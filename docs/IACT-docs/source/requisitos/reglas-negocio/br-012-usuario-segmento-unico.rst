.. meta::
 :artefacto: BR_012
 :tipo: Regla de Negocio
 :dominio: requisitos
 :subdominio: reglas_negocio
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-07
 :ultimo_cambio: 2026-04-30
 :autor: Equipo IACT
 :clasificacion: Interno

.. _br-012:

==============================
BR_012: Usuario Segmento Único
==============================


Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BR_012
 * - **Nombre**
   - Usuario Segmento Único
 * - **Tipo**
   - Hecho
 * - **Categoría**
   - Identidad / Control de Acceso a Datos
 * - **Criticidad**
   - Alta
 * - **Estado**
   - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_012**

 Cada usuario operativo del sistema IACT DEBE estar asociado a
 **exactamente un segmento de datos** (DataSegment) que delimita
 el alcance de los datos que puede consultar (centro, campaña,
 servicio, o región). El segmento es asignado por un administrador
 con la función ``manage_segments``. Un usuario sin segmento NO
 puede consultar reportes operativos.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

 VOCABULARIO:
 - usuario: Entidad que representa una identidad operativa
 - segmento: Subconjunto declarado de datos del IVR
   (centro / campaña / servicio / región)
 - DataSegment: Tabla del modelo de datos que define segmentos
 - asignacion_segmento: Vínculo usuario ↔ segmento

 HECHOS:
 Cada usuario operativo TIENE exactamente un segmento asignado.

 Cada segmento PUEDE estar asignado a 0..N usuarios.

 La relación usuario-segmento ES de tipo N:1 (varios usuarios
 por segmento, un único segmento por usuario).

 REGLA:
 Es OBLIGATORIO que todo usuario con rol operativo tenga
 segmento asignado antes de poder ejecutar UC_RPT_*.

 Es PROHIBIDO ejecutar consultas operativas sin segmento
 vigente.

1.3 Justificación
^^^^^^^^^^^^^^^^^

La unicidad de segmento por usuario garantiza:

- **Aislamiento de datos**: cada usuario sólo accede a su scope.
- **Auditoría clara**: cada consulta queda atada a un segmento.
- **Performance**: el filtrado por segmento es indexable.
- **Compliance**: SoD entre operadores de distintas campañas.
- **Simplicidad operativa**: una asignación por usuario evita
  ambigüedad de scope.

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Tipo**
   - **Hecho**
 * -
   - [X] **Hecho**: Define cardinalidad N:1 entre usuarios y
     segmentos.

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Dinámica — el segmento puede
  reasignarse vía UC_ACC_07.
- **Automatizable**: Sí — FK con NOT NULL en operativos.
- **Alcance**: Tabla de usuarios + tabla DataSegment.

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Documento**
   - Modelo de Acceso a Datos IACT
 * - **Sección**
   - Segmentación operativa
 * - **Versión**
   - 1.0.0
 * - **Tipo Fuente**
   - Requisito de Seguridad + Compliance

3.2 Autoridad de Modificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Arquitecto de Seguridad
- **Proceso de Cambio**: Reasignación por administrador con
  función ``manage_segments``.
- **Frecuencia de Revisión**: Trimestral.

----

4. Aplicación en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Descripción de Aplicación
 * - UC_ACC_06 Gestionar Segmentos
   - CRUD del catálogo DataSegment
 * - UC_ACC_07 Asignar Segmento
   - INSERT / UPDATE de la asignación usuario → segmento
 * - UC_RPT_01..14
   - Filtran consultas por segmento del usuario invocador
 * - SEC_RULES (middleware)
   - Aplica el filtro de segmento en todas las queries de reporte
 * - Modelo User
   - FK ``segment_id`` NOT NULL para usuarios operativos

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Operadores / Supervisores**: ven sólo datos de su segmento.
- **Administradores**: asignan/reasignan segmentos.
- **Auditores / Sysadmins**: pueden quedar sin segmento si su
  función no consume reportes operativos.

4.3 Excepciones
^^^^^^^^^^^^^^^

- Usuarios con función ``view_audit_log`` o equivalentes de
  sistema general pueden NO tener segmento asignado, ya que
  acceden a auditoría agregada (no a datos operativos).

----

5. Trazabilidad
---------------

5.1 Modelo de Datos
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

 ┌─────────────────────────────────────┐
 │ Usuario                             │
 ├─────────────────────────────────────┤
 │ id          : INTEGER (PK)          │
 │ username    : VARCHAR(150) UNIQUE   │
 │ segment_id  : INTEGER FK → segments │<── BR_012
 │ estado      : ENUM(ACTIVO,INACTIVO) │
 │ ...                                 │
 └─────────────────────────────────────┘

 ┌─────────────────────────────────────┐
 │ DataSegment                         │
 ├─────────────────────────────────────┤
 │ id    : INTEGER (PK)                │
 │ tipo  : ENUM(centro, campana, ...)  │
 │ valor : VARCHAR                     │
 │ ...                                 │
 └─────────────────────────────────────┘

 INDEX: idx_users_segment (segment_id)

5.2 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - UC
   - Donde Aplica
 * - UC_USR_01 Crear Usuario
   - Asigna segmento default según rol esperado
 * - UC_ACC_06 Gestionar Segmentos
   - CRUD del catálogo
 * - UC_ACC_07 Asignar Segmento
   - Mutación N:1 controlada
 * - UC_RPT_01..14
   - Filtro automático por segmento del usuario

5.3 Restricciones Vinculadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Filtrado automático por segmento del usuario en reportes
  (CNST aplicable al modelo de acceso a datos operativos).

----

6. Verificación
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. Columna ``segment_id`` existe con FK + NOT NULL en operativos.
2. Cada UC_RPT incluye filtro implícito por segmento.
3. Intento de consulta sin segmento devuelve error claro.
4. UI muestra el segmento activo del usuario en su perfil.
5. Reasignación de segmento queda registrada en auditoría.

6.2 Método de Verificación
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado (FK + middleware SEC_RULES).
- **Frecuencia**: Cada query de reporte.
- **Responsable**: Motor de BD + capa middleware.

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Acceso indebido a datos fuera del scope autorizado.
- Pérdida de aislamiento entre campañas/centros.
- Riesgo de incumplimiento de compliance interno.

----

7. Historial de Cambios
-----------------------

.. list-table::
 :widths: 15 15 20 50
 :header-rows: 1

 * - Versión
   - Fecha
   - Autor
   - Descripción del Cambio
 * - 1.0.0
   - 2026-01-07
   - Equipo IACT
   - Versión inicial — segmentación operativa.

----

Referencias
-----------

- UC_ACC_06: Gestionar Segmentos
- UC_ACC_07: Asignar Segmento
- :doc:`/gestion/evidencia/rbac-historia/discrepancia-rbac-correccion-ene-2026`

----

*Documento versión 1.0.0 — Proyecto IACT*
