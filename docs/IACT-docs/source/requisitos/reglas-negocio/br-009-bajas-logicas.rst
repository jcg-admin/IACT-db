.. meta::
 :artefacto: BR_009
 :tipo: Regla de Negocio
 :dominio: requisitos
 :subdominio: reglas_negocio
 :estado: Aprobado
 :version: 2.0.0
 :fecha_creacion: 2026-01-04
 :ultimo_cambio: 2026-04-30
 :autor: Equipo IACT
 :clasificacion: Critico

.. _br-009:

==================================================
BR_009: No Eliminar Datos (Bajas Lógicas Globales)
==================================================


Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - BR_009
 * - **Nombre**
   - No Eliminar Datos (Bajas Lógicas Globales)
 * - **Tipo**
   - Restriccion Global
 * - **Categoria**
   - Operacional / Cumplimiento / Auditoría
 * - **Criticidad**
   - Crítico
 * - **Estado**
   - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

Ningún registro del sistema IACT puede ser eliminado físicamente
de la base de datos. Toda "eliminación" debe implementarse como
**baja lógica** mediante cambio de estado, preservando el registro
para auditoría e integridad referencial.

Esta regla aplica a **TODOS los módulos del sistema**, no solo a
MOD_Users como en versiones previas. Cubre usuarios, alertas,
reglas SoD, suscripciones, configuraciones, y cualquier otra
entidad persistente.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

 VOCABULARIO:
 - Baja lógica: Cambio de estado a INACTIVO/DISABLED/ARCHIVED
   sin borrar el registro.
 - Baja física: DELETE SQL del registro (PROHIBIDO).
 - Estados canónicos por entidad:
   * Usuario: ACTIVO, INACTIVO, BLOQUEADO
   * Alerta: ACTIVE, ACKNOWLEDGED, RESOLVED, DISABLED
   * Regla SoD: ENABLED, DISABLED
   * Suscripción: ACTIVE, INACTIVE
   * Otros: ACTIVE/INACTIVE como mínimo

 REGLA:
 Es PROHIBIDO eliminar físicamente cualquier registro persistente
 del sistema IACT salvo excepciones declaradas explícitamente
 (sección 4.2).
 Es OBLIGATORIO que la "eliminación" sea mediante cambio de estado
 a un valor terminal de la entidad.
 Es OBLIGATORIO preservar el registro original aunque cambie su
 estado.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

1. **Integridad referencial:** registros históricos (auditorías,
   asignaciones pasadas, ejecuciones de pipeline) referencian
   entidades que pueden haber sido "eliminadas".
2. **Cumplimiento regulatorio:** SOX, ISO 27001 requieren
   trazabilidad completa de cambios de estado.
3. **Reactivación:** una baja lógica puede revertirse; una baja
   física no.
4. **Auditoría forense:** investigaciones post-incidente requieren
   acceso al registro completo, incluido el "borrado".
5. **Consistencia metodológica:** un solo principio aplicado
   uniformemente reduce ambigüedad para implementadores.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restricción Global**: Limita acciones permitidas en todos
los módulos.

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estática
- **Automatizable**: Sí — modelo Django sin operación delete
  física; middleware de DB con permisos restringidos.
- **Alcance**: TODOS los módulos del sistema (MOD_Users,
  MOD_Alerts, MOD_Access, MOD_Audit, MOD_Logs, MOD_Reports,
  MOD_Pipeline, MOD_Auth).

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Documento**
   - Política de Retención de Datos + auditoría de SRP/cleanup
     (WP rbac-modelo-conceptual-cleanup)
 * - **Tipo Fuente**
   - Política Interna + Cumplimiento Regulatorio

----

4. Aplicacion en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

**Todos los módulos del sistema:**

.. list-table::
 :widths: 25 35 40
 :header-rows: 1

 * - Módulo
   - Función "eliminar"
   - Implementación correcta
 * - MOD_Users
   - USR-003 ``deactivate_users``
   - estado = INACTIVO; preservar usuario para audit log
 * - MOD_Alerts
   - ALR-005 ``disable_alerts``
   - estado = DISABLED; preservar histórico de la alerta
 * - MOD_Access
   - ACC-002 ``revoke_functions``
   - end_date en assignment; registro persiste
 * - MOD_Access
   - ACC-009 ``revoke_exceptional_permission``
   - end_date acelerado; registro persiste
 * - MOD_Access
   - ACC-010 ``revoke_function_group``
   - end_date en assignment de grupo; registro persiste
 * - MOD_Access
   - ACC-012 ``disable_separation_rule``
   - estado = DISABLED; regla persiste para historia
 * - MOD_Alerts
   - ALR-009 ``unsubscribe_from_alert``
   - estado de subscription = INACTIVE; persiste
 * - MOD_Audit
   - (sin operación de delete)
   - audit log es append-only (CNST_025)
 * - MOD_Logs
   - (sin operación de delete)
   - logs aplican retención por antigüedad, no delete por entidad
 * - MOD_Pipeline
   - (sin operación de delete)
   - ejecuciones ETL persisten todas

4.2 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

Solo dos casos justifican delete físico:

1. **Datos de prueba en ambiente de desarrollo** (NO producción).
2. **Retención por antigüedad** (CNST específica de retención por
   módulo): logs técnicos viejos pueden purgarse según política
   de retención declarada. NO aplica a registros de negocio.

Cualquier otra excepción requiere ADR explícito + waiver
documentado.

----

5. Trazabilidad
---------------

5.1 UC Afectados
^^^^^^^^^^^^^^^^

- uc-usr-04: Eliminar Usuario (baja lógica)
- uc-alr-04 / uc-alr-05: Gestión de alertas + suscripciones
- uc-acc-02: Revocar Funciones (revocación lógica)
- uc-acc-08: Permiso temporal (revocable lógicamente)
- TODOS los UCs de operaciones administrativas.

5.2 BReq Influenciados
^^^^^^^^^^^^^^^^^^^^^^

- BReq-004: Cumplimiento de Seguridad
- BReq de Auditoría (preservación de evidencia)

5.3 Cambios al modelo RBAC v5.4.0 motivados por esta BR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- USR-003 RENAME ``delete_users`` → ``deactivate_users``
- ALR-005 RENAME ``delete_alerts`` → ``disable_alerts``
- ACC-012 NUEVA ``disable_separation_rule`` (toggle, no delete)

Funciones con verbo ``revoke_*`` (ACC-002, ACC-009, ACC-010) son
compatibles con esta BR: revocar = end_date en el assignment, NO
delete del registro.

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Modelos Django de TODOS los módulos implementan soft delete
   (campo ``status`` o ``end_date`` según entidad).
2. NO existe operación DELETE en API pública para registros de
   negocio.
3. Permisos de BD restringen DELETE a roles operacionales (no
   aplicación).
4. Tests de regresión verifican que después de "eliminar" el
   registro persiste con estado terminal.

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Automático + Auditoría manual periódica
- **Frecuencia:** Continuo (CI) + revisión trimestral
- **Herramienta:** Tests que ejercitan "delete" y validan que el
  registro sigue existiendo con estado terminal; revisión de
  logs SQL para detectar DELETE no autorizados.

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
   - 2026-01-04
   - Equipo IACT
   - Versión inicial (alcance MOD_Users solamente)
 * - 2.0.0
   - 2026-04-30
   - NestorMonroy
   - **Alcance global** (todos los módulos). Estados canónicos por
     entidad. Mapeo a renames del modelo v5.4.0. Decision D-01 (WP
     rbac-modelo-conceptual-cleanup).
