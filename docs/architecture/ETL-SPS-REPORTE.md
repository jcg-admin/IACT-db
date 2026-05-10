# Los 7 Stored Procedures de Reporte IVR

**Fecha:** 2026-05-06
**Fuentes:** WPs `2026-05-02-07-12-32-pipeline-uc-deepening` y
`2026-05-02-09-54-55-source-corrections-pipeline` del repositorio IACT-docs.

> **Corrección respecto a ETL-ANALISIS.md:** El análisis anterior
> incluía `sp_rpt_colgadas` y `sp_rpt_clientes_unicos` (nombres incorrectos).
> La lista canónica confirmada por el equipo es la que se documenta aquí.

---

## Lista canónica de los 7 SPs

| # | Stored Procedure | UC IVR | Fuente de datos |
|---|---|---|---|
| 1 | `sp_rpt_centros_transferencia` | UC_RPT_15 (parcial) | `base_ivr_detalle` |
| 2 | `sp_rpt_centros_xsegmento` | UC_RPT_01, UC_RPT_15 | `base_ivr_detalle` |
| 3 | `sp_rpt_llamadas_abandonadas` | UC_RPT_13 | `base_ivr_detalle` |
| 4 | `sp_rpt_menu_redirigidos` | UC_RPT_16 | `base_ivr_detalle` |
| 5 | `sp_rpt_menu_centro` | UC_RPT_16 | `base_ivr_detalle` |
| 6 | `sp_rpt_cMENU_ERROR` | UC_RPT_16 | `base_ivr_detalle` |
| 7 | `sp_rpt_clientes` | UC_RPT_17 | `base_ivr_clientes` |

Todos son **read-only**. Django los llama bajo demanda con
`cursor.callproc()`. Ninguno modifica datos.

---

## Relación con los scripts SQL de producción

Cada SP tiene su origen en un script de análisis ad-hoc del equipo.
Los SPs son la versión parametrizada y estable de esos scripts:

| SP | Script SQL de origen | Origen del nombre |
|---|---|---|
| `sp_rpt_centros_transferencia` | `Script_Centros_Transferencia.sql` | Centros destino de llamadas con métricas detalladas |
| `sp_rpt_centros_xsegmento` | `Script_Centros_Dias_Habiles.sql` | Centros **por segmento** con dias de semana y clasificación SLA |
| `sp_rpt_llamadas_abandonadas` | `Script_Llamadas_Abandonadas.sql` | Tasa de abandono por menú |
| `sp_rpt_menu_redirigidos` | `Script_Transfer_Menu_Opcion.sql` (parte) | Menús que disparan redirección a un centro |
| `sp_rpt_menu_centro` | `q_menu_centro_transferecia_010925.sql` | Menús y opciones agrupados por centro destino |
| `sp_rpt_cMENU_ERROR` | `q_cMENU_ERROR.sql` | Anomalías: cMenu contiene número de teléfono |
| `sp_rpt_clientes` | `Script_Clientes_Unicos_DID_Trimestre.sql` | Clientes únicos por DID y trimestre |

---

## SP 1 — sp_rpt_centros_transferencia

**Propósito:** Detalle de transferencias por centro destino, con métricas
de comportamiento del llamante (misma línea, línea diferente, no digitó).

**Firma:**
```sql
CALL sp_rpt_centros_transferencia(@quarter, @segmento);
-- @quarter: 'Q01_25', 'Q02_25', 'Q03_25', 'Q04_25', 'Q01_26', 'Q02_26'
-- @segmento: 'Puebla', 'nacional_A', 'nacional_B', o 'Nacional' (ver D-23)
```

**Columnas del result set (PROVEN — de datos reales 2026-05-02):**

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', 'Q02_25', etc. |
| `fecha` | VARCHAR(6) | YYYYMM: '202501', '202502'... |
| `segmento` | VARCHAR(20) | 'Puebla', 'nacional_A', 'nacional_B' |
| `centro_transferencia` | VARCHAR(100) | VDN normalizado, o sentinel: 'CASO_NULL', 'CASO_ERROR_CEROS', 'CLIENTE_COLGO' |
| `menu` | VARCHAR(100) | Menú IVR (ver catálogo de valores reales) |
| `opcion` | VARCHAR(100) | Opción dentro del menú, o 'SIN_OPCION' |
| `total_llamadas` | INT | Conteo agregado por (fecha, segmento, centro, menu, opcion) |
| `porcentaje` | DECIMAL(15,7) | % respecto al total del segmento en esa fecha |
| `misma_linea` | INT | Llamantes donde cTelefono_Origen = cTelefono_Digitado |
| `linea_diferente` | INT | Llamantes donde cTelefono_Origen ≠ cTelefono_Digitado |
| `no_digito_telefono` | INT | Llamantes donde cTelefono_Digitado IS NULL |

**SQL base (MariaDB 10.1 — sin window functions):**
```sql
SELECT
    t.trimestre,
    t.fecha,
    t.segmento,
    t.centro_transferencia,
    t.menu,
    t.opcion,
    t.total_llamadas,
    ROUND(t.total_llamadas /
          (SELECT SUM(t2.total_llamadas)
           FROM   base_ivr_detalle t2
           WHERE  t2.trimestre = t.trimestre
             AND  t2.fecha     = t.fecha
             AND  t2.segmento  = t.segmento)
          * 100, 7)           AS porcentaje,
    t.misma_linea,
    t.linea_diferente,
    t.no_digito_telefono
FROM   base_ivr_detalle t
WHERE  t.trimestre = @quarter
  AND  t.segmento  = @segmento   -- ver D-23 para 'Nacional'
ORDER BY t.fecha, t.total_llamadas DESC;
```

**Nota D-23:** Cuando `@segmento = 'Nacional'`, el SP debe filtrar
`IN ('nacional_A', 'nacional_B')` y agregar las filas. `nacional_A`
domina (~93-99% del volumen Nacional). Nunca filtrar por un solo DID
cuando se quiere el total Nacional.

**Riesgo:** El porcentaje usa subconsulta correlacionada (sin window
functions) — puede ser lento si `base_ivr_detalle` crece. Mitigación:
el índice `idx_quarter_fecha` en `base_ivr_detalle` acelera la subconsulta.

---

## SP 2 — sp_rpt_centros_xsegmento

**Propósito:** KPIs de centros de transferencia **por segmento**,
con clasificación de centros según patrón de uso (empresarial/mixto/
personal) y estado SLA en dias de semana. Es el SP de nivel resumen
(dashboard); `sp_rpt_centros_transferencia` es el detalle.

**Firma:**
```sql
CALL sp_rpt_centros_xsegmento(@quarter);
-- Devuelve métricas para TODOS los segmentos en un solo result set
```

**Columnas del result set (INFERRED de Script_Centros_Dias_Habiles.sql):**

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', etc. |
| `segmento` | VARCHAR(20) | 'Puebla', 'nacional_A', 'nacional_B' |
| `centro_transferencia` | VARCHAR(100) | VDN normalizado |
| `total_llamadas` | INT | Total del quarter para ese centro+segmento |
| `llamadas_entre_semana` | INT | Llamadas en dias de semana (`fn_es_dia_semana`) |
| `llamadas_fines_semana` | INT | Llamadas en fin de semana |
| `dias_semana_desde_hoy` | INT | Dias de semana desde la última llamada (`fn_contar_dias_semana`) |
| `patron_uso_centro` | VARCHAR(20) | 'CENTRO_EMPRESARIAL' / 'CENTRO_MIXTO' / 'CENTRO_PERSONAL' |
| `clasificacion_centro` | VARCHAR(40) | 'CENTRO_CRITICO_ACTIVO' / 'CENTRO_ALTO_VOLUMEN_INACTIVO' / 'CENTRO_VOLUMEN_MEDIO' / 'CENTRO_BAJO_VOLUMEN' |
| `estado_sla` | VARCHAR(30) | 'DENTRO_SLA_HOY' / 'DENTRO_SLA_3_DIAS' / 'FUERA_SLA_CRITICO' / 'FUERA_SLA_ESCALAMIENTO' |

**Lógica de clasificación (PROVEN del script):**

```sql
-- Patrón de uso por proporción de dias de semana vs fines de semana
CASE
    WHEN llamadas_entre_semana / total >= 0.8 THEN 'CENTRO_EMPRESARIAL'
    WHEN llamadas_fines_semana / total >= 0.4 THEN 'CENTRO_MIXTO'
    ELSE                                           'CENTRO_PERSONAL'
END AS patron_uso_centro

-- Clasificación por volumen y actividad reciente
CASE
    WHEN COUNT(*) >= 20 AND dias_semana_desde_hoy <= 1 THEN 'CENTRO_CRITICO_ACTIVO'
    WHEN COUNT(*) >= 20 AND dias_semana_desde_hoy >  3 THEN 'CENTRO_ALTO_VOLUMEN_INACTIVO'
    WHEN COUNT(*) >= 10                                  THEN 'CENTRO_VOLUMEN_MEDIO'
    ELSE                                                      'CENTRO_BAJO_VOLUMEN'
END AS clasificacion_centro

-- Estado SLA
CASE
    WHEN dias_habiles <= 0 THEN 'DENTRO_SLA_HOY'
    WHEN dias_habiles <= 3 THEN 'DENTRO_SLA_3_DIAS'
    WHEN dias_habiles <= 5 THEN 'FUERA_SLA_CRITICO'
    ELSE                        'FUERA_SLA_ESCALAMIENTO'
END AS estado_sla
```

**Dependencia de funciones MySQL embebidas:**

Este es el único SP que requiere las tres funciones de dias de semana:
`fn_es_dia_semana(fecha)`, `fn_contar_dias_semana(ini, fin)`,
`fn_agregar_dias_semana(fecha, n)`. Estas funciones deben crearse
antes que este SP. Son propiedad de la BD IVR del cliente (no de IACT),
por lo que su existencia debe verificarse antes de crear el SP.

**Diferencia con sp_rpt_centros_transferencia:**

| Dimensión | sp_rpt_centros_transferencia | sp_rpt_centros_xsegmento |
|---|---|---|
| Nivel | Detalle por (fecha, segmento, centro, menu, opcion) | Resumen por (segmento, centro) |
| Filtro | Un segmento a la vez | Todos los segmentos juntos |
| Métricas | Conteo por combinación menú+opción | KPIs + clasificación SLA + dias de semana |
| UC | UC_RPT_15 (histórico detallado) | UC_RPT_01 (dashboard), UC_RPT_15 |
| Dependencias | Solo `base_ivr_detalle` | `base_ivr_detalle` + funciones `fn_*` |

---

## SP 3 — sp_rpt_llamadas_abandonadas

**Propósito:** Tasa de abandono por menú y quarter.

**Firma:**
```sql
CALL sp_rpt_llamadas_abandonadas(@quarter);
```

**Columnas del result set:**

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', etc. |
| `menu` | VARCHAR(100) | Valor de menú (incluye sentinels) |
| `total_llamadas` | INT | Total de llamadas con ese menú en el quarter |
| `es_abandono` | TINYINT | 1 si menu IN ('VACIO','cliente_colgo','SinOpcion_Cabecera') |
| `pct_abandono` | DECIMAL(5,2) | % de abandono del total del quarter |

**Definición correcta de abandono (CONFIRMED — D-ETL-006):**

```sql
WHERE menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
```

Tres categorías de abandono:

| Categoría | Descripción | Proporción real Q3 2025 |
|---|---|---|
| `VACIO` | Llamada sin menú (cMenu vacío/NULL en fuente) | ~8-9% |
| `cliente_colgo` | Llegó al menú y colgó explícitamente | ~52% del volumen total |
| `SinOpcion_Cabecera` | Llegó al menú pero no eligió opción | ~3-4% |
| **Total abandono** | | **~27-28% del total de llamadas** |

**Alerta crítica — implementación actual incorrecta:**

El SP actual (si ya existe en producción) probablemente solo cuenta `VACIO`
(~8-9%). La corrección a la definición completa cambia los números de un
factor de 3. Los umbrales operativos deben recalibrarse (D-ETL-007):

| Umbral | Anterior (incorrecto) | Correcto (calibrado a datos reales) |
|---|---|---|
| Óptimo | < 5% | < 20% |
| Aceptable | 5-10% | 20-30% |
| Crítico | > 10% | > 30% |

**Exclusiones del cálculo:**

`Desborde_Cabecera` y `Desborde_Promocional` NO son abandono.
Son enrutamientos válidos por etiqueta de cliente y deben excluirse
del denominador de abandono o tratarse como categoría separada.

---

## SP 4 — sp_rpt_menu_redirigidos

**Propósito:** Lista de menús que dispararon una redirección a un
centro de transferencia. Responde: "¿desde qué menú llegaron las
llamadas a cada centro?"

**Firma:**
```sql
CALL sp_rpt_menu_redirigidos(@quarter);
```

**Columnas del result set (INFERRED — pendiente confirmar P-13):**

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', etc. |
| `menu` | VARCHAR(100) | Menú desde el que se redirigió |
| `centro_transferencia` | VARCHAR(100) | Centro destino de la redirección |
| `total_llamadas` | INT | Total de llamadas redirigidas por esa combinación |

**SQL base:**
```sql
SELECT trimestre, menu, centro_transferencia,
       SUM(total_llamadas) AS total_llamadas
FROM   base_ivr_detalle
WHERE  trimestre = @quarter
  AND  centro_transferencia NOT IN
       ('CASO_NULL', 'CASO_ERROR_CEROS', 'CLIENTE_COLGO')
GROUP BY trimestre, menu, centro_transferencia
ORDER BY total_llamadas DESC;
```

**Regla de negocio:**

`Desborde_Cabecera` **SÍ** debe incluirse (es una redirección válida
por etiqueta de cliente). `cliente_colgo` en `centro_transferencia`
**NO** debe incluirse (no es una redirección — el cliente colgó).

**Pendiente P-13:** Confirmar con el equipo si este SP necesita columnas
adicionales de la vista `llamadas_QN` (etiquetas, nidMQ) que no están
en `base_ivr_detalle`. Si sí, el ETL necesita un 3er scan nocturno o
una tabla base adicional.

---

## SP 5 — sp_rpt_menu_centro

**Propósito:** Para cada centro de transferencia, muestra qué menús
y opciones le llegaron y en qué proporción. Responde: "¿qué flujos
de IVR llevan a cada centro?"

**Firma:**
```sql
CALL sp_rpt_menu_centro(@quarter, @segmento);
```

**Columnas del result set:**

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', etc. |
| `segmento` | VARCHAR(20) | 'Puebla', 'nacional_A', 'nacional_B' |
| `centro_transferencia` | VARCHAR(100) | VDN normalizado |
| `menu` | VARCHAR(100) | Menú que llegó a ese centro |
| `opcion` | VARCHAR(100) | Opción dentro del menú |
| `ejecuciones` | INT | Total de llamadas por esa combinación |
| `pct_dentro_centro` | DECIMAL(5,2) | % que representa esa combinación dentro del total del centro |

**SQL base (sin window functions — MariaDB 10.1):**
```sql
SELECT
    t.trimestre,
    t.segmento,
    t.centro_transferencia,
    t.menu,
    t.opcion,
    SUM(t.total_llamadas)   AS ejecuciones,
    ROUND(SUM(t.total_llamadas) /
          tot.total_centro * 100, 2) AS pct_dentro_centro
FROM   base_ivr_detalle t
JOIN   (SELECT centro_transferencia,
               SUM(total_llamadas) AS total_centro
        FROM   base_ivr_detalle
        WHERE  trimestre = @quarter
          AND  segmento  = @segmento
        GROUP BY centro_transferencia) tot
       ON tot.centro_transferencia = t.centro_transferencia
WHERE  t.trimestre = @quarter
  AND  t.segmento  = @segmento
GROUP BY t.trimestre, t.segmento, t.centro_transferencia, t.menu, t.opcion
ORDER BY t.centro_transferencia, ejecuciones DESC;
```

**Diferencia con sp_rpt_menu_redirigidos:**

| Dimensión | sp_rpt_menu_redirigidos | sp_rpt_menu_centro |
|---|---|---|
| Perspectiva | Menú → Centro (origen del flujo) | Centro → Menú (composición del tráfico) |
| Agrupación | Por menú y centro destino | Por centro, menú y opción |
| Filtro | Sin filtro de segmento | Por segmento |
| Métrica | Conteo total | Conteo + % dentro del centro |

---

## SP 6 — sp_rpt_cMENU_ERROR

**Propósito:** Detectar anomalías donde `cMenu` contiene un número
de teléfono en lugar de un nombre de menú. Esto indica un fallo del
IVR al registrar el menú navegado.

**Firma:**
```sql
CALL sp_rpt_cMENU_ERROR(@quarter);
```

**Columnas del result set:**

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', etc. |
| `menu` | VARCHAR(100) | El valor numérico/telefónico que aparece en cMenu |
| `total` | INT | Cuántas veces aparece esa anomalía |

**SQL base:**
```sql
SELECT trimestre, menu,
       SUM(total_llamadas) AS total
FROM   base_ivr_detalle
WHERE  trimestre = @quarter
  AND  menu REGEXP '^[0-9]+'
GROUP BY trimestre, menu
ORDER BY total DESC;
```

**Valor sentinel `telefono_cMenu`:** En los datos reales se identificó
el valor literal `'telefono_cMenu'` como sentinel que indica esta
anomalía. El SP debe cubrir tanto el patrón regex `^[0-9]+` como
este sentinel explícito.

**Usos:**
- Monitoreo de calidad de datos del IVR
- Identificar cuándo el sistema IVR falla en registrar el menú
- Comparar la tasa de anomalías entre quarters (¿está empeorando?)

---

## SP 7 — sp_rpt_clientes

**Propósito:** Clientes únicos (teléfonos únicos digitados) por
segmento y quarter. Responde: "¿cuántos clientes diferentes llamaron?"

**Firma:**
```sql
CALL sp_rpt_clientes(@quarter);
```

**Columnas del result set (PROVEN — de datos reales 2026-05-02):**

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', 'Q02_25', 'Q03_25' |
| `segmento` | VARCHAR(20) | 'Puebla', 'nacional_A', 'nacional_B' |
| `clientes_unicos` | INT | COUNT(DISTINCT cTelefono_Digitado) en el quarter+segmento |

**SQL base:**
```sql
SELECT trimestre, segmento, clientes_unicos
FROM   base_ivr_clientes
WHERE  trimestre = @quarter
ORDER BY segmento;
-- Retorna 3 filas: una por segmento (Puebla, nacional_A, nacional_B)
```

**Volúmenes reales (PROVEN — Q01+Q02+Q03 2025):**

Suma total de `clientes_unicos` en los tres primeros quarters de 2025:
**9,617,998 clientes únicos** en todos los segmentos combinados.

**Por qué está en una tabla separada:**

`COUNT(DISTINCT cTelefono_Digitado)` es una métrica **no aditiva**:
no puede derivarse sumando filas de `base_ivr_detalle` (que ya está
agregada). Requiere su propio scan sobre la tabla fuente
(`tbl_historico_*`) con acceso a los teléfonos individuales.
Por eso el ETL tiene dos SPs distintos: `sp_etl_base_detalle` y
`sp_etl_base_clientes`.

**Casos especiales:**

- Llamantes que no digitaron teléfono (`cTelefono_Digitado IS NULL`)
  quedan excluidos del conteo — son las mismas llamadas de
  `no_digito_telefono` en `base_ivr_detalle`.
- Un mismo cliente que llama en Q1 y Q2 se cuenta en ambos quarters
  (el conteo es por quarter, no acumulado histórico).

---

## Resumen: qué hace cada SP y desde dónde

```
base_ivr_detalle (miles de filas, con índices)
  │
  ├── sp_rpt_centros_transferencia(@quarter, @segmento)
  │     Detalle: fecha × segmento × centro × menu × opcion
  │     Métricas: total, %, misma_linea, linea_diferente, no_digitó
  │
  ├── sp_rpt_centros_xsegmento(@quarter)
  │     Resumen: segmento × centro
  │     Métricas: total, dias de semana, clasificación SLA
  │     Depende de: fn_es_dia_semana, fn_contar_dias_semana
  │
  ├── sp_rpt_llamadas_abandonadas(@quarter)
  │     Abandono: VACIO + cliente_colgo + SinOpcion_Cabecera
  │     Resultado: total + % de abandono del quarter
  │
  ├── sp_rpt_menu_redirigidos(@quarter)
  │     Perspectiva: menú → centro (flujo de origen)
  │     Pendiente P-13: ¿necesita llamadas_QN?
  │
  ├── sp_rpt_menu_centro(@quarter, @segmento)
  │     Perspectiva: centro → menú+opcion (composición del tráfico)
  │     Métricas: ejecuciones + % dentro del centro
  │
  └── sp_rpt_cMENU_ERROR(@quarter)
        Anomalías: cMenu contiene número de teléfono
        Uso: calidad de datos

base_ivr_clientes (3 filas por quarter, con índices)
  │
  └── sp_rpt_clientes(@quarter)
        Clientes únicos por segmento
        Métrica no aditiva — requiere tabla propia
```

---

## Dependencias de creación

El orden de creación es estricto:

```
1. Funciones de negocio (si no existen ya en MariaDB del cliente):
     fn_es_dia_semana(fecha)
     fn_contar_dias_semana(fecha_ini, fecha_fin)
     fn_agregar_dias_semana(fecha, n)
   ↓
2. Tablas base ETL:
     base_ivr_detalle
     base_ivr_clientes
   ↓
3. SPs ETL (llenan las tablas base):
     sp_etl_base_detalle
     sp_etl_base_clientes
     sp_etl_maestro
   ↓
4. SPs de reporte (leen las tablas base):
     sp_rpt_centros_transferencia   ← solo base_ivr_detalle
     sp_rpt_llamadas_abandonadas    ← solo base_ivr_detalle
     sp_rpt_menu_redirigidos        ← solo base_ivr_detalle (pendiente P-13)
     sp_rpt_menu_centro             ← solo base_ivr_detalle
     sp_rpt_cMENU_ERROR             ← solo base_ivr_detalle
     sp_rpt_clientes                ← solo base_ivr_clientes
     sp_rpt_centros_xsegmento      ← base_ivr_detalle + fn_es_dia_semana + fn_contar_dias
```

Los primeros 6 SPs de reporte pueden crearse en cualquier orden entre ellos.
`sp_rpt_centros_xsegmento` debe ir último (dependencia de las funciones `fn_*`).

---

## Riesgos específicos de los SPs de reporte

| SP | Riesgo | Mitigación |
|---|---|---|
| `sp_rpt_centros_transferencia` | Subconsulta correlacionada lenta si base_ivr_detalle crece | Índice `idx_quarter_fecha_segmento` en base_ivr_detalle |
| `sp_rpt_centros_xsegmento` | Las funciones `fn_*` pueden no existir en la BD del cliente | Verificar antes de crear el SP; documentar como prerrequisito |
| `sp_rpt_llamadas_abandonadas` | Sub-reporte de abandono si solo se cuenta VACIO | Implementar las 3 categorías desde el inicio; nunca desplegar el SP incompleto |
| `sp_rpt_menu_redirigidos` | Puede necesitar columnas de llamadas_QN no en base_ivr_detalle | Confirmar P-13 antes de implementar |
| `sp_rpt_menu_centro` | JOIN a subconsulta puede ser lento con muchos centros | Índice `idx_quarter_segmento_centro` |
| `sp_rpt_cMENU_ERROR` | REGEXP lento en tablas grandes | base_ivr_detalle es pequeña (miles de filas) — no es problema |
| `sp_rpt_clientes` | Devuelve siempre 3 filas — si falta un segmento, row ausente en lugar de 0 | Validar en Django que lleguen los 3 segmentos o rellenar con 0 |

---

## Pendientes antes de implementar

| # | Pregunta | Afecta |
|---|---|---|
| P-13 | ¿`sp_rpt_menu_redirigidos` necesita columnas de la vista `llamadas_QN` (etiquetas, nidMQ) que no están en `base_ivr_detalle`? | Si SÍ: el ETL necesita un 3er scan o tabla base adicional |
| P-14 | ¿Existen las funciones `fn_es_dia_semana`, `fn_contar_dias_semana`, `fn_agregar_dias_semana` en MariaDB del cliente? | Si NO: deben crearse antes de `sp_rpt_centros_xsegmento` |
| G-28 | ¿El reporte `llamadas_cmenu` (todos los menús, 34M llamadas) mapea a `base_ivr_detalle` completa o necesita tabla propia? | Si necesita tabla propia: 8° reporte fuera del Scope 1 original |
| G-29 | ¿Cuál es la causa exacta del defecto en `dFecha`/`dHoraFin` en `tbl_historico_t2/t3_2025`? | Afecta la confiabilidad de cualquier cálculo de duración |

---

## Cómo Django llama cada SP

```python
from django.db import connections

def call_sp(sp_name, params):
    """Wrapper genérico para llamar cualquier SP de reporte IVR."""
    with connections['ivr'].cursor() as cursor:
        cursor.callproc(sp_name, params)
        columns = [col[0] for col in cursor.description]
        return [dict(zip(columns, row)) for row in cursor.fetchall()]

# Ejemplos de uso:
def get_centros_transferencia(quarter, segmento):
    return call_sp('sp_rpt_centros_transferencia', [quarter, segmento])

def get_centros_xsegmento(quarter):
    return call_sp('sp_rpt_centros_xsegmento', [quarter])

def get_llamadas_abandonadas(quarter):
    return call_sp('sp_rpt_llamadas_abandonadas', [quarter])

def get_menu_redirigidos(quarter):
    return call_sp('sp_rpt_menu_redirigidos', [quarter])

def get_menu_centro(quarter, segmento):
    return call_sp('sp_rpt_menu_centro', [quarter, segmento])

def get_cmenu_error(quarter):
    return call_sp('sp_rpt_cMENU_ERROR', [quarter])

def get_clientes(quarter):
    return call_sp('sp_rpt_clientes', [quarter])
```

El patrón `cursor.callproc()` desacopla Django del schema interno de
`base_ivr_*`. Si un SP cambia internamente (nueva columna, nuevo cálculo),
Django solo ve el nuevo result set sin modificar modelos ORM.

---

## Ver también

- `ETL-ANALISIS.md` — flujo ETL completo (SPs ETL + Event + arquitectura general)
- `HISTORICO-IVR.md` — schema y seed de las tablas fuente `tbl_historico_*`
- WP `2026-05-02-07-12-32-pipeline-uc-deepening/discover/etl-job-flow-design.md`
- WP `2026-05-02-07-12-32-pipeline-uc-deepening/discover/reports-uc-analysis.md`
- WP `2026-05-02-09-54-55-source-corrections-pipeline/discover/decisions.md`
