#!/usr/bin/env python3
"""Convert malformed RST simple tables to list-tables (smart 2-col).

Heuristica para 2-column tables: usar el token de col1 del header
para detectar el shape de col1 (1 word, 2 words, **token**).
Luego cada body row se splitea: primer N tokens del mismo shape = col1,
resto = col2.

Para 3+ col tables (raro), usar position-based con fallback whitespace.
"""
import re
import sys
from pathlib import Path

RULER_RE = re.compile(r'^(\s*)((?:=+\s+)+=+)\s*$')


def parse_columns(ruler_text, indent_len):
    cols = []
    i = 0
    n = len(ruler_text)
    while i < n:
        if ruler_text[i] == '=':
            start = i
            while i < n and ruler_text[i] == '=':
                i += 1
            cols.append((start + indent_len, i + indent_len))
        else:
            i += 1
    return cols


def split_2col(line, col1_word_count):
    """Split line into 2 cells using word count for col1."""
    line = line.strip()
    if not line:
        return ['', '']
    parts = line.split(None, col1_word_count)
    if len(parts) <= col1_word_count:
        return [line, '']
    col1 = ' '.join(parts[:col1_word_count])
    col2 = parts[col1_word_count]
    return [col1, col2]


def split_ncol_positional(line, cols):
    """Position-based split for N-col tables."""
    cells = []
    for idx, (s, e) in enumerate(cols):
        if idx == len(cols) - 1:
            cell = line[s:].rstrip() if s < len(line) else ''
        else:
            next_s = cols[idx + 1][0]
            cell = line[s:next_s].rstrip() if s < len(line) else ''
        cells.append(cell.strip())
    return cells


def parse_simple_table(lines, start):
    m = RULER_RE.match(lines[start])
    if not m:
        return None
    indent = m.group(1)
    ruler_text = m.group(2)
    cols = parse_columns(ruler_text, len(indent))
    if len(cols) < 2:
        return None

    n = len(lines)
    i = start + 1

    # Header
    header_lines = []
    while i < n and not RULER_RE.match(lines[i]):
        if lines[i].strip() == '':
            return None
        header_lines.append(lines[i])
        i += 1
    if i >= n:
        return None
    if not RULER_RE.match(lines[i]):
        return None
    i += 1

    # Body
    body_lines = []
    while i < n:
        if RULER_RE.match(lines[i]):
            i += 1
            break
        if lines[i].strip() == '':
            break
        body_lines.append(lines[i])
        i += 1

    return {
        'indent': indent,
        'cols': cols,
        'header_lines': header_lines,
        'body_lines': body_lines,
        'end_idx': i,
    }


def detect_col1_word_count(header_text, n_cols):
    """For 2-col table, header has 2 tokens: count words of col1."""
    parts = header_text.strip().split()
    # Heuristic: if header has same word count as n_cols, col1 = 1 word
    if len(parts) == n_cols:
        return 1
    # If header has more words, assume col1 = first half... fallback to 1
    return 1


def emit_list_table(parsed):
    indent = parsed['indent']
    cols = parsed['cols']
    n_cols = len(cols)
    out = [indent + '.. list-table::',
           indent + '   :header-rows: 1',
           '']
    body_indent = indent + '   '

    def emit_cells(cells):
        if not cells or all(not c for c in cells):
            return
        out.append(body_indent + '* - ' + (cells[0] or '\\ '))
        for c in cells[1:]:
            out.append(body_indent + '  - ' + (c or '\\ '))

    # Header
    header_text = ' '.join(l.strip() for l in parsed['header_lines'])
    if n_cols == 2:
        col1_words = detect_col1_word_count(header_text, n_cols)
        header_cells = split_2col(header_text, col1_words)
        emit_cells(header_cells)
        for line in parsed['body_lines']:
            cells = split_2col(line, col1_words)
            emit_cells(cells)
    else:
        # N-col positional
        for hl in parsed['header_lines']:
            emit_cells(split_ncol_positional(hl, cols))
        for line in parsed['body_lines']:
            emit_cells(split_ncol_positional(line, cols))
    return out


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    i = 0
    n = len(lines)
    changed = False

    while i < n:
        line = lines[i]
        if RULER_RE.match(line):
            parsed = parse_simple_table(lines, i)
            if parsed and parsed['body_lines']:
                emitted = emit_list_table(parsed)
                out.extend(emitted)
                i = parsed['end_idx']
                changed = True
                continue
        out.append(line)
        i += 1

    if changed:
        path.write_text('\n'.join(out), encoding='utf-8')
        return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: fix_simple_table_v2.py <file_or_dir>")
        sys.exit(2)
    targets = []
    for arg in sys.argv[1:]:
        p = Path(arg)
        if p.is_file():
            targets.append(p)
        elif p.is_dir():
            targets.extend(p.rglob('*.rst'))
    fixed = 0
    for f in targets:
        if fix_file(f):
            fixed += 1
            print(f"  fixed: {f}")
    print(f"\nTotal: {fixed} files modified")


if __name__ == '__main__':
    main()
