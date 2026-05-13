.. meta::
   :artefacto: MTM_02
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

.. _mtm-02:

==================================
MTM_02: Metamodelo de Trazabilidad
==================================


Proposito
---------

Este documento define el **metamodelo formal** de trazabilidad del proyecto
IACT. Especifica los tipos de enlaces, direcciones de trazado y reglas de
validacion para la Matriz de Trazabilidad de Requisitos (RTM).

----

1. Concepto de Trazabilidad
---------------------------

1.1 Definicion
^^^^^^^^^^^^^^

.. code-block:: text

   TRAZABILIDAD:
   Capacidad de seguir la vida de un requisito en ambas direcciones:
   - FORWARD:  Desde origen hacia implementacion
   - BACKWARD: Desde implementacion hacia origen

   PROPOSITO:
   - Verificar cobertura completa
   - Analizar impacto de cambios
   - Demostrar cumplimiento

1.2 Niveles de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   NIVEL 0: BR (Reglas de Negocio)
       |
       | deriva/influye
       v
   NIVEL 1: BReq (Objetivos de Negocio)
       |
       | genera
       v
   NIVEL 2: UC (Casos de Uso)
       |
       | deriva
       v
   NIVEL 3: FR (Requisitos Funcionales)
       |
       | implementa
       v
   NIVEL 4: CODE (Codigo Fuente)
       |
       | verifica
       v
   NIVEL 5: TEST (Casos de Prueba)

----

2. Diagrama del Metamodelo
--------------------------

2.1 Clases Principales
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                        <<abstract>>                               |
   |                       TraceableItem                               |
   +------------------------------------------------------------------+
   | - id: String                                                      |
   | - tipo: TipoArtefacto                                            |
   | - version: String                                                 |
   | - estado: EstadoArtefacto                                        |
   +------------------------------------------------------------------+
   | + obtenerLinksEntrantes(): List<TraceLink>                       |
   | + obtenerLinksSalientes(): List<TraceLink>                       |
   | + calcularCobertura(): Float                                      |
   +------------------------------------------------------------------+
                                    △
                                    │
       ┌────────────┬───────────────┼───────────────┬────────────┐
       │            │               │               │            │
   +---+---+   +----+----+   +------+-----+   +-----+----+  +----+----+
   |  BR   |   |  BReq   |   |    UC      |   |    FR    |  |  Test   |
   +-------+   +---------+   +------------+   +----------+  +---------+

2.2 Clase TraceLink
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                         TraceLink                                 |
   +------------------------------------------------------------------+
   | - id: String                                                      |
   | - origen: TraceableItem                                          |
   | - destino: TraceableItem                                         |
   | - tipoLink: TipoLink                                             |
   | - direccion: Direccion                                           |
   | - justificacion: String                                          |
   | - fechaCreacion: Date                                            |
   | - creadoPor: String                                              |
   +------------------------------------------------------------------+
   | + esValido(): Boolean                                            |
   | + obtenerCamino(): List<TraceableItem>                           |
   +------------------------------------------------------------------+

2.3 Diagrama de Relaciones
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +-------------+                      +-------------+
   |TraceableItem|                      | TraceLink   |
   +------+------+                      +------+------+
          |                                    |
          | 1                                  | *
          +------------------------------------+
          |         linksSalientes             |
          +------------------------------------+
          | 1                                  | *
          +------------------------------------+
          |         linksEntrantes             |
          +------------------------------------+

----

3. Tipos de Enlaces
-------------------

3.1 Enumeracion TipoLink
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   <<enumeration>>
   TipoLink
   ─────────────────────────────────────────
   DERIVA       // BR/UC genera UC/FR
   INFLUYE      // BR afecta sin generar
   IMPLEMENTA   // FR se convierte en CODE
   VERIFICA     // TEST valida FR
   REFINA       // Detalla sin cambiar nivel
   SATISFACE    // Cumple objetivo BReq
   CONFLICTO    // Contradiccion detectada
   DEPENDE      // Requiere otro artefacto

3.2 Matriz de Enlaces Validos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 14 14 14 14 14 15

   * - Desde\\Hacia
     - BR
     - BReq
     - UC
     - FR
     - CODE
     - TEST
   * - **BR**
     - --
     - influye
     - deriva
     - influye
     - --
     - --
   * - **BReq**
     - --
     - --
     - genera
     - --
     - --
     - --
   * - **UC**
     - --
     - satisface
     - refina
     - deriva
     - --
     - --
   * - **FR**
     - --
     - --
     - --
     - depende
     - implementa
     - --
   * - **CODE**
     - --
     - --
     - --
     - --
     - --
     - --
   * - **TEST**
     - --
     - --
     - --
     - verifica
     - --
     - --

3.3 Descripcion de Enlaces
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo
     - Semantica
     - Ejemplo
   * - **DERIVA**
     - Origen produce destino por derivacion
     - UC_010 --deriva--> FR-10.1
   * - **INFLUYE**
     - Origen afecta destino sin generarlo
     - BR_015 --influye--> UC_010
   * - **IMPLEMENTA**
     - Codigo realiza el requisito
     - FR-10.1 --implementa--> RoleService.assign()
   * - **VERIFICA**
     - Test valida cumplimiento
     - TEST_010_01 --verifica--> FR-10.1
   * - **REFINA**
     - Agrega detalle al mismo nivel
     - UC_010a --refina--> UC_010
   * - **SATISFACE**
     - Cumple objetivo de negocio
     - UC_010 --satisface--> BReq_003
   * - **CONFLICTO**
     - Contradiccion entre artefactos
     - FR-10.5 --conflicto--> FR-11.3
   * - **DEPENDE**
     - Requiere completar primero
     - FR-10.5 --depende--> FR-05.1

----

4. Direcciones de Trazado
-------------------------

4.1 Forward Tracing
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FORWARD TRACING (Hacia adelante)
   ═════════════════════════════════════════════════════════

   Direccion: Origen → Implementacion

   BR_015 (SoD)
       |
       v
   UC_010 (Asignar Rol)
       |
       v
   FR-10.6 (Validar SoD)
       |
       v
   RoleService.validateSoD()
       |
       v
   TEST_010_06 (Test SoD)

   PREGUNTA QUE RESPONDE:
   "¿Donde se implementa esta regla de negocio?"
   "¿Que tests cubren este requisito?"

4.2 Backward Tracing
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BACKWARD TRACING (Hacia atras)
   ═════════════════════════════════════════════════════════

   Direccion: Implementacion → Origen

   TEST_010_06
       |
       v
   RoleService.validateSoD()
       |
       v
   FR-10.6
       |
       v
   UC_010
       |
       v
   BR_015

   PREGUNTA QUE RESPONDE:
   "¿Por que existe este codigo?"
   "¿Que justifica este test?"

4.3 Grafo de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +-------+     +-------+     +-------+
   | BR_015|---->|UC_010 |---->|FR-10.6|
   +-------+     +---+---+     +---+---+
                     |             |
                     v             v
                +-------+     +--------+
                |FR-10.1|     | CODE   |
                +---+---+     +---+----+
                    |             |
                    v             v
                +-------+     +--------+
                | CODE  |     | TEST   |
                +-------+     +--------+

----

5. Estructura de la RTM
-----------------------

5.1 Columnas de la Matriz
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RTM (Requirements Traceability Matrix)

   +--------+--------+--------+--------+--------+--------+--------+
   | BR_ID  | UC_ID  | FR_ID  | CODE   | TEST   | STATUS | NOTES  |
   +--------+--------+--------+--------+--------+--------+--------+
   | BR_015 | UC_010 | FR-10.6| Role   | T_010  | IMPL   | SoD    |
   |        |        |        | Svc.   | _06    |        | valid. |
   +--------+--------+--------+--------+--------+--------+--------+
   | BR_001 | --     | --     | DB     | T_DB   | IMPL   | Read   |
   |        |        |        | Config | _001   |        | only   |
   +--------+--------+--------+--------+--------+--------+--------+

5.2 Estados de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   <<enumeration>>
   EstadoTrazabilidad
   ─────────────────────────────────────────
   PENDIENTE     // Link identificado, no implementado
   EN_PROGRESO   // Implementacion en curso
   IMPLEMENTADO  // Codigo existe
   VERIFICADO    // Test pasa
   OBSOLETO      // Ya no aplica

5.3 Metricas de Cobertura
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   COBERTURA DE TRAZABILIDAD

   Cobertura BR->UC:
   = (BR con UC derivados / Total BR) * 100

   Cobertura UC->FR:
   = (UC con FR derivados / Total UC) * 100

   Cobertura FR->CODE:
   = (FR implementados / Total FR) * 100

   Cobertura FR->TEST:
   = (FR con test / Total FR) * 100

   UMBRAL MINIMO IACT:
   - BR->UC:    100% (toda BR debe tener impacto)
   - UC->FR:    100% (todo UC genera FR)
   - FR->CODE:   90% (MVP permite gaps)
   - FR->TEST:   80% (priorizacion por riesgo)

----

6. Reglas de Validacion
-----------------------

6.1 Restricciones OCL
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   -- Todo FR debe tener al menos un UC de origen
   context FunctionalRequirement
   inv: self.linksEntrantes->exists(l |
        l.tipoLink = TipoLink::DERIVA and
        l.origen.oclIsTypeOf(UseCase))

   -- Todo UC debe derivar al menos un FR
   context UseCase
   inv: self.linksSalientes->exists(l |
        l.tipoLink = TipoLink::DERIVA and
        l.destino.oclIsTypeOf(FunctionalRequirement))

   -- No pueden existir ciclos en derivacion
   context TraceLink
   inv: self.tipoLink = TipoLink::DERIVA implies
        not self.destino.obtenerCamino()->includes(self.origen)

   -- BR tipo TRIGGER debe tener UC derivado
   context BusinessRule
   inv: self.tipo = TipoBR::DESENCADENADOR implies
        self.linksSalientes->exists(l |
        l.tipoLink = TipoLink::DERIVA)

6.2 Reglas de Integridad
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 10 50 40

   * - #
     - Regla
     - Validacion
   * - T1
     - FR tiene origen UC
     - COUNT(links entrantes DERIVA) >= 1
   * - T2
     - UC genera FR
     - COUNT(links salientes DERIVA) >= 1
   * - T3
     - Sin ciclos
     - Grafo es DAG (aciclico)
   * - T4
     - BR Trigger tiene UC
     - Si tipo=TRIGGER entonces tiene link DERIVA
   * - T5
     - Link tiene justificacion
     - justificacion.length >= 10

----

7. Operaciones del Metamodelo
-----------------------------

7.1 Analisis de Impacto
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   OPERACION: analizarImpacto(artefacto: TraceableItem): Set<TraceableItem>

   ALGORITMO:
   1. Obtener todos los links salientes del artefacto
   2. Para cada destino, recursivamente obtener sus links salientes
   3. Retornar conjunto de todos los artefactos afectados

   EJEMPLO:
   analizarImpacto(BR_015) = {UC_010, FR-10.6, FR-10.7, CODE_*, TEST_*}

   USO:
   - Evaluar costo de cambio en BR
   - Identificar tests a re-ejecutar
   - Planificar releases

7.2 Verificar Cobertura
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   OPERACION: verificarCobertura(nivel: Nivel): Float

   ALGORITMO:
   1. Obtener todos los artefactos del nivel
   2. Contar los que tienen link saliente al siguiente nivel
   3. Retornar porcentaje

   EJEMPLO:
   verificarCobertura(NIVEL_UC) = 95%  // 36 de 38 UC tienen FR

7.3 Detectar Huerfanos
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   OPERACION: detectarHuerfanos(): Set<TraceableItem>

   ALGORITMO:
   1. Para cada artefacto (excepto BR y BReq)
   2. Verificar si tiene al menos un link entrante
   3. Si no tiene, agregar a conjunto de huerfanos

   EJEMPLO:
   huerfanos = {FR-99.1, TEST_orphan_01}

   ACCION:
   - Huerfanos deben eliminarse o vincularse

----

8. Representacion RTM IACT
--------------------------

8.1 Fragmento de Matriz
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +--------+--------+----------+------------------+------------+--------+
   | BR     | UC     | FR       | CODE             | TEST       | STATUS |
   +--------+--------+----------+------------------+------------+--------+
   | BR_015 | UC-010 | FR-10.6  | RoleService.     | T_010_06   | VERIF  |
   |        |        |          | validateSoD()    |            |        |
   +--------+--------+----------+------------------+------------+--------+
   | BR_015 | UC-010 | FR-10.7  | RoleService.     | T_010_07   | IMPL   |
   |        |        |          | checkConflicts() |            |        |
   +--------+--------+----------+------------------+------------+--------+
   | BR_001 | --     | FR-ETL.1 | ETLJob.          | T_ETL_01   | VERIF  |
   |        |        |          | readOnly()       |            |        |
   +--------+--------+----------+------------------+------------+--------+
   | BR_002 | UC-ETL | FR-ETL.3 | ETLJob.          | T_ETL_03   | IMPL   |
   |        |        |          | syncNightly()    |            |        |
   +--------+--------+----------+------------------+------------+--------+

8.2 Estadisticas Actuales
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 20 25 25

   * - Metrica
     - Valor
     - Umbral
     - Estado
   * - BR identificadas
     - 6
     - --
     - ✓
   * - UC derivados
     - 38
     - --
     - ✓
   * - FR estimados
     - ~300
     - --
     - Pendiente
   * - Cobertura BR->UC
     - 100%
     - 100%
     - ✓
   * - Cobertura UC->FR
     - 0%
     - 100%
     - Pendiente
   * - Cobertura FR->TEST
     - 0%
     - 80%
     - Pendiente

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-04` - Trazabilidad (fundamentos)
- :ref:`mtm-01` - Metamodelo de Requisitos
- :ref:`txm-01` - Taxonomia de Requisitos

Fuentes
^^^^^^^

- IEEE 830-1998: Requirements Traceability
- Gotel & Finkelstein: "An Analysis of Requirements Traceability"
- Wiegers: "Software Requirements" (Chapter 20)

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
     - Version inicial con metamodelo completo

----

**Trazabilidad:** Este metamodelo define la estructura formal de la
trazabilidad en IACT. Es la base para la RTM en gobernanza/trazabilidad/
y las validaciones automaticas de cobertura.
