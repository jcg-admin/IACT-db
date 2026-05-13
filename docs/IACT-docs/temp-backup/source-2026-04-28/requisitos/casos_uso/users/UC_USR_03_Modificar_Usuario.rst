.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Users
   :uc_id: UC_USR_03
   :normativa: CNST-001, CNST-005, CNST-009

============================
UC_USR_03: Modificar Usuario
============================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_USR_03
   * - **Nombre**
     - Modificar Usuario
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Actor Secundario**
     - Usuario afectado (recibe notificacion si aplica)
   * - **Modulo**
     - MOD_Users
   * - **Funcion RBAC**
     - USR-003: modifica_usuarios, USR-007: bloquea_usuarios, USR-008: desbloquea_usuarios, USR-009: reactiva_usuarios
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-USR-003

2. Descripcion
--------------

Este caso de uso permite a un administrador de usuarios (AGR-006) modificar
los datos de un usuario existente, incluyendo cambios de estado. Los cambios
de estado criticos se notifican via buzon interno (CNST-001).

**Caracteristicas principales:**

- Modificar datos basicos (nombre, apellido, email)
- Cambiar segmento asignado
- Bloquear usuario (USR-007)
- Desbloquear usuario (USR-008)
- Reactivar usuario inactivo (USR-009)
- El username NO es modificable (CNST-005)
- Notificaciones via buzon interno (CNST-001)
- Registro completo en auditoria (CNST-009)

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_USR_03

   @startuml

   left to right direction

   actor "AGR-006\nagr_admin_usuarios" as ADMIN <<AGR_ADMIN>>
   actor "Usuario\nAfectado" as USER
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Users" {
     usecase "UC_USR_03\nModificar Usuario" as UC03
     usecase "Editar Datos\nBasicos" as EDIT
     usecase "Bloquear\nUsuario" as BLOCK
     usecase "Desbloquear\nUsuario" as UNLOCK
     usecase "Reactivar\nUsuario" as REACT
     usecase "Notificar\nCambios" as NOT
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC03
   UC03 --> EDIT : <<extend>>
   UC03 --> BLOCK : <<extend>>
   UC03 --> UNLOCK : <<extend>>
   UC03 --> REACT : <<extend>>
   UC03 --> NOT : <<include>>
   UC03 --> AUD : <<include>>
   NOT --> USER : InternalMessage
   SYS --> AUD

   note right of NOT
     CNST-001: Solo buzon interno
     para cambios de estado
   end note

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
     - El administrador tiene sesion activa con funcion USR-003
   * - PRE-02
     - El usuario a modificar existe en el sistema
   * - PRE-03
     - El usuario a modificar no es el mismo administrador (para bloqueo)

4.2 Trigger
^^^^^^^^^^^

El administrador selecciona un usuario y hace clic en "Editar" o una accion
especifica (bloquear, desbloquear, reactivar).

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Los datos del usuario se actualizan en base de datos
   * - POST-02
     - Si cambio estado, se notifica via InternalMessage (CNST-001)
   * - POST-03
     - Se registra USER_UPDATE en auditoria (CNST-009)
   * - POST-04
     - Si se bloqueo, se cierran todas las sesiones activas

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
     - Selecciona usuario de la lista (UC_USR_02)
   * - 2
     - Admin
     - Hace clic en "Editar Usuario"
   * - 3
     - Sistema
     - Valida funcion USR-003 (modifica_usuarios)
   * - 4
     - Sistema
     - Presenta formulario con datos actuales
   * - 5
     - Admin
     - Modifica campos deseados (nombre, apellido, email)
   * - 6
     - Admin
     - Opcionalmente cambia segmento
   * - 7
     - Admin
     - Presiona "Guardar Cambios"
   * - 8
     - Sistema
     - Valida formato de campos
   * - 9
     - Sistema
     - Verifica unicidad de email si cambio
   * - 10
     - Sistema
     - Actualiza registro en base de datos
   * - 11
     - Sistema
     - Registra USER_UPDATE en UserActionLog (CNST-009)
   * - 12
     - Sistema
     - Muestra confirmacion de cambios guardados

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_USR_03

   @startuml

   actor "AGR-006\nAdmin" as A
   participant "Frontend\nUsers" as FE <<Frontend>>
   participant "UserController" as UC <<Backend>>
   participant "UserService" as US <<Service>>
   participant "SessionService" as SS <<Service>>
   participant "InternalMessage" as IM <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Click "Editar Usuario"
   activate FE

   FE -> UC: GET /api/users/{id}
   UC --> FE: user_data

   FE -> FE: Muestra formulario con datos
   A -> FE: Modifica campos
   A -> FE: Click "Guardar"

   FE -> UC: PUT /api/users/{id}\n{nombre, apellido, email, segmento_id}
   activate UC

   == Validar Permisos ==
   UC -> UC: verify_function(USR-003)

   UC -> US: update_user(id, data, admin)
   activate US

   == Validar Datos ==
   US -> DB: SELECT * FROM users WHERE id = ?
   DB --> US: current_user

   alt email cambio
     US -> DB: SELECT * FROM users\nWHERE email = ? AND id != ?
     DB --> US: existing
     alt email duplicado
       US --> UC: EmailExistsError
       UC --> FE: 409 Conflict
     end
   end

   == Detectar Cambios ==
   US -> US: diff(current_user, new_data)

   == Actualizar Usuario ==
   US -> DB: UPDATE users SET\nnombre = ?, apellido = ?,\nemail = ?, segmento_id = ?,\nupdated_at = now(), updated_by = ?

   == Registrar Auditoria (CNST-009) ==
   US -> UAL: record(USER_UPDATE, admin, user, changes)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Incluye campos modificados
     (old_value -> new_value)
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> US: logged
   deactivate UAL

   US --> UC: {success: true, changes: [...]}
   deactivate US

   UC --> FE: 200 OK
   deactivate UC

   FE --> A: Confirmacion: Cambios guardados
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Bloquear Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 2a
     - Admin
     - Hace clic en "Bloquear Usuario"
   * - 3a
     - Sistema
     - Valida funcion USR-007 (bloquea_usuarios)
   * - 4a
     - Sistema
     - Muestra dialogo: motivo del bloqueo (obligatorio)
   * - 5a
     - Admin
     - Ingresa motivo y confirma
   * - 6a
     - Sistema
     - Cambia estado a BLOQUEADO
   * - 7a
     - Sistema
     - Cierra todas las sesiones activas del usuario
   * - 8a
     - Sistema
     - Envia InternalMessage notificando bloqueo (CNST-001)
   * - 9a
     - Sistema
     - Registra USER_BLOCKED en auditoria

7.2 FA-02: Desbloquear Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 2a
     - Admin
     - Hace clic en "Desbloquear Usuario"
   * - 3a
     - Sistema
     - Valida funcion USR-008 (desbloquea_usuarios)
   * - 4a
     - Sistema
     - Valida que estado actual sea BLOQUEADO
   * - 5a
     - Sistema
     - Cambia estado a ACTIVO
   * - 6a
     - Sistema
     - Envia InternalMessage notificando desbloqueo (CNST-001)
   * - 7a
     - Sistema
     - Registra USER_UNBLOCKED en auditoria

7.3 FA-03: Reactivar Usuario Inactivo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 2a
     - Admin
     - Hace clic en "Reactivar Usuario"
   * - 3a
     - Sistema
     - Valida funcion USR-009 (reactiva_usuarios)
   * - 4a
     - Sistema
     - Valida que estado actual sea INACTIVO
   * - 5a
     - Sistema
     - Cambia estado a ACTIVO
   * - 6a
     - Sistema
     - Envia InternalMessage notificando reactivacion (CNST-001)
   * - 7a
     - Sistema
     - Registra USER_REACTIVATED en auditoria

8. Excepciones
--------------

8.1 EX-01: Sin Permiso USR-003
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - Administrador no tiene funcion USR-003
   * - **Accion Sistema**
     - Rechaza modificacion
   * - **Mensaje Usuario**
     - "No tiene permisos para modificar usuarios"
   * - **Codigo Error**
     - USR-020

8.2 EX-02: Usuario No Encontrado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 4
   * - **Condicion**
     - ID de usuario no existe
   * - **Accion Sistema**
     - Retorna error 404
   * - **Mensaje Usuario**
     - "Usuario no encontrado"
   * - **Codigo Error**
     - USR-021

8.3 EX-03: Auto-Bloqueo No Permitido
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - FA-01, paso 3a
   * - **Condicion**
     - Admin intenta bloquearse a si mismo
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - "No puede bloquear su propia cuenta"
   * - **Codigo Error**
     - USR-022

8.4 EX-04: Estado Invalido para Operacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - FA-02, FA-03
   * - **Condicion**
     - Estado actual no permite la operacion solicitada
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - "El estado actual del usuario no permite esta operacion"
   * - **Codigo Error**
     - USR-023

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_USR_03

   @startuml

   start

   :Admin selecciona usuario;

   switch (Accion?)
   case (Editar datos)
     if (Tiene USR-003?) then (no)
       :Error permisos;
       stop
     else (si)
     endif
     :Mostrar formulario;
     :Admin modifica campos;
     :Validar datos;
     :Actualizar registro;

   case (Bloquear)
     if (Tiene USR-007?) then (no)
       :Error permisos;
       stop
     else (si)
     endif
     if (Es auto-bloqueo?) then (si)
       :Error: No puede bloquearse;
       stop
     else (no)
     endif
     :Solicitar motivo;
     :Cambiar estado a BLOQUEADO;
     :Cerrar sesiones activas;
     :Notificar via buzon;
     note right: CNST-001

   case (Desbloquear)
     if (Tiene USR-008?) then (no)
       :Error permisos;
       stop
     else (si)
     endif
     :Cambiar estado a ACTIVO;
     :Notificar via buzon;

   case (Reactivar)
     if (Tiene USR-009?) then (no)
       :Error permisos;
       stop
     else (si)
     endif
     :Cambiar estado a ACTIVO;
     :Notificar via buzon;

   endswitch

   :Registrar en auditoria;
   note right: CNST-009

   :Mostrar confirmacion;

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
   * - BR-USR-20
     - Username Inmutable
     - El username nunca puede modificarse despues de creado (CNST-005).
   * - BR-USR-21
     - Motivo Obligatorio
     - El bloqueo de usuario requiere motivo obligatorio que se registra en auditoria.
   * - BR-USR-22
     - Sin Auto-Bloqueo
     - Un administrador no puede bloquear su propia cuenta.
   * - BR-USR-23
     - Cierre de Sesiones
     - Al bloquear un usuario, todas sus sesiones activas se cierran automaticamente.
   * - BR-USR-24
     - Notificacion de Estado
     - Cambios de estado (bloqueo, desbloqueo, reactivacion) se notifican al usuario afectado.
   * - BR-USR-25
     - Transiciones Validas
     - ACTIVO puede ir a BLOQUEADO o INACTIVO. BLOQUEADO solo puede ir a ACTIVO. INACTIVO solo puede ir a ACTIVO.

11. Restricciones de Arquitectura
---------------------------------

.. list-table::
   :widths: 15 25 60
   :header-rows: 1

   * - CNST
     - Nombre
     - Aplicacion en este UC
   * - CNST-001
     - Comunicaciones Prohibidas
     - Las notificaciones de cambio de estado (bloqueo, desbloqueo, reactivacion) se envian UNICAMENTE via InternalMessage. NO email, SMS ni webhooks.
   * - CNST-005
     - RBAC Flat
     - El username es inmutable despues de la creacion. Los estados de usuario siguen transiciones definidas.
   * - CNST-009
     - Auditoria Inmutable
     - Todo cambio se registra en UserActionLog con: admin ejecutor, usuario afectado, campos modificados (valor anterior y nuevo), motivo si aplica.

**Implementacion CNST-001 (Notificacion de Bloqueo):**

.. code-block:: python

   # services/user_service.py
   def block_user(self, user_id: int, admin: User, reason: str) -> User:
       user = User.objects.get(id=user_id)
       user.status = UserStatus.BLOQUEADO
       user.blocked_reason = reason
       user.blocked_at = timezone.now()
       user.blocked_by = admin
       user.save()

       # Cerrar sesiones
       SessionService.close_all_sessions(user_id)

       # CNST-001: Solo InternalMessage
       InternalMessage.notify(
           recipient=user,
           sender=admin,
           subject='Cuenta Bloqueada - IACT',
           body=f'''
           Su cuenta ha sido bloqueada por un administrador.

           Motivo: {reason}

           Contacte al administrador para mas informacion.
                                                          
       )
       # PROHIBIDO: EmailService.send()

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-USR-020
     - El sistema debe permitir modificar datos basicos
     - Nombre, apellido, email, segmento modificables
   * - FR-USR-021
     - El sistema debe impedir modificar username
     - Campo username readonly en formulario
   * - FR-USR-022
     - El sistema debe permitir bloquear usuarios
     - Estado cambia a BLOQUEADO, sesiones cerradas
   * - FR-USR-023
     - El sistema debe notificar cambios de estado
     - InternalMessage enviado al usuario afectado
   * - FR-USR-024
     - El sistema debe registrar cambios detallados
     - Auditoria con campos old_value -> new_value

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-USR-003: Permitir modificacion de usuarios existentes
   * - **Reglas de Negocio**
     - BR-USR-20 a BR-USR-25
   * - **Restricciones**
     - CNST-001 (No Email), CNST-005 (Username inmutable), CNST-009 (Auditoria)
   * - **FR Derivados**
     - FR-USR-020 a FR-USR-024
   * - **UC Relacionados**
     - UC_USR_02 (Consultar Usuarios), UC_USR_04 (Eliminar Usuario), UC_AUTH_05 (Gestionar Sesiones)
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Funcion RBAC**
     - USR-003, USR-007, USR-008, USR-009

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