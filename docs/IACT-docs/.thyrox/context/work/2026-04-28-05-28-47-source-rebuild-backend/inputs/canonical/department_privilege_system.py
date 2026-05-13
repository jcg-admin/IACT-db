# authentication/models.py - Sistema de privilegios por departamento

class DepartmentModuleAccess(models.Model):
    """
    Define qué módulos están disponibles por defecto para cada departamento
    Similar a BD_MENU_CONVENIO pero a nivel departamento
    """
    DEPARTMENT_CHOICES = [
        ('SUPERVISION', 'Supervisión'),
        ('OPERACIONES', 'Operaciones'),
        ('GERENCIA', 'Gerencia'),
        ('TECNOLOGIA', 'Tecnología'),
    ]
    
    department = models.CharField(
        max_length=50,
        choices=DEPARTMENT_CHOICES,
        help_text="Departamento que tiene acceso"
    )
    module = models.ForeignKey(
        'C_MENU2',
        on_delete=models.CASCADE,
        related_name='department_access'
    )
    module_parent_id = models.IntegerField(
        default=0,
        help_text="ID del módulo padre"
    )
    
    # Permisos por defecto para el departamento
    default_can_read = models.BooleanField(default=True)
    default_can_write = models.BooleanField(default=False)
    default_can_delete = models.BooleanField(default=False)
    default_can_export = models.BooleanField(default=False)
    
    # Configuración
    is_core_module = models.BooleanField(
        default=False,
        help_text="Si es un módulo esencial que no se puede remover"
    )
    
    class Meta:
        db_table = 'department_module_access'
        unique_together = ['department', 'module']
        verbose_name = 'Acceso de Módulo por Departamento'
    
    def __str__(self):
        return f"{self.department} -> {self.module.DES_NAME}"


# Modificar C_MENU2 para incluir restricciones por departamento
class C_MENU2(models.Model):
    """
    Tabla de menús/módulos del sistema - Compatible con estructura legacy
    """
    # ... campos existentes ...
    
    # Nuevos campos para control por departamento
    required_departments = models.JSONField(
        default=list,
        blank=True,
        help_text="Departamentos que pueden acceder (vacío = todos)"
    )
    
    module_owner_department = models.CharField(
        max_length=50,
        choices=[
            ('SUPERVISION', 'Supervisión'),
            ('OPERACIONES', 'Operaciones'),
            ('GERENCIA', 'Gerencia'),
            ('TECNOLOGIA', 'Tecnología'),
            ('SHARED', 'Compartido'),
        ],
        default='SHARED',
        help_text="Departamento dueño del módulo"
    )
    
    @property
    def is_restricted(self):
        """Verifica si el módulo tiene restricciones por departamento"""
        return len(self.required_departments) > 0


# Modificar BD_MENU2 para considerar el contexto del sistema
class BD_MENU2(models.Model):
    """
    Privilegios de usuario sobre menús
    El ID_CONVENIO ahora puede representar diferentes contextos
    """
    ID_MENU0 = models.IntegerField(default=0)
    ID_MENU1 = models.ForeignKey(
        C_MENU2,
        on_delete=models.CASCADE,
        db_column='ID_MENU1',
        related_name='user_privileges'
    )
    ID_USUARIO = models.ForeignKey(
        CallCenterUser,
        on_delete=models.CASCADE,
        db_column='ID_USUARIO',
        related_name='menu_privileges'
    )
    ID_CONVENIO = models.IntegerField(
        default=1,
        help_text="Contexto del privilegio (1=Sistema general, >1=Contextos específicos)"
    )
    
    # Permisos específicos
    can_read = models.BooleanField(default=True)
    can_write = models.BooleanField(default=False)
    can_delete = models.BooleanField(default=False)
    can_export = models.BooleanField(default=False)
    
    # Override de departamento
    override_department_restriction = models.BooleanField(
        default=False,
        help_text="Si puede acceder aunque no sea de su departamento"
    )
    
    # ... resto de campos ...


# Servicio actualizado
class DepartmentPrivilegeService:
    """
    Maneja privilegios basados en departamentos
    """
    
    @staticmethod
    @transaction.atomic
    def setup_user_default_modules(user_id):
        """
        Configura módulos por defecto cuando se crea un usuario
        basado en su departamento
        """
        user = CallCenterUser.objects.get(id=user_id)
        
        # Obtener módulos del departamento
        dept_modules = DepartmentModuleAccess.objects.filter(
            department=user.department
        ).select_related('module')
        
        privileges_to_create = []
        
        for dept_access in dept_modules:
            module = dept_access.module
            
            # Crear privilegio principal
            privileges_to_create.append(
                BD_MENU2(
                    ID_MENU0=module.ID_PARENT or 0,
                    ID_MENU1=module,
                    ID_USUARIO=user,
                    ID_CONVENIO=1,  # 1 = Sistema general
                    can_read=dept_access.default_can_read,
                    can_write=dept_access.default_can_write,
                    can_delete=dept_access.default_can_delete,
                    can_export=dept_access.default_can_export
                )
            )
            
            # Agregar hijos automáticamente
            children = C_MENU2.objects.filter(
                ID_PARENT=module.ID_MENU,
                STATUS='ACTIVO'
            )
            
            for child in children:
                # Verificar si el hijo también requiere el mismo departamento
                if not child.required_departments or user.department in child.required_departments:
                    privileges_to_create.append(
                        BD_MENU2(
                            ID_MENU0=module.ID_MENU,
                            ID_MENU1=child,
                            ID_USUARIO=user,
                            ID_CONVENIO=1,
                            can_read=dept_access.default_can_read,
                            can_write=dept_access.default_can_write,
                            can_delete=dept_access.default_can_delete,
                            can_export=dept_access.default_can_export
                        )
                    )
        
        # Crear todos los privilegios
        BD_MENU2.objects.bulk_create(privileges_to_create, ignore_conflicts=True)
        
        return len(privileges_to_create)
    
    @staticmethod
    def assign_cross_department_module(user_id, module_id, assigned_by_id, reason=""):
        """
        Asigna un módulo de otro departamento a un usuario específico
        Por ejemplo: dar acceso a SUPERVISION a alguien de OPERACIONES
        """
        user = CallCenterUser.objects.get(id=user_id)
        module = C_MENU2.objects.get(ID_MENU=module_id)
        
        # Verificar que el módulo sea de otro departamento
        if module.module_owner_department == user.department:
            raise ValueError("El módulo ya pertenece al departamento del usuario")
        
        # Crear privilegio con override
        privilege, created = BD_MENU2.objects.update_or_create(
            ID_USUARIO=user,
            ID_MENU1=module,
            ID_CONVENIO=1,
            defaults={
                'ID_MENU0': module.ID_PARENT or 0,
                'ID_USUARIO_ALTA_id': assigned_by_id,
                'override_department_restriction': True,
                'can_read': True,
                'can_write': False,
                'can_delete': False,
                'can_export': False
            }
        )
        
        # Log de auditoría
        LoginAttempt.log_attempt(
            username=user.username,
            attempt_type='MODULE_ASSIGNED',
            ip_address='0.0.0.0',
            error_details=f'Módulo {module.DES_NAME} asignado por excepción. Razón: {reason}',
            user=user
        )
        
        return privilege
    
    @staticmethod
    def get_user_accessible_modules(user_id):
        """
        Obtiene todos los módulos accesibles para un usuario
        considerando su departamento y excepciones
        """
        query = """
            SELECT DISTINCT
                m.ID_MENU,
                m.NIVEL,
                m.ID_PARENT,
                m.DES_MENU,
                m.DES_NAME,
                m.ORDEN,
                m.HREF,
                m.module_owner_department,
                CASE 
                    WHEN b.ID_MENU1_id IS NOT NULL THEN 'ASSIGNED'
                    WHEN d.module_id IS NOT NULL THEN 'DEPARTMENT'
                    ELSE 'NO_ACCESS'
                END as access_type,
                COALESCE(b.can_read, d.default_can_read, FALSE) as can_read,
                COALESCE(b.can_write, d.default_can_write, FALSE) as can_write,
                COALESCE(b.can_delete, d.default_can_delete, FALSE) as can_delete,
                COALESCE(b.can_export, d.default_can_export, FALSE) as can_export,
                b.override_department_restriction
            FROM C_MENU2 m
            LEFT JOIN BD_MENU2 b ON m.ID_MENU = b.ID_MENU1_id 
                AND b.ID_USUARIO_id = %s 
                AND b.ID_CONVENIO = 1
            LEFT JOIN department_module_access d ON m.ID_MENU = d.module_id 
                AND d.department = (
                    SELECT department FROM auth_callcenter_user WHERE id = %s
                )
            WHERE m.STATUS = 'ACTIVO'
                AND (
                    -- Tiene privilegio directo
                    b.ID_MENU1_id IS NOT NULL
                    OR 
                    -- Es de su departamento
                    d.module_id IS NOT NULL
                    OR
                    -- Es módulo compartido sin restricciones
                    (m.module_owner_department = 'SHARED' 
                     AND JSON_LENGTH(m.required_departments) = 0)
                )
            ORDER BY m.NIVEL, m.ID_PARENT, m.ORDEN
        """
        
        with connection.cursor() as cursor:
            cursor.execute(query, [user_id, user_id])
            columns = [col[0] for col in cursor.description]
            return [dict(zip(columns, row)) for row in cursor.fetchall()]


# Datos de ejemplo para setup inicial
DEPARTMENT_MODULE_SETUP = {
    'OPERACIONES': [
        ('DASHBOARD_OPERACIONES', 'Dashboard Operaciones', True, False, False, False),
        ('MIS_METRICAS', 'Mis Métricas', True, False, False, True),
        ('REPORTES_BASICOS', 'Reportes Básicos', True, False, False, True),
        ('BASE_CONOCIMIENTO', 'Base de Conocimiento', True, False, False, False),
        ('MI_HORARIO', 'Mi Horario', True, False, False, False),
    ],
    'SUPERVISION': [
        ('DASHBOARD_SUPERVISION', 'Dashboard Supervisión', True, True, False, True),
        ('MONITOR_TIEMPO_REAL', 'Monitor Tiempo Real', True, False, False, False),
        ('REPORTES_EQUIPO', 'Reportes de Equipo', True, False, False, True),
        ('GESTION_AGENTES', 'Gestión de Agentes', True, True, False, True),
        ('CALIDAD_BASICA', 'Calidad Básica', True, True, False, True),
        ('HORARIOS_EQUIPO', 'Horarios del Equipo', True, True, False, True),
    ],
    'GERENCIA': [
        ('DASHBOARD_GERENCIAL', 'Dashboard Gerencial', True, True, True, True),
        ('REPORTES_AVANZADOS', 'Reportes Avanzados', True, False, False, True),
        ('ANALYTICS', 'Analytics', True, False, False, True),
        ('GESTION_CAMPANAS', 'Gestión de Campañas', True, True, True, True),
        ('CONFIGURACION_SISTEMA', 'Configuración Sistema', True, True, True, False),
        ('AUDITORIA', 'Auditoría', True, False, False, True),
    ],
    'TECNOLOGIA': [
        ('DASHBOARD_TI', 'Dashboard TI', True, True, True, True),
        ('ADMINISTRACION_USUARIOS', 'Admin Usuarios', True, True, True, False),
        ('LOGS_SISTEMA', 'Logs del Sistema', True, False, False, True),
        ('CONFIGURACION_TECNICA', 'Config Técnica', True, True, True, False),
        ('INTEGRACIONES', 'Integraciones', True, True, True, False),
        ('MONITOREO_SISTEMA', 'Monitoreo Sistema', True, False, False, False),
    ],
}