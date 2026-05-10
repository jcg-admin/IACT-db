# Grafo de dependencias y simulación de producción — Pipeline ETL IVR

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Fuente:** `FLUJO-ETL-V2.1.md`, ejecución real en ivr_legacy (sandbox 10.11.14)

---

## Grafo de dependencias para implementación

Cada nodo tiene sus prerequisitos a la izquierda. Un nodo no puede
desplegarse ni ejecutarse si alguno de sus prerequisitos falla.

```
══════════════════════════════════════════════════════════════════════
 NIVEL 0 — Prerequisito de todo (sin dependencias externas)
══════════════════════════════════════════════════════════════════════

 [fn_did_segmento]          ←  sin dependencias
 [fn_normalizar_menu]       ←  sin dependencias
 [fn_normalizar_centro]     ←  sin dependencias
 [fn_duracion_seg]          ←  sin dependencias  (definida, sin uso activo)
 [ivr_es_dia_semana]        ←  sin dependencias
 [ivr_contar_dias_semana]   ←  [ivr_es_dia_semana]
 [ivr_agregar_dias_semana]  ←  [ivr_es_dia_semana]

══════════════════════════════════════════════════════════════════════
 NIVEL 1 — Tablas fuente (datos del cliente, solo SELECT)
══════════════════════════════════════════════════════════════════════

 [tbl_historico_t1_2025]    ←  schema_historico.sh + seed
 [tbl_historico_t2_2025]    ←  schema_historico.sh + seed
 [tbl_historico_t3_2025]    ←  schema_historico.sh + seed
 [tbl_historico_t4_2025]    ←  schema_historico.sh + seed
 [tbl_historico_t1_2026]    ←  schema_historico.sh + seed
 [tbl_historico_t2_2026]    ←  schema_historico.sh + seed

══════════════════════════════════════════════════════════════════════
 NIVEL 2 — Tablas de control
══════════════════════════════════════════════════════════════════════

 [job_config]               ←  schema_base_ivr.sql + INSERT datos iniciales
                                 (etl_diario=enabled, etl_historico=disabled)
 [job_execution_log]        ←  schema_base_ivr.sql
 [etl_runs]                 ←  schema_base_ivr.sql
 [base_ivr_detalle]         ←  schema_base_ivr.sql (vacía hasta que corra ETL)
 [base_ivr_clientes]        ←  schema_base_ivr.sql (vacía hasta que corra ETL)

══════════════════════════════════════════════════════════════════════
 NIVEL 3 — SPs ETL (escritura en base_ivr_*)
══════════════════════════════════════════════════════════════════════

 [sp_etl_base_detalle]      ←  [fn_did_segmento]
                                [fn_normalizar_menu]
                                [fn_normalizar_centro]
                                [ivr_es_dia_semana]
                                [tbl_historico_tN_YYYY] (dinámica — PREPARE/EXECUTE)
                                [base_ivr_detalle]
                                [job_execution_log]

 [sp_etl_base_clientes]     ←  [fn_did_segmento]
                                [tbl_historico_tN_YYYY] (dinámica — PREPARE/EXECUTE)
                                [base_ivr_clientes]
                                [job_execution_log]

 [sp_etl_validar]           ←  [base_ivr_detalle]
                                [base_ivr_clientes]

══════════════════════════════════════════════════════════════════════
 NIVEL 4 — SPs de orquestación
══════════════════════════════════════════════════════════════════════

 [sp_etl_maestro]           ←  [job_config]          (Lee is_enabled)
                                [job_execution_log]    (Checkpoints + anti-concurrencia)
                                [sp_etl_base_detalle]
                                [sp_etl_base_clientes]
                                [sp_etl_validar]
                                [tbl_historico_tN_YYYY] (calculada en tiempo de ejecución:
                                                          QUARTER(CURDATE()) del día)

 [sp_etl_historico]         ←  [job_execution_log]
                                [sp_etl_base_detalle]
                                [sp_etl_base_clientes]
                                [sp_etl_validar]
                                [tbl_historico_tN_YYYY] (calculada de p_year + p_quarter_num)

══════════════════════════════════════════════════════════════════════
 NIVEL 5 — Disparos (Nivel 4 como dependencia)
══════════════════════════════════════════════════════════════════════

 [evt_etl_diario]           ←  [sp_etl_maestro]
                                event_scheduler = ON (variable global MariaDB)
                                (Registra solo en job_execution_log)

 [manage.py run_etl]        ←  [sp_etl_maestro]
                                [etl_runs]             (INSERT + UPDATE)
                                Django settings.py DATABASES['ivr']
                                (Registra en etl_runs + job_execution_log)

══════════════════════════════════════════════════════════════════════
 NIVEL 6 — SPs de reporte (solo lectura — sin dependencias de escritura)
══════════════════════════════════════════════════════════════════════

 [sp_rpt_clientes]                ←  [base_ivr_clientes]
 [sp_rpt_centros_transferencia]   ←  [base_ivr_detalle]
 [sp_rpt_llamadas_abandonadas]    ←  [base_ivr_detalle]
 [sp_rpt_menu_redirigidos]        ←  [base_ivr_detalle]
 [sp_rpt_menu_centro]             ←  [base_ivr_detalle]
 [sp_rpt_cMENU_ERROR]             ←  [base_ivr_detalle]
 [sp_rpt_centros_xsegmento]       ←  [base_ivr_detalle]
                                      [base_ivr_clientes]
                                      [ivr_contar_dias_semana]
                                      [ivr_agregar_dias_semana]
                                      [ivr_es_dia_semana]

══════════════════════════════════════════════════════════════════════
 NIVEL 7 — Capa API Django (prerequisito: todos los niveles anteriores)
══════════════════════════════════════════════════════════════════════

 [settings.py DATABASES]    ←  MariaDB ivr_legacy accesible + django_user
                                PostgreSQL iact_analytics accesible
 [IVRRouter]                ←  [settings.py DATABASES]
 [services/ivr_reports.py]  ←  [sp_rpt_*] todos desplegados
 [views/ivr_reports.py]     ←  [services/ivr_reports.py]
 [views/ivr_pipeline.py]    ←  [etl_runs]
 [urls/ivr.py]              ←  [views/ivr_reports.py] [views/ivr_pipeline.py]
```

---

## Orden de implementación derivado del grafo

```
PASO 1  funciones_utilidad.sql     7 funciones         (Nivel 0)
PASO 2  schema_historico.sh        6 tablas históricas  (Nivel 1)
PASO 3  seed histórico             datos en Nivel 1
PASO 4  schema_base_ivr.sql        5 tablas control     (Nivel 2)
PASO 5  sp_etl_pipeline.sql        5 SPs ETL/orq.       (Niveles 3-4)
PASO 6  sp_rpt_reportes.sql        7 SPs reporte        (Nivel 6)
PASO 7  event_scheduler = ON       habilitar Event      (Nivel 5A)
PASO 8  sp_etl_historico backfill  poblar base_ivr_*    (Nivel 4→Nivel 2)
PASO 9  Django DRF                 API completa         (Nivel 7)
```

---

## Estado real de cada nodo — sandbox 2026-05-10

| Nodo | Tipo | Estado | Notas |
|---|---|---|---|
| `fn_did_segmento` | FUNCTION | Desplegado | |
| `fn_normalizar_menu` | FUNCTION | Desplegado | |
| `fn_normalizar_centro` | FUNCTION | Desplegado | |
| `fn_duracion_seg` | FUNCTION | Desplegado | Sin uso activo en SPs actuales |
| `ivr_es_dia_semana` | FUNCTION | Desplegado | |
| `ivr_contar_dias_semana` | FUNCTION | Desplegado | |
| `ivr_agregar_dias_semana` | FUNCTION | Desplegado | |
| `tbl_historico_t1_2025` | TABLE | 33,085 registros | 1 fila fuera de rango (2025-06-01) |
| `tbl_historico_t2_2025` | TABLE | 37,794 registros | Rango correcto |
| `tbl_historico_t3_2025` | TABLE | 31,791 registros | Rango correcto |
| `tbl_historico_t4_2025` | TABLE | 34,644 registros | Rango correcto |
| `tbl_historico_t1_2026` | TABLE | 33,638 registros | Rango correcto |
| `tbl_historico_t2_2026` | TABLE | 15,110 registros | Parcial 36/91 días Q2 |
| `job_config` | TABLE | 2 registros | etl_diario=ON, etl_historico=OFF |
| `job_execution_log` | TABLE | 13 registros | Post-simulación |
| `etl_runs` | TABLE | 1 registro | Post-simulación |
| `base_ivr_detalle` | TABLE | 7,636 registros | 6 quarters cargados |
| `base_ivr_clientes` | TABLE | 18 registros | 3 filas × 6 quarters |
| `sp_etl_base_detalle` | PROCEDURE | Desplegado | PREPARE/EXECUTE (CNST-ETL-008) |
| `sp_etl_base_clientes` | PROCEDURE | Desplegado | |
| `sp_etl_validar` | PROCEDURE | Desplegado | |
| `sp_etl_maestro` | PROCEDURE | Desplegado | |
| `sp_etl_historico` | PROCEDURE | Desplegado | |
| `evt_etl_diario` | EVENT | ENABLED | event_scheduler=ON post-reinicio |
| `manage.py run_etl` | Django CMD | Desplegado en IACT-api | |
| `sp_rpt_clientes` | PROCEDURE | Desplegado | Retorna datos ✓ |
| `sp_rpt_centros_transferencia` | PROCEDURE | Desplegado | Retorna datos ✓ |
| `sp_rpt_llamadas_abandonadas` | PROCEDURE | Desplegado | Retorna datos ✓ |
| `sp_rpt_menu_redirigidos` | PROCEDURE | Desplegado | Retorna datos ✓ |
| `sp_rpt_menu_centro` | PROCEDURE | Desplegado | Retorna datos ✓ |
| `sp_rpt_cMENU_ERROR` | PROCEDURE | Desplegado | Retorna datos ✓ |
| `sp_rpt_centros_xsegmento` | PROCEDURE | Desplegado | Retorna datos ✓ |
| Django DRF (9 endpoints) | API | Pendiente | IACT-api no desplegado |

---

## Simulación de producción — resultados reales

### Condiciones de entrada verificadas

| Condición | Valor |
|---|---|
| Fecha de simulación | 2026-05-10 (Q02_26 activo) |
| Quarter calculado por sp_etl_maestro | Q02_26 |
| Tabla fuente del maestro | tbl_historico_t2_2026 (15,110 filas) |
| G-29 en fuente | 38.3%–38.9% por quarter (calibrado) |
| DIDs válidos | 19028031 (45%), 19020001 (30%), 19020084 (25%) |
| Filas fuera de rango | 1 en Q01_25 (excluida por filtro de fecha ETL) |

### Paso 1 — Backfill histórico (sp_etl_historico × 5 quarters)

| Quarter | SP llamado | Filas detalle | Filas clientes | Total llamadas | Duración | Validación |
|---|---|---|---|---|---|---|
| Q01_25 | sp_etl_historico(2025, 1) | 1,200 | 3 | 33,084 | ~1s | OK |
| Q02_25 | sp_etl_historico(2025, 2) | 1,556 | 3 | 37,794 | ~1s | OK |
| Q03_25 | sp_etl_historico(2025, 3) | 1,403 | 3 | 31,791 | ~1s | OK |
| Q04_25 | sp_etl_historico(2025, 4) | 1,440 | 3 | 34,644 | ~1s | OK |
| Q01_26 | sp_etl_historico(2026, 1) | 1,255 | 3 | 33,638 | ~1s | OK |

Pausa de 5 segundos entre cada quarter (DO SLEEP(5) en sp_etl_historico).
Total: ~35 segundos para 5 quarters con datos de seed (~170K filas).
En producción con 11–14M filas reales: ~9 minutos por quarter (~47 min total).

### Paso 2 — ETL diario nocturno (sp_etl_maestro — Q02_26)

Simulando `evt_etl_diario` + `manage.py run_etl`:

| Componente | Acción | Resultado |
|---|---|---|
| etl_runs INSERT | inicio_at=15:12:33, timeout_at=+30min, trigger_source='simulacion_produccion' | id=1 |
| job_config check | etl_diario.is_enabled=1 | Continúa |
| Concurrencia check | 0 jobs RUNNING en últimas 6h | Continúa |
| Quarter calculado | QUARTER(CURDATE())=2 → Q02_26, tbl_historico_t2_2026 | OK |
| sp_etl_base_detalle | 782 filas detalle | SUCCESS (id=12) |
| sp_etl_base_clientes | 3 filas clientes | SUCCESS (id=13) |
| sp_etl_validar | ok=1 | OK — 782 filas, 3 clientes, 15,110 llamadas |
| etl_runs UPDATE | status='success', fin_at=15:12:33 | OK |

### Paso 3 — Verificación final (sp_etl_validar × 6 quarters)

Todos los quarters OK:

| Quarter | Filas detalle | Filas clientes | Total llamadas | ok |
|---|---|---|---|---|
| Q01_25 | 1,200 | 3 | 33,084 | 1 |
| Q02_25 | 1,556 | 3 | 37,794 | 1 |
| Q03_25 | 1,403 | 3 | 31,791 | 1 |
| Q04_25 | 1,440 | 3 | 34,644 | 1 |
| Q01_26 | 1,255 | 3 | 33,638 | 1 |
| Q02_26 | 782 | 3 | 15,110 | 1 |
| **TOTAL** | **7,636** | **18** | **186,061** | **6/6** |

### Paso 4 — SPs de reporte (muestra de resultados reales)

**sp_rpt_clientes('Q01_25')** — 3 filas:
```
nacional_A   14,972 clientes  45.26%
nacional_B    9,905 clientes  29.94%
puebla        8,204 clientes  24.80%
```

**sp_rpt_llamadas_abandonadas('Q01_25', 'todas')** — 9 filas:
```
nacional_A  CLIENTE_COLGO      3,443  10.41% total  22.99% segmento  OPTIMO
nacional_A  VACIO              1,187   3.59%          7.93%           OPTIMO
nacional_A  SINOPC_CABECERA      500   1.51%          3.34%           OPTIMO
nacional_B  CLIENTE_COLGO      2,298   6.95%         23.20%           OPTIMO
...
```

**sp_rpt_centros_xsegmento('Q01_25')** — 81 filas:
```
Top 3 nacional_A:
  10728487   1,617 llamadas  69.4% entre semana  FUERA_SLA  10.80% del segmento
  19020086   1,462 llamadas  70.5% entre semana  FUERA_SLA   9.76% del segmento
  10828091   1,303 llamadas  69.5% entre semana  FUERA_SLA   8.70% del segmento
```

Nota: clasificación `FUERA_SLA` esperada para datos históricos (el SLA
mide días desde la `ultima_actividad` — para Q01_25 han pasado 290 días
hábiles desde 2025-03-31, lo que supera cualquier umbral de seguimiento).

**sp_rpt_cMENU_ERROR('Q01_25', 'todas')** — 47 filas:
```
47 anomalías tipo 'telefono_cMenu' — número de teléfono almacenado en cMenu
(bug IVR Puebla confirmado) — todos enrutados a VDN 19020086
```

**Conteo de filas por SP (Q01_25)**:

| SP | Filas retornadas |
|---|---|
| sp_rpt_clientes | 3 |
| sp_rpt_centros_xsegmento | 81 |
| sp_rpt_llamadas_abandonadas | 9 |
| sp_rpt_menu_redirigidos | 352 |
| sp_rpt_menu_centro | 623 |
| sp_rpt_cMENU_ERROR | 47 |
| sp_rpt_centros_transferencia | 1,200 |

---

## Hallazgos de la simulación

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-SIM-001 | Pipeline completo funcional — 6/6 quarters OK | Resultado positivo | — |
| H-SIM-002 | Grain de base_ivr_detalle correcto — 33K filas → 1,200 agregadas | Resultado positivo | — |
| H-SIM-003 | sp_rpt_menu_redirigidos muestra __CMENU_ERROR__ en top — números de teléfono como menú | Bug real IVR | DOCUMENTADO |
| H-SIM-004 | clasificacion_sla = FUERA_SLA para datos históricos — comportamiento esperado | Comportamiento esperado | DOCUMENTADO |
| H-SIM-005 | event_scheduler=ON requiere flag al arrancar mariadbd — no persiste por defecto | MEDIA | PENDIENTE |
| H-SIM-006 | Django DRF (Nivel 7) — único nivel pendiente de despliegue | ALTA | PENDIENTE |

---

## H-SIM-003 — sp_rpt_menu_redirigidos: __CMENU_ERROR__ en los resultados

La primera fila de `sp_rpt_menu_redirigidos` muestra menús como
`'4431164449'`, `'4432701957'`, etc. — números de teléfono almacenados
en el campo `cMenu` del IVR (bug __CMENU_ERROR__ documentado).

El SP `fn_normalizar_menu()` hace pass-through de estos valores (no los
filtra) porque son datos válidos del IVR real — el SP `sp_rpt_cMENU_ERROR`
existe precisamente para reportar estas anomalías. La vista `sp_rpt_menu_redirigidos`
los incluye porque el ETL los almacenó tal cual en `base_ivr_detalle`.

Comportamiento correcto por diseño.

---

## H-SIM-004 — clasificacion_sla = FUERA_SLA para datos históricos

`sp_rpt_centros_xsegmento` calcula `dias_semana_sin_actividad` usando
`ivr_contar_dias_semana(ultima_actividad, CURDATE())`. Para Q01_25,
la última actividad es 2025-03-31 y hoy es 2026-05-10 — han pasado
290 días hábiles, lo que supera cualquier umbral de SLA (escalamiento
en 5 días). Por eso todos los centros muestran `FUERA_SLA`.

En producción real, `sp_etl_maestro` corre diariamente procesando el
quarter activo. Los centros con actividad del día anterior tendrán
`dias_semana_sin_actividad = 1` y clasificaciones como `ACTIVO_HOY`
o `DENTRO_SLA`.

---

## H-SIM-005 — event_scheduler no persiste tras reinicio

El servidor fue reiniciado con `--event-scheduler=ON` explícito en la
línea de comando. En producción esto debe configurarse en `my.cnf`:

```ini
[mysqld]
event_scheduler = ON
```

Sin esta configuración, `evt_etl_diario` existe y está ENABLED pero
nunca disparará (H-SP2-002 del análisis anterior).

---

## H-SIM-006 — Django DRF: único nivel pendiente

De los 7 niveles del grafo, solo el Nivel 7 (Django DRF) está pendiente
de despliegue en IACT-api. Los componentes pendientes son:

```
settings.py      DATABASES dual (default=PostgreSQL, ivr=MariaDB)
IVRRouter        app_label='ivr' → db='ivr', allow_migrate=False
ivr_reports.py   7 funciones _call_sp() + getters
ivr_pipeline.py  ETLEstadoView + ETLReintentarView
urls/ivr.py      9 endpoints /api/ivr/
run_etl.py       Desplegado (IACT-api/apps/pipeline/management/commands/)
```

`manage.py run_etl` ya existe y está desplegado. Los 9 endpoints de
reporte son los únicos componentes pendientes en la capa Django.
