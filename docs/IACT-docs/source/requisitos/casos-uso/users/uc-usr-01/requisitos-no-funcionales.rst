.. _uc-usr-01-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50**
   - ≤ 250 ms (bcrypt cost 12 ~150 ms domina)
 * - **Latencia P99**
   - ≤ 500 ms
 * - **Throughput**
   - ≥ 5 creaciones/seg
 * - **Concurrencia**
   - retries de username (FA-02) ≤ 5

6.2 Seguridad
=============

- HTTPS obligatorio.
- JWT (CNST-009).
- Funcion ``create_users`` (via AGR-006).
- Generacion password con
  ``secrets.SystemRandom`` (entropia ≥ 72 bits).
- bcrypt cost 12.
- No-leak: contrasena temporal NUNCA en logs,
  response, AuditEvent payload, UI del admin.
- Solo InternalMailbox para credenciales
  (CNST-001 + CNST-002).
- Throttling 60/min/admin (CNST-011).

6.3 Confiabilidad
=================

- Atomicidad pasos 10-13 en transaccion ACID.
- ROLLBACK completo en EX-05/06/07.
- NO idempotente (cada invocacion crea User
  distinto).

6.4 Auditabilidad
=================

- Append-only AuditEvent (CNST-025).
- Sin PII en payload (CNST-026): solo IDs.
- 1 USER_CREATED por exito; 1
  USER_CREATE_FAILED por fallo (con reason).

6.5 Usabilidad
==============

- Form simple (3 campos obligatorios + 1
  opcional).
- Username generado mostrado al admin
  post-creacion.
- Mensaje de exito SIN exponer la contrasena.
- Errores especificos por tipo (EX-02 vs EX-03
  vs EX-09).

6.6 Mantenibilidad
==================

- Logging estructurado (JSON) sin contrasena.
- Counter
  ``users.create.{success,duplicated_email,
  forbidden,validation_error}``.
- Alerta EX-01 (UNAUTHORIZED) escalada media.

6.7 Cumplimiento
================

- CNST-001: 0 envios externos verificable por
  test (mock de email/SMS rechaza llamadas).
- CNST-002: 1 InternalMessage obligatorio.
- CNST-025: AuditEvent obligatorio.
- CNST-026: payload sin email/full_name del
  nuevo user.
- CNST-029: username autogenerado, no editable.
