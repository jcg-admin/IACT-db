# `ivr_contar_dias_semana`

**Versión:** 3.0.0  
**Archivo fuente:** `provisioners/mariadb/objetos/funciones/ivr_contar_dias_semana.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** FUNCTION  
**Retorna:** `INT`

---

## Propósito

Cuenta los días hábiles (lunes a viernes) en un rango de fechas, ambos extremos inclusivos. Usado en sp_rpt_centros_xsegmento para calcular el SLA operacional de los centros de transferencia.

---

## Firma

| Parámetro | Tipo | Descripción |
|---|---|---|
| `p_ini` | DATE | Fecha de inicio (inclusiva) |
| `p_fin` | DATE | Fecha de fin (inclusiva) |

---

## Lógica

```
SI p_ini IS NULL o p_fin IS NULL o p_ini > p_fin → RETURN 0
v_fecha = p_ini
WHILE v_fecha <= p_fin:
    SI ivr_es_dia_semana(v_fecha): v_dias++
    v_fecha += 1 DAY
RETURN v_dias
```

---

## Usada por

- sp_rpt_centros_xsegmento (días_semana_periodo, días_semana_sin_actividad)

---

## Notas

Implementación por iteración día a día — O(n) donde n es el número de días del rango. Para rangos de un quarter (≤ 92 días) el rendimiento es aceptable. No usa tablas de calendario — solo `ivr_es_dia_semana`.
