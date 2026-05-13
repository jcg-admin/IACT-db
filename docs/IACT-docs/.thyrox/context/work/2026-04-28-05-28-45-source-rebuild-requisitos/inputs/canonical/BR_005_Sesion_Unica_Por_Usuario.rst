.. meta::
   :artefacto: BR_005
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-04
   :ultimo_cambio: 2026-01-04
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-005:

================================
BR_005: Sesion Unica por Usuario
================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_005
   * - **Nombre**
     - Sesion Unica por Usuario
   * - **Tipo**
     - Restriccion
   * - **Categoria**
     - Seguridad
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

Cada usuario PUEDE tener unicamente UNA sesion activa a la vez.
SI un usuario inicia sesion en un nuevo dispositivo,
ENTONCES la sesion anterior DEBE ser invalidada automaticamente.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

::

   VOCABULARIO:
     - Sesion activa: Token JWT valido asociado a usuario
     - Nuevo login: Autenticacion exitosa desde cualquier dispositivo
     - Invalidacion: Revocacion de token anterior

   REGLA:
     Es obligatorio que cada usuario tenga maximo una sesion activa.
     Es obligatorio que el nuevo login invalide sesiones previas.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

Previene uso compartido de credenciales, detecta accesos no autorizados
(el usuario legitimo pierde sesion si alguien mas accede), y simplifica
auditoria de accesos al tener una sola sesion rastreable por usuario.

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

[X] **Restriccion**: Limita acciones o valores permitidos

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Estatica
- **Automatizable**: Si - gestion de tokens en backend
- **Alcance**: MOD_Auth

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_002_Gestion_Sesiones_BD
   * - **Seccion**
     - Politica de Sesiones
   * - **Version**
     - 1.0.0
   * - **Tipo Fuente**
     - CNST

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: admin_seguridad (AGR-008)
- **Proceso de Cambio**: Revision de politica de seguridad
- **Frecuencia de Revision**: Anual

----

4. Aplicacion en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripcion de Aplicacion
   * - MOD_Auth
     - Invalida token anterior al crear nuevo
   * - Middleware JWT
     - Verifica validez de token en cada request
   * - Base Analytics
     - Tabla de sesiones activas

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los usuarios del sistema

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones definidas.

----

5. Trazabilidad
---------------

5.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Relacion
   * - CNST_002
     - Define politica de gestion de sesiones

5.2 BReq Influenciados
^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BReq
     - Descripcion
   * - BReq-004
     - Cumplimiento de Seguridad

5.3 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC-001
     - Inicio de Sesion - invalida sesion previa
   * - UC-002
     - Cierre de Sesion - elimina sesion activa
   * - UC-005
     - Gestionar Sesiones - muestra sesion unica

----

6. Verificacion
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Solo existe un token activo por usuario en cualquier momento
2. Login nuevo invalida token anterior
3. Requests con token invalidado reciben 401

6.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Por transaccion de login
- **Responsable**: MOD_Auth

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Sesion anterior cerrada automaticamente
- Usuario anterior recibe error 401
- Registro en log de auditoria

----

7. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-04
     - Equipo IACT
     - Version inicial