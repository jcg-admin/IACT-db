```yml
created_at: 2026-04-28 04:25:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 5 — STRATEGY (análisis de soporte)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis de soporte — Inventario de templates

Análisis que respalda la **Idea 6** (templates como contrato
estructural) y las **Decisions 5 y 6** del solution-strategy.md.

## 1. Inventario verificado

### 1.1 source/normativa/estandares/plantillas/ (22 archivos)

Templates "oficiales" actuales con versiones EN FILENAME (viola
STD_006):

```
TPL_BReq_Objetivos_Negocio_1_0_0.rst
TPL_BR_Business_Rules_1_0_0.rst
TPL_CNST_Restricciones_1_0_0.rst
TPL_MOD_Modulos_1_0_0.rst
TPL_FD_Flujos_Datos_1_0_0.rst
TPL_PROC_Procedimientos_1_0_0.rst
TPL_STD_Estandares_1_0_0.rst
TPL_RTM_Trazabilidad_1_0_0.rst
TPL_API_Documentacion_API_1_1_0.rst       ← v1.1.0
TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
TPL_INDEX_Indices_1_0_0.rst
TPL_UC_Casos_de_Uso_2_0_0.rst             ← v2.0.0
TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst
TPL_FR_Requisitos_Funcionales_1_0_0.rst
TPL_NFR_No_Funcionales_1_0_0.rst
TPL_002_Plantilla_UC_v2.rst               ← naming inusual
TPL_POL_Politicas_1_0_0.rst
TPL_TST_Pruebas_1_0_0.rst
```

Plus en otras ubicaciones de source/:
```
source/gestion/plantilla_adr.rst                                    ← snake, sin TPL_
source/normativa/procedimientos/PROC-GOB-001-mapeo_procesos_templates.rst  ← procedimiento
```

### 1.2 temp-holding/.../iact_templates_v1_3_0/ (set CURADO, 13 archivos)

Set agrupado en directorio dedicado, versión más reciente, con
`README.txt`:

```
TPL_TRZ_Matriz_RTM_1_3_0.rst
TPL_BR_Decision_Tipo_1_3_0.rst
TPL_UC_Construccion_7_Pasos_1_3_0.rst
TPL_UC_CRUD_Operaciones_1_2_0.rst         ← se quedó en 1_2
TPL_UC_Temporal_Schedulers_1_3_0.rst
TPL_UC_Actor_Secundario_1_3_0.rst
TPL_FR_Query_SQL_1_3_0.rst
TPL_UC_Larman_Contratos_1_2_0.rst         ← se quedó en 1_2
TPL_FR_Documentacion_10_Componentes_1_3_0.rst
TPL_FR_Validacion_Reglas_1_3_0.rst
TPL_UC_Stakeholder_Driven_1_3_0.rst
TPL_UC_UI_Driven_1_3_0.rst
README.txt
```

**Observación:** 7 patrones distintos de UC reconocidos:
Construccion_7_Pasos, CRUD_Operaciones, Temporal_Schedulers,
Actor_Secundario, Larman_Contratos, Stakeholder_Driven, UI_Driven.

### 1.3 temp-holding/FASE 02/tmp_work/ (variantes individuales)

~30+ archivos con versiones múltiples (1_2_0, 1_3_0). Notables:

- `TPL_BR_v1_2_0_P1.rst`, `_P2.rst`, `_P3.rst` — template BR
  partido en 3 archivos (¿split editorial intencional?)
- `TPL_UC_Construccion_7_Pasos_1_2_0.rst` y `_1_3_0.rst` — dos
  versiones del mismo template
- `TPL_UC_Construccion_7_Pasos_1_4_0.rst` aparece en
  `temp-holding/GENERACION_DOCUMENTACION/FASE 13/` — versión MÁS
  reciente que la del set curado v1_3_0
- `PROPUESTA_TEMPLATE_01.txt` ... `_10.txt` — 10 propuestas en
  texto plano

### 1.4 temp-holding/FASE 01/TLP_Templates/

Carpeta con typo en nombre ("TLP" vs "TPL"). Contiene:
```
ANALISIS_NOMENCLATURA_TPL_1_0_0.md
PLAN_GENERACION_TPL_1_0_0.md
```

### 1.5 Documentos de análisis previo del ejecutor

| Documento | Ubicación | Propósito |
|-----------|-----------|-----------|
| `ANALISIS_TEMPLATES_VERSIONES.md` | `temp-holding/FASE 02/tmp_work/` | Comparativa v1_0_0 vs v1_1_0 — cobertura de cada template, completitud (líneas, secciones, ejemplos) |
| `PLAN_TEMPLATES_3_12_v1_2_0.md` | `temp-holding/FASE 02/tmp_work/` | Plan de generación de templates |
| `ANALISIS_NOMENCLATURA_TPL_1_0_0.md` | `temp-holding/FASE 01/TLP_Templates/` | Análisis de nomenclatura de templates iniciales |
| `PLAN_GENERACION_TPL_1_0_0.md` | `temp-holding/FASE 01/TLP_Templates/` | Plan original de generación |
| `PROPUESTA_TEMPLATE_01..10.txt` | `temp-holding/FASE 02/tmp_work/` | 10 propuestas de templates en texto plano |

**Lección:** estos documentos son inputs obligatorios para el WP
`normativa/estandares` — ignorarlos es re-trabajo innecesario.

## 2. Versiones cruzadas — qué es canónico

| Tipo de template | source/ versión | iact_templates_v1_3_0 | tmp_work versión más alta | Canónico propuesto |
|-----------------|-----------------|------------------------|----------------------------|---------------------|
| TPL_UC_Construccion_7_Pasos | (no presente) | 1_3_0 | **1_4_0 (FASE 13)** | **1_4_0** |
| TPL_UC_Casos_de_Uso | 2_0_0 | (no — split en variantes) | (no) | Decidir: ¿2_0_0 o variantes 1_3_0? |
| TPL_BR | 1_0_0 | (no — solo Decision_Tipo) | 1_2_0 P1/P2/P3 (split) | Investigar split |
| TPL_FR_Requisitos_Funcionales | 1_0_0 | (no — solo specifics) | (no) | source/ v1_0_0 mantiene |
| TPL_FR_Query_SQL | (no presente) | 1_3_0 | 1_3_0 | **1_3_0** |
| TPL_TRZ_Matriz_RTM | (no presente) | 1_3_0 | 1_3_0 | **1_3_0** |
| TPL_CNST_Restricciones | 1_0_0 | (no presente) | (no) | source/ v1_0_0 mantiene |
| TPL_API_Documentacion_API | 1_1_0 | (no presente) | (no) | source/ v1_1_0 mantiene |
| TPL_ADR | 1_0_0 (+ plantilla_adr.rst en gestion/) | (no presente) | (no) | Reconciliar source/ |

**Conclusión:** ningún set único cubre todos los tipos. Triage caso
por caso es necesario.

## 3. Reglas para el rebuild de templates

### 3.1 Renombrado obligatorio (STD_006 + STD_007)

Todos los templates en el nuevo `source/normativa/estandares/plantillas/`
DEBEN seguir:
- Filename SIN versión: `TPL_BR_Decision_Tipo.rst` (no `_1_3_0`).
- Versión en metadata YAML: `:version: 1.3.0`.
- Patrón STD_007 4.1: `TPL_<KEY>_<Desc_PascalCase>.rst`.

### 3.2 Cobertura mínima por tipo

El nuevo `plantillas/` debe contener al menos:
- TPL para cada tipo de artefacto que se va a producir en el rebuild:
  UC, BR, FR, NFR, ADR, CNST, MOD, FD, PROC, STD, RTM, API, INDEX,
  VIEW, BReq, POL, TST, TRZ.
- Las múltiples variantes de UC (CRUD, Larman, Stakeholder_Driven,
  UI_Driven, Temporal_Schedulers, Actor_Secundario,
  Construccion_7_Pasos) se conservan COMO ARCHIVOS SEPARADOS — son
  patrones distintos, no redundancia.

### 3.3 Pre-condición de cierre del WP `normativa/estandares`

- Todos los STDs reescritos.
- Todos los templates incorporados, renombrados, con versión en
  metadata.
- `index.rst` de `plantillas/` lista todos.
- Build sin warnings de templates rotos (refs internas válidas).

### 3.4 Pre-condición de apertura del WP `requisitos`

- WP `normativa/estandares` cerrado y aprobado.
- Templates de UC, BR, FR, NFR disponibles y validados.
- Triage de variantes de UC documentado (qué patrón usa cada UC).

## 4. Acciones para el WP `normativa/estandares`

Cuando se abra ese WP, su discover debe incluir:

1. Lectura completa de `ANALISIS_TEMPLATES_VERSIONES.md` y
   `PLAN_TEMPLATES_3_12_v1_2_0.md` antes de cualquier decisión.
2. Lista exhaustiva de todos los TPL_* a producir en el nuevo
   `plantillas/`.
3. Triage por cada template: source/ vs temp-holding vs
   iact_templates_v1_3_0 → elegir canónica con justificación.
4. Tarea explícita de renombrado con migración de versión a
   metadata.
5. Validación: cada template tiene metadata YAML completa, sigue
   STD_007 en filename, no tiene refs rotas.

## 5. Riesgos identificados

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Elegir versión obsoleta como canónica (ej: source/ v1_0_0 cuando temp-holding tiene v1_3_0 superior) | Re-trabajo posterior si se descubre tarde | Lectura obligatoria de análisis previos del ejecutor |
| Las 7 variantes de UC se interpretan como redundancia y se fusionan | Pérdida de semántica de patrones distintos | Documentar explícitamente que son patrones, no versiones |
| `TPL_BR_v1_2_0_P1/P2/P3` (split) se reincorpora sin entender por qué se partió | Template fragmentado sin razón clara | Investigar el split antes de incorporar |
| Renombrar templates rompe refs en source/ actual antes del rebuild | Build con warnings durante transición | El rebuild dominio-por-dominio + bridge plan absorbe esto |
