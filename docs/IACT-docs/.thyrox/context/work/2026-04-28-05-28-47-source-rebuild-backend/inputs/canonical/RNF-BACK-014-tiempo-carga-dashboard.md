---
id: RNF-BACK-014
tipo: atributo_calidad
subtipo: rendimiento
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-014: Tiempo de Carga Dashboard

## Categoría

Rendimiento

## Descripción

El backend debe proporcionar los datos necesarios para cargar el dashboard principal de analytics y métricas en un tiempo óptimo, garantizando una experiencia fluida para supervisores y managers.

## Métrica Medible

**Métrica**: Tiempo total de respuesta para cargar datos completos del dashboard

**Valor objetivo**: < 2 segundos (tiempo total)

**Condiciones**:
- Dashboard con últimos 30 días de métricas
- Incluyendo todas las tarjetas/widgets del dashboard
- Medido desde request inicial hasta última respuesta completada

## Método de Medición

**Herramienta de medición**:
- Browser DevTools (Network tab)
- APM para backend timing
- Lighthouse Performance

**Frecuencia de medición**: Por cada release + monitoreo continuo

**Proceso de medición**:
1. Cargar dashboard en navegador con cache limpio
2. Medir tiempo desde navegación hasta evento "load"
3. Verificar que todos los widgets carguen en < 2s
4. Repetir 10 veces y calcular promedio
5. Verificar que promedio < 2s

**Responsable de medición**: Equipo Backend + Frontend + QA

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. Carga inicial completa del dashboard < 2 segundos
2. Cada widget individual debe cargar en < 500ms
3. Re-carga (con cache) debe ser < 500ms

**Umbrales**:
- **Mínimo aceptable**: < 3 segundos
- **Objetivo**: < 2 segundos
- **Óptimo**: < 1 segundo

## Alcance

**Aplica a**: Endpoint de dashboard principal y sus dependencias

**Módulos/Componentes afectados**:
- `/api/dashboard/main/` - Endpoint principal
- `/api/analytics/summary/` - Resumen de métricas
- `/api/llamadas/stats/` - Estadísticas de llamadas
- Queries de agregación a PostgreSQL analytics

**Excepciones**:
- Dashboards personalizados con filtros complejos pueden tomar más tiempo

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-DASHBOARD-001: Visualizar Dashboard Principal
- UC-ANALYTICS-001: Consultar Métricas del Día

**Derivado de Reglas de Negocio**:
- RN-ANALYTICS-001: Métricas deben estar disponibles en tiempo casi real

**Relacionado con Requerimientos de Negocio**:
- RNEG-BACK-004: Proporcionar visibilidad de operaciones en tiempo real

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-050: Pre-agregar métricas del día en tabla materializada
- RF-BACK-051: Cachear resultado de dashboard por 1 minuto
- RF-BACK-052: Implementar endpoint agregado que devuelve todo en un request

**Tests de Validación**:
- TS-RNF-014-001: Test de tiempo de carga dashboard vacío
- TS-RNF-014-002: Test de tiempo de carga dashboard con 30 días datos
- TS-RNF-014-003: Test de tiempo de carga dashboard con cache

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Implementar materialized views para agregaciones frecuentes
- Cachear respuesta de dashboard por 1 minuto en Redis
- Crear endpoint agregado que devuelve múltiples métricas en un request
- Pre-calcular métricas del día cada 5 minutos

**Componentes/Patrones requeridos**:
- PostgreSQL Materialized Views: Para agregaciones pre-calculadas
- Redis Caching: Caché de 1 minuto para dashboard
- APScheduler: Job que actualiza métricas cada 5 minutos
- GraphQL/Aggregated Endpoint: Reducir número de requests

## Validación

**Tipo de validación**: Tests de performance end-to-end

**Frecuencia de validación**: Por cada release

**Criterio de éxito de validación**:
Carga completa del dashboard en promedio < 2s en 10 intentos consecutivos

**Acción si no se cumple**:
- Profiling de queries de dashboard
- Optimizar agregaciones lentas
- Incrementar TTL de caché si apropiado

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
El dashboard es la pantalla principal del sistema, usada constantemente por supervisores

**Riesgos si no se cumple**:
- Frustración de supervisores
- Pérdida de confianza en la herramienta
- Usuarios evitan usar el dashboard

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: No implementado

**Última medición**: N/A

**Último valor medido**: N/A

**Comparación con objetivo**: En progreso

**Acciones correctivas**:
- Diseñar estructura de materialized views
- Implementar caché de dashboard
- Crear endpoint agregado

## Dependencias

**Dependencias técnicas**:
- PostgreSQL con soporte materialized views
- Redis para caché
- APScheduler para jobs periódicos

**Dependencias de otros RNF**:
- RNF-BACK-010: Tiempo respuesta API REST
- RNF-BACK-013: Latencia queries BD

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 2s |

## Aprobación

**Especificado por**: Equipo de Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
