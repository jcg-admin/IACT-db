.. meta::
 :artefacto: TPL_SAD
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================================
TPL_SAD: Plantilla de Software Architecture Document (HLD)
==========================================================

.. note::

 Plantilla para documentos de arquitectura de software (SAD,
 también conocido como HLD — High Level Design). Aplica skill
 ``bpa-design``.

1. Propósito
============

Describir la arquitectura de alto nivel de un componente,
sistema o feature: estructura, componentes, interacciones,
decisiones clave.

2. Cuándo usar esta plantilla
=============================

- Diseño inicial de feature compleja (≥ 3 componentes nuevos).
- Refactorings arquitectónicos significativos.
- Documentación de subsistemas estables para onboarding.

3. Estructura obligatoria
=========================

3.1 Identificación
------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Componente / Feature**
   - {nombre}
 * - **Versión SAD**
   - X.Y.Z
 * - **Estado**
   - Borrador / Aprobado / Superseded
 * - **Owner técnico**
   - Tech Lead responsable

3.2 Vista de contexto
---------------------

- ¿Qué problema resuelve este componente?
- ¿Quién lo consume?
- ¿De qué depende?

Diagrama de contexto C4 nivel 1 (System Context).

3.3 Vista de componentes
------------------------

Diagrama mostrando los componentes internos y sus relaciones.
PlantUML / Mermaid recomendado.

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - {ejemplo}
   - {ejemplo}

3.4 Vista de datos
------------------

- Entidades principales y sus relaciones.
- Storage utilizado (BD, cache, archivos).
- Flujo de datos crítico.

3.5 Vista de despliegue
-----------------------

- En qué nodos corre cada componente.
- Configuración de entornos (dev / staging / producción).

3.6 Decisiones arquitectónicas
------------------------------

Lista de decisiones que requirieron evaluación. Cada una con
puntero al ADR correspondiente:

.. list-table::
 :widths: 40 60
 :header-rows: 1

 * - Decisión
   - ADR
 * - {ejemplo}
   - {ejemplo}

3.7 Restricciones (CNST)
------------------------

CNST que aplican al diseño:

- :doc:`/normativa/restricciones/cnst-007-base-de-datos-ivr-es-solo-lectura`
- {otras CNST}

3.8 Compromisos / Trade-offs
----------------------------

- Qué se priorizó.
- Qué se sacrificó.
- Por qué.

3.9 Riesgos arquitectónicos
---------------------------

.. list-table::
 :widths: 40 30 30
 :header-rows: 1

 * - Riesgo
   - Probabilidad/Impacto
   - Mitigación
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

4. Relación con LLD
===================

El SAD describe el QUÉ y POR QUÉ. El LLD (Low-Level Design)
describe el CÓMO. Ver :doc:`tpl-srs-software-requirements-spec`
para LLD detallado.

5. Ejemplo de aplicación
========================

Ver :doc:`/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/hld-dark-mode`
como SAD aplicado a la feature Dark Mode.

6. Convenciones de naming
=========================

- Archivo: ``hld-{componente}.rst`` o ``sad-{componente}.rst``.
- Ubicación: cerca del componente en source/, o en
  `arquitectura-tecnica/` para SADs de sistema.

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``bpa-design`` (Business Process Architecture — Design)
 * - **Templates relacionados**
   - :doc:`tpl-srs-software-requirements-spec`, :doc:`tpl-mod-modulos`
 * - **Skills complementarias**
   - ``backend-nodejs``, ``frontend-react``, ``db-postgresql``
