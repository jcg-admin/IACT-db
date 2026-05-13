.. meta::
 :artefacto: UC_ACC_09
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/access
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-acc-09:

==================================
UC_ACC_09 — Auditar Cambios Acceso
==================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-acc-09-auditar-cambios-acceso.rst``
 v4.0.0. Producida por el WP
 ``2026-05-01-18-44-50-uc-acc-09-spec-completa``.

Resumen
=======

UC_ACC_09 expone una **vista especializada
de auditoria** focalizada en eventos de
MOD_Access: asignaciones, revocaciones,
cambios SoD, permisos excepcionales. Es la
puerta de entrada de auditores y compliance
officers al historial RBAC. Subset de
UC_AUD_* (audit general) con filtros y
agregaciones especificas del modulo.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_ACC_09
 * - **Modulo**
   - MOD_Access
 * - **Criticidad**
   - ALTA
 * - **Complejidad**
   - MEDIA
 * - **Actor Principal**
   - User con funcion ``view_access_audit``
 * - **Funcion RBAC**
   - ``view_access_audit``
 * - **BReq satisfecho**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-ACC-009

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
- :doc:`/requisitos/casos-uso/access/uc-acc-02/index`
- :doc:`/requisitos/casos-uso/access/uc-acc-03/index`
- :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
- :doc:`/requisitos/casos-uso/access/uc-acc-05/index`
- :doc:`/requisitos/casos-uso/access/uc-acc-08/index`

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
