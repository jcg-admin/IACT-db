.. meta::
   :artefacto: PROC_Versionado_Semantico
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-versionado-semantico:

=======================================================
PROC_Versionado_Semantico: Aplicar Versionado Semantico
=======================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Versionado_Semantico
   * - **Nombre**
     - Aplicar Versionado Semantico a Artefactos
   * - **Categoria**
     - Gobernanza
   * - **Frecuencia**
     - Por cada cambio en artefacto
   * - **Duracion Estimada**
     - 2-5 minutos
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece como aplicar el estandar STD_006 de Versionado
Semantico a todos los artefactos del proyecto IACT.

**Objetivo:** Garantizar consistencia en el versionado y comunicar claramente
el tipo de cambio realizado.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Todos los artefactos versionados: TPL, PROC, STD, POL, MOD
- Documentos con historial de cambios
- Modelo documental

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Artefactos de contenido (BR, UC, FR) que usan version simple
- Archivos de analisis temporales (.md)

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Autor
     - Aplica versionado al modificar
     - Escritura en artefacto

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] STD_006 revisado y comprendido
- [ ] Version actual del artefacto conocida
- [ ] Tipo de cambio identificado

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - Artefacto a versionar
     - Documento con cambios
     - Si
   * - STD_006
     - Estandar de versionado
     - Si

----

6. Procedimiento
----------------

6.1 Formato de Version
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   MAJOR.MINOR.PATCH
   
   Donde:
   - MAJOR: Cambios incompatibles, reestructuracion
   - MINOR: Nueva funcionalidad, compatible
   - PATCH: Correcciones, mejoras menores

6.2 Reglas de Incremento
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 50 30
   :header-rows: 1

   * - Incremento
     - Cuando Aplicar
     - Ejemplo
   * - MAJOR
     - Reestructuracion completa, cambio de formato
     - 1.0.0 -> 2.0.0
   * - MINOR
     - Nueva seccion, contenido adicional significativo
     - 1.0.0 -> 1.1.0
   * - PATCH
     - Correccion de errores, mejoras menores
     - 1.0.0 -> 1.0.1

6.3 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Identificar Tipo de Cambio**

- **Responsable**: Autor
- **Accion**: Clasificar el cambio:

  .. code-block:: text

     Preguntas para clasificar:
     
     1. El cambio rompe compatibilidad con version anterior?
        Si -> MAJOR
     
     2. Se agrega funcionalidad nueva manteniendo compatibilidad?
        Si -> MINOR
     
     3. Es correccion de error o mejora menor?
        Si -> PATCH

- **Resultado**: Tipo identificado
- **Verificacion**: Clasificacion correcta

**Paso 2: Calcular Nueva Version**

- **Responsable**: Autor
- **Accion**: Aplicar incremento:

  .. code-block:: text

     Version actual: 1.2.3
     
     Si MAJOR: 2.0.0 (resetea MINOR y PATCH)
     Si MINOR: 1.3.0 (resetea PATCH)
     Si PATCH: 1.2.4

- **Resultado**: Nueva version
- **Verificacion**: Formato X.Y.Z

**Paso 3: Actualizar Nombre de Archivo**

- **Responsable**: Autor
- **Accion**: Renombrar archivo con nueva version:

  .. code-block:: bash

     # Formato
     [TIPO]_[Nombre]_[MAJOR]_[MINOR]_[PATCH].rst
     
     # Ejemplo
     PROC_Generacion_FR_1_0_0.rst -> PROC_Generacion_FR_1_1_0.rst

- **Resultado**: Archivo renombrado
- **Verificacion**: Nombre correcto

**Paso 4: Actualizar Metadatos**

- **Responsable**: Autor
- **Accion**: Modificar meta tags:

  .. code-block:: rst

     .. meta::
        :version: 1.1.0           <- Actualizar
        :ultimo_cambio: 2026-01-07  <- Actualizar

- **Resultado**: Metadatos actualizados
- **Verificacion**: Consistente con nombre archivo

**Paso 5: Actualizar Historial de Cambios**

- **Responsable**: Autor
- **Accion**: Agregar entrada al historial:

  .. code-block:: rst

     .. list-table::
        :header-rows: 1
     
        * - Version
          - Fecha
          - Autor
          - Cambios
        * - 1.1.0          <- Nueva entrada
          - 2026-01-07
          - Equipo IACT
          - Agregada seccion de validacion
        * - 1.0.0
          - 2026-01-06
          - Equipo IACT
          - Version inicial

- **Resultado**: Historial actualizado
- **Verificacion**: Entrada agregada

**Paso 6: Actualizar Referencias**

- **Responsable**: Autor
- **Accion**: Si otros artefactos referencian este, actualizar:

  .. code-block:: text

     Buscar referencias a version anterior:
     - En otros PROC
     - En index.rst
     - En modelo documental

- **Resultado**: Referencias actualizadas
- **Verificacion**: Sin referencias obsoletas

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - Artefacto versionado
     - Documento con nueva version
     - Ubicacion original

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Nombre de archivo con nueva version
- [ ] Meta tags actualizados
- [ ] Historial de cambios con nueva entrada
- [ ] Referencias actualizadas

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Version sigue formato X.Y.Z
- [ ] Incremento correcto segun tipo de cambio
- [ ] Nombre archivo = meta tag version
- [ ] Historial incluye cambio

9.2 Errores Comunes
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - Error
     - Correccion
   * - Saltar version (1.0.0 -> 1.0.2)
     - Siempre incrementar secuencialmente
   * - No resetear al incrementar MAJOR
     - 1.5.3 -> 2.0.0 (no 2.5.3)
   * - Version en archivo != meta tag
     - Sincronizar ambos valores

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - Version ya existe
     - Incrementar PATCH adicional
   * - Duda sobre tipo de cambio
     - Usar incremento menor (PATCH)
   * - Multiples cambios
     - Usar el incremento mayor aplicable

----

11. Referencias
---------------

- STD_006: Versionado Semantico
- SemVer: https://semver.org/

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
