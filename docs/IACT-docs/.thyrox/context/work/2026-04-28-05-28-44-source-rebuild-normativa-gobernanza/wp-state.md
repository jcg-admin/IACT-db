```yml
project: IACT-docs
work_package: 2026-04-28-05-28-44-source-rebuild-normativa-gobernanza
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #5 of 16
created_at: 2026-04-28 05:28:44
current_phase: Phase 11 — TRACK (CERRADO)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO — 2026-04-28 17:00 (7 ADR-GOB integrados, 12 ADRs no-GOB en handoff, build limpio)
opened_at: 2026-04-28 16:30:00
closed_at: 2026-04-28 17:00:00
```

# WP-hijo #5 — Source Rebuild: normativa/gobernanza

## Propósito

Reconstruir `source/normativa/gobernanza/` (ADRs internos del
proyecto + políticas de gobernanza). Convención: `ADR-<MOD>-<NNN>-
<desc-kebab>.rst` per STD_007 §4.2.

## Capa

**Methodology / Governance** (capa 1).

## Pre-condiciones

- WP #4 `source-rebuild-normativa-restricciones` cerrado.

## Decisiones del padre que aplican

- **Idea 5 (criterio editorial).**
- **Decision 10 (re-autoría con v1.0.0, no migración).**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Triage de ADRs dispersos** | source/ actual tiene ADRs de DEVOPS, FRONT, etc. en `gobernanza/`. Decision 10 dice re-autoría: ADRs activos del proyecto IACT deben quedar acá, los específicos de tier técnico (frontend, backend, infra, db) **deben re-autorearse en sus cajones técnicos** (WPs #8-11) con v1.0.0 fresh. |
| **Inventario de ADRs en temp-holding/** | Hay ADRs candidatos para re-autoría no presentes en source/ actual. |
| **Decisión: política de versionado de ADRs** | ADRs son inmutables tradicionalmente — confirmar la convención del proyecto IACT. |

## Alcance

**In-scope:** ADRs de governance del proyecto (no específicos de
tier), políticas internas; aplicar `TPL_ADR` + STD_007.

**Out-of-scope:** ADRs de tiers técnicos (van en sus cajones).

## Estado

**Borrador (no iniciado).** Spawneado por T-012.
