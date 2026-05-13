.. meta::
 :artefacto: RUNBOOK-reprocesar-etl-fallido
 :tipo: Runbook
 :dominio: devops
 :subdominio: runbooks
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Operacional

==========================================
Runbook: Reprocesar ETL Fallido
==========================================

.. note::

 Procedimiento operativo para reprocesar una ejecución del
 pipeline ETL (IVR → Analytics) que falló o produjo datos
 incompletos. Aplica CNST-007 (BD IVR es read-only para IACT).

 **Stack del proyecto:** modular monolith (Django) sobre
 Apache + mod_wsgi en VM Vagrant. ETL corre como daemon
 ``iact-etl-scheduler`` gestionado por systemd.

1. Cuándo ejecutar
==================

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - Disparador
   - Diagnóstico previo
 * - ETL marcado FAILED en MOD_Pipeline
   - Ver uc-pip-02 logs ETL
 * - ETL marcado SUCCESS pero datos faltantes
   - Discrepancia detectada en uc-pip-03 disponibilidad
 * - Solicitud explícita del usuario
   - Vía función PIP-004 ``request_pipeline_retry``

2. Precondiciones
=================

- ETL no está actualmente en ejecución (verificar status del
  servicio ``iact-etl-scheduler``).
- Acceso SSH al servidor con permisos ``sudo``.
- BD Analytics aceptando escrituras.
- BD IVR accesible en read-only (CNST-007).
- Logs ``/var/log/iact/etl.log`` disponibles.

3. Pasos de reprocesamiento
===========================

3.1 Verificar estado actual
---------------------------

.. code-block:: bash

 # Status de la última ejecución
 curl -s https://api.iact.example/internal/etl/last-run | jq
 # Buscar campos: status, completed_at, error_message,
 #                rows_processed, expected_rows

 # Ejecuciones pendientes en cola
 curl -s https://api.iact.example/internal/etl/queue | jq

3.2 Diagnosticar causa del fallo
--------------------------------

.. code-block:: bash

 # Logs estructurados del ETL (JSON, CNST-024)
 sudo tail -n 5000 /var/log/iact/etl.log \
   | jq 'select(.level == "ERROR" and .ts > "2026-04-29T00:00:00")'

 # Status del daemon scheduler
 sudo systemctl status iact-etl-scheduler

 # Últimas líneas del journal del servicio
 sudo journalctl -u iact-etl-scheduler -n 200 --no-pager

Patrones comunes:

.. list-table::
 :widths: 40 60
 :header-rows: 1

 * - Error message típico
   - Acción
 * - ``connection timeout to ivr``
   - Verificar conectividad IVR
 * - ``constraint violation``
   - Datos incompatibles, requerir limpieza
 * - ``out of memory``
   - Fragmentar reproceso por rangos
 * - ``transaction aborted``
   - Reintentar (transitorio)

3.3 Identificar rango a reprocesar
----------------------------------

.. code-block:: bash

 # Definir el rango de datos afectado
 # Ejemplo: si falló entre 14:00-15:00 del día anterior

 START_TS="2026-04-29T14:00:00Z"
 END_TS="2026-04-29T15:00:00Z"

 # Verificar registros existentes en Analytics para este rango
 psql -h analytics.iact.internal -U iact_app -c "
   SELECT COUNT(*) FROM events
   WHERE source_timestamp BETWEEN '$START_TS' AND '$END_TS';
 "

3.4 Limpiar datos parciales si necesario
----------------------------------------

.. warning::

 Solo aplica baja lógica (BR-009 — no eliminar datos físicos).
 Marcar registros parciales como INACTIVE antes del reproceso.

.. code-block:: bash

 psql -h analytics.iact.internal -U iact_app -c "
   UPDATE events
   SET status = 'INACTIVE',
       inactivated_reason = 'reproceso ETL $(date -u +%Y%m%d)',
       updated_at = NOW()
   WHERE source_timestamp BETWEEN '$START_TS' AND '$END_TS'
     AND status = 'ACTIVE'
     AND batch_id = '<batch_fallido>';
 "

3.5 Encolar reproceso
---------------------

.. code-block:: bash

 # Vía API interna (preferido)
 curl -X POST https://api.iact.example/internal/etl/reprocess \
   -H "Content-Type: application/json" \
   -d "{
     \"start_ts\": \"$START_TS\",
     \"end_ts\": \"$END_TS\",
     \"reason\": \"fallo previo - reproceso autorizado por DevOps\"
   }"

 # Esperado: 202 Accepted + {"job_id": "..."}

3.6 Monitorear ejecución
------------------------

.. code-block:: bash

 # Seguir progreso del job
 JOB_ID="<job_id retornado>"
 watch -n 5 "curl -s https://api.iact.example/internal/etl/jobs/$JOB_ID | jq"

 # Estados esperados: PENDING -> RUNNING -> SUCCESS

4. Verificación post-reproceso
==============================

4.1 Conteo de filas
-------------------

.. code-block:: bash

 # Verificar que las filas reprocesadas equivalen a IVR
 psql -h analytics.iact.internal -U iact_app -c "
   SELECT COUNT(*) FROM events
   WHERE source_timestamp BETWEEN '$START_TS' AND '$END_TS'
     AND status = 'ACTIVE';
 "
 # Comparar con conteo en BD IVR para el mismo rango

4.2 Audit log
-------------

.. code-block:: bash

 # Confirmar que el reproceso quedó auditado (CNST-025)
 curl -s https://api.iact.example/internal/audit/recent \
   | jq '.[] | select(.action == "ETL_REPROCESS")'

5. Si el reproceso falla
========================

- Ejecutar diagnóstico (paso 3.2) sobre el job fallido.
- Si la causa es transitoria (timeout, deadlock): reintentar 1
  vez automáticamente.
- Si la causa es estructural (constraint, OOM):

  - Fragmentar en rangos más pequeños (ej. ventanas de 15 min).
  - Escalar a Tech Lead Backend.

6. Rollback
===========

Si el reproceso introdujo datos incorrectos:

.. code-block:: bash

 # Marcar el batch nuevo como INACTIVE
 psql -h analytics.iact.internal -U iact_app -c "
   UPDATE events
   SET status = 'INACTIVE',
       inactivated_reason = 'rollback reproceso ETL',
       updated_at = NOW()
   WHERE batch_id = '<batch_nuevo>';
 "

 # Reactivar batch original si estaba INACTIVE
 # (solo si el batch original tenía datos válidos)

7. Escalación
=============

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Situación
   - Acción
 * - Reproceso falla 2 veces consecutivas
   - Escalar a Tech Lead Backend
 * - BD IVR no accesible
   - Coordinar con cliente (proveedor BD IVR)
 * - Inconsistencia de datos confirmada
   - Tech Lead + DBA + Compliance

8. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **CNSTs aplicables**
   - CNST-007 (BD IVR read-only), CNST-024 (logs JSON), CNST-025 (auditoría)
 * - **BR aplicable**
   - BR-009 (no eliminar; baja lógica)
 * - **Función RBAC**
   - PIP-004 ``request_pipeline_retry``
 * - **UC relacionado**
   - uc-pip-04 (Solicitar Reintento)
 * - **Runbook relacionado**
   - :doc:`runbook-verificar-servicios`
 * - **Owner**
   - Equipo DevOps / SRE
