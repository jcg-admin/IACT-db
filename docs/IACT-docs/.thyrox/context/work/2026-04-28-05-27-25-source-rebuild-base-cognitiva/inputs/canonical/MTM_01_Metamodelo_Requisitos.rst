.. meta::
   :artefacto: MTM_01
   :tipo: Metamodelo
   :dominio: base_cognitiva
   :subdominio: _taxonomias_y_metamodelos
   :subcarpeta: metamodelos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _mtm-01:

================================
MTM_01: Metamodelo de Requisitos
================================


Proposito
---------

Este documento define el **metamodelo formal** de los tipos de requisitos
del proyecto IACT. Presenta las relaciones estructurales mediante diagramas
UML y especifica cardinalidades, herencia y restricciones.

.. note::

   **Metamodelo vs Taxonomia:**

   - Taxonomia (TXM): Clasifica conceptos en categorias jerarquicas
   - Metamodelo (MTM): Define estructura formal y relaciones (UML)

   Este documento es un METAMODELO (estructura formal con UML).

----

1. Diagrama de Clases Principal
-------------------------------

1.1 Vista General
^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                        <<abstract>>                               |
   |                         Requisito                                 |
   +------------------------------------------------------------------+
   | - id: String                                                      |
   | - nombre: String                                                  |
   | - descripcion: Text                                               |
   | - estado: EstadoRequisito                                         |
   | - version: String                                                 |
   | - fecha_creacion: Date                                            |
   | - autor: String                                                   |
   +------------------------------------------------------------------+
   | + validar(): Boolean                                              |
   | + obtenerTrazabilidad(): List<Requisito>                          |
   +------------------------------------------------------------------+
                                    △
                                    │
          ┌─────────────┬───────────┼───────────┬─────────────┐
          │             │           │           │             │
   +------+------+ +----+----+ +----+----+ +----+----+ +------+------+
   |BusinessRule | |BizReq   | |UseCase  | |FuncReq  | |NonFuncReq   |
   +-------------+ +---------+ +---------+ +---------+ +-------------+
   | - tipo      | |- objetivo| |- actor | |- ucOrigen| |- categoria |
   | - modalidad | |- alcance | |- flujos| |- paso   | |- metrica   |
   | - fuente    | |          | |        | |         | |- umbral    |
   +-------------+ +---------+ +---------+ +---------+ +-------------+

1.2 Diagrama PlantUML
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   @startuml
   skinparam monochrome true

   abstract class Requisito {
     - id: String
     - nombre: String
     - descripcion: Text
     - estado: EstadoRequisito
     - version: String
     + validar(): Boolean
   }

   class BusinessRule {
     - tipo: TipoBR
     - modalidad: Modalidad
     - fuente: String
     - estatica: Boolean
   }

   class BusinessRequirement {
     - objetivo: String
     - alcance: String
     - justificacion: String
   }

   class UseCase {
     - actorPrimario: Actor
     - objetivo: String
     - precondiciones: List
     - postcondiciones: List
     - flujoNormal: List<Paso>
     - flujosAlternos: List<Flujo>
   }

   class FunctionalRequirement {
     - ucOrigen: UseCase
     - pasoOrigen: Integer
     - categoria: CategoriaFR
   }

   class NonFunctionalRequirement {
     - categoria: CategoriaNFR
     - metrica: String
     - umbral: String
   }

   Requisito <|-- BusinessRule
   Requisito <|-- BusinessRequirement
   Requisito <|-- UseCase
   Requisito <|-- FunctionalRequirement
   Requisito <|-- NonFunctionalRequirement

   @enduml

----

2. Relaciones entre Tipos
-------------------------

2.1 Diagrama de Relaciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +---------------+          +-------------------+
   | BusinessRule  |          | BusinessRequirement|
   |    (BR)       |          |      (BReq)       |
   +-------+-------+          +---------+---------+
           |                            |
           | influye (0..*)             | genera (1..*)
           |                            |
           v                            v
   +-------+-----------------------------+---------+
   |                  UseCase                      |
   |                   (UC)                        |
   +----------------------+------------------------+
                          |
                          | deriva (1..*)
                          |
                          v
   +----------------------+------------------------+
   |            FunctionalRequirement              |
   |                   (FR)                        |
   +-----------------------------------------------+

2.2 Matriz de Relaciones
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 20 20 20 20

   * - Desde / Hacia
     - BR
     - BReq
     - UC
     - FR
   * - **BR**
     - --
     - influye
     - genera/influye
     - influye
   * - **BReq**
     - --
     - --
     - genera
     - --
   * - **UC**
     - --
     - --
     - --
     - deriva
   * - **FR**
     - --
     - --
     - --
     - --

----

3. Detalle de Clases
--------------------

3.1 Clase BusinessRule
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +--------------------------------------------------+
   |                  BusinessRule                     |
   +--------------------------------------------------+
   | <<attributes>>                                    |
   | - tipo: TipoBR {Hecho, Restriccion, Trigger,     |
   |                 Inferencia, Calculo}              |
   | - modalidad: Modalidad {Aletica, Deontica}       |
   | - fuente: String                                  |
   | - fechaEfectiva: Date                            |
   | - estatica: Boolean                               |
   +--------------------------------------------------+
   | <<operations>>                                    |
   | + esViolable(): Boolean                          |
   | + generaUC(): Boolean                            |
   | + obtenerUCDerivados(): List<UseCase>            |
   +--------------------------------------------------+

   INVARIANTES:
   - Si tipo = Trigger ENTONCES generaUC() = true
   - Si tipo = Inferencia ENTONCES generaUC() = false
   - Si modalidad = Aletica ENTONCES esViolable() = false

3.2 Clase UseCase
^^^^^^^^^^^^^^^^^

.. code-block:: text

   +--------------------------------------------------+
   |                    UseCase                        |
   +--------------------------------------------------+
   | <<attributes>>                                    |
   | - actorPrimario: Actor                           |
   | - actoresSecundarios: List<Actor>                |
   | - objetivo: String                                |
   | - precondiciones: List<Condicion>                |
   | - postcondiciones: List<Condicion>               |
   | - trigger: String                                 |
   +--------------------------------------------------+
   | <<associations>>                                  |
   | - flujoNormal: List<Paso> [1..*]                 |
   | - flujosAlternos: List<FlujoAlterno> [0..*]      |
   | - excepciones: List<Excepcion> [0..*]            |
   | - businessRules: List<BusinessRule> [0..*]       |
   +--------------------------------------------------+
   | <<operations>>                                    |
   | + obtenerFR(): List<FunctionalRequirement>       |
   | + contarPasos(): Integer                          |
   | + validarCompletitud(): Boolean                  |
   +--------------------------------------------------+

   INVARIANTES:
   - flujoNormal.size() >= 3 (minimo inicio, proceso, fin)
   - actorPrimario != null
   - objetivo != null AND objetivo.length() >= 10

3.3 Clase FunctionalRequirement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +--------------------------------------------------+
   |              FunctionalRequirement                |
   +--------------------------------------------------+
   | <<attributes>>                                    |
   | - ucOrigen: UseCase                              |
   | - pasoOrigen: Integer                            |
   | - categoria: CategoriaFR {Validacion,            |
   |              Procesamiento, Presentacion,         |
   |              Integracion, Seguridad}              |
   | - prioridad: Prioridad {Must, Should, Could}     |
   | - release: String                                 |
   +--------------------------------------------------+
   | <<operations>>                                    |
   | + esVerificable(): Boolean                       |
   | + obtenerTestCases(): List<TestCase>             |
   | + validarAtomicidad(): Boolean                   |
   +--------------------------------------------------+

   INVARIANTES:
   - ucOrigen != null (todo FR deriva de un UC)
   - pasoOrigen > 0
   - descripcion no contiene "y" (atomicidad)

3.4 Clase NonFunctionalRequirement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +--------------------------------------------------+
   |            NonFunctionalRequirement               |
   +--------------------------------------------------+
   | <<attributes>>                                    |
   | - categoria: CategoriaNFR                        |
   |   {Rendimiento, Seguridad, Usabilidad,           |
   |    Confiabilidad, Mantenibilidad}                |
   | - metrica: String                                 |
   | - umbral: String                                  |
   | - metodoVerificacion: String                     |
   +--------------------------------------------------+
   | <<operations>>                                    |
   | + esMedible(): Boolean                           |
   | + obtenerMetrica(): Metrica                      |
   +--------------------------------------------------+

   INVARIANTES:
   - metrica != null (debe ser medible)
   - umbral contiene valor numerico o rango

----

4. Enumeraciones
----------------

4.1 TipoBR
^^^^^^^^^^

.. code-block:: text

   <<enumeration>>
   TipoBR
   ─────────────────
   HECHO
   RESTRICCION
   DESENCADENADOR
   INFERENCIA
   CALCULO

4.2 Modalidad
^^^^^^^^^^^^^

.. code-block:: text

   <<enumeration>>
   Modalidad
   ─────────────────
   ALETICA      // Lo que ES
   DEONTICA     // Lo que DEBE SER

4.3 EstadoRequisito
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   <<enumeration>>
   EstadoRequisito
   ─────────────────
   BORRADOR
   EN_REVISION
   APROBADO
   OBSOLETO
   CONGELADO

4.4 CategoriaFR
^^^^^^^^^^^^^^^

.. code-block:: text

   <<enumeration>>
   CategoriaFR
   ─────────────────
   VALIDACION
   PROCESAMIENTO
   PRESENTACION
   INTEGRACION
   SEGURIDAD

4.5 Prioridad
^^^^^^^^^^^^^

.. code-block:: text

   <<enumeration>>
   Prioridad
   ─────────────────
   MUST_HAVE      // Obligatorio para MVP
   SHOULD_HAVE    // Importante, no critico
   COULD_HAVE     // Deseable si hay tiempo
   WONT_HAVE      // Fuera de alcance

----

5. Relaciones Detalladas
------------------------

5.1 BR influye UC
^^^^^^^^^^^^^^^^^

.. code-block:: text

   RELACION: BusinessRule --influye--> UseCase

   CARDINALIDAD: 0..* a 0..*
   - Una BR puede influir en multiples UC
   - Un UC puede ser influido por multiples BR

   SEMANTICA:
   - BR tipo RESTRICCION: Aparece como precondicion o validacion
   - BR tipo TRIGGER: Genera el UC completo
   - BR tipo HECHO: Define estructura de datos del UC

   EJEMPLO:
   BR_015 (SoD) --influye--> UC_010 (Asignar Rol)
   La restriccion SoD aparece como validacion en paso 6

5.2 UC deriva FR
^^^^^^^^^^^^^^^^

.. code-block:: text

   RELACION: UseCase --deriva--> FunctionalRequirement

   CARDINALIDAD: 1 a 1..*
   - Un UC deriva multiples FR
   - Un FR proviene de exactamente un UC

   SEMANTICA:
   - Cada paso donde "Sistema" actua genera 1+ FR
   - FR son atomicos (un FR por capacidad)

   RATIO TIPICO: 1 UC : 8 FR (promedio)

   EJEMPLO:
   UC_010 --deriva--> FR-10.1, FR-10.2, ..., FR-10.15

5.3 BR genera UC
^^^^^^^^^^^^^^^^

.. code-block:: text

   RELACION: BusinessRule --genera--> UseCase

   CARDINALIDAD: 0..1 a 0..*
   - Una BR tipo TRIGGER genera 0 o 1 UC
   - Solo BR tipo TRIGGER genera UC directamente

   CONDICION:
   BR.tipo = DESENCADENADOR

   EJEMPLO:
   BR_002 (ETL Nocturno) --genera--> UC_ETL (Sincronizar Datos)

----

6. Diagrama de Derivacion
-------------------------

6.1 Flujo de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   NIVEL 0                    NIVEL 1              NIVEL 2           NIVEL 3

   +--------+                                    +---------+
   |  BR    |-----(genera si Trigger)---------->|   UC    |
   | Regla  |                                    |  Caso   |
   +---+----+                                    +----+----+
       |                                              |
       |                                              | deriva
       | influye                                      |
       |                                              v
       |    +--------+      genera      +---------+  +---------+
       +--->| BReq   |----------------->|   UC    |->|   FR    |
            |Objetivo|                  |  Caso   |  | Func.   |
            +--------+                  +---------+  +---------+

   LEYENDA:
   ──────> Relacion de generacion/derivacion
   ─ ─ ─> Relacion de influencia

6.2 Multiplicidades
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR (0..*) ----influye----> (0..*) UC
   BR (0..1) ----genera-----> (0..1) UC  [solo si tipo=TRIGGER]

   BReq (1..*) --genera----> (1..*) UC

   UC (1) ------deriva-----> (1..*) FR

   FR (0..*) --implementa--> (0..*) Codigo
   FR (1..*) --verifica----> (1..*) TestCase

----

7. Restricciones del Metamodelo
-------------------------------

7.1 Restricciones OCL
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   -- Todo FR debe derivar de un UC
   context FunctionalRequirement
   inv: self.ucOrigen <> null

   -- Solo BR tipo TRIGGER genera UC directamente
   context BusinessRule
   inv: self.generaUC() implies self.tipo = TipoBR::DESENCADENADOR

   -- UC debe tener al menos 3 pasos en flujo normal
   context UseCase
   inv: self.flujoNormal->size() >= 3

   -- FR debe ser atomico (no contener "y" en accion principal)
   context FunctionalRequirement
   inv: not self.descripcion.contains(' y ')

   -- NFR debe tener metrica cuantificable
   context NonFunctionalRequirement
   inv: self.metrica <> null and self.umbral <> null

7.2 Reglas de Negocio del Metamodelo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 10 45 45

   * - #
     - Regla
     - Validacion
   * - R1
     - Todo FR tiene origen en UC
     - FR.ucOrigen != null
   * - R2
     - BR Trigger genera exactamente 1 UC
     - COUNT(UC donde BR.genera) = 1
   * - R3
     - FR es atomico
     - FR.descripcion no contiene " y "
   * - R4
     - UC tiene actor primario
     - UC.actorPrimario != null
   * - R5
     - NFR es medible
     - NFR.metrica != null

----

8. Instanciacion IACT
---------------------

8.1 Conteo de Instancias
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Clase
     - Instancias
     - Notas
   * - BusinessRule
     - 6
     - Identificadas en analisis RBAC
   * - BusinessRequirement
     - ~5
     - Objetivos del proyecto
   * - UseCase
     - 38
     - Derivados de BR + CRUD + Larman
   * - FunctionalRequirement
     - ~300
     - Estimado (38 UC x 8 promedio)
   * - NonFunctionalRequirement
     - ~20
     - Pendiente especificacion

8.2 Ejemplo de Instanciacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   :BR_015 (instancia de BusinessRule)
     tipo = RESTRICCION
     modalidad = DEONTICA
     descripcion = "Roles R016 y R017 son mutuamente excluyentes"
     fuente = "Politica de Seguridad"
         |
         | influye
         v
   :UC_010 (instancia de UseCase)
     actorPrimario = R001 (USERS_FULL_MANAGER)
     objetivo = "Asignar rol a usuario"
     flujoNormal = [paso1, paso2, ..., paso11]
     businessRules = [BR_015]
         |
         | deriva
         v
   :FR-10.6 (instancia de FunctionalRequirement)
     ucOrigen = UC_010
     pasoOrigen = 6
     categoria = VALIDACION
     descripcion = "Sistema DEBE validar compatibilidad SoD"

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`txm-01` - Taxonomia de Requisitos
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-06` - Derivacion vs Transformacion
- :ref:`mtm-02` - Metamodelo de Trazabilidad

Fuentes
^^^^^^^

- OMG UML 2.5.1 Specification
- IEEE 830-1998: Software Requirements Specifications
- Larman: "Applying UML and Patterns"

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-20
     - Equipo IACT
     - Version inicial con diagrama de clases completo

----

**Trazabilidad:** Este metamodelo define la estructura formal de los tipos
de requisitos. Complementa :ref:`txm-01` (clasificacion) y fundamenta
:ref:`mtm-02` (trazabilidad). Es la base para validacion automatica de
consistencia entre artefactos.
