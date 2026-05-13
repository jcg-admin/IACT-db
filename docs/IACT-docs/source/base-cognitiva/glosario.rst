.. meta::
 :artefacto: GLOSARIO
 :tipo: Glosario consolidado
 :dominio: base_cognitiva
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2025-12-18
 :ultimo_cambio: 2026-04-28
 :autor: PMO IACT
 :clasificacion: Interno

.. _glosario:
.. _glosario-iact:

=============
Glosario IACT
=============

Glosario consolidado del proyecto IACT. Reúne en un único archivo:

- Términos del producto y del stack técnico real (React+Webpack /
  Django REST Framework / Ubuntu+Apache / MySQL+PostgreSQL).
- Términos de metodología y estándares vigentes en el proyecto:
  BABOK v3, PMBOK 7th Ed, ISO/IEC/IEEE 29148:2018.
- Verbos modales y métodos de verificación obligatorios.
- Abreviaturas comunes.

----

A. Términos del Producto IACT
=============================

**Analytics**
 Proceso de análisis de datos para obtener insights y métricas
 de negocio.

**API REST**
 Interfaz de programación de aplicaciones que utiliza el
 protocolo HTTP para comunicación entre sistemas. En IACT, el
 backend expone una API REST consumida por el frontend y por
 integraciones externas.

**Apache**
 Servidor HTTP usado en producción como reverse proxy, terminador
 TLS y gateway WSGI vía ``mod_wsgi``.

**Dashboard**
 Interfaz visual que presenta métricas y KPIs de manera
 consolidada para facilitar la toma de decisiones.

**Django**
 Framework web de Python en el que está construido el backend
 del producto IACT.

**Django REST Framework (DRF)**
 Librería sobre Django para construir APIs REST de manera
 estructurada (ViewSets, serializers, permissions, routers).
 Es el framework del backend de IACT.

**ETL**
 Extract, Transform, Load. Proceso de extracción de datos desde
 una fuente, transformación según reglas de negocio, y carga en
 un destino analítico. En IACT mueve datos de **MySQL**
 (operativa) a **PostgreSQL** (analítica).

**IVR**
 Interactive Voice Response. Sistema de respuesta de voz
 interactiva usado para enrutar llamadas entrantes y guiar al
 cliente. Es el dominio del cual IACT extrae métricas.

**mod_wsgi**
 Módulo de Apache que permite servir aplicaciones WSGI (Django)
 directamente desde Apache. Es la elección de despliegue del
 backend de IACT.

**MySQL**
 Sistema de gestión de bases de datos relacional usado como
 **fuente operativa** en IACT (modo solo-lectura desde IACT —
 los datos son producidos por sistemas IVR origen).

**PostgreSQL**
 Sistema de gestión de bases de datos relacional usado como
 **destino analítico** en IACT (lectura/escritura desde IACT,
 optimizado para queries agregadas).

**RBAC**
 Role-Based Access Control. Control de acceso basado en roles
 funcionales del sistema. En IACT se aplica con SoD (Separation
 of Duties).

**React**
 Biblioteca de JavaScript para construir interfaces de usuario
 interactivas. Es el framework del frontend de IACT.

**Rol Funcional**
 Capacidad técnica del sistema (ej: ``REPORTS_VIEWER``)
 independiente de puestos organizacionales.

**Separation of Duties (SoD)**
 Principio de seguridad por el que ciertas combinaciones de
 permisos no pueden coexistir en un mismo rol/usuario.

**Ubuntu**
 Distribución Linux usada como sistema operativo de los servidores
 donde corre IACT.

**Webpack**
 Empaquetador (bundler) de assets JavaScript/CSS usado por el
 frontend de IACT.

----

B. Términos de Metodología — BABOK v3
=====================================

Glosario derivado de *Business Analysis Body of Knowledge®
Guide v3* (IIBA, 2015).

.. list-table::
 :header-rows: 1
 :widths: 25 45 30

 * - Término
   - Definición
   - Ejemplo en IACT
 * - **Business Need**
   - Problema u oportunidad que debe abordarse para lograr
     objetivos organizacionales.
   - N-001: Reducir roturas de stock.
 * - **Business Requirement (BR)**
   - Objetivo, meta o resultado de alto nivel que el negocio
     debe lograr.
   - RN-001: Sistema de alertas automáticas.
 * - **Stakeholder Requirement (SR)**
   - Necesidad específica de usuarios, clientes y partes
     interesadas.
   - RS-001: Gerente necesita alertas en dashboard.
 * - **Solution Requirement**
   - Capacidades que debe tener la solución (Funcionales +
     No Funcionales).
   - RF-001: API calcular stock mínimo.
 * - **Functional Requirement (FR)**
   - Comportamiento, acción o capacidad que el sistema debe
     realizar.
   - RF-001: Sistema DEBERÁ calcular stock.
 * - **Non-Functional Requirement (NFR)**
   - Característica de calidad que el sistema debe poseer.
   - RNF-001: Tiempo respuesta < 200ms.
 * - **Business Analyst (BA)**
   - Rol responsable de elicitar, analizar y documentar
     requisitos.
   - Equipo BA del proyecto IACT.
 * - **Requirements Traceability**
   - Relación bidireccional entre requisitos de diferentes
     niveles.
   - N-001 → RN-001 → RF-001.

----

C. Términos de Metodología — PMBOK 7
====================================

Glosario derivado de *A Guide to the Project Management Body of
Knowledge (PMBOK® Guide)* — 7th Edition (PMI, 2021).

.. list-table::
 :header-rows: 1
 :widths: 28 42 30

 * - Término
   - Definición
   - Uso en IACT
 * - **Project Charter**
   - Documento que autoriza formalmente el proyecto.
   - Charter para implementación de requisitos.
 * - **Stakeholder**
   - Individuo, grupo u organización afectado por el proyecto.
   - Gerentes de operaciones, analistas, usuarios finales.
 * - **Scope**
   - Trabajo requerido para entregar producto/servicio.
   - Alcance definido en necesidades (N-XXX).
 * - **Work Breakdown Structure (WBS)**
   - Descomposición jerárquica del trabajo.
   - Fases del proyecto IACT.
 * - **Risk**
   - Evento incierto que puede impactar objetivos.
   - Riesgos documentados en cada requisito.
 * - **Deliverable**
   - Producto, resultado o capacidad entregable.
   - BRS, StRS, SyRS, SRS, RTM.
 * - **Milestone**
   - Punto significativo en el cronograma.
   - Hitos en cada fase.
 * - **Baseline**
   - Versión aprobada de un artefacto.
   - Baselines en gobernanza.

----

D. Términos de Estándar — ISO/IEC/IEEE 29148:2018
=================================================

Glosario derivado de *Systems and Software Engineering — Life
cycle processes — Requirements engineering*.

.. list-table::
 :header-rows: 1
 :widths: 30 35 35

 * - Término
   - Definición
   - Implementación en IACT
 * - **BRS** (Business Requirements Specification)
   - Documento con requisitos de negocio (Clause 9.3).
   - Cajón ``requisitos/`` (RN-XXX).
 * - **StRS** (Stakeholder Requirements Specification)
   - Documento con requisitos de stakeholders (Clause 9.4).
   - Cajón ``requisitos/`` (RS-XXX).
 * - **SyRS** (System Requirements Specification)
   - Documento con requisitos de sistema (Clause 9.5).
   - Cajón ``requisitos/`` (RSi-XXX).
 * - **SRS** (Software Requirements Specification)
   - Documento con requisitos de software (Clause 9.6).
   - Cajón ``requisitos/`` (RF-XXX).
 * - **RTM** (Requirements Traceability Matrix)
   - Matriz de trazabilidad bidireccional.
   - ``requisitos/rtm/index.rst``.
 * - **Requirement Construct**
   - Estructura: Subject + Modal Verb + Action + Object +
     Condition.
   - "El sistema DEBERÁ calcular...".
 * - **Verification**
   - Confirmar que requisito está correctamente especificado.
   - Tests, inspecciones, análisis.
 * - **Validation**
   - Confirmar que requisito satisface necesidad real.
   - UAT con stakeholders.
 * - **Full Conformance**
   - Cumplir todos los requisitos de Clause 4.2.
   - Objetivo de la documentación de IACT.

----

E. Jerarquía integrada de requisitos
====================================

Mapeo entre **BABOK v3 + ISO 29148** y la convención IACT
implementada en ``source/requisitos/`` per
:doc:`/normativa/estandares/adr-std-007-naming-kebab-correction`
(STD-007 v2.0.0+).

.. list-table::
 :header-rows: 1
 :widths: 28 12 22 30 8

 * - Concepto BABOK / ISO 29148
   - ID conceptual (BABOK)
   - ID semántico (metadata IACT)
   - Filename pattern (STD-007)
   - Estado
 * - Strategic Objective
   - ``OE-XXX``
   - ``OE_NNN`` *(reservado)*
   - ``oe-<NNN>-<desc>.rst``
   - GAP
 * - Business Need (BABOK)
   - ``N-XXX``
   - ``N_NNN`` *(reservado)*
   - ``n-<NNN>-<desc>.rst``
   - GAP
 * - Business Requirement
     (BABOK BR / ISO BRS 9.3)
   - ``RN-XXX``
   - ``BReq_NNN``
   - ``breq-<NNN>-<desc>.rst``
   - Implementado
 * - Business Rule
     (BABOK secundario)
   - (sin ID propio en BABOK)
   - ``BR_NNN``
   - ``br-<NNN>-<desc>.rst``
   - Implementado
 * - Stakeholder Requirement
     (BABOK SR / ISO StRS 9.4)
   - ``RS-XXX``
   - ``RS_NNN`` *(reservado)*
   - ``rs-<NNN>-<desc>.rst``
   - GAP (existen ``tpl-rs-*`` y ``tpl-stk-*``)
 * - System Requirement
     (ISO SyRS 9.5)
   - ``RSi-XXX``
   - ``RSi_NNN`` *(reservado)*
   - ``rsi-<NNN>-<desc>.rst``
   - GAP
 * - Use Case
   - (sin ID propio)
   - ``UC_{MOD}_NN``
   - ``uc-<mod>-<NN>-<desc>.rst``
   - Implementado
 * - Functional Requirement
     (BABOK FR / ISO SRS 9.6)
   - ``RF-XXX``
   - ``FR_NNN_NN``
   - ``fr-<NNN>-<NN>-<desc>.rst``
   - Implementado
 * - Non-Functional Requirement
     (BABOK NFR / ISO 25010)
   - ``RNF-XXX``
   - ``RNF_{MOD}_NNN``
   - ``rnf-<mod>-<NNN>-<desc>.rst``
   - Implementado
 * - Test Case
   - ``TC-XXX``
   - ``EV_CP_NNN``
   - (cajón ``gestion/evidencia/``)
   - Otro cajón

**Reglas del mapeo:**

- **Filename pattern** (4ª columna): aplica STD-007 v2.0.0+ —
  todo en kebab-lowercase con prefijo + numeración.
- **ID semántico** (3ª columna): usa PascalCase/UPPER per
  STD-007 v2.0.2 § 6 (metadata field ``:artefacto:``).
- **ID conceptual BABOK** (2ª columna): nomenclatura del
  estándar; usar sólo cuando se cite BABOK/ISO directamente.

**Flujo de derivación canónico** (los GAP son saltables si no
aplican al alcance del proyecto)::

 OE → N → BReq → RS → RSi → UC → FR → TC
              ↓
              BR (regla del dominio, ortogonal — influye en UC y FR)

              RNF (atributo de calidad, ortogonal — debe cumplirse
                   en UC y FR)

----

F. Verbos modales (ISO 29148, Clause 5.2.4)
===========================================

Verbos obligatorios para enunciar requisitos.

.. list-table::
 :header-rows: 1
 :widths: 25 35 40

 * - Verbo modal
   - Significado
   - Ejemplo en IACT
 * - **SHALL / DEBERÁ**
   - Requisito obligatorio.
   - "El sistema DEBERÁ validar..."
 * - **SHOULD / DEBERÍA**
   - Requisito recomendado pero no obligatorio.
   - "El sistema DEBERÍA notificar..."
 * - **MAY / PUEDE**
   - Requisito opcional.
   - "El sistema PUEDE incluir..."
 * - **MUST NOT / NO DEBERÁ**
   - Prohibición.
   - "El sistema NO DEBERÁ exponer..."

----

G. Métodos de verificación (ISO 29148, Clause 6.5.2.2)
======================================================

.. list-table::
 :header-rows: 1
 :widths: 22 38 40

 * - Método
   - Descripción
   - Ejemplo en IACT
 * - **Test**
   - Ejecutar el sistema con inputs específicos.
   - Tests automatizados ``pytest`` (backend),
     ``jest`` (frontend).
 * - **Inspection**
   - Examen visual del producto.
   - Code review en PR; revisión de documentación
     en gates de fase.
 * - **Analysis**
   - Uso de modelos analíticos sin ejecutar.
   - Análisis estático (linters, type checkers,
     static analysis), revisión de diseño.
 * - **Demonstration**
   - Observación del comportamiento operacional.
   - Demo a stakeholders, UAT.

----

H. Vocabulario RBAC unificado (canónico)
========================================

Tras la decisión arquitectónica documentada en el ADR-GOB-008 (RBAC
Coexistencia ACC ↔ PERM), estos son los términos canónicos del modelo
RBAC del sistema IACT. **El uso de estos términos es obligatorio** en
toda documentación nueva del proyecto (formalizado en
:doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`).

.. list-table::
 :header-rows: 1
 :widths: 25 75

 * - Término canónico (docs)
   - Definición
 * - **Función**
   - Capacidad atómica del sistema RBAC: una acción concreta
     verificable expresada como verbo+recurso (``view_audit_log``,
     ``manage_sessions``, ``export_csv``). En código: ``Function``
     (modelo Django, en inglés). Sustituye al término "Capacidad"
     del sistema PERM granular (D-RBAC-1).
 * - **Grupo de Permisos**
   - Set de funciones asignables como bloque. Puede ser
     **predefinido** (system group AGR-001..010, inmutable) o
     **creable** dinámicamente por admin via
     :doc:`/requisitos/casos-uso/permissions/uc-perm-05/index`.
 * - **Agrupador**
   - Sinónimo de "Grupo predefinido AGR-001..010" (terminología
     del modelo legacy v5.2.1). Equivalente a system group.
 * - **Permiso Excepcional**
   - Asignación directa de funciones a un usuario fuera de grupos,
     con justificación obligatoria mínimo 20 caracteres y
     vencimiento máximo 6 meses (ver
     :doc:`/normativa/restricciones/cnst-031-permisos-temporales-maximo-6-meses`).
 * - **Regla SoD**
   - Restricción de mutual exclusion entre dos grupos
     (Separation of Duties). El sistema declara 3 reglas:
     SOD-001 (pipeline ⊕ audit), SOD-002 (users ⊕ audit),
     SOD-003 (access ⊕ audit). Aplican tanto a system como a
     custom groups (ver
     :doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod`).
 * - **Verificación de Permiso**
   - Función SQL nativa que evalúa en tiempo real si un usuario
     tiene una función específica. Implementación PostgreSQL:
     ``usuario_tiene_permiso(user_id, function_code)`` y la
     variante ``verificar_permiso_y_auditar`` que registra cada
     verificación.
 * - **Menú Dinámico**
   - Estructura de navegación jerárquica calculada en runtime
     según las funciones del usuario. Implementación PostgreSQL:
     ``obtener_menu_usuario(user_id)``. Es la materialización UX
     del modelo RBAC plano (CNST_029): sin él, los permisos no
     tienen efecto visible en UI.
 * - **AuditoriaPermiso**
   - Tabla append-only que registra cada verificación de permiso
     en runtime (cumple ``CNST_025`` Auditoría Inmutable). Distinta
     de ``AuditLog`` (auditoría general del sistema) — coexisten
     como tablas separadas con misma política inmutable
     (decisión D-RBAC-3).
 * - **Segmento de Datos** (descartado en v5.2.0)
   - Concepto histórico (v5.1.x): partición lógica del dataset
     operativo que limitaba la visibilidad de un usuario via
     filtro automático ``WHERE segment_id = @user_segment``.
     Catálogo histórico de 5 segmentos: OP (operativos), FI
     (financieros), TE (técnicos), SU (supervisión), CA
     (calidad). **DESCARTADO en v5.2.0** porque la
     segmentación a nivel datos no aplica al contexto IACT:
     (a) el ETL ya entrega datos limpios y separados por
     dominio (CNST-007 BD IVR Solo Lectura + CNST-008 Ventana
     ETL); (b) la visibilidad funcional ya queda cubierta por
     la combinación **AGR (perfil operativo) + MOD (categoría
     de información) + Función (acción específica)**. Las dos
     funciones que operaban sobre segmentos (USR-010
     ``asigna_segmento`` y ACC-006 ``gestiona_segmentos``) se
     eliminaron en la transición v5.1.1 → v5.2.0 (44 → 42
     funciones). NO usar este término en docs nuevas.

----

I. Abreviaturas comunes
=======================

.. list-table::
   :header-rows: 1

   * - Abreviatura
     - Significado
   * - **ADR**
     - Architecture Decision Record
   * - **API**
     - Application Programming Interface
   * - **BA**
     - Business Analyst
   * - **BABOK**
     - Business Analysis Body of Knowledge
   * - **BR**
     - Business Requirement (también: Business Rule en contextos de reglas de negocio)
   * - **BReq**
     - Business Requirement (objetivo de negocio)
   * - **BRS**
     - Business Requirements Specification
   * - **CNST**
     - Restricción Arquitectónica
   * - **DRF**
     - Django REST Framework
   * - **ETL**
     - Extract, Transform, Load
   * - **FR**
     - Functional Requirement
   * - **IACT**
     - IVR Analytics & Customer Tracking (nombre del producto)
   * - **ISO**
     - International Organization for Standardization
   * - **IVR**
     - Interactive Voice Response
   * - **KPI**
     - Key Performance Indicator
   * - **MTM**
     - Metamodelo
   * - **N**
     - Necesidad de Negocio (prefijo de ID: ``N-XXX``)
   * - **NFR**
     - Non-Functional Requirement
   * - **OE**
     - Objetivo Estratégico
   * - **PII**
     - Personally Identifiable Information
   * - **PMBOK**
     - Project Management Body of Knowledge
   * - **PMI**
     - Project Management Institute
   * - **PMO**
     - Project Management Office
   * - **PROC**
     - Procedimiento
   * - **RBAC**
     - Role-Based Access Control
   * - **RF**
     - Requisito Funcional (también ``RQ`` en convenciones legacy)
   * - **RN**
     - Requisito de Negocio (alias: ``BR``)
   * - **RNF**
     - Requisito No Funcional (alias: ``NFR``)
   * - **RPO**
     - Recovery Point Objective
   * - **RS**
     - Requisito de Stakeholder (alias: ``SR``)
   * - **RSi**
     - Requisito de Sistema (alias del SyRS)
   * - **RTM**
     - Requirements Traceability Matrix
   * - **RTO**
     - Recovery Time Objective
   * - **SBVR**
     - Semantics of Business Vocabulary and Business Rules
   * - **SLA**
     - Service Level Agreement
   * - **SoD**
     - Separation of Duties
   * - **SR**
     - Stakeholder Requirement (alias: ``RS``)
   * - **SRS**
     - Software Requirements Specification
   * - **StRS**
     - Stakeholder Requirements Specification
   * - **SyRS**
     - System Requirements Specification
   * - **TC**
     - Caso de Prueba (Test Case)
   * - **TPL**
     - Plantilla (Template)
   * - **TXM**
     - Taxonomía
   * - **UAT**
     - User Acceptance Testing
   * - **UC**
     - Caso de Uso (Use Case)
   * - **WBS**
     - Work Breakdown Structure
   * - **WSGI**
     - Web Server Gateway Interface

----

I. Referencias
==============

1. **BABOK® Guide v3** (2015). International Institute of Business
   Analysis (IIBA).
2. **A Guide to the Project Management Body of Knowledge (PMBOK®
   Guide)** — 7th Edition (2021). Project Management Institute
   (PMI).
3. **ISO/IEC/IEEE 29148:2018** — Systems and software engineering
   — Life cycle processes — Requirements engineering.
4. **ISO/IEC 25010:2011** — Systems and software Quality
   Requirements and Evaluation (SQuaRE) — System and software
   quality models.

----

J. Mantenimiento del glosario
=============================

Este glosario se mantiene actualizado conforme el proyecto
evoluciona. Adiciones / cambios:

- Se incorporan términos nuevos cuando emergen del proyecto y
  alcanzan uso recurrente.
- Se actualizan definiciones cuando cambia el alcance del término
  (con bump de ``:version:`` en metadata).
- Términos obsoletos se marcan ``[obsoleto]`` en lugar de
  eliminarse, para preservar contexto histórico.

Historial
---------

.. list-table::
 :header-rows: 1
 :widths: 12 15 73

 * - Versión
   - Fecha
   - Cambios
 * - 1.0.0
   - 2025-12-18
   - Versión inicial: glosario IACT con ~10 términos del
     producto.
 * - 2.0.0
   - 2026-04-28
   - **Bump MAJOR.** Consolidación a un único archivo
     glosario completo. Fusión de ``IACT_Glossary.rst``
     (producto), ``glosario_babok_pmbok_iso.rst`` (metodología
     cross-framework) y ``glossary.rst`` (abreviaturas
     básicas). Añadidos términos del stack técnico real
     (Apache, Ubuntu, mod_wsgi, Webpack, MySQL, PostgreSQL,
     DRF). Reorganización en 9 secciones (A-J).
