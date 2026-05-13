.. meta::
 :artefacto: TPL_TROUBLESHOOTING
 :tipo: Plantilla
 :dominio: normativa
 :subdominio: estandares/plantillas
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

=================================================
TPL_TROUBLESHOOTING: Plantilla de Troubleshooting
=================================================

.. note::

 Plantilla para documentar guías de troubleshooting tras
 incidentes. Aplica skill ``pps-countermeasures`` (Toyota
 Practical Problem Solving — Countermeasures).

1. Propósito
============

Estandarizar la documentación post-incidente: qué pasó, por qué
pasó, cómo se resolvió, cómo prevenirlo.

2. Cuándo usar esta plantilla
=============================

- Tras un incidente operativo significativo.
- Cuando se identifica un patrón recurrente de fallo.
- Como output del proceso post-mortem.

3. Estructura obligatoria
=========================

3.1 Identificación
------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - troubleshooting-{descripción-corta}
 * - **Fecha incidente**
   - {YYYY-MM-DD}
 * - **Severidad**
   - 1 (crítica) / 2 (alta) / 3 (media) / 4 (baja)
 * - **Servicios afectados**
   - {lista}
 * - **Duración**
   - {horas/minutos de impacto}

3.2 Síntomas
------------

Descripción objetiva de qué se observó:

- Errores reportados por usuarios.
- Métricas anómalas.
- Logs / alertas.

3.3 Diagnóstico
---------------

Qué pasos se siguieron para identificar la causa:

.. list-table::
 :widths: 8 50 42
 :header-rows: 1

 * - Paso
   - Acción
   - Hallazgo
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

3.4 Causa raíz (5 Whys)
-----------------------

Aplicar técnica ``pps-clarify`` (5 Whys):

1. ¿Por qué pasó X? Porque Y.
2. ¿Por qué Y? Porque Z.
3. ... hasta llegar a la causa raíz operativa.

3.5 Resolución aplicada
-----------------------

Acciones tomadas para mitigar el incidente:

- Inmediatas (rollback, restart, etc.).
- Mediano plazo (parche, fix de configuración).

3.6 Countermeasures (skill: pps-countermeasures)
------------------------------------------------

Acciones para prevenir recurrencia:

.. list-table::
 :widths: 35 30 35
 :header-rows: 1

 * - Countermeasure
   - Owner
   - Deadline
 * - {ejemplo}
   - {ejemplo}
   - {ejemplo}

3.7 Verificación
----------------

Cómo confirmar que la countermeasure funciona:

- Métricas que monitorear.
- Tests que validar.
- Período de observación.

3.8 Lecciones aprendidas
------------------------

- Lo que se hizo bien.
- Lo que se hizo mal.
- Qué cambiar para futuros incidentes.

4. Ejemplo de aplicación
========================

Ver :doc:`/devops/runbooks/runbook-reprocesar-etl-fallido` como
ejemplo de runbook que aplicaría esta plantilla en un caso
real (reproceso de ETL fallido).

5. Convenciones de naming
=========================

- Archivo: ``troubleshooting-{tema}.rst`` o
  ``runbook-{operación}.rst`` para runbooks operacionales.
- Ubicación: ``source/devops/runbooks/`` (operacional) o
  ``source/quality/`` (post-mortems de calidad).

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill guía**
   - ``pps-countermeasures`` + ``pps-clarify`` (Toyota PPS)
 * - **Templates relacionados**
   - :doc:`tpl-release-plan-release-management`
 * - **Runbooks ejemplo**
   - :doc:`/devops/runbooks/runbook-verificar-servicios`
