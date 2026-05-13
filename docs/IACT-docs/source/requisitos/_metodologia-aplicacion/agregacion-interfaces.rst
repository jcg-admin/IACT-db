.. meta::
 :artefacto: EJEMPLOS_AGREG_INTERFACES_IACT
 :tipo: Guia
 :dominio: gestion
 :subdominio: pm
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================================
Agregación, composición, interfaces y realización — IACT
==================================================================

.. note::

 Compañero del :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc`.
 Muestra los 5 conceptos de **Hora 5 de Schmuller**
 (agregación, composición, interfaces, realización,
 visibilidad y ámbito) aplicados al **dominio real del
 proyecto IACT** — call center IVR + analytics + ETL + RBAC.

 Sirve como **referencia de precedente** para los autores que
 generen los 13 documentos del plan.

 Diagramas en **PlantUML** (política del proyecto, no Mermaid).

 Para la teoría genérica ver
 :doc:`/base-cognitiva/_uml/uml-05-agregacion-composicion-interfaces`
 (Schmuller Hora 5).

----

1. El camino al modelo completo
===============================

  La meta final es crear una **idea estática** de un sistema,
  con todas las conexiones entre las clases que lo conforman.

En esta hora completamos el modelo UML con:

- **Agregación** y **composición** (partes y todo).
- **Interfaces** (contratos de comportamiento).
- **Realizaciones** (implementación de interfaces).
- **Visibilidad** (acceso público / protegido / privado).
- **Ámbito** (instancia vs compartido / *archivador*).

----

2. Agregación (rombo vacío)
===========================

**Definición:** un *todo* se compone de *partes*, pero las
partes pueden existir **independientemente**.

**Característica clave:** un componente puede pertenecer a
**múltiples todos**.

**Símbolo:** rombo VACÍO (``o--``) en el lado del todo.

2.1 Funcion ◇ Grupo (catálogo RBAC IACT)
----------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class Grupo {
     - id : Integer
     - nombre : String
   }
   class Funcion {
     - codigo : String
     - descripcion : String
   }

   Grupo "*" o-- "*" Funcion : contiene
   note right of Funcion
     Una función (capacidad atómica) PUEDE
     existir sin pertenecer a ningún grupo;
     pertenece a múltiples grupos
     simultáneamente (predefinidos
     AGR-001..010 y/o creados via
     UC_PERM_05). Si un grupo se elimina,
     las funciones siguen vivas en el
     catálogo de 42 funciones (CNST_029).
   end note
   @enduml

2.2 Otras agregaciones canónicas IACT
-------------------------------------

::

 Centro          ◇  Operador           — operadores reasignables
 Campania        ◇  Operador           — operadores compartidos
 Suscripcion     ◇  Alerta             — la alerta sigue activa
                                         si un suscriptor se va
                                         (UC_ALR_05)
 SegmentoDatos   ◇  Reporte            — el segmento puede usarse
                                         por múltiples reportes

2.3 Restricción OR en agregación
--------------------------------

A veces la agregación tiene un patrón *"uno u otro"*. En IACT,
una **alerta crítica** notifica por canal de máxima visibilidad,
elegido entre dos opciones del buzón interno (sin email per
CNST_001):

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class AlertaCritica
   class CanalUrgente
   class CanalPrioritario
   class TipoEntregaImmediata

   AlertaCritica o-- CanalUrgente
   AlertaCritica o-- CanalPrioritario
   AlertaCritica o-- TipoEntregaImmediata

   note "{xor}\nCanalUrgente OR CanalPrioritario\n(no ambos)" as N
   CanalUrgente .. N
   CanalPrioritario .. N
   @enduml

2.4 Características fundamentales de la agregación
--------------------------------------------------

La agregación representa una relación **todo-parte** con
una asociación **más flexible** que la composición. Su
principio rector es **"tiene un"**, pero con una
**dependencia más débil** entre los objetos participantes.

La relación no se limita a vínculos físicos; admite
varios matices:

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Matiz semántico
   - Ejemplos
 * - "tiene un"
   - Una universidad **tiene** estudiantes; un curso
     **tiene** participantes; en IACT, un grupo
     ``Grupo`` **tiene** funciones ``Funcion``.
 * - "contiene un"
   - Una biblioteca **contiene** libros; un departamento
     **contiene** empleados; en IACT, ``Reporte``
     **contiene** filtros aplicados.
 * - "posee un"
   - Un equipo **posee** jugadores; una empresa
     **posee** contratos; en IACT, un supervisor
     **posee** alertas activas que reconoce.

Cuatro características distintivas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
 :widths: 28 36 36
 :header-rows: 1

 * - Característica
   - Significado
   - Ejemplo IACT
 * - **Ciclo de vida independiente**
   - El contenedor (todo) y los componentes (partes)
     tienen vidas independientes. Los componentes
     pueden existir antes, durante y después de
     pertenecer al contenedor.
   - Una ``Funcion`` del catálogo RBAC existe antes y
     después de que un ``Grupo`` la incluya. Los
     ``Usuario`` existen sin tener sesión activa.
 * - **Independencia de componentes**
   - Los componentes son opcionales para el contenedor
     y pueden existir por sí mismos; no son esenciales
     para que el contenedor exista.
   - Un ``Grupo`` puede crearse vacío; los segmentos
     atendidos (BR_012) pueden definirse sin
     ``Llamada`` previa.
 * - **Supervivencia de componentes**
   - La destrucción del compuesto **no destruye** a los
     componentes — siguen existiendo.
   - Si se elimina un ``Grupo``, las ``Funcion``
     individuales del catálogo permanecen disponibles
     para otros grupos.
 * - **Compartición de componentes**
   - Un componente puede pertenecer a varios
     compuestos simultáneamente.
   - Una ``Funcion`` puede asignarse a varios
     ``Grupo`` distintos; un ``Usuario`` puede
     pertenecer a varios grupos a la vez.

2.5 Características técnicas
----------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Característica
   - Valor
   - Implicación
 * - **Visibilidad**
   - Pública.
   - Los componentes son accesibles y compartidos
     entre diferentes contenedores.
 * - **Temporalidad**
   - Alta o media.
   - La relación puede durar mucho tiempo, pero no
     necesariamente toda la vida del contenedor o del
     componente.
 * - **Versatilidad**
   - Baja o media.
   - Limitada en cuanto a la naturaleza de los
     componentes, pero alta en cuanto a su
     compartición entre contenedores.

2.6 Implementación en el diseño
-------------------------------

La agregación se materializa típicamente con cinco
mecanismos:

.. list-table::
 :widths: 28 36 36
 :header-rows: 1

 * - Aspecto
   - Descripción
   - Ejemplo IACT
 * - **Atributos modificables**
   - Los atributos de la relación pueden cambiar de
     estado o valor durante el ciclo de vida.
   - El estado de pertenencia de un ``Usuario`` a un
     ``Grupo`` puede cambiar (alta / baja / suspendido).
 * - **Métodos de gestión**
   - Métodos específicos para insertar y eliminar
     componentes.
   - ``perm_app.SecRules`` expone
     ``agregar_funcion(grupo, funcion)`` y
     ``remover_funcion(grupo, funcion)``.
 * - **Referencias actualizables**
   - Las referencias pueden reasignarse a diferentes
     objetos durante el ciclo de vida.
   - Un ``Usuario`` puede transferirse de un ``Grupo``
     a otro sin recrearse.
 * - **Referencias privadas**
   - El contenedor mantiene referencias privadas; los
     objetos referenciados existen independientemente.
   - ``Grupo`` tiene una lista privada de
     ``Funcion`` y un cambio en la lista no destruye
     las funciones.
 * - **Pertenencia múltiple**
   - Mecanismos para gestionar componentes que
     pertenecen a varios contenedores.
   - Una ``Funcion`` puede aparecer en varios
     ``Grupo``; un ``Usuario`` puede pertenecer a
     varios grupos (asignación N:M).

2.7 Ejemplo canónico — Universidad y Estudiantes
------------------------------------------------

Modelo arquetípico de la literatura, útil para fijar el
patrón antes de aplicarlo a IACT.

Aspectos representados
~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
 :widths: 30 35 35
 :header-rows: 1

 * - Aspecto
   - Características
   - Implementación
 * - Visibilidad pública
   - La universidad permite acceso controlado a la
     lista de estudiantes; los estudiantes son
     accesibles por diferentes partes del sistema.
   - Métodos públicos que interactúan con la lista
     manteniendo encapsulamiento.
 * - Temporalidad alta/media
   - Los estudiantes se agregan o remueven en
     cualquier momento; la relación dura mientras el
     estudiante esté inscrito.
   - Estudiantes pueden entrar y salir sin afectar su
     existencia.
 * - Versatilidad por compartición
   - Un estudiante puede pertenecer a varios
     grupos / facultades; la universidad gestiona
     múltiples estudiantes.
   - Referencias compartidas entre múltiples
     contenedores simultáneamente.
 * - Implementación
   - Atributos modificables; métodos de gestión
     (alta / baja); referencias actualizables;
     referencias privadas con independencia.
   - Lista privada de referencias; métodos públicos
     para gestión; capacidad de transferir.

Diagrama UML
~~~~~~~~~~~~

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class Universidad {
     - estudiantes : List<Estudiante>
     - nombre : String
     + agregarEstudiante(e : Estudiante)
     + removerEstudiante(e : Estudiante)
     + transferirEstudiante(e, otra)
     + tieneEstudiante(e) : boolean
     + cantidadEstudiantes() : int
   }

   class Estudiante {
     - id : String
     - nombre : String
     - estado : String
     + cambiarEstado(nuevo : String)
   }

   Universidad o-- "0..*" Estudiante
   note bottom of Estudiante
     Existe independientemente
     de la Universidad
   end note
   @enduml

Implementación Java de referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: java

   class Estudiante {
       private String id;
       private String nombre;
       private String estado;  // activo, graduado, etc.

       public Estudiante(String id, String nombre) {
           this.id = id;
           this.nombre = nombre;
           this.estado = "activo";
       }

       public void cambiarEstado(String nuevoEstado) {
           this.estado = nuevoEstado;
       }
   }

   class Universidad {
       private List<Estudiante> estudiantes;
       private String nombre;

       public Universidad(String nombre) {
           this.nombre = nombre;
           this.estudiantes = new ArrayList<>();
       }

       public void agregarEstudiante(Estudiante estudiante) {
           if (estudiante != null
                   && !estudiantes.contains(estudiante)) {
               estudiantes.add(estudiante);
           }
       }

       public void removerEstudiante(Estudiante estudiante) {
           estudiantes.remove(estudiante);
           // El estudiante sigue existiendo
       }

       public void transferirEstudiante(
               Estudiante estudiante,
               Universidad otraUniversidad) {
           if (estudiantes.contains(estudiante)) {
               removerEstudiante(estudiante);
               otraUniversidad.agregarEstudiante(estudiante);
           }
       }

       public boolean tieneEstudiante(Estudiante estudiante) {
           return estudiantes.contains(estudiante);
       }

       public int cantidadEstudiantes() {
           return estudiantes.size();
       }
   }

Características clave
~~~~~~~~~~~~~~~~~~~~~

1. **Independencia de objetos** — los estudiantes existen
   sin la universidad; eliminar la universidad no afecta
   su existencia.
2. **Gestión dinámica** — alta, baja y transferencia de
   estudiantes durante el ciclo de vida.
3. **Control de acceso** — lista privada de referencias,
   métodos públicos de gestión.
4. **Flexibilidad** — un estudiante puede pertenecer a
   varios grupos; la universidad puede modificar su lista
   en cualquier momento.

2.8 Mapeo a IACT
----------------

El patrón Universidad/Estudiantes se materializa en IACT
en al menos cinco pares ``Contenedor``↔``Componente``:

.. list-table::
 :widths: 28 30 42
 :header-rows: 1

 * - Contenedor
   - Componente
   - Notas IACT
 * - ``Grupo``
   - ``Funcion`` (catálogo RBAC)
   - Una función pertenece a varios grupos; eliminar un
     grupo no elimina las funciones (CNST_030 SoD se
     mantiene a nivel de catálogo).
 * - ``Grupo``
   - ``Usuario``
   - Asignación N:M con clase intermedia
     ``Asignacion``; usuarios sobreviven a la
     disolución de grupos.
 * - ``Reporte``
   - ``Filtro``
   - Filtros se aplican a varios reportes; el reporte
     no destruye los filtros al cerrarse.
 * - ``Supervisor``
   - ``AlertaReconocida``
   - El supervisor mantiene una lista de alertas
     reconocidas; la alerta sobrevive aunque el
     supervisor cambie de rol.
 * - ``VentanaETL``
   - ``EjecucionETL``
   - Una ventana puede contener varias ejecuciones;
     ejecuciones permanecen como evidencia auditable
     incluso si la ventana se invalida (CNST_025 +
     CNST_006/008).

Anti-patrones IACT
~~~~~~~~~~~~~~~~~~

- Implementar ``Grupo`` con composición fuerte sobre
  ``Funcion`` (rombo relleno) — destruir un grupo no
  debe eliminar funciones del catálogo. Usar agregación.
- ``EventoAuditoria`` agregado a un ``Reporte``
  contenedor — incorrecto; el evento es **inmutable**
  y debe mantenerse en ``aud_app``, no como parte
  modificable del reporte.

----

3. Composición (rombo relleno)
==============================

**Definición:** un *todo* se compone de *partes*, pero las
partes **NO pueden existir sin el todo**.

**Característica clave:** un componente pertenece a **un solo
todo** (relación de pertenencia exclusiva).

**Símbolo:** rombo RELLENO (``*--``) en el lado del todo.

**Vida útil:** cuando el todo muere, las partes también mueren.

3.1 EjecucionETL ● ErrorETL (UC_PIP)
------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class EjecucionETL {
     - id : Integer
     - fecha_inicio : DateTime
     - fecha_fin : DateTime
     - estado : Enum
     + cargarDesdeIVR()
   }

   class ErrorETL {
     - codigo : String
     - mensaje : String
     - tabla : String
     - timestamp : DateTime
   }

   class FilaCargada {
     - tabla : String
     - id_origen : Integer
     - timestamp : DateTime
   }

   EjecucionETL "1" *-- "0..*" ErrorETL    : compone
   EjecucionETL "1" *-- "0..*" FilaCargada : compone

   note right of EjecucionETL
     Composición:
       si la EjecucionETL se purga
       (UC_PIP), sus ErrorETL y
       FilaCargada se eliminan
       en cascada. No tienen
       sentido fuera de la
       ejecución que los generó.
   end note
   @enduml

3.2 Otras composiciones canónicas IACT
--------------------------------------

::

 Reporte          ●  FilaResultado      — filas atadas al reporte
                                          que las generó
 Sesion           ●  Token              — los tokens expiran con
                                          la sesión (CNST_002)
 EventoAuditoria  ●  DetalleAuditoria   — detalle inmutable
                                          atado al evento
                                          (CNST_025)
 Alerta           ●  HistorialAlerta    — historial muere con
                                          la alerta

3.3 Diferencia visual agregación vs composición
-----------------------------------------------

::

 AGREGACIÓN (◇)                COMPOSICIÓN (●)
 ──────────────────────────────────────────────────────
 Partes independientes         Partes dependientes
 Componente ∈ múltiples todos  Componente ∈ un solo todo
 No obligatoria la existencia  Obligatoria la existencia
 Ejemplo: Funcion en Grupo     Ejemplo: ErrorETL en EjecucionETL

  **Pregunta decisiva:**
  *"Si el todo desaparece, ¿la parte sigue teniendo sentido?"*
  - Sí → agregación.
  - No → composición.

3.4 Características fundamentales de la composición
---------------------------------------------------

La composición es un tipo **especial de asociación** que
representa la relación **"tiene un"** entre clases, donde
una representa el **todo (contenedor)** y otra la **parte
(componente)**. La diferencia con la agregación es la
**fuerza** del vínculo: en composición la parte **no
puede existir sin el todo**.

Como la agregación, la composición no se limita a
relaciones físicas:

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Matiz semántico
   - Ejemplos
 * - "tiene un"
   - Un coche tiene un motor; un usuario tiene un
     perfil; en IACT, un ``Reporte`` tiene una
     ``ConfiguracionExport``.
 * - "contiene un"
   - Un libro contiene páginas; en IACT, una
     ``EjecucionETL`` contiene ``ErrorETL`` y
     ``RegistroIngesta``.
 * - "posee un"
   - Una casa posee habitaciones; en IACT, una
     ``Sesion`` posee tokens internos que caducan con
     ella (CNST_002).

Físicas vs lógicas
~~~~~~~~~~~~~~~~~~

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Tipo
   - Ejemplos IACT
 * - Físicas
   - ``Reporte`` y sus archivos temporales de export
     (CNST_019); ``Sesion`` y sus tokens en Redis.
 * - Lógicas
   - ``EventoAuditoria`` y sus ``DetalleAuditoria``
     (CNST_025); una ``EjecucionETL`` y los
     ``RegistroIngesta`` que produjo.

Tres características distintivas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
 :widths: 28 36 36
 :header-rows: 1

 * - Característica
   - Significado
   - Ejemplo IACT
 * - **Ciclo de vida compartido**
   - El componente existe **solo** mientras existe su
     contenedor. Destruir el contenedor destruye los
     componentes.
   - Si una ``EjecucionETL`` se invalida, sus
     ``ErrorETL`` asociados desaparecen como
     entidades vivas (sus huellas en
     ``audit_log`` permanecen, pero los objetos del
     dominio ya no).
 * - **Pertenencia exclusiva**
   - Un componente solo puede pertenecer a **un único**
     contenedor en un momento dado. No se comparte.
   - Un ``ErrorETL`` pertenece a **una** sola
     ``EjecucionETL``; no se reutiliza en otra.
 * - **Dependencia existencial**
   - Los componentes **no tienen sentido** fuera de su
     contenedor.
   - Los detalles de auditoría (``DetalleAuditoria``)
     no tienen sentido sin su ``EventoAuditoria``
     padre.

3.5 Características técnicas
----------------------------

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Característica
   - Valor
   - Implicación
 * - **Visibilidad**
   - Privada.
   - Los componentes son parte integral del contenedor
     y no deberían ser accesibles desde fuera salvo
     vía métodos del contenedor.
 * - **Temporalidad**
   - Alta.
   - La relación persiste durante toda la vida del
     contenedor.
 * - **Versatilidad**
   - Baja.
   - Los componentes son específicos al contenedor y
     no se intercambian entre contenedores.

3.6 Implementación en el diseño
-------------------------------

.. list-table::
 :widths: 28 36 36
 :header-rows: 1

 * - Aspecto
   - Descripción
   - Ejemplo IACT
 * - **Creación en constructor**
   - Los componentes se crean y se vinculan cuando se
     construye el contenedor; inicialización
     obligatoria.
   - ``Reporte`` instancia su
     ``ConfiguracionExport`` en el constructor; no
     se permite crearlo y luego asignársela.
 * - **Referencias con ciclo de vida compartido**
   - Las referencias privadas viven y mueren con el
     contenedor; sincronizadas; sin existencia
     separada.
   - ``EjecucionETL.errores`` es una lista privada
     cuyo ciclo está atado al de la ejecución.
 * - **Encapsulamiento**
   - Asegura la integridad de la relación; protección
     de componentes internos.
   - ``Sesion`` no expone sus tokens; los administra
     internamente.
 * - **Control de acceso**
   - Mecanismos para regular el acceso y modificación
     de los componentes; sin exposición externa.
   - ``EventoAuditoria`` no permite modificar sus
     ``DetalleAuditoria`` directamente — la
     inmutabilidad CNST_025 es una invariante.
 * - **Gestión de dependencias**
   - Manejo de la relación todo-parte; dependencia
     fuerte; sin compartición; **destrucción en
     cascada**.
   - Eliminar un ``Reporte`` (en sentido de dominio)
     elimina su ``ConfiguracionExport`` asociada.

3.7 Ejemplo canónico — Documento y Párrafos
-------------------------------------------

Modelo arquetípico que ilustra los cinco mecanismos de
composición simultáneamente.

Aspectos representados
~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
 :widths: 30 35 35
 :header-rows: 1

 * - Aspecto
   - Características
   - Materialización
 * - Creación en constructor
   - Creación conjunta; existencia dependiente.
   - El ``Documento`` crea sus ``Parrafo`` al
     construirse; los párrafos no pueden existir
     antes.
 * - Ciclo de vida compartido
   - Vidas sincronizadas; sin transferencia.
   - Los párrafos viven y mueren con el documento; no
     pueden transferirse a otro.
 * - Encapsulamiento
   - Protección y mantenimiento de integridad.
   - Los párrafos están protegidos dentro del
     documento; la integridad del contenido se
     mantiene a nivel de documento.
 * - Control de acceso
   - Modificación controlada; acceso regulado.
   - Solo el documento modifica directamente sus
     párrafos; el acceso externo pasa por métodos
     del documento.
 * - Gestión de dependencias
   - Relación fuerte; destrucción en cascada.
   - Eliminar el documento elimina todos los párrafos
     atómicamente.

Diagrama UML
~~~~~~~~~~~~

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class Documento {
     - parrafos : List<Parrafo>
     - titulo : String
     + modificarParrafo(pos, contenido)
     + agregarParrafo(contenido)
     + getContenidoParrafo(pos) : String
     + getNumeroParrafos() : int
   }

   class Parrafo {
     - contenido : String
     - posicion : int
     ~ getContenido() : String
     ~ modificarContenido(nuevo : String)
   }

   Documento *-- "1..*" Parrafo
   note right of Parrafo
     No existe independientemente.
     Pertenece a un unico Documento.
     Se destruye con el Documento.
   end note
   @enduml

Implementación Java de referencia
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: java

   // Clase parte (no puede existir independientemente)
   class Parrafo {
       private String contenido;
       private int posicion;

       // Constructor solo accesible dentro del paquete
       Parrafo(String contenido, int posicion) {
           this.contenido = contenido;
           this.posicion = posicion;
       }

       String getContenido() {
           return contenido;
       }

       void modificarContenido(String nuevoContenido) {
           this.contenido = nuevoContenido;
       }
   }

   // Clase todo (contenedor)
   class Documento {
       private List<Parrafo> parrafos;  // privado
       private String titulo;

       // Creación en constructor — párrafos se crean
       // junto con el documento
       public Documento(String titulo,
                        String... contenidosIniciales) {
           this.titulo = titulo;
           this.parrafos = new ArrayList<>();
           for (int i = 0;
                i < contenidosIniciales.length;
                i++) {
               this.parrafos.add(
                   new Parrafo(contenidosIniciales[i], i));
           }
       }

       public void modificarParrafo(int posicion,
                                    String nuevoContenido) {
           if (posicion >= 0
                   && posicion < parrafos.size()) {
               parrafos.get(posicion)
                   .modificarContenido(nuevoContenido);
           }
       }

       public void agregarParrafo(String contenido) {
           parrafos.add(
               new Parrafo(contenido, parrafos.size()));
       }

       public String getContenidoParrafo(int posicion) {
           if (posicion >= 0
                   && posicion < parrafos.size()) {
               return parrafos.get(posicion)
                   .getContenido();
           }
           return null;
       }

       public int getNumeroParrafos() {
           return parrafos.size();
       }

       // Sin métodos para extraer o transferir parrafos:
       // van en contra de la composición.
   }

Características clave
~~~~~~~~~~~~~~~~~~~~~

1. **Dependencia total** — los párrafos no pueden existir
   sin el documento; no hay creación independiente.
2. **Gestión interna** — el documento controla
   completamente sus párrafos; no hay acceso directo
   externo.
3. **Control de acceso** — referencias privadas a los
   párrafos; métodos controlados para modificación.
4. **Ciclo de vida** — creación simultánea; destrucción
   en cascada.

3.8 Mapeo a IACT
----------------

Composiciones canónicas en este proyecto:

.. list-table::
 :widths: 28 30 42
 :header-rows: 1

 * - Contenedor
   - Componente
   - Nota IACT
 * - ``EjecucionETL``
   - ``ErrorETL``
   - Errores son parte indivisible de la ejecución;
     viven y mueren con ella (CNST_006/008).
 * - ``EjecucionETL``
   - ``RegistroIngesta``
   - Registros de qué cargó la ejecución; sin sentido
     fuera de ella.
 * - ``Reporte``
   - ``ConfiguracionExport``
   - La configuración del export pertenece a la tarea
     puntual; no se reutiliza (ver patrones-diseno § 4
     Builder).
 * - ``EventoAuditoria``
   - ``DetalleAuditoria``
   - Detalles del evento son inmutables como el evento
     (CNST_025); composición fuerte.
 * - ``Sesion``
   - Tokens internos en Redis
   - Tokens caducan con la sesión (CNST_002);
     pertenencia exclusiva.
 * - ``AlertaCritica``
   - ``HistorialReconocimiento``
   - El historial de quién y cuándo reconoció la
     alerta es parte de la propia alerta.

Anti-patrones IACT
~~~~~~~~~~~~~~~~~~

- Modelar ``Funcion`` como composición de ``Grupo``
  (rombo relleno) — incorrecto: las funciones del
  catálogo RBAC sobreviven a la disolución de un grupo.
  Usar **agregación** (§ 2).
- Compartir un ``ErrorETL`` entre dos
  ``EjecucionETL`` — viola pertenencia exclusiva.
  Si el mismo error semántico aparece en dos
  ejecuciones, son **dos instancias** distintas.
- Permitir extraer un ``DetalleAuditoria`` de su
  ``EventoAuditoria`` y reasignarlo — viola CNST_025
  y rompe la composición.

3.9 Pregunta decisiva agregación vs composición
-----------------------------------------------

   *Si el todo desaparece, ¿la parte sigue teniendo
   sentido?*

- **Sí** → agregación (rombo vacío, § 2).
- **No** → composición (rombo relleno, § 3).

Aplicada a IACT: ``Funcion`` ◇ ``Grupo`` → agregación
(funciones siguen). ``ErrorETL`` ● ``EjecucionETL`` →
composición (errores no tienen sentido sin la ejecución).

----

4. Diagramas de contexto
========================

Un **diagrama de contexto** es un *zoom* sobre una parte del
sistema.

4.1 Contexto de composición — EjecucionETL
------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   package "EjecucionETL (composición)" {
     class Scheduler
     class FilaCargada
     class ErrorETL
     class EstadoEjecucion

     Scheduler --> EstadoEjecucion : dispara
     EstadoEjecucion --> FilaCargada : produce
     EstadoEjecucion --> ErrorETL    : registra
   }
   note right of EstadoEjecucion
     Diagrama de contexto:
     muestra cómo se relacionan
     los componentes DENTRO de
     una EjecucionETL.
   end note
   @enduml

4.2 Contexto de sistema — IACT completo
---------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   package "IACT (contexto del sistema)" {
     class Usuario
     class Sesion
     class Reporte
     class Metrica
     class Alerta
     class Suscripcion
     class EjecucionETL
     class EventoAuditoria
     class IVR
     class BuzonInterno

     Usuario --> Sesion         : abre
     Usuario --> Reporte        : consulta
     Reporte --> Metrica        : agrega
     Alerta  --> Suscripcion    : notifica
     Suscripcion --> Usuario    : pertenece
     EjecucionETL --> IVR       : lee (read-only)
     Alerta --> BuzonInterno    : notifica via (CNST_001)
     Usuario --> EventoAuditoria : genera
   }

   cloud "Stripe / SendGrid" as Externos
   note right of Externos
     NO aplica a IACT —
     sin pasarela de pago,
     sin email externo.
   end note
   @enduml

----

5. Interfaces y realizaciones
=============================

**Definición:** una **interfaz** es un conjunto de operaciones
públicas que una clase presenta a otras.

**Interfaz ≠ clase:**

- **Clase** — tiene atributos y operaciones (estructura
  completa).
- **Interfaz** — sólo tiene operaciones públicas (contrato de
  comportamiento).

**Realización:** cuando una clase implementa una interfaz.

**Símbolo:** línea discontinua con triángulo vacío (``..|>``).

5.1 ``IExportable`` — UC_RPT_04, UC_AUD_03, UC_LOG_04
-----------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   interface IExportable <<interface>> {
     + exportar(formato : Enum) : Archivo
     + estimarFilas() : Integer
     + obtenerSizeMB() : Decimal
   }

   class Reporte {
     - tipo : Enum
     - filtros : Filtro
     + exportar(formato : Enum) : Archivo
     + estimarFilas() : Integer
     + obtenerSizeMB() : Decimal
   }

   class EventoAuditoria {
     - rango : Rango
     + exportar(formato : Enum) : Archivo
     + estimarFilas() : Integer
     + obtenerSizeMB() : Decimal
   }

   class LogSistema {
     - rango : Rango
     - servicio : String
     + exportar(formato : Enum) : Archivo
     + estimarFilas() : Integer
     + obtenerSizeMB() : Decimal
   }

   Reporte ..|> IExportable
   EventoAuditoria ..|> IExportable
   LogSistema ..|> IExportable

   note right of IExportable
     Contrato común para tres tipos
     de export en IACT:
       UC_RPT_04 (Reporte)
       UC_AUD_03 (Auditoría)
       UC_LOG_04 (Logs)
     Throttling distinto por formato
     per CNST_019/020.
   end note
   @enduml

5.2 ``INotificable`` — UC_ALR_02 / UC_ALR_05
--------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   interface INotificable <<interface>> {
     + entregar(usuario : Usuario, mensaje : Mensaje) : Boolean
     + obtenerEstado() : EstadoEntrega
   }

   class BuzonInterno {
     + entregar(usuario, mensaje) : Boolean
     + obtenerEstado() : EstadoEntrega
   }

   class NotificacionPush {
     + entregar(usuario, mensaje) : Boolean
     + obtenerEstado() : EstadoEntrega
   }

   BuzonInterno ..|> INotificable
   NotificacionPush ..|> INotificable

   note right of INotificable
     CNST_001 prohíbe email →
     IACT NO implementa NotificacionEmail.
     Las únicas implementaciones válidas son
     buzón interno y notificación push interna.
   end note
   @enduml

5.3 ``ISegmentable`` — filtrado por segmento (BR_012)
-----------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   interface ISegmentable <<interface>> {
     + aplicarFiltroSegmento(s : SegmentoDatos)
     + perteneceA(s : SegmentoDatos) : Boolean
   }

   class Llamada
   class Reporte
   class Alerta
   class EventoAuditoria

   Llamada ..|> ISegmentable
   Reporte ..|> ISegmentable
   Alerta ..|> ISegmentable
   EventoAuditoria ..|> ISegmentable

   note right of ISegmentable
     Toda entidad consultada por
     un usuario operativo debe
     filtrarse por su segmento
     (BR_012). El contrato lo
     uniforma.
   end note
   @enduml

5.4 Beneficios de usar interfaces
---------------------------------

::

 SIN INTERFACES:
   - Código duplicado en múltiples clases
   - Difícil de mantener
   - Acoplamiento alto

 CON INTERFACES:
   - Un solo lugar para definir el contrato
   - Reutilización de código
   - Bajo acoplamiento
   - Fácil agregar nuevas implementaciones

----

6. Visibilidad — ``+ # -``
==========================

La **visibilidad** controla quién puede acceder a atributos y
operaciones.

.. list-table::
 :widths: 12 18 30 40
 :header-rows: 1

 * - Símbolo
   - Nivel
   - Acceso
   - Uso típico en IACT
 * - ``+``
   - Público
   - Cualquier clase
   - Interfaz expuesta a otros UCs
 * - ``#``
   - Protegido
   - Sólo subclases
   - Implementación heredada por subtipos
 * - ``-``
   - Privado
   - Sólo la clase
   - Detalles internos (segmentación, hash,
     SQL crudo)

6.1 Ejemplo — clase ``Reporte``
-------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class Reporte {
     - segmento_aplicado : SegmentoDatos
     - cache_ttl : Integer
     - sql_crudo : String
     # registrarConsulta()
     # invalidarCache()
     + generar(filtros : Filtro)
     + exportar(formato : Enum)
     + getResultados()
   }
   note right of Reporte
     Visibilidad:
       + generar / exportar / getResultados
         → interfaz pública del UC_RPT
       # registrarConsulta / invalidarCache
         → heredable por subtipos
         (ReporteHistorico, ReporteAgentes...)
       - segmento_aplicado / cache_ttl /
         sql_crudo → detalles internos
         (segmentación BR_012, SLA CNST_017)
   end note
   @enduml

6.2 Visibilidad en interfaces
-----------------------------

  En las **interfaces** todas las operaciones son
  **públicas (+)** — el propósito es que otras clases las
  implementen y usen.

----

7. Ámbito — instancia vs archivador
===================================

El **ámbito** determina si un atributo o operación es:

- **Instancia** — cada objeto tiene su propio valor (común).
- **Archivador** (estático) — todos los objetos comparten un
  valor (raro). Notación: subrayado.

7.1 Configuración de SLAs del sistema (CNST_017)
------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class ConfiguracionSLA {
     {static} - sla_max_seg : Integer = 10
     {static} - retencion_max_anios : Integer = 2
     {static} - export_csv_max : Integer = 100000
     {static} - export_excel_max : Integer = 50000
     {static} - export_pdf_max : Integer = 10000
     {static} - throttling_intentos_login : Integer = 5
     {static} - throttling_ventana_min : Integer = 5
     {static} + getSlaMaxSeg() : Integer
     {static} + getExportLimit(formato : Enum) : Integer
   }
   note right of ConfiguracionSLA
     Todos los atributos son
     **archivador** (subrayados):
     una sola configuración
     compartida por todo el
     sistema. Refleja:
       CNST_017 (SLA)
       CNST_015 (retención 2 años)
       CNST_019/020 (export)
       CNST_011 (throttling)
   end note
   @enduml

7.2 Catálogo de funciones — instancia compartida
------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class Funcion {
     - codigo : String
     - descripcion : String
     - modulo : String
     {static} - TOTAL : Integer = 42
     {static} + listarTodas() : List<Funcion>
     {static} + buscarPorCodigo(c : String) : Funcion
   }
   note right of Funcion
     - codigo / descripcion / modulo
       → instancia (cada Funcion es única)
     - TOTAL = 42 (CNST_029)
       → archivador (compartido por todas
         las instancias)
     - listarTodas / buscarPorCodigo
       → archivador (operaciones de catálogo)
   end note
   @enduml

----

8. Modelo completo IACT — integración
=====================================

8.1 Paso 1 — agregación + composición
-------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   class Grupo
   class Funcion
   class EjecucionETL
   class ErrorETL

   Grupo "*" o-- "*" Funcion           : agregación
   EjecucionETL "1" *-- "0..*" ErrorETL : composición

   note right of Funcion
     Agregación: Funcion sobrevive
     al borrado de Grupo.
   end note
   note right of ErrorETL
     Composición: ErrorETL muere
     con la EjecucionETL.
   end note
   @enduml

8.2 Paso 2 — interfaces + visibilidad
-------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   interface IExportable <<interface>> {
     + exportar(formato)
   }
   class Reporte {
     - sql_crudo : String
     # registrarConsulta()
     + exportar(formato)
   }
   class LogSistema {
     - servicio : String
     + exportar(formato)
   }
   Reporte ..|> IExportable
   LogSistema ..|> IExportable
   @enduml

8.3 Paso 3 — diagrama de contexto integrado
-------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   skinparam packageStyle rectangle

   package "IACT — sistema completo" {
     package "Catálogo RBAC" {
       class Funcion
       class Grupo
       Grupo "*" o-- "*" Funcion
     }

     package "Pipeline ETL" {
       class EjecucionETL
       class ErrorETL
       EjecucionETL "1" *-- "0..*" ErrorETL
     }

     package "Reportes" {
       interface IExportable <<interface>>
       class Reporte
       class FilaResultado
       Reporte ..|> IExportable
       Reporte "1" *-- "0..*" FilaResultado
     }

     package "Auditoría" {
       class EventoAuditoria
       class DetalleAuditoria
       EventoAuditoria ..|> IExportable
       EventoAuditoria "1" *-- "0..*" DetalleAuditoria
     }

     package "Alertas" {
       interface INotificable <<interface>>
       class Alerta
       class BuzonInterno
       Alerta -- BuzonInterno : usa
       BuzonInterno ..|> INotificable
     }
   }

   note bottom
     ◇ agregación (Grupo–Funcion)
     ● composición (Reporte–FilaResultado,
       EjecucionETL–ErrorETL,
       EventoAuditoria–DetalleAuditoria)
     ..|> realización (IExportable,
                      INotificable)
   end note
   @enduml

----

9. Resumen — los 5 conceptos
============================

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   skinparam packageStyle rectangle
   rectangle "Modelo UML completo (IACT)" as M {
     rectangle "1. AGREGACIÓN ◇\nGrupo ↔ Funcion\nCentro ↔ Operador"               as A
     rectangle "2. COMPOSICIÓN ●\nEjecucionETL ↔ ErrorETL\nReporte ↔ Fila"          as C
     rectangle "3. INTERFACES\nIExportable, INotificable,\nISegmentable"            as I
     rectangle "4. VISIBILIDAD\n+ público / # protegido / − privado"                as V
     rectangle "5. ÁMBITO\nInstancia vs archivador\n(ConfiguracionSLA = static)"    as S
   }
   @enduml

----

10. Aplicación a UCs específicos del catálogo IACT
==================================================

**UC_RPT_04 (Exportar reporte):**

::

 Interfaz       : Reporte ..|> IExportable
 Composición    : Reporte ●─ FilaResultado
 Visibilidad    : -sql_crudo (privado), +exportar (público)
 Ámbito         : ConfiguracionSLA (archivador) define
                  límites CNST_019/020 por formato

**UC_PIP_02 (Consultar errores ETL):**

::

 Composición    : EjecucionETL ●─ ErrorETL
                  (errores no existen sin ejecución)
 Visibilidad    : +obtenerErrores (público),
                  -conexion_ivr (privada)

**UC_PERM_06 (Asignar funciones a grupo):**

::

 Agregación     : Grupo ◇─ Funcion
                  (función sobrevive al grupo)
 Composición    : —
 Restricción    : SoD validada en runtime per CNST_030

**UC_ALR_05 (Gestionar suscripciones):**

::

 Interfaz       : BuzonInterno ..|> INotificable
 Restricción    : sin email per CNST_001 (no hay
                  NotificacionEmail implementando la interfaz)

**UC_AUD_03 (Exportar auditoría):**

::

 Interfaz       : EventoAuditoria ..|> IExportable
 Composición    : EventoAuditoria ●─ DetalleAuditoria
 Restricción    : append-only per CNST_025
                  (no hay método borrar() en la interfaz)

----

11. Cluster de clases — agrupación por problemática
===================================================

Un **cluster de clases** es un conjunto de clases muy
interrelacionadas que **resuelven una problemática
específica**. Se distingue de los mecanismos formales
(agregación, composición, paquete UML) por su criterio:
no es estructural ni de propiedad, es **funcional** —
"estas clases están aquí porque juntas resuelven X".

Cómo identificar un cluster en IACT
-----------------------------------

Un cluster suele aparecer cuando varias clases:

- Comparten vocabulario del dominio (ej. todas hablan de
  "alerta", "umbral", "reconocimiento").
- Co-evolucionan: un cambio en una típicamente requiere
  cambios coordinados en las demás.
- Atraviesan los mismos contratos hacia fuera (la misma
  interfaz exportada en :doc:`diagramas-componentes`).

Clusters canónicos del dominio IACT
-----------------------------------

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Cluster
   - Problemática que resuelve
   - Clases típicas
 * - **Auth + sesión**
   - Identificación, sesión única (CNST_002), throttling
     (CNST_011).
   - ``Usuario``, ``Sesion``, ``IntentoLogin``,
     ``ContadorThrottling``.
 * - **RBAC + SoD**
   - Catálogo de funciones, asignación de grupos, SoD
     (CNST_030).
   - ``Funcion``, ``Grupo``, ``Permiso``, ``ReglaSoD``.
 * - **Reportería**
   - Generación, agregación, exportación async
     (CNST_019/020), rango ≤ 6 meses (CNST_031).
   - ``Reporte``, ``ReporteVolumen``, ``ReporteAbandono``,
     ``ConfiguracionExport``, ``TareaExport``.
 * - **Alertas**
   - Evaluación de umbrales (BR_016/017/018),
     reconocimiento, sincronización con auditoría.
   - ``Alerta``, ``UmbralAlerta``, ``EvaluadorAlertas``,
     ``EstadoAlerta``.
 * - **ETL**
   - Carga read-only desde BD operativa e IVR
     (CNST_006/007/008).
   - ``EjecucionETL``, ``VentanaETL``, ``ErrorETL``,
     ``RegistroIngesta``.
 * - **Auditoría**
   - Registro inmutable (CNST_025), consulta read-only.
   - ``EventoAuditoria``, ``DetalleAuditoria``,
     ``ConsultaAudit``.

Relación con apps Django
------------------------

Cada cluster del dominio se materializa como una **app
Django** del proyecto (ver :doc:`diagramas-componentes`):
``auth_app``, ``perm_app``, ``rpt_app``, ``alr_app``,
``pip_app``, ``aud_app``. Esta correspondencia no es
casual: la frontera de un cluster bien identificado es
una buena candidata a frontera de app, porque minimiza el
acoplamiento cruzado (ver § 11 de :doc:`orientacion-objetos`).

Cuándo refactorizar por clusters
--------------------------------

Si dos clases están en apps distintas pero co-evolucionan
constantemente, probablemente están en el cluster
equivocado. Si una clase pertenece a una app pero apenas
interactúa con sus vecinas, probablemente debería
moverse al cluster donde realmente tributa. La decisión
debe quedar registrada en un ADR del subdominio afectado.

----

12. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-requirements-analysis`` (BABOK — RADD)
 * - **Origen del documento**
   - Reescrito de "GUÍA-AGREGACION-COMPOSICION-INTERFACES-
     REALIZACION" (cheat-sheet aplicado interno con dominio
     ecommerce), **reorientado al dominio real IACT**.
 * - **Teoría genérica**
   - :doc:`/base-cognitiva/_uml/uml-05-agregacion-composicion-interfaces`
     (Schmuller Hora 5)
 * - **Cheat-sheet de los 9 diagramas**
   - :doc:`/base-cognitiva/_uml/cuando-usar-cada-diagrama`
 * - **Modelo RBAC vigente**
   - :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
 * - **Catálogo modular del dominio IACT**
   - :doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`
 * - **Ejemplos hermanos aplicados a IACT**
   - :doc:`diagramas-uml`,
     :doc:`orientacion-objetos`,
     :doc:`analisis-dominio`,
     :doc:`relaciones-uml`
 * - **Plan de documentación**
   - :doc:`plan-documentacion-uc`
 * - **Plantilla canónica de UC**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Restricciones citadas**
   - CNST_001 (no email),
     CNST_002 (sesión única),
     CNST_011 (throttling 5/5min),
     CNST_015 (retención 2 años),
     CNST_017 (SLA tiempos),
     CNST_019/020 (export async + throttling),
     CNST_025 (auditoría inmutable),
     CNST_029 (catálogo de 42 funciones),
     CNST_030 (SoD),
     BR_012 (segmento único).
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
