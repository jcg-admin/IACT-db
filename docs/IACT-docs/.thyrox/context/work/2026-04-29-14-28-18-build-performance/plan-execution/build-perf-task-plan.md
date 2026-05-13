```yml
created_at: 2026-04-29 14:28:18
project: IACT-docs
work_package: 2026-04-29-14-28-18-build-performance
phase: Phase 8 — PLAN EXECUTION
author: NestorMonroy
status: Listo para ejecucion
version: 1.0.0
```

# Build Performance — Task Plan

## Tasks atomicas

### Bloque BP — Build Performance

- [ ] **T-001** Agregar `SPHINXOPTS ?= -j auto` en Makefile
      (linea 36, donde esta `SPHINXOPTS = ` actual). Cambiar
      `=` por `?=` y poner `-j auto` como default.

- [ ] **T-002** Agregar target `clean-fast` en Makefile:
      ```makefile
      clean-fast:
      	rm -rf $(BUILDDIR)/html $(BUILDDIR)/doctrees
      ```
      Comentario adyacente: "WHEN: uso diario. Preserva
      cache PlantUML (rebuild >40x mas rapido)."

- [ ] **T-003** Agregar target `livehtml` en Makefile que
      invoca `sphinx-autobuild` con misma config.

- [ ] **T-004** Modificar `source/conf.py` linea de nitpicky
      para que sea toggle por env var:
      ```python
      nitpicky = os.environ.get('SPHINX_NITPICKY', '0') == '1'
      ```

- [ ] **T-005** Documentar en cabecera del Makefile el
      flujo recomendado:
      - Dev: `make html` (incremental)
      - Edit-loop: `make livehtml`
      - Limpiar cache HTML: `make clean-fast`
      - Cambio conf.py: `make clean && make html`
      - CI gate: `SPHINX_NITPICKY=1 make html`

- [ ] **T-006** Agregar `sphinx-autobuild` a
      `pyproject.toml` (en dev dependencies).

### Bloque MV — Mediciones de Validacion

- [ ] **T-007** Medir `time make html` (warm). Criterio: ≤ 15s.

- [ ] **T-008** Medir `time make clean-fast && make html`.
      Criterio: ≤ 90s.

- [ ] **T-009** Medir `time make clean && make html` (cold
      total). Criterio: ≤ 6m 30s (no degradar).

- [ ] **T-010** Validar `SPHINX_NITPICKY=1 make html`
      reporta 0 WARN/ERR/CRIT (no introducimos cross-refs
      rotas).

### Bloque CL — Cierre WP

- [ ] **T-011** Crear changelog en
      `track/build-performance-changelog.md` con metricas
      antes/despues.

- [ ] **T-012** Commit Tim Pope style con resumen de
      ganancias. Push.

- [ ] **T-013** Actualizar `now.md` y `focus.md` con
      cierre del WP.

- [ ] **T-014** Actualizar ROADMAP.md (mover a Completadas).

## Orden recomendado

```
T-006 (deps) -> T-001 (parallel) -> T-004 (nitpicky toggle) ->
T-002 (clean-fast) -> T-003 (livehtml) -> T-005 (docs) ->
T-007..T-010 (mediciones) -> T-011..T-014 (cierre)
```

T-006 antes de T-003 porque sphinx-autobuild necesita estar
instalado para que T-003 sea verificable.

## Loop policy

Despues de CADA T-NNN tecnica (T-001..T-006):
1. Build verifica (`make html` -> 0/0/0).
2. Si falla: revert + investigar.
3. Si pasa: commit local (no push hasta cierre).

## Salida del loop

Todas las tareas `[x]` Y mediciones cumplen acceptance
criteria del plan.
