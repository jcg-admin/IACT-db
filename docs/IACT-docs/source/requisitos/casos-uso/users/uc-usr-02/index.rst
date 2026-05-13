.. meta::
 :artefacto: UC_USR_02
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

.. _uc-usr-02:

==================================
UC_USR_02 — Consultar Usuarios
==================================

.. note::

 **Especificacion completa de 12 partes.**
 Producida por el WP
 ``2026-05-01-16-48-17-uc-usr-02-spec-completa``.
 Reemplaza el monolitico
 ``uc-usr-02-consultar-usuarios.rst`` v4.0.0.

Resumen
=======

UC_USR_02 permite a un User con funciones RBAC
``list_users`` y/o ``view_users`` listar y consultar
detalle de los Users del sistema. Es la operacion de
lectura del cluster USR. RBAC granular: ``list_users``
para lista; ``view_users`` para detalle (dos funciones
distintas para minimizar privilegios).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_USR_02
 * - **Nombre**
   - Consultar Usuarios
 * - **Modulo**
   - MOD_Users
 * - **Criticidad**
   - MEDIA
 * - **Complejidad**
   - BAJA-MEDIA (1 dia)
 * - **Actor Principal**
   - User con AGR-006 (admin) o AGR-008 (auditor)
 * - **Funciones RBAC**
   - ``list_users``, ``view_users``
 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad y Auditoria
 * - **BRQ legacy**
   - BRQ-USR-009 (mapeado per index BReq)
 * - **Clase de Dominio primaria**
   - ``User``
 * - **Clases secundarias**
   - ``Assignment``, ``AccessGroup`` (lectura)

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/users/uc-usr-01/index`
  (UC creador)
- :doc:`/requisitos/casos-uso/auth/uc-auth-05/index`
  (UC analogo: gestionar sesiones — patron similar
  de listado + detalle + RBAC granular)

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
