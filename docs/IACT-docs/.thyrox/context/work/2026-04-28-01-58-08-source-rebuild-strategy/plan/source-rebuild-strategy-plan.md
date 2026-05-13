```yml
created_at: 2026-04-28 04:55:00
wp: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 6 — PLAN
status: Aprobado — 2026-04-28 05:15 (ejecutor: si)
```

# Plan — Source Rebuild Strategy (WP-padre)

## Scope Statement

**Problema:** `source/` (379 archivos RST, 34 patrones de naming, 147
hyperlinks rotos, contenido técnico disperso) no refleja la estructura
real del producto IACT (React+Webpack / DRF / Ubuntu+Apache /
MySQL+PostgreSQL) ni su ciclo de vida. La doc publicada está
mezclada metodológicamente y le faltan cajones técnicos completos.

**Usuarios:**
- Devs (frontend, backend, devops, DBA) que necesitan localizar
  decisiones, convenciones y runbooks de su tier.
- Tech leads que validan ADRs y estándares.
- PMs/stakeholders que consultan roadmap, épicas, releases.
- Nuevos contribuidores que entran vía onboarding.

**Criterios de éxito:**
- Build con `sphinx-build -W` exit 0 sobre `source/` reconstruido
  (verificable mediante CI `validate.yml`).
- 16 WPs-hijos abiertos con su `wp-state.md` válido y referencia
  cruzada al padre (verificable: `find .thyrox/context/work/ -name
  wp-state.md | xargs grep -l "parent: source-rebuild-strategy"`
  → 16 hits).
- Estructura de `source/` cumple las 3 capas de strategy v2.0
  (verificable: `find source -maxdepth 1 -type d` lista los
  cajones methodology + spec/tech + lifecycle).
- 0 referencias en `source/` a `temp-backup/` o `temp-holding/`
  (verificable con grep).
- ROADMAP.md actualizado con ÉPICA 8 y los 16 sub-WPs.

---

## In-Scope

Este WP-padre **no reconstruye `source/`**. Spawnea, coordina y
cierra cuando el plan está aprobado. Concretamente:

- Producir este `plan.md` con scope/dependencies/risks (in scope).
- Listar formalmente los 16 WPs-hijos con su naming, dependencies
  y acceptance criteria por tipo.
- Definir las 5 sub-decisiones D-CNST-1..5 que el WP-hijo
  `restricciones` debe resolver (sin resolverlas acá).
- Documentar los handoffs cross-WP críticos (6 hard dependencies).
- Asignar las pre-tareas (creación de `temp-backup/`, cleanup,
  fix de tech-skill).
- Actualizar `ROADMAP.md` con la ÉPICA y los WPs-hijos pendientes.
- Producir `track/source-rebuild-strategy-changelog.md` extendido
  con el cierre del WP-padre.

---

## Out-of-Scope

| Excluido | Razón |
|---|---|
| Reconstrucción del contenido de `source/` archivo por archivo | Trabajo de los 16 WPs-hijos; cada uno con su propio ciclo THYROX (Decision 8). |
| Crear `temp-backup/source-2026-04-28/` | Pre-tarea del WP-hijo #1 (base_cognitiva), ver §"Pre-tareas asignadas". |
| Triage de los 5 backups anidados de `temp-holding/` (F-NEW-2) | Pre-tarea del WP-hijo #1 (base_cognitiva). |
| Resolver D-CNST-1..5 (numeración, huérfanas, v2.0.0, gap, sub-categorías) | WP-hijo #4 (restricciones) — diferidas explícitamente, ver §"Decisiones diferidas". |
| Triage de versiones de templates (Decision 6) | WP-hijo #2 (estandares). |
| Generar `backend-django.instructions.md` (F-NEW-8, Decision 11) | WP `bootstrap-hardening` (paralelo, externo a los 16). |
| Documentar código de backend/frontend/infra/db | Skeleton-first (Decision 12 + Idea 9): solo overview+conventions ahora; sub-WPs futuros documentan código cuando exista. |
| Cleanup de `temp-backup/` y `temp-holding/` | Pre-tarea del WP-hijo #15 (risks-technical-debt) — último tech antes de gestion. |
| Promover entradas a `CHANGELOG.md` raíz | Solo en merge a main con bump de versión (rule changelog-policy.md). |
| Spinoff de extensions Sphinx custom (breadcrumb, autotoctree, metadata_schema, version_injection de v2.0) | Fuera de scope inicial; evaluar en track de cada WP-hijo si Furo built-in no basta. |
| Setup Algolia / search avanzada | Furo built-in basta hasta >1000 archivos (D-V2-7). |

---

## Los 16 WPs-hijos

Patrón de naming: `YYYY-MM-DD-HH-MM-SS-source-rebuild-{dominio}`.
Cada WP-hijo es spinoff con `parent: source-rebuild-strategy` en su
`wp-state.md` y referencia al `solution-strategy.md` del padre.

| # | WP-hijo | Capa | Tamaño | Pre-condiciones | Pre-tareas absorbidas |
|---|---------|------|--------|-----------------|------------------------|
| 1 | `source-rebuild-base-cognitiva` | Methodology | mediano | ninguna (primero) | F-NEW-2 (triage 5 backups), creación `temp-backup/source-2026-04-28/` |
| 2 | `source-rebuild-normativa-estandares` | Methodology | mediano | #1 cerrado | Sub-orden interno STDs→templates→resto (Decision 5); triage de templates (Decision 6, D-V2-2/STD_008 si aprobado) |
| 3 | `source-rebuild-normativa-procedimientos` | Methodology | mediano | #2 cerrado | — |
| 4 | `source-rebuild-normativa-restricciones` | Methodology | grande | #2 cerrado (templates necesarios) | Reconciliación CNST + D-CNST-1..5 (Decision 7) |
| 5 | `source-rebuild-normativa-gobernanza` | Methodology | mediano | #4 cerrado | ADRs internos del proyecto |
| 6 | `source-rebuild-requisitos` | Spec | grande | #2 + #4 cerrados | UCs/FRs/NFRs/BRs basados en templates + CNSTs reconciliadas |
| 7 | `source-rebuild-arquitectura-tecnica` | Spec/Tech | mediano | #6 cerrado | Architecture overview; absorbe `plantuml-guide/` |
| 8 | `source-rebuild-backend` | Tech (skeleton) | pequeño | #7 + bootstrap-hardening cerrados | DRF — solo overview.rst + conventions.rst |
| 9 | `source-rebuild-frontend` | Tech (skeleton) | pequeño | #7 cerrado | React + Webpack |
| 10 | `source-rebuild-infrastructure` | Tech (skeleton) | pequeño | #7 cerrado | Ubuntu + Apache |
| 11 | `source-rebuild-databases` | Tech (skeleton) | pequeño | #7 cerrado | MySQL + PostgreSQL (cajón propio, D-TECH-3) |
| 12 | `source-rebuild-operations` | Tech (skeleton) | pequeño | #8-11 cerrados | Deployment, monitoring, runbooks |
| 13 | `source-rebuild-onboarding` | Tech (skeleton) | pequeño | #8-11 cerrados | Dev quickstart |
| 14 | `source-rebuild-quality` | Tech (skeleton) | pequeño | #8-11 cerrados | Testing strategy |
| 15 | `source-rebuild-risks-technical-debt` | Tech (skeleton) | pequeño | #8-14 cerrados | TD log; **cleanup de `temp-backup/` y `temp-holding/`**; recuperar `-W` (Decision 3 final) |
| 16 | `source-rebuild-gestion` | Lifecycle | mediano | #15 cerrado | charter/roadmap/épicas/sprints/releases/retros/team |

**Tamaños estimados** (orientativo, cada WP-hijo confirma en su Phase 1):
- Pequeño: ~3-8 archivos finales en `source/`, 5-10 tareas T-NNN.
- Mediano: ~10-30 archivos, 15-30 tareas.
- Grande: ~50+ archivos, 30+ tareas.

---

## Cross-WP dependencies (handoffs críticos)

Las 6 dependencias hard que el plan formaliza para evitar bloqueos:

| # | Dependencia | Tipo | Razón |
|---|-------------|------|-------|
| H1 | WP #2 estandares → WP #6 requisitos | hard | Templates UC/BR/FR/NFR deben estar listos antes de generar UCs. |
| H2 | WP #4 restricciones → WP #6 requisitos | hard | CNSTs reconciliadas + tabla de mapeo viejo→nuevo necesaria; UCs no pueden referenciar CNSTs ambiguas. |
| H3 | WP #1 base_cognitiva → todos | soft (vocabulario disponible) | Sin glosario+ontología consolidada, los demás dominios pueden usar términos inconsistentes. |
| H4 | WP `bootstrap-hardening` → WP #8 backend | hard | `backend-django.instructions.md` activo (F-NEW-8 fixeado) antes de que Claude sugiera convenciones backend. |
| H5 | WP #7 arquitectura_tecnica → WPs #8-11 (tech) | hard | Architecture overview existe antes de que los cajones técnicos referencien decisiones de arquitectura. |
| H6 | WP #15 risks-technical-debt → cierre del WP-padre | hard | Cleanup `temp-backup/` y `temp-holding/`; verificar build con `-W` exit 0 antes de cerrar el padre. |

---

## Pre-tareas asignadas a WPs-hijos específicos

| Pre-tarea | WP-hijo asignado | Sección del WP donde se documenta |
|-----------|------------------|------------------------------------|
| Crear `temp-backup/source-2026-04-28/` con snapshot del source/ actual | #1 base_cognitiva | discover/, primera tarea T-001 |
| Triage de los 5 backups anidados de `temp-holding/` (F-NEW-2) | #1 base_cognitiva | discover/ |
| Triage de versiones de templates (Decision 6 — input obligatorio: ANALISIS_TEMPLATES_VERSIONES.md, PLAN_TEMPLATES_3_12_v1_2_0.md, ANALISIS_NOMENCLATURA_TPL_1_0_0.md, PLAN_GENERACION_TPL_1_0_0.md, PROPUESTA_TEMPLATE_01..10.txt) | #2 normativa-estandares | discover/ |
| Reconciliación CNST + tabla de mapeo viejo→nuevo (Decision 7 + D-CNST-1..5) | #4 normativa-restricciones | discover/ + strategy/ |
| F-NEW-8 fix (backend-nodejs → backend-django guideline) | `bootstrap-hardening` (externo) | `bootstrap-hardening` track changelog |
| Cleanup `temp-backup/` + `temp-holding/` + recuperar `-W` (Decision 3 final) | #15 risks-technical-debt | last EXECUTE step |
| Setup `gestion/` con sub-cajones charter/roadmap/épicas/releases/retros/team (Decision 13 — escritos a mano, no auto-generados) | #16 gestion | execute/ |

---

## Decisiones diferidas a WPs-hijos

Listado explícito para evitar que las decisiones se reinventen o
se omitan al abrir cada WP-hijo. Cada WP-hijo debe leer la decisión
diferida en su Phase 1 DISCOVER.

### Diferidas a WP #2 normativa-estandares

- **Sub-orden interno** STDs → templates → resto (Decision 5).
- **Triage de versiones de templates** caso por caso (Decision 6).
  Inputs obligatorios: 5 documentos de análisis previo del ejecutor
  (ver `templates-inventory-analysis.md` §1.5 + §4).
- **Conservación de las 7 variantes UC** como templates separados
  (no fusionar): CRUD, Larman_Contratos, Stakeholder_Driven,
  UI_Driven, Temporal_Schedulers, Actor_Secundario,
  Construccion_7_Pasos.
- **Renombrado de templates** STD_006: versión a metadata, sin
  versión en filename.
- **(Opcional, si D-V2-2 se aprueba en futuro WP)** Crear
  `STD_008_Metadata_Documentos.rst`.

### Diferidas a WP #4 normativa-restricciones

- **D-CNST-1:** ¿Numeración nueva consistente, o respetar la de
  source/?
- **D-CNST-2:** ¿Cómo se manejan las CNSTs huérfanas (presentes
  en uno solo de los lados)? ¿Se incorporan, descartan, fusionan?
- **D-CNST-3:** ¿Qué hacer con `CNST_05_Restriccion_Creacion_
  Iterativa_2_0_0.rst` (v2.0.0 standalone)?
- **D-CNST-4:** Llenar el gap CNST_011 — ¿con qué contenido?
- **D-CNST-5:** Sub-categorías (seguridad, performance, datos,
  infra) — ¿flat por número o agrupadas?

Inputs obligatorios para resolver: `RESTRICCIONES_COMPLETAS_DEL_
SISTEMA_IACT.md`, `ACTUALIZACION_DEL_ARBOL_SECCION_
RESTRICCIONES.md`, `restricciones-divergence-analysis.md` (este
WP-padre §4).

### Diferidas a WPs #8-15 (cajones técnicos)

- **Profundidad inicial** mínima: solo `index.rst` + `overview.rst`
  + `conventions.rst` (Decision 12).
- **Re-autoría con versión 1.0.0 fresh** — no migración mecánica
  (Decision 10). Excepto cuando exista versión superior documentada
  (preservar con justificación).

### Diferidas a WP #16 gestion

- **Decisión por sub-cajón** (charter, roadmap, épicas, sprints,
  releases, retros, team): qué se publica, en qué nivel de
  detalle, frecuencia de actualización.
- **Independencia source ↔ .thyrox** (Decision 13): ningún
  contenido de `gestion/` se auto-genera desde `.thyrox/`.

---

## Acceptance criteria por tipo de WP-hijo

Criterios mínimos verificables por tipo. Cada WP-hijo confirma
en su Phase 1 si necesita criterios adicionales.

### Methodology WPs (#1-5)

- ✅ Todos los archivos del dominio anterior están en el nuevo
  source/ con clasificación (incorporado/fusionado/reescrito/
  descartado-con-razón).
- ✅ Filenames cumplen STD_007 (kebab/snake según patrón).
- ✅ Versiones en metadata YAML, no en filenames (STD_006).
- ✅ `index.rst` del dominio lista todo el contenido en toctree.
- ✅ Build sin warnings de refs rotas dentro del dominio.

### Spec WPs (#6-7)

- ✅ Todos los criterios de Methodology + los siguientes:
- ✅ UCs/FRs/NFRs/BRs siguen los templates del WP #2.
- ✅ Refs a CNSTs usan numeración nueva del WP #4.
- ✅ Refs entre artefactos usan `:ref:` con anchor explícito (no
  `:doc:` con path) — robustez frente a futuros renombres.

### Tech-skeleton WPs (#8-15)

- ✅ Existen exactamente 3 archivos: `index.rst`, `overview.rst`,
  `conventions.rst`.
- ✅ `overview.rst` describe alcance, contexto y decisiones a
  alto nivel (sin referencia a código que no existe).
- ✅ `conventions.rst` lista convenciones de código/diseño que
  aplican al tier (basadas en STDs del WP #2 + ADRs del WP #5).
- ✅ Discover del WP-hijo inventarió ADRs y artefactos relevantes
  en source/ actual y temp-holding/, con clasificación
  re-autoría/descarte.
- ✅ Versión inicial 1.0.0 en metadata, salvo justificación.

### Lifecycle WP (#16)

- ✅ Todos los criterios de Methodology + los siguientes:
- ✅ `gestion/` tiene sub-cajones charter, roadmap, épicas,
  sprints, releases, retrospectives, team — cada uno con
  `index.rst` y mínimo 1 archivo de contenido.
- ✅ Cero referencias en archivos de `gestion/` a paths de
  `.thyrox/context/work/` (Decision 13: independencia de mundos).

---

## Riesgos del plan (3 críticos)

Subidos desde análisis de soporte para visibilidad al ejecutor:

| # | Riesgo | Origen | Impacto | Mitigación |
|---|--------|--------|---------|------------|
| R1 | WP #6 requisitos se rebuilda con CNSTs viejas porque WP #4 no cerró antes | restricciones-divergence-analysis §5 | Bloqueante: UCs/FRs hacen referencia a CNSTs que cambiaron de número/concepto | Hard dependency H2 explícita en este plan; el spawn de WP #6 verifica `wp-state.md::status == Aprobado` del WP #4. |
| R2 | Pérdida de CNST huérfana (presente solo en una de las fuentes) durante reconciliación | restricciones-divergence-analysis §5 | Restricción olvidada → diseño viola constraint sin saberlo | `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` actúa como árbitro; mapeo exhaustivo en discover de WP #4. |
| R3 | Versión de template obsoleta elegida como canónica (ej: source/ v1_0_0 cuando temp-holding tiene v1_3_0 superior) | templates-inventory-analysis §5 | Re-trabajo si se descubre tarde; artefactos derivados heredan template inferior | Lectura obligatoria de los 5 análisis previos del ejecutor en discover de WP #2 antes de proponer canónica. |

Riesgos secundarios (5 más) quedan en sus análisis de soporte —
no son bloqueantes inter-WP y se manejan dentro del WP-hijo
correspondiente.

---

## Estimación de esfuerzo

| Componente | Tareas estimadas |
|---|---|
| Producción de este plan + ROADMAP update | 5 |
| Spawn formal de los 16 WPs-hijos (no incluye su ejecución) | 16 |
| Cierre del WP-padre (track + changelog promoción) | 4 |
| **Total del WP-padre** | **25 tareas** |

**Tamaño del WP-padre:** mediano.
**Fases activas del WP-padre:** Phase 1 (DISCOVER, completa) +
Phase 5 (STRATEGY, completa) + Phase 6 (PLAN, este artefacto) +
Phase 8 (PLAN EXECUTION, próximo) + Phase 10 (EXECUTE, spawn) +
Phase 11 (TRACK).

**Phase 7 DESIGN/SPECIFY se omite** — este WP-padre no produce
componentes que requieran spec formal Given/When/Then. La spec
de cada cajón vive en su WP-hijo.

---

## Pre-condición de cierre del WP-padre

**El WP-padre `source-rebuild-strategy` cierra cuando:**

1. ✅ `plan/source-rebuild-strategy-plan.md` aprobado por ejecutor.
2. ✅ `ROADMAP.md` actualizado con la ÉPICA + 16 sub-WPs listados
   como pendientes.
3. ✅ Los 16 WPs-hijos están **abiertos** (cada uno con su
   `wp-state.md` y referencia al padre) — NO ejecutados.
4. ✅ `bootstrap-hardening` recibió F-NEW-8 en su track changelog.
5. ✅ `track/source-rebuild-strategy-changelog.md` cerrado.

**El WP-padre NO espera** a que los 16 hijos terminen — son
artefactos externos referenciados, no entregables del padre.
Cada hijo cierra independientemente.

---

## Trazabilidad RC → Tarea

> No aplica: este WP-padre no deriva de `analyze/` con RC
> formales. Trabajo es de coordinación + spawn, no resolución
> de causas raíz. Los 16 WPs-hijos pueden tener RC propias.

---

## Link ROADMAP

Ver tracking: [ROADMAP.md — sección "En curso"](../../../../ROADMAP.md)

---

## Validation Checklist

- [x] Scope statement con problema + usuarios + criterios medibles
- [x] In-scope explícito
- [x] Out-of-scope explícito con razón
- [x] Los 16 WPs-hijos listados con naming + capa + tamaño +
      pre-condiciones + pre-tareas absorbidas
- [x] 6 cross-WP dependencies hard documentadas
- [x] Pre-tareas asignadas a WPs específicos (sin huérfanas)
- [x] Decisiones diferidas listadas por WP destino (D-CNST-1..5,
      triage templates, variantes UC, etc.)
- [x] Acceptance criteria por tipo de WP (4 tipos)
- [x] 3 riesgos críticos subidos desde análisis de soporte
- [x] Estimación de esfuerzo del WP-padre
- [x] Pre-condición de cierre explícita del WP-padre
- [x] Trazabilidad clara a strategy v2.0
- [x] Scope aprobado por usuario — 2026-04-28 05:15

---

## Estado de aprobación

- [x] Scope aprobado por usuario — 2026-04-28 05:15
