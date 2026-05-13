.. meta::
   :artefacto: FND_01
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2025-12-19
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-01:

=============================
FND_01: Concepto de Requisito
=============================

Proposito
---------

Este documento define QUE ES un requisito en el contexto del proyecto IACT,
estableciendo la base conceptual para todo el dominio ``requisitos/``.

----

1. Definicion Formal
--------------------

1.1 Que es un Requisito
^^^^^^^^^^^^^^^^^^^^^^^

Un **requisito** es una declaracion documentada de una capacidad, condicion
o caracteristica que un sistema debe poseer para satisfacer un contrato,
estandar, especificacion u otro documento formalmente impuesto.

.. note::

   **Definicion operativa para IACT:**

   Un requisito es una declaracion verificable que describe algo que el
   sistema DEBE hacer (funcional) o una cualidad que DEBE tener (no funcional).

1.2 Requisito vs Deseo
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Requisito
     - Deseo
   * - Naturaleza
     - Obligatorio, contractual
     - Opcional, aspiracional
   * - Verificacion
     - Medible y comprobable
     - Subjetivo
   * - Ejemplo
     - "Sistema DEBE autenticar usuarios"
     - "Sistema deberia ser bonito"
   * - Consecuencia
     - Falla = incumplimiento
     - No cumplir = aceptable

1.3 Requisito vs Especificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Requisito
     - Especificacion
   * - Nivel
     - QUE debe hacerse
     - COMO debe hacerse
   * - Abstraccion
     - Mayor
     - Menor
   * - Ejemplo Requisito
     - "Sistema DEBE hashear passwords"
     - (no aplica)
   * - Ejemplo Especificacion
     - (no aplica)
     - "Usar bcrypt con cost=12"

----

2. Tipos de Requisitos
----------------------

2.1 Taxonomia Principal
^^^^^^^^^^^^^^^^^^^^^^^

Los requisitos se clasifican en dos grandes categorias:

.. code-block:: text

   REQUISITOS
       |
       +--- Funcionales (FR)
       |        |
       |        +--- Que debe HACER el sistema
       |        +--- Capacidades, comportamientos
       |        +--- Verificacion: funciona/no funciona
       |
       +--- No Funcionales (NFR)
                |
                +--- Que tan BIEN debe hacerlo
                +--- Cualidades, restricciones
                +--- Verificacion: grado de cumplimiento

2.2 Requisitos Funcionales (FR)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:**

Especificacion de una capacidad o comportamiento que el sistema debe proveer
para satisfacer las necesidades del negocio.

**Pregunta clave:** Que debe HACER el sistema?

**Ejemplos en IACT:**

.. code-block:: text

   FR-001: Sistema DEBE autenticar usuarios mediante JWT
   FR-002: Sistema DEBE exportar reportes en formato CSV
   FR-003: Sistema DEBE calcular metricas diarias de llamadas

**Caracteristicas:**

- Describen capacidades especificas
- Verificacion binaria (cumple/no cumple)
- Origen: Casos de Uso, Reglas de Negocio

2.3 Requisitos No Funcionales (NFR)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Definicion:**

Especificacion de criterios de calidad que el sistema debe cumplir,
no funcionalidades especificas.

**Pregunta clave:** Que tan BIEN debe hacerlo?

**Categorias principales:**

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Categoria
     - Descripcion
   * - Rendimiento
     - Tiempo de respuesta, throughput, latencia
   * - Escalabilidad
     - Usuarios simultaneos, crecimiento de datos
   * - Seguridad
     - Autenticacion, autorizacion, encriptacion
   * - Disponibilidad
     - Uptime, recuperacion ante desastres
   * - Mantenibilidad
     - Facilidad de cambios, modularidad
   * - Usabilidad
     - Facilidad de aprendizaje, accesibilidad

**Ejemplos en IACT:**

.. code-block:: text

   NFR-001: API DEBE responder en < 2 segundos (95th percentile)
   NFR-002: Sistema DEBE soportar 100 usuarios simultaneos
   NFR-003: Disponibilidad DEBE ser >= 99.5%

2.4 Comparacion FR vs NFR
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - FR (Funcional)
     - NFR (No Funcional)
   * - Pregunta
     - Que debe hacer?
     - Que tan bien?
   * - Enfoque
     - Capacidades
     - Cualidades
   * - Verificacion
     - Binaria
     - Grado
   * - Testing
     - Test funcional
     - Test rendimiento/carga
   * - Ejemplo
     - "Validar email"
     - "Validar en < 100ms"

----

3. Caracteristicas de un Buen Requisito
---------------------------------------

3.1 Criterio SMART
^^^^^^^^^^^^^^^^^^

Un requisito bien escrito cumple con SMART:

.. list-table::
   :header-rows: 1
   :widths: 15 30 55

   * - Letra
     - Significado
     - Aplicacion
   * - S
     - Specific (Especifico)
     - Sin ambiguedad, una sola interpretacion
   * - M
     - Measurable (Medible)
     - Criterios de aceptacion verificables
   * - A
     - Achievable (Alcanzable)
     - Tecnicamente factible
   * - R
     - Relevant (Relevante)
     - Aporta valor al negocio
   * - T
     - Time-bound (Temporal)
     - Tiene fecha o contexto temporal

3.2 Caracteristicas Esenciales
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Precision:**

.. code-block:: text

   INCORRECTO: "El sistema debe validar datos"
   CORRECTO:   "El sistema DEBE validar que el email tenga formato RFC 5322"

**Verificabilidad:**

.. code-block:: text

   INCORRECTO: "El sistema debe ser rapido"
   CORRECTO:   "El sistema DEBE responder en < 2 segundos (95th percentile)"

**No Ambiguedad:**

.. code-block:: text

   INCORRECTO: "El sistema debe guardar informacion del usuario"
   CORRECTO:   "El sistema DEBE almacenar: nombre (max 100 chars),
                email (unico), fecha_registro (timestamp UTC)"

**Atomicidad:**

.. code-block:: text

   INCORRECTO: "El sistema debe registrar productos y validar todo"
   CORRECTO:   FR-40.1: "Sistema DEBE validar formato CAS"
               FR-40.2: "Sistema DEBE verificar unicidad CAS"
               (Cada FR es atomico, separado)

3.3 Nivel de Abstraccion Correcto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El requisito debe estar en el nivel medio de abstraccion:

.. code-block:: text

   ABSTRACCION ALTA (Business Rules):
   "Passwords deben ser seguros"
              |
              v
   ABSTRACCION MEDIA (Requisito) <-- NIVEL CORRECTO
   "Sistema DEBE hashear passwords con bcrypt cost=12"
              |
              v
   ABSTRACCION BAJA (Implementacion):
   "class UserService { hash(pwd) { return bcrypt(pwd, 12); }}"

----

4. Origen de los Requisitos
---------------------------

4.1 Fuentes de Requisitos
^^^^^^^^^^^^^^^^^^^^^^^^^

Los requisitos en IACT provienen de multiples fuentes:

.. code-block:: text

   FUENTE 1: Business Rules (BR)
   BR-015: "Productos quimicos clase 5 requieren aprobacion nivel 2"
       |
       v
   FR-204.3: "Si producto.clase_peligrosidad = 5,
              sistema DEBE requerir aprobador con nivel >= 2"

   FUENTE 2: Casos de Uso (UC)
   UC-40 Paso 6: "Sistema valida formato CAS Number"
       |
       v
   FR-40.6: "Sistema DEBE validar CAS con regex ^[0-9]{2,7}-[0-9]{2}-[0-9]$"

   FUENTE 3: Restricciones del Cliente (CNST)
   CNST-001: "NO usar email para notificaciones"
       |
       v
   FR-MSG-01: "Sistema DEBE usar buzon interno para notificaciones"

4.2 Jerarquia de Requisitos
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los requisitos existen en una jerarquia de abstraccion:

.. code-block:: text

   Nivel 0: Business Rules (BR)
            Politicas externas al sistema
            Pregunta: POR QUE existe esta restriccion?
                |
                v
   Nivel 1: Business Requirements (BReq)
            Objetivos del proyecto
            Pregunta: POR QUE existe este proyecto?
                |
                v
   Nivel 2: User Requirements / Use Cases (UC)
            Comportamientos observables
            Pregunta: QUE hace el usuario?
                |
                v
   Nivel 3: Functional Requirements (FR)
            Especificaciones atomicas
            Pregunta: COMO lo hace el sistema?

Para mas detalle, ver :ref:`fnd-05`.

----

5. Anti-patrones de Requisitos
------------------------------

5.1 Errores Comunes
^^^^^^^^^^^^^^^^^^^

**Requisito vago:**

.. code-block:: text

   INCORRECTO: "El sistema debe ser facil de usar"

   Problema: No verificable, subjetivo

   CORRECTO: "El usuario DEBE completar el registro en < 3 minutos
              sin asistencia, con tasa de exito >= 95%"

**Requisito compuesto:**

.. code-block:: text

   INCORRECTO: "El sistema debe validar, guardar y notificar el pedido"

   Problema: Multiples acciones en un requisito

   CORRECTO: FR-01: "Sistema DEBE validar datos del pedido"
             FR-02: "Sistema DEBE persistir pedido en BD"
             FR-03: "Sistema DEBE notificar via buzon interno"

**Requisito con implementacion:**

.. code-block:: text

   INCORRECTO: "El sistema debe usar la clase BCryptHasher del
                paquete spring-security con metodo encode()"

   Problema: Especifica implementacion, no requisito

   CORRECTO: "El sistema DEBE hashear passwords usando bcrypt
              con cost factor >= 12"

5.2 Palabras Prohibidas
^^^^^^^^^^^^^^^^^^^^^^^

Evitar estas palabras por ser ambiguas:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Palabra
     - Problema
     - Alternativa
   * - "rapido"
     - No cuantificable
     - "en < 2 segundos"
   * - "facil"
     - Subjetivo
     - "en < 3 pasos"
   * - "seguro"
     - Muy amplio
     - Especificar mecanismo
   * - "flexible"
     - Vago
     - Definir parametros
   * - "adecuado"
     - Subjetivo
     - Cuantificar

----

6. Costo de Requisitos Mal Escritos
-----------------------------------

6.1 Impacto Economico
^^^^^^^^^^^^^^^^^^^^^

Segun estudios de IBM (2008), el costo de corregir defectos aumenta
exponencialmente segun la fase donde se detectan:

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Fase de Deteccion
     - Costo Relativo
     - Ejemplo ($)
   * - Requisitos
     - 1x
     - $100
   * - Diseno
     - 5x
     - $500
   * - Codigo
     - 10x
     - $1,000
   * - Testing
     - 20x
     - $2,000
   * - Produccion
     - 100-200x
     - $10,000-20,000

6.2 Beneficios de Requisitos Bien Escritos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Reduccion de defectos en 40-50%
- Eliminacion de ciclos de clarificacion
- Testing directo desde requisitos
- Trazabilidad completa
- Mantenimiento simplificado

----

7. Requisitos en el Contexto IACT
---------------------------------

7.1 Nomenclatura
^^^^^^^^^^^^^^^^

Los requisitos en IACT siguen la convencion:

.. code-block:: text

   FORMATO: PREFIJO-NNN[.X]

   Donde:
   - PREFIJO: Tipo de requisito (BR, UC, FR, NFR)
   - NNN: Numero secuencial de 3 digitos
   - .X: Sub-indice opcional para FR derivados de UC

   Ejemplos:
   - BR-001: Primera regla de negocio
   - UC-015: Caso de uso numero 15
   - FR-015.3: Tercer FR derivado de UC-015
   - NFR-007: Septimo requisito no funcional

7.2 Ubicacion en el Modelo IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   requisitos/
       |
       +--- reglas_negocio/      <- BR_NNN
       |
       +--- casos_uso/           <- UC_NNN
       |
       +--- funcionales/         <- FR_NNN
       |
       +--- no_funcionales/      <- NFR_NNN

----

8. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-02` - Reglas de Negocio
- :ref:`fnd-03` - Casos de Uso
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-07` - Requerimientos Funcionales

Fuentes Externas
^^^^^^^^^^^^^^^^

- IEEE 830-1998: Recommended Practice for Software Requirements Specifications
- IREB CPRE: Certified Professional for Requirements Engineering

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

**Trazabilidad:** Este artefacto es la base conceptual para todo el dominio
requisitos/. Referenciado por FND_02, FND_03, FND_05 y FND_07.
