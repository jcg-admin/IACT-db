.. meta::
 :artefacto: INDEX_CATALOGOS
 :tipo: Indice
 :dominio: arquitectura-tecnica
 :subdominio: catalogos
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================
Catálogos del Sistema IACT
==============================

Inventarios estructurados de elementos del sistema (BR, UC,
Procesos, Templates, Funciones RBAC, etc.) con propósito de
trazabilidad y gobernanza.

Propósito
=========

Los catálogos son **fuentes de verdad** del proyecto. Listan
exhaustivamente los elementos de una categoría y los enlazan a
sus artefactos canónicos. Útiles para:

- Auditoría de cobertura.
- Identificación de duplicados / faltantes.
- Análisis de impacto cuando algo cambia.

Catálogos disponibles
=====================

.. toctree::
 :maxdepth: 1

Convención
==========

- Carpeta canónica: ``source/arquitectura-tecnica/catalogos/``
- Naming: ``catalogo-{tipo}.rst`` (kebab-lowercase per STD-007).
- Cada catálogo tiene metadata `:artefacto: CATALOGO_{TIPO}`.

Catálogos relacionados (en otras ubicaciones)
=============================================

Por convenciones del corpus, algunos catálogos viven en otros
lugares:

- **Catálogo de funciones RBAC:** vive en
  :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (capítulo
  3 — Catálogo de funciones).
- **Catálogo de plantillas:**
  :doc:`/normativa/estandares/plantillas/index`.
- **Catálogo de procedimientos:**
  :doc:`/normativa/procedimientos/index`.
- **Catálogo de constraints:**
  :doc:`/normativa/restricciones/index`.

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``ba-requirements-analysis`` (catalogación BABOK)
 * - **Templates aplicables**
   - :doc:`/normativa/estandares/plantillas/tpl-trz-matriz-rtm`
 * - **Naming standard**
   - :doc:`/normativa/estandares/std-007-convencion-naming`
