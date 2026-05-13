.. meta::
 :artefacto: METODOLOGIA_DIAGRAMAS_COMPONENTES
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
Diagramas de componentes — arquitectura física IACT (H12)
==========================================================

Propósito
=========

Modelar **la estructura física** del sistema IACT: qué
artefactos ejecutables existen, qué interfaces exportan o
importan, y cómo dependen entre sí.

Diferencia con diagramas previos:

- **Clases / OOP** → conceptos en el código fuente.
- **Componentes** → archivos reales en disco/servidor:
  módulos Django, paquetes WSGI, librerías, scripts ETL,
  bases de datos.

Pregunta que responde:

   *¿Cómo se organiza el código y los binarios en los
   servidores de IACT, y qué contratos los unen?*

Marco metodológico
==================

- Skill principal: ``rm-specification``
- Skill complementario: ``rm-analysis``
- Stack canónico: ADR_DEVOPS_001 → Vagrant + Apache +
  ``mod_wsgi`` + Django + MySQL + Redis. **No** Docker, K8s,
  Nginx, Gunicorn.
- Política de diagramación:
  :doc:`/base-cognitiva/plantuml-guide/guidelines`

Preludio — modelar la arquitectura
==================================

Tras documentar el dominio (:doc:`analisis-dominio`) y
visualizar los flujos de aplicación
(:doc:`diagramas-secuencias`), el siguiente paso natural
es **modelar la arquitectura**: cómo los componentes y
nodos físicos se organizan más allá del flujo puntual de
un UC.

La regla operativa, alineada con § 12 de
:doc:`plan-documentacion-uc` (JEDUF):

   *Hacer suficiente diseño inicial para validar el
   enfoque, pero no tanto que no quede espacio para que
   el diseño evolucione.*

Cuando se diseña un sistema, el objetivo no es producir
un plano completo y entregárselo a los implementadores
para que lo "ejecuten". Es **embeberse en el equipo que
lo construye**, buscar feedback regular, evolucionar el
diseño colaborativamente.

Por qué los diagramas-como-código importan aquí
-----------------------------------------------

Antes de PlantUML / Mermaid, cambiar un diagrama
arquitectónico era doloroso: mover cajas, redibujar
líneas, recolocar etiquetas — horas de trabajo manual
para un cambio significativo.

Con **PlantUML + Sphinx** (la combinación IACT) los
diagramas son texto: editarlos en una reunión es
factible, probar una idea toma minutos y, si no aporta,
se descarta sin gran inversión. Esa **agilidad
arquitectónica** es uno de los argumentos más fuertes
para diagramas-como-código (ver "Historia de la
diagramación" en :doc:`diagramas-uml`).

Cuándo usar diagramas de arquitectura
-------------------------------------

Tres usos canónicos en IACT:

1. **README del proyecto / submódulo** — cuando alguien
   llega nuevo o un equipo distinto recibe el sistema,
   un diagrama arquitectónico claro reemplaza páginas
   de documentación textual.
2. **ADRs del proyecto**
   (``.thyrox/context/decisions/``) — al proponer un
   diseño o un cambio mayor, el diagrama itera junto
   con la decisión. Crear un ADR es esencialmente
   proponer una arquitectura.
3. **Onboarding / handoff** — cuando un servicio se
   reasigna entre equipos o ingresa un nuevo
   colaborador, el diagrama de componentes y
   despliegue cuenta la historia que un walkthrough
   verbal tardaría días en transmitir.

Cómo este cajón cubre la arquitectura
-------------------------------------

Tres documentos del cajón colaboran en este nivel:

.. list-table::
 :widths: 28 35 37
 :header-rows: 1

 * - Documento
   - Aspecto
   - Equivale en C4 a…
 * - **Este documento**
     (:doc:`diagramas-componentes`)
   - Apps Django como componentes desplegables y sus
     interfaces.
   - **Component view** (nivel 3 de C4).
 * - :doc:`diagramas-distribucion`
   - Nodos físicos (vm-iact, ldap, bd-operativa,
     ivr-host) y protocolos.
   - **Container / Deployment view** (niveles 2 y
     físico de C4).
 * - El SAD futuro
     (:doc:`plan-documentacion-uc` § 11)
   - Vista holística que integra dominio + flujos +
     componentes + distribución.
   - **Context** + síntesis (nivel 1 + integración).

El **modelo C4** se trata como técnica complementaria
en la sección "Técnica complementaria: el modelo C4"
de :doc:`diagramas-uml`. La política IACT mantiene UML
como técnica principal con C4 como lente para audiencias
no técnicas o material de aprobación.

Mensaje del capítulo
--------------------

A partir de aquí el cajón se centra en la **vista
arquitectónica**. Las secciones siguientes (§§ 1-12 de
este documento + las secciones de
:doc:`diagramas-distribucion`) construyen ese cuadro:
qué componentes existen, qué contratos los unen, dónde
viven y cómo se comunican.

----

1. Qué es un componente en IACT
===============================

Un componente es una pieza física desplegable o referenciada
en el sistema. En el stack IACT los más típicos son:

- Apps Django: ``auth_app``, ``usr_app``, ``acc_app``,
  ``perm_app``, ``rpt_app``, ``alr_app``, ``pip_app``,
  ``aud_app``, ``log_app``.
- WSGI entry point: ``iact.wsgi``.
- Bundle frontend: ``iact-admin.bundle.js``.
- Scripts ETL: ``etl_runner.py``, ``etl_window.cron``.
- Bases de datos físicas: ``bd_operativa`` (read-only),
  ``bd_analytics``, ``audit_log``.
- Servicios de runtime: Apache + ``mod_wsgi``, Redis.
- Integraciones: LDAP corporativo, IVR (read-only).

Una clase OOP de IACT (``Reporte``, ``Sesion``, ``Permiso``)
se materializa como módulo Python dentro de una app Django,
y esa app se distribuye como componente.

2. Interfaces: exportación e importación
========================================

Cada componente IACT define sus interfaces explícitas. Las
relevantes para nuestro dominio:

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Interfaz
   - Operaciones clave
   - Quién la realiza
 * - ``ISecurity``
   - ``verificar_permiso``, ``validar_sesion``,
     ``aplicar_sod``
   - ``perm_app`` (CNST_030)
 * - ``IAuditLog``
   - ``registrar_evento``, ``consultar`` (read-only)
   - ``aud_app`` (CNST_025, immutable)
 * - ``IReporte``
   - ``generar``, ``exportar_async``
   - ``rpt_app`` (CNST_019/020)
 * - ``IAlerta``
   - ``evaluar``, ``publicar``, ``reconocer``
   - ``alr_app``
 * - ``INotificacion``
   - ``enviar_a_buzon`` (CNST_001 — sin email)
   - ``log_app``
 * - ``IDatosOperativos``
   - ``leer`` (read-only, CNST_007)
   - ``bd_operativa``
 * - ``IDatosAnalytics``
   - ``leer``, ``insertar``, ``agregar``
   - ``bd_analytics``
 * - ``IETL``
   - ``ejecutar_ventana`` (CNST_006/008)
   - ``pip_app`` + ``etl_runner``

Regla: un componente IACT **solo** se comunica con otro a
través de una interfaz declarada. Las llamadas directas a
ORM o tablas de otra app rompen el contrato.

3. Vista física global de IACT
==============================

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   skinparam componentStyle rectangle

   package "Cliente (navegador del supervisor)" {
     [iact-admin.bundle.js] as UI
   }

   package "Apache + mod_wsgi" {
     [iact.wsgi] as WSGI
     package "Apps Django" {
       [auth_app]
       [perm_app]
       [rpt_app]
       [alr_app]
       [pip_app]
       [aud_app]
       [log_app]
     }
   }

   package "Datos" {
     database "bd_operativa\n(read-only, CNST_007)" as BDO
     database "bd_analytics" as BDA
     database "audit_log\n(immutable, CNST_025)" as AUDIT
     database "Redis\n(sesiones, throttling)" as REDIS
   }

   package "Integraciones" {
     [LDAP corporativo] as LDAP
     [IVR (read-only)] as IVR
     [etl_runner.py] as ETL
   }

   UI --> WSGI : HTTPS
   WSGI --> auth_app
   WSGI --> perm_app
   WSGI --> rpt_app
   WSGI --> alr_app
   WSGI --> aud_app
   WSGI --> log_app
   auth_app --> LDAP
   auth_app --> REDIS : sesion (CNST_002)
   perm_app --> aud_app : ISecurity → IAuditLog
   rpt_app --> BDA : IDatosAnalytics
   rpt_app --> aud_app
   alr_app --> BDA
   alr_app --> log_app : INotificacion
   pip_app --> ETL
   ETL --> BDO : IDatosOperativos
   ETL --> IVR
   ETL --> BDA : IDatosAnalytics
   aud_app --> AUDIT : IAuditLog
   @enduml

4. Vista detallada con interfaces (lollipop)
============================================

Ejemplo: flujo de exportación de reporte UC_RPT_04.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   skinparam componentStyle rectangle

   [rpt_app] as RPT
   [perm_app] as PERM
   [aud_app] as AUD
   [log_app] as LOG
   database "bd_analytics" as BDA

   PERM -( ISecurity
   AUD  -( IAuditLog
   LOG  -( INotificacion
   RPT  -( IReporte
   BDA  -( IDatosAnalytics

   RPT ..> ISecurity : usa
   RPT ..> IDatosAnalytics : usa
   RPT ..> IAuditLog : usa
   RPT ..> INotificacion : usa (buzon CNST_001)
   @enduml

Lectura: ``rpt_app`` *realiza* ``IReporte`` e *importa*
``ISecurity``, ``IDatosAnalytics``, ``IAuditLog`` e
``INotificacion``. Cualquier cambio interno en ``perm_app``
es transparente para ``rpt_app`` mientras ``ISecurity`` se
mantenga estable.

5. Tipos de componentes en IACT
===============================

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Categoría
   - Qué incluye
   - Ejemplos IACT
 * - **Distribución**
   - Lo desplegado en el VM Vagrant.
   - ``iact.wsgi``, apps Django empaquetadas,
     ``iact-admin.bundle.js``.
 * - **Trabajo**
   - Lo que el desarrollador edita.
   - ``*.py`` de cada app, migraciones,
     ``plantuml-styles.puml``, plantillas RST.
 * - **Ejecución**
   - Lo que se materializa en runtime.
   - Sesiones Redis, archivos temporales de export
     (CNST_019), logs de Apache, ``audit_log`` rows.

6. Sustitución y reutilización
==============================

Casos reales en IACT:

- **Cambiar el origen de datos operativos** (de la BD
  legacy a una réplica): siempre que el nuevo backend
  realice ``IDatosOperativos`` con la misma semántica
  read-only (CNST_007), ``pip_app`` no requiere cambios.
- **Reemplazar el evaluador de alertas** por uno con
  reglas dinámicas: aceptable si sigue realizando
  ``IAlerta`` y respeta el flujo de auditoría
  (UC_ALR_03).
- **Cambiar el mecanismo de notificación** está
  restringido por CNST_001 (solo buzón interno). Cualquier
  implementación que pretenda realizar ``INotificacion``
  via email queda fuera del contrato.

7. Diseño para reutilización en IACT
====================================

Reglas que aplican a este proyecto:

1. Las interfaces se versionan en ``adr-std-*`` cuando
   cambian — no se rompen sin migración explícita.
2. ``aud_app`` y ``perm_app`` son los componentes con más
   consumidores; mantenerlos con superficie mínima y
   altamente cohesiva.
3. ``pip_app`` y ``etl_runner`` deben poder ejecutarse en
   modo dry-run para diagnóstico sin tocar
   ``bd_analytics``.
4. Cada app Django expone su contrato como módulo
   ``services.py`` — nadie consume modelos cruzados
   directamente.
5. Las dependencias prohibidas se documentan en
   ``adr-cross-app-dependencies`` y se validan en CI.

8. Mapeo componente ↔ UCs IACT
==============================

.. list-table::
 :widths: 22 28 50
 :header-rows: 1

 * - Componente
   - Interfaces que realiza
   - UCs principales
 * - ``auth_app``
   - ``IAutenticacion``
   - UC_AUTH_01 Login, UC_AUTH_02 Logout
 * - ``perm_app``
   - ``ISecurity``
   - UC_PERM_07 Verificar permiso, UC_PERM_* SoD
 * - ``rpt_app``
   - ``IReporte``
   - UC_RPT_04 Export, UC_RPT_07 Programado
 * - ``alr_app``
   - ``IAlerta``
   - UC_ALR_03 Reconocer crítica
 * - ``pip_app`` + ``etl_runner``
   - ``IETL``
   - UC_PIP_01 Carga ETL
 * - ``aud_app``
   - ``IAuditLog``
   - Todos los UCs (audit cruzado, CNST_025)
 * - ``log_app``
   - ``INotificacion``
   - UC_RPT_04, UC_ALR_03 (buzón CNST_001)

9. Cuándo usar diagramas de componentes
=======================================

.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Usar cuando…
   - No usar cuando…
 * - Documentamos arquitectura física para deployment.
   - El foco es flujo dinámico (usar secuencias o
     actividades).
 * - Hay riesgo de acoplamiento cruzado entre apps Django.
   - Solo hay un único módulo monolítico sin contratos.
 * - Se evalúa sustituir un proveedor (datos, ETL, alertas).
   - Aún no existe el componente — primero modelar clases.
 * - Se planea un release o despliegue (ver también
     :doc:`/requisitos/_metodologia-aplicacion/index` y, en
     el futuro, diagramas de despliegue).
   - El cambio es solo cosmético en UI.

10. Buenas prácticas
====================

1. Cada componente declara explícitamente sus interfaces
   exportadas e importadas — nada implícito.
2. No mezclar en un mismo diagrama componentes de
   distribución y de trabajo; separar vistas.
3. Etiquetar todas las dependencias con la interfaz
   relevante (``..> ISecurity : usa``).
4. Mantener un único diagrama global de IACT (sección 3) y
   varios diagramas de detalle por subdominio (sección 4).
5. Vincular cada componente a su CNST/BR/ADR principal en
   el texto, no dentro del diagrama.
6. Cuando aparezca un componente externo (LDAP, IVR),
   marcarlo claramente y declarar si es read-only.

11. Patrones de backup desde la perspectiva cohesión/acoplamiento
=================================================================

El backup de datos en IACT (especialmente ``audit_log``,
``bd_analytics`` y configuración del catálogo RBAC) admite
distintos patrones arquitectónicos. Cada uno tiene un perfil
distinto en términos de **cohesión** y **acoplamiento** —
los principios que el documento §§ 10-11 de
:doc:`orientacion-objetos` aplica a clases también valen
para componentes.

11.1 Backup distribuido / descentralizado
-----------------------------------------

Cada componente IACT realiza su propio backup según sus
necesidades. ``aud_app`` exporta ``audit_log``,
``rpt_app`` snapshots agregados, ``pip_app`` registros de
ventana ETL, ``perm_app`` exporta el catálogo RBAC.

Cohesión
~~~~~~~~

Alta cohesión funcional: cada módulo encapsula su lógica
de backup, principio de responsabilidad única por
operación, fácil testing aislado.

Acoplamiento
~~~~~~~~~~~~

Bajo: módulos autónomos, interfaces minimalistas, cambios
localizados, fallos aislados.

Ventajas
~~~~~~~~

- **Inmediatez** — backup disponible justo antes de cada
  cambio, rollback granular, contexto claro.
- **Simplicidad** — directo, autocontenido, pocas
  dependencias.
- **Granularidad** — control preciso por operación,
  trazabilidad de cambios, debugging directo.
- **Resiliencia local** — fallo de un componente no
  afecta backups de otros.

Desventajas
~~~~~~~~~~~

- **Desorganización** — backups dispersos, inventario
  difícil, posible duplicación.
- **Inconsistencia** — formatos y ubicaciones distintos,
  política única difícil de aplicar.
- **Recursos** — espacio fragmentado, overhead por
  múltiples backups, limpieza compleja.
- **Vista global limitada** — recuperar un punto en el
  tiempo del **sistema completo** exige coordinar
  recuperaciones independientes.

11.2 Backup centralizado / monolítico
-------------------------------------

Un único subsistema toma snapshots completos del estado
de IACT (volúmenes MySQL, dumps de Redis, configuración).
Una sola política, una sola programación, una sola fuente
de verdad para restauración.

Cohesión
~~~~~~~~

Alta **cohesión de control** pero responsabilidades
mezcladas: el subsistema toca audit, analytics, RBAC y
sesiones a la vez. Boundaries poco definidos entre lo
que respalda.

Acoplamiento
~~~~~~~~~~~~

Alto: dependencias fuertes con todas las apps Django,
testing extensivo, cambios en el subsistema afectan al
resto.

Ventajas
~~~~~~~~

- **Organización** — estructura clara, política unificada,
  control centralizado.
- **Consistencia** — un único formato, política única.
- **Eficiencia de recursos** — optimización global,
  menos overhead, gestión unificada.
- **Auditoría** — fácil demostrar conformidad con
  CNST_025 / regulaciones — un solo punto de evidencia.

Desventajas
~~~~~~~~~~~

- **Complejidad inicial** — diseño y configuración del
  subsistema más laboriosa.
- **Rigidez** — cambios parciales difíciles, actualización
  global.
- **Punto único de fallo** — si el subsistema cae, ningún
  backup nuevo se hace; requiere redundancia.
- **Escalabilidad limitada** — crecimiento de un
  componente puede saturar el sistema central.

11.3 Backup híbrido
-------------------

Combina distribuido + centralizado: cada app mantiene su
backup local granular para rollback inmediato, y un
subsistema central toma snapshots periódicos consolidados
para política y recuperación de sistema.

Cohesión
~~~~~~~~

**Multinivel**: cohesión modular en cada app + cohesión
de sistema en el orquestador. Separación clara de
concerns; jerarquía de responsabilidades.

Acoplamiento
~~~~~~~~~~~~

**Controlado**: *loose coupling* temporal con
sincronización asíncrona, interfaces bien definidas entre
los dos niveles.

Ventajas
~~~~~~~~

- **Balance** entre inmediatez (local) y orden (central).
- **Resiliencia** — redundancia selectiva, fallback entre
  niveles.
- **Escalabilidad controlada** — cada nivel evoluciona
  según su carga.

Desventajas
~~~~~~~~~~~

- **Complejidad arquitectónica** — diseño inicial más
  elaborado, planificación detallada.
- **Sincronización** — coordinar dos niveles introduce
  estados distribuidos.
- **Costos** — inversión inicial mayor, expertise
  variado, mantenimiento más sofisticado.

11.4 Comparativa
----------------

.. list-table::
 :widths: 22 26 26 26
 :header-rows: 1

 * - Aspecto
   - Distribuido
   - Centralizado
   - Híbrido
 * - Cohesión
   - Alta funcional, por app.
   - Alta de control, mezclada.
   - Multinivel.
 * - Acoplamiento
   - Bajo.
   - Alto.
   - Controlado.
 * - Inmediatez
   - Excelente.
   - Limitada.
   - Buena (capa local).
 * - Política única
   - Difícil.
   - Natural.
   - Por orquestador.
 * - Punto único de fallo
   - No.
   - Sí (mitigable).
   - No (con fallback).
 * - Inversión inicial
   - Baja.
   - Media.
   - Alta.
 * - Adherencia a principios
   - Óptima.
   - Comprometida.
   - Pragmática.

11.5 Recomendación para IACT
----------------------------

- **``audit_log`` (CNST_025 immutable)** — exigir un
  componente de backup **dedicado** y consistente
  (centralizado o capa central del híbrido). El audit
  debe poder restaurarse íntegro y verificarse contra
  hash; la dispersión distribuida lo dificulta.
- **``bd_analytics``** — admite distribuido si cada
  ventana ETL persiste su backup; conviene una capa
  central periódica para recuperación a un punto en el
  tiempo.
- **Catálogo RBAC y reglas SoD (CNST_030)** — backup
  versionado **distribuido** dentro de ``perm_app`` con
  inclusión periódica en el snapshot central; cualquier
  cambio en el catálogo es un evento que debe auditarse.
- **Configuración runtime** (umbrales de alerta,
  parámetros de export) — distribuido, dentro del
  componente que lo posee.

Recomendación general: **híbrido con sesgo distribuido**.
Esto combina la inmediatez y bajo acoplamiento del
distribuido con la consistencia y trazabilidad que
exigen las restricciones del proyecto. Cualquier
desviación (e.g. centralizado puro) debe registrarse en
un ADR de subdominio.

Conclusión de diseño
~~~~~~~~~~~~~~~~~~~~

Desde la perspectiva pura de diseño:

1. **Distribuido** — mejor alineación con cohesión y
   acoplamiento bajo.
2. **Centralizado** — desviación significativa, pero a
   veces inevitable por necesidades operativas.
3. **Híbrido** — balance pragmático para requerimientos
   complejos.

Como con todo patrón, la elección debe considerar no
solo los principios de diseño sino los **requisitos
específicos** del sistema, los recursos y el contexto.
Documentar la elección en un ADR.

----

12. Principios de cohesión y acoplamiento entre componentes
===========================================================

Los principios SOLID (ver §§ 16-20 de
:doc:`orientacion-objetos`) aplican a **clases**. Existe
un conjunto complementario de principios para
**componentes / paquetes**, formulado por Robert C.
Martin. Tres son **principios de cohesión** (qué clases
agrupar dentro de un componente) y tres son **principios
de acoplamiento** (cómo deben relacionarse los
componentes entre sí).

12.1 Principios de cohesión de paquete
--------------------------------------

REP — Reuse / Release Equivalence Principle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   *La granularidad de la reutilización es la misma que
   la granularidad de la liberación. Solo se pueden
   reutilizar efectivamente los componentes que se
   liberan a través de un sistema de seguimiento.*

Implicaciones:

- Una clase rara vez se reutiliza sola; necesita sus
  colaboradoras → liberar el conjunto como **componente**.
- El componente debe tener **número de versión** para
  que los reutilizadores puedan decidir cuándo adoptar
  versiones nuevas.
- Copiar código no es reutilización efectiva; viola DRY
  (§ 13 de :doc:`orientacion-objetos`).

En IACT: cada app Django se libera con su versión
SemVer (ver `metadata-standards.md`); reutilizar
``perm_app`` exige tomar también su catálogo de
funciones, sus modelos y sus servicios — no solo una
clase suelta.

CCP — Common Closure Principle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   *Las clases dentro de un componente liberado deben
   compartir un cierre común. Si una necesita ser
   cambiada, es probable que todas necesiten ser
   cambiadas.*

Es **SRP a nivel de componente**: un cambio típico debe
afectar a **un solo componente**, no a varios.

En IACT: un cambio en CNST_030 (SoD) toca solo
``perm_app``; un cambio en CNST_031 (rango export) toca
solo ``rpt_app``. Si un cambio toca tres apps, hay
agrupación incorrecta.

CRP — Common Reuse Principle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   *Las clases dentro de un componente liberado deben
   reutilizarse juntas. Debe ser imposible separar el
   componente para reutilizar menos que el total.*

Es **ISP a nivel de componente**: si un componente
contiene clases que **no se reutilizan juntas**, sus
consumidores se ven obligados a aceptar versiones
nuevas debido a cambios que no les afectan.

En IACT: ``rpt_app`` solo expone clases que conviven en
todos los reportes; clases que solo aplican a un caso
específico se mueven a un sub-paquete o app distinta.

Tensión entre los tres
~~~~~~~~~~~~~~~~~~~~~~

REP, CCP y CRP **tensionan**:

- REP y CCP empujan a componentes **grandes**
  (todo lo que se reutiliza junto y cambia junto).
- CRP empuja a componentes **pequeños**
  (no obligar a aceptar lo que no se usa).

El equilibrio se ajusta con la madurez del proyecto:
en IACT (proyecto en construcción) **CCP domina** —
agrupar por cierre de cambio. Cuando una app madure y
sea reutilizada externamente, CRP tomará protagonismo.

12.2 Principios de acoplamiento entre paquetes
----------------------------------------------

ADP — Acyclic Dependency Principle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   *La estructura de dependencia entre componentes debe
   ser un Grafo Dirigido Acíclico (DAG). No puede haber
   ciclos.*

Los ciclos son problemáticos:

- Mantenimiento difícil — los cambios se propagan a
  través del ciclo.
- Imposibilidad de liberar componentes en pequeños
  incrementos.

En IACT, las dependencias canónicas forman un DAG:

::

   log_app ←  alr_app  ← rpt_app  ←  ...
                ↓
              aud_app  ← perm_app ← auth_app
                ↑
              pip_app

(El sentido exacto puede consultarse en § 3 de este
documento). Cualquier ciclo entre apps es un defecto a
corregir; típicamente se rompe extrayendo la dependencia
común a una nueva app o invirtiendo con DIP (§ 20 de
:doc:`orientacion-objetos`).

SDP — Stable Dependency Principle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   *Las dependencias deben ir en la dirección de la
   estabilidad. Un componente nunca debe ser más estable
   que aquel del que depende.*

**Métrica de inestabilidad** I:

::

   I = Ce / (Ca + Ce)

donde:

- ``Ca`` = clases externas que **dependen del** componente
  (afferent coupling).
- ``Ce`` = clases externas **de las que el componente
  depende** (efferent coupling).

``I = 0`` → componente máximamente estable; ``I = 1`` →
máximamente inestable.

Las dependencias deben ir de **alto I** a **bajo I**. En
IACT, ``aud_app`` debe ser uno de los componentes con I
más bajo (todos dependen de él, él depende de pocos);
violar esto rompe CNST_025.

SAP — Stable Abstraction Principle
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   *Mientras más estable sea un componente, más debe estar
   compuesto por clases abstractas.*

**Métrica de abstracción** A:

::

   A = (clases abstractas + interfaces) / (total de clases)

``A = 0`` → todo concreto; ``A = 1`` → todo abstracto.

Un componente máximamente estable y máximamente concreto
es **rígido** (cambios duros). Un componente máximamente
abstracto e inestable es **inutilizable**.

Distancia a la secuencia principal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La métrica que combina I y A:

::

   D = | A + I − 1 |
   (rango 0 ≤ D ≤ 1; deseable D ≈ 0)

D ≈ 0 → el componente está en la **secuencia principal**:
estable y abstracto, o inestable y concreto, en
equilibrio.

D lejano de 0 → componente mal balanceado:

- A=0, I=0 (estable y concreto): rígido.
- A=1, I=1 (abstracto e inestable): inútil — abstracción
  sin clientes.

Estos dos extremos son los **dolorosos**.

Cuadrante I/A — interpretación canónica
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Visualizando el plano (eje horizontal = ``I``, eje
vertical = ``A``), las cuatro esquinas tienen lectura
distinta:

.. list-table::
 :widths: 18 18 32 32
 :header-rows: 1

 * - Esquina
   - (I, A)
   - Significado
   - Diagnóstico
 * - **Inferior-izquierda**
   - (0, 0)
   - Máximamente estable y concreto.
   - **Zona de dolor — rígido.** Muchos clientes
     dependen de implementaciones concretas; cualquier
     cambio rompe a todos. Refactorizar a interfaces.
 * - **Superior-izquierda**
   - (0, 1)
   - Máximamente estable y abstracto.
   - **Ideal.** Es lo que queremos para los
     componentes núcleo (``aud_app``, ``perm_app`` con
     sus interfaces ``IAuditLog`` / ``ISecurity``).
 * - **Superior-derecha**
   - (1, 1)
   - Máximamente inestable y abstracto.
   - **Zona de dolor — inutilidad.** Abstracciones
     sin implementación concreta o sin consumidores.
     Borrar o consolidar.
 * - **Inferior-derecha**
   - (1, 0)
   - Máximamente inestable y concreto.
   - Aceptable si es un **componente cliente final**
     (vistas Django, plantillas RST). No debería
     servir de base a otros.

La **secuencia principal** es la diagonal que conecta
(0, 1) con (1, 0): los componentes en esa línea están
balanceados — los estables son abstractos (servir de
base), los inestables son concretos (uso final).

Implicaciones IACT
~~~~~~~~~~~~~~~~~~

- ``aud_app``, ``perm_app`` → meta: cerca de (0, 1).
  Bajo I (todos dependen de ellos), alto A (interfaces
  estables).
- ``rpt_app``, ``alr_app``, ``pip_app`` → meta:
  intermedio. Algunos consumidores, dependen de varias
  interfaces, mezclan abstracto y concreto.
- Vistas Django, templates, plantillas RST → meta:
  cerca de (1, 0). Inestables (cambian con la UI),
  concretas (no son base de nada).
- Cualquier componente que aparezca cerca de (0, 0) o
  (1, 1) durante una medición es candidato a refactor.

Aplicación IACT
~~~~~~~~~~~~~~~

Aplicación recomendada (sin medirla todavía formalmente):

- ``aud_app`` y ``perm_app`` → bajo I (todos los demás
  dependen de ellos), alto A (interfaces ``IAuditLog``,
  ``ISecurity``). D cercano a 0.
- ``rpt_app`` y ``alr_app`` → I medio, A medio. Razonable.
- Vistas Django y plantillas → alto I (dependen de todo),
  A bajo (concretas). D ≈ 0 esperado.

Si en algún momento se mide D y aparece un componente
con D > 0.5, abrir un WP de refactor.

12.3 Resumen
------------

.. list-table::
 :widths: 15 25 60
 :header-rows: 1

 * - Sigla
   - Nombre
   - En una línea
 * - REP
   - Reuse/Release Equivalence
   - Liberar lo que se reutiliza junto.
 * - CCP
   - Common Closure
   - Agrupar lo que cambia por las mismas razones (SRP
     a nivel de componente).
 * - CRP
   - Common Reuse
   - Agrupar lo que se reutiliza junto (ISP a nivel de
     componente).
 * - ADP
   - Acyclic Dependency
   - Sin ciclos entre componentes.
 * - SDP
   - Stable Dependency
   - Las dependencias van hacia los más estables.
 * - SAP
   - Stable Abstraction
   - Los más estables son los más abstractos.

Estos seis principios complementan SOLID a nivel de
arquitectura. Aplicarlos en IACT es la diferencia entre
un conjunto de apps Django **sueltas** y una arquitectura
**modular y mantenible**.

----

13. Vista Context (C4 nivel 1) aplicada a IACT
==============================================

El **diagrama de contexto del sistema** es la vista a
50 000 pies: contiene el **mínimo nivel de detalle** y
es deliberadamente **no técnico**. Su función es
modelar las interacciones entre los usuarios del
sistema y los demás sistemas externos involucrados.

Test de validación
------------------

Una prueba operativa para saber si el nivel de detalle
es el correcto: **mostrarlo a un PM o a alguien no
técnico**. Si pueden entender qué quiere comunicar el
diagrama, está bien. Si necesitan que se les explique
con jerga técnica, hay demasiado detalle — pertenece a
los niveles 2 o 3.

El diagrama Context responde de un vistazo:

- **Quién** usa el sistema (actores).
- **Qué hace** el sistema en el contexto del negocio.
- **Con qué otros sistemas** interactúa para cumplir
  sus responsabilidades.

Tres elementos canónicos
------------------------

1. **Personas** (actores humanos) — quien interactúa
   con el sistema.
2. **El software del sistema** que se está
   diseñando — caja única, sin descomponer.
3. **Software de apoyo** — sistemas externos con los
   que interactúa.

Notación libre — convención IACT
--------------------------------

C4 no impone notación canónica (ver § "C4 no impone
una notación específica" en :doc:`diagramas-uml`). La
convención IACT, alineada con la propuesta de Simon
Brown:

- **Personas** — actor con figura humanoide
  (``actor`` en PlantUML).
- **Sistema en diseño** — caja con borde más grueso o
  color destacado.
- **Sistemas externos** — cajas con color distinto,
  para diferenciarlos visualmente.
- **Flechas** etiquetadas con el **propósito** de la
  interacción, en términos de negocio (no
  protocolo).

Vista Context de IACT
---------------------

Aplicada al sistema completo de IACT, la vista
Context muestra el sistema como una sola caja que
interactúa con sus actores humanos y los sistemas
corporativos externos:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — Vista Context (C4 nivel 1)

   skinparam actorBackgroundColor #E0E7FF
   skinparam rectangleBackgroundColor<<sistema>> #C7D2FE
   skinparam rectangleBorderColor<<sistema>> #1E40AF
   skinparam rectangleBackgroundColor<<externo>> #E0F2F1

   actor Supervisor as S
   actor Auditor as Aud
   actor "Operador ETL" as OETL

   rectangle "IACT\n(Plataforma de analitica\nde call center)" as IACT <<sistema>>

   rectangle "LDAP corporativo" as LDAP <<externo>>
   rectangle "BD operativa\n(call center)" as BDO <<externo>>
   rectangle "IVR-host" as IVR <<externo>>

   S --> IACT : consulta dashboards,\nreconoce alertas
   Aud --> IACT : consulta auditoria,\nverifica SoD
   OETL --> IACT : monitorea ventana ETL

   IACT --> LDAP : autentica usuarios
   IACT --> BDO : lee datos de llamadas\n(read-only)
   IACT --> IVR : lee eventos del IVR\n(read-only)
   @enduml

Lectura del diagrama
--------------------

- **Tres tipos de actor humano** — Supervisor (uso
  cotidiano), Auditor (revisión periódica), Operador
  ETL (monitoreo).
- **Una caja IACT** — el sistema completo, sin
  detallar internamente.
- **Tres sistemas externos**: LDAP corporativo
  (autenticación), BD operativa (origen de datos),
  IVR-host (eventos de telefonía).
- **Flechas etiquetadas en términos de negocio** —
  "consulta dashboards", "lee datos de llamadas",
  no "HTTP GET" ni "SQL SELECT". Esos detalles
  pertenecen al nivel Container.

Lo que el diagrama Context **no** muestra
-----------------------------------------

- Apps Django internas (eso es nivel 3 Component).
- Stack canónico (mod_wsgi, MySQL, Redis) (nivel 2
  Container y físico).
- Protocolos exactos (HTTPS, LDAPS, SQL TCP) (nivel 2
  Container).
- Ciclo de vida de UCs específicos (eso son
  diagramas de secuencia / actividades).
- Restricciones técnicas detalladas (CNST_002 sesión
  única, CNST_006/008 ventana ETL) — solo aparecen
  como notas si son **vinculantes para entender el
  contexto** y a un PM le dicen algo.

Usos del Context en IACT
------------------------

1. **README del repositorio** — primera imagen para
   quien aterriza en el proyecto.
2. **Onboarding** de nuevos miembros (técnicos y no
   técnicos) — entender en 30 segundos qué es IACT y
   con quién dialoga.
3. **Presentaciones a comités** — replicar el sistema
   ante stakeholders sin entrar en stack ni
   topología.
4. **ADRs** que afectan integraciones externas
   (cambiar LDAP, agregar nueva fuente operativa) —
   discutir el cambio en su contexto antes de tocar
   niveles inferiores.

Cuándo crear o actualizar el diagrama Context
---------------------------------------------

- Al inicio del proyecto (ya hecho).
- Cuando aparece o desaparece un **actor humano**
  (e.g., un nuevo rol de auditor externo).
- Cuando aparece o desaparece un **sistema
  externo** (e.g., reemplazo de LDAP por SSO
  corporativo, integración con un nuevo IVR).
- Cuando cambia la **misión del sistema** — raro,
  pero posible si el alcance del producto se
  redefine.

Política IACT
-------------

1. **Una sola caja** para IACT — no descomponer en
   este nivel. Si la audiencia necesita ver apps
   Django, pasar al nivel Component
   (§§ 1-9 de este documento).
2. **Etiquetas en lenguaje del dominio** — sin
   protocolos ni código.
3. **Mantener < 7 elementos** en total (actores +
   sistemas) — más de eso satura la vista a alto
   nivel.
4. **Coherencia con el modelo de dominio**
   (:doc:`analisis-dominio`) — los actores aquí son
   los mismos que aparecen en los UCs.
5. **Actualizar al README** del proyecto cuando
   cambie.

Próximos niveles
----------------

- **C4 nivel 2 Container** → :doc:`diagramas-distribucion`
  detalla los nodos físicos y los protocolos.
- **C4 nivel 3 Component** → §§ 1-9 de este
  documento detallan las apps Django internas y sus
  interfaces.
- **C4 nivel 4 Code** → omitido en IACT (los
  diagramas de clases UML lo cubren naturalmente).

13.1 Construir el diagrama paso a paso — agregar nodos
------------------------------------------------------

La obra citada construye el Context incrementalmente:
primero un nodo (el actor humano), luego el sistema en
diseño, luego los sistemas de apoyo. PlantUML permite
seguir esa misma metodología, con la ventaja de que las
piezas se agregan en pocas líneas.

Convención de Simon Brown — tres líneas por nodo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada nodo del diagrama Context contiene **tres
elementos** según la convención de Brown:

1. **Título** — nombre claro del nodo.
2. **Etiqueta** — el **tipo** del nodo entre corchetes
   (``[Person]``, ``[Software System]``, ``[External
   System]``).
3. **Descripción** — frase breve que describe qué
   representa el nodo.

A nivel Context la etiqueta ``[Software System]`` puede
parecer redundante, pero **mantenerla** asegura
**consistencia** entre los cuatro niveles del modelo
(en el nivel Component aparecen también ``[Container]``,
``[Component]``).

Sintaxis PlantUML para nodos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PlantUML soporta texto multilínea con ``\n`` o con
bloques explícitos. Para mantener legibilidad del
código fuente, preferir ``\n``:

.. code-block:: text

   actor "Supervisor\n[Person]\n\nUsuario que monitorea\nllamadas y reportes" as Supervisor

O con sintaxis multilínea de PlantUML:

.. code-block:: text

   rectangle "IACT\n[Software System]\n\nPlataforma de analitica\nde call center" as IACT

Equivalencia con Mermaid del libro:

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid
   - PlantUML
   - Notas
 * - ``id["título\nlabel\ndescripción"]``
   - ``rectangle "título\n[label]\n\ndescripción" as id``
   - PlantUML separa con ``\n`` igual que Mermaid.
 * - ``flowchart TD``
   - Sin equivalente directo
     (PlantUML decide layout)
   - PlantUML respeta el orden de declaración y la
     dirección de las flechas.

Construcción incremental — IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Paso 1**: declarar el primer actor.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — paso 1: actor

   actor "Supervisor\n[Person]\n\nMonitorea llamadas\ny reportes" as Supervisor
   @enduml

**Paso 2**: agregar el sistema en diseño.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — paso 2: actor + sistema

   actor "Supervisor\n[Person]\n\nMonitorea llamadas\ny reportes" as Supervisor

   rectangle "IACT\n[Software System]\n\nPlataforma de analitica\nde call center" as IACT
   @enduml

**Paso 3**: agregar sistemas externos.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — paso 3: con sistemas externos

   actor "Supervisor\n[Person]\n\nMonitorea llamadas\ny reportes" as Supervisor

   rectangle "IACT\n[Software System]\n\nPlataforma de analitica\nde call center" as IACT

   rectangle "LDAP corporativo\n[External System]\n\nDirectorio de usuarios" as LDAP
   rectangle "BD operativa\n[External System]\n\nDatos del call center\n(read-only)" as BDO
   rectangle "IVR-host\n[External System]\n\nEventos de telefonia\n(read-only)" as IVR
   @enduml

En este punto los nodos están aislados; el siguiente
paso (subsección siguiente) es **conectarlos** con
flechas etiquetadas.

ID corto vs título completo
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como en Mermaid, conviene usar un **ID corto** (alias
PlantUML con ``as``) y reservar el texto largo para el
contenido visible. Esto evita repetir frases largas al
declarar las relaciones:

.. code-block:: text

   ' Mejor:
   rectangle "Servicio de listados\n[Software System]" as LS
   Supervisor --> LS : consulta titulos

   ' Peor:
   "Servicio de listados\n[Software System]" --> ...

Política IACT para nodos del Context
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Tres elementos por nodo** — título + etiqueta
   ``[Person]`` / ``[Software System]`` /
   ``[External System]`` + descripción breve.
2. **Alias cortos con ``as``** — ``LDAP``, ``BDO``,
   ``IVR``, ``IACT``. Evita repetir el texto largo.
3. **Descripción de máximo 2-3 líneas** — el
   diagrama es Context, no documentación.
4. **Coherencia con el dominio** — los actores y
   nombres deben coincidir con :doc:`analisis-dominio`
   y los UCs (``Supervisor``, no
   ``UsuarioFinal``).
5. **Construcción incremental** — declarar los
   actores primero, el sistema después, los externos
   al final. Facilita la lectura del código fuente
   PlantUML y se alinea con la convención del
   capítulo.

13.2 Conectar los nodos
-----------------------

Una vez declarados los nodos (§ 13.1), el siguiente
paso es **conectarlos** con flechas etiquetadas que
indiquen la dependencia o interacción entre ellos.

Sintaxis PlantUML para flechas etiquetadas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PlantUML usa ``-->`` con la etiqueta separada por
``:``:

.. code-block:: text

   Supervisor --> IACT : consulta dashboards,\nreconoce alertas

La sintaxis admite también:

- **Flecha derecha-izquierda**: ``A <-- B``.
- **Línea sin flecha**: ``A -- B``.
- **Línea punteada**: ``A ..> B`` (útil para
  dependencias suaves).
- **Forzar dirección**: ``A -down-> B``,
  ``A -right-> B`` para dirigir el layout.

Equivalencia con Mermaid del libro:

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid
   - PlantUML
   - Notas
 * - ``A-- "etiqueta" -->B``
   - ``A --> B : etiqueta``
   - PlantUML usa ``:`` en lugar de comillas.
 * - ``A-->|"etiqueta"|B``
   - ``A --> B : etiqueta``
   - Equivalente directo.

Convención IACT — etiquetas como dependencias
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como recomienda el libro, en un Context las flechas
modelan **dependencias**: el nodo padre depende de
algo del nodo hijo. La etiqueta describe **qué**
necesita el padre del hijo, no el protocolo ni los
detalles técnicos.

Buenas etiquetas IACT:

- ``consulta dashboards``
- ``autentica usuarios``
- ``lee datos del call center``
- ``recibe eventos del IVR``

Etiquetas a evitar en Context:

- ``HTTPS GET /reportes/04`` (protocolo, no
  Context).
- ``ldap://...`` (URL, no Context).
- ``query analytics_db.sql`` (detalle de
  implementación).

Construcción incremental — IACT (continuación)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Paso 4**: conectar el actor con el sistema en
diseño.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — paso 4: actor conectado al sistema

   actor "Supervisor\n[Person]" as Supervisor
   rectangle "IACT\n[Software System]" as IACT

   Supervisor --> IACT : consulta dashboards,\nreconoce alertas
   @enduml

**Paso 5**: agregar las dependencias del sistema en
diseño hacia los sistemas externos.

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT — paso 5: con sistemas externos conectados

   actor "Supervisor\n[Person]" as Supervisor
   actor "Auditor\n[Person]" as Auditor
   actor "Operador ETL\n[Person]" as OETL

   rectangle "IACT\n[Software System]\n\nPlataforma de analitica\nde call center" as IACT

   rectangle "LDAP corporativo\n[External System]" as LDAP
   rectangle "BD operativa\n[External System]" as BDO
   rectangle "IVR-host\n[External System]" as IVR

   Supervisor --> IACT : consulta dashboards,\nreconoce alertas
   Auditor --> IACT : consulta auditoria,\nverifica SoD
   OETL --> IACT : monitorea ventana ETL

   IACT --> LDAP : autentica usuarios
   IACT --> BDO : lee datos del call center\n(read-only)
   IACT --> IVR : recibe eventos del IVR\n(read-only)
   @enduml

Resultado: el Context diagram completo, equivalente a
la imagen final de la sección "Vista Context de IACT"
de § 13. Cualquier colega técnico o no técnico puede
leerlo y entender quién usa IACT, qué hace y con qué
sistemas dialoga.

Enlaces en nodos del flowchart
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como en los diagramas de clases (§ 16.8 de
:doc:`analisis-dominio`), los nodos del Context pueden
llevar enlaces externos. PlantUML usa ``[[url]]``:

.. code-block:: text

   rectangle "LDAP corporativo\n[External System]" as LDAP [[https://corp.example/ldap-docs]]

Pero la política IACT (§ 16.8 de
:doc:`analisis-dominio`) prefiere mantener las
referencias en el **texto RST adyacente** con
``:doc:`` / ``:ref:``, donde Sphinx valida los
destinos. ``[[url]]`` se reserva para URLs externas
persistentes (RFCs, especificaciones oficiales).

Política IACT para conexiones del Context
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Toda conexión etiquetada** — sin etiqueta el
   diagrama miente sobre la naturaleza de la
   dependencia.
2. **Etiqueta en lenguaje del dominio** — verbos del
   ubiquitous language (consulta, autentica, lee,
   recibe).
3. **Conexiones desde el padre al hijo** — el padre
   depende del hijo. Si la dependencia es mutua,
   modelar dos flechas o usar ``--`` (sin dirección)
   con justificación.
4. **Sin protocolos** en este nivel — pertenecen a
   Container.
5. **Forzar dirección** (``-down->``, ``-right->``)
   solo cuando el layout automático produce cruces.

13.3 Agregar estilo al diagrama Context
---------------------------------------

El estilo no debe agregarse "porque sí", pero en
diagramas C4 el **color es poderoso** para distinguir
visualmente qué representa cada nodo. La paleta de
Simon Brown propone:

- **Personas** — azul oscuro saturado.
- **Sistema en diseño** — azul medio destacado.
- **Sistemas de apoyo / externos** — gris.

Sintaxis PlantUML — estereotipos + skinparam
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PlantUML aplica estilos por **estereotipo**
(``<<stereotype>>`` después del nombre) y los
``skinparam`` configuran apariencia por estereotipo.
Esto es el equivalente directo del ``classDef`` +
``class`` de Mermaid descritos en el libro.

.. code-block:: text

   skinparam rectangleBackgroundColor<<sistema>> #1168bd
   skinparam rectangleFontColor<<sistema>> #ffffff
   skinparam rectangleBorderColor<<sistema>> #0b4884

   skinparam rectangleBackgroundColor<<externo>> #666666
   skinparam rectangleFontColor<<externo>> #ffffff
   skinparam rectangleBorderColor<<externo>> #0b4884

   skinparam actorBackgroundColor #08427b
   skinparam actorFontColor #ffffff
   skinparam actorBorderColor #052e56

   rectangle "IACT" as IACT <<sistema>>
   rectangle "LDAP corporativo" as LDAP <<externo>>

Equivalencia con Mermaid del libro:

.. list-table::
 :widths: 36 36 28
 :header-rows: 1

 * - Mermaid
   - PlantUML
   - Diferencia
 * - ``classDef foo fill:#1168bd,...``
   - ``skinparam rectangleBackgroundColor<<foo>> #1168bd``
   - PlantUML separa color, fuente y borde en
     keys distintas.
 * - ``class node1,node2 foo``
   - ``rectangle ... <<foo>>``
     en cada nodo
   - PlantUML aplica el estereotipo en la
     declaración del nodo.

Centralización en plantuml-styles.puml
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La política IACT (§ 16.7 de :doc:`analisis-dominio` y
§ "Política IACT" en
:doc:`/base-cognitiva/plantuml-guide/guidelines`)
exige que **los skinparam vivan en
`source/_static/plantuml-styles.puml`**, no en cada
diagrama. Eso permite:

- **DRY** — un solo archivo gobierna toda la paleta.
- **Cambios globales** — actualizar la paleta de
  todo el proyecto editando un solo archivo.
- **Diagramas limpios** — el diagrama solo declara
  estereotipos, no skinparam ad-hoc.

Esquema sugerido para C4 en plantuml-styles.puml
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cuando el proyecto adopte C4 sistemáticamente, la
paleta canónica IACT puede vivir en una sección
dedicada del archivo de estilos:

.. code-block:: text

   ' Sección C4 — Simon Brown adaptado a IACT
   skinparam rectangleBackgroundColor<<c4_sistema>> #1168bd
   skinparam rectangleFontColor<<c4_sistema>> #ffffff
   skinparam rectangleBorderColor<<c4_sistema>> #0b4884

   skinparam rectangleBackgroundColor<<c4_externo>> #666666
   skinparam rectangleFontColor<<c4_externo>> #ffffff
   skinparam rectangleBorderColor<<c4_externo>> #0b4884

   skinparam actorBackgroundColor #08427b
   skinparam actorFontColor #ffffff
   skinparam actorBorderColor #052e56

Una vez centralizado, los diagramas Context solo
necesitan declarar los estereotipos:

.. code-block:: text

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT C4 — System Context

   actor "Supervisor\n[Person]" as Supervisor
   rectangle "IACT\n[Software System]" as IACT <<c4_sistema>>
   rectangle "LDAP corporativo\n[External System]" as LDAP <<c4_externo>>

   Supervisor --> IACT : consulta dashboards
   IACT --> LDAP : autentica usuarios
   @enduml

Reglas IACT para estilo en diagramas C4
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **Color complementa**, nunca **sustituye** la
   etiqueta. Un diagrama debe leerse correctamente en
   blanco y negro o impreso.
2. **Estilos centralizados** en
   ``plantuml-styles.puml`` — no skinparam ad-hoc en
   cada diagrama.
3. **Adoptar la paleta de Simon Brown** como base.
   Cualquier desviación se documenta en un ADR.
4. **Estereotipos en cada nodo C4** — ``<<c4_sistema>>``,
   ``<<c4_externo>>`` para fijar el rol visualmente.
5. **Coherencia entre niveles** — la misma paleta
   aplica en Context (este § 13), Container
   (:doc:`diagramas-distribucion`) y Component
   (§§ 1-9 de este documento).

Cuándo añadir un título al diagrama
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Como en § 16.6 de :doc:`analisis-dominio`, todo
diagrama Context publicado lleva título. Para C4 la
convención IACT es:

::

   IACT C4 — System Context
   IACT C4 — Container view
   IACT C4 — Component view (vm-iact)

El prefijo ``IACT C4 —`` lo identifica como vista
arquitectónica; el resto del título indica el nivel
y el alcance.

Recordatorio
~~~~~~~~~~~~

El estilo es **complemento**, no esencia. Un Context
diagram bien construido es legible incluso sin paleta
de colores — los rectángulos, las etiquetas y la
disposición ya cuentan la historia. El color refuerza
el mensaje y facilita la lectura rápida, pero el
diagrama no debe **depender** de él.

13.4 Ejercicio: crear tu propio Context diagram
-----------------------------------------------

La obra citada cierra este capítulo con un ejercicio:
**dibujar un diagrama Context** del proyecto elegido,
para un sistema que se necesite construir o uno con el
que se haya trabajado.

Aplicación a IACT
~~~~~~~~~~~~~~~~~

Como en los ejercicios anteriores
(§§ 15.12 y 16.9 de :doc:`analisis-dominio`,
§ 14 de :doc:`diagramas-secuencias`), en IACT el
ejercicio **ya está realizado**: el diagrama Context
del sistema completo aparece en § 13 (Vista Context
de IACT).

Variantes para nuevos contribuidores
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Quien quiere ejercitar la técnica antes de aplicarla
en un cambio real al proyecto puede:

1. **Reproducir el Context existente** desde cero,
   sin mirar el código fuente PlantUML, validando que
   se entiende cada decisión.
2. **Modelar un Context alternativo** — qué pasaría
   si IACT integrara una nueva fuente operativa
   (e.g., un segundo IVR, un CRM externo). Comparar
   con el actual.
3. **Modelar un sub-sistema** — el cluster de RBAC
   visto como sistema Context propio, con sus
   actores específicos (administrador RBAC,
   auditor SoD) y sus dependencias internas.
4. **Modelar el flujo ETL como sistema** — Context
   con foco en ``etl_runner`` como caja única,
   actores ``Operador ETL`` y ``Supervisor`` (que
   monitorea), sistemas externos ``bd-operativa`` e
   ``ivr-host``.

Variantes para extender el modelo real
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cuando aparezca una iniciativa que **modifique el
contorno del sistema** (nuevos actores, nuevas
integraciones externas, sustitución de un sistema
existente):

1. Abrir un WP en ``.thyrox/context/work/``.
2. **Bocetar** el nuevo Context en ``planttext.com`` o
   en un editor con preview.
3. Discutirlo con stakeholders y refinar.
4. **Actualizar este documento** (§ 13) con el
   nuevo diagrama final.
5. Registrar la decisión en un ADR del subdominio
   afectado.

Plan recomendado para nuevos contribuidores
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Leer §§ 13-13.3 de este documento.
2. Reproducir el Context de IACT desde cero
   (variante 1).
3. Probar la variante 3 (sub-sistema RBAC).
4. Comparar resultado con el equipo.
5. Avanzar al **Container view**
   (:doc:`diagramas-distribucion`) cuando el Context
   esté internalizado.

Próximo capítulo
~~~~~~~~~~~~~~~~

El siguiente nivel del modelo C4 es la **vista
Container**, mucho más detallada que el Context.
Cubre los containers (apps, servicios, bases de
datos, colas) que componen el sistema y los
protocolos entre ellos. En IACT el equivalente vive
en :doc:`diagramas-distribucion` (despliegue) y en
las §§ 1-9 de este documento (componentes y sus
contratos).

----

14. Vista Component (C4 nivel 3)
================================

Tras el Context (§ 13) y el Container
(:doc:`diagramas-distribucion`), el tercer nivel del
modelo C4 es la vista **Component**: una mirada
**hacia adentro** de cada container para identificar
sus **componentes principales** y cómo se relacionan
con los demás containers y sistemas externos.

Qué es un componente en C4
--------------------------

El término "componente" está sobrecargado en la
industria, pero dentro de C4 significa algo
específico: un **agrupamiento de alto nivel** dentro
de un container. En la práctica:

- Un namespace o módulo con responsabilidad propia.
- Una librería o paquete distribuible.
- Una sub-aplicación dentro de un servidor web.

No se modelan **todas** las clases o paquetes — solo
los **bloques de construcción mayores** que el lector
necesita conocer para entender la estructura interna
del container.

Cuándo el Component view aporta valor
-------------------------------------

La guía oficial de C4 lista esta vista como
**opcional**, porque puede quedar **desactualizada
rápidamente** conforme el código evoluciona. La
recomendación práctica:

- **Sí** — para sistemas grandes (monolitos
  modulares) donde los componentes mayores mapean a
  subdominios.
- **Sí** — cuando un container concentra suficiente
  complejidad como para que el lector necesite ver
  sus piezas.
- **No** — para microservicios granulares, donde el
  Container view ya transmite la información útil y
  el servicio interno tiene pocos componentes
  significativos.
- **No** — para componentes de terceros (Redis,
  MySQL, LDAP) que son cajas negras.

Decisión IACT
~~~~~~~~~~~~~

IACT es esencialmente un **monolito modular** Django
desplegado bajo Apache + ``mod_wsgi``: el container
``iact.wsgi`` aglutina varias apps Django (``auth_app``,
``perm_app``, ``rpt_app``, ``alr_app``, ``pip_app``,
``aud_app``, ``log_app``) — cada una con
responsabilidad propia.

Por esa estructura, **el Component view sí aporta
valor**. La realidad es que **§§ 1-9 de este
documento ya constituyen el Component view de IACT**:

- § 3 — vista física global con las apps Django como
  componentes dentro del container ``vm-iact``.
- § 4 — vista detallada con interfaces lollipop
  (``ISecurity``, ``IAuditLog``, ``IReporte``,
  ``IAlerta``, ``INotificacion``,
  ``IDatosOperativos``, ``IDatosAnalytics``,
  ``IETL``).
- §§ 5-8 — clasificación de tipos de componentes,
  sustitución, reutilización y mapeo a UCs.

14.1 Cómo se construye un Component view
----------------------------------------

Las técnicas son las mismas que en el Context y el
Container:

- **Frontera** del container (``package "iact.wsgi"``).
- **Componentes internos** (apps Django,
  estereotipo ``<<c4_component>>``).
- **Containers / sistemas externos** que invocan o
  son invocados por los componentes — quedan **fuera**
  de la frontera.
- **Interacciones etiquetadas** con el propósito.
- **Consistencia de paleta** con los niveles
  anteriores.

Convención de paleta IACT
~~~~~~~~~~~~~~~~~~~~~~~~~

Siguiendo la línea de Brown (azul para sistemas en
foco, gris para externos, verde-azulado para
componentes internos):

.. code-block:: text

   ' En plantuml-styles.puml — sección C4 components
   skinparam rectangleBackgroundColor<<c4_component>> #85bbf0
   skinparam rectangleFontColor<<c4_component>> #000000
   skinparam rectangleBorderColor<<c4_component>> #5d82a8

Los componentes internos quedan en un **azul más
claro** que los containers, para diferenciarlos
visualmente sin cambiar la familia cromática.

14.2 Ejemplo IACT — Component view de iact.wsgi
-----------------------------------------------

El equivalente IACT del ejemplo del libro (componentes
del Web Application container) es la descomposición
de ``iact.wsgi`` en sus apps Django:

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title IACT C4 — Component view (iact.wsgi)

   actor "Supervisor\n[Person]" as Supervisor
   rectangle "Browser\n[Container]" as B <<c4_container>>

   package "iact.wsgi" {
     rectangle "auth_app\n[Django app]\nIdentificacion + sesion" as Auth <<c4_component>>
     rectangle "perm_app\n[Django app]\nPermisos + SoD" as Perm <<c4_component>>
     rectangle "rpt_app\n[Django app]\nReportes" as Rpt <<c4_component>>
     rectangle "alr_app\n[Django app]\nAlertas" as Alr <<c4_component>>
     rectangle "pip_app\n[Django app]\nETL coordinator" as Pip <<c4_component>>
     rectangle "aud_app\n[Django app]\nAuditoria CNST_025" as Aud <<c4_component>>
     rectangle "log_app\n[Django app]\nBuzon CNST_001" as Log <<c4_component>>
   }

   database "Redis\n[Container]" as Redis <<c4_container>>
   database "bd_analytics\n[Container]" as BDA <<c4_container>>
   database "audit_log\n[Container]" as Audit <<c4_container>>
   rectangle "ldap-corporativo\n[External]" as LDAP <<c4_externo>>

   Supervisor --> B
   B --> Auth : POST /login\n[HTTPS]
   B --> Rpt : consultas de reporte\n[HTTPS]
   B --> Alr : reconocer alerta\n[HTTPS]

   Auth --> LDAP : autentica\n[LDAPS]
   Auth --> Redis : sesion (CNST_002)
   Auth ..> Aud : registra acceso

   Rpt --> Perm : verifica permiso
   Rpt --> BDA : lee agregados
   Rpt ..> Log : notifica buzon
   Rpt ..> Aud : registra evento

   Alr --> Perm : verifica permiso
   Alr --> BDA : evalua umbrales
   Alr ..> Aud : registra reconocimiento

   Pip --> BDA : escribe agregados
   Pip ..> Aud : registra ejecucion ETL

   Perm ..> Aud : registra denegado / SoD
   @enduml

Lectura del diagrama
~~~~~~~~~~~~~~~~~~~~

- **Frontera ``iact.wsgi``** agrupa las siete apps
  Django.
- **Componentes** en azul claro
  (``<<c4_component>>``) — siete apps.
- **Containers IACT** fuera (Browser, Redis,
  bd_analytics, audit_log) en azul oscuro
  (``<<c4_container>>``).
- **Sistemas externos** (LDAP) en gris
  (``<<c4_externo>>``).
- **Sync** (``-->``) para llamadas que esperan
  respuesta.
- **Async** (``..>``) para registro de auditoría y
  notificaciones — fire-and-forget vía bus
  Observer.

14.3 Cuándo crear un Component view específico
----------------------------------------------

En IACT, los componentes principales ya están
documentados en §§ 1-9. Crear Component views
adicionales solo cuando:

- Se introduce una **nueva app Django** y se quiere
  documentar su lugar en la arquitectura.
- Una app crece tanto que **internamente** merece
  descomposición — entonces el Component view de
  ese container muestra los sub-componentes.
- Una iniciativa explora **alternativas
  arquitectónicas** (extraer una app a un proceso
  separado, reagrupar funciones).

Para apps de terceros (Redis, MySQL, LDAP, IVR) **no**
se modelan componentes internos — son cajas negras.

14.4 Riesgos y disciplina
-------------------------

El Component view tiene un **riesgo conocido**:
desactualizarse cuando el código evoluciona. Para
controlarlo:

1. **Mantenerlo automático cuando sea posible** —
   parte de los componentes se pueden enumerar desde
   ``INSTALLED_APPS`` de Django.
2. **Atar las actualizaciones a los WPs** que
   cambien el código — un PR que agrega una app
   Django actualiza también este diagrama.
3. **Aceptar la deuda controlada** — si un
   Component view queda 1-2 versiones detrás del
   código, marcarlo con ``status: Borrador`` o
   ``Pendiente de re-validar`` en el frontmatter.
4. **No modelar más detalle del que se mantendrá** —
   un diagrama Component que el equipo no puede
   actualizar es peor que no tenerlo.

Política IACT
~~~~~~~~~~~~~

1. **§§ 1-9 de este documento** son el Component
   view canónico de IACT — actualizarlas cuando
   cambien las apps Django o sus interfaces.
2. **Estereotipo ``<<c4_component>>``** para apps
   Django dentro del container.
3. **Coherencia con el Container view** —
   los containers que cita el Component son los
   mismos que en :doc:`diagramas-distribucion`.
4. **Sin modelar componentes de terceros** —
   Redis, MySQL, LDAP no se descomponen.
5. **Cada cambio en el modelo se acompaña de un PR
   que actualiza este diagrama** — evitar deuda
   estructural.

14.5 Vista Code (C4 nivel 4) — por qué se omite
-----------------------------------------------

El cuarto y último nivel del modelo C4 es la vista
**Code**: un acercamiento aún mayor que muestra las
**clases dentro de cada componente**.

Razón principal para omitirlo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La recomendación general de la comunidad C4 — y la
adoptada por IACT — es **no crearlo manualmente**.
Las razones operan en el mismo eje que las del
Component view, pero con magnitud mucho mayor:

- **Velocidad de cambio** — el código cambia con
  cada commit; un diagrama Code escrito a mano
  queda obsoleto en horas o días.
- **Costo de mantenimiento** — actualizar el
  diagrama tras cada PR consume tanto tiempo como
  mantener el código mismo.
- **Valor decreciente** — el lector que necesita
  ese nivel de detalle puede leer el código
  directamente; el IDE muestra estructura, jerarquía
  y dependencias mejor que un diagrama estático.
- **Riesgo de divergencia** — un diagrama Code
  desactualizado es **peor** que la ausencia de
  diagrama: induce a error.

Alternativa recomendada — generación automática
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Si el proyecto necesita publicar información a
nivel de clases, la práctica recomendada es
**generarla automáticamente** a partir del código
fuente como parte del pipeline de build:

- Herramientas de análisis estático que extraen el
  grafo de clases.
- Plugins Sphinx (``sphinx.ext.inheritance_diagram``,
  ``sphinx-autodoc``) que producen diagramas de
  clases / herencia desde el código Python.
- Plugins PlantUML que aceptan código como entrada
  y generan diagramas (``plantuml-stdlib``).

Estos diagramas **se regeneran** en cada build y por
tanto **no envejecen**. Si IACT alguna vez necesita
publicar un Code view, esa es la ruta correcta —
no escribir PlantUML a mano.

Cómo se cubre el nivel Code en IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En el cajón el conocimiento a nivel de clases vive
en sitios donde tiene **valor pedagógico**, no como
documentación arquitectónica de referencia
permanente:

- :doc:`relaciones-uml` — relaciones entre clases
  canónicas del dominio (asociación, agregación,
  composición, herencia).
- :doc:`agregacion-interfaces` — descomposición
  todo-parte y realización de interfaces.
- :doc:`/base-cognitiva/_uml/index` — teoría UML
  general.
- :doc:`patrones-diseno` — clases que materializan
  patrones GoF / GRASP.

Estos documentos **modelan clases** pero con foco
**didáctico** (cómo se modela, qué decisiones se
toman) o **canónico** (cómo se aplican los patrones
al dominio IACT). No pretenden reflejar el estado
exacto del código en cada momento.

Política IACT — vista Code
~~~~~~~~~~~~~~~~~~~~~~~~~~

1. **No crear vistas Code manuales** como artefactos
   de referencia permanente.
2. **Si se necesita**, generar automáticamente
   desde el código (``sphinx.ext.inheritance_diagram``
   o equivalente) y dejar la generación en el
   pipeline de build.
3. **Los diagramas pedagógicos** de clases (en
   :doc:`relaciones-uml`,
   :doc:`agregacion-interfaces`,
   :doc:`patrones-diseno`) no son Code views — son
   documentación didáctica del dominio y los
   patrones.
4. **Para entender un componente al detalle**, leer
   el código del repositorio. Los IDEs ofrecen
   navegación, refactor y diagrama de clases
   automático.
5. **Cualquier excepción** a estas reglas requiere
   un ADR con justificación clara — el costo de
   mantenimiento de un Code view manual es alto y
   deteriora el resto de la documentación si no se
   mantiene.

Cierre del modelo C4 en IACT
----------------------------

Con esto el cuadro queda completo:

.. list-table::
 :widths: 22 30 48
 :header-rows: 1

 * - Nivel C4
   - Cobertura en IACT
   - Estado
 * - **1 Context**
   - § 13 de este documento
   - Cubierto.
 * - **2 Container**
   - :doc:`diagramas-distribucion`
   - Cubierto.
 * - **3 Component**
   - §§ 1-9 + § 14 de este documento
   - Cubierto.
 * - **4 Code**
   - Omitido — generación automática si se necesita
   - Decisión deliberada (ADR).

El proyecto puede comunicar su arquitectura completa
con los tres niveles cubiertos. El nivel Code queda
disponible para el lector que abre el código —
donde la verdad **siempre está sincronizada**, por
construcción.

----

15. Catálogo consolidado de notaciones
======================================

Tabla índice del documento. Cada componente del
diagrama de componentes con su sintaxis PlantUML,
sección donde se desarrolla y caso IACT.

.. list-table::
 :widths: 22 32 16 30
 :header-rows: 1

 * - Componente
   - Sintaxis PlantUML
   - Sección
   - Caso IACT
 * - Componente
   - ``component "X" as C``
   - § 1
   - ``auth_app``, ``rpt_app``,
     ``aud_app``.
 * - Interfaz proveedora
     (lollipop)
   - ``C -( ISecurity``
   - § 2
   - ``perm_app`` realiza
     ``ISecurity``.
 * - Interfaz requerida
     (socket)
   - ``C ..> ISecurity : usa``
   - § 4
   - ``rpt_app`` consume
     ``ISecurity``.
 * - Puerto
   - ``port`` o atributo
     declarado en la pared
     del componente
   - § 15.2
   - Punto de conexión
     ``rpt_app`` ↔ ``aud_app``.
 * - Artifact (artefacto)
   - ``artifact "Nombre"``
   - § 5
   - ``iact.wsgi``,
     ``etl_runner.py``,
     ``iact-admin.bundle.js``.
 * - Asociación
   - ``A -- B`` o ``A --> B``
   - § 1
   - ``Apache`` -- ``mod_wsgi``.
 * - Realización (clase
     implementa interfaz)
   - ``C ..|> IFace``
   - § 4
   - ``perm_app`` ``..|>``
     ``ISecurity``.
 * - Dependencia
   - ``A ..> B``
   - § 4
   - ``rpt_app ..> aud_app``.
 * - Estereotipo C4
   - ``<<c4_container>>``,
     ``<<c4_component>>``,
     ``<<c4_externo>>``
   - §§ 13-14
   - Notación canónica de
     niveles 1-3 de C4.

15.2 Notaciones complementarias — puerto
----------------------------------------

Un **puerto** es un punto de comunicación
explícito en la frontera de un componente. En la
notación UML clásica se dibuja como un pequeño
cuadrado en el borde, identificado con un nombre.

PlantUML acepta puertos con la palabra clave
``port`` dentro de un componente, o como
elementos al borde:

.. code-block:: text

   component RptApp {
     port p_audit
     port p_perm
   }
   component AudApp
   component PermApp

   p_audit -- AudApp
   p_perm -- PermApp

En IACT los puertos se materializan en la práctica
como **endpoints HTTP internos** o como
**funciones públicas de ``services.py``** —
PlantUML los hace explícitos cuando conviene
mostrar el punto de conexión exacto.

----

16. Galería de ejemplos canónicos IACT — Component Diagram
==========================================================

16.1 Componente simple
----------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   component "auth_app" as Auth
   @enduml

16.2 Componente con interfaz proveedora (lollipop)
--------------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "perm_app" as Perm
   Perm -( ISecurity
   @enduml

16.3 Interfaz requerida (socket)
--------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "rpt_app" as Rpt
   interface ISecurity

   Rpt ..> ISecurity : usa
   @enduml

16.4 Componente con puertos
---------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "rpt_app" as Rpt {
     port p_audit
     port p_perm
   }
   component "aud_app" as Aud
   component "perm_app" as Perm

   p_audit -- Aud
   p_perm -- Perm
   @enduml

16.5 Artifact dentro de un componente
-------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "iact.wsgi" {
     artifact "auth_app" as Auth
     artifact "perm_app" as Perm
     artifact "rpt_app" as Rpt
   }
   @enduml

16.6 Asociación bidireccional entre componentes
-----------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "Apache" as A
   component "mod_wsgi" as W

   A -- W : carga / ejecuta
   @enduml

16.7 Realización de interfaz
----------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   interface ISecurity
   component "perm_app" as Perm

   Perm ..|> ISecurity : implementa
   @enduml

16.8 Dependencia entre componentes
----------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "rpt_app" as Rpt
   component "aud_app" as Aud

   Rpt ..> Aud : registra eventos\n(CNST_025)
   @enduml

16.9 Vista combinada — proveedor + consumidor
---------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   component "perm_app" as Perm
   component "rpt_app" as Rpt
   interface ISecurity

   Perm ..|> ISecurity : implementa
   Rpt ..> ISecurity : usa
   @enduml

16.10 Plantilla — vista de componentes IACT
-------------------------------------------

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml
   title Vista de componentes — <subdominio>

   package "iact.wsgi" {
     component "<app principal>" as Main
     component "<app dependencia>" as Dep
     interface IContrato
   }

   component "<sistema externo>" as Ext

   Dep ..|> IContrato : implementa
   Main ..> IContrato : usa
   Main ..> Ext : <protocolo>
   @enduml

16.11 Cómo usar la galería
--------------------------

1. Localizar el componente en § 15.
2. Copiar el snippet (§§ 16.1-16.9) o usar la
   plantilla (§ 16.10).
3. Adaptar nombres, interfaces y protocolos al
   subdominio.
4. Anclar dependencias a CNST/BR cuando aplique
   (CNST_025 audit, CNST_001 buzón, CNST_030 SoD).
5. Integrar al documento del cluster o del UC.

Mantenimiento
~~~~~~~~~~~~~

- Cada notación nueva en § 15 requiere su mini-
  diagrama en § 16.
- Mantener cada snippet ≤ 5 componentes.
- Si la vista necesita más componentes, modelar
  una vista por subdominio (RBAC, ETL,
  Reportería, Auditoría) y combinar con
  ``package`` (§ 5).

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
 * - **Diagramas hermanos**
   - :doc:`diagramas-secuencias`,
     :doc:`diagramas-colaboraciones`,
     :doc:`diagramas-actividades`
 * - **Stack canónico**
   - ADR_DEVOPS_001 (Vagrant + Apache + mod_wsgi + Django
     + MySQL + Redis)
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Teoría UML**
   - :doc:`/base-cognitiva/_uml/index`
