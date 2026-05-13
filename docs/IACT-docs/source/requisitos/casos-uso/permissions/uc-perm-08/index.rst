.. meta::
 :artefacto: UC_PERM_08
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/permissions
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-008, CNST-009, CNST-013

.. _uc-perm-08:

==============================================
UC_PERM_08 — Generar Menu Dinamico
==============================================

Resumen
=======

UC_PERM_08 construye la **estructura de
navegacion** que el frontend renderiza para
el User autenticado. Basada en el
``effective_set`` del User (UC_PERM_07 en
modo bulk) y agrupada por dominio /
seccion / accion.

Es el **filtro de superficie**: el User
nunca ve opciones para las que no tiene
permiso. Pero el filtro NO es seguridad —
la seguridad esta en cada endpoint
(UC_PERM_07 en cada decorator). El menu es
UX.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_08
 * - **Modulo**
   - MOD_Permissions / Frontend support
 * - **Funcion RBAC**
   - **Implícita**: ``view_own_navigation``
     (auto-otorgada al autenticarse — todo
     User ve su propio menu)
 * - **BReq satisfecho**
   - BReq-001 (visibilidad metricas) +
     BReq-007 (operacion)

.. note:: El menu NO sustituye a la
 verificacion de cada accion (UC_PERM_07).

Documentos vinculados
=====================

- :doc:`/requisitos/casos-uso/permissions/uc-perm-07/index`
- :doc:`/requisitos/business-requirements/breq-001-visibilidad-metricas`

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
