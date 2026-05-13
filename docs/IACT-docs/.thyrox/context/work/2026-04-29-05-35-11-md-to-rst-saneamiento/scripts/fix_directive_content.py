#!/usr/bin/env python3
"""Fix directive content indented at same level as directive.

Pattern md->rst:

    <I>.. code:: bash
    <I>
    <I>black .          <-- WRONG: same indent as directive

Should be:

    <I>.. code:: bash
    <I>
    <I>   black .       <-- 3 spaces deeper

Aplicado a directivas: code, code-block, list-table, note, warning,
tip, important, caution, attention, hint, danger, error, admonition,
seealso, deprecated, versionadded, versionchanged, only, parsed-literal.
"""
import re
import sys
from pathlib import Path

DIRECTIVES = {
    'code', 'code-block', 'list-table', 'note', 'warning', 'tip',
    'important', 'caution', 'attention', 'hint', 'danger', 'error',
    'admonition', 'seealso', 'deprecated', 'versionadded',
    'versionchanged', 'only', 'parsed-literal', 'rubric',
}

DIRECTIVE_RE = re.compile(r'^(\s*)\.\. ([a-zA-Z][a-zA-Z0-9_-]*)::')


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    i = 0
    n = len(lines)

    while i < n:
        line = lines[i]
        m = DIRECTIVE_RE.match(line)
        if m and m.group(2) in DIRECTIVES:
            directive_indent = m.group(1)
            di_len = len(directive_indent)
            target_len = di_len + 3
            out.append(line)
            i += 1

            # Skip option lines (`<directive_indent> :option:`)
            while i < n:
                opt_line = lines[i]
                if opt_line.strip() == '':
                    break
                if re.match(r'^' + re.escape(directive_indent) + r' +:[\w-]+:', opt_line):
                    out.append(opt_line)
                    i += 1
                else:
                    break

            if i >= n:
                break

            # Skip blank line(s) after options
            while i < n and lines[i].strip() == '':
                out.append(lines[i])
                i += 1

            if i >= n:
                break

            # Inspect first content line indent
            first_content = lines[i]
            if first_content.strip() == '':
                continue

            fc_indent = re.match(r'^(\s*)', first_content).group(1)
            fc_len = len(fc_indent)

            # Si content esta a mismo o menor indent que directiva, re-indentar
            if fc_len <= di_len:
                # Re-indentar bloque hasta blank-line + dedent o fin
                while i < n:
                    cur = lines[i]
                    if cur.strip() == '':
                        out.append(cur)
                        i += 1
                        # Si siguiente non-blank tiene indent <= di_len, fin del block
                        j = i
                        while j < n and lines[j].strip() == '':
                            j += 1
                        if j >= n:
                            break
                        next_line = lines[j]
                        next_indent = re.match(r'^(\s*)', next_line).group(1)
                        if len(next_indent) <= di_len:
                            break
                        continue

                    cur_indent = re.match(r'^(\s*)', cur).group(1)
                    if len(cur_indent) < di_len:
                        # dedented out of block
                        break
                    # cur_indent >= di_len → reindent: prefijar 3 espacios
                    if cur_indent.startswith(directive_indent):
                        rest = cur[di_len:]
                        out.append(directive_indent + '   ' + rest)
                    else:
                        out.append(cur)
                    i += 1
                continue
            # else: content already correctly indented, no change
        else:
            out.append(line)
            i += 1

    new_text = '\n'.join(out)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        return True
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: fix_directive_content.py <file_or_dir>")
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
