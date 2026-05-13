.. _uc-auth-05-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**Admin con AGR-006 user_admin_group** — User
con Assignment activo a las funciones
``view_all_active_sessions`` y/o
``close_user_session``.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Iniciador**
   - SI
 * - **Granularidad RBAC**
   - puede tener una funcion sin la otra (e.g.
     auditor lectura sin cierre)

2.2 Actores Secundarios
=======================

2.2.1 User cuya Session se gestiona
-----------------------------------

Receptor pasivo. Si su Session se cierra:

- Su access token siguiente request → 401
- Es desconectado del sistema
- Recibe (si politica) un InternalMessage
  notificando el cierre administrativo

2.2.2 Sistema (Backend Django)
------------------------------

Responsabilidades:

- Validar JWT del admin.
- Validar funcion RBAC apropiada por
  operacion: ``view_all_active_sessions`` para
  GET; ``close_user_session`` para POST/DELETE.
- Listar/leer Sessions con paginacion.
- Cerrar Session(s) atomicamente.
- Emitir AuditEvent SESSION_CLOSED por cada
  cierre con
  ``close_reason='ADMIN_REVOKED'``.
- Enviar InternalMessage al User cuya Session
  fue cerrada (politica recomendada).

2.2.3 BD MySQL
--------------

Responsabilidades:

- Indices apropiados en
  ``session(state, user_id, created_at)``
  para queries eficientes.
- Atomicidad ACID en cierres.

2.2.4 Frontend
--------------

Responsabilidades:

- Tabla paginada con filtros.
- Detalle expandible.
- Confirmacion robusta para cierre (modal).
- Boton "Cerrar todas las sesiones del user"
  con doble confirmacion.

2.2.5 Auditor
-------------

Beneficiario indirecto. Consume AuditEvent
SESSION_CLOSED para detectar:

- Patrones de cierre masivo (incidente?).
- Cierre de sesiones administrativas
  privilegiadas.

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend respondiendo en
  ``/api/auth/sessions/`` y
  ``/api/auth/sessions/{id}/``.
- BD MySQL accesible.

2.3.2 Admin autenticado y autorizado
------------------------------------

- Session activa.
- Funcion RBAC apropiada por operacion.

2.3.3 Datos consistentes
------------------------

- Indices en BD presentes (sin esto, GET
  paginado escala mal).

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito (lectura)
----------------------------------------

- Admin recibe lista paginada filtrada.
- AuditEvent ``SESSIONS_VIEWED`` opcional
  segun politica (puede generar volumen alto;
  recomendamos solo registrar consultas que
  filtren por user_id especifico).

2.4.2 Postcondiciones de exito (cierre individual)
--------------------------------------------------

- Session ``state = CLOSED``,
  ``close_reason = 'ADMIN_REVOKED'``,
  ``closed_at = NOW()``,
  ``closed_by_admin_id = admin.id``.
- Tokens JWT activos blacklisteados.
- AuditEvent ``SESSION_CLOSED`` con
  ``actor_user_id=admin``,
  ``payload={target_user_id, target_session_id,
  ip, user_agent, reason}``.
- (Opcional) InternalMessage al User afectado.

2.4.3 Postcondiciones de exito (cierre masivo)
----------------------------------------------

- Todas las Sessions ACTIVE del User pasan a
  CLOSED.
- N AuditEvent SESSION_CLOSED (uno por
  Session).
- 1 AuditEvent BULK_SESSION_CLOSE adicional con
  ``payload.count = N``.

2.4.4 Postcondiciones de fallo
------------------------------

- EX-01..EX-06: rollback completo. Sessions
  intactas. AuditEvent SESSION_CLOSE_FAILED
  segun politica.
