.. meta::
 :artefacto: TPL_RS
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================================
TPL_RS: Plantilla de Requisito de Stakeholder
==============================================

.. note::

 Plantilla BABOK para Requisitos de Stakeholder (RS). Captura
 lo que un stakeholder específico necesita del producto. Es
 input para derivar requisitos de negocio (BR) y funcionales
 (FR). Aplica skill ``ba-requirements-analysis``.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - RS-{NNN}-{descripcion}
 * - **Stakeholder origen**
   - {nombre / rol}
 * - **Prioridad**
   - Alta / Media / Baja
 * - **Estado**
   - Borrador / Aprobado / Implementado

2. Necesidad expresada
======================

Cita textual del stakeholder o resumen de la entrevista. Mantener
el lenguaje original cuando sea posible.

3. Análisis
===========

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **Tipo**
   - funcional / no funcional / restricción
 * - **Trazabilidad upward**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio` o BReq que motiva
 * - **Trazabilidad downward**
   - :doc:`tpl-fr-requisitos-funcionales` derivados

4. Criterios de aceptación
==========================

Condiciones que deben cumplirse para que el stakeholder considere
satisfecha la necesidad.

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``ba-requirements-analysis`` (BABOK)
 * - **Templates relacionados**
   - :doc:`tpl-stk-stakeholder-analysis`, :doc:`tpl-breq-objetivos-negocio`
