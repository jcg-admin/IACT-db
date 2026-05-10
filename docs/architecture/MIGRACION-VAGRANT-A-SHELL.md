# Migración: Vagrant → Shell Scripts Puros

**Estado:** Completado  
**Fecha de análisis:** 2026-05-05  
**Autor:** Análisis técnico — IACT DevBox  
**Versión:** 1.0.0

---

## Contexto

IACT-db gestiona actualmente la infraestructura de bases de datos mediante
**Vagrant + VirtualBox**: 3 VMs aisladas en una red host-only `192.168.56.0/24`
con MariaDB 11.4, PostgreSQL 16 y Adminer 4.8.1.

Este documento analiza la viabilidad de reemplazar Vagrant por **shell scripts
puros** que operen directamente sobre el SO host, sin virtualización.

La decisión de **no usar Docker** es explícita. La única alternativa evaluada
es shell scripts nativos sobre Ubuntu/Debian.

---

## Problemas actuales con Vagrant

### 1. Dependencias pesadas del entorno de desarrollo

Vagrant requiere **VirtualBox instalado en el host** y el plugin
`vagrant-goodhosts` para gestionar el archivo `/etc/hosts`. Esto implica:

- 5 GB de RAM reservada permanentemente (2 GB MariaDB + 2 GB PostgreSQL + 1 GB Adminer)
- Tiempos de arranque de 3-8 minutos para `vagrant up` desde cero
- Incompatibilidad con entornos donde VirtualBox no puede ejecutarse
  (WSL2, servidores cloud sin nested virtualization, CI sin soporte de KVM)
- El plugin `vagrant-goodhosts` requiere privilegios de administrador en
  Windows para modificar el archivo `hosts`

### 2. Ubuntu 20.04 focal es EOL desde julio 2025

La box `ubuntu/focal64` usada en el Vagrantfile alcanzó End of Life en
julio 2025. Esto forzó el uso del repositorio archivado de PostgreSQL:

```
deb [...] https://apt-archive.postgresql.org/pub/repos/apt focal-pgdg main
```

El repositorio de MariaDB también podría dejar de servir paquetes para focal
en cualquier momento, rompiendo `vagrant up` en sistemas limpios.

### 3. El Vagrantfile es la única fuente de verdad de configuración

Todas las variables de entorno (`MARIADB_VERSION`, `DB_NAME`, `DB_USER`,
`DB_PASSWORD`, etc.) están definidas en el Vagrantfile y se exportan a las
VMs en el momento del provisioning. Esto significa que:

- Cambiar una contraseña o un nombre de base de datos requiere editar
  un archivo Ruby
- No hay forma de sobrescribir variables sin modificar el Vagrantfile
- El mismo archivo mezcla infraestructura de VMs con configuración de aplicación

### 4. Scripts PowerShell exclusivos para Windows + Vagrant

Los 11 archivos `.ps1` en `scripts/` gestionan exclusivamente aspectos del
entorno Vagrant en Windows (firewall de VirtualBox, certificados SSL de
Adminer en el OS, diagnóstico de VMs). Sin Vagrant no tienen propósito.

### 5. El script de verificación tiene IPs hardcodeadas de las VMs

`test/check_db_connections.py` conecta a `192.168.56.10` y `192.168.56.11` —
las IPs host-only de las VMs. Sin Vagrant, esas IPs no existen y el script
falla sin ningún mensaje útil.

---

## Análisis de reutilización

### Lo que funciona directamente: los `utils/`

Los cinco módulos de utilidades son **reutilizables sin modificación**:

| Archivo | Estado | Observación |
|---|---|---|
| `utils/logging.sh` | Reutilizable | Sin dependencias de Vagrant |
| `utils/core.sh` | Reutilizable | Operaciones de filesystem puras |
| `utils/network.sh` | Reutilizable | Funciones de red agnósticas al entorno |
| `utils/validation.sh` | Reutilizable | Validación de variables y sistema |
| `utils/provisioning.sh` | Reutilizable con ajuste menor | `init_env` ya detecta `PROJECT_ROOT` sin Vagrant |
| `utils/system.sh` | Reutilizable | `apt-get`, timezone, locale — funciona en host directo |

### Lo que mejora: `utils/database.sh`

El `utils/database.sh` de IACT-db tiene las funciones CRUD correctas
(`mysql_create_database`, `postgres_create_user`, etc.) pero le faltan
las mejoras desarrolladas en **IACT-api v1.1.0**:

| Función | IACT-db | IACT-api | Diferencia |
|---|---|---|---|
| Detección de MariaDB | Solo TCP | Socket Unix → TCP | IACT-api más robusto en entornos sin red |
| Cleanup de stale PIDs | No tiene | `mariadb_cleanup_stale()` | IACT-api previene arranque fallido |
| Arranque de MariaDB | No tiene | `db_start_mariadb()` | IACT-api usa `mariadbd` (mysqld_safe deprecado) |
| Espera activa | `while ! mysqladmin ping` | Polling con timeout explícito | IACT-api más preciso |
| Funciones CRUD MySQL | Completas | No tiene (delegado a provisioners) | IACT-db más completo aquí |
| Funciones CRUD PostgreSQL | Completas | No tiene | IACT-db más completo aquí |

La versión fusionada combina las funciones CRUD de IACT-db con las
mejoras de arranque y detección de IACT-api.

### Lo que necesita cambio: rutas `/vagrant/` hardcodeadas

Todos los provisioners referencian `/vagrant/` como raíz del proyecto.
Esta ruta la monta Vagrant automáticamente en cada VM. Sin Vagrant no existe.

Archivos afectados:

```
provisioners/mariadb/bootstrap.sh   — source /vagrant/utils/provisioning.sh
provisioners/mariadb/install.sh     — source /vagrant/utils/core.sh, logging.sh...
provisioners/mariadb/setup.sh       — source /vagrant/utils/..., ensure_dir /vagrant/logs
provisioners/postgres/bootstrap.sh  — source /vagrant/utils/provisioning.sh
provisioners/postgres/install.sh    — source /vagrant/utils/...
provisioners/postgres/setup.sh      — source /vagrant/utils/..., systemctl is-active
provisioners/adminer/bootstrap.sh   — source /vagrant/utils/provisioning.sh
```

La solución es el mismo patrón que ya usa `utils/provisioning.sh`:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
```

### Lo que necesita cambio: `systemctl` sin detección previa

Tres provisioners llaman a `systemctl is-active` directamente:

```bash
# provisioners/mariadb/setup.sh
if ! systemctl is-active --quiet mariadb; then ...

# provisioners/postgres/setup.sh
if ! systemctl is-active --quiet postgresql; then ...

# provisioners/adminer/ssl.sh
if ! systemctl is-active --quiet apache2; then ...
```

En entornos sin systemd (WSL2, contenedores, servidores minimal) esto falla.
IACT-api ya resolvió esto con detección por socket Unix y fallback TCP.

Se introduce un wrapper `service_is_active()` que intenta systemctl, luego
`service`, luego los binarios directamente (`mysqladmin ping`, `pg_isready`).

### Lo que cambia de propósito: configuración de red en `install.sh`

Los `install.sh` actuales configuran los servicios para aceptar conexiones
remotas desde `192.168.56.0/24` — la red host-only de Vagrant. En un host
directo, los servicios escuchan en `127.0.0.1` (loopback) por defecto, que
es lo correcto para desarrollo local. Los accesos remotos se configuran solo
si se necesitan explícitamente (staging/producción).

---

## Plan de implementación

### Estructura resultante del repositorio

```
IACT-db/
│
├── .env.example             # fuente de verdad de configuración (reemplaza Vagrantfile)
├── .env                     # copia local ignorada por .gitignore
│
├── bootstrap.sh             # punto de entrada: instala y configura todo
├── setup.sh                 # solo setup de BD (BDs ya instaladas)
├── verify.sh                # verifica conectividad y estado
│
├── utils/                   # sin cambios excepto database.sh
│   ├── core.sh
│   ├── logging.sh
│   ├── network.sh
│   ├── validation.sh
│   ├── provisioning.sh      # ajuste menor: eliminar ref a /vagrant
│   ├── system.sh
│   └── database.sh          # FUSIÓN: IACT-db CRUD + mejoras IACT-api v1.1.0
│
├── provisioners/
│   ├── mariadb/
│   │   ├── bootstrap.sh     # orquestador: system → install → setup
│   │   ├── install.sh       # instala MariaDB 11.4 via apt (sin bind 0.0.0.0 por defecto)
│   │   └── setup.sh         # crea BD/usuario/privilegios — portado de IACT-api
│   ├── postgres/
│   │   ├── bootstrap.sh
│   │   ├── install.sh       # instala PostgreSQL 16 via apt
│   │   └── setup.sh         # portado de IACT-api (incluye schema public perms)
│   └── adminer/
│       ├── bootstrap.sh
│       ├── install.sh       # instala Apache + PHP + Adminer (sin cambios de lógica)
│       ├── ssl.sh           # SSL con openssl (sin cambios de lógica)
│       └── swap.sh          # configuración de swap (sin cambios)
│
├── test/
│   ├── check_db_connections.py   # IPs y credenciales desde .env
│   └── requirements.txt
│
├── config/                  # sin cambios (certs SSL, vhost Apache)
│   ├── certs/
│   └── vhost.conf
│
├── docs/                    # este archivo + actualizaciones
│
└── archive/                 # referencia histórica, no funcional
    ├── Vagrantfile
    └── scripts/             # los 11 .ps1 de Windows/Vagrant
```

### Cambios por archivo

#### `.env.example` (nuevo — reemplaza las variables del Vagrantfile)

```bash
# MariaDB
MARIADB_VERSION=11.4
DB_MARIADB_NAME=ivr_legacy
DB_MARIADB_USER=django_user
DB_MARIADB_PASSWORD=django_pass
DB_MARIADB_ROOT_PASSWORD=rootpass123
DB_CHARSET=utf8mb4
DB_COLLATION=utf8mb4_unicode_ci
MARIADB_HOST=127.0.0.1
MARIADB_PORT=3306

# PostgreSQL
POSTGRES_VERSION=16
DB_POSTGRES_NAME=iact_analytics
DB_POSTGRES_USER=django_user
DB_POSTGRES_PASSWORD=django_pass
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432

# Adminer
ADMINER_VERSION=4.8.1
ADMINER_DOMAIN=adminer.local
SSL_DAYS=365
```

#### `bootstrap.sh` (nuevo — reemplaza `vagrant up`)

```
bootstrap.sh
  ├── carga .env
  ├── valida que se ejecuta como root
  ├── valida OS (Ubuntu/Debian)
  ├── llama provisioners/mariadb/bootstrap.sh
  ├── llama provisioners/postgres/bootstrap.sh
  ├── llama provisioners/adminer/bootstrap.sh (opcional)
  └── llama verify.sh al final
```

#### `utils/database.sh` (fusión)

```
Conservar de IACT-db:
  mysql_execute, mysql_database_exists, mysql_user_exists
  mysql_create_database, mysql_create_user, mysql_grant_privileges
  postgres_execute, postgres_database_exists, postgres_user_exists
  postgres_create_database, postgres_create_user, postgres_grant_privileges
  postgres_allow_remote, wait_for_database, test_db_connection

Incorporar de IACT-api v1.1.0:
  mariadb_is_running()     — detección socket Unix → TCP
  mariadb_cleanup_stale()  — limpia PID/sock de procesos muertos
  mariadb_wait_ready()     — polling activo con timeout explícito
  db_start_mariadb()       — arranque con mariadbd (reemplaza mysqld_safe)
  db_start_postgres()      — arranque con pg_ctlcluster

Renombrar para consistencia:
  mysql_is_running → mariadb_is_running (alias hacia la función mejorada)
  mysql_wait_ready → mariadb_wait_ready (alias)
```

#### Todos los `provisioners/*/bootstrap.sh` y `install.sh`

Reemplazar:
```bash
source /vagrant/utils/provisioning.sh
ensure_dir /vagrant/logs
source /vagrant/provisioners/...
```

Por:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${PROJECT_ROOT}/utils/provisioning.sh"
ensure_dir "${PROJECT_ROOT}/logs"
```

#### `provisioners/mariadb/setup.sh` y `provisioners/postgres/setup.sh`

Portar las versiones más maduras de IACT-api que incluyen:

- MariaDB: privilegios READ-ONLY separados para la BD de producción vs
  CREATE/DROP para la BD de tests (`test_ivr_legacy`)
- PostgreSQL: `ALTER DEFAULT PRIVILEGES` para tablas y secuencias futuras,
  `ALTER ROLE django_user CREATEDB` para que pytest cree `test_iact_analytics`
- Verificación de conexión con las credenciales Django al final de cada setup

#### `test/check_db_connections.py`

Las IPs hardcodeadas se reemplazan por lectura del archivo `.env`:

```python
# Antes (hardcodeado a las VMs)
MARIADB_CONFIG = {"host": "192.168.56.10", ...}
POSTGRES_CONFIG = {"host": "192.168.56.11", ...}

# Después (desde .env)
MARIADB_CONFIG = {
    "host": os.getenv("MARIADB_HOST", "127.0.0.1"),
    "port": int(os.getenv("MARIADB_PORT", "3306")),
    ...
}
```

---

## Compatibilidad del entorno objetivo

Los scripts resultantes son compatibles con:

| Entorno | Compatible | Observación |
|---|---|---|
| Ubuntu 22.04 LTS (Jammy) | Si | Entorno primario |
| Ubuntu 24.04 LTS (Noble) | Si | Probado |
| Debian 12 (Bookworm) | Si | Mismos repositorios apt |
| WSL2 (Ubuntu) | Si | Sin systemd: service_is_active() maneja el fallback |
| Servidor Linux directo | Si | Propósito principal |
| macOS | No | Los repositorios apt y los paths de servicio son Linux-only |
| Windows nativo | No | Requiere WSL2 como intermediario |
| CI/CD Linux | Si | GitHub Actions, GitLab CI, Jenkins en Linux |

---

## Lo que NO cambia

- La lógica de instalación de MariaDB y PostgreSQL (mismos repositorios apt)
- El flujo bootstrap → install → setup en cada componente
- Los `utils/` (excepto `database.sh` que mejora)
- La configuración de Apache y SSL de Adminer
- La estructura de directorios general del repositorio
- La idempotencia de todos los scripts (se puede ejecutar N veces)

---

## Decisión descartada: Docker

Docker fue evaluado y descartado explícitamente. No se documenta como
alternativa futura para mantener el documento enfocado en la implementación
decidida.

---

## Historial

| Versión | Fecha | Cambio |
|---|---|---|
| 1.0.0 | 2026-05-05 | Análisis inicial. Plan de migración documentado. |
| 1.1.0 | 2026-05-05 | Migración implementada en su totalidad. Commits `6085696` y `f5f0472`. |
