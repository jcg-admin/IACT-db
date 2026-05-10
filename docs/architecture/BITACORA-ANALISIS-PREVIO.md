# Bitácora de análisis previo — sesión 2026-05-06/07

**Sesión:** 2026-05-06T21:50 → 2026-05-07T02:33 (transcript: `iact-db-etl-pipeline-v2-impl.txt`)
**Objetivo:** Análisis de reportes de producción, diseño del seed y generación
de los artefactos SQL del pipeline ETL v2.0.

Esta bitácora consolida el trabajo analítico que precedió a la ejecución
del plan (Fases 0-6). Sirve como contexto para entender por qué cada SP,
función y configuración fue diseñada de la manera en que está.

---

## Parte 1 — Análisis de reportes de producción

### Qué se analizó

Se analizaron 4 reportes exportados del sistema IVR de producción:

| Reporte | Archivo | Total registros | Documento |
|---|---|---|---|
| `prom_llamadas` | `prom_llamadas_Q1Q2Q3_2025.csv` | 34,101,981 | `REPORTE-PROM-LLAMADAS.md` |
| `clientes_unicos` | `clientes_unicos_Q1Q2Q3_2025.csv` | 9,617,998 | `REPORTE-CLIENTES-UNICOS.md` |
| `llamadas_cmenu` | `llamadas_cmenu_Q1Q2Q3_2025.csv` | 34,101,981 | `REPORTE-LLAMADAS-CMENU.md` |
| `c_menu` | `c_menu_Q1Q2Q3_2025.csv` | — | `REPORTE-C-MENU.md` |

---

### Hallazgos críticos que impactan los SPs

Los siguientes hallazgos son los que más afectan el diseño de los SPs
de reporte. Para el detalle completo ver los documentos `REPORTE-*.md`.

---

**AH-001 — Sentinel correcto es `telefono_cMenu`, no `MENU_10_NUMEROS`**
`Reporte: prom_llamadas` | `Impacta: sp_rpt_cMENU_ERROR`

El SP de producción que genera `prom_llamadas` usa la cadena literal
`'telefono_cMenu'` como sentinel para identificar registros donde
`cMenu` contiene un número de teléfono (10 u 11 dígitos) en lugar
de un nombre de menú. El seed y los SPs del proyecto deben usar
este mismo sentinel, no `'MENU_10_NUMEROS'` como se propuso inicialmente.

```sql
-- CORRECTO (producción usa este sentinel):
WHERE menu = 'telefono_cMenu'
-- INCORRECTO (no usar):
WHERE menu = 'MENU_10_NUMEROS'
```

**Corrección aplicada:** `sp_rpt_cMENU_ERROR` usa `'telefono_cMenu'`.

---

**AH-002 — cMenu se normaliza a UPPERCASE en todos los SPs excepto c_menu**
`Reportes: prom_llamadas, clientes_unicos, llamadas_cmenu` | `Impacta: sp_etl_base_detalle, sp_rpt_*`

Los reportes `prom_llamadas`, `clientes_unicos` y `llamadas_cmenu` muestran
valores de menú en UPPERCASE (`RES-FALLAINTERNET`, `DESBORDE_CABECERA`).
Solo `c_menu` preserva el mixed case original (`RES-FallaInternet`).

Esto implica que cada SP decide si normaliza o no. Para los SPs del proyecto:
- `sp_etl_base_detalle` → aplica `UPPER(TRIM(cMenu))` al cargar
- `sp_rpt_*` → reciben datos ya normalizados desde `base_ivr_detalle`

**Regla establecida:** `fn_normalizar_menu()` aplica `UPPER(TRIM())`.

---

**AH-003 — Segmento `Nacional` en producción = nacional_A + nacional_B combinados**
`Reporte: prom_llamadas` | `Impacta: sp_rpt_*, parámetro p_segmento`

El reporte de producción no distingue entre nacional_A (DID 19028031)
y nacional_B (DID 19020001) — los combina bajo la etiqueta `'Nacional'`.
Sin embargo, internamente el sistema sí los distingue.

**Decisión D-23:** Los SPs del proyecto soportan `p_segmento IN ('nacional_A',
'nacional_B', 'puebla', 'todas')`. El parámetro `'Nacional'` unificado
no se implementa — los clientes del API ven los segmentos por separado.

---

**AH-004 — Bug G-30: nacional_A ausente en Q01_25 de clientes_unicos (CRÍTICO)**
`Reporte: clientes_unicos` | `Impacta: sp_rpt_clientes, sp_etl_base_clientes, seed`

El reporte histórico de producción para Q01_25 no tiene fila para nacional_A.
La causa es el bug `@ONacionalB = 19028031` en los scripts de análisis que
generaron ese reporte — el DID de nacional_A fue asignado a la variable
de nacional_B, haciendo invisible a nacional_A.

**Impacto en el seed:** El seed usa los datos del reporte Q01 para calibrar
proporciones. El bug hace que Q01 tenga solo 2 filas en clientes_unicos
en lugar de 3. El seed corrige esto generando las 3 filas correctas.

**Regla en el SP:** `sp_etl_base_clientes` NO debe reproducir el bug.
Debe garantizar exactamente 3 filas (una por DID) para cada trimestre.

```sql
-- Verificación post-ETL:
SELECT COUNT(*) FROM base_ivr_clientes
WHERE trimestre = 'Q01_25';
-- Esperado: 3 (no 2 como el reporte histórico erróneo)
```

---

**AH-005 — Filas duplicadas de Nacional en llamadas_cmenu Q02 y Q03**
`Reporte: llamadas_cmenu` | `Impacta: sp_rpt_llamadas_menu, pendiente P-NEW-07`

El reporte `llamadas_cmenu` de Q02 y Q03 tiene DOS filas para `Nacional`:
una para `cDID_800Transfer = 19028031` y otra para `19020001`. El SP
de producción hace `GROUP BY cDID_800Transfer` pero muestra ambas con
la etiqueta `'Nacional'`.

El reporte de Q01 solo tiene UNA fila — consistente con el bug G-30
que excluía nacional_A del análisis.

**Decisión P-NEW-07 (pendiente):** ¿El SP original combina Nacional A+B
intencionalmente o es un bug de diseño? Por ahora los SPs del proyecto
muestran nacional_A y nacional_B por separado (no hay fila combinada).

---

**AH-006 — Excel corrompe valores NK90 con notación científica**
`Reporte: c_menu` | `Impacta: fn_normalizar_centro, documentación`

El reporte `c_menu` fue exportado a Excel. Excel convierte cadenas
numéricas largas (NK90) a notación científica:

| En reporte Excel | VDN real | Tipo NK90 |
|---|---|---|
| `1.309E+16` | `1309XXX` + 10 dígitos teléfono | NK90 len=17 |
| `1.30901E+16` | `13090104` + 10 dígitos | NK90 len=17 |
| `3.09004E+15` | `309004` + 10 dígitos | NK90 len=16 |

**Regla establecida:** Para analizar `c_menu`, siempre usar el CSV original,
nunca la exportación Excel. Los SPs usan `fn_normalizar_centro()` que
maneja los NK90 por longitud (`LENGTH > 10`), no por el valor Excel.

---

**AH-007 — VDN = `'0'` indica transferencia sin centro real**
`Reporte: c_menu` | `Impacta: sp_rpt_centros_xsegmento`

Muchos menús tienen `VDN = '0'` en `c_menu`. Esto indica que la llamada
llegó al menú pero no completó la transferencia a ningún centro.
El SP `sp_rpt_centros_xsegmento` excluye estos registros con
`WHERE centro_transferencia != 'CASO_NULL'`.

---

**AH-008 — Cambios de VDN entre quarters confirman evolución de enrutamiento**
`Reporte: c_menu` | `Impacta: PERFILES-QUARTER.md, perfiles q01-q03`

El reporte `c_menu` muestra que el VDN destino de un mismo menú cambia
entre Q01 y Q03. Por ejemplo, el menú de mayor volumen cambió de VDN
`13090104XX` a `19010000XX` entre Q01 y Q02. Esto confirma que los
perfiles deben ser específicos por quarter y no usar un único perfil.

---

## Parte 2 — Diseño del generador de seed

### Contexto

Se creó `poblar_historico.py` — un motor de generación de datos sintéticos
que replica las características estadísticas de producción. Ver
`PERFILES-QUARTER.md` para la arquitectura completa.

---

### Decisiones de diseño clave

**SD-001 — Proporciones por DID calibradas contra reportes reales**
```python
SEGMENTOS = [
    ('19028031', 0.45),   # Nacional A — dominante (19028031 → 'nacional_A')
    ('19020001', 0.30),   # Nacional B           (19020001 → 'nacional_B')
    ('19020084', 0.25),   # Puebla               (19020084 → 'puebla')
]
```
Calibradas contra `prom_llamadas` Q1-Q3 2025. Nacional A ≈ 45%,
Nacional B ≈ 30%, Puebla ≈ 25% en producción.

---

**SD-002 — Mapeo canónico DID → segmento (G-30 corregido)**
Documentado en `MAPEO-DID-SEGMENTOS.md`:

| DID numérico | Segmento | Nota |
|---|---|---|
| `19028031` | `'nacional_A'` | DID principal Nacional |
| `19020001` | `'nacional_B'` | DID secundario Nacional |
| `19020084` | `'puebla'` | DID Puebla exclusivo |

El bug G-30 confundía `19028031` con `nacional_B`. El mapeo canónico
garantiza que `fn_did_segmento('19028031') = 'nacional_A'`.

---

**SD-003 — Perfiles por quarter (acumulación)**

Cada quarter añade menús y VDNs nuevos sobre los del anterior:

| Quarter | Menús | VDNs | Tipo |
|---|---|---|---|
| Q01_2025 | 44 | 39 | BASE |
| Q02_2025 | 50 | 47 | ACUMULADO q01 + nuevos Q02 |
| Q03_2025 | 55 | 52 | ACUMULADO q01+q02 + nuevos Q03 |
| Q04_2025 | 55 | 52 | PROXY → q03 (sin cambios) |
| Q01_2026 | 44 | 39 | PROXY → q01_2025 |
| Q02_2026 | 50 | 47 | PROXY → q02_2025 (escala 0.462) |

---

**SD-004 — Anomalías de producción replicadas en el seed**

El seed replica las siguientes anomalías que aparecen en producción
(documentadas en `TBL-HISTORICO-ANOMALIAS.md`):

| Bug | Descripción | Tasa en seed |
|---|---|---|
| G-29 | dHoraInicio > dHoraFin (horas invertidas) | ~38.8% de registros |
| G-30 | Corregido en el seed — no se replica intencionalmente | — |
| NK90 | cDID_Centro_Transferencia = VDN + teléfono concatenados | Variable por menú |
| CLIENTE_COLGO | Registro de abandono | ~12% |
| CASO_NULL | Sin centro de transferencia | ~15% |
| CASO_ERROR_CEROS | Centro = `00000000` | <1% |
| ERROR_CARACTER_INICIAL | Centro empieza con `@` o `#` | <1% |

---

**SD-005 — tbl_historico_t2_2026 queda vacía intencionalmente**

El seed no genera datos para Q02_2026 porque en el momento del análisis
ese quarter aún estaba en curso y los datos reales son parciales.
`tbl_historico_t2_2026` tiene 0 filas. El ETL nocturno la procesaría
cuando lleguen datos reales.

---

## Parte 3 — Diseño de los artefactos SQL

### Decisiones de arquitectura (síntesis)

Las decisiones completas están en `ANALISIS-ARQUITECTURA-ETL.md`.
Aquí se resumen las más relevantes para los tests:

---

**SA-001 — Función `fn_normalizar_centro` — orden crítico de ramas**

La función tiene ramas en este orden obligatorio:
1. NULL / vacío → `'CASO_NULL'`
2. `cliente_colgo` → `'CLIENTE_COLGO'`  ← **DEBE ir antes de LENGTH > 10**
3. Todo ceros → `'CASO_ERROR_CEROS'`
4. Carácter inicial @ o # → `'ERROR_CARACTER_INICIAL'`
5. LENGTH > 10 → truncar como NK90
6. Resto → pass-through

**Por qué el orden es crítico:** `'cliente_colgo'` tiene 13 caracteres
(> 10). Si la rama `LENGTH > 10` se evalúa primero, `fn_normalizar_centro('cliente_colgo')`
retornaría `'clie'` (los primeros 4 caracteres del NK90 len=13).
El test T-013 verifica esto explícitamente.

---

**SA-002 — `ivr_es_dia_semana` — festivos hardcoded, Semana Santa excluida**

La función tiene los 7 festivos fijos del Art. 74 LFT hardcoded:
`01-01`, `02-05`, `03-21`, `05-01`, `09-16`, `11-02`, `11-20`, `12-25`.

**Exclusión deliberada de Semana Santa:** Jueves y Viernes Santo son
fechas variables. No están en el catálogo porque requieren cálculo
complejo (algoritmo de Gauss). Requieren decisión del equipo antes
de T-015.

**Impacto en datos de producción Q01_2025:**
- Jueves Santo 2025 = 2025-04-17 → NO en catálogo → clasificado como DÍA HÁBIL
- Viernes Santo 2025 = 2025-04-18 → NO en catálogo → clasificado como DÍA HÁBIL

---

**SA-003 — Estrategia ON DUPLICATE KEY para idempotencia**

`sp_etl_base_detalle` usa `ON DUPLICATE KEY UPDATE` sobre la clave
única `(trimestre, fecha, segmento, centro_transferencia, menu, opcion)`.
Esto hace que llamar al SP dos veces sobre el mismo rango produce el
mismo resultado (idempotente). Verificado en T-033.

---

**SA-004 — sp_etl_historico: puerta de entrada manual**

`sp_etl_historico` tiene 0 nodos que lo llamen en el grafo (confirmado
en `GRAFO-DEPENDENCIAS.md`). Solo se invoca manualmente para el backfill
inicial. Debe quedar deshabilitado en `job_config` post-backfill (T-044b).

---

**SA-005 — `sp_rpt_centros_xsegmento` usa WHILE O(n días)**

`ivr_contar_dias_semana` y `ivr_agregar_dias_semana` usan bucles WHILE
que iteran día a día. Con datos de 5 quarters y muchos centros distintos,
esto puede ser lento. El umbral establecido es < 8s en T-083. Si supera
ese umbral, la solución es pre-computar `dias_semana_sin_actividad` en el ETL.

---

## Parte 4 — Puntos de decisión pendientes

Preguntas que surgieron del análisis y quedaron sin resolver.
Bloquean tasks específicas del plan.

| ID | Pregunta | Bloquea | Prioridad |
|---|---|---|---|
| P-NEW-02 | ¿Sentinel final: `'telefono_cMenu'` o separar por longitud (10 vs 11 dígitos)? | sp_rpt_cMENU_ERROR | Media |
| P-NEW-03 | ¿`DEFAULT` como cMenu en Puebla Q02 es bug del IVR o menú válido? | seed, sp_etl | Baja |
| P-NEW-04 | ¿`sp_etl_base_clientes` usa `cTelefono_Origen` o `cTelefono_Digitado`? | T-034 | Alta |
| P-NEW-07 | ¿El SP original combina Nacional A+B intencionalmente o es bug? | sp_rpt_llamadas_menu | Media |
| P-NEW-08 | ¿`llamadas_cmenu` y `prom_llamadas` son el mismo SP con distinta proyección? | documentación | Baja |
| P-Semana-Santa | CERRADO — IVR opera 7 dias, festivos no aplican | T-015 | — |

---

## Parte 5 — Artefactos generados en esta sesión

Todo lo generado quedó en el repositorio bajo `provisioners/mariadb/`:

| Archivo | Líneas | Contenido |
|---|---|---|
| `funciones_utilidad.sql` | 291 | 7 funciones: fn_did_segmento, fn_normalizar_menu, fn_normalizar_centro, fn_duracion_seg, ivr_es_dia_semana, ivr_contar_dias_semana, ivr_agregar_dias_semana |
| `schema_base_ivr.sql` | 225 | DDL: 5 tablas IACT (base_ivr_detalle con llamadas_entre_semana/fines_semana, base_ivr_clientes, job_execution_log, etl_runs, job_config) |
| `sp_etl_pipeline.sql` | 481 | 5 SPs ETL: sp_etl_base_detalle, sp_etl_base_clientes, sp_etl_validar, sp_etl_maestro, sp_etl_historico |
| `sp_rpt_reportes.sql` | 419 | 7 SPs de reporte: sp_rpt_clientes, sp_rpt_centros_transferencia, sp_rpt_llamadas_abandonadas, sp_rpt_menu_redirigidos, sp_rpt_menu_centro, sp_rpt_cMENU_ERROR, sp_rpt_centros_xsegmento |
| `poblar_historico.py` | 558 | Motor de generación de seed con perfiles por quarter |
| `perfiles/q01_2025.py` | — | BASE: 44 menús, 39 VDNs |
| `perfiles/q02_2025.py` | — | ACUMULADO: 50 menús, 47 VDNs |
| `perfiles/q03_2025.py` | — | ACUMULADO: 55 menús, 52 VDNs |
| `perfiles/q04_2025.py` | — | PROXY → q03 |
| `perfiles/q01_2026.py` | — | PROXY → q01_2025 |
| `perfiles/q02_2026.py` | — | PROXY → q02_2025, escala 0.462 |

---

## Ver también

- `REPORTE-PROM-LLAMADAS.md` — 7 hallazgos detallados
- `REPORTE-CLIENTES-UNICOS.md` — 5 hallazgos incluyendo bug G-30
- `REPORTE-LLAMADAS-CMENU.md` — 5 hallazgos incluyendo duplicado Nacional
- `REPORTE-C-MENU.md` — 7 hallazgos incluyendo NK90 y Excel
- `TBL-HISTORICO-ANOMALIAS.md` — 12 tipos de anomalías en tablas fuente
- `VALIDACION-SEED-REPORTES.md` — Validación cruzada seed vs reportes
- `MAPEO-DID-SEGMENTOS.md` — Canónico DID → segmento y bug G-30
- `PERFILES-QUARTER.md` — Arquitectura de perfiles de acumulación
- `ANALISIS-ARQUITECTURA-ETL.md` — 7 problemas del ETL v1 y propuesta v2
- `FLUJO-ETL-V2.md` — Flujo completo v2.0 con funciones y pipeline granular
- `GRAFO-DEPENDENCIAS.md` — 47 nodos, 74 aristas, análisis de impacto

