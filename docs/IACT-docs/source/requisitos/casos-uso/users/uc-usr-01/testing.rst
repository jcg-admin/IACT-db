.. _uc-usr-01-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 **Principio de abstraccion**. Esta parte
 describe los tests en pseudocodigo
 Given/When/Then alineado con los Criterios de
 Aceptacion (Parte 9), independiente de stack.
 La traduccion a un framework concreto
 (pytest, Jest, JUnit, xUnit) vive en el
 modulo del backend / frontend, no en el UC.

12.1 Pyramid de testing
=======================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura objetivo
 * - Unit (servicios + generadores)
   - 12
   - ≥ 90% lineas / ≥ 85% branches
 * - Integration (endpoint + BD + mailbox)
   - 9
   - flujo principal + EXs + CNSTs
 * - E2E (user-facing UI)
   - 3
   - golden paths + no-leak

12.2 Tests unitarios (pseudocodigo Given/When/Then)
===================================================

12.2.1 UsernameGenerator formato CNST-029
-----------------------------------------

::

   GIVEN un UsernameGenerator
   WHEN  generate("Ana", "Gomez")
   THEN  el resultado matches /^[a-z]+\.[a-z]+\.\d{4}$/

12.2.2 UsernameGenerator quita acentos
--------------------------------------

::

   GIVEN un UsernameGenerator
   WHEN  generate("Andrés", "Ñuñez")
   THEN  el resultado contiene "andres.nunez"

12.2.3 UsernameGenerator incremental
------------------------------------

::

   GIVEN existen ana.gomez.0001 y ana.gomez.0002 en repo
   WHEN  generate("Ana", "Gomez")
   THEN  el resultado == "ana.gomez.0003"

12.2.4 PasswordGenerator complejidad y entropia
-----------------------------------------------

::

   GIVEN un PasswordGenerator
   WHEN  generate(length=12)
   THEN  contiene mayusculas, minusculas, digitos, simbolos
     AND entropia >= 72 bits

12.2.5 create_user happy (CA-01)
--------------------------------

::

   GIVEN un admin con funcion create_users y AGR activo
     AND email no existe
   WHEN  invoker llama create_user(...)
   THEN  User persistido con first_login=true, ACTIVE
     AND Assignment con AGR activo
     AND temp_password NO retornado en output

12.2.6 sin AGR (FA-01, CA-05)
-----------------------------

::

   GIVEN admin con create_users
     AND input sin access_group_id
   WHEN  create_user(...)
   THEN  User persistido sin Assignment
     AND AuditEvent.has_initial_agr == false

12.2.7 InternalMessage creado (CA-12)
-------------------------------------

::

   GIVEN flujo principal
   WHEN  create_user(...)
   THEN  existe 1 InternalMessage con recipient = new_user
     AND body contiene la contrasena temporal

12.2.8 AuditEvent sin PII (CA-13, CA-14)
----------------------------------------

::

   GIVEN flujo principal
   WHEN  create_user(...)
   THEN  AuditEvent USER_CREATED emitido
     AND payload no contiene email, last_name del User
     AND payload contiene ids, ip, user_agent

12.2.9 Atomicidad ante falla mailbox (CA-10)
--------------------------------------------

::

   GIVEN InternalMailbox lanza MailboxFalla
   WHEN  create_user(...)
   THEN  excepcion MailboxFalla propagada
     AND no User persistido (rollback)
     AND no Assignment, no AuditEvent USER_CREATED

12.2.10 Atomicidad ante falla audit (CA-13 negativa)
----------------------------------------------------

::

   GIVEN AuditLog lanza AuditFalla
   WHEN  create_user(...)
   THEN  excepcion AuditFalla propagada
     AND no User persistido
     AND no InternalMessage

12.2.11 Username retry en colision (FA-02)
------------------------------------------

::

   GIVEN existe ana.gomez.0001 en repo
   WHEN  create_user con first=Ana, last=Gomez
   THEN  output.username == "ana.gomez.0002"
     AND retries reportado >= 0

12.2.12 No-leak en logs (CA-03)
-------------------------------

::

   GIVEN flujo principal
   WHEN  se inspeccionan los logs emitidos
   THEN  ningun log line contiene la contrasena temporal

12.3 Tests de integracion
=========================

12.3.1 Endpoint 201 sin password (CA-01, CA-02)
-----------------------------------------------

::

   GIVEN admin con create_users autenticado
   WHEN  POST /api/users/ con datos validos
   THEN  status == 201
     AND body.username matches CNST-029
     AND body NO contiene password ni temp_password

12.3.2 Sin permiso 403 (EX-01, CA-07)
-------------------------------------

::

   GIVEN usuario regular sin create_users
   WHEN  POST /api/users/ con datos validos
   THEN  status == 403
     AND AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT emitido
     AND no User persistido

12.3.3 Email duplicado 409 (EX-02, CA-08)
-----------------------------------------

::

   GIVEN existe User con email = X
   WHEN  POST /api/users/ con email = X
   THEN  status == 409
     AND no nuevo User persistido

12.3.4 Email malformado 400 (EX-03, CA-09)
------------------------------------------

::

   GIVEN admin con create_users
   WHEN  POST /api/users/ con email = "notanemail"
   THEN  status == 400
     AND body.error == "VALIDATION_ERROR"

12.3.5 CNST-001 sin email externo (CA-11)
-----------------------------------------

::

   GIVEN flujo principal con mocks sobre librerias
         de email/SMS/webhook
   WHEN  POST /api/users/ exitoso
   THEN  ZERO invocaciones a librerias externas
     AND existe 1 InternalMessage para el nuevo User

12.3.6 No-leak en logs (CA-03)
------------------------------

::

   GIVEN flujo principal con captura de logs
   WHEN  POST /api/users/ exitoso
   THEN  ningun log line contiene la contrasena
         (extraida del InternalMessage post-test)

12.3.7 First login forzado (CA-04)
----------------------------------

::

   GIVEN admin crea User
     AND temp_password se extrae del InternalMessage
   WHEN  el nuevo User intenta UC_AUTH_01 con
         (username generado, temp_password)
   THEN  status == 200
     AND body.next_step == "change_password"

12.3.8 BD timeout 503 (EX-05)
-----------------------------

::

   GIVEN simulacion de timeout en TransactionManager
   WHEN  POST /api/users/
   THEN  status == 503
     AND body.error == "DB_TIMEOUT"

12.3.9 Throttling 429 (CA-16)
-----------------------------

::

   GIVEN admin que ha enviado 60 POST en 1 minuto
   WHEN  envia POST 61
   THEN  status == 429

12.4 Tests E2E (user-facing UI)
===============================

12.4.1 Admin crea usuario via UI
--------------------------------

::

   GIVEN admin autenticado en UI con AGR-006
   WHEN  navega a "Crear Usuario", ingresa
         (Ana, Gomez, ana@empresa.com),
         click "Crear"
   THEN  toast confirma con username generado
     AND el DOM no contiene la contrasena temporal
     AND el formulario se cierra / redirige

12.4.2 User nuevo recibe credenciales en buzon
----------------------------------------------

::

   GIVEN admin crea User via UI
   WHEN  el nuevo User abre el sistema con su
         username generado y la temp_password
         encontrada en su InternalMailbox
   THEN  login redirige a /change-password
     AND el User puede completar UC_AUTH_04

12.4.3 Sin AGR-006 boton de creacion oculto
-------------------------------------------

::

   GIVEN un User sin AGR-006 autenticado
   WHEN  navega a "Lista de usuarios"
   THEN  el boton "Crear Usuario" no es visible

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente logico
   - Lineas
   - Branches
 * - UserService.create_user
   - ≥ 95%
   - ≥ 90%
 * - UsernameGenerator
   - 100%
   - 100%
 * - PasswordGenerator
   - 100%
   - 100%
 * - HTTPEndpoint create_user
   - ≥ 90%
   - ≥ 85%
 * - AuthorizationGuard create_users
   - 100%
   - 100%

12.6 Resumen
============

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - Capa
   - Test
   - CA cubierto
 * - Unit
   - username formato / sin acentos / incremental
   - CA-06
 * - Unit
   - password complejidad
   - BR-USR-05
 * - Unit
   - create_user happy
   - CA-01
 * - Unit
   - sin AGR
   - CA-05 / FA-01
 * - Unit
   - InternalMessage creado
   - CA-12
 * - Unit
   - AuditEvent sin PII
   - CA-13, CA-14
 * - Unit
   - atomicidad mailbox
   - CA-10
 * - Unit
   - atomicidad audit
   - CA-13 (negativo)
 * - Unit
   - username retry colision
   - FA-02
 * - Unit
   - no-leak logs
   - CA-03
 * - Integration
   - endpoint 201 sin password
   - CA-01, CA-02
 * - Integration
   - sin permiso 403
   - CA-07
 * - Integration
   - email duplicado 409
   - CA-08
 * - Integration
   - email malformado 400
   - CA-09
 * - Integration
   - CNST-001 sin email
   - CA-11
 * - Integration
   - no-leak logs
   - CA-03
 * - Integration
   - first login forzado
   - CA-04
 * - Integration
   - BD timeout 503
   - EX-05
 * - Integration
   - throttling 429
   - CA-16
 * - E2E
   - admin crea via UI
   - flujo completo
 * - E2E
   - user recibe credenciales
   - CA-04 + CA-12
 * - E2E
   - boton oculto sin permiso
   - CA-07 (visual)
