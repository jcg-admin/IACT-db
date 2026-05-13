.. meta::
 :artefacto: UC_ALR_05
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/alerts
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-001, CNST-002, CNST-008, CNST-009, CNST-013

.. _uc-alr-05:

==============================================
UC_ALR_05 — Gestionar Suscripciones
==============================================

Resumen
=======

CRUD de suscripciones a alertas: que User
recibe notificacion mailbox de que regla.
Personal (own) o admin (de otros).

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``manage_own_subscriptions``
     (implícita) +
     ``manage_user_subscriptions``
     (admin)

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
