.. _uc-rpt-04-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- Unit: PayloadValidator, JobLimiter,
  FormatWriter strategies, Sanitizer.
- Integration: encolado + worker pickup +
  storage upload + mailbox.
- E2E: User encolar → recibir mailbox →
  descargar.
- Security: sin email externo, sin PII,
  permission re-check.
- Load: 1M rows, multiples jobs.

12.2 Tests unitarios
====================

UT-01: PayloadValidator OK valido.
UT-02: rechaza format desconocido.
UT-03: rechaza estimated_rows > 1M.
UT-04: JobLimiter count_active correcto.
UT-05: CSV writer batch chico → archivo
valido.
UT-06: XLSX writer.
UT-07: PDF writer con limite 5K filas.
UT-08: Sanitizer remueve campos PII.
UT-09: Streaming cursor en batches.

12.3 Tests de integracion
=========================

IT-01: queue → 202 + job en BD queued.
IT-02: worker pickup → status running.
IT-03: worker completes → done + file_url.
IT-04: re-check fail → PERMISSION_REVOKED.
IT-05: archivo > 200 MB → TOO_LARGE.
IT-06: storage caido → STORAGE_UNAVAILABLE
+ retry.
IT-07: > 5 jobs → 429.
IT-08: cancel queued → cancelled.
IT-09: cancel running → graceful tras
batch.
IT-10: cleanup 24h → expired.
IT-11: status check → progress_pct.

12.4 Tests E2E
==============

E2E-01: User pide CSV de last_30d → recibe
mailbox → descarga URL → archivo CSV
correcto.
E2E-02: User pide XLSX → similar.
E2E-03: PDF con datos limitados.
E2E-04: Filtros segmento aplicados.
E2E-05: Sin permiso 403.

12.5 Tests de seguridad
=======================

SEC-01: NO se llama a SMTP / email
externo (CNST-001) — code scan + integration
mock.
SEC-02: archivo no contiene PII.
SEC-03: URL firmado expira a 24h.
SEC-04: re-check al ejecutar (P-64).
SEC-05: Path traversal en filename_hint
no efectivo.

12.6 Tests de carga
===================

LOAD-01: job 1M rows → < 30 min.
LOAD-02: 50 jobs simultaneos → autoscaling.
LOAD-03: memory por worker estable
(streaming OK).

12.7 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Encolar
   - IT-01
 * - CA-02
   - Worker procesa
   - IT-02, IT-03
 * - CA-03..05
   - Formats
   - UT-05..07, E2E-01..03
 * - CA-06
   - Filtros
   - E2E-04
 * - CA-07
   - > 1M
   - UT-03
 * - CA-08
   - > 5 jobs
   - IT-07
 * - CA-09
   - Permiso revocado
   - IT-04, SEC-04
 * - CA-10
   - > 200 MB
   - IT-05
 * - CA-11
   - Storage caido
   - IT-06
 * - CA-12
   - URL TTL
   - SEC-03
 * - CA-13
   - Cleanup
   - IT-10
 * - CA-14
   - Mailbox
   - E2E-01
 * - CA-15
   - No email externo
   - SEC-01
 * - CA-16
   - Audit
   - integration assertion
 * - CA-17
   - Cancelar
   - IT-08, IT-09
 * - CA-18
   - Status check
   - IT-11
 * - CA-19
   - Sin permiso
   - E2E-05

12.8 Cobertura
==============

- 9 unit tests
- 11 integration tests
- 5 E2E tests
- 5 security tests
- 3 load tests
- 100% de los 19 CAs cubiertos
