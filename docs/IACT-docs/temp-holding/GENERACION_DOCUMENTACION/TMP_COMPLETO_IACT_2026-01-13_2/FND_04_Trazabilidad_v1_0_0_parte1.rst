.. meta::
   :artefacto: FND_04
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-04:

==============================================================================
FND_04: Trazabilidad
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Este documento define QUE ES la Trazabilidad de Requisitos en el contexto del
proyecto IACT, los tipos de enlaces, la matriz RTM, metricas de cobertura y
las herramientas utilizadas para mantener la trazabilidad.

----

1. Definicion Formal
--------------------

1.1 Que es Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^

La **Trazabilidad de Requisitos** es la capacidad de seguir la vida de un
requisito desde su origen hasta su implementacion y verificacion, tanto
hacia adelante (forward) como hacia atras (backward).

.. note::

   **Definicion operativa para IACT:**

   Trazabilidad es la red de enlaces documentados que conecta cada artefacto
   de requisitos (BR, BReq, UC, FR) con sus origenes, derivados y evidencias
   de verificacion.

1.2 Tipos de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo
     - Direccion
     - Proposito
   * - **Forward (Adelante)**
     - Origen → Derivado
     - Verificar que todo requisito se implementa
   * - **Backward (Atras)**
     - Derivado → Origen
     - Verificar que todo codigo tiene justificacion
   * - **Bidireccional**
     - Ambas direcciones
     - Analisis de impacto completo

1.3 Beneficios de la Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BENEFICIO                    DESCRIPCION
   ─────────────────────────────────────────────────────────────
   Analisis de impacto          Identificar que afecta un cambio
   Verificacion de cobertura    Asegurar que nada se omite
   Justificacion de codigo      Todo codigo tiene razon de ser
   Gestion de cambios           Propagacion controlada de cambios
   Auditoria y compliance       Evidencia documentada
   Reutilizacion                Identificar dependencias

----

2. Tipos de Enlaces
-------------------

2.1 Taxonomia de Enlaces
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 15 15 55

   * - Enlace
     - Origen
     - Destino
     - Semantica
   * - **influye**
     - BR
     - BReq
     - BR afecta objetivo sin generar directamente
   * - **genera**
     - BReq
     - UC
     - Objetivo de negocio genera casos de uso
   * - **genera**
     - BR (Trigger)
     - UC
     - BR tipo Desencadenador genera UC especifico
   * - **deriva**
     - UC
     - FR
     - Cada paso "Sistema" del UC deriva FR
   * - **implementa**
     - FR
     - CODE
     - FR se codifica en modulo/funcion
   * - **verifica**
     - TEST
     - FR
     - Test valida cumplimiento de FR
   * - **satisface**
     - UC
     - BReq
     - UC cumple parcialmente objetivo de negocio

2.2 Cardinalidad de Enlaces
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ENLACE              CARDINALIDAD       EJEMPLO
   ─────────────────────────────────────────────────────────────
   BR --influye--> BReq      0..* : 0..*   Varias BR influyen en varios BReq
   BReq --genera--> UC       1 : 1..*     1 BReq genera multiples UC
   BR(Trigger) --genera--> UC  0..1 : 0..1   1 BR Trigger genera maximo 1 UC
   UC --deriva--> FR         1 : 1..*     1 UC deriva multiples FR (ratio ~1:8)
   FR --implementa--> CODE   1 : 0..*     1 FR puede tener 0+ implementaciones
   TEST --verifica--> FR     1..* : 1     Multiples tests verifican 1 FR

2.3 Diagramas de Enlaces
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   JERARQUIA DE DERIVACION (Vertical):

   ┌─────────────┐
   │    BR       │ Nivel 0 - Business Rules
   └──────┬──────┘
          │ influye
          v
   ┌─────────────┐
   │   BReq      │ Nivel 1 - Business Requirements
   └──────┬──────┘
          │ genera
          v
   ┌─────────────┐
   │    UC       │ Nivel 2 - Use Cases
   └──────┬──────┘
          │ deriva
          v
   ┌─────────────┐
   │    FR       │ Nivel 3 - Functional Requirements
   └──────┬──────┘
          │ implementa
          v
   ┌─────────────┐
   │   CODE      │ Nivel 4 - Codigo Fuente
   └──────┬──────┘
          │
          v
   ┌─────────────┐
   │   TEST      │ Nivel 5 - Pruebas (verifica FR)
   └─────────────┘


   TRAZABILIDAD HORIZONTAL (Verificacion):

   FR ←──verifica── TEST
    │
    └──implementa──→ CODE

----

3. Matriz RTM (Requirements Traceability Matrix)
------------------------------------------------

3.1 Definicion
^^^^^^^^^^^^^^

La **Matriz de Trazabilidad de Requisitos (RTM)** es el artefacto central
que documenta todos los enlaces entre requisitos y sus derivados.

3.2 Estructura de la RTM
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RTM IACT - Estructura de Columnas:

   | ID_BR | ID_BReq | ID_UC | ID_FR | ID_CODE | ID_TEST | Estado |
   |-------|---------|-------|-------|---------|---------|--------|
   | BR_001| BReq-005| UC-050| FR-050.1| pipeline/etl.py | TST_PIP_001 | ✅ |
   | BR_002| BReq-001| UC-050| FR-050.2| pipeline/jobs.py| TST_PIP_002 | ✅ |
   | ...   | ...     | ...   | ...   | ...     | ...     | ...    |

3.3 Ubicacion en IACT
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   IACT/
   └── evidencia/
       └── trazabilidad/
           ├── index.rst
           ├── RTM_Master_v1_0_0.rst      ← Matriz principal
           └── COV_001_Reporte_Cobertura.rst  ← Metricas
