.. meta::
 :artefacto: INDEX_MATRICES
 :tipo: Indice
 :dominio: gestion
 :subdominio: pm/matrices
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================
Matrices de Gestión
==============================

Matrices de trazabilidad, RACI, competencias, y otras vistas
estructuradas que apoyan la gestión del proyecto IACT.

Propósito
=========

Las matrices son **vistas de relación** entre elementos del
proyecto. Útiles para:

- **Trazabilidad bidireccional** (BR ↔ UC ↔ FR ↔ TC).
- **Asignación de responsabilidades** (RACI por rol/artefacto).
- **Análisis de competencias** del equipo.
- **Cobertura de tests / requisitos**.

Matrices disponibles
====================

.. toctree::
 :maxdepth: 1

Convención
==========

- Carpeta canónica: ``source/gestion/pm/matrices/``
- Naming: ``matriz-{tipo}.rst`` (kebab-lowercase per STD-007).
- Cada matriz tiene metadata `:artefacto: MATRIZ_{TIPO}`.

Matrices relacionadas (en otras ubicaciones)
============================================

- **Matriz RACI RBAC:** vive en
  :doc:`/arquitectura-tecnica/rbac/raci-rbac-iact` (matriz
  específica del modelo RBAC).
- **Matrices de trazabilidad por UC:** viven en
  ``source/requisitos/requisitos-funcionales/{módulo}/{uc-id}/``
  cuando son específicas de un UC.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``ba-requirements-analysis`` + ``rm-validation``
 * - **Templates aplicables**
   - :doc:`/normativa/estandares/plantillas/tpl-trz-matriz-rtm`
 * - **Naming standard**
   - :doc:`/normativa/estandares/std-007-convencion-naming`
