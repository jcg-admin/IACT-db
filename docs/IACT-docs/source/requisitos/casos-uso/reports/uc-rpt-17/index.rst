.. meta::
 :artefacto: UC_RPT_17
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/reports
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-007, CNST-008, CNST-009, CNST-026

.. _uc-rpt-17:

==============================================
UC_RPT_17 — Reporte de Clientes Unicos
==============================================

Resumen
=======

Conteo de clientes unicos (distinct
callers) en periodo, recurrencia, primer
contacto vs recurrentes. Identifica via
identificador hasheado del cliente
(CNST-026 sin PII).

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``view_unique_clients_reports``

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
