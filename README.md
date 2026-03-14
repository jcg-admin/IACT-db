# IACT Database

Infraestructura de base de datos para IACT usando Vagrant para desarrollo y provisioning scripts reutilizables para producción.

## Descripción

Define y provee 3 servicios de base de datos aislados en VMs independientes:

- **PostgreSQL 16**: Base de datos principal de la aplicación IACT (iact_analytics)
- **MariaDB 11.4 LTS**: Base de datos secundaria para datos legados (ivr_legacy)
- **Adminer 4.8.1**: Interfaz web para gestionar ambas bases de datos con SSL/HTTPS

## Arquitectura

```
IACT DevBox (Host-Only Network: 192.168.56.0/24)
├── VM 1: MariaDB
│   ├── IP: 192.168.56.10:3306
│   ├── Database: ivr_legacy
│   ├── User: django_user / django_pass
│   └── Memory: 2GB, CPU: 1
├── VM 2: PostgreSQL
│   ├── IP: 192.168.56.11:5432
│   ├── Database: iact_analytics
│   ├── User: django_user / django_pass
│   └── Memory: 2GB, CPU: 1
└── VM 3: Adminer
    ├── IP: 192.168.56.12
    ├── HTTP: http://adminer.devbox:80
    ├── HTTPS: https://adminer.devbox:443
    └── Memory: 1GB, CPU: 1
```

## Requisitos

### Desarrollo (Vagrant)

- VirtualBox 6.1+
- Vagrant 2.3+
- 5GB RAM disponible (2GB + 2GB + 1GB)
- 10GB espacio en disco

### Producción (Linux)

- Ubuntu 20.04 LTS o superior
- PostgreSQL 16 compatible
- MariaDB 11.4 compatible
- Apache 2.4+ (para Adminer)

## Instalación - Desarrollo con Vagrant

### 1. Clonar el repositorio

```bash
git clone https://github.com/jcg-admin/IACT-db.git
cd IACT-db
```

### 2. Verificar requisitos

```bash
# Verificar VirtualBox
vboxmanage --version

# Verificar Vagrant
vagrant --version

# Verificar plugins (vagrant-goodhosts se instala automáticamente)
vagrant plugin list
```

### 3. Iniciar el entorno

```bash
# Levantar todas las VMs (primer `vagrant up` toma 10-15 minutos)
vagrant up

# O levantar VMs específicas
vagrant up mariadb
vagrant up postgresql
vagrant up adminer
```

El Vagrantfile instalará automáticamente el plugin `vagrant-goodhosts` y configurará el dominio `adminer.devbox` en tu hosts file.

### 4. Verificar estado

```bash
# Ver estado de todas las VMs
vagrant status

# Ver configuración de red
vagrant ssh mariadb -c "ifconfig eth1"
vagrant ssh postgresql -c "ifconfig eth1"
vagrant ssh adminer -c "ifconfig eth1"
```

## Acceso - Desarrollo

### MariaDB

```bash
# Desde la VM
vagrant ssh mariadb
mysql -u root -p'rootpass123'
mysql -u django_user -p'django_pass' ivr_legacy

# Desde el host
mysql -h 192.168.56.10 -u root -p'rootpass123'
mysql -h 192.168.56.10 -u django_user -p'django_pass' ivr_legacy
```

### PostgreSQL

```bash
# Desde la VM
vagrant ssh postgresql
sudo -u postgres psql
psql -U django_user -d iact_analytics

# Desde el host
PGPASSWORD='postgrespass123' psql -h 192.168.56.11 -U postgres
PGPASSWORD='django_pass' psql -h 192.168.56.11 -U django_user -d iact_analytics
```

### Adminer Web Interface

```
HTTP:  http://adminer.devbox
HTTPS: https://adminer.devbox

# O usando IP
HTTP:  http://192.168.56.12
HTTPS: https://192.168.56.12
```

**Usuarios disponibles:**
- MariaDB root: `root` / `rootpass123`
- MariaDB app: `django_user` / `django_pass`
- PostgreSQL postgres: `postgres` / `postgrespass123`
- PostgreSQL app: `django_user` / `django_pass`

## Estructura del Proyecto

```
db/
├── provisioners/
│   ├── mariadb/
│   │   ├── bootstrap.sh      # Orquestador de instalación
│   │   ├── install.sh        # Instalación de MariaDB
│   │   └── setup.sh          # Configuración y bases de datos
│   ├── postgresql/
│   │   ├── bootstrap.sh      # Orquestador de instalación
│   │   ├── install.sh        # Instalación de PostgreSQL
│   │   └── setup.sh          # Configuración y bases de datos
│   └── adminer/
│       ├── bootstrap.sh      # Orquestador de instalación
│       ├── install.sh        # Instalación de Apache + PHP + Adminer
│       ├── ssl.sh            # Configuración SSL/HTTPS con CA
│       └── swap.sh           # Configuración de swap
├── utils/
│   ├── core.sh              # Funciones centrales
│   ├── logging.sh           # Sistema de logging
│   ├── network.sh           # Funciones de red
│   ├── provisioning.sh      # Orquestación de provisioners
│   ├── system.sh            # Funciones del sistema
│   └── validation.sh        # Validaciones
├── config/
│   ├── certs/
│   │   ├── ca/              # Certificate Authority (auto-generado)
│   │   ├── adminer.crt      # Certificado de Adminer
│   │   └── adminer.key      # Clave privada
│   ├── vhost.conf           # Configuración Apache HTTP
│   └── vhost_ssl.conf       # Configuración Apache HTTPS
├── scripts/
│   ├── PowerShell scripts   # Para configuración en Windows
│   └── *.ps1
├── docs/
│   ├── architecture/        # Documentación de arquitectura
│   ├── getting-started/     # Guías de inicio
│   ├── setup/               # Guías de setup
│   └── troubleshooting/     # Solución de problemas
├── logs/                    # Logs de provisioning
├── test/                    # Tests de conexión
├── Vagrantfile              # Configuración Vagrant
└── README.md
```

## Comandos Vagrant

```bash
# Control de VMs
vagrant up                  # Iniciar todas las VMs
vagrant up mariadb          # Iniciar VM específica
vagrant halt                # Detener todas
vagrant halt mariadb        # Detener VM específica
vagrant destroy             # Destruir todas
vagrant reload              # Recargar y reprovisionar
vagrant status              # Ver estado

# Acceso
vagrant ssh mariadb         # Conectar por SSH
vagrant ssh postgresql
vagrant ssh adminer

# Información
vagrant global-status       # Ver todas las VMs en el sistema
vagrant box list            # Ver boxes instalados
vagrant plugin list         # Ver plugins instalados

# Troubleshooting
vagrant up --debug          # Modo debug
vagrant provision mariadb   # Reprovisionar una VM
```

## Django Settings

Usa esta configuración en tu `settings.py` de Django:

```python
DATABASES = {
    'legacy': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'ivr_legacy',
        'USER': 'django_user',
        'PASSWORD': 'django_pass',
        'HOST': '192.168.56.10',
        'PORT': '3306',
    },
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'iact_analytics',
        'USER': 'django_user',
        'PASSWORD': 'django_pass',
        'HOST': '192.168.56.11',
        'PORT': '5432',
    }
}

DATABASE_ROUTERS = ['callcentersite.config.database_router.DatabaseRouter']
```

## Despliegue en Producción (Linux)

### 1. Preparar el servidor

```bash
# Actualizar sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instalar dependencias
sudo apt-get install -y curl wget git bash
```

### 2. Clonar repositorio

```bash
sudo mkdir -p /opt/iact-db
sudo git clone https://github.com/jcg-admin/IACT-db.git /opt/iact-db
cd /opt/iact-db
sudo chmod +x provisioners/*/*.sh
sudo chmod +x utils/*.sh
```

### 3. Ejecutar provisioners

Los provisioners están diseñados para ejecutarse directamente en Linux sin Vagrant:

```bash
# PostgreSQL
sudo bash provisioners/postgresql/bootstrap.sh

# MariaDB
sudo bash provisioners/mariadb/bootstrap.sh

# Adminer (opcional)
sudo bash provisioners/adminer/bootstrap.sh
```

Las variables de configuración se exportan como variables de entorno. Puedes modificarlas antes de ejecutar:

```bash
export POSTGRES_VERSION="16"
export MARIADB_VERSION="11.4"
export ADMINER_VERSION="4.8.1"
export POSTGRES_PASSWORD="tu-password"
export DB_MARIADB_ROOT_PASSWORD="tu-root-password"

sudo -E bash provisioners/postgresql/bootstrap.sh
```

### 4. Verificar instalación

```bash
# PostgreSQL
sudo systemctl status postgresql
sudo -u postgres psql -c "SELECT 1;"

# MariaDB
sudo systemctl status mariadb
mysql -u root -p -e "SELECT 1;"

# Adminer
sudo systemctl status apache2
curl -I http://localhost
```

## Logs

Todos los logs de provisioning se guardan en `/vagrant/logs/` (Vagrant) o `/opt/iact-db/logs/` (Producción):

```bash
# Ver logs disponibles
ls -la logs/

# Ver log específico
tail -f logs/postgres_install.log
tail -f logs/mariadb_bootstrap.log
tail -f logs/adminer_ssl.log
```

## SSL/HTTPS - Adminer

El sistema genera automáticamente:

1. **Certificate Authority (CA)** en `/vagrant/config/certs/ca/`
2. **Certificado Adminer** firmado por la CA
3. **Configuración Apache SSL** con Subject Alternative Names (SAN)

### Para Windows (Desarrollo)

```bash
# En Windows PowerShell (como Administrador)
.\scripts\install-ca-certificate.ps1
```

Esto instala la CA en el almacén de confianza de Windows y elimina advertencias SSL.

### Para Linux (Producción)

```bash
# Copiar CA al almacén de confianza
sudo cp /opt/iact-db/config/certs/ca/ca.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

## Troubleshooting

### Windows: VERR_INTNET_FLT_IF_NOT_FOUND

```
1. Win+R → ncpa.cpl
2. Click derecho en "VirtualBox Host-Only Ethernet Adapter"
3. Disable → Enable
4. vagrant up
```

Ver `docs/troubleshooting/` para más soluciones.

### Conexión a PostgreSQL rechazada

```bash
# Verificar que PostgreSQL está escuchando
vagrant ssh postgresql -c "sudo netstat -tlnp | grep 5432"

# Verificar archivo de configuración
vagrant ssh postgresql -c "grep 'listen_addresses' /etc/postgresql/*/main/postgresql.conf"
```

### Adminer SSL no funciona

```bash
# Verificar certificados
vagrant ssh adminer -c "sudo openssl x509 -in /etc/ssl/certs/adminer-selfsigned.crt -text -noout"

# Reiniciar Apache
vagrant ssh adminer -c "sudo systemctl restart apache2"
```

## Migraciones y Seeds

Actualmente no hay migraciones SQL en el repositorio. Se planifica agregar:

- Esquemas base para PostgreSQL
- Tablas para MariaDB
- Datos iniciales (seeds)

## Contribuciones

Por favor lee CONTRIBUTING.md antes de hacer cambios.

## Licencia

Propiedad de JCG Admin
