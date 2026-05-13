.. meta::
 :artefacto: EJEMPLOS_OOP_APLICADOS_IACT
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
Principios OOP aplicados al dominio IACT (PlantUML)
==================================================================

.. note::

 Compañero del :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc`
 y de :doc:`/normativa/estandares/metodologia-oop-para-ucs`.

 Muestra los **6 principios OOP** aplicados al **dominio real
 del proyecto IACT**: call center IVR + analytics +
 supervisión ETL + RBAC granular. **No** es ecommerce.

 Sirve como **referencia de precedente**: cada UC documentado
 debe aplicar las 6 dimensiones OOP con el nivel de detalle
 mostrado en estos ejemplos, usando la nomenclatura real del
 catálogo (``UC_ACC``, ``UC_AUTH``, ``UC_USR``, ``UC_PERM``,
 ``UC_RPT``, ``UC_ALR``, ``UC_PIP``, ``UC_AUD``, ``UC_LOG``).

 Diagramas en **PlantUML** (política del proyecto, no Mermaid).

----

Preludio — ¿qué es OO y cómo se mide?
=====================================

Antes de los seis principios y de SOLID, conviene
plantear las preguntas que abren el debate:

   *¿Es OO usar objetos? ¿Es usar C++, Java, C#,
   Smalltalk? ¿Es usar UML? ¿Qué hace que un programa sea
   OO? ¿Cómo se mide un buen diseño?*

La respuesta corta: **OO no se reduce a la sintaxis del
lenguaje ni a las herramientas**. Un programa puede usar
clases sin ser OO en sentido fuerte; un diseño puede
materializarse en UML y no ser OO. OO es un paradigma
sobre **encapsulamiento**, **abstracción**, **herencia**
y **polimorfismo** combinados con disciplina de cohesión
y acoplamiento — el resto de este documento desarrolla
cada pieza en el contexto IACT.

Conceptos clave del paradigma
-----------------------------

- **Objetos** — instancias de clases que contienen datos
  (propiedades) y comportamiento (métodos). Unidad básica
  del paradigma.
- **Clases** — planos o moldes que definen estructura y
  comportamiento de los objetos.
- **Herencia** — mecanismo para reutilizar y especializar
  comportamiento; jerarquías de tipo "es-un".
- **Polimorfismo** — capacidad de tratar objetos de
  distintas clases de forma uniforme; despacho dinámico
  por tipo, sobrescritura y sobrecarga.

Cómo se mide la calidad de un diseño OO
---------------------------------------

Cuatro factores se combinan para evaluar un diseño:

1. **Cohesión** — qué tan fuertemente relacionados están
   los datos y los métodos dentro de una clase.
2. **Acoplamiento** — qué tan independientes son las
   clases entre sí.
3. **Principios SOLID** — guías para código modular,
   flexible y mantenible (ver §§ 16-20).
4. **Patrones de diseño** — soluciones probadas a
   problemas comunes (ver :doc:`patrones-diseno`).

El diseño de clases y objetos es un **proceso incremental
e iterativo**: es muy difícil hacerlo bien desde la
primera vez (ver § 14 Ciclo de prototipos y
§ 15 Ciclo iterativo).

Métricas para el diseño de clases
---------------------------------

**Acoplamiento**

- Herencia es una forma de acoplamiento. Acoplamiento
  fuerte complica el sistema.
- **Diseñar para el acoplamiento más débil posible** —
  una de las decisiones recurrentes del documento.

**Cohesión** — taxonomía clásica (de mejor a peor):

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Tipo de cohesión
   - Significado
   - Calidad
 * - **Funcional**
   - Todos los elementos trabajan juntos para
     proporcionar **un comportamiento bien definido**.
   - **Mejor** — meta del diseño OO.
 * - **Secuencial**
   - La salida de una operación es la entrada de la
     siguiente (cadena de procesamiento).
   - Buena.
 * - **Comunicacional**
   - Los elementos operan sobre los **mismos datos**.
   - Aceptable.
 * - **Procedimental**
   - Los elementos siguen un orden de ejecución
     compartido.
   - Mediocre.
 * - **Temporal**
   - Los elementos se ejecutan en el mismo momento
     (e.g., inicialización).
   - Pobre.
 * - **Lógica**
   - Los elementos pertenecen a la misma "categoría"
     pero hacen cosas distintas.
   - Mala.
 * - **Casual**
   - Todos los elementos están relacionados de manera
     **indeseable** — ningún criterio real los une.
   - **Peor.**

La meta es **cohesión funcional**. La señal de
cohesión casual es una clase llamada ``Utils``,
``Helper`` o ``Manager`` con métodos sin relación
conceptual — refactorizar en clases con propósito claro
del dominio.

Aplicación a IACT
~~~~~~~~~~~~~~~~~

- ``Reporte`` con ``generar``, ``exportar``,
  ``aplicar_filtros_segmento`` (BR_012) → cohesión
  **funcional**: todo concurre a producir un reporte
  válido.
- Una hipotética ``UtilsCallCenter`` con
  ``formatear_telefono``, ``parsear_csv``,
  ``calcular_tasa`` y ``enviar_email`` → cohesión
  **casual**: nada las une excepto que "son utilidades".
  Refactorizar en clases con responsabilidad real.

Conexión con el resto del documento
-----------------------------------

Los seis principios OOP de las §§ 1-10 son la base
conceptual; las §§ 11-15 introducen la disciplina de
acoplamiento, antipatrones y ciclos de vida; las
§§ 16-21 completan el cuadro con SOLID y temas
avanzados. La aplicación correcta de todo el conjunto en
IACT exige los criterios introducidos aquí: maximizar
cohesión funcional y minimizar acoplamiento.

----

1. Dominio IACT — vocabulario base
==================================

Antes de aplicar los 6 principios, recordá los conceptos del
dominio (per
:doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`):

.. list-table::
 :widths: 22 78
 :header-rows: 1

 * - Concepto
   - Significado en IACT
 * - **Llamada / IVR**
   - Interacción telefónica capturada por el conmutador IVR;
     fuente operacional de los datos.
 * - **Métrica operativa**
   - Indicador derivado de las llamadas (tasa de abandono,
     tiempo promedio de espera, índice de eficiencia).
 * - **Función**
   - Capacidad atómica del RBAC (``view_dashboard``,
     ``manage_sessions``, ``export_csv``, etc.). 42 en total.
 * - **Grupo de funciones**
   - Conjunto agrupado de funciones (predefinido AGR-001..010
     o creable por admin).
 * - **Permiso temporal / excepcional**
   - Asignación con justificación + vencimiento ≤ 6 meses.
 * - **Segmento de datos**
   - Subconjunto de IVR autorizado a un usuario (centro,
     campaña, servicio, región).
 * - **Pipeline ETL**
   - Proceso batch que carga IVR → BD analítica (ventana 6-12 h,
     no real-time).
 * - **Auditoría**
   - Registro inmutable append-only de acciones (UC_AUD) y de
     verificaciones de permiso (``AuditoriaPermiso``,
     UC_PERM_09).

----

2. Abstracción
==============

**Definición:** quitar propiedades y acciones innecesarias,
dejar sólo lo esencial al problema que se resuelve.

2.1 Antipatrón — exceso de detalle físico
-----------------------------------------

Si quisieras modelar EXACTAMENTE cada llamada IVR con todo su
detalle eléctrico:

::

 Llamada (modelo perfectamente físico):
   - Códec usado en cada tramo
   - Latencia milisegundo a milisegundo
   - Pérdida de paquetes en cada hop
   - Voltaje de la línea
   - Modulación del DTMF
   - Frecuencia de muestreo del audio
   - Buffer del jitter
   - ... 50 atributos más

**Problema:** excesivo para un sistema de **analytics**. Estos
datos pertenecen al operador IVR, no al consumidor de
métricas.

2.2 Abstracción correcta para IACT
----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Llamada {
     - id : Integer
     - centro_id : Integer
     - campana_id : Integer
     - servicio_id : Integer
     - tipo : Enum
     - duracion_seg : Integer
     - tiempo_espera_seg : Integer
     - resultado : Enum
     - fecha : DateTime
     + getDuracion() : Integer
     + getTipo() : Enum
     + esAbandonada() : Boolean
   }
   note right of Llamada
     Abstracción para analytics:
     sólo atributos relevantes para
     calcular métricas (BR_016 tasa
     de abandono, BR_017 tiempo
     promedio de espera, BR_018
     índice de eficiencia).
   end note
   @enduml

2.3 Decisiones de abstracción en IACT (97 UCs)
----------------------------------------------

**Pregunta para cada clase del dominio:**

- ¿Es relevante para calcular métricas operativas? → incluir.
- ¿Es relevante para verificar permisos en runtime? → incluir.
- ¿Es relevante para auditar acciones? → incluir.
- ¿Es detalle de la red telefónica / del IVR físico? →
  **excluir**.

**Modelos abstraídos:**

- ``Usuario`` (UC_USR / UC_AUTH) — sólo email, hash de
  contraseña, segmento, sesiones activas. **No** cifrado de
  línea.
- ``Llamada`` (consumida por UC_RPT / UC_ALR) — sólo
  duración, tipo, resultado, segmento. **No** códecs ni
  voltajes.
- ``Funcion`` (UC_PERM / UC_ACC) — sólo código, descripción,
  módulo. **No** representación SQL interna.
- ``EjecucionETL`` (UC_PIP) — sólo fecha de inicio, duración,
  filas cargadas, errores. **No** logs de cada query
  individual.

----

3. Herencia
===========

**Definición:** una subclase reutiliza atributos y operaciones
de su superclase. *"Es un tipo de"*.

3.1 Jerarquía de actores IACT
-----------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Usuario {
     - id : Integer
     - email : String
     - password_hash : String
     - is_active : Boolean
     - segmento : SegmentoDatos
     - created_at : DateTime
     + login(email, password) : Boolean
     + logout() : void
     + changePassword(old, new) : void
   }

   class Operador {
     + verDashboard() : Dashboard
     + verAlertasActivas() : List<Alerta>
   }

   class Supervisor {
     - centros : List<Integer>
     + verReportesHistoricos() : List<Reporte>
     + reconocerAlerta(id) : void
   }

   class AdminAcceso {
     + asignarFunciones(usuario, funciones) : void
     + asignarAgrupador(usuario, AGR_id) : void
     + concederPermisoTemporal(...) : void
   }

   class AdminPipeline {
     + supervisarETL() : EstadoETL
     + solicitarReintento(ejecucion_id) : void
   }

   class Auditor {
     + consultarAuditoria(filtros) : List<EventoAud>
     + generarReporteCompliance() : Reporte
   }

   Usuario <|-- Operador
   Usuario <|-- Supervisor
   Usuario <|-- AdminAcceso
   Usuario <|-- AdminPipeline
   Usuario <|-- Auditor

   note right of Usuario
     Herencia: cada rol "es un tipo
     de" Usuario. Todos heredan
     login(), logout(),
     changePassword(). El segmento
     restringe los datos visibles
     (BR_012).
   end note
   @enduml

3.2 Ventaja en IACT
-------------------

::

 Sin herencia (repetición):
   Operador:        email, password, segmento, login(), logout()
   Supervisor:      email, password, segmento, login(), logout()
   AdminAcceso:     email, password, segmento, login(), logout()
   ...

 Con herencia (reutilización):
   Usuario:        email, password, segmento, login(), logout()
     Operador     (+ verDashboard, verAlertas)
     Supervisor   (+ reportes históricos, reconocer)
     AdminAcceso  (+ asignar/revocar funciones)
     AdminPipeline(+ supervisar ETL, reintento)
     Auditor      (+ consultar / exportar auditoría)

3.3 Otras jerarquías canónicas IACT
-----------------------------------

- ``Reporte`` (base) → ``ReporteRealTime`` (UC_RPT_02),
  ``ReporteHistorico`` (UC_RPT_03), ``ReporteAgentes``
  (UC_RPT_12), ``ReporteColas`` (UC_RPT_13),
  ``ReporteCampanias`` (UC_RPT_14).
- ``Alerta`` (base) → ``AlertaUmbral``, ``AlertaTendencia``,
  ``AlertaConsolidada`` con severidades ``INFO`` /
  ``WARNING`` / ``CRITICAL``.
- ``EventoAuditoria`` (base) → ``AuditoriaAcceso`` (UC_AUD),
  ``AuditoriaPermiso`` (UC_PERM_09),
  ``AuditoriaCambioAcceso`` (UC_ACC_09) — distinguidos por
  origen pero con misma política inmutable per CNST_025.
- ``EjecucionETL`` (base) → ``EjecucionExitosa``,
  ``EjecucionConErrores``, ``EjecucionReintentada``.

----

4. Polimorfismo
===============

**Definición:** mismo nombre de operación, diferente
implementación según la clase.

4.1 ``calcularValor()`` polimórfico en métricas IACT
----------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   abstract class Metrica {
     - nombre : String
     - segmento : SegmentoDatos
     + calcularValor(periodo : Rango) : Decimal
   }

   class TasaAbandono {
     + calcularValor(periodo : Rango) : Decimal
   }

   class TiempoPromedioEspera {
     + calcularValor(periodo : Rango) : Decimal
   }

   class IndiceEficiencia {
     - peso_atendidas : Decimal
     - peso_tiempo : Decimal
     + calcularValor(periodo : Rango) : Decimal
   }

   Metrica <|-- TasaAbandono
   Metrica <|-- TiempoPromedioEspera
   Metrica <|-- IndiceEficiencia

   note right of Metrica
     Polimorfismo (BR_016, BR_017, BR_018):
       TasaAbandono           → abandonadas / total × 100
       TiempoPromedioEspera   → SUM(esperas) / N
       IndiceEficiencia       → fórmula compuesta
                                ponderada por servicio
   end note
   @enduml

4.2 ``exportar()`` polimórfico per CNST_019/020
-----------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   abstract class Exportador {
     - reporte : Reporte
     + exportar() : Archivo
   }

   class ExportadorCSV {
     + exportar() : Archivo
   }
   class ExportadorExcel {
     + exportar() : Archivo
   }
   class ExportadorPDF {
     + exportar() : Archivo
   }

   Exportador <|-- ExportadorCSV
   Exportador <|-- ExportadorExcel
   Exportador <|-- ExportadorPDF

   note right of Exportador
     CNST_019 — exportaciones
     asíncronas para sets > 10k filas.
     CNST_020 — throttling distinto
     por formato:
       CSV   100k/10 día
       Excel  50k/5 día
       PDF    10k/3 día
   end note
   @enduml

4.3 Operaciones polimórficas en IACT (97 UCs)
---------------------------------------------

- ``calcularValor()`` — distinto por tipo de métrica
  (UC_RPT_01, UC_RPT_02, UC_RPT_03).
- ``exportar()`` — distinto por formato CSV/Excel/PDF
  (UC_RPT_04..06, CNST_019/020).
- ``verificar_permiso()`` — distinto si la fuente es
  asignación de grupo, asignación directa o permiso
  excepcional (UC_PERM_07).
- ``notificar()`` — distinto para alerta de umbral, alerta de
  tendencia, alerta de pipeline (UC_ALR_02, UC_PIP_02). Sin
  email, **sólo buzón interno** per CNST_001.

----

5. Encapsulamiento
==================

**Definición:** ocultar la complejidad interna y mostrar sólo
la interfaz pública.

5.1 Clase ``Reporte`` (UC_RPT)
------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Reporte {
     == interfaz pública ==
     + generar(filtros : FiltroReporte) : Reporte
     + exportar(formato : Enum) : Archivo
     + getResultados() : List<Fila>
     + getMetadatos() : Metadatos
     == privado / oculto ==
     - validarSegmentoUsuario()
     - construirQuerySQL()
     - aplicarFiltrosPorSegmento()
     - cachearResultado()
     - registrarConsulta()
     - aplicarThrottling(formato)
   }
   note right of Reporte
     El cliente sólo ve:
       generar(), exportar(),
       getResultados(),
       getMetadatos()
     El sistema gestiona internamente:
       segmentación (CNST_008), SQL,
       cache, auditoría, throttling
       (CNST_020).
   end note
   @enduml

5.2 Ventaja del encapsulamiento en IACT
---------------------------------------

::

 Reporte v1.0:
   resultados = ejecutar SQL crudo

 Reporte v2.0 (cambio interno tras CNST_017 — SLAs):
   resultados = ejecutar SQL → cache → throttling
                → segmentación CNST_008

 Resultado: el código de UC_RPT_01..14 NO CAMBIA,
 porque getResultados() siempre devuelve la lista
 correcta independientemente del mecanismo interno.

5.3 Interfaz pública vs privada — dominio IACT
----------------------------------------------

**Lo que ve el operador (interfaz pública):**

::

 Operador (UC_RPT):
   reporte.generar(filtros)
   reporte.exportar("csv")
   reporte.getResultados()

 Admin acceso (UC_ACC):
   asignarFunciones(usuario, funciones)
   asignarAgrupador(usuario, AGR-007)

 Auditor (UC_AUD):
   consultarAuditoria(filtros)
   exportarAuditoria(formato)

**Lo que NO ve (complejidad privada del backend):**

- Validación del segmento del usuario contra el dato
  consultado (CNST_008, BR_012).
- Construcción y caching de queries SQL.
- Throttling por formato (CNST_019/020).
- Verificación SoD en cada asignación (CNST_030).
- Persistencia inmutable de auditoría (CNST_025) — no se
  puede borrar.
- Hasheo de PII en logs (CNST_026).

----

6. Envío de mensajes
====================

**Definición:** un objeto solicita a otro que ejecute una
operación.

6.1 Generar reporte — UC_RPT_01 (ver dashboard)
-----------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant ":Operador"   as O
   participant ":Dashboard"  as D
   participant ":Reporte"    as R
   participant ":SecRules"   as SR
   participant ":BDAnalytics" as BD

   O  -> D  : 1. abrirDashboard()
   D  -> R  : 2. generar(filtros)
   R  -> SR : 3. verificarPermiso(view_dashboard)
   SR --> R : 4. autorizado + segmento del usuario
   R  -> BD : 5. SELECT con filtro de segmento
   BD --> R : 6. filas
   R  --> D : 7. resultados
   D  --> O : 8. dashboard renderizado
   @enduml

6.2 Solicitar reintento ETL — UC_PIP_04
---------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   participant ":AdminPipeline" as AP
   participant ":SupervisorETL" as Sup
   participant ":SchedulerETL" as Sch
   participant ":AuditLog"     as AL

   AP  -> Sup  : 1. solicitarReintento(ejecucion_id)
   Sup -> Sup  : 2. validarEstado(FALLIDA)
   Sup -> Sch  : 3. enqueueReintento(jobId)
   Sch --> Sup : 4. jobEncolado
   Sup -> AL   : 5. registrar(REINTENTO_SOLICITADO)
   Sup --> AP  : 6. confirmación + ETA
   @enduml

6.3 Múltiples interfaces, mismo mensaje
---------------------------------------

Un objeto puede recibir el mismo mensaje por **diferentes
interfaces**:

::

 Reporte:
   Interfaz Web    — operador clic "Generar"      → generar()
   Interfaz API    — sistema externo POST /reports → generar()
   Interfaz Cron   — scheduler dispara reporte
                     programado (UC_RPT_07)        → generar()

 Resultado: 3 interfaces, 1 operación generar().

6.4 Flujos de mensajes en los 97 UCs
------------------------------------

- UC_AUTH_01 (Iniciar sesión) → ``AuthService.login()`` →
  ``SessionStore.create()`` con throttling CNST_011.
- UC_RPT_01 (Ver dashboard) → ``Dashboard.refresh()`` →
  ``Reporte.generar()`` con filtro de segmento BR_012.
- UC_PIP_01 (Supervisar ETL) → ``SupervisorETL.estado()`` →
  ``SchedulerETL.last_run()``.
- UC_PERM_07 (Verificar permiso) → función SQL nativa
  ``usuario_tiene_permiso()``.
- UC_ALR_03 (Reconocer alerta) → ``Alerta.reconocer()`` →
  ``BuzonInterno.notificar()`` (CNST_001 sin email).

----

7. Asociaciones y agregación
============================

7.1 Asociaciones canónicas IACT
-------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Usuario
   class Sesion
   class Grupo
   class Funcion
   class SegmentoDatos
   class Reporte
   class Alerta

   Usuario "1" -- "0..1" Sesion          : posee
   Usuario "1" -- "1"   SegmentoDatos    : restringido_por
   Usuario "*" -- "*"   Grupo            : asignado_a
   Grupo   "*" -- "*"   Funcion          : contiene
   Usuario "1" -- "0..*" Reporte         : consulta
   Usuario "1" -- "0..*" Alerta          : suscrito_a

   note right of Usuario
     - Usuario posee 0..1 Sesion          (CNST_002)
     - Usuario tiene 1 segmento           (BR_012)
     - Usuario en 0..* grupos             (UC_PERM_01)
     - Grupo contiene 0..* funciones      (UC_PERM_06)
     - Usuario consulta 0..* reportes     (UC_RPT)
     - Usuario suscrito a 0..* alertas    (UC_ALR_05)
   end note
   @enduml

7.2 Agregación vs composición en IACT
-------------------------------------

**Agregación** — las partes pueden existir sin el todo:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class Grupo
   class Funcion
   Grupo "*" o-- "*" Funcion : contiene
   note right of Funcion
     Una función (capacidad atómica)
     puede ser parte de varios grupos
     (predefinidos AGR-001..010 o
     creados via UC_PERM_05). Si un
     grupo se elimina, las funciones
     siguen existiendo en el catálogo.
   end note
   @enduml

**Composición** — las partes no pueden existir sin el todo:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   class EjecucionETL
   class ErrorETL
   class FilaCargada
   EjecucionETL "1" *-- "0..*" ErrorETL    : compone
   EjecucionETL "1" *-- "0..*" FilaCargada : compone
   note right of EjecucionETL
     Si la EjecucionETL se purga
     (UC_PIP), sus errores y filas
     cargadas no tienen sentido
     fuera de ella.
   end note
   @enduml

7.3 Aplicación en el proyecto IACT
----------------------------------

**Agregación** (parte puede existir sin el todo):

- ``Grupo`` ↔ ``Funcion`` — la función vive en el catálogo
  aunque el grupo se borre.
- ``Suscripcion`` ↔ ``Alerta`` — la alerta sigue activa
  aunque un suscriptor se desuscriba (UC_ALR_05).

**Composición** (parte no existe sin el todo):

- ``EjecucionETL`` → ``ErrorETL`` (UC_PIP_02): errores ligados
  a una ejecución concreta.
- ``Reporte`` → ``FilaResultado`` — una fila no tiene sentido
  fuera del reporte que la generó.
- ``EventoAuditoria`` → ``DetalleAuditoria`` — el detalle
  inmutable se ata al evento (CNST_025).

----

8. Resumen visual de los 6 principios
=====================================

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   skinparam packageStyle rectangle
   rectangle "Orientación a Objetos en IACT" as OOP {
     rectangle "1. ABSTRACCIÓN\nLlamada / Métrica / Función\nsin ruido físico"             as P1
     rectangle "2. HERENCIA\nUsuario → Operador,\nSupervisor, Auditor..."                  as P2
     rectangle "3. POLIMORFISMO\ncalcularValor() por métrica\nexportar() por formato"      as P3
     rectangle "4. ENCAPSULAMIENTO\ngenerar() público,\nsegmentación interna"              as P4
     rectangle "5. MENSAJES\nOperador → Dashboard\n→ Reporte → SecRules → BD"              as P5
     rectangle "6. ASOCIACIONES\nUsuario 1:1 Sesion;\nGrupo *:* Funcion (agregación);\nEjecucionETL 1:* ErrorETL (composición)" as P6
   }
   @enduml

----

9. Cómo se aplica todo en conjunto — UC ejemplo
===============================================

UC_RPT_01 (Ver Dashboard) en términos OOP:

::

 1. ABSTRACCIÓN
    Reporte modela sólo lo necesario para mostrar métricas
    al operador (no detalles de ETL ni del IVR físico).

 2. HERENCIA
    Reporte (base) → ReporteRealTime, ReporteHistorico,
    ReporteAgentes, ReporteColas, ReporteCampanias.

 3. POLIMORFISMO
    calcularValor() distinto por métrica (BR_016 / BR_017 /
    BR_018). exportar() distinto por formato (CSV / Excel /
    PDF, CNST_019/020).

 4. ENCAPSULAMIENTO
    Operador ve: generar(), exportar(), getResultados().
    Backend gestiona: validación de segmento (CNST_008),
    construcción de SQL, caching, throttling, auditoría.

 5. MENSAJES
    Operador → Dashboard → Reporte → SecRules → BDAnalytics.

 6. ASOCIACIONES
    Usuario 1:1 SegmentoDatos (BR_012);
    Reporte 0..* FilaResultado (composición);
    Usuario 0..* Reporte (consulta).

----

10. Decisiones por aplicar a cada UC del catálogo IACT
======================================================

Para cada uno de los UCs del catálogo (UC_ACC, UC_AUTH,
UC_USR, UC_PERM, UC_RPT, UC_ALR, UC_PIP, UC_AUD, UC_LOG),
preguntarse:

1. **Abstracción** — ¿qué del dominio IVR / RBAC / ETL incluir
   o excluir?
2. **Herencia** — ¿hay reutilización con otros UC? (ej.: todos
   los UC_RPT comparten ``generar()`` / ``exportar()``).
3. **Polimorfismo** — ¿hay variantes del comportamiento?
   (formato de exportación, fuente de permiso, tipo de
   métrica).
4. **Encapsulamiento** — ¿qué expone la interfaz pública vs
   qué gestiona el backend (segmentación, SoD, auditoría)?
5. **Mensajes** — ¿qué objetos se comunican y en qué orden?
6. **Asociaciones** — ¿qué relaciones con otros UCs?
   (UC_AUTH precede UC_RPT; UC_PERM_07 valida cada acceso).

  Estas seis preguntas son **idénticas** a las dimensiones del
  checklist § 6 de
  :doc:`/normativa/estandares/metodologia-oop-para-ucs`. Este
  documento provee los **ejemplos canónicos del dominio IACT**
  que cada UC debe emular en estilo y nivel de detalle.

----

11. Acoplamiento — interdependencia entre clases
================================================

El **acoplamiento** mide el grado de interdependencia entre
objetos y clases. Es el complemento de la cohesión: una OOP
sana en IACT busca **alta cohesión dentro** de cada clase
y **bajo acoplamiento entre** clases.

Criterios canónicos
-------------------

1. **Mínimo acoplamiento posible por interacción**
   (uso o paso de mensajes). Si una clase está conectada con
   muchas otras, aunque internamente esté bien aislada, se
   produce el efecto *rippling*: una modificación en esa
   clase resuena en todo el sistema. En IACT esto aparece
   típicamente cuando ``rpt_app`` consume directamente
   modelos internos de ``perm_app`` o ``aud_app`` saltándose
   ``services.py``; lo correcto es comunicarse vía las
   interfaces ``ISecurity`` y ``IAuditLog``
   (ver :doc:`diagramas-componentes`).

2. **Máximo acoplamiento por herencia**. Cuando una clase
   hereda, debe aprovechar **todo** lo del padre y extenderlo
   tanto como sea necesario. Una herencia que solo reutiliza
   una porción mínima del padre es señal de que la jerarquía
   está mal modelada — frecuentemente conviene reemplazarla
   por composición. En IACT: ``ReporteVolumen`` y
   ``ReporteAbandono`` heredan de ``Reporte`` y reutilizan
   ``generar()``, ``exportar()``, ``aplicar_filtros_segmento()``
   (BR_012) — no solo uno de ellos.

3. **Evitar el acoplamiento *pass-through***. Si un objeto
   intermediario solo reenvía mensajes sin agregar lógica,
   un cambio de firma obliga a modificar **tres** clases
   (origen, intermediario y destino). La regla: pedir
   directamente al objeto que tiene la información.

   En IACT este antipatrón aparece cuando una vista llama a
   ``rpt_app`` que llama a ``aud_app`` solo para obtener un
   evento previamente registrado. Lo correcto: la vista
   consulta ``aud_app`` directamente cuando el dato es de
   auditoría — sin intermediario.

Contraste *pass-through* vs acceso directo
-------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Antipatron pass-through (evitar)
   class Vista
   class RptApp {
     + ultimo_evento_aud(user)
   }
   class AudApp {
     + ultimo_evento(user)
   }
   Vista --> RptApp : ultimo_evento_aud(user)
   RptApp --> AudApp : ultimo_evento(user)
   note right of RptApp
     RptApp no agrega logica:
     solo reenvia. Cambio de
     firma obliga a tocar
     Vista, RptApp y AudApp.
   end note
   @enduml

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Acceso directo (correcto)
   class Vista
   class AudApp {
     + ultimo_evento(user)
   }
   Vista --> AudApp : ultimo_evento(user)
   note right of Vista
     Cambio de firma solo
     obliga a tocar Vista y
     AudApp. RptApp queda
     fuera del cambio.
   end note
   @enduml

Reglas IACT derivadas
---------------------

- Cada app Django expone su contrato vía ``services.py``;
  el resto del sistema **no consume modelos cruzados** de
  otra app directamente.
- Cualquier intermediario que solo redirija debe ser
  refactorizado o justificarse en un ADR.
- Las herencias de ``Reporte`` / ``Alerta`` / ``EventoAud``
  deben reutilizar la mayor parte del padre. Si no lo
  hacen, romper la jerarquía y modelar con composición.

Ley de Demeter y "Tell, Don't Ask"
----------------------------------

La **Ley de Demeter** (LoD) — también conocida como *law
of least knowledge* — concreta el principio de bajo
acoplamiento. Su formulación canónica
(`Northeastern University, K. Lieberherr et al.
<https://www.khoury.northeastern.edu/home/lieber/LoD.html>`_):

   *Los métodos de una clase no deben depender de ninguna
   manera de la estructura de ninguna otra clase, excepto
   de la estructura inmediata de su propia clase. Además,
   cada método debe enviar mensajes solo a objetos
   pertenecientes a un conjunto muy limitado de clases.*

La cita encapsula dos principios:

- **Encapsulación y cohesión** (primera parte): los
  métodos de una clase no deben depender de la estructura
  de ninguna otra clase salvo de la suya propia. Esto
  promueve encapsulación restringiendo el acceso a
  elementos externos y mejora la cohesión asegurando que
  los métodos están fuertemente relacionados con los
  datos y comportamientos de su propia clase.
- **Acoplamiento bajo** (segunda parte): cada método debe
  enviar mensajes solo a objetos pertenecientes a un
  conjunto **muy limitado** de clases. Esto reduce el
  acoplamiento entre clases, simplifica el diseño y
  facilita el mantenimiento.

Operacionalmente, un método solo debe enviar mensajes a:

1. el propio objeto (``self``),
2. los parámetros recibidos,
3. los objetos creados localmente,
4. los atributos directos de ``self``.

Cualquier "salto" más allá (``a.b.c.d.do_something()``) es
una violación: el llamador conoce la **estructura interna**
de ``a``, no solo su contrato. Cambios en ``b`` o ``c``
romperán el llamador aunque la intención del UC no haya
cambiado.

Ejemplo canónico de David Bocks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

David Bocks ilustra la LoD con *El repartidor de periódicos,
la billetera y la ley de Demeter*. Dos formas de cobrar al
cliente:

- **Incumple LoD**: ``customer.wallet.totalMoney`` —
  el repartidor depende de que el cliente tenga un
  atributo ``wallet`` y de su estructura interna.
- **Cumple LoD**: ``customer.getPayment(amount)`` — el
  repartidor le dice al cliente "págame esto". El
  cliente decide internamente si saca de la billetera,
  de un sobre, de una tarjeta… El repartidor solo conoce
  el contrato.

Esto materializa el principio **Tell, Don't Ask**: en lugar
de **preguntar** datos al objeto y operar sobre ellos
externamente, **decirle** al objeto que realice la acción.
La diferencia es estructural: el primer estilo expone la
forma interna; el segundo, solo el comportamiento.

Aplicación a IACT
~~~~~~~~~~~~~~~~~

Casos típicos donde la LoD se viola en este proyecto y la
forma correcta de evitarlo:

.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Incumple LoD (evitar)
   - Cumple LoD (preferido)
 * - ``view.user.session.is_active``
   - ``view.user.is_session_active()``
 * - ``reporte.config.exportar.formato.serializar(data)``
   - ``reporte.exportar(data)``
 * - ``alerta.regla.umbral.valor > x``
   - ``alerta.regla.excede(x)``
 * - ``request.user.grupos.all().filter(...).first().permisos``
   - ``perm_app.verificar(request.user, "fn_id")``
 * - ``ejecucion.errores.first().detalle.causa``
   - ``ejecucion.causa_primer_error()``

Reglas IACT
~~~~~~~~~~~

1. **Una clase no atraviesa la estructura interna de
   otra**. Si necesita un dato de un objeto vecino, lo
   pide vía método del vecino, no por propiedad
   encadenada.
2. ``services.py`` de cada app expone métodos en imperativo
   (``verificar(...)``, ``exportar(...)``,
   ``reconocer(...)``), no getters de estructura interna.
3. Encadenar atributos a través de tres puntos
   (``a.b.c.d``) en una vista o test es **señal** de
   violación: refactorizar a un método del primer
   objeto.
4. La LoD también aplica a las plantillas RST/HTML — si
   un template hace ``{{ user.session.tokens|length }}``
   está espiando estructura interna; mejor exponer
   ``{{ user.tokens_count }}``.

Beneficios en este proyecto
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Cumplimiento de **CNST_025** (auditoría inmutable):
  cuando los cambios pasan por métodos en lugar de
  asignaciones encadenadas, los hooks de audit pueden
  registrar el evento de forma fiable.
- Refactorización segura del **modelo RBAC** (CNST_030):
  reemplazar la fuente de los permisos no rompe
  consumidores que solo invocan
  ``perm_app.verificar(...)``.
- Test más estables: los tests no fixturean cadenas
  internas, solo verifican el contrato.

----

12. Antipatrón: Descomposición funcional
========================================

William Brown, en *AntiPatterns*, describe la
**descomposición funcional** como el antipatrón en el que
el desarrollador estructura un sistema OOP como si fuera un
programa procedural tradicional, ignorando los beneficios y
principios fundamentales de la orientación a objetos.

Síntomas
--------

- **Nombres de clase que reflejan funciones, no entidades**.
  En IACT este síntoma aparece cuando, en lugar de
  ``Reporte`` y ``Permiso`` (entidades del dominio), se
  proponen clases como ``CalcularReporte``,
  ``ProcesarExportacion``, ``ValidarPermiso``.
- **Clases con un único método**, generalmente llamado
  ``ejecutar``, ``procesar`` o ``correr``. Indica que la
  clase es realmente una función disfrazada.
- **Uso excesivo de miembros estáticos** — la clase se
  convierte en un namespace de funciones en lugar de una
  plantilla para crear objetos. En Django esto aparece
  cuando ``services.py`` solo expone ``staticmethod`` sin
  estado, mientras la lógica del dominio (estados,
  invariantes, contratos) queda fuera del modelo.
- **Ausencia de principios OOP**: sin herencia para
  jerarquías "es-un", sin polimorfismo para variantes de
  comportamiento, sin encapsulamiento para proteger
  invariantes.

Consecuencias
-------------

Brown señala que el código en este antipatrón se vuelve:

- **Imposible de comprender** — la lógica está dispersa y
  no refleja el modelo del dominio. En IACT esto rompe la
  trazabilidad UC ↔ código.
- **Difícil de reutilizar** — funcionalidades fuertemente
  acopladas que no encajan en otra app Django sin
  reescritura.
- **Complicado de probar** — sin encapsulamiento y con
  alta dependencia entre componentes, los tests requieren
  fixtures gigantes para cada caso.

En IACT, además, el antipatrón **rompe el contrato del
audit**: si la lógica de negocio vive en funciones sueltas
sin estado, los eventos auditables (CNST_025) se registran
desde múltiples puntos no canónicos y se vuelven
incompletos.

Solución — Modelo del dominio orientado a objetos
-------------------------------------------------

1. Identificar las **entidades reales** del dominio del
   problema (sustantivos del experto del dominio — ver
   :doc:`analisis-dominio`).
2. Modelar esas entidades como clases con
   **responsabilidades bien definidas** (RDD,
   :doc:`analisis-dominio` § 12.3).
3. Establecer **relaciones naturales** entre las clases
   reflejando las relaciones del mundo real
   (asociaciones, agregación, composición — ver
   :doc:`relaciones-uml`,
   :doc:`agregacion-interfaces`).
4. Aplicar **patrones de diseño** apropiados para
   resolver problemas comunes — ver
   :doc:`patrones-diseno`.

Cuándo aparece típicamente en IACT
-----------------------------------

- Migraciones de scripts ETL legados a ``pip_app`` —
  tendencia a copiar el flujo procedural sin modelar
  ``EjecucionETL`` y ``VentanaETL`` como entidades.
- Vistas Django con lógica de negocio inline en lugar
  de delegar al modelo o a ``services.py``.
- Cálculo de métricas BR_016/017/018 implementado como
  funciones sueltas en lugar de en ``Reporte`` y sus
  subclases polimórficas.

Heurística rápida para detectarlo
---------------------------------

Si una clase IACT no tiene atributos de estado y solo
expone un método ``run``/``ejecutar``/``procesar``, casi
seguro es una función disfrazada. Refactorizar a entidad
del dominio o a función pura — pero no dejarla como clase
fingida.

----

13. Antipatrón: Flujo de lava (*lava flow*)
===========================================

El **flujo de lava** describe la acumulación progresiva de
código muerto, obsoleto o poco mantenible que se
"solidifica" en el sistema, similar a cómo la lava
volcánica se endurece al enfriarse. Este código se vuelve
cada vez más difícil de modificar o eliminar con el tiempo.

El fenómeno aparece cuando código que ya no cumple función
útil permanece en el sistema. Los desarrolladores
posteriores, por presión de tiempo o por temor a romper
funcionalidades existentes, evitan modificarlo y prefieren
crear **implementaciones paralelas** — generando más
"flujos" de código problemático.

Manifestaciones concretas
-------------------------

- Interfaces abandonadas.
- Clases sin uso aparente.
- Funciones obsoletas.
- Fragmentos de código comentado sin documentación clara.
- Comentarios ``TODO`` o ``"a reemplazar"`` que nunca se
  abordan.

Tres dinámicas que se retroalimentan
------------------------------------

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Dinámica
   - Qué es
   - Cómo aparece
 * - Acumulación progresiva
   - El código obsoleto o innecesario se va acumulando
     gradualmente.
   - Características a medio desarrollar; fragmentos
     dejados tras cambios de requisitos; código "por si
     acaso"; múltiples versiones de la misma
     funcionalidad.
 * - Solidificación irreversible
   - El código se vuelve cada vez más difícil de
     modificar o eliminar.
   - Pérdida de conocimiento sobre el propósito
     original; dependencias no documentadas; rotación
     de desarrolladores; documentación obsoleta; miedo
     a "romper algo".
 * - Proliferación exponencial
   - El problema se multiplica de manera acelerada.
   - Para evitar tocar lo "solidificado" se crean
     nuevas implementaciones; cada una puede generar su
     propio flujo; el código duplicado se multiplica;
     soluciones temporales se vuelven permanentes.

Cómo aparece típicamente en IACT
--------------------------------

- **Cálculo de métricas BR_016/017/018** implementado
  varias veces (vista, ``services.py``, helper antiguo)
  sin que nadie sepa cuál es la fuente de verdad.
- **Endpoints de export** que quedaron abandonados al
  migrar a la versión async (CNST_019/020) pero siguen
  expuestos.
- **Versiones antiguas de migraciones Django** dejadas
  como referencia; modelos con campos en desuso porque
  alguien temió tocarlos.
- **Reglas de alerta** comentadas dentro de
  ``alr_app`` con TODO de hace meses, mientras la lógica
  vigente vive en otro archivo.
- **ADRs supuestamente reemplazados** sin marcar como
  *Superseded* — el lector no sabe cuál vale.

Por qué es especialmente grave en IACT
--------------------------------------

- Rompe la **trazabilidad UC ↔ código**: si hay tres
  funciones que dicen calcular abandono, ningún auditor
  puede certificar cuál se ejecutó.
- Compromete **CNST_025** (auditoría inmutable): si la
  lógica vive en código muerto que ocasionalmente todavía
  se invoca, los eventos auditados pueden no reflejar la
  realidad.
- Aumenta el riesgo en cada **iteración del modelo de
  fuente** (§ 14): cada incremento se construye sobre
  capas opacas previas.

Prevención y mitigación
-----------------------

- **Revisiones de código regulares** con foco explícito
  en código muerto.
- **Análisis estático** (flake8/ruff/coverage en Python;
  herramientas equivalentes en JS) que reporte
  funciones/clases sin uso o sin tests.
- **Política de refactorización**: eliminar código
  obsoleto antes de que se solidifique. Una limpieza
  pequeña en cada iteración rinde más que una
  "modernización" diferida.
- **Documentación viva**: mantener ADRs y guías
  actualizadas; marcar como *Superseded* o eliminar lo
  que ya no aplica.
- **Eliminar, no comentar**: el git history (I-002) ya
  preserva la versión anterior. Comentar código
  "por si acaso" es producir lava deliberadamente.
- **TODO con dueño y fecha**: un ``TODO`` sin nombre y
  sin fecha es deuda anónima — convertirlo en issue del
  WP correspondiente o eliminarlo.

Heurística IACT
---------------

Si en un *grep* del repositorio aparecen ≥ 2 funciones que
hacen lo mismo (mismo nombre con sufijos *_old*, *_v2*, o
duplicado entre apps), el cluster está acumulando lava.
Abrir un WP de limpieza antes de añadir más código
encima.

DRY — Don't Repeat Yourself
---------------------------

DRY es el principio inverso al flujo de lava. Su
formulación canónica:

   *Cada pieza de conocimiento debe tener una representación
   única, inequívoca y autorizada dentro de un sistema.*

Es uno de los principios más difíciles de aplicar y, a la
vez, más comunes de violar — precisamente porque copiar y
modificar código es **más rápido a corto plazo** que
descubrir y reutilizar la pieza correcta.

Caso ilustrativo
~~~~~~~~~~~~~~~~

El ejemplo clásico: un motor de aplicación que falla con
ciertos nombres de objeto, y una interfaz de usuario que
duplica las **validaciones de negocio** del backend para
"compensar". Cuando el fallo del motor se corrige, la
interfaz sigue ejecutando validaciones obsoletas; reparar
la duplicación toma semanas. La copia ganó días iniciales
y costó meses.

Consecuencias de violar DRY
~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Mantenibilidad deficiente** — un cambio o corrección
   debe replicarse en todas las copias; aumenta la
   complejidad y el riesgo de errores.
2. **Costo elevado** — corregir un defecto exige tocar
   cada instancia, multiplicando el esfuerzo.
3. **Dificultad para evolucionar** — mantener todas las
   copias sincronizadas se vuelve una tarea ardua.

Casos típicos donde DRY se viola en IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Validaciones de negocio** (CNST_*, BR_*) duplicadas
  entre el frontend y ``services.py`` del backend. La
  fuente de verdad debe vivir en el backend; el frontend
  solo decora la experiencia, no decide.
- **Cálculo de métricas** (BR_016/017/018) replicado en
  ``rpt_app.services``, en una vista helper y en un
  notebook de análisis. Una sola implementación canónica
  con tests.
- **Listas de funciones / permisos** (catálogo RBAC)
  hardcodeadas en código y reproducidas en JSON de
  fixtures, plantillas de migración y documentación
  auto-generada. Una única fuente de verdad —
  típicamente la BD — y todo lo demás se genera.
- **Reglas de SoD** (CNST_030) escritas en código y
  repetidas en checklists humanos. La regla canónica
  debe ser ejecutable; los checklists humanos se
  derivan, no se mantienen en paralelo.
- **Consultas SQL idénticas** copiadas en distintas
  vistas. Refactorizar a managers de Django o a
  ``services.py``.

Reglas IACT
~~~~~~~~~~~

1. Antes de copiar una función, **buscar primero**
   (``grep``, IDE) si ya existe.
2. Si dos lugares contienen el **mismo conocimiento**
   (regla, validación, cálculo), refactorizar a una
   única ubicación canónica antes de seguir.
3. Cuando aparezca duplicación inevitable, documentar la
   excepción en un ADR y enlazar las copias entre sí en
   comentarios — para que la próxima persona sepa que
   son **deliberadamente** redundantes.
4. Las plantillas RST y los tests no escapan de DRY: si
   un fragmento aparece en cinco archivos, conviértelo
   en un ``include`` o helper.
5. La eliminación de código duplicado no se posterga;
   crea lava (§ 13).

Tensión con prematuras abstracciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DRY no significa abstraer cualquier coincidencia. Dos
fragmentos similares que **representan conocimientos
distintos** deben permanecer separados — su evolución
divergerá. La regla de Hunt y Thomas: evitar duplicar
**conocimiento**, no caracteres. En IACT esto aparece
cuando dos UCs tienen estructura idéntica al inicio pero
divergen en los flujos alternativos: extraer la base
común sería forzar acoplamiento entre dominios distintos.

----

14. Ciclo de vida basado en prototipos
======================================

El enfoque sustantivos→clases del documento
:doc:`analisis-dominio` se complementa naturalmente con un
**ciclo de vida basado en prototipos**: construir desde el
inicio un prototipo que se enriquece progresivamente por
herencia y especialización, en vez de redactar
especificaciones extensas antes de cualquier ejecución.

Por qué tiene sentido en IACT
-----------------------------

La especificación textual pura, aplicada por sí sola,
plantea dos problemas:

1. **Es poco precisa**. Dos personas pueden entender un
   concepto aparentemente claro de manera diferente. En
   IACT, "tasa de abandono" puede interpretarse como
   abandono **antes** de cola, **dentro** de cola, o por
   timeout sistémico — la diferencia se vuelve evidente
   solo cuando alguien la implementa.
2. **Los objetivos no son siempre claros**. IACT no es un
   sistema que mecaniza tareas manuales por primera vez;
   es una segunda generación que pretende **mejorar** un
   proceso ya existente. Cuando un stakeholder pide
   "mejor visibilidad de los segmentos" o "alertas más
   accionables", traducir esas peticiones a
   funcionalidades concretas es difícil, y el mejor
   enfoque suele ser la **experimentación**.

Por qué OOP hace viable el prototipado
--------------------------------------

Históricamente, los prototipos se construían en lenguajes
de muy alto nivel y, una vez validados, debían
**desecharse** para reescribir la aplicación en un lenguaje
de producción — un coste que solo se asumía en proyectos
excepcionales.

OOP cambia el balance: con **herencia**, **librerías de
clases** y **refinamiento por especialización**, un
prototipo válido **no tiene que tirarse**. Lo que se valida
en el prototipo se conserva como base; las clases se
extienden o sustituyen sin reescribir el sistema entero.

Aplicación en IACT
------------------

- En cada UC nuevo, antes de invertir en una
  especificación de 13 secciones (ver
  :doc:`casos-uso-especificacion`), conviene un prototipo
  ejecutable mínimo del flujo nominal — incluso si solo
  cubre el escenario feliz.
- El prototipo se construye sobre las clases del dominio
  IACT (``Reporte``, ``Alerta``, ``Sesion``, etc.) y se
  refina por herencia (``ReporteVolumen`` ←
  ``Reporte``).
- Los aprendizajes del prototipo se incorporan a la
  especificación; la especificación deja de ser un acto
  de fe y pasa a documentar comportamiento ya observado.
- El prototipo **no es desechable**: las clases probadas
  pasan a producción tras revisión y ajuste, no tras
  reescritura.

Restricciones
-------------

El prototipado no exime al equipo de:

- Validar contra restricciones del proyecto (CNST_*) y
  reglas de negocio (BR_*).
- Cumplir el stack canónico ADR_DEVOPS_001 — un prototipo
  que solo funciona en Docker o con Nginx no es un
  prototipo válido para IACT.
- Auditar cada iteración (CNST_025) cuando el prototipo
  toca datos reales o réplicas operativas.

Relación con las escuelas de análisis
-------------------------------------

Prototipado y análisis no compiten: el análisis
sustantivos→clases / RDD identifica las entidades y
contratos que el prototipo materializa. El prototipo, a su
vez, **revela clases emergentes** que el análisis no había
previsto — alimentando la siguiente iteración del modelo
(ver :doc:`analisis-dominio` § 12.2 sobre la naturaleza
iterativa del análisis basado en escenarios).

----

15. Ciclo de vida iterativo e incremental
=========================================

Cuando el prototipado (§ 13) se sostiene en el tiempo,
desemboca naturalmente en un **ciclo de vida iterativo e
incremental**. Para software orientado a objetos, el modelo
que mejor refleja esta dinámica es el **modelo de fuente
(*fountain model*) de Henderson-Sellers**.

Características del modelo
--------------------------

- **Arraigado en el mundo real** — modela los sistemas tal
  como evolucionan, no como diagramas idealizados.
- **Alto nivel de iteración** — las etapas no son
  estancos: análisis, diseño y construcción se solapan.
- **Fusión de etapas** del modelo clásico — la separación
  rígida entre "análisis terminado", "diseño terminado" y
  "construcción terminada" se relaja.
- **Lema operativo** (Gilb): *"un poco de análisis, un
  poco de diseño, un poco de programación y
  ¡repitámoslo!"*

Estructura típica de iteraciones
--------------------------------

La variante más frecuente del modelo:

1. **Primera iteración** — más larga (3 a 4 meses según el
   tipo de aplicación). En ella se analiza la aplicación y
   se elige el **núcleo significativo de negocio**: lo que
   representa la actividad básica y los objetos que tienen
   relación con la mayor parte del sistema.
2. **Iteraciones siguientes** — más cortas (~1 mes cada
   una). Cada iteración entrega un **incremento** sobre lo
   anterior; el usuario sigue utilizando la versión previa
   en producción mientras se construye la siguiente.

Los cambios sobre lo entregado son habituales y no
problemáticos: la herencia permite introducirlos sin
"desmontar" la base. La crítica del usuario sobre lo que ya
usa **alimenta** la siguiente iteración en lugar de
bloquearla.

Un beneficio implícito: al final del desarrollo, no hace
falta puesta en producción de pruebas ni formación masiva
de usuarios — ambas tareas se han realizado **gradualmente**
durante todo el ciclo.

Aplicación a IACT
-----------------

Núcleo significativo del proyecto IACT (primera iteración):

- ``Sesion``, ``Usuario`` y ``Permiso`` (auth + RBAC) —
  base sobre la que se apoyan todos los demás UCs.
- ``Llamada`` y ``EjecucionETL`` — entidades centrales del
  flujo de datos operativos hacia analytics.
- ``Reporte`` (clase base) y un par de subclases
  representativas (``ReporteVolumen``,
  ``ReporteAbandono``) — suficientes para validar el
  patrón polimórfico de UC_RPT_*.
- ``EventoAuditoria`` — sin auditoría no se puede entregar
  nada (CNST_025).

Incrementos posteriores típicos:

- Reportes adicionales (UC_RPT_*) y exportación async
  (UC_RPT_04).
- Familia de alertas (UC_ALR_*) con sincronización
  auditoría/notificación.
- Endurecimiento del modelo SoD (CNST_030) y reglas BR
  adicionales.
- Optimización de la ventana ETL (CNST_006/008).

Cada incremento se entrega al supervisor y al equipo de
calidad, que lo prueban en condiciones reales mientras el
siguiente incremento está en construcción.

Riesgos a controlar
-------------------

El modelo iterativo no es licencia para descuidar
disciplinas:

- Cada iteración debe respetar las restricciones del
  proyecto (CNST_*) y reglas de negocio (BR_*).
- Cada cambio sobre lo entregado debe pasar por
  ``rm-validation`` antes de re-publicarse — el hecho de
  que la herencia simplifique el cambio técnico no
  exime de re-validación funcional y de auditoría.
- Cada incremento mantiene los ADRs vigentes
  (especialmente ADR_DEVOPS_001) — un incremento que
  cambie el stack es, por definición, un cambio
  arquitectónico, no un incremento.

Relación con prototipos y escuelas de análisis
----------------------------------------------

- El **prototipo** (§ 13) es el punto de partida de la
  primera iteración del modelo de fuente.
- El **análisis del dominio** y las **escuelas de
  identificación de clases** (ver
  :doc:`analisis-dominio` § 12) se aplican en cada
  iteración, no solo al inicio.
- Los **patrones de diseño** (ver
  :doc:`patrones-diseno`) se incorporan progresivamente,
  conforme las iteraciones revelan los puntos donde
  realmente se necesitan.

----

16. Principio Abierto-Cerrado (OCP)
===================================

Bertrand Meyer formuló el **Principio Abierto-Cerrado**
(*Open-Closed Principle, OCP*):

   *Las entidades de software (clases, módulos, funciones,
   etc.) deben estar abiertas a la extensión, pero
   cerradas a la modificación.*

Esto significa que debe poder **agregarse nueva
funcionalidad sin alterar el código existente**. Es uno
de los principios SOLID y subyace a varios patrones GoF
(Strategy, Decorator, Template Method, Adapter — ver
:doc:`patrones-diseno`).

16.1 Diseño deficiente vs buen diseño
-------------------------------------

.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Diseño deficiente (viola OCP)
   - Buen diseño (cumple OCP)
 * - Un solo cambio dispara cascada de
     modificaciones.
   - Los módulos nunca cambian.
 * - El programa es frágil, rígido e
     impredecible.
   - El comportamiento del módulo se extiende
     **agregando nuevo código**, sin tocar el
     existente.

Los módulos de software deben:

- **Estar abiertos a la extensión** — su comportamiento
  se puede ampliar.
- **Estar cerrados a la modificación** — su código
  fuente **no se cambia** para extenderlo.

16.2 Abstracción y polimorfismo son la clave
--------------------------------------------

OCP se materializa con **abstracción** y **polimorfismo**:
una clase no debe depender de una clase concreta, debe
depender de una **clase abstracta o interfaz**. Cuando
aparece una variante nueva, se introduce una clase nueva
que implementa la abstracción — y los consumidores
existentes ni se enteran.

Esta es exactamente la base de los patrones Strategy y
Adapter en :doc:`patrones-diseno`.

16.3 Cierre estratégico
-----------------------

Ningún programa puede estar **100% cerrado**: siempre
habrá cambios contra los cuales algún módulo **no esté
cerrado**. El cierre no es completo — es **estratégico**.

El diseñador decide **para qué tipos de cambios cerrar el
diseño** según experiencia y conocimiento del dominio.

En IACT esto se traduce en preguntas como:

- ¿Para nuevos formatos de export estamos cerrados?
  Sí — Strategy con ``FormatoExport`` permite añadir CSV,
  XLSX, JSON, PDF sin tocar el flujo (ver
  § 9 de :doc:`patrones-diseno`).
- ¿Para nuevos tipos de reporte? Sí — Factory +
  herencia por especialización
  (§ 14.1 de :doc:`relaciones-uml`).
- ¿Para una nueva fuente de datos operativos
  (sustituir bd_operativa)? Sí — Adapter con
  ``IDatosOperativos`` (ver
  :doc:`diagramas-componentes`).
- ¿Para reemplazar el stack canónico
  (ADR_DEVOPS_001)? **No** — eso es una decisión
  arquitectónica, no una extensión de comportamiento.

Cerrar el diseño contra **todo** es imposible. Cerrar
contra los cambios **probables** del dominio es la regla.

16.4 Heurísticas que se derivan
-------------------------------

OCP sugiere varias prácticas concretas — heurísticas, no
reglas absolutas:

- **Variables miembro privadas**. Protege la
  encapsulación: los consumidores quedan cerrados ante
  cambios de nombres de variables o de implementación
  interna. Si fueran públicas, **nadie** estaría
  cerrado contra modificaciones impropias.
- **No usar variables globales**. El estado global
  rompe el cierre por construcción: cualquier código
  puede mutar lo que otro lee.
- **Evitar RTTI (*runtime type identification*) y
  *isinstance* en chains de tipos derivados**. Si un
  módulo hace cast dinámico para distinguir subtipos,
  cada vez que se añade una subclase hay que modificar
  ese módulo — exactamente lo que OCP intenta evitar.
  La alternativa es **polimorfismo** (despacho dinámico
  por método) en lugar de discriminar por tipo.

Ninguna de estas heurísticas viola OCP siempre — son
**guías**.

16.5 Aplicación a IACT
----------------------

Casos donde OCP es crítico en este proyecto:

.. list-table::
 :widths: 35 35 30
 :header-rows: 1

 * - Punto de extensión
   - Cómo cumple OCP
   - Patrón implicado
 * - Nuevos formatos de export
   - Strategy con ``FormatoExport`` (CSV/XLSX/JSON).
   - Strategy
 * - Nuevos tipos de reporte
   - Herencia por especialización + Factory.
   - Factory + Especialización
 * - Nuevas reglas de alerta
   - Strategy ``EvaluadorAlertas``.
   - Strategy
 * - Nuevos formatos de export con firma
   - Decorator (firma + cifrado encadenados).
   - Decorator
 * - Nueva fuente de datos operativos
   - Adapter sobre ``IDatosOperativos``.
   - Adapter
 * - Nuevas vistas auditadas
   - Decorator ``@requiere_permiso``.
   - Decorator
 * - Nuevos suscriptores a eventos de dominio
   - Observer con ``Bus``.
   - Observer

Antipatrones IACT contra OCP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``isinstance`` chain en una vista para decidir cómo
  serializar diferentes ``Reporte``: cada nuevo tipo
  obliga a tocar la vista. Refactorizar a polimorfismo.
- ``services.py`` con ``if formato == "csv": ... elif
  formato == "xlsx": ...`` repetido en N lugares: cada
  formato nuevo se duplica. Strategy.
- Lógica de SoD (CNST_030) hardcodeada por rol en
  varias vistas: cada rol nuevo obliga a tocar todas
  las vistas. Centralizar en ``perm_app.SecRules`` con
  reglas declarativas.

16.6 Relación con otros principios
----------------------------------

- **DRY** (§ 13) — OCP suele eliminar duplicación
  natural: extender por nueva clase en lugar de copiar
  e if-elseificar.
- **LSP** (§ 14 de :doc:`relaciones-uml`) — OCP solo
  funciona si las subclases respetan el contrato; LSP
  es la **garantía** de que el polimorfismo se puede
  usar.
- **Information Expert** (§ 13 de
  :doc:`patrones-diseno`) — el experto natural de un
  comportamiento es el punto de extensión cerrado al
  resto.
- **Demeter** — OCP refuerza Demeter: si los módulos no
  espían estructura interna, agregar una nueva
  variante no rompe a sus consumidores.

----

17. Principio de Responsabilidad Única (SRP)
============================================

El **Single Responsibility Principle** (SRP), formulado por
Robert C. Martin a partir de las ideas de Tom DeMarco y
Meilir Page-Jones, es la "S" de SOLID:

   *Una clase debe tener solo una razón para cambiar.*

Una clase debe tener **una sola responsabilidad o
funcionalidad bien definida**. Si más de un actor del
negocio puede provocar cambios en la misma clase, hay más
de una responsabilidad.

17.1 Por qué importa
--------------------

Problemas que aparecen cuando una clase agrupa múltiples
responsabilidades:

1. **Sobrecarga de responsabilidades** — cada cambio en
   una responsabilidad puede afectar a las demás,
   complicando el mantenimiento.
2. **Acoplamiento excesivo** — clases con varias
   responsabilidades suelen estar más acopladas entre sí,
   reduciendo la modularidad y la flexibilidad.
3. **Falta de claridad** — es más difícil entender el
   propósito y el comportamiento de una clase que hace
   varias cosas a la vez.

Ejemplo histórico — sobrecarga de I/O en C++
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Algunos libros clásicos de C++ promovieron un mal diseño:
sobrecargar los operadores ``<<`` y ``>>`` de
**entrada/salida** dentro de la propia clase de dominio.
Esto mezcla la lógica de negocio con la presentación —
si más adelante se quiere cambiar de terminal a GUI o
web, la clase se tiene que tocar **por una razón distinta
a su propósito de dominio**.

Síntomas: cambios más frecuentes, mayor dependencia con
elementos de UI, dificultad para reutilizar la clase fuera
del contexto original.

Relación con MVC: los estereotipos de análisis
**Control / Entidad / Límite** (boundary) son una
materialización del SRP — separan **lógica de
coordinación**, **modelo de dominio** y **frontera con el
exterior** en clases distintas.

17.2 SRP a nivel de módulo
--------------------------

SRP se extiende del nivel de clase al **nivel de módulo o
componente**. Si un framework de GUI v1.1 incorpora en su
v1.2 una funcionalidad que **no está relacionada** con su
responsabilidad principal, el usuario se ve obligado a
aceptar un cambio irrelevante para su caso de uso.

En IACT esto se traduce en una regla operativa: cada app
Django tiene **una sola responsabilidad de dominio**:

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - App
   - Responsabilidad única
   - Razones legítimas para cambiar
 * - ``auth_app``
   - Identificación contra LDAP, sesión.
   - Cambio de protocolo LDAP, cambio en política
     CNST_002.
 * - ``perm_app``
   - Decisiones de seguridad (permisos, SoD).
   - Nueva función en catálogo, cambio en regla
     CNST_030.
 * - ``rpt_app``
   - Generar y exportar reportes.
   - Nueva métrica, nuevo formato, nuevo rango
     CNST_031.
 * - ``alr_app``
   - Evaluar y publicar alertas.
   - Nueva regla de alerta (BR_016/017/018), nuevo
     mecanismo de reconocimiento.
 * - ``pip_app``
   - Carga ETL desde fuentes operativas.
   - Cambio en bd-operativa, ivr-host o ventana
     CNST_006/008.
 * - ``aud_app``
   - Audit immutable.
   - Cambio en requisito CNST_025 o en consultas
     legales.
 * - ``log_app``
   - Notificación al buzón interno.
   - Cambio en política CNST_001.

Si un cambio toca **más de una app**, probablemente hay
una responsabilidad repartida o un cluster mal definido
(ver § 11 de :doc:`agregacion-interfaces`).

17.3 SRP y reutilización
------------------------

Una menor cohesión produce **pobre reutilización**.
Analogía clásica: si una persona ofrece regalar un VCR
combinado con un televisor, alguien que solo necesita un
VCR no puede aceptarlo — el aparato combinado obliga a
recibir cosas no deseadas.

En código pasa lo mismo: una clase ``Reporte`` que también
serializa, también persiste, también notifica y también
audita es como ese aparato combinado — no se puede
reutilizar la lógica de cálculo sin arrastrar
serialización, persistencia, notificación y audit.

Acoplamiento estrecho + cohesión pobre = mala
reutilización. SRP es la herramienta para evitarlo.

17.4 Aplicación a IACT
----------------------

Antipatrones SRP en este proyecto:

- ``Reporte`` que conoce su formato de export
  (CSV/XLSX/JSON) **y** decide cómo mandarlo al buzón.
  Dos responsabilidades: cálculo + entrega. Separar:
  ``Reporte`` (cálculo) + ``ExportadorReporte`` (formato,
  Strategy) + ``log_app`` (entrega).
- ``Alerta`` que evalúa la regla de umbral, registra el
  evento y publica al supervisor. Tres responsabilidades.
  Separar: ``EvaluadorAlertas`` (regla, Strategy) +
  ``Alerta`` (estado del incidente) + ``log_app``
  (notificación) + ``aud_app`` (registro CNST_025).
- ``Sesion`` que gestiona la caducidad **y** registra
  cada acceso al backend para auditoría. Separar:
  ``Sesion`` (ciclo de vida) + ``aud_app`` (audit).
- Una vista Django que valida permiso, ejecuta lógica,
  serializa la respuesta y registra audit. Cuatro
  responsabilidades. Decoradores
  (``@requiere_permiso``), modelo del dominio,
  serializador y observer de audit cubren cada una con
  su propia clase.

17.5 Cómo detectar violaciones de SRP
-------------------------------------

Heurísticas operativas para IACT:

- La clase tiene **más de cinco** métodos públicos no
  relacionados entre sí.
- En el último mes, la clase ha cambiado por **dos o más
  motivos distintos** (mirar git log).
- El nombre de la clase incluye conjunciones ("y",
  "Manager", "Helper", "Service" sin sufijo de dominio)
  que delatan responsabilidades agrupadas.
- Los tests de la clase necesitan **mocks de áreas
  distintas** (BD, red, audit) para cubrir todos los
  caminos.
- Cambiar la firma de un método obliga a tocar tests de
  más de un dominio.

Cuando varias heurísticas se cumplen a la vez, separar.

17.6 Relación con otros principios
----------------------------------

- **OCP** (§ 16) — SRP es prerrequisito de OCP: si una
  clase tiene varias responsabilidades, cerrarla contra
  modificaciones es imposible porque cada
  responsabilidad pide cambios distintos.
- **Information Expert / RDD** (§ 13 de
  :doc:`patrones-diseno`; § 13.3 de
  :doc:`analisis-dominio`) — SRP guía **a quién**
  asignar la responsabilidad: al experto, no a un
  multi-responsable.
- **Cohesión** (§ 11) — SRP maximiza cohesión: una sola
  responsabilidad implica que todos los miembros de la
  clase concurren al mismo propósito.
- **DRY** (§ 13) — separar responsabilidades elimina la
  duplicación que aparece cuando una clase replica
  fragmentos de otras.

Regla integradora
~~~~~~~~~~~~~~~~~

SRP es el principio más simple de SOLID y, paradójicamente,
el más difícil de aplicar consistentemente. La pregunta
operativa que ayuda en cada revisión: **¿quién (qué actor
del negocio) puede pedir un cambio en esta clase?** Si la
respuesta enumera más de un actor, hay más de una
responsabilidad.

----

18. Principio de Sustitución de Liskov (LSP)
============================================

El **Liskov Substitution Principle** (LSP) fue introducido
por **Barbara Liskov** en 1987 y formalizado posteriormente
con Jeannette Wing. Es la "L" de SOLID:

   *Los objetos de una superclase deben poder ser
   reemplazados por objetos de sus subclases sin afectar
   la corrección del programa.*

LSP convierte la herencia en un instrumento de
**sustituibilidad segura**: si ``B`` hereda de ``A``,
cualquier código que opere sobre instancias de ``A`` debe
funcionar correctamente al recibir una instancia de ``B``,
sin necesidad de saber que es ``B``.

18.1 Reglas formales del contrato
---------------------------------

Las subclases deben **respetar los contratos** establecidos
por la clase base. Si la clase padre garantiza cierto
comportamiento, la hija debe mantener esas garantías.

Los métodos de la subclase que **sobrescriben** métodos de
la superclase deben:

- **Parámetros**: aceptar los **mismos tipos** o tipos
  **más generales** (contravariancia en argumentos).
- **Retorno**: devolver el **mismo tipo** o un
  **subtipo** (covariancia en resultados).
- **Excepciones**: no lanzar nuevas excepciones, salvo
  que sean **subtipos** de las excepciones ya declaradas
  en el padre.

Adicionalmente, según Bertrand Meyer (Design by Contract):

- **Precondiciones** del método sobrescrito **no se
  fortalecen** — la subclase no puede exigir más al
  llamador.
- **Postcondiciones** **no se debilitan** — la subclase
  no puede prometer menos.
- **Invariantes** del padre se preservan en la hija.

18.2 Por qué importa
--------------------

LSP es la condición que **habilita el polimorfismo
seguro**. Sin LSP, el código consumidor de ``A`` debe
revisar (con ``isinstance`` o equivalente) qué subtipo le
está llegando y aplicar excepciones especiales — lo cual
viola OCP (§ 16).

En IACT esto importa especialmente en:

- ``Reporte`` y sus subclases — un consumidor de
  ``IReporte`` debe poder llamar ``generar()`` y
  ``exportar()`` en cualquier subtipo sin reglas
  especiales.
- ``Alerta`` y sus variantes — el supervisor reconoce
  alertas sin saber si es por umbral, tendencia o
  agregado.
- ``EventoAuditoria`` y subtipos — ``aud_app`` registra
  cualquier subtipo sin distinguir.

18.3 Violaciones típicas
------------------------

- Subclase que lanza ``NotImplementedError`` para
  desactivar un método del padre — herencia por
  limitación (ver § 14.4 de :doc:`relaciones-uml`).
  Ejemplo canónico: ``Ave`` con ``volar()`` y
  ``Pinguino`` que lo desactiva.
- Subclase que **fortalece** una precondición — exige
  argumentos no nulos cuando el padre permitía nulos.
  Cualquier consumidor del padre se rompe al recibir la
  hija.
- Subclase que **debilita** una postcondición — el padre
  promete devolver una lista no vacía y la hija puede
  devolver vacía. El consumidor que itera asume no-vacía
  y falla.
- Subclase que lanza una excepción **nueva, no subtipo**
  de las del padre. El consumidor que no la captura
  termina abortando.
- Subclase que **rompe invariantes** del padre — por
  ejemplo, una ``CuentaBancariaCredito`` heredando de
  ``CuentaBancaria`` y permitiendo saldo negativo
  cuando el padre lo prohibía.

18.4 Aplicación a IACT
----------------------

Antipatrones LSP que aparecen o aparecerían en este
proyecto:

- ``ReporteSoloLectura`` heredando de ``Reporte`` y
  lanzando excepción en ``exportar()``. Modelar como
  interfaces separadas (ver § 14.4 de
  :doc:`relaciones-uml` para el rediseño con
  ``IExportable`` e ``IConsultable``).
- ``UsuarioInactivo`` heredando de ``Usuario`` y
  desactivando ``iniciar_sesion()``. Reemplazar por
  estado del propio ``Usuario`` (composición + State).
- ``EjecucionETLDryRun`` heredando de ``EjecucionETL`` y
  saltando la persistencia: rompe la postcondición
  "tras ``commit()`` el resultado está en
  ``bd_analytics``". Modelar como modo de ejecución
  pasado por argumento, no como subtipo.

LSP correcto en IACT
~~~~~~~~~~~~~~~~~~~~

- ``ReporteVolumen``, ``ReporteAbandono``,
  ``ReporteSoDCompliance`` heredan de ``Reporte`` y
  cumplen LSP: cualquiera de las tres puede sustituir a
  ``Reporte`` en cualquier consumidor (ver
  :doc:`patrones-diseno` § 3 Factory; § 14.1 de
  :doc:`relaciones-uml`).
- ``EventoAuditoriaAcceso``, ``EventoAuditoriaCambio``
  heredan de ``EventoAuditoria`` con la misma
  semántica de inmutabilidad (CNST_025).
- ``EstadoAlerta`` con ``AlertaPublicada``,
  ``AlertaReconocida``, ``AlertaCerrada``: cada subtipo
  responde a las mismas operaciones (``reconocer``,
  ``cerrar``) — algunas con ``TransicionInvalida``,
  pero esa excepción es parte del **contrato del padre**
  (no una excepción nueva de la hija). Por eso no viola
  LSP — el padre ya declara que ciertas transiciones
  son inválidas.

18.5 Cómo detectar violaciones
------------------------------

Heurísticas operativas:

- Métodos heredados que lanzan ``NotImplementedError`` o
  excepciones nuevas no documentadas en el padre.
- ``isinstance`` en código consumidor para discriminar
  subtipos — síntoma de que el polimorfismo no es
  seguro.
- Tests del padre que **fallan** cuando la hija se
  inyecta como sustituto.
- Comentarios "no aplica para este subtipo" o "este
  subtipo se comporta diferente".

Cuando estos síntomas aparecen, reemplazar la herencia
por **interfaces más específicas** o **composición**
(ver § 15 de :doc:`relaciones-uml`).

18.6 Relación con otros principios
----------------------------------

- **OCP** (§ 16) — LSP es la condición previa: solo se
  puede extender por nuevas subclases si esas subclases
  son sustituibles.
- **SRP** (§ 17) — una subclase con varias
  responsabilidades es más propensa a violar LSP en
  alguna de ellas.
- **Information Expert** (§ 13 de
  :doc:`patrones-diseno`) — el experto natural cumple
  LSP por construcción cuando sus subtipos comparten el
  mismo conocimiento base.
- **Especialización** (§ 14.1 de
  :doc:`relaciones-uml`) — la única forma de herencia
  que cumple LSP por diseño.

----

19. Principio de Segregación de Interfaces (ISP)
================================================

   *Los clientes no deben ser obligados a depender de
   métodos que no usan.*

19.1 Problema — interfaces sobrecargadas (*fat interfaces*)
-----------------------------------------------------------

Cuando una clase acumula demasiados métodos a lo largo
del tiempo, se convierte en una **interfaz monolítica y
poco cohesiva**. Síntomas:

- Falta de cohesión (viola SRP).
- Clientes obligados a conocer detalles que no les
  importan.
- Implementaciones cargan con métodos no relevantes
  para todos los consumidores.

Ejemplo del crecimiento descontrolado: un componente
``Microondas`` al que el cliente C1 le pide *notificar* y
el cliente C2 le pide *sonar campana*. C1 ahora carga con
métodos que no usa; toda implementación de la interfaz
debe soportar ambas funcionalidades.

19.2 Solución
-------------

Diseñar **interfaces más pequeñas y específicas**, cada
una con un conjunto de métodos coherente. La interfaz
"no significa todos los métodos en una clase" — una clase
puede implementar varias interfaces específicas en lugar
de una única interfaz inflada.

Beneficios:

- **Desacoplamiento** — clientes no acoplados a métodos
  irrelevantes.
- **Simplicidad** — cada cliente trabaja con lo que
  necesita.
- **Mantenibilidad** — cambios localizados.
- **Reutilización** — interfaces pequeñas son más
  fáciles de reutilizar.

19.3 Aplicación a IACT
----------------------

- Separar ``IReporte`` (genera) de ``IExportable``
  (exporta) — un consumidor que solo necesita visualizar
  no carga con la lógica de export.
- Separar ``ISecurity`` (verificar permiso) de
  ``IAuditConsulta`` (consultar audit) — el cliente que
  evalúa permisos no carga con el contrato de
  consulta de auditoría.
- Separar ``IETLLectura`` (leer fuentes) de
  ``IETLEscritura`` (insertar en analytics) — el monitor
  ETL no necesita capacidad de escritura.
- En :doc:`diagramas-componentes` cada interfaz canónica
  (``ISecurity``, ``IAuditLog``, ``IReporte``,
  ``IAlerta``, etc.) se mantiene **estrecha**
  precisamente para cumplir ISP.

----

20. Principio de Inversión de Dependencias (DIP)
================================================

   *Los módulos de alto nivel no deben depender de los
   módulos de bajo nivel. Ambos deben depender de
   abstracciones. Las abstracciones no deben depender de
   detalles. Los detalles deben depender de abstracciones.*

20.1 Idea central
-----------------

Las dependencias se invierten respecto al flujo de
control: en vez de que un módulo de alto nivel use
directamente un módulo de bajo nivel concreto, ambos
**dependen de una abstracción** (interfaz, clase
abstracta).

Ejemplo clásico: un ``Controlador`` depende de un
``RelojDespertador`` concreto solo para acceder a su
alarma. Cualquier cambio en el reloj toca el
controlador (viola OCP) y el reloj acumula
responsabilidades (viola SRP). Solución: introducir
``IAlarm`` y hacer que **ambos** dependan de ella.

Diseño deficiente — dependencia directa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Mal diseno — dependencia directa concreta

   class Controlador {
     - reloj : RelojDespertador
     + iniciar()
   }

   class RelojDespertador {
     + horaActual()
     + sonarAlarma()
   }

   Controlador --> RelojDespertador
   note right of Controlador
     - Cambios en RelojDespertador
       afectan al Controlador.
     - Difícil sustituir por otra
       alarma (viola OCP).
     - Reloj acumula responsabilidades
       (viola SRP).
   end note
   @enduml

Diseño correcto — dependencia invertida sobre IAlarm
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Buen diseno — dependencia invertida via abstraccion

   interface IAlarm {
     + sonar()
   }

   class Controlador {
     - alarma : IAlarm
     + iniciar()
   }

   class RelojDespertador {
     + horaActual()
     + sonar()
   }

   class TemporizadorWeb {
     + sonar()
   }

   Controlador --> IAlarm : depende de
   IAlarm <|.. RelojDespertador
   IAlarm <|.. TemporizadorWeb
   note right of IAlarm
     Tanto Controlador como
     RelojDespertador dependen
     de la abstraccion IAlarm.
     Reemplazar el reloj por
     TemporizadorWeb no toca
     el Controlador (cumple OCP
     y mejora reutilizacion).
   end note
   @enduml

20.2 Beneficios
---------------

- **Desacoplamiento** entre niveles.
- **Flexibilidad** — cambiar la implementación concreta
  no toca a los consumidores.
- **Testabilidad** — sustituir dependencias por dobles
  de prueba se vuelve trivial.
- **Mantenibilidad** a largo plazo.

20.3 Aplicación a IACT
----------------------

- ``rpt_app`` no depende de ``MySQLClient``; depende de
  ``IDatosAnalytics``. La implementación concreta
  (``MySQLAdapter``) implementa la abstracción.
- ``auth_app`` no depende del cliente LDAP concreto;
  depende de un protocolo ``IDirectoryService`` con
  ``LDAPAdapter`` como detalle.
- ``alr_app`` no depende del bus concreto de
  notificación; depende de ``INotificacion`` con
  ``log_app`` como implementación (CNST_001).

DIP es la base de los patrones Adapter (§ 5 de
:doc:`patrones-diseno`) y Strategy (§ 9), y la condición
para hacer testable cada app Django sin levantar todo el
stack.

20.4 Los tres principios fundamentales — LSP, OCP, DIP
------------------------------------------------------

LSP, OCP y DIP están **estrechamente relacionados**:

- Violar **LSP** (§ 18) o **DIP** invariablemente
  resulta en violar **OCP** (§ 16).
- DIP requiere abstracciones; LSP garantiza que las
  implementaciones de esas abstracciones son
  intercambiables; OCP cosecha el beneficio de extender
  sin modificar.

Tener los tres en mente es la diferencia entre código OO
"que funciona" y código OO **flexible y mantenible**.

----

21. Síntomas de mal diseño y temas relacionados
===============================================

21.1 Siete síntomas canónicos
-----------------------------

Robert C. Martin enumera siete síntomas de un diseño OO
deficiente:

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Síntoma
   - Descripción
 * - **Rigidez**
   - Cambios en una parte del sistema disparan cascadas
     de cambios en otras. Síntoma de alto acoplamiento.
 * - **Fragilidad**
   - El sistema se rompe en lugares **inesperados** ante
     un cambio.
 * - **Inmovilidad**
   - Difícil reutilizar partes del código en otro
     contexto por el acoplamiento excesivo.
 * - **Viscosidad**
   - Es **fácil hacer las cosas mal** y difícil hacerlas
     bien — la "ruta correcta" exige más esfuerzo que
     la incorrecta.
 * - **Complejidad innecesaria**
   - Diseño de clases sobre-generalizado o demasiado
     complicado para el problema real (sobre-ingeniería).
 * - **Repetición innecesaria**
   - Copiar y pegar (viola DRY, ver § 13).
 * - **Opacidad**
   - Difícil de entender; el código no comunica su
     intención.

Cuando varios síntomas aparecen juntos, hay deuda técnica
real. Las causas suelen ser violación de **SRP, OCP, LSP
o DIP**.

21.2 Train wreck coding
-----------------------

El **código de desastre ferroviario** (*train wreck
coding*) es la cadena de llamadas
``cliente.getDireccion().getCiudad().getCondado()…`` —
caso particular de violación de la Ley de Demeter
(§ 11). Síntomas: difícil de entender, difícil de depurar,
falta de cohesión. Refactorizar siguiendo
**Tell, Don't Ask** (§ 11).

21.3 Naturaleza del cambio en software
--------------------------------------

   *Los sistemas de software cambian durante su tiempo
   de vida. Tanto los diseños mejores como los
   deficientes tienen que enfrentar los cambios; los
   buenos diseños son estables.*

El cambio es **inevitable**. La diferencia entre un buen
diseño y uno malo no es si soporta cambios — los dos los
soportan — sino **a qué costo** los soporta. Los buenos
diseños permiten cambios localizados, los malos exigen
modificaciones en cascada (§ 21.1 rigidez).

21.4 Diseño por contrato (DbC)
------------------------------

Bertrand Meyer formalizó el contrato entre clases con
tres elementos:

- **Pre-condiciones** — lo que el cliente debe
  garantizar antes de invocar.
- **Post-condiciones** — lo que el servicio promete
  después de ejecutar.
- **Invariantes** — lo que se mantiene cierto siempre.

LSP se apoya en DbC: una subclase es sustituible si
**no fortalece pre-condiciones**, **no debilita
post-condiciones** y **preserva invariantes** del padre
(ver § 18.1).

Aplicación IACT: ``EstadoAlerta`` (publicada / reconocida
/ cerrada) declara pre/post-condiciones por transición.
``aud_app`` declara la invariante "todo registro queda
en ``audit_log``" (CNST_025) — invariante que **ningún
subtipo** puede romper.

Comportamiento anunciado — Stack y eStack
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El **comportamiento anunciado** de un objeto se refiere a
los servicios públicos que la clase declara, junto con sus
pre y post-condiciones. Es el **contrato** que el cliente
puede invocar.

Ejemplo canónico — pila ``Stack`` con métodos ``push``,
``pop`` y ``top``, cada uno con su pre y post-condición:

- ``push(x)`` — pre: ninguna; post: ``top() == x``,
  ``size`` aumenta en 1.
- ``pop()`` — pre: ``size > 0``; post: ``size`` disminuye
  en 1; devuelve el elemento que era ``top``.
- ``top()`` — pre: ``size > 0``; post: devuelve el
  último ``push``-eado, no modifica la pila.

Una pila extendida ``eStack`` que herede de ``Stack``
puede **agregar** nuevos métodos (``contains``,
``snapshot``) y debe **mantener intacto** el
comportamiento anunciado de ``Stack`` — mismas pre y
post-condiciones. Si ``eStack`` cambia el efecto de
``pop()`` (e.g., no decrementa ``size``), rompe el
contrato y el polimorfismo deja de ser seguro.

Aplicación IACT
~~~~~~~~~~~~~~~

- ``ColaIngestaETL`` (base) y ``ColaIngestaPriorizada``
  (subtipo) — la subclase agrega criterios de
  priorización pero las pre/post-condiciones de
  ``encolar`` y ``desencolar`` se mantienen.
- ``EventoAuditoria`` (base) y subtipos
  (``AuditoriaAcceso``, ``AuditoriaCambio``) —
  todos respetan la invariante de inmutabilidad
  (CNST_025); ningún subtipo puede ofrecer ``borrar()``.
- ``Sesion`` y ``SesionDelegada`` — la subclase no puede
  prometer **menos** sobre la caducidad (CNST_002);
  cualquier subtipo que extienda la duración rompe el
  contrato.

LSP en Java
~~~~~~~~~~~

Java materializa LSP en al menos dos restricciones de la
sobrescritura:

1. Los métodos sobrescritos **no pueden lanzar nuevas
   excepciones** no relacionadas con las del padre
   (la firma ``throws`` no puede agregar excepciones
   *checked* nuevas).
2. El nivel de acceso del método sobrescrito **no puede
   ser más restrictivo** que el del padre (un método
   ``public`` no se puede sobrescribir como
   ``protected`` o ``private``).

En Python no hay esa garantía sintáctica, pero el espíritu
es el mismo — la responsabilidad recae en el desarrollador.

21.5 Herencia vs delegación
---------------------------

Regla operativa, complementaria a § 15 de
:doc:`relaciones-uml` (composición vs herencia):

- Si un objeto de ``B`` puede **usarse en lugar de** un
  objeto de ``A`` → usar **herencia**.
- Si un objeto de ``B`` puede **usar un** objeto de
  ``A`` → usar **delegación / composición**.

La delegación es a menudo preferible a la herencia
porque evita acoplamiento excesivo, rigidez y fragilidad.
La herencia es uno de los conceptos más abusados de OOP
(ver § 14 de :doc:`relaciones-uml` para la taxonomía
completa).

21.6 Aplicación de los principios — agilidad
--------------------------------------------

Los principios SOLID son herramientas de **diseño
iterativo**, no decretos:

- Aplicarlos **solo donde aplican** y donde se
  reconozcan los síntomas.
- Aplicarlos arbitrariamente produce **complejidad
  innecesaria** (§ 21.1).
- Son más relevantes durante el desarrollo **iterativo y
  la refactorización** (§ 15) que en el diseño inicial.
- A medida que los requisitos se aclaran, se vuelven
  más claras las fuerzas que impulsan cada principio.

YAGNI vs principios
~~~~~~~~~~~~~~~~~~~

Aplicar un principio "por si acaso" antes de tener un
síntoma viola **YAGNI** (ver § 12.1 de
:doc:`plan-documentacion-uc`) y produce abstracciones
innecesarias. La regla: **ver el síntoma, aplicar el
principio**. No al revés.

----

22. Software autoexplicativo y uso de comentarios
=================================================

El código debe ser **lo suficientemente claro y expresivo
por sí mismo**, minimizando la necesidad de comentarios
explicativos. Los comentarios deben ser un **complemento**
que enriquezca la comprensión, **no un sustituto** de un
buen diseño ni un parche para compensar código mal
estructurado.

22.1 Regla operativa
--------------------

Cuando aparezca la tentación de escribir un comentario,
primero responder:

- ¿Puedo expresar esta misma información mediante una
  **mejor estructura del código**?
- ¿Un **nombre más descriptivo** lo haría innecesario?
- ¿Una **mejor organización** del módulo lo elimina?

Si la respuesta es sí, refactorizar antes de comentar. El
comentario solo se justifica si **añade valor real** que
el código no puede expresar.

22.2 Dos riesgos significativos
-------------------------------

Los comentarios bien intencionados pueden volverse
problemáticos por dos vías:

- **Quedarse desactualizados** cuando el código cambia.
  Un comentario que ya no refleja la realidad del código
  es **más perjudicial** que la ausencia total de
  comentarios — guía al lector por caminos equivocados.
- **Ser superfluos** cuando se añaden por cumplir
  normativas (Javadoc obligatorio para todo) sin aportar
  valor. Esta práctica es contraproducente fuera del
  contexto de bibliotecas públicas con consumidores
  externos.

22.3 Comentarios con valor real
-------------------------------

Solo dos categorías justifican comentarios de forma
sistemática:

.. list-table::
 :widths: 22 38 40
 :header-rows: 1

 * - Tipo
   - Descripción
   - Ejemplo IACT
 * - **Legales**
   - Documentan aspectos jurídicos del código.
     Forman parte de la documentación formal.
   - Cabecera de copyright, licencia y clasificación
     interna en archivos de ``perm_app`` que
     materializan reglas SoD (CNST_030) regulables.
 * - **Aclarativos**
   - Explican conceptos que el código por sí solo no
     puede expresar — el **porqué**, no el qué.
   - Por qué la ventana ETL exige bloqueo exclusivo
     entre ``00:00`` y ``06:00`` (CNST_006/008); por
     qué un cálculo se redondea hacia abajo en
     reportes de abandono (BR_016).

Una buena heurística: si el comentario explica **el
qué**, probablemente sobra. Si explica **el porqué**,
puede valer la pena.

22.4 Violaciones del uso de comentarios
---------------------------------------

Antipatrones recurrentes en código y su solución:

.. list-table::
 :widths: 24 30 26 20
 :header-rows: 1

 * - Tipo
   - Descripción
   - Ejemplo
   - Solución
 * - **Redundantes**
   - Repiten lo que el código ya expresa.
   - ``int dayOfMonth; // the day of the month``
   - Nombres autoexplicativos; eliminar el
     comentario.
 * - **De sección**
   - Separadores visuales para "organizar" el
     código.
   - ``// === Actions ===``
   - Mejorar la estructura: clases y métodos con
     nombres claros eliminan la necesidad.
 * - **No mantenidos**
   - Información desactualizada o irrelevante.
   - ``// port is 7077`` cuando ya no aplica.
   - Eliminar; usar git history y ADRs
     (``.thyrox/context/decisions/``) para
     trazabilidad histórica.
 * - **Excesivos**
   - Información que debería estar en documentación
     externa.
   - Historiales de discusión de diseño en el
     archivo de código.
   - Mover a documentos del proyecto
     (``source/``, work packages, ADRs).
 * - **Confusos**
   - Requieren revisar otras partes del código para
     entenderlos.
   - Referencias a código externo sin contexto.
   - Proporcionar el contexto donde se necesita o
     mejorar la estructura.
 * - **Inexactos**
   - Información imprecisa o errónea sobre el
     funcionamiento.
   - Descripciones que ya no coinciden con el
     comportamiento.
   - Actualizar al comportamiento real o eliminar.
 * - **De atribución**
   - Duplican información del control de versiones.
   - ``// Added by Luis``
   - Confiar en ``git blame`` y ``git log``.
 * - **Código comentado**
   - Bloques deshabilitados que permanecen en el
     archivo.
   - ``// def vieja_implementacion(): ...``
   - Eliminar; git history (I-002 — git como única
     persistencia) recupera versiones anteriores.

22.5 Aplicación a IACT
----------------------

Reglas para este proyecto:

1. **Nombres del dominio antes que comentarios**. Una
   variable ``tasa_abandono`` no necesita ``# tasa de
   abandono``; una función ``verificar_sod(actor,
   funcion)`` no necesita ``# verifica SoD``. El
   vocabulario IACT (BR_*, CNST_*, UC_*) ya nombra
   con precisión.
2. **Comentarios solo cuando explican el porqué**, no
   el qué. Ejemplo válido: ``# CNST_031: rango limitado
   a 6 meses para evitar export gigantes``. Ejemplo
   inválido: ``# valida que sea menor a 6 meses``.
3. **Sin código comentado en el repositorio**. Si la
   versión anterior es valiosa, vive en git history.
4. **Sin atribución en comentarios**. ``git blame`` es
   la fuente de verdad.
5. **Discusiones de diseño en ADRs**, no en
   comentarios. ``.thyrox/context/decisions/`` y los
   work packages de
   ``.thyrox/context/work/`` son el lugar para
   conservar el porqué de decisiones complejas.
6. **Docstrings de servicios públicos sí son útiles**
   cuando documentan contratos (pre/post-condiciones,
   excepciones esperadas) — ver § 21.4 Diseño por
   Contrato.

Anti-patrones IACT específicos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- ``# TODO arreglar`` sin issue ni dueño →
  convertir en deuda técnica registrada en
  ``.thyrox/context/technical-debt.md`` o eliminar.
- ``# WORKAROUND: por bug de Apache`` sin
  referencia a un issue → vincular o documentar en
  ADR.
- Bloques Javadoc/docstring autogenerados con
  texto vacío (``"""TODO documentation"""``) →
  eliminar; añadir solo cuando haya contenido real.
- Comentarios que repiten una guideline ya capturada
  en ``.claude/rules/`` → redundancia con
  documentación viva.

22.6 Relación con otros principios del documento
------------------------------------------------

- **DRY** (§ 13) — comentarios redundantes son
  duplicación de información: el código y el
  comentario dicen lo mismo. DRY pide eliminarlos.
- **Naming claro** — la primera línea de defensa contra
  la necesidad de comentarios.
- **Cohesión / SRP** (§ 17) — clases con
  responsabilidad única no necesitan explicar "qué
  hacen"; el nombre lo dice.
- **Evidence-classification THYROX** — los claims
  importantes (los "porqué") deben quedar como ADR o
  análisis WP, no como comentarios sueltos.

----

23. Formato del código
======================

El **formateo de código** es un mecanismo esencial de
comunicación entre desarrolladores — trasciende
preferencias estéticas. Como enfatiza Robert C. Martin,
un equipo debe establecer y adherir a un **único estilo**
de formato. La estandarización no solo facilita la
comunicación visual: establece un **contrato social** en
el que las preferencias individuales se subordinan al
beneficio colectivo de un código consistente y uniforme.

23.1 Estructura y organización visual
-------------------------------------

La organización del código trasciende lo estético y se
convierte en una herramienta para comunicar la
**estructura lógica** y las **relaciones** entre
elementos. Cada decisión sobre el espaciado responde a un
propósito específico que potencia la claridad y facilita
el mantenimiento.

El código fuente refleja su jerarquía interna a través de
niveles progresivos:

- archivo
- clases / módulos
- métodos / funciones
- bloques anidados

La **indentación** es la guía visual de esa organización
y permite captar de un vistazo las relaciones
estructurales.

23.2 Manejo del espacio — horizontal y vertical
-----------------------------------------------

El espacio cumple una **función dual**:

Espacio horizontal
~~~~~~~~~~~~~~~~~~

Funciona como herramienta **semántica**: la proximidad
visual comunica la **fortaleza de las relaciones** entre
elementos.

- Indica precedencia de operadores
  (``a*b + c`` vs ``a * b + c``).
- Agrupa parámetros estrechamente relacionados.
- Separa cláusulas lógicas en una expresión.

Espacio vertical
~~~~~~~~~~~~~~~~

Establece la organización **macro** del código:

- **Líneas en blanco** demarcan grupos lógicos distintos.
- **Atributos al inicio de la clase**, antes que
  métodos.
- Las **funciones relacionadas** se mantienen próximas,
  con un orden que respeta la secuencia
  *llamante → llamada* (lectura top-down).
- Las funciones con **operaciones similares** se
  agrupan para mantener cohesión lógica.

23.3 Principios organizativos
-----------------------------

Gestión del código
~~~~~~~~~~~~~~~~~~

- **Variables cerca de su uso** — minimiza el ciclo de
  vida visible y facilita seguir el flujo de datos.
- **Funciones ordenadas por dependencias** — la
  secuencia refleja la lógica del programa: lo que se
  invoca cerca de lo que se llama.
- **Cohesión vertical** — agrupar lo que cambia junto
  (CCP a nivel de archivo; ver § 12 de
  :doc:`diagramas-componentes`).

Legibilidad
~~~~~~~~~~~

- **Longitud de línea limitada** estratégicamente —
  típicamente entre **40 y 80 caracteres** (algunos
  estilos toleran hasta 120). La restricción no es
  arbitraria: optimiza la capacidad cognitiva del
  lector y permite *side-by-side diffs* en pantallas
  estándar.

23.4 Prácticas incorrectas
--------------------------

Dos prácticas comprometen la integridad del código aun
cuando "parezcan" ordenadas:

- **Alinear tipos y variables en columnas con
  tabuladores**. Visualmente parece prolijo, pero
  introduce **fragilidad**: cualquier cambio de longitud
  rompe la alineación y obliga a re-formatear bloques
  enteros.
- **No respetar la indentación**, incluso en líneas
  cortas o "atajos" inline. Daña la consistencia visual
  y rompe la jerarquía establecida.

23.5 Aplicación a IACT
----------------------

Reglas concretas para este proyecto (alineadas con
``.claude/rules/`` y la convención del repositorio):

- **Python (Django apps)**: ``black`` con línea de 79-88
  caracteres; ``ruff`` para detección de violaciones.
  Sin alineación manual con tabuladores.
- **JavaScript/React**: ``prettier`` con configuración
  fijada en el repositorio.
- **RST (esta documentación)**: indentación con espacios
  consistente; no mezclar tabs y espacios en directivas
  ``.. uml::`` o ``.. code-block::``.
- **PlantUML embebido**: línea ≤ 80 caracteres;
  alineación de operadores ``-->`` ``..>`` por
  legibilidad sin recurrir a tabuladores manuales.
- **Importaciones Python ordenadas** (``isort``):
  estándar → terceros → locales, con línea en blanco
  entre grupos.
- **Atributos antes que métodos** en cada modelo Django
  o servicio.

Anti-patrones IACT específicos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Funciones de ``services.py`` ordenadas alfabéticamente
  en lugar de por dependencias — dificulta la lectura
  top-down. Reordenar.
- Líneas largas con encadenamientos del estilo train
  wreck (ver § 21.2): además de violar Demeter, suelen
  forzar líneas > 100 caracteres.
- Variables declaradas al inicio del método y usadas 50
  líneas después — dispersa el contexto y dificulta el
  seguimiento.
- Tabuladores para alinear ``=`` en bloques de
  asignación — fragilidad ante refactor.

23.6 Por qué este capítulo importa para IACT
--------------------------------------------

Esta documentación se mantendrá durante años. La
disciplina de formato:

- Reduce la **fricción cognitiva** entre quien escribió
  el código y quien debe mantenerlo (que pueden ser la
  misma persona meses después).
- Facilita **revisiones automáticas** (CI/CD, code
  review).
- Hace que las **diferencias en git** sean significativas
  en lugar de ruido de re-formato.
- Reduce la probabilidad de bugs por estructura visual
  engañosa (e.g., bloques que parecen anidados pero no
  lo están).

23.7 Relación con otros principios
----------------------------------

- **Software autoexplicativo** (§ 22) — el formato es la
  segunda capa de claridad después del nombramiento; un
  buen formato hace que el código autoexplicativo se
  lea como prosa.
- **DRY** (§ 13) — un estilo unificado evita la
  duplicación de "decisiones de formato" caso por caso.
- **SRP** (§ 17) — agrupar funciones por
  responsabilidad refuerza la cohesión vertical.
- **CCP** (§ 12 de :doc:`diagramas-componentes`) — la
  proximidad vertical de funciones que cambian juntas
  es CCP aplicado al archivo.

----

24. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-requirements-analysis`` (BABOK — RADD)
 * - **Origen del documento**
   - Adaptado de "GUÍA-OOP-PRINCIPIOS-CORE — Aplicados al
     dominio E-commerce" (cheat-sheet aplicado interno),
     reescrito en PlantUML **y reorientado al dominio real
     IACT** (call center IVR + analytics + RBAC + ETL).
 * - **Teoría OOP genérica**
   - :doc:`/base-cognitiva/_uml/uml-02-orientacion-objetos`
     (Schmuller Hora 2)
 * - **Metodología OOP del proyecto**
   - :doc:`/normativa/estandares/metodologia-oop-para-ucs`
 * - **Catálogo modular del dominio IACT**
   - :doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`
 * - **Modelo RBAC vigente**
   - :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
 * - **Plan de documentación**
   - :doc:`plan-documentacion-uc`
 * - **Plantilla canónica de UC**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **BRs aplicables citadas**
   - BR_012 (segmento único), BR_016 (tasa abandono),
     BR_017 (tiempo promedio espera), BR_018 (índice
     eficiencia).
 * - **CNSTs aplicables citadas**
   - CNST_001 (no email), CNST_002 (sesión única), CNST_008
     (filtrado por segmento), CNST_011 (throttling), CNST_017
     (SLA), CNST_019/020 (export async + throttling),
     CNST_025 (auditoría inmutable), CNST_026 (no PII),
     CNST_030 (SoD).
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
