.. meta::
 :artefacto: Index_Plantillas
 :tipo: Indice
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-28
 :autor: Equipo IACT
 :clasificacion: Interno

.. _index-plantillas:

================
Plantillas (TPL)
================

Descripción
===========

Este subdominio contiene las **plantillas estándar** del proyecto
IACT. Cada plantilla define la estructura obligatoria para crear
artefactos de documentación consistentes y trazables.

Naming
======

Per :ref:`std-007` §4.1, las plantillas siguen el patrón:

::

 TPL_<KEY>_<Descripcion_PascalCase>.rst

La versión vive en el metadata YAML del archivo, **no** en el
filename (per :ref:`std-006`).

----

Plantillas por categoría
========================

.. toctree::
 :maxdepth: 1
 :caption: Spec — Requisitos

 tpl-breq-objetivos-negocio
 tpl-br-business-rules
 tpl-br-decision-tipo
 tpl-fr-requisitos-funcionales
 tpl-fr-documentacion-10-componentes
 tpl-fr-query-sql
 tpl-fr-validacion-reglas
 tpl-nfr-no-funcionales

.. toctree::
 :maxdepth: 1
 :caption: Casos de Uso (7 patrones)

 tpl-uc-casos-de-uso
 tpl-uc-construccion-7-pasos
 tpl-uc-actor-secundario
 tpl-uc-crud-operaciones
 tpl-uc-larman-contratos
 tpl-uc-stakeholder-driven
 tpl-uc-temporal-schedulers
 tpl-uc-ui-driven
 tpl-uc-spec-con-diagramas-uml

.. toctree::
 :maxdepth: 1
 :caption: Spec — Trazabilidad

 tpl-trz-matriz-rtm

.. toctree::
 :maxdepth: 1
 :caption: Arquitectura técnica

 tpl-adr-decisiones-arquitectonicas
 tpl-api-documentacion-api
 tpl-cnst-restricciones
 tpl-fd-flujos-datos
 tpl-mod-modulos
 tpl-view-vistas-arquitectonicas

.. toctree::
 :maxdepth: 1
 :caption: Gobernanza

 tpl-index-indices
 tpl-pol-politicas
 tpl-proc-procedimientos
 tpl-std-estandares
 tpl-tst-pruebas

.. toctree::
 :maxdepth: 1
 :caption: Project Management (PMBOK)

 tpl-bc-business-case
 tpl-pc-project-charter
 tpl-pmp-project-management-plan
 tpl-stk-stakeholder-analysis
 tpl-rs-requisito-stakeholder
 tpl-changelog-changelog

.. toctree::
 :maxdepth: 1
 :caption: Setup y entornos

 tpl-setup-entorno-setup
 tpl-setup-qa-setup

.. toctree::
 :maxdepth: 1
 :caption: Implementación técnica

 tpl-django-app-django-app
 tpl-etl-job-etl-job
 tpl-ui-ux-ui-ux
 tpl-mu-manual-usuario

.. toctree::
 :maxdepth: 1
 :caption: Diseño de software (HLD/LLD)

 tpl-sad-arquitectura-software
 tpl-srs-software-requirements-spec

.. toctree::
 :maxdepth: 1
 :caption: Release y Operaciones

 tpl-release-plan-release-management
 tpl-deployment-guide-deployment
 tpl-troubleshooting-runbook

----

Uso de plantillas
=================

1. Identificar el tipo de artefacto a crear y elegir la plantilla
   correspondiente.
2. Para casos de uso, elegir el patrón apropiado entre las 7
   variantes disponibles según el tipo de UC (CRUD, Larman,
   Stakeholder_Driven, etc.).
3. Copiar la sección "Plantilla" del archivo TPL al nuevo
   artefacto.
4. Reemplazar los placeholders.
5. Aplicar :ref:`std-007` al filename del nuevo archivo.
6. Aplicar :ref:`std-006` para versionado en metadata.
7. Validar con ``make html`` (sin warnings).

----

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **STD relacionado**
   - :ref:`std-002` (Nomenclatura del Proyecto),
     :ref:`std-007` (Convención de Naming).
 * - **Ubicación canónica**
   - ``source/normativa/estandares/plantillas/``.

----

Historial
=========

.. list-table::
 :header-rows: 1
 :widths: 12 15 73

 * - Versión
   - Fecha
   - Cambios
 * - 1.0.0
   - 2026-01-07
   - Versión inicial con 17 plantillas (priorización P0-P3,
     versiones en filenames).
 * - 2.0.0
   - 2026-04-28
   - **Bump MAJOR.** Reorganización por categoría (Spec /
     Casos de Uso / Trazabilidad / Arquitectura / Gobernanza).
     Renombrado de los 17 archivos legacy: removida la versión
     del filename, mantenida en metadata YAML
     (per :ref:`std-006`). Incorporadas 12 plantillas
     adicionales del set curado v1.3.0 / v1.2.0 (las 7
     variantes UC distintas + 3 variantes FR + TPL_TRZ +
     TPL_BR_Decision_Tipo). Eliminados 2 archivos obsoletos:
     ``TPL_002_Plantilla_UC_v2.rst`` (naming irregular) y
     ``TPL_RTM_Trazabilidad_1_0_0.rst`` (fusión con
     ``TPL_TRZ_Matriz_RTM``). **Total final: 28 plantillas.**
