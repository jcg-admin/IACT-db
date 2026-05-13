.. meta::
 :artefacto: UC_AUD_03
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/audit
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-001, CNST-002, CNST-008, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-aud-03:

==============================================
UC_AUD_03 — Exportar Auditoria
==============================================

Resumen
=======

Export async de AuditEvents (incluye
archive). Mailbox notify (CNST-002), URL
firmado TTL 24h. Reusa pattern de
UC_PERM_10/UC_RPT_04.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``export_audit``

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
