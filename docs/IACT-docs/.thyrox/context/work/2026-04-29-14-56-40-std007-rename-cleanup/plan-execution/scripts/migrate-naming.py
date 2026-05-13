#!/usr/bin/env python3
"""migrate-naming.py — STD_007 v2.0.0 universal kebab migration.

Idempotente: corre múltiples veces sin daño.

Uso:
    python migrate-naming.py --dry-run                  # preview completo
    python migrate-naming.py --dry-run --by-category    # agrupado por prefijo
    python migrate-naming.py --pilot <abs-or-rel-path>  # un solo archivo
    python migrate-naming.py --execute                  # aplicar (renames + refs)

Diseño:
    1. Recolecta renames: archivos y directorios que violan v2.0.0.
    2. Renombra archivos vía `git mv` (preserva historial).
    3. Renombra directorios bottom-up vía `git mv`.
    4. Actualiza :doc: y toctree entries en TODO el corpus .rst.

Excepciones (no renombradas):
    - index.rst
    - Directorios con prefijo `_` (Sphinx convention) — el prefijo se
      preserva, el resto se transforma a kebab.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[6]
SOURCE = REPO_ROOT / "source"

PRESERVED_FILE_NAMES = {"index.rst"}


def transform_stem(stem: str) -> str:
    """Transforma stem (sin extensión) a kebab-lowercase."""
    new = stem.lower().replace("_", "-").replace(".", "-")
    new = re.sub(r"-+", "-", new)
    return new.strip("-")


def transform_filename(name: str) -> str:
    if name in PRESERVED_FILE_NAMES:
        return name
    if "." in name:
        stem, ext = name.rsplit(".", 1)
        return transform_stem(stem) + "." + ext
    return transform_stem(name)


def transform_dirname(name: str) -> str:
    if name.startswith("_"):
        return "_" + transform_stem(name[1:])
    return transform_stem(name)


def collect_file_renames():
    out = []
    for dirpath, _, filenames in os.walk(SOURCE):
        for fname in filenames:
            if not fname.endswith((".rst", ".puml")):
                continue
            new = transform_filename(fname)
            if new != fname:
                out.append((Path(dirpath) / fname, Path(dirpath) / new))
    return out


def collect_dir_renames():
    out = []
    for dirpath, dirnames, _ in os.walk(SOURCE):
        for d in dirnames:
            new = transform_dirname(d)
            if new != d:
                out.append((Path(dirpath) / d, Path(dirpath) / new))
    out.sort(key=lambda x: len(x[0].parts), reverse=True)
    return out


def categorize(name: str) -> str:
    """Clasifica el nombre por prefijo para agrupación."""
    upper = name.upper()
    for pref in ["UC_", "BR_", "BREQ_", "CNST_", "META_", "FND_", "SBVR_",
                 "MTM_", "TXM_", "GOB_", "STD_", "TPL_", "ADR-", "PROCED-",
                 "PROC-", "RNF-", "FR-"]:
        if upper.startswith(pref):
            return pref.rstrip("_-")
    return "(sin-prefijo)"


def build_doc_path_map(file_renames, dir_renames):
    """Mapping de paths relativos (sin .rst) viejos → nuevos.

    Para :doc: y toctree, las rutas son relativas a SOURCE y sin .rst.
    """
    mapping = {}
    # Build composite mapping: si un dir cambió, todos sus paths internos
    # quedan reflejados al renombrar primero los archivos y luego dirs.
    # Pero aquí construimos el mapping de paths FINALES.
    # Estrategia: simular renames secuencialmente.

    # Paso 1: archivos
    for old, new in file_renames:
        old_rel = old.relative_to(SOURCE).with_suffix("")
        new_rel = new.relative_to(SOURCE).with_suffix("")
        mapping[str(old_rel).replace(os.sep, "/")] = str(new_rel).replace(os.sep, "/")

    return mapping


def build_dir_segment_map(dir_renames):
    """Mapping de (path_dir_viejo) → (path_dir_nuevo) en formato POSIX."""
    out = {}
    for old, new in dir_renames:
        old_rel = old.relative_to(SOURCE)
        new_rel = new.relative_to(SOURCE)
        out[str(old_rel).replace(os.sep, "/")] = str(new_rel).replace(os.sep, "/")
    return out


# Refs target patterns
DOC_REF_RE = re.compile(r":doc:`([^`<>]*?<)?([^`<>]+?)(>?)`")


def resolve_ref(path, file_dir, file_map, dir_map):
    """Resuelve un path (absoluto o relativo) y devuelve su nuevo valor.

    file_dir: dir relativo a SOURCE del archivo que contiene la ref.
    Devuelve None si no hay match en ningún mapping.
    """
    cleaned = path.strip()
    if not cleaned:
        return None
    abs_marker = cleaned.startswith("/")
    norm = cleaned.lstrip("/")

    # Construir candidato: si es relativo, prepend file_dir
    if abs_marker:
        candidate = norm
    else:
        candidate = (Path(file_dir) / norm).as_posix() if file_dir else norm

    # File mappings (más específico)
    file_items = sorted(file_map.items(), key=lambda x: -len(x[0]))
    for old, new in file_items:
        if candidate == old:
            if abs_marker:
                return "/" + new
            # Re-relativizar respecto a file_dir
            if file_dir:
                rel = os.path.relpath(new, file_dir).replace(os.sep, "/")
                return rel
            return new

    # Dir mappings (prefijos de path)
    dir_items = sorted(dir_map.items(), key=lambda x: -len(x[0]))
    for old, new in dir_items:
        if candidate == old or candidate.startswith(old + "/"):
            replaced = candidate.replace(old, new, 1)
            if abs_marker:
                return "/" + replaced
            if file_dir:
                rel = os.path.relpath(replaced, file_dir).replace(os.sep, "/")
                return rel
            return replaced

    return None


def update_refs_in_text(text, file_dir, file_map, dir_map):
    """Actualiza :doc: refs y toctree entries.

    file_dir: dir relativo a SOURCE del archivo que se procesa.
    """
    new_text = text

    def repl_doc(match):
        title = match.group(1) or ""
        path = match.group(2)
        closer = match.group(3) or ""
        new_path = resolve_ref(path, file_dir, file_map, dir_map)
        if new_path is None:
            return match.group(0)
        return ":doc:`" + title + new_path + closer + "`"

    new_text = DOC_REF_RE.sub(repl_doc, new_text)
    new_text = update_toctree_entries(new_text, file_dir, file_map, dir_map)
    return new_text


def update_toctree_entries(text, file_dir, file_map, dir_map):
    """Actualiza líneas de toctree replazando paths conocidos."""
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

            new_path = resolve_ref(path, file_dir, file_map, dir_map)
            final_path = new_path if new_path is not None else path
            out.append(current_indent + prefix + final_path + suffix)
            continue

        out.append(raw)

    return "\n".join(out)


def git_mv(src: Path, dst: Path):
    subprocess.run(
        ["git", "mv", str(src), str(dst)],
        check=True,
        cwd=REPO_ROOT,
    )


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--by-category", action="store_true")
    ap.add_argument("--pilot", help="Renombrar solo este path (relativo a source/)")
    ap.add_argument("--domain", help="Limitar renames a paths bajo este prefijo (ej. source/normativa/estandares)")
    ap.add_argument("--execute", action="store_true")
    args = ap.parse_args()

    if not (args.dry_run or args.execute or args.pilot):
        ap.error("Use --dry-run, --pilot, o --execute.")

    file_renames = collect_file_renames()
    dir_renames = collect_dir_renames()

    if args.pilot:
        target = (REPO_ROOT / args.pilot).resolve()
        file_renames = [(o, n) for o, n in file_renames if o.resolve() == target]
        dir_renames = []
        if not file_renames:
            print(f"PILOT: {target} no requiere rename o no existe.")
            return

    if args.domain:
        prefix = (REPO_ROOT / args.domain).resolve()
        prefix_str = str(prefix)
        file_renames = [
            (o, n) for o, n in file_renames
            if str(o.resolve()).startswith(prefix_str)
        ]
        dir_renames = [
            (o, n) for o, n in dir_renames
            if str(o.resolve()).startswith(prefix_str)
        ]
        print(f"--domain={args.domain}: {len(file_renames)} archivos, {len(dir_renames)} dirs")

    # Maps
    file_map = build_doc_path_map(file_renames, dir_renames)
    dir_map = build_dir_segment_map(dir_renames)

    print(f"==> {len(file_renames)} archivos a renombrar")
    print(f"==> {len(dir_renames)} directorios a renombrar")

    if args.by_category:
        cat_counts = defaultdict(int)
        for old, _ in file_renames:
            cat_counts[categorize(old.name)] += 1
        print("\nPor categoría:")
        for cat, n in sorted(cat_counts.items(), key=lambda x: -x[1]):
            print(f"  {cat:12s} {n:4d}")

    if args.dry_run:
        print("\n=== ARCHIVOS (primeros 30) ===")
        for old, new in file_renames[:30]:
            print(f"  {old.relative_to(REPO_ROOT)} -> {new.name}")
        if len(file_renames) > 30:
            print(f"  ... y {len(file_renames) - 30} más")

        print("\n=== DIRECTORIOS ===")
        for old, new in dir_renames:
            print(f"  {old.relative_to(REPO_ROOT)} -> {new.name}")

        # Count refs that would be updated
        refs_changed = 0
        for rst in SOURCE.rglob("*.rst"):
            text = rst.read_text()
            file_dir = str(rst.parent.relative_to(SOURCE)).replace(os.sep, "/")
            if file_dir == ".":
                file_dir = ""
            new_text = update_refs_in_text(text, file_dir, file_map, dir_map)
            if new_text != text:
                refs_changed += 1
        print(f"\n==> {refs_changed} archivos .rst con refs/toctree a actualizar")
        return

    if args.execute or args.pilot:
        # 1. Renombrar archivos
        for old, new in file_renames:
            print(f"git mv {old.relative_to(REPO_ROOT)} -> {new.name}")
            git_mv(old, new)

        # 2. Renombrar directorios (bottom-up)
        for old, new in dir_renames:
            print(f"git mv {old.relative_to(REPO_ROOT)} -> {new.name}")
            git_mv(old, new)

        # 3. Actualizar refs en TODO el corpus
        # Recolectar después de los renames físicos
        rst_files = list(SOURCE.rglob("*.rst"))
        updated = 0
        for rst in rst_files:
            text = rst.read_text()
            file_dir = str(rst.parent.relative_to(SOURCE)).replace(os.sep, "/")
            if file_dir == ".":
                file_dir = ""
            new_text = update_refs_in_text(text, file_dir, file_map, dir_map)
            if new_text != text:
                rst.write_text(new_text)
                updated += 1
        print(f"\n==> {updated} archivos .rst con refs actualizadas")


if __name__ == "__main__":
    main()
