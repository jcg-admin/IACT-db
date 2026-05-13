.. _requisitos:

==========
Requisitos
==========

Propósito del Dominio
=====================

El dominio **Requisitos** define el producto funcional del sistema IACT, 
especificando qué debe hacer el sistema para satisfacer las necesidades del negocio.

Este dominio responde a la pregunta fundamental: **"¿Qué debe hacer el sistema?"**

Contenido
=========

Los requisitos establecen:

* **Reglas de Negocio:** Políticas, restricciones y principios que rigen el sistema
* **Casos de Uso:** Interacciones entre actores y el sistema para lograr objetivos
* **Requisitos Funcionales:** Funcionalidades específicas que debe implementar el sistema
* **Requisitos No Funcionales:** Atributos de calidad (rendimiento, seguridad, usabilidad)
* **Matriz de Trazabilidad:** Relaciones entre requisitos para garantizar coherencia

Jerarquía de Requisitos
=======================

La trazabilidad sigue el modelo:

**BR (Reglas de Negocio) → UC (Casos de Uso) → FR (Requisitos Funcionales) → RNF (Requisitos No Funcionales)**

Subdominios
===========

.. toctree::
   :maxdepth: 2

   reglas_negocio/index
   casos_uso/index
   requisitos_funcionales/index
   requisitos_no_funcionales/index
   rtm/index
   objetivos/index

.. note::
   Todos los requisitos deben estar vinculados en la Matriz de Trazabilidad (RTM) 
   para garantizar la coherencia y facilitar el análisis de impacto de cambios.
