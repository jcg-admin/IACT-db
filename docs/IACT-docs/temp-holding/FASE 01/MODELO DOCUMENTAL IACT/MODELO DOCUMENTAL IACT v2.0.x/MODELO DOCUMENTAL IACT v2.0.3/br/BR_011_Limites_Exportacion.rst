.. meta::
   :artefacto: BR_011
   :tipo: Business Rule
   :subtipo: Restriccion
   :modalidad: Deontica (Obligacion)
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-011:

==============================================================================
BR_011: Limites de Exportacion por Rol
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   El sistema DEBE aplicar limites de exportacion de datos segun el
   rol del usuario. Los limites incluyen: cantidad maxima de registros,
   formatos permitidos, y frecuencia de exportacion.

**Enunciado SBVR:**

   It is obligatory that data export limits are enforced based on user role.
   Export limits include maximum records, allowed formats, and frequency.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Restriccion (Constraint)
   * - **Modalidad**
     - Deontica - Obligacion (Obligation)
   * - **Estatica/Dinamica**
     - Dinamica (limites pueden ajustarse)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Proteccion de Datos
   * - **Documento**
     - POL_001 Seguridad de la Informacion
   * - **Seccion**
     - 7.3 Extraccion y Exportacion de Datos
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Prevencion de fuga de datos:** Limitar cantidad reduce riesgo
   de extraccion masiva.

2. **Control de acceso:** Diferentes roles tienen diferentes
   necesidades de exportacion.

3. **Performance:** Evitar exportaciones que sobrecarguen el sistema.

4. **Auditoria:** Facilitar rastreo de exportaciones significativas.

----

Matriz de Limites por Rol
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 25 20 20 20 15

   * - Rol
     - Max Registros
     - Formatos
     - Frecuencia
     - Periodo
   * - REPORTS_VIEWER (R004)
     - 1,000
     - CSV
     - 5/dia
     - 24h
   * - REPORTS_EXPORTER (R005)
     - 10,000
     - CSV, Excel
     - 20/dia
     - 24h
   * - REPORTS_ADVANCED (R006)
     - 50,000
     - CSV, Excel, PDF
     - 50/dia
     - 24h
   * - DATA_ANALYST (R010)
     - 100,000
     - CSV, Excel, PDF
     - Ilimitado
     - --
   * - SYSTEM_ADMIN (R016)
     - Sin limite
     - Todos
     - Ilimitado
     - --

----

Modelo de Datos
---------------

.. code-block:: sql

   -- Configuracion de limites por rol
   CREATE TABLE export_limits (
       id SERIAL PRIMARY KEY,
       role_id INTEGER NOT NULL REFERENCES roles(id),
       max_records INTEGER NOT NULL,
       allowed_formats TEXT[] NOT NULL,  -- {'CSV', 'EXCEL', 'PDF'}
       max_exports_per_period INTEGER,    -- NULL = ilimitado
       period_hours INTEGER DEFAULT 24,
       created_at TIMESTAMP DEFAULT NOW(),
       updated_at TIMESTAMP
   );

   -- Registro de exportaciones
   CREATE TABLE export_log (
       id SERIAL PRIMARY KEY,
       user_id INTEGER NOT NULL REFERENCES users(id),
       export_at TIMESTAMP DEFAULT NOW(),
       record_count INTEGER NOT NULL,
       format VARCHAR(20) NOT NULL,
       report_type VARCHAR(50),
       file_size_bytes BIGINT,
       duration_ms INTEGER
   );

----

Comportamiento del Sistema
--------------------------

Validacion Pre-Exportacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   1. Obtener roles del usuario
   2. Determinar limite mas permisivo (si tiene multiples roles)
   3. Validar:
      a. Formato solicitado esta en allowed_formats
      b. Registros solicitados <= max_records
      c. Exportaciones en periodo < max_exports_per_period
   4. Si alguna validacion falla: rechazar con mensaje
   5. Si pasa validaciones: proceder y registrar en export_log

Mensajes de Error
^^^^^^^^^^^^^^^^^

.. code-block:: text

   Error 403 - Limite de registros:
   "Su rol permite exportar maximo 1,000 registros.
    Solicitud contiene 5,000. Aplique filtros adicionales."

   Error 403 - Formato no permitido:
   "Su rol no permite exportar en formato PDF.
    Formatos disponibles: CSV"

   Error 429 - Frecuencia excedida:
   "Ha alcanzado el limite de 5 exportaciones diarias.
    Disponible nuevamente en: 14:30"

----

Casos de Uso Afectados
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Impacto de BR_011
   * - UC_022
     - Exportar CSV
     - Valida limite antes de exportar
   * - UC_023
     - Exportar Excel
     - Valida formato y limite
   * - UC_024
     - Exportar PDF
     - Valida formato y limite
   * - UC_063
     - Exportar Auditoria
     - Limites especiales para auditoria

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-022.01
     - Sistema DEBE validar limite de registros antes de exportar
   * - FR-022.02
     - Sistema DEBE validar formato permitido segun rol
   * - FR-022.03
     - Sistema DEBE validar frecuencia de exportacion
   * - FR-022.04
     - Sistema DEBE registrar cada exportacion en export_log
   * - FR-022.05
     - Sistema DEBE mostrar mensaje descriptivo si limite excedido
   * - FR-022.06
     - Sistema DEBE usar limite mas permisivo si usuario tiene multiples roles

----

Implementacion Tecnica
----------------------

.. code-block:: python

   # services/export.py

   class ExportService:

       def validate_export(self, user_id, record_count, format):
           """
           BR_011: Validar limites de exportacion
           """
           limits = self._get_user_limits(user_id)

           # Validar formato
           if format not in limits['allowed_formats']:
               raise ExportLimitError(
                   f"Formato {format} no permitido. "
                   f"Disponibles: {limits['allowed_formats']}"
               )

           # Validar cantidad
           if record_count > limits['max_records']:
               raise ExportLimitError(
                   f"Maximo {limits['max_records']} registros. "
                   f"Solicitados: {record_count}"
               )

           # Validar frecuencia
           if limits['max_exports_per_period']:
               recent = self._count_recent_exports(
                   user_id, limits['period_hours']
               )
               if recent >= limits['max_exports_per_period']:
                   raise ExportLimitError(
                       f"Limite de {limits['max_exports_per_period']} "
                       f"exportaciones alcanzado"
                   )

           return True

       def _get_user_limits(self, user_id):
           """Obtiene limites mas permisivos de los roles del usuario"""
           # Logica para obtener y combinar limites
           pass

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Usuario con R004 no puede exportar mas de 1,000 registros
2. Usuario con R004 no puede exportar en formato Excel
3. Usuario con R005 puede exportar hasta 10,000 en CSV o Excel
4. Exportacion exitosa se registra en export_log
5. Mensaje de error indica limite y rol

----

Restricciones Tecnicas Relacionadas
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_007
     - Limites Performance SLA
     - Define limites tecnicos

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`cnst-007` - CNST_007 Limites Performance SLA
- :ref:`br-006` - BR_006 RBAC Flat NIST
- MOD_Reports - Modulo de Reportes
- UC_022, UC_023, UC_024 - Casos de uso de exportacion

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

- Origen: POL_001 Seguridad de la Informacion
- Implementa: CNST_007 (parcialmente)
- Influye: UC_022, UC_023, UC_024, UC_063
- Deriva: FR-022.01 a FR-022.06
