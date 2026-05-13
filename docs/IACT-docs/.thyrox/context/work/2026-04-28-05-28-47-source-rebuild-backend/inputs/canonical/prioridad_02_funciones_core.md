---
id: DOC-REQ-PRIORIDAD-02
tipo: especificacion_tecnica
titulo: Prioridad 2 - Funciones Core
version: 1.0.0
fecha_creacion: 2025-11-07
estado: por_implementar
propietario: equipo-backend
prioridad: alta
estandares: ["ISO/IEC/IEEE 29148:2018", "REST API", "Django Best Practices"]
relacionados: ["INDICE_MAESTRO_PERMISOS_GRANULAR", "prioridad_01_estructura_base_datos", "ADR_2025_005"]
date: 2025-11-13
---

# PRIORIDAD 2: Funciones Core

**Fase:** Implementación Inicial
**Estado:** Por Implementar
**Prioridad:** [ALTA] - Transversales a todo el sistema

---

## Objetivo

Implementar las 3 funciones transversales del sistema que son prerequisito para todos los demás módulos:
1. **Usuarios** - Gestión de cuentas de usuario
2. **Dashboards** - Visualización y navegación
3. **Configuración** - Parámetros del sistema

---

## Dependencias

**Prerequisito:**
- Prioridad 1: Estructura Base de Datos (COMPLETADA)

**Provee base para:**
- Prioridad 3: Módulos Operativos
- Prioridad 4: Módulos de Gestión

---

## Resumen Ejecutivo

| Aspecto | Detalle |
|---------|---------|
| **Funciones** | 3 (usuarios, dashboards, configuración) |
| **Capacidades** | 16 total (7 + 4 + 5) |
| **Grupos de Permisos** | 3 (administracion_usuarios, visualizacion_basica, configuracion_sistema) |
| **Endpoints API** | 12 endpoints REST |
| **Modelos Django** | Integración con app `users` existente |
| **Tiempo Estimado** | 1 semana |

---

## FUNCIÓN 1: Usuarios

### Metadata

```yaml
nombre: usuarios
nombre_completo: sistema.administracion.usuarios
dominio: administracion
categoria: gestion
descripcion: Gestión de cuentas de usuario del sistema
icono: user-circle
orden_menu: 100
```

### Capacidades (7)

| ID | Nombre Completo | Acción | Nivel Sensibilidad | Requiere Auditoría |
|----|-----------------|--------|-------------------|-------------------|
| 1 | sistema.administracion.usuarios.ver | ver | bajo | FALSE |
| 2 | sistema.administracion.usuarios.crear | crear | alto | TRUE |
| 3 | sistema.administracion.usuarios.editar | editar | normal | TRUE |
| 4 | sistema.administracion.usuarios.eliminar | eliminar | critico | TRUE |
| 5 | sistema.administracion.usuarios.suspender | suspender | alto | TRUE |
| 6 | sistema.administracion.usuarios.reactivar | reactivar | alto | TRUE |
| 7 | sistema.administracion.usuarios.asignar_grupos | asignar_grupos | critico | TRUE |

### Scripts SQL: Datos Semilla

```sql
-- Insertar función: usuarios
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES (
 'usuarios',
 'sistema.administracion.usuarios',
 'administracion',
 'gestion',
 'Gestión de cuentas de usuario del sistema',
 'user-circle',
 100,
 TRUE
);

-- Insertar capacidades de usuarios
INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 (
 'sistema.administracion.usuarios.ver',
 'ver',
 'usuarios',
 'administracion',
 'Ver información de usuarios del sistema',
 'bajo',
 FALSE,
 TRUE
 ),
 (
 'sistema.administracion.usuarios.crear',
 'crear',
 'usuarios',
 'administracion',
 'Crear nuevas cuentas de usuario',
 'alto',
 TRUE,
 TRUE
 ),
 (
 'sistema.administracion.usuarios.editar',
 'editar',
 'usuarios',
 'administracion',
 'Modificar información de usuarios existentes',
 'normal',
 TRUE,
 TRUE
 ),
 (
 'sistema.administracion.usuarios.eliminar',
 'eliminar',
 'usuarios',
 'administracion',
 'Eliminar usuarios del sistema (lógico)',
 'critico',
 TRUE,
 TRUE
 ),
 (
 'sistema.administracion.usuarios.suspender',
 'suspender',
 'usuarios',
 'administracion',
 'Suspender temporalmente acceso de usuario',
 'alto',
 TRUE,
 TRUE
 ),
 (
 'sistema.administracion.usuarios.reactivar',
 'reactivar',
 'usuarios',
 'administracion',
 'Reactivar usuarios suspendidos',
 'alto',
 TRUE,
 TRUE
 ),
 (
 'sistema.administracion.usuarios.asignar_grupos',
 'asignar_grupos',
 'usuarios',
 'administracion',
 'Asignar grupos de permisos a usuarios',
 'critico',
 TRUE,
 TRUE
 );

-- Relacionar función con capacidades
INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT
 f.id,
 c.id,
 CASE
 WHEN c.accion = 'ver' THEN TRUE -- Ver es obligatorio
 ELSE FALSE
 END,
 TRUE,
 CASE
 WHEN c.accion = 'ver' THEN 1
 WHEN c.accion = 'crear' THEN 2
 WHEN c.accion = 'editar' THEN 3
 WHEN c.accion = 'suspender' THEN 4
 WHEN c.accion = 'reactivar' THEN 5
 WHEN c.accion = 'asignar_grupos' THEN 6
 WHEN c.accion = 'eliminar' THEN 7
 END
FROM funciones f
CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.administracion.usuarios'
 AND c.nombre_completo LIKE 'sistema.administracion.usuarios.%';
```

### Servicio Backend: UserManagementService

```python
# api/callcentersite/callcentersite/apps/users/services/user_management_service.py

from typing import List, Optional
from django.contrib.auth import get_user_model
from django.db import transaction
from ..models import User, PermissionService
from ...audit.services import AuditService

User = get_user_model()

class UserManagementService:
 """
 Servicio para gestión de usuarios.
 Integra con sistema de permisos granular.
 """

 @staticmethod
 def listar_usuarios(
 usuario_solicitante: User,
 filtros: Optional[dict] = None
 ) -> List[User]:
 """
 Lista usuarios del sistema.

 Requisitos:
 - Usuario debe tener permiso 'sistema.administracion.usuarios.ver'

 Args:
 usuario_solicitante: Usuario que hace la solicitud
 filtros: Filtros opcionales (activo, email_contains, etc.)

 Returns:
 Lista de usuarios filtrados

 Raises:
 PermissionDenied: Si no tiene permiso
 """
 # Verificar permiso
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.administracion.usuarios.ver'
 ):
 raise PermissionDenied('No autorizado para ver usuarios')

 # Construir query
 queryset = User.objects.all()

 if filtros:
 if 'activo' in filtros:
 queryset = queryset.filter(is_active=filtros['activo'])
 if 'email_contains' in filtros:
 queryset = queryset.filter(email__icontains=filtros['email_contains'])

 return list(queryset)

 @staticmethod
 @transaction.atomic
 def crear_usuario(
 usuario_solicitante: User,
 datos: dict
 ) -> User:
 """
 Crea nuevo usuario en el sistema.

 Requisitos:
 - Usuario debe tener permiso 'sistema.administracion.usuarios.crear'

 Args:
 usuario_solicitante: Usuario que hace la solicitud
 datos: Diccionario con datos del usuario
 {
 'username': str,
 'email': str,
 'password': str,
 'first_name': str,
 'last_name': str
 }

 Returns:
 Usuario creado

 Raises:
 PermissionDenied: Si no tiene permiso
 ValidationError: Si datos inválidos
 """
 # Verificar permiso
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.administracion.usuarios.crear'
 ):
 raise PermissionDenied('No autorizado para crear usuarios')

 # Validar datos requeridos
 required_fields = ['username', 'email', 'password']
 for field in required_fields:
 if field not in datos:
 raise ValidationError(f'Campo requerido: {field}')

 # Crear usuario
 nuevo_usuario = User.objects.create_user(
 username=datos['username'],
 email=datos['email'],
 password=datos['password'],
 first_name=datos.get('first_name', ''),
 last_name=datos.get('last_name', '')
 )

 # Auditar acción
 AuditService.registrar_accion(
 usuario=usuario_solicitante,
 capacidad='sistema.administracion.usuarios.crear',
 accion='usuario_creado',
 recurso=f'usuario:{nuevo_usuario.id}',
 metadata={'username': nuevo_usuario.username}
 )

 return nuevo_usuario

 @staticmethod
 @transaction.atomic
 def suspender_usuario(
 usuario_solicitante: User,
 usuario_id: int,
 motivo: str
 ) -> User:
 """
 Suspende acceso de un usuario.

 Requisitos:
 - Usuario debe tener permiso 'sistema.administracion.usuarios.suspender'

 Args:
 usuario_solicitante: Usuario que hace la solicitud
 usuario_id: ID del usuario a suspender
 motivo: Razón de la suspensión

 Returns:
 Usuario suspendido

 Raises:
 PermissionDenied: Si no tiene permiso
 Usuario.DoesNotExist: Si usuario no existe
 """
 # Verificar permiso
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.administracion.usuarios.suspender'
 ):
 raise PermissionDenied('No autorizado para suspender usuarios')

 # Obtener usuario
 usuario = User.objects.get(id=usuario_id)

 # No puede suspenderse a sí mismo
 if usuario.id == usuario_solicitante.id:
 raise ValidationError('No puede suspender su propia cuenta')

 # Suspender
 usuario.is_active = False
 usuario.save()

 # Auditar acción
 AuditService.registrar_accion(
 usuario=usuario_solicitante,
 capacidad='sistema.administracion.usuarios.suspender',
 accion='usuario_suspendido',
 recurso=f'usuario:{usuario.id}',
 metadata={
 'username': usuario.username,
 'motivo': motivo
 }
 )

 return usuario

 @staticmethod
 @transaction.atomic
 def asignar_grupos(
 usuario_solicitante: User,
 usuario_id: int,
 grupos_ids: List[int],
 motivo: Optional[str] = None
 ) -> User:
 """
 Asigna grupos de permisos a un usuario.

 Requisitos:
 - Usuario debe tener permiso 'sistema.administracion.usuarios.asignar_grupos'

 Args:
 usuario_solicitante: Usuario que hace la solicitud
 usuario_id: ID del usuario
 grupos_ids: Lista de IDs de grupos a asignar
 motivo: Razón opcional de la asignación

 Returns:
 Usuario con grupos actualizados

 Raises:
 PermissionDenied: Si no tiene permiso
 """
 # Verificar permiso
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.administracion.usuarios.asignar_grupos'
 ):
 raise PermissionDenied('No autorizado para asignar grupos')

 # Obtener usuario
 usuario = User.objects.get(id=usuario_id)

 # Asignar grupos (SQL directo para usar tabla usuarios_grupos)
 from django.db import connection
 with connection.cursor() as cursor:
 # Limpiar asignaciones actuales
 cursor.execute(
 "UPDATE usuarios_grupos SET activo = FALSE WHERE usuario_id = %s",
 [usuario_id]
 )

 # Insertar nuevas asignaciones
 for grupo_id in grupos_ids:
 cursor.execute("""
 INSERT INTO usuarios_grupos
 (usuario_id, grupo_id, fecha_asignacion, asignado_por, motivo, activo)
 VALUES (%s, %s, NOW(), %s, %s, TRUE)
 ON CONFLICT (usuario_id, grupo_id)
 DO UPDATE SET activo = TRUE, fecha_asignacion = NOW()
 """, [usuario_id, grupo_id, usuario_solicitante.id, motivo])

 # Auditar acción
 AuditService.registrar_accion(
 usuario=usuario_solicitante,
 capacidad='sistema.administracion.usuarios.asignar_grupos',
 accion='grupos_asignados',
 recurso=f'usuario:{usuario.id}',
 metadata={
 'username': usuario.username,
 'grupos_ids': grupos_ids,
 'motivo': motivo
 }
 )

 return usuario
```

### Endpoints REST

```python
# api/callcentersite/callcentersite/apps/users/views.py

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .services.user_management_service import UserManagementService
from .serializers import UserSerializer

class UserViewSet(viewsets.ModelViewSet):
 """
 ViewSet para gestión de usuarios.
 """
 permission_classes = [IsAuthenticated]
 serializer_class = UserSerializer

 def list(self, request):
 """
 GET /api/usuarios/
 Lista todos los usuarios.

 Requiere: sistema.administracion.usuarios.ver
 """
 try:
 filtros = {
 'activo': request.query_params.get('activo'),
 'email_contains': request.query_params.get('email')
 }
 usuarios = UserManagementService.listar_usuarios(
 usuario_solicitante=request.user,
 filtros={k: v for k, v in filtros.items() if v is not None}
 )
 serializer = self.get_serializer(usuarios, many=True)
 return Response(serializer.data)
 except PermissionDenied as e:
 return Response({'error': str(e)}, status=status.HTTP_403_FORBIDDEN)

 def create(self, request):
 """
 POST /api/usuarios/
 Crea nuevo usuario.

 Requiere: sistema.administracion.usuarios.crear

 Body:
 {
 "username": "juan.perez",
 "email": "juan.perez@ejemplo.com",
 "password": "SecurePass123!",
 "first_name": "Juan",
 "last_name": "Pérez"
 }
 """
 try:
 usuario = UserManagementService.crear_usuario(
 usuario_solicitante=request.user,
 datos=request.data
 )
 serializer = self.get_serializer(usuario)
 return Response(serializer.data, status=status.HTTP_201_CREATED)
 except PermissionDenied as e:
 return Response({'error': str(e)}, status=status.HTTP_403_FORBIDDEN)
 except ValidationError as e:
 return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

 @action(detail=True, methods=['post'])
 def suspender(self, request, pk=None):
 """
 POST /api/usuarios/{id}/suspender/
 Suspende un usuario.

 Requiere: sistema.administracion.usuarios.suspender

 Body:
 {
 "motivo": "Violación de políticas"
 }
 """
 try:
 usuario = UserManagementService.suspender_usuario(
 usuario_solicitante=request.user,
 usuario_id=pk,
 motivo=request.data.get('motivo', '')
 )
 serializer = self.get_serializer(usuario)
 return Response(serializer.data)
 except PermissionDenied as e:
 return Response({'error': str(e)}, status=status.HTTP_403_FORBIDDEN)

 @action(detail=True, methods=['post'])
 def asignar_grupos(self, request, pk=None):
 """
 POST /api/usuarios/{id}/asignar_grupos/
 Asigna grupos de permisos a un usuario.

 Requiere: sistema.administracion.usuarios.asignar_grupos

 Body:
 {
 "grupos_ids": [1, 2, 5],
 "motivo": "Nuevo rol en el equipo"
 }
 """
 try:
 usuario = UserManagementService.asignar_grupos(
 usuario_solicitante=request.user,
 usuario_id=pk,
 grupos_ids=request.data.get('grupos_ids', []),
 motivo=request.data.get('motivo')
 )
 serializer = self.get_serializer(usuario)
 return Response(serializer.data)
 except PermissionDenied as e:
 return Response({'error': str(e)}, status=status.HTTP_403_FORBIDDEN)
```

---

## FUNCIÓN 2: Dashboards

### Metadata

```yaml
nombre: dashboards
nombre_completo: sistema.vistas.dashboards
dominio: vistas
categoria: visualizacion
descripcion: Acceso y personalización de dashboards
icono: dashboard
orden_menu: 10
```

### Capacidades (4)

| ID | Nombre Completo | Acción | Nivel Sensibilidad | Requiere Auditoría |
|----|-----------------|--------|-------------------|-------------------|
| 8 | sistema.vistas.dashboards.ver | ver | bajo | FALSE |
| 9 | sistema.vistas.dashboards.exportar | exportar | normal | FALSE |
| 10 | sistema.vistas.dashboards.personalizar | personalizar | bajo | FALSE |
| 11 | sistema.vistas.dashboards.compartir | compartir | normal | FALSE |

### Scripts SQL: Datos Semilla

```sql
-- Insertar función: dashboards
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES (
 'dashboards',
 'sistema.vistas.dashboards',
 'vistas',
 'visualizacion',
 'Acceso y personalización de dashboards',
 'dashboard',
 10,
 TRUE
);

-- Insertar capacidades de dashboards
INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 (
 'sistema.vistas.dashboards.ver',
 'ver',
 'dashboards',
 'vistas',
 'Ver dashboards del sistema',
 'bajo',
 FALSE,
 TRUE
 ),
 (
 'sistema.vistas.dashboards.exportar',
 'exportar',
 'dashboards',
 'vistas',
 'Exportar datos de dashboards a Excel/PDF',
 'normal',
 FALSE,
 TRUE
 ),
 (
 'sistema.vistas.dashboards.personalizar',
 'personalizar',
 'dashboards',
 'vistas',
 'Personalizar widgets y layout de dashboards',
 'bajo',
 FALSE,
 TRUE
 ),
 (
 'sistema.vistas.dashboards.compartir',
 'compartir',
 'dashboards',
 'vistas',
 'Compartir dashboards personalizados con otros usuarios',
 'normal',
 FALSE,
 TRUE
 );

-- Relacionar función con capacidades
INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT
 f.id,
 c.id,
 CASE
 WHEN c.accion = 'ver' THEN TRUE -- Ver es obligatorio
 ELSE FALSE
 END,
 TRUE,
 CASE
 WHEN c.accion = 'ver' THEN 1
 WHEN c.accion = 'personalizar' THEN 2
 WHEN c.accion = 'exportar' THEN 3
 WHEN c.accion = 'compartir' THEN 4
 END
FROM funciones f
CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.vistas.dashboards'
 AND c.nombre_completo LIKE 'sistema.vistas.dashboards.%';
```

### Integración con Módulo Django Existente

```python
# api/callcentersite/callcentersite/apps/dashboard/views.py

from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..users.models import PermissionService

class DashboardViewSet(viewsets.ViewSet):
 """
 ViewSet para dashboards con permisos granulares.
 """
 permission_classes = [IsAuthenticated]

 def list(self, request):
 """
 GET /api/dashboards/
 Lista dashboards disponibles para el usuario.

 Requiere: sistema.vistas.dashboards.ver
 """
 # Verificar permiso
 if not PermissionService.usuario_tiene_permiso(
 request.user.id,
 'sistema.vistas.dashboards.ver'
 ):
 return Response(
 {'error': 'No autorizado'},
 status=status.HTTP_403_FORBIDDEN
 )

 # Retornar dashboards
 dashboards = [
 {
 'id': 1,
 'nombre': 'Dashboard Principal',
 'descripcion': 'Vista general del sistema',
 'widgets': ['metricas_generales', 'actividad_reciente']
 },
 {
 'id': 2,
 'nombre': 'Dashboard Operativo',
 'descripcion': 'Métricas operacionales',
 'widgets': ['llamadas_hora', 'tickets_abiertos', 'agentes_activos']
 }
 ]

 return Response(dashboards)

 @action(detail=True, methods=['post'])
 def exportar(self, request, pk=None):
 """
 POST /api/dashboards/{id}/exportar/
 Exporta dashboard a Excel o PDF.

 Requiere: sistema.vistas.dashboards.exportar

 Body:
 {
 "formato": "excel" # o "pdf"
 }
 """
 # Verificar permiso
 if not PermissionService.usuario_tiene_permiso(
 request.user.id,
 'sistema.vistas.dashboards.exportar'
 ):
 return Response(
 {'error': 'No autorizado'},
 status=status.HTTP_403_FORBIDDEN
 )

 # Lógica de exportación
 formato = request.data.get('formato', 'excel')

 # TODO: Implementar exportación real
 return Response({
 'mensaje': f'Dashboard exportado a {formato}',
 'url_descarga': f'/api/downloads/dashboard_{pk}.{formato}'
 })
```

---

## FUNCIÓN 3: Configuración

### Metadata

```yaml
nombre: configuracion
nombre_completo: sistema.tecnico.configuracion
dominio: tecnico
categoria: gestion
descripcion: Gestión de parámetros y configuración del sistema
icono: cog
orden_menu: 900
```

### Capacidades (5)

| ID | Nombre Completo | Acción | Nivel Sensibilidad | Requiere Auditoría |
|----|-----------------|--------|-------------------|-------------------|
| 12 | sistema.tecnico.configuracion.ver | ver | bajo | FALSE |
| 13 | sistema.tecnico.configuracion.editar | editar | critico | TRUE |
| 14 | sistema.tecnico.configuracion.exportar | exportar | alto | TRUE |
| 15 | sistema.tecnico.configuracion.importar | importar | critico | TRUE |
| 16 | sistema.tecnico.configuracion.restaurar | restaurar | critico | TRUE |

### Scripts SQL: Datos Semilla

```sql
-- Insertar función: configuracion
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES (
 'configuracion',
 'sistema.tecnico.configuracion',
 'tecnico',
 'gestion',
 'Gestión de parámetros y configuración del sistema',
 'cog',
 900,
 TRUE
);

-- Insertar capacidades de configuracion
INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 (
 'sistema.tecnico.configuracion.ver',
 'ver',
 'configuracion',
 'tecnico',
 'Ver configuración del sistema',
 'bajo',
 FALSE,
 TRUE
 ),
 (
 'sistema.tecnico.configuracion.editar',
 'editar',
 'configuracion',
 'tecnico',
 'Modificar parámetros de configuración',
 'critico',
 TRUE,
 TRUE
 ),
 (
 'sistema.tecnico.configuracion.exportar',
 'exportar',
 'configuracion',
 'tecnico',
 'Exportar configuración del sistema',
 'alto',
 TRUE,
 TRUE
 ),
 (
 'sistema.tecnico.configuracion.importar',
 'importar',
 'configuracion',
 'tecnico',
 'Importar configuración desde archivo',
 'critico',
 TRUE,
 TRUE
 ),
 (
 'sistema.tecnico.configuracion.restaurar',
 'restaurar',
 'configuracion',
 'tecnico',
 'Restaurar configuración a valores por defecto',
 'critico',
 TRUE,
 TRUE
 );

-- Relacionar función con capacidades
INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT
 f.id,
 c.id,
 CASE
 WHEN c.accion = 'ver' THEN TRUE -- Ver es obligatorio
 ELSE FALSE
 END,
 TRUE,
 CASE
 WHEN c.accion = 'ver' THEN 1
 WHEN c.accion = 'editar' THEN 2
 WHEN c.accion = 'exportar' THEN 3
 WHEN c.accion = 'importar' THEN 4
 WHEN c.accion = 'restaurar' THEN 5
 END
FROM funciones f
CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.tecnico.configuracion'
 AND c.nombre_completo LIKE 'sistema.tecnico.configuracion.%';
```

---

## Grupos de Permisos

### Grupo 1: administracion_usuarios

**Propósito:** Gestión completa de usuarios del sistema.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'administracion_usuarios',
 'Administración de Usuarios',
 'Gestión completa de cuentas de usuario y asignación de permisos',
 'tecnico',
 '#3B82F6',
 'users-cog',
 TRUE
);

-- Asignar capacidades al grupo
INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT
 gp.id,
 c.id
FROM grupos_permisos gp
CROSS JOIN capacidades c
WHERE gp.codigo = 'administracion_usuarios'
 AND c.nombre_completo IN (
 'sistema.administracion.usuarios.ver',
 'sistema.administracion.usuarios.crear',
 'sistema.administracion.usuarios.editar',
 'sistema.administracion.usuarios.suspender',
 'sistema.administracion.usuarios.reactivar',
 'sistema.administracion.usuarios.asignar_grupos'
 );
```

### Grupo 2: visualizacion_basica

**Propósito:** Acceso de lectura a dashboards.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'visualizacion_basica',
 'Visualización Básica',
 'Acceso de solo lectura a dashboards del sistema',
 'operativo',
 '#10B981',
 'eye',
 TRUE
);

-- Asignar capacidades al grupo
INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT
 gp.id,
 c.id
FROM grupos_permisos gp
CROSS JOIN capacidades c
WHERE gp.codigo = 'visualizacion_basica'
 AND c.nombre_completo IN (
 'sistema.vistas.dashboards.ver',
 'sistema.vistas.dashboards.personalizar'
 );
```

### Grupo 3: configuracion_sistema

**Propósito:** Gestión de configuración del sistema.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'configuracion_sistema',
 'Configuración del Sistema',
 'Gestión de parámetros y configuración técnica',
 'tecnico',
 '#EF4444',
 'cog',
 TRUE
);

-- Asignar capacidades al grupo
INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT
 gp.id,
 c.id
FROM grupos_permisos gp
CROSS JOIN capacidades c
WHERE gp.codigo = 'configuracion_sistema'
 AND c.nombre_completo IN (
 'sistema.tecnico.configuracion.ver',
 'sistema.tecnico.configuracion.editar',
 'sistema.tecnico.configuracion.exportar',
 'sistema.tecnico.configuracion.importar',
 'sistema.tecnico.configuracion.restaurar'
 );
```

---

## Checklist de Implementación

### Fase 1: Base de Datos (Día 1)

```sql
-- [ ] Ejecutar scripts SQL de funciones (3)
-- [ ] Ejecutar scripts SQL de capacidades (16)
-- [ ] Relacionar funciones con capacidades (16 relaciones)
-- [ ] Crear 3 grupos de permisos
-- [ ] Asignar capacidades a grupos (13 asignaciones total)
-- [ ] Validar con queries de verificación
```

### Fase 2: Backend Services (Días 2-3)

```python
# [ ] Implementar UserManagementService
# [ ] Implementar DashboardService
# [ ] Implementar ConfigurationService
# [ ] Crear serializers
# [ ] Crear viewsets con decoradores de permisos
```

### Fase 3: Tests (Día 4)

```python
# [ ] Tests unitarios de servicios
# [ ] Tests de integración de APIs
# [ ] Tests de verificación de permisos
# [ ] Tests de auditoría
```

### Fase 4: Documentación (Día 5)

```markdown
# [ ] Documentar endpoints en Swagger/OpenAPI
# [ ] Actualizar README de módulos
# [ ] Crear guías de uso
# [ ] Documentar casos de prueba
```

---

## Queries de Validación

### Validar todas las funciones insertadas

```sql
SELECT
 f.id,
 f.nombre,
 f.nombre_completo,
 f.dominio,
 COUNT(fc.id) AS capacidades_count
FROM funciones f
LEFT JOIN funcion_capacidades fc ON f.id = fc.funcion_id
WHERE f.nombre IN ('usuarios', 'dashboards', 'configuracion')
GROUP BY f.id, f.nombre, f.nombre_completo, f.dominio;

-- Resultado esperado: 3 filas con counts (7, 4, 5)
```

### Validar grupos creados

```sql
SELECT
 gp.codigo,
 gp.nombre_display,
 COUNT(gc.id) AS capacidades_count
FROM grupos_permisos gp
LEFT JOIN grupo_capacidades gc ON gp.id = gc.grupo_id
WHERE gp.codigo IN ('administracion_usuarios', 'visualizacion_basica', 'configuracion_sistema')
GROUP BY gp.codigo, gp.nombre_display;

-- Resultado esperado:
-- administracion_usuarios: 6 capacidades
-- visualizacion_basica: 2 capacidades
-- configuracion_sistema: 5 capacidades
```

### Probar función usuario_tiene_permiso()

```sql
-- Asignar grupo a usuario de prueba
INSERT INTO usuarios_grupos (usuario_id, grupo_id, asignado_por)
VALUES (
 1, -- ID del usuario de prueba
 (SELECT id FROM grupos_permisos WHERE codigo = 'visualizacion_basica'),
 1
);

-- Verificar permiso
SELECT usuario_tiene_permiso(1, 'sistema.vistas.dashboards.ver');
-- Esperado: TRUE

SELECT usuario_tiene_permiso(1, 'sistema.administracion.usuarios.crear');
-- Esperado: FALSE
```

---

## Próximos Pasos

Una vez completada esta prioridad:

**3 Funciones Core COMPLETAS**
**16 Capacidades OPERATIVAS**
**3 Grupos de Permisos CREADOS**

**Siguiente: PRIORIDAD 3 - Módulos Operativos**

Estaremos listos para:
- Implementar módulos operativos (IVR, tickets, clientes)
- Crear más grupos funcionales
- Extender el sistema a casos de uso reales

---

**Documento:** Prioridad 2 - Funciones Core
**Fecha:** 07 de Noviembre, 2025
**Estado:** Listo para Implementación

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Creación inicial - 3 funciones core | equipo-ba |
