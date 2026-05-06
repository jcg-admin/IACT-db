# Script: Llamadas Abandonadas

**Reporte destino:** `sp_rpt_llamadas_abandonadas`
**Tabla base:** `base_ivr_detalle`
**Estado:** Script ad-hoc — pendiente migrar a SP

---

## Archivo

`q_REPTRIM021_LLAMADAS_ABDANDONADAS.sql` — única versión disponible.

---

## Qué hace

Muestra el conteo de llamadas agrupado por (DID, trimestre, menú normalizado).
No filtra solo las abandonadas — lista todos los valores de `cMenu` con su
conteo, lo que permite al analista identificar visualmente cuáles son abandono.

```sql
GROUP BY cDID_800Transfer, trimestre, menu_limpio
-- Devuelve: DID | trimestre | menu_limpio | cantidad_registros
```

La identificación de abandono se hace post-consulta: el analista busca
los registros donde `menu_limpio IN ('vacio', 'CLIENTE_COLGO', 'SINOPCION_CABECERA')`.

---

## Normalización de cMenu en este script

```sql
CASE
    WHEN cMenu = ''           THEN 'vacio'      -- minúsculas (diferente a otros scripts)
    WHEN cMenu = 'sin cMenu'  THEN 'vacio'
    WHEN cMenu IS NULL        THEN 'vacio'
    WHEN TRIM(cMenu) = ''     THEN 'vacio'
    ELSE UPPER(TRIM(cMenu))                      -- MAYÚSCULAS para el resto
END AS menu_limpio
```

El sentinel `'vacio'` está en minúsculas aquí. En `base_ivr_detalle` el
valor canónico es `'VACIO'` (mayúsculas). El SP debe usar el valor canónico.

---

## Problemas identificados

### 1. Prefijo REPTRIM021 compartido con q_REPTRIM021_LLAMADAS_MENU.sql

Dos scripts distintos tienen el mismo número de serie `021`. Son análisis
complementarios pero independientes. No hay colisión funcional pero sí
confusión en el naming. Al migrar al SP, se resuelve con nombres distintos:
`sp_rpt_llamadas_abandonadas` vs el script de menú que da origen al
reporte general de distribución de menús.

### 2. @ONacional02 declarado con valor incorrecto y sin usar

```sql
SET @ONacional02 = 1902001;   -- INCORRECTO: falta un cero
                               -- CORRECTO:   19020001
```

El valor correcto de Nacional B es `19020001`. Además, `@ONacional02` no
se usa en el WHERE — solo `@ONacional` (Nacional A). Nacional B queda
excluido del análisis.

### 3. El script no distingue abandono del resto

El SP de producción debe filtrar explícitamente los tres tipos de abandono
en lugar de exponer todos los menús. La lógica correcta (D-ETL-006):

```sql
-- Lo que hace el script (análisis general):
GROUP BY menu_limpio
-- Devuelve ~20-30 filas con TODOS los menús

-- Lo que debe hacer el SP (abandono específico):
WHERE menu IN ('VACIO', 'CLIENTE_COLGO', 'SinOpcion_Cabecera')
-- Devuelve solo las 3 categorías de abandono + totales
```

### 4. 'vacio' en minúsculas vs 'VACIO' canónico

El script usa `'vacio'` (minúsculas). `base_ivr_detalle` almacena `'VACIO'`
(mayúsculas, definido en el ETL). El SP filtra `WHERE menu = 'VACIO'`.

---

## Diferencias con el SP de producción

| Aspecto | Script ad-hoc | sp_rpt_llamadas_abandonadas |
|---|---|---|
| Fuente | `tbl_historico_*` (full scan) | `base_ivr_detalle` (indexada) |
| Alcance | Todos los menús | Solo las 3 categorías de abandono |
| Segmentos | Puebla + Nacional A solamente | Puebla + nacional_A + nacional_B |
| Sentinel vacío | `'vacio'` (minúsculas) | `'VACIO'` (mayúsculas canónico) |
| Output | Distribución cruda de menús | Tasa de abandono + % sobre el total |

