.. meta::
   :artefacto: FND_05
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2026-01-04
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
     - Por que esta restriccion?
     - Origen de las politicas y regulaciones
   * - Nivel 1 (BReq)
     - Por que este proyecto?
     - Justificacion y objetivos del proyecto
   * - Nivel 2 (UC)
     - Que hace el usuario?
     - Comportamientos observables del sistema
   * - Nivel 3 (FR)
     - Como lo hace el sistema?
     - Especificaciones atomicas implementables

1.3 Implementacion en IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^

IACT implementa los 4 niveles completos de la jerarquia:

::

   Nivel 0 (BR):   requisitos/reglas_negocio/   -> 20 BR
   Nivel 1 (BReq): requisitos/objetivos/        -> 5 BReq
   Nivel 2 (UC):   requisitos/casos_uso/        -> 49 UC
   Nivel 3 (FR):   requisitos/funcionales/      -> ~400 FR (estimado)

**Clarificacion sobre META_04:**

El archivo META_04_Contexto_IACT.rst contiene informacion de contexto
del proyecto (ambiente, stakeholders, sistemas existentes). Esto NO ES
lo mismo que Business Requirements (BReq).

::

   META_04 = Contexto (descripcion del ambiente)
   BReq    = Objetivos de negocio medibles

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
   * - Externas
     - Provienen de fuera del sistema (politicas, regulaciones)
   * - Obligatorias
     - No son opcionales ni negociables
   * - Estables
     - Cambian menos frecuentemente que otros requisitos
   * - Influyentes
     - Afectan multiples partes del sistema

2.3 Fuentes
^^^^^^^^^^^

::

   FUENTES EXTERNAS (Obligatorias):
   +------------------+
   | Leyes            |
   | Regulaciones     |
   | Estandares       |
   | Contratos        |
   +------------------+
           |
           v
   +------------------+
   |     SISTEMA      |  <-- El sistema CUMPLE las reglas
   +------------------+      El sistema NO CREA las reglas
           ^
           |
   +------------------+
   | Politicas        |
   | Procedimientos   |
   | Mejores Practicas|
   +------------------+
   FUENTES INTERNAS (Organizacionales)

2.4 Tipos de BR (Taxonomia)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   TIPO              PATRON                       GENERA UC?
   ------------------------------------------------------------------
   Hecho             [X] ES/TIENE [Y]             NO
   Restriccion       [X] DEBE/NO DEBE [Y]         Parcial
   Desencadenador    SI [cond] ENTONCES [vis]     SI
   Inferencia        SI [cond] ENTONCES [int]     NO
   Calculo           [Resultado] = [formula]      NO

2.5 BR en IACT
^^^^^^^^^^^^^^

::

   TIPO              CANTIDAD    EJEMPLO
   ------------------------------------------------------------------
   Hecho                 4       BR_006: RBAC Flat NIST
   Restriccion           9       BR_007: Separacion de Funciones
   Desencadenador        3       BR_002: ETL Batch Nocturno
   Inferencia            1       BR_003: Usuario Inactivo 90d
   Calculo               3       BR_016: Tasa Abandono
   ------------------------------------------------------------------
   TOTAL                20

----

3. Nivel 1: Business Requirements (BReq)
----------------------------------------

3.1 Definicion
^^^^^^^^^^^^^^

Los **Business Requirements** expresan los objetivos de alto nivel que
justifican la existencia del proyecto. Responden: Por que estamos
construyendo este sistema?

3.2 Caracteristicas
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - Estrategicos
     - Vision de negocio, no tecnica
   * - Justificativos
     - Explican el ROI del proyecto
   * - Influenciados
     - Por BR, pero no son reiteracion de ellas
   * - Alcance
     - Definen limites del proyecto
   * - Medibles
     - Tienen metricas de exito cuantificables

3.3 Relacion con BR
^^^^^^^^^^^^^^^^^^^

::

   Business Rules INFLUYEN en Business Requirements:

   BR_001 (Fuente Inmutable)  ----+
   BR_002 (ETL Nocturno)      ----+---> BReq-001: Visibilidad de
                                        metricas IVR en tiempo real

   BR_006 (RBAC Flat)         ----+
   BR_007 (SoD)               ----+---> BReq-004: Cumplimiento de
   BR_010 (Auditoria)         ----+     seguridad y auditoria

3.4 Ejemplo
^^^^^^^^^^^

::

   Business Requirement (IACT):

   BReq-001: Visibilidad de Metricas IVR

   El Sistema IACT Dashboard Analytics debe proporcionar
   visibilidad en tiempo real de las metricas de llamadas
   del IVR, permitiendo a los supervisores identificar
   problemas operacionales y tomar decisiones informadas,
   reduciendo el tiempo de resolucion de incidentes en 40%.

   Influenciado por:
     - BR_001: Fuente operacional inmutable
     - BR_002: Sincronizacion ETL nocturna
     - Objetivo de negocio: Mejora operacional

3.5 BReq en IACT
^^^^^^^^^^^^^^^^

::

   ID        NOMBRE                      METRICA DE EXITO
   ------------------------------------------------------------------
   BReq-001  Visibilidad Metricas IVR    Dashboard actualizado cada 5 min
   BReq-002  Reduccion Tiempo Incidentes Reduccion >= 40% vs linea base
   BReq-003  Decisiones Informadas       100% decisiones con datos
   BReq-004  Cumplimiento Seguridad      0 accesos no autorizados
   BReq-005  Integridad Datos            0 escrituras no autorizadas

3.6 Ubicacion en IACT
^^^^^^^^^^^^^^^^^^^^^

::

   IACT/
   +-- requisitos/
       +-- objetivos/                    <- Nivel 1 (BReq)
           +-- index.rst
           +-- BReq_001_Objetivos_IACT.rst

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
   * - Narrativos
     - Cuentan una historia de interaccion
   * - Observables
     - Describen lo que el usuario VE
   * - Completos
     - Flujo de principio a fin
   * - Sin implementacion
     - NO especifican el COMO interno

4.3 Relacion con BR y BReq
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   FUENTES DE UC:

   1. BReq genera UC:
      BReq-002 (Reduccion Incidentes) --genera--> UC-036 a UC-040 (Alertas)

   2. BR tipo Trigger genera UC:
      BR_002 (ETL Nocturno) --genera--> UC-050 (Supervisar ETL)

   3. BR tipo Restriccion influye en UC:
      BR_007 (SoD) --influye--> UC-043 (Configurar SoD)

4.4 Ejemplo
^^^^^^^^^^^

::

   UC-043: Configurar SoD

   Actor Primario: AGR-008 (admin_seguridad)
   Objetivo:       Crear restricciones para prevenir conflictos de funciones

   Flujo Normal:
     1. Admin Seguridad selecciona Gestionar SoD
     2. Sistema muestra lista de restricciones actuales
     3. Admin selecciona Crear nueva restriccion
     4. Sistema muestra formulario de configuracion
     5. Admin define Grupo A y Grupo B de funciones
     6. Sistema valida que no hay conflictos existentes
     7. Sistema guarda restriccion SoD
     8. Sistema registra en auditoria

   Business Rules aplicadas: BR_007 (SoD)
   BReq relacionado: BReq-004 (Cumplimiento Seguridad)

4.5 UC en IACT
^^^^^^^^^^^^^^

::

   MODULO          CANTIDAD    RANGO UC
   ------------------------------------------------------------------
   MOD_Auth            5       UC-001 a UC-005
   MOD_Users           4       UC-006 a UC-009
   MOD_Access          9       UC-010, UC-011, UC-041 a UC-047
   MOD_Pipeline        4       UC-050 a UC-053
   MOD_Reports        14       UC-017 a UC-030
   MOD_Alerts          5       UC-036 a UC-040
   MOD_Audit           4       UC-060 a UC-063
   MOD_Logs            4       UC-070 a UC-073
   ------------------------------------------------------------------
   TOTAL              49

----

5. Nivel 3: Functional Requirements (FR)
----------------------------------------

5.1 Definicion
^^^^^^^^^^^^^^

Los **Functional Requirements** son especificaciones detalladas y atomicas
de lo que el sistema debe hacer. Se derivan directamente de los pasos de
los Casos de Uso.

5.2 Caracteristicas
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - Atomicos
     - Una sola funcionalidad por FR
   * - Verificables
     - Se puede probar si se cumple o no
   * - Independientes
     - No dependen de secuencia para verificarse
   * - Implementables
     - Suficientemente especificos para codificar

5.3 Relacion con UC
^^^^^^^^^^^^^^^^^^^

::

   Cada paso de UC deriva multiples FR:

   UC-043, Paso 2: Sistema muestra lista de restricciones actuales
       |
       +---> FR-043.1: Sistema DEBE mostrar lista de restricciones SoD
       +---> FR-043.2: Lista DEBE incluir ID, Nombre, Grupo A, Grupo B
       +---> FR-043.3: Lista DEBE estar ordenada por fecha de creacion

   Regla: Cada paso que dice Sistema [verbo] genera FR

5.4 Ejemplo
^^^^^^^^^^^

::

   Derivados de UC-043:

   FR-043.1: Sistema DEBE mostrar lista de restricciones SoD existentes
   FR-043.2: Sistema DEBE validar conflictos al crear nueva SoD
   FR-043.3: Sistema DEBE impedir asignacion que viole SoD
   FR-043.4: Sistema DEBE registrar en auditoria cambios SoD
   FR-043.5: Sistema DEBE notificar al admin de seguridad

5.5 FR en IACT
^^^^^^^^^^^^^^

::

   Estimacion basada en ratio 1 UC : 8 FR

   49 UC x 8 FR/UC = ~400 FR esperados

   Distribucion por modulo:
   - MOD_Auth:      5 UC x 8 = ~40 FR
   - MOD_Users:     4 UC x 8 = ~32 FR
   - MOD_Access:    9 UC x 8 = ~72 FR
   - MOD_Pipeline:  4 UC x 8 = ~32 FR
   - MOD_Reports:  14 UC x 8 = ~112 FR
   - MOD_Alerts:    5 UC x 8 = ~40 FR
   - MOD_Audit:     4 UC x 8 = ~32 FR
   - MOD_Logs:      4 UC x 8 = ~32 FR

----

6. Flujo de Influencia
----------------------

6.1 Diagrama de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   NIVEL 0              NIVEL 1              NIVEL 2           NIVEL 3
   +----------+        +----------+         +----------+      +----------+
   |    BR    |--inf-->|   BReq   |--gen--->|    UC    |--der-->|    FR    |
   |   (20)   |        |   (5)    |         |   (49)   |      |  (~400)  |
   +----+-----+        +----------+         +----------+      +----------+
        |
        | genera (si Trigger)
        |
        +--------------------------------------------->|    UC    |
                                                       +----------+

6.2 Tipos de Relaciones
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 20 20 40

   * - Relacion
     - Origen
     - Destino
     - Semantica
   * - influye
     - BR
     - BReq
     - BR afecta objetivo sin generar
   * - genera
     - BReq
     - UC
     - Objetivo genera casos de uso
   * - genera
     - BR (Trigger)
     - UC
     - BR Desencadenador genera UC
   * - deriva
     - UC
     - FR
     - Pasos del UC generan FR

----

7. Resumen Comparativo
----------------------

7.1 Tabla de Niveles
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 12 18 18 18 18 16

   * - Nivel
     - Nombre
     - Pregunta
     - Contenido
     - Artefacto
     - Prefijo
   * - 0
     - Business Rules
     - Por que restriccion?
     - Politicas, regulaciones
     - BR_NNN.rst
     - BR_
   * - 1
     - Business Req.
     - Por que proyecto?
     - Objetivos, alcance
     - BReq_NNN.rst
     - BReq_
   * - 2
     - User Req.
     - Que hace usuario?
     - Casos de Uso
     - UC_NNN.rst
     - UC_
   * - 3
     - Functional Req.
     - Como sistema?
     - Especificaciones
     - FR_NNN.rst
     - FR_

7.2 Gradiente de Abstraccion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   NIVEL 0 (BR)    NIVEL 1 (BReq)   NIVEL 2 (UC)    NIVEL 3 (FR)

   Mas abstracto ---------------------------------> Mas concreto
   Mas estable -----------------------------------> Mas cambiante
   Mayor alcance ---------------------------------> Menor alcance
   Menos cantidad -------------------------------> Mas cantidad

   Cantidad tipica:

   5-20 BR  ->  3-10 BReq  ->  30-100 UC  ->  200-1000 FR

   IACT:
   20 BR  ->  5 BReq  ->  49 UC  ->  ~400 FR (estimado)

   Ratios IACT:
   BR:BReq = 4:1
   BReq:UC = 1:10
   UC:FR = 1:8

7.3 Responsabilidad por Nivel
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Nivel
     - Responsable de Crear
     - Responsable de Aprobar
   * - BR
     - Stakeholders, Legal, Compliance
     - Sponsor, Legal
   * - BReq
     - Product Owner, BA
     - Sponsor, Stakeholders
   * - UC
     - Business Analyst
     - Product Owner, Usuarios
   * - FR
     - Business Analyst, Arquitecto
     - Tech Lead, QA

----

8. Aplicacion en IACT
---------------------

8.1 Ubicacion en Estructura
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   requisitos/
       |
       +--- objetivos/           <- Nivel 1 (BReq)
       |       +--- index.rst
       |       +--- BReq_001_Objetivos_IACT.rst
       |
       +--- reglas_negocio/      <- Nivel 0 (BR)
       |       +--- BR_001_xxx.rst
       |       +--- BR_002_xxx.rst
       |       +--- ... (20 BR total)
       |
       +--- casos_uso/           <- Nivel 2 (UC)
       |       +--- index.rst
       |       +--- auth/
       |       +--- users/
       |       +--- access/
       |       +--- pipeline/
       |       +--- reports/
       |       +--- alerts/
       |       +--- audit/
       |       +--- logs/
       |
       +--- funcionales/         <- Nivel 3 (FR)
       |       +--- index.rst
       |       +--- auth/
       |       +--- users/
       |       +--- ... (por modulo)
       |
       +--- no_funcionales/      <- NFR (paralelo a FR)
               +--- index.rst
               +--- NFR_001_xxx.rst

8.2 Ejemplos IACT por Nivel
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

   NIVEL 0 - BR:
   BR_001: La BD MySQL operacional es de SOLO LECTURA para IACT
   BR_007: Las funciones criticas deben estar segregadas (SoD)

   NIVEL 1 - BReq:
   BReq-001: Proporcionar visibilidad de metricas de llamadas IVR
   BReq-004: Garantizar cumplimiento de seguridad y auditoria

   NIVEL 2 - UC:
   UC-025: Ver Dashboard Principal
   UC-043: Configurar SoD
   UC-050: Supervisar Estado ETL

   NIVEL 3 - FR:
   FR-025.1: Sistema DEBE mostrar grafico de llamadas por hora
   FR-043.1: Sistema DEBE mostrar lista de restricciones SoD
   FR-050.1: Sistema DEBE mostrar estado del ultimo job ETL

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- FND_01 - Concepto de Requisito
- FND_02 - Reglas de Negocio
- FND_03 - Casos de Uso
- FND_04 - Trazabilidad
- FND_06 - Derivacion vs Transformacion
- FND_07 - Requerimientos Funcionales

Modelos IACT
^^^^^^^^^^^^

- MODELO_DOCUMENTAL_IACT_v2.0.7 - Estructura documental
- MODELO_RBAC_IACT_v5.1.1 - Modelo de control de acceso

Fuentes Externas
^^^^^^^^^^^^^^^^

- Karl Wiegers: Software Requirements (3rd Edition)
- IEEE 830-1998: Software Requirements Specifications
- IREB CPRE Foundation Level Syllabus

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
     - 2026-01-04
     - Equipo IACT
     - Documentada implementacion completa de 4 niveles en IACT. Agregada seccion 1.3 con clarificacion META_04 vs BReq. Agregados 5 BReq identificados. Actualizada cantidad UC de 38 a 49. Agregados ratios IACT. Actualizado arbol de estructura.
   * - 1.0.0
     - 2025-12-19
     - Equipo IACT
     - Version inicial aprobada

----

Trazabilidad: Este artefacto define la estructura jerarquica que
organiza todo el dominio requisitos/. Es la base conceptual para entender
las relaciones BR -> BReq -> UC -> FR documentadas en FND_04 (Trazabilidad).