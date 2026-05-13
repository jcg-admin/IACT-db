---
id: DOC-GOB-MARCO-03
estado: activo
propietario: equipo-ba
ultima_actualizacion: 2025-11-05
relacionados: 
  - DOC-GOB-MARCO-02
  - DOC-GOB-MARCO-04
  - PROC-TRAZABILIDAD-001
estandares: ["ISO/IEC/IEEE 29148:2018"]
---

# Matrices de Trazabilidad: Herramientas de Integración - IACT

**VERSION:** 1.0  
**FECHA:** 2025-11-05  
**ESTADO:** Activo

---

## Navegación

- [00 - Resumen Ejecutivo](00_resumen_ejecutivo_mejores_practicas.md)
- [01 - Marco Conceptual](01_marco_conceptual_iact.md)
- [02 - Relaciones Fundamentales](02_relaciones_fundamentales_iact.md)
- **[03] Matrices de Trazabilidad** (este documento)
- [04 - Metodología de Análisis](04_metodologia_analisis_iact.md)
- [05 - Casos Prácticos](05_casos_practicos_iact.md)
- [06 - Plantillas Integradas](06_plantillas_integradas_iact.md)

---

## 1. Matriz: Proceso-CasoUso-Requisito

### 1.1 Propósito

Validar que cada actividad del proceso tiene casos de uso correspondientes, y que cada caso de uso genera requisitos.

### 1.2 Formato

```
PROCESO: [Nombre del proceso]
CODIGO: PROC-XXX-001
```

| ID Activ | Actividad Proceso | Caso de Uso | Requisito Funcional | Regla Negocio | Procedimiento | Diseño |
|----------|-------------------|-------------|---------------------|---------------|---------------|--------|
| A-XX | Descripción | UC-XXX | RF-XXX | RN-XXX | PROC-XXX | Componente |

### 1.3 Ejemplo Real IACT: Gestión de Autenticación

```
===============================================================================
                MATRIZ DE TRAZABILIDAD INTEGRADA
===============================================================================
PROCESO: Gestión de Autenticación
CODIGO: PROC-AUTH-001
DOMINIO: Backend - Seguridad
===============================================================================
ID     | ACTIVIDAD        | CASO DE | REQUISITO  | REGLA    | PROCEDIMIENTO| DISEÑO
ACTIV  | PROCESO          | USO     | FUNCIONAL  | NEGOCIO  |              |
-------------------------------------------------------------------------------
A-01   | Usuario accede   | UC-001  | RF-005     | RN-C01-01| PROC-LOGIN   | LoginView
       | al sistema       | Iniciar | API POST   | Login con| -001         | .post()
       |                  | Sesión  | /auth/login| credenc. | Paso 1-8     | 
       |                  |         |------------|----------|--------------|----------
       |                  |         | RF-006     | RN-C01-03| PROC-LOGIN   | generate_
       |                  |         | Generar    | Tokens   | -001         | tokens()
       |                  |         | JWT tokens | JWT      | Paso 4-5     |
       |                  |         |------------|----------|--------------|----------
       |                  |         | RF-010     | RN-C01-14| PROC-LOGIN   | close_
       |                  |         | Sesión     | Sesión   | -001         | previous_
       |                  |         | única      | única    | Paso 3       | sessions()
-------------------------------------------------------------------------------
A-02   | Sistema valida   | UC-001  | RF-005     | RN-C01-02| PROC-LOGIN   | validate_
       | credenciales     | (Paso 2)| Validar    | Validar  | -001         | credenti-
       |                  |         | username/  | con      | Paso 2       | als()
       |                  |         | password   | bcrypt   |              |
       |                  |         |------------|----------|--------------|----------
       |                  |         | RNF-001    | RN-C01-02| PROC-LOGIN   | bcrypt
       |                  |         | Tiempo <   | bcrypt   | -001         | .checkpw()
       |                  |         | 500ms      | cost 12  |              | 
-------------------------------------------------------------------------------
A-03   | Sistema registra | UC-001  | RF-007     | RN-C01-13| N/A          | UserSes-
       | sesión           | (Paso 6)| Registrar  | Sesiones | (automático) | sion
       |                  |         | en         | en       |              | .create()
       |                  |         | PostgreSQL | PostgreS.|              |
-------------------------------------------------------------------------------
A-04   | Usuario trabaja  | [N/A]   | [N/A]      | [N/A]    | [N/A]        | [N/A]
       | en el sistema    | (manual)| (no genera)|          |              |
-------------------------------------------------------------------------------
A-05   | Sistema cierra   | UC-002  | RF-011     | RN-C01-06| N/A          | close_
       | por inactividad  | Cerrar  | Cerrar si  | Timeout  | (job         | inactive_
       | (job programado) | Sesión  | >30min     | 30min    | automático)  | sessions()
       |                  | (auto)  | inactivo   |          |              |
-------------------------------------------------------------------------------
A-06   | Usuario cierra   | UC-002  | RF-012     | RN-C01-05| PROC-LOGOUT  | logout()
       | sesión manual    | Cerrar  | Logout     | Logout   | -001         |
       |                  | Sesión  | manual     | manual   | Paso 1-3     |
       |                  | (manual)|            |          |              |
===============================================================================
METRICAS:
- Actividades en proceso: 6
- Actividades manuales: 1 (A-04)
- Casos de uso derivados: 2 (UC-001, UC-002)
- Requisitos funcionales: 6 (RF-005, RF-006, RF-007, RF-010, RF-011, RF-012)
- Requisitos no funcionales: 1 (RNF-001)
- Reglas de negocio aplicadas: 7
- Procedimientos documentados: 2
- Componentes de código: 6
===============================================================================
VALIDACIONES:
[OK] Todas las actividades con sistema tienen UC
[OK] Todos los UC tienen al menos 1 RF
[OK] Todos los RF trazan a RN
[OK] Actividad manual (A-04) correctamente marcada sin UC/RF
===============================================================================
```

### 1.4 Uso de la Matriz

**Para validar completitud:**

```
PREGUNTA: ¿Hay actividades del proceso sin caso de uso?
BUSCAR: Filas donde "CASO DE USO" = vacío
ACCION: Si la actividad requiere sistema, crear UC

PREGUNTA: ¿Hay casos de uso sin requisitos?
BUSCAR: UC que no aparece en ninguna fila de "REQUISITO FUNCIONAL"
ACCION: Derivar RF de los pasos del UC

PREGUNTA: ¿Hay requisitos sin regla de negocio?
BUSCAR: Filas donde "REGLA NEGOCIO" = vacío
ACCION: Investigar si existe RN no documentada o si RF no tiene restricción
```

---

## 2. Matriz: ReglaNegocio-CasoUso-Requisito

### 2.1 Propósito

Mostrar el impacto de cada regla de negocio en casos de uso, requisitos y tests.

### 2.2 Formato

```
===============================================================================
              MATRIZ: IMPACTO DE REGLAS DE NEGOCIO
===============================================================================
PROYECTO: Sistema IACT - Autenticación
===============================================================================
ID     | TIPO  | REGLA DE     | IMPACTA    | GENERA      | GENERA
REGLA  | REGLA | NEGOCIO      | PROCESO    | CASO DE USO | REQUISITO
-------------------------------------------------------------------------------
```

### 2.3 Ejemplo Real IACT: Reglas de Autenticación

```
===============================================================================
              MATRIZ: IMPACTO DE REGLAS DE NEGOCIO
===============================================================================
PROYECTO: Sistema IACT - Componente Autenticación
===============================================================================
ID       | TIPO         | REGLA DE        | IMPACTA     | GENERA       | GENERA
REGLA    | REGLA        | NEGOCIO         | PROCESO     | CASO DE USO  | REQUISITO
-------------------------------------------------------------------------------
RN-C01   | ACTIVADOR    | Login con       | PROC-AUTH   | UC-001       | RF-005
-01      |              | Credenciales    | Actividad   | Iniciar      | API POST
         |              | Locales         | A-01        | Sesión       | /auth/login
         |              | "Solo login     | "Validar    |              |----------
         |              | con username/   | credenc."   |              | RF-006
         |              | password local" |             |              | Generar JWT
         |              |                 |             |              |----------
         |              | Fuente:         |             |              | TEST-005
         |              | PSI-001         |             |              | test_login
-------------------------------------------------------------------------------
RN-C01   | RESTRICCION  | Validación      | PROC-AUTH   | UC-001       | RF-005
-02      |              | de Credenciales | Actividad   | Paso 2       | Validar con
         |              | "Validar con    | A-02        | "Sistema     | bcrypt
         |              | bcrypt cost 12" | "Sistema    | valida       |----------
         |              |                 | valida"     | credenciales"| RNF-001
         |              | Fuente:         |             |              | Tiempo <500ms
         |              | Estándar OWASP  |             |              |----------
         |              |                 |             |              | TEST-006
         |              |                 |             |              | test_bcrypt
-------------------------------------------------------------------------------
RN-C01   | ACTIVADOR    | Generación JWT  | PROC-AUTH   | UC-001       | RF-006
-03      |              | "Access 15 min, | Actividad   | Paso 3-4     | Generar JWT
         |              | Refresh 7 días" | A-01        | "Sistema     | simplejwt
         |              |                 | "Generar    | genera       |----------
         |              | Fuente:         | tokens"     | tokens"      | RNF-002
         |              | PSI-002         |             |              | Tokens PCI-DSS
         |              |                 |             |              |----------
         |              |                 |             |              | TEST-007
         |              |                 |             |              | test_jwt_exp
-------------------------------------------------------------------------------
RN-C01   | DESENCADEN.  | Cierre por      | PROC-AUTH   | UC-002       | RF-011
-06      |              | Inactividad     | Actividad   | Cerrar       | Job cierra
         |              | "Si >30 min     | A-05 (Job   | Sesión       | sesiones >30
         |              | inactivo,       | programado) | (automático) |----------
         |              | cerrar sesión"  |             |              | RNF-003
         |              |                 |             |              | Job cada 5min
         |              | Fuente:         |             |              |----------
         |              | PSI-001         |             |              | TEST-009
         |              |                 |             |              | test_timeout
-------------------------------------------------------------------------------
RN-C01   | RESTRICCION  | Complejidad     | PROC-AUTH   | UC-003       | RF-013
-07      |              | Contraseñas     | Actividad   | Cambiar      | Validar
         |              | "Min 8 chars,   | "Cambiar    | Contraseña   | complejidad
         |              | 1 mayúscula,    | password"   |              |----------
         |              | 1 minúscula,    |             |              | RF-014
         |              | 1 dígito,       |             |              | Mostrar
         |              | 1 especial"     |             |              | requisitos
         |              |                 |             |              |----------
         |              | Fuente:         |             |              | TEST-010
         |              | NIST SP 800-63B |             |              | test_pwd_valid
-------------------------------------------------------------------------------
RN-C01   | RESTRICCION  | Intentos        | PROC-AUTH   | UC-001       | RF-015
-08      |              | Fallidos        | Actividad   | Flujo Alterno| Incrementar
         |              | Limitados       | A-02        | "Credenciales| contador
         |              | "Max 3 intentos"| "Validar"   | inválidas"   |----------
         |              |                 |             |              | RF-016
         |              | Fuente:         |             |              | Bloquear si
         |              | PSI-001         |             |              | 3 intentos
         |              |                 |             |              |----------
         |              |                 |             |              | TEST-011
         |              |                 |             |              | test_lockout
-------------------------------------------------------------------------------
RN-C01   | ACTIVADOR    | Bloqueo         | PROC-AUTH   | UC-001       | RF-016
-09      |              | Temporal        | Actividad   | Excepción    | Bloquear 15
         |              | "Bloquear 15    | A-02        | "Usuario     | minutos
         |              | min si 3        | "Validar"   | bloqueado"   |----------
         |              | intentos"       |             |              | RF-017
         |              |                 |             |              | Desbloqueo
         |              | Fuente:         |             |              | automático
         |              | PSI-001         |             |              |----------
         |              |                 |             |              | TEST-012
         |              |                 |             |              | test_unlock
-------------------------------------------------------------------------------
RN-C01   | HECHO        | Hash Seguro     | PROC-AUTH   | UC-003       | RF-018
-10      |              | Passwords       | Actividad   | Cambiar      | hash_password
         |              | "bcrypt con     | "Cambiar    | Contraseña   | con bcrypt
         |              | cost 12"        | password"   |              |----------
         |              |                 |             |              | RF-019
         |              | Fuente:         |             |              | Guardar en
         |              | OWASP           |             |              | PostgreSQL
         |              |                 |             |              |----------
         |              |                 |             |              | TEST-013
         |              |                 |             |              | test_bcrypt
-------------------------------------------------------------------------------
RN-C01   | HECHO        | Sesiones en     | PROC-AUTH   | UC-001       | RF-007
-13      |              | PostgreSQL      | Actividad   | Paso 6       | Tabla
         |              | "Usar           | A-03        | "Sistema     | user_sessions
         |              | PostgreSQL,     | "Registrar  | registra     |----------
         |              | NO Redis"       | sesión"     | sesión"      | RF-020
         |              |                 |             |              | Tabla
         |              | Fuente:         |             |              | django_session
         |              | ADR-001         |             |              |----------
         |              |                 |             |              | TEST-014
         |              |                 |             |              | test_session_db
-------------------------------------------------------------------------------
RN-C01   | RESTRICCION  | Sesión Única    | PROC-AUTH   | UC-001       | RF-010
-14      |              | "Solo 1 sesión  | Actividad   | Paso 3       | Cerrar sesión
         |              | activa por      | A-01        | "Sistema     | previa
         |              | usuario"        | "Usuario    | cierra       |----------
         |              |                 | accede"     | sesión       | RF-021
         |              | Fuente:         |             | previa"      | Notificar
         |              | PSI-001         |             |              | cierre
         |              |                 |             |              |----------
         |              |                 |             |              | TEST-009
         |              |                 |             |              | test_single
===============================================================================
RESUMEN:
- Total reglas componente autenticación: 10 (de 14 documentadas en RN-C01)
- Hechos: 2
- Restricciones: 5
- Desencadenadores: 2
- Activador: 1
- Procesos impactados: 1 (PROC-AUTH con 6 actividades)
- Casos de uso generados: 3 (UC-001, UC-002, UC-003)
- Requisitos funcionales: 21
- Requisitos no funcionales: 3
- Tests de verificación: 14
===============================================================================
```

### 2.4 Análisis de Cobertura

**Con esta matriz podemos responder:**

```
PREGUNTA: ¿Cuántas reglas de negocio tenemos?
RESPUESTA: 10 reglas documentadas en RN-C01 (Componente Autenticación)

PREGUNTA: ¿Todas las reglas tienen casos de uso?
RESPUESTA: SI - Todas las reglas impactan al menos 1 UC

PREGUNTA: ¿Todas las reglas tienen requisitos?
RESPUESTA: SI - Todas generan al menos 1 RF

PREGUNTA: ¿Todas las reglas tienen tests?
RESPUESTA: SI - Todas tienen al menos 1 test de verificación

PREGUNTA: ¿Qué regla tiene más impacto?
RESPUESTA: RN-C01-01 (Login con Credenciales) genera 3 requisitos
```

---

## 3. Matriz: Procedimiento-Pantalla-Validación

### 3.1 Propósito

Mapear procedimientos de usuario a pantallas, campos y validaciones específicas, derivando requisitos de UI detallados.

### 3.2 Formato

```
===============================================================================
         MATRIZ: PROCEDIMIENTO A ESPECIFICACION DE UI
===============================================================================
PROCEDIMIENTO: PROC-XXX-001 - [Nombre]
===============================================================================
PASO  | ACCION         | PANTALLA/  | CAMPO/     | VALIDACION | MENSAJE
PROC. | PROCEDIMIENTO  | COMPONENTE | ELEMENTO   |            | ERROR
-------------------------------------------------------------------------------
```

### 3.3 Ejemplo Real IACT: PROC-LOGIN-001

```
===============================================================================
         MATRIZ: PROCEDIMIENTO A ESPECIFICACION DE UI
===============================================================================
PROCEDIMIENTO: PROC-LOGIN-001 - Iniciar Sesión en el Sistema
ACTOR: Usuario del Call Center
DURACION ESTIMADA: 30-60 segundos
===============================================================================
PASO  | ACCION           | PANTALLA/    | CAMPO/      | VALIDACION | MENSAJE
PROC. | PROCEDIMIENTO    | COMPONENTE   | ELEMENTO    |            | ERROR
-------------------------------------------------------------------------------
1     | Acceder a URL    | FRM-LOGIN    | [Pantalla   | URL válida | "Página no
      | del sistema      | -001         | completa]   | HTTPS      | encontrada"
      |                  |              |             | Cert. SSL  |
-------------------------------------------------------------------------------
2     | Ingresar         | FRM-LOGIN    | txtUsername | Obligatorio| "Usuario es
      | username         | -001         | (textbox)   | 4-20 chars | obligatorio"
      |                  |              | Max: 20     | Solo a-z,  |----------
      |                  |              | TabIndex: 1 | A-Z, 0-9   | "Usuario solo
      |                  |              |             | Sin espacios| letras/números"
      |                  |              |             |            |----------
      |                  |              |             | On blur    | "Usuario debe
      |                  |              |             | validar    | tener 4-20
      |                  |              |             |            | caracteres"
-------------------------------------------------------------------------------
3     | Ingresar         | FRM-LOGIN    | txtPassword | Obligatorio| "Contraseña
      | password         | -001         | (password)  | 8-100 chars| es obligatoria"
      |                  |              | Max: 100    |            |----------
      |                  |              | TabIndex: 2 | On blur    | "Contraseña
      |                  |              | Type: pwd   | validar    | debe tener 8+
      |                  |              |             |            | caracteres"
      |                  |              |             | Máscara: * |
      |                  |              |             | Icono: eye |
-------------------------------------------------------------------------------
4     | Clic "Ingresar"  | FRM-LOGIN    | btnLogin    | Estado:    | [Deshabilitado
      |                  | -001         | (button)    | disabled   | si campos
      |                  |              | Color: verde| si inválido| inválidos]
      |                  |              | TabIndex: 3 |            |
      |                  |              |             | Enabled si |
      |                  |              |             | ambos OK   |
-------------------------------------------------------------------------------
5     | Sistema valida   | FRM-LOGIN    | spnLoading  | N/A        | N/A
      | (esperar)        | -001         | (spinner)   | (mostrar   |
      |                  |              |             | durante    |
      |                  |              | btnLogin    | validación)|
      |                  |              | Texto:      |            |
      |                  |              | "Ingresando"|            |
-------------------------------------------------------------------------------
6A    | Login exitoso    | [Redirigir]  | Toast       | N/A        | "Bienvenido
      |                  | Dashboard    | verde       |            | [nombre]"
      |                  | FRM-DASH-001 | 3 segundos  |            |
-------------------------------------------------------------------------------
6B    | Error:           | FRM-LOGIN    | MOD-ERROR   | [Muestra]  | "Usuario o
      | Credenciales     | -001         | -001        |            | contraseña
      | inválidas        |              | (modal)     | Intentos   | incorrectos"
      |                  |              | Tamaño:     | restantes  |----------
      |                  |              | 400x250px   | "X intentos| "X intentos
      |                  |              | Icono: X    | restantes" | restantes"
      |                  |              | Color: rojo |            |
-------------------------------------------------------------------------------
6C    | Error:           | FRM-LOGIN    | MOD-ERROR   | [Muestra]  | "Tu cuenta ha
      | Usuario          | -001         | -001        |            | sido bloqueada
      | bloqueado        |              | (modal)     | Minutos    | por múltiples
      |                  |              | Botón:      | restantes  | intentos. Será
      |                  |              | "Contactar  | "[X] min"  | desbloqueada
      |                  |              | Admin"      |            | en [X] minutos"
      |                  |              | Botón:      |            |
      |                  |              | "Cerrar"    |            |
===============================================================================
REQUISITOS DE UI DERIVADOS:
RF-UI-001: Campo txtUsername con validación on blur
RF-UI-002: Campo txtPassword con máscara de caracteres
RF-UI-003: Botón btnLogin habilitado solo si ambos campos válidos
RF-UI-004: Spinner de carga durante validación
RF-UI-005: Modal MOD-ERROR-001 para errores
RF-UI-006: Toast de bienvenida en login exitoso
RF-UI-007: Redirección a dashboard en < 1 segundo
RF-UI-008: Mensajes de error específicos bajo cada campo
RF-UI-009: Contador de intentos restantes visible
RF-UI-010: Botón "Contactar Admin" en modal de bloqueo
===============================================================================
COLORES Y ESTILOS (REQUISITOS RNF-UI):
RNF-UI-001: Campo inválido: borde rojo #dc3545
RNF-UI-002: Campo válido: borde verde #28a745
RNF-UI-003: Botón Ingresar: verde #28a745
RNF-UI-004: Modal error: fondo overlay negro 50% opacity
RNF-UI-005: Toast éxito: fondo verde #28a745, texto blanco
===============================================================================
```

### 3.4 Derivación de Requisitos de UI

De este procedimiento documentado se derivan requisitos específicos de implementación:

```
REQUISITO: RF-UI-001
Título: Campo txtUsername con validación en tiempo real
Descripción:
  - Control: <input type="text" id="txtUsername">
  - Placeholder: "Ingresa tu usuario"
  - Max length: 20
  - Pattern: ^[a-zA-Z0-9]+$
  - Validación: on blur (al salir del campo)
  - Mensaje error: bajo el campo, color rojo #dc3545
  - Borde: rojo si inválido, verde si válido
Trazabilidad:
  - PROC-LOGIN-001 Paso 2
  - RN-C01-01 (Login con credenciales)
Test:
  - TEST-UI-001: Verificar validación on blur
  - TEST-UI-002: Verificar mensaje de error específico
  - TEST-UI-003: Verificar cambio de color de borde

REQUISITO: RF-UI-002
Título: Campo txtPassword con máscara y show/hide
Descripción:
  - Control: <input type="password" id="txtPassword">
  - Placeholder: "Ingresa tu contraseña"
  - Max length: 100
  - Máscara: caracteres mostrados como asteriscos (*)
  - Icono ojo: permite show/hide password
  - Validación: on blur
  - Mensaje error: "Contraseña debe tener 8+ caracteres"
Trazabilidad:
  - PROC-LOGIN-001 Paso 3
  - RN-C01-07 (Complejidad de contraseñas)
Test:
  - TEST-UI-004: Verificar máscara de caracteres
  - TEST-UI-005: Verificar show/hide password con icono

REQUISITO: RF-UI-003
Título: Botón btnLogin habilitado solo si campos válidos
Descripción:
  - Estado inicial: disabled (gris #6c757d)
  - Condición para habilitar:
    * txtUsername válido (4-20 chars, pattern OK)
    * txtPassword válido (8+ chars)
  - Estado habilitado: verde #28a745, cursor pointer
  - Estado cargando: spinner + texto "Ingresando..."
Trazabilidad:
  - PROC-LOGIN-001 Paso 4
  - RNF-001 (Usabilidad)
Test:
  - TEST-UI-006: Botón disabled si campos vacíos
  - TEST-UI-007: Botón enabled si ambos válidos
  - TEST-UI-008: Spinner aparece al hacer clic
```

---

## 4. Matriz de Trazabilidad Total (RTM)

### 4.1 Propósito

Matriz maestra que conecta TODOS los niveles de análisis, conforme a ISO/IEC/IEEE 29148:2018 Clause 5.2.8.

### 4.2 Formato Completo

```
===============================================================================
              RTM - REQUIREMENTS TRACEABILITY MATRIX
===============================================================================
Conforme a: ISO/IEC/IEEE 29148:2018 - Clause 5.2.8
Proyecto: IACT
Componente: Autenticación
Generado: 2025-11-05
===============================================================================
```

### 4.3 Ejemplo Real IACT: Trazabilidad Completa

```
===============================================================================
              RTM - REQUIREMENTS TRACEABILITY MATRIX
===============================================================================
Conforme a: ISO/IEC/IEEE 29148:2018 - Clause 5.2.8
Proyecto: IACT
Componente: Autenticación
===============================================================================
NECESIDAD | RN      | PROCESO  | UC      | RF       | DISEÑO    | TEST      | PROC
-------------------------------------------------------------------------------
N-001     | RN-C01  | PROC-    | UC-001  | RF-005   | LoginView | TEST-005  | PROC-
Control   | -01     | AUTH     | Iniciar | API POST | .post()   | test_     | LOGIN
acceso    | Login   | A-01     | Sesión  | /auth/   |           | login_    | -001
granular  | cred.   | Usuario  |         | login    |           | success   | Paso
          | locales | accede   |         |          |           |           | 1-8
          |---------|----------|---------|----------|-----------|-----------|-------
          | RN-C01  | PROC-    | UC-001  | RF-006   | generate_ | TEST-007  | PROC-
          | -03     | AUTH     | (Paso   | Generar  | tokens()  | test_jwt_ | LOGIN
          | Tokens  | A-01     | 3-4)    | JWT      |           | exp       | -001
          | JWT     | Usuario  | "Gen.   | tokens   |           |           | Paso
          |         | accede   | tokens" |          |           |           | 4-5
          |---------|----------|---------|----------|-----------|-----------|-------
          | RN-C01  | PROC-    | UC-001  | RF-010   | close_    | TEST-009  | PROC-
          | -14     | AUTH     | (Paso3) | Sesión   | previous_ | test_     | LOGIN
          | Sesión  | A-01     | "Cierra | única    | sessions()| single_   | -001
          | única   | Usuario  | previa" |          |           | session   | Paso 3
          |         | accede   |         |          |           |           |
-------------------------------------------------------------------------------
N-001     | RN-C01  | PROC-    | UC-001  | RF-005   | validate_ | TEST-006  | PROC-
Control   | -02     | AUTH     | (Paso2) | Validar  | credenti- | test_     | LOGIN
acceso    | Validar | A-02     | "Sist.  | con      | als()     | bcrypt_   | -001
granular  | bcrypt  | Sistema  | valida" | bcrypt   |           | valid     | Paso 2
          |         | valida   |         |          |           |           |
          |---------|----------|---------|----------|-----------|-----------|-------
          | RN-C01  | PROC-    | UC-001  | RNF-001  | bcrypt.   | TEST-014  | N/A
          | -02     | AUTH     | (Paso2) | Tiempo < | checkpw() | test_     | (perf)
          | Validar | A-02     | "Sist.  | 500ms    |           | response_ |
          | bcrypt  | Sistema  | valida" | (P95)    |           | time      |
          |         | valida   |         |          |           |           |
-------------------------------------------------------------------------------
N-002     | RN-C01  | PROC-    | UC-002  | RF-011   | close_    | TEST-009  | N/A
Auditoría | -06     | AUTH     | Cerrar  | Cerrar   | inactive_ | test_     | (auto)
completa  | Timeout | A-05     | Sesión  | si >30   | sessions()| timeout   |
          | 30 min  | Job      | (auto)  | min      | (job)     |           |
          |         | programa.|         | inactivo |           |           |
          |---------|----------|---------|----------|-----------|-----------|-------
          | RN-C01  | PROC-    | UC-002  | RF-012   | logout()  | TEST-015  | PROC-
          | -05     | AUTH     | Cerrar  | Logout   |           | test_     | LOGOUT
          | Logout  | A-06     | Sesión  | manual   |           | logout    | -001
          | manual  | Usuario  | (manual)|          |           | success   | Paso
          |         | cierra   |         |          |           |           | 1-3
-------------------------------------------------------------------------------
N-001     | RN-C01  | PROC-    | UC-003  | RF-013   | validate_ | TEST-010  | PROC-
Control   | -07     | AUTH     | Cambiar | Validar  | password_ | test_pwd_ | CHPWD
acceso    | Complej | [Proceso | Contra- | complej. | complexi- | valid     | -001
granular  | pwd     | Cambio   | seña    | password | ty()      |           |
          |         | Password]|         |          |           |           |
===============================================================================
ESTADISTICAS:
- Necesidades: 2 (N-001, N-002)
- Reglas de negocio: 7 (de 14 totales en RN-C01)
- Procesos: 1 (PROC-AUTH con 6 actividades)
- Casos de uso: 3 (UC-001, UC-002, UC-003)
- Requisitos funcionales: 8
- Requisitos no funcionales: 1
- Componentes de diseño: 7
- Tests: 10
- Procedimientos: 3

COBERTURA:
- Necesidades con RN: 100% (2/2)
- RN con UC: 100% (7/7)
- UC con RF: 100% (3/3)
- RF con tests: 100% (8/8)
- RF con procedimientos: 75% (6/8) [2 automáticos no tienen PROC]
===============================================================================
```

---

## Referencias del Proyecto

### Documentos Clave

1. Procedimiento de Trazabilidad ISO 29148  
   `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md`

2. Componente 1: Autenticación (14 reglas completas)  
   `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

3. Ejemplo de Requisito con Trazabilidad  
   `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md`

---

**Ultima actualizacion:** 2025-11-05  
**Owner:** equipo-ba  
**Revisores:** equipo-arquitectura, equipo-qa
