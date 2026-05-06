# Script: Detalle Transferencia / Menu / Opcion

**Reporte destino:** `sp_rpt_centros_transferencia`
**Tabla base:** `base_ivr_detalle`
**Estado:** En producción como scripts ad-hoc — pendiente migrar a SP

---

## Versiones disponibles

| Archivo | Versión | Cambio principal |
|---|---|---|
| `v0.0.1_q_REP_DETALLE_TRANSFERENCIA_MENU_OPCION.sql` | 0.0.1 | Primera versión — JOIN para totales, sin dimensión fecha |
| `v0.1.1_q_REP_DETALLE_TRANSFERENCIA_MENU_OPCION.sql` | 0.1.1 | Factor de corrección de porcentajes (suma exacta a 100%) |
| `v0.2.1_q_REP_DETALLE_TRANSFERENCIA_MENU_OPCION.sql` | 0.2.1 | Normalización de cMenu numérico (MENU_10_NUMEROS, MENU_11_NUMEROS) |
| `v0.3.1_q_REP_DETALLE_TRANSFERENCIA_MENU_OPCION.sql` | 0.3.1 | **Versión actual** — agrega dimensión fecha (YYYYMM), nombres de columna definitivos |

La versión **v0.3.1** es la referencia para el diseño del SP.

---

## Evolución entre versiones

### v0.0.1 → v0.1.1: corrección de porcentajes

El porcentaje en v0.0.1 se calcula con `ROUND(..., 4)` sobre el total
del trimestre. Al redondear, la suma de todos los porcentajes no llega
exactamente a 100.0000. La v0.1.1 introduce un `@factor_correccion_tN`
que ajusta el porcentaje multiplicativo para que la suma sea exacta.

El mecanismo: calcular el `SUM(porcentaje)` del GROUP BY con la misma
lógica, luego escalar cada fila por `100.0 / SUM(porcentaje)`.

**Tradeoff:** requiere 2 scans adicionales por quarter (uno para el total,
otro para el factor). Para el SP de producción se descartó porque las
tablas base ya son agregadas y el porcentaje se recalcula en el SELECT
final sin necesidad de corrección.

### v0.1.1 → v0.2.1: normalización de cMenu numérico

La v0.2.1 detecta valores de `cMenu` que contienen números de teléfono
(anomalía del IVR documentada en `sp_rpt_cMENU_ERROR`):

```sql
WHEN cMenu REGEXP '^[0-9]{10}$' THEN 'MENU_10_NUMEROS'
WHEN cMenu REGEXP '^[0-9]{11}$' THEN 'MENU_11_NUMEROS'
```

Esto separa las anomalías del catálogo normal de menús. El SP
`sp_rpt_cMENU_ERROR` es la vista dedicada a este subconjunto.

También se eliminan los acentos en nombres de columna
(`misma_línea` → `misma_linea`) y se corrige la inconsistencia
en el nombre de la columna Q3 (`validaciones_exitosas` → `misma_linea`).

### v0.2.1 → v0.3.1: dimensión fecha y nombres definitivos

El cambio más importante: se agrega `DATE_FORMAT(dFecha,'%Y%m') AS fecha`
al GROUP BY. Esto convierte el resultado de una vista trimestral a una
vista mensual dentro del trimestre, que es el grain de `base_ivr_detalle`.

Nombres de columna que cambian y se vuelven definitivos:

| v0.2.1 | v0.3.1 |
|---|---|
| `cDID_800` | `800_transfer` |
| `tipo_caso` | `centro_transferencia` |
| `menu` | `menu` (igual) |
| `cOpcion` | `opcion` |
| `misma_línea` | `misma_linea` |
| `línea_diferente` | `linea_diferente` |

El ORDER BY de v0.3.1 agrega `fecha ASC` como último criterio.

---

## Problemas identificados (para resolver en el SP)

### 1. Nacional A y Nacional B colapsados como "Nacional"

En todas las versiones, `cDID_800Transfer IN (@ONacionalA, @ONacionalB)`
mapea a la etiqueta `'Nacional'`. Esto impide distinguir el volumen de
cada línea en el resultado.

```sql
-- Actual (todas las versiones):
WHEN cDID_800Transfer IN (@ONacionalA, @ONacionalB) THEN 'Nacional'

-- Correcto para el SP (alineado con base_ivr_detalle):
WHEN cDID_800Transfer = 19028031 THEN 'nacional_A'
WHEN cDID_800Transfer = 19020001 THEN 'nacional_B'
```

La tabla base `base_ivr_detalle` almacena `nacional_A` y `nacional_B`
como filas separadas. El SP puede ofrecer ambas vistas: detalle por línea
o consolidado por parámetro.

### 2. Sentinel `ERROR_CARACTER_INICIAL` en cDID_Centro_Transferencia

Las versiones incluyen este caso en el CASE de normalización:

```sql
WHEN cDID_Centro_Transferencia REGEXP '^[^0-9]' THEN 'ERROR_CARACTER_INICIAL'
```

No está documentado en el catálogo de sentinels de `ETL-SPS-REPORTE.md`.
Confirmar si debe mantenerse como sentinel propio o colapsar con `CASO_NULL`.

### 3. Porcentaje calculado sobre total del trimestre completo

El denominador del porcentaje es el total del trimestre entero. Con la
dimensión `fecha` (YYYYMM) añadida en v0.3.1, el porcentaje ya no refleja
el peso dentro del mes sino dentro del trimestre completo.

Para el SP, evaluar si el denominador debe ser:
- Total del trimestre (actual — para comparar quarters)
- Total del mes (para ver distribución intramensual)

### 4. Tres scans por quarter en v0.0.1 y v0.1.1

Las versiones tempranas hacen 1 scan implícito para el JOIN del total
más el scan principal. v0.2.1 y v0.3.1 precalculan el total con
`SET @total = (SELECT COUNT(*) ...)` antes del SELECT principal,
reduciendo a 2 scans por quarter (1 para el total + 1 para el GROUP BY).

El SP de producción opera sobre `base_ivr_detalle` (miles de filas,
indexadas) — el número de scans no es un problema en ese nivel.

---

## Columnas del resultado (v0.3.1 — versión definitiva)

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | 'Q01_25', 'Q02_25', 'Q03_25' |
| `fecha` | VARCHAR(6) | YYYYMM — dimensión mensual ('202501', '202507'...) |
| `800_transfer` | VARCHAR(20) | 'Puebla' o 'Nacional' (colapsado) |
| `centro_transferencia` | VARCHAR(100) | VDN normalizado o sentinel |
| `menu` | VARCHAR(100) | cMenu normalizado (incluye MENU_10/11_NUMEROS) |
| `opcion` | VARCHAR(100) | cOpcion o 'SIN_OPCION' |
| `total_llamadas` | INT | Conteo por combinación de dimensiones |
| `porcentaje` | DECIMAL(15,7) | % sobre el total del trimestre |
| `misma_linea` | INT | cTelefono_Origen = cTelefono_Digitado |
| `linea_diferente` | INT | cTelefono_Origen ≠ cTelefono_Digitado (y Digitado no NULL) |
| `no_digito_telefono` | INT | cTelefono_Digitado IS NULL |

---

## Relación con sp_rpt_centros_transferencia

Este script es el origen de análisis del SP. Las diferencias entre el
script ad-hoc y el SP de producción serán:

| Aspecto | Script ad-hoc (v0.3.1) | SP de producción |
|---|---|---|
| Fuente | `tbl_historico_*` (full scan) | `base_ivr_detalle` (indexada) |
| Quarters | UNION ALL hardcodeado (Q1+Q2+Q3) | Parámetro `@quarter` |
| Segmento | 'Nacional' colapsado | `nacional_A` / `nacional_B` separados |
| Porcentaje | Sobre total del trimestre | A definir con el equipo |
| Ejecución | Manual (analista) | Django bajo demanda |

