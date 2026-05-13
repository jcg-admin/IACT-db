
----

7. Trazabilidad por Nivel en IACT
---------------------------------

7.1 Nivel 0→1: BR → BReq (Influencia)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR                              BReq
   ────────────────────────────────────────────────────────────
   BR_001 (Fuente Inmutable)   --> BReq-005 (Integridad Datos)
   BR_002 (ETL Nocturno)       --> BReq-001 (Visibilidad)
   BR_006 (RBAC Flat)          --> BReq-004 (Cumplimiento)
   BR_007 (SoD)                --> BReq-004 (Cumplimiento)
   BR_010 (Auditoria Inmutable)--> BReq-004 (Cumplimiento)
   BR_014 (Alerta Umbral)      --> BReq-002 (Reduccion Incidentes)

7.2 Nivel 1→2: BReq → UC (Generacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq                         UC Generados
   ────────────────────────────────────────────────────────────
   BReq-001 (Visibilidad)   --> UC-025 a UC-030 (Dashboard)
   BReq-002 (Red. Incid.)   --> UC-036 a UC-040 (Alertas)
   BReq-003 (Decisiones)    --> UC-017 a UC-024 (Reportes)
   BReq-004 (Cumplimiento)  --> UC-010, UC-043-047, UC-060-063
   BReq-005 (Integridad)    --> UC-050 a UC-053 (Pipeline)

7.3 Nivel 2→3: UC → FR (Derivacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ejemplo detallado para UC-043:

.. code-block:: text

   UC-043: Configurar SoD
   
   Flujo Normal:
   1. Admin Seguridad selecciona "Gestionar SoD"
   2. Sistema muestra lista de restricciones actuales    --> FR-043.1
   3. Admin selecciona "Crear nueva restriccion"
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

7.4 Nivel 3→4: FR → CODE (Implementacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR                    Implementacion
   ────────────────────────────────────────────────────────────
   FR-043.1          --> apps/access/views/sod_views.py::list_sod()
   FR-043.2          --> apps/access/validators/sod_validator.py
   FR-043.3          --> apps/access/middleware/sod_enforcement.py
   FR-043.4          --> apps/audit/signals/sod_audit.py
   FR-043.5          --> apps/alerts/notifications/sod_notify.py

7.5 Nivel 3→5: FR → TEST (Verificacion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FR                    Tests
   ────────────────────────────────────────────────────────────
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

El **Analisis de Impacto** utiliza la trazabilidad para determinar que
artefactos se ven afectados por un cambio propuesto.

8.2 Proceso
^^^^^^^^^^^

.. code-block:: text

   CAMBIO PROPUESTO: Modificar BR_007 (agregar nueva restriccion SoD)

   PASO 1: Identificar derivados directos
   ┌─────────────────────────────────────────┐
   │ BR_007 --> BReq-004 --> UC-043         │
   │                     --> UC-044         │
   │                     --> UC-047         │
   └─────────────────────────────────────────┘

   PASO 2: Propagar a siguientes niveles
   ┌─────────────────────────────────────────┐
   │ UC-043 --> FR-043.1 a FR-043.5         │
   │ UC-044 --> FR-044.1 a FR-044.3         │
   │ UC-047 --> FR-047.1 a FR-047.4         │
   └─────────────────────────────────────────┘

   PASO 3: Identificar codigo afectado
   ┌─────────────────────────────────────────┐
   │ apps/access/sod.py                     │
   │ apps/access/validators/                │
   │ apps/access/middleware/                │
   └─────────────────────────────────────────┘

   PASO 4: Identificar tests a actualizar
   ┌─────────────────────────────────────────┐
   │ tests/access/test_sod_*.py             │
   │ tests/integration/test_sod_flow.py     │
   └─────────────────────────────────────────┘

   RESULTADO: 3 UC, ~12 FR, 3 modulos, ~10 tests afectados

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-02` - Reglas de Negocio
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-06` - Derivacion vs Transformacion
- :ref:`fnd-07` - Requerimientos Funcionales

Artefactos de Trazabilidad IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- evidencia/trazabilidad/RTM_Master_v1_0_0.rst
- evidencia/trazabilidad/COV_001_Reporte_Cobertura.rst

Fuentes Externas
^^^^^^^^^^^^^^^^

- IEEE 830-1998: Recommended Practice for Software Requirements Specifications
- CMMI for Development: Requirements Management Process Area
- Karl Wiegers: "Software Requirements" (3rd Edition)

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
     - 2026-01-03
     - Equipo IACT
     - Version inicial. Creacion completa del documento (reemplazo de archivo corrupto que contenia copia de FND_03)

----

**Trazabilidad:** Este artefacto define el concepto de Trazabilidad que es
fundamental para mantener la integridad del modelo de requisitos. Referenciado
por FND_05, FND_06 y todos los artefactos en evidencia/trazabilidad/.
