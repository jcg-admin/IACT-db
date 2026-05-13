# Análisis — Módulo 12: Operadores de Set aplicados a IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Fuente:** Módulo 12 — "Uso de operadores de set" (UNION, EXCEPT, INTERSECT, APPLY)  
**Motor:** MariaDB 10.11

---

## Tabla de aplicabilidad por operador

| Operador | Disponible en MariaDB 10.11 | Estado en IACT-db | Decisión |
|---|---|---|---|
| `UNION` / `UNION ALL` | Sí — todas las versiones | En uso (suites de tests, bookends) | Sin nuevas oportunidades en los SPs |
| `EXCEPT` / `EXCEPT ALL` | Sí — desde MariaDB 10.3.0 | No se usaba | Implementado en `sp_etl_validar` v2.1.0 |
| `INTERSECT` / `INTERSECT ALL` | Sí — desde MariaDB 10.3.0 | No se usaba | Implementado en `sp_etl_validar` v2.1.0 |
| `CROSS APPLY` / `OUTER APPLY` | **No** — SQL Server únicamente | No aplica | Descartado (requiere TVF — Módulo 11) |

---

## APPLY — no aplica

`APPLY` es un operador de SQL Server que aplica una expresión de tabla o una TVF a
cada fila de la tabla izquierda. MariaDB no lo soporta. Además, su uso principal
(pasar filas a una TVF) no es posible en MariaDB porque tampoco tiene TVF.
Esta exclusión ya estaba documentada en el análisis del Módulo 11.

---

## UNION / UNION ALL — ya en uso, sin nuevas oportunidades en SPs

`UNION ALL` se usa en el proyecto en dos contextos:
- Las suites de tests de FASE 4 construyen conjuntos de datos de prueba combinando
  siete fechas de inicio con dieciséis rangos usando `UNION ALL`.
- Los archivos individuales SQL usan `UNION ALL` en los bloques de verificación para
  combinar los resultados de varias funciones en un solo `SELECT ... FROM DUAL`.

En los SPs de negocio no hay oportunidad para `UNION` porque cada SP opera sobre un
único quarter y un único segmento — no hay necesidad de combinar result sets de
fuentes distintas.

---

## EXCEPT e INTERSECT — gap real detectado en `sp_etl_validar`

### El problema

`sp_etl_validar` v2.0.0 realizaba tres checks de conteo:

```
Check 1: base_ivr_detalle tiene al menos 1 fila
Check 2: base_ivr_clientes tiene exactamente 3 filas
Check 3: SUM(total_llamadas) > 0
```

El Check 2 (`v_count_cli = 3`) verifica que hay 3 registros en `base_ivr_clientes`,
pero **no verifica que esos registros correspondan a los mismos segmentos que están
en `base_ivr_detalle`**. Un ETL parcialmente fallido podría producir:

```
base_ivr_detalle: nacional_A, nacional_B, puebla (3 segmentos)
base_ivr_clientes: nacional_A, nacional_A, nacional_B (3 filas, datos incorrectos)
```

El check de conteo pasaría (`v_count_cli = 3`) pero los datos serían inconsistentes.

### Corrección implementada

**Check 4 — EXCEPT** detecta segmentos en `base_ivr_detalle` que no tienen par en
`base_ivr_clientes`. Si retorna filas, hay inconsistencia de segmentos:

```sql
SELECT segmento FROM base_ivr_detalle WHERE trimestre = p_quarter
GROUP BY segmento
EXCEPT
SELECT segmento FROM base_ivr_clientes WHERE trimestre = p_quarter;
-- Si retorna filas → hay segmentos con detalle pero sin entrada en clientes
```

**Check 5 — INTERSECT** verifica que los segmentos comunes entre ambas tablas son
exactamente 3 (los tres segmentos canónicos: `nacional_A`, `nacional_B`, `puebla`):

```sql
SELECT segmento FROM base_ivr_detalle WHERE trimestre = p_quarter
GROUP BY segmento
INTERSECT
SELECT segmento FROM base_ivr_clientes WHERE trimestre = p_quarter;
-- Debe retornar exactamente 3 filas
```

Estos dos checks son complementarios: EXCEPT garantiza que no hay segmentos
huérfanos; INTERSECT garantiza que los segmentos comunes son exactamente los
esperados. Juntos son más precisos que el check de conteo original.

### Resultado en producción

```
Q01_25: segmentos_sin_par=0, segmentos_comunes=3, validacion_ok=1
Mensaje: OK — 2704 filas detalle, 3 filas clientes, 119,205 llamadas totales,
         3 segmentos comunes.
```

---

## Resumen de cambios implementados

`sp_etl_validar` v2.1.0 — 5 checks en lugar de 3:

| Check | Método | Qué verifica |
|---|---|---|
| 1 | `COUNT(*)` | `base_ivr_detalle` tiene al menos 1 fila |
| 2 | `COUNT(*)` | `base_ivr_clientes` tiene exactamente 3 filas |
| 3 | `SUM(total_llamadas)` | El total de llamadas es mayor que 0 |
| 4 | `EXCEPT` | Ningún segmento del detalle sin par en clientes |
| 5 | `INTERSECT` | Los 3 segmentos canónicos están en ambas tablas |

`p_ok` ahora requiere que los 5 checks pasen. El result set incluye dos columnas
nuevas: `segmentos_sin_par` (debe ser 0) y `segmentos_comunes` (debe ser 3).

---

## SPs no modificados — sin oportunidades de UNION / EXCEPT / INTERSECT

Los SPs de reporte y los SPs ETL distintos de `sp_etl_validar` no tienen
oportunidades para estos operadores porque:
- Los SPs de reporte agregan datos de una sola tabla (`base_ivr_detalle`) con
  filtro por quarter — no hay dos conjuntos que combinar, comparar o restar.
- Los SPs ETL procesan datos de forma secuencial por diseño; combinar result sets
  no aportaría valor.

---

## verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
