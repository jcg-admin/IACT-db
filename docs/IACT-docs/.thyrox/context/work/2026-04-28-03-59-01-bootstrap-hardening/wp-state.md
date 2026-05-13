```yml
project: IACT-docs
work_package: 2026-04-28-03-59-01-bootstrap-hardening
created_at: 2026-04-28 03:59:01
current_phase: Phase 1 — DISCOVER
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: Borrador
parent_finding: F-NEW-7 (source-rebuild-strategy WP)
```

# WP — Bootstrap Hardening

## Propósito

Hacer el bootstrap del repositorio robusto frente a clones nuevos y
sesiones nuevas. Hoy un `git clone` + `make html` falla porque
`scripts/setup.sh` no se ejecuta automáticamente y no está señalizado
como pre-condición obligatoria. La sesión que originó este WP
(2026-04-28, source-rebuild-strategy) perdió tiempo investigando
warnings fantasma (183 plantuml errors) que solo existían porque se
saltó el setup.

## Alcance propuesto (a refinar en DISCOVER)

**In-scope:**

- `readme.rst`: agregar sección "First time setup" con
  `bash scripts/setup.sh` como primer comando.
- `Makefile`: guard en target `html` que verifique `tools/plantuml.jar`
  y `enchant`, con mensaje accionable si faltan.
- `CONTRIBUTING.md`: documento dedicado a flujo de desarrollo
  (clone → setup → make html → cambios → commit → push).
- CI: workflow que parta de checkout limpio + `bash scripts/setup.sh`
  + `make html` con exit 0.
- `.githooks/pre-push`: advertencia opcional si plantuml.jar falta.

**Out-of-scope:**

- Rebuild del contenido de `source/` (ese trabajo es del WP padre
  `source-rebuild-strategy` y los WPs de dominio derivados).
- Cambios al `setup.sh` mismo más allá de mejorar mensajes — el
  script ya funciona bien; el problema es la visibilidad.

## Origen

Hallazgo F-NEW-7 detectado en
`.thyrox/context/work/2026-04-28-01-58-08-source-rebuild-strategy/`
durante la verificación de F-NEW-3. Documentado en su
`track/source-rebuild-strategy-changelog.md` como acción propuesta
"fuera de scope DISCOVER — abordar en WP separado".

## Referencias

- `scripts/setup.sh` — script de bootstrap actual (funcional).
- `Makefile` — preámbulo documenta `uv sync` pero no exige
  `setup.sh`.
- `readme.rst` — describe el producto IACT, no el flujo de
  desarrollo del repo de docs.
