.. meta::
 :artefacto: DB_002
 :tipo: Pipeline ETL
 :dominio: databases
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Alto

============
Pipeline ETL
============

Documenta el proceso ETL (Extract, Transform, Load) que sincroniza
datos desde la BD MySQL IVR del cliente hacia la BD PostgreSQL
Analytics del sistema IACT.

1. Restricciones canonicas
===========================

- **Frecuencia:** cada 6 a 12 horas (CNST_008). NO puede ser menor a
  6h ni mayor a 12h.
- **Mecanismo:** ``django-crontab`` o scheduler equivalente.
- **Ventana preferente:** 02:00-04:00 hora local.
- **Prohibido:** Debezium, WebSockets, polling agresivo, replicacion
  sincrona, triggers cross-database.

2. Etapas
=========

.. list-table::
 :widths: 15 35 50
 :header-rows: 1

 * - Etapa
   - Componente
   - Responsabilidad
 * - Extract
   - ``etl/extractors/``
   - Lee de BD MySQL IVR (SELECT only)
 * - Transform
   - ``etl/transformers/``
   - Calcula metricas derivadas (tasa abandono, TMO, etc.)
 * - Load
   - ``etl/loaders/``
   - Inserta/upserta en BD PostgreSQL Analytics
 * - Track
   - Modelo ``ETLRun``
   - Registra inicio, fin, registros procesados, errores

3. Casos de uso relacionados
=============================

- :doc:`/requisitos/casos-uso/pipeline/uc-pip-01/index`
- :doc:`/requisitos/casos-uso/pipeline/uc-pip-02/index`
- :doc:`/requisitos/casos-uso/pipeline/uc-pip-03/index`
- :doc:`/requisitos/casos-uso/pipeline/uc-pip-04/index`

4. Reglas de negocio
====================

- :doc:`/requisitos/reglas-negocio/br-002-etl-batch-nocturno`
- :doc:`/requisitos/reglas-negocio/br-003-usuario-inactivo-90-dias`

5. UI obligatoria
=================

Las vistas que consultan datos provenientes de IVR DEBEN mostrar al
usuario el ``timestamp`` de la ultima actualizacion ETL para que la
edad de los datos sea explicita (per CNST_008 §UI obligatoria).
