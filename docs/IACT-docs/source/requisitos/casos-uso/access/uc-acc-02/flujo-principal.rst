.. _uc-acc-02-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker abre detalle del User           (Frontend)
   PASO 2   Selecciona funciones a revocar
            + revoke_reason                         (Frontend)
   PASO 3   Modal robusto de confirmacion           (Frontend)
   PASO 4   DELETE /api/users/{id}/functions/       (FE → BE)
   PASO 5   Validar JWT (CNST-009)                  (Backend)
   PASO 6   Validar funcion revoke_functions        (Backend)
   PASO 7   Validar User destino (existe + state)   (Backend → BD)
   PASO 8   Validar P-11 anti-self-revoke           (Backend)
   PASO 9   Localizar Assignments ACTIVE matching   (Backend → BD)
   PASO 10  Filtrar idempotente (skip ya REVOKED)   (Backend)
   PASO 11  Calcular post-revoke state + warnings   (Backend → BD)
   PASO 12  UPDATE Assignments → REVOKED            (Backend → BD)
   PASO 13  Invalidar cache de permisos             (Backend, post-COMMIT)
   PASO 14  Emitir AuditEvent FUNCTIONS_REVOKED     (Backend → BD)
   PASO 15  (Opcional) InternalMessage al User      (Backend → BD)
   PASO 16  200 OK con resumen + warnings           (BE → FE)
   PASO 17  Frontend muestra confirmacion           (Frontend)

3.2 Detalle paso a paso
=======================

PASO 4 — Request
----------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Metodo**
   - DELETE (semantica baja logica per BR-009)
 * - **Path**
   - ``/api/users/{user_id}/functions/``
 * - **Headers**
   - ``Authorization: Bearer <token>``,
     ``Content-Type: application/json``
 * - **Body**
   - ``{"function_ids": [1, 2],
     "revoke_reason": "Cambio de rol",
     "notify_user": true}``

DELETE con body JSON es valido para semantica
de bulk operations sobre subrecursos. La
alternativa POST a
``/api/users/{id}/functions/revoke/`` se
considera tambien pero DELETE preserva la
simetria con UC_ACC_01 POST.

PASOS 5-7 — Validaciones
------------------------

Identicas a UC_ACC_01 (auth, RBAC, user
existence/state).

PASO 8 — Anti-self-revoke (P-11)
--------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Condicion**
   - ``user_id == invoker.id`` con politica
     ``ANTI_SELF_REVOKE_FUNCTIONS=true``
     (default).
 * - **Justificacion**
   - defensa anti-lockout: invocante no
     debe poder revocar sus propias funciones
     (especialmente
     ``revoke_functions`` misma — bug
     critico que dejaria al admin sin la
     capacidad de revertir).
 * - **Errores**
   - EX-04 (400 SELF_REVOKE_FORBIDDEN).

PASO 9 — Localizar Assignments
------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``AssignmentRepository.list_active(
     user=target,
     function_ids__in=payload.function_ids)``
 * - **Resultado**
   - subset de Assignments ACTIVE que matchean.

PASO 10 — Filtrar idempotente
-----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - separar:
     ``to_revoke_ids`` =
     payload.function_ids ∩
     {a.function_id for a in active_matches};
     ``skipped_ids`` =
     payload.function_ids - to_revoke_ids
     (estas son funciones que el User no tiene
     activas — ya REVOKED o nunca asignadas).

PASO 11 — Calcular post-revoke + warnings
-----------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``post_revoke_active = current_active -
     to_revoke_ids``;
     evaluar:

     - ``no_functions`` si
       len(post_revoke_active) == 0
     - ``critical_revoked`` si
       to_revoke_ids ∩ CRITICAL_FUNCTIONS != ∅
     - ``last_holder`` si para alguna funcion
       en to_revoke_ids el target es uno de
       N <= LAST_HOLDER_THRESHOLD que la tiene
       (politica)
 * - **Output**
   - ``warnings`` dict que se incluira en
     response y AuditEvent payload.

PASO 12 — UPDATE Assignments
----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``AssignmentRepository.update_to_revoked(
     to_revoke_ids,
     revoked_at=NOW(),
     revoked_by_admin_id=invoker.id,
     revoke_reason=payload.revoke_reason)``
 * - **Clase**
   - ``Assignment`` (escritura masiva)

PASO 13 — Cache invalidate (post-COMMIT)
----------------------------------------

``PermissionCache.invalidate(target.id)``
fuera de la transaccion (P-29).

PASO 14 — AuditEvent
--------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - emit ``FUNCTIONS_REVOKED`` con payload:
     ``{target_user_id,
     function_ids_revoked: to_revoke_ids,
     function_ids_skipped: skipped_ids,
     revoke_reason,
     post_revoke_active_count,
     warnings, ip, user_agent}``
 * - **CNST**
   - CNST-025 + CNST-026

PASO 15 — InternalMessage opcional
----------------------------------

Si politica ``NOTIFY_USER_ON_REVOKE=true`` o
flag ``payload.notify_user=true``: enviar
mensaje al User destino con display_names de
funciones revocadas y el ``revoke_reason``.

PASO 16 — Response 200
----------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Body**
   - JSON con campos ``target_user_id``,
     ``revoked``, ``skipped``,
     ``revoke_reason``,
     ``post_revoke_active_count``,
     ``warnings`` (objeto con
     ``no_functions``,
     ``critical_revoked``,
     ``last_holder``), y ``user_notified``.
     Ver Parte 7 § 7.3 para ejemplo completo.

PASO 17 — Confirmacion frontend
-------------------------------

Toast: "Revocadas N funciones de {username}.
M ya no estaban activas y se omitieron." Si
hay warnings, modal informativo despues del
toast con detalle.

3.3 Atomicidad
==============

PASOS 12-15 dentro de transaccion atomica:

::

   BEGIN
     UPDATE assignment SET state='REVOKED',
       revoked_at=NOW(),
       revoked_by_admin_id=invoker.id,
       revoke_reason=...
       WHERE user_id=target.id
         AND function_id IN (to_revoke_ids)
         AND state='ACTIVE';
     INSERT INTO audit_event (
       event_type='FUNCTIONS_REVOKED', ...);
     [opcional] INSERT INTO internal_message;
   COMMIT

   -- Cache invalidate post-COMMIT (P-29)
   PermissionCache.invalidate(target.id);

Si la TX falla, ROLLBACK total. Cache NO se
invalida. El UC es retry-safe.
