---
id: TASK-003
tipo: tarea
categoria: qa
prioridad: P0
story_points: 1
asignado: backend-lead
estado: pendiente
fecha_creacion: 2025-11-12
sprint: Sprint 1
relacionados: ["PLAN_EJECUCION_COMPLETO.md"]
date: 2025-11-13
---

# TASK-003: Verificar SESSION_ENGINE en Settings

## Descripción

Grep y verificar SESSION_ENGINE en todos los archivos settings.

Asegurar que todas las configuraciones usen:
SESSION_ENGINE = 'django.contrib.sessions.backends.db'

No debe haber referencias a Redis para sesiones.

## Prioridad

**P0** - CRÍTICO

## Estimación

**Story Points**: 1 SP

## Dependencias

Ninguna

## Bloqueadores

Ninguno

## Asignado

backend-lead

## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Tool-use Prompting** (knowledge_techniques.py)
 - Ejecutar grep para buscar SESSION_ENGINE en settings
 - Usar find para localizar todos los archivos settings*.py

2. **ReAct** (knowledge_techniques.py)
 - Razonar sobre ubicación esperada de settings.py
 - Actuar ejecutando búsqueda
 - Reflexionar sobre resultados encontrados

3. **Retrieval Prompting** (specialized_techniques.py)
 - Recuperar documentación de Django sobre SESSION_ENGINE
 - Buscar ejemplos de configuración correcta

4. **Self-Consistency** (self_consistency.py)
 - Verificar que todos los archivos settings usan misma configuración
 - Validar consistencia entre settings de desarrollo y producción

5. **Delimiter-based Prompting** (optimization_techniques.py)
 - Separar búsqueda por tipo de archivo (settings.py, settings_local.py, etc.)
 - Delimitar scope de búsqueda por directorio

Agente recomendado: SDLCTestingAgent

## Criterios de Aceptación

Ver detalles completos en [PLAN_EJECUCION_COMPLETO.md](../PLAN_EJECUCION_COMPLETO.md)

## Estado

- [x] Pendiente
- [ ] En Progreso
- [ ] Completado
- [ ] Bloqueado

## Notas

Tarea crítica del Sprint 1. Ver PLAN_EJECUCION_COMPLETO.md para detalles de implementación completos, incluyendo:
- Pasos de ejecución detallados
- Criterios de aceptación específicos
- Scripts y comandos necesarios
- Outputs esperados

## Referencias

- [PLAN_EJECUCION_COMPLETO.md](../PLAN_EJECUCION_COMPLETO.md)
- [TAREAS_ACTIVAS.md](../proyecto/TAREAS_ACTIVAS.md)
- [ROADMAP.md](../proyecto/ROADMAP.md)
