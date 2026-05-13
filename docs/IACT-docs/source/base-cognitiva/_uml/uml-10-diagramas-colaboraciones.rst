.. meta::
 :artefacto: UML_10
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-10:

===================================
UML_10: Diagramas de colaboraciones
===================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 10.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados.

 **Nota técnica:** PlantUML no tiene un tipo de diagrama
 "collaboration" nativo. Se reproducen con diagramas de objetos
 cuyas asociaciones llevan etiquetas numeradas (``N: mensaje()``)
 según la convención de comunicación UML 2.x.

----

Introducción
============

Los diagramas de colaboraciones muestran la forma en que los
objetos colaboran entre sí, tal como sucede con un diagrama de
secuencias. Muestran los objetos junto con los mensajes que se
envían entre ellos.

**Ambos tipos de diagrama son semánticamente equivalentes**:
representan la misma información, y podrá convertir un diagrama
de secuencias en un diagrama de colaboraciones equivalente y
viceversa.

- Los **diagramas de secuencias** destacan la sucesión de las
  interacciones.
- Los **diagramas de colaboraciones** destacan el contexto y
  organización general de los objetos que interactúan.

  El diagrama de secuencias se organiza de acuerdo al **tiempo**;
  el de colaboración de acuerdo al **espacio**.

----

Qué es un diagrama de colaboraciones
====================================

Mientras que en un diagrama de objetos se muestran a los objetos
como tales y sus relaciones, el diagrama de colaboraciones
**muestra los mensajes** que se envían los objetos entre sí. Es
una **extensión** del diagrama de objetos.

Para representar un mensaje, dibujará una **flecha** cerca de la
línea de asociación entre dos objetos; esta flecha apunta al
objeto receptor. El tipo de mensaje se mostrará en una etiqueta
cerca de la flecha; **el mensaje le indicará al objeto receptor
que ejecute una de sus operaciones**. El mensaje finalizará con
un par de paréntesis, dentro de los cuales colocará los
parámetros (en caso de haber alguno).

Se podrá representar la información de secuencia agregando una
**cifra** a la etiqueta del mensaje, correspondiente a la
secuencia propia del mensaje. La cifra y el mensaje se separan
mediante dos puntos (``:``).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Actor
   object ":ObjetoA" as A
   object ":ObjetoB" as B
   Actor -> A : iniciar
   A -> B   : "1: operacion(parametro)"
   B -> A   : "2: respuesta()"
   @enduml

----

La GUI
======

Un actor inicia la secuencia al oprimir una tecla. Tal secuencia
(de la lección anterior):

1. La GUI notifica al sistema operativo que se oprimió una tecla.
2. El sistema operativo le notifica a la CPU.
3. El sistema operativo actualiza la GUI.
4. La CPU notifica a la tarjeta de vídeo.
5. La tarjeta de vídeo envía un mensaje al monitor.
6. El monitor presenta el carácter alfanumérico en la pantalla.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Usuario
   object ":GUI"          as GUI
   object ":SistemaOp"    as SO
   object ":CPU"          as CPU
   object ":TarjetaVideo" as TV
   object ":Monitor"      as MON

   Usuario -> GUI : oprimirTecla
   GUI -> SO   : "1: notificarTecla()"
   SO -> CPU   : "2: notificarTecla()"
   SO -> GUI   : "3: actualizar()"
   CPU -> TV   : "4: enviarCaracter()"
   TV -> MON   : "5: presentarCaracter()"
   @enduml

----

Cambios de estado
=================

Puede mostrar los cambios de estado en un objeto en un diagrama
de colaboraciones.

En el rectángulo del objeto indique su estado. Agregue otro
rectángulo al diagrama que **haga las veces del objeto e indique
el estado modificado**. Conecte a los dos con *una línea
discontinua* y etiquétela con un estereotipo ``«se toma»`` (o
``«becomes»``).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object "GUI [Inicialización]" as GUI1
   object "GUI [Operación]"      as GUI2
   GUI1 ..> GUI2 : <<se toma>>
   @enduml

----

La máquina de gaseosas
======================

Aplicando las condiciones a una situación real.

Mejor situación
---------------

Iniciemos con la mejor situación del caso de uso *"Comprar
gaseosa"*:

1. El cliente inserta el dinero en la alcancía de la fachada.
2. El cliente hace su elección.
3. El dinero viaja hacia el registrador.
4. El registrador verifica si la gaseosa elegida está en el
   dispensador.
5. Asumimos que sí hay gaseosas, y el registrador actualiza su
   reserva de efectivo.
6. El registrador hace que el dispensador entregue la gaseosa
   en la fachada.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Cliente
   object ":Fachada"     as F
   object ":Registrador" as R
   object ":Dispensador" as D

   Cliente -> F : "insertar(alimentacion, seleccion)"
   F -> R       : "1: agregar(alimentacion, seleccion)"
   R -> D       : "2: despachar(seleccion)"
   D -> F       : "3: despachar(seleccion)"
   @enduml

Cantidad incorrecta de dinero
-----------------------------

Agreguemos el caso de *"cantidad incorrecta de dinero"*. Hay
varias condiciones:

1. El usuario ha introducido más dinero del necesario.
2. La máquina cuenta con cambio.
3. La máquina no tiene cambio.

Coloque la **condición entre corchetes**, antecediendo la
etiqueta. **Lo importante es coordinar las condiciones con la
numeración.**

El paso que devuelve el cambio *es una consecuencia* del que
verifica si hay cambio. Para indicar esto se utiliza el mismo
número y se agrega ``.1`` (**anidación**):

- Si el mensaje que verifica el cambio es ``N``,
- el mensaje que devuelve el cambio será ``N.1``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Cliente
   object ":Fachada"     as F
   object ":Registrador" as R
   object ":Dispensador" as D

   Cliente -> F : "insertar(alimentacion, seleccion)"
   F -> R       : "1: agregar(alimentacion, seleccion)"
   R -> D       : "[alimentacion = precio]\n2.1: despachar(seleccion)"
   R -> R       : "[alimentacion > precio]\n2.2: verificarCambio(alim, precio)"
   D -> F       : "[hay cambio]\n3.1: despachar(seleccion)"
   R -> Cliente : "[hay cambio]\n3.2: devolver(cambio)"
   @enduml

Sin cambio (transacción finalizada)
-----------------------------------

¿Qué ocurre cuando la máquina no cuenta con el cambio correcto?
Tendrá que mostrar un mensaje, devolver el dinero y pedir el
importe correcto. Agregue una **bifurcación** en el control de
flujo y un estereotipo ``«transacción finalizada»``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Cliente
   object ":Fachada"     as F
   object ":Registrador" as R
   object ":Dispensador" as D

   Cliente -> F : "insertar(alimentacion, seleccion)"
   F -> R       : "1: agregar(alimentacion, seleccion)"
   R -> D       : "[alim = precio]\n2.1: despachar(seleccion)"
   R -> R       : "[alim > precio]\n2.2: verificarCambio(alim, precio)"
   D -> F       : "[hay cambio]\n3.1: despachar(seleccion)"
   R -> Cliente : "[hay cambio]\n3.2: devolver(cambio)"
   R -> Cliente : "<<transacción finalizada>>\n[no hay cambio]\n3.3: devolver(alim)"
   R -> F       : "[no hay cambio]\n3.4: mostrar('Inserte importe exacto')"
   @enduml

----

Creación de un objeto
=====================

Caso de uso *"Crear propuesta"* de la firma de consultoría:

1. El consultor busca en el área de almacenamiento centralizada
   una propuesta adecuada.
2. Si la encuentra, abre el archivo (y la aplicación de oficina);
   guarda con un nuevo nombre, creando un nuevo archivo.
3. Si no encuentra, abre la aplicación y crea un nuevo archivo.
4. Trabaja con la aplicación.
5. Al finalizar, guarda en el área centralizada.

Para mostrar la **creación de un objeto**, agregue un estereotipo
``«crear»`` al mensaje que genera al objeto. Use *si* (``[…]``)
y *mientras* (``*[…]``) según corresponda.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Consultor
   object ":GUI"               as GUI
   object ":Deposito"          as DEP
   object ":AplicacionOficina" as APP
   object ":Propuesta"         as P

   Consultor -> GUI : "1: iniciarBusqueda()"
   GUI       -> DEP : "2: buscar()"
   DEP       -> GUI : "3: resultado"
   Consultor -> GUI : "[encontrado] 4.1: abrir(archivo)"
   Consultor -> GUI : "[no encontrado] 4.2: nuevo(archivo)"
   GUI       -> APP : "5: abrirYGuardarComo(propuesta)"
   APP       -> P   : "<<crear>> 6: crearArchivo()"
   Consultor -> GUI : "*[trabajo] 7: usarAplicaciones()"
   GUI       -> APP : "8: usarAplicaciones()"
   APP       -> P   : "9: modificar()"
   Consultor -> GUI : "[completado] 10: cerrarYGuardar()"
   GUI       -> APP : "11: cerrarYGuardar()"
   APP       -> P   : "12: cerrar()"
   APP       -> DEP : "13: guardar()"
   APP       -> GUI : "14: completado()"
   @enduml

----

Algunos conceptos más
=====================

Varios objetos receptores en una clase
--------------------------------------

En ocasiones un objeto envía un mensaje a diversos objetos de la
misma clase. Por ejemplo: un profesor pide a un grupo de
estudiantes que entreguen una tarea.

En el diagrama de colaboraciones, la representación de los
diversos objetos es una **pila de rectángulos** que se extienden
"desde atrás". Agregue una condición entre corchetes precedida
por un asterisco para indicar que el mensaje irá a todos los
objetos.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Profesor" as P
   object ":Estudiante" as E1
   object ":Estudiante " as E2
   object ":Estudiante  " as E3

   P -> E1 : "*[para todos los estudiantes]\n1: entregarTarea()"
   P -> E2 : "*[para todos los estudiantes]\n1: entregarTarea()"
   P -> E3 : "*[para todos los estudiantes]\n1: entregarTarea()"
   note right of E3
     pila de receptores
     (mismo mensaje "1")
   end note
   @enduml

En algunos casos, el orden del mensaje enviado es importante.
Por ejemplo, un empleado bancario da servicio a cada cliente
conforme fue llegando a la fila. Esto se representa con un
``mientras`` cuya condición implica orden:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":EmpleadoBancario" as EB
   object ":Cliente" as C1
   object ":Cliente " as C2
   object ":Cliente  " as C3

   EB -> C1 : "*[posición = 1..n]\n1: atender()"
   EB -> C2 : "*[posición = 1..n]\n1: atender()"
   EB -> C3 : "*[posición = 1..n]\n1: atender()"
   @enduml

Representación de los resultados
--------------------------------

Un mensaje podría ser una petición a un objeto para que realice
un cálculo y devuelva un valor. Un objeto ``Cliente`` podría
solicitar a un objeto ``Calculadora`` que calcule el precio total.

Sintaxis: el nombre del valor devuelto a la izquierda, seguido
de ``:=``, luego el nombre de la operación y las cantidades:

::

 precioTotal := calcular(precioElemento, impuesto)

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Cliente"      as C
   object ":Calculadora"  as Calc
   C -> Calc : "1: precioTotal := calcular(precioElemento, impuesto)"
   @enduml

A la parte que está a la derecha de ``:=`` se le conoce como
**firma del mensaje**.

Objetos activos
---------------

Los **objetos activos** son elementos que tienen la capacidad de
**iniciar y controlar el flujo de interacciones por sí mismos**,
a diferencia de los **objetos pasivos** que solo responden a
mensajes.

La característica principal de un objeto activo es su capacidad
de **operar de manera independiente y tener su propio hilo de
control (thread)**. Un objeto activo controla el flujo de una
secuencia y puede enviar mensajes a objetos pasivos e
interactuar con otros objetos activos.

En una biblioteca, un bibliotecario relaciona las peticiones a
partir de un patrón, verifica la información de referencia en
una base de datos, devuelve una respuesta, asigna personas para
reabastecer los libros, entre otras cosas.

.. admonition:: Ejemplo — Biblioteca moderna

 En una biblioteca, múltiples bibliotecarios realizan tareas
 simultáneas: mientras uno procesa préstamos, otro actualiza la
 base de datos y un tercero reabastece estantes — todos
 operando concurrentemente.

 La interacción entre bibliotecarios demuestra otro aspecto
 clave de la concurrencia: la **comunicación y coordinación**
 entre procesos. Por ejemplo, deben sincronizarse para evitar
 que dos bibliotecarios intenten reubicar el mismo libro o
 atender la misma solicitud.

Al proceso de que **dos o más objetos activos hagan sus tareas
al mismo tiempo** se le conoce como **concurrencia**. Trabajar
en paralelo: por ejemplo, mientras un proceso espera datos de
la red, otro puede estar realizando cálculos.

La concurrencia también introduce desafíos como la
**sincronización de recursos compartidos** y la prevención de
**condiciones de carrera** (*race conditions*). Por esto, el
diseño de sistemas concurrentes requiere una planificación
cuidadosa.

El diagrama de colaboraciones representa a un objeto activo de
la misma manera que a cualquier otro objeto, **excepto que su
borde será grueso y más oscuro**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Bibliotecario1" as B1 <<active>>
   object ":Bibliotecario2" as B2 <<active>>
   object ":BaseDeDatos"   as BD
   object ":Estante"       as E

   B1 -> BD : "1: consultarReferencia()"
   B1 -> E  : "2: ubicarLibro()"
   B2 -> BD : "3: actualizarRegistros()"
   B1 -> B2 : "4: coordinar()"
   @enduml

Sincronización
--------------

Un objeto sólo puede enviar un mensaje **después de que otros
mensajes han sido enviados**. Es decir, el objeto debe
"sincronizar" todos los mensajes en el orden debido.

- La sincronización establece el **orden específico** en que los
  mensajes deben ser enviados entre objetos durante una
  interacción.
- Garantiza que las operaciones se ejecuten en la secuencia
  correcta.
- Cuando un objeto necesita esperar a que se completen varios
  mensajes antes de poder enviar el suyo, esto se denomina
  **punto de sincronización** (*synchronization point*).
- Su propósito principal es prevenir condiciones de carrera y
  mantener la consistencia.
- La lista de elementos se separa mediante una **coma**, y
  finaliza con una **diagonal** (``/``).
- Se representa mediante una barra pequeña horizontal conectada
  a las flechas de los mensajes que deben completarse antes de
  proceder.

Suponga que sus objetos son personas en un corporativo
ocupados en la campaña de un nuevo producto:

1. El vicepresidente de comercialización pide al de ventas que
   cree una campaña.
2. El vicepresidente de ventas crea la campaña y la asigna al
   gerente.
3. El gerente de ventas instruye a un agente para que venda.
4. El agente hace llamadas a clientes en potencia.
5. **Después de que se completen los pasos 2 y 3** (esto es,
   el VP de ventas dio la comisión y el gerente expidió la
   directiva), un especialista en RP llama al periódico para
   colocar un anuncio.

En lugar de anteceder este mensaje con una etiqueta numérica,
se antecede con una lista de mensajes que tendrán que completarse
antes (sintaxis: ``2,3 / mensaje()``).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":VicepComerc"      as VC
   object ":VicepVentas"      as VV
   object ":GerenteVentas"    as GV
   object ":Vendedor"         as V
   object ":Cliente"          as C
   object ":EspecialistaRP"   as RP
   object ":Periodico"        as PER

   VC -> VV : "1: crear(campana, producto)"
   VV -> GV : "2: asignar(campana, producto)"
   GV -> V  : "3: vender(campana, producto)"
   V  -> C  : "*[clientes asignados]\n4: llamadaVentas(campana, producto)"
   RP -> PER : "2,3 / 5: colocarAnuncio(campana, producto)"
   note bottom of PER
     "2,3 / 5" indica
     sincronización: el mensaje
     5 espera a que terminen
     los mensajes 2 y 3.
   end note
   @enduml

----

Adiciones al panorama
=====================

El diagrama de colaboraciones es otro **elemento de
comportamiento**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   skinparam packageStyle rectangle

   package "UML" {
     package "Comportamiento" {
       rectangle "Casos de uso"  as CMP1
       rectangle "Estados"       as CMP2
       rectangle "Secuencias"    as CMP3
       rectangle "Colaboraciones\n(NUEVO)" as CMP4
       rectangle "Actividades"   as CMP5
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
   }
   @enduml

----

Resumen
=======

- Un diagrama de colaboraciones es **otra forma** de presentar la
  información en un diagrama de secuencias.

  - El diagrama de **secuencias** se organiza de acuerdo al
    **tiempo**.
  - El de **colaboración** de acuerdo al **espacio**.

- El diagrama muestra las **asociaciones entre objetos**, así
  como los mensajes que pasan de un objeto a otro.
- El mensaje se representa con una **flecha junto a la línea de
  asociación** y una etiqueta numerada que muestra el contenido.
- El **número** representa el turno del mensaje en la secuencia.
- Las **condicionales** se representan colocando la instrucción
  entre corchetes ``[…]``.
- Para representar un ciclo *mientras*, anteceda al corchete
  izquierdo con un asterisco: ``*[…]``.
- Algunos mensajes provienen de otros. El esquema de numeración
  representa esto como en los manuales técnicos: con un sistema
  de numeración que utiliza puntos decimales para representar
  los niveles del **anidamiento** (``2.1``, ``2.2``, ``2.2.1``).
- Los diagramas de colaboraciones le permiten modelar **varios
  objetos receptores** en una clase, ya sea que reciban o no los
  mensajes en un orden específico.
- También podrá representar **objetos activos** que controlen el
  flujo de los mensajes, así como mensajes que se sincronizan
  con otros (``2,3 / mensaje()``).

----

Preguntas y respuestas
======================

**¿Tengo que incluir a ambos diagramas (el de colaboraciones y
el de secuencias) en la mayoría de los modelos UML?**

Se recomienda hacerlo. Ambos tipos de diagramas podrán estimular
diversas ideas de los procesos durante el *segmento de análisis*.

El diagrama de **colaboraciones clarifica las relaciones entre
los objetos** debido a que incluye los vínculos. El de
**secuencia se enfoca en la secuencia de las interacciones**.

A su vez, la organización de su cliente podría incluir personas
cuya idea de los procesos podría diferir entre ellos. Cuando
tenga que presentar su modelo, un tipo de diagrama podría
comprenderse mejor para ciertas personas.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-09-diagramas-secuencias`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 10 (Schmuller, 2000)
