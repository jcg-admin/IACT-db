#!/usr/bin/env python3
"""Re-indent contenido perdido de code-block::rst (md->rst).

Pattern: code-block muestra RST de ejemplo, pero el contenido
perdio su +3 indent durante md->rst, asi que docutils procesa
las directivas internas como reales.

Antes:

    <I>.. code-block:: rst

    <I>   **Header**
    <I>
    <I>.. list-table::         <-- WRONG: parsed como directiva
    <I>   :header-rows: 1
    <I>
    <I>  * - col

Despues:

    <I>.. code-block:: rst

    <I>   **Header**
    <I>
    <I>   .. list-table::
    <I>      :header-rows: 1
    <I>
    <I>     * - col

Aplicado solo a code-block:: rst (lenguaje rst). Re-indenta cada
linea del contenido a indent >= I+3, hasta encontrar linea
no-blanca a indent <= I (fin del scope).
"""
import re
import sys
from pathlib import Path

CODEBLOCK_RST_RE = re.compile(r'^(\s*)\.\. code-block::\s+rst\s*$')


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    i = 0
    n = len(lines)
    changed = False

    while i < n:
        line = lines[i]
        m = CODEBLOCK_RST_RE.match(line)
        if m:
            di = m.group(1)
            di_len = len(di)
            min_content_indent = di_len + 3
            out.append(line)
            i += 1

            # Process scope until exit
            while i < n:
                cur = lines[i]
                if cur.strip() == '':
                    out.append(cur)
                    i += 1
                    continue
                cur_indent_m = re.match(r'^(\s*)', cur)
                cur_indent_len = len(cur_indent_m.group(1)) if cur_indent_m else 0

                if cur_indent_len < di_len:
                    # exited scope (strictly less than directive indent)
                    break

                # If line at exactly directive indent: could be sibling OR
                # underindented content. Heuristic: if it looks like a NEW
                # paragraph at the parent's level (e.g. starts with "- " bullet
                # or "**" emphasis), check if there's a same-level sibling
                # bullet/marker pattern. If yes, exit. Otherwise treat as
                # underindented content.
                if cur_indent_len == di_len:
                    stripped = cur.strip()
                    # Heuristic: if it's a list bullet or section heading
                    # at directive_indent and matches sibling-level pattern,
                    # exit. Conservative: only treat as exit if line starts
                    # with `- ` (list bullet at this level — common sibling).
                    if re.match(r'^[-*+]\s', stripped):
                        break

                if cur_indent_len < min_content_indent:
                    # Underindented content — add (min_content_indent - cur_indent_len) spaces
                    delta = min_content_indent - cur_indent_len
                    out.append(' ' * delta + cur)
                    changed = True
                else:
                    # Already correctly indented
                    out.append(cur)
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
        print("Usage: fix_codeblock_rst.py <file_or_dir>")
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
