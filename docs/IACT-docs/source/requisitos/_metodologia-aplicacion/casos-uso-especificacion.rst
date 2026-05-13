.. meta::
 :artefacto: EJEMPLOS_CASOS_USO_IACT
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
Análisis y especificación de casos de uso — IACT
==================================================================

.. note::

 Compañero del :doc:`/requisitos/_metodologia-aplicacion/plan-documentacion-uc`.
 Adapta los conceptos de **Hora 6 de Schmuller**
 (componentes de un UC, precondiciones, flujos, alternativas,
 inclusión, extensión) al **dominio real del proyecto IACT** —
 call center IVR + analytics + RBAC + ETL.

 Sirve como **referencia de precedente** para los autores que
 generen los 13 documentos del plan.

 Diagramas en **PlantUML** (política del proyecto, no Mermaid).

 Para la teoría genérica ver
 :doc:`/base-cognitiva/_uml/uml-06-introduccion-casos-uso`
 (Schmuller Hora 6).

----

1. ¿Por qué casos de uso?
=========================

**Problema:** los desarrolladores hablan en términos técnicos
(clases, métodos, BD); los usuarios hablan en términos de
negocio (consultar dashboard, reconocer alerta, exportar
auditoría).

**Solución:** los casos de uso son el **puente** entre ambos
lenguajes.

**Definición:**

  Un caso de uso es una estructura que describe **cómo el
  sistema lucirá para los usuarios**.

**Componentes clave:**

- **Actor** — quién inicia (persona, sistema, hardware,
  tiempo).
- **Precondición** — qué estado debe existir.
- **Flujo principal** — pasos normales del UC.
- **Resultado** — qué se obtiene (valor para el actor).
- **Rutas alternativas** — escenarios excepcionales.

----

2. Componentes de un caso de uso — ejemplo IACT
===============================================

Caso ilustrativo: **UC_RPT_01 — Ver dashboard**.

::

 CASO DE USO: Ver dashboard
 ─────────────────────────────────────────────
 ACTOR:           Operador
 PRECONDICIÓN:    Operador autenticado con
                  segmento asignado (BR_012)
 FLUJO PRINCIPAL: 1. Operador entra al
                     panel principal
                  2. Sistema verifica permiso
                     view_dashboard
                  3. Sistema consulta métricas
                     filtradas por segmento
                  4. Sistema renderiza
                     dashboard
 RESULTADO:       Operador ve métricas
                  operativas vigentes

----

3. Análisis detallado de componentes
====================================

3.1 Precondición — qué debe ser verdad ANTES
--------------------------------------------

::

 UC_AUTH_01 (Iniciar sesión):
   - Usuario tiene credenciales registradas
   - Cuenta no está bloqueada (CNST_011)
   - Throttling no alcanzado (5 intentos / 5 min)

 UC_RPT_04 (Exportar reporte):
   - Operador / Supervisor autenticado
   - Reporte previamente generado (UC_RPT_03)
   - Throttling diario por formato no
     alcanzado (CNST_019/020)

 UC_PIP_04 (Solicitar reintento ETL):
   - AdminPipeline autenticado
   - EjecucionETL en estado FALLIDA
   - Función manage_pipeline asignada

 UC_AUD_01 (Consultar auditoría):
   - Auditor autenticado
   - Función view_audit_log asignada
   - SoD verificado (CNST_030)

3.2 Actor — quién INICIA el UC
------------------------------

**Tipos de actores en IACT:**

::

 1. PERSONA (Usuario operativo)
    - Operador
    - Supervisor
    - AdminAcceso
    - AdminPipeline
    - Auditor

 2. SISTEMA EXTERNO
    - IVR Conmutador (read-only, fuente
      operacional, CNST_007)
    - APScheduler / Cron (dispara ETL)

 3. HARDWARE
    - (no aplica directamente en IACT)

 4. TIEMPO (actor especial)
    - Cada noche → dispara EjecucionETL
      (UC_PIP_01)
    - Cada hora → evalúa umbrales de alertas
      (UC_ALR_02)
    - Cada 6 meses → vencimiento automático
      de permisos temporales (CNST_031)
    - Cada día → revocación de cuentas
      con 90 días sin login (BR_003)

3.3 Flujo principal — secuencia normal
--------------------------------------

**UC_RPT_04 (Exportar reporte):**

::

 1. Operador clic en "Exportar"
 2. Operador selecciona formato (CSV/Excel/PDF)
 3. Sistema verifica permiso export_<formato>
 4. Sistema valida throttling diario
    (CNST_020 — distinto por formato)
 5. Sistema aplica filtro de segmento
    (BR_012, CNST_008)
 6. Sistema estima # de filas
 7. Si > 10k → encola export asíncrono
    (CNST_019); si ≤ 10k → genera en línea
 8. Sistema registra acción en AuditLog
    (CNST_025 inmutable)
 9. Sistema entrega archivo
    (descarga directa o aviso al buzón)
 10. Operador descarga / recibe el archivo

3.4 Resultado — valor obtenido
------------------------------

::

 UC_AUTH_01: Sesión válida con JWT,
             cookie de sesión activa
             (CNST_002 sesión única)

 UC_RPT_04: Archivo de export entregado
             (CSV / Excel / PDF) con datos
             filtrados por segmento

 UC_PIP_04: EjecucionETL re-encolada,
             evento auditado, ETA estimado

 UC_ALR_03: Alerta marcada como reconocida,
             suscriptores notificados vía
             buzón interno (CNST_001)

3.5 Rutas alternativas — qué pasa si NO es normal
-------------------------------------------------

**Ejemplo — UC_AUTH_01 (Iniciar sesión):**

::

 RUTA ALTERNATIVA A1: Credenciales inválidas
 ─────────────────────────────────────────────
 En paso 3 del flujo principal:
 3a. Si email / password no coinciden:
     3a1. Sistema incrementa contador de
          intentos fallidos
     3a2. Sistema registra evento en
          AuditLog (LOGIN_FAILED)
     3a3. Sistema muestra "Credenciales
          incorrectas"
     → Regresa a paso 1 (otro intento)

 RUTA ALTERNATIVA A2: Throttling alcanzado
 ─────────────────────────────────────────────
 En paso 3 del flujo principal:
 3b. Si intentos fallidos ≥ 5 en
     últimos 5 min (CNST_011):
     3b1. Sistema bloquea IP por X minutos
     3b2. Sistema registra evento en
          AuditLog (LOGIN_BLOCKED_IP)
     3b3. Sistema muestra "IP bloqueada"
     → UC termina sin sesión

 RUTA ALTERNATIVA A3: Cuenta inactiva
 ─────────────────────────────────────────────
 3c. Si is_active = false:
     3c1. Sistema rechaza login
     3c2. Sistema muestra "Cuenta
          desactivada"
     → UC termina sin sesión

 RUTA ALTERNATIVA A4: Sesión existente
 ─────────────────────────────────────────────
 En paso 4 del flujo principal:
 4a. Si ya existe sesión activa
     (CNST_002 sesión única):
     4a1. Sistema invalida sesión
          anterior (logout forzoso)
     4a2. Sistema crea nueva sesión
     → Continúa con paso 5

----

4. Preguntas clave para especificar
===================================

**Estructura de preguntas para cada UC del catálogo IACT:**

**Precondición:**

- ¿Qué condiciones deben existir?
- ¿Qué estado debe tener el sistema (sesión, segmento,
  permiso)?
- ¿Qué CNSTs aplican como condiciones de entrada?

**Resultado:**

- ¿Qué valor obtiene el actor?
- ¿Qué cambios ocurren en el sistema?
- ¿Qué se registra en auditoría (CNST_025)?

**Flujo único:**

- ¿Es éste el único flujo posible?
- ¿Qué escenarios alternativos podrían ocurrir?

**Puntos de fallo:**

- ¿Qué situaciones impiden alcanzar el objetivo?
- ¿Cuáles son los puntos críticos?
  (BD analytics, IVR, scheduler, etc.).

**Datos y estado:**

- ¿Qué sucede con los datos si se interrumpe?
- ¿Hay rollback (transacción ACID en BD)?
- ¿La auditoría queda escrita aun en fallo?

----

5. Inclusión de casos de uso (reutilización)
============================================

**Concepto:** un UC **incluye** los pasos de otro. Beneficio:
eliminar duplicación, reutilizar pasos comunes.

5.1 Inclusión en IACT — Crear orden NO; permisos SÍ
---------------------------------------------------

En IACT, casi todos los UCs operativos **incluyen UC_PERM_07
(Verificar permiso de usuario)** como primer paso. Es el
equivalente a *"abrir la máquina"* del ejemplo del libro.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Operador
   actor Supervisor
   actor Auditor

   rectangle "IACT" {
     usecase "UC_RPT_01\nVer dashboard"          as RPT01
     usecase "UC_RPT_03\nVer reportes históricos" as RPT03
     usecase "UC_RPT_04\nExportar reporte"        as RPT04
     usecase "UC_AUD_01\nConsultar auditoría"     as AUD01
     usecase "UC_PIP_04\nSolicitar reintento ETL" as PIP04
     usecase "UC_PERM_07\nVerificar permiso"      as PERM07
     usecase "Registrar en AuditLog\n(CNST_025)"  as AUDLOG
   }

   Operador   --> RPT01
   Operador   --> RPT04
   Supervisor --> RPT03
   Auditor    --> AUD01

   RPT01 ..> PERM07  : <<include>>
   RPT03 ..> PERM07  : <<include>>
   RPT04 ..> PERM07  : <<include>>
   AUD01 ..> PERM07  : <<include>>
   PIP04 ..> PERM07  : <<include>>

   RPT01 ..> AUDLOG  : <<include>>
   RPT03 ..> AUDLOG  : <<include>>
   RPT04 ..> AUDLOG  : <<include>>
   AUD01 ..> AUDLOG  : <<include>>
   PIP04 ..> AUDLOG  : <<include>>
   @enduml

5.2 Otros casos de inclusión IACT
---------------------------------

::

 UC_RPT_04 (Exportar reporte)
   ├─ INCLUYE UC_RPT_03 (Ver reporte
   │              histórico que se exporta)
   ├─ INCLUYE UC_PERM_07 (Verificar permiso)
   └─ INCLUYE Registrar AuditLog

 UC_AUD_03 (Exportar auditoría)
   ├─ INCLUYE UC_AUD_01 (Consultar auditoría
   │              cuyos resultados se exportan)
   └─ INCLUYE UC_PERM_07

 UC_PIP_04 (Solicitar reintento)
   ├─ INCLUYE UC_PIP_02 (Consultar errores
   │              de la EjecucionETL)
   └─ INCLUYE UC_PERM_07

5.3 Ventaja de la inclusión
---------------------------

::

 SIN inclusión (duplicación):
   UC_RPT_04: pasos para verificar permiso
   UC_AUD_03: MISMOS pasos para verificar
   UC_PIP_04: MISMOS pasos para verificar
   Mantenimiento: cambiar en 3+ lugares

 CON inclusión (reutilización):
   UC_PERM_07 (verificar permiso)
   Los demás UCs lo INCLUYEN
   Mantenimiento: 1 lugar (CNST_030 SoD)

----

6. Extensión de casos de uso (variantes)
========================================

**Concepto:** un UC **extiende** otro agregándole pasos.

6.1 Extensión en IACT — Ver histórico con filtros
-------------------------------------------------

Caso base: ``UC_RPT_03`` (Ver reportes históricos).
Extensión: ``UC_RPT_09`` (Configurar filtros) — opcional para
acotar el conjunto de filas.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Supervisor

   rectangle "IACT" {
     usecase "UC_RPT_03\nVer reportes\nhistóricos\n(BASE)"           as RPT03
     usecase "UC_RPT_09\nConfigurar\nfiltros\n(EXTIENDE)"            as RPT09
     usecase "UC_RPT_10\nGuardar vista\n(EXTIENDE)"                  as RPT10
     usecase "UC_RPT_11\nCompartir reporte\n(EXTIENDE)"              as RPT11
   }

   Supervisor --> RPT03
   RPT09 ..> RPT03 : <<extend>>
   RPT10 ..> RPT03 : <<extend>>
   RPT11 ..> RPT03 : <<extend>>
   @enduml

::

 UC_RPT_03 (Ver reportes históricos) — base
   1. Supervisor abre histórico
   2. Sistema valida permiso
   3. Sistema lista reportes filtrados
      por segmento del usuario
   4. Sistema muestra resultados

 UC_RPT_09 (Configurar filtros) — extensión
   Punto de extensión: paso 3
   Pasos adicionales:
     3a1. Supervisor agrega filtros
          (fecha / centro / campaña)
     3a2. Sistema aplica filtros junto
          con BR_012 (segmento)
     3a3. Sistema actualiza resultados

6.2 Otras extensiones IACT
--------------------------

::

 UC_AUTH_01 (Iniciar sesión) — base
   ↓ extendida por
 UC_AUTH_01b (Iniciar sesión con 2FA)
   — agrega pasos opcionales de verificación
     en dos pasos cuando la cuenta tiene 2FA
     habilitado.

 UC_PIP_04 (Solicitar reintento ETL) — base
   ↓ extendida por
 UC_PIP_04b (Reintentar con parámetros
   ajustados) — permite cambiar la ventana
   de carga (CNST_008) si la ejecución falló
   por timeout.

 UC_ALR_01 (Configurar umbrales) — base
   ↓ extendida por
 UC_ALR_01b (Configurar umbrales con
   ventana móvil) — agrega ventana
   deslizante en lugar de comparación puntual.

6.3 Ventaja de la extensión
---------------------------

::

 SIN extensión (UCs duplicados):
   UC_RPT_03_simple
   UC_RPT_03_con_filtros
   UC_RPT_03_ordenado
   Mantenimiento: 3 lugares

 CON extensión (1 base + variantes):
   UC_RPT_03 (base)
   UC_RPT_09 (extiende con filtros)
   UC_RPT_05 (extiende con orden)
   Mantenimiento: 1 lugar

----

7. Metodología de análisis
==========================

7.1 Fase 1 — entrevistas con clientes / patrocinadores
------------------------------------------------------

::

 OBJETIVO: entender el negocio de alto nivel
           del call center IACT.

 PREGUNTAS:
   - ¿Cuál es el objetivo del sistema?
     (visibilidad de métricas operativas
      del IVR — BReq_001)
   - ¿Quiénes son los usuarios principales?
     (operadores, supervisores, gestores)
   - ¿Qué problemas resuelve?
     (visibilidad sin acceso al IVR crudo)
   - ¿Cuáles son los procesos clave?
     (ETL, RBAC, alertas, auditoría)
   - ¿Cuáles son las métricas de éxito?
     (latencia ≤ 10s — CNST_017)

 DELIVERABLE: diagrama inicial de clases
              + BReqs (BReq_001 ya existe).

7.2 Fase 2 — entrevistas con usuarios
-------------------------------------

::

 OBJETIVO: entender qué harán los usuarios
           operativos en detalle.

 TÉCNICA: entrevistas en grupos por rol
   - Operadores (uso diario del dashboard)
   - Supervisores (reportes históricos)
   - Admins de acceso (gestión RBAC)
   - Admins de pipeline (supervisar ETL)
   - Auditores (consulta de auditoría)

 PREGUNTAS:
   - ¿Qué quieres hacer con el sistema?
   - ¿Cuáles son los pasos que sigues?
   - ¿Qué pasa si algo falla?
   - ¿Cuáles son las variantes normales?
   - ¿Cuáles son tus excepciones?

 RESULTADO: conjunto candidato de casos
            de uso (los 97 actuales).

7.3 Fase 3 — derivación de UCs
------------------------------

::

 OBJETIVO: formalizar los 97 UCs.

 PASOS:
   1. Listar todos los actores
      identificados (5 roles + 2 sistemas
      externos + tiempo).
   2. Para cada actor, listar lo que
      quiere hacer.
   3. Crear UC para cada acción.
   4. Especificar precondición + flujo +
      resultado por UC.
   5. Identificar rutas alternativas.
   6. Identificar inclusiones y
      extensiones.

 DELIVERABLE: 97 UC documentados
              (DOC-14..DOC-26 del plan).

----

8. Plantilla de especificación
==============================

8.1 Template estándar
---------------------

::

 ┌──────────────────────────────────────────┐
 │ CASO DE USO: [nombre descriptivo]        │
 ├──────────────────────────────────────────┤
 │ IDENTIFICADOR:    UC_<MOD>_<NN>          │
 │ ACTOR PRIMARIO:   [quién inicia]         │
 │ ACTORES SECUND.:  [otros involucrados]   │
 │ PRECONDICIÓN:     [qué debe existir]     │
 │ POSTCONDICIÓN:    [qué debe ser verdad]  │
 ├──────────────────────────────────────────┤
 │ FLUJO PRINCIPAL:                         │
 │ 1. [paso 1]                              │
 │ 2. [paso 2]                              │
 │ ...                                      │
 ├──────────────────────────────────────────┤
 │ RESULTADO:        [valor para el actor]  │
 ├──────────────────────────────────────────┤
 │ RUTAS ALTERNATIVAS:                      │
 │ A1. Si [condición]:                      │
 │     1a. [paso alternativo]               │
 │     → regresa a paso [N]                 │
 │ A2. Si [otra condición]:                 │
 │     2a. [otro paso]                      │
 │     → UC termina con [resultado alt]     │
 ├──────────────────────────────────────────┤
 │ INCLUSIONES:      UC_XXX, UC_YYY         │
 │ EXTENSIONES:      UC_ZZZ                 │
 │ PUNTOS CRÍTICOS:  [qué puede fallar]     │
 │ CNSTs / BRs:      [restricciones]        │
 └──────────────────────────────────────────┘

  La plantilla canónica RST con metadata y
  todas las secciones está en
  :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`.

8.2 Ejemplo completado — UC_RPT_04 (Exportar reporte)
-----------------------------------------------------

::

 ┌────────────────────────────────────────────────────┐
 │ CASO DE USO: Exportar reporte                       │
 ├────────────────────────────────────────────────────┤
 │ IDENTIFICADOR:    UC_RPT_04                         │
 │ ACTOR PRIMARIO:   Supervisor                        │
 │ ACTORES SECUND.:  AuditService                      │
 │ PRECONDICIÓN:     Reporte previamente generado     │
 │                   (UC_RPT_03); throttling diario   │
 │                   no alcanzado (CNST_020).         │
 │ POSTCONDICIÓN:    Archivo entregado al actor;      │
 │                   AuditLog inscrito (CNST_025).    │
 ├────────────────────────────────────────────────────┤
 │ FLUJO PRINCIPAL:                                    │
 │ 1. Supervisor clic en "Exportar"                   │
 │ 2. Supervisor selecciona formato (CSV/Excel/PDF)   │
 │ 3. Sistema verifica permiso export_<formato>       │
 │ 4. Sistema valida throttling (CNST_020)            │
 │ 5. Sistema aplica filtro de segmento (BR_012)      │
 │ 6. Sistema estima # de filas                       │
 │ 7. Si > 10k → encola export asíncrono              │
 │       (CNST_019); si ≤ 10k → genera en línea       │
 │ 8. Sistema registra acción en AuditLog             │
 │ 9. Sistema entrega archivo (descarga / buzón)      │
 ├────────────────────────────────────────────────────┤
 │ RESULTADO:        Archivo de export en formato     │
 │                   solicitado, filtrado por         │
 │                   segmento.                        │
 ├────────────────────────────────────────────────────┤
 │ RUTAS ALTERNATIVAS:                                 │
 │ A1. Si permiso denegado (paso 3):                  │
 │     3a1. Sistema muestra 403                       │
 │     3a2. AuditLog registra denegación              │
 │     → UC termina sin archivo                       │
 │                                                    │
 │ A2. Si throttling alcanzado (paso 4):              │
 │     4a1. Sistema muestra "Límite del día"          │
 │     4a2. Sistema indica hora de reset              │
 │     → UC termina sin archivo                       │
 │                                                    │
 │ A3. Si BD analytics no disponible (paso 5):        │
 │     5a1. Sistema reintenta 3 veces                 │
 │     5a2. Si persiste, AuditLog registra error      │
 │     → UC termina sin archivo                       │
 ├────────────────────────────────────────────────────┤
 │ INCLUSIONES:      UC_RPT_03 (Ver histórico)        │
 │                   UC_PERM_07 (Verificar permiso)   │
 │ EXTENSIONES:      —                                │
 │ PUNTOS CRÍTICOS:  Throttling alcanzado; BD         │
 │                   analytics no disponible;         │
 │                   sets > 10k requieren async.      │
 │ CNSTs / BRs:      CNST_019, CNST_020 (export);    │
 │                   CNST_008, BR_012 (segmento);     │
 │                   CNST_025 (auditoría inmutable). │
 └────────────────────────────────────────────────────┘

----

9. En el proyecto IACT — los 97 UCs
===================================

9.1 Estructura del catálogo
---------------------------

::

 UC_AUTH (Autenticación — 5 UCs)
   UC_AUTH_01 — Iniciar sesión [CRÍTICO]
   UC_AUTH_02 — Cerrar sesión
   UC_AUTH_03 — Recuperar contraseña
   UC_AUTH_04 — Cambiar contraseña
   UC_AUTH_05 — Gestionar sesiones

 UC_USR (Usuarios — 4 UCs)
   UC_USR_01..04 — CRUD de usuarios

 UC_ACC (Acceso / RBAC — 9 UCs)
   UC_ACC_01..09 — funciones, agrupador,
                   SoD, segmentos, permiso
                   temporal, auditoría

 UC_PERM (Permisos granular — 10 UCs)
   UC_PERM_01..10 — grupos, capacidades,
                    permiso excepcional,
                    verificar, menú dinámico,
                    auditar acceso

 UC_RPT (Reportes — 14 UCs) [CRÍTICO]
   UC_RPT_01..14 — dashboard, real-time,
                   histórico, export,
                   programar, filtros,
                   guardar vista, compartir,
                   agentes, colas, campañas

 UC_ALR (Alertas — 5 UCs)
   UC_ALR_01..05 — umbrales, ver activas,
                   reconocer, historial,
                   gestionar suscripciones

 UC_PIP (Pipeline ETL — 4 UCs)
   UC_PIP_01..04 — supervisar, errores,
                   disponibilidad, reintento

 UC_AUD (Auditoría — 4 UCs)
   UC_AUD_01..04 — consultar, buscar,
                   exportar, reporte
                   compliance

 UC_LOG (Logs — 7 UCs)
   UC_LOG_01..07 — sistema, ETL, buscar,
                   exportar, infra,
                   estado, métricas

9.2 Cómo especificar cada UC del catálogo
-----------------------------------------

Para cada uno de los 97 UCs:

1. Identificar **actor primario** (Operador, Supervisor,
   Admin*, Auditor, Sistema/Cron, IVR).
2. Escribir **precondición** (sesión, segmento, permiso,
   estado del sistema).
3. Especificar **flujo principal** (5–15 pasos típicamente,
   con verificación de permiso e inscripción en AuditLog).
4. Definir **resultado** esperado.
5. Listar **rutas alternativas** (A1, A2, A3...) cubriendo
   permiso denegado, throttling, BD no disponible, dato
   inexistente.
6. Marcar **inclusiones** — al menos UC_PERM_07 y
   "Registrar AuditLog" si aplica.
7. Marcar **extensiones** si hay variantes opcionales.
8. Identificar **puntos críticos** y **CNSTs / BRs**
   aplicables (CNST_001/002/008/011/017/019/020/025/030,
   BR_012, BR_016/017/018, etc.).

  Entregable: archivo
  ``casos-uso/<modulo>/uc-<mod>-<NN>-<descripcion>.rst``
  per :doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`.

----

10. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-elicitation`` (BABOK — Elicitation and
     Collaboration)
 * - **Origen del documento**
   - Reescrito de "GUÍA-CASOS-DE-USO-ANALISIS-Y-
     ESPECIFICACION" (cheat-sheet aplicado interno con
     dominio ecommerce), **reorientado al dominio real
     IACT**.
 * - **Teoría genérica**
   - :doc:`/base-cognitiva/_uml/uml-06-introduccion-casos-uso`
     (Schmuller Hora 6)
 * - **Cheat-sheet de los 9 diagramas**
   - :doc:`/base-cognitiva/_uml/cuando-usar-cada-diagrama`
 * - **Ejemplos hermanos aplicados a IACT**
   - :doc:`diagramas-uml`,
     :doc:`orientacion-objetos`,
     :doc:`analisis-dominio`,
     :doc:`relaciones-uml`,
     :doc:`agregacion-interfaces`
 * - **Plantilla canónica de UC**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Plan de documentación**
   - :doc:`plan-documentacion-uc`
 * - **Catálogo modular del dominio IACT**
   - :doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`
 * - **BReq motor**
   - :doc:`/requisitos/business-requirements/breq-001-visibilidad-metricas`
 * - **Restricciones citadas**
   - CNST_001 (no email), CNST_002 (sesión única),
     CNST_007/008 (IVR readonly + ventana ETL),
     CNST_011 (throttling 5/5min), CNST_017 (SLA),
     CNST_019/020 (export async + throttling),
     CNST_025 (auditoría inmutable),
     CNST_030 (SoD), CNST_031 (permisos temporales 6m),
     BR_012 (segmento único), BR_003 (90 días sin login).
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
