```yml
project: IACT-docs
work_package: 2026-04-28-05-28-50-source-rebuild-databases
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #11 of 16 (tech-skeleton)
created_at: 2026-04-28 05:28:50
current_phase: Phase 11 — TRACK (CERRADO v1)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v1 — 2026-04-29 (estructura minima creada en source/)
```

# WP-hijo #11 — Source Rebuild: databases (MySQL + PostgreSQL)

## Propósito

Crear cajón nuevo `source/databases/` (cajón propio según
**D-TECH-3**, no sub de backend) para MySQL + PostgreSQL.
Estructura **skeleton-first**: 3 archivos.

## Capa

**Tech (skeleton-first)** (capa 2).

## Pre-condiciones

- **H5:** WP #7 cerrado.

## Decisiones del padre que aplican

- **D-TECH-3 (databases como cajón propio):** son 2 motores
  distintos con razones específicas (CNST_003 — Base_Datos_Dual_
  Inmutable o equivalente reconciliada en WP #4).
- **Idea 9 + Decision 9 + 10 + 12.**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de CNST de bases de datos** | source/normativa/restricciones/CNST_003_Base_Datos_Dual_Inmutable.rst (o su equivalente reconciliado por WP #4). Documenta el "por qué" de los 2 motores. |
| **Triage MySQL vs PostgreSQL** | Decidir si overview.rst es único o dividido por motor. conventions.rst probablemente dividido (naming de tablas, índices, migrations). |

## Acceptance criteria

- ✅ 3 archivos skeleton (mínimo).
- ✅ `overview.rst`: dos motores con razón documentada, scope de
  cada uno, dual-write/read patterns si aplica.
- ✅ `conventions.rst`: naming, índices, migrations Django, backup-
  restore policies a alto nivel.
- ✅ Versión 1.0.0.

## Alcance

**In-scope:** 3 archivos skeleton.

**Out-of-scope:** Schemas concretos, queries específicas, scripts
de migration (van con código).

## Estado

**Borrador (no iniciado).** Spawneado por T-018.
