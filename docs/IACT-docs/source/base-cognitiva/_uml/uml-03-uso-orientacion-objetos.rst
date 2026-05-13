.. meta::
 :artefacto: UML_03
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-03:

==========================================
UML_03: Uso de la orientación a objetos
==========================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 3.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

----

Clase
=====

En UML un **rectángulo** es el símbolo que representa una clase.

El nombre de la clase es, por convención, una palabra con la
primera letra en mayúscula y normalmente se coloca en la parte
superior del rectángulo. Si el nombre de su clase consta de dos
palabras, únalas e inicie cada una con mayúscula (como en
``LavadoraIndustrial``).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora
   class LavadoraIndustrial
   @enduml

----

Paquete
=======

El **paquete** puede jugar un papel en el nombre de la clase.

Un paquete es la manera en que UML **organiza un diagrama de
elementos**. UML representa un paquete como una **carpeta
tabular** cuyo nombre es una cadena de texto.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   package "Electrodomesticos" {
     class Lavadora
     class Refrigerador
     class HornoMicroondas
   }
   @enduml

.. note::

 Si la clase ``Lavadora`` es parte de un paquete llamado
 ``Electrodomesticos``, podrá darle el nombre
 ``Electrodomesticos::Lavadora``.

El par de dos puntos (``::``) separa al nombre del paquete (a la
izquierda) del nombre de la clase (a la derecha). A este tipo de
nombre se le conoce como **nombre de ruta** y refleja una
relación padre-hijo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class "Electrodomesticos::Lavadora" as L
   @enduml

.. caution::

 Evitamos los acentos en los diagramas, e igualmente la letra
 ``ñ``, que sustituimos por ``ni`` (como en ``Anio`` en lugar de
 ``Año``).

----

Atributos
=========

Un atributo es una **propiedad o característica de una clase** y
describe un rango de valores que la propiedad podrá contener en
los objetos (instancias) de la clase. Una clase podrá contener
varios o ningún atributo.

Si el atributo consta de **una sola palabra** se escribe en
**minúsculas**. Si el nombre contiene **más de una palabra**,
cada palabra será unida a la anterior y comenzará con mayúscula,
**a excepción de la primera** que comenzará en minúscula
(``camelCase``).

Los atributos se inician luego de una línea que los separa del
nombre de la clase.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     marca
     modelo
     numeroSerie
     capacidad
   }
   @enduml

Todo objeto de la clase tiene un valor específico en cada
atributo. El nombre de un objeto **inicia con minúscula**, está
**precedido de dos puntos** y luego del nombre de la clase, y
todo el nombre va subrayado.

El nombre ``miLavadora:Lavadora`` es una instancia con nombre,
pero también es posible tener una **instancia anónima**, como
``:Lavadora``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   object "miLavadora : Lavadora" as ml {
     marca = "Laundatorium"
     modelo = "Washmeister"
     numeroSerie = "GL57774"
     capacidad = 7.0
   }
   object ":Lavadora" as anon {
     marca = "GenericBrand"
     capacidad = 8.0
   }
   @enduml

En el símbolo de la clase, podrá especificar un **tipo** para
cada valor del atributo: cadena (``String``), número de punto
flotante (``Float``), entero (``Integer``), booleano
(``Boolean``), así como otros tipos enumerados.

Para indicar un tipo, utilice dos puntos (``:``) para separar el
nombre del atributo de su tipo. También podrá indicar un
**valor predeterminado** para un atributo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     marca : String
     modelo : String
     numeroSerie : String
     capacidad : Float = 7.0
     activa : Boolean = false
   }
   @enduml

----

Operaciones
===========

Una operación es **algo que la clase puede realizar**, o que
usted (u **otra clase**) pueden hacer a una clase.

El nombre de una operación se escribe en minúsculas si consta de
una sola palabra. Si consta de más de una palabra, únalas e
inicie todas con mayúscula exceptuando la primera (``camelCase``,
igual que en atributos).

La lista de operaciones se inicia **debajo de una línea que las
separa de los atributos**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     marca : String
     modelo : String
     capacidad : Float
     --
     agregarRopa()
     agregarDetergente()
     activarse()
     sacarRopa()
   }
   @enduml

.. note::

 Es posible establecer información adicional de los atributos y
 de las operaciones.

En los paréntesis que preceden al nombre de la operación podrá
mostrar el **parámetro** con el que funcionará la operación
junto con su tipo de dato.

La **función**, que es un tipo de operación, devuelve un valor
luego que finaliza su trabajo; la función podrá mostrar el tipo
de valor que regresará.

Estas secciones de información acerca de una operación se
conocen como la **firma de la operación**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     marca : String
     capacidad : Float
     --
     agregarDetergente(d : Integer)
     activarse(modo : String) : Boolean
     obtenerCapacidad() : Float
   }
   @enduml

No es muy útil mostrar siempre los nombres de los atributos y de
las operaciones — se puede ver un diagrama saturado. En lugar de
ello podrá tan sólo mostrar el nombre de la clase y dejar ya
sea el área de atributos o el de operaciones (o ambas) vacía.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora1 as "Lavadora"
   class Lavadora2 as "Lavadora" {
     marca
     modelo
   }
   class Lavadora3 as "Lavadora" {
     --
     agregarRopa()
     activarse()
   }
   @enduml

.. tip::

 En ocasiones será bueno **mostrar algunos (pero no todos)** de
 los atributos u operaciones. Para indicar que sólo enseñará
 algunos de ellos, seguirá la lista de aquellos que mostrará
 **con tres puntos (...)**.

A la omisión de ciertos o todos los atributos y operaciones se
le conoce como **abreviar una clase**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     marca
     modelo
     ...
     --
     agregarRopa()
     ...
   }
   @enduml

Si tiene una larga lista de atributos u operaciones podrá
utilizar un **estereotipo** para organizarla de forma que sea
más comprensible.

Un **estereotipo** es el modo en que UML le permite extenderlo,
es decir, **crear nuevos elementos** que son específicos de un
problema en particular que intente resolver.

Para mostrar un estereotipo, su nombre va bordeado por dos pares
de paréntesis angulares: ``<<info ejemplo>>``. Para una lista
de atributos, podrá utilizar un estereotipo como encabezado de
un subconjunto de atributos.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     <<identidad>>
     marca : String
     modelo : String
     numeroSerie : String
     <<operacion>>
     capacidad : Float
     velocidadMotor : Integer
     --
     agregarRopa()
     activarse()
   }
   @enduml

También podrá utilizar el estereotipo sobre el nombre de una
clase para indicar algo respecto al **papel** de la clase.

----

Responsabilidades y restricciones
=================================

En un área bajo la lista de operaciones, podrá mostrar la
**responsabilidad** de la clase. La responsabilidad es una
descripción de **lo que hará la clase** — es decir, lo que sus
atributos y operaciones intentan realizar en conjunto.

Una lavadora, por ejemplo, tiene la responsabilidad de recibir
ropa sucia y dar por resultado ropa limpia.

Indicará las responsabilidades en un área inferior a la que
contiene las operaciones.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     marca : String
     capacidad : Float
     --
     agregarRopa()
     activarse()
     sacarRopa()
     --
     responsabilidades:
     -- Recibir ropa sucia
     -- Lavar y enjuagar
     -- Entregar ropa limpia
   }
   @enduml

La idea es incluir información suficiente para describir una
clase de forma inequívoca.

Una manera más formal es agregar una **restricción**, un
**texto libre bordeado por llaves**: este texto especifica una o
varias reglas que sigue la clase. Para "restringir" el atributo
``capacidad`` de la clase ``Lavadora``, escribirá
``{capacidad = 7, 8 o 9 Kg}`` junto al símbolo de la clase.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     marca : String
     capacidad : Float
     --
     agregarRopa()
     activarse()
   }
   note right of Lavadora
     {capacidad = 7, 8 o 9 Kg}
   end note
   @enduml

UML proporciona otra forma — aún más formal — de agregar
restricciones, con todo un lenguaje conocido como **OCL** (Object
Constraint Language). OCL cuenta con su propio conjunto de
reglas, términos y operadores, lo que lo convierte en una
herramienta avanzada y, en ocasiones, útil.

----

Notas adjuntas
==============

Por encima y debajo de los atributos, operaciones,
responsabilidades y restricciones, puede **agregar mayor
información a una clase en la figura de notas adjuntas**. Una
nota puede contener tanto una imagen como texto.

Estas notas deben servir solo para algo específico, y no para
dar detalle de lo que hace la clase. Un ejemplo: que se tengan
ciertas reglas ya establecidas para la creación de un atributo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     numeroSerie : String
     marca : String
     capacidad : Float
   }
   note right of Lavadora
     Para la generación de números de serie,
     consulte la **norma gubernamental
     NOM-XXX-2026** que define el formato
     y el procedimiento de asignación.
   end note
   @enduml

----

Qué hacen las clases y cómo encontrarlas
========================================

Las clases son el **vocabulario y terminología de un área del
conocimiento**. Conforme hable con los clientes, analice su
área de conocimiento y diseñe sistemas, este vocabulario se va
formando — es lo que el cliente realiza para resolver su problema
en un área específica. Se puede decir que las clases son el
**área de dominio específico** de lo que hará el sistema.

Con los clientes, preste atención a los **sustantivos** que
utilizan para describir las entidades de sus negocios; dichos
sustantivos se convertirán en las **clases** de su modelo. Y
preste atención a los **verbos** que escuche, dado que
constituirán las **operaciones** y los **atributos** de sus
clases.

Imagine que generará un modelo del juego de baloncesto, y que
entrevista a un entrenador para comprender el juego.

.. admonition:: Ejemplo de entrevista

 **Analista:** "Entrenador, ¿de qué se trata el juego?"

 **Entrenador:** "Consiste en arrojar el *balón* a través de un
 aro, conocido como *cesto*, y hacer una mayor *puntuación* que
 el oponente. Cada *equipo* consta de cinco *jugadores*: dos
 *defensas*, dos *delanteros* y un *central*. Cada equipo lleva
 el balón al cesto del equipo oponente con el objetivo de hacer
 que el balón sea encestado."

 **Analista:** "¿Cómo se hace para llevar el balón al otro
 cesto?"

 **Entrenador:** "Mediante *pases* y *dribles*. Pero el equipo
 tendrá que encestar antes de que termine el *lapso para tirar*."

 **Analista:** "¿El lapso para tirar?"

 **Entrenador:** "Así es, son 24 segundos en el baloncesto
 profesional, 30 en un juego internacional, y 35 en el colegial
 para tirar el balón luego de que un equipo toma posesión de él."

 **Analista:** "¿Cómo funciona el puntaje?"

 **Entrenador:** "Cada *canasta* vale dos puntos, a menos que el
 tiro haya sido hecho detrás de la *línea de los tres puntos*.
 En tal caso, serán tres puntos. Un *tiro libre* contará como
 un punto. A propósito, un tiro libre es la penalización que
 paga un equipo por cometer una *infracción*. Si un jugador
 infracciona a un oponente, se detiene el juego y el oponente
 puede realizar diversos tiros al cesto desde la *línea de tiro
 libre*."

 **Analista:** "Hábleme más acerca de lo que hace cada jugador."

 **Entrenador:** "Quienes juegan de defensa son, en general,
 quienes realizan la mayor parte de los dribles y pases. Por lo
 general tienen menor estatura que los delanteros, y éstos, a
 su vez, son menos altos que el central (que también se conoce
 como 'poste'). Se supone que todos los jugadores pueden burlar,
 pasar, tirar y rebotar. Los delanteros realizan la mayoría de
 los rebotes y los disparos de mediano alcance, mientras que el
 central se mantiene cerca del cesto y dispara desde un alcance
 corto."

 **Analista:** "¿Qué hay de las dimensiones de la *cancha*? Y
 ya que estamos en eso, ¿cuánto dura el juego?"

 **Entrenador:** "En un juego internacional, la cancha mide 28
 metros de longitud y 15 de ancho; el cesto se encuentra a 3.05
 m del piso. En un juego profesional, el juego dura 48 minutos,
 divididos en cuatro cuartos de 12 minutos cada uno. En un juego
 colegial e internacional, la duración es de 40 minutos,
 divididos en dos mitades de 20 minutos. Un *cronómetro del
 juego* lleva un control del tiempo restante."

Sustantivos descubiertos: **balón**, **cesto**, **equipo**,
**jugadores**, **defensas**, **delanteros**, **central** (o
**poste**), **tiro**, **lapso para tirar**, **línea de los tres
puntos**, **tiro libre**, **infracción**, **línea de tiro libre**,
**cancha**, **cronómetro del juego**.

Verbos descubiertos: **tirar**, **avanzar**, **driblar** (o
burlar), **pasar**, **infraccionar**, **rebotar**.

También cuenta con cierta **información adicional** respecto a
algunos de los sustantivos (como las estaturas relativas de los
jugadores de cada posición, las dimensiones de la cancha, la
cantidad total de tiempo en un lapso de tiro y la duración de un
juego).

Con el sentido común podría entrar en acción para generar
ciertos **atributos** por usted mismo. Usted sabe, por ejemplo,
que el balón cuenta con ciertos atributos, como volumen y
diámetro.

A partir de esta información, podrá crear un diagrama como el
siguiente. El diagrama también muestra **las responsabilidades**.
Podría usar este diagrama como fundamento para otras
conversaciones con el entrenador para obtener mayor información.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Balon {
     volumen : Float
     diametro : Float
     --
     rebotar()
   }

   class Cesto {
     altura : Float
   }

   class Cancha {
     longitud : Float = 28
     ancho : Float = 15
   }

   class Equipo {
     nombre : String
     puntuacion : Integer
     --
     atacar()
     defender()
   }

   class Jugador {
     estatura : Float
     numero : Integer
     --
     tirar()
     pasar()
     driblar()
     rebotar()
     infraccionar()
   }

   class Defensa
   class Delantero
   class Central

   Jugador <|-- Defensa
   Jugador <|-- Delantero
   Jugador <|-- Central

   Equipo "1" *-- "5" Jugador

   class Tiro {
     valor : Integer
   }
   class TiroLibre
   Tiro <|-- TiroLibre

   class CronometroJuego {
     tiempoRestante : Integer
   }

   class LapsoTirar {
     duracion : Integer
   }

   Cancha "1" o-- "2" Cesto
   Equipo "2" -- "1" Cancha
   Jugador "1" -- "0..*" Tiro
   @enduml

----

Resumen
=======

Un **rectángulo** es, en UML, la representación simbólica de
una clase.

Una clase tiene **nombre, atributos, operaciones y
responsabilidades**, las cuales se muestran en áreas delimitadas
dentro del rectángulo.

Se puede utilizar un **estereotipo** para organizar las listas
de atributos y operaciones (``<<lista algo>>``).

Se puede **abreviar una clase** al mostrar sólo un subconjunto de
sus atributos y operaciones (``...``).

También se pueden mostrar el tipo de un atributo, su valor
inicial y enseñar los valores con que funciona una operación,
así como sus tipos. En una operación, esta información se conoce
como **firma de la operación**.

Para reducir la ambigüedad en la descripción de una clase
agregue **restricciones**, que se agregan entre llaves ``{ }``.
Existe todo un lenguaje para las restricciones llamado **OCL**
(Object Constraint Language).

Se puede agregar mayor información respecto a una clase mediante
**notas adjuntas**.

Las clases representan el **vocabulario** de un área del
conocimiento: los **sustantivos** se convertirán en clases en un
modelo, y los **verbos** se transformarán en operaciones.

Podrá utilizar un diagrama de clases como una forma de estimular
al cliente.

¿Qué ocurre cuando tengo que analizar un área desconocida (donde
el sentido común no será de mucha ayuda)?

Antes de que se reúna con un cliente o con un experto en el
campo, intente **convertirse en un "subexperto"**. Prepárese
para la reunión y **lea cuanta documentación relacionada tenga
a la mano**. Pregunte a sus entrevistados respecto a documentos
o manuales que hayan escrito. Cuando haya terminado de leer,
tendrá cierto conocimiento básico.

Luego de la fase de análisis, conforme se adentre en el diseño,
podrá **mostrar la firma de una operación**. La firma es una
sección de información que los desarrolladores podrían encontrar
muy útil; en ella se habla de lo que se espera de la operación.
Recuerde, ésta podrá **mostrar el parámetro con el que
funcionará la operación junto con su tipo de dato**. En la
operación ``agregarDetergente(d : Integer)`` es un ejemplo de
una operación de la clase ``Lavadora`` que tiene una relación
con la clase ``Detergente``.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-02-orientacion-objetos`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 3 (Schmuller, 2000)
