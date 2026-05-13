########################################################################
Sistema IACT - Interactive Analytics & Customer Tracking
########################################################################

Información del Proyecto
=========================

**Nombre del Proyecto:** Sistema IACT

**Código del Proyecto:** IACT-2025-001

**Versión de la Documentación:** 1.0.0

**Fecha de Inicio:** Octubre 2025

**Estado:** En Desarrollo Activo

**Organización:** [Nombre de tu Empresa]


Descripción del Sistema
========================

El Sistema IACT (Interactive Analytics & Customer Tracking) es una plataforma
empresarial diseñada para el análisis y seguimiento de interacciones con
clientes en el contexto de operaciones de call center y contact center.

El sistema proporciona:

* Registro y seguimiento de llamadas telefónicas
* Análisis de métricas operacionales y de servicio
* Generación de reportes y dashboards ejecutivos
* Sistema de alertas y notificaciones internas
* Gestión avanzada de permisos mediante RBAC
* Auditoría completa de operaciones

Arquitectura del Sistema
=========================

Componentes Principales
-----------------------

**Frontend Web**

* Interfaz de usuario responsive
* Dashboard interactivo
* Formularios de registro de llamadas

**API Backend**

* Django 4.x con Django REST Framework
* Autenticación JWT
* Control de acceso basado en funciones (RBAC)

**Base de Datos**

* Base de datos Analytics (lectura/escritura)
* Base de datos IVR (solo lectura)
* Arquitectura dual para separación de responsabilidades

**Motor de Reportes**

* Generación de reportes en múltiples formatos (CSV, Excel, PDF)
* Consultas parametrizadas y filtros avanzados
* KPIs y métricas predefinidas

**Pipeline ETL**

* Extracción de datos del sistema IVR
* Transformación y normalización
* Carga periódica (6-12 horas)
* Monitoreo de estado del proceso

Integraciones
-------------

El sistema se integra con:

* Sistema Telefónico PBX/IVR (datos de llamadas)
* CRM Externo (sincronización de interacciones)
* Sistema de Envíos (consulta de tracking)
* Servicio de Mensajería Interna (notificaciones)


Stack Tecnológico
=================

Backend
-------

* Python 3.11
* Django 4.x
* Django REST Framework
* MySQL/PostgreSQL
* APScheduler (programación de tareas)

Frontend
--------

* HTML5, CSS3, JavaScript
* Framework de componentes (a definir)
* Librerías de visualización de datos

Infraestructura
---------------

* Docker y Docker Compose
* Kubernetes (producción)
* Nginx (servidor web)
* Git (control de versiones)

Herramientas de Desarrollo
---------------------------

* Sphinx 8.2.3 (documentación)
* pytest (testing)
* Black, Flake8, isort (calidad de código)
* Bandit, Semgrep (seguridad)


Documentación del Proyecto
===========================

Esta es la documentación técnica oficial del Sistema IACT, construida con
Sphinx y organizada en las siguientes secciones principales:

**Arquitectura Técnica**

* Diseño de la arquitectura del sistema
* Diagramas de componentes y despliegue
* Especificaciones técnicas detalladas

**Base Cognitiva**

* Glosarios (BABOK, PMBOK, ISO)
* Ontologías SBVR
* Taxonomías y metamodelos
* Fundamentos conceptuales

**Gestión del Proyecto**

* Manuales de usuario
* Evidencia de gestión de proyectos
* Plantillas de ADR (Architecture Decision Records)

**Normativa**

* Estándares aplicables
* Restricciones del sistema (CNST)
* Procedimientos y gobernanza

**Requisitos**

* Casos de uso
* Requisitos funcionales y no funcionales
* Reglas de negocio
* Matriz de trazabilidad (RTM)


Estructura del Repositorio
===========================

La documentación está organizada de la siguiente manera:

::

    documentación/
    ├── source/                 # Archivos fuente de la documentación
    │   ├── arquitectura_tecnica/
    │   ├── base_cognitiva/
    │   ├── gestion/
    │   ├── normativa/
    │   ├── requisitos/
    │   ├── _static/           # Recursos estáticos (CSS, JS, imágenes)
    │   ├── _templates/        # Plantillas personalizadas
    │   ├── conf.py            # Configuración de Sphinx
    │   └── index.rst          # Índice principal
    ├── build/                  # Salida generada
    │   └── html/              # Documentación HTML
    ├── requirements.txt        # Dependencias Python
    ├── Makefile               # Comandos de construcción
    ├── authors.rst            # Equipo del proyecto
    ├── licence.rst            # Información legal
    └── readme.rst             # Este archivo


Convenciones de Documentación
==============================

Formato reStructuredText
------------------------

Esta documentación utiliza reStructuredText (reST) como lenguaje de marcado,
con soporte para Markdown mediante MyST Parser.

Jerarquía de Encabezados
-------------------------

La estructura de encabezados sigue las convenciones de Sphinx:

* Nivel 1 (Partes): # con línea superior e inferior
* Nivel 2 (Capítulos): asteriscos con línea superior e inferior
* Nivel 3 (Secciones): signos igual
* Nivel 4 (Subsecciones): guiones
* Nivel 5 (Sub-subsecciones): acentos circunflejos
* Nivel 6 (Párrafos): comillas dobles

Directivas Include
------------------

Se utiliza frecuentemente la directiva ``include`` para reutilizar contenido
entre diferentes secciones. La interpretación de los niveles de encabezado
es relativa al archivo que incluye el contenido, no al archivo incluido.


Construcción de la Documentación
=================================

Requisitos Previos
------------------

Antes de construir la documentación, asegúrese de tener instalado:

1. Python 3.11 o superior
2. pip (gestor de paquetes de Python)
3. Entorno virtual (recomendado)

Instalación de Dependencias
----------------------------

**Nota de compatibilidad (Sphinx 9):**

Este repositorio usa ``Sphinx>=9,<10``. La migración fue posible al eliminar
``autodocsumm==0.2.14`` (incompatible con Sphinx 9), sustituyéndolo por el
``sphinx.ext.autosummary`` nativo que ya estaba configurado en ``conf.py``.

Para Windows (Git Bash):

.. code-block:: bash

    python -m venv .venv
    source .venv/Scripts/activate
    pip install -r requirements.txt

Para Linux/macOS:

.. code-block:: bash

    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt

Construcción HTML
-----------------

Para generar la documentación HTML:

.. code-block:: bash

    make html

Los archivos generados estarán en ``build/html/``

Desarrollo con Live Reload
---------------------------

Para desarrollo activo con recarga automática:

.. code-block:: bash

    make livehtml

Esto iniciará un servidor local con recarga automática al detectar cambios.

Otros Formatos
--------------

* **PDF:** ``make latexpdf``
* **ePub:** ``make epub``
* **Texto plano:** ``make text``

Validación
----------

Para validar enlaces externos:

.. code-block:: bash

    make linkcheck

Para limpiar archivos generados:

.. code-block:: bash

    make clean


Modelo de Control de Acceso (RBAC)
===================================

El sistema implementa un modelo RBAC (Role-Based Access Control) avanzado:

**Filosofía: Sin Pretensiones**

* Las funciones describen acciones, no títulos jerárquicos
* Nomenclatura descriptiva: ``crea_usuarios``, ``ve_reportes``, ``exporta_csv``

**Estructura**

* 8 módulos funcionales
* 44 funciones atómicas
* 10 agrupadores de funciones comunes
* 3 restricciones de separación de funciones (SoD)
* 5 segmentos de datos

**Documentación Completa**

Consultar la sección ``normativa/`` para detalles completos del modelo RBAC v5.1.1


Restricciones del Sistema
==========================

El sistema opera bajo un conjunto de restricciones técnicas y de negocio críticas:

**Restricciones No Negociables (CNST)**

* CNST_001: Prohibido envío de correos electrónicos
* CNST_002: Sesión única por usuario, timeout 15 minutos
* CNST_003: Base de datos IVR estrictamente en modo solo lectura
* CNST_004: Alertas únicamente por buzón interno
* CNST_005: Modelo RBAC plano con separación de funciones (SoD)
* CNST_006: Rango máximo de reportes: 2 años
* CNST_007: Límites de exportación y throttling
* CNST_008: Auditoría inmutable, logs sin PII

**Documentación Completa**

Consultar ``normativa/restricciones/`` para el documento completo de restricciones.


Seguridad y Cumplimiento
=========================

Estándares Aplicados
--------------------

* Django Security Best Practices
* DRF Secure Code Checklist
* OWASP Top 10
* NIST RBAC
* ISO 27001 (controles relevantes)

Prácticas de Seguridad
----------------------

* Autenticación JWT con tokens de acceso y refresco
* Control de acceso basado en funciones (RBAC)
* Separación de funciones (SoD)
* Auditoría completa e inmutable
* Throttling y rate limiting
* Validación exhaustiva de entradas
* Cifrado en tránsito (HTTPS)

Dependencias
------------

* SBOM (Software Bill of Materials) generado
* Escaneo continuo de vulnerabilidades
* Sin CVE High/Critical en producción


Contacto y Soporte
==================

Equipo del Proyecto
-------------------

* **Líder Técnico:** [nombre@empresa.com]
* **Arquitecto de Software:** [nombre@empresa.com]
* **Equipo de Desarrollo:** [dev-iact@empresa.com]
* **Documentación:** [docs-iact@empresa.com]

Canales de Comunicación
------------------------

* **Repositorio Git:** [URL del repositorio interno]
* **Sistema de Tickets:** [URL del sistema de tickets]
* **Wiki del Proyecto:** [URL de la wiki interna]
* **Chat del Equipo:** [Canal de Slack/Teams]

Horario de Soporte
------------------

* **Soporte Técnico:** Lunes a Viernes, 9:00 - 18:00
* **Incidentes Críticos:** 24/7 (on-call rotation)


Historial de Versiones
=======================

**Versión 1.0.0** (Enero 2026)

* Documentación inicial del proyecto
* Especificación completa de requisitos (SRS v2.0)
* Modelo RBAC v5.1.1 implementado
* Restricciones del sistema (CNST) documentadas
* Arquitectura técnica definida

**Versión 0.9.0** (Diciembre 2025)

* Fase de diseño y planificación
* Análisis de restricciones de negocio
* Definición de casos de uso
* Modelado de base de datos

**Versión 0.5.0** (Noviembre 2025)

* Análisis de requisitos iniciales
* Estudio de viabilidad
* Selección de stack tecnológico


Licencia y Confidencialidad
============================

Este sistema y su documentación son propiedad exclusiva de [Nombre de tu Empresa].

Toda la información contenida es confidencial y está protegida por:

* Acuerdos de confidencialidad de empleados
* Políticas de seguridad de la información
* Contratos de no divulgación con terceros
* Legislación aplicable

Para más información, consultar el archivo ``licence.rst``


Notas Finales
=============

Esta documentación es un documento vivo que se actualiza continuamente a medida
que el proyecto avanza. Se recomienda revisar el registro de cambios periódicamente
para mantenerse al día con las actualizaciones más recientes.

Todo el personal que accede a esta documentación debe cumplir con las políticas
de seguridad de la información y los acuerdos de confidencialidad de la empresa.

Para contribuciones o correcciones a la documentación, seguir el proceso de
control de cambios establecido en el sistema de gestión del proyecto.
