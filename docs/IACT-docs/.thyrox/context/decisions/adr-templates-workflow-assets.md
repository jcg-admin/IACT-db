```yml
type: ADR
id: ADR-018
title: Distribución de templates a workflow-*/assets/ — assets autocontenidos por fase
status: Accepted
created_at: 2026-04-09
work_package: 2026-04-09-07-15-48-assets-restructure
depends_on: ADR-017
```

# ADR-018: Distribución de templates a workflow-*/assets/

## Contexto

Hasta FASE 25, los 38 templates del framework vivían centralizados en `pm-thyrox/assets/`. Los archivos `workflow-*/SKILL.md` y `workflow-*/references/*.md` ya usaban paths relativos `assets/X.md.template` y `../assets/X.md.template` asumiendo su propio directorio — pero esos directorios no existían, generando referencias rotas silenciosas.

ADR-017 (FASE 24) estableció el principio de distribución a 3 niveles para references y scripts. FASE 25 extiende ese principio a los templates.

## Decisión

Distribuir 37 de los 38 templates a sus `workflow-*/assets/` correspondientes, basándose en la fase SDLC donde se genera el artefacto. Un template permanece en `pm-thyrox/assets/` por ser genuinamente cross-phase.

### Distribución final

| Directorio | Count | Templates |
|-----------|-------|-----------|
| `workflow-analyze/assets/` | 14 | introduction, risk-register, exit-conditions, constitution, requirements-analysis, use-cases, quality-goals, stakeholders, basic-usage, constraints, context, end-user-context, project.json, adr |
| `workflow-strategy/assets/` | 1 | solution-strategy |
| `workflow-plan/assets/` | 2 | plan, epic |
| `workflow-structure/assets/` | 4 | requirements-specification, design, spec-quality-checklist, document |
| `workflow-decompose/assets/` | 2 | tasks, categorization-plan |
| `workflow-execute/assets/` | 9 | execution-log, commit-message-main, feature, bugfix, refactor, documentation, ad-hoc-tasks, multiple-files, task-completion |
| `workflow-track/assets/` | 5 | lessons-learned, changelog, final-report, refactors, analysis-phase |
| `pm-thyrox/assets/` (queda) | 1 | error-report |

### Caso especial: error-report.md.template

Permanece en `pm-thyrox/assets/` porque se usa en cualquier fase del ciclo SDLC (al detectar un error en Phase 1, 4, 6, etc.). No tiene un owner de fase claro.

### Caso especial: categorization-plan.md.template

Asignado a `workflow-decompose/assets/` (owner primario: se usa para categorizar trabajo activo en Phase 5). `workflow-track/references/incremental-correction.md` actualiza su link a la ruta cross-workflow correcta.

### Caso especial: adr.md.template

Asignado a `workflow-analyze/assets/` (Phase 1 es el primer usuario). `workflow-strategy/SKILL.md` actualiza su referencia a `../workflow-analyze/assets/adr.md.template`.

## Consecuencias

### Positivas

1. **Coherencia con ADR-017**: La anatomía `SKILL.md + references/ + assets/` ahora está completa en cada `workflow-*`. Los skills son autocontenidos.
2. **Referencias reparadas automáticamente**: Los paths `assets/X.md.template` en `workflow-*/SKILL.md` y `../assets/X.md.template` en `workflow-*/references/*.md` empiezan a funcionar sin edición — solo necesitaban el directorio.
3. **Corrección FASE 24 side-effects**: `references/conventions.md` y `references/examples.md` tenían links `../assets/X.md` rotos (apuntaban a `.claude/assets/` inexistente). Corregidos en este WP.

### Negativas / trade-offs

1. **pm-thyrox/SKILL.md tabla más verbosa**: Los 14 links de la tabla de artefactos ahora usan paths `../workflow-*/assets/X.md.template` en lugar del simple `assets/X.md.template`.
2. **adr.md.template cross-skill**: workflow-strategy/SKILL.md ahora referencia assets de otro skill — un grado de acoplamiento. Aceptable dado que adr.md es un template de decisiones arquitectónicas que aplica a ambas fases.

## Alternativas consideradas

### Alternativa A: Mantener centralización en pm-thyrox/assets/

Rechazada. Las referencias en workflow-*/SKILL.md y workflow-*/references/*.md ya asumían distribución. Mantener centralización requería actualizar todos esos archivos — más trabajo y contra la tendencia del codebase.

### Alternativa B: Crear .claude/assets/ como nivel global

Rechazada. Añadiría un cuarto nivel sin precedente en ADR-017. Solo hay 1 template genuinamente global (error-report) — insuficiente para justificar un nuevo directorio de nivel .claude/.

### Alternativa C: Copiar (no mover) categorization-plan.md.template a ambos workflows

Rechazada. Dos fuentes de verdad divergen con el tiempo. Una copia, un owner (workflow-decompose).
