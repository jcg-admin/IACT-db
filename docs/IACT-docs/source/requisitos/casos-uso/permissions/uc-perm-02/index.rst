.. meta::
 :artefacto: UC_PERM_02
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

.. _uc-perm-02:

==========================================
UC_PERM_02 — Revocar Grupo a Usuario
==========================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-perm-02-revocar-grupo-a-usuario.rst``
 v4.0.0.

.. important::

 **Vista alternativa**: cubre el mismo flujo
 que :doc:`/requisitos/casos-uso/access/uc-acc-02/index`
 sobre Assignment con target_type='AccessGroup'.
 Coexistencia ACC↔PERM (ADR-GOB-008).

Resumen
=======

UC_PERM_02 expone la revocacion de un AGR
asignado desde la vista del catalogo de
permisos. Backing: UC_ACC_02 con scope sobre
Assignments AGR. Mismo backend, diferente UI.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_02
 * - **Modulo**
   - MOD_Permissions
 * - **UC backing**
   - UC_ACC_02 (sobre Assignment AGR)
 * - **Funcion RBAC**
   - ``revoke_function_groups``
 * - **BReq satisfecho**
   - BReq-004
 * - **Origen legacy**
   - PRIORIDAD_01 + RNF-002

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/access/uc-acc-02/index`
- :doc:`/requisitos/casos-uso/permissions/uc-perm-01/index`
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
