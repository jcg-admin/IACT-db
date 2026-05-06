# Script: Menús que Redirigen por Centro

**Reporte destino:** `sp_rpt_menu_redirigidos`
**Tabla base:** `base_ivr_detalle`
**Fuente:** Vista `llamadas_Q3` (datos ya normalizados)
**Estado:** Script ad-hoc — pendiente migrar a SP

---

## Archivo

`mariadb_analisis_transferencias_menu.sql` — tres queries en un mismo script.

---

## Las tres queries

**Query 1 — Resumen por centro:** Para cada `id_CTransferencia`, muestra
total de llamadas, usuarios únicos, lista de menús que redirigen a ese
centro (`GROUP_CONCAT`) y métricas de duración con corrección del bug
`dHoraInicio > dHoraFin`. También calcula `registros_hora_invertida`
(cuántos registros tienen el bug) y clasifica el centro por volumen
y complejidad.

**Query 2 — Desglose menú×centro:** Para cada combinación
`(id_CTransferencia, menu, opcion)`, muestra el conteo, el porcentaje
dentro del centro (con JOIN a subconsulta del total), distribución por
horario (mañana/tarde/noche) y etiquetas asociadas.

**Query 3 — Resumen ejecutivo:** Una sola fila con totales globales:
total de centros activos, llamadas totales, promedios, máximos, mínimos
y cantidad de centros por clasificación.

---

## Relación con los SPs

Este script es el origen de **dos** SPs distintos:

| Query | SP |
|---|---|
| Query 1 — perspectiva centro → menus que llegan | `sp_rpt_menu_redirigidos` |
| Query 2 — perspectiva centro → menú×opción con % | `sp_rpt_menu_centro` |

La separación en dos SPs responde a que tienen parámetros y grains
distintos. `sp_rpt_menu_redirigidos` no requiere `@segmento` y devuelve
el `GROUP_CONCAT` de menús. `sp_rpt_menu_centro` requiere `@segmento`
y devuelve una fila por combinación menú+opción con porcentaje.

---

## Columnas clave de Query 2 (origen de sp_rpt_menu_centro)

| Columna | Descripción |
|---|---|
| `centro_transferencia` | id_CTransferencia normalizado |
| `menu` | COALESCE(menu, 'SIN_MENU') |
| `opcion` | COALESCE(opcion, 'NULL') |
| `ejecuciones` | COUNT(*) por combinación |
| `porcentaje_dentro_centro` | % respecto al total del centro (subconsulta JOIN) |
| `usuarios_unicos` | COUNT(DISTINCT numero_digitado) |
| `duracion_promedio_seg` | AVG con corrección bug hora invertida |
| `ejecuciones_manana/tarde/noche` | Distribución horaria |
| `etiquetas_asociadas` | GROUP_CONCAT(DISTINCT etiquetas, 150 chars) |

---

## Diferencias con los SPs de producción

| Aspecto | Script ad-hoc | SPs de producción |
|---|---|---|
| Fuente | Vista `llamadas_Q3` (Q3 hardcodeado) | `base_ivr_detalle` (parámetro `@quarter`) |
| Duración | Calcula desde hora_inicio/fin | No disponible en `base_ivr_detalle` |
| Etiquetas | Incluye `etiquetas_asociadas` | No está en `base_ivr_detalle` (P-13 abierto) |
| Sin segmento | Solo filtra por centro no nulo | `sp_rpt_menu_centro` filtra por `@segmento` |

**Relación con P-13:** La columna `etiquetas_asociadas` y el campo
`numero_digitado` vienen de la vista `llamadas_Q3`. Si `sp_rpt_menu_redirigidos`
necesita estas columnas, el ETL requiere un 3er scan o tabla base adicional.

