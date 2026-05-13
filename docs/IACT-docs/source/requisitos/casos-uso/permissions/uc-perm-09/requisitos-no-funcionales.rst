.. _uc-perm-09-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Metrica
   - Target
   - Notas
 * - INSERT P50
   - ≤ 5 ms
   - dentro de tx caller
 * - INSERT P95
   - ≤ 25 ms
   - tail
 * - PII scan P50
   - ≤ 1 ms
   - regex compilados
 * - Throughput
   - ≥ 5000 events/s
   - por nodo
 * - Lag alerta
   - ≤ 30 s
   - DESDE COMMIT a alert
 * - Storage / dia
   - ≤ 50 GB
   - target conservativo

6.2 Inmutabilidad
=================

- Schema sin columnas nullable que se
  pudieran "rellenar despues".
- Constraint a nivel BD que prohibe UPDATE
  / DELETE (rule / trigger).
- Backups con encriptacion at-rest.
- Acceso a tabla audit limitado a roles
  RBAC especificos (view_audit_log).

6.3 Seguridad
=============

- Sin PII (CNST-026).
- Hash de identificadores sensibles
  (usernames en LOGIN_FAILED).
- Eventos firmados con HMAC opcional para
  cumplir con regulaciones (decision por
  ADR cuando aplique).

6.4 Confiabilidad
=================

- Disponibilidad ≥ 99.99% (caida ⇒
  bloquea TODAS las operaciones audit).
- Read replicas para consulta sin afectar
  write.
- Particiones por mes para mantener INSERT
  rapido.

6.5 Auditabilidad
=================

- Auto-trazabilidad: cambios al schema de
  AuditEvent generan UC_LOG (no auditan a
  si mismos para evitar recursion).

6.6 Cumplimiento
================

- Retencion: 365 dias online, archive 7
  anos (compliance).
- Right-to-be-forgotten: incompatible con
  inmutabilidad → AuditEvent con
  identificadores hasheados, no
  removibles. Documentar trade-off.

6.7 Mantenibilidad
==================

- Catalogo de event_types con docs.
- Schema versionado (migracion crea
  nueva version + tabla, no altera la
  historica).

6.8 Escalabilidad
=================

- Volumetria estimada: 10-100 M events/dia.
- Sharding por modulo si > 100 M/dia.
- Cold storage para > 90 dias.
