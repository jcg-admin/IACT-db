.. meta::
   :artefacto: BR_012
   :tipo: Business Rule
   :subtipo: Hecho
   :modalidad: Aletica
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-012:

==============================================================================
BR_012: Usuario Pertenece a Un Segmento
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   Cada usuario pertenece a exactamente un segmento de datos.
   El segmento determina que datos puede visualizar el usuario
   (filtro de datos por centro/segmento).

**Enunciado SBVR:**

   Each user belongs to exactly one data segment.
   A user's segment determines which data the user can access.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Hecho (Fact)
   * - **Modalidad**
     - Aletica (verdad estructural)
   * - **Estatica/Dinamica**
     - Estatica (estructura del modelo)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Modelo de Datos IACT
   * - **Documento**
     - MDL_001 Modelo Conceptual
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Segregacion de datos:** Usuarios de un centro solo ven datos
   de su centro.

2. **Simplicidad:** Relacion 1:1 es mas facil de gestionar que N:N.

3. **Performance:** Filtro por segmento optimiza queries.

4. **Seguridad:** Limita exposicion de datos por defecto.

----

Segmentos Definidos
-------------------

.. list-table::
   :header-rows: 1
   :widths: 15 35 50

   * - ID
     - Nombre
     - Descripcion
   * - S01
     - Centro Norte
     - Datos del call center region norte
   * - S02
     - Centro Sur
     - Datos del call center region sur
   * - S03
     - Centro Este
     - Datos del call center region este
   * - S04
     - Centro Oeste
     - Datos del call center region oeste
   * - S05
     - Consolidado
     - Acceso a todos los centros

----

Modelo de Datos
---------------

.. code-block:: sql

   CREATE TABLE segments (
       id SERIAL PRIMARY KEY,
       code VARCHAR(10) UNIQUE NOT NULL,
       name VARCHAR(100) NOT NULL,
       description TEXT,
       is_consolidated BOOLEAN DEFAULT FALSE
   );

   CREATE TABLE users (
       id SERIAL PRIMARY KEY,
       -- ... otros campos ...
       segment_id INTEGER NOT NULL REFERENCES segments(id)
       -- NOT NULL garantiza exactamente 1 segmento
   );

----

Comportamiento
--------------

Filtro Automatico de Datos
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # middleware/segment_filter.py

   class SegmentFilterMiddleware:
       """
       BR_012: Filtra datos automaticamente por segmento del usuario
       """
       def __call__(self, request):
           if request.user.is_authenticated:
               segment = request.user.segment

               if segment.is_consolidated:
                   # Acceso a todos los datos
                   request.segment_filter = None
               else:
                   # Filtro por segmento
                   request.segment_filter = segment.id

           return self.get_response(request)

Aplicacion en Queries
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # views/reports.py

   class ReportView(APIView):

       def get_queryset(self):
           qs = CallData.objects.all()

           # BR_012: Aplicar filtro de segmento
           if self.request.segment_filter:
               qs = qs.filter(segment_id=self.request.segment_filter)

           return qs

----

Casos de Uso Afectados
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Impacto de BR_012
   * - UC_006
     - Crear Usuario
     - Requiere asignar segmento
   * - UC_041
     - Asignar Segmento
     - Cambia segmento de usuario
   * - UC_017-029
     - Reportes
     - Datos filtrados por segmento

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-006.05
     - Sistema DEBE requerir segmento al crear usuario
   * - FR-041.01
     - Sistema DEBE permitir cambiar segmento de usuario
   * - FR-RPT.01
     - Sistema DEBE filtrar datos por segmento del usuario
   * - FR-RPT.02
     - Sistema DEBE mostrar todos los datos si segmento es Consolidado

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. No se puede crear usuario sin segmento (NOT NULL)
2. Usuario solo ve datos de su segmento en reportes
3. Usuario con segmento Consolidado ve todos los datos
4. Admin puede cambiar segmento de usuario

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-006` - BR_006 RBAC Flat NIST
- :ref:`mtm-03` - MTM_03 Metamodelo RBAC
- UC_006 - Crear Usuario
- UC_041 - Asignar Segmento

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

- Origen: Modelo de Datos IACT
- Tipo: Hecho (define estructura, no genera UC)
- Influye: UC_006, UC_041, UC_017-029
- Deriva: FR-006.05, FR-041.01, FR-RPT.01, FR-RPT.02
