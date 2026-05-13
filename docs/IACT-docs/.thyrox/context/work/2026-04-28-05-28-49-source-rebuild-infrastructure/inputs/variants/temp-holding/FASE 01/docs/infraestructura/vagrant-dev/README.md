# Vagrant Development Environment

**Autor**: Infrastructure Team
**Fecha**: 2025-11-09
**Estado**: ACTIVO

## Indice

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Arquitectura](#arquitectura)
- [Instalacion y Setup](#instalacion-y-setup)
- [Scripts de Aprovisionamiento](#scripts-de-aprovisionamiento)
- [Configuracion de Bases de Datos](#configuracion-de-bases-de-datos)
- [Testing y Verificacion](#testing-y-verificacion)
- [Troubleshooting](#troubleshooting)
- [Referencias](#referencias)

---

## Resumen Ejecutivo

El Vagrant Development Environment de IACT es un entorno de desarrollo portable y reproducible que provee:

- **MariaDB 11.4 LTS** para base de datos legacy (IVR)
- **PostgreSQL 16** como base de datos principal (Analytics)
- **Ubuntu 20.04 LTS** como sistema operativo base
- **Setup automatizado** con bootstrap script modular
- **Port forwarding** para acceso desde host

**Proposito principal**: Proveer entorno de bases de datos consistente para desarrollo local sin Docker.

**Use cases**:
- Desarrollo local sin DevContainer
- Testing de migraciones en entorno limpio
- Debugging de issues especificos de bases de datos
- Aprendizaje de configuracion de PostgreSQL/MariaDB

---

## Arquitectura

### Diagrama de Componentes

```
[HOST Machine]
      |
      | vagrant up
      v
[VirtualBox VM - Ubuntu 20.04]
┌─────────────────────────────────────┐
│  VM: iact-devbox                     │
│  IP: 10.0.2.10                       │
│  RAM: 4GB, CPU: 2 cores              │
├─────────────────────────────────────┤
│                                      │
│  ┌─────────────────────────────┐   │
│  │  PostgreSQL 16               │   │
│  │  Port: 5432 (guest)          │   │
│  │  Database: iact_analytics    │   │
│  │  User: django_user           │   │
│  └─────────────────────────────┘   │
│           |                          │
│           | Port forwarding          │
│           v                          │
│        localhost:15432 (host)       │
│                                      │
│  ┌─────────────────────────────┐   │
│  │  MariaDB 11.4 LTS            │   │
│  │  Port: 3306 (guest)          │   │
│  │  Database: ivr_legacy        │   │
│  │  User: django_user           │   │
│  └─────────────────────────────┘   │
│           |                          │
│           | Port forwarding          │
│           v                          │
│        localhost:13306 (host)       │
│                                      │
└─────────────────────────────────────┘
```

### Especificaciones

| Componente | Detalles |
|------------|----------|
| **Base Box** | ubuntu/focal64 (>= 20220101.0.0) |
| **Hostname** | callcenter-analytics |
| **VM Name** | iact-devbox |
| **Network** | Private network (10.0.2.10) |
| **RAM** | 4096 MB (4 GB) |
| **CPUs** | 2 cores |
| **Disk** | 40 GB dinamico |

---

## Instalacion y Setup

### Prerequisitos

#### 1. Instalar VirtualBox

**Linux**:
```bash
sudo apt-get update
sudo apt-get install virtualbox
```

**macOS**:
```bash
brew install --cask virtualbox
```

**Windows**:
Descargar desde [VirtualBox Downloads](https://www.virtualbox.org/wiki/Downloads)

#### 2. Instalar Vagrant

**Linux**:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install vagrant
```

**macOS**:
```bash
brew install vagrant
```

**Windows**:
Descargar desde [Vagrant Downloads](https://www.vagrantup.com/downloads)

#### 3. Verificar Instalacion

```bash
vagrant --version  # Esperado: Vagrant 2.3.x o superior
VBoxManage --version  # Esperado: 6.x o 7.x
```

---

### Setup Inicial

#### 1. Navegar al directorio

```bash
cd infraestructura/vagrant
```

#### 2. Levantar VM (Primera vez)

```bash
vagrant up
```

**Duracion esperada**: 15-20 minutos (descarga box + aprovisionamiento)

**Salida esperada**:
```
======================================================================
  IACT DevBox Configuration
======================================================================
VM:
  Name: iact-devbox
  Hostname: callcenter-analytics
  Resources: 4096MB RAM, 2 CPUs
  Network: 10.0.2.10

Port Forwarding:
  PostgreSQL: localhost:15432 -> guest:5432
  MariaDB:    localhost:13306 -> guest:3306

Databases:
  MariaDB:    ivr_legacy (root: rootpass123)
  PostgreSQL: iact_analytics (postgres: postgrespass123)
  App User:   django_user (pass: django_pass)
======================================================================

==> iact-devbox: Importing base box 'ubuntu/focal64'...
...
[STEP 1/5] system_prepare.sh
...
[STEP 5/5] setup_postgres_database.sh
...
[SUCCESS] Bootstrap completado exitosamente
```

#### 3. Verificar VM esta corriendo

```bash
vagrant status
```

**Salida esperada**:
```
Current machine states:

default                   running (virtualbox)
```

---

## Scripts de Aprovisionamiento

Ubicacion: `infrastructure/vagrant/`

### bootstrap.sh (689 lineas)

**Proposito**: Orchestrator principal del aprovisionamiento

**Ejecucion**: Automatica en `vagrant up` o manual con `vagrant provision`

**Pasos ejecutados** (5 steps):

1. **system_prepare.sh** - Preparacion del sistema
2. **mariadb_install.sh** - Instalacion de MariaDB
3. **postgres_install.sh** - Instalacion de PostgreSQL
4. **setup_mariadb_database.sh** - Setup BD MariaDB
5. **setup_postgres_database.sh** - Setup BD PostgreSQL

**Modulos cargados**:
- core.sh (funciones base)
- logging.sh (sistema de logs)
- validation.sh (validaciones)
- database.sh (utilidades BD)

**Variables de entorno**:
```bash
PROJECT_ROOT=/vagrant
LOGS_DIR=/vagrant/logs
DB_ROOT_PASSWORD=rootpass123
DB_PASSWORD=postgrespass123
IVR_DB_NAME=ivr_legacy
DJANGO_DB_NAME=iact_analytics
DJANGO_DB_USER=django_user
DJANGO_DB_PASSWORD=django_pass
MARIADB_VERSION=11.4
POSTGRES_VERSION=16
```

**Logging**:
- Log file: `/vagrant/logs/bootstrap-YYYYMMDD-HHMMSS.log`

**Control de idempotencia**:
- Usa marker files en `/var/iact/state/`
- Puede ejecutarse multiples veces sin error

---

### 1. system_prepare.sh (394 lineas)

**Proposito**: Preparar sistema operativo base

**Tareas ejecutadas**:

1. **Update apt repositories**
   ```bash
   apt-get update
   apt-get upgrade -y
   ```

2. **Instalar dependencias comunes**
   ```bash
   apt-get install -y \
     curl wget git vim \
     build-essential \
     software-properties-common
   ```

3. **Configurar timezone**
   ```bash
   timedatectl set-timezone America/Bogota
   ```

4. **Configurar locales**
   ```bash
   locale-gen en_US.UTF-8
   update-locale LANG=en_US.UTF-8
   ```

5. **Crear directorios de estado**
   ```bash
   mkdir -p /var/iact/state
   ```

**Marker file**: `/var/iact/state/system-prepared`

---

### 2. mariadb_install.sh (497 lineas)

**Proposito**: Instalar MariaDB 11.4 LTS

**Tareas ejecutadas**:

1. **Agregar MariaDB repository**
   ```bash
   curl -LsS https://mariadb.org/mariadb_repo_setup | \
     bash -s -- --mariadb-server-version=11.4
   ```

2. **Instalar MariaDB Server**
   ```bash
   apt-get install -y mariadb-server mariadb-client
   ```

3. **Configurar MariaDB**
   - Bind address: 0.0.0.0 (acceso desde host)
   - Character set: utf8mb4
   - Collation: utf8mb4_unicode_ci
   - Max connections: 200

4. **Configurar root password**
   ```bash
   mysqladmin -u root password "$DB_ROOT_PASSWORD"
   ```

5. **Habilitar y arrancar servicio**
   ```bash
   systemctl enable mariadb
   systemctl start mariadb
   ```

**Archivos de configuracion**:
- `/etc/mysql/mariadb.conf.d/50-server.cnf` (bind-address)
- `/etc/mysql/conf.d/charset.cnf` (character set)

**Marker file**: `/var/iact/state/mariadb-installed`

---

### 3. postgres_install.sh (566 lineas)

**Proposito**: Instalar PostgreSQL 16

**Tareas ejecutadas**:

1. **Agregar PostgreSQL repository**
   ```bash
   curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
     gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg
   echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" | \
     tee /etc/apt/sources.list.d/pgdg.list
   ```

2. **Instalar PostgreSQL 16**
   ```bash
   apt-get update
   apt-get install -y postgresql-16 postgresql-client-16
   ```

3. **Configurar PostgreSQL**
   - listen_addresses: '*' (acceso desde host)
   - max_connections: 200
   - shared_buffers: 256MB
   - effective_cache_size: 1GB

4. **Configurar autenticacion**
   - pg_hba.conf: trust para red local
   - Configurar password para usuario postgres

5. **Habilitar y arrancar servicio**
   ```bash
   systemctl enable postgresql
   systemctl restart postgresql
   ```

**Archivos de configuracion**:
- `/etc/postgresql/16/main/postgresql.conf`
- `/etc/postgresql/16/main/pg_hba.conf`

**Marker file**: `/var/iact/state/postgres-installed`

---

### 4. setup_mariadb_database.sh (379 lineas)

**Proposito**: Crear base de datos y usuario para MariaDB

**Tareas ejecutadas**:

1. **Crear database ivr_legacy**
   ```sql
   CREATE DATABASE IF NOT EXISTS ivr_legacy
     CHARACTER SET utf8mb4
     COLLATE utf8mb4_unicode_ci;
   ```

2. **Crear usuario django_user**
   ```sql
   CREATE USER IF NOT EXISTS 'django_user'@'%'
     IDENTIFIED BY 'django_pass';
   ```

3. **Grant permisos**
   ```sql
   GRANT ALL PRIVILEGES ON ivr_legacy.*
     TO 'django_user'@'%';
   FLUSH PRIVILEGES;
   ```

4. **Seed data inicial** (opcional)
   - Crear tablas de ejemplo
   - Insertar datos de prueba

**Verificacion**:
```bash
mysql -u django_user -p'django_pass' -e "SHOW DATABASES;"
```

**Marker file**: `/var/iact/state/mariadb-database-setup`

---

### 5. setup_postgres_database.sh (453 lineas)

**Proposito**: Crear base de datos y usuario para PostgreSQL

**Tareas ejecutadas**:

1. **Crear database iact_analytics**
   ```sql
   CREATE DATABASE iact_analytics
     WITH ENCODING='UTF8'
          LC_COLLATE='en_US.UTF-8'
          LC_CTYPE='en_US.UTF-8'
          TEMPLATE=template0;
   ```

2. **Crear usuario django_user**
   ```sql
   CREATE USER django_user WITH PASSWORD 'django_pass';
   ```

3. **Grant permisos**
   ```sql
   GRANT ALL PRIVILEGES ON DATABASE iact_analytics
     TO django_user;
   ```

4. **Configurar schema**
   ```sql
   ALTER DATABASE iact_analytics OWNER TO django_user;
   ```

**Verificacion**:
```bash
psql -h localhost -U django_user -d iact_analytics -c "\l"
```

**Marker file**: `/var/iact/state/postgres-database-setup`

---

## Configuracion de Bases de Datos

### PostgreSQL

**Conexion desde HOST**:
```bash
psql -h localhost -p 15432 -U postgres -d iact_analytics
# Password: postgrespass123
```

**Conexion desde Django**:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'iact_analytics',
        'USER': 'django_user',
        'PASSWORD': 'django_pass',
        'HOST': 'localhost',
        'PORT': '15432',
    }
}
```

**pgAdmin Connection**:
```
Host: localhost
Port: 15432
Database: iact_analytics
Username: django_user
Password: django_pass
```

---

### MariaDB

**Conexion desde HOST**:
```bash
mysql -h 127.0.0.1 -P 13306 -u django_user -p'django_pass' ivr_legacy
```

**Conexion desde Django**:
```python
DATABASES = {
    'legacy': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'ivr_legacy',
        'USER': 'django_user',
        'PASSWORD': 'django_pass',
        'HOST': '127.0.0.1',
        'PORT': '13306',
        'OPTIONS': {
            'charset': 'utf8mb4',
        }
    }
}
```

**MySQL Workbench Connection**:
```
Hostname: 127.0.0.1
Port: 13306
Username: django_user
Password: django_pass
Default Schema: ivr_legacy
```

---

## Testing y Verificacion

Ubicacion: `infrastructure/vagrant/tests/`

### 1. bootstrap_test.sh

**Proposito**: Test completo del aprovisionamiento

**Ejecucion**:
```bash
vagrant ssh -c "bash /vagrant/tests/bootstrap_test.sh"
```

**Tests ejecutados**:
1. Verificar MariaDB instalado
2. Verificar PostgreSQL instalado
3. Verificar databases creadas
4. Verificar usuarios tienen permisos
5. Verificar servicios corriendo

**Exit codes**:
- `0`: Todos los tests PASS
- `1`: Al menos un test FAIL

---

### 2. verify_connections.sh

**Proposito**: Verificar conectividad a bases de datos

**Ejecucion**:
```bash
vagrant ssh -c "bash /vagrant/tests/verify_connections.sh"
```

**Tests de conexion**:
1. PostgreSQL localhost connection
2. MariaDB localhost connection
3. PostgreSQL remote connection (desde VM)
4. MariaDB remote connection (desde VM)

**Salida esperada**:
```
[OK] PostgreSQL connection successful
[OK] MariaDB connection successful
```

---

### 3. seed_data.sh

**Proposito**: Poblar bases de datos con datos de prueba

**Ejecucion**:
```bash
vagrant ssh -c "bash /vagrant/tests/seed_data.sh"
```

**Datos insertados**:
- PostgreSQL: Tablas de ejemplo con 1000 rows
- MariaDB: Tablas legacy con 500 rows

---

## Troubleshooting

### Problema: vagrant up falla con VT-x error

**Sintoma**:
```
VBoxManage: error: VT-x is not available
```

**Causa**: Virtualizacion deshabilitada en BIOS

**Solucion**:
1. Reiniciar y entrar a BIOS (F2 o DEL)
2. Buscar "Virtualization Technology" o "VT-x"
3. Habilitar y guardar
4. Reiniciar y ejecutar `vagrant up` nuevamente

---

### Problema: Port 15432 ya en uso

**Sintoma**:
```
Vagrant cannot forward the specified ports on this VM, since they
would collide with some other application that is already listening
```

**Solucion Option 1**: Cambiar puerto en Vagrantfile
```ruby
POSTGRES_PORT = 25432  # Cambiar a puerto libre
```

**Solucion Option 2**: Terminar proceso en puerto
```bash
# Linux/macOS
lsof -i :15432
kill -9 <PID>

# Windows
netstat -ano | findstr :15432
taskkill /PID <PID> /F
```

---

### Problema: PostgreSQL no acepta conexiones remotas

**Sintoma**:
```
psql: could not connect to server: Connection refused
```

**Causa**: pg_hba.conf no configurado correctamente

**Solucion**:
```bash
vagrant ssh
sudo nano /etc/postgresql/16/main/pg_hba.conf

# Agregar linea:
host    all             all             10.0.2.0/24             trust

sudo systemctl restart postgresql
```

---

### Problema: MariaDB authentication error

**Sintoma**:
```
ERROR 1045 (28000): Access denied for user 'django_user'@'localhost'
```

**Solucion**:
```bash
vagrant ssh
mysql -u root -p'rootpass123'

-- Re-crear usuario
DROP USER IF EXISTS 'django_user'@'%';
CREATE USER 'django_user'@'%' IDENTIFIED BY 'django_pass';
GRANT ALL PRIVILEGES ON ivr_legacy.* TO 'django_user'@'%';
FLUSH PRIVILEGES;
```

---

### Problema: VM lenta o sin respuesta

**Sintoma**: VM consume 100% CPU o toma mucho tiempo en responder

**Solucion**:
```bash
# Aumentar recursos en Vagrantfile
VM_MEMORY = 8192  # 8 GB
VM_CPUS = 4

# Re-provisionar
vagrant reload
```

---

### Problema: Aprovisionamiento falla en MariaDB install

**Sintoma**:
```
[ERROR] mariadb_install.sh fallo con codigo: 1
```

**Solucion**:
```bash
# Limpiar estado y re-provisionar
vagrant ssh
sudo rm /var/iact/state/mariadb-installed
exit

vagrant provision
```

---

### Problema: Logs no se generan

**Sintoma**: Directorio /vagrant/logs vacio

**Solucion**:
```bash
vagrant ssh
sudo mkdir -p /vagrant/logs
sudo chmod 777 /vagrant/logs
exit

vagrant provision
```

---

## Comandos Utiles

### Lifecycle de VM

```bash
# Levantar VM
vagrant up

# Detener VM (apagar)
vagrant halt

# Reiniciar VM
vagrant reload

# Destruir VM (eliminar completamente)
vagrant destroy

# Re-aprovisionar (ejecutar bootstrap.sh nuevamente)
vagrant provision
```

### SSH y Debugging

```bash
# Conectar a VM via SSH
vagrant ssh

# Ejecutar comando en VM sin entrar
vagrant ssh -c "comando"

# Ver status de VM
vagrant status

# Ver status global (todas las VMs)
vagrant global-status
```

### Bases de Datos

```bash
# Conectar a PostgreSQL desde HOST
psql -h localhost -p 15432 -U django_user -d iact_analytics

# Conectar a MariaDB desde HOST
mysql -h 127.0.0.1 -P 13306 -u django_user -p'django_pass' ivr_legacy

# Conectar a PostgreSQL desde VM
vagrant ssh -c "psql -U postgres -d iact_analytics"

# Conectar a MariaDB desde VM
vagrant ssh -c "mysql -u root -p'rootpass123' ivr_legacy"
```

### Logs

```bash
# Ver logs de aprovisionamiento
cat infraestructura/vagrant/logs/bootstrap-*.log

# Ver logs de PostgreSQL
vagrant ssh -c "sudo tail -f /var/log/postgresql/postgresql-16-main.log"

# Ver logs de MariaDB
vagrant ssh -c "sudo tail -f /var/log/mysql/error.log"
```

### Mantenimiento

```bash
# Limpiar cache de Vagrant
vagrant box prune

# Actualizar box
vagrant box update

# Verificar version de box
vagrant box list
```

---

## Performance y Recursos

### Uso de Recursos

**Sin carga**:
- RAM: ~1.5 GB (de 4 GB asignados)
- CPU: 5-10%
- Disk: ~8 GB

**Con Django + queries**:
- RAM: ~2.5 GB
- CPU: 20-40%
- Disk: ~10 GB

### Optimizaciones

**1. Aumentar RAM**:
```ruby
VM_MEMORY = 8192  # 8 GB para mejor performance
```

**2. Aumentar shared_buffers (PostgreSQL)**:
```bash
vagrant ssh
sudo nano /etc/postgresql/16/main/postgresql.conf

# Cambiar:
shared_buffers = 512MB  # Era 256MB
effective_cache_size = 2GB  # Era 1GB

sudo systemctl restart postgresql
```

**3. Aumentar buffer pool (MariaDB)**:
```bash
vagrant ssh
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf

# Agregar:
innodb_buffer_pool_size = 512M

sudo systemctl restart mariadb
```

---

## Comparacion con DevContainer

| Aspecto | Vagrant | DevContainer |
|---------|---------|--------------|
| **OS** | Ubuntu 20.04 | Ubuntu 22.04 |
| **Bases de Datos** | MariaDB + PostgreSQL | MariaDB + PostgreSQL |
| **Python** | Sistema | CPython precompilado |
| **Isolation** | VM completa (VirtualBox) | Container (Docker) |
| **Performance** | Mas lento (overhead VM) | Mas rapido |
| **Portabilidad** | Moderada (requiere VirtualBox) | Alta (solo Docker) |
| **Startup** | ~2 minutos | ~30 segundos |
| **Disk Usage** | ~10 GB | ~5 GB |
| **Use Case** | Desarrollo sin Docker | Desarrollo moderno |

**Cuando usar Vagrant**:
- NO tienes Docker/DevContainer
- Necesitas VM completa (no container)
- Testing de infraestructura

**Cuando usar DevContainer**:
- Desarrollo moderno
- CI/CD con GitHub Actions
- Performance es prioridad

---

## Referencias

### Documentacion Interna

- [DevContainer Documentation](../devcontainer/README.md)
- [CPython Precompilado](../cpython/README.md)
- [Migrations Strategy](../../backend/migrations-strategy.md)

### Vagrant Documentation

- [Vagrant Official Documentation](https://www.vagrantup.com/docs)
- [Vagrant Box ubuntu/focal64](https://app.vagrantup.com/ubuntu/boxes/focal64)
- [VirtualBox Documentation](https://www.virtualbox.org/manual/)

### Database Documentation

- [PostgreSQL 16 Documentation](https://www.postgresql.org/docs/16/)
- [MariaDB 11.4 Documentation](https://mariadb.com/kb/en/mariadb-1140-release-notes/)

---

## Changelog

### v1.0.0 (2025-11-09)
- Version inicial de documentacion
- 5 scripts de aprovisionamiento documentados (2,978 lineas totales)
- Setup, configuracion y troubleshooting completos
- Comparacion con DevContainer

---

**Ultima actualizacion**: 2025-11-09
**Mantenedor**: Infrastructure Team
**Estado de documentacion**: COMPLETO
