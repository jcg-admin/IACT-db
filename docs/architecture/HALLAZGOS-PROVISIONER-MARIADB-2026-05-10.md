# Hallazgos del provisioner MariaDB

**Repositorio afectado:** IACT-db  
**Detectado durante:** Análisis del proceso de instalación — sesión 2026-05-10  
**Fecha:** 2026-05-10  
**Referencia:** `provisioners/mariadb/bootstrap.sh`, `install.sh`, `setup.sh`, `utils/core.sh`

---

## Resumen ejecutivo

El análisis del proceso de instalación registrado en la sesión anterior identificó
9 hallazgos. Los hallazgos H-MDB-001 a H-MDB-006 fueron detectados por análisis
estático del código y corregidos en esta sesión. Los hallazgos H-MDB-007 a H-MDB-009
se identificaron leyendo el proceso real del documento — son los que causaron que la
instalación fallara repetidamente y que el proceso durara más de lo esperado.

---

## Hallazgos corregidos en sesión anterior (H-MDB-001..006)

| ID | Descripción | Estado |
|---|---|---|
| H-MDB-001 | `iproute2` 404 bloquea instalación — causa raíz: índice apt obsoleto | RESUELTO |
| H-MDB-002 | `_service_action` sin fallback directo para `mariadb*` en contenedor | RESUELTO |
| H-MDB-003 | Inconsistencia de variables entre `bootstrap.sh` y `.env.example` | RESUELTO |
| H-MDB-004 | `secure_mariadb()` usa password auth para root en instalación fresca | RESUELTO |
| H-MDB-005 | `setup.sh` llama `main()` incondicionalmente — doble ejecución | RESUELTO |
| H-MDB-006 | Sin diagnóstico de crash post-arranque | RESUELTO |

### Nota sobre H-MDB-001 — `--fix-missing` descartado

La primera corrección propuesta usaba `--fix-missing` como reintento en `install_package`.
Esa opción fue descartada porque produce instalaciones inconsistentes: el paquete
aparece como `ii` en dpkg pero le faltan dependencias. El error real se traslada
a tiempo de ejecución sin causa obvia.

La causa raíz del 404 en `iproute2` no fue una dependencia irresolvable sino un
índice apt obsoleto que apuntaba a una versión ya no disponible en el mirror.
La corrección correcta es ejecutar `apt-get update` inmediatamente antes de instalar
MariaDB, dentro de `install_mariadb()`. Esto garantiza que apt resuelve versiones
actuales de todas las dependencias antes de intentar la instalación.

`install_package` quedó en su forma simple original:

```bash
install_package() {
    local package=$1
    is_package_installed "$package" && return 0
    apt-get install -y "$package" || return 1
}
```

Si falla, falla limpiamente. El caller recibe el error y puede decidir.

---

## H-MDB-007 — `io_uring` causa crash inmediato en entornos Firecracker/contenedor

**Severidad:** CRÍTICA — MariaDB arranca, reporta "ready for connections" y muere en segundos  
**Estado:** RESUELTO (2026-05-10)  
**Corrección aplicada en:** `utils/core.sh` (`_mariadb_io_uring_available()`),
`utils/database.sh` (`_mariadb_start_direct()` usa el flag al detectar io_uring restringido),
`provisioners/mariadb/install.sh` (agrega `innodb_use_native_aio=0` en `50-server.cnf`)
**Archivos:** `utils/core.sh` (`_service_action`, fallback `mariadb*`), `provisioners/mariadb/install.sh`

### Problema

El log del proceso muestra el patrón exacto del crash:

```
InnoDB: Using io_uring
...
Server socket created on IP: '0.0.0.0', port: '3306'.
mariadbd: ready for connections.
```

Inmediatamente después, `pgrep mariadbd` devuelve vacío. El proceso muere sin dejar
línea de error en el log porque `io_uring` es la causa — el kernel del entorno
Firecracker (VM ligera) restringe la syscall `io_uring_setup`. MariaDB 10.11 usa
`io_uring` por defecto para I/O asíncrono de InnoDB. Al no poder crearlo, el daemon
termina con exit code 0 (sin crashdump).

El documento confirmó la causa al intentar `--innodb-use-native-aio=0`, que desactiva
`io_uring` y usa el mecanismo de AIO del sistema operativo en su lugar:

```bash
nohup mariadbd --user=mysql \
  --innodb-use-native-aio=0 \
  ...
# → proceso vivo
```

### Por qué H-MDB-006 no captura este crash

H-MDB-006 lee el log de error cuando `mysql_wait_ready` agota su timeout. El problema
es que el log muestra `ready for connections` correctamente — el crash ocurre
**después** de escribir esa línea. El log no registra la causa porque el proceso
termina limpiamente (exit, no signal). El timeout lee el log y no encuentra error.

### Corrección pendiente

Detectar si `io_uring` está disponible en el kernel. Si no lo está, añadir
`--innodb-use-native-aio=0` al arranque directo y al archivo de configuración:

**En `_service_action` fallback `mariadb*` (`utils/core.sh`):**

```bash
# Detectar si io_uring esta disponible en el kernel
local aio_flag=""
if ! cat /proc/sys/kernel/io_uring_disabled 2>/dev/null | grep -q "^0$" \
   && ! (python3 -c "import ctypes; ctypes.CDLL(None).syscall(425,0,0,0,0,0,0)" 2>/dev/null); then
    aio_flag="--innodb-use-native-aio=0"
    log_debug "service_action: io_uring no disponible — usando --innodb-use-native-aio=0"
fi

nohup su -s /bin/bash mysql -c \
    "${daemon} \
     --datadir=/var/lib/mysql \
     --socket=/run/mysqld/mysqld.sock \
     --pid-file=${pid_file} \
     --log-error=/var/log/mysql/error.log \
     --bind-address=127.0.0.1 \
     --port=3306 \
     ${aio_flag}" \
    >/tmp/mariadbd_startup.log 2>&1 &
```

**En `configure_mariadb()` (`install.sh`):** escribir la opción en el archivo
`/etc/mysql/mariadb.conf.d/50-server.cnf` para que sea persistente:

```bash
if ! _mariadb_io_uring_available; then
    echo "" >> "$config_file"
    echo "# H-MDB-007: io_uring no disponible en este entorno (Firecracker/contenedor)" >> "$config_file"
    echo "[mysqld]" >> "$config_file"
    echo "innodb_use_native_aio = 0" >> "$config_file"
    log_success "innodb_use_native_aio=0 configurado (io_uring no disponible)"
fi
```

---

## H-MDB-008 — `mysql_install_db` no se ejecuta si `mariadb-server` falla parcialmente

**Severidad:** ALTA — `mariadbd` arranca pero muere al leer el datadir no inicializado  
**Estado:** RESUELTO (2026-05-10)  
**Corrección aplicada en:** `provisioners/mariadb/install.sh` — `install_mariadb()` verifica
si `/var/lib/mysql/ibdata1` existe antes de arrancar; si no, ejecuta `mysql_install_db`
**Archivos:** `provisioners/mariadb/install.sh` (`install_mariadb`)

### Problema

Si `iproute2` da 404, `apt-get install mariadb-server` puede fallar dejando solo
`mariadb-server-core` instalado. El script postinst de `mariadb-server` — que incluye
la llamada a `mysql_install_db` para inicializar el datadir — no se ejecuta.

El proceso del documento mostró este paso manual explícitamente:

```bash
if [ ! -f /var/lib/mysql/ibdata1 ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi
```

Sin esta inicialización, `mariadbd` arranca, intenta leer el datadir, no encuentra
los archivos del sistema (ibdata1, aria_log, etc.) y termina. El log no muestra error
claro porque el proceso termina antes de crear el socket.

El provisioner actual asume que `apt-get install mariadb-server` completa correctamente
y que el postinst inicializa el datadir. No hay verificación ni fallback.

### Corrección pendiente

Agregar en `install_mariadb()`, después de la instalación del paquete y antes de
`start_service`:

```bash
# H-MDB-008: verificar e inicializar datadir si es necesario
if [[ ! -f /var/lib/mysql/ibdata1 ]]; then
    log_info "Datadir no inicializado — ejecutando mysql_install_db"
    if command -v mysql_install_db &>/dev/null; then
        mysql_install_db --user=mysql --datadir=/var/lib/mysql 2>/dev/null \
            && log_success "Datadir inicializado" \
            || { log_error "mysql_install_db fallo"; return 1; }
    elif command -v mariadb-install-db &>/dev/null; then
        mariadb-install-db --user=mysql --datadir=/var/lib/mysql 2>/dev/null \
            && log_success "Datadir inicializado (mariadb-install-db)" \
            || { log_error "mariadb-install-db fallo"; return 1; }
    else
        log_error "No se encontro mysql_install_db ni mariadb-install-db"
        return 1
    fi
else
    log_info "Datadir ya inicializado (ibdata1 presente)"
fi
```

---

## H-MDB-009 — Entorno Firecracker no soporta MariaDB de forma estable

**Severidad:** INFORMATIVA — limitación del entorno, no del provisioner  
**Estado:** DOCUMENTADO — no requiere corrección en el provisioner  
**Referencia:** Conclusión del proceso de instalación de la sesión anterior

### Hallazgo

El documento registra la conclusión explícita del proceso:

> "El problema es que este entorno (Firecracker VM ligera) tiene restricciones.
> Vamos a confirmar si Django puede funcionar SIN MariaDB — solo con PostgreSQL,
> ya que ivr_legacy es READ-ONLY y puede ser opcional en desarrollo."

El entorno de sandbox (Claude tool — Firecracker microVM) impone restricciones
de kernel que impiden el funcionamiento estable de MariaDB:

- `io_uring_setup` syscall restringida → InnoDB usa AIO nativo, falla
- Incluso con `--innodb-use-native-aio=0`, el proceso continuó siendo inestable
- El entorno no es equivalente a Ubuntu 24.04 en bare metal o VM completa

### Implicación para el flujo de desarrollo

El provisioner debe distinguir entre:

1. **MariaDB falla por error corregible** (iproute2 404, datadir no inicializado) → corregir y reintentar
2. **MariaDB falla por limitación del entorno** (io_uring, seccomp) → continuar sin MariaDB en modo desarrollo

Django puede arrancar sin MariaDB si `ivr_legacy` no tiene conexión activa. La
configuración de desarrollo debe reflejar esto: `IVR_DB_HOST` apuntando a un host
no disponible o un stub, con el `DatabaseRouter` configurado para no fallar en import.

Este hallazgo es consistente con `HALLAZGOS-ENTORNO.md` que ya documenta patrones
similares para MariaDB en este entorno.

---

## Resumen de estado completo

| ID | Descripción | Severidad | Estado |
|---|---|---|---|
| H-MDB-001 | `install_package` sin `--fix-missing` | CRÍTICA | RESUELTO |
| H-MDB-002 | `_service_action` sin fallback `mariadb*` | CRÍTICA | RESUELTO |
| H-MDB-003 | Inconsistencia variables `bootstrap.sh` | MEDIA | RESUELTO |
| H-MDB-004 | `secure_mariadb()` password auth en instalación fresca | ALTA | RESUELTO |
| H-MDB-005 | `setup.sh` doble ejecución `main()` | BAJA | RESUELTO |
| H-MDB-006 | Sin diagnóstico de crash post-arranque | MEDIA | RESUELTO |
| H-MDB-007 | `io_uring` crash en Firecracker/contenedor | CRÍTICA | RESUELTO |
| H-MDB-008 | `mysql_install_db` faltante si postinst no ejecuta | ALTA | RESUELTO |
| H-MDB-009 | Limitación estructural del entorno Firecracker | INFORMATIVA | DOCUMENTADO |

---

## Ver también

- `utils/core.sh` — correcciones H-MDB-001, H-MDB-002 aplicadas
- `provisioners/mariadb/install.sh` — correcciones H-MDB-003..006 aplicadas
- `HALLAZGOS-ENTORNO.md` — limitaciones del entorno de sandbox documentadas
- `HALLAZGOS-PROVISIONER-POSTGRES-2026-05-10.md` — hallazgos equivalentes en PostgreSQL
