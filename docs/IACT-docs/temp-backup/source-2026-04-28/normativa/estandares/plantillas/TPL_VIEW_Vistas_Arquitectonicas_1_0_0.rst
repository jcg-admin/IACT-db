.. meta::
   :artefacto: TPL_VIEW
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-view:

==================================================
TPL_VIEW: Plantilla de Vista Arquitectonica v1.0.0
==================================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Vistas Arquitectonicas (VIEW)**
en el proyecto IACT. Las vistas representan diferentes perspectivas del sistema siguiendo
el modelo 4+1 de Philippe Kruchten.

**Caracteristicas:**

- Perspectiva especifica del sistema
- Dirigida a stakeholders particulares
- Incluye diagramas PlantUML
- Basada en modelo 4+1 (Logica, Proceso, Desarrollo, Fisica + Casos de Uso)

**Las 5 Vistas IACT:**

::

   VIEW_001  -> Componentes (Vista Logica)
   VIEW_002  -> Deployment (Vista Fisica)
   VIEW_003  -> Secuencia ETL (Vista de Proceso)
   VIEW_004  -> Dependencias Modulos (Vista de Desarrollo)
   VIEW_005  -> Modelo RBAC (Vista de Seguridad)

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- sphinxcontrib-plantuml >= 0.27
- PlantUML (JAR o servidor)

**Ubicacion:**

::

   arquitectura_tecnica/vistas/VIEW_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``VIEW_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Identificar tipo de vista (4+1)
5. Documentar stakeholders objetivo
6. Completar diagrama(s) PlantUML
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   VIEW_[NNN]

   Donde:
   - VIEW: Prefijo fijo (Vista Arquitectonica)
   - [NNN]: Numero secuencial de 3 digitos (001-999)

**Ejemplos:**

::

   VIEW_001  -> Vista de Componentes
   VIEW_002  -> Vista de Deployment
   VIEW_003  -> Vista de Secuencia ETL
   VIEW_004  -> Vista de Dependencias

**Nombre de Archivo:**

::

   VIEW_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - VIEW_001_Componentes.rst
   - VIEW_002_Deployment.rst
   - VIEW_003_Secuencia_ETL.rst

----

Modelo 4+1
----------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Vista
     - Descripcion
     - Stakeholders
   * - **Logica**
     - Funcionalidad del sistema (clases, paquetes)
     - Desarrolladores, Arquitectos
   * - **Proceso**
     - Comportamiento en runtime (secuencias, actividades)
     - Integradores, Arquitectos
   * - **Desarrollo**
     - Organizacion del codigo (modulos, dependencias)
     - Desarrolladores, Gestores
   * - **Fisica**
     - Infraestructura y deployment
     - DevOps, Administradores
   * - **Casos de Uso**
     - Escenarios que validan la arquitectura
     - Todos los stakeholders

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: VIEW_[NNN]
      :tipo: Vista Arquitectonica
      :dominio: arquitectura_tecnica
      :subdominio: vistas
      :tipo_vista: [Logica|Proceso|Desarrollo|Fisica|Casos de Uso]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _view-[nnn]:

                                   
   VIEW_[NNN]: [Nombre de la Vista]
                                   

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   Resumen Ejecutivo
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - VIEW_[NNN]
      * - **Nombre**
        - [Nombre descriptivo de la vista]
      * - **Tipo (4+1)**
        - [Logica|Proceso|Desarrollo|Fisica|Casos de Uso]
      * - **Stakeholders**
        - [Roles a quienes esta dirigida]
      * - **Nivel de Detalle**
        - [Alto|Medio|Bajo]
      * - **Estado**
        - [Vigente|En actualizacion]

   ----

   1. Proposito
   ------------

   [Descripcion del proposito de esta vista en 2-3 oraciones.
   Responde: Que perspectiva del sistema muestra y para quien?]

   ----

   2. Audiencia
   ------------

   Esta vista esta dirigida a:

   .. list-table::
      :widths: 25 75
      :header-rows: 1

      * - Stakeholder
        - Interes
      * - [Rol 1]
        - [Que busca entender de esta vista]
      * - [Rol 2]
        - [Que busca entender de esta vista]

   ----

   3. Diagrama Principal
   ---------------------

   .. uml::
      :caption: VIEW_[NNN] - [Nombre de la Vista]
      :align: center
      :scale: 90%

      @startuml
      skinparam backgroundColor #FAFAFA
      skinparam component {
          BackgroundColor #E3F2FD
          BorderColor #1976D2
      }
      skinparam package {
          BackgroundColor #FAFAFA
          BorderColor #90A4AE
      }
      skinparam database {
          BackgroundColor #FFF3E0
          BorderColor #F57C00
      }

      ' [COMPLETAR DIAGRAMA SEGUN TIPO DE VISTA]
      
      package "Sistema IACT" {
          [Componente 1] as C1
          [Componente 2] as C2
          [Componente 3] as C3
      }

      C1 --> C2
      C2 --> C3

      @enduml

   ----

   4. Elementos de la Vista
   ------------------------

   4.1 Componentes Principales
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 1

      * - Elemento
        - Descripcion
      * - [Nombre elemento 1]
        - [Descripcion y responsabilidad]
      * - [Nombre elemento 2]
        - [Descripcion y responsabilidad]
      * - [Nombre elemento N]
        - [Descripcion y responsabilidad]

   4.2 Conectores/Relaciones
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 20 60
      :header-rows: 1

      * - Desde
        - Hacia
        - Descripcion
      * - [Elemento A]
        - [Elemento B]
        - [Tipo de relacion y protocolo]
      * - [Elemento B]
        - [Elemento C]
        - [Tipo de relacion y protocolo]

   ----

   5. Diagramas Complementarios
   ----------------------------

   5.1 Diagrama de Detalle [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. uml::
      :caption: Detalle - [Aspecto especifico]
      :align: center

      @startuml
      ' [DIAGRAMA DE DETALLE SI ES NECESARIO]
      @enduml

   ----

   6. Decisiones Arquitectonicas
   -----------------------------

   Esta vista refleja las siguientes decisiones:

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - ADR
        - Impacto en la Vista
      * - ADR_[NNN]
        - [Como esta decision afecta lo mostrado]
      * - ADR_[NNN]
        - [Como esta decision afecta lo mostrado]

   ----

   7. Restricciones Reflejadas
   ---------------------------

   .. list-table::
      :widths: 20 80
      :header-rows: 1

      * - CNST
        - Manifestacion en la Vista
      * - CNST_[NNN]
        - [Como se ve esta restriccion en el diagrama]
      * - CNST_[NNN]
        - [Como se ve esta restriccion en el diagrama]

   ----

   8. Escenarios de Validacion
   ---------------------------

   Esta vista se valida mediante los siguientes escenarios:

   8.1 Escenario 1: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Descripcion**: [Que se valida]
   - **UC Relacionado**: UC_[MOD]_[NN]
   - **Resultado Esperado**: [Comportamiento esperado]

   8.2 Escenario 2: [Nombre]
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Descripcion**: [Que se valida]
   - **UC Relacionado**: UC_[MOD]_[NN]
   - **Resultado Esperado**: [Comportamiento esperado]

   ----

   9. Consideraciones
   ------------------

   9.1 Limitaciones de la Vista
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Que NO muestra esta vista]
   - [Simplificaciones realizadas]

   9.2 Relacion con Otras Vistas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - VIEW_[NNN]: [Como se complementan]
   - VIEW_[NNN]: [Como se complementan]

   ----

   10. Trazabilidad
   ----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Tipo de Vista**
        - [Logica|Proceso|Desarrollo|Fisica]
      * - **ADR Reflejadas**
        - ADR_[NNN], ADR_[NNN]
      * - **CNST Reflejadas**
        - CNST_[NNN], CNST_[NNN]
      * - **MOD Mostrados**
        - MOD_[xxx], MOD_[yyy]
      * - **UC de Validacion**
        - UC_[MOD]_[NN], UC_[MOD]_[NN]

   ----

   11. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Cambios
      * - 1.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Version inicial

   ----

   *Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada VIEW DEBE incluir minimo estas 11 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, tipo 4+1, stakeholders
   * - 1
     - Proposito
     - Para que sirve esta vista
   * - 2
     - Audiencia
     - A quien esta dirigida
   * - 3
     - Diagrama Principal
     - PlantUML principal de la vista
   * - 4
     - Elementos
     - Componentes y relaciones
   * - 5
     - Diagramas Complementarios
     - Detalles adicionales si aplica
   * - 6
     - Decisiones (ADR)
     - ADR reflejadas
   * - 7
     - Restricciones (CNST)
     - CNST manifestadas
   * - 8
     - Escenarios
     - UC que validan la vista
   * - 9
     - Consideraciones
     - Limitaciones, relacion con otras vistas
   * - 10
     - Trazabilidad
     - Enlaces a ADR, CNST, MOD, UC
   * - 11
     - Historial
     - Control de versiones

----

Validacion
----------

Antes de aprobar una VIEW, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura VIEW_[NNN]
- [ ] Tipo de vista (4+1) especificado
- [ ] Stakeholders identificados
- [ ] Diagrama PlantUML principal incluido
- [ ] Elementos y relaciones documentados
- [ ] ADR reflejadas identificadas
- [ ] CNST manifestadas identificadas
- [ ] Escenarios de validacion con UC
- [ ] Limitaciones documentadas

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST y PlantUML
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- Philippe Kruchten: "Architectural Blueprints - The 4+1 View Model"
- ADR_*: Decisiones reflejadas
- CNST_*: Restricciones manifestadas
- MOD_*: Modulos mostrados
- STD_006: Versionado Semantico

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
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial de plantilla VIEW con modelo 4+1
