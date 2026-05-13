---
id: PROC-INFRA-005
tipo: proceso
categoria: infraestructura
subcategoria: monitoring_observability
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Sonnet 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-INFRA-001", "PROC-INFRA-003", "PROC-INFRA-004"]
---

# PROCESO: Monitoreo y Observabilidad de Infraestructura

## Objetivo

Definir el flujo completo de configuración de métricas, logging, alertas y análisis de rendimiento de la infraestructura del proyecto IACT, asegurando visibilidad proactiva del estado de sistemas, detección temprana de problemas, capacidad de troubleshooting efectivo y toma de decisiones basada en datos.

---

## Propósito (QUE)

Establecer un proceso formal y controlado para:

1. **Configurar** recolección de métricas de infraestructura
2. **Implementar** logging centralizado y estructurado
3. **Definir** alertas inteligentes y umbrales apropiados
4. **Analizar** rendimiento y tendencias de sistemas
5. **Detectar** anomalías y problemas proactivamente
6. **Visualizar** estado de infraestructura en dashboards
7. **Optimizar** recursos basado en datos de monitoreo

Este es un proceso de **nivel estratégico/operativo** (alto nivel). Para detalles de implementación (COMO), ver procedimientos relacionados.

---

## Alcance

### Incluye

- **Infraestructura de desarrollo**: VMs locales, DevContainers, CI/CD agents
- **Métricas de sistema**: CPU, RAM, Disk, Network
- **Métricas de aplicación**: Response time, error rates, throughput
- **Logs de sistema**: Syslog, application logs, audit logs
- **Alertas**: Email, Slack, PagerDuty (si aplica)
- **Dashboards**: Visualización de métricas y estado
- **Análisis de rendimiento**: Bottlenecks, capacity planning
- **Health checks**: Liveness y readiness probes

### NO Incluye

- **Monitoreo de producción**: Ver PROC-MONITORING-PROD-001 (por crear)
- **APM (Application Performance Monitoring)**: Ver PROC-APM-001 (por crear)
- **Business Intelligence**: Ver PROC-BI-001 (por crear)
- **User analytics**: Fuera de alcance de infraestructura
- **Synthetic monitoring**: Ver PROC-SYNTHETIC-MONITORING-001 (por crear)

---

## Roles y Responsabilidades

### DevOps Lead (Monitoring Owner)

**Responsabilidades**:
- Definir estrategia de monitoreo y observabilidad
- Configurar herramientas de monitoring
- Implementar recolección de métricas y logs
- Configurar alertas y umbrales
- Crear y mantener dashboards
- Analizar métricas y tendencias
- Responder a alertas críticas
- Optimizar infraestructura basado en datos
- Reportar métricas a management

**Frecuencia**: Continua

---

### Developer (Usuario de Infraestructura)

**Responsabilidades**:
- Implementar logging en aplicaciones
- Instrumentar código para métricas
- Reportar anomalías detectadas
- Responder a alertas de su responsabilidad
- Consultar dashboards para troubleshooting
- Sugerir métricas adicionales relevantes

**Frecuencia**: Continua

---

### Tech Lead / Infrastructure Manager (Stakeholder)

**Responsabilidades**:
- Revisar reportes de métricas mensuales
- Aprobar cambios significativos a monitoreo
- Definir SLAs y SLOs
- Aprobar presupuesto de herramientas
- Tomar decisiones de capacity planning
- Escalar issues críticos

**Frecuencia**: Revisión mensual

---

## Entradas (Inputs)

### Infraestructura a Monitorear

1. **Inventario de Activos**:
   - Lista de VMs y containers
   - Servicios y aplicaciones
   - Bases de datos
   - Componentes de red
   - CI/CD pipelines

2. **Requisitos de Monitoreo**:
   - SLAs y SLOs definidos
   - Métricas críticas por servicio
   - Umbrales de alertas
   - Frecuencia de recolección
   - Retención de datos

3. **Contexto de Negocio**:
   - Horarios críticos de operación
   - Tolerancia a downtime
   - Impacto de fallas
   - Contactos de escalamiento

---

## Salidas (Outputs)

### Sistema de Monitoreo Operativo

1. **Métricas Recolectadas**:
   - Métricas de infraestructura (CPU, RAM, Disk, Network)
   - Métricas de aplicación (latency, errors, requests)
   - Métricas de negocio (custom metrics)
   - Time series data almacenado

2. **Logs Centralizados**:
   - Application logs estructurados
   - System logs (syslog)
   - Audit logs
   - Access logs
   - Error logs

3. **Alertas Configuradas**:
   - Alertas críticas (PagerDuty/on-call)
   - Alertas de warning (Slack/email)
   - Alertas informativas
   - Runbooks vinculados a alertas

4. **Dashboards y Visualizaciones**:
   - Dashboard de overview general
   - Dashboards específicos por servicio
   - Dashboards de capacity planning
   - Reportes automatizados

5. **Reportes de Análisis**:
   - Reporte mensual de métricas
   - Análisis de tendencias
   - Identificación de bottlenecks
   - Recomendaciones de optimización

---

## FLUJO DEL PROCESO

### ETAPA 1: DEFINICION DE ESTRATEGIA DE MONITOREO

**Objetivo**: Establecer qué, cómo y cuándo monitorear

**Duración estimada**: 1-2 semanas (inicial), revisión trimestral

**Actividades**:

1. **Identificar Métricas Críticas**
   - **Golden Signals**: Latency, Traffic, Errors, Saturation
   - Métricas de infraestructura: CPU, RAM, Disk I/O, Network
   - Métricas de aplicación: Response time, error rate, throughput
   - Métricas de negocio: Conversiones, usuarios activos (si aplica)

2. **Definir SLIs, SLOs y SLAs**
   - **SLI (Service Level Indicator)**: Métrica medible (ej: uptime %)
   - **SLO (Service Level Objective)**: Target del SLI (ej: 99.9% uptime)
   - **SLA (Service Level Agreement)**: Compromiso con cliente (ej: 99.5% uptime)
   - Definir por servicio según criticidad

3. **Seleccionar Herramientas de Monitoreo**
   - **Métricas**: Prometheus, Telegraf, collectd
   - **Logs**: ELK Stack, Fluentd, Loki
   - **Visualización**: Grafana, Kibana
   - **Alerting**: Alertmanager, PagerDuty, Slack
   - Considerar: simplicidad, costo, escalabilidad

4. **Definir Políticas de Retención**
   - Métricas high-resolution: 7-30 días
   - Métricas aggregated: 1 año
   - Logs de aplicación: 30-90 días
   - Logs de auditoría: 1-7 años (compliance)

5. **Establecer Umbrales de Alertas**
   - Crítico: Impacto inmediato en servicio
   - Warning: Degradación de performance
   - Info: Eventos notables pero no urgentes
   - Evitar alert fatigue (demasiadas alertas)

6. **Documentar Estrategia**
   - Crear documento de estrategia de monitoreo
   - Documentar métricas por servicio
   - Definir responsables de alertas
   - Aprobar con Tech Lead

**Criterios de Salida**:
- [ ] Métricas críticas identificadas
- [ ] SLOs definidos por servicio
- [ ] Herramientas seleccionadas
- [ ] Políticas de retención definidas
- [ ] Umbrales de alertas establecidos
- [ ] Estrategia documentada y aprobada

**Procedimientos Relacionados**:
- PROCED-DEFINIR-SLOS-001
- PROCED-SELECCIONAR-HERRAMIENTAS-MONITORING-001
- PROCED-DEFINIR-UMBRALES-ALERTAS-001

---

### ETAPA 2: IMPLEMENTACION DE RECOLECCION DE METRICAS

**Objetivo**: Configurar recolección de métricas de infraestructura

**Duración estimada**: 1-2 semanas

**Actividades**:

1. **Instalar Agentes de Monitoreo**
   - Instalar node_exporter (métricas de sistema)
   - Instalar process exporter (métricas de procesos)
   - Instalar database exporters (PostgreSQL, MySQL)
   - Instalar custom exporters (si necesario)

2. **Configurar Recolección de Métricas de Sistema**
   - CPU usage (total, per core)
   - Memory usage (used, available, swap)
   - Disk usage (space, I/O, IOPS)
   - Network (bandwidth, packets, errors)
   - System load average

3. **Configurar Métricas de Aplicación**
   - Instrumentar aplicaciones con librerías (Prometheus client)
   - Exponer endpoint /metrics
   - Definir métricas custom relevantes
   - Implementar counters, gauges, histograms

4. **Configurar Servidor de Métricas**
   - Instalar Prometheus server (o alternativa)
   - Configurar scrape jobs para targets
   - Definir scrape interval (15s, 30s, 60s)
   - Configurar storage y retención
   - Implementar high availability (opcional)

5. **Validar Recolección**
   - Verificar métricas siendo scraped
   - Validar datos en time series database
   - Probar queries básicas (PromQL)
   - Verificar no hay gaps en datos

**Criterios de Salida**:
- [ ] Agentes instalados en todos los targets
- [ ] Métricas de sistema recolectadas
- [ ] Métricas de aplicación instrumentadas
- [ ] Servidor de métricas operativo
- [ ] Recolección validada y funcional

**Procedimientos Relacionados**:
- PROCED-INSTALAR-NODE-EXPORTER-001
- PROCED-INSTRUMENTAR-APLICACION-METRICAS-001
- PROCED-CONFIGURAR-PROMETHEUS-001

---

### ETAPA 3: IMPLEMENTACION DE LOGGING CENTRALIZADO

**Objetivo**: Configurar recolección y centralización de logs

**Duración estimada**: 1-2 semanas

**Actividades**:

1. **Configurar Logging en Aplicaciones**
   - Implementar structured logging (JSON format)
   - Definir niveles de log (DEBUG, INFO, WARN, ERROR, CRITICAL)
   - Incluir contexto relevante (timestamp, request ID, user ID)
   - Evitar logging de datos sensibles (PII, passwords)

2. **Configurar Recolección de System Logs**
   - Configurar syslog/rsyslog
   - Recolectar logs de OS
   - Recolectar logs de servicios (systemd)
   - Recolectar audit logs (auditd)

3. **Implementar Log Aggregation**
   - Instalar log shipper (Fluentd, Filebeat, Promtail)
   - Configurar parsing de logs
   - Configurar filtrado y enriquecimiento
   - Enviar logs a storage centralizado

4. **Configurar Log Storage**
   - Instalar backend de logs (Elasticsearch, Loki)
   - Configurar índices y retention
   - Configurar compresión
   - Implementar rotation de logs

5. **Implementar Log Querying**
   - Instalar UI de logs (Kibana, Grafana)
   - Crear índices y búsquedas comunes
   - Configurar permisos de acceso
   - Crear dashboards de logs

6. **Validar Logging Pipeline**
   - Generar logs de prueba
   - Verificar logs llegan a storage central
   - Probar búsquedas y queries
   - Validar parsing correcto

**Criterios de Salida**:
- [ ] Aplicaciones logueando estructuradamente
- [ ] System logs recolectados
- [ ] Log aggregation configurado
- [ ] Log storage operativo
- [ ] Log querying funcional
- [ ] Pipeline validado end-to-end

**Procedimientos Relacionados**:
- PROCED-IMPLEMENTAR-STRUCTURED-LOGGING-001
- PROCED-CONFIGURAR-FLUENTD-001
- PROCED-CONFIGURAR-ELASTICSEARCH-001
- PROCED-CREAR-DASHBOARDS-LOGS-001

---

### ETAPA 4: CONFIGURACION DE ALERTAS

**Objetivo**: Implementar alertas inteligentes y efectivas

**Duración estimada**: 1 semana

**Actividades**:

1. **Definir Alertas por Severidad**
   - **Críticas**: Servicio caído, data loss inminente
   - **Altas**: Degradación significativa de performance
   - **Medias**: Anomalías que requieren investigación
   - **Bajas**: Eventos informativos

2. **Configurar Alerting Rules**
   - Crear reglas en Prometheus Alertmanager
   - Definir queries para cada alerta
   - Establecer umbrales y duración (for: 5m)
   - Incluir labels informativos
   - Escribir descripciones claras

3. **Implementar Canales de Notificación**
   - Configurar email para alertas medias/bajas
   - Configurar Slack para alertas altas
   - Configurar PagerDuty para alertas críticas (opcional)
   - Implementar webhook genérico (si necesario)

4. **Vincular Runbooks a Alertas**
   - Crear runbook para cada alerta crítica/alta
   - Incluir steps de troubleshooting
   - Documentar escalamiento
   - Vincular URL en anotación de alerta

5. **Configurar On-Call Rotation (Opcional)**
   - Definir schedule de on-call
   - Configurar escalation policy
   - Integrar con PagerDuty/Opsgenie
   - Comunicar schedule al equipo

6. **Implementar Alert Suppression**
   - Silencing durante maintenance windows
   - Agrupación de alertas relacionadas
   - Deduplicación de alertas
   - Rate limiting para evitar spam

**Criterios de Salida**:
- [ ] Alertas definidas por severidad
- [ ] Alerting rules configuradas
- [ ] Canales de notificación activos
- [ ] Runbooks vinculados
- [ ] Alert suppression implementado
- [ ] Alertas probadas

**Procedimientos Relacionados**:
- PROCED-CREAR-ALERTA-PROMETHEUS-001
- PROCED-CONFIGURAR-ALERTMANAGER-001
- PROCED-CREAR-RUNBOOK-ALERTA-001
- PROCED-CONFIGURAR-SLACK-ALERTAS-001

---

### ETAPA 5: CREACION DE DASHBOARDS Y VISUALIZACIONES

**Objetivo**: Crear visualizaciones efectivas del estado de infraestructura

**Duración estimada**: 1-2 semanas

**Actividades**:

1. **Crear Dashboard de Overview**
   - Status general de servicios (UP/DOWN)
   - Métricas key agregadas (CPU, RAM, Disk total)
   - Alertas activas
   - Top issues o anomalías
   - Tráfico general

2. **Crear Dashboards por Servicio**
   - Dashboard específico por VM
   - Dashboard por aplicación
   - Dashboard por base de datos
   - Métricas detalladas relevantes

3. **Crear Dashboards de Capacity Planning**
   - Tendencias de uso de recursos (30 días)
   - Proyección de crecimiento
   - Utilización vs capacidad
   - Recomendaciones de scaling

4. **Implementar Visualizaciones Efectivas**
   - Usar gráficos apropiados (line, gauge, heatmap)
   - Colores intuitivos (verde OK, amarillo warning, rojo crítico)
   - Incluir umbrales en gráficos
   - Anotaciones de eventos importantes

5. **Configurar Variables de Dashboard**
   - Filtros por ambiente (dev/staging/prod)
   - Filtros por servicio
   - Filtros por tiempo
   - Templates reutilizables

6. **Compartir y Documentar Dashboards**
   - Publicar URLs de dashboards
   - Documentar qué dashboard usar para qué
   - Capacitar equipo en uso de dashboards
   - Configurar permisos de acceso

**Criterios de Salida**:
- [ ] Dashboard de overview creado
- [ ] Dashboards específicos por servicio
- [ ] Dashboard de capacity planning
- [ ] Visualizaciones efectivas y claras
- [ ] Variables configuradas
- [ ] Equipo capacitado en uso

**Procedimientos Relacionados**:
- PROCED-CREAR-DASHBOARD-GRAFANA-001
- PROCED-DISEÑAR-VISUALIZACIONES-EFECTIVAS-001
- PROCED-COMPARTIR-DASHBOARDS-001

---

### ETAPA 6: ANALISIS Y OPTIMIZACION

**Objetivo**: Analizar datos de monitoreo para optimizar infraestructura

**Duración estimada**: Continuo (análisis semanal/mensual)

**Actividades**:

1. **Análisis Diario de Métricas**
   - Revisar dashboards principales
   - Identificar anomalías
   - Verificar alertas activas
   - Validar tendencias normales

2. **Análisis Semanal de Tendencias**
   - Revisar tendencias de la semana
   - Comparar con semanas anteriores
   - Identificar patrones anormales
   - Detectar degradación progresiva

3. **Análisis Mensual de Performance**
   - Generar reporte mensual de métricas
   - Análisis de SLO compliance
   - Identificar bottlenecks
   - Documentar incidentes del mes
   - Comparar con meses anteriores

4. **Capacity Planning**
   - Analizar tendencias de crecimiento
   - Proyectar necesidades futuras
   - Identificar recursos subutilizados
   - Recomendar optimizaciones o scaling

5. **Optimización Basada en Datos**
   - Identificar servicios con alto CPU/RAM
   - Optimizar queries lentas (si DB)
   - Ajustar configuraciones (cache, pools)
   - Eliminar recursos no utilizados
   - Validar impacto de optimizaciones

6. **Ajuste de Alertas y Umbrales**
   - Revisar alertas con muchos false positives
   - Ajustar umbrales según comportamiento real
   - Eliminar alertas innecesarias
   - Agregar alertas para nuevos issues detectados

**Criterios de Salida**:
- [ ] Análisis diario/semanal/mensual completado
- [ ] Reporte mensual generado
- [ ] SLO compliance medido
- [ ] Optimizaciones identificadas e implementadas
- [ ] Alertas ajustadas según aprendizajes

**Procedimientos Relacionados**:
- PROCED-ANALIZAR-METRICAS-DIARIAS-001
- PROCED-GENERAR-REPORTE-MENSUAL-001
- PROCED-CAPACITY-PLANNING-001
- PROCED-OPTIMIZAR-BASADO-EN-METRICAS-001

---

### ETAPA 7: RESPUESTA A ALERTAS Y TROUBLESHOOTING

**Objetivo**: Responder efectivamente a alertas y resolver issues

**Duración estimada**: Variable (según incidente)

**Actividades**:

1. **Recepción de Alerta**
   - Alerta recibida vía canal configurado
   - Clasificar severidad
   - Identificar servicio afectado
   - Asignar responsable (on-call o DevOps Lead)

2. **Investigación Inicial**
   - Revisar dashboard del servicio afectado
   - Consultar logs recientes
   - Identificar timeline de inicio del issue
   - Revisar cambios recientes (deployments, configs)

3. **Consultar Runbook**
   - Acceder runbook vinculado a alerta
   - Seguir steps de troubleshooting
   - Ejecutar comandos de diagnóstico
   - Recolectar información adicional

4. **Mitigación y Resolución**
   - Implementar fix según runbook
   - Rollback si deployment reciente causó issue
   - Reiniciar servicios si necesario
   - Aplicar workaround temporal

5. **Validación de Resolución**
   - Verificar métrica volvió a normal
   - Validar servicio funciona correctamente
   - Confirmar alerta se resolvió
   - Monitorear por recurrencia

6. **Documentación Post-Incidente**
   - Documentar causa raíz
   - Documentar steps de resolución
   - Actualizar runbook si necesario
   - Registrar lecciones aprendidas
   - Crear task para prevención futura

**Criterios de Salida**:
- [ ] Alerta resuelta
- [ ] Servicio funcionando normalmente
- [ ] Causa raíz identificada
- [ ] Resolución documentada
- [ ] Runbook actualizado (si necesario)
- [ ] Acción preventiva creada

**Procedimientos Relacionados**:
- PROCED-RESPONDER-ALERTA-001
- PROCED-TROUBLESHOOT-CON-METRICAS-001
- PROCED-TROUBLESHOOT-CON-LOGS-001
- PROCED-DOCUMENTAR-POST-INCIDENTE-001

---

## DIAGRAMA DE FLUJO

```
┌─────────────────────────────────────────────────────────────────────┐
│       MONITOREO Y OBSERVABILIDAD DE INFRAESTRUCTURA - FLUJO         │
└─────────────────────────────────────────────────────────────────────┘

                    [Inicio del Proceso]
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 1: ESTRATEGIA     │
                    │ - Identificar métricas  │
                    │ - Definir SLOs          │
                    │ - Seleccionar tools     │
                    │ - Definir umbrales      │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 2: METRICAS       │
                    │ - Instalar agentes      │
                    │ - Config recolección    │
                    │ - Instrumentar apps     │
                    │ - Validar recolección   │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 3: LOGGING        │
                    │ - Config logging apps   │
                    │ - Log aggregation       │
                    │ - Log storage           │
                    │ - Validar pipeline      │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 4: ALERTAS        │
                    │ - Definir alertas       │
                    │ - Config rules          │
                    │ - Canales notificación  │
                    │ - Vincular runbooks     │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 5: DASHBOARDS     │
                    │ - Dashboard overview    │
                    │ - Dashboards servicios  │
                    │ - Capacity planning     │
                    │ - Compartir al equipo   │
                    └─────────────────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                    ▼                           ▼
        ┌─────────────────────────┐ ┌─────────────────────────┐
        │ ETAPA 6: ANALISIS       │ │ ETAPA 7: RESPUESTA      │
        │ - Análisis diario       │ │ - Recepción alerta      │
        │ - Análisis semanal      │ │ - Investigación         │
        │ - Reporte mensual       │ │ - Consultar runbook     │
        │ - Capacity planning     │ │ - Mitigación            │
        │ - Optimización          │ │ - Validación            │
        │ - Ajuste alertas        │ │ - Documentación         │
        └─────────────────────────┘ └─────────────────────────┘
                    │                           │
                    │      ¿Alerta activada?    │
                    │            │              │
                    │           SÍ ─────────────┘
                    │
              Ciclo continuo
                    │
                    └───► Volver a ETAPA 6 (análisis continuo)
                          Volver a ETAPA 1 (revisión trimestral)
```

---

## CRITERIOS DE ENTRADA Y SALIDA POR ETAPA

| Etapa | Criterio de Entrada | Criterio de Salida |
|-------|---------------------|-------------------|
| 1. Estrategia | Inicio del proceso | Estrategia documentada, aprobada |
| 2. Métricas | Estrategia definida | Métricas recolectadas, validadas |
| 3. Logging | Métricas configuradas | Logs centralizados, accesibles |
| 4. Alertas | Métricas y logs operativos | Alertas configuradas, probadas |
| 5. Dashboards | Datos disponibles | Dashboards creados, compartidos |
| 6. Análisis | Sistema operativo | Análisis completado, optimizaciones aplicadas |
| 7. Respuesta | Alerta activada | Issue resuelto, documentado |

---

## METRICAS Y KPIs

### Métricas Principales

| Métrica | Target | Frecuencia | Dueño |
|---------|--------|-----------|-------|
| **Uptime de Servicios** | > 99.9% | Mensual | DevOps Lead |
| **Mean Time to Detect (MTTD)** | < 5 minutos | Por incidente | DevOps Lead |
| **Mean Time to Resolve (MTTR)** | < 30 minutos | Por incidente | DevOps Lead |
| **Alert Accuracy** | > 90% (no false positives) | Mensual | DevOps Lead |
| **Dashboard Usage** | 100% equipo usa | Mensual | DevOps Lead |
| **SLO Compliance** | > 99% | Mensual | DevOps Lead |

### Métricas Secundarias

- Número de alertas por severidad
- Tiempo promedio de respuesta a alertas
- Porcentaje de alertas con runbook
- Cobertura de monitoreo (% servicios monitoreados)
- Storage utilizado por métricas/logs
- Número de dashboards activos
- Frecuencia de análisis de métricas

### Reporte Mensual

Incluir:
- Uptime por servicio
- Total de alertas y distribución por severidad
- Incidentes críticos y resoluciones
- SLO compliance por servicio
- Tendencias de uso de recursos
- Optimizaciones implementadas
- Recomendaciones para próximo mes

---

## HERRAMIENTAS Y TECNOLOGIAS

### Métricas

- **Prometheus**: Time series database y alerting
- **Grafana**: Visualización y dashboards
- **Node Exporter**: Métricas de sistema
- **Database Exporters**: PostgreSQL, MySQL exporters
- **Custom Exporters**: Métricas de aplicación

### Logging

- **Fluentd / Fluent Bit**: Log collection y forwarding
- **Elasticsearch**: Log storage y search
- **Kibana**: Log visualization
- **Loki + Grafana**: Alternativa ligera a ELK

### Alerting

- **Prometheus Alertmanager**: Alert routing y management
- **Slack**: Notificaciones
- **Email**: Notificaciones
- **PagerDuty / Opsgenie**: On-call management (opcional)

### Tracing (Opcional)

- **Jaeger**: Distributed tracing
- **Zipkin**: Tracing alternativo

### Health Checks

- **Bash scripts**: Health check simples
- **Blackbox Exporter**: Probing de endpoints

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: Alert Storm (Múltiples Alertas Simultáneas)

**Trigger**: 10+ alertas activadas en <5 minutos

**Acciones**:
- Identificar causa raíz común (ej: VM caída)
- Silenciar alertas secundarias temporalmente
- Enfocarse en resolver issue principal
- Comunicar status al equipo
- Post-mortem para mejorar alert grouping

---

### Caso 2: False Positive Recurrente

**Trigger**: Misma alerta con false positive 3+ veces

**Acciones**:
- Investigar causa de false positives
- Ajustar umbral de alerta
- Mejorar query de alerta
- Considerar eliminar alerta si no útil
- Documentar decisión

---

### Caso 3: Dashboard de Emergency

**Trigger**: Incidente crítico requiere dashboard específico

**Acciones**:
- Crear dashboard ad-hoc rápidamente
- Enfocarse en métricas relevantes al incidente
- Compartir con equipo de respuesta
- Después del incidente, evaluar si dashboard permanente

---

### Caso 4: Storage de Métricas/Logs Lleno

**Trigger**: Storage > 90% capacidad

**Acciones**:
- Reducir retention temporalmente
- Eliminar datos antiguos
- Optimizar compresión
- Provisionar storage adicional
- Revisar políticas de retención

---

### Caso 5: Nueva Métrica Crítica Necesaria

**Trigger**: Incidente revela falta de visibilidad

**Acciones**:
- Fast-track implementación de métrica
- Instrumentar aplicación/servicio
- Configurar recolección
- Crear alerta si necesario
- Agregar a dashboards relevantes

---

## INTERACCION CON OTROS PROCESOS

```
PROC-INFRA-005 (Este proceso)
       │
       ├─► PROC-INFRA-001 (Gestión de VMs)
       │      └─ Monitorear salud de VMs
       │
       ├─► PROC-INFRA-002 (DevContainers)
       │      └─ Métricas de containers
       │
       ├─► PROC-INFRA-003 (Hardening y Seguridad)
       │      └─ Alertas de seguridad, audit logs
       │
       ├─► PROC-INFRA-004 (Backup y Recuperación)
       │      └─ Alertas de fallos de backup
       │
       ├─► PROC-INCIDENT-MGMT-001 (Por crear)
       │      └─ Alertas disparan incident response
       │
       └─► PROC-CAPACITY-PLANNING-001 (Por crear)
              └─ Datos de monitoreo para planning
```

---

## CONTROLES Y VALIDACIONES

### Validaciones Automáticas

1. **Health Checks de Sistema de Monitoreo**
   - Prometheus server UP
   - Scrape jobs activos
   - Alertmanager funcional
   - Dashboards accesibles

2. **Validación de Recolección**
   - Todos los targets siendo scraped
   - No gaps en time series data
   - Logs fluyendo a storage central
   - Alertas ejecutándose

3. **Validación de Alertas**
   - Test de alertas periódicamente
   - Validar canales de notificación
   - Verificar runbooks accesibles

### Validaciones Periódicas

| Validación | Frecuencia | Automatizada | Responsable |
|------------|-----------|--------------|-------------|
| Targets scraped | Diario | Sí | DevOps Lead |
| Alertas funcionales | Semanal | Parcial | DevOps Lead |
| Dashboards actualizados | Mensual | No | DevOps Lead |
| Logs fluyendo | Diario | Sí | DevOps Lead |
| Storage disponible | Diario | Sí | DevOps Lead |
| Runbooks actualizados | Trimestral | No | DevOps Lead |

---

## TROUBLESHOOTING

### Problema: Métricas no Siendo Recolectadas

**Causas comunes**:
- Exporter caído
- Firewall bloqueando puerto
- Prometheus no configurado para scrape

**Solución**:
1. Verificar exporter UP: `systemctl status node_exporter`
2. Verificar puerto accesible: `curl http://localhost:9100/metrics`
3. Verificar config de Prometheus: `promtool check config`
4. Reiniciar Prometheus si necesario

---

### Problema: Alertas no Siendo Enviadas

**Causas comunes**:
- Alertmanager caído
- Configuración incorrecta de receiver
- Network issues

**Solución**:
1. Verificar Alertmanager UP
2. Revisar logs de Alertmanager
3. Probar receiver manualmente
4. Verificar configuración de routing

---

### Problema: Dashboard Vacío o con Errores

**Causas comunes**:
- Query incorrecta (PromQL)
- Data source no configurado
- Permisos de acceso

**Solución**:
1. Probar query en Prometheus UI
2. Verificar data source en Grafana
3. Revisar permisos de dashboard
4. Verificar retention de datos

---

### Problema: Logs no Aparecen en Storage

**Causas comunes**:
- Log shipper caído
- Parsing incorrecto
- Elasticsearch/Loki caído

**Solución**:
1. Verificar status de shipper: `systemctl status fluentd`
2. Revisar logs de shipper
3. Verificar backend de logs UP
4. Probar pipeline manualmente

---

## MEJORA CONTINUA

### Retrospectivas Post-Incidente

**Participantes**: DevOps Lead + Responders + Affected Developers

**Agenda**:
1. Timeline del incidente
2. Efectividad de monitoreo (MTTD)
3. Efectividad de alertas
4. Utilidad de dashboards/logs
5. Mejoras al monitoreo
6. Actualizar runbooks

---

### Revisión Trimestral del Proceso

**Por realizar**: Cada 3 meses (próxima: 2026-02-18)

**Verificar**:
- Métricas de MTTD y MTTR
- Alert accuracy (false positives)
- Dashboard usage
- SLO compliance trends
- Nuevas herramientas de monitoreo disponibles
- Feedback del equipo
- Actualizar proceso según aprendizajes

---

## REFERENCIAS Y GUIAS

- [Google SRE Book - Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [The Four Golden Signals](https://sre.google/sre-book/monitoring-distributed-systems/#xref_monitoring_golden-signals)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Best Practices](https://grafana.com/docs/grafana/latest/best-practices/)
- [Effective Alerting](https://docs.google.com/document/d/199PqyG3UsyXlwieHaqbGiWVa8eMWi8zzAn0YfcApr8Q/)
- [ELK Stack Documentation](https://www.elastic.co/guide/index.html)

---

## HISTORIAL DE CAMBIOS

### v1.0.0 (2025-11-18)

- Versión inicial del proceso
- Definición de 7 etapas del flujo
- Roles y responsabilidades establecidos
- Métricas y KPIs (MTTD, MTTR) definidos
- Estrategia de monitoreo documentada
- Casos especiales incluidos
- Diagrama de flujo y troubleshooting

**Creado por**: Claude Code (Sonnet 4.5)
**Técnica de prompting**: Auto-CoT + Template-based
**Estado**: Activo (aprobación pendiente)

---

**Próxima revisión**: 2026-02-18 (3 meses)
**Responsable de revisión**: DevOps Lead + Tech Lead
**Aprobación pendiente**: CTO, Infrastructure Manager, SRE Lead
