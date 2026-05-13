.. meta::
 :artefacto: UML_08
 :tipo: Guia
 :dominio: base_cognitiva
 :subdominio: _uml
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

.. _uml-08:

==================================
UML_08: Diagramas de estados
==================================

.. note::

 Material adaptado de *Aprendiendo UML en 24 horas* — Hora 8.
 Diagramas re-creados con PlantUML usando los estilos
 centralizados del proyecto.

¿Cómo modificar los procedimientos con el tiempo?

El **elemento de comportamiento** muestra la forma en que las
partes de un modelo UML cambian con el tiempo. Esto se muestra
en el **diagrama de estados**.

Al pasar el tiempo y conforme suceden las cosas, hay cambios que
afectan a los objetos que nos rodean. Conforme el sistema
interactúa con los usuarios y (posiblemente) con otros sistemas,
los objetos que lo conforman pasarán por los cambios necesarios
para ajustar las interacciones.

----

Qué es un diagrama de estados
=============================

Una manera para caracterizar un cambio en un sistema es que los
objetos que lo componen modifiquen su **estado** como respuesta
a los sucesos y al tiempo. Por ejemplo: cuando presiona un botón
de un control remoto, una televisión cambia su estado para
mostrarle un canal u otro. Luego de un lapso adecuado, una
lavadora cambia su estado de *"lavar"* a *"enjuagar"*.

El diagrama de estados UML captura este tipo de cambios.
**Presenta los estados** en los que puede encontrarse *un objeto*
junto con **las transiciones** entre los estados, y muestra los
puntos inicial y final de una secuencia de cambios de estado.

Un diagrama de estados también se conoce como un **motor de
estado** (state machine). Es intrínsecamente distinto a los
diagramas que ya ha visto, que modelan el comportamiento de un
sistema o al menos de un grupo.

  Un diagrama de estados muestra los cambios presentes de **un
  solo objeto**.

----

Simbología
==========

El **rectángulo de vértices redondeados** representa a un
estado, junto con una **línea continua y una punta de flecha** que
representan a una transición. La punta de la flecha apunta hacia
el estado donde se hará la transición. El **círculo relleno**
simboliza un punto inicial, y la **diana** (círculo con un punto
relleno dentro) representa a un punto final.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> EstadoA
   EstadoA --> EstadoB
   EstadoB --> [*]
   @enduml

Adición de detalles al ícono de estado
--------------------------------------

UML le da la opción de agregar detalles a la simbología: es
posible dividir un símbolo de estado en tres áreas (similar al
símbolo de clase: nombre, atributos y operaciones).

- El **área superior** contendrá el nombre del estado (que tiene
  que establecerse exista o no la subdivisión).
- El **área central** contendrá las **variables de estado**
  (cronómetros, contadores).
- El **área inferior** las **actividades**.

Las actividades constan de **sucesos y acciones**. Tres de las
más utilizadas son:

- **entrada** (``entry``) — qué sucede cuando el sistema entra
  al estado.
- **salida** (``exit``) — qué sucede cuando el sistema sale del
  estado.
- **hacer** (``do``) — qué sucede cuando el sistema está en el
  estado.

Puede agregar otras si es necesario.

Cuando se envía un fax — esto es, cuando se encuentra en estado
de *Envío de fax* — la máquina anota la fecha y hora en que
inició el envío (los valores de las variables de estado
``fecha`` y ``hora``), y también anota su número telefónico así
como el nombre del propietario (``telefono`` y ``propietario``).
Al encontrarse en este estado, la máquina se encarga de agregar
un registro de fecha y hora al fax. En otras actividades, la
máquina jala las hojas, pagina el fax y finaliza la transmisión.
Mientras se encuentre en el estado de *Inactividad*, la máquina
muestra la fecha y la hora en una pantalla.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state "Inactividad" as INA {
     INA : do / mostrarFechaYHora
   }

   state "Envío de fax" as ENV {
     ENV : fecha
     ENV : hora
     ENV : telefono
     ENV : propietario
     ENV : ---
     ENV : entry / registrarFechaYHora
     ENV : do / jalarHojas, paginar, transmitir
     ENV : exit / mostrarConfirmacion
   }

   [*]  --> INA
   INA  --> ENV : iniciarEnvio
   ENV  --> INA : finTransmision
   @enduml

----

Sucesos y acciones
==================

Puede agregar ciertos detalles a las líneas de transición. Puede
indicar **un suceso** que provoque una transición (desencadenar
un suceso), y la *actividad de cómputo* (la **acción**) que se
ejecute y haga que suceda la modificación del estado. Los
sucesos y acciones se escriben cerca de la línea de transición,
con una **diagonal** (``/``) para separar un suceso desencadenado
de una acción.

En ocasiones un evento causa una transición *sin una acción
asociada*, y algunas veces una transición sucede dado que *un
estado finaliza una actividad* (en lugar de hacerlo por un
suceso). Este tipo de transición se le conoce como **transición
no desencadenada**.

.. note:: Conceptos clave

 - **Transición:** cambio o paso de un estado a otro.
 - **Suceso (Evento):** algo que **OCURRE** y puede hacer que el
   sistema cambie de estado. *Dispara una transición*.

   - Un cliente presiona un botón
   - Llega un mensaje
   - Se alcanza cierta temperatura
   - El tiempo de espera expira

 - **Acción:** una **OPERACIÓN** o comportamiento que se
   ejecuta. Algo que el sistema **HACE como respuesta a un
   suceso**. Es la *parte ejecutable de la transición*.

   - Guardar datos en base de datos
   - Incrementar un contador
   - Enviar una notificación
   - Actualizar la interfaz

 - **Transición Desencadenada:** **siempre requiere un suceso
   específico** para ocurrir. La acción es **opcional**.

   - ``evento / acción`` — ej: ``boton_presionado / guardar_datos``
   - Sólo evento: ``tiempo_agotado`` (sin acción)

 - **Transición No Desencadenada:** **no requiere ningún suceso
   externo**. Se activa cuando un estado finaliza su actividad,
   ocurre **automáticamente**. La acción es opcional.

   - Cuando termina de procesar un pago, automáticamente pasa al
     siguiente estado.
   - Cuando termina de cargar datos, pasa al estado "listo".
   - No necesita esperar ningún evento externo.

La GUI con que interactúe le dará ejemplos de detalles de la
transición. Asumamos que la GUI puede establecerse en uno de
tres estados: **Inicialización**, **Operación**, **Apagado**.

- Cuando enciende su equipo, se ejecutará un proceso de arranque:
  *al encender se desencadena un suceso* que provoca que la GUI
  aparezca luego de una *transición desde el estado de
  Inicialización*, y *el arranque es una acción* que se realiza
  *durante tal transición*.
- Como resultado de las actividades en el estado de
  Inicialización, la GUI entra al modo de Operación.
- Cuando *desea apagar su PC*, *desencadena un suceso* que
  provoca la *transición hacia el estado de Apagado*, y con ello
  la PC se apaga (transición no desencadenada del Apagado al fin).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Inicializacion : encender / arrancar
   Inicializacion --> Operacion
   Operacion --> Apagado : apagar / cerrar_sesion
   Apagado --> [*]
   @enduml

----

Condiciones de seguridad
========================

Si ha pasado cierto tiempo sin que haya interacción con el
usuario, la GUI hará una transición del estado *Operación* al
estado *Protector de pantallas*. El intervalo se especifica en
su sistema operativo (por lo general 15 minutos).

Cualquier opresión de una tecla o movimiento del ratón provocará
una transición del estado *Protector de pantallas* al estado
*Operación*.

**El intervalo es una condición de seguridad** (*guard
condition*): cuando se cumple, se realiza la transición. La
condición de seguridad se establece como **expresión booleana**
entre corchetes ``[ ]``.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Inicializacion : encender / arrancar
   Inicializacion --> Operacion
   Operacion --> ProtectorPantalla : [tiempoInactivo > 15min]
   ProtectorPantalla --> Operacion : tecla / movimientoRaton
   Operacion --> Apagado : apagar / cerrar_sesion
   Apagado --> [*]
   @enduml

----

Subestados
==========

Cuando la GUI está en el estado *Operación*, hay muchas cosas
que ocurren y que no son particularmente evidentes en la
pantalla.

La GUI aguarda a que usted haga algo (oprimir una tecla, mover
el ratón u oprimir uno de sus botones), debe registrar tales
acciones y modificar lo que se despliega para reflejarlas. La
GUI atravesará por varios cambios mientras se encuentre en el
estado *Operación*. Tales cambios son **cambios de estado**.

Los **estados que se encuentran dentro de otros estados son
subestados**. Hay dos tipos: **secuencial** y **concurrente**.

Subestados secuenciales
-----------------------

Los subestados secuenciales **suceden uno detrás de otro**.

Dentro del estado *Operación* de la GUI, tendrá la siguiente
secuencia:

- *A la espera de acción del usuario*
- *Registro de una acción del usuario*
- *Representación de la acción del usuario*

La acción del usuario desencadena la transición a partir de
*A la espera* hacia *Registro*. Las actividades dentro del
*Registro* trascienden hacia *Representación*. Después del
tercer estado, la GUI vuelve a iniciar *A la espera*.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state Operacion {
     [*] --> Espera
     Espera : "A la espera de\nacción del usuario"
     Espera --> Registro : accionUsuario
     Registro : "Registro de una\nacción del usuario"
     Registro --> Representacion
     Representacion : "Representación de la\nacción del usuario"
     Representacion --> Espera
   }
   @enduml

Subestados concurrentes
-----------------------

La GUI no sólo aguarda a que usted haga algo: también verifica
el cronómetro del sistema y (posiblemente) actualiza el
despliegue de una aplicación luego de un intervalo específico.
Una aplicación podría incluir un reloj en pantalla que tuviera
que actualizar la GUI.

Todo esto sucede al **mismo tiempo** que la secuencia anterior.
Cada secuencia es un conjunto de subestados secuenciales; las
dos secuencias son **concurrentes** entre sí.

Puede representar la concurrencia con una **línea discontinua**
entre las regiones concurrentes.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state Operacion {
     state "Acciones del usuario" as RegionA {
       [*] --> Espera
       Espera --> Registro : accionUsuario
       Registro --> Representacion
       Representacion --> Espera
     }

     ||

     state "Cronómetro / Reloj" as RegionB {
       [*] --> Verificar
       Verificar --> Actualizar : intervaloCumplido
       Actualizar --> Verificar
     }
   }
   @enduml

Cuando **cada componente sea parte de un "todo"**, tratará con
una *composición*. Las partes concurrentes del estado *Operación*
tienen el mismo tipo de relación con él. Por ello, *Operación*
es un **estado compuesto**. Un estado que consta sólo de
subestados secuenciales también es un estado compuesto.

----

Estados históricos
==================

Cuando se activa su protector de pantallas y mueve su ratón
para regresar al estado *Operación*, ¿qué ocurre? ¿Acaso su
pantalla retoma el estado inicial, como si apenas se hubiera
encendido? ¿O lucirá tal como la dejó antes de que se activara
el protector? El **estado histórico** captura esta idea.

Un estado compuesto **recuerda su subestado activo** cuando el
objeto trasciende fuera del estado compuesto.

El símbolo es la **letra "H" encerrada en un círculo** que se
conecta por una línea continua al subestado por recordar, con
una punta de flecha que apunta a tal subestado.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state Operacion {
     [*] --> Espera
     state Espera
     state Registro
     state Representacion
     Espera --> Registro
     Registro --> Representacion
     Representacion --> Espera
     state H <<history>>
   }
   ProtectorPantalla --> H : tecla / mov.Raton
   Operacion --> ProtectorPantalla : [tiempoInactivo > 15min]
   @enduml

- Cuando un estado histórico **recuerda los subestados en todos
  los niveles de anidación**, el estado histórico es
  **profundo**. Se representa agregando un asterisco (``*``) a
  la "H" en el círculo: ``H*``.
- Si sólo recuerda el subestado principal, el estado histórico
  será **superficial**.

El estado histórico y el estado inicial (representado por el
círculo relleno) son conocidos como **pseudoestados**. *No
tienen variables de estado ni actividades*, por lo que no son
estados "completos".

----

Mensajes y señales
==================

Los objetos se comunican mediante el envío de mensajes entre sí.
En este caso, el suceso desencadenado es un mensaje de un objeto
(el usuario) a otro (la GUI).

Un *mensaje que desencadena una transición* en el diagrama de
estados del objeto receptor se conoce como **señal** (signal).

En el mundo de la orientación a objetos, **el envío de una señal
es lo mismo que crear un objeto Señal** y transmitirlo al objeto
receptor. El objeto Señal cuenta con propiedades que se
representan como atributos. Dado que una señal es un objeto, *es
posible crear jerarquías de herencia de señales*.

----

Por qué son importantes los diagramas de estados
================================================

El diagrama de estados de UML proporciona una gran variedad de
símbolos y abarca varias ideas (todas para modelar los cambios
por los que pasa un objeto). Tienen el potencial de convertirse
en algo complejo.

Es necesario contar con diagramas de estados dado que permiten a
los analistas, diseñadores y desarrolladores **comprender el
comportamiento de los objetos** de un sistema.

Un diagrama de clases y un diagrama de objetos sólo muestran los
aspectos **estáticos** de un sistema: muestran las jerarquías y
asociaciones, y le indican qué son las operaciones. Pero **no
muestran los detalles dinámicos** de las operaciones.

Los desarrolladores deben saber la **forma en que los objetos se
supone que se comportarán**, ya que son ellos quienes tendrán
que establecer tales comportamientos en el software. No es
suficiente con implementar un objeto; deben hacer que tal objeto
**haga algo**, así no tendrán que adivinar lo que se supone que
harán los objetos.

Con una clara representación del comportamiento del objeto,
aumenta la probabilidad de que el equipo de desarrollo produzca
un sistema que **cumpla con los requerimientos**.

----

Adiciones al panorama
=====================

Ahora puede agregar los **elementos de comportamiento** al
panorama del UML.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   skinparam packageStyle rectangle

   package "UML" {
     package "Estructurales" {
       rectangle Clase
       rectangle Objeto
       rectangle Actor
       rectangle Interfaz
       rectangle "Caso de uso" as CU
     }
     package "Comportamiento" {
       rectangle "Casos de uso"  as CMP1
       rectangle "Estados"       as CMP2
       rectangle "Secuencias"    as CMP3
       rectangle "Actividades"   as CMP4
     }
     package "Relaciones" {
       rectangle Asociacion
       rectangle Generalizacion
       rectangle Dependencia
       rectangle Realizacion
     }
     package "Agrupamiento" {
       rectangle Paquete
     }
     package "Anotacion" {
       rectangle Nota
     }
     package "Extension" {
       rectangle Estereotipo
     }
   }
   @enduml

----

Resumen
=======

- Los objetos en los sistemas modifican sus estados como
  respuestas a **sucesos** y al **tiempo**. El diagrama de
  estados captura estos cambios.
- El diagrama de estados se enfoca en los cambios de estado en
  **un solo objeto**. Un **rectángulo de vértices redondeados**
  representa a un estado, y una **línea continua con una punta
  de flecha** representa una transición.
- El símbolo del estado contiene el nombre y puede tener
  **variables** y **actividades** del estado.
- Una transición puede suceder como respuesta a un **suceso
  desencadenado**, e implicar una respuesta o **acción**.
- Una transición también puede ocurrir por la actividad en un
  estado: se conoce como **transición no desencadenada**.
- Una transición puede ocurrir cuando se cumple una **condición
  particular**, o **condición de seguridad**.
- Un estado consta de **subestados**. Pueden ser **secuenciales**
  (uno después del otro) o **concurrentes** (al mismo tiempo).
  Un estado que consta de subestados se conoce como **estado
  compuesto**.
- El **estado histórico** indica que un estado compuesto
  recordará su subestado cuando el objeto trascienda de este
  estado compuesto. Puede ser **superficial** o **profundo**.
  Un estado histórico superficial recuerda sólo el subestado
  principal; el profundo recuerda todos los niveles.
- Cuando un objeto envía un mensaje que desencadena una
  transición en el diagrama de estados de otro objeto, tal
  mensaje es una **señal**. Una señal es, por sí misma, un
  objeto, y podrá crear una jerarquía de herencia de señales.
- Los diagramas de estados facilitan la comprensión de los
  objetos de un sistema a los analistas, diseñadores y
  desarrolladores. Los desarrolladores deben saber cómo se
  supone que se comportarán los objetos: no es suficiente
  implementar un objeto, los desarrolladores tienen que hacer
  que tal objeto **haga algo**.

----

Preguntas y respuestas
======================

**¿Cuál es la mejor manera de empezar a crear un diagrama de
estados?**

Parecido a crear un diagrama de clases o un modelo de caso de
uso. Primero creará el diagrama de clases, listará todas las
clases y luego realizará las asociaciones entre ellas.

En el diagrama de estados, **primero listará los estados del
objeto**, y luego se enfocará en las transiciones. Conforme
avance en cada transición, deberá prever si un suceso
desencadenado lo activará y si se realizará alguna acción.

**¿Cada diagrama de estados debe tener un estado final (el que
se representa por la diana)?**

No. *Un objeto que nunca queda inactivo jamás tendrá un estado
final*.

.. note:: Los objetos que nunca quedan inactivos son también
   conocidos como objetos "siempre activos" o "siempre vivos"

 Características comunes:

 - Deben estar funcionando constantemente.
 - No pueden permitirse estados de inactividad.
 - Su funcionamiento es crítico y continuo.
 - Suelen manejar procesos o servicios esenciales.
 - Son persistentes durante la ejecución.
 - Mantienen un estado activo constante.
 - Procesan información continuamente.
 - Interactúan con otros objetos del sistema.
 - Tienen responsabilidades específicas y críticas.

 Ejemplos:

 - **Sistemas de control:** semáforos, sensores de vehículos,
   controladores de tiempo, monitores de temperatura industrial.
 - **Servidor web:** gestor de conexiones, manejador de
   peticiones HTTP, balanceador de carga, cache, logger,
   planificador del SO.
 - **Sistemas de vigilancia:** cámara, detector de movimiento,
   grabador, gestor de alertas, monitor de estado.
 - **Sistemas en tiempo real:** control de vuelo, navegación
   GPS, central eléctrica, monitoreo sísmico.
 - **Servicios de red:** servidor web, servidor de base de
   datos, router, firewall.
 - **Sistemas de monitoreo:** vigilancia, signos vitales en
   hospital, sistema de alarma, monitor de servidores.
 - **Sistema de control de vuelo:** sensor de altitud, control
   de navegación, monitor de combustible, controlador de
   velocidad, sistema de emergencia.
 - **Sistema operativo / servicios de sistema:** gestor de
   procesos, administrador de memoria, planificador de tareas,
   control de dispositivos, monitor de recursos.

**¿Alguna sugerencia para diseñar un diagrama de estados?**

Intente *arreglar los estados y transiciones* para minimizar el
cruzamiento de líneas. Uno de los objetivos de este diagrama (y
de cualquier otro) se centra en la **claridad**.

Si las personas no pueden comprender los modelos que cree, nadie
los usará y sus esfuerzos (no importa qué tan minuciosos hayan
sido) habrán sido infructuosos.

- Primero ubica los estados más importantes.
- Agrupa estados relacionados.
- Mueve los estados para que las flechas sean más directas.
- Si hay muchos cruces, reorganiza hasta minimizarlos.

**Buena organización** (fácil de entender):

- Estados ordenados lógicamente.
- Flechas que no se cruzan (o muy poco).
- Flujo claro y limpio.
- Fácil de seguir las conexiones.

----

Referencias cruzadas
====================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Lección anterior**
   - :doc:`uml-07-diagramas-casos-uso`
 * - **Guía PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/index`
 * - **Guidelines de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo de diagramas IACT**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Fuente original**
   - *Aprendiendo UML en 24 horas* — Hora 8 (Schmuller, 2000)
