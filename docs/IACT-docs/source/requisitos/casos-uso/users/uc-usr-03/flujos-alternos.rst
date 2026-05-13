.. _uc-usr-03-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Bloquear (state → BLOCKED)
=====================================

**Activador**: PATCH con ``state='BLOCKED'``.

**Diferencia**: PASO 9 ejecuta cierre de Sessions
+ blacklist tokens. AuditEvent payload incluye
``transition='ACTIVE→BLOCKED'`` o
``'INACTIVE→BLOCKED'``.

**Postcondicion**: User no puede iniciar sesion
hasta UC_USR_03 con ``state → ACTIVE`` (FA-02).

4.2 FA-02: Desbloquear (state → ACTIVE desde BLOCKED)
=====================================================

**Activador**: PATCH con ``state='ACTIVE'`` y
estado actual ``BLOCKED``.

**Diferencia**: ninguna respecto al PASO 8.
PASO 9 NO ejecuta cierre (no aplica).
AuditEvent transition tracker.

4.3 FA-03: Reactivar usuario INACTIVE
=====================================

**Activador**: PATCH ``state='ACTIVE'`` con
estado actual ``INACTIVE``. Similar a FA-02 sin
side-effect.

4.4 FA-04: Cambio solo de datos personales
==========================================

**Activador**: PATCH solo modifica
``first_name``, ``last_name`` (sin state).

**Diferencia**: NO cierra Sessions. AuditEvent
payload ``fields_changed=['first_name',
'last_name']``.

4.5 FA-05: Cambio de email
==========================

**Activador**: PATCH cambia ``email``.

**Diferencia**: validacion adicional de unicidad
(EX-05 si duplicado). Tras el cambio, opcional
InternalMessage al User notificando el cambio
(politica anti-takeover).

4.6 FA-06: Cambio de segmento operacional
=========================================

**Activador**: PATCH cambia ``segment_id``
(CNST-008).

**Diferencia**: AuditEvent registra
``old_segment_id`` / ``new_segment_id``. El
cambio reconfigura visibilidad de datos del
User en sub-flujos donde aplica filtrado por
segmento.

4.7 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia clave
   - Status
 * - FA-01
   - state → BLOCKED
   - Cierra Sessions activas
   - 200 OK
 * - FA-02
   - state BLOCKED → ACTIVE
   - Sin cierre, transition tracker
   - 200 OK
 * - FA-03
   - state INACTIVE → ACTIVE
   - Reactivacion
   - 200 OK
 * - FA-04
   - Solo datos personales
   - Sin side-effect en sesiones
   - 200 OK
 * - FA-05
   - Cambio email
   - Validacion unicidad + opcional notif
   - 200 OK
 * - FA-06
   - Cambio segmento
   - Reconfigura visibilidad (CNST-008)
   - 200 OK
