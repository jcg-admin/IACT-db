.. _uc-rpt-14-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_14
 * - **Nombre**
   - Reporte de Campanas
 * - **BReq**
   - BReq-001, BReq-003
 * - **Funcion RBAC**
   - ``view_campaign_reports``

1.2 Proposito
=============

Analizar performance de campanas
(outbound: ventas, cobranzas; inbound:
soporte, ventas inbound). Comparar
campanas, identificar la mas eficiente.

1.3 Metricas por campana
========================

- Contacts attempted (outbound)
- Contacts reached
- Conversion rate (objective met / reached)
- Calls per hour
- TMO de la campana
- Disposition mix (success / no answer /
  busy / etc.)
- Cost-per-call (si disponible)

1.4 Restricciones
=================

CNST-007, CNST-008, CNST-009.

1.5 Out of scope
================

- Configurar campana (operacional).
- Listas de contactos detalladas (PII —
  separado).
