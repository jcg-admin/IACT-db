.. _uc-usr-03-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50 (sin cierre Sessions)**
   - ≤ 120 ms — UPDATE simple + audit
 * - **Latencia P50 (con state → BLOCKED)**
   - ≤ 250 ms — incluye cerrar Sessions y
     blacklist de N tokens
 * - **Latencia P99**
   - ≤ 500 ms
 * - **Throughput**
   - ≥ 10 PATCH/seg sostenido
 * - **Concurrencia**
   - ``select_for_update`` sobre el User para
     evitar interleave con UC_AUTH_03
     (admin reset) y UC_USR_04 (eliminacion).
     Lock contention manejado con backoff
     hasta timeout.
 * - **Crecimiento payload**
   - PATCH parcial: solo campos modificados;
     payload tipico ≤ 1 KB.

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
   - ``modify_users`` (parte de AGR-006)
 * - **Defensa anti-self-state-change**
   - EX-04 hard (P-11). Defensa contra
     escalada de privilegios o lockout
     accidental del admin.
 * - **Defensa anti-email-takeover**
   - Cambio de email opcionalmente notificado
     al User dueno via InternalMessage para
     que detecte takeover si no fue iniciado
     por el.
 * - **Validacion de transiciones de state**
   - Tabla de transiciones permitidas
     enforced en PASO 6 (no es libre).
 * - **No-leak**
   - ``password_hash`` NO modificable via este
     UC; cambio de email NO expone hashes.
 * - **Throttling**
   - 60 PATCH/min/admin (CNST-011).

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - Pasos 8-10 (UPDATE User + cierre
     Sessions opcional + AuditEvent +
     InternalMessage opcional) en transaccion
     ACID unica.
 * - **Idempotencia**
   - PATCH es naturalmente idempotente: enviar
     el mismo payload dos veces produce el
     mismo estado final; sin embargo, AuditEvent
     se emite cada vez (cada invocacion
     registra una intencion).
 * - **Recovery**
   - EX-08 retry safe: el cliente puede
     reintentar el PATCH si recibe 503
     (operacion idempotente).
 * - **Lock contention**
   - select_for_update con timeout
     configurable para evitar bloqueos
     prolongados.

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025: AuditEvent inmutable
 * - **PII**
   - CNST-026: payload sin email, full_name —
     solo IDs, lista de campos modificados,
     transicion de state si aplica.
 * - **Granularidad**
   - 1 AuditEvent USER_MODIFIED por PATCH
     exitoso. ``payload.fields_changed``
     identifica que cambio.
 * - **Trazabilidad**
   - Correlable con UC_USR_02 (vista detalle
     antes del cambio) por ``actor_user_id`` y
     ventana temporal.

6.5 Usabilidad
==============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Form prefilled**
   - Frontend carga datos actuales del User
     antes de permitir edicion (sin GET
     adicional el admin no podria editar
     sin perder informacion).
 * - **Validacion incremental**
   - Cambios visibles en tiempo real;
     errores especificos por campo.
 * - **Confirmacion para state changes**
   - Modal de confirmacion obligatorio cuando
     ``state`` cambia (operacion con
     side-effects: cierre de Sessions).
 * - **Indicador de cambios pendientes**
   - UI muestra "tienes cambios sin guardar"
     si admin navega fuera del form.
 * - **Feedback post-cambio**
   - Toast con resumen "X campos actualizados"
     listando campos modificados.

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - JSON estructurado con correlation_id por
     request, ``actor_user_id`` y
     ``target_user_id``.
 * - **Metricas**
   - Counter
     ``users.modify.{success,
     state_changed_to_blocked,
     state_changed_to_active,
     email_changed,
     forbidden, validation_error,
     rate_limited}``;
     histogram de latencia P50/P99.
 * - **Alertas**
   - EX-04 (auto-state) → alerta media; >5
     cambios a BLOCKED en 5 min → alerta
     incidente (posible accion masiva
     erronea).

6.7 Cumplimiento
================

- CNST-008: cambio de segmento mantiene
  consistencia de visibilidad de datos.
- CNST-009: autenticacion DRF.
- CNST-013: manejo estandarizado de
  excepciones con mapping a status HTTP.
- CNST-025: AuditEvent inmutable obligatorio.
- CNST-026: payload sin PII directa.

6.8 Compatibilidad
==================

- Browsers: Chrome ≥110, Firefox ≥110,
  Edge ≥110, Safari ≥16.
- API: PATCH semantica RFC 5789 (parcial).
