.. meta::
 :artefacto: BReq-007
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
BReq-007: Integración con IVR Operacional
==================================================

.. note::

 Business Requirement nivel 2 — Categoría **Integración**
 per :doc:`/normativa/procedimientos/proc-req-001-generacion-breq` § 3.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BReq-007
 * - **Nombre**
   - Integración con IVR Operacional
 * - **Categoría**
   - Integración
 * - **Prioridad**
   - Crítica
 * - **Estado**
   - Borrador
 * - **Stakeholder primario**
   - Operador ETL, Arquitecto de Datos

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE consumir datos del IVR operacional
mediante un **pipeline ETL nocturno desacoplado**, sin
afectar la operación en vivo del IVR y manteniendo la
consistencia analítica entre las dos fuentes.

3. Justificación de negocio
===========================

El IVR es un sistema de tiempo real cuyas tablas no deben
ser bloqueadas por consultas analíticas. La separación
ETL → BD analítica desacopla:

- Carga del IVR (preserva SLA operativo).
- Cómputos analíticos pesados (no impactan IVR).
- Esquema analítico (puede evolucionar sin tocar IVR).

4. Criterios de éxito
=====================

BReq-007 se considera satisfecho cuando:

1. ETL nocturno completa la consolidación del día
   anterior antes del inicio del horario operativo
   (CNST-004).
2. **0** queries de IACT sobre BD IVR durante horario
   operativo (validable en logs de BD).
3. Discrepancia entre IVR y Analytics ≤ 0.1% en
   reconciliación diaria.
4. Pipeline ETL supervisable y auditable (UC_PIP_01).

5. Trazabilidad downstream
==========================

**Business Rules (BR) derivadas:**

- :doc:`/requisitos/reglas-negocio/br-001-fuente-operacional-inmutable`
- :doc:`/requisitos/reglas-negocio/br-002-etl-batch-nocturno`

**Casos de Uso (UC) primarios:**

- PIP cluster: UC_PIP_01..04

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
   - ETL batch nocturno
 * - CNST-018
   - Métricas de proceso ETL

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
   - § 3 Integración (BReq_007-008 en proc original)
