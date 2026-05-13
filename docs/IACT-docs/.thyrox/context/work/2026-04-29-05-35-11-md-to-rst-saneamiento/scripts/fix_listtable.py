#!/usr/bin/env python3
"""Fix list-table column continuations + text continuations in RST files.

Pattern md->rst conversion roto:

    .. list-table::
     :widths: ...

     * - col1
     - col2 first line
     col2 second line       <-- text continuation
     * - row2 ...

Should be:

     * - col1
       - col2 first line
         col2 second line
     * - row2 ...

Reglas:
- Column continuation `<RI>- Y` (mismo indent que `*`) → `<RI>  - Y` (+2 espacios)
- Text continuation `<RI>Z` (linea texto al mismo indent que `*`) → `<RI>    Z` (+4 espacios)

Solo aplica si la primera continuacion vista es del tipo broken (`<RI>- Y`).
Si la tabla ya esta bien formada (`<RI>  - Y`), no se toca.
"""
import re
import sys
from pathlib import Path

LISTTABLE_RE = re.compile(r'^(\s*)\.\. list-table::')
ROW_RE = re.compile(r'^(\s*)\* - ')


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    in_table = False
    table_indent = ''
    row_indent = None
    fixing = None  # None=unknown, True=table is broken (apply fix), False=table OK (skip)

    for line in lines:
        if not in_table:
            m = LISTTABLE_RE.match(line)
            if m:
                in_table = True
                table_indent = m.group(1)
                row_indent = None
                fixing = None
            out.append(line)
            continue

        # in_table
        stripped = line.strip()
        if stripped == '':
            out.append(line)
            continue

        cur_indent = re.match(r'^(\s*)', line).group(1)
        if len(cur_indent) <= len(table_indent):
            in_table = False
            row_indent = None
            fixing = None
            out.append(line)
            continue

        # row starter
        m_row = ROW_RE.match(line)
        if m_row:
            row_indent = m_row.group(1)
            out.append(line)
            continue

        if row_indent is not None:
            broken_prefix = row_indent + '- '
            correct_prefix = row_indent + '  - '

            # Column continuation: starts with `<RI>- ` but NOT `<RI>  - `
            if line.startswith(broken_prefix) and not line.startswith(correct_prefix):
                fixing = True
                rest = line[len(broken_prefix):]
                out.append(row_indent + '  - ' + rest)
                continue

            # Already-correct column continuation
            if line.startswith(correct_prefix):
                if fixing is None:
                    fixing = False
                out.append(line)
                continue

            # Text continuation
            if fixing is True:
                # If line starts at exactly row_indent (no extra spaces), add 4
                if line.startswith(row_indent) and not line.startswith(row_indent + ' '):
                    rest = line[len(row_indent):]
                    out.append(row_indent + '    ' + rest)
                    continue

        out.append(line)

    new_text = '\n'.join(out)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: fix_listtable.py <file_or_dir> [...]")
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
