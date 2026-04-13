#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10,<3.14"
# dependencies = [
#     "i3ipc",
# ]
# ///
"""Swap alacritty's theme based on which i3 output each window lives on.

On HDMI-0 (e-paper): push the light/e-ink theme via `alacritty msg config`.
Anywhere else: `--reset` the window so it falls back to the on-disk config.

Alacritty runs one IPC server per process, with a socket at
`$XDG_RUNTIME_DIR/Alacritty-<DISPLAY>-<PID>.sock`. `alacritty msg` without
`--socket` picks an arbitrary one and will silently succeed on the wrong
process, so every call must target the socket owned by the window's own
process.
"""
from __future__ import annotations

import logging
import os
import shutil
import subprocess
import sys
from pathlib import Path

import i3ipc

LIGHT_OUTPUT = "HDMI-0"
# Theme lives next to this script in the dotfiles repo. `.resolve()` chases the
# symlink in ~/.local/bin/ back to the dotfiles copy.
THEME_FILE = Path(__file__).resolve().parent / "light.toml"
IPC_TIMEOUT = 2.0

UID = os.getuid()
DISPLAY = os.environ.get("DISPLAY") or ":0"
SOCKET_DIR = Path(os.environ.get("XDG_RUNTIME_DIR") or f"/run/user/{UID}")

log = logging.getLogger("alacritty-theme-daemon")

try:
    LIGHT_THEME = THEME_FILE.read_text()
except OSError as e:
    print(f"cannot read {THEME_FILE}: {e}", file=sys.stderr)
    sys.exit(1)

ALACRITTY = shutil.which("alacritty")
if not ALACRITTY:
    print("alacritty not on PATH", file=sys.stderr)
    sys.exit(1)
XPROP = shutil.which("xprop")
if not XPROP:
    print("xprop not on PATH", file=sys.stderr)
    sys.exit(1)

_applied: dict[int, str] = {}
_socket_cache: dict[int, Path] = {}


def output_of(con: i3ipc.Con) -> str | None:
    node = con
    while node is not None:
        if node.type == "output":
            return node.name
        node = node.parent
    return None


def _pid_from_x11(wid: int) -> int | None:
    """i3 doesn't populate con.pid, so read `_NET_WM_PID` straight from X11."""
    try:
        out = subprocess.check_output(
            [XPROP, "-id", str(wid), "_NET_WM_PID"],
            timeout=IPC_TIMEOUT,
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except (subprocess.SubprocessError, OSError):
        return None
    # Format: "_NET_WM_PID(CARDINAL) = 12345"  (or "... :  not found." on missing)
    tail = out.strip().rsplit(" ", 1)[-1]
    try:
        pid = int(tail)
    except ValueError:
        return None
    return pid if pid > 0 else None


def socket_for(wid: int) -> Path | None:
    cached = _socket_cache.get(wid)
    if cached is not None and cached.exists():
        return cached
    pid = _pid_from_x11(wid)
    if pid is None:
        return None
    p = SOCKET_DIR / f"Alacritty-{DISPLAY}-{pid}.sock"
    if not p.exists():
        return None
    _socket_cache[wid] = p
    return p


def _msg(socket: Path, *args: str) -> bool:
    try:
        subprocess.run(
            [ALACRITTY, "msg", "--socket", str(socket), *args],
            check=True,
            timeout=IPC_TIMEOUT,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
        )
        return True
    except subprocess.CalledProcessError as e:
        log.debug("alacritty msg failed: %s", e.stderr.decode(errors="replace").strip())
    except (subprocess.TimeoutExpired, FileNotFoundError) as e:
        log.debug("alacritty msg error: %s", e)
    return False


def apply_light(socket: Path, wid: int) -> None:
    if _applied.get(wid) == "light":
        return
    _msg(socket, "config", "--window-id", str(wid), "--reset")
    if _msg(socket, "config", "--window-id", str(wid), LIGHT_THEME):
        _applied[wid] = "light"
        log.info("light theme applied to window %s", wid)


def apply_default(socket: Path, wid: int) -> None:
    if _applied.get(wid) == "default":
        return
    if _msg(socket, "config", "--window-id", str(wid), "--reset"):
        _applied[wid] = "default"
        log.info("default theme applied to window %s", wid)


def retheme(con: i3ipc.Con) -> None:
    """Apply a theme to ``con``. Requires ``con`` to have a valid parent chain
    (i.e. came from ``i3.get_tree()``, not from an event)."""
    if (con.window_class or "").lower() != "alacritty":
        return
    wid = con.window
    if not wid:
        return
    socket = socket_for(wid)
    if socket is None:
        log.debug("no IPC socket for window %s", wid)
        return
    if output_of(con) == LIGHT_OUTPUT:
        apply_light(socket, wid)
    else:
        apply_default(socket, wid)


def retheme_by_wid(i3: i3ipc.Connection, wid: int) -> None:
    """i3ipc delivers event containers with ``parent=None``, so the output
    walk fails. Re-resolve the container from a fresh tree, which does carry
    parent pointers, then retheme it."""
    if not wid:
        return
    for con in i3.get_tree().leaves():
        if con.window == wid:
            retheme(con)
            return


def on_window(i3: i3ipc.Connection, event: i3ipc.WindowEvent) -> None:
    if event.change == "close":
        wid = event.container.window
        if wid:
            _applied.pop(wid, None)
            _socket_cache.pop(wid, None)
        return
    if event.change in ("new", "move", "focus"):
        retheme_by_wid(i3, event.container.window)


def sweep(i3: i3ipc.Connection) -> None:
    for con in i3.get_tree().leaves():
        retheme(con)


def main() -> int:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
    )
    i3 = i3ipc.Connection()
    i3.on("window", on_window)
    sweep(i3)
    log.info("watching i3 window events (light output = %s)", LIGHT_OUTPUT)
    i3.main()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
