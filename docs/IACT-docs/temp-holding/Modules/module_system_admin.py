"""
Django Admin configuration for module system - UC-005
Call Center Dashboard - Panel de administración para módulos
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.html import format_html
from django.urls import reverse
from django.utils.safestring import mark_safe
from .models import (
    CallCenterUser,
    SystemModule,
    ModuleProfile,
    ModuleProfileAssignment,
    UserProfileAssignment,
    UserModuleAssignment,
    ModuleAccessLog,
    LoginAttempt
)


@admin.register(CallCenterUser)
class CallCenterUserAdmin(UserAdmin):
    """
    Administración de usuarios Call Center
    """
    list_display = [
        'username', 'email', 'role', 'department', 
        'is_active', 'is_account_locked', 'last_login'
    ]
    list_filter = ['role', 'is_active', 'department', 'date_joined']
    search_fields = ['username', 'email', 'employee_id', 'first_name', 'last_name']
    
    fieldsets = UserAdmin.fieldsets + (
        ('Call Center Info', {
            'fields': (
                'role', 'employee_id', 'department', 
                'phone_extension'
            )
        }),
        ('Security', {
            'fields': (
                'password_changed_at', 'last_login_ip',
                'failed_login_attempts', 'account_locked_until'
            )
        }),
        ('Auditoría', {
            'fields': ('created_at', 'updated_at', 'created_by')
        }),
    )
    
    readonly_fields = [
        'created_at', 'updated_at', 'password_changed_at',
        'last_login_ip', 'failed_login_attempts'
    ]
    
    def is_account_locked(self, obj):
        """Indica si la cuenta está bloqueada"""
        if obj.is_account_locked:
            return format_html(
                '<span style="color: red; font-weight: bold;">🔒 Bloqueada</span>'
            )
        return format_html('<span style="color: green;">✓ Activa</span>')
    is_account_locked.short_description = 'Estado'


@admin.register(SystemModule)
class SystemModuleAdmin(admin.ModelAdmin):
    """
    Administración de módulos del sistema
    """
    list_display = [
        'name', 'code', 'module_type', 'icon_preview',
        'is_visible_in_menu', 'is_active', 'display_order'
    ]
    list_filter = ['module_type', 'is_active', 'is_visible_in_menu', 'is_beta']
    search_fields = ['name', 'code', 'description']
    ordering = ['display_order', 'name']
    
    fieldsets = (
        ('Información Básica', {
            'fields': ('name', 'code', 'description', 'module_type')
        }),
        ('Configuración Visual', {
            'fields': ('icon', 'route_path', 'api_endpoint', 'display_order')
        }),
        ('Permisos y Estado', {
            'fields': (
                'requires_special_permission', 
                'is_visible_in_menu',
                'is_active',
                'is_beta'
            )
        }),
        ('Auditoría', {
            'fields': ('created_at', 'updated_at', 'created_by'),
            'classes': ('collapse',)
        }),
    )
    
    readonly_fields = ['created_at', 'updated_at']
    
    def icon_preview(self, obj):
        """Preview del ícono"""
        return format_html(
            '<i class="icon-{}"></i> {}',
            obj.icon,
            obj.icon
        )
    icon_preview.short_description = 'Ícono'
    
    def save_model(self, request, obj, form, change):
        """Registra quién creó el módulo"""
        if not change:
            obj.created_by = request.user
        super().save_model(request, obj, form, change)


class ModuleProfileAssignmentInline(admin.TabularInline):
    """
    Inline para asignaciones de módulos en perfiles
    """
    model = ModuleProfileAssignment
    extra = 1
    fields = ['module', 'can_read', 'can_write', 'can_delete', 'can_export', 'is_active']
    autocomplete_fields = ['module']


@admin.register(ModuleProfile)
class ModuleProfileAdmin(admin.ModelAdmin):
    """
    Administración de perfiles de módulos
    """
    list_display = [
        'name', 'code', 'default_for_role', 
        'module_count', 'user_count', 'is_active'
    ]
    list_filter = ['default_for_role', 'is_active', 'is_default']
    search_fields = ['name', 'code', 'description']
    
    fieldsets = (
        ('Información Básica', {
            'fields': ('name', 'code', 'description')
        }),
        ('Configuración', {
            'fields': ('default_for_role', 'is_active', 'is_default')
        }),
        ('Auditoría', {
            'fields': ('created_at', 'updated_at', 'created_by'),
            'classes': ('collapse',)
        }),
    )
    
    readonly_fields = ['created_at', 'updated_at']
    inlines = [ModuleProfileAssignmentInline]
    
    def module_count(self, obj):
        """Cantidad de módulos asignados"""
        count = ModuleProfileAssignment.objects.filter(
            profile=obj, 
            is_active=True
        ).count()
        return format_html(
            '<a href="{}?profile__id__exact={}">{} módulos</a>',
            reverse('admin:authentication_moduleprofileassignment_changelist'),
            obj.id,
            count
        )
    module_count.short_description = 'Módulos'
    
    def user_count(self, obj):
        """Cantidad de usuarios con este perfil"""
        count = UserProfileAssignment.objects.filter(
            profile=obj,
            is_active=True
        ).count()
        return format_html(
            '<a href="{}?profile__id__exact={}">{} usuarios</a>',
            reverse('admin:authentication_userprofileassignment_changelist'),
            obj.id,
            count
        )
    user_count.short_description = 'Usuarios'
    
    def save_model(self, request, obj, form, change):
        """Registra quién creó el perfil"""
        if not change:
            obj.created_by = request.user
        super().save_model(request, obj, form, change)


@admin.register(ModuleProfileAssignment)
class ModuleProfileAssignmentAdmin(admin.ModelAdmin):
    """
    Administración de asignaciones módulo-perfil
    """
    list_display = [
        'profile', 'module', 'permissions_summary',
        'is_active', 'assigned_at'
    ]
    list_filter = ['is_active', 'can_read', 'can_write', 'can_delete', 'can_export']
    search_fields = ['profile__name', 'module__name', 'module__code']
    autocomplete_fields = ['profile', 'module']
    date_hierarchy = 'assigned_at'
    
    fieldsets = (
        ('Asignación', {
            'fields': ('profile', 'module')
        }),
        ('Permisos', {
            'fields': ('can_read', 'can_write', 'can_delete', 'can_export')
        }),
        ('Estado', {
            'fields': ('is_active',)
        }),
        ('Auditoría', {
            'fields': ('assigned_at', 'assigned_by'),
            'classes': ('collapse',)
        }),
    )
    
    readonly_fields = ['assigned_at']
    
    def permissions_summary(self, obj):
        """Resumen de permisos"""
        perms = []
        if obj.can_read:
            perms.append('<span style="color: green;">R</span>')
        if obj.can_write:
            perms.append('<span style="color: blue;">W</span>')
        if obj.can_delete:
            perms.append('<span style="color: red;">D</span>')
        if obj.can_export:
            perms.append('<span style="color: orange;">E</span>')
        return mark_safe(' | '.join(perms)) if perms else '-'
    permissions_summary.short_description = 'Permisos (R|W|D|E)'


@admin.register(UserProfileAssignment)
class UserProfileAssignmentAdmin(admin.ModelAdmin):
    """
    Administración de asignaciones usuario-perfil
    """
    list_display = [
        'user', 'profile', 'is_active',
        'assigned_at', 'expires_at', 'is_expired'
    ]
    list_filter = ['is_active', 'profile']
    search_fields = ['user__username', 'user__email', 'profile__name']
    autocomplete_fields = ['user', 'profile']
    date_hierarchy = 'assigned_at'
    
    fieldsets = (
        ('Asignación', {
            'fields': ('user', 'profile')
        }),
        ('Estado y Expiración', {
            'fields': ('is_active', 'expires_at')
        }),
        ('Auditoría', {
            'fields': ('assigned_at', 'assigned_by'),
            'classes': ('collapse',)
        }),
    )
    
    readonly_fields = ['assigned_at', 'is_expired']
    
    def is_expired(self, obj):
        """Indica si la asignación expiró"""
        if obj.is_expired:
            return format_html('<span style="color: red;">✗ Expirada</span>')
        return format_html('<span style="color: green;">✓ Vigente</span>')
    is_expired.short_description = 'Estado'


@admin.register(UserModuleAssignment)
class UserModuleAssignmentAdmin(admin.ModelAdmin):
    """
    Administración de asignaciones directas usuario-módulo
    """
    list_display = [
        'user', 'module', 'permissions_summary',
        'is_active', 'assigned_at', 'expires_at'
    ]
    list_filter = ['is_active', 'module__module_type']
    search_fields = ['user__username', 'module__name', 'assignment_reason']
    autocomplete_fields = ['user', 'module']
    date_hierarchy = 'assigned_at'
    
    fieldsets = (
        ('Asignación', {
            'fields': ('user', 'module', 'assignment_reason')
        }),
        ('Permisos', {
            'fields': ('can_read', 'can_write', 'can_delete', 'can_export')
        }),
        ('Estado y Expiración', {
            'fields': ('is_active', 'expires_at')
        }),
        ('Auditoría', {
            'fields': ('assigned_at', 'assigned_by'),
            'classes': ('collapse',)
        }),
    )
    
    readonly_fields = ['assigned_at']
    
    def permissions_summary(self, obj):
        """Resumen de permisos"""
        perms = []
        if obj.can_read:
            perms.append('<span style="color: green;">R</span>')
        if obj.can_write:
            perms.append('<span style="color: blue;">W</span>')
        if obj.can_delete:
            perms.append('<span style="color: red;">D</span>')
        if obj.can_export:
            perms.append('<span style="color: orange;">E</span>')
        return mark_safe(' | '.join(perms)) if perms else '-'
    permissions_summary.short_description = 'Permisos (R|W|D|E)'


@admin.register(ModuleAccessLog)
class ModuleAccessLogAdmin(admin.ModelAdmin):
    """
    Administración de logs de acceso a módulos
    """
    list_display = [
        'user', 'module', 'action', 
        'was_successful', 'accessed_at', 'ip_address'
    ]
    list_filter = [
        'was_successful', 'action', 'module__module_type',
        'accessed_at'
    ]
    search_fields = ['user__username', 'module__name', 'ip_address']
    date_hierarchy = 'accessed_at'
    
    readonly_fields = [
        'user', 'module', 'action', 'ip_address',
        'user_agent', 'was_successful', 'error_message', 'accessed_at'
    ]
    
    def has_add_permission(self, request):
        """No permitir crear logs manualmente"""
        return False
    
    def has_change_permission(self, request, obj=None):
        """No permitir editar logs"""
        return False


@admin.register(LoginAttempt)
class LoginAttemptAdmin(admin.ModelAdmin):
    """
    Administración de intentos de login
    """
    list_display = [
        'username', 'attempt_type', 'ip_address',
        'attempted_at', 'user'
    ]
    list_filter = ['attempt_type', 'attempted_at']
    search_fields = ['username', 'ip_address', 'user__username']
    date_hierarchy = 'attempted_at'
    
    readonly_fields = [
        'username', 'user', 'attempt_type', 'ip_address',
        'user_agent', 'error_details', 'attempted_at'
    ]
    
    def has_add_permission(self, request):
        """No permitir crear logs manualmente"""
        return False
    
    def has_change_permission(self, request, obj=None):
        """No permitir editar logs"""
        return False
