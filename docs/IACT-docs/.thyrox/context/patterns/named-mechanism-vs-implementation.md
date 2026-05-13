```yml
created_at: 2026-04-23 09:30:00
project: THYROX
category: Antipatrón de Arquitectura
type: pattern
id: P-009
severity: ALTO
origin: discover/patterns (legacy framework)
```

# Named Mechanism vs Implementation

Patrón para alinear nombres de componentes (clases, métodos, módulos) con la implementación real que entregan.

## Problema

El nombre del mecanismo en la clase, método o módulo establece un contrato implícito con el lector. "Adaptive" promete que el sistema cambia su comportamiento en respuesta al contexto. "Prioritized" promete que hay un orden basado en criterios. "Intelligent" promete lógica de decisión no-trivial.

Cuando la implementación es un placeholder o una implementación trivial, se crea una brecha de confianza sistémica:
- El código parece más robusto de lo que es
- Las revisiones de seguridad fallan al evaluar capacidades reales
- Módulos que dependen del mecanismo nombrado se construyen sobre premisas falsas

### Anti-patrón

```python
# INCORRECTO — El nombre promete un mecanismo que el código no implementa

class AdaptiveRateLimiter:
    """Rate limiter adaptativo que ajusta límites según carga del sistema."""

    def __init__(self, base_rate: int = 100):
        self.rate = base_rate
        # No hay lógica de adaptación — la tasa nunca cambia

    def check_rate(self, request_id: str) -> bool:
        return True  # siempre permite (sin lógica real)

    def adapt_to_load(self, current_load: float) -> None:
        pass  # TODO: implementar adaptación
        # Método existe pero no hace nada


class PrioritizedTaskQueue:
    """Cola con priorización inteligente basada en urgencia y contexto."""

    def __init__(self):
        self.tasks = []  # lista simple sin orden de prioridad

    def enqueue(self, task: dict) -> None:
        self.tasks.append(task)  # append simple, sin priorización

    def dequeue(self) -> dict:
        return self.tasks.pop(0)  # FIFO simple, ignora prioridades

# Cap.10: "Resource-Aware Agent" que no monitorea recursos
# Cap.11: "Self-Healing System" sin mecanismo de recuperación automática
# Cap.12: "Semantic Router" que usa if/elif sobre strings exactos
# Cap.13: "Adaptive Guardrails" con thresholds hardcoded
# Cap.14: "Intelligent Escalation" que siempre escala (sin criterio de inteligencia)
```

**Por qué falla:** La brecha crea falsos sentidos de seguridad. Si un auditor ve `AdaptiveRateLimiter`, asume que el sistema se adapta automáticamente. El análisis de capacidad se construye sobre la premisa falsa.

## Solución (el Patrón)

### Opción A: Implementar el mecanismo nombrado

```python
# CORRECTO — "Adaptive" hace lo que promete

import asyncio
import time

class AdaptiveRateLimiter:
    """Rate limiter que ajusta límites dinámicamente según carga del sistema."""

    def __init__(self, base_rate: int = 100, monitoring_interval: float = 5.0):
        self.base_rate = base_rate
        self.current_rate = base_rate
        self.monitoring_interval = monitoring_interval
        self._system_load = 0.5  # [0.0-1.0]

    async def _monitor_system_load(self):
        """Monitorea carga del sistema cada N segundos."""
        while True:
            # Obtener métrica real (CPU, memoria, latencia, etc.)
            self._system_load = await get_system_load()
            
            # Ajustar tasa dinámicamente
            if self._system_load > 0.8:
                self.current_rate = int(self.base_rate * 0.5)  # reducir 50%
            elif self._system_load > 0.6:
                self.current_rate = int(self.base_rate * 0.75)  # reducir 25%
            else:
                self.current_rate = self.base_rate
            
            await asyncio.sleep(self.monitoring_interval)

    async def check_rate(self, request_id: str) -> bool:
        """Verifica si se permite el request según tasa adaptada."""
        # Implementar lógica de token bucket o sliding window
        return await self._token_bucket_check(self.current_rate)
```

**Costo:** Complejidad inicial pero promesa cumplida.

---

### Opción B: Renombrar para honestidad semántica

```python
# CORRECTO — Nombre honesto, implementación simple

class FixedRateLimiter:
    """Rate limiter con límite fijo. No se adapta automáticamente."""

    def __init__(self, rate: int = 100):
        self.rate = rate

    def check_rate(self, request_id: str) -> bool:
        return True  # Implementación real de token bucket o sliding window

# Uso: si necesitas adaptabilidad, el usuario sabe que no la tiene
# Si la necesita después, migra a AdaptiveRateLimiter
```

**Costo:** Cero complejidad, pero requiere actualizar a `AdaptiveRateLimiter` si la lógica cambia.

---

### Opción C: Nombre + Comentario explícito

```python
class SimplifiedTaskQueue:
    """
    Cola FIFO de tareas.
    
    NOTA: El nombre original "PrioritizedTaskQueue" prometía priorización
    que nunca fue implementada. Esta versión es honesta: no hay priorización.
    Para priorización real, usar `PriorityQueue` de `heapq` o cola custom.
    """

    def __init__(self):
        self.tasks = []

    def enqueue(self, task: dict) -> None:
        self.tasks.append(task)

    def dequeue(self) -> dict:
        return self.tasks.pop(0)
```

**Costo:** Requiere refactoring de código que depende del nombre viejo.

## Implementación

**Regla de alineación:**

1. **Si el nombre implica característica X:** la implementación DEBE hacer X
2. **Si hacer X es futuro:**renombra a `SimpleX` o `BasicX`
3. **Si hacer X es imposible:** elimina el método/clase

```python
# REVISAR SIEMPRE
class MyClass:
    def method_that_claims(self, ...):  # ← ¿qué promete el nombre?
        pass  # ← ¿la implementación lo entrega?
        
# Checklist:
# 1. Lee el nombre en voz alta: ¿qué esperas que haga?
# 2. Lee el código: ¿qué hace realmente?
# 3. ¿Coinciden? Si no, renombra o implementa.
```

## Cuándo Aplicar

- En revisión de código: verificar alineación entre nombres e implementación
- Al refactorizar: renombrar si la implementación cambió
- Al documentar: asegurarse que docstring refleja comportamiento real
- En auditorías: detectar "feature falso" que parece robusto pero no es

## Alternativas Consideradas

- Aceptar la brecha: lleva a falsa confianza y bugs sutiles
- Nombres genéricos ("MyClass"): sacrifica legibilidad
- Documentación exhaustiva: no reemplaza nombres precisos
