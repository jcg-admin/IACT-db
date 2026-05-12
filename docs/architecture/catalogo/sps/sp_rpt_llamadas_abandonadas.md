# `sp_rpt_llamadas_abandonadas`

**Archivo fuente:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Caso de uso:** UC_RPT_13

---

## Propósito

Tasa de abandono por menú. Las llamadas abandonadas se definen por el valor de `menu` en `('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')` según D-ETL-006. Incluye clasificación SLA recalibrada por D-ETL-007: < 20% óptimo, 20-30% aceptable, > 30% crítico.

---

## Firma

```sql
CALL sp_rpt_llamadas_abandonadas(
    p_quarter  VARCHAR(10),  -- 'Q02_26'
    p_segmento VARCHAR(20)   -- 'todas' | 'nacional_A' | 'nacional_B' | 'puebla'
);
```

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_rpt_llamadas_abandonadas`.

---

## Result set

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | Quarter |
| `segmento` | VARCHAR(20) | Segmento IVR |
| `menu` | VARCHAR(100) | UPPER(TRIM(menu)) del tipo de abandono |
| `total_abandonadas` | BIGINT | Volumen de llamadas abandonadas |
| `pct_del_total` | DECIMAL(6,2) | % sobre el total del quarter/segmento (NULLIF v_total_quarter) |
| `pct_del_segmento` | DECIMAL(6,2) | % sobre el total del segmento individual (NULLIF protegido) |
| `clasificacion_sla` | VARCHAR(20) | 'OPTIMO' < 20% | 'ACEPTABLE' 20-30% | 'CRITICO' > 30% |

---

## Tabla fuente

`base_ivr_detalle` (filtro: `menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')`)

---

## Notas

Usa la variable `v_total_quarter BIGINT DEFAULT 0` como denominador para `pct_del_total`. Protegida con `NULLIF(v_total_quarter, 0)` para evitar división por cero si el quarter está vacío.
