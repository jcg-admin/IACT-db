.. meta::
 :artefacto: INDEX_EJEMPLOS_PEDAGOGICOS
 :tipo: Indice
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

=====================================
Ejemplos Pedagógicos del Proceso SDLC
=====================================

Esta sección contiene **sagas pedagógicas completas** que aplican
el proceso documental SDLC del proyecto IACT a features
hipotéticas de extremo a extremo. Cada saga muestra cómo se
generan los artefactos en cada fase del proceso, con referencias
cruzadas funcionales entre ellos.

Propósito
=========

Las sagas pedagógicas sirven para:

1. **Aprender el método** observando un caso aplicado completo,
   no solo lectura de templates abstractos.
2. **Validar el proceso** end-to-end — si al recorrer la saga se
   detecta un gap, eso es feedback al método.
3. **Demostrar trazabilidad** entre artefactos: cada documento
   referencia los anteriores, evidenciando el hilo conductor del
   SDLC.
4. **Ejemplificar las skills aplicadas** en cada fase. Cada
   artefacto declara con metadata ``:skill_aplicada:`` cuál de
   las skills del proyecto lo guía.

Sagas disponibles
=================

.. toctree::
 :maxdepth: 1

 ejemplo-dark-mode/index

Convención
==========

- Cada saga vive en un subdirectorio propio:
  ``ejemplo-{nombre-feature}/``.
- Los archivos siguen STD-007 (kebab-lowercase universal).
- Cada artefacto incluye en su metadata:

  * ``:skill_aplicada:`` — skill primario que guía su contenido
    (ej. ``ba-elicitation``, ``rm-specification``,
    ``bpa-design``).
  * ``:fase_sdlc:`` — fase del proceso al que pertenece
    (ej. ``descubrimiento``, ``análisis``, ``diseño``,
    ``implementación``, ``pruebas``, ``release``).
  * ``:saga:`` — nombre de la saga a la que pertenece (para
    búsqueda cruzada).

Trazabilidad
============

- Estas sagas son referenciadas desde
  :doc:`/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates`
  como ejemplos del proceso documental.
- Aplican los templates declarados en
  :doc:`/normativa/estandares/std-007-convencion-naming` y siguen
  la jerarquía de :doc:`/base-cognitiva/_metadata/meta-03-fases-sdlc`.
