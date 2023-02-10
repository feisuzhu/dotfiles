#!python3 -W ignore
# -*- coding: utf-8 -*-
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

# -- stdlib --
from collections import defaultdict
import ast
import warnings
import sysconfig

with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    import imp

import os
import subprocess
import sys

# -- third party --
# -- own --

# -- code --
src = sys.stdin.read()
sys.path.insert(0, os.getcwd())

MAX_LINE_WIDTH = 100


def do_sort(src):
    return '\n'.join(filter(None, sorted(set(src.split('\n')))))


def fmtalias(a):
    if a.asname:
        return '%s as %s' % (a.name, a.asname)
    else:
        return a.name

prioritized = ''

try:
    module = ast.parse(src)
    try:
        tok = '# -- prioritized --\n'
        l = src.index(tok) + len(tok)
        tok = '# -- stdlib --\n'
        r = src.index(tok)
        prioritized = src[l:r].strip()
        src = src[r:]
        module = ast.parse(src)
    except IndexError:
        pass
except SyntaxError:
    print(do_sort(src))
    sys.exit()


if not all(isinstance(s, (ast.Import, ast.ImportFrom, ast.If)) for s in module.body):
    print(do_sort(src))
    sys.exit()

# ----------------------
unused = []

if len(sys.argv) > 1:
    try:
        fn = sys.argv[1]
        cmd = '''flake8 --format '%(text)s' ''' + fn + ''' | grep -Po "(?<=')([^)]+)(?=' imported but unused)"'''
        p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        err = p.stderr.read()
        if not err:
            lst = p.stdout.read().decode('utf-8').split()
            unused.extend(lst)
    except Exception:
        pass
    finally:
        p.kill()


froms = defaultdict(list)
imports = []

for stmt in module.body:
    if isinstance(stmt, ast.Import):
        imports.extend([fmtalias(i) for i in stmt.names if i.name not in unused])
    elif isinstance(stmt, ast.ImportFrom):

        lvl = '.' * stmt.level
        mod = stmt.module or ''

        if mod.endswith('TT'):
            froms['typing'].append('TYPE_CHECKING')

        for i in stmt.names:
            ful = lvl + mod
            t = {
                '..actions': 'thb.actions',
                '..cards': 'thb.cards.classes',
                '..inputlets': 'thb.inputlets',
                '.baseclasses': 'thb.characters.base',
            }
            ful = t.get(ful, ful)
            if '%s.%s' % (ful, i.name) in unused:
                continue

            meh = [
                'thb.meta.common.passive_clickable',
                'thb.meta.common.passive_is_action_valid',
                'thb.meta.common.card_desc',
                'thb.meta.common.my_turn',
                'thb.meta.common.build_handcard',
                'thb.meta.common.limit1_skill_used',
                'thb.meta.common.G',
            ]

            if '%s.%s' % (ful, i.name) in meh:
                continue

            if ful == 'game.autoenv' and fmtalias(i) not in ('Game', 'user_input'):
                froms['game.base'].append(fmtalias(i))
            elif ful == 'thb.cards.classes' and fmtalias(i) in ('Card', 'Skill', 'VirtualCard'):
                froms['thb.cards.base'].append(fmtalias(i))
            elif ful == 'game.autoenv':
                if fmtalias(i) in ('user_input',):
                    pass
                else:
                    froms['game.base'].append(fmtalias(i))
            else:
                froms[ful].append(fmtalias(i))

    elif isinstance(stmt, ast.If):
        if isinstance(stmt.test, ast.Name):
            if stmt.test.id == 'TYPE_CHECKING':
                froms['typing'].append('TYPE_CHECKING')
                for stmt in stmt.body:
                    if isinstance(stmt, ast.Import):
                        imports.extend([fmtalias(i) + 'TT' for i in stmt.names])
                    elif isinstance(stmt, ast.ImportFrom):
                        lvl = '.' * stmt.level
                        mod = stmt.module or ''
                        froms[lvl + mod + 'TT'].extend([fmtalias(i) for i in stmt.names])
            else:
                raise Exception("COMPLEX CODE!")
        else:
            raise Exception("COMPLEX CODE!")
    else:
        raise Exception("COMPLEX CODE!")


def _ensure_future(s):
    if s not in froms['__future__']:
        froms['__future__'].append(s)


if sys.version_info.major == 2:
    _ensure_future('absolute_import')
    _ensure_future('division')
    _ensure_future('print_function')
    _ensure_future('unicode_literals')
elif sys.version_info.major == 3:
    pass
    # _ensure_future('annotations')


imports = list(sorted(set(imports)))
froms = list(froms.items())
froms.sort(key=lambda i: i[0])
for k, v in froms:
    v[:] = list(sorted(set(v)))

# ----------------------

future = []
stdlibs = []
third_parties = []
own = []
typing = []
errord = []


def where(name):
    if name.endswith('TT'):
        return typing

    name = name.split('.')[0]
    name = name.split(' as ')[0]
    if name == '__future__':
        return future
    elif not name:  # . and ..
        return own

    try:
        _, path, _ = imp.find_module(name)
    except ImportError:
        return errord

    if path is None:  # `sys` and friends
        return stdlibs

    if '/site-packages/' in path or \
       '/dist-packages/' in path:
        return third_parties
    elif path.startswith(os.path.realpath(sysconfig.get_path('stdlib'))):
        return stdlibs
    elif path.startswith(os.getcwd()):
        return own
    else:
        return third_parties


for name, aliases in froms:
    dst = where(name)
    header = 'from %s import ' % name
    rest = list(aliases)
    commit = []

    def do_commit():
        dst.append(header + ', '.join(commit))
        commit[:] = []

    while rest:
        s = ', '.join(commit + [rest[0]])
        if len(header) + len(s) > MAX_LINE_WIDTH:
            do_commit()
        else:
            commit.append(rest.pop(0))

    commit and do_commit()

    assert not rest
    assert not commit

# --------------------------

for a in imports:
    dst = where(a)
    # print dst
    dst.append('import ' + a)

if src.startswith('#!'):
    print('#!/usr/bin/env python')

print('# -*- coding: utf-8 -*-')
if future:
    print('\n'.join(future))
print()

if prioritized:
    print('# -- prioritized --')
    print(prioritized)
    print()

print('# -- stdlib --')
if stdlibs:
    print('\n'.join(stdlibs))
    print()

print('# -- third party --')
if third_parties:
    print('\n'.join(third_parties))
    print()

print('# -- own --')
if own:
    print('\n'.join(own))
    print()

if typing:
    print('# -- typing --')
    typing = ['    {}  # noqa: F401'.format(i) for i in typing]
    print('if TYPE_CHECKING:')
    print('\n'.join(typing).replace('TT', ''))
    print()

if errord:
    print('# -- errord --')
    print('\n'.join(errord))
    print()

print('\n# -- code --')
