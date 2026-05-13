.. meta::
 :artefacto: UC_PERM_06
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

.. _uc-perm-06:

==============================================
UC_PERM_06 — Asignar Funciones a Grupo
==============================================

Resumen
=======

UC_PERM_06 maneja la **composicion** de un
AccessGroup: agregar funciones al AGR, quitar
funciones, ajustar membresia. Operacion
critica — cualquier cambio afecta el
``effective_set`` de TODOS los Users que
tengan ese AGR ACTIVE (cascade documentada).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_06
 * - **Modulo**
   - MOD_Permissions
 * - **Funcion RBAC**
   - ``manage_access_group_composition``
 * - **BReq satisfecho**
   - BReq-004

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/permissions/uc-perm-05/index`
  (creacion del AGR — esta es composicion)

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
