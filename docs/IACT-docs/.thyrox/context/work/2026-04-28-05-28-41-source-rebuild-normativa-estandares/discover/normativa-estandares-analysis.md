```yml
created_at: 2026-04-28 06:35:00
project: IACT-docs
work_package: 2026-04-28-05-28-41-source-rebuild-normativa-estandares
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Phase 1 DISCOVER — Source Rebuild: normativa/estandares

## 1. Propósito del WP-hijo

Reconstruir el dominio ``source/normativa/estandares/``: standards
técnicos del proyecto IACT (STDs) + plantillas (TPLs) +
guías auxiliares. Dominio crítico porque sus salidas son **inputs
hard** del WP #6 requisitos (templates de UC/BR/FR/NFR) y de los
8 cajones técnicos (#8-15) vía STDs.

## 2. Inventario verificado

### 2.1 Backup canónico (`temp-backup/source-2026-04-28/normativa/estandares/`)

**27 archivos**:

Top-level (6):

- ``index.rst``
- ``STD_006_Versionado_Semantico.rst``
- ``STD_007_Convencion_Naming.rst``
- ``GUIA_ESTILO.rst``
- ``estandares_codigo.rst``
- ``shell_scripting_guide.rst``

Subcarpeta ``plantillas/`` (21):

- ``index.rst``
- ``TPL_002_Plantilla_UC_v2.rst`` (legacy naming, irregular)
- ``TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst``
- ``TPL_API_Documentacion_API_1_1_0.rst``
- ``TPL_BR_Business_Rules_1_0_0.rst``
- ``TPL_BReq_Objetivos_Negocio_1_0_0.rst``
- ``TPL_CNST_Restricciones_1_0_0.rst``
- ``TPL_FD_Flujos_Datos_1_0_0.rst``
- ``TPL_FR_Requisitos_Funcionales_1_0_0.rst``
- ``TPL_INDEX_Indices_1_0_0.rst``
- ``TPL_MOD_Modulos_1_0_0.rst``
- ``TPL_NFR_No_Funcionales_1_0_0.rst``
- ``TPL_POL_Politicas_1_0_0.rst``
- ``TPL_PROC_Procedimientos_1_0_0.rst``
- ``TPL_RTM_Trazabilidad_1_0_0.rst``
- ``TPL_STD_Estandares_1_0_0.rst``
- ``TPL_TST_Pruebas_1_0_0.rst``
- ``TPL_UC_Casos_de_Uso_2_0_0.rst`` (v2.0.0)
- ``TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst``

Todos los TPL del backup violan STD_006 (versión en filename).
Renombrado obligatorio.

### 2.2 Set curado de templates (`temp-holding/.../iact_templates_v1_3_0/`)

**13 archivos** (incluye README.txt) — versión más reciente (v1.3.0):

- ``TPL_BR_Decision_Tipo_1_3_0.rst``
- ``TPL_FR_Documentacion_10_Componentes_1_3_0.rst``
- ``TPL_FR_Query_SQL_1_3_0.rst``
- ``TPL_FR_Validacion_Reglas_1_3_0.rst``
- ``TPL_TRZ_Matriz_RTM_1_3_0.rst``
- ``TPL_UC_Actor_Secundario_1_3_0.rst``
- ``TPL_UC_CRUD_Operaciones_1_2_0.rst``
- ``TPL_UC_Construccion_7_Pasos_1_3_0.rst``
- ``TPL_UC_Larman_Contratos_1_2_0.rst``
- ``TPL_UC_Stakeholder_Driven_1_3_0.rst``
- ``TPL_UC_Temporal_Schedulers_1_3_0.rst``
- ``TPL_UC_UI_Driven_1_3_0.rst``
- ``README.txt``

Aporta:

- **7 variantes UC** distintas (Actor_Secundario, CRUD, Construccion,
  Larman, Stakeholder_Driven, Temporal, UI_Driven) — patrones
  distintos, **no fusionar** (Decision 6 strategy v2.0).
- **3 variantes FR** (Documentacion, Query_SQL, Validacion).
- **1 BR** (Decision_Tipo).
- **1 TRZ** (Matriz_RTM, equivalente a TPL_RTM existente — fusionar
  o discriminar propósito).

### 2.3 STD_001 — múltiples versiones

`temp-holding` tiene 6 ubicaciones con STD_001:

- ``FASE 01/STD_001_Estandares_Documentacion_Sin_Emojis_2_0_0.rst``
  — **v2.0.0 (más reciente)**, agrega "Sin_Emojis" al scope.
- ``FASE 01/STD_001_Estandares_Documentacion_Sin_Emojis_1_1_0.rst``
- ``FASE 02/originales/STD_001_Estandares_Documentacion_1_1_0.rst``
- ``FASE 02/tmp_work/STD_01_Estandares_Documentacion_Sin_Emojis_1_0_0.rst``
- ``FASE 02/base_cognitiva/utilidades/STD_001_Estandares_Documentacion_1_1_0.rst``
- ``GENERACION_DOCUMENTACION/FASE 1/STD_001_Estandares_Documentacion_1_1_0.rst``

**Canónico: v2.0.0 ``Sin_Emojis``** — prohibición de emojis en
documentación es una decisión activa del proyecto que la versión
1.1.0 no contempla.

### 2.4 Análisis previos del ejecutor (5 inputs obligatorios)

- ``temp-holding/FASE 02/tmp_work/ANALISIS_TEMPLATES_VERSIONES.md``
- ``temp-holding/FASE 02/tmp_work/PLAN_TEMPLATES_3_12_v1_2_0.md``
- ``temp-holding/FASE 01/TLP_Templates/ANALISIS_NOMENCLATURA_TPL_1_0_0.md``
- ``temp-holding/FASE 01/TLP_Templates/PLAN_GENERACION_TPL_1_0_0.md``
- 10 ``PROPUESTA_TEMPLATE_*.txt`` en ``temp-holding/FASE 02/tmp_work/``

Inspección: estos análisis confirman que los templates v1.3.0 son
la versión curada y aprueban la conservación de las 7 variantes UC.

### 2.5 NOM_001 — Nomenclatura del Proyecto (encontrado en revisión post-discover)

`temp-holding/FASE 01/NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst`
(v2.0.0, 1235 líneas).

Es una **normativa de nomenclatura general** del proyecto IACT
(identificadores, versionado semántico, convenciones de nombres).
Distinta de STD_007 (que es naming de archivos/directorios) —
NOM_001 cubre **identificadores y versionado** del proyecto en
sentido amplio.

Originalmente se ubicaba bajo `base_cognitiva/_normativa/` (legacy).
En la arquitectura v2.0 corresponde a **normativa/estandares/**.

**F-NE-5 (nuevo):** El prefijo ``NOM_`` NO está listado en
STD_007 §4.1 (prefijos válidos: UC, BR, BReq, CNST, META, FND,
SBVR, MTM, TXM, GOB, STD, TPL). NOM_001 debe **renombrarse** a un
prefijo válido del catálogo STD_007.

**D-NE-1 (decisión):** Renombrar
``NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst`` →
``STD_002_Nomenclatura_Proyecto.rst`` (siguiente número STD
disponible; conservar v2.0.0 en metadata).

**Justificación:**

- NOM_001 cubre estándares de nomenclatura del proyecto — su
  contenido natural es como STD.
- Numeración: STD_001 (Documentacion_Sin_Emojis), **STD_002
  (Nomenclatura_Proyecto)**, STD_003-005 reservados, STD_006
  (Versionado_Semantico), STD_007 (Convencion_Naming archivos).
- STD_007 sigue siendo naming de filenames/directorios
  específicamente. STD_002 cubre nomenclatura de identificadores
  y artefactos del proyecto en sentido amplio.

### 2.6 STDs nuevos a crear (heredados de WP #1)

- ``STD_Naming_Identificadores`` (clean code + autoexplicativo +
  sin abreviaturas de dominio).
- ``STD_Profesional_Documentacion`` (formalizar la convención
  PROFESSIONAL DOCUMENTATION v1.0.0 provista por el ejecutor:
  vocabulario prohibido, headings, tono, etc.).

## 3. Hallazgos

### F-NE-1: Versiones en filenames de TODOS los TPLs viola STD_006

Cada TPL del backup lleva ``_1_0_0`` o ``_2_0_0`` o ``_1_1_0``
en el filename. Renombrado obligatorio: versión a metadata YAML.

### F-NE-2: TPL_002_Plantilla_UC_v2.rst — naming irregular

No sigue patrón ``TPL_<KEY>_<Desc>.rst``. Tiene ``_002_`` y ``_v2``.
Se descarta — su contenido está en ``TPL_UC_Casos_de_Uso_2_0_0.rst``
o en las 7 variantes UC del set curado.

### F-NE-3: TRZ vs RTM — ¿son lo mismo?

Backup tiene ``TPL_RTM_Trazabilidad_1_0_0.rst``.
Set curado tiene ``TPL_TRZ_Matriz_RTM_1_3_0.rst``.

Ambos son matrices de trazabilidad. **Fusión**: usar el v1.3.0 del
set curado como canónico, descartar el v1.0.0 del backup. Filename
final: ``TPL_TRZ_Matriz_RTM.rst`` (TRZ es la abreviatura propuesta
en el set curado).

### F-NE-4: Falta STD_001..STD_005

El backup tiene STD_006 y STD_007 pero no STD_001..STD_005. Los STDs
inferiores deben existir. STD_001 está en temp-holding (v2.0.0 Sin_Emojis).
STD_002..STD_005: investigar si existen en temp-holding.

## 4. Clasificación editorial por archivo

### 4.1 Top-level estandares/ (6 archivos del backup)

| Archivo | Decisión | Razón |
|---------|----------|-------|
| ``index.rst`` | reescribir | Toctree del nuevo dominio (incluye STDs nuevos). |
| ``STD_006_Versionado_Semantico.rst`` | incorporar | Estándar canónico, ya en formato STD_NNN. |
| ``STD_007_Convencion_Naming.rst`` | incorporar | Estándar canónico. |
| ``GUIA_ESTILO.rst`` | incorporar | Guía auxiliar (kebab-case sería más STD_007 §4.4 pero el caps lock es legacy aceptable; renombrar a ``guia-estilo.rst``). |
| ``estandares_codigo.rst`` | incorporar | Guía técnica de código (renombrar a ``estandares-codigo.rst`` para STD_007 §4.4). |
| ``shell_scripting_guide.rst`` | incorporar | Guía técnica (renombrar a ``shell-scripting-guide.rst``). |

### 4.2 STDs nuevos a agregar

| Archivo | Decisión | Razón |
|---------|----------|-------|
| ``STD_001_Estandares_Documentacion_Sin_Emojis.rst`` | incorporar (de temp-holding v2.0.0) | STD existe, solo no estaba en backup. |
| ``STD_Naming_Identificadores.rst`` | reescribir (nuevo) | Clean code + autoexplicativo + sin abreviaturas en identificadores. |
| ``STD_Profesional_Documentacion.rst`` | reescribir (nuevo) | Formalizar convención PROFESSIONAL DOCUMENTATION v1.0.0 (frases prohibidas, headings, tono). |

### 4.3 Templates plantillas/ (renombrado obligatorio + fusiones)

Patrón final: ``TPL_<KEY>_<Desc>.rst`` (sin versión en filename).

| Archivo backup → Archivo final | Versión metadata | Decisión |
|-------------------------------|------------------|----------|
| ``TPL_ADR_Decisiones_Arquitectonicas_1_0_0`` → ``TPL_ADR_Decisiones_Arquitectonicas`` | 1.0.0 | incorporar + renombrar |
| ``TPL_API_Documentacion_API_1_1_0`` → ``TPL_API_Documentacion_API`` | 1.1.0 | incorporar + renombrar |
| ``TPL_BR_Business_Rules_1_0_0`` → ``TPL_BR_Business_Rules`` | 1.0.0 | incorporar + renombrar |
| ``TPL_BReq_Objetivos_Negocio_1_0_0`` → ``TPL_BReq_Objetivos_Negocio`` | 1.0.0 | incorporar + renombrar |
| ``TPL_CNST_Restricciones_1_0_0`` → ``TPL_CNST_Restricciones`` | 1.0.0 | incorporar + renombrar |
| ``TPL_FD_Flujos_Datos_1_0_0`` → ``TPL_FD_Flujos_Datos`` | 1.0.0 | incorporar + renombrar |
| ``TPL_FR_Requisitos_Funcionales_1_0_0`` → ``TPL_FR_Requisitos_Funcionales`` | 1.0.0 | incorporar + renombrar |
| ``TPL_INDEX_Indices_1_0_0`` → ``TPL_INDEX_Indices`` | 1.0.0 | incorporar + renombrar |
| ``TPL_MOD_Modulos_1_0_0`` → ``TPL_MOD_Modulos`` | 1.0.0 | incorporar + renombrar |
| ``TPL_NFR_No_Funcionales_1_0_0`` → ``TPL_NFR_No_Funcionales`` | 1.0.0 | incorporar + renombrar |
| ``TPL_POL_Politicas_1_0_0`` → ``TPL_POL_Politicas`` | 1.0.0 | incorporar + renombrar |
| ``TPL_PROC_Procedimientos_1_0_0`` → ``TPL_PROC_Procedimientos`` | 1.0.0 | incorporar + renombrar |
| ``TPL_RTM_Trazabilidad_1_0_0`` | — | **descartar** (fusión: usar TPL_TRZ_Matriz_RTM del set curado v1.3.0) |
| ``TPL_STD_Estandares_1_0_0`` → ``TPL_STD_Estandares`` | 1.0.0 | incorporar + renombrar |
| ``TPL_TST_Pruebas_1_0_0`` → ``TPL_TST_Pruebas`` | 1.0.0 | incorporar + renombrar |
| ``TPL_UC_Casos_de_Uso_2_0_0`` → ``TPL_UC_Casos_de_Uso`` | 2.0.0 | incorporar + renombrar (template UC genérico/legacy) |
| ``TPL_VIEW_Vistas_Arquitectonicas_1_0_0`` → ``TPL_VIEW_Vistas_Arquitectonicas`` | 1.0.0 | incorporar + renombrar |
| ``TPL_002_Plantilla_UC_v2`` | — | **descartar** (naming irregular, redundante con TPL_UC_Casos_de_Uso) |

### 4.4 Templates del set curado v1.3.0 (incorporar todos como nuevos)

| Archivo origen | Archivo final | Versión |
|----------------|---------------|---------|
| ``TPL_BR_Decision_Tipo_1_3_0.rst`` | ``TPL_BR_Decision_Tipo.rst`` | 1.3.0 |
| ``TPL_FR_Documentacion_10_Componentes_1_3_0.rst`` | ``TPL_FR_Documentacion_10_Componentes.rst`` | 1.3.0 |
| ``TPL_FR_Query_SQL_1_3_0.rst`` | ``TPL_FR_Query_SQL.rst`` | 1.3.0 |
| ``TPL_FR_Validacion_Reglas_1_3_0.rst`` | ``TPL_FR_Validacion_Reglas.rst`` | 1.3.0 |
| ``TPL_TRZ_Matriz_RTM_1_3_0.rst`` | ``TPL_TRZ_Matriz_RTM.rst`` | 1.3.0 |
| ``TPL_UC_Actor_Secundario_1_3_0.rst`` | ``TPL_UC_Actor_Secundario.rst`` | 1.3.0 |
| ``TPL_UC_CRUD_Operaciones_1_2_0.rst`` | ``TPL_UC_CRUD_Operaciones.rst`` | 1.2.0 |
| ``TPL_UC_Construccion_7_Pasos_1_3_0.rst`` | ``TPL_UC_Construccion_7_Pasos.rst`` | 1.3.0 |
| ``TPL_UC_Larman_Contratos_1_2_0.rst`` | ``TPL_UC_Larman_Contratos.rst`` | 1.2.0 |
| ``TPL_UC_Stakeholder_Driven_1_3_0.rst`` | ``TPL_UC_Stakeholder_Driven.rst`` | 1.3.0 |
| ``TPL_UC_Temporal_Schedulers_1_3_0.rst`` | ``TPL_UC_Temporal_Schedulers.rst`` | 1.3.0 |
| ``TPL_UC_UI_Driven_1_3_0.rst`` | ``TPL_UC_UI_Driven.rst`` | 1.3.0 |

## 5. Resultado esperado del WP #2

| Categoría | Cantidad final |
|-----------|----------------|
| STDs | 6 (STD_001 + STD_006 + STD_007 + STD_Naming_Identificadores + STD_Profesional_Documentacion + 1 reservado para futuro) |
| Guías | 3 (GUIA_ESTILO, estandares-codigo, shell-scripting-guide) |
| Templates | ~28 (16 del backup renombrados, menos 2 descartados, más 12 nuevos del set curado v1.3.0) |
| index.rst | 2 (top-level + plantillas/) |
| **Total** | **~39 archivos finales** |

## 6. Pre-condición de cierre

- Build verde sin warnings dentro del dominio.
- toctree de root referencia ``normativa/index`` (cuando exista) o
  ``normativa/estandares/index`` directo.
- 100% archivos cumple STD_007 (filenames) + STD_006 (versión en
  metadata).

## 7. Próximo paso

Phase 10 EXECUTE — aplicar el plan de §4 al filesystem.
