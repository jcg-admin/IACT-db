.. meta::
 :artefacto: UC_AUD_04
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/audit
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critica
 :normativa: CNST-001, CNST-002, CNST-008, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-aud-04:

==============================================
UC_AUD_04 — Generar Reporte de Compliance
==============================================

Resumen
=======

Reporte estructurado de compliance: usuarios
con accesos privilegiados, cambios de
permisos, login failures, accesos a datos
sensibles. Genera PDF/CSV firmado.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``generate_compliance_report``

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
