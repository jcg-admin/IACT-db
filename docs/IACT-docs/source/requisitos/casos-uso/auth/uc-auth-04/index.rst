.. meta::
 :artefacto: UC_AUTH_04
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/auth
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-003, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-auth-04:

================================
UC_AUTH_04 — Cambiar Contrasena
================================

.. note::

 **Especificacion completa de 12 partes.**
 Producida por el WP
 ``2026-05-01-07-52-23-uc-auth-04-spec-completa``.
 Reemplaza el monolitico
 ``uc-auth-04/index.rst`` v4.0.0.

Resumen
=======

UC_AUTH_04 permite a un ``User`` autenticado
**cambiar su propia contrasena**. Es voluntario
en el caso general; es **obligatorio** cuando
``User.first_login = true`` (post UC_USR_01 o
post UC_AUTH_03) o cuando la contrasena ha
expirado por politica.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_AUTH_04
 * - **Nombre**
   - Cambiar Contrasena
 * - **Modulo**
   - MOD_Auth
 * - **Criticidad**
   - ALTA
 * - **Complejidad**
   - MEDIA (1.5 dias)
 * - **Actor Principal**
   - User autenticado (sobre su propia cuenta)
 * - **Funcion RBAC**
   - sesion propia (no requiere AGR especifico)
 * - **Clase de Dominio primaria**
   - ``User``
 * - **Clases secundarias**
   - ``PasswordHistory``, ``Session``,
     ``AuditEvent``

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
  v1.0.0
- :doc:`/requisitos/casos-uso/auth/uc-auth-01/index`
- :doc:`/requisitos/casos-uso/auth/uc-auth-03/index`
  (admin reset que dispara este UC)

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
