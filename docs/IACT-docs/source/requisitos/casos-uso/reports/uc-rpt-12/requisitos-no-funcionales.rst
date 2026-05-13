.. _uc-rpt-12-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- List P50 ≤ 500 ms (50 agentes).
- Detalle P50 ≤ 1 s.
- Cache TTL 15 min.

6.2 Confiabilidad
=================

- Disponibilidad ≥ 99.5%.
- Read replicas.

6.3 Seguridad
=============

- ``view_agent_reports`` enforcement.
- ``view_agent_detail`` para detalle.
- Filtro segmento.
- CNST-026 sin PII.

6.4 Auditabilidad
=================

- P-51 list no audit.
- P-44 detail audit (AGENT_DETAIL_VIEWED).

6.5 Usabilidad
==============

- Tabla sortable, exportable (UC_RPT_04).
- Tooltips con definicion de KPIs.
- Comparativos.

6.6 Cumplimiento
================

- Privacidad: agentes pueden ver SUS
  propios reportes (auto-funcion
  implícita).
