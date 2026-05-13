.. _uc-rpt-11-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- Crear share P50 ≤ 100 ms.
- Apply share P50 ≤ 50 ms (incluye
  resolucion).

6.2 Confiabilidad
=================

- Disponibilidad ≥ 99.5%.
- Cascade delete de shares al borrar view.

6.3 Seguridad
=============

- ``share_reports`` enforcement.
- Receptor aplica con SU scope.
- expires_at TTL configurable.

6.4 Auditabilidad
=================

- ``REPORT_SHARED``,
  ``REPORT_SHARE_REVOKED``,
  ``REPORT_SHARE_APPLIED`` (P-44 visibility
  audit prio).

6.5 Usabilidad
==============

- Modal de share con search User / AGR.
- Indicador de shares activos en view
  detail.
- Mailbox notify al receptor con resumen.

6.6 Cumplimiento
================

- CNST-001: NO email externo.
- CNST-002: mailbox interno.
