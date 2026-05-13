# Análisis y Hallazgos — Módulo 17: Manejo de Errores

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Módulo de referencia:** Módulo 17 — Implementar manejo de errores  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Tabla de equivalencias T-SQL → MariaDB 10.11

| Concepto del módulo | T-SQL (SQL Server) | MariaDB 10.11 | Estado en IACT-db |
|---|---|---|---|
| Lanzar error de aplicación | `RAISERROR(msg, severity, state)` | `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg` | Parcialmente implementado |
| Lanzar error (sucesor moderno) | `THROW 50001, 'mensaje', 0` | `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'mensaje'` | Idem |
| Re-lanzar error en CATCH | `THROW` (sin parámetros) | `RESIGNAL` | Implementado en sp_etl_base_detalle |
| Capturar error estructurado | `BEGIN TRY...END TRY BEGIN CATCH...END CATCH` | `DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ... END` | Implementado en sp_etl_maestro y sp_etl_base_detalle |
| Número del último error | `@@ERROR` | No existe — usar `GET DIAGNOSTICS CONDITION 1 ... MYSQL_ERRNO` | Implementado en sp_etl_maestro |
| Texto del último error | `ERROR_MESSAGE()` | `GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT` | Implementado en sp_etl_maestro |
| Catálogo de mensajes | `sys.messages` + `sp_add_message` | No disponible en MariaDB | No aplica |
| Alertas con registro | `RAISERROR ... WITH LOG` | No disponible en MariaDB | No aplica |
| SQLSTATE estándar para param inválido | `RAISERROR` con severity 16 | `SIGNAL SQLSTATE '22023'` | Implementado en este análisis |

---

## Estado antes del análisis — inventario de manejo de errores

| Objeto | EXIT HANDLER | SIGNAL | RESIGNAL | GET DIAGNOSTICS |
|---|---|---|---|---|
| `sp_etl_base_detalle` | Sí | Sí | Sí | No |
| `sp_etl_base_clientes` | No | Sí | No | No |
| `sp_etl_maestro` | Sí (PASO 4 y 5) | No | No | Sí |
| `sp_etl_validar` | **No** | No | No | No |
| `sp_etl_historico` | No | Sí | No | No |
| 7 SPs de reporte | **Ninguno** | **Ninguno** | No | No |
| 7 funciones | No | No | No | No |

---

## Objetos modificados

| Archivo | Objeto | Versión anterior | Versión nueva | Cambio |
|---|---|---|---|---|
| `sp_rpt_cMENU_ERROR.sql` | `sp_rpt_cMENU_ERROR` | 2.0.0 | 2.0.1 | SIGNAL — validación p_quarter + p_segmento |
| `sp_rpt_centros_transferencia.sql` | `sp_rpt_centros_transferencia` | 2.1.0 | 2.1.1 | SIGNAL — validación p_quarter + p_segmento |
| `sp_rpt_centros_xsegmento.sql` | `sp_rpt_centros_xsegmento` | 2.2.0 | 2.2.1 | SIGNAL — validación p_quarter |
| `sp_rpt_clientes.sql` | `sp_rpt_clientes` | 2.0.0 | 2.0.1 | SIGNAL — validación p_quarter |
| `sp_rpt_llamadas_abandonadas.sql` | `sp_rpt_llamadas_abandonadas` | 2.2.0 | 2.2.1 | SIGNAL — validación p_quarter + p_segmento |
| `sp_rpt_menu_centro.sql` | `sp_rpt_menu_centro` | 2.0.0 | 2.0.1 | SIGNAL — validación p_quarter + p_segmento |
| `sp_rpt_menu_redirigidos.sql` | `sp_rpt_menu_redirigidos` | 2.0.0 | 2.0.1 | SIGNAL — validación p_quarter + p_segmento |
| `sp_etl_validar.sql` | `sp_etl_validar` | 2.1.0 | 2.2.0 | EXIT HANDLER — captura errores inesperados |
| `sp_etl_maestro.sql` | `sp_etl_maestro` | 2.3.0 | 2.4.0 | EXIT HANDLER para PASO 6 |

---

## H-M17-001 — 7 SPs de reporte devolvían resultado vacío ante parámetros inválidos

**Detectado en:** inventario inicial  
**Severidad:** MEDIA — dificulta el diagnóstico desde Django  
**Estado:** RESUELTO

### Descripción

Los 7 SPs de reporte reciben `p_quarter VARCHAR(10)` y (5 de ellos) `p_segmento VARCHAR(20)`.
Antes de este análisis, ninguno validaba los valores recibidos:

```sql
CALL sp_rpt_clientes('');        -- retornaba 0 filas, sin diagnóstico
CALL sp_rpt_clientes('INVALIDO'); -- idem
CALL sp_rpt_llamadas_abandonadas('Q01_25', 'seg_malo'); -- idem
```

Django valida los parámetros antes de llamar al SP (`QUARTERS_VALIDOS`, `SEGMENTOS_VALIDOS`),
pero esa validación es en Python — el SP queda desprotegido ante llamadas directas a la
BD o futuros cambios en el cliente.

### Corrección

```sql
-- Al inicio del SP (después de los DECLARE):
IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    SIGNAL SQLSTATE '22023'
        SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY';
END IF;

IF p_segmento NOT IN ('todas', 'nacional_A', 'nacional_B', 'puebla') THEN
    SIGNAL SQLSTATE '22023'
        SET MESSAGE_TEXT = 'p_segmento: valor no reconocido. Esperado: todas | nacional_A | nacional_B | puebla';
END IF;
```

`SQLSTATE '22023'` es "Invalid parameter value" en el estándar SQL — más semántico que
`'45000'` (error genérico de aplicación). Django recibe `ERROR 1644 (22023)` con el
texto descriptivo del error en lugar de un cursor vacío.

**Verificado:**
```
CALL sp_rpt_clientes('INVALIDO')
→ ERROR 1644 (22023): p_quarter: formato invalido. Esperado: Q01_25, Q02_25, Q03_25 o Q04_YY

CALL sp_rpt_llamadas_abandonadas('Q01_25','seg_malo')
→ ERROR 1644 (22023): p_segmento: valor no reconocido. Esperado: todas | nacional_A | nacional_B | puebla
```

---

## H-M17-002 — `sp_etl_validar` sin EXIT HANDLER dejaba el job en estado RUNNING

**Detectado en:** análisis de PASO 6 en sp_etl_maestro  
**Severidad:** ALTA — el job_execution_log podría quedar RUNNING indefinidamente  
**Estado:** RESUELTO (en sp_etl_validar y en sp_etl_maestro PASO 6)

### Descripción

`sp_etl_maestro` PASO 6 llamaba `CALL sp_etl_validar(v_quarter, v_ok, v_msg)` sin
ningún `BEGIN...END` envolvente con EXIT HANDLER:

```
PASO 4 → BEGIN HANDLER END (actualiza log FAILED)
PASO 5 → BEGIN HANDLER END (actualiza log FAILED)
PASO 6 → CALL sp_etl_validar  ← sin handler
PASO 7 → UPDATE status final
```

Si `sp_etl_validar` fallaba inesperadamente (error de infraestructura, tabla bloqueada),
la excepción propagaba hasta el caller de `sp_etl_maestro` (`evt_etl_diario`), que no
tiene manejo de errores. El job en `job_execution_log` quedaba con `status='RUNNING'`.
La siguiente ejecución del evento (02:00 del día siguiente) era bloqueada por el check
de concurrencia del PASO 1 (detecta RUNNING en las últimas 6 horas).

El comentario en el PASO 5 ya advertía el riesgo: *"Si sp_etl_validar o cualquier
sentencia posterior también falla y la excepción propaga fuera de sp_etl_maestro,
el PASO 7 no se ejecutará y v_maestro_id quedaría RUNNING indefinidamente."*

### Corrección en `sp_etl_validar` v2.2.0

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
    SET p_ok      = FALSE;
    SET p_mensaje = CONCAT('ERROR en sp_etl_validar: ', v_err_msg);
    SELECT p_quarter AS quarter, FALSE AS validacion_ok, p_mensaje AS mensaje;
END;
```

`sp_etl_validar` ahora retorna `p_ok=FALSE` con el error en `p_mensaje` en lugar
de propagar la excepción. `sp_etl_maestro` evalúa el resultado normalmente.

### Corrección en `sp_etl_maestro` v2.4.0

```sql
-- PASO 6 envuelto en BEGIN...END con handler:
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
        UPDATE job_execution_log
        SET status='PARTIAL', end_time=NOW(),
            error_message=CONCAT('Error en sp_etl_validar: ', v_err_msg)
        WHERE id = v_maestro_id;
    END;
    CALL sp_etl_validar(v_quarter, v_ok, v_msg);
END;
```

sp_etl_maestro ahora tiene 3 EXIT HANDLERs: PASO 4, PASO 5 y PASO 6.
Ningún PASO puede dejar el maestro en estado `RUNNING` indefinidamente.

---

## Lo que el módulo valida como correcto (sin cambio necesario)

### `DECLARE EXIT HANDLER FOR SQLEXCEPTION` en SPs ETL

El módulo enseña `BEGIN TRY...END TRY BEGIN CATCH...END CATCH`. El equivalente
MariaDB ya está implementado correctamente en `sp_etl_base_detalle` y `sp_etl_maestro`.

### `RESIGNAL` en `sp_etl_base_detalle`

El módulo enseña `THROW` sin parámetros para re-lanzar el error original desde CATCH.
`sp_etl_base_detalle` usa `RESIGNAL` exactamente para ese propósito — el handler
hace el ROLLBACK y re-lanza para que sp_etl_maestro vea el error.

### `GET DIAGNOSTICS CONDITION 1` en `sp_etl_maestro`

El módulo menciona `ERROR_MESSAGE()` para obtener el texto del error en el bloque CATCH.
`sp_etl_maestro` ya usa `GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT` —
el equivalente correcto en MariaDB.

---

## Lo que no aplica en MariaDB

`sys.messages` y `sp_add_message`: no existen. MariaDB no tiene un catálogo de mensajes
de error configurable. Los `SQLSTATE` estándar (`'22023'`, `'45000'`) son el mecanismo.

`@@ERROR`: no existe en MariaDB (ERROR 1193: Unknown system variable). Usar
`GET DIAGNOSTICS CONDITION 1 v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT`.

`RAISERROR ... WITH LOG`: no existe. MariaDB no tiene integración con registro de eventos
del sistema operativo equivalente al Windows Event Log de SQL Server.

---

## Verificación final

```
7 SPs de reporte: SIGNAL SQLSTATE '22023' en p_quarter y p_segmento
  CALL sp_rpt_clientes('INVALIDO')  → ERROR 1644 (22023) con mensaje descriptivo ✓
  CALL sp_rpt_clientes('Q01_25')    → resultado correcto sin cambio ✓

sp_etl_validar v2.2.0:
  EXIT HANDLER retorna p_ok=FALSE + p_mensaje con el error ✓
  Ejecución normal: OK — 2704 filas detalle, 3 segmentos comunes ✓

sp_etl_maestro v2.4.0:
  3 EXIT HANDLERs: PASO 4, PASO 5, PASO 6 ✓
  Ningún PASO puede dejar status=RUNNING indefinido ✓

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```
