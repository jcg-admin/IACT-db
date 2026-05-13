.. _uc-perm-09-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidad principal
=====================

**AuditEvent**

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - ``id``
   - UUID v7
   - ordenable por tiempo
 * - ``event_type``
   - enum
   - ver 1.3 de info-general
 * - ``actor_id``
   - int | null
   - null en LOGIN_FAILED
 * - ``target_type``
   - string
   - User / AccessGroup / Function / ...
 * - ``target_id``
   - bigint | string
   - id natural
 * - ``payload``
   - JSON
   - sin PII
 * - ``ip_address``
   - inet
   - origen
 * - ``user_agent``
   - text
   - sanitizado
 * - ``request_id``
   - uuid
   - correlacion UC_LOG
 * - ``module``
   - string
   - MOD_*
 * - ``created_at``
   - timestamp UTC
   - inmutable

Constraints:

- PRIMARY KEY ``id``.
- INDEX ``(actor_id, created_at DESC)``.
- INDEX ``(event_type, created_at DESC)``.
- INDEX ``(target_type, target_id,
  created_at DESC)``.
- BD-level constraint: NO UPDATE,
  NO DELETE.

7.2 Particiones (NFR 6.4)
=========================

Por mes:

::

   audit_event_2026_05
   audit_event_2026_06
   ...

Aging job (UC_LOG):

- > 90 dias → mover a archive.
- > 365 dias → mover a cold storage.

Pero el AuditEvent en archive sigue siendo
inmutable.

7.3 Datos derivados (alertas)
=============================

AlertEngine consume AuditEvents para
calcular series:

- denials por User en ventana
- LOGIN_FAILED por IP
- CRITICAL_ACTION fuera de horario

No son datos persistidos por UC_PERM_09 —
son responsabilidad de UC_ALR_*.

7.4 Datos NO involucrados
=========================

- PII de Users (nombre, email plano).
- Tokens, passwords, secrets.
- Contenido de mensajes (UC_MSG si existe).
- Datos de sesion no auth.

7.5 Esquema del payload por tipo
================================

**AGR_ASSIGNED**:

::

   {
     access_group_code,
     valid_until,
     assignment_reason
   }

**ACCESS_GROUP_COMPOSITION_CHANGED**:

::

   {
     agr_code,
     functions_added: [code, ...],
     functions_removed: [code, ...],
     change_reason,
     cascade_affected_user_count
   }

**LOGIN_FAILED**:

::

   {
     username_hash,
     reason: enum,
     attempt_count_in_window
   }

**UNAUTHORIZED**:

::

   {
     attempted_function,
     method,
     path,
     reason: "missing_function" |
              "revoked" |
              "expired"
   }

Catalogo de schemas vive en
documentacion separada (no en este UC) —
pero esta convencion garantiza
estandarizacion.
