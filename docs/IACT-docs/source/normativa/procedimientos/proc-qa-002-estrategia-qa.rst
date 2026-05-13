.. meta::
 :artefacto: PROC_QA_002
 :tipo: Procedimiento
 :dominio: normativa
 :subdominio: procedimientos
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-28
 :autor: Equipo IACT
 :clasificacion: Interno

Estrategia de QA
================

Hoja de ruta para garantizar calidad del software mediante TDD, métricas
de cobertura y coordinación transversal con equipos de producto,
arquitectura y DevOps.

Página padre
------------

- ```readme.rst`` <readme>`__

Línea base de QA
----------------

- Consolidar suite ``pytest`` con cobertura mínima de 80 %.
- Registrar TC-USR-010 y TC-ADM-005 en ``tests/`` por aplicación
  Django.
- Documentar criterios de salida para despliegues APScheduler y
  reportes.
- Mantener bitácora de ejecuciones en ``registros/``.

Métricas esperadas
------------------

.. list-table::
   :header-rows: 1

   * - Métrica
     - Objetivo
     - Fuente
   * - Cobertura unitaria
     - ≥ 80 %
     - Reportes de ``pytest --cov``.
   * - Tiempo medio para corregir fallos críticos
     - ≤ 2 días
     - Bitácora en ``registros/``.
   * - Actividades de control documental completadas
     - 100 % por release
     - ``actividades_garan tia_documental.rst``

Actividades coordinadas
-----------------------

- Seguir las tareas definidas en
  ```actividades_garantia_documental.rst`` <actividades_garantia_documental.rst>`__
  para revisar plantillas y trazabilidad.
- Levantar hallazgos en ``qa/registros/`` cuando se detecten
  incumplimientos de documentación.
- Alinear con producto y arquitectura una revisión semanal dedicada a
  documentación.

Acciones prioritarias
---------------------

- [ ] Generar reporte inicial de cobertura y publicarlo en
  ``registros/``.
- [ ] Completar registro de criterios de salida y enlazarlo con
  Planificación y DevOps.
- [ ] Configurar automatización de tests en la canalización CI.
