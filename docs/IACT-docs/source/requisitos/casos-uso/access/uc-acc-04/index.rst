.. meta::
 :artefacto: UC_ACC_04
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

.. _uc-acc-04:

==================================
UC_ACC_04 — Asignar Agrupador
==================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-acc-04/index.rst`` v4.0.0.
 Producida por el WP
 ``2026-05-01-18-22-43-uc-acc-04-spec-completa``.

Resumen
=======

UC_ACC_04 permite a un User con funcion
``assign_function_groups`` asignar un
``AccessGroup`` (AGR) completo a un User
destino — que efectivamente otorga TODAS las
funciones que el AGR contiene de una sola vez.
Es la version masiva de UC_ACC_01.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_ACC_04
 * - **Modulo**
   - MOD_Access
 * - **Criticidad**
   - CRITICA
 * - **Complejidad**
   - MEDIA
 * - **Actor Principal**
   - User con funcion
     ``assign_function_groups``
 * - **Funcion RBAC**
   - ``assign_function_groups``
 * - **BReq satisfecho**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-ACC-004

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
  (asignacion granular individual)
- :doc:`/requisitos/casos-uso/access/uc-acc-02/index`
  (revocacion granular)
- :doc:`/requisitos/casos-uso/access/uc-acc-03/index`
  (consultar permisos efectivos)
- :doc:`/requisitos/casos-uso/access/uc-acc-05/index`

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
