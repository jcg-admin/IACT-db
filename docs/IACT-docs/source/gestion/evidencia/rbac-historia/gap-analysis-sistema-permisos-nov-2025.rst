.. meta::
 :artefacto: HIST_RBAC_004
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2025-11-09
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-004:

============================================================
Gap Analysis — Sistema de Permisos Granular (Noviembre 2025)
============================================================

.. note::

 **Documento historico — Gap Analysis (BABOK ba-strategy output).**

 Resumen del gap analysis formal del Sistema de Permisos Granular
 realizado en noviembre 2025. Estado reportado: 75% completado.
 NO es spec vigente. Para spec vigente ver
 :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (v5.2.1) +
 :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`.

----

1. Contexto
===========

**Fecha original:** 2025-11-09.
**Owner original:** Equipo Backend.
**Prioridad:** Alta.
**Estado reportado:** 75% completado.

**Proposito original:** documentar las brechas entre el sistema
de permisos implementado (parcialmente) y el sistema completo
production-ready esperado.

**Cierre historico:** los gaps identificados se atendieron
parcialmente; el modelo evoluciono a v5.2.1 (enero 2026) con
recalibracion completa del catalogo (42 funciones + 10 grupos).

----

2. Estado al 75% (lo implementado)
==================================

2.1 Base de Datos (100%)
------------------------

- 8 modelos Django (``models_permisos_granular.py``):

  - ``Funcion``, ``Capacidad``, ``FuncionCapacidad``
  - ``GrupoPermiso``, ``GrupoCapacidad``
  - ``UsuarioGrupo``, ``PermisoExcepcional``
  - ``AuditoriaPermiso``

- 2 vistas SQL optimizadas:

  - ``vista_capacidades_usuario``
  - ``vista_grupos_usuario``

- 5 funciones SQL nativas (PostgreSQL):

  - ``usuario_tiene_permiso()``
  - ``obtener_capacidades_usuario()``
  - ``obtener_grupos_usuario()``
  - ``verificar_permiso_y_auditar()``
  - ``obtener_menu_usuario()``

- 3 migraciones Django:

  - ``0001_initial_permisos_granular.py``
  - ``0002_create_permission_views.py``
  - ``0003_create_permission_functions.py``

- Indices optimizados para queries frecuentes.

2.2 Service Layer (100%)
------------------------

``UserManagementService`` con 6 metodos:

- ``usuario_tiene_permiso()``
- ``asignar_grupo_a_usuario()``
- ``revocar_grupo_de_usuario()``
- ``obtener_capacidades_de_usuario()``
- ``otorgar_permiso_excepcional()``
- ``obtener_grupos_de_usuario()``

Validaciones de negocio + auditoria integrada.

2.3 REST API (100%)
-------------------

Endpoints CRUD para gestion de permisos via DRF.

2.4 Tests (80%)
---------------

Cobertura unitaria + integracion. Faltaban tests E2E completos.

2.5 Documentacion (70%)
-----------------------

ADRs basicos + docstrings. Faltaban UCs formales y diagramas UML.

----

3. Brechas identificadas (10 gaps)
==================================

.. list-table::
 :header-rows: 1
 :widths: 8 38 18 36

 * - #
   - Brecha
   - Prioridad
   - Estado vigente
 * - 2.1
   - Documentacion de Casos de Uso
   - CRITICA
   - **Cerrado** — UC_PERM_01..10 + UC_ACC_01..09 publicados
 * - 2.2
   - Diagramas UML
   - CRITICA
   - Parcial — diagramas en plantuml-guide/
 * - 2.3
   - OpenAPI/Swagger Specification
   - ALTA
   - Diferido (codigo no implementado)
 * - 2.4
   - Decorators y Middleware
   - ALTA
   - Diferido (ver ADR-BACK-005 middleware preservado)
 * - 2.5
   - Django Management Commands
   - MEDIA
   - Diferido (codigo no implementado)
 * - 2.6
   - Script de Seed/Inicializacion
   - ALTA
   - Diferido (codigo no implementado)
 * - 2.7
   - Documentacion de Integracion Frontend
   - ALTA
   - Diferido (frontend no implementado)
 * - 2.8
   - Tests Adicionales
   - MEDIA
   - Diferido
 * - 2.9
   - Django Admin Integration
   - MEDIA
   - Diferido
 * - 2.10
   - Monitoring y Metricas
   - BAJA
   - Diferido

----

4. Vocabulario divergente — anotacion historica
===============================================

El gap analysis usa el vocabulario legacy:

- "Capacidad" / ``Capacidad`` (modelo Django).
- "GrupoPermiso" / ``GrupoPermiso``.
- "UsuarioGrupo" / ``UsuarioGrupo``.

Vocabulario vigente (CNST-033 enforced):

- "Funcion" / ``Function`` (D-RBAC-1).
- "FunctionGroup".
- "UserFunctionAssignment".

La migracion semantica esta documentada en
:doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
(D-RBAC-8: migracion ``Capacidad`` -> ``Function``).

----

5. Plan de accion original (sprints noviembre 2025)
===================================================

Sprint 1 (Semana 1) — BLOCKERS + CRITICO:

- Documentacion UCs, diagramas UML.

Sprint 2 (Semana 2) — ALTA PRIORIDAD:

- OpenAPI/Swagger, decorators/middleware, scripts seed,
  documentacion frontend.

Sprint 3 (Semana 3) — MEDIA/BAJA:

- Tests adicionales, Django Admin, monitoring.

**Estado real:** plan parcialmente ejecutado; el corpus IACT-docs
posterior (enero 2026 -> abril 2026) recalibro el modelo y la
documentacion en spec-only (sin implementacion).

----

6. Cierre y trazabilidad
========================

**Documento original:**
``temp-holding/FASE 01/docs/gobernanza/sesiones/analisis_nov_2025/GAP_ANALYSIS_SISTEMA_PERMISOS.rst``
(no publicado).

**Estado actual del proyecto:** spec abstracta sin
implementacion. El gap analysis aplicaba a una iteracion de
implementacion previa que no continuo. La documentacion vigente
en source/ es una recalibracion completa para guiar la futura
implementacion.

**Documentos vigentes que reemplazan al gap analysis:**

- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (modelo).
- :doc:`/requisitos/casos-uso/permissions/index` (UCs).
- :doc:`/requisitos/casos-uso/access/index` (UCs ACC).
- :doc:`/requisitos/casos-uso/audit/index` (UCs AUD).
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
  (decision de coexistencia ACC + PERM).
