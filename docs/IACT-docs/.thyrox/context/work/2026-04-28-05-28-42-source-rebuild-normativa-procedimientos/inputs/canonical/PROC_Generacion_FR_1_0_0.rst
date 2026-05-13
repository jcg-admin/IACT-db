.. meta::
   :artefacto: PROC_Generacion_FR
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

.. _proc-generacion-fr:

========================================================
PROC_Generacion_FR: Generacion de Requisitos Funcionales
========================================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_FR
   * - **Nombre**
     - Generacion de Requisitos Funcionales
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada UC a derivar
   * - **Duracion Estimada**
     - 10-20 minutos por FR
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar Requisitos Funcionales (FR)
a partir de Casos de Uso (UC). Cada FR documenta una capacidad especifica
que el sistema debe implementar.

**Objetivo:** Crear FR completos, trazables y verificables que sirvan como
base para la implementacion y pruebas del sistema.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Generacion de FR derivados de UC existentes
- FR de todos los modulos IACT
- FR de cualquier tipo (Validacion, Proceso, Interfaz, Datos, Auditoria, Seguridad)

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Requisitos No Funcionales (usar PROC_Generacion_NFR)
- Modificacion de FR existentes (usar PROC_Cambio_Requisitos)
- FR sin UC padre (no permitido en metodologia)

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
     - Genera FR siguiendo TPL
     - Escritura en funcionales/
   * - Revisor
     - Valida FR contra UC origen
     - Lectura de UC y FR

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] PROC_Revision_UC_Previo_Derivacion ejecutado
- [ ] PROC_Revision_TPL_Previo_Generacion ejecutado (TPL_FR)
- [ ] PROC_Crear_Estructura_Directorios_Tmp ejecutado
- [ ] UC origen existe y esta aprobado
- [ ] Lista de FR a generar disponible (de seccion Trazabilidad del UC)

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_FR_Requisitos_Funcionales_1_0_0.rst
     - Template de FR
     - Si
   * - UC_[NNN]_[Nombre].rst
     - Caso de Uso origen
     - Si
   * - BR_[NNN].rst
     - Reglas de negocio aplicables
     - Si
   * - CNST_[NNN].rst
     - Restricciones aplicables
     - No

----

6. Procedimiento
----------------

6.1 Diagrama de Flujo
^^^^^^^^^^^^^^^^^^^^^

.. uml::
   :caption: Flujo de Generacion de FR
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

   :Abrir UC origen;
   :Localizar FR en seccion Trazabilidad;

   repeat
       :Seleccionar FR a generar;
       :Copiar plantilla TPL_FR;
       :Completar Identificacion;
       :Completar Especificacion;
       :Redactar Criterio de Aceptacion;
       note right: Formato DADO/CUANDO/ENTONCES
       :Agregar BR y CNST aplicables;
       :Completar Trazabilidad;
       :Guardar en /tmp;
       :Validar sintaxis RST;
   repeat while (Mas FR del UC?) is (si)

   :Crear/actualizar index.rst del modulo;
   :Ejecutar PROC_Copiar_Tmp_Outputs;

   stop
   @enduml

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Preparar Informacion del UC**

- **Responsable**: Analista
- **Accion**: Del UC origen, extraer:

  - ID del UC (ej: UC_001)
  - Nombre del UC
  - Modulo (ej: MOD_Auth)
  - Paso del flujo normal que origina el FR
  - BR aplicables
  - FR listados en seccion Trazabilidad

- **Resultado**: Informacion de contexto disponible
- **Verificacion**: Datos completos para el FR

**Paso 2: Determinar Nomenclatura del FR**

- **Responsable**: Analista
- **Accion**: Aplicar nomenclatura segun TPL_FR:

  .. code-block:: text

     Formato ID: FR_UC[MOD]_[NN]_[NN]
     
     Donde:
     - FR: Prefijo fijo
     - UC[MOD]: Codigo UC padre (ej: UC001)
     - [NN]: Numero secuencial del FR dentro del UC
     
     Ejemplos:
     - FR_UC001_01 (primer FR de UC_001)
     - FR_UC001_05 (quinto FR de UC_001)
     
     Formato alternativo (usado en UC existentes):
     - FR-001.01, FR-001.02, etc.

- **Resultado**: ID del FR definido
- **Verificacion**: ID unico, sigue nomenclatura

**Paso 3: Copiar y Completar Plantilla**

- **Responsable**: Analista
- **Accion**: Desde TPL_FR, copiar seccion Plantilla y completar:

  **3.1 Seccion Identificacion:**

  .. code-block:: rst

     * - **ID**
       - FR_UC001_01
     * - **Nombre**
       - [Nombre descriptivo del FR]
     * - **UC Padre**
       - UC_001: Iniciar Sesion
     * - **Modulo**
       - MOD_Auth
     * - **Tipo**
       - [Validacion|Proceso|Interfaz|Datos|Auditoria|Seguridad]
     * - **Prioridad**
       - [Critica|Alta|Media|Baja]

  **3.2 Seccion Especificacion:**

  .. code-block:: rst

     **Descripcion:**
     
     El sistema DEBE [accion] CUANDO [condicion] PARA [proposito].

  **3.3 Seccion Criterio de Aceptacion (OBLIGATORIO):**

  .. code-block:: rst

     ::
     
        DADO [contexto inicial]
        CUANDO [accion del usuario o sistema]
        ENTONCES [resultado esperado]

- **Resultado**: FR con contenido completo
- **Verificacion**: Todas las secciones completadas

**Paso 4: Agregar BR y CNST**

- **Responsable**: Analista
- **Accion**: En seccion "Reglas y Restricciones":

  .. code-block:: rst

     **BR Aplicables:**
     
     - BR_005: Sesion Unica por Usuario
     - BR_008: Auditoria de Accesos
     
     **CNST Aplicables:**
     
     - CNST_002: Gestion de Sesiones en BD
     - CNST_005: Seguridad DRF Checklist

- **Resultado**: Trazabilidad a BR y CNST
- **Verificacion**: BR y CNST existen en catalogo

**Paso 5: Completar Trazabilidad**

- **Responsable**: Analista
- **Accion**: Completar seccion Trazabilidad:

  .. code-block:: rst

     * - **UC Origen**
       - UC_001: Iniciar Sesion
     * - **BReq Origen**
       - BReq_AUTH
     * - **BR Aplicables**
       - BR_005, BR_008
     * - **CNST Aplicables**
       - CNST_002, CNST_005
     * - **TST Relacionados**
       - TST_FR_UC001_01 (pendiente)

- **Resultado**: Trazabilidad completa
- **Verificacion**: Enlaces bidireccionales verificables

**Paso 6: Guardar Archivo**

- **Responsable**: Analista
- **Accion**: Guardar en estructura /tmp:

  .. code-block:: bash

     # Ruta: /tmp/funcionales/[modulo]/UC_[NNN]_[Nombre]/
     /tmp/funcionales/auth/UC_001_Iniciar_Sesion/FR_UC001_01_Validar_formato_username.rst

- **Resultado**: Archivo FR creado
- **Verificacion**: Archivo existe en ruta correcta

**Paso 7: Validar Sintaxis RST**

- **Responsable**: Analista
- **Accion**: Verificar sintaxis:

  .. code-block:: bash

     # Validar archivo individual
     rst2html.py FR_UC001_01.rst /dev/null
     
     # O validar con Sphinx
     sphinx-build -b html -W /tmp/funcionales/ /tmp/build/

- **Resultado**: Sin errores de sintaxis
- **Verificacion**: Comando no reporta warnings

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
     - Requisito Funcional generado
     - /tmp/funcionales/[mod]/UC_[NNN]/
   * - index.rst (actualizado)
     - Indice del modulo con nuevo FR
     - /tmp/funcionales/[mod]/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] FR creado con todas las secciones obligatorias
- [ ] Nomenclatura correcta aplicada
- [ ] Criterio de Aceptacion en formato DADO/CUANDO/ENTONCES
- [ ] Trazabilidad a UC, BR, CNST completada
- [ ] Sintaxis RST validada
- [ ] index.rst actualizado

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] ID sigue nomenclatura FR_UC[NNN]_[NN]
- [ ] Tiene las 6 secciones obligatorias
- [ ] Criterio de Aceptacion usa DADO/CUANDO/ENTONCES
- [ ] BR aplicables referenciadas
- [ ] UC padre identificado
- [ ] Tipo de FR especificado

9.2 Checklist de Seciones
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 5 45 50
   :header-rows: 1

   * - #
     - Seccion
     - Verificar
   * - 1
     - Identificacion
     - ID, nombre, UC padre, modulo, tipo, prioridad
   * - 2
     - Especificacion
     - Descripcion clara, justificacion
   * - 3
     - Criterio de Aceptacion
     - Formato DADO/CUANDO/ENTONCES
   * - 4
     - Reglas y Restricciones
     - BR y CNST listadas
   * - 5
     - Trazabilidad
     - UC, BReq, BR, CNST, RBAC
   * - 6
     - Historial
     - Version, fecha, autor

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - UC sin FR en Trazabilidad
     - Derivar FR desde pasos "Sistema..." del flujo normal
   * - BR referenciada no existe
     - Crear BR primero o documentar gap
   * - Criterio de Aceptacion ambiguo
     - Consultar con stakeholder, refinar

----

11. Referencias
---------------

- TPL_FR_Requisitos_Funcionales_1_0_0.rst
- PROC_Revision_UC_Previo_Derivacion
- PROC_Derivacion_UC_FR
- FND_01: Concepto de Requisito

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
