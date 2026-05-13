.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_Users
   :uc_id: UC_USR_01
   :normativa: CNST-001, CNST-005, CNST-009

========================
UC_USR_01: Crear Usuario
========================

1. Resumen
----------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - UC_USR_01
   * - **Nombre**
     - Crear Usuario
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Actor Secundario**
     - Usuario creado (recibe notificacion)
   * - **Modulo**
     - MOD_Users
   * - **Funcion RBAC**
     - USR-001: crea_usuarios
   * - **Prioridad**
     - Alta
   * - **Complejidad**
     - Media
   * - **BReq Origen**
     - BRQ-USR-001

2. Descripcion
--------------

Este caso de uso permite a un administrador de usuarios (AGR-006) crear
nuevas cuentas de usuario en el sistema IACT. El proceso incluye la
generacion automatica de username, asignacion de contrasena temporal,
y notificacion al usuario via buzon interno (CNST-001).

**Caracteristicas principales:**

- Username generado automaticamente (CNST-005)
- Contrasena temporal generada por el sistema
- Estado inicial: PENDIENTE_CONFIGURACION (CNST-005)
- Notificacion SOLO via buzon interno (CNST-001)
- Asignacion obligatoria de segmento
- Registro completo en auditoria (CNST-009)

**Restriccion critica CNST-001:**

.. warning::
   Las credenciales del nuevo usuario se envian UNICAMENTE via
   InternalMessage (buzon interno). NO se permite email, SMS ni
   ningun canal externo.

3. Diagrama de Caso de Uso
--------------------------

.. uml::
   :caption: Diagrama de Caso de Uso - UC_USR_01

   @startuml

   left to right direction

   actor "AGR-006\nagr_admin_usuarios" as ADMIN <<AGR_ADMIN>>
   actor "Usuario\nCreado" as USER
   actor "Sistema" as SYS <<SISTEMA>>

   rectangle "MOD_Users" {
     usecase "UC_USR_01\nCrear Usuario" as UC01
     usecase "Generar\nUsername" as GEN
     usecase "Generar\nPassword Temp" as PWD
     usecase "Notificar via\nBuzon Interno" as NOT
     usecase "Registrar\nAuditoria" as AUD
   }

   ADMIN --> UC01
   UC01 --> GEN : <<include>>
   UC01 --> PWD : <<include>>
   UC01 --> NOT : <<include>>
   UC01 --> AUD : <<include>>
   NOT --> USER : InternalMessage
   SYS --> AUD

   note right of GEN
     CNST-005: Username
     autogenerado, no editable
   end note

   note right of NOT
     CNST-001: SOLO buzon interno
     NO email, NO SMS
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
     - El administrador tiene sesion activa con funcion USR-001
   * - PRE-02
     - El correo electronico proporcionado no existe en el sistema
   * - PRE-03
     - Existe al menos un segmento activo para asignar

4.2 Trigger
^^^^^^^^^^^

El administrador accede al modulo de usuarios y selecciona "Crear Usuario".

4.3 Postcondiciones
^^^^^^^^^^^^^^^^^^^

**Exito:**

.. list-table::
   :widths: 10 90
   :header-rows: 1

   * - ID
     - Postcondicion
   * - POST-01
     - Se crea registro de usuario en base de datos Analytics
   * - POST-02
     - Username generado automaticamente (formato: nombre.apellido.NNNN)
   * - POST-03
     - Estado inicial = PENDIENTE_CONFIGURACION
   * - POST-04
     - Contrasena temporal hasheada almacenada
   * - POST-05
     - Se envia InternalMessage con credenciales (CNST-001)
   * - POST-06
     - Se registra USER_CREATE en auditoria (CNST-009)

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
     - Valida que el admin tenga funcion USR-001 (crea_usuarios)
   * - 3
     - Admin
     - Hace clic en "Crear Usuario"
   * - 4
     - Sistema
     - Presenta formulario de creacion
   * - 5
     - Admin
     - Ingresa datos: nombre, apellido, email corporativo
   * - 6
     - Admin
     - Selecciona segmento de datos (obligatorio)
   * - 7
     - Admin
     - Opcionalmente selecciona agrupador inicial
   * - 8
     - Admin
     - Presiona "Crear Usuario"
   * - 9
     - Sistema
     - Valida formato de campos (email valido, nombre no vacio)
   * - 10
     - Sistema
     - Verifica que email no exista en el sistema
   * - 11
     - Sistema
     - Genera username automatico (nombre.apellido.NNNN)
   * - 12
     - Sistema
     - Genera contrasena temporal segura (12 caracteres)
   * - 13
     - Sistema
     - Hashea contrasena con bcrypt
   * - 14
     - Sistema
     - Crea registro en tabla users con estado PENDIENTE_CONFIGURACION
   * - 15
     - Sistema
     - Asigna segmento seleccionado al usuario
   * - 16
     - Sistema
     - Si se selecciono agrupador, asigna funciones del agrupador
   * - 17
     - Sistema
     - Crea InternalMessage con username y contrasena temporal (CNST-001)
   * - 18
     - Sistema
     - Registra USER_CREATE en UserActionLog (CNST-009)
   * - 19
     - Sistema
     - Muestra confirmacion con username generado
   * - 20
     - Usuario
     - Recibe mensaje en buzon interno con credenciales

6. Diagrama de Secuencia
------------------------

.. uml::
   :caption: Diagrama de Secuencia - UC_USR_01

   @startuml

   actor "AGR-006\nAdmin" as A
   participant "Frontend\nUsers" as FE <<Frontend>>
   participant "UserController" as UC <<Backend>>
   participant "UserService" as US <<Service>>
   participant "UsernameGenerator" as UG <<Service>>
   participant "PasswordGenerator" as PG <<Service>>
   participant "InternalMessage" as IM <<Service>>
   participant "UserActionLog" as UAL <<Service>>
   database "Analytics\nPostgreSQL" as DB <<Database>>

   A -> FE: Click "Crear Usuario"
   activate FE

   FE -> FE: Muestra formulario
   A -> FE: Ingresa datos + segmento + agrupador
   A -> FE: Click "Crear"

   FE -> UC: POST /api/users\n{nombre, apellido, email, segmento_id, agrupador_id}
   activate UC

   == Validar Permisos ==
   UC -> UC: verify_function(USR-001)
   note right
     Requiere funcion
     USR-001: crea_usuarios
   end note

   alt sin permiso USR-001
     UC --> FE: 403 Forbidden
     FE --> A: Error: Sin permisos
   end

   UC -> US: create_user(data, admin)
   activate US

   == Validar Datos ==
   US -> US: validate_email_format(email)
   US -> DB: SELECT * FROM users WHERE email = ?
   DB --> US: existing_user

   alt email ya existe
     US --> UC: EmailExistsError
     UC --> FE: 409 Conflict
     FE --> A: Error: Email ya registrado
   end

   == Generar Username (CNST-005) ==
   US -> UG: generate(nombre, apellido)
   activate UG
   note right of UG
     CNST-005: Username
     autogenerado, no editable
     Formato: nombre.apellido.NNNN
   end note
   UG -> DB: SELECT COUNT(*) FROM users\nWHERE username LIKE 'nombre.apellido%'
   DB --> UG: count
   UG -> UG: username = nombre.apellido.{count+1:04d}
   UG --> US: username
   deactivate UG

   == Generar Password Temporal ==
   US -> PG: generate_temporary(length=12)
   activate PG
   PG --> US: temp_password
   deactivate PG

   US -> US: password_hash = bcrypt.hash(temp_password)

   == Crear Usuario ==
   US -> DB: INSERT INTO users\n(username, email, nombre, apellido,\npassword_hash, status, segmento_id,\ncreated_by, created_at)
   note right of DB
     status = PENDIENTE_CONFIGURACION
   end note
   DB --> US: user_id

   == Asignar Agrupador (si aplica) ==
   alt agrupador_id provided
     US -> DB: INSERT INTO user_functions\n(user_id, function_id)\nSELECT user_id, function_id\nFROM agrupador_functions\nWHERE agrupador_id = ?
   end

   == Notificar via Buzon Interno (CNST-001) ==
   US -> IM: notify(user_id, subject, body)
   activate IM
   note right of IM
     CNST-001: SOLO buzon interno
     NO email, SMS, webhook
   end note
   IM -> DB: INSERT INTO internal_messages\n(recipient_id, sender_id,\nsubject, body, created_at)
   IM --> US: message_sent
   deactivate IM

   == Registrar Auditoria (CNST-009) ==
   US -> UAL: record(USER_CREATE, admin, new_user)
   activate UAL
   note right of UAL
     CNST-009: Registro inmutable
     Sin password en detalles
   end note
   UAL -> DB: INSERT INTO user_action_log
   UAL --> US: logged
   deactivate UAL

   US --> UC: {user_id, username, message_sent: true}
   deactivate US

   UC --> FE: 201 Created + user_data
   deactivate UC

   FE --> A: Confirmacion:\n"Usuario creado: {username}\nCredenciales enviadas al buzon"
   deactivate FE

   @enduml

7. Flujos Alternos
------------------

7.1 FA-01: Sin Agrupador Inicial
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 7a
     - Admin
     - No selecciona ningun agrupador
   * - 16a
     - Sistema
     - Usuario creado sin funciones asignadas
   * - 16b
     - Sistema
     - Admin debera asignar funciones posteriormente (UC_ACC_01)

7.2 FA-02: Username Duplicado (Colision)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 11a
     - Sistema
     - Detecta que username generado ya existe
   * - 11b
     - Sistema
     - Incrementa contador y regenera (nombre.apellido.NNNN+1)
   * - 11c
     - Sistema
     - Continua con flujo normal

7.3 FA-03: Creacion Masiva (Batch)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 20 70
   :header-rows: 1

   * - Paso
     - Actor
     - Accion
   * - 3a
     - Admin
     - Selecciona "Importar usuarios" (CSV)
   * - 4a
     - Sistema
     - Presenta formulario de carga de archivo
   * - 5a
     - Admin
     - Sube archivo CSV con datos de usuarios
   * - 9a
     - Sistema
     - Valida formato y datos de cada fila
   * - 14a
     - Sistema
     - Crea usuarios en transaccion (todo o nada)

8. Excepciones
--------------

8.1 EX-01: Sin Permiso USR-001
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 2
   * - **Condicion**
     - Administrador no tiene funcion USR-001 asignada
   * - **Accion Sistema**
     - Rechaza peticion, registra intento no autorizado
   * - **Mensaje Usuario**
     - "No tiene permisos para crear usuarios"
   * - **Codigo Error**
     - USR-001

8.2 EX-02: Email Ya Existe
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 10
   * - **Condicion**
     - Email ya registrado en el sistema
   * - **Accion Sistema**
     - Rechaza creacion
   * - **Mensaje Usuario**
     - "El email ya esta registrado en el sistema"
   * - **Codigo Error**
     - USR-002

8.3 EX-03: Segmento No Valido
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 6
   * - **Condicion**
     - Segmento seleccionado no existe o esta inactivo
   * - **Accion Sistema**
     - Rechaza creacion
   * - **Mensaje Usuario**
     - "Segmento no valido o inactivo"
   * - **Codigo Error**
     - USR-003

8.4 EX-04: Datos Invalidos
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Paso de Origen**
     - 9
   * - **Condicion**
     - Campos obligatorios vacios o formato invalido
   * - **Accion Sistema**
     - Muestra errores de validacion
   * - **Mensaje Usuario**
     - "Corrija los errores: [lista de errores]"
   * - **Codigo Error**
     - USR-004

9. Diagrama de Actividad
------------------------

.. uml::
   :caption: Diagrama de Actividad - UC_USR_01

   @startuml

   start

   :Admin accede a Crear Usuario;

   if (Tiene funcion USR-001?) then (no)
     :Mostrar error de permisos;
     stop
   else (si)
   endif

   :Mostrar formulario de creacion;

   :Admin ingresa datos del usuario;

   :Admin selecciona segmento;

   :Admin selecciona agrupador (opcional);

   if (Datos validos?) then (no)
     :Mostrar errores de validacion;
     stop
   else (si)
   endif

   if (Email ya existe?) then (si)
     :Error: Email duplicado;
     stop
   else (no)
   endif

   :Generar username automatico;
   note right
     CNST-005
     nombre.apellido.NNNN
   end note

   :Generar password temporal;

   :Hashear password con bcrypt;

   :Crear registro de usuario;
   note right
     status = PENDIENTE_CONFIGURACION
   end note

   :Asignar segmento;

   if (Agrupador seleccionado?) then (si)
     :Asignar funciones del agrupador;
   else (no)
   endif

   :Enviar InternalMessage con credenciales;
   note right
     CNST-001
     Solo buzon interno
   end note

   :Registrar USER_CREATE en auditoria;
   note right
     CNST-009
     Sin password
   end note

   :Mostrar confirmacion con username;

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
   * - BR-USR-01
     - Username Autogenerado
     - El username se genera automaticamente con formato nombre.apellido.NNNN donde NNNN es un contador incremental.
   * - BR-USR-02
     - Estado Inicial
     - Todo usuario nuevo inicia con estado PENDIENTE_CONFIGURACION y debe cambiar su contrasena en el primer login.
   * - BR-USR-03
     - Email Unico
     - El email corporativo debe ser unico en todo el sistema.
   * - BR-USR-04
     - Segmento Obligatorio
     - Todo usuario debe pertenecer a exactamente un segmento de datos.
   * - BR-USR-05
     - Password Temporal
     - La contrasena temporal debe tener minimo 12 caracteres con complejidad alta.
   * - BR-USR-06
     - Solo Buzon Interno
     - Las credenciales SOLO se comunican via InternalMessage, nunca por canales externos.

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
     - Las credenciales (username y password temporal) se envian UNICAMENTE via InternalMessage.notify(). Esta PROHIBIDO usar email, SMS, webhook o cualquier canal externo.
   * - CNST-005
     - RBAC Flat
     - Username autogenerado, no editable por usuario. Estado inicial PENDIENTE_CONFIGURACION. Segmento obligatorio.
   * - CNST-009
     - Auditoria Inmutable
     - Se registra evento USER_CREATE en UserActionLog incluyendo: admin creador, datos del nuevo usuario (SIN password). El registro es inmutable.

**Implementacion CNST-001:**

.. code-block:: python

   # services/user_service.py
   def create_user(self, data: dict, admin: User) -> User:
       # ... crear usuario ...

       # CNST-001: Solo InternalMessage, NO email
       InternalMessage.notify(
           recipient=new_user,
           sender=admin,
           subject='Bienvenido a IACT - Credenciales de Acceso',
           body=f'''
           Se ha creado su cuenta en el sistema IACT.

           Usuario: {new_user.username}
           Contrasena temporal: {temp_password}

           Debe cambiar esta contrasena en su primer inicio de sesion.
                                                                      
       )
       # PROHIBIDO: EmailService.send(), SMSService.send(), etc.

**Implementacion CNST-005:**

.. code-block:: python

   # services/username_generator.py
   def generate(self, nombre: str, apellido: str) -> str:
       base = f"{nombre.lower()}.{apellido.lower()}"
       base = unidecode(base)  # Remover acentos
       base = re.sub(r'[^a-z.]', '', base)  # Solo letras y punto

       count = User.objects.filter(
           username__startswith=base
       ).count()

       return f"{base}.{count+1:04d}"  # nombre.apellido.0001

12. Requisitos Funcionales Derivados
------------------------------------

.. list-table::
   :widths: 15 40 45
   :header-rows: 1

   * - ID
     - Requisito
     - Criterio de Aceptacion
   * - FR-USR-001
     - El sistema debe generar username automaticamente
     - Formato nombre.apellido.NNNN, unico en sistema
   * - FR-USR-002
     - El sistema debe validar unicidad de email
     - Error 409 si email ya existe
   * - FR-USR-003
     - El sistema debe crear usuario con estado PENDIENTE
     - Campo status = PENDIENTE_CONFIGURACION
   * - FR-USR-004
     - El sistema debe notificar SOLO via buzon interno
     - InternalMessage creado, sin emails enviados
   * - FR-USR-005
     - El sistema debe registrar creacion en auditoria
     - Evento USER_CREATE sin datos de password

13. Trazabilidad
----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **BReq Origen**
     - BRQ-USR-001: Permitir creacion de usuarios por administrador
   * - **Reglas de Negocio**
     - BR-USR-01 a BR-USR-06
   * - **Restricciones**
     - CNST-001 (No Email), CNST-005 (RBAC Flat), CNST-009 (Auditoria)
   * - **FR Derivados**
     - FR-USR-001 a FR-USR-005
   * - **UC Relacionados**
     - UC_AUTH_01 (Iniciar Sesion), UC_ACC_01 (Asignar Funciones), UC_ACC_07 (Asignar Segmento)
   * - **Actor Principal**
     - AGR-006: agr_admin_usuarios
   * - **Funcion RBAC**
     - USR-001: crea_usuarios

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
     - Version inicial v4.0 con CNST-001 y CNST-005 aplicadas