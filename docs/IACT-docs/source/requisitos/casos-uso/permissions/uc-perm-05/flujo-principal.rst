.. _uc-perm-05-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3 sub-flujos: crear, modificar, retirar.

3.A Crear AGR
=============

::

   PASO 1   POST /api/access-groups/
   PASO 2   Validar JWT + manage_access_groups
   PASO 3   Validar payload (code formato +
            unique + no colision predefinidos)
   PASO 4   INSERT AccessGroup
   PASO 5   AuditEvent ACCESS_GROUP_CREATED
   PASO 6   201 Created

3.B Modificar AGR
=================

::

   PASO 1   PATCH /api/access-groups/{id}/
   PASO 2   Validar JWT + manage_access_groups
   PASO 3   Validar AGR existe + ACTIVE +
            es custom (no predefinido)
   PASO 4   Validar payload (campos
            modificables)
   PASO 5   UPDATE AccessGroup
   PASO 6   AuditEvent ACCESS_GROUP_MODIFIED
   PASO 7   200 OK

Campos NO modificables (post-create):

- ``code`` (inmutable — defensa anti-confusion
  para Users que ya lo conocen).
- ``is_predefined`` (siempre false para
  custom).

3.C Retirar AGR
===============

::

   PASO 1   DELETE /api/access-groups/{id}/
   PASO 2   Validar JWT + manage_access_groups
   PASO 3   Validar AGR existe + ACTIVE + custom
   PASO 4   Validar retire_reason ≥ 20 chars
   PASO 5   Calcular users_with_agr_count
            (informativo)
   PASO 6   UPDATE state=RETIRED + metadata
   PASO 7   AuditEvent ACCESS_GROUP_RETIRED
            con users_with_agr_count
   PASO 8   200 OK

3.D Atomicidad
==============

Cada sub-flujo es transaccion atomica
(persistencia + audit).
