.. meta::
 :artefacto: FRONT_OVERVIEW
 :tipo: Vision General
 :dominio: frontend
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

==============
Vision General
==============

Scope arquitectonico del frontend IACT. Sin codigo — solo
descripcion de capas y responsabilidades.

React
=====

El frontend IACT esta construido sobre React. Los aspectos
cubiertos por esta documentacion son:

- **Componentes** — jerarquia de componentes presentacionales
  y contenedores. Convenciones de composicion.
- **State management** — estrategia de manejo de estado
  (local vs global). Stores compartidos por dominio.
- **Routing** — esquema de rutas y navegacion entre vistas.
- **Integracion con backend** — clientes HTTP, contratos
  de API, manejo de errores. Detalle en
  :doc:`/arquitectura-tecnica/modulos/index`.

Webpack
=======

El bundling del frontend usa Webpack. Aspectos documentados:

- **Entry / output** — puntos de entrada por aplicacion y
  configuracion de output (chunks, hashing).
- **Loaders** — pipeline de transformacion de assets
  (JS/JSX, CSS, imagenes).
- **Plugins** — plugins de optimizacion y desarrollo.
- **Configuraciones compartidas** — base comun entre
  microfrontends.

Microfrontends
==============

El frontend se descompone en microfrontends por dominio
funcional. La integracion entre ellos sigue las decisiones
arquitectonicas registradas en
:doc:`/arquitectura-tecnica/index`.

Out of scope
============

Esta documentacion **no** incluye:

- Codigo de componentes (vive en el repo de codigo).
- Configuracion Webpack detallada (vive en el repo de codigo).
- Snapshots de UI / mockups (gestionados aparte).
