# Análisis ETL — IACT IVR Pipeline

**Fecha de análisis:** 2026-05-06
**Fuentes:** WPs `2026-05-02-07-12-32-pipeline-uc-deepening` y
`2026-05-02-09-54-55-source-corrections-pipeline` del repositorio IACT-docs.
**Estado:** Diseño confirmado con el equipo — implementación pendiente.

---

## 1. Pregunta central: ¿SP o Job?

**Respuesta:** Ambos, con roles distintos y complementarios.

| Componente | Tipo | Responsabilidad |
|---|---|---|
| `sp_etl_maestro` | Stored Procedure | Orquestador: calcula quarter activo, verifica concurrencia, llama a los SPs ETL |
| `sp_etl_base_detalle` | Stored Procedure | ETL real: lee `tbl_historico_*`, normaliza y agrega a `base_ivr_detalle` |
| `sp_etl_base_clientes` | Stored Procedure | ETL real: COUNT DISTINCT a `base_ivr_clientes` |
| `sp_etl_historico` | Stored Procedure | Carga manual de quarters históricos |
| `evt_etl_diario` | MySQL Event (Job) | Disparador: llama a `sp_etl_maestro()` diariamente a las 02:00 AM |
| `sp_rpt_*` (7 SPs) | Stored Procedures | Reportes: llamados por Django bajo demanda, read-only |

El **Event** es el scheduler (el "cuándo"). Los **Stored Procedures** son
la lógica (el "qué"). Django no toca el ETL — solo llama los `sp_rpt_*`
para servir reportes.

---

## 2. Arquitectura general

```
MySQL Event Scheduler
  evt_etl_diario (02:00 AM diario)
        │
        └── CALL sp_etl_maestro()
                  │
                  ├── Calcula quarter activo: YEAR(CURDATE()) + QUARTER(CURDATE())
                  │   Ejemplo hoy: v_quarter='Q02_26', v_table='tbl_historico_t2_2026'
                  │
                  ├── Verifica concurrencia (no duplicar si ya corre)
                  │
                  ├── CALL sp_etl_base_detalle(@quarter, @inicio, @fin, @table)
                  │         └── 1 full table scan de tbl_historico_t2_2026
                  │             DELETE + INSERT agregado → base_ivr_detalle
                  │
                  └── CALL sp_etl_base_clientes(@quarter, @inicio, @fin, @table)
                            └── 1 full table scan de tbl_historico_t2_2026
                                DELETE + INSERT COUNT DISTINCT → base_ivr_clientes

Django (bajo demanda — solo lectura):
  cursor.callproc('sp_rpt_centros_transferencia', [quarter, segmento])
  cursor.callproc('sp_rpt_llamadas_abandonadas', [quarter])
  cursor.callproc('sp_rpt_clientes_unicos', [quarter])
  ... (7 SPs de reporte en total)
```

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

Beneficios adicionales:

- Agregar un nuevo reporte = nuevo `sp_rpt_*` sin tocar el ETL
- Django recibe result sets del SP, no está acoplado al schema de las tablas
- Los parámetros dinámicos (`@quarter`, `@segmento`) se resuelven en el SP

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
    SÍ → continuar
  COUNT(*) en base_ivr_clientes WHERE quarter='Q02_26' = 3 filas?
    NO → status='PARTIAL', notificar

PASO 6 — Actualizar control
  UPDATE job_execution_log SET status='SUCCESS', end_time=NOW()

PASO 7 — Notificación (buzón interno — CNST-001: sin email)
  INSERT INTO internal_messages → usuarios con role='SYSTEM_ADMIN'
```

---

## 5. Tablas involucradas

### Tablas fuente (propiedad del cliente — solo lectura)

```
tbl_historico_t1_2025   Q1 2025   2025-01-01 → 2025-03-31   ~11-14M filas
tbl_historico_t2_2025   Q2 2025   2025-04-01 → 2025-06-30   ~11-14M filas
tbl_historico_t3_2025   Q3 2025   2025-07-01 → 2025-09-30   ~11-14M filas
tbl_historico_t4_2025   Q4 2025   2025-10-01 → 2025-12-31   ~11-14M filas
tbl_historico_t1_2026   Q1 2026   2026-01-01 → 2026-03-31   ~11-14M filas
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

**`job_execution_log`** — registro de cada ejecución: `job_name`,
`quarter_name`, `start_time`, `end_time`, `status`, `records_extracted`,
`records_loaded`, `error_message`. Django la lee para UC-PIP-01/02/03.

**`job_config`** — configuración por job: `is_enabled`, `timeout_seconds`,
`notify_on_success`, `notify_on_failure`.

### SPs de reporte (7 — llamados por Django)

| SP | Fuente | Descripción |
|---|---|---|
| `sp_rpt_centros_transferencia` | `base_ivr_detalle` | Detalle de transferencias por centro, menú y opción |
| `sp_rpt_centros_xsegmento` | `base_ivr_detalle` | KPIs de centros por segmento con clasificación SLA y días hábiles |
| `sp_rpt_llamadas_abandonadas` | `base_ivr_detalle` | Tasa de abandono: VACIO + cliente_colgo + SinOpcion_Cabecera (~27-28%) |
| `sp_rpt_menu_redirigidos` | `base_ivr_detalle` | Menús que dispararon redirección a un centro (perspectiva menú→centro) |
| `sp_rpt_menu_centro` | `base_ivr_detalle` | Composición del tráfico por centro (perspectiva centro→menú+opción) |
| `sp_rpt_cMENU_ERROR` | `base_ivr_detalle` | Anomalías: cMenu contiene número de teléfono |
| `sp_rpt_clientes` | `base_ivr_clientes` | Clientes únicos por segmento y quarter (COUNT DISTINCT) |

> Ver `ETL-SPS-REPORTE.md` para el análisis profundo de cada SP.

---

## 6. Normalización de datos durante el ETL

El ETL aplica normalización durante el INSERT en `base_ivr_detalle`.
Los valores crudos de `tbl_historico_*` se transforman en sentinels canónicos:

### cDID_800Transfer → segmento

| DID crudo | Segmento normalizado |
|---|---|
| `19020084` | `'Puebla'` |
| `19028031` | `'nacional_A'` |
| `19020001` | `'nacional_B'` |

**Regla crítica:** El filtro siempre incluye los 3 DIDs:
`WHERE cDID_800Transfer IN (19020084, 19028031, 19020001)`.
Omitir uno produce reportes incompletos (bug confirmado en scripts legacy).

### cDID_Centro_Transferencia → centro_transferencia

| Condición | Valor normalizado |
|---|---|
| NULL o vacío | `'CASO_NULL'` |
| `'cliente_colgo'` | `'CLIENTE_COLGO'` |
| Solo ceros (`^0+$`) | `'CASO_ERROR_CEROS'` |
| `LENGTH > 10` (formato NK90) | `LEFT(campo, LENGTH - 10)` — extrae el VDN real |
| Cualquier otro | valor tal cual |

**Nota NK90:** La infraestructura de enrutamiento actual concatena el VDN real
con `cTelefono_Digitado`. La normalización es permanente para datos históricos.

### cMenu → menu

| Condición | Valor normalizado |
|---|---|
| NULL | `'VACIO'` |
| String vacío (`''`) | `'VACIO'` |
| `'sin cMenu'` | `'VACIO'` |
| `'Desborde_Cabecera'` | `'Desborde_Cabecera'` (sin normalizar — valor válido) |
| Cualquier otro | valor tal cual |

### cOpcion → opcion

`COALESCE(NULLIF(TRIM(cOpcion), ''), 'SIN_OPCION')`

---

## 7. Restricciones técnicas que condicionan el diseño

| ID | Restricción | Impacto en el diseño |
|---|---|---|
| CNST-ETL-001 | Solo lectura en `tbl_historico_*` | No se pueden crear índices en la fuente |
| CNST-ETL-005 | `tbl_historico_*` sin índices | Full table scan inevitable — ETL costoso |
| CNST-ETL-007 | MariaDB 10.1.48 sin window functions | Las subconsultas reemplazan `OVER(PARTITION BY)` en los SPs de reporte |
| CNST-ETL-008 | Nombre de tabla dinámico | `PREPARE/EXECUTE` obligatorio — el nombre de tabla viene de `QUARTER(CURDATE())` |
| CNST-003 | Frecuencia ETL 6-12h | El Event Scheduler corre a las 02:00 AM diariamente |
| CNST-001 | Sin email | Las notificaciones de fallo van al buzón interno, no a email |

---

## 8. Restricciones de negocio relevantes

**BR-016 — Tasa de abandono (CORREGIDA):**
La implementación correcta de "llamadas abandonadas" incluye tres categorías:
`menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')`.
El SP actual solo cuenta `VACIO` (~8-9% del total). Con la definición completa
el abandono real es ~27-28%. Los umbrales operativos recalibrados son:
`< 20%` óptimo, `20-30%` aceptable, `> 30%` crítico.

**D-23 — Total Nacional = nacional_A + nacional_B:**
Los reportes que muestren métricas "Nacional" consolidadas deben filtrar
`WHERE segmento IN ('nacional_A', 'nacional_B')`. `nacional_A` domina
(~93-99% del volumen Nacional).

---

## 9. Riesgos identificados

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|---|
| R-01 | Full table scan tarda más de la ventana nocturna (02:00-04:00) | Media | Alto | El ETL actual procesa 1 tabla (~14M filas). Si el volumen crece o MariaDB tiene carga, puede salirse de la ventana. Mitigación: monitorear `duracion_min` en `job_execution_log`. |
| R-02 | Job concurrente (Event lanza 2a instancia antes de que termine la 1a) | Baja | Medio | El SP maestro verifica `status='RUNNING'` en las últimas 6 horas antes de ejecutar. Si detecta concurrencia, registra `SKIP` y sale. |
| R-03 | `PREPARE/EXECUTE` con nombre de tabla dinámico | Baja | Medio | El nombre de tabla se construye internamente desde `QUARTER(CURDATE())` — no viene de input de usuario. Riesgo de inyección SQL nulo. Riesgo real: si la convención de naming cambia, el SP falla silenciosamente. |
| R-04 | `tbl_historico_t{N}_{YYYY}` no existe cuando el ETL la necesita | Media | Alto | Si el cliente aún no creó la tabla del quarter actual, el SP falla con error de tabla inexistente. Mitigación: validar existencia de la tabla al inicio del SP maestro. |
| R-05 | Normalización NK90 incorrecta post-migración a IPVR | Media | Medio | Cuando IPVR reemplace a NK90, `cDID_Centro_Transferencia` dejará de concatenar el teléfono. El CASE `LENGTH > 10` seguirá aplicando pero extraerá datos incorrectos para registros nuevos. Mitigación: agregar flag de migración o fecha de corte. |
| R-06 | ROLLBACK silencioso: datos del quarter anterior conservados sin aviso | Media | Medio | Si el ETL falla, la tabla conserva datos del run anterior — que pueden tener días de antigüedad. El usuario no sabe que está viendo datos viejos sin revisar `job_execution_log`. |
| R-07 | `base_ivr_clientes` con menos de 3 filas (segmento faltante) | Baja | Medio | Si los 3 DIDs no tienen datos en el quarter, el COUNT retorna < 3 filas. Los reportes de clientes únicos mostrarán 0 para el segmento faltante. |
| R-08 | sp_rpt_llamadas_abandonadas con definición incompleta de abandono | Alta | Alto | El SP actual solo cuenta `VACIO` (~8-9%). La definición correcta incluye `cliente_colgo` y `SinOpcion_Cabecera` (~27-28%). Los reportes de tasa de abandono están sub-reportando. **Pendiente de corrección.** |
| R-09 | MariaDB 10.1.48 — versión sin soporte activo | Baja-Media | Alto | Actualización fuera de scope. El diseño usa solo funcionalidad básica (SPs, Events, GROUP BY) compatible con versiones mayores. |
| R-10 | Inyección SQL en PREPARE/EXECUTE | Muy baja | Crítico | Las variables del PREPARE vienen de lógica interna del SP (YEAR, QUARTER, CASE hardcodeado) — no de input de usuario ni de Django. Sin superficie de ataque externa. |

---

## 10. Lo que sigue — secuencia de implementación

Basado en el análisis de los WPs, el orden lógico de implementación es:

### Fase 1 — Tablas base y control (prerequisito de todo lo demás)

```sql
-- En ivr_legacy (MariaDB) — ya documentado en etl-job-flow-design.md
CREATE TABLE base_ivr_detalle ...     -- tabla base con índices
CREATE TABLE base_ivr_clientes ...    -- clientes únicos
CREATE TABLE job_execution_log ...    -- tracking de ejecuciones
CREATE TABLE job_config ...           -- configuración por job
```

Estas tablas son el prerequisito de todos los SPs. Sin ellas ningún
SP puede ejecutarse.

### Fase 2 — SPs ETL (el núcleo)

En este orden estricto (dependencias):

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

Ejecución manual una sola vez:

```sql
CALL sp_etl_historico(2025, 1);   -- Q01_25
CALL sp_etl_historico(2025, 2);   -- Q02_25
CALL sp_etl_historico(2025, 3);   -- Q03_25
CALL sp_etl_historico(2025, 4);   -- Q04_25
CALL sp_etl_historico(2026, 1);   -- Q01_26
-- Q02_26: el Event Scheduler lo maneja desde hoy en adelante
```

### Fase 5 — SPs de reporte (7 SPs — en cualquier orden)

```
sp_rpt_clientes_unicos
sp_rpt_centros_transferencia
sp_rpt_menu_centro
sp_rpt_llamadas_abandonadas   ← incluir las 3 categorías de abandono
sp_rpt_cMENU_ERROR
sp_rpt_colgadas
sp_rpt_menu_redirigidos       ← confirmar si necesita columnas de llamadas_QN (P-13)
```

### Fase 6 — Integración Django

```python
# Conexión django al router 'ivr' → MariaDB
# cursor.callproc('sp_rpt_*', [params])
# Sin modelos ORM para datos IVR
```

### Pendientes de confirmar antes de implementar (P-13, P-14)

| # | Pregunta | Bloquea |
|---|---|---|
| P-13 | ¿`sp_rpt_menu_redirigidos` necesita columnas de `llamadas_QN` (etiquetas, nidMQ) o `base_ivr_detalle` es suficiente? | Diseño del SP y posible 3er scan en el ETL |
| P-14 | ¿`sp_rpt_colgadas` agrupa solo por menu+opcion o hay más dimensiones? | Schema del SELECT del SP |

---

## 11. Cómo Django interactúa con el ETL

Django tiene dos roles distintos con respecto al sistema ETL:

**Monitoreo** (lectura de `job_execution_log` en MariaDB):

```python
# UC-PIP-01: Ver estado del pipeline
def get_etl_status():
    with connections['ivr'].cursor() as cursor:
        cursor.execute("""
            SELECT job_name, quarter_name, start_time, end_time,
                   TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duracion_min,
                   status, records_loaded, error_message
            FROM job_execution_log
            ORDER BY start_time DESC LIMIT 10
        """)
        return cursor.fetchall()
```

**Reportes** (llamada a `sp_rpt_*` en MariaDB):

```python
# UC-RPT-01..17: Reportes IVR
def get_centros_transferencia(quarter, segmento):
    with connections['ivr'].cursor() as cursor:
        cursor.callproc('sp_rpt_centros_transferencia', [quarter, segmento])
        columns = [col[0] for col in cursor.description]
        return [dict(zip(columns, row)) for row in cursor.fetchall()]
```

Django **no puede** disparar el ETL (D-ETL-003, D-09). El Event Scheduler
es el único disparador automático. Para reintentos manuales existe
`sp_etl_historico` que un administrador ejecuta directamente en MariaDB.

---

## 12. Diagrama de dependencias de objetos de base de datos

```
tbl_historico_tN_YYYY  (fuente — cliente)
        │
        │ lee (GRANT SELECT)
        │
        ├──► sp_etl_base_detalle ──► base_ivr_detalle (con índices)
        │           │                        │
        │           └──► job_execution_log   ├──► sp_rpt_centros_transferencia
        │                                    ├──► sp_rpt_menu_centro
        │                                    ├──► sp_rpt_llamadas_abandonadas
        │                                    ├──► sp_rpt_cMENU_ERROR
        │                                    ├──► sp_rpt_colgadas
        │                                    └──► sp_rpt_menu_redirigidos
        │
        └──► sp_etl_base_clientes ─► base_ivr_clientes (con índices)
                    │                        │
                    └──► job_execution_log   └──► sp_rpt_clientes_unicos

sp_etl_maestro ──► sp_etl_base_detalle
               └── sp_etl_base_clientes
               └── job_execution_log
               └── job_config

evt_etl_diario ──► sp_etl_maestro (02:00 AM diario)

sp_etl_historico ──► sp_etl_base_detalle (carga manual quarters pasados)
                 └── sp_etl_base_clientes
```

---

## Ver también

- `docs/getting-started/HISTORICO-IVR.md` — schema y seed de las tablas fuente
- `docs/getting-started/VERIFICACION-LOCAL-SIN-VAGRANT.md` — verificación del entorno
- `provisioners/mariadb/schema_historico.sh` — script de creación de tablas fuente
- WP `2026-05-02-07-12-32-pipeline-uc-deepening/discover/etl-job-flow-design.md` — fuente original
- WP `2026-05-02-09-54-55-source-corrections-pipeline/discover/decisions.md` — decisiones confirmadas
