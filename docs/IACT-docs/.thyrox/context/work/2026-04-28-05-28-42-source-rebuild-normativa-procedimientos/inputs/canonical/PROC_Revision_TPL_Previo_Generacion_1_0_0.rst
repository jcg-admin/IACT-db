.. meta::
   :artefacto: PROC_Revision_TPL_Previo_Generacion
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

.. _proc-revision-tpl-previo-generacion:

=============================================================================
PROC_Revision_TPL_Previo_Generacion: Revision de Template Previo a Generacion
=============================================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Revision_TPL_Previo_Generacion
   * - **Nombre**
     - Revision de Template Previo a Generacion de Artefacto
   * - **Categoria**
     - Preparacion
   * - **Frecuencia**
     - Antes de generar cualquier artefacto
   * - **Duracion Estimada**
     - 5-10 minutos
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece la obligacion de revisar el template (TPL) correspondiente
antes de generar cualquier artefacto del modelo documental. Garantiza consistencia
y adherencia a los estandares definidos.

**Objetivo:** Asegurar que todo artefacto generado cumple con la estructura y
secciones obligatorias definidas en su template.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Generacion de cualquier artefacto: BR, UC, FR, TST, CNST, MOD, ADR, etc.
- Primera generacion de un tipo de artefacto en una sesion
- Cuando hay dudas sobre estructura o secciones

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Generacion repetitiva del mismo tipo (ya revisado en la sesion)
- Edicion menor de artefactos existentes
- Actualizacion de metadatos unicamente

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
     - Revisa TPL antes de crear artefacto
     - Lectura de TPL

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] Tipo de artefacto a generar identificado
- [ ] Acceso a carpeta normativa/estandares/plantillas/
- [ ] TPL correspondiente existe

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_[TIPO]_[Nombre]_X_Y_Z.rst
     - Template del tipo de artefacto
     - Si

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Revision de TPL
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

   :Identificar tipo de artefacto a generar;

   :Localizar TPL correspondiente;

   if (TPL existe?) then (si)
       :Abrir TPL;
       :Leer seccion Proposito;
       :Leer seccion Nomenclatura;
       :Leer seccion Secciones Obligatorias;
       :Localizar seccion Plantilla;
       :Copiar contenido de Plantilla;
       :Proceder con generacion;
   else (no)
       :Reportar TPL faltante;
       :Crear TPL primero;
       stop
   endif

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Identificar TPL Correspondiente**

- **Responsable**: Generador
- **Accion**: Determinar cual TPL usar segun tipo de artefacto:

  .. list-table::
     :widths: 30 70
     :header-rows: 1

     * - Artefacto
       - TPL
     * - BR
       - TPL_BR_Business_Rules_1_0_0.rst
     * - UC
       - TPL_UC_Casos_de_Uso_2_0_0.rst
     * - FR
       - TPL_FR_Requisitos_Funcionales_1_0_0.rst
     * - TST
       - TPL_TST_Pruebas_1_0_0.rst
     * - CNST
       - TPL_CNST_Restricciones_1_0_0.rst
     * - MOD
       - TPL_MOD_Modulos_1_0_0.rst
     * - ADR
       - TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
     * - STD
       - TPL_STD_Estandares_1_0_0.rst
     * - PROC
       - TPL_PROC_Procedimientos_1_0_0.rst

- **Resultado**: TPL identificado
- **Verificacion**: TPL existe en carpeta plantillas/

**Paso 2: Abrir y Leer TPL**

- **Responsable**: Generador
- **Accion**: Abrir archivo TPL y leer secciones clave:

  1. **Proposito**: Entender para que sirve el artefacto
  2. **Nomenclatura**: Verificar formato de ID y nombre de archivo
  3. **Secciones Obligatorias**: Lista de secciones que DEBE tener
  4. **Plantilla**: Codigo RST a copiar

- **Resultado**: Comprension de estructura requerida
- **Verificacion**: Secciones obligatorias identificadas

**Paso 3: Revisar Nomenclatura**

- **Responsable**: Generador
- **Accion**: Verificar formato correcto:

  .. code-block:: text

     Formato general:
     [TIPO]_[Identificador]_[Nombre].rst
     
     Ejemplos:
     - BR_015_Bloqueo_Intentos_Fallidos.rst
     - FR-001.03_Generar_token_JWT.rst
     - UC_001_Iniciar_Sesion.rst

- **Resultado**: Nomenclatura correcta definida
- **Verificacion**: Patron coincide con ejemplos en TPL

**Paso 4: Localizar Seccion Plantilla**

- **Responsable**: Generador
- **Accion**: Buscar seccion "Plantilla" en TPL que contiene el codigo RST base:

  .. code-block:: rst

     Plantilla
     ---------

     .. code-block:: rst

        .. meta::
           :artefacto: [ID]
           ...

- **Resultado**: Codigo RST base localizado
- **Verificacion**: Seccion contiene code-block rst

**Paso 5: Copiar Contenido de Plantilla**

- **Responsable**: Generador
- **Accion**: Copiar todo el contenido dentro del code-block rst
- **Resultado**: Plantilla copiada lista para usar
- **Verificacion**: Todos los [PLACEHOLDER] presentes

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - Plantilla copiada
     - Codigo RST base para nuevo artefacto
     - Memoria/portapapeles

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] TPL revisado y comprendido
- [ ] Nomenclatura correcta identificada
- [ ] Secciones obligatorias conocidas
- [ ] Plantilla RST copiada lista para usar

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] TPL correspondiente al tipo de artefacto fue revisado
- [ ] Nomenclatura del nuevo artefacto sigue patron del TPL
- [ ] Artefacto generado incluye todas las secciones obligatorias

9.2 Checklist Rapido
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Antes de generar [TIPO]:
   [ ] Abri TPL_[TIPO]?
   [ ] Lei nomenclatura?
   [ ] Copie la plantilla?
   [ ] Conozco secciones obligatorias?

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - TPL no existe
     - Crear TPL primero usando TPL_INDEX como guia
   * - TPL desactualizado
     - Actualizar TPL antes de generar artefactos
   * - Version TPL incorrecta
     - Usar ultima version disponible

----

11. Referencias
---------------

- normativa/estandares/plantillas/index.rst: Indice de TPL
- STD_006: Versionado Semantico
- Todos los TPL_[TIPO]_[Nombre]_X_Y_Z.rst

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
