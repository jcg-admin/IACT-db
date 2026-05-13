.. meta::
 :artefacto: UC_RPT_07
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/reports
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-001, CNST-002, CNST-007, CNST-008, CNST-025

.. _uc-rpt-07:

==============================================
UC_RPT_07 — Programar Reporte
==============================================

Resumen
=======

Configurar generacion recurrente de un
reporte (UC_RPT_04 export) en horarios
fijos (diario / semanal / mensual). El
job se ejecuta automaticamente con los
filtros guardados.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Funcion RBAC**
   - ``schedule_reports``

Estructura de la spec
=====================

.. toctree::
 :maxdepth: 1
 :caption: Las 12 partes

 informacion-general
 actores-precondiciones
 flujo-principal
 flujos-alternos
 excepciones
 requisitos-no-funcionales
 datos-involucrados
 diagramas-uml
 criterios-aceptacion
 patrones-diseno
 implementacion-tecnica
 testing
