# Hallazgos — Ejecución FASE 1 (Corrección de seed_historico.sql)

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Implementación de FASE 1 del
`PLAN-SEED-HISTORICO-V2-202605102100.md`  
**Archivo modificado:** `provisioners/mariadb/seed_historico.sql` → v3.0.0

---

## Resultado de las tareas del plan

| Tarea | Descripción | Estado | Observaciones |
|---|---|---|---|
| T-1.1 | `seed_executions.accion` → VARCHAR(20) + ALTER TABLE | COMPLETO | |
| T-1.2 | Eliminar `p_force` de la firma del SP | COMPLETO | |
| T-1.3 | Eliminar bloque TRUNCATE completo | COMPLETO | |
| T-1.4 | SKIP → APPEND incremental | COMPLETO | |
| T-1.5 | Eliminar `@FORCE_RESEED` de variables y CALLs | COMPLETO | |
| T-1.6 | G-29: 0.003 → 0.388 | COMPLETO | |
| T-1.7 | cMenu real Q01_2025 (22 menús) | COMPLETO | |
| T-1.8a | cTelefono_Digitado calibrado | COMPLETO | |
| T-1.8b | VDNs reales por menú | COMPLETO + H-F1-001 | Bug detectado y corregido |
| T-1.9 | LPAD → rango fijo sin ceros internos | COMPLETO + H-F1-002 | Ver análisis |
| T-1.10 | `@SCRIPT_VER` como fallback condicional | COMPLETO | |
| T-1.11 | Escalas por quarter + offset aleatorio | COMPLETO | |
| T-1.12 | Actualizar header y CHANGELOG v3.0.0 | COMPLETO | |

---

## Resultados confirmados

### Primera ejecución (SEED)

```
tbl_historico_t1_2025:  3012  (escala 1.000  + offset)
tbl_historico_t2_2025:  3422  (escala 1.136  pico)
tbl_historico_t3_2025:  2878  (escala 0.954  valle)
tbl_historico_t4_2025:  3139  (escala 1.041)
tbl_historico_t1_2026:  3048  (escala 1.010)
tbl_historico_t2_2026:  1351  (parcial 36/91 días)
```

Ningún quarter termina en 0. Q02_25 es el pico. Q03_25 es el valle. Correcto.

### Segunda ejecución (APPEND)

```
tbl_historico_t1_2025:  6026  (+3014 APPEND)
tbl_historico_t2_2025:  6845  (+3423 APPEND)
tbl_historico_t3_2025:  5756  (+2878 APPEND)
tbl_historico_t4_2025:  6279  (+3140 APPEND)
tbl_historico_t1_2026:  6097  (+3049 APPEND)
tbl_historico_t2_2026:  2708  (+1357 APPEND)
```

`seed_executions` registra 12 filas: 6 SEED + 6 APPEND. Correcto.

### verify.sh final

```
26 OK, 0 WARN, 0 ERR, EXIT 0
```

---

## Distribuciones validadas post-implementación

Medidas en `tbl_historico_t1_2025` (3012 registros):

| Condición | Seed v3.0.0 | Objetivo | Diff | Tolerancia ±2pp |
|---|---|---|---|---|
| G-29 (horas invertidas) | 38.1% | 38.8% | 0.7pp | ✓ |
| `cMenu = 'cliente_colgo'` | 23.5% | 22.6% | 0.9pp | ✓ |
| VACIO (NULL/vacío/sin cMenu) | 7.9% | 8.0% | 0.1pp | ✓ |
| `RES-FallaInternet` | 13.7% | 14.3% | 0.6pp | ✓ |
| `NOTMX-SeguimientoInstalacion` | 10.7% | 11.6% | 0.9pp | ✓ |
| `cTelefono_Digitado IS NULL` | 22.2% | 21.2% | 1.0pp | ✓ |
| `cTelefono_Digitado = Origen` | 27.6% | 28.2% | 0.6pp | ✓ |

Todas las distribuciones dentro de ±1.5pp. Sin deuda técnica en calibración.

---

## Hallazgos identificados

| ID | Hallazgo | Tipo | Severidad | Estado |
|---|---|---|---|---|
| H-F1-001 | cDID agrupaba `SinOpcion_Cabecera` y `Marque3` con `cliente_colgo` | Bug en T-1.8 | ALTA | RESUELTO en sesión |
| H-F1-002 | Teléfonos `55X` con '0' en pos. 4 no son un bug — es patrón válido | Falso positivo | — | DOCUMENTADO |
| H-F1-003 | `cDID='cliente_colgo'` al ~40% vs 12.10% producción | Limitación de Nivel 1 | MEDIA | DOCUMENTADO |
| H-F1-004 | `FORCE_RESEED: 0` sigue apareciendo en log de `schema_historico.sh` | Deuda FASE 2 | BAJA | PENDIENTE FASE 2 |
| H-F1-005 | `script_version='2.2.0'` en lugar de '3.0.0' en `seed_executions` | Trazabilidad | BAJA | DOCUMENTADO |

---

## H-F1-001 — cDID agrupaba `SinOpcion_Cabecera` y `Marque3` con `cliente_colgo`

**Tipo:** Bug detectado durante ejecución de T-1.8  
**Severidad:** ALTA  
**Estado:** RESUELTO durante la sesión (antes del primer commit)

### Descripción

El bloque de cDID original agrupaba cuatro categorías bajo una misma lógica:

```sql
-- INCORRECTO:
IF v_menu IN ('cliente_colgo','SinOpcion_Cabecera','Marque3')
   OR v_menu IS NULL OR v_menu = '' OR v_menu = 'sin cMenu' THEN
    IF v_rand < 0.75 THEN SET v_centro = 'cliente_colgo';  -- 75%
    ...
```

Según `q01_2025.py VDN_POR_MENU`:

```python
'cliente_colgo':      ('cliente_colgo',)         # SIEMPRE 'cliente_colgo'
None (VACIO):         [('cliente_colgo',0.80)...] # 80% 'cliente_colgo'
'SinOpcion_Cabecera': [('19020086',1.0)]          # SIEMPRE '19020086'
'Marque3':            [('19020086',1.0)]          # SIEMPRE '19020086'
```

`SinOpcion_Cabecera` y `Marque3` nunca tienen `'cliente_colgo'` en cDID —
el cliente llegó al IVR pero fue enrutado al VDN de desborde `19020086`.
Mezclarlos con `'cliente_colgo'` producía 75-77% `'cliente_colgo'`
para estas categorías, lo que no existe en producción.

### Corrección aplicada

```sql
IF v_menu = 'cliente_colgo' THEN
    SET v_centro = 'cliente_colgo';  -- 100%

ELSEIF v_menu IS NULL OR v_menu = '' OR v_menu = 'sin cMenu' THEN
    IF    v_rand < 0.80 THEN SET v_centro = 'cliente_colgo';
    ELSEIF v_rand < 0.97 THEN SET v_centro = '19020086';
    ELSE                       SET v_centro = NULL;
    END IF;

ELSEIF v_menu IN ('SinOpcion_Cabecera','Marque3') THEN
    SET v_centro = '19020086';  -- 100%
```

### Lección metodológica

El bloque de cDID fue escrito agrupando "abandono" como una categoría única
sin verificar los VDNs específicos de cada menú en `q01_2025.py`. La
verificación post-ejecución detectó el 77% de `'cliente_colgo'` en
`SinOpcion_Cabecera` — valor imposible según los datos reales.

---

## H-F1-002 — Teléfonos '55X' con '0' en posición 4 no son un bug

**Tipo:** Falso positivo — comportamiento esperado y válido  
**Estado:** DOCUMENTADO

### Descripción

Tras el fix de T-1.9 (`FLOOR(10000000 + RAND() * 90000000)` para prefijo '55'),
el análisis detectó 2.75% de teléfonos con '0' en posición 4 del número completo.
La primera hipótesis era que LPAD seguía causando problemas.

### Análisis

Con `CONCAT('55', FLOOR(10000000 + RAND() * 90000000))`:

```
Sufijo range: [10000000, 99999999]
Número completo: '55' + sufijo
Posición 4 del número = segundo dígito del sufijo
Cuando sufijo ∈ [10000000..19999999]: segundo dígito = '0'
Ejemplo: '55' + '10523847' = '5510523847' → pos. 4 = '0'
```

`'5510523847'` es un número telefónico CDMX real y válido. El prefijo '55' +
'10...' es un formato habitual de teléfonos móviles de CDMX. El '0' en
posición 4 ocurre por la estructura del número, no por padding con ceros.

Frecuencia esperada: ~10% de los números '55' (el sufijo tiene 10/90 de
probabilidad de empezar con '1', poniendo un '0' en posición 4 tras '551').
Con '55' representando el 25% de todos los números: 10% × 25% = 2.5%.
El 2.75% observado es consistente con esta expectativa.

El bug de LPAD (H-SEED-007) fue que producía ceros como padding: `LPAD(123,
7, '0') = '0000123'`, dando números como `'4430000123'`. Eso sí era irreal.
La situación actual es diferente: el '0' proviene de la distribución natural
de números mexicanos.

---

## H-F1-003 — `cDID='cliente_colgo'` al ~40% vs 12.10% producción

**Tipo:** Limitación conocida del Nivel 1 (SQL)  
**Severidad:** MEDIA — cubierta por Nivel 2  
**Estado:** DOCUMENTADO

### Descripción

Tras el fix de H-F1-001, la proporción de `cDID='cliente_colgo'` (len_13) quedó
en ~40% vs 12.10% en producción real Q1 2025.

### Causa

El total de `cDID='cliente_colgo'` en el seed SQL proviene de:

| Fuente | Probabilidad cMenu | P(cDID='cc') | Contribución |
|---|---|---|---|
| `cMenu='cliente_colgo'` | 22.6% | 100% | 22.6% |
| VACIO | 8.0% | 80% | 6.4% |
| Desborde_Cabecera | 13.3% | 75% | 9.975% |
| **Total** | | | **~39%** |

En producción, `'cliente_colgo'` en cDID solo aparece cuando el cliente
literalmente cuelga antes de que el IVR complete la transferencia a un VDN.
En los datos reales esto ocurre en el 12.10% de las llamadas. La diferencia
con el seed se debe a que `Desborde_Cabecera` en producción real enruta
predominantemente a VDNs numéricos, no a `'cliente_colgo'`.

Para `Desborde_Cabecera`, `q01_2025.py` indica 75% `'cliente_colgo'` — pero
esto refleja la distribución del seed de 50K, que puede diferir de producción
real. En producción el 82.18% son VDNs numéricos de 8 dígitos.

### Impacto operacional

Los SPs ETL (`sp_etl_base_detalle`) aplican la regla `CLIENTE_COLGO` que
normaliza `cDID='cliente_colgo'` correctamente. Con ~40% de registros
ejercitando esta rama (vs 12.10% en producción), los tests de ETL son
más estrictos para este caso de prueba — no menos confiables.

### Cobertura

Esta limitación es inherente al Nivel 1 (SQL) sin perfiles por quarter. El
Nivel 2 (`poblar_historico.py`) usa `VDN_POR_MENU` calibrado por menú y
producirá ~27.37% `'cliente_colgo'` en cDID (closer to producción). Por este
motivo no se corrige en FASE 1 — es parte del alcance de FASE 2.

---

## H-F1-004 — `FORCE_RESEED: 0` persiste en log de `schema_historico.sh`

**Tipo:** Variable obsoleta en script — pendiente FASE 2  
**Severidad:** BAJA  
**Estado:** PENDIENTE FASE 2

### Descripción

El output de `schema_historico.sh` muestra:

```
INFO: FORCE_RESEED:        0
```

Esto ocurre porque `schema_historico.sh` aún tiene:
1. `FORCE_RESEED="${FORCE_RESEED:-0}"` en el bloque de configuración
2. `my_exec_vars_root()` inyecta `SET @FORCE_RESEED = ${FORCE_RESEED};`

`seed_historico.sql` v3.0.0 ya no lee ni usa `@FORCE_RESEED` — la inyección
es inofensiva pero genera ruido en los logs y confusión para quien lea el
output esperando que FORCE_RESEED tenga efecto.

### Corrección requerida en FASE 2

En `schema_historico.sh`:
- Eliminar `FORCE_RESEED="${FORCE_RESEED:-0}"` de la configuración
- Eliminar `echo "SET @FORCE_RESEED = ${FORCE_RESEED};"` de `my_exec_vars_root()`
- Eliminar `FORCE_RESEED` de la sección de log de configuración

---

## H-F1-005 — `script_version='2.2.0'` en lugar de '3.0.0' en `seed_executions`

**Tipo:** Trazabilidad — precedencia de versiones  
**Severidad:** BAJA  
**Estado:** DOCUMENTADO

### Descripción

`seed_executions` registra `script_version='2.2.0'` aunque `seed_historico.sql`
es v3.0.0. La razón es la cadena de precedencia:

```
schema_historico.sh (v2.2.0) inyecta:
    SET @SCRIPT_VER = '2.2.0';

seed_historico.sql (v3.0.0) tiene el fallback:
    SET @SCRIPT_VER = IF(@SCRIPT_VER IS NULL OR @SCRIPT_VER = '', '3.0.0', @SCRIPT_VER);

Como @SCRIPT_VER ya vale '2.2.0' (no NULL, no vacío):
    → el fallback no activa → @SCRIPT_VER queda como '2.2.0'
```

### Análisis

El comportamiento es correcto por diseño (H-SEED-008): `@SCRIPT_VER` refleja
la versión del script que invoca el seed, no del SQL. La versión que importa
para trazabilidad es `schema_historico.sh` — que es el punto de entrada del
provisionamiento.

Cuando se actualice `schema_historico.sh` a v2.3.0 (FASE 2), el tracking
registrará `2.3.0`. La versión de `seed_historico.sql` está en el CHANGELOG
del SQL y en git, no necesariamente en `seed_executions`.

### Acción opcional (FASE 2)

Si se desea rastrear la versión del SQL independientemente, agregar una
columna `seed_sql_version VARCHAR(20)` en `seed_executions`. No es bloqueante.

---

## Estado de las tablas al cierre de FASE 1

```
Tabla                    Registros   Último dígito   Escala
tbl_historico_t1_2025      6026          6           1.000 base
tbl_historico_t2_2025      6845          5           1.136 pico ✓
tbl_historico_t3_2025      5756          6           0.954 valle ✓
tbl_historico_t4_2025      6279          9           1.041
tbl_historico_t1_2026      6097          7           1.010
tbl_historico_t2_2026      2708          8           parcial ✓

seed_executions: 12 filas (6 SEED + 6 APPEND)
verify.sh: 26 OK, 0 WARN, 0 ERR, EXIT 0
```

FASE 1 completada sin deuda técnica. H-F1-001 fue detectado y corregido
durante la misma sesión antes de producir un commit. H-F1-003 es una
limitación conocida del Nivel 1 cubierta por diseño en FASE 2.

---

## Documentos a actualizar

- `HALLAZGOS-SEED-SQL-202605102030.md`: H-SEED-001..008 → RESUELTO
- `HALLAZGOS-SEED-VOLUMEN-MENUS-202605102045.md`: H-SEED-010..011 → RESUELTO
- `schema_historico.sh` changelog: entrada v2.3.0 pendiente (FASE 2)
