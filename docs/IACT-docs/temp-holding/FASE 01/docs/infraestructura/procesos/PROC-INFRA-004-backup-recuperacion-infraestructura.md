---
id: PROC-INFRA-004
tipo: proceso
categoria: infraestructura
subcategoria: backup_recovery
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Sonnet 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-INFRA-001", "PROC-INFRA-003", "PROC-DR-001"]
---

# PROCESO: Backup y Recuperación de Infraestructura

## Objetivo

Definir el flujo completo de respaldo de configuraciones de infraestructura, datos críticos y procedimientos de recuperación ante desastres en el proyecto IACT, asegurando continuidad del negocio, minimización de pérdida de datos (RPO) y tiempo de recuperación aceptable (RTO) en caso de fallas.

---

## Propósito (QUE)

Establecer un proceso formal y controlado para:

1. **Identificar** activos críticos que requieren backup
2. **Planificar** estrategias de backup según criticidad
3. **Ejecutar** backups automatizados y manuales
4. **Validar** integridad y completitud de backups
5. **Almacenar** backups de forma segura y redundante
6. **Recuperar** sistemas desde backups cuando sea necesario
7. **Probar** procedimientos de recuperación periódicamente

Este es un proceso de **nivel estratégico/operativo** (alto nivel). Para detalles de implementación (COMO), ver procedimientos relacionados.

---

## Alcance

### Incluye

- **Configuraciones de infraestructura**: Vagrantfiles, devcontainer configs, scripts
- **Datos de desarrollo**: Bases de datos locales, archivos de configuración
- **Código fuente**: Repositorios Git (estrategia de backup)
- **Snapshots de VMs**: Estado completo de máquinas virtuales
- **Container images**: Docker images críticos
- **Documentación**: Wikis, procedimientos, ADRs
- **Credenciales**: Backups encriptados de secretos
- **Logs críticos**: Logs de auditoría e incidentes

### NO Incluye

- **Datos de producción**: Ver PROC-BACKUP-PROD-001 (por crear)
- **Backup de datos de usuario**: Responsabilidad individual
- **Disaster Recovery de datacenter**: Fuera de alcance (infraestructura local)
- **Business Continuity Planning**: Ver PROC-BCP-001 (por crear)
- **Archivado a largo plazo**: Ver PROC-ARCHIVAL-001 (por crear)

---

## Roles y Responsabilidades

### DevOps Lead (Backup Administrator)

**Responsabilidades**:
- Definir estrategia de backup para la infraestructura
- Implementar y mantener sistemas de backup
- Ejecutar backups manuales (cuando necesario)
- Validar backups periódicamente
- Gestionar storage de backups
- Ejecutar procedimientos de recuperación
- Documentar y actualizar runbooks
- Monitorear éxito/fallo de backups automatizados
- Reportar métricas de backup/recovery

**Frecuencia**: Continua

---

### Developer (Usuario de Infraestructura)

**Responsabilidades**:
- Identificar datos críticos en su ambiente
- Solicitar backup de configuraciones específicas
- Validar recuperación de su ambiente (en testing)
- Reportar fallos en backups detectados
- Mantener backups locales de trabajo en progreso

**Frecuencia**: Ocasional

---

### Tech Lead / Infrastructure Manager (Aprobador)

**Responsabilidades**:
- Aprobar estrategia de backup
- Definir RPO/RTO targets por sistema
- Aprobar presupuesto de storage
- Revisar resultados de DR drills
- Aprobar cambios significativos al proceso
- Validar compliance con políticas corporativas

**Frecuencia**: Mensual/Trimestral

---

## Entradas (Inputs)

### Inventario de Activos Críticos

1. **Catálogo de Activos**:
   - Lista de VMs y sus configuraciones
   - DevContainers y Dockerfiles
   - Bases de datos de desarrollo
   - Repositorios de código
   - Documentación crítica
   - Scripts de automatización

2. **Clasificación de Criticidad**:
   - Tier 1 (Crítico): RPO < 1 hora, RTO < 4 horas
   - Tier 2 (Importante): RPO < 24 horas, RTO < 1 día
   - Tier 3 (Regular): RPO < 7 días, RTO < 3 días

3. **Requisitos de Backup**:
   - Frecuencia de backup por activo
   - Retención requerida (días/semanas/meses)
   - Ubicación de storage (local/remoto)
   - Encriptación requerida (sí/no)

### Políticas de Backup

- Políticas de retención de datos
- Estándares de encriptación
- Compliance requirements
- Storage constraints (espacio disponible)

---

## Salidas (Outputs)

### Backups Validados y Disponibles

1. **Backups Completados**:
   - Snapshots de VMs
   - Dumps de bases de datos
   - Archives de configuraciones
   - Exports de containers
   - Copias de repositorios

2. **Metadata de Backups**:
   - Fecha y hora de backup
   - Tamaño del backup
   - Checksum/hash para validación
   - Ubicación de storage
   - Periodo de retención
   - Status de validación

3. **Documentación de Recuperación**:
   - Runbooks de recovery por tipo de activo
   - Procedimientos paso a paso
   - Contactos de escalamiento
   - Tiempos estimados de recuperación
   - Dependencias entre sistemas

4. **Reportes de Backup**:
   - Status de backups diarios/semanales
   - Fallos y resoluciones
   - Métricas de RPO/RTO
   - Storage utilizado vs disponible
   - Resultados de validaciones

---

## FLUJO DEL PROCESO

### ETAPA 1: PLANIFICACION DE ESTRATEGIA DE BACKUP

**Objetivo**: Definir estrategia de backup alineada con objetivos del negocio

**Duración estimada**: 1-2 semanas (inicial), revisión trimestral

**Actividades**:

1. **Identificar Activos Críticos**
   - Inventariar toda la infraestructura
   - Consultar con stakeholders sobre criticidad
   - Clasificar activos por tier (1/2/3)
   - Documentar dependencias entre sistemas

2. **Definir RPO y RTO por Activo**
   - **RPO (Recovery Point Objective)**: Máxima pérdida de datos aceptable
   - **RTO (Recovery Time Objective)**: Tiempo máximo de recuperación
   - Balancear requisitos vs costo de storage
   - Obtener aprobación de Tech Lead

3. **Seleccionar Estrategia de Backup**
   - **Full backups**: Backup completo del activo
   - **Incremental backups**: Solo cambios desde último backup
   - **Differential backups**: Cambios desde último full backup
   - **Snapshot-based**: Point-in-time snapshots (VMs, containers)
   - **Continuous replication**: Para tier 1 crítico

4. **Definir Políticas de Retención**
   - Diarios: Retener 7 días
   - Semanales: Retener 4 semanas
   - Mensuales: Retener 12 meses
   - Anuales: Retener 7 años (compliance)
   - Ajustar según requisitos específicos

5. **Seleccionar Ubicaciones de Storage**
   - Local storage: Backups rápidos, recovery local
   - Network storage (NAS): Backups centralizados
   - Cloud storage: Offsite backups, DR
   - Implementar regla 3-2-1 (3 copias, 2 medios, 1 offsite)

6. **Documentar Estrategia**
   - Crear matriz de backup por activo
   - Documentar RPO/RTO targets
   - Definir schedule de backups
   - Aprobar con Tech Lead

**Criterios de Salida**:
- [ ] Activos críticos identificados y clasificados
- [ ] RPO/RTO definidos por tier
- [ ] Estrategia de backup documentada
- [ ] Políticas de retención aprobadas
- [ ] Storage locations seleccionadas
- [ ] Presupuesto aprobado (si aplica)

**Procedimientos Relacionados**:
- PROCED-CLASIFICAR-ACTIVOS-BACKUP-001
- PROCED-DEFINIR-RPO-RTO-001
- PROCED-SELECCIONAR-ESTRATEGIA-BACKUP-001

---

### ETAPA 2: IMPLEMENTACION DE SISTEMA DE BACKUP

**Objetivo**: Implementar infraestructura y automatización de backups

**Duración estimada**: 1-2 semanas

**Actividades**:

1. **Preparar Infraestructura de Storage**
   - Provisionar storage local/remoto
   - Configurar permisos de acceso
   - Configurar encriptación en storage
   - Validar capacidad suficiente

2. **Implementar Herramientas de Backup**
   - Instalar software de backup (rsync, borgbackup, etc.)
   - Configurar credenciales de acceso
   - Configurar logging de operaciones
   - Configurar notificaciones de fallos

3. **Crear Scripts de Backup Automatizados**
   - Script de backup de VMs (Vagrant snapshots)
   - Script de backup de bases de datos (pg_dump, mysqldump)
   - Script de backup de configuraciones (tar/zip)
   - Script de backup de containers (docker save)
   - Incluir validación de checksums

4. **Configurar Scheduling**
   - Configurar cron jobs para backups automatizados
   - Distribuir backups para evitar contención
   - Configurar backups nocturnos (menos impacto)
   - Implementar retry logic en fallos

5. **Implementar Encriptación**
   - Encriptar backups en tránsito (TLS)
   - Encriptar backups en reposo (AES-256)
   - Gestionar claves de encriptación de forma segura
   - Documentar procedimiento de decryption

6. **Configurar Monitoreo y Alertas**
   - Monitorear éxito/fallo de backups
   - Alertar en fallos consecutivos
   - Monitorear storage disponible
   - Alertar cuando storage < 20% libre

**Criterios de Salida**:
- [ ] Storage de backups configurado
- [ ] Herramientas de backup instaladas
- [ ] Scripts automatizados creados y probados
- [ ] Scheduling configurado y activo
- [ ] Encriptación implementada
- [ ] Monitoreo y alertas funcionando

**Procedimientos Relacionados**:
- PROCED-CONFIGURAR-STORAGE-BACKUP-001
- PROCED-CREAR-SCRIPTS-BACKUP-001
- PROCED-CONFIGURAR-ENCRIPTACION-BACKUP-001
- PROCED-CONFIGURAR-MONITOREO-BACKUP-001

---

### ETAPA 3: EJECUCION DE BACKUPS

**Objetivo**: Ejecutar backups según schedule definido

**Duración estimada**: Continuo (automatizado)

**Actividades**:

1. **Backups Automatizados Diarios**
   - Ejecutados por cron según schedule
   - Backup incremental de configuraciones
   - Backup de bases de datos de desarrollo
   - Backup de logs críticos
   - Snapshot de VMs tier 1 (si aplica)

2. **Backups Semanales**
   - Full backup de configuraciones
   - Snapshot completo de VMs principales
   - Export de container images
   - Backup de documentación

3. **Backups Manuales (Ad-hoc)**
   - Antes de cambios significativos
   - Antes de upgrades de sistemas
   - Antes de migraciones
   - Por solicitud de developer

4. **Registro de Metadata**
   - Registrar fecha/hora de backup
   - Calcular y guardar checksum
   - Registrar tamaño del backup
   - Anotar ubicación de storage
   - Calcular fecha de expiración (retention)

5. **Limpieza de Backups Antiguos**
   - Eliminar backups expirados según retention policy
   - Mantener al menos 1 backup válido siempre
   - Liberar storage de backups viejos
   - Logging de eliminaciones

**Criterios de Salida**:
- [ ] Backups ejecutados según schedule
- [ ] Metadata completa registrada
- [ ] Checksums calculados y guardados
- [ ] Backups antiguos limpiados
- [ ] Logs de operaciones completos

**Procedimientos Relacionados**:
- PROCED-EJECUTAR-BACKUP-MANUAL-001
- PROCED-BACKUP-VM-VAGRANT-001
- PROCED-BACKUP-DATABASE-001
- PROCED-BACKUP-CONFIGURACIONES-001
- PROCED-LIMPIAR-BACKUPS-ANTIGUOS-001

---

### ETAPA 4: VALIDACION DE BACKUPS

**Objetivo**: Verificar integridad y recuperabilidad de backups

**Duración estimada**: 1-2 horas (semanal)

**Actividades**:

1. **Validación de Integridad**
   - Verificar checksums de backups
   - Validar que archivos no están corruptos
   - Verificar tamaño esperado de backups
   - Detectar backups incompletos

2. **Pruebas de Recuperación (Sampling)**
   - Seleccionar muestra de backups (10-20%)
   - Intentar recuperación en ambiente de testing
   - Validar datos recuperados correctamente
   - Medir tiempo de recuperación (validar RTO)
   - Documentar resultados

3. **Validación de Metadata**
   - Verificar metadata completa para todos los backups
   - Validar fechas de expiración correctas
   - Verificar ubicaciones de storage accesibles
   - Validar permisos de acceso

4. **Reporte de Validación**
   - Documentar backups validados
   - Reportar fallos encontrados
   - Registrar tiempos de recuperación
   - Identificar gaps o problemas

5. **Remediar Issues Encontrados**
   - Re-ejecutar backups fallidos
   - Corregir scripts con problemas
   - Reparar archivos corruptos (si posible)
   - Escalar issues críticos

**Criterios de Salida**:
- [ ] Integridad de backups verificada
- [ ] Sampling de recuperación exitoso
- [ ] Metadata validada
- [ ] Reporte de validación generado
- [ ] Issues remediados o escalados

**Procedimientos Relacionados**:
- PROCED-VALIDAR-INTEGRIDAD-BACKUP-001
- PROCED-PROBAR-RECUPERACION-BACKUP-001
- PROCED-REPORTAR-VALIDACION-BACKUP-001

---

### ETAPA 5: ALMACENAMIENTO Y GESTION

**Objetivo**: Gestionar storage de backups eficientemente

**Duración estimada**: Continuo

**Actividades**:

1. **Monitoreo de Storage**
   - Monitorear espacio utilizado vs disponible
   - Predecir crecimiento de storage
   - Alertar cuando storage < 20% libre
   - Identificar backups que consumen más espacio

2. **Optimización de Storage**
   - Comprimir backups (gzip, bzip2)
   - Deduplicar datos (si herramienta lo soporta)
   - Mover backups antiguos a cold storage
   - Revisar retention policies (ajustar si necesario)

3. **Gestión de Ciclo de Vida**
   - Aplicar retention policies automáticamente
   - Migrar backups entre tiers de storage
   - Archivar backups de compliance
   - Eliminar backups expirados de forma segura

4. **Seguridad de Backups**
   - Verificar encriptación activa
   - Auditar acceso a backups
   - Gestionar rotación de claves de encriptación
   - Implementar access controls estrictos

5. **Disaster Recovery Offsite**
   - Replicar backups críticos a ubicación remota
   - Validar conectividad a offsite storage
   - Probar recuperación desde offsite
   - Mantener inventario de backups offsite

**Criterios de Salida**:
- [ ] Storage monitoreado y optimizado
- [ ] Retention policies aplicadas
- [ ] Backups seguros y encriptados
- [ ] Replicación offsite funcionando
- [ ] Storage suficiente disponible

**Procedimientos Relacionados**:
- PROCED-MONITOREAR-STORAGE-BACKUP-001
- PROCED-OPTIMIZAR-STORAGE-BACKUP-001
- PROCED-REPLICAR-BACKUP-OFFSITE-001

---

### ETAPA 6: RECUPERACION DESDE BACKUP

**Objetivo**: Recuperar sistemas desde backup cuando sea necesario

**Duración estimada**: Variable (según RTO)

**Actividades**:

1. **Detección de Necesidad de Recovery**
   - Sistema falla o datos perdidos
   - Corrupción de datos detectada
   - Malware o compromiso de seguridad
   - Solicitud de rollback de developer
   - Testing de DR procedure

2. **Evaluación de Situación**
   - Determinar scope de pérdida de datos
   - Identificar último backup válido
   - Evaluar tiempo de recovery esperado
   - Notificar a stakeholders
   - Activar procedimiento de recovery

3. **Preparar Ambiente de Recovery**
   - Preparar infraestructura destino
   - Validar recursos suficientes
   - Obtener backup desde storage
   - Verificar integridad del backup (checksum)
   - Decryptar backup (si encriptado)

4. **Ejecutar Recovery**
   - Restaurar VM desde snapshot (si VM)
   - Restaurar database desde dump (si DB)
   - Descomprimir y restaurar archivos
   - Aplicar configuraciones restauradas
   - Validar dependencias

5. **Validación Post-Recovery**
   - Verificar sistema funciona correctamente
   - Validar integridad de datos restaurados
   - Verificar servicios iniciados
   - Probar funcionalidad crítica
   - Comparar con estado esperado

6. **Documentar Recovery**
   - Registrar razón de recovery
   - Documentar pasos ejecutados
   - Anotar tiempo total de recovery (comparar con RTO)
   - Documentar issues encontrados
   - Registrar lecciones aprendidas

**Criterios de Salida**:
- [ ] Sistema recuperado exitosamente
- [ ] Funcionalidad validada
- [ ] RTO cumplido (o documentar desviación)
- [ ] Stakeholders notificados
- [ ] Recovery documentado

**Procedimientos Relacionados**:
- PROCED-RECUPERAR-VM-DESDE-SNAPSHOT-001
- PROCED-RESTAURAR-DATABASE-DESDE-BACKUP-001
- PROCED-RECUPERAR-CONFIGURACIONES-001
- PROCED-VALIDAR-POST-RECOVERY-001

---

### ETAPA 7: DISASTER RECOVERY DRILLS

**Objetivo**: Probar procedimientos de recuperación periódicamente

**Duración estimada**: 4-8 horas (trimestral)

**Actividades**:

1. **Planificar DR Drill**
   - Seleccionar sistemas a incluir en drill
   - Definir escenario de disaster
   - Programar fecha/hora del drill
   - Notificar participantes
   - Preparar ambiente de testing

2. **Ejecutar Drill**
   - Simular fallo del sistema
   - Activar procedimiento de recovery
   - Medir tiempo de recuperación
   - Documentar issues encontrados
   - Validar comunicación entre equipo

3. **Validar Recuperación**
   - Verificar sistema recuperado correctamente
   - Validar RPO (pérdida de datos aceptable)
   - Validar RTO (tiempo de recovery)
   - Probar funcionalidad post-recovery
   - Identificar gaps en procedimiento

4. **Documentar Resultados**
   - Crear reporte de DR drill
   - Documentar métricas (RPO/RTO alcanzados)
   - Listar issues y lecciones aprendidas
   - Identificar mejoras necesarias
   - Asignar action items

5. **Actualizar Procedimientos**
   - Corregir procedimientos basado en aprendizajes
   - Actualizar runbooks de recovery
   - Mejorar automatización (si posible)
   - Actualizar contactos y escalamiento
   - Comunicar cambios al equipo

**Criterios de Salida**:
- [ ] DR drill ejecutado exitosamente
- [ ] Métricas de RPO/RTO validadas
- [ ] Issues identificados y documentados
- [ ] Procedimientos actualizados
- [ ] Action items asignados y trackeados

**Procedimientos Relacionados**:
- PROCED-PLANIFICAR-DR-DRILL-001
- PROCED-EJECUTAR-DR-DRILL-001
- PROCED-DOCUMENTAR-RESULTADOS-DR-DRILL-001

---

## DIAGRAMA DE FLUJO

```
┌─────────────────────────────────────────────────────────────────────┐
│         BACKUP Y RECUPERACION DE INFRAESTRUCTURA - FLUJO            │
└─────────────────────────────────────────────────────────────────────┘

                    [Inicio del Proceso]
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 1: PLANIFICACION  │
                    │ - Identificar activos   │
                    │ - Definir RPO/RTO       │
                    │ - Seleccionar estrategia│
                    │ - Políticas retención   │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 2: IMPLEMENTACION │
                    │ - Preparar storage      │
                    │ - Implementar tools     │
                    │ - Crear scripts         │
                    │ - Configurar scheduling │
                    │ - Configurar monitoreo  │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 3: EJECUCION      │
                    │ - Backups diarios       │
                    │ - Backups semanales     │
                    │ - Backups manuales      │
                    │ - Registro metadata     │
                    │ - Limpieza backups      │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 4: VALIDACION     │
                    │ - Verificar integridad  │
                    │ - Pruebas recovery      │
                    │ - Validar metadata      │
                    │ - Reportar resultados   │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 5: GESTION        │
                    │ - Monitorear storage    │
                    │ - Optimizar storage     │
                    │ - Aplicar retention     │
                    │ - Replicar offsite      │
                    └─────────────────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
              ¿Recovery necesaria?      Operación normal
                    │                           │
                   SÍ                           │
                    │                           │
                    ▼                           │
        ┌─────────────────────────┐             │
        │ ETAPA 6: RECUPERACION   │             │
        │ - Evaluar situación     │             │
        │ - Preparar ambiente     │             │
        │ - Ejecutar recovery     │             │
        │ - Validar recovery      │             │
        │ - Documentar            │             │
        └─────────────────────────┘             │
                    │                           │
                    └───────────┬───────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │ ETAPA 7: DR DRILLS      │
                    │ - Planificar drill      │
                    │ - Ejecutar drill        │
                    │ - Validar recovery      │
                    │ - Documentar resultados │
                    │ - Actualizar procesos   │
                    └─────────────────────────┘
                                  │
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
              Ciclo continuo              Revisión trimestral
                    │                           │
                    └───► Volver a ETAPA 3      └──► Volver a ETAPA 1
                          (diario/semanal)           (ajustar estrategia)
```

---

## CRITERIOS DE ENTRADA Y SALIDA POR ETAPA

| Etapa | Criterio de Entrada | Criterio de Salida |
|-------|---------------------|-------------------|
| 1. Planificación | Inicio del proceso | Estrategia documentada, aprobada |
| 2. Implementación | Estrategia aprobada | Sistema de backup operativo |
| 3. Ejecución | Sistema implementado | Backups completados, metadata registrada |
| 4. Validación | Backups disponibles | Integridad verificada, reporte generado |
| 5. Gestión | Backups activos | Storage optimizado, retention aplicada |
| 6. Recuperación | Fallo detectado o solicitud | Sistema recuperado, validado |
| 7. DR Drills | Programación trimestral | Drill ejecutado, procedimientos actualizados |

---

## METRICAS Y KPIs

### Métricas Principales

| Métrica | Target | Frecuencia | Dueño |
|---------|--------|-----------|-------|
| **Backup Success Rate** | > 99% | Diario | DevOps Lead |
| **RPO Actual vs Target** | 100% cumplimiento | Mensual | DevOps Lead |
| **RTO Actual vs Target** | 100% cumplimiento | Por recovery | DevOps Lead |
| **Backup Validation Rate** | 100% validados (semanal) | Semanal | DevOps Lead |
| **Recovery Success Rate** | 100% | Por recovery | DevOps Lead |
| **Storage Utilization** | < 80% capacidad | Semanal | DevOps Lead |

### Métricas Secundarias

- Tiempo promedio de backup por tipo
- Tamaño promedio de backups
- Tasa de crecimiento de storage
- Número de backups por tier de criticidad
- Frecuencia de recovery requests
- Tiempo promedio de recovery por tipo
- Número de DR drills por año
- Issues encontrados en validaciones

### Reporte Mensual

Incluir:
- Total de backups ejecutados vs programados
- Tasa de éxito de backups
- Storage utilizado y disponible
- Recoveries ejecutadas y resultados
- Validaciones completadas
- Issues y resoluciones
- Recomendaciones de optimización

---

## HERRAMIENTAS Y TECNOLOGIAS

### Backup Tools

- **Vagrant**: Snapshots de VMs (`vagrant snapshot`)
- **rsync**: Backup incremental de archivos
- **Borg Backup**: Deduplicating backup program
- **pg_dump / pg_dumpall**: PostgreSQL backups
- **mysqldump**: MySQL/MariaDB backups
- **tar / gzip**: Archiving y compresión
- **Docker save / export**: Container image backups

### Storage

- **Local disk**: Backups rápidos de corto plazo
- **NAS / Network Storage**: Backups centralizados
- **Cloud Storage**: AWS S3, Google Cloud Storage, Azure Blob (offsite)
- **External drives**: Backups offline

### Automation

- **Cron**: Scheduling de backups automatizados
- **Bash scripts**: Automatización de tareas
- **Ansible**: Backup orchestration (opcional)

### Validation

- **md5sum / sha256sum**: Checksums para validación
- **diff / rsync --dry-run**: Comparación de archivos

### Monitoring

- **Logs**: syslog, custom logs
- **Alerting**: Email, Slack webhooks
- **Disk monitoring**: df, du

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: Recovery Urgente (RTO Crítico)

**Trigger**: Sistema crítico caído, negocio bloqueado

**Acciones**:
- Activar ETAPA 6 (Recuperación) inmediatamente
- Priorizar recovery sobre análisis exhaustivo
- Notificar a management
- Utilizar último backup disponible (aunque no sea el más reciente)
- Documentar decisiones tomadas
- Post-mortem obligatorio después

**Tiempo esperado**: Cumplir RTO target (< 4 horas para tier 1)

---

### Caso 2: Backup Fallido Consecutivo

**Trigger**: 3+ fallos consecutivos de backup para un activo

**Acciones**:
- Alertar a DevOps Lead inmediatamente
- Investigar root cause
- Ejecutar backup manual exitoso
- Corregir script/configuración
- Validar corrección funciona
- Documentar issue y resolución

---

### Caso 3: Storage Crítico (< 10% libre)

**Trigger**: Storage de backups casi lleno

**Acciones**:
- Alertar a DevOps Lead
- Revisar retention policies (reducir si aceptable)
- Eliminar backups más antiguos de lo normal
- Mover backups a cold storage
- Provisionar storage adicional (urgente)
- Revisar crecimiento de datos

---

### Caso 4: Corrupción de Backup Detectada

**Trigger**: Validación detecta backup corrupto

**Acciones**:
- Marcar backup como inválido
- Re-ejecutar backup inmediatamente
- Validar nuevo backup
- Investigar causa de corrupción
- Verificar otros backups del mismo periodo
- Actualizar metadata

---

### Caso 5: DR Drill Falla

**Trigger**: Recovery no funciona durante DR drill

**Acciones**:
- Documentar fallo detalladamente
- Identificar gap en procedimiento
- Corregir procedimiento/script
- Re-ejecutar drill para validar corrección
- Escalar a Tech Lead
- Actualizar runbooks

---

## INTERACCION CON OTROS PROCESOS

```
PROC-INFRA-004 (Este proceso)
       │
       ├─► PROC-INFRA-001 (Gestión de VMs)
       │      └─ Backup de VMs antes de cambios
       │
       ├─► PROC-INFRA-002 (DevContainers)
       │      └─ Backup de configuraciones DevContainer
       │
       ├─► PROC-INFRA-003 (Hardening y Seguridad)
       │      └─ Backup encriptado, secure storage
       │
       ├─► PROC-INFRA-005 (Monitoreo)
       │      └─ Alertas de fallos de backup
       │
       ├─► PROC-INCIDENT-MGMT-001 (Por crear)
       │      └─ Recovery en respuesta a incidentes
       │
       └─► PROC-DR-001 (Disaster Recovery, por crear)
              └─ DR planning y testing
```

---

## CONTROLES Y VALIDACIONES

### Controles Automáticos

1. **Pre-Backup Checks**
   - Verificar storage disponible suficiente
   - Validar permisos de acceso
   - Verificar conectividad a storage remoto

2. **Durante Backup**
   - Calcular checksum durante backup
   - Verificar tamaño de backup esperado
   - Validar compresión/encriptación aplicada

3. **Post-Backup Checks**
   - Verificar backup completado sin errores
   - Validar metadata registrada
   - Confirmar backup accesible en storage
   - Alertar si fallo

### Validaciones Periódicas

| Validación | Frecuencia | Automatizada | Responsable |
|------------|-----------|--------------|-------------|
| Integridad (checksum) | Semanal | Sí | DevOps Lead |
| Sampling recovery test | Semanal | No | DevOps Lead |
| Metadata completa | Semanal | Sí | DevOps Lead |
| Storage disponible | Diario | Sí | DevOps Lead |
| Offsite replication | Semanal | Sí | DevOps Lead |
| DR Drill completo | Trimestral | No | DevOps Lead |

---

## TROUBLESHOOTING

### Problema: Backup Falla con Error de Storage

**Causas comunes**:
- Disk lleno
- Permisos insuficientes
- Storage remoto no accesible

**Solución**:
1. Verificar espacio disponible: `df -h`
2. Limpiar backups antiguos manualmente
3. Verificar permisos de directorio
4. Verificar conectividad a storage remoto
5. Re-ejecutar backup

---

### Problema: Recovery es Más Lento que RTO

**Causas comunes**:
- Backup muy grande
- Network lenta (si remote restore)
- Procedimiento no optimizado

**Solución**:
1. Revisar tamaño de backup (comprimir más)
2. Optimizar network bandwidth
3. Mejorar procedimiento de recovery
4. Considerar recovery incremental
5. Actualizar RTO si no realista

---

### Problema: Checksum Validation Falla

**Causas comunes**:
- Backup corrupto
- Transferencia de network corrupta
- Disk corruption

**Solución**:
1. Re-ejecutar backup inmediatamente
2. Verificar salud de disk (SMART)
3. Probar con backup anterior
4. Investigar logs de errores
5. Escalar si persiste

---

## MEJORA CONTINUA

### Retrospectivas Post-Recovery

**Participantes**: DevOps Lead + Affected Developers + Tech Lead

**Agenda**:
1. Razón de recovery necesaria
2. Efectividad del procedimiento
3. RTO/RPO cumplidos
4. Issues encontrados
5. Mejoras al proceso

---

### Revisión Trimestral del Proceso

**Por realizar**: Cada 3 meses (próxima: 2026-02-18)

**Verificar**:
- Métricas de backup y recovery
- Crecimiento de storage
- Efectividad de retention policies
- Resultados de DR drills
- Nuevas herramientas disponibles
- Actualizar proceso según aprendizajes

---

## REFERENCIAS Y GUIAS

- [3-2-1 Backup Strategy](https://www.backblaze.com/blog/the-3-2-1-backup-strategy/)
- [PostgreSQL Backup and Restore](https://www.postgresql.org/docs/current/backup.html)
- [MySQL Backup and Recovery](https://dev.mysql.com/doc/refman/8.0/en/backup-and-recovery.html)
- [Borg Backup Documentation](https://borgbackup.readthedocs.io/)
- [Vagrant Snapshots](https://www.vagrantup.com/docs/cli/snapshot)
- [Docker Save/Load](https://docs.docker.com/engine/reference/commandline/save/)

---

## HISTORIAL DE CAMBIOS

### v1.0.0 (2025-11-18)

- Versión inicial del proceso
- Definición de 7 etapas del flujo
- Roles y responsabilidades establecidos
- Métricas y KPIs (RPO/RTO) definidos
- Estrategias de backup documentadas
- Casos especiales incluidos
- Diagrama de flujo y troubleshooting

**Creado por**: Claude Code (Sonnet 4.5)
**Técnica de prompting**: Auto-CoT + Template-based
**Estado**: Activo (aprobación pendiente)

---

**Próxima revisión**: 2026-02-18 (3 meses)
**Responsable de revisión**: DevOps Lead + Tech Lead
**Aprobación pendiente**: CTO, Infrastructure Manager
