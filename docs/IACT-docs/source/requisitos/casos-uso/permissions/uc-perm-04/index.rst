.. meta::
 :artefacto: UC_PERM_04
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

.. _uc-perm-04:

==============================================
UC_PERM_04 — Revocar Permiso Excepcional
==============================================

.. note::

 Reemplaza
 ``uc-perm-04-revocar-permiso-excepcional.rst``
 v4.0.0.

Resumen
=======

UC_PERM_04 permite revocar explicitamente un
``ExceptionalPermission`` antes de su
expiracion natural. Casos: emergencia
resuelta antes del expires_at, deteccion de
abuso, cambio de criterio.

Diferencia con expiracion automatica (cron):

- Cron: state ACTIVE → EXPIRED por
  ``NOW > expires_at``.
- UC_PERM_04: state ACTIVE → REVOKED
  explicito por admin (con razon obligatoria).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_04
 * - **Modulo**
   - MOD_Permissions
 * - **Funcion RBAC**
   - ``revoke_exceptional_permission``
 * - **BReq satisfecho**
   - BReq-004

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/permissions/uc-perm-03/index`
  (operacion inversa)
- :doc:`/requisitos/casos-uso/access/uc-acc-08/index`
  (UC backing del grant)

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
