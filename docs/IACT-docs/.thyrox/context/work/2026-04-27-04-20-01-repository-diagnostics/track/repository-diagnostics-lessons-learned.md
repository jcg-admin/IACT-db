```yml
created_at: 2026-04-27 05:40:00
project: IACT-docs
work_package: 2026-04-27-04-20-01-repository-diagnostics
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
```

# Lessons Learned — repository-diagnostics

## Resultado

15 hallazgos identificados, 14 con código aplicado, 1 aceptado como meta-pattern.
Repo en estado funcional end-to-end: `bash scripts/setup.sh && make html` produce build OK con 173 diagramas PlantUML renderizados.

## Lecciones por categoría

### Diagnóstico antes de fixear (proceso)

- **L-01 — La pregunta abierta produce inventario, no solución.** "¿Qué problemas tiene el repo?" generó 15 hallazgos en una pasada. Si hubiera empezado en Phase 5 STRATEGY, habría fixeado los 2-3 visibles y dejado los otros 12 invisibles para encontrar después.
- **L-02 — `now.md` es la primera evidencia.** Antes de mirar código, leer el estado de sesión rinde más: F-05 reveló que 3 WPs estaban "activos" simultáneamente — hint de que el proceso, no el código, era el problema.

### Configuración de Claude Code (técnica)

- **L-03 — `.claude-plugin/plugin.json` solo no alcanza.** Para `/thyrox:*`, `.claude/` debe ser plugin root con manifest `.claude/.claude-plugin/plugin.json` Y un marketplace tipo `directory` registrado en `settings.json::extraKnownMarketplaces`. Marketplace inline `source: "settings"` rechaza paths relativos por schema.
- **L-04 — Hooks `.githooks/` no auto-instalan.** Necesitan `git config core.hooksPath` por clone — un script de bootstrap es la única forma realista.

### Build & deps Python (técnica)

- **L-05 — `uv.lock` puede mentir sobre `pyproject.toml`.** Sphinx>=9.0.4 declarado, autodocsumm requiere <9.0; lockfile resolvió a 8.2.3 ignorando la spec. `uv sync` falla; solo `--frozen` funciona. Indica cambio de constraint sin re-resolver.
- **L-06 — `requires-python = ">=3.11"` sin upper bound es deuda futura.** uv resuelve para 3.15+ donde wheels no existen.
- **L-07 — System deps son invisibles hasta que faltan.** `libenchant-2-2` y el binario `plantuml` son C/Java fuera de pyproject — solo se descubren cuando `make html` falla.
- **L-08 — Bundle de binarios > package del sistema.** `tools/plantuml.jar` descargado da control de versión; `apt plantuml` en Ubuntu 24 da v1.2020.2 (4 años atrasada). Wrapper shell `tools/bin/plantuml` desacopla la app del PATH del sistema.

### Idempotencia (proceso/técnico)

- **L-09 — Un script idempotente se mide en segundos.** Setup completo: 30s primera vez, 0.3s subsecuentes. Si la 2da corrida tarda lo mismo que la 1ra, no es idempotente — hay un check faltante.

### Estilo de commits (proceso)

- **L-10 — Conventional Commits estaba forzando 7 tipos rígidos sobre cambios que no calzaban.** Tim Pope (subject + body) recupera el "por qué" del cambio sin tipos artificiales. Body obligatorio fuerza explicar contexto.

### Política de Changelog (proceso)

- **L-11 — `CHANGELOG.md` raíz es el contrato público de `main`.** Editarlo desde feature branch lo hace mentir hasta el merge. Solución: WP-changelog en `track/{wp}-changelog.md` y promoción al merge.

### Anti-patrón evitado

- **L-12 — F-10 (WPs auto-referenciales).** El proyecto tenía 5+ WPs sucesivos auditando el proyecto. `repository-diagnostics` se capeo a sí mismo: solo reporta y aplica, no abre WPs hijos por hallazgo. Reduce el riesgo de que la auditoría se vuelva el trabajo principal.

## Métricas del WP

- **Duración:** 1 sesión continua (~3 horas).
- **Hallazgos:** 15 identificados, 14 con código, 1 aceptado.
- **Commits:** 12 atómicos (Tim Pope desde el switch de estilo).
- **Líneas neto:** ~+250 (rules, scripts, configs) — `git rm --cached` no cuenta porque files locales se preservaron.
- **Build status:** `make html` exit 0, 173 diagramas renderizados.

## Recomendaciones para próximos WPs

1. **Cerrar WPs explícitamente con `CLOSURE-NOTICE.md`** apenas el ejecutor confirme — evita ambigüedad de F-06.
2. **Resetear `now.md` al pasar de WP** — evita la mezcla que F-05 reveló.
3. **Si un WP introduce cambio de regla global** (Tim Pope, changelog policy), commitear la regla en su propio commit con `Refs:` explícito.
4. **Validar `make html` exit 0 antes de cerrar cualquier WP** (ya regla, I-015).

## Estado al cierre

- Branch: `feature/repository-diagnostics` con 12 commits, pusheada.
- WP zero-warnings-build (sucesor) abierto en Phase 1 DISCOVER en commit `e5df309`.
- Pendiente externo: borrar manualmente `origin/claude/review-project-config-V8Fg5` (server bloquea con 403).
