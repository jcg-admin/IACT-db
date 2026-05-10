# Hallazgos — Análisis de Stored Procedures y Pipeline ETL

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Análisis solicitado en T-4.4 del plan
`PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md`.  
El plan menciona `CALL sp_rpt_reportes(...)` — SP que no existe. Este
documento identifica el SP correcto, mapea todos los routines del sistema
y explica por qué los SPs de reporte retornan 0 filas con datos en
`tbl_historico_*`.

---

## Hallazgos identificados

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-SP-001 | El plan referencia `sp_rpt_reportes` — SP que no existe | ERROR en documentación | RESUELTO |
| H-SP-002 | Los SPs de reporte leen `base_ivr_*`, no `tbl_historico_*` directamente | Arquitectura — no bug | DOCUMENTADO |
| H-SP-003 | `base_ivr_detalle` y `base_ivr_clientes` tienen 0 registros — ETL no ha corrido | ALTA | PENDIENTE |
| H-SP-004 | `seed_historico_real.sql` referencia `FORCE_RESEED` y `sp_seed_historico_real` — obsoletos en v3.0.0 | MEDIA | PENDIENTE |
| H-SP-005 | `verify.sh` verifica solo 5 de 7 funciones de utilidad | BAJA | DOCUMENTADO |

---

## H-SP-001 — El plan referencia `sp_rpt_reportes` — SP inexistente

**Estado:** RESUELTO (corrección de documentación)

### Descripción

El plan `PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md` en T-4.4 llama:

```bash
CALL sp_rpt_reportes('2025-01-01', '2025-03-31');
```

Este SP **no existe** en `ivr_legacy` ni en ningún archivo SQL del repositorio.
Es un nombre genérico inventado al redactar el plan.

### SP correcto para T-4.4

El SP de orquestación de reportes no existe como tal — los SPs de reporte son
individuales, cada uno orientado a una métrica específica. Para validar que los
datos del seed permiten que el pipeline funcione, el SP correcto es el
**validador post-ETL**:

```sql
-- Verificar que el ETL tiene datos para operar sobre un quarter
CALL sp_etl_validar('Q01_25', @ok, @msg);
SELECT @ok AS etl_listo, @msg AS detalle;
```

Opcionalmente, tras correr el ETL, cualquiera de los 7 SPs de reporte:

```sql
-- SP de reporte de muestra — requiere ETL ejecutado primero
CALL sp_rpt_centros_xsegmento('Q01_25');
CALL sp_rpt_clientes('Q01_25');
```

---

## H-SP-002 — Arquitectura del pipeline: flujo de datos

**Estado:** DOCUMENTADO

### Flujo completo

```
tbl_historico_tN_YYYY          (datos crudos del IVR — seed histórico)
        ↓
sp_etl_base_detalle()          (normaliza y agrega → base_ivr_detalle)
sp_etl_base_clientes()         (cuenta clientes únicos → base_ivr_clientes)
        ↓
base_ivr_detalle               (tabla analítica — fuente de reportes)
base_ivr_clientes              (tabla analítica — fuente de reportes)
        ↓
sp_rpt_centros_transferencia() ─┐
sp_rpt_centros_xsegmento()     ├─ Reportes sobre base_ivr_*
sp_rpt_clientes()              │  (requieren ETL ejecutado)
sp_rpt_cMENU_ERROR()           │
sp_rpt_llamadas_abandonadas()  │
sp_rpt_menu_centro()           │
sp_rpt_menu_redirigidos()      ─┘
```

Los SPs de reporte **no leen `tbl_historico_*` directamente**. Leen
`base_ivr_detalle` y `base_ivr_clientes`, que son las tablas analíticas
pobladas por el ETL. Por eso retornan 0 filas aunque `tbl_historico_*`
tenga 30K+ registros.

### Orquestadores

| SP | Rol | Habilitado |
|---|---|---|
| `sp_etl_maestro()` | ETL diario — lee `job_config` para decidir si corre | `etl_diario` → `is_enabled=1` |
| `sp_etl_historico(p_year, p_quarter_num)` | Wrapper para carga histórica de un quarter | `etl_historico` → `is_enabled=0` |
| `sp_etl_validar(p_quarter, OUT ok, OUT msg)` | Valida post-ETL que las tablas analíticas tienen datos | — |

---

## H-SP-003 — `base_ivr_detalle` y `base_ivr_clientes` vacías

**Severidad:** ALTA  
**Estado:** PENDIENTE

### Descripción

Con 30K+ registros en `tbl_historico_t1_2025` (y equivalentes en los otros
quarters), el ETL no ha corrido — `base_ivr_detalle` tiene 0 registros y
`base_ivr_clientes` tiene 0 registros.

```sql
sp_etl_validar('Q01_25', @ok, @msg):
  ok=0  mensaje="ERROR: base_ivr_detalle vacía para Q01_25.
                  ERROR: base_ivr_clientes tiene 0 filas (esperado: 3)"
```

### Causa

El ETL histórico está desactivado por diseño (`etl_historico.is_enabled=0`).
El ETL diario (`etl_diario.is_enabled=1`) está habilitado pero solo procesa
el quarter actual — no carga los 5 quarters históricos del seed.

Para poblar `base_ivr_*` con los datos del seed histórico se debe invocar
`sp_etl_historico` manualmente para cada quarter:

```sql
-- Cargar los 6 quarters del seed histórico en base_ivr_*
CALL sp_etl_historico(2025, 1);  -- Q01_25
CALL sp_etl_historico(2025, 2);  -- Q02_25
CALL sp_etl_historico(2025, 3);  -- Q03_25
CALL sp_etl_historico(2025, 4);  -- Q04_25
CALL sp_etl_historico(2026, 1);  -- Q01_26
CALL sp_etl_historico(2026, 2);  -- Q02_26 (parcial)
```

### Impacto

Mientras `base_ivr_*` esté vacío, todos los 7 SPs de reporte retornan
0 filas. El pipeline ETL es funcional — simplemente no ha sido invocado.
Esto no es un bug en el seed ni en los SPs: es el orden de operaciones
esperado en el diseño del sistema.

---

## H-SP-004 — `seed_historico_real.sql` referencia `FORCE_RESEED` obsoleto

**Severidad:** MEDIA  
**Estado:** PENDIENTE

### Descripción

`provisioners/mariadb/seed_historico_real.sql` tiene referencias a
`FORCE_RESEED` y al SP `sp_seed_historico_real`, que son incompatibles
con la arquitectura v3.0.0:

```sql
-- Líneas problemáticas en seed_historico_real.sql:
--   @FORCE_RESEED = 0  → SKIP si la tabla ya tiene datos
--   @FORCE_RESEED = 1  → TRUNCATE + re-seed
SET @FORCE_RESEED = IF(@FORCE_RESEED IS NULL, 0, @FORCE_RESEED);
-- SP: sp_seed_historico_real
```

`seed_historico.sql` v3.0.0 eliminó `FORCE_RESEED` y `TRUNCATE` en H-SEED-002.
`seed_historico_real.sql` es un archivo separado que no fue actualizado con las
mismas correcciones — contiene la lógica SKIP/TRUNCATE que fue considerada
deuda técnica.

### Clasificación

`seed_historico_real.sql` fue el predecesor de `poblar_historico.py` — un
intento de SP con datos reales antes de que el enfoque Python fuera adoptado.
El plan v2.0 lo supera completamente:

| Artefacto | Estado | Reemplazado por |
|---|---|---|
| `seed_historico_real.sql` | Obsoleto — FORCE_RESEED, sin escalas | `poblar_historico.py` (Nivel 2) |
| `seed_historico.sql` v2.0 | Obsoleto | `seed_historico.sql` v3.0.0 (Nivel 1) |

### Acción requerida

Decidir si `seed_historico_real.sql` se archiva, elimina o actualiza.
Si se mantiene, debe recibir las mismas correcciones de H-SEED-001..008.
Si se elimina, `schema_historico.sh` no lo referencia — no hay impacto en
el provisionamiento actual.

---

## H-SP-005 — `verify.sh` verifica 5 de 7 funciones de utilidad

**Severidad:** BAJA  
**Estado:** DOCUMENTADO

### Descripción

`funciones_utilidad.sql` define 7 funciones. `verify.sh` verifica solo 5:

| Función | En BD | Verifica verify.sh |
|---|---|---|
| `fn_did_segmento` | SI | SI |
| `fn_normalizar_menu` | SI | SI |
| `fn_normalizar_centro` | SI | SI |
| `fn_duracion_seg` | SI | SI |
| `ivr_es_dia_semana` | SI | SI |
| `ivr_contar_dias_semana` | SI | **NO** |
| `ivr_agregar_dias_semana` | SI | **NO** |

Las dos funciones no verificadas (`ivr_contar_dias_semana` e
`ivr_agregar_dias_semana`) existen en la BD y son utilizadas internamente
por los SPs ETL. Su ausencia en `verify.sh` no impide el provisionamiento
pero sí reduce la cobertura del baseline de verificación.

---

## Inventario completo de routines en `ivr_legacy`

### Funciones de utilidad (`funciones_utilidad.sql`) — 7

| Función | Propósito | Usada por |
|---|---|---|
| `fn_did_segmento(p_did)` | Clasifica DID → NacionalA / NacionalB / Puebla | `sp_etl_base_detalle` |
| `fn_normalizar_menu(p_menu)` | Limpia cMenu: NULL/vacío → NULL, errores → 'ERROR_CMENU' | `sp_etl_base_detalle` |
| `fn_normalizar_centro(p_centro)` | Normaliza NK90 (len>10 → LEFT), CLIENTE_COLGO, NULL | `sp_etl_base_detalle` |
| `fn_duracion_seg(p_ini, p_fin)` | `ABS(TIMESTAMPDIFF(SECOND,...))` — maneja G-29 | `sp_etl_base_detalle` |
| `ivr_es_dia_semana(p_fecha)` | Retorna TRUE si p_fecha es lunes–viernes | `sp_etl_maestro` |
| `ivr_contar_dias_semana(p_ini, p_fin)` | Cuenta días hábiles en un rango | `sp_etl_historico` |
| `ivr_agregar_dias_semana(p_fecha, p_n)` | Suma n días hábiles a p_fecha | `sp_etl_historico` |

### SPs ETL (`sp_etl_pipeline.sql`) — 5

| SP | Parámetros | Propósito |
|---|---|---|
| `sp_etl_base_detalle` | `p_quarter, p_inicio, p_fin, p_table, p_log_id` | Lee `tbl_historico_*`, normaliza, agrega en `base_ivr_detalle` |
| `sp_etl_base_clientes` | `p_quarter, p_inicio, p_fin, p_table, p_log_id` | COUNT DISTINCT de teléfonos únicos → `base_ivr_clientes` |
| `sp_etl_validar` | `p_quarter, OUT ok, OUT msg` | Valida que `base_ivr_*` tiene datos correctos post-ETL |
| `sp_etl_maestro` | _(sin parámetros)_ | Orquestador diario — lee `job_config.etl_diario` |
| `sp_etl_historico` | `p_year INT, p_quarter_num INT` | Wrapper para carga histórica de un quarter |

### SPs de reporte (`sp_rpt_reportes.sql`) — 7

| SP | Parámetros | Propósito |
|---|---|---|
| `sp_rpt_clientes` | `p_quarter` | Clientes únicos por segmento en el quarter |
| `sp_rpt_centros_transferencia` | `p_quarter, p_segmento` | Distribución de VDNs de destino |
| `sp_rpt_centros_xsegmento` | `p_quarter` | VDNs cruzados por segmento DID |
| `sp_rpt_llamadas_abandonadas` | `p_quarter, p_segmento` | Tasa de abandono (cliente_colgo) |
| `sp_rpt_menu_centro` | `p_quarter, p_segmento` | Combinaciones cMenu + VDN |
| `sp_rpt_menu_redirigidos` | `p_quarter, p_segmento` | Menús que redirigen y su destino |
| `sp_rpt_cMENU_ERROR` | `p_quarter, p_segmento` | Registros con teléfono en cMenu (bug IVR) |

---

## Corrección de T-4.4 en el plan

Reemplazar en `PLAN-IMPLEMENTACION-SEED-HISTORICO-202605102000.md`:

```bash
# Antes (incorrecto — SP inexistente):
CALL sp_rpt_reportes('2025-01-01', '2025-03-31');

# Después — verificación correcta en dos pasos:

# Paso A: confirmar que el ETL tiene datos para operar
CALL sp_etl_validar('Q01_25', @ok, @msg);
SELECT @ok AS etl_listo, @msg AS detalle;
# Esperado: ok=0 (base_ivr_* vacía — ETL no ha corrido)
# Esto confirma que tbl_historico_* tiene datos (el seed funcionó)
# pero que el ETL histórico debe ejecutarse para poblar base_ivr_*

# Paso B: ejecutar el ETL histórico y re-validar
CALL sp_etl_historico(2025, 1);
CALL sp_etl_validar('Q01_25', @ok, @msg);
SELECT @ok AS etl_listo, @msg AS detalle;
# Esperado: ok=1 — base_ivr_detalle y base_ivr_clientes con datos

# Paso C: verificar que los SPs de reporte retornan datos
CALL sp_rpt_centros_xsegmento('Q01_25');
CALL sp_rpt_clientes('Q01_25');
# Esperado: filas > 0
```
