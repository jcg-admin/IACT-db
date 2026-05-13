```yml
created_at: 2026-04-23 09:30:00
project: THYROX
category: HITL — Human-In-The-Loop
type: pattern
id: P-006
severity: CRÍTICO
origin: discover/patterns (legacy framework)
```

# HITL Blocking Loop

Patrón para implementar un mecanismo de Human-In-The-Loop real que bloquea la ejecución del agente hasta recibir aprobación.

## Problema

La función retorna `{"status": "success"}` en cuanto envía la notificación, pero no espera la respuesta del humano. El agente interpreta ese `"success"` como que la escalación fue resuelta y continúa su ejecución. El HITL es decorativo: notifica pero no bloquea, por lo que el agente puede tomar decisiones con consecuencias irreversibles antes de que el humano haya revisado nada. El "Human in the Loop" es un nombre sin implementación real.

### Anti-patrón

```python
# INCORRECTO
import asyncio
from google.adk.agents import LlmAgent
from google.adk.tools import FunctionTool

async def escalate_to_human(
    issue_description: str,
    severity: str,
) -> dict:
    """Escala un problema a revisión humana."""
    # Enviar notificación al sistema de tickets
    ticket_id = await send_notification_to_slack(issue_description, severity)

    # ERROR: retorna inmediatamente sin esperar respuesta humana
    return {
        "status": "success",
        "message": "Escalación enviada",
        "ticket_id": ticket_id,
    }

class EscalationAgent(LlmAgent):
    tools = [FunctionTool(func=escalate_to_human)]
```

**Por qué falla:** El agente ve `"success"` como confirmación y prosigue con acciones que pueden ser irreversibles. El humano puede revisar el ticket, pero el agente ya ejecutó todo.

## Solución (el Patrón)

### Patrón correcto

```python
# CORRECTO
import asyncio
from google.adk.agents import LlmAgent
from google.adk.tools import FunctionTool

# Cola global para resoluciones humanas (en producción: Redis, DB, etc.)
_pending_reviews: dict[str, asyncio.Event] = {}
_review_decisions: dict[str, dict] = {}

async def escalate_to_human(
    issue_description: str,
    severity: str,
    timeout_seconds: int = 300,
) -> dict:
    """Escala un problema a revisión humana y bloquea hasta recibir respuesta."""
    ticket_id = await send_notification_to_slack(issue_description, severity)

    # Crear evento de sincronización
    decision_event = asyncio.Event()
    _pending_reviews[ticket_id] = decision_event

    try:
        # BLOQUEAR hasta que el humano responda
        await asyncio.wait_for(decision_event.wait(), timeout=timeout_seconds)
        
        # Obtener la decisión del humano
        decision = _review_decisions.pop(ticket_id, {"status": "timeout"})
        return decision
        
    except asyncio.TimeoutError:
        return {
            "status": "timeout",
            "message": f"Escalación expiró después de {timeout_seconds}s",
            "ticket_id": ticket_id,
        }
    finally:
        # Limpiar
        _pending_reviews.pop(ticket_id, None)

# API para que humanos resuelvan escalaciones
async def resolve_escalation(ticket_id: str, approval: bool, notes: str = "") -> None:
    """El humano aprueba o rechaza la escalación."""
    _review_decisions[ticket_id] = {
        "status": "approved" if approval else "rejected",
        "notes": notes,
        "ticket_id": ticket_id,
    }
    if ticket_id in _pending_reviews:
        _pending_reviews[ticket_id].set()  # Desbloquear el agente

class EscalationAgent(LlmAgent):
    tools = [FunctionTool(func=escalate_to_human)]
```

**Por qué funciona:** El agente BLOQUEA en `escalate_to_human` hasta que el humano responda (via `resolve_escalation`). El humano DEBE aprobar o rechazar antes de que el agente continúe. El HITL es real: el flujo de control depende de la decisión humana.

## Implementación

**Componentes necesarios:**
1. **Cola de espera:** `_pending_reviews` (asyncio.Event por ticket)
2. **Almacén de decisiones:** `_review_decisions` (dict de resultados)
3. **Timeout:** `asyncio.wait_for(timeout_seconds)` para evitar bloqueos eternos
4. **API de resolución:** endpoint que humanos usan para aprobar/rechazar
5. **Limpieza:** siempre limpiar en `finally` para evitar memory leaks

En producción: usar Redis, DB, o message queue en lugar de dicts en memoria.

## Cuándo Aplicar

- Cuando el agente necesita aprobación humana para acciones irreversibles
- Cuando integres sistemas de revisión (tickets, emails, dashboards)
- Cuando requieras audit trail de decisiones humanas

## Alternativas Consideradas

- Logging y seguimiento post-facto: no previene acciones incorrectas
- Notificaciones sin bloqueo: HITL decorativo (el anti-patrón)
- Parar el agente y reanudar manualmente: requiere orquestación externa compleja
