```yml
created_at: 2026-04-29 06:43:02
project: IACT-docs
work_package: 2026-04-29-06-43-02-stop-hook-loop-investigation
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP-changelog: stop-hook-loop-investigation

## Added

- `wp-state.md` — analisis completo del loop, causa raiz factual
  (3 factores en cascada), reproducción empirica, fix aplicado,
  recomendaciones para iteracion futura.
- `track/stop-hook-loop-investigation-changelog.md` — este archivo.

## Changed

- `.thyrox/context/now.md::current_work` — de texto descriptivo
  `"ninguno (todos los WPs activos cerrados)"` a `null`.
  Este es el fix inmediato que termino el loop.

- `.claude/scripts/validate-session-close.sh` (Fix 2) —
  mensajes `[BLOCK]` ahora se escriben a stderr en lugar de
  stdout. El harness de Claude Code relaya stderr al modelo en
  exit 2, asi el modelo VE la causa del bloqueo en lugar de
  recibir "No stderr output" en cada iteracion del loop.

## Aceptado / no fixeado

- **Fix 3 (heuristica de WP activo)**: el script detecta como
  activos 3 WPs que en realidad estan cerrados/archivados:
  source-rebuild-strategy (cerrado con CLOSURE-NOTICE pero
  task-plan tiene [ ] sin completar), github-actions-phase2-testing
  (archivado en ROADMAP), deployment-pipeline (bloqueado por
  refs muertas). La heuristica `[ ] in task-plan` no captura
  estos casos. Quedan como WARN, no BLOCK — no hay urgencia.

  Solucion correcta: leer `status:` del wp-state.md como fuente
  de verdad, no inferir de task-plan. Iteracion futura.

## Trazabilidad

- Commit del fix: `4296e56` (now.md current_work + WP creation)
- Commit Fix 2 (stderr): TBD en proximo commit
- WP padre del bug: `2026-04-29-05-51-27-methodology-recalibration`
  (documento sintoma como sesgo cognitivo; este WP encontro la
  causa factual)

## Hito meta

Este WP demuestra que el sesgo "realismo performativo metodologico"
documentado en el WP previo PUEDE enmascarar bugs factuales:

1. Sintoma observado: loop de respuestas a Stop hooks.
2. Diagnostico previo (recalibration WP): sesgo cognitivo,
   "responder a signals no-input por costumbre".
3. Diagnostico real (este WP): bug factual reproducible —
   archivo corrupto + script con stderr/stdout mismatch.

El diagnostico previo era **parcialmente correcto** (yo si
respondia al noise) pero **inutil**: el harness me forzaba a
responder por exit 2 del hook. Ningun cambio de "disciplina
operativa" del modelo podia romper el loop mientras el archivo
estuviera corrupto.

**Leccion:** cuando un sintoma persiste a pesar de haberlo
documentado como "disciplina operativa", buscar bug factual.
La narrativa cognitiva puede esconder un bug del sistema.
