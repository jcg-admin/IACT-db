.. _uc-perm-03-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CAs heredados de UC_ACC_08
==============================

CA-01..15 (grant happy, justification
obligatoria, expires_at bounds, auto-grant
prohibido, SoD violation, mailbox HARD,
sin permiso, idempotencia parcial,
re-grant post EXPIRED, ticket_reference,
audit reforzado, cache post-COMMIT,
throttling estricto, cron expiracion).

9.2 CAs especificos PERM
========================

9.2.1 CA-PERM-01: Preview NO persiste
-------------------------------------

::

   GIVEN GET preview ejecutado
   WHEN  inspecciono BD
   THEN  ZERO ExceptionalPermission
   AND   ZERO AuditEvent

9.2.2 CA-PERM-02: Modal muestra warning audit
---------------------------------------------

::

   GIVEN modal de confirmacion
   WHEN  invoker visualiza
   THEN  banner "esta operacion sera
         auditada con visibilidad alta"

9.2.3 CA-PERM-03: Catalogo refresh post-grant
---------------------------------------------

::

   GIVEN grant exitoso
   WHEN  catalogo PERM se re-renderiza
   THEN  count de excepcionales vigentes
         actualizado

9.2.4 CA-PERM-04: Audit unificado
=================================

::

   GIVEN grant via vista PERM
   WHEN  inspecciono AuditEvent
   THEN  event_type ==
         EXCEPTIONAL_PERMISSION_GRANTED
   AND   payload no distingue origen UI

9.3 Resumen
===========

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..15
   - Heredados UC_ACC_08
   - Funcional / cumplimiento
 * - CA-PERM-01
   - Preview no persiste
   - Funcional
 * - CA-PERM-02
   - Modal warning audit
   - UX
 * - CA-PERM-03
   - Catalogo refresh
   - UX
 * - CA-PERM-04
   - Audit unificado
   - Cumplimiento
