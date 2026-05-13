---
id: TASK-002
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

# TASK-002: Validar Restricciones Críticas

## Descripción

Ejecutar validación completa de restricciones críticas RNF-002.

Verifica:
- NO Redis en requirements.txt
- NO Redis en settings.py
- NO SMTP/Email en código
- SESSION_ENGINE = django.contrib.sessions.backends.db

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

1. **ChainOfVerificationAgent** (chain_of_verification.py)
 - Validar restricciones paso a paso (Redis, Email, pickle, WebSockets)
 - Generar verificaciones individuales para cada restricción
 - Crear cadena de validaciones con dependencies

2. **Self-Consistency** (self_consistency.py)
 - Verificar Redis en múltiples ubicaciones (requirements.txt, settings.py, código)
 - Validar Email en múltiples archivos
 - Consistencia entre diferentes fuentes de validación

3. **Auto-CoT** (auto_cot_agent.py)
 - Razonamiento automático sobre por qué cada restricción es crítica
 - Generar explicaciones de violaciones detectadas
 - Chain-of-Thought para análisis de compliance

4. **Constitutional AI** (optimization_techniques.py)
 - Guardrails explícitos para detectar código inseguro (pickle, eval, exec)
 - Validación de políticas de seguridad del proyecto
 - Restricciones constitucionales RNF-002

5. **Expert Prompting** (specialized_techniques.py)
 - Validación con nivel experto de ISO 27001
 - Conocimiento experto de restricciones Django

Agente recomendado: SDLCTestingAgent + PDCAAutomationAgent

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
