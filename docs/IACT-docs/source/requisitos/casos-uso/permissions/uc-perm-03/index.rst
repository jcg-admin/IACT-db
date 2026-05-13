.. meta::
 :artefacto: UC_PERM_03
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/permissions
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-005, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-perm-03:

==============================================
UC_PERM_03 — Conceder Permiso Excepcional
==============================================

.. note::

 Reemplaza
 ``uc-perm-03-conceder-permiso-excepcional.rst``
 v4.0.0.

.. important::

 Vista alternativa de
 :doc:`/requisitos/casos-uso/access/uc-acc-08/index`.
 Coexistencia ACC↔PERM.

Resumen
=======

UC_PERM_03 expone otorgamiento de permisos
excepcionales temporales desde la vista PERM
del catalogo de funciones. Backing UC_ACC_08
con politica reforzada (justification +
expires_at obligatorios + Mailbox-or-abort
hard).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_03
 * - **Modulo**
   - MOD_Permissions
 * - **UC backing**
   - UC_ACC_08
 * - **Funcion RBAC**
   - ``grant_exceptional_permission``
 * - **BReq satisfecho**
   - BReq-004

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/access/uc-acc-08/index`
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`

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
