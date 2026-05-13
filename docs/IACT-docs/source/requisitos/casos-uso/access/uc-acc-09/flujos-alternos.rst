.. _uc-acc-09-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Filter target_user_id (audit P-16)
=============================================

**Activador**: filtro especifico ``target_user_id``.

**Diferencia**: PASO 10 emite
``ACCESS_AUDIT_VIEWED`` con
``payload.target_user_id``. Caso de
investigacion focalizada.

4.2 FA-02: Listado vacio
========================

**Activador**: filtros sin matches.

**Diferencia**: ``count=0, results=[]``.

4.3 FA-03: Vista detalle
========================

**Activador**: GET
``/api/access/audit/{event_id}/``.

**Diferencia**:

- Validar evento existe.
- Si evento no es de MOD_Access (filter
  scope), 404.
- Audit P-16 emit con
  ``viewed_event_id``.

4.4 FA-04: Vista agregada (counts)
==================================

**Activador**: query
``/api/access/audit/aggregations/?
group_by=event_type``.

**Diferencia**:

- Backend ejecuta agregacion (COUNT, GROUP
  BY).
- Response es array de
  ``{event_type, count}``.
- NO se audita (vista amplia P-16).

4.5 FA-05: Filter por funcion implicada
=======================================

**Activador**: query
``?includes_function_id=42``.

**Diferencia**: Backend filtra eventos cuyo
``payload.function_ids`` contiene 42 (operador
JSON contains). Audit con
``includes_function_id=42``.

4.6 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01
   - filter target_user_id
   - Audit P-16
   - 200 OK
 * - FA-02
   - Sin matches
   - results=[]
   - 200 OK
 * - FA-03
   - Vista detalle
   - 200 con detalle, audit P-16
   - 200 / 404
 * - FA-04
   - Agregaciones
   - count grouped (sin audit)
   - 200 OK
 * - FA-05
   - filter function_id
   - JSON contains
   - 200 OK
