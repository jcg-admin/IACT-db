# Scripts: Promedio de Clientes

**Reporte destino:** Sin mapeo directo a los 7 SPs canónicos — métricas derivadas
**Estado:** Scripts de análisis exploratorio — requieren decisión de scope

---

## Archivos

| Archivo | Métrica central |
|---|---|
| `q_REPTRIM031_PROMEDIO_DE_CLIENTES_UNICOS.sql` | `AVG(clientes_unicos)` por (trimestre, DID, cMenu) |
| `q_REPTRIM041_PROMEDIO_CLIENTES_MENU.sql` | `AVG/MIN/MAX(clientes)` por (cMenu, DID) — vista cross-quarter |

---

## REPTRIM031 — Promedio de Clientes Únicos

### Qué hace

Calcula el promedio de clientes únicos (`cTelefono_Digitado`) por combinación
de (trimestre, DID, cMenu). La lógica en tres capas:

```
Capa 1: datos_consolidados
  UNION ALL de los tres quarters
  Detecta sentinel telefono_cMenu

Capa 2: clientes_deduplicados
  SELECT DISTINCT (DID, cMenu, trimestre, cTelefono_Digitado)
  → elimina el mismo teléfono si aparece múltiples veces en el mismo
    quarter+menu (cuenta el teléfono una sola vez por combinación)

Capa 3: conteos_por_trimestre
  COUNT(*) sobre los deduplicados
  → clientes únicos por (DID, cMenu, trimestre)

Capa 4 (SELECT final):
  AVG(clientes_unicos) sobre los trimestres
  → promedio de clientes únicos por menú a lo largo de Q1+Q2+Q3
```

### Uso analítico

Responde: "¿cuántos clientes únicos en promedio llegan a cada menú por
trimestre?" Útil para detectar menús con alta variabilidad entre quarters
(fluctuación estacional) vs menús estables.

---

## REPTRIM041 — Promedio de Clientes por Menú (cross-quarter)

### Qué hace

Similar a REPTRIM031 pero agrega MIN, MAX y `trimestres_con_datos`:

```sql
SELECT
    cMenu, cDID_800Transfer,
    FORMAT(AVG(clientes_por_trimestre), 2) AS promedio_clientes,
    MIN(clientes_por_trimestre)            AS min_clientes,
    MAX(clientes_por_trimestre)            AS max_clientes,
    COUNT(*)                               AS trimestres_con_datos
```

La diferencia clave con REPTRIM031: el GROUP BY final es por `(cMenu, DID)`
sin `trimestre` — el resultado es una sola fila por menú con el comportamiento
promedio a lo largo de todos los quarters. REPTRIM031 mantiene el trimestre
en el resultado final.

### Uso analítico

Responde: "¿qué menús tienen mayor y menor variabilidad de clientes entre
quarters?" `MAX - MIN` es el rango de variación. `trimestres_con_datos`
indica si el menú apareció en 1, 2 o los 3 quarters (si apareció solo en
Q3, puede ser un menú nuevo).

---

## Diferencia entre REPTRIM031 y REPTRIM041

| Dimensión | REPTRIM031 | REPTRIM041 |
|---|---|---|
| GROUP BY final | (trimestre, DID, cMenu) | (cMenu, DID) |
| Rows resultado | Una por (trimestre × DID × menú) | Una por (DID × menú) — vista comprimida |
| Métricas | promedio_clientes | promedio + MIN + MAX + trimestres_con_datos |
| Vista temporal | Por trimestre | Cross-quarter consolidado |

---

## Relación con los 7 SPs canónicos

Estos dos scripts no mapean a ninguno de los 7 SPs del Scope 1. Son
métricas derivadas de segundo orden (promedios sobre los conteos base).

Opciones para el SP:
- Incluirlas como parámetro opcional de `sp_rpt_clientes` (`@modo = 'promedio'`)
- Crear SPs adicionales fuera del Scope 1 (`sp_rpt_clientes_promedio`)
- Exponerlas como cálculo en la capa Django (si `base_ivr_clientes` ya
  tiene los datos por quarter, Django puede calcular el promedio sin SP)

**Recomendación:** calcular en Django. `base_ivr_clientes` tiene 3 filas por
quarter (una por segmento), no por menú. Para el promedio por menú se
necesitaría `base_ivr_detalle`. El cálculo en Django evita un SP adicional.

---

## Problemas identificados en ambos scripts

### 1. Solo Puebla y Nacional A — falta Nacional B

```sql
AND cDID_800Transfer IN (@OPuebla, @ONacional)
-- @ONacional = 19028031  →  solo Nacional A
-- Nacional B (19020001) excluido
```

### 2. Sentinel telefono_cMenu — condición AND

```sql
WHEN cTelefono_Digitado = cMenu AND cTelefono_Origen = cMenu
```

Ambos scripts usan `AND` (ambos campos deben coincidir). Confirmar si es
la condición correcta o si `OR` captura más casos reales.

### 3. REPTRIM031 usa cTelefono_Digitado, REPTRIM011 usa cTelefono_Origen

El script de clientes únicos base (REPTRIM011) usa `cTelefono_Origen`.
Los scripts de promedio (REPTRIM031 y REPTRIM041) usan `cTelefono_Digitado`.
Esta inconsistencia produce números diferentes para "cliente único".

Confirmar con el equipo cuál es la definición canónica de cliente único:
el número desde el que llamó (Origen) o el que ingresó en el IVR (Digitado).

