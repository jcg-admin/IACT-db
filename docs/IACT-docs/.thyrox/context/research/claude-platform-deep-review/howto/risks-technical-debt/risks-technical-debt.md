---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: risks-technical-debt
---

# Risks & Technical Debt — Claude Code How-To

## Patrones

### Patrón 1: Riesgo documentado: pérdida de contexto en sesiones largas

Los checkpoints existen como respuesta explícita al riesgo de pérdida de contexto. El "Summarize from here" es una herramienta de mitigación de riesgo: comprimir contexto para continuar trabajando sin perder la historia. El cc-context-stats integration permite monitorear cuándo el contexto se está llenando. El riesgo de pérdida de contexto tiene tres mitigaciones documentadas.

Fuente: `08-checkpoints/README.md`; `08-checkpoints/checkpoint-examples.md`, Example 8.

### Patrón 2: Riesgo documentado: cambios no rastreados por bash externo

Los checkpoints no rastrean cambios hechos fuera de Claude Code (bash directo, scripts externos). Esto es una limitación explícita y documentada. El riesgo: hacer un rewind puede no restaurar el estado completo si hubo cambios externos. El workaround implícito: usar Claude Code para todas las operaciones durante una sesión de trabajo.

Fuente: `08-checkpoints/README.md`, sección Limitations.

### Patrón 3: Riesgo de seguridad: API keys en memoria o hooks

La documentación de plugins y hooks advierte explícitamente: "Never commit API keys or credentials". El `STYLE_GUIDE.md` tiene este punto en el checklist de autores. Los plugins usan keychain para credenciales. El riesgo de exposición de credentials es reconocido en múltiples puntos del repo.

Fuente: `STYLE_GUIDE.md`, sección Checklist; `07-plugins/README.md`, sección userConfig.

### Patrón 4: Riesgo de scope creep en CLAUDE.md

La skill `claude-md/SKILL.md` documenta explícitamente el riesgo de CLAUDE.md creciendo demasiado: límite recomendado de 300 líneas, prohibición de style rules y code snippets en CLAUDE.md, uso de `agent_docs/` para documentación extendida. El riesgo de "CLAUDE.md inflado" tiene reglas preventivas documentadas.

Fuente: `03-skills/claude-md/SKILL.md`, sección Golden Rules.

### Patrón 5: Riesgo de degradación de performance por context budget saturado

`SLASH_COMMAND_TOOL_CHAR_BUDGET` controla cuánto contexto cargan los skills. La documentación advierte que cargar demasiadas skills simultáneamente degrada la calidad del triggering. El repo recomienda máximo 2-3 skills activos simultáneamente (implícito en la arquitectura de progressive disclosure). El riesgo de context saturation tiene una estrategia de mitigación arquitectural.

Fuente: `03-skills/README.md`, sección Context Budget; CLAUDE.md del proyecto Thyrox, sección Multi-skill orchestration.

### Patrón 6: Deuda técnica: SSE transport deprecated

El transporte SSE para MCP está marcado como deprecated en favor de HTTP. Los repos que usaban SSE tienen deuda técnica de migración a HTTP. El repo documenta esto como "SSE (deprecated)" sin un migration guide explícito.

Fuente: `05-mcp/README.md`, sección Transports.

### Patrón 7: Riesgo de vendor lock-in en Agent Teams experimental

Agent Teams está marcado como "experimental" con `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. Las features experimentales pueden cambiar o eliminarse. Construir workflows críticos sobre features experimentales es un riesgo de mantenibilidad documentado implícitamente por la etiqueta "experimental".

Fuente: `04-subagents/README.md`, sección Agent Teams.

## Conceptos

- **Context loss mitigation**: checkpoints + auto memory como defensa en profundidad contra pérdida de contexto
- **Credential security**: keychain storage como estándar para secrets en plugins
- **CLAUDE.md bloat risk**: límite de 300 líneas como regla preventiva de deuda técnica
- **Experimental feature risk**: etiqueta "experimental" como señal de volatilidad de API
- **External change blind spot**: limitación estructural de los checkpoints ante cambios externos

## Notas

El repo es notable por documentar sus propias limitaciones explícitamente en lugar de ignorarlas. Cada riesgo identificado tiene al menos una estrategia de mitigación documentada. Esta cultura de "documentar las limitaciones" es una señal de madurez del proyecto y contrasta con documentación que solo documenta el happy path.
