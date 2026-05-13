.. meta::
 :artefacto: UC_PERM_01
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

.. _uc-perm-01:

==========================================
UC_PERM_01 — Asignar Grupo a Usuario
==========================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-perm-01/index.rst``
 v4.0.0. Producida por el WP
 ``2026-05-01-18-50-27-uc-perm-01-spec-completa``.

.. important::

 **Vista alternativa**: UC_PERM_01 cubre el
 mismo flujo que :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
 (``assign_function_groups``) pero desde la
 vista RBAC del modulo Permissions. Coexistencia
 documentada en
 :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`.

Resumen
=======

UC_PERM_01 expone la asignacion de un AGR a un
User desde la perspectiva del catalogo de
permisos. La operacion subyacente es identica a
UC_ACC_04 — comparten ``assign_function_groups``,
contratos, validaciones SoD, transaccion atomica.
La spec aqui se enfoca en:

- Vocabulario PERM (catalogo de permisos,
  asignacion de grupo).
- Diferencias de UI/UX para la audiencia de
  permisos (admins de seguridad, compliance
  officers).
- Trazabilidad cruzada con UC_ACC_04 backing.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_01
 * - **Modulo**
   - MOD_Permissions (vista RBAC)
 * - **UC backing**
   - UC_ACC_04 (vista funcional)
 * - **Funcion RBAC**
   - ``assign_function_groups`` (compartida
     con UC_ACC_04)
 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad
 * - **Origen legacy**
   - PRIORIDAD_01 (Estructura Base RBAC) +
     RNF-002 (Control granular)

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
  (UC backing — implementacion compartida)
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
