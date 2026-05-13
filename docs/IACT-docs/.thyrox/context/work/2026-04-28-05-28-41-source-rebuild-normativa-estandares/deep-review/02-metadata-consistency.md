```yml
created_at: 2026-04-28 07:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-41-source-rebuild-normativa-estandares
phase: Phase 11 — TRACK (artefacto deep-review)
agent_id: afad410e81f0dd005
invocation_bound: ~38 archivos · ≤8 hallazgos · solo bloque .. meta::
author: deep-review agent (invocado por orquestador)
status: Aprobado
version: 1.0.0
```

# Deep-Review 02 — Consistencia de Metadata YAML

Output verbatim del agente `deep-review` invocado para auditar la
consistencia de los bloques ``.. meta::`` en todos los archivos
del dominio.

## Inventario por estado de metadata

**Total verificado:** 38 archivos `.rst` (1 índice raíz + 6 STDs +
3 guías + 27 templates + 1 índice de plantillas).

| # | Archivo | Tiene `.. meta::` | Schema | Problema |
|---|---------|-------------------|--------|----------|
| 1 | ``GUIA_ESTILO.rst`` | NO | — | ALTA — sin bloque `.. meta::` |
| 2 | ``estandares_codigo.rst`` | NO | — | ALTA — sin bloque `.. meta::` |
| 3 | ``shell_scripting_guide.rst`` | NO | — | ALTA — sin bloque `.. meta::` |
| 4 | ``index.rst`` (raíz) | NO | — | ALTA — sin bloque `.. meta::` |
| 5 | ``STD_001_...`` | SÍ | nuevo (10 campos) | OK |
| 6 | ``STD_002_...`` | SÍ | nuevo (10 campos) | OK |
| 7 | ``STD_006_...`` | SÍ | nuevo, sin ``ultimo_cambio`` ni ``clasificacion`` | MEDIA — 8 campos |
| 8 | ``STD_007_...`` | SÍ | nuevo, sin ``ultimo_cambio`` ni ``clasificacion`` | MEDIA — 8 campos |
| 9 | ``STD_Naming_Identificadores.rst`` | SÍ | nuevo (10 campos) | OK |
| 10 | ``STD_Profesional_Documentacion.rst`` | SÍ | nuevo (10 campos) | OK |
| 11–22 | ``TPL_ADR``, ``TPL_API``, ``TPL_BR_Business_Rules``, ``TPL_BReq``, ``TPL_CNST``, ``TPL_FD``, ``TPL_FR_Requisitos``, ``TPL_INDEX``, ``TPL_MOD``, ``TPL_NFR``, ``TPL_POL``, ``TPL_PROC``, ``TPL_STD``, ``TPL_TST``, ``TPL_UC_Casos_de_Uso``, ``TPL_VIEW`` | SÍ | nuevo, sin ``ultimo_cambio`` ni ``clasificacion`` | MEDIA — 8 campos |
| 23 | ``plantillas/index.rst`` | SÍ | nuevo (9 campos, sin ``clasificacion``) | BAJA |
| 24 | ``TPL_BR_Decision_Tipo.rst`` | SÍ | **legacy** | CRÍTICA |
| 25 | ``TPL_FR_Documentacion_10_Componentes.rst`` | SÍ | **legacy** | CRÍTICA |
| 26 | ``TPL_FR_Query_SQL.rst`` | SÍ | **legacy** | CRÍTICA |
| 27 | ``TPL_FR_Validacion_Reglas.rst`` | SÍ | **legacy** | CRÍTICA |
| 28 | ``TPL_TRZ_Matriz_RTM.rst`` | SÍ | **legacy** | CRÍTICA |
| 29 | ``TPL_UC_Actor_Secundario.rst`` | SÍ | **legacy** | CRÍTICA |
| 30 | ``TPL_UC_CRUD_Operaciones.rst`` | SÍ | **legacy** | CRÍTICA |
| 31 | ``TPL_UC_Construccion_7_Pasos.rst`` | SÍ | **legacy** | CRÍTICA |
| 32 | ``TPL_UC_Larman_Contratos.rst`` | SÍ | **legacy** | CRÍTICA |
| 33 | ``TPL_UC_Stakeholder_Driven.rst`` | SÍ | **legacy** | CRÍTICA |
| 34 | ``TPL_UC_Temporal_Schedulers.rst`` | SÍ | **legacy** | CRÍTICA |
| 35 | ``TPL_UC_UI_Driven.rst`` | SÍ | **legacy** | CRÍTICA |

## Hallazgos

### F-01 [CRÍTICA] Doble schema coexistente

12 templates usan keys legacy en PascalCase con tilde mismatch:
``:Proyecto:``, ``:Codigo:``, ``:Titulo:``, ``:Version:``,
``:Tipo:``, ``:Fecha:``, ``:Autor:``, ``:Estado:``. El resto del
corpus usa schema nuevo en minúsculas:
``artefacto/tipo/dominio/subdominio/estado/version/fecha_creacion/
autor``. Inconsistencia bloquea queries uniformes sobre metadata.

### F-02 [ALTA] 4 archivos sin `.. meta::`

``GUIA_ESTILO.rst``, ``estandares_codigo.rst``,
``shell_scripting_guide.rst``, ``index.rst`` (raíz). Tres son
guías de primera línea del subdominio.

### F-03 [ALTA] Versiones embebidas en títulos (violación STD_006)

Todos los TPL del schema nuevo repiten la versión en el H1:
``TPL_ADR: ... v1.0.0``, ``TPL_API: ... v1.1.0``,
``TPL_UC: ... v2.0.0``, etc. STD_006 establece que la versión vive
en metadata, no en el título/filename.

### F-04 [MEDIA] Campos `ultimo_cambio` y `clasificacion` inconsistentes

Solo 4 de 22 archivos con schema nuevo tienen los 10 campos. Los
18 restantes (incluidos STD_006 y STD_007) omiten ambos.

### F-05 [MEDIA] `:tipo:` con tilde inconsistente

Schema nuevo usa ``Estándar`` (con tilde) en STDs y ``Plantilla``
en TPLs — consistente. Schema legacy usa ``:Tipo:`` como enum de
valor de instancia (``Restriccion|Calculo|...``, ``Query_SQL``,
``Normal|CRUD|Temporal|UI-Driven``) — semántica completamente
distinta del campo homónimo en schema nuevo. Choque de namespace.

### F-06 [MEDIA] `:artefacto:` con casing mixto

Convención dominante: PascalCase con underscore corto (``STD_001``,
``TPL_ADR``, ``TPL_UC``). Outliers: ``STD_NAMING_IDENTIFICADORES``,
``STD_PROFESIONAL_DOCUMENTACION``, ``INDEX_PLANTILLAS`` —
UPPER_SNAKE_CASE. Sin regla explícita.

### F-07 [BAJA] `:tipo: Índice` con tilde

Solo en ``plantillas/index.rst``. El resto del corpus usa valores
sin diacríticos en ``:tipo:``. No es error per se.

### F-08 [INFO] dominio/subdominio consistentes

Todos los archivos con schema nuevo usan ``:dominio: normativa``
y ``:subdominio: estandares`` (raíz) o
``:subdominio: estandares/plantillas``. Sin desviación. Fechas
en formato ISO ``YYYY-MM-DD`` consistentes.

## Recomendaciones agrupadas

**Migrar schema legacy → nuevo (12 archivos, F-01):**
Renombrar keys: ``:Proyecto:``→ eliminar (implícito por dominio),
``:Codigo:``→``:artefacto:``, ``:Titulo:``→ eliminar (vive en H1),
``:Version:``→``:version:``, ``:Fecha:``→``:fecha_creacion:``,
``:Autor:``→``:autor:``, ``:Estado:``→``:estado:``, agregar
``:tipo: Plantilla``, ``:dominio: normativa``,
``:subdominio: estandares/plantillas``.

**Agregar `.. meta::` (4 archivos, F-02):** crear bloque con
schema nuevo de 10 campos.

**Eliminar versión de títulos (16+ archivos, F-03):** quitar
sufijo ``v1.0.0``, ``v1.1.0``, etc. de los H1.

**Normalizar campos faltantes (18 archivos, F-04):** agregar
``:ultimo_cambio:`` y ``:clasificacion: Interno``.

**Definir regla de casing para `:artefacto:` (F-06):** documentar
si va en PascalCase corto o UPPER_SNAKE largo.

**Consolidar semántica de `:tipo:` (F-05):** decidir si es
categoría de artefacto o variable de instancia.
