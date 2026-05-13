.. meta::
   :artefacto: GOB_06
   :tipo: Proceso
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-06:

=========================
GOB_06: Trazabilidad SDLC
=========================


Proposito
---------

Este documento define el **modelo de trazabilidad** entre artefactos documentales
y las fases del ciclo de vida de desarrollo (SDLC), estableciendo los enlaces
obligatorios, la matriz de trazabilidad (RTM) y los procesos de verificacion
que garantizan la coherencia del sistema documental IACT.

.. important::

   **Pregunta Clave que Responde:**

   "¿Como se relacionan los documentos entre si y con el ciclo de vida?"

.. note::

   Este artefacto complementa :ref:`meta_03_fases_sdlc` que define las fases
   del ciclo de vida. GOB_06 establece las reglas de trazabilidad entre
   artefactos a lo largo de esas fases.

----

1. Modelo de Trazabilidad
-------------------------

1.1 Definicion
^^^^^^^^^^^^^^

La **trazabilidad** es la capacidad de relacionar artefactos entre si,
permitiendo:

.. code-block:: text

   - Rastrear el ORIGEN de un artefacto (de donde viene)
   - Identificar el DESTINO de un artefacto (a donde va)
   - Verificar COBERTURA (que nada quede sin implementar)
   - Analizar IMPACTO de cambios (que se afecta si cambio algo)

1.2 Principios de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PRINCIPIO 1: Trazabilidad Completa
   Todo requisito debe poder rastrearse desde su origen hasta
   su implementacion y verificacion.

   PRINCIPIO 2: Bidireccionalidad
   Los enlaces deben poder navegarse en ambas direcciones:
   BR → UC y UC → BR

   PRINCIPIO 3: Unicidad de Identificadores
   Cada artefacto tiene un ID unico que permite referenciarlo
   sin ambiguedad.

   PRINCIPIO 4: Actualizacion Continua
   La trazabilidad debe mantenerse actualizada con cada cambio.

1.3 Niveles de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Nivel
     - Descripcion
     - Ejemplo
   * - **Vertical**
     - Entre niveles de abstraccion (BR→UC→FR→DES)
     - BR_001 → UC_010 → FR-10.3 → DES_API_010
   * - **Horizontal**
     - Entre artefactos del mismo nivel
     - UC_010 → UC_011 (include/extend)
   * - **Temporal**
     - Entre fases del SDLC
     - FR creado en Elaboration → Implementado en Construction

----

2. Cadena de Trazabilidad Principal
-----------------------------------

2.1 Flujo de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CADENA PRINCIPAL DE TRAZABILIDAD:

   ┌─────────────┐
   │   BR_xxx    │  Reglas de Negocio
   │  (Origen)   │  "El negocio necesita..."
   └──────┬──────┘
          │ genera
          ▼
   ┌─────────────┐
   │   UC_xxx    │  Casos de Uso
   │             │  "El usuario hace..."
   └──────┬──────┘
          │ deriva
          ▼
   ┌─────────────┐
   │   FR_xxx    │  Requisitos Funcionales
   │             │  "El sistema debe..."
   └──────┬──────┘
          │ implementa
          ▼
   ┌─────────────┐
   │   DES_xxx   │  Diseño Detallado
   │             │  "Se construye asi..."
   └──────┬──────┘
          │ verifica
          ▼
   ┌─────────────┐
   │   TEST_xxx  │  Casos de Prueba
   │             │  "Se prueba con..."
   └─────────────┘

2.2 Tipos de Enlace
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 20 30 30

   * - Enlace
     - Direccion
     - Significado
     - Cardinalidad
   * - **genera**
     - BR → UC
     - La BR origina uno o mas UC
     - 1:N
   * - **deriva**
     - UC → FR
     - El UC se descompone en FR
     - 1:N
   * - **implementa**
     - FR → DES
     - El FR se realiza en diseño
     - 1:N
   * - **verifica**
     - FR → TEST
     - El FR se valida con pruebas
     - 1:N
   * - **justifica**
     - FR → ADR
     - El FR motiva una decision
     - N:M
   * - **include**
     - UC → UC
     - Un UC incluye a otro
     - N:M
   * - **extend**
     - UC → UC
     - Un UC extiende a otro
     - N:M
   * - **depende**
     - FR → FR
     - Un FR requiere otro
     - N:M

----

3. Trazabilidad por Fase SDLC
-----------------------------

3.1 Fase Inception
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ARTEFACTOS CREADOS:
   - META_01 (Identidad del Proyecto)
   - Vision del Producto
   - Lista de Stakeholders
   - BR iniciales (identificados, no detallados)
   - UC iniciales (listados, no especificados)

   TRAZABILIDAD REQUERIDA:
   - META_01 referencia Vision
   - BR iniciales vinculados a objetivos de negocio

   MILESTONE: LCO (Lifecycle Objectives)
   Verificar: Alcance acordado, riesgos identificados

3.2 Fase Elaboration
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ARTEFACTOS CREADOS:
   - BR_xxx completos
   - UC_xxx especificados
   - FR_xxx derivados
   - ADR_xxx iniciales
   - RTM creada

   TRAZABILIDAD REQUERIDA:
   - Cada BR debe generar al menos 1 UC
   - Cada UC debe derivar al menos 1 FR
   - Cada ADR debe referenciar FR que justifica
   - RTM debe cubrir 100% de BR y UC

   MILESTONE: LCA (Lifecycle Architecture)
   Verificar: 80% requisitos capturados, arquitectura estable

3.3 Fase Construction
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ARTEFACTOS CREADOS:
   - DES_xxx (Diseño Detallado)
   - API_xxx (Especificaciones)
   - TEST_xxx (Casos de Prueba)
   - Manuales de Usuario

   TRAZABILIDAD REQUERIDA:
   - Cada FR debe tener al menos 1 DES o implementacion
   - Cada FR debe tener al menos 1 TEST
   - RTM actualizada con estado de implementacion
   - ADR nuevos vinculados a FR afectados

   MILESTONE: IOC (Initial Operational Capability)
   Verificar: Sistema funcional, pruebas ejecutadas

3.4 Fase Transition
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ARTEFACTOS CREADOS:
   - Runbook de Operaciones
   - Guia de Despliegue
   - Evidencia de Pruebas
   - Acta de Cierre

   TRAZABILIDAD REQUERIDA:
   - RTM con estado final de todos los requisitos
   - Evidencia de pruebas vinculada a TEST_xxx
   - Acta referencia cumplimiento de requisitos

   MILESTONE: FOC (Full Operational Capability)
   Verificar: Sistema en produccion, proyecto cerrado

----

4. Matriz de Trazabilidad (RTM)
-------------------------------

4.1 Estructura de la RTM
^^^^^^^^^^^^^^^^^^^^^^^^

La Requirements Traceability Matrix (RTM) es el artefacto central de
trazabilidad:

.. code-block:: text

   ESTRUCTURA RTM:

.. list-table::
   :header-rows: 1

   * - ID_BR
     - ID_UC
     - ID_FR
     - ID_DES
     - ID_TEST
     - Estado
     - Fase
   * - BR_001
     - UC_010
     - FR-10.1
     - DES_010
     - TC_010_1
     - Impl.
     - CONS
   * - BR_001
     - UC_010
     - FR-10.2
     - DES_010
     - TC_010_2
     - Impl.
     - CONS
   * - BR_001
     - UC_011
     - FR-11.1
     - -
     - -
     - Pend.
     - ELAB
   * - BR_002
     - UC_020
     - FR-20.1
     - DES_020
     - TC_020_1
     - Impl.
     - CONS

4.2 Estados de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Estado
     - Significado
     - Fase Tipica
   * - **Identificado**
     - Requisito detectado, sin especificar
     - Inception
   * - **Especificado**
     - Requisito documentado completamente
     - Elaboration
   * - **Diseñado**
     - Solucion tecnica definida
     - Elaboration/Construction
   * - **Implementado**
     - Codigo desarrollado
     - Construction
   * - **Verificado**
     - Pruebas ejecutadas exitosamente
     - Construction
   * - **Desplegado**
     - En ambiente de produccion
     - Transition
   * - **Diferido**
     - Postergado para futuro release
     - Cualquiera
   * - **Cancelado**
     - Eliminado del alcance
     - Cualquiera

4.3 Ubicacion de la RTM
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UBICACION:
   normativa/trazabilidad/RTM_001_Matriz_Requisitos.rst

   FORMATO:
   - Archivo RST con tablas
   - Puede complementarse con CSV/Excel para analisis

   RESPONSABLE:
   - BA Lead (creacion y actualizacion)
   - PMO (aprobacion)
   - QA (verificacion de cobertura)

----

5. Enlaces Obligatorios
-----------------------

5.1 Matriz de Enlaces Requeridos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 20 20 20 20

   * - Desde
     - Hacia
     - Tipo
     - Obligatorio
     - Verificacion
   * - BR_xxx
     - UC_xxx
     - genera
     - SI
     - Cada BR tiene >= 1 UC
   * - UC_xxx
     - BR_xxx
     - originado_por
     - SI
     - Cada UC referencia BR
   * - UC_xxx
     - FR_xxx
     - deriva
     - SI
     - Cada UC tiene >= 1 FR
   * - FR_xxx
     - UC_xxx
     - derivado_de
     - SI
     - Cada FR indica UC origen
   * - FR_xxx
     - DES_xxx
     - implementa
     - SI (*)
     - En fase Construction
   * - FR_xxx
     - TEST_xxx
     - verifica
     - SI (*)
     - En fase Construction
   * - ADR_xxx
     - FR_xxx
     - justifica
     - SI
     - Cada ADR indica FR

(*) Obligatorio a partir de fase Construction

5.2 Formato de Referencias
^^^^^^^^^^^^^^^^^^^^^^^^^^

En artefactos RST, usar referencias cruzadas:

.. code-block:: rst

   REFERENCIA A OTRO ARTEFACTO:

   Este caso de uso deriva de :ref:`br-001`.

   Los requisitos funcionales derivados son:
   - :ref:`fr-10-1`
   - :ref:`fr-10-2`
   - :ref:`fr-10-3`

5.3 Seccion de Trazabilidad en Artefactos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Todo artefacto de requisitos debe incluir seccion de trazabilidad:

**En BR_xxx:**

.. code-block:: rst

   Trazabilidad
   ------------

   **Casos de Uso Generados:**

   - :ref:`uc-010` - Gestionar Usuarios
   - :ref:`uc-011` - Consultar Usuarios

**En UC_xxx:**

.. code-block:: rst

   Trazabilidad
   ------------

   **Reglas de Negocio:**

   - :ref:`br-001` - Separacion de funciones
   - :ref:`br-002` - Auditoria obligatoria

   **Requisitos Funcionales Derivados:**

   - :ref:`fr-10-1` - Validar rol existente
   - :ref:`fr-10-2` - Verificar compatibilidad SoD

**En FR_xxx:**

.. code-block:: rst

   Trazabilidad
   ------------

   **Caso de Uso Origen:** :ref:`uc-010`, Paso 3

   **Diseño:** :ref:`des-api-010`

   **Casos de Prueba:** TC_010_001, TC_010_002

----

6. Verificacion de Trazabilidad
-------------------------------

6.1 Checklist de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VERIFICACION DE TRAZABILIDAD
   ============================

   COBERTURA HACIA ADELANTE (Forward):
   [ ] Cada BR genera al menos 1 UC
   [ ] Cada UC deriva al menos 1 FR
   [ ] Cada FR tiene diseño (en Construction)
   [ ] Cada FR tiene prueba (en Construction)

   COBERTURA HACIA ATRAS (Backward):
   [ ] Cada UC referencia al menos 1 BR
   [ ] Cada FR referencia exactamente 1 UC
   [ ] Cada DES referencia FR que implementa
   [ ] Cada TEST referencia FR que verifica

   CONSISTENCIA:
   [ ] IDs en RTM coinciden con artefactos reales
   [ ] Estados en RTM son correctos
   [ ] No hay artefactos huerfanos (sin enlaces)
   [ ] Referencias :ref: resuelven correctamente

6.2 Metricas de Cobertura
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Metrica
     - Formula
     - Meta
   * - Cobertura BR→UC
     - BR con UC / Total BR
     - 100%
   * - Cobertura UC→FR
     - UC con FR / Total UC
     - 100%
   * - Cobertura FR→DES
     - FR con DES / Total FR
     - >= 95% (Construction)
   * - Cobertura FR→TEST
     - FR con TEST / Total FR
     - >= 95% (Construction)
   * - Artefactos huerfanos
     - Sin enlaces / Total
     - 0%

6.3 Reporte de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REPORTE DE TRAZABILIDAD - [Fecha]
                                    

   ESTADISTICAS:
   - Total BR: N
   - Total UC: N
   - Total FR: N
   - Total DES: N
   - Total TEST: N

   COBERTURA:
   - BR → UC: ___%
   - UC → FR: ___%
   - FR → DES: ___%
   - FR → TEST: ___%

   HALLAZGOS:
   - BR sin UC: [lista]
   - UC sin FR: [lista]
   - FR sin DES: [lista]
   - FR sin TEST: [lista]
   - Artefactos huerfanos: [lista]

   ESTADO POR FASE:
   - Inception: N artefactos
   - Elaboration: N artefactos
   - Construction: N artefactos
   - Transition: N artefactos

----

7. Gestion de Cambios en Trazabilidad
-------------------------------------

7.1 Impacto de Cambios
^^^^^^^^^^^^^^^^^^^^^^

Al modificar un artefacto, evaluar impacto en trazabilidad:

.. code-block:: text

   CAMBIO EN BR:
   → Revisar UC generados (pueden requerir actualizacion)
   → Revisar FR derivados (impacto en cascada)
   → Actualizar RTM

   CAMBIO EN UC:
   → Revisar BR origen (sigue siendo consistente?)
   → Revisar FR derivados (pueden requerir cambios)
   → Actualizar RTM

   CAMBIO EN FR:
   → Revisar UC origen
   → Revisar DES que implementa
   → Revisar TEST que verifica
   → Actualizar RTM

   ELIMINACION DE ARTEFACTO:
   → Eliminar de RTM
   → Actualizar referencias en otros artefactos
   → Verificar que no queden enlaces rotos

7.2 Proceso de Actualizacion RTM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CUANDO ACTUALIZAR RTM:

   - Al crear nuevo BR, UC o FR
   - Al modificar alcance de requisito
   - Al cambiar estado de implementacion
   - Al agregar/modificar DES o TEST
   - Al cancelar o diferir requisito
   - En cada milestone SDLC

   QUIEN ACTUALIZA:

   - BA Lead: Cambios en BR, UC, FR
   - Tech Lead: Cambios en DES
   - QA Lead: Cambios en TEST
   - PMO: Validacion y aprobacion

----

8. Trazabilidad en Milestones
-----------------------------

8.1 Verificacion por Milestone
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**LCO (Lifecycle Objectives):**

.. code-block:: text

   VERIFICAR:
   [ ] META_01 aprobado
   [ ] BR iniciales identificados
   [ ] UC iniciales listados
   [ ] Alcance documentado

**LCA (Lifecycle Architecture):**

.. code-block:: text

   VERIFICAR:
   [ ] RTM creada y actualizada
   [ ] 100% BR especificados
   [ ] >= 80% UC especificados
   [ ] >= 80% FR derivados
   [ ] Cobertura BR→UC = 100%
   [ ] ADR iniciales con referencias

**IOC (Initial Operational Capability):**

.. code-block:: text

   VERIFICAR:
   [ ] 100% FR especificados
   [ ] >= 95% FR con DES
   [ ] >= 95% FR con TEST
   [ ] RTM refleja estado de implementacion
   [ ] Pruebas ejecutadas y documentadas

**FOC (Full Operational Capability):**

.. code-block:: text

   VERIFICAR:
   [ ] RTM completa y cerrada
   [ ] 100% FR implementados o justificadamente diferidos
   [ ] 100% TEST ejecutados
   [ ] Evidencia de pruebas vinculada
   [ ] Acta de cierre referencia cumplimiento

----

9. Herramientas de Trazabilidad
-------------------------------

9.1 Referencias RST
^^^^^^^^^^^^^^^^^^^

.. code-block:: rst

   # Definir etiqueta en artefacto origen
   .. _br-001:

   BR_001: Separacion de Funciones
   ===============================

   # Referenciar desde otro artefacto
   Este caso de uso implementa :ref:`br-001`.

9.2 Verificacion Automatica
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Verificar enlaces con Sphinx
   sphinx-build -b linkcheck source/ build/

   # Buscar referencias huerfanas
   grep -r ":ref:" source/ | grep -v "^#"

9.3 Generacion de RTM
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PROCESO MANUAL:
   1. Listar todos los BR
   2. Para cada BR, identificar UC generados
   3. Para cada UC, identificar FR derivados
   4. Completar columnas de DES y TEST
   5. Asignar estado a cada fila

   PROCESO ASISTIDO:
   - Extraer IDs de artefactos con script
   - Extraer referencias :ref: con script
   - Generar matriz base
   - Completar manualmente estados

----

10. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`meta_03_fases_sdlc` - Fases del Ciclo de Vida
- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-03` - Control de Calidad Documental
- :ref:`gob-10` - Auditoria Documental

Fuentes Externas
^^^^^^^^^^^^^^^^

- IEEE 830 - Especificacion de Requisitos de Software
- Rational Unified Process (RUP)

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
     - 2025-12-22
     - Equipo IACT
     - Version inicial. Modelo de trazabilidad. Cadena BR→UC→FR→DES→TEST. RTM. Enlaces obligatorios. Verificacion por milestone.

----

**Trazabilidad:** Este artefacto define las reglas de trazabilidad aplicables
a todos los artefactos de requisitos del sistema IACT. Es verificado en cada
milestone SDLC segun :ref:`meta_03_fases_sdlc` y auditado segun :ref:`gob-10`.