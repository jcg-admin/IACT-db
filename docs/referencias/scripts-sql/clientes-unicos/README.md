# Script: Clientes Únicos por DID y Trimestre

**Reporte destino:** `sp_rpt_clientes`
**Tabla base:** `base_ivr_clientes`
**Estado:** En producción como script ad-hoc — pendiente migrar a SP

---

## Archivo

`q_REPTRIM011_CLIENTES_UNICOS_POR_DID.sql` — única versión disponible.

---

## Qué hace

Cuenta clientes únicos (teléfonos únicos de origen) por segmento y
trimestre, usando `COUNT(DISTINCT cTelefono_Origen)`.

```sql
COUNT(DISTINCT cTelefono_Origen) AS clientes_unicos
```

Los datos se obtienen con UNION ALL sobre tres tablas trimestrales,
filtrando por rango de fechas explícito.

---

## Columnas del resultado

| Columna | Tipo | Descripción |
|---|---|---|
| `cDID` | VARCHAR | 'Puebla', 'Nacional' o 'OTRO' |
| `trimestre` | VARCHAR(10) | 'Q01_25', 'Q02_25', 'Q03_25' |
| `clientes_unicos` | INT | COUNT(DISTINCT cTelefono_Origen) |

---

## Problemas identificados

### 1. Bug crítico: falta @ONacionalB — Nacional B excluido

El script solo declara y usa `@ONacional = 19028031` (Nacional A).
`@ONacionalB = 19020001` (Nacional B) no existe en este script.

```sql
-- Script actual (incompleto):
SET @ONacional = 19028031;

WHERE cDID_800Transfer IN (@OPuebla, @ONacional)
-- → solo captura Puebla + Nacional A
-- → Nacional B (19020001) queda EXCLUIDO de los conteos
```

Este es el mismo bug documentado en `real-db-schema-analysis.md`
(G-30, confirmado). Todos los conteos de clientes únicos de "Nacional"
están sub-reportados porque no incluyen las llamadas de la línea B.

**Corrección para el SP:**

```sql
WHERE cDID_800Transfer IN (@OPuebla, @ONacionalA, @ONacionalB)
-- y separar nacional_A de nacional_B en el resultado
```

### 2. Usa cTelefono_Origen, no cTelefono_Digitado

El script cuenta `COUNT(DISTINCT cTelefono_Origen)` — el número del
llamante (CLI). El análisis previo en los WPs mencionaba
`cTelefono_Digitado` como la fuente de clientes únicos.

La diferencia es conceptual:

| Campo | Representa |
|---|---|
| `cTelefono_Origen` | Número desde el que llamó el cliente (CLI) |
| `cTelefono_Digitado` | Número que el cliente ingresó en el IVR |

`cTelefono_Digitado` puede ser NULL (30% de los casos — cliente que no
digitó nada). `cTelefono_Origen` siempre tiene valor si la llamada llegó.

**Confirmar con el equipo** cuál es la definición de negocio correcta
de "cliente único": ¿el que llama (origen) o el que se identifica en el
IVR (digitado)?

### 3. "Nacional" colapsado — no distingue A de B

Al igual que en el script de transferencia, Nacional A y Nacional B
aparecen como una sola etiqueta `'Nacional'`. El SP debe ofrecer la
posibilidad de verlos separados.

### 4. Rango de fechas hardcodeado por variables

El script usa `@Q1_inicio`, `@Q1_fin` etc. para filtrar por fecha.
Esto es redundante con el hecho de que los datos ya están particionados
físicamente por tabla (`tbl_historico_t1_2025` solo tiene Q1). El filtro
de fecha es defensivo pero añade complejidad sin valor en el script ad-hoc
y sin ningún valor en el SP (que opera sobre `base_ivr_clientes` ya
pre-agregada).

---

## Diferencias entre script ad-hoc y SP de producción

| Aspecto | Script ad-hoc | SP de producción |
|---|---|---|
| Fuente | `tbl_historico_*` (full scan, sin índices) | `base_ivr_clientes` (3 filas por quarter) |
| Segmentos | Puebla + Nacional (colapsado, sin B) | Puebla + nacional_A + nacional_B |
| Campo contado | `cTelefono_Origen` | Confirmar con equipo |
| Quarters | Q1+Q2+Q3 hardcodeados | Parámetro `@quarter` |
| Nulos excluidos | Implícitamente (DISTINCT ignora NULL) | Explícito en documentación |

---

## Relación con base_ivr_clientes

El ETL pre-agrega el COUNT DISTINCT en la tabla `base_ivr_clientes`:

```sql
-- Lo que hace sp_etl_base_clientes (en el ETL nocturno):
INSERT INTO base_ivr_clientes (trimestre, segmento, clientes_unicos)
SELECT @quarter,
       CASE cDID_800Transfer ... END,
       COUNT(DISTINCT cTelefono_Origen)  -- o cTelefono_Digitado (confirmar)
FROM   tbl_historico_tN_YYYY
WHERE  ...
GROUP BY segmento;

-- Lo que hace sp_rpt_clientes (bajo demanda desde Django):
SELECT trimestre, segmento, clientes_unicos
FROM   base_ivr_clientes
WHERE  trimestre = @quarter;
-- → retorna 3 filas en milisegundos (sin full table scan)
```

El SP es trivialmente simple porque el trabajo pesado ya lo hizo el ETL.

