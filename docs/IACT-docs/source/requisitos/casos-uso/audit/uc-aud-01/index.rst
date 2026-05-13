.. meta::
 :artefacto: UC_AUD_01
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/audit
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critica
 :normativa: CNST-008, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-aud-01:

==============================================
UC_AUD_01 — Consultar Auditoria General
==============================================

Resumen
=======

Vista general (timeline) de TODOS los
AuditEvents del sistema (operacionales +
RBAC + transacciones). Para auditores
externos / compliance officers.

.. note:: Diferenciacion con UC_PERM_10

 UC_PERM_10 es vista RBAC-focused (eventos
 de seguridad). UC_AUD_01 es vista global
 (incluye operacionales: cambios de schedule,
 retries de pipeline, etc.).

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``view_general_audit``

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
