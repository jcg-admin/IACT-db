.. meta::
   :artefacto: TPL_API
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-api:

==============================================================================
TPL_API: Plantilla de Documentacion API v1.0.0
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Esta plantilla define la estructura estandar para documentar **APIs REST (API)**
en el proyecto IACT. Cada modulo expone endpoints documentados siguiendo
el estandar OpenAPI/Swagger.

**Caracteristicas:**

- Documentacion de endpoints REST
- Especificacion de request/response
- Codigos HTTP y errores
- Autenticacion y permisos requeridos
- Ejemplos de uso con curl

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Django REST Framework (implementacion)

**Ubicacion:**

::

   arquitectura_tecnica/apis/API_[Nombre].rst

----

Nomenclatura
------------

**Formato de ID:**

::

   API_[Nombre]

   Donde:
   - API: Prefijo fijo
   - [Nombre]: Nombre del modulo en PascalCase

**Ejemplos:**

::

   API_Auth, API_Users, API_Access, API_Reports

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: API_[Nombre]
      :tipo: Documentacion API
      :dominio: arquitectura_tecnica
      :subdominio: apis
      :modulo: MOD_[Nombre]
      :base_url: /api/[nombre]/
      :version_api: v1
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :autor: Equipo IACT

   .. _api-[nombre]:

   ==============================================================================
   API_[Nombre]: API de [Descripcion]
   ==============================================================================

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   Resumen Ejecutivo
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **API**
        - API_[Nombre]
      * - **Modulo**
        - MOD_[Nombre]
      * - **Base URL**
        - ``/api/[nombre]/``
      * - **Version**
        - v1
      * - **Formato**
        - JSON
      * - **Autenticacion**
        - JWT Bearer Token

   ----

   1. Descripcion General
   ----------------------

   [Descripcion del proposito de esta API en 2-3 oraciones.]

   ----

   2. Autenticacion
   ----------------

   Todos los endpoints requieren autenticacion JWT:

   .. code-block:: http

      Authorization: Bearer <token>

   ----

   3. Endpoints
   ------------

   3.1 [GET] /api/[nombre]/
   ^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Listar recursos

   **Permisos:** ``[funcion]_list``

   **Response 200 OK:**

   .. code-block:: json

      {
          "count": 100,
          "next": "/api/[nombre]/?page=2",
          "previous": null,
          "results": [{"id": 1, "campo": "valor"}]
      }

   **Ejemplo curl:**

   .. code-block:: bash

      curl -X GET "/api/[nombre]/" -H "Authorization: Bearer $TOKEN"

   ----

   3.2 [GET] /api/[nombre]/{id}/
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Obtener detalle

   **Permisos:** ``[funcion]_view``

   **Response 200 OK:** Recurso completo

   **Response 404:** No encontrado

   ----

   3.3 [POST] /api/[nombre]/
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Crear recurso

   **Permisos:** ``[funcion]_create``

   **Request Body:**

   .. code-block:: json

      {"campo_1": "valor", "campo_2": "valor"}

   **Response 201 Created:** Recurso creado

   **Response 400:** Error de validacion

   ----

   3.4 [PUT/PATCH] /api/[nombre]/{id}/
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Actualizar recurso

   **Permisos:** ``[funcion]_update``

   **Response 200 OK:** Recurso actualizado

   ----

   3.5 [DELETE] /api/[nombre]/{id}/
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Eliminar recurso (baja logica)

   **Permisos:** ``[funcion]_delete``

   **Response 204 No Content:** Eliminado

   ----

   4. Codigos de Respuesta
   -----------------------

   .. list-table::
      :widths: 15 85
      :header-rows: 1

      * - Codigo
        - Significado
      * - 200
        - OK - Solicitud exitosa
      * - 201
        - Created - Recurso creado
      * - 204
        - No Content - Eliminacion exitosa
      * - 400
        - Bad Request - Error de validacion
      * - 401
        - Unauthorized - Token invalido
      * - 403
        - Forbidden - Sin permisos
      * - 404
        - Not Found - No encontrado
      * - 500
        - Internal Server Error

   ----

   5. Permisos RBAC
   ----------------

   .. list-table::
      :widths: 40 30 30
      :header-rows: 1

      * - Endpoint
        - Metodo
        - Funcion Requerida
      * - /api/[nombre]/
        - GET
        - [funcion]_list
      * - /api/[nombre]/{id}/
        - GET
        - [funcion]_view
      * - /api/[nombre]/
        - POST
        - [funcion]_create
      * - /api/[nombre]/{id}/
        - PUT/PATCH
        - [funcion]_update
      * - /api/[nombre]/{id}/
        - DELETE
        - [funcion]_delete

   ----

   6. Paginacion
   -------------

   .. code-block:: json

      {
          "count": 100,
          "next": "/api/[nombre]/?page=2",
          "previous": null,
          "results": [...]
      }

   Parametros: ``page``, ``page_size`` (max: 100)

   ----

   7. Filtros y Ordenamiento
   -------------------------

   - Filtros: ``?campo=valor``, ``?campo__contains=texto``
   - Ordenar: ``?ordering=-created_at`` (- para DESC)

   ----

   8. Rate Limiting
   ----------------

   - Anonimo: 100 req/hora
   - Autenticado: 1000 req/hora

   ----

   9. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Modulo**
        - MOD_[Nombre]
      * - **UC Relacionados**
        - UC_[MOD]_[NN], UC_[MOD]_[NN]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]

   ----

   10. Historial de Cambios
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

Secciones Obligatorias
----------------------

Cada API DEBE incluir estas 10 secciones:

1. Resumen Ejecutivo
2. Descripcion General
3. Autenticacion
4. Endpoints (con request/response)
5. Codigos de Respuesta
6. Permisos RBAC
7. Paginacion
8. Filtros y Ordenamiento
9. Trazabilidad
10. Historial

----

Validacion
----------

**Checklist:**

- [ ] Base URL especificada
- [ ] Todos los endpoints documentados
- [ ] Request y Response para cada endpoint
- [ ] Permisos RBAC especificados
- [ ] Ejemplos curl incluidos

----

Referencias
-----------

- OpenAPI 3.0: https://swagger.io/specification/
- Django REST Framework: https://www.django-rest-framework.org/
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
     - Version inicial de plantilla API REST
