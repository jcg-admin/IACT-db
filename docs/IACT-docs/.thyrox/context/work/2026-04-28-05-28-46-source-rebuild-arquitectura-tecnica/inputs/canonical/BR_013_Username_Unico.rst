.. meta::
   :artefacto: BR_013
   :tipo: Business Rule
   :subtipo: Hecho
   :modalidad: Aletica
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-03
   :ultimo_cambio: 2026-01-03
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-013:

==============================================================================
BR_013: Username es Unico
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Definicion
----------

**Enunciado Formal:**

   Cada usuario tiene exactamente un username unico en el sistema.
   No pueden existir dos usuarios con el mismo username.
   El email tambien debe ser unico.

**Enunciado SBVR:**

   Each user has exactly one unique username.
   Each user has exactly one unique email address.

----

Clasificacion
-------------

.. list-table::
   :widths: 30 70

   * - **Tipo**
     - Hecho (Fact)
   * - **Modalidad**
     - Aletica (verdad de identidad)
   * - **Estatica/Dinamica**
     - Estatica (estructura fundamental)

----

Fuente
------

.. list-table::
   :widths: 30 70

   * - **Origen**
     - Modelo de Datos, Principios de Autenticacion
   * - **Documento**
     - MDL_001 Modelo Conceptual
   * - **Fecha Vigencia**
     - 2025-01-01

----

Justificacion
-------------

1. **Identificacion:** Username es el identificador de login.

2. **No ambiguedad:** Sistema debe identificar usuario sin duda.

3. **Auditoria:** Acciones se registran por username unico.

4. **Estandar:** Practica universal en sistemas de autenticacion.

----

Implementacion
--------------

.. code-block:: sql

   CREATE TABLE users (
       id SERIAL PRIMARY KEY,
       username VARCHAR(100) NOT NULL,
       email VARCHAR(255) NOT NULL,
       -- ... otros campos ...

       CONSTRAINT uq_username UNIQUE (username),
       CONSTRAINT uq_email UNIQUE (email)
   );

   -- Indices para performance en lookups
   CREATE INDEX idx_users_username ON users(username);
   CREATE INDEX idx_users_email ON users(email);

----

Validacion en Creacion
----------------------

.. code-block:: python

   # services/users.py

   class UserService:

       def create(self, username, email, ...):
           """
           BR_013: Validar unicidad de username y email
           """
           # Validar username unico
           if User.objects.filter(username=username).exists():
               raise ValidationError(
                   f"Username '{username}' ya existe en el sistema"
               )

           # Validar email unico
           if User.objects.filter(email=email).exists():
               raise ValidationError(
                   f"Email '{email}' ya esta registrado"
               )

           return User.objects.create(
               username=username,
               email=email,
               ...
           )

----

Casos de Uso Afectados
----------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - UC
     - Nombre
     - Impacto de BR_013
   * - UC_006
     - Crear Usuario
     - Valida unicidad
   * - UC_007
     - Modificar Usuario
     - No permite cambiar a username existente
   * - UC_001
     - Inicio Sesion
     - Busqueda por username unico

----

Requisitos Funcionales Derivados
--------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR
     - Enunciado
   * - FR-006.01
     - Sistema DEBE validar que username no exista al crear usuario
   * - FR-006.02
     - Sistema DEBE validar que email no exista al crear usuario
   * - FR-006.03
     - Sistema DEBE mostrar error si username duplicado
   * - FR-007.01
     - Sistema DEBE validar unicidad al modificar username

----

Validacion
----------

Criterios de Aceptacion
^^^^^^^^^^^^^^^^^^^^^^^

1. No se pueden crear dos usuarios con mismo username
2. No se pueden crear dos usuarios con mismo email
3. Constraint UNIQUE en base de datos
4. Mensaje de error claro si duplicado

----

Referencias
-----------

Documentos Relacionados
^^^^^^^^^^^^^^^^^^^^^^^

- :ref:`br-005` - BR_005 Sesion Unica
- :ref:`mtm-03` - MTM_03 Metamodelo RBAC
- UC_006 - Crear Usuario
- UC_001 - Inicio Sesion

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

- Origen: Modelo de Datos IACT
- Tipo: Hecho (define identidad)
- Influye: UC_001, UC_006, UC_007
- Deriva: FR-006.01 a FR-006.03, FR-007.01
