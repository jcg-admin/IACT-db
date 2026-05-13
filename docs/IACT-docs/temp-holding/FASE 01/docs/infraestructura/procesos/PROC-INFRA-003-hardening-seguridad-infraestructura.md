---
id: PROC-INFRA-003
tipo: proceso
categoria: infraestructura
subcategoria: security_hardening
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Sonnet 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-INFRA-001", "PROC-INFRA-002", "PROC-SECURITY-001"]
---

# PROCESO: Hardening y Seguridad de Infraestructura

## Objetivo

Definir el flujo completo de aplicación de políticas de seguridad, hardening de sistemas, auditorías periódicas y gestión de vulnerabilidades en la infraestructura del proyecto IACT, asegurando protección proactiva contra amenazas, cumplimiento de estándares de seguridad y minimización de superficie de ataque.

---

## Propósito (QUE)

Establecer un proceso formal y controlado para:

1. **Aplicar** políticas de seguridad a toda la infraestructura
2. **Endurecer** (harden) sistemas operativos y servicios
3. **Auditar** configuraciones de seguridad periódicamente
4. **Detectar** y gestionar vulnerabilidades proactivamente
5. **Responder** a incidentes de seguridad de forma controlada
6. **Actualizar** parches de seguridad en tiempo oportuno
7. **Documentar** controles de seguridad y compliance

Este es un proceso de **nivel estratégico/operativo** (alto nivel). Para detalles de implementación (COMO), ver procedimientos relacionados.

---

## Alcance

### Incluye

- **Infraestructura de desarrollo**: VMs locales, DevContainers, CI/CD agents
- **Sistemas operativos**: Linux (Ubuntu, Debian, CentOS)
- **Servicios**: Bases de datos, servidores web, APIs
- **Red**: Firewall, configuración de puertos, SSL/TLS
- **Acceso**: Autenticación, autorización, gestión de credenciales
- **Aplicaciones**: Dependencies, containers, runtime environments
- **Auditorías**: Scanning de vulnerabilidades, compliance checks
- **Documentación**: Políticas de seguridad, incident reports

### NO Incluye

- **Seguridad de aplicaciones (AppSec)**: Ver PROC-APPSEC-001 (por crear)
- **Gestión de secretos en producción**: Ver PROC-SECRETS-MGMT-001 (por crear)
- **Compliance legal/regulatorio**: Ver PROC-COMPLIANCE-001 (por crear)
- **Seguridad física**: Fuera de alcance (infraestructura cloud/local)
- **Training de seguridad**: Ver PROC-SECURITY-TRAINING-001 (por crear)

---

## Roles y Responsabilidades

### DevOps Lead (Security Owner)

**Responsabilidades**:
- Definir y mantener políticas de seguridad
- Ejecutar auditorías de seguridad periódicas
- Aplicar hardening a nueva infraestructura
- Gestionar vulnerabilidades detectadas
- Coordinar respuesta a incidentes de seguridad
- Mantener inventario de controles de seguridad
- Reportar métricas de seguridad a liderazgo
- Actualizar políticas según amenazas emergentes

**Frecuencia**: Continua

---

### Developer (Usuario de Infraestructura)

**Responsabilidades**:
- Cumplir con políticas de seguridad establecidas
- Reportar vulnerabilidades o configuraciones inseguras detectadas
- Aplicar updates de seguridad a su ambiente local
- No desactivar controles de seguridad sin aprobación
- Participar en incident response (si afectado)
- Sugerir mejoras a políticas de seguridad

**Frecuencia**: Continua

---

### Security Lead / CISO (Aprobador y Auditor)

**Responsabilidades**:
- Aprobar políticas de seguridad críticas
- Revisar resultados de auditorías
- Aprobar excepciones a políticas
- Coordinar pentesting externo (si aplica)
- Validar compliance con estándares
- Escalar incidentes críticos a management
- Definir niveles de riesgo aceptables

**Frecuencia**: Revisiones mensuales/trimestrales

---

## Entradas (Inputs)

### Infraestructura a Asegurar

1. **Inventario de Activos**:
   - Lista de VMs activas
   - Containers y images en uso
   - Servicios expuestos
   - Bases de datos y datastores
   - Endpoints de red

2. **Contexto de Seguridad**:
   - Políticas de seguridad corporativas
   - Estándares de industria (CIS Benchmarks, OWASP)
   - Compliance requirements
   - Threat model del proyecto

3. **Herramientas de Seguridad**:
   - Vulnerability scanners
   - Configuration audit tools
   - Security linters
   - Monitoring tools

### Triggers de Proceso

- Nueva infraestructura provisionada
- Vulnerabilidad crítica publicada (CVE)
- Auditoría programada (mensual/trimestral)
- Incidente de seguridad detectado
- Cambio significativo en arquitectura

---

## Salidas (Outputs)

### Infraestructura Endurecida y Segura

1. **Configuraciones Aplicadas**:
   - Firewalls configurados y activos
   - Servicios innecesarios deshabilitados
   - Permisos de archivos restringidos
   - SSL/TLS configurado en servicios
   - Logging y auditing habilitados

2. **Reporte de Auditoría**:
   - Resultados de scans de vulnerabilidades
   - Configuraciones no conformes detectadas
   - Remediaciones aplicadas
   - Riesgos residuales documentados
   - Plan de acción para issues pendientes

3. **Documentación de Seguridad**:
   - Políticas de seguridad actualizadas
   - Procedimientos de hardening documentados
   - Incident reports (si aplicable)
   - Evidencia de compliance

4. **Métricas de Seguridad**:
   - Número de vulnerabilidades por severidad
   - Tiempo promedio de remediación
   - Cobertura de auditorías
   - Compliance score

---

## FLUJO DEL PROCESO

### ETAPA 1: DEFINICION DE POLITICAS DE SEGURIDAD

**Objetivo**: Establecer políticas de seguridad claras y aplicables

**Duración estimada**: Inicial 1-2 semanas, revisión trimestral

**Actividades**:

1. **Identificar Requisitos de Seguridad**
   - Analizar threat model del proyecto
   - Revisar estándares de industria aplicables
   - Identificar datos sensibles a proteger
   - Evaluar compliance requirements
   - Consultar con stakeholders

2. **Definir Políticas por Categoría**
   - **Acceso**: Autenticación, autorización, MFA
   - **Red**: Firewall rules, puertos permitidos, SSL/TLS
   - **Sistemas**: Hardening de OS, servicios permitidos
   - **Datos**: Encriptación, backup, retention
   - **Aplicaciones**: Dependencies, container security
   - **Monitoreo**: Logging, alertas, incident response

3. **Documentar Políticas**
   - Escribir políticas en lenguaje claro
   - Incluir justificación y contexto
   - Definir excepciones permitidas
   - Especificar procedimientos de aplicación
   - Establecer proceso de revisión

4. **Aprobar y Comunicar**
   - Review por Security Lead/CISO
   - Aprobación formal de políticas
   - Comunicar a todo el equipo
   - Training inicial (si necesario)
   - Publicar en repositorio de documentación

**Criterios de Salida**:
- [ ] Políticas documentadas por categoría
- [ ] Políticas aprobadas por Security Lead
- [ ] Equipo notificado y capacitado
- [ ] Políticas publicadas y accesibles
- [ ] Proceso de revisión definido

**Procedimientos Relacionados**:
- PROCED-DEFINIR-POLITICAS-SEGURIDAD-001
- PROCED-THREAT-MODELING-001

---

### ETAPA 2: APLICACION INICIAL DE HARDENING

**Objetivo**: Aplicar controles de seguridad a infraestructura nueva

**Duración estimada**: 2-4 horas por sistema

**Actividades**:

1. **Hardening de Sistema Operativo**
   - Actualizar OS a última versión estable
   - Aplicar security patches pendientes
   - Desactivar servicios innecesarios
   - Configurar firewall local (ufw/iptables)
   - Establecer políticas de contraseñas fuertes
   - Deshabilitar root login remoto

2. **Hardening de Red**
   - Configurar reglas de firewall
   - Cerrar puertos no utilizados
   - Configurar SSL/TLS en servicios web
   - Deshabilitar protocolos inseguros (TLS 1.0, 1.1)
   - Implementar network segmentation (si aplica)

3. **Hardening de Aplicaciones**
   - Ejecutar con usuarios no privilegiados
   - Configurar permisos mínimos necesarios
   - Habilitar logging de aplicaciones
   - Configurar rate limiting (si aplica)
   - Validar dependencies sin vulnerabilidades conocidas

4. **Configuración de Acceso**
   - Implementar autenticación SSH key-based
   - Deshabilitar password authentication
   - Configurar sudo con logging
   - Implementar principle of least privilege
   - Rotar credenciales iniciales

5. **Habilitar Logging y Auditing**
   - Configurar system logging (syslog)
   - Habilitar audit logging (auditd)
   - Configurar log retention policies
   - Enviar logs a repositorio central (si aplica)
   - Configurar alertas básicas

6. **Documentar Baseline de Seguridad**
   - Registrar configuraciones aplicadas
   - Documentar excepciones (si las hay)
   - Crear checklist de hardening
   - Guardar evidencia de compliance

**Criterios de Salida**:
- [ ] Checklist de hardening completado
- [ ] Todos los servicios innecesarios deshabilitados
- [ ] Firewall configurado y activo
- [ ] Logging habilitado y funcional
- [ ] Baseline documentado
- [ ] No vulnerabilidades críticas detectadas

**Procedimientos Relacionados**:
- PROCED-HARDENING-LINUX-001
- PROCED-CONFIGURAR-FIREWALL-001
- PROCED-CONFIGURAR-SSH-SEGURO-001
- PROCED-HABILITAR-LOGGING-001

---

### ETAPA 3: SCANNING DE VULNERABILIDADES

**Objetivo**: Detectar vulnerabilidades en infraestructura

**Duración estimada**: 1-2 horas (automatizado)

**Actividades**:

1. **Preparar Scanning**
   - Actualizar base de datos de vulnerabilidades
   - Definir scope de scanning
   - Programar scanning en horario apropiado
   - Configurar credenciales (si authenticated scan)

2. **Ejecutar Scans Automáticos**
   - **OS Vulnerability Scan**: Detectar CVEs en OS
   - **Application Dependency Scan**: Vulnerabilidades en packages
   - **Container Image Scan**: Vulnerabilidades en Docker images
   - **Configuration Scan**: Misconfigurations de seguridad
   - **Network Scan**: Puertos abiertos, servicios expuestos

3. **Analizar Resultados**
   - Categorizar vulnerabilidades por severidad
   - Identificar falsos positivos
   - Priorizar remediaciones
   - Documentar vulnerabilidades aceptadas (risk acceptance)

4. **Generar Reporte**
   - Resumen ejecutivo de hallazgos
   - Detalle de vulnerabilidades críticas/altas
   - Recomendaciones de remediación
   - Timeline de remediación propuesto
   - Comparación con scan anterior (trend)

**Criterios de Salida**:
- [ ] Scans ejecutados sin errores
- [ ] Resultados analizados y categorizados
- [ ] Vulnerabilidades críticas identificadas
- [ ] Reporte de vulnerabilidades generado
- [ ] Plan de remediación creado

**Procedimientos Relacionados**:
- PROCED-EJECUTAR-VULNERABILITY-SCAN-001
- PROCED-ANALIZAR-RESULTADOS-SCAN-001
- PROCED-GENERAR-REPORTE-VULNERABILIDADES-001

---

### ETAPA 4: REMEDIACION DE VULNERABILIDADES

**Objetivo**: Corregir vulnerabilidades detectadas

**Duración estimada**: Variable (1 hora - 1 semana según severidad)

**Actividades**:

1. **Priorizar Remediaciones**
   - Críticas: Remediar en 24-48 horas
   - Altas: Remediar en 1 semana
   - Medias: Remediar en 1 mes
   - Bajas: Remediar en próximo maintenance window

2. **Aplicar Parches de Seguridad**
   - Actualizar OS packages vulnerables
   - Actualizar application dependencies
   - Reconstruir container images con fixes
   - Aplicar configuration fixes

3. **Validar Remediaciones**
   - Re-ejecutar vulnerability scan
   - Verificar vulnerabilidad ya no presente
   - Validar funcionalidad no afectada
   - Documentar remediación aplicada

4. **Manejar Excepciones**
   - Documentar vulnerabilidades no remediables
   - Justificar risk acceptance
   - Implementar compensating controls
   - Obtener aprobación de Security Lead
   - Programar revisión futura

5. **Actualizar Documentación**
   - Registrar remediaciones aplicadas
   - Actualizar baseline de seguridad
   - Documentar lecciones aprendidas
   - Actualizar procedimientos (si necesario)

**Criterios de Salida**:
- [ ] Vulnerabilidades críticas y altas remediadas
- [ ] Validation scan confirmó remediación
- [ ] Excepciones formalmente aceptadas
- [ ] Documentación actualizada
- [ ] Funcionalidad del sistema verificada

**Procedimientos Relacionados**:
- PROCED-APLICAR-PARCHES-SEGURIDAD-001
- PROCED-RISK-ACCEPTANCE-001
- PROCED-VALIDAR-REMEDIACION-001

---

### ETAPA 5: AUDITORIA DE CONFIGURACION

**Objetivo**: Verificar compliance con políticas de seguridad

**Duración estimada**: 2-4 horas (mensual)

**Actividades**:

1. **Auditoría Automatizada**
   - Ejecutar configuration compliance scans
   - Verificar CIS Benchmarks (si aplica)
   - Validar configuraciones de firewall
   - Revisar permisos de archivos críticos
   - Verificar logging habilitado

2. **Auditoría Manual**
   - Revisar usuarios y grupos
   - Verificar SSH configurations
   - Revisar servicios activos
   - Validar configuraciones SSL/TLS
   - Revisar scheduled tasks/cron jobs

3. **Revisar Access Controls**
   - Listar usuarios con acceso privilegiado
   - Verificar cuentas inactivas (desactivar)
   - Revisar SSH keys autorizadas
   - Validar principio de least privilege
   - Verificar MFA habilitado (si aplica)

4. **Revisar Logs de Auditoría**
   - Analizar logs de acceso sospechosos
   - Revisar cambios de configuración
   - Identificar actividades anómalas
   - Verificar completitud de logs

5. **Generar Reporte de Auditoría**
   - Listar configuraciones no conformes
   - Documentar hallazgos por severidad
   - Recomendar acciones correctivas
   - Comparar con auditoría anterior
   - Calcular compliance score

**Criterios de Salida**:
- [ ] Auditoría completada según checklist
- [ ] Reporte de auditoría generado
- [ ] Issues críticos identificados
- [ ] Plan de acción definido
- [ ] Compliance score calculado

**Procedimientos Relacionados**:
- PROCED-AUDITORIA-CONFIGURACION-001
- PROCED-REVISAR-ACCESS-CONTROLS-001
- PROCED-ANALIZAR-LOGS-AUDITORIA-001

---

### ETAPA 6: RESPUESTA A INCIDENTES DE SEGURIDAD

**Objetivo**: Responder efectivamente a incidentes de seguridad

**Duración estimada**: Variable (1 hora - varios días)

**Actividades**:

1. **Detección y Clasificación**
   - Identificar incidente de seguridad
   - Clasificar severidad (Crítico/Alto/Medio/Bajo)
   - Determinar scope e impacto
   - Notificar a stakeholders apropiados
   - Activar incident response team

2. **Contención**
   - Aislar sistemas afectados (si necesario)
   - Bloquear acceso malicioso
   - Preservar evidencia
   - Implementar workarounds temporales
   - Prevenir propagación

3. **Investigación**
   - Analizar logs de sistema
   - Identificar root cause
   - Determinar alcance del compromiso
   - Identificar datos/sistemas afectados
   - Documentar timeline de eventos

4. **Erradicación**
   - Eliminar malware/backdoors
   - Cerrar vector de ataque
   - Aplicar patches necesarios
   - Rotar credenciales comprometidas
   - Validar sistema limpio

5. **Recuperación**
   - Restaurar sistemas desde backup (si necesario)
   - Validar integridad de sistemas
   - Monitorear actividad post-incidente
   - Comunicar resolución a stakeholders
   - Retornar a operaciones normales

6. **Post-Mortem y Lecciones Aprendidas**
   - Documentar incidente completo
   - Analizar qué funcionó/qué no
   - Identificar mejoras al proceso
   - Actualizar políticas/procedimientos
   - Comunicar lecciones al equipo

**Criterios de Salida**:
- [ ] Incidente contenido y erradicado
- [ ] Sistemas recuperados y validados
- [ ] Incident report documentado
- [ ] Lecciones aprendidas capturadas
- [ ] Mejoras al proceso implementadas
- [ ] Stakeholders notificados

**Procedimientos Relacionados**:
- PROCED-INCIDENT-DETECTION-001
- PROCED-INCIDENT-RESPONSE-001
- PROCED-FORENSICS-ANALYSIS-001
- PROCED-POST-MORTEM-001

---

### ETAPA 7: MEJORA CONTINUA Y ACTUALIZACION

**Objetivo**: Mantener postura de seguridad actualizada

**Duración estimada**: Continuo (revisión trimestral)

**Actividades**:

1. **Revisión Trimestral de Políticas**
   - Revisar políticas de seguridad actuales
   - Evaluar efectividad de controles
   - Identificar gaps de seguridad
   - Actualizar políticas según amenazas emergentes
   - Obtener aprobación de cambios

2. **Actualización de Baselines**
   - Revisar hardening baselines
   - Incorporar nuevos benchmarks (CIS updates)
   - Actualizar procedimientos de hardening
   - Validar compatibilidad con nueva tecnología

3. **Training y Awareness**
   - Capacitar equipo en nuevas amenazas
   - Comunicar cambios a políticas
   - Realizar security awareness sessions
   - Evaluar conocimiento del equipo

4. **Evaluación de Herramientas**
   - Revisar efectividad de tools actuales
   - Evaluar nuevas herramientas de seguridad
   - Planear upgrades o migraciones
   - Optimizar uso de herramientas existentes

5. **Métricas y Reporting**
   - Revisar métricas de seguridad del trimestre
   - Identificar tendencias
   - Reportar a management
   - Definir objetivos para próximo trimestre

6. **Pentesting y Red Team (Opcional)**
   - Planear ejercicios de pentesting
   - Contratar terceros (si presupuesto)
   - Ejecutar internal red team exercises
   - Documentar hallazgos y remediar

**Criterios de Salida**:
- [ ] Políticas revisadas y actualizadas
- [ ] Baselines de seguridad actualizados
- [ ] Equipo capacitado en cambios
- [ ] Métricas reportadas a management
- [ ] Plan de mejora definido para próximo trimestre

**Procedimientos Relacionados**:
- PROCED-REVISAR-POLITICAS-SEGURIDAD-001
- PROCED-SECURITY-TRAINING-001
- PROCED-PENTESTING-001

---

## DIAGRAMA DE FLUJO

```
┌─────────────────────────────────────────────────────────────────────┐
│         HARDENING Y SEGURIDAD DE INFRAESTRUCTURA - FLUJO            │
└─────────────────────────────────────────────────────────────────────┘

                    [Nueva Infraestructura / Trigger]
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 1: POLITICAS      │
                    │ - Definir políticas     │
                    │ - Aprobar y comunicar   │
                    │ - Documentar            │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 2: HARDENING      │
                    │ - Harden OS             │
                    │ - Configurar firewall   │
                    │ - Habilitar logging     │
                    │ - Configurar acceso     │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 3: SCANNING       │
                    │ - Vulnerability scan    │
                    │ - Config scan           │
                    │ - Analizar resultados   │
                    │ - Generar reporte       │
                    └─────────────────────────┘
                                  │
                        ¿Vulnerabilidades?
                        ├─ NO ──► Continuar a ETAPA 5
                        │
                        └─ SÍ ──► Continuar
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 4: REMEDIACION    │
                    │ - Priorizar             │
                    │ - Aplicar parches       │
                    │ - Validar fixes         │
                    │ - Documentar            │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 5: AUDITORIA      │
                    │ - Config compliance     │
                    │ - Access controls       │
                    │ - Revisar logs          │
                    │ - Generar reporte       │
                    └─────────────────────────┘
                                  │
                        ¿Incidente detectado?
                        ├─ NO ──► Continuar a ETAPA 7
                        │
                        └─ SÍ ──► Continuar
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 6: INCIDENT       │
                    │ - Contener              │
                    │ - Investigar            │
                    │ - Erradicar             │
                    │ - Recuperar             │
                    │ - Post-mortem           │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 7: MEJORA         │
                    │ - Revisar políticas     │
                    │ - Actualizar baselines  │
                    │ - Training              │
                    │ - Reportar métricas     │
                    └─────────────────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
              Ciclo continuo            Nueva infraestructura
                    │                           │
                    └───► Volver a ETAPA 3      └──► Volver a ETAPA 2
                          (mensual)                  (por sistema)
```

---

## CRITERIOS DE ENTRADA Y SALIDA POR ETAPA

| Etapa | Criterio de Entrada | Criterio de Salida |
|-------|---------------------|-------------------|
| 1. Políticas | Inicio de proceso | Políticas aprobadas, comunicadas |
| 2. Hardening | Nueva infraestructura | Baseline aplicado, documentado |
| 3. Scanning | Infra hardened o auditoría programada | Vulnerabilities identificadas |
| 4. Remediación | Vulnerabilidades detectadas | Vulnerabilidades críticas resueltas |
| 5. Auditoría | Auditoría programada | Compliance verificado, reportado |
| 6. Incident Response | Incidente detectado | Incidente resuelto, documentado |
| 7. Mejora Continua | Revisión trimestral | Políticas actualizadas, equipo capacitado |

---

## METRICAS Y KPIs

### Métricas Principales

| Métrica | Target | Frecuencia | Dueño |
|---------|--------|-----------|-------|
| **Vulnerabilidades Críticas** | 0 | Semanal | DevOps Lead |
| **Tiempo de Remediación (Críticas)** | < 48 horas | Por CVE | DevOps Lead |
| **Compliance Score** | > 95% | Mensual | DevOps Lead |
| **Hardening Coverage** | 100% sistemas | Mensual | DevOps Lead |
| **Incident Response Time** | < 1 hora (detección) | Por incidente | DevOps Lead |
| **Patch Lag (Security)** | < 7 días | Mensual | DevOps Lead |

### Métricas Secundarias

- Número de vulnerabilidades por severidad (Critical/High/Medium/Low)
- Porcentaje de falsos positivos en scans
- Número de auditorías completadas vs programadas
- Tiempo promedio de remediación por severidad
- Número de incidentes de seguridad por trimestre
- Cobertura de logging y monitoring
- Número de excepciones de seguridad activas

### Reporte Mensual

Incluir:
- Total de vulnerabilidades detectadas y remediadas
- Compliance score y trend
- Incidentes de seguridad (si los hubo)
- Tiempo promedio de remediación
- Issues pendientes y plan de acción
- Recomendaciones de mejora

---

## HERRAMIENTAS Y TECNOLOGIAS

### Vulnerability Scanning

- **OpenVAS / Greenbone**: Vulnerability scanning open-source
- **Trivy**: Container image y filesystem scanning
- **OWASP Dependency-Check**: Application dependency scanning
- **npm audit / pip-audit**: Language-specific scanners

### Configuration Auditing

- **Lynis**: System hardening auditing tool
- **OpenSCAP**: Security compliance validation
- **CIS-CAT**: CIS Benchmarks assessment
- **Ansible + Inspec**: Configuration as code auditing

### Hardening

- **ufw / iptables**: Firewall configuration
- **fail2ban**: Intrusion prevention
- **auditd**: Linux auditing system
- **SSH hardening**: Secure SSH configuration

### Logging y Monitoring

- **rsyslog / syslog-ng**: Log aggregation
- **Logwatch**: Log analysis and reporting
- **OSSEC / Wazuh**: Security monitoring (opcional)

### Incident Response

- **Logs centralizados**: Análisis de incidentes
- **Git**: Versionado de configuraciones
- **Documentation**: Runbooks de incident response

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: Vulnerabilidad Crítica con 0-Day Exploit

**Trigger**: CVE crítico publicado con exploit activo en wild

**Acciones**:
- ETAPA 4 (Remediación) en modo urgente
- Notificación inmediata a todo el equipo
- Evaluación de impact en 1 hora
- Patch o workaround aplicado en 24 horas
- Comunicación a management
- Post-mortem obligatorio

**Tiempo esperado**: < 24 horas desde publicación de CVE

---

### Caso 2: Incidente de Seguridad Crítico

**Trigger**: Compromiso confirmado de infraestructura

**Acciones**:
- Activar ETAPA 6 (Incident Response) inmediatamente
- Aislar sistemas afectados
- Notificar a Security Lead y management
- Preservar evidencia forense
- Considerar involucrar terceros (forensics)
- Comunicación externa (si data breach)

**Tiempo de respuesta**: < 1 hora desde detección

---

### Caso 3: Compliance Audit Externa

**Trigger**: Auditoría de terceros programada

**Acciones**:
- Ejecutar ETAPA 5 (Auditoría) exhaustiva previamente
- Remediar todos los issues identificados
- Preparar evidencia de compliance
- Coordinar con auditores
- Documentar todos los controles
- Remediar hallazgos de auditoría en timeline acordado

---

### Caso 4: Nueva Amenaza Emergente

**Trigger**: Nueva clase de amenaza publicada (ej: Log4Shell)

**Acciones**:
- Evaluación de impact inmediata
- Actualizar ETAPA 3 (Scanning) para detectar
- Comunicar a equipo proactivamente
- Aplicar mitigations disponibles
- Actualizar políticas (ETAPA 1)
- Documentar en knowledge base

---

### Caso 5: Excepción a Política de Seguridad

**Trigger**: Developer solicita excepción a política

**Acciones**:
- Evaluar justificación de excepción
- Identificar riesgo introducido
- Definir compensating controls
- Obtener aprobación de Security Lead
- Documentar excepción formalmente
- Establecer fecha de expiración
- Revisar excepción periódicamente

---

## INTERACCION CON OTROS PROCESOS

```
PROC-INFRA-003 (Este proceso)
       │
       ├─► PROC-INFRA-001 (Gestión de VMs)
       │      └─ Hardening aplicado a nuevas VMs
       │
       ├─► PROC-INFRA-002 (DevContainers)
       │      └─ Security scanning de images
       │
       ├─► PROC-INFRA-004 (Backup y Recuperación)
       │      └─ Backup antes de cambios de seguridad
       │
       ├─► PROC-INFRA-005 (Monitoreo)
       │      └─ Alertas de seguridad
       │
       ├─► PROC-INCIDENT-MGMT-001 (Por crear)
       │      └─ Incident response coordinado
       │
       └─► PROC-COMPLIANCE-001 (Por crear)
              └─ Evidencia de compliance
```

---

## CONTROLES Y VALIDACIONES

### Controles Técnicos Implementados

1. **Preventivos**
   - Firewalls activos
   - SSH key-based authentication
   - Principle of least privilege
   - Network segmentation
   - Input validation

2. **Detectivos**
   - Vulnerability scanning
   - Log monitoring
   - Configuration auditing
   - Intrusion detection
   - File integrity monitoring

3. **Correctivos**
   - Patch management
   - Incident response procedures
   - Backup y recovery
   - Automated remediation (donde posible)

### Validaciones Periódicas

| Validación | Frecuencia | Responsable |
|------------|-----------|-------------|
| Vulnerability Scan | Semanal | DevOps Lead |
| Configuration Audit | Mensual | DevOps Lead |
| Access Control Review | Mensual | DevOps Lead |
| Log Review | Semanal | DevOps Lead |
| Policy Review | Trimestral | Security Lead |
| Penetration Test | Anual (opcional) | Security Lead |

---

## TROUBLESHOOTING

### Problema: False Positives en Vulnerability Scan

**Causas comunes**:
- Scanner desactualizado
- Configuración específica no detectada
- Vulnerability ya mitigada pero scan no lo detecta

**Solución**:
1. Verificar versión de scanner actualizada
2. Validar manualmente la vulnerabilidad
3. Documentar false positive
4. Actualizar scanner configuration
5. Suprimir false positive en futuras scans

---

### Problema: Compliance Score Bajo

**Causas comunes**:
- Configuraciones no conformes
- Políticas no aplicadas consistentemente
- Drift de configuración

**Solución**:
1. Revisar reporte de auditoría detalladamente
2. Priorizar remediaciones por impacto
3. Aplicar configuraciones faltantes
4. Automatizar compliance checks (Ansible)
5. Re-ejecutar auditoría para validar

---

### Problema: Patch Rompe Funcionalidad

**Causas comunes**:
- Breaking change en patch
- Incompatibilidad con configuración actual
- Dependency conflict

**Solución**:
1. Rollback patch inmediatamente
2. Analizar release notes del patch
3. Probar patch en ambiente de testing
4. Implementar workaround temporal
5. Planear aplicación con downtime programado

---

## MEJORA CONTINUA

### Retrospectivas Post-Incidente

**Participantes**: DevOps Lead + Security Lead + Affected Developers

**Agenda**:
1. Timeline de eventos del incidente
2. Qué funcionó bien en la respuesta
3. Qué pudo mejorarse
4. Cambios a políticas/procedimientos
5. Action items con responsables

---

### Revisión Trimestral del Proceso

**Por realizar**: Cada 3 meses (próxima: 2026-02-18)

**Verificar**:
- Efectividad de controles de seguridad
- Métricas de seguridad y trends
- Nuevas amenazas y vulnerabilidades
- Feedback del equipo sobre políticas
- Actualizaciones a estándares (CIS, OWASP)
- Actualizar proceso según aprendizajes

---

## REFERENCIAS Y GUIAS

- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [Linux Hardening Guide](https://github.com/trimstray/the-practical-linux-hardening-guide)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [SSH Hardening Guide](https://www.ssh.com/academy/ssh/security)

---

## HISTORIAL DE CAMBIOS

### v1.0.0 (2025-11-18)

- Versión inicial del proceso
- Definición de 7 etapas del flujo
- Roles y responsabilidades establecidos
- Métricas y KPIs definidos
- Controles técnicos documentados
- Casos especiales incluidos
- Diagrama de flujo y troubleshooting

**Creado por**: Claude Code (Sonnet 4.5)
**Técnica de prompting**: Auto-CoT + Template-based
**Estado**: Activo (aprobación pendiente)

---

**Próxima revisión**: 2026-02-18 (3 meses)
**Responsable de revisión**: DevOps Lead + Security Lead
**Aprobación pendiente**: CISO, CTO, Compliance Officer
