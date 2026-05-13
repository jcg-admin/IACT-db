.. meta::
 :artefacto: BReq-002
 :tipo: Business Requirement
 :dominio: requisitos
 :subdominio: business-requirements
 :estado: Borrador
 :version: 1.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Interno

=========================================================
BReq-002: Reducción de Tiempo de Resolución de Incidentes
=========================================================

.. note::

 Business Requirement nivel 2 (jerarquía de 5 niveles per
 :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`).
 Categoría per
 :doc:`/normativa/procedimientos/proc-req-001-generacion-breq` § 3:
 **Funcionalidad Core**.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BReq-002
 * - **Nombre**
   - Reducción de Tiempo de Resolución de Incidentes
 * - **Tipo**
   - Business Requirement (nivel 2)
 * - **Categoría**
   - Funcionalidad Core
 * - **Prioridad**
   - Alta
 * - **Estado**
   - Borrador
 * - **Stakeholder primario**
   - Supervisores, Gestores Operacionales

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE proveer **detección temprana de
condiciones anómalas** en la operación del call center
(saturación de colas, agentes inactivos, abandonos
elevados) y **notificación oportuna** a los responsables
para reducir el tiempo de resolución de incidentes
operativos.

3. Justificación de negocio
===========================

Sin alertas tempranas, los supervisores reaccionan a los
incidentes con base en reportes diarios o reclamos de
clientes — el tiempo de resolución se mide en horas o días.
Con alertas operativas, la reacción se mide en minutos.

Beneficios esperados:

- Reducción ≥ 40% del tiempo medio de resolución
  vs línea base (FND_05 § 3.4).
- Mejora del NPS por menor tiempo de cliente en cola.
- Reducción de abandonos por saturación.

4. Criterios de éxito
=====================

BReq-002 se considera satisfecho cuando:

1. Sistema permite configurar umbrales operacionales
   por métrica (CNST-014).
2. Sistema detecta cruces de umbral en ≤ 60 s desde la
   ocurrencia.
3. Sistema notifica al responsable vía
   ``InternalMailbox`` (CNST-001 + CNST-002) en ≤ 60 s
   adicionales.
4. Tiempo medio de resolución (TMR) post-implementación
   se reduce ≥ 40% vs baseline.

5. Trazabilidad downstream
==========================

**Business Rules (BR) derivadas (Nivel 1):**

- :doc:`/requisitos/reglas-negocio/br-014-alerta-por-umbral`
- :doc:`/requisitos/reglas-negocio/br-015-bloqueo-intentos-fallidos`

**Casos de Uso (UC) primarios (Nivel 3):**

- :doc:`/requisitos/casos-uso/alerts/uc-alr-01/index`
- :doc:`/requisitos/casos-uso/alerts/uc-alr-02/index`
- :doc:`/requisitos/casos-uso/alerts/uc-alr-03/index`
- :doc:`/requisitos/casos-uso/alerts/uc-alr-04/index`
- :doc:`/requisitos/casos-uso/alerts/uc-alr-05/index`

**BRQ legacy mapeados (Modelo C — Modelo D ver § 7):**

- BRQ-ALR-001..006

6. Constraints aplicables
=========================

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Aplicación
 * - CNST-001
   - Notificación SOLO vía buzón interno
 * - CNST-002
   - Buzón interno obligatorio
 * - CNST-014
   - Umbrales configurables por usuario AGR-007
 * - CNST-025
   - AuditEvent inmutable de cada alerta

7. Trazabilidad metodológica
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Procedimiento de creación**
   - :doc:`/normativa/procedimientos/proc-req-001-generacion-breq`
 * - **Procedimiento de derivación**
   - :doc:`/normativa/procedimientos/proc-req-002-derivacion-breq-br`
 * - **Plantilla**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
 * - **ADR jerarquía**
   - :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`
 * - **Origen FND**
   - :doc:`/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles`
     § 3.4-3.5
