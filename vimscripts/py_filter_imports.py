#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import, division, print_function, unicode_literals

# -- stdlib --
from collections import defaultdict
import ast
import sys

# -- third party --
# -- own --

# -- code --
src = sys.stdin.read()

MAX_LINE_WIDTH = 100

STDLIBS = (
    'BaseHTTPServer', 'Bastion', 'CGIHTTPServer', 'ConfigParser', 'Cookie', 'DocXMLRPCServer',
    'HTMLParser', 'MimeWriter', 'Queue', 'SimpleHTTPServer', 'SimpleXMLRPCServer', 'SocketServer',
    'StringIO', 'UserDict', 'UserList', 'UserString', 'abc', 'aifc', 'antigravity', 'anydbm', 'argparse',
    'ast', 'asynchat', 'asyncore', 'atexit', 'audiodev', 'base64', 'bdb', 'binascii', 'binhex', 'bisect',
    'bsddb', 'cPickle', 'cProfile', 'cStringIO', 'calendar', 'cgi', 'cgitb', 'chunk', 'cmd', 'code',
    'codecs', 'codeop', 'collections', 'colorsys', 'commands', 'compileall', 'compiler', 'contextlib',
    'cookielib', 'copy', 'copy_reg', 'csv', 'ctypes', 'curses', 'dbhash', 'decimal', 'difflib', 'dircache',
    'dis', 'dist-packages', 'distutils', 'doctest', 'dumbdbm', 'dummy_thread', 'dummy_threading', 'email',
    'encodings', 'errno', 'exceptions', 'fcntl', 'filecmp', 'fileinput', 'fnmatch', 'formatter', 'fpformat',
    'fractions', 'ftplib', 'functools', 'gc', 'genericpath', 'getopt', 'getpass', 'gettext', 'glob', 'grp',
    'gzip', 'hashlib', 'heapq', 'hmac', 'hotshot', 'htmlentitydefs', 'htmllib', 'httplib', 'ihooks',
    'imaplib', 'imghdr', 'imp', 'importlib', 'imputil', 'inspect', 'io', 'itertools', 'json', 'keyword',
    'lib-dynload', 'lib-tk', 'lib2to3', 'linecache', 'locale', 'logging', 'macpath', 'macurl2path',
    'mailbox', 'mailcap', 'markupbase', 'marshal', 'math', 'math', 'md5', 'mhlib', 'mimetools', 'mimetypes',
    'mimify', 'modulefinder', 'mpl_toolkits', 'multifile', 'multiprocessing', 'mutex', 'netrc', 'new',
    'nntplib', 'ntpath', 'nturl2path', 'numbers', 'opcode', 'operator', 'optparse', 'os', 'os2emxpath',
    'pdb', 'pickle', 'pickletools', 'pipes', 'pkgutil', 'platform', 'plistlib', 'popen2', 'poplib',
    'posix', 'posixfile', 'posixpath', 'pprint', 'profile', 'pstats', 'pty', 'pwd', 'py_compile', 'pyclbr',
    'pydoc', 'pydoc_data', 'quopri', 'random', 're', 'repr', 'rexec', 'rfc822', 'rlcompleter', 'robotparser',
    'runpy', 'sched', 'select', 'sets', 'sgmllib', 'sha', 'shelve', 'shlex', 'shutil', 'signal', 'site',
    'sitecustomize', 'smtpd', 'smtplib', 'sndhdr', 'socket', 'sqlite3', 'sre', 'sre_compile', 'sre_constants',
    'sre_parse', 'ssl', 'stat', 'statvfs', 'string', 'stringold', 'stringprep', 'strop', 'struct',
    'subprocess', 'sunau', 'sunaudio', 'symbol', 'symtable', 'sys', 'sysconfig', 'tabnanny', 'tarfile',
    'telnetlib', 'tempfile', 'test', 'textwrap', 'this', 'thread', 'threading', 'time', 'time', 'timeit',
    'toaiff', 'token', 'tokenize', 'trace', 'traceback', 'tty', 'types', 'unittest', 'urllib', 'urllib2',
    'urlparse', 'user', 'uu', 'uuid', 'warnings', 'wave', 'weakref', 'webbrowser', 'whichdb', 'wsgiref',
    'xdrlib', 'xml', 'xmllib', 'xmlrpclib', 'zipfile', 'zipimport', 'zlib',
    'datetime',
)

THIRD_PARTIES = (
    'Crypto',
    'IPython',
    'M2Crypto',
    'PIL',
    'alembic',
    'amqp',
    'anyjson',
    'arrow',
    'babel',
    'bcrypt',
    'beaker',
    'beanstalkc',
    'bidict',
    'billiard',
    'bitcoinrpc',
    'bottle',
    'buildout',
    'captchaimage',
    'cdecimal',
    'celery',
    'click',
    'collective',
    'colorlog',
    'coverage',
    'cryptography',
    'dateutil',
    'docutils',
    'easy_install',
    'ecdsa',
    'flask',
    'flask_admin',
    'flask_babel',
    'flask_migrate',
    'flask_redis',
    'flask_script',
    'flask_sqlalchemy',
    'flask_wtf',
    'flower',
    'funtests',
    'gevent',
    'greenlet',
    'greenlet.so',
    'itsdangerous',
    'jinja2',
    'jquery_unparam',
    'kafka',
    'kombu',
    'leancloud',
    'lxml',
    'magic',
    'mako',
    'markupsafe',
    'moment',
    'msgpack',
    'nose',
    'passlib',
    'plone',
    'progressbar',
    'psycopg2',
    'pygit2',
    'pyglet',
    'pygments',
    'pymysql',
    'pytz',
    'raven',
    'recipe',
    'redis',
    'requests',
    'scrapy',
    'selenium',
    'setuptools',
    'sh',
    'simpleflake',
    'simplejson',
    'speaklater',
    'sphinx',
    'spidermonkey',
    'sqlalchemy',
    'termcolor',
    'tests',
    'times',
    'tornado',
    'ujson',
    'underscore',
    'unidecode',
    'websocket',
    'werkzeug',
    'wtforms',
    'xml4h',
    'yaml',
    'yoyo',
    'zc',
)


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


# ----- Good habit! -----
def _ensure_future(s):
    if s not in froms['__future__']:
        froms['__future__'].append(s)


_ensure_future('absolute_import')
_ensure_future('division')
_ensure_future('print_function')
_ensure_future('unicode_literals')
# -----------------------

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


def where(name):
    name = name.split('.')[0]
    if name == '__future__':
        return future
    if name in STDLIBS:
        return stdlibs
    elif name in THIRD_PARTIES:
        return third_parties
    else:
        return own


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

print('\n# -- code --')
