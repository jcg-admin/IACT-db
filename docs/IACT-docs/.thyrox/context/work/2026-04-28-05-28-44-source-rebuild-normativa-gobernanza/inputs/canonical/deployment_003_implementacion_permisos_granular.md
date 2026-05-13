---
id: GUIA-DEPLOYMENT-003
tipo: guia_tecnica
categoria: deployment
audiencia: desarrolladores-backend
prioridad: P1
tiempo_lectura: 25 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: ["prioridad_01_estructura_base_datos", "MAPEO_FUNCIONES_MODULOS_DJANGO", "ADR_2025_005"]
---

# Implementación del Sistema de Permisos Granular

## Propósito

Esta guía técnica detalla cómo implementar el sistema de permisos granular basado en grupos funcionales, desde la estructura de base de datos hasta los endpoints REST.

## Audiencia

Esta guía está dirigida a: **Desarrolladores backend** responsables de implementar el nuevo sistema de permisos.

## Pre-requisitos

- [ ] Acceso a base de datos PostgreSQL
- [ ] Ambiente de desarrollo Django configurado
- [ ] Conocimiento de Django ORM y Django REST Framework
- [ ] Permisos de administrador en base de datos de desarrollo
- [ ] Haber leído ADR_2025_005 (Grupos Funcionales sin Jerarquía)

## Tiempo estimado

Tiempo de lectura: 25 minutos
Tiempo de implementación: 20-30 horas (distribuidas en 4 semanas)

## Arquitectura General

### Decisión Arquitectónica

Según **ADR_2025_005**, el sistema se basa en:

```
Filosofía:
- NO roles jerárquicos ("Agente", "Supervisor")
- SÍ grupos funcionales ("Atención al Cliente", "Gestión de Equipos")
- Usuarios con múltiples grupos simultáneos
- Permisos granulares combinables
```

### Componentes del Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                    SISTEMA DE PERMISOS                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  PostgreSQL  │  │    Django    │  │   REST API   │     │
│  │  8 Tablas    │  │  5 Módulos   │  │  Endpoints   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  13 Funciones → 78 Capacidades → 10 Grupos          │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Fase 1: Estructura de Base de Datos (Semana 1)

### Paso 1.1: Crear Tablas Principales

**Archivo**: `migrations/0001_create_permissions_tables.sql`

```sql
-- Tabla 1: Funciones (Recursos del sistema)
CREATE TABLE funciones (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nombre_completo VARCHAR(200) UNIQUE NOT NULL,
    dominio VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    descripcion TEXT,
    icono VARCHAR(50),
    orden_menu INTEGER DEFAULT 999,
    activa BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_funciones_dominio ON funciones(dominio);
CREATE INDEX idx_funciones_activa ON funciones(activa);

-- Tabla 2: Capacidades (Acciones sobre recursos)
CREATE TABLE capacidades (
    id SERIAL PRIMARY KEY,
    nombre_completo VARCHAR(255) UNIQUE NOT NULL,
    accion VARCHAR(100) NOT NULL,
    recurso VARCHAR(100) NOT NULL,
    dominio VARCHAR(100) NOT NULL,
    descripcion TEXT,
    nivel_sensibilidad VARCHAR(20) DEFAULT 'normal',
    requiere_auditoria BOOLEAN DEFAULT FALSE,
    activa BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_nivel_sensibilidad
        CHECK (nivel_sensibilidad IN ('bajo', 'normal', 'alto', 'critico'))
);

CREATE INDEX idx_capacidades_recurso ON capacidades(recurso);
CREATE INDEX idx_capacidades_accion ON capacidades(accion);
CREATE INDEX idx_capacidades_nivel ON capacidades(nivel_sensibilidad);

-- Tabla 3: Relación Funciones-Capacidades
CREATE TABLE funcion_capacidades (
    id SERIAL PRIMARY KEY,
    funcion_id INTEGER REFERENCES funciones(id) ON DELETE CASCADE,
    capacidad_id INTEGER REFERENCES capacidades(id) ON DELETE CASCADE,
    requerida BOOLEAN DEFAULT FALSE,
    visible_en_ui BOOLEAN DEFAULT TRUE,
    orden INTEGER DEFAULT 999,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(funcion_id, capacidad_id)
);

CREATE INDEX idx_funcion_capacidades_funcion ON funcion_capacidades(funcion_id);
CREATE INDEX idx_funcion_capacidades_capacidad ON funcion_capacidades(capacidad_id);

-- Tabla 4: Grupos de Permisos
CREATE TABLE grupos_permisos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(100) UNIQUE NOT NULL,
    nombre_display VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo_acceso VARCHAR(50),
    color_hex VARCHAR(7) DEFAULT '#808080',
    requiere_aprobacion BOOLEAN DEFAULT FALSE,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_grupos_permisos_codigo ON grupos_permisos(codigo);
CREATE INDEX idx_grupos_permisos_activo ON grupos_permisos(activo);

-- Tabla 5: Relación Grupos-Capacidades
CREATE TABLE grupo_capacidades (
    id SERIAL PRIMARY KEY,
    grupo_id INTEGER REFERENCES grupos_permisos(id) ON DELETE CASCADE,
    capacidad_id INTEGER REFERENCES capacidades(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(grupo_id, capacidad_id)
);

CREATE INDEX idx_grupo_capacidades_grupo ON grupo_capacidades(grupo_id);
CREATE INDEX idx_grupo_capacidades_capacidad ON grupo_capacidades(capacidad_id);

-- Tabla 6: Asignación Usuarios-Grupos
CREATE TABLE usuarios_grupos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    grupo_id INTEGER REFERENCES grupos_permisos(id) ON DELETE CASCADE,
    asignado_por INTEGER,
    fecha_asignacion TIMESTAMP DEFAULT NOW(),
    fecha_expiracion TIMESTAMP,
    motivo TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(usuario_id, grupo_id)
);

CREATE INDEX idx_usuarios_grupos_usuario ON usuarios_grupos(usuario_id);
CREATE INDEX idx_usuarios_grupos_grupo ON usuarios_grupos(grupo_id);
CREATE INDEX idx_usuarios_grupos_activo ON usuarios_grupos(activo);

-- Tabla 7: Permisos Excepcionales
CREATE TABLE permisos_excepcionales (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    capacidad_id INTEGER REFERENCES capacidades(id) ON DELETE CASCADE,
    tipo VARCHAR(20) NOT NULL,
    motivo TEXT NOT NULL,
    fecha_inicio TIMESTAMP DEFAULT NOW(),
    fecha_fin TIMESTAMP,
    autorizado_por INTEGER NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_tipo CHECK (tipo IN ('conceder', 'revocar'))
);

CREATE INDEX idx_permisos_excepcionales_usuario ON permisos_excepcionales(usuario_id);
CREATE INDEX idx_permisos_excepcionales_capacidad ON permisos_excepcionales(capacidad_id);

-- Tabla 8: Auditoría de Permisos
CREATE TABLE auditoria_permisos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL,
    capacidad_solicitada VARCHAR(255) NOT NULL,
    accion_realizada VARCHAR(100) NOT NULL,
    resultado VARCHAR(50) NOT NULL,
    ip_address INET,
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT NOW(),
    detalles JSONB,
    CONSTRAINT chk_resultado CHECK (resultado IN ('permitido', 'denegado', 'error'))
);

CREATE INDEX idx_auditoria_permisos_usuario ON auditoria_permisos(usuario_id);
CREATE INDEX idx_auditoria_permisos_timestamp ON auditoria_permisos(timestamp);
CREATE INDEX idx_auditoria_permisos_resultado ON auditoria_permisos(resultado);
```

**Ejecutar migración**:
```bash
psql -U postgres -d iact_db -f migrations/0001_create_permissions_tables.sql
```

**Validar**:
```bash
psql -U postgres -d iact_db -c "\dt" | grep -E "(funciones|capacidades|grupos_permisos)"
```

### Paso 1.2: Crear Vistas y Funciones

**Archivo**: `migrations/0002_create_views_functions.sql`

```sql
-- Vista 1: Capacidades de Usuario
CREATE OR REPLACE VIEW vista_capacidades_usuario AS
SELECT DISTINCT
    ug.usuario_id,
    c.nombre_completo as capacidad,
    c.accion,
    c.recurso,
    c.dominio,
    gp.codigo as grupo_codigo,
    gp.nombre_display as grupo_nombre,
    'grupo' as origen
FROM usuarios_grupos ug
JOIN grupos_permisos gp ON ug.grupo_id = gp.id
JOIN grupo_capacidades gc ON gp.id = gc.grupo_id
JOIN capacidades c ON gc.capacidad_id = c.id
WHERE ug.activo = TRUE
  AND gp.activo = TRUE
  AND c.activa = TRUE
  AND (ug.fecha_expiracion IS NULL OR ug.fecha_expiracion > NOW())

UNION ALL

SELECT DISTINCT
    pe.usuario_id,
    c.nombre_completo as capacidad,
    c.accion,
    c.recurso,
    c.dominio,
    NULL as grupo_codigo,
    'Permiso Excepcional' as grupo_nombre,
    'excepcional' as origen
FROM permisos_excepcionales pe
JOIN capacidades c ON pe.capacidad_id = c.id
WHERE pe.activo = TRUE
  AND pe.tipo = 'conceder'
  AND (pe.fecha_fin IS NULL OR pe.fecha_fin > NOW())
  AND c.activa = TRUE;

-- Vista 2: Grupos de Usuario
CREATE OR REPLACE VIEW vista_grupos_usuario AS
SELECT
    ug.usuario_id,
    gp.id as grupo_id,
    gp.codigo as grupo_codigo,
    gp.nombre_display as grupo_nombre,
    gp.descripcion,
    ug.fecha_asignacion,
    ug.fecha_expiracion,
    ug.activo,
    CASE
        WHEN ug.fecha_expiracion IS NULL THEN TRUE
        WHEN ug.fecha_expiracion > NOW() THEN TRUE
        ELSE FALSE
    END as vigente,
    COUNT(gc.capacidad_id) as capacidades_count
FROM usuarios_grupos ug
JOIN grupos_permisos gp ON ug.grupo_id = gp.id
LEFT JOIN grupo_capacidades gc ON gp.id = gc.grupo_id
GROUP BY ug.usuario_id, gp.id, gp.codigo, gp.nombre_display,
         gp.descripcion, ug.fecha_asignacion, ug.fecha_expiracion, ug.activo;

-- Función: Verificar si usuario tiene permiso
CREATE OR REPLACE FUNCTION usuario_tiene_permiso(
    p_usuario_id INTEGER,
    p_capacidad VARCHAR
) RETURNS BOOLEAN AS $$
DECLARE
    v_tiene_permiso BOOLEAN;
BEGIN
    -- Verificar en grupos
    SELECT EXISTS(
        SELECT 1
        FROM vista_capacidades_usuario
        WHERE usuario_id = p_usuario_id
          AND capacidad = p_capacidad
    ) INTO v_tiene_permiso;

    -- Registrar auditoría
    INSERT INTO auditoria_permisos (
        usuario_id,
        capacidad_solicitada,
        accion_realizada,
        resultado
    ) VALUES (
        p_usuario_id,
        p_capacidad,
        'verificacion',
        CASE WHEN v_tiene_permiso THEN 'permitido' ELSE 'denegado' END
    );

    RETURN v_tiene_permiso;
END;
$$ LANGUAGE plpgsql;
```

**Ejecutar**:
```bash
psql -U postgres -d iact_db -f migrations/0002_create_views_functions.sql
```

**Validar**:
```bash
# Verificar vistas
psql -U postgres -d iact_db -c "\dv" | grep vista_

# Probar función
psql -U postgres -d iact_db -c "SELECT usuario_tiene_permiso(1, 'sistema.administracion.usuarios.ver');"
```

## Fase 2: Datos Semilla (Semana 1-2)

### Paso 2.1: Insertar 13 Funciones

**Archivo**: `migrations/0003_seed_funciones.sql`

```sql
-- Prioridad 2: Funciones Core
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu)
VALUES
    ('usuarios', 'sistema.administracion.usuarios', 'administracion', 'gestion',
     'Gestión completa de usuarios del sistema', 'users', 10),
    ('dashboards', 'sistema.vistas.dashboards', 'vistas', 'visualizacion',
     'Acceso y gestión de dashboards y visualizaciones', 'layout-dashboard', 1),
    ('configuracion', 'sistema.tecnico.configuracion', 'tecnico', 'configuracion',
     'Configuración técnica y parámetros del sistema', 'settings', 100);

-- Prioridad 3: Módulos Operativos
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu)
VALUES
    ('llamadas', 'sistema.operaciones.llamadas', 'operaciones', 'operativo',
     'Gestión de llamadas entrantes y salientes', 'phone', 20),
    ('tickets', 'sistema.operaciones.tickets', 'operaciones', 'operativo',
     'Gestión de tickets de soporte', 'ticket', 21),
    ('clientes', 'sistema.operaciones.clientes', 'operaciones', 'operativo',
     'Gestión de información de clientes', 'users-circle', 22),
    ('metricas', 'sistema.analisis.metricas', 'analisis', 'analitico',
     'Visualización de métricas operativas', 'chart-line', 30),
    ('reportes', 'sistema.analisis.reportes', 'analisis', 'analitico',
     'Generación y gestión de reportes', 'file-text', 31),
    ('alertas', 'sistema.monitoreo.alertas', 'monitoreo', 'monitoreo',
     'Gestión de alertas y notificaciones', 'bell', 40);

-- Prioridad 4: Módulos de Gestión
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu)
VALUES
    ('equipos', 'sistema.supervision.equipos', 'supervision', 'gestion',
     'Gestión de equipos de trabajo', 'users-group', 50),
    ('horarios', 'sistema.supervision.horarios', 'supervision', 'planificacion',
     'Gestión de horarios y turnos', 'calendar', 51),
    ('evaluaciones', 'sistema.calidad.evaluaciones', 'calidad', 'calidad',
     'Evaluación de desempeño', 'clipboard-check', 60),
    ('auditoria', 'sistema.calidad.auditoria', 'calidad', 'calidad',
     'Auditoría de calidad de llamadas y tickets', 'search', 61);
```

**Ejecutar y validar**:
```bash
psql -U postgres -d iact_db -f migrations/0003_seed_funciones.sql
psql -U postgres -d iact_db -c "SELECT nombre, nombre_completo, dominio FROM funciones ORDER BY orden_menu;"
```

### Paso 2.2: Insertar 78 Capacidades

**Ver archivo completo**: `docs/backend/requisitos/prioridad_01_estructura_base_datos.md`

**Ejemplo para función usuarios**:
```sql
INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria)
VALUES
    ('sistema.administracion.usuarios.ver', 'ver', 'usuarios', 'administracion',
     'Visualizar listado y detalles de usuarios', 'bajo', FALSE),
    ('sistema.administracion.usuarios.crear', 'crear', 'usuarios', 'administracion',
     'Crear nuevos usuarios en el sistema', 'alto', TRUE),
    ('sistema.administracion.usuarios.editar', 'editar', 'usuarios', 'administracion',
     'Modificar información de usuarios existentes', 'normal', TRUE),
    ('sistema.administracion.usuarios.eliminar', 'eliminar', 'usuarios', 'administracion',
     'Eliminar usuarios del sistema', 'critico', TRUE),
    ('sistema.administracion.usuarios.exportar', 'exportar', 'usuarios', 'administracion',
     'Exportar listado de usuarios', 'normal', TRUE),
    ('sistema.administracion.usuarios.suspender', 'suspender', 'usuarios', 'administracion',
     'Suspender temporalmente acceso de usuario', 'alto', TRUE),
    ('sistema.administracion.usuarios.reactivar', 'reactivar', 'usuarios', 'administracion',
     'Reactivar usuario suspendido', 'alto', TRUE);
```

**Nota**: Repetir para las 13 funciones. Ver `prioridad_01_estructura_base_datos.md` para SQL completo.

### Paso 2.3: Crear 10 Grupos Funcionales

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, activo)
VALUES
    ('administracion_usuarios', 'Administración de Usuarios',
     'Gestión completa de cuentas de usuario del sistema', 'tecnico', '#8B5CF6', TRUE),
    ('visualizacion_basica', 'Visualización Básica',
     'Acceso de solo lectura a dashboards', 'operativo', '#10B981', TRUE),
    ('configuracion_sistema', 'Configuración del Sistema',
     'Gestión de configuración técnica del sistema', 'tecnico', '#EF4444', TRUE),
    ('atencion_cliente', 'Atención al Cliente',
     'Operaciones básicas de atención', 'operativo', '#3B82F6', TRUE),
    ('atencion_cliente_avanzada', 'Atención al Cliente Avanzada',
     'Operaciones avanzadas de atención con cierre y escalamiento', 'operativo', '#F59E0B', TRUE),
    ('analisis_operativo', 'Análisis Operativo',
     'Generación de métricas y reportes operativos', 'analitico', '#EC4899', TRUE),
    ('gestion_equipos', 'Gestión de Equipos',
     'Administración de equipos de trabajo', 'supervision', '#14B8A6', TRUE),
    ('gestion_horarios', 'Gestión de Horarios',
     'Planificación y aprobación de horarios', 'supervision', '#A855F7', TRUE),
    ('auditoria_llamadas', 'Auditoría de Llamadas',
     'Auditoría de calidad de atención', 'calidad', '#F43F5E', TRUE),
    ('evaluacion_desempeno', 'Evaluación de Desempeño',
     'Creación y aprobación de evaluaciones', 'calidad', '#0EA5E9', TRUE);
```

## Fase 3: Módulos Django (Semana 2-3)

### Paso 3.1: Extender Módulo Users

**Ubicación**: `api/callcentersite/callcentersite/apps/users/`

**Crear servicio**: `users/services/user_management_service.py`

```python
from django.contrib.auth import get_user_model
from django.db import connection, transaction
from rest_framework.exceptions import PermissionDenied, ValidationError

User = get_user_model()


class UserManagementService:
    """Servicio para gestión de usuarios con permisos granulares."""

    @staticmethod
    def usuario_tiene_permiso(usuario_id: int, capacidad: str) -> bool:
        """
        Verifica si un usuario tiene una capacidad específica.

        Usa la función PostgreSQL usuario_tiene_permiso().
        """
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT usuario_tiene_permiso(%s, %s);",
                [usuario_id, capacidad]
            )
            result = cursor.fetchone()
            return result[0] if result else False

    @staticmethod
    @transaction.atomic
    def crear_usuario(usuario_solicitante_id: int, datos: dict) -> User:
        """
        Crea un nuevo usuario con validación de permisos.

        Args:
            usuario_solicitante_id: ID del usuario que solicita la creación
            datos: dict con campos: nombre, email, password, grupos[]

        Returns:
            Usuario creado

        Raises:
            PermissionDenied: Si no tiene permiso
            ValidationError: Si datos son inválidos
        """
        # Verificar permiso
        if not UserManagementService.usuario_tiene_permiso(
            usuario_solicitante_id,
            'sistema.administracion.usuarios.crear'
        ):
            raise PermissionDenied('No autorizado para crear usuarios')

        # Validar datos
        if not datos.get('email'):
            raise ValidationError('Email es requerido')

        if User.objects.filter(email=datos['email']).exists():
            raise ValidationError('Email ya registrado')

        # Crear usuario
        usuario = User.objects.create_user(
            username=datos['email'],
            email=datos['email'],
            first_name=datos.get('nombre', ''),
            password=datos.get('password', User.objects.make_random_password())
        )

        # Asignar grupos
        if 'grupos' in datos:
            for grupo_id in datos['grupos']:
                with connection.cursor() as cursor:
                    cursor.execute(
                        """
                        INSERT INTO usuarios_grupos (usuario_id, grupo_id, asignado_por, activo)
                        VALUES (%s, %s, %s, TRUE);
                        """,
                        [usuario.id, grupo_id, usuario_solicitante_id]
                    )

        return usuario

    @staticmethod
    @transaction.atomic
    def suspender_usuario(usuario_solicitante_id: int, usuario_id: int, motivo: str):
        """Suspende un usuario temporalmente."""
        if not UserManagementService.usuario_tiene_permiso(
            usuario_solicitante_id,
            'sistema.administracion.usuarios.suspender'
        ):
            raise PermissionDenied('No autorizado para suspender usuarios')

        usuario = User.objects.get(id=usuario_id)
        usuario.is_active = False
        usuario.save()

        # Registrar auditoría
        with connection.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO auditoria_permisos
                (usuario_id, capacidad_solicitada, accion_realizada, resultado, detalles)
                VALUES (%s, 'sistema.administracion.usuarios.suspender', 'usuario_suspendido', 'permitido', %s::jsonb);
                """,
                [usuario_solicitante_id, f'{{"usuario_suspendido": {usuario_id}, "motivo": "{motivo}"}}']
            )
```

**Crear ViewSet**: `users/views.py`

```python
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .services.user_management_service import UserManagementService
from .serializers import UserSerializer, UserCreateSerializer


class UserViewSet(viewsets.ModelViewSet):
    """ViewSet para gestión de usuarios."""

    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer

    def get_queryset(self):
        """Solo usuarios que el usuario actual puede ver."""
        # TODO: Implementar filtro por permisos
        return User.objects.all()

    def create(self, request):
        """Crear nuevo usuario."""
        serializer = UserCreateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        try:
            usuario = UserManagementService.crear_usuario(
                usuario_solicitante_id=request.user.id,
                datos=serializer.validated_data
            )
            return Response(
                UserSerializer(usuario).data,
                status=status.HTTP_201_CREATED
            )
        except PermissionDenied as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_403_FORBIDDEN
            )

    @action(detail=True, methods=['post'])
    def suspender(self, request, pk=None):
        """Suspender usuario."""
        motivo = request.data.get('motivo', 'Sin motivo')

        try:
            UserManagementService.suspender_usuario(
                usuario_solicitante_id=request.user.id,
                usuario_id=pk,
                motivo=motivo
            )
            return Response({'status': 'Usuario suspendido'})
        except PermissionDenied as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_403_FORBIDDEN
            )
```

**Configurar URLs**: `users/urls.py`

```python
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet

router = DefaultRouter()
router.register(r'usuarios', UserViewSet, basename='usuario')

urlpatterns = [
    path('', include(router.urls)),
]
```

## Fase 4: Tests (Semana 3-4)

### Paso 4.1: Tests de Permisos

**Archivo**: `tests/users/test_permissions.py`

```python
import pytest
from django.contrib.auth import get_user_model
from apps.users.services.user_management_service import UserManagementService

User = get_user_model()


@pytest.mark.django_db
class TestUserManagementPermissions:
    """Tests de permisos de gestión de usuarios."""

    def test_usuario_con_permiso_puede_crear_usuario(self):
        """Usuario con permiso puede crear usuarios."""
        # Setup: Crear usuario admin con grupo administracion_usuarios
        admin = User.objects.create_user(
            username='admin@test.com',
            email='admin@test.com',
            password='test123'
        )

        # Asignar grupo (requiere SQL directo en tests)
        # TODO: Implementar factory para asignación de grupos

        # Test
        datos = {
            'email': 'nuevo@test.com',
            'nombre': 'Usuario Nuevo',
            'grupos': []
        }

        usuario_nuevo = UserManagementService.crear_usuario(
            usuario_solicitante_id=admin.id,
            datos=datos
        )

        assert usuario_nuevo.email == 'nuevo@test.com'

    def test_usuario_sin_permiso_no_puede_crear_usuario(self):
        """Usuario sin permiso no puede crear usuarios."""
        # Setup: Usuario sin grupo de administración
        user = User.objects.create_user(
            username='user@test.com',
            email='user@test.com',
            password='test123'
        )

        # Test
        datos = {
            'email': 'nuevo@test.com',
            'nombre': 'Usuario Nuevo'
        }

        with pytest.raises(PermissionDenied):
            UserManagementService.crear_usuario(
                usuario_solicitante_id=user.id,
                datos=datos
            )
```

## Validación

Al completar la implementación:

- [ ] 8 tablas creadas en PostgreSQL
- [ ] 2 vistas creadas (vista_capacidades_usuario, vista_grupos_usuario)
- [ ] 1 función creada (usuario_tiene_permiso)
- [ ] 13 funciones insertadas
- [ ] 78 capacidades insertadas
- [ ] 10 grupos funcionales creados
- [ ] Módulo users extendido con servicios
- [ ] Endpoints REST funcionales
- [ ] Tests de permisos pasando

## Troubleshooting

### Error 1: Tabla ya existe

**Síntomas**:
```
ERROR: relation "funciones" already exists
```

**Solución**:
```bash
# Verificar tablas existentes
psql -U postgres -d iact_db -c "\dt"

# Si necesitas recrear (CUIDADO: elimina datos)
psql -U postgres -d iact_db -c "DROP TABLE IF EXISTS funciones CASCADE;"
```

### Error 2: Función PostgreSQL no encontrada

**Síntomas**:
```
django.db.utils.ProgrammingError: function usuario_tiene_permiso(integer, character varying) does not exist
```

**Solución**:
```bash
# Verificar funciones creadas
psql -U postgres -d iact_db -c "\df usuario_tiene_permiso"

# Recrear función
psql -U postgres -d iact_db -f migrations/0002_create_views_functions.sql
```

## Próximos pasos

Después de completar esta guía:

1. **Implementar módulos operativos** (tickets, clients, teams)
2. **Crear middleware de permisos** para validación automática
3. **Implementar frontend** para gestión de usuarios y grupos
4. **Capacitar a administradores** en uso del sistema

## Referencias

- Documentación base de datos: `docs/backend/requisitos/prioridad_01_estructura_base_datos.md`
- ADR_2025_005: `docs/adr/ADR_2025_005-grupos-funcionales-sin-jerarquia.md`
- Mapeo Django: `docs/backend/requisitos/MAPEO_FUNCIONES_MODULOS_DJANGO.md`
- Casos de uso: `docs/backend/requisitos/CASOS_DE_USO_SISTEMA_PERMISOS.md`

## Feedback

Si encuentras problemas con esta guía:
- Crea un issue en GitHub con label `bug` o `documentation`
- Contacta a: equipo-backend

---

**Mantenedores**: equipo-backend, equipo-arquitectura
**Última actualización**: 2025-11-07
