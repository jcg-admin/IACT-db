---
id: RNF-BACK-017
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

# RNF-BACK-017: Uso de CPU

## Categoría

Rendimiento

## Descripción

El sistema backend debe mantener un uso de CPU eficiente y razonable, evitando sobrecarga del servidor y permitiendo headroom para picos de tráfico sin degradación del servicio.

## Métrica Medible

**Métrica**: Uso promedio de CPU del servidor backend

**Valor objetivo**: < 70% promedio

**Condiciones**:
- Medido bajo carga normal de operación (50-100 usuarios concurrentes)
- Promedio calculado sobre ventanas de 5 minutos
- Incluyendo todos los workers de Gunicorn + PostgreSQL + Redis

## Método de Medición

**Herramienta de medición**:
- `top` / `htop` para monitoreo manual
- APM para métricas en producción
- Prometheus/Grafana para visualización histórica

**Frecuencia de medición**: Continua en producción

**Proceso de medición**:
1. Monitorear uso de CPU cada minuto
2. Calcular promedio móvil de 5 minutos
3. Verificar que promedio < 70%
4. Alertar si CPU > 85% por más de 3 minutos
5. Analizar procesos consumiendo más CPU si hay problemas

**Responsable de medición**: DevOps

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. Uso promedio de CPU < 70% bajo carga normal
2. Picos de CPU no deben exceder 90%
3. CPU debe volver a < 50% en menos de 5 min después de pico

**Umbrales**:
- **Mínimo aceptable**: < 80% promedio
- **Objetivo**: < 70% promedio
- **Óptimo**: < 50% promedio

## Alcance

**Aplica a**: Servidor completo de backend

**Módulos/Componentes afectados**:
- Workers de Gunicorn
- PostgreSQL database
- MariaDB database
- Redis
- APScheduler jobs

**Excepciones**:
- Durante procesamiento ETL nocturno puede haber uso > 80%

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso del sistema

**Derivado de Reglas de Negocio**:
- RN-INFRA-002: Sistema debe ser eficiente en uso de recursos

**Relacionado con Requerimientos de Negocio**:
- RNEG-INFRA-001: Minimizar costos de infraestructura

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-080: Optimizar algoritmos computacionalmente costosos
- RF-BACK-081: Evitar procesamiento síncrono de tareas pesadas
- RF-BACK-082: Usar índices de BD para evitar full table scans

**Tests de Validación**:
- TS-RNF-017-001: Test de uso CPU bajo carga sostenida
- TS-RNF-017-002: Test de recovery después de pico de carga
- TS-RNF-017-003: Profiling de código CPU-intensive

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Mover procesamiento pesado a jobs asíncronos
- Optimizar queries de BD para reducir CPU
- Implementar caché para reducir cómputo repetitivo
- Usar algoritmos eficientes (evitar O(n²) cuando sea posible)

**Componentes/Patrones requeridos**:
- APScheduler: Para procesamiento asíncrono
- Redis: Caché para evitar re-cómputo
- Database Indexes: Reducir CPU en queries
- Algorithm Optimization: Usar estructuras de datos eficientes

## Validación

**Tipo de validación**: Monitoreo continuo de CPU

**Frecuencia de validación**: Continua con alertas automáticas

**Criterio de éxito de validación**:
CPU promedio < 70% durante 7 días consecutivos de operación normal

**Acción si no se cumple**:
- Profiling con cProfile para identificar hot paths
- Optimizar código CPU-intensive
- Considerar escalar horizontalmente si necesario

## Prioridad y Riesgos

**Prioridad**: Media

**Justificación de prioridad**:
CPU alta impacta latencia pero no causa fallos críticos inmediatos

**Riesgos si no se cumple**:
- Latencias más altas durante picos de tráfico
- Sin headroom para manejar picos inesperados
- Necesidad de más CPU cores (mayor costo)

**Impacto de no cumplimiento**: Medio

## Estado de Cumplimiento

**Estado actual**: No implementado

**Última medición**: N/A

**Último valor medido**: N/A

**Comparación con objetivo**: En progreso

**Acciones correctivas**:
- Configurar monitoreo de CPU
- Implementar alertas si CPU > 85%
- Realizar profiling inicial de código

## Dependencias

**Dependencias técnicas**:
- APM con métricas de CPU
- Prometheus/Grafana para monitoreo
- cProfile para profiling

**Dependencias de otros RNF**:
- RNF-BACK-016: Consumo memoria (ambos compiten por recursos)
- RNF-BACK-013: Latencia queries (queries lentas usan más CPU)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 70% |

## Aprobación

**Especificado por**: Equipo de Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
