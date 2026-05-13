.. meta::
 :artefacto: ADR-BACK-005
 :tipo: ADR
 :dominio: backend
 :estado: Vigente (legacy preservado)
 :version: 1.0.0
 :fecha_creacion: 2025-11-18
 :ultimo_cambio: 2026-04-29
 :autor: Equipo Backend
 :clasificacion: Interno

.. _adr-back-005:

================================================================
ADR-BACK-005: Middleware y Decoradores para Permisos Granulares
================================================================

.. note::

 **ADR aceptado en 2025-11-18, importado al corpus el 2026-04-29
 como referencia tecnica preservada.**

 Este ADR define la integracion de Django/DRF con el sistema de
 permisos granulares cuando se materialice la implementacion.
 NO ha sido superseded por los ADRs nuevos del WP Z.1 (vigente
 en su capa: middleware + decoradores).

 Vocabulario legacy: usa ``capacidad`` / ``Capacidad`` que
 :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
 vigente prohibe a favor de ``Function``. Cuando el codigo se
 implemente, sustituir ``capacidad`` -> ``function`` en toda la
 narrativa de este ADR.

----

Estado y metadata
=================

- **Estado:** Aceptada (legacy preservado).
- **Fecha original:** 2025-11-18.
- **Decisores:** equipo-backend, tech-lead.
- **Contexto tecnico:** Backend — Integracion de Permisos.
- **Relacionados (vigentes):**

  - :doc:`/backend/adr-back-001-grupos-funcionales-sin-jerarquia`
    (legacy, supersedido por ``adr-gob-009`` en Z.1)
  - :doc:`/backend/adr-back-003-orm-sql-hybrid-permissions`
    (legacy, supersedido por ``adr-back-006`` en Z.1)
  - :doc:`/normativa/restricciones/cnst-010-permission-class-explicita-en-vistas-drf`

----

1. Contexto y Problema
======================

El sistema de permisos granulares (ADR-BACK-001) requiere
integracion con vistas Django y Django REST Framework. Necesitamos
un mecanismo para:

1. **Proteger vistas** con verificacion automatica de permisos.
2. **Auditar accesos** de forma transparente.
3. **Soportar multiples tipos de vistas:** FBV, CBV, DRF
   ViewSets.
4. **Minimizar codigo boilerplate** en cada vista.
5. **Proporcionar mensajes claros** cuando se deniega acceso.
6. **Performance** sin overhead significativo.

**Preguntas clave:**

- Como integrar permisos en vistas sin codigo repetitivo?
- Como soportar Function-Based Views y Class-Based Views?
- Como integrar con DRF Permission Classes?
- Como auditar accesos de forma automatica?
- Como minimizar overhead de performance?

**Restricciones (al momento del ADR original):**

- Sistema de permisos granulares con 130+ capacidades (vocabulario
  legacy; hoy = 42 funciones del modelo v5.2.1).
- Django 5.x + Django REST Framework 3.x.
- Necesidad de auditoria automatica (ISO 27001).
- Performance: overhead < 5ms por request.
- Soportar logica AND/OR para multiples permisos.

**Impacto del problema:**

- Sin integracion clara, cada vista debe verificar permisos
  manualmente.
- Codigo duplicado en cada endpoint.
- Riesgo de olvidar proteger endpoints.
- Auditoria inconsistente.

----

2. Factores de Decision
=======================

- **Simplicidad:** facil de usar para desarrolladores.
- **Flexibilidad:** soportar FBV, CBV, DRF ViewSets.
- **Performance:** overhead minimo (< 5ms).
- **Auditoria:** automatica y configurable.
- **Mensajes claros:** errores informativos para debugging.
- **Compatibilidad:** con Django y DRF estandar.
- **Testabilidad:** facil de testear.

----

3. Opciones Consideradas
========================

3.1 Opcion 1: Permission Classes DRF Exclusivamente
---------------------------------------------------

**Descripcion:** usar unicamente DRF Permission Classes para
proteger endpoints.

Pros:

- Estandar DRF.
- Integracion nativa con ViewSets.
- Testing conocido.

Contras:

- Solo funciona en DRF (no en vistas Django tradicionales).
- Codigo repetitivo en cada ViewSet.
- No soporta auditoria automatica.
- Dificil implementar logica AND/OR.

**Razon del rechazo:** no soporta vistas Django tradicionales.
Requiere crear Permission class por cada capacidad.

3.2 Opcion 2: Middleware Global
-------------------------------

**Descripcion:** middleware Django que intercepta todas las
requests y verifica permisos globalmente.

Pros:

- Centralizado.
- Funciona para todas las vistas.
- Auditoria automatica.

Contras:

- Dificil especificar permisos por vista.
- Configuracion compleja (mapping URL -> permiso).
- No es explicito (permisos no visibles en codigo de vista).
- Overhead en TODAS las requests (incluso publicas).

**Razon del rechazo:** no es explicito. Configuracion compleja
y dificil de mantener.

3.3 Opcion 3: Decoradores + Permission Classes DRF (ELEGIDA)
------------------------------------------------------------

**Descripcion:** combinar decoradores Python para FBV/CBV con
Permission Classes DRF para ViewSets, mas middleware opcional
para auditoria.

Componentes:

1. **Decoradores para FBV/CBV:**

   - ``@verificar_permiso(capacidad_requerida)``
   - ``@require_permission(capacidad)``
   - ``@require_any_permission([cap1, cap2])``  (OR logic)
   - ``@require_all_permissions([cap1, cap2])``  (AND logic)

2. **Permission Classes para DRF:**

   - ``GranularPermission``  (permission class base)
   - ``GranularPermissionMixin``  (helpers para ViewSets)

3. **Middleware Opcional:**

   - ``PermissionAuditMiddleware``  (auditoria automatica)

Pros:

- Soporta FBV, CBV, DRF ViewSets.
- Explicito (decorador visible en codigo).
- Flexible (logica AND/OR).
- Auditoria configurable.
- Performance (overhead minimo).
- Facil de testear.
- Mensajes de error claros.

Contras:

- Mas codigo que opcion 1 (pero mas flexible).
- Requiere implementacion de 3 componentes.

----

4. Ejemplos de Implementacion
=============================

4.1 Decorador para FBV
----------------------

.. code-block:: python

   from callcentersite.apps.permissions.middleware import verificar_permiso

   @verificar_permiso('sistema.vistas.dashboards.ver', auditar=True)
   def dashboard_view(request):
       """Vista de dashboard."""
       return render(request, 'dashboard.html', {
           'user': request.user,
       })

4.2 Decorador para CBV
----------------------

.. code-block:: python

   from django.views.generic import TemplateView
   from django.utils.decorators import method_decorator
   from callcentersite.apps.permissions.middleware import verificar_permiso

   @method_decorator(
       verificar_permiso('sistema.vistas.dashboards.ver'),
       name='dispatch'
   )
   class DashboardView(TemplateView):
       template_name = 'dashboard.html'

4.3 Permission Class para DRF
-----------------------------

.. code-block:: python

   from rest_framework import viewsets
   from callcentersite.apps.permissions.permissions import GranularPermission

   class DashboardViewSet(viewsets.ModelViewSet):
       permission_classes = [GranularPermission]
       required_permissions = ['sistema.vistas.dashboards.ver']

       def get_queryset(self):
           return Dashboard.objects.all()

4.4 Logica AND/OR
-----------------

.. code-block:: python

   # OR Logic - Usuario necesita AL MENOS UNA de las capacidades
   @require_any_permission([
       'sistema.vistas.dashboards.ver',
       'sistema.vistas.dashboards.ver_publico'
   ])
   def dashboard_view(request):
       pass

   # AND Logic - Usuario necesita TODAS las capacidades
   @require_all_permissions([
       'sistema.finanzas.pagos.ver',
       'sistema.finanzas.pagos.aprobar'
   ])
   def aprobar_pago_view(request, pago_id):
       pass

4.5 Implementacion del Decorador (referencia)
---------------------------------------------

.. code-block:: python

   from functools import wraps
   from django.http import JsonResponse
   from callcentersite.apps.permissions.services import PermisoService

   def verificar_permiso(capacidad_requerida, auditar=False, mensaje_error=None):
       """
       Decorator para verificar permisos granulares.

       Args:
           capacidad_requerida: str o list[str] - Capacidad(es) requerida(s)
           auditar: bool - Si registrar el acceso en auditoria
           mensaje_error: str - Mensaje custom de error
       """
       def decorator(view_func):
           @wraps(view_func)
           def wrapper(request, *args, **kwargs):
               # Verificar autenticacion
               if not request.user.is_authenticated:
                   return JsonResponse(
                       {'error': 'Authentication required'},
                       status=401
                   )

               # Convertir a lista si es string
               capacidades = (
                   [capacidad_requerida]
                   if isinstance(capacidad_requerida, str)
                   else capacidad_requerida
               )

               # Verificar TODAS las capacidades (AND logic)
               tiene_permiso = all(
                   PermisoService.usuario_tiene_permiso(
                       request.user.id,
                       cap
                   )
                   for cap in capacidades
               )

               if not tiene_permiso:
                   # Auditar acceso denegado
                   if auditar:
                       PermisoService.registrar_acceso(
                           usuario_id=request.user.id,
                           capacidad=capacidad_requerida,
                           accion='acceso_denegado',
                           ip_address=request.META.get('REMOTE_ADDR'),
                           user_agent=request.META.get('HTTP_USER_AGENT')
                       )

                   error_msg = mensaje_error or f'Permission denied: {capacidad_requerida}'
                   return JsonResponse(
                       {'error': error_msg},
                       status=403
                   )

               # Auditar acceso permitido
               if auditar:
                   PermisoService.registrar_acceso(
                       usuario_id=request.user.id,
                       capacidad=capacidad_requerida,
                       accion='acceso_permitido',
                       ip_address=request.META.get('REMOTE_ADDR'),
                       user_agent=request.META.get('HTTP_USER_AGENT')
                   )

               # Permitir acceso
               return view_func(request, *args, **kwargs)

           return wrapper
       return decorator

4.6 Permission Class DRF (referencia)
-------------------------------------

.. code-block:: python

   from rest_framework.permissions import BasePermission
   from callcentersite.apps.permissions.services import PermisoService

   class GranularPermission(BasePermission):
       """
       Permission class para DRF ViewSets.

       Uso:
           class MyViewSet(viewsets.ModelViewSet):
               permission_classes = [GranularPermission]
               required_permissions = ['sistema.recurso.accion']
       """

       def has_permission(self, request, view):
           if not request.user.is_authenticated:
               return False

           # Obtener capacidades requeridas del ViewSet
           required_perms = getattr(view, 'required_permissions', [])

           if not required_perms:
               # Sin permisos definidos, denegar por defecto
               return False

           # Verificar TODAS las capacidades
           return all(
               PermisoService.usuario_tiene_permiso(
                   request.user.id,
                   perm
               )
               for perm in required_perms
           )

----

5. Decision
===========

**Opcion elegida:** "Decoradores + Permission Classes DRF".

Justificacion:

1. **Flexibilidad:** soporta FBV, CBV, DRF ViewSets con APIs
   consistentes.
2. **Explicito:** permisos visibles en codigo (decorador o
   ``permission_classes``).
3. **Auditoria:** configurable por vista con parametro
   ``auditar=True``.
4. **Performance:** overhead minimo (5-10ms), usa estrategia
   hibrida ORM+SQL (ADR-BACK-003 / supersedido por adr-back-006).
5. **Logica AND/OR:** decoradores especializados para casos
   complejos.
6. **Testabilidad:** facil de mockear y testear.

Trade-offs aceptados:

- Mas componentes que opcion 1 (pero mas flexibilidad).
- Codigo adicional vs DRF puro (justificado por soporte de
  FBV/CBV).

----

6. Consecuencias
================

6.1 Positivas
-------------

- Integracion transparente con permisos granulares.
- Soporta FBV, CBV, DRF ViewSets.
- Codigo boilerplate minimo.
- Auditoria configurable por vista.
- Mensajes de error claros.
- Performance optimo (< 5ms overhead).
- Testeable facilmente.
- Logica AND/OR flexible.

6.2 Negativas
-------------

- Requiere implementar 3 componentes (decoradores, permissions,
  middleware).
- Curva de aprendizaje para decoradores Python.
- Debe mantener consistencia entre decoradores y permission
  classes.

6.3 Neutrales
-------------

- Decoradores deben aplicarse correctamente (en ``dispatch``
  para CBV).
- Permission classes requieren atributo ``required_permissions``.
- Middleware opcional para auditoria global.

----

7. Plan de Implementacion (cuando se materialice)
=================================================

1. **Fase 1: Decoradores Base** (2 dias)

   - Implementar ``@verificar_permiso``.
   - Implementar ``@require_permission``.
   - Tests unitarios.

2. **Fase 2: Decoradores Avanzados** (1 dia)

   - Implementar ``@require_any_permission``  (OR).
   - Implementar ``@require_all_permissions``  (AND).
   - Tests de logica AND/OR.

3. **Fase 3: Permission Classes DRF** (2 dias)

   - Implementar ``GranularPermission``.
   - Implementar ``GranularPermissionMixin``.
   - Tests de integracion con ViewSets.

4. **Fase 4: Middleware Opcional** (1 dia)

   - Implementar ``PermissionAuditMiddleware``.
   - Configuracion en settings.
   - Tests de auditoria.

5. **Fase 5: Documentacion y Ejemplos** (1 dia)

   - Documentacion tecnica.
   - Ejemplos de uso.
   - Guia de migracion.

**Total:** 7 dias.

----

8. Validacion y Metricas
========================

Criterios de exito:

- Overhead: < 5ms por request (p95).
- Coverage: 100% de endpoints protegidos.
- Auditoria: 100% de accesos criticos registrados.
- Tests: > 90% coverage.

Como medir:

- Performance profiling de decoradores.
- Code review para verificar proteccion de endpoints.
- Audit log analysis.
- Coverage report de pytest.

----

9. Alternativas Descartadas
===========================

9.1 Django Guardian
-------------------

Por que se descarto:

- Object-level permissions (demasiado granular).
- Complejidad innecesaria.
- No se alinea con modelo de grupos funcionales.

9.2 Custom Middleware Global
----------------------------

Por que se descarto:

- No es explicito (configuracion oculta).
- Overhead en todas las requests.
- Dificil de mantener mapping URL -> permiso.

----

10. Referencias
===============

- :doc:`/backend/adr-back-001-grupos-funcionales-sin-jerarquia`
  (legacy, supersedido por adr-gob-009 en Z.1).
- :doc:`/backend/adr-back-003-orm-sql-hybrid-permissions`
  (legacy, supersedido por adr-back-006 en Z.1).
- :doc:`/normativa/restricciones/cnst-010-permission-class-explicita-en-vistas-drf`.
- `Python Decorators <https://docs.python.org/3/glossary.html#term-decorator>`_.
- `DRF Permissions <https://www.django-rest-framework.org/api-guide/permissions/>`_.

----

11. Notas Adicionales (legacy)
==============================

- **Fecha de discusion inicial:** 2025-11-08.
- **Implementacion declarada como completa en 2025-11-11**
  (codigo legacy en
  ``temp-holding/Modules/`` — ver
  :doc:`/gestion/evidencia/rbac-historia/diseno-referencia-implementacion-permisos-legacy`).
- **Tests implementados (legacy):** 11+ tests en
  ``test_middleware.py``; coverage de casos edge.
- **NOTA IMPORTANTE para implementacion futura:** el codigo
  legacy NO es codigo vigente del proyecto IACT. Cuando se
  materialice la implementacion, aplicar:

  - Vocabulario CNST-033: ``capacidad`` -> ``function``.
  - Modelo v5.2.1: 42 funciones + 10 grupos AGR (no "130+
    capacidades").
  - Estrategia tecnica del adr-back-006 nuevo (supersede
    adr-back-003).
