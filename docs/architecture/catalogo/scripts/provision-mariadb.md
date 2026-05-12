# `scripts/provision-mariadb.sh`

**Versión:** 1.4.0  
**Requiere root:** Sí  
**Idempotente:** Sí — seguro re-ejecutar en cualquier estado

---

## Propósito

Provisionamiento completo de MariaDB en orden. Ejecuta todos los pasos
necesarios para dejar el entorno listo para IACT-api: instancia BD, usuario,
tablas históricas, schema analítico, stored procedures y grants.

---

## Uso

```bash
sudo bash scripts/provision-mariadb.sh             # completo
sudo bash scripts/provision-mariadb.sh --skip-seed # sin seed de prueba
sudo RUN_ETL_BACKFILL=1 bash scripts/provision-mariadb.sh  # con backfill ETL
```

---

## Pasos en orden

| Paso | Función | Descripción |
|---|---|---|
| 1/6 | `start.sh mariadb` | Arrancar MariaDB si no está corriendo |
| 2/6 | `provisioners/mariadb/setup.sh` | BD + usuario + grants base |
| 3/6 | `provisioners/mariadb/schema_historico.sh` | Tablas históricas + seed |
| 4/6 | `provisioners/mariadb/schema_seed.sh` | Tabla de prueba tbl_temp_prueba_ivr |
| 5/6 | SQL files en orden | funciones_utilidad, schema_base_ivr, sp_etl_pipeline, sp_rpt_reportes |
| 6/6 | `_apply_dml_grants` + `_apply_execute_grants` | Grants de acceso |
| Opcional | `_run_etl_backfill` | Backfill ETL si RUN_ETL_BACKFILL=1 |

---

## Funciones internas

| Función | Propósito |
|---|---|
| `sql_exec_file(archivo)` | Ejecuta un archivo SQL como root |
| `sql_exec_query(query, [db])` | Ejecuta una query inline como root |
| `_apply_dml_grants()` | Otorga SELECT, INSERT, UPDATE en `etl_runs` |
| `_apply_execute_grants()` | Otorga EXECUTE en los 9 SPs autorizados + 7 funciones |
| `_run_etl_backfill()` | Llama sp_etl_historico para quarters disponibles |

---

## Grants que aplica

**DML:** solo `etl_runs` — SELECT, INSERT, UPDATE (sin DELETE).  
**EXECUTE:** lista explícita de 9 SPs que Django invoca directamente.  
`sp_etl_base_detalle`, `sp_etl_base_clientes` y `sp_etl_validar` excluidos deliberadamente.
