.. _uc-usr-02-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con ``list_users`` y/o ``view_users``** —
tipicamente AGR-006 (admin) o AGR-008 (auditor).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Iniciador**
   - SI
 * - **Granularidad RBAC**
   - puede tener una funcion sin la otra
     (auditor con ``view_users`` pero sin
     ``list_users`` — perfil "investigador
     puntual" que conoce IDs)

2.2 Actores Secundarios
=======================

- **User consultado**: pasivo. NO se le notifica
  la consulta (lecturas no son auditadas a
  granularidad de cada lectura).
- **Sistema (Backend)**: filtra, pagina, restringe
  campos.
- **BD analitica**: indices apropiados para
  performance.
- **Frontend**: tabla paginada, filtros, vista
  detalle expandible.
- **Auditor (P-16 audit selectivo)**: consume
  AuditEvent ``USERS_VIEWED_FOR_USER`` (cuando
  se filtra por user_id especifico) y
  ``USER_DETAIL_VIEWED``.

2.3 Precondiciones
==================

- Backend respondiendo en ``/api/users/`` (GET).
- BD MySQL accesible con indices recomendados
  (``state, created_at``, ``email``,
  ``username``).
- Invocante autenticado y con al menos una de
  las funciones (``list_users`` o
  ``view_users``).

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito (lectura listado)
------------------------------------------------

- Respuesta paginada con count + results +
  next/previous.
- Cada item con: id, username, email (parcial
  segun politica), full_name, state,
  ``created_at``, ``last_login_at``,
  AGRs activos.
- AuditEvent ``USERS_VIEWED_FOR_USER`` SOLO si
  se filtro por ``user_id`` especifico (P-16).

2.4.2 Postcondiciones de exito (lectura detalle)
------------------------------------------------

- Respuesta con todos los campos del User mas
  Assignments y AGRs vigentes con fechas.
- AuditEvent ``USER_DETAIL_VIEWED`` con
  ``actor_user_id`` y ``target_user_id``.

2.4.3 Postcondiciones de fallo
------------------------------

- EX-01..EX-05: rollback no aplica (operacion
  read-only). AuditEvent
  ``UNAUTHORIZED_ACCESS_ATTEMPT`` segun
  excepcion.
