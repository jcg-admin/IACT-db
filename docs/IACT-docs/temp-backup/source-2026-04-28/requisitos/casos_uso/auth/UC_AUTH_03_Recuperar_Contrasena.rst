.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Auth
   :uc_id: UC_AUTH_03
   :normativa: CNST-001, CNST-009

================================
UC_AUTH_03: Recuperar Contrasena
================================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_AUTH_03
   * - **Nombre**
     - Recuperar Contrasena
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Actor Secundario**
     - Usuario afectado (recibe notificacion)
   * - **Modulo**
     - MOD_Auth
   * - **Funcion RBAC**
     - AUT-003: resetea_password
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-AUTH-003

2. Descripcion
--------------

Este caso de uso permite a un administrador de usuarios (AGR-006) generar
una contrasena temporal para un usuario que ha olvidado sus credenciales.
La nueva contrasena se comunica al usuario unicamente a traves del buzon
interno del sistema (CNST-001).

**Caracteristicas principales:**

- Solo administradores pueden resetear contrasenas (AUT-003)
- Generacion de contrasena temporal segura
- Notificacion SOLO via buzon interno (InternalMessage)
- El usuario debe cambiar la contrasena en su primer login
- Estado del usuario cambia a PENDIENTE_CONFIGURACION
- Registro completo en auditoria (CNST-009)

**Restriccion critica CNST-001:**

.. warning::
   NO se permite enviar la contrasena por email, SMS, webhook ni ningun
   otro canal externo. Solo se utiliza InternalMessage (buzon interno).

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_AUTH_03

   @startuml

   left to right direction

   actor "AGR-006\nagr_admin_usuarios" as ADMIN <<AGR_ADMIN>>
   actor "Usuario\nAfectado" as USER
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Auth" {
     usecase "UC_AUTH_03\nRecuperar Contrasena" as UC03
     usecase "Generar Password\nTemporal" as GEN
     usecase "Notificar via\nBuzon Interno" as NOT
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC03
   UC03 --> GEN : <<include>>
   UC03 --> NOT : <<include>>
   UC03 --> AUD : <<include>>
   NOT --> USER : InternalMessage
   SYS --> AUD

   note right of NOT
     CNST-001: SOLO buzon interno
     NO email, NO SMS, NO webhook
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
     - El administrador tiene sesion activa con funcion AUT-003
   * - PRE-02
     - El usuario destino existe en el sistema
   * - PRE-03
     - El usuario destino tiene estado ACTIVO, BLOQUEADO o PENDIENTE_CONFIGURACION
   * - PRE-04
     - El usuario destino no es el mismo administrador (no auto-reset)

4.2 Trigger
^^^^^^^^^^^

El administrador accede a la gestion de usuarios y selecciona "Resetear Contrasena"
para un usuario especifico.

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se genera una contrasena temporal segura (12+ caracteres)
   * - POST-02
     - El hash de la contrasena anterior se reemplaza
   * - POST-03
     - El estado del usuario cambia a PENDIENTE_CONFIGURACION
   * - POST-04
     - Se envia InternalMessage con la contrasena temporal (CNST-001)
   * - POST-05
     - Se cierran todas las sesiones activas del usuario
   * - POST-06
     - Se registra PASSWORD_RESET en auditoria (CNST-009)

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
     - Valida que el admin tenga funcion AUT-003 (resetea_password)
   * - 3
     - Admin
     - Busca y selecciona el usuario afectado
   * - 4
     - Admin
     - Hace clic en "Resetear Contrasena"
   * - 5
     - Sistema
     - Muestra dialogo de confirmacion con advertencia
   * - 6
     - Admin
     - Confirma la accion
   * - 7
     - Sistema
     - Valida que el usuario destino no sea el mismo admin
   * - 8
     - Sistema
     - Valida que el estado del usuario permita reset
   * - 9
     - Sistema
     - Genera contrasena temporal segura (12 caracteres, mixta)
   * - 10
     - Sistema
     - Hashea la nueva contrasena con bcrypt
   * - 11
     - Sistema
     - Actualiza password_hash del usuario en base de datos
   * - 12
     - Sistema
     - Cambia estado del usuario a PENDIENTE_CONFIGURACION
   * - 13
     - Sistema
     - Cierra todas las sesiones activas del usuario
   * - 14
     - Sistema
     - Crea InternalMessage con la contrasena temporal (CNST-001)
   * - 15
     - Sistema
     - Registra PASSWORD_RESET en UserActionLog (CNST-009)
   * - 16
     - Sistema
     - Muestra confirmacion al administrador
   * - 17
     - Usuario
     - Recibe mensaje en su buzon interno con contrasena temporal

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_AUTH_03

   @startuml

   actor "AGR-006\nAdmin" as A
   participant "Frontend\nUsers" as FE <<Frontend>>
   participant "UserController" as UC <<Backend>>
   participant "AuthService" as AS <<Service>>
   participant "PasswordGenerator" as PG <<Service>>
   participant "SessionService" as SS <<Service>>
   participant "InternalMessage" as IM <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Selecciona usuario\nClick "Resetear Contrasena"
   activate FE

   FE -> FE: Muestra dialogo confirmacion
   A -> FE: Confirma accion

   FE -> UC: POST /api/users/{id}/reset-password\nAuthorization: Bearer {token}
   activate UC

   == Validar Permisos ==
   UC -> UC: verify_function(AUT-003)
   note right
     Requiere funcion
     AUT-003: resetea_password
   end note

   alt sin permiso AUT-003
     UC --> FE: 403 Forbidden
     FE --> A: Error: Sin permisos
   end

   UC -> AS: reset_password(user_id, admin_id)
   activate AS

   == Validar Usuario Destino ==
   AS -> DB: SELECT * FROM users\nWHERE id = ?
   DB --> AS: user_data

   alt usuario no existe
     AS --> UC: UserNotFoundError
     UC --> FE: 404 Not Found
   end

   alt usuario = admin (auto-reset)
     AS --> UC: SelfResetError
     UC --> FE: 400 Bad Request
   end

   alt estado invalido (ELIMINADO)
     AS --> UC: InvalidStateError
     UC --> FE: 400 Bad Request
   end

   == Generar Password Temporal ==
   AS -> PG: generate_temporary(length=12)
   activate PG
   PG -> PG: random(upper + lower + digits + special)
   PG --> AS: temp_password
   deactivate PG

   AS -> AS: bcrypt.hash(temp_password)

   == Actualizar Usuario ==
   AS -> DB: UPDATE users SET\npassword_hash = ?,\nstatus = 'PENDIENTE_CONFIGURACION',\npassword_changed_at = now()

   == Cerrar Sesiones ==
   AS -> SS: close_all_sessions(user_id)
   activate SS
   SS -> DB: UPDATE user_sessions\nSET is_active = false
   SS --> AS: sessions_closed
   deactivate SS

   == Notificar via Buzon Interno (CNST-001) ==
   AS -> IM: notify(user_id, subject, body)
   activate IM
   note right of IM
     CNST-001: SOLO buzon interno
     NO email, SMS, webhook
   end note
   IM -> DB: INSERT INTO internal_messages\n(recipient_id, sender_id,\nsubject, body, created_at)
   IM --> AS: message_sent
   deactivate IM

   == Registrar Auditoria (CNST-009) ==
   AS -> UAL: record(PASSWORD_RESET, admin, user)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Incluye admin que ejecuto
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> AS: logged
   deactivate UAL

   AS --> UC: {success: true, message_sent: true}
   deactivate AS

   UC --> FE: 200 OK
   deactivate UC

   FE --> A: Confirmacion:\n"Contrasena reseteada.\nNotificacion enviada al buzon."
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Usuario Bloqueado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 8a
     - Sistema
     - Detecta usuario con estado BLOQUEADO
   * - 8b
     - Sistema
     - Permite el reset pero mantiene estado BLOQUEADO
   * - 8c
     - Sistema
     - Muestra advertencia: "Usuario bloqueado. Debera desbloquearlo despues del reset."

7.2 FA-02: Administrador Cancela
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 6a
     - Admin
     - Cancela el dialogo de confirmacion
   * - 6b
     - Sistema
     - No realiza ninguna accion
   * - 6c
     - Sistema
     - Retorna a la lista de usuarios

8. Excepciones
--------------

8.1 EX-01: Sin Permiso AUT-003
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Administrador no tiene funcion AUT-003 asignada
   * - **Accion Sistema**
     - Rechaza peticion, registra intento no autorizado
   * - **Mensaje Usuario**
     - "No tiene permisos para resetear contrasenas"
   * - **Codigo Error**
     - AUTH-020

8.2 EX-02: Usuario No Encontrado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 3
   * - **Condicion**
     - ID de usuario no existe en base de datos
   * - **Accion Sistema**
     - Retorna error 404
   * - **Mensaje Usuario**
     - "Usuario no encontrado"
   * - **Codigo Error**
     - AUTH-021

8.3 EX-03: Auto-Reset No Permitido
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 7
   * - **Condicion**
     - Administrador intenta resetear su propia contrasena
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - "No puede resetear su propia contrasena. Use 'Cambiar Contrasena'."
   * - **Codigo Error**
     - AUTH-022

8.4 EX-04: Usuario Eliminado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 8
   * - **Condicion**
     - Usuario destino tiene estado ELIMINADO
   * - **Accion Sistema**
     - Rechaza operacion
   * - **Mensaje Usuario**
     - "No se puede resetear contrasena de usuario eliminado"
   * - **Codigo Error**
     - AUTH-023

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_AUTH_03

   @startuml

   start

   :Admin selecciona usuario;

   :Admin hace clic en "Resetear Contrasena";

   if (Tiene funcion AUT-003?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Mostrar dialogo de confirmacion;

   if (Admin confirma?) then (no)
     :Cancelar operacion;
     stop
   else (si)
   endif

   if (Usuario existe?) then (no)
     :Mostrar "Usuario no encontrado";
     stop
   else (si)
   endif

   if (Es auto-reset?) then (si)
     :Mostrar "No puede resetear su propia cuenta";
     stop
   else (no)
   endif

   if (Estado = ELIMINADO?) then (si)
     :Mostrar "Usuario eliminado";
     stop
   else (no)
   endif

   :Generar contrasena temporal (12 chars);

   :Hashear con bcrypt;

   :Actualizar password en BD;

   :Cambiar estado a PENDIENTE_CONFIGURACION;

   :Cerrar todas las sesiones activas;

   :Enviar InternalMessage con password;
   note right
     CNST-001
     Solo buzon interno
   end note

   :Registrar PASSWORD_RESET en auditoria;
   note right
     CNST-009
     Registro inmutable
   end note

   :Mostrar confirmacion al admin;

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
   * - BR-AUTH-20
     - Solo Admin Reset
     - Solo usuarios con funcion AUT-003 pueden resetear contrasenas de otros usuarios.
   * - BR-AUTH-21
     - Password Temporal
     - La contrasena generada debe tener minimo 12 caracteres con mayusculas, minusculas, numeros y simbolos.
   * - BR-AUTH-22
     - Cambio Obligatorio
     - El usuario debe cambiar la contrasena temporal en su primer login posterior al reset.
   * - BR-AUTH-23
     - Sin Auto-Reset
     - Un administrador no puede resetear su propia contrasena mediante esta funcion.
   * - BR-AUTH-24
     - Cierre de Sesiones
     - Al resetear contrasena, todas las sesiones activas del usuario se cierran automaticamente.
   * - BR-AUTH-25
     - Solo Buzon Interno
     - La contrasena temporal SOLO se comunica via InternalMessage, nunca por canales externos.

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
     - La contrasena temporal se envia UNICAMENTE via InternalMessage.notify(). Esta PROHIBIDO usar email, SMS, webhook o cualquier canal externo.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra evento PASSWORD_RESET en UserActionLog incluyendo: admin que ejecuto, usuario afectado, timestamp e IP. El registro es inmutable.

**Implementacion CNST-001:**

.. code-block:: python

   # services/auth_service.py
   def reset_password(self, user_id: int, admin: User) -> dict:
       # Generar password temporal
       temp_password = PasswordGenerator.generate(length=12)

       # ... actualizar usuario ...

       # CNST-001: Solo InternalMessage, NO email
       InternalMessage.notify(
           recipient=user,
           sender=admin,
           subject='Contrasena Temporal - IACT',
           body=f'''
           Su contrasena ha sido reseteada por un administrador.

           Contrasena temporal: {temp_password}

           Debe cambiar esta contrasena en su proximo inicio de sesion.
                                                                       
       )
       # PROHIBIDO: EmailService.send(), SMSService.send(), etc.

**Implementacion CNST-009:**

.. code-block:: python

   UserActionLog.record(
       user=admin,
       action='PASSWORD_RESET',
       resource=f'User:{user.id}',
       result='SUCCESS',
       ip=request.META.get('REMOTE_ADDR'),
       user_agent=request.META.get('HTTP_USER_AGENT'),
       details={
           'target_user': user.username,
           'admin_user': admin.username,
           'notification_method': 'internal_message'
       }
   )

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-AUTH-020
     - El sistema debe validar funcion AUT-003 antes de permitir reset
     - Error 403 si no tiene la funcion asignada
   * - FR-AUTH-021
     - El sistema debe generar contrasenas temporales seguras
     - Minimo 12 caracteres, mixtos, sin palabras de diccionario
   * - FR-AUTH-022
     - El sistema debe notificar SOLO via buzon interno
     - InternalMessage creado, sin emails enviados
   * - FR-AUTH-023
     - El sistema debe cerrar sesiones del usuario afectado
     - Todas las sesiones marcadas como inactivas
   * - FR-AUTH-024
     - El sistema debe registrar reset en auditoria
     - Evento PASSWORD_RESET con admin y usuario afectado

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-AUTH-003: Permitir recuperacion de contrasenas por administrador
   * - **Reglas de Negocio**
     - BR-AUTH-20 a BR-AUTH-25
   * - **Restricciones**
     - CNST-001 (No Email), CNST-009 (Auditoria Inmutable)
   * - **FR Derivados**
     - FR-AUTH-020 a FR-AUTH-024
   * - **UC Relacionados**
     - UC_AUTH_01 (Iniciar Sesion), UC_AUTH_04 (Cambiar Contrasena), UC_USR_03 (Modificar Usuario)
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Funcion RBAC**
     - AUT-003: resetea_password

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
     - Version inicial v4.0 con CNST-001 aplicada