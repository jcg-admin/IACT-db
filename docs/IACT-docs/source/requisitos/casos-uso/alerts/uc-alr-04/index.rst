.. meta::
 :artefacto: UC_ALR_04
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

.. _uc-alr-04:

==============================================
UC_ALR_04 — Ver Historial de Alertas
==============================================

Resumen
=======

List paginado de alertas closed/resolved
con filtros (rango, regla, severity).
Incluye time-to-ack, time-to-resolve.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``view_alert_history``

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
