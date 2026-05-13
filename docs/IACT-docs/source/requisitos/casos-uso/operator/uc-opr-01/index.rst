.. meta::
 :artefacto: UC_OPR_01
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/operator
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critica
 :normativa: CNST-009, CNST-013, CNST-025

.. _uc-opr-01:

==============================================
UC_OPR_01 — Cambiar Estado del Agente
==============================================

Resumen
=======

Agente cambia su propio estado:
``available``, ``busy``, ``after_call_work``,
``break``, ``training``, ``offline``. Es la
accion mas frecuente del agente y determina
si recibe o no llamadas.

UC derivado del principio UML-06: la
perspectiva del agente como usuario de la
maquina, no la implementacion del routing
interno.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - implícita ``manage_own_agent_state``
     (auto-otorgada al rol agente)

Estructura de la spec
=====================

.. toctree::
 :maxdepth: 1
 :caption: Las 12 partes

 informacion-general
 actores-precondiciones
 flujo-principal
 flujos-alternos
 excepciones
 requisitos-no-funcionales
 datos-involucrados
 diagramas-uml
 criterios-aceptacion
 patrones-diseno
 implementacion-tecnica
 testing
