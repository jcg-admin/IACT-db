.. meta::
   :artefacto: TPL_API
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-api:

==============================================
TPL_API: Plantilla de Documentacion API v1.1.0
==============================================


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

**Las 8 APIs IACT:**

::

   API_Auth     -> Autenticacion y sesiones
   API_Users    -> Gestion de usuarios
   API_Access   -> Control de acceso RBAC
   API_Pipeline -> ETL y datos
   API_Reports  -> Reporteria y exportacion
   API_Alerts   -> Alertas y notificaciones
   API_Audit    -> Auditoria
   API_Logs     -> Bitacoras

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)
- Django REST Framework (implementacion)

**Ubicacion:**

::

   arquitectura_tecnica/apis/API_[Nombre].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de seccion "Plantilla" a nuevo archivo
2. Nombrar archivo segun nomenclatura: ``API_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Documentar cada endpoint con request/response
5. Especificar permisos RBAC requeridos
6. Incluir ejemplos curl
7. Validar con ``sphinx-build -W``

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

   API_Auth     -> API de Autenticacion
   API_Users    -> API de Usuarios
   API_Access   -> API de Control de Acceso
   API_Reports  -> API de Reportes

**Nombre de Archivo:**

::

   API_[Nombre].rst

   Ejemplos:
   - API_Auth.rst
   - API_Users.rst
   - API_Access.rst

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
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _api-[nombre]:

                                     
   API_[Nombre]: API de [Descripcion]
                                     

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
      * - **Total Endpoints**
        - [N] endpoints

   ----

   1. Descripcion General
   ----------------------

   [Descripcion del proposito de esta API en 2-3 oraciones.
   Que recursos expone y para que se utiliza.]

   ----

   2. Autenticacion
   ----------------

   2.1 Metodo de Autenticacion
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   Todos los endpoints (excepto login) requieren autenticacion JWT:

   .. code-block:: http

      Authorization: Bearer <token>

   2.2 Obtencion de Token
   ^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: bash

      curl -X POST /api/auth/login/ \
           -H "Content-Type: application/json" \
           -d '{"username": "user", "password": "pass"}'

   ----

   3. Endpoints
   ------------

   3.1 [GET] /api/[nombre]/
   ^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** [Descripcion del endpoint]

   **Permisos:** ``[funcion_requerida]``

   **Request:**

   .. code-block:: http

      GET /api/[nombre]/ HTTP/1.1
      Host: api.iact.com
      Authorization: Bearer <token>

   **Query Parameters:**

   .. list-table::
      :widths: 20 15 15 50
      :header-rows: 1

      * - Parametro
        - Tipo
        - Requerido
        - Descripcion
      * - page
        - integer
        - No
        - Numero de pagina (default: 1)
      * - page_size
        - integer
        - No
        - Resultados por pagina (default: 20, max: 100)
      * - [filtro]
        - [tipo]
        - [Si/No]
        - [Descripcion]

   **Response 200 OK:**

   .. code-block:: json

      {
          "count": 100,
          "next": "/api/[nombre]/?page=2",
          "previous": null,
          "results": [
              {
                  "id": 1,
                  "campo_1": "valor",
                  "campo_2": "valor"
              }
          ]
      }

   **Ejemplo curl:**

   .. code-block:: bash

      curl -X GET "/api/[nombre]/?page=1&page_size=10" \
           -H "Authorization: Bearer $TOKEN"

   ----

   3.2 [GET] /api/[nombre]/{id}/
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Obtener detalle de un recurso por ID

   **Permisos:** ``[funcion_requerida]``

   **Request:**

   .. code-block:: http

      GET /api/[nombre]/{id}/ HTTP/1.1
      Host: api.iact.com
      Authorization: Bearer <token>

   **Path Parameters:**

   .. list-table::
      :widths: 20 15 65
      :header-rows: 1

      * - Parametro
        - Tipo
        - Descripcion
      * - id
        - integer
        - ID del recurso

   **Response 200 OK:**

   .. code-block:: json

      {
          "id": 1,
          "campo_1": "valor",
          "campo_2": "valor",
          "created_at": "2026-01-07T10:00:00Z",
          "updated_at": "2026-01-07T10:00:00Z"
      }

   **Response 404 Not Found:**

   .. code-block:: json

      {
          "detail": "No encontrado."
      }

   ----

   3.3 [POST] /api/[nombre]/
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Crear un nuevo recurso

   **Permisos:** ``[funcion_requerida]``

   **Request:**

   .. code-block:: http

      POST /api/[nombre]/ HTTP/1.1
      Host: api.iact.com
      Authorization: Bearer <token>
      Content-Type: application/json

   **Request Body:**

   .. code-block:: json

      {
          "campo_1": "valor",
          "campo_2": "valor"
      }

   **Body Parameters:**

   .. list-table::
      :widths: 20 15 15 50
      :header-rows: 1

      * - Campo
        - Tipo
        - Requerido
        - Descripcion
      * - campo_1
        - string
        - Si
        - [Descripcion del campo]
      * - campo_2
        - string
        - No
        - [Descripcion del campo]

   **Response 201 Created:**

   .. code-block:: json

      {
          "id": 1,
          "campo_1": "valor",
          "campo_2": "valor",
          "created_at": "2026-01-07T10:00:00Z"
      }

   **Response 400 Bad Request:**

   .. code-block:: json

      {
          "campo_1": ["Este campo es requerido."]
      }

   **Ejemplo curl:**

   .. code-block:: bash

      curl -X POST "/api/[nombre]/" \
           -H "Authorization: Bearer $TOKEN" \
           -H "Content-Type: application/json" \
           -d '{"campo_1": "valor", "campo_2": "valor"}'

   ----

   3.4 [PUT] /api/[nombre]/{id}/
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Actualizar un recurso completo

   **Permisos:** ``[funcion_requerida]``

   **Request:**

   .. code-block:: http

      PUT /api/[nombre]/{id}/ HTTP/1.1
      Host: api.iact.com
      Authorization: Bearer <token>
      Content-Type: application/json

   **Request Body:** Igual que POST (todos los campos requeridos)

   **Response 200 OK:** Recurso actualizado completo

   **Response 404 Not Found:** Recurso no existe

   **Ejemplo curl:**

   .. code-block:: bash

      curl -X PUT "/api/[nombre]/1/" \
           -H "Authorization: Bearer $TOKEN" \
           -H "Content-Type: application/json" \
           -d '{"campo_1": "nuevo_valor", "campo_2": "nuevo_valor"}'

   ----

   3.5 [PATCH] /api/[nombre]/{id}/
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Actualizar parcialmente un recurso

   **Permisos:** ``[funcion_requerida]``

   **Request:**

   .. code-block:: http

      PATCH /api/[nombre]/{id}/ HTTP/1.1
      Host: api.iact.com
      Authorization: Bearer <token>
      Content-Type: application/json

   **Request Body:** Solo campos a actualizar

   .. code-block:: json

      {
          "campo_1": "nuevo_valor"
      }

   **Response 200 OK:** Recurso actualizado

   **Ejemplo curl:**

   .. code-block:: bash

      curl -X PATCH "/api/[nombre]/1/" \
           -H "Authorization: Bearer $TOKEN" \
           -H "Content-Type: application/json" \
           -d '{"campo_1": "nuevo_valor"}'

   ----

   3.6 [DELETE] /api/[nombre]/{id}/
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   **Descripcion:** Eliminar un recurso (baja logica)

   **Permisos:** ``[funcion_requerida]``

   **Request:**

   .. code-block:: http

      DELETE /api/[nombre]/{id}/ HTTP/1.1
      Host: api.iact.com
      Authorization: Bearer <token>

   **Response 204 No Content:** Eliminado exitosamente

   **Response 404 Not Found:** Recurso no existe

   **Response 403 Forbidden:** Sin permisos para eliminar

   **Ejemplo curl:**

   .. code-block:: bash

      curl -X DELETE "/api/[nombre]/1/" \
           -H "Authorization: Bearer $TOKEN"

   ----

   4. Codigos de Respuesta
   -----------------------

   .. list-table::
      :widths: 15 35 50
      :header-rows: 1

      * - Codigo
        - Significado
        - Descripcion
      * - 200
        - OK
        - Solicitud exitosa (GET, PUT, PATCH)
      * - 201
        - Created
        - Recurso creado exitosamente (POST)
      * - 204
        - No Content
        - Eliminacion exitosa (DELETE)
      * - 400
        - Bad Request
        - Error de validacion en datos enviados
      * - 401
        - Unauthorized
        - Token JWT invalido o expirado
      * - 403
        - Forbidden
        - Sin permisos RBAC para la accion
      * - 404
        - Not Found
        - Recurso no encontrado
      * - 405
        - Method Not Allowed
        - Metodo HTTP no permitido
      * - 429
        - Too Many Requests
        - Rate limit excedido
      * - 500
        - Internal Server Error
        - Error interno del servidor

   ----

   5. Permisos RBAC
   ----------------

   .. list-table::
      :widths: 30 20 25 25
      :header-rows: 1

      * - Endpoint
        - Metodo
        - Funcion Requerida
        - Agrupadores
      * - /api/[nombre]/
        - GET
        - [nombre]_list
        - AGR-001, AGR-002
      * - /api/[nombre]/{id}/
        - GET
        - [nombre]_view
        - AGR-001, AGR-002
      * - /api/[nombre]/
        - POST
        - [nombre]_create
        - AGR-001
      * - /api/[nombre]/{id}/
        - PUT
        - [nombre]_update
        - AGR-001
      * - /api/[nombre]/{id}/
        - PATCH
        - [nombre]_update
        - AGR-001
      * - /api/[nombre]/{id}/
        - DELETE
        - [nombre]_delete
        - AGR-001

   ----

   6. Paginacion
   -------------

   Todos los endpoints de listado (GET collection) usan paginacion:

   **Formato de respuesta paginada:**

   .. code-block:: json

      {
          "count": 100,
          "next": "/api/[nombre]/?page=2",
          "previous": null,
          "results": [...]
      }

   **Parametros de paginacion:**

   .. list-table::
      :widths: 20 20 60
      :header-rows: 1

      * - Parametro
        - Default
        - Descripcion
      * - page
        - 1
        - Numero de pagina
      * - page_size
        - 20
        - Resultados por pagina (max: 100)

   **Ejemplo:**

   .. code-block:: bash

      curl "/api/[nombre]/?page=2&page_size=50"

   ----

   7. Filtros y Ordenamiento
   -------------------------

   7.1 Filtros Disponibles
   ^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 25 50
      :header-rows: 1

      * - Filtro
        - Tipo
        - Ejemplo
      * - [campo]
        - exact
        - ``?campo=valor``
      * - [campo]__contains
        - contains
        - ``?campo__contains=texto``
      * - [campo]__icontains
        - icontains
        - ``?campo__icontains=texto`` (case insensitive)
      * - [fecha]__gte
        - greater than or equal
        - ``?fecha__gte=2026-01-01``
      * - [fecha]__lte
        - less than or equal
        - ``?fecha__lte=2026-12-31``
      * - [campo]__in
        - in list
        - ``?campo__in=val1,val2,val3``
      * - is_active
        - boolean
        - ``?is_active=true``

   7.2 Ordenamiento
   ^^^^^^^^^^^^^^^^

   Usar parametro ``ordering``:

   .. code-block:: http

      GET /api/[nombre]/?ordering=-created_at

   - Prefijo ``-`` para orden descendente
   - Sin prefijo para orden ascendente
   - Multiples campos: ``?ordering=-created_at,nombre``

   **Campos ordenables:** [listar campos]

   ----

   8. Rate Limiting
   ----------------

   .. list-table::
      :widths: 30 70
      :header-rows: 0

      * - **Limite anonimo**
        - 100 requests/hora
      * - **Limite autenticado**
        - 1000 requests/hora
      * - **Header de estado**
        - ``X-RateLimit-Remaining``
      * - **Header de reset**
        - ``X-RateLimit-Reset``

   **Response 429 Too Many Requests:**

   .. code-block:: json

      {
          "detail": "Request was throttled. Expected available in 3600 seconds."
      }

   ----

   9. Manejo de Errores
   --------------------

   9.1 Formato de Error
   ^^^^^^^^^^^^^^^^^^^^

   .. code-block:: json

      {
          "detail": "Mensaje de error general",
          "code": "error_code"
      }

   9.2 Errores de Validacion (400)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: json

      {
          "campo_1": ["Este campo es requerido."],
          "campo_2": ["Asegurese de que este valor sea menor o igual a 100."]
      }

   9.3 Errores de Autenticacion (401)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: json

      {
          "detail": "Las credenciales de autenticacion no se proveyeron.",
          "code": "not_authenticated"
      }

   9.4 Errores de Permisos (403)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. code-block:: json

      {
          "detail": "No tiene permiso para realizar esta accion.",
          "code": "permission_denied"
      }

   ----

   10. Trazabilidad
   ----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Modulo**
        - MOD_[Nombre]
      * - **UC Relacionados**
        - UC_[MOD]_[NN], UC_[MOD]_[NN]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]
      * - **CNST Aplicables**
        - CNST_[NNN]
      * - **FD Relacionados**
        - FD_[NN]

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

Cada API DEBE incluir minimo estas 11 secciones:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - API, modulo, base URL, version, autenticacion
   * - 1
     - Descripcion General
     - Proposito de la API
   * - 2
     - Autenticacion
     - Metodo JWT, obtencion de token
   * - 3
     - Endpoints
     - Cada endpoint con request/response/curl
   * - 4
     - Codigos de Respuesta
     - Todos los HTTP status codes
   * - 5
     - Permisos RBAC
     - Funciones requeridas por endpoint
   * - 6
     - Paginacion
     - Formato y parametros
   * - 7
     - Filtros y Ordenamiento
     - Query parameters disponibles
   * - 8
     - Rate Limiting
     - Limites y headers
   * - 9
     - Manejo de Errores
     - Formatos de error por tipo
   * - 10
     - Trazabilidad
     - MOD, UC, BR, CNST, FD relacionados
   * - 11
     - Historial
     - Control de versiones

----

Validacion
----------

Antes de aprobar una API, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura API_[Nombre]
- [ ] Base URL especificada correctamente
- [ ] Todos los endpoints documentados (GET, POST, PUT, PATCH, DELETE)
- [ ] Request y Response para cada endpoint
- [ ] Query parameters documentados
- [ ] Body parameters documentados
- [ ] Codigos HTTP completos
- [ ] Permisos RBAC especificados por endpoint
- [ ] Ejemplos curl incluidos para cada endpoint
- [ ] Paginacion documentada
- [ ] Filtros y ordenamiento documentados
- [ ] Rate limiting especificado
- [ ] Formatos de error documentados

**Comando de validacion:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- MOD_*: Modulos que exponen la API
- UC_*: Casos de uso implementados
- FD_*: Flujos de datos relacionados
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
   * - 1.1.0
     - 2026-01-07
     - Equipo IACT
     - Version corregida: plantilla completa con todos los endpoints
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial (incompleta - deprecada)
