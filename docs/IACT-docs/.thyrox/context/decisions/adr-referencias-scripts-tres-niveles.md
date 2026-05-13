```yml
type: ADR
id: ADR-017
title: Restructuración de referencias y scripts a 3 niveles arquitectónicos
status: Accepted
created_at: 2026-04-09
work_package: 2026-04-09-03-17-55-skill-references-restructure
depends_on: ADR-015, ADR-016
```

# ADR-017: Restructuración de referencias y scripts a 3 niveles arquitectónicos

## Contexto

### Problema previo (FASE 24 — punto de partida)

Hasta FASE 23, todas las referencias documentales del framework vivían en un único directorio centralizado:

```
.claude/skills/pm-thyrox/references/   ← 24 archivos mezclados
.claude/skills/pm-thyrox/scripts/      ← 20 scripts mezclados
```

Problemas concretos detectados:
1. **Cohesión incorrecta**: Referencias sobre commit conventions (Phase 6) convivían con referencias sobre scalability (Phase 1) sin separación semántica
2. **Acoplamiento bidireccional**: `workflow-analyze/SKILL.md` apuntaba a `pm-thyrox/references/scalability.md` — un skill apuntando al interior de otro skill
3. **Scripts de infraestructura mezclados con scripts de dominio**: `session-start.sh` (hook de Claude Code) en el mismo directorio que `validate-phase-readiness.sh` (validación de workflow)
4. **settings.json con paths incorrectos**: Los hooks apuntaban a `pm-thyrox/scripts/session-start.sh` en lugar de una ubicación de infraestructura

### Evidencia de otros proyectos

Análisis de 6 proyectos que usan pm-thyrox mostró el mismo patrón: referencias globales (conventions.md, examples.md) se duplicaban o quedaban fuera de alcance al ser copiadas entre instancias. La estructura centralizada en pm-thyrox no escala cuando múltiples skills necesitan referenciar la misma documentación.

---

## Decisión

Dividir referencias y scripts en **3 niveles arquitectónicos** basados en scope y propietario:

### Nivel 1: `.claude/references/` — Global, Claude Code platform

**Criterio de inclusión**: Documentación sobre la *plataforma Claude Code* o convenciones que aplican a todo el proyecto, independiente de cualquier fase SDLC.

**Contenido (9 archivos migrados desde pm-thyrox/references/):**
- `agent-spec.md` — Especificación de agentes nativos
- `claude-code-components.md` — Referencia oficial de componentes
- `conventions.md` — Convenciones de archivos, commits, ROADMAP
- `examples.md` — Casos de uso reales
- `long-context-tips.md` — Técnicas para documentos largos
- `prompting-tips.md` — Instrucciones para Claude
- `skill-authoring.md` — Cómo crear y mejorar skills
- `skill-vs-agent.md` — Cuándo crear SKILL vs agente nativo
- `state-management.md` — Gestión de archivos de estado

### Nivel 2: `.claude/skills/workflow-*/references/` — Phase-specific

**Criterio de inclusión**: Documentación específica de una fase SDLC. Solo relevante cuando esa fase está activa.

**Distribución (15 archivos migrados):**
- `workflow-analyze/references/`: scalability.md
- `workflow-strategy/references/`: solution-strategy.md
- `workflow-structure/references/`: spec-driven-development.md
- `workflow-decompose/references/`: (vacío — sin refs específicas)
- `workflow-execute/references/`: commit-convention.md, commit-helper.md
- `workflow-track/references/`: incremental-correction.md, reference-validation.md

### Nivel 3: `.claude/scripts/` — Infrastructure, Claude Code hooks

**Criterio de inclusión**: Scripts que interactúan directamente con Claude Code (hooks de sesión, utilidades de infraestructura). NO lógica de dominio del framework.

**Contenido (13 scripts migrados desde pm-thyrox/scripts/):**
- Hooks de sesión: `session-start.sh`, `session-resume.sh`, `stop-hook-git-check.sh`
- Utilities: `project-status.sh`, `update-state.sh`, `commit-msg-hook.sh`
- Validators: `detect_broken_references.py`, `lint-agents.py`
- Bootstrap: `bootstrap.py`
- Otros: `check-phase-readiness.sh`, `run-bootstrap.sh`

**Scripts que permanecen en pm-thyrox/scripts/ (lógica de dominio):**
- `tests/` — Test suite del framework
- `verify-skill-mapping.sh` — Validación de mappings de skill

**Scripts que permanecen en workflow-track/scripts/ (lógica de fase):**
- `validate-phase-readiness.sh`
- `validate-session-close.sh`

---

## Consecuencias

### Positivas

1. **Sin acoplamiento bidireccional**: Los skills `workflow-*` referencian su propio `references/` — no cruzan al interior de otro skill
2. **settings.json correcto**: Hooks apuntan a `.claude/scripts/` — la ubicación semánticamente correcta para infraestructura
3. **Escalabilidad de instancias**: Al clonar pm-thyrox como template, `.claude/references/` se copia automáticamente como documentación global — no hay referencias rotas al crear nuevo proyecto
4. **Discoverability**: Un desarrollador nuevo ve `.claude/references/` y entiende que es documentación de plataforma; no tiene que buscar dentro de `pm-thyrox/`

### Negativas / trade-offs

1. **Links más largos en SKILL.md**: Las referencias cruzadas ahora usan `../../references/` o `../workflow-*/references/` en lugar del simple `references/`
2. **pm-thyrox/references/ eliminado**: Requirió actualizar 30+ links en 15 archivos
3. **Migración one-time**: Proyectos existentes que ya clonaron pm-thyrox necesitan ejecutar la migración manual o re-clonar el template

### Invariantes preservados

- `pm-thyrox/scripts/tests/` permanece en su lugar — el test suite pertenece al skill
- `workflow-track/scripts/` permanece — scripts de validación de fase pertenecen a su fase
- La anatomía del SKILL (`SKILL.md` + `references/` + `scripts/` + `assets/`) se conserva dentro de cada `workflow-*`

---

## Alternativas consideradas

### Alternativa A: Mantener centralización en pm-thyrox/references/

Rechazada. El acoplamiento bidireccional (workflow-analyze apuntando a pm-thyrox/references) viola el principio de cohesión. Además, no escala cuando se agregan nuevos skills que necesitan referencias específicas de fase.

### Alternativa B: Mover todo a .claude/references/ (sin nivel 2)

Rechazada. References de fase (commit-convention.md, spec-driven-development.md) son irrelevantes fuera de su fase. Mezclarlas con referencias globales aumenta la carga cognitiva y dificulta el on-demand loading.

### Alternativa C: Nivel por skill (pm-thyrox/references/ + workflow-*/references/ sin .claude/references/)

Rechazada. Las referencias globales (conventions.md, agent-spec.md) son necesarias fuera del contexto de pm-thyrox — por ejemplo, al crear un agente sin activar el skill. Requieren un nivel verdaderamente global.
