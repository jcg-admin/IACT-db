.. _uc-rpt-02-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_RPT_02
 * - **Nombre**
   - Ver Metricas en Tiempo Real
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-001, BReq-006
 * - **Funcion RBAC**
   - ``view_realtime_metrics``
 * - **Criticidad**
   - Importante (operacional)

1.2 Proposito
=============

Mostrar el "ahora" del call center:
llamadas en cola, agentes ocupados / libres,
tasa de abandono en ventana movil.
Diferencia clave con UC_RPT_01: granularidad
y latencia sub-minuto.

1.3 Metricas en tiempo real
===========================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Metrica
   - Definicion
 * - Llamadas en cola
   - count(calls.state='queued')
 * - Agentes ocupados
   - count(agents.state='busy')
 * - Agentes libres
   - count(agents.state='idle')
 * - Llamadas atendidas / hora
   - rolling 1h
 * - Tasa abandono / 5min
   - rolling 5min
 * - SL / 15min
   - rolling 15min
 * - Lag actual
   - segundos desde ultima
     actualizacion del stream

1.4 Mecanismo de transporte
===========================

Stack-agnostico, tres opciones validas:

- **SSE** (Server-Sent Events): default
  recomendado — push unidireccional, simple.
- **WebSocket**: si se requiere bidireccional
  o filtros dinamicos sin reconectar.
- **Long-polling**: fallback para clientes
  con proxies que bloquean SSE/WS.

El UC define el contrato del **mensaje**;
el transport es decision tecnica.

1.5 Restricciones
=================

- CNST-007: read Analytics streaming.
- CNST-008: filtro segmento.
- CNST-009: JWT en handshake.
- CNST-013: excepciones estandar.

1.6 Out of scope
================

- Estado individual de agente
  (UC_RPT_12).
- Estado individual de cola
  (UC_RPT_13).
- Historico → UC_RPT_03.
