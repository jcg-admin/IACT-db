---
id: RNF-BACK-010
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

# RNF-BACK-010: Tiempo de Respuesta API REST

## Categoría

Rendimiento

## Descripción

El sistema backend debe garantizar que todas las APIs REST respondan dentro de tiempos óptimos para proporcionar una experiencia de usuario fluida y eficiente, minimizando la latencia percibida por los clientes del sistema.

## Métrica Medible

**Métrica**: Tiempo de respuesta del percentil 95 de requests a APIs REST

**Valor objetivo**: < 200ms (percentil 95)

**Condiciones**:
- Bajo carga normal de producción (hasta 100 usuarios concurrentes)
- Medido para todos los endpoints REST del backend
- Excluyendo operaciones batch o reportes pesados

## Método de Medición

**Herramienta de medición**:
- Django Debug Toolbar (desarrollo)
- APM (Application Performance Monitoring) en producción
- Tests de carga con Locust/JMeter

**Frecuencia de medición**: Continua en producción, tests de carga por release

**Proceso de medición**:
1. Configurar APM para capturar tiempos de respuesta de todas las APIs
2. Ejecutar escenarios de uso típicos con carga simulada
3. Recolectar métricas de tiempo de respuesta durante 30 minutos
4. Calcular percentil 95 de tiempos de respuesta
5. Verificar que p95 < 200ms

**Responsable de medición**: Equipo Backend + QA

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. El 95% de requests REST deben completarse en < 200ms
2. El 99% de requests REST deben completarse en < 500ms
3. No debe haber requests que tarden > 2 segundos (timeout)

**Umbrales**:
- **Mínimo aceptable**: 95% < 300ms
- **Objetivo**: 95% < 200ms
- **Óptimo**: 95% < 100ms

## Alcance

**Aplica a**: Todas las APIs REST del backend Django

**Módulos/Componentes afectados**:
- `/api/auth/` - Autenticación y sesiones
- `/api/users/` - Gestión de usuarios
- `/api/permissions/` - Sistema de permisos
- `/api/llamadas/` - Gestión de llamadas
- `/api/analytics/` - Métricas y analytics

**Excepciones**:
- `/api/reports/generate/` - Generación de reportes (tiene su propio RNF-BACK-015)
- `/api/etl/` - Procesos ETL batch (operaciones asíncronas)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-AUTH-001: Iniciar Sesión
- UC-CALL-001: Registrar Llamada
- UC-PERM-007: Verificar Permiso Usuario
- UC-ANALYTICS-001: Consultar Métricas Dashboard

**Derivado de Reglas de Negocio**:
- RN-BACK-001: Sistema debe responder en tiempo real

**Relacionado con Requerimientos de Negocio**:
- RNEG-BACK-001: Optimizar productividad agentes call center

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-001: Implementar endpoints REST optimizados
- RF-BACK-010: Cachear queries frecuentes
- RF-BACK-011: Optimizar queries con select_related/prefetch_related

**Tests de Validación**:
- TS-RNF-010-001: Test de performance endpoints autenticación
- TS-RNF-010-002: Test de performance endpoints llamadas
- TS-RNF-010-003: Test de carga con 100 usuarios concurrentes

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Implementar caché Redis para queries frecuentes
- Optimizar queries Django con select_related/prefetch_related
- Implementar índices de base de datos en campos frecuentemente consultados
- Usar serializers optimizados en DRF

**Componentes/Patrones requeridos**:
- Redis: Caché de resultados de consultas frecuentes
- Django Query Optimization: Select_related, prefetch_related, only, defer
- Database Indexing: Índices en FK, campos de búsqueda, filtros comunes
- DRF Pagination: Limitar cantidad de resultados por request

## Validación

**Tipo de validación**: Tests de performance con Locust + Monitoreo APM

**Frecuencia de validación**: Por cada release + monitoreo continuo en producción

**Criterio de éxito de validación**:
Tests de carga muestran 95% de requests < 200ms bajo carga normal de 100 usuarios concurrentes

**Acción si no se cumple**:
- Bloquear release si p95 > 300ms
- Investigar y optimizar endpoints lentos
- Revisar queries N+1, cacheo, índices

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
La velocidad de respuesta impacta directamente la productividad de agentes del call center que usan el sistema en tiempo real

**Riesgos si no se cumple**:
- Frustración de usuarios por sistema lento
- Pérdida de productividad de agentes
- Abandono de tareas críticas por timeouts

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: No implementado

**Última medición**: N/A

**Último valor medido**: N/A

**Comparación con objetivo**: En progreso

**Acciones correctivas**:
- Implementar APM en producción
- Configurar tests de performance automatizados
- Realizar optimización inicial de queries

## Dependencias

**Dependencias técnicas**:
- Redis para caché
- APM configurado (New Relic, DataDog, o similar)
- Locust/JMeter para tests de carga
- Django Debug Toolbar para profiling

**Dependencias de otros RNF**:
- RNF-BACK-013: Latencia queries BD (afecta directamente el tiempo de respuesta API)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 200ms p95 |

## Aprobación

**Especificado por**: Equipo de Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
