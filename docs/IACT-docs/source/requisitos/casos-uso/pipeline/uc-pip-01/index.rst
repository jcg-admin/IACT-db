.. meta::
 :artefacto: UC_PIP_01
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/pipeline
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-007, CNST-009, CNST-013

.. _uc-pip-01:

==============================================
UC_PIP_01 — Supervisar ETL
==============================================

Resumen
=======

Vista de salud del pipeline ETL: jobs en
ejecucion / completados / fallados, lag de
datos, throughput. Para detectar
problemas de freshness en Analytics.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``view_etl_supervision``

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
