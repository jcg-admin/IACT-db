.. meta::
   :artefacto: FND_04
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-04:

====================
FND_04: Trazabilidad
====================


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

Definicion operativa para IACT:

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
   * - Forward (Adelante)
     - Origen a Derivado
     - Verificar que todo requisito se implementa
   * - Backward (Atras)
     - Derivado a Origen
     - Verificar que todo codigo tiene justificacion
   * - Bidireccional
     - Ambas direcciones
     - Analisis de impacto completo

1.3 Beneficios de la Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   BENEFICIO                    DESCRIPCION
                                           
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
   * - influye
     - BR
     - BReq
     - BR afecta objetivo sin generar directamente
   * - genera
     - BReq
     - UC
     - Objetivo de negocio genera casos de uso
   * - genera
     - BR (Trigger)
     - UC
     - BR tipo Desencadenador genera UC especifico
   * - deriva
     - UC
     - FR
     - Cada paso Sistema del UC deriva FR
   * - implementa
     - FR
     - CODE
     - FR se codifica en modulo/funcion
   * - verifica
     - TEST
     - FR
     - Test valida cumplimiento de FR
   * - satisface
     - UC
     - BReq
     - UC cumple parcialmente objetivo de negocio

2.2 Cardinalidad de Enlaces
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   ENLACE                  CARDINALIDAD       EJEMPLO
                                                     
   BR --influye--> BReq    0..* : 0..*        Varias BR influyen en varios BReq
   BReq --genera--> UC     1 : 1..*           1 BReq genera multiples UC
   BR(Trigger) --genera--> UC  0..1 : 0..1   1 BR Trigger genera maximo 1 UC
   UC --deriva--> FR       1 : 1..*           1 UC deriva multiples FR (ratio 1:8)
   FR --implementa--> CODE 1 : 0..*           1 FR puede tener 0+ implementaciones
   TEST --verifica--> FR   1..* : 1           Multiples tests verifican 1 FR

2.3 Diagrama de Enlaces
^^^^^^^^^^^^^^^^^^^^^^^

::

   JERARQUIA DE DERIVACION (Vertical):

   +-------------+
   |    BR       | Nivel 0 - Business Rules
   +------+------+
          | influye
          v
   +-------------+
   |   BReq      | Nivel 1 - Business Requirements
   +------+------+
          | genera
          v
   +-------------+
   |    UC       | Nivel 2 - Use Cases
   +------+------+
          | deriva
          v
   +-------------+
   |    FR       | Nivel 3 - Functional Requirements
   +------+------+
          | implementa
          v
   +-------------+
   |   CODE      | Nivel 4 - Codigo Fuente
   +------+------+
          |
          v
   +-------------+
   |   TEST      | Nivel 5 - Pruebas (verifica FR)
   +-------------+

----

3. Matriz RTM (Requirements Traceability Matrix)
------------------------------------------------

3.1 Definicion
^^^^^^^^^^^^^^

La Matriz de Trazabilidad de Requisitos (RTM) es el artefacto central
que documenta todos los enlaces entre requisitos y sus derivados.

3.2 Estructura de la RTM
^^^^^^^^^^^^^^^^^^^^^^^^

::

   RTM IACT - Estructura de Columnas:

.. list-table::
   :header-rows: 1

   * - ID_BR
     - ID_BReq
     - ID_UC
     - ID_FR
     - ID_CODE
     - ID_TEST
     - Estado
   * - BR_001
     - BReq-005
     - UC-050
     - FR-050.1
     - pipeline/etl.py
     - TST_PIP_001
     - OK
   * - BR_002
     - BReq-001
     - UC-050
     - FR-050.2
     - pipeline/jobs.py
     - TST_PIP_002
     - OK
   * - ...
     - ...
     - ...
     - ...
     - ...
     - ...
     - ...

3.3 Ubicacion en IACT
^^^^^^^^^^^^^^^^^^^^^

::

   IACT/
   +-- evidencia/
       +-- trazabilidad/
           +-- index.rst
           +-- RTM_Master_v1_0_0.rst      <- Matriz principal
           +-- COV_001_Reporte_Cobertura.rst  <- Metricas

3.4 Ejemplo de Cadena Completa
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   CADENA: BR_007 (SoD) -> UC-043 -> FR-043.x

   BR_007: Separacion de Funciones SoD
     |
     | influye
     v
   BReq-004: Cumplimiento de Seguridad
     |
     | genera
     v
   UC-043: Configurar SoD
     |
     | deriva
     +---> FR-043.1: Sistema DEBE mostrar lista de restricciones SoD
     +---> FR-043.2: Sistema DEBE validar conflictos al crear SoD
     +---> FR-043.3: Sistema DEBE impedir asignacion que viole SoD
     +---> FR-043.4: Sistema DEBE registrar en auditoria cambios SoD
     +---> FR-043.5: Sistema DEBE notificar al admin de seguridad
           |
           | implementa
           v
         apps/access/sod.py
           |
           | verifica
           v
         TST_Access_SoD_001 a TST_Access_SoD_005

----

4. Metricas de Cobertura
------------------------

4.1 Definicion de Metricas
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 15 60

   * - Metrica
     - Umbral
     - Formula
   * - Cobertura BReq a UC
     - 100%
     - (BReq con UC derivados / Total BReq) x 100
   * - Cobertura BR a UC
     - 100%
     - (BR con impacto en UC / Total BR aplicables) x 100
   * - Cobertura UC a FR
     - 100%
     - (UC con FR derivados / Total UC) x 100
   * - Cobertura FR a CODE
     - 90%
     - (FR implementados / Total FR) x 100
   * - Cobertura FR a TEST
     - 80%
     - (FR con tests / Total FR) x 100

4.2 Estado Actual IACT
^^^^^^^^^^^^^^^^^^^^^^

::

   METRICA                 VALOR      ESTADO
                                            
   BReq identificados        5        Completo
   BR identificadas         20        Completo
   UC identificados         49        Completo
   FR derivados              0        Pendiente

   Cobertura BReq a UC     100%       Verificado
   Cobertura BR a UC         -        Pendiente RTM
   Cobertura UC a FR        0%        Pendiente derivar
   Cobertura FR a CODE      0%        Pendiente implementar
   Cobertura FR a TEST      0%        Pendiente

4.3 Interpretacion de Metricas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   COBERTURA 100%:
     Todos los artefactos origen tienen al menos un derivado.
     NO significa que esten completos, solo que tienen enlace.

   COBERTURA < 100%:
     Existen artefactos sin derivados documentados.
     Requiere accion: derivar o justificar exclusion.

   COBERTURA > 100%:
     Error de calculo o artefactos duplicados.
     Requiere revision de la RTM.

----

5. Herramientas de Trazabilidad en IACT
---------------------------------------

5.1 Sphinx Cross-References
^^^^^^^^^^^^^^^^^^^^^^^^^^^

IACT utiliza el sistema de referencias cruzadas de Sphinx para mantener
trazabilidad dentro de la documentacion.

::

   En BR_007_Separacion_Funciones_SoD.rst:

   .. _br-007:

   Trazabilidad
   ------------
   - Influye en: :ref:`breq-004`
   - UC Relacionados: :ref:`uc-043`
   - FR Derivados: FR-043.1 a FR-043.5


   En UC_043_Configurar_SoD.rst:

   .. _uc-043:

   Trazabilidad
   ------------
   - Origen BR: :ref:`br-007`
   - BReq: :ref:`breq-004`
   - FR Derivados: FR-043.1 a FR-043.5

5.2 Etiquetas de Metadata
^^^^^^^^^^^^^^^^^^^^^^^^^

Cada artefacto incluye metadata que facilita trazabilidad:

::

   .. meta::
      :artefacto: UC_043
      :origen_br: BR_007
      :origen_breq: BReq-004
      :fr_derivados: FR-043.1, FR-043.2, FR-043.3, FR-043.4, FR-043.5
      :modulo: MOD_Access

5.3 Seccion de Trazabilidad Estandar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Todo artefacto de requisitos DEBE incluir una seccion de trazabilidad:

::

   ----

   Trazabilidad
   ------------

   Origen
   ^^^^^^
   - Business Rule: BR_007 (Separacion de Funciones SoD)
   - Business Requirement: BReq-004 (Cumplimiento Seguridad)

   Derivados
   ^^^^^^^^^
   - FR-043.1: Mostrar lista restricciones SoD
   - FR-043.2: Validar conflictos
   - FR-043.3: Impedir asignacion violatoria
   - FR-043.4: Registrar en auditoria
   - FR-043.5: Notificar admin seguridad

   Implementacion
   ^^^^^^^^^^^^^^
   - Modulo: MOD_Access
   - Codigo: apps/access/sod.py
   - Tests: TST_Access_SoD_*

----

6. Proceso de Mantenimiento de Trazabilidad
-------------------------------------------

6.1 Al Crear Nuevo Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   1. Identificar ORIGEN (de donde viene)
   2. Documentar enlace en seccion Trazabilidad
   3. Actualizar artefacto origen con nuevo derivado
   4. Actualizar RTM_Master
   5. Verificar metricas de cobertura

6.2 Al Modificar Artefacto Existente
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   1. Ejecutar analisis de impacto (que depende de este)
   2. Revisar todos los derivados
   3. Propagar cambios necesarios
   4. Actualizar fechas y versiones
   5. Documentar cambio en historial

6.3 Al Eliminar Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^

::

   1. Verificar que no tiene derivados activos
   2. Si tiene derivados, reasignarlos o eliminarlos
   3. Actualizar artefactos origen (remover referencia)
   4. Marcar como obsoleto en RTM (no borrar)
   5. Documentar razon de eliminacion

----

7. Trazabilidad por Nivel en IACT
---------------------------------

7.1 Nivel 0 a 1: BR a BReq (Influencia)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   BR                              BReq
                                       
   BR_001 (Fuente Inmutable)   --> BReq-005 (Integridad Datos)
   BR_002 (ETL Nocturno)       --> BReq-001 (Visibilidad)
   BR_006 (RBAC Flat)          --> BReq-004 (Cumplimiento)
   BR_007 (SoD)                --> BReq-004 (Cumplimiento)
   BR_010 (Auditoria Inmutable)--> BReq-004 (Cumplimiento)
   BR_014 (Alerta Umbral)      --> BReq-002 (Reduccion Incidentes)

7.2 Nivel 1 a 2: BReq a UC (Generacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   BReq                         UC Generados
                                            
   BReq-001 (Visibilidad)   --> UC-025 a UC-030 (Dashboard)
   BReq-002 (Red. Incid.)   --> UC-036 a UC-040 (Alertas)
   BReq-003 (Decisiones)    --> UC-017 a UC-024 (Reportes)
   BReq-004 (Cumplimiento)  --> UC-010, UC-043-047, UC-060-063
   BReq-005 (Integridad)    --> UC-050 a UC-053 (Pipeline)

7.3 Nivel 2 a 3: UC a FR (Derivacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ejemplo detallado para UC-043:

::

   UC-043: Configurar SoD

   Flujo Normal:
   1. Admin Seguridad selecciona Gestionar SoD
   2. Sistema muestra lista de restricciones actuales    --> FR-043.1
   3. Admin selecciona Crear nueva restriccion
   4. Sistema muestra formulario de configuracion
   5. Admin define Grupo A y Grupo B de funciones
   6. Sistema valida que no hay conflictos existentes    --> FR-043.2
   7. Sistema guarda restriccion SoD
   8. Sistema registra en auditoria                      --> FR-043.4
   9. Sistema notifica a administradores                 --> FR-043.5

   Excepcion 6a: Conflicto detectado
   6a.1. Sistema muestra usuarios afectados
   6a.2. Sistema impide guardar hasta resolver           --> FR-043.3
   6a.3. Retorna a paso 5

   FR Derivados:
   - FR-043.1: Sistema DEBE mostrar lista de restricciones SoD
   - FR-043.2: Sistema DEBE validar conflictos al crear SoD
   - FR-043.3: Sistema DEBE impedir asignacion que viole SoD
   - FR-043.4: Sistema DEBE registrar en auditoria cambios SoD
   - FR-043.5: Sistema DEBE notificar al admin de seguridad

7.4 Nivel 3 a 4: FR a CODE (Implementacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   FR                    Implementacion
                                       
   FR-043.1          --> apps/access/views/sod_views.py::list_sod()
   FR-043.2          --> apps/access/validators/sod_validator.py
   FR-043.3          --> apps/access/middleware/sod_enforcement.py
   FR-043.4          --> apps/audit/signals/sod_audit.py
   FR-043.5          --> apps/alerts/notifications/sod_notify.py

7.5 Nivel 3 a 5: FR a TEST (Verificacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   FR                    Tests
                              
   FR-043.1          --> tests/access/test_sod_list.py
   FR-043.2          --> tests/access/test_sod_validation.py
   FR-043.3          --> tests/access/test_sod_enforcement.py
   FR-043.4          --> tests/audit/test_sod_audit_log.py
   FR-043.5          --> tests/alerts/test_sod_notifications.py

----

8. Analisis de Impacto
----------------------

8.1 Definicion
^^^^^^^^^^^^^^

El Analisis de Impacto utiliza la trazabilidad para determinar que
artefactos se ven afectados por un cambio propuesto.

8.2 Proceso
^^^^^^^^^^^

::

   CAMBIO PROPUESTO: Modificar BR_007 (agregar nueva restriccion SoD)

   PASO 1: Identificar derivados directos
   +------------------------------------------+
   | BR_007 --> BReq-004 --> UC-043           |
   |                     --> UC-044           |
   |                     --> UC-047           |
   +------------------------------------------+

   PASO 2: Propagar a siguientes niveles
   +------------------------------------------+
   | UC-043 --> FR-043.1 a FR-043.5           |
   | UC-044 --> FR-044.1 a FR-044.3           |
   | UC-047 --> FR-047.1 a FR-047.4           |
   +------------------------------------------+

   PASO 3: Identificar codigo afectado
   +------------------------------------------+
   | apps/access/sod.py                       |
   | apps/access/validators/                  |
   | apps/access/middleware/                  |
   +------------------------------------------+

   PASO 4: Identificar tests a actualizar
   +------------------------------------------+
   | tests/access/test_sod_*.py               |
   | tests/integration/test_sod_flow.py       |
   +------------------------------------------+

   RESULTADO: 3 UC, 12 FR aprox, 3 modulos, 10 tests afectados

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- FND_01 - Concepto de Requisito
- FND_02 - Reglas de Negocio
- FND_03 - Casos de Uso
- FND_05 - Jerarquia de 4 Niveles
- FND_06 - Derivacion vs Transformacion
- FND_07 - Requerimientos Funcionales

Artefactos de Trazabilidad IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- evidencia/trazabilidad/RTM_Master_v1_0_0.rst
- evidencia/trazabilidad/COV_001_Reporte_Cobertura.rst

Fuentes Externas
^^^^^^^^^^^^^^^^

- IEEE 830-1998: Recommended Practice for Software Requirements Specifications
- CMMI for Development: Requirements Management Process Area
- Karl Wiegers: Software Requirements (3rd Edition)

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
     - 2026-01-04
     - Equipo IACT
     - Version inicial. Documento creado desde cero reemplazando archivo corrupto que contenia copia de FND_03.

----

Trazabilidad: Este artefacto define el concepto de Trazabilidad que es
fundamental para mantener la integridad del modelo de requisitos. Referenciado
por FND_05, FND_06 y todos los artefactos en evidencia/trazabilidad/.
