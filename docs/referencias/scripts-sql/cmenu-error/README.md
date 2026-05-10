# Script: Anomalías cMENU_ERROR

**Reporte destino:** `sp_rpt_cMENU_ERROR`
**Tabla base:** `base_ivr_detalle`
**Estado:** Script ad-hoc — pendiente migrar a SP

---

## Archivo

`q_cMENU_ERROR.sql` — única versión disponible.

---

## Qué hace

Retorna registros individuales (sin agregar) de `tbl_historico_t3_2025`
donde `cMenu` presenta alguna anomalía.

---

## Condición de filtro — tres tipos mezclados

```sql
WHERE cDID_800Transfer IN (19020084, 19028031, 19020001)  -- los 3 DIDs (correcto)
AND (
    (cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu)  -- tipo 1: teléfono como cMenu
    OR cMenu REGEXP '^[0-9]+$'                                  -- tipo 2: cMenu puramente numérico
    OR cMenu IS NULL                                            -- tipo 3: NULL
    OR TRIM(cMenu) = ''                                         -- tipo 4: vacío
    OR cMenu IN ('', 'sin cMenu')                               -- tipo 5: strings sin valor
)
```

Los tipos 3, 4 y 5 son registros que el ETL normaliza a `'VACIO'` —
no son anomalías del tipo `cMENU_ERROR`. El SP debe filtrar solo las
anomalías reales (tipos 1 y 2).

**Definición correcta para el SP:**

```sql
WHERE menu REGEXP '^[0-9]+'           -- cMenu numérico (anomalía real)
  -- o bien: WHERE menu = 'telefono_cMenu'  (si ya fue normalizado en ETL)
```

---

## Diferencias clave con el SP de producción

| Aspecto | Script ad-hoc | sp_rpt_cMENU_ERROR |
|---|---|---|
| Quarter | Solo Q3 2025 hardcodeado | Parámetro `@quarter` |
| Output | `SELECT *` — registros individuales | Agregado por (quarter, menu, total) |
| Anomalías incluidas | Mezcla cMENU_ERROR + VACIO | Solo cMenu numérico / telefónico |
| Los 3 DIDs | Sí (hardcodeados correctamente) | Sí (vía `base_ivr_detalle`) |

---

## Los DIDs están hardcodeados correctamente

Este es uno de los pocos scripts donde los tres DIDs están escritos
directamente sin variables y con los valores correctos:

```sql
AND cDID_800Transfer IN (19020084, 19028031, 19020001)
```

