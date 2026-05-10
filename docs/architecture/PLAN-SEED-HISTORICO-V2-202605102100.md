# Plan de implementación — Corrección del seed histórico e integración Python

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Referencia:** `HALLAZGOS-SEED-SQL-202605102030.md`,
`HALLAZGOS-SEED-VOLUMEN-MENUS-202605102045.md`  
**Hallazgos que cierra:** H-SEED-001..008, H-SEED-010..011 (SQL),
H-SEED-012..015 (Python)

---

## Arquitectura del seed — dos niveles

```
git clone IACT-db
    ↓
setup.sh mariadb --full
    ↓
schema_historico.sh PASO 3
    ↓
seed_historico.sql [NIVEL 1]
    ├── Disponible sin Python
    ├── Datos funcionales para desarrollo básico
    ├── Proporciones calibradas (G-29, menus reales simplificados, telefonos)
    ├── Incremental (APPEND en 2da ejecucion)
    └── Sin TRUNCATE
    ↓
[Opcional — requiere Python 3]
schema_historico.sh PASO 4 (con FULL_SEED=1)
    ↓
poblar_historico.py [NIVEL 2]
    ├── 39–51 menus reales por quarter
    ├── 28+ VDNs reales por menu
    ├── Escalas de volumen por quarter (Q02 > Q01 > Q03 > etc.)
    ├── Volúmenes no redondos con offset aleatorio
    ├── Evolución temporal del catálogo de menus
    └── Validación estadística integrada (±1.5pp)
```

El NIVEL 1 (SQL) corre siempre. El NIVEL 2 (Python) es opcional y mejora
la calidad cuando el entorno tiene Python 3 disponible.

---

## Criterios de atomicidad

Cada tarea modifica exactamente un bloque de código o una variable. La
verificación es un comando ejecutable que produce OK o FALLO sin ambigüedad.

---

## FASE 0 — Pre-condición: estado limpio para pruebas

### T-0.1 — Confirmar estado actual de tablas y seed_executions

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy -N -e "
    SELECT table_name, COUNT(*) AS filas
    FROM information_schema.tables t
    JOIN (SELECT 'tbl_historico_t1_2025' UNION SELECT 'tbl_historico_t2_2025'
          UNION SELECT 'tbl_historico_t3_2025' UNION SELECT 'tbl_historico_t4_2025'
          UNION SELECT 'tbl_historico_t1_2026' UNION SELECT 'tbl_historico_t2_2026') q
        ON t.table_name = q.column_1
    WHERE t.table_schema='ivr_legacy'
    GROUP BY t.table_name;" 2>/dev/null

mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "SELECT id, tabla, accion, filas_antes, filas_despues
        FROM seed_executions ORDER BY id DESC LIMIT 5;" 2>/dev/null
```

**Verificación:** Las 6 tablas existen. `seed_executions` tiene las
ejecuciones de la sesión anterior.

---

## FASE 1 — Corrección de `seed_historico.sql` (6 problemas en SQL)

**Archivo único:** `provisioners/mariadb/seed_historico.sql`

---

### T-1.1 — Actualizar `seed_executions.accion` para soportar APPEND

**Problema:** El ENUM `('SEED','SKIP','TRUNCATE+SEED')` no incluye `APPEND`.
La tabla se crea con `CREATE TABLE IF NOT EXISTS` — se actualiza la definición
en el SQL para futuras instalaciones limpias. En entornos existentes, un
`ALTER TABLE` garantiza que el esquema quede correcto.

**Acción:** En el bloque `CREATE TABLE IF NOT EXISTS seed_executions`:

```sql
-- Antes:
`accion` ENUM('SEED','SKIP','TRUNCATE+SEED') NOT NULL,

-- Después:
`accion` VARCHAR(20) NOT NULL,
-- VARCHAR en lugar de ENUM para admitir SEED, APPEND y cualquier
-- valor futuro sin necesidad de ALTER TABLE.
```

Agregar después del CREATE TABLE:

```sql
-- Asegurar columna accion con VARCHAR en instalaciones previas que tenían ENUM
ALTER TABLE seed_executions
    MODIFY COLUMN accion VARCHAR(20) NOT NULL;
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -N -e "SELECT COLUMN_TYPE FROM information_schema.COLUMNS
           WHERE TABLE_SCHEMA='ivr_legacy'
           AND TABLE_NAME='seed_executions' AND COLUMN_NAME='accion';"
# Esperado: varchar(20)
```

---

### T-1.2 — Eliminar `p_force` de la firma del SP

**Problema:** `IN p_force TINYINT` habilita TRUNCATE. La firma del SP
debe eliminar este parámetro para que no pueda invocarse.

**Acción:** En `CREATE PROCEDURE sp_seed_historico(...)`:

```sql
-- Eliminar esta línea de la firma:
-- IN  p_force        TINYINT,   -- 1 = TRUNCATE + re-seed, 0 = skip si ya hay datos
```

**Verificación:**
```sql
SHOW CREATE PROCEDURE sp_seed_historico\G
-- Esperado: sin p_force en la lista de parámetros
```

---

### T-1.3 — Eliminar bloque TRUNCATE completo

**Problema:** El bloque `IF p_force = 1 AND v_count_antes > 0` ejecuta
`TRUNCATE TABLE` destruyendo datos con valor histórico.

**Acción:** Eliminar el bloque completo:

```sql
-- Eliminar:
IF p_force = 1 AND v_count_antes > 0 THEN
    SET v_accion = 'TRUNCATE+SEED';
    SET v_sql = CONCAT('TRUNCATE TABLE ', p_tabla);
    PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
    SELECT CONCAT('TRUNCATE: ', p_tabla, ' vaciada (',
                  v_count_antes, ' registros eliminados).') AS info;
    SET v_count_antes = 0;
ELSE
    SET v_accion = 'SEED';
END IF;
```

**Verificación:**
```bash
grep -c "TRUNCATE\|p_force\|FORCE" \
    provisioners/mariadb/seed_historico.sql
# Esperado: 0 (solo en comentarios del header si aplica)
```

---

### T-1.4 — Cambiar lógica SKIP → APPEND incremental

**Problema:** El bloque `IF v_count_antes > 0 AND p_force = 0` sale del SP
sin insertar nada. Debe insertar datos adicionales (APPEND).

**Acción:** Reemplazar el bloque de decisión de acción:

```sql
-- Eliminar:
IF v_count_antes > 0 AND p_force = 0 THEN
    SET v_accion = 'SKIP';
    SELECT CONCAT('SKIP: ', p_tabla, ...) AS info;
    INSERT INTO seed_executions (...) VALUES (..., 'SKIP', ...);
    LEAVE sp_seed_historico;
END IF;

-- Reemplazar con:
-- Determinar accion: SEED en primera insercion, APPEND en siguientes.
-- No hay skip — siempre se insertan registros.
IF v_count_antes = 0 THEN
    SET v_accion = 'SEED';
    SELECT CONCAT('SEED: ', p_tabla, ' (tabla vacía — primera siembra de ',
                  p_rows, ' registros)') AS info;
ELSE
    SET v_accion = 'APPEND';
    SELECT CONCAT('APPEND: ', p_tabla, ' ya tiene ', v_count_antes,
                  ' registros — agregando ', p_rows, ' más') AS info;
END IF;
```

**Verificación:**
```bash
grep -c "SKIP\|LEAVE sp_seed_historico" \
    provisioners/mariadb/seed_historico.sql | grep -v "^[0-9]*:#"
# Esperado: 0 en código ejecutable
```

---

### T-1.5 — Eliminar `@FORCE_RESEED` de variables y CALL statements

**Problema:** `@FORCE_RESEED` ya no tiene significado tras T-1.2..T-1.4.
Su presencia en el SQL puede confundir o ser inyectada por schema_historico.sh.

**Acción — en el bloque de variables de sesión:**

```sql
-- Eliminar:
SET @FORCE_RESEED  = IF(@FORCE_RESEED IS NULL, 0, @FORCE_RESEED);
```

**Acción — en los 6 CALL statements:**

```sql
-- Antes:
CALL sp_seed_historico('tbl_historico_t1_2025','2025-01-01','2025-03-31',
    @SEED_ROWS_Q01_25, @FORCE_RESEED, @SCRIPT_VER, @COMMIT_HASH);

-- Después:
CALL sp_seed_historico('tbl_historico_t1_2025','2025-01-01','2025-03-31',
    @SEED_ROWS_Q01_25, @SCRIPT_VER, @COMMIT_HASH);
```

**Verificación:**
```bash
grep "FORCE_RESEED" provisioners/mariadb/seed_historico.sql | grep -v "^--"
# Esperado: 0 líneas de código ejecutable
```

---

### T-1.6 — Corregir G-29: probabilidad 0.003 → 0.388

**Problema:** `IF RAND() < 0.003` genera horas invertidas en 0.3% de los
registros. Los datos reales tienen 38.8% (`P_HORAS_INVERTIDAS = 0.388`
en `poblar_historico.py`).

**Acción:**

```sql
-- Antes:
IF RAND() < 0.003 THEN

-- Después:
-- G-29: 38.8% de registros tienen dHoraInicio > dHoraFin
-- (bug real del sistema IVR confirmado en Q1-Q3 2025 con 34.1M registros)
-- Ref: TBL-HISTORICO-ANOMALIAS.md §1, poblar_historico.py P_HORAS_INVERTIDAS
IF RAND() < 0.388 THEN
```

**Verificación:**
```bash
grep "RAND.*0.003\|RAND.*0.388" provisioners/mariadb/seed_historico.sql
# Esperado: solo la línea con 0.388
```

---

### T-1.7 — Recalibrar distribución de `cMenu` con menús reales

**Problema:** El SP usa 13 menús genéricos inexistentes en producción.
Las proporciones están descalibradas (+30pp en cliente_colgo).

**Acción:** Reemplazar el bloque `IF v_rand < 0.52 ... ELSE ... END IF`
completo con los menús reales de Q01_2025 y sus proporciones documentadas.
Los VDNs de cDID_Centro_Transferencia se actualizan en T-1.8.

```sql
-- Distribución basada en q01_2025.py — proporciones Q1 2025 reales
-- Simplificada para SQL: top 12 menús = 96.7% del volumen
-- Ref: TBL-HISTORICO-ANOMALIAS.md, perfiles/q01_2025.py
SET v_rand = RAND();
IF    v_rand < 0.226 THEN
    SET v_menu='cliente_colgo';     SET v_opcion=NULL;
ELSEIF v_rand < 0.306 THEN
    -- VACIO: NULL/vacío/sin cMenu (8% total)
    SET v_rand2 = RAND();
    IF    v_rand2 < 0.60 THEN SET v_menu=NULL;
    ELSEIF v_rand2 < 0.85 THEN SET v_menu='';
    ELSE                       SET v_menu='sin cMenu';
    END IF;
    SET v_opcion=NULL;
ELSEIF v_rand < 0.339 THEN
    SET v_menu='SinOpcion_Cabecera'; SET v_opcion=NULL;
ELSEIF v_rand < 0.360 THEN
    SET v_menu='Marque3';           SET v_opcion=NULL;
ELSEIF v_rand < 0.493 THEN
    SET v_menu='Desborde_Cabecera'; SET v_opcion=NULL;
ELSEIF v_rand < 0.522 THEN
    SET v_menu='Desborde_Promocional'; SET v_opcion=NULL;
ELSEIF v_rand < 0.665 THEN
    SET v_menu='RES-FallaInternet';
    SET v_opcion=ELT(1+FLOOR(RAND()*3),'DEFAULT','NOBOT','POSIBLE_FALLA_DSLAM_P');
ELSEIF v_rand < 0.694 THEN
    SET v_menu='RES-FallasLinea';
    SET v_opcion=IF(RAND()<0.9,'DEFAULT','ML');
ELSEIF v_rand < 0.820 THEN
    SET v_menu='NOTMX-SeguimientoInstalacion'; SET v_opcion='DEFAULT';
ELSEIF v_rand < 0.847 THEN
    SET v_menu='NOTMX-CONT-Contratacion';       SET v_opcion='DEFAULT';
ELSEIF v_rand < 0.902 THEN
    SET v_menu='RES-SaldooPagos';              SET v_opcion='DEFAULT';
ELSEIF v_rand < 0.962 THEN
    SET v_menu='RES-MADT-Detalle';
    SET v_opcion=IF(RAND()<0.9,'DEFAULT','2L');
ELSE
    -- Cola larga (<3.8%): RES-Entr, RES-ContratacionInfinitum, otros
    SET v_rand2 = RAND();
    IF    v_rand2 < 0.40 THEN SET v_menu='RES-Entr';                    SET v_opcion='DEFAULT';
    ELSEIF v_rand2 < 0.70 THEN SET v_menu='RES-ContratacionInfinitum';  SET v_opcion='DEFAULT';
    ELSEIF v_rand2 < 0.85 THEN SET v_menu='RES_CambioDom';              SET v_opcion='DEFAULT';
    ELSE                        SET v_menu='RES_Otros';                  SET v_opcion='DEFAULT';
    END IF;
END IF;
```

**Verificación:**
```bash
# Después de ejecutar el seed, verificar distribución
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy -N -e "
    SELECT COALESCE(cMenu,'NULL') AS menu,
           COUNT(*) AS cnt,
           ROUND(COUNT(*)/@@rowcount*100,1) AS pct
    FROM tbl_historico_t1_2025
    GROUP BY cMenu ORDER BY cnt DESC LIMIT 12;" 2>/dev/null
# Esperado: cliente_colgo ~22%, RES-FallaInternet ~14%, etc.
```

---

### T-1.8 — Recalibrar distribución de `cTelefono_Digitado` y VDNs reales

**Problema (teléfono):** NULL=30%, igual=45%, diferente=25%. Real: 21.2%, 28.2%, 50.6%.  
**Problema (VDNs):** 6 VDNs genéricos. Reales: 28+ por menú.

**Acción — cTelefono_Digitado:**

```sql
-- Antes:
IF    v_rand < 0.30 THEN SET v_tel_digitado = NULL;
ELSEIF v_rand < 0.75 THEN SET v_tel_digitado = v_tel_origen;
ELSE  SET v_tel_digitado = CONCAT('443',LPAD(...));

-- Después (calibrado con P_NULL=0.212, P_MISMA=0.282):
-- Ref: poblar_historico.py P_NULL, P_MISMA_GIVEN_NOTNULL
IF    v_rand < 0.212 THEN
    SET v_tel_digitado = NULL;
ELSEIF v_rand < 0.494 THEN
    -- misma_linea: 28.2% (0.212 + 0.282 = 0.494)
    SET v_tel_digitado = v_tel_origen;
ELSE
    -- linea_diferente: 50.6%
    SET v_tel_digitado = CONCAT(
        ELT(1+FLOOR(RAND()*4),'443','722','222','55'),
        FLOOR(1000000 + RAND() * 9000000));
END IF;
```

**Acción — cDID_Centro_Transferencia (VDNs reales):**

```sql
-- Reemplazar los 6 VDNs genéricos con los reales de Q01_2025
-- Ref: perfiles/q01_2025.py VDN_POR_MENU
-- Solo los más frecuentes (cubre >90% de los casos con VDN real):
IF v_menu IN ('cliente_colgo','SinOpcion_Cabecera','Marque3') OR
   v_menu IS NULL OR v_menu = '' OR v_menu = 'sin cMenu' THEN
    SET v_rand = RAND();
    IF    v_rand < 0.75 THEN SET v_centro = 'cliente_colgo';
    ELSEIF v_rand < 0.95 THEN SET v_centro = '19020086';
    ELSE                       SET v_centro = NULL;
    END IF;
ELSEIF v_menu = 'Desborde_Cabecera' THEN
    SET v_centro = IF(RAND()<0.75, 'cliente_colgo', '10928253');
ELSEIF v_menu = 'RES-FallaInternet' THEN
    SET v_rand = RAND();
    IF    v_rand < 0.49 THEN SET v_centro = '10828091';
    ELSEIF v_rand < 0.66 THEN SET v_centro = '19010000';
    ELSEIF v_rand < 0.80 THEN SET v_centro = '15070019';
    ELSE                       SET v_centro = '10728000';
    END IF;
ELSEIF v_menu = 'RES-FallasLinea' THEN
    SET v_centro = IF(RAND()<0.70,'15070019',
                   IF(RAND()<0.60,'10828091','10228051'));
ELSEIF v_menu = 'NOTMX-SeguimientoInstalacion' THEN SET v_centro = '10728487';
ELSEIF v_menu = 'NOTMX-CONT-Contratacion' THEN      SET v_centro = '15070059';
ELSEIF v_menu = 'RES-SaldooPagos' THEN
    SET v_centro = IF(RAND()<0.60,'14929014','1309004');
ELSEIF v_menu = 'RES-MADT-Detalle' THEN
    SET v_centro = IF(RAND()<0.80,'15070013','10928253');
ELSE
    SET v_centro = IF(RAND()<0.70,'15070013','19020086');
END IF;

-- NK90: VDN+teléfono concatenados (~5.7% de elegibles)
-- Ref: TBL-HISTORICO-ANOMALIAS.md §2.3, P_NK90=0.099
IF v_centro NOT IN ('cliente_colgo','19020086') AND
   v_centro IS NOT NULL AND
   v_tel_digitado IS NOT NULL AND RAND() < 0.099 THEN
    SET v_centro = CONCAT(v_centro, v_tel_digitado);
END IF;
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy -N -e "
    SELECT LENGTH(cDID_Centro_Transferencia) AS longitud, COUNT(*) AS cnt
    FROM tbl_historico_t1_2025
    WHERE cDID_Centro_Transferencia IS NOT NULL
    GROUP BY longitud ORDER BY cnt DESC;" 2>/dev/null
# Esperado: longitud 8 dominante (~82%), longitud 13 (~12%), longitud 17-18 (~5.7%)
```

---

### T-1.9 — Corregir generación de teléfonos: LPAD → rango fijo

**Problema:** `LPAD(FLOOR(RAND()*9999999), 7, '0')` produce ceros internos
(4430000123) en ~9.4% de los números generados.

**Acción — cTelefono_Origen:**

```sql
-- Antes:
SET v_tel_origen = CONCAT('443', LPAD(FLOOR(RAND()*9999999),7,'0'));

-- Después (rango [1000000..9999999] — siempre 7 dígitos sin ceros iniciales):
-- Distribución de prefijos desde poblar_historico.py PESOS_PREFIJOS
SET v_rand = RAND();
IF    v_rand < 0.30 THEN
    SET v_tel_origen = CONCAT('443', FLOOR(1000000 + RAND() * 9000000));
ELSEIF v_rand < 0.55 THEN
    SET v_tel_origen = CONCAT('722', FLOOR(1000000 + RAND() * 9000000));
ELSEIF v_rand < 0.75 THEN
    SET v_tel_origen = CONCAT('222', FLOOR(1000000 + RAND() * 9000000));
ELSE
    -- 55 + 8 dígitos [10000000..99999999]
    SET v_tel_origen = CONCAT('55', FLOOR(10000000 + RAND() * 90000000));
END IF;
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy -N -e "
    SELECT SUM(cTelefono_Origen REGEXP '^[0-9]{3}0') AS tiene_cero_pos4,
           COUNT(*) AS total
    FROM tbl_historico_t1_2025;" 2>/dev/null
# Esperado: tiene_cero_pos4 = 0
```

---

### T-1.10 — `@SCRIPT_VER`: convertir asignación en fallback condicional

**Problema:** `SET @SCRIPT_VER = '2.0.0';` sobreescribe la versión inyectada
por `schema_historico.sh` (`2.2.0`), dejando trazabilidad incorrecta en
`seed_executions`.

**Acción:**

```sql
-- Antes:
SET @SCRIPT_VER    = '2.0.0';

-- Después (fallback: usar la inyectada, o '2.0.0' si no viene ninguna):
SET @SCRIPT_VER = IF(@SCRIPT_VER IS NULL OR @SCRIPT_VER = '', '2.0.0', @SCRIPT_VER);
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy -N -e "
    SELECT script_version FROM seed_executions ORDER BY id DESC LIMIT 1;" 2>/dev/null
# Esperado: 2.2.0 (la versión de schema_historico.sh), no 2.0.0
```

---

### T-1.11 — Agregar escalas de volumen por quarter con offset aleatorio

**Problema:** Todos los quarters usan `@SEED_ROWS` exacto → volúmenes
idénticos que no reflejan la variación real de producción.

**Acción:** Reemplazar las variables de control y los CALL statements:

```sql
-- Variables de control
SET @SEED_ROWS = IF(@SEED_ROWS IS NULL OR @SEED_ROWS = 0, 3000, @SEED_ROWS);
SET @SCRIPT_VER = IF(@SCRIPT_VER IS NULL OR @SCRIPT_VER = '', '2.0.0', @SCRIPT_VER);

-- Escalas por quarter basadas en SUPUESTOS-VOLUMENES_2026-05-07T154105.md
-- Escala real: Q02_25 es el pico (1.136), Q03_25 el mínimo (0.954)
-- Offset FLOOR(RAND()*15)+3 garantiza último dígito no-cero y variación
SET @OFF = FLOOR(RAND() * 15) + 3;  -- offset base [3..17]

-- Q01_25: escala 1.000 (base real — 11.6M llamadas)
SET @SEED_Q01_25 = @SEED_ROWS + @OFF;

-- Q02_25: escala 1.136 (pico del año — 13.6M llamadas)
SET @SEED_Q02_25 = FLOOR(@SEED_ROWS * 1.136) + @OFF + FLOOR(RAND()*5);

-- Q03_25: escala 0.954 (valle — 11.5M llamadas)
SET @SEED_Q03_25 = FLOOR(@SEED_ROWS * 0.954) + @OFF + FLOOR(RAND()*5);

-- Q04_25: escala 1.041 (supuesto — fin de año)
SET @SEED_Q04_25 = FLOOR(@SEED_ROWS * 1.041) + @OFF + FLOOR(RAND()*5);

-- Q01_26: escala 1.010 (supuesto — crecimiento YoY ~4%)
SET @SEED_Q01_26 = FLOOR(@SEED_ROWS * 1.010) + @OFF + FLOOR(RAND()*5);

-- Q02_26: parcial — 36/91 días del Q02 con crecimiento ~5% sobre Q02_25
SET @SEED_Q02_26 = GREATEST(500,
    FLOOR(@SEED_ROWS * 1.136 * 36 / 91) + FLOOR(RAND()*7) + 3);
```

```sql
-- CALL statements actualizados:
CALL sp_seed_historico('tbl_historico_t1_2025','2025-01-01','2025-03-31',
    @SEED_Q01_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t2_2025','2025-04-01','2025-06-30',
    @SEED_Q02_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t3_2025','2025-07-01','2025-09-30',
    @SEED_Q03_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t4_2025','2025-10-01','2025-12-31',
    @SEED_Q04_25, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t1_2026','2026-01-01','2026-03-31',
    @SEED_Q01_26, @SCRIPT_VER, @COMMIT_HASH);
CALL sp_seed_historico('tbl_historico_t2_2026','2026-04-01','2026-05-06',
    @SEED_Q02_26, @SCRIPT_VER, @COMMIT_HASH);
```

**Verificación:**
```bash
for tbl in tbl_historico_t1_2025 tbl_historico_t2_2025 \
           tbl_historico_t3_2025 tbl_historico_t4_2025 \
           tbl_historico_t1_2026 tbl_historico_t2_2026; do
    cnt=$(mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
        -N -e "SELECT COUNT(*) FROM \`${tbl}\`;" 2>/dev/null)
    last=$(echo "${cnt}" | rev | cut -c1)
    echo "${tbl}: ${cnt} (último dígito: ${last})"
done
# Esperado: ninguna tabla con el mismo conteo, ninguna terminando en 0
```

---

### T-1.12 — Actualizar header de `seed_historico.sql`

**Acción:** Reemplazar el bloque de comportamiento en el header:

```sql
-- COMPORTAMIENTO POR EJECUCION:
--   1ra ejecucion  → inserta @SEED_Qnn registros (escala por quarter)
--   2da ejecucion  → APPEND: inserta @SEED_Qnn registros adicionales
--   Sin SKIP, sin TRUNCATE — cada ejecucion agrega datos.
--
-- ESCALAS POR QUARTER (proporcionales a datos reales Q1-Q3 2025):
--   Q01_25: 1.000 (base, 11.6M reales)
--   Q02_25: 1.136 (pico del año, 13.6M reales)
--   Q03_25: 0.954 (valle, 11.5M reales)
--   Q04_25: 1.041 (supuesto fin de año)
--   Q01_26: 1.010 (supuesto crecimiento YoY ~4%)
--   Q02_26: parcial 36/91 días (supuesto)
--
-- LIMITACIONES (cubiertas por NIVEL 2 — poblar_historico.py):
--   · Solo top 12 menús del catálogo real (Q01 tiene 39 menús)
--   · Sin evolución de menús por quarter
--   · VDNs simplificados (no cubre los 28+ VDNs reales por menú)
--
-- NIVEL 2 — después del seed SQL, ejecutar para mayor fidelidad:
--   python3 provisioners/mariadb/poblar_historico.py \
--       --rows 50000 --socket /run/mysqld/mysqld.sock
```

---

## FASE 2 — Integrar `poblar_historico.py` en `schema_historico.sh`

**Objetivo:** Agregar PASO 4 en `schema_historico.sh` que invoca
`poblar_historico.py` cuando Python 3 está disponible y `FULL_SEED=1`.

**Archivos:** `provisioners/mariadb/schema_historico.sh`

---

### T-2.1 — Agregar variable `FULL_SEED` en el bloque de configuración

**Acción:** Después de `SKIP_SEED="${SKIP_SEED:-0}"`, agregar:

```bash
# FULL_SEED: 0 (default) = solo seed SQL (Nivel 1)
#            1 = seed SQL + poblar_historico.py (Nivel 2, requiere Python 3)
# Nota: poblar_historico.py usa --truncate para reemplazar el seed SQL
#       con datos de mayor fidelidad (39 menus reales, VDNs por menú, escalas).
FULL_SEED="${FULL_SEED:-0}"
```

**Verificación:**
```bash
grep "FULL_SEED" provisioners/mariadb/schema_historico.sh | head -3
```

---

### T-2.2 — Agregar PASO 4 en `main()` para invocar `poblar_historico.py`

**Acción:** Después del bloque `if [[ "${SKIP_SEED}" == "1" ]]` existente
(que maneja el seed SQL), agregar PASO 4:

```bash
# ------------------------------------------------------------------
# Paso 4: seed de alta fidelidad con poblar_historico.py (opcional)
# ------------------------------------------------------------------
log_step 4 4 "Seed de alta fidelidad (Nivel 2 — requiere Python 3)"

if [[ "${SKIP_SEED}" == "1" ]]; then
    log_info "SKIP_SEED=1 — poblar_historico.py omitido."
elif [[ "${FULL_SEED}" != "1" ]]; then
    log_info "FULL_SEED no activo — seed SQL (Nivel 1) es suficiente."
    log_info "Para seed de alta fidelidad: FULL_SEED=1 sudo bash ${BASH_SOURCE[0]}"
elif ! command -v python3 &>/dev/null; then
    log_warn "python3 no disponible — poblar_historico.py omitido."
    log_warn "Instalar con: sudo apt-get install -y python3"
elif [[ ! -f "${SCRIPT_DIR}/poblar_historico.py" ]]; then
    log_warn "No encontrado: ${SCRIPT_DIR}/poblar_historico.py — omitido."
else
    log_info "Ejecutando poblar_historico.py (esto puede tardar varios minutos)..."
    log_info "  --rows: ${SEED_ROWS:-3000}"
    log_info "  Reemplazará los datos del seed SQL con mayor fidelidad."

    if python3 "${SCRIPT_DIR}/poblar_historico.py" \
            --rows "${SEED_ROWS:-3000}" \
            --truncate \
            --socket "${DB_ROOT_SOCK}" \
            --user root \
            --password "${DB_ROOT_PASS}" \
            --db "${DB_NAME}" 2>&1 \
        | while IFS= read -r line; do log_info "  ${line}"; done; then
        log_success "poblar_historico.py completado"
    else
        log_warn "poblar_historico.py falló — los datos del seed SQL siguen disponibles"
    fi
fi
```

**Verificación:**
```bash
bash -n provisioners/mariadb/schema_historico.sh && echo "Sintaxis OK"
grep -n "FULL_SEED\|poblar_historico\|Nivel 2" \
    provisioners/mariadb/schema_historico.sh | head -8
```

---

### T-2.3 — Actualizar `log_step` para reflejar 4 pasos (antes era 3)

**Acción:** En `main()`, cambiar las referencias `log_step X 3` por
`log_step X 4`:

```bash
# Antes:
log_step 1 3 "Verificar acceso a MariaDB"
log_step 2 3 "Crear tablas tbl_historico_tN_YYYY"
log_step 3 3 "Seed de datos"

# Después:
log_step 1 4 "Verificar acceso a MariaDB"
log_step 2 4 "Crear tablas tbl_historico_tN_YYYY"
log_step 3 4 "Seed de datos (Nivel 1 — SQL)"
log_step 4 4 "Seed de alta fidelidad (Nivel 2 — Python)"
```

**Verificación:**
```bash
grep "log_step" provisioners/mariadb/schema_historico.sh
# Esperado: 4 log_step, todos con "4" como total
```

---

## FASE 3 — Validación

### T-3.1 — Verificar sintaxis de ambos archivos modificados

```bash
bash -n provisioners/mariadb/seed_historico.sql 2>/dev/null \
    || mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
       -e "SOURCE provisioners/mariadb/seed_historico.sql" 2>&1 \
    | grep -i "error" | head -5

bash -n provisioners/mariadb/schema_historico.sh && echo "schema_historico.sh: OK"
```

---

### T-3.2 — Ejecutar seed SQL con tablas vacías (primera ejecución)

```bash
cd /tmp/references/IACT-db
export PROJECT_ROOT=/tmp/references/IACT-db

# Reset tablas para prueba limpia
for tbl in tbl_historico_t1_2025 tbl_historico_t2_2025 \
           tbl_historico_t3_2025 tbl_historico_t4_2025 \
           tbl_historico_t1_2026 tbl_historico_t2_2026; do
    mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
        -e "TRUNCATE TABLE \`${tbl}\`;" 2>/dev/null
done

SKIP_SEED=0 FULL_SEED=0 SEED_ROWS=3000 \
    bash provisioners/mariadb/schema_historico.sh 2>&1 \
    | grep -E "STEP|SUCCESS|SEED:|APPEND:|ERROR|Sembrando"
```

**Verificación:** 6 tablas con acción `SEED`, conteos distintos por quarter,
ninguno terminando en 0.

---

### T-3.3 — Ejecutar seed SQL por segunda vez (APPEND incremental)

```bash
SKIP_SEED=0 FULL_SEED=0 SEED_ROWS=3000 \
    bash provisioners/mariadb/schema_historico.sh 2>&1 \
    | grep -E "APPEND:|SEED:|filas"
```

**Verificación:** Acción `APPEND` en las 6 tablas. Conteos aproximadamente
duplicados respecto a T-3.2.

---

### T-3.4 — Verificar distribución de datos post-seed

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy -N -e "
    SELECT 'G-29' AS metrica,
           ROUND(SUM(dHoraInicio > dHoraFin)/COUNT(*)*100,1) AS pct_seed,
           38.8 AS pct_real
    FROM tbl_historico_t1_2025
    UNION ALL
    SELECT 'cliente_colgo',
           ROUND(SUM(cMenu='cliente_colgo')/COUNT(*)*100,1),
           22.6
    FROM tbl_historico_t1_2025
    UNION ALL
    SELECT 'tel_null',
           ROUND(SUM(cTelefono_Digitado IS NULL)/COUNT(*)*100,1),
           21.2
    FROM tbl_historico_t1_2025;" 2>/dev/null
```

**Verificación:** G-29 ≈ 38.8% (±2pp), cliente_colgo ≈ 22.6% (±2pp),
tel_null ≈ 21.2% (±2pp).

---

### T-3.5 — Verificar volumenes distintos por quarter

```bash
for tbl in tbl_historico_t1_2025 tbl_historico_t2_2025 \
           tbl_historico_t3_2025 tbl_historico_t4_2025 \
           tbl_historico_t1_2026 tbl_historico_t2_2026; do
    cnt=$(mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
        -N -e "SELECT COUNT(*) FROM \`${tbl}\`;" 2>/dev/null)
    echo "  ${tbl}: ${cnt}"
done
```

**Verificación:** Ningún par de tables con el mismo conteo. Q02_25 es el
mayor. Ninguna termina en 0.

---

### T-3.6 — Ejecutar verify.sh y confirmar 0 ERR

```bash
cd /tmp/references/IACT-db
export PROJECT_ROOT=/tmp/references/IACT-db
bash verify.sh > /tmp/verify_final3.txt 2>&1
echo "EXIT: $?"
grep -E "OK:|Advertencias:|Errores:" /tmp/verify_final3.txt \
    | sed 's/\x1b\[[0-9;]*m//g'
# Esperado: 26 OK, 0 WARN, 0 ERR
```

---

## FASE 4 — Documentación

### T-4.1 — Actualizar `SCRIPT_VERSION` en `schema_historico.sh`

```bash
# De 2.2.0 a 2.3.0 (agrega PASO 4 y FULL_SEED)
```

### T-4.2 — Actualizar changelog de `schema_historico.sh`

Agregar entrada `v2.3.0 (2026-05-10)`:
- PASO 4: integración de `poblar_historico.py` (FULL_SEED=1)
- Variable FULL_SEED para activar Nivel 2
- `log_step` actualizado a 4 pasos totales

### T-4.3 — Actualizar changelog de `seed_historico.sql`

Agregar entrada `v3.0.0 (2026-05-10)`:
- H-SEED-001: SKIP → APPEND incremental
- H-SEED-002: FORCE_RESEED/TRUNCATE eliminados
- H-SEED-003: G-29 calibrado 0.003 → 0.388
- H-SEED-004: cMenu con menús reales Q01_2025 (top 12)
- H-SEED-005/006: cTelefono calibrado con P_NULL=0.212, P_MISMA=0.282
- H-SEED-007: LPAD → rango fijo sin ceros internos
- H-SEED-008: @SCRIPT_VER como fallback condicional
- H-SEED-010/011: escalas por quarter y offset aleatorio

### T-4.4 — Marcar hallazgos como RESUELTOS

En `HALLAZGOS-SEED-SQL-202605102030.md` y
`HALLAZGOS-SEED-VOLUMEN-MENUS-202605102045.md`:
- H-SEED-001..011: RESUELTO
- H-SEED-012..014: RESUELTO via poblar_historico.py (Nivel 2)
- H-SEED-015: RESUELTO — integración en schema_historico.sh PASO 4

---

## Resumen ejecutivo

| FASE | Tareas | Archivo | Hallazgos | Prioridad |
|---|---|---|---|---|
| FASE 0 — Pre-condición | T-0.1 | — | Entorno | — |
| FASE 1 — Fix SQL | T-1.1..T-1.12 | `seed_historico.sql` | H-SEED-001..011 | CRÍTICA |
| FASE 2 — Python | T-2.1..T-2.3 | `schema_historico.sh` | H-SEED-012..015 | ALTA |
| FASE 3 — Validación | T-3.1..T-3.6 | — | Todos | — |
| FASE 4 — Docs | T-4.1..T-4.4 | Changelogs + hallazgos | — | BAJA |

**Total: 21 tareas atómicas**

## Orden obligatorio

```
FASE 0 → FASE 1 (T-1.1..T-1.12 en secuencia) → FASE 2 → FASE 3 → FASE 4
```

T-1.2..T-1.5 deben ejecutarse en bloque (firma del SP se modifica antes
de cambiar el cuerpo). T-1.7 y T-1.8 deben ejecutarse después de T-1.4
(el bloque de decisión de acción debe existir antes de agregar la lógica
de menús y VDNs).
