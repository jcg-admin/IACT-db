```yml
project: IACT-docs
work_package: 2026-04-28-05-07-32-multi-wp-state-strategy
created_at: 2026-04-28 05:07:32
current_phase: Phase 1 — DISCOVER
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: Borrador
parent_findings: F-NEW-9 (bootstrap-hardening WP) + observación del ejecutor en source-rebuild-strategy WP
```

# WP — Multi-WP State Strategy

## Propósito

Definir convención formal de state files (`now.md`, `now-{agent}.md`,
`gate-*.json`) para escenarios donde el repo opera con:

- N branches en paralelo (worktrees).
- N WPs tocados desde una misma sesión (cross-references, archivado,
  scaffolding de hijos).
- N agentes lanzados en paralelo escribiendo a distintos WPs.
- WP-padre que spawnea N hijos.

Y arreglar el bug del hook `sync-wp-state.sh` que viola la convención
existente al actualizar `current_work` en cualquier escritura.

## Origen

- **F-NEW-9** detectado durante sesión de ÉPICA 8 (source-rebuild-
  strategy) el 2026-04-28 05:01: al escribir `ARCHIVED.md` de un WP
  histórico, `now.md::current_work` se cambió incorrectamente.
- **Observación del ejecutor**: con 16 sub-WPs planeados (en
  source-rebuild-strategy v2.0) y posibles agentes en paralelo, el
  modelo actual single-now.md no escala.

## Alcance propuesto (refinar en DISCOVER)

**In-scope:**

- Análisis del hook `sync-wp-state.sh` y sus casos de falla.
- Propuesta formal de convención multi-WP (extender
  `.claude/references/parallel-agent-state-files.md`).
- Modificación del hook con scope correcto (excluir archivos de
  cierre, detectar sub-agentes).
- Tests de regresión de los 4 escenarios identificados.

**Out-of-scope:**

- Cambios al modelo de branching (mantener `develop` + `feature/*`).
- Implementación de auto-detection de sub-agentes si no es trivial
  (puede quedar como mejora futura).

## Insumos heredados

Documentación previa que se debe consultar en Phase 1 DISCOVER:

- `2026-04-28-01-58-08-source-rebuild-strategy/strategy/multi-wp-parallel-state-strategy.md`
  (v1.0) — análisis preliminar con 4 escenarios y propuesta de
  convención v1. **Punto de partida directo de este WP.**
- `.claude/references/parallel-agent-state-files.md` — convención
  existente parcial.
- `.claude/scripts/sync-wp-state.sh` — código del hook a modificar.
- `.claude/scripts/update-state.sh` — script alternativo existente
  para actualización manual.

## Próximo paso

Phase 1 DISCOVER: leer el análisis preliminar heredado, validar
los 4 escenarios identificados, decidir si la propuesta v1 es la
estrategia correcta o requiere ajustes.

Este WP queda **abierto pero pausado** hasta que el ejecutor
decida re-tomarlo. El WP padre `source-rebuild-strategy` tiene
prioridad.
