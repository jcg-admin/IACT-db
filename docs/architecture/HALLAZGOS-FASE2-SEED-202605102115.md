# Hallazgos — Ejecución FASE 2 (Integración de poblar_historico.py)

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Implementación de FASE 2 del
`PLAN-SEED-HISTORICO-V2-202605102100.md`  
**Archivo modificado:** `provisioners/mariadb/schema_historico.sh` → v2.3.0

---

## Resultado de las tareas del plan

| Tarea | Descripción | Estado | Observaciones |
|---|---|---|---|
| T-2.1 | Eliminar `FORCE_RESEED` de todo el script | COMPLETO | 6 ubicaciones eliminadas |
| T-2.2 | Agregar variable `FULL_SEED` y documentación | COMPLETO | |
| T-2.3 | Agregar PASO 4 con `poblar_historico.py` | COMPLETO + H-F2-001 | Bug de exit code detectado y corregido |
| T-2.4 | Actualizar `log_step` a 4 pasos totales | COMPLETO | |

---

## Resultados confirmados

### Comportamiento sin `FULL_SEED` (default)

```
STEP 1/4  Verificar acceso a MariaDB           → SUCCESS
STEP 2/4  Crear tablas                          → SUCCESS
STEP 3/4  Seed de datos (Nivel 1 — SQL)        → APPEND
STEP 4/4  Seed de alta fidelidad (Nivel 2)     → INFO: FULL_SEED no activo
EXIT: 0
```

### Comportamiento con `SKIP_SEED=1 FULL_SEED=1`

```
STEP 4/4  Seed de alta fidelidad (Nivel 2)     → INFO: SKIP_SEED=1 — omitido
EXIT: 0
```

`SKIP_SEED=1` es una bandera global que omite ambos niveles. Correcto.

### Comportamiento con `FULL_SEED=1 SKIP_SEED=0`

```
STEP 3/4  Seed de datos (Nivel 1 — SQL)        → APPEND (sin truncar)
STEP 4/4  Seed de alta fidelidad (Nivel 2)     → poblar_historico.py (truncate=False)
EXIT: 0
```

Conteos antes y después de la ejecución con `FULL_SEED=1`:

| Tabla | Antes | Nivel 1 (+SQL) | Nivel 2 (+Python) |
|---|---|---|---|
| tbl_historico_t1_2025 | 9,033 | 12,036 | 15,036 |
| tbl_historico_t2_2025 | 10,261 | 13,674 | 17,181 |
| tbl_historico_t3_2025 | 8,628 | 11,498 | 14,456 |
| tbl_historico_t4_2025 | 9,415 | 12,544 | 15,751 |
| tbl_historico_t1_2026 | 9,140 | 12,181 | 15,298 |
| tbl_historico_t2_2026 | 4,062 | 5,418 | 6,876 |

**Ningún dato fue borrado.** Todos los conteos crecen en cada paso.
`truncate=False` confirmado en el output de `poblar_historico.py`.

### verify.sh final

```
26 OK, 0 WARN, 0 ERR, EXIT 0
script_version='2.3.0' en seed_executions (v2.3.0 de schema_historico.sh)
```

---

## Hallazgos identificados

| ID | Hallazgo | Tipo | Severidad | Estado |
|---|---|---|---|---|
| H-F2-001 | Patrón `cmd \| while; done \|\| var=$?` no captura exit code con `set -euo pipefail` | Bug en T-2.3 | ALTA | RESUELTO en sesión |
| H-F2-002 | `FORCE_RESEED` aparecía en 6 ubicaciones en el script (código, inyección SQL, log, mensajes) | Deuda H-F1-004 | MEDIA | RESUELTO T-2.1 |
| H-F2-003 | `SEED_ROWS` en PASO 4 usa el valor de `schema_historico.sh`, no el `n_objetivo` escalado de `poblar_historico.py` | Comportamiento documentado | BAJA | DOCUMENTADO |

---

## H-F2-001 — Patrón de captura de exit code incorrecto con `set -euo pipefail`

**Tipo:** Bug detectado durante T-2.3 — análisis previo a la implementación  
**Severidad:** ALTA  
**Estado:** RESUELTO antes del primer test

### Descripción

El plan original de T-2.3 proponía:

```bash
local py_exit=0
python3 poblar_historico.py ... 2>&1 \
    | while IFS= read -r line; do log_info "  ${line}"; done \
    || py_exit=$?
```

En bash con `set -euo pipefail`, este patrón tiene dos problemas:

1. **`set -e`**: si `python3` falla antes de que el `while` lea cualquier output,
   el script aborta antes de llegar al `|| py_exit=$?`.

2. **`pipefail` + `||`**: el `||` captura el exit code del ÚLTIMO comando del
   pipeline (`while`), no del primero (`python3`). Si `python3` falla pero `while`
   termina con 0, `py_exit` quedaría en 0 — falso positivo.

### Corrección aplicada

Capturar el output completo en una variable y loguear después:

```bash
local py_out py_exit=0
py_out=$(python3 poblar_historico.py ... 2>&1) || py_exit=$?

while IFS= read -r line; do
    [[ -n "${line}" ]] && log_info "  ${line}"
done <<< "${py_out}"
```

La sustitución de comando `$(...)` captura `python3` en un subshell. Con
`set -e`, el `|| py_exit=$?` actúa como guarda: si `python3` falla, el `||`
captura el exit code real antes de que `set -e` aborte el script padre.

### Trade-off aceptado

El output de `poblar_historico.py` no se muestra en tiempo real — aparece
completo al terminar. Para un proceso que dura ~30 segundos con `SEED_ROWS=3000`,
esto es aceptable. Si se requiriera streaming en tiempo real, la alternativa
sería un archivo temporal y `tail -f`.

---

## H-F2-002 — `FORCE_RESEED` en 6 ubicaciones — deuda H-F1-004 cerrada

**Tipo:** Deuda técnica H-F1-004 del plan anterior — ahora RESUELTO  
**Severidad:** MEDIA  
**Estado:** RESUELTO en T-2.1

### Descripción

`FORCE_RESEED` fue eliminado de `seed_historico.sql` v3.0.0 (el SP ya no
tiene `p_force`) pero `schema_historico.sh` v2.2.0 seguía inyectándolo y
mostrándolo. Las 6 ubicaciones eliminadas en T-2.1:

| # | Ubicación | Tipo |
|---|---|---|
| 1 | Header línea 17: `#   · Con FORCE_RESEED=1 → TRUNCATE` | Comentario de comportamiento |
| 2 | Header línea 40: `FORCE_RESEED=1 sudo bash ...` | Ejemplo de uso |
| 3 | Configuración: `FORCE_RESEED="${FORCE_RESEED:-0}"` | Variable de entorno |
| 4 | `my_exec_vars()`: `echo "SET @FORCE_RESEED = ${FORCE_RESEED};"` | Inyección SQL |
| 5 | `my_exec_vars_root()`: misma inyección SQL | Inyección SQL |
| 6 | `main()` log: `log_info "  FORCE_RESEED: ${FORCE_RESEED}"` | Log de configuración |

Adicionalmente, el mensaje de error en `verificar_seed_completo()` decía
`FORCE_RESEED=1 sudo bash ...` — actualizado a `sudo bash ...` (sin variable
obsoleta).

---

## H-F2-003 — `SEED_ROWS` en PASO 4 es el valor base, no el escalado

**Tipo:** Comportamiento documentado  
**Severidad:** BAJA  
**Estado:** DOCUMENTADO

### Descripción

`schema_historico.sh` PASO 4 pasa `--rows "${SEED_ROWS}"` a
`poblar_historico.py`. Este es el valor BASE de Q01_25 (e.g., 3000).

`poblar_historico.py` aplica internamente sus propias escalas por quarter:
- Q01_25: `round(3000 * 1.000)` = 3000
- Q02_25: `round(3000 * 1.136)` = 3408 (pico)
- Q03_25: `round(3000 * 0.954)` = 2862 (valle)
- etc.

El valor `SEED_ROWS=3000` que se muestra en el log del PASO 4 es el `rows_base`,
no el número que se insertará en cada tabla. Esto es correcto y consistente con
cómo `poblar_historico.py` espera el argumento `--rows` (base de Q01_25 sin escala).

No requiere corrección. El log de `poblar_historico.py` muestra `OK — total: N`
con el conteo real post-inserción por tabla, que es la métrica correcta.

---

## Inventario de eliminaciones de `FORCE_RESEED` (T-2.1)

Se confirma que el script v2.3.0 no contiene ninguna referencia ejecutable
a `FORCE_RESEED`:

```bash
grep -n "FORCE_RESEED" schema_historico.sh | grep -v "^[0-9]*:#"
# Resultado: (vacío) — 0 referencias ejecutables
```

---

## Estado del entorno al cierre de FASE 2

```
schema_historico.sh       v2.3.0   26 OK, 0 WARN, 0 ERR
tbl_historico_t1_2025     15,036   Nivel 1 (SQL) + Nivel 2 (Python)
tbl_historico_t2_2025     17,181   pico — mayor que los demás
tbl_historico_t3_2025     14,456   valle — menor que los adyacentes
tbl_historico_t4_2025     15,751
tbl_historico_t1_2026     15,298
tbl_historico_t2_2026      6,876   parcial (36/91 días Q2 2026)

FULL_SEED: funcional — python3 3.12.3 disponible
poblar_historico.py: invocado en APPEND (truncate=False)
verify.sh: 26 OK, 0 WARN, 0 ERR, EXIT 0
```

FASE 2 completada sin deuda técnica. H-F2-001 fue detectado durante el
análisis del código antes del primer test y corregido antes de ejecutar.
H-F1-004 (deuda anterior) fue cerrado en T-2.1.
