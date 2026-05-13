.. _uc-auth-02-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

Variaciones del flujo principal de UC_AUTH_02
que no son falla. Las fallas viven en Parte 5.

UC_AUTH_02 es deliberadamente simple: la cantidad
de FA es menor que en UC_AUTH_01 porque el cierre
voluntario tiene menos ramas legitimas que el
inicio. Solo se documentan las rutas con
postcondiciones distinguibles.

4.1 FA-01: Logout sin refresh token en body
===========================================

**Activador**: PASO 3 del flujo principal — el
cliente envia el request sin
``refresh_token`` en el body (solo el access
token en header).

**Justificacion**: clientes legacy o flujos donde
el refresh token no esta accesible al frontend
(p.ej. cookie HttpOnly gestionada por proxy).

**Punto de divergencia**: PASO 7 (blacklist).

**Pasos:**

::

   PASO 7A (FA-01)  Backend agrega solo el access
                    token al blacklist. El refresh
                    token queda valido hasta su
                    expiracion natural o hasta que
                    el cliente lo presente
                    explicitamente.

   PASO 8A          AuditEvent LOGOUT registra
                    payload {refresh_token_invalidated:
                    false, reason: 'not_provided'}.

   PASO 9A          Continua igual que el flujo
                    principal (200 OK).

**Postcondiciones especiales:**

- ``Session.state = CLOSED``.
- Access token blacklisted; refresh token NO.
- Si el refresh token se usa despues, el endpoint
  ``/api/auth/refresh/`` lo rechaza porque
  ``Session.state != ACTIVE``.

4.2 FA-02: Logout con sesion ya cerrada (idempotencia)
======================================================

**Activador**: PASO 5 — al buscar la Session
``state=ACTIVE``, no existe. Existe una Session
con ``state=CLOSED`` para el mismo ``session_id``.

**Justificacion**: idempotencia. El usuario hace
doble click en "Cerrar sesion", o un retry de
red replay el mismo request.

**Punto de divergencia**: PASO 5.

**Pasos:**

::

   PASO 5A (FA-02)  Backend detecta que la Session
                    ya esta CLOSED. No reabre, no
                    re-cierra.

   PASO 6A          Agrega el access token al
                    blacklist (defensa en
                    profundidad — por si no estaba).

   PASO 7A          AuditEvent LOGOUT_REPLAY con
                    payload {original_close_at,
                    original_close_reason}.

   PASO 8A          Retorna 200 OK con
                    body {"message": "Sesion ya
                    estaba cerrada"}.

**Postcondiciones especiales:**

- Sin cambios en la Session original.
- Token blacklisted dos veces (idempotente — la
  tabla blacklist tiene UNIQUE en ``jti``).
- AuditEvent extra para que el admin de seguridad
  pueda detectar patrones (replay attacks vs
  doble click legitimo).

4.3 FA-03: Logout durante sesion ya superseded
==============================================

**Activador**: PASO 5 — la Session existe pero
fue cerrada por CNST-004 (otra Session iniciada
desde otro dispositivo cerro esta).

**Justificacion**: el usuario tenia esta Session
activa, abrio otra desde un movil (UC_AUTH_01 +
FA-03 de UC_AUTH_01 cerro la del navegador), y
ahora hace logout en el navegador donde la
Session ya esta CLOSED con
``close_reason='SUPERSEDED'``.

**Diferencia con FA-02**: idempotencia con
``close_reason`` distinto al esperado.

**Pasos:**

::

   PASO 5B (FA-03)  Backend detecta Session CLOSED
                    con close_reason='SUPERSEDED'.

   PASO 6B          NO sobreescribe close_reason
                    (la causa real fue CNST-004,
                    no USER_LOGOUT).

   PASO 7B          AuditEvent LOGOUT_ON_SUPERSEDED
                    con payload {original_reason:
                    'SUPERSEDED'}.

   PASO 8B          Retorna 200 OK; el body incluye
                    {"message": "Tu sesion ya habia
                    sido cerrada porque iniciaste
                    sesion en otro dispositivo."}

**Postcondiciones especiales:**

- ``close_reason`` permanece ``SUPERSEDED`` —
  preserva la causa raiz para auditoria.
- Frontend muestra mensaje informativo distinto
  al "Sesion cerrada correctamente".

4.4 Resumen de flujos alternos
==============================

.. list-table::
 :widths: 12 40 25 23
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status response
 * - FA-01
   - Sin refresh token en body
   - Solo access token blacklisted
   - 200 OK
 * - FA-02
   - Session ya CLOSED (mismo motivo)
   - Idempotente; AuditEvent LOGOUT_REPLAY
   - 200 OK
 * - FA-03
   - Session CLOSED por CNST-004
   - close_reason preservado SUPERSEDED
   - 200 OK con mensaje

Todos los FA preservan la postcondicion principal
(Session no esta ACTIVE) y emiten AuditEvent
distinguible para que UC_AUD_01..04 puedan
correlacionar patrones.
