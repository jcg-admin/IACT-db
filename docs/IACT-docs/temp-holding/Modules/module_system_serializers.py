"""
Serializers for module system - UC-005
Call Center Dashboard - Serializers para módulos dinámicos
"""
from rest_framework import serializers
from .models import (
    CallCenterUser,
    SystemModule,
    ModuleProfile,
    ModuleProfileAssignment,
    UserProfileAssignment,
    UserModuleAssignment,
    ModuleAccessLog
)


class SystemModuleSerializer(serializers.ModelSerializer):
    """
    Serializer para módulos del sistema
    """
    module_type_display = serializers.CharField(source='get_module_type_display', read_only=True)
    
    class Meta:
        model = SystemModule
        fields = [
            'id', 'name', 'code', 'description', 'module_type', 
            'module_type_display', 'icon', 'route_path', 'api_endpoint',
            'requires_special_permission', 'is_visible_in_menu', 
            'display_order', 'is_active', 'is_beta',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']


class ModulePermissionsSerializer(serializers.Serializer):
    """
    Serializer para permisos específicos de un módulo
    """
    can_read = serializers.BooleanField()
    can_write = serializers.BooleanField()
    can_delete = serializers.BooleanField()
    can_export = serializers.BooleanField()


class UserModuleSerializer(serializers.ModelSerializer):
    """
    Serializer para módulos asignados a usuario con permisos
    """
    module_type_display = serializers.CharField(source='get_module_type_display', read_only=True)
    permissions = serializers.SerializerMethodField()
    assignment_source = serializers.SerializerMethodField()
    
    class Meta:
        model = SystemModule
        fields = [
            'id', 'name', 'code', 'description', 'module_type',
            'module_type_display', 'icon', 'route_path', 'api_endpoint',
            'is_visible_in_menu', 'display_order', 'is_beta',
            'permissions', 'assignment_source'
        ]
    
    def get_permissions(self, obj):
        """Obtiene permisos efectivos del usuario en este módulo"""
        user = self.context.get('user')
        if not user:
            return {
                'can_read': False,
                'can_write': False,
                'can_delete': False,
                'can_export': False
            }
        
        # Buscar permisos en asignaciones directas
        direct_assignment = UserModuleAssignment.objects.filter(
            user=user,
            module=obj,
            is_active=True
        ).first()
        
        if direct_assignment:
            return {
                'can_read': direct_assignment.can_read,
                'can_write': direct_assignment.can_write,
                'can_delete': direct_assignment.can_delete,
                'can_export': direct_assignment.can_export
            }
        
        # Buscar permisos en perfil
        profile_assignment = ModuleProfileAssignment.objects.filter(
            profile__users=user,
            profile__is_active=True,
            module=obj,
            is_active=True
        ).first()
        
        if profile_assignment:
            return {
                'can_read': profile_assignment.can_read,
                'can_write': profile_assignment.can_write,
                'can_delete': profile_assignment.can_delete,
                'can_export': profile_assignment.can_export
            }
        
        # Permisos por defecto si solo tiene acceso
        return {
            'can_read': True,
            'can_write': False,
            'can_delete': False,
            'can_export': False
        }
    
    def get_assignment_source(self, obj):
        """Indica de dónde viene la asignación del módulo"""
        user = self.context.get('user')
        if not user:
            return None
        
        # Verificar asignación directa
        if UserModuleAssignment.objects.filter(
            user=user, module=obj, is_active=True
        ).exists():
            return 'direct'
        
        # Verificar asignación por perfil
        profile_assignment = ModuleProfileAssignment.objects.filter(
            profile__users=user,
            profile__is_active=True,
            module=obj,
            is_active=True
        ).first()
        
        if profile_assignment:
            return {
                'type': 'profile',
                'profile_name': profile_assignment.profile.name,
                'profile_code': profile_assignment.profile.code
            }
        
        return None


class ModuleProfileAssignmentSerializer(serializers.ModelSerializer):
    """
    Serializer para asignación módulo-perfil
    """
    module_name = serializers.CharField(source='module.name', read_only=True)
    module_code = serializers.CharField(source='module.code', read_only=True)
    
    class Meta:
        model = ModuleProfileAssignment
        fields = [
            'id', 'module', 'module_name', 'module_code',
            'can_read', 'can_write', 'can_delete', 'can_export',
            'is_active', 'assigned_at'
        ]
        read_only_fields = ['id', 'assigned_at']


class ModuleProfileSerializer(serializers.ModelSerializer):
    """
    Serializer para perfiles de módulos
    """
    modules = serializers.SerializerMethodField()
    module_count = serializers.SerializerMethodField()
    user_count = serializers.SerializerMethodField()
    default_for_role_display = serializers.CharField(
        source='get_default_for_role_display', 
        read_only=True
    )
    
    class Meta:
        model = ModuleProfile
        fields = [
            'id', 'name', 'code', 'description',
            'default_for_role', 'default_for_role_display',
            'is_active', 'is_default',
            'modules', 'module_count', 'user_count',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def get_modules(self, obj):
        """Lista de módulos asignados al perfil"""
        assignments = ModuleProfileAssignment.objects.filter(
            profile=obj,
            is_active=True
        ).select_related('module')
        
        return [{
            'id': str(a.module.id),
            'name': a.module.name,
            'code': a.module.code,
            'icon': a.module.icon,
            'permissions': {
                'can_read': a.can_read,
                'can_write': a.can_write,
                'can_delete': a.can_delete,
                'can_export': a.can_export
            }
        } for a in assignments]
    
    def get_module_count(self, obj):
        """Cantidad de módulos asignados"""
        return ModuleProfileAssignment.objects.filter(
            profile=obj,
            is_active=True
        ).count()
    
    def get_user_count(self, obj):
        """Cantidad de usuarios con este perfil"""
        return UserProfileAssignment.objects.filter(
            profile=obj,
            is_active=True
        ).count()


class UserProfileAssignmentSerializer(serializers.ModelSerializer):
    """
    Serializer para asignación usuario-perfil
    """
    profile_name = serializers.CharField(source='profile.name', read_only=True)
    profile_code = serializers.CharField(source='profile.code', read_only=True)
    is_expired = serializers.BooleanField(read_only=True)
    
    class Meta:
        model = UserProfileAssignment
        fields = [
            'id', 'profile', 'profile_name', 'profile_code',
            'is_active', 'assigned_at', 'expires_at', 'is_expired'
        ]
        read_only_fields = ['id', 'assigned_at']


class UserModuleAssignmentSerializer(serializers.ModelSerializer):
    """
    Serializer para asignación directa usuario-módulo
    """
    module_name = serializers.CharField(source='module.name', read_only=True)
    module_code = serializers.CharField(source='module.code', read_only=True)
    is_expired = serializers.BooleanField(read_only=True)
    
    class Meta:
        model = UserModuleAssignment
        fields = [
            'id', 'module', 'module_name', 'module_code',
            'can_read', 'can_write', 'can_delete', 'can_export',
            'assignment_reason', 'is_active',
            'assigned_at', 'expires_at', 'is_expired'
        ]
        read_only_fields = ['id', 'assigned_at']


class UserModulesDetailSerializer(serializers.Serializer):
    """
    Serializer completo de módulos del usuario con todas las asignaciones
    """
    user_id = serializers.UUIDField()
    username = serializers.CharField()
    role = serializers.CharField()
    
    # Módulos disponibles
    available_modules = UserModuleSerializer(many=True)
    
    # Perfiles asignados
    assigned_profiles = serializers.SerializerMethodField()
    
    # Asignaciones directas
    direct_assignments = serializers.SerializerMethodField()
    
    # Resumen
    total_modules = serializers.IntegerField()
    modules_by_type = serializers.DictField()
    
    def get_assigned_profiles(self, obj):
        """Obtiene perfiles asignados al usuario"""
        user = obj.get('user')
        profiles = UserProfileAssignment.objects.filter(
            user=user,
            is_active=True
        ).select_related('profile')
        
        return UserProfileAssignmentSerializer(profiles, many=True).data
    
    def get_direct_assignments(self, obj):
        """Obtiene asignaciones directas del usuario"""
        user = obj.get('user')
        assignments = UserModuleAssignment.objects.filter(
            user=user,
            is_active=True
        ).select_related('module')
        
        return UserModuleAssignmentSerializer(assignments, many=True).data


class ModuleAccessLogSerializer(serializers.ModelSerializer):
    """
    Serializer para logs de acceso a módulos
    """
    username = serializers.CharField(source='user.username', read_only=True)
    user_role = serializers.CharField(source='user.role', read_only=True)
    module_name = serializers.CharField(source='module.name', read_only=True)
    module_code = serializers.CharField(source='module.code', read_only=True)
    
    class Meta:
        model = ModuleAccessLog
        fields = [
            'id', 'user', 'username', 'user_role',
            'module', 'module_name', 'module_code',
            'action', 'ip_address', 'user_agent',
            'was_successful', 'error_message',
            'accessed_at'
        ]
        read_only_fields = ['id', 'accessed_at']


class AssignModuleToProfileSerializer(serializers.Serializer):
    """
    Serializer para asignar módulos a un perfil
    """
    profile_id = serializers.UUIDField()
    module_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1
    )
    can_read = serializers.BooleanField(default=True)
    can_write = serializers.BooleanField(default=False)
    can_delete = serializers.BooleanField(default=False)
    can_export = serializers.BooleanField(default=False)
    
    def validate_profile_id(self, value):
        """Valida que el perfil exista"""
        if not ModuleProfile.objects.filter(id=value, is_active=True).exists():
            raise serializers.ValidationError("Perfil no encontrado o inactivo")
        return value
    
    def validate_module_ids(self, value):
        """Valida que todos los módulos existan"""
        existing_modules = SystemModule.objects.filter(
            id__in=value,
            is_active=True
        ).count()
        
        if existing_modules != len(value):
            raise serializers.ValidationError("Algunos módulos no existen o están inactivos")
        return value


class AssignProfileToUserSerializer(serializers.Serializer):
    """
    Serializer para asignar perfiles a usuarios
    """
    user_id = serializers.UUIDField()
    profile_ids = serializers.ListField(
        child=serializers.UUIDField(),
        min_length=1
    )
    expires_at = serializers.DateTimeField(required=False, allow_null=True)
    
    def validate_user_id(self, value):
        """Valida que el usuario exista"""
        if not CallCenterUser.objects.filter(id=value, is_active=True).exists():
            raise serializers.ValidationError("Usuario no encontrado o inactivo")
        return value
    
    def validate_profile_ids(self, value):
        """Valida que todos los perfiles existan"""
        existing_profiles = ModuleProfile.objects.filter(
            id__in=value,
            is_active=True
        ).count()
        
        if existing_profiles != len(value):
            raise serializers.ValidationError("Algunos perfiles no existen o están inactivos")
        return value


class AssignModuleToUserSerializer(serializers.Serializer):
    """
    Serializer para asignar módulos directamente a usuarios
    """
    user_id = serializers.UUIDField()
    module_id = serializers.UUIDField()
    can_read = serializers.BooleanField(default=True)
    can_write = serializers.BooleanField(default=False)
    can_delete = serializers.BooleanField(default=False)
    can_export = serializers.BooleanField(default=False)
    assignment_reason = serializers.CharField(required=True, max_length=500)
    expires_at = serializers.DateTimeField(required=False, allow_null=True)
    
    def validate_user_id(self, value):
        """Valida que el usuario exista"""
        if not CallCenterUser.objects.filter(id=value, is_active=True).exists():
            raise serializers.ValidationError("Usuario no encontrado o inactivo")
        return value
    
    def validate_module_id(self, value):
        """Valida que el módulo exista"""
        if not SystemModule.objects.filter(id=value, is_active=True).exists():
            raise serializers.ValidationError("Módulo no encontrado o inactivo")
        return value