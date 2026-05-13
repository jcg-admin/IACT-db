.. meta::
 :artefacto: TPL_DJANGO_APP
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

============================================
TPL_DJANGO_APP: Plantilla de Django App
============================================

.. note::

 Plantilla técnica para nuevas apps Django dentro del modular
 monolith IACT. Aplica skills ``backend-nodejs`` (estructura
 modular) y restricciones del proyecto (CNST-002 buzón interno,
 CNST-007 BD dual).

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **App name**
   - {kebab-lowercase}
 * - **Módulo IACT**
   - MOD_Auth / MOD_Users / MOD_Reports / etc.
 * - **Owner técnico**
   - {nombre}

2. Estructura mínima
====================

::

 apps/{app_name}/
 ├── __init__.py
 ├── apps.py
 ├── models.py
 ├── views.py
 ├── urls.py
 ├── serializers.py        # DRF serializers
 ├── permissions.py        # RBAC enforcers (CNST-029)
 ├── migrations/
 ├── tests/
 │   ├── test_models.py
 │   ├── test_views.py
 │   └── test_permissions.py
 └── README

3. Restricciones obligatorias
=============================

- **CNST-002:** notificaciones SOLO vía buzón interno (NO email).
- **CNST-007:** BD IVR es read-only desde Django.
- **CNST-009:** PII enmascarada en logs/auditoría.
- **CNST-019:** exportaciones >10K registros → asíncrono.
- **CNST-029/030:** RBAC plano + SoD enforcement.

4. Checklist pre-deploy
=======================

- [ ] Tests con coverage ≥ 80% (RNF-002).
- [ ] Migrations son backwards-compatible.
- [ ] Permisos RBAC declarados en :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`.
- [ ] Auditoría aplicada en operaciones críticas (CNST-025).
- [ ] Queries respetan CNST-014 (paginación obligatoria).

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``backend-nodejs`` + skills de Django/DRF (tech-stack)
 * - **CNSTs aplicables**
   - CNST-002, CNST-007, CNST-009, CNST-014, CNST-019, CNST-025, CNST-029, CNST-030
 * - **Procedimiento aplicable**
   - :doc:`/normativa/procedimientos/proc-dev-003-desarrollo-local`
