.. meta::
   :dominio: normativa
   :subdominio: gobernanza
   :tipo: Indice
   :estado: Aprobado
   :version: 1.0.0

.. _gobernanza-index:
.. _gob-05:

=====================
Gobernanza Documental
=====================

Este subdominio contiene las **politicas, procesos y estandares** que rigen
el sistema documental IACT, estableciendo las reglas de gobernanza que
garantizan calidad, consistencia y trazabilidad.

----

Proposito del Subdominio
------------------------

El subdominio ``gobernanza/`` define **como** se gestiona la documentacion:

- Quien puede crear, modificar y aprobar artefactos
- Que criterios de calidad deben cumplirse
- Como se versionan y controlan los cambios
- Como se audita el cumplimiento

----

Catalogo de Artefactos
----------------------

Modelo y Estructura
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 45 20 20

   * - ID
     - Titulo
     - Tipo
     - Estado
   * - :ref:`gob-01`
     - Modelo de Gobernanza IACT
     - Politica
     - Aprobado
   * - :ref:`gob-02`
     - Roles y Matriz RACI
     - Matriz
     - Aprobado
   * - :ref:`gob-07`
     - Gestion de Dominios
     - Politica
     - Aprobado

Control de Artefactos
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 45 20 20

   * - ID
     - Titulo
     - Tipo
     - Estado
   * - :ref:`gob-03`
     - Control de Calidad Documental
     - Proceso
     - Aprobado
   * - :ref:`gob-04`
     - Gestion de Cambios Documentales
     - Proceso
     - Aprobado
   * - :ref:`gob-05`
     - Control de Versiones
     - Estandar
     - Aprobado
   * - :ref:`gob-08`
     - Estados Documentales
     - Politica
     - Aprobado

Seguridad y Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 45 20 20

   * - ID
     - Titulo
     - Tipo
     - Estado
   * - :ref:`gob-06`
     - Trazabilidad SDLC
     - Proceso
     - Aprobado
   * - :ref:`gob-09`
     - Politica de Clasificacion
     - Politica
     - Aprobado
   * - :ref:`gob-10`
     - Auditoria Documental
     - Proceso
     - Aprobado

----

Mapa de Dependencias
--------------------

.. code-block:: text

   GOB_01 (Modelo de Gobernanza)
      │
      ├──► GOB_02 (Roles y RACI)
      │       │
      │       └──► GOB_03 (Control de Calidad)
      │               │
      │               └──► GOB_10 (Auditoria)
      │
      ├──► GOB_07 (Gestion de Dominios)
      │
      ├──► GOB_04 (Gestion de Cambios)
      │       │
      │       └──► GOB_05 (Control de Versiones)
      │
      ├──► GOB_08 (Estados Documentales)
      │
      ├──► GOB_06 (Trazabilidad SDLC)
      │
      └──► GOB_09 (Politica de Clasificacion)
              │
              └──► GOB_10 (Auditoria)

----

Guia de Uso Rapido
------------------

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Si necesitas saber...
     - Consulta
   * - ¿Quien aprueba que?
     - :ref:`gob-02` (Roles y RACI)
   * - ¿Como versionar un documento?
     - :ref:`gob-05` (Control de Versiones)
   * - ¿Como modificar un doc aprobado?
     - :ref:`gob-04` (Gestion de Cambios)
   * - ¿Que criterios debe cumplir un doc?
     - :ref:`gob-03` (Control de Calidad)
   * - ¿En que estado puede estar un doc?
     - :ref:`gob-08` (Estados Documentales)
   * - ¿Como se organiza la documentacion?
     - :ref:`gob-07` (Gestion de Dominios)
   * - ¿Quien puede ver este documento?
     - :ref:`gob-09` (Politica de Clasificacion)
   * - ¿Como se audita el cumplimiento?
     - :ref:`gob-10` (Auditoria Documental)
   * - ¿Como se relacionan BR, UC, FR?
     - :ref:`gob-06` (Trazabilidad SDLC)

----

Estadisticas del Subdominio
---------------------------

.. list-table::
   :widths: 50 25

   * - Total de artefactos
     - 10
   * - Politicas
     - 4
   * - Procesos
     - 4
   * - Estandares
     - 1
   * - Matrices
     - 1
   * - Estado
     - Congelado

----

Arbol de Contenido
------------------

.. toctree::
   :maxdepth: 1
   :caption: Artefactos de Gobernanza

   GOB_01_Modelo_Gobernanza_IACT
   GOB_02_Roles_y_RACI
   GOB_03_Control_Calidad_Documental
   GOB_04_Gestion_Cambios_Documentales
   GOB_06_Trazabilidad_SDLC
   GOB_07_Gestion_Dominios
   GOB_08_Estados_Documentales
   GOB_09_Politica_Clasificacion
   GOB_10_Auditoria_Documental

----

**Owner:** PMO
**Clasificacion:** Interno
**Ultima actualizacion:** 2025-12-22


.. toctree::
   :hidden:
   :maxdepth: 1

   ADR-BACK-001-grupos-funcionales-sin-jerarquia
   ADR-BACK-002-configuracion-dinamica-sistema
   ADR-BACK-003-orm-sql-hybrid-permissions
   ADR-BACK-004-sistema-permisos-sin-roles-jerarquicos
   ADR-DEVOPS-001-vagrant-mod-wsgi-IMPORTANTE-PRODUC
   ADR-DEVOPS-003-wasi-style-virtualization--IMPORTANTE-DB
   ADR-FRONT-001-frontend-modular-monolith
   ADR-FRONT-002-redux-toolkit-state-management
   ADR-FRONT-003-webpack-bundler
   ADR-FRONT-004-arquitectura-microfrontends
   ADR-FRONT-010-typescript-adopcion-gradual
   ADR-GOB-002-organizacion-proyecto-por-dominio
   ADR-GOB-004-plantuml-para-diagramas
   ADR-GOB-005-jerarquia-requerimientos-5-niveles
   ADR-GOB-006-clasificacion-reglas-negocio
   ADR-GOB-007-especificacion-casos-uso
   ADR-GOB-008-diagramas-uml-casos-uso
   ADR-GOB-009-trazabilidad-artefactos-requisitos
   ADR-QA-002-testing-strategy-jest-testing-library
   Architecture Decision Records (ADRs) - Indice Maestro
   Ejemplos - GOBERNANZA
   Gobernanza del Frontend-README
   README-(ADR) - Backend
