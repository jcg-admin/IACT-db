```yml
created_at: 2026-04-29 16:25:00
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Findings Execution Order — Análisis de dependencias y orden de ataque

## Premisa

12 findings identificados (F-01..F-12). Para evitar regresión sobre
el trabajo ya hecho en el WP previo (315 renames + módulos
REQ/DOC + STDs 008/009 numerados), el orden de ataque debe respetar
las dependencias técnicas y la causalidad entre findings.

## Dependencias

```
F-10 (híbridos MD/RST) ──────┐
                             ├── Causa común con F-07/F-08/F-09
F-07 (sin .. meta::)         │   (los híbridos no tienen frontmatter
F-08 (sin :version:)  ───────┤   por su origen md). Hacer F-10 primero
F-09 (sin :fecha_creacion:)  ┘   evita doble trabajo.

F-03 (módulos adr/rnf) ──────┐
F-04 (:artefacto: scope)     │
F-05 (duplicados)     ───────┤── 1 sola actualización STD_007 v2.0.2
F-06 (guías estandares/)     │   establece ground-truth antes de
F-02 (prefijo mod- nuevo)    ┘   renames físicos.

F-02 (8 arq-mod-*)    ──┐
F-01 (9 procedimiento-) ├── Renames usan tooling probado.
F-06 reubicación (si)   ┘   Después de v2.0.2 que documenta los
                            módulos faltantes y prefijo `mod`.
```

## Riesgo de regresión

El WP previo dejó 3 scripts probados que NO se reescriben:

| Script | Función |
|--------|---------|
| `migrate-naming.py` | Kebab transform genérico (regla universal) |
| `fix-broken-refs.py` | Post-hoc fixer de toctree/`:doc:` rotos |
| `update-module-refs.py` | Mapping explícito por nombre |

**Riesgo identificado:** si F-07/F-08/F-09 se ejecutan ANTES que
F-10, los archivos híbridos recibirán metadata que luego F-10
podría sobreescribir al rehacer el frontmatter completo. Doble
trabajo + riesgo de pérdida.

**Otro riesgo:** F-09 (133 archivos sin `:fecha_creacion:`) puede
incluir guías que LEGÍTIMAMENTE no necesitan ese campo. Sin triaje
previo, forzar el campo introduce ruido en el corpus.

## Plan ordenado (6 bloques, T-001..T-022)

### Bloque A — Measure (deepening, sin cambios físicos)

| Tarea | Acción | Output |
|-------|--------|--------|
| T-001 | Scan completo F-10: identificar TODOS los archivos híbridos MD/RST (no solo los 2 rnf-proc-* confirmados) | `measure/f10-hybrid-files-inventory.md` |
| T-002 | Triaje F-07/F-08/F-09: set DISTINCT de archivos, overlap entre los 3 findings, distinción artefactos primarios vs. guías cortas | `measure/metadata-coverage-triage.md` |
| T-003 | Inspección F-06: 3 guías en `estandares/` — decidir reubicar (¿a dónde?) o documentar excepción | `analyze/f06-guides-estandares-decision.md` |
| T-004 | Inspección F-02: 8 arq-mod-* — confirmar son módulos arquitectónicos legítimos (no duplicados) | `analyze/f02-arq-mod-decision.md` |

### Bloque B — Spec consolidation (1 commit, 0 renames)

| Tarea | Acción |
|-------|--------|
| T-005 | Crear ADR `adr-std007-spec-gaps-fix.md` documentando F-01..F-06 + decisiones |
| T-006 | STD_007 v2.0.1 → **v2.0.2** (PATCH compatible) extendiendo: |
|       | • §4 tabla módulos `adr-`: back, front, devops, gob, qa |
|       | • §4 tabla módulos `rnf-`: proc |
|       | • §4 prefijo nuevo `mod-NNN-<desc>` (módulos arquitectónicos) |
|       | • §2 nota: `:artefacto:` y campos meta YAML fuera de scope |
|       | • §3 política sobre duplicados de filename |
|       | • §4/§5 decisión F-06 (excepción o reubicación) |
| T-007 | Build verify 0/0/0 |

### Bloque C — Renames físicos (validados contra v2.0.2)

| Tarea | Acción |
|-------|--------|
| T-008 | F-02: 8 archivos `arq-mod-NNN-*` → `mod-NNN-*` con mapping explícito |
| T-009 | F-01: 9 archivos `procedimiento-*` → `proc-<MOD>-<NNN>-*` |
| T-010 | F-06: si v2.0.2 decide reubicar, 3 archivos guías |
| T-011 | Cascade refs + build verify por cada batch |

### Bloque D — F-10 CRITICAL (híbridos MD/RST)

| Tarea | Acción |
|-------|--------|
| T-012 | Por cada archivo del inventory T-001: |
|       | • Eliminar título legacy MD (ej. `RNF-PROC-001_PROCESO_SDLC.md ===`) |
|       | • Agregar frontmatter `.. meta::` completo |
|       | • Verificar estructura RST pura |
| T-013 | Build verify (los títulos cambian → refs `:ref:` pueden moverse) |

### Bloque E — F-07/F-08/F-09 (metadata remediation triageado)

| Tarea | Acción |
|-------|--------|
| T-014 | Artefactos sin `.. meta::`: agregar bloque completo |
| T-015 | Artefactos con `.. meta::` sin `:version:`: añadir `:version: 1.0.0` |
| T-016 | Artefactos sin `:fecha_creacion:`: inferir de `git log` + añadir |
| T-017 | Guías marcadas en T-002 como "sin metadata OK": dejar + excepción documentada |
| T-018 | Build verify |

### Bloque F — Closure

| Tarea | Acción |
|-------|--------|
| T-019 | Re-correr deep-review (los 12 tests F-*) → 0 violaciones |
| T-020 | WP changelog en `track/std007-spec-gaps-changelog.md` |
| T-021 | Update `now.md` + `focus.md` |
| T-022 | Commit Tim Pope + cierre |

## Justificación del orden

| Bloque | Por qué |
|--------|---------|
| **A primero** | Sin medir F-10 ni triagear F-09, riesgo de trabajo desperdiciado |
| **B después de A** | Spec actualizado es ground-truth para renames |
| **C después de B** | Renames usan tooling probado; antes de metadata para minimizar conflictos |
| **D antes de E** | F-10 (híbridos) incluye semantic rewrite que ya agrega metadata |
| **E después de D** | Por entonces se sabe qué archivos genuinamente necesitan metadata |
| **F al final** | Cierre solo cuando todos los F-* están en 0 |

## Magnitud estimada por bloque

| Bloque | Cant cambios | Riesgo | Tiempo aprox |
|--------|-------------:|--------|-------------:|
| A | 0 file edits, ~5 reports | bajo | 1h |
| B | 1 STD_007 + 1 ADR | bajo | 1h |
| C | 17-20 archivos + ~30 refs | medio (probado) | 1h |
| D | TBD por T-001 | alto (semantic) | 1-3h |
| E | 37-133 archivos | medio (mecánico) | 1-2h |
| F | 3-4 archivos | bajo | 30min |

## Política de safety

- Cada bloque cierra con `SPHINX_NITPICKY=1 make html` 0/0/0.
- Cada bloque genera 1+ commits Tim Pope (rollback granular).
- Re-audit completo en T-019 antes de cerrar.
- No tocar tooling existente del WP previo (probado en 315 renames).

## Dependencias circulares — verificadas inexistentes

```
A → B → C
        ↓
        D → E → F
```

No hay dependencia C → A ni E → B. El DAG es lineal.

## Findings sin acción

| F-NN | Estado | Razón |
|------|--------|-------|
| F-11 | Clean | 0 anchor labels duplicados verificados |
| F-12 | Clean | 0 archivos huérfanos verificados |

Estos se incluyen en T-019 (re-audit) para confirmar que siguen
limpios al cierre.
