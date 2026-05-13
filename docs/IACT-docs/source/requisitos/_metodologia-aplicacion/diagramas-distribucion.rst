.. meta::
 :artefacto: METODOLOGIA_DIAGRAMAS_DISTRIBUCION
 :tipo: Guia-Metodologica
 :dominio: requisitos
 :subdominio: _metodologia-aplicacion
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================================
Diagramas de distribución — despliegue IACT (H13)
==========================================================

Propósito
=========

Modelar **dónde corre cada componente** de IACT: nodos
físicos (o virtuales), dispositivos, redes y protocolos.

Diferencia con H12:

- **Componentes (H12)** → qué piezas existen y qué contratos
  las unen.
- **Distribución (H13)** → en qué nodo se ejecuta cada
  pieza, con qué protocolo se comunica y qué frontera de
  red atraviesa.

Pregunta que responde:

   *Si me siento delante del servidor de IACT, ¿qué hay
   instalado en cada máquina y cómo se comunican?*

Marco metodológico
==================

- Skill principal: ``rm-specification``
- Skill complementario: ``rm-analysis``
- Stack canónico: ADR_DEVOPS_001 → Vagrant + Apache +
  ``mod_wsgi`` + Django + MySQL + Redis. **No** Docker, K8s,
  Nginx, Gunicorn, CDN, multi-region.
- Política de diagramación:
  :doc:`/base-cognitiva/plantuml-guide/guidelines`

Preludio — vista Container (C4 nivel 2)
=======================================

El Context (§ 13 de :doc:`diagramas-componentes`) cubre
la vista a 50 000 pies para audiencias no técnicas.
Pero la mayoría de los ingenieros necesita **más
detalle**: qué partes componen el sistema y cómo se
comunican entre sí. Ese nivel de detalle es la **vista
Container** del modelo C4.

Qué es un container en C4
-------------------------

En C4, **container no es contenedor Docker**: significa
una **unidad desplegable individual**. Ejemplos
canónicos:

- Una aplicación Java empaquetada.
- Una base de datos PostgreSQL.
- Un servidor web Apache + módulos.
- Una instancia Redis.
- Un broker de mensajes (Kafka, RabbitMQ).

Cada container es algo que se despliega como pieza
independiente, con su propio ciclo de vida operativo.

Qué muestra el Container — y qué no
-----------------------------------

- **Sí**: containers, sus tecnologías principales y
  los protocolos entre ellos.
- **Sí**: actores humanos (los mismos del Context) y
  sistemas externos.
- **No**: detalle del código dentro de cada container
  — eso es nivel 3 Component.
- **No**: clases, servicios internos, módulos.

La metáfora del zoom: si el Context era la vista al
sistema completo como una caja, el Container es lo
que se ve al **hacer click** sobre esa caja.

Equivalencia C4 ↔ documentos IACT
---------------------------------

En IACT la vista Container del modelo C4 vive en este
documento (``diagramas-distribucion.rst``):

- Los **nodos físicos** (``vm-iact``,
  ``ldap-corporativo``, ``bd-operativa``,
  ``ivr-host``) son el aspecto **deployment** del
  Container view.
- Los **artefactos dentro de cada nodo**
  (``iact.wsgi``, apps Django, Redis, MySQL,
  ``audit_log``) son los **containers** propiamente
  dichos en lenguaje C4.
- Los **protocolos** (HTTPS intranet, LDAPS, SQL
  read-only, SMB, etc.) corresponden a las flechas
  etiquetadas del Container view.

Containers IACT canónicos
-------------------------

.. list-table::
 :widths: 25 30 45
 :header-rows: 1

 * - Container
   - Tecnología
   - Rol
 * - ``Browser`` del supervisor
   - HTML + JS bundle
   - Cliente de la UI.
 * - ``iact-admin.bundle.js``
   - React (servido por Apache)
   - SPA del panel del supervisor.
 * - ``iact.wsgi``
   - Django + mod_wsgi sobre Apache
   - Backend de aplicación.
 * - ``Redis``
   - Redis local
   - Sesiones (CNST_002), throttling
     (CNST_011).
 * - ``bd_analytics``
   - MySQL local
   - Datos derivados de ETL.
 * - ``audit_log``
   - MySQL local (immutable)
   - Auditoría (CNST_025).
 * - ``etl_runner.py``
   - Python script (cron)
   - ETL nocturno (ventana
     CNST_006/008).
 * - ``ldap-corporativo``
   - LDAP externo
   - Directorio corporativo (read-only).
 * - ``bd-operativa``
   - MySQL externo
   - Origen de datos del call center
     (read-only, CNST_007).
 * - ``ivr-host``
   - IVR externo
   - Eventos de telefonía (read-only,
     CNST_006).

A diferencia del ejemplo del libro (que incluye un
broker de mensajes), IACT **no usa Kafka ni
RabbitMQ** por ADR_DEVOPS_001. La razón por la que
el libro nota que el broker no aparecía en el
Context aplica igual a IACT: es un detalle técnico
que pertenece al Container, no al Context.

Para qué sirve el Container view
--------------------------------

- **Ingenieros que entran al proyecto** — entender en
  10 minutos cómo se despliega IACT antes de tocar
  código.
- **Operaciones / SRE** — saber qué procesos viven en
  cada nodo y qué protocolos atraviesa cada
  llamada.
- **Diseño de cambios de infraestructura** — discutir
  el reemplazo de un container o la adición de uno
  nuevo.
- **Aprobaciones arquitectónicas** — material de
  soporte para presentaciones técnicas.

Las secciones siguientes (§§ 1-9 de este documento)
detallan cada container IACT con sus protocolos, su
configuración canónica y sus restricciones.

Construir el Container view paso a paso
---------------------------------------

Como en el Context (§ 13 de :doc:`diagramas-componentes`),
el Container se construye incrementalmente: actor → primeros
containers → resto.

Tres novedades respecto al Context
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Tecnología visible** — cada container declara la
   tecnología que lo implementa entre corchetes
   (``[Django + mod_wsgi]``, ``[React SPA]``,
   ``[MySQL]``, ``[Redis]``).
2. **Protocolo en cada flecha** — la etiqueta de la
   relación incluye el protocolo entre corchetes
   (``[HTTPS]``, ``[LDAPS]``, ``[SQL read-only]``).
3. **Color consistente con el sistema en foco** — los
   containers comparten la paleta del sistema en
   diseño del Context (azul del sistema), porque
   están "dentro" de él.

Sintaxis PlantUML para containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Igual que para el Context, con tres líneas de texto
por nodo (título + tecnología en corchetes +
descripción) más estereotipo de estilo:

.. code-block:: text

   rectangle "Browser\n[Navegador del supervisor]\n\nCliente HTML+JS de la SPA" as B <<c4_container>>
   rectangle "iact.wsgi\n[Django + mod_wsgi]\n\nBackend de aplicacion" as WSGI <<c4_container>>

Las flechas incluyen el protocolo:

.. code-block:: text

   B --> WSGI : Renderiza UI y llama API\n[HTTPS intranet]

Primer paso del Container IACT — actor y los dos primeros containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El equivalente IACT del ejemplo del libro (Web App +
Mobile App). En IACT no hay app móvil — el supervisor
opera desde un navegador en intranet. Los dos primeros
containers son entonces el **Browser** del supervisor
y el ``iact.wsgi`` que sirve la SPA.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT C4 — Container view (paso 1)

   actor "Supervisor\n[Person]\n\nMonitorea llamadas\ny reportes" as Supervisor

   rectangle "Browser\n[Navegador del supervisor]\n\nCliente de la SPA en intranet" as B <<c4_container>>

   rectangle "iact.wsgi\n[Django + mod_wsgi sobre Apache]\n\nServe la SPA y expone\nla API REST del backend" as WSGI <<c4_container>>

   Supervisor --> B : opera el panel\n[uso directo]
   B --> WSGI : consulta dashboards,\nreconoce alertas\n[HTTPS intranet]
   @enduml

Diferencias con el ejemplo del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Sin Mobile App** — IACT solo se usa desde
  intranet en navegador. Una app móvil futura
  requeriría ADR.
- **Tecnología canónica IACT** — Django + mod_wsgi
  sobre Apache (ADR_DEVOPS_001), no .NET Core MVC.
- **HTTPS sobre intranet** — sin exposición pública.
- **Una sola caja Backend** — ``iact.wsgi`` es el
  punto único; las apps Django internas
  (``auth_app``, ``perm_app``, ...) son **Components**
  dentro de él (nivel 3, ver §§ 1-9 de
  :doc:`diagramas-componentes`).

Estilo y color
~~~~~~~~~~~~~~

Como en el Context, el estilo se aplica vía
estereotipos (``<<c4_container>>``) cuyos
``skinparam`` viven en
``source/_static/plantuml-styles.puml``. Política
detallada en § 13.3 de :doc:`diagramas-componentes`.

La regla relevante para Container: **mismos colores
que el sistema en foco** del Context. Los containers
están "dentro" del sistema en diseño, así que
comparten la paleta. Los actores y sistemas externos
mantienen su paleta del Context (azul oscuro y gris
respectivamente).

Política IACT para containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Tecnología visible** — cada container declara su
   stack canónico entre corchetes. Si el stack se
   desvía de ADR_DEVOPS_001, registrar ADR.
2. **Protocolo en cada flecha** — sin protocolo, la
   flecha miente sobre la integración real.
3. **Sin Docker / K8s / Nginx / Gunicorn** — el
   stack es Vagrant + Apache + mod_wsgi + Django +
   MySQL + Redis (ADR_DEVOPS_001).
4. **Construcción incremental** — actor primero,
   containers visibles desde el actor después,
   containers internos al final.
5. **Estereotipo `<<c4_container>>`** en cada
   container; centralizar paleta en
   ``plantuml-styles.puml``.

Crear fronteras con boundary / package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cuando varios containers pertenecen al **mismo sistema**
en diseño, conviene **agruparlos visualmente** dentro
de una frontera. Ayuda a separar lo que está "dentro"
del sistema de lo que está fuera, especialmente cuando
los colores no bastan.

En la convención de Simon Brown se llama
**system boundary**. PlantUML lo expresa con
``package`` o ``rectangle`` con borde discontinuo.

Sintaxis PlantUML
^^^^^^^^^^^^^^^^^

.. code-block:: text

   package "IACT" {
     rectangle "iact.wsgi\n[Django + mod_wsgi]" as WSGI <<c4_container>>
     database "Redis\n[cache + sesiones]" as Redis <<c4_container>>
     database "bd_analytics\n[MySQL]" as BDA <<c4_container>>
   }

PlantUML acepta varios "wrappers" según el énfasis:

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Forma
   - Cuándo usarla
   - Render
 * - ``package "X" { }``
   - Frontera estándar de sistema.
   - Caja con etiqueta arriba.
 * - ``rectangle "X" { }``
   - Equivalente a package; útil si ya se usan
     muchos packages.
   - Caja con etiqueta arriba.
 * - ``frame "X" { }``
   - Frontera con esquinas redondeadas — útil para
     sub-sistemas internos.
   - Caja con esquinas redondeadas.
 * - ``cloud "X" { }``
   - Sistemas externos en la "nube" (raro en
     IACT por intranet only).
   - Forma de nube.

Equivalencia con Mermaid del libro
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid
   - PlantUML
   - Notas
 * - ``subgraph id[Title] ... end``
   - ``package "Title" { ... }``
   - PlantUML no requiere ID separado.
 * - ``style id fill:none,stroke-dasharray:5 5``
   - ``skinparam packageBorderColor`` +
     ``skinparam packageBorderThickness`` o
     estereotipo
   - PlantUML configura por estereotipo o
     skinparam global.

Forma de cilindro para datastores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

PlantUML soporta nativamente la forma de cilindro
con la palabra ``database``:

.. code-block:: text

   database "bd_analytics\n[MySQL]" as BDA

Es el equivalente al ``id[(label)]`` de Mermaid del
libro. PlantUML también ofrece otras formas
especializadas para nodos:

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Palabra clave
   - Forma
   - Uso típico en IACT
 * - ``rectangle``
   - Caja
   - Container genérico (apps, servicios).
 * - ``database``
   - Cilindro
   - Bases de datos persistentes (``bd_analytics``,
     ``audit_log``, ``bd-operativa``).
 * - ``queue``
   - Cola
   - Colas internas (raro — IACT no usa Kafka).
 * - ``cloud``
   - Nube
   - Sistemas externos.
 * - ``actor``
   - Figura humanoide
   - Personas (``Supervisor``, ``Auditor``).

Aplicación a IACT — Container view con frontera
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT C4 — Container view con frontera

   actor "Supervisor\n[Person]" as Supervisor

   package "IACT" {
     rectangle "Browser\n[Navegador del supervisor]" as B <<c4_container>>
     rectangle "iact.wsgi\n[Django + mod_wsgi sobre Apache]" as WSGI <<c4_container>>
     database "Redis\n[Sesiones + throttling]" as Redis <<c4_container>>
     database "bd_analytics\n[MySQL]" as BDA <<c4_container>>
     database "audit_log\n[MySQL immutable]" as Audit <<c4_container>>
   }

   rectangle "ldap-corporativo\n[External]" as LDAP <<c4_externo>>
   database "bd-operativa\n[External, read-only]" as BDO <<c4_externo>>
   rectangle "ivr-host\n[External]" as IVR <<c4_externo>>

   Supervisor --> B : opera el panel
   B --> WSGI : consulta dashboards\n[HTTPS intranet]
   WSGI --> Redis : sesiones y throttling\n[Redis Protocol]
   WSGI --> BDA : lee/escribe analytics\n[MySQL TCP]
   WSGI --> Audit : registra eventos\n[MySQL TCP append-only]
   WSGI --> LDAP : autentica\n[LDAPS]
   WSGI --> BDO : lee llamadas\n[SQL read-only]
   WSGI --> IVR : recibe eventos\n[protocolo IVR]
   @enduml

Lectura del diagrama
^^^^^^^^^^^^^^^^^^^^

- **Frontera ``package "IACT"``** agrupa los
  containers internos. Los sistemas externos quedan
  fuera de la frontera.
- **Cinco containers internos** — Browser,
  ``iact.wsgi``, Redis, ``bd_analytics``,
  ``audit_log``. Las apps Django dentro de
  ``iact.wsgi`` son Components (nivel 3, no aparecen
  aquí).
- **Tres sistemas externos** — LDAP, bd-operativa,
  ivr-host — fuera de la frontera, con paleta gris.
- **Protocolos explícitos** — HTTPS, Redis Protocol,
  MySQL TCP, LDAPS, SQL read-only, protocolo IVR.

Regla operativa: **dentro del package solo van
containers que pertenecen al sistema en diseño**. Si
una flecha cruza la frontera, debe ser obvia
visualmente.

Otras formas (rombo, círculo) en C4
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

PlantUML soporta más formas que el libro menciona
para flowcharts (rombo para decisiones, círculo para
estado). En diagramas C4 estas formas **no son
canónicas** — la convención de Brown se mantiene en
rectángulo, cilindro y nube. Si un diagrama necesita
representar lógica de decisión, conviene mover esa
representación a un diagrama de actividades
(:doc:`diagramas-actividades`).

Política IACT para fronteras
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Una frontera por sistema en foco** — todo lo
   "dentro" de IACT va dentro del ``package "IACT"``.
2. **Sistemas externos fuera de la frontera** — y con
   estereotipo ``<<c4_externo>>``.
3. **Datastores como ``database``** — usar la forma
   de cilindro nativa para todo lo que persiste
   datos (bases de datos, colas con persistencia,
   archivos).
4. **Sin formas no canónicas** en C4 (rombos,
   círculos): la lógica condicional pertenece a
   diagramas de actividad.
5. **Flechas que cruzan la frontera** deben ser
   visibles — no esconderlas detrás del package.

Agregar sistemas de apoyo
~~~~~~~~~~~~~~~~~~~~~~~~~

El Container view se cierra agregando los **sistemas
de apoyo** identificados en el Context (§ 13 de
:doc:`diagramas-componentes`) — los sistemas externos
con los que el sistema en diseño dialoga.

Reglas de ubicación
^^^^^^^^^^^^^^^^^^^

- **Internos (containers)**: dentro del
  ``package "IACT"``.
- **Externos (sistemas de apoyo)**: **fuera** del
  package, con estereotipo ``<<c4_externo>>``.
- **Flechas desde un container interno hacia un
  sistema externo** atraviesan la frontera del
  package.

En IACT no hay equivalente a un broker de mensajes
(Kafka) porque ADR_DEVOPS_001 no lo contempla. Los
sistemas de apoyo de IACT son los tres ya
identificados en el Context:
``ldap-corporativo``, ``bd-operativa``, ``ivr-host``.

Layout — el problema y cómo controlarlo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cuando se agregan varios sistemas de apoyo, el
renderer puede colocarlos a la derecha de la
frontera, generando un diagrama **demasiado ancho**
con flechas largas que cruzan visualmente otros
elementos.

PlantUML ofrece **más control de layout** que
Mermaid:

.. list-table::
 :widths: 28 32 40
 :header-rows: 1

 * - Mecanismo
   - Efecto
   - Cuándo usarlo
 * - ``-down->``, ``-right->``,
     ``-up->``, ``-left->``
   - Fuerza la dirección de la flecha; el
     renderer respeta la pista.
   - Cuando una conexión específica se quiere
     dirigir.
 * - ``together { A B C }``
   - Agrupa varios elementos para que el
     renderer los coloque cerca.
   - Cluster que debe permanecer unido visualmente.
 * - ``left to right direction``
   - Cambia el flujo principal del diagrama
     (default es top-to-bottom).
   - Para diagramas con muchos sistemas externos
     que conviene leer horizontalmente.
 * - ``skinparam ranksep`` /
     ``skinparam nodesep``
   - Ajusta el espaciado entre filas y nodos.
   - Diagramas densos.

Aplicación a IACT — Container view final
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El equivalente IACT de la vista final del libro
(con todos los sistemas de apoyo agregados):

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT C4 — Container view (final)

   actor "Supervisor\n[Person]" as Supervisor

   package "IACT" {
     rectangle "Browser\n[Navegador del supervisor]" as B <<c4_container>>
     rectangle "iact.wsgi\n[Django + mod_wsgi sobre Apache]" as WSGI <<c4_container>>
     database "Redis\n[Sesiones + throttling]" as Redis <<c4_container>>
     database "bd_analytics\n[MySQL]" as BDA <<c4_container>>
     database "audit_log\n[MySQL immutable]" as Audit <<c4_container>>
   }

   together {
     rectangle "ldap-corporativo\n[External]" as LDAP <<c4_externo>>
     database "bd-operativa\n[External, read-only]" as BDO <<c4_externo>>
     rectangle "ivr-host\n[External]" as IVR <<c4_externo>>
   }

   Supervisor -down-> B : opera el panel
   B -down-> WSGI : consulta dashboards\n[HTTPS intranet]
   WSGI -down-> Redis : sesiones y throttling\n[Redis Protocol]
   WSGI -down-> BDA : lee/escribe analytics\n[MySQL TCP]
   WSGI -down-> Audit : registra eventos\n[MySQL TCP append-only]

   WSGI -right-> LDAP : autentica\n[LDAPS]
   WSGI -right-> BDO : lee llamadas\n[SQL read-only]
   WSGI -right-> IVR : recibe eventos\n[protocolo IVR]
   @enduml

Decisiones de layout aplicadas:

- **``together { ... }``** agrupa los tres sistemas
  externos para que aparezcan juntos.
- **``-down->``** para flechas internas verticales.
- **``-right->``** para flechas hacia los sistemas
  externos — los empuja a la derecha sin que se
  dispersen.

Si el renderer aún produce un diagrama demasiado
ancho, alternativa: usar ``left to right direction``
al inicio para reorganizar todo el diagrama
horizontalmente.

Cuándo es válido tener un diagrama "ancho"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A veces el ancho **es legítimo** — cuando el sistema
realmente tiene 6+ sistemas externos en juego.
Reglas para casos así:

1. Si caben en una pantalla 16:9, dejarlo ancho.
2. Si no caben, **dividir** en sub-diagramas: uno por
   cluster de externos relacionados (autenticación,
   datos operativos, telefonía).
3. Documentar la decisión en una nota del diagrama
   ("Vista parcial — ver también
   :doc:`diagramas-distribucion` § X").

Política IACT para sistemas de apoyo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Externos siempre fuera del package** del sistema
   en foco.
2. **Estereotipo ``<<c4_externo>>``** para color y
   diferenciación visual.
3. **Protocolo en cada flecha** — sin excepción.
4. **``together``** para agrupar externos del mismo
   subdominio.
5. **Direcciones forzadas** (``-right->``,
   ``-down->``) si el layout automático produce
   diagramas ilegibles.

Mejorar la legibilidad — controlar los rangos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cuando el renderer coloca los sistemas externos en
posiciones poco amigables, hay un mecanismo más fino
que las direcciones forzadas: **alargar la flecha**
para empujar al destino al siguiente "rank" visual.

El concepto de rank
^^^^^^^^^^^^^^^^^^^

Tanto Mermaid como PlantUML organizan el layout en
**rangos** (filas o columnas según la dirección
principal). Un nodo padre vive en un rango; sus hijos
visualmente conectados viven en el siguiente. Por
defecto, todos los nodos hijos del mismo padre suelen
quedar en el mismo rango.

Sintaxis PlantUML — flechas más largas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

PlantUML ofrece el mismo recurso que Mermaid: **más
guiones = flecha más larga = más distancia visual**.

.. code-block:: text

   A --> B    : flecha corta (rango siguiente)
   A ---> B   : flecha media
   A ----> B  : flecha larga (salta un rango)
   A -----> B : flecha muy larga (salta dos rangos)

Cada guión adicional **incrementa la longitud** de la
flecha, lo que empuja al destino más lejos en el
layout. Equivale al mecanismo descrito en el libro
para Mermaid.

Equivalencia
^^^^^^^^^^^^

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid
   - PlantUML
   - Efecto
 * - ``-->``
   - ``-->``
   - Flecha estándar.
 * - ``--->`` (un guión extra)
   - ``--->`` (un guión extra)
   - Empuja al destino un rango más allá.
 * - ``---->``
   - ``---->``
   - Empuja dos rangos más allá.

Aplicación a IACT — ajuste de rangos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para que los tres sistemas externos
(``ldap-corporativo``, ``bd-operativa``,
``ivr-host``) queden **debajo** de la frontera del
sistema en lugar de a la derecha, alargar las
flechas que cruzan la frontera:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT C4 — Container view (rangos ajustados)

   actor "Supervisor\n[Person]" as Supervisor

   package "IACT" {
     rectangle "Browser" as B <<c4_container>>
     rectangle "iact.wsgi" as WSGI <<c4_container>>
     database "Redis" as Redis <<c4_container>>
     database "bd_analytics" as BDA <<c4_container>>
     database "audit_log" as Audit <<c4_container>>
   }

   rectangle "ldap-corporativo" as LDAP <<c4_externo>>
   database "bd-operativa" as BDO <<c4_externo>>
   rectangle "ivr-host" as IVR <<c4_externo>>

   Supervisor --> B
   B --> WSGI
   WSGI --> Redis
   WSGI --> BDA
   WSGI --> Audit

   ' Flechas alargadas hacia externos: las empujan al
   ' siguiente rango (debajo del package).
   WSGI ---> LDAP : autentica\n[LDAPS]
   WSGI ---> BDO : lee llamadas\n[SQL read-only]
   WSGI ---> IVR : recibe eventos\n[protocolo IVR]
   @enduml

Lectura: las flechas con tres guiones (``--->``)
empujan a los sistemas externos un rango más abajo
que las flechas internas con dos guiones (``-->``).
Esto produce una vista más compacta donde los
externos quedan debajo de la frontera.

Cuándo es útil ajustar rangos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- El renderer pone los sistemas externos a la
  derecha y la vista se vuelve **demasiado ancha**.
- Las **etiquetas de las flechas** se aglomeran y
  se hacen ilegibles — alargar las flechas crea
  espacio vertical adicional.
- Hay **muchos hijos** del mismo padre y conviene
  separarlos en grupos verticales distintos.

Es una **petición** al renderer, no una orden
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como nota el libro citado, alargar la flecha es una
**sugerencia** para el renderer, no una garantía.
PlantUML puede ignorar el largo si comprometería la
legibilidad global. Cuando eso ocurre, la opción de
respaldo es:

- Cambiar la **dirección global** (``left to right
  direction`` al inicio).
- Forzar **direcciones específicas** con
  ``-down->``, ``-right->``.
- **Dividir** el diagrama en sub-diagramas si
  ningún ajuste de layout lo hace legible.

Crear espacio entre nodos
^^^^^^^^^^^^^^^^^^^^^^^^^

Si todas las flechas en un mismo rango se sienten
"apretadas", **alargar todas** las flechas de ese
rango simultáneamente le indica al renderer que
"salte" un rango y deje espacio adicional.

::

   ' Antes (apretado):
   A --> B
   A --> C
   A --> D

   ' Después (con más espacio vertical):
   A ---> B
   A ---> C
   A ---> D

Política IACT para ajuste de rangos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Empezar sin ajustar** — confiar en el layout
   automático en el primer borrador.
2. **Alargar flechas selectivamente** cuando el
   layout produzca diagramas demasiado anchos.
3. **No abusar** — más de tres niveles de
   alargamiento es señal de que el diagrama necesita
   reestructurarse o dividirse.
4. **Documentar el ajuste** en el código fuente con
   un comentario PlantUML (``' alargado para empujar
   externos al siguiente rango``) — el siguiente que
   edite el archivo entenderá la decisión.
5. **Combinar con direcciones forzadas** si alargar
   solo no basta; pero no aplicar ambas a la misma
   flecha (sería redundante).

Título del diagrama
^^^^^^^^^^^^^^^^^^^

Como recordatorio (§ 16.6 de
:doc:`analisis-dominio`), todo diagrama Container
publicado lleva título. Para C4 la convención IACT:

::

   IACT C4 — Container view
   IACT C4 — Container view (vm-iact)
   IACT C4 — Container view (cluster RBAC)

Agregar el título es como **firmar el diagrama** —
indica que se considera completo.

Distinguir interacciones síncronas y asíncronas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En un Container view es útil **diferenciar
visualmente** las comunicaciones síncronas de las
asíncronas. La convención canónica:

- **Línea continua** — interacción síncrona.
- **Línea punteada** — interacción asíncrona.

Sintaxis PlantUML
^^^^^^^^^^^^^^^^^

PlantUML usa puntos en lugar de guiones para flechas
punteadas:

.. code-block:: text

   A --> B    : sincrono
   A ..> B    : asincrono (linea punteada corta)
   A ...> B   : asincrono (linea punteada larga)

Igual que con las flechas continuas, **más puntos**
producen flechas más largas — el mecanismo de control
de rango (subsección anterior) aplica también a las
flechas punteadas.

Equivalencia con Mermaid
^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid
   - PlantUML
   - Notas
 * - ``A-. "label" .->B``
   - ``A ..> B : label``
   - PlantUML: punto en lugar de guión.
 * - ``A-. "label" ..->B``
     (más puntos para alargar)
   - ``A ...> B : label``
     (más puntos = más largo)
   - Mismo mecanismo de rango.

Aplicación a IACT
^^^^^^^^^^^^^^^^^

Como se discutió en § 2.1.quinquies de
:doc:`diagramas-secuencias`, IACT no usa Kafka /
RabbitMQ por ADR_DEVOPS_001. Los mecanismos
asíncronos disponibles son:

- **Audit append** desde una app Django hacia
  ``audit_log`` (vía bus Observer in-process).
- **Notificaciones al buzón interno** (CNST_001)
  desde una app hacia ``log_app``.
- **Encolado de tareas async** (CNST_019 export)
  hacia un worker que procesa fuera de la ventana
  del request.
- **Trigger del cron** que dispara
  ``etl_runner.py`` en ventana CNST_006/008.

Container view IACT con sync vs async
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT C4 — Container view (sync vs async)

   actor "Supervisor\n[Person]" as Supervisor

   package "IACT" {
     rectangle "Browser" as B <<c4_container>>
     rectangle "iact.wsgi\n[Django + mod_wsgi]" as WSGI <<c4_container>>
     database "Redis" as Redis <<c4_container>>
     database "bd_analytics\n[MySQL]" as BDA <<c4_container>>
     database "audit_log\n[MySQL immutable]" as Audit <<c4_container>>
     rectangle "Worker Export\n[Django mgmt cmd]" as Worker <<c4_container>>
   }

   rectangle "ldap-corporativo" as LDAP <<c4_externo>>
   database "bd-operativa" as BDO <<c4_externo>>

   ' Sync (linea continua)
   Supervisor --> B
   B --> WSGI : consulta dashboards\n[HTTPS intranet]
   WSGI --> Redis : sesion / throttling\n[Redis Protocol]
   WSGI --> BDA : lee/escribe analytics\n[MySQL TCP]
   WSGI ---> LDAP : autentica\n[LDAPS]
   WSGI ---> BDO : lee llamadas\n[SQL read-only]

   ' Async (linea punteada)
   WSGI ..> Audit : registra evento\n[in-process bus]
   WSGI ..> Worker : encola export\n[CNST_019]
   Worker ..> BDA : lee agregados
   @enduml

Lectura del diagrama:

- **Sync** (``-->``): operaciones donde el
  ``iact.wsgi`` espera respuesta — render de UI,
  query de Redis, autenticación LDAP.
- **Async** (``..>``): operaciones donde el
  ``iact.wsgi`` no bloquea — registro de audit
  (CNST_025), encolado de export (CNST_019). El
  ``Worker Export`` luego procesa async leyendo
  ``bd_analytics``.
- La distinción visual ayuda a ingenieros y SRE a
  identificar **dónde puede haber latencia** y
  **dónde NO se debe esperar**.

Casos asíncronos canónicos en IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 35 35
 :header-rows: 1

 * - Caller
   - Destino
   - Razón
 * - Cualquier app
   - ``audit_log``
   - Bus Observer in-process; CNST_025
     impone audit pero no bloqueante.
 * - Cualquier app
   - ``log_app``
   - Notificación al buzón interno (CNST_001).
 * - ``rpt_app``
   - ``Worker Export``
   - Export async (CNST_019/020).
 * - ``cron``
   - ``etl_runner``
   - Disparo programado (ventana
     CNST_006/008).
 * - ``alr_app``
   - ``log_app``
   - Notificación de alerta crítica al
     supervisor.

Política IACT — sync vs async en Container view
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. **Línea punteada (``..>``)** para toda
   interacción asíncrona; **continua (``-->``)**
   para síncrona.
2. **Etiqueta el protocolo o mecanismo** del
   asíncrono ("in-process bus", "cron",
   "encola tarea async"), no solo "asíncrono".
3. **No mezclar sync y async** sobre la misma
   conexión sin separarlas en flechas distintas — un
   solo elemento del diagrama no puede ser ambas.
4. **Audit típicamente async** — la inmutabilidad de
   ``audit_log`` se apoya en el bus Observer, que es
   fire-and-forget.
5. **Cualquier broker externo** (Kafka, RabbitMQ,
   Redis Streams) que se introduzca en el futuro
   requiere ADR — no es la posición por defecto del
   proyecto.

Catálogo de tipos de flecha en PlantUML
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Las subsecciones anteriores cubrieron los tipos más
usados (sólida, punteada, alargada). El libro citado
incluye un catálogo completo de flechas para
flowcharts en Mermaid; PlantUML ofrece un set
equivalente y, en algunos casos, más expresivo. Esta
subsección sirve de **referencia** para encontrar el
tipo de flecha adecuado.

Catálogo PlantUML
^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 28 32 40
 :header-rows: 1

 * - Sintaxis PlantUML
   - Render
   - Cuándo usarla
 * - ``A --> B``
   - Línea continua con cabeza de flecha
     rellena.
   - Dependencia / interacción síncrona
     estándar.
 * - ``A -->> B``
   - Línea continua con cabeza abierta.
   - Mensaje asíncrono explícito en
     diagramas de secuencia (no aplica a C4).
 * - ``A -- B``
   - Línea continua sin cabeza de flecha.
   - Asociación bidireccional sin sentido de
     dependencia.
 * - ``A --> B : etiqueta``
   - Flecha continua con etiqueta en el medio.
   - Documentar el propósito o protocolo.
 * - ``A ..> B``
   - Línea punteada con cabeza rellena.
   - Asíncrono en C4, dependencia débil en
     diagramas de clases.
 * - ``A ..> B : etiqueta``
   - Punteada con etiqueta.
   - Async etiquetado en C4.
 * - ``A -[#color]-> B``
   - Flecha con color personalizado.
   - Distinguir tipos de comunicación (uso
     reservado, ver política).
 * - ``A -[bold]-> B``
   - Flecha gruesa / negrita.
   - Resaltar caminos críticos
     (uso parsimonioso).
 * - ``A ---> B``
     (con guiones extra)
   - Flecha continua **más larga**.
   - Empujar al destino al siguiente rango.
 * - ``A ...> B``
     (con puntos extra)
   - Punteada **más larga**.
   - Empujar al destino al siguiente rango
     con flecha punteada.
 * - ``A -down-> B``,
     ``A -right-> B``,
     ``A -up-> B``,
     ``A -left-> B``
   - Flecha forzada en dirección.
   - Cuando el layout automático produce
     cruces.

Equivalencia con Mermaid del libro
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 28 36 36
 :header-rows: 1

 * - Concepto
   - Mermaid (libro)
   - PlantUML (IACT)
 * - Flecha con cabeza
   - ``A-->B``
   - ``A --> B``
 * - Flecha con cabeza + texto
   - ``A-- texto -->B`` o
     ``A-->|texto|B``
   - ``A --> B : texto``
 * - Línea sin cabeza
   - ``A---B``
   - ``A -- B``
 * - Línea sin cabeza + texto
   - ``A-- texto ---B``
   - ``A -- B : texto``
 * - Flecha punteada
   - ``A-.->B``
   - ``A ..> B``
 * - Flecha punteada + texto
   - ``A-. texto .-> B``
   - ``A ..> B : texto``
 * - Flecha gruesa
   - ``A ==> B``
   - ``A -[bold]-> B`` o estereotipo de estilo
 * - Flecha gruesa + texto
   - ``A == texto ==> B``
   - ``A -[bold]-> B : texto``
 * - Flechas múltiples desde un nodo
   - ``A --> B & C --> D``
   - ``A --> B`` + ``A --> C`` + ``C --> D``
     (PlantUML no soporta el ``&`` en una línea;
     es más explícito).
 * - Cadena
   - ``A -- t1 --> B -- t2 --> C``
   - ``A --> B : t1`` + ``B --> C : t2``

Política IACT para tipos de flecha
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las subsecciones anteriores fijan la convención
canónica del proyecto:

1. **Sólida (``-->``)** para sync — el caso por
   defecto.
2. **Punteada (``..>``)** para async — registro de
   audit, encolado, notificación.
3. **Sin cabeza (``--``)** para asociaciones
   bidireccionales en diagramas de clases.
4. **Alargada (``--->``, ``...>``)** para controlar
   rango.
5. **Direccional (``-down->``, ``-right->``)** para
   controlar layout cuando el automático no basta.

Y dos formas que **no** se usan habitualmente en
IACT:

- **Gruesa (``-[bold]->``)** — solo para resaltar
  un camino crítico de un análisis específico
  (e.g., una secuencia que viola SLA). No usar como
  estilo decorativo.
- **Coloreada (``-[#color]->``)** — solo cuando un
  ADR del subdominio justifica el uso del color.
  La paleta principal vive en
  ``plantuml-styles.puml`` por estereotipo.

Referencia rápida en pantalla
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cuando se duda sobre qué flecha usar:

1. ¿Es sync? → ``-->``
2. ¿Es async? → ``..>``
3. ¿Necesita más espacio? → agregar guiones / puntos.
4. ¿El layout automático cruza líneas? → forzar
   dirección.
5. ¿Caso especial que justifica color o grosor? →
   ADR primero.

Demostraciones visuales
^^^^^^^^^^^^^^^^^^^^^^^

Cada tipo de flecha renderizado con dos nodos
genéricos. Útil como referencia rápida cuando se
duda si la sintaxis produce el efecto esperado.

**Flecha continua con cabeza**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A --> B
   @enduml

**Flecha continua etiquetada**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A --> B : text
   @enduml

**Línea sin cabeza**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A -- B
   @enduml

**Línea sin cabeza etiquetada**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A -- B : text
   @enduml

**Flecha punteada con cabeza**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A ..> B
   @enduml

**Flecha punteada etiquetada**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A ..> B : text
   @enduml

**Flecha gruesa con cabeza**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A -[bold]-> B
   @enduml

**Flecha gruesa etiquetada**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A -[bold]-> B : text
   @enduml

**Encadenamiento — A → B → C**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   rectangle C
   A --> B : text
   B --> C : text2
   @enduml

**Bifurcación múltiple — A → B/C → D**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   rectangle C
   rectangle D
   A --> B
   A --> C
   B --> D
   C --> D
   @enduml

**Flecha alargada — empuja al destino al siguiente
rango**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A ---> B : flecha mas larga
   @enduml

**Flecha forzada en dirección horizontal**

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   rectangle A
   rectangle B
   A -right-> B : forzada a la derecha
   @enduml

Estas demos no representan ningún UC IACT
específico; sirven solo de **calibración visual**
del rendering. Para cualquier modelo del proyecto,
elegir el tipo según las políticas IACT de las
subsecciones anteriores.

Ejercicio: crear tu propio Container diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como en los ejercicios de cierre de los capítulos
anteriores
(§§ 15.12 / 16.9 de :doc:`analisis-dominio`,
§ 14 de :doc:`diagramas-secuencias`,
§ 13.4 de :doc:`diagramas-componentes`), el cierre
canónico del Container view es **construir el
diagrama** del proyecto elegido a partir del Context
existente.

Aplicación a IACT
^^^^^^^^^^^^^^^^^

En este proyecto el ejercicio **ya está realizado**:
las subsecciones de este documento desarrollan el
Container view completo de IACT — desde el primer par
de containers (Browser + ``iact.wsgi``), pasando por
la frontera del sistema, los datastores
(``Redis``, ``bd_analytics``, ``audit_log``), los
sistemas externos (``ldap-corporativo``,
``bd-operativa``, ``ivr-host``), hasta la
distinción visual sync/async.

Variantes para nuevos contribuidores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Quien quiere ejercitar la técnica antes de aplicarla
en un cambio real:

1. **Reproducir el Container completo desde cero**
   sin mirar el código fuente PlantUML, validando
   que se entiende cada decisión de layout y cada
   etiqueta de protocolo.
2. **Container alternativo** — qué pasaría si el
   proyecto añadiera un broker de eventos in-process
   (no Kafka, sino un equivalente Python in-process
   más explícito): qué containers nuevos aparecen,
   qué flechas cambian de sólida a punteada.
3. **Container del cluster RBAC visto en aislado**
   — solo ``perm_app``, ``Redis``, ``audit_log`` y
   ``ldap-corporativo``, con foco en SoD CNST_030.
4. **Container del cluster ETL** — ``etl_runner``
   como container central, con ``bd-operativa``,
   ``ivr-host`` y ``bd_analytics`` alrededor;
   diagrama dominado por flechas read-only y
   ventana CNST_006/008.

Variantes para extender el modelo real
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cuando aparezca una iniciativa que **modifique los
containers internos** (e.g., introducir un worker
dedicado para export, separar
``audit_log`` en su propia VM, agregar caché
adicional):

1. Abrir un WP en ``.thyrox/context/work/``.
2. Bocetar el cambio en el Container view con
   PlantUML (``planttext.com`` o editor con preview).
3. Discutirlo con stakeholders técnicos y SRE.
4. Actualizar este documento con el nuevo diagrama
   final.
5. Registrar la decisión en un ADR del subdominio
   afectado, si la modificación es estructural.

Plan recomendado para nuevos contribuidores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Leer el preludio + las subsecciones de este
   capítulo.
2. Reproducir el Container de IACT desde cero
   (variante 1).
3. Probar la variante 3 (cluster RBAC) para
   ejercitar la frontera y el estereotipo
   ``<<c4_externo>>``.
4. Pasar a la variante 4 (cluster ETL) para
   ejercitar la mezcla read-only + ventana temporal.
5. Avanzar al siguiente nivel C4: **Component view**
   (§§ 1-9 de :doc:`diagramas-componentes`).

Próximo capítulo
^^^^^^^^^^^^^^^^

El siguiente nivel del modelo C4 es la vista
**Component**, que detalla los **componentes
internos** de cada container — las apps Django de
``iact.wsgi`` y sus contratos
(``ISecurity``, ``IAuditLog``, ``IReporte``,
``IAlerta``, ``INotificacion``,
``IDatosOperativos``, ``IDatosAnalytics``,
``IETL``). En IACT eso vive en
:doc:`diagramas-componentes` §§ 1-9.

----

1. Nodo, dispositivo y conexión
===============================

En UML un **nodo** es un recurso de cómputo donde se
ejecutan componentes; un **dispositivo** es un recurso que
no ejecuta artefactos pero participa en el sistema (lector,
impresora, sensor). En IACT los nodos típicos son:

- ``vm-iact`` — VM Vagrant (en dev) o servidor corporativo
  (en prod) que aloja Apache + ``mod_wsgi`` + Redis + MySQL.
- ``ldap-corporativo`` — servidor LDAP de la organización.
- ``bd-operativa`` — origen read-only del call center
  (CNST_007).
- ``ivr-host`` — sistema IVR consultado por la ETL en modo
  read-only (CNST_006/008).
- ``puesto-supervisor`` — equipo del usuario final en la
  intranet, con navegador.

No hay CDN, balanceador, ni nodos en otras regiones. La
arquitectura de despliegue es deliberadamente simple.

2. Vista de despliegue global IACT
==================================

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "puesto-supervisor\n<<computadora>>" as PS {
     artifact "Navegador (intranet)" as BR
   }

   node "vm-iact\n<<servidor>>" as VM {
     node "Apache + mod_wsgi" as APACHE {
       artifact "iact.wsgi" as WSGI
       artifact "auth_app, perm_app,\nrpt_app, alr_app,\npip_app, aud_app, log_app" as APPS
     }
     node "Redis" as REDIS
     database "bd_analytics\n(MySQL)" as BDA
     database "audit_log\n(MySQL,\nimmutable CNST_025)" as AUDIT
     artifact "etl_runner.py\n(cron, ventana\nCNST_006/008)" as ETL
     artifact "iact-admin.bundle.js" as UIBUNDLE
   }

   node "ldap-corporativo\n<<servidor>>" as LDAP

   database "bd-operativa\n(read-only,\nCNST_007)" as BDO

   node "ivr-host\n<<servidor>>" as IVR

   BR -down-> APACHE : HTTPS (intranet)
   APACHE -down-> UIBUNDLE : sirve estaticos
   APPS -right-> REDIS : sesiones (CNST_002)\nthrottling (CNST_011)
   APPS -down-> BDA : lectura/escritura
   APPS -down-> AUDIT : append-only
   APPS -right-> LDAP : LDAPS (auth)
   ETL -left-> BDO : SQL read-only
   ETL -left-> IVR : protocolo IVR
   ETL -down-> BDA : insert agregados
   @enduml

3. Conexiones y protocolos
==========================

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Origen
   - Destino
   - Protocolo / nota
 * - ``puesto-supervisor``
   - ``vm-iact`` / Apache
   - HTTPS sobre intranet corporativa.
 * - Apps Django
   - Redis
   - TCP local — sesiones (CNST_002), throttling
     (CNST_011).
 * - Apps Django
   - ``bd_analytics``
   - TCP local — escritura controlada por ``services.py``.
 * - Apps Django
   - ``audit_log``
   - TCP local — append-only (CNST_025).
 * - ``auth_app``
   - ``ldap-corporativo``
   - LDAPS — solo lectura de directorio.
 * - ``etl_runner``
   - ``bd-operativa``
   - SQL **read-only** (CNST_007).
 * - ``etl_runner``
   - ``ivr-host``
   - Protocolo proporcionado por IVR — read-only,
     ventana CNST_006/008.

No existe canal de salida hacia internet pública en runtime.
Cualquier nuevo destino externo requiere ADR explícito.

4. Diferencia entre dev (Vagrant) y prod
========================================

Ambos entornos comparten **la misma topología lógica**: el
diagrama de despliegue es el mismo. Las diferencias son de
implementación, no de arquitectura:

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Aspecto
   - Dev (Vagrant)
   - Prod (servidor corporativo)
 * - Host de ``vm-iact``
   - VM provisionada por Vagrant.
   - VM o bare-metal corporativo.
 * - Apache + mod_wsgi
   - Idéntico al de prod (por ADR_DEVOPS_001).
   - Idéntico.
 * - ``ldap-corporativo``
   - Mock o LDAP de pruebas.
   - LDAP real (read-only).
 * - ``bd-operativa``
   - Snapshot o réplica de prueba.
   - Réplica read-only en producción.
 * - ``ivr-host``
   - Stub de pruebas.
   - IVR real (read-only).

Este principio bloquea fragmentación: un cambio que solo
funciona en dev por usar Docker o Nginx contradice
ADR_DEVOPS_001.

5. Componentes dentro de los nodos
==================================

Vista de detalle de ``vm-iact`` mostrando los artefactos que
contiene y a qué interfaz corresponden (cruce con H12).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" as VM {
     node "Apache + mod_wsgi" {
       artifact "iact.wsgi"
       artifact "auth_app — IAutenticacion"
       artifact "perm_app — ISecurity"
       artifact "rpt_app — IReporte"
       artifact "alr_app — IAlerta"
       artifact "pip_app — IETL"
       artifact "aud_app — IAuditLog"
       artifact "log_app — INotificacion"
     }
     node "Redis"
     database "bd_analytics"
     database "audit_log"
     artifact "etl_runner.py"
   }
   @enduml

6. UCs IACT y sus nodos
=======================

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - UC
   - Nodos involucrados
   - Notas
 * - UC_AUTH_01 Login
   - puesto-supervisor → vm-iact (auth_app) →
     ldap-corporativo
   - LDAPS, sesión en Redis (CNST_002).
 * - UC_PERM_07 Verificar permiso
   - vm-iact (perm_app + aud_app)
   - Local; sin salida externa.
 * - UC_RPT_04 Exportar reporte
   - vm-iact (rpt_app + log_app + aud_app + bd_analytics)
   - Async (CNST_019), buzón interno (CNST_001).
 * - UC_RPT_07 Reporte programado
   - vm-iact (scheduler + rpt_app + bd_analytics)
   - Disparado tras ventana ETL.
 * - UC_PIP_01 Carga ETL
   - vm-iact (etl_runner) ↔ bd-operativa, ivr-host →
     bd_analytics
   - Lectura read-only de operativa e IVR (CNST_007).
 * - UC_ALR_03 Reconocer alerta
   - vm-iact (alr_app + aud_app + log_app)
   - Sin salida externa.

7. Cuándo usar diagramas de distribución
========================================

.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Usar cuando…
   - No usar cuando…
 * - Documentamos el deployment para operaciones.
   - Solo cambia código dentro de un componente.
 * - Hay un cambio de host, protocolo o frontera de red.
   - El cambio es solo lógico (clases, OOP).
 * - Se evalúa un nuevo destino externo (otra BD, otro
     servicio).
   - El UC ya está cubierto con secuencias o componentes.
 * - Se prepara una revisión de seguridad de red.
   - El equipo solo necesita el flujo dinámico (usar
     secuencias o actividades).

8. Buenas prácticas
===================

1. Mantener un único diagrama global de despliegue por
   entorno; los detalles van en sub-diagramas (sección 5).
2. Etiquetar siempre el protocolo en cada conexión —
   "TCP/IP" sin más es poco informativo en una revisión de
   seguridad.
3. Marcar explícitamente las fronteras read-only
   (``bd-operativa``, ``ivr-host``).
4. Evitar nodos imaginarios: si no hay CDN, balanceador o
   multi-región, no aparecen en el diagrama.
5. Cualquier nodo nuevo en producción requiere ADR
   correspondiente (``adr-devops-*``).
6. Cuando cambien los protocolos o las fronteras, abrir un
   WP de revisión y actualizar este diagrama antes de
   ejecutar el cambio.

9. Capas finales del diseño UML aplicado a IACT
===============================================

.. list-table::
 :widths: 22 78
 :header-rows: 1

 * - Capa
   - Documentos en este cajón
 * - Conceptual
   - :doc:`orientacion-objetos`,
     :doc:`analisis-dominio`,
     :doc:`relaciones-uml`,
     :doc:`agregacion-interfaces`
 * - Casos de uso
   - :doc:`casos-uso-especificacion`,
     :doc:`casos-uso-diagramas`
 * - Comportamiento
   - :doc:`diagramas-estados`,
     :doc:`diagramas-secuencias`,
     :doc:`diagramas-colaboraciones`,
     :doc:`diagramas-actividades`
 * - Físico
   - :doc:`diagramas-componentes` (H12),
     :doc:`diagramas-distribucion` (H13)

10. Catálogo consolidado de notaciones
======================================

Tabla índice del documento. Cada componente del
diagrama de despliegue con su sintaxis PlantUML,
sección donde se desarrolla y caso IACT.

.. list-table::
 :widths: 22 32 16 30
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Device node
     (hardware / VM)
   - ``node "X" as N``
   - § 1
   - ``vm-iact``,
     ``puesto-supervisor``.
 * - Execution Environment
     node (software de
     ejecución)
   - ``node "X" as N``
     anidado dentro de un
     device node
   - § 1
   - ``Apache + mod_wsgi``
     dentro de ``vm-iact``.
 * - Database (BD persistente)
   - ``database "X" as DB``
   - § 1
   - ``bd_analytics``,
     ``audit_log``,
     ``Redis``.
 * - Artifact (binario o
     archivo desplegado)
   - ``artifact "X" as A``
   - § 5
   - ``iact.wsgi``,
     ``etl_runner.py``,
     ``iact-admin.bundle.js``.
 * - Asociación
     (bidireccional)
   - ``A -- B``
   - § 3
   - Conexión local entre
     apps y Redis.
 * - Asociación dirigida
   - ``A --> B``
   - § 3
   - ``vm-iact`` →
     ``ldap-corporativo``.
 * - Dependencia
   - ``A ..> B``
   - § 10.2
   - ``etl_runner ..>
     bd-operativa``.
 * - Puerto en frontera
   - ``port`` declarado
     dentro del nodo
   - § 10.2
   - HTTPS de entrada en
     ``vm-iact``.
 * - Estereotipo C4
   - ``<<c4_container>>``,
     ``<<c4_externo>>``
   - Preludio Container
   - Coherente con vista
     Container.
 * - Frontera del sistema
   - ``package "IACT" { ... }``
   - Preludio Container
   - Agrupación visual de
     containers internos.

10.1 Tipos de nodo en la convención UML
---------------------------------------

UML estándar distingue dos tipos de nodo:

- **Device node** — recurso de hardware con
  capacidad de cómputo (servidor físico, VM,
  laptop, mobile).
- **Execution Environment node** — entorno de
  ejecución que corre **dentro** de un device
  node (sistema operativo, servidor web,
  motor de BD, contenedor).

PlantUML usa la misma palabra clave ``node``
para ambos; la **distinción** se hace por
**anidamiento** (un nodo dentro de otro indica
que el interno es execution environment del
externo) y por la **etiqueta** (texto entre
corchetes que aclara el rol).

Aplicación a IACT:

- Device: ``vm-iact`` (VM Vagrant o servidor
  corporativo), ``puesto-supervisor``,
  ``ldap-corporativo``, ``ivr-host``.
- Execution environment dentro de ``vm-iact``:
  ``Apache + mod_wsgi``, ``Redis daemon``,
  ``MySQL daemon``.

10.2 Notaciones complementarias
-------------------------------

Componentes adicionales del catálogo UML
estándar que conviene tener visibles:

Puerto en frontera de nodo
~~~~~~~~~~~~~~~~~~~~~~~~~~

Igual que en el diagrama de componentes (§ 15.2
de :doc:`diagramas-componentes`), un **puerto**
es un punto explícito de comunicación. En
deployment, los puertos típicos son:

- Punto de entrada externo del nodo (HTTPS de
  intranet hacia ``vm-iact``).
- Punto de comunicación entre nodos (LDAPS hacia
  ``ldap-corporativo``).

Sintaxis PlantUML:

.. code-block:: text

   node "vm-iact" {
     port p_https
     port p_ldap
   }

Dependencia entre nodos
~~~~~~~~~~~~~~~~~~~~~~~

Diferencia con asociación: la dependencia
(``..>``) indica que el funcionamiento de un
nodo **requiere** la existencia del otro, sin
implicar comunicación bidireccional permanente.

En IACT:

- ``etl_runner ..> bd-operativa`` —
  dependencia: el ETL no funciona si la BD
  operativa no está disponible.
- ``vm-iact ..> ldap-corporativo`` — dependencia
  para autenticación; sin LDAP el login falla.

----

11. Galería de ejemplos canónicos IACT — Deployment
====================================================

11.1 Device node simple
-----------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" as VM
   @enduml

11.2 Device node con execution environment anidado
--------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" as VM {
     node "Apache + mod_wsgi" as Apache
   }
   @enduml

11.3 Artifact dentro de execution environment
---------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" {
     node "Apache + mod_wsgi" {
       artifact "iact.wsgi"
     }
   }
   @enduml

11.4 Database dentro de un nodo
-------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" {
     database "bd_analytics" as BDA
     database "audit_log" as Audit
     database "Redis" as R
   }
   @enduml

11.5 Asociación bidireccional entre nodos
-----------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "puesto-supervisor" as PS
   node "vm-iact" as VM

   PS -- VM : HTTPS (intranet)
   @enduml

11.6 Asociación dirigida
------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" as VM
   node "ldap-corporativo" as LDAP

   VM --> LDAP : LDAPS\n(autenticacion)
   @enduml

11.7 Dependencia entre nodos
----------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" as VM
   database "bd-operativa\n(read-only)" as BDO

   VM ..> BDO : depende de\n(CNST_007)
   @enduml

11.8 Puertos en frontera
------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   node "vm-iact" as VM {
     port p_https
     port p_ldap
   }
   node "puesto-supervisor" as PS
   node "ldap-corporativo" as LDAP

   PS -- p_https
   p_ldap -- LDAP
   @enduml

11.9 Vista combinada — IACT minimalista
---------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — Deployment minimalista

   actor Supervisor

   node "puesto-supervisor" as PS {
     artifact "Browser"
   }

   node "vm-iact" as VM {
     node "Apache + mod_wsgi" {
       artifact "iact.wsgi"
     }
     database "Redis" as Redis
     database "bd_analytics" as BDA
     database "audit_log" as Audit
   }

   node "ldap-corporativo" as LDAP
   database "bd-operativa\n(read-only)" as BDO

   Supervisor -- PS
   PS --> VM : HTTPS (intranet)
   VM --> LDAP : LDAPS
   VM ..> BDO : SQL read-only\n(CNST_007)
   @enduml

11.10 Plantilla — vista de despliegue IACT
------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Deployment — <ambito>

   actor "<Actor>" as A

   node "<device cliente>" as Cliente {
     artifact "<bundle / cliente>"
   }

   node "vm-iact" as VM {
     node "<execution environment>" as EE {
       artifact "<artifact 1>"
       artifact "<artifact 2>"
     }
     database "<BD interna>" as DB
   }

   node "<sistema externo>" as Ext

   A -- Cliente
   Cliente --> VM : <protocolo>
   VM --> Ext : <protocolo>
   VM ..> Ext : <dependencia opcional>
   @enduml

11.11 Cómo usar la galería
--------------------------

1. Localizar el componente en § 10.
2. Copiar el snippet (§§ 11.1-11.9) o usar la
   plantilla (§ 11.10).
3. Adaptar nombres de nodos, environments y
   artifacts al ámbito a documentar.
4. Etiquetar los protocolos en cada conexión
   (HTTPS, LDAPS, SQL read-only, protocolo IVR,
   Redis Protocol).
5. Marcar las fronteras read-only (CNST_007) y
   las restricciones de ventana (CNST_006/008)
   como notas adyacentes cuando apliquen.
6. Integrar al WP correspondiente o al SAD
   futuro.

Mantenimiento
~~~~~~~~~~~~~

- Cada nodo nuevo en producción requiere ADR
  per la regla 5 de § 8.
- Si se agrega un componente nuevo al catálogo
  § 10, agregar también su snippet en § 11.
- Mantener cada snippet ≤ 5 nodos. Si la vista
  necesita más, dividir por subdominio.

----

Trazabilidad
============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill principal**
   - ``rm-specification``
 * - **Skill complementario**
   - ``rm-analysis``
 * - **Diagrama hermano (vista lógica física)**
   - :doc:`diagramas-componentes`
 * - **Stack canónico**
   - ADR_DEVOPS_001 (Vagrant + Apache + mod_wsgi + Django
     + MySQL + Redis)
 * - **Restricciones aplicadas**
   - CNST_001 buzón interno, CNST_002 sesión única,
     CNST_006/007/008 fronteras de la BD operativa e IVR,
     CNST_011 throttling, CNST_019/020 export async,
     CNST_025 audit immutable
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Teoría UML**
   - :doc:`/base-cognitiva/_uml/index`
