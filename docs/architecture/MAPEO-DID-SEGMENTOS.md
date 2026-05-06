# Mapeo cDID_800Transfer — DIDs de entrada y etiquetas de segmento

**Fecha:** 2026-05-06

---

## El campo cDID_800Transfer

En `tbl_historico_tN_YYYY`, `cDID_800Transfer` contiene el número DID numérico
crudo — es el número que el cliente marcó para entrar al sistema IVR. No
contiene etiquetas como `'Nacional'` o `'Puebla'`. Esas etiquetas son el
resultado de una transformación que aplica el SP de reporte.

```
Llamada del cliente
        ↓
  cDID_800Transfer = '19028031'  ← valor almacenado en la tabla (numérico)
        ↓
  CASE WHEN en el SP
        ↓
  segmento = 'nacional_A'        ← etiqueta presentada en el reporte
```

---

## Tabla de mapeo canónico

| DID en tbl_historico_* | Etiqueta en reportes | Organización | Proporción real Q1-Q3 |
|---|---|---|---|
| `19028031` | `nacional_A` | Línea 800 Nacional A | ~45% del tráfico total |
| `19020001` | `nacional_B` | Línea 800 Nacional B | ~30% del tráfico total |
| `19020084` | `puebla` | Línea 800 Puebla | ~25% del tráfico total |

---

## CASE canónico para los SPs

Todos los SPs de reporte que presenten datos por segmento deben usar
este CASE exacto sobre `cDID_800Transfer`:

```sql
CASE cDID_800Transfer
    WHEN 19028031 THEN 'nacional_A'
    WHEN 19020001 THEN 'nacional_B'
    WHEN 19020084 THEN 'puebla'
    ELSE 'desconocido'
END AS segmento
```

La etiqueta resultante va en minúsculas con guion bajo, siguiendo la
convención observada en el reporte `clientes_unicos` de producción.

---

## Convención de presentación por reporte

Los reportes de producción no son consistentes entre sí en la capitalización:

| Reporte | Convención usada | Ejemplo |
|---|---|---|
| `prom_llamadas` | Capitalizado, A+B combinados | `'Nacional'`, `'Puebla'` |
| `clientes_unicos` | Minúsculas con guion bajo, separados | `'nacional_A'`, `'nacional_B'`, `'puebla'` |

El ETL interno usa la convención de `clientes_unicos` (minúsculas, separados)
porque permite distinguir A de B en las tablas base. Los SPs de presentación
pueden combinar A+B en `'Nacional'` para la capa de reportes si el reporte
lo requiere.

---

## Bug G-30 — @ONacionalB mal asignado en scripts originales

Los scripts de análisis originales del cliente tenían este bug:

```sql
-- INCORRECTO — en múltiples scripts originales
SET @ONacionalA = 19028031;
SET @ONacionalB = 19028031;  -- ERROR: debería ser 19020001
```

Esto causó que cualquier filtro `WHERE cDID_800Transfer IN (@ONacionalA, @ONacionalB)`
evaluara como `IN (19028031, 19028031)` — un solo DID duplicado. El DID
real de Nacional B (`19020001`) quedaba completamente excluido.

**Impacto documentado:**

En el reporte `clientes_unicos` Q01_25, la fila etiquetada `nacional_B`
(3,056,531 clientes) corresponde en realidad a Nacional A (DID 19028031).
El real Nacional B de Q01 no aparece en ese reporte porque fue excluido
por el bug. Ver `REPORTE-CLIENTES-UNICOS.md` para el análisis completo.

**Corrección aplicada:** todos los scripts corregidos en
`docs/referencias/scripts-sql/corregidos/` usan `@ONacionalB = 19020001`.

---

## Dónde está documentado en el código

| Archivo | Línea | Contenido |
|---|---|---|
| `schema_historico.sql` | COMMENT de cada tabla | `DIDs: Puebla=19020084 NacionalA=19028031 NacionalB=19020001` |
| `seed_historico_real.sql` | bloque IF de generación | `SET v_did = '19028031'; -- Nacional A` |
| `poblar_historico.py` | bloque `SEGMENTOS` | Mapeo completo con CASE canónico y advertencia G-30 |

---

## Ver también

- `REPORTE-CLIENTES-UNICOS.md` — hallazgo H-1 y H-2 (mislabel Q01)
- `REPORTE-PROM-LLAMADAS.md` — hallazgo H-4 (Nacional combinado)
- `TBL-HISTORICO-ANOMALIAS.md` — contexto de las tablas fuente
- `scripts-sql/corregidos/` — scripts con @ONacionalB corregido

