.. meta::
 :artefacto: HIST_RBAC_001
 :tipo: Documento Historico
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-01-13
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno

.. _hist-rbac-001:

==============================================================
Analisis de Errores — Modelo RBAC IACT v5.2.0 (Change Impact)
==============================================================

.. note::

 **Documento historico — Change Impact Assessment.**

 Preserva el analisis formal de los 87+ errores detectados en
 ``MODELO_RBAC_IACT_v5_2_0`` (enero 2026). Motivo la generacion
 del modelo vigente v5.2.1 + el vocabulario canonico que mas
 tarde se formalizo en :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`.

 NO es spec vigente. Para spec vigente ver
 :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`.

----

1. Contexto
===========

**Fecha original:** 2026-01-13.

**Documento analizado:** ``MODELO_RBAC_IACT_v5_2_0.rst`` (legacy
en ``temp-holding/RBAC/``).

**Metodologia:** Clean Code v2.0.0.

**Cierre:** los hallazgos de este analisis se materializaron en
el modelo v5.2.1 (vigente) y posteriormente se canonizaron en
CNST-033 Vocabulario Unificado RBAC.

----

2. Resumen de Errores Encontrados
=================================

.. list-table::
 :header-rows: 1
 :widths: 40 20 40

 * - Categoria
   - Errores
   - Gravedad
 * - Nombres de funciones (dominio)
   - 42
   - CRITICA
 * - Nombres de grupos
   - 10
   - CRITICA
 * - Nombres de reglas SoD
   - 3
   - CRITICA
 * - Campos SQL mezclados
   - 15+
   - ALTA
 * - Inconsistencias en ejemplos
   - 20+
   - ALTA
 * - **Total**
   - **87+**
   - **INACEPTABLE**

----

3. Error Fundamental: Inconsistencia en Estandar
================================================

3.1 Lo que se documento erroneamente
------------------------------------

   "NUEVA REGLA (desde v5.2): CODIGO en ingles, COMENTARIOS en
   espanol, NOMBRES FUNCIONES (dominio) en espanol."

3.2 Lo correcto (lo que el ejecutor pidio)
------------------------------------------

   "CODIGO en ingles, COMENTARIOS en espanol, **NOMBRES
   FUNCIONES (dominio) en INGLES**."

3.3 Impacto
-----------

- Nombres de funciones quedaron en espanol.
- Nombres de grupos quedaron en espanol.
- Confusion e inconsistencia.
- Razon raiz: se asumio que "dominio" implicaba "mantener
  espanol"; el ejecutor queria TODO en ingles.

----

4. Errores en Nombres de Funciones (42 funciones)
=================================================

4.1 Patron del Error
--------------------

INCORRECTO (lo aplicado en v5.2.0):

.. code-block:: sql

   INSERT INTO functions (function_id, name, description, category) VALUES
   ('AUTH-001', 'gestiona_sesiones', 'Gestiona sesiones activas', 'auth'),
   ('USR-001', 'crea_usuarios', 'Crea nuevos usuarios', 'users'),
   ('RPT-004', 'exporta_csv', 'Exporta a CSV', 'reports');

CORRECTO (aplicado en v5.2.1):

.. code-block:: sql

   INSERT INTO functions (function_id, name, description, category) VALUES
   ('AUTH-001', 'manage_sessions', 'Gestiona sesiones activas', 'auth'),
   ('USR-001', 'create_users', 'Crea nuevos usuarios', 'users'),
   ('RPT-004', 'export_csv', 'Exporta a CSV', 'reports');

Patron correcto:

- ``function_id``: igual (AUTH-001, USR-001).
- ``name``: **INGLES** (manage_sessions).
- ``description``: ESPANOL (comentario semantico).
- ``category``: igual (auth, users).

4.2 Tabla Completa de Correcciones
----------------------------------

4.2.1 MOD_Auth (4 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - AUTH-001
   - ``gestiona_sesiones``
   - ``manage_sessions``
   - Ingles
 * - AUTH-002
   - ``cierra_sesion_usuario``
   - ``close_user_session``
   - Ingles
 * - AUTH-003
   - ``resetea_password``
   - ``reset_password``
   - Ingles
 * - AUTH-004
   - ``ve_sesiones_activas``
   - ``view_active_sessions``
   - Ingles

4.2.2 MOD_Users (9 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - USR-001
   - ``crea_usuarios``
   - ``create_users``
   - Ingles
 * - USR-002
   - ``modifica_usuarios``
   - ``update_users``
   - Ingles + verbo estandar
 * - USR-003
   - ``elimina_usuarios``
   - ``delete_users``
   - Ingles
 * - USR-004
   - ``lista_usuarios``
   - ``list_users``
   - Ingles
 * - USR-005
   - ``busca_usuarios``
   - ``search_users``
   - Ingles
 * - USR-006
   - ``bloquea_usuarios``
   - ``block_users``
   - Ingles
 * - USR-007
   - ``desbloquea_usuarios``
   - ``unblock_users``
   - Ingles
 * - USR-008
   - ``reactiva_usuarios``
   - ``reactivate_users``
   - Ingles
 * - USR-009
   - ``ve_usuarios``
   - ``view_users``
   - Ingles

4.2.3 MOD_Access (5 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - ACC-001
   - ``asigna_funciones``
   - ``assign_functions``
   - Ingles
 * - ACC-002
   - ``revoca_funciones``
   - ``revoke_functions``
   - Ingles
 * - ACC-003
   - ``ve_asignaciones``
   - ``view_assignments``
   - Ingles
 * - ACC-004
   - ``asigna_agrupadores``
   - ``assign_function_groups``
   - Ingles + completo
 * - ACC-005
   - ``gestiona_sod``
   - ``manage_separation_rules``
   - Ingles + sin acronimo

4.2.4 MOD_Pipeline (4 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - PIP-001
   - ``ve_estado_etl``
   - ``view_pipeline_status``
   - Ingles + sin acronimo
 * - PIP-002
   - ``ve_errores_etl``
   - ``view_pipeline_errors``
   - Ingles + sin acronimo
 * - PIP-003
   - ``ve_disponibilidad_datos``
   - ``view_data_availability``
   - Ingles
 * - PIP-004
   - ``solicita_reintento_etl``
   - ``request_pipeline_retry``
   - Ingles + sin acronimo

4.2.5 MOD_Reports (8 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - RPT-001
   - ``ve_reportes``
   - ``view_reports``
   - Ingles
 * - RPT-002
   - ``ve_dashboard``
   - ``view_dashboard``
   - Ingles
 * - RPT-003
   - ``filtra_reportes``
   - ``filter_reports``
   - Ingles
 * - RPT-004
   - ``exporta_csv``
   - ``export_csv``
   - Ingles
 * - RPT-005
   - ``exporta_excel``
   - ``export_excel``
   - Ingles
 * - RPT-006
   - ``exporta_pdf``
   - ``export_pdf``
   - Ingles
 * - RPT-007
   - ``ve_kpis``
   - ``view_kpis``
   - Ingles
 * - RPT-008
   - ``ve_graficos``
   - ``view_charts``
   - Ingles + ``charts`` no ``graphics``

4.2.6 MOD_Alerts (6 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - ALR-001
   - ``ve_alertas``
   - ``view_alerts``
   - Ingles
 * - ALR-002
   - ``configura_alertas``
   - ``configure_alerts``
   - Ingles
 * - ALR-003
   - ``configura_alertas_equipo``
   - ``configure_team_alerts``
   - Ingles
 * - ALR-004
   - ``pausa_alertas``
   - ``pause_alerts``
   - Ingles
 * - ALR-005
   - ``elimina_alertas``
   - ``delete_alerts``
   - Ingles
 * - ALR-006
   - ``ve_historial_alertas``
   - ``view_alert_history``
   - Ingles

4.2.7 MOD_Audit (4 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - AUD-001
   - ``ve_auditoria``
   - ``view_audit_log``
   - Ingles + ``log`` explicito
 * - AUD-002
   - ``busca_auditoria``
   - ``search_audit_log``
   - Ingles + ``log`` explicito
 * - AUD-003
   - ``exporta_auditoria``
   - ``export_audit_log``
   - Ingles + ``log`` explicito
 * - AUD-004
   - ``genera_reporte_compliance``
   - ``generate_compliance_report``
   - Ingles

4.2.8 MOD_Logs (2 funciones)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :header-rows: 1
 :widths: 12 28 28 32

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - LOG-001
   - ``ve_logs_tecnicos``
   - ``view_technical_logs``
   - Ingles
 * - LOG-002
   - ``exporta_logs``
   - ``export_logs``
   - Ingles

----

5. Errores en Nombres de Grupos (10 grupos)
===========================================

5.1 Patron del Error
--------------------

INCORRECTO:

.. code-block:: sql

   INSERT INTO function_groups (group_id, name, description) VALUES
   ('AGR-001', 'agr_operador_basico', 'Visualizacion basica');

CORRECTO:

.. code-block:: sql

   INSERT INTO function_groups (group_id, name, description) VALUES
   ('AGR-001', 'basic_operator_group', 'Visualizacion basica');

Problemas adicionales del patron incorrecto:

1. Prefijo ``agr_`` redundante (ya esta en ``group_id``).
2. Espanol en lugar de ingles.

5.2 Tabla de Correcciones (10 grupos)
-------------------------------------

.. list-table::
 :header-rows: 1
 :widths: 12 30 30 28

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - AGR-001
   - ``agr_operador_basico``
   - ``basic_operator_group``
   - Ingles + sin prefijo redundante
 * - AGR-002
   - ``agr_visualizador_reportes``
   - ``report_viewer_group``
   - Ingles + sin prefijo
 * - AGR-003
   - ``agr_supervisor_calidad``
   - ``quality_supervisor_group``
   - Ingles + sin prefijo
 * - AGR-004
   - ``agr_exportador_datos``
   - ``data_exporter_group``
   - Ingles + sin prefijo
 * - AGR-005
   - ``agr_gestor_alertas``
   - ``alert_manager_group``
   - Ingles + sin prefijo
 * - AGR-006
   - ``agr_admin_usuarios``
   - ``user_admin_group``
   - Ingles + sin prefijo
 * - AGR-007
   - ``agr_admin_permisos``
   - ``permission_admin_group``
   - Ingles + sin prefijo
 * - AGR-008
   - ``agr_auditor``
   - ``auditor_group``
   - Ingles + sin prefijo
 * - AGR-009
   - ``agr_admin_pipeline``
   - ``pipeline_admin_group``
   - Ingles + sin prefijo
 * - AGR-010
   - ``agr_admin_sistema``
   - ``system_admin_group``
   - Ingles + sin prefijo

Patron correcto:

- Eliminar prefijo ``agr_`` (redundante con ``group_id``).
- Usar ingles.
- Formato: ``{role}_{scope}_group`` o ``{role}_group``.

----

6. Errores en Nombres de Reglas SoD (3 reglas)
==============================================

.. list-table::
 :header-rows: 1
 :widths: 12 30 30 28

 * - ID
   - Incorrecto
   - Correcto
   - Razon
 * - SOD-001
   - ``sod_admin_auditoria``
   - ``pipeline_audit_separation``
   - Ingles + descriptivo
 * - SOD-002
   - ``sod_usuarios_auditoria``
   - ``user_audit_separation``
   - Ingles + descriptivo
 * - SOD-003
   - ``sod_acceso_auditoria``
   - ``access_audit_separation``
   - Ingles + descriptivo

Problemas:

1. Prefijo ``sod_`` redundante (ya esta en ``rule_id``).
2. Espanol mezclado con ingles.
3. Poco descriptivo.

----

7. Errores en Campos SQL
========================

7.1 Nombres de Columnas Inconsistentes
--------------------------------------

INCORRECTO:

.. code-block:: sql

   CREATE TABLE function_separation_rule_details (
       separation_group CHAR(1)  -- nombre confuso
   );

CORRECTO:

.. code-block:: sql

   CREATE TABLE function_separation_rule_details (
       rule_group CHAR(1)  -- mas claro
   );

7.2 Tabla de Correcciones de Campos
-----------------------------------

.. list-table::
 :header-rows: 1
 :widths: 30 25 25 20

 * - Tabla
   - Campo Incorrecto
   - Campo Correcto
   - Razon
 * - ``function_separation_rule_details``
   - ``separation_group``
   - ``rule_group``
   - Mas conciso
 * - ``user_function_assignments``
   - ``assigned_date``
   - ``assigned_at``
   - Convencion ``*_at`` para datetime
 * - ``user_function_group_assignments``
   - ``assigned_date``
   - ``assigned_at``
   - Convencion ``*_at`` para datetime

----

8. Errores en Decorators y Ejemplos
===================================

INCORRECTO (en el documento):

.. code-block:: python

   @require_function('RPT-001', 'RPT-002')
   def list_reports(request):
       """Listado de reportes."""
       pass

CORRECTO (con nombre legible para claridad):

.. code-block:: python

   @require_function('RPT-001')  # view_reports
   def list_reports(request):
       """Listado de reportes."""
       pass

----

9. Errores en Modelos Django
============================

9.1 help_text mezclados
-----------------------

INCORRECTO:

.. code-block:: python

   name = models.CharField(
       help_text="Nombre descriptivo (ve_reportes, exporta_csv)"
   )

CORRECTO:

.. code-block:: python

   name = models.CharField(
       help_text="Nombre descriptivo (view_reports, export_csv)"
   )

9.2 Docstrings con ejemplos incorrectos
---------------------------------------

INCORRECTO:

.. code-block:: python

   class Function(models.Model):
       """
       Funcion atomica del sistema.

       Ejemplos:
       - ve_reportes       # espanol incorrecto
       - exporta_csv       # espanol incorrecto
       """

CORRECTO:

.. code-block:: python

   class Function(models.Model):
       """
       Funcion atomica del sistema.

       Ejemplos:
       - view_reports      # ingles correcto
       - export_csv        # ingles correcto
       """

----

10. Errores en Services
=======================

INCORRECTO (comentario):

.. code-block:: python

   def calculate_effective_functions(self, user: User) -> Set[str]:
       """
       Returns:
           Set de function_id: {'RPT-001', 'RPT-002', ...}  # 'de' espanol
       """

CORRECTO:

.. code-block:: python

   def calculate_effective_functions(self, user: User) -> Set[str]:
       """
       Returns:
           Set of function_id: {'RPT-001', 'RPT-002', ...}  # 'of' ingles
       """

----

11. Resumen de Transformaciones Necesarias
==========================================

11.1 Patron general
-------------------

::

   Espanol (snake_case)        Ingles (snake_case)
   -----------------------------------------------
   gestiona_*          ->  manage_*
   ve_*                ->  view_*
   crea_*              ->  create_*
   modifica_*          ->  update_*
   elimina_*           ->  delete_*
   busca_*             ->  search_*
   bloquea_*           ->  block_*
   desbloquea_*        ->  unblock_*
   reactiva_*          ->  reactivate_*
   asigna_*            ->  assign_*
   revoca_*            ->  revoke_*
   configura_*         ->  configure_*
   pausa_*             ->  pause_*
   solicita_*          ->  request_*
   exporta_*           ->  export_*
   filtra_*            ->  filter_*
   genera_*            ->  generate_*

11.2 Verbos especificos
-----------------------

::

   ve_reportes         ->  view_reports
   ve_graficos         ->  view_charts (NO 'graphics')
   ve_auditoria        ->  view_audit_log
   cierra_sesion       ->  close_session
   resetea_password    ->  reset_password

----

12. Lecciones Aprendidas
========================

12.1 Error fundamental
----------------------

Lo aplicado mal:

- Se asumio que "dominio" = "mantener espanol".
- No se leyo claramente el requerimiento del ejecutor.
- Inconsistencia con el propio estandar declarado.

Lo correcto:

- TODO el codigo en ingles (sin excepciones).
- Comentarios y descripciones en espanol.
- Consistencia absoluta.

12.2 Principio canonico (incorporado luego en CNST-033)
-------------------------------------------------------

::

   CODIGO: Ingles      (clases, metodos, variables, nombres de funciones)
   DOCS:   Espanol     (docstrings, help_text, comments)

NO HAY EXCEPCIONES para "dominio" o cualquier otro caso. Esta
regla se formalizo posteriormente en CNST-033 Vocabulario
Unificado RBAC.

----

13. Conclusion del Analisis Original
====================================

Total de errores identificados: **87+**.

Categorias:

- Nombres de funciones: 42 (CRITICA).
- Nombres de grupos: 10 (CRITICA).
- Nombres de reglas SoD: 3 (CRITICA).
- Campos SQL: 15+ (ALTA).
- Ejemplos y comentarios: 20+ (ALTA).

Accion materializada:

- Generacion de ``MODELO_RBAC_IACT v5.2.1`` con todas las
  correcciones aplicadas.
- Posterior: formalizacion del vocabulario canonico en CNST-033.

----

14. Cierre y Trazabilidad
=========================

**Documento original:** ``temp-holding/RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.rst``
(no publicado).

**Documento de respuesta vigente:**
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (v5.2.1).

**Restriccion normativa que canonizo el aprendizaje:**
:doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`.

**Decision arquitectonica que reconcilia las vistas:**
:doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`.
