#!/usr/bin/env python3
"""Fix under-indented sub-bullets (off-by-one from md->rst).

Patron especifico:

    - parent
     - sub at indent 1     <-- 1 espacio (parent es indent 0)

Should be:

    - parent
      - sub at indent 2

Heuristica conservadora:
- Solo re-indenta sub-bullet cuando el parent inmediatamente
  anterior (linea no-blanca antes) es un bullet a indent N, y
  el sub esta a indent N+1 (off by exactly one), donde marker
  width = 2 (target N+2).
- Multiple subs consecutivos al mismo indent N+1 se re-indentan
  todos.
- Al ver linea no-bullet a indent <= parent_indent, salimos.
"""
import re
import sys
from pathlib import Path

BULLET_RE = re.compile(r'^(\s*)([-*+])(\s)')
ENUM_RE = re.compile(r'^(\s*)(\d+\.)(\s)')


def get_marker_info(line):
    m = BULLET_RE.match(line)
    if m:
        return len(m.group(1)), 2  # indent, marker+space length
    m = ENUM_RE.match(line)
    if m:
        return len(m.group(1)), len(m.group(2)) + 1
    return None, None


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    n = len(lines)
    i = 0

    # Look for parent bullet patterns
    while i < n:
        line = lines[i]
        out.append(line)
        # Check if this is a parent bullet
        parent_indent, parent_marker_len = get_marker_info(line)
        if parent_indent is None:
            i += 1
            continue
        target_sub_indent = parent_indent + parent_marker_len
        i += 1

        # Look for sub-bullets at off-by-one indent (parent_indent + 1, ..., target_sub_indent - 1)
        # Only apply if first sub is at parent_indent < sub_indent < target_sub_indent
        while i < n:
            sub_line = lines[i]
            if sub_line.strip() == '':
                out.append(sub_line)
                i += 1
                # Don't break — bullets can be separated by blank line and continue
                # But check if next non-blank exits scope
                j = i
                while j < n and lines[j].strip() == '':
                    j += 1
                if j >= n:
                    break
                next_indent_m = re.match(r'^(\s*)', lines[j])
                next_indent = len(next_indent_m.group(1)) if next_indent_m else 0
                if next_indent <= parent_indent:
                    break
                continue

            sub_indent, sub_marker_len = get_marker_info(sub_line)
            if sub_indent is None:
                # non-bullet line: check indent
                cur_indent_m = re.match(r'^(\s*)', sub_line)
                cur_indent = len(cur_indent_m.group(1)) if cur_indent_m else 0
                if cur_indent <= parent_indent:
                    break
                out.append(sub_line)
                i += 1
                continue

            # sub_indent: where is it relative to parent?
            if sub_indent <= parent_indent:
                # Sibling of parent or higher — exit
                break
            if sub_indent < target_sub_indent:
                # Off-by-N sub-bullet: re-indent to target
                rest = sub_line[sub_indent:]
                out.append(' ' * target_sub_indent + rest)
                i += 1
                continue
            # sub_indent >= target — already correct
            out.append(sub_line)
            i += 1

    new_text = '\n'.join(out)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: fix_subbullet_v2.py <file_or_dir>")
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
