.. meta::
 :artefacto: UML_01
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-01:

============================
UML_01: Introducción al UML
============================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 1.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto (per
 :doc:`/base-cognitiva/plantuml-guide/guidelines`).

----

Diagrama de clases
==================

Una clase es una categoría o grupo de cosas que tienen atributos y
acciones similares. Podríamos imaginar cada una de esas acciones
como un conjunto de tareas.

La clase **Lavadora** tiene atributos como son la marca, el
modelo, el número de serie y la capacidad. Entre las acciones de
las cosas de esta clase se encuentran: *agregar ropa*, *agregar
detergente*, *activarse* y *sacar ropa*.

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
     + activarse()
     + sacarRopa()
   }
   @enduml

----

Diagrama de objetos
===================

Un objeto es una **instancia de clase** (una entidad que tiene
valores específicos de los atributos y acciones).

Su lavadora, por ejemplo, podría tener la marca *Laundatorium*,
el modelo *Washmeister*, el número de serie *GL57774* y una
capacidad de 7 Kg.

El nombre de la instancia específica se encuentra a la izquierda
de los dos puntos (``:``), y el nombre de la clase a la derecha.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   object "miLavadora : Lavadora" as ml {
     marca = "Laundatorium"
     modelo = "Washmeister"
     numeroSerie = "GL57774"
     capacidad = 7.0
   }
   @enduml

----

Diagrama de casos de uso
========================

Un **caso de uso** es una descripción de las acciones de un
sistema desde el punto de vista del usuario; es una técnica de
aciertos y errores para obtener los requerimientos del sistema
desde el punto de vista del usuario.

A la figura correspondiente al *Usuario de la lavadora* se le
conoce como **actor**. La elipse representa el caso de uso. El
actor (la entidad que inicia el caso de uso) puede ser una persona
u otro sistema.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor "Usuario de la lavadora" as Usuario
   rectangle "Lavadora" {
     usecase "Lavar ropa" as UC1
     usecase "Agregar detergente" as UC2
     usecase "Sacar ropa" as UC3
   }
   Usuario --> UC1
   Usuario --> UC2
   Usuario --> UC3
   @enduml

----

Diagrama de estados
===================

En cualquier momento, un objeto se encuentra en un **estado en
particular**.

Una lavadora podrá estar en la fase de *remojo*, *lavado*,
*enjuague*, *centrifugado* o *apagada*.

El símbolo que está en la parte superior de la figura representa
el **estado inicial** y el de la parte inferior el **estado
final**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Remojo
   Remojo --> Lavado
   Lavado --> Enjuague
   Enjuague --> Centrifugado
   Centrifugado --> Apagada
   Apagada --> [*]
   @enduml

.. warning::

 **Nota:** Los diagramas de clases y los de objetos representan
 información **estática**. Los diagramas de estados, secuencias,
 actividades y colaboraciones representan información **dinámica**
 (cambio progresivo en el tiempo).

----

Diagrama de secuencias
======================

El diagrama de secuencias UML muestra la mecánica de la
**interacción con base en tiempos**.

Entre los componentes de la lavadora se encuentran: una
**manguera de agua** (para obtener agua fresca), un **tambor**
(donde se coloca la ropa) y un **sistema de drenaje**. Por
supuesto, estos también son objetos (un objeto puede estar
conformado por otros objetos).

¿Qué sucederá cuando invoque al caso de uso *Lavar ropa*?

Si damos por hecho que están completas las operaciones *agregar
ropa*, *agregar detergente* y *activar*, la secuencia sería más
o menos así:

1. El agua empezará a llenar el tambor mediante una manguera.
2. El tambor permanecerá inactivo durante cinco minutos.
3. La manguera dejará de abastecer agua.
4. El tambor girará de un lado a otro durante quince minutos.
5. El agua jabonosa saldrá por el drenaje.
6. Comenzará nuevamente el abastecimiento de agua.
7. El tambor continuará girando.
8. El abastecimiento de agua se detendrá.
9. El agua del enjuague saldrá por el drenaje.
10. El tambor girará en una sola dirección y se incrementará su
    velocidad por cinco minutos.
11. El tambor dejará de girar y el proceso de lavado habrá
    finalizado.

El diagrama de secuencias captura las interacciones que se
realizan a través del tiempo entre el abastecimiento de agua, el
tambor y el drenaje (representados como rectángulos en la parte
superior del diagrama). El tiempo se da de arriba hacia abajo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant "Manguera\nde agua" as M
   participant "Tambor" as T
   participant "Drenaje" as D

   M -> T : abrir agua
   note right of T : reposar 5 min
   M -> T : cerrar agua
   T -> T : girar 15 min
   T -> D : descargar agua jabonosa
   M -> T : abrir agua (enjuague)
   T -> T : girar
   M -> T : cerrar agua
   T -> D : descargar agua de enjuague
   T -> T : centrifugar 5 min
   T -> T : detenerse
   @enduml

Volviendo a las ideas acerca de los estados, podríamos
caracterizar:

- Los pasos 1 y 2 como el estado de **remojo**.
- Los pasos 3 y 4 como el estado de **lavado**.
- Los pasos 5 a 7 como el estado de **enjuague**.
- Los pasos 8 al 10 como el estado de **centrifugado**.

----

Diagrama de actividades
=======================

Las actividades que ocurren dentro de un caso de uso o dentro del
comportamiento de un objeto se dan, normalmente, en **secuencia**.

A continuación se representan los pasos del 4 al 6 de la
secuencia anterior con el diagrama de actividades UML.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Tambor gira de un lado a otro\n(15 min);
   :Drenar agua jabonosa;
   :Abrir abastecimiento de agua;
   stop
   @enduml

----

Diagrama de colaboraciones
==========================

Los elementos de un sistema trabajan en conjunto para cumplir con
los **objetivos del sistema**. El diagrama de colaboraciones UML
está diseñado con este fin.

Este ejemplo agrega un **cronómetro interno** al conjunto de
clases que constituyen a una lavadora. Luego de cierto tiempo, el
cronómetro detendrá el flujo de agua y el tambor comenzará a
girar de un lado a otro.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   object Cronometro
   object Manguera
   object Tambor

   Cronometro "1" -- "1" Manguera : controla
   Cronometro "1" -- "1" Tambor   : activa
   Manguera   "1" -- "1" Tambor   : llena
   @enduml

----

Diagrama de componentes
=======================

El moderno desarrollo de software se realiza mediante
**componentes**, lo que es particularmente importante en los
procesos de desarrollo en equipo.

A continuación, la manera en que UML representa un componente de
software.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "Controlador\nde Lavado" as C {
     [Lógica de Ciclo]
     [Sensor de Carga]
   }
   @enduml

----

Diagrama de distribución
========================

Muestra la **arquitectura física** de un sistema informático;
puede representar los equipos y dispositivos, mostrar sus
interconexiones y el software que se encontrará en cada máquina.

Cada computadora está representada por un cubo y las
interacciones entre las computadoras están representadas por
líneas que conectan a los cubos.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "Servidor de Aplicación" as App {
     component [Backend API]
   }
   node "Servidor de BD" as DB {
     database "PostgreSQL"
   }
   node "Cliente" as Web {
     component [Navegador Web]
   }
   Web --> App : HTTPS
   App --> DB  : SQL
   @enduml

----

Otras características
=====================

UML proporciona características que le permiten **organizar y
extender** los diagramas.

Paquetes
--------

Sirven para organizar los elementos de un diagrama en un grupo.
Tal vez quiera mostrar que ciertas clases o componentes son parte
de un subsistema en particular.

Los agruparía en un **paquete**, que se representa por una
carpeta tabulada.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   package "Subsistema Lavado" {
     class Tambor
     class Manguera
     class Drenaje
   }
   @enduml

Notas
-----

Es frecuente que alguna parte del diagrama no presente una clara
explicación del porqué está allí o la manera en que trabaja.
Cuando este sea el caso, la **nota UML** será útil.

La nota es un rectángulo con una esquina doblada, y dentro del
rectángulo se coloca la explicación. Se adjunta al elemento del
diagrama mediante una línea discontinua.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Tambor {
     - capacidad : Float
     + girar()
   }
   note right of Tambor
     El tambor gira en
     ambos sentidos durante
     el ciclo de lavado.
   end note
   @enduml

Estereotipos
------------

De vez en cuando se diseña un sistema que requiere algunos
elementos hechos a la medida. Los **estereotipos** o *clics* le
permiten tomar elementos propios del UML y convertirlos en otros.

Imagine a un estereotipo como una alteración. Se representa como
un nombre entre dos pares de paréntesis angulares (``«…»``) y
después se aplica al elemento.

El concepto de una **interfaz** provee un buen ejemplo. Una
interfaz es una clase que realiza operaciones y que no tiene
atributos; es un conjunto de acciones que tal vez quiera utilizar
una y otra vez en su modelo. En lugar de inventar un nuevo
elemento, podrá utilizar el símbolo de una clase con
``«Interfaz»`` situada justo sobre el nombre de la clase.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Lavable <<Interfaz>> {
     + iniciarCiclo()
     + detenerCiclo()
     + obtenerEstado()
   }
   class Lavadora
   Lavadora ..|> Lavable
   @enduml

----

¿Para qué tantos diagramas?
===========================

Es importante recalcar que en un modelo UML **no es necesario que
aparezcan todos los diagramas**. De hecho, la mayoría de los
modelos UML contienen un subconjunto de los diagramas indicados.

¿Por qué es necesario contar con diferentes perspectivas de un
sistema? Por lo general, un sistema cuenta con diversas personas
implicadas, las cuales tienen enfoques particulares en diversos
aspectos del sistema. Volvamos al ejemplo de la lavadora. Si
diseñara el motor de una lavadora, tendría una perspectiva del
sistema; si escribiera las instrucciones de operación, tendría
otra perspectiva. Si diseñara la forma general de la lavadora,
vería el sistema desde una perspectiva totalmente distinta a si
tan sólo tratara de lavar su ropa.

El escrupuloso diseño de un sistema involucra **todas las
posibles perspectivas**, y cada diagrama UML le da una forma de
incorporar una perspectiva en particular. El objetivo es
satisfacer a cada persona implicada.

----

Resumen
=======

UML es el resultado del trabajo hecho por **Grady Booch**,
**James Rumbaugh** e **Ivar Jacobson**.

UML está constituido por un conjunto de diagramas, y proporciona
un estándar que permite al analista de sistemas generar un
anteproyecto de varias facetas que sean comprensibles para los
clientes, desarrolladores y todos aquellos que estén involucrados
en el proceso de desarrollo.

Es necesario contar con todos esos diagramas dado que cada uno
se dirige a cada tipo de persona implicada en el sistema.

  Un modelo UML indica **qué** es lo que supuestamente hará el
  sistema, mas no **cómo** lo hará.

----

Taller
======

Cuestionario
------------

1. ¿Por qué es necesario contar con diversos diagramas en el
   modelo de un sistema?
2. ¿Cuáles diagramas le dan una perspectiva **estática** de un
   sistema?
3. ¿Cuáles diagramas le dan una perspectiva **dinámica** de un
   sistema (esto es, muestran el cambio progresivo)?

Ejercicios
----------

1. Suponga que creará un sistema informático que jugará ajedrez
   con un usuario. ¿Cuáles diagramas UML serían útiles para
   diseñar el sistema? ¿Por qué?
2. Para el sistema del ejercicio que ha completado, liste las
   preguntas que formularía a un usuario potencial y por qué las
   haría.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Metamodelo de Requisitos (UML)**
   - :doc:`/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-01-metamodelo-requisitos`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 1
