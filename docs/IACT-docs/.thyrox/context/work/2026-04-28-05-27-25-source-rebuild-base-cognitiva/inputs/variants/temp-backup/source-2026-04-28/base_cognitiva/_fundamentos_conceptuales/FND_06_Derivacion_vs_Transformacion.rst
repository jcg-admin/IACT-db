.. meta::
   :artefacto: FND_06
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2025-12-19
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-06:

====================================
FND_06: Derivacion vs Transformacion
====================================


Proposito
---------

Este documento aclara la diferencia conceptual entre **derivacion** y
**transformacion** en el contexto de requisitos, explicando por que el
termino correcto es "derivar" y como esto preserva el principio de
responsabilidad unica.

----

1. El Problema de la Ambiguedad
-------------------------------

1.1 La Pregunta Central
^^^^^^^^^^^^^^^^^^^^^^^

Frecuentemente surge la siguiente pregunta:

.. code-block:: text

   PREGUNTA:
   "Un flujo del sistema, que define los pasos que realizara el caso
   de uso, se puede TRANSFORMAR a requerimientos funcionales?"

   OBSERVACION CRITICA:
   "Suenan parecidos pero no son lo mismo. Si los mezclas se rompe
   el principio de responsabilidad unica."

   BUSQUEDA:
   "Cual seria la estrategia apropiada?"

Esta pregunta contiene una **ambiguedad fundamental** en el uso de la
palabra "transformar".

1.2 El Error Conceptual
^^^^^^^^^^^^^^^^^^^^^^^

El problema es que "transformar" sugiere convertir algo en otra cosa
de naturaleza diferente:

.. code-block:: text

   TRANSFORMACION EN OTROS CONTEXTOS:

   - Senal tiempo -> senal frecuencia (Fourier)
   - Codigo fuente -> codigo maquina (compilacion)
   - Documento Word -> PDF (conversion formato)

   CARACTERISTICA COMUN:
   Algo se convierte en OTRA COSA diferente.

Aplicar este concepto a requisitos es **conceptualmente incorrecto**.

----

2. Derivacion: El Termino Correcto
----------------------------------

2.1 Definicion de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Derivar** significa hacer explicito lo que ya esta implicito. Los
Requisitos Funcionales (FR) no son "otra cosa" diferente al Caso de Uso;
son la **explicitacion** de capacidades que el UC ya contiene implicitamente.

.. code-block:: text

   DERIVAR (termino correcto):

   - Hacer explicito lo implicito
   - Descomponer en partes atomicas
   - Descubrir, no inventar
   - Mantener la esencia, cambiar el nivel de detalle

   RELACION:
   Los FR ya estan DENTRO del UC, solo no estan suficientemente
   detallados. Derivar es extraerlos y documentarlos atomicamente.

2.2 Ilustracion del Proceso
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CASO DE USO DICE:
   "Sistema valida disponibilidad del producto"

   ANALISIS: Que capacidades implica este paso?

   CAPACIDADES IMPLICITAS IDENTIFICADAS:
   1. Capacidad de consultar inventario actual
   2. Capacidad de comparar cantidades
   3. Capacidad de generar mensajes apropiados
   4. Capacidad de actualizar interfaz con resultado

   DERIVACION:
   Hacer explicitas estas capacidades implicitas como
   Requerimientos Funcionales individuales:

   FR-40.3: "Sistema DEBE consultar stock actual del producto"
   FR-40.4: "Sistema DEBE comparar cantidad solicitada vs disponible"
   FR-40.5: "Sistema DEBE mostrar mensaje si stock insuficiente"
   FR-40.6: "Sistema DEBE actualizar UI con resultado de validacion"

   OBSERVACION CLAVE:
   NO estamos INVENTANDO nuevos requerimientos.
   ESTAMOS DESCUBRIENDO requerimientos que ya estaban
   presentes pero no suficientemente detallados en el UC.

2.3 Comparacion: Derivacion vs Transformacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Transformacion (INCORRECTO)
     - Derivacion (CORRECTO)
   * - Concepto
     - Convertir en algo diferente
     - Explicitar lo implicito
   * - Relacion
     - A se convierte en B
     - B ya estaba en A
   * - Proceso
     - Conversion
     - Descubrimiento
   * - Resultado
     - Cosa nueva
     - Detalle de lo existente
   * - Ejemplo
     - Word -> PDF
     - UC paso -> FR atomicos

----

3. Principio de Responsabilidad Unica
-------------------------------------

3.1 Definicion
^^^^^^^^^^^^^^

El **Principio de Responsabilidad Unica** (Single Responsibility Principle)
aplicado a artefactos de requisitos establece que cada nivel de abstraccion
debe tener una responsabilidad clara y unica.

.. code-block:: text

   RESPONSABILIDAD POR NIVEL:

   NIVEL 0 - BR:   Declarar politicas del dominio
   NIVEL 1 - BReq: Justificar el proyecto
   NIVEL 2 - UC:   Describir interacciones usuario-sistema
   NIVEL 3 - FR:   Especificar capacidades atomicas del sistema

   SI SE MEZCLAN NIVELES:
   - Se pierde claridad
   - Se dificulta trazabilidad
   - Se complica mantenimiento
   - Se rompe el principio

3.2 Violacion del Principio
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cuando se "transforma" en lugar de "derivar", se tiende a mezclar niveles:

.. code-block:: text

   DOCUMENTACION PROBLEMATICA (mezcla de niveles):

   "Flujo para solicitar producto quimico:
   1. POST a /api/solicitudes con JSON {producto_id, cantidad}
   2. Validar JWT token del usuario
   3. Consultar SELECT stock FROM inventario WHERE producto_id = ?
   4. Ejecutar procedimiento sp_registrar_solicitud
   5. Si clase_peligrosidad >= 5, enviar email
   6. Registrar en audit_log
   7. Retornar 201 Created con Location header"

   PROBLEMA IDENTIFICADO:
   Este "flujo" mezcla multiples niveles de abstraccion:

   - Detalles tecnicos: endpoints REST, JWT, SQL (Nivel 4: Diseno)
   - Logica de negocio: validacion de peligrosidad (Nivel 3: FR)
   - Comportamiento observable: registro de solicitud (Nivel 2: UC)

   ESTO ROMPE EL PRINCIPIO DE RESPONSABILIDAD UNICA

3.3 Preservacion del Principio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La derivacion correcta preserva la responsabilidad unica:

.. code-block:: text

   NIVEL 2 - CASO DE USO (comportamiento observable):

   UC-04: Solicitar Producto
     1. Usuario selecciona producto del catalogo
     2. Sistema muestra informacion del producto
     3. Usuario especifica cantidad deseada
     4. Sistema valida disponibilidad
     5. Sistema verifica autorizacion del usuario
     6. Sistema registra la solicitud
     7. Sistema confirma al usuario

   --------------------------------------------------

   NIVEL 3 - FUNCTIONAL REQUIREMENTS (capacidades atomicas):

   Derivados del Paso 4 "Sistema valida disponibilidad":

   FR-04.10: Sistema DEBE consultar stock actual
   FR-04.11: Sistema DEBE comparar cantidad vs stock
   FR-04.12: Sistema DEBE mostrar error si insuficiente

   Derivados del Paso 5 "Sistema verifica autorizacion":

   FR-04.13: Sistema DEBE consultar clase de peligrosidad
   FR-04.14: Sistema DEBE verificar nivel de autorizacion
   FR-04.15: Sistema DEBE asignar aprobador si clase >= 5

   --------------------------------------------------

   NIVEL 4 - DISENO TECNICO (implementacion):

   FD-04: Flujo de Datos Tecnico
     POST /api/solicitudes
     SELECT stock FROM inventario...
     IF clase_peligrosidad >= 5 THEN...

   CADA NIVEL TIENE SU RESPONSABILIDAD UNICA

----

4. Direccion de Derivacion
--------------------------

4.1 Proyectos Greenfield
^^^^^^^^^^^^^^^^^^^^^^^^

En proyectos que comienzan desde cero, la direccion de derivacion es
**de abstracto a concreto**:

.. code-block:: text

   SECUENCIA CORRECTA EN GREENFIELD:

   Paso 1: Identificar Business Rules
           Politicas, regulaciones, restricciones del dominio
           |
           v
   Paso 2: Generar Cases de Uso
           Desde BR, desde CRUD, desde Eventos (Larman)
           Cada UC contiene flujo de pasos
           |
           v
   Paso 3: Derivar Functional Requirements
           Desde flujo del UC
           Analisis de cada paso donde sistema actua
           |
           v
   Paso 4: Disenar Arquitectura
           Desde FR
           Crear flujos de datos tecnicos (FD)
           |
           v
   Paso 5: Implementar Codigo
           Desde diseno arquitectonico
           Siguiendo FD tecnicos

   DIRECCION: De abstracto a concreto
   NUNCA AL REVES en proyecto greenfield

4.2 Proyectos Brownfield (Legacy)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En proyectos con codigo existente, la direccion puede ser inversa
(reverse engineering):

.. code-block:: text

   SECUENCIA EN BROWNFIELD:

   Paso 1: Codigo existente
           Analizar implementacion actual
           |
           v
   Paso 2: Extraer Flujo de Datos Tecnico
           Reverse engineering del codigo
           |
           v
   Paso 3: Identificar Functional Requirements
           Que capacidades tiene el sistema?
           |
           v
   Paso 4: Reconstruir Cases de Uso
           Que comportamiento observable provee?
           |
           v
   Paso 5: Descubrir Business Rules
           Que politicas implementa?

   DIRECCION: De concreto a abstracto
   VALIDO SOLO para sistemas legacy

4.3 Comparacion de Contextos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Aspecto
     - Greenfield
     - Brownfield
   * - Direccion
     - Abstracto -> Concreto
     - Concreto -> Abstracto
   * - Secuencia
     - BR -> UC -> FR -> Codigo
     - Codigo -> FR -> UC -> BR
   * - Proceso
     - Disenar antes de implementar
     - Documentar lo que ya existe
   * - Razon
     - No hay codigo previo
     - Sistema ya funciona

.. important::

   **IACT es un proyecto Greenfield.**

   Por tanto, la direccion correcta es:
   BR -> UC -> FR -> Diseno -> Codigo

----

5. Implicaciones Practicas
--------------------------

5.1 Proceso de Derivacion Correcto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PARA CADA PASO DEL CASO DE USO:

   1. Leer el paso del UC
      "Sistema valida disponibilidad del producto"

   2. Preguntar: Que capacidades atomicas implica?
      - Consultar stock
      - Comparar cantidades
      - Generar mensaje resultado

   3. Documentar cada capacidad como FR individual
      FR-xx.1: Sistema DEBE consultar stock actual
      FR-xx.2: Sistema DEBE comparar cantidad vs disponible
      FR-xx.3: Sistema DEBE mostrar mensaje de resultado

   4. Verificar trazabilidad
      Cada FR debe apuntar al paso UC del que deriva

   5. Verificar atomicidad
      Cada FR debe ser verificable independientemente

5.2 Errores a Evitar
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ERROR 1: Mezclar niveles en un solo documento

   INCORRECTO:
   "FR-40: El sistema debe validar el producto consultando
    SELECT * FROM inventario usando JWT token y retornando
    201 Created"

   CORRECTO:
   FR-40.1: Sistema DEBE validar disponibilidad del producto
   (El SQL y JWT son detalles de diseno, no FR)

   ---------------------------------------------------------

   ERROR 2: Inventar FR sin origen en UC

   INCORRECTO:
   FR-99: Sistema DEBE integrarse con TikTok
   (No hay UC que requiera esto)

   CORRECTO:
   Cada FR debe derivar de un paso especifico de un UC

   ---------------------------------------------------------

   ERROR 3: FR demasiado grandes (no atomicos)

   INCORRECTO:
   FR-40: Sistema DEBE validar, registrar y notificar solicitud

   CORRECTO:
   FR-40.1: Sistema DEBE validar datos de solicitud
   FR-40.2: Sistema DEBE registrar solicitud en BD
   FR-40.3: Sistema DEBE notificar via buzon interno

----

6. Aplicacion en IACT
---------------------

6.1 Ejemplo de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_015: Separacion de Funciones (SoD)
   "Roles R016 y R017 son mutuamente excluyentes"
       |
       | genera
       v
   UC_010: Asignar Rol a Usuario
   Paso 6: "Sistema valida compatibilidad SoD"
       |
       | deriva
       v
   FR-10.6: Sistema DEBE consultar roles actuales del usuario
   FR-10.7: Sistema DEBE verificar tabla de incompatibilidades
   FR-10.8: Sistema DEBE bloquear asignacion si hay conflicto
   FR-10.9: Sistema DEBE mostrar mensaje con roles en conflicto

6.2 Verificacion de Trazabilidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CADENA COMPLETA DE DERIVACION:

   BR_015 (SoD)
       |
       +---> UC_010 (Asignar Rol)
                |
                +---> FR-10.6, FR-10.7, FR-10.8, FR-10.9
                          |
                          +---> Tests: T-10.6, T-10.7...
                                    |
                                    +---> Codigo: RBACService.py

   CADA NIVEL DERIVA DEL ANTERIOR
   NO HAY "TRANSFORMACION", HAY "EXPLICITACION"

----

7. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-02` - Reglas de Negocio
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-04` - Trazabilidad
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-07` - Requerimientos Funcionales

Fuentes Externas
^^^^^^^^^^^^^^^^

- Robert C. Martin: "Clean Architecture" (Single Responsibility Principle)
- Karl Wiegers: "Software Requirements"
- ESTRATEGIA_DERIVACION_FR_PROYECTO_GREENFIELD.md (documento metodologico)

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2025-12-19
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:** Este artefacto clarifica el proceso correcto de derivacion
que conecta UC con FR. Es fundamental para entender por que la trazabilidad
(FND_04) funciona y como se preserva la responsabilidad unica por nivel.
