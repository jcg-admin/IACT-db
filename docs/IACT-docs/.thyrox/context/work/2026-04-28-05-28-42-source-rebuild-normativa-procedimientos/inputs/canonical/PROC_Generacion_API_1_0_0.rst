.. meta::
   :artefacto: PROC_Generacion_API
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-generacion-api:

=======================================================
PROC_Generacion_API: Generacion de Documentacion de API
=======================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_API
   * - **Nombre**
     - Generacion de Documentacion de API
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada API/endpoint a documentar
   * - **Duracion Estimada**
     - 30-60 minutos por API
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar documentacion de API
REST siguiendo el template TPL_API.

**Objetivo:** Crear documentacion de API completa con endpoints, request/response,
codigos de error y ejemplos curl.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Documentacion de APIs REST del proyecto IACT
- Endpoints CRUD y operaciones especiales
- APIs internas y externas

2.2 No Aplica A
^^^^^^^^^^^^^^^

- APIs de terceros (solo referencia)
- Documentacion OpenAPI generada automaticamente

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Desarrollador
     - Genera documentacion de API
     - Escritura en api/
   * - Arquitecto
     - Valida consistencia
     - Lectura

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] API implementada o especificada
- [ ] TPL_API revisado
- [ ] MOD relacionado identificado
- [ ] Estructura /tmp/api/ creada

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_API_Documentacion_API_1_1_0.rst
     - Template de API
     - Si
   * - MOD_[Nombre].rst
     - Modulo relacionado
     - Si
   * - FR relacionados
     - Requisitos que implementa
     - No

----

6. Procedimiento
----------------

6.1 Estructura de API Doc
^^^^^^^^^^^^^^^^^^^^^^^^^

Segun TPL_API v1.1.0:

1. Informacion General (base URL, autenticacion)
2. Endpoints (GET, POST, PUT, PATCH, DELETE)
3. Request/Response para cada endpoint
4. Codigos de Estado HTTP
5. Paginacion y Filtros
6. Permisos RBAC
7. Ejemplos curl

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Determinar Nomenclatura**

- **Responsable**: Desarrollador
- **Accion**: Asignar ID segun recurso:

  .. code-block:: text

     Formato: API_[Recurso]
     
     Ejemplos:
     - API_Users: Gestion de usuarios
     - API_Roles: Gestion de roles
     - API_Sessions: Gestion de sesiones
     - API_Reports: Generacion de reportes

- **Resultado**: ID asignado
- **Verificacion**: Recurso identificable

**Paso 2: Definir Informacion General**

- **Responsable**: Desarrollador
- **Accion**: Especificar base y autenticacion:

  .. code-block:: rst

     **Base URL:**
     
     ::
     
        https://api.iact.example.com/v1/
     
     **Autenticacion:**
     
     - Tipo: Bearer Token (JWT)
     - Header: ``Authorization: Bearer <token>``
     - Obtencion: POST /auth/token/

- **Resultado**: Info general completa
- **Verificacion**: URL y auth claros

**Paso 3: Documentar Endpoints**

- **Responsable**: Desarrollador
- **Accion**: Para cada endpoint, documentar:

  .. code-block:: rst

     GET /users/
     ^^^^^^^^^^^
     
     Lista usuarios con paginacion.
     
     **Request:**
     
     - Method: GET
     - URL: /api/v1/users/
     - Query params: page, page_size, search, ordering
     
     **Response 200:**
     
     .. code-block:: json
     
        {
          "count": 150,
          "next": "http://api/v1/users/?page=2",
          "previous": null,
          "results": [
            {
              "id": "uuid-001",
              "username": "jperez",
              "email": "jperez@example.com"
            }
          ]
        }

- **Resultado**: Endpoint documentado
- **Verificacion**: Request y response claros

**Paso 4: Documentar Request Body (POST/PUT)**

- **Responsable**: Desarrollador
- **Accion**: Especificar estructura de entrada:

  .. code-block:: rst

     POST /users/
     ^^^^^^^^^^^^
     
     Crea nuevo usuario.
     
     **Request Body:**
     
     .. code-block:: json
     
        {
          "username": "string (requerido, unico)",
          "email": "string (requerido, formato email)",
          "password": "string (requerido, min 8 chars)",
          "first_name": "string (opcional)",
          "last_name": "string (opcional)"
        }
     
     **Validaciones:**
     
     - username: 3-50 caracteres, alfanumerico
     - email: formato valido RFC 5322
     - password: minimo 8 caracteres, 1 mayuscula, 1 numero

- **Resultado**: Request body documentado
- **Verificacion**: Campos y validaciones claros

**Paso 5: Documentar Codigos de Error**

- **Responsable**: Desarrollador
- **Accion**: Listar codigos HTTP:

  .. code-block:: rst

     **Codigos de Estado:**
     
     .. list-table::
        :header-rows: 1
     
        * - Codigo
          - Significado
          - Cuando
        * - 200
          - OK
          - GET exitoso
        * - 201
          - Created
          - POST exitoso
        * - 400
          - Bad Request
          - Validacion fallida
        * - 401
          - Unauthorized
          - Token invalido/ausente
        * - 403
          - Forbidden
          - Sin permisos
        * - 404
          - Not Found
          - Recurso no existe
        * - 429
          - Too Many Requests
          - Rate limit excedido

- **Resultado**: Codigos documentados
- **Verificacion**: Todos los codigos posibles

**Paso 6: Documentar Permisos RBAC**

- **Responsable**: Desarrollador
- **Accion**: Especificar funciones requeridas:

  .. code-block:: rst

     **Permisos Requeridos:**
     
     .. list-table::
        :header-rows: 1
     
        * - Endpoint
          - Metodo
          - Funcion RBAC
        * - /users/
          - GET
          - FN_USR_VIEW
        * - /users/
          - POST
          - FN_USR_CREATE
        * - /users/{id}/
          - PUT
          - FN_USR_EDIT
        * - /users/{id}/
          - DELETE
          - FN_USR_DELETE

- **Resultado**: Permisos documentados
- **Verificacion**: Cada endpoint tiene permiso

**Paso 7: Agregar Ejemplos curl**

- **Responsable**: Desarrollador
- **Accion**: Incluir ejemplos ejecutables:

  .. code-block:: rst

     **Ejemplo: Listar usuarios**
     
     .. code-block:: bash
     
        curl -X GET "https://api.iact.example.com/v1/users/" \
          -H "Authorization: Bearer eyJ0eXAi..." \
          -H "Content-Type: application/json"
     
     **Ejemplo: Crear usuario**
     
     .. code-block:: bash
     
        curl -X POST "https://api.iact.example.com/v1/users/" \
          -H "Authorization: Bearer eyJ0eXAi..." \
          -H "Content-Type: application/json" \
          -d '{"username":"nuevo","email":"n@e.com","password":"Pass1234"}'

- **Resultado**: Ejemplos incluidos
- **Verificacion**: Ejemplos ejecutables

**Paso 8: Guardar y Validar**

- **Responsable**: Desarrollador
- **Accion**: Guardar y validar:

  .. code-block:: bash

     # Guardar
     /tmp/api/API_Users_1_0_0.rst
     
     # Validar
     sphinx-build -b html -W /tmp/api/ /tmp/build/

- **Resultado**: API doc guardada y validada
- **Verificacion**: Sin errores Sphinx

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - API_[Recurso]_X_Y_Z.rst
     - Documentacion de API
     - /tmp/api/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Todos los endpoints documentados
- [ ] Request/response para cada metodo
- [ ] Codigos de error listados
- [ ] Permisos RBAC especificados
- [ ] Ejemplos curl incluidos

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Base URL especificada
- [ ] Autenticacion documentada
- [ ] CRUD completo (GET, POST, PUT, DELETE)
- [ ] Response JSON con ejemplo real
- [ ] Al menos 5 codigos HTTP documentados
- [ ] Permisos RBAC por endpoint

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - API no implementada
     - Documentar como "propuesta"
   * - Endpoint sin RBAC
     - Marcar como publico o pendiente

----

11. Referencias
---------------

- TPL_API_Documentacion_API_1_1_0.rst
- MOD relacionado
- CNST_005: Seguridad DRF

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
     - 2026-01-07
     - Equipo IACT
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
