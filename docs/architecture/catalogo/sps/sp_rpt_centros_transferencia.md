# `sp_rpt_centros_transferencia`

**Versión:** 2.1.0  
**Archivo fuente:** `provisioners/mariadb/objetos/sps/sp_rpt_centros_transferencia.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Caso de uso:** UC_RPT_15

---

## Propósito

Detalle completo de transferencias: cada fila representa un grupo único de quarter × fecha × segmento × centro × menú × opción con sus métricas de comportamiento. Es el reporte de mayor granularidad del sistema — fuente para análisis ad-hoc.

---

## Firma

```sql
CALL sp_rpt_centros_transferencia(
    p_quarter  VARCHAR(10),  -- 'Q02_26'
    p_segmento VARCHAR(20)   -- 'todas' | 'nacional_A' | 'nacional_B' | 'puebla'
);
```

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_rpt_centros_transferencia`.

---

## Result set

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | Quarter |
| `fecha` | VARCHAR(6) | Mes YYYYMM |
| `segmento` | VARCHAR(20) | Segmento IVR |
| `centro_transferencia` | VARCHAR(100) | VDN normalizado |
| `menu` | VARCHAR(100) | UPPER(TRIM(menu)) para presentación |
| `opcion` | VARCHAR(100) | Valor de cOpcion |
| `total_llamadas` | INT | Volumen del grupo |
| `porcentaje` | DECIMAL(14,7) | % del total del mes/segmento (NULLIF protegido) |
| `misma_linea` | INT | Llamantes que digitaron su propio número |
| `linea_diferente` | INT | Llamantes que digitaron número diferente |
| `no_digito_telefono` | INT | Llamantes que no digitaron número |
| `llamadas_entre_semana` | INT | Llamadas en días lunes-viernes |
| `llamadas_fines_semana` | INT | Llamadas en sábado o domingo |

---

## Tabla fuente

`base_ivr_detalle`

---

## Notas

El campo `porcentaje` es el % del total de llamadas del mes y segmento filtrado. Usa subconsulta correlacionada por `b2.fecha = b.fecha` — el denominador siempre es > 0 mientras haya filas.
