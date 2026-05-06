# Investigación: Catálogo de menús por trimestre

**Script:** `REPTRIM001-A1.sql`
**Título interno:** "Análisis colgadas"
**Tipo:** Exploratorio — análisis de presencia de menús por quarter

---

## Qué hace realmente

A pesar del título "Análisis colgadas", este script no analiza llamadas
colgadas en el sentido del reporte. Construye una **matriz de presencia**:
para cada combinación de (menú, trimestre), indica si ese menú existe
o no en ese trimestre (`'vacia'` = existe, `'NO'` = no existe).

Usa un patrón CROSS JOIN + EXISTS inusual:

```sql
WITH todos_los_menu AS (
    -- catálogo completo de menús únicos en los 3 quarters
    SELECT DISTINCT cMenu FROM UNION de las 3 tablas
),
todos_los_trimestres AS (Q01_25, Q02_25, Q03_25)

SELECT trimestre, cMenu,
    CASE WHEN EXISTS(SELECT 1 FROM tbl_historico_tN WHERE cMenu = c.cMenu ...) THEN 'vacia'
    ELSE 'NO' END AS estado
FROM todos_los_menu CROSS JOIN todos_los_trimestres
```

## Para qué sirve

Detectar menús que aparecen en algunos quarters pero no en otros.
Si un menú aparece en Q1 y Q3 pero no en Q2, puede indicar:
- Un menú estacional
- Un cambio en el catálogo del IVR entre quarters
- Un problema de datos en Q2

## Bug: @ONacional02 = 1902001

Mismo error de cero faltante que en los scripts REPTRIM021. El script
tampoco usa esta variable en el WHERE — solo está declarada.
