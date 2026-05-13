.. meta::
 :artefacto: METODOLOGIA_DIAG_ESTADOS_IACT
 :tipo: Guia
 :dominio: requisitos
 :subdominio: _metodologia-aplicacion
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================================
Diagramas de estados — comportamiento temporal aplicado a IACT
==================================================================

.. note::

 Adapta la **Hora 8 de Schmuller** ("Diagramas de estados")
 al dominio real del proyecto IACT (call center IVR +
 analytics + RBAC + ETL).

 Diagramas en **PlantUML** (política del proyecto, no Mermaid).

 Para la teoría genérica ver
 :doc:`/base-cognitiva/_uml/uml-08-diagramas-estados`
 (Schmuller Hora 8).

----

1. ¿Cómo cambian los objetos?
=============================

Los diagramas de clases muestran la **estructura estática**.
Los diagramas de estados muestran el **comportamiento
dinámico**.

**Pregunta clave:** ¿qué estados tiene un objeto a lo largo de
su vida?

----

2. Definición y simbología
==========================

Un diagrama de estados captura:

- Los **estados** en que puede estar un objeto.
- Las **transiciones** entre estados.
- Los **eventos** que provocan cambios.
- Las **acciones** que ocurren durante los cambios.

2.1 Símbolos básicos
--------------------

Cuatro elementos canónicos: **punto inicial** (círculo
relleno), **estado** (rectángulo redondeado), **transición**
(flecha etiquetada) y **punto final** (diana).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Estado1
   Estado1 --> Estado2 : transición
   Estado2 --> [*]
   @enduml

2.2 Ejemplo simple — Sesion (UC_AUTH)
-------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Inactiva
   Inactiva --> Activa : login()
   Activa --> Inactiva : logout()
   Activa --> [*]
   @enduml

----

3. Estructura detallada del estado
==================================

3.1 Componentes
---------------

::

 Estado: <NOMBRE>
 ─────────────────
 variables_de_estado
 ─────────────────
 entry / accion_al_entrar()
 do    / accion_durante()
 exit  / accion_al_salir()

3.2 Actividades del estado
--------------------------

.. list-table::
 :widths: 20 30 50
 :header-rows: 1

 * - Actividad
   - Cuándo
   - Qué hace
 * - **entry**
   - Al **entrar** al estado
   - Inicializar (ej. arrancar timer)
 * - **do**
   - **Durante** el estado
   - Procesar continuamente (ej. consultar BD)
 * - **exit**
   - Al **salir** del estado
   - Finalizar / limpiar (ej. cerrar conexión,
     registrar AuditLog)

3.3 Ejemplo — EjecucionETL (UC_PIP)
-----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Programada

   state Programada {
     Programada : entry / agendar(scheduler)
     Programada : do / esperar_horario_carga()
   }

   state Cargando {
     Cargando : entry / abrirConexionIVR()
     Cargando : do / leerLlamadasIVR()
     Cargando : exit / cerrarConexionIVR()
   }

   state Validando {
     Validando : entry / consultarErrores()
     Validando : do / validarFilas()
     Validando : exit / generarReporte()
   }

   Programada --> Cargando : horario_carga()
   Cargando --> Validando : carga_completa()
   Validando --> [*] : sin_errores()
   Validando --> [*] : con_errores()
   @enduml

----

4. Sucesos, acciones y transiciones
===================================

4.1 Conceptos clave
-------------------

::

 SUCESO (evento):  algo que OCURRE
   - Operador clic en "Reconocer"
   - Llega trigger del scheduler
   - Se alcanza umbral de métrica
   - Expira tiempo (CNST_002, CNST_011)

 ACCIÓN:           operación que se EJECUTA
   - Registrar en AuditLog (CNST_025)
   - Notificar al buzón interno (CNST_001)
   - Incrementar contador de intentos
   - Actualizar segmento del usuario

 TRANSICIÓN:       cambio de un estado a otro
   Sintaxis: evento / acción
   Ejemplo: "permiso_aprobado / generar_menu_dinamico()"

4.2 Tipos de transiciones
-------------------------

**Transición desencadenada** (requiere evento):

::

 evento / acción
   - Siempre REQUIERE un suceso
   - Acción es OPCIONAL
   - Ejemplo: "alerta_disparada / notificar_buzon()"

**Transición no desencadenada** (automática):

::

 / acción   o   simplemente →
   - Ocurre automáticamente
   - Sin evento externo
   - Cuando el estado anterior finaliza
   - Ejemplo: "/ aplicar_segmento()" automático

**Transición con condición de seguridad**:

::

 evento [condición] / acción
   - Sucede sólo si la condición es verdadera
   - Ejemplo: "intento_login [intentos < 5] / validar()"
              (CNST_011 throttling)

4.3 Ejemplo — UC_AUTH_01 (Iniciar sesión)
-----------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Anonima

   Anonima --> Validando : intento_login(email, password) /\nverificar_credenciales()

   Validando --> Activa : [credenciales_ok && intentos < 5]\n/ generar_jwt() + registrar_auditoria()
   Validando --> Bloqueada : [intentos >= 5]\n/ bloquear_ip(CNST_011) + auditar()
   Validando --> Anonima : [credenciales_ko]\n/ incrementar_intentos() + auditar()

   Activa --> Anonima : logout() / invalidar_token() + auditar()
   Activa --> Anonima : timeout_15min(CNST_002) /\ninvalidar_sesion() + auditar()

   Bloqueada --> Anonima : tiempo_bloqueo_expira() / resetear_contador()

   Anonima --> [*]
   @enduml

----

5. Condiciones de seguridad
===========================

Una **condición de seguridad** es una expresión booleana que
DEBE cumplirse para que ocurra la transición.

::

 evento [condición] / acción

5.1 Ejemplo IACT — permiso temporal con vencimiento (UC_PERM_03)
----------------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Solicitado

   Solicitado --> Aprobado : aprobador_aprueba()\n[justificacion >= 20 chars]\n/ activar_permiso() + auditar()

   Solicitado --> Rechazado : aprobador_rechaza()\n/ notificar_solicitante()

   Aprobado --> Activo : / aplicar_a_usuario()

   Activo --> Vencido : timer [duracion >= 6_meses(CNST_031)]\n/ revocar_automaticamente() + auditar()

   Activo --> Revocado : aprobador_revoca()\n/ revocar_anticipadamente() + auditar()

   Vencido --> [*]
   Revocado --> [*]
   Rechazado --> [*]

   note right of Activo
     CNST_031 — vigencia
     máxima 6 meses (180 días).
     Sin auto-renovación; cada
     extensión requiere nueva
     solicitud.
   end note
   @enduml

----

6. Subestados (estados compuestos)
==================================

**Subestados:** estados dentro de otros estados.

**Tipos:**

- **Secuencial** — uno después de otro.
- **Concurrente** — al mismo tiempo.

6.1 Subestados secuenciales — EjecucionETL en estado "Procesando"
-----------------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Programada

   Programada --> Procesando : horario_carga()

   state Procesando {
     [*] --> ConectandoIVR
     ConectandoIVR --> LeyendoLlamadas : conexion_ok()
     LeyendoLlamadas --> ValidandoFilas : carga_completa()
     ValidandoFilas --> ActualizandoBD : validacion_ok()
     ActualizandoBD --> [*] : commit_exitoso()
   }

   Procesando --> Exitosa : / registrar_run_ok() + auditar()
   Procesando --> ConErrores : [error_detectado]\n/ registrar_error() + alertar()

   Exitosa --> [*]
   ConErrores --> [*]

   note right of Procesando
     Estado compuesto Procesando
     con 4 subestados secuenciales
     dentro de la ventana de
     carga CNST_008 (6-12 horas).
   end note
   @enduml

6.2 Subestados concurrentes — Alerta evaluadora
-----------------------------------------------

Una alerta puede estar evaluando umbrales y, **al mismo
tiempo**, gestionando suscriptores.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Configurada

   Configurada --> EnEvaluacion : umbral_definido()

   state EnEvaluacion {
     state "Region: Evaluación de umbral" as RegionUmbral {
       [*] --> EsperandoMuestra
       EsperandoMuestra --> Comparando : nueva_metrica()
       Comparando --> EsperandoMuestra : [valor < umbral]
       Comparando --> Disparada : [valor >= umbral]
     }
     ||
     state "Region: Gestión de suscriptores" as RegionSusc {
       [*] --> Listo
       Listo --> Notificando : disparar()
       Notificando --> Listo : entrega_buzon_ok(CNST_001)
     }
   }

   EnEvaluacion --> Reconocida : supervisor_reconoce(UC_ALR_03)\n/ auditar()
   Reconocida --> [*]
   @enduml

----

7. Estado histórico
===================

Un **estado histórico** recuerda en qué subestado estaba el
objeto cuando salió de un estado compuesto.

**Tipos:**

- **Superficial** (``H``) — recuerda sólo el subestado
  principal.
- **Profundo** (``H*``) — recuerda todos los niveles anidados.

7.1 Ejemplo IACT — supervisión ETL con pausa
--------------------------------------------

Si el AdminPipeline pausa la supervisión y luego reanuda, el
sistema vuelve al subestado donde estaba (no reinicia desde
``ConectandoIVR``).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Programada
   Programada --> Procesando : horario_carga()

   state Procesando {
     [*] --> ConectandoIVR
     ConectandoIVR --> LeyendoLlamadas
     LeyendoLlamadas --> ValidandoFilas
     ValidandoFilas --> ActualizandoBD
     state H <<history>>
   }

   Procesando --> Pausada : admin_pausa()
   Pausada --> H : admin_reanuda() /\nretomar_subestado_anterior()
   Procesando --> Exitosa : commit_exitoso()
   Exitosa --> [*]
   @enduml

----

8. Ejemplo completo — ciclo de vida de un Reporte programado
============================================================

UC_RPT_07 (Programar reporte) crea un objeto ``ReporteProgramado``
que pasa por varios estados a lo largo de su vida.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Programado

   state Programado {
     Programado : entry / registrar_en_scheduler()
     Programado : do / esperar_proxima_ejecucion()
     Programado : exit / liberar_slot()
   }

   Programado --> Ejecutando : trigger_scheduler()\n/ verificar_permiso(UC_PERM_07)

   state Ejecutando {
     Ejecutando : entry / aplicar_filtro_segmento(BR_012)
     Ejecutando : do / generar_reporte()
     Ejecutando : exit / registrar_run() + auditar(CNST_025)
   }

   Ejecutando --> Disponible : [generacion_ok]\n/ guardar_archivo()
   Ejecutando --> Fallido : [error_bd_analytics]\n/ registrar_error()
   Ejecutando --> Fallido : [throttling CNST_020 alcanzado]\n/ posponer()

   Disponible --> Notificado : / enviar_buzon_interno(CNST_001)
   Notificado --> Programado : [recurrencia_activa] / reagendar()
   Notificado --> [*] : [recurrencia_unica]

   Fallido --> Programado : [reintentos < 3]\n/ reagendar_con_delay()
   Fallido --> [*] : [reintentos >= 3]\n/ notificar_supervisor()

   note right of Ejecutando
     CNST_017 — SLA ≤ 10 s.
     CNST_008 — segmento siempre
       aplicado en SQL.
     CNST_020 — throttling diario
       por formato (CSV/Excel/PDF).
   end note
   @enduml

----

9. Objetos siempre activos (sin estado final)
=============================================

Algunos objetos del sistema **nunca se inactivan**, no tienen
estado final.

**Ejemplos en IACT:**

- ``SecRules`` — siempre verificando permisos
  (UC_PERM_07).
- ``Scheduler`` — siempre disparando ejecuciones ETL
  según calendario.
- ``EvaluadorAlertas`` — siempre comparando métricas con
  umbrales.
- ``AuditLogger`` — siempre registrando eventos
  (CNST_025).
- ``BuzonInterno`` — siempre listo para entregar mensajes
  (CNST_001).

9.1 Ejemplo — EvaluadorAlertas
------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Monitoreando

   Monitoreando : do / consultar_metricas_cada_minuto()

   Monitoreando --> AlertandoUmbral : [valor >= umbral]\n/ disparar_alerta()

   AlertandoUmbral : do / esperar_reconocimiento()

   AlertandoUmbral --> Monitoreando : supervisor_reconoce()\n/ auditar(ALERT_ACK)
   AlertandoUmbral --> AlertandoUmbral : timeout_30min /\nescalar_severidad()

   note right of Monitoreando
     EvaluadorAlertas NUNCA
     se inactiva. No hay
     transición a [*]. Ciclo
     perpetuo Monitoreando ↔
     AlertandoUmbral.
   end note
   @enduml

----

10. Metodología para crear un diagrama de estados
=================================================

**Paso 1 — identificar el objeto:**

::

 ¿Cuál es el objeto que voy a modelar?
   Sesion / EjecucionETL / Alerta /
   PermisoTemporal / ReporteProgramado /
   EventoAuditoria / etc.

**Paso 2 — listar todos los estados:**

::

 ¿Qué estados puede tener durante su vida?
   - Inicial
   - Intermedios
   - Finales (si aplica — algunos objetos
     son siempre activos)

**Paso 3 — definir transiciones:**

::

 Para cada par de estados:
   - ¿Qué evento provoca el cambio?
   - ¿Qué acción ocurre?
   - ¿Hay condición de seguridad
     (CNST_002 / CNST_011 / CNST_031)?

**Paso 4 — agregar detalles:**

::

 - Variables de estado
 - Actividades (entry / do / exit)
 - Auditoría obligatoria (CNST_025)
 - Subestados si la complejidad lo justifica

**Paso 5 — minimizar cruces y ordenar:**

::

 - Reorganizar posiciones (top-bottom o left-right)
 - Agrupar estados relacionados (composite)
 - Hacer el diagrama lo más legible posible

----

11. En el proyecto IACT — qué objetos requieren diagrama
========================================================

**Críticos (obligatorio):**

- ``Sesion`` (UC_AUTH) — Anonima → Activa → Bloqueada → ...
- ``EjecucionETL`` (UC_PIP) — Programada → Cargando →
  Validando → Exitosa / ConErrores / Reintentada.
- ``Alerta`` (UC_ALR) — Configurada → Evaluando → Disparada →
  Reconocida → Resuelta.
- ``PermisoTemporal`` (UC_PERM_03 / UC_PERM_04) — Solicitado
  → Aprobado → Activo → Vencido / Revocado (CNST_031).

**Importantes:**

- ``Usuario`` (UC_USR) — Pendiente → Activo → Bloqueado →
  Inactivo90Dias (BR_003) → Bajo (CNST_005).
- ``ReporteProgramado`` (UC_RPT_07 / UC_RPT_08) —
  Programado → Ejecutando → Disponible / Fallido.
- ``GrupoAsignado`` (UC_PERM_01) — Asignado → Activo →
  Revocado.

**Adicionales:**

Cualquier entidad que tenga ciclo de vida observable
(suscripción, vista guardada, etc.).

  Cada UC del catálogo que **modifica el estado** de una
  entidad observable debe incluir un diagrama de estados de
  ese objeto en su sección 5 per la plantilla
  :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`.

----

12. Catálogo consolidado de notaciones
======================================

Tabla índice del documento. Cada componente del
diagrama de estados con su sintaxis PlantUML,
sección donde se desarrolla y caso IACT.

.. list-table::
 :widths: 22 32 16 30
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Estado inicial
   - ``[*] --> ...``
   - § 2.1
   - Punto de entrada del ciclo de
     ``Sesion``.
 * - Estado final
   - ``... --> [*]``
   - § 2.1
   - Cierre de ``EjecucionETL``.
 * - Estado simple
   - ``state Activa``
   - § 3
   - ``Sesion`` activa.
 * - Estado con entry/do/exit
   - ``X : entry / accion``
   - § 3.2
   - ``EjecucionETL`` con acciones
     por compartimento.
 * - Transición simple
   - ``A --> B : evento``
   - § 4.2
   - ``Sesion``: activa → caducada.
 * - Self-transition
   - ``A --> A : evento``
   - § 12.4
   - ``Procesando`` itera lote sin
     cambiar de estado.
 * - Junction point
   - ``state j <<choice>>``
     (convergencia)
   - § 12.4
   - Tres caminos confluyen al
     estado ``Procesando``.
 * - Choice point
   - ``state c <<choice>>``
     (divergencia con guardas)
   - § 12.4
   - Decidir entre ``Reconocida``
     o ``Escalada``.
 * - Estado compuesto
   - ``state X { ... }``
   - § 6
   - ``Procesando`` con subestados
     ETL.
 * - Shallow history
   - ``state H <<history>>``
   - § 7
   - Pausa que vuelve al subestado
     más reciente.
 * - Deep history
   - ``state H <<historyDeep>>``
   - § 12.5
   - Reanudar ETL en subestado
     más profundo.
 * - Submachine state
   - Estado compuesto +
     nota referencia
   - § 12.6
   - Sub-diagrama de
     ``EjecucionETL``.
 * - Flow final (anormal)
   - Estado etiquetado
     ``state X #FFAAAA``
   - § 12.2
   - Abort de ETL por error
     catastrófico.
 * - Guarda en transición
   - ``A --> B : evento [cond]``
   - § 4.1
   - ``[credenciales válidas]``.

----

12.1 Notaciones complementarias
-------------------------------

Componentes que el catálogo UML estándar incluye
y que el cuerpo del documento aún no detallaba:
flow final, junction point, choice point, deep
history y submachine state.

12.2 Flow final
~~~~~~~~~~~~~~~

Estado de **terminación anormal** — distinto del
estado final regular. Indica que la rama del
ciclo se aborta por una condición excepcional.
Otras ramas pueden continuar.

PlantUML lo expresa con un estado coloreado
distintivamente:

.. code-block:: text

   state "AbortadoEtl" as ABT #FFAAAA
   ABT : entry / registrar abort en audit_log

En IACT aparece en ``EjecucionETL`` cuando un
error catastrófico fuerza el abort. El sistema y
la próxima ventana ETL siguen.

Diferencia con estado final regular:

- Estado final ``[*]`` — terminación esperada.
- Flow final — terminación **no esperada**;
  candidato a alerta o investigación.

12.3 Junction point
~~~~~~~~~~~~~~~~~~~

Pseudo-estado donde **convergen** varias
transiciones a un punto único antes de continuar
al siguiente estado. Útil cuando varias rutas
distintas terminan en el mismo destino sin
sincronización.

.. code-block:: text

   state j <<choice>>
   A --> j
   B --> j
   C --> j
   j --> Destino

12.4 Choice point y self-transition
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pseudo-estado de **decisión** que divide una
transición de entrada en varias salidas según
guardas:

.. code-block:: text

   state c <<choice>>
   Origen --> c
   c --> Caso1 : [cond1]
   c --> Caso2 : [cond2]
   c --> Caso3 : [else]

Junction **converge**, choice **diverge** —
misma sintaxis ``<<choice>>``, semántica opuesta
según las flechas.

**Self-transition** es la flecha que sale y
vuelve al mismo estado:

.. code-block:: text

   Procesando --> Procesando : siguiente lote

12.5 Shallow vs deep history
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Shallow history** (``H``) — al volver al
  estado compuesto, retoma el subestado más
  reciente del **mismo nivel jerárquico**.
- **Deep history** (``H*``) — retoma el
  subestado **más profundo** que estaba activo,
  incluso varios niveles abajo.

.. code-block:: text

   state Procesando {
     state H <<history>>
     state H_deep <<historyDeep>>
   }

En IACT aparece en flujos de ETL pausables: si
el supervisor pausa ``EjecucionETL`` en un
subestado anidado y luego reanuda,
``historyDeep`` lleva al subestado exacto donde
quedó.

12.6 Submachine state
~~~~~~~~~~~~~~~~~~~~~

Un estado que **referencia otro diagrama de
estados** completo, modelado en su propio
documento. Permite descomponer máquinas
complejas en sub-máquinas.

.. code-block:: text

   state Procesando {
     ' Detalles en sub-diagrama
   }
   note right of Procesando
     Sub-maquina: ver
     diagramas-estados § 6.1
   end note

----

13. Galería de ejemplos canónicos IACT
======================================

Mini-diagramas reutilizables, vocabulario IACT
real. Copiar y adaptar al UC objetivo.

13.1 Ciclo simple — Sesion
--------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Activa : login (CNST_002)
   Activa --> Caducada : timeout
   Activa --> Cerrada : logout
   Caducada --> [*]
   Cerrada --> [*]
   @enduml

13.2 Estado con entry/do/exit
-----------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state Procesando {
     Procesando : entry / inicializar contador
     Procesando : do / leer y agregar lote
     Procesando : exit / consolidar batch
   }

   [*] --> Procesando
   Procesando --> [*]
   @enduml

13.3 Self-transition
--------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state Procesando

   Procesando --> Procesando : siguiente lote
   @enduml

13.4 Junction point
-------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state j <<choice>>

   Inicializada --> j
   PreCargada --> j
   Reanudada --> j
   j --> Procesando : empezar batch
   @enduml

13.5 Choice point con guardas
-----------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state c <<choice>>

   Publicada --> c : evaluacion completa
   c --> Reconocida : [auto-reconocible]
   c --> Escalada : [umbral critico]
   c --> Pendiente : [else]
   @enduml

13.6 Estado compuesto con subestados
------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state EjecucionETL {
     [*] --> Inicializada
     Inicializada --> Cargando : start
     Cargando --> Validando : datos cargados
     Validando --> Completada : ok
     Completada --> [*]
   }

   [*] --> EjecucionETL
   EjecucionETL --> [*]
   @enduml

13.7 Shallow history
--------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state Procesando {
     state H <<history>>
     [*] --> H

     state Cargando
     state Validando
     state Insertando

     Cargando --> Validando : ok
     Validando --> Insertando : valido
   }

   Procesando --> Pausada : pausar
   Pausada --> Procesando : reanudar
   @enduml

13.8 Deep history
-----------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   state Procesando {
     state H_deep <<historyDeep>>
     [*] --> H_deep

     state Cargando {
       [*] --> LeyendoLote
       LeyendoLote --> Transformando : leido
       Transformando --> Insertando : transformado
     }
   }

   Procesando --> Pausada : pausar
   Pausada --> Procesando : reanudar (deep)
   @enduml

13.9 Flow final — abort anormal
-------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Inicializada

   Inicializada --> Procesando : start
   Procesando --> Completada : ok

   state "AbortadaPorError" as ABT #FFAAAA
   Procesando --> ABT : error catastrofico
   ABT : entry / registrar en audit_log
   ABT --> [*]
   @enduml

13.10 Submachine state
----------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   [*] --> Inicializada

   state Procesando {
     ' Detalles modelados en sub-diagrama
   }

   note right of Procesando
     Sub-maquina:
     ver diagramas-estados § 6.1
   end note

   Inicializada --> Procesando : start
   Procesando --> Completada : ok
   Completada --> [*]
   @enduml

13.11 Plantilla — ciclo de vida de un objeto IACT
-------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Ciclo de vida — <Objeto IACT>

   [*] --> EstadoInicial : crear

   EstadoInicial : entry / inicializar
   EstadoInicial : do / esperar evento

   state c <<choice>>

   EstadoInicial --> c : evento_decision

   c --> EstadoCasoA : [cond_a]
   c --> EstadoCasoB : [cond_b]
   c --> [*] : [else]

   EstadoCasoA --> Final : completar
   EstadoCasoB --> Final : completar

   state "AbortadoFlowFinal" as ABT #FFAAAA
   EstadoInicial --> ABT : error
   EstadoCasoA --> ABT : error
   EstadoCasoB --> ABT : error
   ABT : entry / registrar abort en audit_log
   ABT --> [*]

   Final --> [*]
   @enduml

13.12 Cómo usar la galería
--------------------------

1. Localizar el componente en § 12.
2. Copiar el snippet de §§ 13.1-13.10 o usar la
   plantilla (§ 13.11).
3. Adaptar nombres de estados, eventos, guardas
   y acciones al objeto del dominio.
4. Anclar las acciones a CNST/BR relevantes.
5. Integrar al documento del UC o al modelado
   del cluster.

Mantenimiento: al introducir un componente
nuevo en § 12, agregar su mini-diagrama en § 13.
Mantener cada snippet ≤ 6-8 estados.

----

14. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skills aplicadas**
   - ``rm-specification`` (modelado del comportamiento del
     objeto), ``rm-analysis`` (verificar consistencia de
     transiciones)
 * - **Origen del documento**
   - Reescrito de "GUÍA-DIAGRAMAS-ESTADOS-COMPORTAMIENTO-
     TEMPORAL" (Hora 8 de Schmuller, cheat-sheet aplicado
     interno con dominio ecommerce), reorientado al dominio
     real IACT.
 * - **Lección teórica**
   - :doc:`/base-cognitiva/_uml/uml-08-diagramas-estados`
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
     :doc:`casos-uso-diagramas`
 * - **Catálogo modular del dominio**
   - :doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`
 * - **Restricciones citadas**
   - CNST_001 (no email — sólo buzón interno),
     CNST_002 (sesión única + timeout 15 min),
     CNST_005 (bajas lógicas),
     CNST_008 (ventana ETL 6-12h),
     CNST_011 (throttling 5 intentos / 5 min),
     CNST_017 (SLA ≤ 10 s),
     CNST_020 (throttling export diario),
     CNST_025 (auditoría inmutable),
     CNST_031 (permisos temporales ≤ 6 meses),
     BR_003 (90 días sin login → desactivar),
     BR_012 (segmento único).
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
