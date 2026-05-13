.. meta::
 :artefacto: UC_ACC_08
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

.. _uc-acc-08:

==================================
UC_ACC_08 — Permiso Temporal
==================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-acc-08-permiso-temporal.rst`` v4.0.0.
 Producida por el WP
 ``2026-05-01-18-38-14-uc-acc-08-spec-completa``.

Resumen
=======

UC_ACC_08 otorga un **permiso excepcional
temporal** (1..N funciones) a un User con
**expires_at obligatorio** (BR-008) y
**justification obligatoria** (auditabilidad
reforzada). Es la via para acceso ad-hoc
(soporte, cobertura de licencia,
emergencias) sin asignar AGRs permanentes.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_ACC_08
 * - **Modulo**
   - MOD_Access
 * - **Criticidad**
   - CRITICA (privilegios elevados temporales)
 * - **Complejidad**
   - MEDIA-ALTA
 * - **Actor Principal**
   - User con funcion
     ``grant_exceptional_permission``
 * - **Funcion RBAC**
   - ``grant_exceptional_permission``
 * - **BReq satisfecho**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-ACC-008

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/reglas-negocio/br-008-auditoria-accesos`
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
  (asignacion estandar)
- :doc:`/requisitos/casos-uso/access/uc-acc-03/index`
  (vista efectiva incluye estos permisos)

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
