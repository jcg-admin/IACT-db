.. _uc-perm-10-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Actor
   - Tipo
   - Rol
 * - **User con funcion**
     ``view_audit_log``
   - Humano
   - Auditor / Compliance / Soporte
 * - **AuthorizationGuard**
   - Sistema
   - valida JWT + RBAC
 * - **AuditRepo (read replica)**
   - Sistema
   - sirve queries
 * - **AuditService (UC_PERM_09)**
   - Sistema
   - emite meta-audit
     ``AUDIT_LOG_QUERIED``
 * - **ExportWorker**
   - Sistema
   - genera CSV / JSON async

2.2 Precondiciones
==================

- Caller autenticado.
- Caller tiene ``view_audit_log`` activa.
- AuditRepo accesible (read replica
  preferido).

2.3 Postcondiciones
===================

**Caso lista exitosa:**

- Response 200 con events + cursor.
- Meta-audit AUDIT_LOG_QUERIED emitido.

**Caso export:**

- Async job creado.
- Notification interna cuando completa.

2.4 Datos de entrada
====================

Comunes a list / aggregate:

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Param
   - Notas
 * - Filtros
   - ver 1.4
 * - cursor
   - opaco; null inicial
 * - page_size
   - default 50, max 200
 * - sort
   - created_at DESC default

Para detalle:

- ``id`` UUID.

Para export:

- Filtros (mismo).
- format: csv | json.
- include_archive: bool.

2.5 Datos de salida
===================

**List**:

::

   {
     events: [
       { id, event_type, actor_id,
         target_type, target_id,
         payload (sanitized snippet),
         ip_address, request_id,
         module, created_at },
       ...
     ],
     next_cursor: opaque | null,
     estimated_total: int,
     query_id: uuid (meta-audit
                       correlation)
   }

**Detalle**: AuditEvent completo.

**Aggregate**:

::

   {
     group_by: enum,
     buckets: [
       { key, count, sample_event_id }, ...
     ],
     query_id
   }

**Export (async)**:

::

   {
     job_id: uuid,
     status: queued,
     check_url: ...
   }
