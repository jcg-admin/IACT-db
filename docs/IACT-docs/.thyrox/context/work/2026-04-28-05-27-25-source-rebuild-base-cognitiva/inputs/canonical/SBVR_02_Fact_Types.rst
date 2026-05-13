.. meta::
   :artefacto: SBVR_02
   :tipo: Ontologia SBVR
   :dominio: base_cognitiva
   :subdominio: _ontologia_sbvr
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _sbvr-02:

=====================================
SBVR_02: Fact Types (Tipos de Hechos)
=====================================


Proposito
---------

Este documento define los **Fact Types** (tipos de hechos) del dominio IACT
siguiendo el estandar SBVR. Los Fact Types son las relaciones (verbos) que
conectan los conceptos nucleares definidos en :ref:`sbvr-01`.

.. note::

   **Notacion SBVR:**

   - **Conceptos** (sustantivos) se muestran subrayados: Usuario
   - **Verbos** se muestran en italica: *tiene*
   - **Fact Type** = Concepto + Verbo + Concepto
   - Ejemplo: Usuario *tiene* Rol

----

1. Estructura de un Fact Type
-----------------------------

1.1 Componentes
^^^^^^^^^^^^^^^

Cada Fact Type se documenta con:

.. code-block:: text

   FACT TYPE: [Concepto1] verbo [Concepto2]

   LECTURA DIRECTA:
   "[Concepto1] [verbo] [Concepto2]"

   LECTURA INVERSA:
   "[Concepto2] [verbo pasivo] [Concepto1]"

   CARDINALIDAD:
   [Concepto1] : [Concepto2] = [N:M | 1:N | N:1 | 1:1]

   OBLIGATORIEDAD:
   - [Concepto1]: [obligatorio | opcional]
   - [Concepto2]: [obligatorio | opcional]

1.2 Tipos de Cardinalidad
^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Cardinalidad
     - Significado
     - Ejemplo
   * - 1:1
     - Uno a uno
     - Usuario *inicia* Sesion (activa)
   * - 1:N
     - Uno a muchos
     - Rol *contiene* Permiso
   * - N:1
     - Muchos a uno
     - Usuario *pertenece_a* Segmento
   * - N:N
     - Muchos a muchos
     - Usuario *tiene* Rol

----

2. Fact Types de Seguridad
--------------------------

2.1 Usuario tiene Rol
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Usuario tiene Rol

   LECTURA DIRECTA:
   "Usuario tiene Rol"

   LECTURA INVERSA:
   "Rol es asignado a Usuario"

   CARDINALIDAD:
   Usuario : Rol = N:N
   - Un usuario puede tener multiples roles
   - Un rol puede estar asignado a multiples usuarios

   OBLIGATORIEDAD:
   - Usuario: debe tener al menos un rol (obligatorio)
   - Rol: puede no estar asignado (opcional)

   IMPLEMENTACION:
   Tabla intermedia: user_roles (user_id, role_id, assigned_at, assigned_by)

   EJEMPLOS:
   - Usuario "admin.sistema001" tiene Rol "R001" (USERS_FULL_MANAGER)
   - Usuario "admin.sistema001" tiene Rol "R016" (SYSTEM_ADMIN)
   - Usuario "ana.reportes" tiene Rol "R004" (REPORTS_VIEWER)

2.2 Rol contiene Permiso
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Rol contiene Permiso

   LECTURA DIRECTA:
   "Rol contiene Permiso"

   LECTURA INVERSA:
   "Permiso pertenece a Rol"

   CARDINALIDAD:
   Rol : Permiso = 1:N
   - Un rol contiene multiples permisos
   - Un permiso pertenece a un rol especifico

   OBLIGATORIEDAD:
   - Rol: debe contener al menos un permiso (obligatorio)
   - Permiso: debe pertenecer a un rol (obligatorio)

   IMPLEMENTACION:
   Tabla: role_permissions (role_id, permission_id)

   EJEMPLOS:
   - Rol "R004" contiene Permiso "reports.view"
   - Rol "R004" contiene Permiso "reports.filter"
   - Rol "R005" contiene Permiso "reports.export.csv"

2.3 Usuario pertenece_a Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Usuario pertenece_a Segmento

   LECTURA DIRECTA:
   "Usuario pertenece a Segmento de Datos"

   LECTURA INVERSA:
   "Segmento de Datos contiene Usuario"

   CARDINALIDAD:
   Usuario : Segmento = N:1
   - Un usuario pertenece a exactamente un segmento
   - Un segmento puede contener multiples usuarios

   OBLIGATORIEDAD:
   - Usuario: debe pertenecer a un segmento (obligatorio)
   - Segmento: puede no tener usuarios (opcional)

   IMPLEMENTACION:
   Columna: users.segment_id (FK a data_segments)

   EJEMPLOS:
   - Usuario "admin.sistema001" pertenece a Segmento "DATOS_CONSOLIDADOS"
   - Usuario "supervisor.norte" pertenece a Segmento "CENTRO_NORTE"

2.4 Usuario inicia Sesion
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Usuario inicia Sesion

   LECTURA DIRECTA:
   "Usuario inicia Sesion"

   LECTURA INVERSA:
   "Sesion pertenece a Usuario"

   CARDINALIDAD:
   Usuario : Sesion (activa) = 1:1
   - Un usuario puede tener como maximo una sesion activa
   - Una sesion pertenece a exactamente un usuario

   NOTA:
   Historicamente, un usuario tiene N sesiones (pasadas).
   En cualquier momento, solo puede tener 1 activa.

   OBLIGATORIEDAD:
   - Usuario: puede no tener sesion activa (opcional)
   - Sesion: debe pertenecer a un usuario (obligatorio)

   IMPLEMENTACION:
   Tabla: sessions (session_id, user_id, is_active, login_at, logout_at)
   Constraint: UNIQUE(user_id) WHERE is_active = TRUE

   EJEMPLOS:
   - Usuario "ana.reportes" inicia Sesion "sess_abc123" (activa)

2.5 Usuario genera Registro_Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Usuario genera Registro_Auditoria

   LECTURA DIRECTA:
   "Usuario genera Registro de Auditoria"

   LECTURA INVERSA:
   "Registro de Auditoria es generado por Usuario"

   CARDINALIDAD:
   Usuario : Registro_Auditoria = 1:N
   - Un usuario genera multiples registros de auditoria
   - Un registro pertenece a exactamente un usuario

   OBLIGATORIEDAD:
   - Usuario: puede no tener registros (opcional, usuario nuevo)
   - Registro: debe tener un usuario asociado (obligatorio)

   IMPLEMENTACION:
   Columna: audit_logs.user_id (FK a users)

   NOTA:
   Los registros son INMUTABLES. No se pueden modificar ni eliminar.

2.6 Rol excluye Rol
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Rol excluye Rol

   LECTURA DIRECTA:
   "Rol excluye Rol" (Separacion de Funciones - SoD)

   LECTURA INVERSA:
   "Rol es excluido por Rol"

   CARDINALIDAD:
   Rol : Rol = N:N (reflexiva)
   - Un rol puede excluir multiples roles
   - Un rol puede ser excluido por multiples roles

   SIMETRIA:
   La relacion es simetrica: si A excluye B, entonces B excluye A.

   OBLIGATORIEDAD:
   Opcional (solo aplica a roles con conflicto SoD)

   PARES CONOCIDOS:
   +------+------+--------------------------------+
   | Rol A| Rol B| Razon                          |
   +------+------+--------------------------------+
   | R016 | R017 | Operador NO debe auditar       |
   | R001 | R017 | Gestor usuarios NO debe auditar|
   +------+------+--------------------------------+

   IMPLEMENTACION:
   Tabla: role_conflicts (role_id_a, role_id_b, reason)

----

3. Fact Types de Dominio IVR
----------------------------

3.1 Llamada origina_en Centro
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Llamada origina_en Centro

   LECTURA DIRECTA:
   "Llamada origina en Centro"

   LECTURA INVERSA:
   "Centro recibe Llamada"

   CARDINALIDAD:
   Llamada : Centro = N:1
   - Una llamada origina en exactamente un centro
   - Un centro recibe multiples llamadas

   OBLIGATORIEDAD:
   - Llamada: debe tener centro de origen (obligatorio)
   - Centro: puede no recibir llamadas (opcional)

   IMPLEMENTACION:
   Columna: tbl_llamadas.centro_id (FK a centros)

3.2 Llamada navega Menu_IVR
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Llamada navega Menu_IVR

   LECTURA DIRECTA:
   "Llamada navega Menu IVR"

   LECTURA INVERSA:
   "Menu IVR es navegado por Llamada"

   CARDINALIDAD:
   Llamada : Menu_IVR = N:N
   - Una llamada puede navegar multiples menus (secuencia)
   - Un menu puede ser navegado por multiples llamadas

   NOTA:
   La navegacion tiene orden (secuencia de opciones seleccionadas).

   OBLIGATORIEDAD:
   - Llamada: puede no navegar ningun menu (llamada corta)
   - Menu: puede no ser navegado (menu no usado)

   IMPLEMENTACION:
   Tabla: llamada_navegacion (llamada_id, menu_id, orden, opcion_seleccionada)

3.3 Llamada genera Transferencia
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Llamada genera Transferencia

   LECTURA DIRECTA:
   "Llamada genera Transferencia"

   LECTURA INVERSA:
   "Transferencia proviene de Llamada"

   CARDINALIDAD:
   Llamada : Transferencia = 1:N
   - Una llamada puede generar multiples transferencias
   - Una transferencia proviene de exactamente una llamada

   OBLIGATORIEDAD:
   - Llamada: puede no generar transferencias (opcional)
   - Transferencia: debe provenir de una llamada (obligatorio)

   IMPLEMENTACION:
   Columna: transferencias.llamada_id (FK a tbl_llamadas)

3.4 Transferencia destina_a Centro
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Transferencia destina_a Centro

   LECTURA DIRECTA:
   "Transferencia destina a Centro"

   LECTURA INVERSA:
   "Centro recibe Transferencia"

   CARDINALIDAD:
   Transferencia : Centro = N:1
   - Una transferencia destina a exactamente un centro
   - Un centro puede recibir multiples transferencias

   OBLIGATORIEDAD:
   - Transferencia: debe tener destino (obligatorio)
   - Centro: puede no recibir transferencias (opcional)

   IMPLEMENTACION:
   Columna: transferencias.centro_destino_id (FK a centros)

----

4. Fact Types de Analitica
--------------------------

4.1 Reporte contiene Metrica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Reporte contiene Metrica

   LECTURA DIRECTA:
   "Reporte contiene Metrica"

   LECTURA INVERSA:
   "Metrica aparece en Reporte"

   CARDINALIDAD:
   Reporte : Metrica = 1:N
   - Un reporte contiene multiples metricas
   - Una metrica puede aparecer en multiples reportes

   OBLIGATORIEDAD:
   - Reporte: debe contener al menos una metrica (obligatorio)
   - Metrica: puede no aparecer en ningun reporte (opcional)

   EJEMPLOS:
   - Reporte "Trimestral" contiene Metrica "Total Llamadas"
   - Reporte "Trimestral" contiene Metrica "Tiempo Promedio"
   - Reporte "Trimestral" contiene Metrica "Tasa Abandono"

4.2 Dashboard visualiza Metrica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Dashboard visualiza Metrica

   LECTURA DIRECTA:
   "Dashboard visualiza Metrica"

   LECTURA INVERSA:
   "Metrica es visualizada en Dashboard"

   CARDINALIDAD:
   Dashboard : Metrica = 1:N
   - Un dashboard visualiza multiples metricas
   - Una metrica puede visualizarse en multiples dashboards

   OBLIGATORIEDAD:
   - Dashboard: debe visualizar al menos una metrica (obligatorio)
   - Metrica: puede no visualizarse (opcional)

   COMPONENTES DE VISUALIZACION:
   - Tarjeta (KPI simple)
   - Grafico de lineas (tendencia)
   - Grafico de barras (comparacion)
   - Grafico de torta (distribucion)

4.3 Alerta monitorea Metrica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Alerta monitorea Metrica

   LECTURA DIRECTA:
   "Alerta monitorea Metrica"

   LECTURA INVERSA:
   "Metrica es monitoreada por Alerta"

   CARDINALIDAD:
   Alerta : Metrica = N:1
   - Una alerta monitorea exactamente una metrica
   - Una metrica puede ser monitoreada por multiples alertas

   OBLIGATORIEDAD:
   - Alerta: debe monitorear una metrica (obligatorio)
   - Metrica: puede no ser monitoreada (opcional)

   ATRIBUTOS DE LA RELACION:
   - umbral: valor limite
   - operador: >, <, =, >=, <=
   - periodo: ventana de tiempo

   EJEMPLOS:
   - Alerta "Alto Abandono" monitorea Metrica "Tasa Abandono" (umbral: > 15%)
   - Alerta "Bajo Volumen" monitorea Metrica "Total Llamadas" (umbral: < 100)

4.4 Alerta notifica_a Usuario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Alerta notifica_a Usuario

   LECTURA DIRECTA:
   "Alerta notifica a Usuario"

   LECTURA INVERSA:
   "Usuario es notificado por Alerta"

   CARDINALIDAD:
   Alerta : Usuario = N:N
   - Una alerta puede notificar a multiples usuarios
   - Un usuario puede recibir notificaciones de multiples alertas

   OBLIGATORIEDAD:
   - Alerta: debe notificar a al menos un usuario (obligatorio)
   - Usuario: puede no recibir alertas (opcional)

   IMPLEMENTACION:
   Tabla: alerta_destinatarios (alerta_id, user_id)

   NOTA:
   Las notificaciones se envian via Mensaje Interno (no email externo).

----

5. Fact Types de Sistema
------------------------

5.1 Usuario recibe Mensaje_Interno
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Usuario recibe Mensaje_Interno

   LECTURA DIRECTA:
   "Usuario recibe Mensaje Interno"

   LECTURA INVERSA:
   "Mensaje Interno es recibido por Usuario"

   CARDINALIDAD:
   Usuario : Mensaje_Interno = 1:N
   - Un usuario puede recibir multiples mensajes
   - Un mensaje es recibido por uno o mas usuarios

   OBLIGATORIEDAD:
   - Usuario: puede no recibir mensajes (opcional)
   - Mensaje: debe tener al menos un destinatario (obligatorio)

   IMPLEMENTACION:
   Tabla: internal_messages (message_id, recipient_user_id, ...)

5.2 Job_ETL sincroniza Llamada
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Job_ETL sincroniza Llamada

   LECTURA DIRECTA:
   "Job ETL sincroniza Llamada"

   LECTURA INVERSA:
   "Llamada es sincronizada por Job ETL"

   CARDINALIDAD:
   Job_ETL : Llamada = 1:N
   - Un job sincroniza multiples llamadas (por ejecucion)
   - Una llamada es sincronizada por exactamente un job

   OBLIGATORIEDAD:
   - Job: sincroniza llamadas cada ejecucion (obligatorio)
   - Llamada: debe ser sincronizada para estar en IACT (obligatorio)

   DIRECCION:
   Unidireccional: IVR (MySQL) -> IACT (PostgreSQL)

   HORARIO:
   Diariamente a las 00:00 (medianoche)

5.3 Permiso aplica_a Modulo
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   FACT TYPE: Permiso aplica_a Modulo

   LECTURA DIRECTA:
   "Permiso aplica a Modulo"

   LECTURA INVERSA:
   "Modulo tiene Permiso"

   CARDINALIDAD:
   Permiso : Modulo = N:1
   - Un permiso aplica a exactamente un modulo
   - Un modulo tiene multiples permisos

   OBLIGATORIEDAD:
   - Permiso: debe aplicar a un modulo (obligatorio)
   - Modulo: debe tener permisos definidos (obligatorio)

   EJEMPLOS:
   - Permiso "reports.view" aplica a Modulo "Reportes"
   - Permiso "users.create" aplica a Modulo "Gestion de Usuarios"
   - Permiso "audit.logs.view" aplica a Modulo "Auditoria"

----

6. Matriz de Fact Types
-----------------------

Resumen de todas las relaciones:

.. list-table::
   :header-rows: 1
   :widths: 30 20 20 15 15

   * - Fact Type
     - Concepto 1
     - Concepto 2
     - Card.
     - Oblig.
   * - tiene
     - Usuario
     - Rol
     - N:N
     - Si
   * - contiene
     - Rol
     - Permiso
     - 1:N
     - Si
   * - pertenece_a
     - Usuario
     - Segmento
     - N:1
     - Si
   * - inicia
     - Usuario
     - Sesion
     - 1:1*
     - No
   * - genera
     - Usuario
     - Reg.Auditoria
     - 1:N
     - No
   * - excluye
     - Rol
     - Rol
     - N:N
     - No
   * - origina_en
     - Llamada
     - Centro
     - N:1
     - Si
   * - navega
     - Llamada
     - Menu_IVR
     - N:N
     - No
   * - genera
     - Llamada
     - Transferencia
     - 1:N
     - No
   * - destina_a
     - Transferencia
     - Centro
     - N:1
     - Si
   * - contiene
     - Reporte
     - Metrica
     - 1:N
     - Si
   * - visualiza
     - Dashboard
     - Metrica
     - 1:N
     - Si
   * - monitorea
     - Alerta
     - Metrica
     - N:1
     - Si
   * - notifica_a
     - Alerta
     - Usuario
     - N:N
     - Si
   * - recibe
     - Usuario
     - Mensaje
     - 1:N
     - No
   * - sincroniza
     - Job_ETL
     - Llamada
     - 1:N
     - Si
   * - aplica_a
     - Permiso
     - Modulo
     - N:1
     - Si

(*) 1:1 para sesion activa, 1:N historico

----

7. Diagrama de Relaciones
-------------------------

.. code-block:: text

                                  +-------------+
                                  |   Modulo    |
                                  +------+------+
                                                 
                                         | aplica_a
                                         |
   +----------+    contiene    +---------+--------+
   |   Rol    +--------------->|     Permiso      |
   +----+-----+                +------------------+
                                                   
        | tiene
        |
   +----+-----+    pertenece_a    +-------------+
   |  Usuario +------------------>|  Segmento   |
   +----+-----+                   +-------------+
        |
        | inicia / genera / recibe
        |
        v
   +----+-----+    +-------------+    +-------------+
   |  Sesion  |    | Reg.Audit.  |    |  Mensaje    |
   +----------+    +-------------+    +-------------+


   +----------+    origina_en    +-------------+
   | Llamada  +----------------->|   Centro    |
   +----+-----+                  +------+------+
        |                               ^
        | navega / genera               | destina_a
        |                               |
        v                        +------+------+
   +----+-----+                  |Transferencia|
   | Menu_IVR |                  +-------------+
   +----------+


   +----------+    contiene    +-------------+
   | Reporte  +--------------->|   Metrica   |
   +----------+                +------+------+
                                              
   +----------+    visualiza          |
   |Dashboard +---------------------->+
   +----------+                       |
                                      |
   +----------+    monitorea          |
   |  Alerta  +---------------------->+
   +----+-----+
        |
        | notifica_a
        v
   +----+-----+
   | Usuario  |
   +----------+

----

8. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`sbvr-01` - Conceptos Nucleares (sustantivos)
- :ref:`sbvr-03` - Reglas Estructurales (aleticas)
- :ref:`sbvr-04` - Reglas Operativas (deonticas)
- :ref:`fnd-02` - Reglas de Negocio

Fuentes
^^^^^^^

- OMG SBVR 1.5 Specification (Fact Types)
- Modelo\_RBAC\_Completo\_-_Sistema_IACT_-_v_0_0_1.md

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
     - 2025-12-20
     - Equipo IACT
     - Version inicial con 17 Fact Types documentados

----

**Trazabilidad:** Este artefacto define los verbos (relaciones) entre los
conceptos de :ref:`sbvr-01`. Es prerequisito para las reglas estructurales
(:ref:`sbvr-03`) y operativas (:ref:`sbvr-04`) que se construyen sobre
estos Fact Types.
