.. _uc-rpt-10-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Validator OK con todos los campos.
UT-02: Validator rechaza columna desconocida.
UT-03: Validator rechaza cross-segmento.

IT-01: Crear con full payload.
IT-02: Apply funciona.
IT-03: Clone derived.
IT-04: Default unique por report_type.
IT-05: Columna deprecada → unavailable.
IT-06: > 30 vistas 429.
IT-07: User no ve vistas de otros (sin
shared).

E2E-01: User configura reporte y guarda
vista; vuelve y ve mismo estado.
E2E-02: Default aplicado al abrir.

SEC-01: Cross-segmento bloqueado.
SEC-02: Apply de vista de otro sin shared
→ 403.

Mapeo CA → Tests:

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Crear
   - IT-01
 * - CA-02
   - Cross-segmento
   - UT-03, SEC-01
 * - CA-03
   - Columna invalida
   - UT-02
 * - CA-04
   - > 30
   - IT-06
 * - CA-05..06
   - Default / apply
   - IT-02, IT-04, E2E-02
 * - CA-07
   - Clone
   - IT-03
 * - CA-08
   - Deprecada
   - IT-05
 * - CA-09
   - CRUD
   - integration

Cobertura: 3 unit, 7 integration, 2 E2E,
2 security. 100% de los 9 CAs.
