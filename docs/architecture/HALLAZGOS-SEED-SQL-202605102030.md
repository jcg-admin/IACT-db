# Hallazgos — Análisis del seed SQL vs datos reales y requisitos de rediseño

**Versión:** 2.0.0  
**Fecha actualización:** 2026-05-10 (FASE 4)  
**Fecha:** 2026-05-10  
**Contexto:** Análisis solicitado por el equipo: comportamiento incremental,
variaciones en datos generados y eliminación de TRUNCATE.  
**Referencia:** `TBL-HISTORICO-ANOMALIAS.md`, `poblar_historico.py`,
`PERFILES-QUARTER.md`, datos reales Q1–Q3 2025

---

## Resumen ejecutivo

El SP `sp_seed_historico` en `seed_historico.sql` tenía tres categorías de
problemas: **comportamental** (skip en lugar de append, truncate que destruye
datos), **distribucional** (proporciones alejadas de los datos reales) y
**generacional** (números de teléfono con ceros internos por LPAD).
Todos fueron resueltos en `seed_historico.sql` v3.0.0 (commit `c2890f0`).

| ID | Hallazgo | Categoría | Severidad | Estado |
|---|---|---|---|---|
| H-SEED-001 | 2ª ejecución hace SKIP — no es incremental | Comportamiento | ALTA | RESUELTO |
| H-SEED-002 | FORCE_RESEED=TRUNCATE destruye datos con valor | Comportamiento | ALTA | RESUELTO |
| H-SEED-003 | G-29 (horas invertidas): 0.37% en seed vs 38.8% en producción | Distribución | CRÍTICA | RESUELTO |
| H-SEED-004 | `cMenu='cliente_colgo'`: 52.4% en seed vs 21.87% en producción | Distribución | ALTA | RESUELTO |
| H-SEED-005 | `cTelefono_Digitado IS NULL`: 30.9% en seed vs 21.2% en producción | Distribución | MEDIA | RESUELTO |
| H-SEED-006 | `cTelefono_Digitado = Origen`: 44.4% en seed vs 28.2% en producción | Distribución | MEDIA | RESUELTO |
| H-SEED-007 | LPAD genera ceros internos en números de teléfono (9.4% afectados) | Generación | MEDIA | RESUELTO |
| H-SEED-008 | `@SCRIPT_VER` sobreescrita en el SQL (ya documentado en H-F1-005) | Trazabilidad | BAJA | RESUELTO |
| H-SEED-009 | `poblar_historico.py` ya tiene el diseño correcto — el SQL debería alinearse | Referencia | — | DOCUMENTADO |

---

## Comparativa completa: seed SQL actual vs producción real

| Condición | SQL actual | Producción real | Diferencia | Referencia |
|---|---|---|---|---|
| `dHoraInicio > dHoraFin` (G-29) | 0.37% | 38.8% | **−38.4pp** | TBL-HISTORICO §1 |
| `cMenu = 'cliente_colgo'` | 52.4% | 21.87% | **+30.5pp** | TBL-HISTORICO §3.3 |
| `cMenu = 'SinOpcion_Cabecera'` | 4.2% | 3.14% | +1.1pp | TBL-HISTORICO §3.4 |
| `cMenu IS NULL/vacío/sin cMenu` | 8.5% | 6.97% | +1.5pp | TBL-HISTORICO §3.1 |
| `cTelefono_Digitado IS NULL` | 30.9% | 21.2% | **+9.7pp** | TBL-HISTORICO §4.1 |
| `cTelefono_Digitado = Origen` | 44.4% | 28.2% | **+16.2pp** | TBL-HISTORICO §4.2 |
| Números con cero en pos. 4 | 9.4% | ~0% en reales | Irreal | §4 LPAD |
| Números con doble cero | 5.4% | ~0% en reales | Irreal | §4 LPAD |

---

## H-SEED-001 — 2ª ejecución hace SKIP — no incremental

**Categoría:** Comportamiento  
**Severidad:** ALTA  
**Estado:** RESUELTO — `seed_historico.sql` v3.0.0 (T-1.4, commit `c2890f0`)

### Comportamiento actual

```sql
IF v_count_antes > 0 AND p_force = 0 THEN
    SET v_accion = 'SKIP';
    LEAVE sp_seed_historico;   -- ← sale sin insertar nada
END IF;
```

Cuando la tabla ya tiene datos, el SP sale inmediatamente. Cada trimestre de
datos reales IVR es incremental — el sistema IVR genera llamadas diariamente
y los datos históricos crecen con cada carga.

### Comportamiento requerido

```
1ª ejecución (tabla vacía):      INSERT SEED_ROWS registros → accion='SEED'
Ejecuciones siguientes:          INSERT SEED_ROWS registros adicionales → accion='APPEND'
```

La distinción entre SEED y APPEND en `seed_executions` permite saber cuándo
ocurrió la siembra inicial y cuántas filas se añadieron en cada ejecución
posterior.

### Corrección requerida

Eliminar el bloque `IF v_count_antes > 0 AND p_force = 0` completo.
La acción se distingue por el conteo inicial:

```sql
-- En lugar del IF de skip:
IF v_count_antes = 0 THEN
    SET v_accion = 'SEED';
ELSE
    SET v_accion = 'APPEND';
END IF;
-- Continuar siempre con el INSERT
```

---

## H-SEED-002 — FORCE_RESEED/TRUNCATE destruye datos con valor

**Categoría:** Comportamiento  
**Severidad:** ALTA  
**Estado:** RESUELTO — `seed_historico.sql` v3.0.0 (T-1.2/T-1.3, commit `c2890f0`)

### Comportamiento actual

```sql
IF p_force = 1 AND v_count_antes > 0 THEN
    SET v_accion = 'TRUNCATE+SEED';
    SET v_sql = CONCAT('TRUNCATE TABLE ', p_tabla);
    PREPARE s FROM v_sql; EXECUTE s; DEALLOCATE PREPARE s;
END IF;
```

Con `FORCE_RESEED=1`, el SP trunca la tabla antes de insertar. Para datos
históricos del IVR del cliente, esto es incorrecto: cada registro insertado
tiene valor, incluyendo los que tienen errores documentados (G-29, NK90, etc.)
ya que esos errores son condiciones reales que el ETL debe manejar.

### Corrección requerida

Eliminar completamente el parámetro `p_force` del SP y toda la lógica de
TRUNCATE:

```sql
-- Eliminar de la firma:
-- IN p_force TINYINT,

-- Eliminar el bloque completo:
-- IF p_force = 1 AND v_count_antes > 0 THEN ... END IF;
```

Y de los CALL statements al final del SQL:

```sql
-- Antes:
CALL sp_seed_historico('tbl_historico_t1_2025', ..., @SEED_ROWS, @FORCE_RESEED, ...);

-- Después:
CALL sp_seed_historico('tbl_historico_t1_2025', ..., @SEED_ROWS, ...);
```

---

## H-SEED-003 — G-29: horas invertidas al 0.37% vs 38.8% en producción

**Categoría:** Distribución  
**Severidad:** CRÍTICA  
**Estado:** RESUELTO — `seed_historico.sql` v3.0.0 (T-1.6, commit `c2890f0`)

### Descripción

El bug G-29 (`dHoraInicio > dHoraFin`) afecta al 38.8% de los registros reales
según `TBL-HISTORICO-ANOMALIAS.md`. El seed SQL actual tiene probabilidad 0.003
(0.3%), dejando la distribución 100× por debajo de la real.

```
Datos reales Q1–Q3 2025:  ~38.8% de ~34.1M = ~13.2M registros afectados
Seed SQL actual:           0.37% de 3000 = ~11 registros
poblar_historico.py:       P_HORAS_INVERTIDAS = 0.388 (calibrado correctamente)
```

### Código actual en `seed_historico.sql`

```sql
IF RAND() < 0.003 THEN   -- ← 0.3%, debería ser 0.388 (38.8%)
    SET v_hora_fin = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora));
    SET v_hora_ini = TIMESTAMP(v_fecha, SEC_TO_TIME(v_inicio_hora + v_duracion_seg));
END IF;
```

### Impacto

Los SPs que calculan duración (`sp_rpt_centros_xsegmento`, `sp_etl_base_detalle`)
deben incluir el CASE para manejar G-29. Si el seed tiene solo 0.3% de G-29,
los tests contra el seed no revelan si el CASE funciona correctamente — se
necesita un volumen representativo (~39%) para validar el comportamiento del ETL.

### Corrección requerida

```sql
-- Cambiar:
IF RAND() < 0.003 THEN

-- Por:
IF RAND() < 0.388 THEN
```

---

## H-SEED-004 — `cMenu = 'cliente_colgo'` al 52.4% vs 21.87% en producción

**Categoría:** Distribución  
**Severidad:** ALTA  
**Estado:** RESUELTO — `seed_historico.sql` v3.0.0 (T-1.7, commit `c2890f0`)

### Descripción

El seed SQL asigna `cMenu = 'cliente_colgo'` con probabilidad acumulada 0.52
(primer ramo del IF-ELSEIF). Los datos reales documentados indican 21.87%.

```
Datos reales Q1 2025:  21.87%
Seed SQL actual:       52.4%   ← +30.5 puntos porcentuales
poblar_historico.py:   usa perfiles por quarter con distribución calibrada
```

### Distribución actual del seed SQL vs real

| cMenu | SQL actual | Real Q1 2025 |
|---|---|---|
| `cliente_colgo` | 52.4% | 21.87% |
| `Desborde_Cabecera` | 5.4% | ~5% |
| `Saldo` | 5.3% | varía por perfil |
| `SinOpcion_Cabecera` | 4.2% | 3.14% |
| `Atencion` | 4.2% | varía |
| `Pagos` | 4.2% | varía |
| NULL | 3.3% | 3.5% (parte de VACIO 6.97%) |
| vacío (`''`) | 3.3% | parte de VACIO |
| `sin cMenu` | 1.8% | parte de VACIO |

### Causa

El ramo `IF v_rand < 0.52` captura toda la variante de abandono con un umbral
excesivo. La probabilidad correcta para `cliente_colgo` es ~0.22, no 0.52.

### Corrección requerida

Redistribuir los umbrales del bloque cMenu:

```sql
-- Cambiar:
IF    v_rand < 0.52 THEN SET v_menu='cliente_colgo';  SET v_opcion=NULL;
-- Por:
IF    v_rand < 0.22 THEN SET v_menu='cliente_colgo';  SET v_opcion=NULL;
```

Ajustar también los umbrales subsiguientes para mantener la suma en 1.0.

---

## H-SEED-005 y H-SEED-006 — Distribución de `cTelefono_Digitado`

**Categoría:** Distribución  
**Severidad:** MEDIA  
**Estado:** RESUELTO — `seed_historico.sql` v3.0.0 (T-1.8a, commit `c2890f0`)

### Descripción

Las tres condiciones de `cTelefono_Digitado` son mutuamente excluyentes y
exhaustivas. Los porcentajes deben sumar 100%:

| Condición | SQL actual | Real (documentado) | `poblar_historico.py` |
|---|---|---|---|
| NULL (`no_digito_telefono`) | 30.9% | 21.2% | `P_NULL = 0.212` |
| `= Origen` (`misma_linea`) | 44.4% | 28.2% | `P_MISMA = 0.282` |
| `≠ Origen` (`linea_diferente`) | 24.7% | 50.6% | calculado como resto |

### Código actual en `seed_historico.sql`

```sql
-- cTelefono_Digitado
SET v_rand = RAND();
IF    v_rand < 0.30 THEN SET v_tel_digitado = NULL;           -- 30%
ELSEIF v_rand < 0.75 THEN SET v_tel_digitado = v_tel_origen;  -- 45%
ELSE  SET v_tel_digitado = CONCAT('443',...);                  -- 25%
```

### Corrección requerida

Alinear con las constantes de `poblar_historico.py`:

```sql
-- Cambiar a:
IF    v_rand < 0.212 THEN SET v_tel_digitado = NULL;           -- 21.2%
ELSEIF v_rand < 0.494 THEN SET v_tel_digitado = v_tel_origen;  -- 28.2% (0.212+0.282)
ELSE  SET v_tel_digitado = CONCAT([prefijo_aleatorio],...);     -- 50.6%
```

---

## H-SEED-007 — LPAD genera números de teléfono con ceros internos

**Categoría:** Generación  
**Severidad:** MEDIA  
**Estado:** RESUELTO — `seed_historico.sql` v3.0.0 (T-1.9, commit `c2890f0`)

### Descripción

El algoritmo actual:

```sql
SET v_tel_origen = CONCAT('443', LPAD(FLOOR(RAND()*9999999), 7, '0'));
```

`FLOOR(RAND()*9999999)` produce valores en `[0, 9999999]`. Cuando el valor
tiene menos de 7 dígitos (probabilidad ≈ 10%), LPAD rellena con ceros a la
izquierda del fragmento numérico:

```
FLOOR(RAND()*9999999) = 472635   → LPAD(472635, 7, '0') = '0472635'
Teléfono resultante: '4430472635'   ← cero en posición 4 (irreal)

FLOOR(RAND()*9999999) = 643909   → LPAD(643909, 7, '0') = '0643909'
Teléfono resultante: '4430643909'   ← cero en posición 4 (irreal)
```

### Evidencia empírica

```
Números con cero en posición 4:  283/3000 = 9.4%
Números con doble cero:          162/3000 = 5.4%
```

Estos patrones no existen en números telefónicos reales mexicanos.

### `poblar_historico.py` lo resuelve correctamente

```python
PREFIJOS = [('443',7), ('722',7), ('222',7), ('55',8), ...]
pref, digs = random.choices(PREFIJOS, weights=PESOS_PREFIJOS)[0]
return pref + str(random.randint(0, 10**digs - 1)).zfill(digs)
# zfill rellena con ceros a la izquierda del fragmento
# pero randint(0, 9999999) produce [0..9999999] — mismo problema potencial
# La diferencia: random.randint genera valores distribuidos uniformemente
# y str().zfill() es equivalente a LPAD
```

En realidad `poblar_historico.py` tiene el mismo potencial de ceros, pero la
probabilidad es baja porque `randint(0, 9999999)` genera uniformemente y
el relleno con `zfill` produce `0472635` igual que LPAD.

### Corrección correcta para ambos

Usar un rango que garantice siempre el número de dígitos correcto:

```sql
-- Para sufijo de 7 dígitos: rango [1000000, 9999999]
SET v_tel_origen = CONCAT('443',
    FLOOR(1000000 + RAND() * 9000000));

-- Para sufijo de 8 dígitos: rango [10000000, 99999999]
SET v_tel_origen = CONCAT('55',
    FLOOR(10000000 + RAND() * 90000000));
```

Esto garantiza que el sufijo siempre tenga exactamente 7 u 8 dígitos sin
ceros iniciales — un número de teléfono realista.

---

## H-SEED-008 — `@SCRIPT_VER` sobreescrita por el SQL (ya en H-F1-005)

**Categoría:** Trazabilidad  
**Severidad:** BAJA  
**Estado:** RESUELTO — `seed_historico.sql` v3.0.0 (T-1.10, commit `c2890f0`)

`seed_historico.sql` define `SET @SCRIPT_VER = '2.0.0';` sobreescribiendo
la versión inyectada por `schema_historico.sh` (`2.2.0`). La corrección
es convertir esta línea en un fallback condicional:

```sql
SET @SCRIPT_VER = IF(@SCRIPT_VER IS NULL OR @SCRIPT_VER = '', '2.0.0', @SCRIPT_VER);
```

---

## H-SEED-009 — `poblar_historico.py` es la referencia correcta

**Categoría:** Referencia arquitectónica  
**Estado:** DOCUMENTADO

`poblar_historico.py` fue desarrollado con mayor precisión que `seed_historico.sql`
y es la implementación de referencia. Tiene:

- Constantes calibradas contra datos reales Q1–Q3 2025 (38,000–50,000 registros)
- `P_HORAS_INVERTIDAS = 0.388` — G-29 calibrado
- `P_NULL = 0.212`, `P_MISMA = 0.282` — distribución de teléfonos calibrada
- Perfiles por quarter (`perfiles/q01_2025.py`...) — distribución de menús
  variable por trimestre
- Validación estadística incorporada (verifica ±1.5pp de las proporciones objetivo)

`seed_historico.sql` debe alinearse con las constantes de `poblar_historico.py`,
no inventar distribuciones propias.

---

## Plan de correcciones requerido

Las correcciones son todas en `seed_historico.sql`. El orden es:

```
1. H-SEED-002: Eliminar p_force y lógica TRUNCATE  (reduce la firma del SP)
2. H-SEED-001: Cambiar skip → append incremental   (lógica de accion)
3. H-SEED-003: Corregir probabilidad G-29          (0.003 → 0.388)
4. H-SEED-004: Recalibrar distribución cMenu       (0.52 → 0.22 para cliente_colgo)
5. H-SEED-005/006: Recalibrar distribución tel_digitado
6. H-SEED-007: Corregir generación de teléfonos    (eliminar LPAD, usar rango fijo)
7. H-SEED-008: Convertir @SCRIPT_VER en fallback   (una línea)
```

Alcance: `provisioners/mariadb/seed_historico.sql` — un solo archivo.  
`schema_historico.sh` no requiere cambios (H-F1-003 confirmado).
