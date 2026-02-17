#!python3 -W ignore
# -*- coding: utf-8 -*-

# -- prioritized --
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

# -- stdlib --
from collections import defaultdict
import ast
import importlib.util
import os
import re
import subprocess
import sys
import sysconfig
import warnings

# -- third party --
# -- own --

# -- code --
MAX_LINE_WIDTH = 100

MARKER_PRIORITIZED = '# -- prioritized --'
MARKER_STDLIB = '# -- stdlib --'
MARKER_THIRD_PARTY = '# -- third party --'
MARKER_OWN = '# -- own --'
MARKER_TYPING = '# -- typing --'
MARKER_ERRORD = '# -- errord --'
MARKER_CODE = '# -- code --'

CATEGORY_FUTURE = 'future'
CATEGORY_STDLIB = 'stdlib'
CATEGORY_THIRD_PARTY = 'third_party'
CATEGORY_OWN = 'own'
CATEGORY_TYPING = 'typing'
CATEGORY_ERROR = 'error'

SECTION_ORDER = [
    (MARKER_STDLIB, CATEGORY_STDLIB),
    (MARKER_THIRD_PARTY, CATEGORY_THIRD_PARTY),
    (MARKER_OWN, CATEGORY_OWN),
]


# -- Helpers --

def format_alias(node):
    """Format an ast.alias node as 'name' or 'name as alias'."""
    if node.asname:
        return '%s as %s' % (node.name, node.asname)
    return node.name


def is_import_stmt(stmt):
    """Check if an AST statement is an import or a TYPE_CHECKING guard."""
    if isinstance(stmt, (ast.Import, ast.ImportFrom)):
        return True
    if isinstance(stmt, ast.If):
        return isinstance(stmt.test, ast.Name) and stmt.test.id == 'TYPE_CHECKING'
    return False


def stmt_start_line(stmt):
    """Get the true start line of a statement, accounting for decorators."""
    if isinstance(stmt, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
        if stmt.decorator_list:
            return min(d.lineno for d in stmt.decorator_list)
    return stmt.lineno


def classify_module(name):
    """Classify a module into a category based on its origin."""
    if name.endswith('TT'):
        return CATEGORY_TYPING

    top_level = name.split('.')[0].split(' as ')[0]

    if top_level == '__future__':
        return CATEGORY_FUTURE
    if not top_level:
        return CATEGORY_OWN

    spec = importlib.util.find_spec(top_level)
    if spec is None:
        return CATEGORY_ERROR
    if spec.origin in ('built-in', 'frozen'):
        return CATEGORY_STDLIB

    path = spec.origin
    if path is None:
        if not spec.submodule_search_locations:
            return CATEGORY_ERROR
        path = spec.submodule_search_locations[0]

    if not path:
        return CATEGORY_ERROR

    if '/site-packages/' in path or '/dist-packages/' in path:
        return CATEGORY_THIRD_PARTY
    if path.startswith(os.path.realpath(sysconfig.get_path('stdlib'))):
        return CATEGORY_STDLIB
    if path.startswith(os.getcwd()):
        return CATEGORY_OWN

    return CATEGORY_THIRD_PARTY


# -- Parsing --

def extract_prioritized(src):
    """Extract the prioritized section, returning (prioritized_text, remaining_src).

    If no prioritized markers are found, returns ('', original_src).
    """
    try:
        start = src.index(MARKER_PRIORITIZED + '\n') + len(MARKER_PRIORITIZED) + 1
        end = src.index(MARKER_STDLIB + '\n')
        return src[start:end].strip(), src[end:]
    except ValueError:
        return '', src


def split_imports_and_code(module, src):
    """Partition module body into import statements and verbatim code text."""
    import_stmts = []
    first_code_line = None

    for stmt in module.body:
        if first_code_line is None and is_import_stmt(stmt):
            import_stmts.append(stmt)
        elif first_code_line is None:
            first_code_line = stmt_start_line(stmt)

    code_text = ''
    if first_code_line is not None:
        src_lines = src.split('\n')
        code_text = '\n'.join(src_lines[first_code_line - 1:])

    return import_stmts, code_text


# -- Unused import detection --

def detect_unused_imports(filename):
    """Use flake8 to detect unused imports in the given file."""
    try:
        result = subprocess.run(
            ['flake8', '--format', '%(text)s', filename],
            capture_output=True, text=True, timeout=10,
        )
        if result.stderr:
            return []
        return re.findall(r"'([^']+)' imported but unused", result.stdout)
    except Exception:
        return []


# -- Import collection --

def _collect_from_import(stmt, unused, froms):
    """Process an ImportFrom statement into the froms dict."""
    module_path = '.' * stmt.level + (stmt.module or '')

    if (stmt.module or '').endswith('TT'):
        froms['typing'].append('TYPE_CHECKING')

    for a in stmt.names:
        if '%s.%s' % (module_path, a.name) in unused:
            continue
        froms[module_path].append(format_alias(a))


def _collect_type_checking_block(stmt, froms, plain):
    """Process a TYPE_CHECKING if-block into froms/plain."""
    froms['typing'].append('TYPE_CHECKING')
    for inner in stmt.body:
        if isinstance(inner, ast.Import):
            plain.extend(format_alias(a) + 'TT' for a in inner.names)
        elif isinstance(inner, ast.ImportFrom):
            module_path = '.' * inner.level + (inner.module or '')
            froms[module_path + 'TT'].extend(
                format_alias(a) for a in inner.names
            )


def collect_imports(import_stmts, unused):
    """Walk import AST nodes and collect them.

    Returns (plain_imports, from_imports) where:
      plain_imports: list of alias strings (e.g. 'os', 'sys as system')
      from_imports:  defaultdict(list) mapping module -> [alias_strings]
    """
    froms = defaultdict(list)
    plain = []

    for stmt in import_stmts:
        if isinstance(stmt, ast.Import):
            plain.extend(
                format_alias(a) for a in stmt.names
                if a.name not in unused
            )
        elif isinstance(stmt, ast.ImportFrom):
            _collect_from_import(stmt, unused, froms)
        elif isinstance(stmt, ast.If):
            _collect_type_checking_block(stmt, froms, plain)

    return plain, froms


# -- Formatting --

def wrap_from_import(module_name, aliases):
    """Format 'from X import a, b, c' lines, wrapping at MAX_LINE_WIDTH."""
    header = 'from %s import ' % module_name
    lines = []
    current = []

    for alias in aliases:
        candidate = ', '.join(current + [alias])
        if current and len(header) + len(candidate) > MAX_LINE_WIDTH:
            lines.append(header + ', '.join(current))
            current = [alias]
        else:
            current.append(alias)

    if current:
        lines.append(header + ', '.join(current))

    return lines


def categorize_imports(plain_imports, from_imports):
    """Classify all imports into category buckets of formatted lines."""
    categories = defaultdict(list)

    sorted_froms = sorted(from_imports.items())
    for _, aliases in sorted_froms:
        aliases[:] = sorted(set(aliases))

    for module_name, aliases in sorted_froms:
        category = classify_module(module_name)
        categories[category].extend(wrap_from_import(module_name, aliases))

    for name in sorted(set(plain_imports)):
        category = classify_module(name)
        categories[category].append('import ' + name)

    return categories


# -- Output --

def format_output(categories, prioritized, code_text, has_shebang):
    """Assemble the final formatted output string."""
    lines = []

    if has_shebang:
        lines.append('#!/usr/bin/env python')

    lines.append('# -*- coding: utf-8 -*-')
    future = categories.get(CATEGORY_FUTURE, [])
    if future:
        lines.extend(future)
    lines.append('')

    if prioritized:
        lines.append(MARKER_PRIORITIZED)
        lines.append(prioritized)
        lines.append('')

    for marker, category in SECTION_ORDER:
        lines.append(marker)
        items = categories.get(category, [])
        if items:
            lines.extend(items)
            lines.append('')

    typing_imports = categories.get(CATEGORY_TYPING, [])
    if typing_imports:
        lines.append(MARKER_TYPING)
        lines.append('if TYPE_CHECKING:')
        for imp in typing_imports:
            lines.append('    %s  # noqa: F401' % imp.replace('TT', ''))
        lines.append('')

    errors = categories.get(CATEGORY_ERROR, [])
    if errors:
        lines.append(MARKER_ERRORD)
        lines.extend(errors)
        lines.append('')

    lines.append('')
    lines.append(MARKER_CODE)

    result = '\n'.join(lines)
    if code_text:
        result += '\n' + code_text

    return result


def fallback_sort(src):
    """Last-resort handler for unparseable input: deduplicate and sort lines."""
    return '\n'.join(filter(None, sorted(set(src.split('\n')))))


# -- Entry point --

def main():
    raw_src = sys.stdin.read()
    sys.path.insert(0, os.getcwd())

    has_shebang = raw_src.startswith('#!')

    try:
        ast.parse(raw_src)
    except SyntaxError:
        print(fallback_sort(raw_src))
        return

    prioritized, src = extract_prioritized(raw_src)
    module = ast.parse(src)

    import_stmts, code_text = split_imports_and_code(module, src)

    unused = detect_unused_imports(sys.argv[1]) if len(sys.argv) > 1 else []

    plain_imports, from_imports = collect_imports(import_stmts, unused)
    categories = categorize_imports(plain_imports, from_imports)

    output = format_output(categories, prioritized, code_text, has_shebang)
    sys.stdout.write(output)
    if not output.endswith('\n'):
        sys.stdout.write('\n')


if __name__ == '__main__':
    main()
