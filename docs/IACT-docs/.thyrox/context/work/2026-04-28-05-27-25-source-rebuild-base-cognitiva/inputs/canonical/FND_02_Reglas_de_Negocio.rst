.. meta::
   :artefacto: FND_02
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.1.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2025-12-21
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-02:

=========================
FND_02: Reglas de Negocio
=========================


Proposito
---------

Este documento define QUE ES una Regla de Negocio (Business Rule) en el
contexto del proyecto IACT, su relacion con el estandar SBVR, y como
se clasifican segun sus tipos y modalidades.

----

1. Definicion Formal
--------------------

1.1 Que es una Regla de Negocio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una **Regla de Negocio (Business Rule - BR)** es una declaracion sobre
como opera la organizacion. Las reglas de negocio NO son creadas por el
proyecto de software; existen independientemente y el software debe
conformarse a ellas.

.. note::

   **Definicion operativa para IACT:**

   Una BR es una politica, restriccion o hecho del dominio que existe
   independientemente del sistema y que el sistema DEBE cumplir.

1.2 Caracteristicas Distintivas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las Business Rules tienen cuatro caracteristicas fundamentales:

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Externa**
     - Proviene de fuera del sistema (politicas, regulaciones, estandares)
   * - **Obligatoria**
     - No es opcional ni negociable para el sistema
   * - **Estable**
     - Cambia menos frecuentemente que los requerimientos funcionales
   * - **Influyente**
     - Afecta multiples partes del sistema

1.3 Diferencia BR vs Requisito Funcional
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Business Rule (BR)
     - Requisito Funcional (FR)
   * - Origen
     - Externo al proyecto
     - Derivado del proyecto
   * - Existencia
     - Independiente del sistema
     - Especifico del sistema
   * - Pregunta
     - Por que esta restriccion?
     - Como lo hace el sistema?
   * - Ejemplo BR
     - "Compras >$500 requieren aprobacion"
     - (no aplica)
   * - Ejemplo FR
     - (no aplica)
     - "Sistema DEBE validar monto contra umbral $500"

----

2. Fuentes de Business Rules
----------------------------

2.1 Fuentes Externas (Obligatorias)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FUENTES EXTERNAS:

   +------------------+----------------------------------------+
   | Leyes            | Regulaciones federales, estatales      |
   +------------------+----------------------------------------+
   | Regulaciones     | Normas de industria, compliance        |
   +------------------+----------------------------------------+
   | Estandares       | ISO, IEEE, normas internacionales      |
   +------------------+----------------------------------------+
   | Contratos        | Acuerdos con clientes, proveedores     |
   +------------------+----------------------------------------+

2.2 Fuentes Internas (Organizacionales)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FUENTES INTERNAS:

   +------------------+----------------------------------------+
   | Politicas        | Politicas corporativas vigentes        |
   +------------------+----------------------------------------+
   | Procedimientos   | Procedimientos operativos estandar     |
   +------------------+----------------------------------------+
   | Mejores Practicas| Practicas establecidas en la org       |
   +------------------+----------------------------------------+

2.3 Relacion con el Sistema
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FUENTES EXTERNAS              FUENTES INTERNAS
        |                              |
        v                              v
   +--------------------------------------------------+
   |                                                  |
   |              SISTEMA DE SOFTWARE                 |
   |                                                  |
   |   El sistema NO crea las reglas                  |
   |   El sistema CUMPLE las reglas                   |
   |                                                  |
   +--------------------------------------------------+

----

3. Taxonomia de Business Rules
------------------------------

Las Business Rules se clasifican en **5 tipos** segun su naturaleza:

3.1 Tipo 1: Hechos (Facts)
^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Verdades sobre el dominio que estructuran el modelo de datos.

**Caracteristicas:**

- Definen entidades y sus relaciones
- Estructuran el modelo de datos
- Son declaraciones de existencia

**Ejemplo:**

.. code-block:: text

   BR-FACT-001: "Cada contenedor tiene un codigo unico"

   Impacto en sistema:
   - Entidad: Contenedor
   - Atributo: codigo (UNIQUE, NOT NULL)
   - Validacion: Unicidad en BD

**Transformacion:**

.. code-block:: text

   Hecho --> Define estructura de entidades
         --> Genera validaciones de integridad de datos

3.2 Tipo 2: Restricciones (Constraints)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Limitaciones obligatorias sobre lo que DEBE o NO DEBE ocurrir.

**Caracteristicas:**

- Establecen limites y condiciones
- Son obligatorias (no opcionales)
- Generan validaciones y controles

**Ejemplo:**

.. code-block:: text

   BR-CONST-001: "Solo gerentes pueden aprobar compras mayores a $500"

   Impacto en sistema:
   - Precondicion en UC de aprobacion
   - Validacion de rol de usuario
   - Control de acceso en API

**Transformacion:**

.. code-block:: text

   Restriccion --> Precondicion/Postcondicion en Caso de Uso
              --> Genera validaciones y controles de acceso

3.3 Tipo 3: Desencadenadores (Triggers)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Reglas que cuando se cumple una condicion, generan un
comportamiento OBSERVABLE.

**Caracteristicas:**

- Formato: SI [condicion] ENTONCES [accion observable]
- El resultado es VISIBLE para el usuario o sistema externo
- Generan Casos de Uso completos

**Ejemplo:**

.. code-block:: text

   BR-TRIG-001: "SI un quimico vence en 30 dias,
                 ENTONCES notificar al responsable de laboratorio"

   Impacto en sistema:
   - Genera UC: "Notificar Vencimiento Proximo"
   - Proceso batch diario de verificacion
   - Notificacion via buzon interno

**Transformacion:**

.. code-block:: text

   Desencadenador --> Genera Caso de Uso completo
                  --> Multiples FR para cada accion observable

.. important::

   **Desencadenador vs Inferencia:**

   La diferencia clave es la OBSERVABILIDAD del resultado.

   - Desencadenador: El sistema HACE algo visible
   - Inferencia: El sistema SABE algo nuevo (interno)

3.4 Tipo 4: Inferencias (Inferences)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Reglas que cuando se cumple una condicion, establecen un
nuevo hecho INTERNO (no observable externamente).

**Caracteristicas:**

- Formato: SI [condicion] ENTONCES [nuevo hecho interno]
- El resultado es SOLO conocido por el sistema
- NO generan Casos de Uso

**Ejemplo:**

.. code-block:: text

   BR-INF-001: "SI una cuenta tiene mas de 30 dias de impago,
               ENTONCES la cuenta se considera 'Deudora'"

   Impacto en sistema:
   - Cambio de estado interno (flag)
   - NO notifica, NO genera accion visible
   - Afecta logica posterior (ej: bloquear credito)

**Transformacion:**

.. code-block:: text

   Inferencia --> NO genera Caso de Uso
             --> Genera logica interna de negocio
             --> Cambio de estado o clasificacion

3.5 Tipo 5: Calculos (Calculations)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Formulas y algoritmos que transforman datos.

**Caracteristicas:**

- Definen como se calculan valores
- Pueden ser formulas matematicas o algoritmos
- Generan FR especificos de calculo

**Ejemplo:**

.. code-block:: text

   BR-CALC-001: "Precio Total = (Suma Items) - Descuento + IVA + Envio"

   Impacto en sistema:
   - Algoritmo especifico de calculo
   - FR que implementa la formula
   - Validacion de componentes

**Transformacion:**

.. code-block:: text

   Calculo --> Paso en flujo de Caso de Uso
          --> FR con algoritmo especifico

3.6 Resumen de Tipos
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 15 25 30 30

   * - Tipo
     - Pregunta
     - Genera UC?
     - Transformacion
   * - Hecho
     - Que existe?
     - No
     - Estructura de datos
   * - Restriccion
     - Que limita?
     - No (condicion)
     - Validaciones
   * - Desencadenador
     - Que dispara accion?
     - SI
     - UC completo
   * - Inferencia
     - Que concluye?
     - No
     - Logica interna
   * - Calculo
     - Como se calcula?
     - No (paso)
     - Algoritmo

----

4. Modalidades SBVR
-------------------

El estandar SBVR (Semantics of Business Vocabulary and Rules) define
dos modalidades logicas para clasificar las reglas de negocio.

4.1 Que es SBVR
^^^^^^^^^^^^^^^

**SBVR** (Semantics of Business Vocabulary and Rules) es un estandar
del OMG que combina aspectos de ontologias y sistemas de reglas.

.. note::

   **Proposito de SBVR:**

   - Capturar el QUE de las reglas de negocio, no el COMO
   - MODELAR reglas de negocio, no ejecutarlas
   - Comunicacion clara entre negocio e IT

4.2 Modalidad Aletica (Estructural)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Describe lo que ES, verdades sobre la estructura del dominio.

**Caracteristicas:**

- Hechos y definiciones
- Restricciones estructurales
- No pueden ser violadas (son verdades)

**Palabras clave:**

.. code-block:: text

   - ES (is)
   - TIENE (has)
   - PERTENECE A (belongs to)
   - EXISTE (exists)

**Ejemplos:**

.. code-block:: text

   ALETICA (Estructural):

   "Un pedido TIENE un cliente"
   "Cada producto PERTENECE A una categoria"
   "Un usuario ES identificado por un email unico"

4.3 Modalidad Deontica (Comportamental)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:** Describe lo que DEBE SER, obligaciones y prohibiciones.

**Caracteristicas:**

- Obligaciones (must)
- Prohibiciones (must not)
- Permisos (may)
- Pueden ser violadas (generan errores/sanciones)

**Palabras clave:**

.. code-block:: text

   Obligacion:
   - DEBE (must)
   - ES REQUERIDO (is required to)
   - TIENE QUE (shall)

   Prohibicion:
   - NO DEBE (must not)
   - ESTA PROHIBIDO (is forbidden to)
   - NO PUEDE (cannot)

   Permiso:
   - PUEDE (may)
   - ESTA PERMITIDO (is permitted to)
   - TIENE PERMITIDO (is allowed to)

**Ejemplos:**

.. code-block:: text

   DEONTICA (Comportamental):

   Obligacion:
   "Un pedido DEBE ser aprobado antes de envio"
   "El usuario DEBE cambiar su password cada 90 dias"

   Prohibicion:
   "Un usuario NO DEBE acceder a datos de otro segmento"
   "El sistema NO DEBE enviar emails externos"

   Permiso:
   "Un gerente PUEDE aprobar compras hasta $5,000"
   "El analista PUEDE exportar reportes en CSV"

4.4 Comparacion de Modalidades
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Aletica
     - Deontica
   * - Describe
     - Lo que ES
     - Lo que DEBE SER
   * - Naturaleza
     - Verdades estructurales
     - Obligaciones/Prohibiciones
   * - Violacion
     - Imposible (es verdad)
     - Posible (genera error)
   * - Ejemplo
     - "Pedido TIENE cliente"
     - "Pedido DEBE ser aprobado"

----

5. Template de Business Rule
----------------------------

5.1 Formato Estandar IACT
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_NNN:
     Definicion:      [Texto de la regla en lenguaje de negocio]
     Tipo:            Fact | Constraint | Trigger | Inference | Calculation
     Modalidad:       Aletica | Deontica (Obligation | Prohibition | Permission)
     Fuente:          [Documento, regulacion, politica de origen]
     Justificacion:   [Por que existe esta regla]
     Fecha Vigencia:  YYYY-MM-DD [desde cuando aplica]
     Prioridad:       Alta | Media | Baja
     Estatica/Dinamica: Estatica | Dinamica
     Ejemplo:         [Aplicacion concreta en el dominio]

5.2 Descripcion de Campos
^^^^^^^^^^^^^^^^^^^^^^^^^

**Campos Obligatorios:**

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Campo
     - Descripcion
   * - **Definicion**
     - Texto completo de la regla en lenguaje natural, comprensible por stakeholders
   * - **Tipo**
     - Uno de los 5 tipos: Fact, Constraint, Trigger, Inference, Calculation
   * - **Modalidad**
     - Aletica (verdad estructural) o Deontica (obligacion/prohibicion/permiso)
   * - **Fuente**
     - Documento, version y seccion especifica de donde proviene la regla
   * - **Fecha Vigencia**
     - Fecha a partir de la cual aplica la regla (formato YYYY-MM-DD)

**Campos Adicionales:**

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Campo
     - Descripcion
   * - **Prioridad**
     - Alta (critica, debe implementarse primero), Media (importante), Baja (deseable)
   * - **Estatica/Dinamica**
     - Estatica: proviene de ley/regulacion, dificil de cambiar. Dinamica: politica organizacional, puede cambiar por decision interna
   * - **Justificacion**
     - Razon de negocio por la cual existe la regla
   * - **Ejemplo**
     - Caso concreto de aplicacion en el dominio del proyecto

5.3 Concepto: Estatica vs Dinamica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ESTATICA:
   - Proviene de ley o regulacion permanente
   - Muy dificil o imposible de cambiar
   - Cambio requiere proceso legislativo o regulatorio
   - Ejemplos: Leyes federales, estandares ISO, regulaciones OSHA

   DINAMICA:
   - Proviene de politica organizacional
   - Puede cambiar por decision interna
   - Cambio requiere aprobacion de ejecutivo o comite
   - Ejemplos: Politicas corporativas, procedimientos internos, SLAs

**Importancia de la clasificacion:**

- Reglas ESTATICAS: Sistema debe cumplirlas sin excepciones
- Reglas DINAMICAS: Considerar parametrizacion para facilitar cambios

5.4 Ejemplo Completo
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_028:
     Definicion:      "Solicitudes de compra que excedan $500 requieren
                       aprobacion del gerente de departamento"
     Tipo:            Constraint
     Modalidad:       Deontica (Obligation)
     Fuente:          Politica Financiera Corporativa v2.3, Seccion 4.2
     Justificacion:   Control de gastos y cumplimiento de auditoria interna
     Fecha Vigencia:  2023-01-01
     Prioridad:       Alta
     Estatica/Dinamica: Dinamica (puede cambiar por decision del CFO)
     Ejemplo:         Compra de reactivo por $750 requiere aprobacion
                      del gerente de laboratorio antes de procesarse.

----

6. Tecnicas de Elicitacion de BR
--------------------------------

6.1 Las 6 Preguntas Estrategicas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para descubrir Business Rules de manera sistematica, usar estas preguntas:

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Pregunta
     - Tipo de BR que Descubre
     - Ejemplo de Respuesta
   * - "Quien puede hacer que?"
     - Restriccion (acceso)
     - "Solo gerentes pueden aprobar >$500"
   * - "Que debe pasar cuando...?"
     - Desencadenador
     - "Cuando vence, notificar por email"
   * - "Como se calcula X?"
     - Calculo
     - "Precio = Base + IVA - Descuento"
   * - "Quien puede Y?"
     - Restriccion (permiso)
     - "Solo admin puede eliminar usuarios"
   * - "Que pasa cuando Z?"
     - Desencadenador o Inferencia
     - "Cuenta queda bloqueada" (ver 6.2)
   * - "En que casos se considera...?"
     - Inferencia
     - "Si >30 dias impago = Deudor"

6.2 Distinguir Desencadenador de Inferencia
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   PREGUNTA CLAVE:
   "Si esta regla se ejecuta, ¿el usuario puede OBSERVAR que algo ocurrio,
    sin consultar la base de datos interna?"

   - SI observa algo --> DESENCADENADOR (genera UC)
   - NO observa nada --> INFERENCIA (solo FR interno)

   EJEMPLO:

   Pregunta: "Que pasa cuando un producto vence?"

   Respuesta A: "Se envia email al responsable"
     --> DESENCADENADOR (el email es observable)
     --> Genera UC: "Notificar Vencimiento"

   Respuesta B: "Se marca como 'Caduco' en el sistema"
     --> INFERENCIA (solo cambia un flag interno)
     --> NO genera UC, solo FR de logica interna

----

7. Business Rules en el Contexto IACT
-------------------------------------

7.1 Nomenclatura
^^^^^^^^^^^^^^^^

Las Business Rules en IACT siguen la convencion:

.. code-block:: text

   FORMATO: BR_NNN_Nombre_Descriptivo.rst

   Donde:
   - BR: Prefijo fijo (Business Rule)
   - NNN: Numero secuencial de 3 digitos
   - Nombre_Descriptivo: Descripcion corta con guiones bajos

   Ejemplos:
   - BR_001_Fuente_Operacional_Inmutable.rst
   - BR_002_ETL_Nocturno_Unidireccional.rst
   - BR_003_RBAC_Flat_Sin_Herencia.rst

7.2 Ubicacion en el Modelo IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   requisitos/
       |
       +--- reglas_negocio/
                |
                +--- index.rst
                +--- BR_001_xxx.rst
                +--- BR_002_xxx.rst
                +--- ...

7.3 Relacion con Otros Artefactos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR (Regla de Negocio)
       |
       +---> UC (Caso de Uso)
       |         Desencadenadores generan UC completos
       |         Restricciones son precondiciones
       |
       +---> FR (Requisito Funcional)
       |         Cada tipo genera FR especificos
       |
       +---> CNST (Restriccion Tecnica)
                 Algunas BR se convierten en restricciones de sistema

----

8. Ejemplos en IACT
-------------------

8.1 BR de Tipo Restriccion
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_001: Fuente Operacional Inmutable

   Definicion:    "La base de datos MySQL operacional es de SOLO LECTURA
                   para el sistema IACT. No se permite ninguna operacion
                   de escritura (INSERT, UPDATE, DELETE)."
   Tipo:          Constraint
   Modalidad:     Deontica (Prohibition)
   Fuente:        Politica de TI - Separacion de Ambientes
   Justificacion: Proteger integridad de datos operacionales
   Estatica:      Si
   Fecha Efectiva: 2025-01-01

8.2 BR de Tipo Desencadenador
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_002: Sincronizacion ETL Nocturna

   Definicion:    "SI es medianoche (00:00 hora local),
                   ENTONCES ejecutar proceso ETL de sincronizacion
                   desde MySQL hacia PostgreSQL."
   Tipo:          Trigger
   Modalidad:     Deontica (Obligation)
   Fuente:        Arquitectura de Sistema - Decision ADR_002
   Justificacion: Mantener datos analytics actualizados sin impactar operacion
   Estatica:      No (horario puede ajustarse)
   Fecha Efectiva: 2025-01-15

8.3 BR de Tipo Inferencia
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BR_003: Clasificacion de Usuario Inactivo

   Definicion:    "SI un usuario no ha iniciado sesion en 90 dias,
                   ENTONCES el usuario se considera 'Inactivo'."
   Tipo:          Inference
   Modalidad:     Aletica
   Fuente:        Politica de Seguridad - Gestion de Accesos
   Justificacion: Identificar cuentas para revision de seguridad
   Estatica:      No (dias pueden cambiar)
   Fecha Efectiva: 2025-01-01

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-06` - Derivacion vs Transformacion
- ``_ontologia_sbvr/`` - Ontologia SBVR completa

Fuentes Externas
^^^^^^^^^^^^^^^^

- OMG SBVR 1.5 Specification
- Paper IBM: "SBVR Use Cases" (Mark H. Linehan, 2008)
- Business Rules Group: Business Rules Manifesto

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
   * - 1.1.0
     - 2025-12-21
     - Equipo IACT
     - Template BR ampliado: campos Fecha Vigencia, Prioridad, Estatica/Dinamica. Nueva seccion 6: Tecnicas de Elicitacion con 6 preguntas estrategicas.
   * - 1.0.0
     - 2025-12-19
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:** Este artefacto define el concepto de BR que es el nivel
mas alto de la jerarquia de requisitos. Referenciado por FND_03, FND_05,
FND_06 y todos los artefactos en requisitos/reglas_negocio/.
