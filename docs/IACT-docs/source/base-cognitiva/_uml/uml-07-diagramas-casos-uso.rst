.. meta::
 :artefacto: UML_07
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-07:

==========================================
UML_07: Diagramas de casos de uso
==========================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 7.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

Los usuarios con frecuencia saben más de lo que dicen. En el
proceso de análisis el objetivo es generar una colección de casos
de uso, catalogar y hacer referencia. Estos mismos funcionarán
como un fundamento para actualizar el sistema.

----

Representación de un modelo de caso de uso
==========================================

Un actor es quien **inicia** un caso de uso, y otro actor
(posiblemente el que inició, pero no necesariamente) es quien
**recibe** algo de valor de él. La representación gráfica es
directa: una **elipse** representa a un caso de uso y una
**figura agregada** (stick figure) representa a un actor.

El actor que **inicia** se encuentra a la izquierda del caso de
uso, y el que **recibe** a la derecha. El nombre del actor
aparece justo debajo de él; el nombre del caso de uso aparecerá
ya sea dentro de la elipse o justo debajo de ella.

En UML una **línea asociativa** conecta a un actor con el caso
de uso, y representa la comunicación entre ambos.

Al analizar los casos de uso se mostrará los **confines** entre
el sistema y el mundo exterior. Generalmente, los actores están
**fuera** del sistema, mientras que los casos de uso están
**dentro** de él.

Se utiliza un **rectángulo** (con el nombre del sistema dentro)
para representar el confín del sistema; el rectángulo envuelve a
los casos de uso. Los actores, casos de uso y líneas de
interconexión componen un **modelo de caso de uso**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor "ActorIniciador" as A
   actor "ActorBeneficiario" as B
   rectangle "Sistema" {
     usecase "Caso de uso" as UC
   }
   A --> UC
   UC --> B
   @enduml

----

Una nueva visita a la máquina de gaseosas
=========================================

El caso de uso *"Comprar gaseosa"* se encuentra dentro del
sistema junto con *"Reabastecer"* y *"Recolectar dinero"*. Los
actores son el ``Cliente``, el ``Representante del proveedor`` y
el ``Recolector``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Cliente
   actor "Representante\ndel proveedor" as Proveedor
   actor Recolector

   rectangle "Máquina de Gaseosas" {
     usecase "Comprar gaseosa"      as UC1
     usecase "Reabastecer"          as UC2
     usecase "Recolectar el dinero" as UC3
   }
   Cliente    --> UC1
   Proveedor  --> UC2
   Recolector --> UC3
   @enduml

----

Secuencia de pasos en los escenarios
====================================

Cada caso de uso es una **colección de escenarios** y cada
escenario es una secuencia de pasos. Tales pasos **no aparecen
en el diagrama**, no se encuentran en notas adjuntas a los casos
de uso. UML no lo prohíbe, pero **la claridad es clave** en la
generación de cualquier diagrama.

Los diagramas de casos de uso serán, por lo general, parte de un
**documento de diseño** que el cliente y el equipo de diseño
tomarán como referencia.

*Cada diagrama tendrá su propia página*; de igual manera, *cada
escenario de caso de uso tendrá su propia página*, donde se
listará en modo de texto:

- El **actor** que inicia al caso de uso
- Las **condiciones previas** para el caso de uso
- Los **pasos** (el flujo) en el escenario
- Las **condiciones posteriores** cuando se finaliza el escenario
- El **actor que se beneficia** del caso de uso
- Las **conjeturas** del escenario (por ejemplo, que un cliente
  a la vez utilizará la máquina)
- Una **breve descripción** de una sola frase del escenario

.. tip:: Conjeturas del escenario

 Se refiere a *suposiciones* o *posibles situaciones* que pueden
 ocurrir dentro del flujo de un caso de uso. Estas representan
 *condiciones* hipotéticas que pueden afectar cómo se desarrolla
 el caso de uso, y ayudan a anticipar posibles variaciones en el
 comportamiento del sistema.

 Ayudan a anticipar y planificar para que el sistema sea robusto
 y responda correctamente a situaciones fuera del flujo
 estándar.

En su descripción, también podría poner los escenarios alternos
de manera separada (*"Sin el producto"* y *"Cambio incorrecto"*),
o podría considerarlos como excepciones al primer escenario del
caso de uso. La forma exacta de hacerlo sólo le concernirá a
usted, su cliente y los usuarios.

Para mostrar los pasos en un escenario, hay otra posibilidad:
utilizar un **diagrama de actividades UML**.

----

Concepción de las relaciones entre casos de uso
===============================================

- **Inclusión** — le permite volver a utilizar los pasos de un
  caso de uso dentro de otro.
- **Extensión** — le permite crear un caso de uso mediante la
  adición de pasos a uno existente.
- **Generalización** — un caso de uso se hereda de otro.
- **Agrupamiento** — manera sencilla de organizar los casos de
  uso.

Inclusión
---------

En los casos de uso *"Reabastecer"* y *"Recolectar dinero"*,
ambos se inician mediante la apertura de la máquina y finalizan
con el cierre y sellado de la misma. El caso de uso *"Exhibir el
interior"* se creó para capturar el primer par de pasos, y
*"Cubrir el interior"* para el segundo. Tanto *"Reabastecer"*
como *"Recolectar dinero"* incluyen este par de casos de uso.

Para representar la inclusión utilizará el símbolo que usó para
la dependencia entre clases: una **línea discontinua con una
punta de flecha** que conecta los casos de uso apuntando hacia
el caso de uso dependiente; sobre la línea agregará un
estereotipo: la palabra ``<<incluir>>`` (o ``<<include>>``)
bordeada por dos pares de paréntesis angulares.

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

Un caso de uso incluido **nunca aparecerá solo**: funciona como
parte de un caso de uso que lo incluya. El primer paso en el
caso de uso *"Reabastecer"* podría ser ``«incluir» (Exhibir el
interior)``.

Extensión
---------

En lugar de sólo reabastecer la máquina de gaseosas para que
todas las marcas tengan la misma cantidad de latas, el
representante podría anotar aquellas que se venden mejor y
reabastecer acorde con ello. Podemos decir que el nuevo caso de
uso **extiende** al original dado que *agrega otros pasos* a la
secuencia del caso de uso original, que se conoce como **el caso
de uso base**.

La extensión sólo se puede realizar en puntos indicados de manera
específica dentro de la secuencia del caso de uso base. A estos
puntos se les conoce como **puntos de extensión**.

En el caso de uso *"Reabastecer"*, los nuevos pasos (*anotar las
ventas* y *abastecer de manera acorde*) se darían luego que el
representante haya abierto la máquina y esté listo para llenar
los compartimientos de las marcas. En este ejemplo, *el punto de
extensión es* **"Llenar los compartimientos"**.

Podrá concebir la extensión con una línea de dependencia (línea
discontinua con punta de flecha), junto con un estereotipo que
muestra ``<<extender>>`` (o ``<<extend>>``) entre paréntesis
angulares; el punto de extensión aparecerá debajo del nombre del
caso de uso.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Proveedor
   actor Recolector

   rectangle "Máquina de Gaseosas" {
     usecase "Reabastecer\n.. extension points ..\nLlenar los compartimientos"  as UC2
     usecase "Reabastecer de\nacuerdo a las ventas"                             as UC2X
     usecase "Recolectar el dinero"                                             as UC3
     usecase "Exhibir el interior"                                              as UCIN
     usecase "Cubrir el interior"                                               as UCOUT
   }
   Proveedor  --> UC2
   Recolector --> UC3
   UC2X ..> UC2 : <<extend>>\n(Llenar compartimientos)
   UC2 ..> UCIN  : <<include>>
   UC2 ..> UCOUT : <<include>>
   UC3 ..> UCIN  : <<include>>
   UC3 ..> UCOUT : <<include>>
   @enduml

Generalización
--------------

Las clases se heredan entre sí; lo mismo se aplica a los casos
de uso.

En la herencia de los casos de uso, el caso de uso secundario
hereda las acciones y significado del primario, y además agrega
sus propias acciones. Puede aplicar el caso de uso secundario en
cualquier lugar donde aplique el primario.

Deberá imaginar un caso de uso *"Comprar un vaso de gaseosa"*
que se hereda de *"Comprar gaseosa"*. El caso de uso secundario
tiene acciones como *"agregar hielo"* y *"mezclar marcas de
gaseosas"*.

Modelará la generalización de casos de uso con líneas continuas
y una **punta de flecha en forma de triángulo sin rellenar** que
apunta hacia el caso de uso primario.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Cliente
   rectangle "Máquina de Gaseosas" {
     usecase "Comprar gaseosa"          as UC1
     usecase "Comprar un vaso\nde gaseosa" as UC1G
   }
   Cliente --> UC1
   Cliente --> UC1G
   UC1G --|> UC1
   @enduml

La relación también se puede establecer entre **actores**, así
como entre casos de uso. Si cambia el nombre del representante
como ``Reabastecedor``, tanto éste como el ``Recolector`` serán
secundarios del ``AgenteProveedor``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor "AgenteProveedor" as AP
   actor "Reabastecedor"   as R1
   actor "Recolector"      as R2
   AP <|-- R1
   AP <|-- R2
   @enduml

Agrupamiento
------------

Podría tener varios casos de uso que querrá organizar. Esto puede
ocurrir cuando un sistema consta de varios subsistemas. Otra
posibilidad sería cuando entrevista a los usuarios para obtener
los requerimientos de un sistema: cada requerimiento podría ser
representado como un caso de uso por separado.

Una forma de ordenar los requerimientos es por **categorías**.

La forma más directa para ordenar los casos de uso sería agrupar
en un **paquete** los casos de uso que se relacionen; un paquete
aparece como una carpeta tabular. Los casos de uso agrupados
aparecerán dentro de la carpeta.

----

Diagramas de casos de uso en el proceso de análisis
===================================================

Colocaremos los casos de uso en el contexto de un esfuerzo de
análisis. Las **entrevistas al cliente** deberán iniciar dicho
proceso. Estas entrevistas producirán los **diagramas de
clases**, que son las bases de su conocimiento para el dominio
del sistema (el área en el cual resolverá los problemas).

Una vez que conozca la terminología general del área del cliente,
estará listo para hablar con los usuarios. Las **entrevistas
con los usuarios** comienzan en la terminología del dominio,
ésta deberá alternarse hacia la **terminología de los usuarios**.

Los resultados iniciales **deberán revelar a los actores y casos
de uso de alto nivel** que describirán los requerimientos
funcionales en términos generales. Las entrevistas posteriores
con los usuarios profundizarán estos requerimientos, lo que dará
por resultado *modelos de casos de uso* que mostrarán los
escenarios y las secuencias detalladamente.

Estos modelos iniciales podrían resultar en otros casos de uso
que satisfagan las relaciones de *inclusión y extensión*.

Es importante confiar en su comprensión del dominio (a partir de
los diagramas de clases derivados de las entrevistas con el
cliente). Si no comprende adecuadamente el dominio, podría crear
demasiados casos de uso y demasiados detalles (situación que
podría obstaculizar el diseño y el desarrollo).

----

Aplicación de los modelos de caso de uso
========================================

Suponga que deberá diseñar una **red de área local (LAN)** para
una firma de consultoría. Deberá comprender la funcionalidad;
¿cómo empezaría?

Una LAN es una red de comunicaciones que una organización utiliza
en un ámbito limitado. Permite a los usuarios compartir recursos
e información.

Comprensión del dominio
-----------------------

Para dicha compresión se tiene que empezar con las entrevistas
al cliente; en la entrevista tiene que surgir el diagrama de
clases.

El diagrama de clases podría incluir las siguientes clases:
``Consultor``, ``Cliente``, ``Proyecto``, ``Propuesta``,
``Datos`` e ``Informe``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Consultor
   class Cliente
   class Proyecto
   class Propuesta
   class Datos
   class Informe

   Consultor "1..*" -- "0..*" Proyecto      : trabaja en
   Cliente   "1"    -- "0..*" Proyecto      : encarga
   Proyecto  "1"    -- "1..*" Propuesta     : produce
   Proyecto  "1"    -- "0..*" Datos         : recopila
   Proyecto  "1"    -- "1..*" Informe       : entrega
   @enduml

Comprensión de los usuarios
---------------------------

Se tiene que tener atención a los usuarios y entender los tipos
de funcionalidad. Esto se realiza mediante **entrevistas** —
nada puede sustituir a las entrevistas.

Un grupo de usuarios serán **consultores**, otros podrían ser
**oficinistas**. Entre otros usuarios en potencia se encontrarán
funcionarios corporativos, vendedores, administradores de red,
administradores de oficina y administradores de proyectos.

Sería conveniente mostrar a los usuarios en una **jerarquía de
generalización**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Empleado
   actor Consultor
   actor Oficinista
   actor "Funcionario\ncorporativo" as FC
   actor Vendedor
   actor "Administrador\nde red" as AR
   actor "Administrador\nde oficina" as AO
   actor "Administrador\nde proyectos" as AP

   Empleado <|-- Consultor
   Empleado <|-- Oficinista
   Empleado <|-- FC
   Empleado <|-- Vendedor
   Empleado <|-- AR
   Empleado <|-- AO
   Empleado <|-- AP
   @enduml

Comprensión de los casos de uso
-------------------------------

Algunas posibilidades son:

- "Establecer niveles de seguridad"
- "Crear una propuesta"
- "Almacenar una propuesta"
- "Utilizar correo electrónico"
- "Compartir información de la base de datos"
- "Realizar la contabilidad"
- "Conectarse a la LAN desde fuera de ella"
- "Conectarse a Internet"
- "Indizar las propuestas"
- "Utilizar propuestas previas"
- "Compartir impresoras"

Este conjunto de casos de uso constituye los **requerimientos
funcionales** de la LAN.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Consultor
   actor Oficinista
   actor "Admin\nde red" as AR

   rectangle "LAN — Firma de Consultoría" {
     usecase "Establecer niveles\nde seguridad"      as U1
     usecase "Crear una propuesta"                   as U2
     usecase "Almacenar una propuesta"               as U3
     usecase "Utilizar correo electrónico"           as U4
     usecase "Compartir info\nde base de datos"      as U5
     usecase "Realizar la contabilidad"              as U6
     usecase "Conectarse a la LAN\ndesde fuera"      as U7
     usecase "Conectarse a Internet"                 as U8
     usecase "Indizar las propuestas"                as U9
     usecase "Utilizar propuestas previas"           as U10
     usecase "Compartir impresoras"                  as U11
   }

   Consultor   --> U2
   Consultor   --> U3
   Consultor   --> U4
   Consultor   --> U10
   Oficinista  --> U6
   Oficinista  --> U4
   AR          --> U1
   AR          --> U7
   AR          --> U8
   AR          --> U11
   AR          --> U5
   Consultor   --> U9
   @enduml

Profundización
--------------

Determinar cuáles son los casos de uso de alto nivel y a partir
de ellos, generar el modelo detallado.

Una actividad extremadamente importante en una firma de
consultoría es la **generación de propuestas**, así que
examinemos el caso de uso *"Crear una propuesta"*.

Las entrevistas con los consultores probablemente le indicarán
cuántos pasos se necesitan en este caso de uso. El actor inicial
es un consultor.

- El consultor tiene que **iniciar una sesión** en la LAN y ser
  **verificado** como usuario válido.
- Luego tendrá que utilizar algún software integrado para oficina
  (procesador de textos, hoja de cálculo y gráficos) para
  escribir la propuesta. En el proceso, el consultor podría
  volver a utilizar **porciones de propuestas previas**.
- La firma podría tener una directiva de que un funcionario
  corporativo y otros dos consultores **revisen** una propuesta
  antes de que llegue a manos del cliente. Por lo que el
  consultor almacena la propuesta en un área central accesible
  mediante la LAN, y envía a los correos electrónicos de los tres
  revisores un mensaje que indique que la propuesta se encuentra
  lista.
- Luego de recibir los comentarios y hacer las modificaciones
  necesarias, el consultor **imprime** la propuesta y la envía
  por correo al cliente.
- Cuando todo termina, el consultor **se retira** de la red.

Ciertos pasos se repetirán de un caso de uso a otro, y ello le
llevará a otros casos de uso (posiblemente incluidos):

- *Iniciar una sesión* y *ser verificado* son dos pasos que
  pueden incluir varios casos de uso → creará un caso de uso
  ``"Verificar usuario"`` que incluye ``"Crear una propuesta"``.
- Otro par de casos de uso son ``"Utilizar software de oficina"``
  y ``"Finalizar sesión de la red"``.

Posiblemente las propuestas sean distintas para clientes nuevos y
clientes constantes; en ese caso crearía
``"Crear una propuesta para un cliente nuevo"`` que **extiende**
a ``"Crear una propuesta"``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Consultor
   actor "Funcionario\ncorporativo" as FC

   rectangle "LAN — Crear propuesta" {
     usecase "Crear una propuesta"                            as CU
     usecase "Crear una propuesta\npara un cliente nuevo"     as CUE
     usecase "Verificar usuario"                              as VU
     usecase "Utilizar software\nde oficina"                  as SO
     usecase "Finalizar sesión\nde la red"                    as FS
     usecase "Almacenar la propuesta"                         as AP
     usecase "Notificar revisores\n(correo)"                  as NR
     usecase "Imprimir y enviar\nal cliente"                  as IM
   }

   Consultor --> CU
   FC        --> NR

   CUE  ..|>  CU                : <<extend>>
   CU   ..>   VU                : <<include>>
   CU   ..>   SO                : <<include>>
   CU   ..>   AP                : <<include>>
   CU   ..>   NR                : <<include>>
   CU   ..>   IM                : <<include>>
   CU   ..>   FS                : <<include>>
   @enduml

Recuerde que **el análisis del caso de uso describe el
comportamiento de un sistema, nunca toca a la implementación**.

----

Dónde estamos
=============

En las horas 2 a la 7 ha trabajado con:

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Elemento
   - Descripción
 * - Casos de uso
   - Descripción de la funcionalidad.
 * - Clases
   - Son sustantivos, representación de algo dentro de un
     dominio.
 * - Objetos
   - Se pueden identificar por verbos, acciones o características
     específicas de algo.
 * - Interfaces
   - Son clases sólo con funciones; estas funciones se repiten
     en varias partes y se pueden implementar de muchas maneras.
     Con ellas se aplica el polimorfismo.
 * - Agregaciones
   - Relación de clases en donde cada clase puede "vivir" de
     manera independiente.
 * - Composiciones
   - La relación es un "todo" — cada clase es necesaria para que
     tenga sentido la representación del dominio.
 * - Estereotipos / Visibilidad
   - **público:** cada clase tiene acceso. **protegido:** sólo
     la primera clase de herencia tiene acceso. **privado:**
     sólo la clase donde se implementa tiene acceso.
 * - Restricciones
   - Tiene su propio lenguaje (OCL); útil cuando la restricción
     es compleja. Cosas que no se pueden hacer.
 * - Actores
   - Pueden ser personas, sistemas o el tiempo. Es quien inicia
     un caso de uso y quien se beneficia por él.
 * - Notas
   - Anotaciones específicas si un atributo tiene que cumplir
     con una normativa particular (como el CURP).
 * - Generalizaciones
   - Es la herencia de los casos de uso (o entre actores). Las
     cosas abstractas del dominio que se pueden repetir en muchas
     clases.
 * - Asociaciones
   - Es la conexión conceptual entre clases o instancias.
 * - Paquetes
   - Agrupaciones de casos de uso o de un contexto.
 * - Extensiones
   - Cuando en un caso de uso, en un comportamiento, se pueden
     hacer más cosas.
 * - Realizaciones
   - Indica el comportamiento de la funcionalidad. Va de la mano
     con la firma — cuando se dice qué se espera de una función.
 * - Inclusiones
   - Cuando un comportamiento en los casos de uso se repite en
     muchas partes.

Elementos estructurales
-----------------------

Las **clases**, **objetos**, **actores**, **interfaces** y
**casos de uso** son cinco de los elementos estructurales en
UML. Tienen diversas diferencias, pero son similares en el
sentido de que representan partes ya sea **físicas** o
**conceptuales** de un modelo.

Relaciones
----------

La **asociación**, **generalización**, **dependencia** y
**realización** son las relaciones en UML; **inclusión** y
**extensión** son dos tipos de dependencias.

Sin las relaciones, los modelos UML no serían más que listas de
elementos estructurales. Las relaciones conectan a tales
elementos y de ese modo conectan los modelos con la realidad.

Agrupamiento
------------

El **paquete** es el único elemento de agrupamiento en UML.
Permite organizar los elementos estructurales en un modelo; un
paquete puede contener cualquier tipo de elemento estructural, y
diferentes tipos a la vez.

Anotación
---------

La **nota** es el elemento de anotación de UML. Sirve para
adjuntar restricciones, comentarios, requerimientos y gráficos
explicativos a sus modelos.

Extensión
---------

Los **estereotipos** o *clichés* (cosas que se repiten) son dos
estructuras que UML proporciona para extender el lenguaje.
Permiten crear nuevos elementos además de los existentes, de
modo que pueda modelar de forma adecuada la sección de realidad.

Elementos de comportamiento
---------------------------

Muestran la forma en que las partes de un modelo (como los
objetos) cambian con el tiempo.

El panorama
-----------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   skinparam packageStyle rectangle

   package "UML" as UML {
     package "Estructurales" as STR {
       rectangle Clase
       rectangle Objeto
       rectangle Actor
       rectangle Interfaz
       rectangle "Caso de uso" as CU
     }
     package "Relaciones" as REL {
       rectangle Asociacion
       rectangle Generalizacion
       rectangle Dependencia
       rectangle Realizacion
       note bottom of Dependencia
         Inclusion / Extension
       end note
     }
     package "Agrupamiento" as AGR {
       rectangle Paquete
     }
     package "Anotacion" as ANO {
       rectangle Nota
     }
     package "Extension" as EXT {
       rectangle Estereotipo
     }
     package "Comportamiento" as COMP {
       rectangle "Casos de uso\nEstados\nSecuencias\nActividades" as CMP
     }
   }
   @enduml

----

Resumen
=======

- El **caso de uso** es una herramienta para obtener los
  requerimientos funcionales.
- Los **diagramas de casos de uso** facilitan la comunicación
  entre los analistas y los usuarios.
- En UML, el símbolo del caso de uso es una **elipse**, el
  símbolo de un actor es una **figura adjunta**; una **línea
  asociativa** conecta a un actor con el caso de uso.
- Los casos de uso están, por lo general, dentro de un
  **rectángulo** que representa el confín del sistema.
- La **inclusión** se representa por una línea de dependencia
  con un estereotipo ``«incluir»``.
- La **extensión** se representa por una línea de dependencia
  con un estereotipo ``«extender»``.
- La **generalización** (un caso de uso hereda el sentido y
  acciones de otro) se representa por la misma línea que muestra
  la herencia entre clases.
- El **agrupamiento** organiza un conjunto de casos de uso; se
  representa por el ícono del paquete.

El proceso de análisis se empieza con entrevistas con los
clientes para obtener diagramas de clases. Estos proporcionan
una base para entrevistar a los usuarios y dan por resultado un
**diagrama de casos de uso de alto nivel** que muestra los
requerimientos funcionales del sistema.

Para crear los modelos de caso de uso, **profundice en cada caso
de uso de alto nivel**. Los diagramas resultantes darán los
fundamentos para el diseño y desarrollo.

----

Preguntas y respuestas
======================

**En el diagrama de casos de uso de alto nivel no mostró las
asociaciones entre los actores y los casos de uso. ¿A qué se
debe?**

El diagrama de casos de uso de alto nivel surge en las etapas
iniciales de las entrevistas con los usuarios. En este punto,
esto es más o menos un ejercicio de **recopilación de ideas** y
el objetivo es **encontrar los requerimientos generales**, ámbito
y confines del sistema. Las asociaciones tendrán mayor sentido
cuando posteriores entrevistas con los clientes le lleven a
profundizar en cada requerimiento y que los modelos de casos de
uso tomen forma.

**¿Es importante tener en cuenta el "panorama" del UML? ¿No basta
con que sepa utilizar cada tipo de diagrama?**

Si usted comprende la organización del UML, podrá **manejar
situaciones que no haya encontrado antes**. Podrá **reconocer
cuando un elemento UML existente no haga el trabajo**, y sabrá
cómo construir uno nuevo. También **sabrá cómo crear un diagrama
híbrido** si llegara a ser la única forma de presentar claramente
un modelo.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-06-introduccion-casos-uso`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Aplicación canónica en IACT**
   - :doc:`/requisitos/casos-uso/index`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 7 (Schmuller, 2000)
