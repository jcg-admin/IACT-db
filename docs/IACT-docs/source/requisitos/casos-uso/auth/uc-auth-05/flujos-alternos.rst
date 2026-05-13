.. _uc-auth-05-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Listado vacio
========================

**Activador**: filtros aplicados no matchean
ninguna Session.

**Diferencia**: Backend retorna 200 OK con
``results=[]`` y ``count=0``.

**Postcondicion**: Frontend muestra estado
"Sin resultados" en la tabla.

4.2 FA-02: Cierre de Session ya CLOSED
======================================

**Activador**: Sub-flujo 3.B PASO 7 — la
Session existe pero ya tiene
``state='CLOSED'`` (timeout, supersession,
cierre por otro admin).

**Justificacion**: idempotencia.

**Pasos:**

::

   PASO 7A          Backend detecta CLOSED.
                    No reabre, no re-cierra.

   PASO 8A          Skip (no UPDATE).

   PASO 10A         AuditEvent
                    SESSION_CLOSE_NOOP con
                    payload {already_closed: true,
                    original_close_reason}.

   PASO 12A         200 OK con body
                    {"message": "Sesion ya
                    estaba cerrada",
                    "original_close_reason": ...}

4.3 FA-03: Cierre masivo cuando User no tiene Sessions activas
==============================================================

**Activador**: Sub-flujo 3.C — el User no tiene
Sessions ACTIVE.

**Diferencia**: PASO 8 no cierra nada.

**Postcondicion**: 200 OK con ``count=0``.
AuditEvent BULK_SESSION_CLOSE_NOOP.

4.4 FA-04: Cierre con notificacion via InternalMessage
======================================================

**Activador**: setting
``NOTIFY_USER_ON_ADMIN_SESSION_CLOSE=True``
(default True).

**Diferencia**: PASO 11 ejecutado.

**Postcondicion**:

- 1 InternalMessage al User con subject
  "Sesion cerrada por administrador" y body
  con timestamp y motivo (sin exponer
  identidad del admin).

4.5 FA-05: Filtrado por User especifico
=======================================

**Activador**: Sub-flujo 3.A con filtro
``user_id=42``.

**Justificacion**: caso comun — el admin
investiga las sesiones de un User especifico.

**Diferencia**: AuditEvent
SESSIONS_VIEWED_FOR_USER con
``payload.target_user_id``.

Esta variante se audita explicitamente porque
indica investigacion de un User concreto
(util para trazar quien examino la actividad
de quien).

4.6 FA-06: Vista por el propio User (view_own_sessions)
=======================================================

**Activador**: el endpoint
``/api/auth/sessions/own/`` invocado por un
User regular (no admin) para ver SUS PROPIAS
Sessions.

**Diferencia**: requiere funcion
``view_own_sessions`` (incluida en cualquier
User autenticado por default). El endpoint
retorna SOLO las Sessions del request.user.

**Note**: este sub-flujo es border-line entre
UC_AUTH_05 y "perfil de usuario". Lo
documentamos aqui por simetria operacional. La
implementacion del endpoint vive en MOD_Auth
junto al admin endpoint.

4.7 Resumen
===========

.. list-table::
 :widths: 12 40 30 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - Listado sin matches
   - results=[]
   - 200 OK
 * - FA-02
   - Cierre de Session ya CLOSED
   - SESSION_CLOSE_NOOP
   - 200 OK
 * - FA-03
   - Bulk sin Sessions activas
   - count=0, NOOP
   - 200 OK
 * - FA-04
   - Setting notify=true
   - InternalMessage adicional
   - 200 OK
 * - FA-05
   - Filtrado por user_id
   - Audit SESSIONS_VIEWED_FOR_USER
   - 200 OK
 * - FA-06
   - Vista propia
   - Solo Sessions del request.user
   - 200 OK
