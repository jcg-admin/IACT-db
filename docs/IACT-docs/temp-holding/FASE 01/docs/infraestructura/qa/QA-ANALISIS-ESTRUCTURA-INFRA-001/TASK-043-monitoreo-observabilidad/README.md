---
id: PROC-INFRA-005
tipo: proceso
categoria: infraestructura
subcategoria: monitoring_observability
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-INFRA-001", "PROC-INFRA-002", "PROC-INFRA-003", "PROC-INFRA-004"]
---

# PROCESO: Monitoreo y Observabilidad de Infraestructura

## Objetivo

Definir el flujo de recopilación, análisis y respuesta ante eventos de infraestructura, asegurando disponibilidad, performance, seguridad y detección temprana de problemas en VMs, DevContainers y componentes de infraestructura.

---

## Propósito (QUÉ)

Establecer un proceso integral para:

1. **Recopilar** métricas de infraestructura (CPU, RAM, disk, red)
2. **Registrar** logs de eventos (aplicación, sistema, seguridad)
3. **Rastrear** cambios de configuración (drift detection)
4. **Alertar** cuando se detectan anomalías
5. **Investigar** issues de infraestructura
6. **Resolver** problemas de forma sistemática
7. **Analizar** tendencias para mejora proactiva
8. **Comunicar** status a stakeholders

Este es un proceso de **nivel estratégico/operativo** (alto nivel). Para detalles técnicos (CÓMO), ver procedimientos relacionados.

---

## Alcance

### Incluye

- **Monitoreo de VMs**: Uptime, CPU, RAM, disk, I/O
- **Monitoreo de DevContainers**: Build time, image size, compatibilidad
- **Monitoreo de Servicios**: Status de servicios, puertos abiertos, conectividad
- **Logs Centralizados**: Agregación de logs de múltiples fuentes
- **Alertas**: Notificación en tiempo real de problemas
- **Dashboards**: Visualización de estado actual
- **Reportes**: Análisis de performance y tendencias
- **On-call**: Escalado de issues críticos
- **Documentación**: Runbooks de troubleshooting

### NO Incluye

- **Monitoreo de aplicación**: Responsabilidad del equipo de desarrollo
- **Monitoreo en producción**: Procesos separados para prod
- **Seguridad avanzada**: Ver PROC-SEGURIDAD-INFRA
- **Capacidad planning**: Ver PROC-GOBERNANZA-INFRA
- **Incident response**: Ver PROC-INCIDENT-RESPONSE (por crear)

---

## Roles y Responsabilidades

### Developer (Usuario de infraestructura)

**Responsabilidades**:
- Usar infraestructura de forma responsable
- Reportar problemas identificados
- Proporcionar feedback sobre salud de infraestructura
- Colaborar en troubleshooting si necesario
- Validar después de cambios

**Frecuencia**: Continua

---

### DevOps Engineer (Operador)

**Responsabilidades**:
- Configurar y mantener monitoreo
- Revisar dashboards regularmente
- Responder a alertas
- Investigar issues
- Documentar problemas y soluciones
- Optimizar alertas (reducir false positives)
- Mantener runbooks actualizados

**Frecuencia**: 24/7

---

### On-Call Engineer (Escalado)

**Responsabilidades**:
- Estar disponible para issues críticos
- Responder rápidamente a alertas
- Ejecutar troubleshooting
- Contactar especialistas si necesario
- Documentar issue y resolución

**Frecuencia**: Rotación (típicamente 1 semana)

---

### Tech Lead / Infrastructure Manager (Revisor)

**Responsabilidades**:
- Revisar reportes de monitoreo
- Identificar tendencias
- Aprobar cambios a alertas
- Planificar mejoras
- Revisar este proceso

**Frecuencia**: Semanal/Mensual

---

## Entradas (Inputs)

### Fuentes de Datos

1. **Infraestructura**:
   - Métricas de VM (Vagrant, VirtualBox)
   - Métricas de aplicación (si aplica)
   - Logs del sistema operativo
   - Logs de servicios (SSH, Docker, etc.)

2. **Herramientas Instaladas**:
   - Monitoring agents (Prometheus, Telegraf, etc.)
   - Log collectors (Filebeat, Fluentd, etc.)
   - Health check scripts
   - Sistema de alertas

3. **Configuración**:
   - Thresholds de alertas
   - Políticas de retención de logs
   - Dashboard definitions
   - Escalado de issues

---

## Salidas (Outputs)

### Monitoreo Activo

1. **Dashboards**:
   - Estado actual de infraestructura
   - Métricas clave visualizadas
   - Actualizadas en tiempo real

2. **Alertas**:
   - Notificaciones de problemas
   - Por severidad (info, warning, critical)
   - A canales apropiados (Slack, email, on-call)

3. **Reportes**:
   - Diarios: Issues críticos
   - Semanales: Performance trends
   - Mensuales: Capacity y recomendaciones

4. **Documentación**:
   - Runbooks de troubleshooting
   - Causa-raíz de issues
   - Procedimientos de respuesta

---

## FLUJO DEL PROCESO

### ETAPA 1: CONFIGURACIÓN DE MONITOREO

**Objetivo**: Establecer instrumentación de infraestructura

**Duración estimada**: 2-4 horas (setup inicial)

**Actividades**:

1. **Identificar Componentes a Monitorear**
   - VMs (listar todas las máquinas)
   - DevContainers (ambiente de desarrollo)
   - Servicios críticos (si aplica)
   - Almacenamiento y red

2. **Seleccionar Herramientas**
   - Monitoring: Prometheus, Grafana, Datadog, etc.
   - Logging: ELK stack, Splunk, etc.
   - Alertas: Alertmanager, OpsGenie, etc.
   - Herramientas deben ser open-source o disponibles

3. **Instalar Agents**
   - Prometheus node exporter en cada VM
   - Log shippers en cada nodo
   - Health check scripts
   - Validar que agents funcionan

4. **Crear Dashboards Iniciales**
   - Overview de infraestructura
   - VM status (uptime, recursos)
   - Service status
   - Top metrics por importancia

5. **Documentar Configuración**
   - Dónde está cada componente
   - Cómo acceder (URLs, credenciales)
   - Procedimiento de escalado
   - Runbook básico

**Criterios de Salida**:
- [ ] Herramientas instaladas
- [ ] Agents recopilando datos
- [ ] Dashboards funcionales
- [ ] Documentación completa

**Procedimientos Relacionados**:
- PROCED-INSTALAR-MONITORING-001
- PROCED-CREAR-DASHBOARD-001

---

### ETAPA 2: DEFINICIÓN DE ALERTAS

**Objetivo**: Establecer umbrales y reglas de alertas

**Duración estimada**: 2-3 horas

**Actividades**:

1. **Definir Thresholds**
   - CPU: Warning 70%, Critical 90%
   - RAM: Warning 80%, Critical 95%
   - Disk: Warning 80%, Critical 95%
   - Uptime: < 99% = warning
   - Servicios caídos = critical

2. **Establecer Reglas**
   - CPU > 90% por > 5 min = alert
   - RAM > 95% = alert inmediato
   - Disk > 95% = alert inmediato
   - Servicio down = alert inmediato
   - Multiple metrics degraded = warning

3. **Canales de Notificación**
   - Critical: Slack #infraestructura + on-call
   - Warning: Slack #infraestructura + email
   - Info: Dashboard solamente
   - Severidad basada en impacto

4. **Escalado**
   - No responden en 15 min → escalado a Tech Lead
   - No responden en 30 min → escalado a CTO
   - Definir cadena de escalado

5. **Testing de Alertas**
   - Simular cada condición de alerta
   - Validar que notificación llega
   - Verificar canales correctos
   - Documentar testing

**Criterios de Salida**:
- [ ] Thresholds definidos
- [ ] Reglas configuradas
- [ ] Canales de notificación activos
- [ ] Testing completado
- [ ] Equipo entrenado

**Procedimientos Relacionados**:
- PROCED-CONFIGURAR-ALERTAS-001
- PROCED-TESTING-ALERTAS-001

---

### ETAPA 3: RECOPILACIÓN DE LOGS

**Objetivo**: Centralizar y indexar logs para análisis

**Duración estimada**: 2-3 horas

**Actividades**:

1. **Identificar Fuentes de Logs**
   - System logs (/var/log/syslog, /var/log/messages)
   - Application logs (si hay aplicaciones)
   - Service logs (SSH, Docker, etc.)
   - Seguridad logs (auth.log, audit logs)

2. **Instalar Log Collectors**
   - Filebeat/Fluentd en cada nodo
   - Configurar para enviar a central
   - Incluir host/timestamp/source

3. **Centralizar Logs**
   - ElasticSearch/Loki/Splunk central
   - Retención de 30 días (mínimo)
   - Indexación para búsqueda rápida
   - Autenticación y RBAC

4. **Crear Log Alerts**
   - Error patterns detectados automáticamente
   - Security events alertados
   - Performance degradation en logs
   - Failed authentication attempts

5. **Acceso y Búsqueda**
   - Visualización de logs en Kibana/Grafana
   - Búsqueda por palabra clave
   - Filtros por host/service/time
   - Exportación de resultados

**Criterios de Salida**:
- [ ] Log collectors instalados
- [ ] Logs centralizados
- [ ] Búsqueda funcional
- [ ] Alertas configuradas
- [ ] Acceso documentado

**Procedimientos Relacionados**:
- PROCED-CONFIGURAR-LOG-COLLECTION-001

---

### ETAPA 4: MONITOREO DIARIO Y SEMANAL

**Objetivo**: Revisar estado de infraestructura regularmente

**Duración estimada**: 30 minutos - 2 horas (diarios/semanales)

**Actividades**:

1. **Revisión Diaria** (al iniciar día laboral)
   - Revisar dashboards de overview
   - Verificar que no hay alertas no respondidas
   - Revisar logs de anomalías
   - Notar cualquier degradación

2. **Respuesta a Alertas**
   - Verificar que alerta es real (no falso positivo)
   - Si es crítica: actuar inmediatamente
   - Si es warning: investigar y planificar fix
   - Documentar en issue tracker

3. **Investigación de Issues**
   - Revisar logs relevantes
   - Reproducir problema si es posible
   - Identificar causa raíz
   - Aplicar fix o workaround
   - Documentar solución

4. **Revisión Semanal** (1 vez por semana)
   - Análisis de tendencias semanales
   - Performance promedio por VM
   - Problemas recurrentes identificados
   - Capacidad remaining

5. **Documentación**
   - Issues resueltos registrados
   - Runbooks actualizados
   - Lecciones documentadas
   - Cambios a alertas si necesario

**Criterios de Salida**:
- [ ] Dashboards revisados diariamente
- [ ] Alertas respondidas < 1 hora
- [ ] Issues investigados
- [ ] Soluciones documentadas
- [ ] Tendencias analizadas

**Procedimientos Relacionados**:
- PROCED-REVISAR-DASHBOARDS-001
- PROCED-RESPONDER-ALERTAS-001

---

### ETAPA 5: INVESTIGACIÓN DE ISSUES

**Objetivo**: Diagnosticar y resolver problemas de infraestructura

**Duración estimada**: 30 minutos - 4 horas (por issue)

**Actividades**:

1. **Triage de Alerta**
   - ¿Es alerta válida o falso positivo?
   - ¿Cuál es severidad actual?
   - ¿Impacto en desarrollo/usuarios?
   - ¿Workaround temporal disponible?

2. **Recopilación de Datos**
   - SSH a VM afectada
   - `top` / `htop` para procesos
   - `df -h` para disk space
   - Logs relevantes (`tail -f /var/log/*`)
   - `systemctl status` para servicios
   - Network connectivity (`ping`, `netstat`)

3. **Análisis Inicial**
   - Patrón de comportamiento (consistente o intermitente)
   - Correlación con cambios recientes
   - Comparación con baselines históricas
   - Hipótesis inicial de causa

4. **Testing de Hipótesis**
   - Validar hipótesis con datos
   - Aislar problema (es VM X o servicio Y?)
   - Reproducir si es posible
   - Documentar hallazgos

5. **Resolución**
   - Aplicar fix si es simple (reiniciar servicio, etc.)
   - O aplicar workaround temporal
   - O escalar si requiere cambio formal
   - Validar que problema resuelto

6. **Documentación**
   - Cause analysis documento
   - Pasos de resolución
   - Cómo prevenir en futuro
   - Link a issue en tracker

**Criterios de Salida**:
- [ ] Problema diagnosticado
- [ ] Causa raíz identificada (si posible)
- [ ] Problema resuelto o escalado
- [ ] Documentación completa
- [ ] Aprendizaje documentado

**Procedimientos Relacionados**:
- PROCED-INVESTIGAR-ISSUE-INFRA-001
- PROCED-TROUBLESHOOTING-RUNBOOK-001

---

### ETAPA 6: CAPACIDAD Y PERFORMANCE ANALYSIS

**Objetivo**: Analizar tendencias para planning proactivo

**Duración estimada**: 2-3 horas (mensualmente)

**Actividades**:

1. **Análisis de Capacidad**
   - Disk usage trend (growing?)
   - RAM usage trend
   - CPU average y picos
   - Predicción cuando alcanzaremos límite

2. **Performance Benchmarks**
   - Build time de DevContainer
   - Response time de servicios
   - Network latency
   - Comparación vs baseline

3. **Identificación de Outliers**
   - VMs con uso anormal
   - Servicios con performance degradada
   - Cambios recientes que afectaron performance
   - Oportunidades de optimización

4. **Recomendaciones**
   - Upgrade necesarios
   - Optimizaciones de software
   - Mejoras de proceso
   - Training para desarrolladores

5. **Reporte Mensual**
   - Summary ejecutivo
   - Gráficas de tendencias
   - Capacidad restante estimada
   - Top issues del mes
   - Recomendaciones priorizado

**Criterios de Salida**:
- [ ] Tendencias analizadas
- [ ] Capacidad estimada
- [ ] Performance benchmarked
- [ ] Recomendaciones claras
- [ ] Reporte generado

**Procedimientos Relacionados**:
- PROCED-ANALIZAR-CAPACIDAD-001
- PROCED-GENERAR-REPORTE-MONITORING-001

---

### ETAPA 7: MEJORA CONTINUA

**Objetivo**: Optimizar monitoreo y alertas basado en aprendizaje

**Duración estimada**: 1-2 horas (mensualmente)

**Actividades**:

1. **Revisión de False Positives**
   - ¿Cuántas alertas fueron falsos positivos?
   - Patrón de cuáles generan false positives
   - Ajustar thresholds si es necesario
   - Desactivar si no son útiles

2. **Cobertura de Monitoreo**
   - ¿Qué eventos importantes no tenemos alert?
   - Nuevas métricas a monitorear
   - Nuevas fuentes de logs
   - Mejoras a dashboards

3. **Optimización de Herramientas**
   - Performance de herramientas de monitoreo
   - Storage de logs (¿están creciendo muy rápido?)
   - Acceso y velocidad de búsqueda
   - Costo de herramientas

4. **Entrenamiento de Equipo**
   - Nuevos miembros en on-call
   - Actualización de runbooks
   - Sesiones de troubleshooting
   - Best practices sharing

5. **Actualización de Proceso**
   - Cambios a este proceso basado en aprendizaje
   - Nuevas herramientas evaluadas
   - SLOs revisados
   - Escalado mejorado

**Criterios de Salida**:
- [ ] False positives reducidos
- [ ] Cobertura mejorada
- [ ] Herramientas optimizadas
- [ ] Equipo entrenado
- [ ] Proceso mejorado

**Procedimientos Relacionados**:
- PROCED-REVISAR-ALERTAS-001

---

## DIAGRAMA DE FLUJO

```
┌──────────────────────────────────────────────────────────┐
│   MONITOREO Y OBSERVABILIDAD DE INFRAESTRUCTURA - FLUJO  │
└──────────────────────────────────────────────────────────┘

         [Infraestructura Corriendo]
                      │
                      ▼
      ┌─────────────────────────────────────┐
      │ ETAPA 1: CONFIGURACIÓN DE MONITOREO │
      │ - Identificar componentes           │
      │ - Instalar agents                   │
      │ - Crear dashboards                  │
      │ - Documentar                        │
      └─────────────────────────────────────┘
                      │
                      ▼
      ┌─────────────────────────────────────┐
      │ ETAPA 2: DEFINICIÓN DE ALERTAS      │
      │ - Thresholds definidos              │
      │ - Reglas configuradas               │
      │ - Canales de notificación           │
      │ - Escalado definido                 │
      └─────────────────────────────────────┘
                      │
                      ▼
      ┌─────────────────────────────────────┐
      │ ETAPA 3: RECOPILACIÓN DE LOGS       │
      │ - Log collectors instalados         │
      │ - Logs centralizados                │
      │ - Búsqueda configurada              │
      │ - Alertas de logs                   │
      └─────────────────────────────────────┘
                      │
      [MONITOREO ACTIVO 24/7]
                      │
                      ▼
      ┌─────────────────────────────────────┐
      │ ETAPA 4: MONITOREO DIARIO Y SEMANAL │
      │ - Revisar dashboards                │
      │ - Responder a alertas               │
      │ - Investigar issues                 │
      │ - Documentar soluciones             │
      └─────────────────────────────────────┘
                      │
          ¿Alerta o anomalía detectada?
          ├─ SÍ ──► Continuar a ETAPA 5
          │
          └─ NO ──► Continuar monitoreo
                      │
                      ▼
      ┌─────────────────────────────────────┐
      │ ETAPA 5: INVESTIGACIÓN DE ISSUES    │
      │ - Triage de alerta                  │
      │ - Recopilación de datos             │
      │ - Análisis inicial                  │
      │ - Testing de hipótesis              │
      │ - Resolución o escalado             │
      │ - Documentación                     │
      └─────────────────────────────────────┘
                      │
          ¿Problema resuelto?
          ├─ NO ──► Escalado a Tech Lead
          │
          └─ SÍ ──► Documentar aprendizaje
                      │
                      ▼
      ┌─────────────────────────────────────┐
      │ ETAPA 6: CAPACIDAD Y PERFORMANCE    │
      │ - Análisis mensual de capacidad     │
      │ - Performance benchmarks            │
      │ - Identificar outliers              │
      │ - Recomendaciones                   │
      │ - Reporte mensual                   │
      └─────────────────────────────────────┘
                      │
                      ▼
      ┌─────────────────────────────────────┐
      │ ETAPA 7: MEJORA CONTINUA            │
      │ - Revisar false positives           │
      │ - Mejorar cobertura                 │
      │ - Optimizar herramientas            │
      │ - Entrenar equipo                   │
      │ - Actualizar proceso                │
      └─────────────────────────────────────┘
                      │
          [MONITOREO MEJORADO - volver a ETAPA 4]
```

---

## CRITERIOS DE ENTRADA Y SALIDA POR ETAPA

| Etapa | Criterio de Entrada | Criterio de Salida |
|-------|---------------------|-------------------|
| 1. Configuración | Infraestructura disponible | Agents recopilando datos |
| 2. Alertas | Dashboards funcionales | Alertas probadas y activas |
| 3. Logs | Herramientas de monitoring | Logs centralizados, búsqueda activa |
| 4. Monitoreo | Alertas configuradas | Dashboards revisados, alertas respondidas |
| 5. Investigación | Alerta activada | Problema resuelto o escalado, documentado |
| 6. Capacidad | Datos mensual recopilado | Análisis completado, reporte generado |
| 7. Mejora | Análisis de mes | Proceso mejorado, equipo entrenado |

---

## MÉTRICAS Y KPIs

### Métricas Principales

| Métrica | Target | Frecuencia | Dueño |
|---------|--------|-----------|-------|
| **Infrastructure Uptime** | > 99.5% | Mensual | DevOps |
| **Alert Response Time** | < 15 min | Por alerta | On-call |
| **MTTR (Mean Time To Resolve)** | < 1 hora | Mensual | DevOps |
| **False Positive Rate** | < 10% | Mensual | DevOps |
| **Dashboard Update Frequency** | Real-time | Continuo | DevOps |
| **Monitoring Coverage** | 100% componentes | Mensual | Tech Lead |

### Métricas Secundarias

- Número de alertas por severidad
- Número de issues investigados
- Average CPU/RAM/Disk utilization
- Capacity remaining (%)
- Log retention ratio
- Mean detection time (from occurrence to alert)

### Reporte Diario/Semanal/Mensual

**Diario**:
- Uptimes de infraestructura
- Critical incidents
- On-call handoff summary

**Semanal**:
- Top issues
- Performance trends
- Capacity trending
- False positive review

**Mensual**:
- Uptime agregado
- Performance análisis
- Capacity forecast
- Mejoras implementadas
- Recomendaciones

---

## HERRAMIENTAS Y TECNOLOGÍAS

### Monitoring

- **Prometheus**: Recopilación de métricas
- **Grafana**: Visualización de dashboards
- **node_exporter**: Exportador de métricas de nodo
- **AlertManager**: Sistema de alertas

### Logging

- **ELK Stack** (ElasticSearch, Logstash, Kibana): Centralización de logs
- **Loki**: Alternativa lightweight
- **Filebeat**: Colector de logs
- **Fluentd**: Agregador de logs

### Alertas y Notificación

- **Slack**: Notificaciones
- **Email**: Alertas críticas
- **PagerDuty/OpsGenie**: Escalado y on-call
- **Webhooks**: Integración custom

### Documentación

- **Markdown**: Runbooks y documentación
- **Wiki/Confluence**: Knowledge base
- **GitHub Issues**: Tracking de problemas

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: Incident Crítico

**Trigger**: Issue crítica detectada (downtime, security, data loss)

**Variaciones**:
- Respuesta inmediata (< 5 min)
- Escalado automático a equipo full
- Todas las manos en deck
- Documentación en vivo
- Comunicación cada 15 min
- Post-mortem dentro de 24h

---

### Caso 2: Cambio de Infraestructura

**Trigger**: Después de cambio mayor (PROC-INFRA-004)

**Acciones**:
- Monitoreo intensivo por 24h
- Comparación de métricas con pre-cambio
- Alertas sensibles temporalmente
- Validación de que cambio fue exitoso
- Post-cambio review

---

### Caso 3: Mantenimiento Planificado

**Trigger**: Maintenance window planificado

**Acciones**:
- Suppressar alertas durante ventana
- Comunicar a equipo que monitoreo suppressado
- Resumir monitoreo post-mantenimiento
- Validar que todo está OK
- Documentar resultados

---

## VARIACIONES DEL PROCESO

### Monitoring Básico (Dev)

**Cuando**: Ambiente de desarrollo sin usuarios

**Diferencias**:
- Alertas menos sensibles
- Respuesta menos crítica (< 1 día es OK)
- Documentación simplificada
- Less frequent reviews

---

### Monitoring Crítico (Futuro prod)

**Cuando**: Ambiente con usuarios finales

**Diferencias**:
- Alertas muy sensibles
- Respuesta crítica (< 5 min)
- Documentación exhaustiva
- 24/7 on-call coverage
- SLAs estrictos

---

## INTERACCIÓN CON OTROS PROCESOS

```
PROC-INFRA-005 (Este proceso)
       │
       ├─► PROC-INFRA-001 (Gestión de VMs)
       │      └─ Monitoreo de VMs
       │
       ├─► PROC-INFRA-002 (Ciclo de vida DevContainer)
       │      └─ Monitoreo de DevContainer
       │
       ├─► PROC-INFRA-003 (CI/CD)
       │      └─ Monitoreo de pipeline
       │
       ├─► PROC-INFRA-004 (Gestión de cambios)
       │      └─ Monitoreo post-cambio
       │
       └─► PROC-INCIDENT-RESPONSE (Por crear)
              └─ Issues críticas escalan a incident response
```

---

## REFERENCIAS A PROCEDIMIENTOS (Por Crear)

Este proceso será soportado por:

- **PROCED-INFRA-023-instalar-monitoring**: Setup de Prometheus/Grafana
- **PROCED-INFRA-024-configurar-alertas**: Definición de reglas
- **PROCED-INFRA-025-recopilacion-logs**: Setup ELK/Loki
- **PROCED-INFRA-026-revisar-dashboards**: Guía diaria
- **PROCED-INFRA-027-investigar-issue**: Troubleshooting guide
- **PROCED-INFRA-028-responder-alertas**: Playbook de alertas
- **PROCED-INFRA-029-runbook-troubleshooting**: Soluciones comunes

---

## REFERENCIAS Y GUÍAS

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- [ElasticSearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [SLO/SLI Best Practices](https://sre.google/sre-book/service-level-objectives/)
- [Observability Engineering](https://www.oreilly.com/library/view/observability-engineering/9781492076438/)

---

## HISTORIAL DE CAMBIOS

### v1.0.0 (2025-11-18)

- Versión inicial del proceso
- Definición de 7 etapas de monitoreo
- Roles y responsabilidades claros
- KPIs medibles
- Casos especiales documentados
- Diagrama ASCII de flujo
- Herramientas específicas mencionadas
- Integración con otros procesos

**Creado por**: Claude Code (Haiku 4.5)
**Técnica de prompting**: Chain-of-Thought + Self-Consistency
**Estado**: Activo (aprobación pendiente)

---

**Próxima revisión**: 2026-02-18 (3 meses)
**Responsable de revisión**: DevOps Lead + Tech Lead
**Aprobación pendiente**: CTO, DevOps Manager, Developer Representatives
