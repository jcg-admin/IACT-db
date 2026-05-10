# Análisis ETL — IACT IVR Pipeline

**Fecha de análisis:** 2026-05-06
**Fuentes:** WPs `2026-05-02-07-12-32-pipeline-uc-deepening`,
`2026-05-02-09-54-55-source-corrections-pipeline` y
`ADR-BACK-012-apscheduler-tareas-programadas`.
**Estado:** Diseño confirmado con el equipo — implementación pendiente.

---

## 1. Pregunta central: ¿SP o Job?

**Respuesta:** Ambos, con roles distintos y complementarios.

| Componente | Tipo | Quién | Responsabilidad |
|---|---|---|---|
| `evt_etl_diario` | MySQL Event (Job) | MariaDB | Disparador: lanza `sp_etl_maestro()` a las 02:00 AM |
| `sp_etl_maestro` | Stored Procedure | MariaDB | Orquestador: calcula quarter, verifica concurrencia |
| `sp_etl_base_detalle` | Stored Procedure | MariaDB | ETL real: lee `tbl_historico_*`, normaliza, agrega |
| `sp_etl_base_clientes` | Stored Procedure | MariaDB | ETL real: COUNT DISTINCT → `base_ivr_clientes` |
| `sp_etl_historico` | Stored Procedure | MariaDB | Carga manual de quarters históricos |
| `run_etl` management command | Django + APScheduler | Django | Disparador alternativo: lanza `CALL sp_etl_maestro()` |
| `sp_rpt_*` (7 SPs) | Stored Procedures | MariaDB | Reportes: llamados por Django bajo demanda |

---

## 2. Dos mecanismos de disparo — no uno

Un hallazgo crítico del ADR-BACK-012: **hay DOS mecanismos de disparo del ETL**,
no uno. Coexisten con roles complementarios:

```
Mecanismo 1 — MySQL Event Scheduler (producción automática):
  evt_etl_diario (02:00 AM)
    └── CALL sp_etl_maestro()

Mecanismo 2 — APScheduler + Django management command (control Django):
  APScheduler (cron trigger 02:00–04:00)
    └── python manage.py run_etl
          └── INSERT etl_runs (estado='en_ejecucion')
          └── cursor.callproc('sp_etl_maestro', [...])
          └── UPDATE etl_runs (estado='exitoso'/'fallido')
```

El ADR-BACK-012 documenta que el ETL fue inicialmente diseñado como
"ETL en Python cada 6 horas" (versión incorrecta). La corrección
(D-ETL-003) establece que Django **no ejecuta el ETL directamente** —
solo lanza el `CALL` al SP. El MySQL Event sigue siendo el disparador
principal automático. El management command `run_etl` es para:
- Reintentos manuales desde la UI de administración (UC-PIP-04)
- Backfill histórico: `manage.py run_etl --quarter Q3_25 --force`

**CNST-008:** La ventana de ejecución es 6-12 horas. Ventana preferente
02:00–04:00 hora local. Nunca menos de 6 horas entre ejecuciones.

---

## 3. Por qué 2 tablas base y no 7 tablas de reporte

El diseño anterior contemplaba 7 tablas `rpt_*` (una por reporte).
Fue descartado por la siguiente razón matemática:

```
tbl_historico_* — sin índices (CNST-ETL-005)
                — ~11-14M filas por quarter
                — full table scan inevitable en cada lectura

Diseño 7 tablas rpt_*:
  7 SPs de ETL × 1 scan cada uno = 7 scans por noche
  → 14M filas × 7 = 98M filas procesadas cada noche

Diseño 2 tablas base (adoptado):
  2 SPs de ETL × 1 scan cada uno = 2 scans por noche
  → 14M filas × 2 = 28M filas procesadas cada noche
  → Los 7 reportes consultan miles de filas indexadas en base_ivr_*
```

---

## 4. Flujo detallado paso a paso

```
PASO 1 — Validaciones iniciales
  ¿Hay otro job con status='RUNNING' en las últimas 6 horas?
    SÍ → INSERT job_execution_log (status='SKIP') y salir
    NO → INSERT job_execution_log (status='RUNNING'), continuar

PASO 2 — Determinar quarter y tabla fuente (dinámico)
  v_year    = YEAR(CURDATE())       → 2026
  v_qnum    = QUARTER(CURDATE())    → 2
  v_quarter = 'Q02_26'
  v_table   = 'tbl_historico_t2_2026'
  v_inicio  = '2026-04-01'
  v_fin     = '2026-06-30'
  (Funciona para cualquier año sin modificar el código)

PASO 3 — sp_etl_base_detalle (1er scan — el más costoso)
  START TRANSACTION
    DELETE FROM base_ivr_detalle WHERE quarter_name = 'Q02_26'
    INSERT INTO base_ivr_detalle
      SELECT (GROUP BY fecha_mes, segmento, centro, menu, opcion)
      FROM tbl_historico_t2_2026        ← PREPARE/EXECUTE (tabla dinámica)
      WHERE dFecha BETWEEN @inicio AND @fin
        AND cDID_800Transfer IN (19020084, 19028031, 19020001)
      GROUP BY 2,3,4,5,6
  COMMIT  (si falla → ROLLBACK automático, datos anteriores conservados)

PASO 4 — sp_etl_base_clientes (2do scan — COUNT DISTINCT no aditivo)
  START TRANSACTION
    DELETE FROM base_ivr_clientes WHERE quarter_name = 'Q02_26'
    INSERT INTO base_ivr_clientes
      SELECT segmento, COUNT(DISTINCT cTelefono_Digitado)
      FROM tbl_historico_t2_2026
      WHERE ... GROUP BY segmento   → 3 filas resultado (una por segmento)
  COMMIT

PASO 5 — Validación post-load
  COUNT(*) en base_ivr_detalle WHERE quarter='Q02_26' > 0?
    NO → status='PARTIAL', notificar
  COUNT(*) en base_ivr_clientes WHERE quarter='Q02_26' = 3 filas?
    NO → status='PARTIAL', notificar

PASO 6 — Actualizar control
  UPDATE job_execution_log SET status='SUCCESS', end_time=NOW()
  UPDATE etl_runs SET estado='exitoso' (si fue disparado via Django)

PASO 7 — Notificación (buzón interno — CNST-001: sin email)
  INSERT INTO internal_messages → usuarios con role='SYSTEM_ADMIN'
```

---

## 5. Tablas involucradas

### Tablas fuente (propiedad del cliente — solo lectura)

```
tbl_historico_t1_2025   Q1 2025   2025-01-01 → 2025-03-31   ~11.6M filas (REAL)
tbl_historico_t2_2025   Q2 2025   2025-04-01 → 2025-06-30   ~13.6M filas (REAL)
tbl_historico_t3_2025   Q3 2025   2025-07-01 → 2025-09-30   ~11.5M filas (REAL)
tbl_historico_t4_2025   Q4 2025   2025-10-01 → 2025-12-31   estimado
tbl_historico_t1_2026   Q1 2026   2026-01-01 → 2026-03-31   estimado
tbl_historico_t2_2026   Q2 2026   2026-04-01 → en curso      parcial
```

Sin índices. Full table scan en cada ejecución del ETL.

### Tablas destino ETL (propiedad de IACT — lectura/escritura)

**`base_ivr_detalle`** — grain por `(quarter, mes, segmento, centro, menu, opcion)`.
Contiene métricas aditivas: `total_llamadas`, `misma_linea`, `linea_diferente`,
`no_digito_telefono`. Con índices. Miles de filas por quarter.

**`base_ivr_clientes`** — grain por `(quarter, segmento)`. Contiene
`clientes_unicos` (COUNT DISTINCT — no aditivo). Con índices. 3 filas por quarter.

### Tablas de control (propiedad de IACT)

**`job_execution_log`** — tracking del MySQL Event Scheduler:
`job_name`, `quarter_name`, `start_time`, `end_time`, `status`,
`records_extracted`, `records_loaded`, `error_message`.

**`etl_runs`** — tracking del management command Django (D-ETL-002):
`tabla_origen`, `trimestre`, `iniciado_en`, `finalizado_en`, `estado`,
`registros_base`, `mensaje_error`, `ejecutado_por`.

**`job_config`** — configuración por job: `is_enabled`, `timeout_seconds`.

> Nota: tanto `job_execution_log` como `etl_runs` cubren tracking de ETL,
> desde dos capas distintas (MariaDB nativo vs Django). Ambas deben crearse.

### SPs de reporte (7 — llamados por Django)

| SP | Fuente | Descripción |
|---|---|---|
| `sp_rpt_centros_transferencia` | `base_ivr_detalle` | Detalle: fecha×segmento×centro×menu×opcion |
| `sp_rpt_centros_xsegmento` | `base_ivr_detalle` | KPIs por segmento con clasificación SLA y días hábiles |
| `sp_rpt_llamadas_abandonadas` | `base_ivr_detalle` | Abandono: VACIO + cliente_colgo + SinOpcion_Cabecera (~27-28%) |
| `sp_rpt_menu_redirigidos` | `base_ivr_detalle` | Perspectiva menú→centro |
| `sp_rpt_menu_centro` | `base_ivr_detalle` | Perspectiva centro→menú+opción |
| `sp_rpt_cMENU_ERROR` | `base_ivr_detalle` | Anomalías: cMenu con número de teléfono |
| `sp_rpt_clientes` | `base_ivr_clientes` | Clientes únicos por segmento/quarter |

---

## 6. Normalización de datos durante el ETL

### cDID_800Transfer → segmento

| DID crudo | Segmento normalizado |
|---|---|
| `19020084` | `'Puebla'` |
| `19028031` | `'nacional_A'` |
| `19020001` | `'nacional_B'` |

### cDID_Centro_Transferencia → centro_transferencia

Datos reales Q1 2025 (11.6M registros):

| Longitud | Clasificación | Registros | % | CASE en ETL |
|---|---|---|---|---|
| 0 | CASO_VACIO | 1,514 | 0.01% | → `'CASO_NULL'` |
| 6 | CONFIGURACION_FIJA_6_DIG | 6 | 0.00% | → valor tal cual |
| **8** | **CONFIGURACION_FIJA_8_DIG** | **9,568,639** | **82.18%** | → **valor tal cual (VDN dominante)** |
| 13 | CASO_CLIENTE_COLGO | 1,408,555 | 12.10% | → `'CLIENTE_COLGO'` |
| 16 | POSIBLE_EMBEBIDO_16_DIG | 39,951 | 0.34% | → `LEFT(campo, 6)` |
| **17** | **POSIBLE_EMBEBIDO_17_DIG** | **620,730** | **5.33%** | → `LEFT(campo, 7)` |
| 24-25 | POSIBLE_EMBEBIDO | 4,284 | 0.04% | → `LEFT(campo, len-10)` |

El VDN dominante es **8 dígitos**, no 7. La regla `LENGTH > 10 → LEFT(campo, LENGTH - 10)`
cubre todos los casos NK90 correctamente.

El CASE debe respetar este orden para evitar colisiones:
```sql
CASE
    WHEN TRIM(cDID_Centro_Transferencia) IS NULL
      OR TRIM(cDID_Centro_Transferencia) = ''        THEN 'CASO_NULL'
    WHEN cDID_Centro_Transferencia = 'cliente_colgo' THEN 'CLIENTE_COLGO'
    WHEN cDID_Centro_Transferencia REGEXP '^0+$'     THEN 'CASO_ERROR_CEROS'
    WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]'  THEN 'ERROR_CARACTER_INICIAL'
    WHEN LENGTH(cDID_Centro_Transferencia) > 10
        THEN LEFT(cDID_Centro_Transferencia,
                  LENGTH(cDID_Centro_Transferencia) - 10)
    ELSE cDID_Centro_Transferencia
END
```

### cMenu → menu

| Condición | Valor normalizado |
|---|---|
| NULL, `''`, `'sin cMenu'` | `'VACIO'` |
| Numérico puro `REGEXP '^[0-9]+'` | valor tal cual (detectado por `sp_rpt_cMENU_ERROR`) |
| `'Desborde_Cabecera'` | `'Desborde_Cabecera'` (valor válido — no normalizar) |
| Cualquier otro | valor tal cual |

### cOpcion → opcion

`COALESCE(NULLIF(TRIM(cOpcion), ''), 'SIN_OPCION')`

Los datos reales confirman que `cliente_colgo`, `Desborde_Promocional`,
`Marque3` y `SinOpcion_Cabecera` tienen opción NULL en la fuente — el
ETL debe normalizarlos a `'SIN_OPCION'`.

---

## 7. Restricciones técnicas que condicionan el diseño

| ID | Restricción | Impacto en el diseño |
|---|---|---|
| CNST-ETL-001 | Solo lectura en `tbl_historico_*` | No se pueden crear índices en la fuente |
| CNST-ETL-005 | `tbl_historico_*` sin índices | Full table scan inevitable — ETL costoso |
| CNST-ETL-007 | MariaDB 10.1.48 sin window functions | Subconsultas reemplazan `OVER(PARTITION BY)` |
| CNST-ETL-008 | Nombre de tabla dinámico | `PREPARE/EXECUTE` obligatorio |
| CNST-003 | Frecuencia ETL 6-12h | Ventana preferente 02:00–04:00 |
| CNST-001 | Sin email | Notificaciones al buzón interno únicamente |
| ADR-BACK-012 | Sin Redis, sin RabbitMQ | APScheduler in-process para el management command |

---

## 8. Restricciones de negocio relevantes

**BR-016 — Tasa de abandono (CORREGIDA):**
Datos reales Agosto 2025: Puebla 24.9%, Nacional 30.3% (sin Marque3).
Con Marque3: Nacional 32.4% → nivel crítico. Umbrales recalibrados:
`< 20%` óptimo, `20-30%` aceptable, `> 30%` crítico.

**D-23 — Total Nacional = nacional_A + nacional_B:**
`nacional_A` domina (~96-99%). `nacional_B` es residual pero nunca omitir.

---

## 9. Riesgos identificados

| ID | Riesgo | Prob. | Impacto | Mitigación |
|---|---|---|---|---|
| R-01 | ETL supera ventana nocturna | Media | Alto | Monitorear `duracion_min` en `job_execution_log` |
| R-02 | Job concurrente | Baja | Medio | SP maestro verifica `status='RUNNING'` últimas 6h |
| R-03 | PREPARE/EXECUTE con tabla dinámica | Baja | Medio | Nombre de tabla viene de lógica interna — sin superficie de inyección |
| R-04 | `tbl_historico_tN_YYYY` no existe aún | Media | Alto | Validar existencia de la tabla al inicio del SP maestro |
| R-05 | Normalización NK90 incorrecta post-migración IPVR | Media | Medio | Agregar flag o fecha de corte cuando IPVR se active |
| R-06 | ROLLBACK silencioso: datos anteriores conservados sin aviso | Media | Medio | `job_execution_log` debe ser consultado por Django para informar al usuario |
| R-07 | `base_ivr_clientes` con menos de 3 filas | Baja | Medio | Validación explícita en PASO 5 |
| R-08 | `sp_rpt_llamadas_abandonadas` sub-reporta abandono | Alta | Alto | Implementar con las 3 categorías desde el inicio |
| R-09 | MariaDB 10.1.48 sin soporte activo | Baja-Media | Alto | Diseño usa solo funcionalidad básica compatible con versiones mayores |
| R-10 | Dos tablas de tracking (`job_execution_log` vs `etl_runs`) | Media | Medio | Definir cuál es la fuente de verdad para los UCs de monitoreo |

---

## 10. Lo que sigue — secuencia de implementación

### Fase 1 — Tablas base y control (prerequisito de todo lo demás)

```sql
-- En ivr_legacy (MariaDB)
CREATE TABLE base_ivr_detalle ...      -- tabla base con índices
CREATE TABLE base_ivr_clientes ...     -- clientes únicos
CREATE TABLE job_execution_log ...     -- tracking MySQL Event
CREATE TABLE job_config ...            -- configuración por job
CREATE TABLE etl_runs ...              -- tracking management command Django
```

### Fase 2 — SPs ETL (orden estricto por dependencias)

1. `sp_etl_base_detalle(quarter, inicio, fin, table)` — ETL principal
2. `sp_etl_base_clientes(quarter, inicio, fin, table)` — ETL secundario
3. `sp_etl_maestro()` — orquestador (depende de los dos anteriores)
4. `sp_etl_historico(year, quarter_num)` — wrapper para carga histórica

### Fase 3 — Event Scheduler (producción)

```sql
SET GLOBAL event_scheduler = ON;
CREATE EVENT evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS '2026-05-07 02:00:00'
DO CALL sp_etl_maestro();
```

### Fase 4 — Carga histórica de quarters pasados

```sql
CALL sp_etl_historico(2025, 1);   -- Q01_25  (11.6M filas reales)
CALL sp_etl_historico(2025, 2);   -- Q02_25  (13.6M filas reales)
CALL sp_etl_historico(2025, 3);   -- Q03_25  (11.5M filas reales)
CALL sp_etl_historico(2025, 4);   -- Q04_25
CALL sp_etl_historico(2026, 1);   -- Q01_26
-- Q02_26: el Event Scheduler lo maneja desde hoy
```

### Fase 5 — SPs de reporte

```
sp_rpt_clientes                  ← solo base_ivr_clientes
sp_rpt_centros_transferencia     ← solo base_ivr_detalle
sp_rpt_llamadas_abandonadas      ← incluir las 3 categorías de abandono
sp_rpt_menu_redirigidos          ← confirmar P-13 antes de implementar
sp_rpt_menu_centro               ← solo base_ivr_detalle
sp_rpt_cMENU_ERROR               ← solo base_ivr_detalle (solo numéricos)
sp_rpt_centros_xsegmento         ← ÚLTIMO: depende de fn_es_dia_habil, fn_contar_dias
```

### Fase 6 — Management command + APScheduler

```python
# manage.py run_etl
# APScheduler trigger cron 02:00 AM
# INSERT etl_runs → CALL sp_etl_maestro() → UPDATE etl_runs
```

### Fase 7 — Integración Django vistas

```python
cursor.callproc('sp_rpt_*', [params])  # Sin modelos ORM para datos IVR
```

---

## 11. Tablas creadas vs tablas necesarias

### Estado actual en IACT-db

```
CREADAS (schema_historico.sql):
  tbl_historico_t1_2025  ✓
  tbl_historico_t2_2025  ✓
  tbl_historico_t3_2025  ✓
  tbl_historico_t4_2025  ✓
  tbl_historico_t1_2026  ✓
  tbl_historico_t2_2026  ✓

PENDIENTES DE CREAR:
  base_ivr_detalle        — prerequisito de los 7 SPs de reporte
  base_ivr_clientes       — prerequisito de sp_rpt_clientes
  job_execution_log       — prerequisito de sp_etl_maestro
  job_config              — prerequisito de sp_etl_maestro
  etl_runs                — prerequisito del management command Django
```

Las tablas fuente están listas. Las tablas destino del ETL son el siguiente
paso crítico antes de poder crear cualquier SP.

---

## 12. Cómo Django interactúa con el ETL

```python
from django.db import connections

# Monitoreo (job_execution_log o etl_runs)
def get_etl_status():
    with connections['ivr'].cursor() as cursor:
        cursor.execute("SELECT ... FROM job_execution_log ORDER BY start_time DESC LIMIT 10")
        return cursor.fetchall()

# Reintentar ETL manualmente (UC-PIP-04)
def retry_etl(quarter):
    with connections['ivr'].cursor() as cursor:
        cursor.execute("INSERT INTO etl_runs (trimestre, estado, ejecutado_por) VALUES (%s, 'en_ejecucion', 'admin')", [quarter])
        cursor.callproc('sp_etl_maestro', [])
        cursor.execute("UPDATE etl_runs SET estado='exitoso' WHERE ...")

# Reportes (bajo demanda)
def get_centros_transferencia(quarter, segmento):
    with connections['ivr'].cursor() as cursor:
        cursor.callproc('sp_rpt_centros_transferencia', [quarter, segmento])
        columns = [col[0] for col in cursor.description]
        return [dict(zip(columns, row)) for row in cursor.fetchall()]
```

---

## 13. Pendientes antes de implementar

| # | Pregunta | Bloquea |
|---|---|---|
| P-13 | ¿`sp_rpt_menu_redirigidos` necesita columnas de la vista `llamadas_QN` (etiquetas, nidMQ)? | Si SÍ: ETL necesita 3er scan o tabla base adicional |
| P-14 | ¿Existen `fn_es_dia_habil`, `fn_contar_dias_habiles`, `fn_agregar_dias_habiles` en MariaDB del cliente? | Si NO: deben crearse antes de `sp_rpt_centros_xsegmento` |
| R-10 | ¿`job_execution_log` o `etl_runs` es la fuente de verdad para los UCs de monitoreo? | Diseño de los UCs PIP-01/02/03 |

---

## Ver también

- `ETL-SPS-REPORTE.md` — análisis profundo de los 7 SPs de reporte
- `HISTORICO-IVR.md` — schema y seed de las tablas fuente
- `datos-reales/` — datos reales de producción Q1-Q3 2025
- `ADR-BACK-012-apscheduler-tareas-programadas` en IACT-docs
- WP `etl-job-flow-design.md` — diseño original del flujo
- WP `decisions.md` — decisiones confirmadas (D-ETL-001..011)
