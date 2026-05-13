.. meta::
 :artefacto: TPL_STK
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================
TPL_STK: Plantilla de Stakeholder Analysis
==========================================

.. note::

 Plantilla BABOK para análisis de stakeholders. Identifica
 actores, intereses, influencia y estrategia de engagement.
 Aplica skill ``ba-elicitation``.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Código**
   - STK-{NNN}
 * - **Proyecto / Iniciativa**
   - {nombre}
 * - **Responsable análisis**
   - {nombre}

2. Matriz de stakeholders
=========================

.. list-table::
 :widths: 20 15 15 25 25
 :header-rows: 1

 * - Stakeholder
   - Influencia (A/M/B)
   - Interés (A/M/B)
   - Necesidades / expectativas
   - Estrategia engagement
 * - {ejemplo}
   - A
   - A
   - {ejemplo}
   - {ejemplo}

3. Matriz Influencia × Interés
==============================

::

  Alto interés  ┌──────────────┬──────────────┐
                │  Mantener    │  Gestionar   │
                │  informados  │  cercanamente│
                ├──────────────┼──────────────┤
  Bajo interés  │  Monitorear  │  Mantener    │
                │              │  satisfechos │
                └──────────────┴──────────────┘
                  Baja           Alta
                  influencia     influencia

4. Estrategia de comunicación
=============================

Por cada stakeholder/grupo: frecuencia, canal, formato del
mensaje, responsable.

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``ba-elicitation`` (BABOK)
 * - **Templates relacionados**
   - :doc:`tpl-pc-project-charter`, :doc:`tpl-breq-objetivos-negocio`
