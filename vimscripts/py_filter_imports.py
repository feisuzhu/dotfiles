#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import, division, print_function, unicode_literals

# -- stdlib --
from collections import defaultdict
import ast
import imp
import os
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


try:
    module = ast.parse(src)
except SyntaxError:
    print(do_sort(src))
    sys.exit()


if not all(isinstance(s, (ast.Import, ast.ImportFrom)) for s in module.body):
    print(do_sort(src))
    sys.exit()

# ----------------------

froms = defaultdict(list)
imports = []

for stmt in module.body:
    if isinstance(stmt, ast.Import):
        imports.extend([fmtalias(i) for i in stmt.names])
    elif isinstance(stmt, ast.ImportFrom):
        lvl = '.' * stmt.level
        mod = stmt.module or ''
        froms[lvl + mod].extend([fmtalias(i) for i in stmt.names])


if sys.version_info.major == 2:
    def _ensure_future(s):
        if s not in froms['__future__']:
            froms['__future__'].append(s)

    _ensure_future('absolute_import')
    _ensure_future('division')
    _ensure_future('print_function')
    _ensure_future('unicode_literals')


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
errord = []


def where(name):
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

    if '/site-packages/' in path or\
       '/dist-packages/' in path:
        return third_parties
    elif path.startswith(os.getcwd()):
        return own
    else:
        return stdlibs


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

if errord:
    print('# -- errord --')
    print('\n'.join(errord))
    print()

print('\n# -- code --')
