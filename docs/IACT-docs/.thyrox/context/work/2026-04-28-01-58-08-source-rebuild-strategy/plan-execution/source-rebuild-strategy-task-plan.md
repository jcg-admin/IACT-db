```yml
created_at: 2026-04-28 05:13:57
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Stage 8 — PLAN EXECUTION
author: NestorMonroy
status: Aprobado — 2026-04-28 05:18 (ejecutor: SI)
```

# Task Plan — Source Rebuild Strategy WP-padre (ÉPICA 8)

> **Generado desde:** `plan/source-rebuild-strategy-plan.md` (Aprobado 2026-04-28 05:15)
> **Alcance:** Coordinación + spawn formal de 16 WPs-hijos + cierre del WP-padre. NO ejecuta el rebuild.
> **Ruta crítica:** T-008 → T-009 → T-010 → ... → T-023 → T-025 → T-031

---

## Convención de tarea

**Opción C — Tareas heterogéneas con trazabilidad a sección del plan.**

Formato: `T-NNN Acción atómica (sección-del-plan-origen)`. Cada tarea es:
- **Una sola operación verificable** (un `Write` / un `Edit` / un `Bash` específico)
- **Outcome único y verificable** (un archivo creado, un campo actualizado, un grep que retorna N)
- **Independientemente completable** (no requiere humano-en-loop salvo gates explícitos)

Spawn tasks (T-008..T-023) son atómicas porque producen exactamente UN
`wp-state.md` con parent-link y pre-tareas declaradas, verificable con
`grep -l "parent: source-rebuild-strategy" {path}/wp-state.md`.

---

## Grupo A — Trabajo retrospectivo (Phase 5 + Phase 6, ya completado)

> *Estas tareas ya están hechas. Marcadas [x] para preservar audit trail
> y dar contexto al lector del task plan.*

- [x] **T-001** Producir `strategy/source-rebuild-strategy-solution-strategy.md` v2.0 con 10 Key Ideas + 14 Decisions (Phase 5)
- [x] **T-002** Producir 4 análisis de soporte de strategy: `templates-inventory-analysis.md`, `restricciones-divergence-analysis.md`, `iact-docs-v2-applicability-analysis.md`, `tech-stack-alignment-analysis.md`
- [x] **T-003** Invocar `deep-review` agent (bounded) y persistir output como `plan/deep-review-strategy-to-plan.md`
- [x] **T-004** Producir `plan/source-rebuild-strategy-plan.md` absorbiendo los 8 gaps del deep-review
- [x] **T-005** Actualizar `ROADMAP.md` con ÉPICA 8 (entrada única, sin sub-líneas — convención emergente)
- [x] **T-006** Obtener aprobación del ejecutor para Phase 6 PLAN (status → Aprobado 2026-04-28 05:15)
- [x] **T-007** Registrar F-NEW-8 (tech-skill mismatch) en `bootstrap-hardening` WP changelog como handoff cross-WP

---

## Grupo B — Spawn de los 16 WPs-hijos

> *Cada T-008..T-023 = una atomic operation: crear `mkdir` del directorio del WP-hijo + write su `wp-state.md` con: timestamp ISO, `parent: source-rebuild-strategy`, scope mínimo, pre-condiciones declaradas, pre-tareas absorbidas, link al solution-strategy.md del padre.*
>
> *Cada hijo se spawnea con `current_phase: Phase 1 — DISCOVER` y `status: Borrador (no iniciado)` — el hijo NO se ejecuta como parte de este WP-padre.*

### Methodology (5 hijos)

- [x] **T-008** Spawn WP-hijo `source-rebuild-base-cognitiva` con pre-tareas: crear `temp-backup/source-2026-04-28/` + triage F-NEW-2 de los 5 backups anidados de `temp-holding/` (sección "Pre-tareas asignadas" del plan)

- [x] **T-009** Spawn WP-hijo `source-rebuild-normativa-estandares` con pre-condición #1 cerrado + sub-orden interno STDs→templates→resto (Decision 5) + triage de templates (Decision 6) con 5 inputs obligatorios: `ANALISIS_TEMPLATES_VERSIONES.md`, `PLAN_TEMPLATES_3_12_v1_2_0.md`, `ANALISIS_NOMENCLATURA_TPL_1_0_0.md`, `PLAN_GENERACION_TPL_1_0_0.md`, `PROPUESTA_TEMPLATE_01..10.txt` + conservación de 7 variantes UC

- [x] **T-010** Spawn WP-hijo `source-rebuild-normativa-procedimientos` con pre-condición #2 cerrado

- [x] **T-011** Spawn WP-hijo `source-rebuild-normativa-restricciones` con pre-condición #2 cerrado + reconciliación CNST + 5 sub-decisiones D-CNST-1..5 (numeración, huérfanas, v2.0.0 standalone, gap CNST_011, sub-categorías) + inputs obligatorios: `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` + `ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` + sección §4.2 de restricciones-divergence-analysis

- [x] **T-012** Spawn WP-hijo `source-rebuild-normativa-gobernanza` con pre-condición #4 cerrado

### Spec (2 hijos)

- [x] **T-013** Spawn WP-hijo `source-rebuild-requisitos` con pre-condiciones hard #2 + #4 cerrados (templates listos + CNSTs reconciliadas con tabla de mapeo viejo→nuevo)

- [x] **T-014** Spawn WP-hijo `source-rebuild-arquitectura-tecnica` con pre-condición #6 cerrado + absorción de `plantuml-guide/` (F-04)

### Tech-skeleton (8 hijos — overview.rst + conventions.rst + index.rst, sin código)

- [x] **T-015** Spawn WP-hijo `source-rebuild-backend` (DRF) con pre-condiciones #7 + bootstrap-hardening cerrado (H4 — backend-django.instructions activo)

- [x] **T-016** Spawn WP-hijo `source-rebuild-frontend` (React + Webpack) con pre-condición #7 cerrado

- [x] **T-017** Spawn WP-hijo `source-rebuild-infrastructure` (Ubuntu + Apache) con pre-condición #7 cerrado

- [x] **T-018** Spawn WP-hijo `source-rebuild-databases` (MySQL + PostgreSQL — cajón propio, D-TECH-3) con pre-condición #7 cerrado

- [x] **T-019** Spawn WP-hijo `source-rebuild-operations` (deployment, monitoring, runbooks) con pre-condiciones #8-11 cerrados

- [x] **T-020** Spawn WP-hijo `source-rebuild-onboarding` (dev quickstart) con pre-condiciones #8-11 cerrados

- [x] **T-021** Spawn WP-hijo `source-rebuild-quality` (testing strategy) con pre-condiciones #8-11 cerrados

- [x] **T-022** Spawn WP-hijo `source-rebuild-risks-technical-debt` con pre-condiciones #8-14 cerrados + pre-tareas: cleanup `temp-backup/` + cleanup `temp-holding/` + recuperar `sphinx-build -W` (Decision 3 final)

### Lifecycle (1 hijo)

- [x] **T-023** Spawn WP-hijo `source-rebuild-gestion` (lifecycle expandido — charter + roadmap + epicas + sprints + releases + retrospectives + team) con pre-condición #15 cerrado + recordatorio Decision 13 (independencia source/ ↔ .thyrox/)

### Commit del grupo

- [x] **T-024** Commit [Grupo B]: `Spawn 16 child WPs for source-rebuild`

---

## Grupo C — Cierre del WP-padre

- [x] **T-025** Verificar que los 16 hijos están abiertos con parent-link válido. Comando: `find .thyrox/context/work/ -name wp-state.md -exec grep -l "parent: source-rebuild-strategy\|parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy" {} \; | wc -l` → debe retornar 16

- [x] **T-026** Verificar pre-condición de cierre #4 del plan: `bootstrap-hardening` recibió F-NEW-8 (grep en su changelog) — ya hecho retrospectivamente en T-007, re-verificar

- [x] **T-027** Update `track/source-rebuild-strategy-changelog.md`: agregar entradas de Phase 8 PLAN EXECUTION + Phase 10 EXECUTE (spawn) + cierre del WP-padre

- [x] **T-028** Run `bash .claude/scripts/validate-phase-completion.sh` y verificar exit 0 (working tree clean + remote sync + build success + recent commits)

- [x] **T-029** Crear `CLOSURE-NOTICE.md` del WP-padre con: fecha cierre, link al plan aprobado, link a los 16 hijos spawneados, link a deep-review, status=Cerrado

- [x] **T-030** Update `wp-state.md` del WP-padre: `current_phase: Phase 11 — TRACK (cerrado)` + `status: Cerrado — YYYY-MM-DD HH:MM:SS`

- [x] **T-031** Update `ROADMAP.md`: mover ÉPICA 8 de "En curso" a "Completadas" con highlights (16 hijos spawneados)

- [x] **T-032** Commit [Grupo C]: `Close source-rebuild-strategy WP — 16 children spawned`

- [x] **T-033** Push final a `origin/feature/solve-problem-docs`

---

## DAG de dependencias

```
T-008 (base_cognitiva) ──┬→ T-009 (estandares) ──┬→ T-010 (procedimientos)
                          │                        ├→ T-011 (restricciones)
                          │                        └→ T-012 (gobernanza)
                          │
                          │   T-009 + T-011 ──→ T-013 (requisitos)
                          │
                          └→ (vocabulario disponible para todos)

T-013 ──→ T-014 (arquitectura_tecnica)
                  │
                  └→ T-015 (backend) ──┐
                  └→ T-016 (frontend) ──┤
                  └→ T-017 (infra) ─────┼→ T-019 (operations)
                  └→ T-018 (databases) ─┤   T-020 (onboarding)
                                         │   T-021 (quality)
                                         │
                                         └→ T-022 (risks-tech-debt) ──→ T-023 (gestion)

bootstrap-hardening WP (externo, F-NEW-8) ──→ T-015 (H4)

T-023 cerrado ──→ T-024 commit ──→ T-025..T-033 cierre
```

**Nota DAG:** las dependencias son entre los WPs-hijos cuando se EJECUTEN
(no entre las tareas T-008..T-023 de spawn). El spawn en sí es secuencial
T-008..T-023 sin dependencias hard — se pueden crear todos los wp-state.md
en orden sin esperar nada.

---

## Trazabilidad sección del plan → tarea

| Sección del plan | Tareas que la implementan |
|------------------|---------------------------|
| "16 WPs-hijos" tabla | T-008..T-023 |
| "Cross-WP dependencies" H4 (F-NEW-8) | T-007 (registrar) + T-015 (referenciar) + T-026 (verificar) |
| "Pre-tareas asignadas" → WP #1 | T-008 |
| "Pre-tareas asignadas" → WP #15 | T-022 |
| "Decisiones diferidas" → WP #4 (D-CNST-1..5) | T-011 |
| "Decisiones diferidas" → WP #2 (templates triage) | T-009 |
| "Pre-condición de cierre del WP-padre" (5 cond) | T-025 (cond 3) + T-026 (cond 4) + T-027 (cond 5) + T-028 (validate script) + T-029-T-030 (cond markers) |
| ROADMAP.md update | T-031 |

---

## Cierre

- [ ] Task plan aprobado por ejecutor
- [ ] Phase 8 PLAN EXECUTION cerrada al iniciarse Phase 10 EXECUTE (T-008+)

**Total de tareas:** 33 (7 retrospectivas marcadas [x] + 16 spawn + 10 cierre).
**Atomicidad:** cada T-NNN tiene 1 outcome verificable con 1 comando.
**Tamaño del WP-padre:** mediano (33 tareas, sin ejecución de los hijos).
