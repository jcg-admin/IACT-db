.. meta::
 :artefacto: UC_PIP_04
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/pipeline
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-009, CNST-013, CNST-025

.. _uc-pip-04:

==============================================
UC_PIP_04 — Solicitar Reintento de Pipeline
==============================================

Resumen
=======

Re-encolar un pipeline failed para nueva
ejecucion. Audit reforzado (operacional
sensitivo).

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``request_pipeline_retry``

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
