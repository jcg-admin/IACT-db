---
id: RNF-BACK-034
tipo: atributo_calidad
subtipo: disponibilidad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-034: Monitoreo Health Checks (< 1 min detección)

## Categoría

Disponibilidad

## Descripción

El sistema backend debe implementar health checks exhaustivos y monitoreo continuo que detecten problemas en menos de 1 minuto, permitiendo respuesta rápida ante fallos y degradación del servicio.

## Métrica Medible

**Métrica**: Tiempo de detección de fallos (MTTD - Mean Time To Detect)

**Valor objetivo**: < 1 minuto

**Condiciones**:
- Health checks ejecutados cada 30 segundos
- Verificar: BD conectividad, Redis, filesystem, workers
- Alerta automática si 2 checks consecutivos fallan

## Método de Medición

**Herramienta de medición**:
- UptimeRobot (monitoreo externo)
- Prometheus + Grafana (monitoreo interno)
- Health check endpoint /health/

**Frecuencia de medición**: Continua (checks cada 30s)

**Proceso de medición**:
1. Configurar UptimeRobot con check interval = 30s
2. Simular fallo (apagar PostgreSQL)
3. Iniciar cronómetro
4. Esperar a recibir alerta
5. Detener cronómetro y verificar tiempo < 1 min

**Responsable de medición**: DevOps

## Criterios de Aceptación

**Criterios de cumplimiento - Health Check debe verificar**:
1. **Database Connectivity**: PostgreSQL y MariaDB responden
2. **Redis**: Redis está accesible
3. **Disk Space**: Espacio en disco > 10% libre
4. **Workers**: Al menos 1 Gunicorn worker activo
5. **Dependencies**: Servicios externos críticos accesibles

**Formato de respuesta Health Check**:
```json
{
 "status": "healthy|degraded|unhealthy",
 "timestamp": "2025-01-17T10:30:45Z",
 "checks": {
 "database": {"status": "healthy", "latency_ms": 5},
 "redis": {"status": "healthy", "latency_ms": 2},
 "disk": {"status": "healthy", "free_percent": 45},
 "workers": {"status": "healthy", "count": 4}
 }
}
```

**Umbrales**:
- **Mínimo aceptable**: MTTD < 5 minutos
- **Objetivo**: MTTD < 1 minuto
- **Óptimo**: MTTD < 30 segundos

## Alcance

**Aplica a**: Sistema backend completo y sus dependencias

**Módulos/Componentes afectados**:
- Endpoint /health/ (health check endpoint)
- PostgreSQL database
- MariaDB database
- Redis cache
- Filesystem (disk space)
- Gunicorn workers

**Excepciones**:
- Servicios externos opcionales (pueden degradar sin ser unhealthy)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso (detección proactiva de problemas)

**Derivado de Reglas de Negocio**:
- RN-MONITORING-001: Fallos deben ser detectados rápidamente

**Relacionado con Requerimientos de Negocio**:
- RNEG-AVAILABILITY-003: Minimizar MTTR mediante detección rápida

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-210: Endpoint /health/ con checks completos
- RF-BACK-211: Check DB connectivity con query simple
- RF-BACK-212: Check Redis con PING
- RF-BACK-213: Check disk space con os.statvfs
- RF-BACK-214: Retornar HTTP 200 (healthy) o 503 (unhealthy)

**Tests de Validación**:
- TS-RNF-034-001: Test health check con todos servicios UP (debe retornar 200)
- TS-RNF-034-002: Test health check con PostgreSQL DOWN (debe retornar 503)
- TS-RNF-034-003: Test tiempo de detección < 1 min

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Implementar endpoint /health/ robusto
- Configurar UptimeRobot con check interval 30s
- Implementar checks de todos los componentes críticos
- Configurar alerting multi-canal (email, Slack, SMS)

**Componentes/Patrones requeridos**:
- Health Check Endpoint: /health/
- UptimeRobot: Monitoreo externo
- Prometheus + Grafana: Monitoreo interno y métricas
- Alerting: Multi-canal (email, Slack, PagerDuty)

## Validación

**Tipo de validación**: Simulación de fallos (chaos testing)

**Frecuencia de validación**: Mensual (chaos test)

**Criterio de éxito de validación**:
- Fallo simulado es detectado en < 1 min
- Alerta es enviada correctamente
- Health check identifica componente específico fallando

**Acción si no se cumple**:
- Reducir interval de checks si necesario
- Mejorar robustez de health checks
- Ajustar configuración de alerting

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Detección rápida de fallos minimiza MTTR y mejora uptime

**Riesgos si no se cumple**:
- Downtime prolongado sin detección
- Degradación silenciosa del servicio
- Usuarios afectados antes de que ops sea consciente
- MTTR más largo

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: Health check básico existe, monitoreo incompleto

**Comparación con objetivo**: No cumple (sin monitoreo externo configurado)

**Acciones correctivas**:
- Mejorar endpoint /health/ para incluir todos los checks
- Configurar UptimeRobot con interval 30s
- Implementar alerting multi-canal
- Documentar runbook de respuesta a alertas

## Dependencias

**Dependencias técnicas**:
- UptimeRobot (o Pingdom)
- Prometheus + Grafana (opcional)
- Alerting system (email, Slack, PagerDuty)
- Health check endpoint implementado

**Dependencias de otros RNF**:
- RNF-BACK-030: Uptime (detección rápida mejora uptime)
- RNF-BACK-032: RTO (detección rápida reduce RTO)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | < 1 min |

## Aprobación

**Especificado por**: Equipo de DevOps + Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
