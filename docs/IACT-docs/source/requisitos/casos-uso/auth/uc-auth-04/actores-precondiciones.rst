.. _uc-auth-04-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User autenticado** — cualquier ``User`` con
Session ACTIVE que cambia su propia contrasena.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Identificacion**
   - JWT con ``user_id`` y ``session_id``
 * - **Iniciador y beneficiario**
   - SI (sobre su propia cuenta)
 * - **Responsabilidad**
   - conocer su contrasena actual; proponer una
     nueva que cumpla la politica

Cualquier User (independiente de su AGR) puede
invocar UC_AUTH_04. Incluso usuarios con scope
limitado por FA-01 de UC_AUTH_01 estan
autorizados — es justamente el camino para
desbloquear su sesion.

2.2 Actores Secundarios
=======================

2.2.1 Sistema (Backend Django)
------------------------------

Responsabilidades:

- Validar contrasena actual (bcrypt.checkpw).
- Validar complejidad de la nueva.
- Consultar PasswordHistory para verificar
  no-reuso.
- Hashear bcrypt cost 12 y persistir.
- Insertar nueva entry en PasswordHistory.
- Actualizar ``User.first_login=false`` y
  ``password_changed_at=NOW()``.
- Cerrar otras Sessions (segun politica).
- Emitir AuditEvent.

2.2.2 BD analitica (MySQL)
--------------------------

Responsabilidades:

- Atomicidad ACID en pasos de UPDATE +
  INSERT history + INSERT audit.
- Append-only en AuditEvent y PasswordHistory.

2.2.3 Frontend (React)
----------------------

Responsabilidades:

- Formulario con 3 inputs: actual, nueva,
  confirmar nueva.
- Indicador de fuerza de la contrasena
  client-side (UI hint, no decision final).
- Mensajes de error claros sin exponer la
  politica completa (no "tu contrasena debe
  contener X" en el form — eso ayuda a
  ataques de bruteforce sobre el historial).

2.2.4 Auditor (beneficiario indirecto)
--------------------------------------

Consume AuditEvent PASSWORD_CHANGED para
detectar:

- Patrones de cambios masivos (botnet?).
- Cambios desde IPs no usuales.

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend Django respondiendo en
  ``/api/auth/change-password/``.
- BD MySQL accesible.
- HTTPS configurado.

2.3.2 User autenticado
----------------------

- ``Session`` con ``state=ACTIVE`` para el
  user.
- Token JWT valido.
- ``User.state ∈ {ACTIVE, INACTIVE,
  BLOCKED, PENDING_CONFIG}`` — incluso BLOCKED
  puede cambiar contrasena (no resetea el
  bloqueo).

2.3.3 Politica disponible
-------------------------

- Configuracion de password policy cargable:
  longitud minima, charset requerido, N en
  historial.
- Diccionario de palabras prohibidas
  (top-1000) accesible.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- ``User.password_hash`` actualizado.
- ``User.first_login = false``.
- ``User.password_changed_at = NOW()``.
- 1 nueva entry en
  ``PasswordHistory(user, password_hash,
  changed_at)`` — la mas vieja se descarta si
  excede N=5.
- Sessions OTRAS DEL USER cerradas (politica
  por default; configurable).
- 1 ``AuditEvent`` con
  ``event_type='PASSWORD_CHANGED'``,
  ``actor_user_id=user.id``,
  ``payload={ip, user_agent, prior_first_login,
  other_sessions_closed_count}``.
- Frontend muestra confirmacion de exito y
  redirige al destino apropiado:

  - Si era post first_login: navega al landing
    normal con sesion plena.
  - Si era voluntario: queda en la pagina
    actual.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-06: rollback completo. ``User``
  intacto. Sin nueva entry en history. Sin
  AuditEvent PASSWORD_CHANGED (puede haber
  AuditEvent PASSWORD_CHANGE_FAILED segun
  politica).

2.4.3 Postcondiciones secundarias
---------------------------------

- Cualquier intento de usar tokens previos
  (excepto el token actual) responde 401 si la
  politica cierra otras sessions.
- Si el cambio era forzado (first_login), la
  Session actual pasa de scope reducido a
  scope pleno.
