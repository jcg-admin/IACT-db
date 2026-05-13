.. =============================================================================
.. ARQ_MOD_001_AUTH.rst
.. Modulo Funcional: Autenticacion y Sesiones
.. Version: 1.0.0
.. =============================================================================

================================================
ARQ_MOD_001: Autenticacion y Sesiones (AUTH)
================================================

.. metadata::
   :id: ARQ_MOD_001
   :codigo: AUTH
   :nombre: Autenticacion y Sesiones
   :version: 1.0.0
   :estado: APROBADO
   :fecha_creacion: 2025-12-22
   :ultima_actualizacion: 2025-12-22
   :autor: Equipo IACT
   :revisor: Arquitecto de Software

.. contents:: Contenido
   :local:
   :depth: 2

----

1. Proposito
============

El modulo AUTH gestiona la **autenticacion de usuarios** y el **ciclo de vida
de las sesiones** en el sistema IACT.

**Pregunta clave que responde:**

   *"¿Quien eres? ¿Tu sesion es valida?"*

Este modulo es el punto de entrada al sistema. Valida credenciales, genera
tokens JWT, gestiona sesiones en base de datos, y controla el timeout de
inactividad.

**Lo demas lo decide:** ARQ_MOD_003_RBAC_CORE (permisos y accesos).

----

2. Alcance
==========

2.1 Incluye
-----------

- Login de usuario (validacion de credenciales)
- Logout del sistema (invalidacion de sesion)
- Generacion y validacion de tokens JWT
- Gestion de refresh tokens
- Sesion unica por usuario (CNST_002)
- Timeout de sesion por inactividad (15 minutos)
- Validacion de IP + User-Agent
- Recuperacion de contrasena via preguntas de seguridad
- Cambio de contrasena

2.2 Excluye (NO incluye)
------------------------

- Definicion de roles y permisos → Pertenece a **ARQ_MOD_003_RBAC_CORE**
- Validacion de que puede hacer el usuario → Pertenece a **ARQ_MOD_003_RBAC_CORE**
- Gestion de datos del usuario (nombre, email, etc.) → Pertenece a **ARQ_MOD_002_USER_IDENTITY**
- Alertas por intentos fallidos → Pertenece a **ARQ_MOD_006_ALERTS**
- Registro de eventos de login/logout → Pertenece a **ARQ_MOD_007_AUDIT**

----

3. Responsabilidades
====================

3.1 PUEDE Hacer
---------------

.. list-table::
   :widths: 60 20 20
   :header-rows: 1

   * - Responsabilidad
     - UC Relacionado
     - CNST Aplicable
   * - Validar credenciales (username + password)
     - UC_001
     - CNST_005
   * - Generar token JWT con claims basicos
     - UC_001
     - CNST_005
   * - Registrar sesion en base de datos
     - UC_001
     - CNST_002
   * - Invalidar sesion previa (sesion unica)
     - UC_001
     - CNST_002
   * - Cerrar sesion y blacklist de token
     - UC_002
     - CNST_002
   * - Validar preguntas de seguridad
     - UC_003
     - CNST_001
   * - Generar contrasena temporal
     - UC_003
     - CNST_001
   * - Cambiar contrasena con validacion
     - UC_004
     - CNST_005
   * - Listar sesiones activas del usuario
     - UC_005
     - CNST_002
   * - Cerrar sesiones remotas
     - UC_005
     - CNST_002
   * - Aplicar timeout de 15 minutos
     - UC_005
     - CNST_002

3.2 NO PUEDE Hacer (Violaciones)
--------------------------------

.. warning::

   Las siguientes acciones **violan la separacion de responsabilidades**
   y NO deben implementarse en este modulo:

- **Decidir si un usuario puede ver un modulo**
  
  - Ejemplo: "Si es ADMIN puede ver X modulo"
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**

- **Validar permisos especificos**
  
  - Ejemplo: "Si no tiene rol R017 no puede ver auditoria"
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE**

- **Generar alertas por fallos de login**
  
  - Ejemplo: "Si falla 5 veces, generar alerta"
  - Eso es responsabilidad de → **ARQ_MOD_006_ALERTS**

- **Bloquear usuario por intentos fallidos**
  
  - La logica de bloqueo es de seguridad avanzada
  - Eso es responsabilidad de → **ARQ_MOD_003_RBAC_CORE** (enforcers)

- **Enviar notificaciones por email**
  
  - Viola restriccion critica CNST_001
  - Solo se usa buzon interno → **ARQ_MOD_006_ALERTS**

- **Registrar eventos de auditoria**
  
  - AUTH emite el evento, pero no lo registra
  - Eso es responsabilidad de → **ARQ_MOD_007_AUDIT**

----

4. Dependencias
===============

4.1 Depende de
--------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_002_USER_IDENTITY
     - Necesita validar que el usuario existe y esta activo
   * - ARQ_MOD_003_RBAC_CORE
     - Consulta roles basicos para incluir en claims JWT

4.2 Es Requerido por
--------------------

.. list-table::
   :widths: 25 75
   :header-rows: 1

   * - Modulo
     - Razon
   * - ARQ_MOD_003_RBAC_CORE
     - Necesita sesion valida para calcular permisos
   * - ARQ_MOD_005_VIS_REPORTS
     - Requiere autenticacion para acceder
   * - ARQ_MOD_006_ALERTS
     - Requiere autenticacion para ver notificaciones
   * - ARQ_MOD_007_AUDIT
     - Registra eventos de login/logout
   * - TODOS
     - Todos los modulos requieren sesion autenticada

----

5. Componentes Tecnicos
=======================

5.1 Apps Django
---------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - App
     - Descripcion
   * - apps.users
     - Contiene vistas de login, logout, modelos de sesion

5.2 Modelos de Datos
--------------------

- **DSC_MOD_001_User** - Usuario del sistema (referencia)
- **DSC_MOD_004_Session** - Sesion activa en BD

.. code-block:: python

   # Modelo de Sesion (apps/users/models.py)
   class UserSession(models.Model):
       user = models.ForeignKey(User, on_delete=models.CASCADE)
       token_hash = models.CharField(max_length=64, unique=True)
       ip_address = models.GenericIPAddressField()
       user_agent = models.TextField()
       created_at = models.DateTimeField(auto_now_add=True)
       last_activity = models.DateTimeField(auto_now=True)
       is_active = models.BooleanField(default=True)

5.3 APIs Expuestas
------------------

- **API_001_Auth_Endpoints**

.. list-table::
   :widths: 20 30 50
   :header-rows: 1

   * - Metodo
     - Endpoint
     - Descripcion
   * - POST
     - /api/v1/auth/login
     - Iniciar sesion
   * - POST
     - /api/v1/auth/logout
     - Cerrar sesion
   * - POST
     - /api/v1/auth/refresh
     - Renovar token
   * - POST
     - /api/v1/auth/password/recovery
     - Recuperar contrasena
   * - PUT
     - /api/v1/auth/password/change
     - Cambiar contrasena
   * - GET
     - /api/v1/auth/sessions
     - Listar sesiones activas
   * - DELETE
     - /api/v1/auth/sessions/{id}
     - Cerrar sesion especifica

5.4 Middleware
--------------

.. code-block:: python

   # apps/common/middleware.py
   
   class SessionTimeoutMiddleware:
       """Verifica timeout de 15 minutos por inactividad"""
       
   class SingleSessionMiddleware:
       """Garantiza sesion unica por usuario"""

----

6. Restricciones Aplicables
===========================

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - CNST
     - Descripcion y Aplicacion
   * - CNST_001
     - **Comunicaciones Prohibidas**: No enviar email para recuperacion. 
       Usar preguntas de seguridad + buzon interno.
   * - CNST_002
     - **Gestion Sesiones BD**: Sesiones en PostgreSQL, no Redis. 
       Sesion unica por usuario. Timeout 15 min. Validar IP+UA.
   * - CNST_005
     - **Seguridad DRF**: JWT con SimpleJWT. Blacklist de tokens. 
       HTTPS obligatorio.

----

7. Casos de Uso Asociados
=========================

.. list-table::
   :widths: 12 35 53
   :header-rows: 1

   * - UC ID
     - Nombre
     - Descripcion
   * - UC_001
     - Iniciar_Sesion
     - Usuario ingresa credenciales y obtiene sesion valida
   * - UC_002
     - Cerrar_Sesion
     - Usuario cierra sesion, token se invalida
   * - UC_003
     - Recuperar_Contrasena
     - Usuario recupera acceso via preguntas de seguridad
   * - UC_004
     - Cambiar_Contrasena
     - Usuario cambia su contrasena actual
   * - UC_005
     - Gestionar_Sesiones_Activas
     - Usuario ve y cierra sus sesiones remotas

----

8. Requisitos Funcionales Derivados
===================================

.. list-table::
   :widths: 12 40 20 28
   :header-rows: 1

   * - FR ID
     - Nombre
     - Deriva de
     - Descripcion
   * - FR_001
     - Validar_Credenciales
     - UC_001
     - Verificar username/password contra BD
   * - FR_002
     - Generar_Token_JWT
     - UC_001
     - Crear JWT con claims de usuario
   * - FR_003
     - Registrar_Sesion_BD
     - UC_001
     - Insertar sesion en tabla UserSession
   * - FR_004
     - Invalidar_Token
     - UC_002
     - Agregar token a blacklist
   * - FR_005
     - Verificar_Preguntas_Seguridad
     - UC_003
     - Validar respuestas de seguridad

----

9. Flujo de Autenticacion
=========================

.. code-block:: text

   +-------------+     +-------------+     +----------------+
   |   Cliente   |     | ARQ_MOD_001 |     | ARQ_MOD_002    |
   |   (React)   |     |    AUTH     |     | USER_IDENTITY  |
   +------+------+     +------+------+     +-------+--------+
          |                   |                    |
          | POST /login       |                    |
          |------------------>|                    |
          |                   | Validar usuario    |
          |                   |------------------->|
          |                   |    Usuario activo  |
          |                   |<-------------------|
          |                   |                    |
          |                   | Validar password   |
          |                   |----+               |
          |                   |    | (bcrypt)      |
          |                   |<---+               |
          |                   |                    |
          |                   | Crear sesion BD    |
          |                   |----+               |
          |                   |    | (UserSession) |
          |                   |<---+               |
          |                   |                    |
          |                   | Generar JWT        |
          |                   |----+               |
          |                   |    | (SimpleJWT)   |
          |                   |<---+               |
          |                   |                    |
          |   200 + JWT       |                    |
          |<------------------|                    |
          |                   |                    |

----

10. Seguridad
=============

10.1 Validaciones Obligatorias
------------------------------

- Password hasheado con bcrypt (minimo 12 rounds)
- Token JWT firmado con HS256, expiracion 1 hora
- Refresh token con expiracion 24 horas
- Validacion de IP en cada request
- Validacion de User-Agent en cada request

10.2 Ataques Mitigados
----------------------

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Ataque
     - Mitigacion
   * - Brute Force
     - Rate limiting en login (5 intentos/minuto)
   * - Session Hijacking
     - Validacion IP + User-Agent
   * - Token Theft
     - Blacklist de tokens, sesion unica
   * - CSRF
     - Tokens JWT (no cookies de sesion)

----

11. Diagrama de Contexto
========================

.. code-block:: text

                        +------------------+
                        |                  |
                        |   ARQ_MOD_001    |
                        |      AUTH        |
                        |                  |
                        +--------+---------+
                                 |
          +----------------------+----------------------+
          |                      |                      |
          v                      v                      v
   +-------------+      +----------------+      +-------------+
   | ARQ_MOD_002 |      | ARQ_MOD_003    |      | ARQ_MOD_007 |
   | USER_IDENTITY|      | RBAC_CORE      |      | AUDIT       |
   | (validar    |      | (roles para    |      | (registrar  |
   |  usuario)   |      |  claims JWT)   |      |  eventos)   |
   +-------------+      +----------------+      +-------------+

----

12. Metricas y Monitoreo
========================

.. list-table::
   :widths: 40 30 30
   :header-rows: 1

   * - Metrica
     - Tipo
     - Umbral Alerta
   * - Logins exitosos/hora
     - Counter
     - N/A (informativo)
   * - Logins fallidos/hora
     - Counter
     - > 100 (posible ataque)
   * - Sesiones activas
     - Gauge
     - > 500 (capacidad)
   * - Tiempo de respuesta login
     - Histogram
     - > 2s (degradacion)

----

13. Historial de Cambios
========================

.. list-table::
   :widths: 12 15 73
   :header-rows: 1

   * - Version
     - Fecha
     - Cambios
   * - 1.0.0
     - 2025-12-22
     - Version inicial. Definicion de proposito, alcance, 
       responsabilidades PUEDE/NO PUEDE, dependencias, 
       componentes tecnicos, UC y FR asociados.

----

*Documento de Arquitectura - ARQ_MOD_001_AUTH*
*Proyecto IACT Dashboard Analytics*
*Version 1.0.0 - 2025-12-22*
