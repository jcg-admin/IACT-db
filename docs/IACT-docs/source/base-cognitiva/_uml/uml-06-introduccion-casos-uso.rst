.. meta::
 :artefacto: UML_06
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-06:

==========================================
UML_06: Introducción a los casos de uso
==========================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 6.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

----

Estática vs dinámica
====================

Los diagramas que proporcionan una **idea estática** de las
clases en un sistema (clase, composición) y los diagramas que
establecen una **idea dinámica** (la forma en que el sistema y
sus clases cambian con el tiempo: casos de uso, estado).

Las ideas estáticas ayudan a que un analista se comunique con un
cliente. La idea dinámica, ayudará al analista a comunicarse
con un grupo de desarrolladores.

Comprender el **punto de vista del usuario** es clave para
generar sistemas que sean tanto útiles como funcionales — esto
es, que cumplan con los requerimientos y que sea fácil (e,
incluso, divertido) trabajar con ellos. El punto de vista del
usuario es el trabajo de los **casos de uso**.

----

Qué son los casos de uso
========================

Si te preguntas qué es lo que deseas hacer con una máquina,
¿qué características deseas?, ¿cuáles funciones necesitas que
tenga? — al preguntarte eso estás siguiendo un tipo de **análisis
del caso de uso**.

Si analizamos para qué queremos una cosa antes de comprarla
impulsivamente, ese análisis es del tipo de caso de uso. Nos
preguntamos cómo utilizaremos el producto, de modo que podamos
obtener algo que cumpla con nuestras necesidades. Este tipo de
análisis es **crucial para la fase de análisis del desarrollo de
un sistema**.

El caso de uso es una estructura que ayuda a trabajar con los
usuarios para determinar la forma en que se **usará un sistema**.
Con una colección de casos de uso, se puede hacer el bosquejo de
un sistema en términos de lo que los usuarios intenten hacer con
él.

El caso de uso es como una **colección de situaciones respecto al
uso de un sistema**; cada escenario describe una secuencia de
eventos.

Cada secuencia se inicia por una persona, otro sistema, una
parte del hardware o por el paso del tiempo. A las entidades que
inician secuencias se les conoce como **actores**. El resultado
de la secuencia debe ser **algo utilizable**.

----

Importancia de los casos de uso
===============================

El diagrama de clases es un buen medio para estimular a un
**cliente** a que hable respecto a un sistema desde su propio
punto de vista. El caso de uso es una excelente herramienta para
estimular a que los **usuarios potenciales** hablen, de un
sistema, desde sus propios puntos de vista.

La idea es **involucrar a los usuarios en las etapas iniciales**
del análisis y diseño del sistema. Esto aumenta la probabilidad
de que el sistema sea de mayor provecho.

Un ejemplo: la **máquina de gaseosas**.

Suponga que empezará a diseñar una máquina despachadora de
gaseosas. Desde el punto de vista del interesado, entrevistará a
varios usuarios potenciales. Como resultado obtendrá la función
principal de una máquina de gaseosas: permitir a un cliente
adquirir una lata de gaseosa. Las personas le dirán que se
enfrentará a diversos escenarios — un caso de uso, en otras
palabras — que podría etiquetar como **"Comprar gaseosa"**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Cliente
   rectangle "Máquina de Gaseosas" {
     usecase "Comprar gaseosa" as UC1
   }
   Cliente --> UC1
   @enduml

.. tip::

 Un caso de uso establece un conjunto de escenarios para
 realizar **algo útil (deseado) para un actor**. Un actor puede
 ser una persona, otro sistema, una parte del hardware o el
 paso del tiempo.

 Entre las preguntas que se tienen que responder con los casos
 de uso están:

 - ¿Qué condiciones llevaron al actor a iniciar el escenario?
 - ¿Qué se obtiene como resultado del escenario?
 - ¿Lo que he descrito es la única posibilidad del escenario?
 - ¿Qué pasa si el actor no cumple con los requisitos iniciales?
 - ¿Qué situaciones pueden impedir que el caso de uso alcance su
   propósito? ¿Cuáles son los puntos críticos donde podría
   fallar? ¿Qué pasa si el caso de uso falla? ¿Hay una ruta
   alternativa o acción correctiva?
 - ¿Qué pasa si el caso de uso tiene cambios?
 - ¿Qué sucede con los datos o el estado del sistema si el caso
   de uso se interrumpe?

En el caso de uso *"Comprar gaseosa"*, el actor es un **cliente
que desea** comprar una lata de gaseosa.

El escenario iniciará cuando el cliente inserte dinero,
posteriormente realizará una selección, y si todo funciona bien,
la máquina contará con al menos una lata de la gaseosa elegida,
misma que pondrá al alcance del cliente.

- **¿Qué condiciones llevaron al cliente a iniciar el escenario
  "Comprar gaseosa"?** La sed es la más obvia.
- **¿Qué se obtiene como resultado?** Lo obvio es que el cliente
  tenga una gaseosa en su poder.
- **¿Lo que he descrito es la única posibilidad?** No. Por
  ejemplo, es posible que la máquina no tenga la gaseosa que
  desee el cliente; también es posible que el cliente no tenga
  el importe exacto.

¿Cómo diseñaría a la máquina de gaseosas para controlar tales
**escenarios**?

Escenario: la máquina se ha quedado sin gaseosa
-----------------------------------------------

Imagínelo como una **ruta alternativa** dentro del caso de uso.
El cliente inicia el caso de uso al insertar dinero en la máquina
y posteriormente hace una selección. La máquina no cuenta con
ninguna lata de la gaseosa seleccionada, por lo que mostrará un
mensaje al cliente que indicará que no tiene de esa marca. Lo
ideal sería que el mensaje le pida al cliente que haga otra
selección; la máquina también debería dar la opción de devolver
el dinero al cliente. En este punto, el cliente selecciona otra
marca que la máquina entregará (siempre y cuando cuente con
provisiones de esta marca), o devolverá el dinero.

- **Condición previa:** un cliente sediento.
- **Resultado:** una lata de gaseosa **o** la (alternativa)
  devolución del dinero.

Claro que el escenario de quedarse sin gaseosa sería posible: el
mensaje *"No hay de esta marca"* podría aparecer en cuanto las
provisiones de la máquina se acabaran y permanecer a la vista
hasta que la máquina sea reabastecida. En tal caso, el usuario
podría no insertar el dinero en primera instancia. El cliente
para el que usted diseñará la máquina podría preferir el primer
escenario: si el cliente ya insertó dinero, la tendencia podría
ser **hacer otra selección** en lugar de pedir a la máquina que
lo devuelva.

Escenario: la cantidad de dinero es incorrecta
----------------------------------------------

El usuario inicia el caso de uso en la forma usual y
posteriormente hace una selección. Asumamos que la máquina tiene
provisión de la marca elegida. Si en la máquina hay una reserva
de moneda fraccionaria, devuelve la diferencia al despachar la
gaseosa; si la máquina **no cuenta con** una reserva de moneda
fraccionaria, devolverá el dinero **(alternativa)** y mostrará un
mensaje que pida al usuario el importe exacto.

- **Condición previa:** la ya indicada.
- **Resultado:** una lata de gaseosa junto con el cambio, o la
  devolución **(alternativa)** del dinero originalmente
  depositado.

Tan pronto como se agote la moneda fraccionaria, **aparezca un
mensaje** que informe a los clientes que se requiere el importe
exacto. El mensaje permanecería a la vista hasta que la máquina
sea reabastecida con moneda fraccionaria.

----

Casos de uso adicionales
========================

Ya ha examinado a la máquina de gaseosas desde el punto de vista
del **cliente**. Hay otros usuarios que intervienen, como el
**proveedor** que tiene que reabastecer a la máquina, el
**recolector de dinero** (que tal vez sea el mismo que el
proveedor) que tiene que recoger el dinero acumulado en la
alcancía de la máquina, etcétera.

Caso de uso "Reabastecer"
-------------------------

El proveedor inicia este caso de uso dado que algún **intervalo**
(actor: tiempo) (digamos, dos semanas) ha pasado. El representante
del proveedor le quita el seguro a la máquina (tal vez mediante
una llave y un cerrojo, pero eso entra dentro de la
implementación), jala la puerta para abrir la máquina y llena el
compartimiento de cada marca hasta su capacidad; el representante
también rellena la reserva de moneda fraccionaria. Luego cierra
el frente de la máquina y vuelve a poner el seguro.

- **Condición previa:** el paso del intervalo.
- **Resultado:** el proveedor cuenta con un nuevo conjunto de
  ventas potenciales.

  Aquí el **tiempo tiene el papel de actor**, ya que se tiene
  que cumplir un intervalo para que ciertas acciones ocurran.

Caso de uso "Recolectar el dinero"
----------------------------------

El recolector inicia debido también a que ha pasado **cierto
tiempo**. La persona deberá seguir la misma secuencia que en
*"Reabastecer"* para abrir la máquina. El recolector sacará el
dinero de la máquina y seguirá los pasos de *"Reabastecer"* para
cerrar y poner el seguro a la máquina.

- **Condición previa:** el paso del intervalo.
- **Resultado:** el dinero en las manos del recolector.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Cliente
   actor Proveedor
   actor Recolector
   actor Tiempo as T

   rectangle "Máquina de Gaseosas" {
     usecase "Comprar gaseosa"      as UC1
     usecase "Reabastecer"          as UC2
     usecase "Recolectar el dinero" as UC3
   }
   Cliente     --> UC1
   Proveedor   --> UC2
   Recolector  --> UC3
   T           --> UC2
   T           --> UC3
   @enduml

Cuando **derivamos un caso de uso**, no nos preocupamos por la
forma de implementarlo. No nos interesamos en los aspectos
internos de la máquina de gaseosa, tampoco por la forma en que
funcione el mecanismo de refrigeración, o por la forma en que la
máquina controle la cantidad de dinero. **Intentamos ver la
forma** en que la máquina lucirá para alguien que tenga que
utilizarla.

El objetivo es **derivar una colección de casos de uso** que,
finalmente, mostraremos a las *personas que diseñen la máquina*
y a las *personas que la construirán*.

Nuestros casos de uso reflejan lo que los clientes, recolectores
y proveedores desean, por lo que el resultado será una máquina
que **todos esos grupos** puedan utilizar con facilidad.

----

Inclusión de los casos de uso
=============================

Tal vez distinguió ciertos pasos en común. ¿Podríamos eliminar la
duplicación de pasos de un caso de uso al otro? Tomar cada
secuencia de pasos en común y conformar un **caso de uso
adicional** a partir de ellos.

Combinemos los pasos necesarios para *"quitar el seguro"* y
*"abrir la máquina"* y llamémoslos **"Exhibir el interior"**, y
los pasos *"cerrar la máquina"* y *"asegurarla"* en otro caso de
uso llamado **"Cubrir el interior"**.

- El caso de uso **"Reabastecer"** iniciaría con el caso de uso
  *"Exhibir el interior"*, luego el representante del proveedor
  seguiría los pasos ya indicados, y concluiría con el caso de
  uso *"Cubrir el interior"*.
- De forma similar, el caso de uso **"Recolectar dinero"**
  iniciaría con *"Exhibir el interior"*, procedería como se
  indicó, y finalizaría con el caso de uso *"Cubrir el
  interior"*.

De tal manera que *"Reabastecer"* y *"Recolectar dinero"*
**incluyen** los nuevos casos de uso. Esta técnica de
**aprovechamiento de un caso de uso** se le conoce como
**inclusión de un caso de uso**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Proveedor
   actor Recolector

   rectangle "Máquina de Gaseosas" {
     usecase "Reabastecer"          as UC2
     usecase "Recolectar el dinero" as UC3
     usecase "Exhibir el interior"  as UCIN
     usecase "Cubrir el interior"   as UCOUT
   }
   Proveedor  --> UC2
   Recolector --> UC3
   UC2 ..> UCIN  : <<include>>
   UC2 ..> UCOUT : <<include>>
   UC3 ..> UCIN  : <<include>>
   UC3 ..> UCOUT : <<include>>
   @enduml

La inclusión de un caso de uso también se conoce como **"usar"
un caso de uso**. El término *incluir* tiene dos ventajas:

1. Es más claro: los pasos en un caso de uso **incluyen** los
   de otro.
2. Se evita la confusión potencial de las palabras *"usar"* y
   *"uso"* en un contexto tan estrecho. Así, no tendremos que
   decir *"promover el uso mediante el uso reiterativo de un
   caso de uso"*.

Promover el uso, mediante la **inclusión** reiterativa de un
caso de uso.

----

Extensión de los casos de uso
=============================

Es posible volver a utilizar un caso de uso de una forma distinta
a una inclusión. En ocasiones crearemos un caso de uso
**agregándole algunos pasos a un caso de uso existente**.

Volviendo al caso de uso *"Reabastecer"*: antes de colocar nuevas
latas de gaseosas en la máquina, suponga que el representante del
proveedor nota las marcas que se han vendido bien, así como las
que no se han vendido tan bien. En lugar de sólo reabastecer
todas las marcas, el representante podría sacar aquellas que no
se han vendido bien y reemplazarlas por latas de las marcas que
han probado ser más populares.

Si agregamos estos pasos a *"Reabastecer"*, tendremos un nuevo
caso de uso que llamaríamos **"Reabastecer de acuerdo a las
ventas"**. Este nuevo caso de uso es una *extensión del
original*, acción a la que se le conoce como **extensión de un
caso de uso**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Proveedor

   rectangle "Máquina de Gaseosas" {
     usecase "Reabastecer"                       as UC2
     usecase "Reabastecer de acuerdo a ventas"   as UC2X
   }
   Proveedor --> UC2X
   UC2X ..> UC2 : <<extend>>
   @enduml

----

Inicio del análisis de un caso de uso
=====================================

En el mundo real, por lo general, seguirá un **conjunto de
procedimientos** cuando empiece un análisis de casos de uso.

Empezará con **entrevistas a los clientes** (y entrevistas con
expertos / *Project Owner*) que lo lleven a los diagramas
iniciales de clases. Esto le dará cierta idea del área en la que
trabajará.

Posteriormente, contará con un fundamento para hablar con los
usuarios. **Entrevistará a los usuarios** (preferentemente en
grupos) y les pedirá que le indiquen todo lo que ellos harían
con el sistema.

Sus respuestas conformarán un **conjunto candidato de casos de
uso**. Al describir brevemente cada caso de uso, derivará una
lista de todos los actores que iniciarán y se beneficiarán de
los casos de uso. Cuanta más información obtenga en esta fase,
aumentará su aptitud para hablar con los usuarios.

Los casos de uso aparecerán en varias fases del proceso de
desarrollo. Le ayudarán con el diseño de una **interfaz del
usuario**, contribuirán con las **opciones de desarrollo** de
los programadores y establecerán las **bases para probar** el
sistema recién generado.

----

Resumen
=======

- El **caso de uso** es una estructura para describir la forma
  en que un sistema lucirá para los usuarios:

  - Es una colección de **escenarios** iniciados por una entidad
    llamada **actor** (una persona, un componente de hardware,
    un lapso u otro sistema).
  - El caso de uso debería dar por resultado **algo de valor**
    ya sea para el actor que lo inició o para otro.

- Una forma de volver a utilizar casos de uso es:

  - **inclusión** (``<<include>>``) — utilizar los pasos de un
    caso de uso como parte de la secuencia de pasos de otro.
  - **extensión** (``<<extend>>``) — crear un nuevo caso de uso
    mediante la adición de pasos a un caso de uso existente.

- La **entrevista directa con los usuarios** es la mejor técnica
  para derivar casos de uso; ver desde distintos puntos de vista
  es importante para destacar las condiciones para iniciar el
  caso de uso y los resultados obtenidos como consecuencia del
  mismo.

  - Primero son las entrevistas a los **usuarios**, después de
    entrevistar a los **clientes** y generar una lista de
    prospectos de clases.
  - Es una buena idea entrevistar a un grupo de usuarios.
  - El objetivo es derivar un conjunto candidato de casos de uso
    y todos los posibles actores.

----

Preguntas y respuestas
======================

**¿Para qué necesito el concepto de caso de uso?**

Tenemos que crear una estructura de lo que los usuarios nos
digan, y los casos de uso la proporcionan. La estructura se
vuelve útil cuando tiene que llevar los resultados de sus
entrevistas con los usuarios y comunicarlos a los clientes y
desarrolladores.

**¿Qué tan difícil es derivar los casos de uso?**

El listado de casos de uso —al menos los de alto nivel— no es muy
complejo. Hay ciertas dificultades al profundizar en cada uno e
intentar lograr que los usuarios *listen los pasos de cada
escenario*. Cuando genere un sistema que reemplace una manera
existente de hacer las cosas, los usuarios típicamente ya sabrán
los pasos bastante bien y los habrán utilizado con tanta
regularidad que se les dificultará estructurarlos. Es una buena
idea tener un **panel de usuarios**, ya que la discusión en grupo
por lo general trae consigo ideas que un usuario en particular
podría tener **problemas para expresar**.

El problema de generar una estructura se debe a que los usuarios
conocen los pasos para solucionar su problema de forma
"automática", algo que ellos realizan como un hábito.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-05-agregacion-composicion-interfaces`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Aplicación canónica en IACT**
   - :doc:`/requisitos/casos-uso/index`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 6 (Schmuller, 2000)
