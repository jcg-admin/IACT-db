---
id: PROC-INFRA-001
tipo: proceso
categoria: infraestructura
subcategoria: vm_management
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-DEVOPS-001", "PROC-GOBERNANZA-VM"]
---

# PROCESO: Gestión de Infraestructura de Máquinas Virtuales (VMs)

## Objetivo

Definir el flujo completo de gestión del ciclo de vida de máquinas virtuales (VMs) en el proyecto IACT, desde su solicitud hasta su descommission, asegurando seguridad, estabilidad, eficiencia de recursos y trazabilidad de cambios.

---

## Propósito (QUÉ)

Establecer un proceso formal y controlado para:

1. **Solicitar** VMs con requisitos claros
2. **Aprobar** solicitudes según políticas de seguridad y recursos
3. **Provisionar** VMs de forma automatizada y consistente
4. **Configurar** con dependencias y servicios requeridos
5. **Validar** funcionalidad y cumplimiento de requisitos
6. **Monitorear** disponibilidad, seguridad y cambios
7. **Descommission** cuando ya no se necesitan

Este es un proceso de **nivel estratégico/operativo** (alto nivel). Para detalles de implementación (CÓMO), ver procedimientos relacionados.

---

## Alcance

### Incluye

- **Máquinas Virtuales Vagrant**: Ambientes de desarrollo local
- **DevContainer Hosts**: Máquinas anfitrionas para DevContainers
- **Ciclo completo**: Solicitud → Provisión → Configuración → Monitoreo → Descommission
- **VMs con diversos SO**: Linux (Ubuntu, Debian, CentOS), Windows (si aplica)
- **Diferentes propósitos**: Desarrollo, testing, CI/CD agents, bases de datos de prueba
- **Gestión de credenciales**: Acceso seguro a VMs
- **Documentación de VMs**: Especificaciones, cambios, ruptura de builds

### NO Incluye

- **Backup y Recuperación de VMs**: Ver PROC-BACKUP-001 (por crear)
- **Disaster Recovery**: Ver PROC-DR-001 (por crear)
- **Gestión de Storage Externo**: Ver PROC-STORAGE-001 (por crear)
- **Monitoreo Detallado**: Ver PROCED-MONITOREO-VMS-001 (procedimiento específico)
- **Tuning de Performance**: Ver PROC-PERFORMANCE-TUNING-001 (por crear)
- **VMs de Producción**: Se gestionan con proceso separado (TBD)

---

## Roles y Responsabilidades

### Developer (Solicitante)

**Responsabilidades**:
- Iniciar solicitud de VM completando requerimientos
- Justificar necesidad de VM
- Especificar recursos necesarios (CPU, RAM, Storage, SO)
- Validar VM aprovisionada en ambiente local
- Reportar problemas encontrados
- Solicitar descommission cuando ya no se necesita

**Frecuencia**: Ocasional (cuando necesita nueva VM)

---

### DevOps Engineer (Ejecutor)

**Responsabilidades**:
- Revisar solicitud de VM (validar requerimientos)
- Provisionar VM usando Vagrant
- Configurar SO y dependencias iniciales
- Validar VM antes de entregar
- Documentar especificaciones finales de VM
- Generar credenciales de acceso
- Monitorear salud de VM (uptime, cambios)
- Ejecutar descommission de VMs
- Mantener inventario de VMs activas
- Actualizar procedimientos según aprendizajes

**Frecuencia**: Contínua

---

### Tech Lead / Infrastructure Manager (Aprobador)

**Responsabilidades**:
- Revisar solicitudes excepcionales (recursos altos, múltiples VMs)
- Aprobar excepciones a políticas
- Revisar y aprobar cambios a este proceso
- Resolver conflicts entre desarrolladores por recursos
- Reportar métricas de uso de VMs
- Planificar capacidad de infraestructura

**Frecuencia**: Según sea necesario (típicamente 1-2 veces por semana)

---

## Entradas (Inputs)

### Solicitud de VM

1. **Formulario de Solicitud** con:
   - Nombre y descripción de la VM
   - SO requerido (Ubuntu 22.04, Debian 12, etc.)
   - Recursos: CPU cores, RAM GB, Disk GB
   - Software a pre-instalar (Python, Node.js, PostgreSQL, etc.)
   - Puertos a exponer (si aplica)
   - Usuario solicitante
   - Propósito/justificación
   - Fecha requerida

2. **Contexto del Proyecto**:
   - Políticas de seguridad de infraestructura
   - Recursos disponibles (máximo por VM)
   - Estándares de naming
   - Lista de software aprobado

3. **Plantillas**:
   - Vagrantfile template
   - Ansible playbooks (si aplica)
   - Health check scripts
   - Documentación template

### Aprobaciones Requeridas

- Validación técnica por DevOps
- Revisión de tech lead (si recursos exceptuales)
- Disponibilidad de recursos

---

## Salidas (Outputs)

### VM Aprovisionada

1. **Máquina Virtual Funcional**:
   - SO instalado y actualizado
   - Dependencias instaladas
   - Servicios configurados
   - Red y puertos configurados
   - Credenciales de acceso generadas

2. **Documentación de VM**:
   - Especificaciones finales (OS, IP, hostname)
   - Credenciales de acceso (usuario/contraseña o SSH keys)
   - Cambios realizados durante configuración
   - Instrucciones de acceso
   - Contacto de responsable (DevOps)

3. **Registro de Provisión**:
   - Fecha de creación
   - Logs de provisión
   - Changelog de configuración
   - Validación completada

4. **Monitoreo Activo**:
   - Health checks automáticos
   - Alertas configuradas
   - Logs centralizados

---

## FLUJO DEL PROCESO

### ETAPA 1: SOLICITUD Y VALIDACIÓN

**Objetivo**: Capturar requerimientos y validar factibilidad

**Duración estimada**: 1-2 horas

**Actividades**:

1. **Developer crea Solicitud**
   - Completa formulario de solicitud
   - Especifica recursos necesarios
   - Justifica propósito de VM
   - Define timeline requerido

2. **DevOps revisa Solicitud**
   - Valida completitud de información
   - Verifica disponibilidad de recursos
   - Identifica software/dependencias especiales
   - Verifica cumplimiento de políticas de seguridad
   - Solicita información adicional si necesario

3. **Estimación de Esfuerzo**
   - Complejidad de provisión (simple/media/compleja)
   - Tiempo estimado de entrega
   - Dependencias con otras VMs

**Criterios de Salida**:
- [ ] Solicitud completa y válida
- [ ] Recursos disponibles confirmados
- [ ] DevOps asignado
- [ ] Timeline acordado con developer

**Procedimientos Relacionados**:
- PROCED-SOLICITAR-VM-001 (cómo llenar formulario)
- PROCED-VALIDAR-SOLICITUD-VM-001 (cómo validar)

---

### ETAPA 2: PROVISIÓN AUTOMATIZADA

**Objetivo**: Crear la VM de forma automatizada y consistente

**Duración estimada**: 30 minutos - 2 horas (según complejidad)

**Actividades**:

1. **Preparar Vagrantfile**
   - Basado en template estándar
   - Definir recursos (CPU, RAM, Disk)
   - Seleccionar box de Vagrant (OS específico)
   - Configurar red (IP, puertos)
   - Preparar scripts de provisión (si aplica)

2. **Provisionar VM**
   - `vagrant up` con Vagrantfile
   - Vagrant crea VM en VirtualBox
   - Aplica provisión inicial (SO updates)
   - Valida conectividad

3. **Validación de Provisión**
   - Verificar VM está en estado "running"
   - Verificar conectividad SSH/RDP
   - Verificar asignación de recursos correcta
   - Revisar logs de provisión (sin errores)

**Criterios de Salida**:
- [ ] VM creada y running
- [ ] Conectividad confirmada
- [ ] Recursos asignados correctamente
- [ ] Sin errores críticos en logs
- [ ] Checkpoint de Vagrant creado (opcional backup)

**Procedimientos Relacionados**:
- PROCED-PROVISIONAR-VM-VAGRANT-001 (ejecución de vagrant)
- PROCED-VALIDAR-PROVISIÓN-VM-001 (verificación)

---

### ETAPA 3: CONFIGURACIÓN INICIAL

**Objetivo**: Instalar SO, dependencias y configurar servicios

**Duración estimada**: 1-4 horas (según software)

**Actividades**:

1. **Actualizar Sistema Operativo**
   - Aplicar parches de seguridad
   - Actualizar paquetes del SO
   - Habilitar firewall básico
   - Configurar NTP (sincronización de hora)

2. **Instalar Dependencias Comunes**
   - Compiladores (gcc, make)
   - Package managers (pip, npm, etc.)
   - Herramientas de desarrollo (git, curl, wget)
   - Docker/Docker-compose (si aplica)

3. **Instalar Software Específico**
   - Lenguajes de programación (Python, Node.js, Java)
   - Bases de datos (PostgreSQL, MySQL, Redis)
   - Servidores (nginx, Apache)
   - Software de la aplicación
   - Herramientas de monitoreo

4. **Configurar Servicios**
   - Iniciar servicios requeridos
   - Habilitar auto-start en boot
   - Configurar puertos
   - Crear usuarios/grupos necesarios

5. **Hardening de Seguridad Básico**
   - Desactivar servicios innecesarios
   - Configurar permisos de archivos
   - Crear cuenta para developer (si aplica)
   - Configurar SSH keys (NO contraseñas)

6. **Documentar Cambios**
   - Registrar cada paso realizado
   - Anotar versiones instaladas
   - Documentar configuraciones especiales

**Criterios de Salida**:
- [ ] SO actualizado y parchado
- [ ] Dependencias instaladas
- [ ] Software funciona correctamente
- [ ] Servicios en auto-start
- [ ] Cambios documentados completamente
- [ ] Permisos y seguridad configurados

**Procedimientos Relacionados**:
- PROCED-ACTUALIZAR-SO-001
- PROCED-INSTALAR-DEPENDENCIAS-001
- PROCED-CONFIGURAR-SERVICIOS-001
- PROCED-HARDENING-VM-001

---

### ETAPA 4: VALIDACIÓN Y TESTING

**Objetivo**: Verificar que VM funciona según requerimientos

**Duración estimada**: 30 minutos - 1 hora

**Actividades**:

1. **Health Checks Automáticos**
   - Script de verificación de servicios
   - Prueba de conectividad a puertos
   - Prueba de acceso de base de datos (si aplica)
   - Validación de espacio en disco

2. **Validación de Software**
   - Verificar versiones instaladas
   - Ejecutar tests básicos (ej: `python --version`)
   - Validar aplicaciones abren correctamente
   - Prueba de comunicación entre servicios

3. **Performance Baseline**
   - Registrar CPU/RAM/Disk libres
   - Registrar velocidad de red
   - Registrar latencia de servicios
   - Crear baseline para futuro monitoreo

4. **Developer Testing (Opcional)**
   - Developer prueba funcionalidad requerida
   - Reporta issues encontrados
   - Propone cambios necesarios

**Criterios de Salida**:
- [ ] Health checks pasan
- [ ] Software verifica correctamente
- [ ] Performance baseline capturado
- [ ] Developer confirma funcionalidad (si aplica)
- [ ] Reporte de validación completado

**Procedimientos Relacionados**:
- PROCED-HEALTH-CHECK-VM-001
- PROCED-PERFORMANCE-BASELINE-001

---

### ETAPA 5: ENTREGA Y DOCUMENTACIÓN

**Objetivo**: Documentar VM y entregar a developer

**Duración estimada**: 30 minutos

**Actividades**:

1. **Generar Credenciales**
   - Crear usuario para developer (si local)
   - Generar SSH keys
   - Documentar credenciales de forma segura
   - Comunicar método de acceso

2. **Crear Documentación**
   - Especificaciones de VM (nombre, IP, SSH, puertos)
   - Instrucciones de acceso
   - Software instalado con versiones
   - Cambios realizados post-provisión
   - Troubleshooting básico

3. **Crear Entrada en Inventario**
   - Registrar VM en sistema de tracking
   - Asignar propietario (developer)
   - Marcar fecha de creación
   - Establecer SLA de uptime

4. **Comunicar Entrega**
   - Notificar a developer
   - Compartir documentación
   - Solicitar feedback
   - Ofrecer sesión de onboarding (si aplica)

**Criterios de Salida**:
- [ ] Documentación completa creada
- [ ] Credenciales compartidas de forma segura
- [ ] Inventario actualizado
- [ ] Developer notificado y accedió VM
- [ ] Feedback inicial registrado

**Procedimientos Relacionados**:
- PROCED-CREAR-DOCUMENTACIÓN-VM-001
- PROCED-GENERAR-CREDENCIALES-001
- PROCED-REGISTRAR-INVENTARIO-VM-001

---

### ETAPA 6: MONITOREO ACTIVO

**Objetivo**: Mantener VM en salud operacional

**Duración estimada**: Contínuo (diario/semanal)

**Actividades**:

1. **Health Check Periódicos**
   - Diarios: Verificar uptime, disco disponible
   - Semanales: Revisar logs de errores
   - Mensuales: Revisar security updates pendientes

2. **Monitoreo de Cambios**
   - Detectar cambios no autorizados (si aplica)
   - Registrar cambios solicitados por developer
   - Mantener documentación actualizada

3. **Mantenimiento Preventivo**
   - Aplicar parches de seguridad (mensual o según criticidad)
   - Limpiar logs antiguos
   - Verificar disk space
   - Validar backups (si aplica)

4. **Registro de Métricas**
   - Uptime %
   - CPU/RAM/Disk promedio
   - Cambios realizados
   - Incidentes reportados

5. **Alertas**
   - Configurar alertas de disco lleno
   - Alertas de high CPU/RAM
   - Alertas de servicios caídos
   - Notificar a developer/on-call

**Criterios de Salida**:
- [ ] Health checks pasando
- [ ] Métricas siendo capturadas
- [ ] Documentación actualizada
- [ ] Alertas configuradas y funcionando
- [ ] Reporte mensual generado

**Procedimientos Relacionados**:
- PROCED-MONITOREO-SALUD-VM-001
- PROCED-ALERTAS-VM-001
- PROCED-PARCHES-SEGURIDAD-001

---

### ETAPA 7: DESCOMMISSION (Ciclo de Vida Final)

**Objetivo**: Remover VM de forma controlada y documentada

**Duración estimada**: 1-2 horas

**Actividades**:

1. **Solicitud de Descommission**
   - Developer solicita eliminar VM
   - Justifica razón (no se necesita, deprecada, reemplazo)
   - Autoriza pérdida de datos

2. **Backup Final (Si Aplica)**
   - Capturar estado final de VM (snapshot)
   - Exportar datos importantes
   - Generar reporte final de cambios

3. **Desactivación de Servicios**
   - Detener servicios corriendo
   - Remover de monitoreo/alertas
   - Desactivar credenciales de acceso
   - Actualizar documentación (marcar como deprecated)

4. **Eliminación de Infraestructura**
   - `vagrant destroy` (si Vagrant)
   - Eliminar snapshots
   - Liberar recursos (disk space)
   - Actualizar inventario (marcar como deleted)

5. **Documentación Final**
   - Registrar fecha de descommission
   - Documentar lecciones aprendidas
   - Actualizar capacidad disponible de infraestructura
   - Archivar documentación (en caso necesario)

**Criterios de Salida**:
- [ ] Backup final capturado (si aplica)
- [ ] Servicios detenidos
- [ ] Monitoreo desactivado
- [ ] Credenciales revocadas
- [ ] VM eliminada del hipervisor
- [ ] Inventario actualizado
- [ ] Documentación archivada

**Procedimientos Relacionados**:
- PROCED-SOLICITAR-DESCOMMISSION-VM-001
- PROCED-EJECUTAR-DESCOMMISSION-VM-001

---

## DIAGRAMA DE FLUJO

```
┌─────────────────────────────────────────────────────────────────────┐
│                     GESTIÓN DE VMs - FLUJO GENERAL                  │
└─────────────────────────────────────────────────────────────────────┘

                            [Developer]
                                  │
                    Inicia Solicitud de VM
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 1: SOLICITUD      │
                    │ - Llenar formulario     │
                    │ - Especificar recursos  │
                    │ - Validar por DevOps    │
                    └─────────────────────────┘
                                  │
                        ¿Solicitud válida?
                        ├─ NO ──► Rechazar + pedir info
                        │
                        └─ SÍ ──► Continuar
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 2: PROVISIÓN      │
                    │ - Preparar Vagrantfile  │
                    │ - vagrant up            │
                    │ - Validar conectividad  │
                    └─────────────────────────┘
                                  │
                        ¿Provisión exitosa?
                        ├─ NO ──► Retry / Investigar
                        │
                        └─ SÍ ──► Continuar
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 3: CONFIGURACIÓN  │
                    │ - Actualizar SO         │
                    │ - Instalar dependencias │
                    │ - Configurar servicios  │
                    │ - Hardening básico      │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 4: VALIDACIÓN     │
                    │ - Health checks         │
                    │ - Pruebas funcionales   │
                    │ - Performance baseline  │
                    └─────────────────────────┘
                                  │
                        ¿Validación OK?
                        ├─ NO ──► Corregir
                        │
                        └─ SÍ ──► Continuar
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 5: ENTREGA        │
                    │ - Crear documentación   │
                    │ - Generar credenciales  │
                    │ - Registrar inventario  │
                    │ - Notificar developer   │
                    └─────────────────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 6: MONITOREO      │
                    │ - Health checks diarios │
                    │ - Parches mensuales     │
                    │ - Registro de cambios   │
                    │ - Alertas activas       │
                    └─────────────────────────┘
                                  │
                    ¿Solicitud de descommission?
                    ├─ NO ──► Continuar monitoreando
                    │
                    └─ SÍ ──► Continuar
                                  │
                                  ▼
                    ┌─────────────────────────┐
                    │ ETAPA 7: DESCOMMISSION  │
                    │ - Backup final          │
                    │ - Detener servicios     │
                    │ - vagrant destroy       │
                    │ - Actualizar inventario │
                    │ - Documentación final   │
                    └─────────────────────────┘
                                  │
                                  ▼
                            [VM Eliminada]
```

---

## CRITERIOS DE ENTRADA Y SALIDA POR ETAPA

| Etapa | Criterio de Entrada | Criterio de Salida |
|-------|---------------------|-------------------|
| 1. Solicitud | Solicitud completada | Validada, recursos disponibles |
| 2. Provisión | Validación OK | VM running, conectividad OK |
| 3. Configuración | VM creada | Software instalado, servicios activos |
| 4. Validación | Config completada | Health checks pasan, baseline capturado |
| 5. Entrega | Validación OK | Documentación completa, developer accedió |
| 6. Monitoreo | VM en producción | Alertas configuradas, métricas normales |
| 7. Descommission | Solicitud aprobada | VM eliminada, documentación archivada |

---

## MÉTRICAS Y KPIs

### Métricas Principales

| Métrica | Target | Frecuencia | Dueño |
|---------|--------|-----------|-------|
| **Lead Time for VM** | < 24 horas | Por VM | DevOps |
| **Provisioning Success Rate** | > 95% | Mensual | DevOps |
| **VM Uptime** | > 99% | Mensual | DevOps |
| **Time to Descommission** | < 2 horas | Por VM | DevOps |
| **Security Patch Lag** | < 7 días | Mensual | DevOps |
| **Configuration Drift** | 0 cambios no autorizados | Semanal | DevOps |

### Métricas Secundarias

- Número total de VMs activas por categoría
- CPU/RAM promedio utilizado
- Disk space promedio usado
- Número de incidentes por mes
- Satisfacción de desarrolladores (encuesta)
- MTTR (Mean Time to Resolve) problemas

### Reporte Mensual

Incluir:
- Total de VMs creadas/destroyed
- Uptime agregado
- Incidentes y resoluciones
- Cambios de patrones de uso
- Recomendaciones de optimización

---

## HERRAMIENTAS Y TECNOLOGÍAS

### Orquestación

- **Vagrant**: Orquestación de VMs (definir, crear, provisionar)
- **VirtualBox**: Hipervisor de VMs
- **Vagrantfile**: Definición declarativa de VM

### Configuración (Post-Provisión)

- **Ansible** (opcional): Instalación/configuración a escala
- **Shell scripts**: Provisión inicial rápida
- **Package managers**: apt, yum, brew (según SO)

### Monitoreo

- **Scripts bash**: Health checks simples
- **Cron jobs**: Ejecución periódica de checks
- **Logs centralizados**: Para auditoría (TBD)
- **Alertas**: Email o webhook (TBD)

### Documentación

- **Wiki/GitBook**: Documentación de VMs
- **Git repository**: Vagrantfiles y scripts versionados
- **Spreadsheet/database**: Inventario de VMs (TBD)

### Seguridad

- **SSH Keys**: Acceso sin contraseña
- **Firewall**: ufw/iptables configurado
- **Audit logs**: Registro de acceso y cambios

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: VM Urgente de Emergencia

**Trigger**: Developer necesita VM inmediatamente (<2 horas)

**Variaciones**:
- Skip revisión formal de Tech Lead (solo DevOps valida)
- Configuración mínima (SO + dependencias básicas)
- Documentación simplificada (puede completarse después)
- Seguimiento acelerado post-entrega

**NOTA**: No debería ser frecuente (máximo 1-2 por mes)

---

### Caso 2: VM con Alto Consumo de Recursos

**Trigger**: Solicitud de VM con >32GB RAM o >16 CPU cores

**Acciones**:
- Requiere aprobación explícita de Tech Lead
- Justificación de necesidad documentada
- Plan de migración a infraestructura alternativa (si aplica)
- Monitoreo especial de consumo real vs solicitado

---

### Caso 3: VM de Larga Duración (>6 meses)

**Trigger**: VM solicitada para proyecto duradero

**Acciones**:
- Documentación extra detallada
- Plan de mantenimiento definido
- Reviews trimestrales (¿sigue siendo necesaria?)
- Actualización de SO planificada

---

### Caso 4: Múltiples VMs por Developer

**Trigger**: Developer solicita 3+ VMs simultáneamente

**Acciones**:
- Agrupar solicitudes en un proyecto
- Revisar si puede usar cloud/IaaS en lugar de local
- Plan de naming consistente
- Documentación centralizada

---

### Caso 5: Cambio Significativo a VM Existente

**Trigger**: Developer solicita agregar >4GB RAM o instalar software importante

**Acciones**:
- Crear snapshot ANTES del cambio
- Documentar cambio solicitado
- Validar post-cambio
- Actualizar documentación de VM

---

## VARIACIONES DEL PROCESO

### Recreación Rápida de VM (Rebuild)

**Cuando**: VM falla o necesita reset completo

**Diferencias**:
- Skip ETAPA 1 (solicitud ya existe)
- Usar Vagrantfile existente
- Validación acelerada (ETAPA 4 simplificada)
- Documentación: solo registrar fecha de rebuild

**Duración**: 1-2 horas

---

### Clonación de VM Existente

**Cuando**: Developer necesita VM similar a otra existente

**Diferencias**:
- ETAPA 2: Copiar Vagrantfile existente
- ETAPA 3: Cambios mínimos vs original
- ETAPA 4: Tests enfocados en cambios
- Skip documentación de software (heredada)

**Duración**: 2-3 horas (más rápido que nueva)

---

### Template VM (Golden Image)

**Cuando**: Crear VM template para reutilización

**Diferencias**:
- ETAPA 3: Extra cuidado en software elegido
- ETAPA 4: Testing exhaustivo
- Crear Vagrant box personalizado (opcional)
- Documentación: enfoque en personalizaciones
- No tiene ETAPA 7 (es reutilizable)

---

## INTERACCIÓN CON OTROS PROCESOS

```
PROC-INFRA-001 (Este proceso)
       │
       ├─► PROC-DEVOPS-001 (Automatización DevOps general)
       │      └─ Definir estándares de provisión
       │
       ├─► PROC-GOBERNANZA-VM (Por crear)
       │      └─ Políticas de seguridad, approvals
       │
       ├─► PROC-MONITOREO-INFRA-001 (Por crear)
       │      └─ Health monitoring detallado
       │
       ├─► PROC-BACKUP-RECOVERY-001 (Por crear)
       │      └─ Backup de VMs (ETAPA 2 & 7)
       │
       └─► PROC-INCIDENT-RESPONSE-001 (Por crear)
              └─ Si VM falla durante ETAPA 6
```

---

## ROLES Y RESPONSABILIDADES DETALLADAS

### Developer (Solicitante)

**Durante Solicitud (ETAPA 1)**:
- Completar formulario con requisitos claros
- Justificar necesidad técnica
- Estimar tiempo de uso

**Durante Validación (ETAPA 4)**:
- Validar funcionalidad (si aplica)
- Reportar issues encontrados
- Aprobar VM antes de entrega

**Durante Monitoreo (ETAPA 6)**:
- Reportar problemas detectados
- Solicitar cambios con anticipación
- Notificar cuando VM ya no se necesita

---

### DevOps Engineer (Ejecutor Principal)

**Toda la ejecución**:
- Responsable de todas las 7 etapas
- Toma decisiones técnicas (SO, software)
- Documenta cambios realizados
- Monitorea salud de VM
- Responde a issues del developer

**Comunicación**:
- Actualiza developer regularmente
- Reporta problemas a Tech Lead
- Documenta lessons learned

---

### Tech Lead / Infrastructure Manager (Aprobador)

**Excepciones y decisiones**:
- Aprueba/rechaza solicitudes de alto costo
- Revisa políticas de seguridad
- Resuelve conflicts por recursos
- Aprueba cambios a este proceso

**Reportes**:
- Recibe reportes mensuales de métricas
- Planifica capacidad de infraestructura
- Propone mejoras al proceso

---

## TROUBLESHOOTING

### Problema: Provisión Falla (vagrant up error)

**Causas comunes**:
- VirtualBox no instalado o desactualizado
- Insuficiente disk space
- Puerto ya está en uso
- Vagrant box corrupto

**Solución**:
1. Revisar error específico de vagrant
2. Verificar estado de VirtualBox
3. Liberar puertos (si necesario)
4. `vagrant box remove` y reintentar (último recurso)

---

### Problema: VM sin Conectividad SSH

**Causas comunes**:
- SSH no instalado
- Firewall bloqueando puerto 22
- IP incorrecta

**Solución**:
1. Acceder via VirtualBox console (headless mode)
2. Verificar IP: `ifconfig`
3. Verificar SSH: `sudo service ssh status`
4. Revisar firewall: `sudo ufw status`

---

### Problema: Software no funciona después de instalación

**Causas comunes**:
- Conflictos de dependencias
- Version incompatible con SO
- Permisos incorrectos

**Solución**:
1. Revisar logs de instalación
2. Verificar versiones instaladas
3. Reinstalar desde docs oficiales
4. Crear nuevo Vagrantfile si es bug recurrente

---

### Problema: VM usa mucha CPU/RAM

**Causas comunes**:
- Proceso descontrolado corriendo
- Swap siendo usado
- Hyper-threading en hipervisor

**Solución**:
1. SSH a VM y revisar `top` / `htop`
2. Identificar proceso culpable
3. Investigar por qué usa más de lo esperado
4. Optimizar o aumentar recursos (si necesario)

---

## MEJORA CONTINUA

### Retrospectivas Mensuales

**Participantes**: DevOps Lead + Developers (representantes)

**Agenda**:
1. Revisar métricas del mes (VMs creadas, uptime, etc.)
2. Qué funcionó bien
3. Problemas encontrados
4. Cambios sugeridos
5. Actualizar este proceso (si necesario)

---

### Revisión Trimestral del Proceso

**Por realizar**: Cada 3 meses (next: 2026-02-18)

**Verificar**:
- Métricas de cumplimiento
- Satisfacción de desarrolladores
- Bottlenecks identificados
- Nuevas herramientas disponibles (Terraform, Ansible, etc.)
- Actualizar este proceso según aprendizajes

---

## REFERENCIA A PROCEDIMIENTOS (Por Crear)

Este proceso será soportado por los siguientes procedimientos (HOW-TO):

- **PROCED-SOLICITAR-VM-001**: Cómo llenar formulario de solicitud
- **PROCED-VALIDAR-SOLICITUD-VM-001**: Cómo validar solicitud
- **PROCED-PROVISIONAR-VM-VAGRANT-001**: Pasos técnicos de vagrant
- **PROCED-INSTALAR-DEPENDENCIAS-001**: Cómo instalar software
- **PROCED-CONFIGURAR-SERVICIOS-001**: Cómo configurar servicios
- **PROCED-HEALTH-CHECK-VM-001**: Scripts de validación
- **PROCED-CREAR-DOCUMENTACION-VM-001**: Template de documentación
- **PROCED-GENERAR-CREDENCIALES-001**: Cómo crear SSH keys
- **PROCED-REGISTRAR-INVENTARIO-VM-001**: Sistema de tracking
- **PROCED-MONITOREO-SALUD-VM-001**: Health monitoring diario
- **PROCED-DESCOMMISSION-VM-001**: Pasos de eliminación
- **PROCED-PARCHES-SEGURIDAD-001**: Cómo aplicar updates

---

## REFERENCIAS Y GUÍAS

- [PROC-DEV-001: Pipeline de Trabajo IACT](../../gobernanza/procesos/PROC-DEV-001-pipeline_trabajo_iact.md)
- [PROC-DEVOPS-001: Automatización DevOps](../../gobernanza/procesos/PROC-DEVOPS-001-devops_automation.md)
- [Guía: Procesos vs Procedimientos](../../gobernanza/guias/DIFERENCIA_PROCESOS_PROCEDIMIENTOS.md)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [VirtualBox User Manual](https://www.virtualbox.org/manual/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/tips_tricks/index.html)

---

## HISTORIAL DE CAMBIOS

### v1.0.0 (2025-11-18)

- Versión inicial del proceso
- Definición de 7 etapas del flujo
- Roles y responsabilidades claros
- KPIs medibles
- Casos especiales documentados
- Diagrama ASCII de flujo
- Troubleshooting incluido
- Mejora continua definida

**Creado por**: Claude Code (Haiku 4.5)
**Técnica de prompting**: Chain-of-Thought + Self-Consistency
**Estado**: Activo (aprobación pendiente)

---

**Próxima revisión**: 2026-02-18 (3 meses)
**Responsable de revisión**: DevOps Lead + Tech Lead
**Aprobación pendiente**: CTO, DevOps Manager, Developer Representatives

