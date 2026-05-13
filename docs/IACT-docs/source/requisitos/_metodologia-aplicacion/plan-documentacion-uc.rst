.. meta::
 :artefacto: PLAN_DOC_UC_UML
 :tipo: Plan
 :dominio: gestion
 :subdominio: pm
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==============================================================
Plan de documentación de UCs con diagramas UML (PlantUML)
==============================================================

.. note::

 Plan de trabajo para documentar los **97 casos de uso** del
 proyecto IACT en **13 documentos temáticos**, cada uno
 incluyendo diagramas UML en **PlantUML** (no Mermaid — política
 del proyecto per
 :doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`
 + :doc:`/base-cognitiva/plantuml-guide/guidelines`).

 Aplica skill ``pm-planning`` (PMBOK Planning).

----

1. Objetivo
===========

Crear **13 documentos** que especifiquen los **97 casos de uso**
del proyecto IACT con diagramas UML completos en PlantUML, usando
los estilos centralizados del proyecto.

Cada documento agrupa los UCs por dominio funcional (acceso,
catálogo, órdenes, pagos, logística, etc.) y aplica la plantilla
canónica
:doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`.

----

2. Contexto y origen
====================

Este plan reemplaza la propuesta original "GUÍA DE INTEGRACIÓN
UML v2.0.0 con Mermaid" (interna), adaptándola a la convención
PlantUML del proyecto. Los 97 UCs y la distribución temática se
preservan; cambia únicamente la herramienta de diagramación.

----

3. Tipos de diagramas obligatorios
==================================

Cada UC documentado debe incluir, según aplique, los siguientes
tipos de diagrama (todos en PlantUML):

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - Tipo de diagrama
   - Cuándo es obligatorio
 * - **Casos de uso**
   - Siempre.
 * - **Estados**
   - Si el UC modifica el estado de una entidad observable.
 * - **Secuencias**
   - Si interactúan ≥ 3 componentes (frontend, backend, BD,
     APIs externas).
 * - **Actividades**
   - Si el flujo principal tiene decisiones, ramas o
     concurrencia.
 * - **Clases**
   - Si el UC introduce o modifica entidades del modelo de
     datos.
 * - **Componentes**
   - En docs consolidados (DOC-26).
 * - **Distribución**
   - En docs consolidados (DOC-26).
 * - **Colaboraciones**
   - Cuando aporta clarificación adicional al diagrama de
     secuencias.

Plantilla canónica:
:doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`.

----

4. Distribución de los 13 documentos
====================================

.. list-table::
 :widths: 8 22 12 58
 :header-rows: 1

 * - Doc
   - Dominio (UCs)
   - # UCs
   - Diagramas previstos
 * - **DOC-14**
   - UC_ACC (Acceso / Autenticación)
   - 12
   - UC, Estados, Secuencias, Clases
 * - **DOC-15**
   - UC_CAT (Catálogo)
   - 13
   - UC, Actividades, Secuencias
 * - **DOC-16**
   - UC_CAR (Carrito)
   - 6
   - UC, Estados, Secuencias
 * - **DOC-17**
   - UC_ORD (Órdenes) **[CRÍTICO]**
   - 8
   - UC, Estados, Secuencias [MEGA]
 * - **DOC-18**
   - UC_PAG (Pagos — Stripe)
   - 7
   - UC, Secuencias [Stripe]
 * - **DOC-19**
   - UC_LOG (Logística)
   - 8
   - UC, Colaboraciones, Secuencias
 * - **DOC-20**
   - UC_REP + UC_NOT (Reportes + Notificaciones)
   - 13
   - UC, Actividades, Secuencias
 * - **DOC-21**
   - UC_FAV + UC_REV (Favoritos + Reviews)
   - 10
   - UC, Estados, Clases
 * - **DOC-22**
   - UC_PRO + UC_INV (Promociones + Inventario)
   - 12
   - UC, Actividades, Clases
 * - **DOC-23**
   - UC_ADM (Administración)
   - 8
   - UC, Clases, Actividades
 * - **DOC-24**
   - Clases consolidadas (cross-dominio)
   - —
   - Diagrama de clases COMPLETO integrado
 * - **DOC-25**
   - Secuencias críticas
   - —
   - 5 diagramas de secuencias de UCs críticos
 * - **DOC-26**
   - Componentes + Distribución
   - —
   - Componentes (arquitectura) + Deployment (despliegue)
 * - **TOTAL**
   - 10 dominios + 3 docs cross
   - **97 UCs**
   - 13 documentos

----

5. Ubicación de los documentos generados
========================================

Los 13 documentos viven dentro de
``source/requisitos/casos-uso/<modulo>/`` cada uno como
``uc-<mod>-<NN>-<desc>.rst`` per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`.

Los 3 docs cross (DOC-24..26) se ubican en:

- **DOC-24** (clases consolidadas):
  ``source/arquitectura-tecnica/modelo-clases-consolidado.rst``
- **DOC-25** (secuencias críticas):
  ``source/arquitectura-tecnica/secuencias-criticas.rst``
- **DOC-26** (componentes + deployment):
  ``source/arquitectura-tecnica/componentes-y-distribucion.rst``

Los 10 docs por dominio (DOC-14..23) generan **N archivos UC
individuales** dentro de su submódulo, no un único archivo
monolítico. Por ejemplo, DOC-14 (UC_ACC) produce 12 archivos
``casos-uso/access/uc-acc-NN-*.rst``.

----

6. Política de diagramación
===========================

- **Herramienta:** PlantUML (no Mermaid). Decisión del proyecto.
- **Estilos centralizados:** todos los diagramas inician con
  ``!include ../../_static/plantuml-styles.puml`` (ajustar la
  profundidad relativa según ubicación del archivo).
- **Conversión Mermaid → PlantUML:** cuando se reciba contenido
  fuente en Mermaid, aplicar la tabla de mapeo de
  :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
  § 4.

----

7. Roadmap de ejecución (por orden recomendado)
===============================================

Orden sugerido por **dependencia y criticidad**:

1. **DOC-14** (UC_ACC) — base de seguridad, todos los demás UC
   dependen de tener auth resuelta.
2. **DOC-23** (UC_ADM) — administración, necesaria para que los
   UC operativos tengan datos.
3. **DOC-15** (UC_CAT) — catálogo, base para carrito/órdenes.
4. **DOC-22** (UC_PRO + UC_INV) — promociones e inventario,
   dependen de catálogo.
5. **DOC-16** (UC_CAR) — carrito, depende de catálogo.
6. **DOC-17** (UC_ORD) — órdenes [CRÍTICO], depende de
   carrito + inventario.
7. **DOC-18** (UC_PAG) — pagos, integra Stripe, depende de
   órdenes.
8. **DOC-19** (UC_LOG) — logística, depende de órdenes.
9. **DOC-20** (UC_REP + UC_NOT) — reportes/notificaciones,
   transversal post-órdenes.
10. **DOC-21** (UC_FAV + UC_REV) — favoritos y reviews,
    independiente de órdenes.
11. **DOC-24** (clases consolidadas) — al cierre, integra
    todos los modelos.
12. **DOC-25** (secuencias críticas) — al cierre, integra
    interacciones cross-dominio.
13. **DOC-26** (componentes + distribución) — al cierre,
    arquitectura física.

----

8. Estimación
=============

.. list-table::
 :widths: 35 25 40
 :header-rows: 1

 * - Bloque
   - UCs
   - Esfuerzo estimado
 * - DOC-14..23 (UC operativos)
   - 97
   - ~1.5–2 h por UC × 97 = **145–195 h**
 * - DOC-24 (clases consolidadas)
   - —
   - ~8–12 h
 * - DOC-25 (secuencias críticas)
   - —
   - ~6–10 h
 * - DOC-26 (componentes + dist.)
   - —
   - ~10–15 h
 * - **Total**
   -
   - **~170–230 horas**

Estimación basada en complejidad media + diagramas previstos.
Ajustar al primer DOC completado para recalibrar.

----

9. Criterios de aceptación por documento
========================================

Cada UC documentado debe cumplir:

1. ✓ Metadata canónica (per STD-007 + plantilla canónica).
2. ✓ Diagrama de casos de uso PlantUML embebido.
3. ✓ Diagramas adicionales según matriz § 3 de este plan.
4. ✓ Secciones completas: precondiciones, flujo principal,
   flujos alternativos, postcondiciones, reglas, excepciones,
   casos de prueba.
5. ✓ Trazabilidad bidireccional: BReq origen, BR aplicables,
   FRs derivados.
6. ✓ Build Sphinx limpio (0 warnings) tras agregar el archivo.
7. ✓ **Análisis OOP completo** per
   :doc:`/normativa/estandares/metodologia-oop-para-ucs` —
   documentar las seis dimensiones (abstracción,
   encapsulamiento, herencia, polimorfismo, envío de mensajes,
   asociaciones) y aprobar el checklist § 6 de la metodología.
8. ✓ **Análisis de dominio completo** per
   :doc:`/normativa/estandares/metodologia-analisis-dominio-ucs`
   — extracción de sustantivos→clases, verbos→operaciones,
   adjetivos→atributos; clases asignadas a un paquete UML;
   restricciones documentadas. Aprobar el checklist § 8 de la
   metodología.

----

10. Riesgos y mitigaciones
==========================

.. list-table::
 :widths: 30 35 35
 :header-rows: 1

 * - Riesgo
   - Impacto
   - Mitigación
 * - Conversión Mermaid → PlantUML genera errores semánticos
   - Diagrama incorrecto, decisiones técnicas mal informadas
   - Validar visualmente cada diagrama tras conversión; usar
     plantilla canónica
 * - 97 UCs es alcance grande; riesgo de inconsistencia entre
     docs
   - Vocabulario divergente, refs rotas
   - Aplicar plantilla canónica estrictamente; revisión
     cruzada cada 10 UCs
 * - Cambios en el modelo de datos durante la documentación
   - Diagramas de clases obsoletos
   - Postergar DOC-24 al final; usar refs
     ``:doc:`` para que actualicen automáticamente
 * - Dependencias inter-UC no detectadas hasta DOC-25
   - Re-trabajo en docs ya cerrados
   - Generar DOC-25 incrementalmente conforme cierren los UCs
     críticos (no esperar al final)

----

11. SAD — Software Architecture Document (complemento al SRS)
=============================================================

El plan de documentación cubre los **requisitos** (qué debe
hacer el sistema). Pero los **97 UCs documentados forman el
SRS** (*Software Requirements Specification*); ese SRS no
captura todas las decisiones arquitectónicas del proyecto.
El complemento natural es un **SAD** (*Software
Architecture Document*).

Por qué un SAD además del SRS
-----------------------------

1. **Propósito específico** — el SAD captura decisiones
   arquitectónicas, patrones de diseño y detalles de
   implementación que no corresponden al SRS pero son
   esenciales para el desarrollo.
2. **Complemento natural al SRS** — el SRS define **qué**
   hace el sistema; el SAD define **cómo** se construye.
   Es el puente entre requisitos e implementación.
3. **Audiencia técnica** — el SAD se orienta al equipo de
   desarrollo; usa terminología técnica y profundiza en
   aspectos de implementación que serían excesivos en un
   SRS dirigido a stakeholders.
4. **Valor a largo plazo** — sirve como referencia durante
   todo el ciclo de vida: mantenimiento, extensiones,
   onboarding de nuevos desarrolladores.
5. **Estándar reconocido** — existen plantillas
   establecidas (IEEE 1471, enfoque **4+1** de Kruchten)
   que estructuran la documentación de arquitectura.

Qué cubre el SAD que el SRS no cubre
------------------------------------

En IACT el SAD es el lugar adecuado para detallar:

- **Patrones de diseño específicos** — Factory, Strategy,
  Adapter, Decorator, Observer, Facade aplicados a las
  apps Django (ver :doc:`patrones-diseno`).
- **Mecanismos internos** — bus de eventos para audit,
  política de sesiones en Redis, throttling con ventana
  deslizante, ventana ETL.
- **Diagramas de secuencia y flujos de interacción** —
  ver :doc:`diagramas-secuencias`,
  :doc:`diagramas-colaboraciones`,
  :doc:`diagramas-actividades`.
- **Decisiones técnicas específicas** — registradas como
  ADRs en ``.thyrox/context/decisions/`` y agrupadas en
  el SAD.
- **Vista física** — :doc:`diagramas-componentes`,
  :doc:`diagramas-distribucion`.
- **Restricciones técnicas y de negocio** — CNST_* / BR_*
  y su impacto arquitectónico.

Diferencia con un documento de diseño detallado
-----------------------------------------------

Un **diseño detallado** se enfoca a nivel de componente
específico (qué clases tiene, qué atributos, qué métodos);
un **SAD** ofrece visión holística de la arquitectura. En
IACT, el diseño detallado se distribuye en cada UC y en los
documentos OOP/relaciones del cajón
``_metodologia-aplicacion/``; el SAD agrupa, integra y
contextualiza esas piezas a nivel de sistema.

Recomendación para IACT
-----------------------

Cuando los 97 UCs estén documentados, abrir un WP para
construir el SAD usando como base:

- ``_metodologia-aplicacion/`` (este cajón) — todo el
  modelado UML aplicado a IACT.
- ``.thyrox/context/decisions/`` — ADRs vivos del
  proyecto.
- Las restricciones canónicas (CNST_*) y reglas de
  negocio (BR_*).

Estructura sugerida — modelo 4+1 de Kruchten
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El modelo original **4+1** de Philippe Kruchten (1995):

- **Vista lógica** *(logical view)* — clases, OOP,
  relaciones (ya cubierto parcialmente en este cajón).
- **Vista de procesos** *(process view)* — concurrencia,
  ETL, alertas, exports async (CNST_019/020).
- **Vista de desarrollo** *(development view)* — apps
  Django, packaging, versionado.
- **Vista física** *(physical view)* —
  :doc:`diagramas-componentes` +
  :doc:`diagramas-distribucion`.
- **+1: Escenarios / Casos de uso** — UCs críticos que
  ejercitan las cuatro vistas (UC_AUTH_01, UC_RPT_04,
  UC_PIP_01, UC_ALR_03).

Variante 5+1 — añade Modelo de Dominio
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Una variante práctica posterior, **5+1**, agrega
explícitamente la **Vista de Dominio** (*domain model*) a
las cinco vistas anteriores. No tiene autor único
reconocido; surgió en entornos que enfatizan
*Domain-Driven Design* y métodos OOP, donde la vista de
dominio adquiere relevancia propia. Su estructura típica:

1. **Modelo de Dominio** — entidades, relaciones,
   reglas de negocio del dominio.
2. **Vista de Diseño** — clases y relaciones lógicas.
3. **Vista de Implementación** — paquetes, módulos,
   estructura de código.
4. **Vista de Casos de Uso** — escenarios funcionales.
5. **Vista de Procesos** — concurrencia y ejecución.
6. **Vista de Despliegue** — nodos físicos y
   protocolos.

Cuándo usar 5+1 en vez de 4+1 en IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adoptar **5+1** si el SAD necesita aislar explícitamente:

- Vocabulario y reglas del dominio del centro de
  contacto (segmento BR_012, ventana ETL CNST_006/008,
  SoD CNST_030).
- Aprendizajes consolidados de
  :doc:`analisis-dominio` (sustantivos→clases, RDD,
  CRC) que justifiquen una vista propia.

En la práctica, este cajón ``_metodologia-aplicacion/``
ya provee buena parte del material para la **vista de
dominio** del modelo 5+1. El SAD definitivo decidirá
entre 4+1 (más liviano) y 5+1 (con vista de dominio
explícita) según el alcance final.

Mapeo vista ↔ diagramas UML
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Algunos diagramas aparecen en **varias vistas** porque se
usan con distinto nivel de detalle o enfoque. Por ejemplo,
el diagrama de clases aparece en *Domain Model* y en
*Design View*: en la primera es más conceptual, en la
segunda incluye detalles de implementación. Los diagramas
de comportamiento e interacción típicamente cruzan vistas
porque muestran aspectos distintos del mismo sistema.

.. list-table::
 :widths: 25 25 25 25
 :header-rows: 1

 * - Vista
   - Foco
   - Diagramas UML típicos
   - Documentos IACT
 * - **Domain Model / Logical View**
   - Funcionalidad para usuarios finales; abstracciones y
     mecanismos del dominio.
   - Clases (conceptual), objetos, estados.
   - :doc:`analisis-dominio`,
     :doc:`orientacion-objetos`,
     :doc:`relaciones-uml`,
     :doc:`diagramas-estados`
 * - **Design View**
   - Cómo el sistema resuelve los requisitos
     técnicamente; componentes y subsistemas.
   - Clases (con detalles de diseño), secuencia,
     colaboración, estados.
   - :doc:`agregacion-interfaces`,
     :doc:`diagramas-secuencias`,
     :doc:`diagramas-colaboraciones`,
     :doc:`patrones-diseno`
 * - **Implementation View**
   - Organización real del código; reutilización,
     restricciones, gestión.
   - Componentes, paquetes.
   - :doc:`diagramas-componentes`
 * - **Use Case View**
   - Comportamiento del sistema; une todas las otras
     vistas.
   - Casos de uso, actividades.
   - :doc:`casos-uso-especificacion`,
     :doc:`casos-uso-diagramas`,
     :doc:`diagramas-actividades`
 * - **Process View**
   - Concurrencia, sincronización, rendimiento,
     escalabilidad, throughput.
   - Actividades, secuencia, tiempo (cuando aplique).
   - :doc:`diagramas-actividades`,
     :doc:`diagramas-secuencias`,
     :doc:`diagramas-tiempo` (preliminar)
 * - **Deployment View** (a veces parte de Physical)
   - Distribución física, comunicación, provisión.
   - Despliegue.
   - :doc:`diagramas-distribucion`

Lectura: el SAD que se construya tras los 97 UCs no debe
generar diagramas nuevos para cada vista; debe **integrar**
los diagramas ya producidos en este cajón asignando cada
uno a la vista que corresponda. Eso asegura coherencia y
evita duplicación (DRY, ver § 13 de
:doc:`orientacion-objetos`).

Este SAD no es objeto de este plan; queda registrado como
trabajo futuro recomendado tras el cierre de los 97 UCs.

----

12. JEDUF — Just Enough Design Up Front
=======================================

Cuánto diseño completar **antes** de empezar a codificar
es una pregunta operativa para este plan: 97 UCs es un
alcance grande y el riesgo de planificar de más (BDUF) o
de menos ("desarrollo de vaqueros") es real.

12.1 Las dos posiciones extremas
--------------------------------

Tres factores empujan hacia **diseñar todo antes**:

1. Los cambios de diseño son más difíciles y costosos
   una vez que se ha escrito código.
2. Arquitectos y diseñadores suelen estar más calificados
   para tomar decisiones; concentrar el trabajo de
   diseño en pocas personas evita retrabajo masivo.
3. Algunas decisiones de diseño generales son requisito
   previo para cualquier desarrollo paralelo.

Si solo se consideran estos tres factores, se llega a
**Big Design Up Front (BDUF)**: todo el diseño en
modelos y documentos antes de escribir una línea de
código.

Siete factores empujan hacia **diseñar a medida que se
codifica**:

4. La sabiduría de un diseño solo se valida con software
   funcionando.
5. Trabajo posterior se beneficia de la experiencia y
   habilidades del equipo más amplio.
6. El equipo aprende sobre el problema mientras avanza —
   decisiones postergadas aprovechan ese aprendizaje.
7. Las decisiones tempranas se basan en supuestos
   erróneos o condiciones que cambian.
8. El diseño temprano tiende a agregar funcionalidades
   que luego resultan innecesarias (de ahí el principio
   ágil **YAGNI** — *You Aren't Gonna Need It*).
9. Los desarrolladores se involucran más cuando tienen
   autonomía para tomar algunas decisiones de diseño.
10. Si el diseño crece sin que ningún elemento se valide
    en código, la cantidad de elementos no válidos
    incorporados puede ser demasiado para corregir.

Si solo se consideran los siete últimos, se cae en
**desarrollo de vaqueros**: disparar desde la cadera sin
arquitectura inicial.

12.2 La síntesis: JEDUF
-----------------------

**JEDUF (Just Enough Design Up Front)** equilibra ambos
extremos: hacer **el suficiente** trabajo de diseño
temprano para empezar bien, pero permitir que el diseño
completo emerja a medida que el trabajo avanza.

Este equilibrio se basa en la observación de que algunos
aspectos emergerán naturalmente y la capacidad de
respuesta al cambio es más valiosa que un plan detallado.

12.3 Cinco áreas de arquitectura inicial
----------------------------------------

Las primeras etapas del diseño se llaman *arquitectura*.
Cuando se aborda la arquitectura de un sistema hay al
menos cinco áreas relacionadas que tratar — **al
mínimo necesario para empezar**, sin caer en exceso de
detalle:

1. **Información** — ¿qué entidades/objetos principales
   debe gestionar el sistema y cómo se identifican?

   En IACT: ``Usuario``, ``Sesion``, ``Permiso``,
   ``Llamada``, ``EjecucionETL``, ``Reporte``,
   ``Alerta``, ``EventoAuditoria`` (ver
   :doc:`analisis-dominio`).
2. **Funcional** — ¿qué funciones de negocio realiza el
   sistema, cómo se relacionan entre sí y cómo conectan
   con funciones externas al alcance?

   En IACT: 9 módulos UC (AUTH, USR, ACC, PERM, RPT,
   ALR, PIP, AUD, LOG) con sus 42 funciones atómicas y
   los enganches con LDAP, BD operativa e IVR.
3. **Interfaz de usuario** — ¿cómo navegará el usuario,
   cómo se verá el sistema, qué controles especiales
   pueden ser necesarios?

   En IACT: panel del supervisor en intranet sobre
   Apache + bundle React; sin canal email
   (CNST_001 — buzón interno).
4. **Tecnología / Infraestructura** — ¿qué tecnologías
   utilizará el proyecto, qué función desempeña cada
   una, sobre qué infraestructura corre, qué
   herramientas de desarrollo se usan?

   En IACT: Vagrant + Apache + ``mod_wsgi`` + Django +
   MySQL + Redis (ADR_DEVOPS_001). **Sin** Docker, K8s,
   Nginx, Gunicorn, CDN, multi-región.
5. **Software** — ¿qué módulos se escribirán y cómo se
   relacionan?

   En IACT: las apps Django ``auth_app``, ``perm_app``,
   ``rpt_app``, ``alr_app``, ``pip_app``, ``aud_app``,
   ``log_app`` y los contratos entre ellas
   (:doc:`diagramas-componentes`).

Cada área se aborda **al nivel suficiente para arrancar**,
no al nivel definitivo.

12.4 Pista arquitectónica
-------------------------

Aun con arquitectura inicial, el equipo puede necesitar
**períodos de trabajo arquitectónico concentrado** durante
el desarrollo — práctica conocida como *extender la pista
arquitectónica*. La idea: la arquitectura sostiene la
funcionalidad; conforme la funcionalidad se acerca al
final de la pista existente, hay que dedicar recursos a
construir más pista para que el trabajo siga fluyendo.

Aplicación a IACT
~~~~~~~~~~~~~~~~~

- **UI crítica para el éxito** → dedicar más diseño
  inicial a la vista del supervisor (UC_RPT,
  UC_ALR).
- **Módulos que pueden evolucionar** → responder
  inicialmente de forma general (apps Django con
  ``services.py`` mínimo); refinar al construir cada
  UC.
- **Restricciones inviolables** (CNST_001, CNST_002,
  CNST_006/007/008, CNST_025, CNST_030) → tratarlas
  como pista arquitectónica fija desde el inicio; no se
  postergan ni se "descubrirán mejor".

Cuándo extender la pista
~~~~~~~~~~~~~~~~~~~~~~~~

Señales en este proyecto:

- Un nuevo cluster de UCs (ver § 11 de
  :doc:`agregacion-interfaces`) requiere una interfaz
  que no existe → trabajo arquitectónico antes de
  redactar los UCs.
- Una restricción nueva entra en el alcance (regulación,
  política interna) → revisar las cinco áreas para ver
  qué cambia.
- El task plan empieza a generar PRs que tocan ≥ 3 apps
  Django simultáneamente → señal de acoplamiento alto;
  pausar y refactorizar.

12.5 Citas de referencia
------------------------

Tres citas que enmarcan el equilibrio:

   *Necesitamos adoptar la actitud de que la estructura
   interna de un sistema requerirá una mejora continua a
   medida que el sistema evoluciona. La refactorización,
   es decir, mejorar el diseño a medida que se desarrolla
   el sistema, no es solo para el software comercial. Sin
   una mejora continua, cualquier sistema de software se
   verá afectado.*
   — Mary y Tom Poppendieck,
   *Lean Software Development: An Agile Toolkit*, 2003.

   *Los prototipos y la creación de prototipos no son
   sustitutos del análisis y el diseño, ni excusas para
   el pensamiento descuidado.*
   — Larry Constantine y Lucy Lockwood,
   *Software for Use*, 1999.

   *Invariablemente se descubre que un sistema complejo
   que funciona ha evolucionado a partir de un sistema
   simple que funcionaba. Un sistema complejo diseñado
   desde cero nunca funciona y no se puede reparar para
   que funcione. Hay que empezar de nuevo, empezando por
   un sistema sencillo que funcione.*
   — John Gall, *Systemantics*, 1975 (Ley de Gall).

12.6 Aplicación a este plan
---------------------------

JEDUF aplicado al plan de los 97 UCs:

- **Arranque (BDUF mínimo)** — núcleo de auth + sesión +
  audit + reportería base. Aprox. 4 áreas resueltas a
  nivel arquitectónico antes del primer UC.
- **Iteración (diseño emergente)** — cada UC introduce
  responsabilidades nuevas que pueden requerir extender
  la pista (refactorizar interfaces, ajustar cluster).
- **Cierre (consolidación)** — DOC-24/25/26 (clases
  consolidadas, secuencias críticas, componentes y
  distribución) absorben el aprendizaje acumulado y
  alimentan el SAD futuro (§ 11).

Este plan **no es BDUF**: las plantillas y diagramas de
:doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
fijan estructura mínima común sin pretender prediseñar
cada UC.

Nota sobre documentación final
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Jack W. Reeves, en *What is Software Design?* (1992),
argumentó que la única documentación que realmente
satisface los criterios de un diseño de ingeniería son
**los listados de código fuente**: el conjunto completo
de archivos que hacen funcionar el programa, incluyendo
estructura de carpetas, dependencias, nombres
auto-documentados y patrones implementados. Este plan no
adopta esa postura como exclusiva — los UCs y diagramas
son documentación de diseño valiosa por sí mismos — pero
la observación es relevante: la documentación que **no se
mantiene en sincronía con el código** pierde valor con
el tiempo y se convierte en lava (ver § 13 de
:doc:`orientacion-objetos`).

----

13. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``pm-planning`` (PMBOK — Planning)
 * - **Origen del plan**
   - Adaptado de "GUÍA DE INTEGRACIÓN UML v2.0.0" (propuesta
     interna en Mermaid), reescrito para PlantUML por política
     del proyecto.
 * - **Ejemplos UML aplicados al dominio IACT**
   - :doc:`diagramas-uml`
 * - **Ejemplos OOP aplicados al dominio IACT**
   - :doc:`orientacion-objetos`
 * - **Ejemplos análisis de dominio aplicados al dominio IACT**
   - :doc:`analisis-dominio`
 * - **Ejemplos relaciones UML aplicadas al dominio IACT**
   - :doc:`relaciones-uml`
 * - **Ejemplos agregación / interfaces / visibilidad — IACT**
   - :doc:`agregacion-interfaces`
 * - **Ejemplos análisis y especificación de UCs — IACT**
   - :doc:`casos-uso-especificacion`
 * - **Plantilla aplicable**
   - :doc:`/normativa/estandares/plantillas/tpl-uc-spec-con-diagramas-uml`
 * - **Metodología de análisis de dominio aplicable**
   - :doc:`/normativa/estandares/metodologia-analisis-dominio-ucs`
 * - **Metodología OOP aplicable**
   - :doc:`/normativa/estandares/metodologia-oop-para-ucs`
 * - **Política de diagramación**
   - :doc:`/base-cognitiva/plantuml-guide/guidelines`
 * - **Catálogo PlantUML del proyecto**
   - :doc:`/base-cognitiva/plantuml-guide/diagramas-de-referencia`
 * - **Convención de naming**
   - :doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`
 * - **Catálogo UC actual**
   - :doc:`/requisitos/casos-uso/index`
