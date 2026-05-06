# Análisis de arquitectura ETL — Problemas y propuesta revisada

**Fecha:** 2026-05-06
**Contexto:** Revisión del diseño de FLUJO-ETL-COMPLETO.md a la luz de
las condiciones reales de los datos de producción.

---

## 1. El problema de G-29 — sin función de corrección de horas

### Situación actual

El bug G-29 (`dHoraInicio > dHoraFin`) afecta **38.8% de los registros**
— aproximadamente 4.5M filas por quarter. Está documentado en
`TBL-HISTORICO-ANOMALIAS.md` con su workaround, pero **no existe como
función reutilizable**. Cualquier SP que calcule duración de llamada debe
reinventar el mismo CASE:

```sql
-- Duplicado actualmente en cada SP que lo necesite:
CASE
    WHEN TIME_TO_SEC(TIME(dHoraInicio)) <= TIME_TO_SEC(TIME(dHoraFin))
        THEN TIME_TO_SEC(TIME(dHoraFin)) - TIME_TO_SEC(TIME(dHoraInicio))
    ELSE
        TIME_TO_SEC(TIME(dHoraInicio)) - TIME_TO_SEC(TIME(dHoraFin))
END AS duracion_seg
```

Si esta lógica está en tres SPs y la corrección de la limitación de
medianoche cambia, hay que encontrar y actualizar los tres. Uno
inevitablemente se queda desactualizado.

### Función requerida

```sql
CREATE FUNCTION fn_duracion_seg(
    p_ini DATETIME,
    p_fin DATETIME
) RETURNS INT DETERMINISTIC
BEGIN
    -- Maneja G-29: si ini > fin, invierte la resta (produce valor positivo)
    -- Limitación conocida: llamadas que cruzan medianoche dan resultado incorrecto
    -- (~0.1% de registros — impacto mínimo documentado en TBL-HISTORICO-ANOMALIAS)
    RETURN ABS(
        TIME_TO_SEC(TIME(p_fin)) - TIME_TO_SEC(TIME(p_ini))
    );
END;
```

---

## 2. Por qué un solo job es insuficiente

### Tiempos estimados con datos reales

Asumiendo 50,000 filas/segundo en el scan+GROUP BY de `sp_etl_base_detalle`
(sin índices en la fuente, MariaDB 10.1.48):

| Quarter | Filas reales | sp_etl_detalle | sp_etl_clientes | Total |
|---|---|---|---|---|
| Q01_25 | 11,643,679 | ~4.5 min | ~4.5 min | ~9 min |
| Q02_25 | 13,612,375 | ~5.0 min | ~5.0 min | ~10 min |
| Q03_25 | 11,482,117 | ~4.5 min | ~4.5 min | ~9 min |
| Backfill 6Q | 65,198,171 | ~25 min | ~25 min | **~50 min** |

Un quarter individual es manejable (~9 min). El backfill completo
(~50 min) cabe en la ventana nocturna. El problema no es el tiempo
— es lo que pasa cuando falla.

### Escenario de falla sin checkpoints

```
sp_etl_maestro ejecuta:
    CALL sp_etl_base_detalle('Q02_25', ...)   ← falla en la fila 8M de 13.6M
        ROLLBACK                               ← datos Q02_25 vuelven al estado anterior
        UPDATE job_execution_log status='FAILED'

    sp_etl_base_clientes nunca corre.         ← base_ivr_clientes no se actualiza

    etl_runs: estado='fallido'                ← Django lo reporta como error

Consecuencia:
    - base_ivr_detalle Q02_25 = datos del día ANTERIOR (no del fallo)
    - base_ivr_clientes Q02_25 = datos del día ANTERIOR
    - El usuario ve datos de ayer — sin saber que el job falló
    - Si nadie monitorea, los datos pueden estar desactualizados días
```

### Escenario de crash de MariaDB

```
sp_etl_maestro ejecuta sp_etl_base_detalle:
    INSERT INTO base_ivr_detalle ... (proceso: 8M de 13.6M filas)
    ← MariaDB se cae (OOM, hardware, etc.)

Resultado:
    - etl_runs: estado='en_ejecucion' PARA SIEMPRE
    - job_execution_log: sin registro de fin
    - Django: ve 'en_ejecucion' y no sabe si reintentar
    - El próximo evt_etl_diario ve el registro 'en_ejecucion'
      y hace SKIP — el ETL no corre hasta que alguien intervenga
```

---

## 3. Lógica de normalización duplicada — el problema real

El diseño actual pone toda la normalización inline en `sp_etl_base_detalle`.
Esto significa que los SPs de reporte que necesiten normalización
tienen que repetirla o asumir que `base_ivr_detalle` ya la hizo.

### Lógicas que se duplicarán sin funciones

**NK90 (6 ramas)** — aparecerá en:
- `sp_etl_base_detalle` (ya diseñado)
- `sp_rpt_centros_transferencia` (si alguien decide mostrar el VDN raw)
- `sp_rpt_menu_centro` (misma razón)
- Cualquier query ad-hoc del equipo

**Segmento (DID → etiqueta)** — aparecerá en:
- `sp_etl_base_detalle`
- `sp_etl_base_clientes`
- `sp_rpt_clientes` (si necesita re-segmentar)
- Scripts de diagnóstico

**VACIO (NULL/vacío → sentinel)** — aparecerá en:
- `sp_etl_base_detalle`
- `sp_rpt_llamadas_abandonadas` (filtro `WHERE menu IN (...)`)

**Duración G-29** — aparecerá en:
- `sp_rpt_centros_xsegmento` (calcula duración promedio)
- Cualquier futuro reporte con métricas de tiempo

**Cada vez que se duplica, existe la posibilidad de una versión ligeramente diferente** — un CASE con una rama faltante, un orden diferente que produce resultados distintos para los edge cases.

---

## 4. Análisis de centralización — ¿conviene?

### Lo que sí conviene centralizar

**En funciones escalares** (todo lo que es una transformación 1→1):

| Función | Entrada | Salida | Usada por |
|---|---|---|---|
| `fn_did_segmento(vDID)` | `19028031` | `'nacional_A'` | ETL + 2 SPs |
| `fn_normalizar_centro(vDID)` | `'190100008190983030'` | `'19010000'` | ETL + 3 SPs |
| `fn_normalizar_menu(vMenu)` | `NULL` | `'VACIO'` | ETL + 4 SPs |
| `fn_duracion_seg(ini, fin)` | datetimes | segundos INT | 1 SP (xsegmento) |
| `fn_es_dia_habil(fecha)` | DATE | BOOLEAN | 1 SP (xsegmento) |
| `fn_contar_dias_habiles(ini, fin)` | DATE, DATE | INT | 1 SP (xsegmento) |

**En el SP maestro**: la lógica de control (concurrencia, quarter actual,
registro de log) sí es correcta centralizarla — es orquestación, no
transformación de datos.

### Lo que NO conviene centralizar en un solo SP

**El scan de datos** — `sp_etl_base_detalle` y `sp_etl_base_clientes` son
dos scans independientes. Si uno falla, el otro no debería verse afectado.
Deben poder ejecutarse por separado.

**La recuperación de errores** — el maestro actual hace ROLLBACK global.
Con checkpoints por paso, un fallo en `sp_etl_base_detalle` no debería
impedir que `sp_etl_base_clientes` corra (leen fuentes distintas).

**El tracking** — `etl_runs` está en MariaDB, pero si MariaDB cae, el
tracking también cae. Parte del tracking de estado debe poder hacerse
desde Django (heartbeat externo).

---

## 5. Propuesta de arquitectura revisada

### Capa de funciones de utilidad (prerequisito de todo)

```
Orden de creación (dependencias):

fn_did_segmento            — sin dependencias
fn_normalizar_menu         — sin dependencias
fn_normalizar_centro       — sin dependencias
fn_duracion_seg            — sin dependencias (maneja G-29)
fn_es_dia_habil            — puede requerir tabla de festivos
fn_contar_dias_habiles     — depende de fn_es_dia_habil
fn_agregar_dias_habiles    — depende de fn_es_dia_habil
```

### Pipeline granular (SPs independientes)

En lugar de un maestro monolítico, un pipeline donde cada paso
puede verificarse y reejecutarse de forma independiente:

```
NIVEL 0 — Funciones de utilidad
  fn_did_segmento()
  fn_normalizar_centro()
  fn_normalizar_menu()
  fn_duracion_seg()
  fn_es_dia_habil()
  fn_contar_dias_habiles()
  fn_agregar_dias_habiles()

NIVEL 1 — ETL granular (cada uno independiente)
  sp_etl_base_detalle(p_quarter, p_inicio, p_fin, p_table)
  sp_etl_base_clientes(p_quarter, p_inicio, p_fin, p_table)

NIVEL 2 — Orquestación con checkpoints
  sp_etl_maestro()
    checkpoint 'INICIADO'
    CALL sp_etl_base_detalle(...)   → checkpoint 'DETALLE_OK' o 'DETALLE_FAIL'
    CALL sp_etl_base_clientes(...)  → checkpoint 'CLIENTES_OK' o 'CLIENTES_FAIL'
    CALL sp_etl_validar(...)        → checkpoint 'VALIDADO' o 'PARTIAL'

NIVEL 3 — Carga histórica
  sp_etl_historico(p_year, p_quarter_num)
    Llama sp_etl_base_detalle + sp_etl_base_clientes secuencialmente
    Con pausa entre quarters para no saturar el servidor

NIVEL 4 — Reportes (sin dependencia del ETL — solo leen base_ivr_*)
  sp_rpt_centros_transferencia()
  sp_rpt_centros_xsegmento()
  sp_rpt_llamadas_abandonadas()
  sp_rpt_menu_redirigidos()
  sp_rpt_menu_centro()
  sp_rpt_cMENU_ERROR()
  sp_rpt_clientes()
```

### Checkpoints en job_execution_log

```sql
-- Columna adicional: step_name
ALTER TABLE job_execution_log
    ADD COLUMN step_name VARCHAR(50) AFTER quarter_name;

-- El maestro inserta un registro por paso, no uno por job
-- Paso 1
INSERT INTO job_execution_log (job_name, quarter_name, step_name, status, start_time)
VALUES ('etl_diario', v_quarter, 'etl_base_detalle', 'RUNNING', NOW());
SET v_step1_id = LAST_INSERT_ID();

CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table);

UPDATE job_execution_log SET status='SUCCESS', end_time=NOW(),
       records_base=v_count_det
WHERE id = v_step1_id;

-- Paso 2 — corre independientemente del paso 1
INSERT INTO job_execution_log (job_name, quarter_name, step_name, status, start_time)
VALUES ('etl_diario', v_quarter, 'etl_base_clientes', 'RUNNING', NOW());
SET v_step2_id = LAST_INSERT_ID();

CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table);

UPDATE job_execution_log SET status='SUCCESS', end_time=NOW()
WHERE id = v_step2_id;
```

Ahora si el paso 1 falla y el paso 2 tiene éxito, Django puede reportar
exactamente qué está desactualizado. El administrador puede reejecutar solo
`sp_etl_base_detalle` sin volver a procesar clientes.

### Heartbeat desde Django — solución al crash de MariaDB

```python
# En el management command run_etl, Django hace polling cada 2 minutos
# mientras el SP corre. Si detecta que MariaDB ya no responde, marca el run.

import threading
import time

def heartbeat_monitor(run_id, stop_event, timeout_min=30):
    """Monitorea que el ETL no lleve más de timeout_min minutos."""
    start = time.time()
    while not stop_event.is_set():
        elapsed = (time.time() - start) / 60
        if elapsed > timeout_min:
            # MariaDB no ha respondido en timeout_min — marcar timeout
            try:
                with connections['ivr'].cursor() as c:
                    c.execute("""
                        UPDATE etl_runs
                        SET estado='fallido',
                            finalizado_en=NOW(),
                            mensaje_error='TIMEOUT: superó %s minutos sin respuesta'
                        WHERE id=%s AND estado='en_ejecucion'
                    """, [timeout_min, run_id])
            except Exception:
                pass  # Si tampoco puede conectar, el siguiente arrange lo detecta
            break
        time.sleep(120)  # check cada 2 min

def handle_etl(run_id):
    stop_event = threading.Event()
    monitor = threading.Thread(
        target=heartbeat_monitor,
        args=(run_id, stop_event, 30),
        daemon=True
    )
    monitor.start()
    try:
        with connections['ivr'].cursor() as cursor:
            cursor.callproc('sp_etl_maestro', [])
    finally:
        stop_event.set()
```

### Transacción por bloques — evitar undo log gigante

En lugar de DELETE + INSERT de 14M filas en una transacción:

```sql
-- En sp_etl_base_detalle: procesar por mes (chunks naturales)

-- Mes 1
DELETE FROM base_ivr_detalle
WHERE trimestre = p_quarter AND fecha LIKE CONCAT(YEAR(p_inicio), '01%');

SET @sql_mes1 = CONCAT('INSERT INTO base_ivr_detalle ...
    WHERE dFecha BETWEEN ? AND ?
    ...', p_table, '...');
-- PREPARE + EXECUTE para enero

-- Mes 2, Mes 3 (idem)
-- Cada INSERT es ~3.5-4.5M filas, el undo log no explota
```

---

## 6. Resumen: qué cambia y por qué

| Área | Diseño actual | Diseño propuesto | Por qué |
|---|---|---|---|
| G-29 | CASE inline en cada SP | `fn_duracion_seg()` | Una sola versión correcta |
| NK90 normalización | CASE inline (6 ramas) | `fn_normalizar_centro()` | Una sola versión correcta |
| Segmento | CASE inline en cada SP | `fn_did_segmento()` | Una sola versión correcta |
| Menu normalización | CASE inline | `fn_normalizar_menu()` | Una sola versión correcta |
| Días hábiles | Pendiente P-14 (cliente) | Crear propias si no existen | Independencia del cliente |
| Job único | `sp_etl_maestro` todo | Pipeline de SPs + maestro | Granularidad de error |
| Checkpoints | Uno (inicio/fin) | Por paso (detalle/clientes/validar) | Diagnóstico preciso |
| Crash MariaDB | etl_runs queda en 'en_ejecucion' | Heartbeat desde Django | Detección de timeout |
| Transacción | 14M filas de una vez | Por mes (chunks ~4M) | Undo log manejable |
| Backfill | `sp_etl_historico` un job | Por quarter, con pausa entre cada uno | No saturar servidor |

---

## 7. Orden de implementación revisado

```
PASO 1 — Funciones de utilidad (todo lo demás depende de estas)
  fn_did_segmento
  fn_normalizar_menu
  fn_normalizar_centro
  fn_duracion_seg
  fn_es_dia_habil (propia — no depender del cliente para P-14)
  fn_contar_dias_habiles
  fn_agregar_dias_habiles

PASO 2 — Tablas de control con checkpoints
  job_execution_log (con columna step_name)
  etl_runs (con columna timeout_at)
  job_config

PASO 3 — Tablas base analítica
  base_ivr_detalle
  base_ivr_clientes

PASO 4 — SPs ETL (usan las funciones del Paso 1)
  sp_etl_base_detalle    — usa fn_did_segmento, fn_normalizar_centro, fn_normalizar_menu
  sp_etl_base_clientes   — usa fn_did_segmento
  sp_etl_validar         — verifica integridad post-load
  sp_etl_maestro         — orquesta con checkpoints
  sp_etl_historico       — wrapper para carga histórica quarter a quarter

PASO 5 — SPs de reporte (leen base_ivr_* y usan funciones del Paso 1)
  sp_rpt_clientes                  (sin funciones especiales)
  sp_rpt_centros_transferencia     (sin funciones especiales)
  sp_rpt_llamadas_abandonadas      (sin funciones especiales)
  sp_rpt_cMENU_ERROR               (sin funciones especiales)
  sp_rpt_menu_redirigidos          (sin funciones especiales)
  sp_rpt_menu_centro               (sin funciones especiales)
  sp_rpt_centros_xsegmento         (usa fn_es_dia_habil, fn_contar_dias_habiles,
                                    fn_agregar_dias_habiles, fn_duracion_seg)

PASO 6 — Event Scheduler + management command con heartbeat
PASO 7 — Carga histórica quarter a quarter
PASO 8 — Integración Django DRF
```

---

## 8. Las funciones propias que el cliente puede o no tener (P-14)

El SP más complejo (`sp_rpt_centros_xsegmento`) depende de tres funciones
que el script de producción del cliente referencia pero que pueden no existir
en la instancia de MariaDB que IACT tiene acceso.

**Estrategia de independencia:**

```sql
-- Crear en el schema de IACT aunque el cliente ya las tenga
-- Las propias tienen nombre con prefijo ivr_ para evitar colisión

CREATE FUNCTION ivr_es_dia_habil(p_fecha DATE)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    -- Excluye fines de semana
    -- Excluye festivos de México (Ley Federal del Trabajo)
    RETURN (
        DAYOFWEEK(p_fecha) NOT IN (1, 7)  -- 1=Domingo, 7=Sábado
        AND p_fecha NOT IN (
            -- Festivos fijos México
            CONCAT(YEAR(p_fecha), '-01-01'),  -- Año nuevo
            CONCAT(YEAR(p_fecha), '-02-05'),  -- Constitución
            CONCAT(YEAR(p_fecha), '-03-21'),  -- Natalicio Juárez
            CONCAT(YEAR(p_fecha), '-05-01'),  -- Día del trabajo
            CONCAT(YEAR(p_fecha), '-09-16'),  -- Independencia
            CONCAT(YEAR(p_fecha), '-11-20'),  -- Revolución
            CONCAT(YEAR(p_fecha), '-12-25')   -- Navidad
            -- Semana Santa: Jueves y Viernes Santo (variables — requiere tabla)
        )
    );
END;

CREATE FUNCTION ivr_contar_dias_habiles(p_ini DATE, p_fin DATE)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE v_dias INT DEFAULT 0;
    DECLARE v_fecha DATE;
    SET v_fecha = p_ini;
    WHILE v_fecha <= p_fin DO
        IF ivr_es_dia_habil(v_fecha) THEN
            SET v_dias = v_dias + 1;
        END IF;
        SET v_fecha = DATE_ADD(v_fecha, INTERVAL 1 DAY);
    END WHILE;
    RETURN v_dias;
END;
```

**Nota:** `ivr_contar_dias_habiles` con un WHILE día a día es O(n) en días.
Para rangos < 90 días (un quarter) es aceptable. Para rangos multi-quarter
se puede optimizar con la fórmula matemática de días hábiles.

---

## Ver también

- `FLUJO-ETL-COMPLETO.md` — diseño base que este documento revisa
- `TBL-HISTORICO-ANOMALIAS.md` — G-29 y otras condiciones de calidad
- `MAPEO-DID-SEGMENTOS.md` — lógica de segmento que fn_did_segmento encapsula
- `ETL-ANALISIS.md` — P-14 (fn_es_dia_habil del cliente) y R-05..R-10

