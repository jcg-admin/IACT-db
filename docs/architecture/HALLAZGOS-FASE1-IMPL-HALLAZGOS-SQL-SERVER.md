# Hallazgos — Ejecución FASE 1 (Plan IACT-db — correcciones de flujo de control)

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Plan de referencia:** `PLAN-IMPL-HALLAZGOS-SQL-SERVER-IACT-DB.md` FASE 1  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-1.1 | `DECLARE v_paso4_failed` en `sp_etl_maestro` | COMPLETO | — |
| T-1.2 | `SET v_paso4_failed = TRUE` en EXIT HANDLER PASO 4 | COMPLETO | — |
| T-1.3 | Guard PASO 5 + PASO 7 preserva FAILED | COMPLETO | H-F1-001 |
| T-1.4 | `PREPARE etl_stmt` fuera del `WHILE` en `sp_etl_base_detalle` | COMPLETO | H-F1-002 |
| T-1.5 | Redespliegue `sp_etl_pipeline.sql` + verify.sh + prueba de fallo | PASA | — |
| T-1.6 | Actualizar `objetos/sps/` individuales (v2.1.0) | COMPLETO | — |
| T-1.7 | Commit de FASE 1 | COMPLETO | — |

---

## H-F1-001 — El plan T-1.3 era incompleto: PASO 7 sobreescribía FAILED con PARTIAL

**Detectado en:** T-1.3, durante el análisis del flujo completo al implementar el guard de PASO 5  
**Severidad:** MEDIA — sin la corrección del PASO 7, el status del maestro en `job_execution_log`
sería engañoso para el operador que monitorea el pipeline  
**Estado:** RESUELTO en T-1.3 (extendido)

### Descripción

El plan documentaba T-1.3 como: "IF NOT v_paso4_failed envuelve el bloque PASO 5".
Durante la implementación, el análisis del flujo completo reveló un gap secundario
no contemplado en el plan original:

**Flujo con solo el guard de PASO 5 (plan original):**

```
1. PASO 4 falla → EXIT HANDLER dispara
2. Handler: UPDATE maestro → status='FAILED', error_message='Falló etl_base_detalle: ...'
3. Handler: SET v_paso4_failed = TRUE
4. PASO 5: IF NOT v_paso4_failed → no ejecuta (CORRECTO)
5. PASO 6: sp_etl_validar ejecuta → v_ok = FALSE (base_ivr_detalle vacía)
6. PASO 7: UPDATE maestro → status='PARTIAL'   ← SOBREESCRIBE EL FAILED
```

El estado final en `job_execution_log` sería:

```
maestro:             PARTIAL   ← incorrecto como causa raíz
etl_base_detalle:   FAILED    ← correcto
etl_base_clientes:  (ninguna entrada) ← correcto con el guard
```

Un operador que revisara el log vería el maestro como `PARTIAL` y tendría que
navegar al detalle del paso para entender que el fallo fue en PASO 4. La causa
raíz quedaría oscurecida.

El comentario existente en el handler decía:

```sql
-- No LEAVE: el handler termina y el bloque externo continua
-- v_ok quedara NULL, el UPDATE final marcara PARTIAL
```

Esto confirma que el comportamiento era conocido y documentado como intencional.
Sin embargo, con el guard de PASO 5 activo, el escenario cambia: antes, PASO 5
corría aunque PASO 4 fallara, por lo que PARTIAL tenía sentido ("algunos pasos
corrieron"). Con el guard, PASO 5 no corre — PARTIAL ya no describe el estado
real: el pipeline no completó ningún paso de datos.

### Corrección implementada

**Corrección de PASO 7** — verificar `v_paso4_failed` antes de actualizar el status:

```sql
-- PASO 7: Estado final del maestro
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

**Estado final en `job_execution_log` con la corrección:**

```
maestro:             FAILED    ← correcto — causa raíz visible de inmediato
etl_base_detalle:   FAILED    ← correcto con error_message
etl_base_clientes:  (ninguna entrada) ← correcto — no se ejecutó
```

### Verificación con prueba de fallo controlado

Se creó un SP de prueba `_test_paso4_fallo` que simula el fallo del PASO 4
usando una tabla inexistente (`tabla_fantasma_99999`). Resultado confirmado:

```
step_name            status   error
maestro              FAILED   Falló etl_base_detalle: Table 'ivr_legacy.tabla_fa...
etl_base_detalle    FAILED   Table 'ivr_legacy.tabla_fantasma_99999' doesn't exist
```

`etl_base_clientes` no tiene entrada en el log — el `IF NOT v_paso4_failed` funcionó.
El maestro quedó en `FAILED`, no en `PARTIAL`.

---

## H-F1-002 — T-1.4: verificación de que `@etl_sql` no usa variables que cambian por iteración

**Detectado en:** T-1.4, durante el análisis previo a mover el `PREPARE` fuera del WHILE  
**Severidad:** INFORMATIVO — sin el análisis, el cambio podría haberse aplicado incorrectamente  
**Estado:** DOCUMENTADO — el cambio es seguro

### Descripción

El plan indicaba "mover `PREPARE etl_stmt` fuera del WHILE". Antes de aplicarlo,
fue necesario confirmar que el SQL del `SET @etl_sql = CONCAT(...)` no referenciaba
variables que cambian entre iteraciones (`v_mes_ini`, `v_mes_fin`).

**Análisis del `CONCAT`:**

El script de inspección buscó `v_mes_ini` y `v_mes_fin` dentro del bloque `SET @etl_sql`:

```
Referencias a v_mes_ini/v_mes_fin dentro del CONCAT: NINGUNA
```

El `CONCAT` solo incluye `p_table` (parámetro `IN` — constante para toda la llamada al SP).
Los valores que cambian por mes (`v_mes_ini`, `v_mes_fin`) se pasan vía `USING` como
`@etl_i` y `@etl_f` — no forman parte del SQL estático que se prepara.

**Consecuencia confirmada:** Mover el `PREPARE` fuera del WHILE es seguro. El statement
preparado es idéntico en todas las iteraciones. Solo `EXECUTE` necesita estar dentro
del WHILE porque los valores de `@etl_i` y `@etl_f` cambian por mes.

### El patrón de la prueba inicial indujo a error

La inspección automática inicial reportó `True` para "v_mes_ini en @etl_sql CONCAT"
porque buscó la cadena en el bloque completo entre el `SET @etl_sql` y la línea
`PREPARE` — incluyendo líneas posteriores al cierre del CONCAT. El análisis posterior,
buscando específicamente dentro del string entre comillas del CONCAT, confirmó que
la referencia estaba en líneas fuera del CONCAT (el `SET @etl_q = p_quarter, @etl_i = v_mes_ini`
que sigue al PREPARE). El CONCAT en sí no las referencia.

---

## Cambios implementados en `sp_etl_pipeline.sql`

### `sp_etl_maestro` — T-1.1, T-1.2, T-1.3

| Tarea | Línea (post-cambio) | Cambio |
|---|---|---|
| T-1.1 | L293-L296 | `DECLARE v_paso4_failed BOOLEAN DEFAULT FALSE;` con comentario |
| T-1.2 | L377-L380 | `SET v_paso4_failed = TRUE;` al final del EXIT HANDLER del PASO 4 |
| T-1.3a | L391-L423 | `IF NOT v_paso4_failed THEN ... END IF;` envuelve el bloque PASO 5 completo |
| T-1.3b | L431-L447 | PASO 7 con `IF v_paso4_failed THEN ... ELSE ... END IF;` |

### `sp_etl_base_detalle` — T-1.4

| Elemento | Antes | Después |
|---|---|---|
| `SET @etl_sql = CONCAT(...)` | Dentro del WHILE (×3 por quarter) | Fuera del WHILE (×1 por llamada) |
| `PREPARE etl_stmt FROM @etl_sql` | Dentro del WHILE (×3 por quarter) | Fuera del WHILE (×1 por llamada) |
| `EXECUTE etl_stmt USING ...` | Dentro del WHILE | Dentro del WHILE (sin cambio) |
| `DEALLOCATE PREPARE etl_stmt` | Dentro del WHILE (×3 por quarter) | Fuera del WHILE, después del END WHILE (×1) |

---

## Versiones actualizadas

| Objeto | Versión anterior | Versión nueva |
|---|---|---|
| `sp_etl_maestro` | 2.0.0 | 2.1.0 |
| `sp_etl_base_detalle` | 2.0.0 | 2.1.0 |
| `objetos/sps/sp_etl_maestro.sql` | 2.0.0 | 2.1.0 |
| `objetos/sps/sp_etl_base_detalle.sql` | 2.0.0 | 2.1.0 |

---

## Verificación funcional

```
sp_etl_base_detalle Q01_25 (con PREPARE fuera):
  Pre:  grupos=884/851/881, llamadas=28625/25781/28678
  Post: grupos=898/869/902, llamadas=34677/31511/34975
  Idempotencia correcta — datos consistentes.

sp_etl_maestro ejecución normal:
  Q02_26: 1783 filas detalle, 3 clientes, 47,534 llamadas — status=SUCCESS

Prueba de fallo controlado (tabla_fantasma_99999):
  maestro:             FAILED   (no sobreescrito por PARTIAL)
  etl_base_detalle:   FAILED   con error_message
  etl_base_clientes:  sin entrada (PASO 5 no ejecutó)

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```
