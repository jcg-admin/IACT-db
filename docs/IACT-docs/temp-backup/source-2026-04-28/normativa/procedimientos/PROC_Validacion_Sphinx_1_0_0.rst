.. meta::
   :artefacto: PROC_Validacion_Sphinx
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Verificacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-validacion-sphinx:

==============================================================
PROC_Validacion_Sphinx: Validacion de Documentacion con Sphinx
==============================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Validacion_Sphinx
   * - **Nombre**
     - Validacion de Documentacion con Sphinx
   * - **Categoria**
     - Verificacion
   * - **Frecuencia**
     - Despues de cada generacion
   * - **Duracion**
     - 2-5 minutos

----

1. Proposito
------------

Validar que los artefactos RST generados cumplen con la sintaxis
requerida por Sphinx y pueden compilarse sin errores.

----

2. Alcance
----------

**Aplica A:** Todos los archivos .rst del proyecto.

**No Aplica A:** Archivos .md, configuracion.

----

3. Procedimiento
----------------

**Paso 1: Ubicar Archivos a Validar**

.. code-block:: bash

   # Archivo individual
   /tmp/artefacto.rst
   
   # Directorio completo
   /tmp/reglas_negocio/

**Paso 2: Ejecutar Validacion**

.. code-block:: bash

   # Validacion estricta (warnings = errores)
   sphinx-build -b html -W [origen] [destino]
   
   # Ejemplo
   sphinx-build -b html -W /tmp/docs/ /tmp/build/

**Paso 3: Analizar Errores**

Errores comunes:

.. list-table::
   :header-rows: 1

   * - Error
     - Causa
     - Solucion
   * - toctree contains reference to nonexisting document
     - Archivo no existe o nombre incorrecto
     - Verificar nombre sin .rst
   * - duplicate label
     - Referencia duplicada
     - Usar labels unicos
   * - Unexpected indentation
     - Indentacion incorrecta
     - Corregir espacios
   * - Unknown directive
     - Directiva no reconocida
     - Verificar sintaxis

**Paso 4: Corregir y Re-validar**

Iterar hasta build exitoso.

**Paso 5: Verificar Renderizado (opcional)**

.. code-block:: bash

   # Abrir HTML generado
   open /tmp/build/index.html

----

4. Comandos Utiles
------------------

.. code-block:: bash

   # Validacion rapida sin generar HTML
   sphinx-build -b dummy -W docs/ /tmp/dummy/
   
   # Validar archivo individual con rst2html
   rst2html.py archivo.rst /dev/null
   
   # Limpiar build anterior
   rm -rf /tmp/build/

----

5. Artefactos de Salida
-----------------------

- Build exitoso (sin errores)
- HTML generado (opcional)

----

6. Verificacion
---------------

- [ ] sphinx-build retorna codigo 0
- [ ] Sin warnings (con flag -W)
- [ ] HTML renderiza correctamente

----

7. Referencias
--------------

- Sphinx Documentation
- STD_005: Estilo Sphinx

----

8. Historial
------------

.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-07
     - Version inicial

----

*Documento version 1.0.0 - Proyecto IACT*
