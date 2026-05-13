.. meta::
 :artefacto: INDEX_BACKEND
 :tipo: Indice
 :dominio: backend
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

=======
Backend
=======

Documentacion de la capa backend del proyecto IACT
(Django REST Framework sobre Python 3.11+).

Estructura skeleton-first: scope y convenciones. El detalle de
endpoints, modelos, migraciones y codigo vive en el repositorio
de codigo, no en esta documentacion.

.. toctree::
 :maxdepth: 1
 :caption: Skeleton

 overview
 conventions

.. toctree::
 :maxdepth: 1
 :caption: ADRs Backend

 adr-back-001-grupos-funcionales-sin-jerarquia
 adr-back-002-configuracion-dinamica-sistema
 adr-back-003-orm-sql-hybrid-permissions
 adr-back-004-sistema-permisos-sin-roles-jerarquicos
 adr-back-005-middleware-decoradores-permisos
 adr-back-006-rbac-estrategia-implementacion
