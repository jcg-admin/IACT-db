.. meta::
 :artefacto: UC_ACC_02
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

.. _uc-acc-02:

==================================
UC_ACC_02 — Revocar Funciones
==================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-acc-02/index.rst`` v4.0.0.
 Producida por el WP
 ``2026-05-01-18-07-06-uc-acc-02-spec-completa``.

Resumen
=======

UC_ACC_02 es la **operacion inversa** de
UC_ACC_01. Permite a un User con funcion
``revoke_functions`` quitar funciones
previamente asignadas a un User destino,
transicionando los Assignments correspondientes
de ``ACTIVE`` a ``REVOKED`` (P-23 soft-delete:
historial preservado).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_ACC_02
 * - **Modulo**
   - MOD_Access
 * - **Criticidad**
   - CRITICA (cambia capacidades del User)
 * - **Complejidad**
   - MEDIA-ALTA (1.5 dias)
 * - **Actor Principal**
   - User con funcion ``revoke_functions``
     (la dependencia canonica del UC es la
     funcion; AGR-006 user_admin_group la
     contiene como agrupacion de conveniencia
     pero NO es requisito).
 * - **Funcion RBAC**
   - ``revoke_functions``
 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad
 * - **BRQ legacy**
   - BRQ-ACC-002

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/reglas-negocio/br-009-bajas-logicas`
- :doc:`/requisitos/casos-uso/access/uc-acc-01/index`
  (operacion inversa)
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
