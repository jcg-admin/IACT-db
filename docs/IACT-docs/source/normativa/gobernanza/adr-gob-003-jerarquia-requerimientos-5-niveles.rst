.. meta::
 :artefacto: ADR_GOB_003_jerarquia_requerimientos_5_niveles
 :tipo: ADR
 :dominio: normativa
 :subdominio: gobernanza
 :estado: Aceptada
 :version: 1.0.0
 :fecha_creacion: 2025-11-06
 :ultimo_cambio: 2026-04-28
 :autor: Equipo Arquitectura
 :clasificacion: Critico

.. _adr_gob_003_jerarquia_requerimientos_5_niveles:

=====================================================
ADR-GOB-003: Jerarquia de Requerimientos en 5 Niveles
=====================================================
Contexto
--------

La ingeniería de requerimientos en proyectos de software requiere un
marco estructurado para organizar, clasificar y relacionar diferentes
tipos de requisitos. Sin una jerarquía clara, se presentan problemas
comunes:

Problemas sin Estructura Jerárquica
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Confusión de niveles**: - Mezclar objetivos de negocio con detalles de
implementación - Tratar reglas de negocio como requisitos funcionales -
No distinguir entre necesidades de usuario y características del sistema

**Falta de trazabilidad**: - Dificultad para rastrear por qué existe
cierta funcionalidad - Imposibilidad de validar que requisitos de alto
nivel se cumplen - Cambios en políticas no se reflejan en funcionalidad

**Comunicación deficiente**: - Stakeholders de negocio no entienden
documentación técnica - Desarrolladores no comprenden objetivos de
negocio - QA no sabe qué validar realmente

**Alcance mal definido**: - Requisitos funcionales se expanden sin
justificación - Features sin conexión con objetivos organizacionales -
Atributos de calidad tratados como “extras opcionales”

Necesidades del Proyecto IACT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

El proyecto IACT requiere:

1. **Múltiples dominios**: Backend, Frontend, DevOps, QA, AI requieren
   organización consistente
2. **Cumplimiento regulatorio**: Reglas de negocio externas (LFPDPPP,
   normas de salud, etc.)
3. **Múltiples stakeholders**: Desde ejecutivos hasta desarrolladores
4. **Trazabilidad completa**: Desde políticas hasta código
5. **Evolución controlada**: Cambios en un nivel deben propagarse
   correctamente

Marco de Referencia
~~~~~~~~~~~~~~~~~~~

La industria de ingeniería de software ha establecido que los
requerimientos no son planos, sino que forman una jerarquía donde cada
nivel: - Tiene un propósito específico - Se deriva del nivel superior -
Informa y restringe el nivel inferior - Requiere diferentes técnicas de
elicitación y validación

Decisión
--------

**Adoptar jerarquía de requerimientos en 5 niveles como estructura
fundamental para documentación de requisitos en el proyecto IACT.**

Jerarquía de 5 Niveles
~~~~~~~~~~~~~~~~~~~~~~

::

 Nivel 1: REGLAS DE NEGOCIO
 ↓ (influencian)
 Nivel 2: REQUERIMIENTOS DE NEGOCIO
 ↓ (se convierten en)
 Nivel 3: REQUERIMIENTOS DE USUARIO
 ↓ (se implementan mediante)
 Nivel 4: REQUERIMIENTOS FUNCIONALES
 ↓ (deben cumplir)
 Nivel 5: ATRIBUTOS DE CALIDAD

Nivel 1: Reglas de Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Políticas, leyes y estándares de la industria bajo los
cuales se rige la organización para operar de manera efectiva y conforme
a las regulaciones.

**Características**: - También llamadas “lógica de negocio” - Son
externas o internas a la organización - NO negociables cuando provienen
de leyes/regulaciones - Restricción y control de funcionalidad

**Funciones principales**: 1. Restringen quién puede realizar ciertos
casos de uso 2. Dictan qué funcionalidad debe continuar el sistema

**Ubicación en proyecto**:
``source/requisitos/reglas-negocio/``

**Nomenclatura** (per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`):
``br-<NNN>-<descripcion-kebab>.rst``. ID semántico en metadata:
``BR_NNN``.

**Ejemplos**:

- ``br-001-fuente-operacional-inmutable.rst``
- ``br-006-rbac-flat-nist.rst``
- ``br-016-tasa-abandono.rst``

Nivel 2: Requerimientos de Negocio
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Objetivos organizacionales de alto nivel que el sistema
debe permitir alcanzar.

**Características**: - Orientados a resultados de negocio - Medibles
(con KPIs) - Derivan de estrategia organizacional - Justifican la
existencia del proyecto

**Relación con Nivel 1**: Las regulaciones gubernamentales pueden
conducir a objetivos de negocio necesarios para un proyecto.

**Ubicación en proyecto**:
``source/requisitos/business-requirements/``

**Nomenclatura** (per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`):
``breq-<NNN>-<descripcion-kebab>.rst``. ID semántico en metadata:
``BReq_NNN``.

**Ejemplos**:

- ``breq-001-visibilidad-metricas.rst``
- (futuro) ``breq-002-cumplimiento-regulatorio.rst``

Nivel 3: Requerimientos de Usuario
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Necesidades específicas de los usuarios del sistema,
descripción de lo que los usuarios deben poder hacer.

**Características**: - Perspectiva del usuario (no del sistema) - Se
expresan como casos de uso, historias de usuario, user journeys -
Describen interacciones usuario-sistema - Orientados a objetivos de
usuario

**Relación con Nivel 1**: Las políticas de privacidad dictan qué
usuarios pueden y no pueden realizar ciertas tareas con el sistema.

**Ubicación en proyecto**:
``source/requisitos/casos-uso/<modulo>/``

**Nomenclatura casos de uso** (per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`):
``uc-<mod>-<NN>-<verbo-objeto>.rst``. ID semántico en metadata:
``UC_{MOD}_NN`` (ej: ``UC_AUTH_01``).

Módulos válidos: ``auth, users, access, permissions, reports,
alerts, pipeline, audit, logs``.

**Ejemplos**:

- ``casos-uso/auth/uc-auth-01/index.rst``
- ``casos-uso/access/uc-acc-01/index.rst``
- ``casos-uso/reports/uc-rpt-01/index.rst``

Nivel 4: Requerimientos Funcionales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Funciones o comportamientos específicos que el sistema
debe realizar. Pequeños bits específicos de funciones que permiten a los
usuarios ejecutar casos de uso.

**Características**: - Describen QUÉ debe hacer el sistema (NO CÓMO) -
Detallados y específicos - Verificables y testeables - Implementables
directamente por desarrolladores

**Relación con Nivel 1**: Las políticas empresariales establecen
procesos específicos que el sistema debe implementar.

**Ubicación en proyecto**:
``source/requisitos/requisitos-funcionales/<modulo>/<uc-padre>/``

**Nomenclatura** (per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`):
``fr-<NNN>-<NN>-<descripcion-kebab>.rst``. El primer NNN refiere
al UC padre; el segundo NN es secuencial dentro del UC. ID
semántico en metadata: ``FR_NNN_NN``.

**Ejemplos**:

- ``requisitos-funcionales/auth/uc-001-iniciar-sesion/fr-001-01-validar-credenciales.rst``
- ``requisitos-funcionales/users/uc-006-crear-usuario/fr-006-01-validar-username-unico.rst``
- ``requisitos-funcionales/access/uc-010-asignar-funciones/fr-010-01-listar-funciones-disponibles.rst``

Nivel 5: Atributos de Calidad (Requerimientos No Funcionales)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Definición**: Características del sistema que describen CÓMO debe
comportarse (rendimiento, seguridad, usabilidad, confiabilidad, etc.).

**Características**: - También llamados RNF (Requerimientos No
Funcionales) - Afectan la arquitectura del sistema - Frecuentemente
medibles (tiempo de respuesta < 2s, disponibilidad > 99.9%) - Aplican
transversalmente al sistema

**Relación con Nivel 1**: Las regulaciones de agencias gubernamentales
pueden dictar ciertos requisitos de seguridad que deben aplicarse a
través de la funcionalidad del sistema.

**Ubicación en proyecto**:
``source/requisitos/requisitos-no-funcionales/``

**Nomenclatura** (per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`
+ :doc:`/normativa/estandares/adr-std-007-spec-gaps-fix` § 4):
``rnf-<mod>-<NNN>-<descripcion-kebab>.rst``. ID semántico en
metadata: ``RNF_{MOD}_NNN`` (ej: ``RNF_PROC_001``).

Módulos válidos: ``proc`` (procesos del sistema/SDLC).
Reservados futuros: ``sec`` (seguridad), ``perf`` (performance),
``avail`` (disponibilidad).

**Ejemplos**:

- ``rnf-proc-001-proceso-sdlc.rst``
- ``rnf-proc-002-metricas-proceso.rst``
- (futuro) ``rnf-perf-001-tiempo-respuesta.rst``
- (futuro) ``rnf-sec-001-cifrado-en-transito.rst``

Tabla de Influencia entre Niveles
---------------------------------

Esta tabla muestra cómo las Reglas de Negocio influyen en cada nivel:

.. list-table::
   :header-rows: 1

   * - Tipo de Requerimiento
     - Cómo Influyen las Reglas de Negocio
     - Ejemplo Práctico
   * - **Requerimientos de Negocio**
     - Las regulaciones gubernamentales pueden conducir a objetivos de negocio necesarios para un proyecto
     - El sistema de seguimiento de químicos debe permitir el cumplimiento de todas las regulaciones federales y estatales sobre el uso de químicos y su eliminación en un período de 5 meses
   * - **Requerimientos de Usuario**
     - Las políticas de privacidad dictan qué usuarios pueden y no pueden realizar ciertas tareas con el sistema
     - Los gerentes de laboratorio están autorizados a generar informes de exposición química para cualquier persona
   * - **Requerimientos Funcionales**
     - Las políticas empresariales establecen procesos específicos que el sistema debe implementar
     - Política: todos los proveedores deben estar registrados y aprobados antes de que se pague una factura. Funcionalidad: cuando una factura es recibida por un proveedor no registrado, el sistema enviará un email al proveedor con un PDF editable para darse de alta
   * - **Atributos de Calidad**
     - Las regulaciones de agencias gubernamentales pueden dictar ciertos requisitos de seguridad que deben aplicarse a través de la funcionalidad del sistema
     - El sistema debe mantener registros de entrenamiento de seguridad que se deben verificar para garantizar que los usuarios están debidamente capacitados antes de poder solicitar un producto químico peligroso

Estructura de Directorios
-------------------------

::

 source/requisitos/
 ├── reglas-negocio/                          (Nivel 1: BR)
 │   ├── br-001-fuente-operacional-inmutable.rst
 │   ├── br-006-rbac-flat-nist.rst
 │   └── ...
 ├── business-requirements/                   (Nivel 2: BReq)
 │   └── breq-001-visibilidad-metricas.rst
 ├── casos-uso/                               (Nivel 3: UC)
 │   ├── auth/
 │   │   ├── uc-auth-01/index.rst
 │   │   └── ...
 │   ├── access/
 │   ├── reports/
 │   └── ...
 ├── requisitos-funcionales/                  (Nivel 4: FR)
 │   ├── auth/uc-001-iniciar-sesion/
 │   │   ├── fr-001-01-validar-credenciales.rst
 │   │   └── ...
 │   └── ...
 └── requisitos-no-funcionales/               (Nivel 5: RNF)
     ├── rnf-proc-001-proceso-sdlc.rst
     └── rnf-proc-002-metricas-proceso.rst

.. note::

 Cajones de niveles BABOK adicionales (``OE`` Strategic
 Objectives, ``N`` Business Needs, ``RS`` Stakeholder Reqs,
 ``RSi`` System Reqs, ``RTM`` Traceability Matrix) están
 declarados en :doc:`/base-cognitiva/glosario` § E pero no han
 sido implementados aún. Su creación es decisión pendiente del
 WP de actualización de requisitos.

Principios de Uso
-----------------

Principio 1: Derivación Descendente
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Los requerimientos de cada nivel deben derivarse del nivel superior:

::

 BR_006 (Nivel 1): RBAC Flat NIST — usuarios autenticados con función válida
 ↓ influye
 BReq_001 (Nivel 2): Visibilidad de métricas operativas con seguridad
 ↓ se convierte en
 UC_AUTH_01 (Nivel 3): Iniciar Sesión
 ↓ se implementa mediante
 FR_001_01 (Nivel 4): Validar credenciales contra base de datos
 ↓ debe cumplir
 RNF_PROC_001 (Nivel 5): Proceso SDLC define ciclo de validación

Principio 2: Trazabilidad Bidireccional
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada requisito debe poder rastrearse: - **Hacia arriba**: ¿Por qué
existe este requisito? - **Hacia abajo**: ¿Cómo se implementa/valida
este requisito?

Principio 3: Stakeholders Apropiados
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada nivel tiene stakeholders primarios diferentes:

.. list-table::
   :header-rows: 1

   * - Nivel
     - Stakeholders Primarios
     - Stakeholders Secundarios
   * - Reglas de Negocio
     - Legal, Compliance, C-Suite
     - Product Owner, Arquitectos
   * - Requerimientos de Negocio
     - C-Suite, Product Owner
     - Arquitectos, Tech Leads
   * - Requerimientos de Usuario
     - Product Owner, UX, Usuarios Finales
     - Desarrolladores
   * - Requerimientos Funcionales
     - Desarrolladores, Tech Leads
     - QA, DevOps
   * - Atributos de Calidad
     - Arquitectos, DevOps, QA
     - Desarrolladores

Principio 4: Diferentes Técnicas de Validación
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1

   * - Nivel
     - Técnicas de Validación
   * - Reglas de Negocio
     - Auditoría legal, revisión de compliance
   * - Requerimientos de Negocio
     - Validación con ejecutivos, análisis de ROI
   * - Requerimientos de Usuario
     - Prototipos, entrevistas, observación de usuarios
   * - Requerimientos Funcionales
     - Code reviews, tests unitarios e integración
   * - Atributos de Calidad
     - Tests de rendimiento, auditorías de seguridad, análisis de código

Alternativas Consideradas
-------------------------

Alternativa 1: Jerarquía Plana (Sin Niveles)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Todos los requisitos en un mismo nivel, sin
categorización.

**Pros**: - Más simple inicialmente - No requiere entrenamiento en la
jerarquía

**Contras**: - Mezcla niveles de abstracción - Imposibilita trazabilidad
- Confusión entre stakeholders - Dificulta priorización y gestión de
cambios

**Razón de rechazo**: Inadecuado para proyectos complejos con múltiples
stakeholders.

Alternativa 2: IEEE 830 (3 Niveles)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Estructura tradicional con solo: 1. Requisitos
Funcionales 2. Requisitos No Funcionales 3. Restricciones

**Pros**: - Estándar conocido - Documentación abundante

**Contras**: - No captura reglas de negocio explícitamente - No
distingue entre requisitos de negocio y de usuario - Insuficiente para
trazabilidad completa - Orientado solo a desarrollo, no a estrategia

**Razón de rechazo**: Insuficiente para capturar relación entre
estrategia organizacional y funcionalidad técnica.

Alternativa 3: User Stories únicamente (Agile puro)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Solo historias de usuario sin estructura jerárquica
formal.

**Pros**: - Muy ágil y flexible - Fácil de entender - Cercanía con
usuario final

**Contras**: - No captura reglas de negocio externas - Dificulta
cumplimiento regulatorio - No adecuado para requisitos de arquitectura -
Falta de contexto estratégico

**Razón de rechazo**: Insuficiente para proyectos con obligaciones
regulatorias y múltiples dominios técnicos.

Alternativa 4: Modelo de 7 Niveles (Extensión del estándar)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Descripción**: Agregar niveles adicionales: 1. Visión estratégica 2.
Reglas de negocio 3. Objetivos de negocio 4. Requisitos de usuario 5.
Requisitos funcionales 6. Requisitos no funcionales 7. Restricciones
técnicas

**Pros**: - Máxima granularidad - Separación muy clara

**Contras**: - Demasiado complejo para tamaño actual del proyecto -
Overhead de documentación excesivo - Confusión entre niveles similares

**Razón de rechazo**: Overkill para proyectos de tamaño mediano. Modelo
de 5 niveles proporciona balance adecuado.

Consecuencias
-------------

Positivas
~~~~~~~~~

1. **Trazabilidad completa**

   - Cada feature se justifica desde reglas de negocio hasta atributos
     de calidad
   - Fácil responder “¿por qué existe esta funcionalidad?”
   - Validación de que objetivos de negocio se cumplen

2. **Comunicación mejorada**

   - Cada stakeholder trabaja en su nivel apropiado
   - Ejecutivos ven requisitos de negocio
   - Desarrolladores ven requisitos funcionales
   - Traducción clara entre niveles

3. **Gestión de cambios efectiva**

   - Cambio en regla de negocio se propaga correctamente
   - Impacto visible en todos los niveles
   - Decisiones informadas sobre aceptar/rechazar cambios

4. **Cumplimiento regulatorio**

   - Reglas de negocio externas explícitas
   - Auditorías pueden verificar cumplimiento
   - Evidencia de conformidad con regulaciones

5. **Priorización basada en valor**

   - Requisitos vinculados a objetivos de negocio
   - Fácil identificar “nice to have” vs “must have”
   - ROI más claro

6. **Arquitectura coherente**

   - Atributos de calidad informan decisiones de arquitectura
   - No son “extras opcionales”
   - Evita deuda técnica por omisión de RNF

Negativas
~~~~~~~~~

1. **Curva de aprendizaje**

   - Equipo debe entender la jerarquía
   - Requiere disciplina para mantenerla
   - Tentación de atajos (saltar niveles)

 **Mitigación**:

   - Capacitación inicial en jerarquía
   - Templates y ejemplos claros
   - Revisiones de calidad de documentación
   - ADRs complementarios (006-009)

2. **Overhead de documentación**

   - Más documentos que enfoque plano
   - Mantenimiento de relaciones entre niveles
   - Tiempo inicial mayor

 **Mitigación**:

   - Herramientas de trazabilidad
   - Templates reutilizables
   - Generación automática de matrices de trazabilidad
   - Revisar solo lo necesario (no documentar por documentar)

3. **Riesgo de inconsistencias**

   - Cambio en un nivel puede no reflejarse en otros
   - Documentos pueden desincronizarse

 **Mitigación**:

   - Referencias explícitas entre documentos (IDs)
   - Code reviews de documentación
   - Scripts de validación de trazabilidad
   - Principio: cambio en nivel superior requiere review de niveles
     inferiores

4. **Complejidad en proyectos pequeños**

   - Para features muy simples puede ser excesivo
   - No todo requisito necesita 5 niveles

 **Mitigación**:

   - Permitir niveles implícitos cuando sean obvios
   - No forzar documentación de niveles triviales
   - Usar juicio: “¿agrega valor documentar esto en 5 niveles?”

Implementación
--------------

Fase 1: Reorganización de Estructura Actual (completada)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Estructura canónica resultante en ``source/requisitos/``:

.. code:: bash

 tree source/requisitos/
 # ├── reglas-negocio/
 # ├── business-requirements/
 # ├── casos-uso/{auth,users,access,permissions,...}/
 # ├── requisitos-funcionales/
 # └── requisitos-no-funcionales/

Fase 2: Creación de Templates (completada)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Templates por nivel disponibles en
``source/normativa/estandares/plantillas/``:

- ``tpl-br-business-rule.rst``
- ``tpl-breq-objetivos-negocio.rst``
- ``tpl-uc-stakeholder-driven.rst`` (UC)
- ``tpl-fr-documentacion-10-componentes.rst`` (FR)
- (futuro) ``tpl-rnf-atributo-calidad.rst``

Fase 3: Capacitación del Equipo (Semana 2)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Sesión de 2 horas sobre jerarquía
2. Ejercicio práctico: derivar requisitos de un caso real
3. Q&A y resolución de dudas

Fase 4: Documentación de Requisitos Existentes (Semanas 3-4)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Identificar reglas de negocio actuales
2. Documentar requisitos de negocio
3. Clasificar casos de uso existentes
4. Derivar requisitos funcionales de casos de uso
5. Documentar atributos de calidad

Fase 5: Matriz de Trazabilidad (Semana 5)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Crear matriz que muestre relaciones:

::

 BR_006 → BReq_001 → UC_AUTH_01 → FR_001_01, FR_001_02 → RNF_PROC_001

Validación
----------

Criterios de Éxito
~~~~~~~~~~~~~~~~~~

- 100% de nuevos requisitos documentados siguiendo jerarquía
- Matriz de trazabilidad completa para features principales
- Equipo capacitado y usando estructura correctamente
- Stakeholders reportan mejor comunicación
- Auditorías de compliance son más eficientes

Métricas
~~~~~~~~

- Número de requisitos por nivel
- Cobertura de trazabilidad (% de requisitos con links a nivel
  superior/inferior)
- Tiempo promedio para derivar requisito de nivel inferior desde
  superior
- Satisfacción del equipo con la estructura (survey trimestral)
- Reducción de defectos por “requisito no entendido”

Referencias
-----------

- `IEEE 29148-2018: Systems and software engineering — Life cycle
  processes — Requirements
  engineering <https://standards.ieee.org/standard/29148-2018.html>`__
- `IIBA BABOK v3: Business Analysis Body of
  Knowledge <https://www.iiba.org/business-analysis-certifications/babok/>`__
- `ADR-GOB-006: Clasificación y Documentación de Reglas de
  Negocio <ADR-GOB-006-clasificacion-reglas-negocio.rst>`__
- `ADR-GOB-007: Especificación de Casos de
  Uso <ADR-GOB-007-especificacion-casos-uso.rst>`__
- `ADR-GOB-009: Trazabilidad entre Artefactos de
  Requisitos <ADR-GOB-009-trazabilidad-artefactos-requisitos.rst>`__

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1

   * - Versión
     - Fecha Autor
     - Cambios
     - \ 
   * - 1.0.0 20
     - 25-11-17 Cl
     - aude Code Ve
     - rsión inicial

Aprobación
----------

- **Autor**: Claude Code (Sonnet 4.5)
- **Revisado por**: Pendiente
- **Aprobado por**: Pendiente
- **Fecha de próxima revisión**: 2026-05-17
