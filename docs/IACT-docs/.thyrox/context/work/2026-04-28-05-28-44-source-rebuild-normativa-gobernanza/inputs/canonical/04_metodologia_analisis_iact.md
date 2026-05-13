---
id: DOC-GOB-MARCO-04
estado: activo
propietario: equipo-ba
ultima_actualizacion: 2025-11-05
relacionados: 
  - DOC-GOB-MARCO-03
  - DOC-GOB-MARCO-05
  - PROC-TRAZABILIDAD-001
estandares: ["ISO/IEC/IEEE 29148:2018", "BABOK v3"]
---

# Metodología de Análisis Integrado - IACT

**VERSION:** 1.0  
**FECHA:** 2025-11-05  
**ESTADO:** Activo

---

## Navegación

- [00 - Resumen Ejecutivo](00_resumen_ejecutivo_mejores_practicas.md)
- [01 - Marco Conceptual](01_marco_conceptual_iact.md)
- [02 - Relaciones Fundamentales](02_relaciones_fundamentales_iact.md)
- [03 - Matrices de Trazabilidad](03_matrices_trazabilidad_iact.md)
- **[04] Metodología de Análisis** (este documento)
- [05 - Casos Prácticos](05_casos_practicos_iact.md)
- [06 - Plantillas Integradas](06_plantillas_integradas_iact.md)

---

## Introducción

Este documento describe el proceso paso a paso para realizar análisis de negocio integrado en IACT, desde la identificación de necesidades hasta la documentación de procedimientos.

---

## FASE 1: Análisis de Procesos y Reglas

### Objetivo

Entender el contexto de negocio, identificar reglas obligatorias y modelar procesos actuales y futuros.

### Duración Típica

1-2 semanas para un componente nuevo

### Actividades

```
ACTIVIDAD 1.1: Identificar Necesidades de Negocio
ACTIVIDAD 1.2: Identificar Reglas de Negocio
ACTIVIDAD 1.3: Modelar Procesos AS-IS
ACTIVIDAD 1.4: Analizar Gaps y Problemas
ACTIVIDAD 1.5: Diseñar Procesos TO-BE
```

---

### ACTIVIDAD 1.1: Identificar Necesidades de Negocio

**Entrada:**
- Objetivos estratégicos de la organización
- Problemas reportados
- Oportunidades de mejora

**Técnicas:**
- Entrevistas con stakeholders clave
- Análisis de métricas actuales
- Benchmarking con industria

**Salida:**
- Documento de necesidades (N-XXX)
- Justificación de negocio
- Stakeholders identificados

**Plantilla:**
Usar `docs/plantillas/template_necesidad.md`

**Ejemplo IACT:**

```
N-001: Control de Acceso Granular

Stakeholder: Gerente de Seguridad TI
Problema: Actualmente no hay control fino de permisos
Impacto: Riesgo de accesos no autorizados
Oportunidad: Implementar sistema de permisos por niveles
Justificación: Cumplir con ISO 27001
Prioridad: Alta
Fecha: 2025-01-15

Métricas Actuales:
- Incidentes de seguridad: 5/mes
- Tiempo promedio de resolución: 4 horas

Métricas Objetivo:
- Incidentes de seguridad: <2/mes
- Tiempo promedio de resolución: <1 hora

Beneficios:
- Reducción de riesgos de seguridad
- Cumplimiento normativo
- Mayor trazabilidad de acciones

Ubicación: docs/implementacion/backend/requisitos/necesidades/n_001.md
```

---

### ACTIVIDAD 1.2: Identificar Reglas de Negocio

**Entrada:**
- Leyes y regulaciones aplicables
- Políticas organizacionales
- Estándares de industria
- Contratos con clientes

**Técnicas:**
- Análisis de documentos legales
- Entrevistas con Legal/Compliance
- Revisión de políticas internas
- Talleres con stakeholders

**Salida:**
- Catálogo de Reglas de Negocio
- Clasificación por tipo (Hecho, Restricción, etc.)
- Priorización por obligatoriedad
- Fuente de cada regla

**Plantilla:**
Usar `docs/plantillas/template_requisito_negocio.md`

**Ejemplo IACT: Catálogo de Reglas RN-C01**

Fuente real: `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

```
CATALOGO DE REGLAS DE NEGOCIO
Componente: Autenticación y Sesiones
Código: RN-C01
Total Reglas: 14

MUST (Obligatorio):
- RN-C01-01: Login con Credenciales Locales [ACTIVADOR]
  Fuente: Política de Seguridad PSI-001
  Obligatoriedad: MUST
  
- RN-C01-02: Validación de Credenciales [RESTRICCION]
  Fuente: OWASP Top 10
  Obligatoriedad: MUST
  
- RN-C01-03: Generación de Tokens JWT [ACTIVADOR]
  Fuente: Política de Seguridad PSI-002
  Obligatoriedad: MUST
  
- RN-C01-07: Complejidad de Contraseñas [RESTRICCION]
  Fuente: NIST SP 800-63B
  Obligatoriedad: MUST
  
- RN-C01-14: Sesión Única por Usuario [RESTRICCION]
  Fuente: Política de Seguridad PSI-001
  Obligatoriedad: MUST

CLASIFICACION POR TIPO:
- Hechos: 2 (RN-C01-10, RN-C01-13)
- Restricciones: 5 (RN-C01-02, RN-C01-07, RN-C01-08, RN-C01-09, RN-C01-14)
- Desencadenadores: 2 (RN-C01-06, RN-C01-09)
- Activadores: 4 (RN-C01-01, RN-C01-03, RN-C01-05, RN-C01-11, RN-C01-12)
- Cálculos: 1 (RN-C01-10 - bcrypt)

MATRIZ DE OBLIGATORIEDAD:
| Regla | Tipo | Fuente | Obligatoriedad | Impacto si no cumple |
|-------|------|--------|----------------|----------------------|
| RN-C01-01 | ACTIVADOR | PSI-001 | MUST | Sistema no arranca |
| RN-C01-02 | RESTRICCION | OWASP | MUST | Vulnerabilidad crítica |
| RN-C01-07 | RESTRICCION | NIST | MUST | Passwords débiles |
| RN-C01-14 | RESTRICCION | PSI-001 | SHOULD | Riesgo de seguridad |
```

---

### ACTIVIDAD 1.3: Modelar Procesos AS-IS

**Entrada:**
- Reglas de negocio identificadas
- Documentación existente
- Acceso a operadores

**Técnicas:**
- Modelado BPMN 2.0
- Observación directa de operación
- Entrevistas con operadores
- Análisis de documentos (manuales existentes)
- Value Stream Mapping

**Salida:**
- Modelos BPMN AS-IS (proceso actual)
- Lista de problemas identificados
- Métricas actuales (tiempos, errores, costos)
- Documentación de excepciones

**Herramienta:**
- draw.io, Lucidchart, o PlantUML para diagramas
- Archivos .bpmn en `docs/anexos/diagramas/procesos/`

**Ejemplo IACT: Proceso AS-IS de Autenticación**

```
PROCESO AS-IS: Autenticación de Usuario (antes del proyecto)

[Inicio]
    |
    v
[Usuario abre aplicación]
    |
    v
[Usuario ingresa username/password en formulario]
    |
    v
[Usuario hace clic en "Ingresar"]
    |
    v
[Sistema valida contra base de datos]
    | ¿Credenciales válidas?
    |
    +-- NO --> [Mostrar error genérico] --> [Fin]
    |
    +-- SI --> [Crear sesión PHP con session_start()]
               |
               v
               [Guardar user_id en $_SESSION]
               |
               v
               [Redireccionar a dashboard]
               |
               v
               [Fin]

PROBLEMAS IDENTIFICADOS:
1. NO hay límite de intentos fallidos (vulnerabilidad de fuerza bruta)
2. Passwords guardados en MD5 (obsoleto, inseguro)
3. Sesiones en archivos /tmp (no escalable, se pierden)
4. NO hay timeout de inactividad (sesiones infinitas)
5. Usuario puede tener N sesiones simultáneas (riesgo de seguridad)
6. NO hay auditoría de logins (no se registran intentos)
7. Mensaje de error genérico (mala UX)

METRICAS AS-IS:
- Tiempo promedio de login: 800ms
- Intentos fallidos promedio: 12/día
- Sesiones concurrentes promedio: 3 por usuario
- Incidentes de seguridad relacionados: 5/mes
```

---

### ACTIVIDAD 1.4: Analizar Gaps y Problemas

**Entrada:**
- Modelos AS-IS
- Reglas de negocio
- Métricas actuales
- Objetivos estratégicos

**Técnicas:**
- Análisis de valor agregado (VA vs NVA)
- Análisis de tiempo de ciclo
- Identificación de desperdicios (7 mudas de Lean)
- Gap analysis (situación actual vs deseada)
- Root cause analysis (5 whys, fishbone)

**Salida:**
- Lista priorizada de problemas
- Oportunidades de mejora
- Necesidades de automatización
- Quick wins identificados

**Ejemplo IACT:**

```
ANALISIS DE GAPS: Autenticación

GAPS IDENTIFICADOS:

GAP-1: Passwords inseguros (MD5)
Situación Actual: MD5 sin salt
Situación Deseada: bcrypt con cost 12
Regla Aplicable: RN-C01-10
Impacto: CRITICO
Esfuerzo: Medio
Prioridad: ALTA

GAP-2: Sin límite de intentos
Situación Actual: Intentos ilimitados
Situación Deseada: Max 3 intentos, bloqueo 15 min
Regla Aplicable: RN-C01-08, RN-C01-09
Impacto: ALTO
Esfuerzo: Bajo
Prioridad: ALTA

GAP-3: Sesiones en archivos
Situación Actual: PHP session files en /tmp
Situación Deseada: PostgreSQL
Regla Aplicable: RN-C01-13
Impacto: MEDIO
Esfuerzo: Medio
Prioridad: MEDIA

GAP-4: Sin auditoría
Situación Actual: No se registran logins
Situación Deseada: Auditoría completa
Regla Aplicable: RN-C01-12
Impacto: MEDIO
Esfuerzo: Bajo
Prioridad: MEDIA

QUICK WINS:
1. Implementar límite de intentos (1 día de desarrollo)
2. Agregar logging básico de logins (2 horas)

MEJORAS A LARGO PLAZO:
1. Migrar passwords a bcrypt (requiere comunicación a usuarios)
2. Migrar sesiones a PostgreSQL (requiere pruebas exhaustivas)
```

---

### ACTIVIDAD 1.5: Diseñar Procesos TO-BE

**Entrada:**
- Modelos AS-IS
- Análisis de gaps
- Reglas de negocio
- Mejores prácticas
- Tecnología disponible

**Técnicas:**
- Modelado BPMN TO-BE
- Lean (eliminación de desperdicios)
- Automatización de actividades repetitivas
- Simplificación de flujos
- Validación con stakeholders

**Salida:**
- Modelos BPMN TO-BE (proceso mejorado)
- Descripción de mejoras implementadas
- Beneficios esperados (cuantitativos)
- Plan de transición AS-IS → TO-BE

**Ejemplo IACT: Proceso TO-BE de Autenticación**

```
PROCESO TO-BE: Autenticación de Usuario (con mejoras)

[Inicio]
    |
    v
[Usuario accede a URL HTTPS]
    |
    v
[Sistema muestra FRM-LOGIN-001]
    |
    v
[Usuario ingresa username en txtUsername]
    |
    v
[Sistema valida formato (on blur)] [MEJORA: validación en tiempo real]
    |
    v
[Usuario ingresa password en txtPassword]
    |
    v
[Sistema valida longitud (on blur)] [MEJORA: feedback inmediato]
    |
    v
[Usuario hace clic en btnLogin]
    |
    v
[Sistema valida credenciales con bcrypt] [MEJORA: seguridad]
    | [RN-C01-02]
    |
    | ¿Credenciales válidas?
    |
    +-- NO --> [Incrementar contador failed_attempts] [MEJORA: protección]
               | [RN-C01-08]
               |
               | ¿failed_attempts >= 3?
               |
               +-- SI --> [Bloquear cuenta 15 min] [MEJORA: seguridad]
               |          | [RN-C01-09]
               |          v
               |          [Notificar usuario vía buzón interno]
               |          |
               |          v
               |          [Auditar bloqueo] [MEJORA: trazabilidad]
               |          |
               |          v
               |          [Mostrar modal "Cuenta bloqueada"]
               |          |
               |          v
               |          [Fin]
               |
               +-- NO --> [Mostrar error específico] [MEJORA: UX]
                          |
                          v
                          [Auditar intento fallido] [MEJORA: auditoría]
                          |
                          v
                          [Fin]
    |
    +-- SI --> [Verificar si hay sesión previa activa] [MEJORA: seguridad]
               | [RN-C01-14]
               |
               | ¿Hay sesión activa?
               |
               +-- SI --> [Cerrar sesión previa] [MEJORA: sesión única]
               |          |
               |          v
               |          [Notificar cierre vía buzón] [MEJORA: transparencia]
               |          |
               |          v
               |          [Auditar cierre de sesión] [MEJORA: auditoría]
               |
               v
               [Generar access token JWT (15 min)] [MEJORA: seguridad]
               | [RN-C01-03]
               v
               [Generar refresh token JWT (7 días)] [MEJORA: UX]
               | [RN-C01-03]
               v
               [Registrar sesión en PostgreSQL] [MEJORA: escalabilidad]
               | [RN-C01-13]
               v
               [Resetear failed_attempts a 0]
               |
               v
               [Auditar login exitoso] [MEJORA: trazabilidad]
               | [RN-C01-12]
               v
               [Retornar tokens JWT]
               |
               v
               [Redireccionar a dashboard]
               |
               v
               [Fin]

MEJORAS IMPLEMENTADAS:
1. Validación en tiempo real (on blur)
2. Hash seguro con bcrypt cost 12
3. Límite de 3 intentos fallidos
4. Bloqueo temporal automático (15 min)
5. Sesión única por usuario
6. Sesiones en PostgreSQL (escalable)
7. Tokens JWT (stateless, seguro)
8. Auditoría completa de eventos
9. Notificaciones transparentes
10. Mensajes de error específicos (mejor UX)

BENEFICIOS ESPERADOS:
- Tiempo promedio de login: 400ms (50% más rápido)
- Reducción de intentos de fuerza bruta: 90%
- Incidentes de seguridad: <1/mes (80% reducción)
- Escalabilidad: soporta 10,000+ usuarios concurrentes
- Cumplimiento: ISO 27001, OWASP Top 10

REGLAS DE NEGOCIO IMPLEMENTADAS:
- RN-C01-01: Login con credenciales locales
- RN-C01-02: Validación con bcrypt
- RN-C01-03: Tokens JWT
- RN-C01-06: Timeout 30 minutos
- RN-C01-08: Max 3 intentos
- RN-C01-09: Bloqueo 15 minutos
- RN-C01-12: Auditoría completa
- RN-C01-13: Sesiones PostgreSQL
- RN-C01-14: Sesión única
```

---

## FASE 2: Modelado de Casos de Uso

### Objetivo

Identificar y especificar todas las interacciones usuario-sistema necesarias para soportar los procesos TO-BE.

### Duración Típica

1-2 semanas para un componente nuevo

### Actividades

```
ACTIVIDAD 2.1: Identificar Actores
ACTIVIDAD 2.2: Identificar Casos de Uso
ACTIVIDAD 2.3: Crear Diagrama de Casos de Uso
ACTIVIDAD 2.4: Especificar Casos de Uso Detalladamente
```

---

### ACTIVIDAD 2.1: Identificar Actores

**Entrada:**
- Modelos de procesos TO-BE
- Organigramas
- Descripción de roles

**Técnicas:**
- Análisis de stakeholders
- Identificación de roles (RACI)
- Clasificación primario/secundario

**Salida:**
- Lista de actores
- Descripción de cada actor
- Matriz actor-proceso

**Guía:**
`docs/gobernanza/casos_de_uso_guide.md`

**Ejemplo IACT:**

```
ACTORES DEL SISTEMA IACT

ACTORES PRIMARIOS (inician casos de uso):

A-001: Usuario del Call Center
Descripción: Operador que atiende llamadas
Objetivo: Registrar y consultar información de llamadas
Permisos: Viewer Básico
Frecuencia de uso: Diaria, 100+ interacciones/día

A-002: Supervisor de Call Center
Descripción: Supervisor de equipo
Objetivo: Monitorear métricas y gestionar equipo
Permisos: Analista de Datos
Frecuencia de uso: Diaria, 20 interacciones/día

A-003: Administrador de Sistema
Descripción: Admin TI
Objetivo: Gestionar usuarios, permisos, configuración
Permisos: Admin Full
Frecuencia de uso: Semanal, 10 interacciones/semana

ACTORES SECUNDARIOS (dan soporte):

A-S01: Sistema de Auditoría
Descripción: Subsistema que registra eventos
Objetivo: Guardar logs de auditoría
Interacción: Automática

A-S02: Servicio de Notificaciones
Descripción: Servicio de buzón interno
Objetivo: Enviar notificaciones a usuarios
Interacción: Automática

A-S03: Job Programado de Timeout
Descripción: Job que cierra sesiones inactivas
Objetivo: Ejecutar cada 5 min, cerrar sesiones >30min
Interacción: Automática

MATRIZ ACTOR-PROCESO:

| Actor | PROC-AUTH | PROC-PERMISOS | PROC-LLAMADAS | PROC-REPORTES |
|-------|-----------|---------------|---------------|---------------|
| Usuario Call Center | Usuario | Usuario | Primario | Usuario |
| Supervisor | Usuario | Consultor | Consultor | Primario |
| Admin Sistema | Primario | Primario | Admin | Admin |
```

---

### ACTIVIDAD 2.2: Identificar Casos de Uso

**Entrada:**
- Modelos TO-BE
- Lista de actores
- Reglas de negocio

**Técnicas:**
- Análisis de actividades del proceso
- Descomposición de tareas
- Identificación de interacciones usuario-sistema

**Criterio de Decisión:**
¿La actividad requiere interacción con sistema?
   SI → Caso de uso
   NO → Actividad manual

**Salida:**
- Lista de casos de uso
- Nomenclatura: VERBO + OBJETO
- Actor principal de cada UC

**Ejemplo IACT:**

```
CASOS DE USO IDENTIFICADOS
Componente: Autenticación

Del PROCESO TO-BE "Gestión de Autenticación":

UC-001: Iniciar Sesión
Actor Primario: Usuario del Call Center
Objetivo: Autenticarse en el sistema
Nivel: Usuario (sea level)
Prioridad: Alta
Frecuencia: 100+ veces/día
Derivado de: Actividad A-01 "Usuario accede al sistema"

UC-002: Cerrar Sesión
Actor Primario: Usuario del Call Center
Objetivo: Terminar sesión manualmente
Nivel: Usuario
Prioridad: Media
Frecuencia: 50 veces/día
Derivado de: Actividad A-06 "Usuario cierra sesión manual"

UC-003: Refrescar Token
Actor Primario: Sistema (automático)
Objetivo: Obtener nuevo access token con refresh token
Nivel: Subfunción
Prioridad: Alta
Frecuencia: 500+ veces/día
Derivado de: Actividad implícita (tokens expiran cada 15 min)

UC-004: Cambiar Contraseña
Actor Primario: Usuario del Call Center
Objetivo: Cambiar su contraseña por seguridad
Nivel: Usuario
Prioridad: Media
Frecuencia: 10 veces/mes
Derivado de: Proceso "Gestión de Seguridad" (fuera de alcance inicial)

CRITERIOS APLICADOS:

Actividad "Usuario accede al sistema" → SI requiere sistema
   Captura de datos: username, password
   Validación: credenciales
   Procesamiento: generar tokens
   → GENERA UC-001

Actividad "Usuario trabaja en el sistema" → NO genera UC
   Actividad manual continua
   → NO GENERA UC

Actividad "Sistema cierra por inactividad" → SI requiere sistema
   Pero es automático (job), no es interacción usuario-sistema directa
   → GENERA UC-002 (variante automática)
```

---

### ACTIVIDAD 2.4: Especificar Casos de Uso

**Entrada:**
- Lista de casos de uso
- Modelos de procesos
- Reglas de negocio
- Plantilla estándar

**Técnicas:**
- Plantilla estructurada (formato dos columnas)
- Escenarios paso a paso
- Identificación de precondiciones, flujos, postcondiciones

**Salida:**
- Especificaciones completas
- Escenarios detallados
- Referencias a reglas

**Plantilla:**
`docs/gobernanza/casos_de_uso_guide.md:82-280`

**Ejemplo IACT: UC-001 Especificado**

Ver ejemplo completo en [05_casos_practicos_iact.md](05_casos_practicos_iact.md) Sección 5.1

---

## FASE 3: Especificación de Requisitos

### Objetivo

Derivar requisitos funcionales y no funcionales detallados a partir de casos de uso y reglas de negocio.

### Duración Típica

2-3 semanas para un componente nuevo

### Actividades

```
ACTIVIDAD 3.1: Derivar Requisitos Funcionales
ACTIVIDAD 3.2: Identificar Requisitos No Funcionales
ACTIVIDAD 3.3: Consolidar Reglas de Negocio
ACTIVIDAD 3.4: Priorizar Requisitos (MoSCoW)
ACTIVIDAD 3.5: Validar Requisitos con Stakeholders
```

---

### ACTIVIDAD 3.1: Derivar Requisitos Funcionales

**Entrada:**
- Especificaciones de casos de uso
- Reglas de negocio
- Procesos TO-BE

**Técnica:**
Para cada paso del caso de uso donde el SISTEMA actúa → Crear RF-XXX

**Patrón:**
"RF-XXX: El sistema debe [verbo] [objeto] [condición]"

**Salida:**
- Lista de requisitos funcionales
- Con trazabilidad a caso de uso
- Con trazabilidad a regla de negocio

**Plantilla:**
`docs/plantillas/template_requisito_funcional.md`

**Ejemplo IACT:**

Del UC-001 "Iniciar Sesión" se derivan (ver [02_relaciones_fundamentales_iact.md](02_relaciones_fundamentales_iact.md) Sección 2.3):

```
RF-005: API debe validar username/password contra PostgreSQL
RF-006: Sistema debe generar tokens JWT con djangorestframework-simplejwt
RF-007: Sistema debe registrar sesión en PostgreSQL
RF-010: Sistema debe permitir solo 1 sesión activa por usuario
```

---

### ACTIVIDAD 3.4: Priorizar Requisitos (MoSCoW)

**Entrada:**
- Todos los requisitos identificados
- Objetivos del proyecto
- Restricciones (tiempo, presupuesto)

**Técnica: MoSCoW**

```
M - Must have (Obligatorio)
  - Requisito crítico, proyecto no viable sin él
  - Ejemplo: RF-005 (API de login)

S - Should have (Importante)
  - Importante pero no crítico
  - Puede diferirse a siguiente release
  - Ejemplo: RF-020 (Recordar username)

C - Could have (Deseable)
  - Nice to have
  - Solo si hay tiempo/presupuesto
  - Ejemplo: RF-030 (Login con biometría)

W - Won't have (Fuera de alcance)
  - Explícitamente excluido de este release
  - Puede considerarse en futuro
  - Ejemplo: RF-040 (Login con OAuth2)
```

**Criterios de Priorización:**

```
CRITERIO 1: Obligatoriedad Legal/Normativa
- Si hay RN-XXX con fuente legal → MUST

CRITERIO 2: Dependencias Técnicas
- Si otros RF dependen de este → Alta prioridad

CRITERIO 3: Riesgo
- Si su ausencia genera riesgo alto → MUST

CRITERIO 4: Valor de Negocio
- ROI, impacto en objetivos → Determina prioridad

CRITERIO 5: Costo de Implementación
- Esfuerzo vs beneficio → Puede bajar prioridad
```

**Ejemplo IACT:**

```
PRIORIZACION DE REQUISITOS - Componente Autenticación

MUST HAVE (Sprint 1):
- RF-005: API POST /auth/login [RN-C01-01 obligatoria]
- RF-006: Generar tokens JWT [RN-C01-03 obligatoria]
- RF-007: Registrar sesión PostgreSQL [RN-C01-13]
- RF-010: Sesión única [RN-C01-14]
- RNF-001: Tiempo < 500ms [Requisito de performance]

SHOULD HAVE (Sprint 2):
- RF-011: Cerrar sesión por inactividad [RN-C01-06]
- RF-012: Logout manual [RN-C01-05]
- RF-013: Validar complejidad password [RN-C01-07]
- RF-015: Límite de intentos [RN-C01-08]

COULD HAVE (Sprint 3 o posterior):
- RF-020: Recordar username en navegador
- RF-021: Recuperar contraseña por email
- RF-022: Login con 2FA (autenticación de dos factores)

WON'T HAVE (explícitamente fuera):
- RF-030: Login con OAuth2 (Google, Microsoft)
  Razón: RN-C01-01 prohíbe, solo login local
- RF-031: Login con biometría
  Razón: Fuera de alcance técnico actual
```

---

## FASE 4: Documentación de Procedimientos

### Objetivo

Detallar paso a paso cómo se ejecutará cada proceso/caso de uso en el sistema implementado.

### Duración Típica

1-2 semanas (en paralelo con desarrollo)

### Actividades

```
ACTIVIDAD 4.1: Identificar Procedimientos Necesarios
ACTIVIDAD 4.2: Diseñar Interfaces de Usuario
ACTIVIDAD 4.3: Documentar Procedimientos (SOPs)
ACTIVIDAD 4.4: Validar Procedimientos con Usuarios
```

---

### ACTIVIDAD 4.3: Documentar Procedimientos (SOPs)

**Entrada:**
- Casos de uso
- Diseños de UI
- Requisitos funcionales
- Reglas de negocio

**Formato: Procedimiento Operativo Estándar (SOP)**
- Paso a paso
- Screenshots
- Validaciones
- Mensajes de error
- Criterios de calidad

**Salida:**
- Procedimientos documentados
- Manuales de usuario
- Guías de referencia rápida

**Ejemplo IACT:**
Ver PROC-LOGIN-001 completo en [02_relaciones_fundamentales_iact.md](02_relaciones_fundamentales_iact.md) Sección 4.3

---

## Resumen del Flujo Completo

```
FASE 1: ANALISIS (1-2 semanas)
├─ Identificar necesidades (N-001)
├─ Identificar reglas (RN-C01-01 a RN-C01-14)
├─ Modelar AS-IS (proceso actual)
├─ Analizar gaps
└─ Diseñar TO-BE (proceso mejorado)
    |
    v
FASE 2: CASOS DE USO (1-2 semanas)
├─ Identificar actores
├─ Identificar UC (UC-001, UC-002, UC-003)
├─ Crear diagramas UML
└─ Especificar UC detalladamente
    |
    v
FASE 3: REQUISITOS (2-3 semanas)
├─ Derivar RF (RF-005, RF-006, ...)
├─ Identificar RNF (RNF-001, ...)
├─ Consolidar RN
├─ Priorizar (MoSCoW)
└─ Validar con stakeholders
    |
    v
FASE 4: PROCEDIMIENTOS (1-2 semanas, paralelo con desarrollo)
├─ Identificar procedimientos
├─ Diseñar UI
├─ Documentar SOPs (PROC-LOGIN-001)
└─ Validar con usuarios
    |
    v
IMPLEMENTACION Y VALIDACION
├─ Desarrollo TDD
├─ Tests de aceptación
├─ Validación de trazabilidad
└─ Despliegue

DURACION TOTAL: 5-9 semanas para un componente nuevo
```

---

## Referencias del Proyecto

### Documentos Clave

1. Procedimiento de Trazabilidad ISO 29148  
   `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md`

2. Guía de Casos de Uso  
   `docs/gobernanza/casos_de_uso_guide.md`

3. Plantillas de Requisitos  
   `docs/plantillas/template_requisito_*.md`

4. Componente 1 Completo (Ejemplo)  
   `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

---

**Ultima actualizacion:** 2025-11-05  
**Owner:** equipo-ba  
**Revisores:** equipo-arquitectura, equipo-producto
