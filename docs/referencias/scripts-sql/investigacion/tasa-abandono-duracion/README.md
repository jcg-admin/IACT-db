# Investigación: Tasa de abandono por duración

**Script:** `q_analisis_centros_transfer_tasa_abandono_010925.sql`
**Tipo:** Exploratorio — definición alternativa de abandono por duración

---

## Qué hace

Identifica centros de transferencia con alta tasa de "abandono" definida
como: llamadas con **duración menor a 30 segundos**. Devuelve centros
donde más del 40% de las llamadas tuvieron duración < 30 seg.

---

## Definición de abandono: duración vs cMenu

Este script usa una definición de abandono completamente diferente a la
del SP de producción:

| Fuente | Definición |
|---|---|
| Este script | `duración < 30 segundos` |
| Estándar (D-ETL-006) | `cMenu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')` |

Ambas detectan abandono pero por ángulos distintos. Una llamada puede
ser `cliente_colgo` con duración de 2 minutos (el cliente esperó pero
no fue transferido). Son complementarias, no equivalentes.

---

## Bugs identificados

### Bug 1 — WHERE sin paréntesis (precedencia incorrecta)

```sql
-- Tal como está:
WHERE cDID_Centro_Transferencia IS NOT NULL AND cDID_Centro_Transferencia != ''
    AND cDID_800Transfer = @OPuebla OR cDID_800Transfer IN (@ONacionalA, @ONacionalB)
    AND dFecha BETWEEN @Q1_inicio AND @Q1_fin

-- Cómo evalúa (por precedencia AND > OR):
WHERE (... AND cDID_800Transfer = @OPuebla)
   OR (cDID_800Transfer IN (@ONacionalA, @ONacionalB) AND dFecha BETWEEN ...)
```

El `OR` sin paréntesis hace que los filtros de fecha y nulos no apliquen
cuando el DID es Nacional. Corrección:

```sql
AND (cDID_800Transfer = @OPuebla OR cDID_800Transfer IN (@ONacionalA, @ONacionalB))
```

### Bug 2 — Sin normalización NK90

El script filtra `cDID_Centro_Transferencia IS NOT NULL` pero no normaliza
el campo — un mismo centro puede aparecer como múltiples entradas si
algunos registros tienen el teléfono concatenado.

### Bug 3 — Rango acotado (primeros 15 días de enero)

`@Q1_fin = '2025-01-15'` — no es el Q1 completo.

