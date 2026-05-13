.. _uc-rpt-09-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes
================

- **SavedFilterEndpoint** (CRUD)
- **FilterValidator** (segmento + estructura)
- **SavedFilterRepo**
- **SegmentChangeListener** (revalidate)

11.2 Contratos
==============

::

   contract SavedFilterService:
     create, list, get, update, delete
       returns ...
       throws ValidationError,
              SegmentViolation,
              LimitExceeded
     apply(saved_filter_id, invoker)
       returns: expanded_filters
       throws FilterInvalid

11.3 Pseudocodigo
=================

::

   procedure create(payload, invoker, ctx):
       FilterValidator.validate_structure(
         payload.filters)
       FilterValidator.validate_against_scope(
         payload.filters,
         SegmentResolver.for(invoker.id))
       if SavedFilterRepo.exists(
              invoker.id, payload.name):
           raise NameDuplicate
       if SavedFilterRepo.count(invoker.id)
              >= 50:
           raise LimitExceeded
       saved = SavedFilter(
         id=uuid_v7(), actor_id=invoker.id,
         name, filters, period_relative,
         applies_to, ...)
       SavedFilterRepo.save(saved)
       AuditService.emit('FILTER_CREATED', ...)
       return saved

   on segments_changed(user_id):
       affected =
         SavedFilterRepo.list(user_id)
       new_segments =
         SegmentResolver.for(user_id)
       for f in affected:
           if not validates_against(
                    f.filters, new_segments):
               f.is_invalid = true
               SavedFilterRepo.save(f)

11.4 Stack-agnostico
====================

- BD: cualquier RDBMS con JSON / JSONB.
- Event listener: pub/sub o trigger.
