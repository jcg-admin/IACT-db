.. meta::
 :artefacto: UC_USR_03
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

.. _uc-usr-03:

==============================
UC_USR_03 — Modificar Usuario
==============================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza ``uc-usr-03-modificar-usuario.rst``
 v4.0.0. Producida por el WP
 ``2026-05-01-16-54-27-uc-usr-03-spec-completa``.

Resumen
=======

UC_USR_03 permite a un admin con
``modify_users`` actualizar atributos no-secretos
de un User existente (datos personales, state,
segmento operacional). Cambios de contrasena
son UC_AUTH_03 (admin reset) o UC_AUTH_04
(propio User). Cambios de RBAC son UC_ACC_*.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_USR_03
 * - **Modulo**
   - MOD_Users
 * - **Criticidad**
   - ALTA
 * - **Complejidad**
   - MEDIA (1.5 dias)
 * - **Actor Principal**
   - AGR-006 user_admin_group
 * - **Funcion RBAC**
   - ``modify_users``
 * - **BReq satisfecho**
   - BReq-004 (Cumplimiento Seguridad)
 * - **BRQ legacy**
   - BRQ-USR-002

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/users/uc-usr-01/index`
- :doc:`/requisitos/casos-uso/auth/uc-auth-03/index`
  (cambio de contrasena admin — alternativa
  para credenciales)
- :doc:`/requisitos/casos-uso/auth/uc-auth-05/index`
  (cierre de sesiones tras bloqueo)

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
