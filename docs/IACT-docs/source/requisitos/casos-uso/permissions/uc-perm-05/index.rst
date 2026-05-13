.. meta::
 :artefacto: UC_PERM_05
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/permissions
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-perm-05:

==============================================
UC_PERM_05 — Crear Grupo de Permisos
==============================================

Resumen
=======

UC_PERM_05 expone la **gestion del catalogo de
AccessGroups custom**: crear, modificar, retirar
AGRs. Los AGRs predefinidos AGR-001..010 NO se
modifican via este UC (son inmutables; politica
documentada en
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_05
 * - **Modulo**
   - MOD_Permissions
 * - **Funcion RBAC**
   - ``manage_access_groups``
 * - **BReq satisfecho**
   - BReq-004

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/permissions/uc-perm-06/index`
  (gestionar composicion del AGR creado)

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
