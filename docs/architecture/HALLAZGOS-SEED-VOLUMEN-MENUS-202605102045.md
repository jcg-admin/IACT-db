# Hallazgos adicionales — Volumen, menús e identificadores del seed SQL

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Hallazgos adicionales identificados en el análisis de
`seed_historico.sql` vs `poblar_historico.py` y los perfiles de quarter.  
**Complementa:** `HALLAZGOS-SEED-SQL-202605102030.md`

---

## Resumen ejecutivo

| ID | Hallazgo | Severidad | Estado |
|---|---|---|---|
| H-SEED-010 | Todas las tablas tienen exactamente 3000 filas — irreal | ALTA | PENDIENTE |
| H-SEED-011 | Sin escala por quarter — todos los quarters son iguales en volumen | ALTA | PENDIENTE |
| H-SEED-012 | Los menús del SQL no son los menús reales del IVR | CRÍTICA | PENDIENTE |
| H-SEED-013 | Solo 6 VDNs en el SQL vs 28+ reales en Q01 solo | CRÍTICA | PENDIENTE |
| H-SEED-014 | Los menús cambian por quarter — el SQL usa el mismo catálogo para los 6 | ALTA | PENDIENTE |
| H-SEED-015 | `poblar_historico.py` ya implementa todo correctamente — el SQL es duplicación incorrecta | Arquitectura | DOCUMENTADO |

---

## H-SEED-010 — Todas las tablas tienen exactamente 3000 filas

**Severidad:** ALTA  
**Estado:** PENDIENTE

### Estado actual

```
tbl_historico_t1_2025:  3000  (Q1 2025)
tbl_historico_t2_2025:  3000  (Q2 2025)
tbl_historico_t3_2025:  3000  (Q3 2025)
tbl_historico_t4_2025:  3000  (Q4 2025)
tbl_historico_t1_2026:  3000  (Q1 2026)
tbl_historico_t2_2026:  1186  (Q2 2026 — parcial, este sí varía)
```

Cinco tablas terminan exactamente en el mismo número: 3000.

### Por qué es irreal

El sistema IVR del cliente procesa millones de llamadas diarias. El volumen
nunca es un número redondo ni idéntico entre quarters. El documento
`SUPUESTOS-VOLUMENES_2026-05-07T154105.md` documenta esto explícitamente:

> "Los valores de 1,000,000 y 1,069,000 son artificialmente redondos.
> En producción los volúmenes nunca son múltiplos exactos de 1,000.
> Se repoblaron Q01_25 y Q04_25 con valores irregulares."

### Volúmenes reales/supuestos documentados

| Quarter | Tabla | Filas reales/supuestas | Último dígito | Fuente |
|---|---|---|---|---|
| Q01_25 | tbl_historico_t1_2025 | 1,031,847 | 7 | REAL |
| Q02_25 | tbl_historico_t2_2025 | 1,172,834 | 4 | REAL — pico del año |
| Q03_25 | tbl_historico_t3_2025 | 983,741 | 1 | REAL |
| Q04_25 | tbl_historico_t4_2025 | 1,074,193 | 3 | SUPUESTO (fin de año) |
| Q01_26 | tbl_historico_t1_2026 | 1,041,623 | 3 | SUPUESTO (crecimiento YoY) |
| Q02_26 | tbl_historico_t2_2026 | 487,918 | 8 | SUPUESTO parcial (36/91 días) |

En el sandbox de desarrollo con `SEED_ROWS=3000`, las proporciones deben
respetarse. Si la base es 3000 rows para Q01_25 (escala 1.000), entonces:

| Quarter | Escala | Rows proporcionales | Redondeado | Último dígito |
|---|---|---|---|---|
| Q01_25 | 1.000 | 3000.0 | 3001* | 1 |
| Q02_25 | 1.136 | 3408.0 | 3413* | 3 |
| Q03_25 | 0.954 | 2862.0 | 2857* | 7 |
| Q04_25 | 1.041 | 3123.0 | 3119* | 9 |
| Q01_26 | 1.010 | 3030.0 | 3027* | 7 |
| Q02_26 | 0.473 | 1419.0 | 1186** | 6 |

\* Agregar un offset aleatorio ±[3..17] para que no termine en cero.  
\*\* Q02_26 ya tiene 1186 — correcto porque usa la proporción de días.

### Impacto

Con volúmenes idénticos, el ETL siempre procesa la misma cantidad de datos
por quarter. No revela problemas de escalabilidad ni de variación de carga,
que son críticos para la validación del pipeline.

---

## H-SEED-011 — Sin escala por quarter — todos iguales en volumen

**Severidad:** ALTA  
**Estado:** PENDIENTE

### Descripción

El SQL usa `@SEED_ROWS` como cantidad fija para todos los quarters:

```sql
CALL sp_seed_historico('tbl_historico_t1_2025', ..., @SEED_ROWS, ...);
CALL sp_seed_historico('tbl_historico_t2_2025', ..., @SEED_ROWS, ...);
CALL sp_seed_historico('tbl_historico_t3_2025', ..., @SEED_ROWS, ...);
CALL sp_seed_historico('tbl_historico_t4_2025', ..., @SEED_ROWS, ...);
CALL sp_seed_historico('tbl_historico_t1_2026', ..., @SEED_ROWS, ...);
```

Solo Q02_26 tiene escala:
```sql
SET @SEED_ROWS_PARCIAL = GREATEST(500, FLOOR(@SEED_ROWS * 36 / 91));
```

### Corrección requerida

Definir `@SEED_ROWS_Qnn` para cada quarter con la escala correspondiente
y un offset aleatorio para evitar terminaciones en cero:

```sql
-- Base Q01_25 = @SEED_ROWS (1.000)
-- Offset aleatorio para evitar múltiplos exactos
SET @SEED_ROWS_Q01_25 = @SEED_ROWS + FLOOR(RAND() * 15) + 3;
SET @SEED_ROWS_Q02_25 = FLOOR(@SEED_ROWS * 1.136) + FLOOR(RAND() * 15) + 3;
SET @SEED_ROWS_Q03_25 = FLOOR(@SEED_ROWS * 0.954) + FLOOR(RAND() * 15) + 3;
SET @SEED_ROWS_Q04_25 = FLOOR(@SEED_ROWS * 1.041) + FLOOR(RAND() * 15) + 3;
SET @SEED_ROWS_Q01_26 = FLOOR(@SEED_ROWS * 1.010) + FLOOR(RAND() * 15) + 3;
SET @SEED_ROWS_Q02_26 = GREATEST(500,
    FLOOR(@SEED_ROWS * 1.136 * 36 / 91) + FLOOR(RAND() * 10) + 3);
```

El `FLOOR(RAND() * 15) + 3` garantiza un offset en `[3..18]` — nunca cero,
nunca idéntico entre ejecuciones.

---

## H-SEED-012 — Los menús del SQL no son los menús reales del IVR

**Severidad:** CRÍTICA  
**Estado:** PENDIENTE

### Comparativa

El SQL usa menús genéricos que NO existen en los datos reales del cliente:

| Menú en SQL | ¿Existe en datos reales? |
|---|---|
| `Saldo` | NO — el real es `RES-SaldooPagos` |
| `Pagos` | NO — el real es `RES-SaldooPagos` |
| `Atencion` | NO — no existe en ningún quarter |
| `Transferencia` | NO — no existe |
| `Informacion` | NO — no existe |
| `ReclamacionesTecnicas` | NO — el real es `RES-FallasLinea`, `RES-FallaInternet` |
| `BajasModificaciones` | NO — no existe |
| `ConsultaFactura` | NO — no existe |
| `SolicitudProducto` | NO — no existe |

### Menús reales de Q01_2025 (39 menús en total)

```
Abandono:      cliente_colgo, NULL/VACIO, SinOpcion_Cabecera, Marque3
Desborde:      Desborde_Cabecera, Desborde_Promocional
Fallas:        RES-FallaInternet, RES-FallasLinea, RES-Fallas_2024,
               RES-FallaInternet_2024, RES-FallaEntretiene, RES-FallaSegQja
NOTMX:         NOTMX-SeguimientoInstalacion, NOTMX-CONT-Contratacion,
               NOTMX-CONT-Portabilidad, RES-SegInst_2024
Saldos:        RES-SaldooPagos, RES-SaldosPagos_2024, RES-Saldos-WT
MADT/Entr:     RES-MADT-Detalle, RES-Entr, RES-MADT-MVSHUB
Contratacion:  RES-ContratacionInfinitum_2024, RES-ContratacionInfinitum
Cambios:       RES_CambioDom, RES_Cambios, RES_CambioTit
Error:         __CMENU_ERROR__ (teléfono en cMenu — 1.2%)
Cola larga:    RES_Otros, RES-AsistenciaTelmexcom, RES-Aparatos,
               RES-DISH, RES-SegurosInbursa, RES-TAE, RES_OcultaVta,
               RES-Falla-AntivirusMcAfee, RES-Falla-Dish, RES-Falla-MVSHUB,
               RES-ClaroDrive, RES-StartGo, default
```

### Impacto

Los SPs `sp_etl_base_detalle` y `sp_rpt_cMENU_ERROR` aplican reglas de
normalización sobre los valores reales de `cMenu`. Si el seed genera menús
que no existen en producción, las reglas de normalización nunca se ejercitan
con los valores correctos — los tests pasan pero el ETL falla en producción.

---

## H-SEED-013 — Solo 6 VDNs en el SQL vs 28+ reales en Q01 solo

**Severidad:** CRÍTICA  
**Estado:** PENDIENTE

### VDNs en el seed SQL actual

```
1309004, 15070013, 2309004, 1205003, 1408002, 1705001
```

### VDNs reales en Q01_2025 (28 distintos)

```
10228051, 10628002, 10728000, 10728009, 10728382, 10728485, 10728487,
10728493, 10728494, 10828073, 10828091, 10928137, 10928253, 1309004,
1309010, 14928960, 14929014, 15070002, 15070004, 15070006, 15070007,
15070013, 15070019, 15070059, 15070071, 19010000, 19020033, 19020086
```

Además los VDNs en formato NK90 (concatenación VDN + teléfono):
`[VDN][cTelefono_Digitado]` — e.g., `'10728487' + '4432278142'` = `'107284874432278142'`

### VDNs del SQL que SÍ existen en datos reales

De los 6 VDNs del SQL, solo `1309004` y `15070013` están confirmados en
Q01_2025. Los otros 4 no aparecen en el catálogo real de Q01.

### Impacto

`sp_rpt_centros_xsegmento` y `sp_rpt_centros_transferencia` agrupan por VDN
normalizado. Con solo 6 VDNs, los reportes no reflejan la distribución real
de destinos y los tests de los SPs no cubren la variedad real.

---

## H-SEED-014 — Los menús cambian por quarter — el SQL usa el mismo catálogo para los 6

**Severidad:** ALTA  
**Estado:** PENDIENTE

### Evolución real del catálogo de menús

| Quarter | Menús totales | Menús nuevos vs anterior | Menús que desaparecen |
|---|---|---|---|
| Q01_25 | 39 | — | — |
| Q02_25 | 46 | 8 nuevos: `Numero Telmex`, `ANI`, `RES-SaldosPagos_FM`, `RES-ContratacionInfinitum_FM`, `RES_FALLA_STOP`, `Tmx_SOMO`, `MASI_RepiteBoleta`, `NoTMX_SinOp` | `RES-FallaInternet_2024` |
| Q03_25 | 51 | 5 nuevos: `KIPSOLCOM`, `SaldoCabecera`, `Saldos1_Pagar`, `Saldos3_Otra`, `MenuSaldosCabecera` | — |
| Q04_25 | 51 | (proxy Q03) | — |
| Q01_26 | 39 | (proxy Q01_25) | — |
| Q02_26 | 46 | (proxy Q02_25, parcial) | — |

### Descripción

El IVR del cliente agrega nuevas opciones de menú con cada quarter. Por
ejemplo, en Q02_2025 aparecen `Numero Telmex` y `ANI` (Puebla), y
`RES_FALLA_STOP`, `RES-SaldosPagos_FM` (Nacional). Estos menús no existían
en Q01.

El seed SQL usa exactamente los mismos 13 menús para todos los quarters, lo
que produce datos históricamente incoherentes: `MASI_RepiteBoleta` aparecería
en Q01_2025 aunque solo existe desde Q02_2025.

---

## H-SEED-015 — `poblar_historico.py` ya implementa todo correctamente

**Severidad:** Arquitectónica  
**Estado:** DOCUMENTADO

### Descripción

`poblar_historico.py` con los perfiles `perfiles/q01_2025.py` ..
`perfiles/q03_2025.py` ya tiene implementado todo lo que falta en el SQL:

| Requisito | `poblar_historico.py` | `seed_historico.sql` |
|---|---|---|
| Menús reales del IVR | 39–51 menús reales por quarter | 13 menús genéricos incorrectos |
| VDNs por menú | 28+ VDNs reales por quarter, asignados por menú | 6 VDNs genéricos sin relación menú-VDN |
| Volumen con escala por quarter | Sí, con escalas 0.473–1.136 | No — todos con `@SEED_ROWS` |
| Números no redondos | Sí (offset aleatorio) | No — múltiplos exactos de SEED_ROWS |
| G-29 calibrado | `P_HORAS_INVERTIDAS = 0.388` | 0.003 (100× menos) |
| Distribución teléfonos calibrada | `P_NULL=0.212`, `P_MISMA=0.282` | Descalibrado |
| Evolución por quarter | Perfiles heredan y sobreescriben | Sin perfiles |
| Menús con variación temporal | Q02 agrega 8, Q03 agrega 5 | Sin variación |
| Validación estadística integrada | Sí — verifica ±1.5pp | No |
| Incremental (no SKIP) | Opcionalmente con `--append` | SKIP (bug) |

### Conclusión arquitectónica

El seed SQL es una reimplementación paralela incompleta y con datos incorrectos
de lo que `poblar_historico.py` ya hace bien. El camino correcto es uno de:

**Opción A — Integrar `poblar_historico.py` en el provisioner:**
`schema_historico.sh` llama a `python3 poblar_historico.py` en lugar de
ejecutar `seed_historico.sql`. Requiere Python 3 en el entorno de provisioning.

**Opción B — Reescribir `seed_historico.sql` usando los perfiles como fuente:**
Reescribir el SP con los menús, VDNs, escalas y calibraciones de `perfiles/*.py`.
Es un trabajo significativo y crea un segundo punto de verdad que puede
desincronizarse con `poblar_historico.py`.

**Opción A es la correcta** por separación de dominios: `poblar_historico.py`
es la fuente de verdad del seed. El provisioner debe invocarlo, no duplicarlo.

---

## Inventario de brechas consolidado

Combinando este documento con `HALLAZGOS-SEED-SQL-202605102030.md`:

| Brecha | Corrección en SQL | Corrección en Python | Complejidad |
|---|---|---|---|
| SKIP → APPEND incremental | Cambiar IF en SP | `--append` flag | Baja en ambos |
| Eliminar TRUNCATE | Remover p_force | Mantener `--truncate` | Baja |
| G-29: 0.3% → 38.8% | Cambiar probabilidad | Ya correcto | Baja en SQL |
| cMenu='cliente_colgo': 52% → 22% | Ajustar umbral | Ya correcto | Baja en SQL |
| Distribución tel_digitado | Ajustar umbrales | Ya correcto | Baja en SQL |
| LPAD → rango sin ceros | Cambiar fórmula | `zfill` (mismo bug potencial) | Baja en SQL |
| 13 menús genéricos → 39 reales | Reescritura completa del SP | Ya correcto | MUY ALTA en SQL |
| 6 VDNs → 28+ reales | Reescritura completa | Ya correcto | MUY ALTA en SQL |
| VDNs por menú | Reescritura completa | Ya correcto | MUY ALTA en SQL |
| Escalas por quarter | Agregar @SEED_ROWS_Qnn | Ya correcto | Media en SQL |
| Volúmenes no redondos | Agregar offset aleatorio | Ya correcto | Baja en SQL |
| Evolución por quarter (46, 51 menús) | Imposible en SP único | Ya correcto | IMPOSIBLE en SQL |

### Veredicto

Los primeros 6 problemas son corregibles en SQL con esfuerzo moderado.
Los últimos 6 — especialmente la evolución por quarter — son prácticamente
imposibles de implementar correctamente en un stored procedure de MariaDB
sin replicar toda la lógica de `poblar_historico.py`.

**La solución correcta es invocar `poblar_historico.py` desde
`schema_historico.sh`** en lugar de mantener dos implementaciones divergentes.
