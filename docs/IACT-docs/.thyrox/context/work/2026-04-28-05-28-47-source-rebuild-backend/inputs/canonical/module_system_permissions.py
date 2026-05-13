"""
Custom permissions for authentication app - UC-005
Call Center Dashboard - Permisos basados en roles y módulos
"""
from rest_framework import permissions


class IsAdminOrSupervisor(permissions.BasePermission):
    """
    Permiso para ADMIN_IT o SUPERVISOR
    """
    def has_permission(self, request, view):
        return (
            request.user and 
            request.user.is_authenticated and 
            request.user.role in ['ADMIN_IT', 'SUPERVISOR']
        )


class IsAdminIT(permissions.BasePermission):
    """
    Permiso solo para ADMIN_IT
    """
    def has_permission(self, request, view):
        return (
            request.user and 
            request.user.is_authenticated and 
            request.user.role == 'ADMIN_IT'
        )


class IsGerente(permissions.BasePermission):
    """
    Permiso para GERENTE o superior
    """
    def has_permission(self, request, view):
        return (
            request.user and 
            request.user.is_authenticated and 
            request.user.role in ['GERENTE', 'ADMIN_IT']
        )


class HasModulePermission(permissions.BasePermission):
    """
    Verifica que el usuario tenga permiso para acceder a un módulo específico
    """
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # ADMIN_IT tiene acceso a todo
        if request.user.role == 'ADMIN_IT':
            return True
        
        # Obtener module_code del view
        module_code = getattr(view, 'required_module_code', None)
        
        if not module_code:
            # Si no se especifica módulo, permitir acceso
            return True
        
        # Verificar si el usuario tiene el módulo asignado
        user_modules = request.user.get_assigned_modules()
        return any(m.code == module_code for m in user_modules)


class HasModuleWritePermission(permissions.BasePermission):
    """
    Verifica que el usuario tenga permiso de escritura en un módulo
    """
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # ADMIN_IT tiene acceso total
        if request.user.role == 'ADMIN_IT':
            return True
        
        # Métodos seguros (GET, HEAD, OPTIONS) no requieren permiso de escritura
        if request.method in permissions.SAFE_METHODS:
            return True
        
        # Obtener module_code del view
        module_code = getattr(view, 'required_module_code', None)
        
        if not module_code:
            return True
        
        from .models import SystemModule, UserModuleAssignment, ModuleProfileAssignment
        
        try:
            module = SystemModule.objects.get(code=module_code, is_active=True)
            
            # Verificar asignación por perfil
            profile_assignment = ModuleProfileAssignment.objects.filter(
                profile__users=request.user,
                profile__is_active=True,
                module=module,
                is_active=True,
                can_write=True
            ).exists()
            
            return profile_assignment
            
        except SystemModule.DoesNotExist:
            return False


class HasModuleDeletePermission(permissions.BasePermission):
    """
    Verifica que el usuario tenga permiso de eliminación en un módulo
    """
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # ADMIN_IT tiene acceso total
        if request.user.role == 'ADMIN_IT':
            return True
        
        # Solo DELETE requiere este permiso
        if request.method != 'DELETE':
            return True
        
        module_code = getattr(view, 'required_module_code', None)
        
        if not module_code:
            return True
        
        from .models import SystemModule, UserModuleAssignment, ModuleProfileAssignment
        
        try:
            module = SystemModule.objects.get(code=module_code, is_active=True)
            
            # Verificar asignación directa
            direct_assignment = UserModuleAssignment.objects.filter(
                user=request.user,
                module=module,
                is_active=True,
                can_delete=True
            ).exists()
            
            if direct_assignment:
                return True
            
            # Verificar asignación por perfil
            profile_assignment = ModuleProfileAssignment.objects.filter(
                profile__users=request.user,
                profile__is_active=True,
                module=module,
                is_active=True,
                can_delete=True
            ).exists()
            
            return profile_assignment
            
        except SystemModule.DoesNotExist:
            return False


class HasModuleExportPermission(permissions.BasePermission):
    """
    Verifica que el usuario tenga permiso de exportación en un módulo
    """
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # ADMIN_IT tiene acceso total
        if request.user.role == 'ADMIN_IT':
            return True
        
        # Solo acciones de export requieren este permiso
        action = getattr(view, 'action', None)
        if action != 'export':
            return True
        
        module_code = getattr(view, 'required_module_code', None)
        
        if not module_code:
            return True
        
        from .models import SystemModule, UserModuleAssignment, ModuleProfileAssignment
        
        try:
            module = SystemModule.objects.get(code=module_code, is_active=True)
            
            # Verificar asignación directa
            direct_assignment = UserModuleAssignment.objects.filter(
                user=request.user,
                module=module,
                is_active=True,
                can_export=True
            ).exists()
            
            if direct_assignment:
                return True
            
            # Verificar asignación por perfil
            profile_assignment = ModuleProfileAssignment.objects.filter(
                profile__users=request.user,
                profile__is_active=True,
                module=module,
                is_active=True,
                can_export=True
            ).exists()
            
            return profile_assignment
            
        except SystemModule.DoesNotExist:
            return False


class CanManageUsers(permissions.BasePermission):
    """
    Permiso para gestionar usuarios (ADMIN_IT, GERENTE, SUPERVISOR)
    """
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # Roles que pueden gestionar usuarios
        return request.user.role in ['ADMIN_IT', 'GERENTE', 'SUPERVISOR']
    
    def has_object_permission(self, request, view, obj):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # ADMIN_IT puede gestionar a todos
        if request.user.role == 'ADMIN_IT':
            return True
        
        # GERENTE puede gestionar SUPERVISOR y ANALISTA
        if request.user.role == 'GERENTE':
            return obj.role in ['SUPERVISOR', 'ANALISTA']
        
        # SUPERVISOR solo puede gestionar ANALISTA
        if request.user.role == 'SUPERVISOR':
            return obj.role == 'ANALISTA'
        
        return False


class CanViewAuditLogs(permissions.BasePermission):
    """
    Permiso para ver logs de auditoría
    """
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # Solo ADMIN_IT y GERENTE pueden ver todos los logs
        if request.user.role in ['ADMIN_IT', 'GERENTE']:
            return True
        
        # SUPERVISOR puede ver logs de su equipo
        if request.user.role == 'SUPERVISOR':
            # Implementar lógica de equipo si es necesario
            return True
        
        # Otros roles solo pueden ver sus propios logs
        return request.method in permissions.SAFE_METHODS


class IsAccountActive(permissions.BasePermission):
    """
    Verifica que la cuenta del usuario esté activa y no bloqueada
    """
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        # Verificar si está activo
        if not request.user.is_active:
            return False
        
        # Verificar si está bloqueado
        if request.user.is_account_locked:
            return False
        
        return True
ación directa
            direct_assignment = UserModuleAssignment.objects.filter(
                user=request.user,
                module=module,
                is_active=True,
                can_write=True
            ).exists()
            
            if direct_assignment:
                return True
            
            # Verificar asign