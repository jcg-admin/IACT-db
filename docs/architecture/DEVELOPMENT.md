# IACT DevBox - Development Guide

Guía para modificar y extender el sistema IACT DevBox.

## Estructura del Proyecto

```
IACT/db/
├── Vagrantfile              # Configuración de VMs
├── scripts/                 # Scripts PowerShell (host)
├── provisioners/            # Scripts Bash (VMs)
├── utils/                   # Funciones compartidas (VMs)
├── config/                  # Configuración de servicios
├── logs/                    # Logs de provisioning
├── test/                    # Scripts de prueba
└── docs/                    # Documentación
```

## Modificar Configuración de VMs

### Cambiar RAM o CPUs

Editar `Vagrantfile`:

```ruby
config.vm.define "mariadb" do |mariadb|
  mariadb.vm.provider "virtualbox" do |vb|
    vb.memory = 3072  # Cambiar de 2048 a 3072 MB
    vb.cpus = 2       # Cambiar de 1 a 2 CPUs
  end
end
```

Aplicar cambios:

```powershell
vagrant reload mariadb
```

### Cambiar IP de una VM

Editar `Vagrantfile`:

```ruby
mariadb.vm.network "private_network", ip: "192.168.56.20"  # Cambiar de .10 a .20
```

**Importante**: También actualizar scripts que usen la IP:
- `scripts/diagnose-system.ps1`
- `scripts/check-prerequisites.ps1`
- `test/check_db_connections.py`

### Cambiar Puertos Forwarding

Editar `Vagrantfile`:

```ruby
mariadb.vm.network "forwarded_port", guest: 3306, host: 33060  # Cambiar puerto host
```

## Agregar Una Nueva VM

### Paso 1: Definir VM en Vagrantfile

```ruby
config.vm.define "redis" do |redis|
  redis.vm.box = "ubuntu/focal64"
  redis.vm.hostname = "redis"
  redis.vm.network "private_network", ip: "192.168.56.13"
  
  redis.vm.provider "virtualbox" do |vb|
    vb.name = "db_redis"
    vb.memory = 1024
    vb.cpus = 1
  end
  
  # Provisioning
  redis.vm.provision "shell", path: "provisioners/system_prepare.sh"
  redis.vm.provision "shell", path: "provisioners/redis/bootstrap.sh"
end
```

### Paso 2: Crear Provisioners

```bash
mkdir provisioners/redis

# bootstrap.sh
cat > provisioners/redis/bootstrap.sh << 'EOF'
#!/bin/bash
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh

init_logging "redis" "bootstrap"
log_section "PROVISIONING: Redis 7.0"

log_info "Installing Redis..."
bash /vagrant/provisioners/redis/install.sh

log_success "Provisioning completed"
EOF

# install.sh
cat > provisioners/redis/install.sh << 'EOF'
#!/bin/bash
source /vagrant/utils/core.sh
source /vagrant/utils/logging.sh

init_logging "redis" "install"

sudo apt-get update
sudo apt-get install -y redis-server

# Configurar para escuchar en todas las interfaces
sudo sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis/redis.conf

sudo systemctl restart redis-server

log_success "Redis installed"
EOF

chmod +x provisioners/redis/*.sh
```

### Paso 3: Crear y Probar

```powershell
vagrant up redis
.\scripts\verify-vms.ps1
Test-NetConnection -ComputerName 192.168.56.13 -Port 6379
```

## Modificar Scripts PowerShell

### Agregar Nueva Verificación a diagnose-system.ps1

```powershell
# Agregar función de verificación
function Test-RedisConnectivity {
    Show-Section "8. Diagnostico de Redis"
    
    try {
        $result = Test-NetConnection -ComputerName 192.168.56.13 -Port 6379 -WarningAction SilentlyContinue
        
        if ($result.TcpTestSucceeded) {
            Show-OK "Redis (192.168.56.13:6379) alcanzable"
            return @{ Status = "OK" }
        } else {
            Show-Fail "Redis no alcanzable"
            return @{ Status = "FAIL" }
        }
    } catch {
        Show-Fail "Error verificando Redis: $_"
        return @{ Status = "ERROR" }
    }
}

# Agregar al Main
function Main {
    # ... código existente ...
    
    $redisResult = Test-RedisConnectivity
    
    # Agregar a resumen
    Show-DiagnosticSummary -RedisResult $redisResult
}
```

### Agregar VM a check-prerequisites.ps1

```powershell
# En configuración
$script:VMs = @{
    "mariadb" = @{ IP = "192.168.56.10"; Ports = @(3306) }
    "postgresql" = @{ IP = "192.168.56.11"; Ports = @(5432) }
    "adminer" = @{ IP = "192.168.56.12"; Ports = @(80, 443) }
    "redis" = @{ IP = "192.168.56.13"; Ports = @(6379) }  # Nueva VM
}
```

## Extender Utils

### Agregar Nueva Función a utils/

**Ejemplo**: Agregar función para Redis en `utils/database.sh`

```bash
# Función para crear clave en Redis
redis_set() {
    local key="$1"
    local value="$2"
    local host="${3:-localhost}"
    local port="${4:-6379}"
    
    redis-cli -h "$host" -p "$port" SET "$key" "$value"
    
    if [ $? -eq 0 ]; then
        log_success "Redis key set: $key"
        return 0
    else
        log_error "Failed to set Redis key: $key"
        return 1
    fi
}

# Función para obtener clave de Redis
redis_get() {
    local key="$1"
    local host="${2:-localhost}"
    local port="${3:-6379}"
    
    redis-cli -h "$host" -p "$port" GET "$key"
}
```

**Uso en provisioners:**

```bash
source /vagrant/utils/database.sh

redis_set "test_key" "test_value" "192.168.56.13" "6379"
value=$(redis_get "test_key" "192.168.56.13" "6379")
log_info "Redis value: $value"
```

## Modificar Configuración de Servicios

### Cambiar Configuración de MariaDB

**Archivo**: `/etc/mysql/mariadb.conf.d/50-server.cnf`

```bash
vagrant ssh mariadb

# Editar configuración
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf

# Ejemplo: Aumentar max_connections
[mysqld]
max_connections = 500

# Reiniciar
sudo systemctl restart mariadb
```

**Para hacer permanente**, agregar al provisioner:

```bash
# En provisioners/mariadb/setup.sh

log_info "Configuring max_connections..."
sudo bash -c 'cat >> /etc/mysql/mariadb.conf.d/50-server.cnf << EOF

# Custom configuration
[mysqld]
max_connections = 500
EOF'

sudo systemctl restart mariadb
```

### Configuración Personalizada de PostgreSQL

```bash
# En provisioners/postgres/setup.sh

log_info "Tuning PostgreSQL..."
sudo -u postgres psql -c "ALTER SYSTEM SET max_connections = 200;"
sudo -u postgres psql -c "ALTER SYSTEM SET shared_buffers = '256MB';"

sudo systemctl restart postgresql
```

## Agregar Tests

### Test de Conectividad

**Crear**: `test/test_redis.py`

```python
import redis
import sys

def test_redis_connection():
    try:
        r = redis.Redis(host='192.168.56.13', port=6379, decode_responses=True)
        r.ping()
        print("[OK] Redis connection successful")
        
        # Test set/get
        r.set('test_key', 'test_value')
        value = r.get('test_key')
        assert value == 'test_value'
        print("[OK] Redis set/get working")
        
        return 0
    except Exception as e:
        print(f"[FAIL] Redis test failed: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(test_redis_connection())
```

**Ejecutar:**

```powershell
python test\test_redis.py
```

## Workflow de Desarrollo

### Desarrollo Iterativo

```powershell
# 1. Hacer cambios en provisioners/
# Editar: provisioners/mariadb/setup.sh

# 2. Re-provisionar solo esa VM
vagrant reload mariadb --provision

# 3. Verificar logs
Get-Content logs\mariadb_setup.log -Tail 50

# 4. Si hay error, corregir y repetir
```

### Testing de Scripts PowerShell

```powershell
# Ejecutar con -WhatIf para simular
.\scripts\clean-logs.ps1 -DaysToKeep 0 -WhatIf

# Ejecutar con -Verbose para debug
$VerbosePreference = "Continue"
.\scripts\diagnose-system.ps1
```

### Debugging de Provisioners

```powershell
# SSH a la VM
vagrant ssh mariadb

# Ejecutar provisioner manualmente con debug
bash -x /vagrant/provisioners/mariadb/install.sh
```

## Versionado y Git

### .gitignore

```gitignore
# Vagrant
.vagrant/
*.box

# Logs
logs/*.log
!logs/.gitkeep

# Cache
.cache/

# OS
.DS_Store
Thumbs.db

# Secrets (si existen)
secrets/
*.secret
```

### Commits Semánticos

```bash
git commit -m "feat(mariadb): add max_connections tuning"
git commit -m "fix(network): correct IP in diagnose script"
git commit -m "docs(readme): update installation steps"
git commit -m "refactor(utils): extract redis functions to database.sh"
```

## Troubleshooting de Desarrollo

### Provisioner No Se Ejecuta

```powershell
# Ver si está registrado
vagrant provision --debug

# Forzar ejecución
vagrant reload --provision
```

### Cambios en Vagrantfile No Aplican

```powershell
# Recargar configuración
vagrant reload

# O destruir y recrear
vagrant destroy -f
vagrant up
```

### Script PowerShell No Encuentra Vagrantfile

```powershell
# Verificar directorio raíz
cd D:\Estadia_IACT\proyecto\IACT\db

# Los scripts buscan Vagrantfile automáticamente
.\scripts\diagnose-system.ps1
```

## Recursos

- **Vagrant Docs**: https://www.vagrantup.com/docs
- **VirtualBox Docs**: https://www.virtualbox.org/manual/
- **PowerShell Docs**: https://docs.microsoft.com/powershell
- **Bash Scripting**: https://www.gnu.org/software/bash/manual/

## Contribuir

1. Crear rama de feature
2. Hacer cambios
3. Probar exhaustivamente
4. Documentar en CHANGELOG
5. Crear pull request

---

**Última actualización**: 2026-01-10
