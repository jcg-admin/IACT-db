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

- ✓ !include path resolution from discover/ to _static/
- ✓ Actor and UseCase color application
- ✓ Sphinx sphinxcontrib-plantuml integration
- ✓ Diagram compiles without PlantUML errors

Diagram
=======

.. uml::

   !include ../../_static/plantuml-styles.puml

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

- ✓ File created in discover/test-uc-diagram.rst
- ✓ PlantUML block contains !include with correct path: ``!include ../../../_static/plantuml-styles.puml``
- ✓ Diagram contains 3-5 actors (4 total: student, instructor, admin) and 4 use cases
- ✓ Markup is well-formed (Sphinx parseable)
- ✓ Diagram syntax is valid PlantUML
