.. meta::
 :artefacto: BACK_CONVENTIONS
 :tipo: Convenciones
 :dominio: backend
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

============
Convenciones
============

Convenciones de naming, estructura y estilo para el backend
IACT (Django REST Framework). Aplica a Python, DRF y artefactos
asociados.

Naming
======

Python
------

- **Modulos / paquetes:** snake_case (``users``, ``auth_module``).
- **Clases:** PascalCase (``UserSerializer``, ``ReportViewSet``).
- **Funciones / metodos:** snake_case (``get_active_users``,
  ``validate_token``).
- **Variables:** snake_case (``user_count``, ``query_params``).
- **Constantes:** UPPER_SNAKE_CASE (``DEFAULT_PAGE_SIZE``).

DRF
----

- **Serializers:** sufijo ``Serializer`` (``UserSerializer``).
- **ViewSets:** sufijo ``ViewSet`` (``UserViewSet``).
- **APIViews:** sufijo ``View`` (``LoginView``).
- **Permissions:** sufijo ``Permission``
  (``IsOwnerOrReadOnly``).

Archivos
--------

- Aplica :doc:`/normativa/estandares/std-007-convencion-naming`:
  snake_case en Python, sin tildes ni enies.

URLs / API
==========

- **Versionado:** prefijo ``/api/v{N}/`` en todos los endpoints.
- **Recursos en plural:** ``/api/v1/users/``, ``/api/v1/reports/``.
- **Acciones no-CRUD:** sub-recursos descriptivos
  (``/api/v1/users/{id}/activate/``).
- **Paginacion:** estandar DRF con ``page_size`` configurable.
- **Errores:** formato JSON consistente con codigo, mensaje y
  detalle. Las decisiones de formato de error son ADRs en
  :doc:`/normativa/gobernanza/index`.

Estructura de apps
==================

Por dominio funcional, alineado con los 8 modulos
arquitectonicos:

.. code-block:: text

 backend/
   apps/
     auth/
       models.py
       serializers.py
       views.py
       urls.py
       permissions.py
     user_identity/
       ...
     rbac_core/
       ...
     etl_monitoring/
       ...
   config/
     settings/
       base.py
       dev.py
       prod.py
     urls.py
     wsgi.py

Estilo
======

- **Linter:** flake8 / ruff con configuracion compartida.
- **Formatter:** black (las reglas de estilo se delegan al
  tooling — no se documentan aqui).
- **Type hints:** obligatorios en interfaces publicas (vistas,
  serializers, servicios).
- **Imports:** orden estable (stdlib → libs externas → django →
  apps locales).

Permisos
========

- Usar el modelo RBAC canonico documentado en
  :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`.
- Las clases de permiso DRF deben mapear a las funciones (no a
  permisos legacy tabla-PERM). La migracion vocabulario
  ``Capacidad`` → ``Function`` (D-RBAC-2 + D-RBAC-8) esta
  registrada como deuda tecnica en
  :doc:`/risks-technical-debt/deuda-tecnica-rebuild` (DEBT-001).

Trazabilidad
============

- Convenciones generales: :doc:`/normativa/estandares/index`.
- Decisiones arquitectonicas backend: registrar como ADR
  en :doc:`/normativa/gobernanza/index` con prefijo
  ``ADR-BACK-`` o ``ADR-DEVOPS-`` segun aplique.
