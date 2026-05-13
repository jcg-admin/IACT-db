.. _uc-perm-09-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: AuditValidationError
===============================

event_type desconocido / payload no JSON /
size > 16 KB. Caller debe corregir y
reintentar. La operacion principal se
aborta (no procede sin audit valido).

5.2 EX-02: AuditPIIDetected
===========================

PIIScanner encuentra patron PII en payload.
Caller debe sanitizar — no se reintenta
automaticamente (CNST-026 requiere
intencion explicita).

5.3 EX-03: AuditWriteFailed (BD timeout)
========================================

INSERT falla por timeout / constraint /
disk full. Caller hace ROLLBACK
(P-09 audit-or-abort).

Status visible al usuario: 500.
event_type secundario emitido por
infraestructura: ``operacion FAILED`` con
contexto.

5.4 EX-04: AuditTableLockTimeout
================================

Lock timeout en la tabla audit. Mismo
manejo que EX-03. Tipicamente indica
contention extrema — alerta a operaciones.

5.5 EX-05: ConsistencyViolation
===============================

Tentativa de UPDATE / DELETE sobre
AuditEvent (CNST-025 prohibido). Bloqueado
a nivel BD via constraints o triggers.

5.6 EX-06: AlertEnginePushFailed
================================

Best-effort. NO afecta caller. Reintento
automatico, DLQ tras N reintentos.

5.7 Resumen
===========

.. list-table::
 :widths: 18 40 18 24
 :header-rows: 1

 * - ID
   - Condicion
   - Severidad
   - Manejo
 * - EX-01
   - Validation
   - critica
   - rollback
 * - EX-02
   - PII detectado
   - critica
   - rollback
 * - EX-03
   - BD timeout
   - critica
   - rollback
 * - EX-04
   - Lock timeout
   - critica
   - rollback
 * - EX-05
   - UPDATE/DELETE
   - bloqueo BD
   - constraint
 * - EX-06
   - Alert push fail
   - degradado
   - DLQ
