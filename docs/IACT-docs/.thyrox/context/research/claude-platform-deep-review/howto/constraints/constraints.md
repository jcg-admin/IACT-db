---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: constraints
---

# Constraints — Claude Code How-To

## Patrones

### Patrón 1: Límites de context window como restricción de diseño

Las skills usan `SLASH_COMMAND_TOOL_CHAR_BUDGET` para controlar cuánto contexto cargan. El sistema de progressive disclosure (3 niveles: minimal, standard, verbose) existe precisamente para operar dentro de las restricciones del context window. Los archivos CLAUDE.md tienen un límite recomendado de 300 líneas. La restricción de context es un driver de arquitectura explícito.

Fuente: `03-skills/README.md`; `03-skills/claude-md/SKILL.md`, sección Golden Rules.

### Patrón 2: Límites de MCP output como restricción operacional

Los MCP tools tienen un límite de 25K de output por defecto, ampliable a 50K con persistencia en disco. Las descripciones de herramientas MCP tienen un cap de 2KB. El patrón de "code execution via MCP" reduce tokens en 98.7% precisamente para operar dentro de estos límites. Los límites son conocidos y tienen workarounds documentados.

Fuente: `05-mcp/README.md`, sección Output Limits y Code Execution Pattern.

### Patrón 3: Checkpoints no capturan cambios externos

El sistema de checkpoints tiene una restricción explícita: no rastrea cambios hechos por bash commands externos o herramientas fuera de Claude Code. La documentación lo llama "limitation" y lo documenta como tal. Es una restricción arquitectural del modelo de persistencia actual.

Fuente: `08-checkpoints/README.md`, sección Limitations.

### Patrón 4: Plugin subagents con restricciones de seguridad

Los subagentes lanzados desde plugins tienen restricciones específicas: no pueden crear otros subagentes, no pueden acceder a herramientas fuera de las aprobadas para el plugin, no pueden modificar configuración del sistema. Es una restricción de sandbox de seguridad, no de capacidad técnica.

Fuente: `07-plugins/README.md`, sección Plugin Subagent Restrictions; `04-subagents/README.md`.

### Patrón 5: Dependencias de versión de Claude Code

Los features avanzados tienen requisitos de versión mínima documentados: Claude.ai MCP Connectors requiere v2.1.83+, MCP Elicitation requiere v2.1.49+. El metadata footer de los documentos especifica versión compatible (`Claude Code Version: 2.1.97`). Las funcionalidades nuevas tienen dependency constraints de versión.

Fuente: `05-mcp/README.md`; `STYLE_GUIDE.md`, sección Document Metadata Footer; `08-checkpoints/README.md`.

### Patrón 6: Auto Memory con límites de tamaño

MEMORY.md se carga al inicio si es menor a 200 líneas o 25KB. Los archivos de memoria por topic se cargan on-demand. La variable `CLAUDE_CODE_DISABLE_AUTO_MEMORY` permite deshabilitar el sistema si los límites interfieren con el proyecto.

Fuente: `02-memory/README.md`, sección Auto Memory Architecture.

## Conceptos

- **Context budget**: recursos de context window como restricción de primer orden en el diseño de skills
- **Progressive disclosure**: estrategia para operar dentro del context budget
- **Token efficiency**: MCP code execution pattern como respuesta a restricciones de tokens
- **Sandbox boundary**: restricciones de seguridad en plugins/subagentes como contratos de aislamiento

## Notas

Las restricciones en este repo son inusualmente bien documentadas — cada límite conocido tiene su workaround o explicación de por qué existe. Esto sugiere madurez en la documentación y experiencia acumulada de usuarios encontrando los límites.
