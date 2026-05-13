
----

3. Actores
----------

3.1 Definicion de Actor
^^^^^^^^^^^^^^^^^^^^^^^

Un **actor** es una entidad externa al sistema que interactua con el.
Puede ser una persona (rol), otro sistema, o el tiempo.

3.2 Tipos de Actores
^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Tipo
     - Descripcion
     - Ejemplo IACT
   * - Humano
     - Persona con rol especifico
     - AGR-004 (visor_dashboard)
   * - Sistema
     - Sistema externo que interactua
     - Sistema IVR MySQL
   * - Tiempo
     - Eventos programados
     - Scheduler ETL (medianoche)

3.3 Actor Primario vs Secundario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ACTOR PRIMARIO:
     - Inicia el caso de uso
     - Tiene el objetivo principal
     - Ejemplo: AGR-008 que configura SoD

   ACTOR SECUNDARIO:
     - Participa pero no inicia
     - Proporciona informacion o recibe notificacion
     - Ejemplo: AGR-007 que recibe notificacion de cambio

3.4 Actores en IACT (v1.2.0 - Agrupadores RBAC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. important::

   **ACTUALIZACION v1.2.0:**
   
   Los actores en IACT se definen mediante **Agrupadores RBAC** siguiendo
   la filosofia "Sin Pretensiones" del modelo RBAC v5.1.1. Esto reemplaza
   la nomenclatura anterior basada en roles R001-R018.

Los actores en IACT corresponden a los 10 Agrupadores del modelo RBAC v5.1.1:

.. code-block:: text

   AGRUPADOR                      FUNCIONES INCLUIDAS        UC TIPICOS
   ─────────────────────────────────────────────────────────────────────────
   AGR-001: administrador_usuarios  USR-001 a USR-010       UC-006 a UC-009
   AGR-002: visor_usuarios          USR-005, USR-006        UC-009
   AGR-003: analista_reportes       RPT-001 a RPT-008       UC-017 a UC-024
   AGR-004: visor_dashboard         RPT-001, RPT-007, RPT-008  UC-025 a UC-030
   AGR-005: gestor_alertas          ALR-001 a ALR-006       UC-036 a UC-040
   AGR-006: supervisor_equipo       USR-005/06, RPT-001/07  UC-009, UC-017
   AGR-007: auditor                 AUD-001 a AUD-004       UC-060 a UC-063
   AGR-008: admin_seguridad         ACC-001 a ACC-006       UC-010, UC-043-047
   AGR-009: admin_sistema           PIP-*, LOG-*, config    UC-050-053, UC-070-072
   AGR-010: operador_etl            PIP-001 a PIP-004       UC-050 a UC-053

   ACTOR ESPECIAL:
   TIEMPO: Para procesos batch (ETL nocturno) - UC-050

3.5 Mapeo de Actores Legacy a Agrupadores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para compatibilidad con documentacion anterior:

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Rol Legacy (R00x)
     - Agrupador (AGR-00x)
     - Nota
   * - R001: USERS_FULL_MANAGER
     - AGR-001: administrador_usuarios
     - Equivalente directo
   * - R002: USERS_VIEWER
     - AGR-002: visor_usuarios
     - Equivalente directo
   * - R004-R007: REPORTS_*
     - AGR-003: analista_reportes
     - Consolidado
   * - R008-R009: DASHBOARD_*
     - AGR-004: visor_dashboard
     - Consolidado
   * - R011-R014: ALERTS_*
     - AGR-005: gestor_alertas
     - Consolidado
   * - R003: USERS_TEAM_MANAGER
     - AGR-006: supervisor_equipo
     - Renombrado
   * - R017: AUDIT_VIEWER
     - AGR-007: auditor
     - Renombrado
   * - R018: SECURITY_ADMIN
     - AGR-008: admin_seguridad
     - Renombrado
   * - R016: SYSTEM_ADMIN
     - AGR-009: admin_sistema
     - Renombrado
   * - (nuevo)
     - AGR-010: operador_etl
     - Nuevo en v5.1.1

----

4. Flujos
---------

4.1 Flujo Normal (Happy Path)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El flujo normal describe la secuencia de pasos cuando TODO sale bien.

**Caracteristicas:**

- Secuencia exitosa de principio a fin
- Sin errores ni excepciones
- Representa el 80% de las ejecuciones tipicas

**Formato de pasos:**

.. code-block:: text

   N. [Actor|Sistema] [verbo] [objeto] [complemento opcional]

   Ejemplos:
   1. Usuario ingresa credenciales de acceso
   2. Sistema valida formato de email
   3. Sistema verifica credenciales contra base de datos
   4. Sistema genera token JWT
   5. Sistema redirige a dashboard principal

4.2 Flujos Alternos
^^^^^^^^^^^^^^^^^^^

Los flujos alternos son variaciones VALIDAS del flujo normal.

**Caracteristicas:**

- Caminos alternativos pero exitosos
- Decisiones del usuario o condiciones del sistema
- Se reincorporan al flujo normal

**Formato:**

.. code-block:: text

   FLUJO ALTERNO Na: [Nombre descriptivo]
     Na.1. [Condicion que dispara el alterno]
     Na.2. [Paso alternativo]
     Na.3. Retorna a paso N+1 del flujo normal

4.3 Excepciones
^^^^^^^^^^^^^^^

Las excepciones son situaciones de ERROR que impiden completar el objetivo.

**Caracteristicas:**

- Condiciones de error o fallo
- Caso de uso NO se completa exitosamente
- Sistema debe manejar gracefully

**Formato:**

.. code-block:: text

   EXCEPCION Ea: [Nombre del error]
     Ea.1. [Condicion de error detectada]
     Ea.2. Sistema [accion de manejo]
     Ea.3. Caso de uso termina

----

5. Tecnicas de Identificacion de UC
-----------------------------------

5.1 Las 5 Tecnicas
^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 10 25 15 50

   * - #
     - Tecnica
     - % UC
     - Descripcion
   * - 1
     - Desde BR
     - 22%
     - BR tipo Desencadenador genera UC
   * - 2
     - CRUD sobre Entidades
     - 40%
     - Crear, Leer, Actualizar, Eliminar
   * - 3
     - Metodo Larman
     - 22%
     - Eventos del sistema y respuestas
   * - 4
     - UI-Driven
     - 11%
     - Desde mockups y pantallas
   * - 5
     - Stakeholders
     - 5%
     - Entrevistas y workshops

5.2 Resultado de Aplicacion en IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   TECNICA                 UC IDENTIFICADOS    PORCENTAJE
   ─────────────────────────────────────────────────────────
   CRUD sobre Entidades        20               41%
   Desde BR                    11               22%
   Metodo Larman               11               22%
   UI-Driven                    5               10%
   Stakeholders                 2                4%
   ─────────────────────────────────────────────────────────
   TOTAL                       49              100%
