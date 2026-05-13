.. meta::
 :artefacto: UC_USR_01
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/users
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-001, CNST-002, CNST-009, CNST-013, CNST-025, CNST-026, CNST-029

.. _uc-usr-01:

==========================
UC_USR_01 — Crear Usuario
==========================

.. note::

 **Especificacion completa de 12 partes.**
 Producida por el WP
 ``2026-05-01-16-36-56-uc-usr-01-spec-completa``.
 Reemplaza el monolitico
 ``uc-usr-01/index.rst`` v4.0.0.

Resumen
=======

UC_USR_01 permite a un administrador con
``AGR-006 user_admin_group`` **crear una nueva
cuenta de usuario** en el sistema. El usuario
nace con ``first_login=true``, recibe la
contrasena temporal en su ``InternalMailbox``
(CNST-001 prohibe canales externos) y al primer
login es forzado a UC_AUTH_04 para cambiar la
contrasena.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_USR_01
 * - **Nombre**
   - Crear Usuario
 * - **Modulo**
   - MOD_Users
 * - **Criticidad**
   - ALTA
 * - **Complejidad**
   - MEDIA (1.5 dias)
 * - **Actor Principal**
   - AGR-006 user_admin_group
 * - **Funcion RBAC**
   - ``create_users``
 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad y Auditoria
 * - **BRQ legacy**
   - BRQ-USR-001 (mapeado per index BReq)
 * - **Clase de Dominio primaria**
   - ``User``
 * - **Clases secundarias**
   - ``Assignment``, ``AccessGroup``,
     ``InternalMailbox``, ``AuditEvent``

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/auth/uc-auth-01/index`
  (login que detectara first_login)
- :doc:`/requisitos/casos-uso/auth/uc-auth-04/index`
  (cambio obligatorio post first_login)
- :doc:`/requisitos/casos-uso/auth/uc-auth-03/index`
  (UC analogo: admin reset)

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
