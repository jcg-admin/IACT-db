.. meta::
 :artefacto: DIAGRAMAS_REFERENCIA
 :tipo: Catálogo
 :dominio: plantuml-guide
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================
Diagramas de Referencia
==========================

Catálogo de diagramas de referencia del proyecto IACT.
Incluye diagramas arquitectónicos, de proceso, de secuencia y
de modelo, todos generados con PlantUML siguiendo
:doc:`guidelines` y :doc:`metadata-standard`.

Propósito
=========

Este catálogo lista los diagramas canónicos disponibles para
reutilización en docs del proyecto. Cada diagrama tiene:

- ID único.
- Tipo (arquitectónico / proceso / secuencia / modelo).
- Aplicación (en qué docs se referencia).
- Fuente PlantUML disponible para reutilizar.

Catálogo
========

Diagramas Arquitectónicos
-------------------------

.. list-table::
 :widths: 20 35 45
 :header-rows: 1

 * - ID
   - Diagrama
   - Aplicación principal
 * - DGM-ARQ-001
   - Arquitectura modular monolith IACT
   - :doc:`/devops/adr-devops-001-vagrant-mod-wsgi-importante-produc`
 * - DGM-ARQ-002
   - BD Dual (IVR read-only + Analytics)
   - :doc:`/databases/modelo-dual`
 * - DGM-ARQ-003
   - Pipeline ETL IVR → Analytics
   - :doc:`/devops/runbooks/runbook-reprocesar-etl-fallido`

Diagramas RBAC
--------------

.. list-table::
 :widths: 20 35 45
 :header-rows: 1

 * - ID
   - Diagrama
   - Aplicación
 * - DGM-RBAC-001
   - Modelo RBAC plano IACT
   - :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
 * - DGM-RBAC-002
   - Matriz RACI funciones
   - :doc:`/arquitectura-tecnica/rbac/raci-rbac-iact`
 * - DGM-RBAC-003
   - Coexistencia ACC + PERM
   - :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`

Diagramas de Proceso (SDLC)
---------------------------

.. list-table::
 :widths: 20 35 45
 :header-rows: 1

 * - ID
   - Diagrama
   - Aplicación
 * - DGM-PROC-001
   - Mapa procedimientos ↔ templates ↔ workflows
   - :doc:`/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates`
 * - DGM-PROC-002
   - Pipeline desarrollo IACT
   - :doc:`/normativa/procedimientos/proc-dev-001-pipeline-trabajo-iact`

Convención
==========

- Naming: ``DGM-{TIPO}-NNN`` (TIPO = ARQ / RBAC / PROC / SEQ / FLOW).
- Sources PlantUML viven en ``source/_static/diagramas/`` (TODO).
- Cada diagrama declara metadata canónica per
  :doc:`metadata-standard`.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``bpa-design`` (Business Process Architecture — Design)
 * - **ADR aplicable**
   - :doc:`/normativa/gobernanza/adr-gob-002-plantuml-para-diagramas`
 * - **Procedimiento**
   - :doc:`/normativa/procedimientos/proced-gob-006-generar-diagrama-uml-plantuml`
 * - **Guidelines**
   - :doc:`guidelines`, :doc:`metadata-standard`, :doc:`color-palette`
