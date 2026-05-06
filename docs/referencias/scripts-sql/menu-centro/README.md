# Script: Menú por Centro de Transferencia

**Reporte destino:** `sp_rpt_menu_centro`
**Tabla base:** `base_ivr_detalle`
**Estado:** Script ad-hoc con bug crítico en @ONacionalB — pendiente migrar a SP

---

## Archivo

`q_menu_centro_transferecia_010925.sql` — única versión disponible.

---

## Qué hace

Para cada centro de transferencia, muestra qué menús y opciones le
llegaron, cuántas veces, y en qué proporción respecto al total del centro.
Incluye distribución horaria (mañana/tarde/noche), duración promedio
y etiquetas de cliente asociadas.

---

## Bug crítico: @ONacionalB = 19028031 (mismo valor que @ONacionalA)

```sql
SET @ONacionalA = 19028031;
SET @ONacionalB = 19028031;   -- INCORRECTO — debería ser 19020001
```

Nacional A y Nacional B tienen el mismo DID asignado. El WHERE filtra
`IN (@ONacionalA, @ONacionalB, @OPuebla)` que en la práctica es
`IN (19028031, 19028031, 19020084)` — Nacional B (19020001) queda
completamente excluido. Este es el bug más grave del conjunto de scripts.

---

## Sin normalización NK90

El script usa `cDID_Centro_Transferencia` sin aplicar la normalización:

```sql
-- El script:
SELECT cDID_Centro_Transferencia AS centro_transferencia_vdn
JOIN ... ON tbl.cDID_Centro_Transferencia = centro_total.cDID_Centro_Transferencia

-- Sin transformar: NK90 concatenado aparece como centro individual
-- '13090044433150875' y '1309004' se tratan como centros DISTINTOS
```

Esto produce conteos incorrectos: el mismo centro físico puede aparecer
como múltiples centros dependiendo de si el campo tiene o no el teléfono
concatenado. El SP debe normalizar antes del JOIN.

---

## Fecha acotada (no Q1 completo)

```sql
SET @Q1_inicio = '2025-01-01';
SET @Q1_fin    = '2025-01-15';   -- Solo los primeros 15 días de enero
```

El script fue ejecutado para un análisis específico de los primeros 15
días. No representa Q1 completo.

---

## Columnas del resultado

| Columna | Descripción |
|---|---|
| `centro_transferencia_vdn` | `cDID_Centro_Transferencia` sin normalizar |
| `cMenu` | COALESCE(cMenu, 'SIN_MENU') |
| `cOpcion` | COALESCE(cOpcion, 'NULL') |
| `ejecuciones` | COUNT(*) |
| `porcentaje_dentro_centro` | % sobre total del centro (JOIN subconsulta) |
| `usuarios_unicos` | COUNT(DISTINCT cTelefono_Digitado) |
| `duracion_promedio_seg` | AVG con corrección bug hora invertida |
| `ejecuciones_manana/tarde/noche` | Por franja horaria |
| `etiquetas_asociadas` | GROUP_CONCAT(DISTINCT cEtiquetacliente) |

---

## Correcciones necesarias para el SP

1. `@ONacionalB = 19020001` (no 19028031)
2. Normalizar `cDID_Centro_Transferencia` antes de GROUP BY y JOIN
3. Leer de `base_ivr_detalle` en lugar de `tbl_historico_*`
4. Recibir `@quarter` y `@segmento` como parámetros (no fechas hardcodeadas)
5. La columna `etiquetas_asociadas` no estará disponible en `base_ivr_detalle`

