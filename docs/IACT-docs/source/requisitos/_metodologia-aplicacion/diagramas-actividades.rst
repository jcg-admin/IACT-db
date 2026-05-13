.. meta::
 :artefacto: METODOLOGIA_DIAGRAMAS_ACTIVIDADES
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
Diagramas de actividades — flujos y procesos en IACT (H11)
==========================================================

Propósito
=========

Modelar **los pasos** que recorre una operación de IACT:
secuencia, decisiones, paralelismo y responsabilidades.

Diferencia clave con otros diagramas:

- **Estados** → en qué estados está un objeto.
- **Actividades** → qué pasos realiza para llegar a esos estados.
- **Secuencias** → quién envía qué mensaje y cuándo.
- **Colaboraciones** → quién está conectado con quién en el espacio.

Pregunta que responde un diagrama de actividades:

   *¿Cuáles son los pasos, decisiones y flujos dentro de
   esta operación?*

Marco metodológico
==================

- Skill principal: ``rm-specification``
- Skill complementario: ``rm-analysis`` (modelado de flujo)
- Política de diagramación:
  :doc:`/base-cognitiva/plantuml-guide/guidelines`
- Estilos centralizados:
  ``source/_static/plantuml-styles.puml``

1. Componentes básicos
======================

Un diagrama de actividades de UML usa:

- **Nodo inicial** — círculo relleno.
- **Actividad** — rectángulo redondeado.
- **Decisión / merge** — rombo.
- **Fork / join** — barra horizontal.
- **Nodo final** — diana.

Forma canónica en PlantUML
--------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   start
   :Actividad 1;
   :Actividad 2;
   if (condicion?) then (si)
     :Actividad 3;
   else (no)
     :Actividad 4;
   endif
   stop
   @enduml

2. Decisiones (bifurcaciones)
=============================

Las **condiciones son mutuamente exclusivas**: solo una rama
se ejecuta. Etiquetar siempre la guarda entre corchetes o
con el texto de la decisión.

Ejemplo IACT — UC_AUTH_01 (Login)
---------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   start
   :Recibir credenciales;
   :Validar usuario en LDAP;
   if (credenciales validas?) then ([si])
     if (sesion previa activa?) then ([no])
       :Crear sesion (CNST_002);
       :Registrar acceso en AuditLog (CNST_025);
       stop
     else ([si])
       :Cerrar sesion previa;
       :Crear sesion nueva;
       stop
     endif
   else ([no])
     :Incrementar contador throttling (CNST_011);
     :Registrar intento fallido;
     stop
   endif
   @enduml

3. Rutas concurrentes (fork / join)
===================================

Cuando varias actividades pueden ejecutarse **al mismo
tiempo**, se usa fork/join. La reunificación espera a que
**todas** las ramas paralelas terminen.

Ejemplo IACT — UC_RPT_07 (Reporte programado)
---------------------------------------------

Al cierre de la ventana ETL (CNST_006/007/008), tres tareas
arrancan en paralelo: cálculo de métricas, persistencia y
notificación al solicitante.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   start
   :Detectar fin de ventana ETL;
   :Cargar configuracion del reporte;
   fork
     :Calcular metricas BR_016/017/018;
     :Persistir resultados en BDAnalytics;
   fork again
     :Generar archivo de exportacion (async, CNST_019);
     :Subir a almacen temporal;
   fork again
     :Componer notificacion;
     :Publicar en buzon interno (CNST_001);
   end fork
   :Marcar reporte como entregado;
   :Registrar evento en AuditLog;
   stop
   @enduml

4. Señales (eventos)
====================

Una actividad puede **enviar** una señal y otra **recibirla**
asincrónicamente. En PlantUML se modela con ``->`` entre
swimlanes o con notas explícitas.

Ejemplo IACT — Alerta crítica (UC_ALR_03)
-----------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   start
   :EvaluadorAlertas detecta umbral excedido;
   :Emitir senal "AlertaCritica";
   note right
     senal asincronica
     hacia el supervisor
   end note
   :Registrar emision en AuditLog;
   stop
   @enduml

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   start
   :Esperar senal "AlertaCritica";
   :Recibir senal;
   :Mostrar alerta en panel del supervisor;
   :Habilitar accion "reconocer";
   stop
   @enduml

5. Marcos de responsabilidad (swimlanes)
========================================

Los swimlanes muestran **quién** ejecuta cada actividad. En
IACT los carriles típicos son: Supervisor, Backend Django,
BD Operativa (read-only, CNST_007), BDAnalytics, Componente
ETL, Scheduler.

Ejemplo IACT — UC_RPT_04 (Exportar reporte)
-------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   |Supervisor|
   start
   :Seleccionar reporte y rango (max 6 meses, CNST_031);
   :Solicitar exportacion;
   |Backend|
   :Validar permiso (CNST_030 SoD);
   if (permiso ok?) then ([si])
     :Verificar throttling export (CNST_020);
     if (cuota disponible?) then ([si])
       :Encolar tarea async (CNST_019);
       |Worker Export|
       :Leer agregados de BDAnalytics;
       :Generar archivo CSV/XLSX;
       :Subir a almacen temporal;
       |Backend|
       :Notificar via buzon interno (CNST_001);
       |Supervisor|
       :Recibir notificacion;
       :Descargar archivo;
       stop
     else ([no])
       |Backend|
       :Responder "cuota agotada";
       stop
     endif
   else ([no])
     :Registrar intento denegado en AuditLog;
     stop
   endif
   @enduml

6. Ciclos
=========

Los ciclos se modelan con ``while``/``repeat``. En IACT
aparecen típicamente en lectura paginada de la BD operativa
y en reintentos controlados de ETL.

Ejemplo IACT — Carga ETL paginada (CNST_006/008)
------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   start
   :Inicializar offset = 0;
   :Definir tamano_lote;
   while (existen mas filas?) is ([si])
     :Leer lote desde BD operativa (readonly);
     :Transformar registros;
     :Insertar en BDAnalytics;
     :Avanzar offset;
     if (ventana ETL agotada?) then ([si])
       :Marcar carga como incompleta;
       break
     else ([no])
     endif
   endwhile ([no])
   :Cerrar carga;
   :Registrar resumen en AuditLog;
   stop
   @enduml

7. Diagramas híbridos
=====================

PlantUML permite combinar elementos de actividades con notas
de objeto, anclas a casos de uso o referencias a estados.
Usarlo con moderación: un solo diagrama no debe sustituir a
los demás, sino complementarlos donde el flujo lo requiera.

Recomendación IACT:

- Si el énfasis es **flujo del proceso** → actividades.
- Si el énfasis es **interacción** → secuencias o
  colaboraciones (:doc:`diagramas-secuencias`,
  :doc:`diagramas-colaboraciones`).
- Si el énfasis es **ciclo de vida del objeto** → estados
  (:doc:`diagramas-estados`).

8. Cuándo usar diagramas de actividades
=======================================

.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Usar cuando…
   - No usar cuando…
 * - El UC tiene flujo con **decisiones múltiples**.
   - Solo hay un par de pasos secuenciales.
 * - Hay **paralelismo** o concurrencia entre subsistemas.
   - El foco es estructura estática (usar clases).
 * - Conviene mostrar **responsabilidades** entre actores.
   - El foco es interacción mensaje a mensaje (usar
     secuencias).
 * - Documentamos **proceso de negocio** para no técnicos.
   - El UC ya quedó claro con la especificación textual.

9. UCs de IACT con diagrama de actividades obligatorio
======================================================

.. list-table::
 :widths: 28 32 40
 :header-rows: 1

 * - UC
   - Por qué
   - Elementos típicos
 * - ``UC_AUTH_01`` Login
   - Decisiones (credenciales, sesión previa) + throttling.
   - Decisión, ciclo de reintento, swimlane Backend/LDAP.
 * - ``UC_RPT_04`` Exportar reporte
   - Async + throttling + notificación.
   - Fork (export + notify), swimlanes Supervisor/Backend/Worker.
 * - ``UC_RPT_07`` Reporte programado
   - Concurrencia post-ETL.
   - Fork de tres ramas, join al final.
 * - ``UC_PIP_01`` Carga ETL
   - Ciclo paginado + ventana temporal CNST_006/008.
   - Loop, decisión por tiempo, swimlane ETL/BD.
 * - ``UC_ALR_03`` Reconocer alerta crítica
   - Señales + sincronización con auditoría/notificación.
   - Send/receive signal, fork/join.
 * - ``UC_PERM_07`` Verificar permiso
   - Decisión SoD (CNST_030).
   - Decisiones encadenadas, swimlane SecRules/AuditLog.

10. Buenas prácticas
====================

1. **Identificar inicio y fin** explícitos antes de dibujar.
2. **Listar pasos** en orden secuencial primero; introducir
   paralelismo solo donde realmente exista.
3. **Etiquetar guardas** ``[condicion]`` en cada salida del
   rombo. Sin guarda, el diagrama miente.
4. **Mantener un nivel de abstracción**: no mezclar
   actividades de negocio con llamadas HTTP en el mismo
   diagrama.
5. **Cerrar todos los joins** que abrieron forks.
6. **Validar caminos** recorriendo manualmente cada rama
   hasta un nodo final.
7. **Vincular** cada actividad relevante a su BR/CNST/UC en
   el texto adyacente, no dentro del diagrama.

11. Cuándo usar diagramas de actividades vs secuencias
======================================================

El diagrama de actividades es la herramienta natural
de IACT para **flujos complejos con bifurcaciones**;
el diagrama de secuencias
(:doc:`diagramas-secuencias`) es mejor para
**interacciones entre objetos o sistemas**. Las dos
herramientas se complementan; conviene saber **cuál
elegir** en cada caso.

11.1 Fortalezas de cada uno
---------------------------

.. list-table::
 :widths: 32 34 34
 :header-rows: 1

 * - Aspecto
   - Diagrama de actividades
   - Diagrama de secuencias
 * - Bifurcaciones (``alt``,
     decisiones condicionales)
   - Excelente — diamantes con guardas,
     fork/join nativos.
   - Aceptable con ``alt``/``else``, pero
     pierde claridad si hay >3 ramas.
 * - Subrutinas / actividades reutilizables
   - Excelente — actividades pueden
     referenciar sub-actividades.
   - Limitado — la secuencia se vuelve
     larga si se inlinen pasos repetidos.
 * - Interacción entre sistemas / clases
   - Aceptable — los swimlanes ayudan.
   - Excelente — eje temporal explícito,
     activaciones, mensajes etiquetados.
 * - Comunicación con stakeholders no
     técnicos
   - Excelente — flujos de proceso son
     intuitivos.
   - Aceptable — requiere familiaridad con
     UML.
 * - Concisión
   - Tiende a expandirse con cada rama.
   - Compacto cuando el flujo es lineal.
 * - Captura del orden temporal exacto
   - Bueno pero menos preciso.
   - Excelente — el eje vertical es
     tiempo.

11.2 Cuándo usar diagrama de actividades
----------------------------------------

- **Lógica de negocio compleja con muchas
  decisiones** — políticas, reglas de aprobación,
  cálculos condicionales (en IACT: SoD CNST_030,
  validación de export CNST_031, evaluación de
  alertas BR_016/017/018).
- **Flujos largos con responsabilidades repartidas**
  entre actores y subsistemas — los swimlanes los
  hacen visibles (en IACT: UC_RPT_04 export
  asincrónico con worker, UC_PIP_01 carga ETL).
- **Documentación de requisitos para stakeholders**
  no técnicos — un diagrama de actividades es más
  legible que una secuencia para discutir con un
  PM o un auditor.
- **Cuando una secuencia se vuelve inmanejable**
  por la cantidad de ramas: convertirla a
  actividades suele clarificar.

Ejemplo IACT donde aplica
~~~~~~~~~~~~~~~~~~~~~~~~~

Un motor de decisión análogo al ejemplo de un
loan-decision-engine sería en IACT el
**evaluador de SoD** (CNST_030):

- Reglas con múltiples ramas (función A vs
  función B en mismo grupo, exenciones por rol,
  escalamiento a comité).
- Stakeholders no técnicos (auditores, equipo de
  compliance) que necesitan entender la decisión.
- El detalle pertenece a un diagrama de
  actividades — no a una secuencia.

11.3 Cuándo usar diagrama de secuencias
---------------------------------------

- **Interacción entre objetos o sistemas** con orden
  temporal explícito (en IACT: UC_AUTH_01 con LDAP
  + Redis + audit_log).
- **Flujos lineales** con pocas ramas, donde el
  ``alt`` no satura el diagrama.
- **Cuando importa mostrar duración** y
  activaciones (SLA CNST_017).
- **Comunicación con ingenieros y SRE** — la
  semántica de mensajes y respuestas es directa.

11.4 Cuándo combinar ambos
--------------------------

Para UCs críticos, **ambos** vistos lado a lado
pueden valer la pena:

- **Secuencia** para la interacción detallada con
  protocolos y activaciones.
- **Actividades** para visualizar la lógica de
  negocio y las bifurcaciones.

En IACT esto aplica a UC_RPT_04 export y
UC_AUTH_01 login — los dos diagramas conviven en
sus respectivos cajones.

11.5 Heurística IACT
--------------------

Pregunta operativa al modelar un flujo:

1. **¿Cuántas ramas condicionales tiene el
   flujo?** Más de 3 → preferir actividades.
2. **¿Importa más el "qué hace" o el "cómo lo
   hacen los actores"?** Lo primero → actividades.
   Lo segundo → secuencias.
3. **¿La audiencia incluye no técnicos?** Sí →
   actividades.
4. **¿Hay un SLA o ventana temporal explícita?** Sí
   → secuencias (con activaciones).
5. **¿La secuencia ya escrita supera 30 mensajes?**
   Sí → considerar reformular como actividades.

Política IACT
~~~~~~~~~~~~~

1. **No duplicar diagramas** — para cada UC,
   elegir el formato que mejor cuente la historia.
2. **Si se duplica intencionalmente** (un UC
   crítico con ambos), mantenerlos sincronizados;
   un cambio en uno se refleja en el otro.
3. **Diagramas de actividades como insumo de
   discusión** con stakeholders; diagramas de
   secuencias como insumo de implementación.

----

12. Notaciones complementarias del diagrama de actividades
==========================================================

Las §§ 1-9 cubrieron las notaciones más usadas
(start, stop, actividades, decisiones, fork/join,
swimlanes, ciclos, señales). Esta sección agrupa
las **notaciones complementarias** del estándar UML
que el catálogo del cajón aún no detalla, con su
sintaxis PlantUML y el caso IACT donde aparecen.

12.1 Merge node (rombo de unión)
--------------------------------

A diferencia del **join** (barra horizontal que
sincroniza ramas paralelas), un **merge node** es
un rombo que **une rutas alternativas** sin
sincronizar — la primera rama que llegue continúa
el flujo.

PlantUML lo expresa con la sintaxis
``if`` / ``elseif`` / ``else`` / ``endif``: el
``endif`` actúa como merge implícito. También
admite merge explícito con ``repeat`` o construcciones
manuales.

Diferencia clave:

- **Join** — espera a **todas** las ramas paralelas.
- **Merge** — toma la **primera** rama que llega.

En IACT aparece cuando un flujo tiene varias
posibles entradas que confluyen sin necesidad de
esperarse mutuamente. Ejemplo: un dashboard que
puede actualizarse por refresh manual del
supervisor o por trigger automático del scheduler;
ambos caminos terminan en "renderizar dashboard".

12.2 Flow Final
---------------

El nodo de **flow final** representa el final
**anormal** de una rama del flujo — distinto del
final del sistema completo. Se dibuja como un
círculo con una X (en PlantUML: ``end`` dentro de
una rama).

Cuándo usarlo en IACT:

- Una rama de error que **termina** sin completar
  el flujo principal pero **no detiene** otras
  ramas paralelas.
- Un fallback que abandona la operación sin
  considerar que el sistema haya fallado
  globalmente.

Diferencia con el ``stop`` final de UML
(``end``):

- **Stop / Final state** — el sistema entero
  termina.
- **Flow Final** — solo termina **esa rama**
  específica.

12.3 Transition y self-transition
---------------------------------

Una **transition** es la flecha base del diagrama
de actividades: une una actividad **fuente** con
una actividad **objetivo**, y se dispara
automáticamente cuando la fuente termina su
trabajo. PlantUML las dibuja con ``-->`` o como
secuencia implícita entre dos ``:actividad;``
consecutivas.

Una **self-transition** es un caso particular:
la transición sale de una actividad y vuelve a la
**misma actividad**. Representa una iteración
interna o re-evaluación sin pasar por otra
actividad — es la cara "actividad" de los
self-messages que aparecen en diagramas de
secuencia (§ 10.1 de :doc:`diagramas-secuencias`).

PlantUML soporta self-transitions naturalmente
con ``while`` interno o transiciones explícitas
en activity diagrams. En IACT aparece típicamente
en estados de espera donde el actor revisa un
estado periódicamente sin avanzar.

12.4 Signal Send / Signal Accept
--------------------------------

UML diferencia dos pentágonos para señales:

- **Signal Send** (pentágono convexo, "punta
  saliendo") — el flujo **envía** una señal y
  continúa sin esperar respuesta.
- **Signal Accept** (pentágono cóncavo, "punta
  entrando") — el flujo **espera** una señal
  para continuar; sin la señal, queda
  bloqueado.

PlantUML usa la sintaxis ``->`` con
``send signal`` y ``receive signal`` para
diferenciarlos:

.. code-block:: text

   :tarea pre-señal;
   ->[señal X]
   :tarea post-señal;

O con notación explícita:

.. code-block:: text

   :emitir señal "AlertaCritica"; <<sdsend>>
   :recibir señal "AlertaCritica"; <<sdreceive>>

Aplicación a IACT
~~~~~~~~~~~~~~~~~

- **Send** — ``alr_app`` emite la señal
  ``AlertaCritica`` y continúa registrando
  audit; no espera al supervisor.
- **Accept** — el panel del supervisor espera la
  señal ``AlertaCritica`` para refrescar la lista
  visible; sin alertas pendientes, queda en
  estado de espera.

El par send/accept materializa el patrón
**Observer** (§ 8 de :doc:`patrones-diseno`) en
forma de diagrama de actividades.

12.5 Subactivity
----------------

Una **subactivity** es una actividad que
**referencia** otra actividad principal, modelada
en un diagrama propio. Sirve para descomponer un
flujo grande en piezas más pequeñas, manteniendo
cada nivel legible.

PlantUML lo expresa como una actividad simple en
el diagrama padre, con un comentario o nota que
remite al diagrama detallado:

.. code-block:: text

   :Validar export;
   note right
     Detalle: ver UC_RPT_04 sub-flujo
     "validar parametros" en
     diagrama X
   end note

En IACT esto aplica cuando un UC complejo
(UC_RPT_04 export con muchas validaciones) se
divide en sub-diagramas:

- Diagrama padre: flujo de alto nivel del UC.
- Sub-diagramas: detalle de cada actividad
  compleja (validar cuota, validar SoD,
  serializar formato).

Ventaja: cada sub-diagrama queda autocontenido
y reutilizable; el padre permanece legible.

12.6 Object node
----------------

Un **object node** representa una entidad de
datos que **viaja entre dos actividades**. Se
dibuja como un rectángulo etiquetado entre las
dos actividades involucradas.

PlantUML lo soporta con la sintaxis:

.. code-block:: text

   :Generar reporte;
   :[Reporte serializado];
   :Encolar export;

El paso intermedio entre corchetes representa el
objeto de datos que la primera actividad produce
y la segunda consume.

En IACT aparece para hacer explícito el flujo de
datos entre apps Django:

- ``rpt_app.generar`` produce ``[Reporte
  serializado]`` que ``rpt_app.exportar``
  consume.
- ``etl_runner.cargar`` produce ``[RegistroIngesta]``
  que ``aud_app.registrar`` consume.

Política IACT — uso de notaciones avanzadas
-------------------------------------------

1. **Merge, flow final, signal send/accept y
   object nodes** son notaciones legítimas de
   UML. Usar cuando el flujo lo requiere; no
   forzarlas decorativamente.
2. **Subactivity es la mejor herramienta para
   diagramas grandes** — descomponer en lugar
   de saturar.
3. **Self-transition con guarda explícita**
   ``[condición]`` siempre — un self-loop sin
   condición miente sobre el flujo.
4. **Signal send/accept** en IACT
   típicamente coincide con el patrón Observer;
   referenciar :doc:`patrones-diseno` § 8 cuando
   aplique.
5. **Si el diagrama necesita más de tres
   notaciones avanzadas**, considerar dividirlo
   — la legibilidad para audiencias mixtas se
   pierde rápido.

----

13. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill principal**
   - ``rm-specification``
 * - **Skill complementario**
   - ``rm-analysis``
 * - **Diagramas hermanos**
   - :doc:`diagramas-secuencias`,
     :doc:`diagramas-colaboraciones`,
     :doc:`diagramas-estados`
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Plantilla de UC**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Teoría UML**
   - :doc:`/base-cognitiva/_uml/index`
