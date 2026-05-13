.. meta::
   :artefacto: TPL_002
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 2.0.0
   :fecha_creacion: 2026-01-06
   :autor: Equipo IACT

.. _tpl-002-v2:

=====================================================
TPL_002: Plantilla de Caso de Uso v2.0 (con PlantUML)
=====================================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar Casos de Uso
en el proyecto IACT usando Sphinx con diagramas PlantUML embebidos.

**Version 2.0**: Incluye diagramas PlantUML usando directiva ``.. uml::``

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- sphinxcontrib-plantuml >= 0.27
- PlantUML (JAR o servidor)

**Configuracion conf.py:**

.. code-block:: python

   extensions = [
       'sphinxcontrib.plantuml',
   ]

   plantuml = 'plantuml'  # o 'java -jar plantuml.jar'
   plantuml_output_format = 'svg'

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo: ``UC_NNN_Nombre_Del_UC.rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Completar los 3 diagramas PlantUML obligatorios
5. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**ID de UC:**

::

   UC-NNN

   Donde NNN es numero de 3 digitos:
   - 001-009: MOD_Auth
   - 006-009: MOD_Users
   - 010-011, 041-047: MOD_Access
   - 017-030: MOD_Reports
   - 036-040: MOD_Alerts
   - 050-053: MOD_Pipeline
   - 060-063: MOD_Audit
   - 070-073: MOD_Logs

**Nombre de Archivo:**

::

   UC_NNN_Nombre_Sin_Espacios.rst

   Ejemplos:
   - UC_001_Iniciar_Sesion.rst
   - UC_043_Configurar_SoD.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: UC_[NNN]
      :tipo: Caso de Uso
      :dominio: requisitos
      :subdominio: casos_uso/[modulo]
      :modulo: MOD_[Modulo]
      :estado: [Borrador|Revision|Aprobado]
      :version: 2.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :autor: Equipo IACT

   .. _uc-[nnn]:

                                     
   UC-[NNN]: [Nombre del Caso de Uso]
                                     

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   1. Resumen
   ----------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - UC-[NNN]
      * - **Nombre**
        - [Nombre descriptivo del caso de uso]
      * - **Actor Primario**
        - [Actor principal que inicia el UC]
      * - **Actores Secundarios**
        - [Otros actores involucrados, o "Ninguno"]
      * - **Modulo**
        - MOD_[Modulo]
      * - **Complejidad**
        - [Baja|Media|Alta]
      * - **Prioridad**
        - [Alta|Media|Baja]
      * - **BReq Origen**
        - BReq-[NNN]: [Nombre del Business Requirement]

   ----

   2. Descripcion
   --------------

   [Descripcion del objetivo del caso de uso en 2-3 oraciones.
   Responde: ¿Que logra el usuario al completar este UC?]

   ----

   3. Diagrama de Caso de Uso
   --------------------------

   .. uml::
      :caption: Diagrama de Caso de Uso - UC-[NNN]
      :align: center
      :scale: 90%

      @startuml
      left to right direction
      skinparam actorStyle awesome
      skinparam backgroundColor #FAFAFA
      skinparam usecase {
          BackgroundColor #E3F2FD
          BorderColor #1976D2
      }

      actor "[Actor Primario]" as AP

      rectangle "MOD_[Modulo]" {
          usecase "UC-[NNN]:\n[Nombre]" as UC
      }

      AP --> UC
      @enduml

   ----

   4. Contexto
   -----------

   4.1 Precondiciones
   ^^^^^^^^^^^^^^^^^^

   1. [Condicion que debe ser verdadera antes de iniciar]
   2. [Otra precondicion]

   4.2 Trigger
   ^^^^^^^^^^^

   [Evento o accion que inicia el caso de uso]

   4.3 Postcondiciones de Exito
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   1. [Estado del sistema tras completar exitosamente]
   2. [Otro resultado esperado]

   4.4 Garantias Minimas
   ^^^^^^^^^^^^^^^^^^^^^

   1. [Lo que siempre se garantiza, incluso si el UC falla]

   ----

   5. Flujo Normal
   ---------------

   .. list-table::
      :widths: 8 46 46
      :header-rows: 1

      * - Paso
        - Actor
        - Sistema
      * - 1
        - [Accion del actor]
           
      * - 2
           
        - [Respuesta del sistema]
      * - 3
        - [Siguiente accion]
           
      * - 4
           
        - [Siguiente respuesta]

   ----

   6. Diagrama de Secuencia
   ------------------------

   .. uml::
      :caption: Secuencia - Flujo Normal UC-[NNN]
      :align: center

      @startuml
      skinparam backgroundColor #FAFAFA
      skinparam sequenceMessageAlign center
      skinparam participant {
          BackgroundColor #E8F5E9
          BorderColor #388E3C
      }
      skinparam database {
          BackgroundColor #FFF3E0
          BorderColor #F57C00
      }

      actor "[Actor]" as A
      participant "Frontend" as FE #E3F2FD
      participant "[Controller]" as CTRL #E8F5E9
      participant "[Service]" as SVC #E8F5E9
      database "PostgreSQL" as DB #FFF3E0

      A -> FE: 1. [Accion inicial]
      activate FE

      FE -> CTRL: 2. [HTTP Request]
      activate CTRL

      CTRL -> SVC: 3. [Llamada a servicio]
      activate SVC

      SVC -> DB: 4. [Query]
      DB --> SVC: 5. [Resultado]

      SVC --> CTRL: 6. [Respuesta]
      deactivate SVC

      CTRL --> FE: 7. [HTTP Response]
      deactivate CTRL

      FE --> A: 8. [Actualiza UI]
      deactivate FE
      @enduml

   ----

   7. Flujos Alternos
   ------------------

   7.1 FA-1: [Nombre del Flujo Alterno]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Punto de bifurcacion:** Paso [N] del flujo normal

   **Condicion:** [Cuando se activa este flujo]

   .. list-table::
      :widths: 10 90
      :header-rows: 1

      * - Paso
        - Descripcion
      * - [N].1
        - [Primera accion del flujo alterno]
      * - [N].2
        - [Segunda accion]

   **Retorno:** [Paso M del flujo normal | Fin del UC]

   ----

   8. Excepciones
   --------------

   8.1 EX-1: [Nombre de la Excepcion]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Condicion:** [Cuando ocurre esta excepcion]

   **Accion del Sistema:** [Que hace el sistema]

   **Mensaje al Usuario:** "[Texto del mensaje de error]"

   ----

   9. Diagrama de Actividad
   ------------------------

   .. uml::
      :caption: Actividad - Flujos y Decisiones UC-[NNN]
      :align: center

      @startuml
      skinparam backgroundColor #FAFAFA
      skinparam activity {
          BackgroundColor #E3F2FD
          BorderColor #1976D2
          DiamondBackgroundColor #FFF9C4
          DiamondBorderColor #F57C00
      }

      start

      :[Paso inicial];

      if ([Condicion de decision]?) then (si)
          :[Accion si verdadero];
      else (no)
          :[Accion si falso];
      endif

      :[Paso final];

      stop
      @enduml

   ----

   10. Reglas de Negocio
   ---------------------

   .. list-table::
      :widths: 12 30 58
      :header-rows: 1

      * - BR
        - Nombre
        - Aplicacion en este UC
      * - BR_[NNN]
        - [Nombre de la regla]
        - [Como y en que paso se aplica esta regla]

   ----

   11. Requerimientos Funcionales Derivados
   ----------------------------------------

   .. list-table::
      :widths: 15 85
      :header-rows: 1

      * - FR
        - Descripcion
      * - FR-[NNN].01
        - [Descripcion breve del requerimiento funcional]
      * - FR-[NNN].02
        - [Descripcion breve]

   ----

   12. Trazabilidad
   ----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Origen (BReq)**
        - BReq-[NNN]: [Nombre]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]
      * - **FR Derivados**
        - FR-[NNN].01 a FR-[NNN].[NN]
      * - **Actores RBAC**
        - AGR-[NNN]: [nombre_agrupador]
      * - **Funciones RBAC**
        - [XXX]-[NNN]: [nombre_funcion]

   ----

   13. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Cambios
      * - 2.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Version inicial con PlantUML embebido

----

Diagramas Obligatorios
----------------------

Cada UC v2.0 DEBE incluir minimo estos diagramas:

1. **Diagrama de Caso de Uso** (Seccion 3)
   - Muestra actor(es) y su relacion con el UC
   - Incluye relaciones <<include>> o <<extends>> si aplica

2. **Diagrama de Secuencia** (Seccion 6)
   - Muestra interaccion entre componentes
   - Pasos numerados del flujo normal
   - Incluye Frontend, Controller, Service, BD

3. **Diagrama de Actividad** (Seccion 9)
   - Muestra flujo de decision
   - Incluye flujos alternos y excepciones
   - Start/Stop claramente marcados

----

Validacion
----------

Antes de aprobar un UC, verificar:

.. code-block:: bash

   # Validar sintaxis RST y PlantUML
   sphinx-build -b html -W docs/ docs/_build/

   # Si hay errores PlantUML, se mostraran en consola

----

Referencias
-----------

- FND_03 v1.3.0: Casos de Uso (definicion conceptual)
- FND_05: Jerarquia de 4 Niveles
- sphinxcontrib-plantuml: https://github.com/sphinx-contrib/plantuml
- PlantUML: https://plantuml.com/

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 2.0.0
     - 2026-01-06
     - Equipo IACT
     - Nueva version con PlantUML embebido para Sphinx
   * - 1.0.0
     - 2025-12-19
     - Equipo IACT
     - Version inicial (sin diagramas)
