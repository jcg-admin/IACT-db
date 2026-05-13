.. meta::
 :artefacto: UML_05
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-05:

================================================================
UML_05: Agregación, composición, interfaces y realización
================================================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 5.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

La meta final es crear una **idea estática** de un sistema, con
todas las conexiones entre las clases que lo conforman.

----

Agregaciones
============

Una clase que consta de otras clases es un tipo especial de
relación conocida como **agregación** o **acumulación**.

.. note::

 La **agregación** o **acumulación** es un tipo de asociación,
 en donde participan el componente y el todo. En agregación, el
 componente **no necesariamente corresponde a un solo todo**.

Puede representar una agregación como una jerarquía con la
**clase completa en la parte superior** y los **componentes por
debajo** de ella.

Una línea conectará el todo con un componente mediante un
**rombo sin relleno** que se colocará en la línea más cercana al
todo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Computadora
   class Gabinete
   class Teclado
   class Raton
   class Monitor
   class UnidadCDROM
   class DiscoDuro

   Computadora o-- Gabinete
   Computadora o-- Teclado
   Computadora o-- Raton
   Computadora o-- Monitor
   Computadora o-- UnidadCDROM
   Computadora o-- "1..*" DiscoDuro
   @enduml

En el ejemplo anterior, cada componente corresponde a un todo.
En una agregación éste no será necesariamente el caso.

Por ejemplo: en un sistema casero de entretenimiento, un control
remoto podría ser un componente de una televisión, aunque
también podría ser un componente de una reproductora de casetes
de vídeo.

Restricciones en las agregaciones
---------------------------------

El conjunto de componentes posibles en una agregación se
establece dentro de una **relación O**: el componente *u otro*
es parte del todo.

Por ejemplo: una comida consta de **sopa o ensalada**, el plato
fuerte y el postre. Para modelar esto, utilizaría **una
restricción**: la palabra ``O`` dentro de llaves ``{O}`` con una
línea discontinua que conecte las dos líneas que conforman al
todo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Comida
   class Sopa
   class Ensalada
   class PlatoFuerte
   class Postre

   Comida o-- Sopa
   Comida o-- Ensalada
   Comida o-- PlatoFuerte
   Comida o-- Postre

   Sopa ..> Ensalada : <<{O}>>
   @enduml

----

Composiciones
=============

La **composición** es un tipo muy representativo de una
agregación. Cada componente dentro de una composición puede
pertenecer **tan sólo a un todo**.

.. note::

 En comparación con la agregación, los componentes de la
 composición **pertenecen a sólo un todo**.

Por ejemplo: los componentes de una **mesa de café** (la
superficie de la mesa y las patas) establecen una composición.

El símbolo es el mismo que el de una agregación, **excepto que el
rombo está relleno**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class MesaCafe
   class Superficie
   class Pata

   MesaCafe *-- "1" Superficie
   MesaCafe *-- "4" Pata
   @enduml

----

Contextos
=========

Cuando modele un sistema podrían producirse, con frecuencia,
agrupamientos de clases (agregaciones o composiciones). Es
necesario enfocar su atención en un agrupamiento u otro.

El **diagrama de contexto** proporciona la característica para
modelar dichos agrupamientos. Las composiciones se encuentran en
gran medida en los diagramas de contexto.

Un diagrama de contexto es como **un mapa detallado de alguna
sección de un mapa de mayores dimensiones**. Pueden ser
necesarias varias secciones para capturar toda la información
detallada — y a veces se necesita ver todo el panorama (como si
estuvieras viendo una ciudad desde un helicóptero).

Por ejemplo: un tipo de diagrama de contexto le mostrará la
camisa como un gran rectángulo de clase, con un diagrama anidado
en el interior que muestra cómo los componentes de la camisa
están relacionados entre sí. Éste es un **diagrama de contexto
de composición** (dado que la sola camisa reúne a cada
componente).

En este diagrama de contexto de composición se enfoca la
atención en la camisa y sus componentes:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   package "Camisa (composición)" {
     class Cuerpo
     class Cuello
     class Manga
     class Boton
     class Ojal
     class Puno

     Cuerpo *-- Cuello
     Cuerpo *-- "2" Manga
     Cuerpo *-- "1..*" Boton
     Cuerpo *-- "1..*" Ojal
     Manga *-- Puno
   }
   @enduml

Un componente, por sí solo, no tiene un propósito; para que lo
tenga debe tener cierto tipo de componentes — **sólo y sólo si
tiene todos los componentes, tiene propósito**. Eso es
composición.

.. note::

 El diagrama de contexto de composición enfoca la atención en
 los **componentes que pertenecen a un todo**.

A veces es necesario ampliar el ámbito. Por ejemplo: la camisa en
el contexto del guardarropa y de algún atuendo. El contexto
cambia a un todo más general, para ver cómo se relaciona en
diferentes ámbitos.

Para conocer todo el ámbito es necesario un **diagrama de
contexto del sistema**. En el ejemplo, mostrar la forma en que
la clase ``Camisa`` se conecta con las clases ``Guardarropa`` y
``Atuendo``:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Guardarropa
   class Atuendo
   class Camisa
   class Pantalon
   class Zapatos

   Guardarropa o-- "0..*" Camisa
   Guardarropa o-- "0..*" Pantalon
   Guardarropa o-- "0..*" Zapatos
   Atuendo "1" o-- "1" Camisa
   Atuendo "1" o-- "1" Pantalon
   Atuendo "1" o-- "1" Zapatos
   @enduml

----

Interfaces y realizaciones
==========================

Cuando haya creado varias clases y se dé cuenta de que no todas
pertenecen a una clase principal, pero su comportamiento debe
incluir algunas de las **mismas operaciones con las mismas
firmas**, querrá:

- codificar las operaciones en una de las clases y reutilizarlas
  en otras;
- desarrollar un conjunto de operaciones que puedan ser
  utilizadas en diferentes clases dentro de un sistema;
- y que también se puedan reutilizar en las clases de otro
  sistema.

Esto implica encontrar un método para capturar un **conjunto
reutilizable de operaciones**. Una forma de lograrlo es a través
de una **interfaz**: un conjunto de operaciones que especifica
cierto aspecto de la funcionalidad de una clase — un **conjunto
de operaciones que una clase presenta a otras clases**.

La interfaz puede establecer un **subconjunto** de las
operaciones de una clase y no necesariamente todas ellas.

Como un conjunto de operaciones, una interfaz **no tiene
atributos**. Para modelar una interfaz en UML se utiliza un
símbolo rectangular con el nombre de la interfaz escrito en
cursiva y precedido por el estereotipo ``<<interface>>``.

.. note::

 Para poder distinguir una clase que no muestra sus atributos de
 una interfaz, puede utilizar la estructura "estereotipo" y
 especificar la palabra ``<<interface>>``. Otra opción es
 colocar la letra ``I`` al principio del nombre de una interfaz.

Por ejemplo: si el teclado de la computadora garantizara que
parte de su funcionalidad *"haría las veces"* del teclado de una
máquina de escribir, bajo este esquema, la relación entre una
clase y una interfaz se conoce como **realización**, y se modela
como una línea discontinua con una **punta de flecha en forma de
triángulo sin rellenar** que adjunte y apunte a la interfaz.

Una **interfaz es un conjunto de operaciones que realiza una
clase**. Esta última se relaciona con una interfaz mediante la
**realización**, indicada por una línea discontinua con una
punta de flecha en forma de triángulo sin rellenar que apunta a
la interfaz.

Una **realización** se refiere a la relación entre una interfaz
y una clase que implementa esa interfaz. Es cuando una clase
dice: *"Voy a seguir las reglas de esta interfaz"*.

Una clase puede realizar más de una interfaz, y una interfaz
puede ser realizada por más de una clase.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   interface "ITecladoMaquinaEscribir" as ITME {
     + presionarTecla(t)
     + obtenerCaracter() : Char
     + cambiarMayuscula()
   }

   class TecladoComputadora {
     - layout : String
     + presionarTecla(t)
     + obtenerCaracter() : Char
     + cambiarMayuscula()
     + enviarComandoSO()
   }

   TecladoComputadora ..|> ITME
   @enduml

Otra forma (omitida en muchas convenciones modernas) de
representar una clase y su interfaz es con un **pequeño círculo**
(*lollipop*) que se conecte mediante una línea a la clase:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class TecladoComputadora
   () "ITecladoMaquinaEscribir" as ITME
   TecladoComputadora -- ITME
   @enduml

----

Visibilidad
===========

La **visibilidad** se aplica a atributos u operaciones, y
establece la proporción en que otras clases podrán utilizar los
atributos y operaciones de una clase dada (o las operaciones de
una interfaz).

- **Nivel público** — la funcionalidad se extiende a otras
  clases. Antecede el atributo u operación con un signo de suma
  (``+``).
- **Nivel protegido** — la funcionalidad se otorga sólo a las
  clases que se heredan de la clase original. Antecede con un
  símbolo de número (``#``).
- **Nivel privado** — sólo la clase original puede utilizar el
  atributo u operación. Antecede con un guion (``-``).

Por ejemplo, en una **televisión**: ``modificarVolumen()`` y
``cambiarCanal()`` son operaciones públicas;
``dibujarImagenEnPantalla()`` es privada.

En un **automóvil**: ``acelerar()`` y ``frenar()`` son
operaciones públicas, pero ``actualizarKilometraje()`` es
protegida.

.. tip::

 La realización implica que el nivel **público** se aplique a
 cualquier operación en una interfaz. La protección de
 operaciones mediante cualquiera de los otros niveles tal vez no
 tendría sentido, dado que una interfaz se orienta a ser
 realizada por diversas clases.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Television {
     - circuitos
     - decodificador
     + modificarVolumen()
     + cambiarCanal()
     - dibujarImagenEnPantalla()
   }

   class Automovil {
     - chasis
     # kilometraje : Integer
     + acelerar()
     + frenar()
     # actualizarKilometraje()
   }
   @enduml

----

Ámbito
======

Existen dos tipos de ámbito: el de **instancia** y el de
**archivador**.

.. list-table::
 :widths: 20 40 40
 :header-rows: 1

 * -
   - Ámbito de Instancia
   - Ámbito de Archivador
 * - **Definición**
   - Cada instancia de una clase tiene su propio conjunto de
     valores para los atributos y operaciones. Los valores
     pueden diferir de una instancia a otra.
   - Sólo habrá un único valor para el atributo u operación,
     compartido por todas las instancias de la clase. Cualquier
     cambio se reflejará en todas las instancias.
 * - **Uso**
   - Cuando es necesario que un grupo específico de instancias
     comparta valores exactos de un atributo privado, pero cada
     instancia tiene su propia representación y estado.
   - Cuando se necesita que un atributo u operación tenga un
     único valor compartido. Frecuente para configuraciones,
     constantes o recursos compartidos.
 * - **Ejemplo**
   - Si tienes una clase ``Coche``, cada objeto (``coche1``,
     ``coche2``...) tendrá su propio valor para atributos como
     ``color`` o ``marca``.
   - Si tienes una clase ``Configuracion``, un atributo como
     ``_version`` podría ser común para todas las instancias.

.. note::

 - **Instancia:** cada instancia cuenta con su propio valor en
   un atributo u operación. Es lo más común.
 - **Archivador:** sólo hay un valor del atributo u operación en
   todas las instancias (subrayado en el diagrama).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Coche {
     - color : String
     - marca : String
     {static} - cantidadFabricados : Integer
     --
     + arrancar()
     {static} + obtenerTotalFabricados() : Integer
   }
   note right of Coche
     ``color`` y ``marca`` son
     ámbito de **instancia**
     (uno por objeto).

     ``cantidadFabricados`` es
     ámbito de **archivador**
     (compartido por todos —
     subrayado en el diagrama).
   end note
   @enduml

----

Resumen
=======

- Una **agregación** establece una asociación para conformar un
  todo: una clase "todo" se genera de clases que la componen.
  Un componente en una agregación puede ser parte de **más de un
  todo**.

- Una **composición** es una conformación ligada con la
  agregación: un componente de una composición puede ser parte
  **solamente de un todo**.

- La línea de asociación que une la parte con un todo tiene un
  **rombo**. En agregación el rombo no está relleno; en
  composición sí lo está.

- El **diagrama de contexto** enfoca la atención en una clase
  específica:

  - Un **diagrama de contexto de composición** es como un mapa
    detallado de un mapa mayor — muestra un diagrama de clases
    anidado dentro de un gran símbolo rectangular de clase.
  - Un **diagrama de contexto de sistema** muestra la forma en
    que el diagrama de clases compuestas se relaciona con otros
    objetos del sistema.

- La **realización** es una asociación entre una clase y una
  interfaz.

- Una **interfaz** es una colección de operaciones que cierta
  cantidad de clases podrá utilizar:

  - La interfaz se representa como una clase **sin atributos**.
  - Para distinguirla:

    - el estereotipo ``<<interfaz>>`` aparecerá por encima del
      nombre de la interfaz;
    - otra forma es anteceder el nombre de la interfaz con una
      ``I`` mayúscula.

- La **realización** se representa en UML mediante:

  - una **línea discontinua con una punta de flecha sin
    rellenar** que conecta a la clase con la interfaz;
  - otra forma: una línea continua que conecte a una clase con
    un pequeño círculo (interfaz como *lollipop*).

- **Visibilidad** — todas las operaciones en una interfaz son
  públicas. ``+`` denota pública. Los otros niveles son:

  - **protegida** (la funcionalidad se extiende a las clases
    secundarias) — ``#``
  - **privada** (atributos y operaciones que se pueden utilizar
    sólo dentro de la clase que los contiene) — ``-``

- En un **ámbito de instancia**, cada objeto de una clase cuenta
  con su propio valor en un atributo u operación.

- En el **ámbito de archivador**, sólo hay un valor para un
  atributo u operación en particular a través de un conjunto de
  objetos. Los objetos que no estén en este conjunto no podrán
  acceder al valor contenido en el ámbito de archivador.

----

Preguntas y respuestas
======================

**Si la clase 3 es un componente de la clase 2, y la clase 2 es
un componente de la clase 1, ¿la clase 3 será un componente de
la clase 1?**

Sí — la agregación es **transitiva**. Por ejemplo, los botones y
la bola del ratón son parte del ratón, a la vez que son parte de
la computadora.

**¿La palabra "interfaz" implica "interfaz de usuario" o GUI?**

No. Una interfaz es tan sólo un **conjunto de operaciones** que
una clase presenta a las demás clases. De hecho, una de estas
operaciones podría ser (aunque no necesariamente) la del usuario.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-04-uso-relaciones`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 5 (Schmuller, 2000)
