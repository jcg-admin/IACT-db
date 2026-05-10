# Análisis del reporte llamadas_cmenu

**Reporte:** `llamadas_cmenu`
**Archivo de datos:** `docs/referencias/datos-reales/llamadas_cmenu_Q1Q2Q3_2025.csv`
**Total declarado:** 34,101,981
**Periodo:** Q01_25, Q02_25, Q03_25

---

## Descripción

Total de llamadas por segmento, quarter y menú. Es el equivalente de
`prom_llamadas` sin la métrica de promedio — solo `total_llamadas`.
Los totales por quarter y segmento son idénticos entre ambos reportes,
confirmando que comparten la misma fuente y lógica de extracción.

---

## Hallazgos

### H-1 — Filas duplicadas para Nacional en Q02 y Q03 (CRÍTICO)

El reporte presenta **dos bloques de filas `Nacional`** para Q02_25 y Q03_25.
Ambos bloques tienen la misma etiqueta `Nacional` en `cDID_800Transfer`
pero contienen datos de DIDs distintos.

**Causa:** el SP que genera este reporte hace `GROUP BY cDID_800Transfer`
sobre el valor numérico, pero en la columna de salida aplica el `CASE`
que convierte ambos DIDs de Nacional (`19028031` y `19020001`) a la misma
etiqueta `'Nacional'`. El resultado son dos grupos con la misma etiqueta
pero volúmenes distintos.

```
Q02_25 Nacional primer bloque  → DID 19020001 (nacional_B)  3,835,166 llamadas
Q02_25 Nacional segundo bloque → DID 19028031 (nacional_A)  8,947,864 llamadas
─────────────────────────────────────────────────────────────────────────────
Q02_25 Nacional total combinado                             12,783,030 llamadas ✓
```

**Identificación de bloques** por volumen relativo y ratios:

| Quarter | Bloque | Llamadas | Clientes (de clientes_unicos) | Ratio |
|---|---|---|---|---|
| Q02_25 | Nacional_B (primer) | 3,835,166 | 1,234,307 | 3.11 |
| Q02_25 | Nacional_A (segundo) | 8,947,864 | 2,440,333 | 3.67 |
| Q03_25 | Nacional_B (primer) | 108,311 | 36,756 | 2.95 |
| Q03_25 | Nacional_A (segundo) | 8,314,606 | 2,296,002 | 3.62 |

Los ratios son consistentes con los de `prom_llamadas` (~3.1-3.7), confirmando
la identificación.

**En Q01_25 solo hay un bloque** — consistente con el bug G-30 que excluía
el DID real de Nacional B (`19020001`) del reporte de Q01.

### H-2 — El SP agrupa por DID crudo pero muestra etiqueta combinada

El SP productor tiene esta lógica problemática:

```sql
-- Lo que hace el SP (GROUP BY sobre DID crudo):
SELECT
    CASE cDID_800Transfer
        WHEN 19028031 THEN 'Nacional'
        WHEN 19020001 THEN 'Nacional'   -- mismo label para dos DIDs distintos
        WHEN 19020084 THEN 'Puebla'
    END AS cDID_800Transfer,
    trimestre,
    UPPER(TRIM(cMenu)) AS cMenu,
    COUNT(*) AS total_llamadas
FROM tbl_historico_tN_YYYY
GROUP BY cDID_800Transfer, trimestre, cMenu   -- agrupa por DID crudo
ORDER BY cDID_800Transfer, trimestre, total_llamadas DESC;
```

El `GROUP BY cDID_800Transfer` opera sobre el valor numérico antes del CASE,
por eso produce dos grupos. El CASE en el SELECT muestra la misma etiqueta
para ambos. El consumidor del reporte no puede distinguir A de B sin
conocer el orden o los volúmenes.

**Corrección en los SPs de este proyecto:** usar etiquetas distintas para A y B:

```sql
CASE cDID_800Transfer
    WHEN 19028031 THEN 'nacional_A'
    WHEN 19020001 THEN 'nacional_B'
    WHEN 19020084 THEN 'puebla'
END AS segmento
```

### H-3 — Nacional B Q03 confirma el evento operativo

```
Q03_25 Nacional_B: 108,311 llamadas totales
Q02_25 Nacional_B: 3,835,166 llamadas totales
Reducción: -97.2%
```

El volumen de Nacional B en Q03 es residual. El primer menú `CLIENTE_COLGO`
tiene solo 30,201 llamadas en Q03 vs 885,171 en Q02. La reducción es
proporcional en todos los menús, lo que descarta un cambio en el
comportamiento del usuario y confirma un evento operativo en el DID 19020001.

### H-4 — Verificación cruzada con prom_llamadas

Los totales por quarter × segmento (combinando los dos bloques de Nacional)
coinciden exactamente con `prom_llamadas` en todos los casos:

| Quarter | Segmento | llamadas_cmenu | prom_llamadas | Diferencia |
|---|---|---|---|---|
| Q01_25 | Nacional | 11,126,838 | 11,126,838 | 0 |
| Q01_25 | Puebla | 516,841 | 516,841 | 0 |
| Q02_25 | Nacional | 12,783,030 | 12,783,030 | 0 |
| Q02_25 | Puebla | 829,345 | 829,345 | 0 |
| Q03_25 | Nacional | 8,422,917 | 8,422,917 | 0 |
| Q03_25 | Puebla | 423,010 | 423,010 | 0 |

Ambos reportes comparten la misma fuente y el mismo filtro. La diferencia
de 2.6M entre estos reportes y el Excel de Q3 es la misma que se documentó
en `REPORTE-PROM-LLAMADAS.md` (H-3).

### H-5 — cMenu en UPPERCASE con mismo sentinel telefono_cMenu

Confirma lo observado en `prom_llamadas`:
- Todos los valores de menú en UPPERCASE
- `telefono_cMenu` como sentinel para cMenu con número de teléfono
  (aparece en Q03_25 Nacional_A=111, Puebla=297)
- `DEFAULT` en Puebla Q02 (5 registros)

---

## Implicación para sp_rpt_llamadas_menu

Este reporte (`llamadas_cmenu`) es la fuente de referencia para diseñar
`sp_rpt_llamadas_menu`. El SP debe:

1. Producir una fila por `(quarter, segmento, menu)` con el `total_llamadas`
2. Usar etiquetas distintas para Nacional A y Nacional B (`nacional_A`, `nacional_B`)
   — no el mismo label `'Nacional'` para ambos
3. Aplicar `UPPER(TRIM(cMenu))` al agrupar
4. Incluir `telefono_cMenu` como un valor de menú válido (no filtrarlo)
5. Ordenar por `total_llamadas DESC` dentro de cada grupo

```sql
-- Estructura de salida esperada:
SELECT
    CASE cDID_800Transfer
        WHEN 19028031 THEN 'nacional_A'
        WHEN 19020001 THEN 'nacional_B'
        WHEN 19020084 THEN 'puebla'
    END                           AS segmento,
    p_quarter                     AS trimestre,
    UPPER(TRIM(cMenu))            AS menu,
    COUNT(*)                      AS total_llamadas
FROM tbl_historico_tN_YYYY
GROUP BY segmento, menu
ORDER BY segmento, total_llamadas DESC;
```

---

## Pendientes abiertos

| ID | Pregunta | Prioridad |
|---|---|---|
| P-NEW-07 | ¿El SP original combina Nacional A+B intencionalmente o es bug de diseño? | Media |
| P-NEW-08 | ¿`llamadas_cmenu` y `prom_llamadas` son el mismo SP con distinta proyección? | Baja |

---

## Ver también

- `REPORTE-PROM-LLAMADAS.md` — misma fuente, agrega métricas de promedio
- `REPORTE-CLIENTES-UNICOS.md` — ratios llamadas/clientes usados en H-1
- `MAPEO-DID-SEGMENTOS.md` — tabla canónica de DIDs y etiquetas
- `datos-reales/llamadas_cmenu_Q1Q2Q3_2025.csv` — datos con columna `bloque_identificado`

