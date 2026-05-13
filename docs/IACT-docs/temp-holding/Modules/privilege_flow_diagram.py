# authentication/management/commands/setup_department_modules.py
"""
Configura los módulos iniciales por departamento
"""
from django.core.management.base import BaseCommand
from django.db import transaction
from authentication.models import C_MENU2, DepartmentModuleAccess


class Command(BaseCommand):
    help = 'Configura módulos por departamento según UC-005'

    def handle(self, *args, **options):
        self.stdout.write('Configurando módulos por departamento...\n')
        
        # Estructura de módulos
        modules_structure = [
            # MÓDULOS COMPARTIDOS (Nivel 1)
            {
                'DES_MENU': 'INICIO',
                'DES_NAME': 'Inicio',
                'NIVEL': 1,
                'ID_PARENT': None,
                'owner': 'SHARED',
                'departments': [],  # Todos pueden ver
                'children': []
            },
            
            # MÓDULOS DE OPERACIONES
            {
                'DES_MENU': 'OPERACIONES',
                'DES_NAME': 'Operaciones',
                'NIVEL': 1,
                'ID_PARENT': None,
                'owner': 'OPERACIONES',
                'departments': ['OPERACIONES'],
                'children': [
                    {
                        'DES_MENU': 'DASHBOARD_AGENTE',
                        'DES_NAME': 'Mi Dashboard',
                        'HREF': 'dashboard-agente.asp'
                    },
                    {
                        'DES_MENU': 'MIS_METRICAS',
                        'DES_NAME': 'Mis Métricas',
                        'HREF': 'metricas-personales.asp'
                    },
                    {
                        'DES_MENU': 'BASE_CONOCIMIENTO',
                        'DES_NAME': 'Base de Conocimiento',
                        'HREF': 'knowledge-base.asp'
                    }
                ]
            },
            
            # MÓDULOS DE SUPERVISIÓN
            {
                'DES_MENU': 'SUPERVISION',
                'DES_NAME': 'Supervisión',
                'NIVEL': 1,
                'ID_PARENT': None,
                'owner': 'SUPERVISION',
                'departments': ['SUPERVISION'],
                'children': [
                    {
                        'DES_MENU': 'DASHBOARD_SUPERVISOR',
                        'DES_NAME': 'Dashboard Supervisor',
                        'HREF': 'dashboard-supervisor.asp'
                    },
                    {
                        'DES_MENU': 'MONITOR_TIEMPO_REAL',
                        'DES_NAME': 'Monitor Tiempo Real',
                        'HREF': 'realtime-monitor.asp'
                    },
                    {
                        'DES_MENU': 'GESTION_EQUIPO',
                        'DES_NAME': 'Gestión de Equipo',
                        'HREF': 'team-management.asp'
                    },
                    {
                        'DES_MENU': 'REPORTES_EQUIPO',
                        'DES_NAME': 'Reportes de Equipo',
                        'HREF': 'team-reports.asp'
                    }
                ]
            },
            
            # MÓDULOS DE GERENCIA
            {
                'DES_MENU': 'GERENCIA',
                'DES_NAME': 'Gerencia',
                'NIVEL': 1,
                'ID_PARENT': None,
                'owner': 'GERENCIA',
                'departments': ['GERENCIA'],
                'children': [
                    {
                        'DES_MENU': 'DASHBOARD_GERENCIAL',
                        'DES_NAME': 'Dashboard Gerencial',
                        'HREF': 'dashboard-gerencia.asp'
                    },
                    {
                        'DES_MENU': 'REPORTES_AVANZADOS',
                        'DES_NAME': 'Reportes Avanzados',
                        'HREF': 'advanced-reports.asp'
                    },
                    {
                        'DES_MENU': 'ANALYTICS',
                        'DES_NAME': 'Analytics',
                        'HREF': 'analytics.asp'
                    },
                    {
                        'DES_MENU': 'CONFIG_CAMPANAS',
                        'DES_NAME': 'Configuración Campañas',
                        'HREF': 'campaign-config.asp'
                    }
                ]
            },
            
            # MÓDULOS DE TI
            {
                'DES_MENU': 'TECNOLOGIA',
                'DES_NAME': 'Tecnología',
                'NIVEL': 1,
                'ID_PARENT': None,
                'owner': 'TECNOLOGIA',
                'departments': ['TECNOLOGIA'],
                'children': [
                    {
                        'DES_MENU': 'ADMIN_USUARIOS',
                        'DES_NAME': 'Administración Usuarios',
                        'HREF': 'user-admin.asp'
                    },
                    {
                        'DES_MENU': 'ADMIN_PERMISOS',
                        'DES_NAME': 'Administración Permisos',
                        'HREF': 'permission-admin.asp'
                    },
                    {
                        'DES_MENU': 'LOGS_SISTEMA',
                        'DES_NAME': 'Logs del Sistema',
                        'HREF': 'system-logs.asp'
                    },
                    {
                        'DES_MENU': 'CONFIG_SISTEMA',
                        'DES_NAME': 'Configuración Sistema',
                        'HREF': 'system-config.asp'
                    }
                ]
            },
            
            # MÓDULOS TRANSVERSALES (pueden ser asignados a cualquiera)
            {
                'DES_MENU': 'REPORTES',
                'DES_NAME': 'Reportes',
                'NIVEL': 1,
                'ID_PARENT': None,
                'owner': 'SHARED',
                'departments': ['SUPERVISION', 'GERENCIA'],  # Solo estos por defecto
                'children': [
                    {
                        'DES_MENU': 'REPORTE_DIARIO',
                        'DES_NAME': 'Reporte Diario',
                        'HREF': 'daily-report.asp'
                    },
                    {
                        'DES_MENU': 'REPORTE_ACUMULADO',
                        'DES_NAME': 'Reporte Acumulado',
                        'HREF': 'accumulated-report.asp'
                    }
                ]
            }
        ]
        
        with transaction.atomic():
            orden_general = 0
            
            for module_data in modules_structure:
                orden_general += 1
                
                # Crear módulo padre
                parent_module, created = C_MENU2.objects.update_or_create(
                    DES_MENU=module_data['DES_MENU'],
                    defaults={
                        'NIVEL': module_data['NIVEL'],
                        'ID_PARENT': module_data['ID_PARENT'],
                        'DES_NAME': module_data['DES_NAME'],
                        'STATUS': 'ACTIVO',
                        'TARGET': 'main',
                        'HREF': 'menu.asp',
                        'ORDEN': orden_general,
                        'module_owner_department': module_data['owner'],
                        'required_departments': module_data['departments']
                    }
                )
                
                if created:
                    self.stdout.write(self.style.SUCCESS(f'✓ Creado: {parent_module.DES_NAME}'))
                else:
                    self.stdout.write(f'↻ Actualizado: {parent_module.DES_NAME}')
                
                # Configurar acceso por departamento
                if module_data['departments']:
                    for dept in module_data['departments']:
                        DepartmentModuleAccess.objects.get_or_create(
                            department=dept,
                            module=parent_module,
                            defaults={
                                'module_parent_id': 0,
                                'default_can_read': True,
                                'default_can_write': dept in ['GERENCIA', 'TECNOLOGIA'],
                                'default_can_export': dept in ['SUPERVISION', 'GERENCIA', 'TECNOLOGIA'],
                                'is_core_module': True
                            }
                        )
                
                # Crear módulos hijos
                orden_hijo = 0
                for child_data in module_data.get('children', []):
                    orden_hijo += 1
                    
                    child_module, created = C_MENU2.objects.update_or_create(
                        DES_MENU=child_data['DES_MENU'],
                        defaults={
                            'NIVEL': 2,
                            'ID_PARENT': parent_module.ID_MENU,
                            'DES_NAME': child_data['DES_NAME'],
                            'STATUS': 'ACTIVO',
                            'TARGET': 'main',
                            'HREF': child_data.get('HREF', 'index.asp'),
                            'ORDEN': orden_hijo,
                            'module_owner_department': module_data['owner'],
                            'required_departments': module_data['departments']
                        }
                    )
                    
                    if created:
                        self.stdout.write(f'  └─ ✓ {child_module.DES_NAME}')
                    
                    # Configurar acceso del hijo
                    if module_data['departments']:
                        for dept in module_data['departments']:
                            DepartmentModuleAccess.objects.get_or_create(
                                department=dept,
                                module=child_module,
                                defaults={
                                    'module_parent_id': parent_module.ID_MENU,
                                    'default_can_read': True,
                                    'default_can_write': dept in ['GERENCIA', 'TECNOLOGIA'],
                                    'default_can_export': dept in ['SUPERVISION', 'GERENCIA', 'TECNOLOGIA'],
                                    'is_core_module': True
                                }
                            )
        
        self.stdout.write(self.style.SUCCESS('\n✓ Configuración de módulos completada'))
        
        # Mostrar resumen
        self.show_summary()
    
    def show_summary(self):
        """Muestra resumen de la configuración"""
        self.stdout.write('\n' + '='*60)
        self.stdout.write('RESUMEN DE CONFIGURACIÓN')
        self.stdout.write('='*60)
        
        for dept in ['OPERACIONES', 'SUPERVISION', 'GERENCIA', 'TECNOLOGIA']:
            count = DepartmentModuleAccess.objects.filter(department=dept).count()
            self.stdout.write(f'{dept}: {count} módulos asignados')
        
        total_modules = C_MENU2.objects.filter(STATUS='ACTIVO').count()
        self.stdout.write(f'\nTotal de módulos activos: {total_modules}')