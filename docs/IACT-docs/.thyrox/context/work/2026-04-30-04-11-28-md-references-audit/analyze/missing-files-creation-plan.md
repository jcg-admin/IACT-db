```yml
created_at: 2026-04-30 05:05:00
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Plan de creación — 305 archivos `.md` referenciados que NO existen

> Deep-review sobre los 305 paths `.md` referenciados en `source/`
> que NO existen en ningún lugar del repo. Categorización por
> familia, mapeo a carpeta destino en source/, asignación de
> SKILL guía para llenar contenido, prioridad y plan accionable.

## Resumen ejecutivo

De los 511 paths únicos referenciados, **305 (64.5%) no existen
en absoluto**. Tras categorizar:

| Familia | Cantidad | Acción dominante |
|---------|----------|-------------------|
| Placeholders / Patrones (no son archivos reales) | ~75 | NO crear (descartar referencias) |
| ADRs (todos los formatos) | 45 | Crear con guía `cp-recommend` |
| Procedimientos | 30 | Crear con guía `pps-implement` + `pm-executing` |
| Casos de Uso (UC-*) | 28 | Crear con guía `rm-specification` o mapear a existentes |
| Plantillas/Templates | 17 | NO crear — son referencias circulares de templates |
| Catálogos | 6 | Crear con guía `ba-requirements-analysis` |
| Guías técnicas | 4 | Crear con guía `bpa-design` |
| Runbooks | 4 | Crear con guía `bpa-implement` |
| Requisitos Funcionales (RF-*) | 4 | Crear con guía `rm-specification` |
| Checklists | 3 | Crear con guía `dmaic-control` |
| Matrices | 3 | Crear con guía `ba-requirements-analysis` |
| Reglas de Negocio (RN-*) | 3 | Crear con guía `ba-elicitation` |
| README / INDICE / CHANGELOG / TODO | 7 | NO crear — externos al sitio |
| Otros (PARTE_*, REPORTE, BN, MODELO_DOCUMENTAL, etc.) | ~76 | Triaje individual |

**Recomendación final neta:**

- **Crear:** ~120-150 archivos nuevos con plantilla canónica.
- **Descartar referencia (no crear archivo):** ~100 (placeholders + templates circulares + externos).
- **Mapear a archivo existente** (corrección de path roto que apunta al doc correcto pero con nombre incorrecto): ~40-60.

---

## 1. Categorías a NO crear (eliminar referencia)

### 1.1 Placeholders / Patrones (~75)

Estos paths NO son archivos reales — son **patrones de nombre**
que aparecen en plantillas de procesos (e.g. "el archivo del
deploy se llamará `DEPLOYMENT_PLAN_{env}_YYYYMMDD_HHMMSS.md`").

Patrones detectados:

```
'plantilla_django_app.md
's/old-filename.md/new-filename.md
AC-DOMINIO-###-descripcion.md
ANALISIS-RAMAS-YYYY-MM-DD.md
ANALISIS_[Tema]_vX_Y_Z.md
BR-DOMINIO-###-descripcion.md
DEPLOYMENT_PLAN_{env}_YYYYMMDD_HHMMSS.md
DESIGN_REVIEW_CHECKLIST_YYYYMMDD_HHMMSS.md
DIAGRAMS_YYYYMMDD_HHMMSS.md
DISENO_TECNICO_{COMPONENTE}.md
HLD_YYYYMMDD_HHMMSS.md
LLD_YYYYMMDD_HHMMSS.md
MODELO_DOCUMENTAL_IACT_vX.Y.Z.md
MONITORING_PLAN_YYYYMMDD_HHMMSS.md
PLAN-CONSOLIDACION-RAMAS-YYYY-MM-DD.md
PLAN-INTEGRACION-REFACTORIZACIONES-YYYY-MM-DD.md
PLAN-REORGANIZACION-ESTRUCTURA-{DOMINIO}-YYYY-MM-DD.md
POST_DEPLOYMENT_CHECKLIST_YYYYMMDD_HHMMSS.md
PRE_DEPLOYMENT_CHECKLIST_YYYYMMDD_HHMMSS.md
REPORTE-EJECUCION-YYYY-MM-DD.md
REPORTE_[Tema].md
RFC_YYYYMMDD_HHMMSS.md
... etc
```

**Acción:** **NO crear archivos**. Estos paths aparecen dentro de
documentación de procesos como ejemplos/plantillas. Las
referencias deben permanecer como **literal strings** en backticks
(`` ``DEPLOYMENT_PLAN_{env}_YYYYMMDD_HHMMSS.md`` ``) y NO como
hyperlinks RST. Donde aparezcan como hyperlinks, convertir a
literal.

**Esfuerzo:** ~1h (script grep+sed para reemplazar `<pattern>`__ por backticks).

### 1.2 README / INDICE / CHANGELOG / TODO externos (7)

Archivos del root del repo, NO del sitio publicado:

```
../../../README.md
../readme.md
../checklists/readme.md
../frontend/checklists/readme.md
../gobernanza/readme.md
../arquitectura/readme.md
TODO.md
```

**Acción:** **NO crear en source/**. Cuando se referencian:

- **README del repo:** reemplazar por URL absoluta a GitHub
  (ej. `https://github.com/jcg-admin/iact-docs/blob/main/README.md`)
  o por texto descriptivo.
- **READMEs de subcarpetas inexistentes:** eliminar la referencia
  o mover a texto plano explicativo.
- **TODO.md:** convertir a referencia textual ("ver backlog del repo").

**Esfuerzo:** ~1h.

### 1.3 Templates de plantillas (17)

Referencias circulares en docs como `proc-gob-001-mapeo-procesos-templates.rst`
que LISTAN templates `.md` como ejemplos del catálogo:

```
plantilla_api_reference.md
plantilla_caso_de_uso.md
plantilla_caso_prueba.md
plantilla_database_design.md
plantilla_deployment_guide.md
plantilla_plan_pruebas.md
plantilla_release_plan.md
plantilla_sad.md
plantilla_srs.md
plantilla_troubleshooting.md
template_necesidad.md
template_requisito_funcional.md
template_requisito_negocio.md
template_requisito_no_funcional.md
plantilla_django_app.md
plantilla_tdd.md
plantilla_database_schema.md
```

**Decisión:** las plantillas concretas YA viven en
`temp-holding/FASE 02/base_cognitiva/normativa/templates/TPL_*.rst`
(verificado: existen como `.rst` con prefijo TPL_).

**Acción recomendada:** crear **un solo doc canónico**
`source/normativa/templates/index.rst` que liste los templates
disponibles + importe los TPL_*.rst de temp-holding al directorio
`source/normativa/templates/`.

**Esfuerzo:** 4-6h (importar 10-15 TPL existentes).

**SKILL guía:** `bpa-design` (templates son artefactos de diseño
de proceso) + `pm-planning` (plantillas de gestión de proyecto).

---

## 2. Categorías a CREAR

### 2.1 ADRs (45 archivos)

Patrones detectados:

```
ADR-001-decision.md (genéricos)
ADR-005-grupos-funcionales-sin-jerarquia.md
ADR-009-frontend-postponement.md
ADR-015-frontend-modular-monolith.md
ADR-056-agentic-design-principles.md
ADR-BACK-005-servicios-resilientes.md
ADR-BACK-006-django-orm-vs-sqlalchemy.md
ADR-DEVOPS-001-vagrant-mod-wsgi.md
ADR-DEVOPS-001-jenkins-vs-gitlab-ci.md
ADR-GOB-002-organizacion-proyecto-por-dominio.md
ADR-GOB-004-plantuml-para-diagramas.md
ADR-GOB-005-jerarquia-requerimientos-5-niveles.md
ADR-GOB-006-clasificacion-reglas-negocio.md
ADR-GOB-007-especificacion-casos-uso.md
ADR-GOB-008-diagramas-uml-casos-uso.md
ADR-GOB-009-trazabilidad-artefactos-requisitos.md
... (más)
```

**Mapeo a carpeta destino:**

| Prefijo | Carpeta destino |
|---------|-----------------|
| `ADR-BACK-*` | `source/backend/adr-back-*.rst` |
| `ADR-FRONT-*` | `source/frontend/adr-front-*.rst` |
| `ADR-DEVOPS-*` | `source/devops/adr-devops-*.rst` |
| `ADR-DB-*` | `source/databases/adr-db-*.rst` |
| `ADR-GOB-*` | `source/normativa/gobernanza/adr-gob-*.rst` |
| `ADR-NNN-*` (sin prefijo dominio) | Triaje por contenido — clasificar |

**Verificación:** Algunos ADR ya existen con nombre kebab-case
(`adr-back-001`, `adr-gob-001`). Para ADR-GOB-005..009 verificar
si los temas ya están cubiertos por adr-gob-* existentes (es
probable: STD-007, jerarquía requerimientos, especificación UCs
ya tienen archivos canónicos).

**Acción concreta:**

1. Para cada ADR-NNN listado: buscar si tema ya existe en source/
   con otro nombre.
2. Si existe → actualizar referencia a `:doc:`.
3. Si no existe → crear con plantilla MADR (Markdown Architectural
   Decision Records, adaptada a RST).

**SKILL guía:** **`cp-recommend`** (Consulting Process — Recommend
phase, adaptado a ADRs). Plus convención del proyecto en
`source/normativa/estandares/std-007-versionado-semantico.rst`.

**Plantilla ADR canónica:**

```rst
.. meta::
 :artefacto: ADR-{DOMINIO}-NNN
 :tipo: ADR
 :dominio: {dominio}
 :version: 1.0.0
 ...

================================================
ADR-{DOMINIO}-NNN: {Título de la decisión}
================================================

**Estado:** Aprobado | Propuesto | Superseded by ADR-XXX
**Fecha:** YYYY-MM-DD
**Decisores:** {nombres}

1. Contexto
===========
{Por qué se necesita decidir esto}

2. Decisión
===========
{Qué se decidió}

3. Justificación
================
{Por qué esta decisión}

4. Consecuencias
================
{Trade-offs aceptados, riesgos}

5. Alternativas evaluadas
=========================
{Otras opciones y por qué se rechazaron}

6. Trazabilidad
===============
{ADRs relacionados, CNST, BR, UC}
```

**Esfuerzo:** ~30-45 min por ADR si existe contenido en
temp-holding; ~1h si se crea desde cero. **Total: 25-35h** para
los 45 (asumiendo 30-50% se mapea a existentes).

**Prioridad:** ALTA para ADR-GOB-* (gobernanza), MEDIA para resto.

### 2.2 Casos de Uso (28 archivos)

Listados detectados (mayormente con prefijo histórico `UC-BACK-*`,
`UC-FRONT-*`):

```
UC-BACK-001-iniciar-sesion.md
UC-BACK-002-cerrar-sesion.md
UC-BACK-003-cambiar-contrasena.md
UC-BACK-004-recuperar-contrasena.md
... (más con prefijo UC-BACK)
UC-FRONT-001-...
UC-001-iniciar-sesion.md (sin prefijo dominio)
... etc
```

**Verificación:** **TODOS los UC-BACK-*** ya tienen equivalente
en source/ con nombre canónico:

| `.md` referenciado (no existe) | RST canónico (existe) |
|--------------------------------|------------------------|
| `UC-BACK-001-iniciar-sesion.md` | `source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst` |
| `UC-BACK-002-cerrar-sesion.md` | `source/requisitos/casos-uso/auth/uc-auth-02-cerrar-sesion.rst` |
| `UC-BACK-003-cambiar-contrasena.md` | `source/requisitos/casos-uso/auth/uc-auth-04-cambiar-contrasena.rst` |
| `UC-BACK-004-recuperar-contrasena.md` | `source/requisitos/casos-uso/auth/uc-auth-03-recuperar-contrasena.rst` |

**Acción:** **NO crear archivos nuevos.** Mapear cada referencia
`UC-BACK-XXX.md` a su `:doc:` canónico mediante script de
remapeo masivo.

**SKILL guía:** `rm-specification` (para verificar contenido si
el doc canónico está incompleto).

**Esfuerzo:** ~3h (script de mapeo + validación).

**Prioridad:** ALTA (mapeo 1:1 directo, alto ROI).

### 2.3 Procedimientos (30 archivos)

Patrones detectados:

```
procedimiento_qa.md (9 refs)
procedimiento_release.md (8 refs)
procedimiento_instalacion_entorno.md (6 refs)
procedimiento_gestion_cambios.md (6 refs)
procedimiento_desarrollo_local.md (6 refs)
procedimiento_diseno_tecnico.md (5 refs)
procedimiento_revision_documental.md
procedimiento_implementacion_codigo.md
procedimiento_creacion_pr.md
... (más)
```

**Verificación:** existe `source/normativa/procedimientos/proc-*.rst`
con muchos procedimientos canónicos (proc-dev-*, proc-qa-*,
proc-gob-*). Verificar mapeo:

| `.md` (no existe) | Posible RST existente |
|-------------------|----------------------|
| `procedimiento_qa.md` | `proc-qa-001-actividades-garantia-documental.rst` |
| `procedimiento_release.md` | crear `proc-rel-001-procedimiento-release.rst` |
| `procedimiento_instalacion_entorno.md` | crear `proc-dev-001-instalacion-entorno.rst` |
| `procedimiento_gestion_cambios.md` | `proc-gob-011-gestion-cambios.rst` |
| `procedimiento_desarrollo_local.md` | crear `proc-dev-XXX-desarrollo-local.rst` |
| `procedimiento_diseno_tecnico.md` | `proc-dev-004-diseno-tecnico.rst` |

**Acción:** mapear ~50% a existentes; crear ~15 nuevos.

**Carpeta destino:** `source/normativa/procedimientos/proc-{cat}-NNN-*.rst`

Categorías de procedimiento (per convención del proyecto):
- `proc-gob-*`: gobernanza
- `proc-dev-*`: desarrollo
- `proc-qa-*`: aseguramiento de calidad
- `proc-rel-*`: release management (NUEVA categoría)
- `proc-req-*`: requirements
- `proc-ops-*`: operaciones (NUEVA si aplica)

**SKILL guías combinadas:**
- **`pps-implement`** (Toyota Practical Problem Solving — implementar countermeasures como procedimientos repetibles)
- **`pm-executing`** (PMBOK — gestión de ejecución de procesos)
- **`workflow-implement`** (THYROX — fase de implementación)

**Esfuerzo por procedimiento nuevo:** 1-2h. **Total: 15-30h** para
los ~15 nuevos + 5h para mapear los existentes.

**Prioridad:** ALTA (alto # refs en source/normativa/).

### 2.4 Catálogos (6 archivos)

```
CATALOGO_BR_CASOS_USO.md
CATALOGO_REQUISITOS.md
CATALOGO_PROCESOS_NEGOCIO.md
CATALOGO_TEMPLATES.md
... (más)
```

**Acción:** crear carpeta nueva
`source/arquitectura-tecnica/catalogos/` y agregar archivos
canónicos.

**SKILL guía:** **`ba-requirements-analysis`** (BABOK — análisis y
catalogación de requirements).

**Plantilla catálogo:**

```rst
.. meta::
 :artefacto: CATALOGO_{TIPO}
 :tipo: Catálogo
 ...

================================================
Catálogo: {Tipo}
================================================

1. Propósito
============

2. Estructura del catálogo
==========================

.. list-table::
 :header-rows: 1
 ...

3. Items
========

.. toctree::
 :maxdepth: 1
 ...

4. Trazabilidad
===============
```

**Esfuerzo:** ~2h por catálogo. **Total: 12h.**

**Prioridad:** MEDIA.

### 2.5 Guías técnicas (4 archivos)

```
GUIA-BACK-003-authentication-guide.md (7 refs)
GUIA-DEVOPS-002-...
guia_deployment.md
guia_testing.md
```

**Acción:** crear en `source/{dominio}/guias/` o
`source/normativa/guias/` según scope.

**SKILL guías:**
- **`bpa-design`** (BPA — diseño de procesos)
- Tech-specific skills (`backend-nodejs`, `frontend-react`, etc.)
  según dominio.

**Esfuerzo:** 2-3h por guía. **Total: 8-12h.**

**Prioridad:** MEDIA.

### 2.6 Runbooks operacionales (4 archivos)

```
verificar_servicios.md (10 refs)
reprocesar_etl_fallido.md (5 refs)
restaurar_backup.md
escalar_servicio.md
```

**Acción:** crear carpeta nueva
`source/devops/runbooks/runbook-*.rst`.

**SKILL guía:** **`bpa-implement`** + **`pps-countermeasures`**.

**Plantilla runbook:**

```rst
.. meta::
 :artefacto: RUNBOOK_{NOMBRE}
 :tipo: Runbook
 ...

============================================
Runbook: {Operación}
============================================

1. Cuándo ejecutar este runbook
================================

2. Precondiciones
=================

3. Pasos
========

4. Rollback
===========

5. Verificación post-ejecución
==============================

6. Escalación
=============

7. Trazabilidad
===============
```

**Esfuerzo:** 2h por runbook. **Total: 8h.**

**Prioridad:** ALTA (`verificar_servicios.md` 10 refs es alto
volumen).

### 2.7 Requisitos Funcionales (4 archivos)

```
RF-BACK-005-registro-proveedor-automatico.md
RF-BACK-006-validacion-email.md
RF-BACK-065-generar-codigo-totp.md
... (más)
```

**Verificación:** existe carpeta
`source/requisitos/requisitos-funcionales/{dominio}/{uc-***}/fr-***.rst`
con estructura jerárquica por UC.

**Acción:** investigar si los RF-BACK-* listados ya tienen
equivalente con nombre kebab-case `fr-back-*.rst`. Si no, crear
en estructura existente.

**SKILL guía:** **`rm-specification`** (Requirements Management — Specification).

**Esfuerzo:** 1-1.5h por RF. **Total: 4-6h.**

**Prioridad:** MEDIA.

### 2.8 Checklists (3 archivos)

```
checklist_desarrollo.md (8 refs)
checklist_trazabilidad_requisitos.md (7 refs)
checklist_testing.md (6 refs)
... (más)
```

**Verificación:** existe `source/gestion/pm/checklists/checklists-*.rst`
con algunos checklists.

**Acción:** crear faltantes en `source/gestion/pm/checklists/`
(o `source/quality/checklists/` si conviene separar).

**SKILL guía:** **`dmaic-control`** (Six Sigma DMAIC — Control
phase usa checklists para mantener mejoras).

**Plantilla checklist:**

```rst
.. meta::
 :artefacto: CHECKLIST_{TIPO}
 :tipo: Checklist
 ...

==============================
Checklist: {Tipo}
==============================

1. Cuándo aplicar
=================

2. Items
========

.. list-table::
 :header-rows: 1

 * - #
   - Item
   - Verificado por
 * - 1
   - {checkbox} {descripción}
   - {rol}

3. Criterio de aprobación
=========================

4. Trazabilidad
===============
```

**Esfuerzo:** 1.5h por checklist. **Total: 5h.**

**Prioridad:** MEDIA-ALTA (alto # refs).

### 2.9 Matrices (3 archivos)

```
MATRIZ_TRAZABILIDAD_BR_UC.md
MATRIZ_RACI_*.md
MATRIZ_COMPETENCIAS.md
```

**Acción:** crear en `source/arquitectura-tecnica/matrices/`
(carpeta nueva) o `source/quality/matrices/`.

**SKILL guía:** **`ba-requirements-analysis`** (BABOK — Trace
Requirements Matrix).

**Esfuerzo:** 2-3h por matriz (incluye contenido). **Total: 6-9h.**

**Prioridad:** MEDIA.

### 2.10 Reglas de Negocio (3 archivos)

```
RN-001-... .md
RN-005-... .md
... (más)
```

**Verificación:** existe `source/requisitos/reglas-negocio/br-NNN-*.rst`
con muchas BRs canónicas.

**Acción:** mapear `RN-*` a `br-*` existentes; crear faltantes
con prefijo `br-`.

**SKILL guía:** **`ba-elicitation`** (BABOK — Elicitar reglas
desde stakeholders).

**Esfuerzo:** 1-2h por RN. **Total: 3-6h.**

**Prioridad:** MEDIA.

### 2.11 Otros / Misceláneos (~76)

Análisis individual requerido. Patrones detectados:

- **PARTE_*.md (8 únicos):** capítulos pedagógicos que YA EXISTEN
  en temp-holding/FASE 02. Importar a `source/base-cognitiva/`.
- **REPORTE_*.md, ANALISIS_*.md:** mayormente patrones, ya
  cubiertos en sección 1.1.
- **BN-*.md, BR-*-descripcion.md:** business needs / business
  reqs — verificar mapeo a `br-*.rst` existentes.
- **DISENO_TECNICO_*.md:** technical designs por componente —
  crear en `source/{dominio}/disenos/`.
- **MAPEO_PROCESOS_TEMPLATES.md:** ya cubierto por
  `proc-gob-001-mapeo-procesos-templates.rst`.
- **PLAN_MAESTRO_PRIORIDAD_02.md:** documento histórico
  de planificación — verificar si vale crear o si es deuda.

**Acción:** triaje individual ~3-4h.

**Esfuerzo total para misceláneos:** ~10-15h (creación selectiva).

---

## 3. Tabla maestra de creación (resumen)

| Categoría | Cantidad refs | Crear | Mapear existentes | Descartar | Esfuerzo (h) |
|-----------|---------------|-------|--------------------|-----------|--------------|
| Placeholders | ~75 | 0 | 0 | 75 | 1 |
| ADRs | 45 | 20-25 | 15-20 | 5 | 25-35 |
| Casos de Uso | 28 | 0-3 | 23-25 | 0-2 | 3-5 |
| Procedimientos | 30 | 12-15 | 12-15 | 3 | 20-30 |
| Templates plantillas | 17 | 0 | 0 (importar de temp-holding) | 17 | 4-6 (importación) |
| Catálogos | 6 | 6 | 0 | 0 | 12 |
| Guías técnicas | 4 | 4 | 0 | 0 | 8-12 |
| Runbooks | 4 | 4 | 0 | 0 | 8 |
| Requisitos Funcionales | 4 | 2-3 | 1-2 | 0 | 3-6 |
| Checklists | 3 | 3 | 0 | 0 | 5 |
| Matrices | 3 | 3 | 0 | 0 | 6-9 |
| Reglas de Negocio | 3 | 1-2 | 1-2 | 0 | 3-6 |
| README/INDICE/CHANGELOG | 7 | 0 | 0 | 7 | 1 |
| Misceláneos | ~76 | 20-30 | 30-40 | 15-20 | 10-15 |
| **TOTAL** | **305** | **75-100** | **82-104** | **122-129** | **109-156** |

---

## 4. Lista de carpetas nuevas a crear en source/

```
source/normativa/templates/        # importar TPL_*.rst de temp-holding
source/devops/runbooks/            # runbooks operacionales
source/arquitectura-tecnica/catalogos/   # catálogos del sistema
source/quality/checklists/         # alternativa a gestion/pm/checklists/
source/quality/matrices/           # matrices de trazabilidad/RACI
source/{dominio}/guias/            # guías técnicas por dominio
source/{dominio}/disenos/          # diseños técnicos por componente
```

**source/gestion/** ya existe — el ejecutor explícitamente lo
declaró disponible. Puede usarse para:

- `source/gestion/checklists/` (alternativa a quality/)
- `source/gestion/matrices/`
- `source/gestion/templates/` (alternativa a normativa/)
- `source/gestion/manuales-usuarios/` (ya existe)
- `source/gestion/evidencia/` (ya existe)

**Decisión propuesta:** consolidar materiales de gestión en
`source/gestion/`:

```
source/gestion/
├── pm/
│   ├── checklists/     ← existe
│   └── matrices/       ← nuevo
├── manuales-usuarios/  ← existe
├── evidencia/          ← existe
└── runbooks/           ← nuevo (alternativa a devops/runbooks/)
```

Y mantener:

```
source/normativa/templates/  ← templates documentales
source/arquitectura-tecnica/catalogos/  ← catálogos arquitectónicos
```

---

## 5. Mapeo familia → SKILL guía

| Familia | SKILL primario | SKILL secundario | Por qué |
|---------|----------------|-------------------|---------|
| ADRs | `cp-recommend` | `bpa-design` | Decisión estructurada con alternativas |
| Casos de Uso | `rm-specification` | `ba-requirements-analysis` | Specification de requirements |
| Procedimientos | `pps-implement` | `pm-executing`, `workflow-implement` | Implementación de procesos repetibles |
| Catálogos | `ba-requirements-analysis` | `rm-management` | Catalogación de items |
| Guías técnicas | `bpa-design` | tech-specific | Diseño de procesos técnicos |
| Runbooks | `bpa-implement` | `pps-countermeasures` | Implementación de operaciones |
| Requisitos Funcionales | `rm-specification` | `ba-requirements-analysis` | Specification |
| Checklists | `dmaic-control` | `pm-monitoring` | Control de calidad |
| Matrices | `ba-requirements-analysis` | `rm-validation` | Trazabilidad y validación |
| Reglas de Negocio | `ba-elicitation` | `rm-elicitation` | Elicitación de stakeholders |

**Cómo usar las skills:**

Cada SKILL en `.claude/skills/<nombre>/SKILL.md` declara:
- Inputs requeridos
- Outputs esperados (artefactos)
- Pasos del proceso
- Templates / heuristics

Al crear un archivo de la familia X, el agente o autor:

1. Lee `SKILL.md` de la skill primaria.
2. Aplica los pasos para producir el contenido.
3. Si hay templates en `<skill>/assets/`, los usa.
4. Aplica metadata canónica del proyecto IACT-docs.

---

## 6. Recomendaciones de priorización

### Sprint 1 (alto ROI — ~10h)

1. Mapear los 28 UC-BACK/UC-FRONT → uc-auth/uc-rpt/etc existentes.
2. Mapear los ~15 procedimientos a procs existentes.
3. Convertir 75 placeholders a literales backticks.
4. Eliminar 7 referencias README/CHANGELOG externas.

**Resultado:** ~125 referencias rotas resueltas sin crear archivos.

### Sprint 2 (creación de docs canónicos faltantes — ~30h)

1. Crear runbook `verificar_servicios.rst` (10 refs).
2. Crear `procedimiento_qa.rst`, `procedimiento_release.rst` (17 refs combinados).
3. Crear ADR-GOB-* faltantes con guía cp-recommend (~15h).
4. Crear checklists con alto # refs (~5h).

**Resultado:** ~70-80 referencias resueltas con docs nuevos.

### Sprint 3 (completar resto — ~50h)

1. Resto de ADRs no críticos.
2. Catálogos.
3. Guías técnicas.
4. Matrices.
5. Misceláneos.

**Resultado:** corpus impecable.

### Total estimado: ~90-110 horas.

---

## 7. Resumen para aprobación

| Pregunta | Recomendación |
|----------|---------------|
| ¿Crear los 305 archivos? | **No.** Crear solo ~100; mapear ~80; descartar ~125. |
| ¿Carpetas nuevas a crear? | 5: `templates/`, `runbooks/`, `catalogos/`, `matrices/`, `guias/` (por dominio) |
| ¿Usar source/gestion/? | Sí — consolidar checklists, matrices, runbooks ahí |
| ¿SKILL guía por familia? | Documentado en sección 5 (mapeo 1-N) |
| ¿Esfuerzo total realista? | 90-110h en 3 sprints |
| ¿Sprint 1 alone resuelve cuánto? | 41% (125/305) sin crear archivos |

## 8. Hallazgos secundarios

1. **Mucho de los referenciados YA EXISTEN con nombre canónico
   kebab-case** en source/. La mayor parte del trabajo es
   reescribir referencias, no crear contenido nuevo.

2. **Templates circulares:** 17 plantillas se referencian a sí
   mismas en docs de gobernanza. Una vez importadas a
   `source/normativa/templates/`, sus referencias internas también
   deben actualizarse.

3. **Patrones de placeholder (75 paths)** revelan que algunos
   procedimientos documentan ejemplos de nombres de archivo
   que se generarán dinámicamente. Estos NO deberían parsearse
   como hyperlinks RST — son texto.

4. **Concentración:** los 4 archivos
   (`proc-gob-001-mapeo-procesos-templates`,
   `proc-gob-008-reorganizacion-estructura-documental`,
   `proced-gob-005-analisis-impacto-cambios`,
   `proc-gob-002-gobernanza-sdlc`) contienen ~300 de las 832
   referencias `.md` (36% del total). Atacar estos 4 docs
   individualmente resuelve gran parte del problema.

## 9. Decisiones para el ejecutor

1. ¿Aprobamos el desglose 100 crear / 80 mapear / 125 descartar?
2. ¿Carpetas nuevas en `source/gestion/` (consolidar) o en
   carpetas separadas (`source/quality/`, `source/devops/runbooks/`)?
3. ¿Empezamos con Sprint 1 (alto ROI sin crear archivos)?
4. ¿Convertimos los 75 placeholders a literales backticks
   inmediatamente como quick-fix?
5. ¿Qué SKILL guía PROBAR primero — `cp-recommend` para ADRs es
   buena candidata?
