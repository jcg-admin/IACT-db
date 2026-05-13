.. meta::
 :artefacto: RUNBOOK-verificar-servicios
 :tipo: Runbook
 :dominio: devops
 :subdominio: runbooks
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Operacional

==============================
Runbook: Verificar Servicios
==============================

.. note::

 Procedimiento operativo para verificar el estado de salud de
 todos los servicios del sistema IACT. Diseñado para ejecutarse
 por DevOps/SRE durante incidentes, post-deployment y como
 health-check periódico programado.

 **Stack del proyecto:** modular monolith (Django) desplegado
 sobre Apache + mod_wsgi en VM provisionada con Vagrant. Ver
 :doc:`/devops/adr-devops-001-vagrant-mod-wsgi-importante-produc`.

1. Cuándo ejecutar
==================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Disparador
   - Acción
 * - Post-deployment a producción
   - Ejecutar inmediatamente tras reinicio de Apache
 * - Alerta error rate > 1%
   - Como primer diagnóstico
 * - Mantenimiento programado
   - Antes y después de la ventana
 * - Health-check periódico
   - Diario 06:00 UTC (cron job)

2. Precondiciones
=================

- Acceso SSH al servidor de aplicación.
- Acceso a las BDs (Analytics + IVR read-only).
- Credenciales del monitoring dashboard.
- Permiso ``sudo`` en el servidor (para servicios y logs).

3. Pasos de verificación
========================

3.1 Servicio Apache + mod_wsgi
------------------------------

.. code-block:: bash

 # 1. Estado del servicio Apache
 sudo systemctl status apache2

 # Esperado: active (running) sin errores recientes

 # 2. Verificar configuración válida
 sudo apache2ctl -t

 # Esperado: "Syntax OK"

 # 3. Confirmar workers de mod_wsgi corriendo
 ps aux | grep -E "wsgi|apache" | grep -v grep

 # Esperado: procesos apache2 + workers Python activos

3.2 Aplicación Django responde
------------------------------

.. code-block:: bash

 # 1. Health endpoint público
 curl -fsS https://api.iact.example/health | jq

 # Esperado: {"status": "UP", "db": "UP", "cache": "UP"}

 # 2. Latencia
 curl -o /dev/null -s -w "tiempo_total: %{time_total}s\n" \
      https://api.iact.example/health

 # Esperado: < 0.5 segundos

3.3 Conectividad de bases de datos
----------------------------------

.. code-block:: bash

 # BD Analytics (read/write)
 psql -h analytics.iact.internal -U iact_app \
      -c "SELECT 1;"
 # Esperado: 1 fila retornada en < 100ms

 # BD IVR (read-only desde IACT, CNST-007)
 psql -h ivr.iact.internal -U iact_reader \
      -c "SELECT NOW();"
 # Esperado: timestamp actual retornado

3.4 Buzón interno (CNST-002)
----------------------------

.. code-block:: bash

 # Verificar tabla de mensajes y workers internos
 curl -fsS https://api.iact.example/internal/messages/health | jq
 # Esperado: {"queue_depth": <100, "workers": "UP"}

3.5 Cola asíncrona de exports (CNST-019)
----------------------------------------

.. code-block:: bash

 # Status de la cola dedicada de exports
 curl -fsS https://api.iact.example/internal/exports/health | jq
 # Esperado: {"workers_active": >=2, "queue_depth": <50}

 # Verificar que el daemon worker está activo
 sudo systemctl status iact-export-worker
 # Esperado: active (running)

3.6 Pipeline ETL (MOD_Pipeline)
-------------------------------

.. code-block:: bash

 # Última ejecución exitosa del ETL
 curl -fsS https://api.iact.example/internal/etl/last-run | jq
 # Esperado: {"status": "SUCCESS", "completed_at": "<24h ago"}

 # Servicio del scheduler ETL
 sudo systemctl status iact-etl-scheduler
 # Esperado: active (running)

3.7 Logs sin errores recientes
------------------------------

.. code-block:: bash

 # Apache access log: 5xx en última hora
 sudo tail -n 5000 /var/log/apache2/iact_access.log \
   | awk '$9 >= 500' | wc -l
 # Esperado: < 10 (umbral configurable)

 # Apache error log: errores recientes
 sudo tail -n 100 /var/log/apache2/iact_error.log
 # Verificar que no hay tracebacks Python masivos

 # Application logs (formato JSON estructurado, CNST-024)
 sudo tail -n 1000 /var/log/iact/application.log \
   | jq 'select(.level == "ERROR")'

4. Verificación de éxito
========================

Todos los servicios reportan estado **UP**:

.. list-table::
 :widths: 35 35 30
 :header-rows: 1

 * - Servicio
   - Resultado esperado
   - Indicador
 * - Apache + mod_wsgi
   - active (running), syntax OK
   - systemctl OK
 * - Aplicación Django
   - HTTP 200 al /health, latencia < 500ms
   - curl OK
 * - BD Analytics
   - Query retorna en < 100ms
   - psql OK
 * - BD IVR (read-only)
   - Query retorna
   - psql OK
 * - Buzón interno
   - Workers UP, depth < 100
   - JSON status
 * - Cola exports
   - Workers >= 2, depth < 50
   - JSON status
 * - ETL pipeline
   - Última ejecución < 24h
   - JSON status
 * - Logs
   - 0 ERROR críticos en última hora
   - tail/jq OK

5. Si algo falla
================

5.1 Apache no inicia
--------------------

.. code-block:: bash

 # Verificar configuración
 sudo apache2ctl -t

 # Ver últimos errores de inicio
 sudo journalctl -u apache2 -n 100 --no-pager

 # Reintentar
 sudo systemctl restart apache2

 # Si persiste: validar que ningún proceso esté ocupando :443
 sudo ss -tlnp | grep :443

5.2 BD no responde
------------------

- Verificar uso CPU/IO de la BD desde monitoring.
- Revisar conexiones activas: si saturación, identificar y kill
  queries largas.
- Si persiste > 5min, escalar a DBA.

5.3 ETL atrasado más de 24h
---------------------------

- Ver :doc:`runbook-reprocesar-etl-fallido`.

6. Escalación
=============

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Severidad
   - Notificar
   - SLA respuesta
 * - 1 servicio DOWN
   - DevOps on-call
   - 15 min
 * - Apache + BD DOWN simultáneo
   - Tech Lead + DevOps Manager
   - 5 min
 * - BD principal DOWN
   - DBA + Tech Lead + Manager
   - inmediato

7. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **CNSTs aplicables**
   - CNST-002 (buzón), CNST-007 (BD dual), CNST-019 (async exports), CNST-024 (logs JSON)
 * - **ADRs DevOps**
   - :doc:`/devops/adr-devops-001-vagrant-mod-wsgi-importante-produc`
 * - **Runbooks relacionados**
   - :doc:`runbook-reprocesar-etl-fallido`
 * - **Owner**
   - Equipo DevOps / SRE
