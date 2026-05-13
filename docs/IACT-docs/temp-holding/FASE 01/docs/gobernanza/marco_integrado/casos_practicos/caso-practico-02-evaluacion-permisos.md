---
title: Caso Práctico 2 - Sistema de Evaluación de Permisos en Tres Niveles
date: 2025-11-16
domain: backend
status: active
caso_numero: 2
relacionado:
  - ../05a_casos_practicos_iact.md
  - ../../backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md
  - ../../adr/ADR-017-sistema-permisos-sin-roles-jerarquicos.md
---

# Caso Práctico 2: Sistema de Evaluación de Permisos en Tres Niveles

**Versión:** 1.0
**Fecha:** 2025-11-05
**Estado:** Vigente
**Dominio:** Call Center - Sistema IACT

---

## 2.1 Contexto del Negocio

**Dominio:** Call Center - Sistema IACT
**Área:** Control de Acceso y Autorización
**Objetivo:** Garantizar que los usuarios solo accedan a funciones y datos autorizados según su rol y permisos específicos

**Stakeholders:**
- Agentes (requieren acceso a funciones básicas)
- Supervisores (requieren acceso a gestión de equipos)
- Administradores (requieren acceso total al sistema)
- Auditores (requieren trazabilidad de accesos)

---

## 2.2 Proceso de Negocio

**PROC-PERM-001: Proceso de Evaluación de Permisos**

```
INICIO
  |
  v
[Usuario autenticado solicita acción]
  |
  v
[Extraer contexto: userId, rol, acción, recurso]
  |
  v
[NIVEL 1: Validar Rol Global]
  |---> [Rol no autorizado] --> [Denegar acceso] --> [Registrar PERMISSION_DENIED] --> FIN
  v
[Rol autorizado]
  |
  v
[NIVEL 2: Validar Permisos de Operación]
  |---> [Permiso de operación no encontrado] --> [Denegar acceso] --> FIN
  v
[Permiso de operación validado]
  |
  v
[NIVEL 3: Validar Contexto Específico]
  |---> [Restricción contextual violada] --> [Denegar acceso] --> FIN
  v
[Todos los niveles aprobados]
  |
  v
[Permitir acceso]
  |
  v
[Registrar PERMISSION_GRANTED]
  |
  v
[Ejecutar acción solicitada]
  |
  v
FIN
```

**Actores:**
- Usuario (Agente/Supervisor/Admin)
- Sistema de Autorización
- Sistema de Auditoría

---

## 2.3 Casos de Uso Derivados

**UC-010: Evaluar Permiso de Acceso a Recurso**

| Caso de Uso | UC-010: Evaluar Permiso de Acceso a Recurso |
|-------------|---------------------------------------------|
| **Actor Principal** | Sistema (invocado por middleware) |
| **Stakeholders** | - Usuario: Espera acceso rápido si autorizado<br>- Administrador: Requiere control granular<br>- Auditor: Necesita trazabilidad de decisiones |
| **Precondiciones** | - Usuario autenticado con sesión válida<br>- Token JWT contiene rol y permisos<br>- Sistema de autorización operativo |
| **Postcondiciones Éxito** | - Acceso permitido<br>- Evento PERMISSION_GRANTED registrado<br>- Acción ejecutada |
| **Postcondiciones Fallo** | - Acceso denegado<br>- Evento PERMISSION_DENIED registrado<br>- Código HTTP 403 retornado |

**Flujo Principal:**

| Paso | Acción del Sistema |
|------|--------------------|
| 1 | Middleware intercepta request del usuario |
| 2 | Sistema extrae token JWT del header Authorization |
| 3 | Sistema decodifica token y extrae: userId, rol, permissions[] |
| 4 | Sistema identifica recurso solicitado (ej: /api/reportes/ventas) |
| 5 | Sistema identifica acción solicitada (ej: READ) |
| 6 | **NIVEL 1**: Sistema valida rol global (agente/supervisor/admin) |
| 7 | **NIVEL 2**: Sistema busca permiso específico en permissions[] |
| 8 | **NIVEL 3**: Sistema valida restricciones contextuales (ej: solo datos propios) |
| 9 | Sistema registra decisión en tabla de auditoría |
| 10 | Sistema permite continuar con el request |

**Flujos Alternativos:**

**FA-1: Nivel 1 Falla - Rol No Autorizado**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 6a | Rol del usuario no está en roles permitidos para el recurso | Sistema detiene evaluación |
| 6b | - | Sistema registra evento PERMISSION_DENIED con motivo "ROLE_NOT_AUTHORIZED" |
| 6c | - | Sistema retorna HTTP 403 con mensaje "Acceso denegado" |

**FA-2: Nivel 2 Falla - Permiso de Operación Faltante**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 7a | Permiso requerido no existe en permissions[] del token | Sistema detiene evaluación |
| 7b | - | Sistema registra evento PERMISSION_DENIED con motivo "PERMISSION_NOT_GRANTED" |
| 7c | - | Sistema retorna HTTP 403 |

**FA-3: Nivel 3 Falla - Restricción Contextual Violada**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 8a | Usuario intenta acceder a datos de otro agente sin ser supervisor | Sistema detiene evaluación |
| 8b | - | Sistema registra evento PERMISSION_DENIED con motivo "CONTEXT_RESTRICTION_VIOLATED" |
| 8c | - | Sistema retorna HTTP 403 |

---

## 2.4 Requisitos Derivados

**Requisitos Funcionales:**

**RF-001: Evaluación de Permisos en Tres Niveles** (EXISTENTE - Referencia real)

```
ID: RF-001
Título: Evaluación de Permisos en Tres Niveles
Prioridad: MUST (MoSCoW)
Categoría: Seguridad - Autorización

Descripción:
El sistema debe evaluar permisos de acceso en tres niveles jerárquicos:
Nivel 1 (Rol), Nivel 2 (Operación), Nivel 3 (Contexto).

Criterios de Aceptación:
1. El sistema debe validar rol global antes de evaluar permisos específicos
2. El sistema debe validar permisos de operación contra lista del token
3. El sistema debe validar restricciones contextuales (ownership, jerarquía)
4. El sistema debe denegar acceso si cualquier nivel falla
5. La evaluación debe completarse en menos de 50ms (P95)

Entrada:
- userId: string (UUID)
- rol: string (agente|supervisor|admin)
- permissions: string[] (lista de permisos)
- recurso: string (ej: "/api/reportes/ventas")
- acción: string (READ|WRITE|DELETE)
- contexto: object (datos adicionales, ej: resourceOwnerId)

Salida:
- permitido: boolean
- motivo: string (si denegado)

Niveles de Validación:

NIVEL 1 - Rol Global:
- Agente: acceso a funciones básicas
- Supervisor: acceso a gestión de equipo
- Admin: acceso completo

NIVEL 2 - Permisos de Operación:
- Ver listado de clientes: "clientes:read"
- Crear cliente: "clientes:write"
- Eliminar cliente: "clientes:delete"
- Ver reportes: "reportes:read"
- Exportar reportes: "reportes:export"

NIVEL 3 - Contexto Específico:
- Agente solo puede ver sus propios clientes
- Supervisor puede ver clientes de su equipo
- Admin puede ver todos los clientes

Trazabilidad:
- Proceso: PROC-PERM-001
- Caso de Uso: UC-010
- Reglas: N/A (lógica de autorización)
- Prueba: TS-RF-001-001 a TS-RF-001-010

Referencias:
- docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md
```

**RF-011: Gestión de Roles y Permisos**

```
ID: RF-011
Título: Gestión de Roles y Permisos de Usuario
Prioridad: MUST (MoSCoW)
Categoría: Administración - Control de Acceso

Descripción:
El sistema debe permitir a administradores gestionar roles y permisos
de usuarios, incluyendo asignación, modificación y revocación.

Criterios de Aceptación:
1. Administrador puede asignar rol a usuario: agente, supervisor, admin
2. Administrador puede asignar permisos específicos adicionales
3. Administrador puede revocar permisos específicos
4. Cambios en permisos deben reflejarse en próximo login (nuevo token)
5. Cambios deben registrarse en tabla de auditoría

Entrada:
- adminUserId: string (quien realiza el cambio)
- targetUserId: string (usuario objetivo)
- acción: "ASSIGN_ROLE" | "GRANT_PERMISSION" | "REVOKE_PERMISSION"
- valor: string (rol o permiso)

Salida:
- éxito: boolean
- usuario actualizado: objeto User

Operaciones:

1. Asignar Rol:
   POST /api/admin/users/:userId/rol
   Body: { "rol": "supervisor" }

2. Otorgar Permiso:
   POST /api/admin/users/:userId/permissions
   Body: { "permission": "reportes:export" }

3. Revocar Permiso:
   DELETE /api/admin/users/:userId/permissions/:permissionId

Validaciones:
- Solo usuarios con rol "admin" pueden ejecutar estas operaciones
- No se puede cambiar el rol del propio usuario (auto-modificación)
- No se puede dejar al sistema sin al menos un administrador

Trazabilidad:
- Proceso: PROC-PERM-001 (gestión de permisos)
- Caso de Uso: UC-011 (Gestionar Permisos de Usuario)
- Prueba: TS-RF-011-001
```

**RF-012: Auditoría de Decisiones de Autorización**

```
ID: RF-012
Título: Auditoría de Decisiones de Autorización
Prioridad: SHOULD (MoSCoW)
Categoría: Auditoría - Cumplimiento

Descripción:
El sistema debe registrar todas las decisiones de autorización (permitido/denegado)
para auditoría, análisis de seguridad y detección de intentos de acceso no autorizado.

Criterios de Aceptación:
1. Registrar evento PERMISSION_GRANTED cuando acceso es permitido
2. Registrar evento PERMISSION_DENIED cuando acceso es denegado
3. Incluir motivo específico de denegación (nivel que falló)
4. Incluir contexto completo: userId, recurso, acción, timestamp, IP
5. Registros deben ser inmutables y persistentes

Estructura del Registro:
{
  "id": "uuid",
  "eventType": "PERMISSION_GRANTED | PERMISSION_DENIED",
  "userId": "uuid",
  "userRol": "string",
  "recurso": "string",
  "acción": "string",
  "resultado": "GRANTED | DENIED",
  "motivoDenegación": "ROLE_NOT_AUTHORIZED | PERMISSION_NOT_GRANTED | CONTEXT_RESTRICTION_VIOLATED",
  "nivelFallido": 1 | 2 | 3 | null,
  "ipAddress": "string",
  "timestamp": "ISO 8601"
}

Casos de Uso:
- Análisis de intentos de acceso no autorizado
- Reportes de cumplimiento regulatorio
- Investigación de incidentes de seguridad
- Optimización de permisos (identificar permisos nunca usados)

Trazabilidad:
- Proceso: PROC-PERM-001 (paso "Registrar decisión")
- Caso de Uso: UC-010 (pasos 9)
- Prueba: TS-RF-012-001
```

---

## 2.5 Procedimientos Operacionales

**PROC-PERM-ADMIN-001: Procedimiento para Asignar Permisos a Usuario**

**Objetivo:** Guiar al administrador en el proceso de asignación de roles y permisos.

**Alcance:** Aplicable solo a usuarios con rol "admin"

**Responsable:** Administrador del sistema

**Pasos Detallados:**

| Paso | Pantalla | Acción del Administrador | Validación del Sistema |
|------|----------|-------------------------|----------------------|
| 1 | Dashboard Admin | Navegar a sección "Gestión de Usuarios" | Sistema carga lista de usuarios |
| 2 | Lista de Usuarios | Buscar usuario por email o nombre | Sistema filtra resultados en tiempo real |
| 3 | Perfil de Usuario | Hacer clic en usuario objetivo | Sistema muestra perfil con rol y permisos actuales |
| 4 | Sección "Roles" | Ver rol actual del usuario | Sistema destaca rol actual |
| 5 | Cambiar Rol | Seleccionar nuevo rol del dropdown | Sistema valida que no es auto-modificación |
| 6 | Confirmar Cambio | Hacer clic en "Guardar Rol" | Sistema actualiza rol en base de datos |
| 7 | Auditoría | - | Sistema registra evento ROLE_CHANGED |
| 8 | Sección "Permisos" | Ver permisos actuales | Sistema muestra tabla de permisos |
| 9 | Agregar Permiso | Hacer clic en "+ Agregar Permiso" | Sistema muestra modal con permisos disponibles |
| 10 | Seleccionar Permiso | Seleccionar permiso de la lista | Sistema valida que no esté duplicado |
| 11 | Confirmar | Hacer clic en "Otorgar Permiso" | Sistema agrega permiso al usuario |
| 12 | Auditoría | - | Sistema registra evento PERMISSION_GRANTED |
| 13 | Notificar | - | Sistema envía email al usuario notificando cambios |

**Ejemplo Práctico:**

**Escenario:** Promover a un agente a supervisor

1. Usuario actual: juan.perez@company.com, Rol: agente
2. Permisos actuales: ["clientes:read", "casos:write"]
3. Cambio solicitado: Rol → supervisor
4. Permisos adicionales automáticos: ["equipo:read", "reportes:read", "metricas:read"]

**Proceso:**

| Acción | Sistema |
|--------|---------|
| Admin busca "juan.perez@company.com" | Sistema muestra perfil |
| Admin cambia rol de "agente" a "supervisor" | Sistema valida y actualiza |
| Sistema agrega permisos del rol supervisor automáticamente | Permisos ahora: ["clientes:read", "casos:write", "equipo:read", "reportes:read", "metricas:read"] |
| Sistema registra evento ROLE_CHANGED | Auditoría: Admin123 cambió rol de juan.perez a supervisor |
| Sistema envía email a juan.perez | Email: "Tu rol ha sido actualizado a Supervisor" |
| Juan debe cerrar sesión y volver a iniciar | Nuevo token JWT incluirá nuevo rol y permisos |

---

## 2.6 Trazabilidad Completa

**Matriz de Trazabilidad: Caso Permisos**

| Proceso | Caso de Uso | Requisito Funcional | Procedimiento | Prueba |
|---------|-------------|---------------------|---------------|--------|
| PROC-PERM-001 | UC-010 | RF-001 | - | TS-RF-001-001 |
| PROC-PERM-001 | UC-011 | RF-011 | PROC-PERM-ADMIN-001 | TS-RF-011-001 |
| PROC-PERM-001 | UC-010 | RF-012 | - | TS-RF-012-001 |

**Flujo de Transformación:**

```
PROCESO DE NEGOCIO (PROC-PERM-001)
         |
         v
CASOS DE USO (UC-010: Evaluar Permiso, UC-011: Gestionar Permisos)
         |
         v
REQUISITOS FUNCIONALES
- RF-001: Evaluación tres niveles
- RF-011: Gestión de roles/permisos
- RF-012: Auditoría de decisiones
         |
         v
PROCEDIMIENTOS OPERACIONALES (PROC-PERM-ADMIN-001)
         |
         v
IMPLEMENTACIÓN Y PRUEBAS
```

---

**Referencias:**
- Documento maestro: `../05a_casos_practicos_iact.md`
- Requisitos funcionales: `../../backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md`
- ADR relacionado: `../../adr/ADR-017-sistema-permisos-sin-roles-jerarquicos.md`
- Marco conceptual: `../01_marco_conceptual_iact.md`
