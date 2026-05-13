.. meta::
 :artefacto: BReq-001
 :tipo: Business Requirement
 :dominio: requisitos
 :subdominio: business-requirements
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

============================================
BReq-001: Visibilidad de Métricas Operativas
============================================

.. note::

 Business Requirement nivel 1 (más alto de la jerarquía de 5
 niveles per :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`).
 Aplica skill ``ba-elicitation``.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BReq-001
 * - **Nombre**
   - Visibilidad de Métricas Operativas
 * - **Tipo**
   - Business Requirement (nivel 1)
 * - **Prioridad**
   - Crítica
 * - **Estado**
   - Aprobado
 * - **Stakeholder primario**
   - Operadores, Supervisores, Gestores

2. Enunciado del objetivo de negocio
====================================

El sistema IACT DEBE proveer **visibilidad en tiempo real y
histórica** de las métricas operativas del call center IVR
(llamadas, tiempos de espera, agentes, colas, transferencias)
para permitir la toma de decisiones basadas en datos por parte
de los stakeholders operativos.

3. Justificación de negocio
===========================

Sin visibilidad de métricas, los operadores y supervisores no
pueden:

- Identificar problemas operativos en tiempo real (colas
  saturadas, agentes inactivos).
- Analizar tendencias históricas para optimización.
- Reportar SLAs cumplidos / incumplidos.
- Tomar decisiones de capacidad y planificación.

4. Criterios de éxito
=====================

BReq-001 se considera satisfecho cuando:

1. El sistema muestra métricas operativas con latencia ≤ 10s.
2. Permite consultas históricas hasta 2 años (CNST-015).
3. Filtra por segmento del usuario (CNST-008).
4. Soporta exportación de datos (CNST-019/020).
5. Cumple SLAs de tiempo de respuesta (CNST-017).

5. Trazabilidad downstream (deriva en)
======================================

**Business Rules (BR) derivadas:**

- :doc:`/requisitos/reglas-negocio/br-016-tasa-abandono`
- :doc:`/requisitos/reglas-negocio/br-017-tiempo-promedio-espera`
- :doc:`/requisitos/reglas-negocio/br-018-indice-eficiencia`

**Casos de Uso (UC) primarios:**

- :doc:`/requisitos/casos-uso/reports/uc-rpt-01/index`
- :doc:`/requisitos/casos-uso/reports/uc-rpt-02/index`
- :doc:`/requisitos/casos-uso/reports/uc-rpt-03/index`

**Requisitos No Funcionales (RNF):**

- :doc:`/requisitos/requisitos-no-funcionales/rnf-proc-002-metricas-proceso`

6. Constraints aplicables
=========================

.. list-table::
 :widths: 20 80
 :header-rows: 1

 * - CNST
   - Aplicación
 * - CNST_007
   - Datos desde BD Analytics (no IVR directa)
 * - CNST_008
   - Filtrado automático por segmento del usuario
 * - CNST_015
   - Retención máxima 2 años de métricas históricas
 * - CNST_017
   - SLA de tiempos de respuesta
 * - CNST_019/020
   - Exportaciones asíncronas + throttling

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-elicitation`` (BABOK — Elicitation)
 * - **Plantilla**
   - :doc:`/normativa/estandares/plantillas/tpl-breq-objetivos-negocio`
 * - **ADR jerarquía**
   - :doc:`/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles`
 * - **Stakeholder analysis**
   - Documentar via :doc:`/normativa/estandares/plantillas/tpl-stk-stakeholder-analysis`
