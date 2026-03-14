# IACT DevBox - Provisioners

Explicación de cómo funcionan los scripts de provisioning de IACT DevBox.

## ¿Qué Son los Provisioners?

Los provisioners son scripts Bash que se ejecutan **dentro de las VMs** durante `vagrant up` para instalar y configurar software.

IACT DevBox tiene 3 conjuntos de provisioners, uno para cada VM:

```
provisioners/
├── mariadb/          # Scripts para VM MariaDB
│   ├── bootstrap.sh  # Orquestador principal
│   ├── install.sh    # Instalación de MariaDB
│   └── setup.sh      # Configuración de usuarios y bases
├── postgres/         # Scripts para VM PostgreSQL
│   ├── bootstrap.sh
│   ├── install.sh
│   └── setup.sh
└── adminer/          # Scripts para VM Adminer
    ├── bootstrap.sh
    ├── install.sh
    ├── ssl.sh        # Configuración de HTTPS
    └── swap.sh       # Configuración de swap
```

## Flujo de Provisioning

Cuando ejecutas `vagrant up`, Vagrant ejecuta los provisioners en este orden:

```
1. vagrant up
   ↓
2. Vagrant crea la VM
   ↓
3. Vagrant ejecuta system_prepare (común a todas las VMs)
   ↓
4. Vagrant ejecuta bootstrap.sh de la VM específica
   ↓
5. bootstrap.sh ejecuta los demás scripts (install.sh, setup.sh, etc.)
   ↓
6. VM lista
```

## Anatomía de un Provisioner

### bootstrap.sh

Es el script principal que orquestra todos los demás. Todos los `bootstrap.sh` tienen esta estructura:

```bash
#!/bin/bash

# 1. Cargar utilidades compartidas
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/validation.sh

# 2. Inicializar logging
init_logging "mariadb" "bootstrap"
log_section "PROVISIONING: MariaDB 11.4"

# 3. Ejecutar pasos de provisioning
log_info "Step 1: Installing MariaDB..."
bash /vagrant/provisioners/mariadb/install.sh

log_info "Step 2: Setting up users..."
bash /vagrant/provisioners/mariadb/setup.sh

# 4. Finalizar
log_success "Provisioning completed successfully"
```

### install.sh

Instala el software principal (MariaDB, PostgreSQL, Apache + Adminer).

Ejemplo (MariaDB):

```bash
#!/bin/bash
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh

log_info "Installing MariaDB 11.4..."

# Agregar repositorio
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64] http://mirror.lstn.net/mariadb/repo/11.4/ubuntu focal main'

# Instalar
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server

log_success "MariaDB installed"
```

### setup.sh

Configura usuarios, bases de datos, permisos.

Ejemplo (MariaDB):

```bash
#!/bin/bash
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh
source /vagrant/utils/database.sh

log_info "Setting up MariaDB users and databases..."

# Crear base de datos
db_mariadb_create "ivr_legacy"

# Crear usuarios
db_mariadb_user "django_user" "django_pass" "ivr_legacy"

log_success "MariaDB setup completed"
```

## Sistema de Utils Compartido

Los provisioners usan funciones compartidas del directorio `utils/`:

```
utils/
├── core.sh           # Funciones core (check_command, etc.)
├── logging.sh        # Sistema de logging (log_info, log_error, etc.)
├── database.sh       # Funciones de BD (db_mariadb_create, etc.)
├── network.sh        # Funciones de red (wait_for_port, etc.)
├── provisioning.sh   # Helpers de provisioning
├── system.sh         # Funciones de sistema (install_package, etc.)
└── validation.sh     # Validaciones (validate_ip, etc.)
```

### Ejemplo: Funciones de logging.sh

```bash
log_info "Mensaje informativo"     # [INFO] Mensaje...
log_success "Operación exitosa"    # [SUCCESS] Operación...
log_warning "Advertencia"          # [WARNING] Advertencia...
log_error "Error crítico"          # [ERROR] Error...
log_section "NUEVA SECCIÓN"        # === NUEVA SECCIÓN ===
```

### Ejemplo: Funciones de database.sh

```bash
# MariaDB
db_mariadb_create "nombre_db"
db_mariadb_user "usuario" "password" "nombre_db"
db_mariadb_grant_all "usuario" "nombre_db"

# PostgreSQL
db_postgres_create "nombre_db"
db_postgres_user "usuario" "password"
db_postgres_grant_all "usuario" "nombre_db"
```

### Ejemplo: Funciones de network.sh

```bash
# Esperar a que un puerto esté disponible
wait_for_port "localhost" "3306" 30

# Verificar conectividad
check_port_open "192.168.56.10" "3306"
```

## Logs de Provisioning

Cada provisioner genera logs en el directorio `logs/`:

```
logs/
├── system_prepare.log         # Común a todas las VMs
├── mariadb_bootstrap.log      # Orquestador de MariaDB
├── mariadb_install.log        # Instalación de MariaDB
├── mariadb_setup.log          # Setup de MariaDB
├── postgres_bootstrap.log     # Orquestador de PostgreSQL
├── postgres_install.log
├── postgres_setup.log
├── adminer_bootstrap.log      # Orquestador de Adminer
├── adminer_install.log
├── adminer_ssl.log            # SSL de Adminer
└── adminer_swap.log           # Swap de Adminer
```

**Formato del log:**

```
2026-01-10 06:00:15 [INFO   ] Installing MariaDB 11.4...
2026-01-10 06:00:45 [SUCCESS] MariaDB installed
2026-01-10 06:00:46 [INFO   ] Creating database: ivr_legacy
2026-01-10 06:00:47 [SUCCESS] Database created
```

## Cómo Agregar un Nuevo Paso de Provisioning

### Ejemplo: Agregar una extensión a PostgreSQL

**1. Crear nuevo script:** `provisioners/postgres/extensions.sh`

```bash
#!/bin/bash
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh

init_logging "postgres" "extensions"

log_section "Installing PostgreSQL Extensions"

log_info "Installing pg_stat_statements..."
sudo -u postgres psql -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"

log_success "Extensions installed"
```

**2. Llamarlo desde bootstrap.sh:**

```bash
# En provisioners/postgres/bootstrap.sh

log_info "Step 3: Installing extensions..."
bash /vagrant/provisioners/postgres/extensions.sh
```

**3. Agregar al Vagrantfile:**

```ruby
postgresql.vm.provision "shell", 
  path: "provisioners/postgres/extensions.sh", 
  name: "PostgreSQL Extensions"
```

**4. Ejecutar:**

```powershell
vagrant reload postgresql --provision
```

## Re-ejecutar Provisioning

### Todas las VMs

```powershell
vagrant provision
```

### Una VM específica

```powershell
vagrant provision mariadb
```

### Un provisioner específico

```powershell
vagrant provision mariadb --provision-with "MariaDB Setup"
```

### Forzar re-provisioning completo

```powershell
vagrant reload --provision
```

## Debugging de Provisioners

### Ver logs en tiempo real

```powershell
# Desde PowerShell (host)
Get-Content logs\mariadb_bootstrap.log -Wait

# Desde SSH (dentro de VM)
vagrant ssh mariadb
tail -f /vagrant/logs/mariadb_bootstrap.log
```

### Ejecutar provisioner manualmente

```powershell
vagrant ssh mariadb
sudo bash /vagrant/provisioners/mariadb/install.sh
```

### Ver errores

```powershell
Get-ChildItem logs\*.log | Select-String "ERROR"
```

## Best Practices

1. **Usar funciones de utils/**: No reinventar la rueda
2. **Logging consistente**: Usar log_info, log_success, log_error
3. **Validar pre-requisitos**: Verificar que comandos/archivos existen
4. **Idempotencia**: Scripts deben poder ejecutarse múltiples veces sin romper
5. **Manejo de errores**: Usar `set -e` y capturar errores críticos
6. **Documentar cambios**: Comentar código complejo

## Próximos Pasos

Ver [DEVELOPMENT.md](DEVELOPMENT.md) para extender el sistema completo.

---

**Última actualización**: 2026-01-10
