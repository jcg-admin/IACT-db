Procedimientos
==============

Este directorio contiene los **procedimientos operacionales** del
proyecto IACT.

Que es un Procedimiento?
------------------------

Un **procedimiento** es un conjunto de instrucciones DETALLADAS y
ESPECIFICAS que describen **COMO** ejecutar una actividad particular
dentro de un proceso.

Caracteristicas: - BAJO NIVEL (vision detallada) - COMO se hace (pasos
especificos) - INSTRUCCIONES paso a paso - PARTE de un proceso -
ORIENTADO A EJECUCION - RECETA a seguir

Diferencia con Procesos
-----------------------

+------------------+------------------+-------------------------------+
| Aspecto          | PROCESO          | PROCEDIMIENTO                 |
+==================+==================+===============================+
| Nivel            | Alto             | Bajo (operacional)            |
|                  | (estrategico)    |                               |
+------------------+------------------+-------------------------------+
| Pregunta         | QUE hacemos      | COMO lo hacemos               |
+------------------+------------------+-------------------------------+
| Alcance          | Amplio           | Especifico (una tarea)        |
|                  | (end-to-end)     |                               |
+------------------+------------------+-------------------------------+
| Ubicacion        | ``docs/gobern    | ``docs                        |
|                  | anza/procesos/`` | /gobernanza/procedimientos/`` |
+------------------+------------------+-------------------------------+
| Patron           | ``PROC           | ``PROCED-###-titulo.md``      |
|                  | -###-titulo.md`` |                               |
+------------------+------------------+-------------------------------+

**Ver**: `GUIA-001: Procesos vs
Procedimientos <../guias/GUIA-001-procesos_vs_procedimientos.md>`__

--------------

Nomenclatura
------------

Todos los procedimientos DEBEN seguir el patron:

::

   PROCED-###-snake_case_title.md

**Ejemplos**: - ``PROCED-001-code_review.md`` -
``PROCED-002-ejecutar_tests.md`` - ``PROCED-003-deploy_staging.md`` -
``PROCED-004-rollback.md``

**Ver**: `GUIA-002: Convenciones de
Nomenclatura <../guias/GUIA-002-convenciones_nomenclatura.md>`__

--------------

Plantilla de Procedimiento
--------------------------

.. code:: markdown

   ---
   id: PROCED-###
   tipo: procedimiento
   categoria: [desarrollo|operaciones|qa|devops]
   proceso_padre: PROC-###
   version: 1.0.0
   fecha_creacion: YYYY-MM-DD
   autor: Nombre
   estado: [borrador|activo|obsoleto]
   relacionados: ["PROC-001", "GUIA-002"]
                                         

   # PROCED-###: Nombre del Procedimiento

   ## Objetivo

   Para que sirve este procedimiento.

   ## Pre-requisitos

   Que debe existir antes de ejecutar:
   - Pre-requisito 1
   - Pre-requisito 2

   ## Responsable

   Quien ejecuta este procedimiento: [Developer | QA | DevOps | Tech Lead]

   ## Pasos

   ### Paso 1: Titulo del Paso

   Descripcion detallada del paso.

   ```bash
   # Comando si aplica
   comando ejemplo

Paso 2: Titulo del Paso
~~~~~~~~~~~~~~~~~~~~~~~

Descripcion detallada.

Paso 3: Titulo del Paso
~~~~~~~~~~~~~~~~~~~~~~~

Descripcion detallada.

Criterios de Exito
------------------

Como validar que se ejecuto correctamente: - Criterio 1 - Criterio 2

Troubleshooting
---------------

Problema 1: Descripcion
~~~~~~~~~~~~~~~~~~~~~~~

**Sintomas**: … **Causa**: … **Solucion**: …

Problema 2: Descripcion
~~~~~~~~~~~~~~~~~~~~~~~

**Sintomas**: … **Causa**: … **Solucion**: …

::


   ---

   ## Procedimientos Existentes

   Actualmente no hay procedimientos formales documentados.

   **Procedimientos planeados** (basados en PROC-001):

   1. `PROCED-001-code_review.md` - Proceso de revision de codigo
   2. `PROCED-002-ejecutar_tests_unitarios.md` - Ejecutar tests unitarios
   3. `PROCED-003-ejecutar_tests_integracion.md` - Ejecutar tests de integracion
   4. `PROCED-004-deploy_staging.md` - Deploy a ambiente staging
   5. `PROCED-005-deploy_produccion.md` - Deploy a ambiente produccion
   6. `PROCED-006-rollback.md` - Rollback de deployment
   7. `PROCED-007-crear_migracion_django.md` - Crear migracion de base de datos
   8. `PROCED-008-ejecutar_linters.md` - Ejecutar linters y formatters

   ---

   ## Como Crear un Nuevo Procedimiento

   1. Identificar el proceso padre (PROC-###)
   2. Determinar el siguiente numero disponible
   3. Crear archivo con patron `PROCED-###-titulo.md`
   4. Copiar plantilla de arriba
   5. Completar todos los campos del frontmatter
   6. Documentar pasos detallados
   7. Incluir comandos y ejemplos
   8. Agregar troubleshooting
   9. Commit con mensaje descriptivo

   **Ejemplo**:
   ```bash
   # Crear archivo
   touch docs/gobernanza/procedimientos/PROCED-001-code_review.md

   # Editar y completar plantilla
   vim docs/gobernanza/procedimientos/PROCED-001-code_review.md

   # Commit
   git add docs/gobernanza/procedimientos/PROCED-001-code_review.md
   git commit -m "docs(procedimientos): agregar PROCED-001 code review"

--------------

Estructura de un Buen Procedimiento
-----------------------------------

Un procedimiento efectivo debe:

1. Ser ESPECIFICO y DETALLADO
2. Incluir TODOS los pasos necesarios
3. Tener comandos EJECUTABLES (copy-paste)
4. Incluir OUTPUTS esperados
5. Documentar PROBLEMAS COMUNES
6. Tener CRITERIOS DE EXITO claros
7. Referenciar el PROCESO PADRE
8. Ser MANTENIDO y ACTUALIZADO

--------------

Relacion con Procesos
---------------------

Cada procedimiento es PARTE de un proceso. El campo ``proceso_padre`` en
el frontmatter debe referenciar el proceso del cual forma parte.

**Ejemplo**:

::

   PROC-001: Pipeline de Trabajo
   ├── PROCED-001: Code Review
   ├── PROCED-002: Ejecutar Tests Unitarios
   ├── PROCED-003: Ejecutar Tests de Integracion
   ├── PROCED-004: Deploy a Staging
   └── PROCED-005: Deploy a Produccion

--------------

Referencias
-----------

-  `GUIA-001: Procesos vs
   Procedimientos <../guias/GUIA-001-procesos_vs_procedimientos.md>`__
-  `GUIA-002: Convenciones de
   Nomenclatura <../guias/GUIA-002-convenciones_nomenclatura.md>`__
-  `PROC-001: Pipeline de Trabajo
   IACT <../procesos/PROC-001-pipeline_trabajo_iact.md>`__

--------------

**Ultima actualizacion**: 2025-11-17
