#!/usr/bin/env python3
"""Fix rubric directives that have indented body content.

rubric no acepta body — solo el title inline. El body indentado
genera 'Error in rubric directive'.

Antes:

    .. rubric:: Title

       Body content here       <-- ERROR

Despues:

    .. rubric:: Title

    Body content here          <-- de-indented to match rubric column
"""
import re
import sys
from pathlib import Path

RUBRIC_RE = re.compile(r'^(\s*)\.\. rubric::')


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    n = len(lines)
    i = 0
    changed = False

    while i < n:
        line = lines[i]
        m = RUBRIC_RE.match(line)
        if m:
            di = m.group(1)
            di_len = len(di)
            out.append(line)
            i += 1
            # Skip blank lines
            while i < n and lines[i].strip() == '':
                out.append(lines[i])
                i += 1
            # Dedent indented body lines until we hit something at indent <= di_len
            while i < n:
                cur = lines[i]
                if cur.strip() == '':
                    out.append(cur)
                    i += 1
                    # Peek next non-blank
                    j = i
                    while j < n and lines[j].strip() == '':
                        j += 1
                    if j >= n:
                        break
                    next_indent = re.match(r'^(\s*)', lines[j]).group(1)
                    if len(next_indent) <= di_len:
                        break
                    continue
                cur_indent = re.match(r'^(\s*)', cur).group(1)
                if len(cur_indent) <= di_len:
                    break
                # Dedent: only if more indented than di
                # Replace leading whitespace with di (effectively de-indent to rubric column)
                new_line = di + cur.lstrip()
                if new_line != cur:
                    changed = True
                out.append(new_line)
                i += 1
            continue
        out.append(line)
        i += 1

    if changed:
        path.write_text('\n'.join(out), encoding='utf-8')
        return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: fix_rubric.py <file_or_dir>")
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
