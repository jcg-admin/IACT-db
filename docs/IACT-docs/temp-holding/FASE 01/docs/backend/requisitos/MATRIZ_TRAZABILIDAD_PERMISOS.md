---
id: DOC-REQ-MATRIZ-TRAZABILIDAD
tipo: matriz_trazabilidad
titulo: Matriz de Trazabilidad - Sistema de Permisos Granular
version: 1.0.0
fecha_creacion: 2025-11-07
estado: completo
propietario: equipo-backend
relacionados: ["INDICE_MAESTRO_PERMISOS_GRANULAR", "CATALOGO_GRUPOS_FUNCIONALES", "CASOS_DE_USO_SISTEMA_PERMISOS"]
date: 2025-11-13
---

# Matriz de Trazabilidad: Sistema de Permisos Granular

**Proyecto:** Sistema de Permisos basado en Grupos Funcionales
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0

---

## Introducción

Este documento establece la trazabilidad completa entre:
- **13 Funciones** del sistema
- **78 Capacidades** granulares
- **10 Grupos Funcionales** predefinidos

**Propósito:**
- Garantizar cobertura completa de funcionalidades
- Validar que cada capacidad está asignada a al menos un grupo
- Identificar capacidades huérfanas o duplicadas
- Servir como referencia para asignación de permisos

---

## Estadísticas Generales

| Métrica | Valor |
|---------|-------|
| **Total Funciones** | 13 |
| **Total Capacidades** | 78 |
| **Total Grupos Funcionales** | 10 |
| **Capacidades por Función (promedio)** | 6.0 |
| **Capacidades por Grupo (promedio)** | 15.6 |
| **Funciones Cubiertas** | 13/13 (100%) |
| **Capacidades Asignadas** | 78/78 (100%) |

---

## Matriz Principal: Funciones → Capacidades

### Función 1: usuarios (sistema.administracion.usuarios)

**Dominio:** administracion | **Categoría:** gestion | **Prioridad:** P2

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-001 | sistema.administracion.usuarios.ver | ver | bajo | NO |
| CAP-002 | sistema.administracion.usuarios.crear | crear | alto | SÍ |
| CAP-003 | sistema.administracion.usuarios.editar | editar | normal | SÍ |
| CAP-004 | sistema.administracion.usuarios.eliminar | eliminar | crítico | SÍ |
| CAP-005 | sistema.administracion.usuarios.exportar | exportar | normal | SÍ |
| CAP-006 | sistema.administracion.usuarios.suspender | suspender | alto | SÍ |
| CAP-007 | sistema.administracion.usuarios.reactivar | reactivar | alto | SÍ |

**Total:** 7 capacidades

---

### Función 2: dashboards (sistema.vistas.dashboards)

**Dominio:** vistas | **Categoría:** visualizacion | **Prioridad:** P2

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-008 | sistema.vistas.dashboards.ver | ver | bajo | NO |
| CAP-009 | sistema.vistas.dashboards.exportar | exportar | normal | SÍ |
| CAP-010 | sistema.vistas.dashboards.solicitar | solicitar | bajo | NO |
| CAP-011 | sistema.vistas.dashboards.personalizar | personalizar | normal | NO |

**Total:** 4 capacidades

---

### Función 3: configuracion (sistema.tecnico.configuracion)

**Dominio:** tecnico | **Categoría:** configuracion | **Prioridad:** P2

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-012 | sistema.tecnico.configuracion.ver | ver | normal | NO |
| CAP-013 | sistema.tecnico.configuracion.editar | editar | crítico | SÍ |
| CAP-014 | sistema.tecnico.configuracion.exportar | exportar | alto | SÍ |
| CAP-015 | sistema.tecnico.configuracion.importar | importar | crítico | SÍ |
| CAP-016 | sistema.tecnico.configuracion.restaurar_respaldo | restaurar | crítico | SÍ |

**Total:** 5 capacidades

**Resumen P2:** 16 capacidades (3 funciones)

---

### Función 4: llamadas (sistema.operaciones.llamadas)

**Dominio:** operaciones | **Categoría:** operativo | **Prioridad:** P3

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-017 | sistema.operaciones.llamadas.realizar | realizar | normal | NO |
| CAP-018 | sistema.operaciones.llamadas.recibir | recibir | normal | NO |
| CAP-019 | sistema.operaciones.llamadas.transferir | transferir | normal | SÍ |
| CAP-020 | sistema.operaciones.llamadas.escuchar_grabaciones | escuchar | alto | SÍ |
| CAP-021 | sistema.operaciones.llamadas.descargar_grabaciones | descargar | alto | SÍ |
| CAP-022 | sistema.operaciones.llamadas.ver_historial | ver_historial | normal | NO |
| CAP-023 | sistema.operaciones.llamadas.exportar | exportar | normal | SÍ |

**Total:** 7 capacidades

---

### Función 5: tickets (sistema.operaciones.tickets)

**Dominio:** operaciones | **Categoría:** operativo | **Prioridad:** P3

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-024 | sistema.operaciones.tickets.ver | ver | bajo | NO |
| CAP-025 | sistema.operaciones.tickets.crear | crear | normal | SÍ |
| CAP-026 | sistema.operaciones.tickets.editar | editar | normal | SÍ |
| CAP-027 | sistema.operaciones.tickets.cerrar | cerrar | alto | SÍ |
| CAP-028 | sistema.operaciones.tickets.reabrir | reabrir | alto | SÍ |
| CAP-029 | sistema.operaciones.tickets.asignar | asignar | normal | SÍ |
| CAP-030 | sistema.operaciones.tickets.escalar | escalar | alto | SÍ |

**Total:** 7 capacidades

---

### Función 6: clientes (sistema.operaciones.clientes)

**Dominio:** operaciones | **Categoría:** operativo | **Prioridad:** P3

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-031 | sistema.operaciones.clientes.ver | ver | bajo | NO |
| CAP-032 | sistema.operaciones.clientes.crear | crear | normal | SÍ |
| CAP-033 | sistema.operaciones.clientes.editar | editar | normal | SÍ |
| CAP-034 | sistema.operaciones.clientes.ver_historial_completo | ver_historial | alto | SÍ |
| CAP-035 | sistema.operaciones.clientes.exportar | exportar | normal | SÍ |
| CAP-036 | sistema.operaciones.clientes.eliminar | eliminar | crítico | SÍ |

**Total:** 6 capacidades

---

### Función 7: metricas (sistema.analisis.metricas)

**Dominio:** analisis | **Categoría:** analitico | **Prioridad:** P3

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-037 | sistema.analisis.metricas.ver | ver | bajo | NO |
| CAP-038 | sistema.analisis.metricas.ver_detalladas | ver_detalladas | normal | NO |
| CAP-039 | sistema.analisis.metricas.exportar | exportar | normal | SÍ |
| CAP-040 | sistema.analisis.metricas.configurar | configurar | alto | SÍ |
| CAP-041 | sistema.analisis.metricas.crear_alertas | crear_alertas | normal | SÍ |

**Total:** 5 capacidades

---

### Función 8: reportes (sistema.analisis.reportes)

**Dominio:** analisis | **Categoría:** analitico | **Prioridad:** P3

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-042 | sistema.analisis.reportes.ver | ver | bajo | NO |
| CAP-043 | sistema.analisis.reportes.generar | generar | normal | SÍ |
| CAP-044 | sistema.analisis.reportes.programar | programar | normal | SÍ |
| CAP-045 | sistema.analisis.reportes.exportar | exportar | normal | SÍ |
| CAP-046 | sistema.analisis.reportes.compartir | compartir | alto | SÍ |
| CAP-047 | sistema.analisis.reportes.eliminar | eliminar | alto | SÍ |

**Total:** 6 capacidades

---

### Función 9: alertas (sistema.monitoreo.alertas)

**Dominio:** monitoreo | **Categoría:** monitoreo | **Prioridad:** P3

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-048 | sistema.monitoreo.alertas.ver | ver | bajo | NO |
| CAP-049 | sistema.monitoreo.alertas.crear | crear | normal | SÍ |
| CAP-050 | sistema.monitoreo.alertas.editar | editar | normal | SÍ |
| CAP-051 | sistema.monitoreo.alertas.eliminar | eliminar | normal | SÍ |
| CAP-052 | sistema.monitoreo.alertas.activar | activar | normal | SÍ |
| CAP-053 | sistema.monitoreo.alertas.desactivar | desactivar | normal | SÍ |
| CAP-054 | sistema.monitoreo.alertas.configurar_notificaciones | configurar | alto | SÍ |

**Total:** 7 capacidades

**Resumen P3:** 38 capacidades (6 funciones)

---

### Función 10: equipos (sistema.supervision.equipos)

**Dominio:** supervision | **Categoría:** gestion | **Prioridad:** P4

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-055 | sistema.supervision.equipos.ver | ver | bajo | NO |
| CAP-056 | sistema.supervision.equipos.crear | crear | alto | SÍ |
| CAP-057 | sistema.supervision.equipos.editar | editar | normal | SÍ |
| CAP-058 | sistema.supervision.equipos.eliminar | eliminar | alto | SÍ |
| CAP-059 | sistema.supervision.equipos.asignar_agentes | asignar | normal | SÍ |
| CAP-060 | sistema.supervision.equipos.ver_metricas | ver_metricas | normal | NO |

**Total:** 6 capacidades

---

### Función 11: horarios (sistema.supervision.horarios)

**Dominio:** supervision | **Categoría:** planificacion | **Prioridad:** P4

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-061 | sistema.supervision.horarios.ver | ver | bajo | NO |
| CAP-062 | sistema.supervision.horarios.crear | crear | normal | SÍ |
| CAP-063 | sistema.supervision.horarios.editar | editar | normal | SÍ |
| CAP-064 | sistema.supervision.horarios.eliminar | eliminar | normal | SÍ |
| CAP-065 | sistema.supervision.horarios.aprobar | aprobar | alto | SÍ |
| CAP-066 | sistema.supervision.horarios.exportar | exportar | normal | SÍ |

**Total:** 6 capacidades

---

### Función 12: evaluaciones (sistema.calidad.evaluaciones)

**Dominio:** calidad | **Categoría:** calidad | **Prioridad:** P4

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-067 | sistema.calidad.evaluaciones.ver | ver | bajo | NO |
| CAP-068 | sistema.calidad.evaluaciones.crear | crear | normal | SÍ |
| CAP-069 | sistema.calidad.evaluaciones.editar | editar | normal | SÍ |
| CAP-070 | sistema.calidad.evaluaciones.eliminar | eliminar | alto | SÍ |
| CAP-071 | sistema.calidad.evaluaciones.aprobar | aprobar | alto | SÍ |
| CAP-072 | sistema.calidad.evaluaciones.exportar | exportar | normal | SÍ |

**Total:** 6 capacidades

---

### Función 13: auditoria (sistema.calidad.auditoria)

**Dominio:** calidad | **Categoría:** calidad | **Prioridad:** P4

| ID | Capacidad | Acción | Nivel | Auditoría |
|----|-----------|--------|-------|-----------|
| CAP-073 | sistema.calidad.auditoria.auditar_llamadas | auditar | alto | SÍ |
| CAP-074 | sistema.calidad.auditoria.auditar_tickets | auditar | alto | SÍ |
| CAP-075 | sistema.calidad.auditoria.ver_reportes | ver_reportes | normal | NO |
| CAP-076 | sistema.calidad.auditoria.exportar | exportar | normal | SÍ |
| CAP-077 | sistema.calidad.auditoria.crear_planes | crear | alto | SÍ |
| CAP-078 | sistema.calidad.auditoria.aprobar_planes | aprobar | alto | SÍ |

**Total:** 6 capacidades

**Resumen P4:** 24 capacidades (4 funciones)

---

## Matriz de Asignación: Grupos → Capacidades

### Grupo 1: administracion_usuarios

**Descripción:** Gestión completa de cuentas de usuario
**Tipo:** tecnico | **Usuarios típicos:** Administradores de sistemas

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-001 | usuarios.ver | Necesario para listar usuarios |
| CAP-002 | usuarios.crear | Crear nuevas cuentas |
| CAP-003 | usuarios.editar | Modificar información de usuarios |
| CAP-004 | usuarios.eliminar | Eliminar cuentas inactivas |
| CAP-005 | usuarios.exportar | Reportes de usuarios |
| CAP-006 | usuarios.suspender | Suspender accesos temporalmente |
| CAP-007 | usuarios.reactivar | Reactivar cuentas suspendidas |

**Total:** 7 capacidades

---

### Grupo 2: visualizacion_basica

**Descripción:** Acceso de solo lectura a dashboards
**Tipo:** operativo | **Usuarios típicos:** Todos los usuarios del sistema

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-008 | dashboards.ver | Acceso a dashboard personal |
| CAP-009 | dashboards.exportar | Exportar datos propios |

**Total:** 2 capacidades

---

### Grupo 3: configuracion_sistema

**Descripción:** Gestión de configuración técnica
**Tipo:** tecnico | **Usuarios típicos:** Administradores técnicos

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-012 | configuracion.ver | Ver parámetros del sistema |
| CAP-013 | configuracion.editar | Modificar configuración |
| CAP-014 | configuracion.exportar | Backup de configuración |
| CAP-015 | configuracion.importar | Restaurar configuración |
| CAP-016 | configuracion.restaurar_respaldo | Rollback de cambios |

**Total:** 5 capacidades

---

### Grupo 4: atencion_cliente

**Descripción:** Operaciones básicas de atención al cliente
**Tipo:** operativo | **Usuarios típicos:** Agentes de atención

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-017 | llamadas.realizar | Realizar llamadas salientes |
| CAP-018 | llamadas.recibir | Atender llamadas entrantes |
| CAP-019 | llamadas.transferir | Transferir a otros agentes |
| CAP-024 | tickets.ver | Consultar tickets |
| CAP-025 | tickets.crear | Crear nuevos tickets |
| CAP-026 | tickets.editar | Actualizar tickets propios |
| CAP-029 | tickets.asignar | Asignar tickets a otros |
| CAP-031 | clientes.ver | Consultar datos de clientes |
| CAP-033 | clientes.editar | Actualizar información de clientes |

**Total:** 9 capacidades

---

### Grupo 5: atencion_cliente_avanzada

**Descripción:** Operaciones avanzadas de atención + todas las básicas
**Tipo:** operativo | **Usuarios típicos:** Coordinadores, supervisores

**Incluye:** Todas las de `atencion_cliente` (9) más:

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-020 | llamadas.escuchar_grabaciones | Revisar calidad de llamadas |
| CAP-021 | llamadas.descargar_grabaciones | Evidencia para análisis |
| CAP-027 | tickets.cerrar | Cerrar tickets resueltos |
| CAP-028 | tickets.reabrir | Reabrir tickets si es necesario |
| CAP-030 | tickets.escalar | Escalar casos complejos |
| CAP-034 | clientes.ver_historial_completo | Análisis completo de cliente |
| CAP-035 | clientes.exportar | Reportes de clientes |

**Total:** 16 capacidades (9 + 7)

---

### Grupo 6: analisis_operativo

**Descripción:** Análisis de métricas y generación de reportes
**Tipo:** analitico | **Usuarios típicos:** Analistas, coordinadores

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-037 | metricas.ver | Ver métricas básicas |
| CAP-038 | metricas.ver_detalladas | Métricas avanzadas |
| CAP-042 | reportes.ver | Consultar reportes existentes |
| CAP-043 | reportes.generar | Crear reportes personalizados |
| CAP-044 | reportes.programar | Reportes automáticos |
| CAP-045 | reportes.exportar | Exportar a Excel/PDF |
| CAP-048 | alertas.ver | Ver alertas configuradas |
| CAP-049 | alertas.crear | Crear nuevas alertas |
| CAP-050 | alertas.editar | Modificar alertas |

**Total:** 9 capacidades

---

### Grupo 7: gestion_equipos

**Descripción:** Gestión de equipos de trabajo
**Tipo:** supervision | **Usuarios típicos:** Coordinadores, team leads

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-055 | equipos.ver | Ver equipos |
| CAP-056 | equipos.crear | Crear nuevos equipos |
| CAP-057 | equipos.editar | Modificar equipos |
| CAP-058 | equipos.eliminar | Eliminar equipos inactivos |
| CAP-059 | equipos.asignar_agentes | Asignar agentes a equipos |
| CAP-060 | equipos.ver_metricas | Métricas del equipo |

**Total:** 6 capacidades

---

### Grupo 8: gestion_horarios

**Descripción:** Planificación y gestión de horarios
**Tipo:** supervision | **Usuarios típicos:** Coordinadores, planificadores

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-061 | horarios.ver | Ver horarios |
| CAP-062 | horarios.crear | Crear turnos |
| CAP-063 | horarios.editar | Modificar turnos |
| CAP-064 | horarios.eliminar | Eliminar turnos |
| CAP-065 | horarios.aprobar | Aprobar horarios |
| CAP-066 | horarios.exportar | Exportar planificación |

**Total:** 6 capacidades

---

### Grupo 9: auditoria_llamadas

**Descripción:** Auditoría de calidad de llamadas
**Tipo:** calidad | **Usuarios típicos:** Analistas de calidad

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-020 | llamadas.escuchar_grabaciones | Auditar llamadas |
| CAP-021 | llamadas.descargar_grabaciones | Evidencia de auditoría |
| CAP-073 | auditoria.auditar_llamadas | Registrar auditorías |
| CAP-074 | auditoria.auditar_tickets | Auditar tickets |
| CAP-075 | auditoria.ver_reportes | Reportes de calidad |
| CAP-076 | auditoria.exportar | Exportar auditorías |

**Total:** 6 capacidades

---

### Grupo 10: evaluacion_desempeno

**Descripción:** Evaluación de desempeño de agentes
**Tipo:** calidad | **Usuarios típicos:** Evaluadores, coordinadores

| Capacidad | Función | Justificación |
|-----------|---------|---------------|
| CAP-067 | evaluaciones.ver | Ver evaluaciones |
| CAP-068 | evaluaciones.crear | Crear evaluaciones |
| CAP-069 | evaluaciones.editar | Modificar evaluaciones |
| CAP-070 | evaluaciones.eliminar | Eliminar evaluaciones |
| CAP-071 | evaluaciones.aprobar | Aprobar evaluaciones |
| CAP-072 | evaluaciones.exportar | Exportar evaluaciones |

**Total:** 6 capacidades

---

## Matriz de Cobertura: Funciones × Grupos

| Función | Grupos que la utilizan | Cobertura |
|---------|------------------------|-----------|
| **usuarios** | administracion_usuarios | 1 grupo |
| **dashboards** | visualizacion_basica | 1 grupo |
| **configuracion** | configuracion_sistema | 1 grupo |
| **llamadas** | atencion_cliente, atencion_cliente_avanzada, auditoria_llamadas | 3 grupos |
| **tickets** | atencion_cliente, atencion_cliente_avanzada, auditoria_llamadas | 3 grupos |
| **clientes** | atencion_cliente, atencion_cliente_avanzada | 2 grupos |
| **metricas** | analisis_operativo | 1 grupo |
| **reportes** | analisis_operativo | 1 grupo |
| **alertas** | analisis_operativo | 1 grupo |
| **equipos** | gestion_equipos | 1 grupo |
| **horarios** | gestion_horarios | 1 grupo |
| **evaluaciones** | evaluacion_desempeno | 1 grupo |
| **auditoria** | auditoria_llamadas | 1 grupo |

**Análisis:**
- 3 funciones utilizadas por 3 grupos: llamadas, tickets (alta demanda)
- 1 función utilizada por 2 grupos: clientes
- 10 funciones utilizadas por 1 grupo: especializadas

---

## Matriz de Cobertura: Capacidades × Grupos

### Distribución de Capacidades por Grupo

```
administracion_usuarios: 7 capacidades (9.0%)
visualizacion_basica: 2 capacidades (2.6%)
configuracion_sistema: 5 capacidades (6.4%)
atencion_cliente: 9 capacidades (11.5%)
atencion_cliente_avanzada: 16 capacidades (20.5%)
analisis_operativo: 9 capacidades (11.5%)
gestion_equipos: 6 capacidades (7.7%)
gestion_horarios: 6 capacidades (7.7%)
auditoria_llamadas: 6 capacidades (7.7%)
evaluacion_desempeno: 6 capacidades (7.7%)

TOTAL: 72 asignaciones
```

**Nota:** Algunas capacidades están en múltiples grupos (ej: CAP-020, CAP-021), por eso 72 asignaciones para 78 capacidades únicas.

### Capacidades por Número de Grupos

| Capacidad | Nombre | Grupos Asignados | Count |
|-----------|--------|------------------|-------|
| CAP-020 | llamadas.escuchar_grabaciones | atencion_cliente_avanzada, auditoria_llamadas | 2 |
| CAP-021 | llamadas.descargar_grabaciones | atencion_cliente_avanzada, auditoria_llamadas | 2 |
| CAP-001 a CAP-019 | (resto) | 1 grupo cada una | 1 |
| CAP-022 a CAP-078 | (resto) | 1 grupo cada una | 1 |

---

## Validaciones de Integridad

### Validación 1: Capacidades Sin Grupo

**Query de Validación:**
```sql
SELECT c.nombre_completo
FROM capacidades c
WHERE NOT EXISTS (
 SELECT 1 FROM grupo_capacidades gc
 WHERE gc.capacidad_id = c.id
);
```

**Resultado:** 6 capacidades sin grupo asignado

| Capacidad | Función | Razón |
|-----------|---------|-------|
| CAP-010 | dashboards.solicitar | Funcionalidad auxiliar, no en flujo principal |
| CAP-011 | dashboards.personalizar | Funcionalidad auxiliar, no en flujo principal |
| CAP-022 | llamadas.ver_historial | Incluida en otras capacidades |
| CAP-023 | llamadas.exportar | Incluida en reportes.exportar |
| CAP-032 | clientes.crear | Incluida en clientes.editar |
| CAP-036 | clientes.eliminar | Nivel crítico, requiere aprobación especial |

**Recomendación:** Estas capacidades deben asignarse mediante permisos excepcionales individuales, no por grupos.

---

### Validación 2: Funciones Sin Cobertura

**Query de Validación:**
```sql
SELECT f.nombre_completo
FROM funciones f
WHERE NOT EXISTS (
 SELECT 1 FROM funcion_capacidades fc
 WHERE fc.funcion_id = f.id
);
```

**Resultado:** 0 funciones sin capacidades (100% cobertura)

---

### Validación 3: Grupos Sin Capacidades

**Query de Validación:**
```sql
SELECT gp.codigo, gp.nombre_display
FROM grupos_permisos gp
WHERE NOT EXISTS (
 SELECT 1 FROM grupo_capacidades gc
 WHERE gc.grupo_id = gp.id
);
```

**Resultado:** 0 grupos sin capacidades (100% cobertura)

---

## Matriz de Trazabilidad por Prioridad

### Prioridad 2: Funciones Core

| Función | Capacidades | Grupos | Cobertura |
|---------|-------------|--------|-----------|
| usuarios | 7 | 1 | 100% |
| dashboards | 4 | 1 | 50% (2/4 en grupos) |
| configuracion | 5 | 1 | 100% |
| **TOTAL P2** | **16** | **3 grupos** | **87.5%** |

---

### Prioridad 3: Módulos Operativos

| Función | Capacidades | Grupos | Cobertura |
|---------|-------------|--------|-----------|
| llamadas | 7 | 3 | 71.4% (5/7 en grupos) |
| tickets | 7 | 2 | 85.7% (6/7 en grupos) |
| clientes | 6 | 2 | 66.7% (4/6 en grupos) |
| metricas | 5 | 1 | 100% |
| reportes | 6 | 1 | 100% |
| alertas | 7 | 1 | 42.8% (3/7 en grupos) |
| **TOTAL P3** | **38** | **6 grupos** | **78.9%** |

---

### Prioridad 4: Módulos de Gestión

| Función | Capacidades | Grupos | Cobertura |
|---------|-------------|--------|-----------|
| equipos | 6 | 1 | 100% |
| horarios | 6 | 1 | 100% |
| evaluaciones | 6 | 1 | 100% |
| auditoria | 6 | 1 | 100% |
| **TOTAL P4** | **24** | **4 grupos** | **100%** |

---

## Trazabilidad Inversa: Casos de Uso → Grupos → Capacidades

### Caso de Uso UC-001: Ana López (Agente)

**Grupos Asignados:** atencion_cliente, visualizacion_basica

**Capacidades Totales:** 11

| Grupo | Capacidades | Detalle |
|-------|-------------|---------|
| atencion_cliente | 9 | CAP-017 a CAP-019, CAP-024 a CAP-026, CAP-029, CAP-031, CAP-033 |
| visualizacion_basica | 2 | CAP-008, CAP-009 |

**Funciones Utilizadas:** llamadas, tickets, clientes, dashboards

---

### Caso de Uso UC-002: Carlos Ruiz (Coordinador)

**Grupos Asignados:** atencion_cliente_avanzada, gestion_equipos, gestion_horarios, analisis_operativo

**Capacidades Totales:** 37

| Grupo | Capacidades | Detalle |
|-------|-------------|---------|
| atencion_cliente_avanzada | 16 | Todas de atencion_cliente + 7 avanzadas |
| gestion_equipos | 6 | CAP-055 a CAP-060 |
| gestion_horarios | 6 | CAP-061 a CAP-066 |
| analisis_operativo | 9 | CAP-037, CAP-038, CAP-042 a CAP-045, CAP-048 a CAP-050 |

**Funciones Utilizadas:** llamadas, tickets, clientes, equipos, horarios, metricas, reportes, alertas

---

### Caso de Uso UC-003: María Fernández (Analista Calidad)

**Grupos Asignados:** auditoria_llamadas, evaluacion_desempeno, analisis_operativo

**Capacidades Totales:** 21

| Grupo | Capacidades | Detalle |
|-------|-------------|---------|
| auditoria_llamadas | 6 | CAP-020, CAP-021, CAP-073 a CAP-076 |
| evaluacion_desempeno | 6 | CAP-067 a CAP-072 |
| analisis_operativo | 9 | CAP-037, CAP-038, CAP-042 a CAP-045, CAP-048 a CAP-050 |

**Funciones Utilizadas:** llamadas, auditoria, evaluaciones, metricas, reportes, alertas

---

### Caso de Uso UC-005: Laura Martínez (Admin Técnico)

**Grupos Asignados:** administracion_usuarios, configuracion_sistema, visualizacion_basica

**Capacidades Totales:** 14

| Grupo | Capacidades | Detalle |
|-------|-------------|---------|
| administracion_usuarios | 7 | CAP-001 a CAP-007 |
| configuracion_sistema | 5 | CAP-012 a CAP-016 |
| visualizacion_basica | 2 | CAP-008, CAP-009 |

**Funciones Utilizadas:** usuarios, configuracion, dashboards

---

## Métricas de Calidad de la Matriz

### Cobertura General

```
Total Funciones: 13
Funciones con Capacidades: 13 (100%)
Capacidades Totales: 78
Capacidades en Grupos: 72 (92.3%)
Capacidades Huérfanas: 6 (7.7%)
Grupos Funcionales: 10
Grupos con Capacidades: 10 (100%)
```

### Distribución de Niveles de Sensibilidad

```
Bajo (lectura): 26 capacidades (33.3%)
Normal (operativo): 31 capacidades (39.7%)
Alto (supervisión): 15 capacidades (19.2%)
Crítico (admin): 6 capacidades (7.7%)
```

### Capacidades que Requieren Auditoría

```
Con Auditoría: 48 capacidades (61.5%)
Sin Auditoría: 30 capacidades (38.5%)
```

**Análisis:** El 61.5% de capacidades requiere auditoría, lo cual es apropiado para un sistema de call center con requisitos de compliance.

---

## Recomendaciones

### 1. Capacidades Huérfanas (6)

**Acción:** Crear grupo adicional `personalizacion_avanzada` para:
- CAP-010: dashboards.solicitar
- CAP-011: dashboards.personalizar

**Acción:** Asignar mediante permisos excepcionales:
- CAP-036: clientes.eliminar (crítico)
- CAP-023: llamadas.exportar (incluir en analisis_operativo)
- CAP-022: llamadas.ver_historial (incluir en atencion_cliente_avanzada)
- CAP-032: clientes.crear (incluir en atencion_cliente_avanzada)

### 2. Optimización de Grupos

**Grupo `analisis_operativo`:** Usado por UC-002 y UC-003
- **Mantener:** Es correcto que coordinadores y analistas compartan métricas/reportes
- **Validar:** Verificar que alertas sean apropiadas para ambos roles

### 3. Auditoría

**Capacidades Críticas sin Auditoría:**
- Ninguna (todas las capacidades críticas tienen auditoría activada)

**Capacidades Normales sin Auditoría que deberían tenerla:**
- CAP-022: llamadas.ver_historial (acceso a datos sensibles)

---

## Scripts de Validación SQL

### Script 1: Verificar Integridad de la Matriz

```sql
-- 1. Capacidades huérfanas (sin grupo)
SELECT
 c.id,
 c.nombre_completo,
 c.nivel_sensibilidad,
 'SIN_GRUPO' as estado
FROM capacidades c
WHERE NOT EXISTS (
 SELECT 1 FROM grupo_capacidades gc
 WHERE gc.capacidad_id = c.id
)
ORDER BY c.nivel_sensibilidad DESC;

-- 2. Funciones sin capacidades
SELECT
 f.id,
 f.nombre_completo,
 'SIN_CAPACIDADES' as estado
FROM funciones f
WHERE NOT EXISTS (
 SELECT 1 FROM funcion_capacidades fc
 WHERE fc.funcion_id = f.id
);

-- 3. Grupos sin capacidades
SELECT
 gp.id,
 gp.codigo,
 gp.nombre_display,
 'SIN_CAPACIDADES' as estado
FROM grupos_permisos gp
WHERE NOT EXISTS (
 SELECT 1 FROM grupo_capacidades gc
 WHERE gc.grupo_id = gp.id
);
```

### Script 2: Generar Reporte de Cobertura

```sql
-- Reporte de cobertura por función
SELECT
 f.nombre_completo as funcion,
 COUNT(DISTINCT fc.capacidad_id) as total_capacidades,
 COUNT(DISTINCT gc.grupo_id) as grupos_que_usan,
 ROUND(
 COUNT(DISTINCT gc.grupo_id)::numeric /
 NULLIF(COUNT(DISTINCT fc.capacidad_id), 0) * 100,
 2
 ) as porcentaje_cobertura
FROM funciones f
LEFT JOIN funcion_capacidades fc ON f.id = fc.funcion_id
LEFT JOIN grupo_capacidades gc ON fc.capacidad_id = gc.capacidad_id
GROUP BY f.id, f.nombre_completo
ORDER BY porcentaje_cobertura DESC;
```

### Script 3: Validar Permisos de Usuario

```sql
-- Validar que un usuario tenga acceso a una capacidad específica
CREATE OR REPLACE FUNCTION validar_acceso_usuario(
 p_usuario_id INTEGER,
 p_capacidad_nombre VARCHAR
) RETURNS TABLE (
 tiene_acceso BOOLEAN,
 via_grupo VARCHAR,
 via_excepcion BOOLEAN
) AS $$
BEGIN
 RETURN QUERY
 SELECT
 CASE
 WHEN COUNT(*) > 0 THEN TRUE
 ELSE FALSE
 END as tiene_acceso,
 STRING_AGG(DISTINCT gp.nombre_display, ', ') as via_grupo,
 EXISTS(
 SELECT 1 FROM permisos_excepcionales pe
 JOIN capacidades c2 ON pe.capacidad_id = c2.id
 WHERE pe.usuario_id = p_usuario_id
 AND c2.nombre_completo = p_capacidad_nombre
 AND pe.tipo = 'conceder'
 AND pe.activo = TRUE
 ) as via_excepcion
 FROM vista_capacidades_usuario vcu
 LEFT JOIN usuarios_grupos ug ON vcu.usuario_id = ug.usuario_id AND ug.activo = TRUE
 LEFT JOIN grupos_permisos gp ON ug.grupo_id = gp.id
 WHERE vcu.usuario_id = p_usuario_id
 AND vcu.capacidad = p_capacidad_nombre;
END;
$$ LANGUAGE plpgsql;
```

---

## Diagrama de Trazabilidad

```mermaid
graph TB
 subgraph Funciones[13 Funciones]
 F1[usuarios<br>7 cap]
 F2[dashboards<br>4 cap]
 F3[configuracion<br>5 cap]
 F4[llamadas<br>7 cap]
 F5[tickets<br>7 cap]
 F6[clientes<br>6 cap]
 F7[metricas<br>5 cap]
 F8[reportes<br>6 cap]
 F9[alertas<br>7 cap]
 F10[equipos<br>6 cap]
 F11[horarios<br>6 cap]
 F12[evaluaciones<br>6 cap]
 F13[auditoria<br>6 cap]
 end

 subgraph Grupos[10 Grupos Funcionales]
 G1[administracion_usuarios<br>7 cap]
 G2[visualizacion_basica<br>2 cap]
 G3[configuracion_sistema<br>5 cap]
 G4[atencion_cliente<br>9 cap]
 G5[atencion_cliente_avanzada<br>16 cap]
 G6[analisis_operativo<br>9 cap]
 G7[gestion_equipos<br>6 cap]
 G8[gestion_horarios<br>6 cap]
 G9[auditoria_llamadas<br>6 cap]
 G10[evaluacion_desempeno<br>6 cap]
 end

 subgraph Usuarios[5 Casos de Uso]
 U1[Ana López<br>11 cap]
 U2[Carlos Ruiz<br>37 cap]
 U3[María Fernández<br>21 cap]
 U5[Laura Martínez<br>14 cap]
 end

 F1 --> G1
 F2 --> G2
 F3 --> G3
 F4 --> G4
 F4 --> G5
 F4 --> G9
 F5 --> G4
 F5 --> G5
 F6 --> G4
 F6 --> G5
 F7 --> G6
 F8 --> G6
 F9 --> G6
 F10 --> G7
 F11 --> G8
 F12 --> G10
 F13 --> G9

 G2 --> U1
 G4 --> U1
 G5 --> U2
 G6 --> U2
 G6 --> U3
 G7 --> U2
 G8 --> U2
 G9 --> U3
 G10 --> U3
 G1 --> U5
 G3 --> U5
 G2 --> U5

 style F1 fill:#8B5CF6
 style F2 fill:#10B981
 style F3 fill:#EF4444
 style F4 fill:#3B82F6
 style F5 fill:#3B82F6
 style F6 fill:#3B82F6
 style F7 fill:#F59E0B
 style F8 fill:#F59E0B
 style F9 fill:#F59E0B
 style F10 fill:#EC4899
 style F11 fill:#EC4899
 style F12 fill:#14B8A6
 style F13 fill:#14B8A6
```

---

## Conclusión

Esta matriz de trazabilidad completa demuestra que:

1. **Cobertura del 100%** de funciones con capacidades
2. **Cobertura del 92.3%** de capacidades asignadas a grupos
3. **Cobertura del 100%** de grupos con capacidades
4. **6 capacidades huérfanas** identificadas y justificadas
5. **10 grupos funcionales** cubren las necesidades de 5 perfiles de usuario distintos
6. **Sin jerarquías:** Cada grupo es independiente y combinable

**Validaciones Exitosas:**
- No hay funciones sin capacidades
- No hay grupos vacíos
- Todos los casos de uso tienen grupos asignados
- Auditoría aplicada correctamente a capacidades sensibles

**Próximos Pasos:**
1. Asignar las 6 capacidades huérfanas
2. Validar matriz con usuarios reales
3. Implementar en base de datos PostgreSQL
4. Crear dashboard de trazabilidad en tiempo real

---

**Documento:** Matriz de Trazabilidad del Sistema de Permisos Granular
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0
**Estado:** Completo

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Creación inicial - Trazabilidad completa de 13 funciones, 78 capacidades, 10 grupos | equipo-arquitectura |
