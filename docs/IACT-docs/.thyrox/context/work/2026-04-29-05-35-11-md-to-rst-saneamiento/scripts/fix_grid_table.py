#!/usr/bin/env python3
"""Convert malformed grid tables to list-table directives.

Grid tables md->rst con anchos de columna inconsistentes producen
"Malformed table" errors. List-tables son tolerantes a anchos y
mas robustas a edicion posterior.

Detecta bloques que empiezan con linea ruler `+---+...+` (al menos
un `+` y un `-`), parsea filas, y reescribe como:

    .. list-table::
       :header-rows: 1

       * - col1
         - col2
       * - val1
         - val2
"""
import re
import sys
from pathlib import Path

RULER_RE = re.compile(r'^(\s*)\+(?:[-=]+\+)+\s*$')
HEADER_RULER_RE = re.compile(r'^(\s*)\+(?:=+\+)+\s*$')
ROW_RE = re.compile(r'^(\s*)\|.+\|\s*$')


def parse_grid_table(lines, start):
    """Parse a grid table starting at lines[start]. Returns (rows, header_idx, end_idx).

    rows: list of list of cell-strings (multi-line cells joined with newline)
    header_idx: index of last row that is header (None if no header ruler)
    end_idx: index after the last line consumed
    """
    indent = RULER_RE.match(lines[start]).group(1)
    i = start + 1
    rows = []
    cur_row_lines = []  # accumulate row text lines between rulers
    header_idx = None
    n = len(lines)

    while i < n:
        line = lines[i]
        if HEADER_RULER_RE.match(line):
            # Flush current row group to rows, mark as header
            if cur_row_lines:
                rows.append(cur_row_lines)
                header_idx = len(rows) - 1
                cur_row_lines = []
            i += 1
            continue
        if RULER_RE.match(line):
            # Regular ruler: flush row group
            if cur_row_lines:
                rows.append(cur_row_lines)
                cur_row_lines = []
            i += 1
            continue
        if ROW_RE.match(line):
            cur_row_lines.append(line)
            i += 1
            continue
        # End of table
        break

    if cur_row_lines:
        rows.append(cur_row_lines)

    return rows, header_idx, i, indent


def parse_row(row_lines):
    """Parse a multi-line row into list of cells (joined with space).

    Each line: `| cell1 | cell2 | ... |`
    Cells in continuations are stripped and joined with space.
    """
    cells_per_line = []
    for line in row_lines:
        # Strip surrounding pipes and split
        inner = line.strip()
        if inner.startswith('|') and inner.endswith('|'):
            inner = inner[1:-1]
        parts = inner.split('|')
        cells_per_line.append([p.strip() for p in parts])

    if not cells_per_line:
        return []

    n_cols = max(len(r) for r in cells_per_line)
    merged = []
    for col in range(n_cols):
        chunks = []
        for r in cells_per_line:
            if col < len(r) and r[col]:
                chunks.append(r[col])
        merged.append(' '.join(chunks))
    return merged


def emit_list_table(rows, header_idx, indent):
    """Emit list-table RST."""
    out = []
    out.append(indent + '.. list-table::')
    if header_idx is not None and header_idx == 0:
        out.append(indent + '   :header-rows: 1')
    out.append('')
    body_indent = indent + '   '
    for row_lines in rows:
        cells = parse_row(row_lines)
        if not cells:
            continue
        out.append(body_indent + '* - ' + cells[0])
        for cell in cells[1:]:
            out.append(body_indent + '  - ' + cell)
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
            # Try parse table
            rows, header_idx, end_idx, indent = parse_grid_table(lines, i)
            if rows and end_idx > i + 1:
                emitted = emit_list_table(rows, header_idx, indent)
                out.extend(emitted)
                # skip blank lines we may have absorbed
                i = end_idx
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
        print("Usage: fix_grid_table.py <file_or_dir>")
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
