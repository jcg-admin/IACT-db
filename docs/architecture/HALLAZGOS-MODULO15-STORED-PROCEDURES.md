# Hallazgos — Análisis Módulo 15 (Procedimientos Almacenados)

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Módulo de referencia:** Módulo 15 — Ejecución de Procedimientos Almacenados  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Objetos modificados

| Archivo | Objeto | Tipo | Versión | Cambio aplicado |
|---|---|---|---|---|
| `objetos/funciones/fn_did_segmento.sql` | `fn_did_segmento` | FUNCTION | 2.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/funciones/fn_duracion_seg.sql` | `fn_duracion_seg` | FUNCTION | 2.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/funciones/fn_normalizar_centro.sql` | `fn_normalizar_centro` | FUNCTION | 2.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/funciones/fn_normalizar_menu.sql` | `fn_normalizar_menu` | FUNCTION | 2.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/funciones/ivr_agregar_dias_semana.sql` | `ivr_agregar_dias_semana` | FUNCTION | 3.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/funciones/ivr_contar_dias_semana.sql` | `ivr_contar_dias_semana` | FUNCTION | 3.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/funciones/ivr_es_dia_semana.sql` | `ivr_es_dia_semana` | FUNCTION | 2.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/jobs/evt_etl_diario.sql` | `evt_etl_diario` | EVENT | 2.0.0 | DROP+CREATE → CREATE OR REPLACE |
| `objetos/sps/` (12 archivos) | 12 SPs ETL y reporte | PROCEDURE | varios | DROP+CREATE → CREATE OR REPLACE |

**Total: 20/20 objetos migrados.** Ningún objeto pasa por estado de "no existe" durante despliegue.

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-15.1 | Análisis de características del módulo vs MariaDB 10.11 | COMPLETO | H-M15-001 |
| T-15.2 | Verificar `CREATE OR REPLACE` para los tres tipos de objeto | PASA | H-M15-002 |
| T-15.3 | Migrar 12 SPs de `DROP+CREATE` a `CREATE OR REPLACE` | COMPLETO | — |
| T-15.4 | Identificar que las funciones y el evento tienen el mismo riesgo | COMPLETO | H-M15-003 |
| T-15.5 | Migrar 7 funciones y el evento | COMPLETO | — |
| T-15.6 | Redesplegar los 20 objetos y verify.sh | PASA | — |

---

## H-M15-001 — El módulo expuso el riesgo del patrón `DROP + CREATE` en producción

**Detectado en:** T-15.1, al analizar el concepto de `ALTER PROCEDURE`  
**Severidad:** ALTA — fallo silencioso del ETL nocturno sin dejar registro de error claro  
**Estado:** RESUELTO en T-15.3 y T-15.5

### Descripción

El módulo describe `ALTER PROCEDURE` como la forma de modificar un SP sin recrearlo.
Eso llevó a examinar el patrón existente en IACT-db: los 20 archivos SQL usaban
`DROP IF EXISTS` seguido de `CREATE`, lo que genera una ventana de indisponibilidad:

```sql
-- Patrón anterior en los 20 objetos:
DROP PROCEDURE IF EXISTS sp_etl_maestro$$    -- ← SP no existe aquí
CREATE PROCEDURE sp_etl_maestro()            -- ← vuelve a existir aquí
BEGIN ...
```

La ventana entre `DROP` y `CREATE` es de milisegundos. Sin embargo, en producción:

- `evt_etl_diario` se activa a las 02:00 con `CALL sp_etl_maestro()`
- `provision-mariadb.sh` se puede ejecutar en cualquier momento para desplegar actualizaciones
- Si el evento coincide con la ventana del DROP de `sp_etl_maestro`, el resultado es:
  `ERROR 1305: PROCEDURE sp_etl_maestro does not exist`
- El evento **no reintenta** — los datos del día quedan sin actualizar silenciosamente
- `job_execution_log` no recibe ninguna entrada del intento fallido

### Corrección

`CREATE OR REPLACE PROCEDURE/FUNCTION/EVENT` es atómico en MariaDB 10.11.
El objeto nunca desaparece durante el reemplazo.

```sql
-- Patrón nuevo en los 20 objetos:
CREATE OR REPLACE PROCEDURE sp_etl_maestro()
BEGIN ...
```

Verificado en motor real: un segundo `CREATE OR REPLACE` sobre el mismo objeto
reemplaza el cuerpo inmediatamente — sin ventana de indisponibilidad.

---

## H-M15-002 — `ALTER PROCEDURE` en MariaDB no cambia el cuerpo del SP

**Detectado en:** T-15.2, durante la verificación de la equivalencia MariaDB ↔ T-SQL  
**Severidad:** Informativo — diferencia de sintaxis, no un error  
**Estado:** DOCUMENTADO

### Descripción

El módulo enseña `ALTER PROCEDURE` como la forma de modificar un SP existente.
En T-SQL (SQL Server), `ALTER PROCEDURE` reemplaza el cuerpo completo del SP.

En MariaDB 10.11, `ALTER PROCEDURE` **solo modifica metadatos**:
`COMMENT`, `SQL SECURITY`, `LANGUAGE SQL`. No puede cambiar el cuerpo del SP.

La equivalencia correcta en MariaDB es `CREATE OR REPLACE PROCEDURE`, que:
- Reemplaza el cuerpo completo de forma atómica
- No requiere DROP previo
- Está disponible desde MariaDB 10.1.3

| Concepto T-SQL | Equivalente MariaDB |
|---|---|
| `ALTER PROCEDURE sp_name AS <nuevo cuerpo>` | `CREATE OR REPLACE PROCEDURE sp_name() BEGIN <nuevo cuerpo> END` |
| `ALTER PROCEDURE sp_name WITH EXECUTE AS` | `ALTER PROCEDURE sp_name SQL SECURITY DEFINER` |

---

## H-M15-003 — El primer commit solo cubrió los SPs — las funciones y el evento tenían el mismo riesgo con mayor gravedad

**Detectado en:** T-15.4, al revisar el inventario completo post-commit  
**Severidad:** ALTA — igual que H-M15-001, con un agravante adicional  
**Estado:** RESUELTO en T-15.5

### Descripción

El commit `3a3b089` migró los 12 SPs a `CREATE OR REPLACE`. Al revisar el inventario
completo del repositorio se detectó que las 7 funciones y el evento seguían con
`DROP + CREATE`.

**El riesgo en las funciones es de mayor gravedad que en los SPs** por el grafo
de dependencias:

```
fn_did_segmento    ← usada por: sp_etl_base_detalle, sp_etl_base_clientes
fn_normalizar_*    ← usadas por: sp_etl_base_detalle
ivr_contar_dias_semana ← usada por: sp_rpt_centros_xsegmento, v_sla_distribucion
ivr_agregar_dias_semana ← usada por: sp_rpt_centros_xsegmento
ivr_es_dia_semana  ← usada por: sp_etl_base_detalle
```

Si Django llama `sp_rpt_centros_xsegmento` mientras `ivr_contar_dias_semana`
está siendo reemplazada con `DROP + CREATE`, el SP falla con:

```
ERROR 1305: FUNCTION ivr_legacy.ivr_contar_dias_semana does not exist
```

El error no es del SP — es de una función ausente momentáneamente. En producción,
con Django sirviendo peticiones de reporte continuamente, la probabilidad de colisión
durante un redespliegue no es despreciable.

El **evento `evt_etl_diario`** también tenía `DROP EVENT IF EXISTS` seguido de
`CREATE EVENT`. Aunque el evento no se llama a sí mismo, si el script de despliegue
corre mientras el scheduler MySQL está justo en el proceso de preparar la siguiente
ejecución del evento, el comportamiento es indefinido.

### Corrección

```sql
-- funciones:
CREATE OR REPLACE FUNCTION ivr_contar_dias_semana(p_ini DATE, p_fin DATE)
RETURNS INT DETERMINISTIC ...

-- evento:
CREATE OR REPLACE EVENT evt_etl_diario
    ON SCHEDULE EVERY 1 DAY
    STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
    DO CALL sp_etl_maestro();
```

Verificado en motor real:
- `CREATE OR REPLACE FUNCTION` — devuelve el resultado correcto inmediatamente ✓
- `CREATE OR REPLACE EVENT` — el evento queda activo sin DROP previo ✓

---

## Lo que el módulo valida como correcto en IACT-db (sin necesidad de cambio)

### SPs como API aislada para Django

El módulo establece que los SPs deben "aislar las aplicaciones de los cambios en
la estructura de la base de datos". IACT-db implementa exactamente esto:
Django llama exclusivamente a los 12 SPs vía `cursor.callproc()`. Los cambios
internos de las 4 fases (CTEs, transacciones, fórmulas O(1)) no requirieron
modificar ningún código Django.

### Parámetros OUT en `sp_etl_validar`

Los parámetros `OUT p_ok BOOLEAN` y `OUT p_mensaje TEXT` corresponden al patrón
OUTPUT del módulo. `sp_etl_maestro` los usa para tomar decisiones de flujo
(continuar, marcar PARTIAL, abortar) sin depender de consultas adicionales.

### SQL dinámico con parámetros — equivalente a `sp_executesql`

El módulo recomienda `sp_executesql` sobre `EXEC(@string)` por seguridad y
reutilización del plan. IACT-db ya implementa el equivalente MariaDB correcto:

```sql
-- sp_etl_base_detalle y sp_etl_base_clientes:
SET @sql = CONCAT('INSERT INTO base_ivr_detalle ... FROM ', p_table, ' WHERE dFecha BETWEEN ? AND ?');
PREPARE stmt FROM @sql;
EXECUTE stmt USING @p_quarter, @v_mes_ini, @v_mes_fin;  -- valores como parámetros
```

`p_table` (nombre de tabla) forma parte del SQL dinámico — no puede pasarse como
`USING`. Los **valores** de filtro sí se pasan como `USING @params`, previniendo
inyección SQL. Correcto según el módulo.

### `information_schema.PARAMETERS` — equivalente de `sys.parameters`

Disponible en MariaDB. Permite descubrir los parámetros de cualquier SP:

```sql
SELECT SPECIFIC_NAME, PARAMETER_MODE, PARAMETER_NAME, DATA_TYPE
FROM information_schema.PARAMETERS
WHERE SPECIFIC_SCHEMA = 'ivr_legacy'
ORDER BY SPECIFIC_NAME, ORDINAL_POSITION;
```

---

## Verificación final

```
Objetos con DROP + CREATE antes del análisis:  20 / 20
Objetos con CREATE OR REPLACE después:         20 / 20
Objetos con DROP + CREATE restantes:            0 / 20

Funciones: 7 migradas (CREATE OR REPLACE FUNCTION verificado)
SPs:      12 migrados (CREATE OR REPLACE PROCEDURE verificado)
Evento:    1 migrado  (CREATE OR REPLACE EVENT verificado)

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```
