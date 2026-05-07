# Script: Centros de Transferencia con Días Hábiles

**Reporte destino:** `sp_rpt_centros_xsegmento`
**Tabla base:** `base_ivr_detalle`
**Estado:** Script ad-hoc — pendiente migrar a SP

---

## Archivo

`query_centros_transferencia_dias_habiles.sql` — única versión disponible.

---

## Qué hace

Tres queries complementarias sobre la vista `llamadas_Q3`:

**Query 1 — Análisis principal por centro:** Para cada `id_CTransferencia`
calcula métricas de volumen, distribución temporal (dias de semana vs fin de
semana), duración promedio de llamada, clasificación del centro y estado SLA.

**Query 2 — Centros para seguimiento inmediato:** Filtra solo los centros
con `estado_seguimiento IN ('URGENTE_1_DIA', 'URGENTE_5_DIAS', 'ESCALAMIENTO_REQUERIDO')`.

**Query 3 — Cumplimiento de SLA por centro:** Resumen agregado que muestra
cuántos centros están en cada estado SLA y el promedio de llamadas por grupo.

---

## Fuente de datos: vista `llamadas_Q3`, no `tbl_historico_*`

Este es el único script de producción que **no** lee directamente de
`tbl_historico_*`. Lee desde la vista `llamadas_Q3` que expone columnas
ya procesadas:

```sql
FROM llamadas_Q3
-- Columnas disponibles: id_CTransferencia, numero_entrada,
-- menu, opcion, fecha, hora_inicio, hora_fin
```

El nombre de columna `id_CTransferencia` ya está normalizado (no es el
campo crudo `cDID_Centro_Transferencia`). Lo mismo para `menu`, `opcion`,
`fecha`, etc. La normalización NK90 ya fue aplicada por la vista.

**Implicación para el SP:** `sp_rpt_centros_xsegmento` leerá de
`base_ivr_detalle` donde el ETL ya aplicó la normalización. La lógica
de clasificación y SLA se traslada directamente.

---

## Funciones de dias de semana utilizadas

```sql
fn_es_dia_semana(fecha)                    -- ¿Es este dia de semana? → BOOLEAN
fn_contar_dias_semana(fecha_ini, MAX(fecha)) -- Dias de semana entre dos fechas → INT
fn_agregar_dias_semana(MAX(fecha), N)    -- Fecha + N dias de semana → DATE
```

Estas funciones son **prerequisito** de `sp_rpt_centros_xsegmento`.
Deben existir en la BD antes de crear el SP. Son propiedad de la BD del
cliente (no de IACT), por lo que hay que verificar su existencia.

---

## Clasificaciones y lógica de negocio (PROVEN)

### Patrón de uso del centro

```sql
WHEN llamadas_entre_semana / total >= 0.8 THEN 'CENTRO_EMPRESARIAL'
WHEN llamadas_fines_semana / total >= 0.4 THEN 'CENTRO_MIXTO'
ELSE                                           'CENTRO_PERSONAL'
```

### Clasificación por volumen y actividad reciente

```sql
WHEN COUNT(*) >= 20 AND fn_contar_dias_semana(MAX(fecha), CURDATE()) <= 1
    THEN 'CENTRO_CRITICO_ACTIVO'
WHEN COUNT(*) >= 20 AND fn_contar_dias_semana(MAX(fecha), CURDATE()) >  3
    THEN 'CENTRO_ALTO_VOLUMEN_INACTIVO'
WHEN COUNT(*) >= 10 THEN 'CENTRO_VOLUMEN_MEDIO'
ELSE                     'CENTRO_BAJO_VOLUMEN'
```

### Estado SLA

```sql
WHEN fn_contar_dias_semana(MAX(fecha), CURDATE()) = 0 THEN 'DENTRO_SLA_HOY'
WHEN fn_contar_dias_semana(MAX(fecha), CURDATE()) <= 3 THEN 'DENTRO_SLA_3_DIAS'
WHEN fn_contar_dias_semana(MAX(fecha), CURDATE()) <= 5 THEN 'FUERA_SLA_CRITICO'
ELSE                                                        'FUERA_SLA_ESCALAMIENTO'
```

---

## Bug en el script: columna no definida en ORDER BY

La query principal tiene en su ORDER BY:

```sql
ORDER BY total_llamadas DESC, dias_semana_desde_ultima_actividad ASC
```

`dias_semana_desde_ultima_actividad` no se define en el SELECT — el
script fallará tal como está. La columna equivalente sí está definida
en la query 2 (`dias_semana_transcurridos`). Para el SP usar el nombre
consistente definido en el SELECT.

---

## Columnas del result set — Query 1 (principales)

| Columna | Descripción |
|---|---|
| `centro_transferencia` | VDN normalizado (ya procesado por la vista) |
| `total_llamadas` | COUNT(*) total del quarter |
| `usuarios_unicos` | COUNT(DISTINCT numero_entrada) |
| `menus_que_redirigen` | GROUP_CONCAT de menú:opción (denormalizado) |
| `fecha_primera_actividad` | MIN(fecha) |
| `fecha_ultima_actividad` | MAX(fecha) |
| `fecha_seguimiento_1_dia` | fn_agregar_dias_semana(MAX, 1) |
| `fecha_seguimiento_3_dias` | fn_agregar_dias_semana(MAX, 3) |
| `fecha_escalamiento` | fn_agregar_dias_semana(MAX, 5) |
| `llamadas_entre_semana` | COUNT donde fn_es_dia_semana = TRUE |
| `llamadas_fines_semana` | COUNT donde fn_es_dia_semana = FALSE |
| `porcentaje_entre_semana` | % sobre total |
| `dias_semana_periodo_actividad` | fn_contar_dias_semana(MIN, MAX) |
| `patron_uso_centro` | EMPRESARIAL / MIXTO / PERSONAL |
| `duracion_promedio_segundos` | AVG de duración corrigiendo bug dHoraInicio > dHoraFin |
| `llamadas_horario_comercial` | COUNT entre 08:00 y 18:00 en dias de semana |
| `clasificacion_centro` | CRITICO_ACTIVO / ALTO_VOLUMEN_INACTIVO / VOLUMEN_MEDIO / BAJO_VOLUMEN |

**Nota sobre duracion_promedio_segundos:** el script corrige el bug de
`dHoraInicio > dHoraFin` tomando el valor absoluto de la diferencia:

```sql
WHEN TIME_TO_SEC(hora_inicio) <= TIME_TO_SEC(hora_fin)
    THEN TIME_TO_SEC(hora_fin) - TIME_TO_SEC(hora_inicio)
ELSE
    TIME_TO_SEC(hora_inicio) - TIME_TO_SEC(hora_fin)   -- swap corregido
```

---

## Diferencias con sp_rpt_centros_xsegmento

| Aspecto | Script ad-hoc | sp_rpt_centros_xsegmento |
|---|---|---|
| Fuente | Vista `llamadas_Q3` | `base_ivr_detalle` (ETL pre-agregado) |
| Quarter | Solo Q3 2025 hardcodeado | Parámetro `@quarter` |
| GROUP_CONCAT menus | Sí (denormalizado) | No — ya en `base_ivr_detalle` por fila |
| duracion_promedio | Calcula desde hora_inicio/fin | No disponible en `base_ivr_detalle` |
| Segmento | Sin filtro de segmento | Todos los segmentos |

