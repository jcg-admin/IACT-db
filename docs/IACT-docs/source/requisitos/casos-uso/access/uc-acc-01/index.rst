.. meta::
 :artefacto: UC_ACC_01
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/access
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-005, CNST-009, CNST-013, CNST-025, CNST-026

.. _uc-acc-01:

==================================
UC_ACC_01 — Asignar Funciones
==================================

.. note::

 **Especificacion completa de 12 partes** —
 reemplaza
 ``uc-acc-01/index.rst`` v4.0.0.
 Producida por el WP
 ``2026-05-01-17-55-31-uc-acc-01-spec-completa``.

Resumen
=======

UC_ACC_01 permite a un User con funcion
``assign_functions`` otorgar una o mas funciones
RBAC a un User destino. Cada asignacion crea un
``Assignment`` con metadata de granted_by y
opcionalmente fecha de expiracion (BR-008,
CNST-005). Validacion de SoD (BR-007 + CNST-005)
es obligatoria antes de aceptar la asignacion.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_ACC_01
 * - **Nombre**
   - Asignar Funciones a Usuario
 * - **Modulo**
   - MOD_Access
 * - **Criticidad**
   - CRITICA (cambia capacidades RBAC del User)
 * - **Complejidad**
   - ALTA (validacion SoD compleja)
 * - **Actor Principal**
   - User con funcion ``assign_functions``
     (la dependencia canonica del UC es la
     funcion; AGR-006 user_admin_group la
     contiene como agrupacion de conveniencia
     pero NO es requisito).
 * - **Funcion RBAC**
   - ``assign_functions``
 * - **BReq satisfecho**
   - BReq-004 (Cumplimiento Seguridad y
     Auditoria)
 * - **BRQ legacy**
   - BRQ-ACC-001 (mapeado per index BReq)
 * - **Clase de Dominio primaria**
   - ``Assignment``
 * - **Clases secundarias**
   - ``User`` (lectura),
     ``Function`` (lectura),
     ``SoDRule`` (lectura, validacion),
     ``AuditEvent``

Documentos vinculados
=====================

- :doc:`/arquitectura-tecnica/modelo-dominio-iact`
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/reglas-negocio/br-007-separacion-funciones-sod`
- :doc:`/requisitos/reglas-negocio/br-008-auditoria-accesos`
- :doc:`/requisitos/casos-uso/access/uc-acc-02/index`
  (operacion inversa)
- :doc:`/requisitos/casos-uso/access/uc-acc-04/index`
  (asignacion masiva via AGR)
- :doc:`/requisitos/casos-uso/access/uc-acc-05/index`
  (configuracion de las reglas SoD)

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
