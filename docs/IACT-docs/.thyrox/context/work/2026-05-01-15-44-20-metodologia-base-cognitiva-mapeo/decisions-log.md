```yml
created_at: 2026-05-01 16:00:00
project: IACT-docs
work_package: 2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo
phase: Phase 1 — DISCOVER (cierre)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Decisions log — Mapeo metodologia base-cognitiva

Decisiones tomadas en este WP, basadas en lectura de:

- `source/base-cognitiva/_fundamentos-conceptuales/fnd-04..06`
- `source/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-02-metamodelo-trazabilidad.rst`
- `source/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles.rst`
- `source/normativa/procedimientos/proc-req-001..010, proc-req-019, proc-doc-007`
- `source/normativa/estandares/plantillas/tpl-breq-objetivos-negocio.rst`
- `source/requisitos/business-requirements/breq-001-visibilidad-metricas.rst` (artefacto vigente)
- `temp-holding/FASE 01..02/` (material no integrado)

## Correccion del survey previo

El documento `discover/temp-holding-deep-survey.md` declara en H-13 y
H-14 que faltan TPL_TRZ_Matriz_RTM y los procs PROC_Generacion_BReq /
PROC_Derivacion_BReq_BR en `source/`. **Esta afirmacion es
incorrecta** y se corrige con esta decisions-log:

- `proc-req-001-generacion-breq.rst` SI existe (proc-req-001).
- `proc-req-002-derivacion-breq-br.rst` SI existe (proc-req-002).
- `proc-doc-007-generacion-rtm.rst` SI existe (proc-doc-007).
- `proc-req-019-trazabilidad-requisitos.rst` SI existe.

Lo que **realmente falta** en `source/` despues del re-analisis:

| Faltante | Origen en temp-holding |
|----------|------------------------|
| 7 BReqs (BReq-002..008) | proc-req-001 prescribe 8, FND_05 lista 5, source tiene 1 |
| Plantilla `tpl-trz-matriz-rtm` | `temp-holding/FASE 02/.../templates/TPL_TRZ_Matriz_RTM_1_3_1.rst` |
| Index de business-requirements actualizado con los 8 BReqs | actualmente solo lista breq-001 |
| Mapping `BRQ-{cluster}-NNN` (legacy en UCs) → `BReq-NNN` (canonico) | construir nuevo (no existe en temp-holding) |

## Decisiones finales

### DEC-01: Convencion de nomenclatura BReq adoptada

**Decision**: adoptar la convencion canonica vigente en `source/`:

- **ID en metadata**: `BReq-NNN` (con guion, NNN de 3 digitos)
- **Nombre de archivo**: `breq-nnn-{descripcion-kebab}.rst`
- **Sin sufijo de modulo** (no usar `BReq_[MOD]` legacy de TPL_BReq)

**Justificacion**: el archivo existente
`source/requisitos/business-requirements/breq-001-visibilidad-metricas.rst`
ya aplica esta convencion y su fecha (2026-04-30) es posterior al
template legacy (2026-01-07). El artefacto vivo prevalece sobre el
template legacy.

**Resuelve**: INC-03 (naming inconsistente) — adoptamos un solo
modelo.

### DEC-02: Cantidad y categorias de BReq

**Decision**: 8 BReqs alineados con `proc-req-001` § 3 (categorias) y
extendidos con los 5 BReqs ejemplificados en `fnd-05` § 3.5:

| ID | Nombre propuesto | Categoria | Origen |
|----|------------------|-----------|--------|
| BReq-001 | Visibilidad de Metricas Operativas | Funcionalidad Core | EXISTE |
| BReq-002 | Reduccion Tiempo Resolucion Incidentes | Funcionalidad Core | FND_05 §3.5 |
| BReq-003 | Decisiones Operacionales Basadas en Datos | Funcionalidad Core | FND_05 §3.5 |
| BReq-004 | Cumplimiento de Seguridad y Auditoria | Seguridad | FND_05 §3.5 |
| BReq-005 | Integridad y Trazabilidad de Datos | Seguridad | FND_05 §3.5 |
| BReq-006 | Operacion Continua con SLA | Rendimiento | proc-req-001 §3 |
| BReq-007 | Integracion con IVR Operacional | Integracion | proc-req-001 §3 |
| BReq-008 | Comunicaciones Internas Controladas | Cumplimiento | proc-req-001 §3 + CNST-001/002 |

**Resuelve**: INC-01 (Modelo A vs B) — usamos solo Modelo A
extendido a 8 (alineado con proc-req-001 que pide 8).

### DEC-03: Manejo del modelo "BRQ-{cluster}-NNN" en UCs (52 referencias legacy)

**Decision**: las referencias `BRQ-{cluster}-NNN` en los UCs NO se
reescriben. Se preservan como **identificadores legacy** y se publica
una **tabla de mapping** `BRQ-{cluster}-NNN → BReq-NNN` como anexo
en `source/requisitos/business-requirements/index.rst`.

**Justificacion**: reescribir 61 UCs (5 splitted + 56 monoliticos)
para cambiar referencias es alto-costo y bajo-valor. Una tabla de
mapping resuelve el gap funcional de trazabilidad sin tocar artefactos
estables.

**Resuelve**: INC-02 (Modelo C no documentado) — el mapping documenta
el modelo C como capa secundaria con resolucion canonica via Modelo A.

### DEC-04: Cluster PERM (INC-04)

**Decision**: NO se incluye en este WP. Se registra como hallazgo
H-PERM-01 para WP futuro (`perm-cluster-traceability-normalization`).

**Justificacion**: PERM cluster usa `PRIORIDAD_NN/RNF/N` — un modelo
totalmente distinto. Normalizarlo implica reescribir 9 UCs PERM, lo
cual rompe el alcance acotado del WP.

### DEC-05: Plantilla TPL_BReq existente vs version completa de temp-holding

**Decision**: enriquecer la plantilla actual
`source/normativa/estandares/plantillas/tpl-breq-objetivos-negocio.rst`
con secciones que tiene la version mas completa de temp-holding
(`TPL_BReq_Objetivos_Negocio_1_0_0.rst`) y que faltan:

- Sec. 6 Restricciones (Negocio + CNST)
- Sec. 7 Dependencias (Depende De / Requerido Por)
- Sec. 8 Riesgos
- Sec. 9 Trazabilidad consolidada (BR/UC/CNST)

NO se cambia la nomenclatura del template (sigue siendo
`tpl-breq-objetivos-negocio.rst`), solo se extiende su contenido. Si
ya estan presentes esas secciones, se preservan.

### DEC-06: Plantilla TPL_TRZ_Matriz_RTM

**Decision**: integrar como
`source/normativa/estandares/plantillas/tpl-trz-matriz-rtm.rst`
adaptando la version mas reciente de temp-holding (v1.3.1) al formato
de las plantillas vigentes en source (kebab-case, meta directive
estandar, identifier `:_tpl-trz-matriz-rtm:`).

**Justificacion**: pieza central de trazabilidad referenciada por
proc-req-019 y proc-doc-007. Sin la plantilla, los procedimientos no
son ejecutables.

### DEC-07: Index de business-requirements

**Decision**: actualizar
`source/requisitos/business-requirements/index.rst` para:

1. Incluir los 8 BReqs en el toctree.
2. Anexar tabla de mapping BRQ-{cluster}-NNN → BReq-NNN (DEC-03).
3. Documentar la categorizacion (DEC-02).

### DEC-08: Trazabilidad downstream en cada BReq

**Decision**: cada BReq nuevo (BReq-002..008) declara explicitamente:

- BR derivadas (Nivel 1) — usando `:doc:` de
  `source/requisitos/reglas-negocio/br-NNN-*.rst`
- UC primarios (Nivel 3) — usando `:doc:` de
  `source/requisitos/casos-uso/{cluster}/uc-{cluster}-NN-*.rst`
- CNST aplicables — IDs canonicos
- BRQ legacy mapeados — para que el mapping table sea generable
  desde los BReqs

**Justificacion**: cumple proc-req-002 §4 paso 5 ("Identificar BR
Candidatas") y proc-req-019 trazabilidad bidireccional.

### DEC-09: Estados de los nuevos BReqs

**Decision**: estado inicial `Borrador` (no `Aprobado` como
breq-001). El motivo es que se generan por backfill metodologico y
deben ser revisados por el product owner antes de aprobacion. Esto
es coherente con `proc-doc-012-revision-artefactos.rst`.

### DEC-10: Decisiones D-04 / D-05 (FR plan, PARTEs Larman)

**Decision**: NO se integran en este WP. Se registran como WPs
futuros:

- `wp-fr-coverage-from-uc-derivation` — generar 393 FR estimados
  desde UCs (proc-req-009).
- `wp-base-cognitiva-pedagogical-extension` — integrar PARTEs
  detalladas Larman, Stakeholder, etc.

## Plan de ejecucion del loop (Phase 8 PLAN EXECUTION)

| Iter | Artefacto | Accion | Output | Build verify |
|------|-----------|--------|--------|--------------|
| L1 | decisions-log.md | Crear | Este documento | n/a |
| L2 | discover/temp-holding-deep-survey.md | Corregir H-13/H-14 | Survey actualizado | n/a |
| L3 | source/normativa/estandares/plantillas/tpl-trz-matriz-rtm.rst | Adaptar de temp-holding v1.3.1 | Plantilla nueva | make html |
| L4 | source/requisitos/business-requirements/breq-002-reduccion-tiempo-incidentes.rst | Crear | BReq-002 | (acumulado) |
| L5 | source/requisitos/business-requirements/breq-003-decisiones-basadas-datos.rst | Crear | BReq-003 | (acumulado) |
| L6 | source/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria.rst | Crear | BReq-004 | (acumulado) |
| L7 | source/requisitos/business-requirements/breq-005-integridad-trazabilidad-datos.rst | Crear | BReq-005 | (acumulado) |
| L8 | source/requisitos/business-requirements/breq-006-operacion-continua-sla.rst | Crear | BReq-006 | (acumulado) |
| L9 | source/requisitos/business-requirements/breq-007-integracion-ivr-operacional.rst | Crear | BReq-007 | (acumulado) |
| L10 | source/requisitos/business-requirements/breq-008-comunicaciones-internas-controladas.rst | Crear | BReq-008 | (acumulado) |
| L11 | source/requisitos/business-requirements/index.rst | Actualizar toctree + tabla mapping BRQ→BReq | Index nuevo | make html (verificar 0 nuevas warnings) |
| L12 | source/normativa/estandares/plantillas/tpl-breq-objetivos-negocio.rst | Enriquecer secciones DEC-05 (si aplica) | Template extendido | make html |
| L13 | wp-state.md | Cerrar Phase 1 DISCOVER, abrir Phase 10 EXECUTE done | wp-state actualizado | n/a |

Cada iteracion sera commit independiente.

Total: **13 iteraciones**, ~10 archivos nuevos, 2 archivos modificados.

## Hallazgos consolidados (post-decisiones)

- H-21: Modelo C de UCs (52 BRQ-{cluster}-NNN) se preserva como
  legacy con tabla de mapping (DEC-03).
- H-22: PERM cluster sigue fuera de scope (DEC-04).
- H-23: FR plan de 393 FRs queda como WP futuro (DEC-10).
- H-24: PARTEs Larman/UI Stakeholder pedagogicas quedan como WP
  futuro (DEC-10).
- H-25: Procs ya existentes (proc-req-001/002, proc-doc-007,
  proc-req-019) se preservan sin modificar — la decision es generar
  artefactos que ESOS procs prescriben.
