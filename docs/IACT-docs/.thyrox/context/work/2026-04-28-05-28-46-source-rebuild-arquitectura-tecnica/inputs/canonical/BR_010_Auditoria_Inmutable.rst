.. meta::
   :artefacto: BR_010
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

.. _br-010:

==============================================================================
BR_010: Auditoria Inmutable
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   Los registros de auditoria NO PUEDEN ser modificados ni eliminados
   una vez creados. Toda accion relevante del sistema DEBE quedar
   registrada en el log de auditoria de forma inmutable.

**Enunciado SBVR:**

   It is prohibited that audit records are modified or deleted.
   It is obligatory that all relevant system actions are recorded
   in the immutable audit log.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Restriccion (Constraint)
   * - **Modalidad**
     - Deontica - Prohibicion + Obligacion
   * - **Estatica/Dinamica**
     - Estatica (requerimiento de compliance)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Seguridad, Compliance
   * - **Documento**
     - POL_001 Seguridad de la Informacion
   * - **Seccion**
     - 9.1 Logging y Auditoria
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Forense:** Permite investigar incidentes de seguridad con
   datos confiables.

2. **No repudio:** Usuario no puede negar acciones registradas.

3. **Compliance:** Requerimiento en ISO 27001, SOX, GDPR.

4. **Integridad:** Garantiza que evidencia no ha sido alterada.

----

Implementacion Tecnica
----------------------

Tabla de Auditoria
^^^^^^^^^^^^^^^^^^

.. code-block:: sql

   CREATE TABLE audit_log (
       id BIGSERIAL PRIMARY KEY,
       timestamp TIMESTAMP DEFAULT NOW() NOT NULL,
       user_id INTEGER REFERENCES users(id),
       session_id UUID REFERENCES sessions(id),
       action VARCHAR(100) NOT NULL,
       resource_type VARCHAR(50),
       resource_id VARCHAR(100),
       ip_address INET,
       user_agent TEXT,
       request_method VARCHAR(10),
       request_path TEXT,
       request_body_hash VARCHAR(64),  -- SHA256, no el body completo
       response_status INTEGER,
       details JSONB,
       checksum VARCHAR(64) NOT NULL  -- Integridad del registro
   );

   -- Prohibir UPDATE y DELETE
   REVOKE UPDATE, DELETE ON audit_log FROM iact_app;

   -- Solo INSERT permitido
   GRANT INSERT, SELECT ON audit_log TO iact_app;

Trigger de Proteccion
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: sql

   -- Trigger que impide modificacion
   CREATE OR REPLACE FUNCTION prevent_audit_modification()
   RETURNS TRIGGER AS $$
   BEGIN
       RAISE EXCEPTION 'BR_010: Audit records are immutable';
   END;
   $$ LANGUAGE plpgsql;

   CREATE TRIGGER audit_immutable
   BEFORE UPDATE OR DELETE ON audit_log
   FOR EACH ROW EXECUTE FUNCTION prevent_audit_modification();

Checksum de Integridad
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # services/audit.py
   import hashlib
   import json

   class AuditService:

       def log(self, user_id, action, resource_type=None, resource_id=None,
               details=None, request=None):
           """
           BR_010: Registrar accion en auditoria inmutable
           """
           record = {
               'timestamp': timezone.now().isoformat(),
               'user_id': user_id,
               'action': action,
               'resource_type': resource_type,
               'resource_id': str(resource_id) if resource_id else None,
               'details': details
           }

           # Calcular checksum para integridad
           checksum = self._calculate_checksum(record)

           AuditLog.objects.create(
               user_id=user_id,
               action=action,
               resource_type=resource_type,
               resource_id=str(resource_id) if resource_id else None,
               ip_address=request.META.get('REMOTE_ADDR') if request else None,
               details=details,
               checksum=checksum
           )

       def _calculate_checksum(self, record):
           """SHA256 del contenido para detectar alteraciones"""
           content = json.dumps(record, sort_keys=True)
           return hashlib.sha256(content.encode()).hexdigest()

----

Acciones a Auditar
------------------

.. list-table::
   :header-rows: 1
   :widths: 30 40 30

   * - Categoria
     - Acciones
     - Prioridad
   * - Autenticacion
     - LOGIN, LOGOUT, LOGIN_FAILED, PASSWORD_CHANGE
     - Critica
   * - Usuarios
     - USER_CREATE, USER_UPDATE, USER_DELETE
     - Alta
   * - Roles
     - ROLE_ASSIGN, ROLE_REVOKE
     - Alta
   * - Permisos
     - PERMISSION_GRANT, PERMISSION_REVOKE
     - Alta
   * - Datos
     - REPORT_VIEW, REPORT_EXPORT, DATA_ACCESS
     - Media
   * - Configuracion
     - CONFIG_CHANGE, ALERT_CONFIG
     - Alta
   * - Sistema
     - ETL_START, ETL_COMPLETE, ETL_FAIL
     - Media

----

Casos de Uso Relacionados
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Relacion con BR_010
   * - UC_060
     - Registrar Evento
     - Implementa el registro
   * - UC_061
     - Consultar Auditoria
     - Solo lectura permitida
   * - UC_062
     - Generar Reporte Auditoria
     - Exporta datos inmutables
   * - UC_063
     - Exportar Auditoria
     - Para auditores externos

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-060.01
     - Sistema DEBE registrar toda accion de autenticacion
   * - FR-060.02
     - Sistema DEBE registrar toda modificacion de usuarios
   * - FR-060.03
     - Sistema DEBE registrar toda asignacion/revocacion de roles
   * - FR-060.04
     - Sistema DEBE registrar accesos a datos sensibles
   * - FR-060.05
     - Sistema DEBE calcular checksum para cada registro
   * - FR-AUD.01
     - Sistema NO DEBE permitir UPDATE en tabla audit_log
   * - FR-AUD.02
     - Sistema NO DEBE permitir DELETE en tabla audit_log
   * - FR-061.01
     - Sistema DEBE permitir consulta de auditoria a rol R017

----

Retencion
---------

.. list-table::
   :widths: 30 70

   * - **Periodo minimo**
     - 2 anios (requerimiento compliance)
   * - **Archivado**
     - Despues de 2 anios, mover a almacenamiento frio
   * - **Eliminacion**
     - Solo por proceso formal con aprobacion legal

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Usuario de aplicacion NO tiene permisos UPDATE/DELETE en audit_log
2. Trigger rechaza intentos de modificacion
3. Toda accion critica genera registro de auditoria
4. Checksum permite verificar integridad de registros

Casos de Prueba
^^^^^^^^^^^^^^^

.. code-block:: text

   TEST_001: Inmutabilidad - UPDATE rechazado
   - Intentar UPDATE en audit_log
   - Resultado: Excepcion "Audit records are immutable"

   TEST_002: Inmutabilidad - DELETE rechazado
   - Intentar DELETE en audit_log
   - Resultado: Excepcion "Audit records are immutable"

   TEST_003: Registro de login
   - Usuario hace login
   - Resultado: Registro en audit_log con action='LOGIN'

----

Restricciones Tecnicas Relacionadas
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_009
     - Logging Auditoria Inmutable
     - Implementa esta BR

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`cnst-009` - CNST_009 Logging Auditoria Inmutable
- :ref:`br-009` - BR_009 Bajas Logicas
- MOD_Audit - Modulo de Auditoria
- UC_060 a UC_063 - Casos de uso de auditoria

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
- Implementa: CNST_009
- Genera: UC_060, UC_061, UC_062, UC_063
- Deriva: FR-060.01 a FR-060.05, FR-AUD.01, FR-AUD.02, FR-061.01
