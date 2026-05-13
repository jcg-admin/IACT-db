.. meta::
   :artefacto: META_04
   :tipo: Contexto
   :dominio: base_cognitiva
   :subdominio: _metadata
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-18
   :ultimo_cambio: 2025-12-18
   :autor: PMO IACT
   :clasificacion: Interno

.. _meta_04_contexto_iact:

==========================================================
META_04 · Contexto del Modelo IACT
==========================================================

.. contents:: Contenido
   :local:
   :depth: 2

------------------------------------------------------------
1. Propósito
------------------------------------------------------------

Este documento introduce el modelo documental IACT (Integrated Analysis and
Contextual Traceability) a nuevos miembros del equipo, explicando su filosofía,
estructura y aplicación práctica en el proyecto.

------------------------------------------------------------
2. Qué es IACT
------------------------------------------------------------

2.1. Definición
^^^^^^^^^^^^^^^

IACT es un modelo de organización documental diseñado para proyectos de
software que requieren trazabilidad rigurosa entre requisitos, arquitectura
e implementación.

El acrónimo representa:

- **I** - Integrated: Integración coherente de todos los artefactos documentales.
- **A** - Analysis: Énfasis en análisis de requisitos y reglas de negocio.
- **C** - Contextual: Cada artefacto existe en un contexto definido y trazable.
- **T** - Traceability: Trazabilidad bidireccional como principio fundamental.

2.2. Problema que Resuelve
^^^^^^^^^^^^^^^^^^^^^^^^^^

En proyectos de software medianos y grandes, la documentación típicamente sufre de:

- Fragmentación en múltiples herramientas y formatos.
- Pérdida de trazabilidad entre requisitos y código.
- Duplicación de información con versiones inconsistentes.
- Dificultad para auditar decisiones y cambios.
- Curva de aprendizaje alta para nuevos miembros.

IACT aborda estos problemas mediante una estructura jerárquica gobernada,
con reglas claras de nomenclatura y trazabilidad explícita.

------------------------------------------------------------
3. Principios Fundamentales
------------------------------------------------------------

3.1. Jerarquía Estricta
^^^^^^^^^^^^^^^^^^^^^^^

Toda la documentación se organiza en una jerarquía de cuatro niveles:

1. **Dominio Primario:** Unidad mayor, gobernada como bloque (ej: requisitos/).
2. **Subdominio:** División semántica dentro del dominio (ej: reglas_negocio/).
3. **Subcarpeta Organizativa:** Solo en subdominios descongelados, organiza por subtipo.
4. **Artefacto:** Unidad mínima, un archivo con ID único.

3.2. Nomenclatura Obligatoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cada artefacto sigue el patrón::

   PREFIJO_NÚMERO_Nombre_Descriptivo.rst

Ejemplos:

- ``BR_001_Cliente_Debe_Autenticarse.rst``
- ``UC_015_Generar_Reporte_Mensual.rst``
- ``ADR_003_Eleccion_Base_Datos.rst``

3.3. Trazabilidad Bidireccional
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las relaciones entre artefactos se documentan explícitamente:

- Reglas de Negocio derivan Casos de Uso.
- Casos de Uso derivan Requisitos Funcionales.
- Requisitos Funcionales se implementan en Diseño.
- Decisiones de Arquitectura justifican Diseño.

Estas relaciones se consolidan en matrices RTM (Requirements Traceability Matrix).

3.4. Gobernanza Centralizada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Cada dominio tiene un Owner responsable.
- Cambios estructurales requieren aprobación de PMO.
- Los subdominios están congelados por defecto.
- El descongelamiento requiere justificación formal.

------------------------------------------------------------
4. Estructura del Modelo
------------------------------------------------------------

4.1. Los 5 Dominios Primarios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Dominio
     - Propósito
   * - base_cognitiva/
     - Fundamentos conceptuales, metodologías, glosario y metadata del proyecto.
   * - requisitos/
     - Reglas de negocio, casos de uso, requisitos funcionales y no funcionales.
   * - arquitectura_tecnica/
     - Decisiones arquitectónicas, diseño detallado, especificaciones técnicas.
   * - normativa/
     - Estándares de codificación, restricciones, plantillas oficiales.
   * - trazabilidad/
     - Matrices RTM, reportes de cobertura, validaciones cruzadas.

4.2. Conteo Oficial
^^^^^^^^^^^^^^^^^^^

- 5 Dominios Primarios
- 21 Subdominios (nivel 2)
- 6 Subcarpetas Organizativas (en subdominios descongelados)

4.3. Notación de Subdominios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Subdominios públicos: nombre sin prefijo (ej: ``glosario/``)
- Subdominios privados: prefijo underscore (ej: ``_metadata/``)

Solo ``_metadata/`` es privado en el modelo actual.

------------------------------------------------------------
5. Flujo de Trabajo Documental
------------------------------------------------------------

5.1. Creación de Artefactos
^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Identificar el subdominio correcto según el tipo de contenido.
2. Asignar el próximo número secuencial del prefijo.
3. Crear archivo siguiendo la plantilla del subdominio.
4. Completar metadatos obligatorios en bloque ``.. meta::``.
5. Establecer referencias cruzadas a artefactos relacionados.
6. Solicitar revisión al Owner del dominio.
7. Actualizar RTM si el artefacto participa en trazabilidad.

5.2. Modificación de Artefactos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Verificar permisos según clasificación del documento.
2. Realizar cambios manteniendo formato y estructura.
3. Actualizar campo ``:ultimo_cambio:`` en metadatos.
4. Incrementar versión según semántica (major.minor.patch).
5. Documentar cambio en historial al final del artefacto.
6. Verificar que referencias cruzadas sigan válidas.

5.3. Validación de Estructura
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El modelo incluye validaciones automatizadas:

- Nomenclatura de archivos correcta.
- Metadatos obligatorios presentes.
- Referencias cruzadas resuelven.
- Subdominios congelados sin subcarpetas.

------------------------------------------------------------
6. Guía de Onboarding
------------------------------------------------------------

6.1. Primeros Pasos
^^^^^^^^^^^^^^^^^^^

Para nuevos miembros del equipo:

1. Leer este documento completo (META_04).
2. Revisar la estructura en META_05_Estructura_Documental.
3. Familiarizarse con el glosario en base_cognitiva/glosario/.
4. Identificar los dominios relevantes para su rol.
5. Revisar plantillas en normativa/estandares/plantillas/.

6.2. Artefactos por Rol
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Rol
     - Artefactos Principales
   * - Business Analyst
     - BR_xxx (Reglas de Negocio), UC_xxx (Casos de Uso)
   * - Arquitecto
     - ADR_xxx (Decisiones), SAD (Arquitectura), DES_xxx (Diseño)
   * - Desarrollador
     - FR_xxx (Funcionales), DES_xxx (Diseño), Especificaciones API
   * - QA
     - UC_xxx (Casos de Uso), FR_xxx (Funcionales), RTM
   * - PMO
     - META_xx (Metadata), RTM, Reportes de Trazabilidad

6.3. Preguntas Frecuentes
^^^^^^^^^^^^^^^^^^^^^^^^^

**P: ¿Dónde documento una nueva regla de negocio?**

R: En ``requisitos/reglas_negocio/`` con prefijo BR_ y siguiente número
secuencial disponible.

**P: ¿Qué hago si necesito crear una subcarpeta?**

R: Verificar si el subdominio está descongelado. Si está congelado,
solicitar descongelamiento a PMO con justificación formal.

**P: ¿Cómo sé qué requisitos cubre un caso de uso?**

R: Consultar la matriz RTM en ``trazabilidad/matrices/``.

**P: ¿Puedo usar Markdown en lugar de reStructuredText?**

R: Solo excepcionalmente y con aprobación. El formato estándar es .rst.

------------------------------------------------------------
7. Referencias
------------------------------------------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Documento
     - Referencia
   * - Identidad del Proyecto
     - :doc:`META_01_Identidad_Proyecto`
   * - Estructura Documental
     - :doc:`META_05_Estructura_Documental`
   * - Definiciones Oficiales
     - :doc:`/normativa/restricciones/RESTRICCIONES_COMPLETAS`
   * - Glosario IACT
     - :doc:`/base_cognitiva/glosario/IACT_Glossary_v1_0_0`

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

**Trazabilidad:** Referencia conceptual para todo el sistema documental.
Documento base para onboarding de nuevos miembros del equipo.