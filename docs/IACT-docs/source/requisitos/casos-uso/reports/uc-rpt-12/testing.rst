.. _uc-rpt-12-parte-12:

==================
Parte 12 — Testing
==================

UT-01: KPI TMO derivado.
UT-02: KPI Occupancy.
UT-03: KPI Adherence.
UT-04: Build summary del team.

IT-01: List basico segmento.
IT-02: Filtro team.
IT-03: Sort por KPI.
IT-04: Cache hit segunda llamada.
IT-05: Detalle requiere view_agent_detail.
IT-06: Detalle cross-segmento → 403.
IT-07: Detalle audit emitido.
IT-08: Sin agentes → items=[].
IT-09: Periodo invalido → 400.
IT-10: BD timeout → 503.

E2E-01: Supervisor ve list de agentes.
E2E-02: Drill a agente con
view_agent_detail.
E2E-03: Sin permiso → 403.

SEC-01: User sin view_agent_detail no
puede acceder.
SEC-02: Sin PII en response.
SEC-03: Cross-segmento bloqueado.

Mapeo CA → Tests:

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..03
   - List
   - IT-01..03
 * - CA-04..05
   - KPIs
   - UT-01..03
 * - CA-06
   - Detalle RBAC
   - IT-05, SEC-01
 * - CA-07
   - Cross-segmento
   - IT-06, SEC-03
 * - CA-08
   - Detalle audit
   - IT-07
 * - CA-09
   - Sin datos
   - IT-08
 * - CA-10..11
   - Robustez
   - IT-09, IT-10
 * - CA-12
   - Sin PII
   - SEC-02

Cobertura: 4 unit, 10 integration, 3 E2E,
3 security. 100% de los 12 CAs.
