---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-howto
domain: introduction
repo: claude-howto
---

# Introduction: Hallazgos de claude-howto

## Patrones identificados

### Patrón 1 — Tutorial progresivo estructurado por niveles
**Descripción:** El repo se organiza explícitamente en 3 niveles de usuario (Beginner/Intermediate/Advanced) con un self-assessment quiz que genera un learning path personalizado. Este no es un reference doc sino un tutorial con mermaid diagrams, copy-paste templates y time estimates.
**Fuente:** README.md, LEARNING-ROADMAP.md
**Relevancia:** Alta

### Patrón 2 — Filosofía "combinations over features"
**Descripción:** El problema declarado explícitamente es que "la documentación oficial describe features pero no muestra cómo combinarlas". El valor del repo es enseñar combinaciones: Slash Commands + Memory + Subagents + Hooks = pipelines productivos.
**Fuente:** README.md:46-50
**Relevancia:** Alta

### Patrón 3 — Feature comparison matrix como herramienta de decisión
**Descripción:** Cada feature se define en contraste con otras a través de tablas: invocación, persistencia, mejor uso. Esto aparece en README, CATALOG y QUICK_REFERENCE como patrón recurrente.
**Fuente:** README.md (Feature Comparison table), CATALOG.md, QUICK_REFERENCE.md
**Relevancia:** Alta

### Patrón 4 — "Get started in 15 minutes" como hook de onboarding
**Descripción:** El repo provee una ruta de 15 minutos (copiar un slash command, probar /optimize) como entrada de baja fricción. Esto separa el "primer valor" de la maestría completa (11-13h).
**Fuente:** README.md:141-177
**Relevancia:** Media

### Patrón 5 — Compatibilidad declarada con modelos específicos
**Descripción:** El repo especifica compatibilidad con Claude Sonnet 4.6, Opus 4.6, Haiku 4.5. Todas las templates trabajan con los tres modelos. La versión de Claude Code es 2.1.97, publicada en April 2026.
**Fuente:** README.md:211-213, INDEX.md (footer)
**Relevancia:** Media

## Conceptos clave

- **10 módulos de tutorial** que van de Beginner a Advanced (30 min a 3 horas por módulo)
- **Tiempo total** estimado: 11-13 horas para completar el path completo
- **21,800+ GitHub stars** — repo de alta adopción entre developers
- **EPUB exportable** via `uv run scripts/build_epub.py` para uso offline
- **Self-assessment interactivo**: `/self-assessment` dentro de Claude Code genera path personalizado
- **Lesson quizzes**: `/lesson-quiz [topic]` para verificar comprensión

## Notas adicionales

El repo es explícitamente una guía tutorial (no documentación oficial). Complementa los official docs. La última versión (v2.3.0, April 2026) está sincronizada con Claude Code 2.1.97.

El problema que resuelve: los developers que instalaron Claude Code pero usan <10% de su capacidad por no saber cómo combinar features. Este framing es valioso para entender qué aspectos documentar primero.
