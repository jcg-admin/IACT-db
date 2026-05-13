.. _uc-usr-02-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

UC_USR_02 tiene **2 sub-flujos**:

- **3.A** Listar Users
- **3.B** Ver detalle de un User

3.A Sub-flujo: Listar Users
===========================

3.A.1 Resumen
-------------

::

   PASO 1   Admin abre vista "Usuarios"           (Frontend)
   PASO 2   Aplica filtros / paginacion           (Frontend)
   PASO 3   GET /api/users/                       (FE → BE)
   PASO 4   Validar JWT + RBAC list_users         (Backend)
   PASO 5   Construir query (filtros + sort)      (Backend)
   PASO 6   SELECT paginado                       (Backend → BD)
   PASO 7   Aplicar restriccion de campos
            (CNST-026 sin PII directa)            (Backend)
   PASO 8   Audit selectivo P-16
            (si filter user_id)                   (Backend → BD)
   PASO 9   200 OK con resultados                 (BE → FE)
   PASO 10  Frontend renderiza tabla              (Frontend)

3.A.2 Detalle clave
-------------------

PASO 5: el query construido respeta los segmentos del
invocante (CNST-008 si aplicara — para listados
restringidos por segmento).

PASO 7: campos visibles en lista:

- ``id``, ``username``, ``state``, ``last_login_at``,
  ``created_at``, AGRs activos (solo IDs).

Campos NO visibles en lista (CNST-026):

- ``email`` completo (solo dominio o partes
  enmascaradas segun politica).
- ``full_name`` completo (politica).
- Datos de password / hash.

PASO 8: AuditEvent ``USERS_VIEWED_FOR_USER`` solo si
``user_id`` filter especifico (caso de
investigacion). Listados amplios NO se auditan
(volumen alto, baja relevancia).

3.B Sub-flujo: Ver detalle
==========================

3.B.1 Resumen
-------------

::

   PASO 1   Frontend solicita detalle             (Frontend)
   PASO 2   GET /api/users/{id}/                  (FE → BE)
   PASO 3   Validar JWT + RBAC view_users         (Backend)
   PASO 4   Localizar User                        (Backend → BD)
   PASO 5   Cargar Assignments + AGRs activos     (Backend → BD)
   PASO 6   Construir respuesta detallada         (Backend)
   PASO 7   Audit USER_DETAIL_VIEWED              (Backend → BD)
   PASO 8   200 OK con detalle completo           (BE → FE)
   PASO 9   Frontend renderiza vista detalle      (Frontend)

3.B.2 Detalle clave
-------------------

PASO 3: requiere ``view_users`` (NO basta con
``list_users``). Granularidad RBAC explicita —
P-15 RBAC granular.

PASO 5: ``Assignment.objects.filter(
user=target_user, state='ACTIVE')`` con
``select_related('access_group')``.

PASO 6: respuesta incluye:

- Datos del User (todos los campos no-secretos).
- Assignments activos con AGR + ``granted_at``
  + ``granted_by_admin_id``.
- ``last_login_at`` y conteo de Sessions activas
  (para correlacion con UC_AUTH_05).

PASO 7: AuditEvent siempre emitido para detalle
(P-16 — vista focalizada se audita).

3.C Datos comunes
=================

- HTTPS + JWT (CNST-009).
- RBAC granular (``list_users`` vs
  ``view_users``).
- Sin PII directa innecesaria (CNST-026).
- Manejo de errores estandar (CNST-013).
- Audit selectivo P-16 (no todas las lecturas).
