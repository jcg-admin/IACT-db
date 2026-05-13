#!/usr/bin/env python3
"""migrate-uc-schema.py — F-13: schema legacy UC → schema canónico.

Mapeo 1:1:
  :uc_id:    -> :artefacto:
  :date:     -> :fecha_creacion:
  :status:   -> :estado:
  :module:   -> :subdominio:
  :project:  -> (eliminar)
  :version:  -> :version: (sin cambio)
  :normativa: -> :normativa: (preservar)

Agrega campos faltantes obligatorios:
  :tipo:, :dominio:, :autor:, :clasificacion:

Idempotente: si el archivo ya está en schema canónico, no hace nada.
"""
from __future__ import annotations
import re
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[6]
SOURCE = REPO_ROOT / "source"

# Field mapping legacy -> canonical
FIELD_MAP = {
    "uc_id": "artefacto",
    "date": "fecha_creacion",
    "status": "estado",
    "module": "subdominio",
}

# Required fields with defaults if missing
REQUIRED_DEFAULTS = {
    "tipo": "Caso de Uso",   # default for UC files (most legacy schema)
    "dominio": "requisitos",
    "autor": "Equipo IACT",
    "clasificacion": "Interno",
}


def has_legacy_schema(text: str) -> bool:
    """Detect if file uses legacy UC schema."""
    return bool(re.search(r"^[ \t]*:(uc_id|date|status|module):", text, re.M))


def has_canonical_schema(text: str) -> bool:
    """Detect if file already uses canonical schema."""
    return ":artefacto:" in text and ":fecha_creacion:" in text


def transform_meta_block(text: str) -> str:
    """Transform a legacy meta block to canonical."""
    # Find the .. meta:: block
    meta_match = re.search(r"(\.\. meta::\n)((?:[ \t]+:[^:]+:[^\n]*\n)+)", text)
    if not meta_match:
        return text

    meta_header = meta_match.group(1)
    meta_body = meta_match.group(2)

    # Parse fields preserving indent
    lines = meta_body.split("\n")
    parsed = {}  # field -> value
    indent = " "
    field_order = []

    for line in lines:
        m = re.match(r"^([ \t]+):([^:]+):[ \t]*(.*)$", line)
        if m:
            indent = m.group(1)
            field = m.group(2).strip()
            value = m.group(3).strip()
            parsed[field] = value
            if field not in field_order:
                field_order.append(field)

    # Skip if not legacy
    if not any(f in parsed for f in FIELD_MAP):
        return text

    # Apply mappings
    new_parsed = {}
    for field in field_order:
        if field == "project":
            continue  # eliminate
        new_field = FIELD_MAP.get(field, field)
        new_parsed[new_field] = parsed[field]

    # Special: :module: was legacy "MOD_Access" -> :subdominio: should be kebab-lowercase per dir
    # Heuristic: if value starts with MOD_, lowercase + replace _ with -
    if "subdominio" in new_parsed:
        v = new_parsed["subdominio"]
        if v.startswith("MOD_"):
            new_parsed["subdominio"] = v[4:].lower().replace("_", "-")
        else:
            new_parsed["subdominio"] = v.lower().replace("_", "-")

    # Add required defaults if missing
    for f, default in REQUIRED_DEFAULTS.items():
        if f not in new_parsed:
            new_parsed[f] = default

    # Special: :tipo: — if :uc_id: existed it's "Caso de Uso", if :artefacto: starts with FR- it's "Requisito Funcional"
    art = new_parsed.get("artefacto", "")
    if art.startswith("FR-") or art.startswith("FR_"):
        new_parsed["tipo"] = "Requisito Funcional"
    elif art.startswith("UC_") or art.startswith("UC-"):
        new_parsed["tipo"] = "Caso de Uso"

    # Define canonical order
    canonical_order = [
        "artefacto", "tipo", "dominio", "subdominio",
        "estado", "version", "fecha_creacion", "ultimo_cambio",
        "autor", "clasificacion", "normativa",
    ]
    # Plus any extra fields preserved
    for f in new_parsed:
        if f not in canonical_order:
            canonical_order.append(f)

    # Render new meta block
    new_lines = []
    for f in canonical_order:
        if f in new_parsed:
            new_lines.append(f"{indent}:{f}: {new_parsed[f]}")
    new_body = "\n".join(new_lines) + "\n"

    return text[:meta_match.start(2)] + new_body + text[meta_match.end():]


def main():
    total_files = 0
    for rst in SOURCE.rglob("*.rst"):
        text = rst.read_text()
        if not has_legacy_schema(text):
            continue
        if has_canonical_schema(text):
            # Mixed — but rare; let's still try
            pass
        new_text = transform_meta_block(text)
        if new_text != text:
            rst.write_text(new_text)
            total_files += 1
            print(f"  ✓ {rst.relative_to(REPO_ROOT)}")
    print(f"\n==> {total_files} archivos migrados a schema canónico")


if __name__ == "__main__":
    main()
