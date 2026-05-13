.. _uc-perm-04-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Permission ya REVOKED (idempotencia)
===============================================

**Activador**: PASO 8 — state ya REVOKED.

**Diferencia**: AuditEvent
EXCEPTIONAL_PERMISSION_REVOKE_NOOP. 200 OK
informativo con
``original_revoked_at``,
``original_revoked_by_admin_id``,
``original_revoke_reason``.

4.2 FA-02: Permission EXPIRED
=============================

**Activador**: state EXPIRED (cron ya
proceso).

**Diferencia**: 400 INVALID_STATE — no se
puede revocar lo ya expirado. Ya no esta
ACTIVE.

4.3 FA-03: Revocacion masiva del User
=====================================

**Activador**: payload con
``permission_ids: [...]`` o flag
``revoke_all_active=true``.

**Diferencia**: backend itera (cada
revocacion atomica) o transaccion bulk
all-or-nothing (politica). Audit por cada
permission revocado.

4.4 FA-04: Notificacion deferida
================================

**Activador**: setting
``DEFERRED_NOTIFICATION=true``.

**Diferencia**: InternalMessage se inserta
pero con flag ``deferred_until=NOW()+1h``.
Util para casos donde el admin no quiere
revelar inmediatamente la revocacion (ej.
investigacion en curso).

4.5 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01
   - Ya REVOKED
   - Audit NOOP
   - 200 OK
 * - FA-02
   - Permission EXPIRED
   - 400 INVALID_STATE
   - 400
 * - FA-03
   - Revocacion masiva
   - bulk/iter
   - 200 con counts
 * - FA-04
   - Notificacion deferida
   - InternalMessage con delay
   - 200 OK
