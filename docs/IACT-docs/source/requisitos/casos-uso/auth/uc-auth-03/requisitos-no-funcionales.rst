.. _uc-auth-03-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50**
   - ≤ 250 ms (bcrypt cost 12 ~150 ms)
 * - **Latencia P99**
   - ≤ 500 ms
 * - **Throughput**
   - ≥ 5 reset/seg sostenido (operacion poco
     frecuente)
 * - **Concurrencia**
   - Lock pesimista en User; concurrencia con
     UC_USR_03 maneja via SELECT FOR UPDATE

6.2 Seguridad
=============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Transporte**
   - HTTPS obligatorio
 * - **Autenticacion**
   - JWT del admin (CNST-009)
 * - **Autorizacion**
   - Funcion ``reset_password`` (via AGR-006)
 * - **Generacion de password**
   - ``secrets.SystemRandom``; entropia minima
     72 bits; charset mixto
 * - **Hashing**
   - bcrypt cost 12 (resistencia 2^12 rounds)
 * - **No-leak**
   - La contrasena temporal NO aparece en:
     logs, response, UI del admin, AuditEvent
     payload, error stacktraces
 * - **Canal de entrega**
   - SOLO InternalMailbox (CNST-001 + CNST-002)
 * - **Anti-self-reset**
   - EX-04 hard
 * - **Throttling**
   - 10 reset/5min/admin (CNST-011)

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - Pasos 10-13 en transaccion ACID
 * - **Tolerancia a fallos**
   - EX-06/07/09 → ROLLBACK completo
 * - **Idempotencia**
   - NO idempotente — cada invocacion genera
     una nueva contrasena. Reintentos producen
     N InternalMessages con N contrasenas
     distintas. El admin debe ser cuidadoso.

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025 — AuditEvent inmutable
 * - **PII**
   - CNST-026 — payload sin email/nombre
     completo; solo IDs e IP
 * - **Granularidad**
   - admin_user_id, target_user_id, ip,
     user_agent, sessions_closed_count
 * - **Trazabilidad**
   - cada PASSWORD_RESET correlacionable con el
     proximo LOGIN del User afectado (que
     disparara FA-01 first_login)

6.5 Usabilidad (admin)
======================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Visibilidad del control**
   - Solo visible si admin tiene AGR-006
 * - **Confirmacion**
   - Modal robusto OBLIGATORIO (no
     opcional como en UC_AUTH_02). La accion
     es destructiva.
 * - **Feedback**
   - Mensaje claro al admin SIN mostrar la
     contrasena
 * - **Reversibilidad**
   - NO reversible — el password anterior se
     pierde. El admin debe estar seguro.

6.6 Usabilidad (User afectado)
==============================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Notificacion**
   - InternalMessage en buzon, visible al
     proximo login (UI badge)
 * - **Claridad**
   - Mensaje incluye: "Tu contrasena fue
     reseteada por un administrador. Contrasena
     temporal: ABC123!@#. Cambiala en tu
     proximo inicio de sesion."
 * - **Forzar UC_AUTH_04**
   - Garantizado por
     User.first_login=true → FA-01

6.7 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - JSON con correlation_id; NUNCA log de la
     contrasena temporal
 * - **Metricas**
   - Counter ``auth.password_reset.{success,
     failed,unauthorized}``
 * - **Alertas**
   - EX-02 (UNAUTHORIZED) genera alerta
     inmediata; EX-04 (self-reset) alerta
     media; > 10 resets/admin/dia alerta baja

6.8 Cumplimiento
================

- CNST-001: prohibicion de email/SMTP/canal
  externo verificada por test de integracion
  (no debe haber llamadas a librerias de
  email).
- CNST-002: InternalMessage obligatorio
  verificado por integration test.
- CNST-025: AuditEvent obligatorio.
