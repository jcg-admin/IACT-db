# `ivr_agregar_dias_semana`

**Archivo fuente:** `provisioners/mariadb/funciones_utilidad.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** FUNCTION  
**Retorna:** `DATE`

---

## Propósito

Retorna la fecha resultante de avanzar N días hábiles (lunes a viernes) desde una fecha de inicio. Usado en sp_rpt_centros_xsegmento para calcular las fechas de seguimiento del SLA operacional.

---

## Firma

| Parámetro | Tipo | Descripción |
|---|---|---|
| `p_fecha` | DATE | Fecha de inicio |
| `p_n` | INT | Número de días hábiles a avanzar |

---

## Lógica

```
SI p_fecha IS NULL o p_n <= 0 → RETURN p_fecha
v_resultado = p_fecha
v_contador = 0
WHILE v_contador < p_n:
    v_resultado += 1 DAY
    SI ivr_es_dia_semana(v_resultado): v_contador++
RETURN v_resultado
```

---

## Usada por

- sp_rpt_centros_xsegmento (fecha_seguimiento_1_dia, fecha_seguimiento_3_dias, fecha_escalamiento)

---

## Notas

Retorna la fecha de inicio sin cambios si p_n <= 0. Los valores estándar de SLA usados en sp_rpt_centros_xsegmento son 1, 3 y 5 días hábiles desde la última actividad registrada del centro.
