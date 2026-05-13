.. meta::
   :artefacto: BR_003
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2025-12-22
   :ultimo_cambio: 2025-12-22
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-003:

==============================================================================
BR_003: Control de Acceso Basado en Roles (RBAC Flat)
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_003
   * - **Nombre**
     - Control de Acceso Basado en Roles (RBAC Flat)
   * - **Tipo**
     - Restriccion
   * - **Categoria**
     - Seguridad / Control de Acceso
   * - **Criticidad**
     - Critica
   * - **Estado**
     - Vigente

----

1. Definicion Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_003**

   Todo acceso a funcionalidades del sistema IACT DEBE estar controlado
   mediante roles predefinidos. Un usuario DEBE tener al menos un rol activo
   para acceder al sistema, y solo puede ejecutar operaciones permitidas
   por los roles que tiene asignados.

1.2 Formulacion SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - rol: Conjunto predefinido de permisos (R001 a R015)
     - permiso: Autorizacion para ejecutar una operacion especifica
     - usuario_autenticado: Usuario con sesion valida en el sistema
     - operacion_protegida: Cualquier endpoint o funcionalidad del sistema

   REGLA:
     Es OBLIGATORIO que usuario_autenticado tenga al menos un rol activo
     para acceder a operacion_protegida.
     
     Es OBLIGATORIO que operacion_protegida valide permisos del rol
     antes de ejecutarse.
     
     Es PROHIBIDO acceder a operacion_protegida sin rol que lo autorice.

1.3 Justificacion
^^^^^^^^^^^^^^^^^

El control de acceso basado en roles es esencial para:

- Proteger datos sensibles del cliente
- Prevenir accesos no autorizados a funcionalidades
- Cumplir con politicas de seguridad corporativas
- Garantizar trazabilidad de acciones por usuario
- Implementar principio de minimo privilegio
- Segregacion de funciones entre roles

----

2. Clasificacion
----------------

2.1 Tipo de Regla
^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - **Tipo**
     - **Restriccion**
   * - 
     - [X] **Restriccion**: Limita acceso a funcionalidades por rol

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estatica/Dinamica**: Semi-estatica (roles fijos, asignacion dinamica)
- **Automatizable**: Si - implementada via DRF Permissions
- **Alcance**: Sistema completo - todas las APIs y funcionalidades

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - CNST_005_Seguridad_DRF_Checklist.rst
   * - **Seccion**
     - Permisos Basados en Roles (RBAC)
   * - **Version**
     - 1.0.0
   * - **Fecha**
     - 2025-12-17
   * - **Tipo Fuente**
     - CNST (Estandar de Seguridad)

3.2 Autoridad de Modificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Administrador de Seguridad + SYSTEM_ADMIN (R015)
- **Proceso de Cambio**: Aprobacion del cliente para nuevos roles
- **Frecuencia de Revision**: Semestral o cuando se agreguen funcionalidades

----

4. Catalogo de Roles
--------------------

4.1 Roles del Sistema
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 10 30 60
   :header-rows: 1

   * - ID
     - Nombre
     - Permisos
   * - R001
     - USERS_FULL_MANAGER
     - CRUD completo de usuarios, asignar cualquier rol
   * - R002
     - USERS_PARTIAL_MANAGER
     - Crear/modificar usuarios, asignar roles limitados
   * - R003
     - USERS_VIEWER
     - Solo lectura de lista de usuarios
   * - R004
     - REPORTS_VIEWER
     - Ver reportes predefinidos
   * - R005
     - REPORTS_EXPORTER
     - Ver y exportar reportes (Excel, PDF)
   * - R006
     - REPORTS_CREATOR
     - Crear reportes personalizados basicos
   * - R007
     - REPORTS_ADVANCED_CREATOR
     - Crear reportes avanzados con SQL
   * - R008
     - DASHBOARD_VIEWER
     - Ver dashboards predefinidos
   * - R009
     - DASHBOARD_CUSTOMIZER
     - Personalizar widgets de dashboard
   * - R010
     - DATA_ANALYST
     - Acceso a datos crudos y analisis avanzado
   * - R011
     - MESSAGES_MANAGER
     - Gestionar mensajes internos del sistema
   * - R012
     - ALERTS_CONFIGURATOR
     - Configurar umbrales de alertas
   * - R013
     - ALERTS_EVENTS_MANAGER
     - Gestionar eventos de alertas
   * - R014
     - ALERTS_TEMPLATES_MANAGER
     - Gestionar plantillas de notificacion
   * - R015
     - SYSTEM_ADMIN
     - Acceso completo a todas las funcionalidades

4.2 Jerarquia de Roles
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   RBAC FLAT (sin herencia):
   
   Cada rol es independiente. Un usuario puede tener multiples roles,
   y sus permisos son la UNION de los permisos de todos sus roles.
   
   Ejemplo:
     Usuario con roles [R004, R005]:
     - Permisos R004: Ver reportes
     - Permisos R005: Ver + Exportar reportes
     - Permisos efectivos: Ver + Exportar reportes

----

5. Aplicacion en Sistema
------------------------

5.1 Donde Aplica
^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Componente
     - Descripcion de Aplicacion
   * - APIs REST (DRF)
     - Cada ViewSet declara roles requeridos
   * - Frontend React
     - UI muestra opciones segun roles del usuario
   * - Reportes
     - Acceso a reportes segun nivel de rol
   * - Configuracion
     - Solo SYSTEM_ADMIN puede modificar settings

5.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Roles**: Todos los usuarios segun su rol asignado
- **Administradores**: R001, R002, R015 gestionan asignaciones

5.3 Excepciones
^^^^^^^^^^^^^^^

- Superusuario Django (is_superuser=True) tiene acceso completo
- Endpoints publicos (login, health) no requieren rol

----

6. Trazabilidad
---------------

6.1 Restricciones Origen (CNST)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - CNST
     - Relacion
   * - CNST_005
     - Define implementacion RBAC en DRF - origen directo de BR_003

6.2 Requisitos de Negocio Derivados (BReq)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - BReq
     - Descripcion
   * - BReq_003
     - Gestionar Accesos (CRUD de roles y asignaciones)

6.3 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC_003
     - Gestionar Roles - implementa asignacion de roles
   * - UC_001
     - Precondicion: Usuario debe tener rol R008 o superior
   * - UC_002
     - Precondicion: Usuario debe tener rol R005 o superior

----

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. Todos los ViewSets tienen permission_classes definidos
2. Cada endpoint valida roles antes de ejecutar
3. Usuario sin rol recibe HTTP 403 Forbidden
4. Asignacion de roles queda registrada en auditoria
5. Tests verifican control de acceso por rol

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Continua (cada request)
- **Responsable**: Django REST Framework

7.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- HTTP 403 Forbidden devuelto al usuario
- Intento registrado en log de auditoria
- Alerta si hay intentos repetidos (posible ataque)

----

8. Implementacion Tecnica
-------------------------

8.1 Permisos DRF
^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/common/permissions.py
   
   from rest_framework import permissions
   
   class HasRole(permissions.BasePermission):
       """
       Verifica que usuario tenga rol especifico.
       Implementa BR_003: RBAC Flat.
       """
       
       message = 'No tiene el rol requerido para esta operacion'
       
       def has_permission(self, request, view):
           if not request.user.is_authenticated:
               return False
           
           # Superusuario tiene acceso total
           if request.user.is_superuser:
               return True
           
           required_roles = getattr(view, 'required_roles', [])
           
           if not required_roles:
               return True  # Sin restriccion de rol
           
           # Obtener roles activos del usuario
           user_roles = set(
               request.user.roles.filter(is_active=True)
               .values_list('role_id', flat=True)
           )
           
           # Usuario debe tener AL MENOS UNO de los roles requeridos
           return bool(user_roles & set(required_roles))

8.2 Uso en ViewSet
^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/reports/views.py
   
   from rest_framework.viewsets import ModelViewSet
   from apps.common.permissions import HasRole
   
   class ReportViewSet(ModelViewSet):
       """
       BR_003: Solo usuarios con roles de reportes pueden acceder.
       """
       permission_classes = [IsAuthenticated, HasRole]
       required_roles = ['R004', 'R005', 'R006', 'R007', 'R015']
       
       def get_queryset(self):
           # Filtrar reportes segun nivel de rol
           user_roles = self.request.user.get_role_ids()
           
           if 'R015' in user_roles or 'R007' in user_roles:
               return Report.objects.all()
           
           return Report.objects.filter(is_public=True)

8.3 Modelo de Roles
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # api/apps/users/models.py
   
   class Role(models.Model):
       """
       Catalogo de roles del sistema.
       BR_003: RBAC Flat.
       """
       role_id = models.CharField(max_length=10, unique=True)  # R001-R015
       name = models.CharField(max_length=100)
       description = models.TextField()
       permissions = models.JSONField(default=list)
       is_active = models.BooleanField(default=True)
       
       class Meta:
           db_table = 'auth_role'
   
   
   class UserRole(models.Model):
       """
       Asignacion de roles a usuarios.
       """
       user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='roles')
       role = models.ForeignKey(Role, on_delete=models.CASCADE)
       assigned_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
       assigned_at = models.DateTimeField(auto_now_add=True)
       is_active = models.BooleanField(default=True)
       
       class Meta:
           db_table = 'auth_user_role'
           unique_together = ['user', 'role']

----

9. Historial de Cambios
-----------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2025-12-22
     - Equipo IACT
     - Version inicial derivada de CNST_005

----

Referencias
-----------

- CNST_005: Seguridad Django REST Framework
- FND_02: Reglas de Negocio
- FND_05: Jerarquia de 4 Niveles
- Django REST Framework: Permissions

----

*Documento version 1.0.0 - Proyecto IACT Dashboard Analytics*
