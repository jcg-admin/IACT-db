# Distribución de menús y opciones — Q1 2025

**Fuente:** Resultado de comparación NULLIF vs detalle sobre datos de Q1 2025
**Total registros confirmado:** 1,929,079
**Nota:** Este total es un subconjunto del Q1 completo (11.6M registros).
El subconjunto corresponde probablemente a un segmento específico (Puebla
o Nacional A) o a un rango de fechas acotado.

---

## Archivos

| Archivo | Descripción |
|---|---|
| `menu_totales_por_menu.csv` | 39 menús con total por menú y opción más frecuente |
| `menu_opcion_detalle.csv` | 126 combinaciones menu×opción — el grain de `base_ivr_detalle` |

---

## Estructura del resultado original

El resultado contenía tres paneles lado a lado comparando dos enfoques
de normalización (NULLIF vs raw):

**Panel izquierdo (NULLIF):** Un registro por menú mostrando el total
de llamadas del menú completo y la opción más frecuente como referencia.
Equivale a `GROUP BY menu`.

**Panel derecho (detalle):** Un registro por combinación (menu, opcion),
que es el grain real de `base_ivr_detalle`. Las opciones vacías de
abandono aparecen sin 'SIN_OPCION' — son NULL en el origen.

---

## Distribución por categoría

| Categoría | Llamadas | % |
|---|---|---|
| **Abandono** (SIN_MENU + cliente_colgo + SinOpcion_Cabecera + Marque3) | **675,475** | **35.0%** |
| Fallas (9 variantes) | 387,614 | 20.1% |
| Desborde (Cabecera + Promocional) | 316,646 | 16.4% |
| NOTMX (seguimiento + contratación) | 272,762 | 14.1% |
| Saldos y Pagos (3 variantes) | 106,971 | 5.5% |
| MADT + Entr + Otros servicios | 150,356 | 7.8% |
| Cambios (CambioDom + Cambios + CambioTit) | 19,255 | 1.0% |

---

## Hallazgos del dataset detallado

### 1. Abandono confirma 35% con la definición correcta (D-ETL-006)

```
cliente_colgo:      422,864 (22.0%)
SIN_MENU:           152,159 ( 7.9%)  ← equivalent a 'VACIO' en base_ivr_detalle
SinOpcion_Cabecera:  61,688 ( 3.2%)
Marque3:             38,764 ( 2.0%)
TOTAL ABANDONO:     675,475 (35.0%)
```

`Marque3` es una categoría de abandono confirmada — aparece con opción
vacía, sin etiqueta, con 38,764 llamadas. No estaba en los 3 tipos de
abandono documentados en D-ETL-006 (VACIO + cliente_colgo + SinOpcion_Cabecera).
**Confirmar con el equipo si Marque3 debe incluirse en la tasa de abandono.**

### 2. Desborde_Cabecera: 32 etiquetas distintas (253,576 llamadas)

El 50.3% de Desborde_Cabecera son quejas (etiquetas QJA_*):

| Grupo | Etiquetas | Llamadas |
|---|---|---|
| Quejas (QJA_*) | QJA_AB_DAT_1, QJA_AB_2, QJA_AB_3, QJA_AB_VOZ_*, QJA_AB_VSI_*, QJA_ACAPULCO | 127,537 |
| Cobranza (TELVICOBRA/TELECOBRA) | TELVICOBRA, TELECOBRA | 71,849 |
| Ecatepec | ECATEPEC, ECATEPEC_FM, ECATEPEC_QJA, ECATEPEC_PORTA | 36,569 |
| Adeudos (MES_1, MES_2) | MES_1, MES_2 | 9,617 |
| Migración (MIGRAFTTH) | MIGRAFTTH | 788 |
| Otros | ANALAMCAN, SABIVALLE, BUSTAVILLAL, RETCOMBO, etc. | 7,216 |

### 3. RES-FallaInternet: 17 opciones de diagnóstico (267,271 llamadas)

La opción `DEFAULT` domina (213,601 — 79.9%), pero las opciones de
diagnóstico automático tienen volumen significativo:

```
NOBOT:                    19,075  (7.1%)  — llamadas filtradas por bot
POSIBLE_FALLA_DSLAM_P:    17,348  (6.5%)  — diagnóstico automático DSLAM
FM_CFE_P:                  1,761  (0.7%)  — falla por CFE (corte de luz)
FM_ROBO_P:                 1,731  (0.6%)  — falla por robo
FALLA_AMBAS_P:             1,299  (0.5%)  — falla en ambos servicios
ADEUDO22222:               5,181  (1.9%)  — cliente con adeudo
CECOR:                     4,343  (1.6%)  — zona CECOR
```

La etiqueta que aparece en el panel izquierdo como "más frecuente" es
`POSIBLE_FALLA_DSLAM_P` — esto es incorrecto (DEFAULT tiene 12x más).
El panel izquierdo muestra la opción del último registro, no la más frecuente.

### 4. Menús nuevos no documentados anteriormente

- `RES-Falla-Dish` (298 llamadas) — falla de servicio DISH
- `RES-TAE` (53 llamadas) — Tiempo Aire/TAE
- `RES-Saldos-WT` (17,118 llamadas) — variante de saldos (wire transfer?)
- `RES_OcultaVta` (60 llamadas) — venta ocultada
- `RES-SaldooPagos` (82,753 llamadas) — nótese la doble 'o' vs `RES-SaldosPagos_2024`

### 5. Opciones recurrentes que funcionan como segmentadores

Las mismas opciones aparecen en múltiples menús, indicando que son
etiquetas de gestión (no opciones del IVR) aplicadas transversalmente:

| Opción | Menús donde aparece | Función |
|---|---|---|
| `DEFAULT` | 33 menús | Sin segmentación especial |
| `2L` | RES-Entr, RES-ContratacionInfinitum, RES-MADT-Detalle, RES_CambioDom, RES_Cambios, RES_CambioTit, RES_Otros | Segunda línea de atención |
| `CECOR` | RES-FallasLinea, RES-ContratacionInfinitum, RES-MADT-Detalle, RES-SegurosInbursa, RES_CambioDom, RES_Cambios, RES_CambioTit, RES_Otros | Centro CECOR |
| `NOBOT` | RES-FallaInternet, RES-Entr, RES-FallaEntretiene | Filtro anti-bot |
| `PQ_389` | RES-ContratacionInfinitum, RES-MADT-Detalle | Paquete/promoción 389 |

### 6. Opciones vacías en abandono y desborde

En el panel de detalle (panel derecho), `cliente_colgo`, `Desborde_Promocional`,
`Marque3` y `SinOpcion_Cabecera` tienen opción vacía (NULL en fuente).
El panel izquierdo (NULLIF) las muestra como `'SIN_OPCION'`.

**Para el ETL:** el SP `sp_etl_base_detalle` debe normalizar estas a
`'SIN_OPCION'` usando `COALESCE(NULLIF(TRIM(cOpcion),''), 'SIN_OPCION')`.
La columna `opcion` en `base_ivr_detalle` nunca debe tener NULL.

---

## 55 opciones/etiquetas únicas identificadas

```
2L, ACUNA, ADEUDO22222, ADEUDO_1Y2, ANALAMCAN, BLACKLIST, BUSTAVILLAL,
CASE_41, CASOSDG, CECOR, CLIENTESAPP, COD_SUSP_7, DEFAULT, DG,
ECATEPEC, ECATEPEC_FM, ECATEPEC_PORTA, ECATEPEC_QJA, ERMITAT,
FALLA_AMBAS_P, FALLA_CENTRAL_P, FM, FM_CFE_P, FM_NATURAL_P, FM_ROBO_P,
INCLUENCER, LAREDO, MEGACABLE, MES_1, MES_2, MIGRAFTTH, ML, NOBOT,
ONT_ECANCELA, POSIBLE_FALLA_DSLAM_P, POT_A_VSI_TDM, PQ_389,
QJA_AB_1, QJA_AB_2, QJA_AB_3, QJA_AB_DAT_1, QJA_AB_DAT_2,
QJA_AB_VOZ_1, QJA_AB_VOZ_2, QJA_AB_VSI_1, QJA_AB_VSI_2, QJA_ACAPULCO,
RETARGETING, RETCOMBO, SABIVALLE, SIN_OPCION, SUS_COM, TELECOBRA,
TELVICOBRA, VSI
```

