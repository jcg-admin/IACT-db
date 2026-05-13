.. meta::
 :artefacto: METODOLOGIA_UC_DIAGRAMAS_IACT
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
Casos de uso — diagramas (modelado visual aplicado a IACT)
==================================================================

.. note::

 Compañero de :doc:`casos-uso-especificacion` (la
 especificación textual de un UC). Este documento cubre la
 **dimensión visual** — cómo crear el diagrama de casos de
 uso que acompaña a la especificación.

 Adapta la **Hora 7 de Schmuller** ("Diagramas de casos de
 uso") al dominio real del proyecto IACT (call center IVR +
 analytics + RBAC + ETL).

 Diagramas en **PlantUML** (política del proyecto, no Mermaid).

 Para la teoría genérica ver
 :doc:`/base-cognitiva/_uml/uml-07-diagramas-casos-uso`
 (Schmuller Hora 7).

----

1. Comunicar requisitos visualmente
===================================

  *Los usuarios con frecuencia saben más de lo que dicen.*

**Solución:** los diagramas de casos de uso convierten el
análisis en **imágenes claras** que todos entienden.

**Objetivo:** comunicar requisitos funcionales de forma
visual y clara.

----

2. Componentes del diagrama
===========================

2.1 Símbolos básicos
--------------------

Cuatro elementos canónicos: **límite del sistema**
(rectángulo), **caso de uso** (elipse), **actor** (figura
de palo) y **línea asociativa**.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor "Actor\n(figura de palo)" as A

   rectangle "Límite del sistema (rectángulo)" {
     usecase "Caso de uso\n(elipse)" as UC
   }

   A --> UC : línea asociativa
   @enduml

2.2 Posicionamiento
-------------------

El **actor que inicia** se ubica a la izquierda; el **caso
de uso** en el centro o a la derecha; el **actor que se
beneficia** a la derecha (puede ser el mismo).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor "Actor\niniciador" as A1
   actor "Actor\nbeneficiario" as A2

   rectangle "Sistema" {
     usecase "Caso de uso" as UC
   }

   A1 --> UC : inicia
   UC --> A2 : se beneficia
   @enduml

----

3. Ejemplo visual — Máquina de gaseosas (referencia genérica)
=============================================================

Diagrama clásico de Schmuller que sirve de base conceptual:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Cliente
   actor "Representante\ndel proveedor" as Proveedor
   actor Recolector
   actor Tiempo

   rectangle "Máquina de Gaseosas" {
     usecase "Comprar gaseosa"      as UC1
     usecase "Reabastecer"          as UC2
     usecase "Recolectar el dinero" as UC3
   }

   Cliente    --> UC1
   Proveedor  --> UC2
   Recolector --> UC3
   Tiempo     --> UC2
   Tiempo     --> UC3
   @enduml

----

4. Ejemplo IACT — diagrama de alto nivel
========================================

Diagrama del **sistema completo IACT** mostrando los UCs
operativos clave por dominio funcional, con sus actores
internos y externos.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction

   actor Operador
   actor Supervisor
   actor "Admin\nAcceso"     as AA
   actor "Admin\nPipeline"   as AP
   actor Auditor
   actor "Sistema /\nScheduler" as Sched
   actor "IVR\nConmutador"  as IVR

   rectangle "IACT" {
     usecase "UC_AUTH_01\nIniciar sesión"     as AUTH01
     usecase "UC_RPT_01\nVer dashboard"       as RPT01
     usecase "UC_RPT_04\nExportar reporte"    as RPT04
     usecase "UC_ALR_03\nReconocer alerta"    as ALR03
     usecase "UC_ACC_01\nAsignar funciones"   as ACC01
     usecase "UC_PERM_07\nVerificar permiso"  as PERM07
     usecase "UC_PIP_01\nSupervisar ETL"      as PIP01
     usecase "UC_PIP_04\nSolicitar reintento" as PIP04
     usecase "UC_AUD_01\nConsultar auditoría" as AUD01
     usecase "UC_AUD_03\nExportar auditoría"  as AUD03
     usecase "Carga ETL\nnocturna"            as ETL
   }

   Operador   --> AUTH01
   Operador   --> RPT01
   Operador   --> RPT04
   Operador   --> ALR03

   Supervisor --> AUTH01
   Supervisor --> RPT04
   Supervisor --> ALR03

   AA         --> ACC01
   AP         --> PIP01
   AP         --> PIP04
   Auditor    --> AUD01
   Auditor    --> AUD03

   Sched      --> ETL
   IVR        <-- ETL

   RPT01      ..> PERM07 : <<include>>
   RPT04      ..> PERM07 : <<include>>
   ACC01      ..> PERM07 : <<include>>
   AUD01      ..> PERM07 : <<include>>
   PIP04      ..> PERM07 : <<include>>
   @enduml

**Lectura del diagrama:**

- Cinco actores **operativos** (Operador, Supervisor,
  AdminAcceso, AdminPipeline, Auditor) inician UCs
  específicos según su rol.
- Dos actores **sistema/externos** (Scheduler y IVR
  Conmutador) participan en la carga ETL.
- ``UC_PERM_07`` (verificar permiso) es **incluido por
  todos** los UCs operativos — es el equivalente IACT a
  *"abrir la máquina"* del ejemplo del libro.

----

5. Inclusión en diagrama (``<<include>>``)
==========================================

**Concepto:** un UC **incluye** los pasos de otro. Reutiliza
y elimina duplicación.

**Notación:** línea discontinua con flecha + estereotipo
``<<include>>``.

5.1 Ejemplo IACT — UC_RPT_04 (Exportar reporte)
-----------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Supervisor

   rectangle "IACT" {
     usecase "UC_RPT_04\nExportar reporte"  as RPT04
     usecase "UC_RPT_03\nVer reportes\nhistóricos"   as RPT03
     usecase "UC_PERM_07\nVerificar permiso\n+ throttling\nCNST_020"            as PERM
     usecase "Aplicar filtro\nsegmento\n(BR_012,\nCNST_008)"                    as SEG
     usecase "Registrar en\nAuditLog\n(CNST_025)"                               as AUD
   }

   Supervisor --> RPT04

   RPT04 ..> PERM  : <<include>>
   RPT04 ..> RPT03 : <<include>>
   RPT04 ..> SEG   : <<include>>
   RPT04 ..> AUD   : <<include>>

   note right of RPT04
     UC_RPT_04 INCLUYE:
       - Verificar permiso del formato
         (CSV / Excel / PDF) con
         throttling diario CNST_020
       - Ver reporte histórico que se
         exporta (UC_RPT_03)
       - Aplicar filtro de segmento
         del usuario (BR_012)
       - Registrar export en
         AuditLog inmutable (CNST_025)
   end note
   @enduml

----

6. Extensión en diagrama (``<<extend>>``)
=========================================

**Concepto:** un UC **extiende** otro agregando pasos en
**puntos de extensión específicos**.

**Notación:** línea discontinua con flecha + estereotipo
``<<extend>>`` apuntando al caso base.

6.1 Ejemplo IACT — UC_RPT_03 (Ver reportes históricos) extendido
----------------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Supervisor

   rectangle "IACT" {
     usecase "UC_RPT_03\nVer reportes\nhistóricos\n.. extension points ..\nresultados listados\nen pantalla"   as RPT03
     usecase "UC_RPT_09\nConfigurar filtros"          as RPT09
     usecase "UC_RPT_10\nGuardar vista"               as RPT10
     usecase "UC_RPT_11\nCompartir reporte"           as RPT11
   }

   Supervisor --> RPT03

   RPT09 ..> RPT03 : <<extend>>\n(resultados listados)
   RPT10 ..> RPT03 : <<extend>>\n(resultados listados)
   RPT11 ..> RPT03 : <<extend>>\n(resultados listados)

   note right of RPT03
     Punto de extensión:
       "resultados listados en pantalla"

     UC_RPT_03 (base) puede ser
     extendido opcionalmente por:
       - UC_RPT_09 (configurar filtros)
       - UC_RPT_10 (guardar vista actual)
       - UC_RPT_11 (compartir vía link)
     Las extensiones son opcionales,
     no obligatorias.
   end note
   @enduml

----

7. Generalización en diagrama
=============================

**Concepto:** un UC **hereda** de otro. El secundario
hereda acciones del primario y agrega las propias.

**Notación:** línea continua con triángulo vacío apuntando
al caso primario.

7.1 Ejemplo IACT — UC_AUTH_01 con variante 2FA
----------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Usuario

   rectangle "IACT" {
     usecase "UC_AUTH_01\nIniciar sesión\n(BASE)"       as A1
     usecase "UC_AUTH_01b\nIniciar sesión\ncon 2FA"     as A1B
   }

   Usuario --> A1
   Usuario --> A1B

   A1B --|> A1

   note right of A1B
     UC_AUTH_01b HEREDA de UC_AUTH_01:
       + paso adicional de verificación
         del segundo factor (TOTP / SMS
         interno) tras validar password.
     Sólo aplica a usuarios con 2FA
     habilitado en su cuenta.
   end note
   @enduml

7.2 Ejemplo IACT — UC_PIP_04 con reintento parametrizado
--------------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor "Admin\nPipeline" as AP

   rectangle "IACT" {
     usecase "UC_PIP_04\nSolicitar reintento\n(BASE)"           as P4
     usecase "UC_PIP_04b\nReintentar con\nparámetros ajustados" as P4B
   }

   AP --> P4
   AP --> P4B

   P4B --|> P4

   note right of P4B
     UC_PIP_04b HEREDA de UC_PIP_04:
       + permite ajustar la ventana
         CNST_008 (6-12h) si la
         ejecución original falló por
         timeout o conexión IVR.
   end note
   @enduml

----

8. Generalización entre actores
===============================

La generalización también aplica entre **actores** — útil
para mostrar la jerarquía de roles del proyecto.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   actor Usuario
   actor Operador
   actor Supervisor
   actor "Admin Acceso"   as AA
   actor "Admin Pipeline" as AP
   actor Auditor

   Usuario <|-- Operador
   Usuario <|-- Supervisor
   Usuario <|-- AA
   Usuario <|-- AP
   Usuario <|-- Auditor

   note right of Usuario
     Usuario base:
       login(), logout(),
       changePassword().
     Cada rol especializado
     hereda esto + agrega
     funciones específicas.
   end note
   @enduml

----

9. Agrupamiento con paquetes
============================

Los **paquetes** organizan UCs en grupos coherentes por
dominio funcional. En IACT, cada paquete corresponde a un
módulo del catálogo modular.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction
   actor Operador
   actor Supervisor
   actor "Admin Acceso"   as AA
   actor "Admin Pipeline" as AP
   actor Auditor

   rectangle "IACT" {
     package "UC_AUTH (5 UCs)" {
       usecase "Iniciar sesión"  as A1
       usecase "Cerrar sesión"   as A2
     }

     package "UC_USR (4 UCs)" {
       usecase "CRUD usuarios" as U1
     }

     package "UC_ACC (9 UCs)" {
       usecase "Asignar funciones"   as AC1
       usecase "Gestionar SoD"       as AC5
     }

     package "UC_PERM (10 UCs)" {
       usecase "Verificar permiso"   as PE7
       usecase "Generar menú\ndinámico" as PE8
     }

     package "UC_RPT (14 UCs)" {
       usecase "Ver dashboard"       as R1
       usecase "Exportar reporte"    as R4
     }

     package "UC_ALR (5 UCs)" {
       usecase "Reconocer alerta"    as AL3
     }

     package "UC_PIP (4 UCs)" {
       usecase "Supervisar ETL"      as P1
       usecase "Solicitar reintento" as P4
     }

     package "UC_AUD (4 UCs)" {
       usecase "Consultar auditoría" as AU1
     }

     package "UC_LOG (7 UCs)" {
       usecase "Consultar logs"      as L1
     }
   }

   Operador   --> A1
   Operador   --> R1
   Supervisor --> R4
   Supervisor --> AL3
   AA         --> AC1
   AA         --> AC5
   AP         --> P1
   AP         --> P4
   Auditor    --> AU1
   @enduml

**Notación de ruta:** un UC dentro de un paquete se referencia
con ``Paquete::UC`` (ej: ``UC_RPT::Ver dashboard``).

----

10. Documentar escenarios — companion textual del diagrama
==========================================================

  El diagrama sólo muestra **qué** UCs existen y cómo se
  relacionan. La **secuencia de pasos** vive en la
  especificación textual del UC.

Ver :doc:`casos-uso-especificacion` para el template
canónico textual.

Cada UC del diagrama tiene su archivo individual en
``source/requisitos/casos-uso/<modulo>/uc-<mod>-<NN>-<desc>.rst``
con flujo, alternativas, precondiciones, postcondiciones y
casos de prueba.

----

11. Flujo completo de análisis
==============================

::

 Fase 1 — Entrevistas con el cliente
   → Diagrama de clases inicial
     (ver: metodologia-analisis-dominio-ucs)

 Fase 2 — Entrevistas con usuarios
   → Diagrama de casos de uso
     ALTO NIVEL (este documento)

 Fase 3 — Profundizar en cada UC
   → Especificación detallada
     (ver: casos-uso-especificacion)
   → Diagrama de casos de uso
     DETALLADO por paquete (este doc)

 Fase 4 — Implementación
   → Diagrama de secuencias
     (ver: diagramas-uml § 5)
   → Diagrama de clases
     (ver: diagramas-uml § 1)
   → Código

----

12. En el proyecto IACT — estructura de diagramas
=================================================

::

 1 diagrama de alto nivel
   - Sistema IACT completo
   - Todos los actores
   - UCs principales agrupados por paquete

 9 diagramas detallados (uno por paquete)
   - UC_AUTH (5 UCs)
   - UC_USR  (4 UCs)
   - UC_ACC  (9 UCs)
   - UC_PERM (10 UCs)
   - UC_RPT  (14 UCs) [crítico]
   - UC_ALR  (5 UCs)
   - UC_PIP  (4 UCs)
   - UC_AUD  (4 UCs)
   - UC_LOG  (7 UCs)

 Diagramas auxiliares en cada UC individual
   - El propio UC + sus inclusiones / extensiones
   - En la sección 4 del archivo
     uc-<mod>-<NN>-<desc>.rst per la plantilla
     :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`

  Total ≈ 10 diagramas master + 1 mini-diagrama por UC
  (97 mini-diagramas).

----

13. Identificar casos de uso es un acto de descubrimiento
=========================================================

Una observación recurrente en la literatura UML:
**identificar casos de uso no es traducir** el
problem statement de manera mecánica — es **descubrir**
lo que el sistema realmente debe hacer. La diferencia
no es semántica: marca cómo se aborda la fase
DISCOVER de un WP.

Por qué importa el encuadre como descubrimiento
-----------------------------------------------

Si los UCs se "leen" del enunciado del problema, dos
riesgos aparecen:

- **Sesgo del autor del enunciado** — los UCs heredan
  los huecos del texto sin cuestionarlos.
- **UCs faltantes** — funcionalidades que el cliente
  da por obvias (y por tanto no escribe) quedan fuera
  del modelo.

Si en cambio se trata como **descubrimiento**, el
equipo:

- **Pregunta** a múltiples actores en lugar de
  parafrasear un único documento.
- **Detecta** UCs que el cliente no había
  enunciado pero claramente necesita.
- **Confronta** supuestos antes de fijarlos en el
  modelo.

Conexión con el flujo THYROX
----------------------------

Este encuadre coincide con **Phase 1 DISCOVER** del
WP: el output canónico no es un resumen del problema,
es una **lista de UCs descubiertos** con su nivel de
confianza marcado (OBSERVABLE / INFERRED / SPECULATIVE,
ver guidelines del cajón).

Los UCs SPECULATIVE no avanzan al gate de
DISCOVER → ANALYZE: hay que **bajarlos** a OBSERVABLE
o INFERRED mediante elicitation adicional, o
descartarlos.

Conexión con el skill ``rm-elicitation``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El skill ``rm-elicitation`` cubre las técnicas
canónicas de descubrimiento — entrevistas,
observación, análisis de documentos, workshops. Cada
una produce UCs candidatos que luego se consolidan en
``rm-analysis``.

La tabla de equivalencia es directa:

.. list-table::
 :widths: 32 32 36
 :header-rows: 1

 * - Técnica
   - Genera
   - Riesgo si se omite
 * - Entrevista a operadores /
     supervisores
   - UCs operativos cotidianos.
   - Faltan UCs que el cliente "no
     enuncia porque son obvios".
 * - Observación de uso real
   - UCs implícitos en el flujo
     diario.
   - Faltan workarounds y
     excepciones reales.
 * - Análisis de documentos
   - UCs formales y regulatorios.
   - Falta el contraste con la
     práctica.
 * - Workshop con stakeholders
   - UCs en disputa o ambiguos.
   - Avanza con supuestos
     contradictorios.

Tres niveles de descubrimiento útiles
-------------------------------------

1. **UCs explícitos** — están en el problem
   statement; se transcriben al modelo.
2. **UCs inferidos** — se deducen de la
   estructura del negocio (todo sistema con login
   requiere logout, todo sistema con audit
   requiere consulta de audit, etc.).
3. **UCs descubiertos** — emergen de
   conversaciones con actores; el cliente no los
   había enunciado, pero los reconoce como
   necesarios al verlos.

Un modelo de UCs maduro contiene **los tres
tipos**. La proporción varía según la madurez del
problem statement: documentos extensos
generalmente sobrerrepresentan los explícitos y
omiten los descubiertos.

Política IACT — descubrimiento de UCs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **No tratar el problem statement como verdad
   completa**. Es un punto de partida.
2. **Validar cada UC con al menos un actor real**
   antes de pasarlo a ``rm-specification``.
3. **Marcar el nivel de confianza** del UC
   (OBSERVABLE / INFERRED / SPECULATIVE) en su
   metadata.
4. **Bloquear el gate** DISCOVER → ANALYZE si hay
   UCs SPECULATIVE en la lista de candidatos
   principales.
5. **Documentar el descubrimiento** —
   ``analyze/`` del WP guarda la evidencia de
   cómo cada UC apareció.

----

14. Dependency entre casos de uso
=================================

Las relaciones de UC más comunes
(``<<include>>``, ``<<extend>>``, generalización)
ya quedaron cubiertas en §§ 5-8. Falta una más en
el catálogo UML: la **dependencia genérica** entre
dos UCs.

Cuándo aparece
--------------

Una **dependencia** es una flecha **punteada sin
estereotipo** entre dos UCs. Indica que la
**existencia o evolución** de un UC depende de la
existencia del otro, **sin** ser una de las
relaciones más fuertes:

- No es ``<<include>>`` — el UC dependiente no
  invoca al otro como subrutina obligatoria.
- No es ``<<extend>>`` — el UC dependiente no
  extiende condicionalmente al otro.
- No es generalización — no comparten estructura
  jerárquica.

Es la relación **más laxa** del catálogo,
equivalente conceptual a la dependencia entre
clases (§ 10 de :doc:`relaciones-uml`).

Sintaxis PlantUML
~~~~~~~~~~~~~~~~~

.. code-block:: text

   UC1 ..> UC2 : depende de

Misma sintaxis que para dependencias entre clases
(``..>``); la diferencia es solo el contexto
(diagrama de UCs vs diagrama de clases).

Cuándo usarla en IACT
~~~~~~~~~~~~~~~~~~~~~

Casos donde un UC depende de otro sin que la
relación sea include / extend / generalización:

- **UC_AUD_03** (consultar audit) **depende** de
  ``UC_AUTH_01`` (login) — no lo invoca, pero la
  ausencia de login deja a UC_AUD_03 sin actor
  válido.
- **UC_RPT_07** (reporte programado) **depende**
  de ``UC_PIP_01`` (carga ETL) — el reporte no
  llama explícitamente al ETL, pero su utilidad
  depende de que ETL haya completado la ventana
  CNST_006/008.
- **UC_ALR_03** (reconocer alerta) **depende** de
  ``UC_ALR_01`` (publicar alerta) — no se puede
  reconocer una alerta inexistente.

Ejemplo IACT
~~~~~~~~~~~~

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — dependency entre UCs (snapshot)

   left to right direction

   actor Supervisor
   actor "Operador ETL" as OETL

   rectangle IACT {
     usecase "UC_PIP_01\nCarga ETL" as PIP01
     usecase "UC_RPT_07\nReporte programado" as RPT07
     usecase "UC_AUTH_01\nLogin" as AUTH01
     usecase "UC_AUD_03\nConsultar audit" as AUD03
   }

   OETL --> PIP01
   Supervisor --> RPT07
   Supervisor --> AUD03

   RPT07 ..> PIP01 : depende de
   AUD03 ..> AUTH01 : depende de
   @enduml

Lectura del diagrama:

- Las flechas continuas representan asociación
  actor → UC.
- Las flechas punteadas (``..>``) sin
  estereotipo representan dependencia entre UCs.
- ``UC_AUD_03 ..> UC_AUTH_01`` se lee:
  "consultar audit depende de login".

Distinción con include
~~~~~~~~~~~~~~~~~~~~~~

La diferencia operativa con ``<<include>>``:

- ``<<include>>`` — el UC base **siempre invoca**
  al UC incluido como parte del flujo nominal.
- Dependencia simple — el UC dependiente
  **necesita que exista** el otro, pero no lo
  invoca paso a paso.

En la práctica IACT: ``UC_RPT_04`` ``<<include>>``
``UC_PERM_07`` (verificar permiso es parte del
flujo de exportar). Pero ``UC_RPT_04 ..>
UC_AUTH_01`` (depende de login porque sin sesión
activa no hay user para verificar).

Cuándo no abusar
~~~~~~~~~~~~~~~~

La dependencia es **la relación más débil**.
Si hay duda entre dependencia simple e
``<<include>>``, casi siempre es ``<<include>>``.
La dependencia genérica es útil para indicar
relaciones **estructurales** que el flujo no
captura, no para sustituir relaciones más
informativas.

Política IACT — dependency entre UCs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Usar dependencia solo cuando ni include
   ni extend ni generalización aplican**.
2. **Etiquetar la flecha** — ``depende de``,
   ``requiere``, ``presupone``. Sin etiqueta
   queda ambigua.
3. **Documentar la naturaleza** de la
   dependencia en el texto adyacente al diagrama,
   especialmente si es temporal (CNST_006/008
   ventana ETL antes de reportes programados) o
   estructural (sesión activa antes de cualquier
   UC autenticado).
4. **No abusar** — si todos los UCs autenticados
   tienen una flecha de dependencia hacia
   ``UC_AUTH_01``, el diagrama satura. Mejor
   declarar la regla globalmente y modelar solo
   las dependencias menos obvias.
5. **Coherencia con § 10 de
   :doc:`relaciones-uml`** — la sintaxis y la
   semántica son las mismas que para dependencia
   entre clases.

Resumen del catálogo de relaciones UC
-------------------------------------

Con § 14 queda cubierto el catálogo completo de
relaciones de casos de uso reconocido en UML:

.. list-table::
 :widths: 28 28 44
 :header-rows: 1

 * - Relación
   - Sintaxis PlantUML
   - Cuándo usar
 * - Asociación actor → UC
   - ``Actor -- UC``
   - Vínculo entre actor y UC.
 * - Asociación dirigida actor → UC
   - ``Actor --> UC``
   - El actor inicia el UC; el UC no inicia al
     actor.
 * - ``<<include>>``
   - ``UC1 ..> UC2 : <<include>>``
   - UC1 invoca a UC2 como parte de su flujo
     nominal.
 * - ``<<extend>>``
   - ``UC1 <.. UC2 : <<extend>>``
   - UC2 extiende condicionalmente a UC1 en
     puntos de extensión.
 * - Generalización
   - ``UC2 --|> UC1``
   - UC2 es una variante / especialización de
     UC1.
 * - Dependencia simple
   - ``UC1 ..> UC2 : depende de``
   - UC1 requiere la existencia de UC2 sin
     invocarlo paso a paso.

----

15. Architecture flow — del problem statement a los casos de uso
================================================================

Antes de modelar UCs uno por uno, conviene tener
una **vista navegacional del sistema completo**:
qué funcionalidades existen, cómo se entra al
sistema, cómo se sale, y qué caminos puede tomar
el usuario entre medio.

Esa vista no es un diagrama de casos de uso
formal — es un **flujo arquitectónico** que actúa
como puente entre el problem statement y el
catálogo de UCs.

15.1 Para qué sirve este flujo
------------------------------

- **Acordar el alcance** con stakeholders no
  técnicos antes de detallar UCs.
- **Identificar UCs faltantes** — un nodo del
  flujo sin UC asociado es señal de huecos en el
  catálogo.
- **Onboarding rápido** — un colaborador nuevo
  entiende qué hace IACT en una imagen.
- **Material para README** y presentaciones de
  alto nivel.

15.2 Anatomía del flujo
-----------------------

Tres bloques canónicos:

1. **Punto de entrada** — cómo un usuario
   accede al sistema (en IACT: ``Login``
   contra LDAP corporativo, ya que no hay
   registro público).
2. **Funcionalidades principales** — los
   grupos de UCs disponibles tras autenticarse,
   uno por cluster del dominio.
3. **Punto de salida** — cómo termina la sesión
   (en IACT: ``Logout`` con caducidad CNST_002 o
   timeout).

15.3 Problem statement IACT — referencia
----------------------------------------

Versión condensada del problem statement de
IACT, útil como referencia cuando un WP necesite
documentar el contexto de alto nivel:

   El sistema IACT ofrece a los **supervisores
   del centro de contacto** una plataforma para
   monitorear la operación, evaluar métricas
   agregadas y reconocer alertas críticas con
   trazabilidad completa.

   Los datos provienen de la **BD operativa** del
   call center (read-only, CNST_007) y de los
   **eventos del IVR** consumidos durante la
   ventana ETL nocturna (CNST_006/008). El sistema
   no escribe en las fuentes operativas; solo
   las consume para construir agregados en
   ``bd_analytics``.

   El acceso se restringe vía **LDAP corporativo**
   (autenticación) y un **catálogo RBAC** propio
   con reglas de **separación de funciones**
   (CNST_030 SoD). Toda acción auditable queda
   registrada **inmutable** en ``audit_log``
   (CNST_025).

   Las notificaciones a los supervisores se
   entregan exclusivamente vía **buzón interno**
   (CNST_001 — sin email, sin canal externo).

Las funciones principales se organizan en siete
clusters: **autenticación**, **gestión RBAC**,
**reportería operativa**, **alertas**,
**monitoreo ETL**, **auditoría** y **buzón
interno**.

15.4 Architecture flow IACT
---------------------------

Vista navegacional condensada — desde la entrada
hasta la salida del sistema, mostrando los
clusters de UCs accesibles:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — Architecture flow (vista navegacional)

   start

   :Login;
   note right
     UC_AUTH_01
     LDAP + sesion unica (CNST_002)
   end note

   if (autenticado?) then ([si])
     :Panel del supervisor;
     note right
       Punto de entrada autenticado.
       Acceso filtrado por RBAC
       (CNST_030 SoD).
     end note

     fork
       :Consultar dashboards
       (UC_RPT_*);
     fork again
       :Reconocer alertas
       (UC_ALR_*);
     fork again
       :Monitorear ETL
       (UC_PIP_*);
     fork again
       :Consultar auditoria
       (UC_AUD_*);
     fork again
       :Gestionar RBAC
       (UC_PERM_*);
     fork again
       :Consultar buzon
       (UC_LOG_*);
     end fork

     :Logout;
     note right
       UC_AUTH_02 o
       caducidad CNST_002
     end note
   else ([no])
     :Registrar intento fallido;
     note right
       Audit (CNST_025) +
       throttling (CNST_011)
     end note
   endif

   stop
   @enduml

Lectura del flujo
~~~~~~~~~~~~~~~~~

- **Una sola entrada** — Login. No hay registro
  público porque los usuarios provienen del
  LDAP corporativo (decisión arquitectónica).
- **Bifurcación tras autenticarse** — el
  supervisor puede operar cualquiera de los seis
  clusters principales. Cada nodo del fork
  agrupa varios UCs del catálogo.
- **Audit transversal** — cualquier rama puede
  generar eventos en ``audit_log``; está
  implícito por CNST_025 y no aparece como nodo
  separado.
- **Salida única** — Logout o caducidad
  automática.

15.5 Cómo usar este patrón en un WP nuevo
-----------------------------------------

Cuando un WP introduce un sub-sistema o
extensión que tiene **vida navegacional propia**
(varios UCs encadenados en un flujo de usuario),
conviene producir un architecture flow propio
antes de los UCs detallados:

1. **Identificar la entrada** al sub-sistema
   (de dónde viene el usuario).
2. **Listar las funcionalidades principales**
   sin entrar en sub-pasos.
3. **Identificar la salida** (terminación
   normal y anormal).
4. **Diagramar el flujo** con un diagrama de
   actividades simple (start → forks → stop).
5. **Mapear cada nodo a su UC** del catálogo —
   nodos sin UC son hallazgos para discutir.

Antipatrones
~~~~~~~~~~~~

- **Diagramas demasiado detallados** — el
  architecture flow no debe tener pasos
  internos de cada UC. Esa profundidad
  pertenece al diagrama de actividades del UC
  individual.
- **Funcionalidades sin nodo de entrada
  claro** — si el flujo no muestra cómo se llega
  a una funcionalidad, hay un hueco
  arquitectónico.
- **Audit como nodo explícito** — el audit es
  transversal en IACT (CNST_025); marcarlo
  como nodo separado satura el flujo.

Política IACT
~~~~~~~~~~~~~

1. **Un architecture flow global por sistema**
   — el de § 15.4 cubre IACT completo.
2. **Architecture flows por sub-sistema**
   solo cuando un sub-cluster tiene navegación
   propia (e.g. flujo de gestión RBAC con su
   wizard de aprobaciones SoD).
3. **El architecture flow se actualiza** cuando
   se agrega un cluster nuevo de UCs o se
   reorganiza el catálogo.
4. **Cada nodo del flujo** debe mapear a uno o
   varios UCs documentados; nodos sin UC son
   deuda.
5. **No reemplaza al diagrama de casos de uso
   formal** — son complementarios. El UC
   diagram describe relaciones entre actor y
   UCs; el architecture flow describe la
   navegación temporal del usuario.

15.6 Relación con otros artefactos del cajón
--------------------------------------------

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Artefacto
   - Qué aporta vs el architecture flow
 * - Diagrama de casos de uso
     (:doc:`casos-uso-diagramas`)
   - Quién usa qué; relaciones include /
     extend / generalización entre UCs.
 * - Diagrama de actividades por UC
     (:doc:`diagramas-actividades`)
   - Detalle interno de cada nodo del
     architecture flow.
 * - Modelo de dominio
     (:doc:`analisis-dominio`)
   - Qué entidades manipula cada
     funcionalidad.
 * - C4 Context view
     (§ 13 de :doc:`diagramas-componentes`)
   - Sistemas externos con los que IACT
     dialoga durante el flujo.

----

16. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skills aplicadas**
   - ``rm-elicitation`` (BABOK Hora 6 + 7 — POV usuario),
     ``rm-specification`` (modelado del UC con UML)
 * - **Origen del documento**
   - Reescrito de "GUÍA-DIAGRAMAS-CASOS-DE-USO-MODELADO"
     (Hora 7 de Schmuller, cheat-sheet aplicado interno con
     dominio ecommerce), reorientado al dominio real IACT.
 * - **Compañero textual**
   - :doc:`casos-uso-especificacion` (Hora 6)
 * - **Lección teórica**
   - :doc:`/base-cognitiva/_uml/uml-07-diagramas-casos-uso`
 * - **Cheat-sheet UML**
   - :doc:`/base-cognitiva/_uml/cuando-usar-cada-diagrama`
 * - **Plantilla canónica de UC**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Ejemplos hermanos**
   - :doc:`diagramas-uml`,
     :doc:`orientacion-objetos`,
     :doc:`analisis-dominio`,
     :doc:`relaciones-uml`,
     :doc:`agregacion-interfaces`
 * - **Catálogo modular del dominio**
   - :doc:`/gestion/evidencia/arquitectura-modular/analisis-catalogo-modular-iact`
 * - **Restricciones citadas**
   - CNST_001 (no email), CNST_008 (ventana ETL),
     CNST_011 (throttling), CNST_017 (SLA),
     CNST_019/020 (export), CNST_025 (auditoría),
     BR_012 (segmento).
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
