# Hallazgos — Ejecución FASE 6 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 6  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-6.1 | `_apply_dml_grants` — eliminar 4 tablas sobrantes, quitar DELETE de etl_runs | COMPLETO | H-F6-001 |
| T-6.2 | `_apply_execute_grants` — cambiar a lista explícita de 9 SPs | COMPLETO | H-F6-002 |
| T-6.3 | Sintaxis y shellcheck limpios | COMPLETO | H-F6-003 |

---

## H-F6-001 — Los grants DML sobrantes persisten en la BD después de FASE 6

**Detectado en:** T-6.1, al verificar el estado de la BD después de la ejecución  
**Severidad:** ALTA — es el comportamiento esperado, pero crítico documentarlo  
**Estado:** DOCUMENTADO — se resuelve en FASE 7

### Descripción

Después de ejecutar `provision-mariadb.sh` con el nuevo código, los grants
sobrantes que existían en la BD **persisten**. El script corregido no otorga
los grants incorrectos en nuevas ejecuciones, pero no revoca los que ya existen.

```
BD después de FASE 6 (grants en TABLE_PRIVILEGES):
  base_ivr_clientes : DELETE, INSERT, SELECT, UPDATE  ← exceso
  base_ivr_detalle  : DELETE, INSERT, SELECT, UPDATE  ← exceso
  etl_runs          : DELETE, INSERT, SELECT, UPDATE  ← DELETE es exceso
  job_config        : DELETE, INSERT, SELECT, UPDATE  ← exceso
  job_execution_log : DELETE, INSERT, SELECT, UPDATE  ← exceso
```

**Razón del diseño (FASE 6 y FASE 7 separadas):**

`GRANT` en MariaDB es una operación aditiva — añade permisos pero no los
elimina. El nuevo `_apply_dml_grants` solo hace `GRANT SELECT, INSERT, UPDATE ON etl_runs`,
lo que es correcto para nuevas instalaciones. Para el entorno existente donde
los grants sobrantes ya fueron otorgados en versiones anteriores del script,
se requieren `REVOKE` explícitos.

La separación entre FASE 6 (corrección del código) y FASE 7 (REVOKE en BD)
es intencional:
- FASE 6 garantiza que instalaciones nuevas sean correctas desde el inicio
- FASE 7 limpia el estado del entorno existente
- Ejecutar las fases por separado permite auditar el estado intermedio

Ejecutar `provision-mariadb.sh` después de FASE 7 confirmaría que los grants
correctos son los únicos presentes.

---

## H-F6-002 — El cambio de consulta dinámica a lista explícita tiene implicación de mantenimiento

**Detectado en:** T-6.2, durante el análisis de la estrategia del cambio  
**Severidad:** INFORMATIVO — decisión de diseño documentada  
**Estado:** DOCUMENTADO

### Descripción

La versión anterior de `_apply_execute_grants` usaba:

```sql
SELECT ROUTINE_NAME FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = '${DB}' AND ROUTINE_TYPE = 'PROCEDURE'
```

Esto otorgaba `EXECUTE` automáticamente a **todos** los procedimientos del
schema, incluyendo los SPs internos del ETL que solo root debe invocar.

La versión corregida usa una lista explícita con `IN(...)`:

```sql
SELECT ROUTINE_NAME FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = '${DB}'
AND ROUTINE_TYPE = 'PROCEDURE'
AND ROUTINE_NAME IN (
    'sp_etl_maestro',
    'sp_etl_historico',
    'sp_rpt_clientes',
    ...
)
```

**Implicación de mantenimiento:** Si se agrega un SP nuevo que Django deba
invocar directamente, debe añadirse explícitamente a esta lista con su
justificación documentada. Esto es una decisión de diseño correcta —
el principio de menor privilegio requiere que cada permiso sea consciente.

**SPs excluidos deliberadamente:**

| SP | Razón de exclusión |
|---|---|
| `sp_etl_base_detalle` | Invocado internamente por `sp_etl_maestro` como `DEFINER=root` |
| `sp_etl_base_clientes` | Ídem |
| `sp_etl_validar` | Ídem |

Las 7 funciones (`fn_did_segmento`, `fn_normalizar_*`, `fn_duracion_seg`,
`ivr_es_dia_semana`, `ivr_contar_dias_semana`, `ivr_agregar_dias_semana`)
se conservan con consulta dinámica. Las funciones son de solo cálculo/lectura
y no presentan riesgo de seguridad. Si se agregan funciones nuevas al schema,
recibirán `EXECUTE` automáticamente — comportamiento aceptable para funciones
de utilidad matemática.

---

## H-F6-003 — SC2043: loop de una iteración — resuelto eliminando el loop

**Detectado en:** T-6.3, durante la verificación con shellcheck  
**Severidad:** BAJA — shellcheck warning resuelto  
**Estado:** RESUELTO en T-6.3

### Descripción

La primera versión del nuevo `_apply_dml_grants` usaba el mismo patrón de
loop que la versión anterior:

```bash
for tbl in etl_runs; do   # SC2043: loop que solo corre una vez
    ...
done
```

shellcheck SC2043 advierte que un loop con un único elemento literal es
sospechoso — suele indicar un error de expansión de variable o glob.
Aunque el loop era intencional (el código estaba diseñado para ser extendido),
la advertencia es válida porque:

1. Un loop con una sola iteración no aporta claridad
2. Si se necesita extender, la decisión de agregar más tablas debe ser
   explícita con justificación documentada en el comentario

**Resolución:** Eliminar el loop y escribir el código directamente para
`etl_runs`. El comentario documenta cómo restaurar el loop si en el futuro
se necesitan más tablas.

---

## Cambios implementados

### `_apply_dml_grants` — T-6.1 y T-6.3

```bash
# Antes (5 tablas, SIDU completo):
for tbl in base_ivr_detalle base_ivr_clientes \
           job_execution_log etl_runs job_config; do
    stmt="GRANT SELECT, INSERT, UPDATE, DELETE
        ON `${DB}`.`${tbl}` TO '${DB_USER}'@'${host}';"
done

# Después (1 tabla, SIU — sin DELETE):
# Sin loop — código directo para etl_runs (evita SC2043)
stmt="GRANT SELECT, INSERT, UPDATE
    ON `${DB}`.`etl_runs` TO '${DB_USER}'@'${host}';"
```

Resultado al ejecutar:
```
[SUCCESS] Grants DML aplicados (2 grants — etl_runs: SELECT, INSERT, UPDATE)
```

### `_apply_execute_grants` — T-6.2

```sql
-- Antes (todos los SPs del schema):
SELECT ROUTINE_NAME FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='${DB}' AND ROUTINE_TYPE='PROCEDURE'

-- Después (lista explícita de 9 SPs que Django invoca directamente):
SELECT ROUTINE_NAME FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='${DB}'
AND ROUTINE_TYPE='PROCEDURE'
AND ROUTINE_NAME IN (
    'sp_etl_maestro',
    'sp_etl_historico',
    'sp_rpt_clientes',
    'sp_rpt_centros_transferencia',
    'sp_rpt_llamadas_abandonadas',
    'sp_rpt_cMENU_ERROR',
    'sp_rpt_centros_xsegmento',
    'sp_rpt_menu_redirigidos',
    'sp_rpt_menu_centro'
)
```

Resultado al ejecutar:
```
[SUCCESS] Grants EXECUTE aplicados (32 grants — 16 routines × 2 hosts)
```
16 routines = 9 SPs + 7 funciones. Los 3 SPs internos no están presentes:

```
sp_etl_historico              PROCEDURE  ✓
sp_etl_maestro                PROCEDURE  ✓
sp_rpt_centros_transferencia  PROCEDURE  ✓
sp_rpt_centros_xsegmento      PROCEDURE  ✓
sp_rpt_clientes               PROCEDURE  ✓
sp_rpt_cMENU_ERROR            PROCEDURE  ✓
sp_rpt_llamadas_abandonadas   PROCEDURE  ✓
sp_rpt_menu_centro            PROCEDURE  ✓
sp_rpt_menu_redirigidos       PROCEDURE  ✓
fn_did_segmento               FUNCTION   ✓
fn_duracion_seg               FUNCTION   ✓
fn_normalizar_centro          FUNCTION   ✓
fn_normalizar_menu            FUNCTION   ✓
ivr_agregar_dias_semana       FUNCTION   ✓
ivr_contar_dias_semana        FUNCTION   ✓
ivr_es_dia_semana             FUNCTION   ✓
-- sp_etl_base_detalle NO PRESENTE ✓
-- sp_etl_base_clientes NO PRESENTE ✓
-- sp_etl_validar NO PRESENTE ✓
```

---

## Estado pendiente — nota sobre la BD actual

FASE 6 corrige el código. Los grants sobrantes en la BD actual persisten
hasta que FASE 7 ejecute los `REVOKE` correspondientes:

| Grant sobrante | Estado tras FASE 6 |
|---|---|
| `SIDU ON base_ivr_detalle` | Persiste en BD — pendiente FASE 7 |
| `SIDU ON base_ivr_clientes` | Persiste en BD — pendiente FASE 7 |
| `SIDU ON job_execution_log` | Persiste en BD — pendiente FASE 7 |
| `SIDU ON job_config` | Persiste en BD — pendiente FASE 7 |
| `DELETE ON etl_runs` | Persiste en BD — pendiente FASE 7 |
| `EXECUTE ON sp_etl_base_detalle` | Persiste en BD — pendiente FASE 7 |
| `EXECUTE ON sp_etl_base_clientes` | Persiste en BD — pendiente FASE 7 |
| `EXECUTE ON sp_etl_validar` | Persiste en BD — pendiente FASE 7 |

---

## Estado de los ítems del plan tras FASE 6

| Ítem | Descripción | Estado |
|---|---|---|
| CNST-003 código `_apply_dml_grants` | Solo `etl_runs` con `SELECT, INSERT, UPDATE` | RESUELTO — T-6.1/T-6.3 |
| CNST-003 código `_apply_execute_grants` | Lista explícita de 9 SPs, excluye SPs internos | RESUELTO — T-6.2 |
| CNST-003 grants BD sobrantes | REVOKE de 8 objetos | PENDIENTE — FASE 7 |
