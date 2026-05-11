# Análisis forense del código "muerto" — qué preservar antes de eliminar

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Pregunta central:** Antes de eliminar las 4 funciones llamadas "muertas",
¿contienen lógica que no existe en `config.sh` y que se perdería?

---

## Por qué se llaman "muertas"

Una función es código muerto cuando existe en el archivo pero ningún
camino de ejecución la invoca. La condición es verificable:

```bash
# ¿configure_postgresql() se llama desde main() de install.sh?
sed -n '/^main()/,/^}/p' provisioners/postgres/install.sh \
    | grep "configure_postgresql"
# → sin resultado → no se llama → código muerto
```

Las 4 funciones pasaron este test: ninguna aparece en el `main()` activo
de su archivo. Sin embargo, llamar "muerta" a una función no significa
que su lógica sea inútil — significa que no se ejecuta. La lógica puede
seguir siendo válida y existir en otro lugar, o puede haberse perdido
durante la migración a `config.sh`.

---

## Metodología del análisis

Para cada función "muerta":

1. ¿Está referenciada en algún otro archivo del repo? (búsqueda exhaustiva)
2. ¿Existe una función equivalente en `config.sh`?
3. ¿Son idénticas? Si difieren, ¿la diferencia es intencional o un error?
4. ¿La función "muerta" tiene lógica que `config.sh` perdió?
5. Veredicto: eliminar, integrar lógica a `config.sh`, o convertir en deuda técnica documentada

---

## Función 1 — `configure_postgresql()` en `install.sh`

### Referencias en el repo

```
provisioners/postgres/install.sh:259   → definición
provisioners/postgres/config.sh:16     → comentario que la menciona
provisioners/postgres/config.sh:90     → _configure_postgresql_conf (distinto nombre)
```

Ningún `main()` la invoca. Código muerto confirmado.

### Función equivalente en `config.sh`

`config.sh` divide la lógica en dos funciones:
- `_configure_pg_hba()` → maneja `pg_hba.conf`
- `_configure_postgresql_conf()` → maneja `postgresql.conf`

### Diferencias encontradas

| Aspecto | `configure_postgresql` (install.sh) | `config.sh` |
|---|---|---|
| `backup_file(pg_hba.conf)` | Sí — crea respaldo con timestamp | No |
| `backup_file(postgresql.conf)` | Sí | No |
| CIDR remoto TCP | `${POSTGRES_REMOTE_CIDR:-127.0.0.1/32}` (variable) | `0.0.0.0/0` (hardcoded) |
| Protocolo TCP | `md5` | `scram-sha-256` |
| Estrategia post-config | `restart_service postgresql` (baja conexiones) | `pg_ctlcluster reload` (sin bajar) |
| Verificar existencia `postgresql.conf` | Sí (`validate_file_exists`) | No |
| Verificar cambio aplicado en `postgresql.conf` | Sí (`grep listen_addresses = '*'`) | No |

### Análisis de cada diferencia

**`backup_file` — ¿es valiosa?**

```bash
backup_file() {
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup" || return 1
}
```

El backup tiene valor en la primera ejecución (instalación fresca) donde
`pg_hba.conf` contiene la configuración por defecto del paquete. Si la
configuración falla, el backup permite restaurar. En re-ejecuciones, el
backup crea archivos `.backup.*` que se acumulan sin limpiar.

**Veredicto:** La lógica es valiosa pero `config.sh` la omitió.
Debe incorporarse en `_configure_pg_hba()` y `_configure_postgresql_conf()`.

**`POSTGRES_REMOTE_CIDR` — ¿variable o hardcode?**

`configure_postgresql` usaba `${POSTGRES_REMOTE_CIDR:-127.0.0.1/32}` con
protocolo `md5`. `config.sh` hardcodeó `0.0.0.0/0` con `scram-sha-256`.

Evidencia del estado real en el servidor:

```
# /etc/postgresql/16/main/pg_hba.conf actual:
host    all    all    127.0.0.1/32    scram-sha-256
```

La configuración activa usa `scram-sha-256` y `127.0.0.1/32`. El CIDR de
`config.sh` (`0.0.0.0/0`) es más permisivo que el original y que el actual.

Evidencia adicional: `POSTGRES_REMOTE_CIDR` no está en `.env.example` —
nunca fue una variable documentada para el usuario. Era un intento de
parametrización que no se completó.

**Veredicto:** `scram-sha-256` es correcto (más seguro que `md5`, alineado
con el estado actual). El CIDR debe ser `0.0.0.0/0` para desarrollo (ya
en `config.sh`). La variable `POSTGRES_REMOTE_CIDR` fue una abstracción
incompleta — no se recupera.

**`restart` vs `reload` — ¿cuál es correcto?**

`restart_service` baja todas las conexiones y reinicia el proceso.
`pg_ctlcluster reload` recarga `pg_hba.conf` y `postgresql.conf` sin
interrumpir conexiones activas.

PostgreSQL permite reload para cambios en `pg_hba.conf` y `postgresql.conf`
(parámetros que no requieren reinicio). El reload es correcto para este
caso y menos agresivo.

**Veredicto:** `pg_ctlcluster reload` en `config.sh` es la elección
correcta. No se recupera.

**Verificación de `postgresql.conf` — ¿se perdió lógica importante?**

`configure_postgresql` verificaba que `listen_addresses = '*'` quedó
escrito. `_configure_postgresql_conf` en `config.sh` no verifica.

**Veredicto:** La verificación es valiosa. Debe incorporarse en
`_configure_postgresql_conf()`.

### Veredicto final de `configure_postgresql`

No eliminar sin incorporar primero en `config.sh`:
- `backup_file` en `_configure_pg_hba()` y `_configure_postgresql_conf()`
- Verificación post-edición en `_configure_postgresql_conf()`

La función entera no se reasigna — ya fue dividida correctamente en
dos funciones en `config.sh`. Se incorporan solo los elementos faltantes.

---

## Función 2 — `_apply_iact_postgres_config()` en `install.sh`

### Comparación con `config.sh`

```bash
# install.sh — L376-L402
_apply_iact_postgres_config() {
    local pg_version="${POSTGRES_VERSION:-16}"   ← default 16
    local conf_d="..."
    ...verifica repo_config existe
    ...verifica conf_d existe con mensaje detallado
    ln -sf "$repo_config" "$system_link"
    log_success "PostgreSQL config vinculada: ${system_link} → ${repo_config}"
}

# config.sh
_apply_iact_postgres_config() {
    local pg_version="${POSTGRES_VERSION:-16}"   ← default 16
    local conf_d="..."
    ...verifica repo_config existe
    ...verifica conf_d existe con mensaje detallado
    ln -sf "$repo_config" "$system_link"
    log_success "  Config vinculada: ${system_link} → ${repo_config}"
}
```

Las dos funciones son **funcionalmente idénticas**. La única diferencia
es el texto del mensaje de log (espaciado y prefijo).

### Veredicto final de `_apply_iact_postgres_config` en install.sh

**Eliminar directamente.** No hay lógica que recuperar. `config.sh` tiene
la versión correcta y activa de esta función.

---

## Función 3 — `configure_mariadb()` en `install.sh`

### Función equivalente en `config.sh`

`config.sh` divide la lógica en dos funciones:
- `_configure_mariadb_server()` → `bind-address`
- `_configure_mariadb_aio()` → `innodb_use_native_aio`

### Diferencias encontradas

| Aspecto | `configure_mariadb` (install.sh) | `config.sh` |
|---|---|---|
| `backup_file(50-server.cnf)` | Sí | No |
| `bind-address = 0.0.0.0` | Sí + verificación post-edición | Sí + verificación |
| `innodb_use_native_aio` (H-MDB-007) | Sí — en la misma función | Sí — en `_configure_mariadb_aio()` separada |
| `restart_service mariadb` | Sí | No — `_restart_mariadb()` usa `service restart` |
| `mysql_wait_ready(30)` | Sí — espera hasta 30s que MariaDB acepte conexiones | No |

### Análisis de cada diferencia

**`backup_file` — ¿es valiosa?**

Mismo análisis que PostgreSQL. El backup de `50-server.cnf` tiene valor
en la primera ejecución. En re-ejecuciones crea acumulación de archivos.

**Veredicto:** Debe incorporarse en `_configure_mariadb_server()`.

**`innodb_use_native_aio` — ¿se perdió?**

No. La lógica fue correctamente refactorizada a `_configure_mariadb_aio()`
en `config.sh`. La separación en función propia es una mejora.

**Veredicto:** No se recupera — ya está correctamente separada.

**`mysql_wait_ready(30)` — ¿es valiosa?**

```bash
# utils/database.sh:
mysql_wait_ready() { mariadb_wait_ready "$@"; }
mariadb_wait_ready() {
    local timeout="${1:-30}"
    local elapsed=0
    while (( elapsed < timeout )); do
        if mariadb_is_running && mysql -e "SELECT 1;" &>/dev/null 2>&1; then
            return 0
        fi
        sleep 1
        (( ++elapsed ))
    done
    return 1
}
```

`config.sh/_restart_mariadb()` hace `service mariadb restart` y luego
`log_success "MariaDB reiniciado"` sin verificar que el daemon acepte
conexiones. Si MariaDB tarda 5 segundos en arrancar, los pasos siguientes
(`_secure_mariadb`, etc.) pueden fallar con "access denied" o "can't connect".

**Veredicto:** La espera es crítica para la idempotencia. Debe incorporarse
en `_restart_mariadb()` de `config.sh`.

### Veredicto final de `configure_mariadb`

No eliminar sin incorporar primero en `config.sh`:
- `backup_file` en `_configure_mariadb_server()`
- `mariadb_wait_ready(30)` en `_restart_mariadb()`

La función entera no se reasigna — ya fue dividida correctamente en
`config.sh`. Se incorporan solo los elementos faltantes.

---

## Función 4 — `_apply_iact_mariadb_config()` en `install.sh`

### Diferencias con `config.sh`

```bash
# install.sh — L395-L423 — tiene verificación extra:
_apply_iact_mariadb_config() {
    ...
    ln -sf "$repo_config" "$system_link"
    ...
    # Verificar que MariaDB puede parsear el nuevo archivo (dry-run)
    if command -v mariadbd &>/dev/null; then
        if ! mariadbd --defaults-file=/etc/mysql/my.cnf \
                      --help --verbose 2>&1 \
                | grep -q "event_scheduler" 2>/dev/null; then
            log_warn "Advertencia: event_scheduler puede no estar activo..."
        fi
    fi
    return 0
}

# config.sh — NO tiene la verificación de parseo
_apply_iact_mariadb_config() {
    ...
    ln -sf "$repo_config" "$system_link"
    log_success "  Config vinculada: ..."
    return 0
}
```

### Análisis de la verificación faltante

```bash
mariadbd --defaults-file=/etc/mysql/my.cnf --help --verbose 2>&1 \
    | grep -q "event_scheduler"
```

Esta verificación hace que MariaDB parsee todos sus archivos de configuración
(incluyendo el recién-linkeado `99-iact.cnf`) sin iniciar el servicio.
Si `99-iact.cnf` tiene errores de sintaxis, `--help --verbose` fallará o
no mostrará `event_scheduler`. Es diagnóstico, no bloqueo.

**Valor:** Detecta errores de sintaxis en `config/mariadb/99-iact.cnf`
inmediatamente después de crear el symlink, antes de hacer restart.
Sin esta verificación, un error en `99-iact.cnf` haría que `_restart_mariadb`
falle con un error críptico de MariaDB.

**Veredicto:** La verificación es valiosa. Debe incorporarse en
`_apply_iact_mariadb_config()` de `config.sh`.

### Veredicto final de `_apply_iact_mariadb_config` en install.sh

No eliminar sin incorporar primero en `config.sh`:
- Verificación de parseo `mariadbd --defaults-file --help --verbose`

---

## Tabla de veredictos

| Función muerta | Lógica faltante en `config.sh` | Veredicto |
|---|---|---|
| `configure_postgresql` | `backup_file` pg_hba + postgresql.conf; verificación post-edición de `listen_addresses` | No eliminar hasta incorporar |
| `_apply_iact_postgres_config` | Ninguna — idéntica a la de `config.sh` | **Eliminar directamente** |
| `configure_mariadb` | `backup_file` 50-server.cnf; `mariadb_wait_ready(30)` en restart | No eliminar hasta incorporar |
| `_apply_iact_mariadb_config` | Verificación parseo `mariadbd --help --verbose` | No eliminar hasta incorporar |

---

## Elementos a incorporar en `config.sh` antes de eliminar

### `config.sh` PostgreSQL — incorporar

**En `_configure_pg_hba()`:**
```bash
# Agregar backup antes de editar
if ! backup_file "$pg_hba"; then
    log_warn "  No se pudo crear backup de ${pg_hba} — continuando"
fi
```

**En `_configure_postgresql_conf()`:**
```bash
# Agregar backup antes de editar
if ! backup_file "$pg_conf"; then
    log_warn "  No se pudo crear backup de ${pg_conf} — continuando"
fi

# Agregar verificación post-edición
if ! grep -q "listen_addresses = '\*'" "$pg_conf"; then
    log_error "  listen_addresses no se configuró correctamente"
    return 1
fi
```

### `config.sh` MariaDB — incorporar

**En `_configure_mariadb_server()`:**
```bash
# Agregar backup antes de editar
if ! backup_file "$config_file"; then
    log_warn "  No se pudo crear backup de ${config_file} — continuando"
fi
```

**En `_restart_mariadb()`:**
```bash
# Agregar espera tras restart
if service mariadb restart 2>/dev/null \
   || systemctl restart mariadb 2>/dev/null; then
    log_info "  Esperando que MariaDB acepte conexiones..."
    if mariadb_wait_ready 30 2>/dev/null; then
        log_success "  MariaDB reiniciado y listo"
    else
        log_warn "  MariaDB arrancó pero no respondió en 30s"
    fi
fi
```

**En `_apply_iact_mariadb_config()`:**
```bash
# Agregar verificación de parseo tras symlink
if command -v mariadbd &>/dev/null; then
    if ! mariadbd --defaults-file=/etc/mysql/my.cnf \
                  --help --verbose 2>&1 \
            | grep -q "event_scheduler" 2>/dev/null; then
        log_warn "  event_scheduler puede no estar activo hasta el próximo inicio"
    else
        log_success "  MariaDB parseó 99-iact.cnf correctamente"
    fi
fi
```

---

## Orden de implementación

```
Paso 1: Incorporar lógica faltante en config.sh (4 incorporaciones)
        → _configure_pg_hba: backup_file
        → _configure_postgresql_conf: backup_file + verificación post-edición
        → _configure_mariadb_server: backup_file
        → _restart_mariadb: mariadb_wait_ready(30)
        → _apply_iact_mariadb_config: verificación mariadbd --help

Paso 2: Verificar que config.sh funciona correctamente
        → bash verify.sh → 27 OK, 0 ERR

Paso 3: Eliminar de install.sh
        → _apply_iact_postgres_config (directamente, sin incorporar)
        → configure_postgresql (después del Paso 1)
        → configure_mariadb (después del Paso 1)
        → _apply_iact_mariadb_config (después del Paso 1)

Paso 4: verify.sh → 27 OK, 0 ERR (confirmar regresión cero)
```

---

## Hallazgos del análisis forense

| ID | Hallazgo | Severidad | Acción |
|---|---|---|---|
| H-DEAD-001 | `backup_file` se omitió en `config.sh` al migrar — archivos del SO se editan sin respaldo | ALTA | Incorporar antes de eliminar |
| H-DEAD-002 | `mysql_wait_ready(30)` se perdió en `_restart_mariadb()` — siguiente paso puede fallar por conexión no lista | ALTA | Incorporar antes de eliminar |
| H-DEAD-003 | Verificación de parseo `mariadbd --help` se perdió en `_apply_iact_mariadb_config` — errores de sintaxis en 99-iact.cnf no se detectan | MEDIA | Incorporar antes de eliminar |
| H-DEAD-004 | Verificación post-edición `listen_addresses` se perdió en `_configure_postgresql_conf` | MEDIA | Incorporar antes de eliminar |
| H-DEAD-005 | `POSTGRES_REMOTE_CIDR` con `md5` en install.sh era abstracción incompleta — no documentada en .env.example | INFO | No recuperar — `scram-sha-256` + `0.0.0.0/0` es correcto |
| H-DEAD-006 | `_apply_iact_postgres_config` es funcionalmente idéntica en install.sh y config.sh | INFO | Eliminar directamente sin incorporar |
| H-DEAD-007 | `restart` vs `reload` para PostgreSQL: `pg_ctlcluster reload` en config.sh es la elección correcta (no interrumpe conexiones) | INFO | No recuperar el restart de install.sh |
