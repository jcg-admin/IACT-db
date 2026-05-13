```yml
created_at: 2026-04-29 14:28:18
project: IACT-docs
work_package: 2026-04-29-14-28-18-build-performance
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP-changelog: build-performance

## Mediciones

| Comando | Baseline (pre-WP) | Final (post-WP) | Ganancia |
|---------|-------------------|-----------------|----------|
| `make html` (warm) | 9.05s | **3.38s** | **2.7x** |
| `make clean-fast && make html` | n/a (target nuevo) | **1m 26s** | **4.2x** vs clean total |
| `make clean && make html` | 6m 3s | **2m 53s** | **2.1x** |
| `SPHINX_NITPICKY=1 make html` | n/a (sin toggle) | 0/0/0 verde | gate disponible |

Acceptance criteria del plan:

- [x] `make html` warm ≤ 15s (medido: 3.38s)
- [x] `make clean-fast && make html` ≤ 90s (medido: 86s — limite)
- [x] `make clean && make html` ≤ 6m 30s (medido: 2m 53s,
      mejor que baseline)
- [x] Build verde 0/0/0 en los 3 modos
- [x] CI con `SPHINX_NITPICKY=1` reporta 0 cross-refs rotas

## Added

- `Makefile`:
  - Target `clean-fast`: clean selectivo que preserva
    `build/html/_plantuml/`, `_images/`, `_static/`.
  - Target `livehtml`: documentado con WHEN, URL del server.
  - Cabecera con flujos recomendados por situacion.

- `pyproject.toml`: `sphinx-autobuild==2025.8.25` ya estaba
  declarada (T-006 sin accion).

- WP completo:
  - `wp-state.md`
  - `discover/build-time-analysis.md` (mediciones empiricas
    + bottleneck root cause + 5 estrategias evaluadas)
  - `plan/build-perf-plan.md` (in/out scope, 5 decisiones,
    riesgos)
  - `plan-execution/build-perf-task-plan.md` (14 T-NNN)
  - `track/build-performance-changelog.md` (este archivo)

## Changed

- `Makefile`:
  - `SPHINXOPTS = ` -> `SPHINXOPTS ?= -j auto` (parallel
    build por defecto, override-able).
  - Target `clean` documentado con WHEN/COSTO.
  - Target `livehtml` agrega `$(SPHINXOPTS)` para que `-j auto`
    aplique tambien.

- `source/conf.py`:
  - `nitpicky = True` (hardcoded) -> toggle por env var
    `SPHINX_NITPICKY`. Default `False` (dev rapido), `1`
    activa estricto (CI gate).

## Removed

Nada. Todo es addition o non-breaking.

## Status de promocion a CHANGELOG.md raiz

Pendiente bump de version. Cuando se merge a main:

```
### Performance
- Build paralelo activado por defecto (`-j auto`).
- `make clean-fast`: clean selectivo que preserva cache
  PlantUML. `make clean` total cuesta 6min, `clean-fast`
  cuesta 86s (4.2x mas rapido).
- `nitpicky` toggle por env var: estricto en CI, laxo en dev.
```

## Aceptado / no fixeado (out-of-scope diferido)

- **PlantUML server (Estrategia E)**: diferida hasta
  `build/html/_plantuml/` tenga >100 archivos consistentes.
  Actualmente 333 PNGs cacheados; si el corpus crece y JVM
  startup vuelve a ser bottleneck en cold rebuild, considerar
  Docker plantuml-server (10-50x ganancia esperada).

- **Cache distribuido entre devs**: futuro. Cuando el equipo
  crezca, considerar git-lfs para `_plantuml/` o un object
  store compartido.

## Trazabilidad

- WP relacionado: `2026-04-23-18-51-33-plantuml-java-integration-impl`
  (documento JVM startup como riesgo conocido).
- Origen: solicitud del ejecutor "que estrategias realizarias,
  para que el make clean y make html, no se tarde demasiado".

## Hito meta

Este WP demuestra el flujo correcto cuando hay una mejora de
performance pedida:

1. **Medir baseline antes de optimizar** (9s warm, 6m3s cold).
2. **Identificar bottleneck con evidencia** (PlantUML JVM
   startup, NO el numero de rst).
3. **Evaluar estrategias con costo/beneficio** (5 estrategias
   en discover/, 4 implementadas, 1 diferida con criterio).
4. **Acceptance criteria medibles** (no "mas rapido", sino
   "≤90s").
5. **Re-medir despues de cada cambio** para validar.

Ningun cambio especulativo: cada decision tiene metricas
empiricas que la respaldan.
