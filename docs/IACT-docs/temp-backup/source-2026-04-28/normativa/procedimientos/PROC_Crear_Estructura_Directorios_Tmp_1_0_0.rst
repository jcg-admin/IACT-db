.. meta::
   :artefacto: PROC_Crear_Estructura_Directorios_Tmp
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Preparacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-crear-estructura-directorios-tmp:

==============================================================================
PROC_Crear_Estructura_Directorios_Tmp: Crear Estructura de Directorios en /tmp
==============================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Crear_Estructura_Directorios_Tmp
   * - **Nombre**
     - Crear Estructura de Directorios en /tmp
   * - **Categoria**
     - Preparacion
   * - **Frecuencia**
     - Antes de cada sesion de generacion masiva
   * - **Duracion Estimada**
     - 2-5 minutos
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece como crear la estructura de directorios en /tmp
antes de generar artefactos. El uso de /tmp permite trabajar de forma segura
sin afectar el repositorio principal hasta que los artefactos esten validados.

**Objetivo:** Preparar el espacio de trabajo temporal con la estructura
correcta de carpetas para generar artefactos de forma organizada.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Generacion masiva de artefactos (FR, TST, etc.)
- Sesiones de trabajo que producen multiples archivos
- Cualquier generacion que requiera estructura de carpetas

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Generacion de archivo unico (se puede crear directo en /tmp)
- Edicion de artefactos existentes en outputs
- Documentos de analisis (.md)

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
     - Crea estructura de directorios
     - Escritura en /tmp

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Tipo de artefactos a generar definido
- [ ] Estructura de carpetas destino conocida (segun modelo documental)
- [ ] Acceso a /tmp disponible

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - MODELO_DOCUMENTAL_IACT
     - Estructura de carpetas oficial
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Creacion de Estructura
   :align: center

   @startuml
   skinparam backgroundColor #FAFAFA
   skinparam activity {
       BackgroundColor #E3F2FD
       BorderColor #1976D2
       DiamondBackgroundColor #FFF9C4
       DiamondBorderColor #F57C00
   }

   start

   :Identificar tipo de artefacto;
   :Determinar estructura de carpetas;

   if (Estructura por modulo?) then (si)
       :Crear carpeta raiz en /tmp;
       :Crear subcarpetas por modulo;
       :Crear subcarpetas por UC (si aplica);
   else (no)
       :Crear carpeta unica en /tmp;
   endif

   :Verificar estructura creada;

   stop
   @enduml

6.2 Estructuras por Tipo de Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Para FR (Requisitos Funcionales):**

.. code-block:: bash

   # Estructura para FR
   mkdir -p /tmp/funcionales/{auth,users,access,pipeline,reports,alerts,audit,logs}
   
   # Subcarpetas por UC dentro de cada modulo
   mkdir -p /tmp/funcionales/auth/UC_001_Iniciar_Sesion
   mkdir -p /tmp/funcionales/auth/UC_002_Cerrar_Sesion
   # ... etc

**Para TST (Pruebas):**

.. code-block:: bash

   # Estructura para TST
   mkdir -p /tmp/pruebas/{auth,users,access,pipeline,reports,alerts,audit,logs}

**Para UC (Casos de Uso):**

.. code-block:: bash

   # Estructura para UC
   mkdir -p /tmp/casos_uso/{auth,users,access,pipeline,reports,alerts,audit,logs}

**Para BR (Business Rules):**

.. code-block:: bash

   # Estructura plana para BR
   mkdir -p /tmp/reglas_negocio

**Para PROC (Procedimientos):**

.. code-block:: bash

   # Estructura plana para PROC
   mkdir -p /tmp/procedimientos

6.3 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Identificar Estructura Requerida**

- **Responsable**: Generador
- **Accion**: Determinar estructura segun tipo de artefacto:

  .. list-table::
     :widths: 20 40 40
     :header-rows: 1

     * - Tipo
       - Estructura
       - Ejemplo
     * - FR
       - Por modulo y UC
       - /tmp/funcionales/auth/UC_001/
     * - TST
       - Por modulo
       - /tmp/pruebas/auth/
     * - UC
       - Por modulo
       - /tmp/casos_uso/auth/
     * - BR
       - Plana
       - /tmp/reglas_negocio/
     * - PROC
       - Plana
       - /tmp/procedimientos/
     * - TPL
       - Plana
       - /tmp/plantillas/

- **Resultado**: Estructura identificada
- **Verificacion**: Coincide con modelo documental

**Paso 2: Crear Carpeta Raiz**

- **Responsable**: Generador
- **Accion**: Crear carpeta principal en /tmp

  .. code-block:: bash

     mkdir -p /tmp/[dominio]

- **Resultado**: Carpeta raiz creada
- **Verificacion**: ``ls /tmp/[dominio]`` no da error

**Paso 3: Crear Subcarpetas por Modulo (si aplica)**

- **Responsable**: Generador
- **Accion**: Crear los 8 modulos IACT

  .. code-block:: bash

     # Los 8 modulos IACT
     for mod in auth users access pipeline reports alerts audit logs; do
         mkdir -p /tmp/[dominio]/$mod
     done

- **Resultado**: 8 subcarpetas de modulo creadas
- **Verificacion**: ``ls /tmp/[dominio]/`` muestra 8 carpetas

**Paso 4: Crear Subcarpetas por UC (solo para FR)**

- **Responsable**: Generador
- **Accion**: Para FR, crear carpeta por cada UC

  .. code-block:: bash

     # Ejemplo para auth (5 UC)
     mkdir -p /tmp/funcionales/auth/UC_001_Iniciar_Sesion
     mkdir -p /tmp/funcionales/auth/UC_002_Cerrar_Sesion
     mkdir -p /tmp/funcionales/auth/UC_003_Recuperar_Password
     mkdir -p /tmp/funcionales/auth/UC_004_Cambiar_Password
     mkdir -p /tmp/funcionales/auth/UC_005_Gestionar_Sesiones

- **Resultado**: Subcarpetas por UC creadas
- **Verificacion**: Estructura lista para recibir FR

**Paso 5: Verificar Estructura Completa**

- **Responsable**: Generador
- **Accion**: Listar estructura creada

  .. code-block:: bash

     # Verificar estructura
     find /tmp/[dominio] -type d | head -20

- **Resultado**: Estructura verificada
- **Verificacion**: Todas las carpetas necesarias existen

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - Estructura de directorios
     - Carpetas creadas en /tmp
     - /tmp/[dominio]/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Estructura de carpetas creada en /tmp
- [ ] Subcarpetas por modulo (si aplica)
- [ ] Subcarpetas por UC (si aplica para FR)
- [ ] Espacio de trabajo listo para generacion

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Carpeta raiz existe en /tmp
- [ ] Subcarpetas de modulos creadas (8 si aplica)
- [ ] Nombres de carpetas coinciden con modelo documental
- [ ] Permisos de escritura disponibles

9.2 Comando de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Verificar estructura FR
   find /tmp/funcionales -type d | wc -l
   
   # Debe ser: 1 (raiz) + 8 (modulos) + N (UC) = minimo 9

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Carpeta ya existe
     - Verificar contenido, limpiar si es necesario
   * - Sin permisos en /tmp
     - Usar directorio alternativo con permisos
   * - Espacio insuficiente
     - Limpiar /tmp de archivos anteriores

----

11. Referencias
---------------

- MODELO_DOCUMENTAL_IACT: Estructura oficial de carpetas
- PROC_Copiar_Tmp_Outputs: Siguiente paso (transferir a outputs)

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
