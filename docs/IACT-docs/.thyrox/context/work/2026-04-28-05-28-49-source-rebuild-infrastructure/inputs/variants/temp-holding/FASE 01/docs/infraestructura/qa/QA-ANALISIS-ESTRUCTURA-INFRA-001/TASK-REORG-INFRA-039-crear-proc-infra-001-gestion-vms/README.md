---
id: TASK-REORG-INFRA-039
tipo: tarea_contenido
categoria: proceso
fase: FASE_3_CONTENIDO_NUEVO
prioridad: ALTA
duracion_estimada: 4h
estado: pendiente
dependencias: [TASK-REORG-INFRA-011]
tags: [proceso, vm, vagrant, gestion]
tecnica_prompting: Chain-of-Thought
---

# TASK-REORG-INFRA-039: Crear PROC-INFRA-001 (Gestión de Infraestructura VM)

## Propósito

Crear el primer proceso formal de infraestructura (alto nivel) para gestionar el ciclo de vida completo de máquinas virtuales en el proyecto IACT.

**Tipo de salida**: Proceso (QUÉ hacemos) - NO procedimiento (CÓMO hacerlo)

---

## Razonamiento Chain-of-Thought (Auto-CoT)

### Paso 1: Exploración de procesos existentes

Se revisaron los procesos de gobernanza:
- **PROC-DEV-001**: Pipeline de trabajo completo (7 etapas definidas)
- **PROC-DEV-002**: Ciclo SDLC
- **PROC-DEVOPS-001**: Automatización DevOps
- **PROC-GOB-001**: Mapeo de procesos y templates

**Aprendizajes**:
- Los procesos tienen frontmatter YAML con metadatos
- Cada etapa tiene actividades claras, criterios de salida y procedimientos relacionados
- Usan diagramas de flujo ASCII para visualizar el flujo
- Incluyen métricas KPI y casos especiales
- Documentan herramientas y roles involucrados

### Paso 2: Razonamiento sobre Gestión de VMs

**Pregunta clave**: ¿Qué es un proceso de gestión de VMs?

Un proceso de gestión de VMs define el FLUJO de actividades para gestionar máquinas virtuales desde su solicitud hasta su descommission. Es alto nivel (QUÉ) no bajo nivel (CÓMO).

**Alcance claro**:
- VMs Vagrant para desarrollo local
- DevContainer Hosts para desarrollo en contenedores
- NO incluye: Monitoreo específico (es un subproceso), backup (otro proceso)

**Roles involucrados**:
- **Desarrolladores**: Solicitan VMs, las usan
- **DevOps**: Aprovisionan, configuran, monitorean
- **Tech Lead**: Revisan políticas y requisitos

### Paso 3: Definición del Flujo High-Level

El ciclo de vida de una VM tiene 5 fases principales:

1. **Solicitud** → Developer solicita, DevOps valida requisitos
2. **Provisión** → Vagrant crea VM, configura SO
3. **Configuración** → Instala dependencias, configura servicios
4. **Validación** → Tests de funcionalidad
5. **Monitoreo** → Uptime, cambios, seguridad
6. **Descommission** → Cuando ya no se necesita

### Paso 4: Definición de Inputs/Outputs

**Inputs**:
- Solicitud de VM (especificación de requisitos)
- Requisitos de CPU, RAM, Storage
- Software a instalar
- Especificaciones de seguridad

**Outputs**:
- VM aprovisionada y funcionando
- Documentación de VM
- Credenciales de acceso
- Logs de provisión y configuración

### Paso 5: Métricas y KPIs

- Lead Time for VM Provision (tiempo solicitud → VM lista)
- VM Uptime (disponibilidad)
- Provisioning Success Rate (% VMs que se crean exitosamente)
- Configuration Accuracy (cambios no autorizados)
- Mean Time to Rebuild (MTTR)

### Paso 6: Herramientas Identificadas

- **Vagrant**: Orquestación de VMs
- **VirtualBox**: Hipervisor
- **Ansible**: Configuración post-provisión (opcional)
- **Monitoring**: Scripts de health check
- **Documentation**: Wiki/GitBook

---

## Self-Consistency Check

**Verificación**: ¿Es un proceso (QUÉ) o procedimiento (CÓMO)?

✓ **CORRECTO**: Define FLUJO de actividades, roles, inputs/outputs, métricas
✗ **INCORRECTO**: No incluye pasos detallados de comandos (esos van en procedimientos)

Ejemplo:
- ✓ Proceso: "El desarrollador solicita una VM completando el formulario de solicitud"
- ✗ Procedimiento: "Ejecutar `vagrant up` con el archivo Vagrantfile"

---

## Estructura del Proceso a Crear

El archivo PROC-INFRA-001-gestion-infraestructura-vm.md incluirá:

1. **Metadatos YAML** con frontmatter
2. **Propósito**: QUÉ hacemos (alto nivel)
3. **Alcance**: VMs Vagrant, DevContainer Hosts, límites claros
4. **Roles y Responsabilidades**: DevOps, desarrolladores, Tech Lead
5. **Flujo del Proceso** (high-level):
   - Solicitud de VM
   - Revisión y Aprobación
   - Provisión
   - Configuración Inicial
   - Validación y Entrega
   - Monitoreo
   - Descommission
6. **Inputs y Outputs** claros
7. **Criterios de Entrada/Salida** para cada etapa
8. **Métricas y KPIs** para medir éxito
9. **Herramientas**: Vagrant, VirtualBox, Ansible, Monitoring
10. **Referencias**: Procedimientos relacionados (a crear después)
11. **Diagrama ASCII** de flujo
12. **Excepciones**: Casos especiales (VM de emergencia, etc.)

---

## Archivos a Crear

```
/home/user/IACT/tareas/TASK-REORG-INFRA-039-crear-proc-infra-001-gestion-vms/
├── README.md (esta tarea)
└── evidencias/
    └── PROC-INFRA-001-gestion-infraestructura-vm.md (el proceso)

/home/user/IACT/docs/infraestructura/procesos/
└── PROC-INFRA-001-gestion-infraestructura-vm.md (enlace/copia)
```

---

## Dependencias

- ✓ TASK-REORG-INFRA-011: Estructura base de infraestructura (completada)

---

## Entregables

1. ✓ Proceso PROC-INFRA-001 con:
   - Metadatos claros
   - 6 etapas del flujo
   - Roles y responsabilidades definidas
   - KPIs medibles
   - Diagrama ASCII
   - Referencias a procedimientos
   - Casos especiales documentados

2. ✓ README.md de tarea documentando razonamiento

3. ✓ Estructura lista para crear procedimientos (PROCED-SOLICITAR-VM-001, etc.)

---

## Próximos Pasos (Post-Tarea)

Después de crear PROC-INFRA-001, crear:
- PROCED-SOLICITAR-VM-001 (cómo solicitar)
- PROCED-PROVISIONAR-VM-001 (cómo provisionar)
- PROCED-DESCOMMISSION-VM-001 (cómo descommission)
- PROCED-MONITOREO-VM-001 (cómo monitorear)

---

## Estado

**Actual**: PENDIENTE
**Creado**: 2025-11-18
**Responsable**: Claude Code (Chain-of-Thought + Self-Consistency)

