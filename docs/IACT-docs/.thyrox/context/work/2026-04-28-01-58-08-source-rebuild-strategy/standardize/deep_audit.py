#!/usr/bin/env python3
"""Deep audit cross-WP — detect drift, broken refs, orphans, vocabulary issues."""
import re
from pathlib import Path
from collections import defaultdict

SOURCE = Path("source")

results = defaultdict(list)


# ============================================================
# AUDIT WP #1 base_cognitiva
# ============================================================

def audit_base_cognitiva():
    bc = SOURCE / "base_cognitiva"
    findings = []

    # B-1: drift "18 roles" en MTM_03
    mtm03 = bc / "_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst"
    if mtm03.exists():
        text = mtm03.read_text()
        if "18 roles" in text or "18 Roles" in text:
            findings.append(("CRITICO", "MTM_03 declara '18 roles' (modelo v4.0 legacy)", str(mtm03)))
        if "44 funciones" in text and "42 funciones" not in text:
            findings.append(("ALTO", "MTM_03 dice '44 funciones' (v5.1.1) en lugar de '42 funciones' (v5.2.1 corregido)", str(mtm03)))
        # Conteos "10 CNST" o variantes
        if re.search(r"\b10\s+(restricciones|CNSTs?)\b", text, re.IGNORECASE):
            findings.append(("MEDIO", "MTM_03 menciona conteo desactualizado de CNSTs (10 vs 31)", str(mtm03)))

    # B-2: glosario tiene "Funcion" / "Capacidad" / "Grupo" canonicos?
    gl = bc / "glosario.rst"
    if gl.exists():
        text = gl.read_text()
        terms = ["Funcion", "Capacidad", "Grupo de Permisos", "Agrupador", "Permiso Excepcional",
                "Regla SoD", "Verificacion de Permiso", "Menu Dinamico", "AuditoriaPermiso"]
        missing = [t for t in terms if t not in text]
        if missing:
            findings.append(("ALTO", f"glosario.rst NO contiene terminos canonicos del RBAC formalizado: {missing}", str(gl)))

    # B-3: FND_00 — ya arreglado en v2 pero verificar
    fnd00 = bc / "_fundamentos_conceptuales/FND_00_Contexto_y_Jerarquia.rst"
    if fnd00.exists():
        text = fnd00.read_text()
        if re.search(r"\b10\s+(restricciones|CNSTs?)\b", text, re.IGNORECASE):
            findings.append(("MEDIO", "FND_00 sigue diciendo '10 restricciones' a pesar de fix v2", str(fnd00)))

    # B-4: TXM_01, TXM_02 — taxonomias
    txm01 = bc / "_taxonomias_y_metamodelos/taxonomias/TXM_01_Taxonomia_Requisitos.rst"
    if txm01.exists():
        text = txm01.read_text()
        if "= 4" in text and "Constraints" in text:
            findings.append(("BAJO", "TXM_01 puede tener conteos viejos de Constraints", str(txm01)))

    # B-5: SBVR_* — conceptos del RBAC
    for f in (bc / "_ontologia_sbvr").glob("SBVR_*.rst"):
        text = f.read_text()
        if "18 roles" in text or "Role" in text and "RBAC" in text:
            # Look for legacy role-based mentions
            if re.search(r"basado\s+en\s+roles", text, re.IGNORECASE):
                findings.append(("MEDIO", f"{f.name}: posible mencion de 'basado en roles' (modelo v4.0)", str(f)))

    return findings


# ============================================================
# AUDIT WP #2 normativa-estandares
# ============================================================

def audit_normativa_estandares():
    ne = SOURCE / "normativa/estandares"
    findings = []

    # E-1: STD_007 menciona convencion ingles/espanol?
    std007 = ne / "STD_007_Convencion_Naming.rst"
    if std007.exists():
        text = std007.read_text()
        # Buscar convencion ingles/espanol
        if "ingles" not in text.lower() and "english" not in text.lower():
            findings.append(("MEDIO", "STD_007 NO menciona convencion ingles/espanol del MODELO_RBAC_v5.2.1", str(std007)))

    # E-2: Plantillas para UC, BR, FR, NFR
    plantillas_dir = ne / "plantillas"
    if plantillas_dir.exists():
        for tipo in ["UC", "BR", "FR", "NFR"]:
            tpls = list(plantillas_dir.glob(f"TPL_{tipo}*.rst"))
            if not tpls:
                findings.append(("ALTO", f"Plantilla TPL_{tipo}_*.rst NO existe en source/normativa/estandares/plantillas/", str(plantillas_dir)))

    return findings


# ============================================================
# AUDIT WP #3 normativa-procedimientos
# ============================================================

def audit_normativa_procedimientos():
    np = SOURCE / "normativa/procedimientos"
    findings = []

    # P-1: PROC_Generacion_* existen?
    gen_procs = list(np.glob("PROC_Generacion_*.rst"))
    if not gen_procs:
        findings.append(("MEDIO", "No hay archivos PROC_Generacion_* en procedimientos/", str(np)))

    # P-2: PROC_Excepciones_CNST pendiente per cross-wp-debt
    if not (np / "PROC_Excepciones_CNST.rst").exists():
        findings.append(("MEDIO", "PROC_Excepciones_CNST.rst pendiente (W-4 cross-wp-debt-summary del WP #4)", str(np)))

    return findings


# ============================================================
# AUDIT WP #4 normativa-restricciones
# ============================================================

def audit_normativa_restricciones():
    nr = SOURCE / "normativa/restricciones"
    findings = []

    # R-1: CNST Menu Dinamico (D-RBAC-5 aprobada)
    files = list(nr.glob("CNST_*.rst"))
    file_text_all = "\n".join(f.read_text() for f in files)
    if "Menu Dinamico" not in file_text_all and "menu dinamico" not in file_text_all.lower():
        findings.append(("ALTO", "CNST nuevo 'Menu Dinamico Obligatorio' (D-RBAC-5) NO existe en restricciones/", "source/normativa/restricciones/"))

    # R-2: CNST Vocabulario Unificado (D-RBAC-6 aprobada)
    if "Vocabulario Unificado" not in file_text_all and "vocabulario unificado" not in file_text_all.lower():
        findings.append(("ALTO", "CNST nuevo 'Vocabulario Unificado RBAC' (D-RBAC-6) NO existe en restricciones/", "source/normativa/restricciones/"))

    # R-3: CNST_029 menciona los 10 grupos predefinidos AGR-001..010?
    cnst029 = nr / "CNST_029_RBAC_Modelo_Plano.rst"
    if cnst029.exists():
        text = cnst029.read_text()
        if "AGR-001" not in text and "AGR_001" not in text:
            findings.append(("ALTO", "CNST_029 NO menciona los 10 grupos predefinidos AGR-001..010", str(cnst029)))
        if "system group" not in text.lower() and "custom group" not in text.lower():
            findings.append(("MEDIO", "CNST_029 NO declara distincion 'system groups' (inmutables) vs 'custom groups' (creables) — D-RBAC-4", str(cnst029)))

    # R-4: CNST_030 declara las 3 reglas SoD especificas?
    cnst030 = nr / "CNST_030_Reglas_de_Separacion_de_Funciones_SoD.rst"
    if cnst030.exists():
        text = cnst030.read_text()
        if "SOD-001" not in text and "pipeline_audit_separation" not in text:
            findings.append(("ALTO", "CNST_030 NO declara las 3 reglas SoD atomicas (SOD-001/002/003)", str(cnst030)))

    return findings


# ============================================================
# AUDIT WP #5 normativa-gobernanza
# ============================================================

def audit_normativa_gobernanza():
    ng = SOURCE / "normativa/gobernanza"
    findings = []

    # G-1: ADR-GOB-008 RBAC Coexistencia (pendiente)
    if not list(ng.glob("ADR-GOB-008*.rst")):
        findings.append(("ALTO", "ADR-GOB-008 'RBAC Coexistencia ACC ↔ PERM' NO existe — necesario para Hipotesis 1 aprobada", str(ng)))

    return findings


# ============================================================
# AUDIT WP #6 requisitos (deep)
# ============================================================

def audit_requisitos():
    req = SOURCE / "requisitos/casos_uso"
    findings = []

    # Q-1: 515 refs CNST legacy en bodies
    legacy_count = 0
    for f in req.rglob("UC_*.rst"):
        text = f.read_text()
        # Skip metadata block at top
        body = text.split("\n\n", 1)[1] if "\n\n" in text else text
        # Count CNST-NNN refs (legacy format with dash)
        legacy_count += len(re.findall(r"CNST-\d{3}", body))
    if legacy_count > 0:
        findings.append(("ALTO", f"{legacy_count} refs CNST legacy (CNST-NNN format) en bodies de UCs", str(req)))

    # Q-2: "Capacidad" en UC_PERM (D-RBAC-1 dice "Funcion")
    perm_dir = req / "permissions"
    cap_count = 0
    for f in perm_dir.glob("UC_PERM_*.rst"):
        cap_count += len(re.findall(r"\b[Cc]apacidad", f.read_text()))
    if cap_count > 0:
        findings.append(("ALTO", f"{cap_count} ocurrencias 'Capacidad' en UC_PERM (deberia 'Funcion' per D-RBAC-1)", str(perm_dir)))

    # Q-3: Cross-refs ACC ↔ PERM
    acc_files = list((req / "access").glob("UC_ACC_*.rst"))
    perm_files = list((req / "permissions").glob("UC_PERM_*.rst"))
    acc_to_perm = sum(1 for f in acc_files if "UC_PERM" in f.read_text())
    perm_to_acc = sum(1 for f in perm_files if "UC_ACC" in f.read_text())
    if acc_to_perm == 0 and perm_to_acc == 0:
        findings.append(("MEDIO", "0 cross-refs entre UC_ACC ↔ UC_PERM (coexistencia invisible al lector)", str(req)))

    # Q-4: BRs, FRs, NFRs NO existen
    for sub in ["reglas_negocio", "requisitos_funcionales", "requisitos_no_funcionales"]:
        if not (SOURCE / "requisitos" / sub).exists():
            findings.append(("MEDIO", f"source/requisitos/{sub}/ NO existe — solo casos_uso fue generado en WP #6", str(SOURCE / "requisitos")))

    # Q-5: Refs intra-UC rotas (UC mencionado pero no existe)
    all_uc_files = {f.stem for f in req.rglob("UC_*.rst")}
    broken_refs = set()
    for f in req.rglob("UC_*.rst"):
        text = f.read_text()
        # Find :doc: refs to other UCs
        for m in re.finditer(r":doc:`([^`]*UC_[^`]+)`", text):
            ref = m.group(1).split("/")[-1]
            if ref not in all_uc_files:
                broken_refs.add((f.name, ref))
    if broken_refs:
        findings.append(("ALTO", f"{len(broken_refs)} refs :doc: a UCs inexistentes", str(broken_refs)[:200]))

    return findings


# ============================================================
# AUDIT global source/
# ============================================================

def audit_global():
    findings = []

    # G-1: archivos en source/ no incluidos en ningun toctree
    all_rsts = set()
    for f in SOURCE.rglob("*.rst"):
        rel = f.relative_to(SOURCE).with_suffix("")
        all_rsts.add(str(rel))
    referenced = set()
    for f in SOURCE.rglob("*.rst"):
        text = f.read_text()
        # Buscar archivos en toctree
        in_toctree = False
        for line in text.split("\n"):
            if ".. toctree::" in line:
                in_toctree = True
                continue
            if in_toctree:
                if line.startswith("   ") and not line.strip().startswith(":"):
                    ref = line.strip()
                    if ref:
                        referenced.add(ref)
                        # Also resolve relative path
                        parent = f.parent.relative_to(SOURCE)
                        full = str(parent / ref) if str(parent) != "." else ref
                        referenced.add(full)
                elif line.strip() and not line.startswith(" "):
                    in_toctree = False
    orphans = sorted(set(r for r in all_rsts if not any(r in ref or ref in r for ref in referenced)))
    # Filter known: index files ARE the entry, base files
    real_orphans = [o for o in orphans if not o.endswith("index") and "/index" not in o]
    if len(real_orphans) > 5:
        findings.append(("MEDIO", f"{len(real_orphans)} archivos posiblemente huerfanos (no en ningun toctree)", "source/"))

    return findings


# Run all
results["WP-1-base-cognitiva"] = audit_base_cognitiva()
results["WP-2-estandares"] = audit_normativa_estandares()
results["WP-3-procedimientos"] = audit_normativa_procedimientos()
results["WP-4-restricciones"] = audit_normativa_restricciones()
results["WP-5-gobernanza"] = audit_normativa_gobernanza()
results["WP-6-requisitos"] = audit_requisitos()
results["GLOBAL"] = audit_global()

# Print and save
total = 0
for wp, findings in results.items():
    print(f"\n=== {wp} — {len(findings)} hallazgos ===")
    for sev, desc, ref in findings:
        print(f"  [{sev}] {desc}")
        print(f"         {ref}")
    total += len(findings)
print(f"\n\n{total} hallazgos totales")
