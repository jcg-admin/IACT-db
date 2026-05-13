.. meta::
 :artefacto: INDEX_GOBERNANZA
 :tipo: Indice
 :dominio: normativa
 :subdominio: gobernanza
 :estado: Vigente
 :version: 1.1.0
 :fecha_creacion: 2026-04-28
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

Gobernanza del Proyecto
=======================

Las decisiones arquitectonicas (ADR) del proyecto IACT viven
**organizadas por su modulo de dominio** (per STD-007 v2.0.2 §4):

- **ADR-GOB**: gobernanza transversal — viven en este cajon.
- **ADR-BACK**: decisiones del backend — viven en :doc:`/backend/index`.
- **ADR-FRONT**: decisiones del frontend — viven en :doc:`/frontend/index`.
- **ADR-DEVOPS**: decisiones de infraestructura — viven en :doc:`/devops/index`.
- **ADR-QA**: decisiones de testing y calidad — viven en :doc:`/quality/index`.

Catalogo
--------

.. toctree::
 :maxdepth: 1
 :caption: ADRs de Gobernanza (transversales)

 adr-gob-001-organizacion-proyecto-por-dominio
 adr-gob-002-plantuml-para-diagramas
 adr-gob-003-jerarquia-requerimientos-5-niveles
 adr-gob-004-clasificacion-reglas-negocio
 adr-gob-005-especificacion-casos-uso
 adr-gob-006-diagramas-uml-casos-uso
 adr-gob-007-trazabilidad-artefactos-requisitos
 adr-gob-008-rbac-coexistencia-acc-perm
 adr-gob-009-rbac-modelo-conceptual

Estructura por dominio
----------------------

**Organizacion del proyecto**

- :doc:`adr-gob-001-organizacion-proyecto-por-dominio` — organizacion
  del repositorio por dominio (no por tipo de archivo).

**Documentacion y diagramas**

- :doc:`adr-gob-002-plantuml-para-diagramas` — PlantUML como
  estandar para todos los diagramas UML.
- :doc:`adr-gob-006-diagramas-uml-casos-uso` — diagramas UML
  obligatorios para los casos de uso.

**Modelo de requisitos**

- :doc:`adr-gob-003-jerarquia-requerimientos-5-niveles` — jerarquia
  de 5 niveles (BReq → BR → UC → FR → NFR/CNST).
- :doc:`adr-gob-004-clasificacion-reglas-negocio` — clasificacion
  y formato canonico de las BRs.
- :doc:`adr-gob-005-especificacion-casos-uso` — formato completo de
  los UCs.
- :doc:`adr-gob-007-trazabilidad-artefactos-requisitos` — matrices
  de trazabilidad bidireccional entre BR/UC/FR/CNST.

Convenciones
------------

- Numeracion ``ADR-GOB-NNN`` flat consecutiva (sin gaps).
- Cada ADR tiene clasificacion ``Critico``, ``Alto`` o ``Medio`` segun
  el impacto de revertirlo o ignorarlo.
- ADRs tecnicos (BACK/FRONT/DEVOPS/QA) viven en sus cajones
  respectivos, no aqui (ver `discover/handoff-to-tech-wps.rst` del
  WP gobernanza para el detalle de transferencias).
- El formato sigue
  :doc:`/normativa/estandares/std-007-convencion-naming` y
  :doc:`/normativa/estandares/plantillas/tpl-adr-decisiones-arquitectonicas`.
