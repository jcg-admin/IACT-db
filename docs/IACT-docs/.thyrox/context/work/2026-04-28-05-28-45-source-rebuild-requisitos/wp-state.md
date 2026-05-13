```yml
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #6 of 16
created_at: 2026-04-28 05:28:45
current_phase: Phase 11 — TRACK (CERRADO — UCs ACC + PERM en source/, build limpio)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO — 2026-04-29 04:00 (59 UCs en 9 modulos, Hipotesis 1 aplicada)
opened_at: 2026-04-29 00:00:00
closed_at: 2026-04-29 04:00:00
```

# WP-hijo #6 — Source Rebuild: requisitos

## Propósito

Reconstruir `source/requisitos/` (158 archivos: UCs + FRs + NFRs +
BRs + casos de uso). Es el dominio más grande del rebuild.

## Capa

**Spec** (capa 2).

## Pre-condiciones — HARD

- **H1:** WP #2 `source-rebuild-normativa-estandares` cerrado —
  templates `TPL_UC`, `TPL_BR`, `TPL_FR`, `TPL_NFR`, etc.
  disponibles.
- **H2:** WP #4 `source-rebuild-normativa-restricciones` cerrado
  — CNSTs reconciliadas + tabla de mapeo viejo→nuevo disponible.
- **H3 (soft):** WP #1 base_cognitiva cerrado — vocabulario.

**No abrir este WP** hasta confirmar las 3 dependencias.

## Decisiones del padre que aplican

- **Idea 6 (templates como contrato).** UCs siguen TPL_UC; FRs
  siguen TPL_FR; etc.
- **Idea 7 (CNSTs como input).** Refs a CNSTs usan numeración
  nueva del WP #4.
- **Decision 6 (7 variantes de UC):** elegir patrón apropiado por
  caso de uso (CRUD, Larman, Stakeholder_Driven, etc.).

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de los 158 archivos** | Distribuidos en sub-dominios: casos_uso/{access, reports, users, ...}, requisitos_funcionales/, requisitos_no_funcionales/, reglas_negocio/. Triage caso por caso. |
| **Migración de refs CNST viejas → nuevas** | Cada UC/FR/BR que cite "CNST_NNN" debe usar la tabla de mapeo del WP #4. |
| **Asignación de variante UC** | Para cada UC, decidir cuál de los 7 patrones aplica. |

## Riesgos críticos heredados

- **R1:** Si se abre antes de #4 cerrado → CNSTs ambiguas.
- **R2:** Pérdida de CNST huérfana propaga aquí silenciosamente.
- **R3:** Versión de template obsoleta como canónica del WP #2 →
  todos los UCs heredan.

## Alcance

**In-scope:** UCs, FRs, NFRs, BRs reescritos con templates +
CNSTs nuevas + STD_007/STD_006.

**Out-of-scope:** Implementación del producto (eso es código).
Crear nuevos UCs sin precedente en backup.

## Estado

**Borrador (no iniciado).** Spawneado por T-013.
