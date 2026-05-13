.. _uc-rpt-01-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Sin datos para el periodo
====================================

Query retorna 0 rows. Response con todos
los KPIs en 0 / null. Frontend muestra
mensaje "Sin datos para hoy".

4.2 FA-02: Cache hit
====================

PASO 6 hit. Response inmediato; cache=true.

4.3 FA-03: Drill-down a KPI
===========================

Click en KPI navega a UC_RPT_03 (historico)
o UC_RPT_12/13/14 (detalle por dimension).
NO se implementa aqui — UC_RPT_01 solo
retorna estructura; navegacion es UI.

4.4 FA-04: Auto-refresh
=======================

Frontend polling cada 30s mientras la
pestana es visible. Visibility API
suspende polling si esta en background.

4.5 FA-05: ETL ventana cerrada
==============================

Si Analytics no se ha actualizado por > X
min (ETL desfasado), response incluye
``staleness_minutes``. Frontend muestra
banner "Datos atrasados X min".

4.6 FA-06: User multi-segmento
==============================

Segmentos = [seg_a, seg_b]. Query incluye
ambos via WHERE / IN. Resultado: union de
KPIs de los segmentos. ``segments_applied``
en response indica cuales se aplicaron.

4.7 FA-07: Periodo last_7d
==========================

Trend buckets diarios (no por hora). Cache
TTL 5 min en lugar de 30 s (datos cambian
mas lento).

4.8 FA-08: Preferencia de auto-refresh off
==========================================

User desactiva auto-refresh. Frontend deja
de hacer polling. Manual refresh disponible
con boton.

4.9 Resumen
===========

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin datos
   - KPIs en 0
   - mensaje frontend
 * - FA-02
   - Cache hit
   - response inmediato
   - mayoritario
 * - FA-03
   - Click KPI
   - navega a otro UC
   - UI
 * - FA-04
   - Auto-refresh
   - polling 30s
   - Visibility API
 * - FA-05
   - ETL desfasado
   - staleness banner
   - operacional
 * - FA-06
   - Multi-segmento
   - union
   - CNST-008
 * - FA-07
   - last_7d
   - buckets diarios
   - TTL 5 min
 * - FA-08
   - Refresh off
   - manual
   - preferencia
