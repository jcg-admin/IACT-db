.. meta::
   :artefacto: TPL_NFR
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-nfr:

===================================================
TPL_NFR: Plantilla de Requisito No Funcional v1.0.0
===================================================


Propósito
---------

Esta plantilla define la estructura estándar para documentar **Requisitos No Funcionales (NFR)**
en el proyecto IACT. Los NFR especifican criterios de calidad que el sistema debe cumplir,
independientemente de las funcionalidades específicas.

**Características:**

- Definen atributos de calidad del sistema
- Aplican transversalmente a múltiples módulos
- Medibles mediante métricas específicas
- Basados en estándares como ISO 25010

**Categorías principales (ISO 25010):**

- Rendimiento
- Seguridad
- Usabilidad
- Confiabilidad
- Mantenibilidad
- Portabilidad

----

Requisitos Técnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Ubicación:**

::

   requisitos/no_funcionales/NFR_[NNN]_[Nombre_Descriptivo].rst

----

Instrucciones de Uso
--------------------

1. Copiar contenido de sección "Plantilla" a nuevo archivo
2. Nombrar archivo según nomenclatura: ``NFR_[NNN]_[Nombre].rst``
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Clasificar según categoría ISO 25010
5. Definir métricas medibles y umbrales
6. Especificar método de verificación
7. Validar con ``sphinx-build -W``

----

Nomenclatura
------------

**Formato de ID:**

::

   NFR_[NNN]

   Donde:
   - NFR: Prefijo fijo (Non-Functional Requirement)
   - [NNN]: Número secuencial de 3 dígitos (001-999)

**Rangos por Categoría:**

::

   001-019: Rendimiento (Performance)
   020-039: Seguridad (Security)
   040-059: Usabilidad (Usability)
   060-079: Confiabilidad (Reliability)
   080-099: Mantenibilidad (Maintainability)
   100-119: Portabilidad (Portability)

**Ejemplos:**

::

   NFR_001  → Tiempo de respuesta de API
   NFR_020  → Cifrado de datos en tránsito
   NFR_040  → Accesibilidad WCAG 2.1
   NFR_060  → Disponibilidad del sistema

**Nombre de Archivo:**

::

   NFR_[NNN]_[Nombre_Descriptivo].rst

   Ejemplos:
   - NFR_001_Rendimiento.rst
   - NFR_020_Seguridad.rst
   - NFR_040_Usabilidad.rst
   - NFR_060_Confiabilidad.rst

----

Categorías ISO 25010
--------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Categoría
     - Descripción
     - Subcategorías
   * - **Rendimiento**
     - Eficiencia del sistema
     - Tiempo respuesta, throughput, uso recursos
   * - **Seguridad**
     - Protección de información
     - Confidencialidad, integridad, autenticación
   * - **Usabilidad**
     - Facilidad de uso
     - Aprendizaje, operabilidad, accesibilidad
   * - **Confiabilidad**
     - Funcionamiento correcto
     - Disponibilidad, tolerancia a fallos, recuperación
   * - **Mantenibilidad**
     - Facilidad de modificación
     - Modularidad, reusabilidad, analizabilidad
   * - **Portabilidad**
     - Capacidad de transferencia
     - Adaptabilidad, instalabilidad, coexistencia

----

Plantilla
---------

.. code-block:: rst

   .. meta::
      :artefacto: NFR_[NNN]
      :tipo: Requisito No Funcional
      :dominio: requisitos
      :subdominio: no_funcionales
      :categoria: [Rendimiento|Seguridad|Usabilidad|Confiabilidad|Mantenibilidad|Portabilidad]
      :estado: [Borrador|Revision|Aprobado]
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT
      :clasificacion: Interno

   .. _nfr-[nnn]:

                                                 
   NFR_[NNN]: [Nombre del Requisito No Funcional]
                                                 

   .. contents:: Contenido
      :local:
      :depth: 2

   ----

   Resumen Ejecutivo
   -----------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **ID**
        - NFR_[NNN]
      * - **Nombre**
        - [Nombre descriptivo del requisito]
      * - **Categoría**
        - [Rendimiento|Seguridad|Usabilidad|Confiabilidad|Mantenibilidad|Portabilidad]
      * - **Subcategoría**
        - [Subcategoría específica]
      * - **Prioridad**
        - [Crítica|Alta|Media|Baja]
      * - **Alcance**
        - [Sistema completo|Módulo específico]
      * - **Estado**
        - Vigente

   ----

   1. Especificación
   -----------------

   1.1 Enunciado
   ^^^^^^^^^^^^^

   .. note:: **Requisito No Funcional NFR_[NNN]**

      [Enunciado claro y conciso del requisito no funcional.
      Debe ser específico, medible, alcanzable, relevante y temporal (SMART).]

   1.2 Justificación
   ^^^^^^^^^^^^^^^^^

   [Por qué es importante este requisito no funcional.
   Qué valor aporta, qué riesgo mitiga, qué necesidad satisface.]

   ----

   2. Métricas y Umbrales
   ----------------------

   2.1 Métrica Principal
   ^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Nombre**
        - [Nombre de la métrica]
      * - **Unidad**
        - [segundos|porcentaje|número|etc.]
      * - **Fórmula**
        - [Cómo se calcula la métrica]

   2.2 Umbrales de Aceptación
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 20 30 50
      :header-rows: 1

      * - Nivel
        - Umbral
        - Descripción
      * - **Mínimo**
        - [valor]
        - Nivel mínimo aceptable
      * - **Objetivo**
        - [valor]
        - Nivel deseado
      * - **Óptimo**
        - [valor]
        - Nivel ideal

   2.3 Condiciones de Medición
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Entorno**: [Producción|Staging|Testing]
   - **Carga**: [Carga normal|Carga pico|Descripción específica]
   - **Frecuencia**: [Continuo|Diario|Semanal|Por release]

   ----

   3. Escenarios de Prueba
   -----------------------

   3.1 Escenario Normal
   ^^^^^^^^^^^^^^^^^^^^

   - **Condiciones**: [Descripción del escenario normal]
   - **Resultado esperado**: [Métrica dentro de umbral objetivo]

   3.2 Escenario de Estrés
   ^^^^^^^^^^^^^^^^^^^^^^^

   - **Condiciones**: [Descripción del escenario de estrés]
   - **Resultado esperado**: [Métrica dentro de umbral mínimo]

   3.3 Escenario Límite
   ^^^^^^^^^^^^^^^^^^^^

   - **Condiciones**: [Descripción del escenario límite]
   - **Resultado esperado**: [Comportamiento degradado pero funcional]

   ----

   4. Método de Verificación
   -------------------------

   4.1 Herramientas
   ^^^^^^^^^^^^^^^^

   - [Herramienta 1]: [Propósito]
   - [Herramienta 2]: [Propósito]

   4.2 Procedimiento de Prueba
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   1. [Paso 1 de la verificación]
   2. [Paso 2 de la verificación]
   3. [Paso 3 de la verificación]

   4.3 Criterio de Aceptación
   ^^^^^^^^^^^^^^^^^^^^^^^^^^

   El NFR se considera **CUMPLIDO** cuando:

   - [ ] [Criterio 1: Métrica cumple umbral mínimo]
   - [ ] [Criterio 2: Condición adicional]
   - [ ] [Criterio 3: Condición adicional]

   ----

   5. Aplicabilidad
   ----------------

   5.1 Componentes Afectados
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 25 75
      :header-rows: 1

      * - Componente
        - Impacto
      * - [MOD_xxx]
        - [Cómo aplica este NFR al módulo]
      * - [API_xxx]
        - [Cómo aplica este NFR a la API]
      * - [Infraestructura]
        - [Cómo aplica a infraestructura]

   5.2 Excepciones
   ^^^^^^^^^^^^^^^

   - [Componente o situación donde NO aplica este NFR]

   ----

   6. Restricciones Relacionadas
   -----------------------------

   .. list-table::
      :widths: 15 45 40
      :header-rows: 1

      * - CNST
        - Nombre
        - Relación
      * - CNST_[NNN]
        - [Nombre de la restricción]
        - [Cómo se relaciona con este NFR]

   ----

   7. Impacto en Arquitectura
   --------------------------

   7.1 Decisiones Arquitectónicas
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [ADR_NNN]: [Decisión relacionada con este NFR]

   7.2 Implicaciones de Diseño
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   - [Implicación 1 en el diseño del sistema]
   - [Implicación 2 en el diseño del sistema]

   ----

   8. Monitoreo
   ------------

   8.1 Indicadores de Monitoreo
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   .. list-table::
      :widths: 30 30 40
      :header-rows: 1

      * - Indicador
        - Umbral de Alerta
        - Acción
      * - [Indicador 1]
        - [Valor de alerta]
        - [Qué hacer si se supera]
      * - [Indicador 2]
        - [Valor de alerta]
        - [Qué hacer si se supera]

   8.2 Dashboard/Herramienta
   ^^^^^^^^^^^^^^^^^^^^^^^^^

   - **Herramienta**: [Grafana|Prometheus|CloudWatch|etc.]
   - **Dashboard**: [Nombre o ubicación del dashboard]

   ----

   9. Trazabilidad
   ---------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **Categoría ISO 25010**
        - [Categoría]
      * - **CNST Relacionadas**
        - CNST_[NNN], CNST_[NNN]
      * - **ADR Relacionadas**
        - ADR_[NNN]
      * - **Módulos Afectados**
        - MOD_[xxx], MOD_[yyy]

   ----

   10. Historial de Cambios
   ------------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Versión
        - Fecha
        - Autor
        - Cambios
      * - 1.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Versión inicial

   ----

   *Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Secciones Obligatorias
----------------------

Cada NFR DEBE incluir mínimo estas 10 secciones:

.. list-table::
   :widths: 5 30 65
   :header-rows: 1

   * - #
     - Sección
     - Contenido
   * - 0
     - Resumen Ejecutivo
     - ID, nombre, categoría, prioridad, alcance
   * - 1
     - Especificación
     - Enunciado SMART y justificación
   * - 2
     - Métricas y Umbrales
     - Métrica, fórmula, umbrales mín/obj/ópt
   * - 3
     - Escenarios de Prueba
     - Normal, estrés, límite
   * - 4
     - Método de Verificación
     - Herramientas, procedimiento, criterios
   * - 5
     - Aplicabilidad
     - Componentes afectados, excepciones
   * - 6
     - Restricciones Relacionadas
     - CNST vinculadas
   * - 7
     - Impacto en Arquitectura
     - ADR e implicaciones de diseño
   * - 8
     - Monitoreo
     - Indicadores, alertas, dashboard
   * - 9
     - Trazabilidad
     - Enlaces a ISO 25010, CNST, ADR, MOD
   * - 10
     - Historial
     - Control de versiones

----

Ejemplos de Métricas
--------------------

**Rendimiento:**

::

   - Tiempo de respuesta API: < 200ms (p95)
   - Throughput: > 1000 req/s
   - Uso de CPU: < 70% en carga normal

**Seguridad:**

::

   - Cifrado: TLS 1.3 obligatorio
   - Intentos de login fallidos antes de bloqueo: 5
   - Tiempo de bloqueo: 30 minutos

**Disponibilidad:**

::

   - Uptime: 99.9% mensual
   - MTTR (Mean Time To Recovery): < 1 hora
   - RPO (Recovery Point Objective): < 1 hora

----

Validación
----------

Antes de aprobar un NFR, verificar:

**Checklist:**

- [ ] ID sigue nomenclatura NFR_[NNN]
- [ ] Categoría ISO 25010 asignada
- [ ] Enunciado es SMART
- [ ] Métrica definida con fórmula
- [ ] Umbrales mínimo/objetivo/óptimo establecidos
- [ ] Escenarios de prueba documentados
- [ ] Método de verificación especificado
- [ ] CNST relacionadas identificadas
- [ ] Indicadores de monitoreo definidos

**Comando de validación:**

.. code-block:: bash

   # Validar sintaxis RST
   sphinx-build -b html -W docs/ docs/_build/

----

Referencias
-----------

- ISO/IEC 25010:2011 - Modelos de calidad
- FND_01: Concepto de Requisito
- CNST_*: Restricciones arquitectónicas
- STD_006: Versionado Semántico

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Versión inicial de plantilla NFR con ISO 25010
