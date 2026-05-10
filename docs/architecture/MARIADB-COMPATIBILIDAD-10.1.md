# Compatibilidad MariaDB 10.1.48 — Restricciones para SPs

**Fecha:** 2026-05-06
**Fuentes:** `HALLAZGOS-ENTORNO.md`, `BITACORA-IMPLEMENTACION.md`,
`IACT-docs/.thyrox/context/work/pipeline-uc-deepening-changelog.md`

---

## Contexto

El sistema IVR del cliente corre sobre **MariaDB 10.1.48** en producción.
Esta versión es legacy — fue publicada en 2018 y no recibe actualizaciones de
seguridad desde 2023. La actualización de versión está fuera del scope del
proyecto IACT (decisión del cliente).

El entorno de desarrollo del sandbox usa MariaDB 10.11.14, que sí incluye
window functions y CTEs. Esta discrepancia fue documentada como hallazgo
H-001-02 y resuelta con la decisión D-001-02.

---

## Versiones y sus capacidades

| Característica | 10.1.48 (produccion) | 10.2.x | 10.11.14 (sandbox dev) |
|---|---|---|---|
| Window functions (`OVER`, `PARTITION BY`) | No | Si | Si |
| `ROW_NUMBER() OVER()` | No | Si | Si |
| CTEs (`WITH ... AS`) | No | No | Si (desde 10.2.1) |
| `RETURNING` clause | No | No | Si |
| JSON functions completas | No | No | Si |
| Subconsultas correlacionadas | Si | Si | Si |
| Variables de sesion `@var` | Si | Si | Si |
| `PREPARE / EXECUTE` | Si | Si | Si |
| `IF()`, `CASE WHEN` | Si | Si | Si |
| `TIMESTAMPDIFF()` | Si | Si | Si |
| Stored Procedures | Si | Si | Si |
| `DELIMITER` via `-e` | No | No | No |

---

## Constraints registrados (CNST-ETL-*)

### CNST-ETL-007 — Sin window functions en MariaDB 10.1

**Descripcion:** MariaDB 10.1.48 no tiene window functions. Las funciones
`OVER()`, `PARTITION BY`, `ROW_NUMBER()`, `RANK()`, `LAG()`, `LEAD()`,
`SUM() OVER()` son sintaxis invalida en esta version.

**Origen:** Window functions se introdujeron en MariaDB 10.2.0 (agosto 2016).

**Regla:** Todos los SPs del proyecto deben evitar window functions.
Usar subconsultas correlacionadas como alternativa.

**Patron alternativo — ranking sin `ROW_NUMBER() OVER()`:**
```sql
-- PROHIBIDO en 10.1:
SELECT ROW_NUMBER() OVER (PARTITION BY segmento ORDER BY total DESC) AS rn,
       segmento, menu, total
FROM base_ivr_detalle;

-- CORRECTO en 10.1 (variable de sesion):
SET @rank := 0, @cur := '';
SELECT
    @rank := IF(@cur = segmento, @rank + 1, 1) AS rn,
    @cur  := segmento                           AS segmento,
    menu,
    total
FROM base_ivr_detalle
ORDER BY segmento, total DESC;
```

**Patron alternativo — totales sin `SUM() OVER()`:**
```sql
-- PROHIBIDO en 10.1:
SELECT menu, total,
       SUM(total) OVER (PARTITION BY segmento) AS total_segmento
FROM base_ivr_detalle;

-- CORRECTO en 10.1 (subconsulta correlacionada):
SELECT b.menu, b.total,
       (SELECT SUM(b2.total)
        FROM base_ivr_detalle b2
        WHERE b2.segmento = b.segmento
          AND b2.trimestre = b.trimestre) AS total_segmento
FROM base_ivr_detalle b;
```

---

### CNST-ETL-008 — Sin tablas dinamicas directas en MariaDB 10.1

**Descripcion:** MariaDB 10.1 no permite usar una variable o parametro como
identificador de tabla directamente en `FROM` o `INTO`.

**Regla:** Los SPs que reciben el nombre de tabla como parametro deben
construir el SQL como string y ejecutarlo con `PREPARE / EXECUTE`.

**Patron correcto:**
```sql
CREATE PROCEDURE sp_etl_base_detalle(
    IN p_table   VARCHAR(40),  -- 'tbl_historico_t1_2025'
    IN p_quarter VARCHAR(10)   -- 'Q01_25'
)
BEGIN
    -- PROHIBIDO en 10.1:
    -- INSERT INTO base_ivr_detalle SELECT ... FROM p_table;

    -- CORRECTO en 10.1 (PREPARE/EXECUTE):
    SET @sql = CONCAT(
        'INSERT INTO base_ivr_detalle (trimestre, segmento, menu, total) ',
        'SELECT ?, fn_did_segmento(cDID_800Transfer), ',
        '       UPPER(TRIM(cMenu)), COUNT(*) ',
        'FROM ', p_table, ' ',   -- nombre de tabla se incrusta via CONCAT
        'GROUP BY cDID_800Transfer, UPPER(TRIM(cMenu))'
    );
    SET @q = p_quarter;
    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @q;
    DEALLOCATE PREPARE stmt;
END;
```

**Nota de seguridad:** Los valores de `p_table`, `p_quarter`, `p_inicio`,
`p_fin` en los SPs ETL son generados internamente por `sp_etl_maestro`
— no son input directo del usuario. No hay riesgo de inyeccion SQL en
este patron especifico.

---

### CNST-ETL-005 — Sin indices en tablas fuente

**Descripcion:** Las tablas `tbl_historico_tN_YYYY` no tienen indices
y IACT no tiene permisos para crearlos (son tablas del cliente).

**Impacto:** Cada acceso a esas tablas en los SPs ETL es un full table
scan de 11-14 millones de filas por quarter.

**Regla:** Los SPs ETL no pueden asumir la existencia de indices en las
tablas fuente. El diseno de filtros debe minimizar los full scans
(procesar por mes, no por fila).

---

### CNST-ETL-006 — Las tablas rpt_* si deben tener indices

**Descripcion:** Las tablas de reporte que IACT controla (`base_ivr_detalle`,
`base_ivr_clientes`, tablas de control) deben tener indices adecuados
para que los SPs de reporte respondan en tiempo razonable.

**Regla:** Todo `CREATE TABLE` de tablas propias de IACT debe incluir
indices en las columnas de filtro frecuente: `trimestre`, `segmento`,
`(trimestre, segmento)`.

---

## Reglas de desarrollo para SPs — resumen ejecutivo

### Prohibido (no compila o produce error en 10.1.48)

```sql
-- Window functions
ROW_NUMBER() OVER (...)
RANK() OVER (...)
SUM(x) OVER (PARTITION BY ...)
LAG(x) OVER (...)

-- CTEs
WITH cte AS (SELECT ...) SELECT * FROM cte;

-- RETURNING
INSERT INTO t (col) VALUES (val) RETURNING id;

-- Tabla dinamica directa
SELECT * FROM p_table_name;   -- p_table_name es un parametro o variable

-- DELIMITER con -e desde bash
mysql -e "DELIMITER ;; CREATE PROCEDURE..."  -- no funciona
```

### Permitido (compatible con 10.1.48)

```sql
-- Subconsultas correlacionadas
SELECT x, (SELECT SUM(y) FROM t2 WHERE t2.k = t1.k) FROM t1;

-- Variables de sesion para ranking
SET @n := 0;
SELECT @n := @n + 1 AS rn, col FROM t ORDER BY col;

-- PREPARE/EXECUTE para tablas dinamicas
SET @sql = CONCAT('SELECT * FROM ', p_table);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- IF / CASE WHEN
SELECT IF(x IS NULL, 0, x), CASE WHEN x > 0 THEN 'A' ELSE 'B' END FROM t;

-- TIMESTAMPDIFF, DATE_FORMAT, DATE_ADD, DATEDIFF
SELECT TIMESTAMPDIFF(MINUTE, dHoraInicio, dHoraFin) FROM tbl;

-- Variables locales en SP
DECLARE v_total INT DEFAULT 0;
SET v_total = (SELECT COUNT(*) FROM t);

-- Transacciones
START TRANSACTION; INSERT ...; COMMIT;

-- Handlers de error
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; END;
```

---

## Workaround para despliegue de SPs desde bash

MariaDB 10.1 (y todas las versiones) no procesa la directiva `DELIMITER`
cuando se usa con la opcion `-e` de la linea de comandos. Los SPs
deben desplegarse leyendo el archivo completo:

```bash
# INCORRECTO — DELIMITER no funciona con -e
mysql -e "DELIMITER // CREATE PROCEDURE sp() BEGIN ... END //"

# CORRECTO — leer el archivo completo
mysql --socket=/run/mysqld/mysqld.sock \
      -u django_user -pdjango_pass ivr_legacy \
      < provisioners/mariadb/mi_sp.sql
```

El archivo `.sql` usa `DELIMITER $$` al inicio y `DELIMITER ;` al final,
y los SPs usan `$$` como terminador interno.

---

## Decision D-001-02 — mantener subconsultas aunque el sandbox tenga 10.11

El sandbox de desarrollo usa MariaDB 10.11.14 que si soporta window
functions. Sin embargo, la decision D-001-02 establece que los SPs
se escriben con subconsultas compatibles con 10.1.x.

**Razon:** Si en el futuro los SPs se despliegan directamente en el
servidor del cliente (10.1.48), no requieren modificacion. Un SP escrito
con `OVER()` fallaria silenciosamente al migrar.

**Consecuencia practica:** El sandbox puede ejecutar los SPs correctamente
aunque esten escritos con subconsultas — no hay perdida de funcionalidad
en el entorno de desarrollo.

---

## Ver tambien

- `HALLAZGOS-ENTORNO.md` — hallazgo H-001-02 (version real vs planificada)
- `BITACORA-IMPLEMENTACION.md` — decision D-001-02, D-002-02
- `FLUJO-ETL-V2.md` — diseno de pipeline con estas restricciones
- `ETL-ANALISIS.md` — tabla de constraints CNST-ETL-*
- `provisioners/mariadb/sp_etl_pipeline.sql` — implementacion de referencia

