# Scripts SQL de referencia — Análisis ad-hoc de producción

Scripts SQL reales utilizados por el equipo para obtener la data de los
reportes IVR. Son la fuente de verdad del comportamiento esperado de los
Stored Procedures que se implementarán.

**Importante:** Estos scripts operan directamente sobre `tbl_historico_*`
(full table scan de ~11-14M filas). Los SPs de producción operarán sobre
las tablas base `base_ivr_detalle` y `base_ivr_clientes` (miles de filas,
indexadas). El resultado debe ser equivalente, no el mecanismo.

---

## Índice por reporte

| Directorio | SP de destino | Estado |
|---|---|---|
| `transferencia-menu-opcion/` | `sp_rpt_centros_transferencia` | 4 versiones — v0.3.1 es la actual |
| `clientes-unicos/` | `sp_rpt_clientes` | 1 versión — bug @ONacionalB faltante |

---

## Scripts pendientes de recibir

Los siguientes SPs aún no tienen script de referencia:

| SP destino | Script esperado |
|---|---|
| `sp_rpt_centros_xsegmento` | Script_Centros_Dias_Habiles.sql |
| `sp_rpt_llamadas_abandonadas` | Script_Llamadas_Abandonadas.sql |
| `sp_rpt_menu_redirigidos` | Parte de Script_Transfer_Menu_Opcion.sql |
| `sp_rpt_menu_centro` | q_menu_centro_transferecia_010925.sql |
| `sp_rpt_cMENU_ERROR` | q_cMENU_ERROR.sql |

---

## Convención de nombres de archivos

```
{version}_{nombre_original}.sql
```

Para scripts sin versionado explícito se usa el nombre original tal cual.

---

## Problemas recurrentes identificados en los scripts

Dos problemas aparecen en múltiples scripts y deben corregirse en todos
los SPs:

**1. @ONacionalB ausente o incorrecto**

Varios scripts solo usan `@ONacional = 19028031` (Nacional A) y omiten
`@ONacionalB = 19020001` (Nacional B). Todos los reportes de Nacional
están sub-contados.

**2. Segmentos colapsados como "Nacional"**

Los scripts muestran `'Nacional'` como etiqueta única para Nacional A y B.
Los SPs deben mantener `'nacional_A'` y `'nacional_B'` separados en
`base_ivr_detalle` y `base_ivr_clientes`, ofreciendo la consolidación
como opción de parámetro.

---

## Ver también

- `docs/architecture/ETL-SPS-REPORTE.md` — análisis de los 7 SPs
- `docs/architecture/ETL-ANALISIS.md` — flujo ETL completo
- `docs/getting-started/HISTORICO-IVR.md` — schema de las tablas fuente
