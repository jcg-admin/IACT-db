.. meta::
 :artefacto: UML_12
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-12:

==================================
UML_12: Diagramas de componentes
==================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 12.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados.

----

Qué es un componente
====================

Un **componente de software** es una parte **física** de un
sistema, y se encuentra en la computadora. ¿Qué puede tomarse
como componente? Una tabla, archivo de datos, ejecutable,
biblioteca de vínculos dinámicos, documentos.

Un componente es la **personificación en software de una
clase**. La clase representa una abstracción de un conjunto de
atributos y operaciones. Un componente puede ser la
implementación de **más de una** clase.

Se modelan los componentes y sus relaciones para que:

1. Los **clientes** puedan ver la estructura del sistema
   finalizado.
2. Los **desarrolladores** cuenten con una estructura con la
   cual trabajar.
3. Quienes escriban las notas técnicas y la **documentación**
   puedan entender de qué escribirán.
4. Usted se aliste para **volver a utilizar** los componentes.

Uno de los aspectos más importantes de los componentes es el
potencial que tienen de **volver a ser utilizados**. Entre más
rápido presente un sistema para producción, *mayor será su
competitividad*. Si puede crear un componente para un sistema y
volver a utilizarlo en otro, contribuirá a esa competitividad.

  Tómese el tiempo y esfuerzo para **modelar un componente** que
  ayude a que esta reutilización pueda llevarse a cabo.

----

Componentes e interfaces
========================

Cuando trate con los componentes, tendrá que tratar con sus
**interfaces**.

Un objeto **oculta al mundo exterior** lo que hace
(*encapsulation*). Pero tiene que presentar un *"rostro"* al
mundo exterior para que puedan pedirle que ejecute sus
operaciones. A este *"rostro"* se le conoce como **interfaz**.

Diversas clases podrían no estar relacionadas con una clase
principal (como en la herencia), pero sus *acciones* podrían
incluir algunas de las **mismas operaciones con las mismas
firmas**. La interfaz le permite **reutilizar un conjunto de
operaciones** de clase en clase.

Una interfaz es un **conjunto de operaciones** que especifica
algo respecto al **comportamiento de una clase**; es como una
clase que sólo contiene operaciones (no atributos).

La interfaz que **utiliza una clase es la misma que la que
utiliza su implementación de software** (un componente). De la
misma forma en que represente una interfaz para una clase, la
representará para un componente. La simbología de UML
**distingue** entre una clase y un componente, pero **no
distingue** entre una interfaz conceptual y una física.

Sólo podrá ejecutar las operaciones de un componente a través
de su interfaz. La relación entre un componente y su interfaz
se conoce como **realización**.

Interfaces de exportación e importación
---------------------------------------

Un componente puede hacer disponible su interfaz para que otros
componentes puedan utilizar sus operaciones. El componente que
proporciona los servicios se dice que **provee una interfaz de
exportación**.

Un componente puede **acceder a los servicios** de otro
componente mediante la interfaz. Al componente que accede a los
servicios se dice que **utiliza una interfaz de importación**.

Cuando un componente **ofrece servicios** (el que "da"), está
proporcionando una **interfaz de exportación**. El componente
**realiza** o implementa la interfaz: se compromete a
proporcionar todas las operaciones definidas. **HACE DISPONIBLE
(exporta)** sus operaciones para que otros componentes puedan
utilizarlas. Es como si dijera *"estos son los servicios que
puedo ofrecer a quien los necesite"*.

Cuando un componente **necesita servicios** de otros (el que
"recibe"), utiliza una **interfaz de importación**. Es una
**relación de dependencia**: el componente accede a servicios
externos. Sólo necesita conocer la interfaz, no la
implementación específica. Es como si dijera *"necesito que
alguien me proporcione estas funcionalidades"*.

Piénselo como una relación de **proveedor-consumidor**: algunos
componentes son proveedores (*exportan interfaces*); otros son
consumidores (*importan interfaces*). Esta estructura — donde
un componente implementa la interfaz (realización) y otro la usa
(dependencia) — es lo que permite el **polimorfismo**: podemos
intercambiar diferentes implementaciones sin tener que modificar
el código de los componentes que las usan.

----

Sustitución y reutilización
===========================

A través del uso de interfaces se obtienen importantes
beneficios de **reutilización y mantenimiento**.

- Un componente puede ser **sustituido** por otro nuevo siempre
  que **contenga las mismas interfaces** que el anterior, lo
  que asegura que los componentes que dependían del anterior
  sigan funcionando sin cambios.
- Un componente puede ser **reutilizado** en otro sistema
  siempre que éste pueda **acceder al componente mediante sus
  interfaces**.

Para potenciar esta reutilización en futuros proyectos, es
crucial diseñar el componente **depurando cuidadosamente sus
interfaces**, asegurando que un amplio rango de componentes
puedan acceder a ellos.

Este proceso se simplifica significativamente cuando **la
información de su interfaz se encuentra disponible como un
modelo**, evitando que los desarrolladores tengan que invertir
tiempo en rastrear y analizar el código fuente.

----

Tipos de componentes
====================

Existen tres tipos de componentes:

1. **Componentes de distribución** — conforman el fundamento de
   los sistemas ejecutables (DLL, ejecutables, controles
   ActiveX, Java Beans).
2. **Componentes para trabajar en el producto** — a partir de
   los cuales se han creado los componentes de distribución
   (archivos de base de datos y de código).
3. **Componentes de ejecución** — creados como resultado de un
   sistema en ejecución.

Si es usuario de Windows, encontrará ejemplos de los tres tipos
cuando utilice la **ayuda**:

- El componente de **distribución** es el archivo ``.HLP``
  (Archivo de Ayuda).
- Un archivo ``.CNT`` (tema de contenido) describe el esquema
  del contenido — es un componente para **trabajar en el
  producto**.
- El índice creado se encuentra en un archivo ``.FTS`` (búsqueda
  de texto completo). El archivo ``.GID`` (índice general) se
  crea la primera vez que abre la ayuda — son componentes de
  **ejecución**.

----

Qué es un diagrama de componentes
=================================

Un diagrama de componentes contiene **componentes**,
**interfaces** y **relaciones**. Pueden aparecer otros tipos de
símbolos.

Representación de un componente
-------------------------------

El símbolo principal es un **rectángulo que tiene otros dos
rectángulos pequeños sobrepuestos en su lado izquierdo**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   component "MiComponente" as C
   @enduml

Si el componente es miembro de un **paquete**, puede usar el
nombre del paquete como prefijo. También puede agregar
información que muestre algún detalle del componente, como las
clases que implementa.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   package "Editor" {
     component "Editor.exe" as Ed {
       component "Documento"    as Doc
       component "Vista"        as Vis
       component "Controlador"  as Ctrl
     }
   }
   @enduml

Otra forma de mostrar las clases que implementa un componente
(aunque por lo general desordena el diagrama):

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   component "Editor.exe" as Ed
   class Documento
   class Vista
   class Controlador
   Ed ..> Documento  : <<implements>>
   Ed ..> Vista       : <<implements>>
   Ed ..> Controlador : <<implements>>
   @enduml

Cómo representar las interfaces
-------------------------------

Tiene **dos formas** de representar a un componente y sus
interfaces:

**Primera forma** — la interfaz como un rectángulo que contiene
la información, conectado al componente por una **línea
discontinua y una punta de flecha de triángulo sin rellenar**
(realización):

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   interface IEditable {
     + abrir()
     + guardar()
     + cerrar()
   }
   component "Editor.exe" as Ed
   Ed ..|> IEditable
   @enduml

**Segunda forma** — la interfaz como un **pequeño círculo**
(*lollipop*) conectado al componente por una **línea continua**.
Aquí la línea representa la realización:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   component "Editor.exe" as Ed
   () "IEditable" as I
   Ed -- I
   @enduml

Además de la realización, puede representar la **dependencia**
(relación entre un componente y una **interfaz de importación**).
La dependencia se vislumbra como una **línea discontinua con una
punta de flecha**.

Puede mostrar **realización y dependencia en el mismo diagrama**:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   component "Editor.exe"   as Ed
   component "Impresora.dll" as Imp
   () "IEditable"   as IE
   () "IImprimible" as II

   Ed -- IE              : (realiza)
   Ed ..> II             : <<usa>> (depende)
   Imp -- II             : (realiza)
   @enduml

----

Aplicación de los diagramas de componentes
==========================================

Una página Web con un applet Java
---------------------------------

Modela un programa con un *applet* que ejecuta el juego de dados
*Craps* en una página Web, usando una clase ``Die`` (para crear
los dados).

Archivos en el directorio ``Tirodedados``:

- ``Craps.html`` — página Web.
- ``Craps.java`` — código fuente del applet.
- ``Craps.class`` — código objeto (componente).
- ``Die.java`` — código fuente de la clase Die.
- ``Die.class`` — código objeto.

``Craps.html`` depende de ``Craps.class`` y ``Die.class``. Cada
``.class`` es un componente y cada uno es la implementación de
una clase.

Tanto ``Craps.java`` como ``Die.java`` **importan** ``java.awt``,
un grupo de clases que muestran y controlan la GDI. Y
``Craps.java`` es un applet, por lo que se hereda desde
``java.applet.Applet``. Finalmente, ``Craps.java`` importa
``java.awt.event`` e implementa la interfaz ``ActionListener``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   package "Tirodedados" {
     component "Craps.html"  as HTML
     component "Craps.class" as CC
     component "Craps.java"  as CJ
     component "Die.class"   as DC
     component "Die.java"    as DJ
   }

   package "JDK" {
     component "java.awt"        as AWT
     component "java.awt.event"  as AWTE
     component "java.applet.Applet" as APPLET
     interface ActionListener as AL
   }

   HTML ..> CC : <<usa>>
   HTML ..> DC : <<usa>>

   CJ ..> AWT  : <<importa>>
   DJ ..> AWT  : <<importa>>

   CJ ..> AWTE   : <<importa>>
   CJ ..|> AL    : <<implements>>
   CJ --|> APPLET
   @enduml

  Generar un modelo a partir de un código existente se conoce
  como **ingeniería inversa**.

Una página Web con controles ActiveX
------------------------------------

ActiveX es el medio de Microsoft para agregar componentes a las
aplicaciones. Una propiedad de un componente ActiveX es su número
de identificación hexadecimal único de 32 bits, conocido como
**CLSID** (identificador de la clase).

En las páginas Web, los componentes ActiveX se encuentran y
trabajan con código escrito en algún lenguaje de scripting como
**VBScript**.

En este ejemplo, la página Web cuenta con un control Timer, dos
cuadros combinados y tres botones ActiveX. La página permite
animar el movimiento de una esfera (imagen ``.gif``).

Los controles ActiveX se encuentran en un componente separado
conocido como **Disposición** (*Layout*). La página HTML y la
disposición están en el mismo directorio.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   package "Anim" {
     component "Anim.html" as HTML
     component "Layout.alx" as LAY
   }

   package "ActiveX Controls" {
     component "Timer"      as T
     component "ComboBox 1" as CB1
     component "ComboBox 2" as CB2
     component "Boton Iniciar" as B1
     component "Boton Detener" as B2
     component "Boton Reset"   as B3
   }

   note right of HTML
     <<VBScript>>
     Lenguaje de scripting que
     coordina los controles
     ActiveX. Mostrado como
     anotación porque no es un
     componente compilado.
   end note

   HTML ..> LAY : <<contiene>>
   LAY ..> T    : <<contiene>>
   LAY ..> CB1
   LAY ..> CB2
   LAY ..> B1
   LAY ..> B2
   LAY ..> B3
   @enduml

PowerToys (TweakUI)
-------------------

Microsoft tiene un paquete llamado **PowerToys** que permite
hacer varias cosas con la GUI mediante una aplicación llamada
``TweakUI``.

Cuando lo descomprime, verá varios archivos con extensiones
``.dll``, un archivo de ayuda y un ``.CNT``. Hacer clic en el
archivo de ayuda generará un ``.GID``. Utilizar la característica
*Buscar* creará un ``.FTS``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   package "PowerToys" {
     component "TweakUI.exe"  as EXE
     component "TweakUI.dll"  as DLL
     component "TweakUI.hlp"  as HLP <<distribución>>
     component "TweakUI.cnt"  as CNT <<trabajo>>
     component "TweakUI.gid"  as GID <<ejecución>>
     component "TweakUI.fts"  as FTS <<ejecución>>
   }

   EXE ..> DLL : <<usa>>
   EXE ..> HLP : <<abre>>
   HLP ..> CNT : <<lee>>
   HLP ..> GID : <<genera>>
   HLP ..> FTS : <<genera>>
   @enduml

----

Diagramas de componentes en el panorama
=======================================

El diagrama de componentes se enfoca en una **arquitectura de
software del sistema**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   skinparam packageStyle rectangle
   package "UML" {
     package "Estructurales" {
       rectangle Clase
       rectangle Objeto
       rectangle Actor
       rectangle Interfaz
       rectangle "Caso de uso" as CU
       rectangle "Componente\n(NUEVO)" as CMP
     }
     package "Comportamiento" {
       rectangle "Casos de uso"
       rectangle "Estados"
       rectangle "Secuencias"
       rectangle "Colaboraciones"
       rectangle "Actividades"
     }
   }
   @enduml

----

Resumen
=======

- El diagrama de componentes UML representa un **elemento real**:
  un componente de software. Estos componentes se encuentran en
  las computadoras.
- Un componente puede accederse a través de su **interfaz**, una
  colección de operaciones. La relación entre un componente y
  su interfaz se llama **realización**.
- Un componente puede acceder a los servicios de otro mediante
  una **interfaz de importación**. El componente que realiza la
  interfaz proporciona una **interfaz de exportación**.
- La representación de un componente es un **rectángulo con
  otros dos rectángulos pequeños sobrepuestos** en su lado
  izquierdo.
- Una interfaz se representa de **dos formas**:

  - Rectángulo que contiene información de la interfaz,
    conectado con el componente mediante una línea discontinua
    con flecha de triángulo sin relleno.
  - **Pequeño círculo** (*lollipop*) conectado al componente con
    una línea continua.

----

Preguntas y respuestas
======================

**En un diagrama de componentes, ¿cuál es la regla de oro para
usar símbolos que no representen a componentes?**

Esto lo hará cuando desee indicar algo que sea ciertamente
distinto de un componente compilado. No es necesario, pero
podría ayudar a tener otro punto de vista. Podría utilizar el
símbolo de la **anotación** para representar archivos de
encabezado, ``.dll`` o archivos de scripting. Otra posibilidad:
el símbolo regular del componente con un **estereotipo** que
indique el tipo de archivo.

**El código de VBScript consta de varios procedimientos. ¿No
podría modelar cada uno como componente?**

Sí, podría. No obstante, podría desordenar su modelo si depurara
al VBScript (o JavaScript) hasta tal nivel; podría, mejor,
agregar una nota.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-11-diagramas-actividades`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 12 (Schmuller, 2000)
