.. _uc-rpt-07-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_07
 * - **Nombre**
   - Programar Reporte
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-001, BReq-007
 * - **Funcion RBAC**
   - ``schedule_reports``

1.2 Proposito
=============

Programar reportes recurrentes (e.g.,
"diario a las 7am: KPIs del dia anterior")
sin que el supervisor tenga que generar
cada vez. Cada ejecucion produce un
ExportJob (UC_RPT_04) automaticamente.

1.3 Frecuencias soportadas
==========================

- ``daily`` (especifica hora del dia)
- ``weekly`` (dia + hora)
- ``monthly`` (dia del mes + hora)
- ``cron expression`` (avanzado)

Hora siempre en zona horaria del User
(o explicita).

1.4 Limites
===========

- Max scheduled reports por User: 10.
- Frecuencia minima: 1 hora.
- Retencion ejecucion: 30 dias online.

1.5 Restricciones
=================

- CNST-001: notify via mailbox (no email).
- CNST-002: mailbox.
- CNST-007: lectura Analytics.
- CNST-008: filtro segmento.
- CNST-025: audit cambios al schedule.

1.6 Out of scope
================

- Compartir output con otros (UC_RPT_11).
- UI catalogo (UC_RPT_08).
