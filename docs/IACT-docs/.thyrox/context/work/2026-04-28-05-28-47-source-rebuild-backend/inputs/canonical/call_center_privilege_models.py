# authentication/models.py - Agregar estos modelos adaptados al Call Center

class Campaign(models.Model):
    """
    Campañas del Call Center (equivalente a Convenio en el sistema legacy)
    Cada campaña puede tener diferentes módulos habilitados
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    code = models.CharField(max_length=20, unique=True)
    name = models.CharField(max_length=100)
    client_name = models.CharField(max_length=100)
    
    # Tipos de campaña específicos del Call Center
    CAMPAIGN_TYPES = [
        ('INBOUND', 'Llamadas Entrantes'),
        ('OUTBOUND', 'Llamadas Salientes'),
        ('BLENDED', 'Mixto'),
        ('SUPPORT', 'Soporte Técnico'),
        ('SALES', 'Ventas'),
        ('COLLECTIONS', 'Cobranza'),
    ]
    campaign_type = models.CharField(max_length=20, choices=CAMPAIGN_TYPES)
    
    # Estado
    is_active = models.BooleanField(default=True)
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    
    # Auditoría
    created_at = models.DateTimeField(auto_now_add=True)
    created_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='campaigns_created'
    )
    
    class Meta:
        db_table = 'campaigns'
        verbose_name = 'Campaña'
        verbose_name_plural = 'Campañas'
        ordering = ['name']
    
    def __str__(self):
        return f"{self.name} ({self.code})"


class CallCenterModule(models.Model):
    """
    Módulos específicos del Call Center
    Extiende C_MENU2 con campos relevantes al dominio
    """
    # Campos legacy compatibles
    ID_MENU = models.AutoField(primary_key=True)
    NIVEL = models.IntegerField(default=1)
    ID_PARENT = models.IntegerField(null=True, blank=True)
    DES_MENU = models.CharField(max_length=100, unique=True)
    DES_NAME = models.CharField(max_length=200)
    STATUS = models.CharField(
        max_length=10,
        choices=[('ACTIVO', 'Activo'), ('INACTIVO', 'Inactivo')],
        default='ACTIVO'
    )
    TARGET = models.CharField(max_length=20, default='main')
    IMAGE = models.CharField(max_length=100, null=True, blank=True)
    HREF = models.CharField(max_length=200, default='index.asp')
    ORDEN = models.IntegerField(default=1)
    
    # Campos específicos Call Center
    MODULE_CATEGORY = [
        ('OPERATIONS', 'Operaciones'),
        ('QUALITY', 'Calidad'),
        ('REPORTS', 'Reportes'),
        ('REALTIME', 'Tiempo Real'),
        ('WORKFORCE', 'Gestión de Personal'),
        ('TRAINING', 'Capacitación'),
        ('ADMIN', 'Administración'),
    ]
    category = models.CharField(
        max_length=20, 
        choices=MODULE_CATEGORY,
        help_text="Categoría del módulo en el Call Center"
    )
    
    # Permisos específicos por tipo de operación Call Center
    requires_supervisor = models.BooleanField(
        default=False,
        help_text="Requiere rol de supervisor o superior"
    )
    requires_quality_role = models.BooleanField(
        default=False,
        help_text="Requiere rol de calidad"
    )
    requires_realtime_access = models.BooleanField(
        default=False,
        help_text="Requiere acceso a datos en tiempo real"
    )
    
    # KPIs asociados
    related_kpis = models.JSONField(
        default=list,
        help_text="KPIs que este módulo puede visualizar"
    )
    
    # Configuración de datos
    data_retention_days = models.IntegerField(
        default=90,
        help_text="Días de retención de datos para reportes"
    )
    refresh_interval_seconds = models.IntegerField(
        default=300,
        help_text="Intervalo de actualización para dashboards"
    )
    
    # Auditoría
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'call_center_modules'
        verbose_name = 'Módulo Call Center'
        verbose_name_plural = 'Módulos Call Center'
        ordering = ['NIVEL', 'ID_PARENT', 'ORDEN']
    
    def __str__(self):
        return f"{self.DES_NAME} ({self.DES_MENU})"


class ModuleByCampaign(models.Model):
    """
    Define qué módulos están disponibles para cada campaña
    Equivalente a BD_MENU_CONVENIO pero adaptado al Call Center
    """
    campaign = models.ForeignKey(
        Campaign,
        on_delete=models.CASCADE,
        related_name='campaign_modules'
    )
    module_parent_id = models.IntegerField(
        default=0,
        help_text="ID del módulo padre"
    )
    module = models.ForeignKey(
        CallCenterModule,
        on_delete=models.CASCADE,
        related_name='campaign_assignments'
    )
    
    # Configuración específica por campaña
    is_mandatory = models.BooleanField(
        default=False,
        help_text="Si es obligatorio para todos los agentes de la campaña"
    )
    
    # Límites específicos por campaña
    max_export_records = models.IntegerField(
        default=1000,
        help_text="Límite de registros para exportación"
    )
    
    # Horarios de disponibilidad
    available_start_time = models.TimeField(
        null=True, 
        blank=True,
        help_text="Hora inicio de disponibilidad"
    )
    available_end_time = models.TimeField(
        null=True, 
        blank=True,
        help_text="Hora fin de disponibilidad"
    )
    
    # Auditoría
    created_at = models.DateTimeField(auto_now_add=True)
    created_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True
    )
    
    class Meta:
        db_table = 'module_by_campaign'
        unique_together = ['campaign', 'module']
        verbose_name = 'Módulo por Campaña'
    
    def __str__(self):
        return f"{self.campaign.name} - {self.module.DES_NAME}"


class UserModulePrivilege(models.Model):
    """
    Privilegios de usuario sobre módulos por campaña
    Equivalente a BD_MENU2 pero con campos específicos del Call Center
    """
    module_parent_id = models.IntegerField(default=0)
    module = models.ForeignKey(
        CallCenterModule,
        on_delete=models.CASCADE,
        related_name='user_privileges'
    )
    user = models.ForeignKey(
        CallCenterUser,
        on_delete=models.CASCADE,
        related_name='module_privileges'
    )
    campaign = models.ForeignKey(
        Campaign,
        on_delete=models.CASCADE,
        related_name='user_privileges'
    )
    
    # Permisos granulares para Call Center
    can_view = models.BooleanField(default=True)
    can_export = models.BooleanField(default=False)
    can_view_realtime = models.BooleanField(default=False)
    can_modify_settings = models.BooleanField(default=False)
    can_view_other_agents = models.BooleanField(
        default=False,
        help_text="Puede ver datos de otros agentes"
    )
    
    # Restricciones temporales
    valid_from = models.DateTimeField(
        null=True,
        blank=True,
        help_text="Fecha desde cuando el privilegio es válido"
    )
    valid_until = models.DateTimeField(
        null=True,
        blank=True,
        help_text="Fecha hasta cuando el privilegio es válido"
    )
    
    # Auditoría
    assigned_at = models.DateTimeField(auto_now_add=True)
    assigned_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='privileges_assigned'
    )
    assignment_reason = models.TextField(
        blank=True,
        help_text="Razón de la asignación"
    )
    
    class Meta:
        db_table = 'user_module_privileges'
        unique_together = ['user', 'module', 'campaign']
        indexes = [
            models.Index(fields=['user', 'campaign']),
            models.Index(fields=['campaign', 'module']),
        ]
        verbose_name = 'Privilegio de Usuario'
    
    def __str__(self):
        return f"{self.user.username} - {self.module.DES_NAME} - {self.campaign.code}"
    
    @property
    def is_valid(self):
        """Verifica si el privilegio está vigente"""
        now = timezone.now()
        if self.valid_from and now < self.valid_from:
            return False
        if self.valid_until and now > self.valid_until:
            return False
        return True


class QualityModuleAccess(models.Model):
    """
    Acceso especial para módulos de calidad
    Similar a ARH_BD_PESTANAS_CANDIDATOS pero para calidad
    """
    user = models.ForeignKey(
        CallCenterUser,
        on_delete=models.CASCADE,
        related_name='quality_access'
    )
    module = models.ForeignKey(
        CallCenterModule,
        on_delete=models.CASCADE
    )
    
    # Permisos específicos de calidad
    can_evaluate_calls = models.BooleanField(default=True)
    can_modify_scores = models.BooleanField(default=False)
    can_view_all_teams = models.BooleanField(default=False)
    can_export_evaluations = models.BooleanField(default=False)
    
    # Equipos que puede evaluar
    allowed_teams = models.JSONField(
        default=list,
        help_text="IDs de equipos que puede evaluar"
    )
    
    # Auditoría
    assigned_at = models.DateTimeField(auto_now_add=True)
    assigned_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='quality_access_assigned'
    )
    
    class Meta:
        db_table = 'quality_module_access'
        unique_together = ['user', 'module']
        verbose_name = 'Acceso Módulo de Calidad'


# Extender CallCenterUser con campos del dominio
class CallCenterUser(AbstractUser):
    # ... campos existentes ...
    
    # Campañas asignadas
    campaigns = models.ManyToManyField(
        Campaign,
        through='UserCampaignAssignment',
        related_name='users'
    )
    
    # Supervisor directo
    supervisor = models.ForeignKey(
        'self',
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name='supervised_agents'
    )
    
    # Turno de trabajo
    SHIFT_CHOICES = [
        ('MORNING', 'Matutino'),
        ('AFTERNOON', 'Vespertino'),
        ('NIGHT', 'Nocturno'),
        ('FLEXIBLE', 'Flexible'),
    ]
    shift = models.CharField(
        max_length=20,
        choices=SHIFT_CHOICES,
        default='MORNING'
    )
    
    # Skills del agente
    skills = models.JSONField(
        default=list,
        help_text="Habilidades del agente (idiomas, productos, etc.)"
    )
    
    # Métricas de desempeño
    quality_score = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        null=True,
        blank=True,
        help_text="Puntuación de calidad promedio"
    )
    
    is_quality_analyst = models.BooleanField(
        default=False,
        help_text="Tiene rol de analista de calidad"
    )


class UserCampaignAssignment(models.Model):
    """
    Asignación de usuarios a campañas con fechas
    """
    user = models.ForeignKey(CallCenterUser, on_delete=models.CASCADE)
    campaign = models.ForeignKey(Campaign, on_delete=models.CASCADE)
    
    assigned_from = models.DateField()
    assigned_until = models.DateField(null=True, blank=True)
    is_primary = models.BooleanField(
        default=False,
        help_text="Si es la campaña principal del usuario"
    )
    
    # Rol en la campaña
    CAMPAIGN_ROLE_CHOICES = [
        ('AGENT', 'Agente'),
        ('TEAM_LEAD', 'Líder de Equipo'),
        ('SUPERVISOR', 'Supervisor'),
        ('QUALITY', 'Analista de Calidad'),
        ('TRAINER', 'Capacitador'),
    ]
    role_in_campaign = models.CharField(
        max_length=20,
        choices=CAMPAIGN_ROLE_CHOICES,
        default='AGENT'
    )
    
    class Meta:
        db_table = 'user_campaign_assignment'
        unique_together = ['user', 'campaign', 'assigned_from']