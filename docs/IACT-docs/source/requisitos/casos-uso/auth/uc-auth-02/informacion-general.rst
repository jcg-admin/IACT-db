.. _uc-auth-02-parte-01:

===========================================
Parte 1 — Informacion general de UC_AUTH_02
===========================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_AUTH_02
 * - **Nombre**
   - Cerrar Sesion
 * - **Version spec**
   - 5.0.0 (estructura 12-partes)
 * - **Fecha**
   - 2026-05-01
 * - **Autor**
   - NestorMonroy
 * - **Clasificacion**
   - ALTO (esencial operativo per
     :doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
     § 1.2.2)
 * - **Modulo**
   - MOD_Auth
 * - **WP origen**
   - ``2026-05-01-07-17-48-uc-auth-02-spec-completa``

1.2 Proposito
=============

UC_AUTH_02 permite que un ``User`` autenticado
**cierre voluntariamente** su ``Session`` activa.
Es la contraparte simetrica de UC_AUTH_01: el
usuario que entro decide salir.

Desde la perspectiva del usuario el proposito es
**desocupar el dispositivo** — en un PC compartido
del call center, dejar el lugar listo para el
proximo turno; en su laptop personal, marcar
inequivocamente que termino su trabajo y reducir
la ventana de exposicion ante un intruso.

Desde el sistema, el proposito es **invalidar
deterministamente** la Session: ``state`` pasa a
``CLOSED`` con ``close_reason = 'USER_LOGOUT'``,
los tokens JWT (access + refresh) se anaden al
blacklist (o equivalente segun strategy), y se
emite un ``AuditEvent LOGOUT`` para trazabilidad
(CNST-025).

1.3 Alcance
===========

1.3.1 IN (incluido)
-------------------

- Recepcion del request POST autenticado.
- Validacion de que el ``access token`` recibido
  corresponde a una ``Session`` con
  ``state = ACTIVE`` del propio ``User``.
- Transicion de la Session a state CLOSED con
  ``close_reason = 'USER_LOGOUT'``,
  ``closed_at = NOW()``.
- Invalidacion del refresh token (blacklist o
  equivalente).
- Emision de ``AuditEvent LOGOUT`` (CNST-025).
- Respuesta 200 OK estandar (CNST-013) o 401 si
  el token ya esta invalidado.

1.3.2 OUT (excluido)
--------------------

- Cierre de Sessions de **otros** usuarios — eso
  es UC_AUTH_05 (gestionar sesiones, admin).
- Cierre por timeout — automatico per CNST-005,
  no requiere UC.
- Cierre por sesion superseded (CNST-004) — lo
  ejecuta UC_AUTH_01 al iniciar nueva sesion.
- Limpieza del cliente (frontend) de tokens en
  localStorage / cookies — responsabilidad del
  frontend.

1.3.3 Posicion en el flujo
--------------------------

UC_AUTH_02 es **simetrico** de UC_AUTH_01. Su
entrada es una Session activa producida por
UC_AUTH_01 o restaurada despues de FA-01/FA-02 +
UC_AUTH_04. Su salida es la finalizacion limpia
de la Session.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq origen**
   - BRQ-AUTH-002 — el sistema debe permitir al
     usuario autenticado cerrar su sesion.
 * - **Reglas de Negocio**
   - BR-AUTH-08 (cierre voluntario), BR-009
     v2.0.0 (alcance global de soft-delete).
 * - **Restricciones (CNST canonicas vigentes)**
   - CNST-003 sesiones persistidas en BD;
     CNST-004 sesion unica; CNST-009
     autenticacion DRF; CNST-013 manejo
     estandarizado; CNST-025 auditoria
     inmutable.
 * - **Funcion RBAC**
   - sesion propia (cualquier User
     autenticado puede cerrar SU PROPIA Session).
 * - **UC Relacionados**
   - UC_AUTH_01 (Iniciar Sesion, simetrico),
     UC_AUTH_05 (Gestionar Sesiones, admin
     cierre de otras Sessions).
 * - **Clase de Dominio primaria**
   - ``Session``
 * - **Clases secundarias**
   - ``AuditEvent``
