.. _uc-rpt-10-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes
================

- **SavedViewEndpoint** (CRUD + clone +
  apply)
- **ViewValidator**
- **ColumnCatalog**
- **SavedViewRepo**

11.2 Contratos
==============

::

   contract SavedViewService:
     create, list, get,
     update, delete, clone
     apply(view_id, invoker)
       returns: expanded request

11.3 Pseudocodigo
=================

::

   procedure create(payload, invoker, ctx):
       ViewValidator.validate(
         payload, ColumnCatalog,
         SegmentResolver.for(invoker.id))
       if SavedViewRepo.exists(
              invoker.id, payload.name):
           raise NameDuplicate
       if SavedViewRepo.count(invoker.id)
              >= 30:
           raise LimitExceeded
       view = SavedView(
         id=uuid_v7(), actor_id=invoker.id,
         ...)
       SavedViewRepo.save(view)
       AuditService.emit('VIEW_CREATED', ...)

   procedure apply(view_id, invoker):
       view = SavedViewRepo.get(view_id)
       if view.actor_id != invoker.id and
          not SharedView.allows(
                view, invoker):
           raise SinPermiso
       expanded = expand_view(view)
       columns_available = [
         c for c in view.columns
         if ColumnCatalog.exists(
              c, view.report_type)]
       expanded.columns = columns_available
       return expanded

11.4 Stack-agnostico
====================

- BD: cualquier RDBMS con JSON.
- Catalog: archivo de config / DB / API.
