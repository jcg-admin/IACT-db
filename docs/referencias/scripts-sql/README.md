# Scripts SQL de referencia — Análisis ad-hoc de producción

Scripts SQL reales del equipo. Fuente de verdad del comportamiento
esperado de los Stored Procedures. Organizados por categoría.

---

## Reportes de producción — los 7 SPs cubiertos

| Directorio | Script(s) | SP destino | Cobertura |
|---|---|---|---|
| `transferencia-menu-opcion/` | v0.0.1 → v0.3.1 (4 versiones) | `sp_rpt_centros_transferencia` | Completa |
| `centros-xsegmento/` | query_centros_transferencia_dias_habiles | `sp_rpt_centros_xsegmento` | Completa |
| `llamadas-abandonadas/` | q_REPTRIM021_LLAMADAS_ABDANDONADAS | `sp_rpt_llamadas_abandonadas` | Completa |
| `menu-redirigidos/` | mariadb_analisis_transferencias_menu | `sp_rpt_menu_redirigidos` | Completa |
| `menu-centro/` | q_menu_centro_transferecia_010925 | `sp_rpt_menu_centro` | Completa |
| `cmenu-error/` | q_cMENU_ERROR | `sp_rpt_cMENU_ERROR` | Completa |
| `clientes-unicos/` | q_REPTRIM011 | `sp_rpt_clientes` | Completa |

Los 7 SPs canónicos tienen script de referencia.

---

## Análisis derivados (fuera Scope 1)

| Directorio | Script(s) | Notas |
|---|---|---|
| `llamadas-menu/` | REPTRIM021 (v1) + REPTRIM121 (v2) | G-28 abierto — distribución general de menús |
| `promedio-clientes/` | REPTRIM031 + REPTRIM041 | Promedios — recomendado calcular en Django |

---

## Scripts de investigación

| Directorio | Script | Qué documenta |
|---|---|---|
| `investigacion/nk90-descubrimiento/` | qCentros_de_transferencia_ID | 6 iteraciones → BR-ROUTING-001 |
| `investigacion/catalogo-menus-trimestral/` | REPTRIM001-A1 | Matriz presencia de menús por quarter |
| `investigacion/tabla-temporal-analisis/` | REPTRIM001-WS | Script workbench — tabla temporal |
| `investigacion/tasa-abandono-duracion/` | q_analisis_centros_transfer_tasa_abandono | Abandono por duración < 30 seg |
| `investigacion/redireciones-analisis/` | q_analisis_redireciones_total | Frecuencia de redirecciones |

---

## Bugs críticos por corregir al implementar los SPs

| Bug | Scripts afectados | Corrección |
|---|---|---|
| `@ONacionalB` ausente | REPTRIM011, REPTRIM021, REPTRIM031, REPTRIM041 | `SET @ONacionalB = 19020001` |
| `@ONacionalB = 1902001` (falta cero) | REPTRIM021_ABONDONADAS, REPTRIM021_MENU, REPTRIM001-A1, REPTRIM001-WS | `= 19020001` |
| `@ONacionalB = 19028031` (igual a NacionalA) | `q_menu_centro_transferecia` | **Bug más grave** — produce doble conteo de Nacional A |
| `@ONacionalB` declarada pero sin usar | REPTRIM021_ABANDONADAS, REPTRIM021_MENU | Agregar al WHERE |
| `@ONacionalB` usada sin declarar | `q_analisis_redireciones_total` | Declarar `SET @ONacionalB = 19020001` |
| WHERE sin paréntesis (`AND x = y OR z IN`) | `q_analisis_centros_transfer_tasa_abandono` | Envolver en paréntesis |
| WHERE lógica invertida (`IS NULL OR != ''`) | `q_analisis_redireciones_total` | Cambiar a `IS NOT NULL AND != ''` |
| `cMenu = NULL` (nunca TRUE) | REPTRIM121 v2 | Cambiar a `cMenu IS NULL` |
| Sin normalización NK90 | `q_menu_centro_transferecia`, `q_analisis_centros_transfer_tasa_abandono`, `q_analisis_redireciones_total` | Aplicar `CASE LENGTH > 10 THEN LEFT(campo, LENGTH-10)` |
| `SELECT *` sin agregación | `q_cMENU_ERROR` | SP debe agregar por (quarter, menu, total) |
| cMENU_ERROR mezcla VACIO + anomalías | `q_cMENU_ERROR` | SP solo filtra `REGEXP '^[0-9]+'` |
| Fechas acotadas (no Q completo) | `q_menu_centro_transferecia`, `q_analisis_*` | Solo afectan a scripts de análisis, no a SPs |

---

## Hallazgo clave: los scripts de la vista `llamadas_Q3`

Dos scripts leen de la vista `llamadas_Q3` en lugar de `tbl_historico_*`:
- `query_centros_transferencia_dias_habiles.sql` (centros-xsegmento)
- `mariadb_analisis_transferencias_menu.sql` (menu-redirigidos)

Esta vista expone columnas ya normalizadas (`id_CTransferencia`, `menu`,
`opcion`, `numero_digitado`, `etiquetas`, `nidMQ`) que no están en
`base_ivr_detalle`. Si los SPs necesitan estas columnas (P-13), el ETL
requiere capturarlas en una tabla base adicional.
