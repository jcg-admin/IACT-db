.. meta::
   :artefacto: SBVR_04
   :tipo: Ontologia SBVR
   :dominio: base_cognitiva
   :subdominio: _ontologia_sbvr
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _sbvr-04:

======================================
SBVR_04: Reglas Operativas (Deonticas)
======================================


Proposito
---------

Este documento define las **reglas operativas** (deonticas) del dominio
IACT siguiendo el estandar SBVR. Las reglas deonticas describen lo que
**DEBE SER**, **NO DEBE SER** o **PUEDE SER** - obligaciones, prohibiciones
y permisos que pueden violarse (y el sistema debe prevenir o detectar).

.. note::

   **Modalidad Deontica (del griego deon = deber):**

   - Describe **obligaciones** y **prohibiciones**
   - Define lo que DEBE SER (no lo que ES)
   - Puede violarse (el sistema debe prevenirlo)
   - Keywords: DEBE, NO DEBE, PUEDE, SOLO, UNICAMENTE

----

1. Tipos de Reglas Deonticas
----------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Tipo
     - Keyword
     - Descripcion
   * - **Obligacion**
     - DEBE
     - Accion requerida, no opcional
   * - **Prohibicion**
     - NO DEBE
     - Accion no permitida bajo ninguna condicion
   * - **Permiso**
     - PUEDE
     - Accion opcional, permitida pero no requerida
   * - **Restriccion**
     - SOLO, UNICAMENTE
     - Limita quien o cuando puede hacer algo

----

2. Reglas de Obligacion (DEBE)
------------------------------

2.1 Usuario debe tener Rol
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-001

   ENUNCIADO:
   Cada Usuario DEBE tener al menos un Rol asignado.

   TIPO: Obligacion

   KEYWORD: DEBE

   EXPRESION FORMAL:
   Es obligatorio que Usuario tenga Rol

   VALIDACION:
   - Al crear usuario: asignar rol por defecto o requerir seleccion
   - Al revocar rol: verificar que quede al menos uno

   MENSAJE ERROR:
   "Usuario debe tener al menos un rol asignado"

   REFERENCIA:
   Complementa ALE-012 (cardinalidad estructural)

2.2 Sesion debe registrar IP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-002

   ENUNCIADO:
   Cada Sesion DEBE registrar la direccion IP de origen.

   TIPO: Obligacion

   KEYWORD: DEBE

   EXPRESION FORMAL:
   Es obligatorio que Sesion tenga ip_address

   JUSTIFICACION:
   Trazabilidad de accesos para auditoria y seguridad.

   IMPLEMENTACION:
   sessions.ip_address VARCHAR(45) NOT NULL

2.3 Accion debe generar Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-003

   ENUNCIADO:
   Cada accion de usuario DEBE generar un Registro de Auditoria.

   TIPO: Obligacion

   KEYWORD: DEBE

   EXPRESION FORMAL:
   Es obligatorio que toda Accion genere Registro_Auditoria

   ACCIONES AUDITABLES:
   - Login / Logout
   - CRUD de usuarios
   - Asignacion/revocacion de roles
   - Consulta de reportes
   - Exportacion de datos
   - Cambios de configuracion

   CONTENIDO MINIMO:
   - user_id
   - timestamp
   - action_type
   - result (SUCCESS/FAILED)
   - ip_address

2.4 Alerta debe tener Destinatario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-004

   ENUNCIADO:
   Cada Alerta DEBE notificar a al menos un Usuario.

   TIPO: Obligacion

   KEYWORD: DEBE

   EXPRESION FORMAL:
   Es obligatorio que Alerta notifique_a Usuario

   VALIDACION:
   - Al crear alerta: requerir al menos un destinatario
   - Al eliminar destinatario: verificar que quede al menos uno

   MENSAJE ERROR:
   "Alerta debe tener al menos un destinatario"

2.5 Cambio de Rol debe justificarse
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-005

   ENUNCIADO:
   La asignacion o revocacion de Rol DEBE incluir justificacion.

   TIPO: Obligacion

   KEYWORD: DEBE

   EXPRESION FORMAL:
   Es obligatorio que asignacion_rol tenga justificacion
   Es obligatorio que revocacion_rol tenga justificacion

   REQUISITO:
   Justificacion minima: 20 caracteres

   MENSAJE ERROR:
   "Debe proporcionar justificacion (minimo 20 caracteres)"

2.6 Password debe cumplir Politica
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-006

   ENUNCIADO:
   El password de Usuario DEBE cumplir la politica de seguridad.

   TIPO: Obligacion

   KEYWORD: DEBE

   POLITICA:
   - Longitud minima: 8 caracteres
   - Al menos una mayuscula
   - Al menos una minuscula
   - Al menos un numero
   - Al menos un caracter especial

   MENSAJE ERROR:
   "Password no cumple politica de seguridad"

----

3. Reglas de Prohibicion (NO DEBE)
----------------------------------

3.1 Usuario no debe tener Roles Conflictivos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-007

   ENUNCIADO:
   Un Usuario NO DEBE tener simultaneamente roles que esten
   en conflicto por Separacion de Funciones (SoD).

   TIPO: Prohibicion

   KEYWORD: NO DEBE

   EXPRESION FORMAL:
   Es prohibido que Usuario tenga Rol_A y Rol_B
   SI Rol_A excluye Rol_B

   PARES CONFLICTIVOS:
   +------+------+--------------------------------+
   | Rol A| Rol B| Razon                          |
   +------+------+--------------------------------+
   | R016 | R017 | Operador NO debe auditar       |
   | R001 | R017 | Gestor usuarios NO debe auditar|
   +------+------+--------------------------------+

   VALIDACION:
   - Al asignar rol: verificar conflictos SoD
   - Si existe conflicto: bloquear asignacion

   MENSAJE ERROR:
   "Rol [X] incompatible con rol existente [Y] por Separacion de Funciones"

   REFERENCIA:
   BR_015 (Separacion de Funciones)

3.2 Sistema no debe enviar Email Externo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-008

   ENUNCIADO:
   El sistema IACT NO DEBE enviar correos electronicos externos.

   TIPO: Prohibicion

   KEYWORD: NO DEBE

   EXPRESION FORMAL:
   Es prohibido que Sistema envie email_externo

   ALTERNATIVA:
   Toda comunicacion se realiza via Mensaje Interno (buzon).

   JUSTIFICACION:
   Politica de seguridad: comunicaciones internas unicamente.

   REFERENCIA:
   CNST_001 (Restriccion de comunicaciones)

3.3 IACT no debe modificar BD IVR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-009

   ENUNCIADO:
   El sistema IACT NO DEBE modificar datos en la BD del sistema IVR.

   TIPO: Prohibicion

   KEYWORD: NO DEBE

   EXPRESION FORMAL:
   Es prohibido que IACT ejecute INSERT en Sistema_IVR
   Es prohibido que IACT ejecute UPDATE en Sistema_IVR
   Es prohibido que IACT ejecute DELETE en Sistema_IVR

   JUSTIFICACION:
   IACT es sistema de analitica (solo lectura).
   La fuente de verdad es el sistema IVR.

   IMPLEMENTACION:
   Usuario de BD con permisos SELECT unicamente.

   REFERENCIA:
   BR_001 (Fuente Operacional Inmutable)

3.4 Auditoria no debe modificarse
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-010

   ENUNCIADO:
   Ningun usuario NO DEBE poder modificar o eliminar
   Registros de Auditoria.

   TIPO: Prohibicion

   KEYWORD: NO DEBE

   EXPRESION FORMAL:
   Es prohibido que Usuario modifique Registro_Auditoria
   Es prohibido que Usuario elimine Registro_Auditoria

   APLICA A:
   Todos los usuarios, incluyendo administradores.

   IMPLEMENTACION:
   - Triggers que bloquean UPDATE/DELETE
   - Sin permiso audit.logs.update en ningun rol
   - Sin permiso audit.logs.delete en ningun rol

   REFERENCIA:
   ALE-015 (Inmutabilidad estructural)

3.5 Usuario Inactivo no debe autenticarse
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-011

   ENUNCIADO:
   Un Usuario con estado INACTIVO o BLOQUEADO NO DEBE poder
   iniciar sesion en el sistema.

   TIPO: Prohibicion

   KEYWORD: NO DEBE

   EXPRESION FORMAL:
   Es prohibido que Usuario inicie Sesion
   SI Usuario.estado != 'ACTIVO'

   VALIDACION:
   - En login: verificar estado antes de autenticar
   - Si inactivo: "Usuario inactivo. Contacte al administrador."
   - Si bloqueado: "Usuario bloqueado. Contacte al administrador."

3.6 Exportacion no debe exceder Limite
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-012

   ENUNCIADO:
   Una exportacion de datos NO DEBE exceder 50,000 registros.

   TIPO: Prohibicion

   KEYWORD: NO DEBE

   EXPRESION FORMAL:
   Es prohibido que Exportacion tenga COUNT > 50000

   JUSTIFICACION:
   - Proteccion contra descarga masiva de datos
   - Rendimiento del sistema
   - Deteccion de actividad sospechosa

   MENSAJE ERROR:
   "Exportacion excede limite de 50,000 registros. Aplique filtros adicionales."

----

4. Reglas de Permiso (PUEDE)
----------------------------

4.1 Administrador puede cerrar Sesion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-013

   ENUNCIADO:
   Un Usuario con rol R016 (SYSTEM_ADMIN) PUEDE cerrar
   la sesion activa de otro usuario.

   TIPO: Permiso

   KEYWORD: PUEDE

   EXPRESION FORMAL:
   Es permitido que Usuario(R016) cierre Sesion de Usuario

   CONDICIONES:
   - Requiere justificacion (minimo 20 caracteres)
   - Se registra en auditoria (nivel CRITICAL)
   - Se notifica al usuario afectado via buzon interno
   - Se notifica a R018 (SECURITY_ADMIN)

4.2 Usuario puede personalizar Dashboard
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-014

   ENUNCIADO:
   Un Usuario con rol R009 (DASHBOARD_CUSTOMIZER) PUEDE
   personalizar la disposicion de widgets en su dashboard.

   TIPO: Permiso

   KEYWORD: PUEDE

   EXPRESION FORMAL:
   Es permitido que Usuario(R009) personalice Dashboard

   ALCANCE:
   - Solo dashboard propio
   - No afecta dashboards de otros usuarios
   - Personalizacion se guarda por usuario

4.3 Analista puede ejecutar Consultas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-015

   ENUNCIADO:
   Un Usuario con rol R010 (DATA_ANALYST) PUEDE ejecutar
   consultas SQL de solo lectura sobre tablas de reportes.

   TIPO: Permiso

   KEYWORD: PUEDE

   EXPRESION FORMAL:
   Es permitido que Usuario(R010) ejecute SELECT
   SOBRE tablas tbl_reporte_*

   RESTRICCIONES:
   - Solo SELECT (no INSERT, UPDATE, DELETE)
   - Solo tablas de reportes (no tablas de sistema)
   - Timeout maximo: 30 segundos
   - Registrado en auditoria

----

5. Reglas de Restriccion (SOLO/UNICAMENTE)
------------------------------------------

5.1 Solo Administrador gestiona Usuarios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-016

   ENUNCIADO:
   SOLO usuarios con rol R001 (USERS_FULL_MANAGER) pueden
   crear, modificar o eliminar usuarios.

   TIPO: Restriccion

   KEYWORD: SOLO

   EXPRESION FORMAL:
   Es obligatorio que Usuario tenga R001
   PARA ejecutar users.create, users.update, users.delete

   EXCEPCION:
   R003 (USERS_TEAM_MANAGER) puede gestionar usuarios
   de su mismo segmento de datos.

5.2 Unicamente via Buzon Interno
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-017

   ENUNCIADO:
   Las notificaciones del sistema se envian UNICAMENTE
   via buzon interno (Mensaje Interno).

   TIPO: Restriccion

   KEYWORD: UNICAMENTE

   EXPRESION FORMAL:
   Es obligatorio que Notificacion use Mensaje_Interno
   Es prohibido que Notificacion use email_externo

   REFERENCIA:
   DEO-008 (prohibicion email), CNST_001

5.3 Solo horario nocturno para ETL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-018

   ENUNCIADO:
   El Job ETL SOLO debe ejecutarse en horario nocturno
   (00:00 - 06:00) en condiciones normales.

   TIPO: Restriccion

   KEYWORD: SOLO

   EXPRESION FORMAL:
   Es obligatorio que Job_ETL.hora_ejecucion ENTRE 00:00 Y 06:00

   EXCEPCION:
   R016 (SYSTEM_ADMIN) puede ejecutar manualmente con justificacion.

   JUSTIFICACION:
   Minimizar impacto en BD IVR durante horario operativo.

   REFERENCIA:
   BR_002 (Sincronizacion ETL Nocturna)

5.4 Solo Auditor ve Logs
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-019

   ENUNCIADO:
   SOLO usuarios con rol R017 (AUDIT_VIEWER) pueden
   consultar los registros de auditoria.

   TIPO: Restriccion

   KEYWORD: SOLO

   EXPRESION FORMAL:
   Es obligatorio que Usuario tenga R017
   PARA ejecutar audit.logs.view

   JUSTIFICACION:
   Independencia del auditor (Separacion de Funciones).

----

6. Reglas Condicionales (SI...ENTONCES)
---------------------------------------

6.1 Si inactivo 90 dias, entonces bloquear
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-020

   ENUNCIADO:
   SI un Usuario no inicia sesion por 90 dias consecutivos,
   ENTONCES el sistema DEBE cambiar su estado a INACTIVO.

   TIPO: Desencadenador (Trigger)

   KEYWORD: SI...ENTONCES DEBE

   EXPRESION FORMAL:
   SI (DIAS_DESDE(Usuario.ultima_sesion) > 90)
   ENTONCES Usuario.estado := 'INACTIVO'

   IMPLEMENTACION:
   Job diario que verifica ultima actividad.

   REFERENCIA:
   BR_003 (Usuario Inactivo por Tiempo)

6.2 Si 3 intentos fallidos, entonces bloquear
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-021

   ENUNCIADO:
   SI un Usuario falla 3 intentos de login consecutivos,
   ENTONCES el sistema DEBE bloquear temporalmente la cuenta.

   TIPO: Desencadenador (Trigger)

   KEYWORD: SI...ENTONCES DEBE

   EXPRESION FORMAL:
   SI (Usuario.intentos_fallidos >= 3)
   ENTONCES Usuario.estado := 'BLOQUEADO'
   Y Usuario.bloqueado_hasta := NOW() + 30 minutos

   NOTIFICACION:
   Enviar mensaje interno a R018 (SECURITY_ADMIN).

6.3 Si alerta dispara, entonces notificar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-022

   ENUNCIADO:
   SI una Alerta detecta que su Metrica supera el umbral,
   ENTONCES el sistema DEBE notificar a todos los destinatarios.

   TIPO: Desencadenador (Trigger)

   KEYWORD: SI...ENTONCES DEBE

   EXPRESION FORMAL:
   SI (Metrica.valor OPERADOR Alerta.umbral)
   ENTONCES PARA CADA Usuario EN Alerta.destinatarios:
     Crear Mensaje_Interno(Usuario, Alerta.contenido)

   CANAL:
   Buzon interno (no email externo).

6.4 Si exportacion grande, entonces confirmar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA OPERATIVA: DEO-023

   ENUNCIADO:
   SI una exportacion contiene mas de 10,000 registros,
   ENTONCES el sistema DEBE solicitar confirmacion explicita.

   TIPO: Desencadenador (Trigger)

   KEYWORD: SI...ENTONCES DEBE

   EXPRESION FORMAL:
   SI (Exportacion.count > 10000)
   ENTONCES requerir_confirmacion(Usuario)

   MENSAJE:
   "Esta exportacion contiene [N] registros. Confirme para continuar."

----

7. Matriz de Reglas Operativas
------------------------------

.. list-table::
   :header-rows: 1
   :widths: 12 30 15 20 23

   * - Codigo
     - Regla
     - Tipo
     - Keyword
     - Referencia
   * - DEO-001
     - Usuario debe tener rol
     - Obligacion
     - DEBE
     - ALE-012
   * - DEO-002
     - Sesion registra IP
     - Obligacion
     - DEBE
     - Auditoria
   * - DEO-003
     - Accion genera auditoria
     - Obligacion
     - DEBE
     - Compliance
   * - DEO-004
     - Alerta tiene destinatario
     - Obligacion
     - DEBE
     - ALE-014
   * - DEO-005
     - Cambio rol justificado
     - Obligacion
     - DEBE
     - Gobernanza
   * - DEO-006
     - Password cumple politica
     - Obligacion
     - DEBE
     - Seguridad
   * - DEO-007
     - No roles conflictivos
     - Prohibicion
     - NO DEBE
     - BR_015
   * - DEO-008
     - No email externo
     - Prohibicion
     - NO DEBE
     - CNST_001
   * - DEO-009
     - No modificar BD IVR
     - Prohibicion
     - NO DEBE
     - BR_001
   * - DEO-010
     - No modificar auditoria
     - Prohibicion
     - NO DEBE
     - ALE-015
   * - DEO-011
     - Inactivo no login
     - Prohibicion
     - NO DEBE
     - Seguridad
   * - DEO-012
     - No exceder 50K export
     - Prohibicion
     - NO DEBE
     - Seguridad
   * - DEO-013
     - Admin cierra sesion
     - Permiso
     - PUEDE
     - R016
   * - DEO-014
     - Personalizar dashboard
     - Permiso
     - PUEDE
     - R009
   * - DEO-015
     - Analista consulta SQL
     - Permiso
     - PUEDE
     - R010
   * - DEO-016
     - Solo admin gestiona
     - Restriccion
     - SOLO
     - R001
   * - DEO-017
     - Solo buzon interno
     - Restriccion
     - UNICAMENTE
     - CNST_001
   * - DEO-018
     - Solo ETL nocturno
     - Restriccion
     - SOLO
     - BR_002
   * - DEO-019
     - Solo auditor ve logs
     - Restriccion
     - SOLO
     - R017
   * - DEO-020
     - 90 dias -> inactivo
     - Trigger
     - SI...ENTONCES
     - BR_003
   * - DEO-021
     - 3 intentos -> bloqueo
     - Trigger
     - SI...ENTONCES
     - Seguridad
   * - DEO-022
     - Alerta -> notificar
     - Trigger
     - SI...ENTONCES
     - Alertas
   * - DEO-023
     - >10K -> confirmar
     - Trigger
     - SI...ENTONCES
     - UX

----

8. Referencias
--------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`sbvr-01` - Conceptos Nucleares
- :ref:`sbvr-02` - Fact Types
- :ref:`sbvr-03` - Reglas Estructurales (aleticas)
- :ref:`sbvr-05` - Vocabulario Controlado
- :ref:`fnd-02` - Reglas de Negocio

Business Rules Referenciadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- BR_001: Fuente Operacional Inmutable
- BR_002: Sincronizacion ETL Nocturna
- BR_003: Usuario Inactivo por Tiempo
- BR_015: Separacion de Funciones (SoD)
- CNST_001: Sin Correo Electronico Externo

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
     - Version inicial con 23 reglas operativas

----

**Trazabilidad:** Este artefacto define las obligaciones y prohibiciones
del dominio (lo que DEBE SER). Complementa :ref:`sbvr-03` que define las
verdades estructurales (lo que ES). Las reglas operativas aqui definidas
se implementan como Business Rules en requisitos/reglas_negocio/.
