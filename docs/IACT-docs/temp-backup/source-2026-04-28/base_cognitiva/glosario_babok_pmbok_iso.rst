Glosario Integrado: BABOK v3, PMBOK 7th Ed, ISO/IEC/IEEE 29148:2018
===================================================================

Este glosario consolida términos clave de los tres estándares utilizados
en el proyecto IACT.

--------------

Términos BABOK v3 (Business Analysis Body of Knowledge)
-------------------------------------------------------

+----------------+---------------------+-------------------------------+
| Término        | Definición          | Ejemplo en IACT               |
+================+=====================+===============================+
| **Business     | Problema u          | N-001: Reducir roturas de     |
| Need**         | oportunidad que     | stock                         |
|                | debe abordarse para |                               |
|                | lograr objetivos    |                               |
|                | organizacionales    |                               |
+----------------+---------------------+-------------------------------+
| **Business     | Objetivo, meta o    | RN-001: Sistema de alertas    |
| Requirement    | resultado de alto   | automáticas                   |
| (BR)**         | nivel que el        |                               |
|                | negocio debe lograr |                               |
+----------------+---------------------+-------------------------------+
| **Stakeholder  | Necesidad           | RS-001: Gerente necesita      |
| Requirement    | específica de       | alertas en dashboard          |
| (SR)**         | usuarios, clientes  |                               |
|                | y partes            |                               |
|                | interesadas         |                               |
+----------------+---------------------+-------------------------------+
| **Solution     | Capacidades que     | RF-001: API calcular stock    |
| Requirement**  | debe tener la       | mínimo                        |
|                | solución            |                               |
|                | (Funcionales + No   |                               |
|                | Funcionales)        |                               |
+----------------+---------------------+-------------------------------+
| **Functional   | Comportamiento,     | RF-001: Sistema DEBERÁ        |
| Requirement    | acción o capacidad  | calcular stock                |
| (FR)**         | que el sistema debe |                               |
|                | realizar            |                               |
+----------------+---------------------+-------------------------------+
| **             | Característica de   | RNF-001: Tiempo respuesta <   |
| Non-Functional | calidad que el      | 200ms                         |
| Requirement    | sistema debe poseer |                               |
| (NFR)**        |                     |                               |
+----------------+---------------------+-------------------------------+
| **Business     | Rol responsable de  | Equipo BA del proyecto IACT   |
| Analyst (BA)** | elicitar, analizar  |                               |
|                | y documentar        |                               |
|                | requisitos          |                               |
+----------------+---------------------+-------------------------------+
| **Requirements | Relación            | N-001 → RN-001 → RF-001       |
| Traceability** | bidireccional entre |                               |
|                | requisitos de       |                               |
|                | diferentes niveles  |                               |
+----------------+---------------------+-------------------------------+

--------------

Términos PMBOK Guide 7th Ed (Project Management)
------------------------------------------------

+------------------+------------------------+--------------------------+
| Término          | Definición             | Uso en IACT              |
+==================+========================+==========================+
| **Project        | Documento que autoriza | Charter para             |
| Charter**        | formalmente el         | implementación de        |
|                  | proyecto               | requisitos               |
+------------------+------------------------+--------------------------+
| **Stakeholder**  | Individuo, grupo u     | Gerentes de compras,     |
|                  | organización afectado  | analistas, usuarios      |
|                  | por el proyecto        |                          |
+------------------+------------------------+--------------------------+
| **Scope**        | Trabajo requerido para | Alcance definido en      |
|                  | entregar               | necesidades (N-XXX)      |
|                  | producto/servicio      |                          |
+------------------+------------------------+--------------------------+
| **Work Breakdown | Descomposición         | Fases 0-6 de la          |
| Structure        | jerárquica del trabajo | propuesta                |
| (WBS)**          |                        |                          |
+------------------+------------------------+--------------------------+
| **Risk**         | Evento incierto que    | Riesgos documentados en  |
|                  | puede impactar         | cada requisito           |
|                  | objetivos              |                          |
+------------------+------------------------+--------------------------+
| **Deliverable**  | Producto, resultado o  | BRS, StRS, SyRS, SRS,    |
|                  | capacidad entregable   | RTM                      |
+------------------+------------------------+--------------------------+
| **Milestone**    | Punto significativo en | Hitos en cada fase de    |
|                  | el cronograma          | migración                |
+------------------+------------------------+--------------------------+
| **Baseline**     | Versión aprobada de un | Baselines en             |
|                  | artefacto              | docs/gobernanza/         |
+------------------+------------------------+--------------------------+

--------------

Términos ISO/IEC/IEEE 29148:2018 (Requirements Engineering)
-----------------------------------------------------------

+-------------+------------------+-------------------------------------+
| Término     | Definición       | Implementación en IACT              |
+=============+==================+=====================================+
| **BRS       | Documento con    | ``docs/requis                       |
| (Business   | requisitos de    | itos/brs_business_requirements.md`` |
| R           | negocio (Clause  |                                     |
| equirements | 9.3)             |                                     |
| Speci       |                  |                                     |
| fication)** |                  |                                     |
+-------------+------------------+-------------------------------------+
| **StRS      | Documento con    | ``docs/requisitos                   |
| (           | requisitos de    | /strs_stakeholder_requirements.md`` |
| Stakeholder | stakeholders     |                                     |
| R           | (Clause 9.4)     |                                     |
| equirements |                  |                                     |
| Speci       |                  |                                     |
| fication)** |                  |                                     |
+-------------+------------------+-------------------------------------+
| **SyRS      | Documento con    | ``docs/requi                        |
| (System     | requisitos de    | sitos/syrs_system_requirements.md`` |
| R           | sistema (Clause  |                                     |
| equirements | 9.5)             |                                     |
| Speci       |                  |                                     |
| fication)** |                  |                                     |
+-------------+------------------+-------------------------------------+
| **SRS       | Documento con    | ``docs/requis                       |
| (Software   | requisitos de    | itos/srs_software_requirements.md`` |
| R           | software (Clause |                                     |
| equirements | 9.6)             |                                     |
| Speci       |                  |                                     |
| fication)** |                  |                                     |
+-------------+------------------+-------------------------------------+
| **RTM       | Matriz de        | ``docs/requ                         |
| (R          | trazabilidad     | isitos/matriz_trazabilidad_rtm.md`` |
| equirements | bidireccional    |                                     |
| T           |                  |                                     |
| raceability |                  |                                     |
| Matrix)**   |                  |                                     |
+-------------+------------------+-------------------------------------+
| **          | Estructura:      | “El sistema DEBERÁ calcular…”       |
| Requirement | Subject + Modal  |                                     |
| Construct** | Verb + Action +  |                                     |
|             | Object +         |                                     |
|             | Condition        |                                     |
+-------------+------------------+-------------------------------------+
| **Ver       | Confirmar que    | Tests, inspecciones, análisis       |
| ification** | requisito está   |                                     |
|             | correctamente    |                                     |
|             | especificado     |                                     |
+-------------+------------------+-------------------------------------+
| **V         | Confirmar que    | UAT con stakeholders                |
| alidation** | requisito        |                                     |
|             | satisface        |                                     |
|             | necesidad real   |                                     |
+-------------+------------------+-------------------------------------+
| **Full      | Cumplir todos    | Objetivo de la reestructuración     |
| Co          | los requisitos   |                                     |
| nformance** | de Clause 4.2    |                                     |
+-------------+------------------+-------------------------------------+

--------------

Jerarquía de Requisitos (Integrada)
-----------------------------------

::

   Objetivos Estratégicos (OE-XXX)
       ↓
   Necesidades de Negocio (N-XXX) ← BABOK: Business Need
       ↓
   Requisitos de Negocio (RN-XXX) ← BABOK: BR / ISO 29148: BRS (Clause 9.3)
       ↓
   Requisitos de Stakeholders (RS-XXX) ← BABOK: SR / ISO 29148: StRS (Clause 9.4)
       ↓
       ├─ Requisitos de Sistema (SyRS) ← ISO 29148: SyRS (Clause 9.5)
       │     ↓
       │  Requisitos Funcionales (RF-XXX) ← BABOK: FR / ISO 29148: SRS (Clause 9.6)
       │     ↓
       └─ Requisitos No Funcionales (RNF-XXX) ← BABOK: NFR / ISO 25010
             ↓
   Tests/Casos de Prueba (TEST-XXX)

--------------

Verbos Modales (ISO 29148 - Clause 5.2.4)
-----------------------------------------

+-----------------------+-----------------------+-----------------------+
| Verbo Modal           | Significado           | Uso en IACT           |
+=======================+=======================+=======================+
| **SHALL / DEBERÁ**    | Requisito obligatorio | “El sistema DEBERÁ    |
|                       |                       | validar…”             |
+-----------------------+-----------------------+-----------------------+
| **SHOULD / DEBERÍA**  | Requisito recomendado | “El sistema DEBERÍA   |
|                       | pero no obligatorio   | notificar…”           |
+-----------------------+-----------------------+-----------------------+
| **MAY / PUEDE**       | Requisito opcional    | “El sistema PUEDE     |
|                       |                       | incluir…”             |
+-----------------------+-----------------------+-----------------------+
| **MUST NOT / NO       | Prohibición           | “El sistema NO DEBERÁ |
| DEBERÁ**              |                       | exponer…”             |
+-----------------------+-----------------------+-----------------------+

--------------

Métodos de Verificación (ISO 29148 - Clause 6.5.2.2)
----------------------------------------------------

+--------------+-----------------------+-------------------------------+
| Método       | Descripción           | Ejemplo en IACT               |
+==============+=======================+===============================+
| **Test**     | Ejecutar el sistema   | Tests automatizados pytest    |
|              | con inputs            |                               |
|              | específicos           |                               |
+--------------+-----------------------+-------------------------------+
| **           | Examen visual del     | Code review, revisión de      |
| Inspection** | producto              | documentación                 |
+--------------+-----------------------+-------------------------------+
| **Analysis** | Uso de modelos        | Análisis estático, revisión   |
|              | analíticos sin        | de diseño                     |
|              | ejecutar              |                               |
+--------------+-----------------------+-------------------------------+
| **Dem        | Observación del       | Demo a stakeholders, UAT      |
| onstration** | comportamiento        |                               |
|              | operacional           |                               |
+--------------+-----------------------+-------------------------------+

--------------

Abreviaturas Comunes
--------------------

=========== ======================================
Abreviatura Significado
=========== ======================================
**BA**      Business Analyst
**BABOK**   Business Analysis Body of Knowledge
**BR**      Business Requirement
**BRS**     Business Requirements Specification
**FR**      Functional Requirement
**NFR**     Non-Functional Requirement
**PMBOK**   Project Management Body of Knowledge
**PMO**     Project Management Office
**RTM**     Requirements Traceability Matrix
**SR**      Stakeholder Requirement
**SRS**     Software Requirements Specification
**StRS**    Stakeholder Requirements Specification
**SyRS**    System Requirements Specification
**UAT**     User Acceptance Testing
=========== ======================================

--------------

Referencias
-----------

1. **BABOK® Guide v3** (2015). International Institute of Business
   Analysis (IIBA)
2. **A Guide to the Project Management Body of Knowledge (PMBOK®
   Guide)** – 7th Edition (2021). Project Management Institute (PMI)
3. **ISO/IEC/IEEE 29148:2018** - Systems and software engineering — Life
   cycle processes — Requirements engineering

--------------

**Nota**: Este glosario debe mantenerse actualizado conforme el proyecto
evolucione.

**Última actualización**: 2025-11-03
