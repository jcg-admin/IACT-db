---
id: DOC-GOB-MARCO-02
estado: activo
propietario: equipo-ba
ultima_actualizacion: 2025-11-05
relacionados: 
  - DOC-GOB-MARCO-01
  - DOC-GOB-MARCO-03
estandares: ["BABOK v3", "ISO/IEC/IEEE 29148:2018"]
---

# Relaciones Fundamentales: Transformaciones en el Análisis - IACT

**VERSION:** 1.0  
**FECHA:** 2025-11-05  
**ESTADO:** Activo

---

## Navegación

- [00 - Resumen Ejecutivo](00_resumen_ejecutivo_mejores_practicas.md)
- [01 - Marco Conceptual](01_marco_conceptual_iact.md)
- **[02] Relaciones Fundamentales** (este documento)
- [03 - Matrices de Trazabilidad](03_matrices_trazabilidad_iact.md)
- [04 - Metodología de Análisis](04_metodologia_analisis_iact.md)
- [05 - Casos Prácticos](05_casos_practicos_iact.md)
- [06 - Plantillas Integradas](06_plantillas_integradas_iact.md)

---

## 1. Procesos → Casos de Uso

### 1.1 Principio de Transformación

**REGLA:** Cada actividad significativa en un proceso que involucra interacción con el sistema puede convertirse en un caso de uso.

```
PROCESO (BPMN)
    |
    | Por cada actividad que requiere sistema
    v
CASO DE USO (UC-XXX)
```

### 1.2 Patrón de Transformación

```
ACTIVIDAD DEL PROCESO
    |
    | ¿Requiere sistema?
    |
    +-- NO --> Actividad manual (no genera UC)
    |
    +-- SI --> ¿Qué tipo de interacción?
               |
               +-- Captura de datos --> UC de registro
               +-- Consulta de información --> UC de consulta
               +-- Procesamiento automático --> UC de proceso
               +-- Decisión basada en reglas --> UC de validación
               +-- Generación de documento --> UC de generación
               +-- Integración con sistema externo --> UC de integración
```

### 1.3 Ejemplo Real IACT: Proceso de Autenticación

**PROCESO: Autenticación de Usuario (BPMN)**

```
[Inicio]
    |
    v
[A1: Usuario ingresa credenciales] --> ¿Requiere sistema? SI
    |                                     |
    |                                     v
    |                                UC-001: Iniciar Sesión
    v
[A2: Sistema valida credenciales] --> ¿Requiere sistema? SI (parte de UC-001)
    |
    v
[A3: Sistema genera tokens JWT] --> ¿Requiere sistema? SI (parte de UC-001)
    |
    v
[A4: Sistema registra sesión] --> ¿Requiere sistema? SI (parte de UC-001)
    |
    v
[A5: Usuario trabaja en el sistema] --> ¿Requiere sistema? NO (uso normal)
    |
    v
[A6: Usuario cierra sesión] --> ¿Requiere sistema? SI
    |                             |
    |                             v
    |                        UC-002: Cerrar Sesión
    v
[Fin]
```

**RESULTADO:**
- Proceso de 6 actividades → 2 casos de uso principales
- UC-001: Iniciar Sesión (agrupa A1-A4)
- UC-002: Cerrar Sesión (A6)

**Fuente:** Análisis del proceso documentado en `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

### 1.4 Criterios de Decisión

**¿Cuándo una actividad genera un caso de uso?**

SI cumple AL MENOS UNO:
- Requiere captura de datos en sistema
- Requiere consulta de información del sistema
- Requiere cálculo o procesamiento automático
- Requiere decisión basada en reglas del sistema
- Requiere generación de documento/reporte
- Requiere integración con otro sistema

ENTONCES:
→ Crear caso de uso

SINO:
→ No crear caso de uso (es actividad manual)

---

## 2. Casos de Uso → Requisitos Funcionales

### 2.1 Principio de Derivación

**REGLA:** Cada paso en el flujo de un caso de uso que describe una acción del sistema genera uno o más requisitos funcionales.

```
CASO DE USO
    |
    | Por cada paso donde el SISTEMA actúa
    v
REQUISITO FUNCIONAL (RF-XXX)
```

### 2.2 Patrón de Derivación

```
CASO DE USO: [Nombre]
    |
    Paso 1: [Actor hace algo] --> NO genera RF
    |
    Paso 2: [Sistema responde] --> RF-XXX: Sistema debe [acción]
    |
    Paso 3: [Sistema valida] --> RF-YYY: Sistema debe validar [condición]
    |                            + RN-ZZZ: Regla de validación
    |
    Paso 4: [Sistema calcula] --> RF-AAA: Sistema debe calcular [fórmula]
    |                            + RN-BBB: Fórmula de cálculo
    |
    Paso 5: [Sistema notifica] --> RF-CCC: Sistema debe notificar [evento]
```

### 2.3 Ejemplo Real IACT: UC-001 → Requisitos

**CASO DE USO: UC-001 Iniciar Sesión**

```
ESPECIFICACION (formato dos columnas):

| Actor | Sistema |
|-------|---------|
| 1. Usuario ingresa username y password | |
| | 2. Sistema valida credenciales [RN-C01-02] |
| | 3. Sistema cierra sesión previa si existe [RN-C01-14] |
| | 4. Sistema genera access token (15 min) [RN-C01-03] |
| | 5. Sistema genera refresh token (7 días) [RN-C01-03] |
| | 6. Sistema registra nueva sesión [RN-C01-13] |
| | 7. Sistema actualiza last_login_at del usuario |
| | 8. Sistema retorna tokens JWT |
```

**REQUISITOS DERIVADOS:**

```
Paso 2 genera:
RF-005: API POST /api/v1/auth/login debe validar username/password contra PostgreSQL
  - Validar que username existe
  - Validar que password coincide con hash bcrypt
  - Validar que usuario está activo
  - Validar que usuario no está bloqueado
  Trazabilidad Upward: RN-C01-01, RN-C01-02
  Ubicación: docs/implementacion/backend/requisitos/funcionales/rf005_login_credenciales_locales.md

Paso 3 genera:
RF-010: Sistema debe permitir solo 1 sesión activa por usuario
  - Cerrar sesiones previas en user_sessions
  - Cerrar sesiones previas en django_session
  - Notificar cierre vía buzón interno
  Trazabilidad Upward: RN-C01-14
  Ubicación: docs/implementacion/backend/requisitos/funcionales/rf010_sesion_unica.md

Pasos 4-5 generan:
RF-006: Sistema debe generar tokens JWT con djangorestframework-simplejwt
  - Access token: 15 minutos exactos
  - Refresh token: 7 días exactos
  - Claims personalizados: username, email, segment, roles
  - Algoritmo HS256 con SECRET_KEY
  Trazabilidad Upward: RN-C01-03
  Ubicación: docs/implementacion/backend/requisitos/funcionales/rf006_tokens_jwt.md

Paso 6 genera:
RF-007: Sistema debe registrar sesión en PostgreSQL
  - Tabla user_sessions: user_id, session_key, user_agent
  - Campo is_active = True
  - Timestamp created_at y last_activity_at
  Trazabilidad Upward: RN-C01-13
  Ubicación: docs/implementacion/backend/requisitos/funcionales/rf007_sesiones_postgresql.md

Paso 7 genera:
RF-008: Sistema debe actualizar campos del usuario post-login
  - last_login_at = timestamp actual
  - failed_login_attempts = 0 (resetear contador)
  - last_failed_login_at = NULL
  Trazabilidad Upward: RN-C01-01

Paso 8 genera:
RF-009: API debe retornar respuesta JSON con tokens
  - Estructura: {access_token, refresh_token, token_type, expires_in}
  - HTTP 200 OK si éxito
  - HTTP 401 si credenciales inválidas
  - HTTP 403 si usuario bloqueado
  Trazabilidad Upward: RN-C01-01

ADICIONALMENTE (de flujos alternos y excepciones):
RNF-001: Tiempo de respuesta del endpoint < 500ms (P95)
RNF-002: Cumplir con PCI-DSS para manejo de credenciales
RNF-003: Transacción ACID en PostgreSQL
```

**RESULTADO:**
- 1 Caso de Uso (8 pasos) → 6 Requisitos Funcionales + 3 No Funcionales

### 2.4 Técnica del Verbo del Sistema

Buscar en cada paso del caso de uso los verbos que indican acción del SISTEMA:

```
- Sistema MUESTRA     → RF: Interfaz de usuario
- Sistema VALIDA      → RF: Validación + RN
- Sistema CALCULA     → RF: Lógica + RN (fórmula)
- Sistema GUARDA      → RF: Persistencia
- Sistema NOTIFICA    → RF: Comunicación
- Sistema GENERA      → RF: Creación de documento
- Sistema INTEGRA     → RF: Integración
- Sistema PROCESA     → RF: Lógica de negocio
- Sistema CONSULTA    → RF: Acceso a datos
- Sistema ACTUALIZA   → RF: Modificación de datos
- Sistema ELIMINA     → RF: Eliminación lógica/física
```

---

## 3. Reglas de Negocio → Todo lo Demás

### 3.1 Principio Transversal

**REGLA:** Las reglas de negocio son TRANSVERSALES y afectan todos los niveles del análisis.

```
REGLA DE NEGOCIO (RN-XXX)
    |
    +--> IMPACTA PROCESO (bifurcaciones, validaciones)
    +--> GENERA/MODIFICA CASO DE USO (precondiciones, flujos alternos)
    +--> GENERA REQUISITOS (funcionales, no funcionales)
    +--> DETALLA PROCEDIMIENTO (validaciones, mensajes)
```

### 3.2 Matriz de Impacto por Tipo de Regla

```
┌─────────────┬─────────────────┬──────────────────┬─────────────────┐
│ TIPO REGLA  │ IMPACTA EN      │ GENERA           │ EJEMPLO IACT    │
├─────────────┼─────────────────┼──────────────────┼─────────────────┤
│ HECHO       │ - Modelo datos  │ - Atributos      │ RN-USER-01:     │
│             │ - Procesos      │ - Relaciones     │ "Cada usuario   │
│             │ - Casos uso     │ - Validaciones   │ tiene username  │
│             │                 │                  │ único"          │
├─────────────┼─────────────────┼──────────────────┼─────────────────┤
│ RESTRICCION │ - Procesos      │ - Validaciones   │ RN-C01-07:      │
│             │ - Casos uso     │ - Controles      │ "Password debe  │
│             │ - Requisitos    │ - Autorizaciones │ tener 8+ chars" │
├─────────────┼─────────────────┼──────────────────┼─────────────────┤
│ DESENCADEN. │ - Procesos      │ - Casos de uso   │ RN-C01-06:      │
│             │ - Flujos        │ - Notificaciones │ "Si inactividad │
│             │ - Requisitos    │ - Workflows      │ >30min cerrar"  │
├─────────────┼─────────────────┼──────────────────┼─────────────────┤
│ INFERENCIA  │ - Procesos      │ - Lógica negocio │ RN-PERM-01:     │
│             │ - Casos uso     │ - Clasificaciones│ "Si rol Admin   │
│             │ - Requisitos    │ - Estados        │ tiene todos los │
│             │                 │                  │ permisos"       │
├─────────────┼─────────────────┼──────────────────┼─────────────────┤
│ CALCULO     │ - Procesos      │ - Algoritmos     │ RN-C01-BCRYPT:  │
│             │ - Casos uso     │ - Fórmulas       │ "Hash = bcrypt  │
│             │ - Requisitos    │ - Transformacion │ (pwd, cost=12)" │
└─────────────┴─────────────────┴──────────────────┴─────────────────┘
```

### 3.3 Ejemplo Real IACT: RN-C01-14 atravesando todos los niveles

**REGLA:** RN-C01-14 "Sesión única por usuario"

```
RN-C01-14: Solo 1 sesión activa por usuario
Tipo: Restricción
Fuente: Política de Seguridad PSI-001
Ubicación: rn_c01_autenticacion_sesiones.md:1758-1833

IMPACTA EN:

PROCESO: Autenticación de Usuario
    |
    | Agregar actividad: "Cerrar sesión anterior"
    v
Actividad Nueva: "A2.5: Sistema cierra sesión previa si existe"

CASO DE USO: UC-001 Iniciar Sesión
    |
    | Agregar paso en flujo principal
    v
Paso 3: Sistema cierra sesión previa si existe [RN-C01-14]
        - Cerrar en user_sessions (is_active=False)
        - Cerrar en django_session (delete)
        - Notificar usuario vía buzón interno

REQUISITOS:
    |
    | Generar requisito funcional
    v
RF-010: Sistema debe permitir solo 1 sesión activa por usuario
    - Consultar UserSession.objects.filter(user=user, is_active=True)
    - Si existe sesión previa:
      * session.is_active = False
      * session.logged_out_at = now()
      * session.logout_reason = 'NEW_SESSION'
      * Eliminar django_session correspondiente
    - Crear InternalMessage notificando cierre
    Trazabilidad Upward: RN-C01-14
    Ubicación: rf010_sesion_unica.md

PROCEDIMIENTO: PROC-LOGIN-001
    |
    | Agregar paso en manual de usuario
    v
Paso 3: Notificación de cierre de sesión
    - Si tenías sesión abierta en otro dispositivo, será cerrada automáticamente
    - Recibirás notificación en tu buzón interno
    - Pantalla: MOD-NOTIFICATION-001
    - Mensaje: "Se ha iniciado nueva sesión. Sesión anterior cerrada."

DISEÑO:
    |
    | Agregar componente
    v
COMPONENTE: UserSession.close_previous_sessions()
Archivo: callcentersite/apps/users/models.py
Método:
def close_previous_sessions(self, user, new_session_key):
    active_sessions = UserSession.objects.filter(
        user=user,
        is_active=True
    ).exclude(session_key=new_session_key)
    
    for session in active_sessions:
        session.is_active = False
        session.logged_out_at = timezone.now()
        session.logout_reason = 'NEW_SESSION'
        session.save()

TESTS:
    |
    | Agregar test case
    v
TEST-009: test_single_session_closes_previous
Archivo: tests/users/test_auth_login.py
Verifica:
- Login con user A en dispositivo 1
- Login con user A en dispositivo 2
- Sesión en dispositivo 1 se cierra automáticamente
- Solo 1 sesión activa en BD
```

**EVIDENCIA:** Esta regla impacta 6 niveles diferentes del análisis.

---

## 4. Procedimientos → Requisitos Detallados de UI

### 4.1 Principio de Detalle

**REGLA:** Los procedimientos especifican el DETALLE de la interfaz de usuario y las validaciones específicas.

```
CASO DE USO (Alto nivel)
"Sistema valida datos del cliente"
    |
    | Se expande en
    v
REQUISITO FUNCIONAL (Medio nivel)
"RF-020: Sistema valida campos obligatorios"
    |
    | Se detalla en
    v
PROCEDIMIENTO (Bajo nivel - Paso a paso)
"Paso 3.1: Verificar campo Nombre
  - Si vacío: Mensaje 'Nombre es obligatorio'
  - Marcar campo con borde rojo
  - Colocar cursor en campo
  - Deshabilitar botón Guardar"
```

### 4.2 Nivel de Detalle Requerido

Los procedimientos NO son genéricos, especifican:

```
COMPONENTES DE UI:
- Pantalla exacta: FRM-LOGIN-001
- Campo exacto: txtUsername (control name)
- Botón exacto: btnGuardar (control name)
- Modal exacto: MOD-CONFIRM-001

VALIDACIONES:
- Tipo: obligatorio, formato, rango
- Mensaje exacto: "Nombre es obligatorio"
- Ubicación mensaje: bajo el campo
- Color: rojo (#FF0000) para error

COMPORTAMIENTO:
- Cuándo validar: on blur, on submit
- Qué deshabilitar: botón Guardar
- Qué mostrar: spinner, mensaje
```

### 4.3 Ejemplo Real IACT: PROC-LOGIN-001

**PROCEDIMIENTO: Iniciar Sesión en el Sistema**

```
PASO 1: Acceder a la pantalla de login
──────────────────────────────────────────
1.1 Abrir navegador Chrome (versión 90+)
1.2 Ir a URL: https://iact.company.com/login
1.3 Esperar carga de pantalla (< 2 segundos)
1.4 Verificar que aparezca:
    - Logo de IACT (arriba centro)
    - Formulario de login (centro)
    - Enlace "¿Olvidaste tu contraseña?" (abajo)

Pantalla: FRM-LOGIN-001
Componentes visibles:
- lblTitulo: "Iniciar Sesión"
- txtUsername: Campo de texto
- txtPassword: Campo de contraseña
- btnLogin: Botón verde "Ingresar"
- lnkForgotPassword: Enlace azul

PASO 2: Ingresar username
──────────────────────────────────────────
2.1 Hacer clic en campo "Usuario" (txtUsername)
2.2 Escribir username (4-20 caracteres)

VALIDACIONES (on blur):
- Si vacío:
  * Mostrar mensaje bajo campo: "Usuario es obligatorio"
  * Borde rojo en txtUsername
  * Deshabilitar btnLogin

- Si formato inválido (espacios, caracteres especiales):
  * Mostrar: "Usuario solo puede contener letras y números"
  * Borde rojo en txtUsername
  * Deshabilitar btnLogin

- Si correcto:
  * Borde verde en txtUsername
  * Habilitar btnLogin si txtPassword también válido

PASO 3: Ingresar password
──────────────────────────────────────────
3.1 Hacer clic en campo "Contraseña" (txtPassword)
3.2 Escribir contraseña (8-100 caracteres)
3.3 Observar: caracteres se muestran como asteriscos

VALIDACIONES (on blur):
- Si vacío:
  * Mostrar: "Contraseña es obligatoria"
  * Borde rojo en txtPassword
  * Deshabilitar btnLogin

- Si longitud < 8 caracteres:
  * Mostrar: "Contraseña debe tener al menos 8 caracteres"
  * Borde rojo en txtPassword
  * Deshabilitar btnLogin

- Si correcto:
  * Borde verde en txtPassword
  * Habilitar btnLogin si txtUsername también válido

PASO 4: Enviar credenciales
──────────────────────────────────────────
4.1 Verificar que btnLogin esté habilitado (verde)
4.2 Hacer clic en "Ingresar" o presionar Enter

PASO 5: Esperar respuesta
──────────────────────────────────────────
5.1 Observar:
    - Spinner de carga en btnLogin
    - Texto del botón cambia a "Ingresando..."
    - Botón se deshabilita temporalmente
5.2 Esperar respuesta (< 500ms típico)

PASO 6A: Login exitoso
──────────────────────────────────────────
6A.1 Sistema muestra:
     - Mensaje "Bienvenido [nombre]" (toast verde, 3 seg)
     - Redirección a dashboard (< 1 segundo)
6A.2 Dashboard principal se carga (FRM-DASHBOARD-001)
6A.3 Observar en header:
     - Nombre de usuario (arriba derecha)
     - Botón "Cerrar Sesión"

PASO 6B: Error - Credenciales inválidas
──────────────────────────────────────────
6B.1 Sistema muestra:
     - Modal de error (MOD-ERROR-001)
     - Mensaje: "Usuario o contraseña incorrectos"
     - Intentos restantes: "X intentos restantes" (si X < 3)
     - Botón "Cerrar" (rojo)
6B.2 Hacer clic en "Cerrar"
6B.3 Modal se cierra
6B.4 Foco regresa a txtPassword (vacío)
6B.5 txtUsername mantiene valor ingresado

PASO 6C: Error - Usuario bloqueado
──────────────────────────────────────────
6C.1 Sistema muestra:
     - Modal de error (MOD-ERROR-001)
     - Mensaje: "Tu cuenta ha sido bloqueada por múltiples
       intentos fallidos. Será desbloqueada automáticamente
       en [X] minutos."
     - Botón "Contactar Administrador" (amarillo)
     - Botón "Cerrar" (rojo)
6C.2 Opciones:
     - Clic "Contactar Administrador": abre email a soporte@
     - Clic "Cerrar": regresa a FRM-LOGIN-001

CASOS ESPECIALES:
──────────────────────────────────────────
- Si hay sesión previa abierta:
  * Sistema la cierra automáticamente
  * Aparece notificación en buzón interno (NO modal)
  * Usuario puede ver notificación después en dashboard

- Si red no disponible:
  * Mensaje: "No se pudo conectar al servidor. Verifica tu conexión."
  * Botón "Reintentar"

- Si servidor no responde (timeout 10 seg):
  * Mensaje: "El servidor no responde. Intenta más tarde."
  * Botón "Cerrar"
```

**REQUISITOS DE UI DERIVADOS:**

```
De este procedimiento se derivan:

RF-UI-001: Campo txtUsername con validación en tiempo real
- Control: textbox
- Max length: 20
- Pattern: ^[a-zA-Z0-9]+$
- Validación: on blur
- Mensaje error: bajo el campo

RF-UI-002: Campo txtPassword con máscara de caracteres
- Control: password
- Max length: 100
- Show/Hide password: icono ojo
- Validación: on blur

RF-UI-003: Botón btnLogin habilitado solo si ambos campos válidos
- Estado inicial: deshabilitado (gris)
- Estado habilitado: verde #28a745
- Estado cargando: spinner + texto "Ingresando..."

RF-UI-004: Mensajes de error específicos bajo cada campo
- Color: rojo #dc3545
- Font size: 12px
- Icono: warning triangle
- Desaparece al corregir

RF-UI-005: Modal de error estándar (MOD-ERROR-001)
- Tamaño: 400x250px
- Título: rojo con icono X
- Botón cerrar: esquina superior derecha
- Botón principal: centrado abajo
```

---

## 5. Patrones de Trazabilidad Completa

### 5.1 Cadena Completa: Ejemplo Autenticación

```
NECESIDAD DE NEGOCIO
N-001: Sistema de autenticación seguro
Stakeholder: Gerente de Seguridad
Justificación: Pérdidas por accesos no autorizados
    |
    | [Genera obligación]
    v
REGLA DE NEGOCIO
RN-C01-01: Login con Credenciales Locales
Tipo: ACTIVADOR
Descripción: "Sistema debe permitir login únicamente con username/password local"
Fuente: Política de Seguridad Interna PSI-001
    |
    | [Define restricción en]
    v
PROCESO
PROCESO: Autenticación de Usuario (BPMN)
Actividad A1: Usuario ingresa credenciales
Actividad A2: Sistema valida credenciales [RN-C01-01, RN-C01-02]
Actividad A3: Sistema genera tokens [RN-C01-03]
    |
    | [Se descompone en]
    v
CASO DE USO
UC-001: Iniciar Sesión
Actor: Usuario del Call Center
Flujo Principal:
  1. Usuario ingresa username y password
  2. Sistema valida credenciales [RN-C01-02]
  3. Sistema genera tokens JWT [RN-C01-03]
  4. Sistema retorna tokens
    |
    | [Genera necesidad de]
    v
REQUISITOS
RF-005: API POST /api/v1/auth/login
  - Validar username/password contra PostgreSQL
  - Usar bcrypt cost 12 para verificación
  - Retornar tokens JWT si válido
  - Retornar error 401 si inválido
  Trazabilidad Upward: N-001, RN-C01-01, UC-001

RNF-001: Tiempo de respuesta < 500ms (P95)
  Trazabilidad Upward: N-001
    |
    | [Se implementa con]
    v
DISEÑO
DESIGN-AUTH-001: Diseño Técnico de Autenticación
  - Diagrama de secuencia
  - Modelo de datos: users, user_sessions
  - API REST con djangorestframework
  - Archivo: docs/implementacion/backend/diseno/DISENO_TECNICO_AUTENTICACION.md
    |
    | [Se codifica en]
    v
CODIGO
FILE: callcentersite/apps/authentication/views.py
CLASS: LoginView(APIView)
METHOD: post(request)
LINEAS: 45-89
    |
    | [Se verifica con]
    v
TESTS
TEST-005: test_login_success
FILE: tests/users/test_auth_login.py::test_login_success
LINEAS: 12-34
Verifica:
  - Login con credenciales válidas
  - Retorna access_token y refresh_token
  - Tokens son válidos JWT
  - Tiempo de respuesta < 500ms
    |
    | [Se detalla en]
    v
PROCEDIMIENTO
PROC-LOGIN-001: Procedimiento de Inicio de Sesión
  - Paso 1: Acceder a FRM-LOGIN-001
  - Paso 2: Ingresar username en txtUsername
  - Paso 3: Ingresar password en txtPassword
  - Paso 4: Clic en btnLogin
  - Paso 5: Esperar respuesta (< 500ms)
  - Paso 6: Redirección a dashboard
```

**VALIDACION BIDIRECCIONAL:**

```
UPWARD (¿Por qué existe este código?):
Código LoginView.post()
  --> Implementa RF-005
    --> Satisface UC-001
      --> Soporta PROCESO "Autenticación"
        --> Respeta RN-C01-01
          --> Satisface N-001

DOWNWARD (¿Cómo se verifica este requisito?):
N-001
  --> Genera RN-C01-01
    --> Restringe UC-001
      --> Requiere RF-005
        --> Se diseña en DESIGN-AUTH-001
          --> Se codifica en LoginView.post()
            --> Se prueba con TEST-005
              --> Se documenta en PROC-LOGIN-001
```

---

## Referencias del Proyecto

### Documentos Clave

1. Componente 1: Autenticación y Sesiones (14 reglas)  
   `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

2. Ejemplo RF con Trazabilidad Completa  
   `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md`

3. Ejemplo RF con Trazabilidad  
   `docs/implementacion/backend/requisitos/funcionales/rf010_sesion_unica.md`

4. Guía de Casos de Uso  
   `docs/gobernanza/casos_de_uso_guide.md`

5. Procedimiento de Trazabilidad ISO 29148  
   `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md`

---

**Ultima actualizacion:** 2025-11-05  
**Owner:** equipo-ba  
**Revisores:** equipo-arquitectura
