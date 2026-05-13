```yml
type: Reference
title: SKILL vs Agente — Distinción y regla de decisión
work_package: 2026-04-07-03-08-03-agent-format-spec
created_at: 2026-04-07 05:22:12
status: Activo
covers: R-006
owner: thyrox (cross-phase)
```

# SKILL vs Agente — Distinción y regla de decisión

---

## Tabla comparativa

| Dimensión | SKILL | Agente |
|-----------|-------|--------|
| **Qué es** | Documento de metodología que define cómo trabajar en un dominio. Instrucciones que Claude lee y sigue en la sesión activa. | Subagente nativo de Claude Code con identidad, tools propios y scope de ejecución acotado. Se invoca en paralelo o como especialista puntual. |
| **Dónde vive** | `.claude/skills/{nombre}/SKILL.md` — dentro del sistema THYROX | `.claude/agents/{nombre}.md` — directorio de agentes nativos de Claude Code |
| **Cómo se activa** | 3 modos: (1) **model-invocable** — Claude decide por `description`; (2) **user-invocable** — usuario escribe `/<name>`; (3) **hidden** — solo `/<name>`, modelo no lo auto-selecciona (`disable-model-invocation: true`) | Claude Code lo selecciona automáticamente por `description` (routing), o el usuario lo invoca explícitamente |
| **Acceso a tools** | No declara tools propios — usa los del contexto de la sesión principal | Declara su propio conjunto de `tools` en el frontmatter; solo tiene acceso a esos tools |
| **Ejecución en paralelo** | No — es metodología que el agente principal integra en su razonamiento | Sí — Claude Code puede lanzar múltiples agentes en paralelo con el `Task` tool |
| **Formato del archivo** | Markdown con secciones estructuradas (fases, checklists, decisiones). Sin frontmatter obligatorio. | Frontmatter YAML con `name`, `description`, `tools` + cuerpo markdown con instrucciones del sistema |
| **Cuándo modificar** | Solo si cambia la metodología general de gestión | Cuando cambia el scope, las tools disponibles, o el routing del agente |

---

## Regla de decisión

**Crear un SKILL** cuando lo que quieres codificar es una metodología reutilizable de trabajo (un proceso, un conjunto de fases, una forma de pensar un dominio); **crear un agente** cuando quieres un especialista autónomo con tools acotadas que puede ejecutarse en paralelo o ser seleccionado por routing automático para una tarea específica.

---

## Ejemplos del proyecto THYROX

### SKILLs activos

| Nombre | Path | Propósito |
|--------|------|-----------|
| `thyrox` | `.claude/skills/thyrox/SKILL.md` | Sistema agentic de gestión de proyectos con 12 stages (DISCOVER → STANDARDIZE). Motor del sistema THYROX. |
| `python-mcp` | `.claude/skills/python-mcp/SKILL.md` | Guía para implementar servidores MCP en Python: estructura, registro de tools, patrones de testing. |

### Agentes activos

| Nombre | Path | Propósito |
|--------|------|-----------|
| `task-executor` | `.claude/agents/task-executor.md` | Ejecuta tareas atómicas de un task-plan.md. Usar cuando hay checkboxes T-NNN pendientes y se quiere implementar la siguiente tarea sin contexto de gestión. |
| `task-planner` | `.claude/agents/task-planner.md` | Descompone un work package en tareas atómicas. Usar cuando se tiene una solution-strategy aprobada y se necesita el task-plan. |
| `tech-detector` | `.claude/agents/tech-detector.md` | Detecta el stack tecnológico de un proyecto. Usar cuando se inicia un work package y se necesita saber qué skills activar. |
| `skill-generator` | `.claude/agents/skill-generator.md` | Genera agentes nativos desde un registry YML. Usar cuando se quiere crear un nuevo agente tech-expert a partir de un template. |

---

## Las 5 capas y sus rutas de ejecución

Arquitectura de 5 capas de thyrox (ADR-015). Cada capa tiene un mecanismo de triggering distinto.

### Tabla de capas

| Capa | Nombre | Triggering | Overhead sesiones no-PM | Actualizable sin migración |
|------|--------|-----------|------------------------|--------------------------|
| 0 — Hooks | shell scripts (harness) | 100% determinístico | Negligible | Sí |
| 1 — CLAUDE.md | system prompt declarativo | Siempre cargado | Bajo (~80 líneas) | Sí |
| 2 — SKILLs (N) | text injection on-demand | Probabilístico | Bajo (solo si se invocan) | Sí |
| 3 — /thyrox:* (plugin) / workflow-* (interno) | slash commands | Determinístico (usuario lo invoca) | Bajo (solo si se usan) | Sí (independiente por fase) |
| 4 — Agentes nativos | subprocesos Claude | Determinístico (una vez lanzados) | 0 (contexto propio) | Sí |

### Tabla de rutas (hoy vs objetivo)

| Ruta | Mecanismo | Calidad HOY | Confiabilidad HOY | Criterio de uso |
|------|-----------|-------------|-------------------|----------------|
| A — thyrox SKILL | Capa 2, probabilístico | Alta (lógica completa) | Media (puede no disparar) | Usar HOY cuando se necesita calidad máxima |
| B — /thyrox:* commands (plugin) | Capa 3, determinístico | Alta (thin wrappers → workflow-* SKILL.md) | Alta (si el usuario los invoca) | Ruta preferida (FASE 31+, interfaz pública) |
| C — /workflow-* (interno) | Capa 2 hidden skills | Alta (implementación completa) | Alta | Uso interno — no exponer al usuario final |

**session-start.sh** (Capa 0) muestra las opciones A y B al inicio de cada sesión. A partir de FASE 31, B muestra `/thyrox:*` como interfaz pública (sin etiqueta `[outdated]`).

### Tipos de hook en Capa 0

La documentación oficial de Claude Code documenta 4 tipos de hook. Solo `command` es 100% determinístico ejecutado por el harness.

| Tipo | Comportamiento | Determinístico | Uso en thyrox |
|------|----------------|----------------|-----------------|
| `command` | Ejecuta shell command vía harness | Sí | SessionStart, Stop, PostCompact |
| `prompt` | Inyecta texto en el próximo prompt de Claude | Probabilístico (interpretación de Claude) | No usado actualmente |
| `agent` | Invoca un agente Claude Code | Determinístico (lanzamiento del agente) | No usado actualmente |
| `http` | Llama a un endpoint HTTP externo | Determinístico (llamada HTTP) | No usado actualmente |

**Regla:** thyrox solo usa `type: command` → la garantía de determinismo de Capa 0 aplica. Si en el futuro se usan hooks `prompt`, esa garantía no aplica para esos hooks.

---

## 5 hallazgos externos sobre SKILLs

Evidencia recopilada en FASE 21 que impacta las decisiones arquitectónicas de thyrox.
Fuentes: artículo "The Ultimate Guide to Claude Code Skills" (Mar 2026) + análisis FASE 21.

| ID | Hallazgo | Evidencia | Fuente |
|----|----------|-----------|--------|
| H1 | **Triggering probabilístico** — Un SKILL perfectamente escrito puede no dispararse. | 0 de 20 prompts que deberían activar una CPO review skill → 0 disparos. | Artículo Mar 2026 |
| H2 | **PTC es ortogonal a hooks y commands** — PTC mejora eficiencia interna de agentes (Capa 4), no reemplaza la arquitectura de capas. | PTC disponible en API, no en Claude Code Web. /workflow_* y hooks no cambian cuando PTC llegue. | Análisis FASE 21 |
| H3 | **Truncación de descripciones al escalar** — El budget de context para SKILL descriptions es ~1% del context window. Con 16 skills activos, la truncación de keywords reduce la tasa de disparo. | THYROX: 16 skills activos → rango donde la truncación ya puede ocurrir. | Análisis FASE 21 |
| H4 | **SKILLs son prompt injection** — No hay magia arquitectónica. 40 de 47 skills probados empeoraron el output. | "Skills are prompt injections. That's it. Nothing more magical than that." | Artículo Mar 2026 |
| H5 | **CLAUDE.md como alternativa más simple** — Siempre cargado, sin triggering probabilístico, sin riesgo de truncación. | "Why not just stick with a well-written system prompt in your CLAUDE.md? It's simpler, always loads..." | Artículo Mar 2026 |

**Implicación para thyrox:** Los hallazgos H1/H3/H4 justifican la arquitectura de 5 capas (ADR-015):
Hooks (100% determinísticos) + CLAUDE.md (siempre cargado) compensan la confiabilidad media del SKILL.

---

## Tabla de decisión — SKILL vs /workflow_* vs agente vs CLAUDE.md

Cuándo usar cada mecanismo. Usar la primera fila que aplique.

| Situación | Mecanismo | Razón |
|-----------|-----------|-------|
| Instrucciones que deben aplicarse en TODA sesión sin excepción | CLAUDE.md (Capa 1) | Siempre cargado, sin triggering probabilístico |
| Metodología de trabajo que se activa on-demand por dominio | SKILL (Capa 2) | Inyección de texto con conocimiento especializado |
| Ejecutar una fase específica del ciclo PM de forma determinística | `/thyrox:*` command (Capa 3, plugin) | Determinístico cuando el usuario lo invoca |
| Especialista autónomo con tools acotadas, ejecutable en paralelo | Agente nativo (Capa 4) | Subproceso con contexto propio, tools declaradas |
| Múltiples agentes coordinados sin orquestador central | Agent teams (experimental) | Agentes peer-to-peer vía `Agent` tool — no usar en producción hasta estabilización |
| Notificación o trigger al inicio/fin de sesión | Hook (Capa 0) | 100% determinístico, ejecutado por el harness |

### Naturaleza de cada mecanismo

| Mecanismo | Naturaleza | Confiabilidad | Overhead |
|-----------|-----------|---------------|---------|
| CLAUDE.md | Declarativo, siempre en contexto | Alta (siempre) | Bajo (~80 líneas fijas) |
| SKILL | Probabilístico, on-demand | Media (puede no disparar) | Bajo (solo si se invoca) |
| `/thyrox:*` command (plugin) | Determinístico, usuario lo invoca explícitamente | Alta (si se usa) | 0 (solo cuando se usa) |
| Agente nativo | Determinístico una vez lanzado, contexto propio | Alta | 0 (contexto separado) |
| Agent teams | Experimental — agentes peer-to-peer vía `Agent` tool | Media (experimental) | 0 por agente (contextos separados) |

**Referencia completa:** ADR-015 documenta el razonamiento
completo detrás de la arquitectura de 5 capas y las opciones descartadas.

---

## Señales de confusión frecuente

- Si el archivo necesita `tools` para hacer su trabajo → es un agente, no un SKILL.
- Si el archivo define fases o un proceso de pensamiento → es un SKILL, no un agente.
- Si quieres que se ejecute en paralelo con otros → definitivamente un agente.
- Si quieres que cambie cómo Claude razona en una sesión entera → definitivamente un SKILL.
