# Análisis del reporte clientes_unicos

**Reporte:** `clientes_unicos`
**Archivo de datos:** `docs/referencias/datos-reales/clientes_unicos_Q1Q2Q3_2025.csv`
**Total declarado:** 9,617,998
**Periodo:** Q01_25, Q02_25, Q03_25

---

## Datos del reporte

| Quarter | Segmento | Clientes únicos | Nota |
|---|---|---|---|
| Q01_25 | nacional_B | 3,056,531 | Ver hallazgo H-1 |
| Q01_25 | puebla | 155,507 | |
| Q02_25 | nacional_A | 2,440,333 | |
| Q02_25 | nacional_B | 1,234,307 | |
| Q02_25 | puebla | 266,185 | |
| Q03_25 | nacional_A | 2,296,002 | |
| Q03_25 | nacional_B | 36,756 | Ver hallazgo H-3 |
| Q03_25 | puebla | 132,377 | |

**Totales por quarter:**

| Quarter | Total clientes únicos | Total llamadas (prom_llamadas) | Ratio |
|---|---|---|---|
| Q01_25 | 3,212,038 | 11,643,679 | 3.62 |
| Q02_25 | 3,940,825 | 13,612,375 | 3.45 |
| Q03_25 | 2,465,135 | 8,845,927 | 3.59 |

---

## Hallazgos

### H-1 — nacional_A AUSENTE en Q01_25 (CRÍTICO)

Q01_25 solo tiene `nacional_B` y `puebla`. `nacional_A` (DID 19028031)
no aparece en el reporte de Q01. Q02 y Q03 sí tienen los tres segmentos.

**Causa probable:** el script que generó el reporte Q01 tenía el bug
`@ONacionalB = 19028031` — mismo valor que `@ONacionalA`. La condición
`WHERE cDID_800Transfer IN (@ONacionalA, @ONacionalB)` evaluaba como
`IN (19028031, 19028031)` — un solo DID duplicado. El DID de Nacional A
(19028031) produjo registros etiquetados como `nacional_B`, y el DID
real de Nacional B (19020001) quedó excluido por completo.

Este es exactamente el bug G-30 documentado en `real-db-schema-analysis.md`
y corregido en `q_REPTRIM011_CLIENTES_UNICOS_POR_DID_corregido.sql`.

### H-2 — Q01 `nacional_B` es en realidad `nacional_A` (mislabel confirmado)

**Evidencia por ratio llamadas/clientes:**

| Quarter | Llamadas Nacional | Clientes "nacional_B" Q01 / A Q02-Q03 | Ratio |
|---|---|---|---|
| Q01_25 | 11,126,838 | 3,056,531 (etiquetado como B) | **3.64** |
| Q02_25 | 12,783,030 | 2,440,333 (A) + 1,234,307 (B) = 3,674,640 | **3.48** |
| Q03_25 | 8,422,917 | 2,296,002 (A) + 36,756 (B) = 2,332,758 | **3.61** |

El ratio Q01 (3.64) es perfectamente consistente con Q02 (3.48) y Q03 (3.61)
solo si se asume que el `nacional_B` de Q01 son en realidad clientes de
Nacional A (DID 19028031). El real Nacional B de Q01 no aparece en ningún
lado de este reporte.

**Implicación para `sp_rpt_clientes`:** el SP debe asignar el segmento
basándose en `cDID_800Transfer` con la asignación correcta:

```sql
CASE cDID_800Transfer
    WHEN 19028031 THEN 'nacional_A'
    WHEN 19020001 THEN 'nacional_B'
    WHEN 19020084 THEN 'puebla'
END AS segmento
```

Nunca derivar el segmento de una variable con el bug `@ONacionalB = 19028031`.

### H-3 — Nacional B cae -97% en Q03 (evento operativo)

```
Q02_25 nacional_B:  1,234,307 clientes únicos
Q03_25 nacional_B:     36,756 clientes únicos   → -97%
```

Confirma numéricamente el evento operativo de Nacional B documentado en
BR-MENU-002 y en la diferencia de 2.6M registros entre el Excel y el
reporte `prom_llamadas` en Q3.

Los 36,756 clientes únicos de Q03 Nacional B son residuales. El DID 19020001
prácticamente dejó de recibir tráfico en Q3 2025. No es un error de datos
— los registros existen en `tbl_historico_t3_2025` y deben procesarse
normalmente en el ETL.

### H-4 — Convención de segmento en lowercase

Este reporte usa `nacional_a`, `nacional_b`, `puebla` en minúsculas.
El reporte `prom_llamadas` usa `Nacional` (A+B combinados), `Puebla`.

La convención documentada en `ETL-ANALISIS.md` para `base_ivr_detalle` es
`'nacional_A'`, `'nacional_B'`, `'Puebla'`. Los SPs de reporte deben
ser consistentes con esta convención interna, independientemente de cómo
el script de producción etiquete los segmentos.

### H-5 — Definición de clientes únicos: probable `cTelefono_Origen`

Los ratios llamadas/cliente (~3.5) son consistentes con
`COUNT(DISTINCT cTelefono_Origen)` — el ANI, siempre presente en todos
los registros.

`BR-CLIENT-001` documentó `COUNT(DISTINCT cTelefono_Digitado)`, pero con
21.2% de registros con `cTelefono_Digitado IS NULL`, ese conteo excluiría
clientes que nunca digitaron su número. Si usáramos `cTelefono_Digitado`,
el ratio sería mayor (~4.5 estimado) porque se excluye el 21% de NULLs.

| Escenario | Clientes únicos estimados Q02 | Ratio |
|---|---|---|
| `COUNT(DISTINCT cTelefono_Origen)` | ~3.67M | 3.5 ✓ (coincide) |
| `COUNT(DISTINCT cTelefono_Digitado)` | ~2.9M | 4.4 (no coincide) |

**Pendiente P-NEW-04:** confirmar con el equipo cuál es la columna
fuente del conteo. Define el DDL de `base_ivr_clientes`.

---

## Impacto en el diseño de SPs

### `sp_rpt_clientes`

```sql
-- Diseño correcto basado en este análisis
SELECT
    q.quarter_name                        AS trimestre,
    CASE c.cDID_800Transfer
        WHEN 19028031 THEN 'nacional_A'
        WHEN 19020001 THEN 'nacional_B'
        WHEN 19020084 THEN 'puebla'
    END                                   AS segmento,
    COUNT(DISTINCT c.cTelefono_Origen)    AS clientes_unicos
    -- NOTA: pendiente P-NEW-04 si debe ser cTelefono_Digitado
FROM base_ivr_clientes c
WHERE c.quarter_name = p_quarter
GROUP BY segmento;
```

### `sp_etl_base_clientes`

Debe procesar los tres DIDs en todos los quarters, incluyendo Nacional B
en Q01 (que el reporte histórico omitió por el bug). El ETL no debe
reproducir el error `@ONacionalB = 19028031`.

---

## Pendientes abiertos

| ID | Pregunta | Prioridad |
|---|---|---|
| P-NEW-04 | ¿`clientes_unicos` = `COUNT(DISTINCT cTelefono_Origen)` o `cTelefono_Digitado`? | Alta |
| P-NEW-05 | Confirmar con equipo: ¿Q01 `nacional_B` es mislabel de nacional_A? | Alta |
| P-NEW-06 | ¿Existe el dato real de Q01 `nacional_B` (DID 19020001) en algún reporte? | Media |

---

## Ver también

- `TBL-HISTORICO-ANOMALIAS.md` — anomalías en los datos fuente
- `ETL-ANALISIS.md` — diseño del ETL y base_ivr_clientes
- `REPORTE-PROM-LLAMADAS.md` — análisis del reporte prom_llamadas
- `scripts-sql/corregidos/q_REPTRIM011_CLIENTES_UNICOS_POR_DID_corregido.sql`
- `datos-reales/clientes_unicos_Q1Q2Q3_2025.csv`

