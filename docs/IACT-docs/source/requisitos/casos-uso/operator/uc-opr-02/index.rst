.. meta::
 :artefacto: UC_OPR_02
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

.. _uc-opr-02:

==============================================
UC_OPR_02 — Atender Llamada Entrante
==============================================

Resumen: agente recibe llamada entrante
ofrecida por el routing y la acepta.
Estado pasa a busy automaticamente
(UC_OPR_01 FA-01).

.. list-table::

 * - **Funcion RBAC**
   - implícita ``answer_inbound_calls``

.. toctree::
 :maxdepth: 1

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
