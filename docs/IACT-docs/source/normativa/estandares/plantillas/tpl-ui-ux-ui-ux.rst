.. meta::
 :artefacto: TPL_UI_UX
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
TPL_UI_UX: Plantilla de Diseño UI/UX
==========================================

.. note::

 Plantilla para documentar decisiones de diseño UI/UX. Aplica
 skill ``ba-solution-evaluation`` + skills frontend específicas.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Pantalla / Feature**
   - {nombre}
 * - **UC asociado**
   - ``/requisitos/casos-uso/{módulo}/{uc}`` (ruta del UC parent)
 * - **Designer**
   - {nombre}

2. Wireframes / Mockups
=======================

Insertar imágenes desde ``source/_static/img/``:

::

  .. image:: /_static/img/wireframe-{feature}.png
     :alt: Wireframe de {feature}

3. User flow
============

Diagrama del flujo de interacción del usuario. PlantUML
recomendado.

4. Componentes UI
=================

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Componente
   - Tipo
   - Comportamiento
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

5. Accesibilidad (WCAG AA)
==========================

- Contraste mínimo 4.5:1 (texto normal).
- Navegable con teclado.
- ARIA labels.
- Soporte screen reader.

6. Responsive
=============

Breakpoints, layouts por viewport, mobile-first o desktop-first.

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``ba-solution-evaluation`` + ``frontend-react``
 * - **Templates relacionados**
   - :doc:`tpl-uc-ui-driven`, :doc:`tpl-sad-arquitectura-software`
