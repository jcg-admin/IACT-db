# Hallazgos — Ejecución FASE 1 (sobre archivos individuales canónicos)

**Versión:** 2.0.0  
**Fecha:** 2026-05-13  
**Plan de referencia:** `PLAN-IMPL-HALLAZGOS-SQL-SERVER-IACT-DB.md` FASE 1  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Nota sobre versión anterior:** La v1.0.0 documentaba FASE 1 aplicada sobre los bundles
`sp_etl_pipeline.sql` / `sp_rpt_reportes.sql` / `funciones_utilidad.sql`. Esos bundles
fueron eliminados en commit `5c3cc64` — cada SP tiene ahora su propio archivo en
`provisioners/mariadb/objetos/`. Este documento v2.0.0 es la fuente de verdad
de FASE 1 sobre los archivos canónicos actuales.

---

## Archivos canónicos — estado post-FASE 1

| Archivo | Objeto | Versión | Cambios FASE 1 |
|---|---|---|---|
| `objetos/sps/sp_etl_maestro.sql` | `sp_etl_maestro` | 2.1.0 | Sí — T-1.1, T-1.2, T-1.3 |
| `objetos/sps/sp_etl_base_detalle.sql` | `sp_etl_base_detalle` | 2.1.0 | Sí — T-1.4 |
| `objetos/sps/sp_etl_base_clientes.sql` | `sp_etl_base_clientes` | 2.0.0 | No — sin cambios funcionales |
| `objetos/sps/sp_etl_validar.sql` | `sp_etl_validar` | 2.0.0 | No — sin cambios funcionales |
| `objetos/sps/sp_etl_historico.sql` | `sp_etl_historico` | 2.0.0 | No — sin cambios funcionales |

---

## Resultado de las tareas

| Tarea | Descripción | Archivo canónico | Estado | Hallazgo |
|---|---|---|---|---|
| T-1.1 | `DECLARE v_paso4_failed` | `sp_etl_maestro.sql` | COMPLETO | — |
| T-1.2 | `SET v_paso4_failed = TRUE` en handler PASO 4 | `sp_etl_maestro.sql` | COMPLETO | — |
| T-1.3 | Guard PASO 5 + PASO 7 preserva FAILED | `sp_etl_maestro.sql` | COMPLETO | H-F1-001 |
| T-1.4 | `PREPARE etl_stmt` fuera del `WHILE` | `sp_etl_base_detalle.sql` | COMPLETO | H-F1-002 |
| T-1.5 | Verificación 20/20 archivos en MariaDB | — | PASA | H-F1-003 |
| T-1.6 | verify.sh 27 OK | — | PASA | — |

---

## H-F1-001 — T-1.3 era incompleto: PASO 7 sobreescribía FAILED con PARTIAL

**Detectado en:** T-1.3, durante el análisis del flujo completo  
**Archivo afectado:** `objetos/sps/sp_etl_maestro.sql`  
**Severidad:** MEDIA  
**Estado:** RESUELTO

### Descripción

El plan especificaba: "IF NOT v_paso4_failed envuelve PASO 5". Al implementar,
el análisis del flujo completo reveló un gap secundario no contemplado:

```
Flujo con solo el guard de PASO 5:
  1. PASO 4 falla → handler: maestro = FAILED, v_paso4_failed = TRUE
  2. PASO 5 no ejecuta (CORRECTO)
  3. PASO 6: sp_etl_validar → v_ok = FALSE (base_ivr_detalle vacía)
  4. PASO 7: UPDATE maestro → status = PARTIAL  ← SOBREESCRIBE FAILED
```

Estado final en `job_execution_log` sin la corrección adicional:

```
maestro:             PARTIAL   ← causa raíz oscurecida
etl_base_detalle:   FAILED    ← correcto
etl_base_clientes:  (sin entrada)  ← correcto
```

### Corrección en `sp_etl_maestro.sql`

PASO 7 modificado con bifurcación por `v_paso4_failed`:

```sql
IF v_paso4_failed THEN
    -- El handler de PASO 4 ya fijó status=FAILED y error_message.
    -- Solo garantizar que end_time quede seteado.
    UPDATE job_execution_log
    SET end_time = COALESCE(end_time, NOW())
    WHERE id = v_maestro_id;
ELSE
    UPDATE job_execution_log
    SET status        = IF(COALESCE(v_ok, FALSE), 'SUCCESS', 'PARTIAL'),
        end_time      = NOW(),
        error_message = IF(COALESCE(v_ok, FALSE), NULL, v_msg)
    WHERE id = v_maestro_id;
END IF;
```

### Verificación con prueba de fallo controlado

```
step_name            status   error
maestro              FAILED   Falló etl_base_detalle: Table 'ivr_legacy.tabla_fa...
etl_base_detalle    FAILED   Table 'ivr_legacy.tabla_fantasma_99999' doesn't exist
```

`etl_base_clientes` sin entrada — PASO 5 no ejecutó.  
`maestro` en `FAILED`, no en `PARTIAL`.

---

## H-F1-002 — Verificación de T-1.4: `@etl_sql` no usa variables que cambian por iteración

**Detectado en:** T-1.4, durante el análisis previo a mover el PREPARE  
**Archivo afectado:** `objetos/sps/sp_etl_base_detalle.sql`  
**Severidad:** INFORMATIVO — confirma que el cambio es seguro  
**Estado:** DOCUMENTADO

### Descripción

Antes de mover `PREPARE etl_stmt` fuera del WHILE se verificó que el CONCAT de
`@etl_sql` no referenciaba variables que cambian entre iteraciones. Confirmado:
el CONCAT solo usa `p_table` (parámetro `IN`, constante durante toda la llamada).
Los valores dinámicos (`v_mes_ini`, `v_mes_fin`) se pasan exclusivamente vía `USING`.

### Estado en `sp_etl_base_detalle.sql`

```
PREPARE etl_stmt : L14  → antes del WHILE (L92)         OK
DEALLOCATE       : L117 → después del END WHILE (L125)   OK
PREPARE/DEALLOCATE dentro del WHILE: 0 ocurrencias
```

---

## H-F1-003 — 9 archivos individuales tenían prerequisitos referenciando bundles eliminados

**Detectado en:** T-1.5, durante la auditoría previa al despliegue  
**Archivos afectados:** 9 de los 20 archivos en `objetos/`  
**Severidad:** MEDIA — prerequisitos rotos generan confusión operacional  
**Estado:** RESUELTO (parte de esta FASE 1)

### Descripción

La auditoría detectó que 9 archivos individuales tenían en su campo `Prerequisito`
referencias a los tres bundles ya eliminados:

| Patrón encontrado | Archivos afectados |
|---|---|
| `funciones_utilidad.sql — schema_base_ivr.sql` | `sp_etl_base_detalle.sql`, `sp_etl_base_clientes.sql`, 7 SPs RPT |
| `sp_etl_pipeline.sql (base_ivr_* con datos)` | 7 SPs RPT |

Un desarrollador que leyera el campo `Prerequisito` e intentara instalar la
dependencia obtendría "archivo no encontrado". Este hallazgo no estaba en el
plan original pero se resuelve en esta FASE porque es deuda técnica directa
del refactor de bundles → archivos individuales.

### Correcciones aplicadas en los 9 archivos

```
Antes: funciones_utilidad.sql — schema_base_ivr.sql
Ahora: objetos/funciones/ (7 funciones) — schema_base_ivr.sql

Antes: funciones_utilidad.sql — schema_base_ivr.sql — sp_etl_pipeline.sql (base_ivr_* con datos)
Ahora: objetos/funciones/ (7 funciones) — schema_base_ivr.sql — objetos/sps/sp_etl_*.sql (base_ivr_* con datos)
```

### Verificación

```
grep 'funciones_utilidad.sql' objetos/**/*.sql  → 0 ocurrencias
grep 'sp_etl_pipeline.sql'    objetos/**/*.sql  → 0 ocurrencias
grep 'sp_rpt_reportes.sql'    objetos/**/*.sql  → 0 ocurrencias
```

---

## Cambios en `sp_etl_maestro.sql` (T-1.1, T-1.2, T-1.3)

| Elemento | Línea | Descripción |
|---|---|---|
| `DECLARE v_paso4_failed BOOLEAN DEFAULT FALSE` | L37-L40 | Flag con comentario sobre H-IACT-005 |
| `SET v_paso4_failed = TRUE` | en EXIT HANDLER PASO 4 | Activa el flag en el handler |
| `IF NOT v_paso4_failed THEN ... END IF;` | envuelve PASO 5 | Guard completo del bloque PASO 5 |
| `IF v_paso4_failed THEN ... ELSE ... END IF;` | PASO 7 | Preserva FAILED vs calcula SUCCESS/PARTIAL |

## Cambio en `sp_etl_base_detalle.sql` (T-1.4)

| Elemento | Antes | Después |
|---|---|---|
| `SET @etl_sql = CONCAT(...)` | Dentro del WHILE (×3/quarter) | Antes del WHILE (×1/llamada) |
| `PREPARE etl_stmt FROM @etl_sql` | Dentro del WHILE (×3/quarter) | Antes del WHILE (×1/llamada) |
| `EXECUTE etl_stmt USING ...` | Dentro del WHILE | Dentro del WHILE (sin cambio) |
| `DEALLOCATE PREPARE etl_stmt` | Dentro del WHILE (×3/quarter) | Después del END WHILE (×1/llamada) |

---

## Verificación funcional final

```
20/20 archivos individuales: OK en MariaDB (0 errores de sintaxis)
provision-mariadb.sh: 20 objetos aplicados, 32 grants EXECUTE restaurados
verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0

sp_etl_maestro ejecución normal:
  Q02_26: 1783 filas detalle, 3 clientes, 47,534 llamadas — status=SUCCESS

Prueba de fallo controlado (v_paso4_failed):
  maestro: FAILED (no PARTIAL)
  etl_base_clientes: sin entrada en log (PASO 5 no ejecutó)

Prerequisitos en 20 archivos: 0 referencias a bundles eliminados
```
