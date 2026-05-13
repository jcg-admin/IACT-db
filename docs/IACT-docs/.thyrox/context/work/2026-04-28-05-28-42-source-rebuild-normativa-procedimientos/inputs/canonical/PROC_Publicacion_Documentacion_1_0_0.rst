.. meta::
   :artefacto: PROC_Publicacion_Documentacion
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Publicacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :autor: Equipo IACT

.. _proc-publicacion-documentacion:

============================================================
PROC_Publicacion_Documentacion: Publicacion de Documentacion
============================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75

   * - **ID**
     - PROC_Publicacion_Documentacion
   * - **Nombre**
     - Publicacion de Documentacion Final
   * - **Categoria**
     - Publicacion
   * - **Frecuencia**
     - Por release o milestone
   * - **Duracion**
     - 30-60 minutos

----

1. Proposito
------------

Publicar documentacion validada y aprobada para acceso del equipo
y stakeholders, generando HTML navegable con Sphinx.

----

2. Alcance
----------

**Aplica A:** Documentacion aprobada lista para publicar.

**No Aplica A:** Borradores, documentos en revision.

----

3. Procedimiento
----------------

**Paso 1: Verificar Prerequisitos**

- [ ] Documentacion validada (PROC_Validacion_Sphinx)
- [ ] Artefactos aprobados (PROC_Aprobacion_Documentos)
- [ ] Indices actualizados
- [ ] Sin gaps criticos

**Paso 2: Actualizar Modelo Documental**

Ejecutar PROC_Actualizacion_Modelo_Documental con nueva version.

**Paso 3: Generar Build Final**

.. code-block:: bash

   # Limpiar build anterior
   rm -rf docs/_build/
   
   # Generar HTML
   sphinx-build -b html docs/ docs/_build/html/
   
   # Verificar sin errores
   echo $?  # Debe ser 0

**Paso 4: Verificar Navegacion**

- [ ] Index principal carga
- [ ] Links internos funcionan
- [ ] Diagramas PlantUML renderizan
- [ ] Busqueda funciona

**Paso 5: Publicar**

Segun ambiente destino:

.. code-block:: bash

   # Opcion 1: GitHub Pages
   ghp-import -n -p docs/_build/html/
   
   # Opcion 2: Servidor interno
   rsync -avz docs/_build/html/ server:/var/www/docs/
   
   # Opcion 3: ReadTheDocs
   # Push a rama main, RTD construye automaticamente

**Paso 6: Notificar Stakeholders**

.. code-block:: text

   NOTIFICACION DE PUBLICACION
   
   Nueva version de documentacion disponible:
   - URL: https://docs.iact.example.com/
   - Version: v2.1.2
   - Fecha: 2026-01-07
   
   Cambios principales:
   - 8 nuevos PROC
   - 17 TPL actualizados

**Paso 7: Registrar Publicacion**

.. code-block:: text

   REGISTRO DE PUBLICACIONES
   
.. list-table::
   :header-rows: 1

   * - Version
     - Fecha
     - URL
     - Responsable
   * - v2.1.2
     - 2026-01-07
     - docs.iact/
     - Equipo IACT

----

4. Artefactos de Salida
-----------------------

- HTML publicado
- Notificacion enviada
- Registro actualizado

----

5. Verificacion
---------------

- [ ] URL accesible
- [ ] Contenido actualizado
- [ ] Sin errores 404
- [ ] Stakeholders notificados

----

6. Referencias
--------------

- PROC_Validacion_Sphinx
- PROC_Actualizacion_Modelo_Documental
- Sphinx Documentation

----

7. Historial
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
