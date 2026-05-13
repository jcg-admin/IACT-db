.. _uc-rpt-09-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- Crear / get / list ≤ 50 ms.

6.2 Confiabilidad
=================

- Disponibilidad ≥ 99.5%.

6.3 Seguridad
=============

- Filtros NO escapan segmento del User
  (validacion en write).
- Re-validacion al aplicar (P-69).

6.4 Auditabilidad
=================

- P-51 read-no-audit.
- Cambios audit ``FILTER_*``.

6.5 Usabilidad
==============

- Default filter.
- Search por nombre.
- Chips para acceso rapido.

6.6 Mantenibilidad
==================

- Schema versionado.
