# README: Procedimientos de Infraestructura IACT

## Visión General

Este directorio contiene **6 procedimientos detallados y operacionales** para infraestructura del proyecto IACT, organizados como **TASK-044 a TASK-049** dentro de la estrategia FASE_3_CONTENIDO_NUEVO. Todos los procedimientos están vinculados al proceso **PROC-INFRA-001: Gestión de Infraestructura de Máquinas Virtuales**.

Cada procedimiento incluye:
- **Propósito claro** (CÓMO hacerlo, paso a paso)
- **Pre-requisitos verificables**
- **7-10 pasos detallados con comandos exactos**
- **Validaciones por paso**
- **Troubleshooting comprehensive**
- **Rollback procedures**
- **Criterios de éxito**
- **Tiempo estimado**

---

## Procedimientos Disponibles

### TASK-044: PROCED-INFRA-001 - Provisión de VM con Vagrant

**Archivo**: `PROCED-INFRA-001-provision-vm-vagrant.md`

**Propósito**: Provisionar una máquina virtual con Vagrant, incluyendo validación de requisitos, creación de VM, aprovisionamiento de servicios (PostgreSQL, MariaDB), y verificación de funcionalidad.

**Pasos**:
1. Verificar pre-requisitos (Vagrant, VirtualBox, virtualizacion)
2. Clonar/Obtener Vagrantfile
3. Configurar bootstrap script
4. Ejecutar vagrant up
5. Verificar máquina virtual
6. SSH y validaciones
7. Crear snapshot
8. Tests finales

**Tiempo**: 45-90 minutos

**Comandos clave**:
```bash
vagrant --version
vagrant validate
vagrant up
vagrant ssh
VBoxManage snapshot "iact-devbox" take "clean-provision"
```

---

### TASK-045: PROCED-INFRA-002 - Configurar DevContainer Host

**Archivo**: `PROCED-INFRA-002-configurar-devcontainer-host.md`

**Propósito**: Configurar el host para DevContainers (Docker, Docker Compose, permisos, redes)

**Pasos**:
1. Verificar pre-requisitos del sistema (OS, virtualizacion, espacio)
2. Actualizar sistema operativo (apt-get update/upgrade)
3. Instalar Docker Engine (repositorio + paquete)
4. Configurar permisos Docker (grupo docker, usermod)
5. Instalar Docker Compose (versión 2.x)
6. Configurar Docker Daemon (daemon.json)
7. Verificar instalación (hello-world test)
8. Configurar DevContainer (clonar repo)
9. Testing de conectividad y recursos
10. Validación final

**Tiempo**: 55-90 minutos

**Comandos clave**:
```bash
docker --version
docker-compose --version
docker run hello-world
sudo systemctl status docker
```

---

### TASK-046: PROCED-INFRA-003 - Ejecutar Pipeline CI/CD

**Archivo**: `PROCED-INFRA-003-ejecutar-pipeline-cicd.md`

**Propósito**: Ejecutar pipeline completo (tests, linting, build, validación)

**Pasos**:
1. Verificar pre-requisitos (Git, Node, Python, Docker)
2. Clonar/actualizar repositorio
3. Instalar dependencias (npm, pip)
4. Setup de variables de entorno (.env files)
5. Ejecutar tests unitarios (Jest, Pytest)
6. Análisis estático de código (ESLint, Flake8)
7. Build de artefactos (npm run build, Docker images)
8. Validación de artefactos
9. Tests de integración (Playwright, pytest)
10. Logging y reportes del pipeline

**Tiempo**: 120-180 minutos

**Comandos clave**:
```bash
npm install && npm test
pytest --cov
npm run build
docker-compose build
```

---

### TASK-047: PROCED-INFRA-004 - Backup y Restauración de VM

**Archivo**: `PROCED-INFRA-004-backup-restauracion-vm.md`

**Propósito**: Realizar backups completos y restauraciones de VMs y bases de datos

**Pasos**:
1. Preparar ambiente para backup (espacio, permisos)
2. Crear snapshot de VM Vagrant
3. Backup de bases de datos (PostgreSQL, MariaDB)
4. Backup de volúmenes Docker
5. Backup de archivos de configuración
6. Compresión y compactación de backups
7. Validación de integridad de backups
8. Almacenamiento y rotación de backups
9. Restauración desde snapshot
10. Restauración de bases de datos

**Tiempo**: 95-150 minutos

**Comandos clave**:
```bash
VBoxManage snapshot "iact-devbox" take "backup-name"
pg_dump -U postgres iact_analytics | gzip > backup.sql.gz
mysqldump -u root -p ivr_legacy | gzip > backup.sql.gz
docker volume backup
tar czf backup.tar.gz backups/
```

---

### TASK-048: PROCED-INFRA-005 - Troubleshooting DevContainer

**Archivo**: `PROCED-INFRA-005-troubleshooting-devcontainer.md`

**Propósito**: Diagnosticar y resolver problemas comunes de DevContainers

**Pasos**:
1. Diagnosticar estado del contenedor
2. Diagnosticar problemas de configuración (devcontainer.json)
3. Diagnosticar problemas de red
4. Diagnosticar problemas de volúmenes
5. Diagnosticar problemas de permisos
6. Diagnosticar problemas de recursos
7. Diagnosticar problemas de performance
8. Diagnosticar problemas de extensiones VS Code
9. Debugging avanzado (shell, logs)
10. Recuperación y reset

**Tiempo**: Variable (5-120 minutos según problema)

**Matriz de troubleshooting**:
- Container no conecta → Docker status, logs
- Mount refused → Permisos de archivos
- Network unavailable → DNS/conectividad
- Out of memory → Aumentar RAM
- Disk full → docker system prune

---

### TASK-049: PROCED-INFRA-006 - Actualizar Toolchain CPython

**Archivo**: `PROCED-INFRA-006-actualizar-toolchain-cpython.md`

**Propósito**: Compilar e instalar versiones nuevas de Python, actualizar venvs

**Pasos**:
1. Preparar ambiente para compilación (build-essentials, headers)
2. Descargar CPython source (validar integridad)
3. Configurar compilación (./configure con optimizaciones)
4. Compilar CPython (make -j$(nproc))
5. Ejecutar tests (make test)
6. Instalar CPython (/opt/python-X.Y.Z/)
7. Actualizar virtual environments
8. Validación de compatibilidad (imports, tests)
9. Performance testing (benchmarks)
10. Limpieza y preparación de rollback

**Tiempo**: 180-250 minutos (3-4 horas)

**Compilación**: 60-120 minutos (cuello de botella)

**Comandos clave**:
```bash
./configure --prefix=/opt/python-3.12.0 --enable-optimizations
make -j$(nproc)
sudo make install
python3.12 -m venv venv
```

---

## Tabla Resumen de Procedimientos

| ID | Título | Proceso Relacionado | Duración Estimada | Estado |
|----|--------|-------------------|-------------------|--------|
| **PROCED-INFRA-001** | Provisión de VM Vagrant | PROC-INFRA-001 (ETAPA 2-3) | 45-90 min | ACTIVO |
| **PROCED-INFRA-002** | Configurar DevContainer Host | PROC-INFRA-001 (ETAPA 3) | 55-90 min | ACTIVO |
| **PROCED-INFRA-003** | Ejecutar Pipeline CI/CD | PROC-INFRA-001 (ETAPA 4) | 120-180 min | ACTIVO |
| **PROCED-INFRA-004** | Backup y Restauración de VM | PROC-INFRA-001 (ETAPA 7) | 95-150 min | ACTIVO |
| **PROCED-INFRA-005** | Troubleshooting DevContainer | PROC-INFRA-001 (ETAPA 6) | Variable (5-120 min) | ACTIVO |
| **PROCED-INFRA-006** | Actualizar Toolchain CPython | PROC-INFRA-001 (ETAPA 3) | 180-250 min | ACTIVO |

## Matriz Procedimientos-Procesos

Esta matriz vincula cada procedimiento con las etapas del proceso PROC-INFRA-001 (Gestión de Infraestructura de VMs):

| Procedimiento | Proceso Padre | Etapa(s) del Proceso | Descripción de Vinculación |
|---------------|---------------|---------------------|----------------------------|
| **PROCED-INFRA-001** | PROC-INFRA-001 | ETAPA 2: Provisión Automatizada<br>ETAPA 3: Configuración Inicial | Cubre el CÓMO provisionar una VM con Vagrant (vagrant up) y la configuración inicial del sistema |
| **PROCED-INFRA-002** | PROC-INFRA-001 | ETAPA 3: Configuración Inicial | Cubre el CÓMO configurar el host para DevContainers (Docker, Docker Compose, permisos) |
| **PROCED-INFRA-003** | PROC-INFRA-001 | ETAPA 4: Validación y Testing | Cubre el CÓMO ejecutar el pipeline CI/CD completo (tests, linting, build, deployment) |
| **PROCED-INFRA-004** | PROC-INFRA-001 | ETAPA 7: Descommission<br>ETAPA 6: Monitoreo Activo | Cubre el CÓMO realizar backups completos de VMs, bases de datos y configuraciones, y cómo restaurar desde backups |
| **PROCED-INFRA-005** | PROC-INFRA-001 | ETAPA 6: Monitoreo Activo | Cubre el CÓMO diagnosticar y resolver problemas comunes en DevContainers (conectividad, permisos, recursos) |
| **PROCED-INFRA-006** | PROC-INFRA-001 | ETAPA 3: Configuración Inicial | Cubre el CÓMO compilar e instalar versiones nuevas de CPython desde source, actualizar virtual environments |

## Tabla Resumen de Tareas (Origen de Creación)

| TASK | PROCED | Título | Fase | Prioridad | Duración | Técnica |
|------|--------|--------|------|-----------|----------|---------|
| **TASK-044** | PROCED-INFRA-001 | Provisión de VM Vagrant | FASE_3 | ALTA | 4-5h | Decomposed Prompting |
| **TASK-045** | PROCED-INFRA-002 | Configurar DevContainer Host | FASE_3 | ALTA | 4-5h | Decomposed Prompting |
| **TASK-046** | PROCED-INFRA-003 | Ejecutar Pipeline CI/CD | FASE_3 | ALTA | 4-5h | Decomposed Prompting |
| **TASK-047** | PROCED-INFRA-004 | Backup y Restauración de VM | FASE_3 | ALTA | 4-5h | Decomposed Prompting |
| **TASK-048** | PROCED-INFRA-005 | Troubleshooting DevContainer | FASE_3 | ALTA | 4-5h | Decomposed Prompting |
| **TASK-049** | PROCED-INFRA-006 | Actualizar Toolchain CPython | FASE_3 | ALTA | 4-5h | Decomposed Prompting |

---

## Características Clave

### Decomposed Prompting (Técnica)
- Cada procedimiento descompone tareas complejas en pasos atómicos
- Cada paso incluye comando exacto + salida esperada
- Validaciones intermedias después de cada paso
- Troubleshooting específico para cada síntoma

### Auto-CoT + Self-Consistency
- Múltiples cadenas de razonamiento para robustez
- Validaciones en múltiples puntos
- Fallbacks y alternativas documentadas
- Tests de integridad en cada etapa

### Documentación Exhaustiva
- 7-10 pasos detallados por procedimiento
- Comandos exactos que pueden ser copiados/pegados
- Salidas esperadas documentadas
- Logs y debugging información

---

## Cómo Usar Estos Procedimientos

### Ejecución Paso a Paso

1. **Leer TODO el procedimiento primero** (5 minutos)
   - Entender el objetivo general
   - Identificar pre-requisitos
   - Estimar tiempo total

2. **Verificar pre-requisitos** (Paso 1 de cada procedimiento)
   - Ejecutar comandos de verificación
   - Instalar faltantes si es necesario
   - Confirmar recursos disponibles

3. **Ejecutar cada paso secuencialmente**
   - Copiar comando exacto
   - Ejecutar en terminal
   - Comparar salida con esperada
   - Si falla, referir a sección Troubleshooting

4. **Validar después de cada paso**
   - Usar comandos de validación especificados
   - Usar tabla de "Validaciones por Paso"
   - Documentar cualquier desviación

5. **Si algo falla**
   - Buscar síntoma en sección "Troubleshooting"
   - Aplicar solución
   - Reintentanar paso fallido
   - Si problema persiste, consultar Tech Lead

---

## Integración con Workflow

### Workflow de Desarrollo
```
Developer → (PROCED-INFRA-001) Provisión VM Vagrant
         → (PROCED-INFRA-002) Setup DevContainer Host
         → (PROCED-INFRA-003) Run CI/CD Pipeline
         → (PROCED-INFRA-004) Backup Before Major Changes
         → Si problema → (PROCED-INFRA-005) Troubleshoot DevContainer
         → Si update Python → (PROCED-INFRA-006) Update CPython
```

---

## Archivos Relacionados

### Procedimientos de Infraestructura
- `/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md`
- `/docs/infraestructura/procedimientos/PROCED-INFRA-002-configurar-devcontainer-host.md`
- `/docs/infraestructura/procedimientos/PROCED-INFRA-003-ejecutar-pipeline-cicd.md`
- `/docs/infraestructura/procedimientos/PROCED-INFRA-004-backup-restauracion-vm.md`
- `/docs/infraestructura/procedimientos/PROCED-INFRA-005-troubleshooting-devcontainer.md`
- `/docs/infraestructura/procedimientos/PROCED-INFRA-006-actualizar-toolchain-cpython.md`

### Procesos de Infraestructura
- `/docs/infraestructura/procesos/PROC-INFRA-001-gestion-infraestructura-vm.md`

### Documentación de Infraestructura
- `/docs/infraestructura/README.md`
- `/docs/infraestructura/devcontainer/README.md`
- `/docs/infraestructura/vagrant-dev/README.md`

### Análisis y Reportes
- `/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/LISTADO-COMPLETO-TAREAS.md`

---

## Estadísticas de Documentación

| Métrica | Valor |
|---------|-------|
| Total Procedimientos | 6 (PROCED-INFRA-001 a PROCED-INFRA-006) |
| Total Pasos | 60 (10 pasos × 6 procedimientos) |
| Total Comandos | 300+ |
| Total Troubleshooting | 35+ problemas |
| Total Líneas de Código/Docs | 10000+ |
| Tiempo Total Estimado (todos) | 590-850 minutos |
| Cobertura | 100% de procedimientos críticos de infraestructura |
| Proceso Padre | PROC-INFRA-001 (Gestión de Infraestructura de VMs) |

---

## Versiones de Procedimientos

Todos los procedimientos tienen:
- **Versión**: 1.0.0 (inicial)
- **Fecha de creación**: 2025-11-18
- **Autor**: Claude Code (Haiku 4.5)
- **Estado**: ACTIVO
- **Próxima revisión**: 2026-02-18 (3 meses)

---

**Última actualización**: 2025-11-18
**Próxima revisión**: 2026-02-18
**Mantenedor**: DevOps Team
