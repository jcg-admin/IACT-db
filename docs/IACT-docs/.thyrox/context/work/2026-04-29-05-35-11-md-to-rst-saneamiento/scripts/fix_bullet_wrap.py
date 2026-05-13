#!/usr/bin/env python3
"""Fix bullet text continuations from md->rst conversion (hybrid heuristic).

Pattern md->rst:

    - texto
    continuacion        <-- WRONG (mismo indent que `-`)

Should be:

    - texto
      continuacion      <-- aligned with text after `-`

Heuristica hibrida:
- Si YA estamos en un bullet (in_bullet=True), confiar en el regex:
  un nuevo `<I>- ...` al mismo indent o sub-indent es bullet real.
- Si NO estamos en bullet, exigir contexto valido (linea anterior
  blanca, header, directive, o bullet anterior).

Esto evita falsos positivos por texto inline tipo "- UC-001" en
medio de un parrafo, pero respeta listas verdaderas con
continuaciones que envuelven multiples lineas.
"""
import re
import sys
from pathlib import Path

BULLET_RE = re.compile(r'^(\s*)([-*+])\s')
ENUM_RE = re.compile(r'^(\s*)(\d+\.)\s')
DIRECTIVE_RE = re.compile(r'^\s*\.\.\s+\w')
HEADER_UNDERLINE_RE = re.compile(r'^[=\-~^"\'`*+#]{3,}\s*$')


def is_valid_bullet_start(prev_line: str | None, cur_indent_len: int) -> bool:
    """Cuando NO estamos en bullet: ¿la linea anterior justifica abrir lista?"""
    if prev_line is None:
        return True
    if prev_line.strip() == '':
        return True
    if DIRECTIVE_RE.match(prev_line):
        return True
    if HEADER_UNDERLINE_RE.match(prev_line):
        return True
    # Bullet anterior al mismo indent o menor
    m = BULLET_RE.match(prev_line)
    if m and len(m.group(1)) <= cur_indent_len:
        return True
    m = ENUM_RE.match(prev_line)
    if m and len(m.group(1)) <= cur_indent_len:
        return True
    return False


def fix_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    out = []
    in_bullet = False
    bullet_indent = ''
    target_indent_len = 0
    prev_line = None

    for line in lines:
        if line.strip() == '':
            in_bullet = False
            out.append(line)
            prev_line = line
            continue

        m_b = BULLET_RE.match(line)
        m_e = ENUM_RE.match(line)

        if m_b or m_e:
            cur_indent = (m_b or m_e).group(1)
            cur_len = len(cur_indent)

            # Determinar si es bullet real
            is_real = False
            if in_bullet:
                # Ya en lista: aceptar mismo indent o sub-indent
                if cur_len >= len(bullet_indent):
                    is_real = True
            else:
                is_real = is_valid_bullet_start(prev_line, cur_len)

            if is_real:
                bullet_indent = cur_indent
                if m_b:
                    target_indent_len = len(bullet_indent) + 2
                else:
                    target_indent_len = len(bullet_indent) + len(m_e.group(2)) + 1
                in_bullet = True
                out.append(line)
                prev_line = line
                continue

            # No es bullet real (texto inline tipo "- UC-001 ...")
            # Si estabamos en bullet, podria ser continuacion rota
            if in_bullet:
                bi_len = len(bullet_indent)
                if cur_indent.startswith(bullet_indent) and bi_len <= cur_len < target_indent_len:
                    rest = line[cur_len:]
                    out.append(' ' * target_indent_len + rest)
                    prev_line = line
                    continue
            out.append(line)
            prev_line = line
            continue

        # Linea sin marker bullet
        if in_bullet:
            cur_indent = re.match(r'^(\s*)', line).group(1)
            cur_len = len(cur_indent)
            bi_len = len(bullet_indent)

            if cur_len < bi_len or not cur_indent.startswith(bullet_indent):
                in_bullet = False
                out.append(line)
                prev_line = line
                continue

            rest_after_indent = line[cur_len:]
            if rest_after_indent.startswith('..'):
                in_bullet = False
                out.append(line)
                prev_line = line
                continue

            if bi_len <= cur_len < target_indent_len:
                out.append(' ' * target_indent_len + rest_after_indent)
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
        print("Usage: fix_bullet_wrap.py <file_or_dir> [...]")
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
