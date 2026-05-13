```yml
project: IACT-docs
work_package: 2026-04-28-05-28-41-source-rebuild-normativa-estandares
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #2 of 16
created_at: 2026-04-28 05:28:41
current_phase: Phase 11 — TRACK (CERRADO — 0 warnings, 0 errors, todos los deep-review hallazgos resueltos)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO — 2026-04-28 07:55 (build limpio, todos los hallazgos de los 3 deep-review aplicados)
opened_at: 2026-04-28 06:30:00
closed_at: 2026-04-28 07:55:00
```

# WP-hijo #2 — Source Rebuild: normativa/estandares

## Propósito

Reconstruir `source/normativa/estandares/` (~10 STDs + carpeta
`plantillas/` con 22+ templates). Este dominio define las **reglas
universales** (STDs) y los **moldes** (templates) que el resto de
los dominios va a usar.

## Capa

**Methodology / Governance** (capa 1).

## Pre-condiciones

- WP #1 `source-rebuild-base-cognitiva` cerrado.
- Vocabulario de glosario disponible (H3 del padre).

## Decisiones del padre que aplican

- **Decision 5 (sub-orden interno):** STDs → templates → resto.
- **Decision 6 (triage de templates):** caso por caso con inputs
  obligatorios.
- **Idea 6 (templates como contrato estructural).**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Sub-orden STDs → templates → resto** | Task plan del WP-hijo agrupa en 3 bloques. |
| **Triage de templates** | Para cada tipo (UC, BR, FR, NFR, ADR, CNST, MOD, FD, PROC, STD, RTM, API, INDEX, VIEW, BReq, POL, TST, TRZ): listar versiones existentes, elegir canónica con justificación, renombrar a `TPL_KEY_Desc.rst` (sin versión en filename), mover versión a metadata YAML. |
| **Conservar 7 variantes UC como templates separados** | NO fusionar: CRUD, Larman_Contratos, Stakeholder_Driven, UI_Driven, Temporal_Schedulers, Actor_Secundario, Construccion_7_Pasos. |
| **Crear `STD_Naming_Identificadores`** (heredado de WP #1) | Principios: (a) clean code en código y artefactos; (b) nombres de funciones, métodos, clases y variables **autoexplicativos** (sin necesidad de saber el dominio para entenderlos); (c) las **abreviaturas de dominio** (SoD, RBAC, ETL, PII, etc.) NO deben aparecer en identificadores técnicos — sí en narrativa cuando estén definidas en glosario. Ejemplo aplicado en MTM_03: `validateSoD` → `validateRoleConflict`. |
| **Crear `STD_Profesional_Documentacion`** (heredado de WP #1) | **Convención completa ya provista por el ejecutor** — formalizar como STD del proyecto. Contenido: (1) lenguaje profesional/técnico obligatorio; (2) frases prohibidas con alternativas: "Regla de Oro" → "Core Principle / Critical Standard", "Principio Unix" → "Core Principle / Architectural Principle", "Los 5 Pilares" → "Five Core Principles", "Si tienes que..." → reformular, "Recuerda que..." → "Note that..." / "Important:", "Para recordar:" → estructurar como lista o heading; (3) heading styles: `# TITLE` (all caps), `## SECTION` (Title Case), `### SUBSECTION` (Title Case); (4) prohibición de headings decorativos ("La Magia de X", "Los Secretos de X") y sub-headings informales ("Recuerda:", "No Olvides:"); (5) tono técnico, directo, formal pero no rígido; (6) inglés preferido si el documento es en inglés; (7) consistencia terminológica. **Audit hecho durante WP #1 base_cognitiva: cero ocurrencias actuales de frases prohibidas en source/** (excepto "Regla de Oro" en SBVR_05 ya fixeado). El STD aplica a todos los documentos futuros. |

## Inputs obligatorios (lectura previa al discover)

5 análisis previos del ejecutor (de `temp-holding/`):

1. `temp-holding/FASE 02/tmp_work/ANALISIS_TEMPLATES_VERSIONES.md`
2. `temp-holding/FASE 02/tmp_work/PLAN_TEMPLATES_3_12_v1_2_0.md`
3. `temp-holding/FASE 01/TLP_Templates/ANALISIS_NOMENCLATURA_TPL_1_0_0.md`
4. `temp-holding/FASE 01/TLP_Templates/PLAN_GENERACION_TPL_1_0_0.md`
5. `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_01..10.txt`
   (10 archivos)

Plus análisis del padre: `strategy/templates-inventory-analysis.md`.

## Alcance

**In-scope:** STDs reescritos, templates triageados/renombrados,
`plantillas/index.rst`, build verde.

**Out-of-scope:** generar/modificar UCs, BRs, FRs concretos (eso es
WP #6); aplicar templates a artefactos del producto.

## Pre-condición de cierre del padre que activa este WP-hijo

- Salida de este WP-hijo es **input hard de WP #6 requisitos**
  (H1 cross-WP dependency).

## Estado

**Borrador (no iniciado).** Spawneado por T-009.
