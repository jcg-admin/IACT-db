.. meta::
   :artefacto: META_01
   :tipo: Identidad
   :dominio: base_cognitiva
   :subdominio: _metadata
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-18
   :ultimo_cambio: 2025-12-18
   :autor: PMO IACT
   :clasificacion: Interno

.. _meta_01_identidad_proyecto:

==========================================================
META_01 · Identidad del Proyecto
==========================================================

.. contents:: Contenido
   :local:
   :depth: 2

------------------------------------------------------------
1. Identificación Oficial
------------------------------------------------------------

.. list-table:: Datos de Identificación
   :widths: 30 70
   :header-rows: 0
   :stub-columns: 1

   * - **Nombre Oficial**
     - IVR Analytics & Customer Tracking (IACT)
   * - **Código Proyecto**
     - IACT-2025
   * - **Acrónimo**
     - IACT
   * - **Versión Sistema**
     - 1.0.0-dev
   * - **Fecha Inicio**
     - 2025-01-15
   * - **Estado Actual**
     - En Desarrollo (Fase Elaboration)

------------------------------------------------------------
2. Descripción del Proyecto
------------------------------------------------------------

2.1. Descripción Ejecutiva
^^^^^^^^^^^^^^^^^^^^^^^^^^

IACT (IVR Analytics & Customer Tracking) es un sistema integral de análisis
y seguimiento para operaciones de centro de contacto basadas en IVR (Interactive
Voice Response). El sistema captura, procesa y presenta métricas de interacción
cliente-IVR, habilitando toma de decisiones basada en datos.

2.2. Descripción Técnica
^^^^^^^^^^^^^^^^^^^^^^^^

Sistema web compuesto por:

- **Backend:** Django REST Framework (Python 3.11+)
- **Frontend:** React 18+ con TypeScript
- **Base de Datos:** PostgreSQL 15+
- **Cache:** NO Redis
- **Mensajería:** NO Celery para tareas asíncronas

El sistema expone APIs RESTful para integración con plataformas IVR externas
y provee dashboards analíticos en tiempo real.

------------------------------------------------------------
3. Alcance del Proyecto
------------------------------------------------------------

3.1. Dentro del Alcance (In-Scope)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Captura de eventos de interacción IVR (llamadas, menús, transferencias)
- Procesamiento y almacenamiento de métricas de llamada
- Dashboards analíticos configurables
- Reportes exportables (PDF, Excel, CSV)
- Gestión de usuarios y roles con autenticación JWT
- APIs de integración para sistemas IVR de terceros
- Alertas y notificaciones basadas en umbrales
- Auditoría de acciones de usuario

3.2. Fuera del Alcance (Out-of-Scope)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Desarrollo o modificación de plataformas IVR
- Grabación de audio de llamadas
- Transcripción de voz (speech-to-text)
- Procesamiento de lenguaje natural en tiempo real
- CRM o gestión de clientes
- Facturación o billing

------------------------------------------------------------
4. Objetivos del Proyecto
------------------------------------------------------------

4.1. Objetivo General
^^^^^^^^^^^^^^^^^^^^^

Proveer una plataforma analítica que permita a operadores de centros de
contacto comprender, medir y optimizar las interacciones de clientes
con sistemas IVR.

4.2. Objetivos Específicos
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 5 95
   :header-rows: 0

   * - O1
     - Reducir tiempo medio de análisis de métricas IVR de horas a minutos
   * - O2
     - Centralizar datos de múltiples fuentes IVR en una única plataforma
   * - O3
     - Habilitar detección temprana de cuellos de botella en flujos IVR
   * - O4
     - Proveer visibilidad ejecutiva mediante dashboards de alto nivel
   * - O5
     - Cumplir con requisitos de auditoría y trazabilidad de datos

------------------------------------------------------------
5. Stakeholders Principales
------------------------------------------------------------

.. list-table::
   :widths: 25 25 50
   :header-rows: 1

   * - Rol
     - Área
     - Interés Principal
   * - Sponsor Ejecutivo
     - Dirección de Operaciones
     - ROI, alineación estratégica
   * - Product Owner
     - PMO
     - Alcance, priorización, entrega de valor
   * - Gerente de Contact Center
     - Operaciones
     - Métricas operativas, eficiencia
   * - Analista de Datos
     - Business Intelligence
     - Calidad de datos, reportes
   * - Administrador de Sistemas
     - TI/Infraestructura
     - Despliegue, disponibilidad, seguridad
   * - Usuario Final (Supervisor)
     - Contact Center
     - Usabilidad, acceso a información

------------------------------------------------------------
6. Restricciones y Supuestos
------------------------------------------------------------

6.1. Restricciones
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 0

   * - R1
     - Presupuesto limitado a equipo de desarrollo interno (sin contratación externa)
   * - R2
     - Infraestructura debe ser on-premise (no cloud público)
   * - R3
     - Compatibilidad con navegadores: Chrome 90+, Firefox 88+, Edge 90+
   * - R4
     - Cumplimiento con políticas de seguridad corporativas vigentes

6.2. Supuestos
^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 90
   :header-rows: 0

   * - S1
     - Las plataformas IVR existentes proveen APIs de exportación de eventos
   * - S2
     - El equipo de infraestructura provee ambiente de desarrollo y staging
   * - S3
     - Los usuarios finales tienen experiencia básica con herramientas web
   * - S4
     - Disponibilidad de SMEs de Contact Center para validación de requisitos

------------------------------------------------------------
7. Referencias
------------------------------------------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Documento
     - Referencia
   * - Clasificación Documental
     - :doc:`META_02_Clasificacion_Documental`
   * - Fases SDLC
     - :doc:`META_03_Fases_SDLC`
   * - Contexto IACT
     - :doc:`META_04_Contexto_IACT`
   * - Estructura Documental
     - :doc:`META_05_Estructura_Documental`

------------------------------------------------------------
Historial de Cambios
------------------------------------------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-18
     - PMO IACT
     - Versión inicial aprobada

----

**Trazabilidad:** Este artefacto es referenciado por reportes, actas y
documentos externos del proyecto. Ver :doc:`/trazabilidad/matrices/RTM_Master`.