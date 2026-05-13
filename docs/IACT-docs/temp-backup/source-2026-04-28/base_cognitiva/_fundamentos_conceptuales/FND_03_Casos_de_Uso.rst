.. meta::
   :artefacto: FND_03
   :tipo: Fundamento Conceptual
   :dominio: base_cognitiva
   :subdominio: _fundamentos_conceptuales
   :estado: Aprobado
   :version: 1.2.0
   :fecha_creacion: 2025-12-19
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _fnd-03:

====================
FND_03: Casos de Uso
====================


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
     - UC-043: Configurar SoD
     - FR-043.1: Sistema DEBE mostrar lista SoD

**Analogia:**

.. code-block:: text

   CASO DE USO = PLANO ARQUITECTONICO
     - Muestra habitaciones, distribucion, flujo
     - Alto nivel, comprensible por cliente
     - No especifica tamano de cada ladrillo

   REQUISITO FUNCIONAL = ESPECIFICACION DE CONSTRUCCION
     - Ladrillo debe ser de 10cm x 20cm
     - Bajo nivel, comprensible por constructor
     - Cada especificacion es verificable

   AMBOS SE NECESITAN:
     - Plano sin especificaciones: Constructor adivina
     - Especificaciones sin plano: No sabe como ensamblar

----

2. Estructura de un Caso de Uso
-------------------------------

2.1 Componentes Obligatorios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-NNN: [Nombre del Caso de Uso]

   IDENTIFICACION:
     ID:              UC-NNN
     Nombre:          [Verbo + Objeto]
     Actor Primario:  [Agrupador RBAC que inicia]
     Actores Secundarios: [Otros agrupadores involucrados]

   CONTEXTO:
     Objetivo:        [Meta del actor]
     Precondiciones:  [Que debe ser verdad ANTES]
     Postcondiciones: [Que sera verdad DESPUES - exito]
     Trigger:         [Evento que inicia el UC]

   FLUJOS:
     Flujo Normal:    [Pasos 1, 2, 3... secuencia exitosa]
     Flujos Alternos: [Variaciones del flujo normal]
     Excepciones:     [Errores y como manejarlos]

   TRAZABILIDAD:
     Business Rules:  [BR que aplican]
     BReq:            [Objetivo de negocio]
     FR Derivados:    [FR que se generan de este UC]

2.2 Ejemplo Completo
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-043: Configurar SoD

   IDENTIFICACION:
     ID:              UC-043
     Nombre:          Configurar Segregacion de Funciones
     Actor Primario:  AGR-008 (admin_seguridad)
     Actores Secundarios: AGR-007 (auditor)

   CONTEXTO:
     Objetivo:        Crear restricciones SoD para prevenir conflictos
     Precondiciones:
       - Usuario autenticado con agrupador AGR-008
       - Existen funciones definidas en catalogo RBAC
     Postcondiciones:
       - Restriccion SoD creada en sistema
       - Evento registrado en auditoria
       - Administradores notificados
     Trigger:         Admin selecciona Gestionar SoD

   FLUJO NORMAL:
     1. Admin Seguridad selecciona Gestionar SoD
     2. Sistema muestra lista de restricciones actuales
     3. Admin selecciona Crear nueva restriccion
     4. Sistema muestra formulario de configuracion
     5. Admin define nombre de la restriccion
     6. Admin selecciona funciones para Grupo A
     7. Admin selecciona funciones para Grupo B
     8. Sistema valida que no hay conflictos existentes
     9. Admin confirma creacion
    10. Sistema guarda restriccion SoD
    11. Sistema registra en auditoria
    12. Sistema notifica a administradores

   FLUJO ALTERNO 8a: Conflicto con usuarios existentes
     8a.1. Sistema detecta usuarios que violarian nueva SoD
     8a.2. Sistema muestra lista de usuarios afectados
     8a.3. Sistema impide guardar hasta resolver
     8a.4. Retorna a paso 6

   EXCEPCION 1: Sin permisos
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
     - Persona con agrupador especifico
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

3.4 Actores en IACT (Agrupadores RBAC v5.1.1)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los actores en IACT corresponden a los 10 Agrupadores del modelo RBAC v5.1.1,
siguiendo la filosofia Sin Pretensiones:

.. code-block:: text

   AGRUPADOR                           FUNCIONES              UC TIPICOS
                                                                        
   AGR-001: administrador_usuarios     USR-001 a USR-010      UC-006 a UC-009
   AGR-002: visor_usuarios             USR-005, USR-006       UC-009
   AGR-003: analista_reportes          RPT-001 a RPT-008      UC-017 a UC-024
   AGR-004: visor_dashboard            RPT-001, RPT-007/08    UC-025 a UC-030
   AGR-005: gestor_alertas             ALR-001 a ALR-006      UC-036 a UC-040
   AGR-006: supervisor_equipo          USR-005/06, RPT-001    UC-009, UC-017
   AGR-007: auditor                    AUD-001 a AUD-004      UC-060 a UC-063
   AGR-008: admin_seguridad            ACC-001 a ACC-006      UC-010, UC-043-047
   AGR-009: admin_sistema              PIP-*, LOG-*, config   UC-050-053, UC-070-072
   AGR-010: operador_etl               PIP-001 a PIP-004      UC-050 a UC-053

   ACTOR ESPECIAL:
     - TIEMPO: Para procesos batch (ETL nocturno) - UC-050

3.5 Mapeo de Actores Legacy a Agrupadores
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para compatibilidad con documentacion anterior que usaba roles R001-R018:

.. list-table::
   :header-rows: 1
   :widths: 35 35 30

   * - Rol Legacy (R00x)
     - Agrupador (AGR-00x)
     - Nota
   * - R001: USERS_FULL_MANAGER
     - AGR-001: administrador_usuarios
     - Equivalente directo
   * - R002: USERS_VIEWER
     - AGR-002: visor_usuarios
     - Equivalente directo
   * - R003: USERS_TEAM_MANAGER
     - AGR-006: supervisor_equipo
     - Renombrado
   * - R004-R007: REPORTS_*
     - AGR-003: analista_reportes
     - Consolidado
   * - R008-R009: DASHBOARD_*
     - AGR-004: visor_dashboard
     - Consolidado
   * - R010: DATA_ANALYST
     - AGR-003: analista_reportes
     - Absorbido
   * - R011-R014: ALERTS_*
     - AGR-005: gestor_alertas
     - Consolidado
   * - R015: MODULES_ADMIN
     - AGR-009: admin_sistema
     - Consolidado
   * - R016: SYSTEM_ADMIN
     - AGR-009: admin_sistema
     - Renombrado
   * - R017: AUDIT_VIEWER
     - AGR-007: auditor
     - Renombrado
   * - R018: SECURITY_ADMIN
     - AGR-008: admin_seguridad
     - Renombrado
   * - (nuevo)
     - AGR-010: operador_etl
     - Nuevo en RBAC v5.1.1

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

Las excepciones son situaciones de ERROR que impiden completar el UC.

**Caracteristicas:**

- El objetivo NO se cumple
- Requiere manejo especial
- Puede terminar el UC o permitir reintento

**Formato:**

.. code-block:: text

   EXCEPCION N: [Nombre del error]
     N.1. [Condicion de error]
     N.2. Sistema muestra mensaje de error
     N.3. [Accion: termina UC | permite reintento]

----

5. Tecnicas de Identificacion de UC
-----------------------------------

Existen cinco tecnicas complementarias para identificar Casos de Uso.

.. important::

   **GAP Fundamental BR vs Sistema Completo:**

   Las Business Rules solo generan aproximadamente el 22% de los UC totales.
   El 78% restante debe identificarse mediante tecnicas complementarias.

5.1 Tecnica 1: Derivacion desde Business Rules (22%)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Las Business Rules de tipo Desencadenador (Trigger) generan UC directamente.

.. code-block:: text

   BR (Trigger): SI quimico vence en 30 dias,
                 ENTONCES notificar al responsable
       |
       v
   UC-xxx: Notificar Vencimiento Proximo

   PORCENTAJE: 22% de los UC totales
   NATURALEZA: Deductiva (BR explicita -> UC)

5.2 Tecnica 2: Analisis CRUD (40%)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para cada entidad del dominio, considerar operaciones basicas segun su clasificacion.

**Clasificacion de Entidades:**

.. list-table::
   :header-rows: 1
   :widths: 25 35 40

   * - Tipo Entidad
     - UC Generados
     - Ejemplo
   * - Maestro
     - CRUD completo (6 UC)
     - Usuario, Rol, Centro
   * - Transaccional
     - C + R solamente (3 UC)
     - Llamada, Auditoria, Sesion
   * - Tecnica
     - Sin UC directos
     - ConfiguracionSistema, Log

5.3 Tecnica 3: Modelo de Larman - Eventos del Sistema (22%)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Identificar eventos externos que requieren respuesta del sistema.

**4 Caracteristicas Obligatorias de un Evento Valido:**

.. code-block:: text

   1. EXTERNO:      Originado fuera del sistema (no interno)
   2. DETECTABLE:   Sistema puede sentir que ocurrio
   3. SIGNIFICATIVO: Tiene relevancia en el dominio de negocio
   4. ATOMICO:      Ocurrencia puntual e indivisible en el tiempo

5.4 Tecnica 4: Analisis de Interfaz UI-Driven (11%)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Identificar UC a partir de mockups, wireframes o necesidades de UI.

.. code-block:: text

   APLICA A:
   - Dashboards y visualizaciones complejas
   - Busquedas avanzadas con multiples filtros
   - Acciones en lote (batch operations)
   - Wizards multi-paso

5.5 Tecnica 5: Requerimientos Directos de Stakeholders (5%)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

UC que provienen de necesidades explicitas no capturadas como BR.

.. code-block:: text

   APLICA A:
   - Requisitos de compliance y auditoria
   - Integraciones con sistemas externos
   - Reporteria especifica de BI
   - Administracion tecnica del sistema

5.6 Matriz de Cobertura Completa
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   COBERTURA TOTAL:

   +----------------------------------+------------+--------------+
   | Tecnica                          | Porcentaje | UC Tipicos   |
   +----------------------------------+------------+--------------+
   | 1. Business Rules (Deductiva)    |    22%     | 11 UC        |
   | 2. CRUD (Inductiva)              |    40%     | 20 UC        |
   | 3. Larman/Eventos (Inductiva)    |    22%     | 11 UC        |
   | 4. UI-Driven (Inductiva)         |    11%     |  5 UC        |
   | 5. Stakeholders (Inductiva)      |     5%     |  2 UC        |
   +----------------------------------+------------+--------------+
   | TOTAL                            |   100%     | 49 UC        |
   +----------------------------------+------------+--------------+

----

6. Contratos de Operacion
-------------------------

6.1 Definicion
^^^^^^^^^^^^^^

Un **contrato de operacion** describe QUE debe lograr una operacion del
sistema, sin especificar COMO lo hace. Define precondiciones y postcondiciones.

6.2 Formato
^^^^^^^^^^^

.. code-block:: text

   Operacion: nombreOperacion(parametros)

   Precondiciones:
     - [Condicion que DEBE ser verdad ANTES]

   Postcondiciones:
     - [Estado que SERA verdad DESPUES]

6.3 Relacion UC - Contrato
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Caso de Uso: Define COMO interactua usuario con sistema
   Contrato:    Define QUE debe pasar tecnicamente

   UC es mas NARRATIVO (flujo de trabajo)
   Contrato es mas TECNICO (cambios de estado)

----

7. Casos de Uso en el Contexto IACT
-----------------------------------

7.1 Nomenclatura
^^^^^^^^^^^^^^^^

Los Casos de Uso en IACT siguen la convencion:

.. code-block:: text

   FORMATO: UC_NNN_Nombre_Descriptivo.rst

   Donde:
   - UC: Prefijo fijo (Use Case)
   - NNN: Numero secuencial de 3 digitos
   - Nombre_Descriptivo: Verbo + Objeto con guiones bajos

   Ejemplos:
   - UC_006_Crear_Usuario.rst
   - UC_043_Configurar_SoD.rst
   - UC_050_Supervisar_ETL.rst

7.2 Ubicacion en el Modelo IACT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   requisitos/
       +--- casos_uso/
                +--- index.rst
                +--- auth/
                +--- users/
                +--- access/
                +--- pipeline/
                +--- reports/
                +--- alerts/
                +--- audit/
                +--- logs/

7.3 Relacion con Otros Artefactos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   BReq (Objetivo de Negocio)
       |
       | genera
       v
   UC (Caso de Uso) <---- BR tipo Trigger tambien genera
       |
       | deriva
       v
   FR (Requisito Funcional) <---- Cada paso Sistema deriva FR

----

8. Lista de UC Identificados en IACT (49 UC)
--------------------------------------------

Basado en el analisis del modelo RBAC v5.1.1, se han identificado 49 Casos de Uso
distribuidos en 8 modulos funcionales.

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

8.5 Reportes y Dashboards - MOD_Reports (14 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

8.8 Bitacoras - MOD_Logs (4 UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   UC-070: Consultar Logs del Sistema
   UC-071: Filtrar Logs por Criterios
   UC-072: Exportar Logs
   UC-073: Configurar Retencion de Logs

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
     - 4
     - UC-070 a UC-073
   * - **TOTAL**
     - **49**
     - --

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- FND_01 - Concepto de Requisito
- FND_02 - Reglas de Negocio
- FND_04 - Trazabilidad
- FND_05 - Jerarquia de 4 Niveles
- FND_07 - Requerimientos Funcionales

Modelos IACT
^^^^^^^^^^^^

- MODELO_RBAC_IACT_v5.1.1 - Modelo de control de acceso
- MODELO_DOCUMENTAL_IACT_v2.0.7 - Estructura documental

Fuentes Externas
^^^^^^^^^^^^^^^^

- Craig Larman: Applying UML and Patterns (3rd Edition)
- Alistair Cockburn: Writing Effective Use Cases
- Ivar Jacobson: Object-Oriented Software Engineering

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
     - 2026-01-04
     - Equipo IACT
     - Lista de UC actualizada de 38 a 49. Actores cambiados de R00x a AGR-00x (Agrupadores RBAC v5.1.1). Agregados modulos Auth, Pipeline, Audit, Logs. Mapeo de actores legacy incluido. Reorganizacion de UC por modulos.
   * - 1.1.0
     - 2025-12-21
     - Equipo IACT
     - Corregidos porcentajes de tecnicas UC (22/40/22/11/5). Agregadas tecnicas 4 (UI-Driven) y 5 (Stakeholders). Documentado GAP 22%/78%. Agregada clasificacion de entidades.
   * - 1.0.0
     - 2025-12-19
     - Equipo IACT
     - Version inicial aprobada

----

Trazabilidad: Este artefacto define el concepto de UC que es el Nivel 2
en la jerarquia de requisitos (BReq -> UC -> FR). Referenciado por FND_04,
FND_05, FND_06, FND_07 y todos los artefactos en requisitos/casos_uso/.
