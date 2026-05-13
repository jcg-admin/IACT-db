.. _uc-auth-04-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Latencia P50**
   - ≤ 350 ms (2x bcrypt cost 12: validar actual
     + hash nueva, ~150 ms cada uno + I/O)
 * - **Latencia P99**
   - ≤ 700 ms
 * - **Throughput**
   - ≥ 10 req/seg
 * - **Concurrencia**
   - select_for_update sobre el User para
     evitar interleave con UC_AUTH_03

6.2 Seguridad
=============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Transporte**
   - HTTPS obligatorio
 * - **Autenticacion**
   - JWT
 * - **Anti-bruteforce**
   - EX-08 lockout 5min tras 5 fallos
     consecutivos; delay aleatorio en EX-02
 * - **Hashing**
   - bcrypt cost 12
 * - **No-reuso**
   - history N=5 obligatorio (BR-AUTH-32)
 * - **Politica de complejidad**
   - longitud ≥ 12, charset mixto, no
     diccionario top-1000, no similitud con
     username/email
 * - **No-leak**
   - la contrasena (actual o nueva) NUNCA
     aparece en logs, response, AuditEvent
     payload, o stacktrace
 * - **Constant-time check**
   - bcrypt.checkpw es constant-time por
     diseno; el delay defensivo aleatorio
     adiciona resistencia a timing
 * - **CSRF**
   - DRF con SessionAuthentication: CSRF
     token; con JWT-only: opt-out documentado

6.3 Confiabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Atomicidad**
   - Pasos 10-13 en transaccion ACID
 * - **Idempotencia**
   - NO — invocar dos veces seguidas con la
     misma "nueva" debiera fallar la segunda
     vez por EX-04 (ahora la "nueva" es la
     actual + esta en history)
 * - **Recuperacion**
   - EX-07 retry safe

6.4 Auditabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Append-only**
   - CNST-025
 * - **PII**
   - CNST-026 — solo IDs, IP, user_agent;
     NUNCA passwords (ni hashes en payload —
     los hashes viven en User y
     PasswordHistory)
 * - **Granularidad**
   - actor_user_id (= user que cambio),
     prior_first_login,
     other_sessions_closed_count, scope_upgrade

6.5 Usabilidad
==============

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Indicador de fuerza**
   - Frontend muestra barra de fuerza
     orientativa (entropia client-side); la
     decision final es del backend
 * - **Mensajes de error**
   - claros pero no exhaustivos. EX-03 lista
     violaciones especificas; EX-04 dice
     "reuso" sin numerar
 * - **Re-prompt**
   - tras EX-02/03/04, el form preserva los
     campos "nueva/confirmar" pero limpia
     "actual"
 * - **Flujo forzado**
   - Cuando viene de FA-01 UC_AUTH_01, no
     ofrece "Cancelar" (no hay otra parte de
     la UI accesible con scope reducido)

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Logging**
   - JSON estructurado; filtros que redactan
     "current_password", "new_password" y
     "new_password_confirmation"
 * - **Metricas**
   - Counter
     ``auth.password_change.{success,
     wrong_current,policy,reused,same,
     db_error,bruteforce}``
 * - **Alertas**
   - EX-08 (bruteforce) genera alerta media

6.7 Cumplimiento
================

- CNST-003 sesiones persistidas: PASO 12 hace
  UPDATE en BD (no solo invalidacion en cache)
- CNST-009 autenticacion DRF
- CNST-013 manejo estandarizado de excepciones
- CNST-025 auditoria inmutable
- CNST-026 sin PII en payload
