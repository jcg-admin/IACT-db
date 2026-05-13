.. meta::
   :artefacto: PROC_Generacion_Index
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

.. _proc-generacion-index:

===================================================
PROC_Generacion_Index: Generacion de Archivos Index
===================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_Index
   * - **Nombre**
     - Generacion de Archivos Index para Sphinx
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada subdominio/modulo
   * - **Duracion Estimada**
     - 10-20 minutos por index
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar archivos index.rst
que organizan los artefactos en subdominios para Sphinx.

**Objetivo:** Crear indices que permitan navegacion estructurada
de la documentacion y build exitoso de Sphinx.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Indices de subdominios (reglas_negocio/, casos_uso/, etc.)
- Indices de modulos (auth/, users/, etc.)
- Index raiz de dominios

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Archivos individuales de artefactos
- Configuracion de Sphinx (conf.py)

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Generador
     - Crea/actualiza index.rst
     - Escritura en subdominio

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Artefactos del subdominio generados
- [ ] TPL_INDEX revisado
- [ ] Estructura de carpetas existente

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_INDEX_Indices_1_0_0.rst
     - Template de Index
     - Si
   * - Artefactos del subdominio
     - Archivos a listar
     - Si

----

6. Procedimiento
----------------

6.1 Tipos de Index
^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 30 40
   :header-rows: 1

   * - Tipo
     - Ubicacion
     - Contenido
   * - Dominio
     - requisitos/index.rst
     - Lista subdominios
   * - Subdominio
     - reglas_negocio/index.rst
     - Lista artefactos BR
   * - Modulo
     - casos_uso/auth/index.rst
     - Lista UC del modulo

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Identificar Tipo de Index**

- **Responsable**: Generador
- **Accion**: Determinar nivel del index:

  .. code-block:: text

     Niveles:
     
     1. Dominio: requisitos/, arquitectura_tecnica/, etc.
     2. Subdominio: reglas_negocio/, casos_uso/, etc.
     3. Modulo: auth/, users/, access/, etc.

- **Resultado**: Tipo identificado
- **Verificacion**: Ubicacion correcta

**Paso 2: Listar Artefactos**

- **Responsable**: Generador
- **Accion**: Obtener lista de archivos:

  .. code-block:: bash

     # Listar artefactos del subdominio
     ls -1 [subdominio]/*.rst | grep -v index.rst | sort
     
     # Ejemplo
     BR_001_Sesion_Unica.rst
     BR_002_Auditoria_Accesos.rst
     ...

- **Resultado**: Lista de artefactos
- **Verificacion**: Sin duplicados

**Paso 3: Crear Estructura del Index**

- **Responsable**: Generador
- **Accion**: Usar estructura segun TPL_INDEX:

  .. code-block:: rst

     .. meta::
        :dominio: [dominio]
        :subdominio: [subdominio]
        :tipo: Indice
        :version: 1.0.0
     
                            
     [Titulo del Subdominio]
                            
     
     **Descripcion:** [Breve descripcion]
     
     **Total artefactos:** [N]
     
     **Fecha actualizacion:** [YYYY-MM-DD]
     
     ----
     
     Contenido
     ---------
     
     .. toctree::
        :maxdepth: 1
        :caption: [Categoria]
     
        [artefacto_1_sin_extension]
        [artefacto_2_sin_extension]
        ...

- **Resultado**: Estructura base
- **Verificacion**: Secciones completas

**Paso 4: Agregar toctree**

- **Responsable**: Generador
- **Accion**: Listar archivos SIN extension:

  .. code-block:: rst

     .. toctree::
        :maxdepth: 1
        :caption: Reglas de Negocio
     
        BR_001_Sesion_Unica
        BR_002_Auditoria_Accesos
        BR_003_Formato_Username

  **IMPORTANTE:** No incluir ".rst" en toctree.

- **Resultado**: toctree completo
- **Verificacion**: Nombres sin extension

**Paso 5: Agregar Metricas (Opcional)**

- **Responsable**: Generador
- **Accion**: Incluir estadisticas:

  .. code-block:: rst

     Metricas
     --------
     
     .. list-table::
        :header-rows: 1
     
        * - Metrica
          - Valor
        * - Total artefactos
          - 20
        * - Estado Aprobado
          - 20
        * - Ultima actualizacion
          - 2026-01-07

- **Resultado**: Metricas agregadas
- **Verificacion**: Valores correctos

**Paso 6: Validar con Sphinx**

- **Responsable**: Generador
- **Accion**: Ejecutar build:

  .. code-block:: bash

     sphinx-build -b html -W docs/ docs/_build/
     
     # Errores comunes:
     # - "toctree contains reference to nonexisting document"
     #   -> Verificar nombre de archivo
     # - "duplicate label"
     #   -> Verificar referencias unicas

- **Resultado**: Build exitoso
- **Verificacion**: Sin errores ni warnings

**Paso 7: Guardar Index**

- **Responsable**: Generador
- **Accion**: Guardar como index.rst:

  .. code-block:: bash

     # Nombre SIEMPRE es index.rst
     /tmp/[subdominio]/index.rst
     
     # Ejemplo
     /tmp/reglas_negocio/index.rst

- **Resultado**: Index guardado
- **Verificacion**: Nombre exacto "index.rst"

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - index.rst
     - Indice del subdominio
     - /tmp/[subdominio]/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] index.rst creado en subdominio
- [ ] toctree lista todos los artefactos
- [ ] Validacion Sphinx exitosa
- [ ] Metricas actualizadas

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Archivo se llama exactamente "index.rst"
- [ ] toctree sin extensiones .rst
- [ ] Todos los artefactos del subdominio listados
- [ ] Sphinx build sin errores

9.2 Checklist de toctree
^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Directiva ``.. toctree::`` presente
- [ ] ``:maxdepth:`` especificado
- [ ] ``:caption:`` descriptivo
- [ ] Linea en blanco antes de lista
- [ ] Nombres sin extension .rst

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Artefacto no encontrado
     - Verificar nombre exacto del archivo
   * - Duplicate label
     - Verificar que referencias son unicas
   * - Subdominio vacio
     - No crear index hasta tener artefactos

----

11. Referencias
---------------

- TPL_INDEX_Indices_1_0_0.rst
- Sphinx toctree documentation
- PROC_Copiar_Tmp_Outputs

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
