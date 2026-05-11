# Hallazgos — Ejecución FASE 4 (Pipeline ETL + verify.sh)

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Plan de referencia:** `PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` FASE 4  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo |
|---|---|---|---|
| T-4.1 | `provision-mariadb.sh`: agregar `_run_etl_backfill()` + PASO 7 opcional | COMPLETO | H-F4-001 |
| T-4.2 | `verify.sh`: agregar `ivr_contar_dias_semana` e `ivr_agregar_dias_semana` | COMPLETO | — |
| T-4.3 | `verify.sh`: reordenar sección 3b — históricas al final | COMPLETO | — |
| T-4.4 | `utils/logging.sh`: corregir `log_fatal` — agregar `exit 1` | COMPLETO | H-F4-003 |
| T-4.5 | `verify.sh` → 27 OK sin regresión | PASA | H-F4-002 |

---

## H-F4-001 — `provision-mariadb.sh` tenía el mismo loop de 5 funciones que verify.sh

**Detectado en:** Pre-análisis de T-4.1  
**Severidad:** MEDIA  
**Estado:** RESUELTO — T-4.1

La verificación nominal al final de `main()` en `provision-mariadb.sh`
tenía exactamente el mismo loop de 5 funciones que `verify.sh` antes de T-4.2:

```bash
# provision-mariadb.sh antes:
for fn in fn_did_segmento fn_normalizar_menu fn_normalizar_centro \
          fn_duracion_seg ivr_es_dia_semana; do
```

`ivr_contar_dias_semana` e `ivr_agregar_dias_semana` no se verificaban como
parte del provisionamiento completo. Un operador que corriera `provision-mariadb.sh`
podría recibir "Provisionamiento completado" sin que estas funciones hubieran
sido verificadas.

**Resolución:** Loop actualizado a 7 funciones en `provision-mariadb.sh`,
marcado como `H-F4-001` para diferenciar del `H-ETL-002` de `verify.sh`.

---

## H-F4-002 — El baseline no sube de 27 a 28 — el plan proyectó incorrectamente

**Detectado en:** T-4.5 (verificación final)  
**Severidad:** BAJA (informativo)  
**Estado:** DOCUMENTADO — no requiere acción

El plan (`PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md`) decía:

> Nota: El baseline sube de 27 a 28 OK

La proyección era incorrecta. La función `ok()` en `verify.sh` se llama UNA
vez por bloque de verificación, independientemente de cuántos elementos
comprueba ese bloque:

```bash
# Antes: ok "Funciones de utilidad completas (5/5)"  → 1 ok-call
# Ahora: ok "Funciones de utilidad completas (7/7)"  → 1 ok-call
```

Agregar funciones al loop de un check existente amplía la cobertura del check,
pero no agrega un nuevo `ok-call`. El baseline permanece en 27 OK porque:

- T-4.2 amplió el loop de un check existente (sin nuevo bloque)
- T-4.3 reordenó bloques existentes (sin agregar ni quitar bloques)
- T-4.4 corrigió `log_fatal` (sin impacto en conteo de OK)
- T-4.1 agregó `_run_etl_backfill` que no genera checks en `verify.sh`

El baseline de 27 OK es el resultado correcto. El plan deberá corregir
esta proyección en la documentación de cierre (FASE 7).

---

## H-F4-003 — `log_fatal` tenía un bug más grave que el descrito en el plan

**Detectado en:** Pre-análisis de T-4.4  
**Severidad:** ALTA  
**Estado:** RESUELTO — T-4.4

El plan (`H-ETL-003`) describía el problema como:

> `log_fatal` solo imprime, NO hace `exit 1`. Con `set -euo pipefail`,
> el código CONTINÚA después del bloque `if/then` que llama `log_fatal`.

La descripción era parcialmente incorrecta. El enunciado "solo imprime" era
correcto. El enunciado "Con `set -euo pipefail`, el código CONTINÚA" también
era correcto, pero por una razón diferente: el problema no era que `exit 1`
matara solo el subshell — el problema era que no había ningún `exit 1`.

El plan también proponía como solución:

> `kill -TERM 0 2>/dev/null || exit 1`

Esta solución fue descartada porque `kill -TERM 0` envía SIGTERM a todo el
grupo de procesos, incluyendo procesos de sistema en entornos de provisioning.
Es demasiado agresivo para un entorno donde otros servicios pueden estar
corriendo en el mismo proceso group.

**Análisis del contexto de uso real:**

```
grep de log_fatal en subshell $(): → vacío (NUNCA se usa en subshell)
Patrón universal de uso:
    if ! condición; then
        log_fatal "mensaje"
    fi
```

`log_fatal` SIEMPRE se llama en top-level de función, no dentro de `$()`.
Por lo tanto `exit 1` es la solución correcta y segura:

- En script ejecutado directamente: termina el proceso
- En script sourced desde bootstrap: termina el bootstrap (comportamiento correcto)
- Sin impacto en grupos de procesos del sistema

**Resolución:** `exit 1` simple, con documentación del razonamiento completo.

**Test de regresión:**
```bash
bash -c '
    source utils/logging.sh
    source utils/core.sh
    log_fatal "test"
    echo "NUNCA debería llegar aquí"
'
# → imprime el mensaje FATAL y EXIT=1. La línea posterior no se ejecuta.
```

---

## Cambios implementados — resumen

### `utils/logging.sh`

```bash
# Antes (solo log):
log_fatal() {
    log_message "$LOG_LEVEL_FATAL" "FATAL  " "$COLOR_FATAL" "$1"
}

# Después (log + exit):
log_fatal() {
    log_message "$LOG_LEVEL_FATAL" "FATAL  " "$COLOR_FATAL" "$1"
    exit 1
}
```

### `verify.sh`

Cambio 1 (T-4.2 — H-ETL-002): loop de funciones 5→7:
```bash
for fn in fn_did_segmento fn_normalizar_menu fn_normalizar_centro \
          fn_duracion_seg ivr_es_dia_semana \
          ivr_contar_dias_semana ivr_agregar_dias_semana; do
```
Mensaje actualizado: `"Funciones de utilidad completas (${fn_ok}/7)"`

Cambio 2 (T-4.3 — H-VFY-001): orden de bloques en `check_mariadb_schema()`:
```
Antes: analíticas → históricas → funciones → SPs ETL → SPs Reporte → EXECUTE
Ahora: analíticas → funciones → SPs ETL → SPs Reporte → EXECUTE → históricas
```

### `scripts/provision-mariadb.sh`

Cambio 1 (T-4.1 — H-ETL-001): función `_run_etl_backfill()` nueva:
- Detecta tablas `tbl_historico_*` existentes automáticamente
- Parsea year y quarter del nombre de cada tabla
- Llama `sp_etl_historico(year, quarter)` para cada una
- Controlada por `RUN_ETL_BACKFILL=${RUN_ETL_BACKFILL:-0}`
- PASO 7 opcional en `main()` (solo si `RUN_ETL_BACKFILL=1`)

Cambio 2 (H-F4-001): loop de verificación 5→7 funciones (mismo fix que H-ETL-002).

---

## Estado de hallazgos del plan tras FASE 4

| Hallazgo | Descripción | Estado |
|---|---|---|
| H-ETL-001 | `provision-mariadb.sh`: falta backfill ETL para instalaciones nuevas | RESUELTO — T-4.1 |
| H-ETL-002 | `verify.sh`: 5 de 7 funciones verificadas | RESUELTO — T-4.2 |
| H-VFY-001 | `verify.sh` sección 3b: históricas antes que funciones | RESUELTO — T-4.3 |
| H-ETL-003 | `log_fatal` no termina el proceso | RESUELTO — T-4.4 |
| H-F4-001 | `provision-mariadb.sh`: mismo loop de 5 funciones | RESUELTO — T-4.1 |
| H-F4-002 | Plan proyectaba baseline 28 OK — en realidad se mantiene en 27 | DOCUMENTADO |
| H-F4-003 | `log_fatal`: bug más grave que el descrito — sin ningún exit | DOCUMENTADO |
