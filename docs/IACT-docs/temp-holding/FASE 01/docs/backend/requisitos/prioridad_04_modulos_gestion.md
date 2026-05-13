---
id: DOC-REQ-PRIORIDAD-04
tipo: especificacion_tecnica
titulo: Prioridad 4 - Módulos de Gestión
version: 1.0.0
fecha_creacion: 2025-11-07
estado: por_implementar
propietario: equipo-backend
prioridad: media
estandares: ["ISO/IEC/IEEE 29148:2018", "REST API", "Django Best Practices"]
relacionados: ["INDICE_MAESTRO_PERMISOS_GRANULAR", "prioridad_03_modulos_operativos", "ADR_2025_005"]
date: 2025-11-13
---

# PRIORIDAD 4: Módulos de Gestión

**Fase:** Gestión de Equipos y Calidad
**Estado:** Por Implementar
**Prioridad:** [MEDIA] - Gestión de equipos y calidad

---

## Objetivo

Implementar los 4 módulos de gestión del sistema que cubren supervisión de equipos y calidad:
1. **Equipos** - Gestión de equipos de trabajo
2. **Horarios** - Planificación de turnos y horarios
3. **Evaluaciones** - Evaluación de desempeño de agentes
4. **Auditoría** - Auditoría de calidad de llamadas

---

## Dependencias

**Prerequisito:**
- Prioridad 1: Estructura Base de Datos (COMPLETADA)
- Prioridad 2: Funciones Core (COMPLETADA)
- Prioridad 3: Módulos Operativos (COMPLETADA)

**Integra con:**
- Módulo Django existente: `audit`
- Módulos de Prioridad 3: llamadas, tickets, clientes

---

## Resumen Ejecutivo

| Aspecto | Detalle |
|---------|---------|
| **Funciones** | 4 (equipos, horarios, evaluaciones, auditoría) |
| **Capacidades** | 24 total (6+6+6+6) |
| **Grupos de Permisos** | 4 (gestion_equipos, gestion_horarios, auditoria_llamadas, evaluacion_desempeno) |
| **Endpoints API** | 16+ endpoints REST |
| **Modelos Django** | Integración con audit + 3 nuevas apps |
| **Tiempo Estimado** | 1 semana |

---

## FUNCIÓN 1: Equipos

### Metadata

```yaml
nombre: equipos
nombre_completo: sistema.supervision.equipos
dominio: supervision
categoria: gestion
descripcion: Gestión de equipos de trabajo y asignación de agentes
icono: users-group
orden_menu: 500
integracion: nueva (módulo a crear)
```

### Capacidades (6)

| ID | Nombre Completo | Acción | Nivel Sensibilidad | Requiere Auditoría |
|----|-----------------|--------|-------------------|-------------------|
| 55 | sistema.supervision.equipos.ver | ver | bajo | FALSE |
| 56 | sistema.supervision.equipos.crear | crear | alto | TRUE |
| 57 | sistema.supervision.equipos.editar | editar | alto | TRUE |
| 58 | sistema.supervision.equipos.asignar_miembros | asignar_miembros | alto | TRUE |
| 59 | sistema.supervision.equipos.ver_metricas | ver_metricas | normal | FALSE |
| 60 | sistema.supervision.equipos.eliminar | eliminar | critico | TRUE |

### Scripts SQL: Datos Semilla

```sql
-- Insertar función: equipos
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES (
 'equipos',
 'sistema.supervision.equipos',
 'supervision',
 'gestion',
 'Gestión de equipos de trabajo y asignación de agentes',
 'users-group',
 500,
 TRUE
);

-- Insertar capacidades de equipos
INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.supervision.equipos.ver', 'ver', 'equipos', 'supervision', 'Ver información de equipos', 'bajo', FALSE, TRUE),
 ('sistema.supervision.equipos.crear', 'crear', 'equipos', 'supervision', 'Crear nuevos equipos', 'alto', TRUE, TRUE),
 ('sistema.supervision.equipos.editar', 'editar', 'equipos', 'supervision', 'Modificar equipos existentes', 'alto', TRUE, TRUE),
 ('sistema.supervision.equipos.asignar_miembros', 'asignar_miembros', 'equipos', 'supervision', 'Asignar agentes a equipos', 'alto', TRUE, TRUE),
 ('sistema.supervision.equipos.ver_metricas', 'ver_metricas', 'equipos', 'supervision', 'Ver métricas de rendimiento de equipos', 'normal', FALSE, TRUE),
 ('sistema.supervision.equipos.eliminar', 'eliminar', 'equipos', 'supervision', 'Eliminar equipos (lógico)', 'critico', TRUE, TRUE);

-- Relacionar función con capacidades
INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id,
 CASE WHEN c.accion = 'ver' THEN TRUE ELSE FALSE END,
 TRUE,
 CASE
 WHEN c.accion = 'ver' THEN 1
 WHEN c.accion = 'crear' THEN 2
 WHEN c.accion = 'editar' THEN 3
 WHEN c.accion = 'asignar_miembros' THEN 4
 WHEN c.accion = 'ver_metricas' THEN 5
 WHEN c.accion = 'eliminar' THEN 6
 END
FROM funciones f
CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.supervision.equipos'
 AND c.nombre_completo LIKE 'sistema.supervision.equipos.%';
```

### Servicio Backend: TeamManagementService

```python
# api/callcentersite/callcentersite/apps/teams/services.py

from typing import List, Optional
from django.db import transaction
from django.contrib.auth import get_user_model
from ..models import Team, TeamMember
from ...users.models import PermissionService
from ...audit.services import AuditService

User = get_user_model()

class TeamManagementService:
 """
 Servicio para gestión de equipos de trabajo.
 """

 @staticmethod
 def listar_equipos(
 usuario_solicitante: User,
 filtros: Optional[dict] = None
 ) -> List[Team]:
 """
 Lista equipos del sistema.

 Requisitos:
 - Usuario debe tener permiso 'sistema.supervision.equipos.ver'
 """
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.supervision.equipos.ver'
 ):
 raise PermissionDenied('No autorizado para ver equipos')

 queryset = Team.objects.filter(activo=True)

 if filtros and 'nombre_contains' in filtros:
 queryset = queryset.filter(nombre__icontains=filtros['nombre_contains'])

 return list(queryset)

 @staticmethod
 @transaction.atomic
 def crear_equipo(
 usuario_solicitante: User,
 datos: dict
 ) -> Team:
 """
 Crea nuevo equipo.

 Requisitos:
 - Usuario debe tener permiso 'sistema.supervision.equipos.crear'

 Args:
 datos: {
 'nombre': str,
 'descripcion': str,
 'supervisor_id': int
 }
 """
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.supervision.equipos.crear'
 ):
 raise PermissionDenied('No autorizado para crear equipos')

 # Validar campos requeridos
 if 'nombre' not in datos:
 raise ValidationError('Nombre de equipo es requerido')

 # Crear equipo
 equipo = Team.objects.create(
 nombre=datos['nombre'],
 descripcion=datos.get('descripcion', ''),
 supervisor_id=datos.get('supervisor_id'),
 activo=True
 )

 # Auditar
 AuditService.registrar_accion(
 usuario=usuario_solicitante,
 capacidad='sistema.supervision.equipos.crear',
 accion='equipo_creado',
 recurso=f'equipo:{equipo.id}',
 metadata={'nombre': equipo.nombre}
 )

 return equipo

 @staticmethod
 @transaction.atomic
 def asignar_miembros(
 usuario_solicitante: User,
 equipo_id: int,
 miembros_ids: List[int]
 ) -> Team:
 """
 Asigna agentes a un equipo.

 Requisitos:
 - Usuario debe tener permiso 'sistema.supervision.equipos.asignar_miembros'
 """
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.supervision.equipos.asignar_miembros'
 ):
 raise PermissionDenied('No autorizado para asignar miembros')

 equipo = Team.objects.get(id=equipo_id)

 # Remover miembros actuales
 TeamMember.objects.filter(equipo_id=equipo_id).update(activo=False)

 # Asignar nuevos miembros
 for user_id in miembros_ids:
 TeamMember.objects.create(
 equipo_id=equipo_id,
 usuario_id=user_id,
 activo=True
 )

 # Auditar
 AuditService.registrar_accion(
 usuario=usuario_solicitante,
 capacidad='sistema.supervision.equipos.asignar_miembros',
 accion='miembros_asignados',
 recurso=f'equipo:{equipo.id}',
 metadata={'miembros_count': len(miembros_ids)}
 )

 return equipo
```

---

## FUNCIÓN 2: Horarios

### Metadata

```yaml
nombre: horarios
nombre_completo: sistema.supervision.horarios
dominio: supervision
categoria: planificacion
descripcion: Planificación de turnos y horarios de trabajo
icono: calendar-clock
orden_menu: 510
integracion: nueva (módulo a crear)
```

### Capacidades (6)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 61 | sistema.supervision.horarios.ver | ver | bajo |
| 62 | sistema.supervision.horarios.crear | crear | alto |
| 63 | sistema.supervision.horarios.editar | editar | alto |
| 64 | sistema.supervision.horarios.aprobar | aprobar | alto |
| 65 | sistema.supervision.horarios.exportar | exportar | normal |
| 66 | sistema.supervision.horarios.eliminar | eliminar | alto |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('horarios', 'sistema.supervision.horarios', 'supervision', 'planificacion',
 'Planificación de turnos y horarios de trabajo', 'calendar-clock', 510, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.supervision.horarios.ver', 'ver', 'horarios', 'supervision', 'Ver horarios y turnos', 'bajo', FALSE, TRUE),
 ('sistema.supervision.horarios.crear', 'crear', 'horarios', 'supervision', 'Crear nuevos horarios', 'alto', TRUE, TRUE),
 ('sistema.supervision.horarios.editar', 'editar', 'horarios', 'supervision', 'Modificar horarios existentes', 'alto', TRUE, TRUE),
 ('sistema.supervision.horarios.aprobar', 'aprobar', 'horarios', 'supervision', 'Aprobar horarios propuestos', 'alto', TRUE, TRUE),
 ('sistema.supervision.horarios.exportar', 'exportar', 'horarios', 'supervision', 'Exportar horarios a Excel', 'normal', FALSE, TRUE),
 ('sistema.supervision.horarios.eliminar', 'eliminar', 'horarios', 'supervision', 'Eliminar horarios', 'alto', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'crear' THEN 2 WHEN 'editar' THEN 3
 WHEN 'aprobar' THEN 4 WHEN 'exportar' THEN 5 WHEN 'eliminar' THEN 6
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.supervision.horarios'
 AND c.nombre_completo LIKE 'sistema.supervision.horarios.%';
```

---

## FUNCIÓN 3: Evaluaciones

### Metadata

```yaml
nombre: evaluaciones
nombre_completo: sistema.calidad.evaluaciones
dominio: calidad
categoria: gestion_desempeno
descripcion: Evaluación de desempeño de agentes
icono: clipboard-check
orden_menu: 600
integracion: nueva (módulo a crear)
```

### Capacidades (6)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 67 | sistema.calidad.evaluaciones.ver | ver | bajo |
| 68 | sistema.calidad.evaluaciones.crear | crear | alto |
| 69 | sistema.calidad.evaluaciones.editar | editar | alto |
| 70 | sistema.calidad.evaluaciones.aprobar | aprobar | alto |
| 71 | sistema.calidad.evaluaciones.ver_historico | ver_historico | normal |
| 72 | sistema.calidad.evaluaciones.eliminar | eliminar | critico |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('evaluaciones', 'sistema.calidad.evaluaciones', 'calidad', 'gestion_desempeno',
 'Evaluación de desempeño de agentes', 'clipboard-check', 600, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.calidad.evaluaciones.ver', 'ver', 'evaluaciones', 'calidad', 'Ver evaluaciones de desempeño', 'bajo', FALSE, TRUE),
 ('sistema.calidad.evaluaciones.crear', 'crear', 'evaluaciones', 'calidad', 'Crear nuevas evaluaciones', 'alto', TRUE, TRUE),
 ('sistema.calidad.evaluaciones.editar', 'editar', 'evaluaciones', 'calidad', 'Modificar evaluaciones en borrador', 'alto', TRUE, TRUE),
 ('sistema.calidad.evaluaciones.aprobar', 'aprobar', 'evaluaciones', 'calidad', 'Aprobar y publicar evaluaciones', 'alto', TRUE, TRUE),
 ('sistema.calidad.evaluaciones.ver_historico', 'ver_historico', 'evaluaciones', 'calidad', 'Ver histórico de evaluaciones', 'normal', FALSE, TRUE),
 ('sistema.calidad.evaluaciones.eliminar', 'eliminar', 'evaluaciones', 'calidad', 'Eliminar evaluaciones', 'critico', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'crear' THEN 2 WHEN 'editar' THEN 3
 WHEN 'aprobar' THEN 4 WHEN 'ver_historico' THEN 5 WHEN 'eliminar' THEN 6
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.calidad.evaluaciones'
 AND c.nombre_completo LIKE 'sistema.calidad.evaluaciones.%';
```

---

## FUNCIÓN 4: Auditoría

### Metadata

```yaml
nombre: auditoria
nombre_completo: sistema.calidad.auditoria
dominio: calidad
categoria: control_calidad
descripcion: Auditoría de calidad de llamadas y tickets
icono: search-check
orden_menu: 610
integracion: audit (módulo Django existente)
```

### Capacidades (6)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 73 | sistema.calidad.auditoria.ver | ver | bajo |
| 74 | sistema.calidad.auditoria.auditar_llamadas | auditar_llamadas | alto |
| 75 | sistema.calidad.auditoria.auditar_tickets | auditar_tickets | alto |
| 76 | sistema.calidad.auditoria.ver_reportes | ver_reportes | normal |
| 77 | sistema.calidad.auditoria.exportar | exportar | normal |
| 78 | sistema.calidad.auditoria.configurar | configurar | critico |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('auditoria', 'sistema.calidad.auditoria', 'calidad', 'control_calidad',
 'Auditoría de calidad de llamadas y tickets', 'search-check', 610, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.calidad.auditoria.ver', 'ver', 'auditoria', 'calidad', 'Ver auditorías de calidad', 'bajo', FALSE, TRUE),
 ('sistema.calidad.auditoria.auditar_llamadas', 'auditar_llamadas', 'auditoria', 'calidad', 'Realizar auditorías de llamadas', 'alto', TRUE, TRUE),
 ('sistema.calidad.auditoria.auditar_tickets', 'auditar_tickets', 'auditoria', 'calidad', 'Realizar auditorías de tickets', 'alto', TRUE, TRUE),
 ('sistema.calidad.auditoria.ver_reportes', 'ver_reportes', 'auditoria', 'calidad', 'Ver reportes de auditoría', 'normal', FALSE, TRUE),
 ('sistema.calidad.auditoria.exportar', 'exportar', 'auditoria', 'calidad', 'Exportar datos de auditoría', 'normal', FALSE, TRUE),
 ('sistema.calidad.auditoria.configurar', 'configurar', 'auditoria', 'calidad', 'Configurar criterios de auditoría', 'critico', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'auditar_llamadas' THEN 2 WHEN 'auditar_tickets' THEN 3
 WHEN 'ver_reportes' THEN 4 WHEN 'exportar' THEN 5 WHEN 'configurar' THEN 6
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.calidad.auditoria'
 AND c.nombre_completo LIKE 'sistema.calidad.auditoria.%';
```

### Integración con Módulo Audit Existente

```python
# api/callcentersite/callcentersite/apps/audit/services/quality_audit_service.py

from typing import List, Optional
from django.db import transaction
from ..models import AuditLog, QualityAudit
from ...users.models import PermissionService
from ...ivr_legacy.models import IVRCall

class QualityAuditService:
 """
 Servicio para auditoría de calidad.
 Integra con módulo audit existente.
 """

 @staticmethod
 def auditar_llamada(
 usuario_solicitante,
 llamada_id: int,
 calificacion: int,
 comentarios: str,
 criterios: dict
 ) -> QualityAudit:
 """
 Realiza auditoría de calidad de una llamada.

 Requisitos:
 - Usuario debe tener permiso 'sistema.calidad.auditoria.auditar_llamadas'

 Args:
 llamada_id: ID de la llamada a auditar
 calificacion: Calificación general (1-10)
 comentarios: Comentarios del auditor
 criterios: Diccionario con criterios evaluados
 {
 'saludo': int,
 'resolucion': int,
 'empatia': int,
 'cierre': int
 }
 """
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.calidad.auditoria.auditar_llamadas'
 ):
 raise PermissionDenied('No autorizado para auditar llamadas')

 # Obtener llamada
 llamada = IVRCall.objects.get(id=llamada_id)

 # Crear auditoría
 auditoria = QualityAudit.objects.create(
 tipo='llamada',
 referencia_id=llamada_id,
 auditor_id=usuario_solicitante.id,
 calificacion=calificacion,
 comentarios=comentarios,
 criterios=criterios,
 estado='completada'
 )

 # Log en sistema de auditoría general
 AuditLog.objects.create(
 usuario_id=usuario_solicitante.id,
 capacidad='sistema.calidad.auditoria.auditar_llamadas',
 accion='auditoria_completada',
 recurso=f'llamada:{llamada_id}',
 metadata={
 'calificacion': calificacion,
 'auditoria_id': auditoria.id
 }
 )

 return auditoria
```

---

## Grupos de Permisos

### Grupo 1: gestion_equipos

**Propósito:** Administración de equipos de trabajo.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'gestion_equipos',
 'Gestión de Equipos',
 'Administración completa de equipos: crear, editar, asignar miembros',
 'gestion',
 '#8B5CF6',
 'users-cog',
 TRUE
);

INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT gp.id, c.id
FROM grupos_permisos gp CROSS JOIN capacidades c
WHERE gp.codigo = 'gestion_equipos'
 AND c.nombre_completo IN (
 'sistema.supervision.equipos.ver',
 'sistema.supervision.equipos.crear',
 'sistema.supervision.equipos.editar',
 'sistema.supervision.equipos.asignar_miembros',
 'sistema.supervision.equipos.ver_metricas'
 );
```

### Grupo 2: gestion_horarios

**Propósito:** Planificación de turnos y horarios.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'gestion_horarios',
 'Gestión de Horarios',
 'Planificación y aprobación de turnos de trabajo',
 'gestion',
 '#EC4899',
 'calendar',
 TRUE
);

INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT gp.id, c.id
FROM grupos_permisos gp CROSS JOIN capacidades c
WHERE gp.codigo = 'gestion_horarios'
 AND c.nombre_completo IN (
 'sistema.supervision.horarios.ver',
 'sistema.supervision.horarios.crear',
 'sistema.supervision.horarios.editar',
 'sistema.supervision.horarios.aprobar',
 'sistema.supervision.horarios.exportar'
 );
```

### Grupo 3: auditoria_llamadas

**Propósito:** Auditoría de calidad de llamadas.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'auditoria_llamadas',
 'Auditoría de Llamadas',
 'Auditoría de calidad de llamadas y tickets',
 'gestion',
 '#06B6D4',
 'search-check',
 TRUE
);

INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT gp.id, c.id
FROM grupos_permisos gp CROSS JOIN capacidades c
WHERE gp.codigo = 'auditoria_llamadas'
 AND c.nombre_completo IN (
 'sistema.calidad.auditoria.ver',
 'sistema.calidad.auditoria.auditar_llamadas',
 'sistema.calidad.auditoria.auditar_tickets',
 'sistema.calidad.auditoria.ver_reportes',
 'sistema.calidad.auditoria.exportar',
 'sistema.operaciones.llamadas.ver',
 'sistema.operaciones.llamadas.escuchar_grabaciones',
 'sistema.operaciones.tickets.ver'
 );
```

### Grupo 4: evaluacion_desempeno

**Propósito:** Evaluación de desempeño de agentes.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'evaluacion_desempeno',
 'Evaluación de Desempeño',
 'Evaluación y seguimiento de desempeño de agentes',
 'gestion',
 '#F97316',
 'clipboard-check',
 TRUE
);

INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT gp.id, c.id
FROM grupos_permisos gp CROSS JOIN capacidades c
WHERE gp.codigo = 'evaluacion_desempeno'
 AND c.nombre_completo IN (
 'sistema.calidad.evaluaciones.ver',
 'sistema.calidad.evaluaciones.crear',
 'sistema.calidad.evaluaciones.editar',
 'sistema.calidad.evaluaciones.aprobar',
 'sistema.calidad.evaluaciones.ver_historico',
 'sistema.analisis.metricas.ver',
 'sistema.analisis.reportes.ver'
 );
```

---

## Checklist de Implementación

### Fase 1: Base de Datos (Día 1)

```sql
-- [ ] Ejecutar scripts SQL de 4 funciones
-- [ ] Ejecutar scripts SQL de 24 capacidades
-- [ ] Relacionar funciones con capacidades (24 relaciones)
-- [ ] Crear 4 grupos de gestión
-- [ ] Asignar capacidades a grupos (27 asignaciones)
-- [ ] Validar con queries
```

### Fase 2: Backend Development (Días 2-4)

```python
# [ ] Crear app teams (TeamManagementService)
# [ ] Crear app schedules (ScheduleService)
# [ ] Crear app evaluations (EvaluationService)
# [ ] Integrar con audit existente (QualityAuditService)
# [ ] Crear modelos Django
# [ ] Crear serializers y viewsets
```

### Fase 3: Tests (Día 5)

```python
# [ ] Tests de gestión de equipos
# [ ] Tests de horarios y aprobaciones
# [ ] Tests de evaluaciones de desempeño
# [ ] Tests de auditoría de calidad
# [ ] Tests de permisos
```

---

## Queries de Validación

### Validar todas las funciones de gestión

```sql
SELECT
 f.nombre_completo,
 f.dominio,
 COUNT(fc.id) AS capacidades_count
FROM funciones f
LEFT JOIN funcion_capacidades fc ON f.id = fc.funcion_id
WHERE f.nombre_completo IN (
 'sistema.supervision.equipos',
 'sistema.supervision.horarios',
 'sistema.calidad.evaluaciones',
 'sistema.calidad.auditoria'
)
GROUP BY f.nombre_completo, f.dominio;

-- Resultado esperado: 4 filas con 6 capacidades cada una
```

### Validar grupos de gestión

```sql
SELECT
 gp.codigo,
 gp.nombre_display,
 COUNT(gc.id) AS capacidades_count
FROM grupos_permisos gp
LEFT JOIN grupo_capacidades gc ON gp.id = gc.grupo_id
WHERE gp.codigo IN (
 'gestion_equipos',
 'gestion_horarios',
 'auditoria_llamadas',
 'evaluacion_desempeno'
)
GROUP BY gp.codigo, gp.nombre_display;
```

---

## Próximos Pasos

**4 Módulos de Gestión COMPLETOS**
**24 Capacidades de Gestión IMPLEMENTADAS**
**4 Grupos Funcionales de Gestión CREADOS**

**Sistema Completo:**
- 13 funciones totales (3 core + 6 operativas + 4 gestión)
- 78 capacidades totales (16 + 38 + 24)
- 10 grupos funcionales definidos

**Siguiente: Catálogo de Grupos, Casos de Uso, Matriz de Trazabilidad**

---

**Documento:** Prioridad 4 - Módulos de Gestión
**Fecha:** 07 de Noviembre, 2025
**Estado:** Listo para Implementación

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Creación inicial - 4 módulos de gestión | equipo-ba |
