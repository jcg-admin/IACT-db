.. meta::
   :artefacto: BReq_003
   :tipo: Requisito de Negocio
   :dominio: requisitos
   :subdominio: requisitos_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _breq-003:

==============================================================================
BReq_003: Gestionar Accesos y Permisos
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Identificacion
--------------

.. list-table::
   :widths: 25 75
   :stub-columns: 1

   * - ID
     - BReq_003
   * - Nombre
     - Gestionar Accesos y Permisos
   * - Categoria
     - Funcional / Seguridad
   * - Prioridad
     - **Critica**
   * - Stakeholder
     - Administradores de Sistema, Seguridad IT
   * - Deriva de
     - BR_003 (RBAC Flat)

----

1. Declaracion del Requisito
----------------------------

1.1 Enunciado
^^^^^^^^^^^^^

.. admonition:: BReq_003 - Requisito de Negocio
   :class: important

   **"El negocio NECESITA que los administradores puedan gestionar usuarios,
   asignar roles y controlar permisos de acceso al sistema, garantizando
   que cada usuario tenga exactamente los privilegios necesarios para su
   funcion y nada mas (principio de minimo privilegio)."**

1.2 Contexto de Negocio
^^^^^^^^^^^^^^^^^^^^^^^

El sistema IACT maneja datos sensibles del call center. Es critico que:

- Solo personal autorizado acceda al sistema
- Cada usuario tenga permisos apropiados a su rol
- Los accesos sean auditables y trazables
- Se pueda revocar acceso rapidamente cuando sea necesario

1.3 Problema que Resuelve
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   SITUACION ACTUAL (sin gestion centralizada):
   
   - Permisos gestionados manualmente por TI
   - Proceso lento para onboarding de usuarios
   - Dificil saber quien tiene acceso a que
   - Riesgo de permisos acumulados (privilege creep)
   
   SITUACION DESEADA (con gestion en IACT):
   
   - Administradores gestionan usuarios autonomamente
   - Onboarding en minutos, no dias
   - Visibilidad clara de permisos por usuario
   - Principio de minimo privilegio aplicado

----

2. Restricciones Aplicables
---------------------------

2.1 De BR_003 (RBAC Flat)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Modelo RBAC sin jerarquia
   
   - 17 roles funcionales predefinidos
   - Usuarios pueden tener multiples roles
   - No hay herencia automatica de permisos
   - Permisos se calculan como UNION de roles
   
   IMPLICACION PARA GESTION:
   - Administrador asigna roles, no permisos individuales
   - Cambios de rol son efectivos inmediatamente
   - Perfiles predefinidos simplifican asignacion

2.2 Separacion de Funciones (SoD)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RESTRICCION: Roles mutuamente excluyentes
   
   - R016 (SYSTEM_ADMIN) y R017 (AUDIT_VIEWER) son incompatibles
   - R001 (USERS_MANAGER) y R017 (AUDIT_VIEWER) son incompatibles
   
   IMPLICACION PARA GESTION:
   - Sistema advierte al asignar roles conflictivos
   - Se requiere justificacion para excepciones
   - Excepciones quedan registradas en audit_logs

----

3. Funcionalidades Requeridas
-----------------------------

3.1 Gestion de Usuarios
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 45 30

   * - Funcion
     - Descripcion
     - Rol Requerido
   * - Crear usuario
     - Alta de nuevo usuario con datos basicos
     - R001
   * - Modificar usuario
     - Editar datos (nombre, email, estado)
     - R001, R003 (solo su equipo)
   * - Desactivar usuario
     - Deshabilitar acceso sin eliminar
     - R001
   * - Resetear contraseña
     - Forzar cambio de contraseña
     - R001
   * - Ver usuarios
     - Listar y buscar usuarios
     - R002

3.2 Gestion de Roles
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 45 30

   * - Funcion
     - Descripcion
     - Rol Requerido
   * - Asignar rol
     - Agregar rol a usuario
     - R001
   * - Revocar rol
     - Quitar rol de usuario
     - R001
   * - Asignar perfil
     - Aplicar perfil predefinido
     - R001
   * - Ver roles de usuario
     - Consultar roles asignados
     - R002
   * - Auditar cambios
     - Ver historial de asignaciones
     - R017

3.3 Perfiles Predefinidos
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 40 35

   * - Perfil
     - Roles Incluidos
     - Uso Tipico
   * - BASICO
     - R004, R008, R011
     - Usuarios operativos
   * - ANALISTA
     - R005-R007, R009, R012
     - Analistas de datos
   * - ADMIN_SEGMENTO
     - R003, R006, R009, R013
     - Supervisores de equipo
   * - ADMINISTRADOR
     - R001, R014-R016, R018
     - Administradores IT

----

4. Criterios de Exito
---------------------

4.1 Criterios Medibles
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Criterio
     - Meta
     - Medicion
   * - Tiempo de creacion de usuario
     - < 2 minutos
     - Cronometro en prueba
   * - Tiempo de asignacion de rol
     - < 30 segundos
     - Cronometro en prueba
   * - Efectividad inmediata de cambios
     - < 5 segundos
     - Test automatizado
   * - Cobertura de audit_logs
     - 100% de acciones
     - Revision de logs

4.2 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: gherkin

   Escenario: Crear nuevo usuario
     Dado que el administrador tiene rol R001
     Cuando el administrador completa el formulario de nuevo usuario
     Y hace clic en "Crear Usuario"
     Entonces el sistema DEBE crear el usuario
     Y el sistema DEBE asignar perfil BASICO por defecto
     Y el sistema DEBE enviar email de activacion
     Y el sistema DEBE registrar la accion en audit_logs

   Escenario: Asignar rol a usuario
     Dado que el administrador tiene rol R001
     Y existe un usuario "maria"
     Cuando el administrador asigna rol R005 a "maria"
     Entonces el rol DEBE estar activo inmediatamente
     Y "maria" DEBE poder exportar datos (permiso de R005)
     Y el cambio DEBE quedar en audit_logs

   Escenario: Detectar conflicto SoD
     Dado que el usuario "pedro" tiene rol R016 (SYSTEM_ADMIN)
     Cuando el administrador intenta asignar R017 (AUDIT_VIEWER)
     Entonces el sistema DEBE mostrar advertencia de conflicto
     Y el sistema DEBE solicitar justificacion
     Y si se proporciona justificacion, el sistema DEBE permitir
     Y la excepcion DEBE quedar registrada en audit_logs

   Escenario: Desactivar usuario
     Dado que el usuario "juan" esta activo
     Cuando el administrador desactiva a "juan"
     Entonces "juan" NO DEBE poder iniciar sesion
     Y las sesiones activas de "juan" DEBEN terminar
     Y el estado DEBE quedar en audit_logs

   Escenario: Administrador de segmento solo ve su equipo
     Dado que el usuario tiene rol R003 (USERS_TEAM_MANAGER)
     Cuando el usuario accede a la lista de usuarios
     Entonces solo DEBE ver usuarios de su segmento de datos
     Y NO DEBE ver usuarios de otros segmentos

----

5. Seguridad y Auditoria
------------------------

5.1 Registro de Acciones
^^^^^^^^^^^^^^^^^^^^^^^^

Todas las acciones de gestion se registran:

.. code-block:: python

   # Ejemplo de entrada en audit_logs
   {
       "action": "USER_ROLE_ASSIGNED",
       "actor_id": 1,           # Admin que hizo el cambio
       "target_id": 45,         # Usuario afectado
       "timestamp": "2025-12-22T10:30:00Z",
       "details": {
           "role_id": "R005",
           "role_name": "REPORTS_EXPORTER",
           "justification": null,   # null si no hay conflicto SoD
           "previous_roles": ["R004", "R008"],
           "new_roles": ["R004", "R005", "R008"]
       },
       "ip_address": "192.168.1.100",
       "user_agent": "Mozilla/5.0..."
   }

5.2 Alertas de Seguridad
^^^^^^^^^^^^^^^^^^^^^^^^

El sistema genera alertas automaticas cuando:

- Se asigna rol de administrador (R001, R016, R018)
- Se crea excepcion SoD
- Un usuario intenta acceder sin permisos (multiples veces)
- Se desactiva un usuario con rol administrativo

----

6. Trazabilidad
---------------

6.1 Hacia Arriba (Origen)
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq_003
     │
     └──▶ BR_003: Control de Acceso RBAC Flat
           │
           ├── 17 roles funcionales
           ├── Perfiles predefinidos
           └── Reglas SoD

6.2 Hacia Abajo (Deriva)
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq_003
     │
     └──▶ UC_003: Gestionar Roles de Usuario
           │
           ├──▶ FR_004: Crear Usuario
           └──▶ FR_005: Asignar Rol

6.3 Matriz de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 25 25

   * - BR
     - BReq
     - UC
     - FR
     - TST
   * - BR_003
     - **BReq_003**
     - UC_003
     - FR_004, FR_005
     - TST_UC_003

----

7. Historial de Cambios
-----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Creacion inicial

----

Referencias
-----------

- :ref:`br-003` - Control de Acceso RBAC Flat
- :ref:`gob-02` - Roles y Matriz RACI
- :ref:`uc-003` - Gestionar Roles de Usuario (pendiente)
