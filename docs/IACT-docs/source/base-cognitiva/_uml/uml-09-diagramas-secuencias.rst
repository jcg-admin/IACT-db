.. meta::
 :artefacto: UML_09
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-09:

==================================
UML_09: Diagramas de secuencias
==================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 9.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

.. warning::

 Recuerde que los **diagramas de estados** se centran en **un
 objeto** y muestran los cambios por los que pasa dicho objeto;
 se enfocan sólo en los diferentes estados de un objeto.

El **diagrama de secuencias** muestra la forma en que los objetos
se comunican entre sí al transcurrir el tiempo.

UML le muestra la forma en que un objeto interactúa con otros;
esto incluirá una importante dimensión: **el tiempo**.

La idea es que las interacciones entre los objetos se realizan en
una secuencia establecida, y que la secuencia se toma su tiempo
en ir del principio al fin.

Un diagrama de secuencias está implícito en cada caso de uso.

----

Qué es un diagrama de secuencias
================================

El diagrama de secuencias consta de:

- **Objetos** representados del modo usual: rectángulos con
  nombre (subrayado).
- **Mensajes** representados por líneas continuas con una punta
  de flecha.
- **Tiempo** representado como una progresión vertical.

Los objetos se colocan en la parte superior del diagrama de
izquierda a derecha, acomodados de manera que simplifiquen el
diagrama.

La extensión que está debajo (en forma descendente) de cada
objeto es una **línea discontinua** conocida como **la línea de
vida del objeto**.

Junto con la línea se encuentra un pequeño rectángulo conocido
como **activación**, que representa la ejecución de una
operación que realiza el objeto. La longitud del rectángulo se
interpreta como la duración de la activación.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant Cliente as C
   participant ":Objeto" as O
   C -> O ++ : mensaje
   ... actividad ...
   return resultado
   @enduml

Un **mensaje** que va de un objeto a otro pasa de la línea de
vida de un objeto a la de otro. Un objeto puede enviarse un
mensaje a sí mismo desde su línea de vida hacia su propia línea
de vida.

El mensaje puede ser **simple**, **sincrónico** o **asincrónico**:

.. list-table::
 :widths: 22 48 30
 :header-rows: 1

 * - Tipo
   - Qué es
   - Punta de flecha
 * - **Simple**
   - Transferencia del control de un objeto a otro.
   - Formada por dos líneas (open arrow ``>``).
 * - **Sincrónico**
   - El emisor esperará la respuesta antes de continuar.
   - Está rellena (filled arrow ``▶``).
 * - **Asincrónico**
   - El emisor no esperará una respuesta antes de continuar.
   - Tiene una sola línea (half open arrow ``>``).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant A
   participant B
   A ->  B : mensaje simple
   A ->> B : mensaje asincrónico
   A -> B  : mensaje sincrónico
   B --> A : retorno
   @enduml

En el diagrama se representa al **tiempo** en dirección
vertical: se inicia en la parte superior y avanza hacia la parte
inferior. Un mensaje que esté más cerca de la parte superior
ocurrirá antes que uno cerca de la parte inferior.

El diagrama de secuencias tiene dos dimensiones:

- **Dimensión horizontal:** disposición de los objetos.
- **Dimensión vertical:** paso del tiempo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Actor
   participant ":ObjetoA" as A
   participant ":ObjetoB" as B
   participant ":ObjetoC" as C

   Actor -> A : iniciar
   activate A
   A -> B : operacion1()
   activate B
   B -> C : operacion2()
   activate C
   C --> B : resultado
   deactivate C
   B --> A : ok
   deactivate B
   deactivate A
   @enduml

----

La GUI
======

Se dibujará un diagrama de secuencias que represente las
interactividades de la GUI con otros objetos.

La secuencia
------------

El usuario de una GUI presiona una tecla alfanumérica. Si
asumimos que utiliza una aplicación como un procesador de
textos, el carácter correspondiente deberá aparecer de inmediato
en la pantalla.

¿Qué ocurre tras bambalinas para que esto suceda?

1. La GUI notifica al sistema operativo que se oprimió una tecla.
2. El sistema operativo le notifica a la CPU.
3. El sistema operativo actualiza la GUI.
4. La CPU notifica a la tarjeta de vídeo.
5. La tarjeta de vídeo envía un mensaje al monitor.
6. El monitor presenta el carácter alfanumérico en la pantalla.

El diagrama de secuencias
-------------------------

Los mensajes son **asincrónicos**: ninguno de los componentes
aguarda nada antes de continuar.

Cuando teclea en un procesador de textos, en ocasiones no ve
aparecer en la pantalla el carácter correspondiente a la tecla
que haya oprimido sino hasta después de haber oprimido algunas
más.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Usuario
   participant ":GUI"          as GUI
   participant ":SistemaOp"    as SO
   participant ":CPU"          as CPU
   participant ":TarjetaVideo" as TV
   participant ":Monitor"      as MON

   Usuario ->> GUI : oprimirTecla
   GUI     ->> SO  : notificarTecla
   SO      ->> CPU : notificarTecla
   SO      ->> GUI : actualizar
   CPU     ->> TV  : enviarCaracter
   TV      ->> MON : presentarCaracter
   @enduml

Es muy instructivo mostrar los **estados** de uno o varios de los
objetos en el diagrama de secuencias. Se puede combinar con
diagrama de estados (híbrido). La secuencia se origina y
finaliza en el estado *Operativo* de la GUI.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Usuario
   participant ":GUI" as GUI
   participant ":SistemaOp" as SO
   participant ":CPU" as CPU

   Usuario ->> GUI : oprimirTecla
   note over GUI : estado: Operativo → Registrando
   GUI ->> SO : notificarTecla
   SO  ->> CPU : notificarTecla
   SO  ->> GUI : actualizar
   note over GUI : estado: Registrando → Operativo
   @enduml

Otra forma de mostrar el cambio de estado de un objeto es
**incluir al objeto más de una vez** en el diagrama.

El caso de uso
--------------

¿Qué es exactamente lo que representa un diagrama de secuencias?

Muestra las interacciones de objetos que se realizan durante un
escenario sencillo. Este escenario podría ser parte de un caso
de uso llamado *"Ejecutar la opresión de una tecla"*.

Representar gráficamente las interacciones del sistema en el
caso de uso, el diagrama de secuencias **delineará** el caso de
uso dentro del sistema.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Usuario
   rectangle "Sistema" {
     usecase "Ejecutar la opresión\nde una tecla" as UC
   }
   Usuario --> UC
   @enduml

----

Instancias y genéricos
======================

Diagrama de secuencias de instancias
------------------------------------

En el caso de uso *"Comprar gaseosa"*, el actor es un cliente
que desea adquirir una lata de gaseosa.

El cliente inicia el escenario mediante la inserción de dinero
en la máquina y luego hace una selección. Asumamos que en la
máquina hay tres objetos: la **fachada** (interfaz al usuario),
el **registrador de dinero** y el **dispensador**.

Daremos por hecho que el registrador controla al dispensador.
Secuencia:

1. El cliente inserta el dinero en la alcancía de la fachada.
2. El cliente hace su elección.
3. El dinero viaja hacia el registrador.
4. El registrador verifica si la gaseosa elegida está en el
   dispensador.
5. Dado que es el mejor escenario, asumimos que sí hay
   gaseosas, y el registrador actualiza su reserva de efectivo.
6. El registrador hace que el dispensador entregue la gaseosa
   en la fachada.

.. warning:: Diagrama de secuencias de instancias

 Es un diagrama de secuencias que sólo se centra en **un
 escenario** (una instancia).

Cada mensaje mueve el flujo de control de un objeto a otro
(mensajes simples).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Cliente
   participant ":Fachada"      as F
   participant ":Registrador"  as R
   participant ":Dispensador"  as D

   Cliente -> F : insertarDinero
   Cliente -> F : seleccionarMarca
   F -> R       : enviarDinero
   R -> D       : verificarMarca
   D --> R      : disponible
   R -> R       : actualizarReserva
   R -> D       : entregarGaseosa
   D -> F       : depositarGaseosa
   F --> Cliente : tomarGaseosa
   @enduml

Diagrama de secuencias genérico
-------------------------------

El caso de uso *"Comprar gaseosa"* tenía dos escenarios alternos:
máquina sin la gaseosa seleccionada, y cliente sin el dinero
exacto.

.. warning:: Diagrama de secuencias genérico

 Es un diagrama de secuencias que toma en cuenta **todos los
 escenarios** de un caso de uso.

Para representar cada condición en la secuencia, tal condición
se coloca en un *si condicional* entre **corchetes**:

::

 [alimentación > precio]
 [alimentación - precio no presente]
 [alimentación - precio presente]

**Cada condición causa una bifurcación** del control en el
mensaje, que separará al mensaje en rutas distintas. Como cada
ruta irá al mismo objeto, la bifurcación causa una *"ramificación"*
del control en la línea de vida del objeto receptor. En algún
lugar de la secuencia, las ramas confluirán.

Escenario "Monto incorrecto":

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Cliente
   participant ":Fachada"     as F
   participant ":Registrador" as R
   participant ":Dispensador" as D

   Cliente -> F  : insertarDinero
   Cliente -> F  : seleccionarMarca
   F -> R        : enviarDinero
   R -> R        : verificarMonto

   alt [alimentación > precio]
     alt [alimentación - precio presente]
       R -> Cliente : devolverCambio
       R -> D       : entregarGaseosa
       D -> F       : depositarGaseosa
     else [alimentación - precio no presente]
       R -> Cliente : devolverDinero
       R -> F       : "Inserte importe exacto"
     end
   else [alimentación = precio]
     R -> D : entregarGaseosa
     D -> F : depositarGaseosa
   else [alimentación < precio]
     F -> Cliente : "Esperando más dinero"
   end
   @enduml

Escenarios "Monto incorrecto" + "Sin marca":

1. Una vez que el cliente elige una marca agotada, la máquina
   muestra un mensaje de *"Agotado"*.
2. La máquina muestra un mensaje que solicita al cliente que
   haga otra elección.
3. El cliente tiene la opción de oprimir un botón para que se le
   regrese su dinero.
4. Si el cliente elige una marca en existencia, todo procede
   como en el mejor escenario.
5. Si el cliente elige otra marca agotada, el proceso se repite.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Cliente
   participant ":Fachada"     as F
   participant ":Registrador" as R
   participant ":Dispensador" as D

   Cliente -> F  : insertarDinero
   F -> R        : enviarDinero

   loop mientras [marca no disponible y cliente no cancela]
     Cliente -> F : seleccionarMarca
     F -> D       : verificarMarca
     alt [no disponible]
       D --> F : "Agotado"
       F -> Cliente : pedirOtraSeleccion
     else [disponible]
       break
     end
   end

   alt [cliente cancela]
     R -> Cliente : devolverDinero
   else [marca disponible]
     R -> R : verificarMonto
     alt [monto correcto]
       R -> D : entregarGaseosa
       D -> F : depositarGaseosa
     else [monto incorrecto]
       R -> Cliente : devolverDineroOAjustar
     end
   end
   @enduml

Si empieza a pensar que un diagrama de secuencias está implícito
en cada caso de uso, ya tiene la idea.

----

Creación de un objeto en la secuencia
=====================================

Con frecuencia un programa orientado a objetos debe crear un
objeto. En términos del software, una **clase es una plantilla
para crear un objeto** (como un molde de galletas para crear una
galleta).

¿Cómo representaría la creación de un objeto cuando represente
una secuencia de interacciones entre objetos?

Caso de uso *"Crear una propuesta"* de la LAN en una firma de
consultoría. Si damos por hecho que el consultor ya ha iniciado
una sesión, la secuencia es:

1. El consultor querrá volver a utilizar partes de una propuesta
   existente y busca en un área centralizada de la red.
2. Si el consultor encuentra una propuesta adecuada, abre el
   archivo y guarda con un nuevo nombre, creando un archivo
   nuevo.
3. Si no encuentra, abre la aplicación de oficina y crea un
   archivo para la propuesta.
4. Al trabajar, utiliza las aplicaciones del software integrado.
5. Cuando finaliza, guarda en el área de almacenamiento
   centralizada.

Esta secuencia trae consigo el uso de **si** y de un ciclo
**mientras**.

Cuando una secuencia da por resultado *la creación de un objeto*,
tal objeto se representa como un rectángulo con nombre. **No** se
coloca en la parte superior; se coloca a lo largo de la
dimensión vertical, de modo que su ubicación corresponda al
momento en que se cree.

El mensaje que crea al objeto se nombra ``Crear()`` (o se usa el
estereotipo ``«Crear»``). En un lenguaje OO, una **operación
constructor genera un objeto**.

En el caso del *mientras*, el control de flujo se representa
colocando la condición entre corchetes con un asterisco (``*``)
antes del primer corchete.

.. note:: Este ejemplo representa una abstracción

 He omitido detalles que no nos competen en lo particular.
 Primero, obvié los detalles de la LAN. La GUI es un objeto en
 el diagrama de secuencias, y no he incluido toda la complejidad
 del caso de uso *"Teclazo"* del ejemplo anterior — los detalles
 de la interacción de la GUI con el sistema operativo, la CPU y
 el monitor **no son importantes en este caso**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Consultor
   participant ":AreaCentral" as A
   participant ":AppOficina" as App
   participant ":Propuesta" as P

   Consultor -> A : buscarPropuesta()

   alt [propuesta encontrada]
     Consultor -> App : abrir(propuestaExistente)
     activate App
     App -> P ** : Crear(nuevoNombre)
     activate P
   else [no encontrada]
     Consultor -> App : abrir()
     activate App
     App -> P ** : Crear()
     activate P
   end

   loop *[mientras se trabaja en la propuesta]
     Consultor -> App : editar()
     App -> P : actualizar()
   end

   Consultor -> A : guardar(P)
   deactivate P
   deactivate App
   @enduml

----

Cómo representar la recursividad
================================

Un objeto cuenta con una operación que se invoca a sí misma. A
esto se le conoce como **recursividad**.

Por ejemplo: uno de los objetos en su sistema es una calculadora,
y una de sus operaciones es el cálculo de intereses. Para
calcular el interés compuesto para un periodo que incluya varios
periodos, la operación tendrá que invocarse a sí misma varias
veces.

Para representar esto en UML, se dibuja una **flecha de mensaje
fuera de la activación** que signifique la operación, y un
**pequeño rectángulo sobrepuesto** en la activación. La flecha
apunta al pequeño rectángulo, y otra flecha regresa al objeto
que inició la recursividad.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant ":Calculadora" as C
   activate C
   C -> C : calcularInteres(periodo)
   activate C
   C -> C : calcularInteres(periodo-1)
   activate C
   C --> C : resultado
   deactivate C
   C --> C : resultado
   deactivate C
   deactivate C
   @enduml

----

Adiciones al panorama
=====================

El diagrama de secuencias va bajo la categoría **Elementos de
comportamiento**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   skinparam packageStyle rectangle

   package "UML" {
     package "Comportamiento" {
       rectangle "Casos de uso"  as CMP1
       rectangle "Estados"       as CMP2
       rectangle "Secuencias\n(NUEVO)" as CMP3
       rectangle "Actividades"   as CMP4
     }
     package "Estructurales" {
       rectangle Clase
       rectangle Objeto
       rectangle Actor
       rectangle Interfaz
       rectangle "Caso de uso" as CU
     }
     package "Relaciones" {
       rectangle Asociacion
       rectangle Generalizacion
       rectangle Dependencia
       rectangle Realizacion
     }
     package "Agrupamiento" { rectangle Paquete }
     package "Anotacion"    { rectangle Nota    }
     package "Extension"    { rectangle Estereotipo }
   }
   @enduml

----

Resumen
=======

- El diagrama de secuencias agrega la **dimensión del tiempo** a
  las interacciones de los objetos. Los objetos se colocan en
  la parte superior y el tiempo avanza de arriba hacia abajo.
- La **línea de vida** de un objeto desciende de cada uno de
  ellos. Un pequeño rectángulo en la línea de vida representa
  una **activación** (la ejecución de una de las operaciones).
- Puede incorporar los estados de un objeto colocándolos junto
  a su línea de vida.
- Los **mensajes** (simples, sincrónicos y asincrónicos) son
  flechas que conectan a una línea de vida con otra. La
  ubicación del mensaje en la dimensión vertical representará
  el momento en que sucede.
- Los mensajes que ocurren primero están más cerca de la parte
  superior; los que ocurren después, cerca de la parte inferior.
- El diagrama de secuencias puede mostrar ya sea **una instancia**
  (un escenario) de un caso de uso o puede ser **genérico** e
  incorporar todos los escenarios.
- Los diagramas genéricos con frecuencia dan la oportunidad de
  representar **instrucciones condicionales** y **ciclos
  mientras**. Bordee a cada condición con corchetes; en un ciclo
  *mientras* anteceda al corchete izquierdo con un asterisco.
- Cuando una secuencia incluya la **creación de un objeto**, lo
  representa como un rectángulo de la forma acostumbrada; su
  posición en la dimensión vertical representará el momento en
  que se creó.
- Una operación puede invocarse a sí misma — **recursividad**.
  Se representa con una flecha que sale de la activación hacia
  sí misma, y un pequeño rectángulo sobrepuesto a la activación.

----

Preguntas y respuestas
======================

**El diagrama de secuencias parece que podría ser útil para más
que tan sólo el análisis de sistemas. ¿Puedo usarlo para mostrar
la interactividad en una empresa?**

Así es. Los objetos pueden ser los actores principales, y los
mensajes pueden ser simples transferencias de control.

**¿Los objetos también se destruyen, y si es así, cómo lo
represento?**

Los objetos, en efecto, se destruyen. Podrá representar la
destrucción de un objeto con una **"X"** al final de la línea de
vida correspondiente a tal objeto.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-08-diagramas-estados`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 9 (Schmuller, 2000)
