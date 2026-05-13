.. _uc-usr-01-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

.. note::

 **Principio de abstraccion**. Esta parte
 describe la implementacion en terminos de
 **contratos, responsabilidades y pseudocodigo**
 — independiente de lenguaje y framework.
 Cualquier stack que respete los contratos
 satisface el UC. Los ejemplos en stacks
 concretos quedan en
 ``arquitectura-tecnica/`` o en guias del
 stack vigente, NO en este UC.

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **HTTPEndpoint**
   - Recibir POST hacia ``/api/users/``,
     deserializar payload, delegar al servicio
 * - **AuthenticationGuard**
   - Validar token de sesion del invocante
 * - **AuthorizationGuard**
   - Verificar que el invocante posee la
     funcion RBAC ``create_users``
 * - **ThrottlePolicy**
   - Imponer limite de N creaciones por
     ventana temporal por invocante
 * - **InputValidator**
   - Validar tipos, formatos (email),
     ausencia de campos requeridos
 * - **UniquenessChecker**
   - Verificar que ``email`` no exista en el
     repositorio
 * - **UsernameGenerator**
   - Producir un identificador unico per
     CNST-029 (``base.NNNN``)
 * - **PasswordGenerator**
   - Producir contrasena temporal con
     entropia criptograficamente segura
 * - **PasswordHasher**
   - Hashear con algoritmo resistente
     (recomendado: bcrypt cost 12 o
     equivalente)
 * - **UserRepository**
   - Persistir el User
 * - **AssignmentRepository**
   - Persistir el Assignment opcional
 * - **InternalMailbox**
   - Persistir mensaje en buzon del nuevo User
     (CNST-001 + CNST-002)
 * - **AuditLog**
   - Persistir AuditEvent inmutable
     append-only (CNST-025)
 * - **TransactionManager**
   - Garantizar atomicidad ACID de pasos
     persistentes (10-13)
 * - **SecretsRedactor**
   - Filtro de logs que oculta credenciales

11.2 Contratos (signaturas abstractas)
======================================

::

   # Servicio principal del UC

   contract UserService:
     create_user(input: CreateUserInput,
                 invoker: AuthenticatedUser,
                 context: RequestContext)
       returns: CreateUserOutput
       throws: SinPermiso, EmailExiste,
               DatosInvalidos, MailboxFalla,
               UsernameRetriesExhausted,
               AGRInvalido, BDTimeout, AuditFalla

   data CreateUserInput:
     first_name: string (1..50)
     last_name: string (1..50)
     email: string (formato email valido)
     access_group_id: opt[int]

   data CreateUserOutput:
     user_id: int
     username: string
     email: string
     state: enum {ACTIVE, INACTIVE, BLOCKED, ELIMINATED}
     first_login: bool
     created_at: timestamp
     access_group_id: opt[int]
     notification_sent: bool
     # NO contiene: password, password_hash

   contract UsernameGenerator:
     generate(first: string, last: string) returns string
       postcondition: matches /^[a-z]+\.[a-z]+\.\d{4}$/

   contract PasswordGenerator:
     generate(length: int) returns string
       precondition: length >= 12
       postcondition:
         - contiene al menos 1 mayuscula
         - contiene al menos 1 minuscula
         - contiene al menos 1 digito
         - contiene al menos 1 simbolo
         - entropia >= 72 bits

   contract PasswordHasher:
     hash(plaintext: string) returns string
       postcondition: hash es resistente a fuerza
                      bruta (cost >= 12 si bcrypt)
     verify(plaintext, hash) returns bool

   contract UserRepository:
     exists_by_email(email) returns bool
     exists_by_username(username) returns bool
     count_by_username_prefix(prefix) returns int
     insert(user_data) returns User
       throws: UniqueConstraintViolation

   contract InternalMailbox:
     send(recipient_id, subject, body)
       throws: MailboxFalla
       guarantee:
         - mensaje persistido localmente
         - no canal externo (CNST-001)

   contract AuditLog:
     emit(event_type, actor_id, payload)
       throws: AuditFalla
       guarantee:
         - append-only (CNST-025)
         - sin PII en payload (CNST-026)

   contract TransactionManager:
     atomic(block: () -> T) returns T
       throws: cualquier excepcion del block
       guarantee:
         - si block lanza, ROLLBACK total
         - si block retorna, COMMIT atomico

11.3 Pseudocodigo del flujo principal
=====================================

::

   procedure create_user(input, invoker, ctx):

       # Pasos 5: validacion auth (delegado a Guards)
       require AuthenticationGuard.is_valid(invoker)
       require AuthorizationGuard.has_function(
                 invoker, 'create_users')
       require ThrottlePolicy.is_allowed(invoker)

       # Paso 6: validacion datos
       InputValidator.validate(input)
       if UserRepository.exists_by_email(input.email):
           raise EmailExiste
       if AGRStrict and AGRPolicy.is_external(input.email):
           raise EmailExterno
       if input.access_group_id is not None:
           require AGRRepository.is_active(
                     input.access_group_id)

       # Paso 7: generar username con retries (FA-02)
       (username, retries) = generate_unique_username(
           input.first_name, input.last_name,
           max_retries = 5)

       # Paso 8-9: password + hash
       temp_password = PasswordGenerator.generate(
                         length = 12)
       password_hash = PasswordHasher.hash(temp_password)

       # Pasos 10-13: persistencia atomica
       result = TransactionManager.atomic(():

           new_user = UserRepository.insert(
               username = username,
               email = input.email,
               first_name = input.first_name,
               last_name = input.last_name,
               password_hash = password_hash,
               state = ACTIVE,
               first_login = True,
               password_changed_at = now(),
               created_by_admin_id = invoker.id)

           if input.access_group_id is not None:
               AssignmentRepository.insert(
                   user_id = new_user.id,
                   access_group_id = input.access_group_id,
                   state = ACTIVE,
                   granted_at = now(),
                   granted_by_admin_id = invoker.id)

           InternalMailbox.send(
               recipient_id = new_user.id,
               subject = 'Bienvenido a IACT — Credenciales',
               body = build_welcome_body(
                        username, temp_password))

           AuditLog.emit(
               event_type = 'USER_CREATED',
               actor_id = invoker.id,
               payload = {
                 target_user_id: new_user.id,
                 access_group_id: input.access_group_id,
                 has_initial_agr: input.access_group_id
                                  is not None,
                 username_retries: retries,
                 ip: ctx.ip,
                 user_agent: ctx.user_agent})

           return new_user
       )

       # CRITICO: temp_password NUNCA en response,
       # logs, audit payload, ni stacktrace.
       return CreateUserOutput(
           user_id = result.id,
           username = result.username,
           email = result.email,
           state = result.state,
           first_login = result.first_login,
           created_at = result.created_at,
           access_group_id = input.access_group_id,
           notification_sent = True)


   procedure generate_unique_username(first, last,
                                       max_retries):
       for retry in 0 .. max_retries:
           candidate = UsernameGenerator.generate(
                         first, last)
           if not UserRepository.exists_by_username(
                    candidate):
               return (candidate, retry)
       raise UsernameRetriesExhausted

11.4 Mapeo excepcion → respuesta HTTP
=====================================

.. list-table::
 :widths: 35 30 35
 :header-rows: 1

 * - Excepcion
   - Status HTTP
   - Body code
 * - sin token / token invalido
   - 401
   - INVALID_TOKEN
 * - SinPermiso / falta create_users
   - 403
   - FORBIDDEN
 * - DatosInvalidos
   - 400
   - VALIDATION_ERROR
 * - EmailExiste
   - 409
   - EMAIL_EXISTS
 * - EmailExterno
   - 400
   - EXTERNAL_EMAIL_FORBIDDEN
 * - AGRInvalido
   - 400
   - INVALID_ACCESS_GROUP
 * - UsernameRetriesExhausted
   - 500
   - USERNAME_GENERATION_FAILED
 * - MailboxFalla
   - 500
   - MAILBOX_FAILED
 * - AuditFalla
   - 500
   - AUDIT_FAILED
 * - BDTimeout
   - 503
   - DB_TIMEOUT
 * - throttle exceeded
   - 429
   - RATE_LIMIT

11.5 Restricciones cross-cutting
================================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Restriccion
   - Implementacion
 * - **Logging sin secretos**
   - SecretsRedactor filtra mensajes que
     contienen ``temp_password`` o
     ``Contrasena temporal:`` antes de emitir
     al sink. Aplicado a todos los logs del
     servicio.
 * - **Sin canales externos** (CNST-001)
   - InternalMailbox es la UNICA salida
     posible para credenciales. Cualquier
     intento de invocar EmailService /
     SMSService / WebhookService desde el
     servicio falla en build (lint/policy).
 * - **Mailbox obligatorio** (CNST-002)
   - El bloque atomico de la transaccion
     incluye la emision del InternalMessage.
     Sin mailbox no hay creacion.
 * - **Audit obligatorio** (CNST-025)
   - El bloque atomico incluye AuditLog.emit.
     Sin audit no hay creacion.
 * - **PII fuera del payload** (CNST-026)
   - El payload del AuditEvent solo contiene
     IDs, IP, user_agent y banderas.
     Validable por test:
     ``email``/``last_name`` NO en payload.

11.6 Ejemplos de stack (informativo, no prescriptivo)
=====================================================

La especificacion anterior se realiza en
distintos stacks. La implementacion concreta
NO pertenece al UC; vive en
``arquitectura-tecnica/`` y en los modulos del
backend del proyecto:

- Stack web Python: Django/DRF + bcrypt + ORM
  + transaction.atomic.
- Stack web Node.js: Express + Argon2 +
  Sequelize + transactions.
- Stack JVM: Spring + BCryptPasswordEncoder +
  JPA + @Transactional.
- Stack .NET: ASP.NET Core + Identity + EF
  Core + ITransaction.

Cualquiera satisface el UC siempre y cuando
honre los **contratos** (§ 11.2),
**pseudocodigo** (§ 11.3) y **restricciones
cross-cutting** (§ 11.5).
