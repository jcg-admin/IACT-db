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
