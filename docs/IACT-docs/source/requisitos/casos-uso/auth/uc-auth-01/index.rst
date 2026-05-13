.. meta::
 :artefacto: UC_AUTH_01
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/auth
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critico
 :normativa: CNST-001, CNST-002, CNST-003, CNST-004, CNST-005, CNST-009, CNST-011, CNST-013, CNST-025

.. _uc-auth-01:

===========================
UC_AUTH_01 — Iniciar Sesion
===========================

.. note::

 **Especificacion completa de 12 partes.**
 Producida por el WP
 ``2026-05-01-07-00-34-uc-auth-01-spec-completa``
 en cumplimiento de la directiva del ejecutor
 (2026-05-01) — los 61 UCs adoptan estructura
 de 12 partes en archivos separados.

 Reemplaza al monolitico ``uc-auth-01/index.rst``
 v4.0.0 (eliminado).

Resumen
=======

UC_AUTH_01 es el caso de uso **CRITICO** de
entrada universal al sistema IACT. Permite a un
usuario registrado autenticarse con sus
credenciales (username + password), produciendo
una ``Session`` activa que habilita el resto de
los UCs operativos del catalogo (59 de 61
dependen de esta sesion via T-01).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_AUTH_01
 * - **Nombre**
   - Iniciar Sesion
 * - **Modulo**
   - MOD_Auth
 * - **Criticidad**
   - CRITICO (Parte 1 de la matriz de dependencias)
 * - **Complejidad**
   - MEDIA (5 dias estimados)
 * - **Actor Principal**
   - Usuario (cualquier registrado)
 * - **Funcion RBAC**
   - publica (post-login establece AUTH-001 ``view_own_sessions``)
 * - **Clase de Dominio primaria**
   - ``Session``
 * - **Clases secundarias**
   - ``User``, ``InternalMailbox``, ``AuditEvent``

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
  v1.0.0 — clases ``User``, ``Session``,
  ``InternalMailbox``, ``AuditEvent``.
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
  v5.4.0 — funciones AUTH-001..004.
- :doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
  v1.0.0 — criticidad, transversales T-01/02/03,
  patrones de diseno aplicables.

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
