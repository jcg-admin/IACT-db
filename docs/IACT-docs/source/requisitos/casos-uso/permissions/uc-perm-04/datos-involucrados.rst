.. _uc-perm-04-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoint
============

DELETE
``/api/users/{user_id}/exceptional-permissions/{permission_id}/``
con funcion ``revoke_exceptional_permission``.

7.2 Request
===========

.. code-block:: http

   DELETE /api/users/42/exceptional-permissions/510/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "revoke_reason": "TKT-12345 cerrado.
                       Acceso ya no es
                       requerido."
   }

7.3 Response 200
================

.. code-block:: json

   {
     "permission_id": 510,
     "target_user_id": 42,
     "function_id": 1,
     "function_code": "view_users",
     "state": "REVOKED",
     "revoked_at": "2026-05-01T19:35:00Z",
     "revoked_by_admin_id": 1,
     "revoke_reason": "TKT-12345 cerrado.",
     "previous_expires_at": "2026-05-15T...",
     "user_notified": true
   }

7.4 Modelo de datos tocado
==========================

7.4.1 ExceptionalPermission (UPDATE)
------------------------------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Cambio
 * - state
   - ENUM
   - ACTIVE → REVOKED
 * - revoked_at
   - DATETIME
   - NOW()
 * - revoked_by_admin_id
   - BIGINT
   - invoker.id
 * - revoke_reason
   - TEXT
   - payload.revoke_reason

NO se modifica: granted_at,
granted_by_admin_id, expires_at,
justification, ticket_reference (historial
preservado).

7.4.2 InternalMessage (INSERT obligatorio)
------------------------------------------

::

   subject: "Permiso temporal revocado"
   body: "Tu permiso temporal {function_code}
          fue revocado anticipadamente.
          Motivo: {revoke_reason}."

7.4.3 AuditEvent (INSERT)
-------------------------

::

   event_type:
     EXCEPTIONAL_PERMISSION_REVOKED
   payload:
     {target_user_id, permission_id,
      function_id, function_code,
      revoke_reason, previous_expires_at,
      ip, user_agent}

7.4.4 PermissionCache invalidate
--------------------------------

post-COMMIT.

7.5 FR derivados
================

- FR-PERM-04-01: Validar JWT.
- FR-PERM-04-02: Verificar
  revoke_exceptional_permission.
- FR-PERM-04-03: Localizar
  ExceptionalPermission ACTIVE.
- FR-PERM-04-04: Validar P-11 anti-self.
- FR-PERM-04-05: Validar revoke_reason.
- FR-PERM-04-06: UPDATE state=REVOKED +
  metadata.
- FR-PERM-04-07: INSERT InternalMessage
  obligatorio (HARD).
- FR-PERM-04-08: INSERT AuditEvent.
- FR-PERM-04-09: Cache invalidate
  post-COMMIT.
- FR-PERM-04-10: Construir response.
