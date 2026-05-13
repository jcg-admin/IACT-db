.. _uc-rpt-08-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- List P50 ≤ 50 ms.
- Detalle P50 ≤ 100 ms.
- Historico runs P50 ≤ 200 ms.

6.2 Confiabilidad
=================

- Disponibilidad ≥ 99.5%.
- Read replicas.

6.3 Seguridad
=============

- Filtro por ownership / scope.
- Sin PII.

6.4 Auditabilidad
=================

- P-51 read-no-audit.

6.5 Usabilidad
==============

- Indicador de salud por schedule (verde /
  amarillo / rojo).
- Acciones inline (pause / resume /
  delete / run-now).
- Search por nombre.

6.6 Mantenibilidad
==================

- Reuso de componentes de UC_RPT_07.
