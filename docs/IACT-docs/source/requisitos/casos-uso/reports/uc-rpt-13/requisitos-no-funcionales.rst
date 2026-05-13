.. _uc-rpt-13-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

- Performance: P50 list ≤ 500 ms;
  detail ≤ 1 s.
- Confiabilidad: ≥ 99.5%, read replicas.
- Seguridad: view_queue_reports;
  segment-bound; sin PII.
- Auditabilidad: P-51 list no audit;
  detail con audit (P-44).
- Usabilidad: sortable, exportable.
- Cumplimiento: igual que UC_RPT_12.
