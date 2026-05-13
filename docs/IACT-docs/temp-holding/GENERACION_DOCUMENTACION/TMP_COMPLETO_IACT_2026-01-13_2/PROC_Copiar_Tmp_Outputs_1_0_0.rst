.. meta::
   :artefacto: PROC_Copiar_Tmp_Outputs
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Transferencia
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-copiar-tmp-outputs:

==============================================================================
PROC_Copiar_Tmp_Outputs: Transferir Artefactos de /tmp a /outputs
==============================================================================

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
     - PROC_Copiar_Tmp_Outputs
   * - **Nombre**
     - Transferir Artefactos de /tmp a /outputs
   * - **Categoria**
     - Transferencia y Publicacion
   * - **Frecuencia**
     - Al finalizar cada sesion de generacion
   * - **Duracion Estimada**
     - 2-5 minutos
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para transferir artefactos generados
en /tmp al directorio /mnt/user-data/outputs/ donde seran accesibles
para el usuario final.

**Objetivo:** Asegurar que los artefactos validados se publican correctamente
y estan disponibles para descarga o visualizacion.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Artefactos RST generados en /tmp
- Documentos de analisis (.md) en /tmp
- Cualquier archivo que deba ser entregado al usuario

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Archivos temporales de trabajo (borradores)
- Archivos con errores de validacion
- Logs o archivos de depuracion

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
     - Ejecuta transferencia
     - Escritura en /outputs

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Artefactos generados en /tmp
- [ ] Validacion Sphinx ejecutada sin errores (si aplica)
- [ ] Nomenclatura de archivos correcta
- [ ] Contenido completo (no truncado)

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - Archivos en /tmp
     - Artefactos a transferir
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Transferencia
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
   }

   start
   :Listar archivos en /tmp;
   :Verificar nomenclatura;

   if (Archivos validos?) then (si)
       :Verificar contenido completo;
       
       if (Contenido OK?) then (si)
           :Copiar a /outputs;
           :Verificar copia exitosa;
           :Presentar archivos al usuario;
       else (no)
           :Corregir contenido;
           stop
       endif
   else (no)
       :Corregir nomenclatura;
       stop
   endif

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Listar Archivos a Transferir**

- **Responsable**: Generador
- **Accion**: Identificar archivos generados:

  .. code-block:: bash

     # Listar archivos RST
     ls -la /tmp/*.rst
     
     # Listar archivos MD
     ls -la /tmp/*.md
     
     # Listar estructura de carpetas (si aplica)
     find /tmp/[dominio] -type f -name "*.rst" | wc -l

- **Resultado**: Lista de archivos a transferir
- **Verificacion**: Archivos existen

**Paso 2: Verificar Nomenclatura**

- **Responsable**: Generador
- **Accion**: Confirmar que nombres siguen estandar:

  .. code-block:: text

     Patrones validos:
     - TPL_[Nombre]_X_Y_Z.rst
     - PROC_[Nombre]_X_Y_Z.rst
     - BR_[NNN]_[Nombre].rst
     - FR_UC[NNN]_[NN]_[Nombre].rst
     - ANALISIS_[Nombre].md

- **Resultado**: Nomenclatura verificada
- **Verificacion**: Todos los archivos cumplen patron

**Paso 3: Verificar Contenido Completo**

- **Responsable**: Generador
- **Accion**: Confirmar que archivos no estan truncados:

  .. code-block:: bash

     # Verificar lineas por archivo
     wc -l /tmp/[archivo]
     
     # Verificar que termina correctamente (RST)
     tail -5 /tmp/[archivo].rst
     # Debe mostrar pie de documento o historial

- **Resultado**: Contenido verificado
- **Verificacion**: Archivos completos

**Paso 4: Ejecutar Copia**

- **Responsable**: Generador
- **Accion**: Copiar archivos a /outputs:

  .. code-block:: bash

     # Archivo individual
     cp /tmp/[archivo] /mnt/user-data/outputs/
     
     # Multiples archivos
     cp /tmp/*.rst /mnt/user-data/outputs/
     
     # Estructura de carpetas
     cp -r /tmp/[dominio]/ /mnt/user-data/outputs/

- **Resultado**: Archivos copiados
- **Verificacion**: Sin errores de copia

**Paso 5: Verificar Copia Exitosa**

- **Responsable**: Generador
- **Accion**: Confirmar archivos en destino:

  .. code-block:: bash

     # Verificar existencia
     ls -la /mnt/user-data/outputs/[archivo]
     
     # Verificar tamanio coincide
     wc -l /mnt/user-data/outputs/[archivo]
     
     # Comparar con origen
     diff /tmp/[archivo] /mnt/user-data/outputs/[archivo]

- **Resultado**: Copia verificada
- **Verificacion**: Archivos identicos

**Paso 6: Presentar Archivos al Usuario**

- **Responsable**: Generador
- **Accion**: Usar herramienta present_files:

  .. code-block:: text

     Invocar present_files con:
     - filepaths: lista de archivos en /outputs
     
     Esto genera links descargables para el usuario.

- **Resultado**: Archivos presentados
- **Verificacion**: Usuario puede acceder

**Paso 7: Limpiar /tmp (Opcional)**

- **Responsable**: Generador
- **Accion**: Eliminar archivos ya transferidos:

  .. code-block:: bash

     # Solo si copia fue exitosa
     rm /tmp/[archivo]
     
     # O limpiar carpeta completa
     rm -rf /tmp/[dominio]/

- **Resultado**: /tmp limpio
- **Verificacion**: Espacio liberado

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - Archivos transferidos
     - Artefactos disponibles para usuario
     - /mnt/user-data/outputs/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Archivos copiados a /outputs
- [ ] Copia verificada (tamanio, contenido)
- [ ] Archivos presentados al usuario
- [ ] /tmp limpio (opcional)

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Todos los archivos copiados
- [ ] Nomenclatura correcta mantenida
- [ ] Contenido identico a origen
- [ ] Usuario puede acceder/descargar

9.2 Comando de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Contar archivos en outputs
   ls /mnt/user-data/outputs/*.rst | wc -l
   
   # Verificar ultimo archivo
   ls -lt /mnt/user-data/outputs/ | head -5

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Archivo ya existe en /outputs
     - Sobrescribir si es version nueva, o renombrar
   * - Error de permisos
     - Verificar permisos de escritura
   * - Espacio insuficiente
     - Limpiar archivos antiguos de /outputs
   * - Archivo truncado
     - Regenerar archivo antes de copiar

----

11. Referencias
---------------

- PROC_Crear_Estructura_Directorios_Tmp
- PROC_Validacion_Sphinx
- Documentacion present_files tool

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
