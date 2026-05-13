.. meta::
 :artefacto: UC_ALR_03
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/alerts
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-008, CNST-009, CNST-013, CNST-025

.. _uc-alr-03:

==============================================
UC_ALR_03 — Reconocer Alerta
==============================================

Resumen
=======

Acknowledge de una alerta firing → estado
``acknowledged``. Documenta quien y cuando.
Opcionalmente con nota.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``acknowledge_alerts``

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
