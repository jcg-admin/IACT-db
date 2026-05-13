---
title: Caso Práctico 1 - Sistema de Autenticación y Gestión de Sesiones
date: 2025-11-16
domain: backend
status: active
caso_numero: 1
relacionado:
  - ../05a_casos_practicos_iact.md
  - ../../backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md
  - ../../backend/requisitos/funcionales/rf005_validacion_credenciales.md
---

# Caso Práctico 1: Sistema de Autenticación y Gestión de Sesiones

**Versión:** 1.0
**Fecha:** 2025-11-05
**Estado:** Vigente
**Dominio:** Call Center - Sistema IACT

---

## 1.1 Contexto del Negocio

**Dominio:** Call Center - Sistema IACT
**Área:** Seguridad y Control de Acceso
**Objetivo:** Garantizar autenticación segura y gestión robusta de sesiones de usuario

**Stakeholders:**
- Agentes de call center (usuarios finales)
- Supervisores (gestión de equipos)
- Administradores de seguridad
- Oficiales de cumplimiento (auditoría)

---

## 1.2 Proceso de Negocio

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

---

## 1.3 Casos de Uso Derivados

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

---

## 1.4 Requisitos Derivados

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

---

## 1.5 Procedimientos Operacionales

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

---

## 1.6 Trazabilidad Completa

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

**Referencias:**
- Documento maestro: `../05a_casos_practicos_iact.md`
- Reglas de negocio: `../../backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`
- Requisitos funcionales: `../../backend/requisitos/funcionales/rf005_validacion_credenciales.md`
- Marco conceptual: `../01_marco_conceptual_iact.md`
