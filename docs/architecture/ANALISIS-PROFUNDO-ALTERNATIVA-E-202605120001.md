# Análisis profundo — Alternativa E: todos los archivos

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Propósito:** Documento base para implementar Alternativa E y para la
futura migración a Ansible. Cubre cada archivo del sistema de provisioning:
estado actual, cambios necesarios, resultado esperado y la correspondencia
con la estructura de roles Ansible.

---

## Principio rector

Una función tiene una razón para cambiar. Esa razón define su capa.

```
¿Toca paquetes apt?               → INSTALL
¿Toca objetos de seguridad        → SECURE  (sub-capa de CONFIG)
  del motor del sistema?
¿Toca archivos del SO del         → CONFIG
  servicio o symlinks del repo?
¿Toca objetos de la BD            → SETUP
  del proyecto?
```

---

## Inventario completo — estado actual

### Nivel 0 — Configuración del entorno

| Archivo | Líneas | Rol | Cambia en Alt-E |
|---|---|---|---|
| `.env` | — | Variables de entorno. Nunca se commitea. | No |
| `.env.example` | — | Plantilla documentada de variables | No |
| `config/mariadb/99-iact.cnf` | 40 | Config IACT para MariaDB (symlink target) | No |
| `config/postgres/99-iact.conf` | 32 | Config IACT para PostgreSQL (symlink target) | No |
| `config/vhost.conf` | 57 | VirtualHost Apache para Adminer | No |
| `config/vhost_ssl.conf` | 65 | VirtualHost SSL Apache para Adminer | No |
| `config/certs/adminer.crt` | — | Certificado TLS Adminer (dev) | No |
| `config/certs/adminer.key` | — | Clave privada TLS Adminer (dev) | No |

### Nivel 1 — Utilidades compartidas

| Archivo | Líneas | Rol | Cambia en Alt-E |
|---|---|---|---|
| `utils/logging.sh` | 297 | `log_info`, `log_error`, `log_success`, `log_step` | No |
| `utils/core.sh` | 535 | `ensure_dir`, `backup_file`, `validate_root` | No |
| `utils/network.sh` | 312 | `wait_for_port`, `is_port_open` | No |
| `utils/validation.sh` | 359 | `require_vars`, `validate_file_exists` | No |
| `utils/provisioning.sh` | 339 | `init_all`, `run_all`, `step_header`, `show_results` | No |
| `utils/system.sh` | 217 | `install_essentials`, `update_system`, `configure_timezone` | No |
| `utils/database.sh` | 1097 | `mariadb_is_running`, `db_start_mariadb`, `pg_is_running`, `mysql_create_database`, etc. | No |

### Nivel 2 — Scripts de entrada raíz

| Archivo | Líneas | Rol | Cambia en Alt-E |
|---|---|---|---|
| `bootstrap.sh` | 144 | Orquestador raíz. Llama a `provisioners/*/bootstrap.sh` | No |
| `setup.sh` | 176 | Punto de entrada para `sudo bash setup.sh [target]`. Llama a `setup.sh` de cada motor o a `scripts/provision-mariadb.sh --full` | No |
| `start.sh` | 192 | Arranca MariaDB y/o PostgreSQL. Cadena: service → systemctl → directo | No |
| `verify.sh` | 495 | Verifica 27 condiciones del entorno. Baseline: 27 OK, 0 ERR | No |

### Nivel 3 — Scripts de soporte

| Archivo | Líneas | Rol | Cambia en Alt-E |
|---|---|---|---|
| `scripts/provision-mariadb.sh` | 439 | Provisionamiento completo de ivr_legacy: SQL, SPs, seed, grants EXECUTE | No |
| `scripts/install-clients.sh` | — | Instala clientes de BD para CI/CD | No |

### Nivel 4 — Provisioners MariaDB

| Archivo | Líneas | Rol actual | Cambia en Alt-E |
|---|---|---|---|
| `provisioners/mariadb/bootstrap.sh` | 82 | Orquesta: system → install → config → setup | **No** — ya tiene la estructura correcta |
| `provisioners/mariadb/install.sh` | 502 | INSTALL + dead code (configure_mariadb, _apply_iact) + SECURE mal ubicado (secure_mariadb) | **Sí** — eliminar 135L, extraer secure_mariadb |
| `provisioners/mariadb/config.sh` | 169 | CONFIG: bind-address, aio, symlink, restart | **Sí** — agregar _secure_mariadb al inicio |
| `provisioners/mariadb/setup.sh` | 185 | SETUP: CREATE DATABASE, CREATE USER, GRANT SELECT (CNST-003) | No |
| `provisioners/mariadb/schema_historico.sh` | 600 | Schema histórico IVR: 6 tablas, seed Nivel 1 (SQL) + Nivel 2 (Python) | No |
| `provisioners/mariadb/schema_seed.sh` | 204 | Tabla de prueba `tbl_temp_prueba_ivr` | No |
| `provisioners/mariadb/backup_ivr_legacy.sh` | 423 | Dump comprimido de ivr_legacy | No |

### Nivel 4 — Provisioners PostgreSQL

| Archivo | Líneas | Rol actual | Cambia en Alt-E |
|---|---|---|---|
| `provisioners/postgres/bootstrap.sh` | 81 | Orquesta: system → install → config → setup | **No** — ya tiene la estructura correcta |
| `provisioners/postgres/install.sh` | 418 | INSTALL + dead code (configure_postgresql, _apply_iact) + SECURE mal ubicado (set_postgres_password) | **Sí** — eliminar 147L, extraer set_postgres_password |
| `provisioners/postgres/config.sh` | 207 | CONFIG: pg_hba.conf, postgresql.conf, symlink, reload | **Sí** — agregar _secure_postgres al inicio |
| `provisioners/postgres/setup.sh` | 143 | SETUP: CREATE USER, CREATE DATABASE, GRANT ALL, EXTENSION | No |

### Nivel 4 — Provisioners Adminer

| Archivo | Rol | Cambia en Alt-E |
|---|---|---|
| `provisioners/adminer/bootstrap.sh` | Orquesta adminer: system → install → ssl | No |
| `provisioners/adminer/install.sh` | Apache, PHP, Adminer, vhost. Usa `config/vhost.conf` (copy) | No |
| `provisioners/adminer/ssl.sh` | TLS: genera cert, copia `config/certs/`, configura vhost SSL | No |
| `provisioners/adminer/swap.sh` | Configuración de swap para entornos con poca RAM | No |

### Nivel 5 — SQL, Python, datos

| Archivo | Rol | Cambia en Alt-E |
|---|---|---|
| `provisioners/mariadb/schema_base_ivr.sql` | DDL de tablas analíticas (base_ivr_detalle, job_config, etl_runs...) | No |
| `provisioners/mariadb/schema_historico.sql` | DDL de tablas históricas (tbl_historico_tN_YYYY) | No |
| `provisioners/mariadb/funciones_utilidad.sql` | 7 funciones MariaDB (fn_did_segmento, ivr_es_dia_semana...) | No |
| `provisioners/mariadb/sp_etl_pipeline.sql` | 5 SPs ETL (sp_etl_maestro, sp_etl_base_detalle...) | No |
| `provisioners/mariadb/sp_rpt_reportes.sql` | 7 SPs de reporte (sp_rpt_clientes, sp_rpt_centros_transferencia...) | No |
| `provisioners/mariadb/seed_historico.sql` | Nivel 1: seed histórico IVR (v3.0.0) | No |
| `provisioners/mariadb/poblar_historico.py` | Nivel 2: seed con perfiles por quarter (v1.1.0) | No |
| `provisioners/mariadb/perfiles/` | 6 módulos Python con distribuciones calibradas por quarter | No |
| `test/check_db_connections.py` | Test de conectividad a MariaDB y PostgreSQL | No |

---

## Los 4 archivos que cambian

---

### ARCHIVO 1 — `provisioners/postgres/install.sh`

**Tamaño actual:** 418 líneas  
**Tamaño proyectado:** 271 líneas (-147)

#### Funciones a eliminar (código muerto — ya están en config.sh)

```
L259-L364  configure_postgresql()         105 líneas
           Operaciones: pg_hba.conf, postgresql.conf
           Estado: NO se llama desde main()
           Destino: ELIMINAR — la lógica ya existe en config.sh/_configure_pg_hba()
                    y config.sh/_configure_postgresql_conf()

L376-L402  _apply_iact_postgres_config()   27 líneas
           Operaciones: ln -sf 99-iact.conf → /etc/postgresql/conf.d/
           Estado: NO se llama desde main()
           Destino: ELIMINAR — ya existe en config.sh/_apply_iact_postgres_config()
```

#### Función a extraer (capa incorrecta — debe ir a config.sh)

```
L405-L416  set_postgres_password()         11 líneas
           Operaciones: ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}'
           Estado: SE LLAMA desde main() — actualmente en capa INSTALL
           Análisis:
             - 'postgres' es el superusuario del sistema creado por apt install
             - No es un usuario de la aplicación (eso es setup.sh)
             - No es instalación de paquetes (no es apt)
             - No es configuración de archivos del SO (no es pg_hba.conf)
             - Es hardening del motor recién instalado
           Destino: MOVER a config.sh como _secure_postgres() — PASO 0 de config
           Variable requerida: POSTGRES_PASSWORD
             → Ya declarada en require_vars de bootstrap.sh (línea 44)
             → config.sh recibe el entorno del bootstrap → disponible
```

#### `main()` resultante — solo INSTALL

```bash
main() {
    validate_root
    require_vars POSTGRES_VERSION POSTGRES_PASSWORD
    ensure_dir "${PROJECT_ROOT}/logs"

    _ensure_correct_postgres_version   # detectar → stop → purge versión incorrecta
    add_postgresql_repository          # PGDG repo + GPG key + apt update
    install_postgresql                 # apt install postgresql-16 + contrib
    # FIN — sin hardening, sin configuración de archivos del SO
}
```

---

### ARCHIVO 2 — `provisioners/postgres/config.sh`

**Tamaño actual:** 207 líneas  
**Tamaño proyectado:** 227 líneas (+20)

#### Función nueva a agregar

```
_secure_postgres()                    ~15 líneas
  Operaciones:
    sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"
  Por qué aquí:
    - Hardening del motor del sistema (no de la aplicación)
    - Mismo propósito que _secure_mariadb() en el motor MariaDB
    - Se ejecuta ANTES de configurar pg_hba.conf porque pg_hba.conf
      necesita que el usuario postgres tenga password para que
      scram-sha-256 funcione correctamente
  Idempotencia:
    - ALTER USER no falla si el usuario ya tiene el password
    - Seguro ejecutar N veces
  Variable requerida: POSTGRES_PASSWORD
    → Ya en require_vars de config.sh:
      require_vars POSTGRES_VERSION DB_POSTGRES_USER
      Agregar: require_vars POSTGRES_VERSION DB_POSTGRES_USER POSTGRES_PASSWORD
```

#### `main()` resultante — SECURE + CONFIG

```bash
main() {
    validate_root
    require_vars POSTGRES_VERSION DB_POSTGRES_USER POSTGRES_PASSWORD

    log_step 1 4 "Hardening del motor (postgres system user)"
    _secure_postgres           # ALTER USER postgres WITH PASSWORD

    log_step 2 4 "pg_hba.conf — autenticación"
    _configure_pg_hba          # scram-sha-256 para django_user + remoto

    log_step 3 4 "postgresql.conf — acceso remoto"
    _configure_postgresql_conf # listen_addresses = '*'

    log_step 4 4 "Config IACT (symlink 99-iact.conf)"
    _apply_iact_postgres_config # ln -sf config/postgres/99-iact.conf
    _reload_postgresql          # pg_ctlcluster reload
}
```

---

### ARCHIVO 3 — `provisioners/mariadb/install.sh`

**Tamaño actual:** 502 líneas  
**Tamaño proyectado:** 367 líneas (-135)

#### Funciones a eliminar (código muerto — ya están en config.sh)

```
L317-L374  configure_mariadb()             57 líneas
           Operaciones: 50-server.cnf bind-address, backup_file, sed
           Estado: NO se llama desde main()
           Destino: ELIMINAR — ya existe en config.sh/_configure_mariadb_server()

L395-L423  _apply_iact_mariadb_config()    28 líneas
           Operaciones: ln -sf 99-iact.cnf → /etc/mysql/mariadb.conf.d/
           Estado: NO se llama desde main()
           Destino: ELIMINAR — ya existe en config.sh/_apply_iact_mariadb_config()
```

#### Función a extraer (capa incorrecta — debe ir a config.sh)

```
L428-L473  secure_mariadb()                45 líneas
           Operaciones:
             mysql -u root DELETE FROM mysql.user WHERE User=''
             mysql -u root DELETE FROM mysql.user WHERE User='root' AND Host NOT IN (...)
             mysql -u root DROP DATABASE IF EXISTS test
             mysql -u root ALTER USER 'root'@'localhost' IDENTIFIED BY '...'
             mysql -u root FLUSH PRIVILEGES
           Estado: SE LLAMA desde main() — actualmente en capa INSTALL
           Análisis:
             - Modifica objetos del SISTEMA en mysql.user y mysql.db
             - No es instalación de paquetes (no es apt)
             - No es configuración de archivos del SO (no es 50-server.cnf)
             - No es objeto de la BD del proyecto (no es ivr_legacy)
             - Es hardening del motor recién instalado (mysql_secure_installation)
           Destino: MOVER a config.sh como _secure_mariadb() — PASO 0 de config
           Prerequisito: MariaDB instalado y corriendo (ya garantizado por install.sh)
           Variable requerida: DB_MARIADB_ROOT_PASSWORD
             → Ya en require_vars de bootstrap.sh y de install.sh
             → config.sh actualmente solo requiere MARIADB_VERSION
             → Agregar: require_vars MARIADB_VERSION DB_MARIADB_ROOT_PASSWORD
```

#### `main()` resultante — solo INSTALL

```bash
main() {
    validate_root
    require_vars MARIADB_VERSION DB_MARIADB_ROOT_PASSWORD
    ensure_dir "${PROJECT_ROOT}/logs"

    _ensure_correct_mariadb_version    # detectar → stop → purge serie incorrecta
    add_mariadb_repository             # MariaDB.org repo + GPG key
    pin_mariadb_series                 # preferences.d — fijar serie 10.11
    install_mariadb                    # apt install mariadb-server + client
    verify_mariadb_version             # confirmar que se instaló la serie correcta
    # FIN — sin hardening, sin configuración de archivos del SO
}
```

---

### ARCHIVO 4 — `provisioners/mariadb/config.sh`

**Tamaño actual:** 169 líneas  
**Tamaño proyectado:** 219 líneas (+50)

#### Función nueva a agregar

```
_secure_mariadb()                     ~45 líneas
  Es el equivalente de mysql_secure_installation ejecutado de forma
  idempotente y no interactiva.
  Operaciones:
    Detectar método de autenticación root (unix_socket o password)
    DELETE FROM mysql.user WHERE User=''           → usuarios anónimos
    DELETE FROM mysql.user WHERE User='root'
      AND Host NOT IN ('localhost','127.0.0.1','::1') → root solo local
    DROP DATABASE IF EXISTS test                   → BD de prueba del sistema
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_MARIADB_ROOT_PASSWORD}'
    FLUSH PRIVILEGES
  Idempotencia:
    - DELETE y DROP IF EXISTS son idempotentes por naturaleza
    - ALTER USER es idempotente (no falla si el password ya es el mismo)
  Se ejecuta ANTES de _configure_mariadb_server porque secure_mariadb
  puede necesitar unix_socket auth (que viene con la instalación fresca)
  antes de que el password esté configurado.
  Variable requerida: DB_MARIADB_ROOT_PASSWORD
    → Agregar a require_vars de config.sh
```

#### `main()` resultante — SECURE + CONFIG

```bash
main() {
    validate_root
    require_vars MARIADB_VERSION DB_MARIADB_ROOT_PASSWORD

    log_step 1 4 "Hardening del motor (root, usuarios anónimos, BD test)"
    _secure_mariadb            # mysql_secure_installation idempotente

    log_step 2 4 "50-server.cnf — acceso de red (bind-address)"
    _configure_mariadb_server  # bind-address = 0.0.0.0

    log_step 3 4 "AIO — io_uring"
    _configure_mariadb_aio     # innodb_use_native_aio si no hay io_uring

    log_step 4 4 "Config IACT (symlink 99-iact.cnf)"
    _apply_iact_mariadb_config # ln -sf config/mariadb/99-iact.cnf
    _restart_mariadb           # service mariadb restart
}
```

---

## Archivos que NO cambian

### `provisioners/mariadb/bootstrap.sh` — sin cambios

Ya tiene los 4 pasos correctos desde el commit `21eb26e`:

```bash
steps=( "mariadb_system" "mariadb_install" "mariadb_config" "mariadb_setup" )
```

`mariadb_config()` llama a `config.sh main()` que ejecutará `_secure_mariadb`
automáticamente sin modificar el bootstrap.

### `provisioners/postgres/bootstrap.sh` — sin cambios

```bash
steps=( "postgres_system" "postgres_install" "postgres_config" "postgres_setup" )
```

Mismo caso.

### `provisioners/mariadb/setup.sh` — sin cambios

Contiene solo operaciones de la BD del proyecto (CNST-003):
```sql
CREATE DATABASE ivr_legacy
CREATE USER django_user (READ-ONLY por CNST-003)
GRANT SELECT ON ivr_legacy.* TO django_user
```

### `provisioners/postgres/setup.sh` — sin cambios

```sql
CREATE USER django_user
CREATE DATABASE iact_analytics OWNER django_user
GRANT ALL PRIVILEGES (desarrollo — django_user necesita CREATEDB para tests)
CREATE EXTENSION uuid-ossp, pg_trgm, hstore, citext
```

### `bootstrap.sh` (raíz) — sin cambios

Llama a `provisioners/mariadb/bootstrap.sh` y `provisioners/postgres/bootstrap.sh`.

### `setup.sh` (raíz) — sin cambios

Llama a `start.sh`, luego a `provisioners/*/setup.sh` (modo básico) o a
`scripts/provision-mariadb.sh` (modo `--full`).

### `start.sh`, `verify.sh` — sin cambios

`verify.sh` tiene 27 checks que no tocan las funciones que se mueven.
El baseline de 27 OK debe mantenerse tras la implementación.

### `utils/*` — sin cambios

Las 7 utilidades no contienen lógica de instalación ni configuración de
motor. Son helpers reutilizables por todos los provisioners.

### `scripts/provision-mariadb.sh` — sin cambios

Gestiona el ciclo de vida de ivr_legacy: SQL, SPs, grants, seed. No
invoca funciones de install.sh ni config.sh de los provisioners.

---

## Flujo completo post-Alternativa E

### Escenario 1 — Servidor limpio (fresh install)

```
bootstrap.sh
    ├─ mariadb_system    utils/system.sh
    │    apt install curl wget git ca-certificates gnupg lsb-release...
    │
    ├─ mariadb_install   provisioners/mariadb/install.sh
    │    _ensure_correct_mariadb_version()
    │      dpkg -l mariadb-server → no instalado → continuar
    │    add_mariadb_repository()
    │      lsb_release -cs → noble
    │      wget MariaDB GPG key → /usr/share/keyrings/
    │      echo "deb ... noble main" > /etc/apt/sources.list.d/mariadb.list
    │      apt-get update
    │    pin_mariadb_series()
    │      write /etc/apt/preferences.d/mariadb-pin
    │    install_mariadb()
    │      debconf-set-selections (password)
    │      apt-get install mariadb-server=10.11.x mariadb-client=10.11.x
    │      start_service mariadb → wait_ready 30s
    │    verify_mariadb_version()
    │      mysql --version → "10.11.x-MariaDB" → OK
    │
    ├─ mariadb_config    provisioners/mariadb/config.sh
    │    _secure_mariadb()                     ← NUEVO en config.sh
    │      mysql -u root (unix_socket auth)
    │      DELETE anon users
    │      DELETE root remoto
    │      DROP DATABASE test
    │      ALTER USER root IDENTIFIED BY '...'
    │      FLUSH PRIVILEGES
    │    _configure_mariadb_server()
    │      sed bind-address = 0.0.0.0 en 50-server.cnf
    │    _configure_mariadb_aio()
    │      (opcional — si no hay io_uring)
    │    _apply_iact_mariadb_config()
    │      ln -sf config/mariadb/99-iact.cnf /etc/mysql/mariadb.conf.d/
    │    _restart_mariadb()
    │
    └─ mariadb_setup     provisioners/mariadb/setup.sh
         CREATE DATABASE ivr_legacy
         CREATE USER django_user READ-ONLY
         GRANT SELECT
```

### Escenario 2 — Servidor con MariaDB 11.4 pre-instalado

```
mariadb_install:
    _ensure_correct_mariadb_version()
      mysql --version → "11.4.x-MariaDB" → serie 11.4 ≠ 10.11
      service mariadb stop
      apt-get purge mariadb-server mariadb-client mariadb-common
      rm /etc/apt/sources.list.d/mariadb.list
      rm /etc/apt/preferences.d/mariadb-pin
      apt-get autoremove
    → continúa con add_mariadb_repository / install / verify

mariadb_config:
    _secure_mariadb()
      Tras la nueva instalación: unix_socket auth disponible
      → hardening limpio sobre el motor recién instalado
```

### Escenario 3 — Re-ejecución en servidor ya configurado

```
mariadb_install:
    _ensure_correct_mariadb_version()
      mysql --version → "10.11.14-MariaDB" → serie 10.11 = 10.11 → sin cambios
    add_mariadb_repository()
      GPG key ya existe → skip
      sources.list.d ya existe → skip
    install_mariadb()
      mariadb-server ya instalado → apt no reinstala
    verify_mariadb_version() → OK

mariadb_config:
    _secure_mariadb()
      DELETE anon users → 0 rows affected (idempotente)
      DROP DATABASE test → ya no existe (idempotente)
      ALTER USER root → aplica el mismo password (idempotente)
    _configure_mariadb_server()
      grep bind-address → ya existe → sin cambios
    _apply_iact_mariadb_config()
      ln -sf → actualiza/confirma el symlink
```

---

## Resumen de cambios

| Archivo | Acción | Líneas antes | Δ | Líneas después |
|---|---|---|---|---|
| `postgres/install.sh` | Eliminar configure_postgresql + _apply_iact + set_postgres_password | 418 | -147 | 271 |
| `postgres/config.sh` | Agregar _secure_postgres() + llamada en main() + require_vars | 207 | +20 | 227 |
| `mariadb/install.sh` | Eliminar configure_mariadb + _apply_iact + secure_mariadb | 502 | -135 | 367 |
| `mariadb/config.sh` | Agregar _secure_mariadb() + llamada en main() + require_vars | 169 | +50 | 219 |
| `postgres/bootstrap.sh` | Sin cambios | 81 | 0 | 81 |
| `mariadb/bootstrap.sh` | Sin cambios | 82 | 0 | 82 |
| `postgres/setup.sh` | Sin cambios | 143 | 0 | 143 |
| `mariadb/setup.sh` | Sin cambios | 185 | 0 | 185 |
| **Total provisioners** | | **1867** | **-282** | **1585** |

**Archivos nuevos: 0**  
**Archivos eliminados: 0**  
**Archivos modificados: 4**  
**Líneas de código muerto eliminadas: 220** (configure + _apply_iact)  
**Líneas reubicadas: 56** (secure_mariadb + set_postgres_password → config.sh)  
**Reducción neta: 282 líneas**

---

## Correspondencia con roles Ansible

La separación implementada en bash refleja directamente la estructura de
roles Ansible. Migrar en el futuro es traducir funciones, no rediseñar
el sistema:

```
bash (hoy)                                Ansible (futuro)
────────────────────────────────────      ────────────────────────────────────
utils/system.sh                           roles/common/tasks/main.yml
  install_essentials()                      - apt: name: [curl, wget, git...]

provisioners/postgres/install.sh          roles/postgresql/tasks/install.yml
  _ensure_correct_postgres_version()        - apt: state=absent (purge)
  add_postgresql_repository()               - apt_key + apt_repository
  install_postgresql()                      - apt: name: [postgresql-16, contrib]

provisioners/postgres/config.sh           roles/postgresql/tasks/configure.yml
  _secure_postgres()                        - postgresql_user: password=...
  _configure_pg_hba()                       - template: src=pg_hba.conf.j2
  _configure_postgresql_conf()              - lineinfile: regexp=listen_addresses
  _apply_iact_postgres_config()             - file: state=link
  _reload_postgresql()                      - service: state=reloaded
                                            → notify: restart postgresql (handler)

provisioners/postgres/setup.sh            roles/postgresql/tasks/setup.yml
  CREATE USER django_user                   - postgresql_user: name=django_user
  CREATE DATABASE iact_analytics            - postgresql_db: name=iact_analytics
  GRANT ALL PRIVILEGES                      - postgresql_privs: privs=ALL
  CREATE EXTENSION uuid-ossp               - postgresql_ext: name=uuid-ossp

config/postgres/99-iact.conf             roles/postgresql/files/99-iact.conf
  (symlink target)                          (static file — no template porque
                                             no tiene variables dinámicas)

bootstrap.sh                             playbooks/site.yml
  run_provisioner "postgres"               - import_role: name=postgresql
  run_provisioner "mariadb"               - import_role: name=mariadb
```

La correspondencia es 1:1 porque las capas están correctamente separadas.
Si `install.sh` todavía tuviera `configure_postgresql()`, en Ansible esa
lógica estaría en `tasks/install.yml` en lugar de `tasks/configure.yml`,
creando el mismo problema de separación en otro lenguaje.

---

## Hallazgos registrados

| ID | Hallazgo | Severidad | Origen |
|---|---|---|---|
| H-INST-001 | `secure_mariadb()` en install.sh — capa incorrecta | ALTA | Este análisis |
| H-INST-002 | 220 líneas de código muerto en install.sh (configure + _apply_iact) | ALTA | Este análisis |
| H-INST-003 | `set_postgres_password()` en install.sh — capa incorrecta | ALTA | Este análisis |
| H-INST-004 | bootstrap.sh de ambos motores ya tiene la estructura de 4 pasos correcta | INFO | Este análisis |
| H-INST-005 | 0 archivos nuevos necesarios para implementar Alternativa E | INFO | Este análisis |
| H-INST-006 | `require_vars` en config.sh debe ampliarse: agregar `POSTGRES_PASSWORD` y `DB_MARIADB_ROOT_PASSWORD` | MEDIA | Este análisis |
| H-INST-007 | `_secure_postgres()` debe ejecutarse ANTES de `_configure_pg_hba()` porque pg_hba scram-sha-256 requiere que postgres tenga password | ALTA | Este análisis |
| H-INST-008 | `_secure_mariadb()` debe ejecutarse ANTES de `_configure_mariadb_server()` porque en instalación fresca root usa unix_socket auth — disponible solo antes de que se cambie la config de red | ALTA | Este análisis |
