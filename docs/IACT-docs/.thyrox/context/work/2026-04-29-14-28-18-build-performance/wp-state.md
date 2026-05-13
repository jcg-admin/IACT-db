```yml
project: IACT-docs
work_package: 2026-04-29-14-28-18-build-performance
created_at: 2026-04-29 14:28:18
current_phase: Cerrado
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado — 2026-04-29 (objetivos cumplidos, ver track/)
```

# WP — Build Performance (Sphinx + PlantUML)

## Origen

El proyecto `source/` esta en expansion (401 archivos `.rst`,
crecera a 600+ con WPs diferidos #10 infrastructure, #12
operations + posibles backend/frontend ampliados). El ciclo
`make clean && make html` paso de aceptable a **bloqueante
para iteracion rapida**:

| Comando | Tiempo medido (2026-04-29 14:28) |
|---------|----------------------------------|
| `make html` (incremental) | **9 segundos** |
| `make clean && make html` | **6 minutos 3 segundos** |

Diferencia: **40x**. Cada `make clean` mata productividad.

## Acceptance criteria

- [ ] `make html` incremental sigue ≤ 15s (no degradar).
- [ ] `make clean` selectivo (`clean-fast`) preserva
      `build/_plantuml/` cache. Tiempo objetivo: ≤ 90s.
- [ ] Build paralelo via `-j auto` activado.
- [ ] `nitpicky` toggle por env var (relajado en dev,
      estricto en CI).
- [ ] `sphinx-autobuild` documentado para edit-preview.
- [ ] Documentado en Makefile cuando usar cada target.
- [ ] Build verde 0/0/0 mantenido.

## Estructura

```
2026-04-29-14-28-18-build-performance/
├── wp-state.md
├── discover/
│   └── build-time-analysis.md       (medicion + bottleneck root cause)
├── plan/
│   └── build-perf-plan.md           (scope, in/out, decisiones)
├── plan-execution/
│   └── build-perf-task-plan.md      (T-NNN atomicas)
└── track/
```

## Estado

**Listo para ejecucion.** Quick wins identificados (3 cambios
en Makefile + 1 en conf.py = ~15 min) producen mejora estimada
40x → 5x en clean rebuild.
