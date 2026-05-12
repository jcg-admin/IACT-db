# Hallazgos — Ejecución FASE 2 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 2  
**Commit:** `93437ae`  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-2.1 | `backup_ivr_legacy.sh` L279 — proteger `SKIP_GRANT=$(root_exec \| awk)` (BUG-006) | COMPLETO | H-F2-001 |
| T-2.2 | `backup_ivr_legacy.sh` L309 — proteger `TABLES=$(root_exec)` (BUG-005) | COMPLETO | H-F2-002 |
| T-2.3 | Sintaxis y shellcheck limpios | PASA | — |

---

## H-F2-001 — Comportamiento de `pipefail` con pipes: el exit code más a la derecha que falla

**Detectado en:** T-2.1, durante el análisis del pipe `root_exec ... | awk`  
**Severidad:** INFORMATIVO — hallazgo de comportamiento de bash documentado  
**Estado:** DOCUMENTADO — influyó en la corrección de T-2.1

### Descripción

El análisis inicial de BUG-006 asumía que en:

```bash
SKIP_GRANT=$(root_exec ... | awk '/skip_grant_tables/{print $2}')
```

si `root_exec` falla, `awk` tiene exit 0 y por tanto el pipe podría
tener exit 0. Esto era incorrecto.

**Con `set -o pipefail`: si cualquier componente del pipe falla, el pipe
falla.** No importa si el último componente tiene exit 0.

```bash
# Verificación empírica:
bash -c 'set -o pipefail; (exit 1) | true; echo "exit: $?"'
# output: exit: 1   ← awk=true tuvo exit 0, pero el pipe falla por el componente izquierdo

bash -c 'set -o pipefail; true | (exit 1); echo "exit: $?"'
# output: exit: 1   ← también falla cuando es el componente derecho
```

### Implicación para BUG-006

Con `set -euo pipefail` activo en L44 del script:

1. `root_exec` falla (MariaDB no responde) → exit 1
2. `root_exec` redirige stderr de mysql a stdout via `2>&1` interno
3. El mensaje de error de mysql va al stdin de `awk`
4. `awk` no encuentra la línea `skip_grant_tables` → imprime nada → exit 0
5. El pipe tiene exit 1 (por pipefail, el componente izquierdo falló)
6. `set -e` termina el script en la asignación `SKIP_GRANT=$(...)` — silenciosamente

### Decisión de corrección

Se agregó `2>/dev/null` al `root_exec` para suprimir los mensajes de error
de mysql que pasaban por el pipe al `awk`, y `|| { ...; SKIP_GRANT=""; }`
para capturar el fallo del pipe:

```bash
SKIP_GRANT=$(root_exec -e "SHOW VARIABLES LIKE 'skip_grant_tables';" \
    2>/dev/null | awk '/skip_grant_tables/{print $2}') \
    || { log "WARN: ..."; SKIP_GRANT=""; }
```

**Estrategia conservadora:** cuando no se puede verificar `skip_grant_tables`,
se asume que NO está activo. No se registra el hallazgo BK-003 sin evidencia.
Un falso positivo en el reporte de hallazgos degrada la utilidad del sistema
de auditoría.

---

## H-F2-002 — `DUMP_SIZE` y `DUMP_BYTES` son seguros por invariante de ejecución

**Detectado en:** T-2.2, durante el análisis exhaustivo de todos los command substitutions  
**Severidad:** INFORMATIVO — candidatos descartados, no requieren corrección  
**Estado:** DOCUMENTADO

### Descripción

Al auditar todos los command substitutions del archivo para determinar si
BUG-005 era un patrón repetido, se identificaron dos candidatos adicionales:

```bash
# L367:
DUMP_SIZE=$(du -h "${DUMP_FILE}" | cut -f1)

# L387:
DUMP_BYTES=$(stat -c%s "${DUMP_FILE}")
```

Ambas líneas podrían fallar si `DUMP_FILE` no existe cuando se ejecutan.

### Análisis

El PASO 4 que genera el dump es:

```bash
mysqldump ... 2>"${STDERR_FILE}" | gzip -6 > "${DUMP_FILE}"
```

Este pipe tiene `set -euo pipefail` activo. Si `mysqldump` o `gzip` fallan,
`set -e` **termina el script antes de llegar a L367**. La invariante es:

> Si la ejecución llega a L367, el pipe de L353 tuvo exit 0,
> lo que garantiza que `DUMP_FILE` existe en el sistema de archivos.

`DUMP_SIZE` y `DUMP_BYTES` **no necesitan protección adicional**.
El estado de error ya está gestionado por `set -e` en el pipe del PASO 4.

### Lista completa de command substitutions auditados

| Línea | Expresión | Protección necesaria | Razón |
|---|---|---|---|
| L77 | `TIMESTAMP=$(date ...)` | No | `date` no falla en entorno normal |
| L207 | `MARIADB_INICIO=$(date +%s)` | No | ídem |
| L279 | `SKIP_GRANT=$(root_exec \| awk)` | **Sí** — BUG-006, CORREGIDO | root_exec puede fallar |
| L309 | `TABLES=$(root_exec ...)` | **Sí** — BUG-005, CORREGIDO | root_exec puede fallar |
| L347 | `T_DUMP_INI=$(date +%s%N)` | No | `date` no falla en entorno normal |
| L365 | `T_DUMP_FIN=$(date +%s%N)` | No | ídem |
| L367 | `DUMP_SIZE=$(du -h DUMP_FILE)` | No | invariante: DUMP_FILE existe si llegamos aquí |
| L387 | `DUMP_BYTES=$(stat DUMP_FILE)` | No | ídem |

---

## Cambios implementados

### `provisioners/mariadb/backup_ivr_legacy.sh`

**T-2.1 L279-280 — proteger `SKIP_GRANT=$(root_exec ... | awk)` (BUG-006):**

```bash
# Antes:
SKIP_GRANT=$(root_exec -e "SHOW VARIABLES LIKE 'skip_grant_tables';" \
    | awk '/skip_grant_tables/{print $2}')

# Después:
SKIP_GRANT=$(root_exec -e "SHOW VARIABLES LIKE 'skip_grant_tables';" \
    2>/dev/null | awk '/skip_grant_tables/{print $2}') \
    || { log "WARN: no se pudo verificar skip_grant_tables — BD no respondio"; SKIP_GRANT=""; }
```

Cambios respecto al plan original:
- Se agregó `2>/dev/null` a `root_exec` (no estaba en la propuesta inicial).
  Razón: `root_exec` redirige `2>&1` internamente, enviando mensajes de error
  de mysql al pipe. Suprimirlos evita que `awk` procese texto de error.
- El fallback `|| SKIP_GRANT=""` del plan se amplió con `log` de warning
  para que el operador sepa que la verificación no ocurrió.

**T-2.2 L309-312 — proteger `TABLES=$(root_exec ...)` (BUG-005):**

```bash
# Antes:
TABLES=$(root_exec "${DB}" -N -e "
SELECT table_name FROM information_schema.tables
WHERE table_schema='${DB}' AND table_type='BASE TABLE'
ORDER BY table_name;" 2>/dev/null)

# Después:
TABLES=$(root_exec "${DB}" -N -e "
SELECT table_name FROM information_schema.tables
WHERE table_schema='${DB}' AND table_type='BASE TABLE'
ORDER BY table_name;" 2>/dev/null) \
    || {
        log "WARN: no se pudo obtener lista de tablas — BD no respondio al inventario"
        registrar_hallazgo "MEDIA" \
            "BD no respondio durante el inventario de tablas" \
            "root_exec fallo al consultar information_schema.tables.\
\nEl inventario de conteos (PASO 3) queda vacio.\
\nEl dump del PASO 4 puede proceder si la BD recupera conectividad."
        TABLES=""
    }
```

Con `TABLES=""`:
- El `while IFS= read -r tbl; done <<< "${TABLES}"` no itera
- `TOTAL_ROWS=0`, `CONTEOS` queda como array vacío
- El PASO 4 (dump real) es independiente del inventario y continúa
- El fallo queda registrado como hallazgo MEDIA en el `.md` de auditoría

---

## Estado de los bugs del plan tras FASE 2

| Bug | Descripción | Estado |
|---|---|---|
| BUG-005 | `TABLES=$(root_exec ...)` sin `\|\| true` en `backup_ivr_legacy.sh` L309 | RESUELTO — T-2.2 |
| BUG-006 | `SKIP_GRANT=$(root_exec ...)` sin `\|\| true` en `backup_ivr_legacy.sh` L279 | RESUELTO — T-2.1 |
