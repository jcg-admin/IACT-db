# Hallazgos — Ejecución FASE 3 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 3  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-3.1 | `ssl.sh` — infraestructura `_SSL_TMPFILES` + `_cleanup_ssl_tmpfiles` + `trap` | COMPLETO | H-F3-001 |
| T-3.2 | `generate_adminer_certificate()` — 3 archivos a `mktemp` (GRUPO A) | COMPLETO | H-F3-002 |
| T-3.3 | `configure_ssl_vhost()` — `apache_ssl_test.log` a `mktemp` (GRUPO B) | COMPLETO | — |
| T-3.4 | `enable_ssl_site()` — `apache_ssl_final_test.log` a `mktemp` (GRUPO B) | COMPLETO | — |
| T-3.5 | verify.sh 27 OK sin regresión | PASA | — |

---

## H-F3-001 — BUG-009 tenía dos problemas distintos, el plan solo describía uno

**Detectado en:** T-3.1, durante el análisis de cleanup antes de implementar  
**Severidad:** ALTA — el segundo problema tiene implicación de seguridad  
**Estado:** RESUELTO en T-3.1

### Descripción

El catálogo de bugs describía BUG-009 como race condition por rutas `/tmp` fijas.
Al analizar el script en profundidad se identificó un segundo problema
independiente de la concurrencia.

**Problema 1 — Race condition (el documentado):**

Con rutas fijas como `/tmp/adminer.csr`, dos instancias del script que corran
simultáneamente (entornos de CI, múltiples Vagrant boxes, Docker) comparten los
mismos nombres de archivo:

```
Instancia A escribe /tmp/adminer_san.cnf con ADMINER_IP=192.168.1.10
Instancia B sobreescribe /tmp/adminer_san.cnf con ADMINER_IP=192.168.1.20
Instancia A lee el archivo de B → CSR con IP incorrecta
→ certificado final contiene Subject Alternative Name de B, instalado para A
→ Apache rechaza el certificado en producción (IP mismatch)
```

**Problema 2 — Sin limpieza ante señales (no documentado):**

El código original tenía cleanup explícito correcto en todos los paths de código:

```bash
# PATH 1: openssl req falla
rm -f "$san_config"        # correcto — csr_file y ext_file no existen aún

# PATH 2: openssl x509 falla
rm -f "$san_config" "$ext_file" "$csr_file"   # correcto

# PATH 3: éxito
rm -f "$san_config" "$ext_file" "$csr_file"   # correcto
```

Sin embargo, no había ningún `trap`. Si el script recibe `SIGINT` (Ctrl+C)
o `SIGTERM` mientras cualquiera de los comandos `openssl` ejecuta, `set -e`
hace que el proceso termine inmediatamente. Ninguno de los `rm -f` del código
se ejecuta. Los archivos quedan en `/tmp` indefinidamente:

```
/tmp/adminer.csr      ← contiene el CSR firmado con la clave privada
/tmp/adminer_san.cnf  ← contiene la configuración de SAN con la IP
/tmp/adminer_ext.cnf  ← contiene las extensiones del certificado
```

El CSR (`/tmp/adminer.csr`) es el archivo más sensible: contiene la
información necesaria para crear un certificado válido si se obtiene
también la clave privada de la CA. En un servidor de desarrollo compartido,
cualquier usuario con acceso a `/tmp` puede leerlo.

### Resolución

Dos mecanismos complementarios:

**1. `mktemp` elimina la race condition** (Problema 1):

```bash
# Antes: nombre fijo — compartido entre instancias
local csr_file="/tmp/adminer.csr"

# Después: nombre único por proceso
local csr_file
csr_file=$(mktemp /tmp/adminer_XXXXXX.csr)
# → /tmp/adminer_9ZPcgW.csr en instancia A
# → /tmp/adminer_Fd2rBN.csr en instancia B
```

**2. `_SSL_TMPFILES` + `trap EXIT INT TERM` elimina archivos huérfanos** (Problema 2):

```bash
# Array global — visible desde cualquier función
_SSL_TMPFILES=()

_cleanup_ssl_tmpfiles() {
    local f
    for f in "${_SSL_TMPFILES[@]:-}"; do
        [[ -n "$f" ]] && rm -f "$f" 2>/dev/null || true
    done
    _SSL_TMPFILES=()
}

# trap a nivel del script — se dispara en cualquier tipo de salida:
# - EXIT normal (return 0 o exit 0)
# - set -e activado por un comando fallido
# - SIGINT (Ctrl+C)
# - SIGTERM (kill del proceso)
trap '_cleanup_ssl_tmpfiles' EXIT INT TERM
```

Cada función registra sus archivos temporales en el array antes de usarlos:

```bash
csr_file=$(mktemp /tmp/adminer_XXXXXX.csr)
_SSL_TMPFILES+=("$csr_file")   # garantiza que el trap lo limpie
```

El cleanup explícito en cada función (al éxito y al error controlado) libera
los archivos antes del EXIT del proceso. El trap es el último recurso para
el caso de señal o error inesperado.

---

## H-F3-002 — El cleanup original de PATH 1 era correcto pero no obvio

**Detectado en:** T-3.2, durante el análisis del cleanup de `openssl req`  
**Severidad:** INFORMATIVO — el código original era correcto en ese punto  
**Estado:** DOCUMENTADO

### Descripción

En el código original, cuando `openssl req` fallaba (PATH 1), el cleanup era:

```bash
if ! openssl req -new ... -out "$csr_file" ...; then
    log_error "Failed to create CSR"
    rm -f "$san_config"    # ← solo borra san_config
    return 1
fi
```

A primera vista parece incompleto — ¿por qué no borra `csr_file` y `ext_file`?

El análisis del flujo de ejecución confirma que es correcto:

- `csr_file` es la salida de `openssl req` — si el comando falla, el archivo
  o no se creó, o se creó parcialmente y es inútil. `rm -f` de un archivo
  inexistente no es error (`-f` lo suprime). Borrarlo es correcto.
- `ext_file` se define en L223, que está **después** de la verificación de
  `openssl req` en L209. Si `openssl req` falla, la ejecución nunca llega
  a L223, por lo que `ext_file` no existe en ese punto.

Con el nuevo código, este análisis ya no es relevante porque `_cleanup_ssl_tmpfiles`
maneja todos los archivos registrados en `_SSL_TMPFILES`, sin importar cuántos
existan en el momento del cleanup.

---

## Cambios implementados

### Infraestructura global (después del bloque `readonly`)

```bash
_SSL_TMPFILES=()

_cleanup_ssl_tmpfiles() {
    local f
    for f in "${_SSL_TMPFILES[@]:-}"; do
        [[ -n "$f" ]] && rm -f "$f" 2>/dev/null || true
    done
    _SSL_TMPFILES=()
}

trap '_cleanup_ssl_tmpfiles' EXIT INT TERM
```

### `generate_adminer_certificate()` — 3 archivos (GRUPO A)

| Antes | Después |
|---|---|
| `local csr_file="/tmp/adminer.csr"` | `csr_file=$(mktemp /tmp/adminer_XXXXXX.csr)` |
| `local san_config="/tmp/adminer_san.cnf"` | `san_config=$(mktemp /tmp/adminer_san_XXXXXX.cnf)` |
| `local ext_file="/tmp/adminer_ext.cnf"` | `ext_file=$(mktemp /tmp/adminer_ext_XXXXXX.cnf)` |
| `rm -f "$san_config"` (fallo openssl req) | `_cleanup_ssl_tmpfiles` |
| `rm -f "$san_config" "$ext_file" "$csr_file"` (fallo openssl x509) | `_cleanup_ssl_tmpfiles` |
| `rm -f "$san_config" "$ext_file" "$csr_file"` (éxito) | `_cleanup_ssl_tmpfiles` |

Las tres variables se declararon juntas con `local csr_file san_config ext_file`
(sin asignación) y se asignan en líneas separadas para cumplir SC2155.

### `configure_ssl_vhost()` — 1 archivo (GRUPO B)

```bash
# Antes (hardcoded):
if ! apachectl configtest 2>&1 | tee /tmp/apache_ssl_test.log; then
    cat /tmp/apache_ssl_test.log

# Después (variable local + mktemp):
local ssl_test_log
ssl_test_log=$(mktemp /tmp/adminer_apache_test_XXXXXX.log)
_SSL_TMPFILES+=("$ssl_test_log")
if ! apachectl configtest 2>&1 | tee "$ssl_test_log"; then
    cat "$ssl_test_log"
    _cleanup_ssl_tmpfiles
    return 1
fi
_cleanup_ssl_tmpfiles
```

### `enable_ssl_site()` — 1 archivo (GRUPO B)

```bash
# Antes (hardcoded):
if ! apachectl configtest 2>&1 | tee /tmp/apache_ssl_final_test.log; then
    cat /tmp/apache_ssl_final_test.log
    a2dissite adminer-ssl.conf >/dev/null 2>&1 || true

# Después (variable local + mktemp):
local ssl_final_test_log
ssl_final_test_log=$(mktemp /tmp/adminer_apache_final_XXXXXX.log)
_SSL_TMPFILES+=("$ssl_final_test_log")
if ! apachectl configtest 2>&1 | tee "$ssl_final_test_log"; then
    cat "$ssl_final_test_log"
    a2dissite adminer-ssl.conf >/dev/null 2>&1 || true
    _cleanup_ssl_tmpfiles
    return 1
fi
_cleanup_ssl_tmpfiles
```

---

## Verificación funcional

| Test | Resultado |
|---|---|
| Cleanup explícito al éxito — 0 archivos residuales | PASA |
| Dos instancias paralelas generan nombres distintos | PASA |
| trap EXIT limpia archivos sin cleanup explícito | PASA |
| bash -n: sin errores de sintaxis | PASA |
| shellcheck -S warning: limpio | PASA |
| Sin rutas fijas `/tmp/adminer.*` en el código | PASA |
| Sin rutas fijas `/tmp/apache_ssl*` en el código | PASA |
| 5 llamadas a mktemp (3 GRUPO A + 2 GRUPO B) | PASA |
| 5 registros en `_SSL_TMPFILES` | PASA |
| 1 `trap` a nivel de script | PASA |
| verify.sh: 27 OK, 0 WARN, 0 ERR | PASA |

---

## Estado de los bugs del plan tras FASE 3

| Bug | Descripción | Estado |
|---|---|---|
| BUG-009 | Archivos `/tmp` fijos en `ssl.sh` L179/183/223 | RESUELTO — T-3.2 |
| BUG-009 ext. | Logs `/tmp/apache_ssl*.log` hardcoded | RESUELTO — T-3.3/T-3.4 |
| BUG-009 ext. | Sin `trap` para cleanup ante señales | RESUELTO — T-3.1 |
