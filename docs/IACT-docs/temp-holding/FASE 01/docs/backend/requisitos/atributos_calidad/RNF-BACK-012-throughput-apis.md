---
id: RNF-BACK-012
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

# RNF-BACK-012: Throughput APIs

## Categoría

Rendimiento

## Descripción

El sistema backend debe ser capaz de manejar un volumen alto de requests simultáneos por segundo, garantizando que la capacidad del sistema escale adecuadamente con la demanda.

## Métrica Medible

**Métrica**: Throughput (requests por segundo) sostenible del sistema

**Valor objetivo**: >= 1000 req/s

**Condiciones**:
- Medido bajo carga sostenida durante 10 minutos
- Mix realista de operaciones (70% reads, 30% writes)
- Con tasa de error < 1%

## Método de Medición

**Herramienta de medición**:
- Locust para tests de carga
- APM para métricas de producción
- Grafana para visualización de throughput

**Frecuencia de medición**: Por cada release major + monitoreo continuo

**Proceso de medición**:
1. Configurar test de carga con rampa gradual hasta 1000 req/s
2. Mantener carga sostenida durante 10 minutos
3. Monitorear throughput, latencia y tasa de error
4. Verificar que sistema mantenga >= 1000 req/s con error rate < 1%
5. Identificar bottlenecks si no se alcanza objetivo

**Responsable de medición**: Equipo Backend + DevOps

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. Sistema debe sostener >= 1000 req/s durante 10 minutos
2. Tasa de error debe ser < 1% bajo carga máxima
3. Latencia p95 debe mantenerse < 500ms bajo carga máxima

**Umbrales**:
- **Mínimo aceptable**: >= 500 req/s
- **Objetivo**: >= 1000 req/s
- **Óptimo**: >= 2000 req/s

## Alcance

**Aplica a**: Sistema backend completo (APIs REST + GraphQL)

**Módulos/Componentes afectados**:
- Gunicorn workers configuration
- Database connection pooling
- Redis connection pooling
- Nginx load balancing

**Excepciones**:
- Operaciones batch/ETL (tienen su propio throughput separado)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso del sistema

**Derivado de Reglas de Negocio**:
- RN-BACK-002: Sistema debe escalar con crecimiento de usuarios

**Relacionado con Requerimientos de Negocio**:
- RNEG-BACK-003: Soportar crecimiento proyectado de 200 usuarios concurrentes

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-030: Configurar pool de conexiones BD optimizado
- RF-BACK-031: Configurar workers Gunicorn según cores disponibles
- RF-BACK-032: Implementar circuit breaker para servicios externos

**Tests de Validación**:
- TS-RNF-012-001: Test de throughput con carga creciente
- TS-RNF-012-002: Test de sostenibilidad bajo carga constante
- TS-RNF-012-003: Test de recovery después de picos de carga

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Configurar Gunicorn con workers basados en CPU cores (2*cores + 1)
- Implementar connection pooling en PostgreSQL y MariaDB
- Usar Nginx como reverse proxy y load balancer
- Implementar rate limiting para proteger contra abuse

**Componentes/Patrones requeridos**:
- Gunicorn: WSGI server con múltiples workers
- Nginx: Reverse proxy y load balancer
- PgBouncer: Connection pooling para PostgreSQL
- Redis: Caché para reducir carga en BD

## Validación

**Tipo de validación**: Tests de carga con Locust

**Frecuencia de validación**: Por cada release major + trimestral en producción

**Criterio de éxito de validación**:
Sistema sostiene >= 1000 req/s durante 10 minutos con error rate < 1%

**Acción si no se cumple**:
- Identificar bottleneck (BD, CPU, memoria, I/O)
- Optimizar componente limitante
- Escalar recursos si necesario

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
El sistema debe manejar múltiples agentes simultáneos en call center real

**Riesgos si no se cumple**:
- Timeouts y errores 503 bajo carga
- Degradación de servicio en horas pico
- Incapacidad de escalar con crecimiento de usuarios

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: No implementado

**Última medición**: N/A

**Último valor medido**: N/A

**Comparación con objetivo**: En progreso

**Acciones correctivas**:
- Configurar tests de carga automatizados
- Optimizar configuración de workers y pooling
- Implementar monitoreo de throughput en producción

## Dependencias

**Dependencias técnicas**:
- Locust instalado y configurado
- APM con métricas de throughput
- Infraestructura con recursos suficientes

**Dependencias de otros RNF**:
- RNF-BACK-010: Tiempo respuesta API REST
- RNF-BACK-016: Consumo memoria por worker
- RNF-BACK-017: Uso CPU

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | >= 1000 req/s |

## Aprobación

**Especificado por**: Equipo de Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
