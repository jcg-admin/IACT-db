---
id: RNF-BACK-013
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

# RNF-BACK-013: Latencia Queries Base de Datos

## Categoría

Rendimiento

## Descripción

El sistema backend debe ejecutar queries a base de datos (PostgreSQL y MariaDB) con latencia mínima, optimizando el acceso a datos y garantizando que las consultas no sean el cuello de botella del sistema.

## Métrica Medible

**Métrica**: Latencia del percentil 95 de queries a base de datos

**Valor objetivo**: < 50ms (percentil 95)

**Condiciones**:
- Medido en todas las queries ejecutadas por el ORM Django
- Incluyendo queries a PostgreSQL (analytics) y MariaDB (IVR legacy)
- Excluyendo queries analíticas complejas (agregaciones grandes)

## Método de Medición

**Herramienta de medición**:
- Django Debug Toolbar (desarrollo)
- Django Silk para profiling
- pg_stat_statements (PostgreSQL)
- Slow Query Log (MariaDB)

**Frecuencia de medición**: Continua en desarrollo, monitoreo semanal en producción

**Proceso de medición**:
1. Habilitar logging de queries lentas (> 100ms)
2. Ejecutar escenarios de uso típicos
3. Analizar queries ejecutadas con Django Silk
4. Calcular p95 de latencia de queries
5. Identificar queries lentas y optimizar

**Responsable de medición**: Equipo Backend

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. El 95% de queries deben ejecutarse en < 50ms
2. El 99% de queries deben ejecutarse en < 100ms
3. No debe haber queries > 500ms (excepto reportes)

**Umbrales**:
- **Mínimo aceptable**: 95% < 100ms
- **Objetivo**: 95% < 50ms
- **Óptimo**: 95% < 20ms

## Alcance

**Aplica a**: Todas las queries Django ORM a PostgreSQL y MariaDB

**Módulos/Componentes afectados**:
- Modelos Django de todas las apps
- QuerySets y managers personalizados
- Raw queries cuando sea necesario

**Excepciones**:
- Queries analíticas con agregaciones grandes (tienen timeout de 30s)
- Procesos ETL batch (optimizados para throughput, no latencia)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso que accedan a base de datos

**Derivado de Reglas de Negocio**:
- RN-BACK-003: Acceso a datos debe ser eficiente

**Relacionado con Requerimientos de Negocio**:
- RNEG-BACK-001: Optimizar productividad mediante respuestas rápidas

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-040: Implementar índices en todos los FK y campos de búsqueda
- RF-BACK-041: Usar select_related para FK frecuentes
- RF-BACK-042: Usar prefetch_related para M2M frecuentes
- RF-BACK-043: Implementar only/defer para queries que no necesitan todos los campos

**Tests de Validación**:
- TS-RNF-013-001: Test de N+1 query detection
- TS-RNF-013-002: Test de latencia queries frecuentes
- TS-RNF-013-003: Auditoría de índices faltantes

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Uso agresivo de select_related/prefetch_related
- Implementar índices compuestos para queries complejas
- Usar database query explain para optimización
- Implementar query monitoring continuo

**Componentes/Patrones requeridos**:
- Django ORM Optimization: Select_related, prefetch_related, only, defer
- Database Indexes: B-tree, GiN, partial indexes
- Query Analysis Tools: Django Silk, nplusone
- Query Caching: Redis para queries frecuentes

## Validación

**Tipo de validación**: Análisis de queries con Django Silk

**Frecuencia de validación**: Por cada PR (CI/CD check)

**Criterio de éxito de validación**:
- No debe haber queries N+1
- Todas las queries frecuentes deben tener índices
- p95 de queries < 50ms en tests

**Acción si no se cumple**:
- Bloquear PR si se detecta N+1
- Crear issue para agregar índices faltantes
- Optimizar queries lentas antes de merge

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
La BD es el recurso más crítico y costoso del sistema; queries lentas afectan todo

**Riesgos si no se cumple**:
- Timeouts en aplicación
- Degradación progresiva con crecimiento de datos
- Bloqueos y deadlocks en BD

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: ~30% de queries > 50ms (análisis inicial)

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Auditoría completa de queries actuales
- Implementar Django Silk en desarrollo
- Crear guía de optimización de queries para equipo
- Implementar tests de N+1 automatizados

## Dependencias

**Dependencias técnicas**:
- Django Debug Toolbar
- Django Silk
- nplusone (N+1 query detector)
- pg_stat_statements habilitado en PostgreSQL

**Dependencias de otros RNF**:
- RNF-BACK-010: Tiempo respuesta API (afectado directamente por latencia BD)
- RNF-BACK-060: Cobertura tests (necesaria para validar optimizaciones)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 50ms p95 |

## Aprobación

**Especificado por**: Equipo de Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
