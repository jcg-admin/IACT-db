.. _uc-perm-09-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- **Unit**: validator, PII scanner,
  sanitizer, event factory.
- **Integration**: emit en tx con
  rollback test, batch atomico,
  inmutabilidad.
- **Security**: PII detection coverage,
  enforcement BD-level.
- **E2E**: caller UC + audit chain
  completa.

12.2 Tests unitarios
====================

UT-01: validator OK con event_type valido.
UT-02: validator rechaza event_type
desconocido.
UT-03: validator rechaza payload > 16 KB.
UT-04: validator rechaza payload no JSON.
UT-05: PII scanner detecta email plano.
UT-06: PII scanner detecta numero
identidad.
UT-07: PII scanner detecta password.
UT-08: PII scanner pass payload sanitizado.
UT-09: Sanitizer hashea username.
UT-10: Sanitizer normaliza tz a UTC.
UT-11: EventFactory genera UUID v7
ordenable.
UT-12: EventFactory completa request_id si
falta (sintetico).

12.3 Tests de integracion
=========================

IT-01: emit basico → INSERT verificable.
IT-02: emit con tx caller; rollback caller →
audit row tampoco persiste.
IT-03: UPDATE sobre AuditEvent rechazado por
constraint.
IT-04: DELETE sobre AuditEvent rechazado.
IT-05: emit_batch atomico — 1 row inválida
→ rollback batch.
IT-06: emit con event_type CRITICAL
replicado a log secundario.
IT-07: BD timeout en INSERT → AuditWriteFailed.
IT-08: AlertHook no llamado antes de COMMIT.
IT-09: AlertHook llamado post-COMMIT.
IT-10: AlertEngine fail → DLQ; caller no
afectado.
IT-11: Particionamiento — events de mes M
en particion correcta.

12.4 Tests de seguridad
=======================

SEC-01: Scan corpus de payloads reales del
sistema → 0 PII en audit_event tabla.
SEC-02: Verificar grants BD: rol audit_writer
solo INSERT, no UPDATE/DELETE.
SEC-03: Tentar UPDATE con SQL directo
desde rol owner → rechazado.

12.5 Tests E2E
==============

E2E-01: UC_ACC_01 asigna AGR → AuditEvent
AGR_ASSIGNED visible en UC_PERM_10 query.
E2E-02: UC_AUTH_01 fallido → LOGIN_FAILED con
username_hash.
E2E-03: UC_PERM_05 retire AGR → COMPOSITION
events en cadena (FAILED si SoD bloquea, OK
si exito).
E2E-04: AlertEngine recibe evento crítico
en < 30s.

12.6 Tests de carga
===================

LOAD-01: 5000 emit/s sostenidos por 5 min →
P95 ≤ 25ms, sin fallas.
LOAD-02: emit_batch de 100 events × 100 req/s
→ throughput equivalente.

12.7 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Emit basico
   - IT-01
 * - CA-02
   - Inmutabilidad
   - IT-03, IT-04, SEC-02, SEC-03
 * - CA-03
   - event_type desconocido
   - UT-02
 * - CA-04
   - payload > 16 KB
   - UT-03
 * - CA-05
   - PII bloqueado
   - UT-05..07, SEC-01
 * - CA-06
   - hash de username
   - UT-09, E2E-02
 * - CA-07
   - INSERT en tx
   - IT-02
 * - CA-08
   - rollback en BD timeout
   - IT-07
 * - CA-09
   - alert post-COMMIT
   - IT-08, IT-09
 * - CA-10
   - alert engine fail
   - IT-10
 * - CA-11
   - batch atomico
   - IT-05
 * - CA-12
   - CRITICAL replica
   - IT-06
 * - CA-13
   - UNAUTHORIZED
   - E2E (denial path)
 * - CA-14
   - request_id correlacion
   - UT-12 + log assert
 * - CA-15
   - UTC
   - UT-10

12.8 Cobertura
==============

- 12 unit tests
- 11 integration tests
- 3 security tests
- 4 E2E tests
- 2 load tests
- 100% de los 15 CAs cubiertos
