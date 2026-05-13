.. meta::
 :artefacto: Index_Procedimientos
 :tipo: Indice
 :dominio: normativa
 :subdominio: procedimientos
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-28
 :autor: Equipo IACT
 :clasificacion: Interno

.. _procedimientos:

==============
Procedimientos
==============

Propósito
=========

Este subdominio agrupa los **procedimientos** del proyecto IACT:
secuencias paso-a-paso que describen cómo se ejecutan las
operaciones recurrentes en cada disciplina del proyecto
(desarrollo, devops, operaciones, calidad, gobernanza,
documentación).

Categorización
==============

- ``PROC-MOD-NNN-desc`` — procedimientos generales de un módulo
  funcional (DEV, DEVOPS, OPS, QA, GOB).
- ``PROCED-MOD-NNN-desc`` — procedimientos de gobernanza
  (creación de artefactos, revisión, aprobación).
- ``PROC_Desc`` — procedimientos de generación y derivación de
  artefactos documentales (variante sin módulo, scope
  transversal).

----

Procedimientos generales (PROC-MOD-NNN)
=======================================

.. toctree::
 :maxdepth: 1
 :caption: Desarrollo (DEV)

 proc-dev-001-pipeline-trabajo-iact
 proc-dev-002-sdlc-process

.. toctree::
 :maxdepth: 1
 :caption: DevOps

 proc-devops-001-devops-automation

.. toctree::
 :maxdepth: 1
 :caption: Operaciones (OPS)

 proc-ops-001-deployment
 proc-ops-002-setup-entorno-desarrollo

.. toctree::
 :maxdepth: 1
 :caption: Calidad (QA)

 proc-qa-001-actividades-garantia-documental
 proc-qa-002-estrategia-qa

.. toctree::
 :maxdepth: 1
 :caption: Gobernanza (GOB)

 proc-gob-001-mapeo-procesos-templates
 proc-gob-002-gobernanza-sdlc
 proc-gob-008-reorganizacion-estructura-documental

----

Procedimientos de gobernanza (PROCED-MOD-NNN)
=============================================

.. toctree::
 :maxdepth: 1
 :caption: Desarrollo

 proced-dev-001-crear-pull-request
 proced-dev-002-code-review
 proced-dev-003-resolver-conflictos-merge

.. toctree::
 :maxdepth: 1
 :caption: DevOps

 proced-devops-001-deploy-staging

.. toctree::
 :maxdepth: 1
 :caption: Gobernanza de excepciones

 proc-req-015-excepciones-cnst

.. toctree::
 :maxdepth: 1
 :caption: Gobernanza

 proced-gob-001-crear-adr
 proced-gob-002-actualizar-documentacion
 proced-gob-003-documentar-regla-negocio
 proced-gob-004-crear-caso-uso
 proced-gob-005-analisis-impacto-cambios
 proced-gob-006-generar-diagrama-uml-plantuml
 proced-gob-007-consolidacion-ramas-git
 proced-gob-008-configurar-permisos-git-push
 proced-gob-009-refactorizaciones-codigo-tdd

.. toctree::
 :maxdepth: 1
 :caption: Calidad

 proced-qa-001-ejecutar-tests

----

Procedimientos de generación de artefactos (PROC_Desc)
======================================================

Procedimientos que rigen cómo se generan los artefactos del
proyecto a partir de plantillas y reglas de derivación.

.. toctree::
 :maxdepth: 1
 :caption: Generación por tipo de artefacto

 proc-req-001-generacion-breq
 proc-req-003-generacion-br
 proc-req-007-generacion-uc
 proc-req-009-generacion-fr
 proc-req-010-generacion-nfr
 proc-req-004-generacion-cnst
 proc-doc-004-generacion-mod
 proc-doc-005-generacion-fd
 proc-doc-006-generacion-view
 proc-doc-008-generacion-api
 proc-doc-002-generacion-adr
 proc-doc-001-generacion-std
 proc-doc-003-generacion-pol
 proc-doc-009-generacion-tst
 proc-doc-007-generacion-rtm
 proc-doc-010-generacion-index

.. toctree::
 :maxdepth: 1
 :caption: Derivación entre niveles

 proc-req-002-derivacion-breq-br
 proc-req-005-derivacion-br-uc
 proc-req-008-derivacion-uc-fr
 proc-req-012-derivacion-fr-code
 proc-req-011-derivacion-fr-tst

.. toctree::
 :maxdepth: 1
 :caption: Revisión y validación

 proc-doc-011-revision-tpl-previo-generacion
 proc-req-006-revision-uc-previo-derivacion
 proc-doc-012-revision-artefactos
 proc-doc-013-validacion-sphinx
 proc-req-017-verificacion-cobertura
 proc-req-016-identificar-gaps-huerfanos

.. toctree::
 :maxdepth: 1
 :caption: Lifecycle documental

 proc-req-018-crear-plan-analisis
 proc-doc-014-crear-estructura-directorios-tmp
 proc-req-014-cambio-requisitos
 proc-gob-003-aprobacion-documentos
 proc-gob-006-actualizacion-modelo-documental
 proc-gob-009-auditoria-documental
 proc-gob-010-versionado-semantico
 proc-gob-007-publicacion-documentacion
 proc-gob-004-congelamiento-subdominio
 proc-gob-005-descongelamiento-subdominio

.. toctree::
 :maxdepth: 1
 :caption: Procedimiento integrador (meta-flujo)

 proc-req-013-elaboracion-completa-requisitos

----

Guías y procedimientos transversales
====================================

.. toctree::
 :maxdepth: 1

 guia-completa-desarrollo-features
 proc-qa-003-analisis-seguridad
 proc-dev-003-desarrollo-local
 proc-dev-004-diseno-tecnico
 proc-gob-011-gestion-cambios
 proc-ops-003-instalacion-entorno
 proc-qa-004-qa
 proc-devops-002-release
 proc-gob-012-revision-documental
 proc-req-019-trazabilidad-requisitos
