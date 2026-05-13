.. meta::
 :artefacto: UC_PERM_09
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/permissions
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critica
 :normativa: CNST-013, CNST-025, CNST-026

.. _uc-perm-09:

==============================================
UC_PERM_09 — Auditar Acceso (write side)
==============================================

Resumen
=======

UC_PERM_09 es el **emisor canonico de
AuditEvents** para acciones relacionadas
con autorizacion y RBAC. Es invocado por
todos los UCs que crean / modifican / revocan
permisos (UC_ACC_*, UC_PERM_05/06) y por
acciones sensibles que requieren rastro
(P-39 audit reforzado).

NO audita cada permission check (UC_PERM_07
delega P-51 read-no-audit). Audita **acciones
y eventos de seguridad significativos**.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_09
 * - **Modulo**
   - MOD_Permissions / Auditoria
 * - **Funcion RBAC**
   - **No aplica al WRITE** (servicio
     interno invocado por otros UCs).
     La consulta es UC_PERM_10
     (``view_audit_log``).
 * - **BReq satisfecho**
   - BReq-004 (cumplimiento + auditoria)
 * - **CNST clave**
   - CNST-025 (inmutable),
     CNST-026 (sin PII)

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/permissions/uc-perm-10/index`
  (read side)

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
