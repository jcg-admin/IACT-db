# Plan de correcciones — Hallazgos de ejecución IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Referencia:** `HALLAZGOS-EJECUCION-2026-05-10.md`  
**Hallazgos que cierra:** H-EXEC-005, H-EXEC-006, H-EXEC-007, H-EXEC-008, H-EXEC-009

---

## Criterios de atomicidad

Cada tarea modifica exactamente un archivo o produce exactamente un resultado
verificable. Ninguna tarea puede completarse parcialmente. La verificación de
cada tarea es ejecutable — no es subjetiva.

---

## FASE 0 — `schema_historico.sh`: variables y helpers de conexión raíz

**Objetivo:** Establecer la infraestructura de conexión privilegiada antes de
corregir DDL y seed. `schema_historico.sh` es un provisioner que corre como root;
usar `django_user` (READ-ONLY por CNST-003) para DDL es una contradicción
arquitectónica.

**Archivo:** `provisioners/mariadb/schema_historico.sh`

---

### T-0.1 — Agregar variables de conexión raíz

**Problema:** El bloque de configuración (líneas 61–65) solo define `DB_USER` y
`DB_PASS` con defaults a `django_user`. No hay variables para conexión raíz.

**Acción:** Después de las variables `DB_PORT` y antes de `SEED_ROWS`, agregar:

```bash
# Conexión raíz para operaciones DDL (CREATE TABLE, INSERT en tbl_historico_*).
# Socket Unix: sin password en Ubuntu/Debian (peer auth para root).
# TCP fallback: usa DB_MARIADB_ROOT_PASSWORD del .env.
DB_ROOT_SOCK="/run/mysqld/mysqld.sock"
DB_ROOT_PASS="${DB_MARIADB_ROOT_PASSWORD:-}"
```

**Verificación:**
```bash
bash -c 'source provisioners/mariadb/schema_historico.sh 2>/dev/null; \
    echo "${DB_ROOT_SOCK:-FALTA}"'
# Esperado: /run/mysqld/mysqld.sock
```

---

### T-0.2 — Agregar `my_exec_root()` para queries inline como raíz

**Problema:** `my_exec()` conecta como `django_user`. Las verificaciones dentro de
funciones de provisioning (conteos de tablas, estado de seed) deben ejecutarse
como root para ver todos los objetos sin restricciones de privilegio.

**Acción:** Después de `my_exec_file()`, agregar:

```bash
# my_exec_root [args...]
#   Ejecuta una query inline como root.
#   Socket Unix si disponible (sin password), TCP con root password como fallback.
my_exec_root() {
    if [[ -S "$DB_ROOT_SOCK" ]]; then
        mysql --batch --socket="$DB_ROOT_SOCK" "$DB_NAME" "$@" 2>&1
    else
        mysql --batch -h "$DB_HOST" -P "$DB_PORT" \
              -u root -p"$DB_ROOT_PASS" "$DB_NAME" "$@" 2>&1
    fi
}
```

**Verificación:**
```bash
grep -c "my_exec_root()" provisioners/mariadb/schema_historico.sh
# Esperado: 1
```

---

### T-0.3 — Agregar `my_exec_file_root()` para archivos SQL como raíz

**Problema:** `my_exec_file()` conecta como `django_user` y se usa para ejecutar
`schema_historico.sql` que contiene `CREATE TABLE`. `django_user` no tiene
privilegio `CREATE` (CNST-003) → ERROR 1142 silencioso.

**Acción:** Después de `my_exec_root()`, agregar:

```bash
# my_exec_file_root <archivo.sql>
#   Ejecuta un archivo SQL completo como root.
#   Usado para DDL (CREATE TABLE IF NOT EXISTS).
my_exec_file_root() {
    if [[ -S "$DB_ROOT_SOCK" ]]; then
        mysql --batch --socket="$DB_ROOT_SOCK" "$DB_NAME" < "$1" 2>&1
    else
        mysql --batch -h "$DB_HOST" -P "$DB_PORT" \
              -u root -p"$DB_ROOT_PASS" "$DB_NAME" < "$1" 2>&1
    fi
}
```

**Verificación:**
```bash
grep -c "my_exec_file_root()" provisioners/mariadb/schema_historico.sh
# Esperado: 1
```

---

### T-0.4 — Agregar `my_exec_vars_root()` para seed de tablas históricas como raíz

**Problema:** `my_exec_vars()` conecta como `django_user` y se usa para el seed
de datos en `tbl_historico_*`. `django_user` solo tiene `SELECT` en `ivr_legacy.*`
— no `INSERT`. El seed fallaría con ERROR 1142 si llegara a ejecutarse.

**Acción:** Después de `my_exec_file_root()`, agregar:

```bash
# my_exec_vars_root <archivo.sql>
#   Ejecuta un archivo SQL con variables de sesión inyectadas, como root.
#   Usado para el seed de tbl_historico_* (INSERT masivo).
my_exec_vars_root() {
    local sql_file="$1"
    {
        echo "SET @SEED_ROWS    = ${SEED_ROWS};"
        echo "SET @FORCE_RESEED = ${FORCE_RESEED};"
        echo "SET @COMMIT_HASH  = '${COMMIT_HASH}';"
        echo "SET @SCRIPT_VER   = '${SCRIPT_VERSION}';"
        cat "$sql_file"
    } | if [[ -S "$DB_ROOT_SOCK" ]]; then
            mysql --batch --socket="$DB_ROOT_SOCK" "$DB_NAME" 2>&1
        else
            mysql --batch -h "$DB_HOST" -P "$DB_PORT" \
                  -u root -p"$DB_ROOT_PASS" "$DB_NAME" 2>&1
        fi
}
```

**Verificación:**
```bash
grep -c "my_exec_vars_root()" provisioners/mariadb/schema_historico.sh
# Esperado: 1
```

---

## FASE 1 — `schema_historico.sh`: corregir DDL y seed (H-EXEC-005 + H-EXEC-006)

**Objetivo:** Usar las funciones raíz de FASE 0 en los lugares donde se necesitan
privilegios DDL. Separar la captura de salida del manejo de errores para que los
fallos de MySQL sean visibles y fatales.

**Archivo:** `provisioners/mariadb/schema_historico.sh`

---

### T-1.1 — Reemplazar `my_exec_file()` con `my_exec_file_root()` en `create_tables()`

**Problema:** La línea que aplica `schema_historico.sql` usa `my_exec_file()` que
conecta como `django_user`. Con el cambio a `my_exec_file_root()`, las tablas se
crearán correctamente.

**Acción:** En la función `create_tables()`, reemplazar:

```bash
# Antes:
my_exec_file "$SCHEMA_SQL" | grep -v "^$" | while IFS= read -r line; do
    log_info "  ${line}"
done || true

log_success "Schema aplicado"
```

**Verificación de la línea antes:**
```bash
grep -n "my_exec_file.*SCHEMA_SQL" provisioners/mariadb/schema_historico.sh
```

---

### T-1.2 — Corregir manejo de errores en `create_tables()` (H-EXEC-006)

**Problema:** El patrón `| while ...; done || true` descarta el exit code del
comando MySQL. El `|| true` suprime ERROR 1142, ERROR 1064 y ERROR 2002 por igual,
emitiendo siempre `log_success "Schema aplicado"`.

**Acción:** Reemplazar el bloque completo (incluyendo el `log_success`) con una
captura de output y verificación de exit code explícita. Dependencia de T-1.1:

```bash
# Después — capturar output y verificar exit code por separado
local schema_output
if ! schema_output=$(my_exec_file_root "$SCHEMA_SQL" 2>&1); then
    log_error "schema_historico.sql falló — salida del servidor:"
    echo "$schema_output" | grep -v "^$" | while IFS= read -r line; do
        log_error "  ${line}"
    done
    log_fatal "CREATE TABLE falló — revisar permisos y sintaxis SQL"
fi
echo "$schema_output" | grep -v "^$" | while IFS= read -r line; do
    log_info "  ${line}"
done
log_success "Schema aplicado"
```

**Verificación:**
```bash
bash -n provisioners/mariadb/schema_historico.sh && echo "Sintaxis OK"
grep -c "|| true" provisioners/mariadb/schema_historico.sh
# Esperado: 0 (el único || true debe ser eliminado)
```

---

### T-1.3 — Reemplazar `my_exec_vars()` con `my_exec_vars_root()` en seed de tablas históricas

**Problema:** El seed de `tbl_historico_*` usa `my_exec_vars()` que conecta como
`django_user`. `django_user` no tiene `INSERT` en esas tablas (los grants de
T-1.4 del plan anterior solo cubren tablas analíticas). El seed fallará con
ERROR 1142 si SKIP_SEED no está activo.

**Acción:** En la función `create_tables()`, dentro del bloque `else` del
`if [[ "${SKIP_SEED}" == "1" ]]`, reemplazar:

```bash
# Antes:
if ! my_exec_vars "$SEED_SQL" | grep -v "^$" | while IFS= read -r line; do
    log_info "  ${line}"
done; then
```

Por:

```bash
# Después:
if ! my_exec_vars_root "$SEED_SQL" | grep -v "^$" | while IFS= read -r line; do
    log_info "  ${line}"
done; then
```

**Verificación:**
```bash
grep -n "my_exec_vars" provisioners/mariadb/schema_historico.sh
# Esperado: 0 líneas con my_exec_vars (sin _root), solo my_exec_vars_root
```

---

### T-1.4 — Actualizar `check_prerequisites()` para verificar acceso raíz

**Problema:** `check_prerequisites()` verifica acceso con `my_ping()` que usa
`django_user`. Si el socket raíz no está disponible y `DB_MARIADB_ROOT_PASSWORD`
está vacío, el provisioner llegará a CREATE TABLE y fallará con un error de auth
poco descriptivo.

**Acción:** En `check_prerequisites()`, después del `my_ping()` existente, agregar
verificación de acceso raíz:

```bash
# Verificar acceso raíz — necesario para DDL (CREATE TABLE)
local root_test
if ! root_test=$(my_exec_root -e "SELECT 1;" 2>&1); then
    log_fatal "Sin acceso raíz a MariaDB — requerido para CREATE TABLE.
  Via socket: ${DB_ROOT_SOCK} (debe existir y ser accesible)
  Via TCP:    DB_MARIADB_ROOT_PASSWORD debe estar configurado en .env"
fi
log_debug "Acceso raíz verificado"
```

**Verificación:**
```bash
grep -n "acceso raíz\|root_test\|my_exec_root.*SELECT 1" \
    provisioners/mariadb/schema_historico.sh
# Esperado: 3 líneas (las tres agregadas)
```

---

### T-1.5 — Agregar `require_vars DB_MARIADB_ROOT_PASSWORD` solo para TCP

**Problema:** Si el socket no está disponible y `DB_MARIADB_ROOT_PASSWORD` está
vacío, MySQL intentará conectar con password vacío y fallará. El error no es
descriptivo. `require_vars` lo detecta antes de intentar cualquier conexión.

**Acción:** En `main()`, después de cargar `.env`, agregar validación condicional:

```bash
if [[ ! -S "$DB_ROOT_SOCK" ]]; then
    # Sin socket Unix, la conexión raíz necesita password explícito
    require_vars DB_MARIADB_ROOT_PASSWORD
fi
```

**Verificación:**
```bash
grep -n "require_vars.*ROOT" provisioners/mariadb/schema_historico.sh
# Esperado: 1 línea
```

---

## FASE 2 — `schema_historico.sh`: corregir `column` (H-EXEC-007)

**Objetivo:** Eliminar la dependencia de `column` como comando externo. Su ausencia
genera un `WARN` engañoso que hace creer que `seed_executions` no existe.

**Archivo:** `provisioners/mariadb/schema_historico.sh`

---

### T-2.1 — Reemplazar `column -t` por fallback compatible

**Problema:** Línea 342 usa `column -t` para formatear la tabla de historial de
ejecuciones. `column` no está disponible en Ubuntu minimal. El pipeline
`query | column -t || log_warn "..."` interpreta la ausencia del binario como
ausencia de la tabla.

**Acción:** Reemplazar el pipeline `| column -t`:

```bash
# Antes:
my_exec ... | column -t \
    || log_warn "seed_executions no disponible aun"

# Después:
if command -v column &>/dev/null; then
    my_exec ... 2>/dev/null | column -t \
        || log_warn "seed_executions no disponible aun"
else
    my_exec ... 2>/dev/null \
        || log_warn "seed_executions no disponible aun"
fi
```

**Verificación:**
```bash
grep -n "command -v column" provisioners/mariadb/schema_historico.sh
# Esperado: 1 línea
grep "column -t" provisioners/mariadb/schema_historico.sh | grep -v "command -v"
# Esperado: 0 líneas (no debe quedar uso directo sin guarda)
```

---

## FASE 3 — `setup.sh`: corregir `SKIP_SEED` (H-EXEC-009)

**Objetivo:** Eliminar `${SKIP_SEED:+--skip-seed}` y reemplazarlo con comparación
explícita. El patrón `${var:+word}` es incompatible con la semántica booleana
numérica (`0=false`, `1=true`) porque "0" es no vacío y activa el flag.

**Archivo:** `setup.sh` (raíz IACT-db)

---

### T-3.1 — Cambiar el default de `SKIP_SEED` de `"0"` a vacío

**Problema:** `export SKIP_SEED="${SKIP_SEED:-0}"` inicializa con "0" para
satisfacer `set -u`. Con el nuevo enfoque de comparación explícita, el estado
"no activo" debe ser el string vacío, no "0", para que la convención sea coherente:
vacío o no definido = no saltar; "1" = saltar.

**Acción:**

```bash
# Antes:
export SKIP_SEED="${SKIP_SEED:-0}"

# Después:
export SKIP_SEED="${SKIP_SEED:-}"
```

**Verificación:**
```bash
grep "SKIP_SEED:-" setup.sh | grep -v "^#"
# Esperado: export SKIP_SEED="${SKIP_SEED:-}"
```

---

### T-3.2 — Reemplazar `${SKIP_SEED:+--skip-seed}` con `if` explícito

**Problema:** `${SKIP_SEED:+--skip-seed}` evalúa a `--skip-seed` para cualquier
valor no vacío incluyendo `"0"`. Con el default anterior de `"0"`, el seed siempre
se omitía.

**Acción:** En `run_mariadb_setup()`, reemplazar:

```bash
# Antes:
if bash "${PROJECT_ROOT}/scripts/provision-mariadb.sh" ${SKIP_SEED:+--skip-seed}; then

# Después:
local seed_flag=""
[[ "${SKIP_SEED}" == "1" ]] && seed_flag="--skip-seed"
if bash "${PROJECT_ROOT}/scripts/provision-mariadb.sh" ${seed_flag}; then
```

**Verificación:**
```bash
bash -n setup.sh && echo "Sintaxis OK"
grep "SKIP_SEED:+" setup.sh | grep -v "^#"
# Esperado: 0 líneas — el patrón eliminado no debe aparecer en código
```

---

### T-3.3 — Actualizar el comentario de `SKIP_SEED` en setup.sh

**Problema:** El comentario en línea 61–63 explica la inicialización a "0" y el
propósito de `set -u`. Tras el cambio, el comentario es incorrecto y puede
confundir.

**Acción:** Reemplazar el comentario:

```bash
# Antes:
# T-0.4: definir SKIP_SEED explícitamente para evitar "unbound variable" con set -u.
# El operador puede sobreescribirlo antes de ejecutar: SKIP_SEED=1 sudo bash setup.sh ...
export SKIP_SEED="${SKIP_SEED:-0}"

# Después:
# SKIP_SEED: vacío (default) = ejecutar seed; "1" = omitir seed.
# Usar string vacío como default — ${var:+word} no se usa; la comparación
# es explícita [[ "${SKIP_SEED}" == "1" ]] para evitar ambigüedad con "0".
export SKIP_SEED="${SKIP_SEED:-}"
```

**Verificación:**
```bash
grep -A1 "SKIP_SEED: vacío" setup.sh
# Esperado: línea de comentario + export
```

---

### T-3.4 — Actualizar el header de setup.sh con el ejemplo corregido

**Problema:** El header en línea 30 documenta `SKIP_SEED=1` como ejemplo de
uso — esto sigue siendo correcto. Pero también hay que revisar si algún ejemplo
menciona `SKIP_SEED=0` como forma de desactivarlo.

**Acción:** Revisar las líneas de ejemplo del header. Si existe `SKIP_SEED=0`
como ejemplo, eliminarlo. Si no existe, confirmar que los ejemplos vigentes son
correctos y actualizar versión del header.

**Verificación:**
```bash
grep "SKIP_SEED=0" setup.sh
# Esperado: 0 líneas
head -5 setup.sh | grep "Versión\|version"
```

---

## FASE 4 — `verify.sh`: verificación de tablas históricas (H-EXEC-008)

**Objetivo:** `verify.sh 3b` debe detectar cuando `schema_historico.sh` no creó
las tablas `tbl_historico_*`. Actualmente el entorno pasa la verificación con 25 OK
aunque las tablas históricas no existan.

**Archivo:** `verify.sh`

---

### T-4.1 — Agregar bloque de verificación de tablas históricas en `check_mariadb_schema()`

**Problema:** `check_mariadb_schema()` verifica tablas analíticas, funciones y SPs
pero no `tbl_historico_*`. Las 6 tablas históricas son el origen de datos del
pipeline ETL — su ausencia es un error crítico equivalente al de las tablas analíticas.

**Acción:** Después del bloque de tablas analíticas (después del `if [[ $tbl_miss -eq 0 ]]`),
agregar:

```bash
# ── Tablas históricas (schema_historico.sh) ───────────────────────────────
# Verificación por patrón: las 6 tablas tienen nombres dinámicos
# (tbl_historico_tN_YYYY) generados en schema_historico.sh.
# Se esperan exactamente 6 (t1..t4 de 2025 + t1..t2 de 2026).
local hist_count
hist_count=$(_mdb_schema_q \
    "SELECT COUNT(*) FROM tables
     WHERE table_schema='${DB_MARIADB_NAME}'
     AND table_name LIKE 'tbl_historico_%';")
if [[ "${hist_count:-0}" -ge 6 ]]; then
    ok "Tablas históricas presentes: ${hist_count}"
else
    fail "Tablas históricas incompletas: ${hist_count}/6 — ejecutar: sudo bash setup.sh mariadb --full"
fi
```

**Verificación:**
```bash
bash -n verify.sh && echo "Sintaxis OK"
grep -n "tbl_historico" verify.sh
# Esperado: al menos 1 línea en check_mariadb_schema
```

---

### T-4.2 — Verificar que `fail` se usa (no `warn`) para tablas históricas faltantes

**Problema:** Las tablas históricas son el origen de datos del pipeline ETL. Su
ausencia debe ser un error (`fail` → incrementa `ERR`, exit code 1), no una
advertencia (`warn` → solo incrementa `WARN`, exit code 0).

**Acción:** Confirmar que el `fail` del bloque T-4.1 es correcto. Revisar que
`fail` llama a `log_error` y que incrementa `ERR` en el resumen final.

**Verificación:**
```bash
grep -A1 "^fail()" verify.sh
# Esperado: log_error + ERR=$(( ERR + 1 ))
```

---

## FASE 5 — Integración y prueba

**Objetivo:** Confirmar end-to-end que todas las correcciones funcionan juntas y que
no se introdujeron regresiones.

---

### T-5.1 — Verificar sintaxis de todos los archivos modificados

**Acción:**
```bash
for f in provisioners/mariadb/schema_historico.sh setup.sh verify.sh; do
    bash -n "$f" && echo "OK: $f" || echo "FALLO: $f"
done
```

**Verificación:** Los tres archivos producen `OK`.

---

### T-5.2 — Confirmar que `verify.sh` detecta tablas históricas faltantes (ANTES de `--full`)

**Estado esperado:** `ivr_legacy` existe, `tbl_historico_*` no existen.

**Acción:**
```bash
bash verify.sh 2>&1 | grep -E "historica|3b/8|Errores:"
```

**Verificación:**
```
FAIL: Tablas históricas incompletas: 0/6
Errores: N  (N ≥ 1)
```

---

### T-5.3 — Ejecutar `setup.sh mariadb --full` sin `SKIP_SEED` y confirmar seed corre

**Estado esperado:** Con el fix de T-3.1/T-3.2, `SKIP_SEED` vacío no pasa
`--skip-seed` → el seed histórico debe ejecutarse.

**Acción:**
```bash
bash setup.sh mariadb --full 2>&1 | grep -E "SKIP_SEED|seed|tbl_historico"
```

**Verificación:**
```
SKIP_SEED:    (vacío o no aparece "1")
Schema aplicado
Seed completado y verificado     ← NO debe aparecer "seed omitido"
```

---

### T-5.4 — Confirmar que `SKIP_SEED=1` sí omite el seed

**Acción:**
```bash
SKIP_SEED=1 bash setup.sh mariadb --full 2>&1 | grep -E "SKIP_SEED|seed omitido"
```

**Verificación:**
```
SKIP_SEED:    1
SKIP_SEED=1 — seed omitido
```

---

### T-5.5 — Ejecutar `verify.sh` completo después de `--full` y confirmar 0 ERR

**Acción:**
```bash
bash verify.sh 2>&1 | grep -E "historica|OK:|Errores:|Advertencias:"
```

**Verificación:**
```
OK:   Tablas históricas presentes: 6
OK:           N   (N ≥ 25)
Advertencias: 0
Errores:      0
```

---

## FASE 6 — Documentación

---

### T-6.1 — Actualizar changelog de `schema_historico.sh`

**Acción:** Agregar entrada de versión nueva con los cambios de FASE 0, 1 y 2.

**Verificación:** `head -20 provisioners/mariadb/schema_historico.sh` muestra
versión nueva con changelog de funciones raíz y corrección de manejo de errores.

---

### T-6.2 — Actualizar changelog de `setup.sh`

**Acción:** Agregar nota de corrección de `SKIP_SEED` con referencia a H-EXEC-009.

**Verificación:** `head -5 setup.sh` muestra versión actualizada.

---

### T-6.3 — Actualizar changelog de `verify.sh`

**Acción:** Agregar nota de verificación de tablas históricas en sección 3b.

**Verificación:** `head -5 verify.sh` muestra versión actualizada.

---

### T-6.4 — Actualizar `HALLAZGOS-EJECUCION-2026-05-10.md` — estados a RESUELTO

**Acción:** Cambiar el estado de H-EXEC-005, H-EXEC-006, H-EXEC-007, H-EXEC-008
y H-EXEC-009 a `RESUELTO (2026-05-10)`. Agregar referencia al archivo que
implementa la corrección.

**Verificación:**
```bash
grep "Estado.*PENDIENTE" \
    docs/architecture/HALLAZGOS-EJECUCION-2026-05-10.md
# Esperado: 0 líneas
```

---

## Resumen ejecutivo

| Fase | Tareas | Archivos | Hallazgos que cierra | Prioridad |
|---|---|---|---|---|
| FASE 0 — Helpers raíz | T-0.1..T-0.4 | `schema_historico.sh` | H-EXEC-005 (prereq) | CRÍTICA |
| FASE 1 — DDL y seed | T-1.1..T-1.5 | `schema_historico.sh` | H-EXEC-005, H-EXEC-006 | CRÍTICA |
| FASE 2 — `column` | T-2.1 | `schema_historico.sh` | H-EXEC-007 | BAJA |
| FASE 3 — `SKIP_SEED` | T-3.1..T-3.4 | `setup.sh` | H-EXEC-009 | ALTA |
| FASE 4 — verify.sh | T-4.1..T-4.2 | `verify.sh` | H-EXEC-008 | ALTA |
| FASE 5 — Integración | T-5.1..T-5.5 | — | Todos | — |
| FASE 6 — Documentación | T-6.1..T-6.4 | Docs | Todos | — |

**Total: 23 tareas atómicas**

---

## Orden de ejecución obligatorio

```
FASE 0 → FASE 1 → FASE 3 → FASE 4 → FASE 2 → FASE 5 → FASE 6
```

FASE 0 antes que FASE 1: las funciones raíz deben existir antes de ser usadas.

FASE 1 antes que FASE 5 T-5.3: la prueba de seed crea tablas históricas — si el DDL
sigue usando `django_user`, las tablas no se crean y T-5.3 falla.

FASE 3 antes que FASE 5 T-5.3: si SKIP_SEED no está corregido, el seed siempre
se omite y T-5.3 no puede verificar que el seed corre.

FASE 4 antes que FASE 5 T-5.2 y T-5.5: las verificaciones de `verify.sh` de tablas
históricas deben estar implementadas para que T-5.2 y T-5.5 sean significativas.

FASE 2 después de FASE 1: el fix de `column` es independiente del DDL. Se puede
implementar en cualquier momento — se deja al final porque es de baja severidad
y no bloquea las pruebas de integración.
