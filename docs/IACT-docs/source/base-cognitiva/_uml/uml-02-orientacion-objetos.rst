.. meta::
 :artefacto: UML_02
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-02:

==================================
UML_02: Orientación a objetos
==================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 2.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

----

Introducción
============

La orientación a objetos fomenta una metodología basada en
**componentes** para el desarrollo de software. Primero se
genera un sistema mediante un conjunto de objetos, posteriormente
se podrá ampliar el sistema agregándole funcionalidad a los
componentes que ya había generado, y finalmente podrá volver a
utilizar los objetos que generó para el sistema cuando cree uno
nuevo, con lo cual reducirá sustancialmente el tiempo de
desarrollo.

UML sirve para generar **modelos de objetos fáciles de usar y
comprender** para que los desarrolladores puedan convertirlos en
software.

La orientación a objetos es un **paradigma** que depende de
ciertos principios fundamentales. El software actual simula al
mundo (o un segmento de él), y los programas, por lo general,
imitan a los objetos del mundo.

----

Objetos y clases
================

Un **objeto** es la instancia de una clase (o categoría). Usted
y yo, por ejemplo, somos instancias de la clase ``Persona``. Un
objeto cuenta con una estructura: **atributos** (propiedades) y
**acciones**. Las acciones son todas las actividades que el objeto
es capaz de realizar. Los atributos y acciones, en conjunto, se
conocen como **características** o **rasgos**.

Como objetos de la clase ``Persona``, usted y yo contamos con los
siguientes atributos: altura, peso y edad (puede imaginar muchos
más). También realizamos las siguientes tareas: comer, dormir,
leer, escribir, hablar, trabajar, etcétera.

En el mundo de la orientación a objetos, una clase tiene otro
propósito además de la categorización: es una **plantilla para
fabricar objetos**. Imagínelo como un molde de galletas que
produce muchas galletas.

¿Cuál es la diferencia entre categorías y fabricación?
-------------------------------------------------------

Si en la clase ``Lavadora`` se indica la marca, el modelo, el
número de serie y la capacidad (junto con las acciones de
agregar ropa, agregar detergente y sacar ropa), tendrá un
mecanismo para **fabricar nuevas instancias** a partir de su
clase; es decir, podrá **crear nuevos objetos**.

.. note::

 Los nombres de las clases, como lavadora, se escribirán como
 ``Lavadora``, y si constara de dos palabras se escribiría como
 ``LavadoraIndustrial``. Las características como número de
 serie se escribirán como ``numeroSerie``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     - marca : String
     - modelo : String
     - numeroSerie : String
     - capacidad : Float
     --
     + agregarRopa()
     + agregarDetergente()
     + sacarRopa()
   }

   object "lavadora1 : Lavadora" as l1
   object "lavadora2 : Lavadora" as l2
   object "lavadora3 : Lavadora" as l3

   Lavadora ..> l1 : <<instantiate>>
   Lavadora ..> l2 : <<instantiate>>
   Lavadora ..> l3 : <<instantiate>>
   @enduml

**Las clases en los programas orientados a objetos pueden crear
nuevas instancias.** El propósito de la orientación a objetos es
desarrollar software que refleje (es decir, que modele) un
esquema del mundo.

  **Entre más atributos y acciones tome en cuenta, mayor será
  la similitud de su modelo con la realidad.**

El ejemplo de la lavadora tendrá un modelo más exacto si incluye
los siguientes atributos: ``volumenTambor``, ``cronometroInterno``,
``trampa``, ``motor`` y ``velocidadMotor``. Podría hacerlo más
preciso si incluye las acciones de ``agregarBlanqueador``,
``cronometrarRemojo``, ``cronometrarLavado``, ``cronometrarEnjuague``
y ``cronometrarCentrifugado``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavadora {
     - marca : String
     - modelo : String
     - numeroSerie : String
     - capacidad : Float
     - volumenTambor : Float
     - cronometroInterno : Cronometro
     - trampa : Trampa
     - motor : Motor
     - velocidadMotor : Integer
     --
     + agregarRopa()
     + agregarDetergente()
     + agregarBlanqueador()
     + cronometrarRemojo()
     + cronometrarLavado()
     + cronometrarEnjuague()
     + cronometrarCentrifugado()
     + sacarRopa()
   }
   @enduml

La orientación a objetos se refiere a algo más que tan sólo
atributos y acciones. Dichos aspectos se conocen como
**abstracción**, **herencia**, **polimorfismo**, **encapsulamiento**,
el **envío de mensajes**, las **asociaciones** y la **agregación**.

----

Abstracción
===========

La abstracción se refiere a **quitar las propiedades y acciones
de un objeto** para dejar sólo aquellas que sean necesarias.

Diferentes tipos de problemas requieren distintas cantidades de
información, aun si estos problemas pertenecen a un área en
común.

¿Vale la pena, realmente, agregar todos los atributos y acciones
a una clase?

Valdría la pena si usted pertenece al equipo de desarrollo que
generará finalmente la aplicación que simule con exactitud lo que
hace una lavadora; puede ser muy útil para los ingenieros de
diseño que actualmente estén trabajando en el diseño de una
lavadora.

.. attention::

 Deberá ser tan completo que permita obtener predicciones
 exactas respecto a lo que ocurriría cuando se fabrique la
 lavadora, funcione a toda su capacidad y lave la ropa.

Por otra parte, si va a generar un software que haga un
**seguimiento de las transacciones** en una lavandería que cuente
con diversas lavadoras, posiblemente *no valdrá la pena*.

Con lo que se quedará luego de tomar su decisión respecto a lo
que incluirá o desechará, será una **abstracción**.

----

Herencia
========

Una clase es una categoría de objetos (y en el mundo del
software, una plantilla sirve para crear otros objetos).

Un objeto es una instancia de una clase; como instancia de una
clase, un objeto tiene todas las características de la clase de
la que proviene. A esto se le conoce como **herencia**.

Cada objeto de la clase heredará dichos atributos y operaciones.
Un objeto no sólo hereda de una clase, sino que **una clase
también puede heredar de otra**.

Las lavadoras, refrigeradores, hornos de microondas, tostadores,
lavaplatos, radios, licuadoras y planchas son clases y forman
parte de una **clase más genérica** llamada ``Electrodomestico``.
Un electrodoméstico cuenta con los atributos de ``interruptor`` y
``cableElectrico``, y las operaciones de ``encender()`` y
``apagar()``.

Otra forma de explicarlo es que son **subclases** de la clase.
Decimos que la clase ``Electrodomestico`` es una **superclase** de
todas las demás.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Electrodomestico {
     - interruptor
     - cableElectrico
     + encender()
     + apagar()
   }
   class Lavadora
   class Refrigerador
   class HornoMicroondas
   class Tostador
   class Lavaplatos
   class Radio
   class Licuadora
   class Plancha

   Electrodomestico <|-- Lavadora
   Electrodomestico <|-- Refrigerador
   Electrodomestico <|-- HornoMicroondas
   Electrodomestico <|-- Tostador
   Electrodomestico <|-- Lavaplatos
   Electrodomestico <|-- Radio
   Electrodomestico <|-- Licuadora
   Electrodomestico <|-- Plancha
   @enduml

La herencia no tiene por qué terminar aquí. ``Electrodomestico``
es una subclase de ``ArticulosHogar``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class ArticulosHogar
   class Electrodomestico
   class Mueble
   class Decoracion

   ArticulosHogar <|-- Electrodomestico
   ArticulosHogar <|-- Mueble
   ArticulosHogar <|-- Decoracion

   class Lavadora
   class Refrigerador
   Electrodomestico <|-- Lavadora
   Electrodomestico <|-- Refrigerador
   @enduml

----

Polimorfismo
============

En ocasiones **una operación tiene el mismo nombre en diferentes
clases**. En la orientación a objetos, cada clase "sabe" cómo
realizar tal operación. Esto es el **polimorfismo**.

Una operación puede tener el mismo nombre en diferentes contextos
o clases. El ejemplo de ``abrir`` aplica para muchas cosas: abrir
una puerta, abrir una caja, abrir una ventana — es la misma
acción, pero no se realiza de la misma forma.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Puerta {
     + abrir()
   }
   class Caja {
     + abrir()
   }
   class Ventana {
     + abrir()
   }
   note bottom of Puerta : girar perilla\n+ tirar
   note bottom of Caja   : levantar tapa
   note bottom of Ventana: deslizar marco
   @enduml

Este concepto es importante para los **desarrolladores** de
software: tienen que crear el software que **implemente tales
métodos** en los programas, y deben estar conscientes de
diferencias importantes entre las operaciones que pudieran tener
el mismo nombre.

El polimorfismo también es importante para los **modeladores**:
les **permite hablar con el cliente** (quien está familiarizado
con la sección del mundo que será modelada) en las propias
palabras y terminología del cliente. Las palabras y terminología
del cliente nos conducen a **palabras de acción** (como ``abrir``)
que pueden tener más de un significado.

El polimorfismo permite al modelador mantener tal terminología
sin tener que crear palabras artificiales para sustentar una
unicidad innecesaria de los términos.

----

Encapsulamiento
===============

La esencia del encapsulamiento (o encapsulación) es que cuando un
objeto trae consigo su funcionalidad, esta última **se oculta**.

Por lo general, la mayoría de la gente que ve la televisión no
sabe o no se preocupa de la complejidad electrónica que hay
detrás de la pantalla. La televisión hace lo que tiene que hacer
sin mostrarnos el proceso necesario para ello.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Television {
     - circuitos : Hardware
     - antena : Antena
     - decodificador : Decoder
     --
     + encender()
     + apagar()
     + cambiarCanal(n)
     + ajustarVolumen(n)
   }
   note right of Television
     La complejidad interna
     (circuitos, decodificador,
     antena) está oculta del
     mundo exterior.
   end note
   @enduml

El encapsulamiento permite **reducir el potencial de errores** que
pudieran ocurrir.

En un sistema que consta de objetos, éstos dependen unos de otros
en diversas formas. Si uno de ellos falla y los especialistas de
software tienen que modificarlo de alguna forma, **el ocultar
sus operaciones de otros objetos significará que tal vez no será
necesario modificar los demás objetos**.

El monitor de su computadora, en cierto sentido, oculta sus
operaciones de la CPU. Si algo falla en su monitor, lo reparará o
lo reemplazará; es muy probable que no tenga que reparar o
reemplazar la CPU al mismo tiempo.

Un **objeto oculta lo que hace a otros objetos y al mundo
exterior**, por lo cual al encapsulamiento también se le conoce
como **ocultamiento de la información**.

Un objeto tiene que presentar un "rostro" al mundo exterior para
poder iniciar sus operaciones. Los botones y perillas de la
televisión y de la lavadora se conocen como **interfaces**.

.. note::

 Cuando mencionamos *rostro*, nos referimos a lo que podemos
 "tocar" o acceder para interactuar con la funcionalidad de los
 objetos. Esto es una **interfaz**.

----

Envío de mensajes
=================

Los objetos trabajan en conjunto. Esto se logra mediante el
**envío de mensajes** entre ellos. Un objeto envía a otro un
mensaje para realizar una operación, y el objeto receptor
ejecutará la operación.

Una televisión y su control remoto pueden ser un ejemplo muy
intuitivo del mundo que nos rodea: al presionar el botón de
encendido, le envía literalmente un mensaje al televisor para
que se encienda. Muchas de las cosas que hace mediante el
control remoto, también las podrá hacer si se levanta de la
silla, va a la televisión y presiona los botones correspondientes.

La interfaz que la televisión le presenta (el conjunto de botones
y perillas) no es, obviamente, la misma que le muestra al control
remoto (un receptor de rayos infrarrojos).

  El envío de mensajes se puede hacer por diferentes interfaces.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Persona
   participant ControlRemoto
   participant Television

   Persona        -> ControlRemoto : presionar botón
   ControlRemoto  -> Television    : señal IR (encender)
   Persona        -> Television    : presionar perilla\n(interfaz física)
   @enduml

----

Asociaciones
============

Otro acontecimiento común es que **los objetos se relacionan
entre sí de alguna forma**.

La asociación "encendido" es en **una sola dirección (una vía)**:
usted enciende la televisión.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Persona
   class Television
   Persona --> Television : enciende
   @enduml

Hay otras asociaciones que son en **dos direcciones**, como
"casamiento".

En ocasiones, un objeto podría asociarse con otro en más de una
forma. Si usted y su colaborador son amigos, ello servirá de
ejemplo. Usted tendría una asociación "es amigo de", así como
"es colaborador de".

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Persona
   Persona "1" -- "1" Persona : es amigo de
   Persona "1" -- "1" Persona : es colaborador de
   @enduml

**Una clase se puede asociar con más de una clase distinta.** Una
persona puede viajar en automóvil, pero también puede hacerlo en
autobús.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Persona
   class Automovil
   class Autobus
   Persona -- Automovil : viaja en
   Persona -- Autobus   : viaja en
   @enduml

----

La multiplicidad (o diversificación)
====================================

Indica la **cantidad de objetos** de una clase que se relacionan
con otro objeto en particular de la clase asociada.

Por ejemplo, en un curso escolar, el curso se imparte por un solo
instructor; en consecuencia, el curso y el instructor están en
una **asociación de uno a uno**. Sin embargo, en un seminario hay
diversos instructores que impartirán el curso a lo largo del
semestre, por lo tanto, el curso y el instructor tienen una
**asociación de uno a muchos**.

Podrá encontrar todo tipo de multiplicidades si echa una mirada a
su alrededor: una bicicleta rueda en dos neumáticos
(**multiplicidad de uno a dos**), un triciclo rueda en tres, y un
vehículo de 18 ruedas tiene **multiplicidad de uno a 18**.

----

Agregación
==========

Vea su computadora: cuenta con un gabinete, un teclado, un
ratón, un monitor, una unidad de CD-ROM, uno o varios discos
duros y otros elementos sin los que difícilmente podría vivir.

Su computadora es **una agregación o adición**, otro tipo de
asociación entre objetos. Su equipo está constituido de diversos
tipos de componentes.

.. warning::

 **¿Qué es una agregación?**

 Es un objeto que se construye de diversos tipos de objetos. Los
 componentes son **independientes** del objeto agregado. Pueden
 existir sin estar necesariamente asociados al compuesto y
 tienen una vida útil propia.

 Ejemplo: el objeto **libreta** se construye de los objetos
 *espiral*, *pasta*, *hojas*, etc.

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

Composición
-----------

Un tipo de agregación **trae consigo una estrecha relación entre
un objeto agregado y sus objetos componentes**. A esto se le
conoce como **composición**.

.. warning::

 **Composición**

 Un objeto más complejo (llamado **compuesto**) se compone de uno
 o más objetos más pequeños (**componentes**). La composición es
 una relación fuerte, en la que los **componentes no tienen
 sentido** por sí solos sin el objeto compuesto. Los componentes
 **dependen completamente** del objeto compuesto. No pueden
 existir de manera independiente fuera de este.

El punto central de la composición es que el componente se
considera como tal sólo como parte del objeto compuesto. El
concepto clave: **la vida del componente está ligada a la vida
del objeto compuesto**.

Por ejemplo: una camisa está compuesta de cuerpo, cuello, mangas,
botones, ojales y puños. Suprima la camisa y el cuello será
inútil.

En ocasiones, un objeto compuesto no tiene el mismo tiempo de
vida que sus propios componentes. Las hojas de un árbol pueden
morir antes que el árbol; si destruye al árbol, también las
hojas morirán.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Camisa
   class Cuerpo
   class Cuello
   class Manga
   class Boton
   class Ojal
   class Puno

   Camisa *-- Cuerpo
   Camisa *-- Cuello
   Camisa *-- "2" Manga
   Camisa *-- "1..*" Boton
   Camisa *-- "1..*" Ojal
   Camisa *-- "2" Puno

   class Arbol
   class Hoja
   Arbol *-- "0..*" Hoja
   note right of Hoja
     Las hojas pueden morir
     antes que el árbol;
     si el árbol muere, también
     mueren las hojas.
   end note
   @enduml

----

Entender la relación entre los objetos
======================================

Comprender cómo deben interactuar los objetos y cuál es la vida
útil esperada de cada uno requiere preguntas guiadas.

Preguntas para hacerse a uno mismo
----------------------------------

- ¿Los componentes deben existir solo como parte del objeto
  compuesto?

  - Ejemplo: ¿Una habitación puede existir fuera de una casa, o
    solo tiene sentido dentro de la casa?

- ¿Qué sucede con los componentes cuando el objeto compuesto es
  destruido?

  - Si el objeto principal se destruye, ¿deberían destruirse
    también los componentes o pueden seguir existiendo?

- ¿Cuál es la relación jerárquica entre el objeto compuesto y sus
  componentes?

  - ¿Los componentes son esenciales para el funcionamiento del
    compuesto o pueden operar independientemente?

- ¿El ciclo de vida de los componentes está completamente ligado
  al objeto compuesto?

  - ¿Los componentes pueden existir antes o después del ciclo de
    vida del objeto compuesto?

- ¿Es importante mantener la independencia de los componentes
  para su reutilización en otros contextos?

  - Si los componentes van a ser reutilizados en diferentes
    partes del sistema, ¿deberían ser modelados como agregación
    en lugar de composición?

- ¿El componente es parte integral del objeto principal o puede
  funcionar de forma independiente?

  - Ejemplo: ¿Una pieza de maquinaria es parte de una máquina en
    particular o puede moverse entre diferentes máquinas?

- ¿Cómo ves la relación entre las partes y el todo en este
  sistema?

  - Por ejemplo, si estamos hablando de un vehículo, ¿cada una de
    sus piezas siempre estará asociada a un solo vehículo o
    podrían ser usadas en otros vehículos?

- ¿Qué sucede con los componentes si el objeto principal deja de
  existir?

  - Si un objeto compuesto se elimina o deja de ser relevante en
    el sistema, ¿los componentes también deben eliminarse
    automáticamente o siguen siendo útiles por sí mismos?

- ¿Qué sucede con los elementos individuales cuando el todo ya no
  está disponible?

  - Si hablamos de un departamento en una empresa, ¿qué sucede
    con los empleados cuando ese departamento se cierra?

- ¿Los componentes del sistema deben ser reutilizables en otros
  contextos?

  - ¿El cliente desea que los componentes puedan utilizarse en
    diferentes sistemas o escenarios, o solo tienen sentido en el
    contexto actual del objeto compuesto?

- ¿El sistema requiere una relación estricta y fuerte entre los
  componentes y el objeto principal, o una relación más flexible?

  - ¿Los componentes y el objeto principal tienen una relación de
    dependencia fuerte, o pueden cambiar y adaptarse fácilmente
    sin que el sistema se vea afectado?

- ¿Qué sucede si un componente desaparece o se elimina antes de
  que el objeto principal deje de existir?

  - ¿Es aceptable que ciertos componentes desaparezcan o sean
    eliminados antes que el objeto principal, o deben coexistir
    siempre hasta el final?

- ¿Qué pasa si un elemento deja de funcionar o se elimina antes
  de que el conjunto completo termine su vida útil?

  - Si un empleado se va antes de que un proyecto esté terminado,
    ¿cómo impacta eso el trabajo del resto del equipo o el
    proyecto en sí?

- ¿Cómo se debe gestionar la vida útil de los componentes en
  relación con el objeto principal?

  - ¿El cliente espera que los componentes sean gestionados por
    el sistema de manera independiente o como una parte integral
    del compuesto?

- ¿Qué tan interdependientes son estos elementos entre sí?

  - En términos prácticos, si una parte del sistema cambia o se
    elimina, ¿quieres que el resto siga funcionando igual, o se
    vería afectado de inmediato?

- Si el todo deja de existir, ¿quieres que los componentes
  puedan seguir funcionando?

  - Por ejemplo, si cerramos una tienda, ¿los empleados se
    trasladan a otras tiendas o se terminan todos los contratos?

Preguntas para hacerle al cliente
---------------------------------

Las preguntas que se hacen al cliente deben ser claras y
orientadas al negocio, evitando tecnicismos. La pregunta debe ser
más directa y específica.

Las preguntas al cliente te permiten entender las **expectativas
funcionales** del sistema y cómo los componentes deben
comportarse dentro del ciclo de vida del objeto principal.

**1. ¿Cada parte de este sistema solo existe como parte del
conjunto, o podría funcionar o ser útil por sí sola, fuera del
sistema principal?**

Este enfoque clarifica si las partes (componentes) dependen por
completo del objeto principal (el todo) o si pueden existir y
funcionar de manera independiente.

Ejemplos:

- Tienda en línea: "¿Los productos solo se gestionan dentro de
  esta tienda, o podrían ser vendidos también en otras tiendas o
  plataformas?"
- Proyecto de software: "¿Los módulos de este sistema solo sirven
  para esta aplicación, o podrían ser reutilizados en otras
  aplicaciones?"

**2. Si el sistema principal deja de funcionar o ser necesario,
¿qué pasa con las partes que lo componen? ¿Siguen siendo útiles
o deben desaparecer también?**

Esta pregunta busca clarificar la vida útil de los componentes
cuando el sistema principal ya no está disponible, ayudando a
distinguir si se trata de una relación fuerte (composición) o más
flexible (agregación).

Ejemplos:

- Gestión de empleados: "Si un departamento de la empresa se
  cierra, ¿los empleados de ese departamento pueden ser
  reasignados a otros departamentos, o su trabajo depende
  completamente de ese departamento?"
- Sistema de inventario: "Si se elimina un almacén, ¿los
  productos de ese almacén se pueden trasladar a otro lugar, o
  solo tienen sentido dentro de ese almacén?"

**3. ¿Es importante que las diferentes partes de este sistema se
puedan usar en otros sistemas o proyectos, o solo tienen sentido
dentro de este sistema específico?**

Esta pregunta te ayuda a comprender si el cliente espera
**reutilización y flexibilidad** de los componentes, lo que
indicaría una relación de agregación.

Ejemplos:

- Sistema de software: "¿Los módulos o funcionalidades de esta
  aplicación se deben poder usar en otras aplicaciones que tengan
  necesidades similares?"
- Gestión de productos: "¿Los datos o procesos que usamos para
  un producto podrían aplicarse también a otros sistemas o solo
  funcionan dentro del entorno actual?"

**4. ¿Quieres que las partes de este sistema puedan ser usadas en
otros sistemas o proyectos futuros, o solo tienen utilidad en
este sistema específico?**

Facilita que el cliente piense en términos de reutilización o si
las partes del sistema tienen una utilidad exclusiva dentro del
contexto actual.

**5. ¿Es posible que algunas partes del sistema dejen de
funcionar o sean eliminadas antes de que el sistema completo
termine su ciclo de vida, o deben mantenerse hasta el final junto
con el sistema principal?**

Determina si algunos componentes pueden ser eliminados o
inactivados antes que el sistema principal — clave para entender
si la relación es de agregación (más flexibilidad) o de
composición (interdependencia más estricta).

**6. ¿Quieres que las partes del sistema tengan el mismo tiempo
de vida que el sistema principal, o pueden ser reemplazadas o
eliminadas de forma independiente?**

Aclara si los componentes deben ser gestionados de forma
independiente o si su vida útil está estrictamente ligada al
sistema principal.

**7. ¿Las partes del sistema solo tienen sentido si están dentro
del sistema completo, o pueden existir y funcionar por separado?**

Determina si los componentes son completamente dependientes del
objeto compuesto (composición) o si pueden existir y funcionar
independientemente (agregación).

**8. ¿El sistema principal controla completamente a sus partes, o
las partes pueden funcionar de manera más independiente y
autónoma?**

Determina si existe una dependencia fuerte (composición) o cierto
grado de independencia (agregación).

**9. ¿Las partes del sistema deben seguir funcionando solo
mientras el sistema principal esté activo, o pueden seguir
funcionando incluso si el sistema principal ya no está?**

Esclarece si el ciclo de vida de los componentes depende
completamente del objeto principal (composición) o si los
componentes pueden seguir existiendo o funcionando
independientemente (agregación).

----

La recompensa
=============

Los objetos y sus asociaciones conforman la **columna vertebral
de la funcionalidad** de los sistemas. Para modelarlos, necesitará
comprender lo que son las asociaciones.

Las asociaciones son relaciones que permiten a los objetos
interactuar en un sistema orientado a objetos. Estas relaciones
son esenciales para modelar la funcionalidad y las interacciones
en un sistema.

La asociación es una relación entre dos o más clases que permite
que los objetos de esas clases interactúen. Esta relación es
fundamental para modelar cómo se comunican y colaboran los
diferentes objetos dentro de un sistema orientado a objetos. Las
asociaciones pueden ser de diferentes tipos, dependiendo de la
naturaleza de la relación entre los objetos.

Tipos de asociaciones
---------------------

**Cardinalidad** — Especifica cuántos objetos pueden participar
en una asociación. Esto puede variar de uno a uno, uno a muchos o
muchos a muchos, y es fundamental para definir la cantidad de
interacciones posibles entre objetos en un sistema. **Define
cuántos objetos pueden participar en la asociación.**

**Asociación Unidireccional** — En esta relación, un objeto
conoce a otro, pero el segundo objeto no tiene conocimiento del
primero. Se puede pensar como una conexión en una sola dirección.
**Solo un objeto conoce al otro.**

Ejemplos:

- Un profesor enseña a un estudiante.
- Un objeto ``Cliente`` tiene un ``Pedido``. El ``Pedido`` no
  necesita saber quién es el ``Cliente``.
- ``Cliente → Pedido`` (el cliente conoce el pedido, pero el
  pedido no conoce al cliente).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Cliente
   class Pedido
   Cliente --> Pedido : tiene
   @enduml

**Agregación** — Representa una relación "todo/parte", donde la
parte puede existir independientemente del todo. La vida de la
parte no está controlada por el todo. **Relación en la que un
objeto es parte de otro, pero ambos pueden existir de forma
independiente.**

Características:

- Las partes pueden ser compartidas por múltiples "todo".
- El ciclo de vida de las partes no está ligado al del todo.
- Se conoce como una relación de **"parte-todo"**.

Ejemplos:

- "Un coche tiene llantas". Si el coche es destruido, las llantas
  pueden existir por separado.
- ``Biblioteca ⟶ Libro`` (la biblioteca puede tener libros, pero
  los libros pueden existir independientemente de la biblioteca).
- **Universidad y Estudiantes:** una universidad tiene
  estudiantes, pero los estudiantes pueden existir sin la
  universidad.
- **Equipo de Fútbol y Jugadores:** un equipo está compuesto por
  jugadores, pero los jugadores pueden jugar en otros equipos.
- **Carro y Componentes:** un carro está compuesto por motor,
  ruedas y asientos, pero estos componentes pueden existir
  independientemente del carro.
- **Casa y Habitaciones:** una casa está formada por varias
  habitaciones, pero cada habitación puede ser parte de otra casa
  o existir como unidad independiente.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Biblioteca
   class Libro
   Biblioteca o-- "0..*" Libro
   @enduml

**Composición** — Es un tipo más fuerte de agregación donde la
parte no puede existir sin el todo. Si el todo es destruido,
también lo son sus partes. **Relación en la que un objeto depende
completamente de otro para existir.**

Características:

- Si el "todo" se destruye, las partes también lo hacen.
- Relación de propiedad exclusiva.
- El ciclo de vida de las partes está estrictamente ligado al
  ciclo de vida del todo.

Ejemplos:

- Un objeto ``Casa`` y un objeto ``Habitacion``. Una habitación
  no tiene sentido fuera de la casa.
- "Una casa tiene habitaciones". Si la casa es destruida, las
  habitaciones también dejan de existir.
- ``Equipo ⟶ Miembro`` (si el equipo es destruido, también lo son
  sus miembros, en el contexto del equipo específico).
- Un libro y sus capítulos: si el libro deja de existir, los
  capítulos también desaparecen.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Casa
   class Habitacion
   Casa *-- "1..*" Habitacion
   @enduml

**Dependencia** — Relación temporal en la que un objeto depende
de otro para realizar una tarea o función específica, pero la
relación no es permanente. **Relación temporal entre objetos,
donde uno depende del otro para realizar una tarea.**

Características:

- Es una relación temporal donde un objeto depende de otro para
  realizar una tarea específica.
- No implica propiedad.
- Cuando un objeto utiliza o invoca un servicio de otro objeto,
  la relación se da en el momento en que el objeto dependiente
  necesita al proveedor para realizar su función.
- Es una relación débil y temporal.
- Cuando un objeto se ve afectado por un cambio en otro objeto:
  cualquier modificación en el objeto proveedor puede impactar al
  objeto dependiente.
- Esta relación es menos formal y más efímera que las otras
  asociaciones.

Ejemplos:

- **Cliente y Pedido:** un cliente hace un pedido a una tienda;
  el cliente depende del sistema de pedidos para completar la
  acción.
- **Usuario y Aplicación:** un usuario utiliza una aplicación
  para obtener información; la aplicación es necesaria para que
  el usuario acceda a esa información.
- **Cliente y Catálogo de Productos:** si el catálogo de productos
  se actualiza, el cliente puede ver diferentes opciones
  disponibles.
- **Sistema de Notificaciones y Configuración de Usuario:** si un
  usuario cambia sus preferencias de notificación, el sistema de
  notificaciones depende de esos cambios para funcionar
  correctamente.
- **Interfaz y Clase Concreta:** una clase concreta implementa
  una interfaz; si la interfaz cambia, la clase concreta puede
  verse afectada.
- **Módulos de Sistema y Bibliotecas Externas:** un módulo de
  software puede depender de una biblioteca externa para funciones
  específicas; cambios en la biblioteca pueden afectar el módulo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Cliente
   class CatalogoProductos
   Cliente ..> CatalogoProductos : <<usa>>
   @enduml

**Herencia (Generalización)** — Relación jerárquica entre clases
en la que una clase (subclase o clase derivada) hereda atributos
y comportamientos de otra clase (superclase o clase base). Esta
relación permite **reutilizar el código** y crear una estructura
de clases más organizada y comprensible.

Características:

- **Herencia Simple:** una clase hereda de una sola superclase,
  manteniendo una estructura jerárquica simple.
- **Herencia Múltiple:** una clase puede heredar de múltiples
  superclases. Esto permite combinar características de diferentes
  clases, pero puede complicar la jerarquía y la resolución de
  conflictos.
- **Herencia Jerárquica:** varias clases derivadas heredan de una
  sola superclase, formando una estructura jerárquica donde una
  clase base tiene múltiples subclases.

Ejemplos:

- **Animal y Perro:** la clase ``Perro`` hereda de la clase
  ``Animal``, adquiriendo sus atributos y métodos.
- **Animal y Perro, Gato:** la clase ``Animal`` tiene dos
  subclases (``Perro`` y ``Gato``), cada una heredando de
  ``Animal``.
- **Vehículo y Coche:** la clase ``Coche`` hereda de la clase
  ``Vehiculo``.
- **Ave y Volador:** la clase ``Pajaro`` puede heredar de ``Ave``
  y de ``Volador`` (herencia múltiple).
- **Estudiante y Trabajador:** la clase ``EstudianteTrabajador``
  hereda de las clases ``Estudiante`` y ``Trabajador``,
  combinando las características de ambas.
- **Vehículo y Coche, Motocicleta:** la clase ``Vehiculo`` tiene
  subclases ``Coche`` y ``Motocicleta``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Animal
   class Perro
   class Gato
   Animal <|-- Perro
   Animal <|-- Gato
   @enduml

**Cardinalidad (o Multiplicidad)** — Define **cuántos objetos**
pueden participar en la asociación.

Se puede definir como:

- **Uno a uno (1:1):** un objeto A está relacionado con un solo
  objeto B. Ejemplo: "Un pasaporte pertenece a una persona".
- **Uno a muchos (1:\*):** un objeto A puede estar relacionado
  con muchos objetos B. Ejemplo: "Un profesor enseña a muchos
  estudiantes".
- **Muchos a muchos (\*:\*):** muchos objetos A pueden estar
  relacionados con muchos objetos B. Ejemplo: "Un autor puede
  escribir varios libros, y un libro puede tener varios autores".

**Asociación Bidireccional** — Ambos objetos son conscientes de
la relación y pueden interactuar entre sí. Cada objeto conoce al
otro. **Ambos objetos se conocen y pueden interactuar.**

Ejemplos:

- Un objeto ``Profesor`` y un objeto ``Curso``. Un ``Curso``
  conoce a su ``Profesor`` y viceversa.
- Una persona posee un automóvil.
- ``Profesor ↔ Curso`` (ambos objetos se conocen y pueden
  interactuar).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Profesor
   class Curso
   Profesor "1" -- "1..*" Curso
   @enduml

**Asociación Binaria** — Relación entre exactamente dos objetos.

Ejemplos:

- **Cliente y Pedido:** un cliente puede realizar múltiples
  pedidos, pero un pedido pertenece a un solo cliente.
- **Estudiante y Curso:** un estudiante puede estar inscrito en
  varios cursos, pero un curso puede tener muchos estudiantes.

**Asociación Unaria** — Relación de un objeto consigo mismo.

Ejemplos:

- **Empleado y Supervisor:** un empleado puede supervisar a otros
  empleados.
- **Árbol y Rama:** una rama puede tener subramas, que también son
  ramas.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Empleado
   Empleado "1" -- "0..*" Empleado : supervisa
   @enduml

**Asociación N-aria** — Relación entre tres o más objetos.

Ejemplos:

- **Proyecto, Empleado y Rol:** un proyecto puede involucrar a
  múltiples empleados, cada uno con un rol específico en el
  proyecto.
- **Pedido, Producto y Cantidad:** un pedido puede incluir varios
  productos, y cada producto puede tener una cantidad específica
  en ese pedido.

----

Resumen
=======

Un objeto es una instancia de una clase. Una clase es una
categoría genérica de objetos que tienen los mismos atributos y
acciones. Cuando crea un objeto, el área del problema en que
trabaje determinará cuántos de los atributos y acciones debe
tomar en cuenta.

La **herencia** es un aspecto importante de la orientación a
objetos: un objeto hereda los atributos y operaciones de su
clase. Una clase también puede heredar atributos y acciones de
otra.

El **polimorfismo** es otro aspecto importante: especifica que
una acción puede tener el mismo nombre en diferentes clases y
cada clase ejecutará tal operación de forma distinta.

Los objetos **ocultan su funcionalidad** de otros objetos y del
mundo exterior. Cada objeto presenta una **interfaz** para que
otros objetos (y personas) puedan aprovechar su funcionalidad.

Los objetos funcionan en conjunto mediante el **envío de mensajes**
entre ellos. Los mensajes son peticiones para realizar
operaciones.

Por lo general, los objetos se **asocian** entre sí y esta
asociación puede ser de diversos tipos. Un objeto en una clase
puede asociarse con cualquier cantidad de objetos distintos en
otra clase.

La **agregación** es un tipo de asociación. Un objeto agregado
consta de un conjunto de objetos que lo componen, y una
**composición** es un tipo especial de agregación. En un objeto
compuesto, los componentes sólo existen como parte del objeto
compuesto.

----

Cuestionario
============

1. **¿Qué es un objeto?**

   Es una instancia de una clase.

2. **¿Cómo trabajan los objetos en conjunto?**

   Mediante el **envío de mensajes** (no por herencia — la
   herencia es la relación entre clases, no la forma en que los
   objetos cooperan en runtime).

3. **¿Qué establece la multiplicidad?**

   La **cardinalidad** de los objetos: cuántos objetos de una
   clase se relacionan con otro objeto en particular de la clase
   asociada.

4. **¿Pueden asociarse dos objetos entre sí en más de una
   manera?**

   Sí. Por ejemplo, dos personas pueden estar asociadas como
   "es amigo de" y "es colaborador de" simultáneamente.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-01-introduccion`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 2 (Schmuller, 2000)
