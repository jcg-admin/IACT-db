.. _uc-perm-04-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre lista de excepcionales
            del User                              (Frontend)
   PASO 2   Selecciona permiso a revocar         (Frontend)
   PASO 3   Ingresa revoke_reason                (Frontend)
   PASO 4   Modal robusto + confirmacion         (Frontend)
   PASO 5   DELETE /api/users/{id}/
            exceptional-permissions/{permid}/    (FE → BE)
   PASO 6   Validar JWT (CNST-009)               (Backend)
   PASO 7   Validar funcion
            revoke_exceptional_permission         (Backend)
   PASO 8   Validar User + permission existe
            ACTIVE                                (Backend → BD)
   PASO 9   Validar P-11 anti-self                (Backend)
   PASO 10  Validar revoke_reason                (Backend)
   PASO 11  UPDATE state → REVOKED + metadata    (Backend → BD)
   PASO 12  Invalidar cache (post-COMMIT)         (Backend)
   PASO 13  INSERT InternalMessage OBLIGATORIO   (Backend → BD)
   PASO 14  AuditEvent
            EXCEPTIONAL_PERMISSION_REVOKED        (Backend → BD)
   PASO 15  200 OK con resumen                   (BE → FE)
   PASO 16  Refresh vista                         (Frontend)

3.2 Detalle clave
=================

PASO 8 — Localizar permission
-----------------------------

::

   permission = ExceptionalPermissionRepo
                  .get_active_by_id(perm_id)
   if not permission: raise NotFound
   if permission.state != ACTIVE:
       raise InvalidState (ya REVOKED o EXPIRED)
   if permission.user_id != target_user_id:
       raise UrlMismatch

PASO 11 — UPDATE atomico
------------------------

::

   permission.state = REVOKED
   permission.revoked_at = NOW()
   permission.revoked_by_admin_id =
     invoker.id
   permission.revoke_reason = payload.reason
   save()

3.3 Atomicidad
==============

PASOS 11-14 atomicos. Mailbox-or-abort HARD
(P-10 — la notificacion al User es
auditabilidad de la revocacion). Cache
post-COMMIT.
