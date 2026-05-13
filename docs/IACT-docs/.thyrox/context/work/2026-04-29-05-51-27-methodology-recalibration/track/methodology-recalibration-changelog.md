```yml
created_at: 2026-04-29 05:51:27
project: IACT-docs
work_package: 2026-04-29-05-51-27-methodology-recalibration
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP-changelog: methodology-recalibration

## Added

- `wp-state.md` — contexto, origen del WP, acceptance criteria.
- `discover/root-cause-real.md` — hipotesis evaluadas (H1..H4),
  causa raiz real (H2 + H4), sesgo "realismo performativo
  metodologico" documentado.
- `analyze/deep-review-result.md` — output verbatim del
  agente deep-dive contra mi propia recalibracion. Veredicto:
  FALSE/UNCERTAIN en 4 de 5 puntos.
- `plan/correction-plan.md` — 4 acciones (A1..A4) pendiente
  aprobacion.

## Changed

- `.claude/rules/thyrox-invariants.md` — removida seccion
  I-016 (con comentario apuntando a la nueva ubicacion).
- `wp-state.md` — Borrador -> Cerrado tras ejecutar A1+A3+A4.

## Removed

- I-016 como invariante en `.claude/rules/`. Razon: regla de
  uso de tool especifico (Bash con run_in_background) no merece
  carga permanente en context budget.

## Added (en otros directorios — referencias on-demand)

- `.claude/skills/thyrox/references/bash-background-tasks.md`
  (relocalizacion de I-016, lazy-load).
- `.claude/skills/thyrox/references/mechanical-bulk-edits.md`
  (micro-ciclo de 5 pasos como reference, NO invariante).
- `.claude/skills/thyrox/references/methodology-bias-watch.md`
  (sesgo "realismo performativo metodologico" + 4 preguntas
  de diagnostico antes de codificar invariante).

## Aceptado / no fixeado

- **NO se agrego I-017** (descartado tras deep-review). La
  decision esta documentada en `plan/correction-plan.md`
  accion A2.

- **No se modifica el WP padre `md-to-rst-saneamiento`** ni
  los 11 commits historicos del saneamiento. Son historia,
  no se reescriben — la recalibracion es addendum.

## Status de promocion a CHANGELOG.md raiz

Pendiente bump de version. Cuando se merge a main, condensar
con la entrada del WP saneamiento en una sola seccion del tipo:

```
### Changed
- Estructura `.claude/rules/` clarificada: I-016
  (background tasks) movido a references/ lazy-load.
  Agregadas guias on-demand mechanical-bulk-edits.md y
  methodology-bias-watch.md.
```

## Trazabilidad

- Commits: `79362fe` (open WP), `0a3161d` (execute
  A1+A3+A4 + close).
- WP padre: `2026-04-29-05-35-11-md-to-rst-saneamiento`
  (saneamiento que origino la recalibracion).
- Deep-review invocado contra deep-dive agent — output
  verbatim en `analyze/deep-review-result.md`.

## Hito meta

Este WP demuestra el ciclo correcto cuando una falla
operativa se confunde con falla de proceso:

1. Falla detectada (zombies + STD_007 violado).
2. Reaccion default: agregar invariante (I-016 commiteado,
   I-017 propuesto).
3. **Validacion adversarial via deep-dive** revela que la
   reaccion era over-engineering.
4. Correccion: relocalizar lo codificado, descartar la
   propuesta, documentar el sesgo para evitar repeticion.

El paso 3 (validacion adversarial antes de codificar)
deberia ser parte del flujo cuando una nueva regla en
`.claude/rules/` se considera. Documentado en
`references/methodology-bias-watch.md`.
