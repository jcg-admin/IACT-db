.. _uc-rpt-17-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

- Performance: P50 ≤ 1 s con HLL (volumen
  alto); ≤ 500 ms con COUNT DISTINCT
  exacto (volumen bajo).
- Confiabilidad: ≥ 99.5%.
- Seguridad: view_unique_clients_reports;
  segment-bound; sin PII (CNST-026).
- Auditabilidad: P-51.
- Cumplimiento: hash con salt por tenant
  para prevenir rainbow tables.
