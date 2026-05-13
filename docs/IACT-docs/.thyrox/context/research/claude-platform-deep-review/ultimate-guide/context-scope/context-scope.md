---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: context-scope
repo: claude-code-ultimate-guide
---

# Context Engineering y Gestión de Sesiones: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Context engineering vs prompt engineering: distinción explícita
**Descripción:** Prompt engineering es "crafting the right question for one task". Context engineering es "el sistema que asegura que Claude tiene el background correcto antes de cualquier tarea". La diferencia: scope (una interacción vs toda la sesión), duración (ephemeral vs persistente), artefacto (un string vs un sistema de configuración).
**Fuente:** core/context-engineering.md:46-58
**Relevancia:** Alta

### Patrón 2 — Jerarquía de 3 capas de contexto
**Descripción:** Global (`~/.claude/CLAUDE.md`, siempre activo), Project (`./CLAUDE.md` + módulos path-scoped, por sesión), Session (instrucciones inline, flags, ephemeral). Cada capa posterior overridea las anteriores. Las más específicas ganan.
**Fuente:** core/context-engineering.md:99-111
**Relevancia:** Alta

### Patrón 3 — Arquitectura modular con path-scoping
**Descripción:** En lugar de un CLAUDE.md monolítico, usar módulos por subsistema cargados solo cuando los archivos relevantes están en scope. Ejemplo: `src/api/CLAUDE-api.md`, `src/components/CLAUDE-components.md`. Resultado: reducción 40-50% del contexto always-on sin pérdida de cobertura.
**Fuente:** core/context-engineering.md:418-455
**Relevancia:** Alta

### Patrón 4 — Context rot es estructural, no accidental
**Descripción:** Los transformers atienden todos los tokens pairwise (relaciones crecen como n²). Con 200K tokens = billones de cómputos pairwise → atención difusa. No es un bug que los modelos futuros eliminarán; es consecuencia de la arquitectura. La solución no es una ventana mayor sino contexto más lean.
**Fuente:** core/context-engineering.md:128-133
**Relevancia:** Alta

### Patrón 5 — Just-in-time retrieval vs pre-loading
**Descripción:** Pre-loading (RAG): recuperar todo el contexto potencialmente relevante antes de la inferencia. JIT retrieval: recuperar exactamente lo necesario cuando se necesita via tool calls. Claude Code usa ambos: CLAUDE.md se pre-carga, file contents se recuperan on-demand via Read/Grep/Glob.
**Fuente:** core/context-engineering.md:137-147
**Relevancia:** Alta

### Patrón 6 — Memory tool (beta, Sonnet 4.5+)
**Descripción:** Tool de memoria en beta público: almacena y recupera hechos persistentes across sessions sin gestión manual de CLAUDE.md. Distinto de CLAUDE.md (siempre cargado) — Memory tool es recuperación dinámica on-demand. Reduce la necesidad de codificar conocimiento manualmente en config files.
**Fuente:** core/context-engineering.md:149-153
**Relevancia:** Media

### Patrón 7 — Session handoff pattern
**Descripción:** Iniciar una nueva sesión y pasar un documento de contexto resumido de la sesión anterior cuando el contexto está exhausto o degradado. Más controlado que esperar a auto-compact (que pierde matices).
**Fuente:** core/glossary.md:115 ("Session handoff")
**Relevancia:** Alta

### Patrón 8 — ACE pipeline para gestión intencional de contexto
**Descripción:** Assemble (construir el contexto correcto antes del task), Check (verificar que el contexto es completo y consistente), Execute (ejecutar con ese contexto establecido). Framework para pensar la gestión de contexto en 3 fases.
**Fuente:** core/glossary.md:24 ("ACE pipeline")
**Relevancia:** Media

### Patrón 9 — Session Pattern Discovery con cc-sessions
**Descripción:** La herramienta `cc-sessions discover` analiza el historial de sesiones para identificar patrones recurrentes. Regla del 20%: >20% de sesiones → regla en CLAUDE.md, 5-20% → skill, <5% → command. Automatiza la detección de qué debería extraerse.
**Fuente:** ultimate-guide.md:890-951
**Relevancia:** Media

### Patrón 10 — Thresholds de contexto con respaldo en investigación
**Descripción:** <70%: capacidad completa de razonamiento. 75%: buen momento para `/compact` manual. 85%: territorio de auto-compact — handoff manual recomendado. 95%: force handoff, degradación severa. Investigación: LLM performance cae 50-70% en tareas complejas al crecer contexto de 1K a 32K tokens (Context Rot Research, Jul 2025).
**Fuente:** core/architecture.md:425-433
**Relevancia:** Alta

### Patrón 11 — Failure-triggered context drift (mecanismo distinto)
**Descripción:** Errores repetidos de herramientas acumulan stack traces y retry noise en el contexto. El modelo empieza a seguir la narrativa del error en lugar del objetivo original. Solución: hook PostToolUse que re-inyecta el task original después de fallos.
**Fuente:** core/architecture.md:474-487
**Relevancia:** Media

### Patrón 12 — Semantic priming hypothesis
**Descripción:** Cuando se ultra-comprime un contexto, el modelo no recuerda la información removida verbatim. El contexto comprimido actúa como "semantic prime" activando conocimiento latente en los pesos. Palabras clave y señales estructurales pueden activar más conocimiento relevante que párrafos de prosa.
**Fuente:** ecosystem/context-engineering-tools.md:72-78
**Relevancia:** Media

## Conceptos clave

- Context engineering = sistema, no per-request crafting
- Path-scoping: la técnica más efectiva para reducir always-on context
- Context rot tiene base matemática (n² attention) y no desaparece con modelos más grandes
- Memory tool (beta): recuperación dinámica vs CLAUDE.md estático
- "Most AI output failures are context failures, not model failures"
- El 20% rule como framework de decisión para dónde poner las instrucciones

## Notas adicionales

El documento `context-engineering.md` incluye un "maturity model" para evaluar el nivel de sofisticación de las prácticas de context engineering de un equipo (sección 9). También tiene un workflow de "Token Audit" (sección 10) para auditar qué está consumiendo tokens en el contexto.

La distinción entre "context synthesis" (acumulación estatal, CLAUDE.md) y "reasoning" (ephemeral, chain of thought) es clave: mezclarlos contamina el contexto con ruido ephemeral.
