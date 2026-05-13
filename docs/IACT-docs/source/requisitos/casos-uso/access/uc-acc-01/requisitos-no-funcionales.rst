.. _uc-acc-01-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50 (1-3 funciones)**
   - ≤ 200 ms (validacion + SoD + INSERT N)
 * - **Latencia P50 (10 funciones)**
   - ≤ 350 ms
 * - **Latencia P99**
   - ≤ 700 ms
 * - **Throughput**
   - ≥ 5 POST/seg sostenido
 * - **Costo SoD validation**
   - O(rules × funciones del User) — debe ser
     < 100 ms con 50 SoDRules y 20 funciones
     activas/User. Indices recomendados.

6.2 Seguridad
=============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Transporte**
   - HTTPS obligatorio
 * - **Autenticacion**
   - JWT (CNST-009)
 * - **Autorizacion**
   - funcion ``assign_functions`` (atomica;
     P-15 RBAC granular distinta de
     ``revoke_functions`` y de
     ``configure_sod``)
 * - **Anti-self-assignment (P-11)**
   - opcional configurable. Default: bloquea
     auto-asignacion para defender contra
     escalada en cascada.
 * - **SoD enforcement (CNST-005, BR-007)**
   - en tiempo de asignacion. NO se permite
     asignacion parcial — all-or-nothing.
 * - **Atomicidad ante violacion**
   - rollback total. Auditoria registra el
     intento bloqueado.
 * - **Throttling**
   - 30 POST/min/invoker (CNST-011)
 * - **Tamano payload**
   - max 50 funciones por request.

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - PASOS 11-13 (INSERT N + AuditEvent +
     opcional InternalMessage) en transaccion
     ACID. Cache invalidation post-COMMIT.
 * - **Idempotencia parcial (FA-01, FA-03)**
   - re-asignacion de funcion ya activa es
     no-op.
 * - **Recovery**
   - EX-09 retry safe (operacion idempotente
     parcial).

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025
 * - **PII**
   - CNST-026 — payload sin email/full_name;
     solo IDs y codigos de funciones.
 * - **Granularidad**
   - 1 AuditEvent FUNCTIONS_ASSIGNED por
     invocacion, con
     ``function_ids_assigned`` (las nuevas) y
     ``function_ids_skipped`` (las que ya
     estaban — idempotencia trazable).
 * - **Trazabilidad de violaciones**
   - EX-08 (SoD) genera audit con
     ``rule_id`` y ``conflict_pair`` —
     correlacionable con UC_ACC_05
     (configuracion de la regla).

6.5 Usabilidad
==============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Multi-select de funciones**
   - UI con search + categoria. Visible solo
     con ``assign_functions``.
 * - **SoD preview (recomendado)**
   - antes de submit, frontend puede
     ``GET /api/users/{id}/functions/sod-preview``
     para mostrar violaciones potenciales.
     (Endpoint no es parte de UC_ACC_01;
     opcional UX.)
 * - **Confirmacion robusta**
   - modal con resumen de funciones a
     asignar y expires_at si aplica.
 * - **Feedback claro en SoD**
   - cuando bloquea (EX-08), mostrar la regla
     SoD violada con su nombre legible y el
     par conflictivo, sugiriendo revocar
     primero la otra funcion (UC_ACC_02).
 * - **Resumen post-operacion**
   - lista de asignadas + omitidas.

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - JSON con correlation_id, invoker_id,
     target_user_id, function_ids,
     sod_outcome.
 * - **Metricas**
   - Counter
     ``access.assign.{success,
     sod_violation, forbidden, not_found,
     invalid_state, validation_error,
     rate_limited}``;
     histogram de latencia P50/P99;
     histogram de cantidad de funciones por
     request.
 * - **Alertas**
   - EX-02 (UNAUTHORIZED) → alerta media;
     EX-05 (auto-assign) → alerta alta;
     EX-08 (SoD) > 5/dia mismo invoker →
     alerta investigacion;
     asignacion de funcion altamente
     privilegiada (configure_sod, etc.) →
     alerta media.

6.7 Cumplimiento
================

- BR-006 RBAC Flat NIST: funciones atomicas,
  no jerarquicas.
- BR-007 SoD: enforcement obligatorio.
- BR-008 Permisos con Vencimiento: opcional
  via ``expires_at``.
- BR-010 Auditoria Inmutable: AuditEvent
  obligatorio.
- CNST-005 enforcement SoD en tiempo de
  asignacion.
- CNST-009/013/025/026.

6.8 Compatibilidad
==================

- Browsers: Chrome ≥110, Firefox ≥110,
  Edge ≥110, Safari ≥16.
- API: REST estandar (POST con body JSON).
