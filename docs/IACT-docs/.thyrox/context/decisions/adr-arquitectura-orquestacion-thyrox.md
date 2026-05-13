```yml
type: ADR
id: ADR-015
title: Arquitectura de 5 capas para pm-thyrox — decisión sobre mecanismo de orquestación
status: Accepted
created_at: 2026-04-08 05:40:00
work_package: 2026-04-08-03-51-36-skill-architecture-review
replaces: análisis SKILL-vs-agent de FASE 20 (conclusiones incorrectas)
```

# ADR-015: Arquitectura de 5 Capas para pm-thyrox

## Contexto

El análisis de FASE 20 (skill-vs-agent-analysis.md) concluyó que pm-thyrox debería ser un
"thin orchestrator SKILL". Esa conclusión tenía errores de framing identificados con evidencia
externa en FASE 21. Este ADR documenta la decisión arquitectónica correcta.

### Los 5 hallazgos que invalidaron el análisis anterior

**H1 — SKILLs tienen triggering probabilístico** *(Fuente: artículo "The Ultimate Guide to Claude Code Skills", Mar 2026)*

> "Skills are not deterministic. You can write the perfect skill, install it correctly, name it beautifully — and Claude Code might just... not use it."

Evidencia empírica: 20 prompts que deberían disparar una CPO review skill → 0 disparos.
El análisis anterior asumió que pm-thyrox SKILL se activa cuando se necesita. Eso es falso.

**H2 — SKILLs son prompt injection, no arquitectura** *(Fuente: mismo artículo)*

> "Skills are prompt injections. That's it. Nothing more magical than that."
> "40 of 47 skills tested made the output WORSE."

El framing de "solución arquitectónica" era inflado. El mecanismo subyacente es: texto inyectado en contexto.

**H3 — CLAUDE.md es una alternativa más confiable** *(Fuente: mismo artículo)*

> "Why not just stick with a well-written system prompt in your CLAUDE.md? It's simpler, always loads, doesn't have trigger reliability issues."

El análisis anterior ignoró esta alternativa. CLAUDE.md se carga siempre — sin probabilidad.

**H4 — PTC existe pero es ortogonal a hooks y commands** *(Fuente: "Programmatic Tool Calling with Claude Code", 2026)*

PTC permite que Claude orqueste N tool calls en un script Python (reduce round-trips).
Disponible en la API, **no en Claude Code Web**. Cuando llegue a Claude Code:
- Opera dentro de una fase (tool calls), no entre fases (orchestration)
- /workflow_* commands y hooks no cambian — PTC mejora la eficiencia interna de los agentes
- La arquitectura de 5 capas persiste; solo la Capa 4 gana eficiencia

**H5 — Truncación de descripciones al escalar SKILLs** *(Fuente: análisis FASE 21)*

El presupuesto de context para SKILL descriptions = ~1% del context window.
THYROX tiene 16 skills activos. En este rango, la truncación de keywords ya puede ocurrir,
reduciendo la tasa de disparo de pm-thyrox SKILL aún más.

### El error de framing crítico del análisis anterior

El análisis de FASE 20 dijo: "la única opción viable es un SKILL — es una limitación arquitectónica de Claude Code".

Eso era **incorrecto en dos dimensiones**:
1. CLAUDE.md es una alternativa más confiable (siempre cargada, no probabilística)
2. La limitación es de producto (Anthropic eligió no incluir PTC en Claude Code), no arquitectónica

### Restricciones del entorno

- Claude Code Web: sin PTC disponible hoy
- CLAUDE.md: siempre cargado, pero overhead en sesiones no-PM si contiene lógica completa
- Hooks (SessionStart, Stop): 100% determinísticos — ejecutados por el harness, no por Claude
- /workflow_* commands: determinísticos si el usuario los invoca; hoy **desactualizados** vs SKILL.md
- 16 SKILLs activos: budget de descriptions potencialmente saturado

---

## Opciones Consideradas

| Opción | Descripción | PTC-proof | Confiabilidad | Overhead no-PM |
|--------|------------|-----------|--------------|----------------|
| A — Status quo (SKILL monolítica ~430 líneas) | pm-thyrox contiene lógica completa de 7 fases | -Probabilístico ≠ PTC | Media (puede no disparar) | Bajo (on-demand) |
| B — Todo en CLAUDE.md | Lógica de fases en CLAUDE.md, siempre cargada | +| Alta (siempre cargado) | Alto (430+ líneas siempre) |
| C — Hooks + /workflow_* + SKILL thin *(elegida)* | Hooks determinísticos + commands on-demand + SKILL catálogo | +| Alta (hooks 100%) | Bajo (commands on-demand) |
| D — Sin SKILL central + workflow_* autónomos | CLAUDE.md flujo + commands autónomos sin pm-thyrox | +| Alta | Bajo (pero duplicación) |

**Opción C elegida** porque: es PTC-proof, ya está 70% implementada (workflow_* existen), no requiere overhead de CLAUDE.md completa, y respeta el principio de "humano en el loop" como feature.

---

## Decisiones

### D-01: Separación de capas por nivel de triggering

Cada capa tiene un único nivel de triggering — no mezclar responsabilidades entre capas.

| Capa | Nombre | Triggering | Quién escribe la lógica |
|------|--------|-----------|------------------------|
| 0 | Hooks (session-start.sh, stop-hook) | 100% determinístico (harness/shell) | Scripts en `scripts/` |
| 1 | CLAUDE.md | Siempre en contexto (declarativo) | Instrucciones mínimas de flujo |
| 2 | pm-thyrox SKILL + N skills | Probabilístico on-demand | Solo catálogo, no lógica de fase |
| 3 | /workflow_* commands | Determinístico si el usuario los invoca | Phase-specific markdown |
| 4 | Agentes nativos | Determinístico una vez lanzados | Definiciones en `.claude/agents/` |

### D-02: pm-thyrox SKILL → catálogo ~40 líneas (cuando TD-008 completo)

pm-thyrox SKILL se reduce a: descripción de activación + tabla de escalabilidad + tabla de /workflow_*.
La lógica de fase se elimina del SKILL y vive únicamente en el /workflow_* command correspondiente.
**Precondición:** TD-008 (sync /workflow_* commands) debe completarse ANTES de reducir el SKILL.
Reducir sin sincronizar produce sistema peor (Ruta 1 sin lógica + Ruta 2 outdated).

### D-03: /workflow_* commands = única fuente de verdad de lógica de fase

Cada command contiene la lógica completa y actualizada de su fase.
pm-thyrox SKILL no duplica esa lógica (post-TD-008).
Cada command tiene frontmatter con `updated_at` — actualizaciones independientes por fase.

### D-04: SessionStart hook muestra las dos rutas con calidad actual

El hook facilita la decisión del usuario — no la reemplaza.
Muestra: WP activo + fase + próxima tarea + Opción A (SKILL, calidad alta HOY) + Opción B (/workflow_*, con etiqueta "[outdated]" hasta TD-008).
Flag `COMMANDS_SYNCED=false` permite eliminar la etiqueta sin cambiar estructura del script.

### D-05: Cláusula de revisión PTC en ADR

Cuando PTC llegue a Claude Code: los agentes lo adoptan internamente (eficiencia interna de Capa 4).
/workflow_* commands, hooks, y CLAUDE.md NO requieren cambio.
pm-thyrox SKILL (catálogo) podría convertirse en script PTC para batch execution si hay caso de uso real.

### D-06: La arquitectura no oculta sus gaps — los hace visibles

El hook muestra "[outdated]" mientras /workflow_* no estén sincronizados.
El ADR documenta estado actual vs objetivo con triggers claros.
El usuario informado elige mejor que el sistema que decide por él.

### D-07: Capa 2 soporta N skills, no solo pm-thyrox

Cada skill tiene section owners disjuntos. pm-thyrox escribe `now.md`. Skills especializados escriben `now-{skill-name}-{wp-id}.md`.
Límite recomendado: máx 2-3 skills simultáneos (context window budget).

### D-08: Naming convention para checkpoints multi-skill

| Tipo | Archivo | Quién escribe |
|------|---------|--------------|
| Estado compartido | `now.md` | pm-thyrox / orquestador |
| Agente nativo en ejecución | `now-{agent-name}.md` (e.g. `now-task-executor.md`) | El agente |
| Skill especializado | `now-{skill-name}-{wp-id}.md` (e.g. `now-security-audit-wp-auth.md`) | El skill |

### D-09: CLAUDE.md incluye guía de orquestación multi-skill

Sección permanente en CLAUDE.md: máx simultáneos, cuándo secuenciar, section owners disjuntos.
Siempre cargada → siempre visible, sin depender de que el usuario recuerde un reference.

---

## Tabla de 5 Capas — Arquitectura Objetivo

| Capa | Mecanismo | Triggering | Overhead sesiones no-PM | Actualizable sin migración |
|------|-----------|-----------|------------------------|--------------------------|
| 0 — Hooks | shell scripts (harness) | 100% determinístico | Negligible | Sí |
| 1 — CLAUDE.md | system prompt declarativo | Siempre cargado | Bajo (~80 líneas) | Sí |
| 2 — SKILLs (N) | text injection on-demand | Probabilístico | Bajo (solo si se invocan) | Sí |
| 3 — /workflow_* | slash commands | Determinístico (usuario) | Bajo (solo si se usan) | Sí (independiente por fase) |
| 4 — Agentes nativos | subprocesos Claude | Determinístico (una vez lanzados) | 0 (contexto propio) | Sí |

**Coordinación en Capa 4:** `now.md` + `now-{agent-name}.md` + `now-{skill-name}-{wp-id}.md` + git commits como barriers.

---

## Cláusula de Revisión PTC (D-05)

Cuando **Programmatic Tool Calling** esté disponible en Claude Code:

**Cambia:**
- Capa 4 (agentes): pueden usar PTC internamente para batch tool calls — más eficiente
- pm-thyrox SKILL (catálogo): podría convertirse en script PTC para batch execution si hay caso de uso real
- Necesidad de compensación via CLAUDE.md: se reduce (SKILL más predecible)

**No cambia:**
- Capa 0 (Hooks): scripts shell, ortogonales a PTC
- Capa 3 (/workflow_* commands): text injection, no compite con PTC
- Capa 4 coordinación: `now.md` / git barriers siguen igual
- Arquitectura general: persisten 5 capas, PTC mejora eficiencia interna de agentes

**Conclusión:** PTC cambia eficiencia, no arquitectura. Este ADR no requiere revisión cuando PTC llegue, excepto para evaluar si pm-thyrox SKILL → script PTC tiene caso de uso real.

---

## Estado Actual vs Objetivo

| Aspecto | HOY (2026-04-08) | OBJETIVO (post-TD-008) |
|---------|-----------------|----------------------|
| pm-thyrox SKILL | ~430 líneas, lógica completa de 7 fases | ~40 líneas, catálogo + tabla /workflow_* |
| /workflow_* commands | Desactualizados (sin gates, manifest, calibración) | Sincronizados, únicos portadores de lógica de fase |
| session-start.sh | Muestra "invocar pm-thyrox" como primera acción | Muestra 2 rutas con calidad (Opción A + B sin etiqueta outdated) |
| CLAUDE.md | Flujo de sesión + glosario | + Sección multi-skill orchestration |
| Ruta preferida | Ruta 1 (SKILL) — calidad alta, confiabilidad media | Ruta 3 (/workflow_*) — calidad alta, confiabilidad alta |
| Trabajo pendiente | TD-008: sync /workflow_* (prerequisito de todo lo demás) | TD-008 completado → D-02 ejecutable |

**Requisito para alcanzar el objetivo:** TD-008 completado — es el prerequisito bloqueante.

---

## Consecuencias

**Positivas:**
- Arquitectura explícita y documentada — no implícita en el código
- Humano en el loop como feature, no como bug — el usuario siempre decide la ruta
- PTC-proof por diseño — capas ortogonales
- Multi-skill coordinado — section owners disjuntos eliminan race conditions

**Negativas:**
- Dos rutas con calidad distinta HOY — confusión potencial hasta TD-008
- TD-008 es trabajo significativo (7 commands × ~80-100 líneas de lógica actualizada)

**Mitigaciones:**
- Hook muestra la advertencia "[outdated]" en Ruta 2 — confusión minimizada
- TD-008 tiene descripción completa y trigger claro en technical-debt.md

---

## Status

**Status:** Accepted — 2026-04-08
**Work package:** `2026-04-08-03-51-36-skill-architecture-review`
**Reemplaza conclusiones de:** `skill-vs-agent-analysis.md` de FASE 20 (ver sección Corrección en ese documento)
**Próxima revisión:** cuando TD-008 esté completado O cuando PTC llegue a Claude Code

---

## Addendum 2026-04-18 — 3 Actualizaciones estructurales (ÉPICA 29, 39, 41)

*Las decisiones D-01..D-09 no se modifican. Este addendum registra cambios de naming, conteo y posicionamiento que afectan las referencias de este ADR.*

### Actualización 1 — pm-thyrox → thyrox (ÉPICA 29)

Todas las referencias a `pm-thyrox` en este ADR son históricas. El skill fue renombrado a `thyrox` en ÉPICA 29:

| Este ADR dice | Estado actual |
|---------------|---------------|
| `pm-thyrox SKILL` | `thyrox SKILL` (`.claude/skills/thyrox/SKILL.md`) |
| `pm-thyrox/references/` | `thyrox/references/` |
| Capa 2: `pm-thyrox SKILL + N skills` | Capa 2: `thyrox SKILL + N skills` |

El prefijo `pm-` fue eliminado porque THYROX no es Project Management (PMI) — es el nombre propio del sistema.

### Actualización 2 — 7 fases → 12 stages (ÉPICA 39)

El ADR describe un ciclo de 7 fases. En ÉPICA 39 se restructuró el ciclo THYROX a 12 stages propios:

| Antes (7 fases) | Ahora (12 stages) |
|----------------|-------------------|
| ANALYZE | DISCOVER (Stage 1) |
| SOLUTION_STRATEGY | BASELINE (Stage 2) / DIAGNOSE (Stage 3) |
| PLAN | CONSTRAINTS (Stage 4) / STRATEGY (Stage 5) / SCOPE (Stage 6) |
| STRUCTURE | DESIGN/SPECIFY (Stage 7) |
| DECOMPOSE | PLAN EXECUTION (Stage 8) |
| EXECUTE | PILOT/VALIDATE (Stage 9) / IMPLEMENT (Stage 10) |
| TRACK | TRACK/EVALUATE (Stage 11) / STANDARDIZE (Stage 12) |

La nomenclatura cambió: "FASE N" → "ÉPICA N" (número secuencial global), "Phase N" → "Stage N" (etapa dentro del WP).

La Tabla Estado Actual vs Objetivo (sección final) referencia "7 fases" y "pm-thyrox SKILL ~430 líneas" — esos números corresponden al estado en 2026-04-08. El estado actual es:
- `thyrox SKILL` — ciclo de 12 stages, ~430+ líneas con referencias completas
- `/workflow_*` skills — renombrados y restructurados (12 skills: workflow-discover...workflow-standardize)

### Actualización 3 — THYROX como sistema de Agentic AI (ÉPICA 41)

El posicionamiento implícito en este ADR ("pm-thyrox SKILL para gestión de proyectos") fue revisado en ÉPICA 41. La decisión formal se documenta en `adr-thyrox-agentic-ai-identity.md`.

Resumen: THYROX no es un "framework de gestión" pasivo — es un **sistema de Agentic AI** con 23 agentes, multi-agent coordination, HITL gates, memoria persistente (FAISS) y hooks reactivos. La implementación actual es sobre Claude Code (Anthropic); la identidad del sistema es independiente de la plataforma.

Esta actualización no modifica las decisiones arquitectónicas D-01..D-09. La arquitectura de 5 capas sigue vigente; el cambio es de naming y posicionamiento conceptual.

*Fuente: nueva documentación oficial de Claude Code (FASE 22 — framework-evolution). Las decisiones D-01..D-09 no se modifican.*

### Corrección 1 — H1 matizado: 3 modos de triggering de SKILLs

H1 decía "SKILLs tienen triggering probabilístico" sin distinción. La nueva documentación oficial distingue 3 modos:

| Modo | Cómo se activa | Confiabilidad | Cómo configurar |
|------|----------------|--------------|-----------------|
| **model-invocable** | Claude decide cuándo usarlo (basado en `description`) | Probabilístico | Sin `disable-model-invocation` |
| **user-invocable** | Usuario escribe `/<name>` explícitamente | Determinístico | Sin `disable-model-invocation` (ambos modos aplican) |
| **hidden** | Solo `/<name>` — el modelo nunca lo auto-selecciona | Determinístico | `disable-model-invocation: true` en frontmatter |

**Impacto en arquitectura:** H1 sigue válido para el modo model-invocable. Los modos user-invocable y hidden son determinísticos — cambia la justificación de migrar /workflow_* a skills hidden (SPEC-C01/ADR-016).

### Corrección 2 — Capa 0: "determinístico" aplica solo a hooks type:command

D-01 lista Capa 0 como "100% determinístico (harness/shell)". Eso aplica estrictamente a hooks de tipo `command`. La documentación oficial documenta 4 tipos de hook:

| Tipo | Comportamiento | Determinístico |
|------|----------------|----------------|
| `command` | Ejecuta shell command | Sí (harness) |
| `prompt` | Inyecta texto en el prompt | Probabilístico (interpretación de Claude) |
| `agent` | Invoca un agente Claude | Determinístico (lanzamiento) |
| `http` | Llama a un endpoint HTTP | Determinístico (llamada) |

**pm-thyrox usa solo `type: command`** → la afirmación "100% determinístico" sigue siendo correcta para el uso actual. Si en el futuro se usan hooks de tipo `prompt`, esta característica no aplica.

### Corrección 3 — Capa 1: .claude/rules/ como sublayer path-scoped

La tabla de 5 capas en D-01 lista Capa 1 solo como "CLAUDE.md". La documentación oficial documenta `.claude/rules/` como un mecanismo adicional de Capa 1:

| Sublayer | Mecanismo | Scope | Overhead |
|----------|-----------|-------|---------|
| CLAUDE.md | System prompt global | Todo el proyecto | Siempre cargado |
| `.claude/rules/*.md` | Instrucciones path-scoped | Solo cuando aplica el path | Condicional |

**Implicación:** `.claude/rules/` es un sublayer de Capa 1 que permite instrucciones específicas por directorio. No reemplaza CLAUDE.md — lo complementa con granularidad de path. THYROX no usa `.claude/rules/` actualmente.

### Corrección 4 — Capa 3: actualizar a "skills hidden" (post-TD-008)

La tabla de 5 capas en D-01 lista Capa 3 como "/workflow_* commands (determinístico si el usuario los invoca)". Post-TD-008:

| Estado | Capa 3 |
|--------|--------|
| Pre-TD-008 (HOY) | `/workflow_*` en `.claude/commands/` — slash commands clásicos |
| Post-TD-008 | `/workflow_*` en `.claude/skills/` con `disable-model-invocation: true` — skills hidden |

La UX es idéntica (`/<name>` sigue funcionando). La diferencia es el mecanismo de almacenamiento y la capacidad de añadir frontmatter con hooks automáticos. La decisión se documenta en ADR-016.

### Corrección 5 — Agent teams como 4ª categoría de coordinación

D-08 documenta 3 patrones de estado para coordinación multi-agente. La documentación oficial describe un 4º patrón experimental:

| Patrón | Mecanismo | Naturaleza |
|--------|-----------|-----------|
| now.md | Archivo de estado compartido | Orquestador → agente |
| now-{agent-name}.md | Archivo por agente | Agente → orquestador |
| git commits | Barriers de sincronización | Cualquier → cualquier |
| **Agent teams** | Agentes peer-to-peer vía `Agent` tool | Experimental (sin orquestador central) |

**Agent teams:** patrón donde múltiples agentes se coordinan entre sí sin un orquestador central, usando el `Agent` tool para delegar subtareas. Documentado como experimental — no usar en producción hasta que la documentación oficial lo estabilice.
