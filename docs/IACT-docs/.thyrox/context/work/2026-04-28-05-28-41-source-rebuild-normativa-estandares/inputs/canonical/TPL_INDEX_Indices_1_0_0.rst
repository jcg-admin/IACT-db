.. meta::
   :artefacto: TPL_INDEX
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _tpl-index:

=====================================
TPL_INDEX: Plantilla de Indice v1.0.0
=====================================


Proposito
---------

Esta plantilla define la estructura estandar para crear archivos **index.rst**
en los subdominios del proyecto IACT. Los indices organizan y vinculan los
artefactos contenidos en cada carpeta de la documentacion.

**Caracteristicas:**

- Punto de entrada a cada subdominio
- Lista organizada de artefactos
- Metricas de contenido
- Navegacion Sphinx con toctree

**Ubicaciones de index.rst:**

::

   requisitos/objetivos_negocio/index.rst
   requisitos/reglas_negocio/index.rst
   requisitos/casos_uso/[modulo]/index.rst
   requisitos/funcionales/[modulo]/index.rst
   arquitectura_tecnica/modulos/index.rst
   arquitectura_tecnica/restricciones/index.rst
   normativa/estandares/index.rst
   normativa/procedimientos/index.rst
   evidencia/pruebas/[modulo]/index.rst

----

Requisitos Tecnicos
-------------------

**Dependencias:**

- Sphinx >= 7.0.0
- Formato ReStructuredText (.rst)

**Nombre de Archivo:**

::

   index.rst (siempre este nombre exacto)

----

Instrucciones de Uso
--------------------

1. Crear archivo ``index.rst`` en la carpeta del subdominio
2. Copiar contenido de seccion "Plantilla"
3. Reemplazar todos los ``[PLACEHOLDER]`` con valores reales
4. Agregar cada artefacto al toctree
5. Actualizar metricas
6. Validar con ``sphinx-build -W``

----

Plantilla Basica
----------------

.. code-block:: rst

   .. meta::
      :artefacto: INDEX_[subdominio]
      :tipo: Indice
      :dominio: [dominio]
      :subdominio: [subdominio]
      :estado: Activo
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT

   .. _index-[subdominio]:

                          
   [Nombre del Subdominio]
                          

   .. contents:: Contenido
      :local:
      :depth: 1

   ----

   Descripcion
   -----------

   [Descripcion breve del contenido de este subdominio en 1-2 oraciones.]

   ----

   Metricas
   --------

   .. list-table::
      :widths: 50 50
      :header-rows: 0

      * - **Total Artefactos**
        - [N]
      * - **Ultimo Actualizado**
        - [YYYY-MM-DD]

   ----

   Contenido
   ---------

   .. toctree::
      :maxdepth: 1
      :caption: [Tipo de Artefactos]

      [Artefacto_001]
      [Artefacto_002]
      [Artefacto_NNN]

   ----

   *Indice version 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Plantilla Extendida (con categorias)
------------------------------------

.. code-block:: rst

   .. meta::
      :artefacto: INDEX_[subdominio]
      :tipo: Indice
      :dominio: [dominio]
      :subdominio: [subdominio]
      :estado: Activo
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT

   .. _index-[subdominio]:

                          
   [Nombre del Subdominio]
                          

   .. contents:: Contenido
      :local:
      :depth: 1

   ----

   Descripcion
   -----------

   [Descripcion breve del contenido de este subdominio en 1-2 oraciones.]

   ----

   Metricas
   --------

   .. list-table::
      :widths: 40 30 30
      :header-rows: 1

      * - Categoria
        - Cantidad
        - Estado
      * - [Categoria 1]
        - [N1]
        - [Completo|En progreso]
      * - [Categoria 2]
        - [N2]
        - [Completo|En progreso]
      * - **Total**
        - **[N]**
        - -

   ----

   [Categoria 1]
   -------------

   .. toctree::
      :maxdepth: 1
      :caption: [Categoria 1]

      [Artefacto_Cat1_001]
      [Artefacto_Cat1_002]

   ----

   [Categoria 2]
   -------------

   .. toctree::
      :maxdepth: 1
      :caption: [Categoria 2]

      [Artefacto_Cat2_001]
      [Artefacto_Cat2_002]

   ----

   Historial de Cambios
   --------------------

   .. list-table::
      :widths: 12 12 20 56
      :header-rows: 1

      * - Version
        - Fecha
        - Autor
        - Cambios
      * - 1.0.0
        - [YYYY-MM-DD]
        - Equipo IACT
        - Version inicial

   ----

   *Indice version 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Plantilla para Modulos (casos_uso, funcionales, pruebas)
--------------------------------------------------------

.. code-block:: rst

   .. meta::
      :artefacto: INDEX_[modulo]
      :tipo: Indice de Modulo
      :dominio: [dominio]
      :subdominio: [subdominio]/[modulo]
      :modulo: MOD_[Modulo]
      :estado: Activo
      :version: 1.0.0
      :fecha_creacion: [YYYY-MM-DD]
      :ultimo_cambio: [YYYY-MM-DD]
      :autor: Equipo IACT

   .. _index-[subdominio]-[modulo]:

                                  
   [Tipo Artefacto] - MOD_[Modulo]
                                  

   .. contents:: Contenido
      :local:
      :depth: 1

   ----

   Descripcion
   -----------

   [Tipo de artefactos] del modulo **MOD_[Modulo]** ([Descripcion del modulo]).

   ----

   Metricas
   --------

   .. list-table::
      :widths: 50 50
      :header-rows: 0

      * - **Modulo**
        - MOD_[Modulo]
      * - **Total [Tipo]**
        - [N]
      * - **Estado**
        - [Completo|En progreso] ([X]%)
      * - **Ultimo Actualizado**
        - [YYYY-MM-DD]

   ----

   Listado de [Tipo]
   -----------------

   .. toctree::
      :maxdepth: 1
      :caption: [Tipo] MOD_[Modulo]

      [PREFIJO]_[MOD]_01
      [PREFIJO]_[MOD]_02
      [PREFIJO]_[MOD]_NN

   ----

   Trazabilidad
   ------------

   .. list-table::
      :widths: 25 75
      :header-rows: 0

      * - **BReq**
        - BReq_[MOD]
      * - **BR Aplicables**
        - BR_[NNN], BR_[NNN]
      * - **[Nivel Superior]**
        - [Enlaces al nivel superior]
      * - **[Nivel Inferior]**
        - [Enlaces al nivel inferior]

   ----

   *Indice version 1.0.0 - Proyecto IACT Dashboard Analytics*

----

Ejemplos Especificos
--------------------

Ejemplo 1: index.rst para reglas_negocio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: rst

   .. meta::
      :artefacto: INDEX_reglas_negocio
      :tipo: Indice
      :dominio: requisitos
      :subdominio: reglas_negocio
      :estado: Activo
      :version: 2.0.0
      :fecha_creacion: 2026-01-06
      :ultimo_cambio: 2026-01-07
      :autor: Equipo IACT

                         
   Reglas de Negocio (BR)
                         

   Metricas
   --------

   .. list-table::
      :widths: 40 30 30
      :header-rows: 1

      * - Tipo (TXM_03)
        - Cantidad
        - Estado
      * - Restriccion
        - 10
        - Completo
      * - Desencadenador
        - 3
        - Completo
      * - Hecho
        - 3
        - Completo
      * - Inferencia
        - 1
        - Completo
      * - Calculo
        - 3
        - Completo
      * - **Total**
        - **20**
        - **Completo**

   Contenido
   ---------

   .. toctree::
      :maxdepth: 1
      :caption: Business Rules

      BR_001_Fuente_Operacional_Inmutable
      BR_002_ETL_Programado
      BR_003_Inactividad_Usuario
      ...
      BR_020_Tamano_Maximo_Exportacion

----

Ejemplo 2: index.rst para casos_uso/auth
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: rst

   .. meta::
      :artefacto: INDEX_casos_uso_auth
      :tipo: Indice de Modulo
      :dominio: requisitos
      :subdominio: casos_uso/auth
      :modulo: MOD_Auth
      :estado: Activo
      :version: 1.0.0

                          
   Casos de Uso - MOD_Auth
                          

   Metricas
   --------

   .. list-table::
      :widths: 50 50
      :header-rows: 0

      * - **Modulo**
        - MOD_Auth
      * - **Total UC**
        - 5
      * - **FR Derivados**
        - 21
      * - **Estado**
        - Completo (100%)

   Casos de Uso
   ------------

   .. toctree::
      :maxdepth: 1
      :caption: UC MOD_Auth

      UC_AUTH_01_Iniciar_Sesion
      UC_AUTH_02_Cerrar_Sesion
      UC_AUTH_03_Recuperar_Password
      UC_AUTH_04_Cambiar_Password
      UC_AUTH_05_Gestionar_Sesiones

----

Secciones Obligatorias
----------------------

Cada index.rst DEBE incluir minimo:

.. list-table::
   :widths: 5 25 70
   :header-rows: 1

   * - #
     - Seccion
     - Contenido
   * - 0
     - Meta tags
     - artefacto, tipo, dominio, subdominio, version
   * - 1
     - Titulo
     - Nombre del subdominio
   * - 2
     - Descripcion
     - Breve descripcion del contenido
   * - 3
     - Metricas
     - Total artefactos, estado, fecha
   * - 4
     - Contenido/toctree
     - Lista de artefactos con toctree

**Opcionales:**

- Categorias (si hay agrupaciones)
- Trazabilidad (si es indice de modulo)
- Historial de cambios

----

Validacion
----------

Antes de aprobar un index.rst, verificar:

**Checklist:**

- [ ] Nombre de archivo es exactamente ``index.rst``
- [ ] Meta tags completos
- [ ] Descripcion presente
- [ ] Metricas actualizadas
- [ ] Todos los artefactos listados en toctree
- [ ] Nombres de archivo en toctree sin extension .rst
- [ ] Orden logico (numerico o alfabetico)
- [ ] Sin artefactos faltantes
- [ ] Sin artefactos inexistentes referenciados

**Comando de validacion:**

.. code-block:: bash

   # Validar que no hay archivos huerfanos
   sphinx-build -b html -W docs/ docs/_build/

   # Verificar warnings de toctree
   grep -i "toctree" docs/_build/output.log

----

Notas Importantes
-----------------

1. **Nombre de archivo**: Siempre ``index.rst``, nunca otro nombre
2. **toctree sin extension**: Listar ``BR_001`` no ``BR_001.rst``
3. **Orden**: Mantener orden numerico o logico consistente
4. **Actualizacion**: Actualizar metricas al agregar/eliminar artefactos
5. **Sphinx**: El toctree es obligatorio para que Sphinx navegue

----

Referencias
-----------

- Sphinx toctree: https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-toctree
- STD_001: Estructura de Documentacion
- STD_006: Versionado Semantico

----

Historial de Cambios
--------------------

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
     - Version inicial de plantilla INDEX
