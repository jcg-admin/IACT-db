# Flujo ETL IVR — Version 2.1 (documento completo)

**Fecha:** 2026-05-07
**Version:** 2.1
**Reemplaza:** `FLUJO-ETL-V2.md` (arquitectura) + `FLUJO-ETL-COMPLETO.md` (implementacion)
**Por que:** V2.md tenia la arquitectura actualizada pero sin codigo real.
COMPLETO.md tenia el codigo pero era v1 con nombres obsoletos y sin checkpoints.
Este documento fusiona ambos con la implementacion actual.

---

## Que cambio de v1 a v2

| Area | v1 | v2 | Por que |
|---|---|---|---|
| G-29 | CASE inline en cada SP | `fn_duracion_seg()` | Una sola version correcta para 38.8% de registros |
| NK90 / segmento / VACIO | CASE inline duplicado | `fn_normalizar_centro()`, `fn_did_segmento()`, `fn_normalizar_menu()` | Cambio en un lugar afecta a todos |
| Dias de semana | Pendiente del cliente | `ivr_es_dia_semana()` propias | Independencia del cliente — IVR opera 7 dias, criterio es lun-vie |
| Procesamiento | DELETE+INSERT de todo el quarter | Por mes (chunks ~4M filas) | Undo log manejable en MariaDB 10.1 |
| Orquestacion | Un SP sin checkpoints | Pipeline con checkpoint por paso en `job_execution_log` | Diagnostico preciso de fallos — saber exactamente que paso y que error |
| Crash MariaDB | `etl_runs` queda en `en_ejecucion` sin fin | Heartbeat Django + campo `timeout_at` | Deteccion automatica de timeout en 30 minutos |
| Dias de semana en reportes | Segundo scan a la fuente | Pre-computados en ETL (`llamadas_entre_semana`) | `sp_rpt_centros_xsegmento` sin scan adicional |

---

## Vision general

```
CLIENTE (solo lectura)          IACT — MariaDB mismo servidor
──────────────────────          ──────────────────────────────────────────────

tbl_historico_t1_2025           DISPARO
tbl_historico_t2_2025           evt_etl_diario (02:00 AM MySQL Event)
tbl_historico_t3_2025           manage.py run_etl (APScheduler Django)
tbl_historico_t4_2025               │
tbl_historico_t1_2026               ▼
tbl_historico_t2_2026           sp_etl_maestro()
         │                          │ checkpoint 'etl_base_detalle'
         └── scan mes a mes ──▶     ├── sp_etl_base_detalle() ──▶ base_ivr_detalle
         └── scan full quarter ──▶  ├── sp_etl_base_clientes() ──▶ base_ivr_clientes
                                    └── sp_etl_validar()
                                         │
                                    job_execution_log / etl_runs
                                         │
                                         ▼
                                  sp_rpt_centros_transferencia()
                                  sp_rpt_centros_xsegmento()
                                  sp_rpt_llamadas_abandonadas()   ◀── Django
                                  sp_rpt_menu_redirigidos()           cursor.callproc()
                                  sp_rpt_menu_centro()
                                  sp_rpt_cMENU_ERROR()
                                  sp_rpt_clientes()
```

---

## Diagrama de niveles

```
┌─────────────────────────────────────────────────────────────────┐
│  NIVEL 0 — Funciones de utilidad  (prerequisito de todo)        │
│                                                                   │
│  fn_did_segmento        fn_normalizar_menu    fn_duracion_seg    │
│  fn_normalizar_centro   ivr_es_dia_semana     ivr_contar_dias_s  │
│                         ivr_agregar_dias_s                       │
└──────────────────────────────┬──────────────────────────────────┘
                               │ usan
┌──────────────────────────────▼──────────────────────────────────┐
│  NIVEL 1 — Disparo del ETL                                       │
│  evt_etl_diario (MySQL Event 02:00 AM)                           │
│  manage.py run_etl ──▶ INSERT etl_runs + heartbeat thread        │
└──────────────────────────────┬──────────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────┐
│  NIVEL 2 — Orquestacion con checkpoints (sp_etl_maestro)        │
│  checkpoint 'maestro'         → job_execution_log               │
│  checkpoint 'etl_base_detalle'→ job_execution_log               │
│  checkpoint 'etl_base_clientes'→ job_execution_log              │
└───────────┬──────────────────────┬──────────────────────────────┘
            │                      │
┌───────────▼──────────┐ ┌─────────▼────────────┐
│  NIVEL 3A            │ │  NIVEL 3B             │
│  sp_etl_base_detalle │ │  sp_etl_base_clientes │
│  Scan mes a mes      │ │  Scan full quarter    │
│  GROUP BY grain      │ │  COUNT(DISTINCT)      │
│  → base_ivr_detalle  │ │  → base_ivr_clientes  │
└──────────────────────┘ └───────────────────────┘
            │                      │
┌───────────▼──────────────────────▼──────────────────────────────┐
│  NIVEL 4 — SPs de reporte (read-only, milisegundos)              │
│  7 SPs que leen base_ivr_detalle / base_ivr_clientes             │
└──────────────────────────────┬──────────────────────────────────┘
                               │ cursor.callproc()
┌──────────────────────────────▼──────────────────────────────────┐
│  NIVEL 5 — Django REST Framework                                  │
│  services/ivr_reports.py + views/ivr_reports.py + urls.py        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Nivel 0 — Tablas fuente (propiedad del cliente)

### Schema de cada tabla tbl_historico_tN_YYYY

| Columna | Tipo | Descripcion |
|---|---|---|
| `dFecha` | DATE | Fecha de la llamada — filtro principal del ETL |
| `dHoraInicio` | DATETIME | Inicio — 38.8% de registros tienen ini > fin (G-29) |
| `dHoraFin` | DATETIME | Fin — puede ser anterior al inicio (bug G-29) |
| `cDID_800Transfer` | VARCHAR(20) | DID de entrada: `19028031` / `19020001` / `19020084` |
| `cDID_Centro_Transferencia` | VARCHAR(50) | VDN destino — requiere normalizacion NK90 |
| `cMenu` | VARCHAR(100) | Menu IVR navegado — mixed case, puede ser NULL/vacio |
| `cOpcion` | VARCHAR(100) | Opcion dentro del menu — NULLABLE |
| `cTelefono_Origen` | VARCHAR(20) | ANI — siempre presente |
| `cTelefono_Digitado` | VARCHAR(20) | Numero digitado — 21.2% NULL |
| `cEtiquetacliente` | VARCHAR(200) | Etiquetas CSV raw por registro |

### Condiciones de calidad que el ETL maneja

| Condicion | Prevalencia | Tratamiento |
|---|---|---|
| `dHoraInicio > dHoraFin` (G-29) | 38.8% | `fn_duracion_seg()` usa ABS(TIMESTAMPDIFF) |
| `cMenu IS NULL` o vacio | ~8% | `fn_normalizar_menu()` → sentinel `'VACIO'` |
| `cDID_Centro` = `'cliente_colgo'` | 27.4% | `fn_normalizar_centro()` → sentinel `'CLIENTE_COLGO'` |
| `cDID_Centro` NULL o vacio | 1.3% | → sentinel `'CASO_NULL'` |
| `cDID_Centro` solo ceros | ~0.75% Puebla Q02+ | → sentinel `'CASO_ERROR_CEROS'` |
| `cDID_Centro` NK90 longitud > 10 | 5.67% | → `LEFT(campo, LENGTH-10)` |
| `cDID_Centro` char no numerico | 0.05% | → sentinel `'ERROR_CARACTER_INICIAL'` |
| `cTelefono_Digitado IS NULL` | 21.2% | → columna `no_digito_telefono += 1` |
| `cMenu` contiene telefono | 1.2% | Pasa tal cual — `sp_rpt_cMENU_ERROR` lo detecta |

### Restricciones de acceso

| Restriccion | Impacto |
|---|---|
| GRANT SELECT (CNST-ETL-001) | No se crean indices en la fuente |
| Sin indices en `tbl_historico_*` (CNST-ETL-005) | Full table scan en cada corrida ETL |
| Produccion en MariaDB 10.1.48 (CNST-ETL-007) | Sin window functions — subconsultas y variables de sesion |
| Nombre de tabla dinamico (CNST-ETL-008) | `PREPARE/EXECUTE` obligatorio en SPs ETL |

---

## Nivel 0 — Funciones de utilidad

### Resumen de las 7 funciones

```
fn_did_segmento(p_did)
  '19028031' → 'nacional_A'
  '19020001' → 'nacional_B'
  '19020084' → 'puebla'
  cualquier otro → 'desconocido'
  Usada por: sp_etl_base_detalle, sp_etl_base_clientes

fn_normalizar_menu(p_menu)
  NULL / '' / 'sin cMenu' → 'VACIO'
  cualquier otro → pass-through (mixed case)
  Usada por: sp_etl_base_detalle

fn_normalizar_centro(p_centro)
  Orden de ramas es critico — 'cliente_colgo' antes que LENGTH > 10
  NULL/vacio              → 'CASO_NULL'
  'cliente_colgo'         → 'CLIENTE_COLGO'
  solo ceros              → 'CASO_ERROR_CEROS'
  char no numerico inicio → 'ERROR_CARACTER_INICIAL'
  LENGTH > 10             → LEFT(campo, LENGTH-10)  -- NK90
  valor limpio            → pass-through
  Usada por: sp_etl_base_detalle

fn_duracion_seg(p_ini, p_fin)
  Retorna ABS(TIMESTAMPDIFF(SECOND, p_ini, p_fin))
  Maneja G-29 (38.8% tienen ini > fin) con ABS()
  NULL en cualquier argumento → 0
  Usada por: sp_rpt_centros_xsegmento (no en el ETL)

ivr_es_dia_semana(p_fecha)
  RETURN DAYOFWEEK(p_fecha) NOT IN (1, 7)
  TRUE  = lunes a viernes
  FALSE = sabado o domingo
  El IVR opera 7 dias — festivos no aplican (datos confirman
  volumen normal en dias festivos)
  Usada por: sp_etl_base_detalle, ivr_contar_dias_semana,
             ivr_agregar_dias_semana, sp_rpt_centros_xsegmento

ivr_contar_dias_semana(p_ini, p_fin)
  COUNT de dias lun-vie en el rango [p_ini, p_fin] inclusive
  O(n dias) — aceptable para rangos de un quarter (max 92 dias)
  Rango invertido → 0 (no error)
  Usada por: sp_rpt_centros_xsegmento

ivr_agregar_dias_semana(p_fecha, p_n)
  Avanza p_n dias de semana desde p_fecha
  p_n = 0 → retorna p_fecha sin cambio
  Usada por: sp_rpt_centros_xsegmento (fechas de seguimiento SLA)
```

---

## Nivel 1 — Disparo del ETL

Dos mecanismos coexisten con roles distintos.

### Mecanismo A — MySQL Event Scheduler (produccion automatica)

```sql
SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
COMMENT 'ETL IVR nocturno — ejecuta sp_etl_maestro()'
DO CALL sp_etl_maestro();
```

- Corre sin intervencion humana a las 02:00 AM
- No registra en `etl_runs` — solo en `job_execution_log`
- El SP maestro maneja la concurrencia: si hay un job RUNNING
  en las ultimas 6 horas, inserta `status='SKIP'` y sale

### Mecanismo B — Django management command (control manual)

```python
# management/commands/run_etl.py
import threading
from django.core.management.base import BaseCommand
from django.db import connections

class Command(BaseCommand):

    def add_arguments(self, parser):
        parser.add_argument('--quarter', type=str, default=None)
        parser.add_argument('--force',   action='store_true')

    def handle(self, *args, **options):
        quarter = options.get('quarter') or self._calcular_quarter_actual()

        # 1. Registrar inicio con timeout_at
        # H-ARCH-002: columnas reales de etl_runs:
        #   inicio_at (no iniciado_en), status (no estado),
        #   trigger_source (no ejecutado_por)
        with connections['ivr'].cursor() as c:
            c.execute("""
                INSERT INTO etl_runs
                    (trimestre, inicio_at, timeout_at, status, trigger_source)
                VALUES (%s, NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE),
                        'en_ejecucion', %s)
            """, [quarter, f'management_command'])
            run_id = c.lastrowid

        # 2. Heartbeat en thread paralelo (detecta timeout)
        stop_event = threading.Event()
        threading.Thread(
            target=self._heartbeat,
            args=(run_id, stop_event),
            daemon=True
        ).start()

        # 3. Ejecutar el ETL
        try:
            with connections['ivr'].cursor() as c:
                c.callproc('sp_etl_maestro', [])
            self._update_run(run_id, 'exitoso')
        except Exception as e:
            self._update_run(run_id, 'fallido', str(e))
            raise
        finally:
            stop_event.set()

    def _heartbeat(self, run_id, stop_event):
        """Marca como timeout si el SP lleva mas de 30 min sin responder."""
        # H-ARCH-002: intervalo corregido a 60s (schema heartbeat_at COMMENT).
        # Columnas: status (no estado), fin_at (no finalizado_en),
        #           error_message (no mensaje_error)
        while not stop_event.wait(timeout=60):    # check cada 60s
            try:
                with connections['ivr'].cursor() as c:
                    c.execute("""
                        UPDATE etl_runs
                        SET status='timeout',
                            fin_at=NOW(),
                            error_message='Sin respuesta > 30 min'
                        WHERE id=%s
                          AND status='en_ejecucion'
                          AND timeout_at < NOW()
                    """, [run_id])
            except Exception:
                pass

    def _update_run(self, run_id, status, error=None):
        # H-ARCH-002: columnas corregidas: status, fin_at, error_message
        with connections['ivr'].cursor() as c:
            c.execute("""
                UPDATE etl_runs
                SET status=%s, fin_at=NOW(), error_message=%s
                WHERE id=%s
            """, [status, error, run_id])
```

---

## Nivel 2 — Orquestacion con checkpoints (sp_etl_maestro)

Un registro en `job_execution_log` por cada paso del pipeline.
Si un paso falla, el log muestra exactamente cual paso y el error.

### Ejecucion exitosa

```
id  job_name    step_name           quarter  status   duracion_seg
1   etl_diario  maestro             Q02_26   SUCCESS  318
2   etl_diario  etl_base_detalle    Q02_26   SUCCESS  281
3   etl_diario  etl_base_clientes   Q02_26   SUCCESS  34
```

### Fallo en etl_base_detalle

```
id  step_name           status   error_message
1   maestro             FAILED   Fallo etl_base_detalle: Table doesn't exist
2   etl_base_detalle    FAILED   Table 'tbl_historico_t2_2026' doesn't exist
-- etl_base_clientes NO llega a correr
-- se puede reintentar solo el paso fallido
```

### PARTIAL (detalle OK, clientes falla)

```
id  step_name           status   records_procesados
1   maestro             PARTIAL  —
2   etl_base_detalle    SUCCESS  12847
3   etl_base_clientes   FAILED   0
-- Solo 2 filas de 3 en base_ivr_clientes
-- reintentar solo sp_etl_base_clientes
```

---

## Nivel 3A — sp_etl_base_detalle (ETL principal)

### Por que se procesa mes a mes

Con 13.6M filas (Q02_25), un DELETE+INSERT en una sola transaccion
genera varios GB de undo log en MariaDB 10.1.48. Procesando por mes:

```
Enero   → DELETE mes + INSERT ~4.5M filas → COMMIT   (undo log < 1GB)
Febrero → DELETE mes + INSERT ~4.5M filas → COMMIT
Marzo   → DELETE mes + INSERT ~4.5M filas → COMMIT
```

Si falla en Febrero, Enero ya esta commiteado. El checkpoint del step
en `job_execution_log` permite saber hasta que mes llego el ETL.

### Codigo real (simplificado para legibilidad)

```sql
CREATE PROCEDURE sp_etl_base_detalle(
    IN p_quarter  VARCHAR(10),    -- 'Q02_26'
    IN p_inicio   DATE,           -- '2026-04-01'
    IN p_fin      DATE,           -- '2026-06-30'
    IN p_table    VARCHAR(100),   -- 'tbl_historico_t2_2026'
    IN p_log_id   INT             -- ID en job_execution_log, o NULL
)
etl_detalle: BEGIN
    DECLARE v_mes_ini DATE;
    DECLARE v_mes_fin DATE;
    DECLARE v_total_ins INT DEFAULT 0;

    SET v_mes_ini = p_inicio;

    -- Iterar mes a mes dentro del quarter
    WHILE v_mes_ini <= p_fin DO
        SET v_mes_fin = LAST_DAY(v_mes_ini);
        IF v_mes_fin > p_fin THEN SET v_mes_fin = p_fin; END IF;

        -- DELETE idempotente solo para este mes
        DELETE FROM base_ivr_detalle
        WHERE trimestre = p_quarter
          AND fecha = DATE_FORMAT(v_mes_ini, '%Y%m');

        -- PREPARE/EXECUTE porque p_table es nombre dinamico (CNST-ETL-008)
        SET @etl_sql = CONCAT('
            INSERT INTO base_ivr_detalle
                (trimestre, fecha, segmento, centro_transferencia,
                 menu, opcion,
                 total_llamadas, misma_linea, linea_diferente,
                 no_digito_telefono,
                 llamadas_entre_semana, llamadas_fines_semana)
            SELECT
                ?,                                        -- trimestre
                DATE_FORMAT(dFecha, ''%Y%m''),            -- fecha
                fn_did_segmento(cDID_800Transfer),        -- segmento
                fn_normalizar_centro(cDID_Centro_Transferencia),
                fn_normalizar_menu(cMenu),
                COALESCE(NULLIF(TRIM(cOpcion), ''''), ''SIN_OPCION''),
                COUNT(*),
                SUM(cTelefono_Origen = cTelefono_Digitado
                    AND cTelefono_Digitado IS NOT NULL),
                SUM(cTelefono_Origen != cTelefono_Digitado
                    AND cTelefono_Digitado IS NOT NULL),
                SUM(cTelefono_Digitado IS NULL),
                SUM(ivr_es_dia_semana(dFecha)),           -- lun-vie
                SUM(NOT ivr_es_dia_semana(dFecha))        -- sab-dom
            FROM ', p_table, '
            WHERE dFecha BETWEEN ? AND ?
              AND cDID_800Transfer IN (''19020084'',''19028031'',''19020001'')
            GROUP BY
                DATE_FORMAT(dFecha, ''%Y%m''),
                fn_did_segmento(cDID_800Transfer),
                fn_normalizar_centro(cDID_Centro_Transferencia),
                fn_normalizar_menu(cMenu),
                COALESCE(NULLIF(TRIM(cOpcion), ''''), ''SIN_OPCION'')
            ON DUPLICATE KEY UPDATE
                total_llamadas        = VALUES(total_llamadas),
                misma_linea           = VALUES(misma_linea),
                linea_diferente       = VALUES(linea_diferente),
                no_digito_telefono    = VALUES(no_digito_telefono),
                llamadas_entre_semana = VALUES(llamadas_entre_semana),
                llamadas_fines_semana = VALUES(llamadas_fines_semana),
                cargado_en            = CURRENT_TIMESTAMP
        ');

        PREPARE etl_stmt FROM @etl_sql;
        SET @etl_q = p_quarter;
        SET @etl_i = v_mes_ini;
        SET @etl_f = v_mes_fin;
        EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;
        SET v_total_ins = v_total_ins + ROW_COUNT();
        DEALLOCATE PREPARE etl_stmt;

        SET v_mes_ini = DATE_ADD(LAST_DAY(v_mes_ini), INTERVAL 1 DAY);
    END WHILE;

    -- Actualizar checkpoint si se proporcion log_id
    IF p_log_id IS NOT NULL AND p_log_id > 0 THEN
        UPDATE job_execution_log
        SET records_procesados = v_total_ins,
            status             = 'SUCCESS',
            end_time           = NOW()
        WHERE id = p_log_id;
    END IF;
END etl_detalle;
```

### Grain de base_ivr_detalle

Una fila por combinacion unica de:
`(trimestre, fecha_mes, segmento, centro_transferencia, menu, opcion)`

Con 11-14M registros en la fuente y ~126 combinaciones reales de
`menu x opcion`, el resultado es del orden de miles de filas por
quarter — no millones. Los indices hacen que los 7 SPs de reporte
sean instantaneos.

---

## Nivel 3B — sp_etl_base_clientes (ETL secundario)

`COUNT(DISTINCT cTelefono_Origen)` no es aditivo: no puede calcularse
sumando valores de `base_ivr_detalle`. Requiere un segundo scan completo
del quarter. Resultado: exactamente 3 filas por quarter.

```sql
CREATE PROCEDURE sp_etl_base_clientes(
    IN p_quarter  VARCHAR(10),
    IN p_inicio   DATE,
    IN p_fin      DATE,
    IN p_table    VARCHAR(100),
    IN p_log_id   INT
)
BEGIN
    DELETE FROM base_ivr_clientes WHERE trimestre = p_quarter;

    SET @sql = CONCAT('
        INSERT INTO base_ivr_clientes (trimestre, segmento, clientes_unicos)
        SELECT
            ?,
            fn_did_segmento(cDID_800Transfer) AS segmento,
            COUNT(DISTINCT cTelefono_Origen)  AS clientes_unicos
            -- P-NEW-04: pendiente confirmar cTelefono_Origen vs cTelefono_Digitado
        FROM ', p_table, '
        WHERE dFecha BETWEEN ? AND ?
          AND cDID_800Transfer IN (''19020084'', ''19028031'', ''19020001'')
        GROUP BY fn_did_segmento(cDID_800Transfer)
    ');

    PREPARE stmt FROM @sql;
    SET @q = p_quarter, @i = p_inicio, @f = p_fin;
    EXECUTE stmt USING @q, @i, @f;
    DEALLOCATE PREPARE stmt;
    -- Resultado esperado: 3 filas (nacional_A, nacional_B, puebla)
END;
```

---

## Nivel 3 — Tablas intermedias (DDL real)

### base_ivr_detalle

```sql
CREATE TABLE base_ivr_detalle (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    trimestre             VARCHAR(10)  NOT NULL  COMMENT 'Q01_25, Q02_25...',
    fecha                 VARCHAR(6)   NOT NULL  COMMENT 'YYYYMM: 202501',
    segmento              VARCHAR(20)  NOT NULL  COMMENT 'nacional_A | nacional_B | puebla',
    centro_transferencia  VARCHAR(100) NOT NULL  COMMENT 'VDN normalizado o sentinel',
    menu                  VARCHAR(100) NOT NULL  COMMENT 'Raw mixed case. UPPER() en SPs de reporte.',
    opcion                VARCHAR(100) NOT NULL  COMMENT 'Valor de cOpcion o SIN_OPCION',
    total_llamadas        INT NOT NULL DEFAULT 0 COMMENT 'COUNT(*) por grupo',
    misma_linea           INT NOT NULL DEFAULT 0,
    linea_diferente       INT NOT NULL DEFAULT 0,
    no_digito_telefono    INT NOT NULL DEFAULT 0,
    llamadas_entre_semana INT NOT NULL DEFAULT 0 COMMENT 'Llamadas lun-vie (ivr_es_dia_semana)',
    llamadas_fines_semana INT NOT NULL DEFAULT 0 COMMENT 'Llamadas sab-dom',
    cargado_en            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_grain (trimestre, fecha, segmento,
                         centro_transferencia(50), menu(50), opcion(50)),
    KEY idx_trim_seg_fecha (trimestre, segmento, fecha),
    KEY idx_trim_menu      (trimestre, menu),
    KEY idx_trim_centro    (trimestre, centro_transferencia),
    KEY idx_fecha_seg      (fecha, segmento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### base_ivr_clientes

```sql
CREATE TABLE base_ivr_clientes (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    trimestre       VARCHAR(10)  NOT NULL,
    segmento        VARCHAR(20)  NOT NULL,
    clientes_unicos INT          NOT NULL DEFAULT 0,
    cargado_en      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uk_grain  (trimestre, segmento),
    KEY        idx_trim_seg (trimestre, segmento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- 3 filas por quarter: nacional_A, nacional_B, puebla
```

### etl_runs (fuente de verdad para la UI Django)

```sql
CREATE TABLE etl_runs (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    trimestre           VARCHAR(20)  NOT NULL,
    -- H-ARCH-002: columnas corregidas 2026-05-11
    inicio_at           DATETIME     NOT NULL,
    fin_at              DATETIME     DEFAULT NULL,
    timeout_at          DATETIME     NOT NULL  COMMENT 'Fecha/hora limite. Si sigue en en_ejecucion despues → timeout.',
    heartbeat_at        DATETIME     DEFAULT NULL
                        COMMENT 'Actualizado cada 60s por el thread de heartbeat de run_etl.py',
    status              ENUM('en_ejecucion','success','failed','timeout','skip')
                        NOT NULL DEFAULT 'en_ejecucion',
    registros_detalle   INT          DEFAULT 0,
    registros_clientes  INT          DEFAULT 0,
    error_message       TEXT         DEFAULT NULL,
    trigger_source      VARCHAR(100) DEFAULT 'django_command'
                        COMMENT 'django_command | evt_etl_diario | manual',

    KEY idx_status_inicio (status, inicio_at DESC),
    KEY idx_trimestre     (trimestre),
    KEY idx_timeout       (status, timeout_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### job_execution_log (tracking granular del SP pipeline)

```sql
CREATE TABLE job_execution_log (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    job_name            VARCHAR(100) NOT NULL  COMMENT 'etl_diario | etl_historico',
    quarter_name        VARCHAR(20)  DEFAULT NULL,
    step_name           VARCHAR(50)  DEFAULT NULL  COMMENT 'maestro | etl_base_detalle | etl_base_clientes',
    tabla_origen        VARCHAR(100) DEFAULT NULL,
    start_time          DATETIME     NOT NULL,
    end_time            DATETIME     DEFAULT NULL,
    status              ENUM('RUNNING','SUCCESS','PARTIAL','FAILED','SKIP','TIMEOUT')
                        NOT NULL DEFAULT 'RUNNING',
    records_procesados  INT          DEFAULT 0,
    duracion_seg        INT AS (
                            CASE WHEN end_time IS NOT NULL
                            THEN TIMESTAMPDIFF(SECOND, start_time, end_time)
                            ELSE NULL END
                        ) STORED,  -- columna calculada automaticamente
    error_message       TEXT         DEFAULT NULL,
    ejecutado_por       VARCHAR(50)  DEFAULT 'evt_etl_diario',

    KEY idx_status_start  (status, start_time DESC),
    KEY idx_quarter_step  (quarter_name, step_name),
    KEY idx_job_start     (job_name, start_time DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### job_config

```sql
CREATE TABLE job_config (
    job_name        VARCHAR(100) NOT NULL PRIMARY KEY,
    is_enabled      BOOLEAN      NOT NULL DEFAULT TRUE,
    timeout_seconds INT          NOT NULL DEFAULT 1800  COMMENT 'Default 30 min',
    ventana_inicio  TIME         DEFAULT '02:00:00',
    ventana_fin     TIME         DEFAULT '04:00:00',
    min_intervalo_h INT          NOT NULL DEFAULT 6  COMMENT 'Horas minimas entre ejecuciones',
    notas           TEXT         DEFAULT NULL,
    actualizado_en  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                    ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Datos iniciales
INSERT INTO job_config (job_name, is_enabled, timeout_seconds, notas) VALUES
('etl_diario',    TRUE,  1800, 'ETL nocturno automatico. Procesa el quarter actual.'),
('etl_historico', FALSE, 7200, 'Carga historica manual. Habilitar solo durante backfill inicial.');
```

---

## Nivel 4 — SPs de reporte

### Patron de filtro unificado

Todos los SPs usan el mismo patron para `p_segmento`:

```sql
WHERE b.trimestre = p_quarter
  AND (p_segmento = 'todas' OR b.segmento = p_segmento)
```

`p_segmento = 'todas'` devuelve todos los segmentos en el mismo result set.
Un solo SELECT — sin bloques IF duplicados como en FUNC_REPORTE_COBRANZA.

### Los 7 SPs

| SP | Parametros | Filas aprox. | Descripcion |
|---|---|---|---|
| `sp_rpt_clientes` | quarter | 3 | Clientes unicos por segmento |
| `sp_rpt_centros_transferencia` | quarter, segmento | Cientos | Detalle fecha x centro x menu x opcion |
| `sp_rpt_llamadas_abandonadas` | quarter, segmento | 3-9 | Tasa abandono: VACIO + cliente_colgo + SinOpcion_Cabecera |
| `sp_rpt_menu_redirigidos` | quarter, segmento | Docenas | Menus que dispararon transferencia |
| `sp_rpt_menu_centro` | quarter, segmento | Decenas | Centro → menus que lo alimentan |
| `sp_rpt_cMENU_ERROR` | quarter, segmento | < 10 | Anomalias: cMenu contiene numero de telefono |
| `sp_rpt_centros_xsegmento` | quarter | Docenas | KPIs SLA con dias de semana |

### sp_rpt_llamadas_abandonadas — ejemplo completo

```sql
CREATE PROCEDURE sp_rpt_llamadas_abandonadas(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))    AS menu,
        SUM(b.total_llamadas)  AS total_abandonadas,
        ROUND(
            SUM(b.total_llamadas) /
            (SELECT SUM(b2.total_llamadas)
             FROM base_ivr_detalle b2
             WHERE b2.trimestre = p_quarter
               AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
            ) * 100, 2
        ) AS pct_del_total
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    GROUP BY b.trimestre, b.segmento, b.menu
    ORDER BY b.segmento, total_abandonadas DESC;
END;
```

### sp_rpt_centros_xsegmento — columnas de salida

| Columna | Fuente | Descripcion |
|---|---|---|
| `total_llamadas` | SUM(total_llamadas) | Volumen total en el quarter |
| `llamadas_entre_semana` | SUM(llamadas_entre_semana) | Pre-computado en ETL — lun-vie |
| `llamadas_fines_semana` | SUM(llamadas_fines_semana) | Pre-computado en ETL — sab-dom |
| `pct_entre_semana` | Calculado | % de llamadas en dias de semana |
| `primera_actividad` | MIN(fecha) → DATE | Primer mes con datos |
| `ultima_actividad` | MAX(fecha) → LAST_DAY | Ultimo dia del mes mas reciente |
| `dias_semana_periodo` | `ivr_contar_dias_semana()` | Dias lun-vie en el periodo activo |
| `dias_semana_sin_actividad` | `ivr_contar_dias_semana()` | Dias lun-vie desde ultima actividad |
| `fecha_seguimiento_1_dia` | `ivr_agregar_dias_semana(max, 1)` | Proximo dia de semana |
| `fecha_seguimiento_3_dias` | `ivr_agregar_dias_semana(max, 3)` | Seguimiento critico |
| `fecha_escalamiento` | `ivr_agregar_dias_semana(max, 5)` | Escalamiento |
| `clasificacion_sla` | CASE | ACTIVO_HOY / DENTRO_SLA / RIESGO_SLA / FUERA_SLA / VOLUMEN_MEDIO / BAJO_VOLUMEN |
| `pct_del_segmento` | Subconsulta | % que este centro representa en su segmento |

---

## Nivel 5 — Django REST Framework

### Configuracion de conexion dual

```python
# settings.py
DATABASES = {
    'default': {                       # PostgreSQL — operacional Django
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_DB', 'iact_analytics'),
        ...
    },
    'ivr': {                           # MariaDB — IVR fuente + analitica IACT
        'ENGINE': 'django.db.backends.mysql',
        'NAME':     os.environ.get('IVR_DB_NAME',     'ivr_legacy'),
        'USER':     os.environ.get('IVR_DB_USER',     'django_user'),
        'PASSWORD': os.environ.get('IVR_DB_PASSWORD', 'django_pass'),
        'OPTIONS': {
            'charset':     'utf8mb4',
            'unix_socket': os.environ.get('IVR_DB_SOCKET', '/run/mysqld/mysqld.sock'),
        },
    }
}
DATABASE_ROUTERS = ['iact.routers.IVRRouter']
```

### Router

```python
# iact/routers.py
class IVRRouter:
    def db_for_read(self, model, **hints):
        if model._meta.app_label == 'ivr': return 'ivr'
        return None

    def db_for_write(self, model, **hints):
        if model._meta.app_label == 'ivr': return 'ivr'
        return None

    def allow_migrate(self, db, app_label, **hints):
        if app_label == 'ivr': return False   # nunca migrar en MariaDB con Django
        return None
```

### Motor comun y los 7 servicios

```python
# services/ivr_reports.py
from django.db import connections

def _call_sp(sp_name: str, params: list) -> list[dict]:
    with connections['ivr'].cursor() as cursor:
        cursor.callproc(sp_name, params)
        if cursor.description is None:   # SP retorno 0 filas (T-053b)
            return []
        cols = [c[0] for c in cursor.description]
        return [dict(zip(cols, row)) for row in cursor.fetchall()]

get_clientes              = lambda q:    _call_sp('sp_rpt_clientes',              [q])
get_centros_transferencia = lambda q, s: _call_sp('sp_rpt_centros_transferencia', [q, s])
get_abandonadas           = lambda q, s: _call_sp('sp_rpt_llamadas_abandonadas',  [q, s])
get_menu_redirigidos      = lambda q, s: _call_sp('sp_rpt_menu_redirigidos',      [q, s])
get_menu_centro           = lambda q, s: _call_sp('sp_rpt_menu_centro',           [q, s])
get_cmenu_error           = lambda q, s: _call_sp('sp_rpt_cMENU_ERROR',           [q, s])
get_centros_xsegmento     = lambda q:    _call_sp('sp_rpt_centros_xsegmento',     [q])
```

### Vista DRF — ejemplo completo

```python
# views/ivr_reports.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from services import ivr_reports

QUARTERS_VALIDOS  = {'Q01_25','Q02_25','Q03_25','Q04_25','Q01_26','Q02_26'}
SEGMENTOS_VALIDOS = {'todas','nacional_A','nacional_B','puebla'}

def _validar(quarter=None, segmento=None):
    errores = []
    if quarter  and quarter  not in QUARTERS_VALIDOS:
        errores.append(f'quarter invalido: {quarter}')
    if segmento and segmento not in SEGMENTOS_VALIDOS:
        errores.append(f'segmento invalido: {segmento}')
    return errores


class LlamadasAbandonadasView(APIView):
    """GET /api/ivr/reportes/abandonadas/?quarter=Q01_25&segmento=todas"""

    def get(self, request):
        quarter  = request.query_params.get('quarter',  'Q01_25')
        segmento = request.query_params.get('segmento', 'todas')

        errores = _validar(quarter=quarter, segmento=segmento)
        if errores:
            return Response({'errores': errores}, status=status.HTTP_400_BAD_REQUEST)

        data = ivr_reports.get_abandonadas(quarter, segmento)
        return Response({
            'quarter':     quarter,
            'segmento':    segmento,
            'total_filas': len(data),
            'datos':       data
        })
```

### URLs — los 9 endpoints

```python
# urls/ivr.py
from django.urls import path
from views import ivr_reports, ivr_pipeline

urlpatterns = [
    path('reportes/clientes/',          ivr_reports.ClientesView.as_view()),
    path('reportes/centros/',           ivr_reports.CentrosTransferenciaView.as_view()),
    path('reportes/centros-segmento/',  ivr_reports.CentrosXSegmentoView.as_view()),
    path('reportes/abandonadas/',       ivr_reports.LlamadasAbandonadasView.as_view()),
    path('reportes/menu-redirigidos/',  ivr_reports.MenuRedirigidosView.as_view()),
    path('reportes/menu-centro/',       ivr_reports.MenuCentroView.as_view()),
    path('reportes/cmenu-error/',       ivr_reports.CMENUErrorView.as_view()),
    path('pipeline/estado/',            ivr_pipeline.ETLEstadoView.as_view()),
    path('pipeline/reintentar/',        ivr_pipeline.ETLReintentarView.as_view()),
]

# urls.py principal
path('api/ivr/', include('urls.ivr')),
```

### Flujo end-to-end de una peticion

```
Frontend
    │  GET /api/ivr/reportes/abandonadas/?quarter=Q01_25&segmento=nacional_A
    ▼
Django — LlamadasAbandonadasView.get()
    │  Valida: quarter en QUARTERS_VALIDOS, segmento en SEGMENTOS_VALIDOS
    │  ivr_reports.get_abandonadas('Q01_25', 'nacional_A')
    ▼
MariaDB — conexion 'ivr'
    cursor.callproc('sp_rpt_llamadas_abandonadas', ['Q01_25', 'nacional_A'])
    │  SELECT ... FROM base_ivr_detalle
    │  WHERE trimestre='Q01_25' AND segmento='nacional_A'
    │    AND menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
    │  usa INDEX idx_trim_seg_fecha — respuesta en milisegundos
    ▼
  Result set: lista de dicts
    │  [{trimestre, segmento, menu, total_abandonadas, pct_del_total}, ...]
    ▼
Django — Response(JSON)
    │
    ▼
Frontend — consume JSON directamente sin post-procesamiento
```

---

## Carga historica inicial

```sql
-- Ejecutar una sola vez para poblar los quarters historicos.
-- sp_etl_historico(p_year INT, p_quarter_num INT):
--   Escribe en job_execution_log (NO toca job_config).
--   Flujo interno: sp_etl_base_detalle → SLEEP(5) →
--                  sp_etl_base_clientes → sp_etl_validar
--   H-ARCH-002: corregido 2026-05-11 — descripción anterior incorrecta.

CALL sp_etl_historico(2025, 1);   -- Q01_25  ~11.6M filas reales  ~9 min
CALL sp_etl_historico(2025, 2);   -- Q02_25  ~13.6M filas reales  ~10 min
CALL sp_etl_historico(2025, 3);   -- Q03_25  ~11.5M filas reales  ~9 min
CALL sp_etl_historico(2025, 4);   -- Q04_25  estimado             ~9 min
CALL sp_etl_historico(2026, 1);   -- Q01_26  estimado             ~9 min
-- Q02_26: evt_etl_diario lo maneja desde hoy
-- Total backfill: ~47 min (5 quarters + pausas de 5s entre pasos)
```

---

## Orden de implementacion

```
PASO 1  funciones_utilidad.sql    — 7 funciones (Nivel 0)
PASO 2  schema_base_ivr.sql       — 5 tablas (base_ivr_*, control)
PASO 3  sp_etl_pipeline.sql       — 5 SPs ETL (Niveles 2 y 3)
PASO 4  sp_rpt_reportes.sql       — 7 SPs reporte (Nivel 4)
PASO 5  MySQL Event Scheduler     — evt_etl_diario (Nivel 1A)
PASO 6  management command        — run_etl + heartbeat (Nivel 1B)
PASO 7  sp_etl_historico          — carga de Q01_25..Q01_26
PASO 8  Django DRF                — settings + services + views + urls
```

---

## Restricciones tecnicas que condicionan el diseno

| ID | Restriccion | Impacto |
|---|---|---|
| CNST-ETL-001 | Solo SELECT en `tbl_historico_*` | No se crean indices en la fuente |
| CNST-ETL-005 | Sin indices en tablas fuente | Full scan obligatorio — chunks por mes para controlar undo log |
| CNST-ETL-007 | Produccion en MariaDB 10.1.48. Sandbox en 10.11.14. SPs escritos sin window functions para compatibilidad. | Subconsultas correlacionadas en lugar de `OVER(PARTITION BY)` |
| CNST-ETL-008 | Nombre de tabla dinamico (p_table) | `PREPARE/EXECUTE` obligatorio en sp_etl_base_detalle y sp_etl_base_clientes |
| CNST-003 | Intervalo minimo entre ejecuciones | `job_config.min_intervalo_h = 6` |
| ADR-BACK-012 | Sin Redis/RabbitMQ | Heartbeat con `threading.Thread` en el management command |
| IVR opera 7 dias | No aplica festivos nacionales | `ivr_es_dia_semana` = solo lun-vie, sin catalogo de festivos |

---

## Comparacion con FUNC_REPORTE_COBRANZA

| Aspecto | FUNC_REPORTE_COBRANZA (SQL Server) | Nuestros sp_rpt_* (MariaDB) |
|---|---|---|
| Tipo | Table-Valued Function | Stored Procedure (result set) |
| Modo de filtro | `@FORM=1/2/3` + `@ID` | `p_quarter` + `p_segmento` |
| Bloque condicional | 3 bloques IF con SELECT duplicado | 1 SELECT con `OR segmento=` |
| Superficie de bug | Alta — 3 copias del mismo SELECT | Baja — un solo lugar para cambiar |
| Output | 20 columnas denormalizadas | 7-11 columnas limpias por SP |

El bug de `PATERNO` duplicado en la funcion original ocurre precisamente
por copiar el mismo bloque tres veces. Un solo SELECT con
`WHERE (p_segmento = 'todas' OR b.segmento = p_segmento)` elimina esa
superficie de error.

---

## Estado de todos los componentes

| Capa | Componente | Tecnologia | Estado |
|---|---|---|---|
| 0 — Fuente | `tbl_historico_tN_YYYY` (6 tablas) | MariaDB cliente | Creadas + seed |
| 0 — Funciones | 7 funciones de utilidad | MariaDB FUNCTION | Desplegadas |
| 1 — Disparo | `evt_etl_diario` | MySQL Event | Pendiente |
| 1 — Disparo | `manage.py run_etl` + heartbeat | Django | Pendiente |
| 2 — Orquestacion | `sp_etl_maestro` | MariaDB SP | Desplegado |
| 3 — ETL | `sp_etl_base_detalle` | MariaDB SP (PREPARE/EXECUTE) | Desplegado |
| 3 — ETL | `sp_etl_base_clientes` | MariaDB SP (PREPARE/EXECUTE) | Desplegado |
| 3 — ETL | `sp_etl_validar` | MariaDB SP | Desplegado |
| 3 — Backfill | `sp_etl_historico` | MariaDB SP | Desplegado |
| 4 — Tablas | `base_ivr_detalle`, `base_ivr_clientes` | MariaDB IACT | Creadas |
| 4 — Control | `job_execution_log`, `etl_runs`, `job_config` | MariaDB IACT | Creadas |
| 5 — Reportes | 7 SPs `sp_rpt_*` | MariaDB SP | Desplegados |
| 6 — API | `settings.py` DATABASES dual | Django | Pendiente |
| 6 — API | `services/ivr_reports.py` | Django | Pendiente |
| 6 — API | `views/ivr_reports.py` + `urls.py` | Django DRF | Pendiente |
| 6 — Scheduler | APScheduler + `run_etl` command | Django | Pendiente |

---

## Ver tambien

- `ANALISIS-ARQUITECTURA-ETL.md` — 7 problemas de v1 que motivaron este diseno
- `GRAFO-DEPENDENCIAS.md` — analisis de dependencias entre componentes
- `PLAN-IMPLEMENTACION-V2.md` — plan de 66 tareas para la implementacion completa
- `MARIADB-COMPATIBILIDAD-10.1.md` — restricciones SQL para MariaDB 10.1.48
- `TBL-HISTORICO-ANOMALIAS.md` — G-29, NK90 y demas condiciones de calidad
- `MAPEO-DID-SEGMENTOS.md` — DIDs y etiquetas canonicas de segmento
- `REPORTE-C-MENU.md` — fuente de los VDNs y el mixed case (H-1)

