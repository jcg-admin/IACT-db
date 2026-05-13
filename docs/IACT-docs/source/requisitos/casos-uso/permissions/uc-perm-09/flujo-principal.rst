.. _uc-perm-09-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Pasos
=========

**PASO 1 — Invocacion del caller**

UC invocante (e.g. UC_ACC_01) llama al
servicio con event_type, actor, target,
payload, context.

**PASO 2 — Validacion estructural**

- ``event_type`` ∈ enum conocido.
- ``payload`` es JSON serializable.
- Tamano payload ≤ 16 KB.
- ``module`` ∈ MOD_*.

Si falla → ``AuditValidationError`` (caller
debe hacer ROLLBACK).

**PASO 3 — PII scan (CNST-026)**

Heuristica de PII en payload:

- emails detectables → ERROR
- numeros de identidad → ERROR
- passwords / tokens → ERROR
- telefonos → ERROR

Si detecta → ``AuditPIIDetected``. Bloquear
emision (no es decoracion: es enforcement).

**PASO 4 — Sanitizar y normalizar**

- Convertir nombres / emails a hashes
  (cuando son obligatorios para
  trazabilidad).
- Normalizar timestamps a UTC.
- Asegurar request_id presente.

**PASO 5 — Construir AuditEvent**

::

   event = {
     id: uuid_v7(),
     event_type, actor_id,
     target_type, target_id,
     payload: sanitized,
     ip_address, user_agent,
     request_id, module,
     created_at: now_utc()
   }

**PASO 6 — INSERT en transaccion del caller**

Critico (P-09): el INSERT ocurre en la
**misma transaccion** que la operacion
principal. Si la BD lo rechaza, ambos hacen
rollback.

::

   AuditRepo.insert(event)
   # Sin INSERT separado.

**PASO 7 — Push a alert engine (best-effort,
post-COMMIT)**

Tras COMMIT del caller, se notifica al
AlertEngine (UC_ALR) async:

::

   on_commit:
     AlertEngine.consume(event)

Best-effort: si falla, NO afecta la
operacion. Hay reintento con backoff y dead
letter queue.

**PASO 8 — Retornar id al caller**

Caller puede incluir ``audit_event_id`` en
response al usuario para trazabilidad.

3.2 Sub-flujo: emit batch
=========================

Para acciones con N AuditEvents
(e.g. UC_ACC_05 bulk):

**PASO B1** — validar todos los eventos.
**PASO B2** — INSERT batch (multi-row) en
una sola operacion.
**PASO B3** — push batch al alert engine.
**PASO B4** — retornar list[id].

3.3 Resumen
===========

.. list-table::
 :widths: 8 50 22 20
 :header-rows: 1

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1
   - Invocacion
   - Caller UC
   - —
 * - 2
   - Validacion estructural
   - AuditValidator
   - —
 * - 3
   - PII scan
   - PIIScanner
   - 026
 * - 4
   - Sanitizar
   - Sanitizer
   - 026
 * - 5
   - Construir event
   - EventFactory
   - 025
 * - 6
   - INSERT en tx caller
   - AuditRepo
   - 025
 * - 7
   - Push alert post-COMMIT
   - AlertHook
   - —
 * - 8
   - Retornar id
   - Service
   - —
