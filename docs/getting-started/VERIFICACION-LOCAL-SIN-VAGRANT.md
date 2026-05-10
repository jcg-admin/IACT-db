# Verificación de bases de datos — entorno local sin Vagrant

**Fecha:** 2026-05-06
**Aplica a:** entornos donde PostgreSQL y MariaDB corren directamente
en el sistema operativo (sin VMs Vagrant).

---

## Contexto

El README y `VERIFICACION_COMPLETA.md` describen el flujo con Vagrant
(3 VMs en red host-only `192.168.56.0/24`). Este documento cubre el
caso opuesto: PostgreSQL y MariaDB instalados y corriendo localmente
en `127.0.0.1`, como ocurre en contenedores de desarrollo o
máquinas con los motores instalados directamente.

---

## Arquitectura local

```
localhost (127.0.0.1)
├── PostgreSQL 16        :5432   iact_analytics   django_user
└── MariaDB 10.11+       :3306   ivr_legacy       django_user
```

Las credenciales son las mismas que en el entorno Vagrant
(definidas en `.env.example`).

---

## Paso 1 — Verificar que los motores responden

```bash
# PostgreSQL
pg_isready -h 127.0.0.1 -p 5432
# Esperado: 127.0.0.1:5432 - accepting connections

# MariaDB
mysqladmin -h 127.0.0.1 -u django_user -pdjango_pass ping
# Esperado: mysqld is alive
```

Si PostgreSQL no responde, iniciarlo:

```bash
# Ubuntu/Debian con cluster instalado
sudo pg_ctlcluster 16 main start

# Verificar estado del cluster
pg_lsclusters
```

Si MariaDB no responde, iniciarlo:

```bash
sudo service mariadb start
# o
sudo systemctl start mariadb
```

---

## Paso 2 — Verificar usuario y base de datos PostgreSQL

Conectar via socket unix como superusuario postgres:

```bash
runuser -u postgres -- psql << 'SQL'
-- Verificar que el usuario existe
SELECT rolname, rolcreatedb FROM pg_roles WHERE rolname = 'django_user';

-- Verificar que la BD existe
SELECT datname FROM pg_database WHERE datname = 'iact_analytics';
SQL
```

Salida esperada:

```
   rolname   | rolcreatedb
-------------+-------------
 django_user | t
(1 row)

    datname
----------------
 iact_analytics
(1 row)
```

Si el usuario o la BD no existen, ejecutar el setup:

```bash
# Requiere sudo — el script es idempotente
sudo bash provisioners/postgres/setup.sh
```

---

## Paso 3 — Verificar tablas en PostgreSQL

```bash
runuser -u postgres -- psql -d iact_analytics -c \
  "SELECT count(*) as tablas FROM pg_tables WHERE schemaname = 'public';"
```

Salida esperada: 38 tablas (o más si hay migraciones adicionales).

Si hay 0 tablas, las migraciones Django no se han ejecutado.
Ver `IACT-api` para ejecutar `manage.py migrate`.

---

## Paso 4 — Verificar MariaDB

```bash
mysql -h 127.0.0.1 -u django_user -pdjango_pass ivr_legacy \
  -e "SELECT COUNT(*) as registros FROM tbl_temp_prueba_ivr;"
```

Salida esperada: 3000 registros (sembrados por `schema_seed.sh`).

Si la BD o el usuario no existen, ejecutar el setup:

```bash
# Requiere acceso root a MariaDB via socket
sudo bash provisioners/mariadb/setup.sh
```

---

## Paso 5 — Verificar la conexión desde Django

Este paso se ejecuta desde el directorio de `IACT-api`:

```bash
cd /ruta/a/IACT-api/callcentersite
source venv/bin/activate

# Verificar PostgreSQL (BD principal)
python manage.py check --database default
# Esperado: System check identified no issues (0 silenced).

# Verificar MariaDB (BD legacy, solo lectura)
python manage.py check --database ivr
# Esperado: System check identified no issues (0 silenced).
```

Si alguno falla, revisar el `.env` del proyecto IACT-api:

```
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=iact_analytics
DB_USER=django_user
DB_PASSWORD=django_pass

IVR_DB_HOST=127.0.0.1
IVR_DB_PORT=3306
IVR_DB_NAME=ivr_legacy
IVR_DB_USER=django_user
IVR_DB_PASSWORD=django_pass
```

---

## Paso 6 — Verificar migraciones aplicadas

```bash
# Debe mostrar [X] en todas las migraciones — ninguna [ ] pendiente
python manage.py showmigrations --database default | grep '\[ \]'
# Salida esperada: (vacío — 0 migraciones pendientes)

python manage.py showmigrations --database ivr | grep '\[ \]'
# Salida esperada: (vacío)
```

---

## Resumen de verificación

| Componente              | Comando de verificación                              | Resultado esperado              |
|-------------------------|------------------------------------------------------|---------------------------------|
| PostgreSQL servicio     | `pg_isready -h 127.0.0.1 -p 5432`                   | accepting connections           |
| MariaDB servicio        | `mysqladmin -h 127.0.0.1 -u django_user -p ping`     | mysqld is alive                 |
| Usuario django_user PG  | `psql` → `SELECT rolname FROM pg_roles`              | 1 fila                          |
| BD iact_analytics       | `psql` → `SELECT datname FROM pg_database`           | 1 fila                          |
| Tablas PG               | `pg_tables WHERE schemaname='public'`                | 38+ tablas                      |
| BD ivr_legacy registros | `SELECT COUNT(*) FROM tbl_temp_prueba_ivr`           | 3000                            |
| Django default          | `manage.py check --database default`                 | 0 issues                        |
| Django ivr              | `manage.py check --database ivr`                     | 0 issues                        |
| Migraciones pendientes  | `manage.py showmigrations` grep `\[ \]`              | vacío                           |

---

## Ver también

- `VERIFICACION_COMPLETA.md` — verificación con VMs Vagrant
- `docs/architecture/SEPARACION-IACT-API.md` — qué gestiona cada repo
- `provisioners/postgres/setup.sh` — setup idempotente de PostgreSQL
- `provisioners/mariadb/setup.sh` — setup idempotente de MariaDB
