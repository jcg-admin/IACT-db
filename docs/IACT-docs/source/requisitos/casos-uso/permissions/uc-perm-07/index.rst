.. meta::
 :artefacto: UC_PERM_07
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/permissions
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critica
 :normativa: CNST-005, CNST-008, CNST-009, CNST-013

.. _uc-perm-07:

==============================================
UC_PERM_07 — Verificar Permiso de Usuario
==============================================

Resumen
=======

UC_PERM_07 es el **servicio core** de
authorization: dado un (User, function_code),
retorna si el User tiene la funcion en su
``effective_set``. Invocado por decorators,
permission classes, middleware y por endpoint
admin de consulta explicita.

Algoritmo: precedencia revocacion > concesion
excepcional > AGR.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_PERM_07
 * - **Modulo**
   - MOD_Permissions (servicio)
 * - **Funcion RBAC (consulta admin)**
   - ``view_assignments``
 * - **BReq satisfecho**
   - BReq-004

.. note:: Servicio interno

 El servicio interno (invocado por decorators)
 NO requiere funcion RBAC — es la primitiva
 sobre la cual se construye RBAC. La consulta
 admin explicita SI requiere
 ``view_assignments``.

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
- :doc:`/requisitos/casos-uso/access/uc-acc-03/index`
  (vista funcional)
- :doc:`/requisitos/casos-uso/permissions/uc-perm-08/index`
  (Generar Menu — usa este UC)

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
