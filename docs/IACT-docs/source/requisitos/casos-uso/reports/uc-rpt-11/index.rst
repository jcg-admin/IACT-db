.. meta::
 :artefacto: UC_RPT_11
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/reports
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-001, CNST-002, CNST-008, CNST-009, CNST-013, CNST-025

.. _uc-rpt-11:

==============================================
UC_RPT_11 — Compartir Reporte
==============================================

Resumen
=======

Compartir una vista guardada (UC_RPT_10)
con otros Users. El receptor puede aplicar
la vista; los datos se filtran por SU
segmento (no el del owner). Notificacion
via mailbox interno (CNST-002).

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``share_reports``

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
