
----

4. Nivel 2: User Requirements / Use Cases (UC)
----------------------------------------------

4.1 Definicion
^^^^^^^^^^^^^^

Los **User Requirements** describen comportamientos del sistema desde la
perspectiva del usuario. Se expresan tipicamente como **Casos de Uso** que
especifican interacciones completas entre actores y sistema.

4.2 Caracteristicas
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Narrativos**
     - Cuentan una historia de interaccion
   * - **Observables**
     - Describen lo que el usuario VE
   * - **Completos**
     - Flujo de principio a fin
   * - **Sin implementacion**
     - NO especifican el COMO interno

4.3 Relacion con BR y BReq
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FUENTES DE UC:

   1. BReq genera UC:
      BReq-002 (Reduccion Incidentes) --genera--> UC-036 a UC-040 (Alertas)

   2. BR tipo Trigger genera UC:
      BR_002 (ETL Nocturno) --genera--> UC-050 (Supervisar ETL)

   3. BR tipo Restriccion influye en UC:
      BR_007 (SoD) --influye--> UC-043 (Configurar SoD)

4.4 UC en IACT (v1.1.0)
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   MODULO          CANTIDAD    RANGO UC
   ─────────────────────────────────────────────────────────
   MOD_Auth            5       UC-001 a UC-005
   MOD_Users           4       UC-006 a UC-009
   MOD_Access          9       UC-010, UC-011, UC-041 a UC-047
   MOD_Pipeline        4       UC-050 a UC-053
   MOD_Reports        14       UC-017 a UC-030
   MOD_Alerts          5       UC-036 a UC-040
   MOD_Audit           4       UC-060 a UC-063
   MOD_Logs            3       UC-070 a UC-072
   ─────────────────────────────────────────────────────────
   TOTAL              49

4.5 Ubicacion en IACT
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   IACT/
   └── requisitos/
       └── casos_uso/                    ← Nivel 2 (UC)
           ├── index.rst
           ├── auth/
           │   └── UC_001_Inicio_Sesion.rst
           ├── users/
           ├── access/
           ├── pipeline/
           ├── reports/
           ├── alerts/
           ├── audit/
           └── logs/

----

5. Nivel 3: Functional Requirements (FR)
----------------------------------------

5.1 Definicion
^^^^^^^^^^^^^^

Los **Functional Requirements** son especificaciones atomicas de
comportamiento del sistema. Cada FR describe una capacidad especifica
que el sistema DEBE proporcionar.

5.2 Caracteristicas
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Atomicos**
     - Una sola capacidad por FR
   * - **Verificables**
     - Se puede probar SI/NO cumple
   * - **Implementables**
     - Traducibles directamente a codigo
   * - **Independientes**
     - No dependen del orden de otros FR

5.3 Derivacion desde UC
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-043: Configurar SoD

   Flujo Normal:
   2. Sistema muestra lista de restricciones --> FR-043.1
   6. Sistema valida conflictos             --> FR-043.2
   7. Sistema impide asignacion violatoria  --> FR-043.3
   8. Sistema registra en auditoria         --> FR-043.4
   9. Sistema notifica administradores      --> FR-043.5

   Regla: Cada paso que dice "Sistema [verbo]" genera un FR

5.4 Criterios SMART (ver FND_07)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Todo FR debe cumplir:

- **S**pecific: Claro y sin ambiguedad
- **M**easurable: Verificable objetivamente
- **A**chievable: Tecnica y economicamente viable
- **R**elevant: Alineado con objetivos del proyecto
- **T**ime-bound: Con criterio de completitud

5.5 FR en IACT
^^^^^^^^^^^^^^

.. code-block:: text

   Estimacion basada en ratio 1 UC : 8 FR

   49 UC × 8 FR/UC = ~400 FR esperados

   Distribucion por modulo:
   - MOD_Auth:      5 UC × 8 = ~40 FR
   - MOD_Users:     4 UC × 8 = ~32 FR
   - MOD_Access:    9 UC × 8 = ~72 FR
   - MOD_Pipeline:  4 UC × 8 = ~32 FR
   - MOD_Reports:  14 UC × 8 = ~112 FR
   - MOD_Alerts:    5 UC × 8 = ~40 FR
   - MOD_Audit:     4 UC × 8 = ~32 FR
   - MOD_Logs:      3 UC × 8 = ~24 FR

5.6 Ubicacion en IACT
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   IACT/
   └── requisitos/
       └── funcionales/                  ← Nivel 3 (FR)
           ├── index.rst
           ├── auth/
           │   └── FR_UC001_Inicio_Sesion.rst
           ├── users/
           ├── access/
           ├── pipeline/
           ├── reports/
           ├── alerts/
           ├── audit/
           └── logs/

----

6. Flujo de Influencia entre Niveles
------------------------------------

6.1 Diagrama Completo
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   NIVEL 0                NIVEL 1              NIVEL 2           NIVEL 3
   ┌─────────┐           ┌─────────┐          ┌─────────┐       ┌─────────┐
   │   BR    │──influye──►│  BReq   │──genera──►│   UC    │─deriva─►│   FR    │
   │ (20)    │           │  (5)    │          │  (49)   │       │ (~400)  │
   └────┬────┘           └─────────┘          └─────────┘       └─────────┘
        │
        │ genera (si Trigger)
        │
        └───────────────────────────────────────►│   UC    │
                                                 └─────────┘

6.2 Tipos de Relaciones
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 20 20 40

   * - Relacion
     - Origen
     - Destino
     - Semantica
   * - **influye**
     - BR
     - BReq
     - BR afecta objetivo sin generar
   * - **genera**
     - BReq
     - UC
     - Objetivo genera casos de uso
   * - **genera**
     - BR (Trigger)
     - UC
     - BR Desencadenador genera UC
   * - **deriva**
     - UC
     - FR
     - Pasos del UC generan FR

6.3 Ratios Tipicos
^^^^^^^^^^^^^^^^^^

.. code-block:: text

   NIVEL        CANTIDAD TIPICA    RATIO
   ─────────────────────────────────────────────
   BR              5-20            --
   BReq            3-10            1 BR : 0.5 BReq
   UC             30-100           1 BReq : 10 UC
   FR            200-1000          1 UC : 8 FR

   IACT:
   BR = 20, BReq = 5, UC = 49, FR = ~400
   Ratios: BR:BReq = 4:1, BReq:UC = 1:10, UC:FR = 1:8
