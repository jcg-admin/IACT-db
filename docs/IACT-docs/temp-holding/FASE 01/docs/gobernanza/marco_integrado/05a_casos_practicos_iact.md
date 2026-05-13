# Casos Prácticos IACT - Aplicación del Marco Integrado

**Versión:** 1.0
**Fecha:** 2025-11-05
**Estado:** Vigente

## Propósito del Documento

Este documento presenta casos prácticos reales del proyecto IACT que demuestran la aplicación completa del marco integrado de análisis de negocio. Cada caso muestra cómo fluye la información desde procesos de negocio hasta procedimientos operacionales.

**Nota:** Para un caso didáctico genérico con propósitos pedagógicos, consultar el documento complementario `05b_caso_didactico_generico.md`.

## Referencias

- **01_marco_conceptual_iact.md** - Fundamentos teóricos
- **02_relaciones_fundamentales_iact.md** - Patrones de transformación
- **03_matrices_trazabilidad_iact.md** - Matrices RTM
- **04_metodologia_analisis_iact.md** - Metodología de 4 fases
- **docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md** - Reglas de negocio reales
- **docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md** - Requisitos funcionales

---

## Caso Práctico 1: Sistema de Autenticación y Gestión de Sesiones

### 1.1 Contexto del Negocio

**Dominio:** Call Center - Sistema IACT
**Área:** Seguridad y Control de Acceso
**Objetivo:** Garantizar autenticación segura y gestión robusta de sesiones de usuario

**Stakeholders:**
- Agentes de call center (usuarios finales)
- Supervisores (gestión de equipos)
- Administradores de seguridad
- Oficiales de cumplimiento (auditoría)

### 1.2 Proceso de Negocio

**PROC-AUTH-001: Proceso de Autenticación de Usuario**

```
INICIO
  |
  v
[Usuario solicita acceso]
  |
  v
[Validar credenciales]
  |---> [Credenciales inválidas] --> [Registrar intento fallido]
  |                                         |
  |                                         v
  |                                    [Cuenta bloqueada?] --No--> [Mostrar error] --> FIN
  |                                         |
  |                                        Si
  |                                         v
  |                                    [Bloquear cuenta] --> [Notificar admin] --> FIN
  v
[Credenciales válidas]
  |
  v
[Crear sesión]
  |
  v
[Registrar evento de acceso]
  |
  v
[Permitir acceso al sistema]
  |
  v
FIN
```

**Actores:**
- Usuario (Agente/Supervisor/Admin)
- Sistema de Autenticación
- Sistema de Auditoría

**Reglas de Negocio Aplicables:**
- RN-C01-01: Formato de contraseña
- RN-C01-02: Longitud mínima de contraseña
- RN-C01-03: Bloqueo por intentos fallidos
- RN-C01-04: Duración de bloqueo
- RN-C01-05: Tiempo de expiración de sesión
- RN-C01-06: Renovación de sesión
- RN-C01-14: Token JWT estructura

### 1.3 Casos de Uso Derivados

**UC-001: Iniciar Sesión**

| Caso de Uso | UC-001: Iniciar Sesión |
|-------------|------------------------|
| **Actor Principal** | Usuario (Agente, Supervisor, Administrador) |
| **Stakeholders** | - Usuario: Desea acceso rápido y seguro<br>- Administrador de Seguridad: Requiere trazabilidad<br>- Oficial de Cumplimiento: Necesita logs de auditoría |
| **Precondiciones** | - Usuario tiene cuenta activa en el sistema<br>- Sistema de autenticación está operativo<br>- Base de datos de usuarios accesible |
| **Postcondiciones Éxito** | - Sesión creada con token JWT válido<br>- Evento de login registrado en auditoría<br>- Usuario redirigido a dashboard según rol |
| **Postcondiciones Fallo** | - Intento fallido registrado<br>- Cuenta bloqueada si excede límite (RN-C01-03)<br>- Notificación a administrador si corresponde |

**Flujo Principal:**

| Paso | Acción del Usuario | Respuesta del Sistema |
|------|-------------------|----------------------|
| 1 | Usuario accede a la URL de login del sistema | Sistema muestra formulario de autenticación con campos: email y contraseña |
| 2 | Usuario ingresa email y contraseña | Sistema valida formato de email (RN-C01-01) |
| 3 | Usuario hace clic en "Iniciar Sesión" | Sistema valida credenciales contra base de datos |
| 4 | - | Sistema verifica que cuenta no esté bloqueada (RN-C01-03) |
| 5 | - | Sistema genera token JWT con estructura definida (RN-C01-14) |
| 6 | - | Sistema crea sesión con expiración 30 minutos (RN-C01-05) |
| 7 | - | Sistema registra evento LOGIN_SUCCESS en tabla de auditoría |
| 8 | - | Sistema redirige a dashboard según rol del usuario |

**Flujos Alternativos:**

**FA-1: Credenciales Inválidas**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 3a | Email no existe en base de datos | Muestra mensaje genérico "Credenciales inválidas" (seguridad) |
| 3b | Contraseña incorrecta | Incrementa contador de intentos fallidos |
| 3c | - | Registra evento LOGIN_FAILED con IP y timestamp |
| 3d | Contador >= 5 intentos (RN-C01-03) | Bloquea cuenta por 15 minutos (RN-C01-04) |
| 3e | - | Notifica a administrador de seguridad |
| 3f | - | Retorna a paso 1 mostrando mensaje de error |

**FA-2: Cuenta Bloqueada**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 4a | Cuenta está bloqueada | Calcula tiempo restante de bloqueo |
| 4b | - | Muestra mensaje "Cuenta bloqueada. Intente en X minutos" |
| 4c | - | Registra evento LOGIN_BLOCKED en auditoría |
| 4d | - | Retorna a paso 1 |

**FA-3: Sesión Activa Existente**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 5a | Usuario ya tiene sesión activa | Invalida sesión anterior |
| 5b | - | Registra evento SESSION_REPLACED |
| 5c | - | Continúa con paso 6 del flujo principal |

**UC-002: Renovar Sesión**

| Caso de Uso | UC-002: Renovar Sesión |
|-------------|------------------------|
| **Actor Principal** | Sistema (automático) |
| **Precondiciones** | - Sesión activa existe<br>- Sesión próxima a expirar (<5 minutos) |
| **Postcondiciones Éxito** | - Nueva sesión creada con token renovado<br>- Sesión anterior invalidada<br>- Usuario mantiene acceso sin interrupción |

**Flujo Principal:**

| Paso | Acción del Sistema |
|------|--------------------|
| 1 | Sistema detecta sesión con menos de 5 minutos para expirar |
| 2 | Sistema valida que usuario esté activo (actividad reciente) |
| 3 | Sistema genera nuevo token JWT (RN-C01-14) |
| 4 | Sistema actualiza timestamp de expiración (+30 minutos) (RN-C01-06) |
| 5 | Sistema invalida token anterior |
| 6 | Sistema registra evento SESSION_RENEWED |
| 7 | Sistema envía nuevo token al cliente |

### 1.4 Requisitos Derivados

**Requisitos Funcionales:**

**RF-005: Validación de Credenciales**

```
ID: RF-005
Título: Validación de Credenciales de Usuario
Prioridad: MUST (MoSCoW)
Categoría: Seguridad - Autenticación

Descripción:
El sistema debe validar las credenciales de usuario (email y contraseña)
contra la base de datos de usuarios durante el proceso de autenticación.

Criterios de Aceptación:
1. El sistema debe verificar que el email existe en la tabla Users
2. El sistema debe comparar la contraseña hasheada usando bcrypt
3. El sistema debe validar que la cuenta no esté en estado 'bloqueada'
4. El sistema debe validar que la cuenta no esté en estado 'inactiva'
5. La validación debe completarse en menos de 500ms (P95)

Entrada:
- email: string (formato email válido)
- password: string (texto plano)

Salida:
- Si válido: objeto User con id, email, rol, permisos
- Si inválido: error "INVALID_CREDENTIALS"

Reglas de Negocio:
- RN-C01-01: Formato de contraseña
- RN-C01-02: Longitud mínima de contraseña
- RN-C01-03: Bloqueo por intentos fallidos

Trazabilidad:
- Proceso: PROC-AUTH-001 (paso "Validar credenciales")
- Caso de Uso: UC-001 (paso 3)
- Prueba: TS-RF-005-001, TS-RF-005-002

Referencias:
- docs/implementacion/backend/requisitos/funcionales/rf005_validacion_credenciales.md
```

**RF-006: Generación de Token JWT**

```
ID: RF-006
Título: Generación de Token JWT para Sesión
Prioridad: MUST (MoSCoW)
Categoría: Seguridad - Gestión de Sesiones

Descripción:
El sistema debe generar un token JWT válido tras autenticación exitosa,
siguiendo la estructura definida en RN-C01-14.

Criterios de Aceptación:
1. El token debe incluir claims: userId, email, rol, permissions
2. El token debe firmarse con algoritmo HS256
3. El token debe tener expiración de 30 minutos (RN-C01-05)
4. El token debe incluir timestamp de emisión (iat)
5. El token debe ser válido según estándar RFC 7519

Entrada:
- user: objeto User {id, email, rol, permisos}

Salida:
- token: string JWT codificado
- expiresAt: timestamp (30 minutos desde ahora)

Estructura del Token (Payload):
{
  "userId": "uuid",
  "email": "usuario@example.com",
  "rol": "agente|supervisor|admin",
  "permissions": ["perm1", "perm2"],
  "iat": 1699123456,
  "exp": 1699125256
}

Reglas de Negocio:
- RN-C01-05: Tiempo de expiración de sesión
- RN-C01-14: Token JWT estructura

Trazabilidad:
- Proceso: PROC-AUTH-001 (paso "Crear sesión")
- Caso de Uso: UC-001 (paso 5)
- Prueba: TS-RF-006-001
```

**RF-010: Registro de Auditoría de Autenticación**

```
ID: RF-010
Título: Registro de Eventos de Autenticación
Prioridad: MUST (MoSCoW)
Categoría: Auditoría - Seguridad

Descripción:
El sistema debe registrar todos los eventos relacionados con autenticación
en la tabla de auditoría para trazabilidad y cumplimiento.

Criterios de Aceptación:
1. Registrar evento LOGIN_SUCCESS con userId, timestamp, IP
2. Registrar evento LOGIN_FAILED con email, timestamp, IP, motivo
3. Registrar evento LOGIN_BLOCKED con userId, timestamp, duración
4. Registrar evento SESSION_RENEWED con userId, timestamp
5. Los registros deben ser inmutables (solo INSERT, no UPDATE/DELETE)
6. Los registros deben persistirse antes de responder al usuario

Estructura del Registro:
{
  "id": "uuid",
  "eventType": "LOGIN_SUCCESS|LOGIN_FAILED|LOGIN_BLOCKED|SESSION_RENEWED",
  "userId": "uuid|null",
  "email": "string",
  "ipAddress": "string",
  "userAgent": "string",
  "timestamp": "ISO 8601",
  "metadata": {objeto con detalles específicos}
}

Reglas de Negocio:
- N/A (requisito de auditoría transversal)

Trazabilidad:
- Proceso: PROC-AUTH-001 (paso "Registrar evento de acceso")
- Caso de Uso: UC-001 (pasos 7, 3c, 4c)
- Prueba: TS-RF-010-001
```

**Requisitos No Funcionales:**

**RNF-005: Tiempo de Respuesta de Autenticación**

```
ID: RNF-005
Título: Tiempo de Respuesta de Proceso de Autenticación
Prioridad: SHOULD (MoSCoW)
Categoría: Rendimiento

Descripción:
El proceso completo de autenticación debe completarse en tiempo aceptable
para garantizar buena experiencia de usuario.

Métricas:
- P50 (mediana): <= 200ms
- P95 (percentil 95): <= 500ms
- P99 (percentil 99): <= 1000ms

Condiciones:
- Medición desde recepción de request POST /auth/login
- Hasta envío de response con token JWT
- Bajo carga normal (< 100 req/s)

Trazabilidad:
- Proceso: PROC-AUTH-001 (tiempo total)
- Caso de Uso: UC-001 (flujo completo)
```

### 1.5 Procedimientos Operacionales

**PROC-LOGIN-001: Procedimiento Operacional - Inicio de Sesión**

**Objetivo:** Guiar al agente en el proceso de inicio de sesión en el sistema IACT.

**Alcance:** Aplicable a todos los agentes, supervisores y administradores.

**Responsable:** Usuario final

**Frecuencia:** Cada inicio de jornada y después de cada cierre de sesión

**Pasos Detallados:**

| Paso | Pantalla | Acción del Usuario | Validación del Sistema | Referencia |
|------|----------|-------------------|----------------------|------------|
| 1 | Navegador | Abrir navegador web (Chrome, Firefox, Edge) | N/A | - |
| 2 | URL | Navegar a: https://iact.callcenter.com/login | Sistema carga formulario de login | UC-001 paso 1 |
| 3 | Formulario Login | Verificar que aparecen campos: Email y Contraseña | Sistema muestra formulario responsive | - |
| 4 | Campo Email | Ingresar email corporativo (ej: juan.perez@company.com) | Validación de formato email en tiempo real | RN-C01-01 |
| 5 | Campo Contraseña | Ingresar contraseña (mínimo 8 caracteres) | No se muestra texto plano (campo password) | RN-C01-02 |
| 6 | Botón "Iniciar Sesión" | Hacer clic en botón "Iniciar Sesión" | Sistema muestra spinner de carga | UC-001 paso 3 |
| 7 | Procesamiento | Esperar respuesta del sistema (máx 2 segundos) | Sistema valida credenciales | RF-005 |
| 8a | Dashboard | Si exitoso: Visualizar dashboard principal | Sistema redirige según rol | UC-001 paso 8 |
| 8b | Error | Si fallo: Leer mensaje de error | Sistema muestra mensaje genérico | UC-001 FA-1 |

**Casos Especiales:**

**CE-1: Contraseña Olvidada**

| Paso | Acción | Sistema |
|------|--------|---------|
| 1 | Hacer clic en enlace "¿Olvidaste tu contraseña?" | Sistema muestra formulario de recuperación |
| 2 | Ingresar email corporativo | Sistema valida formato |
| 3 | Hacer clic en "Enviar enlace de recuperación" | Sistema envía email con token temporal |
| 4 | Revisar bandeja de correo (incluir spam) | Email contiene enlace válido por 1 hora |
| 5 | Hacer clic en enlace del email | Sistema muestra formulario de nueva contraseña |
| 6 | Ingresar nueva contraseña (2 veces) | Sistema valida que cumple RN-C01-01 y RN-C01-02 |
| 7 | Confirmar cambio | Sistema actualiza contraseña y redirige a login |

**CE-2: Cuenta Bloqueada**

| Paso | Acción | Sistema |
|------|--------|---------|
| 1 | Intentar login con cuenta bloqueada | Sistema muestra "Cuenta bloqueada temporalmente" |
| 2 | Leer tiempo restante de bloqueo | Sistema indica minutos restantes |
| 3 | Esperar 15 minutos (RN-C01-04) | Sistema desbloquea automáticamente |
| 4 | Reintentar login | Sistema permite nuevo intento |
| 5 | Si persiste: Contactar a supervisor | Supervisor puede desbloquear manualmente desde admin panel |

**Errores Comunes y Soluciones:**

| Error | Causa Probable | Solución |
|-------|---------------|----------|
| "Credenciales inválidas" | Email o contraseña incorrectos | Verificar Caps Lock, revisar email, usar recuperación de contraseña |
| "Cuenta bloqueada" | 5 intentos fallidos consecutivos | Esperar 15 minutos o contactar supervisor |
| "Sesión expirada" | 30 minutos de inactividad | Hacer login nuevamente |
| "Error de conexión" | Red caída o servidor inaccesible | Verificar conexión a internet, contactar IT |
| "Token inválido" | Cookie corrupta o expirada | Limpiar cookies del navegador, recargar página |

**Validaciones Visuales (Pantalla de Login):**

```
+--------------------------------------------------+
|                  IACT Call Center                |
|                  Sistema de Gestión              |
+--------------------------------------------------+
|                                                  |
|     +----------------------------------+         |
|     |  Iniciar Sesión                  |         |
|     +----------------------------------+         |
|     |                                  |         |
|     | Email:                           |         |
|     | [____________________________]   | <- Validación: formato email
|     |                                  |         |
|     | Contraseña:                      |         |
|     | [____________________________]   | <- Validación: mín 8 caracteres
|     |                                  |         |
|     | [ ] Recordarme                   |         |
|     |                                  |         |
|     |   [  Iniciar Sesión  ]          |         |
|     |                                  |         |
|     | ¿Olvidaste tu contraseña?        |         |
|     +----------------------------------+         |
|                                                  |
+--------------------------------------------------+
```

### 1.6 Trazabilidad Completa

**Matriz de Trazabilidad: Caso Autenticación**

| Proceso | Caso de Uso | Requisito Funcional | Requisito No Funcional | Procedimiento | Regla de Negocio |
|---------|-------------|---------------------|----------------------|---------------|-----------------|
| PROC-AUTH-001 | UC-001 | RF-005 | RNF-005 | PROC-LOGIN-001 | RN-C01-01, RN-C01-02 |
| PROC-AUTH-001 | UC-001 | RF-006 | - | PROC-LOGIN-001 | RN-C01-05, RN-C01-14 |
| PROC-AUTH-001 | UC-001 | RF-010 | - | PROC-LOGIN-001 | - |
| PROC-AUTH-001 | UC-002 | RF-006 | - | - | RN-C01-06 |

**Flujo de Transformación:**

```
PROCESO DE NEGOCIO (PROC-AUTH-001)
         |
         v
ANÁLISIS DE ACTORES E INTERACCIONES
         |
         v
CASOS DE USO (UC-001, UC-002)
         |
         v
IDENTIFICACIÓN DE FUNCIONALIDADES
         |
         v
REQUISITOS FUNCIONALES (RF-005, RF-006, RF-010)
REQUISITOS NO FUNCIONALES (RNF-005)
         |
         v
APLICACIÓN DE REGLAS DE NEGOCIO
(RN-C01-01 a RN-C01-14)
         |
         v
PROCEDIMIENTOS OPERACIONALES (PROC-LOGIN-001)
         |
         v
IMPLEMENTACIÓN Y PRUEBAS
```

---

## Caso Práctico 2: Sistema de Evaluación de Permisos en Tres Niveles

### 2.1 Contexto del Negocio

**Dominio:** Call Center - Sistema IACT
**Área:** Control de Acceso y Autorización
**Objetivo:** Garantizar que los usuarios solo accedan a funciones y datos autorizados según su rol y permisos específicos

**Stakeholders:**
- Agentes (requieren acceso a funciones básicas)
- Supervisores (requieren acceso a gestión de equipos)
- Administradores (requieren acceso total al sistema)
- Auditores (requieren trazabilidad de accesos)

### 2.2 Proceso de Negocio

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

### 2.3 Casos de Uso Derivados

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

### 2.4 Requisitos Derivados

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

### 2.5 Procedimientos Operacionales

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

### 2.6 Trazabilidad Completa

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

## Caso Práctico 3: Sistema de Auditoría de Seguridad

### 3.1 Contexto del Negocio

**Dominio:** Call Center - Sistema IACT
**Área:** Auditoría y Cumplimiento
**Objetivo:** Registrar y analizar eventos de seguridad para detección de amenazas, cumplimiento regulatorio e investigación de incidentes

**Stakeholders:**
- Oficial de Seguridad (monitoreo de eventos)
- Auditores externos (cumplimiento)
- Administradores (investigación de incidentes)
- Oficiales de Cumplimiento (reportes regulatorios)

### 3.2 Proceso de Negocio

**PROC-AUDIT-001: Proceso de Registro y Análisis de Eventos de Seguridad**

```
INICIO
  |
  v
[Evento de seguridad ocurre en el sistema]
  |
  v
[Capturar contexto del evento: tipo, usuario, recurso, timestamp, IP]
  |
  v
[Clasificar criticidad: INFO|WARNING|CRITICAL]
  |
  v
[Registrar evento en tabla audit_log (inmutable)]
  |
  v
[¿Evento es CRITICAL?]
  |
  |--No--> [Continuar operación normal] --> FIN
  |
  |--Si--> [Evaluar reglas de detección de amenazas]
            |
            v
         [¿Patrón sospechoso detectado?]
            |
            |--No--> FIN
            |
            |--Si--> [Generar alerta de seguridad]
                     |
                     v
                  [Notificar a oficial de seguridad]
                     |
                     v
                  [Registrar alerta en tabla security_alerts]
                     |
                     v
                  [¿Requiere bloqueo automático?]
                     |
                     |--No--> FIN
                     |
                     |--Si--> [Bloquear cuenta/IP]
                              |
                              v
                           [Notificar a administrador]
                              |
                              v
                           FIN
```

**Actores:**
- Sistema (generador de eventos)
- Módulo de Auditoría (registro)
- Módulo de Detección de Amenazas (análisis)
- Oficial de Seguridad (investigación)

### 3.3 Casos de Uso Derivados

**UC-020: Registrar Evento de Auditoría**

| Caso de Uso | UC-020: Registrar Evento de Auditoría |
|-------------|--------------------------------------|
| **Actor Principal** | Sistema (automático) |
| **Stakeholders** | - Oficial de Seguridad: Requiere eventos completos<br>- Auditor: Necesita trazabilidad<br>- Administrador: Usa para investigación |
| **Precondiciones** | - Evento de seguridad ha ocurrido<br>- Módulo de auditoría operativo<br>- Conexión a base de datos disponible |
| **Postcondiciones Éxito** | - Evento registrado en audit_log<br>- Timestamp asignado<br>- Evento inmutable (no modificable) |

**Flujo Principal:**

| Paso | Acción del Sistema |
|------|--------------------|
| 1 | Sistema detecta evento de seguridad (login, acceso, cambio, error) |
| 2 | Sistema captura contexto completo del evento |
| 3 | Sistema genera UUID único para el evento |
| 4 | Sistema clasifica criticidad (INFO/WARNING/CRITICAL) |
| 5 | Sistema serializa metadata adicional en formato JSON |
| 6 | Sistema inserta registro en tabla audit_log |
| 7 | Sistema confirma persistencia del registro |

**Tipos de Eventos Auditados:**

| Categoría | Eventos | Criticidad |
|-----------|---------|-----------|
| Autenticación | LOGIN_SUCCESS, LOGIN_FAILED, LOGIN_BLOCKED, LOGOUT | WARNING/CRITICAL |
| Autorización | PERMISSION_GRANTED, PERMISSION_DENIED | INFO/WARNING |
| Gestión de Usuarios | USER_CREATED, USER_UPDATED, USER_DELETED, ROLE_CHANGED | WARNING |
| Datos Sensibles | SENSITIVE_DATA_ACCESSED, SENSITIVE_DATA_EXPORTED | CRITICAL |
| Configuración | CONFIG_CHANGED, PERMISSION_CHANGED | WARNING |
| Errores | SYSTEM_ERROR, DATABASE_ERROR, INTEGRATION_ERROR | CRITICAL |

**UC-021: Detectar Patrón Sospechoso**

| Caso de Uso | UC-021: Detectar Patrón Sospechoso |
|-------------|-----------------------------------|
| **Actor Principal** | Módulo de Detección de Amenazas (automático) |
| **Precondiciones** | - Eventos de auditoría registrados<br>- Reglas de detección configuradas |
| **Postcondiciones Éxito** | - Alerta generada si patrón detectado<br>- Oficial de seguridad notificado<br>- Acción correctiva ejecutada (si aplicable) |

**Flujo Principal:**

| Paso | Acción del Sistema |
|------|--------------------|
| 1 | Sistema analiza eventos recientes (ventana de 15 minutos) |
| 2 | Sistema aplica reglas de detección de amenazas |
| 3 | Sistema identifica patrón sospechoso |
| 4 | Sistema genera alerta con severidad (LOW/MEDIUM/HIGH) |
| 5 | Sistema registra alerta en security_alerts |
| 6 | Sistema notifica a oficial de seguridad (email/Slack) |
| 7 | Sistema ejecuta acción correctiva automática (si configurada) |

**Patrones de Amenaza Detectados:**

| Patrón | Descripción | Regla | Acción |
|--------|-------------|-------|--------|
| Fuerza Bruta | >5 LOGIN_FAILED en 5 min desde misma IP | 5/5min | Bloquear IP temporalmente |
| Escalación de Privilegios | Múltiples PERMISSION_DENIED + cambio de rol | 10/15min | Alertar admin |
| Acceso Anómalo | Login desde país/IP inusual | GeoIP check | Alertar usuario y admin |
| Extracción Masiva | >100 SENSITIVE_DATA_ACCESSED en 10 min | 100/10min | Bloquear cuenta |
| Manipulación de Auditoría | Intento de DELETE en audit_log | 1 intento | Bloquear inmediatamente |

### 3.4 Requisitos Derivados

**RF-020: Registro Inmutable de Eventos de Auditoría**

```
ID: RF-020
Título: Registro Inmutable de Eventos de Auditoría
Prioridad: MUST (MoSCoW)
Categoría: Auditoría - Cumplimiento

Descripción:
El sistema debe registrar todos los eventos de seguridad en una tabla
inmutable (solo INSERT) con integridad criptográfica.

Criterios de Aceptación:
1. Todos los eventos de seguridad deben registrarse automáticamente
2. Registros deben ser inmutables (no UPDATE, no DELETE)
3. Tabla audit_log debe tener trigger que bloquee modificaciones
4. Cada registro debe tener hash SHA-256 para verificar integridad
5. Registros deben persistirse de forma síncrona (antes de responder)

Estructura del Registro:
CREATE TABLE audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type VARCHAR(50) NOT NULL,
  event_category VARCHAR(20) NOT NULL,
  severity VARCHAR(10) NOT NULL,
  user_id UUID,
  user_email VARCHAR(255),
  resource VARCHAR(255),
  action VARCHAR(50),
  result VARCHAR(20),
  ip_address INET,
  user_agent TEXT,
  metadata JSONB,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  integrity_hash VARCHAR(64) NOT NULL
);

-- Trigger para prevenir modificaciones
CREATE TRIGGER prevent_audit_modification
  BEFORE UPDATE OR DELETE ON audit_log
  FOR EACH ROW EXECUTE FUNCTION prevent_modification();

Cálculo de Hash:
hash = SHA256(
  event_type + user_id + resource + action +
  timestamp + secret_key
)

Trazabilidad:
- Proceso: PROC-AUDIT-001
- Caso de Uso: UC-020
- Prueba: TS-RF-020-001
```

**RF-021: Detección Automática de Amenazas**

```
ID: RF-021
Título: Detección Automática de Patrones de Amenaza
Prioridad: SHOULD (MoSCoW)
Categoría: Seguridad - Detección de Amenazas

Descripción:
El sistema debe analizar eventos de auditoría en tiempo real para
detectar patrones sospechosos y generar alertas automáticas.

Criterios de Aceptación:
1. Análisis debe ejecutarse en ventanas de tiempo (5, 10, 15 min)
2. Sistema debe detectar al menos 5 patrones predefinidos
3. Alertas deben generarse en menos de 30 segundos desde detección
4. Alertas deben incluir evidencia (eventos relacionados)
5. Acciones correctivas deben ejecutarse automáticamente si configuradas

Reglas de Detección:

REGLA 1: Fuerza Bruta
- Condición: >5 LOGIN_FAILED desde misma IP en 5 min
- Severidad: HIGH
- Acción: Bloquear IP por 1 hora

REGLA 2: Escalación de Privilegios
- Condición: >10 PERMISSION_DENIED + ROLE_CHANGED en 15 min
- Severidad: CRITICAL
- Acción: Bloquear cuenta + notificar admin

REGLA 3: Acceso Anómalo
- Condición: Login desde país no habitual (últimos 90 días)
- Severidad: MEDIUM
- Acción: Notificar usuario + requerir 2FA

REGLA 4: Extracción Masiva
- Condición: >100 SENSITIVE_DATA_ACCESSED en 10 min
- Severidad: CRITICAL
- Acción: Bloquear cuenta + alerta inmediata

REGLA 5: Manipulación de Auditoría
- Condición: Cualquier intento UPDATE/DELETE en audit_log
- Severidad: CRITICAL
- Acción: Bloquear cuenta permanentemente

Estructura de Alerta:
{
  "id": "uuid",
  "patternType": "BRUTE_FORCE | PRIVILEGE_ESCALATION | ...",
  "severity": "LOW | MEDIUM | HIGH | CRITICAL",
  "detectedAt": "timestamp",
  "userId": "uuid",
  "evidenceEvents": ["eventId1", "eventId2", ...],
  "automaticActionTaken": "IP_BLOCKED | ACCOUNT_SUSPENDED | ...",
  "notifiedTo": ["security@company.com"]
}

Trazabilidad:
- Proceso: PROC-AUDIT-001
- Caso de Uso: UC-021
- Prueba: TS-RF-021-001 a TS-RF-021-005
```

**RF-022: Generación de Reportes de Auditoría**

```
ID: RF-022
Título: Generación de Reportes de Auditoría
Prioridad: SHOULD (MoSCoW)
Categoría: Auditoría - Reportes

Descripción:
El sistema debe permitir generar reportes de auditoría filtrados por
fecha, usuario, tipo de evento y severidad para análisis y cumplimiento.

Criterios de Aceptación:
1. Soportar filtros: fecha_inicio, fecha_fin, userId, eventType, severity
2. Generar reportes en formatos: PDF, CSV, JSON
3. Incluir métricas agregadas (total eventos, por tipo, por severidad)
4. Permitir exportación de hasta 10,000 eventos por reporte
5. Reportes deben generarse en menos de 10 segundos

Filtros Disponibles:
- Rango de fechas (obligatorio, máx 90 días)
- Usuario específico (opcional)
- Tipo de evento (opcional, multi-selección)
- Severidad (opcional, multi-selección)
- Resultado (SUCCESS/FAILURE)

Métricas Incluidas:
- Total de eventos en el período
- Distribución por tipo de evento (gráfico)
- Distribución por severidad (gráfico)
- Top 10 usuarios con más eventos
- Top 10 IPs con más eventos
- Tendencia temporal (eventos por día)

Formato del Reporte:

PDF:
- Encabezado con logo y período
- Sección de métricas agregadas
- Tabla de eventos con paginación
- Firma digital del sistema

CSV:
- Headers con nombres de columnas
- Filas con datos de eventos
- UTF-8 encoding

JSON:
- Array de objetos evento
- Metadata del reporte

Trazabilidad:
- Proceso: PROC-AUDIT-001
- Caso de Uso: UC-022 (Generar Reporte de Auditoría)
- Prueba: TS-RF-022-001
```

### 3.5 Procedimientos Operacionales

**PROC-AUDIT-REVIEW-001: Procedimiento de Revisión de Eventos de Seguridad**

**Objetivo:** Guiar al oficial de seguridad en la revisión periódica de eventos de auditoría.

**Alcance:** Aplicable a oficiales de seguridad y administradores

**Responsable:** Oficial de Seguridad

**Frecuencia:** Diaria (eventos CRITICAL), Semanal (eventos WARNING), Mensual (todos)

**Pasos Detallados:**

| Paso | Pantalla | Acción | Sistema |
|------|----------|--------|---------|
| 1 | Dashboard Seguridad | Navegar a "Auditoría y Seguridad" | Sistema carga dashboard con métricas del día |
| 2 | Métricas | Revisar panel de alertas activas | Sistema muestra alertas críticas no resueltas |
| 3 | Alertas CRITICAL | Hacer clic en alerta con severidad CRITICAL | Sistema muestra detalles y eventos relacionados |
| 4 | Investigación | Revisar eventos de evidencia (expandir JSON) | Sistema presenta timeline de eventos |
| 5 | Análisis | Determinar si es amenaza real o falso positivo | - |
| 6a | Si amenaza real | Hacer clic en "Escalar Incidente" | Sistema crea ticket de incidente |
| 6b | Si falso positivo | Hacer clic en "Marcar como Falso Positivo" | Sistema actualiza alerta y ajusta regla |
| 7 | Acciones | Ejecutar acciones correctivas (bloquear usuario, resetear contraseña) | Sistema ejecuta y registra acciones |
| 8 | Documentación | Agregar notas de investigación | Sistema guarda notas en la alerta |
| 9 | Reporte | Generar reporte de eventos del día | Sistema genera PDF con eventos CRITICAL |
| 10 | Envío | Enviar reporte a stakeholders | Sistema envía email con reporte adjunto |

**Checklist de Revisión Diaria:**

- [ ] Revisar todas las alertas CRITICAL generadas en las últimas 24 horas
- [ ] Investigar cualquier patrón de fuerza bruta (LOGIN_FAILED múltiples)
- [ ] Verificar accesos desde IPs/países inusuales
- [ ] Revisar intentos de escalación de privilegios
- [ ] Analizar eventos de acceso a datos sensibles
- [ ] Confirmar que no hay intentos de manipulación de auditoría
- [ ] Documentar incidentes y acciones tomadas
- [ ] Generar y enviar reporte diario a CISO

### 3.6 Trazabilidad Completa

**Matriz de Trazabilidad: Caso Auditoría**

| Proceso | Caso de Uso | Requisito Funcional | Procedimiento | Prueba |
|---------|-------------|---------------------|---------------|--------|
| PROC-AUDIT-001 | UC-020 | RF-020 | - | TS-RF-020-001 |
| PROC-AUDIT-001 | UC-021 | RF-021 | PROC-AUDIT-REVIEW-001 | TS-RF-021-001 |
| PROC-AUDIT-001 | UC-022 | RF-022 | PROC-AUDIT-REVIEW-001 | TS-RF-022-001 |

**Flujo de Transformación:**

```
PROCESO DE NEGOCIO (PROC-AUDIT-001)
         |
         v
CASOS DE USO
- UC-020: Registrar Evento
- UC-021: Detectar Amenaza
- UC-022: Generar Reporte
         |
         v
REQUISITOS FUNCIONALES
- RF-020: Registro inmutable
- RF-021: Detección automática
- RF-022: Reportes de auditoría
         |
         v
PROCEDIMIENTOS OPERACIONALES
(PROC-AUDIT-REVIEW-001)
         |
         v
IMPLEMENTACIÓN Y PRUEBAS
```

---

## Resumen de Casos Prácticos IACT

### Casos Implementados

| # | Caso | Proceso | Casos de Uso | Requisitos | Procedimientos |
|---|------|---------|--------------|-----------|----------------|
| 1 | Autenticación y Sesiones | PROC-AUTH-001 | UC-001, UC-002 | RF-005, RF-006, RF-010, RNF-005 | PROC-LOGIN-001 |
| 2 | Evaluación de Permisos | PROC-PERM-001 | UC-010, UC-011 | RF-001, RF-011, RF-012 | PROC-PERM-ADMIN-001 |
| 3 | Auditoría de Seguridad | PROC-AUDIT-001 | UC-020, UC-021, UC-022 | RF-020, RF-021, RF-022 | PROC-AUDIT-REVIEW-001 |

### Métricas de Cobertura

- **Procesos Documentados:** 3
- **Casos de Uso Derivados:** 8
- **Requisitos Funcionales:** 11
- **Requisitos No Funcionales:** 1
- **Procedimientos Operacionales:** 3
- **Reglas de Negocio Aplicadas:** 14 (RN-C01-01 a RN-C01-14)

### Referencias a Documentación Real

Todos los casos prácticos están basados en documentación real del proyecto IACT:

- `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (1859 líneas)
- `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md` (1039 líneas)
- Casos de uso reales: UC-001, UC-002, UC-010, UC-011

### Valor Demostrativo

Estos casos prácticos demuestran:

1. **Flujo completo**: Desde proceso de negocio hasta procedimiento operacional
2. **Trazabilidad bidireccional**: Cada artefacto referencia sus orígenes y derivados
3. **Aplicación de estándares**: ISO 29148:2018, BABOK v3, UML 2.5
4. **Integración real**: Basados en código y documentación existente del proyecto
5. **Cobertura completa**: Todos los niveles del marco integrado representados

---

**Próximo Documento:** `05b_caso_didactico_generico.md` - Caso pedagógico con ejemplo bancario para propósitos didácticos.

**Referencias:**
- `docs/gobernanza/marco_integrado/01_marco_conceptual_iact.md`
- `docs/gobernanza/marco_integrado/02_relaciones_fundamentales_iact.md`
- `docs/gobernanza/marco_integrado/03_matrices_trazabilidad_iact.md`
- `docs/gobernanza/marco_integrado/04_metodologia_analisis_iact.md`
