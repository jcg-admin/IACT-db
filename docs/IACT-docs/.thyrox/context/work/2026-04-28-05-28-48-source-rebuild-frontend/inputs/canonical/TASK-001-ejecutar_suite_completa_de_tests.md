---
id: TASK-001
tipo: tarea
categoria: qa
prioridad: P0
story_points: 2
asignado: backend-lead
estado: pendiente
fecha_creacion: 2025-11-12
sprint: Sprint 1
relacionados: ["PLAN_EJECUCION_COMPLETO.md"]
date: 2025-11-13
---

# TASK-001: Ejecutar Suite Completa de Tests

## Descripción

Ejecutar suite completa de tests para validar coverage >= 80% y compliance.

Incluye:
- Tests unitarios de todas las apps Django
- Tests de integración
- Validación de coverage
- Generación de reportes HTML

## Prioridad

**P0** - CRÍTICO

## Estimación

**Story Points**: 2 SP

## Dependencias

Ninguna

## Bloqueadores

Ninguno

## Asignado

backend-lead

## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Tool-use Prompting** (knowledge_techniques.py)
   - Ejecutar pytest con parámetros específicos
   - Ejecutar comandos shell para validar coverage

2. **ReAct** (knowledge_techniques.py)
   - Razonar sobre el estado actual antes de ejecutar tests
   - Actuar ejecutando la suite completa
   - Reflexionar sobre resultados de coverage

3. **Self-Consistency** (self_consistency.py)
   - Verificar coverage en múltiples reportes (terminal, HTML)
   - Validar consistencia entre unittest y pytest

4. **Constitutional AI** (optimization_techniques.py)
   - Verificar que no se ejecuten tests que modifiquen datos de producción
   - Validar que tests usen fixtures y mocks apropiados

5. **Expert Prompting** (specialized_techniques.py)
   - Aplicar conocimiento experto de testing Django
   - Validar compliance con estándares de testing

Agente recomendado: SDLCTestingAgent o TDDAgent

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
