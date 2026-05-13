---
id: DOC-CMD-001
tipo: documentacion_tecnica
nombre: Management Commands para Sistema de Permisos
version: 1.0.0
fecha: 2025-01-09
autor: Sistema
estado: aprobado
---

# Management Commands - Sistema de Permisos Granulares

## Resumen

Este documento describe los management commands disponibles para inicializar y gestionar el sistema de permisos granulares.

## Commands Disponibles

### 1. `seed_permisos_base`

**Propósito**: Crea funciones y capacidades base del sistema.

**Uso**:
```bash
# Crear capacidades (idempotente)
python manage.py seed_permisos_base

# Eliminar y recrear
python manage.py seed_permisos_base --reset
```

**Qué crea**:
- **10 Funciones** agrupadas por dominio:
 - `vistas.dashboards`
 - `vistas.reportes`
 - `vistas.calidad`
 - `vistas.equipos`
 - `vistas.analisis`
 - `administracion.usuarios`
 - `administracion.grupos`
 - `administracion.permisos`
 - `administracion.auditoria`
 - `administracion.configuracion`

- **~32 Capacidades** con formato `sistema.dominio.funcion.accion`:
 - `sistema.vistas.dashboards.ver`
 - `sistema.vistas.reportes.crear`
 - `sistema.administracion.usuarios.editar`
 - etc.

**Características**:
- Idempotente: Se puede ejecutar múltiples veces sin duplicar
- Asocia automáticamente capacidades a funciones
- Valida datos antes de insertar

---

### 2. `seed_grupos_default`

**Propósito**: Crea grupos de permisos por defecto con capacidades asignadas.

**Uso**:
```bash
# Crear grupos (idempotente)
python manage.py seed_grupos_default

# Eliminar y recrear
python manage.py seed_grupos_default --reset
```

**Qué crea**:

#### Grupo: Agentes Nivel 1 (`agentes_nivel_1`)
**Descripción**: Permisos básicos de visualización

**Capacidades** (2):
- `sistema.vistas.dashboards.ver`
- `sistema.vistas.reportes.ver`

**Casos de uso**: Agentes de atención al cliente con permisos mínimos

---

#### Grupo: Agentes Nivel 2 (`agentes_nivel_2`)
**Descripción**: Permisos ampliados para agentes experimentados

**Capacidades** (5):
- Todo lo de Nivel 1, más:
- `sistema.vistas.reportes.crear`
- `sistema.vistas.reportes.exportar`
- `sistema.vistas.analisis.ver`

**Casos de uso**: Agentes senior que crean reportes

---

#### Grupo: Coordinadores (`coordinadores`)
**Descripción**: Gestión de equipos, calidad y reportes completos

**Capacidades** (14+):
- **Dashboards completos**: ver, editar, compartir
- **Reportes completos**: ver, crear, editar, eliminar, exportar
- **Calidad**: ver, evaluar, aprobar
- **Equipos**: ver, gestionar
- **Análisis**: ver, avanzados

**Casos de uso**: Supervisores y coordinadores de equipos

---

#### Grupo: Administradores (`administradores`)
**Descripción**: Acceso completo al sistema

**Capacidades**: **TODAS** (~32)

**Casos de uso**: Administradores del sistema

---

### 3. `seed_usuarios_demo`

**Propósito**: Crea usuarios de demostración con grupos asignados.

**Uso**:
```bash
# Crear usuarios demo (password por defecto: demo123456)
python manage.py seed_usuarios_demo

# Con password personalizado
python manage.py seed_usuarios_demo --password "mipassword123"

# Eliminar y recrear
python manage.py seed_usuarios_demo --reset
```

**Qué crea**:

| Usuario | Email | Grupo | Descripción |
|---------|-------|-------|-------------|
| `admin_demo` | admin@demo.com | Administradores | Admin completo del sistema |
| `coord1_demo` | coord1@demo.com | Coordinadores | Coordinador de equipo |
| `agente1_demo` | agente1@demo.com | Agentes Nivel 1 | Agente básico |
| `agente2_demo` | agente2@demo.com | Agentes Nivel 2 | Agente senior |
| `analista1_demo` | analista1@demo.com | Coordinadores | Analista de calidad |

**Credenciales por defecto**:
- Username: Ver tabla arriba
- Password: `demo123456` (configurable con `--password`)

---

### 4. `seed_permisos_completo` **RECOMENDADO**

**Propósito**: Ejecuta todos los seeders anteriores en orden correcto.

**Uso**:
```bash
# Inicialización completa (permisos + grupos + usuarios)
python manage.py seed_permisos_completo

# Con password personalizado
python manage.py seed_permisos_completo --password "mypass123"

# Solo permisos y grupos (sin usuarios)
python manage.py seed_permisos_completo --skip-usuarios

# Eliminar todo y recrear
python manage.py seed_permisos_completo --reset
```

**Flujo de ejecución**:
```
1. seed_permisos_base
 ↓
2. seed_grupos_default
 ↓
3. seed_usuarios_demo (opcional)
 ↓
4. Resumen y próximos pasos
```

**Output esperado**:
```
================================================================
 SEEDING COMPLETO - SISTEMA DE PERMISOS GRANULARES
================================================================

[1/3] Creando funciones y capacidades base...
 + Función creada: vistas.dashboards
 + Función creada: vistas.reportes
 ...
 + Capacidad creada: sistema.vistas.dashboards.ver
 ...

[OK] Seeding completado:
 - Funciones: 10
 - Capacidades: 32

[2/3] Creando grupos de permisos por defecto...
 + Grupo creado: Agentes Nivel 1 (2 capacidades)
 + Grupo creado: Agentes Nivel 2 (5 capacidades)
 + Grupo creado: Coordinadores (14 capacidades)
 + Grupo creado: Administradores (32 capacidades - TODAS)

[OK] Grupos creados: 4

[3/3] Creando usuarios de demostración...
 + Usuario creado: admin_demo
 → Asignado al grupo: Administradores
 ...

[OK] Usuarios demo creados: 5

================================================================
 [OK] SEEDING COMPLETADO EXITOSAMENTE
================================================================
```

---

## Guía Rápida de Inicio

### Para Desarrollo Local

```bash
# 1. Aplicar migraciones
python manage.py migrate

# 2. Inicializar permisos completo
python manage.py seed_permisos_completo

# 3. Verificar datos
python manage.py shell
>>> from callcentersite.apps.users.models_permisos_granular import *
>>> GrupoPermiso.objects.count()
4
>>> Capacidad.objects.count()
32
>>> from django.contrib.auth import get_user_model
>>> get_user_model().objects.filter(username__contains='demo').count()
5

# 4. Probar login
curl -X POST http://localhost:8000/api/auth/login/ \
 -H "Content-Type: application/json" \
 -d '{"username":"admin_demo","password":"demo123456"}'

# 5. Probar verificación de permisos
curl -H "Authorization: Bearer <token>" \
 http://localhost:8000/api/permisos/verificar/1/capacidades/
```

---

### Para Testing / CI

```bash
# Setup rápido sin usuarios (solo estructura)
python manage.py seed_permisos_completo --skip-usuarios

# En tests, crear usuarios específicos según necesites
```

---

### Para Staging / Production

```bash
# 1. Solo crear estructura base (sin usuarios demo)
python manage.py seed_permisos_base
python manage.py seed_grupos_default

# 2. Crear usuarios reales mediante Admin UI o API
# NO ejecutar seed_usuarios_demo en producción

# 3. Verificar
python manage.py shell
>>> from callcentersite.apps.users.models_permisos_granular import *
>>> GrupoPermiso.objects.all().values('codigo', 'nombre')
```

---

## Personalización

### Agregar Capacidades Personalizadas

Después de ejecutar el seeding base, puedes agregar capacidades custom:

```python
# En Django shell o script
from callcentersite.apps.users.models_permisos_granular import Capacidad, Funcion

# Crear capacidad custom
funcion = Funcion.objects.get(codigo='vistas.reportes')
capacidad = Capacidad.objects.create(
 codigo='sistema.vistas.reportes.aprobar',
 nombre='Aprobar Reportes',
 descripcion='Capacidad para aprobar reportes antes de publicar',
 activa=True,
)
funcion.capacidades.add(capacidad)
```

### Agregar Grupos Personalizados

```python
from callcentersite.apps.users.models_permisos_granular import GrupoPermiso, Capacidad

# Crear grupo custom
grupo = GrupoPermiso.objects.create(
 codigo='supervisores_financieros',
 nombre='Supervisores Financieros',
 descripcion='Supervisores del área financiera',
 activo=True,
)

# Asignar capacidades
capacidades = Capacidad.objects.filter(
 codigo__in=[
 'sistema.vistas.reportes.ver',
 'sistema.vistas.reportes.exportar',
 'sistema.vistas.analisis.avanzados',
 ]
)
grupo.capacidades.set(capacidades)
```

---

## Troubleshooting

### Error: "Función no encontrada"

**Causa**: Intentas crear capacidades antes de funciones.

**Solución**:
```bash
# Ejecutar en orden correcto
python manage.py seed_permisos_base
python manage.py seed_grupos_default
```

---

### Error: "Grupo no encontrado"

**Causa**: Intentas crear usuarios antes de grupos.

**Solución**:
```bash
# Usar command completo que ejecuta en orden
python manage.py seed_permisos_completo --reset
```

---

### Error: Datos duplicados

**Causa**: Ejecutaste seeding múltiples veces sin `--reset`.

**Solución**:
Los commands son idempotentes, pero si quieres limpiar:
```bash
python manage.py seed_permisos_completo --reset
```

---

### Resetear solo usuarios demo

```bash
python manage.py seed_usuarios_demo --reset
```

---

## Scripts de Utilidad

### Verificar Permisos de un Usuario

```python
# management/commands/verificar_permisos_usuario.py
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from callcentersite.apps.users.services_permisos_granular import UserManagementService

class Command(BaseCommand):
 def add_arguments(self, parser):
 parser.add_argument('username', type=str)

 def handle(self, *args, **options):
 User = get_user_model()
 user = User.objects.get(username=options['username'])

 grupos = UserManagementService.obtener_grupos_usuario(user.id)
 self.stdout.write(f"\nGrupos de {user.username}:")
 for grupo in grupos:
 self.stdout.write(f" - {grupo['codigo']}: {grupo['nombre']}")

 # Verificar algunas capacidades
 capacidades_test = [
 'sistema.vistas.dashboards.ver',
 'sistema.vistas.reportes.crear',
 'sistema.administracion.usuarios.editar',
 ]

 self.stdout.write(f"\nCapacidades:")
 for cap in capacidades_test:
 tiene = UserManagementService.verificar_permiso(user.id, cap)
 symbol = "[OK]" if tiene else "[FAIL]"
 self.stdout.write(f" {symbol} {cap}")

# Uso:
# python manage.py verificar_permisos_usuario admin_demo
```

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0.0 | 2025-01-09 | Creación inicial con 4 commands |

---

## Referencias

- [Sistema de Permisos Granulares](./arquitectura/permisos-granular.md)
- [Casos de Uso](../casos_de_uso/)
- [API Documentation](../api/openapi_permisos.yaml)
