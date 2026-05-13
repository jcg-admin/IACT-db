---
id: RUNBOOK-VERIFY-SERVICES
estado: activo
propietario: equipo-devops
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-DEVOPS-INDEX", "ADR-2025-001"]
---
# Runbook: Verificar Servicios de Base de Datos

## Propósito

Validar que PostgreSQL y MariaDB estén operativos y accesibles desde el entorno de desarrollo.

## Cuándo Usar

- Después de ejecutar `vagrant up`
- Al troubleshootear problemas de conexión a DB
- Antes de ejecutar migraciones o tests
- Al validar un nuevo entorno

## Pre-requisitos

- Vagrant VM corriendo (`vagrant status` muestra "running")
- Variables de entorno configuradas (opcional, usa defaults)
- Cliente PostgreSQL instalado (`psql`)
- Cliente MariaDB instalado (`mysql`)

## Procedimiento Automático

### Opción 1: Script automatizado (recomendado)

```bash
./scripts/verificar_servicios.sh
```

**Tips clave:**

- Usa `--dry-run` en entornos CI/CD o cuando las bases de datos aún no están levantadas.
- Sobrescribe credenciales mediante flags (`--postgres-host`, `--mariadb-password`, etc.) o variables de entorno.
- Códigos de salida: `0` (OK), `1` (fallo de conexión), `2` (clientes faltantes).

**Output esperado (éxito):**
```
[OK] Cliente psql disponible
[OK] Cliente mysql disponible
[INFO] Verificando PostgreSQL...
[OK] PostgreSQL respondió correctamente
[INFO] Verificando MariaDB...
[OK] MariaDB respondió correctamente
[OK] Todos los servicios están operativos
```

**Output esperado (`--dry-run`):**
```
[DRY-RUN] Validación de conectividad omitida.
[DRY-RUN] Ejecutarías:
  PGPASSWORD=**** psql -h 127.0.0.1 -p 15432 -U django_user -d iact_analytics -c 'SELECT 1;'
  mysql -h 127.0.0.1 -P 13306 -u django_user -p**** -e 'SELECT 1;' ivr_data
```

### Opción 2: Verificación Manual

Si el script falla o necesitas debugging adicional:

## Procedimiento Manual

### 1. Verificar que VM está corriendo

```bash
vagrant status
```

**Output esperado:**
```
Current machine states:

default                   running (virtualbox)
```

**Si no está corriendo:**
```bash
vagrant up
```

### 2. Verificar PostgreSQL

**Comando:**
```bash
psql -h 127.0.0.1 -p 15432 -U django_user -d iact_analytics -c "SELECT version();"
```

**Password:** `django_pass` (cuando se solicite)

**Output esperado:**
```
                                                    version
----------------------------------------------------------------------------------------------------------------
 PostgreSQL 15.x on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0, 64-bit
(1 row)
```

**Si falla con "connection refused":**

a) Verificar que puerto está expuesto:
```bash
vagrant port
```

Debe mostrar:
```
5432 (guest) => 15432 (host)
3306 (guest) => 13306 (host)
```

b) Verificar que PostgreSQL está corriendo en VM:
```bash
vagrant ssh -c "sudo systemctl status postgresql"
```

Debe mostrar: `Active: active (running)`

c) Reiniciar PostgreSQL si es necesario:
```bash
vagrant ssh -c "sudo systemctl restart postgresql"
```

### 3. Verificar MariaDB

**Comando:**
```bash
mysql -h 127.0.0.1 -P 13306 -u django_user -p -e "SELECT VERSION();"
```

**Password:** `django_pass` (cuando se solicite)

**Output esperado:**
```
+--------------------------+
| VERSION()                |
+--------------------------+
| 10.x.x-MariaDB-1ubuntu1 |
+--------------------------+
```

**Si falla con "connection refused":**

a) Verificar que MariaDB está corriendo en VM:
```bash
vagrant ssh -c "sudo systemctl status mariadb"
```

Debe mostrar: `Active: active (running)`

b) Reiniciar MariaDB si es necesario:
```bash
vagrant ssh -c "sudo systemctl restart mariadb"
```

### 4. Verificar Bases de Datos Existen

**PostgreSQL:**
```bash
psql -h 127.0.0.1 -p 15432 -U django_user -d postgres -c "\l" | grep iact_analytics
```

Debe mostrar: `iact_analytics`

**MariaDB:**
```bash
mysql -h 127.0.0.1 -P 13306 -u django_user -pdjango_pass -e "SHOW DATABASES;" | grep iact_ivr
```

Debe mostrar: `iact_ivr`

### 5. Verificar Permisos de Usuario

**PostgreSQL:**
```bash
psql -h 127.0.0.1 -p 15432 -U django_user -d iact_analytics -c "CREATE TABLE test_table (id INT); DROP TABLE test_table;"
```

Debe ejecutar sin errores.

**MariaDB:**
```bash
mysql -h 127.0.0.1 -P 13306 -u django_user -pdjango_pass iact_ivr -e "CREATE TABLE test_table (id INT); DROP TABLE test_table;"
```

Debe ejecutar sin errores.

### 6. Verificar desde Django

```bash
# Activar entorno virtual
source .venv/bin/activate

# Verificar conexión a bases de datos
python manage.py check --database default
python manage.py check --database ivr
```

**Output esperado:**
```
System check identified no issues (0 silenced).
```

## Troubleshooting

### Error: "psql: command not found"

**Causa:** Cliente PostgreSQL no instalado.

**Solución Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y postgresql-client
```

**Solución macOS:**
```bash
brew install postgresql
```

### Error: "mysql: command not found"

**Causa:** Cliente MariaDB/MySQL no instalado.

**Solución Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y mariadb-client
```

**Solución macOS:**
```bash
brew install mariadb
```

### Error: "connection refused"

**Posibles causas:**

1. **VM no está corriendo**
   ```bash
   vagrant up
   ```

2. **Servicio no está corriendo en VM**
   ```bash
   vagrant ssh -c "sudo systemctl start postgresql"
   vagrant ssh -c "sudo systemctl start mariadb"
   ```

3. **Puerto forwarding no configurado**
   ```bash
   vagrant reload
   ```

4. **Firewall bloqueando conexión**
   ```bash
   # En VM
   vagrant ssh
   sudo ufw status
   sudo ufw allow 5432/tcp
   sudo ufw allow 3306/tcp
   ```

### Error: "FATAL: password authentication failed"

**Causa:** Credenciales incorrectas.

**Verificar variables de entorno:**
```bash
echo $DB_USER      # Debe ser: django_user
echo $DB_PASSWORD  # Debe ser: django_pass
```

**Resetear password (última opción):**

PostgreSQL:
```bash
vagrant ssh
sudo -u postgres psql
ALTER USER django_user WITH PASSWORD 'django_pass';
\q
exit
```

MariaDB:
```bash
vagrant ssh
sudo mysql
ALTER USER 'django_user'@'%' IDENTIFIED BY 'django_pass';
FLUSH PRIVILEGES;
exit
exit
```

### Error: "database does not exist"

**Solución:** Re-aprovisionar VM
```bash
vagrant destroy -f
vagrant up
```

Esto ejecutará nuevamente `provisioning/bootstrap.sh` que crea las bases de datos.

## Variables de Entorno

El script `verificar_servicios.sh` usa estas variables (con defaults):

| Variable | Default | Descripción |
|----------|---------|-------------|
| `POSTGRES_HOST` | `127.0.0.1` | Host PostgreSQL |
| `POSTGRES_PORT` | `15432` | Puerto PostgreSQL |
| `POSTGRES_USER` | `django_user` | Usuario PostgreSQL |
| `POSTGRES_DB` | `iact_analytics` | Base de datos PostgreSQL |
| `MYSQL_HOST` | `127.0.0.1` | Host MariaDB |
| `MYSQL_PORT` | `13306` | Puerto MariaDB |
| `MYSQL_USER` | `django_user` | Usuario MariaDB |
| `MYSQL_DB` | `iact_ivr` | Base de datos MariaDB |

**Personalizar:**
```bash
export POSTGRES_PORT=5432
./scripts/verificar_servicios.sh
```

## Verificación Exitosa

Cuando todo está correcto, deberías ver:

```
[OK] Cliente PostgreSQL (psql) instalado
[OK] Cliente MariaDB (mysql) instalado
[OK] PostgreSQL conectado exitosamente en 127.0.0.1:15432
  └─ Version: PostgreSQL 15.x
[OK] MariaDB conectado exitosamente en 127.0.0.1:13306
  └─ Version: 10.x.x-MariaDB
[OK] Base de datos 'iact_analytics' existe
[OK] Base de datos 'iact_ivr' existe
[OK] Permisos de usuario validados
[OK] Django puede conectarse a ambas DBs

OK Todos los servicios están operativos
```

## Próximos Pasos

Una vez verificado que servicios están operativos:

1. Ejecutar migraciones: `python manage.py migrate`
2. Crear superuser: `python manage.py createsuperuser`
3. Ejecutar tests: `pytest`
4. Iniciar servidor: `python manage.py runserver`

## Referencias

- [Script verificar_servicios.sh](../../../scripts/verificar_servicios.sh)
- [Vagrantfile](../../../vagrantfile)
- [Bootstrap script](../../../provisioning/bootstrap.sh)
- [README principal](../../../readme.md)

## Changelog

- 2025-11-02: Creación inicial del runbook
- 2025-02-18: Actualizado con troubleshooting adicional
