.. meta::
   :artefacto: OPERATIONS_CONVENTIONS
   :tipo: Convenciones del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Operations — Convenciones
============================================

Formato de runbooks
===================

Cada runbook sigue una plantilla mínima:

::

    Título del runbook
    ──────────────────

    Cuándo se aplica
        Trigger explícito (alerta, condición, hora programada).

    Pre-requisitos
        Permisos, accesos, tooling necesario.

    Pasos
        Numerados, idempotentes cuando posible.

    Verificación
        Cómo se confirma que el runbook tuvo el efecto deseado.

    Rollback
        Si aplica: cómo deshacer.

    Escalación
        A quién notificar si los pasos fallan.

    Última revisión
        Fecha + autor.

Naming
======

- Runbooks: ``{categoria}-{accion}.rst`` en kebab-case
  (ej: ``deploy-production.rst``,
  ``restore-postgres-from-backup.rst``).
- Categorías estándar: ``deploy``, ``rollback``, ``backup``,
  ``restore``, ``incident``, ``maintenance``, ``failover``.

Severidad de incidentes
=======================

::

    S1 — Producción caída total o pérdida de datos
         Response: inmediata, on-call escalado.
         SLA de detección: <5 min.
         SLA de respuesta: <15 min.

    S2 — Función crítica degradada
         Response: durante horario laboral extendido.
         SLA de respuesta: <1 hora.

    S3 — Función no crítica afectada
         Response: durante horario laboral.
         SLA de respuesta: <1 día.

    S4 — Cosmético / mejora
         Response: backlog de operaciones.

Logging
=======

- Formato estructurado (JSON) para logs de aplicación.
- Niveles: DEBUG (solo dev), INFO (rutinario), WARN (anomalía),
  ERROR (fallo recuperable), CRITICAL (fallo grave).
- Logs de auditoría (acciones de usuarios) en logger separado
  ``audit``, destino inmutable (CNST aplicable).

Métricas
========

- Recolección con un colector (Prometheus / equivalente —
  pendiente decisión).
- Naming de métricas: ``iact_{componente}_{metric}_{unidad}``
  (ej: ``iact_api_request_duration_seconds``,
  ``iact_etl_rows_processed_total``).
- Cardinality controlada (no labels de alta cardinalidad como
  user_id en métricas globales).

Alertas
=======

- Threshold + duración (no alertar por spikes momentáneos).
- Cada alerta debe tener:

  - Severidad asignada.
  - Runbook linkeado.
  - Owner asignado.

- Sin alertas sin owner — si no hay quien responda, la alerta
  no debería existir o degrada a S4.

Deploy
======

- Una sola fuente de verdad para artefactos a deployar
  (registro/repo).
- Tag SemVer en el commit que se va a deployar.
- Deploy es **idempotente**: ejecutar 2 veces produce el mismo
  estado.
- Rollback es deploy de la versión anterior (no manual fix).

Maintenance windows
===================

- Documentadas con anticipación.
- Frecuencia, duración, comunicación: política en
  :doc:`/normativa/restricciones/index` o
  :doc:`/normativa/procedimientos/index`.
