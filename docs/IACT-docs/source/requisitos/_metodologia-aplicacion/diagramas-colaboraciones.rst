.. meta::
 :artefacto: METODOLOGIA_DIAG_COLABORACIONES_IACT
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
Diagramas de colaboraciones — contexto espacial aplicado a IACT
==================================================================

.. note::

 Adapta la **Hora 10 de Schmuller** ("Diagramas de
 colaboraciones") al dominio real del proyecto IACT (call
 center IVR + analytics + RBAC + ETL).

 Diagramas en **PlantUML** (política del proyecto, no Mermaid,
 no ASCII art).

 Para la teoría genérica ver
 :doc:`/base-cognitiva/_uml/uml-10-diagramas-colaboraciones`.

----

1. Secuencias vs colaboraciones — diferencias clave
===================================================

.. list-table::
 :widths: 35 32 33
 :header-rows: 1

 * - Aspecto
   - Diagrama de **secuencias**
   - Diagrama de **colaboraciones**
 * - Organización
   - Tiempo
   - Espacio
 * - Enfoque
   - Cuándo
   - Dónde y cómo
 * - Eje
   - Vertical (arriba → abajo)
   - Relaciones entre objetos
 * - Mejor para
   - Flujo temporal
   - Contexto general / arquitectura
 * - Pregunta
   - ¿En qué orden?
   - ¿Qué estructura?

Ambos diagramas representan **exactamente la misma
información**. Se puede convertir uno en el otro sin
perder nada — sólo cambia la presentación.

----

2. Componentes básicos
======================

Cuatro elementos canónicos: **objetos** (rectángulos con
nombre), **enlaces** (líneas que conectan objetos),
**mensajes numerados** sobre los enlaces, y **flechas** que
indican dirección.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object Objeto1
   object Objeto2
   object Objeto3

   Objeto1 -> Objeto2 : "1: mensaje()"
   Objeto2 -> Objeto3 : "2: mensaje()"
   Objeto3 -> Objeto1 : "3: respuesta()"
   @enduml

2.1 Sintaxis del mensaje
------------------------

::

 [condición] número [anidación] : operación(parámetros)

Ejemplos IACT:

::

 1: verificar_permiso(usuario, funcion)
 [usuario_activo] 2: aplicar_filtro_segmento(BR_012)
 2.1: validar_segmento_no_nulo()
 2.2: aplicar_SQL_WHERE(segmento)
 [* funcion_implicada en macro_funcion]
   3: verificar_permiso(usuario, sub_funcion)
 resultado := evaluar_umbral(metrica, umbral)

----

3. Numeración y anidación
=========================

3.1 Secuencia lineal
--------------------

::

 1: verificar_permiso()
 2: aplicar_segmento()
 3: ejecutar_query()
 4: registrar_auditoria()

3.2 Anidación (submensajes)
---------------------------

::

 2: aplicar_segmento()
   2.1: obtener_segmento_usuario()
   2.2: construir_clausula_where()
   2.3: validar_segmento_existe()
     2.3.1: consultar_tabla_segmentos()
     2.3.2: cachear_resultado()

  Significado: ``2.X`` son consecuencias directas de ``2``;
  ``2.3.X`` son consecuencias de ``2.3``.

3.3 Anidación en IACT — UC_RPT_04 (Exportar reporte)
----------------------------------------------------

::

 1: solicitar_export(tipo, filtros)
   1.1: verificar_permiso(export_<formato>)
   1.2: validar_throttling(CNST_020)
   1.3: estimar_filas()
 2: aplicar_filtros(filtros, segmento_usuario)
   2.1: aplicar_segmento(BR_012, CNST_008)
   2.2: validar_filtros_consistentes()
 3: [filas <= 10k] generar_archivo_sincrono()
   3.1: ejecutar_query()
   3.2: serializar(formato)
 3': [filas > 10k] encolar_export_async(CNST_019)
   3'.1: registrar_job_en_cola()
   3'.2: notificar_buzon_cuando_listo(CNST_001)
 4: registrar_en_auditoria(CNST_025)

----

4. Condiciones
==============

::

 [condición] número: mensaje()

Ejemplos IACT:

::

 [is_active && segmento != null] 1: ejecutar_query()
 [throttling no alcanzado] 2: procesar_export()
 [intentos < 5] 3: validar_credenciales()  (CNST_011)
 [permiso_temporal_vigente] 4: aplicar_funcion()  (CNST_031)

4.1 Ejemplo IACT — UC_PERM_07 (Verificar permiso)
-------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Backend
   object ":SecRules"           as SR
   object ":CatalogoFunciones"  as Cat
   object ":Usuario_grupos"     as UG
   object ":PermisosTemporales" as PT
   object ":AuditoriaPermiso"   as AP

   Backend -> SR : "1: verificar_permiso(\n   user, fn)"
   SR -> Cat     : "1.1: existe_funcion(fn)?"
   SR -> UG      : "1.2: [funcion_existe]\n   buscar_via_grupo(\n   user, fn)"
   SR -> PT      : "1.3: [no_via_grupo]\n   buscar_excepcional(\n   user, fn,\n   vigente_hoy)"
   SR -> AP      : "1.4: [permiso_resuelto]\n   registrar(\n   PERMISO_OK)"
   SR -> AP      : "1.5: [no_resuelto]\n   registrar(\n   PERMISO_DENEGADO)"
   SR -> Backend : "2: bool resultado"
   @enduml

----

5. Ciclos (mientras)
====================

::

 [* condición] número: mensaje()

Ejemplos IACT:

::

 [* funcion_implicada en macro_funcion]
   1: verificar_permiso(user, sub_funcion)

 [* alerta en alertas_activas && sin_reconocer]
   2: notificar_via_buzon(supervisor)

 [* error en errores_etl]
   3: clasificar_error_para_reintento()

5.1 Ejemplo IACT — UC_RPT_07 (Procesamiento de reportes programados)
--------------------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Scheduler"     as Sch
   object ":ReporteProg"   as RP
   object ":SecRules"      as SR
   object ":BDAnalytics"   as BD
   object ":BuzonInterno"  as BI

   Sch -> RP : "1: [* reporte en\n   programados_pendientes]\n   ejecutar(reporte)"
   RP -> SR  : "1.1: verificar_permiso_owner()"
   RP -> BD  : "1.2: aplicar_segmento(\n   owner, CNST_008)"
   RP -> BD  : "1.3: ejecutar_query()"
   RP -> BI  : "1.4: notificar(\n   owner, archivo_listo)"
   @enduml

----

6. Cambios de estado durante la colaboración
============================================

Cuando un objeto cambia de estado durante la colaboración, se
representa con **dos rectángulos del mismo objeto** unidos por
una línea discontinua etiquetada con el estereotipo
``<<se_transforma_en>>``.

6.1 Ejemplo IACT — Sesion en UC_AUTH_01
---------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object "sesion : Sesion\n[Anonima]"  as S1
   object ":AuthService"                as A
   object ":SessionStore"               as SS
   object "sesion : Sesion\n[Activa]"   as S2

   actor Usuario

   Usuario -> A : "1: login(email, pass)"
   A -> SS      : "2: validar_credenciales()"
   SS -> A      : "3: ok + segmento"
   A -> S1      : "4: invalidar_anonima()"
   A -> S2      : "5: crear_activa(token)"
   S1 ..> S2    : "<<se_transforma_en>>"
   @enduml

----

7. Valores de retorno
=====================

::

 variable_resultado := operación(parámetros)

Ejemplos IACT:

::

 cuenta_filas := count_query(filtros)
 token := generar_jwt(user_id, segmento)
 vigente := evaluar_permiso_temporal(perm_id, hoy)
 metricas := calcular_kpis(periodo, segmento)

7.1 Ejemplo IACT — cálculo de métrica BR_016 (tasa de abandono)
---------------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Reporte"      as R
   object ":Calculadora"  as C
   object ":BDAnalytics"  as BD

   R -> C  : "1: tasaAbandono :=\n   calcular_tasa_abandono(\n   periodo, segmento)"
   C -> BD : "1.1: total :=\n   contar_llamadas(\n   periodo, segmento)"
   C -> BD : "1.2: abandonadas :=\n   contar_llamadas(\n   periodo, segmento,\n   resultado=ABANDONADA)"
   C -> R  : "1.3: tasaAbandono =\n   abandonadas / total\n   × 100"

   note right of C
     BR_016 — fórmula:
       (abandonadas / total) × 100
     Filtrado siempre por
     segmento del usuario
     (CNST_008, BR_012).
   end note
   @enduml

----

8. Objetos activos vs pasivos
=============================

**Objeto pasivo** — sólo responde a mensajes; sin hilo propio.
Ejemplo IACT: ``Usuario``, ``Reporte``, ``EventoAuditoria``.

**Objeto activo** — inicia y controla flujo; con hilo propio
(*thread*). Borde grueso. Ejemplo IACT: ``Backend``,
``Scheduler``, ``EvaluadorAlertas``, ``SupervisorETL``.

8.1 Ejemplo IACT — concurrencia entre objetos activos
-----------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing
   object ":Backend" as B <<active>>
   object ":Scheduler" as Sch <<active>>
   object ":EvaluadorAlertas" as EA <<active>>
   object ":SupervisorETL" as Sup <<active>>
   object ":BDAnalytics"                  as BD
   object ":AuditLog"                     as AL
   object ":BuzonInterno"                 as BI

   B   -> BD  : "consultar"
   Sch -> Sup : "disparar_carga()"
   Sup -> BD  : "INSERT filas"
   EA  -> BD  : "evaluar_metrica()"
   EA  -> BI  : "notificar_alerta()"
   B   -> AL  : "registrar()"
   Sup -> AL  : "registrar()"
   EA  -> AL  : "registrar()"

   note right of EA
     Tres objetos activos en
     paralelo: Backend (atendiendo
     requests), Scheduler+
     SupervisorETL (cargando datos),
     EvaluadorAlertas (monitoreando
     umbrales). Todos escriben en
     BDAnalytics y AuditLog
     (objetos pasivos).
   end note
   @enduml

----

9. Sincronización
=================

Un mensaje sólo se envía **después de que otros se completen**.

9.1 Sintaxis
------------

::

 número.letra / operación()

Donde:

- ``número`` = mensajes que deben completarse antes.
- ``.letra`` = submensaje de sincronización.
- ``,`` separa los precondicionantes.

Ejemplo:

::

 2.1, 2.2 / colocar_aviso()
   significa: esperar a que 2.1 Y 2.2
              terminen, luego ejecutar.

9.2 Ejemplo IACT — UC_ALR_03 (Reconocer alerta crítica con escalado)
--------------------------------------------------------------------

Cuando se reconoce una alerta crítica, antes de cerrar el
incidente debe haberse:

1. Registrado el ack en AuditLog (CNST_025).
2. Notificado a todos los suscriptores (CNST_001).

Sólo después se publica el cierre en el panel general.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Supervisor
   object ":Alerta"        as A
   object ":SecRules"      as SR
   object ":AuditLog"      as AL
   object ":BuzonInterno"  as BI
   object ":Suscriptores"  as S
   object ":PanelGeneral"  as PG

   Supervisor -> SR : "1: verificar_permiso(\n   ack_alert)"
   Supervisor -> A  : "2: reconocer()"
   A          -> AL : "2.1: registrar(\n   ALERT_ACK)"
   A          -> BI : "2.2: notificar(\n   suscriptores)"
   BI         -> S  : "2.2.1: entregar(buzon)"

   A          -> PG : "2.1, 2.2 /\n   3: publicar_cierre()"

   note right of A
     El mensaje 3 (publicar cierre)
     espera a que se completen 2.1
     (auditoría) Y 2.2 (notificación
     vía buzón interno) antes de
     ejecutar.
   end note
   @enduml

----

10. Ejemplo completo IACT — UC_RPT_04 (Exportar reporte) en contexto espacial
=============================================================================

Combina todo: numeración, condiciones, anidación, ciclos,
sincronización, objetos activos / pasivos.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing
   actor Supervisor

   object ":Backend" as B <<active>>
   object ":SecRules"               as SR
   object ":Reporte"                as R
   object ":BDAnalytics"            as BD
   object ":ExportQueue" as EQ <<active>>
   object ":Archivo"                as F
   object ":BuzonInterno"           as BI
   object ":AuditLog"               as AL

   Supervisor -> B  : "1: solicitar_export(\n   reporte_id, fmt)"
   B          -> SR : "1.1: verificar_permiso(\n   export_<fmt>)"
   B          -> SR : "1.2: validar_throttling(\n   CNST_020)"

   B  -> R   : "[autorizado] 2: aplicar_filtros(\n   filtros, segmento)"
   R  -> BD  : "2.1: aplicar_segmento(\n   BR_012, CNST_008)"
   R  -> BD  : "2.2: estimar_filas := count()"

   B  -> F   : "[filas <= 10k] 3a: <<create>>\n   generar_sincrono(fmt)"
   F  -> BD  : "3a.1: ejecutar_query()"
   F  -> B   : "3a.2: archivo_listo"

   B  -> EQ  : "[filas > 10k] 3b: encolar(\n   reporte_id, fmt, supervisor_id)"
   EQ -> EQ  : "3b.1: [* job en cola]\n   procesar(job)"
   EQ -> BI  : "3b.2: entregar(supervisor,\n   archivo_listo)"
   BI -> Supervisor : "3b.3: aviso buzón\n   (CNST_001)"

   B  -> AL  : "1.1, 2 / 4: registrar(\n   EXPORT_ACTION,\n   resultado)"
   B  -> Supervisor : "5: respuesta(url | aviso)"

   note right of EQ
     ExportQueue es objeto activo:
     procesa jobs en background,
     escribe en BuzonInterno cuando
     termina (CNST_019). Borde grueso.
   end note

   note right of AL
     Sincronización: el registro 4
     en AuditLog espera a que se
     completen 1.1 (verificación)
     Y 2 (filtros aplicados).
   end note
   @enduml

----

11. Comparación — secuencias vs colaboraciones
==============================================

11.1 Vista temporal — secuencias
--------------------------------

  *Pregunta:* ¿en qué orden suceden?
  *Respuesta:* arriba a abajo.

::

 Operador → Frontend → Backend → SecRules → BD → AuditLog
   ↓
   Paso 1: clic
   Paso 2: GET /dashboard
   Paso 3: verificar permiso
   Paso 4: query con segmento
   Paso 5: registrar auditoría

11.2 Vista espacial — colaboraciones
------------------------------------

  *Pregunta:* ¿cómo se conectan?
  *Respuesta:* estructura de relaciones.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   actor Operador
   object ":Frontend"   as F
   object ":Backend"    as B
   object ":SecRules"   as SR
   object ":BDAnalytics" as BD
   object ":AuditLog"   as AL

   Operador -> F  : "1"
   F        -> B  : "2"
   B        -> SR : "3"
   B        -> BD : "4"
   B        -> AL : "5"
   @enduml

11.3 Cuándo usar cada una
-------------------------

.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Diagrama de **secuencias** cuando…
   - Diagrama de **colaboraciones** cuando…
 * - El **tiempo** es crítico
   - El **contexto / arquitectura** es importante
 * - Flujo secuencial complejo (UC_RPT_04 con 2
     ramas async)
   - Mostrar relaciones espaciales (quién habla con
     quién)
 * - Casos de uso con muchos pasos sincrónicos
   - Sistemas con muchos objetos activos
     concurrentes
 * - Comunicar *qué sucede cuándo*
   - Comunicar *cómo se conectan*

Recomendación: para los UCs **críticos** (UC_AUTH_01,
UC_RPT_04, UC_PIP_04, UC_PERM_07), usar **ambos** —
perspectivas complementarias para mejor comprensión.

----

12. En el proyecto IACT — qué UCs requieren colaboraciones
==========================================================

**Recomendado para UCs con múltiples objetos activos
concurrentes:**

- ``UC_PIP_04`` — Solicitar reintento ETL (Scheduler +
  SupervisorETL + AuditLog en paralelo).
- ``UC_RPT_04`` — Exportar reporte (Backend + ExportQueue +
  BuzonInterno).
- ``UC_ALR_03`` — Reconocer alerta crítica con
  sincronización (auditoría + notificación antes de cerrar).
- ``UC_PERM_07`` — Verificar permiso (recursivo sobre
  catálogo de funciones implicadas).

**Recomendado para diagramas arquitectónicos generales:**

- Vista global del sistema IACT mostrando todos los objetos
  activos (Backend, Scheduler, SupervisorETL,
  EvaluadorAlertas) interactuando con BDAnalytics, IVR,
  AuditLog, BuzonInterno (objetos pasivos).

  Cada UC puede incluir su diagrama de colaboraciones en la
  sección 7-bis del archivo
  ``casos-uso/<modulo>/uc-<mod>-<NN>-<desc>.rst``,
  complementando el diagrama de secuencias.

----

13. Catálogo consolidado de notaciones
======================================

Tabla índice del documento — cada componente con
sintaxis PlantUML, sección y caso IACT.

.. list-table::
 :widths: 24 30 16 30
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Objeto sin lifeline
   - ``object ":Clase" as O``
   - § 2
   - ``:Sesion``, ``:Alerta``.
 * - Enlace bidireccional
   - ``A -- B``
   - § 2
   - ``Supervisor`` ↔ ``Browser``.
 * - Self-link
   - ``A -- A`` con auto-mensaje
     numerado
   - § 9
   - ``EvaluadorAlertas`` revisando
     umbrales.
 * - Forward síncrono
   - ``A -> B : "1: op()"``
   - § 3
   - ``Browser`` → ``auth_app``.
 * - Forward asíncrono
   - ``A -> B : "1: op()"``
   - § 3
   - ``rpt_app`` → ``audit_log``.
 * - Reverse stimulus
   - ``B --> A : "2: ack"``
   - § 3
   - ``LDAP`` → ``auth_app``
     respuesta.
 * - Numeración anidada
   - Etiqueta ``"N.M: op()"``
   - § 4
   - Sub-pasos en una operación.
 * - Mensaje con guarda
   - Etiqueta
     ``"N: [cond] op()"``
   - § 5
   - Condicional inline.
 * - Mensaje en bucle
   - Etiqueta
     ``"N: *[i:1..n] op()"``
   - § 6
   - Iteración sobre lote.
 * - Cambio de estado
   - Nota anclada al objeto
   - § 7
   - ``Sesion`` activa → caducada.
 * - Valor de retorno
   - Etiqueta
     ``"N: r := op()"``
   - § 8
   - Resultado capturado.
 * - Sincronización
   - Mensajes con prefijo
     compartido
   - § 9
   - Audit + notify completos
     antes de cerrar.

----

14. Galería de ejemplos canónicos IACT
======================================

Mini-diagramas reutilizables, vocabulario IACT
real. Copiar y adaptar al UC nuevo.

14.1 Objetos y enlace bidireccional
-----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Supervisor" as S
   object ":Browser" as B

   S -- B : opera
   @enduml

14.2 Self-link
--------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":EvaluadorAlertas" as E

   E -- E : "1: revisar_umbrales()"
   @enduml

14.3 Forward síncrono numerado
------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Browser" as B
   object ":auth_app" as Auth

   B -> Auth : "1: POST /login"
   @enduml

14.4 Forward asíncrono
----------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":rpt_app" as Rpt
   object ":audit_log" as Audit

   Rpt -> Audit : "1: registrar_evento()"
   @enduml

14.5 Reverse stimulus (request + respuesta)
-------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":auth_app" as Auth
   object ":ldap-corporativo" as LDAP

   Auth -> LDAP : "1: authenticate(user, pass)"
   LDAP --> Auth : "2: ok + atributos"
   @enduml

14.6 Numeración anidada
-----------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Browser" as B
   object ":auth_app" as Auth
   object ":Redis" as R

   B -> Auth : "1: POST /login"
   Auth -> R : "1.1: crear_sesion()"
   R --> Auth : "1.2: session_id"
   Auth --> B : "1.3: 302 panel"
   @enduml

14.7 Mensaje con guarda condicional
-----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":auth_app" as Auth
   object ":audit_log" as Audit

   Auth -> Audit : "1: [credenciales_validas] registrar_acceso()"
   @enduml

14.8 Mensaje en bucle
---------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":etl_runner" as ETL
   object ":bd_operativa" as BDO

   ETL -> BDO : "1: *[i:1..n] leer_lote(i)"
   @enduml

14.9 Cambio de estado anotado
-----------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":auth_app" as Auth
   object ":Sesion" as S

   Auth -> S : "1: caducar()"
   note right of S
     estado: activa → caducada
     CNST_002
   end note
   @enduml

14.10 Valor de retorno capturado
--------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":rpt_app" as Rpt
   object ":Reporte" as R

   Rpt -> R : "1: tarea_id := exportar(req)"
   @enduml

14.11 Sincronización — UC_ALR_03
--------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing

   object ":Supervisor" as S
   object ":alr_app" as Alr
   object ":audit_log" as Audit
   object ":log_app" as Log
   object ":Alerta" as A

   S -> Alr : "1: reconocer(alerta_id)"
   Alr -> Audit : "1.1: registrar(CNST_025)"
   Alr -> Log : "1.2: notificar(CNST_001)"
   Alr -> A : "1.3: cambiar_estado(reconocida)"
   note right of A
     estado: publicada → reconocida
   end note
   @enduml

14.12 Plantilla — UC nuevo en colaboración
------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   allowmixing
   title UC_XXX_NN — vista de colaboracion

   object ":Actor" as Actor
   object ":AppEmisora" as Emisor
   object ":AppReceptora" as Receptor
   object ":BD" as BD
   object ":audit_log" as Audit

   Actor -> Emisor : "1: disparador()"
   Emisor -> Receptor : "1.1: operacion_principal(req)"
   Receptor -> BD : "1.1.1: persistir(datos)"
   BD --> Receptor : "1.1.2: ack"
   Receptor --> Emisor : "1.1.3: ok"
   Emisor -> Audit : "1.2: registrar_evento(CNST_025)"
   Emisor --> Actor : "1.3: exito"
   @enduml

14.13 Cómo usar la galería
--------------------------

1. Localizar el componente en § 13.
2. Copiar el snippet correspondiente (§§
   14.1-14.11) o usar la plantilla (§ 14.12).
3. Adaptar nombres, mensajes, guardas, anclar
   a CNST/BR.
4. Integrar al documento del UC.

Mantenimiento: al introducir un componente
nuevo en § 13, agregar su mini-diagrama aquí.
Mantener cada snippet ≤ 6 mensajes.

----

15. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skills aplicadas**
   - ``rm-specification`` (modelado de la arquitectura
     espacial), ``rm-analysis`` (verificar consistencia
     espacial vs temporal)
 * - **Origen del documento**
   - Reescrito de "GUÍA-DIAGRAMAS-COLABORACIONES-CONTEXTO-
     ESPACIAL" (Hora 10 de Schmuller, cheat-sheet aplicado
     interno con dominio ecommerce), reorientado al
     dominio real IACT.
 * - **Lección teórica**
   - :doc:`/base-cognitiva/_uml/uml-10-diagramas-colaboraciones`
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
     :doc:`diagramas-estados`,
     :doc:`diagramas-secuencias`
 * - **Catálogo modular del dominio**
   - :doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`
 * - **Restricciones citadas**
   - CNST_001 (sólo buzón interno),
     CNST_008 (filtro segmento),
     CNST_011 (throttling),
     CNST_017 (SLA),
     CNST_019 / 020 (export async + throttling),
     CNST_025 (auditoría inmutable),
     CNST_030 (SoD),
     CNST_031 (permisos temporales 6m),
     BR_012 (segmento único),
     BR_016 (tasa de abandono).
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
