.. meta::
 :artefacto: UC_PIP_02
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

.. _uc-pip-02:

==============================================
UC_PIP_02 — Consultar Errores ETL
==============================================

Resumen
=======

List de errores en pipeline runs con
detalle: stack, payload sample,
correlation id.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``view_etl_errors``

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
