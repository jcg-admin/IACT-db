# `sp_rpt_centros_xsegmento`

**Versión:** 2.1.0  
**Archivo fuente:** `provisioners/mariadb/objetos/sps/sp_rpt_centros_xsegmento.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Caso de uso:** UC_RPT_01 / UC_RPT_15

---

## Propósito

KPIs operacionales por centro de transferencia con clasificación SLA y métricas de días de semana. Es el SP más complejo — usa todas las funciones de calendario (ivr_es_dia_semana, ivr_contar_dias_semana, ivr_agregar_dias_semana). Determina si un centro está activo, dentro/fuera de SLA o con bajo volumen.

---

## Firma

```sql
CALL sp_rpt_centros_xsegmento(
    p_quarter  VARCHAR(10)  -- 'Q02_26'
    -- Sin p_segmento: retorna todos los segmentos
);
```

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_rpt_centros_xsegmento`.

---

## Result set

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | Quarter |
| `segmento` | VARCHAR(20) | Segmento IVR |
| `centro_transferencia` | VARCHAR(100) | VDN |
| `total_llamadas` | BIGINT | Volumen total del centro |
| `misma_linea` | BIGINT | SUM misma_linea |
| `linea_diferente` | BIGINT | SUM linea_diferente |
| `no_digito_telefono` | BIGINT | SUM no_digito_telefono |
| `llamadas_entre_semana` | BIGINT | SUM llamadas_entre_semana |
| `llamadas_fines_semana` | BIGINT | SUM llamadas_fines_semana |
| `pct_entre_semana` | DECIMAL(5,1) | % de llamadas en días hábiles (NULLIF protegido) |
| `primera_actividad` | DATE | Primer mes con datos |
| `ultima_actividad` | DATE | Último mes con datos |
| `dias_semana_periodo` | INT | Días hábiles en el rango de actividad |
| `dias_semana_sin_actividad` | INT | Días hábiles desde última actividad hasta hoy |
| `fecha_seguimiento_1_dia` | DATE | Última actividad + 1 día hábil |
| `fecha_seguimiento_3_dias` | DATE | Última actividad + 3 días hábiles |
| `fecha_escalamiento` | DATE | Última actividad + 5 días hábiles |
| `clasificacion_sla` | VARCHAR(20) | ACTIVO_HOY | DENTRO_SLA | RIESGO_SLA | FUERA_SLA | VOLUMEN_MEDIO | BAJO_VOLUMEN |
| `pct_del_segmento` | DECIMAL(8,4) | % del total del quarter para ese segmento |

---

## Tabla fuente

`base_ivr_detalle` (excluye CASO_NULL, CASO_ERROR_CEROS, ERROR_CARACTER_INICIAL, CLIENTE_COLGO)

---

## Notas

Clasificación SLA basada en volumen total (umbral: ≥ 1000 llamadas) y días hábiles sin actividad. Usa CURDATE() para días_semana_sin_actividad — el resultado cambia cada día.
