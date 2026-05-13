.. meta::
 :artefacto: BReq-006
 :tipo: Business Requirement
 :dominio: requisitos
 :subdominio: business-requirements
 :estado: Borrador
 :version: 1.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================
BReq-006: Operación Continua con SLA
==================================================

.. note::

 Business Requirement nivel 2 — Categoría **Rendimiento**
 per :doc:`/normativa/procedimientos/proc-req-001-generacion-breq` § 3.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BReq-006
 * - **Nombre**
   - Operación Continua con SLA
 * - **Categoría**
   - Rendimiento
 * - **Prioridad**
   - Alta
 * - **Estado**
   - Borrador
 * - **Stakeholder primario**
   - Soporte Técnico, Gestor Operacional

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE operar con **alta disponibilidad
durante el horario operativo del call center** y proveer
**bitácoras de sistema accesibles, rotadas y archivadas
para soporte técnico** que permitan diagnóstico rápido
de incidentes operativos.

3. Justificación de negocio
===========================

El call center opera 16 horas al día (turnos diurnos +
vespertinos). Caídas de IACT durante operación implican:

- Supervisores ciegos a la operación.
- Métricas perdidas (no recuperables retroactivamente).
- Decisiones reactivas sin datos.

Las bitácoras (logs) son el principal insumo de soporte
para diagnosticar incidentes técnicos.

4. Criterios de éxito
=====================

BReq-006 se considera satisfecho cuando:

1. Disponibilidad ≥ 99.5% durante horario operativo
   (SLA medible vía monitoreo).
2. Logs estructurados (CNST-008 JSON) accesibles en
   tiempo casi real.
3. Rotación y archivado de logs automática.
4. Tiempos de respuesta API ≤ SLA (CNST-017).

5. Trazabilidad downstream
==========================

**Business Rules (BR) derivadas:**

- :doc:`/requisitos/reglas-negocio/br-003-usuario-inactivo-90-dias`
- :doc:`/requisitos/reglas-negocio/br-019-retencion-2-anios`

**Casos de Uso (UC) primarios:**

- LOG cluster: UC_LOG_01..07

**BRQ legacy mapeados:**

- BRQ-LOG-001..007

6. Constraints aplicables
=========================

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Aplicación
 * - CNST-008
   - Logs JSON estructurado
 * - CNST-017
   - SLA tiempos de respuesta
 * - CNST-018
   - Métricas de proceso (RNF)

7. Trazabilidad metodológica
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Procedimiento de creación**
   - :doc:`/normativa/procedimientos/proc-req-001-generacion-breq`
 * - **Plantilla**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
 * - **Categoría proc-req-001**
   - § 3 Rendimiento (BReq_003 en proc original)
