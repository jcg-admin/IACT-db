# Hallazgos — Análisis comparativo SQL Server vs IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Fuente de referencia:** `FUNC_ADD_DIAS_HABILES_TABLA.sql`, `FUNC_REPORTE_COBRANZA.sql`, `SP_REPORTE_INDICADORES.sql`  
**Dominio analizado:** `provisioners/mariadb/funciones_utilidad.sql`, `sp_rpt_reportes.sql`, `sp_etl_pipeline.sql`

---

## Marco de comparación

Los tres archivos de referencia son T-SQL de SQL Server del sistema de microfinanzas CRECIENDO (2008-2018). El motor, el dialecto y algunos patrones son distintos a MariaDB 10.11. Antes de trasladar cualquier hallazgo al dominio IACT-db es necesario determinar si aplica, si aplica parcialmente, o si no aplica por diferencia de motor.

---

## Tabla de aplicabilidad — hallazgo por hallazgo

| Hallazgo SQL Server | Aplica a IACT-db | Motivo |
|---|---|---|
| WHILE loop sin fórmula matemática | **Sí, directamente** | `ivr_contar_dias_semana` e `ivr_agregar_dias_semana` usan WHILE |
| Subconsulta dentro del WHILE | **No** | Nuestros WHILE solo llaman `DAYOFWEEK()` — sin acceso a tabla |
| Dependencia de locale en `DATENAME` | **No** | Usamos `DAYOFWEEK()` — independiente de idioma del servidor |
| Multi-statement TVF vs inline TVF | **No aplica** | MariaDB no tiene table-valued functions |
| Funciones escalares por fila en SELECT | **Sí, directamente** | `sp_rpt_centros_xsegmento` llama 8 funciones WHILE por fila de resultado |
| Subconsultas correlacionadas por fila | **Sí, con matices** | Todos los SPs RPT las tienen; el impacto varía según cardinalidad |
| Código triplicado con IF @FORM | **No** | Nuestros SPs tienen parámetros directos, sin ramificación por @FORM |
| CURSOR fila por fila | **No** | No usamos cursores |
| Variables no reinicializadas entre iteraciones | **No aplica** | Sin cursores; aplica solo al WHILE del ETL mensual (ver H-IACT-004) |
| Sin transacción en operaciones de escritura | **Sí, parcialmente** | `sp_etl_base_detalle` hace DELETE + INSERT sin `START TRANSACTION` |
| Funciones escalares dentro de SUM/AVG | **No** | No invocamos funciones en `SUM()` en los SPs actuales |
| Subquery constante repetida N veces | **No** | No tenemos el patrón `SET @x = @x / (SELECT COUNT ...)` repetido |
| Bug de campo equivocado (PATERNO vs MATERNO) | **Investigado — sin equivalente** | Nuestros campos usan nombres correctos |
| ORDER BY inútil dentro de INSERT a tabla var. | **No aplica** | MariaDB no tiene variables de tabla de ese tipo |
| Sin manejo de errores TRY/CATCH | **Parcialmente** | Tenemos EXIT HANDLER pero hay un gap en el flujo de PASO 4→5 |
| PREPARE fuera del WHILE | **Sí, menor** | El PREPARE está dentro del WHILE en lugar de fuera |

---

## H-IACT-001 — WHILE O(n) en `ivr_contar_dias_semana` e `ivr_agregar_dias_semana`

**Severidad:** MEDIA-ALTA — se multiplica por el número de centros en `sp_rpt_centros_xsegmento`  
**Paralelo con SQL Server:** `FUNC_ADD_DIAS_HABILES_TABLA` — mismo patrón WHILE día a día

### Descripción

`ivr_contar_dias_semana` itera día a día desde `p_ini` hasta `p_fin`, llamando `ivr_es_dia_semana` en cada iteración. Para un quarter de 90 días, ejecuta 90 iteraciones. `ivr_agregar_dias_semana` avanza de a un día hasta acumular `p_n` días hábiles.

El problema se multiplica en `sp_rpt_centros_xsegmento`, que llama estas funciones por cada fila del resultado del GROUP BY:

```sql
-- Por cada centro × segmento:
ivr_contar_dias_semana(primera_actividad, ultima_actividad)    -- ~90 iteraciones
ivr_contar_dias_semana(ultima_actividad,  CURDATE())           -- ~30 iteraciones
ivr_contar_dias_semana(ultima_actividad,  CURDATE())  -- en CASE (×3 ramas)
ivr_agregar_dias_semana(ultima_actividad, 1)                   -- ~1.4 iteraciones
ivr_agregar_dias_semana(ultima_actividad, 3)                   -- ~4.2 iteraciones
ivr_agregar_dias_semana(ultima_actividad, 5)                   -- ~7 iteraciones
```

Con 300 filas de resultado (100 centros × 3 segmentos), el SP ejecuta aproximadamente **108,000 iteraciones de WHILE** por llamada.

### Diferencia clave con SQL Server

En `FUNC_ADD_DIAS_HABILES_TABLA`, cada iteración del WHILE ejecuta también una subconsulta sobre `C_DIAS_FESTIVOS` (catálogo de festivos). Nuestro WHILE solo llama `DAYOFWEEK()` — una función nativa sin acceso a tabla. El costo por iteración es mucho menor que en el caso SQL Server, pero el volumen de iteraciones lo compensa.

### Corrección propuesta

Reemplazar el WHILE con fórmula matemática O(1) para `ivr_contar_dias_semana`:

```sql
-- Fórmula O(1) para contar días lunes-viernes entre dos fechas:
-- 1. Calcular semanas completas y días sobrantes
-- 2. Ajustar según el día de la semana de inicio y fin
SET v_dias_totales = DATEDIFF(p_fin, p_ini);
SET v_semanas      = FLOOR(v_dias_totales / 7);
SET v_resto        = v_dias_totales MOD 7;
-- Días de la semana de inicio y fin (1=Dom, 2=Lun...7=Sab)
SET v_dow_ini      = DAYOFWEEK(p_ini);
SET v_dow_fin      = DAYOFWEEK(p_fin);
-- Contar días hábiles en el resto mediante tabla de lookup
RETURN v_semanas * 5 + <lookup_dias_habiles_en_resto>;
```

La implementación completa requiere un pequeño array de corrección según el día de inicio — consultar ADR antes de implementar.

---

## H-IACT-002 — Funciones WHILE por fila en `sp_rpt_centros_xsegmento`

**Severidad:** ALTA — es el SP más costoso del sistema de reportes  
**Paralelo con SQL Server:** `FUNC_REPORTE_COBRANZA` con 4 funciones escalares por fila; `SP_REPORTE_INDICADORES` con `SUM(FUNC_FACTOR_CAPITAL(...))` sobre miles de pagos

### Descripción

`sp_rpt_centros_xsegmento` llama 8 funciones WHILE en el SELECT principal por cada fila del GROUP BY. A diferencia del caso SQL Server — donde las funciones escalares dentro de `SUM()` ejecutaban en cada fila de la tabla fuente — aquí las funciones ejecutan por cada fila del resultado agregado. El problema está acotado por la cardinalidad del resultado, no de la tabla fuente.

Sin embargo, la diferencia con el caso SQL Server no elimina el problema: si el resultado tiene 300 filas y cada función ejecuta ~45 iteraciones de WHILE, el SP genera ~108,000 llamadas a `DAYOFWEEK()`.

### Corrección propuesta — dos niveles

**Nivel 1 (inmediato):** Pre-calcular los valores de calendario en una tabla temporal o CTE dentro del SP, de modo que las funciones se llamen una vez por centro, no una vez por centro × WHEN del CASE:

```sql
-- En lugar de llamar ivr_contar_dias_semana 5 veces por fila (3 en CASE + 2 en columnas),
-- calcular una vez en una subconsulta derivada:
WITH centros_base AS (
    SELECT
        trimestre, segmento, centro_transferencia,
        STR_TO_DATE(CONCAT(MIN(fecha), '01'), '%Y%m%d') AS primera_act,
        LAST_DAY(STR_TO_DATE(CONCAT(MAX(fecha), '01'), '%Y%m%d')) AS ultima_act,
        SUM(total_llamadas) AS total_llamadas,
        ...
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter AND ...
    GROUP BY trimestre, segmento, centro_transferencia
)
SELECT
    ...,
    ivr_contar_dias_semana(primera_act, ultima_act) AS dias_semana_periodo,
    ivr_contar_dias_semana(ultima_act, CURDATE())   AS dias_semana_sin_actividad,
    ...
FROM centros_base;
```

Esto elimina las 3 llamadas redundantes en el CASE sin cambiar la lógica.

**Nivel 2 (definitivo):** Implementar H-IACT-001 (fórmula O(1)) y el problema desaparece por completo.

---

## H-IACT-003 — Subconsultas correlacionadas en SPs de reporte: impacto diferenciado

**Severidad:** Variable — de MUY BAJA a MEDIA según el SP  
**Paralelo con SQL Server:** `FUNC_REPORTE_COBRANZA` con 7 subconsultas correlacionadas por fila sobre `BD_PAGOS`

### Descripción

Todos los SPs de reporte tienen al menos una subconsulta correlacionada en el SELECT para calcular porcentajes. A diferencia del caso SQL Server — donde las subconsultas accedían a tablas de transacciones con millones de filas — las nuestras leen `base_ivr_detalle` (tabla analítica de ~16,500 filas).

El impacto real por SP:

| SP | Subconsultas correlacionadas | Filas del resultado | Ejecuciones de subconsulta | Impacto |
|---|---|---|---|---|
| `sp_rpt_clientes` | 1 | 3 | 3 | MUY BAJO |
| `sp_rpt_llamadas_abandonadas` | 1 | ~9 | 9 | MUY BAJO |
| `sp_rpt_cMENU_ERROR` | 1 (sin correlación fuerte) | ~20 | 20 | BAJO |
| `sp_rpt_menu_redirigidos` | 2 | ~50 | 100 | BAJO |
| `sp_rpt_menu_centro` | 1 | ~150 | 150 | BAJO |
| `sp_rpt_centros_transferencia` | 1 | ~1,000 | ~3,000 | MEDIO |
| `sp_rpt_centros_xsegmento` | 1 + 8 fn_WHILE | ~300 | ver H-IACT-002 | ALTO |

### Por qué no copiamos el anti-patrón SQL Server

En `FUNC_REPORTE_COBRANZA`, las 7 subconsultas correlacionadas ejecutan sobre `BD_PAGOS` — una tabla de transacciones con potencialmente millones de filas — una vez por cada préstamo activo. Eso producía miles de lecturas secuenciales.

En nuestro caso, `base_ivr_detalle` es una tabla analítica pre-agregada. La subconsulta de porcentaje en `sp_rpt_centros_transferencia` lee la misma tabla con el mismo filtro de `trimestre` que la consulta exterior — MariaDB puede reusar los resultados del buffer pool. El costo real es aceptable para el volumen actual.

### Corrección propuesta — solo para `sp_rpt_centros_transferencia`

Este es el único SP donde el impacto puede crecer con el volumen. La corrección es un JOIN con subconsulta pre-agregada:

```sql
-- Antes: subconsulta correlacionada por cada fila
/ NULLIF((SELECT SUM(b2.total_llamadas)
          FROM base_ivr_detalle b2
          WHERE b2.trimestre = p_quarter AND b2.fecha = b.fecha
            AND b2.segmento  = b.segmento ...), 0)

-- Después: JOIN con totales pre-calculados
LEFT JOIN (
    SELECT trimestre, fecha, segmento, SUM(total_llamadas) AS total_mes_seg
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
    GROUP BY trimestre, fecha, segmento
) totales ON totales.trimestre = b.trimestre
         AND totales.fecha     = b.fecha
         AND totales.segmento  = b.segmento
...
/ NULLIF(totales.total_mes_seg, 0)
```

Un solo scan de `base_ivr_detalle` en lugar de un scan por grupo.

---

## H-IACT-004 — `sp_etl_base_detalle`: DELETE + INSERT sin transacción explícita

**Severidad:** BAJA — la idempotencia mitiga el riesgo  
**Paralelo con SQL Server:** `SP_REPORTE_INDICADORES` sin TRY/CATCH ni transacción alrededor del cursor

### Descripción

El WHILE mensual de `sp_etl_base_detalle` ejecuta para cada mes:

```sql
DELETE FROM base_ivr_detalle WHERE trimestre = p_quarter AND fecha = YYYYMM;
PREPARE etl_stmt FROM @sql;
EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
```

No hay `START TRANSACTION` ni `ROLLBACK` envolviendo el par DELETE + INSERT. Si el INSERT del mes 3 falla (por timeout, lock, etc.), los datos del mes 3 quedan eliminados y sin reemplazar hasta la próxima ejecución.

### Por qué el riesgo está mitigado

La función es idempotente: el DELETE precede a cada INSERT. La siguiente ejecución del ETL borrará y volverá a insertar el mes 3 correctamente. La ventana de inconsistencia es el tiempo entre el fallo y la próxima ejecución programada (máximo 24 horas con el event diario).

### Por qué no es igual al caso SQL Server

En `SP_REPORTE_INDICADORES`, el fallo a mitad del cursor dejaba datos parciales en `BD_REPORTE_INDICADORES` con algunos meses con datos y otros sin borrar — sin mecanismo de recuperación automática. En nuestro caso, el ETL tiene la garantía de idempotencia por diseño.

### Corrección propuesta (opcional)

Agregar `START TRANSACTION` / `COMMIT` dentro del bloque de cada mes — no alrededor de todo el WHILE — para garantizar atomicidad mensual sin afectar el rendimiento:

```sql
WHILE v_mes_ini <= p_fin DO
    START TRANSACTION;
    DELETE FROM base_ivr_detalle WHERE trimestre = @etl_q AND fecha = DATE_FORMAT(v_mes_ini, '%Y%m');
    EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
    COMMIT;
    ...
END WHILE;
```

---

## H-IACT-005 — `sp_etl_maestro`: PASO 5 continúa cuando PASO 4 falla

**Severidad:** BAJA-MEDIA — produce estado inconsistente entre `base_ivr_detalle` y `base_ivr_clientes`  
**Paralelo con SQL Server:** Variables de cursor en `SP_REPORTE_INDICADORES` que no se reinicializan entre iteraciones

### Descripción

El EXIT HANDLER del PASO 4 marca el registro maestro en `job_execution_log` como `FAILED` y sale del bloque `BEGIN...END` interno. Sin embargo, el código externo de `sp_etl_maestro` continúa hacia PASO 5 (`sp_etl_base_clientes`) sin verificar si PASO 4 tuvo éxito.

Consecuencia: `base_ivr_clientes` puede contener datos del quarter aunque `base_ivr_detalle` esté vacía o incompleta para ese mismo quarter. Los SPs de reporte leerían datos inconsistentes si se invocaran en esa ventana.

El comentario en el handler dice:

```sql
-- No LEAVE: el handler termina y el bloque externo continua
-- v_ok quedara NULL, el UPDATE final marcara PARTIAL
```

Esto indica que el comportamiento es intencional: ambos pasos se intentan para recolectar información de diagnóstico. El status final `PARTIAL` en `job_execution_log` es la señal de que los datos no son confiables.

### Estado actual vs. corrección propuesta

El diseño actual es aceptable si los consumidores (Django REST Framework) verifican el status antes de usar los datos. Si los endpoints de reporte no validan que el último run tenga status `SUCCESS`, el riesgo se materializa.

**Corrección mínima:** Agregar un flag que PASO 5 verifique antes de ejecutar:

```sql
-- En el EXIT HANDLER del PASO 4:
SET v_paso4_failed = TRUE;

-- En PASO 5 (antes del BEGIN del handler):
IF NOT v_paso4_failed THEN
    -- ... ejecutar sp_etl_base_clientes
END IF;
```

---

## H-IACT-006 — PREPARE dentro del WHILE en `sp_etl_base_detalle`

**Severidad:** MUY BAJA — impacto práctico negligible  
**Paralelo con SQL Server:** No tiene paralelo directo

### Descripción

El `PREPARE etl_stmt FROM @sql` está dentro del WHILE mensual. El statement se prepara y se deallocate en cada iteración (3 veces por quarter). La práctica correcta es preparar una vez fuera del WHILE y ejecutar N veces.

```sql
-- Actual (dentro del WHILE):
WHILE v_mes_ini <= p_fin DO
    PREPARE etl_stmt FROM @sql;
    EXECUTE etl_stmt USING ...;
    DEALLOCATE PREPARE etl_stmt;
    ...
END WHILE;

-- Correcto (preparar fuera):
PREPARE etl_stmt FROM @sql;
WHILE v_mes_ini <= p_fin DO
    EXECUTE etl_stmt USING ...;
    ...
END WHILE;
DEALLOCATE PREPARE etl_stmt;
```

Con N=3 por quarter, el costo adicional de 2 PREPARE extra es negligible. Se documenta como deuda técnica menor.

---

## Hallazgos que NO aplican a IACT-db — justificación explícita

### Dependencia de locale

`FUNC_ADD_DIAS_HABILES_TABLA` usa `DATENAME(WEEKDAY, ...)` comparando con strings en español. Si el servidor corre en inglés, la función falla silenciosamente. Nuestras funciones usan `DAYOFWEEK()` de MariaDB, que retorna enteros (1=Domingo, 7=Sábado) sin importar el idioma del servidor o la sesión.

### Multi-statement TVF

SQL Server distingue entre multi-statement TVF (caja negra para el optimizador) e inline TVF (expandible). MariaDB no tiene table-valued functions — sus funciones almacenadas siempre retornan escalares o conjuntos de resultado sin el problema de cardinalidad mal estimada.

### CURSOR fila a fila

`SP_REPORTE_INDICADORES` itera con cursor sobre sucursales, ejecutando ~15 SELECTs por sucursal. IACT-db no usa cursores. Los SPs ETL procesan por mes con WHILE pero cada iteración es un INSERT masivo orientado a conjuntos, no una operación fila por fila.

### Triplicación de código con IF @FORM

`FUNC_REPORTE_COBRANZA` repite el mismo SELECT tres veces con `IF @FORM = 1/2/3`. Nuestros SPs de reporte reciben los parámetros directamente (`p_quarter`, `p_segmento`) sin ramificación de this kind. El comentario en `sp_rpt_reportes.sql` documenta explícitamente que se usó un solo SELECT para evitar esa duplicación.

### Funciones escalares dentro de SUM() sobre tablas de transacciones

`SP_REPORTE_INDICADORES` llama `SUM(FUNC_FACTOR_CAPITAL(BD_PRESTAMO.ID_PRESTAMO))` sobre todas las filas del JOIN entre préstamos y pagos — potencialmente millones de invocaciones. IACT-db no invoca funciones almacenadas dentro de `SUM()`. Las funciones de calendario se llaman en el SELECT del resultado agregado (después del GROUP BY), no en la tabla fuente.

---

## Plan de acción por severidad

| Hallazgo | Severidad | Acción | Estimación |
|---|---|---|---|
| H-IACT-001: WHILE O(n) en funciones calendario | MEDIA-ALTA | Reemplazar con fórmula O(1) — requiere ADR | ADR + implementación |
| H-IACT-002: 8 llamadas fn_WHILE por fila en sp_rpt_centros_xsegmento | ALTA | Nivel 1: CTE para eliminar llamadas redundantes del CASE. Nivel 2: depende de H-IACT-001 | Nivel 1 inmediato |
| H-IACT-003: Subconsulta correlacionada en sp_rpt_centros_transferencia | MEDIA | JOIN con subconsulta pre-agregada | Una iteración |
| H-IACT-004: DELETE + INSERT sin transacción | BAJA | Opcional — agregar TX por mes | Bajo riesgo actual |
| H-IACT-005: PASO 5 continúa cuando PASO 4 falla | BAJA-MEDIA | Flag `v_paso4_failed` + validación en Django | Dos puntos de cambio |
| H-IACT-006: PREPARE dentro del WHILE | MUY BAJA | Mover PREPARE fuera del WHILE | Una línea de cambio |

---

## Conclusión del análisis comparativo

El patrón más dañino del SQL Server — funciones escalares dentro de `SUM()` sobre tablas de transacciones y CURSORs fila a fila — no existe en IACT-db. El diseño orientado a conjuntos del ETL es correcto.

El problema real en IACT-db es más sutil: las funciones WHILE son correctas en aislamiento, pero se convierten en un problema cuando `sp_rpt_centros_xsegmento` las invoca 8 veces por cada fila del resultado. La corrección de nivel 1 (CTE para eliminar llamadas redundantes del CASE) puede aplicarse sin cambiar las funciones. La corrección definitiva (fórmula O(1)) elimina el problema de raíz y debe priorizarse cuando el volumen de centros escale.
