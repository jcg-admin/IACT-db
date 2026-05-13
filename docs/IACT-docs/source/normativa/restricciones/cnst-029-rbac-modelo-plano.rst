.. meta::
 :artefacto: CNST_029
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-029:

===========================
CNST-029: RBAC Modelo Plano
===========================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_029
 * - **Categoria**
   - RBAC
 * - **Tipo (TXM_01)**
   - Tecnica
 * - **Criticidad**
   - Critico
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^


El control de acceso del sistema IACT DEBE implementarse como un
modelo RBAC plano: funciones atomicas asignadas a usuarios via
grupos, sin jerarquia ni herencia entre roles. Esta prohibido el uso
de modelos jerarquicos (RBAC inherit) o ABAC complejo.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


El modelo plano es auditable, predecible y soportado nativamente por
``django-guardian`` u otros frameworks. Modelos jerarquicos derivan
en permisos efectivos opacos al revisor.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Decision de arquitectura (simplicidad operativa)
- **Documento:** MODELO_RBAC_IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Unidad atomica: **Funcion** (vocabulario canonico,
  :doc:`cnst-033-vocabulario-unificado-rbac`). Una accion concreta
  expresada como verbo+recurso, ej. ``manage_sessions``,
  ``view_reports``, ``export_csv``.
- **Grupo de Permisos**: conjunto de funciones asignables como bloque.
- **Asignacion**: usuario en N grupos. No hay asignacion directa de
  funciones a usuarios (excepto via Permisos Excepcionales,
  :doc:`cnst-031-permisos-temporales-maximo-6-meses`).
- Sin herencia: si un grupo deriva de otro, sus funciones se copian
  explicitamente.

**Catalogo de Grupos predefinidos (system groups, inmutables):**

.. list-table::
 :widths: 12 30 13 25 20
 :header-rows: 1

 * - ID
   - Nombre (ingles)
   - # Funciones
   - Actor tipico
   - Tipo
 * - AGR-001
   - basic_operator_group
   - 6
   - Operador
   - system
 * - AGR-002
   - report_viewer_group
   - 8
   - Analista
   - system
 * - AGR-003
   - quality_supervisor_group
   - 11
   - Supervisor
   - system
 * - AGR-004
   - data_exporter_group
   - 14
   - Data Analyst
   - system
 * - AGR-005
   - alert_manager_group
   - 6
   - Gestor Alertas
   - system
 * - AGR-006
   - user_admin_group
   - 9
   - Admin Usuarios
   - system
 * - AGR-007
   - permission_admin_group
   - 5
   - Admin Permisos
   - system
 * - AGR-008
   - auditor_group
   - 4
   - Auditor
   - system
 * - AGR-009
   - pipeline_admin_group
   - 4
   - Admin Pipeline
   - system
 * - AGR-010
   - system_admin_group
   - 6
   - Sysadmin
   - system

**System groups vs custom groups (decision D-RBAC-4):**

Los 10 grupos AGR-001..010 son **system groups**: inmutables, no
editables por admin. Estan definidos en seed inicial del sistema.

El admin puede crear **custom groups** dinamicamente via
:doc:`/requisitos/casos-uso/permissions/uc-perm-05/index`,
asignando capabilities especificas via
:doc:`/requisitos/casos-uso/permissions/uc-perm-06/index`.

Las reglas SoD (:doc:`cnst-030-reglas-de-separacion-de-funciones-sod`)
aplican TANTO a system groups como a custom groups.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- django-guardian
- django.contrib.auth.Group
- Funciones atomicas (custom)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Access
   - Implementa modelo plano + 42 funciones atomicas
 * - (todos)
   - Consultan permisos sin jerarquia

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_042
   - Precedencia de permisos
 * - Todos los UCs con autorizacion
   - Usan modelo plano

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Heredar permisos entre roles
- Usar ABAC complejo
- Crear roles con jerarquia padre/hijo

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: python

 user.groups.all # union de funciones, sin jerarquia

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones permitidas.

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Cambio de modelo requiere ADR + revision arquitectonica.

El protocolo formal de waiver de CNSTs esta pendiente de elaborar en
el WP de gobernanza (`PROC_Excepciones_CNST` — ver
(referencia interna) § W-4).

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El cumplimiento se verifica via los snippets de la seccion 5.

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Manual + Automatico
- **Frecuencia:** Code review + deployment
- **Herramienta:** Inspeccion del modelo + test que verifica que get_effective_permissions no atraviesa jerarquia

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-030-reglas-de-separacion-de-funciones-sod`, :doc:`cnst-031-permisos-temporales-maximo-6-meses`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_042, Todos los UCs con autorizacion
 * - **MODs afectados**
   - MOD_Access, (todos)
 * - **ADRs relacionados**
   - Pendiente WP arquitectura tecnica

9. Historial de Cambios
-----------------------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Version
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2025-12-17
   - NestorMonroy
   - Version inicial (consolidada del backup canonico)
 * - 2.0.0
   - 2026-04-28
   - NestorMonroy
   - Descomposicion SRP (un concern por archivo) + enriquecimiento estructura completa TPL_CNST (9 secciones)

