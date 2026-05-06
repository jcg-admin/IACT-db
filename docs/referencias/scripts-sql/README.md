# Scripts SQL de referencia — Análisis ad-hoc de producción

Scripts SQL reales del equipo. Fuente de verdad del comportamiento
esperado de los Stored Procedures. Organizados por categoría.

---

## Reportes de producción (mapean a los 7 SPs)

| Directorio | Script(s) | SP destino |
|---|---|---|
| `transferencia-menu-opcion/` | v0.0.1 → v0.3.1 (4 versiones) | `sp_rpt_centros_transferencia` |
| `clientes-unicos/` | q_REPTRIM011 | `sp_rpt_clientes` |
| `llamadas-abandonadas/` | q_REPTRIM021_LLAMADAS_ABDANDONADAS | `sp_rpt_llamadas_abandonadas` |
| `llamadas-menu/` | q_REPTRIM021 (v1) + q_REPTRIM121 (v2) | Sin SP definitivo — G-28 abierto |
| `centros-xsegmento/` | query_centros_transferencia_dias_habiles | `sp_rpt_centros_xsegmento` |

## Análisis derivados (fuera del Scope 1)

| Directorio | Script(s) | Notas |
|---|---|---|
| `promedio-clientes/` | REPTRIM031 + REPTRIM041 | Promedios — recomendado calcular en Django |

## Scripts de investigación (no son reportes)

| Directorio | Script | Qué documenta |
|---|---|---|
| `investigacion/nk90-descubrimiento/` | qCentros_de_transferencia_ID | 6 iteraciones que descubrieron BR-ROUTING-001 |
| `investigacion/catalogo-menus-trimestral/` | REPTRIM001-A1 | Matriz de presencia de menús por quarter |
| `investigacion/tabla-temporal-analisis/` | REPTRIM001-WS | Script workbench — tabla temporal multi-quarter |

---

## Scripts pendientes de recibir

| SP destino | Script esperado |
|---|---|
| `sp_rpt_menu_redirigidos` | Script_Transfer_Menu_Opcion.sql (parte) |
| `sp_rpt_menu_centro` | q_menu_centro_transferecia_010925.sql |
| `sp_rpt_cMENU_ERROR` | q_cMENU_ERROR.sql |

---

## Bugs recurrentes documentados

| Bug | Scripts afectados | Corrección para el SP |
|---|---|---|
| `@ONacionalB` ausente o `= 1902001` (falta un cero) | REPTRIM011, REPTRIM021a/b, REPTRIM001-A1, REPTRIM001-WS, REPTRIM031, REPTRIM041 | `SET @ONacionalB = 19020001` — siempre los 3 DIDs |
| `'Nacional'` colapsado (A+B juntos) | Todos los scripts | Separar `nacional_A` y `nacional_B` en las tablas base |
| `cMenu = NULL` en lugar de `cMenu IS NULL` | REPTRIM121 | Usar `IS NULL` siempre |
| `dias_habiles_desde_ultima_actividad` no definida | query_centros_dias_habiles | Definir la columna o renombrar la referencia |
| Fechas acotadas (no quarters completos) | REPTRIM001-WS | Solo aplica a ese script de workbench |

---

## Hallazgo arquitectónico clave: vista `llamadas_Q3`

`query_centros_transferencia_dias_habiles.sql` es el único script que
lee de la vista `llamadas_Q3` en lugar de `tbl_historico_*` directamente.
Las columnas de esa vista (`id_CTransferencia`, `menu`, `opcion`, `fecha`,
`numero_entrada`) ya están normalizadas — es una capa de abstracción sobre
las tablas crudas que el equipo usa para análisis sin tocar la fuente.

El SP `sp_rpt_centros_xsegmento` replicará esta abstracción leyendo de
`base_ivr_detalle` (que cumple el mismo rol de datos ya normalizados).
