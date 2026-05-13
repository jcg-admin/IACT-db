.. _uc-perm-09-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Actor
   - Tipo
   - Rol
 * - **UC invocante**
   - Sistema
   - cualquier UC de UC_AUTH_*,
     UC_USR_*, UC_ACC_*, UC_PERM_05/06
 * - **AuthorizationGuard**
   - Sistema
   - emite UNAUTHORIZED en denials
 * - **AuditLog (servicio)**
   - Sistema
   - persiste el evento (este UC es
     su contrato)
 * - **AlertEngine**
   - Sistema
   - consume eventos de tipo crítico
     y dispara alertas (UC_ALR)

2.2 Precondiciones
==================

- BD audit table accesible.
- Schema AuditEvent valido.
- Operacion principal en transaccion
  abierta (P-09 obliga atomicidad).

2.3 Postcondiciones
===================

**Caso exito:**

- AuditEvent persistido.
- ``id`` retornado al caller.
- Hooks de alerta evaluados (sin bloquear).

**Caso fallo:**

- Excepcion ``AuditWriteFailed`` propagada.
- Caller hace ROLLBACK de la operacion
  principal (P-09 audit-or-abort).

2.4 Datos de entrada
====================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Campo
   - Notas
 * - ``event_type``
   - Obligatorio. Enum (1.3).
 * - ``actor_id``
   - Obligatorio salvo eventos
     anonimos (LOGIN_FAILED).
 * - ``target_type``
   - Obligatorio si aplica.
 * - ``target_id``
   - Obligatorio si target_type.
 * - ``payload``
   - JSON estructurado, **sin PII**.
 * - ``context``
   - request_id, ip, user_agent,
     module, trace_id.

2.5 Datos de salida
===================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Campo
   - Notas
 * - ``id``
   - UUID del evento creado
 * - ``persisted_at``
   - timestamp ACK de la BD
