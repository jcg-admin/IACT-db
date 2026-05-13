.. meta::
 :artefacto: BReq-005
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
BReq-005: Integridad y Trazabilidad de Datos
==================================================

.. note::

 Business Requirement nivel 2 — Categoría **Seguridad** per
 :doc:`/normativa/procedimientos/proc-req-001-generacion-breq` § 3.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BReq-005
 * - **Nombre**
   - Integridad y Trazabilidad de Datos
 * - **Categoría**
   - Seguridad / Datos
 * - **Prioridad**
   - Crítica
 * - **Estado**
   - Borrador
 * - **Stakeholder primario**
   - Auditor, Operador ETL, Arquitecto

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE garantizar **0 escrituras no
autorizadas** sobre la fuente operativa (BD del IVR), un
pipeline ETL que preserve la integridad de los datos
analíticos, y políticas de retención + bajas lógicas que
permitan reconstruir el estado del sistema en cualquier
punto temporal dentro del horizonte de retención.

3. Justificación de negocio
===========================

El IVR es la fuente operativa transaccional del call
center. Una escritura no autorizada desde IACT corrompería
operación en vivo. Adicionalmente:

- Sin trazabilidad temporal no es posible auditar
  comportamiento histórico ante reclamos.
- Sin bajas lógicas, datos relevantes desaparecen.
- Sin retención clara, costos de almacenamiento crecen sin
  control.

4. Criterios de éxito
=====================

BReq-005 se considera satisfecho cuando:

1. **0** escrituras de IACT sobre BD IVR (validable por
   permisos de BD: lectura solamente).
2. ETL nocturno (CNST-004) reproduce datos completos sin
   pérdida ≥ 99.9% de las ejecuciones.
3. Bajas lógicas activas en User, Session, Assignment
   (BR-009).
4. Retención automática de 2 años (BR-019, CNST-006).

5. Trazabilidad downstream
==========================

**Business Rules (BR) derivadas:**

- :doc:`/requisitos/reglas-negocio/br-001-fuente-operacional-inmutable`
- :doc:`/requisitos/reglas-negocio/br-002-etl-batch-nocturno`
- :doc:`/requisitos/reglas-negocio/br-009-bajas-logicas`
- :doc:`/requisitos/reglas-negocio/br-019-retencion-2-anios`
- :doc:`/requisitos/reglas-negocio/br-020-clasificacion-datos`

**Casos de Uso (UC) primarios:**

- PIP cluster (Pipeline ETL): UC_PIP_01..04

**BRQ legacy mapeados:**

- BRQ-PIP-001..004

6. Constraints aplicables
=========================

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Aplicación
 * - CNST-003
   - BD dual: IVR readonly / Analytics transaccional
 * - CNST-004
   - ETL batch nocturno consolidado
 * - CNST-006
   - Retención 2 años
 * - CNST-010
   - Clasificación de datos

7. Trazabilidad metodológica
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Procedimiento de creación**
   - :doc:`/normativa/procedimientos/proc-req-001-generacion-breq`
 * - **Plantilla**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
 * - **Origen FND**
   - :doc:`/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles`
     § 3.5 BReq-005
