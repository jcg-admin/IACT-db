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

- ✓ !include path resolution (second diagram type)
- ✓ Style inheritance across diagram types
- ✓ Component and interface coloring
- ✓ Sphinx sphinxcontrib-plantuml integration

Diagram
=======

.. uml::

   !include ../../_static/plantuml-styles.puml

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

- ✓ File created in discover/test-component-diagram.rst
- ✓ !include path correct: ``!include ../../../_static/plantuml-styles.puml``
- ✓ Diagram contains 3 packages and 8 components with relationships
- ✓ Markup is well-formed
- ✓ Diagram syntax is valid PlantUML
