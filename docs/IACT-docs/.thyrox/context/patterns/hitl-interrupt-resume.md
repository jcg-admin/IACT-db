```yml
created_at: 2026-04-23 09:30:00
project: THYROX
category: HITL — Human-In-The-Loop
type: pattern
id: P-007
severity: CRÍTICO
origin: discover/patterns (legacy framework)
```

# HITL Interrupt/Resume

Patrón para interrumpir la ejecución de un agente, permitir que un humano revise/modifique el estado, y reanudar desde el punto de interrupción.

## Problema

`flag_for_review` persiste un registro y retorna `{"status": "flagged"}`, pero no interrumpe la ejecución del agente. El agente interpreta el retorno como completación exitosa y continúa al siguiente paso. El humano puede revisar el flag en la base de datos, pero el agente ya ejecutó las acciones posteriores. El HITL es decorativo: existe en los datos, no en el flujo de control.

### Anti-patrón

```python
# INCORRECTO
class ReviewAgent(LlmAgent):
    tools = [FunctionTool(func=flag_for_review)]

async def flag_for_review(
    action_description: str,
    action_data: dict,
) -> dict:
    """Marca una acción para revisión humana."""
    # Solo persiste el flag — no hay mecanismo de bloqueo
    await db.save({
        "action": action_description,
        "data": action_data,
        "flagged": True,
        "reviewed": False,
    })
    # ERROR: retorna inmediatamente, el agente continúa sin esperar
    return {
        "status": "flagged",
        "message": "Acción marcada para revisión",
    }
```

**Por qué falla:** Método existe en la interfaz pero no implementa ningún mecanismo real de interrupt/resume. El agente ve "flagged" como confirmación y prosigue.

## Solución (el Patrón)

### Patrón correcto

```python
# CORRECTO
import asyncio
from google.adk.agents import LlmAgent
from google.adk.tools import FunctionTool

# Registro de interrupciones activas
_interrupts: dict[str, asyncio.Event] = {}
_resolutions: dict[str, dict] = {}

async def flag_for_review(
    action_description: str,
    action_data: dict,
    timeout_seconds: int = 600,
) -> dict:
    """Interrumpe la ejecución y espera resolución humana."""
    interrupt_id = str(uuid.uuid4())
    
    # Crear evento de sincronización
    resume_event = asyncio.Event()
    _interrupts[interrupt_id] = resume_event
    
    # Persister la acción para revisión
    await db.save({
        "interrupt_id": interrupt_id,
        "action": action_description,
        "data": action_data,
        "status": "pending_review",
        "timestamp": datetime.now(),
    })

    try:
        # BLOQUEAR hasta que el humano resuelva
        await asyncio.wait_for(resume_event.wait(), timeout=timeout_seconds)
        
        # Obtener la resolución humana
        resolution = _resolutions.pop(interrupt_id)
        return {
            "status": "resumed",
            "resolution": resolution["action"],  # "approved" o "rejected"
            "human_notes": resolution.get("notes", ""),
            "interrupt_id": interrupt_id,
        }
        
    except asyncio.TimeoutError:
        return {
            "status": "timeout",
            "message": f"Interrupción expiró después de {timeout_seconds}s",
            "interrupt_id": interrupt_id,
        }
    finally:
        _interrupts.pop(interrupt_id, None)

# API para que humanos resuelvan interrupciones
async def resume_agent(interrupt_id: str, action: str, notes: str = "") -> None:
    """El humano aprueba, rechaza o modifica la acción."""
    _resolutions[interrupt_id] = {
        "action": action,  # "approved", "rejected", o instrucción modificada
        "notes": notes,
    }
    if interrupt_id in _interrupts:
        _interrupts[interrupt_id].set()  # Reanudar el agente
```

**Por qué funciona:** El agente BLOQUEA en `flag_for_review` y espera que el humano invoque `resume_agent`. El flujo de control es sincrónico: no hay acciones "posteriores" que se ejecuten sin aprobación.

## Implementación

**Diferencia clave vs Blocking Loop (P-006):**

| Aspecto | Blocking Loop (escalada) | Interrupt/Resume |
|--------|--------------------------|------------------|
| **Trigger** | Agente decide escalar | Agente u humano decide revisar |
| **Responsable** | Humano aprueba/rechaza | Humano aprueba/rechaza/modifica |
| **Reanudación** | Continúa con aprobación | Continúa con decisión humana |
| **Estado del agente** | Se reinicia | Se reanuda desde punto exacto |

**Pasos de implementación:**

1. En el agente, llamar `flag_for_review()` con la acción propuesta
2. El agente BLOQUEA esperando `resume_event`
3. Humano recibe notificación de interrupt en el dashboard
4. Humano revisa acción, decide, invoca `resume_agent(interrupt_id, acción)`
5. Agente se reanuda con la decisión

## Cuándo Aplicar

- Cuando el agente propone acciones que requieren aprobación antes de ejecutar
- Cuando necesites que humanos modifiquen/ajusten acciones propuestas
- Cuando requieras reversibilidad: humanos revisan ANTES que el agente actúe

## Alternativas Consideradas

- Blocking Loop sin modificación: usuario solo aprueba/rechaza
- Undo/Rollback: permite que el agente actúe, humano deshace después (menos seguro)
