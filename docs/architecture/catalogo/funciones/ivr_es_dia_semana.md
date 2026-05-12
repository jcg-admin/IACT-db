# `ivr_es_dia_semana`

**Archivo fuente:** `provisioners/mariadb/funciones_utilidad.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** FUNCTION  
**Retorna:** `TINYINT(1) (BOOLEAN)`

---

## Propósito

Predicado que retorna TRUE si la fecha dada es un día de semana (lunes a viernes). El IVR opera los 7 días, incluyendo festivos, por lo que la distinción es lunes-viernes vs. sábado-domingo, sin calendario de festivos.

---

## Firma

| Parámetro | Tipo | Descripción |
|---|---|---|
| `p_fecha` | DATE | Fecha a evaluar |

---

## Lógica

```sql
RETURN DAYOFWEEK(p_fecha) NOT IN (1, 7);
-- DAYOFWEEK: 1=Domingo, 7=Sábado en MariaDB
```

---

## Usada por

- sp_etl_base_detalle (ETL) — pre-computa llamadas_entre_semana y llamadas_fines_semana
- ivr_contar_dias_semana
- ivr_agregar_dias_semana

---

## Notas

Festivos NO son excluidos (Art. 74 LFT no aplica al IVR de cobranza que opera 7 días). Esta decisión se documentó en H-F1-002 del plan V2.1.
