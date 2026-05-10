# IACT-db — Quickstart

Guía rápida para levantar MariaDB + PostgreSQL con shell scripts puros.
Sin Vagrant, sin Docker, sin VirtualBox.

## Setup inicial

```bash
# 1. Clonar
git clone https://github.com/jcg-admin/IACT-db.git
cd IACT-db

# 2. Configurar credenciales
cp .env.example .env
# Editar .env si se quieren cambiar las credenciales por defecto

# 3. Instalar clientes de BD (psql, mysql CLI)
sudo bash scripts/install-clients.sh

# 4. Instalar y configurar todo
sudo bash bootstrap.sh

# 5. Verificar
bash verify.sh
```

## Opciones de bootstrap

```bash
# Solo MariaDB + PostgreSQL (sin Adminer)
sudo bash bootstrap.sh --no-adminer

# Instalar todo + sembrar datos de prueba en ivr_legacy
sudo bash bootstrap.sh --seed
```

## Si las BDs ya están instaladas

```bash
# Arrancar los servicios (sin instalar ni configurar)
bash start.sh

# Arrancar + configurar BD/usuario/privilegios
sudo bash setup.sh
```

## Conexión directa (credenciales por defecto)

```bash
# MariaDB
mysql -h 127.0.0.1 -u django_user -p'django_pass' ivr_legacy

# PostgreSQL
PGPASSWORD='django_pass' psql -h 127.0.0.1 -U django_user -d iact_analytics
```

## Comandos de diagnóstico

```bash
# Estado completo (7 secciones con contadores OK/WARN/ERR)
bash verify.sh

# Verificar conexión Python a ambas BDs
cd test && python check_db_connections.py

# Ver logs de provisioning
ls logs/
tail -f logs/mariadb_bootstrap.log
```

## Sembrar datos de prueba en ivr_legacy

```bash
# Crea tbl_temp_prueba_ivr con 3000 registros (idempotente)
sudo bash provisioners/mariadb/schema_seed.sh

# SEED_ROWS es configurable en .env (default: 3000)
```

## Django settings resultantes

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'iact_analytics',
        'USER': 'django_user',
        'PASSWORD': 'django_pass',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    },
    'ivr': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'ivr_legacy',
        'USER': 'django_user',
        'PASSWORD': 'django_pass',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
```

## Compatibilidad

| SO | Compatible |
|---|---|
| Ubuntu 22.04 LTS | Sí |
| Ubuntu 24.04 LTS | Sí |
| Debian 12 | Sí |
| WSL2 (Ubuntu) | Sí |
| macOS | No |

---

Ver [MIGRACION-VAGRANT-A-SHELL.md](../architecture/MIGRACION-VAGRANT-A-SHELL.md)
para el análisis técnico completo de la migración desde Vagrant.

## Verificar la conexión desde Django (IACT-api)

Una vez que las BDs están corriendo, confirmar que Django puede
conectar a ambas. Este paso se ejecuta desde el repo `IACT-api`:

```bash
cd /ruta/a/IACT-api/callcentersite
source venv/bin/activate

# BD principal — PostgreSQL
python manage.py check --database default
# Esperado: System check identified no issues (0 silenced).

# BD legacy — MariaDB (solo lectura)
python manage.py check --database ivr
# Esperado: System check identified no issues (0 silenced).

# Migraciones pendientes (debe retornar vacío)
python manage.py showmigrations --database default | grep '\[ \]'
```

Ver `VERIFICACION-LOCAL-SIN-VAGRANT.md` para el checklist completo.

---

## Configurar IACT-api para usar las bases de datos de IACT-db

Una vez que los servicios están corriendo, IACT-api debe apuntar a ellos.

**Verificar que los servicios responden:**

```bash
pg_isready -h 127.0.0.1 -p 5432
mysqladmin -h 127.0.0.1 -u django_user -pdjango_pass ping
# o via socket:
mysqladmin --socket=/run/mysqld/mysqld.sock status
```

**Configurar IACT-api:**

El archivo `callcentersite/config/settings_local.py` en IACT-api
hereda de `settings.development` que lee las credenciales del `.env`:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=iact_analytics
DB_USER=django_user
DB_PASSWORD=django_pass

IVR_DB_HOST=localhost
IVR_DB_PORT=3306
IVR_DB_NAME=ivr_legacy
IVR_DB_USER=django_user
IVR_DB_PASSWORD=django_pass
```

**Aplicar migraciones Django:**

```bash
cd IACT-api/callcentersite
python manage.py migrate
```

Ver: `IACT-db/docs/architecture/SEPARACION-IACT-API.md`
