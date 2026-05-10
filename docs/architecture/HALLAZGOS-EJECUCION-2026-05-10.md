# Hallazgos de ejecución — IACT-db 2026-05-10

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Método:** Ejecución real en entorno Ubuntu 24.04 con PostgreSQL 16 y MariaDB 10.11.14  
**Cobertura:** `utils/database.sh`, `setup.sh`, `scripts/provision-mariadb.sh`,
`provisioners/mariadb/schema_historico.sh`, `verify.sh`

---

## Resumen ejecutivo

| ID | Componente | Severidad | Estado |
|---|---|---|---|
| H-EXEC-001 | `_pg_kill_stale` / `_mariadb_kill_stale` sin guarda interna | CRÍTICA | RESUELTO |
| H-EXEC-002 | `_pg_start_ctlcluster` restart sin re-verificar `pg_is_running` | ALTA | RESUELTO |
| H-EXEC-003 | `local` en cuerpo principal de `provision-mariadb.sh` | ALTA | RESUELTO |
| H-EXEC-004 | `mariadb_cleanup_stale` funciona correctamente | — | POSITIVO |
| H-EXEC-005 | `schema_historico.sh` usa `django_user` para CREATE TABLE | CRÍTICA | PENDIENTE |
| H-EXEC-006 | `schema_historico.sh` swallows errores DDL y reporta SUCCESS | CRÍTICA | PENDIENTE |
| H-EXEC-007 | `column` no disponible en `schema_historico.sh` línea 342 | BAJA | PENDIENTE |
| H-EXEC-008 | `verify.sh 3b` no verifica tablas históricas `tbl_historico_*` | ALTA | PENDIENTE |
| H-EXEC-009 | `${SKIP_SEED:+--skip-seed}` pasa `--skip-seed` cuando `SKIP_SEED=0` | ALTA | PENDIENTE |

---

## Hallazgos resueltos en sesión

### H-EXEC-001 — `_pg_kill_stale` / `_mariadb_kill_stale` sin guarda interna

**Componente:** `utils/database.sh`  
**Severidad:** CRÍTICA  
**Estado:** RESUELTO (2026-05-10)

**Descripción:**
Ambas funciones recibían un PID del PID file, verificaban que el proceso existía
(`kill -0 $pid`), y procedían a matar el proceso con SIGTERM → SIGKILL. No
verificaban si el servicio aceptaba conexiones antes de matar.

**Evidencia empírica:**
Llamar `_pg_kill_stale 16` directamente con PostgreSQL activo lo mató
silenciosamente. El PID (3296) estaba vivo y aceptando conexiones. La función
emitió:
```
WARN: proceso 3296 existe pero no acepta conexiones — enviando SIGTERM
SUCCESS: proceso 3296 terminado (2s)
```
Sin haber verificado que realmente no aceptaba conexiones.

**Causa raíz:**
El diseño original asumía que la función solo sería llamada desde `db_start_postgres`
/ `db_start_mariadb` después de que `_try_levels()` fallara (lo que implica que el
servicio no responde). Esta premisa no se reforzó dentro de la función misma.

**Impacto:**
- Llamada directa por un operador o en un script externo → mata el servicio sin importar si está sano
- Race condition: entre `_try_levels()` fallando y `_kill_stale()` ejecutándose,
  el servicio podría haber arrancado → se mataría un servicio que acababa de recuperarse
- Viola el principio de defensa en profundidad: el caller no debería ser el único
  control de seguridad para una operación destructiva

**Corrección aplicada:**
Agregar verificación `if pg_is_running / mariadb_is_running` como primera guarda
antes de SIGTERM. Si el servicio responde, rechazar el kill y emitir `log_warn`
con el comando correcto para detenerlo manualmente.

---

### H-EXEC-002 — `_pg_start_ctlcluster` restart sin re-verificar `pg_is_running`

**Componente:** `utils/database.sh`  
**Severidad:** ALTA  
**Estado:** RESUELTO (2026-05-10)

**Descripción:**
En el `case "$cluster_status"` de `_pg_start_ctlcluster`, el caso `online)`
ejecutaba `pg_ctlcluster restart` asumiendo que el cluster estaba en estado
inconsistente (online pero sin aceptar conexiones). No re-verificaba
`pg_is_running` antes de reiniciar.

**Evidencia empírica:**
Llamar `_pg_start_ctlcluster 16` directamente con PostgreSQL activo causó un
restart innecesario. El log emitió:
```
WARN: cluster 16 reporta 'online' pero no acepta conexiones
WARN: intentando pg_ctlcluster restart
SUCCESS: restart completado
```
PostgreSQL interrumpió conexiones activas innecesariamente.

**Causa raíz:**
El comentario original decía: "El cluster ya está online pero `pg_is_running` dijo
que no acepta conexiones". La condición era válida en el flujo de `db_start_postgres`
(donde `pg_is_running` ya retornó false), pero no para llamada directa.

**Impacto:**
- Restart innecesario que interrumpe conexiones activas en PostgreSQL
- En un entorno de producción con `migrate` en progreso, causaría pérdida de trabajo

**Corrección aplicada:**
Re-verificar `pg_is_running` dentro del caso `online)`. Si el servicio responde:
retornar 0 sin restart. Si no responde: proceder con restart (estado inconsistente real).

---

### H-EXEC-003 — `local` en cuerpo principal de `provision-mariadb.sh`

**Componente:** `scripts/provision-mariadb.sh`  
**Severidad:** ALTA  
**Estado:** RESUELTO (2026-05-10)

**Descripción:**
La variable `grant` fue declarada con `local` dentro de un `for` loop en el cuerpo
principal del script (fuera de cualquier función). `local` solo es válido dentro
de funciones — con `set -euo pipefail` activo, Bash termina el script en esa línea.

**Evidencia empírica:**
```
/tmp/references/IACT-db/scripts/provision-mariadb.sh: line 194:
  local: can only be used in a function
ERROR: provision-mariadb.sh fallo
```
El script abortó en el PASO 4 antes de otorgar los grants analíticos a `django_user`.

**Causa raíz:**
El código fue escrito con el patrón de función, pero el bloque de grants quedó en
el cuerpo principal del script como parte del loop `for sql in ... ; do`.

**Corrección aplicada:**
Renombrar `local grant=` a `GRANT_STMT=` (variable de shell sin scope de función).

---

## Hallazgos pendientes — requieren plan de corrección

### H-EXEC-005 — `schema_historico.sh` usa `django_user` para CREATE TABLE

**Componente:** `provisioners/mariadb/schema_historico.sh`  
**Severidad:** CRÍTICA  
**Estado:** PENDIENTE

**Descripción:**
`schema_historico.sh` conecta a MariaDB usando `DB_MARIADB_USER` (valor: `django_user`)
para ejecutar el archivo `schema_historico.sql` que contiene `CREATE TABLE IF NOT EXISTS`.

```bash
# schema_historico.sh línea 62-63
DB_USER="${DB_MARIADB_USER:-django_user}"
DB_PASS="${DB_MARIADB_PASSWORD:-django_pass}"

# línea 103-107 (my_exec_file)
my_exec_file() {
    mysql --batch -h "${DB_HOST}" -P "${DB_PORT}" \
          -u "${DB_USER}" -p"${DB_PASS}" \
          "${DB_NAME}" < "$1" 2>&1
}
```

**Evidencia empírica:**
El provisioner emitió el error a stdout pero lo swalló con `|| true`:
```
ERROR 1142 (42000) at line 29: CREATE command denied to user
  'django_user'@'localhost' for table `ivr_legacy`.`tbl_historico_t1_2025`
[SUCCESS] Schema aplicado
```

Las seis tablas históricas (`tbl_historico_t1_2025` .. `tbl_historico_t2_2026`)
no fueron creadas. `verify.sh 3b` no las verifica → el error pasa desapercibido.

**Causa raíz:**
Contradicción de diseño:
- CNST-003 establece que `django_user` es READ-ONLY en `ivr_legacy`
- `schema_historico.sh` asume que `DB_MARIADB_USER` tiene privilegios DDL
- Las dos decisiones son incompatibles

`provision-mariadb.sh` resolvió correctamente este problema en sus propios helpers
(`sql_exec_file`, `sql_exec_query`) usando root via socket. `schema_historico.sh`
no fue actualizado con el mismo patrón.

**Impacto:**
- Las tablas `tbl_historico_t*` no existen en la BD
- Todos los endpoints IVR que leen datos históricos fallan con:
  `ERROR 1146: Table 'ivr_legacy.tbl_historico_t1_2025' doesn't exist`
- El pipeline ETL no puede leer la fuente histórica
- `verify.sh` reporta 0 errores aunque el entorno esté incompleto (H-EXEC-008)
- El bug es silencioso: el provisioner dice SUCCESS y continúa

**Corrección requerida:**
`schema_historico.sh` debe conectar como root via socket (igual que `sql_exec_file`
en `provision-mariadb.sh`), no como `django_user`. Patrón correcto:

```bash
# En lugar de DB_USER / DB_PASS, usar root via socket o TCP con root
_mdb_exec_file_root() {
    local sql_file="$1"
    if [[ -S "/run/mysqld/mysqld.sock" ]]; then
        mysql --socket=/run/mysqld/mysqld.sock "${DB_NAME}" < "$sql_file" 2>&1
    else
        mysql -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_MARIADB_ROOT_PASSWORD}" \
              "${DB_NAME}" < "$sql_file" 2>&1
    fi
}
```

---

### H-EXEC-006 — `schema_historico.sh` swallows errores DDL y reporta SUCCESS

**Componente:** `provisioners/mariadb/schema_historico.sh`  
**Severidad:** CRÍTICA  
**Estado:** PENDIENTE

**Descripción:**
El código de creación de tablas es:

```bash
# línea 265-267
my_exec_file "$SCHEMA_SQL" | grep -v "^$" | while IFS= read -r line; do
    log_info "  ${line}"
done || true          # ← swallows all errors

log_success "Schema aplicado"   # ← siempre se emite
```

La construcción `| while ...; done || true` captura la salida del comando para
mostrarla en log, pero el `|| true` final descarta el exit code de `my_exec_file`.
Incluso si `my_exec_file` retorna exit 1 (error de MySQL), el pipeline completo
retorna 0 (true), por lo que `log_success` siempre se emite.

**Causa raíz:**
El patrón `cmd | while read ...; done || true` es habitual para display de salida
con supresión de "broken pipe", pero en este contexto suprime también los errores
reales de MySQL. Un error de permiso (1142), de sintaxis (1064) o de conexión (2002)
son todos ignorados.

**Impacto compuesto con H-EXEC-005:**
- H-EXEC-005 genera ERROR 1142 → `my_exec_file` retorna exit 1
- H-EXEC-006 swallows ese exit 1 → el script continúa sin señalar el problema
- La combinación hace que el fallo sea completamente invisible para el operador

**Corrección requerida:**
Separar captura de salida del manejo de errores. El error de MySQL debe capturarse
y verificarse, no descartarse:

```bash
# Ejecutar y capturar exit code por separado
if ! my_exec_file "$SCHEMA_SQL" > /tmp/schema_output.txt 2>&1; then
    log_error "schema_historico.sql falló — salida:"
    cat /tmp/schema_output.txt | while IFS= read -r line; do
        log_error "  ${line}"
    done
    return 1
fi
cat /tmp/schema_output.txt | grep -v "^$" | while IFS= read -r line; do
    log_info "  ${line}"
done
log_success "Schema aplicado"
```

---

### H-EXEC-007 — `column` no disponible en `schema_historico.sh`

**Componente:** `provisioners/mariadb/schema_historico.sh`  
**Severidad:** BAJA  
**Estado:** PENDIENTE

**Descripción:**
La línea 342 de `schema_historico.sh` usa el comando `column` para formatear la
salida tabular de `seed_executions`:

```bash
LIMIT 10;" 2>/dev/null | column -t \
    || log_warn "seed_executions no disponible aun"
```

El comando `column` no está disponible en todos los entornos (no instalado por
defecto en algunas imágenes de Ubuntu minimal).

**Evidencia empírica:**
```
/tmp/references/IACT-db/provisioners/mariadb/schema_historico.sh:
  line 342: column: command not found
WARN: seed_executions no disponible aun
```

**Impacto:**
- El `WARN` es engañoso: `seed_executions` puede existir correctamente, pero
  el error se reporta como si no existiera porque el pipeline falla en `column -t`
- La tabla `seed_executions` puede estar presente y el historial de ejecuciones
  disponible, pero no se muestra

**Corrección requerida:**
Verificar disponibilidad de `column` antes de usarlo, o usar `cat` como fallback:

```bash
if command -v column &>/dev/null; then
    mysql_query ... | column -t
else
    mysql_query ...
fi
```

---

### H-EXEC-008 — `verify.sh 3b` no verifica tablas históricas

**Componente:** `verify.sh`, sección `check_mariadb_schema()`  
**Severidad:** ALTA  
**Estado:** PENDIENTE

**Descripción:**
La sección `3b/8 MariaDB — schema ivr_legacy` de `verify.sh` verifica:
- Tablas analíticas (`base_ivr_*`, `job_*`, `etl_runs`) ✓
- Funciones de utilidad ✓
- SPs ETL y reporte ✓

No verifica:
- Tablas históricas `tbl_historico_t1_2025` .. `tbl_historico_t2_2026`

**Impacto compuesto con H-EXEC-005 y H-EXEC-006:**
El fallo silencioso de `schema_historico.sh` (H-EXEC-005 + H-EXEC-006) deja las
tablas históricas sin crear. Como `verify.sh 3b` no las verifica, el entorno pasa
la verificación con 25 OK, 0 WARN, 0 ERR aunque las tablas históricas no existan.

**Corrección requerida:**
Agregar verificación de las 6 tablas históricas en `check_mariadb_schema()`:

```bash
# Tablas históricas dinámicas — verificar por patrón
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

Usar `fail` (no `warn`) porque estas tablas son el origen de datos del pipeline ETL.

---

### H-EXEC-009 — `${SKIP_SEED:+--skip-seed}` activa `--skip-seed` cuando `SKIP_SEED=0`

**Componente:** `setup.sh` (raíz IACT-db)  
**Severidad:** ALTA  
**Estado:** PENDIENTE — decisión de diseño: eliminar el patrón completamente

**Descripción:**
En `setup.sh` líneas 63 y 127:

```bash
export SKIP_SEED="${SKIP_SEED:-0}"                                  # línea 63
bash "...provision-mariadb.sh" ${SKIP_SEED:+--skip-seed}            # línea 127
```

La expansión `${var:+word}` evalúa a `word` si la variable está definida
**y no está vacía**. La cadena `"0"` es no vacía — por lo tanto:

```bash
SKIP_SEED=0
echo "${SKIP_SEED:+--skip-seed}"
# Output: --skip-seed    ← BUG: se pasa --skip-seed aunque SKIP_SEED=0
```

**Evidencia empírica (confirmada con Bash 5.2):**
```bash
$ bash -c 'SKIP_SEED=0; echo "Expansion: |${SKIP_SEED:+--skip-seed}|"'
Expansion: |--skip-seed|    ← confirma el bug
```

En el test de `setup.sh mariadb --full` sin pasar `SKIP_SEED=1`:
```
SKIP_SEED:    1             ← provision-mariadb.sh recibió --skip-seed
SKIP_SEED=1 — seed omitido  ← schema_historico.sh omitió seed
```

El seed histórico fue omitido aunque el operador no lo solicitó.

**Causa raíz: incompatibilidad de semánticas**

El operador `${var:+word}` tiene una semántica de presencia/ausencia:
- Está diseñado para casos donde la variable ausente o vacía significa "desactivado"
- Funciona correctamente cuando el "estado por defecto" es la variable sin definir o vacía

```bash
# Uso correcto — DEBUG ausente o vacío significa "no verbose"
DEBUG=""
${DEBUG:+--verbose}   # → vacío (correcto)

DEBUG=1
${DEBUG:+--verbose}   # → --verbose (correcto)
```

Nuestro caso usa la convención booleana numérica de shell (`0 = false`, `1 = true`):
- `SKIP_SEED=0` debería significar "no saltar"
- `SKIP_SEED=1` debería significar "saltar"

Las dos semánticas son incompatibles. `${var:+word}` no distingue entre `"0"` y `"1"` —
solo distingue entre vacío y no vacío.

**Decisión de diseño: eliminar el patrón**

La corrección no es solo cambiar el default de `"0"` a `""`. El patrón
`${var:+word}` introduce fragilidad porque su comportamiento depende de si la
variable está vacía, no de su valor semántico. Cualquier valor no vacío — `"0"`,
`"false"`, `"no"` — activa el flag.

La alternativa es una comparación explícita que hace la intención inequívoca:

```bash
# ELIMINAR:
export SKIP_SEED="${SKIP_SEED:-0}"
bash "...provision-mariadb.sh" ${SKIP_SEED:+--skip-seed}

# REEMPLAZAR CON:
export SKIP_SEED="${SKIP_SEED:-}"       # vacío = no saltar

if [[ "${SKIP_SEED}" == "1" ]]; then
    bash "${PROJECT_ROOT}/scripts/provision-mariadb.sh" --skip-seed
else
    bash "${PROJECT_ROOT}/scripts/provision-mariadb.sh"
fi
```

Ventajas del `if` explícito:
- Exactamente un valor activa el flag: `"1"`
- `SKIP_SEED=0`, `SKIP_SEED=""`, `SKIP_SEED=false`, variable no definida → todos
  significan "no saltar" sin ambigüedad
- La intención es legible sin conocer la semántica de `${:+}`
- Fácil de extender: si en el futuro se agrega otro flag, el patrón escala limpiamente

**Impacto:**
- `sudo bash setup.sh mariadb --full` **siempre** omite el seed histórico en el estado actual
- El único modo de obtener el seed es `SKIP_SEED= sudo bash setup.sh mariadb --full`
  (valor vacío explícito), lo cual es contraintuitivo y no está documentado
- En entornos de staging recién aprovisionados, los datos históricos no se cargan
  y el fallo es silencioso (combinado con H-EXEC-005/006)

---

## Hallazgo positivo

### H-EXEC-004 — `mariadb_cleanup_stale` funciona correctamente con archivos reales

**Componente:** `utils/database.sh`  
**Severidad:** —  
**Estado:** POSITIVO — sin acción requerida

**Descripción:**
El proceso MariaDB murió (PID 4307) dejando un PID file stale y un socket huérfano
en `/run/mysqld/`. `mariadb_cleanup_stale` detectó y eliminó ambos archivos
correctamente:

```
DEBUG: PID 4307 en /run/mysqld/mysqld.pid no existe — eliminando
WARN:  socket huérfano /run/mysqld/mysqld.sock — eliminando
SUCCESS: 1 socket(s) stale eliminado(s)
```

La distinción entre proceso vivo (`kill -0` retorna 0) y proceso muerto
(`kill -0` retorna 1) funcionó correctamente. El socket fue verificado con
`mysqladmin ping` antes de clasificarlo como huérfano.

---

## Análisis de interdependencias

Los hallazgos H-EXEC-005, H-EXEC-006 y H-EXEC-008 forman una cadena de fallos
silenciosos:

```
H-EXEC-005: schema_historico.sh usa django_user (sin privilegios DDL)
    ↓
    CREATE TABLE falla con ERROR 1142
    ↓
H-EXEC-006: || true swallows el error → log_success "Schema aplicado"
    ↓
    Las tablas tbl_historico_* no existen, pero el operador no lo sabe
    ↓
H-EXEC-008: verify.sh 3b no verifica tbl_historico_*
    ↓
    verify.sh reporta 25 OK, 0 WARN, 0 ERR
    ↓
    ENTORNO ROTO PASA VERIFICACIÓN
```

H-EXEC-009 agrava la situación: incluso si H-EXEC-005/006 se corrigen, el seed
histórico seguirá siendo omitido silenciosamente porque SKIP_SEED=0 activa
`--skip-seed`.

Estos cuatro hallazgos deben ser corregidos en conjunto — corregir solo uno de
ellos no resuelve el problema de fondo.

---

## Orden de prioridad de corrección

1. **H-EXEC-009** — Corregir primero: afecta la condición de entrada del provisioner.
   Sin esta corrección, los tests de H-EXEC-005/006 son ambiguos (el seed siempre se omite).

2. **H-EXEC-005 + H-EXEC-006** — Corregir juntos: la causa (usuario incorrecto) y
   el enmascaramiento (swallow de error) son interdependientes.

3. **H-EXEC-008** — Corregir después de H-EXEC-005/006: el nuevo check de
   tablas históricas en verify.sh debe ejecutarse en un entorno donde esas
   tablas sí se puedan crear.

4. **H-EXEC-007** — Corregir último: impacto menor, solo afecta display.

---

## Ver también

- `PLAN-CORRECCIONES-2026-05-10.md` — plan de correcciones anterior (FASE 0..5 completadas)
- `ANALISIS-MARIADB-PROVISIONAMIENTO-2026-05-10.md` — análisis original H-MDB-010..015
