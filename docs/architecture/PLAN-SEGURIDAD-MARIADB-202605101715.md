# Plan de correcciones — Hallazgos de seguridad MariaDB

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Referencia:** `HALLAZGOS-SEGURIDAD-MARIADB-202605101700.md`  
**Hallazgos que cierra:** H-SEC-002, H-SEC-003, H-SEC-004  
**H-SEC-001:** Documentado — no requiere corrección de código

---

## Criterios de atomicidad

Cada tarea modifica exactamente un archivo o produce exactamente un resultado
verificable con un comando ejecutable. Ninguna tarea puede completarse parcialmente.

---

## FASE 0 — Entorno: corregir autenticación root (H-SEC-003)

**Objetivo:** Restablecer el estado funcional de autenticación root para TCP.
El estado actual (`authentication_string=invalid`) impide que el fallback TCP
de `my_exec_root`, `my_exec_file_root` y `my_exec_vars_root` opere, haciendo
que el provisioner falle cuando el socket no está disponible.

**Archivo afectado:** `provisioners/mariadb/install.sh`  
**Entorno:** Estado de MariaDB en el sistema de prueba

---

### T-0.1 — Verificar estado actual de autenticación root

**Acción:** Confirmar que `authentication_string=invalid` antes de aplicar la corrección.

```bash
mysql --socket=/run/mysqld/mysqld.sock -u root \
    -e "SELECT User, Host, plugin, authentication_string
        FROM mysql.user WHERE User='root';" 2>/dev/null
```

**Verificación:** Salida muestra `plugin=mysql_native_password` y
`authentication_string=invalid`.

---

### T-0.2 — Corregir authentication_string con sintaxis explícita de plugin

**Problema:** `ALTER USER ... IDENTIFIED BY '...'` cuando el plugin activo es
`unix_socket` deja `authentication_string=invalid`. El comando asigna
`mysql_native_password` como plugin pero no establece el hash correctamente.

**Diagnóstico confirmado:**
```sql
-- Comando con bug (lo que hace secure_mariadb actualmente):
ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpass123';
-- Resultado: authentication_string=invalid (bug)

-- Comando correcto:
ALTER USER 'root'@'localhost'
    IDENTIFIED VIA mysql_native_password
    USING PASSWORD('rootpass123');
-- Resultado: authentication_string=<hash_válido>
```

**Acción:** Ejecutar via socket (que sí funciona):

```bash
mysql --socket=/run/mysqld/mysqld.sock -u root -e "
    ALTER USER 'root'@'localhost'
        IDENTIFIED VIA mysql_native_password
        USING PASSWORD('rootpass123');
    FLUSH PRIVILEGES;
" 2>&1
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock -u root \
    -e "SELECT authentication_string FROM mysql.user
        WHERE User='root' AND Host='localhost';" 2>/dev/null
# Esperado: hash con formato *XXXXXXXX... (no el literal "invalid")
```

---

### T-0.3 — Verificar que root@TCP funciona con password del .env

**Acción:**
```bash
source .env
mysql -h 127.0.0.1 -u root -p"${DB_MARIADB_ROOT_PASSWORD}" \
    -e "SELECT 'TCP_root_OK';" 2>/dev/null
```

**Verificación:** Exit code 0, output contiene `TCP_root_OK`.

---

### T-0.4 — Corregir `secure_mariadb()` en `install.sh` para prevenir recurrencia

**Problema:** El comando de cambio de password en `secure_mariadb()` usa
`ALTER USER ... IDENTIFIED BY '...'` sin especificar el plugin. En una
instalación fresca de Ubuntu 24.04 donde root usa `unix_socket`, este comando
produce `authentication_string=invalid`.

**Archivo:** `provisioners/mariadb/install.sh`  
**Líneas afectadas:** 354–358 (bloque `ALTER USER`)

**Acción:** Reemplazar el bloque de cambio de password:

```bash
# Antes:
$mysql_root_cmd \
    -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_MARIADB_ROOT_PASSWORD}';" \
    2>/dev/null || \
$mysql_root_cmd \
    -e "UPDATE mysql.user SET Password=PASSWORD('${DB_MARIADB_ROOT_PASSWORD}') WHERE User='root';" \
    2>/dev/null || true

# Después:
# IDENTIFIED VIA mysql_native_password USING PASSWORD('...) especifica el plugin
# explícitamente — evita que quede authentication_string=invalid cuando el plugin
# activo era unix_socket. El fallback UPDATE también usa la columna correcta.
$mysql_root_cmd \
    -e "ALTER USER 'root'@'localhost'
        IDENTIFIED VIA mysql_native_password
        USING PASSWORD('${DB_MARIADB_ROOT_PASSWORD}');" \
    2>/dev/null || \
$mysql_root_cmd \
    -e "UPDATE mysql.user
        SET plugin='mysql_native_password',
            authentication_string=PASSWORD('${DB_MARIADB_ROOT_PASSWORD}')
        WHERE User='root' AND Host='localhost';" \
    2>/dev/null || true
```

**Verificación:**
```bash
bash -n provisioners/mariadb/install.sh && echo "Sintaxis OK"
grep -A5 "IDENTIFIED VIA" provisioners/mariadb/install.sh
# Esperado: bloque con IDENTIFIED VIA mysql_native_password USING PASSWORD(...)
```

---

## FASE 1 — Código: `DB_ROOT_SOCK` configurable (H-SEC-002)

**Objetivo:** Eliminar el hardcoding de la ruta del socket en `schema_historico.sh`.
Implementar detección automática entre rutas conocidas (coherente con
`_MARIADB_SOCKETS` en `database.sh`) y permitir override desde `.env`.

**Archivos afectados:** `provisioners/mariadb/schema_historico.sh`, `.env.example`

---

### T-1.1 — Reemplazar ruta hardcoded con detección automática de sockets

**Problema:** `DB_ROOT_SOCK="/run/mysqld/mysqld.sock"` es una constante. Si
MariaDB usa `/var/run/mysqld/mysqld.sock` (MySQL via apt vs MariaDB via apt),
el socket no se detecta y el fallback TCP se activa aunque el socket exista en
otra ruta.

**Archivo:** `provisioners/mariadb/schema_historico.sh` — línea 74

**Acción:** Reemplazar la asignación directa:

```bash
# Antes:
DB_ROOT_SOCK="/run/mysqld/mysqld.sock"

# Después:
# Detectar socket disponible entre rutas conocidas.
# Patrón coherente con _MARIADB_SOCKETS en utils/database.sh.
# Si no se encuentra ninguno: DB_ROOT_SOCK="" → activa fallback TCP.
DB_ROOT_SOCK=""
for _candidate_sock in \
    "/run/mysqld/mysqld.sock" \
    "/var/run/mysqld/mysqld.sock" \
    "/tmp/mysql.sock"; do
    if [[ -S "${_candidate_sock}" ]]; then
        DB_ROOT_SOCK="${_candidate_sock}"
        break
    fi
done
unset _candidate_sock
```

**Verificación:**
```bash
bash -n provisioners/mariadb/schema_historico.sh && echo "Sintaxis OK"
grep -n "DB_ROOT_SOCK" provisioners/mariadb/schema_historico.sh | grep -v "^[0-9]*:#"
# Esperado: el loop de detección y las referencias en my_exec_root etc.
# No debe aparecer: DB_ROOT_SOCK="/run/mysqld/mysqld.sock" (hardcoded)
```

---

### T-1.2 — Permitir override de `DB_ROOT_SOCK` desde `.env` via `MARIADB_SOCK`

**Problema:** La detección automática de T-1.1 cubre los casos más comunes, pero
un entorno con socket en ruta personalizada no puede configurarlo sin modificar
el script. La variable de entorno `MARIADB_SOCK` permite al operador especificar
la ruta exacta.

**Acción:** Envolver la detección automática de T-1.1 en una guarda que respeta
`MARIADB_SOCK` del `.env`:

```bash
# MARIADB_SOCK del .env tiene precedencia sobre la detección automática.
# Útil para: sockets en rutas no estándar, entornos de contenedor, bind mounts.
if [[ -n "${MARIADB_SOCK:-}" ]]; then
    DB_ROOT_SOCK="${MARIADB_SOCK}"
    log_debug "DB_ROOT_SOCK: usando MARIADB_SOCK del .env: ${DB_ROOT_SOCK}"
else
    # Detección automática entre rutas conocidas
    DB_ROOT_SOCK=""
    for _candidate_sock in \
        "/run/mysqld/mysqld.sock" \
        "/var/run/mysqld/mysqld.sock" \
        "/tmp/mysql.sock"; do
        if [[ -S "${_candidate_sock}" ]]; then
            DB_ROOT_SOCK="${_candidate_sock}"
            break
        fi
    done
    unset _candidate_sock
    [[ -n "${DB_ROOT_SOCK}" ]] \
        && log_debug "DB_ROOT_SOCK: detectado automáticamente: ${DB_ROOT_SOCK}" \
        || log_debug "DB_ROOT_SOCK: sin socket disponible — se usará TCP"
fi
```

**Verificación:**
```bash
bash -n provisioners/mariadb/schema_historico.sh && echo "Sintaxis OK"
grep -n "MARIADB_SOCK\|_candidate_sock\|DB_ROOT_SOCK" \
    provisioners/mariadb/schema_historico.sh | grep -v "^[0-9]*:#"
# Esperado: guarda MARIADB_SOCK + loop de detección + log_debug
```

---

### T-1.3 — Agregar `MARIADB_SOCK` comentada a `.env.example`

**Problema:** La nueva variable `MARIADB_SOCK` no existe en `.env.example`. Un
operador que revisa el archivo de referencia no sabe que puede configurar la ruta
del socket.

**Archivo:** `.env.example`

**Acción:** Agregar en la sección de MariaDB, después de `MARIADB_PORT`:

```bash
# Socket Unix de MariaDB (opcional — auto-detectado si no se especifica).
# Usar solo si el socket está en una ruta no estándar.
# Rutas conocidas (detectadas automáticamente):
#   /run/mysqld/mysqld.sock      (MariaDB via apt, Ubuntu 24.04)
#   /var/run/mysqld/mysqld.sock  (MySQL via apt)
#   /tmp/mysql.sock              (instalaciones manuales)
# MARIADB_SOCK=
```

**Verificación:**
```bash
grep -A6 "MARIADB_SOCK" .env.example
# Esperado: comentario con las 3 rutas conocidas + variable comentada
```

---

### T-1.4 — Verificar comportamiento de las funciones root con socket detectado

**Problema:** Las funciones `my_exec_root`, `my_exec_file_root` y
`my_exec_vars_root` ya usan `${DB_ROOT_SOCK}`. Con la nueva lógica de detección,
verificar que el caso `DB_ROOT_SOCK=""` (sin socket) activa correctamente el
fallback TCP, y que `[[ -S "${DB_ROOT_SOCK}" ]]` con string vacío evalúa como
false (no intenta abrir el socket vacío).

**Acción:**
```bash
bash -c '
DB_ROOT_SOCK=""
if [[ -S "${DB_ROOT_SOCK}" ]]; then
    echo "PROBLEMA: -S con string vacio evalua como true"
else
    echo "OK: -S con string vacio evalua como false — TCP fallback activado"
fi
'
```

**Verificación:** Output es `OK: -S con string vacio...`

---

## FASE 2 — Documentación: prerequisitos (H-SEC-004)

**Objetivo:** Documentar explícitamente qué estado de MariaDB requiere
`schema_historico.sh` antes de ejecutarse, para que un operador que ve un fallo
de acceso raíz sepa exactamente qué configurar.

---

### T-2.1 — Agregar bloque `PREREQUISITOS` al header de `schema_historico.sh`

**Problema:** El header documenta USO pero no los prerequisitos de infraestructura.
Un operador en un entorno recién instalado no sabe por qué falla T-1.4 ni cómo
resolverlo.

**Archivo:** `provisioners/mariadb/schema_historico.sh` — después del bloque USO

**Acción:** Agregar entre el bloque USO y `=====`:

```bash
#
# PREREQUISITOS:
#   · MariaDB instalado via provisioners/mariadb/install.sh
#     install.sh ejecuta secure_mariadb() que establece password root con
#     plugin mysql_native_password y hash válido (no "invalid").
#   · DB_MARIADB_ROOT_PASSWORD en .env corresponde al password actual de root.
#   · Socket Unix disponible (auto-detectado) O root accesible via TCP:
#       - Socket: /run/mysqld/mysqld.sock, /var/run/mysqld/mysqld.sock, /tmp/mysql.sock
#       - TCP:    mysql -h 127.0.0.1 -u root -p"${DB_MARIADB_ROOT_PASSWORD}" debe funcionar
#   · django_user NO es suficiente para este script (CNST-003: READ-ONLY).
#     Las operaciones DDL y el seed requieren root.
#   · Ejecutar como root del sistema operativo: sudo bash schema_historico.sh
```

**Verificación:**
```bash
grep -c "PREREQUISITOS\|secure_mariadb\|django_user NO es suficiente" \
    provisioners/mariadb/schema_historico.sh
# Esperado: 3
```

---

### T-2.2 — Actualizar changelog de `schema_historico.sh`

**Problema:** Los cambios de FASE 0 T-0.4, FASE 1 T-1.1..T-1.2 y FASE 2 T-2.1
no están registrados en el header del script.

**Archivo:** `provisioners/mariadb/schema_historico.sh`  
**Acción:** Actualizar `SCRIPT_VERSION` de `2.1.0` a `2.2.0` y agregar entrada de
changelog en el header con las correcciones de H-SEC-002 y H-SEC-004.

**Verificación:**
```bash
grep "SCRIPT_VERSION\|2.2.0" provisioners/mariadb/schema_historico.sh | head -3
```

---

### T-2.3 — Actualizar `install.sh` con entrada de changelog

**Archivo:** `provisioners/mariadb/install.sh`  
**Acción:** Actualizar version header a v2.2.0 y agregar entrada de changelog para
el fix de `secure_mariadb()` (H-SEC-003).

**Verificación:**
```bash
head -25 provisioners/mariadb/install.sh | grep -E "2\.2\.0|IDENTIFIED VIA"
```

---

### T-2.4 — Actualizar `HALLAZGOS-SEGURIDAD-MARIADB-202605101700.md`

**Acción:** Cambiar el estado de H-SEC-002, H-SEC-003 y H-SEC-004 a
`RESUELTO (2026-05-10)` con referencia a los archivos modificados.

**Verificación:**
```bash
grep "Estado.*PENDIENTE" \
    docs/architecture/HALLAZGOS-SEGURIDAD-MARIADB-202605101700.md
# Esperado: 0 líneas
```

---

## FASE 3 — Prueba de integración

**Objetivo:** Confirmar end-to-end que H-SEC-002 y H-SEC-003 están resueltos y que
las tres rutas de conexión raíz funcionan correctamente.

---

### T-3.1 — Probar socket en ruta estándar (caso normal)

**Precondición:** Socket `/run/mysqld/mysqld.sock` existe.

**Acción:**
```bash
SKIP_SEED=1 bash provisioners/mariadb/schema_historico.sh 2>&1 \
    | grep -E "STEP|Acceso|Socket|DB_ROOT_SOCK"
```

**Verificación:**
```
SUCCESS: Acceso OK
SUCCESS: Acceso raíz OK
DEBUG:   DB_ROOT_SOCK: detectado automáticamente: /run/mysqld/mysqld.sock
```

---

### T-3.2 — Probar detección en ruta alternativa

**Acción:** Simular socket en `/var/run/mysqld/mysqld.sock` creando un enlace
simbólico temporal y verificando que `DB_ROOT_SOCK` lo detecta:

```bash
mkdir -p /var/run/mysqld
ln -sf /run/mysqld/mysqld.sock /var/run/mysqld/mysqld.sock

# Borrar el socket estándar temporalmente para forzar la detección alternativa
# (no se puede hacer en producción — solo probar la lógica de detección)
bash -c '
source utils/logging.sh; source utils/core.sh; source utils/validation.sh
source .env 2>/dev/null || true
DB_ROOT_SOCK=""
for _s in "/run/mysqld/mysqld_inexistente.sock" \
          "/var/run/mysqld/mysqld.sock" \
          "/tmp/mysql.sock"; do
    if [[ -S "$_s" ]]; then DB_ROOT_SOCK="$_s"; break; fi
done
echo "Detectado: ${DB_ROOT_SOCK}"
'

rm -f /var/run/mysqld/mysqld.sock
```

**Verificación:** Output muestra `/var/run/mysqld/mysqld.sock` como detectado.

---

### T-3.3 — Probar fallback TCP con socket no disponible (H-SEC-003 resuelto)

**Precondición:** H-SEC-003 corregido (root@TCP funciona con rootpass123).

**Acción:** Forzar `DB_ROOT_SOCK=""` via `MARIADB_SOCK` con path inexistente en `.env`:

```bash
# Crear .env temporal sin socket
cp .env /tmp/test_nosock.env
echo "MARIADB_SOCK=/tmp/socket_inexistente.sock" >> /tmp/test_nosock.env

# Ejecutar con el .env alternativo
# (requiere parchear ENV_FILE — ver H-SEC-001 sobre limitaciones de testing)
bash -c '
source utils/logging.sh; source utils/core.sh; source utils/validation.sh

DB_MARIADB_NAME="ivr_legacy"
DB_HOST="127.0.0.1"
DB_PORT="3306"
MARIADB_SOCK="/tmp/socket_inexistente.sock"    # socket inexistente
DB_MARIADB_ROOT_PASSWORD="rootpass123"

DB_ROOT_SOCK="${MARIADB_SOCK}"
DB_ROOT_PASS="${DB_MARIADB_ROOT_PASSWORD}"

my_exec_root() {
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_MARIADB_NAME}" "$@" 2>&1
    else
        mysql --batch -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" "${DB_MARIADB_NAME}" "$@" 2>&1
    fi
}

result=$(my_exec_root -e "SELECT \"TCP_fallback_OK\";" 2>&1)
echo "Resultado: ${result}"
echo "Socket usado: $([[ -S "$DB_ROOT_SOCK" ]] && echo "socket" || echo "TCP (fallback)")"
'
```

**Verificación:**
```
Resultado: TCP_fallback_OK
Socket usado: TCP (fallback)
```

---

### T-3.4 — Probar mensaje descriptivo cuando root@TCP tampoco funciona

**Objetivo:** Verificar que el mensaje de error de T-1.4 es claro cuando ni
socket ni TCP están disponibles.

**Acción:** Ejecutar `schema_historico.sh` con socket inexistente y password
incorrecto (requiere .env temporal con credencial errónea):

```bash
bash -c '
source /tmp/references/IACT-db/utils/logging.sh
source /tmp/references/IACT-db/utils/core.sh

DB_ROOT_SOCK="/tmp/inexistente.sock"
DB_ROOT_PASS="password_incorrecto"
DB_MARIADB_NAME="ivr_legacy"
DB_HOST="127.0.0.1"
DB_PORT="3306"

my_exec_root() {
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_MARIADB_NAME}" "$@" 2>&1
    else
        mysql --batch -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" "${DB_MARIADB_NAME}" "$@" 2>&1
    fi
}

local root_check
if ! root_check=$(my_exec_root -e "SELECT 1;" 2>&1); then
    log_error "Sin acceso raíz a MariaDB — requerido para CREATE TABLE y seed."
    log_error "  Socket esperado: ${DB_ROOT_SOCK}"
    log_error "  Estado socket:   NO existe"
    log_error "  Salida: ${root_check}"
fi
'  2>&1
```

**Verificación:** Output contiene mensajes `ERROR` descriptivos con el socket
esperado y la salida real de MySQL.

---

## Resumen ejecutivo

| Fase | Tareas | Archivos | Hallazgos | Prioridad |
|---|---|---|---|---|
| FASE 0 — Entorno auth root | T-0.1..T-0.4 | `install.sh` + entorno | H-SEC-003 | ALTA |
| FASE 1 — DB_ROOT_SOCK configurable | T-1.1..T-1.4 | `schema_historico.sh`, `.env.example` | H-SEC-002 | MEDIA |
| FASE 2 — Documentación | T-2.1..T-2.4 | `schema_historico.sh`, `install.sh`, docs | H-SEC-004 | BAJA |
| FASE 3 — Integración | T-3.1..T-3.4 | — | Todos | — |

**Total: 16 tareas atómicas**

---

## Orden de ejecución obligatorio

```
FASE 0 → FASE 1 → FASE 2 → FASE 3
```

**FASE 0 antes que FASE 1:** T-3.3 de integración prueba el fallback TCP. Sin H-SEC-003
corregido (FASE 0), la prueba siempre falla independientemente de si H-SEC-002 está bien.

**FASE 0 T-0.4 puede hacerse en paralelo con FASE 1:** El fix de `install.sh` no
afecta el entorno ya running — es para prevención en futuras instalaciones. Sin embargo,
se documenta en FASE 0 por coherencia con el hallazgo H-SEC-003.

**FASE 2 T-2.1 (PREREQUISITOS) debe reflejar el comportamiento de FASE 1:** El
bloque de prerequisitos menciona la auto-detección de socket. Redactarlo antes de
implementar FASE 1 puede resultar en documentación incorrecta.

**FASE 3 es la validación de FASE 0 + FASE 1 combinadas:** T-3.3 en particular
requiere ambas para ser ejecutable.
