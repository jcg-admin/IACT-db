.. meta::
 :artefacto: TPL_SRS
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================================
TPL_SRS: Plantilla de Low-Level Design (LLD)
==============================================

.. note::

 Plantilla para Low-Level Design (LLD), también conocido como
 Software Requirements Specification a nivel detallado. Describe
 el CÓMO de la implementación. Aplica skill ``bpa-design``.

1. Propósito
============

Especificar los detalles de implementación de un componente:
estructuras de datos, algoritmos, APIs internas, contratos.

2. Cuándo usar esta plantilla
=============================

- Después del HLD/SAD y antes de comenzar la implementación.
- Para cualquier componente con lógica no trivial.
- Como input al developer que escribirá el código.

3. Estructura obligatoria
=========================

3.1 Identificación
------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Componente**
   - {nombre}
 * - **HLD parent**
   - ``/path/to/hld-{componente}`` (ruta al HLD del componente)
 * - **Owner técnico**
   - {nombre}

3.2 Estructura de datos
-----------------------

Definición de tipos y estructuras:

.. code-block:: typescript

 // Ejemplo: tipo de datos del componente
 interface UserPreferences {
   userId: number;
   themePreference: 'light' | 'dark';
   updatedAt: Date;
 }

3.3 APIs internas
-----------------

Contratos de las funciones / clases del componente:

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Función / Método
   - Signature
   - Descripción
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

3.4 Algoritmos clave
--------------------

Pseudocódigo o código real para lógica no trivial.

3.5 Manejo de errores
---------------------

Cómo se manejan los errores esperables y no esperables:

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Tipo error
   - Cuándo ocurre
   - Manejo
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

3.6 Performance considerations
------------------------------

- Complejidad O() de operaciones críticas.
- Uso de memoria esperado.
- Optimizaciones aplicadas.

3.7 Concurrency / Threading
---------------------------

Si aplica:

- Locks / mutexes.
- Race conditions consideradas.
- Async / await patterns.

3.8 Dependencias
----------------

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Dependencia
   - Versión
   - Por qué
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

3.9 Configuración
-----------------

Settings, env vars, feature flags relevantes.

4. Diferencia HLD vs LLD
========================

- **HLD/SAD:** QUÉ hace y POR QUÉ — vista alto nivel,
  componentes y sus relaciones. Ver
  :doc:`tpl-sad-arquitectura-software`.
- **LLD/SRS:** CÓMO se implementa — detalles de código,
  estructuras de datos, contratos de funciones.

5. Ejemplo de aplicación
========================

Ver :doc:`/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/lld-dark-mode`
como LLD aplicado a Dark Mode.

6. Convenciones de naming
=========================

- Archivo: ``lld-{componente}.rst`` o ``srs-{componente}.rst``.
- Ubicación: cerca del HLD/SAD del mismo componente.

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``bpa-design`` + tech-skill específica del componente
 * - **Templates relacionados**
   - :doc:`tpl-sad-arquitectura-software`, :doc:`tpl-api-documentacion-api`
 * - **Skills complementarias**
   - ``backend-nodejs``, ``frontend-react``, ``db-postgresql``,
     ``test-driven-development``
