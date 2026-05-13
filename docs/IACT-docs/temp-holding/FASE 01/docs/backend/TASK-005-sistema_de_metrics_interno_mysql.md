---
id: TASK-005
tipo: tarea
categoria: arquitectura
prioridad: P1
story_points: 8
asignado: backend-lead
estado: pendiente
fecha_creacion: 2025-11-12
sprint: Sprint 1
relacionados: ["PLAN_EJECUCION_COMPLETO.md"]
date: 2025-11-13
---

# TASK-005: Sistema de Metrics Interno (MySQL)

## Descripción

Implementar tabla dora_metrics en MySQL para centralizar métricas DORA, performance y usage.

Incluye:
- Crear Django app dora_metrics
- Modelo DORAMetric con campos cycle_id, feature_id, phase_name, decision, duration_seconds, metadata
- API endpoints GET/POST para métricas
- Migraciones de base de datos
- Migración de datos de JSON a MySQL

## Prioridad

**P1** - ALTA

## Estimación

**Story Points**: 8 SP

## Dependencias

TASK-001 a TASK-004 completadas

## Bloqueadores

Ninguno

## Asignado

backend-lead

## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **TaskDecomposition** (structuring_techniques.py)
 - Descomponer en subtareas: crear app, modelos, API, migración
 - Secuencia ordenada de implementación

2. **Code Generation Prompting** (specialized_techniques.py)
 - Generar models.py para DORA metrics
 - Generar views.py para API endpoints
 - Generar serializers.py

3. **Few-Shot Learning** (fundamental_techniques.py)
 - Aprender de estructura de apps Django existentes
 - Usar ejemplos de otros modelos del proyecto

4. **Least-to-Most Prompting** (structuring_techniques.py)
 - Empezar con modelo simple
 - Incrementalmente agregar complejidad
 - Resolver de simple a complejo

5. **Tool-use Prompting** (knowledge_techniques.py)
 - Ejecutar django-admin startapp
 - Ejecutar makemigrations y migrate
 - Usar Django test framework

6. **Expert Prompting** (specialized_techniques.py)
 - Aplicar mejores prácticas Django
 - Conocimiento experto de MySQL con Django

Agente recomendado: SDLCDesignAgent + FeatureAgent

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
