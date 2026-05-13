.. meta::
 :artefacto: UML_13
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-13:

==================================
UML_13: Diagramas de distribución
==================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 13.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados.

Es momento de concentrarnos en el **hardware**: un tema
primordial en un sistema de varios componentes. Un sistema
podría abarcar diversos tipos de plataformas en ubicaciones
dispersas, y un diseño sólido de distribución de hardware es
básico para el diseño del sistema.

----

Qué es un diagrama de distribución
==================================

El elemento primordial del hardware es un **nodo**: un nombre
genérico para todo tipo de **recurso de cómputo**.

Existen dos tipos de nodos:

- **Procesador** — puede ejecutar un componente.
- **Dispositivo** — no lo ejecuta; tiene contacto de alguna
  forma con el mundo exterior (impresora, monitor, etc.).

En UML, un **cubo** representa a un nodo. Asigne un nombre y
puede utilizar un **estereotipo** para indicar el tipo de
recurso.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "ServidorWeb" <<procesador>> as SW
   node "Impresora"   <<dispositivo>> as P
   @enduml

Si el nodo es parte de un paquete, su nombre puede contener
también el del paquete.

Se puede dividir al cubo en compartimientos que agreguen
información (componentes colocados en el nodo):

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "ServidorWeb" as SW {
     component "Apache"        as Ap
     component "PHP runtime"   as PHP
     component "App de cliente" as App
   }
   @enduml

Otra forma de indicar los componentes distribuidos es mostrarlos
en relaciones de **dependencia** con un nodo:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "ServidorWeb" as SW
   component "Apache"      as Ap
   component "PHP runtime" as PHP
   SW <.. Ap  : <<deploys>>
   SW <.. PHP : <<deploys>>
   @enduml

Una **línea** que asocie a dos cubos representa una **conexión**
entre ellos. No necesariamente un cable: también puede ser una
conexión inalámbrica (infrarroja, satelital, etc.).

Puede usar un **estereotipo** para dar información respecto a la
conexión:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "Cliente"    as C
   node "Servidor"   as S
   node "BD Server"  as DB
   node "Impresora"  as P

   C  -- S  : <<HTTPS>>
   S  -- DB : <<TCP/IP — JDBC>>
   C  -- P  : <<USB>>
   S  .. P  : <<inalambrica IR>>
   @enduml

La conexión es el tipo común de asociación entre dos nodos, pero
es posible utilizar otros (como **agregación** o **dependencia**)
y representarlos de las formas ya conocidas.

----

Aplicación de los diagramas de distribución
===========================================

Un equipo doméstico
-------------------

Para modelar un equipo de cómputo doméstico, incluimos el
procesador y los dispositivos, y también la conexión telefónica
con el proveedor de servicios de Internet.

  La nube que representa Internet **no es parte** de la
  simbología UML, pero es útil para clarificar el modelo.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "PC Hogar"      <<procesador>> as PC
   node "Monitor"       <<dispositivo>> as MON
   node "Teclado"       <<dispositivo>> as TEC
   node "Ratón"         <<dispositivo>> as RAT
   node "Impresora"     <<dispositivo>> as IMP
   node "Modem ADSL"    <<dispositivo>> as MOD
   cloud "Internet"                     as NET
   node "Proveedor ISP" <<procesador>>  as ISP

   PC  -- MON : <<HDMI>>
   PC  -- TEC : <<USB>>
   PC  -- RAT : <<USB>>
   PC  -- IMP : <<USB>>
   PC  -- MOD : <<Ethernet>>
   MOD -- NET : <<ADSL>>
   NET -- ISP
   @enduml

Una red token-ring
------------------

En una red **token-ring**, las computadoras equipadas con una
**NIC** (tarjeta de interfaz de red) se conectan a una **MSAU**
(unidad central de acceso a multi estaciones). Se conectan
varias MSAU en serie que forma un anillo.

El anillo de MSAU se combina para fungir como un policía de
tránsito mediante una señal conocida como **token** que permite
a cada equipo saber cuándo puede transmitir información. El
token va de equipo en equipo hasta que uno de ellos contenga
información por enviar. Cuando se obtiene el token, sólo esa
información puede ir por la red.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "MSAU 1" as M1
   node "MSAU 2" as M2
   node "MSAU 3" as M3

   node "PC 1" <<procesador>> as P1
   node "PC 2" <<procesador>> as P2
   node "PC 3" <<procesador>> as P3
   node "PC 4" <<procesador>> as P4
   node "PC 5" <<procesador>> as P5

   M1 -- M2 : <<token>>
   M2 -- M3 : <<token>>
   M3 -- M1 : <<token>>

   M1 -- P1 : <<NIC>>
   M1 -- P2 : <<NIC>>
   M2 -- P3 : <<NIC>>
   M3 -- P4 : <<NIC>>
   M3 -- P5 : <<NIC>>
   @enduml

ARCnet
------

Una red **ARCnet** (*Attached Resource Computer Network*)
implica pasar un *token* o señal de un equipo a otro. La
diferencia es que en ARCnet **cada equipo tiene asignado un
número** y el orden numérico determina cuál equipo obtendrá el
token.

Cada equipo se conecta a un **concentrador** (*hub*) que puede
ser **activo** (amplifica la información) o **pasivo**
(transmite sin amplificar). A diferencia de los MSAU, los
concentradores ARCnet **no mueven el token en un anillo**; los
equipos se lo pasan entre sí.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "Hub Activo"  <<dispositivo>> as HA
   node "Hub Pasivo"  <<dispositivo>> as HP

   node "PC 1 (id=1)" <<procesador>> as P1
   node "PC 2 (id=2)" <<procesador>> as P2
   node "PC 3 (id=3)" <<procesador>> as P3
   node "PC 4 (id=4)" <<procesador>> as P4

   HA -- HP : <<cable>>
   HA -- P1
   HA -- P2
   HP -- P3
   HP -- P4

   note bottom of HA
     El token se pasa entre
     equipos en orden numérico
     (1 → 2 → 3 → 4 → 1).
   end note
   @enduml

Thin ethernet
-------------

Los equipos se conectan a un cable de red mediante dispositivos
conocidos como **conectores T**. Un segmento de red puede unirse
a otro mediante un **repetidor**, dispositivo que amplifica una
señal antes de transmitirla.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "PC 1" <<procesador>> as P1
   node "PC 2" <<procesador>> as P2
   node "PC 3" <<procesador>> as P3
   node "PC 4" <<procesador>> as P4
   node "Repetidor" <<dispositivo>> as R
   node "PC 5" <<procesador>> as P5
   node "PC 6" <<procesador>> as P6

   P1 -- P2 : <<conector T>>
   P2 -- P3 : <<conector T>>
   P3 -- P4 : <<conector T>>
   P4 -- R  : <<coaxial>>
   R  -- P5 : <<coaxial>>
   P5 -- P6 : <<conector T>>
   @enduml

Red inalámbrica Ricochet de Metricom
------------------------------------

**Metricom** ofrece una solución inalámbrica por módem para
acceso móvil a Internet. Su **módem inalámbrico** se conecta al
puerto serial de un equipo y se comunica con la red Ricochet.

La red Ricochet consta de transmisores y receptores de radio del
tamaño de una caja de zapatos. Estos **radios de microceldilla**
se montan en la parte superior de los postes de luz a distancias
de 400 a 800 metros, en patrón de tablero de ajedrez. Cada radio
obtiene una pequeña cantidad de energía del poste si se equipa
con un adaptador especial.

Los radios de microceldilla difunden señales a **Puntos de
acceso cableados** que llevan la información a un **NIF**
(*Network Interconnection Facility*).

El NIF consta de un **servidor de nombres** (BD que valida las
conexiones), un **enrutador** (enlaza redes entre sí) y una
**puerta de enlace** (traduce la información de un protocolo a
otro). La información se lleva del NIF a Internet.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "Laptop" <<procesador>> as L
   node "Modem inalambrico" <<dispositivo>> as M
   node "Radio microceldilla 1" <<dispositivo>> as R1
   node "Radio microceldilla 2" <<dispositivo>> as R2
   node "Punto de acceso cableado" <<dispositivo>> as PA

   node "NIF" {
     component "Servidor de nombres" as SN
     component "Enrutador"           as RT
     component "Puerta de enlace"    as GW
   }

   cloud "Internet" as NET

   L  -- M  : <<serial>>
   M  -- R1 : <<RF>>
   M  -- R2 : <<RF>>
   R1 -- PA : <<RF>>
   R2 -- PA : <<RF>>
   PA -- SN : <<cable>>
   SN -- RT
   RT -- GW
   GW -- NET
   @enduml

----

Los diagramas de distribución en el panorama
============================================

El panorama del UML queda finalizado al incluir el diagrama de
distribución.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   skinparam packageStyle rectangle
   package "UML — panorama completo" {
     package "Estructurales" {
       rectangle Clase
       rectangle Objeto
       rectangle Actor
       rectangle Interfaz
       rectangle "Caso de uso"
       rectangle Componente
       rectangle "Nodo\n(NUEVO)" as NODO
     }
     package "Comportamiento" {
       rectangle "Casos de uso"
       rectangle "Estados"
       rectangle "Secuencias"
       rectangle "Colaboraciones"
       rectangle "Actividades"
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

- El diagrama de distribución ilustra la forma en que luce un
  sistema **físicamente** cuando es conjugado.
- Un sistema consta de **nodos**; cada nodo se representa por un
  **cubo**.
- Una **línea** asocia a dos cubos y simboliza una **conexión**
  entre ellos.
- Los tipos de nodos son **procesador** (puede ejecutar un
  componente) y **dispositivo** (no lo puede hacer; los
  dispositivos por lo general interactúan con el mundo).
- Los diagramas de distribución son útiles para modelar **redes**.

----

Preguntas y respuestas
======================

**¿Un modelador puede utilizar símbolos que no están en la
simbología?**

Así es. La idea es utilizar UML para expresar una visión. En
ninguna parte esto es tan útil como en los diagramas de
distribución. Si tiene una imagen que pueda mostrar claramente
los equipos de escritorio, portátiles, servidores y otros
procesadores (o dispositivos), podrá utilizarlos. Estará creando
un **estereotipo gráfico**.

  Curiosidad: el símbolo de la nube es una nota al margen
  interesante. Uno de los creadores del UML, **Grady Booch**,
  solía representar objetos como nubes en la simbología de su
  esquema antes de que se convirtiera en parte del equipo UML.

**Suponga que cuenta con una gran cantidad de figuras para
representar a ciertos objetos. ¿Se pueden mezclar con los
símbolos del UML?**

El objeto es dibujar diagramas para clarificar una visión, no
para nublarla.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-12-diagramas-componentes`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 13 (Schmuller, 2000)
