.. _uc-perm-09-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_PERM_09
 * - **Nombre**
   - Auditar Acceso (write side)
 * - **Categoria**
   - Servicio core de auditoria
 * - **Modulo**
   - MOD_Permissions / Auditoria
 * - **BReq**
   - BReq-004
 * - **Funcion RBAC (write)**
   - No aplica (servicio interno)
 * - **Criticidad**
   - **Critica** — perdida de eventos
     ⇒ breach de compliance

1.2 Proposito
=============

Persistir registros inmutables de eventos
de seguridad / autorizacion para:

- **Cumplimiento normativo** (auditorías)
- **Investigacion de incidentes**
- **Detección de patrones anomalos**
- **Trazabilidad** (quien, cuando, que,
  resultado)

1.3 Eventos auditados
=====================

UC_PERM_09 audita estos tipos de evento:

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - event_type
   - Origen
 * - ``LOGIN_SUCCESS``
   - UC_AUTH_01
 * - ``LOGIN_FAILED``
   - UC_AUTH_01 (intentos fallidos)
 * - ``LOGOUT``
   - UC_AUTH_02
 * - ``PASSWORD_CHANGED``
   - UC_AUTH_03
 * - ``PASSWORD_RESET``
   - UC_AUTH_04
 * - ``USER_CREATED``
   - UC_USR_01
 * - ``USER_DEACTIVATED``
   - UC_USR_03
 * - ``AGR_ASSIGNED``
   - UC_ACC_01 / UC_PERM_01
 * - ``AGR_REVOKED``
   - UC_ACC_02 / UC_PERM_02
 * - ``ACCESS_GRANTED``
   - UC_ACC_06 (concesion excepcional)
 * - ``ACCESS_REVOKED_EXCEPTIONAL``
   - UC_ACC_06 (revocacion excepcional)
 * - ``ACCESS_GROUP_CREATED``
   - UC_PERM_05
 * - ``ACCESS_GROUP_RETIRED``
   - UC_PERM_05
 * - ``ACCESS_GROUP_COMPOSITION_CHANGED``
   - UC_PERM_06
 * - ``ACCESS_GROUP_COMPOSITION_FAILED``
   - UC_PERM_06 (cascade SoD bloque)
 * - ``UNAUTHORIZED``
   - cualquier UC, 403
 * - ``SOD_VIOLATION``
   - UC_ACC_*, UC_PERM_06
 * - ``CRITICAL_ACTION``
   - acciones marcadas con
     ``audit_required=true``

1.4 Lo que NO audita
====================

- Permission checks individuales
  (UC_PERM_07 — P-51 read-no-audit).
- Generacion de menu (UC_PERM_08).
- Lecturas comunes (visualizacion de
  dashboards, reportes — solo cambios).
- Operaciones internas del sistema (jobs,
  cron) — tienen su propio log
  operacional (UC_LOG).

1.5 Estructura del AuditEvent
=============================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Campo
   - Descripcion
 * - id
   - UUID inmutable
 * - event_type
   - enum (ver 1.3)
 * - actor_id
   - User que realizo la accion
 * - target_type
   - tipo de entidad afectada
 * - target_id
   - id de entidad afectada
 * - payload
   - JSON estructurado (sin PII)
 * - ip_address
   - origen
 * - user_agent
   - cliente
 * - request_id
   - correlacion con UC_LOG
 * - created_at
   - timestamp del evento
 * - module
   - MOD_AUTH / MOD_USERS / ...

1.6 Restricciones canonicas
===========================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - CNST
   - Aplicacion
 * - **CNST-025**
   - Inmutable: AuditEvent NO se borra
     ni modifica. Solo INSERT.
 * - **CNST-026**
   - Sin PII: payload con
     hash de identificadores sensibles
     (ej: email hash, no email plano).
 * - **CNST-013**
   - Excepciones: si emit falla, la
     accion principal hace ROLLBACK
     (P-09 audit-or-abort).

1.7 Canales prohibidos
======================

CNST-001 / CNST-002 — el audit NO genera
notificaciones via email o externo. Solo
internal mailbox para alertas (UC_ALR_*).

1.8 Out of scope
================

- Consulta de audit logs (UC_PERM_10).
- Generacion de alertas (UC_ALR_*).
- Aging / archival politico (UC_LOG_*).
- Audit de acciones operacionales no de
  permisos (UC_AUD_* o UC_LOG_*).
