#!/usr/bin/env python3
"""fix-broken-refs.py — post-hoc fixer for toctree/:doc: entries broken by rename.

Walks all .rst files. For each toctree entry and :doc: ref, checks if the
target document exists. If not, transforms the basename to kebab-lowercase
and checks if THAT exists. If yes, replaces.

Idempotente: corre múltiples veces sin daño.
"""
from __future__ import annotations
import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[6]
SOURCE = REPO_ROOT / "source"

DOC_REF_RE = re.compile(r":doc:`([^`<>]*?<)?([^`<>]+?)(>?)`")


def kebab(s: str) -> str:
    s = s.lower().replace("_", "-").replace(".", "-")
    s = re.sub(r"-+", "-", s)
    return s.strip("-")


def transform_path(path: str) -> str:
    """Transforma un path completo: lowercase + _ → - en cada segmento.

    Preserva index, prefix _ Sphinx no aplicable acá (paths internos).
    """
    parts = path.split("/")
    out = []
    for p in parts:
        if not p:
            out.append(p)
            continue
        # Preservar prefijo _ pero kebabizar el resto
        if p.startswith("_"):
            out.append("_" + kebab(p[1:]))
        elif p == "index":
            out.append(p)
        else:
            out.append(kebab(p))
    return "/".join(out)


def doc_exists(rel_path: str, file_dir: str) -> bool:
    """Verifica si rel_path (sin .rst) existe como documento."""
    if rel_path.startswith("/"):
        full = SOURCE / rel_path.lstrip("/")
    else:
        full = SOURCE / file_dir / rel_path
    return (full.with_suffix(".rst")).exists()


def try_fix(path: str, file_dir: str) -> str | None:
    """Si path está roto, intenta versión kebab. Retorna nuevo path o None."""
    if doc_exists(path, file_dir):
        return None  # already fine
    # Try kebab transformation
    abs_marker = path.startswith("/")
    norm = path.lstrip("/")
    new_norm = transform_path(norm)
    new_path = ("/" if abs_marker else "") + new_norm
    if new_path != path and doc_exists(new_path, file_dir):
        return new_path
    return None


def fix_text(text: str, file_dir: str) -> tuple[str, int]:
    changes = 0

    # Fix :doc: refs
    def repl_doc(match):
        nonlocal changes
        title = match.group(1) or ""
        path = match.group(2)
        closer = match.group(3) or ""
        new_path = try_fix(path, file_dir)
        if new_path is None:
            return match.group(0)
        changes += 1
        return ":doc:`" + title + new_path + closer + "`"

    text = DOC_REF_RE.sub(repl_doc, text)

    # Fix toctree entries
    lines = text.split("\n")
    out = []
    in_toctree = False
    toctree_indent = ""

    for raw in lines:
        stripped_left = raw.lstrip()
        if stripped_left.startswith(".. toctree::"):
            in_toctree = True
            toctree_indent = raw[: len(raw) - len(stripped_left)]
            out.append(raw)
            continue

        if in_toctree:
            if raw.strip() == "":
                out.append(raw)
                continue
            current_indent = raw[: len(raw) - len(stripped_left)]
            if len(current_indent) <= len(toctree_indent):
                in_toctree = False
                out.append(raw)
                continue
            if stripped_left.startswith(":"):
                out.append(raw)
                continue

            content = stripped_left
            m = re.match(r"^(.*?<)([^>]+)(>.*)$", content)
            if m:
                prefix, path, suffix = m.group(1), m.group(2), m.group(3)
            else:
                prefix, path, suffix = "", content.rstrip(), ""

            new_path = try_fix(path, file_dir)
            if new_path is not None:
                changes += 1
                out.append(current_indent + prefix + new_path + suffix)
            else:
                out.append(raw)
            continue

        out.append(raw)

    return "\n".join(out), changes


def main():
    total_files = 0
    total_changes = 0
    for rst in SOURCE.rglob("*.rst"):
        text = rst.read_text()
        file_dir = str(rst.parent.relative_to(SOURCE)).replace(os.sep, "/")
        if file_dir == ".":
            file_dir = ""
        new_text, changes = fix_text(text, file_dir)
        if changes > 0:
            rst.write_text(new_text)
            total_files += 1
            total_changes += changes
            print(f"  {rst.relative_to(REPO_ROOT)}: {changes} ref(s)")
    print(f"\n==> {total_files} archivos modificados, {total_changes} refs corregidas")


if __name__ == "__main__":
    main()
