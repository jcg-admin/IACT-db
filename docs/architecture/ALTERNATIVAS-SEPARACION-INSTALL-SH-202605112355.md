# Análisis de alternativas — Separación `install.sh` vs configuración del SO

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Contexto:** `install.sh` de MariaDB y PostgreSQL aún contiene código muerto:
`configure_mariadb()`, `configure_postgresql()`, `_apply_iact_*_config()`.
Estas funciones ya no se invocan desde `main()` pero siguen en el archivo.
El equipo decidió no mezclar instalación con configuración del SO.
Este documento analiza todas las alternativas antes de tomar la decisión.

---

## Estado actual del problema

```
provisioners/postgres/install.sh  — 417 líneas
  main(): _ensure_correct_postgres_version → add_repo → install_postgresql
           → set_postgres_password     ← CORRECTO: solo instalación

  configure_postgresql() { ... }        ← CÓDIGO MUERTO: no se llama
  _apply_iact_postgres_config() { ... } ← CÓDIGO MUERTO: no se llama

provisioners/mariadb/install.sh  — 502 líneas
  main(): _ensure_correct_mariadb_version → add_repo → pin_series
           → install_mariadb → secure_mariadb → verify_version ← CORRECTO

  configure_mariadb() { ... }           ← CÓDIGO MUERTO: no se llama
  _apply_iact_mariadb_config() { ... }  ← CÓDIGO MUERTO: no se llama
```

Las funciones viven en `install.sh` por historia: existían ahí antes de que
`config.sh` fuera creado. La pregunta es qué hacer con ellas.

---

## Referencia de la industria

El patrón de separación `install / configure / service` tiene consenso en
todas las herramientas de gestión de configuración:

**Ansible roles** — el estándar de facto para N servidores:
```
roles/postgresql/tasks/
    main.yml       → import install.yml, configure.yml, service.yml
    install.yml    → apt install postgresql-16, postgresql-contrib
    configure.yml  → template pg_hba.conf, postgresql.conf
    service.yml    → service started, enabled
```

Referencia directa: la estructura de un rol Ansible separa explícitamente
las tareas en archivos individuales como `install.yml` y `config.yml`,
importados desde `main.yml`. Las tareas de `install.yml` instalan paquetes;
las de `config.yml` renderizan archivos de configuración.

Este es exactamente el modelo que el proyecto implementó con `config.sh`.
La diferencia es que el proyecto usa bash en lugar de YAML.

**Principio de responsabilidad única** — un módulo debe tener una y solo
una razón para cambiar. Las cosas que cambian por distintas razones deben
separarse. La versión del motor cambia por una razón (nueva release).
La configuración del servicio cambia por otra (nuevo usuario, nuevo puerto).
Son razones distintas → archivos distintos.

---

## Las 6 alternativas

---

### Alternativa A — Eliminar código muerto de `install.sh` (estado limpio)

**Descripción:** Conservar `config.sh` tal como está. Eliminar de `install.sh`
las funciones que ya no se llaman: `configure_postgresql()`,
`configure_mariadb()`, `_apply_iact_*_config()`.

**Estructura resultante:**
```
provisioners/postgres/
    install.sh   → add_repo, _ensure_correct_version, install, set_password
    config.sh    → pg_hba.conf, postgresql.conf, symlink 99-iact.conf, reload
    setup.sh     → CREATE USER, DATABASE, GRANT, EXTENSION

provisioners/mariadb/
    install.sh   → add_repo, pin_series, _ensure_correct_version, install, secure
    config.sh    → bind-address, aio, symlink 99-iact.cnf, restart
    setup.sh     → CREATE DATABASE, CREATE USER, GRANT
```

**bootstrap.sh (ya implementado):**
```bash
steps=( "system" "install" "config" "setup" )
```

**Idempotencia:**
- `install.sh`: `_ensure_correct_version()` verifica antes de purgar
- `config.sh`: `grep -q` antes de agregar líneas; `ln -sf` para symlinks
- `setup.sh`: `IF NOT EXISTS`, `IF EXISTS` en DDL

**Ejecución independiente en N servidores:**
```bash
# Motor correcto instalado, config rota → solo reconfigurar
sudo bash provisioners/postgres/config.sh

# Versión incorrecta → instalar la correcta → configurar → provisionar
sudo bash provisioners/postgres/install.sh
sudo bash provisioners/postgres/config.sh
sudo bash provisioners/postgres/setup.sh
```

**Pros:**
- Sin archivos nuevos — `config.sh` ya existe
- Cada script tiene una responsabilidad única
- Ejecutable de forma independiente
- Consistente con el patrón de la industria (Ansible roles)
- El código muerto desaparece → install.sh baja de 417 a ~250 líneas

**Contras:**
- Requiere eliminar código que "funciona" (aunque no se use)
- Migración mental: el equipo debe recordar que config está en `config.sh`

---

### Alternativa B — Script único con flags `--install` / `--config` / `--setup`

**Descripción:** Un solo archivo por motor que acepta flags para ejecutar
solo la fase correspondiente.

```bash
# Un solo archivo:
provisioners/postgres/provisioner.sh --install
provisioners/postgres/provisioner.sh --config
provisioners/postgres/provisioner.sh --setup
provisioners/postgres/provisioner.sh --all   # install + config + setup
```

**Estructura interna:**
```bash
main() {
    local mode="${1:-all}"
    case "$mode" in
        --install) do_install ;;
        --config)  do_config  ;;
        --setup)   do_setup   ;;
        --all)     do_install; do_config; do_setup ;;
    esac
}
```

**Pros:**
- Un solo archivo por motor en lugar de tres
- Un punto de entrada — menos archivos que mantener

**Contras:**
- `bootstrap.sh` necesita pasar flags: más frágil
- Los flags rompen la convención del proyecto (todos los scripts usan `main()` sin args)
- Mezcla las tres responsabilidades en un archivo — el SRP se viola a nivel de archivo aunque no de función
- Si falla `--install`, el operador ejecuta `--config` sin saber si el install completó

---

### Alternativa C — Funciones de configuración en `utils/database.sh`

**Descripción:** Mover `configure_postgresql()` y `configure_mariadb()` a
`utils/database.sh` (que ya existe). Los archivos individuales las invocan
desde ahí.

```bash
# utils/database.sh agrega:
configure_postgresql() { ... }  # pg_hba.conf, postgresql.conf
configure_mariadb() { ... }     # bind-address, aio

# install.sh futura:
source "${PROJECT_ROOT}/utils/database.sh"
# ya no define configure_* — las hereda de utils/
```

**Pros:**
- Reutilización: MariaDB y PostgreSQL comparten código de configuración si hay lógica común
- DRY — no duplicar helpers entre motores

**Contras:**
- `utils/database.sh` ya tiene 185 líneas — crecer más lo hace difícil de mantener
- `database.sh` actualmente es para funciones de conexión y verificación, no de configuración
- Mezcla la capa de utilidades con la lógica específica de cada motor
- No elimina la necesidad de `config.sh` — solo mueve dónde viven las funciones
- La separación de archivos sigue siendo necesaria; esta alternativa no la resuelve

---

### Alternativa D — Adoptar Ansible

**Descripción:** Reemplazar todos los scripts bash por roles de Ansible.

```
roles/
    postgresql/
        tasks/
            main.yml    → import install.yml, configure.yml, setup.yml
            install.yml → apt, version check, purge if wrong
            configure.yml → pg_hba.conf, postgresql.conf, symlink
            setup.yml   → CREATE USER, DATABASE, GRANT
    mariadb/
        tasks/
            main.yml
            install.yml
            configure.yml
            setup.yml
```

**Pros:**
- Idempotencia por diseño: `state: present`, `state: started`
  garantizan el mismo resultado en N ejecuciones sin lógica adicional
- Handlers: configuración cambió → reinicia el servicio automáticamente
- Templating Jinja2 para archivos de configuración
- Estándar de la industria — el equipo encuentra documentación fácilmente
- Inventario: ejecutar en 50 servidores con un comando

**Contras:**
- Dependencia: requiere instalar Ansible en la máquina que ejecuta el provisioning
- Curva de aprendizaje para el equipo actual (bash → YAML + Ansible DSL)
- Los 1786 líneas de bash existentes deben reescribirse
- El proyecto tiene patrones propios (`utils/logging.sh`, `utils/core.sh`) que no migran directamente
- Complejidad operacional: `ansible-playbook` vs `sudo bash bootstrap.sh`

**Viabilidad para este proyecto:** Alta a largo plazo, costosa a corto plazo.
El costo de migración supera el beneficio inmediato. Candidata para una
decisión de arquitectura mayor en sesión separada.

---

### Alternativa E — `install.sh` verdaderamente puro (solo paquetes apt)

**Descripción:** `install.sh` hace exactamente una cosa: gestionar paquetes.
Ni siquiera llama a `secure_mariadb()` (que configura usuarios de BD —
¿es eso instalación?). Todo lo que toca archivos del SO va a `config.sh`.
Todo lo que toca la BD va a `setup.sh`.

```
install.sh  → apt: add_repo, install packages, purge if wrong version
config.sh   → SO: pg_hba.conf, bind-address, aio, symlinks, passwords del SO
setup.sh    → BD: CREATE USER, DATABASE, GRANT, EXTENSION, secure_mariadb
```

**Diferencia con Alternativa A:** `secure_mariadb()` (eliminar usuarios
anónimos, setear password root) actualmente vive en `install.sh`. ¿Es
instalación o configuración? Técnicamente es configuración de seguridad
del servicio — debería ir en `config.sh`.

**Pros:**
- `install.sh` queda con ~150 líneas (solo apt, repos, version check)
- La responsabilidad de cada archivo es inequívoca

**Contras:**
- `secure_mariadb()` en `config.sh` es semánticamente extraño — seguridad
  no es lo mismo que configuración de red
- Podría justificarse un cuarto archivo `secure.sh` — más archivos

---

### Alternativa F — Tres scripts, sin `config.sh` (config embebida en `setup.sh`)

**Descripción:** Revertir a dos archivos por motor, pero mover la
configuración del SO al inicio de `setup.sh` en lugar de `install.sh`.

```
install.sh   → solo paquetes apt
setup.sh     → PASO 0: configurar SO (pg_hba.conf, bind-address, symlinks)
               PASO 1..N: provisionar BD (CREATE USER, DATABASE, GRANT)
```

**Pros:**
- Dos archivos por motor en lugar de tres — menos archivos
- bootstrap.sh más simple: `system → install → setup`

**Contras:**
- `setup.sh` vuelve a mezclar configuración del SO con provisioning de BD
- Si falla la configuración del SO, el provisioning de BD no debe ejecutarse
- Elimina el beneficio de ejecutar solo `config.sh` en un servidor con BD ya provisionada
- Regresión al problema que se quería resolver

---

## Tabla comparativa

| Criterio | A (limpio) | B (flags) | C (utils) | D (Ansible) | E (puro) | F (regresión) |
|---|---|---|---|---|---|---|
| Responsabilidad única | ✓ | ~ | ~ | ✓ | ✓ | ✗ |
| Sin código muerto | ✓ | ✓ | ~ | ✓ | ✓ | ✓ |
| Ejecutable independiente | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Sin archivos nuevos | ✓ | ~ | ✗ | ✗ | ✓ | ✓ |
| Consistente con proyecto | ✓ | ✗ | ~ | ✗ | ✓ | ✗ |
| Costo de implementación | BAJO | MEDIO | MEDIO | ALTO | BAJO | BAJO |
| Regresión | No | No | No | No | No | Sí |
| Idempotencia garantizada | ✓ | ✓ | ✓ | ✓ | ✓ | ~ |

---

## Hallazgos adicionales durante el análisis

### H-INST-001 — `secure_mariadb()` en `install.sh`: ¿correcta la capa?

`secure_mariadb()` elimina usuarios anónimos, elimina la BD `test` y
establece el password de root. Es configuración de seguridad del servicio,
no instalación de paquetes. Actualmente vive en `install.sh`.

Opciones:
- Mantenerla en `install.sh` (convención: "dejar el motor listo para usar")
- Moverla a `config.sh` (convención: "todo lo que toca el SO va en config")
- Crear `secure.sh` (convención: separación máxima)

Decisión pendiente para el equipo.

### H-INST-002 — Código muerto acumulado: 150+ líneas en install.sh

```
provisioners/postgres/install.sh:
  configure_postgresql()        ← 115 líneas — no se llama
  _apply_iact_postgres_config() ←  30 líneas — no se llama

provisioners/mariadb/install.sh:
  configure_mariadb()           ←  50 líneas — no se llama
  _apply_iact_mariadb_config()  ←  40 líneas — no se llama
```

Total: ~235 líneas de código que no se ejecutan. Riesgo: un desarrollador
futuro las "redescubre", las llama desde algún lugar, y rompe la separación
que se diseñó.

### H-INST-003 — `set_postgres_password()` en `install.sh`: límite borroso

`set_postgres_password()` establece el password del usuario `postgres` del
sistema operativo. Es configuración del servicio, no instalación. Actualmente
en `install.sh`. Candidata a moverse a `config.sh` (Alternativa E).

---

## Recomendación

**Alternativa A** resuelve el problema inmediato sin introducir complejidad
nueva. La implementación tiene tres pasos:

```
Paso 1: Eliminar código muerto de install.sh
    - provisioners/postgres/install.sh: quitar configure_postgresql() y
      _apply_iact_postgres_config() (ya están en config.sh)
    - provisioners/mariadb/install.sh: quitar configure_mariadb() y
      _apply_iact_mariadb_config() (ya están en config.sh)

Paso 2: Actualizar changelog de install.sh con la razón del cambio

Paso 3: Verificar que verify.sh sigue en 27 OK tras la limpieza
```

**Alternativa D** (Ansible) es la arquitectura correcta a largo plazo para
un proyecto que crece a 50+ servidores, pero requiere una decisión de
inversión mayor separada.

**Alternativa E** puede aplicarse como refinamiento de A en la misma sesión
si el equipo decide que `secure_mariadb()` y `set_postgres_password()`
también pertenecen en `config.sh` y no en `install.sh`.
