# Script: Llamadas Menu (distribución general de menús)

**Reporte destino:** Reporte `llamadas_cmenu` — mapeo a SP pendiente (G-28)
**Estado:** Script ad-hoc — relación con los 7 SPs canónicos por confirmar

---

## Archivo

`q_REPTRIM021_LLAMADAS_MENU.sql` — única versión disponible.

---

## Qué hace

Muestra la distribución de llamadas por valor de `cMenu` (todos los menús,
no solo los abandonados). Incluye la detección del sentinel `telefono_cMenu`:
registros donde el campo `cMenu` contiene el número de teléfono del llamante
(anomalía del IVR).

```sql
-- Detección del sentinel en la subconsulta:
CASE
    WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu
    THEN 'telefono_cMenu'
    ELSE cMenu
END AS cMenu
```

El resultado agrupa por (DID, trimestre, cMenu normalizado) y devuelve
el conteo total de llamadas. Es el origen del reporte `llamadas_cmenu`
documentado en los WPs con un volumen de ~34M llamadas Q01+Q02+Q03 2025.

---

## Normalización de cMenu

```sql
WHEN cMenu = ''           THEN 'VACIO'     -- mayúsculas (correcto)
WHEN cMenu = 'sin cMenu'  THEN 'VACIO'
WHEN cMenu IS NULL        THEN 'VACIO'
WHEN TRIM(cMenu) = ''     THEN 'VACIO'
ELSE UPPER(TRIM(cMenu))
```

A diferencia de `q_REPTRIM021_LLAMADAS_ABDANDONADAS.sql`, este script
usa `'VACIO'` en mayúsculas — consistente con el valor canónico de
`base_ivr_detalle`. Todos los demás menús se normalizan a UPPER.

---

## Relación con los 7 SPs canónicos

Este script cubre un territorio diferente al de los 7 SPs:

| Script | Alcance | SP canónico |
|---|---|---|
| `q_REPTRIM021_LLAMADAS_MENU.sql` | Distribución de TODOS los menús | No mapeado directamente (G-28) |
| `q_REPTRIM021_LLAMADAS_ABDANDONADAS.sql` | Idem pero naming sugiere foco en abandono | `sp_rpt_llamadas_abandonadas` |
| Script de anomalías | Solo cMenu numérico (`REGEXP '^[0-9]+'`) | `sp_rpt_cMENU_ERROR` |

El gap G-28 abierto en los WPs pregunta exactamente esto: ¿la distribución
completa de menús (`llamadas_cmenu`) es una vista derivada de `base_ivr_detalle`
o requiere su propio SP? Este script sugiere que es un análisis propio,
distinto de `sp_rpt_cMENU_ERROR` (que solo filtra anomalías numéricas).

**Confirmar con el equipo:** si `llamadas_menu` se convierte en un 8° SP
fuera del Scope 1 original o si `sp_rpt_cMENU_ERROR` + `sp_rpt_llamadas_abandonadas`
cubren su propósito combinados.

---

## Problemas identificados

### 1. @ONacional02 incorrecto y sin usar

```sql
SET @ONacional02 = 1902001;   -- INCORRECTO (falta un cero: 19020001)
-- No se usa en el WHERE
```

Mismo bug que en `q_REPTRIM021_LLAMADAS_ABDANDONADAS.sql`.

### 2. Solo captura Puebla y Nacional A

El WHERE usa solo `@OPuebla` y `@ONacional`. Nacional B (19020001)
queda excluido. Toda la distribución de menús de Nacional B está ausente.

### 3. UPPER() oculta diferencias de casing

El UPPER normaliza menús como `'RES-FallaInternet'` y `'RES-FALLAINTERNET'`
al mismo valor `'RES-FALLAINTERNET'`. Esto puede colapsar variantes que
el equipo quiera distinguir. El SP debe decidir si normalizar el casing
o mantenerlo tal como llega de `base_ivr_detalle`.

### 4. Detección de telefono_cMenu — lógica de doble condición

```sql
WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu
THEN 'telefono_cMenu'
```

Requiere que AMBOS teléfonos sean iguales al cMenu. Si solo uno coincide,
el registro no se clasifica como anomalía. Confirmar con el equipo si la
condición debe ser `AND` (ambos) u `OR` (cualquiera).

---

## Columnas del resultado

| Columna | Descripción |
|---|---|
| `cDID` | 'Puebla' o 'Nacional' |
| `trimestre` | 'Q01_25', 'Q02_25', 'Q03_25' |
| `cMenu` | Valor normalizado (UPPER) o sentinel |
| `cantidad_registros` | COUNT(*) por combinación |

