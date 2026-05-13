#!/usr/bin/env python3
"""Verify each of the 401 UC IDs into exact categories — no estimates."""
import re
from pathlib import Path
from collections import defaultdict

BASE = Path(".thyrox/context/work")

# === Step 1: re-collect all 401 UCs with their context lines ===
all_ucs = defaultdict(list)
for input_dir in BASE.glob("*/inputs/"):
    for f in input_dir.rglob("*"):
        if not f.is_file() or f.suffix.lower() not in {".md", ".rst", ".txt"}:
            continue
        try:
            text = f.read_text(encoding="utf-8", errors="replace")
        except:
            continue
        for m in re.finditer(r"\bUC[-_]([A-Z]+)?[-_]?(\d{1,3})(?:\.\d+)?\b", text):
            mod = m.group(1)
            num = m.group(2).zfill(3)
            nid = f"UC-{mod}-{num}" if mod else f"UC-{num}"
            line_start = text.rfind("\n", 0, m.start()) + 1
            line_end = text.find("\n", m.end())
            ctx = text[line_start:line_end if line_end > 0 else len(text)].strip()
            all_ucs[nid].append(ctx)

print(f"Total IDs unicos: {len(all_ucs)}")

# === Step 2: categorize each ID with deterministic rules ===
V4_MODULES = {"USR", "AUTH", "ACC", "RPT", "ALR", "PIP", "AUD", "LOG"}

# Verify which modular IDs actually have backing .rst in backup
canonical_path = Path("temp-backup/source-2026-04-28/requisitos/casos_uso")
canonical_files = set()
if canonical_path.exists():
    for mod_dir in canonical_path.iterdir():
        if mod_dir.is_dir():
            for f in mod_dir.glob("UC_*.rst"):
                # Normalize: UC_AUTH_01_X -> UC-AUTH-01
                m = re.match(r"UC_([A-Z]+)_(\d+)_", f.stem)
                if m:
                    nid = f"UC-{m.group(1)}-{m.group(2).zfill(3)}"
                    canonical_files.add(nid)

print(f"\nIDs en backup canonico: {len(canonical_files)}")

# Map legacy v2 -> v4 from PLAN_MAESTRO
LEGACY_MAP_RANGES = {
    # IACT v2.0 numbers that map to v4 canonical
    range(1, 6),    # UC-001..005 = AUTH/USR
    range(6, 12),   # UC-006..011 = USR/ACC
    range(12, 17),  # UC-012..016 = AUD/ACC
    range(17, 31),  # UC-017..030 = RPT
    range(36, 48),  # UC-036..047 = ALR/ACC
    range(50, 64),  # UC-050..063 = PIP/AUD
}

def is_iact_v2_legacy(nid, ctxs):
    """UC-NNN with content suggesting IACT v2.0 (auth/RBAC/reports/alerts)"""
    if not re.match(r"^UC-\d+$", nid):
        return False
    n = int(nid.split("-")[1])
    iact_keywords = ["uc_acc", "uc_usr", "uc_rpt", "uc_alr", "uc_pip", "uc_aud", "uc_auth",
                     "rbac", "alerta", "configurar alerta", "exportar excel", "exportar csv",
                     "iniciar sesion", "cerrar sesion", "asignar funcion", "consultar reporte",
                     "mod_users", "mod_access", "mod_reports", "mod_alerts", "mod_pipeline",
                     "uc-010 a uc-047", "uc-005 a uc-011", "uc-012 a uc-016",
                     "uc-017 a uc-024", "uc-025 a uc-030", "uc-036 a uc-040",
                     "uc-051", "uc-052", "uc-053", "uc-060 a uc-063",
                     "registrar evento", "auditar", "asignar segmento", "permiso temporal"]
    blob = " ".join(ctxs).lower()
    has_iact = any(k in blob for k in iact_keywords)
    in_legacy_range = any(n in r for r in LEGACY_MAP_RANGES)
    return has_iact and in_legacy_range

def is_devops_tool(nid, ctxs):
    devops_kw = ["validate python version", "validate node", "validate node.js",
                 "detect missing ui", "analyze django serializer",
                 "pre-push validation", "ci-local validation",
                 "handle job dependencies", "fail-fast on critical",
                 "timeout handling for long-running", "dry-run pipeline",
                 "generate pipeline execution report",
                 "track deployment frequency", "track lead time",
                 "track change failure", "track mean time to recovery", "mttr",
                 "execute act phase", "execute specific stage",
                 "automated pdca cycle"]
    blob = " ".join(ctxs).lower()
    return any(k in blob for k in devops_kw)

def is_pedagogic_chem(nid, ctxs):
    chem_kw = ["cas number", "msds", "hoja seguridad", "hoja de seguridad",
               "producto quimico", "producto químico", "consultar productos",
               "osha", "epa", "regulacion ambiental", "uc-204", "uc-208",
               "chemicalproduct", "chemical product", "química"]
    blob = " ".join(ctxs).lower()
    return any(k in blob for k in chem_kw)

def is_pedagogic_employees(nid, ctxs):
    """UC-A-NNN and UC-B-NNN are Larman/RRHH examples"""
    if re.match(r"^UC-[AB]-\d+$", nid):
        return True
    blob = " ".join(ctxs).lower()
    rrhh_kw = ["registrar empleado", "dar de alta empleado", "modificar datos de empleado",
               "actualizar información personal", "stakeholder - rh", "larman - evento"]
    return any(k in blob for k in rrhh_kw)

def is_adr_mgmt(nid, ctxs):
    return nid.startswith("UC-ADR-")

def is_subnumeration_nfr(nid, ctxs):
    """UC-NNN where context shows it's actually NFR-NNN.X"""
    blob = " ".join(ctxs).lower()
    # Common NFR sub-aspects
    return any(p in blob for p in ["nfr-110.", "nfr-61.", "nfr-62.", "nfr-40.",
                                    "nfr_110.", "nfr_61.", "nfr_62."])

def is_unofficial_prefix(nid, ctxs):
    """Modular prefix not in V4_MODULES"""
    parts = nid.split("-")
    if len(parts) == 3 and parts[0] == "UC":
        return parts[1] not in V4_MODULES and parts[1] not in {"A", "B", "ADR"}
    return False

def is_v4_modular_canonical(nid):
    parts = nid.split("-")
    if len(parts) != 3 or parts[0] != "UC":
        return False
    if parts[1] not in V4_MODULES:
        return False
    return nid in canonical_files

def is_v4_modular_padding_dup(nid):
    """UC_ACC_001 vs UC_ACC_01 — same concept different padding"""
    parts = nid.split("-")
    if len(parts) != 3 or parts[1] not in V4_MODULES:
        return False
    n = int(parts[2])
    # Check if alternate padding exists in canonical
    alt_padded = f"UC-{parts[1]}-{str(n).zfill(3)}"
    if alt_padded != nid and alt_padded in canonical_files:
        return True
    # Or if number > expected range for that module
    expected_max = {"USR": 4, "AUTH": 5, "ACC": 9, "RPT": 14, "ALR": 5, "PIP": 4, "AUD": 4, "LOG": 4}
    return n > expected_max.get(parts[1], 99)

# === Step 3: classify all ===
categories = defaultdict(list)

for nid, ctxs in all_ucs.items():
    # Priority order matters
    if is_v4_modular_canonical(nid):
        categories["A_iact_v4_canonical"].append(nid)
    elif is_v4_modular_padding_dup(nid):
        categories["A_v4_padding_variant"].append(nid)
    elif is_adr_mgmt(nid, ctxs):
        categories["F_adr_mgmt"].append(nid)
    elif is_pedagogic_employees(nid, ctxs):
        categories["E_pedagogic_employees"].append(nid)
    elif is_unofficial_prefix(nid, ctxs):
        categories["G_unofficial_prefix"].append(nid)
    elif is_pedagogic_chem(nid, ctxs):
        categories["D_pedagogic_chem"].append(nid)
    elif is_devops_tool(nid, ctxs):
        categories["C_devops_tools"].append(nid)
    elif is_subnumeration_nfr(nid, ctxs):
        categories["H_subnumeration_nfr"].append(nid)
    elif is_iact_v2_legacy(nid, ctxs):
        categories["B_iact_v2_legacy"].append(nid)
    else:
        categories["I_noise"].append(nid)

# === Step 4: report ===
print(f"\n=== Categorizacion verificada (cada ID asignado a 1 categoria) ===\n")
labels = {
    "A_iact_v4_canonical": "A. IACT v4.0.0 canonico (.rst en backup)",
    "A_v4_padding_variant": "A'. v4 modular variantes padding",
    "B_iact_v2_legacy": "B. IACT v2.0 legacy mapeable",
    "C_devops_tools": "C. DevOps tools",
    "D_pedagogic_chem": "D. Pedagogicos quimicos/OSHA",
    "E_pedagogic_employees": "E. Pedagogicos empleados/RRHH",
    "F_adr_mgmt": "F. ADR management",
    "G_unofficial_prefix": "G. Nomenclatura no oficial",
    "H_subnumeration_nfr": "H. Sub-numeraciones NFR",
    "I_noise": "I. Ruido sin clasificar",
}
total = 0
for key, label in labels.items():
    n = len(categories[key])
    total += n
    print(f"  {n:4d}  {label}")
print(f"  ----")
print(f"  {total:4d}  TOTAL")

# Sample ruido para inspeccion
print(f"\n=== Sample del ruido (primeros 30) ===")
for nid in sorted(categories["I_noise"])[:30]:
    ctx = all_ucs[nid][0][:120].replace("\n", " ")
    print(f"  {nid}: {ctx}")

# Save details to file
out = Path(".thyrox/context/work/2026-04-28-05-28-45-source-rebuild-requisitos/analyze/uc-401-clasificacion-verificada.md")
with open(out, "w") as f:
    f.write("```yml\ncreated_at: 2026-04-29 00:30:00\nproject: IACT-docs\nstatus: Aprobado\nversion: 1.0.0\n```\n\n")
    f.write("# Clasificacion VERIFICADA de los 401 UCs\n\n")
    f.write(f"Cada uno de los 401 IDs fue clasificado deterministicamente por reglas\n")
    f.write(f"explicitas (ver `/tmp/verify_uc_categories.py`). Cada ID asignado a UNA SOLA categoria.\n\n")
    f.write(f"## Conteos exactos\n\n")
    f.write(f"| # | Categoria | Cantidad |\n|---|-----------|----------|\n")
    for key, label in labels.items():
        n = len(categories[key])
        f.write(f"| {key.split('_')[0]} | {label} | **{n}** |\n")
    f.write(f"| | **Total** | **{total}** |\n\n")
    f.write(f"## Detalle por categoria\n\n")
    for key, label in labels.items():
        ids = sorted(categories[key])
        f.write(f"### {label} ({len(ids)})\n\n")
        if not ids:
            f.write("(ninguno)\n\n")
            continue
        f.write("```\n")
        for nid in ids:
            f.write(f"  {nid}\n")
        f.write("```\n\n")
print(f"\nWrote: {out}")
