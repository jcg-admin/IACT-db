.. meta::
   :artefacto: FND_03
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.2.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-03:

==============================================================================
FND_03: Casos de Uso
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Proposito
---------

Este documento define QUE ES un Caso de Uso (Use Case) en el contexto del
proyecto IACT, su estructura, componentes y relacion con otros artefactos
de requisitos.

----

1. Definicion Formal
--------------------

1.1 Que es un Caso de Uso
^^^^^^^^^^^^^^^^^^^^^^^^^

Un **Caso de Uso (Use Case - UC)** es una descripcion de una secuencia de
interacciones entre un actor y el sistema para lograr un objetivo especifico.
Describe comportamientos del sistema desde la perspectiva del usuario.

.. note::

   **Definicion operativa para IACT:**

   Un UC es una narrativa que describe COMO un usuario interactua con el
   sistema para completar una tarea de negocio, incluyendo el flujo normal
   y los flujos alternativos.

1.2 Caracteristicas de un Caso de Uso
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Caracteristica
     - Descripcion
   * - **Narrativo**
     - Cuenta una historia: "El usuario hace X, sistema responde Y"
   * - **Alto nivel**
     - Describe interaccion completa, no detalles atomicos
   * - **Orientado a actor**
     - Perspectiva del usuario, no del sistema
   * - **Secuencial**
     - Pasos ordenados en flujo temporal
   * - **Contextualizado**
     - Incluye precondiciones y postcondiciones
   * - **Multi-camino**
     - Flujo normal mas flujos alternativos

1.3 UC vs FR: Diferencia Fundamental
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Caso de Uso (UC)
     - Requisito Funcional (FR)
   * - Vista
     - Narrativa (historia)
     - Atomica (declaracion)
   * - Nivel
     - Alto (interaccion completa)
     - Bajo (comportamiento especifico)
   * - Orientacion
     - Actor (usuario)
     - Sistema (implementacion)
   * - Dependencia
     - Secuencia importa
     - Independiente
   * - Verificacion
     - Escenario end-to-end
     - Test unitario/aislado
   * - Ejemplo
     - "UC-043: Configurar SoD"
     - "FR-043.1: Sistema DEBE mostrar lista SoD"

----

2. Estructura de un Caso de Uso
-------------------------------

2.1 Template Estandar IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ============================================================
   UC-NNN: Nombre del Caso de Uso
   ============================================================

   METADATA:
     ID:              UC-NNN
     Nombre:          [Titulo descriptivo]
     Actor Primario:  [Agrupador RBAC]
     Prioridad:       Alta | Media | Baja
     Estado:          Borrador | Aprobado | Implementado
     Version:         X.Y.Z

   DESCRIPCION:
     [Parrafo que explica el objetivo del caso de uso]

   PRECONDICIONES:
     1. [Condicion que debe cumplirse antes de iniciar]
     2. [Otra condicion]

   POSTCONDICIONES (Exito):
     1. [Estado del sistema despues de ejecucion exitosa]
     2. [Otro resultado esperado]

   FLUJO NORMAL:
     1. Actor [accion]
     2. Sistema [respuesta]
     3. Actor [accion]
     4. Sistema [respuesta]
     ...

   FLUJOS ALTERNOS:
     [Na]: [Nombre del alterno]
       Na.1. [Condicion]
       Na.2. [Accion alternativa]
       Na.3. Retorna a paso N

   EXCEPCIONES:
     [Ea]: [Nombre de la excepcion]
       Ea.1. [Condicion de error]
       Ea.2. Sistema [manejo del error]
       Ea.3. Caso de uso termina

   TRAZABILIDAD:
     Business Rules:  [BR_NNN]
     BReq:            [BReq-NNN]
     FR Derivados:    [FR-NNN.1 a FR-NNN.N]

2.2 Ejemplo Completo
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ============================================================
   UC-043: Configurar SoD
   ============================================================

   METADATA:
     ID:              UC-043
     Nombre:          Configurar Segregacion de Funciones
     Actor Primario:  AGR-008 (admin_seguridad)
     Prioridad:       Alta
     Estado:          Aprobado
     Version:         1.0.0

   DESCRIPCION:
     Permite al administrador de seguridad crear, modificar o
     eliminar restricciones de Segregacion de Funciones (SoD)
     que impiden asignar funciones conflictivas a un usuario.

   PRECONDICIONES:
     1. Usuario autenticado con AGR-008 (admin_seguridad)
     2. Existen funciones definidas en catalogo RBAC

   POSTCONDICIONES (Exito):
     1. Restriccion SoD creada/modificada en sistema
     2. Evento registrado en auditoria
     3. Administradores notificados

   FLUJO NORMAL:
     1. Admin Seguridad selecciona "Gestionar SoD"
     2. Sistema muestra lista de restricciones actuales
     3. Admin selecciona "Crear nueva restriccion"
     4. Sistema muestra formulario de configuracion
     5. Admin define nombre de la restriccion
     6. Admin selecciona funciones para Grupo A
     7. Admin selecciona funciones para Grupo B
     8. Sistema valida que no hay conflictos existentes
     9. Admin confirma creacion
    10. Sistema guarda restriccion SoD
    11. Sistema registra en auditoria
    12. Sistema notifica a administradores

   FLUJOS ALTERNOS:
     3a: Modificar restriccion existente
       3a.1. Admin selecciona restriccion de la lista
       3a.2. Sistema muestra formulario con datos actuales
       3a.3. Retorna a paso 5

     3b: Eliminar restriccion
       3b.1. Admin selecciona restriccion y "Eliminar"
       3b.2. Sistema solicita confirmacion
       3b.3. Admin confirma eliminacion
       3b.4. Sistema elimina restriccion
       3b.5. Retorna a paso 11

   EXCEPCIONES:
     8a: Conflicto con usuarios existentes
       8a.1. Sistema detecta usuarios que violarian nueva SoD
       8a.2. Sistema muestra lista de usuarios afectados
       8a.3. Sistema impide guardar hasta resolver
       8a.4. Retorna a paso 6

     1a: Sin permisos
       1a.1. Sistema detecta falta de AGR-008
       1a.2. Sistema muestra mensaje de acceso denegado
       1a.3. Caso de uso termina

   TRAZABILIDAD:
     Business Rules:  BR_007 (Separacion de Funciones SoD)
     BReq:            BReq-004 (Cumplimiento Seguridad)
     FR Derivados:    FR-043.1 a FR-043.5

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

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`fnd-01` - Concepto de Requisito
- :ref:`fnd-02` - Reglas de Negocio
- :ref:`fnd-04` - Trazabilidad
- :ref:`fnd-05` - Jerarquia de 4 Niveles
- :ref:`fnd-07` - Requerimientos Funcionales

Modelos IACT
^^^^^^^^^^^^

- MODELO_RBAC_IACT_v5.1.1 - Modelo de control de acceso
- MODELO_DOCUMENTAL_IACT_v2.0.6 - Estructura documental

Fuentes Externas
^^^^^^^^^^^^^^^^

- Craig Larman: "Applying UML and Patterns" (3rd Edition)
- Alistair Cockburn: "Writing Effective Use Cases"
- Ivar Jacobson: "Object-Oriented Software Engineering"

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
   * - 1.2.0
     - 2026-01-03
     - Equipo IACT
     - **ACTUALIZACION MAYOR:** Lista de UC actualizada de 38 a 49. Actores cambiados de R00x a AGR-00x (Agrupadores RBAC v5.1.1). Agregados modulos Auth, Pipeline, Audit, Logs. Mapeo de actores legacy incluido. Tecnicas UC actualizadas con porcentajes corregidos.
   * - 1.1.0
     - 2025-12-21
     - Equipo IACT
     - Corregidos porcentajes de tecnicas UC (22/40/22/11/5). Agregadas tecnicas 4 (UI-Driven) y 5 (Stakeholders). Documentado GAP 22%/78%. Agregada clasificacion de entidades. Agregadas caracteristicas de eventos.
   * - 1.0.0
     - 2025-12-19
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:** Este artefacto define el concepto de UC que es el Nivel 2
en la jerarquia de requisitos (BReq→UC→FR). Referenciado por FND_04, FND_05,
FND_06, FND_07 y todos los artefactos en requisitos/casos_uso/.
