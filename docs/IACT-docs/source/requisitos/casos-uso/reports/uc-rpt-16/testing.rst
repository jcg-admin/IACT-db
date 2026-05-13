.. _uc-rpt-16-parte-12:

==================
Parte 12 — Testing
==================

UT-01: PathMiner extrae secuencia.
UT-02: Top-N counter.
UT-03: Drop-off rate por nodo.

IT-01: Totales correctos.
IT-02: Filtro ivr_id.
IT-03: Cross-segmento → 403.
IT-04: BD timeout.

E2E-01: Optimizar IVR via reporte.

SEC-01: Cross-segmento bloqueado.

Mapeo CA → Tests:

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - Datos
   - IT-01, UT-01..03
 * - CA-05, 09
   - Auth
   - IT-03, SEC-01
 * - CA-06..08
   - Robustez
   - integration
 * - CA-10
   - Filtros
   - IT-02

Cobertura: 3 unit, 4 integration, 1 E2E,
1 security. 100% de los 10 CAs.
