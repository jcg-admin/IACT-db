.. meta::
   :artefacto: PROC_Generacion_UC
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

.. _proc-generacion-uc:

==============================================
PROC_Generacion_UC: Generacion de Casos de Uso
==============================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - PROC_Generacion_UC
   * - **Nombre**
     - Generacion de Casos de Uso
   * - **Categoria**
     - Generacion de Artefactos
   * - **Frecuencia**
     - Por cada UC a documentar
   * - **Duracion Estimada**
     - 30-60 minutos por UC
   * - **Estado**
     - Vigente

----

1. Proposito
------------

Este procedimiento establece los pasos para generar Casos de Uso (UC)
siguiendo el template TPL_UC v2.0.0.

**Objetivo:** Crear UC completos con flujos, actores, precondiciones
y FR derivados identificados.

----

2. Alcance
----------

2.1 Aplica A
^^^^^^^^^^^^

- Creacion de nuevos UC derivados de BR
- UC de todos los modulos IACT
- UC de cualquier complejidad

2.2 No Aplica A
^^^^^^^^^^^^^^^

- Modificacion de UC existentes
- Documentacion de requisitos no funcionales

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
     - Genera UC siguiendo TPL
     - Escritura en casos_uso/
   * - Usuario Final
     - Valida flujos de interaccion
     - Lectura

----

4. Precondiciones
-----------------

Antes de iniciar este procedimiento, verificar:

- [ ] BR relacionadas identificadas
- [ ] TPL_UC revisado (PROC_Revision_TPL_Previo_Generacion)
- [ ] Modulo destino identificado
- [ ] Estructura /tmp/casos_uso/[modulo]/ creada

----

5. Artefactos de Entrada
------------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Obligatorio
   * - TPL_UC_Casos_de_Uso_2_0_0.rst
     - Template de UC
     - Si
   * - BR_[NNN].rst
     - Reglas de negocio relacionadas
     - Si
   * - MOD_[Nombre].rst
     - Especificacion del modulo
     - No

----

6. Procedimiento
----------------

6.1 Estructura de UC
^^^^^^^^^^^^^^^^^^^^

Segun TPL_UC v2.0.0, un UC tiene:

1. Resumen (ID, nombre, actor, modulo, complejidad, prioridad)
2. Descripcion
3. Contexto (precondiciones, trigger, postcondiciones, garantias)
4. Flujo Normal
5. Flujos Alternos
6. Excepciones
7. Reglas de Negocio
8. Trazabilidad (BReq origen, FR derivados)
9. Historial

6.2 Pasos Detallados
^^^^^^^^^^^^^^^^^^^^

**Paso 1: Determinar Nomenclatura**

- **Responsable**: Analista
- **Accion**: Asignar ID segun modulo:

  .. code-block:: text

     Formato: UC_[NNN]
     
     Rangos por modulo:
     - MOD_Auth: UC_001 - UC_005
     - MOD_Users: UC_006 - UC_009
     - MOD_Access: UC_010 - UC_011, UC_041 - UC_047
     - MOD_Reports: UC_017 - UC_030
     - MOD_Alerts: UC_036 - UC_040
     - MOD_Pipeline: UC_050 - UC_053
     - MOD_Audit: UC_060 - UC_063
     - MOD_Logs: UC_070 - UC_073
     
     Archivo: UC_[NNN]_[Nombre_Accion].rst

- **Resultado**: ID asignado
- **Verificacion**: ID dentro del rango del modulo

**Paso 2: Identificar Actor Primario**

- **Responsable**: Analista
- **Accion**: Determinar quien inicia el UC:

  .. code-block:: text

     Actores IACT:
     - Usuario no autenticado
     - Usuario autenticado
     - Administrador
     - Supervisor
     - Sistema (para UC automaticos)
     - API Externa

- **Resultado**: Actor identificado
- **Verificacion**: Actor valido del sistema

**Paso 3: Redactar Descripcion**

- **Responsable**: Analista
- **Accion**: Escribir descripcion en 2-3 oraciones:

  .. code-block:: text

     Formato:
     "Permite a [actor] [accion principal] para [objetivo/beneficio]."
     
     Ejemplo UC_001:
     "Permite a un usuario autenticarse en el sistema IACT
     proporcionando sus credenciales (username y password) para
     obtener acceso a las funcionalidades segun sus permisos."

- **Resultado**: Descripcion clara
- **Verificacion**: Indica actor, accion, objetivo

**Paso 4: Definir Contexto**

- **Responsable**: Analista
- **Accion**: Especificar:

  .. code-block:: rst

     **Precondiciones:**
     
     1. [Condicion que debe cumplirse antes]
     2. [Otra condicion]
     
     **Trigger:**
     
     [Evento que inicia el UC]
     
     **Postcondiciones de Exito:**
     
     1. [Estado despues de exito]
     
     **Garantias Minimas:**
     
     1. [Lo que siempre se cumple, exito o fallo]

- **Resultado**: Contexto completo
- **Verificacion**: 4 elementos definidos

**Paso 5: Escribir Flujo Normal**

- **Responsable**: Analista
- **Accion**: Documentar pasos numerados:

  .. code-block:: rst

     ::
     
        1. Actor [accion]
        2. Sistema [respuesta]
        3. Actor [accion]
        4. Sistema [respuesta]
        ...

  **Reglas:**
  
  - Alternar actor/sistema cuando aplique
  - Pasos del sistema inician con "Sistema"
  - Ser especifico, no ambiguo
  - 5-15 pasos tipicamente

- **Resultado**: Flujo normal completo
- **Verificacion**: Pasos claros y secuenciales

**Paso 6: Documentar Flujos Alternos**

- **Responsable**: Analista
- **Accion**: Identificar variaciones validas:

  .. code-block:: rst

     **FA-1: [Nombre del flujo alterno]**
     
     ::
     
        Na. [Condicion alternativa]
        Nb. Sistema [accion]
        Nc. [Continua o termina]

- **Resultado**: Flujos alternos documentados
- **Verificacion**: Cada FA tiene condicion clara

**Paso 7: Documentar Excepciones**

- **Responsable**: Analista
- **Accion**: Identificar condiciones de error:

  .. code-block:: rst

     **EX-1: [Nombre de la excepcion]**
     
     ::
     
        *a. [Condicion de error]
        *b. Sistema [manejo del error]
        *c. UC termina

- **Resultado**: Excepciones documentadas
- **Verificacion**: Manejo de errores claro

**Paso 8: Vincular BR**

- **Responsable**: Analista
- **Accion**: Listar BR aplicables:

  .. code-block:: rst

     .. list-table::
        :header-rows: 1
     
        * - BR
          - Nombre
          - Aplicacion
        * - BR_005
          - Sesion Unica
          - Paso 7: Invalida sesiones

- **Resultado**: BR vinculadas
- **Verificacion**: BR existen en catalogo

**Paso 9: Identificar FR Derivados**

- **Responsable**: Analista
- **Accion**: Listar FR que implementan el UC:

  .. code-block:: rst

     **FR Derivados:**
     
     - FR-001.01: Validar formato username
     - FR-001.02: Validar credenciales
     - FR-001.03: Generar token JWT

- **Resultado**: FR identificados
- **Verificacion**: Nomenclatura FR correcta

**Paso 10: Guardar y Validar**

- **Responsable**: Analista
- **Accion**: Guardar y validar:

  .. code-block:: bash

     # Guardar
     /tmp/casos_uso/auth/UC_001_Iniciar_Sesion.rst
     
     # Validar
     sphinx-build -b html -W /tmp/casos_uso/ /tmp/build/

- **Resultado**: UC guardado y validado
- **Verificacion**: Sin errores Sphinx

----

7. Artefactos de Salida
-----------------------

.. list-table::
   :widths: 30 50 20
   :header-rows: 1

   * - Artefacto
     - Descripcion
     - Ubicacion
   * - UC_[NNN]_[Nombre].rst
     - Caso de Uso generado
     - /tmp/casos_uso/[modulo]/

----

8. Postcondiciones
------------------

Al finalizar este procedimiento:

- [ ] UC creado con 9 secciones
- [ ] Flujo normal con pasos numerados
- [ ] Flujos alternos y excepciones documentados
- [ ] BR vinculadas
- [ ] FR derivados identificados

----

9. Verificacion y Validacion
----------------------------

9.1 Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^

- [ ] ID sigue formato UC_[NNN]
- [ ] Actor primario identificado
- [ ] Flujo normal tiene pasos "Sistema"
- [ ] Al menos 1 FA o EX documentado
- [ ] FR derivados listados

----

10. Manejo de Excepciones
-------------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Excepcion
     - Accion
   * - UC muy complejo
     - Dividir en UC mas pequeños
   * - Sin BR relacionadas
     - Documentar como UC independiente
   * - Flujo no claro
     - Consultar con usuario final

----

11. Referencias
---------------

- TPL_UC_Casos_de_Uso_2_0_0.rst
- PROC_Derivacion_BR_UC
- PROC_Derivacion_UC_FR

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
