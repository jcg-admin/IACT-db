.. meta::
 :artefacto: RACI_RBAC_IACT
 :tipo: Matriz RACI
 :dominio: arquitectura-tecnica
 :subdominio: rbac
 :estado: Aprobado
 :version: 1.2.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Critico

.. _raci-rbac-iact:

==============================================================
Matriz RACI — RBAC IACT (61 Funciones x Stakeholders)
==============================================================

.. note::

 Matriz RACI sobre el catalogo de **61 funciones** + **10 grupos
 AGR-001..010** + **3 reglas SOD-001..003** del modelo RBAC IACT
 v5.4.0. Resuelve la nota in-text de ADR-BACK-004 legacy y
 cierra la deuda DEBT-RBAC-RACI sin diferir.

 Per :doc:`/normativa/gobernanza/adr-gob-009-rbac-modelo-conceptual`
 y :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`.

----

1. Convencion RACI
==================

.. list-table::
 :header-rows: 1
 :widths: 12 88

 * - Codigo
   - Significado
 * - **R**
   - **Responsible** — ejecuta la funcion (rol que la realiza)
 * - **A**
   - **Accountable** — autoridad final / owner de la spec de la funcion
 * - **C**
   - **Consulted** — consultado antes de cambios a la funcion
 * - **I**
   - **Informed** — notificado tras cambios o ejecucion

**Regla unica per funcion:** una sola **A** (accountable). Multiples
**R**, **C**, **I** permitidos.

----

2. Stakeholders identificados
=============================

Los 6 stakeholders agrupan los **10 Actores Tipicos** documentados
en :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` § 4.1
(catalogo de grupos AGR-001..010). El mapeo es 1-N: un
stakeholder puede agrupar multiples Actores Tipicos.

.. list-table::
 :header-rows: 1
 :widths: 22 12 36 30

 * - Stakeholder
   - Codigo
   - Descripcion
   - Mapeo a Actor Tipico v5.2.1 / Grupo AGR
 * - Admin no-tech
   - **AdmNT**
   - Asigna agrupadores predefinidos a usuarios. Perfil
     RH/Ops sin background tecnico.
   - "Admin Usuarios" -> AGR-006 (``user_admin_group``)
 * - Admin tecnico (DevSecOps)
   - **AdmT**
   - Crea grupos custom, define funciones, gestiona permisos
     excepcionales.
   - "Admin Permisos" -> AGR-007 (``permission_admin_group``);
     "Admin Pipeline" -> AGR-009 (``pipeline_admin_group``);
     "Sysadmin" -> AGR-010 (``system_admin_group``)
 * - Operador final
   - **Op**
   - Consume funciones operativas via su asignacion de grupo.
   - "Operador" -> AGR-001 (``basic_operator_group``);
     "Analista" -> AGR-002 (``report_viewer_group``);
     "Supervisor" -> AGR-003 (``quality_supervisor_group``);
     "Data Analyst" -> AGR-004 (``data_exporter_group``);
     "Gestor Alertas" -> AGR-005 (``alert_manager_group``)
 * - Tech Lead Backend
   - **TLB**
   - Owner tecnico de la spec del modelo RBAC + implementacion
     backend (Django + SQL). Accountable global del modelo.
   - Externo a los grupos AGR (rol de gobernanza tecnica)
 * - Equipo de Auditoria
   - **Aud**
   - Consulta logs RBAC + reglas SoD. Aplica restriccion SoD
     declarada en v5.2.1 § 4.2 (NO puede tener funciones de
     otros admin groups).
   - "Auditor" -> AGR-008 (``auditor_group``)
 * - Equipo Compliance
   - **Comp**
   - Notificado de cambios al modelo RBAC para reportes
     normativos (SOX, ISO 27001).
   - Externo a los grupos AGR (rol stakeholder regulatorio)

----

3. RACI por modulo (vista resumida)
===================================

3.1 MOD_Auth (4 funciones — autenticacion y sesiones)
-----------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - AUTH-001
   - ``view_own_sessions``
   - I
   - C
   - R
   - A
   - I
   - I
 * - AUTH-002
   - ``close_user_session``
   - C
   - R
   - R
   - A
   - I
   - —
 * - AUTH-003
   - ``reset_password``
   - R
   - R
   - —
   - A
   - I
   - I
 * - AUTH-004
   - ``view_all_active_sessions``
   - I
   - C
   - —
   - A
   - R
   - I

3.2 MOD_Users (9 funciones — gestion de identidades)
----------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - USR-001
   - ``create_users``
   - R
   - C
   - —
   - A
   - I
   - I
 * - USR-002
   - ``update_users``
   - R
   - C
   - —
   - A
   - I
   - —
 * - USR-003
   - ``deactivate_users``
   - C
   - R
   - —
   - A
   - I
   - I
 * - USR-004
   - ``list_users``
   - R
   - I
   - —
   - A
   - R
   - —
 * - USR-005
   - ``search_users``
   - R
   - —
   - —
   - A
   - R
   - —
 * - USR-006
   - ``block_users``
   - R
   - C
   - —
   - A
   - I
   - I
 * - USR-007
   - ``unblock_users``
   - R
   - C
   - —
   - A
   - I
   - I
 * - USR-008
   - ``reactivate_users``
   - R
   - C
   - —
   - A
   - I
   - —
 * - USR-009
   - ``view_users``
   - R
   - —
   - —
   - A
   - R
   - —

3.3 MOD_Access (12 funciones — RBAC vista funcional + admin)
------------------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - ACC-001
   - ``assign_functions``
   - R
   - C
   - —
   - A
   - I
   - I
 * - ACC-002
   - ``revoke_functions``
   - R
   - C
   - —
   - A
   - I
   - I
 * - ACC-003
   - ``view_assignments``
   - R
   - I
   - —
   - A
   - R
   - —
 * - ACC-004
   - ``assign_function_groups``
   - R
   - C
   - —
   - A
   - I
   - I
 * - ACC-005
   - ``view_separation_rules``
   - C
   - R
   - —
   - A
   - C
   - I
 * - ACC-006
   - ``create_function_group`` (NUEVA v5.3.0)
   - I
   - R
   - —
   - A
   - C
   - I
 * - ACC-007
   - ``assign_functions_to_group`` (NUEVA v5.3.0)
   - I
   - R
   - —
   - A
   - C
   - I
 * - ACC-008
   - ``grant_exceptional_permission`` (NUEVA v5.3.0)
   - C
   - R
   - —
   - A
   - C
   - I
 * - ACC-009
   - ``revoke_exceptional_permission`` (NUEVA v5.3.0)
   - C
   - R
   - —
   - A
   - C
   - I
 * - ACC-010
   - ``revoke_function_group`` (NUEVA v5.3.0)
   - R
   - C
   - —
   - A
   - I
   - I
 * - ACC-011
   - ``update_separation_rule`` (NUEVA v5.4.0)
   - I
   - R
   - —
   - A
   - C
   - I
 * - ACC-012
   - ``disable_separation_rule`` (NUEVA v5.4.0)
   - I
   - R
   - —
   - A
   - C
   - I

3.4 MOD_Pipeline (4 funciones — supervision ETL)
------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - PIP-001
   - ``view_pipeline_status``
   - I
   - I
   - R
   - A
   - I
   - —
 * - PIP-002
   - ``view_pipeline_errors``
   - —
   - I
   - R
   - A
   - I
   - —
 * - PIP-003
   - ``view_data_availability``
   - —
   - I
   - R
   - A
   - I
   - —
 * - PIP-004
   - ``request_pipeline_retry``
   - —
   - C
   - R
   - A
   - I
   - —

3.5 MOD_Reports (11 funciones — visualizacion y reportes)
---------------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - RPT-001
   - ``view_reports``
   - R
   - —
   - R
   - A
   - I
   - I
 * - RPT-002
   - ``view_dashboard``
   - R
   - —
   - R
   - A
   - I
   - I
 * - RPT-003
   - ``filter_reports``
   - R
   - —
   - R
   - A
   - I
   - —
 * - RPT-004
   - ``export_csv``
   - R
   - —
   - R
   - A
   - I
   - I
 * - RPT-005
   - ``export_excel``
   - R
   - —
   - R
   - A
   - I
   - I
 * - RPT-006
   - ``export_pdf``
   - R
   - —
   - R
   - A
   - I
   - I
 * - RPT-007
   - ``view_kpis``
   - R
   - —
   - R
   - A
   - I
   - I
 * - RPT-008
   - ``view_charts``
   - R
   - —
   - R
   - A
   - I
   - I
 * - RPT-009
   - ``schedule_report`` (NUEVA v5.3.0 — restaura ``programa_reportes`` v5.0_1/v5.1)
   - R
   - C
   - —
   - A
   - I
   - I
 * - RPT-010
   - ``save_view`` (NUEVA v5.3.0)
   - R
   - —
   - R
   - A
   - I
   - —
 * - RPT-011
   - ``share_report`` (NUEVA v5.3.0 — restaura ``comparte_reportes`` v5.0_1/v5.1)
   - R
   - C
   - R
   - A
   - I
   - I

3.6 MOD_Alerts (10 funciones — alertas y notificaciones)
--------------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - ALR-001
   - ``view_alerts``
   - R
   - —
   - R
   - A
   - I
   - —
 * - ALR-002
   - ``configure_alerts``
   - R
   - C
   - C
   - A
   - I
   - I
 * - ALR-003
   - ``configure_team_alerts``
   - R
   - C
   - —
   - A
   - I
   - I
 * - ALR-004
   - ``pause_alerts``
   - R
   - I
   - —
   - A
   - I
   - —
 * - ALR-005
   - ``disable_alerts``
   - R
   - C
   - —
   - A
   - I
   - I
 * - ALR-006
   - ``view_alert_history``
   - R
   - —
   - R
   - A
   - R
   - —
 * - ALR-007
   - ``acknowledge_alert`` (NUEVA v5.4.0)
   - R
   - C
   - R
   - A
   - I
   - I
 * - ALR-008
   - ``subscribe_to_alert`` (NUEVA v5.4.0)
   - R
   - C
   - R
   - A
   - I
   - —
 * - ALR-009
   - ``unsubscribe_from_alert`` (NUEVA v5.4.0)
   - R
   - C
   - R
   - A
   - I
   - —
 * - ALR-010
   - ``configure_subscription_severity`` (NUEVA v5.4.0)
   - R
   - C
   - —
   - A
   - I
   - —

3.7 MOD_Audit (4 funciones — auditoria funcional)
-------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - AUD-001
   - ``view_audit_log``
   - I
   - I
   - —
   - A
   - R
   - C
 * - AUD-002
   - ``search_audit_log``
   - I
   - I
   - —
   - A
   - R
   - C
 * - AUD-003
   - ``export_audit_log``
   - I
   - C
   - —
   - A
   - R
   - C
 * - AUD-004
   - ``generate_compliance_report``
   - I
   - I
   - —
   - A
   - R
   - C

3.8 MOD_Logs (7 funciones — bitacoras tecnicas + health + métricas)
-------------------------------------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 8 30 12 10 10 10 10 10

 * - ID
   - Funcion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - LOG-001
   - ``view_application_logs``
   - —
   - R
   - —
   - A
   - C
   - —
 * - LOG-002
   - ``export_logs``
   - —
   - R
   - —
   - A
   - C
   - I
 * - LOG-003
   - ``search_logs`` (NUEVA v5.3.0)
   - —
   - R
   - —
   - A
   - C
   - —
 * - LOG-004
   - ``view_etl_logs`` (NUEVA v5.4.0)
   - —
   - R
   - —
   - A
   - C
   - —
 * - LOG-005
   - ``view_infrastructure_logs`` (NUEVA v5.4.0)
   - —
   - R
   - —
   - A
   - C
   - —
 * - LOG-006
   - ``view_system_health`` (NUEVA v5.4.0)
   - —
   - R
   - —
   - A
   - I
   - —
 * - LOG-007
   - ``view_technical_metrics`` (NUEVA v5.4.0)
   - —
   - R
   - —
   - A
   - I
   - —

----

4. RACI por grupo predefinido (AGR-001..010)
============================================

.. list-table::
 :header-rows: 1
 :widths: 8 28 14 12 12 12 14

 * - ID
   - Grupo (nombre canonico)
   - AdmNT
   - AdmT
   - TLB
   - Aud
   - Comp
 * - AGR-001
   - ``basic_operator_group``
   - R
   - C
   - A
   - I
   - I
 * - AGR-002
   - ``report_viewer_group``
   - R
   - C
   - A
   - I
   - I
 * - AGR-003
   - ``quality_supervisor_group``
   - R
   - C
   - A
   - I
   - I
 * - AGR-004
   - ``data_exporter_group``
   - R
   - C
   - A
   - I
   - I
 * - AGR-005
   - ``alert_manager_group``
   - R
   - C
   - A
   - I
   - I
 * - AGR-006
   - ``user_admin_group``
   - C
   - R
   - A
   - I
   - I
 * - AGR-007
   - ``permission_admin_group``
   - I
   - R
   - A
   - C
   - I
 * - AGR-008
   - ``auditor_group``
   - I
   - C
   - A
   - R
   - I
 * - AGR-009
   - ``pipeline_admin_group``
   - I
   - R
   - A
   - I
   - —
 * - AGR-010
   - ``system_admin_group``
   - I
   - R
   - A
   - C
   - I

----

5. RACI sobre reglas SoD (SOD-001..003)
=======================================

.. list-table::
 :header-rows: 1
 :widths: 8 28 14 12 12 12 14

 * - ID
   - Regla SoD
   - AdmNT
   - AdmT
   - TLB
   - Aud
   - Comp
 * - SOD-001
   - ``pipeline_audit_separation``
   - I
   - C
   - A
   - R
   - C
 * - SOD-002
   - ``user_audit_separation``
   - I
   - C
   - A
   - R
   - C
 * - SOD-003
   - ``access_audit_separation``
   - I
   - C
   - A
   - R
   - C

----

6. RACI sobre operaciones de gobernanza del modelo
==================================================

.. list-table::
 :header-rows: 1
 :widths: 35 12 12 12 12 12 12

 * - Operacion
   - AdmNT
   - AdmT
   - Op
   - TLB
   - Aud
   - Comp
 * - Agregar nueva funcion al catalogo
   - —
   - C
   - —
   - A
   - C
   - I
 * - Eliminar funcion del catalogo (Deprecate)
   - —
   - C
   - —
   - A
   - C
   - C
 * - Crear grupo custom
   - —
   - R
   - —
   - A
   - I
   - I
 * - Modificar grupo system (AGR-001..010)
   - —
   - C
   - —
   - A
   - C
   - C
 * - Agregar regla SoD
   - —
   - C
   - —
   - A
   - C
   - I
 * - Conceder permiso excepcional (max 6 meses, CNST-031)
   - —
   - R
   - —
   - A
   - C
   - I
 * - Renovar permiso excepcional
   - —
   - R
   - —
   - A
   - C
   - I
 * - Auditar accesos del periodo
   - —
   - I
   - —
   - A
   - R
   - I
 * - Generar reporte compliance
   - —
   - I
   - —
   - A
   - R
   - C

----

7. Convenciones de uso
======================

7.1 Conflictos R/A
------------------

Si la misma persona/rol aparece como **R** y **A** para una funcion,
es valido (ejecuta + es accountable). Pero **A es unico**: no
puede haber dos roles distintos con A para la misma funcion.

7.2 Cambios al catalogo
-----------------------

Cualquier cambio al catalogo de funciones, grupos o reglas SoD
requiere:

1. Aprobacion del **TLB** (Accountable global del modelo).
2. Consulta a **AdmT** (DevSecOps, impacto tecnico).
3. Consulta a **Aud** (impacto en auditoria/compliance).
4. Notificacion a **Comp** tras el cambio.

Per :doc:`/normativa/gobernanza/adr-gob-009-rbac-modelo-conceptual`
y :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`.

7.3 Permisos excepcionales (CNST-031)
-------------------------------------

Maximo **6 meses** de duracion. Renovacion requiere nueva
aprobacion **AdmT** + **TLB** + auditoria.

----

8. Trazabilidad
===============

- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` — modelo
  conceptual v5.3.0 (catalogo de 51 funciones + 10 AGR + 3 SoD).
- :doc:`/normativa/gobernanza/adr-gob-009-rbac-modelo-conceptual` —
  ADR canonico que motivo la generacion de esta matriz (resuelve
  nota in-text de ADR-BACK-004 legacy).
- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano` —
  CNST normativo del modelo plano.
- :doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod` —
  3 reglas SoD declarativas.
- :doc:`/normativa/restricciones/cnst-031-permisos-temporales-maximo-6-meses` —
  permisos excepcionales.
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac` —
  vocabulario canonico ingles.
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm` —
  coexistencia ACC + PERM.

----

9. Mantenimiento
================

Esta matriz se actualiza cuando:

- Se agrega/elimina una funcion del catalogo.
- Se agrega/elimina un grupo predefinido.
- Se agrega/modifica una regla SoD.
- Cambia un stakeholder canonico.

**Owner del mantenimiento:** TLB (Tech Lead Backend).

----

10. Fundamento documental
=========================

Las asignaciones R/A/C/I de esta matriz se fundamentan en los
"Actor Tipico" + "Proposito" de cada grupo AGR documentados en
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` § 4.1
(catalogo de los 10 grupos predefinidos del modelo v5.2.1):

.. list-table::
 :header-rows: 1
 :widths: 12 28 60

 * - AGR
   - Actor Tipico
   - Proposito (per modelo v5.2.1 § 4.2)
 * - AGR-001
   - Operador
   - Usuario basico que solo visualiza informacion.
 * - AGR-002
   - Analista
   - Analista que puede aplicar filtros pero no exportar.
 * - AGR-003
   - Supervisor
   - Supervisor con capacidad de configurar alertas propias.
 * - AGR-004
   - Data Analyst
   - Analista autorizado para exportar con limites CNST-007.
 * - AGR-005
   - Gestor Alertas
   - Gestor de alertas de equipo/departamento.
 * - AGR-006
   - Admin Usuarios
   - Administracion completa de identidades.
     **SoD:** NO puede tener funciones de AGR-008 (auditoria).
 * - AGR-007
   - Admin Permisos
   - Administracion de RBAC.
 * - AGR-008
   - Auditor
   - Solo auditoria. **SoD:** restriccion declarada en SOD-001/002/003.
 * - AGR-009
   - Admin Pipeline
   - Administracion de ETL.
 * - AGR-010
   - Sysadmin
   - Administracion tecnica del sistema.

**Razones de la R/A elegida en este documento:**

- ``A`` (Accountable) global = TLB porque es el owner unico del
  modelo conceptual (per :doc:`/normativa/gobernanza/adr-gob-009-rbac-modelo-conceptual`).
- ``R`` (Responsible) por funcion siguen el grupo AGR cuyo
  Proposito declarado en v5.2.1 incluye esa funcion. Por ejemplo:

  - ``view_reports`` (RPT-001): R = Op (incluye AGR-002
    "Analista que puede aplicar filtros pero no exportar" + AGR-003
    "Supervisor" + AGR-004 "Data Analyst") y AdmNT (AGR-006 que
    para administracion ve reportes propios).
  - ``view_audit_log`` (AUD-001): R = Aud unico porque AGR-008
    tiene SoD declarado contra otros admin groups
    (per :doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod`).
  - ``view_separation_rules`` (ACC-005): R = AdmT, C = AdmNT/Aud
    porque modificar reglas SoD afecta directamente la
    administracion no-tech (y es auditable).

**Trazabilidad a fuente legacy del catalogo de grupos:**

- :doc:`/gestion/evidencia/rbac-historia/analisis-errores-modelo-rbac-v5-2-0`
  documenta el origen del nombre ingles canonico de cada grupo
  (corregido de espanol en v5.2.0).
- :doc:`/gestion/evidencia/rbac-historia/modelo-rbac-v4-0-roles-jerarquicos-deprecado`
  documenta los "bundles" v4.0 (10 predefinidos) que dieron
  origen a los AGR-001..010 vigentes.
