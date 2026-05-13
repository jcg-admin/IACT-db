.. meta::
 :artefacto: TPL_UC_UML_SPEC
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

================================================================
TPL — Especificación de UC con diagramas UML (PlantUML)
================================================================

.. note::

 Plantilla canónica para especificar un caso de uso del proyecto
 IACT incluyendo los diagramas UML correspondientes en
 PlantUML, con estilos centralizados (per
 :doc:`/base-cognitiva/plantuml-guide/guidelines`).

 Esta plantilla acompaña al
 :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc` que define
 cómo aplicar esta plantilla a los 97 UCs del proyecto.

----

1. Cuándo usar esta plantilla
=============================

Use esta plantilla cuando documente un UC que requiera:

- Especificación textual (actor, precondiciones, flujos, etc.).
- Uno o más **diagramas UML** PlantUML (UC, estados, secuencia,
  actividades, clases) embebidos en la especificación.
- Trazabilidad estándar a BR, FR, NFR y plantillas
  relacionadas.

Para UCs simples sin diagramas UML, prefiera la plantilla básica
``tpl-uc-stakeholder-driven.rst``.

----

2. Convención de diagramas
==========================

- **Herramienta:** PlantUML (no Mermaid). Política del proyecto
  per
  :doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`
  + :doc:`/base-cognitiva/plantuml-guide/guidelines`.
- **Estilos:** todos los diagramas deben empezar con
  ``!include ../../_static/plantuml-styles.puml`` (ajustar
  profundidad relativa al archivo).
- **Tipos esperados** según el UC:

  - **Diagrama de casos de uso** — siempre.
  - **Diagrama de estados** — si el UC modifica el estado de
    una entidad.
  - **Diagrama de secuencias** — si el UC implica más de 2
    componentes interactuando.
  - **Diagrama de actividades** — si el flujo principal tiene
    decisiones, ramas o concurrencia.
  - **Diagrama de clases** — si el UC introduce o modifica
    entidades del modelo de datos.

----

3. Plantilla canónica
=====================

Copie y adapte el siguiente esqueleto. Reemplace los
placeholders ``[…]`` con valores reales.

3.1 Encabezado y metadata
-------------------------

.. code-block:: rst

 .. meta::
  :artefacto: UC_[MOD]_[NN]
  :tipo: Caso de Uso
  :dominio: requisitos
  :subdominio: casos-uso/[modulo]
  :estado: Borrador
  :version: 1.0.0
  :fecha_creacion: YYYY-MM-DD
  :ultimo_cambio: YYYY-MM-DD
  :autor: [Autor]
  :clasificacion: Interno

 .. _uc-[mod]-[nn]:

 ====================================
 UC_[MOD]_[NN]: [Nombre del UC]
 ====================================

3.2 Sección 1 — Información básica
----------------------------------

.. code-block:: rst

 1. Información básica
 =====================

 .. list-table::
  :widths: 25 75
  :header-rows: 0

  * - **Código**
    - UC_[MOD]_[NN]
  * - **Nombre**
    - [Descripción completa]
  * - **Actor(es)**
    - [Usuarios que inician este UC]
  * - **Prioridad**
    - CRÍTICO / ALTO / MEDIO / BAJO
  * - **Complejidad**
    - Baja / Media / Alta / MUY ALTA
  * - **Estimación**
    - XX–YY horas

3.3 Sección 2 — Relaciones UML
------------------------------

.. code-block:: rst

 2. Relaciones UML
 =================

 - **Precondición:** [UC o condición previa]
 - **<<include>>:** [UC incluido obligatoriamente]
 - **<<extend>>:** [UC extendido opcionalmente]
 - **Generaliza a / de:** [UC padre o hijo]

3.4 Sección 3 — Descripción breve
---------------------------------

.. code-block:: rst

 3. Descripción breve
 ====================

 [Párrafo descriptivo del UC: qué problema resuelve y cómo.]

3.4.0 Sección 3-pre — Análisis de dominio (obligatorio)
-------------------------------------------------------

Per :doc:`/normativa/estandares/metodologia-analisis-dominio-ucs`,
todo UC debe documentar **antes del análisis OOP** la extracción
de clases, operaciones y atributos a partir del lenguaje del
dominio.

.. code-block:: rst

 3-pre. Análisis de dominio
 ==========================

 **Sustantivos identificados** → Clases candidatas:

 - [Sustantivo 1] → ``[ClaseCandidata1]``
 - [Sustantivo 2] → ``[ClaseCandidata2]``
 - [Sustantivo N] → ``[ClaseCandidataN]``

 **Verbos identificados** → Operaciones:

 - [Verbo 1] → ``[Clase].[metodo1]()``
 - [Verbo 2] → ``[Clase].[metodo2]()``

 **Adjetivos identificados** → Atributos:

 - [Adjetivo 1] → ``[atributo1] : Boolean``
 - [Adjetivo 2] → ``[atributo2] : Boolean``

 **Paquete UML asignado:** ``[Authentication | Catalog |
 Orders | Payments | Notifications | …]``

 **Nombres de ruta** (FQN): ``Paquete::Clase``

 **Restricciones derivadas** (notación informal entre llaves):

 - ``{atributo: regla}``
 - ``{operación: precondición}``

3.4.1 Sección 3-bis — Análisis OOP (obligatorio)
------------------------------------------------

Per :doc:`/normativa/estandares/metodologia-oop-para-ucs`, todo
UC debe documentar las **seis dimensiones OOP**. Esta sección
**asume** que el análisis de dominio (§ 3-pre) ya identificó
las clases involucradas.

.. code-block:: rst

 3-bis. Análisis OOP
 ===================

 **Abstracción** — niveles de detalle:

 - Nivel 0 (USUARIO): "[lo que el usuario quiere lograr]"
 - Nivel 1 (PRODUCTO): [flujo abstracto en 3-5 pasos]
 - Nivel 2 (DESARROLLO): [pasos técnicos sólo si la
   implementación no es trivial]

 **Encapsulamiento** — qué se expone vs qué se oculta:

 - Interfaz pública: [endpoints / métodos visibles]
 - Lógica privada: [validación, cálculos, persistencia,
   auditoría]

 **Herencia** — UCs que reutiliza este UC:

 - [UC del que reutiliza pasos / clases / interfaces]
 - (escribir "ninguno" si aplica)

 **Polimorfismo** — variaciones de comportamiento:

 - [Variante 1] → [comportamiento]
 - [Variante 2] → [comportamiento]
 - (escribir "no aplica" si el UC tiene un solo comportamiento)

 **Envío de mensajes** — secuencia documentada en § 7
 (Diagrama de secuencias).

 **Asociaciones** — documentadas en § 2 (Relaciones UML):
 ``<<include>>``, ``<<extend>>``, generalización.

3.5 Sección 4 — Diagrama de casos de uso (PlantUML)
---------------------------------------------------

Plantilla del bloque (siempre presente):

.. code-block:: rst

 4. Diagrama de casos de uso
 ===========================

 .. uml::

    @startuml
    !include ../../_static/plantuml-styles.puml

    left to right direction
    actor "[Actor]" as A
    rectangle "[Sistema o Subsistema]" {
      usecase "[Nombre del UC]" as UC
      usecase "[Otro UC incluido]" as UCInc
    }
    A --> UC
    UC ..> UCInc : <<include>>
    @enduml

3.6 Sección 5 — Diagrama de estados (PlantUML)
----------------------------------------------

Sólo si el UC modifica estado.

.. code-block:: rst

 5. Diagrama de estados
 ======================

 .. uml::

    @startuml
    !include ../../_static/plantuml-styles.puml

    [*] --> Estado1
    Estado1 --> Estado2 : acción
    Estado2 --> Estado3 : otra acción
    Estado3 --> [*]
    @enduml

3.7 Sección 6 — Diagrama de actividades (PlantUML)
--------------------------------------------------

Sólo si el flujo tiene decisiones o ramas.

.. code-block:: rst

 6. Diagrama de actividades
 ==========================

 .. uml::

    @startuml
    !include ../../_static/plantuml-styles.puml

    start
    :Actividad 1;
    if ([condición]) then (sí)
      :Actividad 2;
    else (no)
      :Alternativa;
    endif
    :Fin común;
    stop
    @enduml

3.8 Sección 7 — Diagrama de secuencias (PlantUML)
-------------------------------------------------

Sólo si interactúan más de 2 componentes.

.. code-block:: rst

 7. Diagrama de secuencias
 =========================

 .. uml::

    @startuml
    !include ../../_static/plantuml-styles.puml

    actor Usuario
    participant ":Frontend" as F
    participant ":Backend"  as B
    participant ":BD"       as DB

    Usuario -> F  : acción
    F -> B        : POST /api/...
    B -> DB       : query
    DB --> B      : resultado
    B --> F       : respuesta
    F --> Usuario : confirmación
    @enduml

3.9 Sección 8 — Diagrama de clases (PlantUML)
---------------------------------------------

Sólo si introduce o modifica entidades.

.. code-block:: rst

 8. Diagrama de clases (entidades implicadas)
 ============================================

 .. uml::

    @startuml
    !include ../../_static/plantuml-styles.puml

    class Entidad1 {
      - id : Integer
      - nombre : String
      + metodo()
    }
    @enduml

3.10 Sección 9 — Precondiciones, flujos, postcondiciones
--------------------------------------------------------

.. code-block:: rst

 9. Precondiciones
 =================

 - [Condición 1]
 - [Condición 2]

 10. Flujo principal
 ===================

 1. [Paso 1]
 2. [Paso 2]
 3. [Paso 3]

 11. Flujos alternativos
 =======================

 **[Num]a — [Condición de bifurcación]:**

 1. [Acción alternativa]
 2. [Continuación]

 12. Postcondiciones
 ===================

 - [Cambio de estado tras éxito]

3.11 Sección 10 — Reglas y excepciones
--------------------------------------

.. code-block:: rst

 13. Reglas de negocio aplicables
 ================================

 - :doc:`/requisitos/reglas-negocio/br-NNN-[desc]`

 14. Excepciones
 ===============

 **E1 — [Nombre de la excepción]:**

 - **Causa:** [qué la dispara]
 - **Acción:** [qué hace el sistema]
 - **Mensaje al usuario:** [texto]

3.12 Sección 11 — Casos de prueba y trazabilidad
------------------------------------------------

.. code-block:: rst

 15. Casos de prueba
 ===================

 - **CP-[UCCODE]-001** — Caso positivo:
   [Descripción]

 - **CP-[UCCODE]-002** — Caso negativo (excepción E1):
   [Descripción]

 16. Trazabilidad
 ================

 .. list-table::
  :widths: 25 75
  :header-rows: 0

  * - **BReq origen**
    - :doc:`/requisitos/business-requirements/breq-NNN-[desc]`
  * - **BR aplicables**
    - BR_NNN, BR_NNN
  * - **FRs derivados**
    - FR_NNN_NN, FR_NNN_NN
  * - **Plantilla aplicada**
    - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`

----

4. Convención de migración Mermaid → PlantUML
=============================================

Si recibe contenido del proyecto con diagramas en **Mermaid**,
convierta antes de aplicar esta plantilla. Mapeo directo:

.. list-table::
 :widths: 30 35 35
 :header-rows: 1

 * - Tipo de diagrama
   - Mermaid
   - PlantUML equivalente
 * - Casos de uso
   - ``graph LR`` con flechas etiquetadas
   - ``actor`` + ``rectangle { usecase }`` + ``-->``
 * - Clases
   - ``classDiagram``
   - ``class … { … }`` con visibilidad ``+/-/#``
 * - Estados
   - ``stateDiagram-v2``
   - ``[*] --> Estado``, transiciones ``-->``
 * - Secuencias
   - ``sequenceDiagram``
   - ``participant`` + ``->`` / ``->>`` / ``-->``
 * - Actividades
   - ``graph TD`` con decisiones
   - ``start``, ``:actividad;``, ``if/else/endif``,
     ``stop``
 * - Componentes
   - ``graph LR`` con ``subgraph``
   - ``component``, ``package``, ``interface``
 * - Distribución
   - ``graph TB`` con ``subgraph``
   - ``node``, ``cloud``, ``component``
 * - Colaboraciones
   - ``graph TB`` con etiquetas numeradas
   - ``object`` + flechas con etiqueta ``"N: msg()"``

----

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Origen del template**
   - Adaptado de "GUÍA DE INTEGRACIÓN UML v2.0.0" (interna),
     reescrito a PlantUML por política del proyecto
 * - **Política de diagramación**
   - PlantUML — :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Estilos centralizados**
   - ``source/_static/plantuml-styles.puml``
 * - **Plan de aplicación**
   - :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc`
 * - **Plantilla hermana (UC simple)**
   - :doc:`tpl-uc-stakeholder-driven`
 * - **Metodología de análisis de dominio**
   - :doc:`/normativa/estandares/metodologia-analisis-dominio-ucs`
 * - **Metodología OOP**
   - :doc:`/normativa/estandares/metodologia-oop-para-ucs`
 * - **Estándar de naming**
   - :doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`
