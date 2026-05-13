.. meta::
   :artefacto: STD_006
   :tipo: Estándar
   :dominio: normativa
   :subdominio: estandares
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _std-006:

=============================
STD_006: Versionado Semántico
=============================


1. Propósito
------------

Establecer las reglas obligatorias para el versionado de todos los artefactos
documentales del proyecto IACT, garantizando trazabilidad, consistencia y
comunicación clara del estado de evolución de cada documento.

Este estándar adopta **Semantic Versioning 2.0.0** (SemVer) como base,
adaptándolo a las necesidades específicas de documentación técnica.

----

2. Alcance
----------

Este estándar aplica a:

- Modelo Documental IACT (MODELO_DOCUMENTAL_IACT_vX.Y.Z.md)
- Documentos fundacionales (FND_xx)
- Casos de uso (UC_xxx_xx)
- Requisitos funcionales (FR_UCxxx_xx_xx)
- Reglas de negocio (BR_xxx)
- Restricciones (CNST_xxx)
- Todos los demás artefactos del sistema documental

----

3. Formato de Versión
---------------------

.. code-block:: text

   MAJOR.MINOR.PATCH

   Donde:
   ├── MAJOR = Número entero ≥ 0
   ├── MINOR = Número entero ≥ 0
   └── PATCH = Número entero ≥ 0

**Ejemplos válidos:**

- ``1.0.0`` — Primera versión estable
- ``2.1.0`` — Segunda major, primera minor
- ``2.0.10`` — Décimo parche de v2.0

**Ejemplos inválidos:**

- ``v2.1`` — Falta PATCH
- ``2.1.0.1`` — Demasiados niveles
- ``2.1.9-beta`` — Sufijos no permitidos en documentación IACT

----

4. Reglas de Incremento
-----------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - Componente
     - Cuándo Incrementar
     - Efecto en Otros
   * - **MAJOR**
     - Cambios incompatibles o ruptura de estructura
     - MINOR y PATCH se reinician a 0
   * - **MINOR**
     - Nueva funcionalidad compatible hacia atrás
     - PATCH se reinicia a 0
   * - **PATCH**
     - Correcciones de errores, ajustes menores, typos
     - No afecta a otros componentes

4.1 Incremento de MAJOR
~~~~~~~~~~~~~~~~~~~~~~~

Se incrementa MAJOR cuando:

1. Cambia la estructura fundamental del artefacto
2. Se eliminan secciones obligatorias
3. Se modifica la semántica de campos existentes
4. Los artefactos dependientes requieren actualización

**Ejemplo IACT:**

.. code-block:: text

   v1.0.0 → v2.0.0
   
   Cambio: Reestructuración de 4 dominios a 5 dominios
   Impacto: Todos los artefactos deben reubicarse

4.2 Incremento de MINOR
~~~~~~~~~~~~~~~~~~~~~~~

Se incrementa MINOR cuando:

1. Se añade nueva funcionalidad o contenido
2. Se agregan nuevas secciones opcionales
3. Se expande el alcance sin romper compatibilidad
4. Se inicia una nueva fase del proyecto

**Ejemplo IACT:**

.. code-block:: text

   v2.0.8 → v2.1.0
   
   Cambio: Inicio de generación de FR (55 FR nuevos)
   Impacto: Compatible con v2.0.8, añade contenido

4.3 Incremento de PATCH
~~~~~~~~~~~~~~~~~~~~~~~

Se incrementa PATCH cuando:

1. Se corrigen errores tipográficos
2. Se ajusta formato o estilo
3. Se corrigen errores menores de contenido
4. Se actualizan referencias sin cambiar semántica

**Ejemplo IACT:**

.. code-block:: text

   v2.0.8 → v2.0.9
   
   Cambio: Corrección de nomenclatura incorrecta
   Impacto: Solo corrección, sin nuevo contenido

----

5. Reglas Específicas IACT
--------------------------

5.1 Versión Inicial
~~~~~~~~~~~~~~~~~~~

Todo artefacto nuevo comienza en ``1.0.0`` cuando:

- Está completo según su plantilla
- Ha sido revisado
- Está listo para uso

Los borradores usan ``0.x.y`` hasta alcanzar estabilidad.

5.2 Documentos Congelados
~~~~~~~~~~~~~~~~~~~~~~~~~

Los artefactos marcados como ``[CONGELADO]`` solo pueden incrementar PATCH
para correcciones críticas. Cambios MINOR o MAJOR requieren aprobación de PMO
y descongelamiento formal.

5.3 Consistencia en Cadena de Derivación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cuando un artefacto padre cambia de versión MAJOR o MINOR, los artefactos
hijos derivados deben evaluarse para actualización:

.. code-block:: text

   BR_001 v1.0.0 → v2.0.0 (cambio MAJOR)
   │
   └── UC_AUTH_01 debe revisarse
       │
       └── FR_UCAUTH_01_xx deben revisarse

5.4 Prohibición de Saltos
~~~~~~~~~~~~~~~~~~~~~~~~~

**NO está permitido** saltar versiones arbitrariamente:

.. code-block:: text

   ❌ v2.0.8 → v2.1.9  (salta v2.1.0 a v2.1.8)
   ✅ v2.0.8 → v2.1.0  (incremento correcto)

Cada versión debe tener un commit/registro que la justifique.

----

6. Registro de Versiones
------------------------

Todo artefacto debe incluir una sección de historial con:

.. code-block:: rst

   Historial de Cambios
   --------------------

   .. list-table::
      :widths: 15 15 70
      :header-rows: 1

      * - Versión
        - Fecha
        - Descripción del Cambio
      * - 1.0.0
        - 2026-01-07
        - Versión inicial

----

7. Ejemplos Aplicados al Proyecto IACT
--------------------------------------

7.1 Evolución del Modelo Documental
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :widths: 15 20 65
   :header-rows: 1

   * - Versión
     - Tipo Cambio
     - Descripción
   * - v2.0.0
     - MAJOR
     - Reestructuración completa del modelo
   * - v2.0.3
     - PATCH
     - Añadido subdominio modulos/, nomenclatura Clean Code
   * - v2.0.4
     - PATCH
     - Añadido nivel BReq
   * - v2.0.5
     - PATCH
     - Nueva nomenclatura UC: UC_MOD_NN
   * - v2.0.6
     - PATCH
     - Integración MODELO RBAC v5.1.1
   * - v2.0.7
     - PATCH
     - Generación 49 UC completos
   * - v2.0.8
     - PATCH
     - Consolidación final UC v4.0
   * - v2.1.0
     - MINOR
     - Inicio generación FR (55 FR nuevos)

7.2 Decisión de Versionado: Caso Real
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Situación:** Se generó v2.0.9 con errores de nomenclatura (UC_001 en lugar
de UC_AUTH_01).

**Análisis:**

.. code-block:: text

   Opción A: v2.0.10 (corrección del error)
   └── Solo si fuera corrección sin contenido nuevo
   
   Opción B: v2.1.0 (nueva funcionalidad) ✅
   └── Correcto porque añade 55 FR nuevos
   
   Opción C: v2.1.9 (salto arbitrario)
   └── Incorrecto: viola regla de no saltar versiones

**Decisión:** ``v2.1.0`` porque incluye nueva funcionalidad (FR) además de
correcciones.

----

8. Verificación de Cumplimiento
-------------------------------

Checklist para revisores:

.. code-block:: text

   [ ] Formato MAJOR.MINOR.PATCH correcto
   [ ] No hay saltos de versión injustificados
   [ ] Historial de cambios actualizado
   [ ] Tipo de incremento corresponde al cambio realizado
   [ ] Artefactos dependientes evaluados (si aplica)

----

9. Referencias
--------------

- Semantic Versioning 2.0.0: https://semver.org/
- GOB_05_Control_Versiones.rst
- FND_04_Trazabilidad.rst

----

10. Trazabilidad
----------------

**Origen:**

- GOB_05: Control de Versiones

**Artefactos Relacionados:**

- Todos los documentos del proyecto IACT

**Aplica a:**

- Dominio: normativa/estandares/
- Clasificación: Normativo
- Obligatoriedad: Mandatorio

----

11. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Versión inicial del estándar de versionado semántico
