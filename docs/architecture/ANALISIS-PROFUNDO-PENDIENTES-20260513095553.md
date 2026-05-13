# Análisis Profundo — Pendientes de Implementación IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Motor verificado:** MariaDB 10.11.14

Este documento analiza cada pendiente a nivel técnico: qué objetos cambian, qué
tablas se crean o modifican, qué dependencias existen, qué riesgos hay, y qué
correcciones son necesarias respecto al análisis anterior. No es el plan de
implementación — es la base técnica que lo hace posible.

---

## Matriz de impacto por objeto

| Objeto | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | P9 | P10 |
|---|---|---|---|---|---|---|---|---|---|---|
| `sp_etl_maestro` | MODIFICA | — | — | — | — | — | — | — | — | — |
| `sp_rpt_cMENU_ERROR` | — | MODIFICA | MODIFICA | — | — | — | — | — | — | — |
| `sp_rpt_menu_centro` | — | MODIFICA | — | MODIFICA | — | — | — | — | — | — |
| `sp_rpt_clientes` | — | MODIFICA | — | — | MODIFICA | — | — | — | — | — |
| `sp_rpt_menu_redirigidos` | — | MODIFICA | — | — | — | MODIFICA | — | — | — | — |
| `sp_rpt_centros_xsegmento` | — | — | — | — | — | — | — | — | MODIFICA | — |
| `sp_rpt_centros_transferencia` | — | MODIFICA | — | — | — | — | — | — | — | MODIFICA |
| `sp_rpt_llamadas_abandonadas` | — | MODIFICA | — | — | — | — | — | — | — | — |
| `v_etl_rendimiento` | — | — | — | — | — | — | CREA | — | — | — |
| `sp_rpt_resumen_abandono_rollup` | — | — | — | — | — | — | — | CREA | — | — |
| `ivr_error_log` | RECIBE | RECIBE | — | — | — | — | — | — | — | — |
| `job_execution_log` | REFERENCIA | — | — | — | — | — | REFERENCIA | — | — | — |

**Nuevas tablas:** ninguna.  
**Nuevas vistas:** `v_etl_rendimiento` (P7).  
**Nuevos SPs:** `sp_rpt_resumen_abandono_rollup` (P8).  
**Objetos que solo reciben datos:** `ivr_error_log` (P1, P2).  
**Objetos que no se modifican:** `sp_etl_base_detalle`, `sp_etl_base_clientes`,
`sp_etl_validar`, `sp_etl_historico`, `evt_etl_diario`, todas las funciones,
`v_quarter_actual`, `v_sla_distribucion`.

---

## P1 — Conectar `ivr_error_log` con los EXIT HANDLERs de `sp_etl_maestro`

**Objeto:** `sp_etl_maestro` v2.4.0 → v2.5.0  
**Schema:** no cambia — `ivr_error_log` ya existe

### Variables disponibles dentro de los handlers

Cuando un EXIT HANDLER de PASO 4, 5 o 6 se activa, las variables del SP externo
son accesibles. La cadena de asignaciones es:

```
PASO 0: GET JOB_CONFIG → v_enabled, v_timeout
PASO 2: SET v_year, v_qnum, v_quarter, v_table, v_inicio, v_fin
PASO 3: INSERT job_execution_log → v_maestro_id = LAST_INSERT_ID()
PASO 4: INSERT step log → v_step_id = LAST_INSERT_ID()
        CALL sp_etl_base_detalle() ← EXIT HANDLER puede activarse aquí
PASO 5: INSERT step log → v_step_id = LAST_INSERT_ID()  (si v_detalle_cargado)
        CALL sp_etl_base_clientes() ← EXIT HANDLER puede activarse aquí
PASO 6: CALL sp_etl_validar() ← EXIT HANDLER puede activarse aquí
```

Cuando PASO 4 falla: `v_quarter` ✓, `v_maestro_id` ✓, `v_step_id` ✓, `v_err_msg` ✓.  
Cuando PASO 5 falla: mismas variables ✓.  
Cuando PASO 6 falla: `v_quarter` ✓, `v_maestro_id` ✓ (v_step_id no es relevante para PASO 6).

### Verificación técnica del patrón

`DECLARE` dentro de un BEGIN block anidado dentro de un EXIT HANDLER es válido
en MariaDB 10.11.14 — verificado en motor real. El CONTINUE HANDLER declarado
en el bloque interno captura cualquier error del INSERT al log y permite que
la ejecución continúe con la lógica existente del handler.

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
    -- Bloque de log protegido: si falla el INSERT, no enmascara el error original
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO ivr_error_log (error_type, severity, sp_nombre,
            sql_state, p_quarter, error_message, job_log_id, ejecutado_por)
        VALUES (...);
    END;
    -- Lógica existente del handler: sin cambios
    UPDATE job_execution_log SET status='FAILED' WHERE id = v_step_id;
    UPDATE job_execution_log SET status='FAILED' WHERE id = v_maestro_id;
    SET v_detalle_cargado = FALSE;
END;
```

### Qué cambia exactamente por PASO

| PASO | `error_type` | `severity` | `error_message` en ivr_error_log | `job_log_id` |
|---|---|---|---|---|
| 4 | `ETL_FALLO` | `CRITICA` | `CONCAT('Falló etl_base_detalle: ', v_err_msg)` | `v_maestro_id` |
| 5 | `ETL_FALLO` | `CRITICA` | `CONCAT('Falló etl_base_clientes: ', v_err_msg)` | `v_maestro_id` |
| 6 | `ETL_PARTIAL` | `ALTA` | `CONCAT('Error en sp_etl_validar: ', v_err_msg)` | `v_maestro_id` |

El campo `job_log_id = v_maestro_id` vincula el error al registro maestro del
pipeline ETL. Django puede hacer `SELECT * FROM v_errores_recientes WHERE job_log_id = <id>`
para ver todos los errores de un job concreto.

### Riesgo de la modificación

Bajo. El CONTINUE HANDLER garantiza que si `ivr_error_log` está bloqueada o el
INSERT falla por cualquier razón, la lógica existente del handler sigue ejecutando.
El comportamiento observable desde Django no cambia: los mismos errores se siguen
propagando. Solo se agrega persistencia en `ivr_error_log`.

---

## P2 — Conectar `ivr_error_log` con los SIGNAL de los 7 SPs de reporte

**Objetos:** 7 SPs de reporte (todos en versión x.x.1 → x.x.2)  
**Schema:** no cambia

### Patrón verificado en motor real

```
Caso 'malo' → inner BEGIN (log simulado) → SIGNAL → ERROR 1644 (22023)
Caso 'bueno' → flujo normal, sin log ni error
```

El log ocurre, y después el SIGNAL se lanza igual. Django recibe el error
exactamente como antes. La única adición es el INSERT a `ivr_error_log`.

### Estructura de inserción por SP

Ambas validaciones (quarter y segmento) siguen el mismo patrón en cada SP:

```sql
IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO ivr_error_log (error_type, severity, sp_nombre,
            sql_state, mysql_errno, p_quarter, error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', '<nombre_sp>', '22023', 1644,
                p_quarter, CONCAT('p_quarter invalido: ', p_quarter), 'django_api');
    END;
    SIGNAL SQLSTATE '22023' SET MESSAGE_TEXT = '...';
END IF;
```

### Consideración: ¿el INSERT al log agrega latencia perceptible?

El SIGNAL activa una excepción inmediatamente. Antes de eso, el INSERT es una
escritura a `ivr_error_log` sobre un índice. En el camino de error (parámetro
inválido), la latencia adicional es el tiempo de un INSERT a una tabla local —
insignificante. El camino feliz (parámetro válido) no ejecuta el INSERT ni el SIGNAL.

### Consideración: `ejecutado_por = 'django_api'`

Todos los SPs de reporte son llamados exclusivamente por Django vía
`cursor.callproc()`. El valor estático `'django_api'` es correcto. Agregar un
parámetro adicional para el usuario específico sería una firma de SP más grande;
Django ya tiene esa información en su capa de autenticación.

---

## P3 — Window aggregate en `sp_rpt_cMENU_ERROR`

**Objeto:** `sp_rpt_cMENU_ERROR` v2.0.1 → v2.1.0  

### CORRECCIÓN al análisis anterior

El análisis previo (`ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md`) indicaba
`OVER(PARTITION BY b.segmento)` como reemplazo. Esto es **incorrecto** cuando
`p_segmento='todas'`. Verificación en motor real con Q01_25:

| Escenario | Subquery original | `OVER(PARTITION BY segmento)` | `OVER()` |
|---|---|---|---|
| `p_segmento='todas'` | **119** | 55 (nacional_A) / distinto por seg | **119** |
| `p_segmento='nacional_A'` | **55** | 55 | **55** |

**La subquery con `p_segmento='todas'` scannea todos los segmentos y devuelve el
grand total. `OVER(PARTITION BY segmento)` da el per-segment total — diferente
semántica. `OVER()` da el total de todas las filas visibles, que es exactamente
lo que devuelve la subquery en ambos escenarios.**

### Reemplazo correcto

```sql
-- INCORRECTO (análisis previo):
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento) AS total_anomalias_quarter

-- CORRECTO:
SUM(SUM(b.total_llamadas)) OVER () AS total_anomalias_quarter
```

### ¿Requiere tabla derivada?

No. `total_anomalias_quarter` es una columna de salida informacional — no se usa
como denominador dentro del mismo SELECT. No hay conflicto de alias.

### Impacto en el GROUP BY y ORDER BY

Ninguno. El `GROUP BY b.trimestre, b.segmento, b.menu, b.centro_transferencia`
y el `ORDER BY b.segmento, total_llamadas DESC` no cambian.

---

## P4 — Window aggregate en `sp_rpt_menu_centro`

**Objeto:** `sp_rpt_menu_centro` v2.0.1 → v2.1.0  

### Confirmación del reemplazo

```sql
-- Subconsulta actual (correlaciona por centro_transferencia):
(SELECT SUM(b2.total_llamadas) FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND b2.centro_transferencia = b.centro_transferencia
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento))

-- Reemplazo correcto:
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia)
```

Verificación con Q01_25, ambos escenarios:

| Escenario | Centro 10228051 subq | OVER(PARTITION BY centro) |
|---|---|---|
| `p_segmento='todas'` | 352 | 352 ✓ |
| `p_segmento='nacional_A'` | 154 | 154 ✓ |

Por qué `OVER(PARTITION BY centro)` es correcto en ambos casos: la subquery
correlaciona por `centro_transferencia` pero no por `segmento` — suma TODOS
los segmentos para ese centro cuando `p_segmento='todas'`. La window function
`OVER(PARTITION BY centro)` también suma todas las filas visibles del GROUP BY
para ese centro. Cuando `p_segmento='todas'` todas las filas son visibles →
equivalencia. Cuando `p_segmento='nacional_A'` solo filas de nacional_A son
visibles → también equivalencia.

### La window function se usa como denominador en el mismo SELECT

```sql
ROUND(
    SUM(b.total_llamadas)
    / NULLIF(
        SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia),
      0) * 100, 2
) AS pct_del_centro
```

Verificado: MariaDB 10.11.14 permite usar `SUM(SUM()) OVER()` directamente
como denominador en una expresión del mismo SELECT. El resultado es correcto.

---

## P5 — Window aggregate en `sp_rpt_clientes`

**Objeto:** `sp_rpt_clientes` v2.0.1 → v2.1.0 (prioridad BAJA)

El SP consulta `base_ivr_clientes` (3 filas fijas). La subquery devuelve la suma
total de clientes del quarter. El reemplazo es `SUM(c.clientes_unicos) OVER ()`.

Verificación Q01_25: `subq = OVER() = 83,068` ✓

No hay escenario de `p_segmento` — el SP solo recibe `p_quarter`. No hay ambigüedad.

---

## P6 — Window aggregates en `sp_rpt_menu_redirigidos`

**Objeto:** `sp_rpt_menu_redirigidos` v2.0.1 → v2.1.0  

### CORRECCIÓN al análisis anterior para subq1

El análisis previo indicaba `OVER(PARTITION BY b.segmento, b.menu)` para la
subconsulta 1. Esto es **incorrecto** cuando `p_segmento='todas'`.

Verificación con `SinOpcion_Cabecera` (presente en 3 segmentos, Q01_25):

| Escenario | Subquery original | `OVER(PARTITION BY seg,menu)` | `OVER(PARTITION BY menu)` |
|---|---|---|---|
| `p_segmento='todas'` | **3,942** | 1,698 (por seg) | **3,942** ✓ |
| `p_segmento='nacional_A'` | **1,698** | 1,698 | **1,698** ✓ |

**La subquery con `p_segmento='todas'` devuelve el total del menú M en TODOS los
segmentos. `OVER(PARTITION BY segmento, menu)` da el total del menú M dentro de
un segmento — semántica diferente. `OVER(PARTITION BY menu)` da el total del
menú M entre todos los segmentos visibles — correcto en ambos escenarios.**

### Reemplazos correctos para las 2 subconsultas

```sql
-- SUBCONSULTA 1 (pct_del_menu):
-- INCORRECTO (análisis previo):
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento, b.menu)
-- CORRECTO:
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.menu)

-- SUBCONSULTA 2 (pct_del_total):
-- CORRECTO (ya documentado):
SUM(SUM(b.total_llamadas)) OVER ()
```

### Por qué subq2 es `OVER()` y subq1 es `OVER(PARTITION BY menu)`

Subq2 calcula "total del scope completo" — el denominador del KPI total. Cuando
`p_segmento='todas'`, ese denominador es el grand total; cuando es un segmento
específico, es el total de ese segmento. `OVER()` captura exactamente las filas
visibles después del WHERE, que cambia según `p_segmento`. Correcto.

Subq1 calcula "total de ese menú en el scope" — el denominador del KPI por menú.
Cuando `p_segmento='todas'`, ese denominador es el total del menú en todos los
segmentos; cuando es un segmento específico, es el total del menú en ese segmento.
`OVER(PARTITION BY menu)` captura las filas de ese menú entre todos los visibles.
Correcto en ambos escenarios.

### Las dos window functions como denominadores en el mismo SELECT

Verificado en motor real — ambas expresiones funcionan simultáneamente:

```sql
ROUND(SUM(b.total_llamadas) / NULLIF(
    SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.menu), 0) * 100, 2) AS pct_del_menu,
ROUND(SUM(b.total_llamadas) / NULLIF(
    SUM(SUM(b.total_llamadas)) OVER (), 0) * 100, 4) AS pct_del_total
```

No se necesita tabla derivada. No hay conflicto de alias entre las dos expresiones.

---

## P7 — Vista `v_etl_rendimiento` con `LAG()`

**Objeto nuevo:** `v_etl_rendimiento` v1.0.0  
**Tablas involucradas:** `job_execution_log` (solo lectura)  
**Schema:** no cambia — es una VIEW

### Verificación técnica

La vista compila en MariaDB 10.11.14 sin errores. `LAG()` sobre `TIMESTAMPDIFF()`
opera sobre particiones de `(job_name, step_name)` ordenadas por `start_time`. La
primera ejecución de cada `(job_name, step_name)` devuelve `NULL` en `duracion_anterior_seg`
y `NULL` en `delta_seg` — comportamiento correcto para la primera ejecución.

### Consideración sobre el filtro `WHERE status='SUCCESS'`

El filtro `WHERE status = 'SUCCESS'` excluye ejecuciones FAILED y PARTIAL del
cálculo de LAG. Esto es intencional: comparar duraciones de ejecuciones exitosas
es la forma correcta de detectar regresiones de rendimiento. Una ejecución FAILED
interrumpe la secuencia antes de completar, lo que produciría duraciones artificialmente
cortas como `duracion_anterior_seg` y contaminaría el cálculo de `delta_seg`.

Si se quisiera incluir PARTIAL, se puede agregar `OR status='PARTIAL'` al WHERE.
La vista se define con SUCCESS — se puede cambiar si hay necesidad operacional.

### Dependencia con Django

Django puede consultar esta vista con una lectura directa:
```python
# No requiere cursor.callproc() — es una VIEW
rows = cursor.execute("SELECT * FROM v_etl_rendimiento ORDER BY start_time DESC LIMIT 20")
```

No hay cambio en los permisos existentes — `django_user` ya tiene SELECT sobre
`job_execution_log`, y las vistas heredan los permisos de las tablas base.

---

## P8 — `sp_rpt_resumen_abandono_rollup`

**Objeto nuevo:** `sp_rpt_resumen_abandono_rollup` v1.0.0  
**Tablas involucradas:** `base_ivr_detalle` (solo lectura)  
**Schema:** no cambia

### Por qué este SP no extiende `sp_rpt_llamadas_abandonadas`

`sp_rpt_llamadas_abandonadas` tiene dos particularidades que hacen complejo agregar
ROLLUP al SELECT existente:

1. Usa una tabla derivada (`FROM (...) t`) para calcular `pct_del_total` una sola vez.
   Agregar WITH ROLLUP dentro de la tabla derivada requiere una reestructuración
   no trivial.

2. Tiene `pct_del_segmento` calculada con una subconsulta correlacionada que usa el
   total del segmento como denominador (no modificable por diseño). En las filas de
   SUBTOTAL y TOTAL generadas por ROLLUP, ese denominador sería NULL (segmento=NULL),
   produciendo NULL/0 que es semánticamente incorrecto.

El SP de resumen ejecutivo es más simple intencionalmente: entrega solo
`abandonadas` y `pct_del_quarter`. No tiene `pct_del_segmento` ni `clasificacion_sla`
porque en los niveles de subtotal estos KPIs son ambiguos.

### Diseño del SP con variable `v_total`

```sql
DECLARE v_total BIGINT DEFAULT 0;
SELECT SUM(total_llamadas) INTO v_total
FROM base_ivr_detalle WHERE trimestre=p_quarter
  AND menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera');
```

Usar `v_total` como denominador en la división del ROLLUP SELECT evita la
subconsulta correlacionada — patrón idéntico al de `sp_rpt_llamadas_abandonadas`.
Verificado en motor real: el SP compila, devuelve los niveles de ROLLUP correctamente,
y la fila TOTAL muestra `pct_del_quarter = 100.00%`.

### El SP nuevo debe incluir P2 desde el inicio

Al ser un SP nuevo, se diseña directamente con la validación de parámetros
(SIGNAL) y el INSERT a `ivr_error_log` antes del SIGNAL. No requiere un paso
posterior de conexión.

### Permisos

El nuevo SP necesita GRANT EXECUTE para `django_user` y `etl_runs`. El script
`provision-mariadb.sh` genera automáticamente los GRANTs para cualquier objeto
nuevo si sigue la convención de nombre de archivo.

---

## P9 — `PERCENT_RANK` y `FIRST_VALUE` en `sp_rpt_centros_xsegmento`

**Objeto:** `sp_rpt_centros_xsegmento` v2.2.1 → v2.3.0  

### Verificación de sintaxis en el contexto del SP existente

Verificado con Q01_25:
```
segmento   centro    total  ranking  percentil  pct_del_lider
nacional_A 10728487  5,493    1       1.0000      100.0%
nacional_A 19020086  5,084    2       0.9630       92.6%
nacional_A 10828091  4,803    3       0.9259       87.4%
```

Ambas funciones operan sobre el resultado del CTE existente (`centros_calendario`).
El SP ya tiene un SELECT con `DENSE_RANK` — agregar `PERCENT_RANK` y `FIRST_VALUE`
es añadir dos columnas al mismo SELECT, no una reestructuración.

### Consideración: `PERCENT_RANK` con ORDER BY ASC

El SP usa `ORDER BY cc.total_llamadas DESC` para `DENSE_RANK`. Para `PERCENT_RANK`
con semántica "0=menos activo, 1=más activo", el ORDER BY debe ser ASC:

```sql
ROUND(PERCENT_RANK() OVER (
    PARTITION BY cc.segmento
    ORDER BY cc.total_llamadas    -- ASC implícito
), 4) AS percentil_actividad
```

Esto no conflicta con `DENSE_RANK() OVER (... ORDER BY DESC)` — cada window
function tiene su propia especificación de orden. Verificado en el mismo SELECT.

### `FIRST_VALUE` requiere un frame explícito en MariaDB

MariaDB 10.11.14 requiere que `FIRST_VALUE` tenga un frame window explícito o
use el comportamiento por defecto. En la mayoría de los casos, el valor por
defecto es suficiente:

```sql
ROUND(cc.total_llamadas / FIRST_VALUE(cc.total_llamadas) OVER (
    PARTITION BY cc.segmento
    ORDER BY cc.total_llamadas DESC
) * 100, 1) AS pct_del_lider
```

Verificado en motor real — funciona sin frame explícito y produce el resultado
correcto (100.0% para el líder, 87.4% para el segundo, etc.).

---

## P10 — `NTILE(4)` en `sp_rpt_centros_transferencia`

**Objeto:** `sp_rpt_centros_transferencia` v2.1.1 → v2.2.0  

### Consideración de diseño

El SP actual hace JOIN con una tabla derivada pre-agregada. `NTILE(4)` debe
operar sobre el total agregado por centro — no sobre filas individuales. La
estructura correcta:

```sql
NTILE(4) OVER (
    PARTITION BY b.trimestre, b.segmento
    ORDER BY SUM(b.total_llamadas) DESC
) AS cuartil_centro
```

`SUM(b.total_llamadas)` dentro de NTILE es válido porque la window function
opera después del GROUP BY. El `SUM` es el valor agrupado del GROUP BY externo.

Verificado: los primeros 7 centros de nacional_A (los de mayor volumen) quedan
en cuartil 1; el centro 8 (con 1,423 llamadas) cae a cuartil 2.

### Advertencia sobre NTILE con pocos centros

`NTILE(N)` divide en N grupos iguales. Si hay menos de N centros en una partición,
MariaDB asigna correctamente cuartiles 1..K donde K = número de centros. Con
28 centros en los datos de ejemplo: 7 en Q1, 7 en Q2, 7 en Q3, 7 en Q4.
En producción con 100 centros: 25 por cuartil. El comportamiento es correcto en ambos casos.

---

## Tabla de correcciones al análisis anterior

| Documento anterior | Propuesta original | Corrección confirmada en motor |
|---|---|---|
| `ANALISIS-CANDIDATOS-WF` D-1 | `OVER(PARTITION BY segmento)` | **`OVER()`** — subq=119, OVER(seg)=55, OVER()=119 con p_segmento='todas' |
| `ANALISIS-CANDIDATOS-WF` D-4 subq1 | `OVER(PARTITION BY segmento, menu)` | **`OVER(PARTITION BY menu)`** — subq=3942, OVER(seg,menu)=1698, OVER(menu)=3942 con p_segmento='todas' |
| `ANALISIS-CANDIDATOS-WF` D-2 | `OVER(PARTITION BY centro)` | Confirmado correcto — subq=352, wf=352 en ambos escenarios |
| `ANALISIS-CANDIDATOS-WF` D-4 subq2 | `OVER()` | Confirmado correcto |
| `ANALISIS-CANDIDATOS-WF` D-3 | `OVER()` | Confirmado correcto — 3 filas, sin segmentación cruzada |

---

## Consideraciones de despliegue

### Orden de despliegue dentro de un mismo sprint

P1 y P2 son independientes entre sí pero no tienen dependencias externas — pueden
desplegarse en cualquier orden. `ivr_error_log` ya existe.

P3-P6 son modificaciones de SPs de solo lectura. Ningún SP de reporte depende de
otro SP de reporte. Pueden desplegarse en paralelo.

P7 es una VIEW — su despliegue no puede fallar en tiempo de ejecución (los datos
pueden no estar todavía, pero la CREATE OR REPLACE VIEW es DDL atómica).

P8 es un SP nuevo. Debe desplegarse después de P2 para que ya incluya el INSERT
a `ivr_error_log` desde su primera versión.

P9 y P10 modifican SPs de lectura — sin riesgo de regresión en datos ETL.

### verify.sh

Todos los pendientes mantienen la firma visible de los objetos (`CREATE OR REPLACE`
en lugar de `DROP + CREATE`). El deploy es atómico. verify.sh verifica 27 checks
actualmente — ningún pendiente modifica los checks existentes.

P7 y P8 agregan 2 objetos nuevos. Si provision-mariadb.sh y verify.sh cuentan
el número de objetos, necesitarán actualización. El check actual es
"20 objetos aplicados" — con P7 y P8 serían 22.

### Grants

`ivr_error_log` requiere permiso INSERT para `etl_runs` (que ejecuta sp_etl_maestro
via evt_etl_diario) y para `django_user` (que ejecuta los SPs de reporte).
`provision-mariadb.sh` aplica los grants automáticamente basándose en la presencia
de los archivos SQL. El schema_error_log.sql ya existe en el repositorio —
los grants se necesitan actualizar manualmente o via script.

El SP nuevo `sp_rpt_resumen_abandono_rollup` necesita EXECUTE para `django_user`.
