.. meta::
 :artefacto: UML_11
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-11:

==================================
UML_11: Diagramas de actividades
==================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 11.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados.

Este diagrama muestra los **pasos** en una operación o proceso.
Es muy parecido a los diagramas de flujo: muestra los pasos
(conocidos como **actividades**) así como puntos de decisión y
bifurcaciones.

----

Qué es un diagrama de actividades
=================================

Está diseñado para mostrar una **visión simplificada** de lo que
ocurre durante una operación o proceso.

Es una **extensión del diagrama de estados**: el de estados
muestra los estados de un objeto y representa las actividades
como flechas; el de actividades **resalta estas actividades**.

El procesamiento dentro de una actividad se lleva a cabo y, al
realizarse, se continúa con la siguiente.

- Cada actividad se representa por un **rectángulo con esquinas
  redondeadas**.
- Una **flecha** representa la transición de una a otra
  actividad.
- Cuenta con un **punto inicial** (círculo relleno) y un
  **punto final** (diana).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Actividad 1;
   :Actividad 2;
   stop
   @enduml

----

Decisiones
==========

Una secuencia de actividades llegará a un punto donde se realice
alguna **decisión**. Las condiciones le llevarán por un camino y
otras por otro (mutuamente exclusivas).

Puede representar un punto de decisión de dos formas:

- mostrar las rutas posibles que parten directamente de una
  actividad;
- llevar la transición hacia un **rombo** y que de allí salgan
  las rutas.

Indica la condición con una instrucción **entre corchetes** junto
a la ruta correspondiente.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Verificar valor;
   if ([valor > 0]) then (sí)
     :Procesar positivo;
   else (no)
     :Procesar negativo;
   endif
   stop
   @enduml

----

Rutas concurrentes
==================

Puede separar una transición en dos rutas que se ejecuten al
mismo tiempo (concurrentemente) y luego se reúnan.

Para representar esta división, utiliza una **línea gruesa
perpendicular** a la transición y las rutas parten de ella. Para
representar la reincorporación, ambas rutas apuntarán a otra
línea gruesa.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   fork
     :Ruta A — Actividad 1;
     :Ruta A — Actividad 2;
   fork again
     :Ruta B — Actividad 1;
     :Ruta B — Actividad 2;
   end fork
   :Reunión;
   stop
   @enduml

----

Indicaciones
============

Durante una secuencia es posible enviar una **indicación**
(*signal*). Cuando se reciba, provocará que se ejecute una
actividad.

- El **pentágono convexo** simboliza el **envío** de un evento.
- El **pentágono cóncavo** simboliza la **recepción** del evento.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Preparar mensaje;
   ->Enviar señal>
   :Esperar...;
   ->Recibir señal<
   :Procesar respuesta;
   stop
   @enduml

----

Aplicación: serie de Fibonacci
==============================

La serie ``1, 1, 2, 3, 5, 8, 13, ...`` se conoce como **serie
de Fibonacci**. Cada número es un *fib*: ``fib(1) = 1``,
``fib(2) = 1``, ``fib(3) = 2``, ... La regla: cada fib (excepto
los dos primeros) es la suma del par anterior.

Imagine que una clase ``Calculadora`` tiene la operación
``calcularFib(n)`` que muestra el enésimo fib.

Variables: ``Contador`` (control), ``Respuesta`` (resultado),
``Respuesta1`` y ``Respuesta2`` (dos fibs anteriores).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Respuesta1 := 1;
   :Contador   := 1;
   if ([n = 1]) then (sí)
     :Respuesta := Respuesta1;
     :mostrar(Respuesta, Contador);
     stop
   else ([n > 1])
     :Respuesta2 := 1;
     :Contador := 2;
     if ([n = 2]) then (sí)
       :Respuesta := Respuesta2;
       :mostrar(Respuesta, Contador);
       stop
     else ([n > 2])
       repeat
         :Respuesta := Respuesta1 + Respuesta2;
         :Contador := Contador + 1;
         if ([n = Contador]) then (sí)
           :mostrar(Respuesta, Contador);
           stop
         else ([n > Contador])
           :Respuesta1 := Respuesta2;
           :Respuesta2 := Respuesta;
         endif
       repeat while ([n > Contador])
     endif
   endif
   @enduml

----

Proceso de creación de un documento
===================================

Actividades para utilizar una aplicación de oficina y crear un
documento:

1. Abrir la aplicación para procesamiento de textos.
2. Crear un archivo.
3. Guardar el archivo con un nombre único en una carpeta.
4. Teclear el documento.
5. Si se necesitan ilustraciones, abrir la app relacionada,
   generar los gráficos y colocarlos en el documento.
6. Si se necesita una hoja de cálculo, abrir la app relacionada,
   crear la hoja y colocarla.
7. Guardar el archivo.
8. Imprimir el documento.
9. Salir de la aplicación.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Abrir procesador de textos;
   :Crear archivo;
   :Guardar con nombre único;
   :Teclear documento;
   if ([necesita ilustraciones]) then (sí)
     :Abrir app de gráficos;
     :Generar gráficos;
     :Insertar en documento;
   endif
   if ([necesita hoja de cálculo]) then (sí)
     :Abrir app de hoja de cálculo;
     :Crear hoja;
     :Insertar en documento;
   endif
   :Guardar archivo;
   :Imprimir documento;
   :Salir de la aplicación;
   stop
   @enduml

----

Marcos de responsabilidad
=========================

El diagrama de actividades puede expandirse y mostrar **quién
tiene la responsabilidad** en un proceso.

Caso: firma de consultoría y proceso de negociación con un
cliente.

1. Un vendedor llama al cliente y concierta una cita.
2. Si la cita es en la oficina del consultor, los técnicos
   corporativos preparan una sala de conferencias para la
   presentación.
3. Si es en la oficina del cliente, un consultor prepara una
   presentación en una laptop.
4. El consultor y el vendedor se reúnen con el cliente.
5. El vendedor crea una minuta.
6. Si la reunión planteó la solución de un problema, el
   consultor crea una propuesta y la envía al cliente.

Para visualizar responsabilidades se separa el diagrama en
segmentos paralelos conocidos como **marcos de responsabilidad**
(*swimlanes*). Cada marco muestra el nombre de un responsable en
la parte superior y presenta sus actividades.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   |Vendedor|
   start
   :Llamar al cliente;
   :Concertar cita;
   if ([cita]) then (oficina consultor)
     |Técnicos corporativos|
     :Preparar sala\nde conferencias;
   else (oficina cliente)
     |Consultor|
     :Preparar presentación\nen laptop;
   endif
   |Vendedor|
   :Reunirse con cliente;
   |Consultor|
   :Reunirse con cliente;
   |Vendedor|
   :Crear minuta;
   |Consultor|
   if ([solución requerida]) then (sí)
     :Crear propuesta;
     :Enviar al cliente;
   endif
   stop
   @enduml

----

Diagramas híbridos
==================

Un diagrama híbrido contiene símbolos de diferentes tipos.

En el diagrama de creación de documento, se podría depurar la
actividad de impresión: en lugar de sólo mostrar *"Imprimir
documento"*, se transmite una señal a un objeto ``Impresora``
que la recibe y la imprime.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   start
   :Guardar archivo;
   ->Enviar a impresora>
   stop

   note right
     La impresora recibe la señal
     y ejecuta la impresión.
   end note
   @enduml

Otra posibilidad: mostrar un diagrama de actividades para una
operación **dentro de un símbolo de objeto**, y el objeto que
recibe una petición para ejecutar la operación:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   allowmixing
   actor Usuario
   object Calculadora
   Usuario -> Calculadora : calcularFib(n)
   note right of Calculadora
     (interior)
     start \n Respuesta1 := 1 \n
     Contador := 1 \n ... \n
     mostrar(Respuesta, Contador) \n stop
   end note
   @enduml

----

Adiciones al panorama
=====================

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   skinparam packageStyle rectangle
   package "UML" {
     package "Comportamiento" {
       rectangle "Casos de uso"
       rectangle "Estados"
       rectangle "Secuencias"
       rectangle "Colaboraciones"
       rectangle "Actividades\n(NUEVO)" as ACT
     }
   }
   @enduml

----

Resumen
=======

- El diagrama de actividades muestra los **pasos**, **puntos de
  decisión** y **bifurcaciones**. Es útil para representar
  operaciones de un objeto y procesos de negocios.
- Es una **extensión del diagrama de estados** — los de estados
  destacan estados, los de actividad destacan actividades.
- Cada actividad se representa como un rectángulo con esquinas
  redondeadas. Mismos símbolos que el de estados para inicio
  y final.
- Cuando una ruta se divide en dos o más, tal dispersión se
  representa con una **línea gruesa perpendicular**, y se reúne
  en una línea similar.
- Puede mostrar una **señal**: transmisión = pentágono convexo,
  recepción = pentágono cóncavo.
- Puede representar las actividades por **responsabilidad**
  asignada (**marcos de responsabilidad** / *swimlanes*).
- Es posible combinar con símbolos de otros diagramas =
  **diagramas híbridos**.

----

Preguntas y respuestas
======================

**¿Realmente lo necesito?**

Recomendado en su análisis: pueden poner en claro algunos
procesos para usted y sus clientes, son muy útiles para los
desarrolladores. Un buen diagrama de actividades es de gran
utilidad para que un desarrollador codifique una operación.

**¿UML establece limitaciones en los tipos de híbridos?**

No. UML no intenta ser restrictivo: tiene algunas reglas
sintácticas, pero la idea es que los analistas generen un
modelo que transmita una idea consistente.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-10-diagramas-colaboraciones`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 11 (Schmuller, 2000)
