# Scripts SQL de referencia — Análisis ad-hoc de producción

Scripts SQL reales del equipo. Son la fuente de verdad del comportamiento
esperado de los Stored Procedures que se implementarán.

Estos scripts operan sobre `tbl_historico_*` (full table scan de ~11-14M
filas). Los SPs de producción operarán sobre `base_ivr_detalle` y
`base_ivr_clientes` (miles de filas, indexadas). El resultado debe ser
equivalente, no el mecanismo.

---

## Directorio de scripts

| Directorio | Script(s) | SP destino | Estado mapeo |
|---|---|---|---|
| `transferencia-menu-opcion/` | v0.0.1 → v0.3.1 (4 versiones) | `sp_rpt_centros_transferencia` | Directo |
| `clientes-unicos/` | q_REPTRIM011 | `sp_rpt_clientes` | Directo — bug @ONacionalB |
| `llamadas-abandonadas/` | q_REPTRIM021_LLAMADAS_ABDANDONADAS | `sp_rpt_llamadas_abandonadas` | Directo — bug @ONacionalB |
| `llamadas-menu/` | q_REPTRIM021_LLAMADAS_MENU | Sin SP definido (G-28 abierto) | Por confirmar |
| `promedio-clientes/` | q_REPTRIM031 + q_REPTRIM041 | Fuera del Scope 1 | Decisión pendiente |

---

## Scripts pendientes de recibir

| SP destino | Script esperado |
|---|---|
| `sp_rpt_centros_xsegmento` | Script_Centros_Dias_Habiles.sql |
| `sp_rpt_menu_redirigidos` | Script_Transfer_Menu_Opcion.sql (parte) |
| `sp_rpt_menu_centro` | q_menu_centro_transferecia_010925.sql |
| `sp_rpt_cMENU_ERROR` | q_cMENU_ERROR.sql |

---

## Bugs recurrentes en todos los scripts

Tres problemas aparecen sistemáticamente y deben corregirse en todos los SPs:

### Bug 1 — @ONacionalB ausente o con valor incorrecto

| Script | Problema |
|---|---|
| q_REPTRIM011_CLIENTES_UNICOS | `@ONacional = 19028031` — sin @ONacionalB |
| q_REPTRIM021_LLAMADAS_ABDANDONADAS | `@ONacional02 = 1902001` — falta un cero (incorrecto) |
| q_REPTRIM021_LLAMADAS_MENU | `@ONacional02 = 1902001` — falta un cero (incorrecto) |
| q_REPTRIM031_PROMEDIO | `@ONacional = 19028031` — sin @ONacionalB |
| q_REPTRIM041_PROMEDIO_MENU | `@ONacional = 19028031` — sin @ONacionalB |

El DID correcto de Nacional B es `19020001`. Todos los análisis de "Nacional"
en estos scripts están sub-contados por excluir Nacional B.

### Bug 2 — 'Nacional' colapsado (Nacional A + B como un solo segmento)

Todos los scripts mapean los dos DIDs nacionales a la etiqueta `'Nacional'`.
Los SPs deben mantener `'nacional_A'` y `'nacional_B'` separados en las
tablas base y ofrecer la consolidación como opción.

### Bug 3 — Inconsistencia en el campo de cliente único

| Script | Campo usado |
|---|---|
| REPTRIM011 | `cTelefono_Origen` |
| REPTRIM031, REPTRIM041 | `cTelefono_Digitado` |

Confirmar con el equipo cuál es la definición canónica de "cliente único"
antes de implementar `sp_etl_base_clientes`.

---

## Naming: colisión REPTRIM021

Dos scripts tienen el mismo número de serie `021`:

- `q_REPTRIM021_LLAMADAS_ABDANDONADAS.sql` → `sp_rpt_llamadas_abandonadas`
- `q_REPTRIM021_LLAMADAS_MENU.sql` → SP no definido (análisis general de menús)

No hay colisión funcional, pero el naming sugiere que son variantes del
mismo análisis. Al implementar los SPs se resuelve con nombres explícitos.

