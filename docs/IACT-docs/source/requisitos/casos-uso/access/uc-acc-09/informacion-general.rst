.. _uc-acc-09-parte-01:

============================================
Parte 1 — Informacion general de UC_ACC_09
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_ACC_09
 * - **Nombre**
   - Auditar Cambios de Acceso
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Access

1.2 Proposito
=============

UC_ACC_09 expone el historial de eventos
RBAC del sistema con filtros y agregaciones
especificas del dominio Access. Sirve para:

- **Investigacion**: rastrear quien hizo que
  cambio de RBAC sobre quien.
- **Compliance**: producir reportes de
  cambios para auditorias regulatorias.
- **Forensics**: investigar incidentes de
  seguridad — escalada de privilegios,
  asignaciones sospechosas.
- **Triage**: visualizar actividad por
  ventana temporal.

Eventos auditables consumidos:

- ``FUNCTIONS_ASSIGNED`` (UC_ACC_01)
- ``FUNCTIONS_REVOKED`` (UC_ACC_02)
- ``AGR_ASSIGNED`` (UC_ACC_04)
- ``SOD_RULE_*`` (UC_ACC_05)
- ``EXCEPTIONAL_PERMISSION_GRANTED`` /
  ``EXPIRED`` (UC_ACC_08)
- ``UNAUTHORIZED_ACCESS_ATTEMPT`` (todos)
- ``USER_ELIMINATED`` (UC_USR_04 — afecta
  Assignments)

1.3 Alcance
===========

1.3.1 IN
--------

- GET paginado de eventos AuditEvent del
  conjunto consumido (ver §1.2).
- Filtros: ``event_type``, ``actor_user_id``,
  ``target_user_id``, fecha range,
  ``includes_function_id``,
  ``severity`` (informativo).
- Vista detalle de un evento.
- Agregaciones: count por event_type,
  top actors, top targets.
- Exportacion (delegada a UC_RPT_* — fuera
  de este UC).

1.3.2 OUT
---------

- Vista efectiva actual → UC_ACC_03.
- Audit fuera de MOD_Access → UC_AUD_*.
- Generacion de reportes formateados →
  UC_AUD_04 / UC_RPT_*.

1.3.3 Posicion en el flujo
--------------------------

UC_ACC_09 es **operacion de lectura
auditiva continua**. Disparado por:

- Auditor en compliance review.
- Investigador de seguridad post-incidente.
- Admin que quiere ver "que hice ayer".

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-ACC-009
 * - **Reglas**
   - BR-010 Auditoria Inmutable
 * - **CNST**
   - CNST-009/013/025/026
 * - **Funcion RBAC**
   - ``view_access_audit``
 * - **AGR de conveniencia**
   - AGR-008 auditor_group
 * - **UCs relacionados**
   - UC_ACC_01..08 (productores de eventos),
     UC_AUD_01..04 (vista audit general),
     UC_RPT_* (reportes formateados).
 * - **Clase primaria**
   - ``AuditEvent`` (lectura)
