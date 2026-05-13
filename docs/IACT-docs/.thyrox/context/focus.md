```yml
type: Estado Operacional
project: IACT-docs
version: 2.0.0
created_at: 2026-04-23 09:00:00
updated_at: 2026-04-29 06:35:00
```

# Focus — IACT-docs

Navegación de la iniciativa actual del proyecto IACT-docs.

---

## Iniciativa Actual

**Estado:** entre iniciativas. Última ÉPICA cerrada el 2026-04-29 06:00.
**Branch:** `feature/solve-problem-docs`
**Build status:** `make clean && make html` → `build succeeded` con 0 WARN / 0 ERR / 0 CRIT.

---

## Últimas ÉPICAs cerradas (orden cronológico inverso)

### ÉPICA 12 — methodology-recalibration (2026-04-29 06:00)

WP `2026-04-29-05-51-27-methodology-recalibration`. Meta-WP de
validación adversarial vía deep-dive contra mi propia recalibración
metodológica.

**Resultado:**
- I-016 (background tasks) **relocalizado** de `.claude/rules/` a
  `.claude/skills/thyrox/references/bash-background-tasks.md`
  (lazy-load on-demand).
- I-017 (micro-ciclo metodológico) **descartado** — over-engineering
  identificado por deep-review.
- 2 references on-demand creadas: `mechanical-bulk-edits.md` +
  `methodology-bias-watch.md`.
- Sesgo "realismo performativo metodológico" documentado.

**Trazabilidad:** commits `79362fe`, `0a3161d`, `0a846af`.

### ÉPICA 11 — md-to-rst-saneamiento (2026-04-29 05:35)

WP `2026-04-29-05-35-11-md-to-rst-saneamiento`. Saneamiento masivo
del corpus `source/` post-rebuild.

**Resultado:**
- 19222 issues → 0 (-100%) en 11 batches commit.
- 9 scripts archivados en `scripts/` del WP como canalización
  post-conversion para reuso futuro.
- 8 patrones de bug del conversor original catalogados con
  before/after.
- Causa raíz documentada: el conversor md→rst preservó indent
  visual sin recalcular indent semántico que RST exige.

**Trazabilidad:** commits `e71a78d` → `0f884df` (11 commits) +
`0a2549d` (post-mortem WP).

### ÉPICA 8 — source-rebuild-strategy (2026-04-28)

WP padre del rebuild documental. Spawneo de 16 hijos.

**Estado de hijos a 2026-04-29:**
- **14 CERRADO v1**: base-cognitiva, normativa-* (4),
  requisitos, arquitectura-tecnica, backend, frontend, databases,
  onboarding, quality, risks-technical-debt, gestion.
- **2 DIFERIDO**: infrastructure (205 inputs heavy),
  operations (203 inputs).

Ver `2026-04-28-01-58-08-source-rebuild-strategy/track/children-status-summary.md`.

---

## Estado de la documentación

| Indicador | Valor |
|-----------|-------|
| `make clean && make html` | `build succeeded` |
| WARNINGs | 0 |
| ERRORs | 0 |
| CRITICALs | 0 |
| Cajones publicados en `source/` | 14 |
| Cajones diferidos | 2 (infrastructure, operations) |

---

## Próxima decisión

Pendiente del ejecutor. Opciones identificadas:

| Opción | Descripción | Complejidad |
|--------|-------------|-------------|
| (a) Retomar WP #10 infrastructure | 205 inputs canónicos + 236 variantes en `temp-holding/`. Documentar topología de despliegue Ubuntu + Apache | Heavy |
| (b) Retomar WP #12 operations | 203 inputs en `temp-holding/`. Documentar runbooks operativos | Heavy |
| (c) Atacar DEBT items | DEBT-001..007 en `source/risks-technical-debt/deuda-tecnica-rebuild.rst`. DEBT-001 (vocabulario `Capacidad`→`Function`) requiere coordinación backend | Variable |
| (d) Nueva dirección | Iniciativa fuera del rebuild documental | — |

---

## Convenciones operativas activas

- **Política 0/0**: el build debe quedar siempre limpio. Verificar
  con `make clean && make html` antes de cualquier reporte de
  completación.
- **STD_007**: nombres de archivo kebab-case, sin tildes/eñes/espacios,
  sin sufijos genéricos (`README`, `TODO`).
- **Tim Pope commits**: subject ≤72 ch imperativo, body con QUÉ y
  POR QUÉ.
- **Changelog en dos niveles**: `track/{wp}-changelog.md` siempre,
  `CHANGELOG.md` raíz solo en merge a `main` con bump.
- **Antes de codificar invariante en `.claude/rules/`**: cargar
  `references/methodology-bias-watch.md` y responder las 4
  preguntas de diagnóstico.

---

**Ubicación:** `.thyrox/context/focus.md`
**Scope:** Proyecto IACT-docs — historial reciente y próxima decisión
**Última actualización:** 2026-04-29 06:35:00
