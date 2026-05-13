```yml
created_at: 2026-04-23 09:30:00
project: THYROX
category: ADK — Agent Development Kit
type: pattern
id: P-005
severity: ALTO
origin: discover/patterns (legacy framework)
```

# ADK Tool Callback Contract

Patrón de contrato correcto para callbacks de herramientas en Google ADK.

## Problema

El ADK define dos tipos de contexto distintos para callbacks: `CallbackContext` para callbacks de modelo (before/after model) y `ToolContext` para callbacks de herramientas (before/after tool). Usar `CallbackContext` en `before_tool_callback` provoca un `TypeError` en runtime porque el framework pasa una instancia de `ToolContext` que no es compatible con la firma declarada.

### Anti-patrón

```python
# INCORRECTO
from google.adk.agents import LlmAgent
from google.adk.agents.callback_context import CallbackContext  # ← tipo incorrecto
from google.adk.tools import BaseTool

class MyAgent(LlmAgent):
    def before_tool_callback(
        self,
        tool: BaseTool,
        args: dict,
        ctx: CallbackContext,  # ← ERROR: tipo incorrecto para tool callbacks
    ) -> dict | None:
        # Validar o modificar args antes de ejecutar la tool
        if "query" in args and len(args["query"]) > 1000:
            args["query"] = args["query"][:1000]
        return None
```

**Por qué falla:** En Python con type checking estricto, esto falla en la llamada; sin type checking, puede fallar más adelante al intentar acceder a atributos específicos de `ToolContext`.

## Solución (el Patrón)

### Patrón correcto

```python
# CORRECTO
from google.adk.agents import LlmAgent
from google.adk.tools import BaseTool
from google.adk.tools.tool_context import ToolContext  # ← importar el tipo correcto

class MyAgent(LlmAgent):
    def before_tool_callback(
        self,
        tool: BaseTool,
        args: dict,
        tool_context: ToolContext,  # ← tipo correcto
    ) -> dict | None:
        # Validar o modificar args antes de ejecutar la tool
        if "query" in args and len(args["query"]) > 1000:
            args["query"] = args["query"][:1000]
        return args  # retornar los args modificados (o None para usar los originales)
```

**Por qué funciona:** `ToolContext` expone atributos específicos de la ejecución de tools: acceso al `state` de la sesión, a las `actions` disponibles, y al contexto de invocación de la herramienta. Al usar el tipo correcto, el framework puede pasar el objeto apropiado y el código puede acceder a todos los atributos disponibles en ese contexto.

## Implementación

**Regla de tipos:**

| Callback | Tipo de contexto correcto |
|----------|---------------------------|
| `before_model_callback` | `CallbackContext` |
| `after_model_callback` | `CallbackContext` |
| `before_tool_callback` | `ToolContext` |
| `after_tool_callback` | `ToolContext` |

```python
# Siempre verificar el tipo correcto en la firma
def before_tool_callback(
    self,
    tool: BaseTool,
    args: dict,
    tool_context: ToolContext,  # ← ToolContext, no CallbackContext
) -> dict | None:
    ...
    return args  # o None si no hay cambios
```

## Cuándo Aplicar

- Siempre que implemente callbacks de herramientas en ADK
- Cuando validate o modifique arguments antes de ejecutar la herramienta
- Cuando acceda a estado de la sesión en un tool callback

## Alternativas Consideradas

- Duck typing (confiar en que funcione): funciona en tests sin type checking, pero falla en producción
- Usar solo callbacks de modelo: menos flexible, no permite validación de arguments de tools
