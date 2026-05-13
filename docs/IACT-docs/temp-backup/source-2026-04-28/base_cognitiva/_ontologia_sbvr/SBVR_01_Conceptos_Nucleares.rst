.. meta::
   :artefacto: SBVR_01
   :tipo: Ontologia SBVR
   :dominio: base_cognitiva
   :subdominio: _ontologia_sbvr
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-18
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _sbvr-01:

============================
SBVR_01: Conceptos Nucleares
============================


Proposito
---------

Este documento define los **conceptos nucleares** (sustantivos) del dominio
IACT siguiendo el estandar SBVR. Estos conceptos forman el vocabulario base
sobre el cual se construyen todas las reglas de negocio.

.. note::

   **Notacion SBVR:**

   - **Conceptos** (sustantivos) se muestran subrayados: Usuario
   - **Definiciones** se expresan en lenguaje controlado
   - **Sinonimos** se listan como terminos alternativos aceptados

----

1. Categorias de Conceptos
--------------------------

Los conceptos del dominio IACT se organizan en 5 categorias:

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Categoria
     - Descripcion
   * - Actores
     - Entidades que interactuan con el sistema
   * - Seguridad
     - Elementos del modelo de control de acceso
   * - Dominio IVR
     - Objetos del negocio de analitica de llamadas
   * - Analitica
     - Elementos de reporteria y visualizacion
   * - Sistema
     - Componentes tecnicos del sistema

----

2. Categoria: Actores
---------------------

2.1 Usuario
^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Usuario

   DEFINICION:
   Persona que tiene una cuenta activa en el sistema IACT y puede
   autenticarse para acceder a funcionalidades segun sus roles asignados.

   SINONIMOS:
   - Operador (contexto operacional)
   - Cuenta (contexto tecnico)

   CARACTERISTICAS:
   - Tiene exactamente un username (unico)
   - Tiene exactamente un email (unico)
   - Tiene exactamente un estado (ACTIVO | INACTIVO | BLOQUEADO)
   - Pertenece a exactamente un segmento de datos
   - Puede tener uno o mas roles

   REPRESENTACION BD:
   Tabla: users
   PK: user_id

2.2 Administrador
^^^^^^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Administrador

   DEFINICION:
   Usuario que tiene asignado al menos uno de los roles de administracion
   (R001, R015, R016, R017, R018).

   SINONIMOS:
   - Admin
   - Usuario privilegiado

   NOTA:
   Es un concepto derivado (subtipo de Usuario), no una entidad separada.
   Se infiere por los roles asignados.

2.3 Sistema Externo
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Sistema Externo

   DEFINICION:
   Componente de software fuera del perimetro de IACT que interactua
   con el sistema mediante interfaces definidas.

   INSTANCIAS CONOCIDAS:
   - Sistema IVR (fuente de datos MySQL)
   - Proceso ETL (sincronizacion nocturna)

   NOTA:
   Los sistemas externos actuan como actores en ciertos casos de uso
   pero no tienen cuenta de usuario.

----

3. Categoria: Seguridad
-----------------------

3.1 Rol
^^^^^^^

.. code-block:: text

   CONCEPTO: Rol

   DEFINICION:
   Conjunto nombrado de permisos que representa una funcion tecnica
   dentro del sistema IACT.

   SINONIMOS:
   - Rol funcional
   - Perfil de acceso

   CARACTERISTICAS:
   - Tiene exactamente un codigo (R001-R018)
   - Tiene exactamente un nombre descriptivo
   - Tiene uno o mas permisos asociados
   - Es independiente (sin herencia de otros roles)

   CATALOGO:
   El sistema define exactamente 18 roles funcionales:

   +-------+-------------------------+----------------------+
   | Codigo| Nombre                  | Categoria            |
   +-------+-------------------------+----------------------+
   | R001  | USERS_FULL_MANAGER      | Gestion de Usuarios  |
   | R002  | USERS_VIEWER            | Gestion de Usuarios  |
   | R003  | USERS_TEAM_MANAGER      | Gestion de Usuarios  |
   | R004  | REPORTS_VIEWER          | Reportes             |
   | R005  | REPORTS_EXPORTER        | Reportes             |
   | R006  | REPORTS_ADVANCED_VIEWER | Reportes             |
   | R007  | REPORTS_CREATOR         | Reportes             |
   | R008  | DASHBOARD_VIEWER        | Visualizacion        |
   | R009  | DASHBOARD_CUSTOMIZER    | Visualizacion        |
   | R010  | DATA_ANALYST            | Analisis             |
   | R011  | ALERTS_VIEWER           | Alertas              |
   | R012  | ALERTS_CONFIGURATOR     | Alertas              |
   | R013  | ALERTS_TEAM_MANAGER     | Alertas              |
   | R014  | ALERTS_GLOBAL_ADMIN     | Alertas              |
   | R015  | MODULES_ADMIN           | Administracion       |
   | R016  | SYSTEM_ADMIN            | Administracion       |
   | R017  | AUDIT_VIEWER            | Administracion       |
   | R018  | SECURITY_ADMIN          | Administracion       |
   +-------+-------------------------+----------------------+

   REPRESENTACION BD:
   Tabla: roles
   PK: role_id

3.2 Permiso
^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Permiso

   DEFINICION:
   Autorizacion atomica para ejecutar una accion especifica sobre
   un recurso del sistema.

   SINONIMOS:
   - Privilegio
   - Capacidad

   FORMATO:
   {recurso}.{accion}[.{modificador}]

   EJEMPLOS:
   - users.create
   - reports.view
   - reports.export.csv
   - audit.logs.view

   CARACTERISTICAS:
   - Es atomico (una sola accion)
   - Pertenece a uno o mas roles
   - Puede asignarse directamente a usuario (temporal)

   REPRESENTACION BD:
   Tabla: permissions
   PK: permission_id

3.3 Sesion
^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Sesion

   DEFINICION:
   Periodo de tiempo durante el cual un usuario autenticado mantiene
   acceso activo al sistema.

   SINONIMOS:
   - Session
   - Conexion activa

   CARACTERISTICAS:
   - Pertenece a exactamente un usuario
   - Tiene exactamente un estado (ACTIVE | EXPIRED | CLOSED)
   - Tiene fecha/hora de inicio
   - Tiene fecha/hora de ultima actividad
   - Es unica por usuario (sesion unica)

   RESTRICCION:
   Un usuario puede tener como maximo una sesion activa en cualquier
   momento (politica de sesion unica).

   REPRESENTACION BD:
   Tabla: sessions
   PK: session_id

3.4 Segmento de Datos
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Segmento de Datos

   DEFINICION:
   Particion logica de los datos del sistema que determina el alcance
   de visibilidad de un usuario.

   SINONIMOS:
   - Segmento
   - Ambito de datos
   - Data scope

   INSTANCIAS CONOCIDAS:
   - DATOS_CONSOLIDADOS (ve todos los centros)
   - CENTRO_NORTE (ve solo centro norte)
   - CENTRO_SUR (ve solo centro sur)
   - CENTRO_ORIENTE (ve solo centro oriente)

   CARACTERISTICAS:
   - Usuario pertenece a exactamente un segmento
   - Segmento filtra automaticamente los datos visibles

   REPRESENTACION BD:
   Tabla: data_segments
   PK: segment_id

3.5 Registro de Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Registro de Auditoria

   DEFINICION:
   Entrada inmutable que documenta una accion ejecutada en el sistema,
   incluyendo quien, cuando, que y resultado.

   SINONIMOS:
   - Log de auditoria
   - Audit log
   - Evento de auditoria

   CARACTERISTICAS:
   - Es inmutable (no se puede modificar ni eliminar)
   - Registra: usuario, timestamp, accion, resultado, IP
   - Tiene nivel de severidad (INFO, WARNING, CRITICAL)

   REPRESENTACION BD:
   Tabla: audit_logs
   PK: log_id (BIGINT AUTO_INCREMENT)

----

4. Categoria: Dominio IVR
-------------------------

4.1 Llamada
^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Llamada

   DEFINICION:
   Interaccion telefonica registrada en el sistema IVR que representa
   un contacto de cliente con el centro de atencion.

   SINONIMOS:
   - Call
   - Contacto telefonico
   - Interaccion IVR

   CARACTERISTICAS:
   - Tiene fecha y hora de inicio
   - Tiene duracion en segundos
   - Origina en exactamente un centro
   - Tiene un resultado (completada, abandonada, transferida)
   - Tiene una navegacion de menu (opciones seleccionadas)

   ORIGEN:
   Datos provienen del sistema IVR (MySQL, solo lectura)

   REPRESENTACION BD (origen):
   Tabla: tbl_llamadas (MySQL IVR - READ ONLY)

4.2 Centro
^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Centro

   DEFINICION:
   Ubicacion fisica o logica donde se reciben y procesan las llamadas
   del sistema IVR.

   SINONIMOS:
   - Centro de atencion
   - Centro de llamadas
   - Call center
   - Centro de transferencia

   CARACTERISTICAS:
   - Tiene un codigo unico
   - Tiene un nombre descriptivo
   - Tiene una ubicacion geografica
   - Puede recibir transferencias de otros centros

   REPRESENTACION BD:
   Tabla: centros
   PK: centro_id

4.3 Menu IVR
^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Menu IVR

   DEFINICION:
   Estructura jerarquica de opciones que el sistema IVR presenta
   al llamante para navegar hacia el servicio deseado.

   SINONIMOS:
   - Arbol IVR
   - Estructura de navegacion
   - Menu de opciones

   CARACTERISTICAS:
   - Tiene multiples niveles (jerarquia)
   - Cada opcion tiene un codigo numerico (1-9, 0)
   - Cada opcion lleva a otro menu o a un destino final

   EJEMPLO:
   1 -> Consulta de saldo
   2 -> Pagos
     2.1 -> Pago con tarjeta
     2.2 -> Pago en efectivo
   3 -> Hablar con ejecutivo

4.4 Transferencia
^^^^^^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Transferencia

   DEFINICION:
   Accion de redirigir una llamada desde un centro o punto de atencion
   hacia otro destino dentro del sistema IVR.

   SINONIMOS:
   - Transfer
   - Redireccion

   CARACTERISTICAS:
   - Tiene un origen (centro o menu)
   - Tiene un destino (centro o agente)
   - Tiene una razon (seleccion usuario, regla automatica)
   - Tiene un timestamp

----

5. Categoria: Analitica
-----------------------

5.1 Reporte
^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Reporte

   DEFINICION:
   Documento estructurado que presenta datos agregados y metricas
   del sistema IVR para un periodo y criterios especificos.

   SINONIMOS:
   - Informe
   - Report

   TIPOS:
   - Reporte Trimestral de Llamadas
   - Reporte de Transferencias por Centro
   - Reporte de Problemas de Menu

   CARACTERISTICAS:
   - Tiene un tipo (predefinido)
   - Tiene un rango de fechas
   - Tiene filtros aplicados (centro, servicio)
   - Puede exportarse a CSV, Excel, PDF

   REPRESENTACION BD:
   Tabla: tbl_reporte_llamadas_dia (precalculado)

5.2 Dashboard
^^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Dashboard

   DEFINICION:
   Interfaz visual que presenta metricas y graficos en tiempo real
   o casi-real sobre el comportamiento del sistema IVR.

   SINONIMOS:
   - Tablero
   - Panel de control
   - Vista ejecutiva

   COMPONENTES:
   - Tarjetas de metricas (KPIs)
   - Graficos de lineas (tendencias)
   - Graficos de barras (comparaciones)
   - Graficos de torta (distribuciones)

   CARACTERISTICAS:
   - Puede personalizarse (usuarios con R009)
   - Se actualiza periodicamente
   - Respeta segmento de datos del usuario

5.3 Metrica
^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Metrica

   DEFINICION:
   Valor numerico calculado que representa una medida de desempeno
   o comportamiento del sistema IVR.

   SINONIMOS:
   - KPI (Key Performance Indicator)
   - Indicador
   - Medida

   EJEMPLOS:
   - Total de llamadas (por periodo)
   - Tiempo promedio de espera
   - Tasa de abandono
   - Llamadas por hora
   - Transferencias por centro

   CARACTERISTICAS:
   - Tiene un nombre
   - Tiene una formula de calculo
   - Tiene una unidad de medida
   - Tiene un periodo de agregacion

5.4 Alerta
^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Alerta

   DEFINICION:
   Notificacion automatica que se genera cuando una metrica supera
   un umbral configurado.

   SINONIMOS:
   - Alarma
   - Notificacion de umbral
   - Warning

   CARACTERISTICAS:
   - Monitorea exactamente una metrica
   - Tiene un umbral (valor limite)
   - Tiene un operador de comparacion (>, <, =, >=, <=)
   - Tiene uno o mas destinatarios
   - Tiene un estado (ACTIVA | INACTIVA)

   REPRESENTACION BD:
   Tabla: alertas
   PK: alerta_id

----

6. Categoria: Sistema
---------------------

6.1 Modulo
^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Modulo

   DEFINICION:
   Componente funcional del sistema IACT que agrupa funcionalidades
   relacionadas y puede asignarse a usuarios.

   SINONIMOS:
   - Funcionalidad
   - Componente
   - Feature

   MODULOS IDENTIFICADOS:
   - Gestion de Usuarios
   - Reportes
   - Dashboard
   - Alertas
   - Auditoria
   - Administracion del Sistema

   CARACTERISTICAS:
   - Tiene un codigo unico
   - Tiene permisos asociados
   - Puede habilitarse/deshabilitarse por usuario

6.2 Mensaje Interno
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Mensaje Interno

   DEFINICION:
   Comunicacion dentro del sistema IACT entre usuarios o desde
   el sistema hacia usuarios, sin uso de correo electronico externo.

   SINONIMOS:
   - Notificacion interna
   - Internal message
   - Buzon interno

   CARACTERISTICAS:
   - Tiene un remitente (usuario o SISTEMA)
   - Tiene uno o mas destinatarios
   - Tiene asunto y cuerpo
   - Tiene tipo (info, warning, alert)
   - Tiene estado de lectura

   RESTRICCION:
   El sistema IACT NO envia correos electronicos externos.
   Toda comunicacion es via mensajes internos (CNST_001).

   REPRESENTACION BD:
   Tabla: internal_messages
   PK: message_id

6.3 Job ETL
^^^^^^^^^^^

.. code-block:: text

   CONCEPTO: Job ETL

   DEFINICION:
   Proceso programado que extrae datos del sistema IVR (MySQL),
   los transforma y los carga en la base de datos IACT (PostgreSQL).

   SINONIMOS:
   - Proceso ETL
   - Sincronizacion
   - Stored procedure de actualizacion

   CARACTERISTICAS:
   - Se ejecuta diariamente a las 00:00 (medianoche)
   - Es unidireccional (IVR -> IACT)
   - Solo lectura en origen (MySQL)
   - Escritura en destino (PostgreSQL)

   INSTANCIA PRINCIPAL:
   sp_actualizar_reportes_iact

   REPRESENTACION BD:
   Tabla: etl_jobs (configuracion)
   Tabla: etl_logs (ejecuciones)

----

7. Relaciones entre Conceptos
-----------------------------

Vista general de como se relacionan los conceptos nucleares:

.. code-block:: text

   Usuario
       |
       +--- tiene ---> Rol (1:N)
       |
       +--- pertenece_a ---> Segmento de Datos (N:1)
       |
       +--- inicia ---> Sesion (1:1 activa)
       |
       +--- genera ---> Registro de Auditoria (1:N)
       |
       +--- recibe ---> Mensaje Interno (1:N)

   Rol
       |
       +--- contiene ---> Permiso (1:N)

   Llamada
       |
       +--- origina_en ---> Centro (N:1)
       |
       +--- navega ---> Menu IVR (N:N)
       |
       +--- genera ---> Transferencia (1:N)

   Reporte
       |
       +--- contiene ---> Metrica (1:N)

   Alerta
       |
       +--- monitorea ---> Metrica (N:1)
       |
       +--- notifica_a ---> Usuario (N:N)

   Dashboard
       |
       +--- visualiza ---> Metrica (1:N)
       |
       +--- visualiza ---> Reporte (1:N)

.. note::

   Las relaciones detalladas se documentan en :ref:`sbvr-02` (Fact Types).

----

8. Glosario Rapido
------------------

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Concepto
     - Definicion Corta
   * - Usuario
     - Persona con cuenta en IACT
   * - Rol
     - Conjunto de permisos (18 definidos)
   * - Permiso
     - Autorizacion atomica para una accion
   * - Sesion
     - Periodo de acceso activo
   * - Segmento
     - Particion de datos visible
   * - Llamada
     - Interaccion telefonica IVR
   * - Centro
     - Ubicacion de atencion
   * - Reporte
     - Documento con datos agregados
   * - Dashboard
     - Panel visual de metricas
   * - Metrica
     - Valor numerico de desempeno
   * - Alerta
     - Notificacion por umbral
   * - Mensaje Interno
     - Comunicacion dentro del sistema

----

9. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`sbvr-02` - Fact Types (relaciones entre conceptos)
- :ref:`sbvr-03` - Reglas Estructurales (aleticas)
- :ref:`sbvr-04` - Reglas Operativas (deonticas)
- :ref:`fnd-02` - Reglas de Negocio (fundamentos)

Fuentes
^^^^^^^

- Modelo\_RBAC\_Completo\_-_Sistema_IACT_-_v_0_0_1.md
- OMG SBVR 1.5 Specification
- Paper IBM: "SBVR Use Cases" (Linehan, 2008)

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
     - Version inicial con 5 categorias y 17 conceptos

----

**Trazabilidad:** Este artefacto define el vocabulario base (sustantivos)
del dominio IACT. Es prerequisito para SBVR_02 (Fact Types) y referenciado
por todas las Business Rules en requisitos/reglas_negocio/.
