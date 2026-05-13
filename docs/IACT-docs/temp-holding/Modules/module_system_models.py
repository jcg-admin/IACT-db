"""
Extended models for authentication app - UC-005
Call Center Dashboard - Sistema de módulos dinámicos por perfil
"""
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinLengthValidator
from django.utils import timezone
import uuid


class CallCenterUser(AbstractUser):
    """
    Usuario extendido para Call Center con roles UC-005
    """
    ROLE_CHOICES = [
        ('ANALISTA', 'Analista'),
        ('SUPERVISOR', 'Supervisor'),
        ('GERENTE', 'Gerente'),
        ('ADMIN_IT', 'Administrador IT'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='ANALISTA')
    phone_extension = models.CharField(max_length=10, blank=True, null=True)
    employee_id = models.CharField(max_length=20, unique=True, null=True, blank=True)
    department = models.CharField(max_length=100, blank=True)
    
    # Control de acceso
    is_active = models.BooleanField(default=True)
    password_changed_at = models.DateTimeField(auto_now_add=True)
    last_login_ip = models.GenericIPAddressField(null=True, blank=True)
    failed_login_attempts = models.IntegerField(default=0)
    account_locked_until = models.DateTimeField(null=True, blank=True)
    
    # Auditoría
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(
        'self', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='users_created'
    )

    class Meta:
        db_table = 'auth_callcenter_user'
        verbose_name = 'Usuario Call Center'
        verbose_name_plural = 'Usuarios Call Center'
        ordering = ['username']

    def __str__(self):
        return f"{self.username} - {self.get_role_display()}"

    @property
    def is_account_locked(self):
        """Verifica si la cuenta está bloqueada"""
        if self.account_locked_until:
            return timezone.now() < self.account_locked_until
        return False

    def get_assigned_modules(self):
        """Obtiene módulos asignados directamente o por perfil"""
        # Módulos directos del usuario
        user_modules = self.user_module_assignments.filter(
            is_active=True
        ).select_related('module')
        
        # Módulos del perfil del usuario
        profile_modules = ModuleProfileAssignment.objects.filter(
            profile__users=self,
            profile__is_active=True,
            is_active=True
        ).select_related('module')
        
        # Combinar y eliminar duplicados
        all_modules = set()
        for assignment in user_modules:
            all_modules.add(assignment.module)
        for assignment in profile_modules:
            all_modules.add(assignment.module)
        
        return list(all_modules)


class SystemModule(models.Model):
    """
    Módulos del sistema Call Center (Ventas, Reportes, etc.)
    """
    MODULE_TYPE_CHOICES = [
        ('DASHBOARD', 'Dashboard Principal'),
        ('REPORTS', 'Reportes'),
        ('SALES', 'Ventas'),
        ('ANALYTICS', 'Analítica'),
        ('ADMIN', 'Administración'),
        ('MONITORING', 'Monitoreo'),
        ('QUALITY', 'Calidad'),
        ('TRAINING', 'Capacitación'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    code = models.CharField(
        max_length=50, 
        unique=True,
        validators=[MinLengthValidator(3)],
        help_text="Código único del módulo (ej: SALES, REPORTS)"
    )
    description = models.TextField(blank=True)
    module_type = models.CharField(max_length=20, choices=MODULE_TYPE_CHOICES)
    
    # Configuración del módulo
    icon = models.CharField(max_length=50, default='default', help_text="Nombre del ícono (ej: chart-bar, users)")
    route_path = models.CharField(max_length=200, help_text="Ruta frontend (ej: /dashboard/sales)")
    api_endpoint = models.CharField(max_length=200, blank=True, help_text="Endpoint API principal (ej: /api/v1/sales/)")
    
    # Permisos y configuración
    requires_special_permission = models.BooleanField(default=False)
    is_visible_in_menu = models.BooleanField(default=True)
    display_order = models.IntegerField(default=0, help_text="Orden de visualización en menú")
    
    # Estado
    is_active = models.BooleanField(default=True)
    is_beta = models.BooleanField(default=False)
    
    # Auditoría
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='modules_created'
    )

    class Meta:
        db_table = 'system_module'
        verbose_name = 'Módulo del Sistema'
        verbose_name_plural = 'Módulos del Sistema'
        ordering = ['display_order', 'name']

    def __str__(self):
        return f"{self.name} ({self.code})"


class ModuleProfile(models.Model):
    """
    Perfiles de módulos (conjunto predefinido de módulos para roles específicos)
    Ejemplo: "Perfil Ventas", "Perfil Supervisor", etc.
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    code = models.CharField(max_length=50, unique=True)
    description = models.TextField(blank=True)
    
    # Relación con roles UC-005
    default_for_role = models.CharField(
        max_length=20,
        choices=CallCenterUser.ROLE_CHOICES,
        null=True,
        blank=True,
        help_text="Rol por defecto que recibe este perfil"
    )
    
    # Usuarios asignados
    users = models.ManyToManyField(
        CallCenterUser,
        through='UserProfileAssignment',
        related_name='module_profiles'
    )
    
    # Estado
    is_active = models.BooleanField(default=True)
    is_default = models.BooleanField(default=False, help_text="Perfil por defecto para nuevos usuarios")
    
    # Auditoría
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    created_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='profiles_created'
    )

    class Meta:
        db_table = 'module_profile'
        verbose_name = 'Perfil de Módulos'
        verbose_name_plural = 'Perfiles de Módulos'
        ordering = ['name']

    def __str__(self):
        return self.name

    def get_modules(self):
        """Obtiene todos los módulos asignados a este perfil"""
        return SystemModule.objects.filter(
            profile_assignments__profile=self,
            profile_assignments__is_active=True,
            is_active=True
        )


class ModuleProfileAssignment(models.Model):
    """
    Asignación de módulos a perfiles (many-to-many con metadata)
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    profile = models.ForeignKey(
        ModuleProfile,
        on_delete=models.CASCADE,
        related_name='module_assignments'
    )
    module = models.ForeignKey(
        SystemModule,
        on_delete=models.CASCADE,
        related_name='profile_assignments'
    )
    
    # Permisos específicos en el módulo
    can_read = models.BooleanField(default=True)
    can_write = models.BooleanField(default=False)
    can_delete = models.BooleanField(default=False)
    can_export = models.BooleanField(default=False)
    
    # Estado
    is_active = models.BooleanField(default=True)
    
    # Auditoría
    assigned_at = models.DateTimeField(auto_now_add=True)
    assigned_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='module_profile_assignments_made'
    )

    class Meta:
        db_table = 'module_profile_assignment'
        verbose_name = 'Asignación Módulo-Perfil'
        verbose_name_plural = 'Asignaciones Módulo-Perfil'
        unique_together = ['profile', 'module']
        ordering = ['profile', 'module__display_order']

    def __str__(self):
        return f"{self.profile.name} -> {self.module.name}"


class UserProfileAssignment(models.Model):
    """
    Asignación de perfiles a usuarios (many-to-many con metadata)
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        CallCenterUser,
        on_delete=models.CASCADE,
        related_name='profile_assignments'
    )
    profile = models.ForeignKey(
        ModuleProfile,
        on_delete=models.CASCADE,
        related_name='user_assignments'
    )
    
    # Estado
    is_active = models.BooleanField(default=True)
    
    # Auditoría
    assigned_at = models.DateTimeField(auto_now_add=True)
    assigned_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='user_profile_assignments_made'
    )
    expires_at = models.DateTimeField(null=True, blank=True, help_text="Fecha de expiración del perfil")

    class Meta:
        db_table = 'user_profile_assignment'
        verbose_name = 'Asignación Usuario-Perfil'
        verbose_name_plural = 'Asignaciones Usuario-Perfil'
        unique_together = ['user', 'profile']
        ordering = ['-assigned_at']

    def __str__(self):
        return f"{self.user.username} -> {self.profile.name}"

    @property
    def is_expired(self):
        """Verifica si la asignación ha expirado"""
        if self.expires_at:
            return timezone.now() > self.expires_at
        return False


class UserModuleAssignment(models.Model):
    """
    Asignación directa de módulos a usuarios (override de perfiles)
    Para casos especiales donde un usuario necesita módulos adicionales
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        CallCenterUser,
        on_delete=models.CASCADE,
        related_name='user_module_assignments'
    )
    module = models.ForeignKey(
        SystemModule,
        on_delete=models.CASCADE,
        related_name='user_assignments'
    )
    
    # Permisos específicos
    can_read = models.BooleanField(default=True)
    can_write = models.BooleanField(default=False)
    can_delete = models.BooleanField(default=False)
    can_export = models.BooleanField(default=False)
    
    # Razón de asignación especial
    assignment_reason = models.TextField(blank=True, help_text="Por qué se asignó este módulo directamente")
    
    # Estado
    is_active = models.BooleanField(default=True)
    
    # Auditoría
    assigned_at = models.DateTimeField(auto_now_add=True)
    assigned_by = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        related_name='direct_module_assignments_made'
    )
    expires_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'user_module_assignment'
        verbose_name = 'Asignación Directa Usuario-Módulo'
        verbose_name_plural = 'Asignaciones Directas Usuario-Módulo'
        unique_together = ['user', 'module']
        ordering = ['-assigned_at']

    def __str__(self):
        return f"{self.user.username} -> {self.module.name} (Directo)"

    @property
    def is_expired(self):
        """Verifica si la asignación ha expirado"""
        if self.expires_at:
            return timezone.now() > self.expires_at
        return False


class ModuleAccessLog(models.Model):
    """
    Log de acceso a módulos para auditoría UC-005
    """
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        CallCenterUser,
        on_delete=models.CASCADE,
        related_name='module_access_logs'
    )
    module = models.ForeignKey(
        SystemModule,
        on_delete=models.CASCADE,
        related_name='access_logs'
    )
    
    # Detalles del acceso
    action = models.CharField(max_length=50, help_text="Acción realizada (VIEW, EXPORT, etc.)")
    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField(blank=True)
    
    # Resultado
    was_successful = models.BooleanField(default=True)
    error_message = models.TextField(blank=True)
    
    # Timestamp
    accessed_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'module_access_log'
        verbose_name = 'Log de Acceso a Módulo'
        verbose_name_plural = 'Logs de Acceso a Módulos'
        ordering = ['-accessed_at']
        indexes = [
            models.Index(fields=['user', 'accessed_at']),
            models.Index(fields=['module', 'accessed_at']),
        ]

    def __str__(self):
        return f"{self.user.username} -> {self.module.name} @ {self.accessed_at}"


class LoginAttempt(models.Model):
    """
    Registro de intentos de login para auditoría UC-005
    """
    ATTEMPT_TYPE_CHOICES = [
        ('SUCCESS', 'Éxito'),
        ('FAILED', 'Fallido'),
        ('LOCKED', 'Cuenta Bloqueada'),
        ('LOGOUT', 'Logout'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    username = models.CharField(max_length=150, db_index=True)
    user = models.ForeignKey(
        CallCenterUser,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='login_attempts'
    )
    attempt_type = models.CharField(max_length=10, choices=ATTEMPT_TYPE_CHOICES)
    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField(blank=True)
    error_details = models.TextField(blank=True)
    attempted_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'login_attempt'
        verbose_name = 'Intento de Login'
        verbose_name_plural = 'Intentos de Login'
        ordering = ['-attempted_at']
        indexes = [
            models.Index(fields=['username', 'attempted_at']),
            models.Index(fields=['user', 'attempted_at']),
        ]

    def __str__(self):
        return f"{self.username} - {self.get_attempt_type_display()} @ {self.attempted_at}"

    @classmethod
    def log_attempt(cls, username, attempt_type, ip_address, user_agent='', error_details='', user=None):
        """Método helper para registrar intentos de login"""
        return cls.objects.create(
            username=username,
            user=user,
            attempt_type=attempt_type,
            ip_address=ip_address,
            user_agent=user_agent,
            error_details=error_details
        )
