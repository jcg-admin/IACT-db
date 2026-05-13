---
id: DOC-REQ-CATALOGO-GRUPOS
tipo: catalogo
titulo: Catálogo de Grupos Funcionales
version: 1.0.0
fecha_creacion: 2025-11-07
estado: completo
propietario: equipo-backend
relacionados: ["INDICE_MAESTRO_PERMISOS_GRANULAR", "prioridad_02_funciones_core", "prioridad_03_modulos_operativos", "prioridad_04_modulos_gestion"]
date: 2025-11-13
---

# Catálogo de Grupos Funcionales

**Proyecto:** Sistema de Permisos Granular
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0

---

## Introducción

Este documento cataloga los **10 grupos funcionales** definidos en el sistema de permisos granular. Cada grupo agrupa capacidades relacionadas sin establecer jerarquías.

**Filosofía:**
- **NO** hay roles jerárquicos ("Admin", "Supervisor", "Agente")
- **SÍ** hay grupos descriptivos ("Atención al Cliente", "Gestión de Equipos")
- Un usuario puede tener **múltiples grupos simultáneamente**
- Los grupos son **iguales entre sí**, solo agrupan capacidades diferentes

---

## Resumen Ejecutivo

| Categoría | Grupos | Capacidades Totales | Usuarios Típicos |
|-----------|--------|-------------------|------------------|
| **Técnicos** | 3 | 13 | Administradores de sistema |
| **Operativos** | 3 | 34 | Agentes de atención al cliente |
| **Gestión** | 4 | 31 | Coordinadores y supervisores |
| **TOTAL** | **10** | **78** | Todos los usuarios |

---

## Grupos por Categoría

### CATEGORÍA: Técnicos

Grupos para administración técnica del sistema.

#### 1. administracion_usuarios

```yaml
codigo: administracion_usuarios
nombre_display: Administración de Usuarios
tipo_acceso: tecnico
color_hex: "#3B82F6"
icono: users-cog
```

**Propósito:** Gestión completa de cuentas de usuario y asignación de permisos.

**Capacidades (6):**
1. sistema.administracion.usuarios.ver
2. sistema.administracion.usuarios.crear
3. sistema.administracion.usuarios.editar
4. sistema.administracion.usuarios.suspender
5. sistema.administracion.usuarios.reactivar
6. sistema.administracion.usuarios.asignar_grupos

**Usuarios típicos:**
- Administradores de sistema
- Gestores de cuentas

**Casos de uso:**
- Crear nuevas cuentas de usuario
- Asignar grupos de permisos
- Suspender usuarios que violan políticas
- Reactivar cuentas suspendidas

---

#### 2. visualizacion_basica

```yaml
codigo: visualizacion_basica
nombre_display: Visualización Básica
tipo_acceso: operativo
color_hex: "#10B981"
icono: eye
```

**Propósito:** Acceso de solo lectura a dashboards del sistema.

**Capacidades (2):**
1. sistema.vistas.dashboards.ver
2. sistema.vistas.dashboards.personalizar

**Usuarios típicos:**
- Todos los usuarios del sistema
- Personal administrativo
- Consultores externos con acceso limitado

**Casos de uso:**
- Ver métricas generales del sistema
- Personalizar widgets de dashboard personal
- Monitorear estado general sin realizar acciones

---

#### 3. configuracion_sistema

```yaml
codigo: configuracion_sistema
nombre_display: Configuración del Sistema
tipo_acceso: tecnico
color_hex: "#EF4444"
icono: cog
```

**Propósito:** Gestión de parámetros y configuración técnica del sistema.

**Capacidades (5):**
1. sistema.tecnico.configuracion.ver
2. sistema.tecnico.configuracion.editar
3. sistema.tecnico.configuracion.exportar
4. sistema.tecnico.configuracion.importar
5. sistema.tecnico.configuracion.restaurar

**Usuarios típicos:**
- Administradores técnicos
- DevOps
- Arquitectos de sistema

**Casos de uso:**
- Modificar parámetros de configuración
- Exportar configuración para backup
- Importar configuración en ambiente nuevo
- Restaurar valores por defecto tras error

---

### CATEGORÍA: Operativos

Grupos para operaciones diarias de atención al cliente.

#### 4. atencion_cliente

```yaml
codigo: atencion_cliente
nombre_display: Atención al Cliente
tipo_acceso: operativo
color_hex: "#10B981"
icono: headset
```

**Propósito:** Operaciones básicas de call center: llamadas, tickets, clientes.

**Capacidades (9):**
1. sistema.operaciones.llamadas.ver
2. sistema.operaciones.llamadas.realizar
3. sistema.operaciones.llamadas.recibir
4. sistema.operaciones.tickets.ver
5. sistema.operaciones.tickets.crear
6. sistema.operaciones.tickets.editar
7. sistema.operaciones.clientes.ver
8. sistema.operaciones.clientes.ver_historial
9. sistema.vistas.dashboards.ver

**Usuarios típicos:**
- Agentes de call center
- Personal de atención al cliente nivel básico

**Casos de uso:**
- Recibir llamadas entrantes
- Crear tickets de soporte
- Consultar información de clientes
- Ver dashboard con métricas personales

**Limitaciones:**
- NO puede cerrar tickets (solo crear/editar)
- NO puede escuchar grabaciones
- NO puede transferir llamadas

---

#### 5. atencion_cliente_avanzada

```yaml
codigo: atencion_cliente_avanzada
nombre_display: Atención al Cliente Avanzada
tipo_acceso: operativo
color_hex: "#3B82F6"
icono: headset-check
```

**Propósito:** Atención con capacidades adicionales (cerrar tickets, escuchar grabaciones, transferir).

**Capacidades (16):**

**Llamadas:**
1. sistema.operaciones.llamadas.ver
2. sistema.operaciones.llamadas.realizar
3. sistema.operaciones.llamadas.recibir
4. sistema.operaciones.llamadas.transferir
5. sistema.operaciones.llamadas.escuchar_grabaciones

**Tickets:**
6. sistema.operaciones.tickets.ver
7. sistema.operaciones.tickets.crear
8. sistema.operaciones.tickets.editar
9. sistema.operaciones.tickets.asignar
10. sistema.operaciones.tickets.cerrar

**Clientes:**
11. sistema.operaciones.clientes.ver
12. sistema.operaciones.clientes.crear
13. sistema.operaciones.clientes.editar
14. sistema.operaciones.clientes.ver_historial

**Dashboards:**
15. sistema.vistas.dashboards.ver
16. sistema.vistas.dashboards.exportar

**Usuarios típicos:**
- Agentes senior
- Especialistas de soporte
- Personal con mayor experiencia

**Casos de uso:**
- Cerrar tickets resueltos
- Escuchar grabaciones para contexto
- Transferir llamadas complejas a especialistas
- Registrar nuevos clientes en el sistema

---

#### 6. analisis_operativo

```yaml
codigo: analisis_operativo
nombre_display: Análisis Operativo
tipo_acceso: gestion
color_hex: "#F59E0B"
icono: chart-bar
```

**Propósito:** Acceso a métricas, reportes y alertas del sistema.

**Capacidades (9):**

**Métricas:**
1. sistema.analisis.metricas.ver
2. sistema.analisis.metricas.ver_detalladas
3. sistema.analisis.metricas.exportar

**Reportes:**
4. sistema.analisis.reportes.ver
5. sistema.analisis.reportes.generar
6. sistema.analisis.reportes.exportar

**Alertas:**
7. sistema.monitoreo.alertas.ver

**Dashboards:**
8. sistema.vistas.dashboards.ver
9. sistema.vistas.dashboards.exportar

**Usuarios típicos:**
- Analistas de datos
- Controllers
- Gerentes operativos

**Casos de uso:**
- Generar reportes de rendimiento mensual
- Exportar métricas para presentaciones
- Monitorear alertas de performance
- Analizar tendencias operacionales

---

### CATEGORÍA: Gestión

Grupos para supervisión de equipos y gestión de calidad.

#### 7. gestion_equipos

```yaml
codigo: gestion_equipos
nombre_display: Gestión de Equipos
tipo_acceso: gestion
color_hex: "#8B5CF6"
icono: users-cog
```

**Propósito:** Administración completa de equipos de trabajo.

**Capacidades (5):**
1. sistema.supervision.equipos.ver
2. sistema.supervision.equipos.crear
3. sistema.supervision.equipos.editar
4. sistema.supervision.equipos.asignar_miembros
5. sistema.supervision.equipos.ver_metricas

**Usuarios típicos:**
- Coordinadores de equipos
- Supervisores
- Gerentes de operaciones

**Casos de uso:**
- Crear nuevos equipos de trabajo
- Asignar agentes a equipos
- Reorganizar equipos según demanda
- Monitorear métricas de equipo

---

#### 8. gestion_horarios

```yaml
codigo: gestion_horarios
nombre_display: Gestión de Horarios
tipo_acceso: gestion
color_hex: "#EC4899"
icono: calendar
```

**Propósito:** Planificación y aprobación de turnos de trabajo.

**Capacidades (5):**
1. sistema.supervision.horarios.ver
2. sistema.supervision.horarios.crear
3. sistema.supervision.horarios.editar
4. sistema.supervision.horarios.aprobar
5. sistema.supervision.horarios.exportar

**Usuarios típicos:**
- Planificadores de turnos
- Supervisores
- Recursos humanos

**Casos de uso:**
- Crear turnos semanales
- Aprobar cambios de horario
- Exportar horarios para nómina
- Gestionar coberturas de emergencia

---

#### 9. auditoria_llamadas

```yaml
codigo: auditoria_llamadas
nombre_display: Auditoría de Llamadas
tipo_acceso: gestion
color_hex: "#06B6D4"
icono: search-check
```

**Propósito:** Auditoría de calidad de llamadas y tickets.

**Capacidades (8):**

**Auditoría:**
1. sistema.calidad.auditoria.ver
2. sistema.calidad.auditoria.auditar_llamadas
3. sistema.calidad.auditoria.auditar_tickets
4. sistema.calidad.auditoria.ver_reportes
5. sistema.calidad.auditoria.exportar

**Acceso a datos:**
6. sistema.operaciones.llamadas.ver
7. sistema.operaciones.llamadas.escuchar_grabaciones
8. sistema.operaciones.tickets.ver

**Usuarios típicos:**
- Analistas de calidad
- Auditores internos
- Especialistas en QA

**Casos de uso:**
- Auditar llamadas aleatoriamente
- Evaluar calidad de atención
- Escuchar grabaciones para análisis
- Generar reportes de calidad

---

#### 10. evaluacion_desempeno

```yaml
codigo: evaluacion_desempeno
nombre_display: Evaluación de Desempeño
tipo_acceso: gestion
color_hex: "#F97316"
icono: clipboard-check
```

**Propósito:** Evaluación y seguimiento de desempeño de agentes.

**Capacidades (7):**

**Evaluaciones:**
1. sistema.calidad.evaluaciones.ver
2. sistema.calidad.evaluaciones.crear
3. sistema.calidad.evaluaciones.editar
4. sistema.calidad.evaluaciones.aprobar
5. sistema.calidad.evaluaciones.ver_historico

**Análisis:**
6. sistema.analisis.metricas.ver
7. sistema.analisis.reportes.ver

**Usuarios típicos:**
- Supervisores
- Gerentes de recursos humanos
- Líderes de equipo

**Casos de uso:**
- Crear evaluaciones trimestrales
- Aprobar evaluaciones de supervisores
- Ver histórico de desempeño de agente
- Analizar métricas para evaluación

---

## Matriz de Grupos y Capacidades

### Resumen por Grupo

| Grupo | Capacidades | Funciones Cubiertas | Nivel Acceso |
|-------|-------------|-------------------|--------------|
| administracion_usuarios | 6 | usuarios | Crítico |
| visualizacion_basica | 2 | dashboards | Lectura |
| configuracion_sistema | 5 | configuración | Crítico |
| atencion_cliente | 9 | llamadas, tickets, clientes, dashboards | Básico |
| atencion_cliente_avanzada | 16 | llamadas, tickets, clientes, dashboards | Avanzado |
| analisis_operativo | 9 | métricas, reportes, alertas, dashboards | Análisis |
| gestion_equipos | 5 | equipos | Gestión |
| gestion_horarios | 5 | horarios | Gestión |
| auditoria_llamadas | 8 | auditoría, llamadas, tickets | QA |
| evaluacion_desempeno | 7 | evaluaciones, métricas, reportes | RRHH |

---

## Ejemplos de Asignación

### Ejemplo 1: Agente de Call Center Nuevo

```
Usuario: Ana López
Grupos Asignados:
 visualizacion_basica
 atencion_cliente

Puede:
- Ver su dashboard personal
- Recibir y realizar llamadas
- Crear tickets
- Consultar clientes

No puede:
- Cerrar tickets
- Escuchar grabaciones
- Transferir llamadas
- Gestionar equipos
```

### Ejemplo 2: Agente Senior

```
Usuario: Carlos Ruiz
Grupos Asignados:
 visualizacion_basica
 atencion_cliente_avanzada

Puede:
- Todo lo de agente nuevo
- Cerrar tickets
- Escuchar grabaciones
- Transferir llamadas
- Exportar dashboards

No puede:
- Gestionar equipos
- Aprobar horarios
- Realizar auditorías
```

### Ejemplo 3: Coordinador de Equipo

```
Usuario: María Fernández
Grupos Asignados:
 visualizacion_basica
 atencion_cliente_avanzada
 gestion_equipos
 gestion_horarios
 analisis_operativo

Puede:
- Todo lo de agente senior
- Crear y gestionar equipos
- Planificar y aprobar horarios
- Ver métricas avanzadas
- Generar reportes

No puede:
- Crear usuarios del sistema
- Modificar configuración técnica
- Realizar auditorías de calidad
```

### Ejemplo 4: Analista de Calidad

```
Usuario: Roberto Díaz
Grupos Asignados:
 visualizacion_basica
 auditoria_llamadas
 evaluacion_desempeno

Puede:
- Ver dashboards
- Auditar llamadas y tickets
- Escuchar grabaciones
- Crear evaluaciones de desempeño
- Ver métricas de calidad

No puede:
- Gestionar equipos
- Aprobar horarios
- Cerrar tickets
- Realizar llamadas
```

### Ejemplo 5: Administrador Técnico

```
Usuario: Laura Martínez
Grupos Asignados:
 administracion_usuarios
 configuracion_sistema
 visualizacion_basica

Puede:
- Crear y gestionar usuarios
- Asignar grupos de permisos
- Modificar configuración del sistema
- Exportar/importar configuración
- Ver dashboards

No puede:
- Realizar operaciones de call center
- Gestionar equipos operativos
- Auditar llamadas
- Aprobar horarios
```

---

## Combinaciones Comunes

### Para Call Center

| Perfil | Grupos | Capacidades Total |
|--------|--------|------------------|
| Agente Nuevo | visualizacion_basica + atencion_cliente | 11 |
| Agente Senior | visualizacion_basica + atencion_cliente_avanzada | 18 |
| Coordinador | visualizacion_basica + atencion_cliente_avanzada + gestion_equipos + gestion_horarios + analisis_operativo | 37 |

### Para Calidad

| Perfil | Grupos | Capacidades Total |
|--------|--------|------------------|
| Auditor QA | visualizacion_basica + auditoria_llamadas | 10 |
| Especialista RRHH | visualizacion_basica + evaluacion_desempeno | 9 |
| Gerente Calidad | visualizacion_basica + auditoria_llamadas + evaluacion_desempeno + analisis_operativo | 24 |

### Para Administración

| Perfil | Grupos | Capacidades Total |
|--------|--------|------------------|
| Admin Técnico | administracion_usuarios + configuracion_sistema + visualizacion_basica | 13 |
| Analista | visualizacion_basica + analisis_operativo | 11 |

---

## Ventajas del Sistema

### vs. RBAC Tradicional

| Aspecto | RBAC Tradicional | Grupos Funcionales |
|---------|------------------|-------------------|
| Asignación | 1 rol por usuario | N grupos por usuario |
| Nomenclatura | "Admin", "Supervisor", "Agente" | "Gestión de Equipos", "Atención al Cliente" |
| Jerarquía | Rígida y visible | No existe |
| Flexibilidad | Baja | Alta |
| Cambios | Cambiar todo el rol | Agregar/quitar grupos específicos |
| Claridad | Confusa ("¿Qué hace un Supervisor?") | Descriptiva ("Gestión de Equipos") |

---

## Scripts de Validación

### Verificar todos los grupos creados

```sql
SELECT
 codigo,
 nombre_display,
 tipo_acceso,
 COUNT(gc.id) AS capacidades_count
FROM grupos_permisos gp
LEFT JOIN grupo_capacidades gc ON gp.id = gc.grupo_id
WHERE activo = TRUE
GROUP BY codigo, nombre_display, tipo_acceso
ORDER BY tipo_acceso, codigo;
```

### Ver capacidades por grupo específico

```sql
SELECT
 gp.codigo AS grupo,
 c.nombre_completo AS capacidad,
 c.nivel_sensibilidad
FROM grupos_permisos gp
JOIN grupo_capacidades gc ON gp.id = gc.grupo_id
JOIN capacidades c ON gc.capacidad_id = c.id
WHERE gp.codigo = 'atencion_cliente_avanzada'
ORDER BY c.nombre_completo;
```

### Usuarios por grupo

```sql
SELECT
 gp.codigo AS grupo,
 COUNT(DISTINCT ug.usuario_id) AS usuarios_count
FROM grupos_permisos gp
LEFT JOIN usuarios_grupos ug ON gp.id = ug.grupo_id AND ug.activo = TRUE
GROUP BY gp.codigo
ORDER BY usuarios_count DESC;
```

---

## Próximos Pasos

1. Asignar grupos iniciales a usuarios existentes
2. Crear UI para gestión de grupos
3. Documentar casos de uso adicionales
4. Capacitar a usuarios en el modelo de grupos funcionales

---

**Documento:** Catálogo de Grupos Funcionales
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0
**Estado:** Completo

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Creación inicial - 10 grupos funcionales | equipo-ba |
