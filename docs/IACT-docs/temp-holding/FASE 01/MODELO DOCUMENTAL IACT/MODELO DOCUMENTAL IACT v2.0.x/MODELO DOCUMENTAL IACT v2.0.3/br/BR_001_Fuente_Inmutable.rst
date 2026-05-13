.. meta::
   :artefacto: BR_001
   :tipo: Business Rule
   :subtipo: Restriccion
   :modalidad: Deontica (Prohibicion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-001:

==============================================================================
BR_001: Fuente Operacional Inmutable
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   La base de datos MySQL operacional del sistema IVR es de SOLO LECTURA
   para el sistema IACT. No se permite ninguna operacion de escritura
   (INSERT, UPDATE, DELETE) desde IACT hacia la base de datos MySQL.

**Enunciado SBVR:**

   It is prohibited that IACT system modifies data in IVR MySQL database.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Restriccion (Constraint)
   * - **Modalidad**
     - Deontica - Prohibicion (Prohibition)
   * - **Estatica/Dinamica**
     - Estatica (arquitectura fundamental, no cambia)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de TI - Separacion de Ambientes
   * - **Documento**
     - Arquitectura de Referencia IACT v1.0
   * - **Seccion**
     - 3.2 Integracion con Sistemas Externos
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Proteccion de datos operacionales:** El sistema IVR es critico para
   la operacion del negocio. Cualquier modificacion accidental podria
   afectar el servicio telefonica a clientes.

2. **Separacion de responsabilidades:** IACT es un sistema de analytics,
   no un sistema transaccional. Su proposito es consultar y analizar,
   no modificar.

3. **Auditoria y compliance:** Mantener la fuente inmutable permite
   garantizar que los datos analizados son los mismos que los
   operacionales, sin alteraciones.

4. **Simplicidad arquitectonica:** Al eliminar la posibilidad de
   escritura, se reduce la complejidad de la integracion y los
   posibles modos de falla.

----

Impacto en el Sistema
---------------------

Arquitectura
^^^^^^^^^^^^

.. code-block:: text

   +-------------------+          +-------------------+
   |   MySQL (IVR)     |   ETL    |  PostgreSQL (IACT)|
   |   Operacional     | -------> |    Analytics      |
   +-------------------+  (READ)  +-------------------+
           |                              |
           | Solo SELECT                  | CRUD completo
           |                              |
           v                              v
   +-------------------+          +-------------------+
   |   Usuario BD      |          |   IACT Backend    |
   |   iact_readonly   |          |   Django + DRF    |
   +-------------------+          +-------------------+

Implementacion Tecnica
^^^^^^^^^^^^^^^^^^^^^^

1. **Usuario de base de datos:**

   .. code-block:: sql

      -- Usuario MySQL con permisos minimos
      CREATE USER 'iact_readonly'@'%' IDENTIFIED BY '***';
      GRANT SELECT ON ivr_operacional.* TO 'iact_readonly'@'%';
      -- NO otorgar INSERT, UPDATE, DELETE, ALTER, DROP

2. **Configuracion Django:**

   .. code-block:: python

      # settings.py
      DATABASES = {
          'ivr_source': {
              'ENGINE': 'django.db.backends.mysql',
              'NAME': 'ivr_operacional',
              'USER': 'iact_readonly',
              'OPTIONS': {
                  'read_only': True,  # Flag adicional
              }
          }
      }

3. **Router de base de datos:**

   .. code-block:: python

      class IVRReadOnlyRouter:
          def db_for_write(self, model, **hints):
              if model._meta.app_label == 'ivr_source':
                  raise PermissionError("Write to IVR source prohibited")
              return 'default'

----

Casos de Uso Afectados
----------------------

Esta BR NO genera Casos de Uso directamente (es tipo Restriccion, no
Desencadenador). Sin embargo, INFLUYE en los siguientes UC:

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - UC
     - Nombre
     - Como Influye
   * - UC_050
     - Supervisar ETL
     - ETL solo lee de MySQL
   * - UC_051
     - Consultar Errores ETL
     - Errores no modifican fuente
   * - UC_017-029
     - Reportes
     - Datos son copia, no original

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-ETL.01
     - Sistema DEBE conectar a MySQL con usuario de solo lectura
   * - FR-ETL.02
     - Sistema DEBE usar exclusivamente sentencias SELECT en MySQL
   * - FR-ETL.03
     - Sistema DEBE rechazar cualquier intento de escritura a MySQL
   * - FR-CFG.01
     - Sistema DEBE configurar router que bloquee escrituras a IVR

----

Restricciones Tecnicas Relacionadas
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_003
     - Base de Datos Dual Inmutable
     - Implementa esta BR
   * - CNST_004
     - Actualizacion Datos ETL
     - Complementa (define frecuencia)

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Usuario MySQL `iact_readonly` solo tiene permiso SELECT
2. Configuracion Django tiene flag `read_only: True`
3. Router rechaza operaciones de escritura a modelos IVR
4. Tests de integracion verifican que INSERT/UPDATE/DELETE fallan

Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^

- Inspeccion de permisos MySQL
- Revision de configuracion Django
- Tests automatizados que intentan escribir y verifican excepcion

----

Ejemplos
--------

Ejemplo Correcto
^^^^^^^^^^^^^^^^

.. code-block:: python

   # Consulta permitida
   from ivr.models import LlamadaIVR

   llamadas = LlamadaIVR.objects.using('ivr_source').filter(
       fecha__gte='2025-01-01'
   )  # OK - Solo SELECT

Ejemplo Incorrecto (Bloqueado)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # Operacion prohibida - lanzara excepcion
   from ivr.models import LlamadaIVR

   llamada = LlamadaIVR.objects.using('ivr_source').get(id=1)
   llamada.estado = 'PROCESADA'
   llamada.save()  # ERROR: PermissionError

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`cnst-003` - CNST_003 Base de Datos Dual Inmutable
- :ref:`cnst-004` - CNST_004 Actualizacion Datos ETL
- :ref:`br-002` - BR_002 ETL Batch Nocturno
- :ref:`fnd-02` - Fundamentos de Reglas de Negocio

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Version
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - 2026-01-03
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:**

- Origen: Politica de TI, Arquitectura de Referencia
- Implementa: CNST_003
- Influye: UC_050, UC_051, UC_017-029
- Deriva: FR-ETL.01, FR-ETL.02, FR-ETL.03, FR-CFG.01
