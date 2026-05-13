.. _uc-rpt-12-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Sin view_agent_reports — 403.
5.3 EX-03: Sin view_agent_detail (en detalle) — 403.
5.4 EX-04: agent_id no existe — 404.
5.5 EX-05: agent_id cross-segmento — 403.
5.6 EX-06: Periodo invalido — 400.
5.7 EX-07: BD timeout — 503.

5.8 Resumen
===========

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..03
   - Auth/RBAC
   - 401/403
   - middleware/UNAUTHORIZED
 * - EX-04..06
   - Validation
   - 404/403/400
   - validation
 * - EX-07
   - BD
   - 503
   - operacion FAILED
