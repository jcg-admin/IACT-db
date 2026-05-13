.. meta::
 :artefacto: ONB_BIENVENIDA
 :tipo: Guia
 :dominio: onboarding
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Interno

==========
Bienvenida
==========

Bienvenido al equipo IACT. Esta guia te orienta sobre la organizacion
del proyecto, sus convenciones y los recursos clave para empezar.

1. ¿Que es IACT?
================

IACT (IVR Analytics & Customer Tracking) es un sistema de analisis
de llamadas para call centers. Consume datos del sistema IVR del
cliente (BD MySQL readonly) via ETL y los expone via dashboards y
reportes (BD PostgreSQL + frontend React).

Ver :doc:`/base-cognitiva/_metadata/meta-04-contexto-iact` para
detalle completo.

2. Stack del producto
=====================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Capa
   - Tecnologia
 * - Frontend
   - React + Webpack
 * - Backend
   - Django REST Framework + Python 3.10+
 * - Infraestructura
   - Ubuntu Server + Apache + mod_wsgi
 * - Bases de datos
   - MySQL (operativa, RO) + PostgreSQL (analitica)

3. Recursos clave
=================

- :doc:`/base-cognitiva/index` — vocabulario y fundamentos del
  proyecto.
- :doc:`/normativa/index` — estandares, plantillas, procedimientos
  y restricciones del sistema.
- :doc:`/requisitos/index` — casos de uso, BRs, FRs, NFRs.
- :doc:`/arquitectura-tecnica/index` — modelo arquitectonico
  (RBAC, modulos).
- :doc:`/gestion/index` — gestion del proyecto, manuales, evidencias.
