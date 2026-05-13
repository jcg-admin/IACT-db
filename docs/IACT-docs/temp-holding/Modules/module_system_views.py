"""
Views for module system - UC-005
Call Center Dashboard - API views para gestión de módulos dinámicos
"""
from rest_framework import status, permissions, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.views import APIView
from django.db import transaction
from django.utils import timezone
from django.db.models import Count, Q
from django_ratelimit.decorators import ratelimit
from django.utils.decorators import method_decorator
from .models import (
    CallCenterUser,
    SystemModule,
    ModuleProfile,
    ModuleProfileAssignment,
    UserProfileAssignment,
    UserModuleAssignment,
    ModuleAccessLog
)
from .serializers import (
    SystemModuleSerializer,
    UserModuleSerializer,
    ModuleProfileSerializer,
    ModuleProfileAssignmentSerializer,
    UserProfileAssignmentSerializer,
    UserModuleAssignmentSerializer,
    UserModulesDetailSerializer,
    ModuleAccessLogSerializer,
    AssignModuleToProfileSerializer,
    AssignProfileToUserSerializer,
    AssignModuleToUserSerializer
)
from .permissions import IsAdminOrSupervisor
import logging

logger = logging.getLogger('authentication')


class UserModulesAPIView(APIView):
    """
    Vista para obtener módulos del usuario autenticado
    """
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        """
        Obtiene todos los módulos disponibles para el usuario actual
        """
        try:
            user = request.user
            
            # Obtener módulos del usuario
            modules = user.get_assigned_modules()
            
            # Serializar con permisos
            serializer = UserModuleSerializer(
                modules,
                many=True,
                context={'user': user}
            )
            
            # Agrupar por tipo
            modules_by_type = {}
            for module in serializer.data:
                module_type = module['module_type']
                if module_type not in modules_by_type:
                    modules_by_type[module_type] = []
                modules_by_type[module_type].append(module)
            
            return Response({
                'modules': serializer.data,
                'modules_by_type': modules_by_type,
                'total_modules': len(serializer.data),
                'user': {
                    'username': user.username,
                    'role': user.role,
                    'role_display': user.get_role_display()
                }
            }, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(f"Error fetching modules for {request.user.username}: {str(e)}")
            return Response({
                'error': 'Failed to fetch user modules',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class UserModulesDetailAPIView(APIView):
    """
    Vista para obtener detalle completo de módulos y asignaciones del usuario
    """
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        """
        Obtiene módulos, perfiles y asignaciones directas del usuario
        """
        try:
            user = request.user
            
            # Obtener módulos
            modules = user.get_assigned_modules()
            
            # Preparar datos
            data = {
                'user': user,
                'user_id': user.id,
                'username': user.username,
                'role': user.get_role_display(),
                'available_modules': modules,
                'total_modules': len(modules),
                'modules_by_type': self._group_modules_by_type(modules)
            }
            
            serializer = UserModulesDetailSerializer(data, context={'user': user})
            
            return Response(serializer.data, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(f"Error fetching module details for {request.user.username}: {str(e)}")
            return Response({
                'error': 'Failed to fetch module details',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def _group_modules_by_type(self, modules):
        """Agrupa módulos por tipo"""
        grouped = {}
        for module in modules:
            module_type = module.module_type
            if module_type not in grouped:
                grouped[module_type] = 0
            grouped[module_type] += 1
        return grouped


class SystemModuleViewSet(viewsets.ModelViewSet):
    """
    ViewSet para gestión de módulos del sistema
    Solo accesible por ADMIN_IT
    """
    queryset = SystemModule.objects.all().order_by('display_order', 'name')
    serializer_class = SystemModuleSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrSupervisor]

    def get_queryset(self):
        """Filtra módulos según parámetros"""
        queryset = super().get_queryset()
        
        # Filtro por tipo
        module_type = self.request.query_params.get('type')
        if module_type:
            queryset = queryset.filter(module_type=module_type)
        
        # Filtro por activo
        is_active = self.request.query_params.get('is_active')
        if is_active is not None:
            queryset = queryset.filter(is_active=is_active.lower() == 'true')
        
        # Solo visibles en menú
        visible_only = self.request.query_params.get('visible_only')
        if visible_only and visible_only.lower() == 'true':
            queryset = queryset.filter(is_visible_in_menu=True)
        
        return queryset

    def perform_create(self, serializer):
        """Registra quién creó el módulo"""
        serializer.save(created_by=self.request.user)

    @action(detail=True, methods=['post'])
    def toggle_active(self, request, pk=None):
        """Activa/desactiva un módulo"""
        try:
            module = self.get_object()
            module.is_active = not module.is_active
            module.save()
            
            logger.info(f"Module {module.code} toggled to active={module.is_active} by {request.user.username}")
            
            return Response({
                'message': f"Módulo {'activado' if module.is_active else 'desactivado'}",
                'module': SystemModuleSerializer(module).data
            }, status=status.HTTP_200_OK)
        
        except Exception as e:
            logger.error(f"Error toggling module: {str(e)}")
            return Response({
                'error': 'Failed to toggle module',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class ModuleProfileViewSet(viewsets.ModelViewSet):
    """
    ViewSet para gestión de perfiles de módulos
    """
    queryset = ModuleProfile.objects.all().order_by('name')
    serializer_class = ModuleProfileSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrSupervisor]

    def get_queryset(self):
        """Filtra perfiles según parámetros"""
        queryset = super().get_queryset()
        
        # Filtro por rol
        role = self.request.query_params.get('role')
        if role:
            queryset = queryset.filter(default_for_role=role)
        
        # Filtro por activo
        is_active = self.request.query_params.get('is_active')
        if is_active is not None:
            queryset = queryset.filter(is_active=is_active.lower() == 'true')
        
        return queryset

    def perform_create(self, serializer):
        """Registra quién creó el perfil"""
        serializer.save(created_by=self.request.user)

    @action(detail=True, methods=['post'])
    def assign_modules(self, request, pk=None):
        """
        Asigna múltiples módulos a un perfil
        POST: {
            "module_ids": ["uuid1", "uuid2"],
            "can_read": true,
            "can_write": false,
            "can_delete": false,
            "can_export": false
        }
        """
        try:
            profile = self.get_object()
            
            # Validar datos
            serializer = AssignModuleToProfileSerializer(data={
                'profile_id': profile.id,
                **request.data
            })
            
            if not serializer.is_valid():
                return Response({
                    'error': 'Validation failed',
                    'details': serializer.errors
                }, status=status.HTTP_400_BAD_REQUEST)
            
            validated_data = serializer.validated_data
            module_ids = validated_data['module_ids']
            
            # Asignar módulos
            with transaction.atomic():
                assignments_created = 0
                assignments_updated = 0
                
                for module_id in module_ids:
                    module = SystemModule.objects.get(id=module_id)
                    
                    assignment, created = ModuleProfileAssignment.objects.update_or_create(
                        profile=profile,
                        module=module,
                        defaults={
                            'can_read': validated_data.get('can_read', True),
                            'can_write': validated_data.get('can_write', False),
                            'can_delete': validated_data.get('can_delete', False),
                            'can_export': validated_data.get('can_export', False),
                            'is_active': True,
                            'assigned_by': request.user
                        }
                    )
                    
                    if created:
                        assignments_created += 1
                    else:
                        assignments_updated += 1
                
                logger.info(f"Modules assigned to profile {profile.code} by {request.user.username}: {assignments_created} created, {assignments_updated} updated")
            
            return Response({
                'message': 'Módulos asignados exitosamente',
                'created': assignments_created,
                'updated': assignments_updated,
                'profile': ModuleProfileSerializer(profile).data
            }, status=status.HTTP_200_OK)
        
        except SystemModule.DoesNotExist:
            return Response({
                'error': 'Algunos módulos no existen'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"Error assigning modules to profile: {str(e)}")
            return Response({
                'error': 'Failed to assign modules',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['delete'])
    def remove_module(self, request, pk=None):
        """
        Remueve un módulo de un perfil
        DELETE con query param: ?module_id=uuid
        """
        try:
            profile = self.get_object()
            module_id = request.query_params.get('module_id')
            
            if not module_id:
                return Response({
                    'error': 'module_id is required'
                }, status=status.HTTP_400_BAD_REQUEST)
            
            # Buscar y eliminar asignación
            assignment = ModuleProfileAssignment.objects.filter(
                profile=profile,
                module_id=module_id
            ).first()
            
            if not assignment:
                return Response({
                    'error': 'Module not assigned to this profile'
                }, status=status.HTTP_404_NOT_FOUND)
            
            module_name = assignment.module.name
            assignment.delete()
            
            logger.info(f"Module {module_name} removed from profile {profile.code} by {request.user.username}")
            
            return Response({
                'message': f"Módulo {module_name} removido del perfil",
                'profile': ModuleProfileSerializer(profile).data
            }, status=status.HTTP_200_OK)
        
        except Exception as e:
            logger.error(f"Error removing module from profile: {str(e)}")
            return Response({
                'error': 'Failed to remove module',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class UserProfileManagementAPIView(APIView):
    """
    Vista para gestionar asignación de perfiles a usuarios
    """
    permission_classes = [permissions.IsAuthenticated, IsAdminOrSupervisor]

    @method_decorator(ratelimit(key='user', rate='20/m', method='POST'))
    def post(self, request):
        """
        Asigna perfiles a un usuario
        POST: {
            "user_id": "uuid",
            "profile_ids": ["uuid1", "uuid2"],
            "expires_at": "2025-12-31T23:59:59Z" (opcional)
        }
        """
        try:
            serializer = AssignProfileToUserSerializer(data=request.data)
            
            if not serializer.is_valid():
                return Response({
                    'error': 'Validation failed',
                    'details': serializer.errors
                }, status=status.HTTP_400_BAD_REQUEST)
            
            validated_data = serializer.validated_data
            user = CallCenterUser.objects.get(id=validated_data['user_id'])
            profile_ids = validated_data['profile_ids']
            expires_at = validated_data.get('expires_at')
            
            # Asignar perfiles
            with transaction.atomic():
                assignments_created = 0
                assignments_updated = 0
                
                for profile_id in profile_ids:
                    profile = ModuleProfile.objects.get(id=profile_id)
                    
                    assignment, created = UserProfileAssignment.objects.update_or_create(
                        user=user,
                        profile=profile,
                        defaults={
                            'is_active': True,
                            'assigned_by': request.user,
                            'expires_at': expires_at
                        }
                    )
                    
                    if created:
                        assignments_created += 1
                    else:
                        assignments_updated += 1
                
                logger.info(f"Profiles assigned to user {user.username} by {request.user.username}: {assignments_created} created, {assignments_updated} updated")
            
            return Response({
                'message': 'Perfiles asignados exitosamente',
                'user': user.username,
                'created': assignments_created,
                'updated': assignments_updated
            }, status=status.HTTP_200_OK)
        
        except CallCenterUser.DoesNotExist:
            return Response({
                'error': 'Usuario no encontrado'
            }, status=status.HTTP_404_NOT_FOUND)
        except ModuleProfile.DoesNotExist:
            return Response({
                'error': 'Algunos perfiles no existen'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"Error assigning profiles to user: {str(e)}")
            return Response({
                'error': 'Failed to assign profiles',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class UserModuleManagementAPIView(APIView):
    """
    Vista para gestionar asignación directa de módulos a usuarios
    """
    permission_classes = [permissions.IsAuthenticated, IsAdminOrSupervisor]

    @method_decorator(ratelimit(key='user', rate='20/m', method='POST'))
    def post(self, request):
        """
        Asigna un módulo directamente a un usuario
        POST: {
            "user_id": "uuid",
            "module_id": "uuid",
            "can_read": true,
            "can_write": false,
            "can_delete": false,
            "can_export": false,
            "assignment_reason": "Acceso temporal para proyecto X",
            "expires_at": "2025-12-31T23:59:59Z" (opcional)
        }
        """
        try:
            serializer = AssignModuleToUserSerializer(data=request.data)
            
            if not serializer.is_valid():
                return Response({
                    'error': 'Validation failed',
                    'details': serializer.errors
                }, status=status.HTTP_400_BAD_REQUEST)
            
            validated_data = serializer.validated_data
            user = CallCenterUser.objects.get(id=validated_data['user_id'])
            module = SystemModule.objects.get(id=validated_data['module_id'])
            
            # Crear o actualizar asignación
            assignment, created = UserModuleAssignment.objects.update_or_create(
                user=user,
                module=module,
                defaults={
                    'can_read': validated_data.get('can_read', True),
                    'can_write': validated_data.get('can_write', False),
                    'can_delete': validated_data.get('can_delete', False),
                    'can_export': validated_data.get('can_export', False),
                    'assignment_reason': validated_data['assignment_reason'],
                    'is_active': True,
                    'assigned_by': request.user,
                    'expires_at': validated_data.get('expires_at')
                }
            )
            
            action = 'creada' if created else 'actualizada'
            logger.info(f"Direct module assignment {action} for user {user.username} - module {module.code} by {request.user.username}")
            
            return Response({
                'message': f"Asignación directa {action} exitosamente",
                'user': user.username,
                'module': module.name,
                'assignment': UserModuleAssignmentSerializer(assignment).data
            }, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)
        
        except CallCenterUser.DoesNotExist:
            return Response({
                'error': 'Usuario no encontrado'
            }, status=status.HTTP_404_NOT_FOUND)
        except SystemModule.DoesNotExist:
            return Response({
                'error': 'Módulo no encontrado'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"Error assigning module to user: {str(e)}")
            return Response({
                'error': 'Failed to assign module',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)


class ModuleAccessLogAPIView(APIView):
    """
    Vista para registrar y consultar logs de acceso a módulos
    """
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        """
        Registra acceso a un módulo
        POST: {
            "module_id": "uuid",
            "action": "VIEW",
            "was_successful": true,
            "error_message": "" (opcional)
        }
        """
        try:
            module_id = request.data.get('module_id')
            action = request.data.get('action', 'VIEW')
            was_successful = request.data.get('was_successful', True)
            error_message = request.data.get('error_message', '')
            
            if not module_id:
                return Response({
                    'error': 'module_id is required'
                }, status=status.HTTP_400_BAD_REQUEST)
            
            module = SystemModule.objects.get(id=module_id)
            
            # Obtener IP y user agent
            ip_address = self.get_client_ip(request)
            user_agent = request.META.get('HTTP_USER_AGENT', '')
            
            # Crear log
            log = ModuleAccessLog.objects.create(
                user=request.user,
                module=module,
                action=action,
                ip_address=ip_address,
                user_agent=user_agent,
                was_successful=was_successful,
                error_message=error_message
            )
            
            return Response({
                'message': 'Acceso registrado',
                'log_id': str(log.id)
            }, status=status.HTTP_201_CREATED)
        
        except SystemModule.DoesNotExist:
            return Response({
                'error': 'Módulo no encontrado'
            }, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            logger.error(f"Error logging module access: {str(e)}")
            return Response({
                'error': 'Failed to log access',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request):
        """
        Obtiene logs de acceso a módulos
        Query params:
        - module_id: filtrar por módulo
        - user_id: filtrar por usuario (solo ADMIN_IT puede ver logs de otros)
        - from_date: fecha inicio
        - to_date: fecha fin
        - limit: límite de resultados (default 50, max 500)
        """
        try:
            # Filtros base
            queryset = ModuleAccessLog.objects.select_related('user', 'module')
            
            # Solo ADMIN_IT puede ver logs de todos los usuarios
            if request.user.role != 'ADMIN_IT':
                queryset = queryset.filter(user=request.user)
            else:
                # Filtro por usuario específico
                user_id = request.query_params.get('user_id')
                if user_id:
                    queryset = queryset.filter(user_id=user_id)
            
            # Filtro por módulo
            module_id = request.query_params.get('module_id')
            if module_id:
                queryset = queryset.filter(module_id=module_id)
            
            # Filtro por fecha
            from_date = request.query_params.get('from_date')
            if from_date:
                queryset = queryset.filter(accessed_at__gte=from_date)
            
            to_date = request.query_params.get('to_date')
            if to_date:
                queryset = queryset.filter(accessed_at__lte=to_date)
            
            # Límite
            limit = int(request.query_params.get('limit', 50))
            limit = min(limit, 500)  # Máximo 500
            
            queryset = queryset.order_by('-accessed_at')[:limit]
            
            serializer = ModuleAccessLogSerializer(queryset, many=True)
            
            return Response({
                'logs': serializer.data,
                'count': len(serializer.data)
            }, status=status.HTTP_200_OK)
        
        except Exception as e:
            logger.error(f"Error fetching module access logs: {str(e)}")
            return Response({
                'error': 'Failed to fetch logs',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def get_client_ip(self, request):
        """Obtiene la IP real del cliente"""
        x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
        if x_forwarded_for:
            ip = x_forwarded_for.split(',')[0].strip()
        else:
            ip = request.META.get('REMOTE_ADDR', '127.0.0.1')
        return ip
