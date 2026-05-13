# Análisis — Módulo 15: Procedimientos Almacenados aplicados a IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Motor:** MariaDB 10.11.14

---

## Diferencias de sintaxis T-SQL vs MariaDB

El módulo enseña T-SQL (SQL Server). Todas las características existen en MariaDB
con sintaxis diferente.

| Concepto del módulo | T-SQL (SQL Server) | MariaDB 10.11 |
|---|---|---|
| Ejecutar un SP | `EXEC schema.sp_name @param = val` | `CALL sp_name(val)` |
| Parámetro de entrada | `@param AS INT` | `IN p_param INT` |
| Parámetro de salida | `@param AS INT OUTPUT` | `OUT p_param INT` |
| Crear SP | `CREATE PROCEDURE` | `CREATE PROCEDURE` |
| Modificar SP (body) | `ALTER PROCEDURE` (cambia el cuerpo) | `CREATE OR REPLACE PROCEDURE` |
| Modificar SP (metadatos) | No existe separado | `ALTER PROCEDURE` (solo COMMENT, SQL SECURITY) |
| SQL dinámico con parámetros | `EXEC sys.sp_executesql @sql, @params, @val` | `PREPARE stmt FROM @sql; EXECUTE stmt USING @val` |
| SQL dinámico sin parámetros | `EXEC(@sql)` | `PREPARE stmt FROM @sql; EXECUTE stmt` |
| Catálogo de parámetros | `sys.parameters` | `information_schema.PARAMETERS` |

---

## Lo que IACT-db ya implementa correctamente (validado por el módulo)

### SPs como interfaz de programación aislada

El módulo establece: *"los procedimientos pueden proporcionar una interfaz de
programación de aplicaciones confiable para una base de datos, aislando las
aplicaciones de los cambios en la estructura de la base de datos"*.

IACT-db cumple exactamente este principio: Django llama exclusivamente a los 12 SPs
a través de `cursor.callproc()`. Cuando la lógica de negocio cambia (como en las
4 fases de corrección), Django no necesita actualizar ningún código — solo se
despliega el nuevo SP.

### Parámetros OUT en `sp_etl_validar`

El módulo enseña el patrón OUTPUT para retornar valores del SP al llamador:

```sql
-- T-SQL:
CREATE PROCEDURE sp_proc (@input INT, @output INT OUTPUT) AS ...
EXEC sp_proc @input = 1, @output = @var OUTPUT;

-- IACT-db (MariaDB):
CREATE PROCEDURE sp_etl_validar(
    IN  p_quarter VARCHAR(10),
    OUT p_ok      BOOLEAN,
    OUT p_mensaje TEXT
)
-- sp_etl_maestro lo llama así:
CALL sp_etl_validar(v_quarter, v_ok, v_msg);
```

`sp_etl_maestro` usa `v_ok` para decidir si continuar o marcar el job como PARTIAL.
Este es el patrón correcto según el módulo.

### SQL dinámico con parámetros en `sp_etl_base_detalle` y `sp_etl_base_clientes`

El módulo recomienda `sp_executesql` sobre `EXEC(@string)` porque:
- Soporta parámetros de entrada y salida
- Minimiza el riesgo de inyección SQL
- Permite reutilización del plan de consulta

IACT-db ya usa el equivalente MariaDB en ambos SPs ETL:

```sql
-- sp_etl_base_detalle: p_table es el nombre dinámico de la tabla fuente
SET @etl_sql = CONCAT('INSERT INTO base_ivr_detalle ... FROM ', p_table, ' WHERE dFecha BETWEEN ? AND ?');
PREPARE etl_stmt FROM @etl_sql;
SET @etl_q = p_quarter, @etl_i = v_mes_ini, @etl_f = v_mes_fin;
EXECUTE etl_stmt USING @etl_q, @etl_i, @etl_f;  -- parámetros, no concatenación
```

`p_table` (nombre de tabla) no puede pasarse como parámetro a `USING` — es el
único componente dinámico en la cadena SQL. Los valores de filtro (`p_quarter`,
`v_mes_ini`, `v_mes_fin`) sí se pasan como `USING @params`, previniendo inyección
SQL en los valores. Correcto según el módulo.

### Catálogo de parámetros via `information_schema.PARAMETERS`

El módulo menciona `sys.parameters` para descubrir los parámetros de un SP.
MariaDB equivalente verificado en producción:

```sql
SELECT SPECIFIC_NAME, PARAMETER_MODE, PARAMETER_NAME, DATA_TYPE
FROM information_schema.PARAMETERS
WHERE SPECIFIC_SCHEMA = 'ivr_legacy'
ORDER BY SPECIFIC_NAME, ORDINAL_POSITION;
```

```
sp_etl_base_detalle   IN   p_quarter   varchar
sp_etl_base_detalle   IN   p_inicio    date
sp_etl_base_detalle   IN   p_fin       date
sp_etl_base_detalle   IN   p_table     varchar
sp_etl_base_detalle   IN   p_log_id    int
sp_etl_validar        IN   p_quarter   varchar
sp_etl_validar        OUT  p_ok        tinyint
sp_etl_validar        OUT  p_mensaje   text
sp_rpt_centros_xsegmento IN p_quarter  varchar
```

---

## Problema real identificado — el patrón `DROP + CREATE`

El módulo menciona `ALTER PROCEDURE` como forma de modificar un SP sin recrearlo.
Esto llevó a investigar el patrón actual de IACT-db en todos los archivos SQL:

```sql
-- Patrón actual en los 12 SPs (antes de este análisis):
DROP PROCEDURE IF EXISTS sp_etl_maestro$$
CREATE PROCEDURE sp_etl_maestro()
BEGIN ...
```

**El riesgo:** entre el `DROP` y el `CREATE` hay una ventana donde el SP no existe.
Si `evt_etl_diario` (programado a las 02:00) coincide con esa ventana durante un
despliegue, el evento falla con `ERROR 1305: PROCEDURE sp_etl_maestro does not exist`.
El evento no reintenta — los datos del día quedan sin actualizar silenciosamente.

**La ventana es de milisegundos** pero `provision-mariadb.sh` despliega los 20 objetos
en secuencia. Si el evento se activa mientras el script está corriendo, el riesgo es real.

---

## Corrección implementada — `CREATE OR REPLACE PROCEDURE`

MariaDB 10.11 soporta `CREATE OR REPLACE PROCEDURE` (desde 10.1.3). Esta instrucción
reemplaza atómicamente el SP existente sin pasar por un estado de "no existe":

```sql
-- Patrón nuevo en los 12 SPs:
CREATE OR REPLACE PROCEDURE sp_etl_maestro()
BEGIN ...
```

La diferencia con `ALTER PROCEDURE` de T-SQL: en MariaDB, `ALTER PROCEDURE` solo
modifica metadatos (`COMMENT`, `SQL SECURITY`) — no el cuerpo. Para cambiar el
cuerpo de un SP en MariaDB se usa `CREATE OR REPLACE`, que es la instrucción
equivalente al `ALTER PROCEDURE` de T-SQL.

**Verificado en motor real:**
```sql
CREATE OR REPLACE PROCEDURE _test(IN p INT) BEGIN SELECT p * 10; END;
-- Reemplazar sin DROP:
CREATE OR REPLACE PROCEDURE _test(IN p INT) BEGIN SELECT p * 20; END;
CALL _test(3);  -- devuelve 60 (no 30) — el reemplazo fue atómico
```

**Resultado de la implementación:**
12/12 SPs migrados de `DROP + CREATE` a `CREATE OR REPLACE`.
verify.sh: 27 OK, 0 WARN, 0 ERR.

---

## Lo que no aplica en MariaDB

**`EXEC` con nombre en dos partes (`schema.proc`):** MariaDB usa `CALL db.proc()` pero
en IACT-db los SPs están todos en `ivr_legacy` y Django ya especifica la base de datos
en la conexión. No hay cambio necesario.

**`sp_executesql` de SQL Server:** no existe en MariaDB. El equivalente
`PREPARE/EXECUTE USING` ya está correctamente implementado.

---

## Resumen

| Característica del módulo | Estado en IACT-db |
|---|---|
| SPs como API aislada para la aplicación | Ya implementado correctamente |
| Parámetros OUT | Ya usado en `sp_etl_validar` |
| SQL dinámico con parámetros | Ya usado en `sp_etl_base_detalle` y `sp_etl_base_clientes` |
| `CREATE OR REPLACE` (equivalente a ALTER T-SQL) | **Implementado en este análisis** — 12 SPs |
| Catálogo `information_schema.PARAMETERS` | Disponible, verificado |
| `EXEC` / `sp_executesql` (sintaxis T-SQL) | No aplica — MariaDB usa `CALL` y `PREPARE/EXECUTE` |

**El hallazgo accionable del módulo:** el concepto de "modificar el SP en un lugar
sin recrearlo" (la filosofía de `ALTER PROCEDURE`) señaló el riesgo del patrón
`DROP + CREATE` y llevó a migrar los 12 SPs a `CREATE OR REPLACE` — eliminando
la ventana de indisponibilidad durante despliegues en producción.
