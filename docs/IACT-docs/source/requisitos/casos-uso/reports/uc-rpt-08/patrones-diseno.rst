.. _uc-rpt-08-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   - view_scheduled_reports
 * - **P-25**
   - Read replicas
   - lista
 * - **P-51**
   - Read-no-audit
   - lista no audita
 * - **P-58**
   - Segment-bound
   - filtro automatico
 * - **P-68** (nuevo)
   - Ownership-by-default
   - User ve solo propios
     salvo scope expreso

10.2 P-68: Ownership-by-default
===============================

**Problema**: cuando un recurso pertenece
al User, hay tendencia a permitir que un
admin lo vea sin RBAC explicito.

**Solucion**: filtro por actor_id por
default. Ver schedules de OTRO User
requiere funcion ``view_user_schedules``
o equivalente, y entra en P-44 visibility
audit prio.

10.3 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-25
   - NFR
 * - P-51
   - sin audit
 * - P-58
   - PASO 4
 * - P-68
   - CA-07, FA-03
