.. meta::
 :artefacto: UC_AUTH_03
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/auth
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-001, CNST-002, CNST-009, CNST-013, CNST-025

.. _uc-auth-03:

==================================
UC_AUTH_03 — Recuperar Contrasena
==================================

.. note::

 **Especificacion completa de 12 partes.**
 Producida por el WP
 ``2026-05-01-07-43-53-uc-auth-03-spec-completa``.
 Reemplaza el monolitico
 ``uc-auth-03-recuperar-contrasena.rst`` v4.0.0.

Resumen
=======

UC_AUTH_03 permite a un administrador con
``AGR-006 user_admin_group`` resetear la
contrasena de un ``User`` que la olvido. La
nueva contrasena temporal se entrega
**exclusivamente** a traves del
``InternalMailbox`` del usuario (CNST-001 y
CNST-002 prohiben canales externos).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_AUTH_03
 * - **Nombre**
   - Recuperar Contrasena
 * - **Modulo**
   - MOD_Auth
 * - **Criticidad**
   - ALTA
 * - **Complejidad**
   - MEDIA (2 dias estimados)
 * - **Actor Principal**
   - AGR-006 user_admin_group (admin)
 * - **Actor afectado**
   - ``User`` cuyo password se resetea
 * - **Funcion RBAC**
   - ``reset_password``
 * - **Clase de Dominio primaria**
   - ``User``
 * - **Clases secundarias**
   - ``InternalMailbox``, ``Session``,
     ``AuditEvent``

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
  v1.0.0
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
  v5.4.0 (AGR-006)
- :doc:`/requisitos/casos-uso/auth/uc-auth-01/index`
  (login con first_login)
- :doc:`/requisitos/casos-uso/auth/uc-auth-04/index`
  (cambio voluntario)

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
