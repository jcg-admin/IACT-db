.. meta::
 :artefacto: UC_AUTH_05
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/auth
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-003, CNST-004, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-auth-05:

==================================
UC_AUTH_05 — Gestionar Sesiones
==================================

.. note::

 **Especificacion completa de 12 partes.**
 Producida por el WP
 ``2026-05-01-08-00-00-uc-auth-05-spec-completa``.
 Reemplaza el monolitico
 ``uc-auth-05-gestionar-sesiones.rst`` v4.0.0.

Resumen
=======

UC_AUTH_05 permite a un administrador con
``AGR-006 user_admin_group`` listar las
``Session`` activas del sistema, ver detalle de
una Session especifica, y cerrar Sessions
individuales o todas las del User. Es la
contraparte administrativa de UC_AUTH_02 (cierre
voluntario por el propio User).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_AUTH_05
 * - **Nombre**
   - Gestionar Sesiones
 * - **Modulo**
   - MOD_Auth
 * - **Criticidad**
   - MEDIA
 * - **Complejidad**
   - MEDIA (2 dias)
 * - **Actor Principal**
   - AGR-006 user_admin_group
 * - **Funciones RBAC**
   - ``view_all_active_sessions``,
     ``close_user_session``
 * - **Clase de Dominio primaria**
   - ``Session``
 * - **Clases secundarias**
   - ``BlacklistedToken``, ``AuditEvent``

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
  v1.0.0
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
  v5.4.0
- :doc:`/requisitos/casos-uso/auth/uc-auth-02/index`
  (cierre voluntario)

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
