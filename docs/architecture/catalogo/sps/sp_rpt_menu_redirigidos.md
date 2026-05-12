# `sp_rpt_menu_redirigidos`

**Archivo fuente:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Caso de uso:** UC_RPT_16

---

## Propósito

Perspectiva menú → centro de transferencia. Responde: para cada menú, ¿a qué centros redirige el IVR y con qué proporción? Excluye menú 'VACIO' y centros sentinels. Permite detectar qué centros son receptores dominantes de cada menú.

---

## Firma

```sql
CALL sp_rpt_menu_redirigidos(
    p_quarter  VARCHAR(10),
    p_segmento VARCHAR(20)
);
```

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_rpt_menu_redirigidos`.

---

## Result set

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | Quarter |
| `segmento` | VARCHAR(20) | Segmento IVR |
| `menu` | VARCHAR(100) | Menú origen (UPPER TRIM) |
| `centro_transferencia` | VARCHAR(100) | Centro destino |
| `total_llamadas` | BIGINT | Volumen menú→centro |
| `pct_del_menu` | DECIMAL(6,2) | % de ese menú que va a ese centro |
| `pct_del_total` | DECIMAL(8,4) | % del total del quarter |

---

## Tabla fuente

`base_ivr_detalle` (excluye `menu='VACIO'` y sentinels de centro)

---

## Notas

Ambas divisiones protegidas con NULLIF. Grain: trimestre × segmento × menu × centro.
