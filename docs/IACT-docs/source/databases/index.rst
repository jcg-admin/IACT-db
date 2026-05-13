.. meta::
 :artefacto: INDEX_DATABASES
 :tipo: Indice
 :dominio: databases
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

==============
Bases de Datos
==============

Documentacion del modelo de datos dual del sistema IACT (MySQL IVR
readonly + PostgreSQL Analytics) y del pipeline ETL.

.. toctree::
 :maxdepth: 1

 modelo-dual
 etl-pipeline

.. note::

 Las restricciones del modelo de datos viven en
 :doc:`/normativa/restricciones/cnst-006-arquitectura-de-base-de-datos-dual`,
 :doc:`/normativa/restricciones/cnst-007-base-de-datos-ivr-es-solo-lectura`,
 :doc:`/normativa/restricciones/cnst-008-sincronizacion-etl-en-ventana-de-6-a-12-horas`.
