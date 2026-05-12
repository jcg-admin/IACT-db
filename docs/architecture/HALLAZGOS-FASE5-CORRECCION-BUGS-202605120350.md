# Hallazgos — Ejecución FASE 5 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 5  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-5.1 | `sp_rpt_clientes` — NULLIF en `pct_del_total` | COMPLETO | H-F5-001 |
| T-5.2 | `sp_rpt_centros_transferencia` — NULLIF en `porcentaje` | COMPLETO | H-F5-002 |
| T-5.3 | `sp_rpt_llamadas_abandonadas` — NULLIF en 3 divisiones (BUG-004 principal) | COMPLETO | H-F5-003 |
| T-5.4 | `sp_rpt_menu_redirigidos` — NULLIF en `pct_del_menu` y `pct_del_total` | COMPLETO | — |
| T-5.5 | `sp_rpt_menu_centro` — NULLIF en `pct_del_centro` | COMPLETO | — |
| T-5.6 | `sp_rpt_centros_xsegmento` — NULLIF en `pct_del_segmento` | COMPLETO | — |
| T-5.7 | Redespliegue en BD + restauración de GRANT EXECUTE | COMPLETO | H-F5-004 |
| T-5.8 | Verificación funcional de los 7 SPs | PASA | H-F5-005 |

---

## H-F5-001 — BUG-004 solo es real en dos SPs; el resto son casos defensivos

**Detectado en:** T-5.1 y T-5.2, durante el análisis previo a los cambios  
**Severidad:** INFORMATIVO — el alcance del fix es mayor que el del bug documentado  
**Estado:** DOCUMENTADO, alcance ampliado deliberadamente

### Descripción

El catálogo de BUG-004 mencionaba divisiones por cero silenciosas en
`sp_rpt_clientes` y `sp_rpt_llamadas_abandonadas`. El análisis de las 9
divisiones en el archivo reveló dos categorías con propiedades distintas:

**Categoría 1 — Bug demostrable (2 SPs):**

`sp_rpt_clientes` divide `clientes_unicos` por un `SUM()` de
`base_ivr_clientes`, que es una **tabla distinta** a la tabla del `FROM`
exterior. Si el ETL falló y `base_ivr_clientes` tiene filas para el quarter
pero con `clientes_unicos = 0`, el denominador es 0 y la división produce
`NULL` silencioso. Verificado empíricamente:

```sql
INSERT INTO base_ivr_clientes (trimestre, segmento, clientes_unicos)
VALUES ('Q_TEST', 'seg_test', 0);
CALL sp_rpt_clientes('Q_TEST');
-- pct_del_total = NULL ← bug confirmado
```

`sp_rpt_llamadas_abandonadas` usa `DECLARE v_total_quarter BIGINT DEFAULT 0`.
Si la tabla no tiene filas para el filtro aplicado, `SELECT SUM(...) INTO v_total_quarter`
retorna `NULL` y la asignación deja `v_total_quarter` en `0` (por el `DEFAULT 0`,
no en `NULL`). Dividir por 0 en MariaDB produce `NULL`. Adicionalmente, el `CASE`
en la `clasificacion_sla` usa la expresión con divisor en sus condiciones `WHEN`:
con `v_total_quarter = 0`, `NULL < 20` evalúa a `UNKNOWN` en SQL, y el `CASE`
cae al `ELSE 'CRITICO'` — que es el resultado de mayor alerta, no el correcto.

**Categoría 2 — Subconsultas correlacionadas seguras (5 SPs):**

Las demás divisiones usan subconsultas correlacionadas con la misma tabla y
quarter del `FROM` exterior:

```sql
-- Ejemplo: sp_rpt_centros_transferencia
b.total_llamadas
/ (SELECT SUM(b2.total_llamadas)
   FROM base_ivr_detalle b2
   WHERE b2.trimestre = p_quarter
     AND b2.fecha     = b.fecha    -- correlación con la fila exterior
     AND ...)
```

Si la fila exterior `b` existe (tiene `fecha = X`), la subconsulta
encontrará al menos esa misma fila → `SUM >= b.total_llamadas > 0`.
El denominador no puede ser `NULL` ni `0` mientras haya filas en el
resultado exterior.

**Decisión de alcance:** Aplicar `NULLIF` a todas las divisiones, incluyendo
las subconsultas correlacionadas. El motivo:

1. `sp_rpt_centros_xsegmento` ya usaba `NULLIF` en su única división
   (anterior a esta FASE). La inconsistencia con los demás SPs es deuda técnica.
2. El costo de `NULLIF` en datos válidos es cero (nunca dispara).
3. La correctitud explícita es preferible a la implícita — el código deja de
   depender del razonamiento "la correlación garantiza SUM > 0" que es correcto
   hoy pero podría cambiar si el ETL cambia la granularidad de `base_ivr_detalle`.

---

## H-F5-002 — El catálogo incluía `sp_rpt_centros_transferencia` como afectado: análisis

**Detectado en:** T-5.2, durante el análisis de la subconsulta correlacionada  
**Severidad:** INFORMATIVO  
**Estado:** DOCUMENTADO

### Descripción

El catálogo de BUG-004 (en el plan) listaba `sp_rpt_centros_transferencia L89`
como una de las divisiones a corregir. El análisis reveló que es una
subconsulta correlacionada por `b2.fecha = b.fecha`.

La subconsulta busca filas con `trimestre = p_quarter AND fecha = b.fecha`.
La fila exterior `b` proviene de `base_ivr_detalle WHERE trimestre = p_quarter AND fecha = b.fecha`.
Estas condiciones garantizan que la subconsulta siempre encontrará al menos la
fila `b` misma, por lo que `SUM >= b.total_llamadas > 0`.

Se aplicó `NULLIF` por consistencia con el resto del archivo.

---

## H-F5-003 — `CASE` con `NULL` en `sp_rpt_llamadas_abandonadas` va al `ELSE`, no queda en NULL

**Detectado en:** T-5.3, durante el análisis de `v_total_quarter = 0`  
**Severidad:** INFORMATIVO — el comportamiento incorrecto es menos grave de lo esperado  
**Estado:** DOCUMENTADO

### Descripción

Cuando `v_total_quarter = 0`, las tres expresiones que lo usan en
`sp_rpt_llamadas_abandonadas` producen `NULL`:

```sql
ROUND(SUM(b.total_llamadas) / 0 * 100, 2)  →  NULL
```

El campo `pct_del_total` queda `NULL` — comportamiento incorrecto silencioso.

Sin embargo, el `CASE` en `clasificacion_sla`:

```sql
CASE
    WHEN ROUND(SUM(b.total_llamadas) / v_total_quarter * 100, 2) < 20
        THEN 'OPTIMO'
    WHEN ROUND(SUM(b.total_llamadas) / v_total_quarter * 100, 2) <= 30
        THEN 'ACEPTABLE'
    ELSE 'CRITICO'
END
```

Con `NULL` en la expresión:
- `NULL < 20` evalúa a `UNKNOWN` en SQL (no `TRUE` ni `FALSE`)
- `UNKNOWN` no activa el `WHEN`
- El `CASE` cae al `ELSE 'CRITICO'`

Verificado:
```sql
SELECT
    ROUND(5/0*100,2) AS div_by_zero,
    CASE
        WHEN ROUND(5/0*100,2) < 20 THEN 'OPTIMO'
        WHEN ROUND(5/0*100,2) <= 30 THEN 'ACEPTABLE'
        ELSE 'CRITICO'
    END AS clasificacion;
-- → NULL | CRITICO
```

El resultado `'CRITICO'` vía `ELSE` es paradójicamente el estado de mayor
alerta — peor que lo correcto, pero no `NULL`. Con el fix (`NULLIF`), si
`v_total_quarter = 0`, `pct_del_total = NULL` y `clasificacion_sla = 'CRITICO'`
(por el `ELSE`). El comportamiento es el mismo en el `CASE`, pero `pct_del_total`
sería `NULL` explícito en lugar de resultado de dividir por cero — semántica más
clara para el frontend que consume el SP.

---

## H-F5-004 — `DROP PROCEDURE` elimina GRANT EXECUTE: requiere provision-mariadb.sh post-redespliegue

**Detectado en:** T-5.7, al ejecutar verify.sh después del redespliegue  
**Severidad:** ALTA — proceso a documentar para futuros redespliegues  
**Estado:** RESUELTO en T-5.7

### Descripción

Al redesplegar `sp_rpt_reportes.sql` con los cambios de `NULLIF`, verify.sh
reportó:

```
ERROR: GRANT EXECUTE faltante — django_user no puede invocar routines (0 PROC, 7 FUNC)
```

**Causa:** El archivo SQL tiene `DROP PROCEDURE IF EXISTS sp_rpt_X$$` antes de
cada `CREATE PROCEDURE`. En MariaDB (y MySQL), `DROP PROCEDURE` elimina también
todos los `GRANT EXECUTE` asociados al procedimiento. Al recrear el SP con
`CREATE PROCEDURE`, el SP existe pero sin los grants de ejecución.

**Solución:** Ejecutar `scripts/provision-mariadb.sh` después del redespliegue
para restaurar los `GRANT EXECUTE`. Este script es idempotente y re-aplica todos
los grants necesarios.

**Procedimiento documentado para futuros redespliegues de SPs:**

```bash
# 1. Redesplegar el SQL:
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy < sp_rpt_reportes.sql

# 2. Restaurar GRANT EXECUTE (siempre necesario después de DROP/CREATE PROCEDURE):
bash scripts/provision-mariadb.sh

# 3. Verificar:
bash verify.sh
```

Este comportamiento aplica también a `sp_etl_pipeline.sql` (FASE 4) y a
cualquier otro archivo SQL que use `DROP PROCEDURE IF EXISTS`.

---

## H-F5-005 — Los 128 NULL reportados por grep en sp_rpt_centros_transferencia son texto literal

**Detectado en:** T-5.8, durante la verificación funcional  
**Severidad:** INFORMATIVO — no hay bug, solo artefacto del método de verificación  
**Estado:** DOCUMENTADO

### Descripción

Durante la verificación, el conteo de `NULL` en el output de
`sp_rpt_centros_transferencia` mostró 128 ocurrencias. Una investigación
adicional confirmó que son la cadena de texto `'NULL'` almacenada en la columna
`opcion` de `base_ivr_detalle`, no valores SQL `NULL`.

En `mysql -N` (modo batch sin cabeceras), los valores `NULL` SQL se muestran
como la palabra `NULL`, idéntica a una cadena de texto que contenga `"NULL"`.
El `grep "NULL"` no distingue entre ambos.

La verificación correcta requiere inspeccionar la columna específica:

```sql
SELECT COUNT(*) FROM base_ivr_detalle
WHERE trimestre = 'Q02_26' AND opcion IS NULL;
-- → 0 (no hay NULL SQL en la columna opcion)
```

Los 128 casos son datos válidos donde `opcion` contiene el texto `'NULL'`
proveniente del sistema IVR fuente.

---

## Cambios implementados — resumen

| SP | Campo | Antes | Después |
|---|---|---|---|
| `sp_rpt_clientes` | `pct_del_total` | `/ (SELECT SUM(...))` | `/ NULLIF((SELECT SUM(...)), 0)` |
| `sp_rpt_centros_transferencia` | `porcentaje` | `/ (SELECT SUM(...))` | `/ NULLIF((SELECT SUM(...)), 0)` |
| `sp_rpt_llamadas_abandonadas` | `pct_del_total` | `/ v_total_quarter` | `/ NULLIF(v_total_quarter, 0)` |
| `sp_rpt_llamadas_abandonadas` | `pct_del_segmento` | `/ (SELECT SUM(...))` | `/ NULLIF((SELECT SUM(...)), 0)` |
| `sp_rpt_llamadas_abandonadas` | `clasificacion_sla` CASE (×2) | `/ v_total_quarter` | `/ NULLIF(v_total_quarter, 0)` |
| `sp_rpt_menu_redirigidos` | `pct_del_menu` | `/ (SELECT SUM(...))` | `/ NULLIF((SELECT SUM(...)), 0)` |
| `sp_rpt_menu_redirigidos` | `pct_del_total` | `/ (SELECT SUM(...))` | `/ NULLIF((SELECT SUM(...)), 0)` |
| `sp_rpt_menu_centro` | `pct_del_centro` | `/ (SELECT SUM(...))` | `/ NULLIF((SELECT SUM(...)), 0)` |
| `sp_rpt_centros_xsegmento` | `pct_del_segmento` | `/ (SELECT SUM(...))` | `/ NULLIF((SELECT SUM(...)), 0)` |
| `sp_rpt_centros_xsegmento` | `pct_entre_semana` | `/ NULLIF(...)` | sin cambio — ya correcto |

---

## Verificación funcional

| SP | Filas | NULL SQL reales |
|---|---|---|
| `sp_rpt_clientes('Q02_26')` | 3 | 0 |
| `sp_rpt_centros_transferencia('Q02_26','todas')` | 1759 | 0 |
| `sp_rpt_llamadas_abandonadas('Q02_26','todas')` | 9 | 0 |
| `sp_rpt_menu_redirigidos('Q02_26','todas')` | 563 | 0 |
| `sp_rpt_menu_centro('Q02_26','todas')` | 1095 | 0 |
| `sp_rpt_cMENU_ERROR('Q02_26','todas')` | 29 | 0 |
| `sp_rpt_centros_xsegmento('Q02_26')` | 91 | 0 |

---

## Estado de los bugs del plan tras FASE 5

| Bug | Descripción | Estado |
|---|---|---|
| BUG-004 | División por cero silenciosa en `sp_rpt_clientes` y `sp_rpt_llamadas_abandonadas` | RESUELTO — T-5.1/T-5.3 |
| Extensión | Divisiones en los 5 SPs restantes — patrón inconsistente con `sp_rpt_centros_xsegmento` | RESUELTO — T-5.2/T-5.4/T-5.5/T-5.6 |
