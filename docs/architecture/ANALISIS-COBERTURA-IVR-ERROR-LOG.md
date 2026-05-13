# Análisis — Cobertura de `ivr_error_log`: SPs, ENUM y diseño de tabla

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Pregunta:** ¿`ivr_error_log` debe asociarse a más SPs? ¿Es correcta una sola tabla?
¿El ENUM está bien diseñado?

---

## Mapa completo: qué error genera qué SP y si llega a `ivr_error_log`

| SP | Camino de error | `error_type` correcto | Estado actual |
|---|---|---|---|
| `sp_etl_maestro` | PASO 4 falla (`etl_base_detalle` lanza RESIGNAL) | `ETL_FALLO` | Planeado T1.2 |
| `sp_etl_maestro` | PASO 5 falla (`etl_base_clientes` lanza RESIGNAL) | `ETL_FALLO` | Planeado T1.2 |
| `sp_etl_maestro` | PASO 6 falla (`sp_etl_validar` lanza excepción) | `ETL_PARTIAL` | Planeado T1.2 |
| `sp_etl_maestro` | **PASO 7: `v_ok=FALSE` (validación de negocio)** | **`VALIDACION`** | **GAP** |
| `sp_etl_validar` | EXIT HANDLER (fallo de infraestructura) | delegado al caller | Delegado ✓ |
| `sp_etl_validar` | **`v_ok=FALSE` (checks 1-5 fallan, sin excepción)** | **`VALIDACION`** | **GAP vía PASO 7** |
| `sp_etl_historico` | **SIGNAL: `p_quarter_num NOT IN (1,2,3,4)`** | **`PARAM_INVALIDO`** | **GAP** |
| `sp_etl_historico` | **`sp_etl_base_detalle` falla → RESIGNAL sin handler** | **`ETL_FALLO`** | **GAP** |
| `sp_etl_historico` | **`sp_etl_validar` retorna `v_ok=FALSE`** | **`VALIDACION`** | **GAP** |
| `sp_etl_base_detalle` | EXIT HANDLER → ROLLBACK + RESIGNAL | delegado al caller | Delegado ✓ |
| `sp_etl_base_clientes` | SIGNAL: `p_table` NULL/vacío | delegado al caller | Delegado ✓ |
| 7 SPs de reporte | SIGNAL: `p_quarter` o `p_segmento` inválido | `PARAM_INVALIDO` | Planeado T1.3 |

---

## Los SPs que delegan correctamente

`sp_etl_base_detalle` y `sp_etl_base_clientes` no deben logear a `ivr_error_log`
directamente. Ambos son SPs internos invocados solo por `sp_etl_maestro` y
`sp_etl_historico`. El patrón correcto es:

```
sp_etl_base_detalle falla
    → ROLLBACK + RESIGNAL hacia el caller
    → caller tiene EXIT HANDLER (sp_etl_maestro tiene, sp_etl_historico NO tiene)
    → el caller registra el error en ivr_error_log con el contexto del pipeline completo
```

Si `sp_etl_base_detalle` logeara directamente, habría dos entradas para el mismo error
(una desde el SP interno con contexto parcial, otra desde el caller con contexto completo).
La delegación es el diseño correcto.

---

## GAP 1 — PASO 7 de `sp_etl_maestro`: `VALIDACION` nunca llega a `ivr_error_log`

### Qué ocurre hoy

`sp_etl_validar` tiene 5 checks de integridad de datos. Cuando alguno falla (sin
excepción — es lógica de negocio), retorna `p_ok=FALSE` y `p_mensaje` con la
descripción del problema. Por ejemplo:

```
"ERROR: base_ivr_clientes tiene 2 filas (esperado: 3) para Q02_26.
 ERROR: 1 segmento(s) en detalle sin entrada en clientes (EXCEPT)."
```

`sp_etl_maestro` PASO 7 recibe ese resultado y actualiza `job_execution_log` como PARTIAL:

```sql
UPDATE job_execution_log
SET status = 'PARTIAL', error_message = v_msg
WHERE id = v_maestro_id;
```

Pero `ivr_error_log` no recibe nada. El error_type `VALIDACION` existe en el ENUM
pero **nunca se usa**. Para encontrar el problema hay que buscar en `job_execution_log`
con `status='PARTIAL'`. `ivr_error_log` no sería el lugar correcto para buscarlo.

### Por qué es importante

`ivr_error_log` es la tabla de auditoría centralizada. Un operador que consulta
`SELECT * FROM v_errores_recientes` no vería los fallos de validación de datos,
solo los fallos técnicos. Los fallos de validación son los más informativos para
diagnosticar problemas de calidad del ETL.

### Corrección

En `sp_etl_maestro` PASO 7, cuando `v_ok=FALSE`:

```sql
ELSE
    -- Cuando v_ok=FALSE: registrar en ivr_error_log como VALIDACION
    IF NOT COALESCE(v_ok, FALSE) THEN
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO ivr_error_log
                (error_type, severity, sp_nombre,
                 p_quarter, error_message, job_log_id, ejecutado_por)
            VALUES
                ('VALIDACION', 'ALTA', 'sp_etl_validar',
                 v_quarter, v_msg, v_maestro_id, 'evt_etl_diario');
        END;
    END IF;
    UPDATE job_execution_log
    SET status        = IF(COALESCE(v_ok, FALSE), 'SUCCESS', 'PARTIAL'),
        ...
```

**El sp_nombre es `'sp_etl_validar'`** (no `'sp_etl_maestro'`) porque el problema
fue detectado por sp_etl_validar, aunque el INSERT lo hace sp_etl_maestro.

**Impacto en el plan:** T1.2 debe extenderse para incluir este INSERT en PASO 7.
La versión de `sp_etl_maestro` sigue siendo v2.5.0 (ya incluida en T1.2) —
este es parte de la misma tarea.

---

## GAP 2 — `sp_etl_historico` sin cobertura de errores

`sp_etl_historico` es el SP de carga histórica manual. A diferencia de
`sp_etl_maestro` (que es orquestador con 3 EXIT HANDLERs), `sp_etl_historico`
no tiene ningún EXIT HANDLER. Los problemas que genera:

### 2a — SIGNAL de validación no llega a `ivr_error_log`

```sql
IF p_quarter_num NOT IN (1, 2, 3, 4) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '...';
END IF;
```

Si Django llama con `p_quarter_num=5`, el SIGNAL llega al cliente sin log.
Igual que los 7 SPs de reporte antes de T1.3.

### 2b — Fallo de `sp_etl_base_detalle` deja `job_execution_log` en RUNNING

Cuando `sp_etl_base_detalle` falla desde `sp_etl_historico`:
- `sp_etl_base_detalle` hace ROLLBACK + RESIGNAL
- RESIGNAL propaga a `sp_etl_historico`
- `sp_etl_historico` NO tiene EXIT HANDLER
- La excepción va a Django
- `job_execution_log` tiene `status='RUNNING'` para ese step indefinidamente

### 2c — `v_ok=FALSE` de `sp_etl_validar` no llega a `ivr_error_log`

`sp_etl_historico` llama a `sp_etl_validar` y hace:
```sql
CALL sp_etl_validar(v_quarter, v_ok, v_msg);
SELECT v_quarter AS quarter_procesado, v_ok AS ok, v_msg AS resultado;
```

Si `v_ok=FALSE`, el resultado solo va al SELECT de salida hacia Django. No hay
registro persistente en `ivr_error_log` ni actualización de `job_execution_log`
con el mensaje de error.

### Corrección

`sp_etl_historico` necesita los mismos patrones que los otros SPs:

1. INSERT a `ivr_error_log` antes del SIGNAL (mismo patrón que T1.3)
2. EXIT HANDLERs para los CALL a `sp_etl_base_detalle` y `sp_etl_base_clientes`
   que actualicen `job_execution_log` como FAILED y registren en `ivr_error_log`
3. INSERT a `ivr_error_log` cuando `v_ok=FALSE` (mismo patrón que GAP 1)

**Impacto en el plan:** nueva tarea T1.4 `sp_etl_historico` v2.1.0 en FASE 1.

---

## Decisión: ¿una tabla o varias?

La pregunta es si se necesita una tabla separada para errores ETL vs errores de
reporte, o si `ivr_error_log` es suficiente para todos.

### Argumento para múltiples tablas

Podría argumentarse que los errores ETL tienen un contexto diferente (job_log_id,
v_quarter del pipeline, step name) respecto a los errores de reporte (p_quarter del
parámetro de consulta, p_segmento). Tablas separadas podrían tener esquemas
optimizados para cada contexto.

### Por qué una sola tabla es la decisión correcta

**Volumen:** en producción, los errores ETL son rarísimos (el ETL corre una vez al día).
Los errores de reporte ocurren cuando un cliente API envía parámetros inválidos.
Ambos juntos producen decenas de filas por semana — no miles. No hay justificación
de rendimiento para particionar.

**Consultas:** el caso de uso principal es "¿qué errores hubo en las últimas 48 horas?"
Con una sola tabla: `SELECT * FROM v_errores_recientes`. Con dos tablas: necesita
UNION o dos queries desde Django. Más complejo sin beneficio real.

**INSERT desde handlers:** el patrón `DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END`
dentro del EXIT HANDLER ya protege el INSERT. No hay razón técnica para separar las tablas.

**El campo `job_log_id` como FK nullable** ya resuelve la diferenciación: errores ETL
tienen `job_log_id` con valor; errores de reporte tienen `job_log_id = NULL`. El JOIN
con `job_execution_log` en `v_errores_recientes` usa LEFT JOIN precisamente por esto.

**Conclusión:** una sola tabla es la decisión correcta. La columna `contexto` (LONGTEXT
JSON) permite agregar cualquier dato adicional específico del tipo de error sin alterar
el schema.

---

## Decisión: ¿el ENUM `error_type` está bien diseñado?

### Valores actuales

| Valor | Origen | Usado hoy |
|---|---|---|
| `PARAM_INVALIDO` | 7 SPs reporte SIGNAL | T1.3 — sí (en plan) |
| `ETL_FALLO` | sp_etl_maestro EXIT HANDLERs | T1.2 — sí (en plan) |
| `ETL_PARTIAL` | sp_etl_maestro PASO 6 handler | T1.2 — sí (en plan) |
| `VALIDACION` | sp_etl_validar p_ok=FALSE | GAP 1 — pendiente |
| `REPORTE_VACIO` | SP retorna 0 filas | Definido, sin implementar |
| `SISTEMA` | Errores de infraestructura | Sin casos específicos aún |

### ¿Está completo el ENUM?

Sí. Todos los caminos de error identificados tienen un valor de ENUM que los cubre.
No hay una categoría de error que no encaje en los 6 valores. Los casos nuevos
identificados (GAP 1 y GAP 2) usan `PARAM_INVALIDO`, `ETL_FALLO` y `VALIDACION`
— valores que ya existen.

### `REPORTE_VACIO` — ¿eliminar o conservar?

`REPORTE_VACIO` representa "el SP se ejecutó sin error pero devolvió 0 filas".
Implementarlo requeriría que cada SP de reporte detecte ROW_COUNT() después del
SELECT y haga un INSERT condicional — lógica que cambia la firma del SP y agrega
complejidad para un caso de uso de valor bajo (un resultado vacío puede ser
completamente normal: el quarter Q03_26 aún no tiene datos).

**Decisión: conservar en el ENUM, no implementar.** El ENUM es fácilmente extensible
con ALTER TABLE — conservar el valor no genera deuda. Si en producción se identifica
un patrón recurrente de resultados vacíos que vale la pena auditar, se implementa
entonces.

### `SISTEMA` — ¿cuándo se usa?

`SISTEMA` es el comodín para errores de infraestructura que no encajan en las otras
categorías: tabla bloqueada por timeout, error de conexión en pleno ETL, OOM del
servidor. Estos no se pueden anticipar — se registran desde el EXIT HANDLER cuando
`GET DIAGNOSTICS` devuelve un `mysql_errno` de infraestructura (ej: 1205=lock wait
timeout, 1040=too many connections).

No hay una tarea específica para `SISTEMA` — los EXIT HANDLERs existentes (T1.2, T1.4)
ya lo capturarían automáticamente a través del error_type `ETL_FALLO`. `SISTEMA` queda
como valor disponible si se quiere una distinción más fina en el futuro.

---

## Conclusión — Correcciones al plan

El plan necesita dos adiciones para no tener deuda técnica:

### Corrección a T1.2

`sp_etl_maestro` v2.5.0 debe incluir el INSERT a `ivr_error_log` también en PASO 7
(cuando `v_ok=FALSE`). Es parte de la misma tarea — mismo archivo, mismo commit.

**Adición al PASO 7:**
```sql
ELSE  -- v_detalle_cargado=TRUE, PASO 6 ejecutó sp_etl_validar
    -- Cuando la validación de negocio detecta problemas (no excepción):
    IF NOT COALESCE(v_ok, FALSE) THEN
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO ivr_error_log
                (error_type, severity, sp_nombre,
                 p_quarter, error_message, job_log_id, ejecutado_por)
            VALUES
                ('VALIDACION', 'ALTA', 'sp_etl_validar',
                 v_quarter, v_msg, v_maestro_id, 'evt_etl_diario');
        END;
    END IF;
    UPDATE job_execution_log SET status = IF(...), ...
```

### Nueva tarea T1.4 — `sp_etl_historico` v2.1.0

`sp_etl_historico` necesita:

1. **INSERT a `ivr_error_log` antes del SIGNAL de validación:**
   ```sql
   IF p_quarter_num NOT IN (1, 2, 3, 4) THEN
       BEGIN
           DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
           INSERT INTO ivr_error_log
               (error_type, severity, sp_nombre, sql_state, mysql_errno,
                error_message, ejecutado_por)
           VALUES
               ('PARAM_INVALIDO', 'MEDIA', 'sp_etl_historico', '45000', 1644,
                CONCAT('p_quarter_num invalido: ', p_quarter_num), 'django_api');
       END;
       SIGNAL ...
   END IF;
   ```

2. **EXIT HANDLER para `sp_etl_base_detalle`** (wrapper BEGIN...END):
   ```sql
   BEGIN
       DECLARE EXIT HANDLER FOR SQLEXCEPTION
       BEGIN
           GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
           BEGIN
               DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
               INSERT INTO ivr_error_log
                   (error_type, severity, sp_nombre, sql_state,
                    p_quarter, error_message, job_log_id, ejecutado_por)
               VALUES
                   ('ETL_FALLO', 'CRITICA', 'sp_etl_historico', '45000',
                    v_quarter,
                    CONCAT('Falló etl_base_detalle: ', v_err_msg),
                    v_step_id, 'manual');
           END;
           UPDATE job_execution_log
           SET status='FAILED', end_time=NOW(), error_message=v_err_msg
           WHERE id = v_step_id;
       END;
       CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);
   END;
   ```

3. **EXIT HANDLER análogo para `sp_etl_base_clientes`.**

4. **INSERT cuando `v_ok=FALSE`** (mismo patrón que GAP 1):
   ```sql
   CALL sp_etl_validar(v_quarter, v_ok, v_msg);
   IF NOT COALESCE(v_ok, FALSE) THEN
       BEGIN
           DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
           INSERT INTO ivr_error_log
               (error_type, severity, sp_nombre,
                p_quarter, error_message, ejecutado_por)
           VALUES
               ('VALIDACION', 'ALTA', 'sp_etl_validar',
                v_quarter, v_msg, 'manual');
       END;
   END IF;
   SELECT v_quarter AS quarter_procesado, v_ok AS ok, v_msg AS resultado;
   ```

---

## Tabla de impacto actualizada

| Cambio | Objeto | Tarea |
|---|---|---|
| INSERT `ivr_error_log` en PASO 4/5/6 EXIT HANDLERs | `sp_etl_maestro` v2.5.0 | T1.2 (sin cambio) |
| INSERT `ivr_error_log` en PASO 7 cuando `v_ok=FALSE` | `sp_etl_maestro` v2.5.0 | **T1.2 — EXTENDER** |
| INSERT `ivr_error_log` antes de SIGNAL param inválido | 7 SPs reporte | T1.3 (sin cambio) |
| INSERT `ivr_error_log` antes de SIGNAL + EXIT HANDLERs + VALIDACION | `sp_etl_historico` v2.1.0 | **T1.4 — NUEVA** |
| Tabla adicional para errores ETL | — | No necesario |
| Tabla adicional para errores de reporte | — | No necesario |
| Cambio en estructura del ENUM | — | No necesario |
| Implementar REPORTE_VACIO | — | Diferido |
