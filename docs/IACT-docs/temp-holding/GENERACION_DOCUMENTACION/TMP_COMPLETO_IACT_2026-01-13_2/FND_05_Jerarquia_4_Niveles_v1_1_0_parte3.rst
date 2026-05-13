
----

7. Gradiente de Abstraccion
---------------------------

7.1 Estabilidad vs Cambio
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   MAS ESTABLE ◄────────────────────────────────► MAS CAMBIANTE

   BR ─────────► BReq ─────────► UC ─────────► FR
   (Decadas)    (Anos)          (Meses)       (Semanas)

   Ejemplo:
   - BR_007 (SoD): Existe desde creacion de la empresa
   - BReq-004: Definido al inicio del proyecto
   - UC-043: Puede cambiar con nuevos requisitos
   - FR-043.1: Cambia con cada iteracion

7.2 Abstraccion vs Detalle
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   MAS ABSTRACTO ◄──────────────────────────────► MAS DETALLADO

   BR ─────────► BReq ─────────► UC ─────────► FR
   (Vision)     (Objetivo)     (Historia)    (Especificacion)

   Ejemplo:
   - BR_007: "Las funciones criticas deben estar segregadas"
   - BReq-004: "El sistema debe garantizar cumplimiento de seguridad"
   - UC-043: "Admin configura restriccion SoD con grupos A y B"
   - FR-043.1: "Sistema DEBE mostrar lista con columnas: ID, Nombre,
                Grupo A, Grupo B, Estado, Fecha Creacion"

7.3 Responsabilidad de Creacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 30 55

   * - Nivel
     - Responsable
     - Actividad
   * - BR
     - Stakeholders, Legal
     - Identificar y documentar reglas existentes
   * - BReq
     - Product Owner
     - Definir objetivos medibles del proyecto
   * - UC
     - Business Analyst
     - Describir interacciones usuario-sistema
   * - FR
     - BA + Arquitecto
     - Especificar comportamientos atomicos

----

8. Arbol de Estructura IACT
---------------------------

8.1 Ubicacion de Cada Nivel
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   IACT/
   │
   └── requisitos/
       │
       ├── objetivos/                    ← NIVEL 1: BReq
       │   ├── index.rst
       │   └── BReq_001_Objetivos_IACT.rst
       │
       ├── reglas_negocio/               ← NIVEL 0: BR
       │   ├── index.rst
       │   ├── BR_001_Fuente_Inmutable.rst
       │   ├── BR_002_ETL_Batch_Nocturno.rst
       │   └── ... (20 BR total)
       │
       ├── casos_uso/                    ← NIVEL 2: UC
       │   ├── index.rst
       │   ├── auth/
       │   │   ├── UC_001_Inicio_Sesion.rst
       │   │   └── ...
       │   ├── users/
       │   ├── access/
       │   ├── pipeline/
       │   ├── reports/
       │   ├── alerts/
       │   ├── audit/
       │   └── logs/
       │
       ├── funcionales/                  ← NIVEL 3: FR
       │   ├── index.rst
       │   ├── auth/
       │   │   └── FR_UC001_Inicio_Sesion.rst
       │   └── ... (por modulo)
       │
       └── no_funcionales/               ← NFR (paralelo a FR)
           ├── index.rst
           └── NFR_001_Rendimiento.rst

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-02` - Reglas de Negocio
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-04` - Trazabilidad
- :ref:`fnd-06` - Derivacion vs Transformacion
- :ref:`fnd-07` - Requerimientos Funcionales

Modelos IACT
^^^^^^^^^^^^

- MODELO_DOCUMENTAL_IACT_v2.0.6 - Estructura documental
- MODELO_RBAC_IACT_v5.1.1 - Modelo de control de acceso

Fuentes Externas
^^^^^^^^^^^^^^^^

- Karl Wiegers: "Software Requirements" (3rd Edition)
- IEEE 830-1998: Software Requirements Specifications
- BABOK Guide v3: Business Analysis Body of Knowledge

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
   * - 1.1.0
     - 2026-01-03
     - Equipo IACT
     - **ACTUALIZACION:** Documentada implementacion completa de 4 niveles en IACT. Agregada seccion 1.3 con decision arquitectonica. Clarificacion META_04 vs BReq. Agregados BReq identificados. Actualizada cantidad UC de 38 a 49. Agregado arbol de estructura completo.
   * - 1.0.0
     - 2025-12-19
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:** Este artefacto define la jerarquia de 4 niveles que es
el marco conceptual de todo el modelo de requisitos IACT. Referenciado por
FND_01 a FND_07 y MODELO_DOCUMENTAL_IACT.
