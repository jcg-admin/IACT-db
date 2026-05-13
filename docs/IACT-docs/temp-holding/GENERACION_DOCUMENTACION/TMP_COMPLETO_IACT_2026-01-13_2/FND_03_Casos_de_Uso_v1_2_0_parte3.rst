
----

6. Derivacion de UC
-------------------

6.1 Cadena de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq (Objetivo de Negocio)
       |
       | genera
       v
   UC (Caso de Uso) <---- BR tipo Trigger tambien genera
       |
       | deriva
       v
   FR (Requisito Funcional) <---- Cada paso "Sistema" deriva FR

6.2 Ratio de Derivacion
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Tipico: 1 UC : 8 FR

   Justificacion:
   - Flujo normal: ~5 pasos "Sistema" = 5 FR
   - Flujos alternos: ~2 pasos adicionales = 2 FR
   - Excepciones: ~1 paso de manejo = 1 FR
   - Total tipico: 8 FR por UC

   IACT esperado:
   - 49 UC × 8 FR/UC = ~400 FR

----

7. Trazabilidad de UC
---------------------

7.1 Hacia Arriba (Origen)
^^^^^^^^^^^^^^^^^^^^^^^^^

Cada UC debe documentar:

- **BReq origen:** Objetivo de negocio que satisface
- **BR relacionadas:** Reglas que influyen en el comportamiento

7.2 Hacia Abajo (Derivados)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cada UC genera:

- **FR derivados:** Requisitos funcionales atomicos
- **Tests:** Casos de prueba end-to-end

7.3 Seccion de Trazabilidad Obligatoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Todo UC DEBE incluir al final:

.. code-block:: rst

   ----

   Trazabilidad
   ------------

   Origen
   ^^^^^^
   - Business Requirement: BReq-NNN
   - Business Rules: BR_NNN, BR_NNN

   Derivados
   ^^^^^^^^^
   - FR-NNN.1: [Descripcion]
   - FR-NNN.2: [Descripcion]
   - ...

   Modulo
   ^^^^^^
   - MOD_Xxx

----

8. Lista de UC Identificados en IACT (v1.2.0)
---------------------------------------------

.. important::

   **ACTUALIZACION v1.2.0:**
   
   Lista actualizada con 49 UC (anteriormente 38). Se agregaron modulos
   Auth, Pipeline, Audit y Logs que no estaban en version anterior.

8.1 Autenticacion - MOD_Auth (5 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-001: Inicio de Sesion
   UC-002: Cierre de Sesion
   UC-003: Recuperar Password
   UC-004: Cambiar Password
   UC-005: Gestionar Sesiones

   Actor Primario: Cualquier usuario autenticado
   BR Relacionadas: BR_005 (Sesion Unica), BR_015 (Bloqueo Intentos)

8.2 Gestion de Usuarios - MOD_Users (4 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-006: Crear Usuario
   UC-007: Modificar Usuario
   UC-008: Baja Usuario (logica)
   UC-009: Listar Usuarios

   Actor Primario: AGR-001 (administrador_usuarios)
   BR Relacionadas: BR_009 (Bajas Logicas), BR_013 (Username Unico)

8.3 Control de Acceso - MOD_Access (9 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-010: Asignar Funciones a Usuario
   UC-011: Gestionar Permisos por Agrupador
   UC-041: Asignar Segmento de Datos
   UC-042: Asignar Permiso Directo
   UC-043: Configurar SoD
   UC-044: Consultar Permisos Efectivos
   UC-045: Gestionar Catalogo de Agrupadores
   UC-046: Gestionar Catalogo de Funciones
   UC-047: Auditar Cambios de Permisos

   Actor Primario: AGR-008 (admin_seguridad)
   BR Relacionadas: BR_006 (RBAC Flat), BR_007 (SoD), BR_012 (Usuario-Segmento)

8.4 Pipeline ETL - MOD_Pipeline (4 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-050: Supervisar Estado ETL
   UC-051: Consultar Errores ETL
   UC-052: Consultar Disponibilidad de Datos
   UC-053: Solicitar Reintento ETL

   Actor Primario: AGR-010 (operador_etl), AGR-009 (admin_sistema)
   BR Relacionadas: BR_001 (Fuente Inmutable), BR_002 (ETL Nocturno)

8.5 Reportes - MOD_Reports (14 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REPORTES BASE:
   UC-017: Consultar Reporte Trimestral
   UC-018: Consultar Problemas de Menu
   UC-019: Consultar Transferencias por Centro

   FILTROS:
   UC-020: Filtrar Reportes por Fecha
   UC-021: Filtrar Reportes por Centro

   EXPORTACION:
   UC-022: Exportar CSV
   UC-023: Exportar Excel
   UC-024: Exportar PDF

   DASHBOARDS:
   UC-025: Ver Dashboard Principal
   UC-026: Ver Tendencias Temporales
   UC-027: Ver Graficos por Hora
   UC-028: Ver Graficos por Dia
   UC-029: Ver Distribucion por Centro
   UC-030: Personalizar Dashboard

   Actor Primario: AGR-003 (analista_reportes), AGR-004 (visor_dashboard)
   BR Relacionadas: BR_011 (Limites Exportacion), BR_020 (Rango Temporal)

8.6 Alertas - MOD_Alerts (5 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-036: Crear Alerta por Umbral
   UC-037: Recibir Notificacion de Alerta
   UC-038: Pausar/Reactivar Alerta
   UC-039: Consultar Historial de Alertas
   UC-040: Gestionar Destinatarios

   Actor Primario: AGR-005 (gestor_alertas)
   BR Relacionadas: BR_004 (Comunicaciones Internas), BR_014 (Alerta Umbral)

8.7 Auditoria - MOD_Audit (4 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-060: Registrar Evento de Auditoria
   UC-061: Consultar Log de Auditoria
   UC-062: Generar Reporte de Auditoria
   UC-063: Exportar Auditoria

   Actor Primario: AGR-007 (auditor)
   BR Relacionadas: BR_010 (Auditoria Inmutable)

8.8 Bitacoras - MOD_Logs (3 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-070: Consultar Logs del Sistema
   UC-071: Filtrar Logs por Criterios
   UC-072: Exportar Logs

   Actor Primario: AGR-009 (admin_sistema)
   BR Relacionadas: (ninguna directa)

8.9 Resumen de UC por Modulo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 15 55

   * - Modulo
     - Cantidad
     - Rango UC
   * - MOD_Auth
     - 5
     - UC-001 a UC-005
   * - MOD_Users
     - 4
     - UC-006 a UC-009
   * - MOD_Access
     - 9
     - UC-010, UC-011, UC-041 a UC-047
   * - MOD_Pipeline
     - 4
     - UC-050 a UC-053
   * - MOD_Reports
     - 14
     - UC-017 a UC-030
   * - MOD_Alerts
     - 5
     - UC-036 a UC-040
   * - MOD_Audit
     - 4
     - UC-060 a UC-063
   * - MOD_Logs
     - 3
     - UC-070 a UC-072
   * - **TOTAL**
     - **49**
     - --
