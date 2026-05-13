# Análisis — Módulo 16: Programación T-SQL aplicada a IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Motor:** MariaDB 10.11.14  
**Veredicto general:** el módulo valida el diseño existente de IACT-db.
No genera cambios de código — sí genera correcciones de nomenclatura y
documenta equivalencias que todo el equipo debe conocer.

---

## Tabla de equivalencias T-SQL → MariaDB 10.11

| Concepto T-SQL | Disponible en MariaDB | Sintaxis MariaDB | Estado en IACT-db |
|---|---|---|---|
| Lotes con `GO` | No — diferente modelo | `DELIMITER $$` | Ya implementado correctamente |
| `DECLARE @var INT = 0` | Sí | `DECLARE v_var INT DEFAULT 0` | Ya implementado en todos los SPs |
| `SET @var = valor` | Sí | `SET v_var = valor` | Ya implementado |
| `SELECT @var = col FROM t` | Sí | `SELECT col INTO v_var FROM t` | Ya implementado — auditado (ver abajo) |
| `CREATE SYNONYM` | **No** — T-SQL/Oracle exclusivo | `CREATE VIEW` (parcial) | No aplica directamente |
| `IF ... ELSE` | Sí — idéntico | `IF ... ELSE ... END IF` | Ya implementado en 11 objetos |
| `WHILE ... BEGIN ... END` | Sí — idéntico | `WHILE ... DO ... END WHILE` | Ya implementado donde corresponde |
| `BREAK` (salir del WHILE) | Sí — diferente sintaxis | `LEAVE nombre_label` | Disponible — no necesario actualmente |
| `CONTINUE` (saltar iteración) | Sí — diferente sintaxis | `ITERATE nombre_label` | Disponible — no necesario actualmente |
| `RETURN` (salir del SP) | Sí | `RETURN` (SP) / `RETURN valor` (función) | Ya implementado en funciones |

---

## Lección 1: Lotes (`GO`) — equivalencia con `DELIMITER`

T-SQL usa `GO` para separar lotes de sentencias. `GO` impone que ciertos objetos
(`CREATE FUNCTION`, `CREATE PROCEDURE`, `CREATE VIEW`) estén en lotes separados.

MariaDB no tiene `GO`. El mecanismo equivalente es `DELIMITER`:

```sql
-- T-SQL:
CREATE PROCEDURE sp_nombre AS BEGIN ... END;
GO
CREATE FUNCTION fn_nombre() RETURNS INT AS BEGIN ... END;
GO

-- MariaDB (patrón en IACT-db):
DELIMITER $$
CREATE OR REPLACE PROCEDURE sp_nombre()
BEGIN ... END$$

CREATE OR REPLACE FUNCTION fn_nombre() RETURNS INT
BEGIN ... END$$
DELIMITER ;
```

Los 20 archivos SQL de IACT-db ya usan correctamente el patrón `DELIMITER $$`.
El análisis del Módulo 15 (CREATE OR REPLACE) completó la migración — ya no existe
ningún `DROP + CREATE` en los archivos.

---

## Lección 1: Variables — auditoría de `SELECT INTO` (advertencia del módulo)

El módulo advierte: *"Asegúrese de que la instrucción SELECT devuelve exactamente
una fila"* al asignar a una variable.

IACT-db tiene 6 `SELECT INTO` en 3 SPs. Auditoría completa:

| SP | Query SELECT INTO | Garantía de 1 fila |
|---|---|---|
| `sp_etl_maestro` | `SELECT is_enabled, timeout_seconds INTO ... FROM job_config WHERE job_name='etl_diario'` | `job_name` es PRIMARY KEY — máximo 1 fila |
| `sp_etl_validar` | `SELECT COUNT(*), SUM(total_llamadas) INTO ... FROM base_ivr_detalle WHERE ...` | `COUNT(*)` y `SUM()` siempre devuelven exactamente 1 fila |
| `sp_etl_validar` | `SELECT COUNT(*) INTO v_count_cli FROM base_ivr_clientes WHERE ...` | Ídem |
| `sp_etl_validar` | `SELECT COUNT(*) INTO v_seg_huerfanos FROM (EXCEPT subquery)` | `COUNT(*)` sobre subquery — siempre 1 fila |
| `sp_etl_validar` | `SELECT COUNT(*) INTO v_seg_comunes FROM (INTERSECT subquery)` | Ídem |
| `sp_rpt_llamadas_abandonadas` | `SELECT SUM(total_llamadas) INTO v_total_quarter FROM base_ivr_detalle WHERE ...` | `SUM()` siempre devuelve 1 fila (NULL si vacío, manejado por NULLIF) |

**Resultado:** todos los `SELECT INTO` usan funciones de agregación (`COUNT`, `SUM`)
o acceso por clave primaria. Ninguno puede devolver más de 1 fila.
La advertencia del módulo está satisfecha.

---

## Lección 1: Sinónimos — no disponibles en MariaDB

T-SQL permite `CREATE SYNONYM alias FOR schema.objeto` para crear alias de objetos
locales o remotos. MariaDB no soporta `CREATE SYNONYM` (ERROR 1064).

La aproximación más cercana en MariaDB es `CREATE VIEW`, que cubre el caso de
tablas y consultas:

```sql
-- T-SQL:
CREATE SYNONYM dbo.DetalleCentros FOR ivr_legacy.base_ivr_detalle;

-- MariaDB — equivalente parcial:
CREATE OR REPLACE VIEW v_detalle AS SELECT * FROM base_ivr_detalle;
```

Para SPs y funciones no hay equivalente en MariaDB — el SP debe llamarse por
su nombre original. No hay un gap funcional en IACT-db: todos los objetos tienen
nombres descriptivos y Django los llama por nombre directo.

---

## Lección 2: Control de flujo — equivalencias verificadas

### `IF ... ELSE`

Idéntico en MariaDB salvo que el bloque requiere `END IF`:

```sql
-- T-SQL:
IF @var > 0
    SELECT 'positivo';
ELSE
    SELECT 'no positivo';

-- MariaDB (IACT-db):
IF v_var > 0 THEN
    SELECT 'positivo';
ELSE
    SELECT 'no positivo';
END IF;
```

IACT-db usa `IF/ELSE` en 11 de los 20 objetos SQL. El módulo valida su uso correcto.

### `WHILE` — el único que permanece activo

El módulo enseña WHILE para iteración secuencial. IACT-db tiene exactamente un WHILE
activo en código de producción:

```sql
-- sp_etl_base_detalle: iterar por mes dentro del quarter
WHILE v_mes_ini <= p_fin DO
    ...
    SET v_mes_ini = DATE_ADD(LAST_DAY(v_mes_ini), INTERVAL 1 DAY);
END WHILE;
```

Este WHILE es necesario: el INSERT de cada mes debe confirmar (COMMIT) antes del
siguiente, lo que requiere procesamiento secuencial. No es candidato a refactoring
set-based.

Los WHILE de `ivr_contar_dias_semana` e `ivr_agregar_dias_semana` fueron eliminados
en FASE 4 y reemplazados por fórmulas O(1). El módulo valida esa decisión.

### `BREAK` → `LEAVE label` y `CONTINUE` → `ITERATE label`

MariaDB soporta ambos con sintaxis diferente. El label debe estar en el `WHILE`,
no en el `BEGIN`:

```sql
-- T-SQL:
WHILE @i <= 10
BEGIN
    IF @i = 4 BREAK;     -- sale del loop
    IF @i MOD 2 = 0 CONTINUE;  -- salta al inicio
    SET @i += 1;
END;

-- MariaDB (sintaxis correcta):
mi_loop: WHILE v_i <= 10 DO
    IF v_i = 4 THEN
        LEAVE mi_loop;    -- equivalente a BREAK
    END IF;
    IF v_i MOD 2 = 0 THEN
        ITERATE mi_loop;  -- equivalente a CONTINUE — label en el WHILE, no en BEGIN
    END IF;
    SET v_i = v_i + 1;
END WHILE mi_loop;
```

**Verificado en motor real:** `LEAVE` retorna 4 (correcto), `ITERATE` acumula
solo impares y da 25 (1+3+5+7+9 = correcto).

**¿Los SPs actuales necesitan LEAVE o ITERATE?** No. El único WHILE activo
(`sp_etl_base_detalle`) usa `EXIT HANDLER` con `ROLLBACK + RESIGNAL` para salir
ante errores — mecanismo más robusto que un LEAVE manual porque cierra la TX
antes de propagar el error.

### `RETURN` — ya implementado en funciones

Las funciones escalares de IACT-db usan `RETURN valor` como corresponde.
Los SPs de ETL no usan `RETURN` para salida anticipada — usan `EXIT HANDLER`
con `RESIGNAL`, que es el mecanismo correcto para errores.

---

## Hallazgo de nomenclatura: label en `WHILE` vs label en `BEGIN`

Durante la verificación de `ITERATE` se detectó que el label debe colocarse en
el `WHILE`, no en el `BEGIN` del SP:

```sql
-- INCORRECTO — el label en BEGIN no permite ITERATE dentro del WHILE:
mi_bloque: BEGIN
    WHILE v_i < 10 DO
        ITERATE mi_bloque;  -- ERROR 1308: ITERATE with no matching label
    END WHILE;
END;

-- CORRECTO — el label en el WHILE:
BEGIN
    mi_loop: WHILE v_i < 10 DO
        ITERATE mi_loop;    -- correcto
    END WHILE mi_loop;
END;
```

`sp_etl_maestro` usa `LEAVE` con el label en el bloque `BEGIN` externo del SP
(etiqueta de procedimiento) — este es el uso correcto para salir del SP completo,
no de un WHILE. Los comentarios en el código documentan la restricción de MariaDB
10.11 sobre LEAVE desde dentro de EXIT HANDLERs anidados.

---

## Resumen — el módulo valida sin exigir cambios

| Elemento del módulo | Estado en IACT-db |
|---|---|
| Lotes (`GO`) | Resuelto con DELIMITER — ya correcto |
| Variables (`DECLARE`, `SET`, `SELECT INTO`) | Todos seguros — auditados |
| Sinónimos | No aplica en MariaDB — sin gap funcional |
| `IF/ELSE` | 11 objetos lo usan correctamente |
| `WHILE` | 1 WHILE activo — necesario y correcto |
| `BREAK` / `LEAVE` | Disponible — no necesario actualmente |
| `CONTINUE` / `ITERATE` | Disponible — sintaxis verificada (label en WHILE) |
| `RETURN` | Implementado correctamente en funciones |

**No hay código que cambiar.** El módulo confirma que IACT-db implementa
correctamente todos los patrones de programación T-SQL que tienen equivalente
en MariaDB. El único aprendizaje nuevo es la sintaxis exacta de `ITERATE`
(label en el `WHILE`, no en el `BEGIN`), documentada para referencia futura.
