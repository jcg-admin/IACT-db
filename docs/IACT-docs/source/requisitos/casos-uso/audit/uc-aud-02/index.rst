.. meta::
 :artefacto: UC_AUD_02
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/audit
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-008, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-aud-02:

==============================================
UC_AUD_02 — Buscar Auditoria
==============================================

Resumen
=======

Full-text search sobre AuditEvent (payload
sanitized + event_type + actor). Util para
investigaciones por palabra clave.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``search_audit``

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
