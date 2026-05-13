```yml
created_at: 2026-04-28 23:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (sintesis)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP #6 Phase 1 DISCOVER — Resumen ejecutivo de inventarios

## Objetivo

Concentrar TODO el contenido de requirements antes de generar
`source/requisitos/`. Producir 4 catalogos canonicos + mapeos
cruzados + decisiones D-REQ.

## Resultados de la concentracion

### Catalogo IACT v4.0.0 final

| Tipo | Detectados raw | Filtrados IACT reales | Senial | Nomenclatura v4.0.0 |
|------|---------------|----------------------|--------|---------------------|
| **UC**  | 401 | **49** | 12% | `UC_<MOD>_<NN>_<Nombre>` ✓ canonica en RSTs |
| **BR**  | 384 | **20** | 5% | NO existe modular v4 — propuesta `BR_<MOD>_<NN>` pendiente |
| **FR**  | 315 | **51** documentados (88% catalogo aun no .rst) | 16% | `FR_<MOD>_<UC>_<NN>_<Nombre>` ✓ declarada en PLAN_MAESTRO |
| **NFR** | 15 | **28** propuestos ISO 25010 | 187%* | `NFR_<TIPO>_<NN>` (PERF/SEC/REL/USAB/AUD) |

(*) NFR > 100% porque varios NFRs cuantitativos vienen cross-CNST
(no estaban como NFR explicito en inputs).

### Distribucion UC por modulo (49 UCs)

| Modulo | UCs | Cantidad |
|--------|-----|----------|
| MOD_Auth | UC_AUTH_01..05 | 5 (NUEVO modulo, no en mi catalogo inicial) |
| MOD_Users | UC_USR_01..04 | 4 |
| MOD_Access | UC_ACC_01..09 | 9 |
| MOD_Reports | UC_RPT_01..14 | 14 (TITULOS DIVERGEN del PLAN_MAESTRO) |
| MOD_Alerts | UC_ALR_01..05 | 5 (TITULOS DIVERGEN del PLAN_MAESTRO) |
| MOD_Pipeline | UC_PIP_01..04 | 4 |
| MOD_Audit | UC_AUD_01..04 | 4 |
| MOD_Logs | UC_LOG_01..04 | 4 (NUEVO modulo, no en mi catalogo inicial) |
| **Total** | | **49** |

### Distribucion NFR por atributo ISO 25010 (28 NFRs)

| Atributo | NFRs |
|----------|-----|
| NFR_PERF (Performance Efficiency) | 9 |
| NFR_SEC (Security) | 8 |
| NFR_REL (Reliability) | 5 |
| NFR_USAB (Usability) | 3 |
| NFR_AUD (Auditability) | 3 |
| **Total** | **28** |

### BReqs (Business Requirements) referenciados por UCs

22 BReqs unicos referenciados en metadata RST de los 49 UCs:

- BRQ-AUTH-001..005 (5)
- BRQ-USR-001..004 (4)
- BRQ-ACC-001..009 (9) [presumido por simetria con UC_ACC_01..09]
- BRQ-RPT-001..014 (14)
- BRQ-ALR-001..005 (5)
- etc.

(Conteo exacto en `inventory-uc-v4.md` § "Cobertura de BReqs")

### CNSTs referenciados por UCs

Los UCs declaran en su metadata `:normativa: CNST-NNN, CNST-NNN`
**con nomenclatura LEGACY (set de 11 CNSTs)**. Phase 2 debe mapear a
la nomenclatura del rebuild SRP-31 (ver `cross-wp-debt-summary.md`
§ W-1).

## Hallazgos criticos

### H-CRITICAL-1: Mi catalogo inicial estaba incompleto

Mi prompt al agente UC asumio 40 UCs en 6 modulos, basado en
PLAN_MAESTRO. La verificacion directa de los RSTs reveló:

- **49 UCs reales** (no 40)
- **8 modulos reales** (no 6) — faltaron AUTH y LOG
- **20 UCs con titulos divergentes** del PLAN_MAESTRO (14 RPT + 4 ALR + 2 AUD)

**Decision implicita aplicada:** los RSTs son la autoridad (Idea 1
backup-as-reference). El PLAN_MAESTRO esta desactualizado. El inventario
UC v2.0.0 (re-escrito post-agente) refleja la verdad de los RSTs.

### H-CRITICAL-2: Drift de nomenclatura BR

A diferencia de UC y FR (que tienen nomenclatura modular v4.0.0
documentada), **los BRs no tienen modular v4**. Solo existen como
`BR_001..BR_020`. Esto crea inconsistencia: un UC referencia
`BR_005` pero no se sabe a que modulo pertenece.

**Decision pendiente D-REQ-3:** introducir nomenclatura modular para
BRs (ej. `BR_AUTH_001`, `BR_RPT_001`) o conservar flat.

### H-CRITICAL-3: 88% del catalogo FR aun no generado

Solo 51 de los esperados 200+ FRs (estimado por proporcion
1 UC ~ 4 FRs) estan documentados como `.rst`. Los demas estan
referenciados en tablas pero sin archivo dedicado.

**Decision pendiente D-REQ-5:** generar los FRs faltantes en este WP
o diferir a WP-hijo separado.

### H-CRITICAL-4: 12 BRs pedagogicos descartados

BRs `BR_028, 029, 030, 045, 046, 052, 087, 088, 089` y `BR_CHEM_001..004`
son ejemplos pedagogicos del documento metodologico generico (dominio
quimicos / OSHA / presupuestos), no del sistema IACT. Se descartan.

## Inventarios producidos en este WP

| Artefacto | Status |
|-----------|--------|
| `analyze/id-index-uc.md` (401 raw) | ✓ |
| `analyze/id-index-br.md` (384 raw) | ✓ |
| `analyze/id-index-fr.md` (315 raw) | ✓ |
| `analyze/id-index-nfr.md` (15 raw) | ✓ |
| `analyze/inventory-uc-v4.md` (49 IACT) | ✓ v2.0.0 corregida |
| `analyze/inventory-br-v4.md` (20 IACT) | ✓ |
| `analyze/inventory-fr-v4.md` (51 IACT documentados, 88% pendiente) | ✓ |
| `analyze/inventory-nfr-v4.md` (28 IACT) | ✓ |
| **Pendiente Phase 1B** | |
| `analyze/mapping-br-cnst.md` | pending |
| `analyze/mapping-uc-cnst.md` | pending |
| `analyze/mapping-uc-fr.md` | pending |
| `analyze/mapping-uc-mod.md` | pending |
| **Pendiente Phase 1C** | |
| `analyze/decisions-d-req.md` | pending (7-9 decisiones) |

## Proximo paso

Phase 1B: generar 4 mapeos cruzados consolidando los 4 inventarios
(produce las matrices de trazabilidad bidireccional).

Phase 1C: documentar 7-9 decisiones D-REQ-N para resolver:

- D-REQ-1: nomenclatura modular para BRs (introducir o conservar flat)
- D-REQ-2: re-mapeo de UCs RPT/ALR/AUD divergentes (RSTs > PLAN_MAESTRO)
- D-REQ-3: cobertura FR (generar los 88% faltantes en este WP o diferir)
- D-REQ-4: nomenclatura NFR (adoptar ISO 25010 propuesto)
- D-REQ-5: tratamiento de los 12 BRs pedagogicos descartados (eliminar
  refs en otros WPs si existen)
- D-REQ-6: mapping CNST legacy → SRP-31 en metadata UC
- D-REQ-7: ¿agrupar requisitos por modulo en subdirs (como ya estan
  en el backup) o flat?
- D-REQ-8: profundidad de los UCs reescritos (preservar ~150-300 ln
  de los RST canonicos vs comprimir)
- D-REQ-9: ¿cuando se generan los BReqs (BRQ-AUTH-001 etc.) ya
  referenciados pero sin archivo dedicado?
