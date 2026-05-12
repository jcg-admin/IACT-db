# `sp_rpt_cMENU_ERROR`

**Archivo fuente:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Caso de uso:** UC_RPT_16

---

## Propósito

Anomalías donde cMenu contiene un número de teléfono en lugar de un identificador de menú. En base_ivr_detalle se almacenan como el número raw (no como un sentinel). El reporte los agrupa bajo el tipo 'telefono_cMenu' para presentación. Ref: REPORTE-C-MENU.md H-6.

---

## Firma

```sql
CALL sp_rpt_cMENU_ERROR(
    p_quarter  VARCHAR(10),
    p_segmento VARCHAR(20)
);
```

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_rpt_cMENU_ERROR`.

---

## Result set

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | Quarter |
| `segmento` | VARCHAR(20) | Segmento IVR |
| `tipo_anomalia` | VARCHAR(20) | Siempre 'telefono_cMenu' |
| `valor_cMenu_raw` | VARCHAR(100) | El número de teléfono real del llamante en cMenu |
| `centro_transferencia` | VARCHAR(100) | Siempre 19020086 (bucket de abandono) |
| `total_llamadas` | BIGINT | Volumen de esta anomalía específica |
| `total_anomalias_quarter` | BIGINT | Total de todas las anomalías en el quarter/segmento |

---

## Tabla fuente

`base_ivr_detalle` (filtro: `menu REGEXP '^[0-9]+$' AND LENGTH(menu) >= 7`)

---

## Notas

Detecta números de teléfono como menú: solo dígitos y longitud ≥ 7. No tiene división — no requiere NULLIF.
