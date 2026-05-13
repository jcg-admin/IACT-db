.. _uc-acc-08-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Idempotencia (todas ya granted activas)
==================================================

**Activador**: PASO 11 — todas las funciones
ya tienen ExceptionalPermission ACTIVE no
expirado.

**Diferencia**: cero INSERT. AuditEvent
EXCEPTIONAL_PERMISSION_GRANT_NOOP. 200 OK
informativo.

4.2 FA-02: Mix nuevas + ya activas
==================================

**Activador**: subset del payload ya granted.

**Diferencia**: separa ``new_function_ids``
(insertar) vs ``already_granted_ids``
(skip). Response 201 con
``granted`` y ``skipped``.

4.3 FA-03: Re-grant despues de EXPIRED
======================================

**Activador**: existe ExceptionalPermission
con state=EXPIRED para esa funcion (cron ya
la procesó).

**Diferencia**: nuevo ExceptionalPermission
ACTIVE creado. EXPIRED previo preservado en
historial.

4.4 FA-04: ticket_reference en justification
============================================

**Activador**: politica
``REQUIRE_TICKET_REFERENCE=true``.

**Diferencia**: PASO 9 valida que
``justification`` contiene patron
``TKT-NNNN`` o equivalente. Si no, EX-XX.

4.5 FA-05: Revocacion explicita antes de expirar
================================================

**Activador**: NO es parte de UC_ACC_08; es
un UC complementario sobre
ExceptionalPermission. Documentar como
referencia.

::

   POST /api/users/{id}/exceptional-permissions/
     {permission_id}/revoke/
   con funcion ``revoke_exceptional_permission``

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
   - Todas ya granted
   - cero INSERT, NOOP
   - 200 OK
 * - FA-02
   - Mix nuevas + activas
   - granted + skipped lists
   - 201 Created
 * - FA-03
   - Re-grant post EXPIRED
   - nuevo ACTIVE, EXPIRED preservado
   - 201 Created
 * - FA-04
   - ticket_reference required
   - validar patron en justification
   - 201 / 400
 * - FA-05
   - Revocacion explicita
   - UC separado
   - n/a
