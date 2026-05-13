.. meta::
 :artefacto: DB_001
 :tipo: Modelo de Datos
 :dominio: databases
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Critico

====================
Modelo de Datos Dual
====================

El sistema IACT opera sobre dos bases de datos separadas con
proposito distinto.

1. BD MySQL (IVR Operacional)
=============================

- **Owner:** cliente.
- **Acceso desde IACT:** SOLO LECTURA (CNST_007).
- **Contenido:** llamadas, agentes, colas, eventos del IVR.
- **No se modifica:** IACT no escribe NADA en esta BD bajo ninguna
  circunstancia (3 niveles de enforcement: GRANT SELECT, Django
  ``managed = False``, middleware de proteccion).

2. BD PostgreSQL (IACT Analytics)
==================================

- **Owner:** sistema IACT.
- **Acceso:** read/write para IACT.
- **Contenido:** tablas analiticas derivadas del ETL + tablas
  operacionales del sistema (usuarios, sesiones, RBAC, alertas,
  audit log, configuraciones).

3. Sincronizacion
=================

Solo via ETL programado en ventana de 6 a 12 horas (CNST_008). NO
existe sincronizacion en tiempo real.

Ver :doc:`etl-pipeline`.

4. Routers Django
=================

.. code-block:: python

 # api/db_routers.py
 class IVRRouter:
 """Enruta lecturas de modelos IVR a BD MySQL readonly."""
 def db_for_read(self, model, **hints):
 if model._meta.app_label == 'ivr':
 return 'ivr'
 return None

 def db_for_write(self, model, **hints):
 if model._meta.app_label == 'ivr':
 raise ProtectedError("CNST_007: BD IVR is read-only")
 return None
