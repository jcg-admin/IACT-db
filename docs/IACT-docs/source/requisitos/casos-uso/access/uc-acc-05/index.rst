.. meta::
 :artefacto: UC_ACC_05
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/access
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-005, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-acc-05:

==================================
UC_ACC_05 — Gestionar Reglas SoD
==================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-acc-05/index.rst`` v4.0.0.
 Producida por el WP
 ``2026-05-01-18-29-22-uc-acc-05-spec-completa``.

Resumen
=======

UC_ACC_05 expone la **gestion del catalogo de
reglas SoD** (Separation of Duties) per
BR-007 + CNST-005. Cubre dos sub-operaciones
con RBAC granular distinto (P-15):

- **Lectura** con ``view_separation_rules``:
  listar y ver detalle de reglas SoD.
- **Gestion** con ``manage_separation_rules``:
  crear, modificar, retirar reglas (CRUD).

Las reglas configuradas por este UC son
consumidas por UC_ACC_01 (asignar funciones),
UC_ACC_04 (asignar AGR) y UC_PERM_03 (permisos
excepcionales) al validar SoD write-time.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_ACC_05
 * - **Modulo**
   - MOD_Access
 * - **Criticidad**
   - CRITICA (afecta enforcement de SoD en
     todo el sistema)
 * - **Complejidad**
   - ALTA
 * - **Actor Principal**
   - User con funcion
     ``view_separation_rules`` (lectura) y/o
     ``manage_separation_rules`` (CRUD)
 * - **Funciones RBAC**
   - ``view_separation_rules``,
     ``manage_separation_rules``
 * - **BReq satisfecho**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-ACC-005

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/reglas-negocio/br-007-separacion-funciones-sod`
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
  (consume las reglas en write-time)
- :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
  (consume las reglas)

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
