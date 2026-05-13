.. meta::
 :artefacto: UML_04
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-04:

==============================
UML_04: Uso de relaciones
==============================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 4.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

----

Asociación
==========

Es importante saber cómo se conectan las clases entre sí. Cuando
las clases se conectan entre sí de **forma conceptual**, esta
conexión se conoce como **asociación**.

Por ejemplo: la asociación entre un jugador y un equipo. *"Un
jugador participa en un equipo"*. Se visualizará en UML como una
**línea que conectará a ambas clases**, con el nombre de la
asociación (``"participa en"``) justo sobre la línea.

Dicha línea indicará la dirección de la relación con un
**triángulo relleno** que apunte en la dirección apropiada.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Jugador
   class Equipo
   Jugador --> Equipo : participa en  ▶
   @enduml

.. note::

 Cuando una clase se asocia con otra, cada una de ellas **juega
 un papel dentro de tal asociación**.

Puede representar los papeles en el diagrama escribiéndolos
cerca de la línea de asociación, junto a la clase que juega el
papel correspondiente. Si el equipo es profesional, éste es un
**empleador** y el jugador es un **empleado**.

En el ejemplo, el equipo tiene jugadores a los que contrata para
jugar: el ``Equipo`` juega el rol de **empleador** porque es
quien da el trabajo y paga, los ``Jugadores`` actúan como
**empleados** porque aceptan el trabajo y desempeñan las
funciones asignadas.

.. note:: Relación empleador-empleado

 La *"relación empleador-empleado"* se refiere a una
 **interacción o vínculo** entre dos entidades donde una toma
 el papel de **quien contrata** (empleador) y la otra el papel
 de **quien es contratado** (empleado, que acepta ese trabajo y
 realiza las tareas establecidas por el empleador).

 Es un vínculo formal y de dependencia: una parte tiene
 autoridad para contratar y dar tareas, mientras que la otra
 parte sigue las directrices a cambio de un beneficio.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Equipo
   class Jugador
   Equipo "empleador" --> "empleado" Jugador : contrata
   @enduml

La asociación puede funcionar en dirección inversa: un equipo
emplea a jugadores; si no hay empleado (jugador), el empleador
(equipo) no tiene a quién contratar. Y si no hay empleador, el
empleado no tendría un trabajo. Por lo tanto, **ambos dependen
mutuamente** para que exista la relación de trabajo.

Mostrar ambas asociaciones en el mismo diagrama con un triángulo
relleno que indique la dirección de cada asociación.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Equipo
   class Jugador
   Equipo "empleador" --> "empleado" Jugador : contrata  ▶
   Jugador "empleado" --> "empleador" Equipo : trabaja para  ▶
   @enduml

Cómo identificar una relación inversa / dependencia mutua
---------------------------------------------------------

Debes identificar si existe una **interacción mutua** entre dos
entidades, donde ambas cumplen roles complementarios. Si cada
entidad tiene una función distinta pero interconectada, entonces
la relación puede observarse desde ambos lados.

Una "función distinta pero interconectada" se refiere a que en
una relación entre dos entidades, cada una **hace cosas
diferentes** (funciones distintas), pero ambas funciones están
relacionadas y dependen entre sí para que la relación exista.

Puedes preguntarte:

1. **¿Qué es A y B en su núcleo?**

   - ¿Qué rol o propósito fundamental cumple cada entidad en
     la relación?
   - ¿Qué función cumple cada entidad?
   - La respuesta tiene que ser acciones, como enseñar,
     aprender, dar trabajo, hacer el trabajo, comprar, vender.

2. **¿A puede cumplir su propósito sin B?**

   - ¿Puede cada entidad existir y realizar su función sin la
     otra, o necesita de la otra para tener sentido?
   - Si la respuesta es **no**, entonces no hay dependencia
     mutua.

3. **Si B no existe, ¿A sigue teniendo sentido?**

   - Si una entidad desaparece, ¿cómo afecta esto a la función
     o propósito de la otra?
   - Si una entidad no puede cumplir su rol sin la otra, hay
     dependencia mutua.

4. **¿Qué obtiene A de B y qué obtiene B de A?**

   - ¿Qué contribución o valor esencial proporciona cada
     entidad para mantener la relación?
   - Si no, es una relación dependiente.

5. **¿Ambos dependen de un intercambio necesario?**

   - ¿Es esta interacción una necesidad mutua, donde ambas
     entidades intercambian algo fundamental?
   - Esto refleja que la relación es **bidireccional** y que
     ambas partes dependen una de la otra.

Si descubres que **A y B no pueden cumplir su rol sin la otra**,
o que la relación pierde sentido si una de ellas no está
presente, entonces estás ante una **relación de dependencia
mutua**.

Las asociaciones podrían ser más complejas: **varias clases se
pueden conectar a una**. Los defensas, delanteros y central, así
como sus asociaciones con la clase ``Equipo``:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Equipo
   class Defensa
   class Delantero
   class Central

   Equipo "1" -- "2" Defensa   : tiene
   Equipo "1" -- "2" Delantero : tiene
   Equipo "1" -- "1" Central   : tiene
   @enduml

----

Restricciones en las asociaciones
=================================

En ocasiones una asociación debe seguir cierta regla: esta regla
se indica al establecer una **restricción** junto a la línea de
asociación.

Por ejemplo, un ``Cajero`` atiende a un ``Cliente``, pero cada
``Cliente`` es atendido en el orden en que se encuentre en la
formación. Dicha restricción se puede realizar colocando la
palabra ``ordenado`` entre llaves ``{}`` junto a la clase
``Cliente``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Cajero
   class Cliente
   Cajero "1" -- "0..*" Cliente : atiende
   note bottom of Cliente
     {ordenado}
   end note
   @enduml

Otro tipo de restricción es la relación **OR** (distinguida como
``{Or}``) en una **línea discontinua** que conecte a dos líneas
de asociación. El siguiente diagrama modela a un estudiante de
educación media superior que elegirá entre un curso académico o
uno comercial.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Estudiante
   class CursoAcademico
   class CursoComercial

   Estudiante --> CursoAcademico : se inscribe en
   Estudiante --> CursoComercial : se inscribe en
   CursoAcademico ..> CursoComercial : <<{Or}>>
   @enduml

----

Clases de asociación
====================

Una **clase de asociación** puede contener atributos y
operaciones. Tiene cosas en común para las otras clases: si se
usa con otras clases, éstas tienen los mismos atributos y
operaciones que la clase asociada.

Puede concebir a una clase de asociación de la misma forma en que
lo haría con una clase estándar, y utilizará una **línea
discontinua** para conectarla a la línea de asociación. Una clase
de asociación puede tener asociaciones con otras clases.

Por ejemplo, un ``Jugador`` y un ``Equipo`` tienen un
``Contrato``. Este contrato es el mismo tanto para el jugador
como para el equipo; quien genera el contrato es el director
general. La clase de asociación ``Contrato`` se asocia con la
clase ``DirectorGeneral``, que a su vez se asocia con
``Jugador`` y ``Equipo``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Jugador
   class Equipo
   class Contrato {
     fechaInicio : Date
     duracion : Integer
     monto : Float
   }
   class DirectorGeneral

   Jugador "1" -- "1" Equipo : participa en
   (Jugador, Equipo) .. Contrato
   Contrato -- DirectorGeneral : generado por
   @enduml

----

Vínculos
========

Un **vínculo** es la **instancia de una asociación**. Conecta a
los **objetos** en lugar de las clases.

Así como un objeto es una instancia de una clase, una asociación
también cuenta con instancias.

Si imaginamos a un jugador específico que juega para un equipo
específico, la relación *"participa en"* se conocerá como
**vínculo**. El vínculo se representará como una línea que conecta
a dos objetos. Tal como tuvo que subrayar el nombre de un objeto,
deberá subrayar el nombre de un vínculo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   object "michael : Jugador" as M
   object "bulls : Equipo" as B
   M -- B : participa en
   @enduml

----

Multiplicidad
=============

La **multiplicidad** es la cantidad de objetos de una clase que
se relacionan con un objeto de la clase asociada. Dicha relación
se colocará sobre la línea de asociación junto a la clase
correspondiente.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Equipo
   class Jugador
   Equipo "1" -- "5..*" Jugador : tiene
   @enduml

Hay varios tipos de multiplicidades: uno a uno, uno a muchos, uno
a uno o más, uno a ninguno o uno, uno a un intervalo definido
(por ejemplo: uno a cinco hasta diez), uno a exactamente n, o uno
a un conjunto de opciones (por ejemplo, uno a nueve o diez).

Se utiliza un **asterisco** (``*``) para representar *muchos*.

En un contexto OR se representa por dos puntos, como en
``"1..*"`` (*uno o más*); en otro contexto, OR se representa por
una coma (``,``), como en ``"5, 10"`` (*5 o 10*).

.. tip::

 Cuando la clase ``A`` tiene una multiplicidad de uno a ninguno
 o uno con la clase ``B``, la clase ``B`` se dice que es
 **opcional** para la clase ``A``.

.. list-table:: Tipos de multiplicidad
 :widths: 30 70
 :header-rows: 1

 * - Multiplicidad
   - Significado
 * - ``1 → 1``
   - uno a uno
 * - ``1 → *``
   - uno a muchos
 * - ``1 → 1..*``
   - uno a uno o más (muchos)
 * - ``1 → 0,1``
   - uno a ninguno o uno
 * - ``1 → 12..18``
   - uno a 12 hasta 18
 * - ``1 → 3``
   - uno a tres
 * - ``1 → 12,24``
   - uno a 12 o 24

----

Asociaciones calificadas
========================

En una asociación de uno a muchos, cuando un objeto de una clase
tiene que seleccionar un objeto particular de otro tipo para
cumplir con un papel en la asociación, la primera clase deberá
atenerse a un atributo en particular para localizar al objeto
adecuado. Dicho atributo es un **identificador** — puede ser un
número de identidad. Esa información se conoce como
**calificador**.

Un calificador es una asociación que **resuelve el problema de
la búsqueda de uno a muchos a uno a uno**. El símbolo en UML es
un **pequeño rectángulo** adjunto a la clase que hará la
búsqueda.

Ejemplo: una recepcionista puede obtener una sola reservación
gracias al número de confirmación de dicha reservación.

La idea es **reducir, con eficiencia, la multiplicidad de uno a
muchos a una multiplicidad de uno a uno**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Recepcionista
   class Reservacion
   Recepcionista "1" -[#black]- "(numeroConfirmacion)" Reservacion : busca
   note right of Reservacion
     Multiplicidad efectiva
     reducida a 1:1 mediante
     el calificador
     numeroConfirmacion.
   end note
   @enduml

----

Asociación binaria
==================

Relación que existe entre instancias/objetos de dos clases, donde
los objetos de una clase **existen de forma independiente** a la
existencia de los objetos de la otra clase.

La creación o destrucción de una instancia de la ``Clase A``
implica únicamente la creación o destrucción de la **relación**
que existe entre esa instancia y otra instancia de la ``Clase
B``, pero **nunca** significa la creación o destrucción de la
instancia de la ``Clase B``.

No hay una relación fuerte entre ambas instancias. El objeto de
la ``Clase A`` usa un objeto de la ``Clase B`` y puede que
viceversa también.

En UML esta asociación se representa con una **línea que une
ambas clases**.

**Ejemplo — Las obras de arte y las salas de un museo:**

Imagina un museo que alberga obras de arte. Cada obra de arte
(instancia de la clase ``Artwork``) está expuesta en una sala
del museo (instancia de la clase ``Room``).

Si se destruye una obra de arte (por ejemplo, se quema o se
deteriora), esto **no significa** que destruyamos la sala del
museo, ya que puede haber más obras de arte expuestas en ella.
Lo mismo pasa al revés: si destruimos una sala porque la vamos a
fusionar con otra o vamos a usar su espacio para otra cosa
(``Office``), las obras de arte que alberga no las tenemos que
destruir; en todo caso, las tendremos que reubicar en otras
salas.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Artwork {
     titulo : String
     autor : String
     anio : Integer
   }
   class Room {
     numero : Integer
     planta : Integer
   }
   Artwork "0..*" -- "1" Room : se exhibe en
   @enduml

----

Asociaciones reflexivas
=======================

En ocasiones, una clase tiene una asociación **consigo misma**.
Esto puede ocurrir cuando una clase tiene objetos que pueden
jugar diversos papeles.

Por ejemplo: un ``OcupanteDeAutomovil`` puede ser un
``Conductor`` o un ``Pasajero``. En el papel del conductor, el
``OcupanteDeAutomovil`` puede llevar a ninguno o más
``OcupanteDeAutomovil`` que jugarán el papel de pasajeros. Esto
se representa mediante el trazado de una línea de asociación a
partir del rectángulo de la clase hacia el mismo rectángulo, e
indicando los papeles, el nombre de la asociación, la dirección
y la multiplicidad.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class OcupanteDeAutomovil
   OcupanteDeAutomovil "1\nconductor" -- "0..*\npasajero" OcupanteDeAutomovil : transporta
   @enduml

Una **asociación reflexiva** es una asociación binaria en la que
los objetos que participan en la relación pertenecen a la misma
clase: los objetos origen y destino son de la misma clase.

**Otro ejemplo — El jefe y sus subordinados:**

Piensa en cualquier trabajo: siempre hay un empleado que es jefe
de otros. Tanto el jefe como los trabajadores a su cargo son
empleados. Cada empleado existe independientemente del resto y
un empleado no está formado o compuesto por otros empleados. Las
etiquetas ``<<boss>>`` y ``<<subordinate>>`` se llaman **roles**
y se escriben en los extremos de la asociación para identificar
correcta y semánticamente qué papel juega cada objeto dentro de
la relación.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Empleado
   Empleado "1\n<<boss>>" -- "0..*\n<<subordinate>>" Empleado : supervisa
   @enduml

----

Herencia y generalización
=========================

Si usted conoce algo de una categoría de cosas, automáticamente
sabrá algunas cosas que podrá transferir a otras categorías. A
esto se le conoce como **herencia**; UML también lo denomina
**generalización**.

Una clase (la **clase secundaria** o **subclase**) puede heredar
los atributos y operaciones de otra (la **clase principal** o
**superclase**).

La clase principal (o madre) es más genérica que la secundaria
(o hija). La hija es **sustituible** por la madre: donde quiera
que se haga referencia a la clase madre, también se hace
referencia a la clase hija (en el caso contrario no es
aplicable).

Una clase secundaria puede ser principal para otra clase
secundaria. En UML se coloca un **triángulo sin rellenar** que
apunte a la clase principal — esto se interpreta con la frase
*"es un tipo de"*.

Ejemplo: un ``Mamifero`` es una clase secundaria de ``Animal``,
y ``Caballo`` es una clase secundaria de ``Mamifero``. Un
``Mamifero`` *es un tipo de* ``Animal``, y un ``Caballo`` *es un
tipo de* ``Mamifero``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Animal
   class Mamifero
   class Reptil
   class Ave
   class Caballo
   class Perro
   class Vaca

   Animal <|-- Mamifero
   Animal <|-- Reptil
   Animal <|-- Ave
   Mamifero <|-- Caballo
   Mamifero <|-- Perro
   Mamifero <|-- Vaca
   @enduml

Observe la apariencia del triángulo y las líneas cuando varias
clases secundarias son herencia de una clase principal. También
observe que no se colocaron los atributos y operaciones en las
subclases — esto trae por resultado un diagrama más ordenado.

.. tip::

 Al modelar, se tiene que satisfacer la relación *"es un tipo
 de"* con la clase principal. Si no se cumple, tal vez una
 asociación de otro tipo sea más adecuada.

Las clases secundarias agregan otras operaciones y atributos a
los que han heredado. En el ejemplo anterior, un ``Mamifero``
tiene pelo y da leche — dos atributos que no se encuentran en la
clase ``Animal``.

Una clase puede no provenir de una clase principal, en cuyo caso
será una **clase base** o **clase raíz**. En caso contrario,
una clase podría no tener clases secundarias, en cuyo caso será
una **clase final** o **clase hoja**.

Si una clase tiene exactamente una clase principal, tendrá
**herencia simple**. Si proviene de varias clases principales,
tendrá **herencia múltiple**.

Descubrimiento de la herencia
-----------------------------

El analista deberá darse cuenta de que los atributos y
operaciones de una clase son generales y que se aplicarán a,
quizá, varias clases (mismas que agregarán sus propios atributos
y operaciones).

En el ejemplo del baloncesto de la hora 3
(:doc:`uml-03-uso-orientacion-objetos`):

- El ``Jugador`` tiene atributos como ``nombre``, ``estatura``,
  ``peso``, ``velocidadAlCorrer`` y ``saltoVertical``. Tiene
  operaciones como ``driblar()``, ``pasar()``, ``rebotar()`` y
  ``tirar()``.
- Las clases ``Defensa``, ``Delantero`` y ``Central`` heredarán
  tales atributos y operaciones, y agregarán los suyos:

  - La clase ``Defensa`` podría tener las operaciones
    ``correrAlFrente()`` y ``quitarBalon()``.
  - El ``Central`` podría tener ``retacarBalon()``.

- De acuerdo con los comentarios del entrenador respecto a las
  estaturas, el analista tal vez quisiera colocar
  **restricciones** en las estaturas para cada posición.

- El modelo del baloncesto tiene un ``CronometroDeJuego`` (que
  controla el tiempo restante en un periodo de juego) y un
  ``LapsoDeTiro`` (que controla el tiempo restante desde el
  instante que un equipo tomó posesión del balón). Si nos damos
  cuenta de que **ambos controlan el tiempo**, el analista
  podría formular una clase ``Reloj`` con una operación
  ``controlarTiempo()`` que podrían heredar tanto
  ``CronometroDeJuego`` como ``LapsoDeTiro``.

- Dado que ``LapsoDeTiro`` controla 24 segundos (profesional) o
  35 segundos (colegial) y el ``CronometroDeJuego`` controla 12
  minutos (profesional) o 20 minutos (colegial),
  ``controlarTiempo()`` será **polimórfico**.

----

Clases abstractas
=================

Las clases que **no proveen objetos** se dice que son
**abstractas**. Una clase abstracta se distingue por tener su
nombre en *cursivas*.

Las clases secundarias son importantes en el modelo dado que
finalmente usted querrá tener instancias de tales clases.

En el modelado de baloncesto necesitará instancias de
``Defensa``, ``Delantero``, ``Central``, ``CronometroDeJuego`` y
``LapsoDeTiro``. ``Jugador`` y ``Reloj`` **no proporcionan
ninguna instancia** al modelo. Un objeto de la clase ``Jugador``
no serviría a ningún propósito, así como tampoco uno de la clase
``Reloj``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   abstract class Jugador {
     nombre : String
     estatura : Float
     --
     driblar()
     pasar()
     rebotar()
     tirar()
   }
   class Defensa
   class Delantero
   class Central
   Jugador <|-- Defensa
   Jugador <|-- Delantero
   Jugador <|-- Central

   abstract class Reloj {
     --
     controlarTiempo()
   }
   class CronometroDeJuego
   class LapsoDeTiro
   Reloj <|-- CronometroDeJuego
   Reloj <|-- LapsoDeTiro
   @enduml

----

Dependencias
============

Cuando una clase **utiliza** a otra, a esto se le llama
**dependencia**.

El uso más común de una dependencia es mostrar que la **firma de
la operación** de una clase utiliza a otra clase.

Ejemplo: suponga que diseñará un sistema que muestra formularios
corporativos en pantalla para que los empleados los llenen. El
empleado utiliza un menú para seleccionar el formulario. Hay una
clase ``Sistema`` y una clase ``Formulario``. La clase
``Sistema`` tiene ``mostrarFormulario(f : Form)``; el formulario
que el sistema desplegará dependerá del que elija el usuario.

La notación de UML es una **línea discontinua** con una punta de
flecha en forma de **triángulo sin relleno** que apunta a la
clase de la que depende.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Sistema {
     mostrarFormulario(f : Form)
   }
   class Formulario
   Sistema ..|> Formulario : <<usa>>
   @enduml

----

Resumen
=======

- Las **relaciones** muestran cómo se conectan los términos del
  vocabulario entre sí para dar una idea de la sección del mundo
  que se modela.

- La **asociación** es la conexión conceptual fundamental entre
  clases. Cada clase en una asociación juega un **papel**.

- La **multiplicidad** especifica cuántos objetos de una clase se
  relacionan con un objeto de la clase asociada. Hay muchos tipos
  de multiplicidad.

- Una asociación se representa como una línea entre los
  rectángulos de clases con los papeles y multiplicidades en
  cada extremo. Una asociación puede contener atributos y
  operaciones (**clases de asociación**).

- Una clase puede heredar atributos y operaciones de otra clase.
  La clase heredada es **secundaria** de la clase **principal**
  de la que se hereda. Descubrirá la herencia en su modelo
  inicial cuando tenga atributos y operaciones en común. La
  herencia se representa como una línea entre la clase principal
  y la secundaria, con un **triángulo sin rellenar** que se
  adjunta (y apunta a) la clase principal.

- Las **clases abstractas** sólo se proyectan como bases de
  herencia y no proporcionan objetos.

- En una **dependencia**, una clase utiliza a otra. El uso más
  común es mostrar que una firma en la operación de una clase
  utiliza a otra clase. La dependencia se proyecta como una
  línea discontinua con una punta de flecha en forma de triángulo
  sin relleno que apunta a la clase de la que se depende.

----

Preguntas y respuestas
======================

**¿Se le puede poner nombre a una relación de herencia, como se
hace en una asociación?**

UML no le impide que adjudique un nombre a una relación de
herencia, pero por lo general esto **no es necesario**.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-03-uso-orientacion-objetos`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 4 (Schmuller, 2000)
