.. meta::
 :artefacto: BACK_OVERVIEW
 :tipo: Vision General
 :dominio: backend
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

==============
Vision General
==============

Scope arquitectonico del backend IACT. Sin codigo — solo
descripcion de capas y responsabilidades.

Stack
=====

- **Python:** 3.11+
- **Framework:** Django + Django REST Framework (DRF)
- **Servidor:** Apache + mod_wsgi sobre Ubuntu
- **Origen de datos operativos:** MySQL (modo solo-lectura)
- **Destino analitico:** PostgreSQL (optimizado)

Modulos arquitectonicos
=======================

El backend implementa los 8 modulos definidos en
:doc:`/arquitectura-tecnica/modulos/index`:

- AUTH — autenticacion y sesion
- USER_IDENTITY — identidad y perfiles
- RBAC_CORE — control de acceso por rol/funcion
- ETL_MONITORING — observabilidad de pipelines
- VIS_REPORTS — vistas y reportes
- ALERTS — gestion de alertas
- AUDIT — auditoria de acciones
- SYS_LOGS — logging tecnico

Estructura DRF
==============

Aspectos cubiertos por esta documentacion:

- **Settings** — configuracion por entorno (dev, staging, prod).
- **Apps** — descomposicion por dominio funcional alineada con
  los 8 modulos arquitectonicos.
- **Middleware** — pipeline de procesamiento de request/response.
- **URLs** — convenciones de routing y versionado de API.
- **Serializers / ViewSets / Permisos** — capas DRF.

Integracion con frontend
========================

El backend expone una API REST consumida por el frontend
React + Webpack (ver :doc:`/frontend/overview`). Los contratos
de API se versionan; las decisiones de evolucion se registran
como ADRs en :doc:`/normativa/gobernanza/index`.

Out of scope
============

Esta documentacion **no** incluye:

- Endpoints especificos (viven en el repo de codigo / OpenAPI).
- Modelos y migraciones (viven en el repo de codigo).
- Codigo DRF concreto (serializers, viewsets, querysets).
