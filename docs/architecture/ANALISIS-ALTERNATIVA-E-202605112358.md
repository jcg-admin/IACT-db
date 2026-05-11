# Análisis de flujo — Alternativa E: `install.sh` verdaderamente puro

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Contexto:** Análisis previo a la implementación. Base para futura migración Ansible.

---

## Estado del sistema antes de implementar

```
provisioners/
    postgres/
        bootstrap.sh   81 líneas   steps: system → install → config → setup
        install.sh    418 líneas   main() correcto + 133 líneas código muerto
        config.sh     207 líneas   correcto (creado en commit 21eb26e)
        setup.sh      143 líneas   correcto
    mariadb/
        bootstrap.sh   82 líneas   steps: system → install → config → setup
        install.sh    502 líneas   main() correcto + 87 líneas código muerto
                                   + secure_mariadb() en capa incorrecta
        config.sh     169 líneas   correcto (creado en commit 21eb26e)
        setup.sh      185 líneas   correcto
```

---

## Clasificación de cada función por capa

El criterio es inequívoco: ¿qué toca la función?

| Función | Toca | Capa correcta | Está en |
|---|---|---|---|
| `_ensure_correct_postgres_version()` | `dpkg`, `apt-get purge` | INSTALL | install.sh ✓ |
| `add_postgresql_repository()` | `sources.list.d`, GPG key | INSTALL | install.sh ✓ |
| `install_postgresql()` | `apt-get install postgresql-16` | INSTALL | install.sh ✓ |
| `configure_postgresql()` | `pg_hba.conf`, `postgresql.conf` | CONFIG | install.sh ✗ (muerto) |
| `_apply_iact_postgres_config()` | `ln -sf 99-iact.conf` | CONFIG | install.sh ✗ (muerto) |
| `set_postgres_password()` | `ALTER USER postgres` (usuario del sistema) | SECURE | install.sh ✗ |
| `_ensure_correct_mariadb_version()` | `dpkg`, `apt-get purge` | INSTALL | install.sh ✓ |
| `add_mariadb_repository()` | `sources.list.d`, GPG key | INSTALL | install.sh ✓ |
| `pin_mariadb_series()` | `preferences.d` (apt pinning) | INSTALL | install.sh ✓ |
| `install_mariadb()` | `apt-get install mariadb-server` | INSTALL | install.sh ✓ |
| `configure_mariadb()` | `50-server.cnf` (bind-address) | CONFIG | install.sh ✗ (muerto) |
| `_apply_iact_mariadb_config()` | `ln -sf 99-iact.cnf` | CONFIG | install.sh ✗ (muerto) |
| `secure_mariadb()` | `mysql.user`, `mysql.db`, `ALTER USER root` | SECURE | install.sh ✗ |
| `verify_mariadb_version()` | `mysql --version` | INSTALL (post-verificación) | install.sh ✓ |

**Funciones en capa incorrecta: 6**
- 4 código muerto (configure_*, _apply_iact_*) → eliminar de install.sh
- 2 hardening del motor (secure_mariadb, set_postgres_password) → mover a config.sh

---

## Las 4 capas por motor

```
CAPA 1 — INSTALL    (paquetes del sistema operativo)
CAPA 2 — CONFIG     (archivos del servicio + hardening del motor)
CAPA 3 — SETUP      (objetos de la BD del proyecto)
```

Las capas son 3, no 4. `SECURE` no es una capa separada — es la **primera
sub-responsabilidad de CONFIG**: antes de configurar archivos del SO se
asegura el motor recién instalado. Añadir una capa `secure.sh` independiente
crearía un cuarto paso sin justificación suficiente — `secure_mariadb` y
`set_postgres_password` son "poner el motor en estado seguro para empezar
a configurar", no una fase con ciclo de vida propio.

```
bootstrap.sh
    ├── system     → utils/system.sh       paquetes base del SO
    ├── install    → install.sh            paquetes del motor (apt puro)
    ├── config     → config.sh             hardening + archivos SO + symlinks
    └── setup      → setup.sh             objetos de la BD del proyecto
```

---

## Qué cambia, archivo por archivo

### `provisioners/postgres/install.sh`

**Eliminar:**
```
L259-L364: configure_postgresql()          106 líneas — muerto, está en config.sh
L376-L402: _apply_iact_postgres_config()    27 líneas — muerto, está en config.sh
L405-L418: set_postgres_password()          14 líneas — mover a config.sh
```
Total eliminado: **147 líneas**  
Resultado: 418 → 271 líneas — solo responsabilidad INSTALL

**`main()` resultante:**
```bash
main() {
    _ensure_correct_postgres_version   # detectar/purgar versión incorrecta
    add_postgresql_repository          # agregar repo PGDG
    install_postgresql                 # apt install postgresql-16 + contrib
    # FIN — sin configuración, sin segurización
}
```

---

### `provisioners/postgres/config.sh`

**Agregar al inicio de `main()` (antes de paso 1):**
```bash
log_step 0 4 "Hardening del motor (postgres system user)"
_secure_postgres           # era set_postgres_password en install.sh
```

**Agregar función `_secure_postgres()`:**
```bash
_secure_postgres() {
    # ALTER USER postgres WITH PASSWORD '...'
    # Hardening del superusuario del sistema creado por apt.
    # No es django_user (usuario de la aplicación — eso es setup.sh).
}
```

**`main()` resultante (4 pasos):**
```bash
main() {
    log_step 1 4 "Hardening del motor"          # _secure_postgres
    log_step 2 4 "pg_hba.conf"                  # _configure_pg_hba
    log_step 3 4 "postgresql.conf"              # _configure_postgresql_conf
    log_step 4 4 "Config IACT (99-iact.conf)"   # _apply_iact_postgres_config + reload
}
```

---

### `provisioners/mariadb/install.sh`

**Eliminar:**
```
L317-L374: configure_mariadb()             58 líneas — muerto, está en config.sh
L395-L423: _apply_iact_mariadb_config()    29 líneas — muerto, está en config.sh
L428-L475: secure_mariadb()                48 líneas — mover a config.sh
```
Total eliminado: **135 líneas**  
Resultado: 502 → 367 líneas — solo responsabilidad INSTALL

**`main()` resultante:**
```bash
main() {
    _ensure_correct_mariadb_version    # detectar/purgar versión incorrecta
    add_mariadb_repository             # agregar repo MariaDB.org
    pin_mariadb_series                 # preferences.d — fijar serie 10.11
    install_mariadb                    # apt install mariadb-server + client
    verify_mariadb_version             # verificar que se instaló la serie correcta
    # FIN — sin configuración, sin segurización
}
```

---

### `provisioners/mariadb/config.sh`

**Agregar al inicio de `main()` (antes de paso 1):**
```bash
log_step 0 4 "Hardening del motor (root, anon users, test DB)"
_secure_mariadb            # era secure_mariadb() en install.sh
```

**Agregar función `_secure_mariadb()`:**
```bash
_secure_mariadb() {
    # DELETE anon users
    # DELETE root remoto
    # DROP DATABASE test
    # ALTER USER root IDENTIFIED BY
    # FLUSH PRIVILEGES
}
```

**`main()` resultante (4 pasos):**
```bash
main() {
    log_step 1 4 "Hardening del motor"          # _secure_mariadb
    log_step 2 4 "50-server.cnf (bind-address)" # _configure_mariadb_server
    log_step 3 4 "AIO (io_uring)"              # _configure_mariadb_aio
    log_step 4 4 "Config IACT (99-iact.cnf)"   # _apply_iact_mariadb_config + restart
}
```

---

### `provisioners/postgres/bootstrap.sh` — sin cambios

```bash
steps=( "postgres_system" "postgres_install" "postgres_config" "postgres_setup" )
```
Ya tiene la estructura de 4 pasos correcta.

### `provisioners/mariadb/bootstrap.sh` — sin cambios

```bash
steps=( "mariadb_system" "mariadb_install" "mariadb_config" "mariadb_setup" )
```
Ya tiene la estructura de 4 pasos correcta.

### `provisioners/postgres/setup.sh` — sin cambios
### `provisioners/mariadb/setup.sh` — sin cambios

---

## Resumen: qué archivos cambian y cómo

| Archivo | Acción | Cambio neto |
|---|---|---|
| `postgres/install.sh` | Eliminar 3 funciones (2 muertas + `set_postgres_password`) | -147 líneas |
| `postgres/config.sh` | Agregar `_secure_postgres()` + llamada en `main()` | +~20 líneas |
| `mariadb/install.sh` | Eliminar 3 funciones (2 muertas + `secure_mariadb`) | -135 líneas |
| `mariadb/config.sh` | Agregar `_secure_mariadb()` + llamada en `main()` | +~50 líneas |
| `postgres/bootstrap.sh` | Sin cambios | 0 |
| `mariadb/bootstrap.sh` | Sin cambios | 0 |
| `postgres/setup.sh` | Sin cambios | 0 |
| `mariadb/setup.sh` | Sin cambios | 0 |

**Archivos nuevos creados: 0**  
**Archivos modificados: 4**  
**Líneas de código muerto eliminadas: 282**

---

## Resultado proyectado

```
provisioners/
    postgres/
        bootstrap.sh   81 líneas  (sin cambios)
        install.sh    271 líneas  (-147)  INSTALL puro: version, repo, apt
        config.sh     227 líneas  (+20)   SECURE + CONFIG: hardening, pg_hba, symlink
        setup.sh      143 líneas  (sin cambios)
    mariadb/
        bootstrap.sh   82 líneas  (sin cambios)
        install.sh    367 líneas  (-135)  INSTALL puro: version, repo, pin, apt
        config.sh     219 líneas  (+50)   SECURE + CONFIG: hardening, bind-addr, symlink
        setup.sh      185 líneas  (sin cambios)
```

---

## Flujo completo en un servidor con versión incorrecta pre-instalada

```
sudo bash bootstrap.sh
    │
    ├── postgres_system()     [utils/system.sh]
    │       apt install curl, wget, git, ca-certificates...
    │
    ├── postgres_install()    [install.sh — INSTALL PURO]
    │       _ensure_correct_postgres_version()
    │           dpkg -l postgresql-14 → existe, no es 16
    │           pg_ctlcluster 14 main stop
    │           apt-get purge postgresql-14 postgresql-client-14
    │           rm -rf /etc/postgresql/14
    │       add_postgresql_repository()
    │           lsb_release -cs → noble
    │           wget PGDG signing key
    │           echo "deb ... noble-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    │           apt-get update
    │       install_postgresql()
    │           apt-get install postgresql-16 postgresql-contrib-16
    │           wait for service
    │
    ├── postgres_config()     [config.sh — SECURE + CONFIG]
    │       _secure_postgres()
    │           ALTER USER postgres WITH PASSWORD '...'
    │       _configure_pg_hba()
    │           grep -q django_user pg_hba.conf → no existe
    │           sed -i insertar regla scram-sha-256
    │       _configure_postgresql_conf()
    │           sed -i listen_addresses = '*'
    │       _apply_iact_postgres_config()
    │           ln -sf config/postgres/99-iact.conf conf.d/
    │       _reload_postgresql()
    │           pg_ctlcluster 16 main reload
    │
    └── postgres_setup()      [setup.sh — OBJETOS DE LA BD]
            CREATE USER django_user WITH PASSWORD '...'
            CREATE DATABASE iact_analytics OWNER django_user
            GRANT ALL PRIVILEGES ...
            ALTER ROLE django_user CREATEDB
            CREATE EXTENSION IF NOT EXISTS uuid-ossp
            CREATE EXTENSION IF NOT EXISTS pg_trgm
```

---

## Base para futura migración a Ansible

La correspondencia bash → Ansible es directa porque las 3 capas del proyecto
se alinean con la estructura canónica de un rol Ansible:

```
Bash (hoy)                    Ansible (futuro)
─────────────────────────     ────────────────────────────────
utils/system.sh               roles/common/tasks/main.yml
install.sh                    roles/postgresql/tasks/install.yml
config.sh (secure + config)   roles/postgresql/tasks/secure.yml
                              roles/postgresql/tasks/configure.yml
setup.sh                      roles/postgresql/tasks/setup.yml
config/postgres/99-iact.conf  roles/postgresql/templates/99-iact.conf.j2
bootstrap.sh                  playbooks/postgresql.yml
```

Cada función bash se convierte en una task Ansible:

```yaml
# roles/postgresql/tasks/install.yml
- name: Detect installed PostgreSQL versions
  shell: dpkg -l 'postgresql-[0-9]*' | awk '/^ii/{print $2}'
  register: pg_installed

- name: Purge incorrect PostgreSQL versions
  apt:
    name: "{{ item }}"
    state: absent
    purge: yes
  loop: "{{ pg_installed.stdout_lines | ... }}"
  when: item does not match target_version

- name: Install PostgreSQL {{ postgres_version }}
  apt:
    name:
      - postgresql-{{ postgres_version }}
      - postgresql-contrib-{{ postgres_version }}
    state: present
```

La separación en bash que estamos implementando no es un paso previo
a Ansible — es la misma arquitectura expresada en un lenguaje diferente.
Migrar a Ansible en el futuro no requerirá rediseñar el flujo, solo
traducir funciones bash a tasks YAML.

---

## Hallazgos del análisis

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-INST-001 | `secure_mariadb` en install.sh — capa incorrecta | ALTA | PENDIENTE |
| H-INST-002 | 282 líneas de código muerto en install.sh de ambos motores | ALTA | PENDIENTE |
| H-INST-003 | `set_postgres_password` en install.sh — capa incorrecta | ALTA | PENDIENTE |
| H-INST-004 | bootstrap.sh de ambos motores ya tiene la estructura de 4 pasos correcta | INFO | DOCUMENTADO |
| H-INST-005 | 0 archivos nuevos necesarios — Alternative E se implementa modificando 4 archivos | INFO | DOCUMENTADO |
