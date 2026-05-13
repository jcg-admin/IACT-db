# Hallazgos — Análisis Módulo 16 (Programación T-SQL)

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Módulo de referencia:** Módulo 16 — Programación con T-SQL  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Objetos modificados o creados

| Archivo | Objeto | Tipo | Versión anterior | Versión nueva | Cambio |
|---|---|---|---|---|---|
| `objetos/sps/sp_etl_maestro.sql` | `sp_etl_maestro` | PROCEDURE | 2.2.0 | 2.3.0 | `v_abort` flag → `LEAVE etl_maestro` |
| `objetos/sps/sp_rpt_llamadas_abandonadas.sql` | `sp_rpt_llamadas_abandonadas` | PROCEDURE | 2.1.0 | 2.2.0 | Tabla derivada — expresión `pct_del_total` calculada una vez |
| `objetos/vistas/v_quarter_actual.sql` | `v_quarter_actual` | VIEW | — | 1.0.0 | Nueva — VIEW como synonym del cálculo de quarter |

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-16.1 | Análisis de patrones del módulo — equivalencias T-SQL → MariaDB | COMPLETO | H-M16-001 |
| T-16.2 | Auditoría de `SELECT INTO` en los 3 SPs que lo usan | PASA | — |
| T-16.3 | Verificar `LEAVE`/`ITERATE` con label en `WHILE` | PASA | H-M16-002 |
| T-16.4 | Probar `LEAVE` desde el body principal de un SP | PASA | H-M16-003 |
| T-16.5 | Refactorizar `sp_etl_maestro` con `LEAVE etl_maestro` | COMPLETO | — |
| T-16.6 | Probar alias de columna en `CASE` del mismo `SELECT` | FALLA | H-M16-004 |
| T-16.7 | Tabla derivada en `sp_rpt_llamadas_abandonadas` | COMPLETO | — |
| T-16.8 | Crear `v_quarter_actual` como VIEW-synonym | COMPLETO | — |
| T-16.9 | Redesplegar y verify.sh | PASA | — |

---

## H-M16-001 — El comentario en `sp_etl_maestro` describía una restricción incorrecta

**Detectado en:** T-16.1, al analizar el concepto de `BREAK → LEAVE`  
**Severidad:** MEDIA — el comentario llevaba a creer que `LEAVE` no era viable en MariaDB  
**Estado:** RESUELTO en T-16.5

### Descripción

El código de `sp_etl_maestro` contenía este comentario desde la sesión FASE 1:

```
-- FIX: eliminados labels de bloque y LEAVE en handlers anidados.
-- MariaDB 10.11 no permite LEAVE de bloque externo desde EXIT HANDLER.
-- Patron reemplazado: variable v_abort como flag de salida temprana.
```

El comentario es técnicamente correcto pero incompleto. La restricción de MariaDB
aplica a `LEAVE` desde **dentro de un EXIT HANDLER** — no desde el body principal del SP.

Verificado en motor real:

```sql
etl_maestro: BEGIN
    IF NOT v_enabled THEN
        LEAVE etl_maestro;  -- desde el body principal: VÁLIDO
    END IF;
    
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            LEAVE etl_maestro;  -- desde EXIT HANDLER: ERROR en MariaDB 10.11
        END;
    END;
END etl_maestro;
```

El patrón `v_abort` era la solución correcta para la parte del handler (y se conserva
como `v_detalle_cargado`). Pero para los checks de los PASO 0 y PASO 1 — que son código
del body principal, no handlers — `LEAVE` es perfectamente válido.

### Corrección

`sp_etl_maestro` refactorizado:

```
Antes:
  SET v_abort = TRUE        (en PASO 0 y PASO 1)
  IF NOT v_abort THEN       (gran IF que envuelve PASO 2-7)
    ...7 pasos de ETL...
  END IF;                   (cierre del gran IF)

Después:
  LEAVE etl_maestro         (en PASO 0 y PASO 1)
  ...7 pasos de ETL...      (directamente, sin IF envolvente)
END etl_maestro;
```

Beneficio: elimina la variable `v_abort`, elimina un nivel de indentación, y hace
el flujo secuencial — más legible para futuros desarrolladores.

`v_detalle_cargado` se mantiene porque está controlado por el EXIT HANDLER del
PASO 4 (diferente mecanismo — no es un check manual en el body principal).

---

## H-M16-002 — `ITERATE` requiere label en el `WHILE`, no en el `BEGIN`

**Detectado en:** T-16.3  
**Severidad:** Informativo — error de sintaxis fácil de cometer  
**Estado:** DOCUMENTADO para referencia del equipo

### Descripción

```sql
-- INCORRECTO — label en BEGIN:
mi_bloque: BEGIN
    WHILE v_i < 10 DO
        ITERATE mi_bloque;   -- ERROR 1308: ITERATE with no matching label
    END WHILE;
END;

-- CORRECTO — label en el WHILE:
BEGIN
    mi_loop: WHILE v_i < 10 DO
        ITERATE mi_loop;     -- OK
    END WHILE mi_loop;
END;
```

El error `ERROR 1308: ITERATE with no matching label` es confuso porque el label
sí existe — pero `ITERATE` solo reconoce labels en bucles (`WHILE`, `LOOP`, `REPEAT`),
no en bloques `BEGIN...END`.

`LEAVE` en cambio acepta labels tanto de bucles como de bloques `BEGIN` — por eso
el label `etl_maestro:` en el `BEGIN` del SP funciona para `LEAVE etl_maestro`.

---

## H-M16-003 — Expresión repetida x3 en `sp_rpt_llamadas_abandonadas`

**Detectado en:** T-16.6, al buscar candidatos a mejora con variables  
**Severidad:** BAJA — mantenibilidad; no afecta correctitud  
**Estado:** RESUELTO en T-16.7

### Descripción

El módulo enseña que las variables evitan calcular la misma expresión múltiples veces.
En `sp_rpt_llamadas_abandonadas` la expresión de porcentaje aparecía tres veces:

```sql
-- x1: columna pct_del_total
ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) AS pct_del_total,
-- x2: primer WHEN del CASE
WHEN ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) < 20
-- x3: segundo WHEN del CASE
WHEN ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) <= 30
```

### Por qué una variable de SP no funciona aquí

Una variable de SP (`DECLARE v_pct DECIMAL`) es un escalar — se asigna una vez.
En un contexto de `GROUP BY`, cada fila del resultado tiene un valor diferente de
`SUM()`. No existe un mecanismo para asignar una variable por fila dentro de un SELECT.

### Por qué el alias tampoco funciona en el mismo nivel

```sql
-- INCORRECTO — alias no disponible en el mismo SELECT:
ROUND(SUM() / ...) AS pct_del_total,
CASE WHEN pct_del_total < 20 ...  -- ERROR 1054: Unknown column 'pct_del_total'
```

En SQL, todas las expresiones del `SELECT` se evalúan en paralelo — un alias definido
en una columna no puede referenciarse en otra columna del mismo `SELECT`.

### Corrección — tabla derivada

El SELECT externo sí puede referenciar el alias del SELECT interno:

```sql
SELECT
    t.pct_del_total,
    CASE
        WHEN t.pct_del_total < 20  THEN 'OPTIMO'    -- referencia el alias
        WHEN t.pct_del_total <= 30 THEN 'ACEPTABLE'
        ELSE 'CRITICO'
    END AS clasificacion_sla
FROM (
    SELECT
        SUM(b.total_llamadas) AS total_abandonadas,
        ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2) AS pct_del_total
    FROM base_ivr_detalle b
    WHERE ...
    GROUP BY b.segmento, b.menu WITH ROLLUP
) t;
```

`WITH ROLLUP` permanece en el SELECT interno (donde está el `GROUP BY`).
El resultado es idéntico al anterior — verificado en motor real.

---

## H-M16-004 — `v_quarter_actual` resuelve la duplicación de lógica de quarter

**Detectado en:** T-16.8, al analizar sinónimos y lógica compartida  
**Severidad:** BAJA — mantenibilidad  
**Estado:** RESUELTO — vista creada

### Descripción

`sp_etl_maestro` y `sp_etl_historico` calculan la misma lógica de quarter:

```sql
-- En ambos SPs (duplicado):
SET v_year    = YEAR(CURDATE());
SET v_qnum    = QUARTER(CURDATE());
SET v_quarter = CONCAT('Q0', v_qnum, '_', RIGHT(v_year, 2));
SET v_table   = CONCAT('tbl_historico_t', v_qnum, '_', v_year);
SET v_inicio  = MAKEDATE(v_year, 1) + INTERVAL (v_qnum - 1) * 3 MONTH;
SET v_fin     = LAST_DAY(v_inicio + INTERVAL 2 MONTH);
```

MariaDB no soporta `CREATE SYNONYM`. La alternativa es una VIEW:

```sql
CREATE OR REPLACE VIEW v_quarter_actual AS
SELECT
    CONCAT('Q0', QUARTER(CURDATE()), '_', RIGHT(YEAR(CURDATE()), 2))  AS quarter
    , CONCAT('tbl_historico_t', QUARTER(CURDATE()), '_', YEAR(CURDATE())) AS tabla_origen
    , MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL (QUARTER(CURDATE())-1)*3 MONTH AS fecha_inicio
    , LAST_DAY(MAKEDATE(YEAR(CURDATE()),1) + INTERVAL QUARTER(CURDATE())*3-1 MONTH) AS fecha_fin;
```

**Verificado en Mayo 2026 (Q02_26):**
```
quarter = Q02_26
tabla_origen = tbl_historico_t2_2026
fecha_inicio = 2026-04-01
fecha_fin    = 2026-06-30
```

**Valor para Django:** el endpoint de estado del ETL puede consultar
`SELECT * FROM v_quarter_actual` para mostrar el quarter activo sin llamar
a un SP ni replicar la lógica `YEAR/QUARTER/MAKEDATE` en Python.

---

## Verificación final

```
sp_etl_maestro v2.3.0:
  v_abort eliminado del código (solo en comentarios históricos)
  etl_maestro: label en BEGIN
  LEAVE etl_maestro en PASO 0 y PASO 1
  v_detalle_cargado conservado (EXIT HANDLER)

sp_rpt_llamadas_abandonadas v2.2.0:
  ROUND(SUM/NULLIF(v_total_quarter)) aparece x1 (antes x3)
  CASE clasificacion_sla referencia alias pct_del_total
  WITH ROLLUP conservado en SELECT interno
  Resultado idéntico verificado: 34.01% CRITICO en fila TOTAL

v_quarter_actual v1.0.0:
  Centraliza lógica de quarter en un lugar
  Django puede consultar sin SP

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```
