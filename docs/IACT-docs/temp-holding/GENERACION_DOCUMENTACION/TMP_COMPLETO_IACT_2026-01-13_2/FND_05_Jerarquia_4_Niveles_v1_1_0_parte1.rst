.. meta::
   :artefacto: FND_05
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-05:

==============================================================================
FND_05: Jerarquia de 4 Niveles
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Este documento describe la **jerarquia de abstraccion de requisitos** que
fundamenta el modelo IACT. Explica los 4 niveles desde Business Rules hasta
Functional Requirements y como se relacionan entre si.

----

1. Vision General
-----------------

1.1 Principio Fundamental
^^^^^^^^^^^^^^^^^^^^^^^^^

Los requisitos NO son planos. Existen en **niveles de abstraccion** que van
desde lo mas general y estable (reglas de negocio) hasta lo mas especifico
y cambiante (requisitos funcionales).

.. code-block:: text

   MAS ABSTRACTO                              MAS CONCRETO
   MAS ESTABLE                                MAS CAMBIANTE
   MAYOR ALCANCE                              MENOR ALCANCE
        |                                           |
        v                                           v

   +------------+    +------------+    +--------+    +--------+
   | Nivel 0    | -> | Nivel 1    | -> | Nivel 2| -> | Nivel 3|
   | BR         |    | BReq       |    | UC     |    | FR     |
   | (Reglas)   |    | (Objetivos)|    | (Casos)|    | (Func.)|
   +------------+    +------------+    +--------+    +--------+

1.2 Preguntas por Nivel
^^^^^^^^^^^^^^^^^^^^^^^

Cada nivel responde una pregunta diferente:

.. list-table::
   :header-rows: 1
   :widths: 15 25 60

   * - Nivel
     - Pregunta
     - Descripcion
   * - Nivel 0 (BR)
     - POR QUE esta restriccion?
     - Origen de las politicas y regulaciones
   * - Nivel 1 (BReq)
     - POR QUE este proyecto?
     - Justificacion y objetivos del proyecto
   * - Nivel 2 (UC)
     - QUE hace el usuario?
     - Comportamientos observables del sistema
   * - Nivel 3 (FR)
     - COMO lo hace el sistema?
     - Especificaciones atomicas implementables

1.3 Implementacion en IACT (v1.1.0)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. important::

   **DECISION ARQUITECTONICA (v1.1.0):**
   
   IACT implementa los 4 niveles completos de la jerarquia:
   
   - **Nivel 0 (BR):** requisitos/reglas_negocio/ → 20 BR
   - **Nivel 1 (BReq):** requisitos/objetivos/ → 5 BReq
   - **Nivel 2 (UC):** requisitos/casos_uso/ → 49 UC
   - **Nivel 3 (FR):** requisitos/funcionales/ → ~400 FR (estimado)

.. note::

   **Clarificacion sobre META_04:**
   
   El archivo META_04_Contexto_IACT.rst contiene informacion de contexto
   del proyecto (ambiente, stakeholders, sistemas existentes). Esto NO ES
   lo mismo que Business Requirements (BReq).
   
   - META_04 = Contexto (descripcion del ambiente)
   - BReq = Objetivos de negocio medibles
   
   Los BReq se documentan en requisitos/objetivos/BReq_001_Objetivos_IACT.rst

----

2. Nivel 0: Business Rules (BR)
-------------------------------

2.1 Definicion
^^^^^^^^^^^^^^

Las **Business Rules** son declaraciones sobre como opera la organizacion.
No son creadas por el proyecto de software; existen independientemente y
el software debe conformarse a ellas.

2.2 Caracteristicas
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Preexistentes**
     - Existen antes del proyecto, no dependen de el
   * - **Organizacionales**
     - Aplican a toda la organizacion, no solo al sistema
   * - **Estables**
     - Cambian con poca frecuencia
   * - **Imperativas**
     - Expresan obligacion, prohibicion o permiso

2.3 Tipos de BR (Taxonomia)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   TIPO              PATRON                       GENERA UC?
   ─────────────────────────────────────────────────────────────
   Hecho             "[X] ES/TIENE [Y]"           NO
   Restriccion       "[X] DEBE/NO DEBE [Y]"       Parcial
   Desencadenador    "SI [cond] ENTONCES [vis]"   SI
   Inferencia        "SI [cond] ENTONCES [int]"   NO
   Calculo           "[Resultado] = [formula]"    NO

2.4 BR en IACT
^^^^^^^^^^^^^^

.. code-block:: text

   TIPO              CANTIDAD    EJEMPLO
   ─────────────────────────────────────────────────────────────
   Hecho                 4       BR_006: RBAC Flat NIST
   Restriccion           9       BR_007: Separacion de Funciones
   Desencadenador        3       BR_002: ETL Batch Nocturno
   Inferencia            1       BR_003: Usuario Inactivo 90d
   Calculo               3       BR_016: Tasa Abandono
   ─────────────────────────────────────────────────────────────
   TOTAL                20

----

3. Nivel 1: Business Requirements (BReq)
----------------------------------------

3.1 Definicion
^^^^^^^^^^^^^^

Los **Business Requirements** expresan los objetivos de alto nivel que
justifican la existencia del proyecto. Responden: "Por que estamos
construyendo este sistema?"

3.2 Caracteristicas
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Estrategicos**
     - Vision de negocio, no tecnica
   * - **Justificativos**
     - Explican el ROI del proyecto
   * - **Influenciados**
     - Por BR, pero no son reiteracion de ellas
   * - **Alcance**
     - Definen limites del proyecto
   * - **Medibles**
     - Tienen metricas de exito cuantificables

3.3 Relacion con BR
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Business Rules INFLUYEN en Business Requirements:

   BR_001 (Fuente Inmutable)  ----+
   BR_002 (ETL Nocturno)      ----+---> BReq-001: Visibilidad de
                                        metricas IVR en tiempo real

   BR_006 (RBAC Flat)         ----+
   BR_007 (SoD)               ----+---> BReq-004: Cumplimiento de
   BR_010 (Auditoria)         ----+     seguridad y auditoria

3.4 BReq en IACT (v1.1.0)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ID        NOMBRE                      METRICA DE EXITO
   ─────────────────────────────────────────────────────────────────────
   BReq-001  Visibilidad Metricas IVR    Dashboard actualizado cada 5 min
   BReq-002  Reduccion Tiempo Incidentes Reduccion >= 40% vs linea base
   BReq-003  Decisiones Informadas       100% decisiones con datos
   BReq-004  Cumplimiento Seguridad      0 accesos no autorizados
   BReq-005  Integridad Datos            0 escrituras no autorizadas

3.5 Ubicacion en IACT
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   IACT/
   └── requisitos/
       └── objetivos/                    ← Nivel 1 (BReq)
           ├── index.rst
           └── BReq_001_Objetivos_IACT.rst
