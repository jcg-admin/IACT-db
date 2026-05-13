.. _uc-rpt-03-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Metrica
   - Target
   - Notas
 * - P50 (cache hit)
   - ≤ 5 ms
   -
 * - P50 (last_24h)
   - ≤ 200 ms
   -
 * - P50 (last_30d)
   - ≤ 500 ms
   -
 * - P50 (last_90d / custom)
   - ≤ 2 s
   -
 * - P95
   - ≤ 5 s
   -
 * - Max range
   - 2 anos
   - online

6.2 Confiabilidad
=================

- Disponibilidad ≥ 99.5%.
- Read replicas.
- Particionamiento mensual / trimestral.

6.3 Seguridad
=============

- ``view_historical_reports`` enforcement.
- Filtro segmento.
- Sin PII.

6.4 Auditabilidad
=================

- P-51 read-no-audit.
- Volumen anomalo de queries detectado por
  metrics.

6.5 Usabilidad
==============

- Comparative side-by-side claro.
- Tooltips con definiciones de KPIs.
- Save view (UC_RPT_10).

6.6 Mantenibilidad
==================

- Buckets configurables por ADR.
- Aging policy: > 2 anos → archive.
