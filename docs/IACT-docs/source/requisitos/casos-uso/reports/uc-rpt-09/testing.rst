.. _uc-rpt-09-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

Unit, integration, security.

12.2 Tests unitarios
====================

UT-01: Validator estructura OK.
UT-02: Validator segment violation.
UT-03: Validator nombre duplicado check.

12.3 Tests de integracion
=========================

IT-01: Crear basico.
IT-02: Nombre duplicado → 400.
IT-03: Cross-segmento → 400.
IT-04: > 50 filtros → 429.
IT-05: Update / delete.
IT-06: List propios.
IT-07: Apply en historico.
IT-08: Default filter unico por
report_type.
IT-09: Segmento cambia → invalida.

12.4 Tests E2E
==============

E2E-01: User crea filtro + aplica.
E2E-02: Default filter aplicado al abrir.

12.5 Tests de seguridad
=======================

SEC-01: User crea filtro con segmento que
no tiene → 400 (P-58).
SEC-02: User no ve filtros de otros.
SEC-03: Apply revalidacion al consumir
(no se confia en cache de validacion).

12.6 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..06
   - CRUD
   - IT-01..06
 * - CA-07
   - Ownership
   - SEC-02
 * - CA-08
   - Apply
   - IT-07, E2E-01
 * - CA-09
   - Default
   - IT-08, E2E-02
 * - CA-10
   - Invalid
   - IT-09

12.7 Cobertura
==============

- 3 unit
- 9 integration
- 2 E2E
- 3 security
- 100% de los 10 CAs
