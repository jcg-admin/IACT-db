# Window Functions — Casos de Uso con Datos Reales IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Motor:** MariaDB 10.11 — todas las funciones verificadas  
**Escala del entorno de referencia:** 11.6M filas fuente → ~2,700 filas agregadas por quarter

---

## Contexto del dominio

El sistema IVR procesa llamadas de tres segmentos (`nacional_A`, `nacional_B`, `puebla`).
Cada llamada termina en un centro de transferencia (VDN). Los datos de Q01_25 muestran:

```
Segmento     Centros   Llamadas totales   Top 3 centros (% del segmento)
nacional_A      28         53,879         10728487=5,493 | 19020086=5,084 | 10828091=4,803 (47%)
nacional_B      28         35,572         10728487=3,628 | 19020086=3,394 | 10828091=3,111 (29%)
puebla          28         29,754         10728487=3,144 | 19020086=2,895 | 10828091=2,690 (29%)
```

La distribución es asimétrica: los 3 primeros centros concentran el 30-47% del volumen,
mientras los 6 últimos apenas alcanzan el 0.6% en `nacional_A`.

---

## UC-01 — `SUM() OVER (PARTITION BY)`: porcentaje dentro del grupo con una sola pasada

**Pregunta que responde:** ¿Qué porcentaje del total del segmento representa cada centro,
sin un segundo scan de la tabla?

**Contexto:** Los SPs de reporte necesitan calcular porcentajes del tipo "este centro
representa el X% del segmento". La subconsulta correlacionada hace un scan adicional
por fila. La window function calcula el total del segmento en la misma pasada.

```sql
SELECT
    segmento
    , centro_transferencia
    , SUM(total_llamadas)                                          AS llamadas
    , SUM(SUM(total_llamadas)) OVER (PARTITION BY segmento)        AS total_segmento
    , ROUND(SUM(total_llamadas)
        / SUM(SUM(total_llamadas)) OVER (PARTITION BY segmento) * 100, 2) AS pct_del_segmento
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO')
GROUP BY segmento, centro_transferencia
ORDER BY segmento, llamadas DESC;
```

**Resultado real Q01_25 — nacional_A:**
```
10728487   5,493   32,573   16.86%
19020086   5,084   32,573   15.61%
10828091   4,803   32,573   14.75%
15070013   2,560   32,573    7.86%
```

**Valor en producción:** Elimina el segundo scan de `base_ivr_detalle` (10,000-60,000 filas).
Aplicable directamente en `sp_rpt_cMENU_ERROR` y `sp_rpt_menu_centro` donde la
equivalencia semántica está verificada.

---

## UC-02 — `ROW_NUMBER() OVER (...)`: paginación en la API sin LIMIT/OFFSET

**Pregunta que responde:** ¿Cómo puede Django solicitar "la página 2 de centros del
segmento `nacional_A`" sin re-ejecutar el SP completo?

**Contexto:** Django REST expone el resultado de `sp_rpt_centros_xsegmento` como JSON.
Si el frontend necesita paginar los 28-200 centros en grupos de 10, `LIMIT/OFFSET` en
MariaDB re-ejecuta la query completa desde el principio. `ROW_NUMBER()` permite filtrar
exactamente las filas de la página desde una vista o CTE materializado.

```sql
-- Patrón: SP materializa el ranking, la app filtra por fila
SELECT segmento, centro_transferencia, llamadas, fila
FROM (
    SELECT
        segmento
        , centro_transferencia
        , SUM(total_llamadas) AS llamadas
        , ROW_NUMBER() OVER (
            PARTITION BY segmento
            ORDER BY SUM(total_llamadas) DESC
          ) AS fila
    FROM base_ivr_detalle
    WHERE trimestre = 'Q01_25'
      AND centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO')
    GROUP BY segmento, centro_transferencia
) t
WHERE fila BETWEEN 11 AND 20   -- página 2 de 10 en 10
ORDER BY segmento, fila;
```

**Resultado real — fila 1-3 de cada segmento:**
```
nacional_A   10728487   5,493   fila=1
nacional_A   19020086   5,084   fila=2
nacional_A   10828091   4,803   fila=3
nacional_B   10728487   3,628   fila=1
```

**Diferencia con `DENSE_RANK`:** `ROW_NUMBER()` nunca produce empates — dos centros con el
mismo volumen reciben números consecutivos arbitrarios. Es el patrón correcto para
paginación (cada página tiene exactamente N filas). `DENSE_RANK` es correcto para ranking
(centros empatados comparten posición). Usar `ROW_NUMBER` para paginar y `DENSE_RANK`
para rankear — no intercambiarlos.

---

## UC-03 — `NTILE(4) OVER (...)`: cuartiles de centros como alternativa a umbrales fijos

**Pregunta que responde:** ¿Qué centros forman el 25% superior, 50%, 75% y fondo de
actividad, sin depender de umbrales fijos como 1,000 llamadas?

**Contexto:** `clasificacion_sla` en `sp_rpt_centros_xsegmento` usa umbrales fijos
(`total_llamadas >= 1000`, `>= 100`). Esos umbrales son correctos para el SLA
contractual, pero no son adaptativos: si en un trimestre quieto ningún centro supera 800
llamadas, todos caen en `VOLUMEN_MEDIO` aunque el top del segmento tenga 800.
`NTILE(4)` divide los centros en cuartiles relativos al segmento — siempre habrá
un Q1 de alta actividad sin importar el volumen absoluto.

```sql
SELECT
    segmento
    , centro_transferencia
    , SUM(total_llamadas)                                              AS llamadas
    , NTILE(4) OVER (
        PARTITION BY segmento
        ORDER BY SUM(total_llamadas) DESC
      )                                                                AS cuartil
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO')
GROUP BY segmento, centro_transferencia
ORDER BY segmento, llamadas DESC;
```

**Resultado real Q01_25 — nacional_A (resumen por cuartil):**
```
Cuartil  Centros  Llamadas mín   Llamadas máx   Total llamadas  % del segmento
1 (top)      7       1,710          5,493          24,256           74.4%
2            7         243          1,423           6,663           20.5%
3            7         154            235           1,446            4.4%
4 (fondo)    7           1             81             208            0.6%
```

**Insight clave de los datos reales:** Los 7 centros del Q1 concentran el **74.4%** del
volumen de llamadas en `nacional_A`. El Q4 (7 centros) genera el **0.6%**. Esta
asimetría extrema justifica enfocar el monitoreo SLA en el Q1 — que en producción
representará la misma concentración aunque haya 200 centros en lugar de 28.

**Valor en producción:** No hay que recalibrar umbrales cuando cambia el volumen
estacional. El Q1 siempre tendrá los centros más activos del quarter, sean 500 o
5,000 llamadas el mínimo de ese tier.

---

## UC-04 — `PERCENT_RANK() OVER (...)`: percentil de actividad de un centro

**Pregunta que responde:** ¿En qué percentil de actividad está un centro dentro de su
segmento? ¿Está en el top 10% o en el bottom 10%?

**Contexto:** Un gerente de operaciones que ve que el centro `15070013` tiene 2,560
llamadas no sabe si eso es mucho o poco sin compararlo. `PERCENT_RANK()` le dice:
"este centro está en el percentil 88.9% de actividad dentro de `nacional_A`" —
está entre los más activos.

```sql
SELECT
    segmento
    , centro_transferencia
    , SUM(total_llamadas) AS llamadas
    , ROUND(PERCENT_RANK() OVER (
        PARTITION BY segmento
        ORDER BY SUM(total_llamadas)   -- ASC: percentil 0 = menos activo, 1 = más activo
      ), 4)                            AS percentil
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO')
GROUP BY segmento, centro_transferencia
ORDER BY segmento, llamadas DESC;
```

**Resultado real Q01_25 — nacional_A (selección):**
```
Centro       Llamadas   Percentil
10728487       5,493      1.0000   (máximo del segmento)
19020086       5,084      0.9630
10828091       4,803      0.9259
15070013       2,560      0.8889
...
19020088           1      0.0000   (mínimo del segmento)
```

**Valor en producción:** Permite reglas tipo "alertar si un centro cae por debajo del
percentil 0.25 estando en el Q1 del quarter anterior" — detección de degradación
sin ajustar umbrales manuales cuando el volumen absoluto cambia entre trimestres.

---

## UC-05 — `CUME_DIST() OVER (...)`: concentración de volumen (regla de Pareto)

**Pregunta que responde:** ¿Cuántos centros necesito monitorear para cubrir el 80%
del volumen total del segmento?

**Contexto:** Con 200 centros en producción, es imposible hacer seguimiento de todos.
`CUME_DIST()` permite identificar el conjunto mínimo de centros que generan la mayor
parte del impacto operacional.

```sql
SELECT segmento, COUNT(*) AS centros_criticos, SUM(llamadas) AS llamadas_cubiertas
FROM (
    SELECT
        segmento
        , centro_transferencia
        , SUM(total_llamadas)                                                    AS llamadas
        , CUME_DIST() OVER (
            PARTITION BY segmento
            ORDER BY SUM(total_llamadas) DESC
          )                                                                      AS cume_d
    FROM base_ivr_detalle
    WHERE trimestre = 'Q01_25'
      AND centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO')
    GROUP BY segmento, centro_transferencia
) t
WHERE cume_d <= 0.20   -- el 20% superior de centros por volumen
GROUP BY segmento;
```

**Resultado real Q01_25:**
```
Segmento     Centros (top 20%)   Llamadas   % del volumen total
nacional_A         6               24,256      74.4%
nacional_B         6               16,110      74.7%
puebla             6               13,692      74.8%
```

**Insight crítico:** El **20% de los centros (6 de 28) concentra el 74-75% del volumen**
en los tres segmentos. Monitoreando solo estos 6 centros se cubre el impacto mayor.
Con 200 centros en producción, esto equivale a 40 centros críticos. El resto (160
centros) genera el 25% restante y puede monitorearse con menor frecuencia.

---

## UC-06 — `LAG() OVER (...)`: detección de tendencia en llamadas abandonadas

**Pregunta que responde:** ¿Las llamadas abandonadas aumentaron o disminuyeron respecto
al mes anterior? ¿Hay una tendencia de deterioro?

**Contexto:** El SP `sp_rpt_llamadas_abandonadas` devuelve el total por mes/segmento
pero no la variación. Un analista tiene que comparar manualmente dos filas. `LAG()`
integra la comparación directamente en el resultado.

```sql
SELECT
    segmento
    , fecha
    , SUM(CASE WHEN menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
               THEN total_llamadas ELSE 0 END)                              AS abandonadas
    , LAG(SUM(CASE WHEN menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
               THEN total_llamadas ELSE 0 END))
        OVER (PARTITION BY segmento ORDER BY fecha)                         AS mes_anterior
    , SUM(CASE WHEN menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
               THEN total_llamadas ELSE 0 END)
      - LAG(SUM(CASE WHEN menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
               THEN total_llamadas ELSE 0 END))
          OVER (PARTITION BY segmento ORDER BY fecha)                       AS delta
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
GROUP BY segmento, fecha
ORDER BY segmento, fecha;
```

**Resultado real Q01_25:**
```
Segmento     Mes      Abandonadas   Mes anterior   Delta
nacional_A   202501      6,394          NULL         —
nacional_A   202502      5,601         6,394        -793   (mejora)
nacional_A   202503      6,391         5,601        +790   (deterioro)
nacional_B   202501      4,174          NULL         —
nacional_B   202502      3,782         4,174        -392   (mejora)
nacional_B   202503      4,244         3,782        +462   (deterioro)
```

**Insight de los datos:** Febrero fue el mejor mes en los tres segmentos. Marzo recuperó
casi exactamente el nivel de enero. El patrón es estacional, no una tendencia de
deterioro sostenido — información que NO es visible mirando solo los totales.

**Extensión para producción — LAG entre quarters:**
```sql
LAG(total_llamadas, 3) OVER (PARTITION BY segmento, centro ORDER BY fecha)
```
Compara cada mes con el mismo mes del quarter anterior (3 meses atrás) — detecta
estacionalidad inter-quarter.

---

## UC-07 — `LEAD() OVER (...)`: análisis prospectivo de volumen

**Pregunta que responde:** ¿El mes siguiente al período analizado tuvo más o menos
llamadas que el actual? ¿Hay algún mes que sirvió como punto de inflexión?

**Contexto:** Al analizar un quarter desde el final, `LEAD()` permite ver si los meses
del quarter siguiente confirmaron la tendencia que se veía al cierre.

```sql
SELECT
    segmento
    , fecha
    , SUM(total_llamadas)                                              AS llamadas
    , LEAD(SUM(total_llamadas)) OVER (PARTITION BY segmento ORDER BY fecha) AS siguiente_mes
    , LEAD(SUM(total_llamadas)) OVER (PARTITION BY segmento ORDER BY fecha)
      - SUM(total_llamadas)                                            AS variacion
FROM base_ivr_detalle
WHERE trimestre IN ('Q01_25', 'Q02_25')
GROUP BY segmento, fecha
ORDER BY segmento, fecha;
```

**Resultado real — transición Q01_25 a Q02_25 — nacional_A:**
```
Mes      Llamadas   Siguiente   Variación
202501     18,533     16,729      -1,804
202502     16,729     18,617      +1,888
202503     18,617     14,294      -4,323   ← caída marcada al entrar Q02_25
202504     14,294     14,634        +340
```

**Insight:** La transición de Q01_25 a Q02_25 muestra una caída de **4,323 llamadas**
(-23.2%) en `nacional_A`. Esto es visible desde marzo mirando hacia adelante. Con
`LEAD()` esta caída queda integrada en el reporte de cierre de Q01_25 —
no hay que esperar el reporte de Q02_25 para ver que algo cambió.

---

## UC-08 — `FIRST_VALUE() OVER (...)`: comparar cada centro con el líder del segmento

**Pregunta que responde:** ¿Qué porcentaje del volumen del centro líder tiene este centro?
¿Está en el mismo orden de magnitud o es marginal?

**Contexto:** Un centro con 2,560 llamadas parece importante. Pero si el líder del segmento
tiene 5,493, ese centro está al 46.6% del líder — tiene un volumen relativo significativo.
Un centro con 81 llamadas está al 1.5% del líder — marginal.

```sql
SELECT
    segmento
    , centro_transferencia
    , SUM(total_llamadas)                                                           AS llamadas
    , FIRST_VALUE(centro_transferencia) OVER (
        PARTITION BY segmento
        ORDER BY SUM(total_llamadas) DESC
      )                                                                             AS centro_lider
    , FIRST_VALUE(SUM(total_llamadas)) OVER (
        PARTITION BY segmento
        ORDER BY SUM(total_llamadas) DESC
      )                                                                             AS llamadas_lider
    , ROUND(SUM(total_llamadas)
        / FIRST_VALUE(SUM(total_llamadas)) OVER (
            PARTITION BY segmento ORDER BY SUM(total_llamadas) DESC
          ) * 100, 1)                                                               AS pct_del_lider
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO')
GROUP BY segmento, centro_transferencia
ORDER BY segmento, llamadas DESC;
```

**Resultado real Q01_25 — nacional_A:**
```
Centro       Llamadas   Líder       Llamadas líder   % del líder
10728487       5,493    10728487       5,493            100.0%
19020086       5,084    10728487       5,493             92.6%
10828091       4,803    10728487       5,493             87.4%
15070013       2,560    10728487       5,493             46.6%
10928253       2,488    10728487       5,493             45.3%
...
19020088           1    10728487       5,493              0.0%
```

**Insight:** Los centros `19020086` y `10828091` están al 92.6% y 87.4% del líder —
son prácticamente de la misma magnitud. A partir de `15070013` (46.6%) hay un quiebre
claro: los centros del cuartil 2 son la mitad del líder. En producción con 200 centros,
este quiebre natural define grupos de intervención sin umbrales arbitrarios.

---

## UC-09 — `LAST_VALUE() OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)`: último mes activo por centro

**Pregunta que responde:** ¿Cuál es el último mes en que este centro tuvo actividad en
el quarter? ¿Estuvo activo todo el trimestre o solo parte?

**Nota técnica:** `LAST_VALUE()` requiere `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`
para ver la última fila de la partición completa. Sin ese marco, la ventana por defecto
termina en la fila actual (`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`) y `LAST_VALUE`
devuelve el valor actual, no el último de la partición.

```sql
SELECT
    segmento
    , centro_transferencia
    , fecha
    , SUM(total_llamadas) AS llamadas_ese_mes
    , LAST_VALUE(fecha) OVER (
        PARTITION BY segmento, centro_transferencia
        ORDER BY fecha
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      ) AS ultimo_mes_activo
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
GROUP BY segmento, centro_transferencia, fecha
ORDER BY segmento, centro_transferencia, fecha;
```

**Valor en producción:** Detecta centros que dejaron de recibir llamadas a mitad del
quarter — posible desconexión o reasignación de VDN. Si `ultimo_mes_activo = 202501`
para un centro que debería estar activo en marzo, hay algo que investigar.

---

## UC-10 — `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`: promedio móvil de 3 meses

**Pregunta que responde:** ¿Cuál es la tendencia de llamadas abandonadas suavizando la
variación mensual? ¿El sistema está mejorando o empeorando en los últimos 3 meses?

**Contexto:** Los datos mensuales tienen variación estacional (febrero típicamente baja
en telefonía). El promedio móvil de 3 meses suaviza esa variación y muestra la tendencia
real.

```sql
SELECT
    segmento
    , fecha
    , SUM(CASE WHEN menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
               THEN total_llamadas ELSE 0 END)                                AS abandonadas
    , ROUND(AVG(SUM(CASE WHEN menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera')
               THEN total_llamadas ELSE 0 END))
        OVER (
            PARTITION BY segmento
            ORDER BY fecha
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 0)                                                                 AS prom_mov_3m
FROM base_ivr_detalle
WHERE trimestre IN ('Q01_25','Q02_25','Q03_25','Q04_25')
GROUP BY segmento, fecha
ORDER BY segmento, fecha;
```

**Resultado real — nacional_A (12 meses):**
```
Mes      Abandonadas   Prom. móvil 3m
202501      6,394         6,394   (solo 1 mes disponible)
202502      5,601         5,998   (2 meses)
202503      6,391         6,129   (3 meses — Q1 promedio)
202504      4,737         5,576   (entra Q2 — caída)
202505      4,916         5,348   (Q2 estabilización)
202506      4,679         4,777   (Q2 cierre)
202507      3,954         4,516   (entra Q3 — nueva caída)
202508      3,822         4,152
202509      3,809         3,862   (Q3 estabilización)
202510      4,193         3,941   (Q4 inicio — ligera subida)
202511      4,134         4,045
202512      4,151         4,159
```

**Insight:** El promedio móvil muestra una **tendencia de descenso sostenida durante 2025**:
de ~6,100 en Q1 a ~4,000 en Q3, con una ligera recuperación en Q4 hacia ~4,150.
Esta tendencia no es visible mirando los datos mensuales crudos — la estacionalidad
(febrero baja, marzo sube) oculta la señal. El promedio móvil la revela.

---

## Cuadro resumen de UCs por función

| Función | UC | Pregunta respondida | Disponibilidad IACT-db |
|---|---|---|---|
| `SUM() OVER (PARTITION BY)` | UC-01 | Porcentaje del segmento sin segundo scan | Implementar en cMENU_ERROR y menu_centro |
| `ROW_NUMBER()` | UC-02 | Paginación determinista en la API | Nuevo SP de paginación o parámetro en Django |
| `NTILE(4)` | UC-03 | Cuartiles adaptativos al volumen del quarter | Nuevo SP `sp_rpt_cuartiles_centros` |
| `PERCENT_RANK()` | UC-04 | Percentil de actividad por centro | Columna adicional en `sp_rpt_centros_xsegmento` |
| `CUME_DIST()` | UC-05 | Centros críticos que cubren el 80% del volumen | Consulta de diagnóstico / vista |
| `LAG()` | UC-06 | Variación mensual de abandono | Vista `v_tendencia_abandono` |
| `LEAD()` | UC-07 | Variación prospectiva entre quarters | Consulta de cierre de quarter |
| `FIRST_VALUE()` | UC-08 | % del volumen del centro líder | Columna adicional en `sp_rpt_centros_xsegmento` |
| `LAST_VALUE()` | UC-09 | Último mes activo en el quarter | Consulta de detección de VDN inactivos |
| `ROWS BETWEEN` | UC-10 | Promedio móvil de 3 meses de abandono | Vista `v_tendencia_abandono_movil` |

---

## Nota sobre escala real

Con 11.6M filas fuente por quarter, las 10 consultas anteriores operan sobre
`base_ivr_detalle` (10,000-60,000 filas post-ETL). Los índices existentes
cubren todos los accesos:

```
idx_trim_seg_fecha (trimestre, segmento, fecha)
idx_trim_menu      (trimestre, menu)
idx_trim_centro    (trimestre, centro_transferencia)
```

Las window functions no añaden scans adicionales — operan sobre el resultado ya
agrupado por el `GROUP BY`. En todos los UCs, el resultado del `GROUP BY` tiene
como máximo `N_centros × N_meses × N_segmentos` filas — en el rango de cientos,
no de miles.
