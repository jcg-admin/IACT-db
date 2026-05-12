# `sp_rpt_clientes`

**Archivo fuente:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Caso de uso:** UC_RPT_17

---

## Propósito

Retorna el número de clientes únicos por segmento para el quarter indicado,
junto con el porcentaje que representa cada segmento sobre el total del quarter.
Lee directamente de `base_ivr_clientes` — tabla generada por `sp_etl_base_clientes`.

---

## Firma

```sql
CALL sp_rpt_clientes(
    p_quarter  VARCHAR(10)  -- 'Q02_26'
);
```

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_rpt_clientes`.

---

## Result set

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | Quarter: `'Q02_26'` |
| `segmento` | VARCHAR(20) | `nacional_A`, `nacional_B`, `puebla` |
| `clientes_unicos` | INT | COUNT DISTINCT de cTelefono_Origen |
| `pct_del_total` | DECIMAL | % del total del quarter (NULLIF protegido) |
| `ultima_actualizacion` | DATETIME | `cargado_en` de la fila |

Retorna 3 filas por quarter (una por segmento), ordenadas por `clientes_unicos DESC`.

---

## Tabla fuente

`base_ivr_clientes` — generada por `sp_etl_base_clientes`.

---

## Notas

El denominador `SUM(c2.clientes_unicos)` está protegido con `NULLIF(..., 0)` para
evitar división por cero silenciosa si el ETL falló y la tabla tiene filas con
`clientes_unicos = 0` (BUG-004, resuelto en FASE 5).

---

## Invocación de ejemplo

```sql
CALL sp_rpt_clientes('Q02_26');
-- Retorna: nacional_A 18392 (45.12%), nacional_B 12370 (30.35%), puebla 9998 (24.53%)
```
