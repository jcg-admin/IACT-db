---
id: DOC-GOB-MARCO-01
estado: activo
propietario: equipo-ba
ultima_actualizacion: 2025-11-05
relacionados: 
  - DOC-GOB-MARCO-00
  - DOC-GOB-MARCO-02
estandares: ["ISO/IEC/IEEE 29148:2018", "BABOK v3"]
---

# Marco Conceptual: Ecosistema Integrado de Análisis - IACT

**VERSION:** 1.0  
**FECHA:** 2025-11-05  
**ESTADO:** Activo

---

## Navegación

- [00 - Resumen Ejecutivo](00_resumen_ejecutivo_mejores_practicas.md)
- **[01] Marco Conceptual** (este documento)
- [02 - Relaciones Fundamentales](02_relaciones_fundamentales_iact.md)
- [03 - Matrices de Trazabilidad](03_matrices_trazabilidad_iact.md)
- [04 - Metodología de Análisis](04_metodologia_analisis_iact.md)
- [05 - Casos Prácticos](05_casos_practicos_iact.md)
- [06 - Plantillas Integradas](06_plantillas_integradas_iact.md)

---

## 1. Visión General del Ecosistema IACT

### 1.1 El Panorama Completo

El proyecto IACT implementa un ecosistema integrado de análisis de negocio donde cada elemento está conectado mediante trazabilidad bidireccional:

```
NIVEL 0: CONTEXTO ORGANIZACIONAL
┌─────────────────────────────────────────┐
│ Estrategia del Call Center              │
│ - Reducir tiempo de atención            │
│ - Mejorar calidad de servicio           │
│ - Aumentar seguridad de datos           │
└────────────┬────────────────────────────┘
             │
             v
NIVEL 1: NECESIDADES DE NEGOCIO (N-XXX)
┌─────────────────────────────────────────┐
│ N-001: Control de acceso granular       │
│ N-002: Auditoría completa de acciones   │
│ N-003: Gestión eficiente de llamadas    │
└────────────┬────────────────────────────┘
             │ [Generan]
             v
NIVEL 2: REGLAS DE NEGOCIO (RN-XXX)
┌─────────────────────────────────────────┐
│ RN-C01-01: Login con credenciales       │
│ RN-C01-02: Validación con bcrypt        │
│ RN-C01-07: Complejidad de passwords     │
│ RN-C01-14: Sesión única por usuario     │
└────────────┬────────────────────────────┘
             │ [Restringen]
             v
NIVEL 3: PROCESOS DE NEGOCIO (BPMN)
┌─────────────────────────────────────────┐
│ PROCESO: Autenticación de Usuario       │
│ Inicio → Validar Credenciales →         │
│ Generar Tokens → Fin                    │
└────────────┬────────────────────────────┘
             │ [Se descomponen en]
             v
NIVEL 4: CASOS DE USO (UC-XXX)
┌─────────────────────────────────────────┐
│ UC-001: Iniciar Sesión                  │
│ Actor: Usuario del Call Center          │
│ Objetivo: Autenticarse en el sistema    │
└────────────┬────────────────────────────┘
             │ [Generan]
             v
NIVEL 5: REQUISITOS (RF-XXX, RNF-XXX)
┌─────────────────────────────────────────┐
│ RF-005: API POST /api/v1/auth/login     │
│ RF-006: Generación de tokens JWT        │
│ RNF-001: Tiempo de autenticación <500ms │
└────────────┬────────────────────────────┘
             │ [Se detallan en]
             v
NIVEL 6: PROCEDIMIENTOS (PROC-XXX)
┌─────────────────────────────────────────┐
│ PROC-LOGIN-001: Pasos detallados login  │
│ - Pantalla: FRM-LOGIN-001               │
│ - Campos: txtUsername, txtPassword      │
│ - Validaciones específicas              │
└────────────┬────────────────────────────┘
             │ [Se implementan en]
             v
NIVEL 7: DISEÑO E IMPLEMENTACIÓN
┌─────────────────────────────────────────┐
│ - Código Python: LoginView              │
│ - Base de datos: users table            │
│ - Tests: test_login_success.py          │
└─────────────────────────────────────────┘
```

**FLUJO TRANSVERSAL: Reglas de Negocio**

Las reglas de negocio atraviesan TODOS los niveles:

```
RN-C01-14: "Sesión única por usuario"
│
├─→ PROCESO: Actividad "Cerrar sesión anterior"
├─→ CASO DE USO: UC-001 Paso 2 "Sistema cierra sesión previa"
├─→ REQUISITO: RF-010 "Sistema permite solo 1 sesión activa"
├─→ PROCEDIMIENTO: PROC-LOGIN-001 Paso 3 "Notificar cierre de sesión"
└─→ CÓDIGO: UserSession.close_previous_sessions()
```

Fuente: `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md:1758-1833`

---

## 2. Jerarquía de Conceptos en IACT

### 2.1 Principio Fundamental

**Cada nivel se deriva del anterior y debe ser consistente con él.**

```
ESTRATEGIA ORGANIZACIONAL
    |
    | Define objetivos de negocio
    v
NECESIDADES DE NEGOCIO (N-XXX)
    |
    | Identifican problemas u oportunidades
    v
REGLAS DE NEGOCIO (RN-XXX)
    |
    | Establecen hechos, restricciones, desencadenadores
    v
PROCESOS DE NEGOCIO (BPMN)
    |
    | Modelan flujo de actividades para lograr objetivos
    v
CASOS DE USO (UC-XXX)
    |
    | Describen interacciones usuario-sistema
    v
REQUISITOS (RF-XXX, RNF-XXX)
    |
    | Especifican qué debe hacer el sistema
    v
PROCEDIMIENTOS (PROC-XXX)
    |
    | Detallan cómo ejecutar paso a paso
    v
DISEÑO Y CÓDIGO
    |
    | Implementan toda la cadena anterior
```

### 2.2 Jerarquía BABOK v3 Aplicada en IACT

Según BABOK v3 Chapter 7 y documentado en `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md:15-26`:

```
NECESIDAD DE NEGOCIO (Business Need)
├─ Código: N-XXX
├─ Ubicación: docs/implementacion/backend/requisitos/necesidades/
├─ Propósito: Problema u oportunidad que justifica el proyecto
└─ Ejemplo: N-001 "Control de acceso granular"

REQUISITO DE NEGOCIO (Business Requirement)
├─ Código: RN-XXX
├─ Ubicación: docs/implementacion/[dominio]/requisitos/negocio/
├─ Propósito: Capacidad requerida del sistema para satisfacer N-XXX
├─ Trazabilidad Upward: N-XXX
└─ Ejemplo: RN-C01-01 "Login con credenciales locales"

REQUISITO DE STAKEHOLDER (Stakeholder Requirement)
├─ Código: RS-XXX
├─ Ubicación: docs/implementacion/[dominio]/requisitos/stakeholders/
├─ Propósito: Necesidad específica de un stakeholder
├─ Trazabilidad Upward: N-XXX, RN-XXX
└─ Ejemplo: RS-001 "Gerente requiere acceso 24/7"

REQUISITO FUNCIONAL (Functional Requirement)
├─ Código: RF-XXX
├─ Ubicación: docs/implementacion/[dominio]/requisitos/funcionales/
├─ Propósito: Comportamiento específico del sistema
├─ Trazabilidad Upward: N-XXX, RN-XXX, RS-XXX
├─ Trazabilidad Downward: TEST-XXX, DESIGN-XXX
└─ Ejemplo: RF-005 "API POST /api/v1/auth/login"

REQUISITO NO FUNCIONAL (Non-Functional Requirement)
├─ Código: RNF-XXX
├─ Ubicación: docs/implementacion/[dominio]/requisitos/no_funcionales/
├─ Propósito: Calidad, restricción técnica, atributo del sistema
├─ Trazabilidad Upward: N-XXX, RN-XXX
└─ Ejemplo: RNF-001 "Tiempo de autenticación < 500ms"
```

### 2.3 Ejemplo Completo de Jerarquía: Sistema de Autenticación

```
N-001: Sistema de autenticación seguro
Stakeholder: Gerente de Seguridad
Justificación: Pérdidas por accesos no autorizados
Ubicación: docs/implementacion/backend/requisitos/necesidades/n_001.md (pendiente)
    |
    +-- RN-C01-01: Login con Credenciales Locales
        Tipo: ACTIVADOR
        Descripción: "Sistema debe permitir login únicamente con username/password local"
        Fuente: Política de Seguridad Interna PSI-001
        Ubicación: docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md:50-351
        |
        +-- RS-001: Usuario gerente necesita acceso 24/7
            Stakeholder: Gerente de Operaciones
            Razón: "Necesito acceder al sistema en cualquier momento"
            Ubicación: docs/implementacion/backend/requisitos/stakeholders/rs_001.md (pendiente)
            |
            +-- RF-005: Login con username/password
                Descripción: "API REST POST /api/v1/auth/login con credenciales"
                Trazabilidad Upward: N-001, RN-C01-01, RS-001
                Trazabilidad Downward: TEST-005, DESIGN-AUTH-001
                Ubicación: docs/implementacion/backend/requisitos/funcionales/rf005_login_credenciales_locales.md
                |
                +-- TEST-005: test_login_success
                    Archivo: api/callcentersite/tests/users/test_auth_login.py::test_login_success
                    Criterio: "Login con credenciales válidas retorna tokens JWT"
                    Estado: Implementado, pasando
            |
            +-- RNF-001: Tiempo de autenticación < 500ms
                Descripción: "Tiempo de respuesta P95 < 500ms"
                Trazabilidad Upward: N-001, RN-C01-01
                Trazabilidad Downward: TEST-006
                Ubicación: docs/implementacion/backend/requisitos/no_funcionales/rnf_001.md (pendiente)
```

---

## 3. Flujos de Transformación en IACT

### 3.1 FLUJO 1: De Arriba Hacia Abajo (Análisis)

Este es el flujo principal de análisis de negocio:

```
PASO 1: IDENTIFICAR REGLAS DE NEGOCIO
Entrada: 
- Leyes y regulaciones (ej: Ley de Protección de Datos)
- Políticas organizacionales (ej: PSI-001)
- Estándares de industria (ej: PCI-DSS)

Técnica: 
- Análisis de documentos
- Entrevistas con Legal/Compliance
- Talleres con stakeholders

Salida: 
- Catálogo de Reglas de Negocio
- Clasificación por tipo (Hecho, Restricción, Desencadenador, etc.)
- Priorización por obligatoriedad (MUST, SHOULD)

Ejemplo IACT:
- RN-C01-01 a RN-C01-14 (14 reglas de autenticación)
- Documentado en: docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md
    |
    v
PASO 2: MODELAR PROCESOS
Entrada: 
- Reglas identificadas
- Operación actual (AS-IS)
- Mejores prácticas

Técnica: 
- Modelado BPMN
- Observación directa
- Entrevistas con operadores
- Talleres de mejora

Salida: 
- Modelos AS-IS (proceso actual)
- Modelos TO-BE (proceso mejorado)
- Lista de gaps y mejoras

Ejemplo IACT:
- PROCESO: Autenticación de Usuario (TO-BE)
- Actividades: Validar Credenciales → Generar Tokens → Registrar Sesión
    |
    v
PASO 3: IDENTIFICAR CASOS DE USO
Entrada: 
- Modelos de procesos TO-BE
- Lista de actores
- Reglas de negocio

Técnica: 
- Análisis de actividades del proceso
- Regla: ¿La actividad requiere sistema? → Caso de uso
- Identificación de actores principales

Salida: 
- Lista de casos de uso
- Nomenclatura: VERBO + OBJETO
- Actor principal de cada UC

Ejemplo IACT:
- UC-001: Iniciar Sesión
- UC-002: Cerrar Sesión
- UC-003: Refrescar Token
    |
    v
PASO 4: ESPECIFICAR CASOS DE USO
Entrada: 
- Lista de casos de uso
- Modelos de procesos
- Reglas de negocio
- Plantilla estándar

Técnica: 
- Plantilla de dos columnas (Actor | Sistema)
- Escenarios: Principal, Alternos, Excepciones
- Vinculación de reglas de negocio

Salida: 
- Especificaciones completas de UC
- Diagramas UML (opcional)
- Referencias a reglas

Ejemplo IACT:
- Especificación UC-001 con:
  - Flujo principal (8 pasos)
  - 2 flujos alternos
  - 3 excepciones
  - Vinculado a RN-C01-01, RN-C01-02, RN-C01-03
    |
    v
PASO 5: DERIVAR REQUISITOS
Entrada: 
- Casos de uso especificados
- Reglas de negocio
- Restricciones técnicas

Técnica: 
- De cada paso del sistema en UC → RF-XXX
- De restricciones de calidad → RNF-XXX
- Frontmatter YAML con trazabilidad

Salida: 
- SRS (Software Requirements Specification)
- Requisitos funcionales (RF-XXX)
- Requisitos no funcionales (RNF-XXX)
- Trazabilidad bidireccional

Ejemplo IACT:
- RF-005: API POST /api/v1/auth/login (de UC-001 Paso 1)
- RF-006: Generación de tokens JWT (de UC-001 Paso 3)
- RNF-001: Tiempo de respuesta < 500ms
    |
    v
PASO 6: DOCUMENTAR PROCEDIMIENTOS
Entrada: 
- Requisitos aprobados
- Diseño de interfaces
- Reglas de negocio

Técnica: 
- Procedimientos Operativos Estándar (SOPs)
- Screenshots de pantallas
- Validaciones específicas
- Mensajes de error exactos

Salida: 
- Manuales de usuario
- Guías de referencia rápida
- Videos tutoriales (opcional)

Ejemplo IACT:
- PROC-LOGIN-001: Procedimiento detallado de login
  - Pantalla: FRM-LOGIN-001
  - Campos: txtUsername, txtPassword
  - Validaciones: longitud, formato
  - Mensajes: "Credenciales inválidas"
```

### 3.2 FLUJO 2: De Abajo Hacia Arriba (Validación)

Este flujo valida que la implementación cumple con todos los niveles superiores:

```
CODIGO IMPLEMENTADO
    |
    | ¿Pasa todos los tests?
    v
TESTS (TEST-XXX)
    |
    | ¿Cubren todos los criterios de aceptación?
    v
PROCEDIMIENTOS (PROC-XXX)
    |
    | ¿Siguen los pasos especificados?
    v
REQUISITOS (RF-XXX, RNF-XXX)
    |
    | ¿Satisfacen los casos de uso?
    v
CASOS DE USO (UC-XXX)
    |
    | ¿Soportan los procesos?
    v
PROCESOS (BPMN)
    |
    | ¿Respetan las reglas de negocio?
    v
REGLAS DE NEGOCIO (RN-XXX)
    |
    | ¿Satisfacen las necesidades?
    v
NECESIDADES (N-XXX)
    |
    | ¿Alineados con estrategia?
    v
ESTRATEGIA ORGANIZACIONAL
```

**Ejemplo de Validación en IACT:**

```
CODIGO: LoginView.post()
    |
    | ¿Pasa test_login_success?
    v SI
TEST-005: test_login_success
    |
    | ¿Verifica RF-005?
    v SI
RF-005: API POST /api/v1/auth/login
    |
    | ¿Satisface UC-001?
    v SI
UC-001: Iniciar Sesión
    |
    | ¿Soporta PROCESO "Autenticación"?
    v SI
PROCESO: Autenticación de Usuario
    |
    | ¿Respeta RN-C01-01?
    v SI
RN-C01-01: Login con Credenciales Locales
    |
    | ¿Satisface N-001?
    v SI
N-001: Sistema de autenticación seguro
    |
    | ¿Alineado con objetivo "Aumentar seguridad"?
    v SI
ESTRATEGIA: Aumentar seguridad de datos
```

### 3.3 FLUJO 3: Impacto de Cambios (Análisis de Impacto)

Cuando cambia un elemento, este flujo permite identificar impactos:

```
CAMBIO EN: RN-C01-14 "Sesión única por usuario"
Antes: Permitir múltiples sesiones
Después: Solo 1 sesión activa

ANALISIS DE IMPACTO:
    |
    | ¿Qué procesos se afectan?
    v
PROCESOS AFECTADOS:
- PROCESO: Autenticación (agregar paso "Cerrar sesión anterior")
    |
    | ¿Qué casos de uso se afectan?
    v
CASOS DE USO AFECTADOS:
- UC-001: Iniciar Sesión (nuevo paso 2: "Sistema cierra sesión previa")
- UC-002: Cerrar Sesión (ya no aplica si hay múltiples sesiones)
    |
    | ¿Qué requisitos se afectan?
    v
REQUISITOS AFECTADOS:
- RF-010: "Sistema permite solo 1 sesión activa" (NUEVO)
- RF-005: Modificar para agregar lógica de cierre
    |
    | ¿Qué procedimientos se afectan?
    v
PROCEDIMIENTOS AFECTADOS:
- PROC-LOGIN-001: Agregar paso "Notificar cierre de sesión anterior"
    |
    | ¿Qué tests se afectan?
    v
TESTS AFECTADOS:
- TEST-005: test_login_success (modificar para verificar cierre)
- TEST-009: test_single_session (NUEVO)
    |
    | ¿Qué código se afecta?
    v
CODIGO AFECTADO:
- LoginView.post(): Agregar UserSession.close_previous_sessions()
- UserSession model: Agregar método close_previous_sessions()
```

**Beneficio:** Con trazabilidad completa, el análisis de impacto es automático.

---

## 4. Tipos de Reglas de Negocio en IACT

Clasificación según BABOK v3 Section 10.38:

### 4.1 Hechos (Facts)

**Definición:** Enunciados sobre estructura de la información del negocio.

**Formato:** "Cada [entidad] tiene [atributo/relación]"

**Ejemplos IACT:**

```
RN-USER-01: "Cada usuario tiene un username único"
Impacto:
- Modelo de datos: users.username UNIQUE
- Validación: RF-001 "Sistema valida unicidad de username"
- Test: test_username_unique()

RN-SESSION-01: "Cada sesión pertenece a exactamente un usuario"
Impacto:
- Modelo de datos: user_sessions.user_id FK users.user_id
- Validación: RF-011 "Sistema asocia sesión a usuario"
```

### 4.2 Restricciones (Constraints)

**Definición:** Límites sobre acciones o valores permitidos.

**Formato:** "Solo [condición]" o "[Acción] no puede [condición]"

**Ejemplos IACT:**

```
RN-C01-07: "Contraseña debe tener mínimo 8 caracteres"
Tipo: Restricción de validación
Impacto:
- UC-001: Flujo alterno si contraseña < 8 caracteres
- RF-007: "Sistema valida longitud de contraseña"
- PROC-LOGIN-001: Mensaje "Contraseña debe tener 8+ caracteres"
Ubicación: rn_c01_autenticacion_sesiones.md:1134-1249

RN-C01-14: "Solo 1 sesión activa por usuario"
Tipo: Restricción de cardinalidad
Impacto:
- RF-010: "Sistema cierra sesiones previas al login"
- Test: test_single_session()
Ubicación: rn_c01_autenticacion_sesiones.md:1758-1833
```

### 4.3 Desencadenadores (Action Enablers)

**Definición:** Reglas que disparan acciones automáticas.

**Formato:** "Si [condición] entonces [acción]"

**Ejemplos IACT:**

```
RN-C01-06: "Si inactividad > 30 min, entonces cerrar sesión"
Tipo: Desencadenador temporal
Impacto:
- PROCESO: Job programado cada 5 min
- RF-008: "Sistema cierra sesiones inactivas"
- Test: test_inactivity_timeout()
Ubicación: rn_c01_autenticacion_sesiones.md:1016-1132

RN-C01-09: "Si 3 intentos fallidos, entonces bloquear cuenta 15 min"
Tipo: Desencadenador por contador
Impacto:
- UC-001: Flujo de excepción "Usuario bloqueado"
- RF-009: "Sistema bloquea cuenta tras 3 intentos"
- Test: test_account_lockout()
Ubicación: rn_c01_autenticacion_sesiones.md:1332-1422
```

### 4.4 Inferencias (Inferences)

**Definición:** Reglas que derivan nueva información de información existente.

**Formato:** "Si [condición] entonces se puede inferir [conclusión]"

**Ejemplos IACT:**

```
RN-PERM-01: "Si usuario tiene rol 'Admin' entonces tiene todos los permisos"
Tipo: Inferencia de autorización
Impacto:
- RF-001: Algoritmo de evaluación de permisos
- Test: test_admin_has_all_permissions()

RN-STATUS-01: "Si última actividad < 5 min entonces usuario está activo"
Tipo: Inferencia de estado
Impacto:
- RF-012: "Sistema calcula estado de usuario"
- Dashboard: Indicador de usuarios activos
```

### 4.5 Cálculos (Computations)

**Definición:** Fórmulas o algoritmos para derivar valores.

**Formato:** "[Resultado] = [fórmula]"

**Ejemplos IACT:**

```
RN-C01-BCRYPT: "Hash de contraseña = bcrypt(password, salt, cost=12)"
Tipo: Cálculo criptográfico
Impacto:
- RF-006: "Sistema hashea passwords con bcrypt"
- Código: hash_password() function
Ubicación: rn_c01_autenticacion_sesiones.md:1456-1469

RN-JWT-EXP: "Expiración de access token = timestamp_actual + 15 minutos"
Tipo: Cálculo temporal
Impacto:
- RF-006: Generación de tokens JWT
- Test: test_token_expiration()
```

---

## 5. Conformidad con Estándares

### 5.1 ISO/IEC/IEEE 29148:2018

IACT implementa:

**Clause 5.2.8: Traceability**
- Trazabilidad bidireccional (upward + downward)
- Frontmatter YAML en cada requisito
- Matrices de trazabilidad
- Scripts de validación

**Clause 9: Information Items**
- BRS (Business Requirements Specification)
- StRS (Stakeholder Requirements Specification)
- SyRS (System Requirements Specification)
- SRS (Software Requirements Specification)

**Evidencia:** `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md:33-80`

### 5.2 BABOK v3 (IIBA)

**Chapter 7: Requirements Analysis and Design Definition**
- 7.2: Use Cases and Scenarios
- 7.3: Business Rules Analysis

**Chapter 10: Underlying Competencies**
- 10.38: Business Rules Analysis

**Evidencia:** Jerarquía N→RN→RS→RF→RNF aplicada en IACT

### 5.3 UML 2.5

**Use Case Diagrams**
- Casos de uso con actores
- Relaciones: include, extend, generalization

**Sequence Diagrams**
- Interacciones actor-sistema
- Flujos temporales

**Evidencia:** `docs/gobernanza/casos_de_uso_guide.md:283-428`

---

## Referencias del Proyecto

### Documentos Clave

1. Procedimiento de Trazabilidad ISO 29148  
   `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md`

2. Componente 1: Autenticación y Sesiones (14 reglas)  
   `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

3. Guía de Casos de Uso  
   `docs/gobernanza/casos_de_uso_guide.md`

4. Ejemplo de Requisito Funcional con Trazabilidad  
   `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md`

---

**Ultima actualizacion:** 2025-11-05  
**Owner:** equipo-ba  
**Revisores:** equipo-arquitectura
