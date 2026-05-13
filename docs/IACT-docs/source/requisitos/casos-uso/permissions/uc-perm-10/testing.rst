.. _uc-perm-10-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- **Unit**: filter validator, cursor
  encoder/decoder, sanitizer.
- **Integration**: query con datos
  realistas, paginacion estable, scope
  por segmento.
- **E2E**: auditor consulta, exporta,
  recibe mailbox.
- **Compliance**: meta-audit
  obligatorio.

12.2 Tests unitarios
====================

UT-01: validator OK con date range valido.
UT-02: validator rechaza date range
invertido.
UT-03: validator rechaza > 90 dias sin
archive.
UT-04: validator rechaza page_size > 200.
UT-05: cursor encoder ↔ decoder roundtrip.
UT-06: cursor con filters_hash distinto
rechazado.
UT-07: cursor expirado (> 24h) rechazado.
UT-08: sanitizer trunca payload a 500 char.
UT-09: sanitizer no destruye campos
estructurados (event_type, actor_id).

12.3 Tests de integracion
=========================

IT-01: list basico con 100 events → 50 +
cursor.
IT-02: paginacion completa (4 paginas) →
sin duplicados.
IT-03: insert concurrente durante paginacion
→ sin perdida.
IT-04: filtros exactos (actor_id) →
solo events de ese actor.
IT-05: filtro event_type lista → solo
events de esos tipos.
IT-06: range > 90 dias rechazado.
IT-07: detalle online success.
IT-08: detalle archive success (latencia
mayor pero ok).
IT-09: detalle no existe → 404.
IT-10: aggregate group_by event_type.
IT-11: aggregate excede limite → 400.
IT-12: export queued, ExportWorker procesa,
file generado, mailbox notifica.
IT-13: scope segmento aplicado: User con
scope MOD_X solo ve events de MOD_X.

12.4 Tests E2E
==============

E2E-01: Auditor login → list audit events
→ filter por incident → exporta CSV →
recibe mailbox → descarga.
E2E-02: User sin permiso → 403 +
UNAUTHORIZED audit emitido.
E2E-03: Audit fail simulado →
AuditUnavailable; datos NO retornados.
E2E-04: Multi-pagina con writes
concurrentes → consistencia.

12.5 Tests de compliance
========================

C-01: cada call exitoso a list emite
AUDIT_LOG_QUERIED.
C-02: cada call a detalle emite
AUDIT_LOG_DETAIL_VIEWED.
C-03: cada export emite
AUDIT_LOG_EXPORT_QUEUED inicialmente y
COMPLETED al final.
C-04: filtros usados en consulta visibles
en payload del meta-audit (no PII).

12.6 Tests de carga
===================

LOAD-01: list con 10M rows en BD →
P95 ≤ 500 ms.
LOAD-02: 100 auditores concurrentes →
no degradacion read replica.
LOAD-03: export 1M rows → < 30 min.

12.7 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - List + cursor
   - IT-01, IT-02, IT-03, UT-05..07
 * - CA-05..07
   - Filtros
   - IT-04, IT-05
 * - CA-08
   - Range > 90
   - IT-06, UT-03
 * - CA-09..11
   - Detalle
   - IT-07, IT-08, IT-09
 * - CA-12..13
   - Aggregate
   - IT-10, IT-11
 * - CA-14..15
   - Export
   - IT-12, E2E-01
 * - CA-16
   - Sin permiso
   - E2E-02
 * - CA-17..18
   - Meta-audit
   - C-01..04, E2E-03
 * - CA-19
   - Sin PII
   - UT-08, C-04

12.8 Cobertura
==============

- 9 unit tests
- 13 integration tests
- 4 E2E tests
- 4 compliance tests
- 3 load tests
- 100% de los 19 CAs cubiertos
