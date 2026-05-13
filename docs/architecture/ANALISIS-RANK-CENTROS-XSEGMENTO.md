# Análisis — `DENSE_RANK()` en `sp_rpt_centros_xsegmento`

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Objeto modificado:** `sp_rpt_centros_xsegmento` v2.1.0 → v2.2.0  
**Contexto:** El análisis del Módulo 13 propuso agregar `RANK()` por volumen dentro
de cada segmento. Este documento describe el análisis completo y la decisión de usar
`DENSE_RANK()` en lugar de `RANK()`.

---

## El SP y su propósito operacional

`sp_rpt_centros_xsegmento` muestra todos los centros de transferencia de un quarter,
agrupados por segmento, con métricas de volumen, actividad y cumplimiento SLA. La
columna `clasificacion_sla` ya diferencia entre `ACTIVO_HOY`, `DENTRO_SLA`,
`RIESGO_SLA`, `FUERA_SLA`, `VOLUMEN_MEDIO` y `BAJO_VOLUMEN`.

Lo que el SP no tenía era una respuesta directa a: *dentro de un segmento, ¿en qué
posición está este centro respecto a los demás por volumen de llamadas?*

---

## Por qué el ranking por volumen tiene valor operacional

El SP devuelve 28 centros por segmento (84 filas para un quarter con 3 segmentos).
El `ORDER BY cc.segmento, cc.total_llamadas DESC` ya los ordena por volumen, pero
el número de fila en el resultado no es accesible sin cálculo adicional en el cliente.

Con `rango_en_segmento`, el consumidor del SP puede responder directamente:

- El centro `10728487` es el `#1` en `nacional_A` por volumen.
- El centro `10928137` es el `#25` en `nacional_A` — de los últimos en actividad.
- Los centros `#1` al `#11` en cada segmento son `FUERA_SLA` — los de mayor volumen y mayor
  tiempo de inactividad requieren atención prioritaria.

Esto permite priorizar intervenciones: no es igual un centro `FUERA_SLA` que es el
`#1` en volumen que uno que es el `#26`.

---

## Análisis de empates: por qué DENSE_RANK sobre RANK

La primera decisión fue verificar si existen empates en `total_llamadas` dentro de
un segmento, porque el comportamiento de `RANK()` y `DENSE_RANK()` difiere solo
cuando hay empates.

### Resultado de la verificación en Q01_25

```
nacional_A — distribución de volumen (28 centros):
  posición  centro         llamadas   RANK   DENSE_RANK
  ────────  ─────────────  ────────   ────   ──────────
  ...
  22        15070006            81     22        22
  23        15070071            50     23        23
  24        10628002            20     24        24   ← empate
  24        15070002            20     24        24   ← empate
  26        10928137            18     26        25   ← empate
  26        10728494            18     26        25   ← empate
  28        19020088             1     28        26
```

**Con `RANK()`:** Los dos centros con 20 llamadas ocupan la posición 24. La siguiente
posición es la 26 (se salta la 25 porque las dos posiciones 24 "consumen" el espacio de
la 25). Los dos centros con 18 llamadas quedan en la 26, y el último centro queda en
la 28. No existe ningún centro en la posición 25 ni en la 27.

**Con `DENSE_RANK()`:** Los dos centros con 20 llamadas ocupan la posición 24. La
siguiente posición es la 25 — continua, sin saltos. Los dos centros con 18 llamadas
quedan en la 25. El último centro queda en la 26. La secuencia es 24,24,25,25,26.

### Por qué DENSE_RANK es la elección correcta aquí

El máximo de `DENSE_RANK()` coincide con el número de niveles de volumen distintos
en el segmento. Para Q01_25 con 28 centros: `DENSE_RANK` máximo = 26, lo que indica
que existen 26 niveles de volumen distintos (28 centros, 2 pares empatados).

El máximo de `RANK()` sería 28 — igual al número total de centros — pero no porque
haya 28 niveles distintos, sino porque los saltos inflan el número. Esto puede
inducir a interpretarlo como "hay 28 centros distintos por volumen" cuando en
realidad dos pares empatan.

Para el propósito de priorización operacional — *"¿a cuántos centros le doy prioridad
antes que a este?"* — DENSE_RANK responde de forma más precisa. Si un centro es
`DENSE_RANK = 25`, significa que 24 niveles de volumen están por encima de él, y hay
exactamente 1 nivel por debajo.

---

## Implementación

La columna se agrega al final del `SELECT` final del SP, operando sobre
`centros_calendario cc` que ya tiene `total_llamadas` materializado. No requiere
un CTE adicional.

```sql
, DENSE_RANK() OVER (
    PARTITION BY cc.segmento
    ORDER BY cc.total_llamadas DESC
  ) AS rango_en_segmento
```

**Por qué al final del SELECT:** Las columnas existentes se mantienen en las mismas
posiciones. Cualquier cliente que acceda por posición no se ve afectado.

**Por qué `PARTITION BY cc.segmento`:** El ranking es independiente por segmento.
`nacional_A` y `nacional_B` tienen cada uno su propio rango empezando en 1.
Un ranking global sin partición mezclaría los tres segmentos y perdería significado.

**Por qué `ORDER BY cc.total_llamadas DESC`:** La posición 1 corresponde al centro
de mayor volumen. Esta es la dimensión de priorización primaria: a mayor volumen,
mayor impacto operacional si el centro entra en `FUERA_SLA`.

---

## Resultado verificado en MariaDB 10.11

```
Q01_25 — nacional_A (primeros y últimos centros):
  centro        llamadas   clasificacion_sla   rango
  ──────────    ────────   ─────────────────   ─────
  10728487         5493    FUERA_SLA               1
  19020086         5084    FUERA_SLA               2
  10828091         4803    FUERA_SLA               3
  ...
  15070006           81    BAJO_VOLUMEN           22
  15070071           50    BAJO_VOLUMEN           23
  10628002           20    BAJO_VOLUMEN           24   ← empate
  15070002           20    BAJO_VOLUMEN           24   ← empate
  10928137           18    BAJO_VOLUMEN           25   ← empate
  10728494           18    BAJO_VOLUMEN           25   ← empate
  19020088            1    BAJO_VOLUMEN           26
```

Los empates en posiciones 24 y 25 muestran secuencia continua sin brechas.

---

## Lo que no se implementó y por qué

**`RANK()` por `dias_sin_actividad DESC` (ranking de riesgo SLA):**
En Q01_25 todos los centros tienen `dias_sin_actividad = 293` (el quarter terminó en
marzo de 2025, y la consulta se hace en mayo de 2026). El ranking sería 1 para todos
— sin valor informacional para datos históricos. Para un quarter en curso donde los
centros tienen fechas de última actividad distintas, este ranking aportaría valor,
pero en el contexto actual no justifica la adición.

**`RANK()` dentro de `clasificacion_sla` (ranking por SLA bucket):**
Sería un `PARTITION BY cc.segmento, cc.clasificacion_sla`. Permite responder *"entre
todos los centros `FUERA_SLA` de mi segmento, ¿cuál tiene más volumen?"*. Tiene
valor analítico, pero al combinarse con el ranking global ya implementado es
información redundante: si un centro es `FUERA_SLA` y su `rango_en_segmento` es 1,
ya se sabe que es el más urgente.

**`ROW_NUMBER()` en lugar de `DENSE_RANK()`:**
`ROW_NUMBER()` nunca produce empates — a centros con el mismo volumen les asigna
números secuenciales arbitrarios dependiendo del orden interno. Para priorización,
esto es engañoso: dos centros con exactamente el mismo volumen deberían tener el
mismo rango.

---

## verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
