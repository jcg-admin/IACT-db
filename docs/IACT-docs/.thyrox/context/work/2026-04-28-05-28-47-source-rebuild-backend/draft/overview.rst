.. meta::
   :artefacto: BACKEND_OVERVIEW
   :tipo: Visión general del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Backend — Visión general
============================================

Alcance
=======

El tier de backend del producto IACT se implementa con **Django REST
Framework (DRF)** sobre **Python 3.11+**. Expone una API REST que
sirve al frontend (React + Webpack) y consume las dos bases de datos
del producto (MySQL + PostgreSQL).

Stack
=====

- **Lenguaje:** Python 3.11+
- **Framework web:** Django + Django REST Framework
- **WSGI:** mod_wsgi sobre Apache (ver :doc:`/infrastructure/overview`)
- **Bases de datos:** MySQL + PostgreSQL (ver :doc:`/databases/overview`)
- **Gestión de paquetes:** pip / pyproject.toml

Componentes principales
=======================

Los componentes detallados se documentarán en sub-WPs cuando exista
código. A alto nivel, el backend se organiza en:

- **Apps Django** por dominio funcional.
- **API endpoints** vía ViewSets / APIView de DRF.
- **Serializers** para mapping entre modelos y JSON.
- **Authentication / Authorization** — RBAC con SoD (ver
  restricciones aplicables en :doc:`/normativa/restricciones/index`).
- **Migrations** — manejo en :doc:`/databases/overview`.

Decisiones arquitectónicas
==========================

Las decisiones de alto nivel del backend viven como ADRs en
:doc:`/normativa/gobernanza/index` (con prefijo ``ADR-BACK-`` o
``ADR-DEVOPS-`` cuando cruzan tier).

Los principales drivers del diseño actual:

- API REST stateless (no sessions server-side persistentes).
- Dual database: ver :doc:`/databases/overview` para razón.
- Despliegue mod_wsgi sobre Apache: ver
  :doc:`/infrastructure/overview`.

Restricciones aplicables
========================

Las restricciones (CNST_*) que aplican específicamente a backend se
listan en :doc:`/normativa/restricciones/index`. Categorías
relevantes: comunicaciones, sesiones, base de datos, seguridad,
performance, logging.

Operaciones
===========

Deploy, monitoring, runbooks: :doc:`/operations/overview`.

Calidad
=======

Estrategia de testing del backend: :doc:`/quality/overview`.

Convenciones
============

Convenciones de código y diseño del tier: :doc:`conventions`.
