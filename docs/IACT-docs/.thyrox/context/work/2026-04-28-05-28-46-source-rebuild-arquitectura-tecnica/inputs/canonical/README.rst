Arquitectura del Proyecto IACT
==============================

Este espacio documenta las decisiones arquitectónicas, patrones de
diseño, componentes del sistema y lineamientos técnicos del proyecto
IACT (Call Center Analytics).

Página padre
------------

-  `Índice de espacios documentales <../index.md>`__

Páginas hijas
-------------

-  `Lineamientos de código <lineamientos_codigo.md>`__
-  `Catálogo simplificado de patrones de
   diseño <patrones/DESIGN_PATTERNS_GUIDE.md>`__
-  `Architecture Decision Records (ADR) <adr/plantilla_adr.md>`__
-  `Backend - Arquitectura <../backend/arquitectura/README.md>`__
-  `Frontend - Arquitectura <../frontend/arquitectura/README.md>`__
-  `Infrastructure -
   Arquitectura <../infrastructure/arquitectura/README.md>`__

Información clave
-----------------

Visión Arquitectónica
~~~~~~~~~~~~~~~~~~~~~

**IACT** es una plataforma de analítica para centros de contacto
construida como monolito modular con las siguientes capas:

::

   ┌─────────────────────────────────────────┐
   │         Frontend (Futuro)               │
   │   React/Vue - Dashboards & Reports      │
   └─────────────────────────────────────────┘
                       ▼
   ┌─────────────────────────────────────────┐
   │         API Layer (Django REST)         │
   │   Endpoints para consultas analíticas   │
   └─────────────────────────────────────────┘
                       ▼
   ┌─────────────────────────────────────────┐
   │       Business Logic (Django)           │
   │   Procesamiento, transformación ETL     │
   └─────────────────────────────────────────┘
                       ▼
   ┌──────────────────┬──────────────────────┐
   │   PostgreSQL     │      MariaDB         │
   │   (Analytics)    │   (IVR Read-Only)    │
   └──────────────────┴──────────────────────┘

Stack Tecnológico
~~~~~~~~~~~~~~~~~

**Backend:** - **Framework**: Django 5.x - **Lenguaje**: Python 3.11+ -
**ORM**: Django ORM (multi-database) - **API**: Django REST Framework
(futuro)

**Bases de Datos:** - **PostgreSQL 15+**: Base de datos analítica
(puerto 15432) - Métricas procesadas - Datos agregados - Reportes
históricos - **MariaDB 10+**: Base de datos IVR (puerto 13306) - Solo
lectura - Datos operacionales del call center

**Infraestructura Local:** - **Virtualización**: Vagrant + VirtualBox 7
- **Aprovisionamiento**: Shell scripts (``provisioning/bootstrap.sh``) -
**Contenedores**: DevContainer para desarrollo

Principios Arquitectónicos
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Separación de Responsabilidades**

   -  Capa de datos separada (PostgreSQL vs MariaDB)
   -  Lógica de negocio independiente de presentación
   -  Infraestructura como código

2. **Escalabilidad Horizontal (Futuro)**

   -  Diseño permite migración a microservicios
   -  APIs RESTful stateless
   -  Cache distribuido (Redis - futuro)

3. **Seguridad por Diseño**

   -  Credenciales en variables de entorno
   -  Conexión a MariaDB en modo solo lectura
   -  Validación de inputs en todas las capas

4. **Observabilidad**

   -  Logging estructurado
   -  Métricas de performance
   -  Trazabilidad de errores

Patrones de Diseño
~~~~~~~~~~~~~~~~~~

-  **Repository Pattern**: Acceso a datos mediante repositorios
-  **Service Layer**: Lógica de negocio en servicios reutilizables
-  **DTO Pattern**: Transferencia de datos tipados
-  **Factory Pattern**: Creación de conexiones a bases de datos

Componentes Principales
~~~~~~~~~~~~~~~~~~~~~~~

1. **ETL Engine**

   -  Extracción desde MariaDB (IVR)
   -  Transformación y agregación
   -  Carga a PostgreSQL (Analytics)

2. **Analytics Core**

   -  Cálculo de KPIs
   -  Generación de reportes
   -  Agregaciones temporales

3. **API Gateway** (Futuro)

   -  Autenticación y autorización
   -  Rate limiting
   -  Versionado de APIs

Decisiones Arquitectónicas
~~~~~~~~~~~~~~~~~~~~~~~~~~

Las decisiones arquitectónicas significativas se documentan mediante
**Architecture Decision Records (ADR)**:

-  `ADR-2025-001: Vagrant +
   mod_wsgi <adr/adr_2025_001_vagrant_mod_wsgi.md>`__
-  `ADR-2025-002: Suite Completa de Calidad de
   Código <adr/adr_2025_002_suite_calidad_codigo.md>`__
-  `Plantilla ADR <adr/plantilla_adr.md>`__

Estado de cumplimiento
----------------------

+--------------------+----------------+-------------------------------+
| Elemento           | Estado         | Observaciones                 |
+====================+================+===============================+
| Diagrama de        | WARNING        | Diagrama ASCII incluido,      |
| arquitectura       | Parcial        | falta diagrama C4             |
+--------------------+----------------+-------------------------------+
| Stack tecnológico  | OK Sí          | Detallado en este documento   |
| documentado        |                |                               |
+--------------------+----------------+-------------------------------+
| ADRs de decisiones | WARNING        | Existe ADR-2025-001, faltan   |
| clave              | Parcial        | otros                         |
+--------------------+----------------+-------------------------------+
| Patrones de diseño | OK Sí          | Documentados arriba           |
| establecidos       |                |                               |
+--------------------+----------------+-------------------------------+

Acciones prioritarias
---------------------

-  ☐ Crear diagramas C4 (Context, Container, Component, Code)
-  ☐ Documentar estrategia de migración a microservicios
-  ☐ Establecer lineamientos de APIs REST
-  ☐ Definir estrategia de caching
-  ☐ Documentar proceso de deployment
-  ☐ Crear ADR para elección de Django vs FastAPI

Recursos relacionados
---------------------

-  `Requisitos del Sistema <../requisitos/README.md>`__
-  `Diseño Detallado <../diseno_detallado/README.md>`__
-  `DevOps <../devops/README.md>`__
-  `README principal <../../README.md>`__
