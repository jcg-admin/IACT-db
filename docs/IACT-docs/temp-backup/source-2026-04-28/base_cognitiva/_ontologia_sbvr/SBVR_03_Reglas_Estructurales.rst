.. meta::
   :artefacto: SBVR_03
   :tipo: Ontologia SBVR
   :dominio: base_cognitiva
   :subdominio: _ontologia_sbvr
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-20
   :ultimo_cambio: 2025-12-20
   :autor: Equipo IACT
   :clasificacion: Interno

.. _sbvr-03:

========================================
SBVR_03: Reglas Estructurales (Aleticas)
========================================


Proposito
---------

Este documento define las **reglas estructurales** (aleticas) del dominio
IACT siguiendo el estandar SBVR. Las reglas aleticas describen lo que **ES**
verdadero en el dominio - verdades estructurales que no pueden violarse.

.. note::

   **Modalidad Aletica (del griego aletheia = verdad):**

   - Describe la **estructura** del dominio
   - Define lo que **ES** (no lo que DEBE SER)
   - No puede violarse (si se viola, hay error en el modelo)
   - Keywords: ES, TIENE, EXISTE, CADA, EXACTAMENTE

----

1. Diferencia: Aletica vs Deontica
----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Aspecto
     - Aletica (Estructural)
     - Deontica (Operativa)
   * - Pregunta
     - Que ES?
     - Que DEBE SER?
   * - Naturaleza
     - Verdad del dominio
     - Obligacion/Prohibicion
   * - Violacion
     - Imposible (error modelo)
     - Posible (error operativo)
   * - Keywords
     - ES, TIENE, CADA
     - DEBE, NO DEBE, PUEDE
   * - Ejemplo
     - "Cada usuario TIENE username"
     - "Usuario DEBE tener rol"

----

2. Reglas de Identidad
----------------------

2.1 Unicidad de Usuario
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-001

   ENUNCIADO:
   Cada Usuario tiene exactamente un username.
   Cada username identifica exactamente un Usuario.

   TIPO: Identidad unica

   EXPRESION FORMAL:
   Usuario.username ES UNICO

   IMPLEMENTACION:
   CREATE TABLE users (
     username VARCHAR(100) UNIQUE NOT NULL
   );

   JUSTIFICACION:
   El username es el identificador de negocio del usuario.
   No pueden existir dos usuarios con el mismo username.

2.2 Unicidad de Email
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-002

   ENUNCIADO:
   Cada Usuario tiene exactamente un email.
   Cada email pertenece a exactamente un Usuario.

   TIPO: Identidad unica

   EXPRESION FORMAL:
   Usuario.email ES UNICO

   IMPLEMENTACION:
   CREATE TABLE users (
     email VARCHAR(255) UNIQUE NOT NULL
   );

2.3 Unicidad de Rol
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-003

   ENUNCIADO:
   Cada Rol tiene exactamente un codigo.
   Cada codigo de Rol es unico en el sistema.

   TIPO: Identidad unica

   EXPRESION FORMAL:
   Rol.codigo ES UNICO
   Rol.codigo TIENE formato "R" + 3 digitos (R001-R018)

   CATALOGO CERRADO:
   El sistema define exactamente 18 roles.
   No se pueden crear nuevos roles dinamicamente.

2.4 Unicidad de Sesion Activa
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-004

   ENUNCIADO:
   Cada Usuario tiene como maximo una Sesion activa.

   TIPO: Cardinalidad maxima

   EXPRESION FORMAL:
   COUNT(Sesion WHERE Usuario = X AND estado = ACTIVA) <= 1

   IMPLEMENTACION:
   CREATE UNIQUE INDEX idx_unique_active_session
   ON sessions (user_id)
   WHERE is_active = TRUE;

   JUSTIFICACION:
   Politica de seguridad: sesion unica por usuario.

----

3. Reglas de Existencia
-----------------------

3.1 Usuario tiene Segmento
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-005

   ENUNCIADO:
   Cada Usuario pertenece a exactamente un Segmento de Datos.

   TIPO: Existencia obligatoria

   EXPRESION FORMAL:
   PARA CADA Usuario EXISTE exactamente un Segmento
   TAL QUE Usuario pertenece_a Segmento

   IMPLEMENTACION:
   CREATE TABLE users (
     segment_id INT NOT NULL,
     FOREIGN KEY (segment_id) REFERENCES data_segments(segment_id)
   );

   JUSTIFICACION:
   El segmento determina el alcance de datos visible.
   Un usuario sin segmento no tendria datos visibles.

3.2 Rol tiene Permisos
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-006

   ENUNCIADO:
   Cada Rol contiene al menos un Permiso.

   TIPO: Existencia obligatoria

   EXPRESION FORMAL:
   PARA CADA Rol EXISTE al menos un Permiso
   TAL QUE Rol contiene Permiso

   JUSTIFICACION:
   Un rol sin permisos no tiene sentido funcional.
   Todo rol debe otorgar al menos una capacidad.

3.3 Llamada tiene Centro
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-007

   ENUNCIADO:
   Cada Llamada origina en exactamente un Centro.

   TIPO: Existencia obligatoria

   EXPRESION FORMAL:
   PARA CADA Llamada EXISTE exactamente un Centro
   TAL QUE Llamada origina_en Centro

   JUSTIFICACION:
   Una llamada sin centro de origen no puede clasificarse
   ni asignarse a un segmento de datos.

3.4 Alerta tiene Metrica
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-008

   ENUNCIADO:
   Cada Alerta monitorea exactamente una Metrica.

   TIPO: Existencia obligatoria

   EXPRESION FORMAL:
   PARA CADA Alerta EXISTE exactamente una Metrica
   TAL QUE Alerta monitorea Metrica

   JUSTIFICACION:
   Una alerta sin metrica no puede evaluar condiciones
   ni disparar notificaciones.

----

4. Reglas de Estado
-------------------

4.1 Estados de Usuario
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-009

   ENUNCIADO:
   Cada Usuario tiene exactamente un estado.
   El estado de Usuario es uno de: ACTIVO, INACTIVO, BLOQUEADO.

   TIPO: Enumeracion cerrada

   EXPRESION FORMAL:
   Usuario.estado IN ('ACTIVO', 'INACTIVO', 'BLOQUEADO')

   IMPLEMENTACION:
   CREATE TABLE users (
     status ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO') NOT NULL DEFAULT 'ACTIVO'
   );

   TRANSICIONES VALIDAS:
   ACTIVO -> INACTIVO (desactivacion)
   ACTIVO -> BLOQUEADO (bloqueo por seguridad)
   INACTIVO -> ACTIVO (reactivacion)
   BLOQUEADO -> ACTIVO (desbloqueo)

4.2 Estados de Sesion
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-010

   ENUNCIADO:
   Cada Sesion tiene exactamente un estado.
   El estado de Sesion es uno de: ACTIVE, EXPIRED, CLOSED.

   TIPO: Enumeracion cerrada

   EXPRESION FORMAL:
   Sesion.estado IN ('ACTIVE', 'EXPIRED', 'CLOSED')

   TRANSICIONES VALIDAS:
   ACTIVE -> EXPIRED (timeout automatico)
   ACTIVE -> CLOSED (logout voluntario o forzado)

   NOTA:
   EXPIRED y CLOSED son estados terminales.

4.3 Estados de Alerta
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-011

   ENUNCIADO:
   Cada Alerta tiene exactamente un estado.
   El estado de Alerta es uno de: ACTIVA, INACTIVA, DISPARADA.

   TIPO: Enumeracion cerrada

   EXPRESION FORMAL:
   Alerta.estado IN ('ACTIVA', 'INACTIVA', 'DISPARADA')

----

5. Reglas de Cardinalidad
-------------------------

5.1 Roles por Usuario
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-012

   ENUNCIADO:
   Un Usuario puede tener uno o mas Roles.
   No existe limite maximo de roles por usuario.

   TIPO: Cardinalidad minima

   EXPRESION FORMAL:
   COUNT(Rol WHERE Usuario tiene Rol) >= 1

   NOTA:
   La restriccion de minimo 1 rol es deontica (DEBE tener),
   no aletica. Estructuralmente, la relacion permite 0..N.
   Ver ALE-012-D en SBVR_04.

5.2 Permisos por Rol
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-013

   ENUNCIADO:
   Un Rol puede contener uno o mas Permisos.
   El numero de permisos por rol varia segun la funcion.

   TIPO: Cardinalidad variable

   EXPRESION FORMAL:
   COUNT(Permiso WHERE Rol contiene Permiso) >= 1

   EJEMPLOS:
   - R002 (USERS_VIEWER): 7 permisos (solo lectura)
   - R001 (USERS_FULL_MANAGER): 28 permisos (CRUD completo)
   - R016 (SYSTEM_ADMIN): 35 permisos (administracion)

5.3 Destinatarios por Alerta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-014

   ENUNCIADO:
   Una Alerta notifica a uno o mas Usuarios.

   TIPO: Cardinalidad minima

   EXPRESION FORMAL:
   COUNT(Usuario WHERE Alerta notifica_a Usuario) >= 1

   JUSTIFICACION:
   Una alerta sin destinatarios no cumple su proposito.

----

6. Reglas de Inmutabilidad
--------------------------

6.1 Registros de Auditoria
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-015

   ENUNCIADO:
   Los Registros de Auditoria son inmutables.
   Un Registro de Auditoria no puede modificarse despues de creado.
   Un Registro de Auditoria no puede eliminarse.

   TIPO: Inmutabilidad

   EXPRESION FORMAL:
   Registro_Auditoria.created_at ES INMUTABLE
   Registro_Auditoria.* NO PERMITE UPDATE
   Registro_Auditoria NO PERMITE DELETE

   IMPLEMENTACION:
   CREATE TRIGGER prevent_audit_modification
   BEFORE UPDATE ON audit_logs
   FOR EACH ROW
   BEGIN
     SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'Logs de auditoria son inmutables';
   END;

6.2 Base de Datos IVR
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-016

   ENUNCIADO:
   La base de datos MySQL del sistema IVR es de solo lectura
   para el sistema IACT.

   TIPO: Inmutabilidad (externa)

   EXPRESION FORMAL:
   Sistema_IVR.datos NO PERMITE INSERT desde IACT
   Sistema_IVR.datos NO PERMITE UPDATE desde IACT
   Sistema_IVR.datos NO PERMITE DELETE desde IACT

   JUSTIFICACION:
   IACT es sistema de analitica, no sistema transaccional.
   La fuente de verdad para datos de llamadas es el IVR.

   REFERENCIA:
   BR_001: Fuente Operacional Inmutable

----

7. Reglas de Catalogo Cerrado
-----------------------------

7.1 Catalogo de Roles
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-017

   ENUNCIADO:
   El sistema IACT define exactamente 18 roles funcionales.
   El catalogo de roles es cerrado (no extensible dinamicamente).

   TIPO: Catalogo cerrado

   EXPRESION FORMAL:
   COUNT(Rol) = 18
   Rol.codigo IN ('R001'..'R018')

   CATALOGO COMPLETO:
   R001-R003: Gestion de Usuarios (3)
   R004-R007: Reportes (4)
   R008-R009: Visualizacion (2)
   R010: Analisis (1)
   R011-R014: Alertas (4)
   R015-R018: Administracion (4)

   JUSTIFICACION:
   Roles predefinidos basados en funciones del sistema.
   Nuevos roles requieren cambio de version del sistema.

7.2 Catalogo de Segmentos
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-018

   ENUNCIADO:
   Los Segmentos de Datos son predefinidos por administracion.
   Los segmentos corresponden a centros o consolidados.

   TIPO: Catalogo administrado

   SEGMENTOS CONOCIDOS:
   - DATOS_CONSOLIDADOS (todos los centros)
   - CENTRO_NORTE
   - CENTRO_SUR
   - CENTRO_ORIENTE
   - CENTRO_OCCIDENTE

   NOTA:
   A diferencia de roles, los segmentos pueden extenderse
   mediante configuracion (no requiere cambio de codigo).

7.3 Catalogo de Modulos
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-019

   ENUNCIADO:
   El sistema IACT tiene 6 modulos funcionales.

   TIPO: Catalogo cerrado

   MODULOS:
   1. Gestion de Usuarios
   2. Reportes
   3. Dashboard
   4. Alertas
   5. Auditoria
   6. Administracion del Sistema

   EXPRESION FORMAL:
   COUNT(Modulo) = 6

----

8. Reglas de Herencia
---------------------

8.1 Sin Herencia de Roles
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-020

   ENUNCIADO:
   Los roles son independientes (Flat RBAC).
   Un rol NO hereda permisos de otro rol.

   TIPO: Anti-herencia

   EXPRESION FORMAL:
   NO EXISTE relacion "Rol hereda_de Rol"

   CONSECUENCIA:
   Los permisos de un usuario son la UNION de los permisos
   de todos sus roles asignados, sin herencia implicita.

   JUSTIFICACION:
   Modelo NIST Flat RBAC: permisos explicitos, sin jerarquia.

8.2 Acumulacion de Permisos
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   REGLA ESTRUCTURAL: ALE-021

   ENUNCIADO:
   Los permisos de un Usuario son la union de los permisos
   de todos sus Roles asignados.

   TIPO: Composicion

   EXPRESION FORMAL:
   Usuario.permisos_efectivos =
     UNION(Rol.permisos PARA CADA Rol DONDE Usuario tiene Rol)

   EJEMPLO:
   Usuario con R004 + R008:
   Permisos = permisos(R004) UNION permisos(R008)

   NOTA:
   Si un permiso esta en multiples roles, se cuenta una vez.

----

9. Matriz de Reglas Estructurales
---------------------------------

.. list-table::
   :header-rows: 1
   :widths: 12 35 25 28

   * - Codigo
     - Regla
     - Tipo
     - Conceptos
   * - ALE-001
     - Username es unico
     - Identidad
     - Usuario
   * - ALE-002
     - Email es unico
     - Identidad
     - Usuario
   * - ALE-003
     - Codigo de Rol es unico
     - Identidad
     - Rol
   * - ALE-004
     - Una sesion activa por usuario
     - Cardinalidad
     - Usuario, Sesion
   * - ALE-005
     - Usuario tiene un segmento
     - Existencia
     - Usuario, Segmento
   * - ALE-006
     - Rol tiene permisos
     - Existencia
     - Rol, Permiso
   * - ALE-007
     - Llamada tiene centro
     - Existencia
     - Llamada, Centro
   * - ALE-008
     - Alerta tiene metrica
     - Existencia
     - Alerta, Metrica
   * - ALE-009
     - Estados de usuario
     - Enumeracion
     - Usuario
   * - ALE-010
     - Estados de sesion
     - Enumeracion
     - Sesion
   * - ALE-011
     - Estados de alerta
     - Enumeracion
     - Alerta
   * - ALE-012
     - Roles por usuario
     - Cardinalidad
     - Usuario, Rol
   * - ALE-013
     - Permisos por rol
     - Cardinalidad
     - Rol, Permiso
   * - ALE-014
     - Destinatarios por alerta
     - Cardinalidad
     - Alerta, Usuario
   * - ALE-015
     - Auditoria inmutable
     - Inmutabilidad
     - Registro_Auditoria
   * - ALE-016
     - BD IVR solo lectura
     - Inmutabilidad
     - Sistema_IVR
   * - ALE-017
     - 18 roles fijos
     - Catalogo cerrado
     - Rol
   * - ALE-018
     - Segmentos administrados
     - Catalogo admin
     - Segmento
   * - ALE-019
     - 6 modulos fijos
     - Catalogo cerrado
     - Modulo
   * - ALE-020
     - Sin herencia de roles
     - Anti-herencia
     - Rol
   * - ALE-021
     - Permisos acumulados
     - Composicion
     - Usuario, Rol, Permiso

----

10. Referencias
---------------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`sbvr-01` - Conceptos Nucleares
- :ref:`sbvr-02` - Fact Types
- :ref:`sbvr-04` - Reglas Operativas (deonticas)
- :ref:`fnd-02` - Reglas de Negocio

Fuentes
^^^^^^^

- OMG SBVR 1.5 Specification (Alethic Modality)
- Paper IBM: "SBVR Use Cases" (structural vs operative rules)
- NIST RBAC Model (Flat RBAC)

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
     - Version inicial con 21 reglas estructurales

----

**Trazabilidad:** Este artefacto define las verdades estructurales del
dominio (lo que ES). Complementa :ref:`sbvr-04` que define las obligaciones
(lo que DEBE SER). Juntos forman la base semantica para las Business Rules
en requisitos/reglas_negocio/.
