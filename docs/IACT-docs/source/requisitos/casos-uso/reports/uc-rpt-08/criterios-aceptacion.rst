.. _uc-rpt-08-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: List schedules del User
==================================

User con N schedules → 200 + N items.

9.2 CA-02: Sin schedules
========================

200 con items=[].

9.3 CA-03: Filtro status=active
===============================

Solo activos.

9.4 CA-04: Detalle existe
=========================

GET id valido → 200 + ultimo run.

9.5 CA-05: Detalle no existe
============================

404.

9.6 CA-06: Historico runs
=========================

GET runs/ → list de ejecuciones (30 dias).

9.7 CA-07: User no ve schedules de otros
========================================

Filtro automatico por actor_id.

9.8 CA-08: Auditor scope global
===============================

User con scope amplio ve schedules de
sus segmentos.

9.9 CA-09: Sin permiso 403
==========================

403.

9.10 CA-10: BD timeout 503
==========================

503.

9.11 Resumen
============

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - List + filtros
   - Funcional
 * - CA-04..06
   - Detalle + runs
   - Funcional
 * - CA-07..08
   - Ownership / scope
   - Seguridad
 * - CA-09
   - Sin permiso
   - Seguridad
 * - CA-10
   - BD timeout
   - Robustez
