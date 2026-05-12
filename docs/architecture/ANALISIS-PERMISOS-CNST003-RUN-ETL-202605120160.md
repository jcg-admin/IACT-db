# Análisis de permisos — CNST-003, restricción READ-ONLY y job ETL

**Fecha:** 2026-05-11  
**Alcance:** `provisioners/mariadb/setup.sh`, `scripts/provision-mariadb.sh`,  
`apps/pipeline/management/commands/run_etl.py`, `apps/pipeline/scheduler.py`,  
`apps/pipeline/views.py`, `apps/reports/ivr_services.py`

---

## Pregunta concreta

CNST-003 dice que `django_user` es READ-ONLY en `ivr_legacy`.  
`run_etl.py` necesita escribir en MariaDB para registrar la ejecución.  
¿Contradicción? ¿Qué permisos se necesitan realmente?

---

## La restricción en dos capas

El aprovisionamiento aplica los permisos en dos pasos con responsabilidades distintas.

### Capa 1 — `setup.sh` (CNST-003 base)

```sql
GRANT SELECT ON `ivr_legacy`.* TO 'django_user'@'localhost';
GRANT SELECT ON `ivr_legacy`.* TO 'django_user'@'%';
-- Tests:
GRANT CREATE, DROP, INDEX, ALTER ON `test_ivr_legacy`.*
    TO 'django_user'@'localhost';
```

`django_user` puede leer cualquier tabla de `ivr_legacy`. Sin escritura, sin EXECUTE.

La verificación CNST-003 en `setup.sh` consulta `USER_PRIVILEGES` (grants globales)
y devuelve 0 escrituras — correcto en este punto.

### Capa 2 — `provision-mariadb.sh` (extensión operacional)

```sql
-- _apply_dml_grants: 5 tablas con SIDU completo
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`etl_runs`        TO ...
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`base_ivr_detalle` TO ...
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`base_ivr_clientes` TO ...
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`job_execution_log` TO ...
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`job_config`        TO ...

-- _apply_execute_grants: 12 SPs + 7 funciones
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_maestro` TO ...
-- ... (11 SPs más, 7 funciones)
```

Estos son grants de tabla (`TABLE_PRIVILEGES`), invisibles a `USER_PRIVILEGES`.
La verificación CNST-003 de `setup.sh` sigue viendo 0 aunque estos existan.
No es un bug de seguridad — es una verificación incompleta que engaña al operador.

---

## Qué hace Django con MariaDB (uso real auditado en el código)

### `run_etl.py` y `scheduler.py` — job ETL

| Operación | SQL | Tabla afectada |
|---|---|---|
| Registrar inicio | `INSERT INTO etl_runs (trimestre, inicio_at, ...)` | `etl_runs` |
| Heartbeat | `UPDATE etl_runs SET heartbeat_at=NOW() WHERE id=?` | `etl_runs` |
| Marcar timeout | `UPDATE etl_runs SET status='timeout' WHERE ...` | `etl_runs` |
| Invocar ETL | `CALL sp_etl_maestro()` | (delega a root) |
| Cerrar run | `UPDATE etl_runs SET status=?, fin_at=NOW() WHERE id=?` | `etl_runs` |

### `pipeline/views.py` — endpoints de observabilidad

Todas son `SELECT` sobre `job_execution_log` y `etl_runs`.
Una llama `CALL sp_etl_historico(year, quarter)` (ETLReintentarView).

### `reports/ivr_services.py` — endpoints de reportes

Llama a 7 SPs: `sp_rpt_clientes`, `sp_rpt_centros_transferencia`,
`sp_rpt_llamadas_abandonadas`, `sp_rpt_cMENU_ERROR`,
`sp_rpt_centros_xsegmento`, `sp_rpt_menu_redirigidos`, `sp_rpt_menu_centro`.

### Dentro de `sp_etl_maestro` (DEFINER=root@localhost)

El SP corre con privilegios de root. `django_user` no necesita permisos
para estas operaciones internas:

```
INSERT/UPDATE job_execution_log  →  root
CALL sp_etl_base_detalle         →  root → escribe base_ivr_detalle
CALL sp_etl_base_clientes        →  root → escribe base_ivr_clientes
CALL sp_etl_validar              →  root
```

---

## Grants actuales vs grants necesarios

| Grant actual | Necesario | Justificación |
|---|---|---|
| `SELECT ON ivr_legacy.*` | ✅ | CNST-003 base — lectura universal |
| `SELECT, INSERT, UPDATE ON etl_runs` | ✅ | run_etl.py y scheduler.py escriben aquí |
| `DELETE ON etl_runs` | ❌ exceso | Ningún archivo .py hace DELETE en etl_runs |
| `SIDU ON base_ivr_detalle` | ❌ exceso | Solo root escribe aquí. SELECT ya cubierto por el grant global |
| `SIDU ON base_ivr_clientes` | ❌ exceso | Solo root escribe aquí. SELECT ya cubierto |
| `SIDU ON job_execution_log` | ❌ exceso | Solo root escribe aquí. SELECT ya cubierto |
| `SIDU ON job_config` | ❌ exceso | Django solo lee. SELECT ya cubierto |
| `EXECUTE ON sp_etl_maestro` | ✅ | run_etl.py + scheduler.py |
| `EXECUTE ON sp_etl_historico` | ✅ | ETLReintentarView |
| `EXECUTE ON sp_rpt_*` (7 SPs) | ✅ | reports/ivr_services.py |
| `EXECUTE ON sp_etl_base_detalle` | ❌ exceso | Root lo llama desde sp_etl_maestro |
| `EXECUTE ON sp_etl_base_clientes` | ❌ exceso | Root lo llama desde sp_etl_maestro |
| `EXECUTE ON sp_etl_validar` | ❌ exceso | Root lo llama desde sp_etl_maestro |
| `EXECUTE ON fn_*` (7 funciones) | ⚠️ defensivo | Las funciones son llamadas por los SPs como root. Django no las invoca directamente. Sin impacto de seguridad; se conservan |

---

## El modelo correcto

### Definición actualizada de CNST-003

> `django_user` tiene READ-ONLY sobre los **datos del dominio IVR**:
> tablas históricas (`tbl_historico_*`) y tabla de prueba (`tbl_temp_prueba_ivr`).
>
> La única excepción explícita es `etl_runs`: `django_user` necesita
> `INSERT, UPDATE` para que el management command `run_etl` y el scheduler
> APScheduler puedan registrar el ciclo de vida de las ejecuciones del job.
> `DELETE` está deliberadamente excluido — no hay caso de uso.

### Grants correctos para `_apply_dml_grants`

```sql
-- ÚNICA tabla donde django_user escribe directamente.
-- run_etl.py registra inicio, heartbeat y cierre del job.
-- scheduler.py hace lo mismo para el disparo nocturno (APScheduler).
-- DELETE excluido deliberadamente — no hay caso de uso en el código.
GRANT SELECT, INSERT, UPDATE
    ON `ivr_legacy`.`etl_runs`
    TO 'django_user'@'localhost';
GRANT SELECT, INSERT, UPDATE
    ON `ivr_legacy`.`etl_runs`
    TO 'django_user'@'%';
FLUSH PRIVILEGES;
```

### Grants correctos para `_apply_execute_grants`

```sql
-- SPs que Django invoca directamente.
-- Los SPs internos (sp_etl_base_*, sp_etl_validar) los llama root
-- desde sp_etl_maestro — django_user no los necesita.
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_maestro`
    TO 'django_user'@'localhost';   -- run_etl.py, scheduler.py
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_historico`
    TO 'django_user'@'localhost';   -- ETLReintentarView
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_clientes`
    TO 'django_user'@'localhost';   -- UC_RPT_17
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_centros_transferencia`
    TO 'django_user'@'localhost';   -- UC_RPT_12
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_llamadas_abandonadas`
    TO 'django_user'@'localhost';   -- UC_RPT_13
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_cMENU_ERROR`
    TO 'django_user'@'localhost';   -- UC_RPT_14
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_centros_xsegmento`
    TO 'django_user'@'localhost';   -- UC_RPT_15
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_menu_redirigidos`
    TO 'django_user'@'localhost';   -- UC_RPT_16
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_menu_centro`
    TO 'django_user'@'localhost';   -- UC_RPT_16
-- (ídem para @'%')
FLUSH PRIVILEGES;
```

### Tablas escritas por root (django_user no necesita DML)

| Tabla | Escritor real | django_user puede leerla |
|---|---|---|
| `job_execution_log` | `sp_etl_maestro` (DEFINER=root) | Sí — SELECT global |
| `base_ivr_detalle` | `sp_etl_base_detalle` (DEFINER=root) | Sí — SELECT global |
| `base_ivr_clientes` | `sp_etl_base_clientes` (DEFINER=root) | Sí — SELECT global |
| `job_config` | Nadie en el código actual | Sí — SELECT global |

---

## Impacto de corregir `_apply_dml_grants`

Eliminar los grants sobrantes no rompe ninguna funcionalidad:

- `run_etl.py` y `scheduler.py`: siguen funcionando — conservan INSERT/UPDATE en etl_runs
- Endpoints de reportes: siguen funcionando — conservan EXECUTE en sp_rpt_*
- ETLReintentarView: sigue funcionando — conserva EXECUTE en sp_etl_historico
- Lectura de job_execution_log, base_ivr_detalle, etc.: sigue funcionando — SELECT global

Lo que se elimina: la capacidad de que django_user modifique directamente
los resultados del ETL y el log de checkpoints. Esas tablas son territorio
de root vía DEFINER — django_user no debería poder alterarlas.

---

## El bug en la verificación CNST-003

```sql
-- Lo que usa setup.sh (USER_PRIVILEGES — solo grants globales ON *.*):
SELECT COUNT(*) FROM information_schema.USER_PRIVILEGES
WHERE GRANTEE LIKE 'django_user%'
AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE','DROP','CREATE','ALTER');
-- → 0 siempre, aunque provision-mariadb.sh haya otorgado SIDU en 5 tablas
```

```sql
-- Lo que debería consultarse (TABLE_PRIVILEGES — grants de tabla):
SELECT TABLE_NAME, GROUP_CONCAT(PRIVILEGE_TYPE ORDER BY PRIVILEGE_TYPE) AS grants
FROM information_schema.TABLE_PRIVILEGES
WHERE GRANTEE LIKE 'django_user%'
AND TABLE_SCHEMA = 'ivr_legacy'
AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE')
GROUP BY TABLE_NAME;
-- → muestra exactamente qué tablas tienen escritura y cuáles no
```

La verificación actual siempre pasa porque `provision-mariadb.sh` se corre
después de `setup.sh` y sus grants de tabla son invisibles a `USER_PRIVILEGES`.
El operador ve "CNST-003 verificado" pero la imagen completa de permisos
no se refleja en esa verificación.
