.. meta::
   :artefacto: BR_013
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-013:

======================
BR_013: Username Único
======================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_013
   * - **Nombre**
     - Username Único
   * - **Tipo**
     - Hecho
   * - **Categoría**
     - Identidad / Integridad de Datos
   * - **Criticidad**
     - Crítica
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_013**

   Cada usuario en el sistema IACT DEBE tener un username único e irrepetible.
   No pueden existir dos usuarios con el mismo username, independientemente
   de su estado (activo/inactivo). El username es inmutable una vez creado.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - username: Identificador único de texto para autenticación
     - usuario: Entidad que representa una identidad en el sistema
     - estado_usuario: ACTIVO | INACTIVO

   HECHOS:
     Cada usuario TIENE exactamente un username.
     
     Cada username PERTENECE a exactamente un usuario.
     
     La relación usuario-username ES de tipo uno-a-uno (1:1).

   REGLA:
     Es OBLIGATORIO que cada username sea UNICO en todo el sistema.
     
     Es PROHIBIDO reutilizar un username de un usuario dado de baja.
     
     Es PROHIBIDO modificar el username una vez creado el usuario.

1.3 Justificación
^^^^^^^^^^^^^^^^^

La unicidad del username garantiza:

- **Identificación inequívoca**: Cada usuario es único en el sistema
- **Auditoría confiable**: Los logs siempre refieren a un único usuario
- **Seguridad**: Previene suplantación de identidad
- **Integridad referencial**: FKs y relaciones siempre válidas
- **Histórico preservado**: Usuarios inactivos mantienen su identidad

----

2. Clasificación
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Hecho**
   * - 
     - [X] **Hecho**: Define cardinalidad 1:1 entre usuario y username

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Estática - constraint permanente
- **Automatizable**: Sí - constraint UNIQUE en BD
- **Alcance**: Tabla de usuarios del sistema

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - Modelo de Identidades IACT
   * - **Sección**
     - Gestión de Usuarios
   * - **Versión**
     - 1.0.0
   * - **Tipo Fuente**
     - Requisito de Seguridad

3.2 Autoridad de Modificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Arquitecto de Seguridad
- **Proceso de Cambio**: No modificable (principio fundamental)
- **Frecuencia de Revisión**: N/A - regla inmutable

----

4. Aplicación en Sistema
------------------------

4.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripción de Aplicación
   * - UC_USR_01
     - Crear Usuario - Valida unicidad antes de INSERT
   * - UC_AUTH_01
     - Iniciar Sesión - Busca por username único
   * - UC_AUTH_03
     - Recuperar Contraseña - Identifica por username
   * - Modelo User
     - Constraint UNIQUE en columna username
   * - API
     - Validación en serializer antes de crear

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Administrador**: No puede crear usuarios con username duplicado
- **Sistema**: Rechaza automáticamente duplicados

4.3 Excepciones
^^^^^^^^^^^^^^^

Sin excepciones. La unicidad es absoluta e incondicional.

----

5. Trazabilidad
---------------

5.1 Modelo de Datos
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ┌─────────────────────────────────────┐
   │              Usuario                │
   ├─────────────────────────────────────┤
   │ id           : INTEGER (PK)         │
   │ username     : VARCHAR(150) UNIQUE  │◄── BR_013: Constraint UNIQUE
   │ email        : VARCHAR(254)         │
   │ estado       : ENUM(ACTIVO,INACTIVO)│
   │ created_at   : TIMESTAMP            │
   │ ...                                 │
   └─────────────────────────────────────┘
   
   INDEX: idx_users_username (username) UNIQUE

5.2 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC_USR_01
     - Crear Usuario - Valida unicidad
   * - UC_USR_02
     - Modificar Usuario - Username NO editable
   * - UC_AUTH_01
     - Login - Búsqueda por username único
   * - UC_AUTH_03
     - Recuperar Password - Identificación por username

----

6. Verificación
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. Columna username tiene constraint UNIQUE en BD
2. Índice único existe sobre username
3. Intento de INSERT duplicado falla con error específico
4. UI muestra mensaje claro si username ya existe
5. Username no es editable en formulario de modificación

6.2 Método de Verificación
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado (constraint BD)
- **Frecuencia**: Cada operación de creación
- **Responsable**: Motor de Base de Datos

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Error de base de datos (IntegrityError)
- Rechazo de creación de usuario
- Imposibilidad de autenticación si hubiera duplicados

----

7. Implementación Técnica
-------------------------

7.1 Modelo Django
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/users/models.py
   
   class User(AbstractBaseUser, PermissionsMixin):
                                               
       Modelo de usuario que implementa BR_013.
                                               
       username = models.CharField(
           max_length=150,
           unique=True,  # BR_013: Username único
           validators=[username_validator],
           error_messages={
               'unique': 'Ya existe un usuario con este username.',
           },
       )
       email = models.EmailField(blank=True)
       estado = models.CharField(
           max_length=10,
           choices=[('ACTIVO', 'Activo'), ('INACTIVO', 'Inactivo')],
           default='ACTIVO'
       )
       
       USERNAME_FIELD = 'username'
       
       class Meta:
           db_table = 'users'
           indexes = [
               models.Index(fields=['username'], name='idx_users_username'),
           ]

7.2 Validación en Serializer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/users/serializers.py
   
   class UserCreateSerializer(serializers.ModelSerializer):
                                                           
       Serializer para creación de usuario.
       Implementa validación BR_013.
                                    
       
       def validate_username(self, value):
                                                
           Valida unicidad de username (BR_013).
                                                
           if User.objects.filter(username__iexact=value).exists():
               raise serializers.ValidationError(
                   "BR_013: Ya existe un usuario con este username. "
                   "El username debe ser único en todo el sistema."
               )
           return value.lower()  # Normalizar a minúsculas

----

8. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Descripción del Cambio
   * - 1.0.0
     - 2026-01-07
     - Equipo IACT
     - Versión inicial - Regla fundamental de identidad

----

Referencias
-----------

- FND_02: Reglas de Negocio
- UC_USR_01: Crear Usuario
- CNST_005: Seguridad DRF Checklist

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
