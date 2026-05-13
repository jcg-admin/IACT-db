.. _uc-usr-03-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen
===========

::

   PASO 1   Admin abre vista de detalle del User    (Frontend)
   PASO 2   Click "Modificar" + edita campos        (Frontend)
   PASO 3   PATCH /api/users/{id}/                  (FE → BE)
   PASO 4   Validar JWT + RBAC modify_users         (Backend)
   PASO 5   Validar User destino existe + no
            ELIMINATED                              (Backend → BD)
   PASO 6   Validar transicion de state permitida
            (P-11 anti-self-state-change)           (Backend)
   PASO 7   Validar campos individuales
            (email unico si cambia, etc.)           (Backend → BD)
   PASO 8   UPDATE User                             (Backend → BD)
   PASO 9   Si state → BLOCKED:
            cerrar Sessions ACTIVE                  (Backend → BD)
   PASO 10  Emitir AuditEvent USER_MODIFIED         (Backend → BD)
   PASO 11  (Opcional) InternalMessage al User      (Backend → BD)
   PASO 12  200 OK con datos actualizados           (BE → FE)
   PASO 13  Frontend toast confirmacion             (Frontend)

3.2 Detalles relevantes
=======================

PASO 6 — Transiciones de state permitidas:

::

   ACTIVE   → INACTIVE | BLOCKED
   INACTIVE → ACTIVE   | BLOCKED
   BLOCKED  → ACTIVE   | INACTIVE
   ELIMINATED → (ninguna — fin de vida)

   Restriccion adicional (P-11):
   admin NO puede cambiar SU PROPIO state via
   este UC.

PASO 7 — Si ``email`` cambia, validar unicidad
en sistema (excluyendo el propio User).

PASO 8-10 — Atomicos en transaccion.

3.3 Atomicidad
==============

::

   BEGIN
     UPDATE User SET (campos)... WHERE id = ?;
     IF state -> BLOCKED:
       UPDATE Session SET state='CLOSED',
         close_reason='ADMIN_BLOCKED'
         WHERE user_id = ? AND state='ACTIVE';
       INSERT BlacklistedToken (...);
     END IF;
     INSERT AuditEvent USER_MODIFIED;
     IF state cambio: INSERT InternalMessage;
   COMMIT
