.. meta::
 :artefacto: UC_PERM_10
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/permissions
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-008, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-perm-10:

==============================================
UC_PERM_10 — Consultar Auditoria de Permisos
==============================================

Resumen
=======

UC_PERM_10 es la **read side** del sistema de
auditoria. Permite a auditores consultar el
log inmutable de AuditEvents emitido por
UC_PERM_09 con filtros, paginacion, y
agregaciones.

Es de **alto valor para compliance** —
demuestra trazabilidad ante auditorías
externas. La consulta misma es auditada
(meta-audit) por P-44 visibility audit prio.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_10
 * - **Modulo**
   - MOD_Permissions / Auditoria
 * - **Funcion RBAC**
   - ``view_audit_log``
 * - **BReq satisfecho**
   - BReq-004

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/permissions/uc-perm-09/index`
  (write side)

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
