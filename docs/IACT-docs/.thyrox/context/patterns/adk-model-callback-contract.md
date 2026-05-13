```yml
created_at: 2026-04-23 09:30:00
project: THYROX
category: ADK — Agent Development Kit
type: pattern
id: P-004
severity: CRÍTICO
origin: discover/patterns (legacy framework)
```

# ADK Model Callback Contract

Patrón de contrato correcto para callbacks de modelo en Google ADK.

## Problema

El contrato del callback en ADK especifica que el valor de retorno es el objeto que el framework usará para la llamada al modelo. Cuando se retorna `None`, el framework interpreta que no hay override y continúa con el objeto recibido — el que existía ANTES de las modificaciones. Las mutaciones en `llm_request` se pierden porque el framework no observa el estado interno del objeto mutado; solo hace branching sobre el valor de retorno.

### Anti-patrón

```python
# INCORRECTO
from google.adk.agents import LlmAgent
from google.adk.agents.callback_context import CallbackContext
from google.genai import types

class MyAgent(LlmAgent):
    def before_model_callback(
        self,
        callback_context: CallbackContext,
        llm_request: types.GenerateContentRequest
    ) -> types.GenerateContentRequest | None:
        # Modificar el objeto directamente
        llm_request.contents.append(
            types.Content(role="user", parts=[types.Part(text="Responde en JSON")])
        )
        return None  # ← ERROR: el framework usa el objeto ORIGINAL, no el modificado
```

**Por qué falla:** El error es silencioso: el agente no lanza excepción, simplemente ignora la modificación. En producción esto significa que las instrucciones de sistema, guardrails o context injection nunca se aplican, sin ninguna señal de falla.

## Solución (el Patrón)

### Patrón correcto

```python
# CORRECTO
from google.adk.agents import LlmAgent
from google.adk.agents.callback_context import CallbackContext
from google.genai import types

class MyAgent(LlmAgent):
    def before_model_callback(
        self,
        callback_context: CallbackContext,
        llm_request: types.GenerateContentRequest
    ) -> types.GenerateContentRequest | None:
        # Modificar el objeto directamente
        llm_request.contents.append(
            types.Content(role="user", parts=[types.Part(text="Responde en JSON")])
        )
        return llm_request  # ← CORRECTO: retornar el objeto modificado
```

**Por qué funciona:** El framework ADK evalúa el valor de retorno del callback. Si no es `None`, usa ese valor como el request real al modelo. Retornar el objeto modificado (incluso si es el mismo objeto mutado) hace que el framework lo tome como el input efectivo.

## Implementación

**Regla:** En `before_model_callback`, SIEMPRE retornar:
- El objeto modificado (si hiciste cambios)
- El objeto sin cambios (si pasas la request sin modificar)
- NUNCA retornar `None` cuando quieres que se apliquen cambios

```python
def before_model_callback(self, ..., llm_request):
    # Opción A: modificar y retornar
    llm_request.contents.append(...)
    return llm_request  ✓

    # Opción B: no modificar, retornar None es correcto
    return None  ✓

    # Opción C: NO hacer esto
    llm_request.contents.append(...)
    return None  ✗ (cambios perdidos)
```

## Cuándo Aplicar

- Siempre que implemente un callback de modelo en ADK
- Cuando inject instrucciones, guardrails, o context dinámico
- Cuando validate o modifique el request antes de pasar al modelo

## Alternativas Consideradas

- Usar post-processing después del modelo: funciona pero es más lento (requiere reprocesar output)
- Usar system prompt estatizado: no permite inyección dinámica según estado del agente
