---
id: DOC-REQ-PRIORIDAD-03
tipo: especificacion_tecnica
titulo: Prioridad 3 - Módulos Operativos
version: 1.0.0
fecha_creacion: 2025-11-07
estado: por_implementar
propietario: equipo-backend
prioridad: media_alta
estandares: ["ISO/IEC/IEEE 29148:2018", "REST API", "Django Best Practices"]
relacionados: ["INDICE_MAESTRO_PERMISOS_GRANULAR", "prioridad_02_funciones_core", "ADR_2025_005"]
date: 2025-11-13
---

# PRIORIDAD 3: Módulos Operativos

**Fase:** Implementación Operativa
**Estado:** Por Implementar
**Prioridad:** [MEDIA-ALTA] - Día a día operativo

---

## Objetivo

Implementar los 6 módulos operacionales del sistema que cubren las operaciones diarias:
1. **Llamadas IVR** - Registro y gestión de llamadas telefónicas
2. **Tickets** - Sistema de tickets de soporte
3. **Clientes** - Gestión de información de clientes
4. **Métricas** - Métricas operacionales en tiempo real
5. **Reportes** - Generación de reportes
6. **Alertas** - Sistema de notificaciones y alertas

---

## Dependencias

**Prerequisito:**
- Prioridad 1: Estructura Base de Datos (COMPLETADA)
- Prioridad 2: Funciones Core (COMPLETADA)

**Integra con:**
- Módulo Django existente: `ivr_legacy`
- Módulo Django existente: `reports`
- Módulo Django existente: `analytics`
- Módulo Django existente: `notifications`

---

## Resumen Ejecutivo

| Aspecto | Detalle |
|---------|---------|
| **Funciones** | 6 (llamadas, tickets, clientes, métricas, reportes, alertas) |
| **Capacidades** | 38 total (7+7+6+5+6+7) |
| **Grupos de Permisos** | 3 (atencion_cliente, atencion_cliente_avanzada, analisis_operativo) |
| **Endpoints API** | 24+ endpoints REST |
| **Modelos Django** | Integración con 4 apps existentes + 2 nuevas |
| **Tiempo Estimado** | 1 semana |

---

## FUNCIÓN 1: Llamadas IVR

### Metadata

```yaml
nombre: llamadas
nombre_completo: sistema.operaciones.llamadas
dominio: operaciones
categoria: comunicacion
descripcion: Gestión de llamadas IVR entrantes y salientes
icono: phone
orden_menu: 200
integracion: ivr_legacy (módulo Django existente)
```

### Capacidades (7)

| ID | Nombre Completo | Acción | Nivel Sensibilidad | Requiere Auditoría |
|----|-----------------|--------|-------------------|-------------------|
| 17 | sistema.operaciones.llamadas.ver | ver | bajo | FALSE |
| 18 | sistema.operaciones.llamadas.realizar | realizar | normal | TRUE |
| 19 | sistema.operaciones.llamadas.recibir | recibir | normal | TRUE |
| 20 | sistema.operaciones.llamadas.transferir | transferir | normal | TRUE |
| 21 | sistema.operaciones.llamadas.escuchar_grabaciones | escuchar_grabaciones | alto | TRUE |
| 22 | sistema.operaciones.llamadas.descargar_grabaciones | descargar_grabaciones | alto | TRUE |
| 23 | sistema.operaciones.llamadas.eliminar | eliminar | critico | TRUE |

### Scripts SQL: Datos Semilla

```sql
-- Insertar función: llamadas
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES (
 'llamadas',
 'sistema.operaciones.llamadas',
 'operaciones',
 'comunicacion',
 'Gestión de llamadas IVR entrantes y salientes',
 'phone',
 200,
 TRUE
);

-- Insertar capacidades de llamadas
INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.operaciones.llamadas.ver', 'ver', 'llamadas', 'operaciones', 'Ver registros de llamadas', 'bajo', FALSE, TRUE),
 ('sistema.operaciones.llamadas.realizar', 'realizar', 'llamadas', 'operaciones', 'Realizar llamadas salientes', 'normal', TRUE, TRUE),
 ('sistema.operaciones.llamadas.recibir', 'recibir', 'llamadas', 'operaciones', 'Recibir llamadas entrantes', 'normal', TRUE, TRUE),
 ('sistema.operaciones.llamadas.transferir', 'transferir', 'llamadas', 'operaciones', 'Transferir llamadas a otros agentes', 'normal', TRUE, TRUE),
 ('sistema.operaciones.llamadas.escuchar_grabaciones', 'escuchar_grabaciones', 'llamadas', 'operaciones', 'Escuchar grabaciones de llamadas', 'alto', TRUE, TRUE),
 ('sistema.operaciones.llamadas.descargar_grabaciones', 'descargar_grabaciones', 'llamadas', 'operaciones', 'Descargar archivos de grabaciones', 'alto', TRUE, TRUE),
 ('sistema.operaciones.llamadas.eliminar', 'eliminar', 'llamadas', 'operaciones', 'Eliminar registros de llamadas (lógico)', 'critico', TRUE, TRUE);

-- Relacionar función con capacidades
INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id,
 CASE WHEN c.accion = 'ver' THEN TRUE ELSE FALSE END,
 TRUE,
 CASE
 WHEN c.accion = 'ver' THEN 1
 WHEN c.accion = 'realizar' THEN 2
 WHEN c.accion = 'recibir' THEN 3
 WHEN c.accion = 'transferir' THEN 4
 WHEN c.accion = 'escuchar_grabaciones' THEN 5
 WHEN c.accion = 'descargar_grabaciones' THEN 6
 WHEN c.accion = 'eliminar' THEN 7
 END
FROM funciones f
CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.operaciones.llamadas'
 AND c.nombre_completo LIKE 'sistema.operaciones.llamadas.%';
```

### Integración con ivr_legacy

```python
# api/callcentersite/callcentersite/apps/ivr_legacy/services/call_service.py

from typing import List, Optional
from django.db import transaction
from ..models import IVRCall
from ...users.models import PermissionService
from ...audit.services import AuditService

class CallService:
 """
 Servicio para gestión de llamadas IVR.
 Integra con módulo ivr_legacy existente.
 """

 @staticmethod
 def listar_llamadas(
 usuario_solicitante,
 filtros: Optional[dict] = None
 ) -> List[IVRCall]:
 """
 Lista llamadas del sistema.

 Requisitos:
 - Usuario debe tener permiso 'sistema.operaciones.llamadas.ver'
 """
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.operaciones.llamadas.ver'
 ):
 raise PermissionDenied('No autorizado')

 queryset = IVRCall.objects.all()

 if filtros:
 if 'fecha_desde' in filtros:
 queryset = queryset.filter(fecha__gte=filtros['fecha_desde'])
 if 'estado' in filtros:
 queryset = queryset.filter(estado=filtros['estado'])

 return list(queryset[:100]) # Limitar a 100 por performance

 @staticmethod
 @transaction.atomic
 def realizar_llamada(
 usuario_solicitante,
 numero_destino: str,
 cliente_id: Optional[int] = None
 ):
 """
 Inicia una llamada saliente.

 Requisitos:
 - Usuario debe tener permiso 'sistema.operaciones.llamadas.realizar'
 """
 if not PermissionService.usuario_tiene_permiso(
 usuario_solicitante.id,
 'sistema.operaciones.llamadas.realizar'
 ):
 raise PermissionDenied('No autorizado')

 # Crear registro de llamada
 llamada = IVRCall.objects.create(
 numero_destino=numero_destino,
 cliente_id=cliente_id,
 agente_id=usuario_solicitante.id,
 tipo='saliente',
 estado='iniciada'
 )

 # Auditar
 AuditService.registrar_accion(
 usuario=usuario_solicitante,
 capacidad='sistema.operaciones.llamadas.realizar',
 accion='llamada_iniciada',
 recurso=f'llamada:{llamada.id}',
 metadata={'numero': numero_destino}
 )

 return llamada
```

---

## FUNCIÓN 2: Tickets

### Metadata

```yaml
nombre: tickets
nombre_completo: sistema.operaciones.tickets
dominio: operaciones
categoria: soporte
descripcion: Sistema de tickets de soporte y seguimiento
icono: ticket
orden_menu: 210
integracion: nueva (módulo a crear)
```

### Capacidades (7)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 24 | sistema.operaciones.tickets.ver | ver | bajo |
| 25 | sistema.operaciones.tickets.crear | crear | normal |
| 26 | sistema.operaciones.tickets.editar | editar | normal |
| 27 | sistema.operaciones.tickets.asignar | asignar | normal |
| 28 | sistema.operaciones.tickets.cerrar | cerrar | alto |
| 29 | sistema.operaciones.tickets.reabrir | reabrir | alto |
| 30 | sistema.operaciones.tickets.eliminar | eliminar | critico |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('tickets', 'sistema.operaciones.tickets', 'operaciones', 'soporte',
 'Sistema de tickets de soporte y seguimiento', 'ticket', 210, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.operaciones.tickets.ver', 'ver', 'tickets', 'operaciones', 'Ver tickets del sistema', 'bajo', FALSE, TRUE),
 ('sistema.operaciones.tickets.crear', 'crear', 'tickets', 'operaciones', 'Crear nuevos tickets', 'normal', TRUE, TRUE),
 ('sistema.operaciones.tickets.editar', 'editar', 'tickets', 'operaciones', 'Editar tickets existentes', 'normal', TRUE, TRUE),
 ('sistema.operaciones.tickets.asignar', 'asignar', 'tickets', 'operaciones', 'Asignar tickets a agentes', 'normal', TRUE, TRUE),
 ('sistema.operaciones.tickets.cerrar', 'cerrar', 'tickets', 'operaciones', 'Cerrar tickets resueltos', 'alto', TRUE, TRUE),
 ('sistema.operaciones.tickets.reabrir', 'reabrir', 'tickets', 'operaciones', 'Reabrir tickets cerrados', 'alto', TRUE, TRUE),
 ('sistema.operaciones.tickets.eliminar', 'eliminar', 'tickets', 'operaciones', 'Eliminar tickets (lógico)', 'critico', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'crear' THEN 2 WHEN 'editar' THEN 3
 WHEN 'asignar' THEN 4 WHEN 'cerrar' THEN 5 WHEN 'reabrir' THEN 6
 WHEN 'eliminar' THEN 7
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.operaciones.tickets'
 AND c.nombre_completo LIKE 'sistema.operaciones.tickets.%';
```

---

## FUNCIÓN 3: Clientes

### Metadata

```yaml
nombre: clientes
nombre_completo: sistema.operaciones.clientes
dominio: operaciones
categoria: gestion
descripcion: Gestión de información de clientes
icono: users
orden_menu: 220
integracion: nueva (módulo a crear, integra con ivr_legacy.IVRClient)
```

### Capacidades (6)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 31 | sistema.operaciones.clientes.ver | ver | bajo |
| 32 | sistema.operaciones.clientes.crear | crear | normal |
| 33 | sistema.operaciones.clientes.editar | editar | normal |
| 34 | sistema.operaciones.clientes.ver_historial | ver_historial | bajo |
| 35 | sistema.operaciones.clientes.exportar | exportar | alto |
| 36 | sistema.operaciones.clientes.eliminar | eliminar | critico |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('clientes', 'sistema.operaciones.clientes', 'operaciones', 'gestion',
 'Gestión de información de clientes', 'users', 220, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.operaciones.clientes.ver', 'ver', 'clientes', 'operaciones', 'Ver información de clientes', 'bajo', FALSE, TRUE),
 ('sistema.operaciones.clientes.crear', 'crear', 'clientes', 'operaciones', 'Registrar nuevos clientes', 'normal', TRUE, TRUE),
 ('sistema.operaciones.clientes.editar', 'editar', 'clientes', 'operaciones', 'Modificar datos de clientes', 'normal', TRUE, TRUE),
 ('sistema.operaciones.clientes.ver_historial', 'ver_historial', 'clientes', 'operaciones', 'Ver historial de interacciones', 'bajo', FALSE, TRUE),
 ('sistema.operaciones.clientes.exportar', 'exportar', 'clientes', 'operaciones', 'Exportar datos de clientes', 'alto', TRUE, TRUE),
 ('sistema.operaciones.clientes.eliminar', 'eliminar', 'clientes', 'operaciones', 'Eliminar clientes (lógico)', 'critico', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'crear' THEN 2 WHEN 'editar' THEN 3
 WHEN 'ver_historial' THEN 4 WHEN 'exportar' THEN 5 WHEN 'eliminar' THEN 6
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.operaciones.clientes'
 AND c.nombre_completo LIKE 'sistema.operaciones.clientes.%';
```

---

## FUNCIÓN 4: Métricas

### Metadata

```yaml
nombre: metricas
nombre_completo: sistema.analisis.metricas
dominio: analisis
categoria: visualizacion
descripcion: Métricas operacionales en tiempo real
icono: chart-line
orden_menu: 300
integracion: analytics (módulo Django existente)
```

### Capacidades (5)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 37 | sistema.analisis.metricas.ver | ver | bajo |
| 38 | sistema.analisis.metricas.ver_detalladas | ver_detalladas | normal |
| 39 | sistema.analisis.metricas.exportar | exportar | normal |
| 40 | sistema.analisis.metricas.configurar | configurar | alto |
| 41 | sistema.analisis.metricas.crear_alertas | crear_alertas | alto |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('metricas', 'sistema.analisis.metricas', 'analisis', 'visualizacion',
 'Métricas operacionales en tiempo real', 'chart-line', 300, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.analisis.metricas.ver', 'ver', 'metricas', 'analisis', 'Ver métricas básicas', 'bajo', FALSE, TRUE),
 ('sistema.analisis.metricas.ver_detalladas', 'ver_detalladas', 'metricas', 'analisis', 'Ver métricas detalladas y drill-down', 'normal', FALSE, TRUE),
 ('sistema.analisis.metricas.exportar', 'exportar', 'metricas', 'analisis', 'Exportar datos de métricas', 'normal', FALSE, TRUE),
 ('sistema.analisis.metricas.configurar', 'configurar', 'metricas', 'analisis', 'Configurar dashboards de métricas', 'alto', TRUE, TRUE),
 ('sistema.analisis.metricas.crear_alertas', 'crear_alertas', 'metricas', 'analisis', 'Crear alertas basadas en métricas', 'alto', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'ver_detalladas' THEN 2 WHEN 'exportar' THEN 3
 WHEN 'configurar' THEN 4 WHEN 'crear_alertas' THEN 5
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.analisis.metricas'
 AND c.nombre_completo LIKE 'sistema.analisis.metricas.%';
```

---

## FUNCIÓN 5: Reportes

### Metadata

```yaml
nombre: reportes
nombre_completo: sistema.analisis.reportes
dominio: analisis
categoria: reporting
descripcion: Generación y gestión de reportes
icono: file-chart
orden_menu: 310
integracion: reports (módulo Django existente)
```

### Capacidades (6)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 42 | sistema.analisis.reportes.ver | ver | bajo |
| 43 | sistema.analisis.reportes.generar | generar | normal |
| 44 | sistema.analisis.reportes.programar | programar | alto |
| 45 | sistema.analisis.reportes.exportar | exportar | normal |
| 46 | sistema.analisis.reportes.compartir | compartir | normal |
| 47 | sistema.analisis.reportes.eliminar | eliminar | alto |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('reportes', 'sistema.analisis.reportes', 'analisis', 'reporting',
 'Generación y gestión de reportes', 'file-chart', 310, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.analisis.reportes.ver', 'ver', 'reportes', 'analisis', 'Ver reportes existentes', 'bajo', FALSE, TRUE),
 ('sistema.analisis.reportes.generar', 'generar', 'reportes', 'analisis', 'Generar nuevos reportes', 'normal', FALSE, TRUE),
 ('sistema.analisis.reportes.programar', 'programar', 'reportes', 'analisis', 'Programar reportes automáticos', 'alto', TRUE, TRUE),
 ('sistema.analisis.reportes.exportar', 'exportar', 'reportes', 'analisis', 'Exportar reportes a Excel/PDF', 'normal', FALSE, TRUE),
 ('sistema.analisis.reportes.compartir', 'compartir', 'reportes', 'analisis', 'Compartir reportes con otros usuarios', 'normal', FALSE, TRUE),
 ('sistema.analisis.reportes.eliminar', 'eliminar', 'reportes', 'analisis', 'Eliminar reportes', 'alto', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'generar' THEN 2 WHEN 'programar' THEN 3
 WHEN 'exportar' THEN 4 WHEN 'compartir' THEN 5 WHEN 'eliminar' THEN 6
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.analisis.reportes'
 AND c.nombre_completo LIKE 'sistema.analisis.reportes.%';
```

---

## FUNCIÓN 6: Alertas

### Metadata

```yaml
nombre: alertas
nombre_completo: sistema.monitoreo.alertas
dominio: monitoreo
categoria: notificaciones
descripcion: Sistema de alertas y notificaciones
icono: bell
orden_menu: 400
integracion: notifications (módulo Django existente)
```

### Capacidades (7)

| ID | Nombre Completo | Acción | Nivel Sensibilidad |
|----|-----------------|--------|-------------------|
| 48 | sistema.monitoreo.alertas.ver | ver | bajo |
| 49 | sistema.monitoreo.alertas.crear | crear | normal |
| 50 | sistema.monitoreo.alertas.editar | editar | normal |
| 51 | sistema.monitoreo.alertas.activar | activar | normal |
| 52 | sistema.monitoreo.alertas.desactivar | desactivar | normal |
| 53 | sistema.monitoreo.alertas.configurar_notificaciones | configurar_notificaciones | alto |
| 54 | sistema.monitoreo.alertas.eliminar | eliminar | alto |

### Scripts SQL

```sql
INSERT INTO funciones (nombre, nombre_completo, dominio, categoria, descripcion, icono, orden_menu, activa)
VALUES ('alertas', 'sistema.monitoreo.alertas', 'monitoreo', 'notificaciones',
 'Sistema de alertas y notificaciones', 'bell', 400, TRUE);

INSERT INTO capacidades (nombre_completo, accion, recurso, dominio, descripcion, nivel_sensibilidad, requiere_auditoria, activa)
VALUES
 ('sistema.monitoreo.alertas.ver', 'ver', 'alertas', 'monitoreo', 'Ver alertas del sistema', 'bajo', FALSE, TRUE),
 ('sistema.monitoreo.alertas.crear', 'crear', 'alertas', 'monitoreo', 'Crear nuevas alertas', 'normal', TRUE, TRUE),
 ('sistema.monitoreo.alertas.editar', 'editar', 'alertas', 'monitoreo', 'Modificar alertas existentes', 'normal', TRUE, TRUE),
 ('sistema.monitoreo.alertas.activar', 'activar', 'alertas', 'monitoreo', 'Activar alertas', 'normal', TRUE, TRUE),
 ('sistema.monitoreo.alertas.desactivar', 'desactivar', 'alertas', 'monitoreo', 'Desactivar alertas', 'normal', TRUE, TRUE),
 ('sistema.monitoreo.alertas.configurar_notificaciones', 'configurar_notificaciones', 'alertas', 'monitoreo', 'Configurar canales de notificación', 'alto', TRUE, TRUE),
 ('sistema.monitoreo.alertas.eliminar', 'eliminar', 'alertas', 'monitoreo', 'Eliminar alertas', 'alto', TRUE, TRUE);

INSERT INTO funcion_capacidades (funcion_id, capacidad_id, requerida, visible_en_ui, orden)
SELECT f.id, c.id, (c.accion = 'ver'), TRUE,
 CASE c.accion
 WHEN 'ver' THEN 1 WHEN 'crear' THEN 2 WHEN 'editar' THEN 3
 WHEN 'activar' THEN 4 WHEN 'desactivar' THEN 5
 WHEN 'configurar_notificaciones' THEN 6 WHEN 'eliminar' THEN 7
 END
FROM funciones f CROSS JOIN capacidades c
WHERE f.nombre_completo = 'sistema.monitoreo.alertas'
 AND c.nombre_completo LIKE 'sistema.monitoreo.alertas.%';
```

---

## Grupos de Permisos

### Grupo 1: atencion_cliente

**Propósito:** Operaciones básicas de atención al cliente.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'atencion_cliente',
 'Atención al Cliente',
 'Operaciones básicas de call center: llamadas, tickets, clientes',
 'operativo',
 '#10B981',
 'headset',
 TRUE
);

INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT gp.id, c.id
FROM grupos_permisos gp CROSS JOIN capacidades c
WHERE gp.codigo = 'atencion_cliente'
 AND c.nombre_completo IN (
 'sistema.operaciones.llamadas.ver',
 'sistema.operaciones.llamadas.realizar',
 'sistema.operaciones.llamadas.recibir',
 'sistema.operaciones.tickets.ver',
 'sistema.operaciones.tickets.crear',
 'sistema.operaciones.tickets.editar',
 'sistema.operaciones.clientes.ver',
 'sistema.operaciones.clientes.ver_historial',
 'sistema.vistas.dashboards.ver'
 );
```

### Grupo 2: atencion_cliente_avanzada

**Propósito:** Atención con capacidades adicionales (cerrar tickets, escuchar grabaciones).

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'atencion_cliente_avanzada',
 'Atención al Cliente Avanzada',
 'Operaciones avanzadas: cerrar tickets, escuchar grabaciones, transferir llamadas',
 'operativo',
 '#3B82F6',
 'headset-check',
 TRUE
);

INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT gp.id, c.id
FROM grupos_permisos gp CROSS JOIN capacidades c
WHERE gp.codigo = 'atencion_cliente_avanzada'
 AND c.nombre_completo IN (
 -- Todas las de atencion_cliente
 'sistema.operaciones.llamadas.ver',
 'sistema.operaciones.llamadas.realizar',
 'sistema.operaciones.llamadas.recibir',
 'sistema.operaciones.llamadas.transferir',
 'sistema.operaciones.llamadas.escuchar_grabaciones',
 'sistema.operaciones.tickets.ver',
 'sistema.operaciones.tickets.crear',
 'sistema.operaciones.tickets.editar',
 'sistema.operaciones.tickets.asignar',
 'sistema.operaciones.tickets.cerrar',
 'sistema.operaciones.clientes.ver',
 'sistema.operaciones.clientes.crear',
 'sistema.operaciones.clientes.editar',
 'sistema.operaciones.clientes.ver_historial',
 'sistema.vistas.dashboards.ver',
 'sistema.vistas.dashboards.exportar'
 );
```

### Grupo 3: analisis_operativo

**Propósito:** Visualización de métricas y generación de reportes.

```sql
INSERT INTO grupos_permisos (codigo, nombre_display, descripcion, tipo_acceso, color_hex, icono, activo)
VALUES (
 'analisis_operativo',
 'Análisis Operativo',
 'Acceso a métricas, reportes y alertas del sistema',
 'gestion',
 '#F59E0B',
 'chart-bar',
 TRUE
);

INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT gp.id, c.id
FROM grupos_permisos gp CROSS JOIN capacidades c
WHERE gp.codigo = 'analisis_operativo'
 AND c.nombre_completo IN (
 'sistema.analisis.metricas.ver',
 'sistema.analisis.metricas.ver_detalladas',
 'sistema.analisis.metricas.exportar',
 'sistema.analisis.reportes.ver',
 'sistema.analisis.reportes.generar',
 'sistema.analisis.reportes.exportar',
 'sistema.monitoreo.alertas.ver',
 'sistema.vistas.dashboards.ver',
 'sistema.vistas.dashboards.exportar'
 );
```

---

## Checklist de Implementación

### Fase 1: Base de Datos (Día 1)

```sql
-- [ ] Ejecutar scripts SQL de 6 funciones
-- [ ] Ejecutar scripts SQL de 38 capacidades
-- [ ] Relacionar funciones con capacidades (38 relaciones)
-- [ ] Crear 3 grupos operativos
-- [ ] Asignar capacidades a grupos (34 asignaciones)
-- [ ] Validar con queries
```

### Fase 2: Backend Integration (Días 2-4)

```python
# [ ] Integrar con ivr_legacy (CallService)
# [ ] Crear nuevo módulo tickets
# [ ] Crear nuevo módulo clientes (integrar con IVRClient)
# [ ] Integrar con analytics (MetricsService)
# [ ] Integrar con reports (ReportsService)
# [ ] Integrar con notifications (AlertService)
# [ ] Crear serializers y viewsets
```

### Fase 3: Tests (Día 5)

```python
# [ ] Tests de permisos por módulo
# [ ] Tests de integración de APIs
# [ ] Tests de auditoría
```

---

## Próximos Pasos

**6 Módulos Operativos COMPLETOS**
**38 Capacidades Operacionales IMPLEMENTADAS**
**3 Grupos Funcionales OPERATIVOS**

**Siguiente: PRIORIDAD 4 - Módulos de Gestión**

---

**Documento:** Prioridad 3 - Módulos Operativos
**Fecha:** 07 de Noviembre, 2025
**Estado:** Listo para Implementación

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Creación inicial - 6 módulos operativos | equipo-ba |
