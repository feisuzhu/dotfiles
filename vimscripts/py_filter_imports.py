# -*- coding: utf-8 -*-

import sys
from collections import defaultdict
import ast


src = sys.stdin.read()

MAX_LINE_WIDTH = 100

STDLIBS = (
    'BaseHTTPServer', 'Bastion', 'CGIHTTPServer', 'ConfigParser', 'Cookie', 'DocXMLRPCServer',
    'HTMLParser', 'MimeWriter', 'Queue', 'SimpleHTTPServer', 'SimpleXMLRPCServer', 'SocketServer',
    'StringIO', 'UserDict', 'UserList', 'UserString', 'abc', 'aifc', 'antigravity', 'anydbm',
    'argparse', 'ast', 'asynchat', 'asyncore', 'atexit', 'audiodev', 'base64', 'bdb', 'binhex',
    'bisect', 'bsddb', 'cProfile', 'calendar', 'cgi', 'cgitb', 'chunk', 'cmd', 'code', 'codecs',
    'codeop', 'collections', 'colorsys', 'commands', 'compileall', 'compiler', 'contextlib',
    'cookielib', 'copy', 'copy_reg', 'csv', 'ctypes', 'curses', 'dbhash', 'decimal', 'difflib',
    'dircache', 'dis', 'dist-packages', 'distutils', 'doctest', 'dumbdbm', 'dummy_thread',
    'dummy_threading', 'email', 'encodings', 'filecmp', 'fileinput', 'fnmatch', 'formatter',
    'fpformat', 'fractions', 'ftplib', 'functools', 'genericpath', 'getopt', 'getpass', 'gettext',
    'glob', 'gzip', 'hashlib', 'heapq', 'hmac', 'hotshot', 'htmlentitydefs', 'htmllib', 'httplib',
    'ihooks', 'imaplib', 'imghdr', 'importlib', 'imputil', 'inspect', 'io', 'json', 'keyword',
    'lib-dynload', 'lib-tk', 'lib2to3', 'linecache', 'locale', 'logging', 'macpath', 'macurl2path',
    'mailbox', 'mailcap', 'markupbase', 'md5', 'mhlib', 'mimetools', 'mimetypes', 'mimify',
    'modulefinder', 'multifile', 'multiprocessing', 'mutex', 'netrc', 'new', 'nntplib', 'ntpath',
    'nturl2path', 'numbers', 'opcode', 'optparse', 'os', 'os2emxpath', 'pdb', 'pickle', 'pickletools',
    'pipes', 'pkgutil', 'platform', 'plistlib', 'popen2', 'poplib', 'posixfile', 'posixpath', 'pprint',
    'profile', 'pstats', 'pty', 'py_compile', 'pyclbr', 'pydoc', 'pydoc_data', 'quopri', 'random',
    're', 'repr', 'rexec', 'rfc822', 'rlcompleter', 'robotparser', 'runpy', 'sched', 'sets', 'sgmllib',
    'sha', 'shelve', 'shlex', 'shutil', 'site', 'sitecustomize', 'smtpd', 'smtplib', 'sndhdr',
    'socket', 'sqlite3', 'sre', 'sre_compile', 'sre_constants', 'sre_parse', 'ssl', 'stat', 'statvfs',
    'string', 'stringold', 'stringprep', 'struct', 'subprocess', 'sunau', 'sunaudio', 'symbol',
    'symtable', 'sysconfig', 'tabnanny', 'tarfile', 'telnetlib', 'tempfile', 'test', 'textwrap',
    'this', 'threading', 'timeit', 'toaiff', 'token', 'tokenize', 'trace', 'traceback', 'tty', 'types',
    'unittest', 'urllib', 'urllib2', 'urlparse', 'user', 'uu', 'uuid', 'warnings', 'wave', 'weakref',
    'webbrowser', 'whichdb', 'wsgiref', 'xdrlib', 'xml', 'xmllib', 'xmlrpclib', 'zipfile',
)

THIRD_PARTIES = (
    'M2Crypto',
    'PIL',
    'bottle',
    'colorlog',
    'gevent',
    'msgpack',
    'pygit2',
    'pyglet',
    'redis',
    'requests',
    'simplejson',
    'sqlalchemy',
    'unidecode',
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
    print do_sort(src)
    sys.exit()


if not all(isinstance(s, (ast.Import, ast.ImportFrom)) for s in module.body):
    print do_sort(src)
    sys.exit()

# ----------------------

froms = defaultdict(list)
imports = []

for stmt in module.body:
    if isinstance(stmt, ast.Import):
        imports.extend(stmt.names)
    elif isinstance(stmt, ast.ImportFrom):
        froms[stmt.module].extend(stmt.names)

imports.sort(key=lambda v: v.name)
froms = froms.items()
froms.sort(key=lambda (k, v): k)
for k, v in froms:
    v.sort(key=lambda v: v.name)

# ----------------------

stdlibs = []
third_parties = []
own = []


def where(name):
    name = name.split('.')[0]
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
    while rest:
        commit.append(rest.pop(0))
        s = ', '.join([fmtalias(i) for i in commit])
        if len(header) + len(s) > MAX_LINE_WIDTH or not rest:
            dst.append(header + s)
            commit[:] = []

    assert not rest
    assert not commit

# --------------------------

for a in imports:
    dst = where(a.name)
    # print dst
    dst.append('import ' + fmtalias(a))

print '# -- stdlib --'
if stdlibs:
    print '\n'.join(stdlibs)
    print

print '# -- third party --'
if third_parties:
    print '\n'.join(third_parties)
    print

print '# -- own --'
if own:
    print '\n'.join(own)
    print

print '# -- code --'
