.. _uc-perm-07-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_PERM_07
 * - **Nombre**
   - Verificar Permiso de Usuario
 * - **Categoria**
   - Servicio core de authorization
 * - **Modulo**
   - MOD_Permissions
 * - **BReq**
   - BReq-004 (cumplimiento + auditoria)
 * - **Funcion RBAC**
   - ``view_assignments`` (solo endpoint
     admin de consulta explicita)
 * - **Criticidad**
   - **Critica** (cada accion del sistema lo
     invoca; bug aqui = breach o lockout)

1.2 Proposito
=============

Responder con autoridad y rapidez:

- ¿El User U tiene la funcion F **ahora**?
- ¿Cual es el **origen** del permiso?
- ¿La respuesta es consistente entre llamadas
  paralelas?

Este UC es el **single source of truth** de
authorization en runtime. Toda decision de
permitir / denegar accion pasa por aqui.

1.3 Modos de invocacion
=======================

Tres consumidores principales:

**(a) Sistema interno (no RBAC-gated)**

- Decorator ``@require_function('F_CODE')``
  en endpoint handler
- Permission class del framework
- Middleware de autorizacion

Estos invocan el servicio **directamente** —
no pasan por endpoint HTTP. NO requieren
funcion adicional (seria recursion: chequear
permiso para chequear permiso).

**(b) Frontend (UC_PERM_08)**

- UC_PERM_08 invoca este UC en bulk para
  construir menu dinamico.
- Optimizado: una llamada con multiples
  function_codes.

**(c) Endpoint admin de consulta (RBAC-gated)**

- ``GET /api/users/{user_id}/permissions/check/?function={code}``
- Requiere ``view_assignments``
- Para auditores y soporte tecnico.

1.4 Algoritmo de precedencia
============================

Orden estricto, primer match gana:

1. **Revocacion excepcional activa** ⇒ DENY
   (prioridad maxima — no debe poder
   bypassearse via grupos).
2. **Concesion excepcional activa** ⇒ ALLOW
   (over-ride a la falta de AGR).
3. **AGR ACTIVE con funcion** ⇒ ALLOW.
4. **Sin match** ⇒ DENY (fail-closed).

Activa = ``state == ACTIVE`` AND
(``valid_until is null`` OR
``valid_until > now``).

Empate: revocacion siempre gana sobre
concesion del mismo periodo (mas restrictivo).

1.5 Origen retornado
====================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - origen
   - Significado
 * - ``REVOKED_EXCEPTIONAL``
   - Hay revocacion explicita; ignora todo
     lo demas. ``allowed = false``.
 * - ``GRANTED_EXCEPTIONAL``
   - Hay concesion explicita activa.
     ``allowed = true``.
 * - ``GRANTED_BY_AGR``
   - Concedida por AGR (incluye lista de
     AGRs que la otorgan).
     ``allowed = true``.
 * - ``DENIED_NO_GRANT``
   - Sin concesion / AGR. ``allowed =
     false``.

1.6 Restricciones canonicas aplicables
======================================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - CNST
   - Aplicacion
 * - **CNST-005**
   - SoD: el servicio NO valida SoD —
     asume que la asignacion paso ese
     check al crearse.
 * - **CNST-008**
   - Visibilidad por segmento: si la funcion
     verificada es ``view_*``, el resultado
     no implica acceso a ``ver`` registros
     fuera del segmento del User.
 * - **CNST-009**
   - Auth: el endpoint admin requiere JWT.
     El servicio interno asume invoker ya
     autenticado (lo enforza el caller).
 * - **CNST-013**
   - Excepciones: estandar.

1.7 Performance crítica
=======================

Es el path más caliente del sistema.
Targets:

- P50 ≤ 5 ms (con cache)
- P95 ≤ 25 ms (cache miss)
- Cache hit ratio ≥ 90%

Ver Parte 6.

1.8 Out of scope
================

- Crear / modificar permisos (UC_ACC_*).
- Auditar el resultado del check (UC_PERM_09
  audita el USO; este UC es read-only y NO
  emite audit events por invocacion — seria
  inviable a la escala de invocaciones).
- Enumerar TODOS los permisos del User
  (UC_ACC_03 / UC_PERM_08 lo hacen).
