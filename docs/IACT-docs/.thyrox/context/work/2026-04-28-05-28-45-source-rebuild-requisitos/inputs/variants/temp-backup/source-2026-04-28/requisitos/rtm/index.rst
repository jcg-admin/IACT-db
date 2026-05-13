.. _rtm:

======================
Matriz de Trazabilidad
======================

Propósito
=========

Este subdominio contiene la **Matriz de Trazabilidad de Requisitos (RTM)** del proyecto IACT, 
documentando las relaciones entre reglas de negocio, casos de uso y requisitos.

La RTM garantiza que todos los requisitos estén justificados y permite analizar 
el impacto de cambios en el sistema.

Contenido
=========

La matriz de trazabilidad documenta:

* Relaciones BR → UC (qué casos de uso implementan cada regla)
* Relaciones UC → FR (qué requisitos funcionales derivan de cada caso de uso)
* Relaciones FR → RNF (qué requisitos no funcionales afectan cada funcionalidad)
* Cobertura de requisitos
* Análisis de impacto de cambios

Jerarquía
=========

La trazabilidad sigue el flujo:

**BR** (Reglas de Negocio) → **UC** (Casos de Uso) → **FR** (Requisitos Funcionales) → **RNF** (Requisitos No Funcionales)

Prefijo
=======

Los artefactos de este subdominio usan el prefijo **RTM_**.

Ejemplo: ``RTM_Master_v1_0_0.rst``

.. note::
   Contenido en desarrollo. La matriz de trazabilidad se mantendrá actualizada 
   conforme se agreguen y modifiquen requisitos.
