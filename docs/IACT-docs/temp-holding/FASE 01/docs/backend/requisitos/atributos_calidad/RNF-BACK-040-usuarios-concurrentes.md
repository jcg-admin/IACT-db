---
id: RNF-BACK-040
tipo: atributo_calidad
subtipo: escalabilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-040: Usuarios Concurrentes (>= 200)

## Categoría

Escalabilidad

## Descripción

El sistema backend debe soportar al menos 200 usuarios concurrentes activos sin degradación significativa del servicio, escalando adecuadamente para el crecimiento proyectado del call center.

## Métrica Medible

**Métrica**: Número de usuarios concurrentes soportados con latencia aceptable

**Valor objetivo**: >= 200 usuarios concurrentes

**Condiciones**:
- Latencia p95 < 500ms bajo 200 usuarios concurrentes
- Tasa de error < 1%
- Usuarios activos realizando operaciones típicas (mix 70% reads, 30% writes)

## Método de Medición

**Herramienta de medición**: Locust para tests de carga

**Frecuencia de medición**: Por cada release major

**Proceso de medición**:
1. Configurar Locust con 200 usuarios virtuales
2. Simular operaciones típicas (login, consultas, registros)
3. Ejecutar durante 30 minutos
4. Medir latencia p95 y tasa de error
5. Verificar que p95 < 500ms y error rate < 1%

**Responsable de medición**: QA + Backend

## Criterios de Aceptación

1. Sistema soporta >= 200 usuarios concurrentes
2. Latencia p95 < 500ms bajo carga de 200 usuarios
3. Tasa de error < 1%
4. Sin degradación progresiva (memory leaks, etc.)

**Umbrales**:
- **Mínimo aceptable**: 150 usuarios concurrentes
- **Objetivo**: 200 usuarios concurrentes
- **Óptimo**: 300+ usuarios concurrentes

## Trazabilidad

### Trazabilidad Ascendente

**Derivado de**: RNEG-BACK-003 (Soportar crecimiento de 200 agentes)

### Trazabilidad Descendente

**Implementado en**:
- RF-BACK-220: Configurar Gunicorn workers = (2 * CPU cores) + 1
- RF-BACK-221: Implementar connection pooling (PgBouncer)
- RF-BACK-222: Configurar Redis para caché distribuido

**Tests**: TS-RNF-040-001 (Test de carga con 200 usuarios)

## Impacto en Arquitectura

**Componentes requeridos**:
- Gunicorn: Múltiples workers
- PgBouncer: Connection pooling
- Redis: Caché compartido entre workers
- Nginx: Load balancing

## Prioridad**: Alta

**Riesgos**: Incapacidad de escalar con crecimiento de agentes

## Estado de Cumplimiento**: No implementado (sin tests de carga)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | >= 200 usuarios |
