.. meta::
   :artefacto: BR_003
   :tipo: Business Rule
   :subtipo: Inferencia
   :modalidad: Aletica
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-003:

==============================================================================
BR_003: Usuario Inactivo por 90 Dias
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   SI un usuario no ha iniciado sesion en los ultimos 90 dias,
   ENTONCES el usuario se considera en estado INACTIVO.

**Enunciado SBVR:**

   A user is considered inactive if the user has not logged in
   for 90 consecutive days.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Inferencia (Inference)
   * - **Modalidad**
     - Aletica (deriva nuevo hecho de hechos existentes)
   * - **Estatica/Dinamica**
     - Dinamica (el umbral de 90 dias puede ajustarse)

**Nota:** Este es una INFERENCIA porque el resultado (estado INACTIVO)
es un cambio de estado INTERNO que no genera accion observable
directamente. No hay notificacion, no hay mensaje al usuario, solo
cambia un flag en la base de datos.

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Politica de Seguridad - Gestion de Accesos
   * - **Documento**
     - POL_001 Seguridad de la Informacion
   * - **Seccion**
     - 5.3 Ciclo de Vida de Cuentas de Usuario
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Seguridad:** Cuentas sin uso representan riesgo de acceso no
   autorizado si las credenciales son comprometidas.

2. **Higiene de datos:** Identificar cuentas inactivas permite
   planificar su revision o desactivacion.

3. **Compliance:** Politicas de seguridad requieren monitorear
   cuentas sin actividad.

4. **Licenciamiento:** En algunos casos, cuentas inactivas pueden
   liberarse para reasignacion.

----

Condicion y Resultado
---------------------

Condicion (SI)
^^^^^^^^^^^^^^

.. code-block:: text

   Condicion: (fecha_actual - ultimo_login) > 90 dias

   Variables:
   - fecha_actual: NOW()
   - ultimo_login: users.last_login_at
   - umbral: 90 dias (configurable)

   Calculo:
   dias_sin_login = DATEDIFF(NOW(), last_login_at)
   condicion_cumplida = dias_sin_login > 90

Resultado (ENTONCES)
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Resultado: usuario.estado = 'INACTIVO'

   Este resultado es:
   - INTERNO: Solo cambia un campo en BD
   - NO OBSERVABLE directamente por el usuario
   - NO genera notificacion (seria Desencadenador)
   - Afecta logica posterior (ej: reportes, alertas de admin)

Diferencia con Desencadenador
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Si la regla fuera:
   "SI usuario inactivo 90 dias, ENTONCES notificar al admin"
   --> Seria DESENCADENADOR (accion observable: notificacion)

   Pero la regla dice:
   "SI usuario inactivo 90 dias, ENTONCES se considera INACTIVO"
   --> Es INFERENCIA (solo cambia estado interno)

----

No Genera Caso de Uso
---------------------

Esta BR NO genera Caso de Uso porque es tipo Inferencia.
El cambio de estado ocurre automaticamente sin interaccion de usuario.

Implementacion sugerida:

.. code-block:: text

   Opcion A: Job batch diario
   - Proceso nocturno revisa usuarios
   - Actualiza estado a INACTIVO si aplica

   Opcion B: Lazy evaluation
   - Se evalua cuando se consulta el usuario
   - Calculo dinamico basado en last_login_at

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-USR.10
     - Sistema DEBE calcular dias desde ultimo login para cada usuario
   * - FR-USR.11
     - Sistema DEBE marcar usuario como INACTIVO si dias > 90
   * - FR-USR.12
     - Sistema DEBE permitir consultar usuarios en estado INACTIVO
   * - FR-USR.13
     - Sistema DEBE incluir estado INACTIVO en filtros de listado

----

Estados de Usuario
------------------

.. code-block:: text

   Estados posibles del usuario:

   PENDIENTE_CONFIGURACION  (inicial, recien creado)
          |
          v
        ACTIVO  <------------+
          |                  |
          | (90 dias         | (admin reactiva
          |  sin login)      |  manualmente)
          v                  |
       INACTIVO  ------------+
          |
          | (admin desactiva)
          v
       BLOQUEADO

   Nota: INACTIVO es diferente de BLOQUEADO
   - INACTIVO: Automatico por inactividad, puede reactivarse
   - BLOQUEADO: Manual por admin o seguridad, requiere revision

----

Impacto en el Sistema
---------------------

Donde se Usa el Estado INACTIVO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Componente
     - Uso
   * - UC_009 Listar Usuarios
     - Filtro por estado incluye INACTIVO
   * - Reportes de Seguridad
     - Listar usuarios inactivos para revision
   * - Dashboard Admin
     - Contador de cuentas inactivas
   * - Proceso de Auditoria
     - Identificar cuentas para desactivacion

Que NO Hace el Estado INACTIVO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Accion
     - Razon
   * - Bloquear login
     - Usuario INACTIVO aun puede loguearse
   * - Notificar usuario
     - Seria Desencadenador, no Inferencia
   * - Eliminar cuenta
     - Requiere accion manual de admin
   * - Revocar permisos
     - Permisos se mantienen, solo estado cambia

----

Parametros Configurables
------------------------

.. list-table::
   :widths: 30 20 50

   * - Parametro
     - Valor Default
     - Descripcion
   * - DIAS_INACTIVIDAD
     - 90
     - Dias sin login para marcar inactivo
   * - FRECUENCIA_REVISION
     - Diaria
     - Frecuencia del job de revision
   * - HORA_REVISION
     - 01:00
     - Hora del job (despues del ETL)

----

Implementacion Tecnica
----------------------

Job Batch
^^^^^^^^^

.. code-block:: python

   # tasks/user_inactivity.py
   from datetime import timedelta
   from django.utils import timezone
   from users.models import User

   def mark_inactive_users():
       """
       BR_003: Marcar usuarios inactivos por 90 dias
       Tipo: Inferencia (cambio de estado interno)
       """
       threshold = timezone.now() - timedelta(days=90)

       updated = User.objects.filter(
           last_login_at__lt=threshold,
           estado='ACTIVO'
       ).update(
           estado='INACTIVO',
           inactivo_desde=timezone.now()
       )

       return f"Usuarios marcados como inactivos: {updated}"

Query de Consulta
^^^^^^^^^^^^^^^^^

.. code-block:: sql

   -- Usuarios que deberian marcarse como inactivos
   SELECT user_id, username, last_login_at,
          DATEDIFF(NOW(), last_login_at) as dias_sin_login
   FROM users
   WHERE estado = 'ACTIVO'
     AND DATEDIFF(NOW(), last_login_at) > 90;

----

Restricciones Relacionadas
--------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 50 30

   * - CNST
     - Nombre
     - Relacion
   * - CNST_005
     - Seguridad DRF Checklist
     - Define estados validos de usuario

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. Usuario sin login por 91 dias tiene estado INACTIVO
2. Usuario con login hace 89 dias mantiene estado ACTIVO
3. Usuario INACTIVO puede loguearse (vuelve a ACTIVO)
4. Lista de usuarios permite filtrar por estado INACTIVO

Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^

- Tests unitarios del job batch
- Tests de integracion del ciclo de vida
- Query de validacion post-ejecucion

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-005` - BR_005 Sesion Unica (relacionado con login)
- :ref:`br-009` - BR_009 Bajas Logicas
- :ref:`fnd-02` - Fundamentos de Reglas de Negocio (seccion Inferencia)
- MOD_Users - Modulo responsable

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
     - 2026-01-03
     - Equipo IACT
     - Version inicial aprobada

----

**Trazabilidad:**

- Origen: POL_001 Seguridad de la Informacion
- Tipo: Inferencia (NO genera UC)
- Deriva: FR-USR.10, FR-USR.11, FR-USR.12, FR-USR.13
- Modulo: MOD_Users
