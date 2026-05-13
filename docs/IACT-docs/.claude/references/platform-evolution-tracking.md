# Platform Evolution Tracking — Claude Code

> On-demand reference. No cargado automáticamente.
> Propósito: detectar cambios de plataforma que afecten componentes THYROX.
> Proceso: verificar al inicio de una ÉPICA si hay cambios relevantes.

## Componentes THYROX con dependencia directa de plataforma

| Componente | Versión verificada | Comportamiento esperado | Cómo detectar cambio |
|------------|-------------------|------------------------|----------------------|
| `@imports` en CLAUDE.md | Claude Code ~1.x | Carga archivos referenciados con ruta relativa al repo | Si una guideline no aplica → revisar sección Memory del changelog |
| Hooks API (`settings.json`) | Claude Code ~1.x | `PreToolUse`, `PostToolUse`, `Stop`, `SessionStart` | Si hook no dispara → verificar `hookEventName` en settings |
| Agent frontmatter | Claude Code ~1.x | `name`, `description`, `tools`, `model`, `async_suitable` | Si agente no auto-invoca → revisar formato en docs oficiales |
| Slash commands | Claude Code ~1.x | Archivos en `.claude/commands/` sin frontmatter | Si comando no disponible → verificar plugin.json |

## Proceso de verificación

Al inicio de una ÉPICA nueva, verificar (máximo 10 min):
1. Leer changelog de Claude Code por releases desde la última ÉPICA
2. Para cada componente en tabla → confirmar que comportamiento esperado sigue vigente
3. Si hay cambio → crear TD-NNN en technical-debt.md

## Historial de cambios detectados

| ÉPICA | Componente | Cambio detectado | Acción tomada |
|-------|-----------|-----------------|---------------|
| 42 | `@imports` | TD-040: duda sobre carga de rutas fuera de `.claude/` | T-001 PASS — mecanismo confirmado funcional |

## Validación de referencias del libro de patrones agentic

Cuando THYROX adopta un patrón de un libro o fuente externa, verificar:
1. ¿El código ejecutable hace lo que el título del capítulo promete?
2. ¿Los imports del ejemplo están completos y son correctos?
3. ¿Las URLs son raw content ejecutable?
4. ¿Los métodos de protocolo son de la versión actual de la librería?

**Patrones sistémicos detectados en libro analizado (ÉPICA 42):**
- Named Mechanism vs. Implementation (Cap.10-15): título nombra mecanismo que el código no implementa
- Implementation Facade (Cap.8): código funcional pero con lógica decorativa
- Credibilidad Prestada: referencia a paper/estándar sin derivación del claim específico

**Regla:** al adoptar un patrón de esta fuente, citar el hallazgo del deep-dive (AP-ID), no solo el capítulo.
