.. meta::
   :artefacto: BR_012
   :tipo: Regla de Negocio
   :dominio: requisitos
   :subdominio: reglas_negocio
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-07
   :ultimo_cambio: 2026-01-07
   :autor: Equipo IACT
   :clasificacion: Interno

.. _br-012:

==============================
BR_012: Usuario-Segmento Único
==============================


Resumen Ejecutivo
-----------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BR_012
   * - **Nombre**
     - Usuario-Segmento Único
   * - **Tipo**
     - Hecho
   * - **Categoría**
     - Seguridad / Control de Acceso
   * - **Criticidad**
     - Alta
   * - **Estado**
     - Vigente

----

1. Definición Formal
--------------------

1.1 Enunciado de la Regla
^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: **Regla de Negocio BR_012**

   Un usuario en el sistema IACT puede estar asignado a uno o más centros
   (segmentos). La relación usuario-centro determina qué datos puede
   visualizar el usuario. Un usuario sin segmentos asignados NO puede
   acceder a ningún dato operacional.

1.2 Formulación SBVR
^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   VOCABULARIO:
     - usuario: Identidad autenticada en el sistema IACT
     - segmento: Centro de atención al cliente (call center)
     - asignacion: Relación entre usuario y segmento
     - datos_operacionales: Métricas, reportes y logs del sistema

   HECHOS:
     Cada usuario PUEDE tener asignados uno o más segmentos.
     
     Cada segmento PUEDE estar asignado a uno o más usuarios.
     
     La relación usuario-segmento ES de tipo muchos-a-muchos (N:M).

   REGLA:
     Es OBLIGATORIO que un usuario tenga AL MENOS un segmento asignado
     para acceder a datos_operacionales.
     
     Es OBLIGATORIO que las consultas de datos filtren automáticamente
     por los segmentos asignados al usuario.

1.3 Justificación
^^^^^^^^^^^^^^^^^

La segmentación por centro garantiza:

- **Segregación de datos**: Usuarios solo ven datos de sus centros asignados
- **Cumplimiento normativo**: Control de acceso granular por ubicación
- **Privacidad**: Datos de un centro no son visibles por otros
- **Auditoría**: Trazabilidad de qué usuario accedió a qué centro
- **Flexibilidad**: Un supervisor puede ver múltiples centros

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
     - [X] **Hecho**: Define estructura de datos usuario-segmento

2.2 Naturaleza
^^^^^^^^^^^^^^

- **Estática/Dinámica**: Estática - estructura de relación fija
- **Automatizable**: Sí - filtro automático en todas las consultas
- **Alcance**: Todos los módulos que manejan datos por centro

----

3. Origen y Autoridad
---------------------

3.1 Fuente Primaria
^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **Documento**
     - MODELO_RBAC_IACT_v5_1_1.md
   * - **Sección**
     - Segmentación por Centro
   * - **Versión**
     - 5.1.1
   * - **Tipo Fuente**
     - Diseño de Seguridad

3.2 Autoridad de Modificación
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Responsable**: Administrador de Seguridad
- **Proceso de Cambio**: Requiere aprobación de PMO
- **Frecuencia de Revisión**: Anual o ante cambios organizacionales

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
   * - UC_ACC_06
     - Asignar Segmento - Crea relación usuario-centro
   * - UC_RPT_03
     - Filtrar por Centro - Solo muestra centros asignados
   * - UC_RPT_01
     - Ver Dashboard - Filtra datos por segmentos del usuario
   * - Middleware
     - Aplica filtro automático en todas las consultas
   * - APIs
     - Valida acceso a datos según segmentos

4.2 Actores Afectados
^^^^^^^^^^^^^^^^^^^^^

- **Administrador**: Asigna segmentos a usuarios
- **Todos los roles**: Ven datos solo de sus segmentos asignados
- **Superadmin**: Puede ver todos los centros (asignación especial)

4.3 Excepciones
^^^^^^^^^^^^^^^

- **agr_superadmin**: Puede tener acceso a todos los centros
- **Reportes consolidados**: Requieren función especial de consolidación

----

5. Trazabilidad
---------------

5.1 Modelo de Datos
^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   ┌─────────────┐       ┌─────────────────┐       ┌─────────────┐
   │   Usuario   │       │ user_segments   │       │   Centro    │
   ├─────────────┤       ├─────────────────┤       ├─────────────┤
   │ id (PK)     │──────<│ user_id (FK)    │>──────│ id (PK)     │
   │ username    │       │ center_id (FK)  │       │ nombre      │
   │ ...         │       │ assigned_at     │       │ region      │
   └─────────────┘       │ assigned_by     │       └─────────────┘
                         └─────────────────┘
   
   Relación: N:M (muchos a muchos)
   Constraint: UNIQUE(user_id, center_id)

5.2 Casos de Uso Afectados (UC)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - UC
     - Donde Aplica
   * - UC_ACC_06
     - Asignar Segmento a usuario
   * - UC_ACC_07
     - Consultar Permisos Efectivos (incluye segmentos)
   * - UC_RPT_01-14
     - Todos los reportes filtran por segmento
   * - UC_ALR_01-05
     - Alertas filtradas por segmento
   * - UC_AUD_01-04
     - Auditoría filtrada por segmento

----

6. Verificación
---------------

6.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La regla se considera cumplida cuando:

1. Tabla user_segments existe con constraint UNIQUE
2. Todo usuario tiene al menos un segmento para acceder a datos
3. Todas las consultas de datos aplican filtro por segmento
4. UI solo muestra centros asignados en selectores
5. Intentos de acceso a centros no asignados son bloqueados

6.2 Método de Verificación
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo**: Automatizado
- **Frecuencia**: Cada request
- **Responsable**: Middleware de Segmentación

6.3 Consecuencias de Incumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Exposición de datos de centros no autorizados
- Violación de políticas de privacidad
- Incumplimiento de segregación de datos
- Posibles sanciones regulatorias

----

7. Implementación Técnica
-------------------------

7.1 Modelo Django
^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/access/models.py
   
   class UserSegment(models.Model):
                                                     
       Relación usuario-centro que implementa BR_012.
                                                     
       user = models.ForeignKey(
           'users.User',
           on_delete=models.CASCADE,
           related_name='segments'
       )
       center = models.ForeignKey(
           'centers.Center',
           on_delete=models.CASCADE,
           related_name='users'
       )
       assigned_at = models.DateTimeField(auto_now_add=True)
       assigned_by = models.ForeignKey(
           'users.User',
           on_delete=models.SET_NULL,
           null=True,
           related_name='segment_assignments'
       )
       
       class Meta:
           db_table = 'user_segments'
           unique_together = ['user', 'center']  # BR_012: Relación única
           
       def __str__(self):
           return f"{self.user.username} -> {self.center.nombre}"

7.2 Middleware de Filtrado
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/core/middleware/segment_filter.py
   
   class SegmentFilterMiddleware:
                                 
       Middleware que aplica filtro automático por segmento.
       Implementa BR_012.
                         
       
       def __init__(self, get_response):
           self.get_response = get_response
       
       def __call__(self, request):
           if request.user.is_authenticated:
               # Obtener centros asignados al usuario
               request.user_centers = list(
                   request.user.segments.values_list('center_id', flat=True)
               )
               
               if not request.user_centers:
                   # BR_012: Sin segmentos = sin acceso a datos
                   request.user_centers = []
           
           return self.get_response(request)

7.3 QuerySet Filtrado
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

   # apps/reports/managers.py
   
   class SegmentedManager(models.Manager):
                                                                    
       Manager que filtra automáticamente por segmentos del usuario.
                                                                    
       
       def for_user(self, user):
                                
           Retorna queryset filtrado por centros del usuario.
           Implementa BR_012.
                             
           center_ids = user.segments.values_list('center_id', flat=True)
           return self.filter(center_id__in=center_ids)

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
     - Versión inicial basada en MODELO_RBAC_IACT_v5_1_1

----

Referencias
-----------

- MODELO_RBAC_IACT_v5_1_1.md: Modelo de permisos y segmentación
- FND_02: Reglas de Negocio
- UC_ACC_06: Asignar Segmento

----

*Documento versión 1.0.0 - Proyecto IACT Dashboard Analytics*
