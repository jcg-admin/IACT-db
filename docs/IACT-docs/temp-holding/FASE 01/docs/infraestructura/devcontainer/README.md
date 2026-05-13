# DevContainer - Entorno de Desarrollo Contenedorizado

**Autor**: Infrastructure Team
**Fecha**: 2025-11-09
**Estado**: ACTIVO

## Indice

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Arquitectura del Sistema](#arquitectura-del-sistema)
- [Lifecycle Scripts](#lifecycle-scripts)
- [Utility Modules](#utility-modules)
- [Configuracion y Variables](#configuracion-y-variables)
- [Troubleshooting](#troubleshooting)
- [Referencias](#referencias)

---

## Resumen Ejecutivo

El DevContainer del proyecto IACT es un entorno de desarrollo completamente contenedorizado que proporciona:

- **Python 3.12.6 precompilado** con optimizaciones PGO/LTO
- **PostgreSQL** como base de datos principal
- **MariaDB** para acceso legacy (read-only)
- **Setup automatizado** con 5 scripts de lifecycle
- **Validaciones comprehensivas** en cada fase
- **Idempotencia garantizada** - puede ejecutarse multiples veces

**Soporte de plataformas**:
- GitHub Codespaces
- VS Code Local + Docker Desktop
- VS Code Remote SSH

### Compatibilidad con Linux y entornos basados en Vagrant

- **Linux host**: El DevContainer funciona sin cambios en distribuciones Linux siempre que tengas Docker y la extensión Dev Containers instalados; no requiere Docker Desktop.
- **Coexistencia con Vagrant**: Puedes mantener tu stack de bases de datos en Vagrant y usar el DevContainer solo para el workspace de código. Ajusta los hosts/puertos en `.env` (o `.devcontainer/.env`) para apuntar al PostgreSQL/MariaDB expuestos por Vagrant (p. ej., `15432` y `13306`).
- **CI/CD y producción sin Docker**: Que producción no use contenedores no invalida el DevContainer. Úsalo para reproducibilidad en desarrollo/CI y mantén paridad declarando las mismas variables y scripts de provisión que usarás en máquinas bare metal.

---

## Arquitectura del Sistema

### Diagrama de Lifecycle

```
[HOST]                      [CONTAINER]
  |                              |
  |--[1. init_host.sh]           |
  |   Pre-validations            |
  |   (Estructura, scripts)      |
  |                              |
  |                              |--[2. on_create.sh]
  |                              |   Initial setup (once)
  |                              |   (Python, Git, dirs)
  |                              |
  |                              |--[3. update_content.sh]
  |                              |   Install dependencies
  |                              |   (pip install)
  |                              |
  |                              |--[4. post_create.sh]
  |                              |   Database setup (once)
  |                              |   (Migrations, superuser)
  |                              |
  |                              |--[5. post_start.sh]
  |                              |   Quick verification
  |                              |   (Every start)
  |
  v                              v
[Contenedor Listo]
```

### Componentes

| Componente | Ubicacion | Proposito |
|------------|-----------|-----------|
| **devcontainer.json** | .devcontainer/ | Configuracion principal |
| **Dockerfile** | .devcontainer/ | Imagen del contenedor |
| **docker_compose.yml** | .devcontainer/ | Servicios (app, postgres, mariadb) |
| **Lifecycle Scripts** | infrastructure/devcontainer/scripts/ | Automatizacion |
| **Utility Modules** | infrastructure/devcontainer/utils/ | Funciones reutilizables |

---

## Lifecycle Scripts

### 1. init_host.sh (443 lineas)

**Lifecycle**: `initializeCommand` (HOST)
**Frecuencia**: MULTIPLE (creacion + reinicios)
**Ejecuta en**: HOST (antes de construir contenedor)

**Proposito**: Validaciones universales antes de construir el contenedor

**Pasos ejecutados** (8 steps):

1. **Deteccion de contexto**
   - GitHub Codespaces
   - VS Code Remote
   - Local

2. **Validacion de estructura de directorios**
   ```bash
   infraestructura/devcontainer
   infraestructura/devcontainer/scripts
   api/callcentersite
   ```

3. **Validacion de lifecycle scripts**
   - Verificar existencia de scripts
   - Hacer ejecutables si necesario
   - Scripts requeridos:
     - on_create.sh
     - update_content.sh
     - post_create.sh
     - post_start.sh

4. **Validacion de archivos criticos**
   - api/callcentersite/manage.py
   - .devcontainer/docker_compose.yml
   - .devcontainer/Dockerfile
   - .devcontainer/devcontainer.json

5. **Validacion de requirements**
   - requirements/base.txt (requerido)
   - requirements/dev.txt (requerido)
   - requirements/test.txt (opcional)

6. **Creacion de directorios necesarios**
   ```bash
   infraestructura/devcontainer/logs
   infraestructura/state
   ```

7. **Setup de env file**
   - Copiar env.example -> env si no existe
   - Crear env basico si env.example no existe

8. **Validacion de utils** (opcional)
   - Verificar que utils/core.sh existe

**Control de idempotencia**:
- Crea archivo `.devcontainer/.init_completed` con timestamps
- Primera inicializacion vs re-inicializaciones

**Exit codes**:
- `0`: Success (ERRORS = 0)
- `1`: Failure (ERRORS > 0)

**Ejemplo de salida**:
```
===================================================
DEVCONTAINER PRE-INITIALIZATION
===================================================

[INFO] Detecting execution context...
[OK] Running locally
[INFO] OS: Linux

[STEP 1/8] Validating directory structure...
[OK] Directory found: infrastructure/devcontainer
[OK] Directory found: api/callcentersite

[STEP 8/8] Marking initialization...
[OK] First-time initialization completed at: 2025-11-09T10:30:00-05:00

===================================================
[OK] Pre-initialization completed successfully
[INFO] Errors: 0, Warnings: 0
===================================================
```

---

### 2. on_create.sh (420 lineas)

**Lifecycle**: `onCreateCommand` (CONTAINER)
**Frecuencia**: UNA SOLA VEZ (creacion del contenedor)
**Ejecuta en**: CONTAINER (primera vez)

**Proposito**: Setup basico dentro del contenedor por primera vez

**Modulos cargados**:
- core.sh (funciones base)
- logging.sh (sistema de logging)
- validation.sh (validaciones)
- python.sh (utilidades Python/Django)

**Pasos ejecutados** (7 steps):

1. **Validar contexto y sistema**
   - Detectar contexto (Codespaces, Remote, Local)
   - Informacion del sistema (OS, memoria, disco)
   - Validar espacio en disco (minimo 5GB)

2. **Validar Python environment**
   - Python instalado (3.11+)
   - pip instalado
   - Comandos adicionales (git, curl)

3. **Validar estructura del proyecto**
   - Proyecto Django valido
   - Requirements directory
   - Validar base.txt, dev.txt, test.txt

4. **Crear directorios necesarios**
   ```bash
   infraestructura/devcontainer/logs
   infraestructura/state
   .devcontainer
   ```

5. **Setup Git configuration**
   - user.name (si no existe)
   - user.email (si no existe)
   - safe.directory

6. **Validar clientes de base de datos**
   - PostgreSQL client (psql)
   - MariaDB client (mysql)

7. **Marcar completado**
   - Crear `infrastructure/state/on-create.completed`

**Logging**:
- Log file: `infrastructure/devcontainer/logs/on-create-YYYYMMDD-HHMMSS.log`

**Ejemplo de salida**:
```
================================================================
DEVCONTAINER - INITIAL SETUP (onCreate)
================================================================

[1/7] Validating context and system
[INFO] Execution context: codespaces
[INFO] OS: Ubuntu 22.04.3 LTS
[INFO] Memory: 7.8 GB
[INFO] Disk: 50 GB available
[OK] Context and system validated

[2/7] Validating Python environment
[OK] Python installed: 3.12.6
[OK] Python version meets requirements (>= 3.11)
[OK] pip installed: pip 24.0

[7/7] Marking onCreate as completed
[OK] onCreate marked as completed

================================================================
[OK] onCreate completed successfully
[INFO] Errors: 0, Warnings: 0
================================================================
```

---

### 3. update_content.sh (492 lineas)

**Lifecycle**: `updateContentCommand` (CONTAINER)
**Frecuencia**: MULTIPLE (rebuild, actualizar contenido)
**Ejecuta en**: CONTAINER (multiples veces)

**Proposito**: Instalar y actualizar dependencias de Python

**Caracteristica clave**: COMPLETAMENTE IDEMPOTENTE

**Modulos cargados**:
- core.sh
- logging.sh
- validation.sh
- python.sh

**Pasos ejecutados**:

1. **Validar prerequisitos**
   - Python instalado
   - pip instalado
   - Requirements directory

2. **Actualizar pip y setuptools**
   ```bash
   pip install --upgrade pip setuptools wheel
   ```

3. **Instalar requirements/base.txt**
   - Dependencias de produccion
   - Django, DRF, PostgreSQL, etc.

4. **Instalar requirements/dev.txt**
   - Herramientas de desarrollo
   - pytest, ruff, black, etc.

5. **Instalar requirements/test.txt** (opcional)
   - Dependencias de testing

6. **Verificar instalacion de Django**
   - Validar que Django esta instalado
   - Mostrar version instalada

7. **Marcar completado**
   - Crear `infrastructure/state/update-content.completed`

**Deteccion de cambios**:
- Compara checksums de requirements files
- Skip instalacion si no hay cambios

**Logging**:
- Log file: `infrastructure/devcontainer/logs/update-content-YYYYMMDD-HHMMSS.log`

---

### 4. post_create.sh (452 lineas)

**Lifecycle**: `postCreateCommand` (CONTAINER)
**Frecuencia**: UNA SOLA VEZ (creacion del contenedor)
**Ejecuta en**: CONTAINER (despues de dependencias)

**Proposito**: Setup completo de base de datos, migraciones y superuser

**Modulos cargados**:
- core.sh
- logging.sh
- validation.sh
- database_postgres.sh
- database_mariadb.sh
- python.sh

**Pasos ejecutados** (7 steps):

1. **Validar prerequisitos**
   - Django instalado
   - Proyecto Django valido
   - Clientes de base de datos disponibles

2. **Esperar PostgreSQL**
   - Test de conexion (max 120s)
   - Verificar que la base de datos existe
   ```
   Host: db_postgres
   User: postgres
   Database: callcenter_db
   ```

3. **Esperar MariaDB**
   - Test de conexion (max 120s)
   - Verificar que la base de datos existe
   ```
   Host: db_mariadb
   User: root
   Database: callcenter_legacy
   ```

4. **Django system check**
   - Esperar a que Django pueda conectarse a BD
   - Ejecutar `python manage.py check`

5. **Ejecutar migraciones**
   - Migraciones para PostgreSQL (default database)
   - Migraciones para MariaDB (legacy database)
   ```bash
   python manage.py migrate --database=default
   python manage.py migrate --database=legacy
   ```

6. **Crear superuser**
   - Idempotente (skip si ya existe)
   ```
   Username: admin (configurable)
   Email: admin@example.com
   Password: admin
   ```

7. **Marcar completado**
   - Crear `infrastructure/state/post-create.completed`

**Variables de entorno**:
```bash
# PostgreSQL
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=db_postgres
POSTGRES_DB=callcenter_db

# MariaDB
MARIADB_USER=root
MARIADB_ROOT_PASSWORD=root
MARIADB_HOST=db_mariadb
MARIADB_DATABASE=callcenter_legacy

# Django Superuser
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=admin
```

**Logging**:
- Log file: `infrastructure/devcontainer/logs/post-create-YYYYMMDD-HHMMSS.log`

**Ejemplo de salida**:
```
================================================================
DEVCONTAINER - POST-CREATE SETUP
================================================================

[2/7] Waiting for PostgreSQL
[INFO] PostgreSQL connection details:
[INFO]   Host: db_postgres
[INFO]   User: postgres
[INFO]   Database: callcenter_db
[OK] PostgreSQL is ready
[OK] PostgreSQL connection test successful

[5/7] Running Django migrations
[INFO] Running migrations for PostgreSQL (default database)...
[OK] Migrations applied for default database
[INFO] Running migrations for MariaDB (legacy database)...
[OK] Migrations applied for legacy database

[6/7] Creating Django superuser
[INFO] Superuser configuration:
[INFO]   Username: admin
[INFO]   Email: admin@example.com
[OK] Superuser operation completed

================================================================
[OK] postCreate completed successfully
[INFO] Errors: 0, Warnings: 0

[OK] DevContainer is ready to use!
[INFO] Run Django: cd api/callcentersite && python manage.py runserver
================================================================
```

---

### 5. post_start.sh (382 lineas)

**Lifecycle**: `postStartCommand` (CONTAINER)
**Frecuencia**: MULTIPLE (cada vez que se inicia el contenedor)
**Ejecuta en**: CONTAINER (cada inicio)

**Proposito**: Verificaciones rapidas cada vez que el contenedor se inicia

**Restriccion de tiempo**: < 30 segundos

**Caracteristica clave**: Solo VERIFICAR, NO instalar

**Modulos cargados**:
- core.sh
- logging.sh
- validation.sh
- database_postgres.sh
- database_mariadb.sh
- python.sh

**Pasos ejecutados**:

1. **Validar ambiente Python**
   - Python disponible
   - Django instalado

2. **Verificar conectividad PostgreSQL**
   - Test rapido de conexion (max 30s)

3. **Verificar conectividad MariaDB**
   - Test rapido de conexion (max 30s)

4. **Django quick check**
   - Verificar que Django puede conectarse a BD
   - NO ejecutar migraciones

5. **Verificar servicios externos** (opcional)
   - Cassandra logging (si configurado)

6. **Marcar completado**
   - Actualizar `infrastructure/state/post-start.last-run`

**Logging**:
- Log file: `infrastructure/devcontainer/logs/post-start-YYYYMMDD-HHMMSS.log`

**Ejemplo de salida**:
```
================================================================
DEVCONTAINER - POST-START VERIFICATION
================================================================

[1/4] Validating Python environment
[OK] Python 3.12.6 available
[OK] Django 4.2.7 installed

[2/4] Verifying PostgreSQL connectivity
[OK] PostgreSQL connection successful

[3/4] Verifying MariaDB connectivity
[OK] MariaDB connection successful

[4/4] Django quick check
[OK] Django can connect to databases

================================================================
[OK] postStart verification completed
[INFO] Errors: 0, Warnings: 0
[INFO] DevContainer is ready!
================================================================
```

---

### 6. check_no_emojis.sh (192 lineas)

**Proposito**: Validar que NO hay emojis en archivos del proyecto

**Uso**:
- Parte de pre-commit hook
- Validacion en CI/CD
- Ejecutable manualmente

**Patron de emojis detectados**:
- Unicode emoji blocks
- Caracteres especiales (checkmarks, arrows, bullets)

**Exit codes**:
- `0`: No emojis found
- `1`: Emojis detected

---

## Utility Modules

Ubicacion: `infrastructure/devcontainer/utils/`

### 1. core.sh

**Proposito**: Funciones base del sistema

**Funciones principales**:
- `iact_source_module()` - Cargar modulos
- `iact_get_context()` - Detectar contexto (Codespaces, Local, Remote)
- `iact_get_os_info()` - Informacion del OS
- `iact_get_memory_info()` - Memoria disponible
- `iact_get_disk_info()` - Espacio en disco
- `iact_command_exists()` - Verificar comando existe
- `iact_validate_commands_exist()` - Validar multiples comandos
- `iact_validate_dir_exists()` - Verificar directorio
- `iact_validate_file_exists()` - Verificar archivo
- `iact_create_dir()` - Crear directorio (mkdir -p)
- `iact_validate_disk_space()` - Validar espacio minimo

**Ejemplo de uso**:
```bash
source "${UTILS_DIR}/core.sh"

# Cargar modulo
iact_source_module "logging"

# Detectar contexto
context=$(iact_get_context)  # Returns: codespaces | vscode-remote | local

# Validar espacio en disco
if iact_validate_disk_space 5; then
    echo "Suficiente espacio (5GB+)"
fi
```

### 2. logging.sh

**Proposito**: Sistema de logging consistente

**Funciones principales**:
- `iact_init_logging()` - Inicializar logging con nombre
- `iact_get_log_file()` - Obtener ruta del log file
- `iact_log_header()` - Header de log
- `iact_log_separator()` - Separador visual
- `iact_log_step()` - Log de paso (ej: "[1/7] Step name")
- `iact_log_info()` - Mensaje informativo
- `iact_log_success()` - Mensaje de exito
- `iact_log_warning()` - Warning
- `iact_log_error()` - Error
- `iact_log_file_operation()` - Log de operacion de archivo

**Log files**:
- Ubicacion: `infrastructure/devcontainer/logs/`
- Formato: `{script-name}-YYYYMMDD-HHMMSS.log`
- Ejemplo: `on-create-20251109-103045.log`

**Colores en terminal**:
- INFO: Azul
- SUCCESS: Verde
- WARNING: Amarillo
- ERROR: Rojo

**Ejemplo de uso**:
```bash
source "${UTILS_DIR}/core.sh"
iact_source_module "logging"

# Inicializar
iact_init_logging "my-script"

# Logging
iact_log_header "MI SCRIPT"
iact_log_step 1 5 "Validando prerequisites"
iact_log_info "Validando Python..."
iact_log_success "Python 3.12 found"
iact_log_warning "Test requirements missing"
iact_log_error "Database connection failed"
```

### 3. validation.sh

**Proposito**: Funciones de validacion reutilizables

**Funciones principales**:
- `iact_validate_django_project()` - Validar proyecto Django (manage.py)
- `iact_validate_requirements_file()` - Validar requirements.txt
- `iact_validate_python_installed()` - Python disponible
- `iact_validate_python_version()` - Version minima de Python
- `iact_validate_pip_installed()` - pip disponible
- `iact_validate_django_installed()` - Django instalado
- `iact_validate_postgres_client()` - psql disponible
- `iact_validate_mariadb_client()` - mysql disponible

**Ejemplo de uso**:
```bash
source "${UTILS_DIR}/core.sh"
iact_source_module "validation"

# Validar Python
if iact_validate_python_installed; then
    echo "Python available"
fi

if iact_validate_python_version "3.11"; then
    echo "Python >= 3.11"
fi

# Validar proyecto Django
if iact_validate_django_project "/path/to/project"; then
    echo "Valid Django project"
fi
```

### 4. python.sh

**Proposito**: Utilidades para Python y Django

**Funciones principales**:
- `iact_python_get_version()` - Version de Python
- `iact_pip_get_command()` - Comando pip (pip vs pip3)
- `iact_pip_install()` - Instalar paquetes
- `iact_django_get_version()` - Version de Django
- `iact_django_wait_for_db()` - Esperar conexion a BD
- `iact_django_check()` - Ejecutar system check
- `iact_django_has_pending_migrations()` - Verificar migraciones pendientes
- `iact_django_migrate()` - Ejecutar migraciones
- `iact_django_createsuperuser_noninteractive()` - Crear superuser

**Ejemplo de uso**:
```bash
source "${UTILS_DIR}/core.sh"
iact_source_module "python"

# Version de Python
python_version=$(iact_python_get_version)
echo "Python: $python_version"

# Instalar paquete
iact_pip_install "requests"

# Django operations
cd /path/to/django/project
iact_django_wait_for_db "." 120
iact_django_migrate "." "default"
iact_django_createsuperuser_noninteractive "." "admin" "admin@example.com" "admin"
```

### 5. database_postgres.sh

**Proposito**: Utilidades para PostgreSQL

**Funciones principales**:
- `iact_db_postgres_wait()` - Esperar a que PostgreSQL este listo
- `iact_db_postgres_test_connection()` - Test de conexion
- `iact_db_postgres_database_exists()` - Verificar que BD existe
- `iact_db_postgres_run_query()` - Ejecutar query SQL

**Ejemplo de uso**:
```bash
source "${UTILS_DIR}/core.sh"
iact_source_module "database_postgres"

# Esperar PostgreSQL
if iact_db_postgres_wait "postgres" "password" 120 "db_postgres"; then
    echo "PostgreSQL ready"
fi

# Test conexion
if iact_db_postgres_test_connection "postgres" "password" "mydb" "db_postgres"; then
    echo "Connection successful"
fi

# Verificar BD existe
if iact_db_postgres_database_exists "mydb" "postgres" "password" "db_postgres"; then
    echo "Database exists"
fi
```

### 6. database_mariadb.sh

**Proposito**: Utilidades para MariaDB

**Funciones principales**:
- `iact_db_mariadb_wait()` - Esperar a que MariaDB este listo
- `iact_db_mariadb_test_connection()` - Test de conexion
- `iact_db_mariadb_database_exists()` - Verificar que BD existe
- `iact_db_mariadb_run_query()` - Ejecutar query SQL

**Ejemplo de uso**:
```bash
source "${UTILS_DIR}/core.sh"
iact_source_module "database_mariadb"

# Esperar MariaDB
if iact_db_mariadb_wait "root" "password" 120 "db_mariadb"; then
    echo "MariaDB ready"
fi

# Test conexion
if iact_db_mariadb_test_connection "root" "password" "mydb" "db_mariadb"; then
    echo "Connection successful"
fi
```

---

## Configuracion y Variables

### devcontainer.json

**Configuracion principal del DevContainer**

**Lifecycle hooks**:
```json
{
  "initializeCommand": "bash infraestructura/devcontainer/scripts/init_host.sh",
  "onCreateCommand": "bash infraestructura/devcontainer/scripts/on_create.sh",
  "updateContentCommand": "bash infraestructura/devcontainer/scripts/update_content.sh",
  "postCreateCommand": "bash infraestructura/devcontainer/scripts/post_create.sh",
  "postStartCommand": "bash infraestructura/devcontainer/scripts/post_start.sh"
}
```

**Features**:
- Imagen base devcontainers Python 3.12 (Debian Bookworm)
- Git (latest)
- Common utils (zsh, oh-my-zsh)

**VS Code extensions**:
- Python (ms-python.python)
- Django (batisteo.vscode-django)
- PostgreSQL/MySQL (mtxr.sqltools)
- Docker (ms-azuretools.vscode-docker)
- GitLens (eamodio.gitlens)

**Forwarded ports**:
- 8000: Django runserver
- 5432: PostgreSQL
- 3306: MariaDB

### docker_compose.yml

**Servicios**:

1. **app** (DevContainer principal)
   - Image: mcr.microsoft.com/devcontainers/python:3.12-bookworm
   - Python 3.12 preinstalado en la imagen base
   - Workspace: /workspaces/IACT---project
   - env_file: .devcontainer/.env

2. **db_postgres**
   - Image: postgres:15
   - Port: 5432
   - Database: callcenter_db
   - User: postgres
   - Password: postgres
   - env_file: .devcontainer/.env

3. **db_mariadb**
   - Image: mariadb:10.11
   - Port: 3306
   - Database: callcenter_legacy
   - User: root
   - Password: root
   - env_file: .devcontainer/.env

**Volumes**:
- postgres-data: PostgreSQL data
- mariadb-data: MariaDB data

### Variables de Entorno

Todas las variables se cargan desde `.devcontainer/.env`, generado automáticamente a partir de `.devcontainer/.env.example` durante `initializeCommand`. Ajusta los valores según tu entorno (incluyendo hosts/puertos de Vagrant si aplican).

**Plantilla `.devcontainer/.env.example` (valores por defecto)**:
```bash
DJANGO_SETTINGS_MODULE=callcentersite.settings.development
DEBUG=True

POSTGRES_HOST=db_postgres
POSTGRES_PORT=5432
POSTGRES_DB=callcenter_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres

MARIADB_HOST=db_mariadb
MARIADB_PORT=3306
MARIADB_DATABASE=callcenter_legacy
MARIADB_USER=root
MARIADB_ROOT_PASSWORD=root

DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=admin

PYTHONUNBUFFERED=1
PYTHONDONTWRITEBYTECODE=1
TZ=America/Mexico_City
```

**Customizar**:
- Copia `.devcontainer/.env.example` a `.devcontainer/.env` y ajusta credenciales/hosts.
- Si usas Vagrant, apunta `POSTGRES_HOST`/`MARIADB_HOST` a los puertos expuestos por tu VM.

---

## Troubleshooting

### Problema: init_host.sh falla con errores de permisos

**Sintoma**: Scripts no ejecutables

**Solucion**:
```bash
chmod +x infraestructura/devcontainer/scripts/*.sh
```

### Problema: PostgreSQL no responde en post_create.sh

**Sintoma**: "PostgreSQL no respondio en 120s"

**Causas posibles**:
1. Contenedor PostgreSQL no inicio
2. Credenciales incorrectas
3. Red Docker no configurada

**Solucion**:
```bash
# Verificar estado de contenedor
docker ps | grep postgres

# Ver logs de PostgreSQL
docker logs <postgres-container-id>

# Verificar conexion manual
psql -h db_postgres -U postgres -d callcenter_db
```

### Problema: Django migrations fallan

**Sintoma**: "Failed to apply migrations for default database"

**Causas posibles**:
1. Base de datos no existe
2. Modelos con errores
3. Migraciones conflictivas

**Solucion**:
```bash
cd api/callcentersite

# Ver estado de migraciones
python manage.py showmigrations

# Ver error detallado
python manage.py migrate --verbosity=2

# Crear BD manualmente si necesario
psql -h db_postgres -U postgres -c "CREATE DATABASE callcenter_db;"
```

### Problema: update_content.sh toma demasiado tiempo

**Sintoma**: pip install tarda >5 minutos

**Causas posibles**:
1. Network lento
2. Dependencias compiladas (psycopg2, etc.)

**Solucion**:
```bash
# Usar binary wheels
pip install psycopg2-binary  # En lugar de psycopg2

# Verificar network
ping pypi.org
```

### Problema: Logs no se generan

**Sintoma**: No se encuentra log file en infrastructure/devcontainer/logs/

**Causas posibles**:
1. Directorio logs no existe
2. Permisos insuficientes

**Solucion**:
```bash
# Crear directorio
mkdir -p infraestructura/devcontainer/logs

# Verificar permisos
ls -la infraestructura/devcontainer/
```

### Problema: Estado corrupto - contenedor no inicia

**Sintoma**: Errores constantes en cada inicio

**Solucion NUCLEAR**:
```bash
# Eliminar estado completamente
rm -rf infraestructura/state/*
rm -f .devcontainer/.init_completed

# Rebuild contenedor
# En VS Code: Ctrl+Shift+P -> "Dev Containers: Rebuild Container"
```

---

## Comandos Utiles

### Reconstruir contenedor

**VS Code**:
```
Ctrl+Shift+P -> "Dev Containers: Rebuild Container"
```

**CLI**:
```bash
docker-compose -f .devcontainer/docker_compose.yml build --no-cache
```

### Ver logs de lifecycle scripts

```bash
# Logs mas recientes
ls -lt infraestructura/devcontainer/logs/ | head -10

# Ver log especifico
cat infraestructura/devcontainer/logs/post-create-20251109-103045.log

# Tail en tiempo real (durante ejecucion)
tail -f infraestructura/devcontainer/logs/post-create-*.log
```

### Ejecutar script manualmente

```bash
# init_host (desde HOST)
bash infraestructura/devcontainer/scripts/init_host.sh

# Dentro del contenedor
bash infraestructura/devcontainer/scripts/on_create.sh
bash infraestructura/devcontainer/scripts/update_content.sh
bash infraestructura/devcontainer/scripts/post_create.sh
bash infraestructura/devcontainer/scripts/post_start.sh
```

### Verificar estado

```bash
# Ver archivos de estado
ls -la infraestructura/state/

# Ver contenido
cat infraestructura/state/post-create.completed
```

### Limpiar estado

```bash
# Limpiar estado de lifecycle
rm -f infraestructura/state/*.completed
rm -f infraestructura/state/*.last-run

# Limpiar logs antiguos (>7 dias)
find infraestructura/devcontainer/logs/ -name "*.log" -mtime +7 -delete
```

---

## Metricas y Performance

### Tiempos Esperados

| Script | Primera Ejecucion | Re-ejecucion |
|--------|-------------------|--------------|
| init_host.sh | ~5s | ~2s |
| on_create.sh | ~15s | N/A (once) |
| update_content.sh | ~120s | ~5s (si no hay cambios) |
| post_create.sh | ~60s | N/A (once) |
| post_start.sh | ~10s | ~10s |

**Total primera inicializacion**: ~3-4 minutos

**Total reinicio**: ~12 segundos

### Limites de Recursos

**Contenedor app**:
- CPU: No limitado
- Memory: 8GB recomendado
- Disk: 10GB minimo

**PostgreSQL**:
- CPU: 1 core
- Memory: 1GB
- Disk: 5GB

**MariaDB**:
- CPU: 1 core
- Memory: 512MB
- Disk: 2GB

---

## Referencias

### Documentacion Interna

- [CPython Precompilado](../cpython/README.md)
- [Vagrant Dev Environment](../vagrant-dev/README.md)
- [SPEC_INFRA_001](../../specs/SPEC_INFRA_001_cpython_precompilado.md)

### Docker & DevContainers

- [Development Containers Specification](https://containers.dev/)
- [VS Code DevContainers Documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

### Scripts Constitution

- [SHELL_SCRIPTS_CONSTITUTION.md](../../../SHELL_SCRIPTS_CONSTITUTION.md)
- [ESTRATEGIA_GIT_HOOKS.md](../../../ESTRATEGIA_GIT_HOOKS.md)

---

## Changelog

### v1.0.0 (2025-11-09)
- Version inicial de documentacion
- 5 lifecycle scripts documentados (2,381 lineas totales)
- 6 utility modules documentados
- Troubleshooting guide completo
- Metricas y performance benchmarks

---

**Ultima actualizacion**: 2025-11-09
**Mantenedor**: Infrastructure Team
**Estado de documentacion**: COMPLETO
