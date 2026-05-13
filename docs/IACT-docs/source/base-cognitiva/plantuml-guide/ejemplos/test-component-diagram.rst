.. meta::
 :artefacto: Test_Component_Diagram
 :tipo: Test/Ejemplo
 :dominio: plantuml-guide
 :subdominio: ejemplos
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-26
 :autor: Equipo IACT
 :clasificacion: Interno

================================================
Test: Component Diagram with Centralized Styling
================================================

:created: 2026-04-25 11:26:00
:project: IACT-docs
:phase: Phase 10 — EXECUTE
:feature: plantuml-java-integration-impl
:status: Test

Validations
===========

- OK !include path resolution (second diagram type)
- OK Style inheritance across diagram types
- OK Component and interface coloring
- OK Sphinx sphinxcontrib-plantuml integration

Diagram
=======

.. uml::

   !include ../../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: plantuml-guide
   ' type: component
   ' description: Test component diagram showing system architecture layers

   package "API Layer" {
     component [UserService]
     component [AuthService]
     component [NotificationService]
     interface "REST API" as rest
   }

   package "Database Layer" {
     component [MongoDB]
     component [Redis]
   }

   package "External Services" {
     component [EmailProvider]
     component [PaymentGateway]
   }

   UserService --> rest
   AuthService --> rest
   NotificationService --> rest
   UserService --> MongoDB
   AuthService --> Redis
   NotificationService --> EmailProvider
   PaymentGateway ..> MongoDB

Success Criteria
================

- OK File created in discover/test-component-diagram.rst
- OK !include path correct: ``!include ../../../_static/plantuml-styles.puml``
- OK Diagram contains 3 packages and 8 components with relationships
- OK Markup is well-formed
- OK Diagram syntax is valid PlantUML
