#!/usr/bin/env python3
"""add-meta-block.py — F-07/F-08/F-09: agregar .. meta:: faltante.

Para cada archivo sin frontmatter:
1. Inferir campos del path + filename.
2. Obtener :fecha_creacion: del primer commit en git log.
3. Insertar bloque .. meta:: al inicio.

Idempotente.
"""
from __future__ import annotations
import re
import subprocess
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[6]
SOURCE = REPO_ROOT / "source"


def has_meta(text: str) -> bool:
    return bool(re.match(r"^\.\. meta::", text.lstrip()))


def infer_artefacto(stem: str) -> str:
    """Derive :artefacto: ID from filename stem."""
    # adr-back-004-... -> ADR-BACK-004
    # checklist-desarrollo -> Checklist_Desarrollo
    # plantilla-adr -> Plantilla_ADR
    parts = stem.split("-")
    # Numbered with module: prefix-mod-nnn-...
    if len(parts) >= 4 and parts[2].isdigit():
        return f"{parts[0].upper()}-{parts[1].upper()}-{parts[2]}"
    # Numbered no module: prefix-nnn-...
    if len(parts) >= 2 and parts[1].isdigit():
        return f"{parts[0].upper()}_{parts[1]}"
    # Words (guides/templates): pascal-snake
    return "_".join(p.capitalize() for p in parts)


def infer_tipo(stem: str) -> str:
    if stem.startswith("adr-"):
        return "ADR"
    if stem.startswith("checklist") or stem.startswith("checklists"):
        return "Checklist"
    if stem.startswith("plantilla-"):
        return "Plantilla"
    if "-test-" in stem or stem.startswith("test-"):
        return "Test/Ejemplo"
    return "Guia"


def infer_dominio_subdominio(rel: Path) -> tuple[str, str]:
    parts = rel.parts
    if len(parts) >= 1:
        dominio = parts[0]
    else:
        dominio = "source"
    if len(parts) >= 2:
        subdominio = parts[1]
    else:
        subdominio = ""
    # Strip trailing filename if present
    if subdominio.endswith(".rst"):
        subdominio = ""
    return dominio, subdominio


def get_first_commit_date(filepath: Path) -> str:
    """Get first commit date of the file (added). Fallback to today."""
    try:
        result = subprocess.run(
            ["git", "log", "--diff-filter=A", "--format=%ad", "--date=short",
             "--follow", "--", str(filepath.relative_to(REPO_ROOT))],
            capture_output=True, text=True, cwd=REPO_ROOT, check=True,
        )
        lines = [l for l in result.stdout.strip().split("\n") if l]
        if lines:
            return lines[-1]  # oldest first commit (with --follow)
    except Exception:
        pass
    return "2026-04-28"  # fallback


def build_meta_block(filepath: Path) -> str:
    rel = filepath.relative_to(SOURCE)
    stem = filepath.stem
    artefacto = infer_artefacto(stem)
    tipo = infer_tipo(stem)
    dominio, subdominio = infer_dominio_subdominio(rel)
    fecha = get_first_commit_date(filepath)

    fields = [
        f" :artefacto: {artefacto}",
        f" :tipo: {tipo}",
        f" :dominio: {dominio}",
    ]
    if subdominio:
        fields.append(f" :subdominio: {subdominio}")
    fields.extend([
        " :estado: Aprobado",
        " :version: 1.0.0",
        f" :fecha_creacion: {fecha}",
        " :autor: Equipo IACT",
        " :clasificacion: Interno",
    ])
    return ".. meta::\n" + "\n".join(fields) + "\n\n"


def main():
    total = 0
    for rst in SOURCE.rglob("*.rst"):
        if rst.name == "index.rst":
            continue
        text = rst.read_text()
        if has_meta(text):
            continue
        meta = build_meta_block(rst)
        new_text = meta + text
        rst.write_text(new_text)
        total += 1
        print(f"  ✓ {rst.relative_to(REPO_ROOT)}")
    print(f"\n==> {total} archivos con .. meta:: agregado")


if __name__ == "__main__":
    main()
