.. _uc-auth-05-parte-01:

============================================
Parte 1 — Informacion general de UC_AUTH_05
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_AUTH_05
 * - **Nombre**
   - Gestionar Sesiones
 * - **Version spec**
   - 5.0.0
 * - **Fecha**
   - 2026-05-01
 * - **Autor**
   - NestorMonroy
 * - **Clasificacion**
   - MEDIO
 * - **Modulo**
   - MOD_Auth
 * - **WP origen**
   - ``2026-05-01-08-00-00-uc-auth-05-spec-completa``

1.2 Proposito
=============

UC_AUTH_05 da al administrador con AGR-006
visibilidad y control sobre las ``Session``
activas del sistema. Es una herramienta
operacional de seguridad: detectar sesiones
sospechosas, cerrar sesiones de un User
comprometido, supervisar concurrencia.

Tres operaciones en este UC:

- **Listar** Sessions activas (con filtros).
- **Ver detalle** de una Session.
- **Cerrar** Session(s) — individual o todas las
  del User.

1.3 Alcance
===========

1.3.1 IN (incluido)
-------------------

- GET de lista paginada de Sessions con
  filtros (state, user_id, ip, fecha,
  user_agent fuzzy).
- GET de detalle de una Session.
- DELETE / POST de cierre de Session
  individual.
- POST de cierre masivo de las Sessions de un
  User.
- Emision de AuditEvent SESSION_CLOSED por
  cada Session cerrada.

1.3.2 OUT (excluido)
--------------------

- Cierre por el propio User — UC_AUTH_02.
- Cierre automatico por timeout (CNST-005) —
  proceso del sistema, no UC.
- Cierre automatico por sesion superseded
  (CNST-004) — lo ejecuta UC_AUTH_01 al iniciar
  nueva sesion.
- Modificacion del estado del User (BLOCKED,
  ACTIVE) — UC_USR_05/06.
- Reseteo de password — UC_AUTH_03.

1.3.3 Posicion en el flujo
--------------------------

UC_AUTH_05 es **operacion administrativa** que
no entra ni sale de un flujo de negocio
principal. Es una capacidad continua,
disponible cualquier momento.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq origen**
   - BRQ-AUTH-005 — el sistema debe permitir al
     admin gestionar sesiones activas.
 * - **Restricciones**
   - CNST-003 sesiones persistidas; CNST-004
     sesion unica (consistencia); CNST-009
     auth; CNST-013 manejo estandar; CNST-025
     audit inmutable; CNST-026 sin PII.
 * - **Funciones RBAC**
   - ``view_all_active_sessions`` (lectura),
     ``close_user_session`` (cierre).
 * - **AGR**
   - AGR-006 user_admin_group (incluye ambas
     funciones).
 * - **UC Relacionados**
   - UC_AUTH_02 (cierre voluntario por el
     User), UC_USR_05 (bloquear usuario —
     puede invocar UC_AUTH_05 internamente).
 * - **Clase primaria**
   - ``Session``
 * - **Clases secundarias**
   - ``BlacklistedToken``, ``AuditEvent``
