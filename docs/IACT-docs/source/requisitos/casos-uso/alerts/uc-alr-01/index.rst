.. meta::
 :artefacto: UC_ALR_01
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

.. _uc-alr-01:

==============================================
UC_ALR_01 — Configurar Umbrales de Alertas
==============================================

Resumen
=======

CRUD de definiciones de alertas: que metrica
+ umbral + ventana + accion. Las alertas
configuradas son evaluadas por un evaluador
async (UC_ALR_02 backend).

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``manage_alert_thresholds``

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
