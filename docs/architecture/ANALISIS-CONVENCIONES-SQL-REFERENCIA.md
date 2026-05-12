# Análisis de convenciones — Script de referencia SQL

**Fuente analizada:** `q_REP_DETALLE_TRANSFERENCIA_MENU_OPCION-v.0.1.1.sql`  
**Aplicado a:** `provisioners/mariadb/objetos/{funciones,sps,jobs}/`  
**Fecha:** 2026-05-12

---

## Estructura global del archivo

Todo script sigue exactamente este orden, sin excepción:

```
1. BOOKEND de inicio         (SELECT FROM DUAL)
2. Bloque de documentación   (/* ... */)
3. -- CONFIGURACIÓN ...      (sección principal)
4. -- ANÁLISIS / DEFINICIÓN  (sección principal)
5. -- FINALIZACIÓN           (sección principal)
6. BOOKEND de cierre         (SELECT FROM DUAL)
```

---

## Regla A — BOOKEND de inicio

Primera instrucción ejecutable del archivo. Sin comentarios antes.

```sql
SELECT
    'PROCESO INICIO' as evento,
    NOW() as timestamp_inicio
FROM DUAL;
```

**Detalles exactos:**
- `SELECT` en su propia línea, sin columna en la misma línea
- Columnas indentadas 4 espacios
- `as` en minúsculas (alias de literal — ver Regla F)
- `FROM DUAL` sin indentación
- Punto y coma al final

---

## Regla B — Bloque de documentación

Inmediatamente después del bookend de inicio, separado por una línea en blanco.

```sql
/*********************************************************************************************
    Script          : nombre-del-archivo.sql
    Version         : 2.0.0
    Create          : MAYO/2026
    Engine          : MariaDB 10.11
    Schema          : ivr_legacy
    Prerequisito    : nombre-de-dependencia
    Despliegue      : mysql ... < nombre.sql
    Notas           : texto libre
*********************************************************************************************/
```

**Medidas exactas (auditadas byte a byte):**
- Línea de apertura: `/*` + 92 asteriscos = 94 caracteres
- Línea de cierre: 93 asteriscos + `*/` = 95 caracteres
- Campos indentados 4 espacios
- Nombres de campo: 16 caracteres con padding a la derecha (`Script          `)
- Separador: ` : ` (espacio, dos puntos, espacio)
- El script de referencia original tiene: `Script`, `Create`, `Engine`, `Notas`
- Los archivos de objetos de BD agregan: `Version`, `Schema`, `Prerequisito`, `Despliegue`

---

## Regla C — Etiquetas de sección

**Secciones principales:** ALL CAPS, precedidas de línea en blanco.

```sql
-- CONFIGURACIÓN DE VARIABLES

-- ANÁLISIS

-- FINALIZACIÓN
```

**Sub-etiquetas:** Primera letra mayúscula, el resto minúsculas. Van pegadas al bloque que describen, sin línea en blanco previa.

```sql
-- Calcular factor de corrección en una subconsulta
SET @factor_correccion_t1 = ( ...

-- Consulta principal
SELECT
    ...
```

**Adaptación para objetos de BD:**

| Sección original | Equivalente en archivos de objetos |
|---|---|
| `-- CONFIGURACIÓN DE VARIABLES` | `-- CONFIGURACIÓN` (metadatos de contexto) |
| `-- ANÁLISIS` | `-- DEFINICIÓN` (DELIMITER + DROP + CREATE) |
| `-- FINALIZACIÓN` | `-- VERIFICACIÓN` + `-- FINALIZACIÓN` |

---

## Regla D — Variables con `SET @`

CamelCase con prefijo semántico. Agrupadas por dominio con línea en blanco entre grupos.

```sql
-- Constantes de negocio (identificadores)
SET @Q1_nombre = 'Q01_25';
SET @Q2_nombre = 'Q02_25';

-- Constantes de dominio (DIDs 800)
SET @OPuebla   = 19020084;
SET @ONacionalA = 19028031;
SET @ONacionalB = 19020001;

-- Variables calculadas (subconsultas)
SET @total_llamadas_t1 = ( SELECT COUNT(*) FROM ... );
```

**Convención de nombres:**
- Constantes de negocio: `@Q1_nombre`, `@Q2_nombre` — prefijo por quarter
- Constantes de DID: `@OPuebla`, `@ONacionalA` — prefijo `O` de "origen"
- Calculadas: `@total_llamadas_t1`, `@factor_correccion_t1` — nombre descriptivo + sufijo de quarter

---

## Regla E — SELECT: formato de columnas

```sql
SELECT
    primera_columna as alias          -- sin coma antes de la primera
    , segunda_columna AS Alias        -- comma-FIRST en todas las siguientes
    , tercera_columna AS Alias
FROM tabla
WHERE condicion
GROUP BY alias1, alias2
```

**Detalles:**
- `SELECT` solo en su línea
- Primera columna: 4 espacios de indentación, sin coma
- Columnas siguientes: 4 espacios + `, ` (coma-espacio) al inicio
- `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`: sin indentación (columna 0)
- `GROUP BY` en una línea, usando los ALIAS del SELECT (no la expresión)

---

## Regla F — Alias: `as` vs `AS`

La distinción es semántica, no estilística:

| Caso | Keyword | Ejemplo |
|---|---|---|
| Literal de texto o variable de sesión | `as` (minúsculas) | `'PROCESO INICIO' as evento` |
| Variable de sesión `@var` | `as` (minúsculas) | `@Q1_nombre as trimestre` |
| Expresión calculada (función, CASE, COUNT) | `AS` (mayúsculas) | `COUNT(*) AS total_llamadas` |
| CASE multlínea | `AS` al lado de END | `END AS tipo_caso` |
| Subconsulta | `AS` | `) AS subtotal` |

---

## Regla G — CASE: indentación

**CASE de una línea** (condición simple):
```sql
    , CASE WHEN a = b THEN 'x' WHEN a = c THEN 'y' END as alias
```

**CASE multilínea** (múltiples condiciones):
```sql
    , CASE
        WHEN condicion_1             THEN 'valor_1'
        WHEN condicion_2             THEN 'valor_2'
        ELSE 'valor_default'
    END AS alias
```

- `CASE` en la línea de la coma, a 4 espacios
- `WHEN` a 8 espacios (4 adicionales)
- `ELSE` a 8 espacios
- `END AS alias` a 4 espacios (vuelve al nivel de columna)

---

## Regla H — UNION ALL

Sin punto y coma entre bloques. Línea en blanco antes y después.

```sql
GROUP BY alias1, alias2

UNION ALL

SELECT
    ...
```

El punto y coma va únicamente al final del último `SELECT` del conjunto.

---

## Regla I — ORDER BY con CASE

```sql
ORDER BY
    CASE columna_alias
        WHEN valor1 THEN 1
        WHEN valor2 THEN 2
        WHEN valor3 THEN 3
    END,
    columna_secundaria,
    columna_terciaria DESC;
```

- `ORDER BY` solo en su línea
- `CASE` indentado 4 espacios
- `WHEN` indentado 8 espacios
- `END,` indentado 4 espacios
- Columnas adicionales en líneas separadas

---

## Regla J — BOOKEND de cierre

Última instrucción ejecutable. Precedida de la sección `-- FINALIZACIÓN`.

```sql
-- FINALIZACIÓN

SELECT
    'PROCESO COMPLETADO' as evento,
    NOW() as timestamp_fin
FROM DUAL;
```

---

## Adaptación para objetos de BD (funciones / SPs / events)

Los archivos de objetos tienen una sección `-- DEFINICIÓN` que contiene el
`DELIMITER`, el `DROP IF EXISTS` y el `CREATE`. Todo lo demás (bookends,
documentación, verificación) va fuera del DELIMITER.

```
BOOKEND inicio
bloque doc /*...*/

-- CONFIGURACIÓN         ← contexto, notas de prerequisitos
[SET @ variables si aplica]

-- DEFINICIÓN
DELIMITER $$
DROP ... IF EXISTS nombre$$
CREATE ...
...
END$$
DELIMITER ;

-- VERIFICACIÓN          ← SELECT que confirma existencia o resultado
SELECT ROUTINE_NAME FROM information_schema.ROUTINES ...;

-- FINALIZACIÓN
BOOKEND cierre
```

**El `DELIMITER $$` solo aparece dentro de `-- DEFINICIÓN`.** Los bookends,
la documentación y la verificación son SQL normal que el cliente ejecuta
directamente, sin necesidad de cambiar el delimitador.
