.. meta::
   :project: IACT - Sistema de Dashboard Analytics
   :version: 1.0.0
   :date: 2026-04-25
   :status: Validado
   :feature: plantuml-java-integration-impl

=====================================================
Ejemplo: Diagrama de Arquitectura de Sistema Completo
=====================================================

Propósito
=========

Este ejemplo muestra la arquitectura completa del IACT con todos los componentes principales, sus interconexiones y flujos de datos, utilizando el sistema de estilos centralizados de PlantUML.

Arquitectura
============

.. uml::
   :caption: IACT - Arquitectura de Sistema Completo

   @startuml IACT-Architecture
   !include ../../_static/plantuml-styles.puml

   ' @IACT-DIAGRAM
   ' module: plantuml-guide
   ' type: component
   ' description: Complete IACT system architecture with all layers

   skinparam BackgroundColor white

   package "Data Sources" {
     component [MySQL IVR\n(Read-Only)] as mysql
     note right of mysql : Operational Data\nReal-time activity
   }

   package "ETL Pipeline" {
     component [Extract] as extract
     component [Transform] as transform
     component [Validate] as validate
     component [Load] as load
   }

   package "Analytical Database" {
     component [PostgreSQL\nAnalytics] as postgres
     note right of postgres : Optimized for\nAnalytical Queries
   }

   package "Application Layer" {
     component [Django REST\nBackend] as django
     component [API Gateway] as gateway
   }

   package "Client Layer" {
     component [React\nDashboard] as react
     note right of react : Interactive UI\nReal-time Charts
   }

   package "Infrastructure" {
     component [Logging &\nMonitoring] as logging
     component [Authentication\nService] as auth
   }

   ' Connections
   mysql --> extract : Read Data
   extract --> transform : Raw Events
   transform --> validate : Transformed Data
   validate --> load : Validated Events
   load --> postgres : Store Analytics

   postgres --> django : Query Analytics
   django --> gateway : REST Endpoints
   gateway --> react : JSON Response

   react --> auth : Authenticate
   auth --> gateway : Verify Token

   django -.-> logging : Log Events
   extract -.-> logging : ETL Status
   postgres -.-> logging : Query Performance

   @enduml

Componentes Principales
=======================

1. **Data Sources (MySQL IVR)**
   - Base de datos operacional
   - Acceso read-only por CNST-003
   - Datos en tiempo real de actividades

2. **ETL Pipeline**
   - Extract: Lee desde MySQL IVR
   - Transform: Aplica reglas de negocio
   - Validate: Verifica integridad de datos
   - Load: Escribe en PostgreSQL Analytics

3. **Analytical Database (PostgreSQL)**
   - Optimizado para consultas analíticas
   - Índices y particiones para performance
   - Respaldo inmutable por CNST-003

4. **Application Layer (Django REST)**
   - API REST completa
   - Gestión de autenticación
   - Control de acceso (RBAC)
   - Logging inmutable (CNST-009)

5. **Client Layer (React Dashboard)**
   - Dashboard interactivo
   - Gráficos en tiempo real
   - Exportación de reportes

6. **Infrastructure**
   - Logging centralizado y auditado
   - Servicio de autenticación
   - Monitoreo del sistema

Flujos de Datos
===============

**Flujo Primario (Escribir):**

.. code-block:: text

   MySQL IVR → Extract → Transform → Validate → Load → PostgreSQL

**Flujo Secundario (Leer):**

.. code-block:: text

   PostgreSQL → Django API → React Dashboard → User

**Flujo de Seguridad:**

.. code-block:: text

   User → Auth Service → Token → Django API → RBAC Check → Data Access

Validación
==========

Este ejemplo demuestra:

- ✓ Componentes con colores semánticos (verde=datos, azul=interfaces, etc.)
- ✓ Flujos de datos directos e indirectos
- ✓ Arquitectura de 3 capas (datos, aplicación, cliente)
- ✓ Decisiones arquitectónicas (read-only MySQL, PostgreSQL analítico)
- ✓ Conformidad con restricciones del proyecto (CNST-003, CNST-009)

Referencias
===========

Ver documentación relacionada:
- :doc:`../GUIDELINES` — Guía de uso de estilos
- :doc:`../color-palette` — Convenciones de colores
- :ref:`arquitectura-tecnica` — Detalles de arquitectura
- :ref:`requisitos` — Casos de uso funcionales
