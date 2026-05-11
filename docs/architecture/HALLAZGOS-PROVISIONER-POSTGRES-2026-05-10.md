# Hallazgos del provisioner PostgreSQL

**Repositorio afectado:** IACT-db  
**Detectado durante:** Análisis de flujo de aprovisionamiento — sesión 2026-05-10  
**Fecha:** 2026-05-10  
**Referencia:** `provisioners/postgres/bootstrap.sh`, `install.sh`, `setup.sh`, `utils/core.sh`

---

## Resumen ejecutivo

El análisis del flujo completo `bootstrap.sh → install.sh → setup.sh` identificó
5 hallazgos que impiden la ejecución correcta del provisioner en entornos sin
systemd (contenedores, CI) y que generan una brecha de configuración entre lo
que `setup.sh` crea y lo que IACT-api requiere para conectarse via socket Unix.
Dos hallazgos fueron corregidos en esta sesión. Tres quedan pendientes.

---

## H-PG-001 — `utils/core.sh`: `start_service` y `restart_service` fallan en contenedor

**Severidad:** CRÍTICA — PostgreSQL no arranca, `postgres_wait_ready` agota timeout  
**Estado:** RESUELTO — `utils/core.sh` actualizado en sesión 2026-05-10  
**Archivos:** `utils/core.sh`, `provisioners/postgres/install.sh`

### Problema

`install.sh` llama `start_service postgresql` y `restart_service postgresql`
definidas en `core.sh`. La implementación original era puro `systemctl`:

```bash
start_service()   { systemctl start "$1"   || return 1; }
restart_service() { systemctl restart "$1" || return 1; }
```

En contenedores sin D-Bus activo `systemctl` retorna error inmediatamente.
`postgres_wait_ready 30` agota el timeout y el provisioner falla.
`database.sh` ya contaba con `db_start_postgres()` que implementa la cadena
correcta (systemctl → service → pg_ctlcluster), pero `install.sh` no la usaba.

### Corrección aplicada

Se reemplazó el bloque `SERVICE OPERATIONS` de `core.sh` con tres funciones
internas y la cadena de decisión completa:

```bash
_has_systemd()              # Verifica D-Bus disponible
_pg_version_from_service()  # Infiere versión para pg_ctlcluster
_service_action()           # Cadena: systemctl → service → pg_ctlcluster
```

Cada nivel registra su decisión en el log del provisioner:

```
[DEBUG  ] service_action: systemctl disponible — intentando systemctl start postgresql
[WARN   ] service_action: systemctl start postgresql fallo — continuando cadena
[DEBUG  ] service_action: intentando service postgresql start
[SUCCESS] service_action: start postgresql via service
```

`start_service`, `stop_service` y `restart_service` delegan a `_service_action`.
`enable_service` retorna `0` silenciosamente cuando no hay systemd.

---

## H-PG-002 — `pg_hba.conf` no configura autenticación por socket Unix

**Severidad:** ALTA — IACT-api producción falla al conectar con `DB_SOCKET`  
**Estado:** RESUELTO — FASE 1: config.sh/_configure_pg_hba() agrega la regla local scram-sha-256 · commit f4a9e98
**Archivos:** `provisioners/postgres/install.sh` (`configure_postgresql`), `pg_hba.conf`

### Problema

`configure_postgresql()` en `install.sh` agrega una regla de acceso remoto
vía TCP pero no configura autenticación local por socket Unix:

```
# Estado actual después de configure_postgresql():
local   all             postgres                                peer
local   all             all                                     peer    ← bloquea django_user
host    all             all             127.0.0.1/32            scram-sha-256
```

IACT-api en producción usa `DB_SOCKET=/var/run/postgresql` (ver
`PREREQUISITOS-POSTGRESQL.md` en IACT-api). Django construye la conexión como:

```python
'HOST': '/var/run/postgresql',   # socket Unix
'PORT': '',
```

PostgreSQL evalúa la regla `local all all peer`, que exige que el usuario
del SO coincida con el rol de BD. `django_user` no existe como usuario del
SO — la conexión falla con:

```
FATAL: Peer authentication failed for user "django_user"
```

La verificación de `setup.sh` usa TCP (`127.0.0.1:5432`) con `scram-sha-256`,
por lo que pasa correctamente sin detectar esta brecha.

### Corrección pendiente

En `configure_postgresql()`, agregar la regla `local scram-sha-256` para
`django_user` antes de la regla `peer` genérica:

```bash
# Regla socket Unix para django_user (antes de la línea peer genérica)
local_rule="local   all             django_user                             scram-sha-256"

if ! grep -q "django_user.*scram-sha-256" "$pg_hba_conf"; then
    # Insertar antes de la primera línea "local all all peer"
    sed -i "/^local.*all.*all.*peer/i ${local_rule}" "$pg_hba_conf"
    log_success "Regla socket Unix agregada para django_user"
fi
```

---

## H-PG-003 — Repositorio PGDG hardcodeado para Ubuntu 20.04 (focal)

**Severidad:** MEDIA — errores de apt en Ubuntu 24.04, instalación por repo incorrecto  
**Estado:** RESUELTO — os_codename dinámico via lsb_release -cs (ya existía en el código)
**Archivos:** `provisioners/postgres/install.sh` (`add_postgresql_repository`)

### Problema

`add_postgresql_repository()` escribe el repo archivado de Ubuntu 20.04:

```bash
cat > "$repo_file" << EOF
deb [...] https://apt-archive.postgresql.org/pub/repos/apt focal-pgdg main
EOF
```

El entorno de implementación es Ubuntu 24.04 (noble). El repo `focal-pgdg`
genera errores en `apt-get update` al no servir paquetes para `noble`.
PostgreSQL 16 se instala desde los repositorios base de Ubuntu 24.04 (donde
existe), pero el repo PGDG incorrecto queda activo y contamina futuras
actualizaciones.

### Corrección pendiente

Detectar el codename del SO en tiempo de ejecución:

```bash
add_postgresql_repository() {
    local os_codename
    os_codename=$(lsb_release -cs 2>/dev/null || . /etc/os-release && echo "$VERSION_CODENAME")

    # Ubuntu 20.04 (focal) usa el repo archivado; versiones posteriores usan el activo
    local repo_base
    case "$os_codename" in
        focal) repo_base="https://apt-archive.postgresql.org/pub/repos/apt" ;;
        *)     repo_base="https://apt.postgresql.org/pub/repos/apt" ;;
    esac

    cat > "$repo_file" << EOF
deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] ${repo_base} ${os_codename}-pgdg main
EOF
```

---

## H-PG-004 — Inconsistencia de nombres de variable entre `bootstrap.sh` y `setup.sh`

**Severidad:** MEDIA — `require_vars` falla al ejecutar `bootstrap.sh` con `.env` canónico  
**Estado:** RESUELTO — DB_NAME eliminado; todos los scripts usan DB_POSTGRES_NAME
**Archivos:** `provisioners/postgres/bootstrap.sh`, `provisioners/postgres/setup.sh`, `.env.example`

### Problema

`bootstrap.sh` exige con `require_vars`:

```bash
require_vars POSTGRES_VERSION DB_NAME DB_USER DB_PASSWORD \
             POSTGRES_PASSWORD POSTGRES_IP POSTGRES_PORT
```

`setup.sh` exige con `require_vars`:

```bash
require_vars DB_POSTGRES_NAME DB_POSTGRES_USER DB_POSTGRES_PASSWORD
```

`.env.example` define `DB_POSTGRES_NAME`, `DB_POSTGRES_USER`, `DB_POSTGRES_PASSWORD`.

Son convenciones distintas. Con el `.env.example` canónico, `bootstrap.sh`
falla en su `require_vars` porque `DB_NAME` no está definido. Si se define
`DB_NAME`, `setup.sh` no lo ve porque espera `DB_POSTGRES_NAME`.

Adicionalmente, `bootstrap.sh` exige `POSTGRES_IP` pero `setup.sh` usa
`POSTGRES_HOST` (con default `127.0.0.1`).

### Corrección pendiente

Unificar la convención. La opción de menor impacto es alinear `bootstrap.sh`
con `setup.sh` y `.env.example` (que usan el prefijo `DB_POSTGRES_*`):

```bash
# bootstrap.sh — require_vars corregido
require_vars POSTGRES_VERSION DB_POSTGRES_NAME DB_POSTGRES_USER DB_POSTGRES_PASSWORD \
             POSTGRES_PASSWORD POSTGRES_HOST POSTGRES_PORT
```

---

## H-PG-005 — `setup.sh` ejecuta `main()` dos veces al ser invocado desde `bootstrap.sh`

**Severidad:** BAJA — doble ejecución, no error por idempotencia  
**Estado:** RESUELTO — BASH_SOURCE guard en setup.sh impide doble ejecución al hacer source
**Archivos:** `provisioners/postgres/setup.sh`

### Problema

`bootstrap.sh` define:

```bash
postgres_setup() {
    source "${PROJECT_ROOT}/provisioners/postgres/setup.sh"
    main
}
```

`setup.sh` termina con `main` incondicionalmente (sin guard). Al hacer
`source`, `main` ejecuta una vez. `bootstrap.sh` luego llama `main`
explícitamente: segunda ejecución. `install.sh` tiene el comentario
correcto ("main() is called by bootstrap.sh, not auto-executed") pero
no llama a `main` al final. El comportamiento entre ambos scripts es
inconsistente.

### Corrección pendiente

Agregar guard en `setup.sh` (mismo patrón que `system.sh`):

```bash
# Al final de setup.sh — reemplazar la llamada directa:
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

`bootstrap.sh` llama `main` explícitamente después del `source`, por lo
que la ejecución ocurre exactamente una vez en ambos casos.

---

## Resumen de estado

| ID | Descripción | Severidad | Estado |
|---|---|---|---|
| H-PG-001 | `start_service`/`restart_service` sin fallback en contenedor | CRÍTICA | RESUELTO |
| H-PG-002 | `pg_hba.conf` sin regla `local scram-sha-256` para socket Unix | ALTA | RESUELTO — FASE 1: config.sh/_configure_pg_hba() agrega la regla · commit f4a9e98 |
| H-PG-003 | Repositorio PGDG `focal-pgdg` hardcodeado en Ubuntu 24.04 | MEDIA | RESUELTO — install.sh usa lsb_release -cs dinámico (os_codename) |
| H-PG-004 | Inconsistencia `DB_NAME` vs `DB_POSTGRES_NAME` en `bootstrap.sh` | MEDIA | RESUELTO — DB_NAME eliminado; solo DB_POSTGRES_NAME en todos los scripts |
| H-PG-005 | `setup.sh` ejecuta `main()` dos veces desde `bootstrap.sh` | BAJA | RESUELTO — BASH_SOURCE guard en setup.sh: main() solo cuando es punto de entrada directo |

---

## Ver también

- `utils/core.sh` — corrección H-PG-001 aplicada
- `IACT-api/docs/setup/PREREQUISITOS-POSTGRESQL.md` — requisitos de infraestructura desde el lado del consumidor
- `HALLAZGOS-ENTORNO.md` — hallazgos previos del entorno de implementación
