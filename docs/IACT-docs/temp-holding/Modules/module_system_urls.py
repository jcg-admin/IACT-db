"""
URL configuration for module system - UC-005
Call Center Dashboard - URLs para gestión de módulos dinámicos
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import module_views

# Router para ViewSets
router = DefaultRouter()
router.register(r'modules', module_views.SystemModuleViewSet, basename='system-module')
router.register(r'profiles', module_views.ModuleProfileViewSet, basename='module-profile')

app_name = 'modules'

urlpatterns = [
    # Módulos del usuario actual
    path('my-modules/', 
         module_views.UserModulesAPIView.as_view(), 
         name='my_modules'),
    
    path('my-modules/detail/', 
         module_views.UserModulesDetailAPIView.as_view(), 
         name='my_modules_detail'),
    
    # Gestión de perfiles de usuario
    path('user-profiles/assign/', 
         module_views.UserProfileManagementAPIView.as_view(), 
         name='assign_user_profiles'),
    
    # Gestión de módulos directos de usuario
    path('user-modules/assign/', 
         module_views.UserModuleManagementAPIView.as_view(), 
         name='assign_user_modules'),
    
    # Logs de acceso a módulos
    path('access-logs/', 
         module_views.ModuleAccessLogAPIView.as_view(), 
         name='module_access_logs'),
    
    # Router URLs (incluye todos los ViewSets)
    path('', include(router.urls)),
]
