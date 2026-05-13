```yml
created_at: 2026-04-29 14:28:18
project: IACT-docs
work_package: 2026-04-29-14-28-18-build-performance
phase: Phase 6 — PLAN
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Build Performance — Plan

## Objetivo

Reducir el tiempo de `make clean && make html` de **6m 3s**
a **<= 90s** sin sacrificar correctness ni `nitpicky=True`
en CI, manteniendo politica 0/0 (build verde 0 WARN/ERR/CRIT).

## In-scope

1. **Sphinx parallel build** — agregar `-j auto` a SPHINXOPTS
   por defecto en Makefile.
2. **Clean selectivo** — agregar target `clean-fast` que
   borra HTML y doctrees pero **preserva** `build/_plantuml/`
   cache.
3. **`sphinx-autobuild` documentado** — agregar target
   `serve` o `livehtml` que invoca sphinx-autobuild para
   ciclo edit-preview.
4. **`nitpicky` toggle por env var** — `SPHINX_NITPICKY=1`
   activa estricto (CI), default es laxo (dev).
5. **Documentacion en Makefile** — comentarios que expliquen
   cuando usar cada target.

## Out-of-scope

1. **PlantUML server** (Estrategia E del analysis) — diferir
   hasta que `build/_plantuml/` tenga >100 archivos
   consistentemente. Complejidad adicional no justificada
   por volumen actual.
2. **Cambiar tema o extensiones** — no son bottleneck.
3. **Optimizar conf.py** — costo bajo (1-2s), no impacta el
   problema principal.
4. **Refactor de archivos rst** — el corpus es lo que es; no
   reducir count para ganar tiempo.
5. **Cache distribuido** (compartir `_plantuml/` entre devs)
   — futuro, no urgente.

## Decisiones

### D1 — `-j auto` por defecto

```makefile
SPHINXOPTS ?= -j auto
```

`?=` permite override desde CLI: `SPHINXOPTS="" make html`
si se quiere serial.

### D2 — `clean-fast` separado de `clean`

```makefile
clean:           # Borra TODO (incluyendo cache plantuml). Lento despues.
	rm -rf $(BUILDDIR)/*

clean-fast:      # Borra HTML + doctrees, preserva _plantuml cache.
	rm -rf $(BUILDDIR)/html $(BUILDDIR)/doctrees
```

Politica: usar `clean-fast` por defecto. Reservar `clean`
para cambios en conf.py o debug de cache corrupto.

### D3 — `livehtml` con sphinx-autobuild

```makefile
livehtml:
	sphinx-autobuild -j auto $(ALLSPHINXOPTS) $(BUILDDIR)/html
```

Requiere `pip install sphinx-autobuild` (agregar a
`pyproject.toml` o `requirements-dev.txt`).

### D4 — `nitpicky` toggle

`conf.py`:

```python
import os
nitpicky = os.environ.get('SPHINX_NITPICKY', '0') == '1'
```

Politica:
- Local dev: default `nitpicky=False` (rapido).
- Pre-commit hook: `SPHINX_NITPICKY=1 make html`.
- CI: `SPHINX_NITPICKY=1 make html` (gate).

### D5 — Documentacion en Makefile

Cada target nuevo lleva comentario `# WHEN: descripcion`.

## Riesgos

| Riesgo | Mitigacion |
|--------|------------|
| Cache plantuml corrupto sin saber | Si build falla raro, ejecutar `make clean` (full). |
| `-j auto` causa output entrelazado | Sphinx ya maneja sync; si hay problema, override `SPHINXOPTS=""`. |
| `nitpicky=False` permite refs rotas que llegan a main | CI con `SPHINX_NITPICKY=1` es el gate. Documentar en convenciones. |
| `sphinx-autobuild` no instalado en CI | No usado en CI; solo dev. |

## Acceptance criteria (medible)

- [ ] `time make html` (warm) ≤ 15s
- [ ] `time make clean-fast && make html` ≤ 90s
- [ ] `time make clean && make html` (cold all) ≤ 6m 30s
      (no debe degradar)
- [ ] Build verde 0/0/0 en los 3 modos
- [ ] CI con `SPHINX_NITPICKY=1` reporta build verde sin
      cross-refs rotas

## Plan de validacion

1. Medir baseline (ya hecho: 9s warm, 6m3s cold).
2. Aplicar D1-D5.
3. Re-medir cada modo.
4. Comparar contra acceptance criteria.
5. Documentar cambios en Makefile y conf.py.
6. Cerrar WP con changelog.
