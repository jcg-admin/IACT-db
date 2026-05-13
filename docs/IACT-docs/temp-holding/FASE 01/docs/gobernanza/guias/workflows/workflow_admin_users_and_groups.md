---
id: GUIA-WORKFLOW-ADMIN-USERS-AND-GROUPS
tipo: guia_operativa
categoria: workflows
audiencia: administradores-tecnicos
prioridad: P1
tiempo_lectura: 15 minutos
version: 1.0.0
fecha: 2025-01-15
relacionados: ["CASOS_DE_USO_SISTEMA_PERMISOS", "CATALOGO_GRUPOS_FUNCIONALES", "UC-005"]
---

# Gestión de Usuarios y Grupos de Permisos

## Propósito

Esta guía explica cómo administrar usuarios y asignar grupos funcionales en el sistema de permisos granular, siguiendo el nuevo enfoque sin jerarquías.

## Audiencia

Esta guía está dirigida a: **Administradores técnicos** responsables de la gestión de cuentas de usuario y asignación de permisos.

## Pre-requisitos

- [ ] Tener cuenta con grupo `administracion_usuarios`
- [ ] Acceso al panel de administración del sistema
- [ ] Conocer los 10 grupos funcionales disponibles
- [ ] Entender la filosofía sin jerarquías del sistema

## Tiempo estimado

Tiempo de lectura: 15 minutos
Tiempo de ejecución: 5-10 minutos por usuario

## Contexto: Sistema de Grupos Funcionales

**Filosofía del sistema:**
- NO hay roles jerárquicos ("Agente", "Supervisor", "Admin")
- SÍ hay grupos funcionales descriptivos ("Atención al Cliente", "Gestión de Equipos")
- Los usuarios pueden tener múltiples grupos simultáneamente
- Los permisos son combinables y flexibles

**10 Grupos Funcionales Disponibles:**

1. `administracion_usuarios` (7 capacidades) - Gestión de cuentas
2. `visualizacion_basica` (2 capacidades) - Acceso a dashboards
3. `configuracion_sistema` (5 capacidades) - Configuración técnica
4. `atencion_cliente` (9 capacidades) - Operaciones básicas
5. `atencion_cliente_avanzada` (16 capacidades) - Operaciones avanzadas
6. `analisis_operativo` (9 capacidades) - Métricas y reportes
7. `gestion_equipos` (6 capacidades) - Administración de equipos
8. `gestion_horarios` (6 capacidades) - Planificación de turnos
9. `auditoria_llamadas` (6 capacidades) - Auditoría de calidad
10. `evaluacion_desempeno` (6 capacidades) - Evaluaciones

## Pasos

### 1. Crear Nuevo Usuario

**Navegación**:
1. Acceder al panel de administración
2. Ir a **Administración > Usuarios**
3. Hacer clic en **Crear nuevo usuario**

**Formulario**:
```
Nombre: Pedro Gómez
Email: pedro.gomez@empresa.com
Departamento: Atención al Cliente
Fecha de ingreso: 2025-11-07
```

**Output esperado**:
```
Usuario creado exitosamente
ID: 123
Estado: Activo
Contraseña temporal enviada a: pedro.gomez@empresa.com
```

**Nota**: El usuario debe cambiar la contraseña en el primer login.

### 2. Asignar Grupos Funcionales

**Navegación**:
1. En el perfil del usuario recién creado
2. Ir a pestaña **Grupos y Permisos**
3. Hacer clic en **Asignar grupos**

**Seleccionar grupos según el rol laboral**:

**Ejemplo 1: Agente de Atención al Cliente**
```
Grupos a asignar:
☑ atencion_cliente
☑ visualizacion_basica

Total capacidades: 11
```

**Ejemplo 2: Coordinador de Equipo**
```
Grupos a asignar:
☑ atencion_cliente_avanzada
☑ gestion_equipos
☑ gestion_horarios
☑ analisis_operativo

Total capacidades: 37
```

**Ejemplo 3: Analista de Calidad**
```
Grupos a asignar:
☑ auditoria_llamadas
☑ evaluacion_desempeno
☑ analisis_operativo

Total capacidades: 21
```

**Output esperado**:
```
Grupos asignados exitosamente
Grupos activos: 2
Capacidades totales: 11
Auditoría registrada: Sí
```

### 3. Verificar Permisos Asignados

**Navegación**:
1. En el perfil del usuario
2. Ir a pestaña **Permisos Efectivos**

**Vista de permisos**:
```
Permisos del Usuario: Pedro Gómez

Grupo: atencion_cliente (9 capacidades)
  - sistema.operaciones.llamadas.realizar
  - sistema.operaciones.llamadas.recibir
  - sistema.operaciones.llamadas.transferir
  - sistema.operaciones.tickets.ver
  - sistema.operaciones.tickets.crear
  - sistema.operaciones.tickets.editar
  - sistema.operaciones.tickets.asignar
  - sistema.operaciones.clientes.ver
  - sistema.operaciones.clientes.editar

Grupo: visualizacion_basica (2 capacidades)
  - sistema.vistas.dashboards.ver
  - sistema.vistas.dashboards.exportar

Total: 11 capacidades
```

### 4. Suspender Usuario Temporalmente

**Casos de uso:**
- Vacaciones prolongadas
- Licencia médica
- Investigación interna

**Pasos**:
1. Ir al perfil del usuario
2. Hacer clic en **Suspender usuario**
3. Completar formulario:

```
Motivo: Vacaciones
Fecha de reactivación automática: 2025-11-20
Notas: Vacaciones programadas, reactivar automáticamente
```

**Output esperado**:
```
Usuario suspendido exitosamente
Estado: Suspendido
Sesiones activas: Cerradas (2 sesiones cerradas)
Reactivación programada: 2025-11-20
Permisos: Mantenidos (se restauran al reactivar)
```

### 5. Modificar Grupos de Usuario Existente

**Caso**: Usuario cambia de departamento o asume nuevas responsabilidades

**Pasos**:
1. Ir al perfil del usuario
2. Pestaña **Grupos y Permisos**
3. Hacer clic en **Modificar grupos**

**Ejemplo: Agente promovido a Coordinador**

**Antes**:
```
Grupos actuales:
☑ atencion_cliente
☑ visualizacion_basica
```

**Después**:
```
Nuevos grupos:
☑ atencion_cliente_avanzada  (reemplaza atencion_cliente)
☑ visualizacion_basica        (se mantiene)
☑ gestion_equipos             (nuevo)
☑ gestion_horarios            (nuevo)
☑ analisis_operativo          (nuevo)
```

**Output esperado**:
```
Grupos actualizados exitosamente
Cambios registrados en auditoría
Grupos anteriores: 2
Grupos nuevos: 5
Capacidades anteriores: 11
Capacidades nuevas: 37
Notificación enviada al usuario
```

## Validación

Para validar que completaste correctamente esta guía:

- [ ] Usuario creado con email único
- [ ] Grupos asignados según rol laboral
- [ ] Permisos efectivos visibles en el perfil
- [ ] Usuario puede iniciar sesión correctamente
- [ ] Auditoría registrada de todas las acciones

## Cómo interpretar resultados

**Éxito**:
- Usuario aparece en lista de usuarios con estado "Activo"
- Grupos se muestran en el perfil del usuario
- Capacidades totales coinciden con la suma de grupos
- Email de contraseña temporal fue enviado

**Errores comunes**: Ver sección Troubleshooting

## Troubleshooting

### Error 1: Email ya existe en el sistema

**Síntomas**:
```
ERROR: Usuario con este email ya existe
Email: pedro.gomez@empresa.com
Usuario existente: ID 45 (Suspendido)
```

**Causa**: El email ya está registrado en el sistema, posiblemente de un usuario anterior

**Solución**:
```
Opción A: Si es el mismo usuario
1. Ir al perfil del usuario existente (ID 45)
2. Hacer clic en "Reactivar usuario"
3. Actualizar información si es necesario
4. Reasignar grupos actuales

Opción B: Si es usuario diferente
1. Verificar que el email sea correcto
2. Usar email corporativo alternativo
3. Si el usuario anterior ya no trabaja, eliminarlo lógicamente
```

### Error 2: Grupo requiere aprobación

**Síntomas**:
```
ADVERTENCIA: Grupo 'aprobacion_pagos' requiere aprobación
Estado: Pendiente de aprobación
Aprobador: CISO
```

**Causa**: Algunos grupos sensibles requieren aprobación de un superior

**Solución**:
```
1. Completar formulario de justificación
2. Enviar solicitud de aprobación
3. Esperar aprobación del CISO o responsable
4. El grupo se activará automáticamente tras aprobación
```

### Error 3: Usuario no puede acceder a módulo específico

**Síntomas**:
```
Usuario reporta: "No puedo acceder a Gestión de Horarios"
Grupos asignados: atencion_cliente, visualizacion_basica
```

**Causa**: El usuario no tiene el grupo necesario

**Solución**:
```
1. Verificar qué grupo otorga acceso a Gestión de Horarios
   Respuesta: gestion_horarios

2. Evaluar si el usuario debe tener ese acceso según su rol

3. Si sí:
   - Ir a perfil del usuario
   - Asignar grupo gestion_horarios
   - Verificar que capacidades se actualizan

4. Si no:
   - Explicar al usuario que no tiene ese permiso
   - Redirigir al coordinador o supervisor para solicitud formal
```

## Buenas Prácticas

### 1. Principio de Mínimo Privilegio

Asignar solo los grupos necesarios para que el usuario realice su trabajo:

```
INCORRECTO:
Agente nuevo con grupos:
☑ atencion_cliente_avanzada
☑ gestion_equipos
☑ analisis_operativo
☑ configuracion_sistema
(Demasiados permisos)

CORRECTO:
Agente nuevo con grupos:
☑ atencion_cliente
☑ visualizacion_basica
(Solo lo necesario)
```

### 2. Revisión Periódica de Permisos

Realizar auditorías trimestrales:

```bash
# Revisar usuarios con múltiples grupos (>4)
SELECT usuario_id, COUNT(*) as grupos_totales
FROM usuarios_grupos
WHERE activo = TRUE
GROUP BY usuario_id
HAVING COUNT(*) > 4
ORDER BY grupos_totales DESC;
```

### 3. Documentar Cambios Importantes

Al asignar grupos sensibles, documentar:
- Motivo de la asignación
- Quién autorizó
- Fecha de revisión programada

### 4. Usar Permisos Excepcionales Solo Cuando Sea Necesario

Los permisos excepcionales (individuales) deben ser temporales:

```
Correcto: Permiso excepcional por proyecto temporal (60 días)
Incorrecto: Permiso excepcional permanente (usar grupos en su lugar)
```

## Casos de Uso Reales

### Caso 1: Onboarding de Nuevo Agente

**Situación**: Nueva contratación, Ana López, agente de atención

**Grupos a asignar**:
```
☑ atencion_cliente
☑ visualizacion_basica
```

**Tiempo estimado**: 5 minutos

### Caso 2: Promoción Interna

**Situación**: Carlos Ruiz promovido de agente a coordinador

**Grupos antes**:
```
☑ atencion_cliente
☑ visualizacion_basica
```

**Grupos después**:
```
☑ atencion_cliente_avanzada  (reemplaza atencion_cliente)
☑ visualizacion_basica        (mantener)
☑ gestion_equipos             (agregar)
☑ gestion_horarios            (agregar)
☑ analisis_operativo          (agregar)
```

**Tiempo estimado**: 8 minutos

### Caso 3: Cambio de Departamento

**Situación**: Usuario cambia de Atención a Calidad

**Grupos antes**:
```
☑ atencion_cliente_avanzada
☑ analisis_operativo
```

**Grupos después**:
```
☑ auditoria_llamadas
☑ evaluacion_desempeno
☑ analisis_operativo  (mantener)
```

**Tiempo estimado**: 6 minutos

## Próximos pasos

Después de completar esta guía, puedes continuar con:

1. **GUIA-WORKFLOWS-006**: Gestión de Equipos y Horarios (para coordinadores)
2. **GUIA-WORKFLOWS-007**: Auditoría de Permisos y Compliance
3. **CASOS_DE_USO_SISTEMA_PERMISOS.md**: Ver casos de uso completos
4. **CATALOGO_GRUPOS_FUNCIONALES.md**: Referencia completa de grupos

## Referencias

- Documentación técnica: `docs/backend/requisitos/CASOS_DE_USO_SISTEMA_PERMISOS.md`
- Catálogo de grupos: `docs/backend/requisitos/CATALOGO_GRUPOS_FUNCIONALES.md`
- Matriz de trazabilidad: `docs/backend/requisitos/MATRIZ_TRAZABILIDAD_PERMISOS.md`
- Script relacionado: `api/callcentersite/callcentersite/apps/users/services.py`

## Feedback

Si encuentras problemas con esta guía o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: equipo-backend

---

**Mantenedores**: equipo-backend, equipo-documentacion
**Última actualización**: 2025-11-07
