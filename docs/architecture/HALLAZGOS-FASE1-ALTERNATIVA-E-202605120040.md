# Hallazgos — Ejecución FASE 1 (Plan Alternativa E Consolidado)

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Plan de referencia:** `PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` FASE 1  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-1.1 | `mariadb/config.sh`: `backup_file` en `_configure_mariadb_server` | COMPLETO | — |
| T-1.2 | `mariadb/config.sh`: `source database.sh` + `mariadb_wait_ready(30)` | COMPLETO | H-F1-001 |
| T-1.3 | `mariadb/config.sh`: verificación parseo `mariadbd --help` | COMPLETO | — |
| T-1.4 | `mariadb/config.sh`: `_secure_mariadb()` + `require_vars` + reorden | COMPLETO | — |
| T-1.5 | `postgres/config.sh`: `backup_file` en `_configure_pg_hba` y `_configure_postgresql_conf` | COMPLETO | — |
| T-1.6 | `postgres/config.sh`: verificación post-edición `listen_addresses` | COMPLETO | — |
| T-1.7 | `postgres/config.sh`: `_secure_postgres()` + `require_vars` + reorden | COMPLETO | — |
| T-1.8 | `verify.sh` → 27 OK sin regresión | PASA | — |

---

## H-F1-001 — `utils/database.sh` no estaba sourced en `mariadb/config.sh`

**Detectado en:** T-1.2 (antes de implementar `mariadb_wait_ready`)  
**Severidad:** ALTA  
**Estado:** RESUELTO en T-1.2

### Descripción

Al intentar agregar `mariadb_wait_ready(30)` en `_restart_mariadb()`, se
verificó que `utils/database.sh` no estaba en los `source` de `config.sh`.

```bash
# mariadb/config.sh antes de T-1.2 — sources presentes:
source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/validation.sh"
# database.sh: AUSENTE
```

`mariadb_wait_ready()` y `mariadb_is_running()` viven en `database.sh`.
Sin `source database.sh`, cualquier llamada a esas funciones producía
`command not found` en tiempo de ejecución — no detectable con `bash -n`.

### Impacto

Si se hubiera implementado T-1.2 sin resolver primero este hallazgo,
`_restart_mariadb()` habría fallado silenciosamente en producción:

```
bash: mariadb_wait_ready: command not found
```

Con `set -euo pipefail` activo en `config.sh`, ese error habría terminado
el script antes de que `_secure_mariadb()` y las configuraciones posteriores
se ejecutaran.

### Resolución

Agregar `source "${PROJECT_ROOT}/utils/database.sh"` inmediatamente después
de las líneas de source existentes, con comentario que explica por qué es
necesario en este archivo.

---

## Cambios implementados en `provisioners/mariadb/config.sh`

### Nuevas dependencias
```bash
source "${PROJECT_ROOT}/utils/database.sh"
# Provee: mariadb_wait_ready(), mariadb_is_running()
```

### Nueva función `_secure_mariadb()`
Movida desde `install.sh/secure_mariadb()`. Hardening del motor:
- Detecta método de autenticación root (unix_socket o password)
- `DELETE FROM mysql.user WHERE User=''` — usuarios anónimos
- `DELETE FROM mysql.user WHERE User='root' AND Host NOT IN (...)` — root solo local
- `DROP DATABASE IF EXISTS test` — BD de prueba del sistema
- `ALTER USER 'root'@'localhost' IDENTIFIED BY '...'`
- `FLUSH PRIVILEGES`

### Cambios en `_configure_mariadb_server()`
- `backup_file(50-server.cnf)` antes del primer `sed` (T-1.1)

### Cambios en `_apply_iact_mariadb_config()`
- Verificación `mariadbd --defaults-file --help --verbose | grep event_scheduler`
  tras crear el symlink (T-1.3)

### Cambios en `_restart_mariadb()`
- `mariadb_wait_ready(30)` después de `service mariadb restart` (T-1.2)

### Cambios en `main()`
- `require_vars MARIADB_VERSION DB_MARIADB_ROOT_PASSWORD` (T-1.4)
- PASO 1: `_secure_mariadb()` — hardening antes de configurar
- PASO 2: `_configure_mariadb_server()` — bind-address
- PASO 3: `_configure_mariadb_aio()` — io_uring
- PASO 4: `_apply_iact_mariadb_config()` — symlink + parseo

---

## Cambios implementados en `provisioners/postgres/config.sh`

### Nueva función `_secure_postgres()`
Movida desde `install.sh/set_postgres_password()`. Hardening del motor:
- `ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}'`

### Cambios en `_configure_pg_hba()`
- `backup_file(pg_hba.conf)` antes de agregar reglas (T-1.5)

### Cambios en `_configure_postgresql_conf()`
- `backup_file(postgresql.conf)` antes de editar (T-1.5)
- Verificación `grep listen_addresses = '*'` tras el `sed` (T-1.6)
- Retorna error si la verificación falla (T-1.6)

### Cambios en `main()`
- `require_vars POSTGRES_VERSION DB_POSTGRES_USER POSTGRES_PASSWORD` (T-1.7)
- PASO 1: `_secure_postgres()` — password del superusuario postgres
- PASO 2: `_configure_pg_hba()` — autenticación
- PASO 3: `_configure_postgresql_conf()` — acceso remoto
- PASO 4: `_apply_iact_postgres_config()` — symlink

---

## Por qué el orden SECURE → CONFIG es obligatorio

### MariaDB
En instalación fresca, MariaDB autentica root via `unix_socket` (plugin
de autenticación que verifica el UID del proceso). Este mecanismo está
disponible desde que el daemon arranca por primera vez.

Si `_configure_mariadb_server()` se ejecuta primero (cambia `bind-address`
y hace restart), el contexto de arranque puede cambiar dependiendo del
entorno (systemd vs directo). Ejecutar `_secure_mariadb()` antes garantiza
que la autenticación unix_socket está disponible.

### PostgreSQL
`pg_hba.conf` con `scram-sha-256` para el usuario `postgres` requiere
que ese usuario tenga password configurado. Si se agrega la regla primero
y luego se intenta conectar antes de tener password (por ejemplo, en una
re-ejecución donde la regla ya existe), la autenticación falla con:

```
FATAL: password authentication failed for user "postgres"
```

Ejecutar `_secure_postgres()` primero garantiza que el password existe
antes de que pg_hba.conf lo exija.

---

## Estado de los hallazgos del plan tras FASE 1

| Hallazgo | Descripción | Estado |
|---|---|---|
| H-DEAD-001 | `backup_file` faltante en config.sh | RESUELTO — T-1.1, T-1.5 |
| H-DEAD-002 | `mariadb_wait_ready(30)` faltante en `_restart_mariadb` | RESUELTO — T-1.2 |
| H-DEAD-003 | Verificación parseo `mariadbd --help` faltante | RESUELTO — T-1.3 |
| H-DEAD-004 | Verificación `listen_addresses` faltante | RESUELTO — T-1.6 |
| H-INST-001 | `secure_mariadb()` en capa incorrecta | RESUELTO — T-1.4 |
| H-INST-003 | `set_postgres_password()` en capa incorrecta | RESUELTO — T-1.7 |
| H-INST-006 | `require_vars` incompleto en config.sh de ambos motores | RESUELTO — T-1.4, T-1.7 |
| H-INST-007 | Orden `_secure_postgres` ANTES de `_configure_pg_hba` | RESUELTO — T-1.7 |
| H-INST-008 | Orden `_secure_mariadb` ANTES de `_configure_mariadb_server` | RESUELTO — T-1.4 |
| H-F1-001 | `database.sh` no sourced en `mariadb/config.sh` | RESUELTO — T-1.2 |
