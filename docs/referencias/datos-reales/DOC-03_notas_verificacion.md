# DOC-03 — Notas de verificación y correcciones

**Documento:** DOC-03 Catálogo de Centros de Transferencia (17/10/2025)
**Verificado contra:** DID_Centro_Transferencia_v0.3.1.csv (datos reales Excel)

---

## Estado de verificación

Todos los volúmenes de los 15 centros principales del DOC-03 fueron
verificados contra el CSV de producción. **Coincidencia exacta al 100%
en todos los casos.** El DOC-03 es una fuente confiable.

---

## Correcciones y discrepancias identificadas

### 1. Nombres de sentinels — usar el estándar del ETL

El DOC-03 propone nombres distintos a los ya establecidos en el diseño
del ETL (`etl-job-flow-design.md`). Los nombres canónicos son los del ETL:

| Condición | DOC-03 propone | Nombre canónico ETL | Estado |
|---|---|---|---|
| NULL o vacío | `'SIN_CENTRO'` | **`'CASO_NULL'`** | Usar ETL |
| Solo ceros | `'ERROR_REGISTRO'` | **`'CASO_ERROR_CEROS'`** | Usar ETL |
| Carácter inicial no numérico | `'ERROR_FORMATO'` | **`'ERROR_CARACTER_INICIAL'`** | Usar ETL |
| `'cliente_colgo'` | `'CLIENTE_COLGO'` | **`'CLIENTE_COLGO'`** | Coincide |

Los nombres canónicos del ETL están documentados en `ETL-ANALISIS.md` y
en los scripts de referencia analizados. No se deben cambiar.

### 2. Centro 19020088 — es Nacional, no Puebla

El DOC-03 lo clasifica como "Centro regional Puebla" pero los datos reales
muestran que es mayoritariamente Nacional:

```
Q02_25: Nacional 721,520 / Puebla 25,655  (96.6% Nacional)
Q03_25: Nacional 1,115,730 / Puebla 31,623 (97.2% Nacional)
```

El volumen de Puebla (~2.8-3.4%) puede ser ruido o un pequeño overlap.
Tratar 19020088 como centro **Nacional** en los reportes.

### 3. Centro 309004 — es el VDN post-normalización de un NK90

El DOC-03 lo lista con 917,315 llamadas como "Centro operativo". Este
VDN de 6 dígitos corresponde al caso `CONFIGURACION_FIJA_6_DIG` de la
clasificación de longitudes. Solo hay 6 registros con longitud exactamente
6 en el análisis de clasificación (dataset 1), pero en el CSV consolidado
suma 917K — esto sugiere que muchos registros de mayor longitud se
normalizan a `309004` por la regla NK90 (`LEFT(campo, LENGTH - 10)`).

### 4. Centros mencionados en DOC-03 sin datos en el CSV

Los siguientes centros aparecen en el DOC-03 pero no se verificaron
en el CSV de producción (pueden existir en combinaciones no incluidas):

- `19020087` — "Centro regional" (~220K según DOC-03)
- `10828093` — "Centro de atención" (~280K según DOC-03)
- `10928254` — "Centro de atención" (~200K según DOC-03)

### 5. Descripción de 10928253 — menú principal es Desborde + RES-FallaSegQja

El DOC-03 asocia 10928253 con `RES_FALLA_STOP`. Los datos del CSV de
detalle muestran que sus menús son `Desborde_Cabecera` y `RES-FallaSegQja`
(ver `centros_transferencia_detalle.csv`). `RES_FALLA_STOP` no aparece
vinculado a este centro en el período Q1 analizado.

---

## Información nueva aportada por DOC-03

### Series de VDN identificadas

El DOC-03 identifica patrones en los prefijos de los VDNs:

| Prefijo | Tipo inferido |
|---|---|
| `190xxxxx` | Centros nacionales/regionales principales |
| `108xxxxx` | Atención general |
| `109xxxxx` | Soporte técnico |
| `150xxxxx` | Soporte especializado |
| `144xxxxx` | Servicios específicos |
| `309xxx` / `1309xxx` | Centros operativos |

### Confirmación de volúmenes históricos (Q1-Q3 2025)

| Centro | Q1 | Q2 | Q3 | Tendencia |
|---|---|---|---|---|
| 19020086 | ~3.6M | ~4.1M | ~3.2M | Estable |
| CLIENTE_COLGO | ~1.4M | ~1.8M | ~1.5M | Incremento leve |
| 19010000 | ~1.0M | ~1.3M | ~1.4M | Crecimiento |
| 10828091 | ~1.2M | ~0.8M | ~0.4M | Descenso |

### 50+ centros únicos confirmados

El DOC-03 extiende el análisis previo de 63 centros (Q1 solo) a la vista
multi-quarter Q1-Q3 con 96 VDNs en el catálogo de la Hoja2.

---

## Uso recomendado de este documento en el proyecto

El DOC-03 es la fuente más completa y validada del catálogo de centros.
Reemplaza las estimaciones previas y debe ser la referencia principal para:

- Definir los valores de prueba de `sp_rpt_centros_transferencia`
- Poblar el seed de `base_ivr_detalle` con centros reales
- Validar los resultados del ETL contra los totales por trimestre
- Diseñar los filtros del UC-019 (Consultar Transferencias por Centro)

**No usar** los nombres de sentinels del DOC-03 — usar los del ETL.

