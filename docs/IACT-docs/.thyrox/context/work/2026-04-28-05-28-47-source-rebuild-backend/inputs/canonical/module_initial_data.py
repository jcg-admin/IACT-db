"""
Django management command to setup initial modules and profiles - UC-005
Call Center Dashboard - Población de datos iniciales del sistema de módulos

Uso:
    python manage.py setup_modules
"""
from django.core.management.base import BaseCommand
from django.db import transaction
from authentication.models import (
    SystemModule,
    ModuleProfile,
    ModuleProfileAssignment,
    CallCenterUser
)


class Command(BaseCommand):
    help = 'Configura módulos y perfiles iniciales para el sistema Call Center'

    def add_arguments(self, parser):
        parser.add_argument(
            '--reset',
            action='store_true',
            help='Elimina y recrea todos los módulos y perfiles',
        )

    def handle(self, *args, **options):
        if options['reset']:
            self.stdout.write(self.style.WARNING('Eliminando módulos y perfiles existentes...'))
            ModuleProfileAssignment.objects.all().delete()
            ModuleProfile.objects.all().delete()
            SystemModule.objects.all().delete()
            self.stdout.write(self.style.SUCCESS('✓ Datos eliminados'))

        self.stdout.write(self.style.HTTP_INFO('Creando módulos del sistema...'))
        
        with transaction.atomic():
            modules = self.create_modules()
            profiles = self.create_profiles()
            self.assign_modules_to_profiles(modules, profiles)

        self.stdout.write(self.style.SUCCESS(f'\n✓ Sistema configurado exitosamente!'))
        self.stdout.write(self.style.SUCCESS(f'  • {len(modules)} módulos creados'))
        self.stdout.write(self.style.SUCCESS(f'  • {len(profiles)} perfiles creados'))

    def create_modules(self):
        """Crea módulos iniciales del sistema"""
        modules_data = [
            # Dashboard Principal
            {
                'name': 'Dashboard Principal',
                'code': 'DASHBOARD_MAIN',
                'description': 'Panel principal con métricas y resumen general del call center',
                'module_type': 'DASHBOARD',
                'icon': 'home',
                'route_path': '/dashboard',
                'api_endpoint': '/api/v1/dashboard/',
                'display_order': 1,
            },
            
            # Ventas
            {
                'name': 'Módulo de Ventas',
                'code': 'SALES',
                'description': 'Gestión de ventas, cotizaciones y seguimiento de clientes',
                'module_type': 'SALES',
                'icon': 'shopping-cart',
                'route_path': '/dashboard/sales',
                'api_endpoint': '/api/v1/sales/',
                'display_order': 2,
            },
            {
                'name': 'Reportes de Ventas',
                'code': 'SALES_REPORTS',
                'description': 'Reportes y análisis de ventas realizadas',
                'module_type': 'REPORTS',
                'icon': 'chart-line',
                'route_path': '/dashboard/sales/reports',
                'api_endpoint': '/api/v1/sales/reports/',
                'display_order': 3,
            },
            
            # Analítica
            {
                'name': 'Analítica General',
                'code': 'ANALYTICS',
                'description': 'Análisis general de datos y métricas del call center',
                'module_type': 'ANALYTICS',
                'icon': 'chart-bar',
                'route_path': '/dashboard/analytics',
                'api_endpoint': '/api/v1/analytics/',
                'display_order': 4,
            },
            {
                'name': 'Analítica Avanzada',
                'code': 'ANALYTICS_ADVANCED',
                'description': 'Análisis predictivo y reportes avanzados',
                'module_type': 'ANALYTICS',
                'icon': 'chart-pie',
                'route_path': '/dashboard/analytics/advanced',
                'api_endpoint': '/api/v1/analytics/advanced/',
                'display_order': 5,
                'requires_special_permission': True,
            },
            
            # Reportes
            {
                'name': 'Reportes Generales',
                'code': 'REPORTS',
                'description': 'Reportes generales del call center',
                'module_type': 'REPORTS',
                'icon': 'file-text',
                'route_path': '/dashboard/reports',
                'api_endpoint': '/api/v1/reports/',
                'display_order': 6,
            },
            {
                'name': 'Exportación de Datos',
                'code': 'DATA_EXPORT',
                'description': 'Exportación de datos a Excel, CSV y PDF',
                'module_type': 'REPORTS',
                'icon': 'download',
                'route_path': '/dashboard/reports/export',
                'api_endpoint': '/api/v1/reports/export/',
                'display_order': 7,
            },
            
            # Monitoreo
            {
                'name': 'Monitoreo en Tiempo Real',
                'code': 'MONITORING_REALTIME',
                'description': 'Monitoreo de llamadas y agentes en tiempo real',
                'module_type': 'MONITORING',
                'icon': 'activity',
                'route_path': '/dashboard/monitoring',
                'api_endpoint': '/api/v1/monitoring/',
                'display_order': 8,
            },
            {
                'name': 'Grabaciones de Llamadas',
                'code': 'CALL_RECORDINGS',
                'description': 'Acceso a grabaciones de llamadas',
                'module_type': 'MONITORING',
                'icon': 'mic',
                'route_path': '/dashboard/monitoring/recordings',
                'api_endpoint': '/api/v1/monitoring/recordings/',
                'display_order': 9,
                'requires_special_permission': True,
            },
            
            # Calidad
            {
                'name': 'Control de Calidad',
                'code': 'QUALITY_CONTROL',
                'description': 'Evaluación de calidad de llamadas',
                'module_type': 'QUALITY',
                'icon': 'check-circle',
                'route_path': '/dashboard/quality',
                'api_endpoint': '/api/v1/quality/',
                'display_order': 10,
            },
            {
                'name': 'Auditoría de Calidad',
                'code': 'QUALITY_AUDIT',
                'description': 'Auditoría y seguimiento de estándares de calidad',
                'module_type': 'QUALITY',
                'icon': 'clipboard-check',
                'route_path': '/dashboard/quality/audit',
                'api_endpoint': '/api/v1/quality/audit/',
                'display_order': 11,
                'requires_special_permission': True,
            },
            
            # Capacitación
            {
                'name': 'Capacitación',
                'code': 'TRAINING',
                'description': 'Materiales de capacitación y cursos',
                'module_type': 'TRAINING',
                'icon': 'book-open',
                'route_path': '/dashboard/training',
                'api_endpoint': '/api/v1/training/',
                'display_order': 12,
            },
            
            # Administración
            {
                'name': 'Gestión de Usuarios',
                'code': 'USER_MANAGEMENT',
                'description': 'Administración de usuarios y permisos',
                'module_type': 'ADMIN',
                'icon': 'users',
                'route_path': '/dashboard/admin/users',
                'api_endpoint': '/api/v1/admin/users/',
                'display_order': 13,
                'requires_special_permission': True,
            },
            {
                'name': 'Configuración del Sistema',
                'code': 'SYSTEM_CONFIG',
                'description': 'Configuración general del sistema',
                'module_type': 'ADMIN',
                'icon': 'settings',
                'route_path': '/dashboard/admin/config',
                'api_endpoint': '/api/v1/admin/config/',
                'display_order': 14,
                'requires_special_permission': True,
            },
            {
                'name': 'Logs de Auditoría',
                'code': 'AUDIT_LOGS',
                'description': 'Logs de auditoría y seguridad del sistema',
                'module_type': 'ADMIN',
                'icon': 'file-text',
                'route_path': '/dashboard/admin/audit',
                'api_endpoint': '/api/v1/admin/audit/',
                'display_order': 15,
                'requires_special_permission': True,
            },
        ]

        modules = {}
        for module_data in modules_data:
            module, created = SystemModule.objects.get_or_create(
                code=module_data['code'],
                defaults=module_data
            )
            modules[module.code] = module
            status = 'creado' if created else 'existente'
            self.stdout.write(f'  • {module.name} ({module.code}): {status}')

        return modules

    def create_profiles(self):
        """Crea perfiles iniciales por rol"""
        profiles_data = [
            {
                'name': 'Perfil Analista',
                'code': 'PROFILE_ANALISTA',
                'description': 'Perfil básico para analistas de call center',
                'default_for_role': 'ANALISTA',
            },
            {
                'name': 'Perfil Supervisor',
                'code': 'PROFILE_SUPERVISOR',
                'description': 'Perfil para supervisores con acceso a reportes y monitoreo',
                'default_for_role': 'SUPERVISOR',
            },
            {
                'name': 'Perfil Gerente',
                'code': 'PROFILE_GERENTE',
                'description': 'Perfil ejecutivo con acceso a analítica avanzada',
                'default_for_role': 'GERENTE',
            },
            {
                'name': 'Perfil Administrador',
                'code': 'PROFILE_ADMIN',
                'description': 'Perfil con acceso completo al sistema',
                'default_for_role': 'ADMIN_IT',
            },
        ]

        profiles = {}
        for profile_data in profiles_data:
            profile, created = ModuleProfile.objects.get_or_create(
                code=profile_data['code'],
                defaults=profile_data
            )
            profiles[profile.code] = profile
            status = 'creado' if created else 'existente'
            self.stdout.write(f'  • {profile.name} ({profile.code}): {status}')

        return profiles

    def assign_modules_to_profiles(self, modules, profiles):
        """Asigna módulos a perfiles según roles UC-005"""
        
        # Perfil ANALISTA - Acceso básico
        analista_modules = [
            ('DASHBOARD_MAIN', True, False, False, False),
            ('SALES', True, True, False, True),
            ('SALES_REPORTS', True, False, False, True),
            ('REPORTS', True, False, False, True),
            ('TRAINING', True, False, False, False),
        ]
        
        # Perfil SUPERVISOR - Acceso a monitoreo y calidad
        supervisor_modules = [
            ('DASHBOARD_MAIN', True, False, False, False),
            ('SALES', True, True, False, True),
            ('SALES_REPORTS', True, False, False, True),
            ('ANALYTICS', True, False, False, True),
            ('REPORTS', True, False, False, True),
            ('DATA_EXPORT', True, False, False, True),
            ('MONITORING_REALTIME', True, False, False, False),
            ('CALL_RECORDINGS', True, False, False, False),
            ('QUALITY_CONTROL', True, True, False, True),
            ('TRAINING', True, True, False, False),
        ]
        
        # Perfil GERENTE - Acceso ejecutivo con analítica avanzada
        gerente_modules = [
            ('DASHBOARD_MAIN', True, False, False, False),
            ('SALES', True, False, False, True),
            ('SALES_REPORTS', True, False, False, True),
            ('ANALYTICS', True, False, False, True),
            ('ANALYTICS_ADVANCED', True, False, False, True),
            ('REPORTS', True, False, False, True),
            ('DATA_EXPORT', True, False, False, True),
            ('MONITORING_REALTIME', True, False, False, False),
            ('CALL_RECORDINGS', True, False, False, False),
            ('QUALITY_CONTROL', True, False, False, True),
            ('QUALITY_AUDIT', True, True, False, True),
            ('TRAINING', True, False, False, False),
        ]
        
        # Perfil ADMIN_IT - Acceso completo
        admin_modules = [
            (code, True, True, True, True) 
            for code in modules.keys()
        ]
        
        assignments = {
            'PROFILE_ANALISTA': analista_modules,
            'PROFILE_SUPERVISOR': supervisor_modules,
            'PROFILE_GERENTE': gerente_modules,
            'PROFILE_ADMIN': admin_modules,
        }
        
        self.stdout.write(self.style.HTTP_INFO('\nAsignando módulos a perfiles...'))
        
        for profile_code, module_list in assignments.items():
            profile = profiles[profile_code]
            count = 0
            
            for module_code, can_read, can_write, can_delete, can_export in module_list:
                module = modules[module_code]
                
                ModuleProfileAssignment.objects.update_or_create(
                    profile=profile,
                    module=module,
                    defaults={
                        'can_read': can_read,
                        'can_write': can_write,
                        'can_delete': can_delete,
                        'can_export': can_export,
                        'is_active': True,
                    }
                )
                count += 1
            
            self.stdout.write(f'  • {profile.name}: {count} módulos asignados')
