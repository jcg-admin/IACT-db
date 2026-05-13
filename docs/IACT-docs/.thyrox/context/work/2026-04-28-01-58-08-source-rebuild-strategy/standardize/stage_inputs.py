#!/usr/bin/env python3
"""Pre-stage input documents from temp-backup/ and temp-holding/ to each WP-hijo.

Strategy:
- MD5 dedup: identical files → 1 copy in inputs/canonical/ (preferred source)
- Different files with same name → all copied to inputs/variants/ with mirror path
- Each WP gets INPUTS_INVENTORY.md with origin, hash, size, decision
- Master inputs-routing-map.md goes to parent WP

Excluded paths (known duplicates / out-of-scope):
- temp-holding/GENERACION_DOCUMENTACION/IACT_Backup_Completo_2026-01-11-old/
- temp-holding/GENERACION_DOCUMENTACION/IACT_Backup_Completo_2026-01-11/
- temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_2026-01-13_OK/
- temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_IACT_2026-01-13_2/
- temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_2026-01-13/

Source preference order (for MD5-identical canonicals):
1. temp-backup/source-2026-04-28/ (canonico Idea 1)
2. temp-holding/FASE 02/
3. temp-holding/FASE 01/
4. temp-holding/RBAC/
5. temp-holding/GENERACION_DOCUMENTACION/ (no excluded)
"""
import hashlib
import shutil
import re
from pathlib import Path
from collections import defaultdict

ROOT = Path("/home/user/IACT-docs")
WORK = ROOT / ".thyrox/context/work"
TB = ROOT / "temp-backup"
TH = ROOT / "temp-holding"

WPS = {
    "base-cognitiva": "2026-04-28-05-27-25-source-rebuild-base-cognitiva",
    "normativa-estandares": "2026-04-28-05-28-41-source-rebuild-normativa-estandares",
    "normativa-procedimientos": "2026-04-28-05-28-42-source-rebuild-normativa-procedimientos",
    "normativa-restricciones": "2026-04-28-05-28-43-source-rebuild-normativa-restricciones",
    "normativa-gobernanza": "2026-04-28-05-28-44-source-rebuild-normativa-gobernanza",
    "requisitos": "2026-04-28-05-28-45-source-rebuild-requisitos",
    "arquitectura-tecnica": "2026-04-28-05-28-46-source-rebuild-arquitectura-tecnica",
    "backend": "2026-04-28-05-28-47-source-rebuild-backend",
    "frontend": "2026-04-28-05-28-48-source-rebuild-frontend",
    "infrastructure": "2026-04-28-05-28-49-source-rebuild-infrastructure",
    "databases": "2026-04-28-05-28-50-source-rebuild-databases",
    "operations": "2026-04-28-05-28-51-source-rebuild-operations",
    "onboarding": "2026-04-28-05-28-52-source-rebuild-onboarding",
    "quality": "2026-04-28-05-28-53-source-rebuild-quality",
    "risks-technical-debt": "2026-04-28-05-28-54-source-rebuild-risks-technical-debt",
    "gestion": "2026-04-28-05-28-55-source-rebuild-gestion",
}
PARENT_WP = "2026-04-28-01-58-08-source-rebuild-strategy"

EXCLUDE_PATTERNS = [
    "IACT_Backup_Completo_2026-01-11-old",
    "IACT_Backup_Completo_2026-01-11/",
    "TMP_COMPLETO_2026-01-13_OK/",
    "TMP_COMPLETO_IACT_2026-01-13_2/",
    "TMP_COMPLETO_2026-01-13/",
    "Sphinx (documentation generator)",  # Reference de Sphinx, no del proyecto
]

# Routing rules: (regex_pattern, wp_key)
# Order matters — first match wins
ROUTING = [
    # ── temp-backup canonical structure ─────────────────────────
    (r"temp-backup/source-2026-04-28/base_cognitiva/", "base-cognitiva"),
    (r"temp-backup/source-2026-04-28/normativa/estandares/", "normativa-estandares"),
    (r"temp-backup/source-2026-04-28/normativa/procedimientos/", "normativa-procedimientos"),
    (r"temp-backup/source-2026-04-28/normativa/restricciones/", "normativa-restricciones"),
    (r"temp-backup/source-2026-04-28/normativa/", "normativa-gobernanza"),  # gobernanza/decisions/
    (r"temp-backup/source-2026-04-28/requisitos/", "requisitos"),
    (r"temp-backup/source-2026-04-28/arquitectura_tecnica/", "arquitectura-tecnica"),
    (r"temp-backup/source-2026-04-28/plantuml-guide/", "arquitectura-tecnica"),
    (r"temp-backup/source-2026-04-28/gestion/", "gestion"),

    # ── temp-holding/FASE 02 ────────────────────────────────────
    (r"temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/", "base-cognitiva"),
    (r"temp-holding/FASE 02/base_cognitiva/normativa/estandares/", "normativa-estandares"),
    (r"temp-holding/FASE 02/base_cognitiva/normativa/restricciones/", "normativa-restricciones"),
    (r"temp-holding/FASE 02/base_cognitiva/normativa/", "normativa-gobernanza"),
    (r"temp-holding/FASE 02/base_cognitiva/utilidades/", "normativa-estandares"),  # plantillas
    (r"temp-holding/FASE 02/originales/RESTRICCIONES_COMPLETAS", "normativa-restricciones"),
    (r"temp-holding/FASE 02/originales/FND_", "base-cognitiva"),
    (r"temp-holding/FASE 02/originales/META_", "base-cognitiva"),
    (r"temp-holding/FASE 02/originales/SBVR_", "base-cognitiva"),
    (r"temp-holding/FASE 02/originales/TXM_", "base-cognitiva"),
    (r"temp-holding/FASE 02/originales/MTM_", "base-cognitiva"),
    (r"temp-holding/FASE 02/originales/", "base-cognitiva"),  # default for originales (analyses)
    (r"temp-holding/FASE 02/tmp_work/", "base-cognitiva"),

    # ── temp-holding/project (risks/decisions/quality) ──────────
    (r"temp-holding/project/risks", "risks-technical-debt"),
    (r"temp-holding/project/decisions", "normativa-gobernanza"),
    (r"temp-holding/project/quality", "quality"),

    # ── DB-specific (priority sobre backend) ────────────────────
    (r"temp-holding/FASE 01/docs/backend/.*[Ee][Tt][Ll].*\.md", "databases"),
    (r"temp-holding/FASE 01/docs/backend/.*mysql.*\.md", "databases"),
    (r"temp-holding/FASE 01/docs/backend/plantilla_etl", "databases"),
    (r"temp-holding/FASE 01/docs/backend/TASK-005-sistema_de_metrics_interno_mysql", "databases"),
    (r"temp-holding/FASE 01/docs/backend/TASK-028-etl_pipeline_automation", "databases"),

    # ── temp-holding/FASE 01 root (archivos sueltos) ────────────
    (r"temp-holding/FASE 01/STD_", "normativa-estandares"),
    (r"temp-holding/FASE 01/NOM_", "normativa-estandares"),
    (r"temp-holding/FASE 01/CNST_05_", "normativa-restricciones"),
    (r"temp-holding/FASE 01/PLAN_MAESTRO_", "normativa-estandares"),
    (r"temp-holding/FASE 01/CLEAN CODE NAMING", "normativa-estandares"),
    (r"temp-holding/FASE 01/ANALISIS_COMPLETO_PROYECTO_RST", "base-cognitiva"),
    (r"temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO", "base-cognitiva"),
    (r"temp-holding/FASE 01/ARQUITECTURA_DOCUMENTAL", "arquitectura-tecnica"),
    (r"temp-holding/FASE 01/Call Center Dashboard - Arquitectura", "arquitectura-tecnica"),
    (r"temp-holding/FASE 01/ETL - Documentación", "databases"),

    # ── temp-holding/FASE 01 subdirs ────────────────────────────
    (r"temp-holding/FASE 01/BASE_COGNITIVA/", "base-cognitiva"),
    (r"temp-holding/FASE 01/CNST RESTRICCIONES/", "normativa-restricciones"),
    (r"temp-holding/FASE 01/STD ", "normativa-estandares"),
    (r"temp-holding/FASE 01/PROC_Procedimientos/", "normativa-procedimientos"),
    (r"temp-holding/FASE 01/TLP_Templates/", "normativa-estandares"),
    (r"temp-holding/FASE 01/MODELO DOCUMENTAL IACT/", "arquitectura-tecnica"),
    (r"temp-holding/FASE 01/Casos de Uso/", "requisitos"),
    (r"temp-holding/FASE 01/BR_ Busines Requirements/", "requisitos"),
    (r"temp-holding/FASE 01/FR_Requisitos_Funcionales/", "requisitos"),
    (r"temp-holding/FASE 01/Ingeniería de Requerimientos/", "requisitos"),
    (r"temp-holding/FASE 01/modulos/", "requisitos"),
    (r"temp-holding/FASE 01/RBAC/", "arquitectura-tecnica"),

    # ── temp-holding/FASE 01/docs (DOC_TYPE) ────────────────────
    (r"temp-holding/FASE 01/docs/backend/db/", "databases"),
    (r"temp-holding/FASE 01/docs/backend/", "backend"),
    (r"temp-holding/FASE 01/docs/frontend/", "frontend"),
    (r"temp-holding/FASE 01/docs/devops/", "infrastructure"),
    (r"temp-holding/FASE 01/docs/infraestructura/", "infrastructure"),
    (r"temp-holding/FASE 01/docs/operaciones/", "operations"),
    (r"temp-holding/FASE 01/docs/gobernanza/", "normativa-gobernanza"),
    (r"temp-holding/FASE 01/docs/trazabilidad/", "normativa-gobernanza"),
    (r"temp-holding/FASE 01/docs/PRODUCTO_DASHBOARD_ANALYTICS/", "requisitos"),
    (r"temp-holding/FASE 01/docs/scripts/", "operations"),
    (r"temp-holding/FASE 01/docs/SETUP\.md", "onboarding"),
    (r"temp-holding/FASE 01/docs/CONTRIBUTING\.md", "onboarding"),
    (r"temp-holding/FASE 01/docs/INDEX\.md", "onboarding"),
    (r"temp-holding/FASE 01/docs/README", "onboarding"),
    (r"temp-holding/FASE 01/docs/CHANGELOG\.md", "onboarding"),
    (r"temp-holding/FASE 01/docs/CODEOWNERS", "normativa-gobernanza"),
    (r"temp-holding/FASE 01/docs/Makefile", "quality"),
    (r"temp-holding/FASE 01/docs/pytest\.ini", "quality"),
    (r"temp-holding/FASE 01/docs/requirements\.txt", "backend"),
    (r"temp-holding/FASE 01/docs/mkdocs\.yml", "onboarding"),

    # ── temp-holding/Modules (Django models de referencia) ──────
    (r"temp-holding/Modules/", "backend"),

    # ── Sphinx config + index root ──────────────────────────────
    (r"temp-backup/source-2026-04-28/conf\.py", "onboarding"),
    (r"temp-backup/source-2026-04-28/index\.rst", "onboarding"),

    # ── temp-holding/RBAC ───────────────────────────────────────
    (r"temp-holding/RBAC/", "arquitectura-tecnica"),

    # ── temp-holding/GENERACION_DOCUMENTACION ───────────────────
    (r"temp-holding/GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_RBAC", "arquitectura-tecnica"),
    (r"temp-holding/GENERACION_DOCUMENTACION/MAPA_RBAC", "arquitectura-tecnica"),
    (r"temp-holding/GENERACION_DOCUMENTACION/CONTENIDO_DEL_BACKUP", "base-cognitiva"),
    (r"temp-holding/GENERACION_DOCUMENTACION/PLAN_MAESTRO_GENERACION", "base-cognitiva"),
    (r"temp-holding/GENERACION_DOCUMENTACION/PLAN_REGENERACION", "base-cognitiva"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 0/", "base-cognitiva"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 1/", "requisitos"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 2/", "arquitectura-tecnica"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 3", "backend"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 10/", "operations"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 11/", "quality"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 12/", "operations"),
    (r"temp-holding/GENERACION_DOCUMENTACION/FASE 13/", "operations"),
    (r"temp-holding/GENERACION_DOCUMENTACION/", "base-cognitiva"),  # default
]

PREFERENCE_ORDER = [
    "temp-backup/source-2026-04-28/",
    "temp-holding/FASE 02/",
    "temp-holding/FASE 01/",
    "temp-holding/RBAC/",
    "temp-holding/GENERACION_DOCUMENTACION/",
]


def is_excluded(path):
    s = str(path)
    for pat in EXCLUDE_PATTERNS:
        if pat in s:
            return True
    return False


def md5(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def route(rel_path):
    s = str(rel_path)
    for pat, wp_key in ROUTING:
        if re.search(pat, s):
            return wp_key
    return None


def preference_score(path):
    s = str(path)
    for i, pref in enumerate(PREFERENCE_ORDER):
        if pref in s:
            return i
    return len(PREFERENCE_ORDER)


def main():
    # 1) Collect all candidates
    print("[1/5] Collecting candidates...")
    candidates = []
    for base in [TB, TH]:
        for f in base.rglob("*"):
            if not f.is_file():
                continue
            if f.suffix.lower() not in {".md", ".rst", ".txt", ".yml", ".yaml", ".py", ".sh", ".ini", ".toml", ".cfg"}:
                continue
            if is_excluded(f):
                continue
            rel = f.relative_to(ROOT)
            wp = route(rel)
            if wp is None:
                continue
            candidates.append((f, rel, wp))
    print(f"  {len(candidates)} candidates")

    # 2) Group by (wp_key, basename) to detect collisions
    print("[2/5] Computing MD5 + grouping by basename...")
    groups = defaultdict(list)  # (wp, basename) -> [(path, rel, hash, score, size)]
    for f, rel, wp in candidates:
        try:
            h = md5(f)
            size = f.stat().st_size
            score = preference_score(rel)
            groups[(wp, f.name)].append((f, rel, h, score, size))
        except Exception as e:
            print(f"  WARN {f}: {e}")

    # 3) Stage to inputs/canonical or inputs/variants
    print("[3/5] Staging to WPs...")
    stats = defaultdict(lambda: {"canonical": 0, "variants": 0, "dedup_skip": 0})
    inventories = defaultdict(list)  # wp -> [dict]

    for (wp, basename), items in groups.items():
        wp_dir = WORK / WPS[wp] / "inputs"

        # Group by hash within this basename
        by_hash = defaultdict(list)
        for f, rel, h, sc, sz in items:
            by_hash[h].append((f, rel, sc, sz))

        if len(by_hash) == 1:
            # All same content -> canonical
            h = list(by_hash.keys())[0]
            ranked = sorted(by_hash[h], key=lambda x: x[2])
            chosen = ranked[0]
            f, rel, sc, sz = chosen
            dst = wp_dir / "canonical" / basename
            dst.parent.mkdir(parents=True, exist_ok=True)
            if not dst.exists():
                shutil.copy2(f, dst)
            stats[wp]["canonical"] += 1
            stats[wp]["dedup_skip"] += len(items) - 1
            inventories[wp].append({
                "type": "canonical",
                "dst": f"canonical/{basename}",
                "src": str(rel),
                "hash": h[:8],
                "size": sz,
                "duplicates_collapsed": len(items) - 1,
                "duplicate_sources": [str(it[1]) for it in ranked[1:]],
            })
        else:
            # Different contents -> variants with mirror path
            for f, rel, h_unused, sc, sz in sorted(items, key=lambda x: x[3]):
                # mirror path under variants/
                # Use rel without ROOT prefix
                mirror = wp_dir / "variants" / rel
                mirror.parent.mkdir(parents=True, exist_ok=True)
                if not mirror.exists():
                    shutil.copy2(f, mirror)
                h = md5(f)
                stats[wp]["variants"] += 1
                inventories[wp].append({
                    "type": "variant",
                    "dst": f"variants/{rel}",
                    "src": str(rel),
                    "hash": h[:8],
                    "size": sz,
                    "duplicates_collapsed": 0,
                })

    # 4) Write INPUTS_INVENTORY.md per WP
    print("[4/5] Writing inventories...")
    for wp, items in inventories.items():
        wp_dir = WORK / WPS[wp] / "inputs"
        inv = wp_dir / "INPUTS_INVENTORY.md"
        with open(inv, "w") as out:
            out.write("```yml\n")
            out.write("created_at: 2026-04-28 15:00:00\n")
            out.write(f"project: IACT-docs\n")
            out.write(f"work_package: {WPS[wp]}\n")
            out.write("phase: Phase 1 — DISCOVER (input staging)\n")
            out.write("author: NestorMonroy\n")
            out.write("status: Aprobado\n")
            out.write("version: 1.0.0\n")
            out.write("```\n\n")
            out.write(f"# Inputs Inventory — WP {wp}\n\n")
            out.write("Documentos pre-staged desde `temp-backup/` y `temp-holding/`. ")
            out.write("Solo estos archivos deben consultarse para el analisis de este WP — ")
            out.write("evita buscar en todo `temp-*`.\n\n")
            out.write("## Convencion\n\n")
            out.write("- `canonical/` — un solo archivo por concepto (MD5 deduplicado, ")
            out.write("preferencia: temp-backup > FASE 02 > FASE 01).\n")
            out.write("- `variants/` — archivos con mismo nombre pero contenido distinto, ")
            out.write("ruta espejo del origen para desambiguar.\n\n")

            canonical = [i for i in items if i["type"] == "canonical"]
            variants = [i for i in items if i["type"] == "variant"]
            out.write(f"## Resumen\n\n")
            out.write(f"- Canonicos: **{len(canonical)}**\n")
            out.write(f"- Variantes: **{len(variants)}**\n")
            out.write(f"- Duplicados colapsados: **{sum(i['duplicates_collapsed'] for i in canonical)}**\n\n")
            total_size = sum(i["size"] for i in items)
            out.write(f"- Tamano total stage: {total_size:,} bytes ({total_size/1024:.1f} KB)\n\n")

            out.write("## Canonicos\n\n")
            out.write("| Destino | Origen elegido | Hash | Bytes | Dups colapsados |\n")
            out.write("|---------|---------------|------|-------|----------------|\n")
            for it in sorted(canonical, key=lambda x: x["dst"]):
                dups = it["duplicates_collapsed"]
                out.write(f"| `{it['dst']}` | `{it['src']}` | {it['hash']} | {it['size']:,} | {dups} |\n")
            out.write("\n")

            if variants:
                out.write("## Variantes\n\n")
                out.write("| Destino | Origen | Hash | Bytes |\n")
                out.write("|---------|--------|------|-------|\n")
                for it in sorted(variants, key=lambda x: x["dst"]):
                    out.write(f"| `{it['dst']}` | `{it['src']}` | {it['hash']} | {it['size']:,} |\n")
                out.write("\n")

    # 5) Write master routing map in parent WP
    print("[5/5] Writing master routing map...")
    parent_dir = WORK / PARENT_WP / "analyze"
    parent_dir.mkdir(parents=True, exist_ok=True)
    with open(parent_dir / "inputs-routing-map.md", "w") as out:
        out.write("```yml\n")
        out.write("created_at: 2026-04-28 15:00:00\n")
        out.write("project: IACT-docs\n")
        out.write(f"work_package: {PARENT_WP}\n")
        out.write("phase: Phase 11 — TRACK (post-cierre — input routing)\n")
        out.write("author: NestorMonroy\n")
        out.write("status: Aprobado\n")
        out.write("version: 1.0.0\n")
        out.write("```\n\n")
        out.write("# Inputs Routing Map — temp-holding/temp-backup → WPs hijos\n\n")
        out.write("Mapeo central de documentos en `temp-backup/` y `temp-holding/` ")
        out.write("a su WP-hijo destino. Cuando se abre un WP-hijo nuevo, sus inputs ")
        out.write("ya estan pre-staged en `inputs/canonical/` o `inputs/variants/`.\n\n")
        out.write("## Resumen por WP\n\n")
        out.write("| WP | Canonicos | Variantes | Total |\n")
        out.write("|----|-----------|-----------|-------|\n")
        for wp_key in WPS:
            s = stats.get(wp_key, {})
            tot = s.get("canonical", 0) + s.get("variants", 0)
            out.write(f"| {wp_key} | {s.get('canonical', 0)} | {s.get('variants', 0)} | {tot} |\n")
        out.write(f"\n**Total candidatos enrutados:** {sum((stats[w]['canonical'] + stats[w]['variants']) for w in WPS)}\n\n")
        out.write("## Reglas de enrutamiento aplicadas\n\n")
        for pat, wp in ROUTING:
            out.write(f"- `{pat}` → **{wp}**\n")
        out.write("\n## Exclusiones\n\n")
        for pat in EXCLUDE_PATTERNS:
            out.write(f"- `{pat}`\n")
        out.write("\n## Preferencia de canonicos (orden)\n\n")
        for i, p in enumerate(PREFERENCE_ORDER, 1):
            out.write(f"{i}. `{p}`\n")

    # Final stats
    print("\n=== STATS ===")
    for wp in WPS:
        s = stats[wp]
        tot = s["canonical"] + s["variants"]
        print(f"  {wp:30s} canonical={s['canonical']:4d} variants={s['variants']:4d} dup_skipped={s['dedup_skip']:4d} | total={tot}")

    grand_total = sum(stats[w]["canonical"] + stats[w]["variants"] for w in WPS)
    grand_dedup = sum(stats[w]["dedup_skip"] for w in WPS)
    print(f"\n  GRAND TOTAL files staged: {grand_total}")
    print(f"  GRAND TOTAL duplicates collapsed: {grand_dedup}")


if __name__ == "__main__":
    main()
