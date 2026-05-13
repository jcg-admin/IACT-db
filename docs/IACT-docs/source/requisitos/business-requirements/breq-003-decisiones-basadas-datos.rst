.. meta::
 :artefacto: BReq-003
 :tipo: Business Requirement
 :dominio: requisitos
 :subdominio: business-requirements
 :estado: Borrador
 :version: 1.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Interno

============================================================
BReq-003: Decisiones Operacionales Basadas en Datos
============================================================

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
   - BReq-003
 * - **Nombre**
   - Decisiones Operacionales Basadas en Datos
 * - **Tipo**
   - Business Requirement (nivel 2)
 * - **Categoría**
   - Funcionalidad Core
 * - **Prioridad**
   - Alta
 * - **Estado**
   - Borrador
 * - **Stakeholder primario**
   - Gestores Operacionales, Supervisores, Analistas

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE proveer **reportería analítica
históricamente verificable** y **métricas operacionales
calculadas con definiciones canónicas** para que el 100%
de las decisiones de gestión del call center se sustenten
en datos trazables, no en juicios subjetivos.

3. Justificación de negocio
===========================

Las decisiones de capacidad, dotación, evaluación de
agentes y SLAs requieren métricas consistentes y
auditables. Sin canon de cálculo:

- Distintos reportes producen cifras distintas para la
  misma métrica.
- No es posible comparar períodos.
- Las evaluaciones de agentes carecen de equidad.

4. Criterios de éxito
=====================

BReq-003 se considera satisfecho cuando:

1. Las métricas calculadas (Tasa Abandono, TMW, Eficiencia)
   tienen una sola definición canónica documentada.
2. 100% de los reportes operativos consumen las
   definiciones canónicas (no formulas ad-hoc).
3. Los reportes históricos son re-ejecutables y producen
   los mismos resultados.
4. Los reportes son exportables (CNST-019/020) para
   análisis fuera del sistema.

5. Trazabilidad downstream
==========================

**Business Rules (BR) derivadas:**

- :doc:`/requisitos/reglas-negocio/br-016-tasa-abandono`
- :doc:`/requisitos/reglas-negocio/br-017-tiempo-promedio-espera`
- :doc:`/requisitos/reglas-negocio/br-018-indice-eficiencia`
- :doc:`/requisitos/reglas-negocio/br-011-limites-exportacion`

**Casos de Uso (UC) primarios:**

- :doc:`/requisitos/casos-uso/reports/uc-rpt-01/index`
- :doc:`/requisitos/casos-uso/reports/uc-rpt-02/index`
- :doc:`/requisitos/casos-uso/reports/uc-rpt-03/index`
- :doc:`/requisitos/casos-uso/reports/uc-rpt-04/index`

**BRQ legacy mapeados:**

- BRQ-RPT-001..017 (excepto huecos en numeración 006)

6. Constraints aplicables
=========================

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Aplicación
 * - CNST-007
   - Datos desde BD Analytics (no IVR directa)
 * - CNST-008
   - Filtrado automático por segmento del usuario
 * - CNST-015
   - Retención máxima 2 años de métricas históricas
 * - CNST-019
   - Exportaciones asíncronas
 * - CNST-020
   - Throttling exportaciones masivas

7. Trazabilidad metodológica
============================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Procedimiento de creación**
   - :doc:`/normativa/procedimientos/proc-req-001-generacion-breq`
 * - **Plantilla**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
 * - **ADR jerarquía**
   - :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`
 * - **Origen FND**
   - :doc:`/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles`
     § 3.5 BReq-003
