.. meta::
 :artefacto: HIST_RBAC_008
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2025-11-18
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-008:

==============================================================
Diseno de Referencia — Implementacion Permisos Legacy (Code)
==============================================================

.. note::

 **Documento historico — Reference Design (codigo).**

 Narrativa que resume la estructura de los 12 archivos Python
 del legacy ``temp-holding/Modules/`` (sistema de permisos
 implementado en noviembre 2025). NO es codigo vigente del
 proyecto IACT (el proyecto esta en spec-only — sin
 implementacion). Este documento preserva el diseno como
 **referencia para la implementacion futura**.

 Para spec vigente ver
 :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` y
 :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`.

----

1. Contexto
===========

**Fecha original:** 2025-11-18.

12 archivos Python (~165 KB) que implementan un sistema de
permisos granular basado en grupos para call center. Estos
archivos fueron parte de un prototipo de implementacion previo
al rebuild documental de IACT-docs.

**Estado:** legacy preservado para trazabilidad. NO es codigo
del proyecto IACT vigente. La spec vigente para implementacion
futura esta en
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`.

----

2. Inventario de archivos
=========================

.. list-table::
 :header-rows: 1
 :widths: 38 20 42

 * - Archivo
   - Tamano aprox
   - Proposito
 * - ``call_center_privilege_models.py``
   - ~12 KB
   - Modelos Django de privilegios call center (Campaign, User extendido)
 * - ``call_center_privilege_service.py``
   - ~13 KB
   - Service layer para verificacion de privilegios
 * - ``department_privilege_system.py``
   - ~12 KB
   - Sistema de privilegios por departamento
 * - ``module_initial_data.py``
   - ~14 KB
   - Datos seed iniciales (modulos, capacidades, grupos)
 * - ``module_system_admin.py``
   - ~12 KB
   - Django Admin integration para el sistema de modulos
 * - ``module_system_models.py``
   - ~15 KB
   - Modelos Django nucleares (Module, Capability, Group)
 * - ``module_system_permissions.py``
   - ~9 KB
   - DRF permission classes
 * - ``module_system_serializers.py``
   - ~14 KB
   - DRF serializers para API
 * - ``module_system_urls.py``
   - ~1 KB
   - URL routing del sistema de modulos
 * - ``module_system_views.py``
   - ~23 KB
   - Views (CBV/ViewSets) del sistema de modulos
 * - ``privilege_flow_diagram.py``
   - ~11 KB
   - Generador de diagramas de flujo de privilegios
 * - ``updated_main_urls.py``
   - ~3 KB
   - Integracion con urls principales del proyecto

**Total:** ~165 KB de codigo Python. NO importado al corpus
``source/`` (no es spec; es referencia historica).

----

3. Vocabulario legacy del codigo
================================

El codigo usa vocabulario legacy que **NO cumple CNST-033 vigente**:

.. list-table::
 :header-rows: 1
 :widths: 30 30 40

 * - Termino legacy en codigo
   - Termino vigente (CNST-033)
   - Mapeo
 * - ``Capacidad``, ``Capacity``
   - ``Funcion``, ``Function``
   - 1:1
 * - ``CallCenterUser``
   - ``User`` (Django builtin)
   - Eliminar extensiones
 * - ``Campaign``
   - (no aplica)
   - Sub-dominio call center, no parte del modelo IACT generico
 * - ``Module`` (con permisos)
   - ``MOD_*`` en filename
   - Concepto preservado, naming distinto

----

4. Estructura general del diseno legacy
=======================================

::

   USUARIO (CallCenterUser extiende AbstractUser)
     |
     | tiene asignados
     v
   GRUPOS (groups, custom + system)
     |
     | contiene
     v
   CAPACIDADES (capacities)
     |
     | sobre
     v
   MODULOS (modules)
     |
     | contiene
     v
   ACCIONES PERMITIDAS

----

5. Decisiones implementacion legacy
===================================

5.1 Roles tipo organizacional (DESCARTADO)
------------------------------------------

::

   ROLE_CHOICES = [
       ('ANALISTA', 'Analista'),
       ('SUPERVISOR', 'Supervisor'),
       ('GERENTE', 'Gerente'),
       ('ADMIN_IT', 'Administrador IT'),
   ]

**Estado vigente:** rechazado per modelo "Sin Pretensiones" v5.x
y :doc:`/backend/adr-back-001-grupos-funcionales-sin-jerarquia`
(supersedido por adr-gob-009 nuevo en Z.1). Las etiquetas
jerarquicas no se usan en v5.x.

5.2 Multi-tenant por Campaign (DIFERIDO)
----------------------------------------

::

   class Campaign(models.Model):
       """
       Campanas del Call Center (equivalente a Convenio).
       Cada campana puede tener diferentes modulos habilitados.
       """

**Estado vigente:** concepto de "Campaign" es especifico de call
center; no parte del modelo RBAC IACT generico. Diferido a
subdominio call center cuando se materialice.

5.3 Service layer pattern (PRESERVADO)
--------------------------------------

El patron ``service.py`` que centraliza logica de verificacion
de permisos es valido y se preserva en
:doc:`/backend/adr-back-003-orm-sql-hybrid-permissions`
(supersedido por adr-back-006 nuevo en Z.1).

5.4 DRF permission_classes (PRESERVADO)
---------------------------------------

El uso de ``permission_classes`` explicito en cada vista DRF se
formaliza en
:doc:`/normativa/restricciones/cnst-010-permission-class-explicita-en-vistas-drf`.

5.5 Middleware/decoradores (PRESERVADO)
---------------------------------------

El patron de middleware/decoradores para enforcement automatico
de permisos se documentara en ``adr-back-005-middleware-decoradores-permisos``
(legacy preservado, importacion en Bloque B de Z.1).

----

6. Que se preserva del diseno legacy
====================================

- Patron service layer (``Service`` class para logica de
  permisos).
- DRF ``permission_classes`` explicito.
- Middleware/decoradores para enforcement automatico.
- Grupos con membership N:M.
- Auditoria via tabla separada.
- Funciones SQL nativas para performance.

----

7. Que se descarta del diseno legacy
====================================

- Vocabulario en espanol mezclado (``Capacidad``, ``Convenio``).
- Roles jerarquicos con etiquetas organizacionales (``Analista``,
  ``Supervisor``, ``Gerente``, ``Admin_IT``).
- Modelo multi-tenant por ``Campaign`` (especifico call center,
  no del modelo generico IACT).
- Extension de ``AbstractUser`` con ``CallCenterUser`` (usar
  ``User`` builtin + tabla auxiliar).

----

8. Mapeo legacy -> spec vigente
===============================

Para el implementador futuro:

.. list-table::
 :header-rows: 1
 :widths: 35 65

 * - Concepto en codigo legacy
   - Spec vigente correspondiente
 * - ``CallCenterUser.role``
   - Eliminar — usar grupos AGR-001..010
 * - ``Module``, ``Capacity``
   - 8 MOD_* + 42 funciones del catalogo (modelo v5.2.1)
 * - ``Group`` (custom)
   - ``FunctionGroup`` con ``is_custom=True`` (D-RBAC-4)
 * - ``Group`` (system)
   - AGR-001..AGR-010 inmutables
 * - ``Permission`` granular
   - Function (vocabulario CNST-033)
 * - Service ``has_permission()``
   - SQL function ``usuario_tiene_funcion()``
 * - Permission_classes DRF
   - Sin cambio (CNST-010 vigente)
 * - Audit table
   - ``AuditoriaPermiso`` (CNST-025 vigente)
 * - Multi-tenant Campaign
   - Diferido (segmentos via ``user_segment_assignment`` D-RBAC-7)

----

9. Cierre y trazabilidad
========================

**Codigo original (no publicado):**
``temp-holding/Modules/*.py`` (12 archivos, ~165 KB).

**Spec vigente para implementacion futura:**

- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` — modelo
  conceptual.
- :doc:`/arquitectura-tecnica/modulos/arq-mod-003-rbac-core` —
  modulo arquitectonico RBAC_CORE.
- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano` —
  modelo plano.
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac` —
  vocabulario canonico.
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm` —
  decision de coexistencia ACC + PERM.

**ADRs nuevos en Z.1 (al cierre del WP):**

- ``adr-gob-009-rbac-modelo-conceptual`` — supersede
  BACK-001 + BACK-004.
- ``adr-back-006-rbac-estrategia-implementacion`` — supersede
  BACK-003.

**ADR-BACK-005 middleware:**

- ``adr-back-005-middleware-decoradores-permisos`` —
  importacion legacy pendiente en Bloque B de Z.1; vivira en
  ``source/backend/`` per Z.1.A reorganization.
