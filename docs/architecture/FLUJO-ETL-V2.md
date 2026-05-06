# Flujo ETL IVR — Versión 2.0

**Fecha:** 2026-05-06
**Reemplaza:** `FLUJO-ETL-COMPLETO.md` (v1.0)
**Motivación:** `ANALISIS-ARQUITECTURA-ETL.md` identificó 7 problemas
en la v1 que impactan directamente sobre los 11–14M de registros
reales por quarter.

---

## Qué cambió de v1.0 a v2.0

| Área | v1.0 | v2.0 | Por qué |
|---|---|---|---|
| G-29 | CASE inline en cada SP | `fn_duracion_seg()` | Una sola versión correcta para 38.8% de registros |
| NK90 / segmento / VACIO | CASE inline duplicado | `fn_normalizar_centro()` `fn_did_segmento()` `fn_normalizar_menu()` | Cambio en un lugar afecta a todos |
| Días hábiles | Pendiente P-14 (cliente) | `ivr_es_dia_habil()` propias | Independencia del entorno del cliente |
| Job | Un solo SP sin checkpoints | Pipeline con checkpoint por paso | Diagnóstico preciso de fallos |
| Crash MariaDB | `etl_runs` queda en `en_ejecucion` ∞ | Heartbeat desde Django + `timeout_at` | Detección automática de timeout |
| Transacción | DELETE+INSERT 14M filas | Por mes (chunks ~4M filas) | Undo log manejable en MariaDB 10.1 |
| Días hábiles en reportes | Require scan a fuente | Pre-computados en ETL (`llamadas_dias_habiles`) | `sp_rpt_centros_xsegmento` sin segundo scan |

---

## Visión general — diagrama v2.0

```
┌─────────────────────────────────────────────────────────────────┐
│  NIVEL 0 — Funciones de utilidad  (prerequisito de todo)        │
│                                                                   │
│  fn_did_segmento        fn_normalizar_menu    fn_duracion_seg    │
│  fn_normalizar_centro   ivr_es_dia_habil      ivr_contar_dias_h  │
│                         ivr_agregar_dias_h                       │
└──────────────────────────────┬──────────────────────────────────┘
                               │ usan
┌──────────────────────────────▼──────────────────────────────────┐
│  NIVEL 1 — Disparo del ETL                                       │
│                                                                   │
│  evt_etl_diario (MySQL Event 02:00 AM)                           │
│  manage.py run_etl  ──►  INSERT etl_runs (en_ejecucion)         │
│       │                  heartbeat thread (timeout 30 min)       │
│       └──────────────────────────┐                               │
└──────────────────────────────────┼──────────────────────────────┘
                                   │ llama
┌──────────────────────────────────▼──────────────────────────────┐
│  NIVEL 2 — Orquestación con checkpoints                          │
│                                                                   │
│  sp_etl_maestro()                                                │
│    checkpoint 'maestro'      RUNNING → SUCCESS/FAILED            │
│    checkpoint 'etl_base_detalle'   RUNNING → SUCCESS/FAILED      │
│    checkpoint 'etl_base_clientes'  RUNNING → SUCCESS/FAILED      │
│    CALL sp_etl_validar()    → PARTIAL si algún check falla       │
└───────────┬──────────────────────┬──────────────────────────────┘
            │                      │
┌───────────▼──────────┐ ┌─────────▼────────────────────────────┐
│  NIVEL 3A            │ │  NIVEL 3B                             │
│  sp_etl_base_detalle │ │  sp_etl_base_clientes                 │
│                      │ │                                        │
│  Scan tbl_historico  │ │  Scan tbl_historico                   │
│  GROUP BY mes        │ │  COUNT(DISTINCT cTelefono_Origen)      │
│  3 chunks (~4M c/u)  │ │  Resultado: 3 filas                   │
│  Usa fn_* para       │ │  Usa fn_did_segmento()                │
│  normalización       │ │                                        │
│         │            │ │         │                              │
│         ▼            │ │         ▼                              │
│  base_ivr_detalle    │ │  base_ivr_clientes                    │
└──────────────────────┘ └───────────────────────────────────────┘
            │                      │
┌───────────▼──────────────────────▼──────────────────────────────┐
│  NIVEL 4 — SPs de reporte (solo leen base_ivr_*)                 │
│                                                                   │
│  sp_rpt_clientes             → 3 filas por quarter               │
│  sp_rpt_centros_transferencia → cientos de filas                 │
│  sp_rpt_llamadas_abandonadas → decenas de filas                  │
│  sp_rpt_menu_redirigidos     → docenas de filas                  │
│  sp_rpt_menu_centro          → docenas de filas                  │
│  sp_rpt_cMENU_ERROR          → < 10 filas                        │
│  sp_rpt_centros_xsegmento   → docenas + KPIs SLA + días hábiles │
└──────────────────────────────┬──────────────────────────────────┘
                               │ cursor.callproc()
┌──────────────────────────────▼──────────────────────────────────┐
│  NIVEL 5 — Django REST Framework                                  │
│                                                                   │
│  services/ivr_reports.py  (_call_sp motor común)                 │
│  views/ivr_reports.py     (validación de parámetros)             │
│  urls.py                  (9 endpoints)                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## Archivos del pipeline (provisioners/mariadb/)

| Archivo | Líneas | Contenido | Ejecutar en orden |
|---|---|---|---|
| `funciones_utilidad.sql` | 291 | 7 funciones de utilidad | **1°** |
| `schema_base_ivr.sql` | 225 | DDL: 5 tablas IACT | **2°** |
| `sp_etl_pipeline.sql` | 481 | 5 SPs ETL | **3°** |
| `sp_rpt_reportes.sql` | 419 | 7 SPs de reporte | **4°** |

---

## Nivel 0 — Funciones de utilidad

### Las 7 funciones y qué problema resuelve cada una

```
fn_did_segmento(p_did)
  '19028031' → 'nacional_A'
  '19020001' → 'nacional_B'
  '19020084' → 'puebla'
  Usada por: sp_etl_base_detalle, sp_etl_base_clientes

fn_normalizar_menu(p_menu)
  NULL / '' / 'sin cMenu' → 'VACIO'
  Cualquier otro valor    → pass-through (mixed case)
  Usada por: sp_etl_base_detalle

fn_normalizar_centro(p_centro)
  NULL/vacío              → 'CASO_NULL'
  'cliente_colgo'         → 'CLIENTE_COLGO'
  Solo ceros              → 'CASO_ERROR_CEROS'
  Char no numérico al inicio → 'ERROR_CARACTER_INICIAL'
  LENGTH > 10             → LEFT(campo, LENGTH-10)  [NK90]
  Valor limpio            → pass-through
  Usada por: sp_etl_base_detalle

fn_duracion_seg(p_ini, p_fin)
  Retorna ABS(TIME_TO_SEC(fin) - TIME_TO_SEC(ini))
  Maneja G-29 (38.8% tienen ini > fin) con ABS()
  Usada por: sp_rpt_centros_xsegmento

ivr_es_dia_habil(p_fecha)
  FALSE si DAYOFWEEK IN (1, 7)  [Sáb/Dom]
  FALSE si es festivo fijo MX (Art.74 LFT)
  TRUE  en cualquier otro caso
  Usada por: sp_etl_base_detalle, ivr_contar_dias_habiles,
             ivr_agregar_dias_habiles, sp_rpt_centros_xsegmento

ivr_contar_dias_habiles(p_ini, p_fin)
  COUNT de días hábiles en el rango [p_ini, p_fin] inclusive
  O(n días) — aceptable para rangos de un quarter (≤ 92 días)
  Usada por: sp_rpt_centros_xsegmento

ivr_agregar_dias_habiles(p_fecha, p_n)
  Retorna la fecha después de N días hábiles
  Usada por: sp_rpt_centros_xsegmento (fechas de seguimiento SLA)
```

---

## Nivel 1 — Disparo del ETL

### Mecanismo A — MySQL Event (producción automática)

```sql
SET GLOBAL event_scheduler = ON;

CREATE EVENT evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
DO CALL sp_etl_maestro();
```

No requiere Django. No registra en `etl_runs`. Solo registra en
`job_execution_log` (dentro de MariaDB).

### Mecanismo B — Django management command (control manual)

```python
# management/commands/run_etl.py
class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--quarter', type=str, default=None)
        parser.add_argument('--force',  action='store_true')

    def handle(self, *args, **options):
        import threading, time

        with connections['ivr'].cursor() as cursor:
            # 1. Registrar inicio con timeout_at
            cursor.execute("""
                INSERT INTO etl_runs
                    (trimestre, iniciado_en, timeout_at, estado, ejecutado_por)
                VALUES (%s, NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE),
                        'en_ejecucion', %s)
            """, [options.get('quarter') or 'auto', self._ejecutado_por()])
            run_id = cursor.lastrowid

        # 2. Heartbeat en thread paralelo
        stop = threading.Event()
        threading.Thread(
            target=self._heartbeat,
            args=(run_id, stop),
            daemon=True
        ).start()

        # 3. Ejecutar ETL
        try:
            with connections['ivr'].cursor() as cursor:
                cursor.callproc('sp_etl_maestro', [])
            self._update_run(run_id, 'exitoso')
        except Exception as e:
            self._update_run(run_id, 'fallido', str(e))
            raise
        finally:
            stop.set()

    def _heartbeat(self, run_id, stop_event):
        """Marca como timeout si el SP lleva más de 30 min sin responder."""
        while not stop_event.wait(timeout=120):  # check cada 2 min
            try:
                with connections['ivr'].cursor() as c:
                    c.execute("""
                        UPDATE etl_runs
                        SET estado='timeout', finalizado_en=NOW(),
                            mensaje_error='Sin respuesta > 30 min'
                        WHERE id=%s AND estado='en_ejecucion'
                          AND timeout_at < NOW()
                    """, [run_id])
            except Exception:
                pass

    def _update_run(self, run_id, estado, error=None):
        with connections['ivr'].cursor() as c:
            c.execute("""
                UPDATE etl_runs
                SET estado=%s, finalizado_en=NOW(), mensaje_error=%s
                WHERE id=%s
            """, [estado, error, run_id])
```

---

## Nivel 2 — Orquestación con checkpoints

`sp_etl_maestro` registra un checkpoint por paso en `job_execution_log`.
Si un paso falla, el log muestra exactamente qué paso y qué error.

```
job_execution_log después de una ejecución exitosa:

id  step_name          quarter  status   duracion_seg
1   maestro            Q02_26   SUCCESS  312
2   etl_base_detalle   Q02_26   SUCCESS  278
3   etl_base_clientes  Q02_26   SUCCESS  31
```

```
job_execution_log después de un fallo en detalle:

id  step_name          quarter  status   error_message
1   maestro            Q02_26   FAILED   Falló etl_base_detalle: ...
2   etl_base_detalle   Q02_26   FAILED   Table 'tbl_historico_t2_2026' doesn't exist
                                          ↑ sp_etl_base_clientes NO corre
                                          → se puede reintentar solo el paso 2
```

```
job_execution_log después de un PARTIAL (detalle OK, clientes falla):

id  step_name          quarter  status   records_procesados
1   maestro            Q02_26   PARTIAL  —
2   etl_base_detalle   Q02_26   SUCCESS  12,847
3   etl_base_clientes  Q02_26   FAILED   0
                                          ↑ solo 2 filas de 3 en base_ivr_clientes
                                          → reintentar solo sp_etl_base_clientes
```

---

## Nivel 3A — sp_etl_base_detalle (ETL principal)

### Por qué se procesa mes a mes

Con 13.6M filas (Q02_25 — el pico), un DELETE+INSERT en una transacción
genera un undo log de varios GB en MariaDB 10.1.48. Procesando por mes:

```
Enero   → DELETE mes + INSERT ~4.5M filas → COMMIT  (undo log < 1GB)
Febrero → DELETE mes + INSERT ~4.5M filas → COMMIT
Marzo   → DELETE mes + INSERT ~4.5M filas → COMMIT
```

Si falla en Febrero, Enero ya está commiteado y solo se reprocesa
desde Febrero. El checkpoint del step en `job_execution_log` permite
saber exactamente hasta qué mes llegó.

### Normalización aplicada

Toda la lógica de normalización llama a las funciones del Nivel 0:

```sql
fn_did_segmento(cDID_800Transfer)           -- DID → 'nacional_A'/'nacional_B'/'puebla'
fn_normalizar_centro(cDID_Centro_Transferencia)  -- NK90, sentinels
fn_normalizar_menu(cMenu)                   -- NULL/vacío → 'VACIO'
ivr_es_dia_habil(dFecha)                   -- pre-computa días hábiles
```

### ON DUPLICATE KEY UPDATE — idempotencia

El INSERT usa la clave única `uk_grain(trimestre, fecha, segmento, centro,
menu, opcion)`. Si se reprocesa un quarter, los datos se actualizan en lugar
de duplicarse. El ETL es idempotente por diseño.

---

## Nivel 3B — sp_etl_base_clientes (ETL secundario)

`COUNT(DISTINCT cTelefono_Origen)` no es aditivo: no puede calcularse
sumando los valores de `base_ivr_detalle`. Requiere un segundo scan de
`tbl_historico_*`. Resultado: exactamente 3 filas por quarter.

```
Q02_26 | nacional_A | 2,440,333
Q02_26 | nacional_B |   134,217
Q02_26 | puebla     |   412,891
```

---

## Nivel 4 — SPs de reporte

### Patrón de filtro unificado

Todos los SPs usan el mismo patrón para el parámetro `p_segmento`:

```sql
WHERE b.trimestre = p_quarter
  AND (p_segmento = 'todas' OR b.segmento = p_segmento)
```

`p_segmento = 'todas'` retorna todos los segmentos en el mismo result set.
Un solo SP — sin duplicación de bloques IF como en `FUNC_REPORTE_COBRANZA`.

### Normalización en presentación

Los SPs de reporte aplican `UPPER(TRIM(b.menu))` para presentación.
El ETL almacena mixed case (valor raw de la fuente — ver REPORTE-C-MENU H-1).
Esto permite que la UI muestre `RES-FALLAINTERNET` (estándar de reporte)
aunque la fuente diga `RES-FallaInternet`.

### Los 7 SPs

| SP | Fuente | p_quarter | p_segmento | Filas aprox. |
|---|---|---|---|---|
| `sp_rpt_clientes` | `base_ivr_clientes` | ✓ | — | 3 |
| `sp_rpt_centros_transferencia` | `base_ivr_detalle` | ✓ | ✓ | Cientos |
| `sp_rpt_llamadas_abandonadas` | `base_ivr_detalle` | ✓ | ✓ | 3–9 |
| `sp_rpt_menu_redirigidos` | `base_ivr_detalle` | ✓ | ✓ | Docenas |
| `sp_rpt_menu_centro` | `base_ivr_detalle` | ✓ | ✓ | Docenas |
| `sp_rpt_cMENU_ERROR` | `base_ivr_detalle` | ✓ | ✓ | < 10 |
| `sp_rpt_centros_xsegmento` | `base_ivr_detalle` | ✓ | — (todos) | Docenas |

### sp_rpt_centros_xsegmento — columnas clave

| Columna | Fuente | Descripción |
|---|---|---|
| `total_llamadas` | SUM(total_llamadas) | Volumen total en el quarter |
| `llamadas_dias_habiles` | SUM(llamadas_dias_habiles) | Pre-computado en ETL |
| `llamadas_fines_semana` | SUM(llamadas_fines_semana) | Pre-computado en ETL |
| `pct_dias_habiles` | Calculado | % de llamadas en días hábiles |
| `primera_actividad` | MIN(fecha) → DATE | Primer mes con datos |
| `ultima_actividad` | MAX(fecha) → LAST_DAY | Último día del mes más reciente |
| `dias_habiles_sin_actividad` | `ivr_contar_dias_habiles()` | Días hábiles desde última actividad |
| `fecha_seguimiento_1_dia` | `ivr_agregar_dias_habiles(max, 1)` | Fecha de primer seguimiento |
| `fecha_seguimiento_3_dias` | `ivr_agregar_dias_habiles(max, 3)` | Fecha de seguimiento crítico |
| `fecha_escalamiento` | `ivr_agregar_dias_habiles(max, 5)` | Fecha de escalamiento |
| `clasificacion_sla` | Calculado | ACTIVO_HOY / DENTRO_SLA / RIESGO_SLA / FUERA_SLA / VOLUMEN_MEDIO / BAJO_VOLUMEN |
| `pct_del_segmento` | Subconsulta | % que este centro representa en su segmento |

---

## Nivel 5 — Django REST Framework

### Motor común

```python
# services/ivr_reports.py
from django.db import connections

def _call_sp(sp_name, params):
    with connections['ivr'].cursor() as cursor:
        cursor.callproc(sp_name, params)
        cols = [c[0] for c in cursor.description]
        return [dict(zip(cols, row)) for row in cursor.fetchall()]

# Los 7 servicios — todos usan el mismo motor
get_clientes              = lambda q:    _call_sp('sp_rpt_clientes',              [q])
get_centros_transferencia = lambda q, s: _call_sp('sp_rpt_centros_transferencia', [q, s])
get_abandonadas           = lambda q, s: _call_sp('sp_rpt_llamadas_abandonadas',  [q, s])
get_menu_redirigidos      = lambda q, s: _call_sp('sp_rpt_menu_redirigidos',      [q, s])
get_menu_centro           = lambda q, s: _call_sp('sp_rpt_menu_centro',           [q, s])
get_cmenu_error           = lambda q, s: _call_sp('sp_rpt_cMENU_ERROR',           [q, s])
get_centros_xsegmento     = lambda q:    _call_sp('sp_rpt_centros_xsegmento',     [q])
```

### Endpoints

```
GET /api/ivr/reportes/clientes/?quarter=Q01_25
GET /api/ivr/reportes/centros/?quarter=Q01_25&segmento=nacional_A
GET /api/ivr/reportes/abandonadas/?quarter=Q01_25&segmento=todas
GET /api/ivr/reportes/menu-redirigidos/?quarter=Q01_25&segmento=puebla
GET /api/ivr/reportes/menu-centro/?quarter=Q01_25&segmento=todas
GET /api/ivr/reportes/cmenu-error/?quarter=Q03_25&segmento=todas
GET /api/ivr/reportes/centros-xsegmento/?quarter=Q01_25

GET /api/ivr/pipeline/estado/
POST /api/ivr/pipeline/reintentar/   body: {"quarter": "Q02_26"}
```

### Validación de parámetros en vistas

```python
QUARTERS  = {'Q01_25','Q02_25','Q03_25','Q04_25','Q01_26','Q02_26'}
SEGMENTOS = {'todas','nacional_A','nacional_B','puebla'}

def _validar(quarter=None, segmento=None):
    errores = []
    if quarter  and quarter  not in QUARTERS:  errores.append(f'quarter inválido: {quarter}')
    if segmento and segmento not in SEGMENTOS: errores.append(f'segmento inválido: {segmento}')
    return errores
```

---

## Carga histórica inicial

```sql
-- Ejecutar una vez para poblar los 6 quarters históricos.
-- sp_etl_historico incluye pausa de 5s entre pasos para no saturar el servidor.

CALL sp_etl_historico(2025, 1);   -- Q01_25  ~11.6M filas reales  ~9 min
CALL sp_etl_historico(2025, 2);   -- Q02_25  ~13.6M filas reales  ~10 min
CALL sp_etl_historico(2025, 3);   -- Q03_25  ~11.5M filas reales  ~9 min
CALL sp_etl_historico(2025, 4);   -- Q04_25  estimado             ~9 min
CALL sp_etl_historico(2026, 1);   -- Q01_26  estimado             ~9 min
-- Q02_26: el evt_etl_diario lo maneja desde hoy
-- Total backfill: ~47 min (5 quarters + pausas)
```

---

## Orden de implementación v2.0

```
PASO 1  funciones_utilidad.sql     → 7 funciones (Nivel 0)
PASO 2  schema_base_ivr.sql        → 5 tablas (base_ivr_*, control)
PASO 3  sp_etl_pipeline.sql        → 5 SPs ETL (Niveles 2 y 3)
PASO 4  sp_rpt_reportes.sql        → 7 SPs reporte (Nivel 4)
PASO 5  Event Scheduler            → evt_etl_diario (Nivel 1A)
PASO 6  management command         → run_etl + heartbeat (Nivel 1B)
PASO 7  sp_etl_historico           → carga de Q01_25..Q01_26
PASO 8  Django DRF                 → services + views + urls (Nivel 5)
```

---

## Restricciones técnicas que condicionan el diseño

| ID | Restricción | Impacto en v2.0 |
|---|---|---|
| CNST-ETL-001 | Solo SELECT en `tbl_historico_*` | No se crean índices en la fuente — full scan inevitable |
| CNST-ETL-005 | Sin índices en tablas fuente | Chunks por mes para controlar undo log |
| CNST-ETL-007 | MariaDB 10.1.48 sin window functions | Subconsultas en lugar de `OVER(PARTITION BY)` |
| CNST-ETL-008 | Nombre de tabla dinámico | `PREPARE/EXECUTE` en sp_etl_base_detalle y sp_etl_base_clientes |
| CNST-003 | ETL cada 6-12h | `job_config.min_intervalo_h = 6` |
| ADR-BACK-012 | Sin Redis/RabbitMQ | Heartbeat con `threading.Thread` en el management command |
| P-14 (resuelta) | fn_es_dia_habil del cliente puede no existir | Creadas propias con prefijo `ivr_` |

---

## Ver también

- `ANALISIS-ARQUITECTURA-ETL.md` — análisis que motivó esta versión
- `FLUJO-ETL-COMPLETO.md` — v1.0 (referencia histórica)
- `TBL-HISTORICO-ANOMALIAS.md` — G-29, NK90 y demás condiciones de calidad
- `PERFILES-QUARTER.md` — seed de datos por quarter
- `MAPEO-DID-SEGMENTOS.md` — DIDs y etiquetas canónicas
- `REPORTE-C-MENU.md` — fuente de los VDNs y mixed case (H-1)
- `decisiones.md` (IACT-docs) — D-ETL-001..011

