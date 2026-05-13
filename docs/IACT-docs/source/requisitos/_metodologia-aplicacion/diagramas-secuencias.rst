.. meta::
 :artefacto: METODOLOGIA_DIAG_SECUENCIAS_IACT
 :tipo: Guia
 :dominio: requisitos
 :subdominio: _metodologia-aplicacion
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

=====================================================================
Diagramas de secuencias — interacciones temporales aplicadas a IACT
=====================================================================

.. note::

 Adapta la **Hora 9 de Schmuller** ("Diagramas de
 secuencias") al dominio real del proyecto IACT (call
 center IVR + analytics + RBAC + ETL).

 Diagramas en **PlantUML** (política del proyecto, no Mermaid).

 Para la teoría genérica ver
 :doc:`/base-cognitiva/_uml/uml-09-diagramas-secuencias`.

----

Preludio — visualizar flujos de aplicación y usuario
====================================================

Una vez **modelado el dominio** (ver :doc:`analisis-dominio`),
el siguiente artefacto natural es **visualizar los flujos**
entre los sistemas y entre el usuario y la aplicación.

El diagrama de secuencias es la herramienta canónica para
este caso de uso: muestra **interacciones de alto nivel**
antes de bajar al detalle de implementación.

Por qué visualizar flujos antes de implementar
----------------------------------------------

- **Discusión con colegas no técnicos**: los flujos son
  el puente más cercano que tiene un ingeniero con un
  PM, un auditor, un supervisor. Confirman si lo que se
  va a construir cumple los criterios del proyecto.
- **Aprobaciones arquitectónicas**: cuando un nuevo
  sistema o un cambio mayor necesita autorización de
  un arquitecto o comité, presentar **diagramas de
  secuencia** suele ser más efectivo que muros de
  texto. La experiencia recurrente de quienes han
  presentado propuestas: el documento puede acompañar
  con secuencias claras, y la mayor parte de la
  presentación se vuelve "leer el diagrama" — la
  aprobación llega más rápido.
- **Comunicación entre ingenieros**: cuando un
  desarrollador junior se incorpora, una secuencia
  responde "¿cómo funciona X?" en segundos.
- **Detección temprana de inconsistencias**: dibujar
  el flujo expone supuestos no validados (orden de
  llamadas, mensajes faltantes, dependencias no
  declaradas).

Cuándo usar secuencias en el ciclo de vida del WP
-------------------------------------------------

En el flujo THYROX del proyecto:

- **Phase 1 DISCOVER**: bocetos rápidos para entender
  el flujo del problema reportado.
- **Phase 5 STRATEGY**: comparar alternativas
  presentándolas como dos secuencias paralelas.
- **Phase 7 DESIGN/SPECIFY**: secuencias formales
  como parte del entregable.
- **Phase 9 PILOT**: validar la secuencia diseñada
  antes de construir.
- **Phase 10 EXECUTE**: la secuencia es referencia
  para implementar y revisar PRs.

Equivalente IACT del ejemplo Streamy del libro
----------------------------------------------

El libro citado modela el flujo de **registro
(``sign-up``)** de un usuario en Streamy. En IACT no
hay registro público — los usuarios provienen del
**LDAP corporativo** y el flujo equivalente más
cercano es **UC_AUTH_01: Login del supervisor**.
Ese flujo ya está modelado en § 1 de este documento
y en § 2 de :doc:`diagramas-actividades`.

Otros flujos IACT canónicos para diagramar como
secuencia:

- **UC_RPT_01** — supervisor consulta dashboard (vs
  SLA CNST_017).
- **UC_RPT_04** — exportar reporte async (CNST_019).
- **UC_PIP_01** — carga ETL (ventana CNST_006/008).
- **UC_ALR_03** — reconocer alerta crítica con
  sincronización audit + notify.
- **UC_PERM_07** — verificar permiso con SoD
  (CNST_030).

Política general
----------------

**Casi cualquier presentación se beneficia de un
diagrama**. Antes de redactar un documento extenso o
defenderlo en reunión, evaluar si una secuencia
explicaría más rápido lo que se quiere comunicar — la
respuesta es "sí" más a menudo de lo que parece.

Las secciones siguientes detallan la sintaxis y los
ejemplos IACT.

----

Preludio II — visualizar flujos de código
=========================================

El Preludio anterior planteó las secuencias como
herramienta para **flujos de aplicación / usuario**.
Las secuencias también sirven para un caso distinto:
**entender flujos de código** entre clases o módulos.

Aquí el lifeline ya no es un sistema o un componente
físico — es una **clase** o un **objeto** del dominio.
La pregunta que el diagrama responde cambia: en lugar
de "cómo el navegador habla con el backend", el
diagrama explica "cómo varias clases colaboran para
ejecutar una operación concreta".

Por qué importa diagramar a nivel de código
-------------------------------------------

El IDE muestra el código, sí, pero presenta dos
limitaciones cuando se quiere entender una
**colaboración** entre clases:

- **Ruido contextual**: archivos abiertos, imports,
  navegación entre símbolos. Un colega que aterriza
  en un cluster desconocido se distrae con detalles
  irrelevantes para la pregunta.
- **No comunica intención**: el código muestra
  *qué* se hace; el diagrama muestra *por qué* y
  *en qué orden*.

Para responder "cómo interactúan estas clases",
una secuencia condensa la conversación en una imagen.
Para responder "qué depende de qué", un diagrama de
clases lo muestra mejor (ver :doc:`relaciones-uml`).

Cuándo es buen momento para diagramar código en IACT
----------------------------------------------------

Casos típicos:

- **Onboarding** a un cluster (RBAC, ETL,
  alertería) donde el código tiene varios
  niveles de indirección.
- **Refactor planificado** — antes de tocar el
  código, modelar el flujo actual para acordar el
  flujo objetivo.
- **Explicar a un colega** un comportamiento
  particular en una sesión corta.
- **PR review** cuando un cambio toca tres apps
  Django y revisar el código línea a línea no
  basta.
- **Pago de deuda técnica** — al rediseñar
  ``services.py`` que crece sin orden, una
  secuencia exhibe los puntos donde el patrón
  Facade o Strategy tiene sentido.

En IACT esto se ve cuando un UC crece más allá de
su intención original y los tests empiezan a
necesitar fixtures complejos — señal de que el
flujo del código merece un diagrama, primero como
diagnóstico y luego como guía del refactor.

Diferencias con el preludio anterior
------------------------------------

.. list-table::
 :widths: 28 36 36
 :header-rows: 1

 * - Aspecto
   - Flujo de aplicación
   - Flujo de código
 * - Lifeline típico
   - Sistema, container, app Django.
   - Clase, módulo, objeto puntual.
 * - Audiencia
   - Mixta (PM, SRE, ingenieros).
   - Ingenieros del dominio.
 * - Granularidad
   - Alta — pocos pasos por mensaje.
   - Más fina — un mensaje puede ser una
     llamada a un método.
 * - Uso del autonumber
   - Recomendable.
   - Casi obligatorio — los pasos sirven
     de referencia en revisiones.
 * - Permanencia
   - Documentación viva del UC.
   - A menudo **snapshot** efímero del
     análisis o del refactor.

Diagramas de clases — el complemento natural
--------------------------------------------

Las secuencias responden "cómo interactúan"; los
**diagramas de clases** responden "qué depende de
qué". Para flujos de código las dos vistas
trabajan juntas:

- **Secuencia** — orden temporal de mensajes,
  activaciones, bifurcaciones.
- **Diagrama de clases** — atributos, métodos,
  relaciones de herencia / composición /
  asociación, dependencias.

El cajón ya cubre los diagramas de clases en
profundidad — ver :doc:`relaciones-uml` (taxonomía
de relaciones, herencia con sus cuatro tipos,
comparativas) y :doc:`agregacion-interfaces`
(composición, agregación e interfaces).

Para refactor / pago de deuda técnica IACT
------------------------------------------

Patrón operativo recomendado cuando se va a
refactorizar código de una app Django:

1. **Modelar el flujo actual** con una secuencia —
   un snapshot del estado pre-refactor.
2. **Modelar el diagrama de clases actual** del
   cluster afectado — un snapshot de la
   estructura.
3. **Diseñar el flujo objetivo** y la estructura
   objetivo en versiones nuevas de los dos
   diagramas.
4. **Comparar** los dos pares: lo que cambia, lo
   que sobrevive, lo que se elimina.
5. **Convertir el delta en task plan** en el WP
   correspondiente.

Esa práctica reemplaza la conversación
"refactoremos esto" por una propuesta concreta y
discutible. El delta entre los dos snapshots es
también la justificación del WP en revisiones
posteriores.

Cierre
------

Las secciones siguientes ya cubren la sintaxis
detallada que sirve tanto para flujos de
aplicación como para flujos de código.
Cuando el lifeline sea una clase, valen las
mismas reglas: declarar participantes
explícitamente, etiquetar mensajes con la
operación, separar sync y async, agrupar
bifurcaciones con ``alt``, anotar restricciones
con ``note``, y usar ``autonumber`` para
referenciar pasos en revisiones.

----

1. Comunicación entre objetos en el tiempo
==========================================

  El diagrama de secuencias muestra cómo los objetos se
  comunican entre sí al transcurrir el tiempo.

::

 Diagrama de ESTADOS:    cómo CAMBIA UN OBJETO
 Diagrama de SECUENCIAS: cómo SE COMUNICAN VARIOS OBJETOS

**Pregunta clave:** ¿qué mensajes se intercambian los objetos
y en qué orden?

----

2. Componentes básicos
======================

2.1 Elementos del diagrama
--------------------------

Cinco elementos canónicos: **participantes** (rectángulos
arriba), **línea de vida** (punteada vertical), **activación**
(rectángulo en línea de vida), **mensaje** (flecha horizontal
etiquetada), **tiempo** (eje vertical, arriba → abajo).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant Objeto1
   participant Objeto2
   participant Objeto3

   Objeto1 -> Objeto2 : mensaje 1
   activate Objeto2
   Objeto2 -> Objeto3 : mensaje 2
   activate Objeto3
   Objeto3 --> Objeto2 : retorno
   deactivate Objeto3
   Objeto2 --> Objeto1 : retorno
   deactivate Objeto2
   @enduml

2.1.bis Definir actores y participantes
---------------------------------------

Todo diagrama de secuencia debe tener **actores** y
**participantes**:

- **Actor** — representa un **humano** que interactúa
  con el sistema (supervisor, auditor, agente).
- **Participante** — representa un **proceso** o
  componente del sistema (servicio, base de datos,
  cola de mensajes, integración externa).

Sintaxis PlantUML
~~~~~~~~~~~~~~~~~

PlantUML diferencia los dos tipos con palabras clave
explícitas:

.. code-block:: text

   @startuml
   !include ../../_static/plantuml-styles.puml
   title User Sign Up Flow

   actor Browser
   participant "Sign Up Service" as SUS
   participant "User Service" as US
   queue Kafka
   @enduml

Lectura del fragmento:

- ``actor Browser`` — figura humanoide (stick figure).
- ``participant "Sign Up Service" as SUS`` — caja
  rectangular con alias corto ``SUS`` para mensajes.
- ``queue Kafka`` — PlantUML ofrece tipos
  especializados (``database``, ``queue``, ``boundary``,
  ``control``, ``entity``, ``collections``) que cambian
  el icono.

Esto es **más rico** que Mermaid, donde solo existen
``actor`` y ``participant``. Para IACT esa expresividad
ayuda a comunicar la naturaleza del componente sin
explicarlo en una nota.

Equivalente IACT del flujo del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El libro modela un flujo de registro genérico con
``Browser`` → ``Sign Up Service`` → ``User Service`` →
``Kafka``. En IACT no hay registro público (los
usuarios provienen del LDAP corporativo, ver § 16.7 de
:doc:`analisis-dominio`). El flujo análogo más cercano
es **UC_AUTH_01** (login del supervisor):

.. code-block:: text

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — Login del supervisor

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth
   participant "perm_app" as Perm
   database "ldap-corporativo" as LDAP
   database "Redis (sesiones)" as Redis
   database "audit_log" as Audit
   @enduml

Esto declara los **lifelines** sin mensajes — solo el
elenco. El renderizado muestra los participantes
alineados horizontalmente con sus líneas de vida
descendiendo, listas para recibir mensajes en las
secciones siguientes.

Tipos de participante en IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
 :widths: 22 30 48
 :header-rows: 1

 * - PlantUML keyword
   - Cuándo usarlo
   - Ejemplo IACT
 * - ``actor``
   - Persona física que opera la UI.
   - ``Supervisor``, ``Auditor``,
     ``OperadorETL``, ``AdministradorRBAC``.
 * - ``participant``
   - App Django, servicio, vista.
   - ``auth_app``, ``perm_app``, ``rpt_app``,
     ``alr_app``.
 * - ``database``
   - Base de datos o almacén persistente.
   - ``bd_operativa``, ``bd_analytics``,
     ``audit_log``, ``Redis``.
 * - ``queue``
   - Cola de mensajes (raro en IACT por
     ADR_DEVOPS_001).
   - Solo si se introduce alguna cola futura;
     requiere ADR.
 * - ``entity``
   - Entidad del dominio (modelo Django).
   - ``Reporte``, ``Sesion``, ``Alerta`` cuando
     son objetos del dominio que reciben mensajes.
 * - ``boundary``
   - Frontera del sistema, integración externa.
   - ``ldap-corporativo``, ``ivr-host``.
 * - ``control``
   - Componente coordinador / orquestador.
   - ``ExportarReporteFacade`` (ver § 6 de
     :doc:`patrones-diseno`).

Aliases para legibilidad
~~~~~~~~~~~~~~~~~~~~~~~~

PlantUML soporta alias con la sintaxis ``as``, igual
que Mermaid:

.. code-block:: text

   participant "ExportarReporteFacade" as Facade

En el resto del diagrama se puede usar ``Facade`` para
mensajes; el render mostrará el nombre completo.

¿Es obligatoria la declaración explícita?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

No. PlantUML acepta usar el nombre del participante
directamente en un mensaje sin declararlo antes — lo
crea como ``participant`` por defecto. Pero hay tres
razones para declararlo explícitamente:

1. **Forzar el icono correcto** — para tener un actor
   con figura humanoide hay que declararlo como
   ``actor``.
2. **Controlar el orden** de izquierda a derecha — el
   orden de declaración determina el orden visual.
3. **Definir aliases** que se reutilizan en todos los
   mensajes.

Política IACT
~~~~~~~~~~~~~

1. **Siempre declarar explícitamente** los lifelines en
   las primeras líneas del diagrama. Fija orden e
   iconos sin ambigüedad.
2. **Usar el tipo más específico** disponible: prefiere
   ``database`` para BD, ``actor`` para humanos,
   ``boundary`` para integraciones externas.
3. **Aliases para nombres largos** — ``auth_app`` se
   queda corto pero ``ExportarReporteFacade`` se
   abrevia con ``as Facade`` para que los mensajes
   queden legibles.
4. **No abusar de tipos exóticos** — si el equipo no
   conoce ``boundary`` / ``control``, usar
   ``participant`` con una nota explicativa.
5. **Coherencia con el modelo de dominio** — los
   participantes deben coincidir con entidades de
   :doc:`analisis-dominio` o componentes de
   :doc:`diagramas-componentes`.

2.1.ter Agregar la primera interacción
--------------------------------------

Una vez declarados actores y participantes (§ 2.1.bis),
el siguiente paso es agregar **la primera interacción**
del flujo. Las interacciones se modelan como **mensajes**
entre lifelines.

Sintaxis PlantUML para mensajes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PlantUML diferencia entre síncronos y asíncronos /
respuestas con tres flechas básicas:

.. list-table::
 :widths: 22 28 50
 :header-rows: 1

 * - Sintaxis
   - Tipo
   - Cuándo usarla
 * - ``->``
   - Síncrono (request).
   - Llamada que espera respuesta.
 * - ``-->``
   - Respuesta o asíncrono.
   - Línea punteada para retorno o callback.
 * - ``->>``
   - Asíncrono explícito (sin retorno
     inmediato).
   - Eventos, fire-and-forget, mensajes en cola.

Equivalencia con Mermaid del libro:

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Mermaid (libro)
   - PlantUML (IACT)
   - Significado
 * - ``->>``
   - ``->``
   - Llamada síncrona request.
 * - ``-->>``
   - ``-->``
   - Respuesta (línea punteada).

Estructura de un mensaje
~~~~~~~~~~~~~~~~~~~~~~~~

::

   <emisor> <flecha> <receptor> : <descripción breve>

- **Emisor** a la izquierda; **receptor** a la derecha.
- **Descripción breve** después de los dos puntos.
- El **tiempo avanza hacia abajo** — el orden de las
  líneas en el código es el orden cronológico.

Equivalente IACT del primer mensaje del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El libro abre con ``Browser`` → ``Sign Up Service``
pidiendo la página de registro y la respuesta 200 OK
con el HTML. En IACT, el flujo análogo de primera
interacción para UC_AUTH_01 es la solicitud de la
página de login:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — primer intercambio

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth

   Supervisor -> B : abre URL del panel
   B -> Auth : GET /login
   Auth --> B : 200 OK (formulario login)
   B --> Supervisor : muestra formulario
   @enduml

Lectura:

- **Mensaje síncrono** (``->``) — el navegador hace
  ``GET /login`` y espera respuesta.
- **Respuesta** (``-->``) — ``auth_app`` retorna el
  HTML; línea punteada para distinguir del request.
- **Mensaje del actor al sistema** y **del sistema al
  actor** — capturados con sintaxis idéntica.

El render muestra mensajes con flechas distintas
(continua para síncronos, punteada para respuestas) que
permiten al lector distinguir requests de responses sin
leer las etiquetas.

Etiquetas — alto nivel siempre
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El libro lo enfatiza: los diagramas de secuencia son
**vistas de alto nivel** del proceso. Las etiquetas
deben mantenerse al mismo nivel.

Buenas etiquetas IACT:

- ``GET /reportes/04/exportar`` — claro, identifica el
  endpoint.
- ``verificar_permiso(user, "exportar")`` — operación
  del dominio.
- ``encolar tarea async`` — descripción funcional.
- ``200 OK (JSON)`` o ``403 Forbidden`` — respuesta
  con código.

Etiquetas que **deberían evitarse**:

- ``serializer = ReporteSerializer(context={...}); ...
  return Response(serializer.data, ...)`` — código
  detallado, pertenece a la implementación, no al
  diagrama.
- ``hacer cosas con la BD`` — vago, no comunica nada.
- ``proceso interno`` — opaco; mejor descomponer en
  varios mensajes específicos.

Reglas IACT para mensajes
~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Síncrono** (``->``) por defecto; **respuesta**
   (``-->``) siempre que el receptor responde.
2. **Asíncrono explícito** (``->>``) solo cuando hay
   un evento sin respuesta inmediata (e.g.
   ``log_app.notificar`` puesta en cola).
3. **Etiqueta breve** y de alto nivel — máximo una
   línea, idealmente verbo + objeto.
4. **Mensajes a un actor** (``Auth -> Supervisor : ...``)
   son legítimos cuando el sistema **muestra** o
   **notifica** algo al humano.
5. **No esconder mensajes implícitos** críticos —
   especialmente la auditoría: si una operación
   dispara un evento de ``aud_app``, ese mensaje
   **debe** aparecer (CNST_025).
6. **Orden cronológico estricto** — leer de arriba
   hacia abajo debe contar la historia del flujo
   completo.

Ejemplo IACT — primer intercambio UC_RPT_01
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Aplicado al UC_RPT_01 (consultar dashboard) con SLA
CNST_017:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_RPT_01 — primer intercambio dashboard

   actor Supervisor
   participant "Browser" as B
   participant "rpt_app" as Rpt

   Supervisor -> B : selecciona dashboard
   B -> Rpt : GET /dashboard?segmento=N
   Rpt --> B : 200 OK (HTML + datos)
   B --> Supervisor : renderiza dashboard
   note right of Rpt
     SLA CNST_017: respuesta <= 10s
   end note
   @enduml

La nota referencia explícitamente la restricción
temporal sin saturar la etiqueta del mensaje. Este
patrón (mensaje + nota explicativa) se repite a lo
largo de la documentación IACT.

2.1.quater Mostrar lógica de bifurcación
----------------------------------------

La mayoría de los flujos tiene al menos un **happy
path** (todo sale bien) y uno o más **unhappy paths**
(algo falla). Modelar al menos un unhappy path crítico
en la misma secuencia ayuda a identificar dónde
concentrar el manejo de errores.

Sin embargo: **no detallar todo lo que puede salir
mal** en una sola secuencia — se vuelve ilegible. Si
hay varios unhappy paths importantes, hacer **diagramas
separados** para cada uno.

Sintaxis PlantUML — alt / else / end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PlantUML usa **exactamente la misma sintaxis** que
Mermaid para alternativas:

.. code-block:: text

   alt invalid input
       Sign_Up_Service --> Browser : Error
   else valid input
       Sign_Up_Service -> User_Service : POST /users
       User_Service --> Sign_Up_Service : 201 Created
       Sign_Up_Service --> Browser : 301 Redirect
   end

Lectura: ``alt`` abre la primera rama con su guarda
``[invalid input]``; ``else`` abre la rama alternativa;
``end`` cierra el bloque. Se admiten múltiples ``else``
para más de dos ramas, pero conviene mantenerlo bajo.

Equivalente IACT del flujo del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El libro modela ``Sign Up Service`` validando input,
con rama ``invalid → Error`` y rama ``valid → POST
/users → 201 Created → 301 Redirect``. En IACT el
flujo análogo es **UC_AUTH_01 Login** con validación
de credenciales:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — Login con bifurcacion happy/unhappy

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth
   database "ldap-corporativo" as LDAP
   database "Redis" as Redis
   database "audit_log" as Audit

   Supervisor -> B : envia credenciales
   B -> Auth : POST /login (user, pass)
   Auth -> Auth : validar formato

   alt [credenciales invalidas]
     Auth -> Audit : registrar intento fallido (CNST_011)
     Auth --> B : 401 Unauthorized
     B --> Supervisor : muestra error
   else [credenciales validas]
     Auth -> LDAP : authenticate(user, pass)
     LDAP --> Auth : OK + atributos
     Auth -> Redis : crear sesion (CNST_002)
     Auth -> Audit : registrar acceso exitoso
     Auth --> B : 302 Redirect (panel)
     B --> Supervisor : muestra panel
   end
   @enduml

Análisis del diagrama
~~~~~~~~~~~~~~~~~~~~~

- **Happy path** = `[credenciales válidas]`: validación
  → autenticación LDAP → creación de sesión en Redis
  (CNST_002) → registro en ``audit_log`` (CNST_025) →
  redirect al panel.
- **Unhappy path** = `[credenciales inválidas]`:
  registro del intento fallido (CNST_011 throttling) +
  401 al navegador.
- **Audit en ambas ramas**: cada rama dispara un
  registro en ``aud_app``. Ningún flujo IACT debe
  tener un alt sin auditoría asociada.

Múltiples alternativas
~~~~~~~~~~~~~~~~~~~~~~

PlantUML soporta varios ``else`` para flujos con más
de dos ramas:

.. code-block:: text

   alt [caso 1]
     A -> B : caso 1
   else [caso 2]
     A -> C : caso 2
   else [caso 3]
     A -> D : caso 3
   end

En IACT esto puede aparecer en UC_RPT_04 export con
tres caminos: cuota agotada, throttling, OK.

Reglas IACT para bifurcaciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Modelar al menos un unhappy path crítico** en la
   secuencia principal — refuerza la disciplina de
   manejo de errores.
2. **Si hay más de dos unhappy paths importantes**,
   crear **diagramas separados** uno por escenario,
   no anidar.
3. **Cada rama debe registrar audit** cuando aplique
   (CNST_025) — no esconder eventos auditables en el
   "if no falla".
4. **Etiquetar las guardas** entre corchetes
   (``[credenciales válidas]``) o con el texto entre
   ``alt``/``else`` directamente. Sin guarda, el
   diagrama miente sobre qué rama se ejecuta.
5. **Mantener máximo 3-4 ramas** — más de eso es
   señal de descomponer en flujos separados.

Política de espaciado
~~~~~~~~~~~~~~~~~~~~~

Como recomienda el autor citado, separar visualmente
**bloques de mensajes distintos** con líneas en blanco
en el código fuente PlantUML. No afecta el render pero
facilita el mantenimiento. Aplicar al alt: dejar línea
en blanco antes de ``alt`` y después de ``end``.

----

2.1.quater.bis Bifurcación opcional — bloque ``opt``
----------------------------------------------------

El bloque ``alt`` modela una bifurcación con **dos
o más ramas exclusivas**. Cuando solo hay **una
rama condicional** — un IF sin else — el fragmento
canónico es ``opt`` (de "optional"). PlantUML lo
soporta nativamente:

.. code-block:: text

   opt [guarda]
     A -> B : mensaje condicional
   end

Lectura: si la guarda se cumple, los mensajes
dentro del bloque se ejecutan; si no, el flujo
salta al final del bloque sin recorrer ninguna
rama alternativa.

Diferencia con ``alt``
~~~~~~~~~~~~~~~~~~~~~~

- ``alt`` — múltiples ramas; **una sola se
  ejecuta**.
- ``opt`` — una sola rama; **se ejecuta o se
  salta**.

Si el modelado solo necesita "esto pasa cuando se
cumple X, si no, nada", ``opt`` es más conciso
que ``alt`` con un ``else`` vacío.

Aplicación a IACT
~~~~~~~~~~~~~~~~~

Casos típicos donde ``opt`` aplica:

- **Notificación opcional** — si el usuario tiene
  preferencia de buzón habilitada (CNST_001),
  enviar notificación; si no, omitir el paso.
- **Audit detallado opcional** — para eventos no
  críticos, registrar payload extendido solo si
  el flag de auditoría granular está activo.
- **Validación adicional** — cuando un flag
  específico exige una verificación extra antes
  de continuar.

Ejemplo IACT
~~~~~~~~~~~~

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_RPT_04 — paso opcional de notificacion

   participant "rpt_app" as Rpt
   participant "log_app" as Log
   actor Supervisor

   Rpt -> Rpt : encolar export

   opt [supervisor.notif_buzon == true]
     Rpt ->> Log : notificar buzon (CNST_001)
     Log --> Supervisor : entrega mensaje
   end

   Rpt --> Rpt : retornar tarea_id
   @enduml

Lectura: la notificación al buzón solo se dispara
cuando el supervisor tiene la preferencia
activada; si no, el flujo continúa sin tocar
``log_app``.

Política IACT — uso de ``opt``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Etiquetar la guarda** ``[condicion]``
   siempre — sin etiqueta, ``opt`` queda
   ambiguo.
2. **Preferir ``opt`` sobre ``alt`` con else
   vacío** — mejor expresividad, menos ruido
   visual.
3. **No anidar más de dos opt** — si hay tres
   condiciones encadenadas, evaluar
   reestructurar como ``alt`` con varias ramas.
4. **Audit dentro de ``opt``** sigue las reglas
   generales (§ 2.1.quater): si una rama
   condicional dispara un evento auditable
   (CNST_025), debe quedar visible.
5. **Si la guarda evalúa una restricción del
   proyecto** (CNST_*, BR_*), citarla en la
   etiqueta o en una nota adyacente.

Resumen — fragmentos disponibles
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Con ``opt`` queda completo el catálogo de
fragmentos canónicos para flujos en IACT:

.. list-table::
 :widths: 22 38 40
 :header-rows: 1

 * - Fragmento
   - Significado
   - Sección
 * - ``alt``
   - Una de varias ramas (IF/ELSE).
   - § 2.1.quater
 * - ``opt``
   - IF simple — se ejecuta o se salta.
   - § 2.1.quater.bis
 * - ``loop``
   - Iteración hasta condición.
   - § 10.1
 * - ``par``
   - Ramas paralelas — todas se ejecutan.
   - § 10.2.bis
 * - ``break``
   - Salida temprana del enclosing fragment.
   - PlantUML lo soporta; usarlo solo cuando
     el flujo lo justifique.

----

2.1.quinquies Mostrar mensajes asíncronos
-----------------------------------------

Hasta aquí los mensajes han sido **síncronos** (request
con respuesta esperada). En arquitecturas modernas es
común el **mensaje asíncrono** *fire-and-forget*: el
emisor publica un evento y continúa sin esperar
respuesta.

Sintaxis PlantUML
~~~~~~~~~~~~~~~~~

PlantUML usa ``->>`` para mensajes asíncronos
(equivalente a ``--)`` en Mermaid del libro citado).

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Mermaid (libro)
   - PlantUML (IACT)
   - Render
 * - ``->>``
   - ``->``
   - Línea continua, flecha rellena (sync request).
 * - ``-->>``
   - ``-->``
   - Línea punteada, flecha rellena (sync response).
 * - ``--)``
   - ``->>``
   - Línea punteada, flecha abierta (async).

Importante: la flecha ``->>`` significa **distinto** en
Mermaid (sync) y en PlantUML (async). La política IACT
usa la convención PlantUML.

Cuándo usar mensajes asíncronos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Eventos del dominio que no requieren respuesta
  inmediata.
- Notificaciones a buzón interno (CNST_001).
- Encolado de tareas async (CNST_019 export).
- Triggers de auditoría — el caller no espera el
  ack del registro (CNST_025).
- Publicación de alertas — el evaluador no espera
  acuse del supervisor.

Stack IACT y mensajes asíncronos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Por **ADR_DEVOPS_001**, el stack canónico no incluye
Kafka. Los mecanismos asíncronos disponibles en IACT
son más simples:

- **Apache + mod_wsgi worker pool** — concurrencia de
  requests.
- **Tareas async vía cron** o **Django management
  commands** — para batches.
- **Buzón interno** (``log_app``) — publicación a un
  destinatario.
- **Bus de eventos in-process** (Observer pattern,
  ver § 8 de :doc:`patrones-diseno`) — propagación de
  eventos auditables sin red.

Cualquier uso futuro de un broker externo (Kafka,
RabbitMQ, Redis Streams) requiere un ADR explícito —
no es la posición por defecto del proyecto.

Equivalente IACT del ejemplo del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El libro publica un evento ``User Created`` en Kafka
desde ``User Service``. En IACT el evento equivalente
es un **registro de auditoría** disparado desde
``aud_app`` cuando una sesión se crea, sin que el
flujo principal espere acuse:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — registro auditable async (CNST_025)

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth
   participant "log_app" as Log
   database "Redis" as Redis
   database "audit_log" as Audit

   Supervisor -> B : envia credenciales
   B -> Auth : POST /login
   Auth -> Redis : crear sesion (CNST_002)
   Auth ->> Audit : registrar evento (async)
   Auth ->> Log : notificar buzon supervisor (async, CNST_001)
   Auth --> B : 302 Redirect (panel)
   B --> Supervisor : muestra panel
   @enduml

Análisis:

- ``Auth ->> Audit`` — flecha asíncrona; el flujo
  principal no espera la confirmación de
  ``audit_log``. La invariante CNST_025 (audit
  inmutable) se preserva por construcción del bus de
  eventos: si la persistencia falla, se reintenta sin
  detener el login.
- ``Auth ->> Log`` — la notificación al buzón interno
  no bloquea la respuesta al supervisor.
- ``Auth --> B`` — síncrono (línea punteada con flecha
  rellena) porque el navegador sí espera la
  redirección.

Cambiar el orden de los participantes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como menciona el autor citado, el orden de declaración
de los participantes determina el orden visual de
izquierda a derecha. Esa es la **tercera razón**
(complementando § 2.1.bis) para declararlos
explícitamente al inicio.

En IACT esto se aprovecha para dar protagonismo al
componente más relevante del flujo. Para UC_AUTH_01
ponemos ``auth_app`` cerca del actor; para UC_RPT_04
ponemos ``rpt_app`` central; para UC_PIP_01 ponemos
``etl_runner`` al frente. La regla informal:
**componentes más relevantes a la izquierda**, después
del actor.

Reglas IACT para mensajes asíncronos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Asíncrono solo cuando realmente lo es** — si el
   caller usa el resultado, es síncrono.
2. **Audit típicamente async** — el bus
   ``aud_app`` no debe bloquear el flujo del UC.
3. **Notificaciones al buzón interno (CNST_001) async**
   — el supervisor revisa cuando puede.
4. **Sin Kafka / RabbitMQ por defecto** — cualquier
   broker externo requiere ADR.
5. **Etiquetar cada mensaje async** con su naturaleza:
   "registrar evento (async)", "notificar buzón
   (async)" — quien lee el diagrama no debe inferir
   solo de la flecha.

----

2.1.sexies Mostrar duración con activaciones
--------------------------------------------

Las **activaciones** son rectángulos angostos sobre la
línea de vida que indican **desde cuándo** un
participante está procesando un mensaje hasta **cuándo**
devuelve la respuesta. No representan tiempo absoluto,
pero comunican visualmente:

- Dónde **empieza y termina** cada interacción.
- Qué participante tiene la **complejidad mayor**
  (activaciones más largas).
- Cuándo un mensaje **anida** dentro de otro
  (activaciones encajadas).

Sintaxis PlantUML
~~~~~~~~~~~~~~~~~

PlantUML soporta dos formas, igual que Mermaid:

**Forma explícita** — ``activate`` / ``deactivate``:

.. code-block:: text

   Browser -> Auth : GET /login
   activate Auth
   Auth --> Browser : 200 OK
   deactivate Auth

**Forma inline** — sufijo ``++`` para activar y
``--`` para desactivar:

.. code-block:: text

   Browser -> Auth ++ : GET /login
   Auth --> Browser -- : 200 OK

Equivalencia con Mermaid del libro:

.. list-table::
 :widths: 32 32 36
 :header-rows: 1

 * - Mermaid (libro)
   - PlantUML (IACT)
   - Significado
 * - ``activate X`` / ``deactivate X``
   - ``activate X`` / ``deactivate X``
   - Forma explícita en líneas separadas.
 * - ``->>+`` / ``-->>-``
   - ``->>++`` / ``-->>--`` o
     ``-> X ++`` / ``-->`` con ``--``
   - Forma inline (sufijo en la flecha).

PlantUML acepta ambas; el render genera rectángulos
sobre la línea de vida del participante activo.

Cuándo usar cada forma
~~~~~~~~~~~~~~~~~~~~~~

- **Explícita** (``activate``/``deactivate`` en líneas
  propias): más legible cuando hay activaciones
  encajadas o cuando el flujo es complejo. El
  ``activate`` aparece como una línea distinta y es
  más fácil de localizar al editar.
- **Inline** (``++`` / ``--``): más conciso, mejor
  para flujos simples o cuando se quiere reducir el
  ruido del código fuente.

Equivalente IACT del flujo del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El libro muestra activaciones encajadas en el flujo
sign-up con tres niveles: ``Sign Up Service`` activo
durante el POST, dentro del cual ``User Service`` se
activa para el ``POST /users``. Aplicado a UC_AUTH_01
con activaciones encajadas:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — activaciones encajadas

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth
   database "ldap-corporativo" as LDAP
   database "Redis" as Redis
   database "audit_log" as Audit

   Supervisor -> B : envia credenciales
   B -> Auth ++ : POST /login

   Auth -> Auth : validar formato

   alt [credenciales invalidas]
     Auth ->> Audit : registrar intento (CNST_011)
     Auth --> B -- : 401 Unauthorized
   else [credenciales validas]
     Auth -> LDAP ++ : authenticate(user, pass)
     LDAP --> Auth -- : OK + atributos
     Auth -> Redis : crear sesion (CNST_002)
     Auth ->> Audit : registrar acceso
     Auth --> B -- : 302 Redirect (panel)
   end
   B --> Supervisor : muestra panel
   @enduml

Lectura del diagrama
~~~~~~~~~~~~~~~~~~~~

- ``B -> Auth ++`` — activa ``auth_app`` desde el
  POST hasta su respuesta.
- ``Auth -> LDAP ++`` — activa ``LDAP`` solo durante
  ``authenticate``.
- ``LDAP --> Auth --`` — desactiva ``LDAP`` al
  retornar.
- ``Auth --> B --`` — desactiva ``auth_app`` al
  responder al navegador (cierra la activación
  exterior).
- Mensajes asíncronos (``->> Audit``) **no activan**
  al destinatario en este modelo simple — el bus de
  audit es fire-and-forget.

A simple vista, el rectángulo de ``auth_app`` cubre
todo el procesamiento del login, y el rectángulo
interno de ``LDAP`` muestra que la autenticación es la
operación de mayor latencia dentro del flujo. Eso es
lo que las activaciones comunican.

Política IACT — cuándo usar activaciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Diagramas pedagógicos cortos**: opcional. Si el
   flujo tiene 3-5 mensajes lineales, las activaciones
   añaden más ruido que valor.
2. **Diagramas con bifurcación o anidamiento**:
   recomendado. Las activaciones hacen visible el
   **scope** de cada llamada y dónde anida una dentro
   de otra.
3. **Diagramas para revisión arquitectónica o
   aprobación**: obligatorio. Comunican la
   complejidad relativa y el alcance temporal.
4. **Mezcla síncrono / asíncrono**: las activaciones
   refuerzan la diferencia visual — un async no
   genera rectángulo del receptor.
5. **Forma elegida**: si todas las activaciones del
   diagrama son encajadas, preferir la **inline**
   (más conciso). Si solo unas pocas activaciones son
   relevantes, la **explícita** facilita destacar
   esas ubicaciones.

Reglas IACT adicionales
~~~~~~~~~~~~~~~~~~~~~~~

- Toda **bifurcación crítica** debe cerrar todas sus
  activaciones — un ``alt`` con ``activate`` sin su
  ``deactivate`` correspondiente produce diagramas
  defectuosos.
- En flujos con **SLA** (CNST_017) el rectángulo de
  activación visualiza dónde puede estar el cuello de
  botella; complementar con una nota que cite el SLA.
- Para flujos con **export async** (CNST_019), no
  activar al worker de export más allá del momento
  del encolado — el procesamiento posterior pertenece
  a un diagrama de secuencia separado.

----

2.1.septies Agregar contexto con notas
--------------------------------------

Las **etiquetas** de los mensajes deben mantenerse
breves (§ 2.1.ter). Cuando se necesita **contexto
adicional** —un detalle que el lector debe ver pero
que satura la etiqueta— el mecanismo correcto es la
**nota**.

Sintaxis PlantUML
~~~~~~~~~~~~~~~~~

PlantUML soporta tres formas de nota:

.. code-block:: text

   note left of Auth : detalle a la izquierda
   note right of Auth : detalle a la derecha
   note over Auth : detalle sobre el participante
   note over Auth, Audit : abarca dos participantes

Equivalencia con Mermaid del libro:

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid (libro)
   - PlantUML (IACT)
   - Posición
 * - ``Note left of X``
   - ``note left of X``
   - Pegada al lado izquierdo de X.
 * - ``Note right of X``
   - ``note right of X``
   - Pegada al lado derecho de X.
 * - ``Note over X``
   - ``note over X``
   - Centrada sobre X.
 * - ``Note over X, Y``
   - ``note over X, Y``
   - Atraviesa de X a Y.

PlantUML también admite notas multilínea con
``note ... end note`` y formato:

.. code-block:: text

   note right of Auth
     Detalle de la operación.
     Multiple líneas posibles.
   end note

Cuándo usar notas
~~~~~~~~~~~~~~~~~

- Resaltar una **restricción del proyecto** que aplica
  al mensaje (CNST_*, BR_*).
- Documentar un **detalle de seguridad o autenticación**
  que no cabe en la etiqueta (e.g. paso de token,
  encriptación).
- Indicar que un **evento publicado** será consumido
  por otros servicios o componentes.
- Marcar **deuda técnica**, **TODO crítico** o
  **WORKAROUND** localizados — anclados a un ADR si
  son permanentes.

Equivalente IACT del ejemplo del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El libro agrega ``Note left of Kafka: other services
take action based on this event`` para señalar el
fan-out del evento. En IACT el fan-out equivalente es
el bus interno de auditoría: un evento auditable
disparado desde una app es consumido por
``aud_app`` y, en algunos UCs, también por
``log_app`` para notificar al supervisor.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — fan-out auditable

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth
   participant "log_app" as Log
   database "audit_log" as Audit

   Supervisor -> B : envia credenciales
   B -> Auth : POST /login

   Auth ->> Audit : registrar evento (CNST_025)
   note right of Audit
     audit_log es immutable;
     no se reasigna ni borra
   end note

   Auth ->> Log : notificar buzon supervisor
   note over Log : entrega via buzon interno (CNST_001)

   Auth --> B : 302 Redirect (panel)
   B --> Supervisor : muestra panel
   @enduml

Análisis:

- **``note right of Audit``** — recuerda al lector la
  invariante CNST_025 sin saturar la etiqueta del
  mensaje. La nota se queda al lado del destino
  relevante.
- **``note over Log``** — ubica el comentario sobre el
  participante; útil cuando el detalle es **del
  participante**, no del mensaje específico.
- **Notas atravesando dos lifelines** son útiles para
  describir un **acuerdo entre componentes** (ej. un
  contrato de retry, una garantía de orden).

Política IACT — uso de notas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Notas para CNST/BR** que aplican al mensaje pero
   no caben en la etiqueta. Citar la sigla
   (``CNST_025``, ``BR_012``) explícitamente.
2. **Notas para fan-out** cuando un mensaje async
   detona múltiples consumidores; describir
   brevemente quiénes consumen.
3. **Notas para autenticación / seguridad** —
   resaltar que un endpoint requiere un token, una
   firma o un canal específico (LDAPS, mTLS).
4. **Notas para SLA** — referenciar CNST_017 cerca
   del rectángulo de activación que cubre el flujo
   crítico.
5. **No saturar** — un diagrama con más de 3-4 notas
   probablemente está mezclando varios niveles de
   detalle. Considerar separar en varios diagramas o
   mover detalles al texto RST adyacente.

Notas vs documentación adyacente
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para detalles **largos** (más de dos líneas) preferir
el **texto RST circundante**. Las notas dentro del
diagrama PlantUML deben ser **comentarios cortos** que
se leen junto a la línea relevante. Si la explicación
necesita un párrafo, no es una nota — es texto del
documento.

----

2.1.octies Anotar el diagrama con números de secuencia
------------------------------------------------------

Anotar cada mensaje con un **número** facilita
discutir el diagrama: en lugar de describir un
mensaje, basta con citarlo por su número (*"el paso
3 es donde validamos throttling"*).

Sintaxis PlantUML
~~~~~~~~~~~~~~~~~

PlantUML usa la directiva ``autonumber`` igual que
Mermaid:

.. code-block:: text

   @startuml
   !include ../../_static/plantuml-styles.puml
   autonumber
   B -> Auth : POST /login
   Auth -> LDAP : authenticate
   LDAP --> Auth : OK
   Auth --> B : 302 Redirect
   @enduml

El render agrega ``1``, ``2``, ``3``, ``4`` al inicio
de cada mensaje. PlantUML extiende lo básico:

.. list-table::
 :widths: 32 68
 :header-rows: 1

 * - Forma
   - Efecto
 * - ``autonumber``
   - Numeración 1, 2, 3, …
 * - ``autonumber 10``
   - Empieza en 10.
 * - ``autonumber 10 5``
   - Empieza en 10, incremento 5 (10, 15, 20, …).
 * - ``autonumber "<b>[000]"``
   - Formato con padding y estilo (negrita, ceros).
 * - ``autonumber stop``
   - Detiene la numeración.
 * - ``autonumber resume``
   - Reanuda la numeración previa.

Equivalente IACT del ejemplo del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Aplicado a UC_AUTH_01 con ``autonumber``:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — login con numeracion automatica

   autonumber

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth
   database "ldap-corporativo" as LDAP
   database "Redis" as Redis
   database "audit_log" as Audit

   Supervisor -> B : envia credenciales
   B -> Auth : POST /login
   Auth -> Auth : validar formato
   Auth -> LDAP : authenticate(user, pass)
   LDAP --> Auth : OK + atributos
   Auth -> Redis : crear sesion (CNST_002)
   Auth ->> Audit : registrar acceso (CNST_025)
   Auth --> B : 302 Redirect (panel)
   B --> Supervisor : muestra panel
   @enduml

Referirse al diagrama es directo: *"el paso 4 es la
autenticación contra LDAP"*, *"el paso 7 es donde
disparamos audit"*. Esa precisión vale especialmente
en revisiones de PR, en sesiones de design review y
en aprobaciones arquitectónicas.

Política IACT — cuándo numerar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Diagramas con más de 5 mensajes**: numerar
   ayuda a la discusión.
2. **Diagramas para revisión / aprobación**:
   numerar siempre — facilita las actas y los
   feedback comments.
3. **Diagramas pedagógicos cortos** (3-4
   mensajes): no numerar; las flechas hablan por sí
   solas.
4. **Diagramas con bifurcación**: la numeración
   continúa **a través** de las ramas — los pasos
   3a, 3b, etc. no son nativos. Si el lector
   necesita distinguir ramas, agregar una **nota**
   con la guarda.
5. **No reutilizar números entre diagramas**: cada
   diagrama tiene su propia numeración local. Las
   referencias cruzadas usan el ID del diagrama o
   el UC, no el número de paso.

Combinación con activaciones y notas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La numeración se combina sin conflicto con las
demás técnicas:

- **Activaciones** (§ 2.1.sexies) — los rectángulos
  de activación coexisten con los números.
- **Notas** (§ 2.1.septies) — las notas pueden
  referenciar números de paso ("ver paso 3").
- **alt / else** (§ 2.1.quater) — los bloques
  alternativos siguen numerando dentro de cada rama.

Para diagramas críticos del proyecto (UC_RPT_04
export, UC_PIP_01 ETL, UC_AUTH_01 login,
UC_ALR_03 reconocimiento), aplicar **todos los
enriquecimientos**: actores y participantes
explícitos + activaciones + alt + notas para
CNST/BR + ``autonumber``. Esa combinación produce
diagramas listos para revisión y onboarding.

----

2.1.nonies Enlaces y menús en participantes
-------------------------------------------

Mermaid soporta **menús desplegables** (drop-down) en
actores y participantes con un formato tipo JSON que
asocia varias claves-valor (por ejemplo, "Repository",
"Domain Model", "ADR"). Al renderizar y pasar el mouse
sobre el participante, aparece el menú con los enlaces.

PlantUML no ofrece menús desplegables nativos, pero sí
permite **enlazar un participante a una URL única** con
``[[url]]``, lo cual cubre el 80% del caso de uso.

Sintaxis PlantUML
~~~~~~~~~~~~~~~~~

Enlace simple en un participante:

.. code-block:: text

   participant "auth_app" as Auth [[https://repo.iact.local/auth_app]]

Con tooltip:

.. code-block:: text

   participant "auth_app" as Auth [[https://repo.iact.local/auth_app{repositorio}]]

Equivalencia funcional con Mermaid del libro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid (libro)
   - PlantUML (IACT)
   - Diferencia
 * - ``links X: {"Repo": "...", "Doc": "..."}``
   - ``participant X [[url]]``
   - PlantUML solo admite **una URL** por
     participante.
 * - Menú con varios enlaces al hover.
   - Tooltip simple al hover; click abre la URL.
   - Menú multilink solo en Mermaid.

Cuando el participante necesita **varios enlaces**
(repositorio + ADR + documentación), la solución
PlantUML / Sphinx es **mantenerlos en el texto RST
adyacente** al diagrama, donde Sphinx puede gestionar
referencias cruzadas internas (``:doc:``, ``:ref:``).

Política IACT
~~~~~~~~~~~~~

1. **Preferir referencias en el texto RST** al
   diagrama, no inline en PlantUML. Sphinx valida los
   destinos y los renderiza con la apariencia
   estándar del proyecto.
2. **Reservar ``[[url]]`` PlantUML** para casos donde
   tenga sentido convertir un participante en
   clickeable directo a documentación externa
   persistente (RFC, especificación oficial,
   documentación de un servicio externo).
3. **No enlazar a recursos efímeros** —
   issues, branches, borradores. La URL puede morir;
   el diagrama sobrevive.
4. **Si un participante merece varios enlaces**,
   listarlos en el párrafo introductorio del
   diagrama:

   .. code-block:: rst

      El siguiente diagrama modela UC_AUTH_01.

      Componentes referenciados:

      - :doc:`auth_app — modelo de dominio </requisitos/_metodologia-aplicacion/analisis-dominio>`
      - :doc:`Decisión de stack — ADR_DEVOPS_001 </normativa/...>`
      - :doc:`Restricciones aplicables — CNST_002, CNST_011, CNST_025 </requisitos/...>`

Limitaciones del enfoque PlantUML
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **No hay menú multilink** en el render PlantUML de
  Sphinx. Si esa funcionalidad fuera crítica para un
  caso específico, se podría considerar Mermaid solo
  para ese contexto (issue/discussion en GitHub) sin
  alterar la política general — pero esa decisión
  requeriría ADR (ver § "Reconocimiento de la
  limitación" en :doc:`diagramas-uml`).
- Los **menús/links no aparecen en PDF, presentaciones
  exportadas ni capturas de pantalla**. Como bien
  señala el autor citado, esto vale tanto para
  Mermaid como para PlantUML — los enlaces solo
  funcionan en HTML interactivo.

Recomendación práctica
~~~~~~~~~~~~~~~~~~~~~~

Para IACT, la combinación más robusta es:

- **Diagrama PlantUML autocontenido** sin enlaces
  inline.
- **Texto RST adyacente** con la lista de referencias
  cruzadas (UCs, ADRs, BRs, CNSTs, modelos de dominio).
- **El lector** que necesite "saltar al repositorio
  de auth_app" sigue las referencias del párrafo —
  la experiencia es similar al menú desplegable, pero
  más predecible y validable por Sphinx.

----

2.2 Convenciones
----------------

::

 Participante:    rectángulo en la parte superior
 Línea de vida:   línea vertical descendente desde el
                  participante (punteada)
 Activación:      rectángulo angosto sobrepuesto a la
                  línea de vida (representa ejecución)
 Mensaje:         flecha horizontal entre líneas de vida
 Auto-mensaje:    flecha que sale y vuelve al mismo
                  participante
 Tiempo:          progresa de arriba hacia abajo

----

3. Tipos de mensajes
====================

3.1 Mensaje simple (transferencia de control)
---------------------------------------------

::

 Objeto1 → Objeto2
   - Transferencia de control
   - No espera respuesta explícita
   - Flecha abierta

3.2 Mensaje sincrónico (bloqueante)
-----------------------------------

::

 Objeto1 ⇒ Objeto2
   - Espera respuesta antes de continuar
   - Llamada a función bloqueante
   - Flecha rellena
   - El más común en programación

3.3 Mensaje asincrónico (no bloqueante)
---------------------------------------

::

 Objeto1 ⇢ Objeto2
   - NO espera respuesta
   - El emisor continúa inmediatamente
   - Cola de mensajes / event bus
   - Flecha abierta de medio trazo

3.4 Ejemplo IACT — los tres tipos en UC_RPT_01
----------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Operador
   participant ":Frontend"   as F
   participant ":Backend"    as B
   participant ":SecRules"   as SR
   participant ":BDAnalytics" as BD
   participant ":AuditLog"   as AL

   Operador -> F   : 1. clic "Ver Dashboard"        (simple)
   F -> B          : 2. GET /api/dashboard          (sincrónico)
   activate B
   B -> SR         : 3. verificarPermiso(view_dashboard)\n  (sincrónico)
   activate SR
   SR --> B        : 4. autorizado + segmento
   deactivate SR
   B -> BD         : 5. SELECT con filtro segmento  (sincrónico)
   activate BD
   BD --> B        : 6. filas
   deactivate BD
   B ->> AL        : 7. registrar(VIEW_DASHBOARD)   (asincrónico,\n     CNST_025)
   B --> F         : 8. {datos, métricas, ts}
   deactivate B
   F --> Operador  : 9. dashboard renderizado
   @enduml

----

4. Diagrama de instancia — escenario feliz
==========================================

Una **instancia** es un escenario específico de un UC sin
condiciones alternativas.

4.1 Ejemplo IACT — UC_PIP_01 (Supervisar ETL, escenario OK)
-----------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor "Admin\nPipeline" as AP
   participant ":SupervisorETL" as Sup
   participant ":SchedulerETL"  as Sch
   participant ":BDAnalytics"   as BD
   participant ":AuditLog"      as AL

   AP -> Sup  : abrirSupervision()
   activate Sup

   Sup -> Sch : ultimoRun()
   activate Sch
   Sch --> Sup : run_id, fecha_inicio, estado
   deactivate Sch

   Sup -> BD  : SELECT errores WHERE run_id=?
   activate BD
   BD --> Sup : []  (sin errores)
   deactivate BD

   Sup -> AL  : registrar(VIEW_ETL_STATUS)
   activate AL
   AL --> Sup : ok
   deactivate AL

   Sup --> AP : panel ETL: estado OK,\nprox_ejecucion=02:00 AM
   deactivate Sup

   note over AP,AL
     Escenario feliz:
     última ejecución exitosa,
     CNST_008 ventana 6-12h
     respetada.
   end note
   @enduml

----

5. Diagrama genérico — múltiples escenarios
===========================================

Un diagrama **genérico** muestra varios escenarios alternos
en uno solo, usando ``alt`` / ``else`` (condiciones) y
``loop`` (ciclos).

5.1 Ejemplo IACT — UC_AUTH_01 (Iniciar sesión, todos los caminos)
-----------------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Usuario
   participant ":Frontend"     as F
   participant ":AuthService"  as A
   participant ":SecRules"     as SR
   participant ":SessionStore" as SS
   participant ":AuditLog"     as AL

   Usuario -> F : 1. submit (email, password)
   F -> A       : 2. POST /api/auth/login
   activate A

   A -> SR : 3. verificarThrottling(IP)\n   (CNST_011: 5 / 5min)

   alt [throttling alcanzado]
     SR --> A : 4a. denegado
     A ->> AL : 5a. registrar(LOGIN_BLOCKED_IP)
     A --> F  : 6a. {error: "IP bloqueada"}
     F --> Usuario : 7a. ✗ "Intentos máximos"
   else [throttling ok]
     SR --> A : 4b. autorizado

     A -> SS  : 5b. validarCredenciales(email, hash)

     alt [credenciales válidas]
       SS --> A : 6b1. user_record (is_active=true)

       alt [sesión existente — CNST_002]
         A -> SS : 7b1. invalidarSesionAnterior()
         SS --> A : 7b2. ok
       end

       A -> SS  : 8b. crearSesion(user_id, segmento)
       SS --> A : 9b. session_id, jwt
       A ->> AL : 10b. registrar(LOGIN_SUCCESS)
       A --> F  : 11b. {jwt, refresh_token, user}
       F --> Usuario : 12b. ✓ Redirect /dashboard
     else [credenciales inválidas]
       SS --> A : 6c. user_not_found
       A -> SS  : 7c. incrementarIntentos(IP)
       A ->> AL : 8c. registrar(LOGIN_FAILED)
       A --> F  : 9c. {error: "Credenciales"}
       F --> Usuario : 10c. ✗ Mostrar error
     end
   end
   deactivate A
   @enduml

----

6. Activaciones y duración — SLA CNST_017
=========================================

La **altura** de la activación representa la **duración**.
Útil para visualizar SLAs (CNST_017 — latencia ≤ 10 s).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant ":Backend" as B
   participant ":CacheRedis" as C
   participant ":BDAnalytics" as BD

   B -> C : GET reporte:dash:user_42
   activate C
   note left of C
     Cache lookup
     ~5 ms
   end note
   C --> B : MISS
   deactivate C

   B -> BD : SELECT métricas WHERE segmento=?
   activate BD
   note right of BD
     Query con filtro
     CNST_008 ~ 800 ms
   end note
   BD --> B : filas
   deactivate BD

   B -> C : SET reporte:dash:user_42 TTL=300
   activate C
   C --> B : ok
   deactivate C

   note over B
     Total ≈ 850 ms
     ≤ CNST_017 (10 s) ✓
   end note
   @enduml

----

7. Creación de objetos
======================

Los objetos pueden ser **creados durante la secuencia**.
Notación: mensaje ``<<create>>``. La posición en el eje
vertical indica el momento de creación.

7.1 Ejemplo IACT — Sesion creada en login
-----------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Usuario
   participant ":AuthService" as A
   participant ":SessionStore" as SS

   Usuario -> A : login(email, password)
   activate A
   A -> A : validarCredenciales()

   create participant ":Sesion" as S
   A -> S : <<create>> nueva(user_id, segmento)
   activate S
   S -> S : generarTokenJWT()
   S -> S : generarTokenRefresh()
   S --> A : token + session_id

   A -> SS : guardar(session)
   activate SS
   SS --> A : ok
   deactivate SS

   A --> Usuario : {jwt, refresh}
   deactivate A

   note right of S
     Objeto Sesion creado
     en este punto del tiempo.
     Vive hasta logout o
     timeout 15 min (CNST_002).
   end note
   @enduml

----

8. Destrucción de objetos
=========================

Los objetos pueden ser **destruidos** durante la secuencia.
Notación: ``destroy`` o una **X** al final de la línea de
vida.

8.1 Ejemplo IACT — Sesion destruida en logout
---------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Usuario
   participant ":Frontend"     as F
   participant ":AuthService"  as A
   participant ":Sesion"       as S
   participant ":AuditLog"     as AL

   Usuario -> F : clic "Cerrar sesión"
   F -> A       : POST /api/auth/logout
   activate A

   A -> S : invalidar()
   activate S
   S -> S : marcarRevocada()
   S --> A : ok
   deactivate S

   A ->> AL : registrar(LOGOUT)

   destroy S
   note over S
     Objeto Sesion destruido —
     tokens marcados revocados,
     entrada eliminada del
     SessionStore.
   end note

   A --> F : {ok}
   deactivate A
   F --> Usuario : redirigir a /login
   @enduml

----

9. Recursividad
===============

Un objeto puede **enviarse un mensaje a sí mismo**. Útil
cuando una operación se invoca recursivamente.

9.1 Ejemplo IACT — verificación de permiso heredado
---------------------------------------------------

UC_PERM_07: una macro-función puede implicar otras (catálogo
con relaciones reflexivas, ver
:doc:`relaciones-uml` § 5.2). El verificador recursivo debe
expandir cada función hasta llegar a las atómicas.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant ":SecRules"  as SR
   participant ":BDAnalytics" as BD

   [-> SR : verificarPermiso(usuario, "manage_users")
   activate SR

   SR -> BD : SELECT funciones_implicadas("manage_users")
   activate BD
   BD --> SR : [view_users, create_users, modify_users, delete_users]
   deactivate BD

   loop para cada función implicada
     SR -> SR : verificarPermiso(usuario, sub_funcion)
     activate SR
     SR --> SR : true | false
     deactivate SR
   end

   SR -->] : true (todas las atómicas\nestán autorizadas)
   deactivate SR
   @enduml

----

10. Ciclos y condicionales
==========================

10.1 Ciclo ``loop``
-------------------

::

 loop [condición]
   ... mensajes que se repiten ...
 end

Composición de ``loop`` con otras construcciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dentro del cuerpo de un ``loop`` puede aparecer
**cualquier construcción válida** del diagrama:
mensajes, ``alt`` para bifurcaciones por iteración,
``par`` para tareas paralelas dentro del ciclo,
notas, e incluso ``loop`` anidado.

Patrón self-message en ``loop``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Un patrón frecuente: el cuerpo del loop contiene un
**mensaje de un participante hacia sí mismo**, que
representa una iteración interna sin desbordar a
otros participantes. Sintaxis PlantUML:

.. code-block:: text

   loop por cada filtro
     Facade -> Facade : validar(f)
   end

El bucle interno queda confinado a la lifeline del
participante; el diagrama no se ensucia con flechas
hacia otros componentes que en realidad no
participan.

Aplicación a IACT
~~~~~~~~~~~~~~~~~

Casos canónicos donde el self-loop aplica:

- ``ExportarReporteFacade`` validando filtros en
  el ejemplo de § 10.2.bis (cada filtro
  inspeccionado contra el reporte sin mensaje
  externo).
- ``EvaluadorAlertas`` recorriendo umbrales
  configurados antes de decidir si publicar la
  alerta.
- ``ReglaSoD`` chequeando funciones miembro al
  evaluar la regla.

Cuándo usar ``loop`` con guardia explícita
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PlantUML acepta una etiqueta tras ``loop`` que
documenta la condición o el conjunto iterado:

.. code-block:: text

   loop hasta exito o n=3 reintentos
     ...
   end

   loop por cada llamada en lote
     ...
   end

La etiqueta hace explícita la **forma del bucle**
sin abrir la implementación. El lector entiende qué
condiciona la iteración sin consultar el código.

Política IACT
~~~~~~~~~~~~~

1. **Siempre etiquetar la condición** del loop —
   un bucle sin guardia oculta la intención.
2. **Self-message dentro de loop** cuando la
   iteración es interna del participante.
3. **No anidar más de dos loops** — si el flujo
   real lo requiere, considerar dividirlo en
   sub-diagramas o pasar a un diagrama de
   actividades (ver § 11 de
   :doc:`diagramas-actividades`).
4. **Los mensajes dentro del loop pueden mezclar
   sync, async, alt y par** — pero sin saturar.
5. **Auditar dentro del loop** solo si cada
   iteración merece registro propio; típicamente
   se audita el loop completo desde fuera.

10.2.bis Ejecución paralela — bloque ``par``
--------------------------------------------

Cuando varios mensajes ocurren **al mismo tiempo**
(no se esperan entre sí), no alcanza con `loop` ni
con `alt`. PlantUML provee el bloque ``par`` para
modelar **paralelismo explícito**:

.. code-block:: text

   par
     A -> B : tarea 1
   else
     A -> C : tarea 2
   else
     A -> D : tarea 3
   end

Lectura: ``A`` dispara las tres tareas
**simultáneamente**; el flujo continúa cuando todas
terminan (o cuando la operación lo defina).

Caso de uso típico — flujos de código
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En el nivel de código, ``par`` aparece cuando un
servicio dispara varias acciones colaterales que
no dependen entre sí:

- Audit + notificación al buzón.
- Persistencia + cache update + métricas.
- Encolado de tareas async hacia varios
  destinos.

Aplicación a IACT — ``ExportarReporteFacade``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Diagrama de flujo de código (no UC) del facade
``ExportarReporteFacade`` (ver § 6 de
:doc:`patrones-diseno`) procesando un export:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Code flow — ExportarReporteFacade.ejecutar (snapshot)

   autonumber

   participant "ExportarReporteFacade" as Facade
   participant "perm_app.SecRules" as Sec
   participant "rpt_app.Reporte" as Rpt
   participant "rpt_app.Worker" as Worker
   participant "aud_app.Bus" as Audit
   participant "log_app.Buzon" as Notify

   Facade -> Sec ++ : verificar(user, "exportar")
   Sec --> Facade -- : ok

   loop por cada filtro
     Facade -> Rpt : validar_filtro(f)
   end

   Facade -> Worker ++ : encolar_tarea(cfg)
   Worker --> Facade -- : tarea_id

   par
     Facade ->> Audit : registrar_evento("export_iniciado", tarea_id)
   else
     Facade ->> Notify : notificar(destinatarios, tarea_id)
   end

   Facade --> Facade : return tarea_id
   @enduml

Lectura del flujo:

- **Verificación** sync de permiso (``perm_app``).
- **Loop** sobre los filtros del request, cada uno
  validado por ``Reporte``.
- **Encolado** sync hacia el worker que procesa
  el export.
- **``par``** dispara simultáneamente el registro
  de auditoría (CNST_025) y la notificación al
  buzón interno (CNST_001) — ninguno bloquea al
  otro ni bloquea el retorno al caller.
- **``autonumber``** facilita referenciar pasos
  específicos en revisiones de PR.

Lo que captura el diagrama
^^^^^^^^^^^^^^^^^^^^^^^^^^

El diagrama explica algo que el código no
comunica de un vistazo: que el facade tiene
**responsabilidad orquestadora** clara y delega
a los expertos (``perm_app`` para permisos,
``Reporte`` para validación de filtros,
``Worker`` para procesamiento, ``aud_app`` y
``log_app`` para registros laterales). Cada
mensaje en el diagrama corresponde a una
responsabilidad del experto en información
(§ 13 de :doc:`patrones-diseno`).

Cuándo usar ``par`` vs ``loop`` vs ``alt``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 22 36 42
 :header-rows: 1

 * - Bloque
   - Cuándo
   - Ejemplo IACT
 * - ``loop``
   - Repetir N veces sobre una colección o hasta
     una condición.
   - Validar cada filtro de un export, reintentar
     ETL hasta éxito.
 * - ``alt`` / ``else``
   - Una sola rama se ejecuta según una guarda.
   - Credenciales válidas vs inválidas en
     UC_AUTH_01.
 * - ``par`` / ``else``
   - Varias ramas se ejecutan simultáneamente.
   - Audit + notificación tras un export exitoso.

Atención al ``else`` confuso
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tanto ``alt`` como ``par`` usan ``else`` como
separador de ramas, pero el significado es
distinto:

- ``alt`` ... ``else`` ... — **una sola** rama se
  ejecuta.
- ``par`` ... ``else`` ... — **todas** las ramas
  se ejecutan simultáneamente.

El bloque ``par`` se renombra a veces ``parallel``
en variantes UML para evitar la ambigüedad.
PlantUML acepta ``par``; al leer un diagrama
ajeno conviene mirar la palabra clave del
encabezado, no asumir.

Política IACT para ``par``
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Usar ``par`` solo cuando las ramas son
   genuinamente paralelas** — sin dependencias
   entre ellas.
2. **Marcar las ramas como asíncronas**
   (``->>``) cuando aplique — el bloque ``par``
   no implica async por sí mismo.
3. **Audit y notificación** son los casos típicos
   de ``par`` en IACT por CNST_025 + CNST_001 —
   ninguno bloquea al otro.
4. **Limitar a 3-4 ramas** — más de eso satura
   visualmente. Si hay más, considerar
   sub-diagramas.
5. **No abusar** — si un código real es secuencial
   pero rápido, no marcarlo como ``par`` solo
   porque "parece concurrente". El diagrama
   debe reflejar lo que el código hace.

10.2 Ejemplo IACT — UC_PIP_04 reintento ETL
-------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor "Admin\nPipeline" as AP
   participant ":SupervisorETL" as Sup
   participant ":SchedulerETL" as Sch
   participant ":BDAnalytics" as BD
   participant ":AuditLog" as AL

   AP -> Sup : solicitarReintento(run_id)
   activate Sup

   loop [intentos < 3 AND estado != EXITOSA]
     Sup -> Sch : enqueueReintento(run_id, intentos)
     activate Sch
     Sch -> BD : ejecutarCarga()
     activate BD

     alt [carga exitosa]
       BD --> Sch : commit_ok
       Sch --> Sup : EXITOSA
       Sup ->> AL : registrar(ETL_RETRY_SUCCESS)
     else [error temporal — timeout IVR]
       BD --> Sch : timeout
       Sch --> Sup : CON_ERRORES (temporal)
       Sup ->> AL : registrar(ETL_RETRY_FAILED_TEMP)
     else [error permanente]
       BD --> Sch : ERROR_PERM
       Sch --> Sup : ERROR_PERMANENTE
       Sup ->> AL : registrar(ETL_RETRY_FAILED_PERM)
     end
     deactivate BD
     deactivate Sch
   end

   alt [estado == EXITOSA]
     Sup --> AP : ✓ ETL recuperado
   else [3 intentos fallidos]
     Sup ->> AL : registrar(ETL_RETRY_GAVE_UP)
     Sup --> AP : ✗ Requiere intervención manual
   end
   deactivate Sup
   @enduml

----

11. Ejemplo completo crítico — UC_RPT_04 (Exportar reporte)
===========================================================

Combina todo: instancia + alternativas + creación de objeto +
loop + asincrónico + auditoría inmutable.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Supervisor
   participant ":Frontend"      as F
   participant ":Backend"       as B
   participant ":SecRules"      as SR
   participant ":Reporte"       as R
   participant ":BDAnalytics"   as BD
   participant ":ExportQueue"   as EQ
   participant ":BuzonInterno"  as BI
   participant ":AuditLog"      as AL

   == UC_RPT_04: Exportar reporte ==

   Supervisor -> F : clic "Exportar (Excel)"
   F -> B          : POST /api/reports/{id}/export?fmt=xlsx
   activate B

   B -> SR : verificarPermiso(export_excel)\n           + throttling CNST_020
   alt [permiso denegado o throttling]
     SR --> B : denegado
     B ->> AL : registrar(EXPORT_DENIED)
     B --> F  : 403
     F --> Supervisor : ✗ "Sin permiso o límite del día"
     deactivate B
   else [autorizado]
     SR --> B : ok + segmento

     B -> R : aplicarFiltrosSegmento(BR_012, CNST_008)
     activate R
     R -> BD : SELECT con filtro
     activate BD
     BD --> R : filas
     deactivate BD

     alt [filas ≤ 10k → síncrono]
       create participant ":Archivo" as A
       R -> A : <<create>> generarXLSX(filas)
       activate A
       A --> R : archivo
       deactivate A
       R ->> AL : registrar(EXPORT_OK)
       R --> B  : url_descarga
       B --> F  : url
       F --> Supervisor : descarga directa
       deactivate R
     else [filas > 10k → asincrónico CNST_019]
       R -> EQ : encolar(filtros, fmt, supervisor_id)
       activate EQ
       EQ --> R : job_id
       deactivate EQ
       R ->> AL : registrar(EXPORT_QUEUED)
       R --> B  : job_id
       B --> F  : "Procesando, te avisaremos"
       F --> Supervisor : aviso

       deactivate R

       loop [hasta job listo]
         EQ -> EQ : procesar(job)
         activate EQ
       end
       deactivate EQ

       EQ ->> BI : entregar(supervisor_id,\n            "Tu export está listo")
       BI ->> Supervisor : aviso al buzón\n(CNST_001)
     end
   end
   deactivate B
   @enduml

----

12. Relación con casos de uso
=============================

::

 Cada UC contiene UNO O MÁS diagramas de secuencias —
 uno por escenario relevante (principal + alternativas
 críticas).

 Ejemplo: UC_RPT_04 (Exportar reporte)
   ├─ Diagrama secuencia: escenario principal
   │  (≤ 10k filas, descarga directa)
   ├─ Diagrama secuencia: > 10k filas
   │  (export asíncrono via cola)
   ├─ Diagrama secuencia: throttling CNST_020 alcanzado
   └─ Diagrama secuencia: BD analytics no disponible

----

13. En el proyecto IACT — qué UCs requieren secuencias
======================================================

**Obligatorio (secuencias detalladas + alternativas):**

- ``UC_AUTH_01`` — Iniciar sesión (principal + 3
  alternativas: throttling, inválidas, sesión existente).
- ``UC_RPT_04`` — Exportar reporte (principal + async +
  throttling + sin BD).
- ``UC_PIP_04`` — Solicitar reintento ETL (principal +
  loop reintentos + agotamiento).
- ``UC_PERM_07`` — Verificar permiso (principal +
  recursividad para macro-funciones).

**Importante (secuencias medias):**

- ``UC_RPT_01`` — Ver dashboard (principal con CNST_017
  SLA).
- ``UC_ALR_03`` — Reconocer alerta (principal +
  notificación buzón CNST_001).
- ``UC_ACC_01`` — Asignar funciones (principal + SoD
  CNST_030).
- ``UC_AUD_01`` — Consultar auditoría (principal con
  filtros).

**Recomendado (secuencias básicas):**

- ``UC_USR_01`` / ``UC_USR_03`` / ``UC_USR_04`` — CRUD
  usuarios.
- ``UC_LOG_01..07`` — consulta de logs.
- ``UC_PIP_01`` / ``UC_PIP_02`` / ``UC_PIP_03`` —
  supervisión ETL.

  Cada UC incluye su(s) diagrama(s) de secuencia en la
  sección 7 del archivo
  ``casos-uso/<modulo>/uc-<mod>-<NN>-<desc>.rst`` per la
  plantilla
  :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`.

----

14. Ejercicio: visualizar tu propio flujo
=========================================

La obra citada cierra el capítulo de secuencias con un
ejercicio: **modelar un flujo del proyecto elegido** y,
como actividad opcional, **diagramar un fragmento de
código complejo** la próxima vez que aparezca, para
verificar si la secuencia ayuda a entenderlo.

Recomendación general
---------------------

- Elegir un flujo con **elementos complejos**:
  bifurcaciones, mensajes asíncronos, varios
  componentes participantes — para ejercitar todos
  los recursos del capítulo.
- Mantener el **mismo dominio** para los diagramas
  sucesivos del proyecto, evitando *context
  switching* entre empresas / dominios distintos.

Aplicación a IACT
-----------------

En este proyecto, como en los ejercicios de
:doc:`analisis-dominio` (§§ 15.12 y 16.9), el
ejercicio **ya está realizado y documentado** para
los UCs principales. La sección § 13 lista los UCs
que requieren secuencias detalladas.

Cinco flujos canónicos IACT (en orden recomendado de
modelado para nuevos contribuidores):

.. list-table::
 :widths: 22 35 43
 :header-rows: 1

 * - UC
   - Por qué es buen ejercicio
   - Recursos del capítulo que ejercita
 * - **UC_AUTH_01** Login
   - Flujo lineal con bifurcación clara (credenciales
     válidas / inválidas) e integración con LDAP
     externo. Ideal como **primer flujo** para fijar
     la sintaxis.
   - Actores + participantes, sync request/response,
     alt/else, audit async, notas para CNST.
 * - **UC_RPT_01** Dashboard
   - Flujo síncrono con SLA CNST_017 — perfecto para
     practicar **activaciones** y notas de SLA.
   - Activaciones, ``autonumber``, nota sobre el
     SLA.
 * - **UC_RPT_04** Export
   - Combina sync + async (encolado) + bifurcación
     por cuota / throttling / OK. **Ejemplo
     completo** del capítulo; reproduce todos los
     enriquecimientos.
   - Todo lo anterior + alt con tres ramas + async
     fan-out a worker + nota sobre CNST_019.
 * - **UC_PIP_01** ETL
   - Flujo cíclico con ventana CNST_006/008 y
     reintentos. Ejercita ``loop``, recursividad y
     condiciones por estado.
   - Ciclos (§ 10), creación de objetos (§ 7), notas
     sobre CNST_006/008.
 * - **UC_ALR_03** Reconocer alerta
   - Sincronización entre evaluador, audit y
     notificación al supervisor. Ejercita la
     **simultaneidad** y el fan-out auditable.
   - Async + sync + notas, dos consumidores en fan-out
     desde ``aud_app``.

Plan recomendado para nuevos contribuidores
-------------------------------------------

1. Leer este documento de principio a fin (§§ 1-13).
2. Elegir **UC_AUTH_01** como primer ejercicio:
   reproducir el diagrama existente, asegurando que
   se entiende cada elemento.
3. Modificarlo: cambiar el orden de participantes,
   convertir un mensaje sync en async (y validar que
   ya no aplica), agregar/quitar notas — para
   internalizar la sintaxis.
4. Pasar a **UC_RPT_04** como ejercicio avanzado:
   combina todos los recursos.
5. Para flujos nuevos del proyecto, partir de la
   plantilla canónica
   (:doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`)
   y aplicar las § 2.1.bis-octies de este documento.

Actividad bonus — diagramar código complejo
-------------------------------------------

Cuando aparezca una porción de código IACT que cuesta
entender (típicamente: orquestaciones cross-app, hooks
de audit, manejo de errores en ETL), abrir un boceto
PlantUML antes de modificar nada. Beneficios
observados:

- Detectar **mensajes implícitos** (auditoría que se
  esconde dentro de una llamada).
- Identificar **acoplamiento accidental** (una vista
  que toca tres apps directas en lugar de pasar por
  el facade).
- Validar **respeto a Demeter** (§ 11 de
  :doc:`orientacion-objetos`): si la secuencia obliga
  a anidar referencias, hay olor a violación.
- Revelar **flujos que no respetan SRP** (§ 17 de
  :doc:`orientacion-objetos`).

El boceto puede ser efímero — si después de
diagramarlo el código se entiende, no hace falta
publicarlo. Si revela un problema arquitectónico,
abrir un WP para refactorizar y conservar el diagrama
como evidencia.

Cuándo el ejercicio es solo personal vs cuándo
publicarlo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Personal** — boceto efímero para entender un
  flujo. No se publica; sirve solo al autor.
- **Equipo** — diagrama en un PR o issue para
  facilitar la revisión. Vive con el PR.
- **Proyecto** — diagrama del UC integrado al cajón
  ``_metodologia-aplicacion/``. Pasa por la plantilla
  canónica, respeta la política PlantUML (§ del
  :doc:`/base-cognitiva/plantuml-guide/guidelines`)
  y se mantiene actualizado conforme el UC evoluciona.

Cierre del capítulo
-------------------

Con §§ 1-14, el lector tiene los recursos para crear
**cualquier diagrama de secuencia** relevante a IACT:
desde un boceto rápido para discutir con un colega
hasta un diagrama formal de aprobación
arquitectónica. Las secciones siguientes
(:doc:`diagramas-colaboraciones`,
:doc:`diagramas-actividades`,
:doc:`diagramas-componentes`) cubren tipos de
diagrama complementarios que enriquecen lo
modelado aquí.

----

15. Recapitulación del capítulo
===============================

Antes de continuar con los siguientes diagramas
(:doc:`diagramas-colaboraciones`,
:doc:`diagramas-actividades`,
:doc:`diagramas-componentes`,
:doc:`diagramas-distribucion`), conviene fijar lo que
este documento ha cubierto.

Lo aprendido
------------

1. **Qué es un diagrama de secuencia y para qué
   sirve** — modelar interacciones entre actores y
   participantes a lo largo del tiempo (Preludio + § 1).
2. **Definir actores y participantes** —
   ``actor``, ``participant``, ``database``,
   ``boundary``, ``control``, ``entity``, ``queue``
   (§ 2.1.bis), con la regla de declararlos
   explícitamente para fijar orden e iconos.
3. **Agregar interacciones** — mensajes síncronos
   con ``->`` y respuestas con ``-->`` (§ 2.1.ter).
4. **Mostrar lógica de bifurcación** — bloques
   ``alt`` / ``else`` / ``end`` (§ 2.1.quater) con la
   regla IACT de auditar en cada rama.
5. **Mensajes asíncronos** — ``->>`` para
   *fire-and-forget* (§ 2.1.quinquies), distinguiendo
   sync vs async vs response.
6. **Activaciones para mostrar duración** — formas
   explícita (``activate``/``deactivate``) e inline
   (``++``/``--``) (§ 2.1.sexies).
7. **Notas para contexto adicional** —
   ``note left of`` / ``note right of`` /
   ``note over X`` / ``note over X, Y``
   (§ 2.1.septies).
8. **Numeración automática** con ``autonumber``,
   incluyendo offset, incremento, formato y
   stop/resume (§ 2.1.octies).
9. **Enlaces y menús en participantes** —
   ``[[url]]`` PlantUML como equivalente (más
   limitado) de los drop-down menus de Mermaid
   (§ 2.1.nonies).
10. **Que las secuencias sirven también para
    modelar interacciones entre clases**, no solo
    entre sistemas (§§ 2-13 de detalles canónicos
    IACT).

Síntesis sintáctica
-------------------

Un diagrama de secuencia se construye con piezas que
se combinan:

.. code-block:: text

   @startuml
   !include ../../_static/plantuml-styles.puml
   title <título>
   autonumber

   actor <Actor>
   participant "<Largo>" as <alias>
   database <BD>

   <emisor> -> <receptor> ++ : <etiqueta sync>
   <emisor> --> <receptor> -- : <etiqueta respuesta>
   <emisor> ->> <receptor> : <etiqueta async>

   alt [guarda]
     ...
   else [otra guarda]
     ...
   end

   note over <participante> : <comentario>
   @enduml

Esa plantilla cubre el 90% de los casos IACT. Los
recursos avanzados (creación de objetos § 7,
destrucción § 8, recursividad § 9, ciclos § 10) se
agregan cuando el flujo lo justifica.

Resultado consolidado del capítulo
----------------------------------

El equivalente IACT del flujo cerrado del libro
(``Sign Up Flow`` con todos los enriquecimientos) es
**UC_AUTH_01 con todos los recursos aplicados**:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_AUTH_01 — flujo final con todos los recursos

   autonumber

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth
   database "ldap-corporativo" as LDAP
   database "Redis" as Redis
   database "audit_log" as Audit
   participant "log_app" as Log

   Supervisor -> B : abre URL del panel
   B -> Auth ++ : GET /login
   Auth --> B -- : 200 OK (formulario)
   B --> Supervisor : muestra formulario

   Supervisor -> B : envia credenciales
   B -> Auth ++ : POST /login (user, pass)
   Auth -> Auth : validar formato

   alt [credenciales invalidas]
     Auth ->> Audit : registrar intento fallido
     note right of Audit
       CNST_011 throttling:
       max 5 intentos / 5 min
     end note
     Auth --> B -- : 401 Unauthorized
     B --> Supervisor : muestra error
   else [credenciales validas]
     Auth -> LDAP ++ : authenticate(user, pass)
     LDAP --> Auth -- : OK + atributos
     Auth -> Redis : crear sesion
     note right of Redis
       CNST_002: sesion unica
     end note
     Auth ->> Audit : registrar acceso (CNST_025)
     Auth ->> Log : notificar buzon (CNST_001)
     Auth --> B -- : 302 Redirect (panel)
     B --> Supervisor : muestra panel
   end
   @enduml

Este diagrama combina **todos los recursos del
capítulo** — actores y participantes con tipos
específicos, sync + async + response, alt con dos
ramas, activaciones inline, notas anclando CNST_*,
numeración automática.

Siguiente paso
--------------

Tras visualizar los flujos, el siguiente nivel del
diseño es **modelar la arquitectura completa** del
sistema: cómo los componentes y nodos físicos se
organizan más allá del flujo puntual de un UC. Eso
está cubierto en:

- :doc:`diagramas-componentes` — componentes
  desplegables y sus contratos.
- :doc:`diagramas-distribucion` — nodos físicos y
  redes.
- Vistas C4 (Context / Container / Component / Code)
  complementarias — pendientes de redactar como
  documento propio en ``base-cognitiva/``.

Ese es el siguiente capítulo conceptual del proyecto.

----

16. Catálogo consolidado de notaciones
======================================

Tabla índice del documento — lista todos los
componentes del diagrama de secuencias cubiertos en
el cajón con su sintaxis PlantUML, sección del
documento donde se desarrolla y el caso IACT
canónico donde aparece.

16.1 Lifelines y participantes
------------------------------

.. list-table::
 :widths: 22 25 18 35
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Actor (humano)
   - ``actor "Nombre" as A``
   - § 2.1.bis
   - ``Supervisor``, ``Auditor``,
     ``Operador ETL``.
 * - Participante (servicio /
     componente)
   - ``participant "Nombre" as P``
   - § 2.1.bis
   - ``auth_app``, ``perm_app``,
     ``rpt_app``.
 * - Database (persistencia)
   - ``database "Nombre" as DB``
   - § 2.1.bis
   - ``bd_analytics``, ``audit_log``,
     ``Redis``.
 * - Boundary (frontera /
     integración externa)
   - ``boundary "Nombre" as B``
   - § 2.1.bis
   - ``ldap-corporativo``, ``ivr-host``.
 * - Control (orquestador)
   - ``control "Nombre" as C``
   - § 2.1.bis
   - ``ExportarReporteFacade``.
 * - Entity (entidad de dominio)
   - ``entity "Nombre" as E``
   - § 2.1.bis
   - ``Reporte``, ``Sesion``,
     ``Alerta``.
 * - Lifeline + activación
   - ``activate``/``deactivate`` o
     ``++`` / ``--`` inline
   - § 2.1.sexies
   - UC_AUTH_01 con
     ``auth_app`` activo durante el
     login.

16.2 Mensajes
-------------

.. list-table::
 :widths: 22 25 18 35
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Mensaje síncrono
   - ``A -> B : etiqueta``
   - § 2.1.ter
   - ``Browser -> auth_app : POST /login``
 * - Mensaje de respuesta
   - ``A --> B : etiqueta``
   - § 2.1.ter
   - ``auth_app --> Browser : 200 OK``
 * - Mensaje asíncrono
     (fire-and-forget)
   - ``A ->> B : etiqueta``
   - § 2.1.quinquies
   - ``auth_app ->> audit_log :
     registrar evento`` (CNST_025).
 * - Self-message
   - ``A -> A : op interna``
   - § 10.1
   - ``Facade -> Facade :
     validar(filtro)``.
 * - Numeración automática
   - ``autonumber`` (con offset y
     formato opcionales)
   - § 2.1.octies
   - UCs con > 5 mensajes que se
     revisan en PR.

16.3 Fragments
--------------

.. list-table::
 :widths: 18 30 18 34
 :header-rows: 1

 * - Fragment
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - ``alt`` / ``else``
   - ``alt [guarda]`` ... ``else
     [guarda]`` ... ``end``
   - § 2.1.quater
   - UC_AUTH_01: credenciales válidas
     vs inválidas.
 * - ``opt``
   - ``opt [guarda]`` ... ``end``
   - § 2.1.quater.bis
   - UC_RPT_04: notificar buzón solo
     si la preferencia CNST_001 está
     activa.
 * - ``loop``
   - ``loop [condición]`` ... ``end``
   - § 10.1
   - UC_PIP_01: leer lotes hasta fin
     de ventana CNST_006/008.
 * - ``par`` / ``else``
   - ``par`` ... ``else`` ... ``end``
   - § 10.2.bis
   - UC_RPT_04: audit + notify
     simultáneos tras encolado.
 * - ``break``
   - ``break [guarda]`` ...
   - § 10.1 (mencionado)
   - Salida temprana en bucle ETL
     ante ventana agotada.

16.4 Notas y anotaciones
------------------------

.. list-table::
 :widths: 22 28 18 32
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Nota a un participante
   - ``note left of P : ...``,
     ``note right of P : ...``
   - § 2.1.septies
   - Nota CNST_002 al lado de
     ``Sesion``.
 * - Nota sobre dos participantes
   - ``note over P, Q : ...``
   - § 2.1.septies
   - Nota CNST_011 abarcando
     ``Browser`` y ``auth_app``.
 * - Nota multilínea
   - ``note right of P``
     ... ``end note``
   - § 2.1.septies
   - Aclaraciones de fan-out
     auditable.

16.5 Ciclo de vida de objetos
-----------------------------

.. list-table::
 :widths: 22 28 18 32
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Creación de objeto
   - ``create participant ":Obj"
     as O`` + flecha
     ``A -> O : <<create>>``
   - § 7
   - ``Sesion`` creada en
     UC_AUTH_01.
 * - Destrucción de objeto
   - ``destroy O`` o X al final
     de la lifeline
   - § 8
   - ``Sesion`` destruida en
     logout.

16.6 Enlaces y dirección
------------------------

.. list-table::
 :widths: 25 28 18 29
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Link en participante
   - ``participant ... [[url]]``
   - § 2.1.nonies
   - Enlace a docs externas
     persistentes (RFC, etc.).
 * - Forzar dirección
   - ``-down->``, ``-right->``
   - § 2.1.quinquies
   - Cuando el layout automático
     produce cruces.

16.7 Cómo usar la tabla
-----------------------

- **Buscar un componente** — Ctrl+F sobre la
  tabla por sintaxis o por nombre.
- **Ver el detalle** — saltar a la sección
  citada para encontrar el ejemplo IACT
  completo, las reglas y los antipatrones.
- **Reutilizar el snippet** — copiar la sintaxis
  de la columna PlantUML y adaptarla al UC en
  modelado.
- **Validar coherencia con políticas** — cada
  sección citada incluye sus 5 reglas IACT;
  consultar antes de cerrar el diagrama.

Esta tabla **se mantiene** sincronizada con las
secciones del documento. Cada vez que se agregue
una notación nueva o se mueva una existente,
actualizar esta tabla.

----

17. Galería de ejemplos canónicos IACT
======================================

Catálogo de **mini-diagramas reutilizables** —
uno por componente del catálogo (§ 16). Cada
ejemplo:

- Está dibujado en PlantUML, listo para
  copiar.
- Usa nombres del dominio IACT
  (``Supervisor``, ``auth_app``,
  ``audit_log``, etc.) o nodos genéricos
  cuando la notación es puramente sintáctica.
- Sirve de **plantilla** para crear el
  diagrama completo de un UC nuevo.

Cuando un nuevo contribuidor necesita modelar
una notación, **copia el snippet** de esta
galería, lo personaliza al UC y lo integra en
el documento que corresponda.

17.1 Actor humano
-----------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   actor "Supervisor" as S
   participant "auth_app" as Auth
   S -> Auth : envia credenciales
   @enduml

17.2 Participante (servicio Django)
-----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "rpt_app" as Rpt
   participant "perm_app" as Perm
   Rpt -> Perm : verificar(user, "exportar")
   Perm --> Rpt : ok
   @enduml

17.3 Database (BD persistente)
------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "rpt_app" as Rpt
   database "bd_analytics" as BDA
   Rpt -> BDA : SELECT agregados
   BDA --> Rpt : filas
   @enduml

17.4 Boundary (integración externa read-only)
---------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "etl_runner" as ETL
   boundary "ivr-host" as IVR
   ETL -> IVR : leer eventos del IVR
   IVR --> ETL : payload
   note right of IVR
     CNST_006: read-only;
     ventana 6-12h
   end note
   @enduml

17.5 Control (orquestador)
--------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   actor Supervisor
   control "ExportarReporteFacade" as Facade
   participant "perm_app" as Perm
   participant "rpt_app" as Rpt

   Supervisor -> Facade : ejecutar(user, cfg)
   Facade -> Perm : verificar
   Facade -> Rpt : encolar
   @enduml

17.6 Entity (entidad de dominio)
--------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "alr_app" as Alr
   entity "Alerta" as A
   Alr -> A : reconocer(supervisor)
   A --> Alr : nuevo estado
   @enduml

17.7 Activación inline
----------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   actor S as Supervisor
   participant "auth_app" as Auth
   database "Redis" as R

   S -> Auth ++ : POST /login
   Auth -> R : crear sesion (CNST_002)
   R --> Auth : ok
   Auth --> S -- : 302 panel
   @enduml

17.8 Mensaje síncrono y respuesta
---------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "Browser" as B
   participant "rpt_app" as Rpt

   B -> Rpt : GET /dashboard
   Rpt --> B : 200 OK (HTML + datos)
   @enduml

17.9 Mensaje asíncrono — fire-and-forget
----------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "rpt_app" as Rpt
   database "audit_log" as Audit
   participant "log_app" as Log

   Rpt ->> Audit : registrar export iniciado
   Rpt ->> Log : notificar buzon (CNST_001)
   @enduml

17.10 Self-message (iteración interna)
--------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "ExportarReporteFacade" as Facade

   loop por cada filtro
     Facade -> Facade : validar(filtro)
   end
   @enduml

17.11 Autonumber con offset
---------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   autonumber

   actor Supervisor
   participant "Browser" as B
   participant "auth_app" as Auth

   Supervisor -> B : envia credenciales
   B -> Auth : POST /login
   Auth --> B : 302 Redirect
   @enduml

17.12 Bifurcación ``alt`` / ``else``
------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "auth_app" as Auth
   database "ldap-corporativo" as LDAP
   database "audit_log" as Audit

   Auth -> Auth : validar formato

   alt [credenciales validas]
     Auth -> LDAP : authenticate
     LDAP --> Auth : OK
   else [credenciales invalidas]
     Auth ->> Audit : registrar intento (CNST_011)
   end
   @enduml

17.13 Bifurcación opcional ``opt``
----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "rpt_app" as Rpt
   participant "log_app" as Log

   Rpt -> Rpt : encolar export

   opt [supervisor.notif_buzon == true]
     Rpt ->> Log : notificar (CNST_001)
   end
   @enduml

17.14 Ciclo ``loop`` con guarda
-------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "etl_runner" as ETL
   database "bd_operativa" as BDO
   database "bd_analytics" as BDA

   loop hasta fin de ventana CNST_006/008
     ETL -> BDO : leer lote (read-only)
     BDO --> ETL : filas
     ETL -> BDA : insertar agregados
   end
   @enduml

17.15 Paralelismo ``par``
-------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "ExportarReporteFacade" as Facade
   database "audit_log" as Audit
   participant "log_app" as Log

   Facade -> Facade : encolar tarea

   par
     Facade ->> Audit : registrar evento
   else
     Facade ->> Log : notificar buzon
   end
   @enduml

17.16 Salida temprana ``break``
-------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "etl_runner" as ETL
   database "bd_operativa" as BDO

   loop hasta fin de ventana
     ETL -> BDO : leer lote
     break [ventana agotada]
       ETL -> ETL : marcar carga incompleta
     end
   end
   @enduml

17.17 Nota ``note left of``
---------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "auth_app" as Auth
   database "Redis" as R

   Auth -> R : crear sesion
   note left of R
     CNST_002:
     una sola sesion activa
     por usuario
   end note
   @enduml

17.18 Nota sobre dos participantes
----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "Browser" as B
   participant "auth_app" as Auth

   B -> Auth : POST /login

   note over B, Auth
     CNST_011 throttling:
     max 5 intentos / 5 min
   end note
   @enduml

17.19 Creación de objeto
------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "auth_app" as Auth

   create participant ":Sesion" as S
   Auth -> S : <<create>> nueva(user_id)
   @enduml

17.20 Destrucción de objeto
---------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   participant "auth_app" as Auth
   participant ":Sesion" as S

   Auth -> S : caducar()
   destroy S
   @enduml

17.21 Plantilla completa para nuevo UC
--------------------------------------

Punto de partida combinando los recursos más
frecuentes. Reemplazar nombres y mensajes según
el UC objetivo:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title UC_XXX_NN — descripcion breve

   autonumber

   actor "Actor" as ActorRol
   participant "App emisora" as Emisor
   participant "App receptora" as Receptor
   database "BD destino" as BD
   database "audit_log" as Audit

   ActorRol -> Emisor ++ : disparador

   alt [precondicion ok]
     Emisor -> Receptor : operacion principal
     Receptor -> BD : persistir resultado
     BD --> Receptor : ack
     Receptor --> Emisor : ok
     Emisor ->> Audit : registrar evento (CNST_025)
     Emisor --> ActorRol -- : exito
   else [precondicion no cumplida]
     Emisor ->> Audit : registrar denegado
     Emisor --> ActorRol -- : error
   end
   @enduml

17.22 Cómo usar esta galería
----------------------------

1. **Identificar el componente** que se necesita
   en el catálogo de § 16.
2. **Localizar el snippet** correspondiente en
   esta galería (§§ 17.1-17.20) o usar la
   plantilla completa (§ 17.21).
3. **Copiar el código fuente PlantUML** —
   click derecho sobre el bloque renderizado o
   abrir el ``.rst`` directamente.
4. **Adaptar al UC**: reemplazar nombres de
   participantes, ajustar protocolos y
   mensajes, anclar a las CNST/BR pertinentes.
5. **Integrar al documento del UC** (la
   plantilla canónica es
   :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`).

Mantenimiento de la galería
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Cuando se agregue una **notación nueva** al
  catálogo de § 16, agregar también un mini-
  diagrama aquí.
- Cuando se descubra una **plantilla mejor**
  para un componente específico, sustituir el
  ejemplo y registrar en el commit el cambio.
- Mantener los ejemplos **cortos** — su valor
  está en ser legibles de un vistazo. Si una
  plantilla crece más allá de ~10 mensajes,
  pertenece a un documento de UC, no a la
  galería.

----

18. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skills aplicadas**
   - ``rm-specification`` (modelado de la interacción
     entre objetos), ``rm-analysis`` (verificar
     consistencia con UCs)
 * - **Origen del documento**
   - Reescrito de "GUÍA-DIAGRAMAS-SECUENCIAS-INTERACCIONES-
     TEMPORAL" (Hora 9 de Schmuller, cheat-sheet aplicado
     interno con dominio ecommerce), reorientado al
     dominio real IACT.
 * - **Lección teórica**
   - :doc:`/base-cognitiva/_uml/uml-09-diagramas-secuencias`
 * - **Cheat-sheet UML**
   - :doc:`/base-cognitiva/_uml/cuando-usar-cada-diagrama`
 * - **Plantilla canónica de UC**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Ejemplos hermanos**
   - :doc:`diagramas-uml`,
     :doc:`orientacion-objetos`,
     :doc:`analisis-dominio`,
     :doc:`relaciones-uml`,
     :doc:`agregacion-interfaces`,
     :doc:`casos-uso-especificacion`,
     :doc:`casos-uso-diagramas`,
     :doc:`diagramas-estados`
 * - **Catálogo modular del dominio**
   - :doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`
 * - **Restricciones citadas**
   - CNST_001 (no email — sólo buzón interno),
     CNST_002 (sesión única + timeout 15 min),
     CNST_008 (filtro segmento en SQL),
     CNST_011 (throttling 5 / 5 min),
     CNST_017 (SLA ≤ 10 s),
     CNST_019 / 020 (export async + throttling diario),
     CNST_025 (auditoría inmutable),
     CNST_030 (SoD),
     BR_012 (segmento único).
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
