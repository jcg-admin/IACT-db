.. _uc-perm-10-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades leidas
====================

- **AuditEvent** (UC_PERM_09).
- **User** (resolver actor_id → display).
- **Function** (resolver function_code).
- **AccessGroup** (resolver target_id en
  events de AGR).

7.2 Entidades escritas
======================

- **AuditEvent** (meta-audit via UC_PERM_09).
- **ExportJob** (job tracking).

7.3 ExportJob
=============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - id
   - uuid
   - PK
 * - actor_id
   - int
   - quien lo encolo
 * - filters
   - JSON
   - filtros aplicados
 * - format
   - csv | json
   -
 * - include_archive
   - bool
   -
 * - status
   - queued | running |
     done | failed
   -
 * - file_path
   - string | null
   - storage path
 * - file_url_expires_at
   - timestamp | null
   - URL firmada
 * - row_count
   - int | null
   - al completar
 * - byte_count
   - int | null
   - al completar
 * - created_at
   - timestamp
   -
 * - completed_at
   - timestamp | null
   -

7.4 Cursor opaco
================

Codifica:

::

   base64({
     last_created_at: ISO8601,
     last_id: uuid,
     filters_hash: string,
     issued_at: ISO8601
   })

Validaciones:

- ``filters_hash`` debe coincidir con la
  request actual (evita reuso con filtros
  distintos).
- ``issued_at`` < 24h.

7.5 Indices criticos
====================

- ``audit_event(created_at DESC, id)``
  primary scan order.
- ``audit_event(actor_id, created_at)``.
- ``audit_event(event_type, created_at)``.
- ``audit_event(target_type, target_id,
  created_at)``.
- ``audit_event(request_id)`` para
  correlacion.

7.6 Datos NO involucrados
=========================

- PII de Users.
- Tokens, passwords.
- Eventos de log operacional (separados,
  UC_LOG_*).
