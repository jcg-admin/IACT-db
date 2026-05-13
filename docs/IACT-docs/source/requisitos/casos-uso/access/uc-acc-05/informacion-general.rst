.. _uc-acc-05-parte-01:

============================================
Parte 1 — Informacion general de UC_ACC_05
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_ACC_05
 * - **Nombre**
   - Gestionar Reglas SoD (Separation of Duties)
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Access

1.2 Proposito
=============

UC_ACC_05 administra el catalogo de **reglas
SoD** que el sistema usa para enforcement
write-time. BR-007 establece que ciertas
funciones son mutuamente excluyentes para un
mismo User (ej. ``modify_users`` y
``audit_users`` no deben coexistir — el que
modifica no audita sus propios cambios).

CNST-005 obliga que estas reglas se evaluen
en tiempo de asignacion (UC_ACC_01,
UC_ACC_04, UC_PERM_03). UC_ACC_05 es el lugar
donde se configuran.

1.3 Alcance
===========

1.3.1 IN
--------

Sub-operacion de lectura
(``view_separation_rules``):

- Listar reglas SoD vigentes (state=ACTIVE) y
  retiradas (state=RETIRED) con paginacion.
- Ver detalle de una regla.

Sub-operacion de gestion
(``manage_separation_rules``):

- **Crear** nueva regla SoD (con par o
  conjunto de funciones en conflicto y
  metadata).
- **Modificar** regla existente
  (display_name, descripcion, estado).
- **Retirar** regla (state ACTIVE → RETIRED;
  no DELETE).

1.3.2 OUT
---------

- Validacion SoD en write-time → UC_ACC_01,
  UC_ACC_04, UC_PERM_03.
- Investigacion de violaciones existentes →
  UC_ACC_03 (modo informativo).
- Reporte de cumplimiento → UC_AUD_*.

1.3.3 Posicion en el flujo
--------------------------

UC_ACC_05 es **operacion de configuracion
critica**. Cambios deben:

- Auditarse exhaustivamente (CNST-025).
- Notificarse a stakeholders (politica).
- Considerar impact retroactivo: una nueva
  regla puede generar violaciones
  pre-existentes (UC_ACC_03 las detectara).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq**
   - BReq-004 Cumplimiento de Seguridad
 * - **BRQ legacy**
   - BRQ-ACC-005
 * - **Reglas**
   - BR-007 Separacion de Funciones (SoD),
     BR-010 Auditoria
 * - **CNST**
   - CNST-005 SoD enforcement, CNST-009,
     CNST-013, CNST-025, CNST-026
 * - **Funciones RBAC**
   - ``view_separation_rules`` (lectura),
     ``manage_separation_rules`` (CRUD —
     P-15 distinta y mas privilegiada)
 * - **AGRs de conveniencia**
   - AGR-006 user_admin_group y AGR de
     seguridad/compliance contienen
     ``manage_separation_rules``;
     ``view_separation_rules`` adicionalmente
     en AGR-008 auditor_group.
 * - **UCs relacionados**
   - UC_ACC_01, UC_ACC_04, UC_PERM_03
     (consumidores), UC_ACC_03 (vista
     informativa de violaciones), UC_AUD_*
     (compliance).
 * - **Clase primaria**
   - ``SoDRule``
 * - **Clases secundarias**
   - ``Function`` (referenciada por la regla),
     ``AuditEvent``.
