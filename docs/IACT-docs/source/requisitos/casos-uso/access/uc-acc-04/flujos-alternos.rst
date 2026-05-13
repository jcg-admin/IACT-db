.. _uc-acc-04-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Idempotencia (AGR ya asignado)
=========================================

**Activador**: PASO 10 — User ya tiene
Assignment ACTIVE para ese AGR.

**Diferencia**: PASO 13 NO ejecuta UPDATE.
AuditEvent AGR_ASSIGN_NOOP con
``original_granted_at``. Response 200 OK
informativo.

4.2 FA-02: Asignacion temporal con expires_at
=============================================

**Activador**: payload incluye ``expires_at``
(BR-008).

**Diferencia**: Assignment creado con
``expires_at``. Cron eventualmente lo
expirara → state EXPIRED.

**Validaciones**: NOW()+1h ≤ expires_at ≤
NOW()+1y (politica).

4.3 FA-03: AGR custom
=====================

**Activador**: ``access_group_id`` apunta a un
AGR custom (creado via UC_PERM_05) en vez de
predefinido AGR-001..010.

**Diferencia**: ninguna en procesamiento.
AuditEvent payload incluye
``access_group_type='custom'``.

4.4 FA-04: Re-asignacion despues de revocacion
==============================================

**Activador**: existe Assignment(user, AGR,
state='REVOKED') previo.

**Diferencia**: nuevo Assignment ACTIVE
creado. Assignment REVOKED preservado en
historial.

4.5 FA-05: Subset de funciones del AGR ya tiene el User
=======================================================

**Activador**: PASO 11/12 — algunas funciones
del AGR ya estan asignadas directamente al
User (via UC_ACC_01).

**Diferencia**: ninguna en procesamiento — el
Assignment AGR se crea normalmente. La vista
efectiva (UC_ACC_03) consolidara mostrando
ambas sources para esas funciones.

**AuditEvent**: ``functions_count_added``
refleja la cantidad NUEVA (excluye las que ya
estaban directas).

4.6 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01
   - AGR ya asignado
   - NOOP, audit
   - 200 OK
 * - FA-02
   - expires_at
   - Assignment temporal
   - 201 Created
 * - FA-03
   - AGR custom
   - Audit metadata
   - 201 Created
 * - FA-04
   - Re-asignacion post revoke
   - Nuevo Assignment, REVOKED preservado
   - 201 Created
 * - FA-05
   - Subset ya directo
   - functions_count_added < AGR.size
   - 201 Created
