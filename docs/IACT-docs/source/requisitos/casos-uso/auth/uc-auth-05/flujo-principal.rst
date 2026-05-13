.. _uc-auth-05-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

UC_AUTH_05 tiene 3 sub-flujos principales:

- **3.A** Listar Sessions
- **3.B** Cerrar Session individual
- **3.C** Cerrar todas las Sessions de un User

3.A Sub-flujo: Listar Sessions
==============================

3.A.1 Resumen
-------------

::

   PASO 1   Admin abre vista "Sesiones activas"   (Frontend)
   PASO 2   Admin aplica filtros (opcional)       (Frontend)
   PASO 3   Frontend GET /api/auth/sessions/      (FE → BE)
   PASO 4   Backend valida JWT + RBAC             (Backend)
   PASO 5   Backend query Session + paginacion    (Backend → BD)
   PASO 6   Backend aplica CNST-026 (no PII)      (Backend)
   PASO 7   Backend retorna 200 + lista           (BE → FE)
   PASO 8   Frontend renderiza tabla              (Frontend)

3.A.2 Detalle
-------------

PASO 4 — Validacion RBAC requiere
``view_all_active_sessions``. Si falta, EX-02.

PASO 5 — Query con filtros opcionales por:
``state``, ``user_id``, ``ip_like``,
``user_agent_like``, ``created_after``,
``created_before``. Default: solo
``state='ACTIVE'``, paginacion 50/pagina.

PASO 6 — La lista NO incluye PII directa: no
email del User (solo user_id). El admin que
necesite mas detalle puede pedir UC_USR_*.

3.B Sub-flujo: Cerrar Session individual
========================================

3.B.1 Resumen
-------------

::

   PASO 1   Admin localiza la Session             (Frontend)
   PASO 2   Admin clickea "Cerrar"                (Frontend)
   PASO 3   Frontend muestra modal confirmacion   (Frontend)
   PASO 4   Admin confirma                        (Frontend)
   PASO 5   Frontend POST /api/auth/sessions/
            {id}/close/                            (FE → BE)
   PASO 6   Backend valida JWT + RBAC
            close_user_session                     (Backend)
   PASO 7   Backend localiza Session              (Backend → BD)
   PASO 8   Backend transita Session a CLOSED     (Backend → BD)
   PASO 9   Backend blacklistea tokens activos    (Backend → BD)
   PASO 10  Backend emite AuditEvent
            SESSION_CLOSED                         (Backend → BD)
   PASO 11  Backend (opcional) crea InternalMessage
            al User                                (Backend → BD)
   PASO 12  Backend 200 OK                        (BE → FE)
   PASO 13  Frontend toast confirmacion           (Frontend)

3.B.2 Atomicidad
----------------

::

   BEGIN
     UPDATE session SET state='CLOSED',
       close_reason='ADMIN_REVOKED',
       closed_at=NOW(),
       closed_by_admin_id=admin.id
       WHERE session_id=X AND state='ACTIVE';
     INSERT INTO blacklisted_token (jti, ...);
     INSERT INTO audit_event (
       event_type='SESSION_CLOSED', actor=admin,
       payload={target_user_id, target_session_id});
     [opcional] INSERT INTO internal_message (...);
   COMMIT

3.C Sub-flujo: Cerrar todas las Sessions del User
=================================================

3.C.1 Resumen
-------------

::

   PASO 1   Admin abre detalle del User           (Frontend)
   PASO 2   Admin clickea "Cerrar todas las
            sesiones"                              (Frontend)
   PASO 3   Modal robusto con conteo "Esto
            cerrara 3 sesiones del usuario X"     (Frontend)
   PASO 4   Admin confirma                        (Frontend)
   PASO 5   Frontend POST /api/users/{id}/
            close-all-sessions/                    (FE → BE)
   PASO 6   Backend valida JWT + RBAC             (Backend)
   PASO 7   Backend SELECT Sessions ACTIVE        (Backend → BD)
   PASO 8   Backend cierra cada Session           (Backend → BD)
   PASO 9   Backend blacklistea tokens (N)        (Backend → BD)
   PASO 10  Backend N AuditEvent SESSION_CLOSED
            + 1 BULK_SESSION_CLOSE                 (Backend → BD)
   PASO 11  Backend (opcional) InternalMessage    (Backend → BD)
   PASO 12  Backend 200 OK con count              (BE → FE)
   PASO 13  Frontend toast con count              (Frontend)

3.C.2 Politica adicional
------------------------

Si el target User es el propio admin (auto-
cierre masivo), aplica EX-04 (defensa contra
escalada — el admin podria perder su propia
sesion en la operacion). Permitido solo si la
politica lo habilita explicitamente; default
PROHIBIDO.

3.D Datos comunes
=================

Todos los sub-flujos comparten:

- Validacion HTTPS + JWT (CNST-009).
- Validacion RBAC granular (lectura vs cierre).
- AuditEvent obligatorio (CNST-025).
- Sin PII en payload (CNST-026).
- Manejo estandarizado de excepciones (CNST-013).
