---
id: DOC-REQ-INDICE-MAESTRO-PERMISOS
tipo: documento_maestro
titulo: Índice Maestro - Sistema de Permisos Granular
version: 1.0.0
fecha_creacion: 2025-11-07
estado: completo
propietario: equipo-backend
estandares: ["ISO/IEC/IEEE 29148:2018", "BABOK v3"]
relacionados: ["DOC-REQ-BACKEND", "RF-001", "RF-002", "RF-003", "RF-004"]
date: 2025-11-13
---

# ÍNDICE MAESTRO: Sistema de Permisos Granular

**Proyecto:** Sistema de Permisos basado en Grupos Funcionales
**Fase:** Definición y Arquitectura
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0

---

## Visión General del Proyecto

Sistema de permisos granular que **elimina roles jerárquicos tradicionales** y los reemplaza con **grupos funcionales descriptivos** que se pueden combinar libremente.

### Filosofía Central

**NO más:**
- Etiquetas pretenciosas: "Agente", "Supervisor", "Director", "Admin"
- Jerarquías rígidas de poder
- Un solo rol por usuario

**SÍ tenemos:**
- Grupos descriptivos: "Atención al Cliente", "Gestión de Equipos"
- Permisos combinables y flexibles
- Múltiples grupos simultáneos por usuario
- Descripción clara de QUÉ PUEDE HACER cada persona

---

## Documentos del Proyecto

### 01 - Prioridad 1: Estructura Base de Datos
**[CRÍTICA] - Sin esto, nada funciona**

**Ubicación:** `./prioridad_01_estructura_base_datos.md`

#### Contenido:
- 8 tablas principales del sistema
- Vistas auxiliares y funciones
- Índices de performance
- Scripts de validación
- Datos de prueba

#### Tablas Implementadas:
1. `funciones` - Recursos del sistema
2. `capacidades` - Acciones sobre recursos
3. `funcion_capacidades` - Relación N:M
4. `grupos_permisos` - Agrupaciones sin jerarquía
5. `grupo_capacidades` - Relación N:M
6. `usuarios_grupos` - Asignación múltiple
7. `permisos_excepcionales` - Sobrescritura individual
8. `auditoria_permisos` - Log completo

#### Tiempo Estimado: 1 semana

---

### 02 - Prioridad 2: Funciones Core
**[ALTA] - Transversales a todo**

**Ubicación:** `./prioridad_02_funciones_core.md`

#### Contenido:
- 3 funciones esenciales
- Datos semilla completos
- Pseudocódigo de servicios
- APIs REST definidas
- Grupos de permisos asociados

#### Funciones Implementadas:
1. **Usuarios** (`sistema.administracion.usuarios`)
 - 7 capacidades
 - CRUD completo + suspensión/reactivación

2. **Dashboards** (`sistema.vistas.dashboards`)
 - 4 capacidades
 - Visualización + personalización

3. **Configuración** (`sistema.tecnico.configuracion`)
 - 5 capacidades
 - Gestión de parámetros del sistema

#### Grupos Creados:
- `administracion_usuarios`
- `visualizacion_basica`
- `configuracion_sistema`

#### Tiempo Estimado: 1 semana

---

### 03 - Prioridad 3: Módulos Operativos
**[MEDIA-ALTA] - Día a día operativo**

**Ubicación:** `./prioridad_03_modulos_operativos.md`

#### Contenido:
- 6 módulos operacionales
- Integraciones entre módulos
- Sistema de caché para métricas
- Pseudocódigo de servicios clave

#### Módulos Implementados:
1. **Llamadas IVR** - 7 capacidades
2. **Tickets** - 7 capacidades
3. **Clientes** - 6 capacidades
4. **Métricas** - 5 capacidades
5. **Reportes** - 6 capacidades
6. **Alertas** - 7 capacidades

#### Grupos Creados:
- `atencion_cliente`
- `atencion_cliente_avanzada`
- `analisis_operativo`

#### Tiempo Estimado: 1 semana

---

### 04 - Prioridad 4: Módulos de Gestión
**[MEDIA] - Gestión de equipos y calidad**

**Ubicación:** `./prioridad_04_modulos_gestion.md`

#### Contenido:
- 4 módulos de gestión
- Sistema de evaluaciones
- Gestión de horarios
- Auditoría de calidad

#### Módulos Implementados:
1. **Equipos** - 6 capacidades
2. **Horarios** - 6 capacidades
3. **Evaluaciones** - 6 capacidades
4. **Auditoría** - 6 capacidades

#### Grupos Creados:
- `gestion_equipos`
- `gestion_horarios`
- `auditoria_llamadas`
- `evaluacion_desempeno`

#### Tiempo Estimado: 1 semana

---

### 05 - Prioridad 5: Módulos Financieros
**[MEDIA] - Gestión financiera**

**Ubicación:** `./prioridad_05_modulos_financieros.md`

#### Contenido:
- 3 módulos financieros
- Integración con pasarelas de pago
- Sistema de facturación
- Gestión de cobranza

#### Módulos Implementados:
1. **Pagos** - 6 capacidades
2. **Facturas** - 6 capacidades
3. **Cobranza** - 5 capacidades

#### Grupos Creados:
- `gestion_pagos`
- `aprobacion_pagos`
- `gestion_facturacion`
- `gestion_cobranza`

#### Tiempo Estimado: 1 semana

---

### 06 - Prioridad 6: Módulos Estratégicos
**[BAJA] - Decisiones estratégicas**

**Ubicación:** `./prioridad_06_modulos_estrategicos.md`

#### Contenido:
- 3 módulos estratégicos
- Sistema de presupuestos
- Gestión de políticas
- Manejo de excepciones

#### Módulos Implementados:
1. **Presupuestos** - 7 capacidades
2. **Políticas** - 6 capacidades
3. **Excepciones** - 6 capacidades

#### Grupos Creados:
- `gestion_presupuestos`
- `aprobacion_presupuestos`
- `gestion_politicas`
- `aprobacion_excepciones`

#### Tiempo Estimado: 1 semana

---

## Resumen Ejecutivo

### Estadísticas del Sistema Completo

| Categoría | Cantidad |
|-----------|----------|
| **Tablas de Base de Datos** | 8 principales |
| **Funciones (Recursos)** | 19 |
| **Capacidades (Acciones)** | ~130 |
| **Grupos de Permisos Predefinidos** | 17+ |
| **Dominios Organizacionales** | 10 |
| **Endpoints API** | 50+ |

### Dominios del Sistema

1. **vistas** - Dashboards y visualizaciones
2. **administracion** - Gestión de usuarios
3. **analisis** - Métricas y reportes
4. **monitoreo** - Alertas y seguimiento
5. **operaciones** - Llamadas, tickets, clientes
6. **finanzas** - Pagos, facturas, cobranza
7. **calidad** - Auditoría y evaluaciones
8. **supervision** - Equipos, horarios, excepciones
9. **direccion** - Presupuestos y políticas
10. **tecnico** - Configuración del sistema

---

## Mapeo con Arquitectura Existente

### Módulos Backend Actuales (apps Django)

| Módulo Documento | Módulo Django Existente | Estado | Acción |
|------------------|-------------------------|--------|--------|
| Usuarios | `users` | Existe | Extender |
| Dashboards | `dashboard` | Existe | Extender |
| Llamadas IVR | `ivr_legacy` | Existe | Extender |
| Reportes | `reports` | Existe | Extender |
| Métricas | `analytics` | Existe | Extender |
| Alertas | `notifications` | Existe | Extender |
| Auditoría | `audit` | Existe | Extender |
| Configuración | `common` | Existe | Extender |
| ETL | `etl` | Existe | Mantener |
| Tickets | - | No existe | Crear nuevo |
| Clientes | - | No existe | Crear nuevo |
| Equipos | - | No existe | Crear nuevo |
| Horarios | - | No existe | Crear nuevo |
| Evaluaciones | - | No existe | Crear nuevo |
| Pagos | - | No existe | Crear nuevo |
| Facturas | - | No existe | Crear nuevo |
| Cobranza | - | No existe | Crear nuevo |
| Presupuestos | - | No existe | Crear nuevo |
| Políticas | - | No existe | Crear nuevo |
| Excepciones | - | No existe | Crear nuevo |

---

## Cronograma de Implementación

### Fase 1: Fundamentos (Semanas 1-2)
```
Semana 1: Prioridad 1 - Estructura Base
 Base de datos completa + vistas + funciones

Semana 2: Prioridad 2 - Funciones Core
 Usuarios + Dashboards + Configuración
```

### Fase 2: Operaciones (Semanas 3-4)
```
Semana 3: Prioridad 3 - Módulos Operativos
 Llamadas + Tickets + Clientes + Métricas + Reportes + Alertas

Semana 4: Prioridad 4 - Módulos de Gestión (Parte 1)
 Equipos + Horarios
```

### Fase 3: Gestión y Finanzas (Semanas 5-6)
```
Semana 5: Prioridad 4 - Módulos de Gestión (Parte 2)
 Evaluaciones + Auditoría

Semana 6: Prioridad 5 - Módulos Financieros
 Pagos + Facturas + Cobranza
```

### Fase 4: Estrategia (Semana 7)
```
Semana 7: Prioridad 6 - Módulos Estratégicos
 Presupuestos + Políticas + Excepciones
```

### Fase 5: Finalización (Semanas 8-11)
```
Semana 8: Estabilización
 Testing + Performance + Security

Semana 9: Documentación
 Manuales + Guías + Videos

Semana 10: Capacitación
 Training de usuarios

Semana 11: Go Live
 Deploy + Monitoreo + Soporte
```

**Duración Total:** 11 semanas (~2.5 meses)

---

## Grupos de Permisos - Catálogo Completo

### Operativos
1. `atencion_cliente` - Operaciones básicas
2. `atencion_cliente_avanzada` - Con cierre y escalamiento
3. `analisis_operativo` - Métricas y reportes

### Gestión
4. `gestion_equipos` - Administración de equipos
5. `gestion_horarios` - Planificación de turnos
6. `aprobacion_excepciones` - Manejo de casos especiales

### Calidad
7. `auditoria_llamadas` - Evaluación de interacciones
8. `evaluacion_desempeno` - Evaluaciones de personal

### Finanzas
9. `gestion_pagos` - Procesamiento de transacciones
10. `aprobacion_pagos` - Autorización financiera
11. `gestion_facturacion` - Emisión de facturas
12. `gestion_cobranza` - Cuentas por cobrar

### Estratégicos
13. `gestion_presupuestos` - Planificación financiera
14. `aprobacion_presupuestos` - Autorización de presupuestos
15. `gestion_politicas` - Definición de políticas

### Técnicos
16. `administracion_usuarios` - Gestión de cuentas
17. `configuracion_sistema` - Parámetros técnicos
18. `visualizacion_basica` - Acceso de lectura

---

## Casos de Uso Reales

### Caso 1: Usuario de Atención al Cliente
```
Nombre: Ana López
Grupos:
 atencion_cliente
 visualizacion_basica

Puede:
- Realizar y recibir llamadas
- Crear y editar tickets
- Ver información de clientes
- Ver su dashboard personal

No puede:
- Cerrar tickets
- Escuchar grabaciones
- Gestionar equipos
- Aprobar nada
```

### Caso 2: Coordinador de Equipo
```
Nombre: Carlos Ruiz
Grupos:
 atencion_cliente_avanzada
 gestion_equipos
 gestion_horarios
 analisis_operativo

Puede:
- Todo de atención al cliente avanzada
- Gestionar su equipo
- Crear y aprobar horarios
- Ver métricas avanzadas
- Generar reportes

No puede:
- Gestionar pagos
- Crear usuarios del sistema
- Modificar configuración
```

### Caso 3: Analista de Calidad
```
Nombre: María Fernández
Grupos:
 auditoria_llamadas
 evaluacion_desempeno
 analisis_operativo

Puede:
- Auditar llamadas
- Escuchar grabaciones
- Crear evaluaciones
- Ver métricas de calidad
- Generar reportes

No puede:
- Gestionar equipos
- Aprobar horarios
- Gestionar pagos
```

### Caso 4: Responsable Financiero
```
Nombre: Roberto Díaz
Grupos:
 gestion_pagos
 aprobacion_pagos
 gestion_facturacion
 gestion_cobranza
 gestion_presupuestos

Puede:
- Procesar y aprobar pagos
- Generar facturas
- Gestionar cobranza
- Crear presupuestos
- Ver reportes financieros

No puede:
- Gestionar usuarios
- Modificar configuración
- Auditar llamadas
```

### Caso 5: Administrador Técnico
```
Nombre: Laura Martínez
Grupos:
 administracion_usuarios
 configuracion_sistema
 visualizacion_basica

Puede:
- Crear y gestionar usuarios
- Asignar grupos de permisos
- Modificar configuración
- Ver dashboards
- Exportar datos del sistema

No puede:
- Procesar pagos
- Gestionar operaciones
- Aprobar presupuestos
```

---

## Ventajas del Sistema

### vs. Sistema de Roles Tradicional

| Aspecto | Roles Tradicionales | Grupos Funcionales |
|---------|---------------------|-------------------|
| **Nomenclatura** | "Admin", "Supervisor", "Agente" | "Gestión de Equipos", "Atención al Cliente" |
| **Flexibilidad** | Un rol a la vez | Múltiples grupos combinables |
| **Escalabilidad** | Difícil agregar roles | Fácil crear nuevos grupos |
| **Claridad** | "¿Qué hace un Supervisor?" | Descripción funcional clara |
| **Jerarquía** | Implícita y visible | No existe |
| **Mantenimiento** | Roles monolíticos | Grupos modulares |
| **Cambios** | Cambiar de rol completo | Agregar/quitar grupos específicos |

---

## Quick Start

### Para Implementar el Sistema:

1. **Semana 1:** Ejecutar `prioridad_01_estructura_base_datos.md`
 ```bash
 # Crear todas las tablas
 # Crear vistas y funciones
 # Insertar datos de prueba
 ```

2. **Semana 2:** Ejecutar `prioridad_02_funciones_core.md`
 ```bash
 # Insertar funciones: usuarios, dashboards, configuracion
 # Crear grupos: administracion_usuarios, visualizacion_basica
 # Implementar servicios backend
 ```

3. **Semanas 3-7:** Seguir prioridades 3-6 en orden

4. **Semanas 8-11:** Estabilización, documentación, capacitación, go-live

---

## Guías de Referencia Rápida

### Cómo agregar un nuevo recurso/función

1. Insertar en tabla `funciones`
2. Crear capacidades asociadas en tabla `capacidades`
3. Relacionar en `funcion_capacidades`
4. Crear o actualizar grupos de permisos
5. Implementar servicio backend
6. Crear endpoints API
7. Implementar componentes UI

### Cómo crear un nuevo grupo de permisos

1. Insertar en `grupos_permisos` con código descriptivo
2. Asociar capacidades en `grupo_capacidades`
3. Documentar el grupo
4. Asignar a usuarios según necesidad

### Cómo asignar permisos a un usuario

**Opción 1: Via Grupos (recomendado)**
```sql
INSERT INTO usuarios_grupos (usuario_id, grupo_id, asignado_por)
VALUES (123, (SELECT id FROM grupos_permisos WHERE codigo = 'atencion_cliente'), 1);
```

**Opción 2: Via Permiso Excepcional (casos especiales)**
```sql
INSERT INTO permisos_excepcionales
(usuario_id, capacidad_id, tipo, motivo, fecha_fin, autorizado_por)
VALUES (123, 456, 'conceder', 'Proyecto temporal', '2025-12-31', 1);
```

### Cómo verificar permisos en código

**Backend (pseudocódigo):**
```python
if not PermissionService.usuario_tiene_permiso(usuario_id, 'sistema.operaciones.tickets.crear'):
 raise PermissionDenied('No autorizado')
```

**API (middleware):**
```python
@api_view(['POST'])
@permission_required('sistema.operaciones.tickets.crear')
def crear_ticket(request):
 # handler
 pass
```

---

## Consultas Útiles

### Ver todos los permisos de un usuario
```sql
SELECT * FROM vista_capacidades_usuario
WHERE usuario_id = 123;
```

### Ver grupos de un usuario
```sql
SELECT * FROM vista_grupos_usuario
WHERE usuario_id = 123 AND vigente = TRUE;
```

### Auditar accesos denegados
```sql
SELECT * FROM auditoria_permisos
WHERE accion_realizada = 'acceso_denegado'
 AND timestamp > NOW() - INTERVAL '24 hours'
ORDER BY timestamp DESC;
```

### Usuarios con capacidad específica
```sql
SELECT DISTINCT usuario_id, usuario_nombre
FROM vista_capacidades_usuario
WHERE capacidad = 'sistema.finanzas.pagos.aprobar';
```

---

## Recursos Adicionales

### Documentación Técnica
- Esquema de base de datos completo
- Diccionario de datos
- Diagramas ER
- Índices de performance

### Guías de Usuario
- Manual de administrador
- Manual de usuario final
- Videos tutoriales
- FAQ

### Soporte
- Sistema de tickets
- Base de conocimientos
- Foros de comunidad
- Contacto directo

---

## Conclusión

Este sistema de permisos granular proporciona:

- **Flexibilidad total** sin ataduras jerárquicas
- **Escalabilidad** para crecer con la organización
- **Claridad** en qué puede hacer cada usuario
- **Auditoría completa** de todos los accesos
- **Facilidad de mantenimiento** con grupos modulares
- **Experiencia humana** con nomenclatura descriptiva

---

**Documento:** Índice Maestro
**Fecha:** 07 de Noviembre, 2025
**Versión:** 1.0
**Estado:** Completo y listo para usar

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción | Aprobado Por |
|---------|-------|-------|-------------|--------------|
| 1.0 | 2025-11-07 | equipo-backend | Creación inicial - Adaptación sin emojis | equipo-ba |
