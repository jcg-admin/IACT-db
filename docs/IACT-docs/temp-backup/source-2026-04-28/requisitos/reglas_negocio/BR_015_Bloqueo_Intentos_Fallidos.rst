.. meta::
   :artefacto: BR_015
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-015:

=====================================
BR_015: Bloqueo por Intentos Fallidos
=====================================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_015
   * - **Nombre**
     - Bloqueo por Intentos Fallidos
   * - **Tipo**
     - Desencadenador
   * - **Categoría**
     - Seguridad / Autenticación
   * - **Criticidad**
     - Crítica
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_015**

   CUANDO un usuario acumula 5 intentos fallidos de autenticación consecutivos,
   ENTONCES el sistema DEBE bloquear la cuenta temporalmente por 30 minutos
   y registrar el evento de seguridad en auditoría.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - intento_fallido: Autenticación con credenciales incorrectas
     - limite_intentos: 5 intentos consecutivos
     - periodo_bloqueo: 30 minutos
     - cuenta_bloqueada: Estado temporal que impide autenticación

   REGLA DESENCADENADORA:
     SI contador_intentos_fallidos >= 5
     ENTONCES:
       1. Sistema DEBE cambiar estado cuenta a BLOQUEADA
       2. Sistema DEBE registrar timestamp de bloqueo
       3. Sistema DEBE registrar evento en auditoría
       4. Sistema DEBE desbloquear automáticamente tras 30 minutos

1.3 Justificación
^^^^^^^^^^^^^^^^^

El bloqueo por intentos fallidos protege contra:

- **Ataques de fuerza bruta**: Limita intentos de adivinación
- **Credential stuffing**: Dificulta uso de credenciales robadas
- **Acceso no autorizado**: Protege cuentas comprometidas
- **Cumplimiento**: Requisito de seguridad estándar

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Desencadenador**
   * - 
     - [X] **Desencadenador**: SI intentos >= 5 ENTONCES bloquear

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Dinámica - evaluada en cada login
- **Automatizable**: Sí - lógica en autenticación
- **Alcance**: MOD_Auth - proceso de login

----

3. Aplicación en Sistema
------------------------

3.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripción de Aplicación
   * - UC_AUTH_01
     - Iniciar Sesión - Evalúa intentos fallidos
   * - API /auth/login
     - Incrementa contador en cada fallo
   * - Modelo User
     - Campos: failed_attempts, locked_until

3.2 Parámetros Configurables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 20 50
   :header-rows: 1

   * - Parámetro
     - Valor
     - Descripción
   * - MAX_FAILED_ATTEMPTS
     - 5
     - Intentos antes de bloqueo
   * - LOCKOUT_DURATION
     - 30 min
     - Duración del bloqueo
   * - RESET_AFTER_SUCCESS
     - True
     - Reinicia contador tras login exitoso

----

4. Implementación Técnica
-------------------------

4.1 Modelo Django
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/users/models.py
   
   class User(AbstractBaseUser):
       failed_attempts = models.IntegerField(default=0)
       locked_until = models.DateTimeField(null=True, blank=True)
       
       def is_locked(self):
           """BR_015: Verifica si cuenta está bloqueada."""
           if self.locked_until and self.locked_until > timezone.now():
               return True
           return False
       
       def register_failed_attempt(self):
           """BR_015: Registra intento fallido."""
           self.failed_attempts += 1
           if self.failed_attempts >= 5:
               self.locked_until = timezone.now() + timedelta(minutes=30)
           self.save()
       
       def reset_failed_attempts(self):
           """BR_015: Reinicia contador tras login exitoso."""
           self.failed_attempts = 0
           self.locked_until = None
           self.save()

----

5. Trazabilidad
---------------

- **Origen**: CNST_005 (Seguridad DRF Checklist)
- **UC Relacionados**: UC_AUTH_01 (FA-1: Usuario bloqueado)
- **CNST**: CNST_005

----

6. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 70
   :header-rows: 1

   * - Versión
     - Fecha
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Versión inicial

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
