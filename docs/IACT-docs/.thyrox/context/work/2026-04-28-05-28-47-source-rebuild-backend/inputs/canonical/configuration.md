---
title: App: configuration
date: 2025-11-13
domain: backend
status: active
---

# App: configuration

**Dominio**: Sistema
**Tipo**: Core
**Estado**: Producción
**Versión**: 1.0.0

## Resumen Ejecutivo

La aplicación `configuration` gestiona parámetros de configuración técnica del sistema que pueden ser modificados en tiempo de ejecución por usuarios autorizados. Implementa un sistema robusto de configuración dinámica con historial completo de cambios, tipos de datos tipados, y auditoría integral.

**Propósito principal**: Permitir la parametrización dinámica del sistema sin necesidad de redespliegues, con trazabilidad completa de cambios y control granular de permisos.

## Índice

- [Arquitectura](#arquitectura)
- [Modelos](#modelos)
- [Servicios](#servicios)
- [API](#api)
- [Decisiones de Diseño](#decisiones-de-diseño)
- [Seguridad](#seguridad)
- [Integración](#integración)

---

## Arquitectura

### Diagrama de Componentes

```

 configuration App 

 Configuracion<ConfiguracionHis
 torial 

 | 

 ConfiguracionService 
 - obtener() 
 - editar() 
 - exportar() 
 - importar() 
 - restaurar() 

 | 

 ConfiguracionViewSet 
 (DRF APIView) 

 |

 users.models 
 (Permisos 
 granulares) 

```

### Responsabilidades

1. **Almacenamiento de configuraciones**: Modelos Django con tipos de datos tipados
2. **Gestión de cambios**: CRUD completo con validación y permisos
3. **Historial de auditoría**: Tracking completo de modificaciones con metadata
4. **Import/Export**: Gestión masiva de configuraciones en formato JSON
5. **Restauración**: Rollback a valores por defecto

### Dependencias

- **Django ORM**: Persistencia de configuraciones
- **users app**: Sistema de permisos granulares (capacidades)
- **audit app**: Auditoría de acciones (indirecta vía service_helpers)
- **DRF**: REST API para CRUD de configuraciones

---

## Modelos

### 1. Configuracion

**Propósito**: Almacena parámetros de configuración técnica del sistema.

**Campos principales**:

| Campo | Tipo | Propósito |
|-------|------|-----------|
| `categoria` | CharField(50) | Agrupación lógica (general, seguridad, notificaciones, etc.) |
| `clave` | CharField(100) | Identificador único (ej: `sistema.timeout_session`) |
| `valor` | TextField | Valor actual de la configuración |
| `tipo_dato` | CharField(20) | Tipo del valor: string, integer, boolean, float, json, email, url |
| `valor_default` | TextField | Valor por defecto para restauración |
| `descripcion` | TextField | Descripción del propósito de la configuración |
| `activa` | BooleanField | Soft delete - indica si está activa |
| `updated_by` | FK(User) | Usuario que realizó la última modificación |
| `updated_at` | DateTimeField | Timestamp de última actualización |
| `created_at` | DateTimeField | Timestamp de creación |

**Métodos**:
- `get_valor_typed()`: Convierte el valor almacenado (string) a su tipo correspondiente
- `resetear_a_default()`: Restaura el valor al default configurado

**Índices**:
- `(categoria, activa)`: Búsquedas por categoría de configuraciones activas
- `clave`: UNIQUE index para búsqueda rápida

**Ejemplo de uso**:
```python
# Obtener configuración
config = Configuracion.objects.get(clave='sistema.timeout_session')
timeout = config.get_valor_typed() # Retorna int si tipo_dato='integer'

# Resetear a default
config.resetear_a_default()
```

### 2. ConfiguracionHistorial

**Propósito**: Registra todas las modificaciones realizadas a configuraciones para auditoría y trazabilidad.

**Campos principales**:

| Campo | Tipo | Propósito |
|-------|------|-----------|
| `configuracion` | FK(Configuracion) | Configuración modificada |
| `clave` | CharField(100) | Clave desnormalizada para queries históricas |
| `valor_anterior` | TextField | Valor antes del cambio |
| `valor_nuevo` | TextField | Valor después del cambio |
| `modificado_por` | FK(User) | Usuario que realizó el cambio |
| `timestamp` | DateTimeField | Momento exacto del cambio |
| `ip_address` | GenericIPAddressField | IP desde donde se realizó el cambio |
| `user_agent` | CharField(255) | User agent del navegador |

**Índices**:
- `(clave, -timestamp)`: Historial de cambios por configuración
- `(modificado_por, -timestamp)`: Cambios por usuario
- `(-timestamp)`: Orden cronológico inverso

**Ejemplo de uso**:
```python
# Ver historial de una configuración
historial = ConfiguracionHistorial.objects.filter(
 clave='sistema.timeout_session'
).order_by('-timestamp')[:10]

for cambio in historial:
 print(f"{cambio.timestamp}: {cambio.valor_anterior} -> {cambio.valor_nuevo}")
```

---

## Servicios

### ConfiguracionService

Implementa operaciones CRUD con verificación de permisos granulares y auditoría automática.

#### 1. obtener_configuracion()

**Propósito**: Consulta configuraciones con filtrado opcional por categoría.

**Parámetros**:
- `usuario_id` (int): ID del usuario consultante
- `categoria` (str, opcional): Filtrar por categoría específica

**Permisos requeridos**: `sistema.tecnico.configuracion.ver`

**Retorna**: Lista de diccionarios con configuraciones activas

**Ejemplo**:
```python
# Obtener configuraciones de seguridad
configs = ConfiguracionService.obtener_configuracion(
 usuario_id=1,
 categoria='seguridad'
)
```

#### 2. editar_configuracion()

**Propósito**: Modifica una configuración existente con creación automática de historial.

**Parámetros**:
- `usuario_id` (int): ID del usuario que edita
- `clave` (str): Clave de la configuración
- `nuevo_valor` (str): Nuevo valor a establecer
- `ip_address` (str, opcional): IP del usuario
- `user_agent` (str, opcional): User agent del navegador

**Permisos requeridos**: `sistema.tecnico.configuracion.editar`

**Transaccionalidad**: Atómica - configuración + historial en una transacción

**Retorna**: Instancia actualizada de `Configuracion`

**Ejemplo**:
```python
config = ConfiguracionService.editar_configuracion(
 usuario_id=1,
 clave='sistema.timeout_session',
 nuevo_valor='3600',
 ip_address='192.168.1.10',
 user_agent='Mozilla/5.0...'
)
```

#### 3. exportar_configuracion()

**Propósito**: Exporta todas las configuraciones activas agrupadas por categoría.

**Parámetros**:
- `usuario_id` (int): ID del usuario que exporta
- `formato` (str): Formato de exportación (actualmente solo 'json')

**Permisos requeridos**: `sistema.tecnico.configuracion.exportar`

**Retorna**: Diccionario con configuraciones agrupadas por categoría

**Ejemplo**:
```python
export_data = ConfiguracionService.exportar_configuracion(usuario_id=1)
# Resultado:
# {
# 'seguridad': [{clave: '...', valor: '...', ...}, ...],
# 'notificaciones': [{...}, ...],
# ...
# }
```

#### 4. importar_configuracion()

**Propósito**: Importa configuraciones desde JSON, creando nuevas o actualizando existentes.

**Parámetros**:
- `usuario_id` (int): ID del usuario que importa
- `configuraciones_json` (dict): Diccionario con configuraciones por categoría
- `ip_address` (str, opcional): IP del usuario
- `user_agent` (str, opcional): User agent

**Permisos requeridos**: `sistema.tecnico.configuracion.importar`

**Transaccionalidad**: Atómica - todas las importaciones en una transacción

**Retorna**: Diccionario con estadísticas:
- `importadas` (int): Configuraciones nuevas creadas
- `actualizadas` (int): Configuraciones existentes modificadas
- `errores` (int): Configuraciones con errores

**Ejemplo**:
```python
data = {
 'seguridad': [
 {
 'clave': 'sistema.max_login_attempts',
 'valor': '5',
 'tipo_dato': 'integer',
 'valor_default': '3',
 'descripcion': 'Máximo de intentos de login'
 }
 ]
}

resultado = ConfiguracionService.importar_configuracion(
 usuario_id=1,
 configuraciones_json=data
)
# {import adas': 1, 'actualizadas': 0, 'errores': 0}
```

#### 5. restaurar_configuracion()

**Propósito**: Restaura una configuración a su valor por defecto.

**Parámetros**:
- `usuario_id` (int): ID del usuario que restaura
- `clave` (str): Clave de la configuración
- `ip_address` (str, opcional): IP del usuario
- `user_agent` (str, opcional): User agent

**Permisos requeridos**: `sistema.tecnico.configuracion.restaurar`

**Retorna**: Instancia restaurada de `Configuracion`

**Ejemplo**:
```python
config = ConfiguracionService.restaurar_configuracion(
 usuario_id=1,
 clave='sistema.timeout_session'
)
# Configuración restaurada a su valor_default
```

---

## API

### Endpoints REST (DRF)

Base URL: `/api/configuration/`

#### GET /api/configuration/
**Propósito**: Lista configuraciones activas
**Parámetros query**:
- `categoria` (opcional): Filtrar por categoría

**Respuesta**:
```json
[
 {
 "id": 1,
 "categoria": "seguridad",
 "clave": "sistema.timeout_session",
 "valor": "3600",
 "tipo_dato": "integer",
 "descripcion": "Tiempo de expiración de sesión en segundos",
 "updated_at": "2025-11-09T10:30:00Z"
 }
]
```

#### PUT /api/configuration/{clave}/
**Propósito**: Edita una configuración existente
**Body**:
```json
{
 "nuevo_valor": "7200"
}
```

**Respuesta**: Configuración actualizada

#### POST /api/configuration/export/
**Propósito**: Exporta configuraciones en formato JSON
**Respuesta**: Diccionario agrupado por categorías

#### POST /api/configuration/import/
**Propósito**: Importa configuraciones desde JSON
**Body**: Diccionario con configuraciones por categoría
**Respuesta**: Estadísticas de importación

#### POST /api/configuration/{clave}/restore/
**Propósito**: Restaura configuración a valor por defecto
**Respuesta**: Configuración restaurada

---

## Decisiones de Diseño

### 1. Almacenamiento de Valores como TextField

**Decisión**: Todos los valores se almacenan como `TextField` independientemente del tipo de dato.

**Motivación**:
- Flexibilidad para almacenar cualquier tipo de valor (strings largos, JSON, URLs)
- Conversión on-the-fly mediante `get_valor_typed()`
- Evita complejidad de múltiples columnas por tipo

**Trade-offs**:
- **Pros**: Simple, flexible, fácil de mantener
- **Cons**: No hay validación a nivel DB, requiere conversión en aplicación

### 2. Historial Inmutable

**Decisión**: ConfiguracionHistorial es append-only (nunca se modifica/elimina).

**Motivación**:
- Auditoría completa - trazabilidad regulatoria
- Compliance con ISO 27001
- Debugging - capacidad de ver estado histórico

**Implementación**:
- No DELETE permitido en ConfiguracionHistorial
- Relación CASCADE desde Configuracion solo para integridad referencial
- Desnormalización de `clave` para queries históricas eficientes

### 3. Soft Delete en Configuraciones

**Decisión**: Campo `activa` en lugar de borrado físico.

**Motivación**:
- Preservar historial completo
- Posibilidad de reactivar configuraciones
- Integridad referencial con ConfiguracionHistorial

### 4. Categorización de Configuraciones

**Decisión**: 8 categorías predefinidas (general, seguridad, notificaciones, etc.).

**Motivación**:
- Organización lógica para usuarios
- Facilita descubrimiento de configuraciones relacionadas
- Permite permisos granulares por categoría en el futuro

**Categorías disponibles**:
- `general`: Configuraciones generales del sistema
- `seguridad`: Parámetros de seguridad y autenticación
- `notificaciones`: Configuración de mensajes internos
- `integraciones`: Conexiones con sistemas externos
- `llamadas`: Parámetros del subsistema de llamadas
- `tickets`: Configuración del sistema de tickets
- `reportes`: Parámetros de generación de reportes
- `sistema`: Configuraciones técnicas de bajo nivel

### 5. Auditoría Metadata (IP + User Agent)

**Decisión**: Capturar IP y User Agent en cada modificación.

**Motivación**:
- Compliance regulatorio (ISO 27001, GDPR)
- Investigación de incidentes de seguridad
- Detección de accesos no autorizados

**Implementación**: Opcional en service layer, capturado desde request en API views

---

## Seguridad

### Permisos Granulares

El sistema de configuración utiliza capacidades granulares del módulo `users.models_permisos_granular`:

| Capacidad | Acción | Descripción |
|-----------|--------|-------------|
| `sistema.tecnico.configuracion.ver` | READ | Ver configuraciones |
| `sistema.tecnico.configuracion.editar` | UPDATE | Modificar valores |
| `sistema.tecnico.configuracion.exportar` | EXPORT | Exportar configuraciones |
| `sistema.tecnico.configuracion.importar` | IMPORT | Importar configuraciones masivamente |
| `sistema.tecnico.configuracion.restaurar` | RESTORE | Restaurar a valores por defecto |

### Auditoría Automática

Cada operación genera dos tipos de auditoría:

1. **Auditoría de permisos** (AuditoriaPermiso):
 - Usuario, capacidad, recurso, acción, timestamp
 - Generada automáticamente por `verificar_permiso_y_auditar()`

2. **Auditoría de cambios** (ConfiguracionHistorial):
 - Cambio específico: valor_anterior → valor_nuevo
 - Metadata: usuario, IP, user agent, timestamp

### Validaciones

1. **Existencia de configuración**: ValidationError si clave no existe
2. **Permisos**: PermissionDenied si usuario no autorizado
3. **Tipos de datos**: Conversión segura en `get_valor_typed()`
4. **Transaccionalidad**: Cambios atómicos (configuración + historial)

---

## Integración

### Uso desde Otras Apps

```python
from callcentersite.apps.configuration.services import ConfiguracionService

# Obtener configuración tipada
configs = ConfiguracionService.obtener_configuracion(
 usuario_id=user.id,
 categoria='seguridad'
)

timeout_config = next(c for c in configs if c['clave'] == 'sistema.timeout_session')
timeout_valor = Configuracion.objects.get(id=timeout_config['id']).get_valor_typed()
# timeout_valor ahora es int
```

### Management Commands

**seed_configuraciones_default**: Popula configuraciones iniciales del sistema.

```bash
python manage.py seed_configuraciones_default
```

Ubicación: `configuration/management/commands/seed_configuraciones_default.py`

### Admin Django

Interfaz administrativa completa en Django Admin:
- Vista de lista con filtros por categoría y activa
- Edición inline de configuraciones
- Visualización de historial en configuración detail view

---

## Referencias

- **Implementación completa**: docs/PLAN_MAESTRO_PRIORIDAD_02.md (Tareas 33-41)
- **Permisos granulares**: docs/backend/arquitectura/users.md
- **Auditoría**: docs/backend/arquitectura/audit.md
- **Código fuente**: `api/callcentersite/callcentersite/apps/configuration/`

---

## Changelog

### v1.0.0 (2025-11-09)
- Implementación inicial con modelos, servicios y API
- Sistema de permisos granulares integrado
- Historial inmutable de cambios
- Import/Export de configuraciones
- Restauración a valores por defecto
- Management command para seed de datos

---

**Última actualización**: 2025-11-09
**Mantenedor**: Backend Team
**Estado de documentación**: Completo
