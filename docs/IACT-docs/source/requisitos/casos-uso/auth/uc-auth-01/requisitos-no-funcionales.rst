.. _uc-auth-01-parte-06:

==========================================
Parte 6 — Requisitos no funcionales (RNF)
==========================================

Cifras concretas (numeros, umbrales, periodos)
viven en los CNST canonicos y en futuros ADRs
de implementacion. Esta parte documenta los
**ejes** que el UC debe satisfacer, citando los
constraints que los gobiernan.

6.1 Performance
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Latencia objetivo**
   - Respuesta del endpoint ``/api/auth/login/``
     dentro del SLA declarado en CNST-017 SLA
     de tiempos de respuesta.
 * - **Componentes que dominan la latencia**
   - 1) ``bcrypt.check_password()`` (paso 9) —
     intencionalmente lento por seguridad,
     domina el coste.
     2) Query ``Session.objects.filter(user_id,
     state='ACTIVE').update(...)`` (paso 10) —
     debe estar indexada.
     3) Insercion del ``AuditEvent`` (paso 13).
 * - **Caching aplicable**
   - Cache LRU del par
     ``(user_id, function_id) → bool`` para
     UC_PERM_07; **no aplica al UC_AUTH_01 en
     si** porque cada login crea Session nueva.
 * - **Throughput esperado**
   - El endpoint debe soportar la concurrencia
     de logins simultaneos del horario pico del
     call center. La cifra objetivo se define
     en el ADR de capacity planning.
 * - **Monitoreo**
   - Las metricas tecnicas (latencia, error
     rate, throughput) son consumidas por
     UC_LOG_07 ``view_technical_metrics``.

6.2 Seguridad
=============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **HTTPS obligatorio**
   - El endpoint NO acepta HTTP plano. El
     middleware redirige o rechaza requests no
     cifrados (ADR-DEVOPS-001).
 * - **TLS minimo**
   - TLS 1.2+ (no SSL v3 ni TLS 1.0/1.1).
 * - **Storage de password**
   - bcrypt con coste configurado segun ADR de
     implementacion. **Nunca** plaintext en BD,
     logs o respuesta.
 * - **Comparacion de password**
   - Constant-time (``bcrypt.checkpw()``) para
     prevenir timing attacks.
 * - **Throttling**
   - CNST-011 — los limites concretos viven en
     el CNST mismo y en el ADR.
 * - **Anti-enumeracion de usernames**
   - EX-01 y EX-02 retornan el mismo
     ``error_code = INVALID_CREDENTIALS``. Esto
     evita que un atacante distinga "usuario
     existe pero password mala" de "usuario no
     existe". Trade-off aceptado en EX-03 /
     EX-04 por usabilidad (DEC-A11).
 * - **Sesion unica**
   - CNST-004 reduce el riesgo de sesiones
     simultaneas robadas.
 * - **Timeout de sesion**
   - CNST-005 acota la ventana de oportunidad
     de un token comprometido.
 * - **Auditoria inmutable**
   - CNST-025 garantiza que el evento ``LOGIN``
     no puede ser borrado o alterado para
     ocultar accesos no autorizados.
 * - **PII en logs**
   - CNST-026 prohibe password, tokens o datos
     personales sensibles en logs y AuditEvent.
     El payload del AuditEvent ``LOGIN`` solo
     contiene IP, user_agent, session_id —
     nunca password ni tokens.
 * - **Validacion de input**
   - CNST-012 — toda entrada del cliente pasa
     por DRF Serializer antes de llegar a la
     logica del UC.

6.3 Confiabilidad
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Atomicidad**
   - Los pasos 10-14 son una transaccion
     atomica en BD. ROLLBACK si cualquier paso
     falla; no hay estados intermedios visibles.
 * - **Idempotencia**
   - El UC NO es idempotente — un login exitoso
     produce una Session nueva cada vez. Esto
     es correcto: cada invocacion representa
     un acto de autenticacion distinto.
 * - **Manejo de fallos transitorios**
   - EX-07 cubre BD timeout / deadlock. EX-08
     cubre InternalMailbox offline (parcial,
     no bloqueante).
 * - **Disponibilidad**
   - El uptime del servicio Auth es **el techo
     del uptime del producto entero** — sin
     auth no hay producto. CNST-017 SLA aplica
     con prioridad maxima.
 * - **Backup y replicacion**
   - La BD analitica donde viven ``User``,
     ``Session`` y ``AuditEvent`` debe
     replicarse y respaldarse segun CNST-006
     arquitectura BD dual.
 * - **Recovery**
   - En caso de perdida de la BD, las Sessions
     activas se invalidan al fallar la
     verificacion contra BD (CNST-003 — sesiones
     persistidas en BD, no en memoria).

6.4 Usabilidad
==============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Idioma**
   - Mensajes al usuario en espanol claro y
     directo. Nada de jerga tecnica como
     "JWT invalido" o "bcrypt mismatch".
 * - **Feedback inmediato**
   - El boton "Iniciar sesion" muestra spinner
     mientras se procesa la respuesta. Tras
     respuesta, mensaje de exito o error
     visible en menos de 1 segundo.
 * - **Anti-doble-submit**
   - El frontend deshabilita el boton entre
     submit y respuesta para prevenir doble
     login.
 * - **Persistencia de username**
   - El campo username no se limpia tras un
     login fallido — el usuario solo retoca el
     password.
 * - **Mostrar / ocultar password**
   - Toggle visible para que el usuario pueda
     verificar lo que tipea.
 * - **Atajos de teclado**
   - Enter en cualquier campo dispara el submit.
 * - **Accesibilidad**
   - Labels asociadas a inputs; mensajes de
     error con ``aria-live``; contraste de
     colores AA.
 * - **Mobile responsive**
   - El formulario se adapta a viewports desde
     320px.
 * - **Recordatorio de proxima accion**
   - En FA-01 / FA-02 el modal de cambio de
     contrasena explica por que se requiere
     (primer login o expiracion proxima) — el
     usuario sabe que esta haciendo y por que.

6.5 Auditabilidad
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Eventos generados**
   - ``LOGIN``, ``LOGIN_FAILED``,
     ``LOGIN_BLOCKED``, ``LOGIN_INACTIVE``,
     ``LOGIN_THROTTLED``, ``SESSION_CLOSED``
     (cuando aplica CNST-004).
 * - **Inmutabilidad**
   - CNST-025 — append-only, sin UPDATE ni
     DELETE.
 * - **Trazabilidad**
   - Cada AuditEvent tiene ``actor_user_id``,
     ``occurred_at``, ``payload`` con IP y
     user_agent. Permite reconstruir patrones
     de acceso para investigacion forense.
 * - **Retencion**
   - Periodo definido en CNST-018 rango maximo
     de consulta (2 anos) y politicas de
     archivado.
 * - **Acceso a la auditoria**
   - Solo via UCs del cluster AUD (UC_AUD_01
     ``view_audit_log``, UC_AUD_02
     ``search_audit_log``, UC_AUD_03
     ``export_audit_log``, UC_AUD_04
     ``generate_compliance_report``) por
     ``auditor_group`` (AGR-008).

6.6 Mantenibilidad
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Separacion de responsabilidades**
   - Validacion de input (Serializer) ↔ logica
     del UC (View / Service) ↔ persistencia
     (ORM). Cada capa con responsabilidad clara
     (CNST-016 SOLID).
 * - **Pruebas automatizadas**
   - Cobertura del UC mediante tests
     documentados en Parte 12.
 * - **Anti-patrones prohibidos**
   - CNST-015 anti-patrones de arquitectura —
     el UC respeta los limites declarados.
 * - **Logging estructurado**
   - CNST-024 — los logs del UC en formato JSON
     consumible por UC_LOG_01..04.

6.7 Resumen de constraints aplicables
=====================================

.. list-table::
 :widths: 16 84
 :header-rows: 1

 * - CNST
   - Aplicacion en UC_AUTH_01
 * - CNST-001
   - Prohibicion de email — el UC no envia
     email; las notificaciones van por
     InternalMailbox (CNST-002).
 * - CNST-002
   - Buzon interno obligatorio — usado en
     FA-03 para notificar cierre de sesion
     anterior.
 * - CNST-003
   - Sesiones persistidas en BD — la ``Session``
     se persiste en MySQL, no en memoria de
     Django.
 * - CNST-004
   - Sesion unica por usuario — gobernada en
     paso 10 del flujo principal.
 * - CNST-005
   - Timeout 15 min — gobierna ``Session.expires_at``.
 * - CNST-009
   - Autenticacion DRF obligatoria — el endpoint
     usa el framework de DRF.
 * - CNST-011
   - Throttling endpoints publicos — paso 6.
 * - CNST-012
   - Validacion via Serializer — paso 5.
 * - CNST-013
   - Manejo estandarizado de excepciones DRF —
     todas las respuestas 4xx/5xx siguen el
     shape de error estandar.
 * - CNST-016
   - SOLID — diseno de las clases View / Service
     / Serializer.
 * - CNST-017
   - SLA tiempos de respuesta.
 * - CNST-024
   - Logs estructurados JSON — para
     observabilidad via UC_LOG_*.
 * - CNST-025
   - Auditoria inmutable — emision del
     ``AuditEvent LOGIN``.
 * - CNST-026
   - PII prohibida en logs y auditoria — el
     payload de AuditEvent NO contiene
     password ni tokens.
