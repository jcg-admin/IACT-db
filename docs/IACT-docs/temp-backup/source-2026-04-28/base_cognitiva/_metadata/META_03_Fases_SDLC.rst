.. meta::
   :artefacto: META_03
   :tipo: Ciclo de Vida
   :dominio: base_cognitiva
   :subdominio: _metadata
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-18
   :ultimo_cambio: 2025-12-18
   :autor: PMO IACT
   :clasificacion: Interno

.. _meta-03:
.. _meta_03_fases_sdlc:

========================================
META_03 · Fases del Ciclo de Vida (SDLC)
========================================

1. Propósito
------------

Este documento define las fases del ciclo de vida de desarrollo de software
(SDLC) adoptadas por el proyecto IACT, estableciendo el marco temporal y
metodológico que contextualiza toda la documentación del sistema.

--------------------------
2. Modelo de Ciclo de Vida
--------------------------

El proyecto IACT adopta un modelo iterativo e incremental basado en
Rational Unified Process (RUP), adaptado a las necesidades del equipo
y la organización.

2.1. Justificación del Modelo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Permite refinamiento progresivo de requisitos.
- Reduce riesgo mediante entregas incrementales.
- Facilita retroalimentación temprana de stakeholders.
- Compatible con prácticas ágiles dentro de cada iteración.

---------------------
3. Fases del Proyecto
---------------------

3.1. Visión General
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 15 65
   :header-rows: 1

   * - Fase
     - Duración Est.
     - Objetivo Principal
   * - Inception
     - 4 semanas
     - Establecer visión, alcance y viabilidad del proyecto.
   * - Elaboration
     - 8 semanas
     - Definir arquitectura base y mitigar riesgos técnicos principales.
   * - Construction
     - 16 semanas
     - Desarrollar el sistema completo de forma incremental.
   * - Transition
     - 4 semanas
     - Desplegar en producción y transferir a operaciones.

3.2. Fase: Inception
^^^^^^^^^^^^^^^^^^^^

**Objetivo:** Establecer el caso de negocio y delimitar el alcance del proyecto.

**Criterios de Entrada:**

- Aprobación de sponsor para iniciar proyecto.
- Recursos iniciales asignados.

**Actividades Principales:**

- Identificación de stakeholders y sus necesidades.
- Definición de visión y alcance del producto.
- Elaboración de caso de negocio preliminar.
- Identificación de riesgos críticos.
- Estimación inicial de esfuerzo y cronograma.

**Artefactos Clave:**

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - Artefacto
     - Dominio IACT
   * - META_01_Identidad_Proyecto
     - base_cognitiva/_metadata/
   * - Visión del Producto
     - requisitos/vision/
   * - Lista inicial de Stakeholders
     - base_cognitiva/_metadata/
   * - Riesgos identificados
     - (gestión de proyecto)

**Criterios de Salida (Milestone: Lifecycle Objectives):**

- Alcance acordado con stakeholders.
- Riesgos críticos identificados.
- Caso de negocio aprobado.
- Go/No-Go para continuar a Elaboration.

3.3. Fase: Elaboration
^^^^^^^^^^^^^^^^^^^^^^

**Objetivo:** Establecer la arquitectura del sistema y reducir riesgos técnicos.

**Criterios de Entrada:**

- Milestone LCO aprobado.
- Equipo técnico conformado.

**Actividades Principales:**

- Captura detallada de requisitos funcionales y no funcionales.
- Definición de arquitectura de referencia.
- Desarrollo de prototipos arquitectónicos.
- Refinamiento de estimaciones.
- Planificación detallada de Construction.

**Artefactos Clave:**

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - Artefacto
     - Dominio IACT
   * - Reglas de Negocio (BR_xxx)
     - requisitos/reglas_negocio/
   * - Casos de Uso (UC_xxx)
     - requisitos/casos_uso/
   * - Requisitos Funcionales (FR_xxx)
     - requisitos/funcionales/
   * - Documento de Arquitectura (SAD)
     - arquitectura_tecnica/arquitectura/
   * - ADRs iniciales
     - arquitectura_tecnica/arquitectura/decisiones/

**Criterios de Salida (Milestone: Lifecycle Architecture):**

- Arquitectura de referencia estable.
- Riesgos técnicos principales mitigados.
- 80% de requisitos capturados.
- Plan de Construction aprobado.

3.4. Fase: Construction
^^^^^^^^^^^^^^^^^^^^^^^

**Objetivo:** Desarrollar el sistema completo con calidad de producción.

**Criterios de Entrada:**

- Milestone LCA aprobado.
- Arquitectura base implementada.
- Ambiente de desarrollo configurado.

**Actividades Principales:**

- Desarrollo iterativo de funcionalidades.
- Integración continua y pruebas automatizadas.
- Refinamiento de requisitos según feedback.
- Documentación técnica y de usuario.
- Preparación de ambientes de staging.

**Artefactos Clave:**

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - Artefacto
     - Dominio IACT
   * - Diseño Detallado (DES_xxx)
     - arquitectura_tecnica/diseño_detallado/
   * - Especificaciones de API
     - arquitectura_tecnica/especificaciones/
   * - Casos de Prueba
     - (gestión de calidad)
   * - Manuales de Usuario
     - (documentación de usuario)

**Criterios de Salida (Milestone: Initial Operational Capability):**

- Sistema funcional en ambiente de staging.
- Pruebas de aceptación ejecutadas.
- Documentación de usuario completa.
- Plan de Transition aprobado.

3.5. Fase: Transition
^^^^^^^^^^^^^^^^^^^^^

**Objetivo:** Desplegar el sistema en producción y transferir a operaciones.

**Criterios de Entrada:**

- Milestone IOC aprobado.
- Ambiente de producción preparado.
- Equipo de operaciones capacitado.

**Actividades Principales:**

- Despliegue en producción.
- Migración de datos si aplica.
- Capacitación a usuarios finales.
- Soporte post-implementación.
- Cierre formal del proyecto.

**Artefactos Clave:**

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - Artefacto
     - Dominio IACT
   * - Runbook de Operaciones
     - arquitectura_tecnica/especificaciones/
   * - Guía de Despliegue
     - arquitectura_tecnica/especificaciones/
   * - Acta de Cierre
     - (gestión de proyecto)

**Criterios de Salida (Milestone: Product Release):**

- Sistema en producción operativo.
- Usuarios capacitados.
- Transferencia a operaciones completada.
- Proyecto cerrado formalmente.

-----------------------------
4. Estado Actual del Proyecto
-----------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 0
   :stub-columns: 1

   * - **Fase Actual**
     - Elaboration
   * - **Iteración**
     - E2 (segunda iteración de Elaboration)
   * - **Fecha Inicio Fase**
     - 2025-02-12
   * - **Fecha Estimada Fin**
     - 2025-04-09
   * - **Próximo Milestone**
     - LCA (Lifecycle Architecture)

---------------------------------
5. Relación Fases-Artefactos IACT
---------------------------------

La siguiente matriz indica en qué fase se crean o actualizan los
principales tipos de artefactos del modelo IACT:

.. list-table::
   :widths: 30 15 15 15 15
   :header-rows: 1

   * - Tipo Artefacto
     - Inception
     - Elaboration
     - Construction
     - Transition
   * - META_xx (Identidad)
     - Crear
     - Actualizar
     - \-
     - \-
   * - BR_xxx (Reglas Negocio)
     - Identificar
     - Crear
     - Refinar
     - \-
   * - UC_xxx (Casos de Uso)
     - Listar
     - Crear
     - Refinar
     - \-
   * - FR_xxx (Funcionales)
     - \-
     - Crear
     - Refinar
     - \-
   * - ADR_xxx (Decisiones)
     - \-
     - Crear
     - Crear
     - \-
   * - DES_xxx (Diseño)
     - \-
     - Inicial
     - Crear
     - \-
   * - RTM (Trazabilidad)
     - \-
     - Crear
     - Mantener
     - Cerrar

--------------
6. Referencias
--------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Documento
     - Referencia
   * - Identidad del Proyecto
     - :doc:`META_01_Identidad_Proyecto`
   * - Contexto IACT
     - :doc:`META_04_Contexto_IACT`
   * - Estructura Documental
     - :doc:`META_05_Estructura_Documental`

--------------------
Historial de Cambios
--------------------

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

**Trazabilidad:** Este artefacto contextualiza la documentación en el proceso
de desarrollo. Los artefactos se relacionan con fases específicas del SDLC
para auditoría y gobernanza.
