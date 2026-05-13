.. meta::
 :artefacto: UC_ACC_03
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

.. _uc-acc-03:

==========================================
UC_ACC_03 — Consultar Permisos Efectivos
==========================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-acc-03/index.rst`` v4.0.0.
 Producida por el WP
 ``2026-05-01-18-15-47-uc-acc-03-spec-completa``.

Resumen
=======

UC_ACC_03 expone una vista consolidada de los
**permisos efectivos** de un User: funciones
asignadas directamente + funciones heredadas
de los AGRs activos + permisos excepcionales
(UC_PERM_03). El UC sirve para auditoria,
diagnostico y compliance.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_ACC_03
 * - **Modulo**
   - MOD_Access
 * - **Criticidad**
   - MEDIA
 * - **Complejidad**
   - MEDIA (1 dia — query consolidacion)
 * - **Actor Principal**
   - User con funcion ``view_assignments``
     (la dependencia canonica del UC es la
     funcion; AGR-006 y AGR-008 la contienen
     en el catalogo predefinido).
 * - **Funcion RBAC**
   - ``view_assignments``
 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad
 * - **BRQ legacy**
   - BRQ-ACC-003

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
- :doc:`/requisitos/casos-uso/access/uc-acc-02/index`
- :doc:`/requisitos/casos-uso/access/uc-acc-04/index`

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
