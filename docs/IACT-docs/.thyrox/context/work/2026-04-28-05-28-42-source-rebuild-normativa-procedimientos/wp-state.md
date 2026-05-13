```yml
project: IACT-docs
work_package: 2026-04-28-05-28-42-source-rebuild-normativa-procedimientos
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #3 of 16
created_at: 2026-04-28 05:28:42
current_phase: Phase 11 — TRACK (CERRADO — 0 warnings, 0 errors, todos los hallazgos resueltos)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO — 2026-04-28 08:35 (build limpio, 73 archivos, 3 deep-reviews aplicados)
opened_at: 2026-04-28 08:00:00
closed_at: 2026-04-28 08:35:00
```

# WP-hijo #3 — Source Rebuild: normativa/procedimientos

## Propósito

Reconstruir `source/normativa/procedimientos/` (~67 archivos PROC* +
PROCED*). Procedimientos operacionales del proyecto IACT
(governance, dev, devops, deployment, etc.).

## Capa

**Methodology / Governance** (capa 1).

## Pre-condiciones

- WP #2 `source-rebuild-normativa-estandares` cerrado.
- Templates `TPL_PROC_Procedimientos.rst` disponible para usar
  como molde.

## Decisiones del padre que aplican

- **Idea 1 (Backup-as-reference).**
- **Idea 5 (criterio editorial).**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Inventario de los 67 archivos** | Clasificar cada uno como incorporar / fusionar / reescribir / descartar. Hay archivos con espacios en filename (ej: `Procedimientos - frontend-README.rst`) que violan STD_007 — renombrar obligatorio. |
| **Triage de PROCs dispersos** | Procedimientos relacionados con frontend/backend/devops dispersos aquí — algunos pueden migrarse al cajón técnico correspondiente cuando llegue su turno (re-autoría con v1.0.0 fresh, Decision 10). |

## Alcance

**In-scope:** Reescribir PROCs aplicando `TPL_PROC` + STD_007.

**Out-of-scope:** Crear nuevos PROCs no presentes en backup.

## Estado

**Borrador (no iniciado).** Spawneado por T-010.
