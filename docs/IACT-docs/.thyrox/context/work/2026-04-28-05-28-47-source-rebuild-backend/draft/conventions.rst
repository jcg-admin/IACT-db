.. meta::
   :artefacto: BACKEND_CONVENTIONS
   :tipo: Convenciones del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Backend — Convenciones
============================================

Convenciones de código y diseño que aplican al tier de backend
(Django REST Framework + Python 3.11+).

Estilo de código
================

- **PEP 8** estricto para Python.
- Linter: ``flake8`` o ``ruff``.
- Formatter: ``black``.
- Import sorting: ``isort``.
- Type hints obligatorios en funciones públicas; ``mypy`` en CI.

Estructura del proyecto
=======================

Organización de apps Django por dominio funcional, no por capa
técnica:

::

    backend/
    ├── manage.py
    ├── pyproject.toml
    ├── {project}/                  # Settings + URLs root
    │   ├── settings/
    │   ├── urls.py
    │   └── wsgi.py
    ├── apps/
    │   ├── auth/                   # RBAC, SoD
    │   ├── users/
    │   ├── reports/
    │   └── ...
    └── tests/

Cada app:

::

    apps/{domain}/
    ├── __init__.py
    ├── apps.py
    ├── models.py
    ├── serializers.py
    ├── views.py                    # ViewSets
    ├── urls.py
    ├── permissions.py
    ├── filters.py
    └── tests/

API REST (DRF)
==============

ViewSets vs APIView
-------------------

- **ViewSets** son la opción por defecto para CRUD estándar.
  Generan rutas automáticamente y dan operaciones consistentes.
- **APIView** se usa solo cuando la lógica no encaja en CRUD
  (operaciones custom, endpoints no resource-oriented).

Serializers
-----------

- Un serializer por modelo, en ``serializers.py`` de la app.
- Validaciones de negocio en ``validate_<field>`` o ``validate``.
- No mezclar lógica de negocio en serializers — delegar a
  servicios o métodos de modelo.

URLs
----

- Cada app tiene su ``urls.py`` con un ``DefaultRouter``.
- El root ``urls.py`` del proyecto incluye los de las apps con un
  prefijo ``/api/v1/{app}/``.
- Versionado en URL: ``/api/v1/`` actual.

Permisos
--------

- ``IsAuthenticated`` por default en settings.
- Permisos custom en ``apps/{domain}/permissions.py``.
- RBAC implementado con ``django-guardian`` o equivalente
  (pendiente decisión de implementación).
- Aplicar SoD según restricciones del producto (ver
  :doc:`/normativa/restricciones/index`).

Errores
-------

- Status codes HTTP semánticos (200, 201, 204, 400, 401, 403,
  404, 409, 422, 500).
- Body de error consistente:

  .. code-block:: json

     {
       "error": "validation_error",
       "message": "...",
       "details": { ... }
     }

Modelos
=======

- Heredar de ``django.db.models.Model``.
- Campos en snake_case.
- ``Meta.db_table`` explícito si el nombre auto-generado no
  cumple convenciones de DB (ver :doc:`/databases/conventions`).
- ``__str__`` siempre definido.
- Fechas: ``created_at``, ``updated_at`` automáticos vía
  ``auto_now_add`` / ``auto_now``.

Migrations
==========

- Una migration por cambio lógico, no por commit.
- Nombres descriptivos: ``0042_add_user_role_field.py``.
- Migrations destructivas (drop column) requieren proceso documentado
  en :doc:`/operations/overview`.
- Política de rollback: ver :doc:`/databases/conventions`.

Logging
=======

- ``logging`` estándar de Python con configuración en settings.
- Niveles: DEBUG (dev), INFO (operaciones rutinarias), WARNING
  (anomalías recuperables), ERROR (errores del sistema).
- Auditoría (acciones de usuarios) usa logger específico
  ``audit`` con destino inmutable (ver restricciones).

Testing
=======

Convenciones específicas en :doc:`/quality/conventions`. Resumen:

- ``pytest`` + ``pytest-django``.
- Tests por app en ``apps/{domain}/tests/``.
- Fixtures con ``factory-boy`` o equivalente.

Dependencias
============

- ``pyproject.toml`` como única fuente de verdad.
- Pinning estricto de versiones mayores; ranges para parches.
- Dependencias de dev (``[project.optional-dependencies].dev``)
  separadas de runtime.

Commit y branching
==================

Aplican las reglas globales del repo (Tim Pope commit style,
``feature/*`` por ÉPICA — ver :doc:`/normativa/procedimientos/index`).
