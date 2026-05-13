.. meta::
 :artefacto: UC_RPT_09
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/reports
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-008, CNST-009

.. _uc-rpt-09:

==============================================
UC_RPT_09 — Configurar Filtros
==============================================

Resumen
=======

CRUD de filtros guardados que el User
puede aplicar rapidamente a UC_RPT_03 y
derivados. Filtros viven en perfil del
User.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``manage_own_filters`` (implícita,
     todo User puede gestionar sus
     propios filtros)

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
