.. _uc-acc-02-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50 (1-3 funciones)**
   - ≤ 150 ms (UPDATE masivo + audit)
 * - **Latencia P50 (10 funciones)**
   - ≤ 250 ms
 * - **Latencia P99**
   - ≤ 500 ms
 * - **Throughput**
   - ≥ 10 DELETE/seg sostenido
 * - **Costo last-holder check**
   - O(funciones × COUNT) — debe ser < 50 ms
     con indices apropiados

6.2 Seguridad
=============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **HTTPS**
   - obligatorio
 * - **Auth**
   - JWT (CNST-009)
 * - **RBAC**
   - funcion ``revoke_functions`` (P-15
     granular distinta de
     ``assign_functions``)
 * - **Anti-self-revoke (P-11)**
   - default activo. Defensa fundamental
     contra lockout (admin no puede revocar
     sus propias funciones criticas
     incluyendo ``revoke_functions``).
 * - **Last-holder protection**
   - opcional con
     ``BLOCK_LAST_HOLDER_REVOKE=true``;
     default warn-only.
 * - **Throttling**
   - 30 DELETE/min/invoker (CNST-011)
 * - **Tamano payload**
   - max 50 funciones por request

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - PASOS 12-15 atomicos. Cache invalidate
     post-COMMIT (P-29).
 * - **Idempotencia**
   - re-revocar funcion ya REVOKED es no-op.
     Permite retries seguros.
 * - **Recovery**
   - EX-07 retry safe.

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025
 * - **PII**
   - CNST-026 — payload sin email/full_name
 * - **revoke_reason obligatorio**
   - cada revocacion documentada con motivo
     (auditabilidad fuerte). Si vacio →
     EX-06.
 * - **Granularidad**
   - 1 AuditEvent FUNCTIONS_REVOKED por
     invocacion con
     ``function_ids_revoked`` y
     ``function_ids_skipped``,
     ``post_revoke_active_count``,
     ``warnings``.

6.5 Usabilidad
==============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Multi-select**
   - lista de funciones actuales del User con
     checkboxes. Visible solo con
     ``revoke_functions``.
 * - **Confirmacion robusta**
   - modal con resumen + texto
     destructivo. ``revoke_reason`` obligatorio.
 * - **Warnings visuales**
   - antes del submit, frontend puede
     consultar
     ``GET /api/users/{id}/functions/revoke-preview``
     para mostrar warnings potenciales (no
     parte de UC_ACC_02; opcional UX).
 * - **Resumen post-operacion**
   - lista de revoked + skipped + warnings.

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - JSON con correlation_id, invoker,
     target, function_ids, revoke_reason.
 * - **Metricas**
   - Counter
     ``access.revoke.{success, forbidden,
     not_found, self_revoke,
     last_holder_blocked, validation_error,
     rate_limited}``;
     histogram de funciones por request.
 * - **Alertas**
   - EX-02 (UNAUTHORIZED) → alerta media;
     EX-04 (auto-revoke) → alerta alta;
     EX-09 (last holder block) → alerta
     baja (informativo).

6.7 Cumplimiento
================

- BR-006 RBAC Flat NIST.
- BR-009 Bajas Logicas: NO DELETE fisico.
- BR-010 Auditoria Inmutable.
- CNST-009/013/025/026.

6.8 Compatibilidad
==================

- Browsers: Chrome ≥110, Firefox ≥110,
  Edge ≥110, Safari ≥16.
- API: DELETE con body JSON (RFC 7231 lo
  permite para semantica de bulk).
