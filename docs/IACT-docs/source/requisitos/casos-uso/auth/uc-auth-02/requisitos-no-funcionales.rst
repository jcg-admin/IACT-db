.. _uc-auth-02-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50**
   - ≤ 80 ms (request → 200 OK)
 * - **Latencia P99**
   - ≤ 250 ms
 * - **Throughput**
   - ≥ 100 logout/seg sostenido
 * - **Concurrencia**
   - Idempotente bajo concurrencia (FA-02
     garantiza)

UC_AUTH_02 es mas rapido que UC_AUTH_01 porque no
hay verificacion de password (bcrypt cost 12 es
el cuello de botella en login).

6.2 Seguridad
=============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Transporte**
   - HTTPS obligatorio (CNST-013)
 * - **Autenticacion**
   - Token JWT valido requerido (CNST-009)
 * - **Autorizacion**
   - Solo el dueno de la Session puede cerrarla
     (verificacion en PASO 5 — EX-03)
 * - **Blacklist**
   - Tokens invalidados quedan en blacklist hasta
     su ``expires_at`` original
 * - **Anti-replay**
   - FA-02 + AuditEvent LOGOUT_REPLAY permite
     correlacionar intentos sospechosos
 * - **Throttling**
   - Rate limit por IP (CNST-011) — mitiga DoS
     por inundacion de blacklist

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - Pasos 6-8 en transaccion ACID
 * - **Idempotencia**
   - Garantizada por FA-02 (Session ya CLOSED →
     200 OK)
 * - **Tolerancia a fallos**
   - EX-04 retry safe; EX-05/06 ROLLBACK
     completo

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025 — todo AuditEvent inmutable
 * - **PII**
   - CNST-026 — payload no contiene PII
     directa; solo IDs y user_agent
 * - **Retencion**
   - Per ADR de retencion analitica (no
     definido en este UC)

6.5 Usabilidad
==============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Visibilidad del control**
   - Boton "Cerrar sesion" accesible desde
     cualquier pagina autenticada
 * - **Confirmacion**
   - Modal opcional (politica de producto)
 * - **Feedback**
   - Mensaje "Sesion cerrada correctamente" en
     /login post-redirect
 * - **Doble click**
   - FA-02 evita errores confusos

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - Backend log estructurado (JSON) con
     correlation_id por request
 * - **Metricas**
   - Counter ``auth.logout.{success,failed,
     replay}``; histogram de latencia
 * - **Alertas**
   - EX-03 (user mismatch) genera alerta
     inmediata via UC_ALR_*

6.7 Compatibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Browsers**
   - Chrome ≥110, Firefox ≥110, Edge ≥110,
     Safari ≥16
 * - **Dispositivos**
   - Desktop + tablet (no mobile native)
 * - **Backend API**
   - DRF 3.14+, Django 4.2+
