---
id: RNF-BACK-016
tipo: atributo_calidad
subtipo: rendimiento
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: media
---

# RNF-BACK-016: Consumo de Memoria por Worker

## Categoría

Rendimiento

## Descripción

Cada worker de Gunicorn debe mantener un consumo de memoria razonable para permitir ejecutar múltiples workers en el servidor sin agotar recursos, optimizando el uso de infraestructura disponible.

## Métrica Medible

**Métrica**: Memoria RSS (Resident Set Size) promedio por worker de Gunicorn

**Valor objetivo**: < 512 MB por worker

**Condiciones**:
- Medido después de 1 hora de operación bajo carga normal
- Incluyendo memoria de Django + librerías + conexiones BD
- Promedio de todos los workers activos

## Método de Medición

**Herramienta de medición**:
- `ps aux` para memoria RSS por proceso
- APM para métricas de memoria en producción
- memory_profiler para profiling detallado

**Frecuencia de medición**: Monitoreo continuo en producción

**Proceso de medición**:
1. Identificar PIDs de todos los workers Gunicorn
2. Ejecutar `ps aux` y extraer memoria RSS de cada worker
3. Calcular promedio de memoria de workers
4. Verificar que promedio < 512 MB
5. Alertar si algún worker excede 700 MB (posible leak)

**Responsable de medición**: DevOps + Backend

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. Promedio de memoria por worker < 512 MB
2. Ningún worker debe exceder 700 MB bajo operación normal
3. Memoria debe ser estable (no crecimiento continuo indicando leak)

**Umbrales**:
- **Mínimo aceptable**: < 700 MB promedio
- **Objetivo**: < 512 MB promedio
- **Óptimo**: < 350 MB promedio

## Alcance

**Aplica a**: Workers de Gunicorn ejecutando aplicación Django

**Módulos/Componentes afectados**:
- Gunicorn workers
- Django application
- Conexiones a BD (PostgreSQL + MariaDB)
- Conexiones a Redis

**Excepciones**:
- Workers procesando reportes grandes pueden tener picos temporales

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso (eficiencia de recursos)

**Derivado de Reglas de Negocio**:
- RN-INFRA-001: Optimizar uso de recursos de servidor

**Relacionado con Requerimientos de Negocio**:
- RNEG-INFRA-001: Minimizar costos de infraestructura

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-070: Configurar max_requests para reciclar workers
- RF-BACK-071: Cerrar conexiones BD después de cada request
- RF-BACK-072: Evitar cargar datos grandes en memoria

**Tests de Validación**:
- TS-RNF-016-001: Test de consumo memoria bajo carga sostenida
- TS-RNF-016-002: Test de memory leaks con memory_profiler
- TS-RNF-016-003: Test de reciclaje de workers

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Configurar Gunicorn max_requests para reciclar workers periódicamente
- Usar streaming para archivos grandes (no cargar en memoria)
- Cerrar conexiones explícitamente
- Limitar tamaño de caché por worker

**Componentes/Patrones requeridos**:
- Gunicorn max_requests: Reciclar workers cada N requests
- Django StreamingHttpResponse: Para archivos grandes
- Connection Pooling: Limitar conexiones abiertas por worker
- Memory Profiling: Detectar leaks en desarrollo

## Validación

**Tipo de validación**: Monitoreo de memoria en producción

**Frecuencia de validación**: Continua (alertas automáticas)

**Criterio de éxito de validación**:
Promedio de memoria workers < 512 MB durante 7 días consecutivos

**Acción si no se cumple**:
- Profiling con memory_profiler para identificar leak
- Reducir max_requests si crece memoria progresivamente
- Optimizar código que carga datos grandes en memoria

## Prioridad y Riesgos

**Prioridad**: Media

**Justificación de prioridad**:
Importante para costos de infraestructura pero no crítico para funcionalidad

**Riesgos si no se cumple**:
- Necesidad de más RAM en servidor (mayor costo)
- Menos workers posibles por servidor
- OOM kills si hay memory leaks

**Impacto de no cumplimiento**: Medio

## Estado de Cumplimiento

**Estado actual**: No implementado

**Última medición**: N/A

**Último valor medido**: N/A

**Comparación con objetivo**: En progreso

**Acciones correctivas**:
- Configurar monitoreo de memoria por worker
- Implementar max_requests en Gunicorn
- Configurar alertas si memoria > 700 MB

## Dependencias

**Dependencias técnicas**:
- APM con métricas de memoria
- memory_profiler para profiling
- Alerting system (Prometheus/Grafana)

**Dependencias de otros RNF**:
- RNF-BACK-017: Uso CPU (ambos compiten por recursos)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 512 MB |

## Aprobación

**Especificado por**: Equipo de Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
