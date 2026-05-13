.. meta::
   :artefacto: PROC_Generacion_STD
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Generacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-generacion-std:

=============================================
PROC_Generacion_STD: Generacion de Estandares
=============================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_STD
   * - **Nombre**
     - Generacion de Estandares
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada STD a documentar
   * - **Duracion Estimada**
     - 45-90 minutos por STD
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar Estandares (STD)
siguiendo el template TPL_STD.

**Objetivo:** Crear STD completos con reglas claras, ejemplos
correctos/incorrectos y metodos de verificacion.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Creacion de nuevos estandares tecnicos
- Estandares de todas las categorias (documentacion, codigo, arquitectura)

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Politicas de alto nivel (usar PROC_Generacion_POL)
- Procedimientos operativos (usar otros PROC)

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Arquitecto
     - Genera STD siguiendo TPL
     - Escritura en estandares/
   * - Equipo Tecnico
     - Valida viabilidad
     - Lectura

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Necesidad del estandar identificada
- [ ] TPL_STD revisado
- [ ] Categoria del estandar determinada
- [ ] Estructura /tmp/estandares/ creada

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_STD_Estandares_1_0_0.rst
     - Template de STD
     - Si

----

6. Procedimiento
----------------

6.1 Categorias de STD
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 20 60
   :header-rows: 1

   * - Rango
     - Categoria
     - Ejemplos
   * - 001-019
     - Documentacion
     - Estructura docs, nomenclatura, diagramas
   * - 020-039
     - Codigo
     - Convenciones Python, commits, versionado
   * - 040-059
     - Arquitectura
     - Patrones, capas, integracion
   * - 060-079
     - Pruebas
     - Cobertura, naming, fixtures
   * - 080-099
     - Operaciones
     - Deployment, monitoreo, logs

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Determinar Nomenclatura**

- **Responsable**: Arquitecto
- **Accion**: Asignar ID segun categoria:

  .. code-block:: text

     Formato: STD_[NNN]
     
     Ejemplos:
     - STD_001: Estructura Documentacion (Documentacion)
     - STD_004: Convenciones Python (Codigo)
     - STD_006: Versionado Semantico (Codigo)

- **Resultado**: ID asignado
- **Verificacion**: Dentro del rango de categoria

**Paso 2: Definir Proposito**

- **Responsable**: Arquitecto
- **Accion**: Describir objetivo del estandar:

  .. code-block:: rst

     1. Proposito
     ------------
     
     Este estandar define [que normaliza] para [objetivo].
     
     **Aplica a:** [ambito de aplicacion]
     
     **Beneficios:**
     - [Beneficio 1]
     - [Beneficio 2]

- **Resultado**: Proposito claro
- **Verificacion**: Objetivo entendible

**Paso 3: Definir Alcance**

- **Responsable**: Arquitecto
- **Accion**: Especificar donde aplica y donde no:

  .. code-block:: rst

     2.1 Aplica A
     ^^^^^^^^^^^^
     
     - [Contexto 1 donde aplica]
     - [Contexto 2]
     
     2.2 No Aplica A
     ^^^^^^^^^^^^^^^
     
     - [Excepcion 1]
     - [Excepcion 2]

- **Resultado**: Alcance definido
- **Verificacion**: Limites claros

**Paso 4: Documentar Reglas**

- **Responsable**: Arquitecto
- **Accion**: Para cada regla del estandar:

  .. code-block:: rst

     **Regla STD_001-R01: [Nombre de la regla]**
     
     - **Descripcion**: [Que establece la regla]
     - **Obligatoriedad**: Obligatorio | Recomendado
     - **Verificacion**: Manual | Automatica | Herramienta
     
     **Ejemplo Correcto:**
     
     .. code-block:: [lenguaje]
     
        [codigo o texto correcto]
     
     **Ejemplo Incorrecto:**
     
     .. code-block:: [lenguaje]
     
        [codigo o texto incorrecto]

- **Resultado**: Reglas documentadas
- **Verificacion**: Ejemplos claros

**Paso 5: Crear Tabla Resumen**

- **Responsable**: Arquitecto
- **Accion**: Consolidar reglas en tabla:

  .. code-block:: rst

     .. list-table::
        :header-rows: 1
     
        * - Regla
          - Descripcion
          - Obligatorio
          - Verificacion
        * - R01
          - [Descripcion corta]
          - Si/No
          - Manual/Auto/Tool

- **Resultado**: Tabla resumen
- **Verificacion**: Todas las reglas listadas

**Paso 6: Definir Verificacion**

- **Responsable**: Arquitecto
- **Accion**: Especificar como verificar cumplimiento:

  .. code-block:: rst

     9. Verificacion
     ---------------
     
     9.1 Automatica
     ^^^^^^^^^^^^^^
     
     - Herramienta: [nombre]
     - Comando: [comando]
     
     9.2 Manual
     ^^^^^^^^^^
     
     - Checklist de revision
     - Frecuencia: [cuando]

- **Resultado**: Metodos de verificacion
- **Verificacion**: Al menos 1 metodo definido

**Paso 7: Documentar Excepciones**

- **Responsable**: Arquitecto
- **Accion**: Proceso para excepciones:

  .. code-block:: rst

     10. Excepciones
     ---------------
     
     **Proceso para solicitar excepcion:**
     
     1. Documentar justificacion
     2. Aprobar con Arquitecto
     3. Registrar en historial del artefacto

- **Resultado**: Proceso de excepciones
- **Verificacion**: Proceso claro

**Paso 8: Guardar y Validar**

- **Responsable**: Arquitecto
- **Accion**: Guardar y validar:

  .. code-block:: bash

     # Guardar
     /tmp/estandares/STD_006_Versionado_Semantico.rst
     
     # Validar
     sphinx-build -b html -W /tmp/estandares/ /tmp/build/

- **Resultado**: STD guardado y validado
- **Verificacion**: Sin errores Sphinx

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - STD_[NNN]_[Nombre].rst
     - Estandar generado
     - /tmp/estandares/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] STD creado con todas las secciones
- [ ] Reglas con ejemplos correcto/incorrecto
- [ ] Metodos de verificacion definidos
- [ ] Proceso de excepciones documentado

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] ID sigue formato STD_[NNN]
- [ ] Categoria correcta segun rango
- [ ] Cada regla tiene ejemplo correcto e incorrecto
- [ ] Metodo de verificacion definido
- [ ] Consecuencias de incumplimiento claras

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Regla no verificable
     - Reformular o marcar como recomendacion
   * - Conflicto con otro STD
     - Resolver antes de publicar

----

11. Referencias
---------------

- TPL_STD_Estandares_1_0_0.rst
- STD existentes del proyecto

----

12. Historial de Cambios
------------------------

.. list-table::
   :widths: 12 12 20 56
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
