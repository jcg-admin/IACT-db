.. meta::
   :artefacto: MTM_03
   :tipo: Metamodelo
   :dominio: base_cognitiva
   :subdominio: _taxonomias_y_metamodelos
   :subcarpeta: metamodelos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _mtm-03:

=======================
MTM_03: Metamodelo RBAC
=======================


Proposito
---------

Este documento define el **metamodelo formal** del sistema de control de
acceso basado en roles (RBAC) del proyecto IACT. Especifica las entidades,
relaciones, cardinalidades y restricciones del modelo de seguridad.

----

1. Modelo NIST RBAC
-------------------

1.1 Niveles RBAC
^^^^^^^^^^^^^^^^

.. code-block:: text

   NIST RBAC LEVELS

   Level 0: Flat RBAC (IACT usa este nivel)
   - Usuarios, roles, permisos
   - Asignacion usuario-rol
   - Sin herencia de roles

   Level 1: Hierarchical RBAC
   - Herencia de roles
   - Roles padre/hijo

   Level 2: Constrained RBAC
   - Separacion de Funciones (SoD)
   - Restricciones estaticas y dinamicas

   Level 3: Symmetric RBAC
   - Revision de permisos
   - Auditoria completa

1.2 IACT: Flat RBAC + SoD
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   IACT implementa:
   - Flat RBAC (Level 0): Sin herencia de roles
   - SoD de Level 2: Separacion de Funciones estatica

   JUSTIFICACION:
   - Simplicidad operativa
   - Permisos explicitos (sin confusion por herencia)
   - SoD para compliance

----

2. Diagrama de Clases Principal
-------------------------------

2.1 Vista General
^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------+          +------------------+
   |     Usuario      |          |    Segmento      |
   +------------------+          +------------------+
   | - user_id: PK    |    N:1   | - segment_id: PK |
   | - username: UQ   +--------->| - nombre         |
   | - email: UQ      |          | - descripcion    |
   | - password_hash  |          +------------------+
   | - estado         |
   +--------+---------+
            |
            | N:N
            v
   +--------+---------+          +------------------+
   |       Rol        |    1:N   |     Permiso      |
   +------------------+<---------+------------------+
   | - role_id: PK    |          | - permission_id  |
   | - codigo: UQ     |          | - nombre         |
   | - nombre         |          | - recurso        |
   | - descripcion    |          | - accion         |
   +--------+---------+          +------------------+
            |
            | N:N (SoD)
            v
   +--------+---------+
   |   RolConflicto   |
   +------------------+
   | - rol_a: FK      |
   | - rol_b: FK      |
   | - razon          |
   +------------------+

2.2 Diagrama con Sesion
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------+       1:1 (activa)      +------------------+
   |     Usuario      |<----------------------->|     Sesion       |
   +------------------+                         +------------------+
   | - user_id        |                         | - session_id: PK |
   | - username       |                         | - user_id: FK    |
   | - estado         |                         | - ip_address     |
   +------------------+                         | - user_agent     |
            |                                   | - login_at       |
            |                                   | - last_activity  |
            | 1:N                               | - is_active      |
            v                                   +------------------+
   +------------------+
   |  RegistroAudit   |
   +------------------+
   | - log_id: PK     |
   | - user_id: FK    |
   | - timestamp      |
   | - action_type    |
   | - result         |
   +------------------+

----

3. Detalle de Entidades
-----------------------

3.1 Usuario
^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                          Usuario                                  |
   +------------------------------------------------------------------+
   | <<primary key>>                                                   |
   | - user_id: SERIAL                                                |
   |                                                                   |
   | <<unique>>                                                        |
   | - username: VARCHAR(100)                                         |
   | - email: VARCHAR(255)                                            |
   |                                                                   |
   | <<attributes>>                                                    |
   | - password_hash: VARCHAR(255)                                    |
   | - nombre_completo: VARCHAR(200)                                  |
   | - estado: EstadoUsuario                                          |
   | - segment_id: FK -> Segmento                                     |
   | - created_at: TIMESTAMP                                          |
   | - updated_at: TIMESTAMP                                          |
   | - last_login: TIMESTAMP                                          |
   | - failed_attempts: INTEGER DEFAULT 0                             |
   +------------------------------------------------------------------+
   | <<operations>>                                                    |
   | + autenticar(password): Boolean                                  |
   | + tienePermiso(permiso): Boolean                                 |
   | + tieneRol(rol): Boolean                                         |
   | + obtenerPermisosEfectivos(): Set<Permiso>                       |
   +------------------------------------------------------------------+

   INVARIANTES:
   - username es unico y no nulo
   - email es unico y no nulo
   - estado IN ('ACTIVO', 'INACTIVO', 'BLOQUEADO')
   - segment_id no es nulo

3.2 Rol
^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                            Rol                                    |
   +------------------------------------------------------------------+
   | <<primary key>>                                                   |
   | - role_id: SERIAL                                                |
   |                                                                   |
   | <<unique>>                                                        |
   | - codigo: VARCHAR(50)  // R001-R018                              |
   |                                                                   |
   | <<attributes>>                                                    |
   | - nombre: VARCHAR(100)                                           |
   | - descripcion: TEXT                                              |
   | - categoria: CategoriaRol                                        |
   | - is_active: BOOLEAN DEFAULT TRUE                                |
   +------------------------------------------------------------------+
   | <<operations>>                                                    |
   | + contienePermiso(permiso): Boolean                              |
   | + esCompatibleCon(otroRol): Boolean                              |
   | + obtenerPermisos(): Set<Permiso>                                |
   +------------------------------------------------------------------+

   CATALOGO CERRADO (18 roles):
   +-------+---------------------------+--------------------+
   | Codigo| Nombre                    | Categoria          |
   +-------+---------------------------+--------------------+
   | R001  | USERS_FULL_MANAGER        | Gestion Usuarios   |
   | R002  | USERS_VIEWER              | Gestion Usuarios   |
   | R003  | USERS_TEAM_MANAGER        | Gestion Usuarios   |
   | R004  | REPORTS_VIEWER            | Reportes           |
   | R005  | REPORTS_EXPORTER          | Reportes           |
   | R006  | REPORTS_ADVANCED_VIEWER   | Reportes           |
   | R007  | REPORTS_CREATOR           | Reportes           |
   | R008  | DASHBOARD_VIEWER          | Visualizacion      |
   | R009  | DASHBOARD_CUSTOMIZER      | Visualizacion      |
   | R010  | DATA_ANALYST              | Analisis           |
   | R011  | ALERTS_VIEWER             | Alertas            |
   | R012  | ALERTS_CONFIGURATOR       | Alertas            |
   | R013  | ALERTS_TEAM_MANAGER       | Alertas            |
   | R014  | ALERTS_GLOBAL_ADMIN       | Alertas            |
   | R015  | MODULES_ADMIN             | Administracion     |
   | R016  | SYSTEM_ADMIN              | Administracion     |
   | R017  | AUDIT_VIEWER              | Administracion     |
   | R018  | SECURITY_ADMIN            | Administracion     |
   +-------+---------------------------+--------------------+

3.3 Permiso
^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                          Permiso                                  |
   +------------------------------------------------------------------+
   | <<primary key>>                                                   |
   | - permission_id: SERIAL                                          |
   |                                                                   |
   | <<unique>>                                                        |
   | - nombre: VARCHAR(100)  // recurso.accion[.modificador]          |
   |                                                                   |
   | <<attributes>>                                                    |
   | - descripcion: TEXT                                              |
   | - recurso: VARCHAR(50)                                           |
   | - accion: VARCHAR(50)                                            |
   | - modificador: VARCHAR(50) NULLABLE                              |
   +------------------------------------------------------------------+

   FORMATO NOMBRE:
   {recurso}.{accion}[.{modificador}]

   EJEMPLOS:
   - users.create
   - users.read
   - reports.view
   - reports.export.csv
   - reports.export.excel
   - audit.logs.view

3.4 Segmento
^^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                         Segmento                                  |
   +------------------------------------------------------------------+
   | <<primary key>>                                                   |
   | - segment_id: SERIAL                                             |
   |                                                                   |
   | <<unique>>                                                        |
   | - codigo: VARCHAR(50)                                            |
   |                                                                   |
   | <<attributes>>                                                    |
   | - nombre: VARCHAR(100)                                           |
   | - descripcion: TEXT                                              |
   | - filtro_sql: TEXT  // Clausula WHERE para filtrar datos         |
   +------------------------------------------------------------------+

   INSTANCIAS CONOCIDAS:
   +---------------------+--------------------------------+
   | Codigo              | Filtro SQL                     |
   +---------------------+--------------------------------+
   | DATOS_CONSOLIDADOS  | 1=1 (sin filtro)              |
   | CENTRO_NORTE        | centro_id IN (1,2,3)          |
   | CENTRO_SUR          | centro_id IN (4,5,6)          |
   | CENTRO_ORIENTE      | centro_id IN (7,8)            |
   | CENTRO_OCCIDENTE    | centro_id IN (9,10)           |
   +---------------------+--------------------------------+

3.5 Sesion
^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                          Sesion                                   |
   +------------------------------------------------------------------+
   | <<primary key>>                                                   |
   | - session_id: VARCHAR(255)                                       |
   |                                                                   |
   | <<foreign key>>                                                   |
   | - user_id: FK -> Usuario                                         |
   |                                                                   |
   | <<attributes>>                                                    |
   | - ip_address: VARCHAR(45)                                        |
   | - user_agent: VARCHAR(500)                                       |
   | - login_at: TIMESTAMP                                            |
   | - last_activity: TIMESTAMP                                       |
   | - logout_at: TIMESTAMP NULLABLE                                  |
   | - logout_reason: VARCHAR(50) NULLABLE                            |
   | - is_active: BOOLEAN DEFAULT TRUE                                |
   +------------------------------------------------------------------+

   RESTRICCION CRITICA:
   Solo UNA sesion activa por usuario (sesion unica).

   CONSTRAINT:
   CREATE UNIQUE INDEX idx_unique_active_session
   ON sessions (user_id) WHERE is_active = TRUE;

----

4. Tablas de Relacion
---------------------

4.1 Usuario_Rol (N:N)
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                        user_roles                                 |
   +------------------------------------------------------------------+
   | <<composite key>>                                                 |
   | - user_id: FK -> Usuario                                         |
   | - role_id: FK -> Rol                                             |
   |                                                                   |
   | <<attributes>>                                                    |
   | - assigned_at: TIMESTAMP                                         |
   | - assigned_by: FK -> Usuario                                     |
   | - justificacion: TEXT (min 20 chars)                             |
   +------------------------------------------------------------------+

   REGLA:
   Usuario debe tener al menos 1 rol.

4.2 Rol_Permiso (1:N)
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                       role_permissions                            |
   +------------------------------------------------------------------+
   | <<composite key>>                                                 |
   | - role_id: FK -> Rol                                             |
   | - permission_id: FK -> Permiso                                   |
   +------------------------------------------------------------------+

   REGLA:
   Rol debe tener al menos 1 permiso.

4.3 Rol_Conflicto (SoD)
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   +------------------------------------------------------------------+
   |                       role_conflicts                              |
   +------------------------------------------------------------------+
   | <<composite key>>                                                 |
   | - role_a: FK -> Rol                                              |
   | - role_b: FK -> Rol                                              |
   |                                                                   |
   | <<attributes>>                                                    |
   | - razon: TEXT                                                    |
   +------------------------------------------------------------------+

   PARES CONFLICTIVOS IACT:
   +-------+-------+------------------------------------+
   | Rol A | Rol B | Razon                              |
   +-------+-------+------------------------------------+
   | R016  | R017  | Operador NO debe auditar           |
   | R001  | R017  | Gestor usuarios NO debe auditar    |
   +-------+-------+------------------------------------+

   PROPIEDAD:
   La relacion es SIMETRICA: si (A,B) existe, (B,A) esta implicito.

----

5. Diagrama ER Completo
-----------------------

.. code-block:: text

   ┌─────────────┐       ┌─────────────┐       ┌─────────────┐
   │  Segmento   │       │   Usuario   │       │   Sesion    │
   ├─────────────┤       ├─────────────┤       ├─────────────┤
   │ segment_id  │<──────│ segment_id  │───────│ user_id     │
   │ codigo      │  N:1  │ user_id     │  1:1  │ session_id  │
   │ nombre      │       │ username    │(activa)│ is_active   │
   └─────────────┘       │ email       │       └─────────────┘
                         │ estado      │
                         └──────┬──────┘
                                │
                                │ N:N
                                │
                         ┌──────┴──────┐
                         │ user_roles  │
                         ├─────────────┤
                         │ user_id     │
                         │ role_id     │
                         │ assigned_by │
                         └──────┬──────┘
                                │
                                │
                         ┌──────┴──────┐       ┌─────────────┐
                         │     Rol     │       │role_conflicts│
                         ├─────────────┤       ├─────────────┤
                         │ role_id     │<──────│ role_a      │
                         │ codigo      │  N:N  │ role_b      │
                         │ nombre      │ (SoD) │ razon       │
                         └──────┬──────┘       └─────────────┘
                                │
                                │ 1:N
                                │
                         ┌──────┴──────┐
                         │role_perms   │
                         ├─────────────┤
                         │ role_id     │
                         │ permission_id│
                         └──────┬──────┘
                                │
                                │
                         ┌──────┴──────┐
                         │   Permiso   │
                         ├─────────────┤
                         │permission_id │
                         │ nombre      │
                         │ recurso     │
                         │ accion      │
                         └─────────────┘

----

6. Algoritmos Clave
-------------------

6.1 Verificar Permiso
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FUNCION tienePermiso(usuario_id, permiso_nombre): Boolean

   ALGORITMO:
   1. Obtener roles del usuario
      SELECT role_id FROM user_roles WHERE user_id = @usuario_id

   2. Para cada rol, obtener permisos
      SELECT permission_id FROM role_permissions WHERE role_id IN (roles)

   3. Verificar si permiso existe en conjunto
      RETURN permiso_nombre IN permisos_usuario

   SQL EQUIVALENTE:
   SELECT EXISTS (
     SELECT 1 FROM user_roles ur
     JOIN role_permissions rp ON ur.role_id = rp.role_id
     JOIN permissions p ON rp.permission_id = p.permission_id
     WHERE ur.user_id = @usuario_id
     AND p.nombre = @permiso_nombre
   );

6.2 Validar SoD
^^^^^^^^^^^^^^^

.. code-block:: text

   FUNCION validarSoD(usuario_id, nuevo_rol_id): Boolean

   ALGORITMO:
   1. Obtener roles actuales del usuario
   2. Verificar si nuevo_rol tiene conflicto con alguno existente
   3. Retornar TRUE si no hay conflicto

   SQL:
   SELECT NOT EXISTS (
     SELECT 1 FROM user_roles ur
     JOIN role_conflicts rc ON
       (ur.role_id = rc.role_a AND @nuevo_rol_id = rc.role_b)
       OR
       (ur.role_id = rc.role_b AND @nuevo_rol_id = rc.role_a)
     WHERE ur.user_id = @usuario_id
   );

6.3 Obtener Permisos Efectivos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FUNCION obtenerPermisosEfectivos(usuario_id): Set<Permiso>

   ALGORITMO:
   1. Obtener todos los roles del usuario
   2. Para cada rol, obtener sus permisos
   3. Unir todos los permisos (UNION)
   4. Retornar conjunto resultante

   SQL:
   SELECT DISTINCT p.*
   FROM users u
   JOIN user_roles ur ON u.user_id = ur.user_id
   JOIN role_permissions rp ON ur.role_id = rp.role_id
   JOIN permissions p ON rp.permission_id = p.permission_id
   WHERE u.user_id = @usuario_id;

   NOTA:
   Flat RBAC = UNION simple, sin herencia.

----

7. Restricciones del Modelo
---------------------------

7.1 Restricciones de Integridad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 10 45 45

   * - #
     - Restriccion
     - Implementacion
   * - R1
     - Usuario tiene exactamente 1 segmento
     - FK NOT NULL
   * - R2
     - Usuario tiene al menos 1 rol
     - Trigger/Aplicacion
   * - R3
     - Rol tiene al menos 1 permiso
     - CHECK en insert
   * - R4
     - Sesion activa unica por usuario
     - UNIQUE INDEX parcial
   * - R5
     - Username y email unicos
     - UNIQUE constraints
   * - R6
     - SoD: roles conflictivos no coexisten
     - Trigger en user_roles

7.2 OCL Constraints
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   -- Usuario debe tener al menos un rol
   context Usuario
   inv: self.roles->size() >= 1

   -- Rol debe tener al menos un permiso
   context Rol
   inv: self.permisos->size() >= 1

   -- Usuario no puede tener roles conflictivos
   context Usuario
   inv: self.roles->forAll(r1, r2 |
        r1 <> r2 implies not r1.conflictoCon(r2))

   -- Sesion activa es unica
   context Usuario
   inv: self.sesiones->select(s | s.is_active)->size() <= 1

   -- Estado usuario valido
   context Usuario
   inv: Set{'ACTIVO','INACTIVO','BLOQUEADO'}->includes(self.estado)

----

8. Estadisticas IACT
--------------------

8.1 Volumetria Esperada
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Entidad
     - Cantidad
     - Notas
   * - Usuarios
     - 50-100
     - Organizacion mediana
   * - Roles
     - 18
     - Catalogo cerrado
   * - Permisos
     - ~150
     - Por modulo funcional
   * - Segmentos
     - 5-10
     - Por centro + consolidado
   * - Sesiones activas
     - 20-40
     - Concurrencia tipica
   * - Conflictos SoD
     - 2
     - Pares definidos

8.2 Permisos por Rol
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 35 25 25

   * - Rol
     - Nombre
     - Permisos
     - Tipo
   * - R002
     - USERS_VIEWER
     - 7
     - Solo lectura
   * - R004
     - REPORTS_VIEWER
     - 12
     - Solo lectura
   * - R001
     - USERS_FULL_MANAGER
     - 28
     - CRUD completo
   * - R016
     - SYSTEM_ADMIN
     - 35
     - Administracion

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`sbvr-01` - Conceptos Nucleares (Usuario, Rol, Permiso)
- :ref:`sbvr-02` - Fact Types (relaciones)
- :ref:`sbvr-04` - Reglas Operativas (DEO-007 SoD)
- Modelo_RBAC_Completo_IACT

Fuentes
^^^^^^^

- NIST RBAC Model (Ferraiolo, Sandhu, Kuhn)
- ANSI INCITS 359-2004: RBAC Standard
- Sandhu: "Role-Based Access Control Models"

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
   * - 1.0.0
     - 2025-12-20
     - Equipo IACT
     - Version inicial con modelo RBAC completo

----

**Trazabilidad:** Este metamodelo es el core de seguridad de IACT.
Define la estructura formal del control de acceso documentado en
Modelo_RBAC_Completo_IACT y referenciado en los UC de gestion
de usuarios (UC-005 a UC-011).

**Catalogo poblado:** la materializacion concreta de este metamodelo
(las 42 funciones, los 10 grupos, las 3 reglas SoD, la politica de
permisos temporales) esta en :ref:`cnst-012`.

**Regla de negocio asociada:** :ref:`br-006`.
