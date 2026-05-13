.. _uc-rpt-12-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_12
 * - **Nombre**
   - Reporte de Agentes
 * - **BReq**
   - BReq-001, BReq-003
 * - **Funcion RBAC**
   - ``view_agent_reports``

1.2 Proposito
=============

Analizar productividad y performance por
agente. Casos: revision semanal de KPIs,
identificar gaps de capacitacion,
balanceo de cargas.

1.3 Metricas por agente
=======================

- Calls answered / abandoned
- TMO (avg handle time)
- AHT (avg time talking + wrap)
- Ocupacion (%) = busy/total_time
- Adherence (%) = scheduled vs actual
- Holds count / avg hold time
- Transfers (in/out)
- After Call Work duration

1.4 Privacidad
==============

CNST-026 sin PII — el reporte usa agent_id
y display_name (no SSN, telefono personal).
Acceso al reporte controlado por:

- ``view_agent_reports``: ver agregados
  del segmento.
- ``view_agent_detail``: drill a 1 agente
  (P-44 audit reforzado).

1.5 Restricciones
=================

- CNST-007, CNST-008, CNST-009.
- CNST-026 sin PII.

1.6 Out of scope
================

- Auditar acciones del agente
  (UC_AUD_*).
- Modificar schedule (UC_USR_*).
