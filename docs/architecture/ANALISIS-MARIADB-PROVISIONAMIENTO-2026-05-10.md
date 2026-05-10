# Análisis — MariaDB: estado de provisionamiento vs requerimientos IACT-api

**Repositorio:** IACT-db  
**Fecha:** 2026-05-10  
**Referencia:** `scripts/provision-mariadb.sh`, `provisioners/mariadb/setup.sh`,
`IACT-api/callcentersite/config/settings/base.py`, `.env`

---

## 1. Lo que IACT-api requiere de MariaDB

### Conexión (`base.py` + `.env`)

| Parámetro | Valor en `.env` | Default en `base.py` |
|---|---|---|
| BD | `ivr_legacy` | `ivr_legacy` |
| Usuario | `django_user` (via `IVR_DB_USER`) | `ivr_readonly` ← DISCREPANCIA |
| Password | `django_pass` (via `IVR_DB_PASSWORD`) | `ivr_readonly_password` ← DISCREPANCIA |
| Conexión | Socket Unix `/run/mysqld/mysqld.sock` | `localhost:3306` TCP |

El `.env` activo corrige los defaults incorrectos de `base.py`. Sin `.env`, Django
intentaría conectar con `ivr_readonly` que no existe en la BD provisionada.

### Modelo de acceso (CNST-003)

- `ivr_legacy` → READ-ONLY para Django (`SELECT` únicamente)
- `test_ivr_legacy` → CREATE/DROP para pytest
- Ninguna migración de Django sobre `ivr_legacy`
- `DatabaseRouter.allow_migrate('ivr', 'ivr')` retorna `True` — BUG documentado (HALLAZGOS-ENTORNO.md)

### Objetos de BD requeridos para el pipeline ETL

| Objeto | Tipo | Archivo fuente | Descripción |
|---|---|---|---|
| `tbl_historico_t1_2025..t4_2025` | Tabla | `schema_historico.sql` | Datos IVR fuente (6 quarters) |
| `tbl_historico_t1_2026..t2_2026` | Tabla | `schema_historico.sql` | Datos IVR 2026 |
| `tbl_temp_prueba_ivr` | Tabla | `schema_seed.sh` | Tabla de prueba (3000 filas) |
| `base_ivr_detalle` | Tabla | `schema_base_ivr.sql` | Resultado ETL — fuente de 6 SPs |
| `base_ivr_clientes` | Tabla | `schema_base_ivr.sql` | Clientes únicos por quarter |
| `job_execution_log` | Tabla | `schema_base_ivr.sql` | Tracking MySQL Event Scheduler |
| `etl_runs` | Tabla | `schema_base_ivr.sql` | Tracking management command Django |
| `job_config` | Tabla | `schema_base_ivr.sql` | Configuración de jobs |
| `fn_did_segmento` | Función | `funciones_utilidad.sql` | Prerequisito de SPs |
| `fn_normalizar_menu` | Función | `funciones_utilidad.sql` | Prerequisito de SPs |
| `fn_normalizar_centro` | Función | `funciones_utilidad.sql` | Prerequisito de SPs |
| `fn_duracion_seg` | Función | `funciones_utilidad.sql` | Prerequisito de SPs |
| `ivr_es_dia_semana` | Función | `funciones_utilidad.sql` | Prerequisito de SPs |
| `ivr_contar_dias_semana` | Función | `funciones_utilidad.sql` | Prerequisito de SPs |
| `ivr_agregar_dias_semana` | Función | `funciones_utilidad.sql` | Prerequisito de SPs |
| `sp_etl_*` | Stored Procedure | `sp_etl_pipeline.sql` | Pipeline ETL principal |
| `sp_rpt_*` | Stored Procedure | `sp_rpt_reportes.sql` | 6 SPs de reporte |

---

## 2. Lo que el provisioner actualmente entrega

### `setup.sh` (via `root setup.sh mariadb`)

- BD `ivr_legacy` con charset/collation correctos
- Usuario `django_user` en hosts `%` y `localhost`
- `SELECT` sobre `ivr_legacy.*`
- `CREATE, DROP, INDEX, ALTER` sobre `test_ivr_legacy.*`
- Verificación de conexión TCP

### `provision-mariadb.sh` (`scripts/provision-mariadb.sh`)

- Todo lo anterior
- Tablas `tbl_historico_tN_YYYY` (6 quarters) con seed
- Tabla `tbl_temp_prueba_ivr` (3000 filas)
- Funciones de utilidad (`funciones_utilidad.sql`)
- SPs ETL (`sp_etl_pipeline.sql`)
- SPs Reportes (`sp_rpt_reportes.sql`)

---

## 3. Hallazgos

### H-MDB-010 — `schema_base_ivr.sql` nunca se aplica

**Severidad:** CRÍTICA — los SPs de ETL y reporte fallan al no encontrar sus tablas destino  
**Estado:** RESUELTO (2026-05-10)  
**Corrección:** `provision-mariadb.sh` v1.1.0 — agrega `schema_base_ivr.sql` en PASO 4
en el orden correcto de dependencias: `funciones_utilidad.sql` → `schema_base_ivr.sql`
→ `sp_etl_pipeline.sql` → `sp_rpt_reportes.sql`

`sp_etl_pipeline.sql` escribe en `base_ivr_detalle`, `base_ivr_clientes` y
`job_execution_log`. `sp_rpt_reportes.sql` lee `base_ivr_detalle`.
`schema_base_ivr.sql` crea estas cinco tablas pero no está en el flujo de
`provision-mariadb.sh`.

El orden correcto de aplicación es:

```
1. funciones_utilidad.sql   ← prerequisito del resto
2. schema_base_ivr.sql      ← prerequisito de sp_etl y sp_rpt
3. sp_etl_pipeline.sql
4. sp_rpt_reportes.sql
```

---

### H-MDB-011 — `provision-mariadb.sh` no está integrado en `setup.sh` raíz

**Severidad:** ALTA — `sudo bash setup.sh mariadb` deja la BD sin schema ni SPs  
**Estado:** RESUELTO (2026-05-10)  
**Corrección:** `setup.sh` raíz v1.x — agrega flag `--full` que ejecuta
`provision-mariadb.sh` en lugar de solo `provisioners/mariadb/setup.sh`.
Sin `--full`: BD + usuario + grants únicamente.
Con `--full`: schema completo + SPs + seed.

`setup.sh` raíz llama directamente a `provisioners/mariadb/setup.sh` (BD + usuario
únicamente). `provision-mariadb.sh` hace el provisionamiento completo pero vive en
`scripts/` sin conexión con el flujo de `setup.sh`.

Un operador que ejecute `sudo bash setup.sh mariadb` obtiene la BD y el usuario,
pero sin tablas históricas, sin SPs y sin datos de prueba. El entorno parece
funcional pero falla en tiempo de ejecución cuando Django invoca los endpoints IVR.

---

### H-MDB-012 — `provision-mariadb.sh` no carga `network.sh`

**Severidad:** ALTA — `mariadb_is_running()` falla al no tener `can_reach_port`  
**Estado:** RESUELTO (2026-05-10)  
**Corrección:** `provision-mariadb.sh` v1.1.0 — agrega `source utils/network.sh`
en la cadena de carga, antes de `utils/database.sh`

`mariadb_is_running()` en `database.sh` llama `can_reach_port()` que está definida
en `network.sh`. `provision-mariadb.sh` carga:

```bash
source utils/logging.sh
source utils/core.sh
source utils/validation.sh
source utils/database.sh      # ← usa can_reach_port de network.sh
```

`network.sh` no está en la cadena. Al llamar `mariadb_is_running`, el script falla
con `command not found: can_reach_port`.

---

### H-MDB-013 — Verificación de socket Unix faltante en `setup.sh`

**Severidad:** ALTA — mismo patrón que H-PG-002 en PostgreSQL  
**Estado:** RESUELTO (2026-05-10)  
**Corrección:** `provisioners/mariadb/setup.sh` — agrega verificación de conexión
via socket Unix después de verificar TCP; emite `log_warn` si el socket no responde

`setup.sh` de MariaDB verifica la conexión de Django via TCP
(`mysql -h "$host" -P "$port"`). IACT-api en producción se conecta via socket Unix
(`IVR_DB_SOCKET=/run/mysqld/mysqld.sock`). La verificación TCP pasa, pero la
conexión socket podría fallar si el socket no existe o los permisos no son correctos.

No hay un paso que verifique:
```bash
mysql --socket=/run/mysqld/mysqld.sock \
    -u "$db_user" -p"$db_pass" "$db_name" \
    -e "SELECT 1;"
```

---

### H-MDB-014 — Default de `base.py` no coincide con usuario provisionado

**Severidad:** MEDIA — fallo silencioso si `.env` no existe  
**Estado:** RESUELTO (2026-05-10) — corrección en IACT-api  
**Corrección:** `callcentersite/config/settings/base.py` — cambia default
`IVR_DB_USER` de `ivr_readonly` a `django_user`

`base.py` define como default `IVR_DB_USER=ivr_readonly` /
`IVR_DB_PASSWORD=ivr_readonly_password`. El provisioner crea `django_user`.
Sin `.env`, Django conecta con credenciales que no existen en la BD.

Esta discrepancia no causa problemas cuando `.env` está presente (que es el caso
normal), pero sí en entornos nuevos donde se olvida crear `.env` antes de arrancar.
El error es `Access denied for user 'ivr_readonly'@'localhost'` — no indica
claramente que falta el `.env`.

---

### H-MDB-015 — `provision-mariadb.sh` asume socket sin verificar existencia

**Severidad:** BAJA  
**Estado:** RESUELTO (2026-05-10)  
**Corrección:** `provision-mariadb.sh` v1.1.0 — verifica existencia del socket
antes de usarlo; si no existe, cambia a TCP como fallback. v1.2.0 — introduce
`sql_exec_query()` que encapsula este fallback para todas las queries de PASO 5.

El Paso 4 aplica SPs con `mysql --socket="$SOCK"` donde `SOCK` es
`/run/mysqld/mysqld.sock` hardcodeado. Si MariaDB arrancó pero el socket no existe
(arrancó solo via TCP, o el socket tiene path diferente), el paso falla con
`ERROR 2002` sin mensaje claro.

---

## 4. Estado consolidado (2026-05-10)

| Objeto requerido | Provisionado por | ¿Integrado en `setup.sh`? |
|---|---|---|
| BD `ivr_legacy` + usuario | `setup.sh` | Si |
| `tbl_historico_*` (6 tablas) | `provision-mariadb.sh` | Si (`--full`) |
| `tbl_temp_prueba_ivr` | `provision-mariadb.sh` | Si (`--full`) |
| `base_ivr_detalle` y tablas ETL | `provision-mariadb.sh` (H-MDB-010) | Si (`--full`) |
| Funciones de utilidad | `provision-mariadb.sh` | Si (`--full`) |
| SPs ETL y Reporte | `provision-mariadb.sh` | Si (`--full`) |
| Grants DML en tablas analíticas | `provision-mariadb.sh` (T-1.4) | Si (`--full`) |

---

## 5. Orden de implementación

Todos los hallazgos H-MDB-010..015 resueltos en sesión 2026-05-10.
Ver changelog de `provision-mariadb.sh` v1.1.0 y v1.2.0.

---

## Ver también

- `HALLAZGOS-PROVISIONER-MARIADB-2026-05-10.md` — hallazgos H-MDB-001..009
- `IACT-api/docs/setup/PREREQUISITOS-POSTGRESQL.md` — patrón equivalente para PostgreSQL
- `IACT-api/docs/setup/PREREQUISITOS-MARIADB.md` — prerequisitos de infraestructura MariaDB
