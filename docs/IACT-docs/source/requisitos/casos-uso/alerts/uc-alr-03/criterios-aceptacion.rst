.. _uc-alr-03-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Ack basico → 200 + state ack.
CA-02: Note guardado.
CA-03: Cross-segmento → 403.
CA-04: Ya ack → 409 idempotente.
CA-05: Resolved → 409.
CA-06: Audit ALERT_ACKNOWLEDGED.
CA-07: Suprime notificaciones futuras.
CA-08: Bulk endpoint.
CA-09: Sin permiso → 403.
CA-10: Atomicidad (audit fail → rollback).

Resumen
=======

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02
   - Ack basico
   - Funcional
 * - CA-03..05
   - Validation
   - Robustez
 * - CA-06..07
   - Audit + suppress
   - Compliance/UX
 * - CA-08
   - Bulk
   - Funcional
 * - CA-09
   - Auth
   - Seguridad
 * - CA-10
   - Atomicidad
   - Confiabilidad
