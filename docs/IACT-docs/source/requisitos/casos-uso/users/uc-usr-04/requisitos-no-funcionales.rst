.. _uc-usr-04-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50**
   - ≤ 300 ms (UPDATE User + UPDATE masivo
     Sessions + UPDATE masivo Assignments +
     INSERT BlacklistedToken N + AuditEvent)
 * - **Latencia P99**
   - ≤ 700 ms
 * - **Throughput**
   - ≥ 5 DELETE/seg
 * - **Concurrencia**
   - ``select_for_update`` sobre el target User
     evita interleave con UC_USR_03 / UC_AUTH_03
     / UC_AUTH_05.
 * - **Volumen tipico**
   - User tipico tiene 1-3 Sessions activas y
     1-5 Assignments. Pico operacional cuando
     se elimina admin con muchos Assignments
     custom: hasta ~20 Assignments revocadas.

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
   - funcion ``deactivate_users`` (P-15
     granularidad — distinta de
     ``modify_users`` y ``create_users``)
 * - **Defensa anti-self-elimination**
   - EX-04 hard (P-11). Defensa contra
     escalada o lockout accidental.
 * - **Defensa anti-doble-eliminacion-replay**
   - FA-02 idempotente con AuditEvent
     ``USER_ELIMINATE_NOOP`` para detectar
     replays sospechosos. Politica strict
     opcional.
 * - **Modal robusto + doble confirmacion**
   - en frontend para evitar clicks
     accidentales (input "ELIMINAR" literal).
 * - **Throttling**
   - 30 DELETE/min/admin (CNST-011) — limite
     mas estricto que UC_USR_03 dado que la
     accion es destructiva e irreversible.

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - PASOS 9-14 en transaccion ACID. Si
     cualquier paso falla, ROLLBACK completo
     — el User permanece intacto.
 * - **Idempotencia**
   - default idempotente (FA-02). Strict
     opcional.
 * - **Recovery**
   - EX-06 retry safe; el cliente puede
     reintentar el DELETE si recibe 503.

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025 — AuditEvent inmutable.
 * - **PII**
   - CNST-026 — payload sin email/full_name;
     solo IDs, contadores y prior_state.
 * - **Granularidad**
   - 1 AuditEvent USER_ELIMINATED por
     eliminacion exitosa con
     ``sessions_closed_count``,
     ``assignments_revoked_count``,
     ``prior_state``, ``mailbox_failed`` (si
     aplica).
 * - **Trazabilidad correlacionable**
   - ``user.eliminated_by_admin_id`` en BD
     permite reverse lookup desde User
     ELIMINATED al admin que lo elimino, sin
     consultar AuditEvent.
 * - **Retencion**
   - registros del User preservados (BR-009 +
     CNST-006 2 anios).

6.5 Usabilidad
==============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Visibilidad del control**
   - Boton "Eliminar" rojo, visible solo si el
     invocante tiene la funcion
     ``deactivate_users``.
 * - **Confirmacion robusta obligatoria**
   - Modal con texto explicativo + input que
     requiere escribir "ELIMINAR" literal.
     NO es suficiente un click.
 * - **Mensaje claro**
   - "Esta accion no se puede deshacer" en el
     modal.
 * - **Feedback post-operacion**
   - Toast con resumen: "Usuario {username}
     eliminado. {N} sesiones cerradas, {M}
     permisos revocados."
 * - **Indicador de ELIMINATED en lista**
   - badge visual rojo "ELIMINATED" si la
     lista incluye usuarios eliminados (filter
     opcional).

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - JSON estructurado con correlation_id,
     ``actor_user_id``, ``target_user_id``,
     ``operation='user_elimination'``.
 * - **Metricas**
   - Counter
     ``users.eliminate.{success, forbidden,
     not_found, self_elimination,
     already_eliminated, db_timeout,
     audit_failed, rate_limited}``;
     histogram de latencia + histograma de
     ``sessions_closed_count`` y
     ``assignments_revoked_count``.
 * - **Alertas**
   - EX-04 (auto-eliminacion) → alerta alta;
     >5 eliminaciones en 5min/admin → alerta
     incidente; eliminacion de cuenta con
     cualquier funcion administrativa →
     alerta media (escalada de seguridad).

6.7 Cumplimiento
================

- BR-009 (Bajas Logicas): NO DELETE fisico,
  solo UPDATE state.
- CNST-006: retencion 2 anios automatica.
- CNST-009: autenticacion DRF.
- CNST-013: manejo estandar de excepciones.
- CNST-025: AuditEvent inmutable.
- CNST-026: payload sin PII.

6.8 Compatibilidad
==================

- Browsers: Chrome ≥110, Firefox ≥110,
  Edge ≥110, Safari ≥16.
- API: DELETE semantica RFC 7231 (con baja
  logica internamente, no DELETE fisico).
