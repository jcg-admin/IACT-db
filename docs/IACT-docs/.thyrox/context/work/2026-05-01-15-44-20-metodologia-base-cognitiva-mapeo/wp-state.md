```yml
project: IACT-docs
work_package: 2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo
created_at: 2026-05-01 15:44:20
closed_at: 2026-05-01 16:15:00
current_phase: CERRADO — alcance acotado completado
status: Cerrado
author: NestorMonroy
flow: thyrox
methodology_step: standardize
predecessor_wp: 2026-05-01-15-42-45-business-requirements-backfill
target: Mapear y aplicar la metodologia documentada en source/base-cognitiva/ al proyecto IACT
artifacts_produced:
  - source/requisitos/business-requirements/breq-002..008.rst (7 nuevos)
  - source/requisitos/business-requirements/index.rst (actualizado v2.0.0)
deferred_to_future_wps:
  - perm-cluster-traceability-normalization (DEC-04)
  - wp-fr-coverage-from-uc-derivation (DEC-10)
  - wp-base-cognitiva-pedagogical-extension (DEC-10)
```

# WP CERRADO — resumen ejecutivo

## Estado al cierre

- **Phase 1 DISCOVER**: completa (3 documentos en `discover/`).
- **Decisiones**: 10 documentadas en `decisions-log.md`.
- **Phase 10 EXECUTE**: completa para alcance acotado:
  - 7 BReqs canonicos creados (BReq-002..008) siguiendo formato de
    breq-001 vigente.
  - Index v2.0.0 actualizado con toctree + tabla mapping
    BRQ legacy → BReq canonico.
- **Build verify**: 0 warnings introducidas en mis archivos.
- **Hallazgos correctos**: TPL_TRZ_Matriz_RTM y procs ya existian
  en source — survey inicial estaba incorrecto y fue corregido en
  decisions-log.

## Trabajo restante (WPs futuros, fuera de alcance)

- Cluster PERM (9 UCs) usa convencion `PRIORIDAD/RNF/N` distinta —
  normalizacion en WP futuro.
- 393 FR estimados en `temp-holding/.../FR_Requisitos_Funcionales/` —
  generacion en WP futuro.
- PARTEs pedagogicas detalladas (Larman, UI Stakeholder) en
  `temp-holding/.../Ingeniería de Requerimientos/` — integracion en
  WP futuro.

---

# WP — Mapeo de Metodologia Base Cognitiva (contenido pre-cierre)

# WP — Mapeo de Metodologia Base Cognitiva

## Contexto

El proyecto IACT-docs declara en
``source/base-cognitiva/`` una metodologia formal de
transformacion de requisitos:

::

   Business Requirements (BReq)
            ↓
   Business Rules (BR)
            ↓
   Use Cases (UC)
            ↓
   Functional Requirements (FR)
            ↓
   CODE + TESTS

Esta metodologia esta documentada en seis sub-cajones:

| Cajon | Cantidad | Proposito |
|-------|----------|-----------|
| ``_fundamentos-conceptuales/`` | 8 FND | Conceptos: BReq, BR, UC, FR, jerarquia, trazabilidad, derivacion |
| ``_taxonomias-y-metamodelos/taxonomias/`` | 3 TXM | Taxonomias: requisitos, artefactos, reglas-negocio (5 tipos de BR) |
| ``_taxonomias-y-metamodelos/metamodelos/`` | 3 MTM | Metamodelos: requisitos, trazabilidad, RBAC |
| ``_ontologia-sbvr/`` | 5 SBVR | Conceptos nucleares, fact types, reglas estructurales/operativas, vocabulario |
| ``_metadata/`` | 5 META | Identidad, clasificacion documental, fases SDLC, contexto, estructura |
| ``_ejemplos-pedagogicos/ejemplo-dark-mode/`` | 14 archivos | Ejemplo end-to-end del ciclo completo (BN→RN→UC→RF→HLD→LLD→TC→deploy) |
| ``_uml/`` | 15+ docs | Diagramas UML aplicables |

La metodologia es **prescriptiva** — establece como deben crearse,
nombrarse y trazarse los artefactos del proyecto.

## Hallazgo motivador

Auditoria del cajon
``source/requisitos/business-requirements/`` revela:

- **1** archivo BReq existe (``breq-001-visibilidad-metricas.rst``).
- **52** BRQs distintos referenciados por UCs sin artefacto
  formal.
- **0** BRQs en cluster PERM (que usa otra convencion:
  PRIORIDAD/RNF/N).
- Naming del unico BReq existente NO sigue la convencion BRQ que
  los UCs usan (``BRQ-{cluster}-NNN``).

Este es un sintoma. La causa raiz parece ser que la metodologia
de base-cognitiva no se aplico de forma sistematica en la
generacion de los UCs.

## Alcance del WP

### IN (incluido)

- Lectura completa de los 6 sub-cajones de
  ``source/base-cognitiva/``.
- Inventario de prescripciones metodologicas (que dice la
  metodologia que debe haber).
- Inventario de cobertura actual del proyecto (que existe hoy
  vs lo que la metodologia prescribe).
- Mapeo BReq → BR → UC → FR → CODE para los 8 clusters
  funcionales (AUTH, USR, ACC, PERM, RPT, ALR, PIP, AUD, LOG).
- Identificacion de artefactos faltantes con prioridad.
- Plan de remediacion por capas (BReq primero, luego BR,
  luego FR — UCs ya existen).
- Backfill de los 52 BReqs huerfanos como Phase 10 EXECUTE de
  este WP (subsume el WP cerrado).

### OUT (excluido)

- Reescritura de UCs existentes (5 ya en formato 12-partes;
  56 monoliticos pendientes — fuera de este WP).
- Generacion de codigo o tests reales — solo especificacion.
- Reorganizacion fisica de la estructura de directorios del
  proyecto (esto seria otro WP).
- Aplicacion de SBVR / metamodelos formales como restricciones
  ejecutables (no aplicable en docs).

## Plan de fases (THYROX)

| Fase | Output esperado |
|------|-----------------|
| Phase 1 — DISCOVER | discover/methodology-survey.md (que prescribe base-cognitiva) + discover/coverage-baseline.md (que existe hoy) |
| Phase 2 — MEASURE | metrics: artefactos esperados vs existentes por cluster + nivel jerarquico |
| Phase 3 — ANALYZE | analyze/gap-analysis.md por capa (BReq, BR, UC, FR) y por cluster |
| Phase 4 — CONSTRAINTS | constraints/*.md (restricciones de naming, plantillas obligatorias, CNST aplicables) |
| Phase 5 — STRATEGY | strategy/solution-strategy.md (orden de remediacion, criterios de stub vs detallado) |
| Phase 6 — PLAN | plan/scope.md (que se incluye, que se posterga, ROADMAP) |
| Phase 7 — DESIGN/SPECIFY | design/breq-template-spec.md, design/traceability-matrix-spec.md |
| Phase 8 — PLAN EXECUTION | plan-execution/task-plan.md con T-NNN para cada artefacto a crear |
| Phase 9 — PILOT | pilot/breq-auth-001-pilot.md (1 BReq como prototipo, validacion de plantilla) |
| Phase 10 — EXECUTE | source/requisitos/business-requirements/{cluster}/breq-*.rst (52 archivos) |
| Phase 11 — TRACK | track/coverage-after.md (cobertura post-WP) + lessons-learned |
| Phase 12 — STANDARDIZE | standardize/methodology-application-guide.md |

## Cluster PERM (anomalia explicita)

Los 9 UCs de PERM cluster usan
``PRIORIDAD_NN``, ``RNF-NNN``, ``N-NNN`` en vez de
``BRQ-PERM-NNN``. Decision provisional: documentar como
**hallazgo H-PERM-01** y NO normalizar en este WP. Razon: la
normalizacion implica reescribir los 9 UCs PERM, lo cual rompe
el alcance acotado.

Resolucion del cluster PERM: WP futuro
``perm-cluster-traceability-normalization``.

## Decisiones heredadas del WP cerrado (preservadas)

- **DEC-01**: archivos `breq-{cluster-lc}-NNN-{desc}.rst`
  alineados con el ID `BRQ-{CLUSTER}-NNN` que usan los UCs.
- **DEC-02**: `breq-001-visibilidad-metricas.rst` se evaluara
  contra el catalogo de RPT BReqs en Phase 3 ANALYZE — puede
  renombrarse a `breq-rpt-006` o quedar como BReq trasversal
  (cross-cluster).
- **DEC-03**: huecos en numeracion (USR-004..008, ACC-006/007,
  RPT-006, ALR-004) preservados — historia documental.
- **DEC-04**: PERM cluster fuera de scope (H-PERM-01).
- **DEC-05**: contenido inicial de cada BReq sera **stub
  estructurado** segun plantilla ``tpl-breq``, refinable
  posteriormente.

## Definicion de exito (alta level)

- Documento de gap analysis publicado y aprobado.
- 52 BReqs creados conforme a plantilla
  ``tpl-breq-objetivos-negocio.rst``.
- TODOS los UCs que referencian BRQ-{cluster}-NNN tienen
  artefacto resoluble (cross-reference Sphinx).
- Build incremental sin nuevas warnings de
  "unknown document".
- Trazabilidad bidireccional documentada: BReq.section
  "UCs que lo realizan" + UC.section "BReq origen" coincidente.
- Guia de aplicacion de metodologia en
  ``standardize/`` para futuras incorporaciones.

## Hallazgos iniciales

- **H-01**: cluster PERM fuera de convencion BRQ (no usa el
  vocabulario base-cognitiva).
- **H-02**: huecos en numeracion BRQ — preservar.
- **H-03**: legacy `breq-001-visibilidad-metricas.rst` sin
  amarre a cluster.
- **H-04**: capa BR (Business Rules) puede tener gaps similares
  — verificar en Phase 1 DISCOVER.
- **H-05**: capa FR (Functional Requirements) tiene su propio
  cajon ``source/requisitos/requisitos-funcionales/`` —
  verificar cobertura en Phase 1 DISCOVER.
- **H-06**: ejemplo pedagogico
  ``_ejemplos-pedagogicos/ejemplo-dark-mode/`` muestra el ciclo
  completo BN → RN → UC → RF → HLD → LLD → TC → deploy. Los
  prefijos (BN, RN, RF) no coinciden con los del proyecto real
  (BReq, BR, FR) — mismatch de naming entre metodologia
  pedagogica y aplicacion.

## Proximo paso

Phase 1 DISCOVER —
``discover/methodology-survey.md`` y
``discover/coverage-baseline.md``. Lectura sistematica de los
6 cajones y comparacion con artefactos existentes.

NO se generan BReqs aun.
