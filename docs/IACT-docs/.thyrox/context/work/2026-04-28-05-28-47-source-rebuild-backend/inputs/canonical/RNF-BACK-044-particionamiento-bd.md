---
id: RNF-BACK-044
tipo: atributo_calidad
subtipo: escalabilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: baja
---

# RNF-BACK-044: Particionamiento BD (por fecha)

## Categoría

Escalabilidad

## Descripción

El sistema backend debe implementar particionamiento de tablas grandes por fecha para mantener performance de queries y facilitar archivado de datos históricos.

## Métrica Medible

**Métrica**: Performance de queries en tabla particionada vs no particionada

**Valor objetivo**: Queries 2-5x más rápidas con particionamiento

**Condiciones**:
- Tabla llamadas particionada por mes o año
- Queries con filtro de fecha usan partition pruning
- Particiones antiguas pueden ser archivadas fácilmente

## Método de Medición

**Herramienta de medición**: EXPLAIN ANALYZE en PostgreSQL

**Frecuencia de medición**: Una vez al implementar

**Proceso de medición**:
1. Ejecutar query con filtro fecha en tabla particionada
2. Verificar EXPLAIN muestra partition pruning
3. Medir tiempo de query vs tabla sin particionar
4. Confirmar mejora de performance 2-5x

**Responsable de medición**: DBA + Backend

## Criterios de Aceptación

1. **Particionamiento**: Tabla llamadas particionada por mes
2. **Partition Pruning**: Queries aprovechan particionamiento
3. **Mantenimiento**: Script automático crea particiones nuevas
4. **Archivado**: Particiones > 2 años se pueden archivar fácilmente

**Umbrales**:
- **Mínimo aceptable**: Sin particionamiento (tabla única)
- **Objetivo**: Particionamiento mensual
- **Óptimo**: Particionamiento + archivado automático

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNF-BACK-041 (Crecimiento de datos)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-260: CREATE TABLE llamadas PARTITION BY RANGE (fecha_hora)
- RF-BACK-261: Script crea particiones mensuales automáticamente
- RF-BACK-262: Índices en cada partición

**Tests**: TS-RNF-044-001 (Test partition pruning funciona)

## Impacto en Arquitectura

**Componentes requeridos**:
- PostgreSQL 10+ (soporte particionamiento nativo)
- Script de mantenimiento de particiones
- Modificación de modelo Django (managed=False para particiones)

## Prioridad**: Baja (solo necesario al superar 5M registros)

**Riesgos**: Degradación con datos muy grandes sin particionamiento

## Estado de Cumplimiento**: No implementado

**Acciones**: Implementar cuando tabla llamadas supere 5M registros

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | Mensual |
