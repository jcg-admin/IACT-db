.. meta::
   :artefacto: BR_001
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-001:

==============================================================================
BR_001: Inmutabilidad de Fuente Operacional
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_001
   * - **Nombre**
     - Inmutabilidad de Fuente Operacional
   * - **Tipo**
     - Restriccion
   * - **Categoria**
     - Operacional / Integridad de Datos
   * - **Criticidad**
     - Critica
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_001**

   El sistema IACT NO DEBE modificar, insertar ni eliminar datos en la base
   de datos fuente IVR. Toda interaccion con la base IVR se limita
   exclusivamente a operaciones de lectura (SELECT).

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - base_ivr: Base de datos operacional del sistema IVR del cliente
     - operacion_escritura: INSERT, UPDATE, DELETE, TRUNCATE, ALTER
     - operacion_lectura: SELECT
     - sistema_iact: Sistema IACT Dashboard Analytics

   REGLA:
     Es OBLIGATORIO que sistema_iact ejecute UNICAMENTE operaciones de lectura
     sobre base_ivr.
     
     Es PROHIBIDO que sistema_iact ejecute operaciones de escritura
     sobre base_ivr bajo cualquier circunstancia.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

La base de datos IVR es un sistema legacy critico del cliente que alimenta
multiples aplicaciones del call center. Cualquier modificacion no autorizada
podria:

- Corromper datos operacionales del call center
- Afectar el funcionamiento de sistemas dependientes
- Generar inconsistencias en reportes corporativos
- Violar acuerdos contractuales con el cliente
- Comprometer la auditoria y trazabilidad de datos originales

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Restriccion**
   * - 
     - [X] **Restriccion**: Limita acciones permitidas sobre datos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica - restriccion permanente del proyecto
- **Automatizable**: Si - implementada via Database Router de Django
- **Alcance**: Sistema completo - toda interaccion con base IVR

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_003_Base_Datos_Dual_Inmutable.rst
   * - **Seccion**
     - Arquitectura de Datos - Base IVR
   * - **Version**
     - 1.0.0
   * - **Fecha**
     - 2025-12-17
   * - **Tipo Fuente**
     - CNST (Restriccion Tecnica del Cliente)

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Cliente (propietario de base IVR)
- **Proceso de Cambio**: Requiere autorizacion escrita del cliente
- **Frecuencia de Revision**: Solo cuando cliente lo solicite

----

4. Aplicacion en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripcion de Aplicacion
   * - Django ORM
     - Router IVRReadOnlyRouter bloquea operaciones de escritura
   * - Proceso ETL
     - Solo extrae datos (SELECT), no modifica origen
   * - APIs REST
     - Endpoints de consulta IVR son solo lectura
   * - Management Commands
     - Comandos de sincronizacion no escriben en IVR

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los roles del sistema (ninguno puede escribir en IVR)
- **Sistemas Externos**: ETL, APIs de consulta

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones definidas. La inmutabilidad es absoluta e incondicional.

----

5. Trazabilidad
---------------

5.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Relacion
   * - CNST_003
     - Define arquitectura dual con IVR inmutable - origen directo de BR_001

5.2 Requisitos de Negocio Derivados (BReq)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BReq
     - Descripcion
   * - BReq_001
     - Visualizar Metricas (usa datos copiados, no originales)
   * - BReq_002
     - Exportar Datos (exporta copia local, no datos IVR directos)

5.3 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC_001
     - Precondicion: Datos provienen de copia sincronizada, no de IVR directo

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. IVRReadOnlyRouter esta configurado en settings de Django
2. Todos los modelos IVR usan ``managed = False``
3. No existen migraciones para tablas IVR
4. Tests automatizados verifican que escrituras a IVR fallan
5. Code review rechaza cualquier operacion de escritura a IVR

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado + Manual
- **Frecuencia**: Continua (cada commit) + Code Review
- **Responsable**: CI/CD Pipeline + Reviewer

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Rechazo inmediato en code review
- Falla de tests automatizados
- Posible corrupcion de datos del cliente
- Incidente critico de produccion
- Potencial incumplimiento contractual

----

7. Implementacion Tecnica
-------------------------

7.1 Database Router
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/config/database_routers.py
   
   class IVRReadOnlyRouter:
       """
       Router que garantiza que la base IVR sea SOLO LECTURA.
       Implementa BR_001: Inmutabilidad de Fuente Operacional.
       """
       
       IVR_APPS = ['ivr']  # Apps que usan base IVR
       
       def db_for_read(self, model, **hints):
           if model._meta.app_label in self.IVR_APPS:
               return 'ivr'
           return None
       
       def db_for_write(self, model, **hints):
           # NUNCA permitir escritura en IVR
           if model._meta.app_label in self.IVR_APPS:
               raise PermissionError(
                   "BR_001: Escritura prohibida en base IVR. "
                   "La base IVR es inmutable."
               )
           return None
       
       def allow_migrate(self, db, app_label, model_name=None, **hints):
           # NUNCA migrar en base IVR
           if db == 'ivr':
               return False
           if app_label in self.IVR_APPS:
               return False
           return None

7.2 Configuracion Django
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/config/settings/base.py
   
   DATABASE_ROUTERS = [
       'config.database_routers.IVRReadOnlyRouter',
       'config.database_routers.AnalyticsRouter',
   ]

----

8. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Version inicial derivada de CNST_003

----

Referencias
-----------

- CNST_003: Base de Datos Dual con Inmutabilidad IVR
- FND_02: Reglas de Negocio
- FND_05: Jerarquia de 4 Niveles

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
