.. _uc-perm-09-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Emit basico exitoso
==============================

**DADO** caller con event valido,
**ENTONCES** AuditEvent persistido + id
retornado.

9.2 CA-02: Inmutabilidad
========================

**DADO** AuditEvent persistido,
**CUANDO** UPDATE / DELETE intentado,
**ENTONCES** rechazado por BD constraint.

9.3 CA-03: Validation rechaza event_type desconocido
====================================================

**ENTONCES** AuditValidationError.

9.4 CA-04: Validation rechaza payload > 16 KB
=============================================

**ENTONCES** AuditValidationError.

9.5 CA-05: PII detectado bloquea
================================

**DADO** payload contiene email plano,
**ENTONCES** AuditPIIDetected.

9.6 CA-06: Hash de PII obligatorio
==================================

**DADO** LOGIN_FAILED con username,
**ENTONCES** payload contiene
``username_hash``, NO username plano.

9.7 CA-07: INSERT en transaccion del caller
===========================================

**DADO** caller con tx abierta,
**ENTONCES** INSERT en MISMA tx (verificable
con rollback test).

9.8 CA-08: P-09 rollback en BD timeout
======================================

**DADO** INSERT timeout,
**ENTONCES** caller hace rollback de su
operacion principal.

9.9 CA-09: Push alert post-COMMIT
=================================

**DADO** COMMIT exitoso,
**ENTONCES** AlertHook.consume llamado
DESPUES del COMMIT.

9.10 CA-10: Alert engine fail no afecta caller
==============================================

**DADO** AlertEngine caido,
**ENTONCES** caller succeed; evento ya
persistido; reintento async.

9.11 CA-11: Batch emit atomico
==============================

**DADO** N events,
**CUANDO** 1 falla,
**ENTONCES** ROLLBACK del batch entero.

9.12 CA-12: CRITICAL_ACTION replica
===================================

**DADO** event_type con priority=critical,
**ENTONCES** replicado sincrono a log
secundario.

9.13 CA-13: UNAUTHORIZED en denial
==================================

**DADO** AuthorizationGuard deniega,
**ENTONCES** evento UNAUTHORIZED emitido
con attempted_function + reason.

9.14 CA-14: Request_id correlacion
==================================

**DADO** request HTTP con request_id,
**ENTONCES** event.request_id == request.id.

9.15 CA-15: UTC timestamp
=========================

**DADO** evento creado,
**ENTONCES** created_at en UTC.

9.16 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Emit basico
   - Funcional
 * - CA-02
   - Inmutabilidad
   - Cumplimiento
 * - CA-03..04
   - Validacion
   - Robustez
 * - CA-05..06
   - PII / hash
   - Cumplimiento
 * - CA-07..08
   - P-09 atomicidad
   - Confiabilidad
 * - CA-09..10
   - Alerta best-effort
   - Confiabilidad
 * - CA-11
   - Batch atomico
   - Funcional
 * - CA-12
   - P-39 critical replica
   - Cumplimiento
 * - CA-13
   - UNAUTHORIZED
   - Seguridad
 * - CA-14..15
   - Trazabilidad
   - Auditabilidad
