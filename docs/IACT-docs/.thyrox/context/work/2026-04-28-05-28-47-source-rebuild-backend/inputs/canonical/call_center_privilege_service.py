# authentication/services/call_center_privilege_service.py
"""
Servicio de privilegios adaptado al dominio del Call Center
"""
from django.db import transaction, connection
from django.utils import timezone
from datetime import datetime, time
from authentication.models import (
    CallCenterUser, CallCenterModule, Campaign,
    ModuleByCampaign, UserModulePrivilege,
    QualityModuleAccess, UserCampaignAssignment
)


class CallCenterPrivilegeService:
    """
    Maneja privilegios de módulos en el contexto del Call Center
    """
    
    @staticmethod
    @transaction.atomic
    def assign_module_privilege_by_role(user_id, campaign_id, assigned_by_id):
        """
        Asigna privilegios automáticamente basado en el rol del usuario en la campaña
        """
        # Obtener asignación del usuario a la campaña
        user_campaign = UserCampaignAssignment.objects.get(
            user_id=user_id,
            campaign_id=campaign_id
        )
        
        # Definir módulos por rol
        role_modules = {
            'AGENT': [
                'DASHBOARD_AGENT',
                'MY_METRICS',
                'KNOWLEDGE_BASE',
                'SCHEDULE_VIEW'
            ],
            'TEAM_LEAD': [
                'DASHBOARD_AGENT',
                'DASHBOARD_TEAM',
                'MY_METRICS',
                'TEAM_METRICS',
                'KNOWLEDGE_BASE',
                'SCHEDULE_VIEW',
                'SCHEDULE_MANAGE'
            ],
            'SUPERVISOR': [
                'DASHBOARD_SUPERVISOR',
                'REALTIME_MONITOR',
                'REPORTS_OPERATIONAL',
                'TEAM_METRICS',
                'AGENT_MANAGEMENT',
                'SCHEDULE_MANAGE',
                'QUALITY_MONITOR'
            ],
            'QUALITY': [
                'QUALITY_EVALUATION',
                'QUALITY_REPORTS',
                'CALL_RECORDINGS',
                'AGENT_FEEDBACK',
                'CALIBRATION'
            ],
            'TRAINER': [
                'TRAINING_MODULES',
                'AGENT_PROGRESS',
                'KNOWLEDGE_BASE_ADMIN',
                'QUIZ_MANAGEMENT'
            ]
        }
        
        # Obtener módulos para el rol
        module_codes = role_modules.get(user_campaign.role_in_campaign, [])
        
        # Asignar cada módulo disponible en la campaña
        for module_code in module_codes:
            try:
                module = CallCenterModule.objects.get(
                    DES_MENU=module_code,
                    STATUS='ACTIVO'
                )
                
                # Verificar que el módulo esté habilitado para la campaña
                if ModuleByCampaign.objects.filter(
                    campaign_id=campaign_id,
                    module=module
                ).exists():
                    
                    # Determinar permisos según el rol
                    permissions = cls._get_permissions_by_role(
                        user_campaign.role_in_campaign,
                        module.category
                    )
                    
                    # Crear privilegio
                    UserModulePrivilege.objects.update_or_create(
                        user_id=user_id,
                        module=module,
                        campaign_id=campaign_id,
                        defaults={
                            'module_parent_id': module.ID_PARENT or 0,
                            'assigned_by_id': assigned_by_id,
                            **permissions
                        }
                    )
                    
                    # Si el módulo tiene hijos, asignarlos también
                    cls._assign_child_modules(
                        user_id, 
                        module.ID_MENU, 
                        campaign_id, 
                        assigned_by_id,
                        permissions
                    )
                    
            except CallCenterModule.DoesNotExist:
                continue
        
        return True
    
    @staticmethod
    def _get_permissions_by_role(role, module_category):
        """
        Determina permisos específicos según rol y categoría del módulo
        """
        permissions = {
            'can_view': True,
            'can_export': False,
            'can_view_realtime': False,
            'can_modify_settings': False,
            'can_view_other_agents': False
        }
        
        # Permisos por rol
        if role == 'SUPERVISOR':
            permissions.update({
                'can_export': True,
                'can_view_realtime': True,
                'can_modify_settings': True,
                'can_view_other_agents': True
            })
        elif role == 'TEAM_LEAD':
            permissions.update({
                'can_export': True,
                'can_view_other_agents': True
            })
            if module_category == 'REALTIME':
                permissions['can_view_realtime'] = True
        elif role == 'QUALITY':
            permissions.update({
                'can_export': True,
                'can_view_other_agents': True
            })
        
        return permissions
    
    @staticmethod
    def _assign_child_modules(user_id, parent_id, campaign_id, assigned_by_id, parent_permissions):
        """
        Asigna módulos hijos recursivamente
        """
        child_modules = CallCenterModule.objects.filter(
            ID_PARENT=parent_id,
            STATUS='ACTIVO'
        )
        
        for child in child_modules:
            # Verificar que el hijo esté disponible en la campaña
            if ModuleByCampaign.objects.filter(
                campaign_id=campaign_id,
                module=child
            ).exists():
                
                UserModulePrivilege.objects.update_or_create(
                    user_id=user_id,
                    module=child,
                    campaign_id=campaign_id,
                    defaults={
                        'module_parent_id': parent_id,
                        'assigned_by_id': assigned_by_id,
                        **parent_permissions
                    }
                )
                
                # Recursión para nietos
                CallCenterPrivilegeService._assign_child_modules(
                    user_id,
                    child.ID_MENU,
                    campaign_id,
                    assigned_by_id,
                    parent_permissions
                )
    
    @staticmethod
    def check_module_access(user_id, module_code, campaign_id):
        """
        Verifica si el usuario tiene acceso a un módulo específico
        considerando horarios, vigencia y permisos
        """
        try:
            privilege = UserModulePrivilege.objects.select_related(
                'module', 'campaign'
            ).get(
                user_id=user_id,
                module__DES_MENU=module_code,
                campaign_id=campaign_id
            )
            
            # Verificar vigencia temporal
            if not privilege.is_valid:
                return False, "Privilegio fuera de vigencia"
            
            # Verificar horario de disponibilidad del módulo
            module_campaign = ModuleByCampaign.objects.filter(
                campaign_id=campaign_id,
                module=privilege.module
            ).first()
            
            if module_campaign:
                current_time = datetime.now().time()
                if module_campaign.available_start_time and module_campaign.available_end_time:
                    if not (module_campaign.available_start_time <= current_time <= module_campaign.available_end_time):
                        return False, "Módulo fuera de horario disponible"
            
            # Verificar estado de la campaña
            if not privilege.campaign.is_active:
                return False, "Campaña inactiva"
            
            return True, "Acceso permitido"
            
        except UserModulePrivilege.DoesNotExist:
            return False, "Sin privilegios para este módulo"
    
    @staticmethod
    def assign_quality_module_access(user_id, module_id, teams, assigned_by_id):
        """
        Asigna acceso especial para módulos de calidad
        """
        # Verificar que el usuario sea analista de calidad
        user = CallCenterUser.objects.get(id=user_id)
        if not user.is_quality_analyst:
            raise ValueError("Usuario no es analista de calidad")
        
        # Crear acceso de calidad
        quality_access, created = QualityModuleAccess.objects.update_or_create(
            user_id=user_id,
            module_id=module_id,
            defaults={
                'allowed_teams': teams,
                'assigned_by_id': assigned_by_id,
                'can_evaluate_calls': True,
                'can_export_evaluations': True
            }
        )
        
        # Actualizar flag en usuario
        user.is_quality_analyst = True
        user.save(update_fields=['is_quality_analyst'])
        
        return quality_access
    
    @staticmethod
    def get_user_dashboard_modules(user_id, campaign_id):
        """
        Obtiene módulos organizados para mostrar en el dashboard del usuario
        """
        query = """
            WITH ModuleHierarchy AS (
                -- Módulos raíz con acceso
                SELECT 
                    m.ID_MENU,
                    m.NIVEL,
                    m.ID_PARENT,
                    m.DES_MENU,
                    m.DES_NAME,
                    m.ORDEN,
                    m.HREF,
                    m.IMAGE,
                    m.category,
                    m.refresh_interval_seconds,
                    p.can_view,
                    p.can_export,
                    p.can_view_realtime,
                    p.can_modify_settings,
                    p.can_view_other_agents,
                    mc.is_mandatory
                FROM call_center_modules m
                INNER JOIN user_module_privileges p ON m.ID_MENU = p.module_id
                INNER JOIN module_by_campaign mc ON m.ID_MENU = mc.module_id 
                    AND mc.campaign_id = p.campaign_id
                WHERE p.user_id = %s 
                    AND p.campaign_id = %s
                    AND m.STATUS = 'ACTIVO'
                    AND m.NIVEL = 1
                    AND p.can_view = true
                    AND (p.valid_from IS NULL OR p.valid_from <= NOW())
                    AND (p.valid_until IS NULL OR p.valid_until >= NOW())
                
                UNION ALL
                
                -- Módulos hijos recursivos
                SELECT 
                    m.ID_MENU,
                    m.NIVEL,
                    m.ID_PARENT,
                    m.DES_MENU,
                    m.DES_NAME,
                    m.ORDEN,
                    m.HREF,
                    m.IMAGE,
                    m.category,
                    m.refresh_interval_seconds,
                    h.can_view,
                    h.can_export,
                    h.can_view_realtime,
                    h.can_modify_settings,
                    h.can_view_other_agents,
                    mc.is_mandatory
                FROM call_center_modules m
                INNER JOIN ModuleHierarchy h ON m.ID_PARENT = h.ID_MENU
                INNER JOIN user_module_privileges p ON m.ID_MENU = p.module_id
                INNER JOIN module_by_campaign mc ON m.ID_MENU = mc.module_id 
                    AND mc.campaign_id = p.campaign_id
                WHERE p.user_id = %s 
                    AND p.campaign_id = %s
                    AND m.STATUS = 'ACTIVO'
                    AND p.can_view = true
            )
            SELECT * FROM ModuleHierarchy
            ORDER BY NIVEL, ID_PARENT, ORDEN
        """
        
        with connection.cursor() as cursor:
            cursor.execute(query, [user_id, campaign_id, user_id, campaign_id])
            columns = [col[0] for col in cursor.description]
            modules = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        # Organizar por categorías
        categorized_modules = {
            'OPERATIONS': [],
            'QUALITY': [],
            'REPORTS': [],
            'REALTIME': [],
            'WORKFORCE': [],
            'TRAINING': [],
            'ADMIN': []
        }
        
        for module in modules:
            category = module.get('category', 'OPERATIONS')
            if category in categorized_modules:
                categorized_modules[category].append(module)
        
        return categorized_modules