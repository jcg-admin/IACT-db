.. meta::
 :artefacto: UC_AUTH_02
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/auth
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-003, CNST-004, CNST-009, CNST-013, CNST-025

.. _uc-auth-02:

==========================
UC_AUTH_02 — Cerrar Sesion
==========================

.. note::

 **Especificacion completa de 12 partes.**
 Producida por el WP
 ``2026-05-01-07-17-48-uc-auth-02-spec-completa``.
 Reemplaza el monolitico
 ``uc-auth-02/index.rst`` v4.0.0
 (eliminado).

Resumen
=======

UC_AUTH_02 permite a un ``User`` autenticado
**cerrar voluntariamente** su ``Session`` activa.
A diferencia del cierre involuntario por
CNST-004 (sesion unica) o CNST-005 (timeout), aqui
el usuario acciona deliberadamente la salida.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_AUTH_02
 * - **Nombre**
   - Cerrar Sesion
 * - **Modulo**
   - MOD_Auth
 * - **Criticidad**
   - ALTO (Parte 1.2.2 de la matriz de
     dependencias)
 * - **Complejidad**
   - BAJA (1 dia estimado)
 * - **Actor Principal**
   - Usuario autenticado
 * - **Funcion RBAC**
   - sesion propia (no requiere funcion
     externa)
 * - **Clase de Dominio primaria**
   - ``Session``
 * - **Clases secundarias**
   - ``AuditEvent``

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
  v1.0.0
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
  v5.4.0
- :doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
  v1.0.0
- :doc:`/requisitos/casos-uso/auth/uc-auth-01/index`
  (UC inverso — Iniciar Sesion)

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
