.. meta::
   :artefacto: FRONTEND_OVERVIEW
   :tipo: Visión general del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Frontend — Visión general
============================================

Alcance
=======

El tier de frontend del producto IACT se implementa con **React**
(SPA) y se empaqueta con **Webpack**. Consume la API REST del
backend (DRF, ver :doc:`/backend/overview`) y presenta dashboards
analíticos.

Stack
=====

- **Lenguaje:** JavaScript / TypeScript (decisión pendiente —
  ver ADRs en :doc:`/normativa/gobernanza/index`).
- **UI library:** React.
- **Bundler:** Webpack.
- **Gestión de paquetes:** npm.

Componentes principales
=======================

A alto nivel:

- **Componentes UI** reutilizables.
- **State management** (Redux / Context / Zustand — ver ADR
  pendiente).
- **Routing** (react-router o equivalente).
- **HTTP client** (axios / fetch wrapper) hacia la API DRF.
- **Build pipeline** Webpack: entry, output, loaders (babel, css,
  asset), plugins.

Decisiones arquitectónicas
==========================

Los ADRs específicos de frontend viven en
:doc:`/normativa/gobernanza/index` con prefijo ``ADR-FRONT-``.
Históricamente: arquitectura modular monolith vs micro-frontends.

Restricciones aplicables
========================

Restricciones que aplican a frontend (UX, performance budget,
seguridad cliente): ver :doc:`/normativa/restricciones/index`.

Operaciones
===========

Build, deploy del bundle, CDN, cache: :doc:`/operations/overview`.

Calidad
=======

Testing del frontend (unit, component, e2e):
:doc:`/quality/overview`.

Convenciones
============

Convenciones de código React/Webpack: :doc:`conventions`.
