---
id: RNF-BACK-030
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

# RNF-BACK-030: Uptime 99.5%

## Categoría

Disponibilidad

## Descripción

El sistema backend debe mantener una disponibilidad (uptime) de al menos 99.5% mensual, minimizando el tiempo de inactividad no planificada y garantizando acceso confiable al servicio para usuarios.

## Métrica Medible

**Métrica**: Uptime mensual del servicio backend

**Valor objetivo**: >= 99.5% uptime mensual

**Condiciones**:
- Medido mensualmente (720 horas ≈ 30 días)
- Downtime permitido: <= 3.6 horas/mes
- Excluyendo mantenimientos programados y anunciados
- Medido desde health check endpoint

## Método de Medición

**Herramienta de medición**:
- UptimeRobot o Pingdom (monitoreo externo)
- Health check endpoint `/health/`
- Logs de downtime del servidor
- Prometheus + Grafana para uptime histórico

**Frecuencia de medición**: Continua (checks cada 1 minuto)

**Proceso de medición**:
1. UptimeRobot realiza HTTP GET a /health/ cada 1 min
2. Si responde 200 OK → servicio UP
3. Si no responde o status != 200 → servicio DOWN
4. Al final del mes calcular: (Minutos UP / Total Minutos) * 100
5. Verificar que uptime >= 99.5%

**Responsable de medición**: DevOps

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Uptime mensual**: >= 99.5% (≈ 43,200 min UP de 43,560 min totales)
2. **Downtime máximo**: <= 3.6 horas/mes
3. **Recovery Time**: Sistema debe recuperarse automáticamente en < 5 min
4. **Health Check**: Endpoint /health/ responde en < 1s

**Umbrales**:
- **Mínimo aceptable**: 99.0% uptime (7.2 horas downtime/mes)
- **Objetivo**: 99.5% uptime (3.6 horas downtime/mes)
- **Óptimo**: 99.9% uptime (43 min downtime/mes)

## Alcance

**Aplica a**: Servicio backend completo

**Módulos/Componentes afectados**:
- Gunicorn workers
- Nginx reverse proxy
- PostgreSQL database
- Redis cache
- Health check endpoint

**Excepciones**:
- Mantenimientos programados y anunciados con >= 24h anticipación NO cuentan como downtime

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso (requieren sistema disponible)

**Derivado de Reglas de Negocio**:
- RN-AVAILABILITY-001: Sistema debe estar disponible en horario laboral

**Relacionado con Requerimientos de Negocio**:
- RNEG-AVAILABILITY-001: Garantizar operación continua del call center

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-170: Implementar health check endpoint /health/
- RF-BACK-171: Configurar auto-restart de Gunicorn en caso de fallo
- RF-BACK-172: Configurar supervisord para mantener procesos vivos
- RF-BACK-173: Implementar graceful shutdown

**Tests de Validación**:
- TS-RNF-030-001: Test health check responde 200 OK
- TS-RNF-030-002: Test recovery automático después de crash simulado
- TS-RNF-030-003: Test uptime mensual >= 99.5% (validación histórica)

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Usar supervisord para auto-restart de procesos
- Implementar health check endpoint completo (verifica BD, Redis)
- Configurar graceful shutdown para evitar pérdida de requests
- Monitoreo externo con alertas

**Componentes/Patrones requeridos**:
- Supervisord: Process management y auto-restart
- Health Check Endpoint: Verificar estado del sistema
- UptimeRobot/Pingdom: Monitoreo externo
- Alerting: Notificaciones de downtime por email/SMS

## Validación

**Tipo de validación**: Monitoreo continuo externo

**Frecuencia de validación**: Continua (checks cada 1 min) + reporte mensual

**Criterio de éxito de validación**:
Reporte mensual de UptimeRobot muestra uptime >= 99.5%

**Acción si no se cumple**:
- Análisis de root cause de downtime
- Implementar mejoras para prevenir recurrencia
- Ajustar configuración de auto-restart si necesario

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Call center depende del sistema; downtime impacta operación completa

**Riesgos si no se cumple**:
- Pérdida de productividad del call center
- Incapacidad de atender llamadas
- Pérdida de ingresos por downtime
- Incumplimiento de SLA con clientes

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: No implementado (sin medición)

**Última medición**: N/A

**Último valor medido**: N/A (sin monitoreo configurado)

**Comparación con objetivo**: Desconocido

**Acciones correctivas**:
- Configurar UptimeRobot para monitoreo del servicio
- Implementar health check endpoint /health/
- Configurar supervisord para auto-restart
- Configurar alerting de downtime

## Dependencias

**Dependencias técnicas**:
- UptimeRobot o Pingdom (servicio externo)
- Supervisord para process management
- Health check endpoint implementado
- Alerting system (email/SMS)

**Dependencias de otros RNF**:
- RNF-BACK-032: RTO (tiempo de recuperación)
- RNF-BACK-034: Monitoreo health checks

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 99.5% |

## Aprobación

**Especificado por**: Equipo de Arquitectura + DevOps IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
