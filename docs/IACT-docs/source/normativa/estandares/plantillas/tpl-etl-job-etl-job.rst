.. meta::
 :artefacto: TPL_ETL_JOB
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==========================================
TPL_ETL_JOB: Plantilla de Job ETL
==========================================

.. note::

 Plantilla técnica para jobs ETL (BD IVR → BD Analytics) per
 CNST-007. Aplica skill ``bpa-implement``.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Job name**
   - {kebab-lowercase}
 * - **Origen**
   - BD IVR (read-only)
 * - **Destino**
   - BD Analytics (write)
 * - **Frecuencia**
   - {N min / horaria / diaria}
 * - **Owner**
   - {Tech Lead pipeline}

2. Diseño del job
=================

- **Extracción:** SQL con paginación (CNST-014).
- **Transformación:** mapeos declarados, sin PII (CNST-009).
- **Carga:** UPSERT idempotente, batch size declarado.

3. Manejo de errores
====================

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Error
   - Acción
   - Notificación
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

4. Trazabilidad y observabilidad
================================

- Logs JSON estructurados (CNST-024).
- Métricas: rows processed, duration, error rate.
- Alertas vía buzón interno (CNST-002).

5. Runbook asociado
===================

Si el job falla, ver
:doc:`/devops/runbooks/runbook-reprocesar-etl-fallido`.

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``bpa-implement``
 * - **CNSTs aplicables**
   - CNST-002, CNST-007, CNST-009, CNST-014, CNST-024, CNST-025
 * - **Runbook**
   - :doc:`/devops/runbooks/runbook-reprocesar-etl-fallido`
