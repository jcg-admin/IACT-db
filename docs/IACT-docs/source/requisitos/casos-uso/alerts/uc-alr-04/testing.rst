.. _uc-alr-04-parte-12:

==================
Parte 12 — Testing
==================

UT-01: TimingCalculator ack delta.
UT-02: TimingCalculator resolve delta.

IT-01: List con range.
IT-02: Filtros aplican.
IT-03: Cross-segmento → 403.
IT-04: > 1 ano → 400.
IT-05: BD timeout.

E2E-01: Auditor analiza.

SEC-01: Cross-segmento bloqueado.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - List
   - IT-01..04
 * - CA-05..08
   - Metricas
   - UT-01, UT-02
 * - CA-09..10
   - Robustez
   - integration

Cobertura: 2 unit, 5 integration, 1 E2E,
1 security. 100% de los 10 CAs.
