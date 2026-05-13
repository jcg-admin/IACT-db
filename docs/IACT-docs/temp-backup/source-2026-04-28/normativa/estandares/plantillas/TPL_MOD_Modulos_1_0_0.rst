.. meta::
   :artefacto: TPL_MOD
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-mod:

==================================================
TPL_MOD: Plantilla de Modulo Arquitectonico v1.0.0
==================================================


Proposito
---------

Esta plantilla define la estructura estandar para documentar **Modulos Arquitectonicos (MOD)**
en el proyecto IACT. Los MOD representan las unidades funcionales principales del sistema,
cada uno mapeado a una Django App.

**Caracteristicas:**

- Unidad funcional cohesiva del sistema
- Mapeado 1:1 con Django App
- Define responsabilidades claras (PUEDE/NO PUEDE)
- Contiene casos de uso relacionados
- Incluye diagrama PlantUML de componentes

**Los 8 Modulos IACT:**

::

   MOD_Auth     -> apps.auth      (Autenticacion)
   MOD_Users    -> apps.users     (Gestion Usuarios)
   MOD_Access   -> apps.access    (Control Acceso RBAC)
   MOD_Pipeline -> apps.pipeline  (ETL y Datos)
   MOD_Reports  -> apps.reports   (Reporteria)
   MOD_Alerts   -> apps.alerts    (Alertas)
   MOD_Audit    -> apps.audit     (Auditoria)
   MOD_Logs     -> apps.logs      (Bitacoras)

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- sphinxcontrib-plantuml >= 0.27
- PlantUML (JAR o servidor)

**Ubicacion:**

::

   arquitectura_tecnica/modulos/MOD_[Nombre].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``MOD_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Definir responsabilidades (PUEDE) y limites (NO PUEDE)
5. Listar UC asociados al modulo
6. Completar diagrama PlantUML de componentes
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   MOD_[Nombre]

   Donde:
   - MOD: Prefijo fijo (Module)
   - [Nombre]: Nombre del modulo en PascalCase

**Ejemplos:**

::

   MOD_Auth      -> Modulo de Autenticacion
   MOD_Users     -> Modulo de Gestion de Usuarios
   MOD_Access    -> Modulo de Control de Acceso
   MOD_Reports   -> Modulo de Reporteria

**Nombre de Archivo:**

::

   MOD_[Nombre].rst

   Ejemplos:
   - MOD_Auth.rst
   - MOD_Users.rst
   - MOD_Access.rst
   - MOD_Reports.rst

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: MOD_[Nombre]
      :tipo: Modulo Arquitectonico
      :dominio: arquitectura_tecnica
      :subdominio: modulos
      :django_app: apps.[nombre]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _mod-[nombre]:

                                    
   MOD_[Nombre]: [Titulo del Modulo]
                                    

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
        - MOD_[Nombre]
      * - **Nombre**
        - [Nombre descriptivo del modulo]
      * - **Django App**
        - apps.[nombre]
      * - **Prefijo UC**
        - UC_[MOD]_
      * - **Total UC**
        - [N] casos de uso
      * - **BReq Asociado**
        - BReq_[MOD]
      * - **Estado**
        - [Activo|En desarrollo|Congelado]

   ----

   1. Proposito
   ------------

   [Descripcion del proposito principal del modulo en 2-3 oraciones.
   Responde: Cual es la razon de existencia de este modulo?]

   ----

   2. Responsabilidades (PUEDE hacer)
   ----------------------------------

   Este modulo ES RESPONSABLE de:

   - [Responsabilidad 1: Descripcion de lo que puede hacer]
   - [Responsabilidad 2: Descripcion de lo que puede hacer]
   - [Responsabilidad 3: Descripcion de lo que puede hacer]
   - [Responsabilidad N: Descripcion de lo que puede hacer]

   ----

   3. Limites (NO PUEDE hacer)
   ---------------------------

   Este modulo NO ES RESPONSABLE de:

   - [Limite 1: Lo que NO puede hacer y quien lo hace]
   - [Limite 2: Lo que NO puede hacer y quien lo hace]
   - [Limite 3: Lo que NO puede hacer y quien lo hace]

   ----

   4. Casos de Uso Asociados
   -------------------------

   .. list-table::
      :widths: 20 50 30
      :header-rows: 1

      * - UC
        - Nombre
        - Estado
      * - UC_[MOD]_01
        - [Nombre del UC]
        - [Aprobado|En revision]
      * - UC_[MOD]_02
        - [Nombre del UC]
        - [Aprobado|En revision]
      * - UC_[MOD]_NN
        - [Nombre del UC]
        - [Aprobado|En revision]

   ----

   5. Restricciones Aplicables (CNST)
   ----------------------------------

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - CNST
        - Nombre
        - Aplicacion en MOD
      * - CNST_[NNN]
        - [Nombre de la restriccion]
        - [Como aplica al modulo]
      * - CNST_[NNN]
        - [Nombre de la restriccion]
        - [Como aplica al modulo]

   ----

   6. Business Rules Aplicables (BR)
   ---------------------------------

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - BR
        - Nombre
        - Aplicacion en MOD
      * - BR_[NNN]
        - [Nombre de la regla]
        - [Como aplica al modulo]
      * - BR_[NNN]
        - [Nombre de la regla]
        - [Como aplica al modulo]

   ----

   7. Dependencias con otros Modulos
   ---------------------------------

   7.1 Depende de
   ^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 40 40
      :header-rows: 1

      * - Modulo
        - Tipo Dependencia
        - Descripcion
      * - MOD_[xxx]
        - [Obligatoria|Opcional]
        - [Para que necesita este modulo]

   7.2 Dependido por
   ^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 40 40
      :header-rows: 1

      * - Modulo
        - Tipo Dependencia
        - Descripcion
      * - MOD_[yyy]
        - [Obligatoria|Opcional]
        - [Por que depende de este modulo]

   ----

   8. Componentes Internos
   -----------------------

   8.1 Estructura Django
   ^^^^^^^^^^^^^^^^^^^^^

   ::

      apps/[nombre]/
      |-- __init__.py
      |-- admin.py
      |-- apps.py
      |-- models.py          # Modelos de datos
      |-- views.py           # Vistas/ViewSets DRF
      |-- serializers.py     # Serializadores DRF
      |-- services.py        # Logica de negocio
      |-- urls.py            # Rutas del modulo
      |-- permissions.py     # Permisos personalizados
      +-- tests/
          |-- __init__.py
          |-- test_models.py
          |-- test_views.py
          +-- test_services.py

   8.2 Modelos Principales
   ^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 1

      * - Modelo
        - Descripcion
      * - [NombreModelo]
        - [Descripcion del modelo y su proposito]
      * - [NombreModelo]
        - [Descripcion del modelo y su proposito]

   8.3 Servicios
   ^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 70
      :header-rows: 1

      * - Servicio
        - Responsabilidad
      * - [NombreService]
        - [Que hace este servicio]
      * - [NombreService]
        - [Que hace este servicio]

   ----

   9. Diagrama de Componentes
   --------------------------

   .. uml::
      :caption: Componentes de MOD_[Nombre]
      :align: center

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

      package "MOD_[Nombre]" {
          [Views/ViewSets] as V
          [Serializers] as S
          [Services] as SVC
          [Models] as M
          [Permissions] as P
      }

      database "PostgreSQL" as DB

      V --> S : usa
      V --> P : verifica
      S --> SVC : delega
      SVC --> M : opera
      M --> DB : persiste

      @enduml

   ----

   10. Interfaces Expuestas
   ------------------------

   10.1 API Endpoints
   ^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 15 35 25 25
      :header-rows: 1

      * - Metodo
        - Endpoint
        - Descripcion
        - Permiso
      * - GET
        - /api/[modulo]/
        - [Descripcion]
        - [funcion_requerida]
      * - POST
        - /api/[modulo]/
        - [Descripcion]
        - [funcion_requerida]

   10.2 Eventos Emitidos
   ^^^^^^^^^^^^^^^^^^^^^

   - [Evento 1]: [Cuando se emite y que contiene]
   - [Evento 2]: [Cuando se emite y que contiene]

   ----

   11. Trazabilidad
   ----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **BReq Origen**
        - BReq_[MOD]: [Nombre]
      * - **UC Asociados**
        - UC_[MOD]_01, UC_[MOD]_02, ... UC_[MOD]_NN
      * - **CNST Aplicables**
        - CNST_[NNN], CNST_[NNN]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]
      * - **API Documento**
        - API_[Nombre].rst

   ----

   12. Historial de Cambios
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

Cada MOD DEBE incluir minimo estas 12 secciones:

.. list-table::
   :widths: 5 30 65
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, Django App, prefijo UC, BReq
   * - 1
     - Proposito
     - Razon de existencia del modulo
   * - 2
     - Responsabilidades
     - Lo que PUEDE hacer
   * - 3
     - Limites
     - Lo que NO PUEDE hacer
   * - 4
     - Casos de Uso
     - UC asociados al modulo
   * - 5
     - Restricciones (CNST)
     - CNST que aplican
   * - 6
     - Business Rules (BR)
     - BR que aplican
   * - 7
     - Dependencias
     - Relacion con otros modulos
   * - 8
     - Componentes Internos
     - Estructura Django, modelos, servicios
   * - 9
     - Diagrama
     - PlantUML de componentes
   * - 10
     - Interfaces
     - API endpoints, eventos
   * - 11
     - Trazabilidad
     - Enlaces a BReq, UC, CNST, BR, API
   * - 12
     - Historial
     - Control de versiones

----

Validacion
----------

Antes de aprobar un MOD, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura MOD_[Nombre]
- [ ] Django App especificada correctamente
- [ ] Proposito claro y conciso
- [ ] Responsabilidades (PUEDE) definidas
- [ ] Limites (NO PUEDE) definidos
- [ ] UC asociados listados
- [ ] CNST aplicables referenciadas
- [ ] BR aplicables referenciadas
- [ ] Dependencias documentadas
- [ ] Diagrama PlantUML incluido
- [ ] API endpoints listados

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST y PlantUML
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- BReq_*: Objetivos de negocio origen
- UC_*: Casos de uso del modulo
- CNST_*: Restricciones aplicables
- BR_*: Business Rules aplicables
- API_*: Documentacion de API
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
     - Version inicial de plantilla MOD con PlantUML
