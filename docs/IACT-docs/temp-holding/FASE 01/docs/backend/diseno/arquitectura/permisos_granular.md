---
title: Sistema de Permisos Granular
date: 2025-11-13
domain: backend
status: active
---

# Sistema de Permisos Granular

**Autor**: Backend Team
**Fecha**: 2025-11-09
**Estado**: ACTIVO - 100% IMPLEMENTADO

## Indice

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Arquitectura del Sistema](#arquitectura-del-sistema)
- [Modelos de Datos](#modelos-de-datos)
- [API y Servicios](#api-y-servicios)
- [Vistas y Funciones SQL](#vistas-y-funciones-sql)
- [Uso y Ejemplos](#uso-y-ejemplos)
- [Performance](#performance)
- [Referencias](#referencias)

---

## Resumen Ejecutivo

El Sistema de Permisos Granular implementa un modelo **basado en Grupos Funcionales** (NO roles jerárquicos) que permite:

[OK] **Permisos granulares** a nivel de acción sobre recurso
[OK] **Grupos funcionales** sin jerarquía (composición flexible)
[OK] **Permisos excepcionales** (temporales o permanentes)
[OK] **Auditoría completa** de todos los accesos
[OK] **Performance optimizado** con vistas SQL y funciones nativas

**Estado**: [OK] 100% IMPLEMENTADO (Nov 2025)

---

## Arquitectura del Sistema

### Diagrama de Componentes

```

 CAPA DE APLICACIÓN 

 Django Views / DRF ViewSets 
 ↓ 
 UserManagementService (services_permisos_granular.py) 
 ↓ 
 verificar_permiso_y_auditar() helper 

 ↓

 CAPA DE DATOS 

 Django ORM (models_permisos_granular.py) 
 ↓ 
 8 Modelos Django: 
 - Funcion, Capacidad, FuncionCapacidad 
 - GrupoPermiso, GrupoCapacidad, UsuarioGrupo 
 - PermisoExcepcional, AuditoriaPermiso 

 ↓

 CAPA DE BASE DE DATOS 

 PostgreSQL 16 
 ↓ 
 8 Tablas + 2 Vistas + 5 Funciones SQL: 
 - Tablas: funciones, capacidades, grupos_permisos, etc 
 - Vistas: vista_capacidades_usuario, vista_grupos_usuario 
 - Funciones: usuario_tiene_permiso(), obtener_menu(), etc 

```

---

## Modelos de Datos

### 1. Funcion (Recurso del Sistema)

**Proposito**: Representa recursos/módulos del sistema

**Ubicacion**: `models_permisos_granular.py:17`

**Campos principales**:
```python
nombre: str # 'dashboards', 'usuarios'
nombre_completo: str # 'sistema.vistas.dashboards'
dominio: str # 'vistas', 'administracion'
categoria: str # 'visualizacion', 'gestion'
icono: str # Para UI
orden_menu: int # Para ordenar en menú
activa: bool # Control de activación
```

**Relaciones**:
- ManyToMany con `Capacidad` (through `FuncionCapacidad`)

**Ejemplo**:
```python
from callcentersite.apps.users.models_permisos_granular import Funcion

dashboard_func = Funcion.objects.get(codigo='sistema.vistas.dashboards')
print(dashboard_func.capacidades.count()) # Número de capacidades
```

---

### 2. Capacidad (Acción Granular)

**Proposito**: Acción específica sobre un recurso

**Ubicacion**: `models_permisos_granular.py:66`

**Campos principales**:
```python
codigo: str # 'sistema.administracion.usuarios.crear'
nombre: str # 'Crear Usuario'
nivel_riesgo: str # 'bajo', 'medio', 'alto', 'critico'
requiere_aprobacion: bool
activa: bool
```

**Ejemplos de capacidades**:
```
sistema.vistas.dashboards.ver
sistema.administracion.usuarios.crear
sistema.administracion.usuarios.editar
sistema.administracion.usuarios.eliminar
sistema.operaciones.llamadas.realizar
sistema.reportes.metricas.exportar
```

**Uso**:
```python
from callcentersite.apps.users.models_permisos_granular import Capacidad

# Obtener capacidad
cap = Capacidad.objects.get(codigo='sistema.vistas.dashboards.ver')
print(cap.nivel_riesgo) # 'bajo'

# Listar capacidades de nivel crítico
criticas = Capacidad.objects.filter(nivel_riesgo='critico')
```

---

### 3. GrupoPermiso (Grupo Funcional)

**Proposito**: Agrupación lógica de capacidades SIN jerarquía

**Ubicacion**: `models_permisos_granular.py:110`

**Campos principales**:
```python
codigo: str # 'atencion_cliente', 'supervision_operativa'
nombre_display: str # 'Atención al Cliente'
tipo_acceso: str # 'operativo', 'gestion', 'estrategico'
color_hex: str # '#3B82F6' (para UI)
activo: bool
```

**Relaciones**:
- ManyToMany con `Capacidad` (through `GrupoCapacidad`)
- ManyToMany con `User` (through `UsuarioGrupo`)

**Grupos predefinidos** (10 grupos):
1. `administracion_usuarios` - Gestión de usuarios
2. `atencion_cliente` - Atención al cliente
3. `supervision_operativa` - Supervisión de operaciones
4. `gestion_financiera` - Gestión financiera
5. `administracion_tecnica` - Administración técnica
6. `analisis_calidad` - Análisis de calidad
7. `gestion_equipos` - Gestión de equipos
8. `visualizacion_basica` - Solo lectura
9. `coordinacion_general` - Coordinación
10. `direccion_ejecutiva` - Dirección

**Ejemplo**:
```python
from callcentersite.apps.users.models_permisos_granular import GrupoPermiso

# Obtener grupo
grupo = GrupoPermiso.objects.get(codigo='atencion_cliente')

# Ver capacidades del grupo
capacidades = grupo.capacidades.all()
print(f"Grupo '{grupo.nombre_display}' tiene {capacidades.count()} capacidades")
```

---

### 4. UsuarioGrupo (Asignación de Grupos)

**Proposito**: Asigna grupos a usuarios (N:M)

**Ubicacion**: `models_permisos_granular.py:144`

**Campos principales**:
```python
usuario: ForeignKey(User)
grupo: ForeignKey(GrupoPermiso)
fecha_asignacion: datetime
fecha_expiracion: datetime # NULL = permanente
asignado_por: ForeignKey(User)
motivo: str
activo: bool
```

**Características**:
- [OK] Un usuario puede tener **N grupos** simultáneos
- [OK] Asignaciones **temporales** (con fecha_expiracion)
- [OK] Asignaciones **permanentes** (fecha_expiracion = NULL)
- [OK] Historial (desactivar vs eliminar)

**Ejemplo**:
```python
from callcentersite.apps.users.services_permisos_granular import UserManagementService

# Asignar grupo a usuario
UserManagementService.asignar_grupo_a_usuario(
 usuario_id=1,
 grupo_codigo='atencion_cliente',
 asignado_por_id=5,
 fecha_expiracion=None, # Permanente
 motivo='Nuevo agente de call center'
)

# Obtener grupos de usuario
grupos = UserManagementService.obtener_grupos_de_usuario(usuario_id=1)
print([g.nombre_display for g in grupos])
```

---

### 5. PermisoExcepcional (Permisos Directos)

**Proposito**: Permisos individuales que sobrescriben grupos

**Ubicacion**: `models_permisos_granular.py:188`

**Campos principales**:
```python
usuario: ForeignKey(User)
capacidad: ForeignKey(Capacidad)
tipo: str # 'conceder' o 'revocar'
fecha_inicio: datetime
fecha_expiracion: datetime
motivo: str # OBLIGATORIO
otorgado_por: ForeignKey(User)
activo: bool
```

**Tipos**:
1. **Conceder**: Añade capacidad NO incluida en grupos
2. **Revocar**: Quita capacidad que SÍ viene de grupos

**Ejemplo**:
```python
from callcentersite.apps.users.services_permisos_granular import UserManagementService
from datetime import datetime, timedelta

# Otorgar permiso excepcional temporal (7 días)
UserManagementService.otorgar_permiso_excepcional(
 usuario_id=3,
 capacidad_codigo='sistema.reportes.metricas.exportar',
 otorgado_por_id=5,
 motivo='Reemplazo temporal de analista de turno',
 tipo='temporal',
 fecha_expiracion=datetime.now() + timedelta(days=7)
)
```

---

### 6. AuditoriaPermiso (Log de Accesos)

**Proposito**: Registro inmutable de TODOS los intentos de acceso

**Ubicacion**: `models_permisos_granular.py:224`

**Campos principales**:
```python
usuario: ForeignKey(User)
capacidad_codigo: str
accion: str # 'acceso_permitido', 'acceso_denegado', etc
resultado: str # 'exito', 'fallo'
recurso_accedido: str
endpoint: str
ip_address: str
user_agent: str
metadata: JSONField
timestamp: datetime
```

**Se audita**:
- [OK] Accesos permitidos
- [OK] Accesos denegados
- [OK] Asignación de grupos
- [OK] Revocación de grupos
- [OK] Permisos excepcionales

**Ejemplo de consulta**:
```python
from callcentersite.apps.users.models_permisos_granular import AuditoriaPermiso
from datetime import datetime, timedelta

# Accesos denegados últimas 24h
denegados = AuditoriaPermiso.objects.filter(
 accion='acceso_denegado',
 timestamp__gte=datetime.now() - timedelta(hours=24)
).select_related('usuario')

for log in denegados:
 print(f"{log.usuario.username} intentó {log.capacidad_codigo} desde {log.ip_address}")
```

---

## API y Servicios

### UserManagementService

**Ubicacion**: `services_permisos_granular.py:28`

#### Método 1: `usuario_tiene_permiso()`

**Proposito**: Verificar si usuario tiene capacidad específica

**Signatura**:
```python
@staticmethod
def usuario_tiene_permiso(
 usuario_id: int,
 capacidad_codigo: str,
 auditar: bool = True,
 ip_address: Optional[str] = None,
 user_agent: Optional[str] = None,
) -> bool
```

**Niveles de verificación**:
1. Permisos excepcionales concedidos (+)
2. Grupos asignados (=)
3. Permisos excepcionales revocados (-)

**Ejemplo**:
```python
from callcentersite.apps.users.services_permisos_granular import UserManagementService

# Verificar permiso
tiene_permiso = UserManagementService.usuario_tiene_permiso(
 usuario_id=1,
 capacidad_codigo='sistema.vistas.dashboards.ver',
 auditar=True,
 ip_address='192.168.1.100'
)

if tiene_permiso:
 # Mostrar dashboard
 pass
else:
 # Mostrar error 403
 pass
```

---

#### Método 2: `obtener_capacidades_de_usuario()`

**Proposito**: Obtener TODAS las capacidades efectivas de un usuario

**Signatura**:
```python
@staticmethod
def obtener_capacidades_de_usuario(usuario_id: int) -> List[Capacidad]
```

**Ejemplo**:
```python
capacidades = UserManagementService.obtener_capacidades_de_usuario(usuario_id=1)

# Agrupar por dominio
from collections import defaultdict
por_dominio = defaultdict(list)

for cap in capacidades:
 dominio = cap.codigo.split('.')[1] # 'sistema.DOMINIO.recurso.accion'
 por_dominio[dominio].append(cap.codigo)

print(por_dominio)
# {'vistas': ['sistema.vistas.dashboards.ver', ...],
# 'administracion': ['sistema.administracion.usuarios.crear', ...]}
```

---

#### Método 3: `asignar_grupo_a_usuario()`

**Proposito**: Asignar grupo funcional a usuario

**Signatura**:
```python
@staticmethod
def asignar_grupo_a_usuario(
 usuario_id: int,
 grupo_codigo: str,
 asignado_por_id: int,
 fecha_expiracion: Optional[datetime] = None,
 motivo: str = "",
) -> bool
```

**Ejemplo**:
```python
# Asignación permanente
UserManagementService.asignar_grupo_a_usuario(
 usuario_id=10,
 grupo_codigo='atencion_cliente',
 asignado_por_id=5,
 motivo='Nuevo agente contratado'
)

# Asignación temporal (30 días)
from datetime import datetime, timedelta

UserManagementService.asignar_grupo_a_usuario(
 usuario_id=12,
 grupo_codigo='supervision_operativa',
 asignado_por_id=5,
 fecha_expiracion=datetime.now() + timedelta(days=30),
 motivo='Reemplazo vacaciones supervisor titular'
)
```

---

### Helper: `verificar_permiso_y_auditar()`

**Ubicacion**: `service_helpers.py:16`

**Proposito**: Decorator/helper para views que requieren permisos

**Ejemplo de uso en view**:
```python
from callcentersite.apps.users.service_helpers import verificar_permiso_y_auditar
from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET'])
def dashboard_view(request):
 # Verificar permiso
 tiene_permiso = verificar_permiso_y_auditar(
 usuario_id=request.user.id,
 capacidad_codigo='sistema.vistas.dashboards.ver',
 request=request
 )

 if not tiene_permiso:
 return Response({'error': 'Permiso denegado'}, status=403)

 # Continuar con lógica
 return Response({'data': 'Dashboard data'})
```

---

## Vistas y Funciones SQL

### Vista 1: `vista_capacidades_usuario`

**Proposito**: Consolidar capacidades efectivas de cada usuario

**Ubicacion**: Migración `0002_create_permission_views.py`

**Uso en Django**:
```python
from django.db import connection

def obtener_capacidades_sql(usuario_id):
 """Usar vista SQL directamente (más rápido que ORM)"""
 with connection.cursor() as cursor:
 cursor.execute("""
 SELECT capacidad_codigo, origen, nivel_riesgo
 FROM vista_capacidades_usuario
 WHERE usuario_id = %s
 ORDER BY capacidad_codigo
 """, [usuario_id])

 return [
 {
 'codigo': row[0],
 'origen': row[1],
 'nivel_riesgo': row[2]
 }
 for row in cursor.fetchall()
 ]
```

**Performance**:
- ORM (Django): ~50-100ms (con 10 grupos, 78 capacidades)
- Vista SQL: ~10-20ms (5-10x más rápido)

---

### Vista 2: `vista_grupos_usuario`

**Proposito**: Grupos asignados con cálculo de vigencia

**Uso**:
```sql
-- Ver grupos vigentes de usuario
SELECT
 grupo_codigo,
 grupo_nombre,
 vigente,
 fecha_expiracion
FROM vista_grupos_usuario
WHERE usuario_id = 1
 AND vigente = TRUE;
```

---

### Función 1: `usuario_tiene_permiso(p_usuario_id, p_capacidad_codigo)`

**Proposito**: Verificación rápida de permisos en SQL puro

**Ubicacion**: Migración `0003_create_permission_functions.py`

**Uso**:
```sql
-- Verificar permiso
SELECT usuario_tiene_permiso(1, 'sistema.vistas.dashboards.ver');
-- Retorna: TRUE o FALSE
```

**Uso desde Django**:
```python
from django.db import connection

def verificar_permiso_sql(usuario_id, capacidad_codigo):
 """Verificación ultra-rápida usando función SQL"""
 with connection.cursor() as cursor:
 cursor.execute(
 "SELECT usuario_tiene_permiso(%s, %s)",
 [usuario_id, capacidad_codigo]
 )
 return cursor.fetchone()[0]
```

**Performance**:
- Service Python: ~30-50ms
- Función SQL: ~5-10ms (3-5x más rápido)

---

### Función 2: `obtener_menu_usuario(p_usuario_id)`

**Proposito**: Generar menú dinámico en formato JSONB

**Uso**:
```sql
-- Obtener menú completo
SELECT obtener_menu_usuario(1);

-- Retorna JSONB:
{
 "vistas": {
 "dashboards": ["sistema.vistas.dashboards.ver"],
 "reportes": ["sistema.vistas.reportes.ver", "sistema.vistas.reportes.exportar"]
 },
 "administracion": {
 "usuarios": ["sistema.administracion.usuarios.ver", "sistema.administracion.usuarios.crear"]
 }
}
```

**Uso desde Django**:
```python
from django.db import connection
import json

def generar_menu_usuario(usuario_id):
 """Generar menú usando función SQL"""
 with connection.cursor() as cursor:
 cursor.execute("SELECT obtener_menu_usuario(%s)", [usuario_id])
 menu_jsonb = cursor.fetchone()[0]
 return json.loads(menu_jsonb) if menu_jsonb else {}
```

---

## Uso y Ejemplos

### Caso de Uso 1: Login y Generación de Menú

```python
from callcentersite.apps.users.services_permisos_granular import UserManagementService

def after_login(user_id):
 """Ejecutar después del login exitoso"""

 # 1. Obtener grupos del usuario
 grupos = UserManagementService.obtener_grupos_de_usuario(user_id)

 # 2. Obtener capacidades
 capacidades = UserManagementService.obtener_capacidades_de_usuario(user_id)

 # 3. Guardar en sesión
 request.session['grupos'] = [g.codigo for g in grupos]
 request.session['capacidades'] = [c.codigo for c in capacidades]

 # 4. Generar menú (usando función SQL para performance)
 from django.db import connection
 with connection.cursor() as cursor:
 cursor.execute("SELECT obtener_menu_usuario(%s)", [user_id])
 menu = cursor.fetchone()[0]

 return menu
```

---

### Caso de Uso 2: Verificación en View

```python
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from callcentersite.apps.users.services_permisos_granular import UserManagementService

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def crear_usuario_view(request):
 """Crear usuario - requiere permiso específico"""

 # Verificar permiso
 tiene_permiso = UserManagementService.usuario_tiene_permiso(
 usuario_id=request.user.id,
 capacidad_codigo='sistema.administracion.usuarios.crear',
 auditar=True,
 ip_address=request.META.get('REMOTE_ADDR'),
 user_agent=request.META.get('HTTP_USER_AGENT')
 )

 if not tiene_permiso:
 return Response(
 {'error': 'No tienes permiso para crear usuarios'},
 status=403
 )

 # Continuar con creación
 # ... lógica de creación de usuario ...

 return Response({'status': 'Usuario creado'}, status=201)
```

---

### Caso de Uso 3: Asignación de Grupo Temporal

```python
from datetime import datetime, timedelta
from callcentersite.apps.users.services_permisos_granular import UserManagementService

def reemplazo_temporal_supervisor(usuario_reemplazo_id, supervisor_original_id):
 """Dar permisos de supervisión temporalmente"""

 # Calcular fecha de expiración (14 días)
 expiracion = datetime.now() + timedelta(days=14)

 # Asignar grupo de supervisión
 UserManagementService.asignar_grupo_a_usuario(
 usuario_id=usuario_reemplazo_id,
 grupo_codigo='supervision_operativa',
 asignado_por_id=supervisor_original_id,
 fecha_expiracion=expiracion,
 motivo=f'Reemplazo temporal durante vacaciones de supervisor #{supervisor_original_id}'
 )

 # Notificar al usuario
 # ... enviar email/notificación ...

 return {
 'status': 'success',
 'expira_en': expiracion.isoformat(),
 'dias': 14
 }
```

---

## Performance

### Benchmarks

| Operación | ORM Django | Vista SQL | Función SQL | Mejora |
|-----------|-----------|-----------|-------------|---------|
| `usuario_tiene_permiso()` | 30-50ms | N/A | 5-10ms | **5x** |
| `obtener_capacidades()` | 50-100ms | 10-20ms | N/A | **5-10x** |
| `generar_menu()` | 100-200ms | N/A | 20-40ms | **5x** |
| Auditoría (insert) | 10-15ms | N/A | 5-8ms | **2x** |

**Conclusión**: Funciones SQL son 3-10x más rápidas para queries frecuentes.

### Recomendaciones

**Usar ORM cuando**:
- Desarrollo/prototipado
- Queries complejas con múltiples JOINs
- Portabilidad entre DBs es importante

**Usar SQL nativo cuando**:
- Performance es crítica (< 10ms requerido)
- Endpoint de alta frecuencia (>100 req/s)
- Cálculos agregados complejos

---

## Referencias

### Documentación Interna

- [PRIORIDAD_01_estructura_base_datos.md](../requisitos/prioridad_01_estructura_base_datos.md)
- [PRIORIDAD_02_funciones_core.md](../requisitos/prioridad_02_funciones_core.md)
- [CATALOGO_GRUPOS_FUNCIONALES.md](../requisitos/CATALOGO_GRUPOS_FUNCIONALES.md)

### Código Fuente

- Modelos: `apps/users/models_permisos_granular.py`
- Servicios: `apps/users/services_permisos_granular.py`
- Helpers: `apps/users/service_helpers.py`
- Migración tablas: `apps/users/migrations/0001_initial_permisos_granular.py`
- Migración vistas: `apps/users/migrations/0002_create_permission_views.py`
- Migración funciones: `apps/users/migrations/0003_create_permission_functions.py`
- Seed: `apps/users/management/commands/seed_permisos_granular.py`

### Tests

- Unit tests: `tests/unit/users/test_permisos_granular.py`
- Integration tests: `tests/integration/test_administrador_completo.py`

---

## Changelog

### v1.0.0 (2025-11-09)
- Documentación completa del sistema
- 8 tablas + 8 modelos Django implementados
- 2 vistas SQL + 5 funciones SQL nativas
- Benchmarks y comparativas ORM vs SQL

---

**Ultima actualizacion**: 2025-11-09
**Mantenedor**: Backend Team
**Estado**: 100% IMPLEMENTADO
