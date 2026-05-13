.. meta::
 :artefacto: INDEX_RUNBOOKS
 :tipo: Indice
 :dominio: devops
 :subdominio: runbooks
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================
Runbooks DevOps
==================

Procedimientos operativos paso a paso para tareas recurrentes
del sistema IACT. Cada runbook está diseñado para ejecutarse
bajo presión (incidentes, mantenimientos, troubleshooting) sin
ambigüedad.

Catálogo
========

.. toctree::
 :maxdepth: 1

 runbook-verificar-servicios
 runbook-reprocesar-etl-fallido

Convención
==========

Cada runbook incluye:

- **Cuándo ejecutar** — trigger condition explícito.
- **Precondiciones** — qué debe ser cierto antes.
- **Pasos numerados** — sin ambigüedad operativa.
- **Verificación** — cómo confirmar éxito.
- **Rollback** — si algo falla, cómo revertir.
- **Escalación** — a quién avisar si no se resuelve.

Sigue STD-007 (kebab-lowercase).
