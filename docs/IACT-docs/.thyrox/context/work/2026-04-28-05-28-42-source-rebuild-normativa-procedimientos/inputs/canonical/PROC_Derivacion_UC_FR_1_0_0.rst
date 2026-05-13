.. meta::
   :artefacto: PROC_Derivacion_UC_FR
   :tipo: Procedimiento
   :dominio: normativa
   :subdominio: procedimientos
   :categoria: Derivacion
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _proc-derivacion-uc-fr:

==========================================================================
PROC_Derivacion_UC_FR: Derivacion de Casos de Uso a Requisitos Funcionales
==========================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Derivacion_UC_FR
   * - **Nombre**
     - Derivacion de UC a FR
   * - **Categoria**
     - Derivacion
   * - **Frecuencia**
     - Por cada modulo a derivar
   * - **Duracion Estimada**
     - 1-2 horas por modulo
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece la metodologia para derivar Requisitos Funcionales (FR)
desde Casos de Uso (UC). Define como identificar, nombrar y documentar los FR
que implementan cada UC.

**Objetivo:** Garantizar trazabilidad completa UC -> FR y cobertura de todos
los pasos del sistema definidos en los UC.

**Ratio esperado:** 1 UC -> 3-8 FR (promedio: 1:4)

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Derivacion sistematica de FR desde UC existentes
- Sesiones de derivacion por modulo completo
- Verificacion de cobertura UC -> FR

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Creacion de FR sin UC padre (no permitido)
- Derivacion de UC desde BR (usar PROC_Derivacion_BR_UC)
- Modificacion de FR existentes

----

3. Roles y Responsabilidades
----------------------------

.. list-table::
   :widths: 20 40 40
   :header-rows: 1

   * - Rol
     - Responsabilidad
     - Permisos Requeridos
   * - Analista
     - Ejecuta derivacion, genera FR
     - Escritura en funcionales/
   * - Arquitecto
     - Valida completitud y consistencia
     - Lectura de UC, FR, BR

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] UC del modulo generados y aprobados
- [ ] PROC_Revision_UC_Previo_Derivacion ejecutado
- [ ] PROC_Crear_Estructura_Directorios_Tmp ejecutado
- [ ] TPL_FR revisado (PROC_Revision_TPL_Previo_Generacion)
- [ ] BR y CNST del modulo disponibles

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - UC_[NNN]_[Nombre].rst
     - Casos de Uso del modulo
     - Si
   * - TPL_FR_Requisitos_Funcionales_1_0_0.rst
     - Template de FR
     - Si
   * - Documento de trabajo
     - Lista FR extraida de revision UC
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Derivacion UC a FR
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

   :Seleccionar modulo a derivar;
   :Obtener lista de UC del modulo;

   partition "Por cada UC" {
       :Abrir UC;
       :Extraer pasos del Sistema;
       :Mapear pasos a FR;
       
       partition "Por cada FR" {
           :Ejecutar PROC_Generacion_FR;
       }
       
       :Verificar cobertura UC;
   }

   :Calcular metricas de derivacion;
   :Generar index.rst del modulo;
   :Validar con Sphinx;

   stop
   @enduml

6.2 Metodologia de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Regla Principal:** Cada paso del Flujo Normal que comienza con "Sistema..."
genera al menos un FR.

**Ejemplo de Derivacion:**

.. code-block:: text

   UC_001: Iniciar Sesion
   
   Flujo Normal:
   1. Usuario accede a pantalla -> NO genera FR (accion usuario)
   2. Sistema muestra formulario -> FR: Mostrar formulario login
   3. Usuario ingresa credenciales -> NO genera FR (accion usuario)
   4. Usuario presiona boton -> NO genera FR (accion usuario)
   5. Sistema valida formato -> FR: Validar formato campos
   6. Sistema verifica credenciales -> FR: Verificar credenciales
   7. Sistema invalida sesiones -> FR: Invalidar sesiones previas
   8. Sistema genera token -> FR: Generar token JWT
   9. Sistema registra evento -> FR: Registrar evento auditoria
   10. Sistema redirige -> FR: Redirigir a dashboard
   
   Resultado: 6 FR derivados de UC_001

6.3 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Seleccionar Modulo**

- **Responsable**: Analista
- **Accion**: Identificar modulo a derivar segun prioridad:

  .. list-table::
     :widths: 20 20 30 30
     :header-rows: 1

     * - Modulo
       - UC
       - FR Estimados
       - Prioridad
     * - MOD_Auth
       - 5
       - ~21
       - Alta
     * - MOD_Users
       - 4
       - ~17
       - Alta
     * - MOD_Access
       - 9
       - ~30
       - Alta
     * - MOD_Reports
       - 14
       - ~41
       - Media
     * - MOD_Pipeline
       - 4
       - ~11
       - Media
     * - MOD_Alerts
       - 5
       - ~16
       - Media
     * - MOD_Audit
       - 4
       - ~12
       - Baja
     * - MOD_Logs
       - 4
       - ~10
       - Baja

- **Resultado**: Modulo seleccionado
- **Verificacion**: UC del modulo disponibles

**Paso 2: Listar UC del Modulo**

- **Responsable**: Analista
- **Accion**: Obtener lista ordenada de UC:

  .. code-block:: bash

     ls casos_uso/[modulo]/UC_*.rst | sort

- **Resultado**: Lista de UC a procesar
- **Verificacion**: Cantidad coincide con inventario

**Paso 3: Analizar Flujo Normal del UC**

- **Responsable**: Analista
- **Accion**: Para cada UC, identificar pasos del sistema:

  1. Abrir archivo UC
  2. Localizar seccion "Flujo Normal"
  3. Extraer pasos que inician con "Sistema"
  4. Cada paso = 1 FR candidato

- **Resultado**: Lista de FR candidatos
- **Verificacion**: Todos los pasos "Sistema" identificados

**Paso 4: Verificar contra Seccion Trazabilidad**

- **Responsable**: Analista
- **Accion**: Comparar FR candidatos con seccion "FR Derivados" del UC:

  .. code-block:: text

     Seccion Trazabilidad del UC:
     **FR Derivados:**
     - FR-001.01: Validar formato username
     - FR-001.02: Validar credenciales
     - FR-001.03: Generar token JWT
     ...

- **Resultado**: Lista oficial de FR confirmada
- **Verificacion**: FR candidatos = FR en Trazabilidad

**Paso 5: Generar FR**

- **Responsable**: Analista
- **Accion**: Para cada FR, ejecutar PROC_Generacion_FR
- **Resultado**: Archivo FR creado
- **Verificacion**: FR existe en /tmp/funcionales/[mod]/UC_[NNN]/

**Paso 6: Verificar Cobertura del UC**

- **Responsable**: Analista
- **Accion**: Confirmar que todos los pasos "Sistema" tienen FR:

  .. code-block:: text

     UC_001 Cobertura:
     - Paso 2 (muestra formulario) -> FR_UC001_01 [OK]
     - Paso 5 (valida formato) -> FR_UC001_02 [OK]
     - Paso 6 (verifica credenciales) -> FR_UC001_03 [OK]
     ...
     Cobertura: 100%

- **Resultado**: Cobertura verificada
- **Verificacion**: Todos los pasos cubiertos

**Paso 7: Calcular Metricas**

- **Responsable**: Analista
- **Accion**: Al completar modulo, calcular:

  .. code-block:: text

     Metricas MOD_Auth:
     - UC procesados: 5
     - FR generados: 21
     - Ratio promedio: 4.2 FR/UC
     - Cobertura: 100%

- **Resultado**: Metricas del modulo
- **Verificacion**: Ratio dentro de rango esperado (3-8)

**Paso 8: Generar Index del Modulo**

- **Responsable**: Analista
- **Accion**: Crear/actualizar index.rst:

  .. code-block:: rst

                                      
     Requisitos Funcionales - MOD_Auth
                                      
     
     .. toctree::
        :maxdepth: 2
        :caption: UC_001: Iniciar Sesion
     
        UC_001_Iniciar_Sesion/FR_UC001_01_Validar_formato
        UC_001_Iniciar_Sesion/FR_UC001_02_Verificar_credenciales
        ...

- **Resultado**: Index actualizado
- **Verificacion**: Todos los FR listados en toctree

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - FR_UC[NNN]_[NN]_[Nombre].rst
     - FR generados (multiples)
     - /tmp/funcionales/[mod]/UC_[NNN]/
   * - index.rst
     - Indice del modulo
     - /tmp/funcionales/[mod]/
   * - Reporte de metricas
     - Estadisticas de derivacion
     - Documento de trabajo

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] Todos los UC del modulo tienen FR derivados
- [ ] Cobertura 100% de pasos "Sistema"
- [ ] Index del modulo actualizado
- [ ] Metricas calculadas (UC, FR, ratio)
- [ ] Validacion Sphinx sin errores

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] Cada UC tiene minimo 1 FR
- [ ] Ratio FR/UC entre 3 y 8
- [ ] Todos los FR tienen UC padre
- [ ] Index lista todos los FR
- [ ] Sintaxis RST valida

9.2 Matriz de Cobertura
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 20 20 20 20
   :header-rows: 1

   * - Modulo
     - UC
     - FR Esperados
     - FR Generados
     - Cobertura
   * - MOD_Auth
     - 5
     - ~21
     - [N]
     - [%]
   * - MOD_Users
     - 4
     - ~17
     - [N]
     - [%]
   * - ...
     - ...
     - ...
     - ...
     - ...

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - UC sin pasos "Sistema"
     - Revisar UC, posible error de redaccion
   * - Ratio < 3 FR/UC
     - Verificar que no faltan FR
   * - Ratio > 8 FR/UC
     - Verificar granularidad, posible subdivision excesiva

----

11. Referencias
---------------

- PROC_Revision_UC_Previo_Derivacion
- PROC_Generacion_FR
- TPL_FR_Requisitos_Funcionales_1_0_0.rst
- FND_04: Trazabilidad

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
