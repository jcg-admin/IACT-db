# Flujo ETL completo — Del origen al consumo por Django

**Fecha:** 2026-05-06
**Fuentes:** ETL-ANALISIS.md, ETL-SPS-REPORTE.md, decisions.md (D-ETL-001..011),
             MAPEO-DID-SEGMENTOS.md, REPORTE-*.md, scripts SQL de producción.

---

## Visión general en un diagrama

```
CLIENTE (solo lectura)          IACT — MariaDB mismo servidor
──────────────────────          ──────────────────────────────────────────────

tbl_historico_t1_2025           DISPARO
tbl_historico_t2_2025    ──▶    evt_etl_diario (02:00 AM MySQL Event)
tbl_historico_t3_2025    ──▶    manage.py run_etl (APScheduler Django)
tbl_historico_t4_2025           │
tbl_historico_t1_2026           ▼
tbl_historico_t2_2026    ──▶    sp_etl_maestro()
                                │  ├── sp_etl_base_detalle() ──▶ base_ivr_detalle
                                │  └── sp_etl_base_clientes() ──▶ base_ivr_clientes
                                │         │
                                │   job_execution_log / etl_runs
                                │
                                ▼
                          sp_rpt_centros_transferencia()
                          sp_rpt_centros_xsegmento()
                          sp_rpt_llamadas_abandonadas()    ◀── DJANGO REST
                          sp_rpt_menu_redirigidos()            cursor.callproc()
                          sp_rpt_menu_centro()
                          sp_rpt_cMENU_ERROR()
                          sp_rpt_clientes()
```

---

## Capa 0 — Datos fuente (propiedad del cliente)

### Tablas

```
tbl_historico_tN_YYYY    N=1..4  YYYY=2025,2026,...
```

El particionamiento es **físico por quarter**, no lógico. No existe una
tabla única con columna `quarter`. El ETL lee una tabla diferente por
trimestre usando `PREPARE/EXECUTE` con el nombre dinámico.

### Schema confirmado de cada tabla

| Columna | Tipo | Descripción |
|---|---|---|
| `dFecha` | DATE | Fecha de la llamada (filtro principal del ETL) |
| `dHoraInicio` | DATETIME | Inicio — 38.8% de registros tienen ini > fin (G-29) |
| `dHoraFin` | DATETIME | Fin — puede ser anterior al inicio (bug G-29) |
| `cDID_800Transfer` | VARCHAR(20) | DID de entrada: `19028031` / `19020001` / `19020084` |
| `cDID_Centro_Transferencia` | VARCHAR(50) | VDN destino — requiere normalización NK90 |
| `cMenu` | VARCHAR(100) | Menú IVR navegado — mixed case, puede ser NULL/vacío |
| `cOpcion` | VARCHAR(100) | Opción dentro del menú — NULLABLE |
| `cTelefono_Origen` | VARCHAR(20) | ANI — siempre presente |
| `cTelefono_Digitado` | VARCHAR(20) | Número digitado — 21.2% NULL |
| `cEtiquetacliente` | VARCHAR(200) | Etiquetas CSV raw por registro |

### Condiciones de calidad que el ETL debe manejar

| Condición | Prevalencia | Tratamiento en ETL |
|---|---|---|
| `dHoraInicio > dHoraFin` (G-29) | 38.8% | ABS en cálculo de duración: `CASE WHEN ini<=fin THEN fin-ini ELSE ini-fin END` |
| `cMenu IS NULL` o vacío | ~8% | → sentinel `'VACIO'` |
| `cDID_Centro` = `'cliente_colgo'` | 27.4% | → sentinel `'CLIENTE_COLGO'` |
| `cDID_Centro` NULL o vacío | 1.3% | → sentinel `'CASO_NULL'` |
| `cDID_Centro` solo ceros | ~0.75% Puebla Q02+ | → sentinel `'CASO_ERROR_CEROS'` |
| `cDID_Centro` NK90 len>10 | 5.67% | → `LEFT(campo, LENGTH-10)` |
| `cDID_Centro` char no numérico | 0.05% | → sentinel `'ERROR_CARACTER_INICIAL'` |
| `cTelefono_Digitado IS NULL` | 21.2% | → columna `no_digito_telefono += 1` |
| `cMenu` contiene teléfono | 1.2% | → pasa tal cual; `sp_rpt_cMENU_ERROR` lo detecta |

### Restricciones de acceso

| Restricción | Impacto |
|---|---|
| GRANT SELECT únicamente (CNST_007) | No se pueden crear índices en la fuente |
| Sin índices en `tbl_historico_*` (CNST-ETL-005) | Full table scan obligatorio por ejecución |
| MariaDB 10.1.48 (CNST-ETL-007) | Sin window functions (`ROW_NUMBER`, `RANK`, etc.) |
| Nombre de tabla dinámico (CNST-ETL-008) | `PREPARE/EXECUTE` obligatorio en los SPs |

---

## Capa 1 — Disparo del ETL

Hay dos mecanismos. Coexisten con roles distintos:

### Mecanismo A — MySQL Event Scheduler (producción automática)

```sql
-- Se activa una vez al día a las 02:00 AM
CREATE EVENT evt_etl_diario
ON SCHEDULE EVERY 1 DAY
STARTS '2026-05-07 02:00:00'
DO CALL sp_etl_maestro();
```

- Corre sin intervención humana
- No registra en `etl_runs` (solo en `job_execution_log`)
- El SP maestro maneja la concurrencia: si ya hay un job corriendo,
  inserta `status='SKIP'` y sale

### Mecanismo B — Django management command (control manual)

```python
# manage.py run_etl  — invocado por APScheduler o por un admin desde la UI
def handle(self, *args, **options):
    quarter = options.get('quarter') or calcular_quarter_actual()
    with connections['ivr'].cursor() as cursor:
        # 1. Registrar inicio
        cursor.execute("""
            INSERT INTO etl_runs (trimestre, iniciado_en, estado, ejecutado_por)
            VALUES (%s, NOW(), 'en_ejecucion', %s)
        """, [quarter, options.get('ejecutado_por', 'scheduler')])
        run_id = cursor.lastrowid

        # 2. Ejecutar el ETL
        try:
            cursor.callproc('sp_etl_maestro', [])
            cursor.execute("""
                UPDATE etl_runs SET estado='exitoso', finalizado_en=NOW()
                WHERE id = %s
            """, [run_id])
        except Exception as e:
            cursor.execute("""
                UPDATE etl_runs SET estado='fallido', finalizado_en=NOW(),
                mensaje_error=%s WHERE id = %s
            """, [str(e), run_id])
            raise
```

- Usado para reintentos manuales (UC_PIP_04)
- Registra en `etl_runs` (fuente de verdad para la UI Django)
- Permite `--quarter Q3_25 --force` para backfill histórico

---

## Capa 2 — Orquestación (sp_etl_maestro)

```sql
CREATE PROCEDURE sp_etl_maestro()
BEGIN
    -- PASO 1: Verificar concurrencia
    IF EXISTS (
        SELECT 1 FROM job_execution_log
        WHERE status = 'RUNNING'
          AND start_time > DATE_SUB(NOW(), INTERVAL 6 HOUR)
    ) THEN
        INSERT INTO job_execution_log (job_name, status, start_time)
        VALUES ('etl_diario', 'SKIP', NOW());
        LEAVE sp_etl_maestro;
    END IF;

    -- PASO 2: Calcular quarter y tabla fuente (dinámico — funciona cualquier año)
    SET v_year    = YEAR(CURDATE());
    SET v_qnum    = QUARTER(CURDATE());
    SET v_quarter = CONCAT('Q0', v_qnum, '_', RIGHT(v_year, 2));
    SET v_table   = CONCAT('tbl_historico_t', v_qnum, '_', v_year);
    SET v_inicio  = MAKEDATE(v_year, 1) + INTERVAL ((v_qnum-1)*3) MONTH;
    SET v_fin     = v_inicio + INTERVAL 3 MONTH - INTERVAL 1 DAY;

    -- PASO 3: Registrar inicio
    INSERT INTO job_execution_log
        (job_name, quarter_name, tabla_origen, start_time, status)
    VALUES
        ('etl_diario', v_quarter, v_table, NOW(), 'RUNNING');
    SET v_log_id = LAST_INSERT_ID();

    -- PASO 4: Ejecutar ETL (con manejo de errores)
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            UPDATE job_execution_log
            SET status='FAILED', end_time=NOW(), error_message=@error
            WHERE id = v_log_id;
        END;

        CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table);
        CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table);
    END;

    -- PASO 5: Validación post-load
    SELECT COUNT(*) INTO v_count_det
    FROM base_ivr_detalle WHERE trimestre = v_quarter;

    SELECT COUNT(*) INTO v_count_cli
    FROM base_ivr_clientes WHERE trimestre = v_quarter;

    SET v_status = IF(v_count_det > 0 AND v_count_cli = 3, 'SUCCESS', 'PARTIAL');

    UPDATE job_execution_log
    SET status      = v_status,
        end_time    = NOW(),
        records_base = v_count_det
    WHERE id = v_log_id;
END;
```

---

## Capa 3A — ETL principal (sp_etl_base_detalle)

Este SP hace el único scan costoso de `tbl_historico_*` y produce
`base_ivr_detalle` — la tabla que alimenta 6 de los 7 SPs de reporte.

```sql
CREATE PROCEDURE sp_etl_base_detalle(
    IN p_quarter VARCHAR(10),   -- 'Q02_26'
    IN p_inicio  DATE,          -- '2026-04-01'
    IN p_fin     DATE,          -- '2026-06-30'
    IN p_table   VARCHAR(100)   -- 'tbl_historico_t2_2026'
)
BEGIN
    -- DELETE idempotente: permite reprocesar sin duplicar
    DELETE FROM base_ivr_detalle WHERE trimestre = p_quarter;

    -- PREPARE es necesario porque el nombre de tabla es dinámico
    SET @sql = CONCAT('
        INSERT INTO base_ivr_detalle
        SELECT
            ?, DATE_FORMAT(dFecha, "%Y%m") AS fecha,
            CASE cDID_800Transfer
                WHEN 19028031 THEN "nacional_A"
                WHEN 19020001 THEN "nacional_B"
                WHEN 19020084 THEN "puebla"
            END AS segmento,
            -- Normalización cDID_Centro_Transferencia (orden crítico)
            CASE
                WHEN TRIM(cDID_Centro_Transferencia) IS NULL
                  OR TRIM(cDID_Centro_Transferencia) = ""   THEN "CASO_NULL"
                WHEN cDID_Centro_Transferencia = "cliente_colgo"
                                                             THEN "CLIENTE_COLGO"
                WHEN cDID_Centro_Transferencia REGEXP "^0+$" THEN "CASO_ERROR_CEROS"
                WHEN cDID_Centro_Transferencia REGEXP "^[^0-9]"
                                                             THEN "ERROR_CARACTER_INICIAL"
                WHEN LENGTH(cDID_Centro_Transferencia) > 10
                    THEN LEFT(cDID_Centro_Transferencia,
                              LENGTH(cDID_Centro_Transferencia) - 10)
                ELSE cDID_Centro_Transferencia
            END AS centro_transferencia,
            -- Normalización cMenu
            CASE
                WHEN cMenu IS NULL
                  OR TRIM(cMenu) = ""
                  OR cMenu = "sin cMenu"    THEN "VACIO"
                ELSE cMenu                  -- mixed case — el SP de reporte aplica UPPER()
            END AS menu,
            -- Normalización cOpcion
            COALESCE(NULLIF(TRIM(cOpcion), ""), "SIN_OPCION") AS opcion,
            -- Métricas aditivas (pueden sumarse entre filas)
            COUNT(*) AS total_llamadas,
            SUM(cTelefono_Origen = cTelefono_Digitado)               AS misma_linea,
            SUM(cTelefono_Origen != cTelefono_Digitado
                AND cTelefono_Digitado IS NOT NULL)                   AS linea_diferente,
            SUM(cTelefono_Digitado IS NULL)                          AS no_digito_telefono
        FROM ', p_table, '
        WHERE dFecha BETWEEN ? AND ?
          AND cDID_800Transfer IN (19020084, 19028031, 19020001)
        GROUP BY 2, 3, 4, 5, 6
    ');
    PREPARE stmt FROM @sql;
    SET @q = p_quarter, @i = p_inicio, @f = p_fin;
    EXECUTE stmt USING @q, @i, @f;
    DEALLOCATE PREPARE stmt;
END;
```

**Grain de base_ivr_detalle:** una fila por combinación única de
`(trimestre, fecha_mes, segmento, centro_transferencia, menu, opcion)`.

Con 11-14M registros en la fuente y ~126 combinaciones reales de
`menu × opcion`, el resultado es del orden de miles de filas por
quarter — no millones. Los índices en `base_ivr_detalle` hacen que
las 7 queries de reporte sean instantáneas.

---

## Capa 3B — ETL secundario (sp_etl_base_clientes)

Second scan, separado porque `COUNT(DISTINCT)` no es aditivo — no
puede calcularse desde `base_ivr_detalle`.

```sql
CREATE PROCEDURE sp_etl_base_clientes(
    IN p_quarter VARCHAR(10),
    IN p_inicio  DATE,
    IN p_fin     DATE,
    IN p_table   VARCHAR(100)
)
BEGIN
    DELETE FROM base_ivr_clientes WHERE trimestre = p_quarter;

    SET @sql = CONCAT('
        INSERT INTO base_ivr_clientes (trimestre, segmento, clientes_unicos)
        SELECT
            ?,
            CASE cDID_800Transfer
                WHEN 19028031 THEN "nacional_A"
                WHEN 19020001 THEN "nacional_B"
                WHEN 19020084 THEN "puebla"
            END AS segmento,
            COUNT(DISTINCT cTelefono_Origen) AS clientes_unicos
            -- NOTA P-NEW-04: pendiente confirmar si es cTelefono_Origen
            -- o cTelefono_Digitado. Datos reales apuntan a cTelefono_Origen.
        FROM ', p_table, '
        WHERE dFecha BETWEEN ? AND ?
          AND cDID_800Transfer IN (19020084, 19028031, 19020001)
        GROUP BY segmento
    ');
    PREPARE stmt FROM @sql;
    SET @q = p_quarter, @i = p_inicio, @f = p_fin;
    EXECUTE stmt USING @q, @i, @f;
    DEALLOCATE PREPARE stmt;
    -- Resultado: 3 filas (una por segmento)
END;
```

---

## Capa 4 — Tablas intermedias (Base Analítica IVR)

### base_ivr_detalle

```sql
CREATE TABLE base_ivr_detalle (
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    trimestre            VARCHAR(10)    NOT NULL,  -- 'Q01_25'
    fecha                VARCHAR(6)     NOT NULL,  -- '202501' (YYYYMM)
    segmento             VARCHAR(20)    NOT NULL,  -- 'nacional_A'|'nacional_B'|'puebla'
    centro_transferencia VARCHAR(100)   NOT NULL,  -- VDN normalizado o sentinel
    menu                 VARCHAR(100)   NOT NULL,  -- valor raw (no UPPER)
    opcion               VARCHAR(100)   NOT NULL,  -- o 'SIN_OPCION'
    total_llamadas       INT            NOT NULL DEFAULT 0,
    misma_linea          INT            NOT NULL DEFAULT 0,
    linea_diferente      INT            NOT NULL DEFAULT 0,
    no_digito_telefono   INT            NOT NULL DEFAULT 0,
    -- Índices para que los 6 SPs de reporte sean O(log n)
    INDEX idx_trim_seg   (trimestre, segmento),
    INDEX idx_trim_menu  (trimestre, menu),
    INDEX idx_trim_centro(trimestre, centro_transferencia),
    INDEX idx_fecha      (fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### base_ivr_clientes

```sql
CREATE TABLE base_ivr_clientes (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    trimestre       VARCHAR(10)  NOT NULL,
    segmento        VARCHAR(20)  NOT NULL,
    clientes_unicos INT          NOT NULL DEFAULT 0,
    INDEX idx_trim_seg (trimestre, segmento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- 3 filas por quarter: nacional_A, nacional_B, puebla
```

### Tablas de control

```sql
-- Tracking del MySQL Event Scheduler
CREATE TABLE job_execution_log (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    job_name          VARCHAR(100)  NOT NULL,
    quarter_name      VARCHAR(20),
    tabla_origen      VARCHAR(100),
    start_time        DATETIME      NOT NULL,
    end_time          DATETIME,
    status            ENUM('RUNNING','SUCCESS','PARTIAL','FAILED','SKIP')
                      NOT NULL DEFAULT 'RUNNING',
    records_base      INT           DEFAULT 0,
    error_message     TEXT,
    INDEX idx_status_start (status, start_time DESC)
) ENGINE=InnoDB;

-- Tracking del management command Django (fuente de verdad para la UI)
CREATE TABLE etl_runs (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    trimestre       VARCHAR(20)   NOT NULL,
    iniciado_en     DATETIME      NOT NULL,
    finalizado_en   DATETIME,
    estado          ENUM('en_ejecucion','exitoso','fallido')
                    DEFAULT 'en_ejecucion',
    registros_base  INT           DEFAULT 0,
    mensaje_error   TEXT,
    ejecutado_por   VARCHAR(100)  DEFAULT 'scheduler',
    INDEX idx_estado_inicio (estado, iniciado_en DESC),
    INDEX idx_trimestre     (trimestre)
) ENGINE=InnoDB;
```

---

## Capa 5 — Stored Procedures de reporte

Django llama a estos SPs bajo demanda. Son **read-only**. Cada uno
lee de `base_ivr_detalle` o `base_ivr_clientes` (miles de filas
indexadas — respuesta en milisegundos).

### Parámetros comunes

```
p_quarter  VARCHAR(10)  — 'Q01_25' | 'Q02_25' | ... | 'Q02_26'
p_segmento VARCHAR(20)  — 'todas' | 'nacional_A' | 'nacional_B' | 'puebla'
```

El parámetro `p_segmento = 'todas'` es el equivalente del `@FORM`
de `FUNC_REPORTE_COBRANZA` — controla el scope del filtro sin duplicar
el SELECT en bloques IF separados.

### Los 7 SPs y su output

| SP | Parámetros | Filas resultado | Propósito |
|---|---|---|---|
| `sp_rpt_centros_transferencia` | quarter, segmento | Cientos por quarter | Detalle fecha×centro×menu×opcion con métricas de teléfono |
| `sp_rpt_centros_xsegmento` | quarter | 3 bloques (uno por segmento) | KPIs con clasificación SLA y días hábiles |
| `sp_rpt_llamadas_abandonadas` | quarter, segmento | Decenas | Tasa abandono: VACIO + cliente_colgo + SinOpcion_Cabecera |
| `sp_rpt_menu_redirigidos` | quarter, segmento | Docenas | Menús que dispararon transferencia a un centro |
| `sp_rpt_menu_centro` | quarter, segmento | Decenas | Perspectiva inversa: centro → menús que lo alimentan |
| `sp_rpt_cMENU_ERROR` | quarter, segmento | < 10 | Anomalías: cMenu = número de teléfono (`'telefono_cMenu'`) |
| `sp_rpt_clientes` | quarter | 3 filas | Clientes únicos por segmento |

### Ejemplo: sp_rpt_llamadas_abandonadas

```sql
CREATE PROCEDURE sp_rpt_llamadas_abandonadas(
    IN p_quarter  VARCHAR(10),
    IN p_segmento VARCHAR(20)
)
BEGIN
    SELECT
        b.trimestre,
        b.segmento,
        UPPER(TRIM(b.menu))           AS menu,     -- normalización en el SP de reporte
        SUM(b.total_llamadas)         AS total_abandonadas,
        ROUND(
            SUM(b.total_llamadas) /
            (SELECT SUM(b2.total_llamadas)
             FROM base_ivr_detalle b2
             WHERE b2.trimestre = p_quarter
               AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
            ) * 100, 2
        )                             AS pct_del_total
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND (p_segmento = 'todas' OR b.segmento = p_segmento)
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
      -- D-ETL-006: las 3 categorías de abandono — no solo VACIO
    GROUP BY b.trimestre, b.segmento, b.menu
    ORDER BY b.segmento, total_abandonadas DESC;
END;
```

---

## Capa 6 — Django REST Framework

### Configuración de conexión dual

```python
# settings.py
DATABASES = {
    'default': {                    # PostgreSQL — operacional Django
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'iact_operacional',
        ...
    },
    'ivr': {                        # MariaDB — IVR fuente + analítica IACT
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'ivr_legacy',
        'OPTIONS': {'charset': 'utf8mb4'},
        ...
    }
}
DATABASE_ROUTERS = ['iact.routers.IVRRouter']
```

### Capa de servicio (sin modelos ORM para datos IVR)

```python
# services/ivr_reports.py

from django.db import connections

def _call_sp(sp_name, params):
    """Motor común para todos los SPs de reporte."""
    with connections['ivr'].cursor() as cursor:
        cursor.callproc(sp_name, params)
        columns = [col[0] for col in cursor.description]
        return [dict(zip(columns, row)) for row in cursor.fetchall()]


def get_llamadas_abandonadas(quarter, segmento='todas'):
    return _call_sp('sp_rpt_llamadas_abandonadas', [quarter, segmento])

def get_centros_transferencia(quarter, segmento='todas'):
    return _call_sp('sp_rpt_centros_transferencia', [quarter, segmento])

def get_centros_xsegmento(quarter):
    return _call_sp('sp_rpt_centros_xsegmento', [quarter])

def get_menu_redirigidos(quarter, segmento='todas'):
    return _call_sp('sp_rpt_menu_redirigidos', [quarter, segmento])

def get_menu_centro(quarter, segmento='todas'):
    return _call_sp('sp_rpt_menu_centro', [quarter, segmento])

def get_cmenu_error(quarter, segmento='todas'):
    return _call_sp('sp_rpt_cMENU_ERROR', [quarter, segmento])

def get_clientes_unicos(quarter):
    return _call_sp('sp_rpt_clientes', [quarter])
```

### Vistas DRF (serialización directa)

```python
# views/ivr_reports.py

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from services import ivr_reports

QUARTERS_VALIDOS = {'Q01_25','Q02_25','Q03_25','Q04_25','Q01_26','Q02_26'}
SEGMENTOS_VALIDOS = {'todas', 'nacional_A', 'nacional_B', 'puebla'}


class LlamadasAbandonadasView(APIView):
    """
    GET /api/ivr/reportes/abandonadas/?quarter=Q01_25&segmento=todas
    """
    def get(self, request):
        quarter   = request.query_params.get('quarter', 'Q01_25')
        segmento  = request.query_params.get('segmento', 'todas')

        if quarter not in QUARTERS_VALIDOS:
            return Response(
                {'error': f'quarter inválido: {quarter}'},
                status=status.HTTP_400_BAD_REQUEST
            )
        if segmento not in SEGMENTOS_VALIDOS:
            return Response(
                {'error': f'segmento inválido: {segmento}'},
                status=status.HTTP_400_BAD_REQUEST
            )

        data = ivr_reports.get_llamadas_abandonadas(quarter, segmento)
        return Response({
            'quarter':  quarter,
            'segmento': segmento,
            'total_filas': len(data),
            'datos': data          # lista de dicts — lista para JSON
        })


class CentrosTransferenciaView(APIView):
    def get(self, request):
        quarter  = request.query_params.get('quarter', 'Q01_25')
        segmento = request.query_params.get('segmento', 'todas')
        data = ivr_reports.get_centros_transferencia(quarter, segmento)
        return Response({'quarter': quarter, 'segmento': segmento,
                         'total_filas': len(data), 'datos': data})


class ClientesUnicosView(APIView):
    def get(self, request):
        quarter = request.query_params.get('quarter', 'Q01_25')
        data = ivr_reports.get_clientes_unicos(quarter)
        return Response({'quarter': quarter, 'datos': data})
```

### URLs

```python
# urls.py
urlpatterns = [
    path('api/ivr/reportes/abandonadas/',     LlamadasAbandonadasView.as_view()),
    path('api/ivr/reportes/centros/',          CentrosTransferenciaView.as_view()),
    path('api/ivr/reportes/centros-segmento/', CentrosXSegmentoView.as_view()),
    path('api/ivr/reportes/menu-redirigidos/', MenuRedirigidosView.as_view()),
    path('api/ivr/reportes/menu-centro/',      MenuCentroView.as_view()),
    path('api/ivr/reportes/cmenu-error/',      CMENUErrorView.as_view()),
    path('api/ivr/reportes/clientes/',         ClientesUnicosView.as_view()),
    path('api/ivr/pipeline/estado/',           ETLEstadoView.as_view()),
    path('api/ivr/pipeline/reintentar/',       ETLReintentarView.as_view()),
]
```

---

## Flujo de una petición de reporte (end-to-end)

```
Usuario en el frontend
        │  GET /api/ivr/reportes/abandonadas/?quarter=Q01_25&segmento=nacional_A
        ▼
Django (DRF)
  LlamadasAbandonadasView.get()
    │  Valida parámetros
    │  ivr_reports.get_llamadas_abandonadas('Q01_25', 'nacional_A')
    ▼
MariaDB — conexión 'ivr'
  cursor.callproc('sp_rpt_llamadas_abandonadas', ['Q01_25', 'nacional_A'])
    │  SELECT ... FROM base_ivr_detalle
    │  WHERE trimestre='Q01_25' AND segmento='nacional_A'
    │    AND menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
    │  → usa INDEX idx_trim_seg (milisegundos)
    ▼
  Result set: lista de dicts
        │  [{trimestre, segmento, menu, total_abandonadas, pct_del_total}, ...]
        ▼
Django (DRF)
  Response(JSON)
        │
        ▼
Frontend  — consume directamente el JSON sin transformaciones adicionales
```

---

## Comparación con FUNC_REPORTE_COBRANZA

La función SQL Server que se proporcionó como referencia usa el mismo
principio: datos limpios y listos para serializar producidos en la BD,
consumidos directamente por la capa de aplicación sin post-procesamiento.

| Aspecto | FUNC_REPORTE_COBRANZA (SQL Server) | Nuestros sp_rpt_* (MariaDB) |
|---|---|---|
| Tipo | Table-Valued Function | Stored Procedure (result set) |
| Modo de filtro | `@FORM=1/2/3` + `@ID` | `p_quarter` + `p_segmento` |
| Bloque condicional | 3 bloques IF con mismo SELECT | 1 SELECT con `OR segmento=` |
| Lógica en BD | Cálculo de capital, interés, mora | Normalización NK90, VACIO, sentinels |
| Consumo | Aplicación hace `SELECT * FROM FUNC(...)` | Django hace `cursor.callproc()` |
| Output | 20 columnas denormalizadas | 7-11 columnas limpias por SP |

El bug de la función original (`PATERNO` duplicado, filtro en `JOIN ON`)
ocurre precisamente por copiar y pegar el mismo bloque tres veces. Nuestro
diseño con un solo `SELECT` y `WHERE (p_segmento = 'todas' OR ...)` elimina
esa superficie de error.

---

## Resumen de componentes por capa

| Capa | Componente | Tecnología | Estado |
|---|---|---|---|
| 0 — Fuente | `tbl_historico_tN_YYYY` | MariaDB (cliente) | Creadas + seed |
| 1 — Disparo | `evt_etl_diario` | MySQL Event | Pendiente |
| 1 — Disparo | `manage.py run_etl` | Django + APScheduler | Pendiente |
| 2 — Orquestación | `sp_etl_maestro` | MariaDB SP | Pendiente |
| 3 — ETL | `sp_etl_base_detalle` | MariaDB SP (PREPARE/EXECUTE) | Pendiente |
| 3 — ETL | `sp_etl_base_clientes` | MariaDB SP (PREPARE/EXECUTE) | Pendiente |
| 3 — Control | `sp_etl_historico` | MariaDB SP | Pendiente |
| 4 — Tablas base | `base_ivr_detalle` | MariaDB (IACT) | Pendiente |
| 4 — Tablas base | `base_ivr_clientes` | MariaDB (IACT) | Pendiente |
| 4 — Control | `job_execution_log`, `etl_runs`, `job_config` | MariaDB (IACT) | Pendiente |
| 5 — Reportes | `sp_rpt_*` (7 SPs) | MariaDB SP | Pendiente |
| 6 — API | `services/ivr_reports.py` | Django | Pendiente |
| 6 — API | `views/ivr_reports.py` + `urls.py` | Django DRF | Pendiente |

---

## Ver también

- `ETL-ANALISIS.md` — análisis detallado del diseño ETL
- `ETL-SPS-REPORTE.md` — análisis de los 7 SPs de reporte
- `MAPEO-DID-SEGMENTOS.md` — DIDs y etiquetas de segmento
- `REPORTE-PROM-LLAMADAS.md` — hallazgo H-1 (UPPERCASE en SPs de reporte)
- `TBL-HISTORICO-ANOMALIAS.md` — condiciones de calidad que el ETL maneja
- `PERFILES-QUARTER.md` — cómo el seed replica los datos por quarter
- `decisions.md` (IACT-docs) — D-ETL-001..011

