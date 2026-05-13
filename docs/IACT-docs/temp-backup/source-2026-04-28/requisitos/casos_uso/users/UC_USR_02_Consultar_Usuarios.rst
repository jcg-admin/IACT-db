.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Users
   :uc_id: UC_USR_02
   :normativa: CNST-009

=============================
UC_USR_02: Consultar Usuarios
=============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_USR_02
   * - **Nombre**
     - Consultar Usuarios
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Actor Secundario**
     - N/A
   * - **Modulo**
     - MOD_Users
   * - **Funcion RBAC**
     - USR-002: ve_usuarios, USR-005: lista_usuarios, USR-006: busca_usuarios
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Baja
   * - **BReq Origen**
     - BRQ-USR-002

2. Descripcion
--------------

Este caso de uso permite a un administrador de usuarios (AGR-006) consultar,
listar y buscar usuarios del sistema. Incluye capacidades de filtrado por
estado, segmento, agrupador y busqueda por texto.

**Caracteristicas principales:**

- Listar todos los usuarios con paginacion
- Filtrar por estado (ACTIVO, INACTIVO, BLOQUEADO, PENDIENTE, ELIMINADO)
- Filtrar por segmento de datos
- Filtrar por agrupador asignado
- Busqueda por texto (nombre, apellido, username, email)
- Ver detalle completo de un usuario
- Ordenamiento por columnas

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_USR_02

   @startuml

   left to right direction

   actor "AGR-006\nagr_admin_usuarios" as ADMIN <<AGR_ADMIN>>

   rectangle "MOD_Users" {
     usecase "UC_USR_02\nConsultar Usuarios" as UC02
     usecase "Listar\nUsuarios" as LIST
     usecase "Buscar\nUsuarios" as SEARCH
     usecase "Ver Detalle\nUsuario" as DETAIL
     usecase "Filtrar\nUsuarios" as FILTER
   }

   ADMIN --> UC02
   UC02 --> LIST : <<include>>
   UC02 --> SEARCH : <<extend>>
   UC02 --> FILTER : <<extend>>
   UC02 --> DETAIL : <<extend>>

   @enduml

4. Contexto de Ejecucion
------------------------

4.1 Precondiciones
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Precondicion
   * - PRE-01
     - El administrador tiene sesion activa valida
   * - PRE-02
     - El administrador tiene al menos una de las funciones: USR-002, USR-005, USR-006

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de gestion de usuarios.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se muestra lista de usuarios segun filtros aplicados
   * - POST-02
     - La consulta no modifica ningun dato

5. Flujo Normal (Camino Feliz)
------------------------------

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 1
     - Admin
     - Accede al modulo de gestion de usuarios
   * - 2
     - Sistema
     - Valida funcion USR-005 (lista_usuarios)
   * - 3
     - Sistema
     - Consulta usuarios con paginacion (pagina 1, 20 por pagina)
   * - 4
     - Sistema
     - Presenta tabla con: username, nombre, email, estado, segmento, ultimo acceso
   * - 5
     - Admin
     - Navega entre paginas si es necesario
   * - 6
     - Admin
     - Aplica filtros opcionales
   * - 7
     - Sistema
     - Actualiza lista segun filtros
   * - 8
     - Admin
     - Hace clic en un usuario para ver detalle
   * - 9
     - Sistema
     - Valida funcion USR-002 (ve_usuarios)
   * - 10
     - Sistema
     - Muestra panel de detalle con toda la informacion del usuario

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_USR_02

   @startuml

   actor "AGR-006\nAdmin" as A
   participant "Frontend\nUsers" as FE <<Frontend>>
   participant "UserController" as UC <<Backend>>
   participant "UserService" as US <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   == Listar Usuarios ==
   A -> FE: Accede a Gestion de Usuarios
   activate FE

   FE -> UC: GET /api/users?page=1&size=20
   activate UC

   UC -> UC: verify_function(USR-005)

   UC -> US: list_users(page, size, filters)
   activate US

   US -> DB: SELECT u.*, s.nombre as segmento\nFROM users u\nJOIN segmentos s ON u.segmento_id = s.id\nORDER BY u.created_at DESC\nLIMIT 20 OFFSET 0
   DB --> US: users_list

   US -> DB: SELECT COUNT(*) FROM users
   DB --> US: total_count

   US --> UC: {users, total, page, pages}
   deactivate US

   UC --> FE: 200 OK + users_paginated
   deactivate UC

   FE --> A: Muestra tabla de usuarios

   == Buscar Usuarios ==
   A -> FE: Ingresa texto en busqueda

   FE -> UC: GET /api/users?search=texto&page=1
   activate UC

   UC -> UC: verify_function(USR-006)

   UC -> US: search_users(texto)
   activate US

   US -> DB: SELECT * FROM users\nWHERE username ILIKE '%texto%'\nOR nombre ILIKE '%texto%'\nOR apellido ILIKE '%texto%'\nOR email ILIKE '%texto%'
   DB --> US: results

   US --> UC: users_found
   deactivate US

   UC --> FE: 200 OK + results
   deactivate UC

   FE --> A: Actualiza tabla con resultados

   == Ver Detalle ==
   A -> FE: Click en usuario

   FE -> UC: GET /api/users/{id}
   activate UC

   UC -> UC: verify_function(USR-002)

   UC -> US: get_user_detail(id)
   activate US

   US -> DB: SELECT u.*, \n  (SELECT json_agg(f.*) FROM user_functions uf\n   JOIN functions f ON uf.function_id = f.id\n   WHERE uf.user_id = u.id) as funciones\nFROM users u WHERE u.id = ?
   DB --> US: user_detail

   US --> UC: user_with_permissions
   deactivate US

   UC --> FE: 200 OK + user_detail
   deactivate UC

   FE --> A: Muestra panel de detalle
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Filtrar por Estado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Admin
     - Selecciona estado en filtro (ej: ACTIVO)
   * - 7a
     - Sistema
     - Agrega WHERE status = 'ACTIVO' a consulta
   * - 7b
     - Sistema
     - Muestra solo usuarios con ese estado

7.2 FA-02: Filtrar por Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Admin
     - Selecciona segmento en filtro
   * - 7a
     - Sistema
     - Agrega WHERE segmento_id = X a consulta
   * - 7b
     - Sistema
     - Muestra solo usuarios de ese segmento

7.3 FA-03: Ordenar por Columna
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 4a
     - Admin
     - Hace clic en encabezado de columna
   * - 4b
     - Sistema
     - Ordena por esa columna (ASC/DESC)
   * - 4c
     - Sistema
     - Actualiza tabla con nuevo orden

7.4 FA-04: Exportar Lista
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 5a
     - Admin
     - Hace clic en "Exportar"
   * - 5b
     - Sistema
     - Genera archivo CSV con usuarios filtrados
   * - 5c
     - Sistema
     - Descarga archivo (sin passwords ni datos sensibles)

8. Excepciones
--------------

8.1 EX-01: Sin Permiso para Listar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Administrador no tiene funcion USR-005
   * - **Accion Sistema**
     - Rechaza acceso al modulo
   * - **Mensaje Usuario**
     - "No tiene permisos para listar usuarios"
   * - **Codigo Error**
     - USR-010

8.2 EX-02: Sin Permiso para Ver Detalle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Administrador no tiene funcion USR-002
   * - **Accion Sistema**
     - Permite listar pero no ver detalle
   * - **Mensaje Usuario**
     - "No tiene permisos para ver detalle de usuario"
   * - **Codigo Error**
     - USR-011

8.3 EX-03: Usuario No Encontrado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - ID de usuario no existe
   * - **Accion Sistema**
     - Retorna error 404
   * - **Mensaje Usuario**
     - "Usuario no encontrado"
   * - **Codigo Error**
     - USR-012

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_USR_02

   @startuml

   start

   :Admin accede a Gestion de Usuarios;

   if (Tiene funcion USR-005?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Consultar usuarios paginados;

   :Mostrar tabla de usuarios;

   fork
     :Aplicar filtros;
     :Actualizar lista;
   fork again
     :Buscar por texto;
     if (Tiene funcion USR-006?) then (no)
       :Busqueda deshabilitada;
     else (si)
       :Ejecutar busqueda;
       :Mostrar resultados;
     endif
   fork again
     :Ordenar por columna;
     :Reordenar lista;
   fork again
     :Navegar paginas;
     :Cargar pagina;
   end fork

   :Admin selecciona usuario;

   if (Tiene funcion USR-002?) then (no)
     :Detalle no disponible;
     stop
   else (si)
   endif

   :Consultar detalle de usuario;

   :Mostrar panel de detalle;

   stop

   @enduml

10. Reglas de Negocio
---------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - ID
     - Regla
     - Descripcion
   * - BR-USR-10
     - Paginacion Obligatoria
     - Las consultas de usuarios siempre usan paginacion (max 100 por pagina) para evitar sobrecarga.
   * - BR-USR-11
     - Funciones Separadas
     - Listar (USR-005), buscar (USR-006) y ver detalle (USR-002) son funciones independientes.
   * - BR-USR-12
     - Sin Datos Sensibles
     - La lista nunca muestra passwords, tokens ni datos sensibles.
   * - BR-USR-13
     - Incluir Eliminados
     - Por defecto se excluyen usuarios ELIMINADO, pero puede filtrarse para verlos.

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-009
     - Auditoria Inmutable
     - Las consultas de lectura no generan registros de auditoria individuales. Solo se auditan accesos a datos sensibles o exportaciones.

**Nota sobre CNST-009:**

Este caso de uso es principalmente de lectura. No se registra cada consulta
en auditoria para evitar sobrecarga. Sin embargo, se puede habilitar logging
de acceso si se requiere por compliance.

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-USR-010
     - El sistema debe listar usuarios con paginacion
     - Maximo 100 usuarios por pagina, navegacion funcional
   * - FR-USR-011
     - El sistema debe permitir filtros multiples
     - Filtros por estado, segmento, agrupador combinables
   * - FR-USR-012
     - El sistema debe permitir busqueda por texto
     - Busqueda en username, nombre, apellido, email
   * - FR-USR-013
     - El sistema debe mostrar detalle completo
     - Incluye funciones asignadas, segmento, historial

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-USR-002: Permitir consulta de usuarios existentes
   * - **Reglas de Negocio**
     - BR-USR-10 a BR-USR-13
   * - **Restricciones**
     - CNST-009 (Auditoria - no aplica a lecturas)
   * - **FR Derivados**
     - FR-USR-010 a FR-USR-013
   * - **UC Relacionados**
     - UC_USR_01 (Crear Usuario), UC_USR_03 (Modificar Usuario)
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Funcion RBAC**
     - USR-002, USR-005, USR-006

14. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial v4.0 con funciones RBAC separadas