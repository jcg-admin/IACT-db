# Catálogo técnico — IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Schema:** `ivr_legacy` (MariaDB 10.11)

Este catálogo contiene un documento técnico por cada objeto de la base de datos
y por cada script del repositorio. La intención es que cualquier desarrollador
pueda entender qué hace un objeto, qué consume, qué produce y cómo invocarlo,
sin tener que leer el código fuente completo.

---

## Stored Procedures

### Pipeline ETL

| Archivo | Objeto | Invocado por | Rol |
|---|---|---|---|
| [sps/sp_etl_maestro.md](sps/sp_etl_maestro.md) | `sp_etl_maestro` | `evt_etl_diario`, `run_etl.py` | Orquestador del pipeline — punto de entrada |
| [sps/sp_etl_base_detalle.md](sps/sp_etl_base_detalle.md) | `sp_etl_base_detalle` | `sp_etl_maestro`, `sp_etl_historico` | ETL principal — agrega `base_ivr_detalle` |
| [sps/sp_etl_base_clientes.md](sps/sp_etl_base_clientes.md) | `sp_etl_base_clientes` | `sp_etl_maestro`, `sp_etl_historico` | ETL secundario — agrega `base_ivr_clientes` |
| [sps/sp_etl_validar.md](sps/sp_etl_validar.md) | `sp_etl_validar` | `sp_etl_maestro`, `sp_etl_historico` | Validación post-carga |
| [sps/sp_etl_historico.md](sps/sp_etl_historico.md) | `sp_etl_historico` | `run_etl.py` (manual) | Carga histórica de quarters pasados |

### Reportes (consumidos por Django REST Framework)

| Archivo | Objeto | UC | Descripción |
|---|---|---|---|
| [sps/sp_rpt_clientes.md](sps/sp_rpt_clientes.md) | `sp_rpt_clientes` | UC_RPT_17 | Clientes únicos por quarter |
| [sps/sp_rpt_centros_transferencia.md](sps/sp_rpt_centros_transferencia.md) | `sp_rpt_centros_transferencia` | UC_RPT_15 | Detalle fecha×centro×menú×opción |
| [sps/sp_rpt_llamadas_abandonadas.md](sps/sp_rpt_llamadas_abandonadas.md) | `sp_rpt_llamadas_abandonadas` | UC_RPT_13 | Tasa de abandono por menú |
| [sps/sp_rpt_menu_redirigidos.md](sps/sp_rpt_menu_redirigidos.md) | `sp_rpt_menu_redirigidos` | UC_RPT_16 | Menú → centros de transferencia |
| [sps/sp_rpt_menu_centro.md](sps/sp_rpt_menu_centro.md) | `sp_rpt_menu_centro` | UC_RPT_16 | Centro → menús y opciones |
| [sps/sp_rpt_cmenu_error.md](sps/sp_rpt_cmenu_error.md) | `sp_rpt_cMENU_ERROR` | UC_RPT_16 | Anomalías cMenu=teléfono |
| [sps/sp_rpt_centros_xsegmento.md](sps/sp_rpt_centros_xsegmento.md) | `sp_rpt_centros_xsegmento` | UC_RPT_01 | KPIs por centro con SLA |

---

## Funciones

| Archivo | Función | Tipo | Propósito |
|---|---|---|---|
| [funciones/fn_did_segmento.md](funciones/fn_did_segmento.md) | `fn_did_segmento` | Mapeo | DID 800 → nombre de segmento |
| [funciones/fn_normalizar_centro.md](funciones/fn_normalizar_centro.md) | `fn_normalizar_centro` | Normalización | VDN raw → VDN normalizado o sentinel |
| [funciones/fn_normalizar_menu.md](funciones/fn_normalizar_menu.md) | `fn_normalizar_menu` | Normalización | cMenu → valor normalizado o `VACIO` |
| [funciones/fn_duracion_seg.md](funciones/fn_duracion_seg.md) | `fn_duracion_seg` | Cálculo | Diferencia en segundos entre dos DATETIME |
| [funciones/ivr_es_dia_semana.md](funciones/ivr_es_dia_semana.md) | `ivr_es_dia_semana` | Predicado | Retorna TRUE si la fecha es lunes–viernes |
| [funciones/ivr_contar_dias_semana.md](funciones/ivr_contar_dias_semana.md) | `ivr_contar_dias_semana` | Cálculo | Días hábiles entre dos fechas |
| [funciones/ivr_agregar_dias_semana.md](funciones/ivr_agregar_dias_semana.md) | `ivr_agregar_dias_semana` | Cálculo | Fecha + N días hábiles |

---

## Jobs (MySQL Events)

| Archivo | Evento | Disparo | Acción |
|---|---|---|---|
| [jobs/evt_etl_diario.md](jobs/evt_etl_diario.md) | `evt_etl_diario` | Diario 02:00 AM | `CALL sp_etl_maestro()` |

---

## Tablas analíticas

| Archivo | Tabla | Escritura | Propósito |
|---|---|---|---|
| [tablas/base_ivr_detalle.md](tablas/base_ivr_detalle.md) | `base_ivr_detalle` | ETL (root/DEFINER) | Grain analítico — fuente de 6 de 7 SPs de reporte |
| [tablas/base_ivr_clientes.md](tablas/base_ivr_clientes.md) | `base_ivr_clientes` | ETL (root/DEFINER) | Clientes únicos por quarter (COUNT DISTINCT no aditivo) |
| [tablas/job_execution_log.md](tablas/job_execution_log.md) | `job_execution_log` | SPs ETL (root/DEFINER) | Tracking granular por paso del pipeline |
| [tablas/etl_runs.md](tablas/etl_runs.md) | `etl_runs` | `run_etl.py` (django_user) | Tracking por ejecución del management command |
| [tablas/job_config.md](tablas/job_config.md) | `job_config` | Manual (root) | Configuración operacional de jobs |

---

## Scripts

### Entrypoints principales

| Archivo | Script | Requiere root | Propósito |
|---|---|---|---|
| [scripts/bootstrap.md](scripts/bootstrap.md) | `bootstrap.sh` | Sí | Instala y configura todo desde cero |
| [scripts/setup.md](scripts/setup.md) | `setup.sh` | Sí | Configura BDs (sin instalar) |
| [scripts/start.md](scripts/start.md) | `start.sh` | No | Arranca MariaDB y PostgreSQL |
| [scripts/verify.md](scripts/verify.md) | `verify.sh` | No | Verificación completa del entorno |
| [scripts/provision-mariadb.md](scripts/provision-mariadb.md) | `scripts/provision-mariadb.sh` | Sí | Provisionamiento completo de MariaDB |

### Provisioners MariaDB

| Archivo | Script | Propósito |
|---|---|---|
| [scripts/mariadb-setup.md](scripts/mariadb-setup.md) | `provisioners/mariadb/setup.sh` | BD + usuario + grants base |
| [scripts/mariadb-install.md](scripts/mariadb-install.md) | `provisioners/mariadb/install.sh` | Instalación de MariaDB 10.11 |
| [scripts/mariadb-backup.md](scripts/mariadb-backup.md) | `provisioners/mariadb/backup_ivr_legacy.sh` | Backup comprimido de ivr_legacy |
| [scripts/schema-historico.md](scripts/schema-historico.md) | `provisioners/mariadb/schema_historico.sh` | Tablas históricas + seed sintético |

### Utilidades compartidas

| Archivo | Script | Funciones clave |
|---|---|---|
| [scripts/utils-core.md](scripts/utils-core.md) | `utils/core.sh` | `ensure_dir`, `backup_file`, `service_action` |
| [scripts/utils-logging.md](scripts/utils-logging.md) | `utils/logging.sh` | `log_info`, `log_error`, `log_fatal`, `log_step` |
| [scripts/utils-database.md](scripts/utils-database.md) | `utils/database.sh` | `mariadb_is_running`, `db_start_mariadb` |

### Python

| Archivo | Script | Propósito |
|---|---|---|
| [scripts/poblar-historico.md](scripts/poblar-historico.md) | `provisioners/mariadb/poblar_historico.py` | Genera datos sintéticos en `tbl_historico_*` |
