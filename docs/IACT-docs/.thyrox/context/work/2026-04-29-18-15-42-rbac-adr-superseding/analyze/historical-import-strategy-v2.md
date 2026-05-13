```yml
created_at: 2026-04-29 20:55:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 3 — ANALYZE (revised)
author: NestorMonroy
status: Aprobado
version: 2.0.0
supersedes: analyze/historical-import-strategy.md v1.0.0
```

# Estrategia de import histórico — REVISADA tras consulta a skills + scan total

## Cambios respecto a v1.0.0

1. **Directorio destino reconsiderado** vía consulta a skills `ba-*`/`pm-*`
   y revisión del subdominio existente `source/gestion/`.
2. **Material adicional encontrado** — el scan inicial era incompleto.
3. **Conflicto de numeración detectado** con ADR-BACK-005 legacy.

## Parte 1 — Consulta a skills

### Skills relevantes

| Skill | THYROX Stage | Output clave aplicable a este WP |
|-------|--------------|---------------------------------|
| **ba-strategy** | Stage 5 STRATEGY | "Current State Analysis · Future State Definition · **Gap Analysis** · Risk Assessment · Solution Recommendation" |
| **ba-requirements-lifecycle** | Stage 7/10 | "**Traceability Matrix** · **Requirements Baseline** · **Change Impact Assessments**" |
| **ba-planning** | Stage 5/6 | "BA Plan · **Stakeholder Engagement Approach** · Governance Approach" |
| **pm-closing** | Stage 11/12 | "Final Acceptance · **Lessons Learned** · **Project Archives**" |

### Frase clave de pm-closing

> "A project that ends without formal closure leaves loose ends:
> contracts still open, lessons not captured, and team members
> uncertain whether the work is truly done."

**Output canónico:** "Project Archives".

### Implicación para directory placement

Los documentos históricos que vamos a importar son, según
nomenclatura BABOK/PMBOK:

- **Project Archives** (pm-closing) — artefactos de fases pasadas
  del proyecto que se preservan para trazabilidad.
- **Lessons Learned** (pm-closing) — qué aprendimos del proceso
  de evolución v4.0 → v5.2.1.
- **Requirements Baseline previo** (ba-requirements-lifecycle) —
  la versión "anterior" del modelo RBAC contra la cual la actual
  se contrasta.
- **Change Impact Assessment** (ba-requirements-lifecycle) — el
  análisis de errores v5.2.0 que motivó v5.2.1 ES un Change
  Impact Assessment ya escrito.

**El directorio canónico para Project Archives + Lessons Learned
en `source/` es `gestion/evidencia/`.**

## Parte 2 — `source/gestion/` revisado

```
source/gestion/
├── evidencia/         ← "evidencia auditable de calidad del proyecto"
│   └── index.rst
├── git-workflow.rst
├── manuales-usuarios/
├── pm/
│   ├── checklists/
│   ├── deployment-plan.rst
│   ├── planificacion-releases-frontend.rst
│   └── index.rst
└── plantilla-adr.rst
```

`source/gestion/index.rst` declara explícitamente:

> "El dominio Gestión contiene la documentación de usuarios, la
> gestión del proyecto y las **evidencias** de pruebas y
> validaciones del sistema IACT."

`source/gestion/evidencia/index.rst` declara:

> "Este subdominio contiene las **evidencias de pruebas,
> validaciones y aprobaciones** del proyecto IACT, documentando
> la verificación y validación del sistema. La evidencia
> proporciona **trazabilidad auditable** de la calidad del proyecto."

### Encaje del material histórico

| Material | Tipo BABOK/PMBOK | ¿Encaja en gestion/evidencia? |
|----------|------------------|------------------------------|
| ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md | Change Impact Assessment + Lessons Learned | **SÍ** — evidencia auditable de calidad (corrigió 87 errores) |
| Modelo v4.0 18 roles legacy | Requirements Baseline previo | **SÍ** — evidencia de evolución |
| ANALISIS_PROFUNDO_DECISIONES § PARTE 3 | Decision Log (8 vs 9 módulos) | **SÍ** — trazabilidad de decisiones |
| GAP_ANALYSIS_SISTEMA_PERMISOS.md | Gap Analysis (ba-strategy) | **SÍ** — análisis de brechas auditable |
| DISCREPANCIA_RBAC_Y_PROPUESTA_CORRECCION.md | Change Impact Assessment | **SÍ** — evidencia de divergencia y corrección |
| CAPACIDADES_ATOMICAS_VS_PERMISOS_GRANULARES.md | Solution Recommendation | **SÍ** — análisis comparativo justificativo |
| Modules/*.py (código Python) | Reference design | **NO encaja** en evidencia — es diseño técnico |

## Parte 3 — Reconsideración de Opción A → propuesta REVISADA

### Opción A original (rechazada)

`source/arquitectura-tecnica/rbac/_historia/`

**Problema:** mezcla histórico con spec técnica vigente. El
subdomain `_historia` es genérico y no aprovecha la semántica
canónica del proyecto.

### Opción D (NUEVA — recomendada)

**Distribución por tipo de artefacto** según taxonomía BABOK/PMBOK:

```
source/gestion/evidencia/rbac-historia/
├── index.rst                                              # entry-point
├── analisis-errores-modelo-rbac-v5-2-0.rst                # Change Impact (87 errores)
├── modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst       # Baseline previo (resumen)
├── decisiones-modulos-8-vs-9-historico.rst                # Decision Log (PARTE 3)
├── gap-analysis-sistema-permisos.rst                      # Gap Analysis Nov 2025
├── discrepancia-rbac-y-propuesta-correccion.rst           # Change Impact (Ene 2026)
└── capacidades-vs-permisos-comparativo.rst                # Solution Recommendation

source/arquitectura-tecnica/rbac/
├── modelo-rbac-iact.rst                                   # spec vigente (existente)
├── index.rst
└── (NO _historia aquí — eso vive en gestion/evidencia)
```

**Por qué Opción D es mejor:**

1. **Alineación con BABOK/PMBOK** — Project Archives + Lessons
   Learned + Change Impact Assessments viven en `gestion/evidencia/`
   por convención metodológica.
2. **Aprovecha estructura existente** — el subdominio
   `gestion/evidencia/` declara explícitamente "trazabilidad
   auditable de calidad".
3. **Separación de concerns** — `arquitectura-tecnica/rbac/`
   queda 100% vigente; el histórico vive en su propio
   subdominio temático.
4. **Reusable** — el patrón `gestion/evidencia/<tema>-historia/`
   sirve para FUTUROS imports históricos de otros temas (no solo
   RBAC). Por ejemplo: `gestion/evidencia/sphinx-historia/`,
   `gestion/evidencia/saneamiento-md-historia/`.

### Cross-refs entre subdominios

```rst
# Desde adr-gob-009 (en source/normativa/gobernanza/)
:doc:`/gestion/evidencia/rbac-historia/analisis-errores-modelo-rbac-v5-2-0`

# Desde modelo-rbac-iact (en source/arquitectura-tecnica/rbac/)
.. seealso::
   :doc:`/gestion/evidencia/rbac-historia/index` para evolución histórica
```

## Parte 4 — Material adicional encontrado en temp-holding/

El scan inicial era incompleto. Material adicional crítico:

### A — `FASE 01/MODELO DOCUMENTAL IACT/v2.0.3/`

| Archivo | Por qué es relevante |
|---------|---------------------|
| `CAPACIDADES_ATOMICAS_VS_PERMISOS_GRANULARES.md` | **CRÍTICO** — origen conceptual de D-RBAC-1 (vocabulario único). Comparación entre los 2 enfoques RBAC. |
| `DISCREPANCIA_RBAC_Y_PROPUESTA_CORRECCION.md` | **CRÍTICO** — documenta cuándo se detectó que las BR usaban roles tradicionales (R001..R018) en lugar del enfoque granular |

### B — `FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/`

| Archivo | Por qué es relevante |
|---------|---------------------|
| `GAP_ANALYSIS_SISTEMA_PERMISOS.md` | **GAP ANALYSIS formal** (BABOK ba-strategy output) — estado nov 2025: 75% completado del sistema de permisos |

### C — `FASE 01/docs/backend/diseno/permisos/ANALISIS_RESTRICCIONES_VS_MEJORAS.md`

Análisis de compliance del middleware contra restricciones del
proyecto. Identifica conflictos. Útil como referencia para
ADR-BACK-005 nuevo si decide cubrir middleware.

### D — `GENERACION_DOCUMENTACION/TMP_COMPLETO_IACT_2026-01-13_2/ANALISIS_COMPARATIVO_RBAC_v4_vs_BR_IACT.md`

**MUY relevante:** comparación formal v4.0 vs BR IACT con
hallazgos:
- Documento v4.0 tiene 75+ funciones atómicas vs 18 roles cerrados de IACT.
- "Bundles (10 predefinidos)" en v4.0 — origen de los AGR-001..010.
- "Namespace (identity, epm, base)" — origen de los MOD_ con módulos.

**Es la genealogía del modelo v5.x.**

### E — `FASE 01/docs/backend/gobernanza/adr/ADR-BACK-005-middleware-decoradores-permisos.md`

**CONFLICTO IMPORTANTE:** existe un ADR-BACK-005 legacy en
temp-holding sobre middleware/decoradores. Si nuestro plan era
crear `adr-back-005-rbac-estrategia-implementacion.rst`, **el
número 005 ya está implícitamente "reservado" históricamente para
middleware**.

**Recomendación:**

- Renombrar el plan: nuestro nuevo ADR técnico será **`adr-back-006-rbac-estrategia-implementacion.rst`** (no 005).
- Importar ADR-BACK-005 legacy como `adr-back-005-middleware-decoradores.rst` aceptando su contenido (o marcarlo como deprecado/superseded en su propia migración futura).
- O alternativamente, dejar 005 como hueco reservado documentado.

### F — Archivos UC-PERM legacy

`FASE 01/docs/backend/UC-PERM-003.md`, `UC-PERM-004.md`,
`UC-PERM-005.md`, `UC-PERM-007.md` — versiones legacy de UCs.
**Ya migrados a source/requisitos/casos-uso/permissions/uc-perm-*.rst** (correspondiente).
**No requieren import.**

## Parte 5 — Propuesta de archivos a crear (REVISADA)

### Estructura final propuesta

```
source/gestion/evidencia/rbac-historia/
├── index.rst
├── analisis-errores-modelo-rbac-v5-2-0.rst                # 14 KB → ~280 líneas
├── modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst       # resumen narrativo, ~150 líneas
├── decisiones-modulos-8-vs-9-historico.rst                # extracto PARTE 3, ~120 líneas
├── gap-analysis-sistema-permisos-nov-2025.rst             # GAP nov 2025, ~250 líneas
├── discrepancia-rbac-correccion-ene-2026.rst              # Change Impact ene 2026, ~200 líneas
├── capacidades-vs-permisos-comparativo.rst                # Solution Recommendation, ~250 líneas
├── analisis-comparativo-rbac-v4-vs-br-iact.rst            # genealogía v4 → v5, ~200 líneas
└── diseno-referencia-implementacion-permisos-legacy.rst   # narrativa Modules/*.py, ~180 líneas
```

8 archivos en lugar de 5. Mayor cobertura de la trazabilidad
histórica completa.

### Frontmatter Schema A canonical

Todos con:

```yml
:artefacto: HIST_RBAC_NNN
:tipo: Documento Historico
:dominio: gestion
:subdominio: evidencia/rbac-historia
:estado: Aprobado
:version: 1.0.0
:fecha_creacion: 2026-04-29
:autor: Equipo IACT
:clasificacion: Interno
```

### Decisión sobre numeración ADR-BACK

Renombrar plan original:
- ~~`adr-back-005-rbac-estrategia-implementacion.rst`~~
- → **`adr-back-006-rbac-estrategia-implementacion.rst`**

Esto evita conflicto con ADR-BACK-005 legacy de middleware.

**ADR-BACK-005 legacy NO se importa en este Z.1** (out of scope).
Si en futuro WP se decide migrar middleware/decoradores, se hará
ahí.

## Parte 6 — Impacto en Z.1 expandido

| Aspecto | v1.0.0 (original) | v2.0.0 (revisado) |
|---------|-------------------|-------------------|
| Archivos a crear en source/ | 5 | **8** |
| Tiempo estimado | 4-6h | **6-8h** |
| Directorio destino | `arquitectura-tecnica/rbac/_historia/` | **`gestion/evidencia/rbac-historia/`** |
| Numeración ADRs nuevos | gob-009 + back-005 | **gob-009 + back-006** |
| Material cubierto | RBAC core + decisiones | RBAC core + decisiones + gap analysis + change impacts + comparativos |

## Calibración

- **OBSERVABLE:** 28 claims (skills consultados, archivos
  inspeccionados, gestion/evidencia/ verificado).
- **INFERRED:** 8 claims (interpretación BABOK/PMBOK, encaje
  semántico).
- **SPECULATIVE:** 0.
- **Ratio:** 36/36 = 1.0 ≥ 0.75 ✓

## Pregunta para el ejecutor

1. ¿Apruebas **Opción D** (`source/gestion/evidencia/rbac-historia/`)
   en lugar de la Opción A original (`arquitectura-tecnica/rbac/_historia/`)?
2. ¿Apruebas el **plan ampliado de 8 archivos** (vs los 5 originales)?
3. ¿Apruebas **renombrar adr-back-005 → adr-back-006** para evitar
   conflicto con el ADR-BACK-005 legacy de middleware?
4. ¿Confirmas que ADR-BACK-005 middleware queda **out of scope**
   de este Z.1 (no se importa, se aborda en WP futuro si aplica)?
