.. meta::
   :artefacto: GOB_02
   :tipo: Matriz
   :dominio: normativa
   :subdominio: gobernanza
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _gob-02:

===========================
GOB_02: Roles y Matriz RACI
===========================


Proposito
---------

Este documento define el **catalogo completo de roles** del sistema IACT
y establece la **matriz RACI** que asigna responsabilidades claras para
cada tipo de artefacto y proceso del sistema documental.

.. important::

   **Pregunta Clave que Responde:**

   "¿Quien es responsable de que en este proyecto?"

----

1. Modelo RBAC del Sistema IACT
-------------------------------

1.1 Tipo de Modelo
^^^^^^^^^^^^^^^^^^

El sistema IACT implementa **Flat RBAC** (NIST):

.. code-block:: text

   CARACTERISTICAS:
   - Roles independientes sin jerarquia automatica
   - Sin herencia de permisos entre roles
   - Permisos explicitos por rol
   - Un usuario puede tener multiples roles
   - Permisos se acumulan (operacion UNION)

1.2 Arquitectura de Seguridad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ┌─────────────────────────────────────────────────────┐
   │                     USUARIOS                        │
   └─────────────────────────────────────────────────────┘
                           │
                           │ N:N
                           ▼
   ┌─────────────────────────────────────────────────────┐
   │                      ROLES                          │
   │  (17 roles funcionales - sin Analisis Avanzado)     │
   └─────────────────────────────────────────────────────┘
                           │
                           │ 1:N
                           ▼
   ┌─────────────────────────────────────────────────────┐
   │                    PERMISOS                         │
   └─────────────────────────────────────────────────────┘
                           │
                           ▼
   ┌─────────────────────────────────────────────────────┐
   │                  FUNCIONES                          │
   │  (Modulos del sistema)                              │
   └─────────────────────────────────────────────────────┘

----

2. Catalogo de Roles Funcionales
--------------------------------

2.1 Resumen por Categoria
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 10 20 40

   * - Categoria
     - Roles
     - Usuarios Est.
     - Descripcion
   * - Gestion de Usuarios
     - 3
     - 27-48
     - Administracion de cuentas y permisos
   * - Reportes
     - 4
     - 95-180
     - Visualizacion y exportacion de reportes
   * - Visualizacion
     - 2
     - 70-140
     - Dashboards y graficos
   * - Alertas
     - 4
     - 57-108
     - Notificaciones y umbrales
   * - Administracion
     - 4
     - 6-12
     - Sistema, seguridad, auditoria
   * - **TOTAL**
     - **17**
     - **255-488**
     - \\-

.. note::

   **Exclusiones:** El rol R010 (DATA_ANALYST) y la categoria de Analisis
   Avanzado (Exploratorio, Comparativo, Patrones) no aplican al alcance
   actual del proyecto IACT.

----

2.2 Categoria 1: Gestion de Usuarios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**R001 - USERS_FULL_MANAGER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Administra usuarios, roles, permisos y segmentos de datos
   * - Capacidades
     - Crea, modifica, desactiva usuarios. Asigna roles. Resetea contraseñas. Administra segmentos.
   * - Usuarios Est.
     - 2-3
   * - Perfil Tipico
     - ADMINISTRADOR
   * - SoD
     - Mutuamente excluyente con R017 (AUDIT_VIEWER)

**R002 - USERS_VIEWER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Ve informacion de usuarios sin modificacion
   * - Capacidades
     - Consulta, lista y busca usuarios. Ve roles asignados. Solo lectura.
   * - Usuarios Est.
     - 10-20
   * - Perfil Tipico
     - BASICO, ADMINISTRADOR_SEGMENTO

**R003 - USERS_TEAM_MANAGER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Administra usuarios del mismo segmento de datos
   * - Capacidades
     - Modifica datos basicos de su equipo. Solicita creacion (requiere aprobacion R001).
   * - Usuarios Est.
     - 15-25
   * - Perfil Tipico
     - ADMINISTRADOR_SEGMENTO

----

2.3 Categoria 2: Reportes
^^^^^^^^^^^^^^^^^^^^^^^^^

**R004 - REPORTS_VIEWER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Consulta reportes basicos con filtros estandar
   * - Capacidades
     - Ve reportes trimestrales, transferencias, problemas de menu. Aplica filtros por fecha/centro/DID.
   * - Usuarios Est.
     - 50-100
   * - Perfil Tipico
     - BASICO
   * - Restricciones
     - Solo su segmento. No puede exportar.

**R005 - REPORTS_EXPORTER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Exporta reportes en multiples formatos
   * - Capacidades
     - Todo de R004 + exporta a CSV, Excel, PDF. Limites diarios segun perfil.
   * - Usuarios Est.
     - 30-50
   * - Perfil Tipico
     - BASICO, ANALISTA

**R006 - REPORTS_ADVANCED_VIEWER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Accede a reportes avanzados y ejecutivos
   * - Capacidades
     - Todo de R004 + reportes ejecutivos, tendencias, comparativos.
   * - Usuarios Est.
     - 10-20
   * - Perfil Tipico
     - ANALISTA, ADMINISTRADOR_SEGMENTO

**R007 - REPORTS_CREATOR**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Crea y modifica reportes personalizados
   * - Capacidades
     - Crea reportes con SQL validado. Comparte con otros. Programa generacion automatica.
   * - Usuarios Est.
     - 5-10
   * - Perfil Tipico
     - ANALISTA
   * - Restricciones
     - Solo SELECT. Timeout 5 min. Max 50,000 registros.

----

2.4 Categoria 3: Visualizacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**R008 - DASHBOARD_VIEWER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Ve dashboards estandar sin personalizacion
   * - Capacidades
     - Dashboard principal, graficos por hora/dia, distribucion por centro, tendencias.
   * - Usuarios Est.
     - 50-100
   * - Perfil Tipico
     - BASICO
   * - Widgets
     - 10 widgets predefinidos (llamadas, distribucion, top centros, alertas, etc.)

**R009 - DASHBOARD_CUSTOMIZER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Personaliza dashboards y guarda vistas
   * - Capacidades
     - Todo de R008 + reordena widgets, guarda vistas (max 5), crea dashboards personales.
   * - Usuarios Est.
     - 20-40
   * - Perfil Tipico
     - ANALISTA, ADMINISTRADOR_SEGMENTO

----

2.5 Categoria 4: Alertas y Notificaciones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**R011 - ALERTS_VIEWER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Recibe y visualiza alertas sin configurar
   * - Capacidades
     - Recibe alertas personales. Ve historial. Filtra. Marca leidas. Snooze temporal.
   * - Usuarios Est.
     - 30-60
   * - Perfil Tipico
     - BASICO
   * - Restricciones
     - Solo alertas propias. No configura.

**R012 - ALERTS_CONFIGURATOR**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Configura alertas personales con umbrales
   * - Capacidades
     - Todo de R011 + crea alertas, define umbrales, configura frecuencia y severidad.
   * - Usuarios Est.
     - 15-30
   * - Perfil Tipico
     - ANALISTA
   * - Restricciones
     - Solo alertas personales. Max 20 activas.

**R013 - ALERTS_TEAM_MANAGER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Administra alertas del equipo (mismo segmento)
   * - Capacidades
     - Todo de R012 + asigna alertas a equipo, gestiona destinatarios (max 50).
   * - Usuarios Est.
     - 10-15
   * - Perfil Tipico
     - ADMINISTRADOR_SEGMENTO
   * - Restricciones
     - Solo usuarios de su segmento.

**R014 - ALERTS_GLOBAL_ADMIN**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Administra alertas globales del sistema
   * - Capacidades
     - Todo de R013 + configura alertas globales, broadcast, umbrales por defecto, politicas.
   * - Usuarios Est.
     - 2-3
   * - Perfil Tipico
     - ADMINISTRADOR

----

2.6 Categoria 5: Administracion y Seguridad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**R015 - MODULES_ADMIN**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Administra modulos dinamicos y perfiles
   * - Capacidades
     - Asigna modulos a usuarios. Crea perfiles personalizados. Habilita/deshabilita modulos.
   * - Usuarios Est.
     - 2-3
   * - Perfil Tipico
     - ADMINISTRADOR
   * - Perfiles Predefinidos
     - BASICO, ANALISTA, ADMINISTRADOR_SEGMENTO, ADMINISTRADOR

**R016 - SYSTEM_ADMIN**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Administra configuracion global del sistema
   * - Capacidades
     - Configura sistema, parametros globales, integraciones, mantenimiento.
   * - Usuarios Est.
     - 1-2
   * - Perfil Tipico
     - ADMINISTRADOR
   * - SoD
     - Mutuamente excluyente con R017 (AUDIT_VIEWER)

**R017 - AUDIT_VIEWER**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Ve logs de auditoria del sistema
   * - Capacidades
     - Consulta audit_logs. Genera reportes de auditoria. Exporta logs.
   * - Usuarios Est.
     - 2-4
   * - Perfil Tipico
     - AUDITOR (externo al equipo operativo)
   * - SoD
     - Mutuamente excluyente con R001 y R016

**R018 - SECURITY_ADMIN**

.. list-table::
   :widths: 25 75

   * - Funcion
     - Administra politicas de seguridad
   * - Capacidades
     - Configura politicas de contraseñas, bloqueos, sesiones. Gestiona incidentes.
   * - Usuarios Est.
     - 1-2
   * - Perfil Tipico
     - ADMINISTRADOR

----

3. Separacion de Funciones (SoD)
--------------------------------

3.1 Roles Mutuamente Excluyentes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 25 25 50

   * - Rol A
     - Rol B
     - Razon
   * - R016 (SYSTEM_ADMIN)
     - R017 (AUDIT_VIEWER)
     - Quien opera NO debe auditar
   * - R001 (USERS_FULL_MANAGER)
     - R017 (AUDIT_VIEWER)
     - Quien gestiona usuarios NO debe auditar

3.2 Justificacion
^^^^^^^^^^^^^^^^^

.. code-block:: text

   PRINCIPIO: Independencia de Auditoria

   - El auditor debe ser independiente de operaciones
   - Previene encubrimiento de acciones indebidas
   - Garantiza objetividad en revision de logs
   - Cumplimiento con estandares de seguridad

3.3 Validacion del Sistema
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Al asignar roles mutuamente excluyentes:

   1. Sistema detecta conflicto SoD
   2. Muestra advertencia explicita
   3. Requiere justificacion (min 20 caracteres)
   4. Requiere aprobacion de R001 o R018
   5. Registra excepcion en audit_logs

----

4. Perfiles de Modulos
----------------------

4.1 Perfiles Predefinidos
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Perfil
     - Roles Tipicos
     - Modulos Incluidos
   * - BASICO
     - R004, R008, R011
     - Dashboard Principal, Mi Perfil, Reportes Basicos
   * - ANALISTA
     - R005-R007, R009, R012
     - + Reportes Avanzados, Dashboards Personalizados, Exportacion
   * - ADMINISTRADOR_SEGMENTO
     - R003, R006, R009, R013
     - + Gestion Equipo, Alertas Equipo
   * - ADMINISTRADOR
     - R001, R014-R016, R018
     - Todos los modulos

4.2 Modulos del Sistema
^^^^^^^^^^^^^^^^^^^^^^^

**Categoria: Basicos**

- Dashboard Principal (obligatorio)
- Mi Perfil (obligatorio)
- Reportes Basicos

**Categoria: Reportes**

- Reportes Avanzados (requiere: Reportes Basicos)
- Reportes Personalizados (requiere: Reportes Basicos)
- Reportes Ejecutivos
- Reportes Operativos

**Categoria: Visualizacion**

- Dashboards Estandar
- Dashboards Personalizados (requiere: Dashboards Estandar)

**Categoria: Exportacion**

- Exportacion Basica (CSV, Excel)
- Exportacion Avanzada (PDF)

**Categoria: Alertas**

- Alertas Basicas
- Configuracion de Alertas (requiere: Alertas Basicas)
- Alertas de Equipo (requiere: Configuracion de Alertas)

**Categoria: Administracion**

- Gestion de Usuarios
- Gestion de Modulos
- Configuracion del Sistema
- Auditoria

.. note::

   **Modulos Excluidos:** Analisis Exploratorio, Analisis Comparativo,
   Analisis de Patrones no estan disponibles en el alcance actual.

----

5. Matriz RACI - Artefactos Documentales
----------------------------------------

5.1 Leyenda RACI
^^^^^^^^^^^^^^^^

.. code-block:: text

   R = Responsible (Ejecuta el trabajo)
   A = Accountable (Rinde cuentas, aprueba)
   C = Consulted   (Se consulta antes de decidir)
   I = Informed    (Se informa despues de decidir)

5.2 Matriz por Tipo de Artefacto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 22 13 13 13 13 13 13

   * - Artefacto
     - PMO
     - Arq Doc
     - BA Lead
     - Tech Lead
     - Dev
     - QA
   * - **META_** (Metadata)
     - A
     - R
     - C
     - I
     - I
     - I
   * - **GLOS_** (Glosario)
     - A
     - R
     - C
     - C
     - I
     - I
   * - **FND_** (Fundamentos)
     - A
     - R
     - C
     - C
     - I
     - I
   * - **SBVR_** (Ontologia)
     - A
     - R
     - C
     - C
     - I
     - I
   * - **TXM_** (Taxonomias)
     - A
     - R
     - C
     - C
     - I
     - I
   * - **MTM_** (Metamodelos)
     - A
     - R
     - C
     - C
     - I
     - I
   * - **GOB_** (Gobernanza)
     - R/A
     - C
     - I
     - I
     - I
     - I
   * - **STD_** (Estandares)
     - A
     - R
     - C
     - C
     - C
     - C
   * - **PROC_** (Procedimientos)
     - A
     - R
     - C
     - C
     - I
     - C
   * - **CNST_** (Restricciones)
     - A
     - C
     - C
     - R
     - C
     - I
   * - **BR_** (Reglas Negocio)
     - A
     - C
     - R
     - I
     - I
     - I
   * - **UC_** (Casos de Uso)
     - A
     - C
     - R
     - C
     - I
     - C
   * - **FR_** (Funcionales)
     - I
     - C
     - R
     - C
     - C
     - C
   * - **NFR_** (No Funcionales)
     - I
     - C
     - R
     - R
     - C
     - C
   * - **ADR_** (Decisiones Arq)
     - I
     - A
     - C
     - R
     - C
     - I
   * - **RTM_** (Trazabilidad)
     - A
     - C
     - R
     - C
     - I
     - C

----

6. Matriz RACI - Procesos de Gobernanza
---------------------------------------

6.1 Procesos Estructurales
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 14 14 14 14 14

   * - Proceso
     - PMO
     - Arq Doc
     - Owner Dom
     - Tech Lead
     - Sponsor
   * - Crear Dominio
     - A
     - R
     - C
     - C
     - A
   * - Crear Subdominio
     - A
     - R
     - R
     - C
     - I
   * - Descongelar Subdominio
     - A
     - R
     - R
     - C
     - I
   * - Recongelar Subdominio
     - A
     - R
     - R
     - C
     - I
   * - Crear Seccion
     - I
     - C
     - R
     - I
     - I

6.2 Procesos de Artefactos
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 14 14 14 14 14

   * - Proceso
     - PMO
     - Owner Dom
     - Autor
     - Revisor
     - QA
   * - Crear Artefacto
     - I
     - I
     - R
     - C
     - I
   * - Revisar Artefacto
     - I
     - C
     - I
     - R
     - C
   * - Aprobar Artefacto
     - A
     - R
     - I
     - I
     - I
   * - Modificar Artefacto
     - I
     - C
     - R
     - C
     - I
   * - Obsoleter Artefacto
     - A
     - R
     - C
     - I
     - I

6.3 Procesos de Control
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 14 14 14 14 14

   * - Proceso
     - PMO
     - Arq Doc
     - Owner Dom
     - Auditor
     - QA
   * - Cambio de Version
     - I
     - C
     - R
     - I
     - I
   * - Cambio de Clasificacion
     - A
     - C
     - R
     - I
     - I
   * - Auditoria de Cumplimiento
     - A
     - C
     - I
     - R
     - C
   * - Verificacion de Trazabilidad
     - I
     - C
     - C
     - C
     - R

----

7. Asignacion de Roles a Funciones Documentales
-----------------------------------------------

7.1 Roles vs Funciones RACI
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Rol RACI
     - Roles RBAC Correspondientes
   * - PMO
     - R001, R014, R016
   * - Arquitecto Doc
     - R015, R016
   * - BA Lead
     - R003 (segmento requisitos), R006, R007
   * - Tech Lead
     - R003 (segmento arquitectura), R016
   * - Developer
     - R004, R005, R008
   * - QA
     - R002, R004, R017
   * - Auditor
     - R017 (exclusivo)
   * - Owner Dominio
     - Variable segun dominio (ver seccion 3.3 de GOB_01)

----

8. Reglas de Asignacion de Roles
--------------------------------

8.1 Principio de Minimo Privilegio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA: Asignar solo los roles necesarios para la funcion

   EJEMPLO CORRECTO:
   Usuario necesita: Ver reportes basicos
   Rol asignado: R004 (REPORTS_VIEWER)

   EJEMPLO INCORRECTO:
   Usuario necesita: Ver reportes basicos
   Rol asignado: R006 (REPORTS_ADVANCED_VIEWER)
   --> Viola minimo privilegio

8.2 Acumulacion de Permisos
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA: Los permisos se acumulan (UNION)

   Usuario: juan.perez123
   Roles:
     - R004 (REPORTS_VIEWER)
     - R005 (REPORTS_EXPORTER)
     - R012 (ALERTS_CONFIGURATOR)

   Permisos resultantes: UNION de todos
   - Puede ver reportes (R004)
   - Puede exportar reportes (R005)
   - Puede configurar alertas personales (R012)

8.3 Revision Periodica
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FRECUENCIA: Trimestral

   CHECKLIST DE REVISION:
   [ ] Usuario sigue activo en la organizacion
   [ ] Funcion actual requiere los roles asignados
   [ ] No hay roles redundantes
   [ ] No hay violaciones de SoD
   [ ] Ultimo acceso < 90 dias (si no, investigar)

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`gob-01` - Modelo de Gobernanza IACT
- :ref:`gob-03` - Control de Calidad Documental
- :ref:`meta-02` - Clasificacion Documental
- Modelo RBAC Completo v0.0.1 - Documento fuente

Fuentes Externas
^^^^^^^^^^^^^^^^

- NIST RBAC Model - Flat RBAC
- ISO 27001 - Gestion de Seguridad de la Informacion

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
     - 2025-12-22
     - Equipo IACT
     - Version inicial. Catalogo de 17 roles (excluye R010 DATA_ANALYST). Matriz RACI para artefactos y procesos. Reglas SoD y asignacion.

----

**Trazabilidad:** Este artefacto define la asignacion de responsabilidades
para todos los artefactos y procesos del sistema documental IACT. Es
referenciado por GOB_03 (Control de Calidad) y GOB_04 (Gestion de Cambios)
para determinar aprobadores y revisores.