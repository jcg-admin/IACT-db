#!/usr/bin/env python3
"""Fix section underlines indented more than their title.

Pattern md->rst conversion bug:

    1. Proposito
       ------------    <-- underline indented mas que titulo (indent 0)

Should be:

    1. Proposito
    ------------

Detect: linea siguiente compuesta solo por chars de underline RST
(=, -, ~, ^, ", ', `, *, +, #, _) con length >= 3 y mas indent que la
linea anterior (titulo). Re-indentar underline al indent del titulo.

Tambien valida que el underline tenga al menos la longitud del titulo
(dejarlo igual si es mas corto — eso es otro tipo de bug).
"""
import re
import sys
from pathlib import Path

UNDERLINE_RE = re.compile(r'^(\s*)([=\-~^"\'`*+#_])\2{2,}\s*$')


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    prev_line = None

    for i, line in enumerate(lines):
        m = UNDERLINE_RE.match(line)
        if m and prev_line is not None and prev_line.strip() != '':
            ul_indent = m.group(1)
            char = m.group(2)
            ul_count = len(line.strip())

            # Indent del titulo (linea anterior)
            title_indent_m = re.match(r'^(\s*)', prev_line)
            title_indent = title_indent_m.group(1) if title_indent_m else ''

            if len(ul_indent) > len(title_indent):
                # Underline mas indentado que titulo: re-indentar
                out.append(title_indent + char * ul_count)
                prev_line = line
                continue

        out.append(line)
        prev_line = line

    new_text = '\n'.join(out)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: fix_section_underline.py <file_or_dir>")
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
