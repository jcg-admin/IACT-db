.. meta::
 :artefacto: Test_Uc_Diagram
 :tipo: Test/Ejemplo
 :dominio: plantuml-guide
 :subdominio: ejemplos
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-26
 :autor: Equipo IACT
 :clasificacion: Interno

===============================================
Test: Use Case Diagram with Centralized Styling
===============================================

:created: 2026-04-25 11:25:00
:project: IACT-docs
:phase: Phase 10 — EXECUTE
:feature: plantuml-java-integration-impl
:status: Test

Validations
===========

- OK !include path resolution from discover/ to _static/
- OK Actor and UseCase color application
- OK Sphinx sphinxcontrib-plantuml integration
- OK Diagram compiles without PlantUML errors

Diagram
=======

.. uml::

   !include ../../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: plantuml-guide
   ' type: use-case
   ' description: Test use case diagram with actors and system interactions

   actor "Student" as student
   actor "Instructor" as instructor
   actor "Administrator" as admin

   usecase "Submit Assignment" as submit
   usecase "Grade Assignment" as grade
   usecase "View Results" as results
   usecase "Manage Courses" as manage

   student --> submit
   student --> results
   instructor --> grade
   instructor --> manage
   admin --> manage

Success Criteria
================

- OK File created in discover/test-uc-diagram.rst
- OK PlantUML block contains !include with correct path: ``!include ../../../_static/plantuml-styles.puml``
- OK Diagram contains 3-5 actors (4 total: student, instructor, admin) and 4 use cases
- OK Markup is well-formed (Sphinx parseable)
- OK Diagram syntax is valid PlantUML
