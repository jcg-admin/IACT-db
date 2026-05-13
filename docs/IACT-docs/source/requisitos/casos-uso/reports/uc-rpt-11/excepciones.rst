.. _uc-rpt-11-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT — 401.
5.2 EX-02: Sin share_reports — 403.
5.3 EX-03: View no existe — 404.
5.4 EX-04: Owner no es invoker — 403.
5.5 EX-05: Target invalido — 400.
5.6 EX-06: Target == owner — 400.
5.7 EX-07: expires_at en pasado — 400.
5.8 EX-08: Share expirado al apply — 403 SHARE_EXPIRED.
5.9 EX-09: Share revocado al apply — 403 SHARE_NOT_FOUND.
5.10 EX-10: Receptor sin segmento al apply — 400.
5.11 EX-11: Audit fail — 500.

5.12 Resumen
============

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..02
   - JWT / RBAC
   - 401 / 403
   - middleware / UNAUTHORIZED
 * - EX-03..07
   - Validation share
   - 404 / 403 / 400
   - validation
 * - EX-08..10
   - Apply
   - 403 / 400
   - validation
 * - EX-11
   - Audit fail
   - 500
   - operacion FAILED
