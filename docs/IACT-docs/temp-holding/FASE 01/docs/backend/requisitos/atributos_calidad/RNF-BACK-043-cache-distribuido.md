---
id: RNF-BACK-043
tipo: atributo_calidad
subtipo: escalabilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: media
---

# RNF-BACK-043: Caché Distribuido (Redis Cluster)

## Categoría

Escalabilidad

## Descripción

El sistema backend debe implementar caché distribuido con Redis para compartir caché entre múltiples workers y escalar eficientemente, reduciendo carga en base de datos.

## Métrica Medible

**Métrica**: Hit rate de caché

**Valor objetivo**: >= 70% cache hit rate

**Condiciones**:
- Medido sobre queries frecuentes
- Redis configurado con tamaño apropiado
- TTL configurado según tipo de dato

## Método de Medición

**Herramienta de medición**: Redis INFO stats

**Frecuencia de medición**: Continua (monitoreo Grafana)

**Proceso de medición**:
1. Ejecutar `redis-cli INFO stats`
2. Obtener keyspace_hits y keyspace_misses
3. Calcular hit rate = hits / (hits + misses) * 100
4. Verificar que hit rate >= 70%

**Responsable de medición**: DevOps + Backend

## Criterios de Aceptación

1. **Hit Rate**: >= 70% para queries frecuentes
2. **TTL**: Configurado apropiadamente (1min - 1h según dato)
3. **Eviction Policy**: allkeys-lru configurado
4. **Tamaño**: Memoria suficiente para working set
5. **Uso**: Queries frecuentes cacheadas (permisos, dashboard, etc.)

**Umbrales**:
- **Mínimo aceptable**: 50% hit rate
- **Objetivo**: 70% hit rate
- **Óptimo**: 85%+ hit rate

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNF-BACK-010 (Tiempo respuesta API)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-250: CACHES = Redis con configuración apropiada
- RF-BACK-251: @cache_page para views frecuentes
- RF-BACK-252: cache.set() para datos computados pesados
- RF-BACK-253: Invalidación de caché en updates

**Tests**: TS-RNF-043-001 (Test cache hit rate)

## Impacto en Arquitectura

**Componentes requeridos**:
- Redis: Caché distribuido
- django-redis: Cliente Redis para Django
- Decoradores de caché: @cache_page, @method_decorator(cache_page)
- Cache invalidation: Signals para invalidar caché

## Prioridad**: Media

**Riesgos**: Performance pobre sin caché eficiente

## Estado de Cumplimiento**: Parcialmente implementado

**Última medición**: Redis configurado, poco uso de caché

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 70% hit rate |
