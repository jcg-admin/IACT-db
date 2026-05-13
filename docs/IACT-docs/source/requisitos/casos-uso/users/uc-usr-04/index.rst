.. meta::
 :artefacto: UC_USR_04
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/users
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-usr-04:

==============================
UC_USR_04 — Eliminar Usuario
==============================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza ``uc-usr-04-eliminar-usuario.rst``
 v4.0.0. Producida por el WP
 ``2026-05-01-17-02-53-uc-usr-04-spec-completa``.

Resumen
=======

UC_USR_04 ejecuta la **baja logica** de un User
(``state → ELIMINATED``) per BR-009. NO hay
DELETE fisico — el registro permanece para
trazabilidad historica. Side-effects: cierre de
todas las Sessions activas + revocacion logica
de Assignments + bloqueo de tokens.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_USR_04
 * - **Modulo**
   - MOD_Users
 * - **Criticidad**
   - CRITICA (operacion irreversible
     funcionalmente)
 * - **Complejidad**
   - MEDIA (1.5 dias)
 * - **Actor Principal**
   - User con funcion ``deactivate_users``
     (la dependencia canonica del UC es la
     funcion; AGR-006 user_admin_group la
     contiene como agrupacion de conveniencia).
 * - **Funcion RBAC**
   - ``deactivate_users``
 * - **BReq satisfecho**
   - BReq-004 + BReq-005 (Cumplimiento +
     Integridad/Trazabilidad)
 * - **BRQ legacy**
   - BRQ-USR-003

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/business-requirements/breq-005-integridad-trazabilidad-datos`
- :doc:`/requisitos/reglas-negocio/br-009-bajas-logicas`
- :doc:`/requisitos/casos-uso/users/uc-usr-03/index`
  (modificacion — UCs distintos para cambios
  no-destructivos)

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
