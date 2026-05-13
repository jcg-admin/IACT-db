.. meta::
 :artefacto: UC_ALR_02
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/alerts
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-008, CNST-009, CNST-013

.. _uc-alr-02:

==============================================
UC_ALR_02 — Ver Alertas Activas
==============================================

Resumen
=======

Vista de alertas en estado ``firing`` o
``acknowledged`` (no closed). Tiempo real
con auto-refresh; soporta filtros por
severidad, scope, regla.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``view_active_alerts``

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
