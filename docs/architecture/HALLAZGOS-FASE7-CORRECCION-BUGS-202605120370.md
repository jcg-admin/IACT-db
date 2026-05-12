# Hallazgos — Ejecución FASE 7 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 7  
**Prerequisito:** FASE 6 completada (commit `e8f223f`)  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-7.1 | `REVOKE DELETE ON etl_runs` @localhost y @% | COMPLETO | — |
| T-7.2 | `REVOKE SIDU ON` las 4 tablas sobrantes @localhost y @% | COMPLETO | H-F7-001 |
| T-7.3 | `EXECUTE` en SPs internos: confirmar limpieza de FASE 5+6 | COMPLETO | H-F7-002 |
| T-7.4 | Verificar inventario completo de grants resultantes | PASA | — |
| T-7.5 | Verificar que `run_etl` funciona y DELETE está denegado | PASA | — |
| T-7.6 | verify.sh 27 OK sin regresión | PASA | — |

---

## H-F7-001 — REVOKE de grant de tabla no afecta el grant de schema

**Detectado en:** T-7.2, durante el análisis de impacto antes de ejecutar  
**Severidad:** INFORMATIVO — comportamiento de MariaDB documentado y verificado  
**Estado:** DOCUMENTADO

### Descripción

Antes de ejecutar T-7.2, se planteó la pregunta: si se revoca `SELECT` sobre
una tabla específica (`REVOKE SELECT ON ivr_legacy.base_ivr_detalle`), ¿se
revoca también el `SELECT` que viene del grant global (`GRANT SELECT ON ivr_legacy.*`)?

MariaDB mantiene dos niveles de grants independientes:

- **Schema-level:** `GRANT SELECT ON ivr_legacy.* TO django_user` — cubre toda la BD
- **Table-level:** `GRANT SELECT, INSERT, UPDATE ON ivr_legacy.base_ivr_detalle TO django_user` — específico de tabla

`REVOKE SELECT ON ivr_legacy.base_ivr_detalle` elimina únicamente el
table-level grant. El schema-level grant sigue intacto y django_user conserva
`SELECT` sobre esa tabla.

### Verificación empírica

Se creó y eliminó un usuario de prueba (`test_revoke_user`) para verificar
sin riesgo sobre django_user:

```sql
-- Estado inicial:
GRANT SELECT ON `ivr_legacy`.* TO `test_revoke_user`@`localhost`
GRANT SELECT, INSERT, UPDATE ON `ivr_legacy`.`base_ivr_detalle` TO `test_revoke_user`@`localhost`

-- Después de REVOKE SELECT, INSERT, UPDATE ON base_ivr_detalle:
GRANT SELECT ON `ivr_legacy`.* TO `test_revoke_user`@`localhost`
-- El table-level grant desapareció; el schema-level sigue

-- SELECT sigue funcionando:
SELECT COUNT(*) FROM base_ivr_detalle → 16555 filas  ✓
-- INSERT denegado:
INSERT INTO base_ivr_detalle ... → ERROR 1142  ✓
```

Esto confirma que revocar el table-level grant no crea un "agujero" en el
schema-level grant. El acceso de solo lectura de django_user sobre todas las
tablas de `ivr_legacy` sigue vigente desde el `GRANT SELECT ON ivr_legacy.*`
aplicado por `provisioners/mariadb/setup.sh` (CNST-003 base).

---

## H-F7-002 — Los EXECUTE de SPs internos ya estaban eliminados: FASE 7 es solo verificación

**Detectado en:** T-7.3, al inspeccionar el estado antes de ejecutar  
**Severidad:** INFORMATIVO — consecuencia del diseño de FASE 5 y FASE 6  
**Estado:** DOCUMENTADO

### Descripción

El plan de FASE 7 incluía T-7.3 como "REVOKE EXECUTE en `sp_etl_base_detalle`,
`sp_etl_base_clientes`, `sp_etl_validar`". Al verificar el estado de la BD,
estos grants ya no existían, por lo que T-7.3 se convirtió en verificación
en lugar de acción.

**Cronología de la eliminación:**

1. **FASE 5 (FASE 5 del plan de corrección, commit `62559b6`):** El redespliegue de
   `sp_rpt_reportes.sql` usó `DROP PROCEDURE IF EXISTS` + `CREATE PROCEDURE`. En
   MariaDB, `DROP PROCEDURE` elimina automáticamente todos los `GRANT EXECUTE`
   asociados. Este efecto se aplicó también en la sesión anterior a FASE 5 cuando
   se ejecutó `sp_etl_pipeline.sql` (FASE 4), que usa el mismo patrón `DROP/CREATE`.

2. **FASE 6 (commit `e8f223f`):** La ejecución de `provision-mariadb.sh` con el
   nuevo `_apply_execute_grants` usó la lista explícita de 9 SPs. Los grants
   `EXECUTE` para `sp_etl_base_detalle`, `sp_etl_base_clientes` y
   `sp_etl_validar` no se aplicaron porque no están en la lista.

**Resultado:** Cuando llegó FASE 7, los EXECUTE sobrantes ya no existían.
T-7.3 confirmó este estado sin necesidad de ejecutar `REVOKE`.

Esta interacción entre fases fue beneficiosa — la corrección del código en
FASE 6 produjo parte del efecto esperado en FASE 7 como consecuencia natural
del comportamiento de MariaDB con `DROP/CREATE PROCEDURE`.

---

## Estado de la BD antes y después de FASE 7

### Antes (sobrantes que existían)

```
TABLE_PRIVILEGES:
  base_ivr_clientes: DELETE, INSERT, SELECT, UPDATE @localhost y @%  (8 filas)
  base_ivr_detalle:  DELETE, INSERT, SELECT, UPDATE @localhost y @%  (8 filas)
  etl_runs:          DELETE, INSERT, SELECT, UPDATE @localhost y @%  (8 filas)
  job_config:        DELETE, INSERT, SELECT, UPDATE @localhost y @%  (8 filas)
  job_execution_log: DELETE, INSERT, SELECT, UPDATE @localhost y @%  (8 filas)
  TOTAL: 40 filas
```

### Después (estado correcto)

```
TABLE_PRIVILEGES:
  etl_runs: INSERT, SELECT, UPDATE @localhost y @%  (6 filas)
  TOTAL: 6 filas

EXECUTE (mysql.procs_priv, DISTINCT por routine):
  PROCEDURE: sp_etl_historico, sp_etl_maestro, sp_rpt_* (7)  = 9 procedures
  FUNCTION: fn_did_segmento, fn_duracion_seg, fn_normalizar_centro,
            fn_normalizar_menu, ivr_agregar_dias_semana,
            ivr_contar_dias_semana, ivr_es_dia_semana             = 7 functions
```

---

## Inventario final de grants de `django_user@localhost`

```sql
GRANT USAGE ON *.* TO `django_user`@`localhost`
GRANT SELECT ON `ivr_legacy`.* TO `django_user`@`localhost`
GRANT CREATE, DROP, INDEX, ALTER ON `test_ivr_legacy`.* TO `django_user`@`localhost`
GRANT SELECT, INSERT, UPDATE ON `ivr_legacy`.`etl_runs` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_maestro` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_historico` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_clientes` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_centros_transferencia` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_llamadas_abandonadas` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_cMENU_ERROR` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_centros_xsegmento` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_menu_redirigidos` TO `django_user`@`localhost`
GRANT EXECUTE ON PROCEDURE `ivr_legacy`.`sp_rpt_menu_centro` TO `django_user`@`localhost`
GRANT EXECUTE ON FUNCTION `ivr_legacy`.`fn_did_segmento` TO `django_user`@`localhost`
GRANT EXECUTE ON FUNCTION `ivr_legacy`.`fn_normalizar_menu` TO `django_user`@`localhost`
GRANT EXECUTE ON FUNCTION `ivr_legacy`.`fn_duracion_seg` TO `django_user`@`localhost`
GRANT EXECUTE ON FUNCTION `ivr_legacy`.`fn_normalizar_centro` TO `django_user`@`localhost`
GRANT EXECUTE ON FUNCTION `ivr_legacy`.`ivr_contar_dias_semana` TO `django_user`@`localhost`
GRANT EXECUTE ON FUNCTION `ivr_legacy`.`ivr_es_dia_semana` TO `django_user`@`localhost`
GRANT EXECUTE ON FUNCTION `ivr_legacy`.`ivr_agregar_dias_semana` TO `django_user`@`localhost`
```

Ídem para `@'%'` (acceso remoto).

---

## Verificación funcional de `run_etl`

```
1. INSERT etl_runs (registrar inicio): OK (id=7)
2. UPDATE etl_runs (heartbeat):        OK
3. CALL sp_etl_maestro:                OK
4. UPDATE etl_runs (estado final):     OK
5. DELETE etl_runs:                    ERROR 1142 (correcto — acceso revocado)

RESULTADO: run_etl funciona correctamente. DELETE correctamente denegado.
```

---

## Estado de los ítems del plan tras FASE 7

| Ítem | Descripción | Estado |
|---|---|---|
| CNST-003 BD `DELETE ON etl_runs` | Revocado @localhost y @% | RESUELTO — T-7.1 |
| CNST-003 BD `SIDU ON base_ivr_detalle` | Revocado @localhost y @% | RESUELTO — T-7.2 |
| CNST-003 BD `SIDU ON base_ivr_clientes` | Revocado @localhost y @% | RESUELTO — T-7.2 |
| CNST-003 BD `SIDU ON job_execution_log` | Revocado @localhost y @% | RESUELTO — T-7.2 |
| CNST-003 BD `SIDU ON job_config` | Revocado @localhost y @% | RESUELTO — T-7.2 |
| CNST-003 BD `EXECUTE ON sp_etl_base_detalle` | Eliminado en FASE 5+6 — confirmado | RESUELTO — T-7.3 |
| CNST-003 BD `EXECUTE ON sp_etl_base_clientes` | Eliminado en FASE 5+6 — confirmado | RESUELTO — T-7.3 |
| CNST-003 BD `EXECUTE ON sp_etl_validar` | Eliminado en FASE 5+6 — confirmado | RESUELTO — T-7.3 |
