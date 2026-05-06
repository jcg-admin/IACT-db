# Investigación: Análisis de redirecciones totales

**Script:** `q_analisis_redireciones_total_290825.sql`
**Tipo:** Exploratorio — análisis de frecuencia y patrones de redirección

---

## Qué hace

Agrupa llamadas por `cDID_Centro_Transferencia` (tipo de interacción) con
métricas de frecuencia, usuarios únicos, días activos y menús usados.
Incluye un JOIN a una subconsulta de fechas min/max por teléfono de origen.

---

## Bugs identificados

### Bug crítico 1 — @ONacionalB usada pero nunca declarada

```sql
-- Variables declaradas:
SET @OPuebla = 19020084;
SET @ONacionalA = 19028031;
-- @ONacionalB NUNCA se declara

-- Pero se usa en el SELECT:
WHEN l.cDID_800Transfer IN (@ONacionalA, @ONacionalB) THEN 'Nacional'
```

En MariaDB, una variable no declarada es NULL. El CASE evalúa
`IN (19028031, NULL)` — Nacional B queda fuera del resultado sin error.

### Bug 2 — WHERE con lógica invertida para cDID_Centro_Transferencia

```sql
-- Tal como está (filtra registros donde ES NULL o NO está vacío):
WHERE (cDID_Centro_Transferencia IS NULL OR cDID_Centro_Transferencia != '')

-- Intención probable (solo registros con valor no nulo y no vacío):
WHERE cDID_Centro_Transferencia IS NOT NULL AND cDID_Centro_Transferencia != ''
```

La condición actual incluye NULLs y excluye solo el string vacío — es
el comportamiento opuesto al esperado.

### Bug 3 — Rango acotado (primeros 15 días de enero)

`@Q1_fin = '2025-01-15'`

