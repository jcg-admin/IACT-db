# PARTE 2: TRANSFORMACIÓN DE BUSINESS RULES A CASOS DE USO Y FUNCTIONAL REQUIREMENTS

**Sistema:** IACT - Integrated Analysis and Contextual Traceability  
**Versión del Documento:** 2.0.0 - IACT Edition  
**Fecha:** Enero 2026  
**Alcance:** Secciones 1-3 (Fundamentos y Patrones de Transformación)

---

## PARTE 2A: FUNDAMENTOS Y PATRONES (Secciones 1-3)

**Documento Analizado:** PARTE_2A_FUNDAMENTOS_IACT.md  
**Longitud:** ~60 páginas estimadas  
**Objetivo:** Establecer los fundamentos de transformación BR → UC → FR

---

# SECCIÓN 1: INTRODUCCIÓN

## 1.1 Estructura y Alcance

### Entrada de PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md

Al finalizar PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md, obtuvimos:

- **45 Business Rules** del sistema IACT clasificadas por tipo
- **Catálogo completo** con metadatos (fuente, vigencia, stakeholders)
- **5 tipos identificados**: Hechos, Restricciones, Desencadenadores, Inferencias, Cálculos
- **Trazabilidad establecida** a documentos origen

**Estado actual del catálogo:**

| Tipo BR | Cantidad | % Total | Ejemplo |
|---------|----------|---------|---------|
| Hechos | 8 | 18% | BR-IACT-012: Code_slug único |
| Restricciones | 15 | 33% | BR-IACT-087: Permisos nivel 3 |
| Desencadenadores | 7 | 16% | BR-IACT-031: Alert sesión ⭐ |
| Inferencias | 6 | 13% | BR-IACT-046: Marcar expirada |
| Cálculos | 9 | 20% | BR-IACT-060: Score riesgo |
| **TOTAL** | **45** | **100%** | - |

### Objetivo de PARTE 2

Esta parte construye sobre ese fundamento, respondiendo a la pregunta central:

> **¿Cómo se transforman las Business Rules en elementos de requerimientos implementables?**

Específicamente, aprenderemos a:

**Objetivos Conceptuales:**
1. Comprender qué es un Caso de Uso y sus componentes esenciales
2. Dominar los **5 patrones de transformación** (uno por cada tipo de BR)
3. Distinguir cuándo una BR genera UC vs cuándo se integra en UC existente
4. Entender la diferencia crítica entre Desencadenadores e Inferencias

**Objetivos Prácticos:**
1. Construir Casos de Uso completos siguiendo estructura estándar profesional
2. Integrar múltiples BR de diferentes tipos en un mismo UC
3. Derivar Functional Requirements (FR) desde pasos de UC
4. Establecer trazabilidad bidireccional BR → UC → FR → Código

**Objetivos de Validación:**
1. Aplicar checklist de calidad a UC construidos
2. Calcular métricas de trazabilidad
3. Identificar UC huérfanos y BR sin cobertura
4. Auditar completitud del proceso

### Entregables Esperados

Al finalizar PARTE 2, tendremos:

**ENTREGABLE 1: Casos de Uso Derivados de Desencadenadores**
- UC-IACT-07: Notificar Expiración Inminente de Sesión (de BR-IACT-031) ⭐
- UC-IACT-08: Alertar Intento de Acceso Sospechoso
- UC-IACT-09: Notificar Vencimiento de Permiso Temporal
- Ratio: 7 Desencadenadores → 7 UC (1:1 perfecto)

**ENTREGABLE 2: Casos de Uso que Integran Múltiples BR**
- UC-IACT-04: Asignar Función Crítica (integra BR-IACT-087, 028, 060, 046, 012)
- UC-IACT-12: Transferir Segmento de Datos
- UC-IACT-15: Registrar Nueva Función en Catálogo

**ENTREGABLE 3: Functional Requirements Derivados**
- FR-301 a FR-309: De UC-IACT-07 (9 FR derivados del ejemplo central)
- FR-401 a FR-404: De BR-IACT-087 integrada en UC-IACT-04
- FR-205 a FR-209: De BR-IACT-028 integrada en UC-IACT-04
- ~156 FR totales derivados de 22 UC

**ENTREGABLE 4: Modelo de Dominio RBAC**
- Entidades derivadas de Hechos: Function, User, Permission, Segment, Grouper
- Relaciones con cardinalidad
- Atributos con restricciones UNIQUE, NOT NULL, etc.
- Esquema conceptual completo del sistema de permisos

**ENTREGABLE 5: Matriz de Trazabilidad**
- BR → UC → FR → Código
- Bidireccional (forward y backward)
- Cobertura >90% de BR en UC

### Proceso General de Transformación

```
┌─────────────────────┐
│  PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md: Catálogo  │
│  45 Business Rules  │
│  (Clasificadas)     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────────────────┐
│         PARTE 2: Transformación                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────┐        ┌──────────────┐     │
│  │  ANÁLISIS    │        │  DECISIÓN    │     │
│  │  Tipo de BR  │───────▶│  ¿Qué genera?│     │
│  └──────────────┘        └──────┬───────┘     │
│                                  │             │
│              ┌───────────────────┼─────────────────────┐
│              │                   │                     │
│              ▼                   ▼                     ▼
│   ┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│   │  UC COMPLETO   │  │  INTEGRACIÓN   │  │  MODELO/FR     │
│   │  (Desen.)      │  │  (Restr./Cálc.)│  │  (Hecho/Infer.)│
│   └───────┬────────┘  └────────┬───────┘  └────────┬───────┘
│           │                    │                    │
│           └────────────────────┼────────────────────┘
│                                │
│                                ▼
│                    ┌───────────────────────┐
│                    │  DERIVACIÓN DE FR     │
│                    │  (Functional Req.)    │
│                    └───────────┬───────────┘
│                                │
│                                ▼
│                    ┌───────────────────────┐
│                    │    TRAZABILIDAD       │
│                    │  BR → UC → FR → Code  │
│                    └───────────────────────┘
│                                                 │
└─────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────┐
│  PARTE 3: UC CRUD   │
│  Técnicas Adicional │
└─────────────────────┘
```

## 1.2 Decisión Central del Proceso

**La pregunta más importante de PARTE 2:**

> **¿Qué genera cada tipo de Business Rule?**

Esta tabla es la **guía de decisión** fundamental:

```
┌──────────────────┬────────────────────┬─────────────────────────────┐
│   TIPO DE BR     │  ¿GENERA UC        │         RESULTADO           │
│                  │  INDEPENDIENTE?    │                             │
├──────────────────┼────────────────────┼─────────────────────────────┤
│                  │                    │                             │
│  1. HECHO        │        NO          │  • Modelo de Dominio        │
│                  │                    │  • Entidades y relaciones   │
│                  │                    │  • Atributos con restrict.  │
│                  │                    │  • NO genera UC             │
│                  │                    │                             │
├──────────────────┼────────────────────┼─────────────────────────────┤
│                  │                    │                             │
│  2. RESTRICCIÓN  │    NO (indep.)     │  • Precondición en UC       │
│                  │                    │  • Validación en paso       │
│                  │                    │  • Flujo Alterno            │
│                  │                    │  • Se INTEGRA, no genera    │
│                  │                    │                             │
├──────────────────┼────────────────────┼─────────────────────────────┤
│                  │                    │                             │
│  3. DESENCADE-   │    SÍ ⭐⭐⭐       │  • UC COMPLETO              │
│     NADOR        │   (ÚNICO TIPO)     │  • 1 Desencadenador = 1 UC  │
│                  │                    │  • Comportamiento observable│
│                  │                    │  • Actor recibe resultado   │
│                  │                    │                             │
├──────────────────┼────────────────────┼─────────────────────────────┤
│                  │                    │                             │
│  4. INFERENCIA   │        NO          │  • FR Directo (sin UC)      │
│                  │                    │  • Cambio interno NO observ.│
│                  │                    │  • UPDATE automático        │
│                  │                    │  • Trazabilidad: BR→FR      │
│                  │                    │                             │
├──────────────────┼────────────────────┼─────────────────────────────┤
│                  │                    │                             │
│  5. CÁLCULO      │    NO (indep.)     │  • Paso dentro de UC        │
│                  │                    │  • FR con algoritmo         │
│                  │                    │  • Se INTEGRA, no genera    │
│                  │                    │                             │
└──────────────────┴────────────────────┴─────────────────────────────┘
```

### Implicación Crítica

**REGLA DE ORO:**

> **Solo los DESENCADENADORES generan Casos de Uso completos e independientes.**

Los demás tipos (Hechos, Restricciones, Inferencias, Cálculos) se integran en UC existentes o generan artefactos diferentes (Modelo, FR directo).

**Ejemplo visual:**

```
BR-IACT-031 (DESENCADENADOR):
"SI sesión lleva >12 minutos activa 
 ENTONCES enviar alerta al usuario"
           │
           ├──▶ ✅ GENERA UC-IACT-07 completo
           │    (Usuario RECIBE alerta = observable)
           │
           └──▶ Actor: Usuario (recibe mensaje)
                Trigger: Cada minuto (scheduler)
                Flujo: 7 pasos + 2 FA
                FR: 9 derivados

vs.

BR-IACT-046 (INFERENCIA):
"SI sesión >15 min inactividad 
 ENTONCES marcar como EXPIRADA"
           │
           ├──▶ ❌ NO genera UC
           │    (Solo campo BD cambia = NO observable)
           │
           └──▶ FR-305 directo: UPDATE estado
                (Sin UC intermedio)
```

---

# SECCIÓN 2: FUNDAMENTOS DE CASOS DE USO

## 2.1 Qué es un Caso de Uso

### Definición Formal

> **Caso de Uso:** Una descripción de una secuencia completa de interacciones entre un actor y el sistema, iniciada por el actor para alcanzar un objetivo específico que tiene valor para ese actor.

**Descomposición de la definición:**

1. **"Secuencia completa"** → Tiene inicio, desarrollo y fin definidos
2. **"Interacciones"** → Intercambio observable de información/acciones
3. **"Actor y sistema"** → Dos participantes claramente identificados
4. **"Iniciada por actor"** → El actor dispara, el sistema responde
5. **"Objetivo específico"** → Propósito claro y medible
6. **"Valor para actor"** → Resultado que beneficia al actor

### Ejemplos Correctos e Incorrectos del Dominio IACT

| ❌ Incorrecto (NO es UC) | ✅ Correcto (SÍ es UC) | Razón |
|-------------------------|---------------------|--------|
| "UC-01: Validar Usuario" | "UC-01: Iniciar Sesión" | Validar es subpaso, no objetivo completo |
| "UC-05: Pantalla de Permisos" | "UC-05: Consultar Permisos de Usuario" | Pantalla es UI, no comportamiento |
| "UC-10: Módulo de Acceso" | "UC-10: Asignar Funciones a Usuario" | Módulo es arquitectura, no acción |
| "UC-15: CRUD Funciones" | "UC-15: Registrar Nueva Función en Catálogo" | CRUD es patrón, no caso específico |
| "UC-20: Sistema RBAC" | "UC-20: Verificar Permisos Efectivos" | Sistema es contexto, no objetivo |

### Características Esenciales de un UC

**1. Interacción Completa**

No es solo "consultar", "validar" o "mostrar". Es una secuencia COMPLETA con:
- Entrada del actor
- Procesamiento del sistema
- Respuesta observable al actor
- Objetivo alcanzado

**Ejemplo completo:**
```
UC-IACT-04: Asignar Funciones a Usuario

1. Administrador selecciona usuario destino
2. Sistema muestra funciones disponibles
3. Administrador selecciona funciones
4. Sistema valida restricciones SoD [BR-IACT-087]
5. Sistema registra asignaciones
6. Sistema actualiza permisos efectivos
7. Sistema muestra confirmación
```

**2. Valor para el Actor**

El resultado debe tener sentido de negocio para el actor:

✅ "Asignar funciones" → Admin puede dar permisos (valor: control acceso)  
✅ "Consultar permisos" → User sabe qué puede hacer (valor: transparencia)  
✅ "Notificar expiración" → User puede extender sesión (valor: continuidad)

❌ "Validar token JWT" → Paso técnico sin valor directo para actor  
❌ "Actualizar caché" → Infraestructura, no negocio

**3. Comportamiento Observable**

El actor debe poder VER/PERCIBIR que algo ocurrió:

✅ Usuario recibe notificación en buzón interno  
✅ Usuario ve confirmación "Funciones asignadas correctamente"  
✅ Usuario observa que sus permisos cambiaron

❌ Sistema actualiza timestamp en BD (no observable por actor)  
❌ Sistema marca sesión como "vista" (cambio interno)

**4. Unidad de Análisis**

Un UC es la unidad mínima de funcionalidad con valor completo:

- NO es tan grande como un módulo
- NO es tan pequeño como una función/método
- Es el "grano" correcto de análisis

**5. Independencia Contextual**

Un UC bien escrito se entiende sin necesitar leer otros UC:

- Tiene sus propias precondiciones
- Tiene su propio flujo completo
- Tiene sus propias postcondiciones
- Referencias a otros UC son explícitas

## 2.2 Componentes de un Caso de Uso

Un Caso de Uso profesional tiene **12 componentes**, de los cuales **7 son obligatorios**:

### Componentes Obligatorios

```
┌───────────────────────────────────────────────────┐
│         ANATOMÍA DE UN CASO DE USO                │
├───────────────────────────────────────────────────┤
│                                                   │
│  1. ID ÚNICO                                      │
│     UC-IACT-04 (nomenclatura estándar)            │
│                                                   │
│  2. NOMBRE DESCRIPTIVO                            │
│     Verbo + Objeto (Asignar Funciones a Usuario)  │
│                                                   │
│  3. ACTOR PRIMARIO                                │
│     Quién inicia (AGR-007: agr_admin_acceso)      │
│                                                   │
│  4. PRECONDICIONES                                │
│     ¿Qué debe ser cierto ANTES?                   │
│     - Admin autenticado                           │
│     - Usuario destino existe y está ACTIVO        │
│     - Funciones existen en catálogo               │
│                                                   │
│  5. TRIGGER                                       │
│     ¿Qué desencadena el UC?                       │
│     Admin accede a "Control de Acceso" y          │
│     selecciona "Asignar Funciones"                │
│                                                   │
│  6. FLUJO NORMAL                                  │
│     Secuencia cuando todo sale perfecto           │
│     1. Admin selecciona usuario...                │
│     2. Sistema muestra funciones...               │
│     3. Admin selecciona...                        │
│     ...                                           │
│     7. Sistema muestra confirmación               │
│                                                   │
│  7. POSTCONDICIONES                               │
│     ¿Qué cambió en el sistema?                    │
│     - Funciones asignadas en user_functions       │
│     - Permisos efectivos actualizados             │
│     - Auditoría registrada                        │
│                                                   │
└───────────────────────────────────────────────────┘
```

### Componentes Opcionales (pero Recomendados)

**8. Actores Secundarios**

Otros participantes que NO inician pero SÍ participan:

```
UC-IACT-07: Notificar Expiración Inminente de Sesión

Actor Primario: Sistema (scheduler)
Actores Secundarios:
  - Usuario (recibe notificación)
  - SessionMonitorService (valida estado)
```

**9. Stakeholders e Intereses**

Quiénes se benefician y por qué:

```
Stakeholders:
  - Usuario: Quiere aviso con anticipación para no perder trabajo
  - Administrador: Quiere reducir sesiones zombie
  - Seguridad: Quiere cerrar sesiones inactivas automáticamente
```

**10. Flujos Alternos**

¿Qué pasa cuando algo sale diferente?

```
FA-1: Usuario Sin Nivel de Seguridad Requerido [BR-IACT-087]
  4a. Sistema detecta nivel_seguridad < 3
  4b. Sistema deniega asignación
  4c. Sistema muestra mensaje de error
  4d. UC termina sin asignar
```

**11. Garantías**

Promesas del sistema incluso si algo falla:

```
Garantías Mínimas (incluso con fallo):
  - Integridad de datos mantenida
  - Intento registrado en auditoría
  - Usuario recibe mensaje de error

Garantías de Éxito:
  - Asignaciones completadas atómicamente
  - Todas las validaciones pasadas
  - Auditoría completa registrada
```

**12. Business Rules Aplicadas**

Lista de BR que afectan este UC:

```
Business Rules Aplicadas:
  - BR-IACT-012: code_slug único (Hecho → Modelo)
  - BR-IACT-087: Nivel seguridad 3 (Restricción → Precond + FA)
  - BR-IACT-028: Aprobación si >10 users (Restricción → Valid + FA)
  - BR-IACT-060: Score de riesgo (Cálculo → Paso 6)
  - BR-IACT-046: Estado efectivo (Inferencia → Postcond)
```

## 2.3 Ejemplos del Dominio IACT

### Ejemplo Recurrente: UC-IACT-04

Este UC aparecerá múltiples veces en PARTE 2 porque ejemplifica la **integración de múltiples BR**.

```
UC-IACT-04: Asignar Funciones a Usuario

IDENTIFICACIÓN
--------------
ID: UC-IACT-04
Nombre: Asignar Funciones a Usuario
Versión: 2.0.0
Módulo: MOD_Access

ACTORES
-------
Actor Primario: AGR-007 (agr_admin_acceso)
Actores Secundarios: 
  - Sistema (validación SoD)
  - Usuario destino (recibe permisos)

CONTEXTO
--------
Precondiciones:
  - Administrador autenticado con función ACC-001
  - Usuario destino existe en sistema
  - Usuario destino tiene estado ACTIVO
  - SI función es crítica (función.es_critica = TRUE):
    ENTONCES admin tiene nivel_seguridad >= 3 [BR-IACT-087]
  - Funciones a asignar existen en catálogo

Trigger:
  Admin accede a "Control de Acceso" y selecciona "Asignar Funciones"

COMPORTAMIENTO
--------------
Flujo Normal (12 pasos):

  1. Admin selecciona opción "Asignar Funciones"
  
  2. Sistema muestra catálogo de 44 funciones disponibles
  
  3. Admin selecciona usuario destino
  
  4. Sistema verifica nivel_seguridad si hay funciones críticas [BR-IACT-087]
  
  5. Admin selecciona funciones a asignar (múltiples)
  
  6. Sistema calcula score de riesgo de acceso [BR-IACT-060]
  
  7. Sistema verifica si asignación afecta >10 usuarios [BR-IACT-028]
  
  8. SI afecta >10 usuarios:
       Sistema identifica Auditor responsable
       Sistema registra solicitud con estado "PENDIENTE_APROBACION"
       Ir a FA-1 [BR-IACT-028]
     SINO:
       Continuar
  
  9. Sistema valida restricciones SoD (Separación de Funciones)
  
  10. Sistema crea registros en user_functions
  
  11. Sistema actualiza permisos efectivos del usuario [BR-IACT-046]
  
  12. Sistema muestra confirmación con lista de funciones asignadas

FLUJOS ALTERNOS
---------------

FA-1: Asignación Requiere Aprobación de Auditor [BR-IACT-028]
  8a. Sistema detecta que cantidad_usuarios_afectados > 10
  8b. Sistema identifica auditor del segmento
  8c. Sistema registra solicitud con estado "PENDIENTE_APROBACION"
  8d. Sistema envía notificación interna al auditor
  8e. Sistema envía notificación interna al administrador
  8f. UC termina (continuará con UC-IACT-09: Aprobar Asignación Masiva)

FA-2: Usuario Destino Inactivo
  3a. Sistema consulta estado del usuario
  3b. estado != 'ACTIVO' (está SUSPENDIDO o ELIMINADO)
  3c. Sistema muestra mensaje de error
  3d. UC termina sin asignar

FA-3: Administrador Sin Nivel de Seguridad Requerido [BR-IACT-087]
  4a. Sistema detecta función.es_critica = TRUE
  4b. Sistema verifica admin.nivel_seguridad < 3
  4c. Sistema deniega acceso
  4d. Sistema muestra: "Requiere nivel de seguridad 3 para asignar funciones críticas"
  4e. Sistema registra intento en auditoría
  4f. Retornar a paso 5 (sin esa función en lista)

FA-4: Violación de Restricciones SoD
  9a. Sistema ejecuta validación de Separación de Funciones
  9b. Detecta conflicto (ej: asignar "aprobar" + "ejecutar" a mismo user)
  9c. Sistema lista funciones en conflicto
  9d. Sistema muestra mensaje explicativo
  9e. Retornar a paso 5

FA-5: Score de Riesgo Excede Umbral Crítico
  6a. Sistema calcula score_riesgo [BR-IACT-060]
  6b. score_riesgo > 85 (umbral crítico)
  6c. Sistema requiere justificación adicional
  6d. Admin ingresa justificación
  6e. Sistema registra justificación
  6f. Continuar con paso 7

FA-6: Error al Actualizar Permisos Efectivos
  11a. Sistema intenta UPDATE en tabla permissions_cache
  11b. BD retorna error (constraint, timeout, lock)
  11c. Sistema ejecuta ROLLBACK completo
  11d. Sistema registra error en log
  11e. Sistema muestra mensaje de error técnico
  11f. Sistema ofrece: "Reintentar" o "Cancelar"
  11g. Si Reintentar: Volver a paso 11
  11h. Si Cancelar: UC termina sin completar

RESULTADO
---------
Postcondiciones (Flujo Normal):
  - Funciones asignadas registradas en user_functions
  - Registros con fecha_asignacion = NOW()
  - Permisos efectivos actualizados en permissions_cache [BR-IACT-046]
  - Auditoría registrada: FUNCTION_ASSIGN
  - Usuario puede ejercer nuevas funciones inmediatamente
  - Score de riesgo recalculado

Postcondiciones (FA-1: Requiere Aprobación):
  - Solicitud registrada con estado "PENDIENTE_APROBACION"
  - Registro en approval_requests creado
  - Auditor notificado en buzón interno
  - Administrador notificado de envío a aprobación
  - Funciones NO asignadas aún

METADATOS
---------
Business Rules Aplicadas:
  - BR-IACT-012: Code_slug único por función (Hecho → Modelo)
  - BR-IACT-087: Nivel seguridad 3 para críticas (Restricción → Prec + FA-3)
  - BR-IACT-028: Aprobación si >10 usuarios (Restricción → Valid + FA-1)
  - BR-IACT-060: Score de riesgo (Cálculo → Paso 6)
  - BR-IACT-046: Permisos efectivos actualizados (Inferencia → Postcond)

Frecuencia: 50-100 veces al día
Prioridad: Alta
Complejidad: Alta (integra 5 BR de 4 tipos diferentes)
```

**Términos específicos IACT:**
- "funciones" (15× en UC)
- "permisos efectivos" (4×)
- "nivel de seguridad" (3×)
- "auditor del segmento" (2×)
- "SoD" / "Separación de Funciones" (3×)
- "score de riesgo" (3×)
- "buzón interno" (2×)

## 2.4 Actores y sus Tipos

### Taxonomía de Actores

Un **actor** es cualquier entidad externa que interactúa con el sistema. No es necesariamente una persona.

```
┌───────────────────────────────────────────────────┐
│         TAXONOMÍA DE ACTORES EN IACT              │
├────────────────┬──────────────────────────────────┤
│                │                                  │
│  ACTOR         │  • Inicia el UC                  │
│  PRIMARIO      │  • Tiene el objetivo principal   │
│                │  • Solo UNO por UC               │
│                │  • Recibe el resultado           │
│                │                                  │
│  Ejemplos IACT:│                                  │
│  - AGR-007 (Admin Acceso)                         │
│  - AGR-001 (Superusuario)                         │
│  - Usuario (genérico)                             │
│  - Sistema (tiempo) ⭐ ← para Desencadenadores     │
│                │                                  │
├────────────────┼──────────────────────────────────┤
│                │                                  │
│  ACTOR         │  • Participa pero NO inicia      │
│  SECUNDARIO    │  • Responde o provee info        │
│                │  • Puede haber varios            │
│                │  • Soporte al flujo              │
│                │                                  │
│  Ejemplos IACT:│                                  │
│  - Auditor (aprueba solicitudes)                  │
│  - Usuario destino (recibe permisos)              │
│  - Sistema (validaciones)                         │
│                │                                  │
├────────────────┼──────────────────────────────────┤
│                │                                  │
│  ACTOR         │  • Sistema externo               │
│  SISTEMA       │  • API o servicio                │
│                │  • Integración                   │
│                │  • Proveedor de datos            │
│                │                                  │
│  Ejemplos IACT:│                                  │
│  - BD IVR Legacy (readonly)                       │
│  - ETL Service                                    │
│  - LDAP/AD (si hubiera autenticación externa)    │
│                │                                  │
├────────────────┼──────────────────────────────────┤
│                │                                  │
│  ACTOR         │  • Ejecución periódica           │
│  TIEMPO        │  • Scheduler/Cron                │
│                │  • Batch jobs                    │
│                │  • Típico de Desencadenadores    │
│                │                                  │
│  Ejemplos IACT:│                                  │
│  - Sistema (cada minuto) ← UC-IACT-07            │
│  - Sistema (cada 6-12h) ← ETL updates            │
│  - Sistema (diario 02:00) ← Limpieza sesiones    │
│                │                                  │
└────────────────┴──────────────────────────────────┘
```

### Identificación del Actor Primario

**Pregunta clave:** "¿Quién quiere que esto ocurra?"

**Ejemplo de análisis:**

```
BR-IACT-031 (DESENCADENADOR):
"SI sesión lleva >12 minutos activa 
 ENTONCES enviar alerta al usuario"

Análisis:
  Comportamiento: "enviar alerta"
  
  ¿Quién se beneficia?
    ✓ Usuario recibe alerta → Se beneficia (puede extender sesión)
  
  ¿Quién INICIA la acción?
    ✗ NO es el usuario (él RECIBE, no inicia)
    ✓ ES el sistema (revisa automáticamente cada minuto)

Decisión: Actor Primario = Sistema (tiempo)
Trigger: Cada minuto (APScheduler job)
```

### Errores Comunes

**Error 1: Confundir actor primario con secundario**

❌ Incorrecto:
```
UC-IACT-04: Asignar Funciones
Actor Primario: Usuario (recibe permisos)
```

✅ Correcto:
```
UC-IACT-04: Asignar Funciones
Actor Primario: AGR-007 (admin que asigna)
Actor Secundario: Usuario (recibe permisos)
```

**Error 2: Usar componente técnico como actor**

❌ Incorrecto:
```
UC-IACT-08: Validar Token
Actor Primario: Middleware de Autenticación
```

✅ Correcto:
```
UC-IACT-08: Validar Token
Actor Primario: Sistema
(El middleware es infraestructura, no actor)
```

**Error 3: Múltiples actores primarios**

❌ Incorrecto:
```
UC-IACT-12: Transferir Segmento
Actores Primarios: Admin de Acceso y Admin de Segmento
```

✅ Correcto:
```
UC-IACT-12: Transferir Segmento
Actor Primario: AGR-007 (Admin de Acceso)
Actor Secundario: AGR-005 (Admin de Segmento, aprueba)
```

### Plantilla de Decisión

Cuando tengas duda sobre quién es el actor primario, usa esta secuencia:

```
Pregunta 1: ¿Es ejecución automática/periódica?
  SÍ → Actor: Sistema (tiempo)
       Ejemplo: UC-IACT-07 (notificación de expiración)
  NO → Continuar

Pregunta 2: ¿Es sistema externo/API?
  SÍ → Actor: [Nombre del Sistema]
       Ejemplo: UC-ETL-01 (sincronización desde IVR Legacy)
  NO → Continuar

Pregunta 3: ¿Es persona con rol específico?
  SÍ → Actor: [Agrupador/Rol]
       Ejemplo: AGR-007 (agr_admin_acceso)
```

## 2.5 Flujo Normal vs Flujos Alternos

### Estructura de Flujos en un Caso de Uso

```
┌────────────────────────────────────────────────────────┐
│              ESTRUCTURA DE FLUJOS EN UC                │
├────────────────────────────────────────────────────────┤
│                                                        │
│   PRECONDICIONES                                       │
│   (Lo que debe ser cierto ANTES)                       │
│                                                        │
│   ┌────────────────────────────────────┐              │
│   │                                    │              │
│   │        FLUJO NORMAL                │              │
│   │      (happy path)                  │              │
│   │                                    │              │
│   │   1. Actor hace X                  │              │
│   │   2. Sistema hace Y                │◄─────────┐   │
│   │   3. Sistema valida Z              │          │   │
│   │   4. Actor confirma                │          │   │
│   │   5. Sistema registra              │          │   │
│   │   6. Sistema muestra resultado     │          │   │
│   │                                    │          │   │
│   └────────────────────────────────────┘          │   │
│                 │                                  │   │
│                 │ (Si algo sale diferente)         │   │
│                 ▼                                  │   │
│   ┌────────────────────────────────────┐          │   │
│   │      FLUJOS ALTERNOS               │          │   │
│   │                                    │          │   │
│   │  FA-1: Error Validación            │          │   │
│   │    3a. Validación falla            │          │   │
│   │    3b. Sistema muestra error       │          │   │
│   │    3c. Retornar a paso 2  ─────────┼──────────┘   │
│   │                                    │              │
│   │  FA-2: Usuario Cancela             │              │
│   │    *a. En cualquier momento        │              │
│   │    *b. Actor cancela               │              │
│   │    *c. UC termina          ────────┼──────┐       │
│   │                                    │      │       │
│   │  FA-3: Timeout                     │      │       │
│   │    5a. Sistema no responde en 30s  │      │       │
│   │    5b. UC termina con error ───────┼──────┘       │
│   │                                    │              │
│   └────────────────────────────────────┘              │
│                 │                                      │
│                 ▼                                      │
│   POSTCONDICIONES                                      │
│   (Lo que cambió en el sistema)                        │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### 4 Tipos de Flujos Alternos

**TIPO A: Variación de Negocio**

No es un error, es un camino legítimo alternativo del negocio.

```
Ejemplo: FA-1 en UC-IACT-04

FA-1: Asignación Requiere Aprobación [BR-IACT-028]
  8a. Sistema detecta que cantidad_usuarios_afectados > 10
  8b. Sistema identifica auditor del segmento
  8c. Sistema registra solicitud con estado "PENDIENTE_APROBACION"
  8d. Sistema envía notificación al auditor
  8e. UC termina (continuará con UC-IACT-09: Aprobar Asignación)

Características:
  - NO es error
  - Es regla de negocio aplicada
  - Flujo completo y válido
  - Terminación controlada
```

**TIPO B: Error de Validación**

Dato inválido o faltante proporcionado por el actor.

```
Ejemplo: FA-2 en UC-IACT-15

FA-2: Code_slug Ya Existe en Catálogo [BR-IACT-012]
  4a. Sistema verifica code_slug único
  4b. Ya existe función con ese code_slug
  4c. Sistema muestra: "El código '{code_slug}' ya está registrado"
  4d. Sistema sugiere alternative codes
  4e. Retornar a paso 3 (para modificar)

Características:
  - Error de usuario
  - Validación de integridad
  - Retorno para corrección
  - Mensaje descriptivo
```

**TIPO C: Error Técnico**

Fallo de infraestructura, servicio externo, BD, etc.

```
Ejemplo: FA-6 en UC-IACT-04

FA-6: Error al Actualizar Permisos Efectivos
  11a. Sistema intenta UPDATE en permissions_cache
  11b. BD retorna error (constraint, timeout, lock)
  11c. Sistema ejecuta ROLLBACK completo
  11d. Sistema registra error en log con stack trace
  11e. Sistema muestra mensaje genérico de error
  11f. Sistema ofrece: "Reintentar" o "Reportar problema"
  11g. Si Reintentar: Esperar 2 segundos, volver a paso 11
  11h. Si Reportar: Generar ticket, UC termina

Características:
  - Fallo técnico
  - ROLLBACK automático
  - Logging detallado
  - Opción de reintento
  - Escalamiento si falla
```

**TIPO D: Usuario Cancela**

Actor decide no continuar en cualquier momento.

```
Ejemplo: FA-7 en UC-IACT-04

FA-7: Administrador Cancela Asignación
  *a. En cualquier momento antes de paso 10
  *b. Administrador presiona "Cancelar"
  *c. Sistema descarta selecciones temporales
  *d. Sistema NO registra auditoría (acción no completada)
  *e. Sistema muestra: "Asignación cancelada"
  *f. Retornar a menú principal de Control de Acceso

Características:
  - Punto de desviación: *a (cualquier momento)
  - Sin side effects
  - Sin auditoría
  - Retorno limpio
```

### Ejemplo Completo con Múltiples Flujos Alternos

```
UC-IACT-12: Transferir Segmento de Datos

Actor Primario: AGR-005 (agr_admin_segmento)

Flujo Normal (8 pasos):
  1. Admin selecciona segmento origen
  2. Sistema muestra usuarios asignados al segmento (cantidad)
  3. Admin selecciona segmento destino
  4. Sistema verifica compatibilidad de segmentos
  5. Admin confirma transferencia
  6. Sistema actualiza registros en user_segments
  7. Sistema recalcula permisos efectivos de usuarios afectados
  8. Sistema muestra confirmación con cantidad de usuarios transferidos

Flujos Alternos:

FA-1: Segmento Origen Sin Usuarios
  2a. Sistema consulta user_segments
  2b. No encuentra usuarios asignados al segmento origen
  2c. Sistema muestra: "El segmento '{nombre}' no tiene usuarios asignados"
  2d. UC termina

FA-2: Segmentos Incompatibles (Tipo Diferente)
  4a. Sistema verifica segmento_origen.tipo = segmento_destino.tipo
  4b. Tipos son diferentes (ej: 'GEOGRAFICO' vs 'FUNCIONAL')
  4c. Sistema deniega transferencia
  4d. Sistema muestra: "Solo se pueden transferir segmentos del mismo tipo"
  4e. Retornar a paso 3

FA-3: Segmento Destino en Estado BLOQUEADO
  4a. Sistema verifica segmento_destino.estado
  4b. estado = 'BLOQUEADO' (mantenimiento o auditoría)
  4c. Sistema muestra: "Segmento destino bloqueado temporalmente"
  4d. Sistema muestra fecha_desbloqueo estimada
  4e. UC termina

FA-4: Transferencia Requiere Aprobación (>50 usuarios)
  2a. Sistema cuenta usuarios en segmento
  2b. cantidad_usuarios > 50
  2c. Sistema requiere justificación adicional
  2d. Admin ingresa justificación
  2e. Sistema registra solicitud para aprobación
  2f. Sistema notifica a Auditor
  2g. UC termina (continuará con UC-IACT-13: Aprobar Transferencia)

FA-5: Error al Recalcular Permisos Masivos
  7a. Sistema inicia recálculo de permisos para N usuarios
  7b. Fallo en actualización de permissions_cache
  7c. Sistema ejecuta ROLLBACK de toda la transferencia
  7d. Sistema registra error con lista de usuarios afectados
  7e. Sistema muestra error técnico
  7f. Sistema ofrece "Reportar a soporte"
  7g. UC termina sin completar

FA-6: Administrador Cancela Transferencia
  *a. Cualquier momento antes de paso 6
  *b. Admin presiona "Cancelar"
  *c. Sistema descarta cambios temporales
  *d. Sistema muestra: "Transferencia cancelada"
  *e. Retornar a menú de Gestión de Segmentos
```

**Notación de Punto de Desviación:**

- `Xa.` → Después del paso X (ejemplo: 3a después de paso 3)
- `3-7a.` → Entre pasos 3 y 7
- `*a.` → En cualquier momento (típico de cancelaciones)

**Términos IACT en flujos alternos:**
- "segmento" (10× en ejemplo)
- "usuarios asignados" (3×)
- "permisos efectivos" (2×)
- "aprobación" / "auditor" (2×)
- "BLOQUEADO" / estados (3×)

---

# SECCIÓN 3: PATRONES DE TRANSFORMACIÓN POR TIPO

**LA SECCIÓN MÁS CRÍTICA DE PARTE 2**

Esta sección presenta los **5 patrones** de transformación, uno por cada tipo de Business Rule. Dominar estos patrones es esencial para realizar el análisis de requerimientos correctamente.

## 3.1 Patrón 1: Hechos → Modelo de Dominio

### Principio Fundamental

> **Los Hechos NO generan Casos de Uso porque no describen comportamiento, describen estructura.**

Un Hecho define:
- Qué entidades existen
- Qué atributos tienen
- Qué relaciones mantienen entre sí
- Qué restricciones de integridad aplican

**El resultado de un Hecho es el MODELO DE DOMINIO, no un UC.**

### Ejemplo Principal: BR-IACT-012

```
BR-IACT-012 (HECHO):
"Cada función del catálogo RBAC tiene un code_slug único que no 
 puede reasignarse a otra función. El code_slug sigue el formato 
 ABC-NNN (3 letras, guión, 3 dígitos)."

Tipo: Hecho
Fuente: Normativa NIST RBAC + CNST-005
Vigencia: Desde 2025-01-01
```

**Análisis Paso a Paso:**

**PASO 1: Identificar Entidades**

¿Qué "cosas" menciona la BR?
- "función del catálogo RBAC" → Entidad: **Function**
- Implícito: Catálogo → Entidad: **RBACCatalog** (o contenedor lógico)

**PASO 2: Identificar Atributos**

¿Qué propiedades tienen?
- `code_slug` (mencionado explícitamente)
- Formato: ABC-NNN (restricción de formato)
- Implícitos típicos de función:
  * `function_id` (PK)
  * `name` (nombre descriptivo)
  * `description`
  * `es_critica` (boolean)
  * `categoria` (ej: 'CONSULTA', 'MODIFICACION', 'ADMIN')

**PASO 3: Identificar Características del Atributo**

- **UNIQUE** - "único que no puede reasignarse"
- **NOT NULL** - Obligatorio para toda función
- **IMMUTABLE** - "no puede reasignarse" → Una vez asignado, no cambia
- **FORMATO** - "ABC-NNN" → Validación regex: `^[A-Z]{3}-\d{3}$`

**PASO 4: Identificar Relaciones**

En este caso:
- Function "pertenece a" RBACCatalog (implícito)
- Function "se asigna a" User (relación N:N a través de user_functions)
- Function "tiene" Permission (1:N, una función tiene múltiples permisos)

**PASO 5: Crear Modelo de Dominio**

```
┌─────────────────────────────────────────────────┐
│               MODELO DE DOMINIO                 │
│            (Derivado de BR-IACT-012)            │
├─────────────────────────────────────────────────┤
│                                                 │
│   ┌──────────────────────┐                     │
│   │    RBACCatalog       │                     │
│   ├──────────────────────┤                     │
│   │ + catalog_version    │                     │
│   │ + fecha_vigencia     │                     │
│   │ + total_functions    │                     │
│   └──────────┬───────────┘                     │
│              │ 1                               │
│              │                                 │
│              │ contiene                        │
│              │                                 │
│              │ N                               │
│   ┌──────────▼───────────┐                    │
│   │      Function        │                    │
│   ├──────────────────────┤                    │
│   │ PK function_id       │ INT AUTO_INCREMENT │
│   │ UK code_slug ⭐      │ VARCHAR(7)         │
│   │    name              │ VARCHAR(100)       │
│   │    description       │ TEXT               │
│   │    es_critica        │ BOOLEAN            │
│   │    categoria         │ ENUM               │
│   │    fecha_creacion    │ TIMESTAMP          │
│   └──────────┬───────────┘                    │
│              │ 1                              │
│              │                                │
│              │ define                         │
│              │                                │
│              │ N                              │
│   ┌──────────▼───────────┐                   │
│   │     Permission       │                   │
│   ├──────────────────────┤                   │
│   │ PK permission_id     │                   │
│   │ FK function_id       │ → Function        │
│   │    resource_type     │ VARCHAR(50)       │
│   │    action            │ ENUM(CRUD)        │
│   └──────────────────────┘                   │
│                                               │
└───────────────────────────────────────────────┘

CONSTRAINTS (de BR-IACT-012):
-----------------------------
ALTER TABLE functions
  ADD CONSTRAINT uk_code_slug 
    UNIQUE (code_slug);
  
  ADD CONSTRAINT chk_code_slug_format 
    CHECK (code_slug REGEXP '^[A-Z]{3}-[0-9]{3}$');
  
  MODIFY code_slug VARCHAR(7) NOT NULL;

INDEX para performance:
CREATE INDEX idx_function_categoria 
  ON functions(categoria);

CREATE INDEX idx_function_critica 
  ON functions(es_critica) 
  WHERE es_critica = TRUE;
```

**PASO 6: Documentar No-Generación de UC**

```
BR-IACT-012 NO genera Caso de Uso porque:
  ✓ Es estructura, no comportamiento
  ✓ Define el modelo, no acciones
  ✓ Se consulta en múltiples UC pero no genera UC propio

UC que USAN este modelo:
  - UC-IACT-04: Asignar Funciones (consulta catálogo)
  - UC-IACT-15: Registrar Nueva Función (crea con code_slug)
  - UC-IACT-18: Modificar Función (NO puede cambiar code_slug)
  - UC-IACT-22: Eliminar Función (baja lógica)
```

### Ejemplo Adicional: BR-IACT-018

```
BR-IACT-018 (HECHO):
"Un agrupador puede contener múltiples funciones, y una función 
 puede pertenecer a múltiples agrupadores. La relación se establece 
 a través de la tabla grouper_functions con fecha de asociación."

Tipo: Hecho
Impacto: Define relación N:N

Modelo resultante:

┌──────────────┐              ┌─────────────────────┐              ┌──────────────┐
│   Grouper    │              │  grouper_functions  │              │   Function   │
├──────────────┤              ├─────────────────────┤              ├──────────────┤
│ grouper_id   │◄─────────────┤ grouper_id (FK)     │              │ function_id  │
│ code         │ 1          N ├─────────────────────┤ N          1 │ code_slug    │
│ name         │              │ function_id (FK)    ├──────────────►│ name         │
│ description  │              ├─────────────────────┤              │ es_critica   │
│ estado       │              │ fecha_asociacion    │              │ categoria    │
└──────────────┘              │ asignado_por        │              └──────────────┘
                              │ PK(grouper_id,      │
                              │    function_id)     │
                              └─────────────────────┘

Tabla de asociación captura:
  - Relación N:N
  - Auditoría: fecha_asociacion, asignado_por
  - PK compuesta para unicidad
```

### Ejemplo Breve: BR-IACT-022

```
BR-IACT-022 (HECHO):
"Una asignación de función a usuario tiene cardinalidad mínima 0 
 (usuario puede no tener funciones) y máxima N (sin límite)."

Modelo:

User "1" ─────< "0..N" user_functions >───── "N" Function

Implementación:
  - FK opcional (user_id puede no tener registros)
  - Sin constraint de mínimo
  - Sin constraint de máximo
```

### Resumen del Patrón Hechos

```
┌────────────────────────────────────────────────────┐
│         PATRÓN 1: HECHOS → MODELO                  │
├────────────────────────────────────────────────────┤
│                                                    │
│  ENTRADA:  BR de tipo HECHO                        │
│            Describe estructura del dominio         │
│                                                    │
│  PROCESO:  1. Identificar entidades                │
│            2. Identificar atributos                │
│            3. Identificar características (UK, NN) │
│            4. Identificar relaciones               │
│            5. Crear diagrama de clases             │
│                                                    │
│  SALIDA:   Modelo de Dominio                       │
│            Esquema de BD                           │
│            Constraints                             │
│                                                    │
│  NO GENERA: Caso de Uso                            │
│                                                    │
│  SE USA EN: Múltiples UC que consultan/modifican   │
│             las entidades del modelo               │
│                                                    │
└────────────────────────────────────────────────────┘
```

## 3.2 Patrón 2: Restricciones → Precondiciones/Validaciones/Flujos Alternos

### Principio Fundamental

> **Las Restricciones NO generan Casos de Uso independientes. Se integran en UC existentes en una de tres ubicaciones: Precondición, Validación en Paso, o Flujo Alterno.**

Una Restricción limita o condiciona el comportamiento del sistema. Puede aplicar:
- **ANTES** del UC (Precondición)
- **DURANTE** el UC (Validación en paso)
- **Cuando se viola** (Flujo Alterno)

### Las 3 Ubicaciones Posibles

```
┌────────────────────────────────────────────────────┐
│     UBICACIONES DE UNA RESTRICCIÓN EN UC           │
├────────────────────────────────────────────────────┤
│                                                    │
│  UBICACIÓN 1: PRECONDICIÓN (aplica ANTES)          │
│  ├─ Condición que debe cumplirse para INICIAR     │
│  ├─ Si no cumple, UC no puede ejecutarse          │
│  └─ Ejemplo: "Usuario debe tener nivel seg >= 3"  │
│                                                    │
│  UBICACIÓN 2: VALIDACIÓN EN PASO (aplica DURANTE)  │
│  ├─ Condición verificada en un paso específico    │
│  ├─ Sistema valida explícitamente                 │
│  └─ Ejemplo: "Sistema verifica score_riesgo < 85" │
│                                                    │
│  UBICACIÓN 3: FLUJO ALTERNO (cuando se VIOLA)      │
│  ├─ Qué pasa cuando la restricción no se cumple   │
│  ├─ Manejo del caso negativo                      │
│  └─ Ejemplo: "FA-3: Nivel seguridad insuficiente" │
│                                                    │
└────────────────────────────────────────────────────┘
```

### Ejemplo 1: BR-IACT-087 como PRECONDICIÓN

```
BR-IACT-087 (RESTRICCIÓN):
"Solo usuarios con nivel de seguridad 3 o superior pueden asignar 
 funciones críticas (function.es_critica = TRUE). Esta restricción 
 aplica independientemente del rol o agrupador del usuario."

Tipo: Restricción de Autorización
Fuente: CNST-009 (Auditoría y Control)
Criticidad: Alta
Vigencia: Desde 2025-10-01
```

**Análisis de Integración:**

```
PREGUNTA: ¿Cuándo aplica esta restricción?

Respuesta: ANTES de permitir la asignación

Por lo tanto: Se integra como PRECONDICIÓN + FLUJO ALTERNO

UC donde aplica: UC-IACT-04 (Asignar Funciones a Usuario)
```

**INTEGRACIÓN EN UC-IACT-04:**

```
UC-IACT-04: Asignar Funciones a Usuario

PRECONDICIONES (ACTUALIZADAS):
  - Administrador autenticado con función ACC-001
  - Usuario destino existe y tiene estado ACTIVO
  - SI función es crítica (función.es_critica = TRUE):
    ENTONCES admin tiene nivel_seguridad >= 3 [BR-IACT-087] ⭐
  - Funciones a asignar existen en catálogo

Flujo Normal:
  ...
  4. Sistema verifica nivel_seguridad si hay funciones críticas [BR-IACT-087]
  ...

FLUJO ALTERNO DERIVADO:

FA-3: Administrador Sin Nivel de Seguridad Requerido [BR-IACT-087]
  
  Punto de desviación: Paso 4
  
  4a. Sistema detecta que al menos una función tiene es_critica = TRUE
  
  4b. Sistema consulta nivel_seguridad del administrador:
      SELECT nivel_seguridad 
      FROM users 
      WHERE user_id = {admin_id}
  
  4c. Sistema verifica: nivel_seguridad < 3
  
  4d. Sistema deniega asignación de funciones críticas
  
  4e. Sistema muestra mensaje:
      "Requiere nivel de seguridad 3 o superior para asignar 
       funciones críticas. Su nivel actual: {nivel_actual}. 
       Funciones críticas intentadas: {lista_funciones_criticas}"
  
  4f. Sistema registra intento denegado en auditoría:
      - Evento: CRITICAL_FUNCTION_DENIED
      - Admin: {admin_id}
      - Funciones: {lista_code_slugs}
      - Razón: Nivel seguridad insuficiente
      - Timestamp: NOW()
  
  4g. Sistema ofrece dos opciones:
      [Continuar sin funciones críticas] [Cancelar asignación]
  
  4h. Si "Continuar": 
      - Remover funciones críticas de selección
      - Retornar a paso 5 con funciones no-críticas únicamente
  
  4i. Si "Cancelar":
      - UC termina sin asignar ninguna función

POSTCONDICIONES (ACTUALIZADAS):
  - Si FA-3 con "Continuar": Solo funciones no-críticas asignadas
  - Auditoría completa del intento (incluye funciones denegadas)
```

**Functional Requirements Derivados:**

```
RF-401: Verificar Nivel de Seguridad del Administrador

Descripción:
  Sistema debe verificar que el administrador tiene nivel_seguridad >= 3
  cuando intenta asignar funciones con es_critica = TRUE.

Derivado de: UC-IACT-04 Paso 4
Implementa: BR-IACT-087
Prioridad: Crítica (Seguridad)

Algoritmo:
  # 1. Identificar funciones críticas en selección
  funciones_criticas = []
  FOR EACH funcion IN funciones_seleccionadas:
    IF funcion.es_critica = TRUE THEN
      funciones_criticas.APPEND(funcion)
    END IF
  END FOR
  
  # 2. Si hay críticas, verificar nivel
  IF funciones_criticas IS NOT EMPTY THEN
    nivel_admin = SELECT nivel_seguridad 
                  FROM users 
                  WHERE user_id = admin_id
    
    IF nivel_admin < 3 THEN
      RETURN (
        permitido: FALSE,
        razon: 'Nivel seguridad insuficiente',
        nivel_requerido: 3,
        nivel_actual: nivel_admin,
        funciones_denegadas: funciones_criticas
      )
    END IF
  END IF
  
  RETURN (permitido: TRUE)

Query SQL:
  SELECT 
    u.nivel_seguridad,
    COUNT(CASE WHEN f.es_critica = TRUE THEN 1 END) as criticas_count
  FROM users u
  CROSS JOIN selected_functions sf
  JOIN functions f ON sf.function_id = f.function_id
  WHERE u.user_id = ?
  GROUP BY u.nivel_seguridad;

Casos de Prueba:
  - Admin nivel 3 + 2 críticas → Permitir
  - Admin nivel 2 + 1 crítica → Denegar
  - Admin nivel 4 + 0 críticas → Permitir (no aplica restricción)
  - Admin nivel 1 + 5 críticas → Denegar con lista completa

RF-402: Listar Funciones Críticas en Selección

Descripción:
  Sistema debe identificar qué funciones de la selección tienen
  es_critica = TRUE para mostrar al administrador.

Derivado de: UC-IACT-04 Paso 4 (subacción)
Implementa: BR-IACT-087 (identificación)
Prioridad: Alta

Query:
  SELECT 
    f.function_id,
    f.code_slug,
    f.name,
    f.es_critica,
    f.categoria
  FROM functions f
  WHERE f.function_id IN ({lista_seleccionadas})
    AND f.es_critica = TRUE
  ORDER BY f.code_slug;

RF-403: Registrar Intento Denegado en Auditoría

Descripción:
  Sistema debe crear registro en audit_log cuando se deniega
  asignación de funciones críticas por nivel insuficiente.

Derivado de: UC-IACT-04 FA-3 Paso 4f
Implementa: BR-IACT-087 (auditoría)
Prioridad: Crítica (Compliance)

Estructura del log:
  INSERT INTO audit_log (
    evento_tipo,
    user_id,
    admin_id,
    resource_type,
    resource_ids,
    action_attempted,
    resultado,
    razon_denegacion,
    metadata_json,
    ip_address,
    timestamp
  ) VALUES (
    'CRITICAL_FUNCTION_DENIED',
    {admin_id},
    NULL,
    'Function',
    {array_function_ids_criticas},
    'ASSIGN',
    'DENIED',
    'Nivel seguridad insuficiente',
    '{"nivel_requerido": 3, "nivel_actual": {nivel}}',
    {ip_address},
    NOW()
  );

Retención: 2 años (compliance CNST-009)

RF-404: Mostrar Mensaje de Denegación Informativo

Descripción:
  Sistema debe componer mensaje claro indicando por qué se denegó
  la asignación y qué opciones tiene el administrador.

Derivado de: UC-IACT-04 FA-3 Paso 4e
Implementa: BR-IACT-087 (comunicación)
Prioridad: Alta (UX)

Template del mensaje:
  Título: "Asignación de Funciones Críticas Denegada"
  
  Cuerpo:
  "Requiere nivel de seguridad 3 o superior para asignar funciones críticas.
   
   Su nivel actual: {nivel_actual}
   Nivel requerido: 3
   
   Funciones críticas en su selección:
   {lista_code_slug_con_nombres}
   
   Opciones:
   - Continuar asignando solo las funciones no-críticas
   - Cancelar esta operación
   - Contactar al administrador de seguridad para elevar su nivel"
  
  Botones: [Continuar sin críticas] [Cancelar] [Ayuda]
```

### Ejemplo 2: BR-IACT-028 como VALIDACIÓN + FLUJO ALTERNO

```
BR-IACT-028 (RESTRICCIÓN):
"Asignaciones masivas que afectan más de 10 usuarios requieren 
 aprobación del auditor del segmento correspondiente antes de 
 aplicarse. El auditor tiene 48 horas para aprobar o rechazar."

Tipo: Restricción de Control
Fuente: CNST-009 + Política de Auditoría Interna
Criticidad: Alta
Vigencia: Desde 2025-06-01
```

**Análisis de Integración:**

```
PREGUNTA: ¿Cuándo aplica esta restricción?

Respuesta: DURANTE el flujo, después de saber cantidad de usuarios
          pero ANTES de aplicar cambios

Por lo tanto: Validación en PASO + FLUJO ALTERNO

UC donde aplica: UC-IACT-04 cuando se usa con agrupador
```

**INTEGRACIÓN EN UC-IACT-04 (variante masiva):**

```
UC-IACT-04: Asignar Funciones (Variante: Via Agrupador)

Flujo Normal (modificado):
  ...
  7. Sistema cuenta usuarios que serán afectados [BR-IACT-028]
  
     Query:
     SELECT COUNT(DISTINCT ug.user_id) as usuarios_afectados
     FROM user_groupers ug
     WHERE ug.grouper_id = {grouper_seleccionado}
       AND ug.estado = 'ACTIVO';
  
  8. Sistema verifica si cantidad > 10 [BR-IACT-028]
  
     IF usuarios_afectados > 10 THEN
       Ir a FA-1: Requiere Aprobación de Auditor
     ELSE
       Continuar con paso 9
     END IF
  
  9. Sistema aplica asignaciones...
  ...

FLUJO ALTERNO DERIVADO:

FA-1: Asignación Requiere Aprobación de Auditor [BR-IACT-028]
  
  Punto de desviación: Paso 8
  
  8a. Sistema detecta usuarios_afectados > 10
  
  8b. Sistema identifica auditor del segmento:
      
      SELECT u.user_id, u.email, u.nombre
      FROM users u
      JOIN user_segments us ON u.user_id = us.user_id
      JOIN segments s ON us.segment_id = s.segment_id
      WHERE s.segment_id = {segment_del_agrupador}
        AND u.tiene_funcion('AUD-001') = TRUE  -- auditor function
        AND u.estado = 'ACTIVO'
      LIMIT 1;
  
  8c. Sistema genera solicitud de aprobación:
      
      INSERT INTO approval_requests (
        request_type,
        requested_by_user_id,
        affected_grouper_id,
        affected_user_count,
        functions_to_assign,
        estado,
        auditor_assigned_id,
        fecha_solicitud,
        fecha_limite_aprobacion  -- +48 horas
      ) VALUES (
        'MASS_FUNCTION_ASSIGNMENT',
        {admin_id},
        {grouper_id},
        {usuarios_afectados},
        {json_array_functions},
        'PENDIENTE',
        {auditor_id},
        NOW(),
        NOW() + INTERVAL 48 HOUR
      );
  
  8d. Sistema envía notificación interna al auditor:
      
      Asunto: "Aprobación Requerida: Asignación Masiva de Funciones"
      
      Cuerpo:
      "{admin_nombre} solicita aprobar asignación masiva de funciones.
       
       Detalles:
       - Agrupador: {grouper_code} - {grouper_name}
       - Usuarios afectados: {cantidad}
       - Funciones a asignar: {lista_code_slugs}
       - Fecha límite: {fecha_limite}
       
       Para revisar y aprobar: [Link a UC-IACT-09]"
  
  8e. Sistema envía confirmación al administrador:
      
      "Su solicitud de asignación masiva ha sido enviada a aprobación.
       
       Auditor asignado: {auditor_nombre}
       Usuarios afectados: {cantidad}
       Fecha límite de respuesta: {fecha_limite}
       
       Recibirá notificación cuando sea aprobada o rechazada."
  
  8f. Sistema registra en auditoría:
      - Evento: MASS_ASSIGNMENT_REQUESTED
      - Admin: {admin_id}
      - Grouper: {grouper_id}
      - Users_count: {cantidad}
      - Estado: PENDIENTE
  
  8g. UC termina sin aplicar asignaciones
      (Continuará con UC-IACT-09: Aprobar Asignación Masiva)

POSTCONDICIONES (FA-1):
  - Solicitud registrada con estado PENDIENTE
  - Auditor notificado en buzón interno
  - Administrador notificado de envío a aprobación
  - Funciones NO asignadas aún (pendiente aprobación)
  - Timer de 48 horas iniciado
```

**Functional Requirements Derivados:**

```
RF-205: Contar Usuarios Afectados por Asignación Masiva

Descripción:
  Sistema debe calcular cuántos usuarios serán afectados cuando
  se asignan funciones a través de un agrupador.

Derivado de: UC-IACT-04 Paso 7
Implementa: BR-IACT-028 (condición de aplicación)
Prioridad: Alta

Query:
  SELECT 
    COUNT(DISTINCT ug.user_id) as usuarios_afectados,
    s.segment_id,
    s.nombre as segment_nombre
  FROM user_groupers ug
  JOIN groupers g ON ug.grouper_id = g.grouper_id
  LEFT JOIN segments s ON g.segment_id = s.segment_id
  WHERE ug.grouper_id = ?
    AND ug.estado = 'ACTIVO'
    AND ug.user_id IN (
      SELECT user_id FROM users WHERE estado = 'ACTIVO'
    )
  GROUP BY s.segment_id, s.nombre;

Performance:
  - Índice en (grouper_id, estado) 
  - Típicamente retorna <100 usuarios
  - Tiempo esperado: <50ms

RF-206: Identificar Auditor del Segmento

Descripción:
  Sistema debe encontrar al auditor responsable del segmento
  donde se aplicará la asignación masiva.

Derivado de: UC-IACT-04 FA-1 Paso 8b
Implementa: BR-IACT-028 (aprobador)
Prioridad: Crítica

Lógica:
  1. Obtener segment_id del grouper
  2. Buscar usuario con función AUD-001 en ese segmento
  3. Si no hay auditor: Escalar a AGR-001 (superusuario)
  4. Si hay múltiples: Elegir por menor carga de trabajo

Query:
  SELECT 
    u.user_id,
    u.nombre,
    COUNT(ar.request_id) as pending_approvals
  FROM users u
  JOIN user_functions uf ON u.user_id = uf.user_id
  JOIN functions f ON uf.function_id = f.function_id
  JOIN user_segments us ON u.user_id = us.user_id
  LEFT JOIN approval_requests ar ON ar.auditor_assigned_id = u.user_id
    AND ar.estado = 'PENDIENTE'
  WHERE f.code_slug = 'AUD-001'
    AND us.segment_id = ?
    AND u.estado = 'ACTIVO'
  GROUP BY u.user_id, u.nombre
  ORDER BY pending_approvals ASC
  LIMIT 1;

RF-207: Registrar Solicitud de Aprobación

Descripción:
  Sistema debe crear registro en approval_requests con todos
  los datos necesarios para la aprobación.

Derivado de: UC-IACT-04 FA-1 Paso 8c
Implementa: BR-IACT-028 (proceso de aprobación)
Prioridad: Alta

Campos obligatorios:
  - request_type: 'MASS_FUNCTION_ASSIGNMENT'
  - requested_by_user_id: {admin_id}
  - affected_grouper_id: {grouper_id}
  - affected_user_count: {cantidad}
  - functions_to_assign: JSON array de function_ids
  - estado: 'PENDIENTE'
  - auditor_assigned_id: {auditor_id}
  - fecha_solicitud: NOW()
  - fecha_limite_aprobacion: NOW() + 48 HOURS

Estados posibles:
  - PENDIENTE: Esperando decisión
  - APROBADA: Auditor aprobó
  - RECHAZADA: Auditor rechazó
  - EXPIRADA: >48h sin respuesta
  - CANCELADA: Admin canceló antes de aprobación

RF-208: Enviar Notificación Interna de Aprobación

Descripción:
  Sistema debe enviar mensaje al buzón interno del auditor
  informando de la solicitud pendiente.

Derivado de: UC-IACT-04 FA-1 Paso 8d
Implementa: BR-IACT-028 (notificación)
Prioridad: Alta

Estructura mensaje:
  INSERT INTO internal_messages (
    recipient_user_id,
    sender_user_id,
    message_type,
    subject,
    body_text,
    priority,
    action_required,
    related_entity_type,
    related_entity_id,
    fecha_envio
  ) VALUES (
    {auditor_id},
    NULL,  -- mensaje del sistema
    'APPROVAL_REQUEST',
    'Aprobación Requerida: Asignación Masiva',
    {body_template},
    'HIGH',
    TRUE,
    'ApprovalRequest',
    {request_id},
    NOW()
  );

Template del cuerpo:
  "{admin_nombre} solicita su aprobación para asignación masiva.
   
   Detalles:
   - Agrupador: {grouper_code} - {grouper_name}
   - Funciones: {lista_nombres_funciones}
   - Usuarios afectados: {cantidad}
   - Plazo: {fecha_limite} ({horas_restantes}h restantes)
   
   Para revisar: [Link directo a UC-IACT-09]
   Request ID: {request_id}"

RF-209: Iniciar Timer de Expiración (48 horas)

Descripción:
  Sistema debe programar job que marcará la solicitud como
  EXPIRADA si no recibe respuesta en 48 horas.

Derivado de: UC-IACT-04 FA-1 (proceso completo)
Implementa: BR-IACT-028 (plazo)
Prioridad: Media

Implementación con APScheduler:
  scheduler.add_job(
    func=check_approval_expiration,
    trigger='date',
    run_date=fecha_limite_aprobacion,
    args=[request_id],
    id=f'approval_expire_{request_id}',
    replace_existing=True
  )

Lógica de expiración:
  def check_approval_expiration(request_id):
    request = ApprovalRequest.objects.get(id=request_id)
    
    if request.estado == 'PENDIENTE':
      request.estado = 'EXPIRADA'
      request.fecha_expiracion = NOW()
      request.save()
      
      # Notificar a admin que solicitó
      send_internal_message(
        recipient=request.requested_by_user_id,
        subject='Solicitud de Aprobación Expirada',
        body=f'Su solicitud #{request_id} expiró sin respuesta...'
      )
      
      # Registrar en auditoría
      audit_log(
        event='APPROVAL_EXPIRED',
        request_id=request_id
      )
```

### Resumen del Patrón Restricciones

```
┌────────────────────────────────────────────────────┐
│     PATRÓN 2: RESTRICCIONES → INTEGRACIÓN         │
├────────────────────────────────────────────────────┤
│                                                    │
│  ENTRADA:  BR de tipo RESTRICCIÓN                  │
│            Limita/condiciona comportamiento        │
│                                                    │
│  DECISIÓN: ¿Cuándo aplica la restricción?         │
│            - ANTES → Precondición                  │
│            - DURANTE → Validación en paso          │
│            - CUANDO VIOLA → Flujo Alterno          │
│                                                    │
│  PROCESO:  1. Identificar UC afectado              │
│            2. Determinar punto de verificación     │
│            3. Agregar a Precondiciones             │
│            4. Agregar paso de validación           │
│            5. Crear Flujo Alterno para violación   │
│                                                    │
│  SALIDA:   UC enriquecido con:                     │
│            - Precondición adicional                │
│            - Paso de validación                    │
│            - FA para manejo de violación           │
│            - FR derivados de validación            │
│                                                    │
│  NO GENERA: Caso de Uso independiente              │
│                                                    │
│  TRAZABILIDAD: BR → UC (integrada) → FR            │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 3.3 Patrón 3: Desencadenadores → Casos de Uso Completos

### Principio Fundamental

> **Los Desencadenadores son el ÚNICO tipo de BR que genera Casos de Uso completos e independientes.**

**¿Por qué?**

Un Desencadenador describe un **comportamiento observable** iniciado automáticamente por una condición temporal o de estado. Cumple todos los requisitos de un UC:
- Tiene actor primario (típicamente: Sistema/Tiempo)
- Tiene objetivo con valor (notificar, alertar, actualizar)
- Tiene interacción completa (el actor secundario RECIBE el resultado)
- Es comportamiento observable (el usuario VE/PERCIBE algo)

### Diferencia Crítica: Desencadenador vs Inferencia

**LA DISTINCIÓN MÁS IMPORTANTE DE PARTE 2:**

```
┌──────────────────────────────────────────────────────────┐
│  DESENCADENADOR vs INFERENCIA: ¿Cómo Diferenciarlos?    │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  DESENCADENADOR:                                         │
│  ├─ Resultado es OBSERVABLE por actor externo           │
│  ├─ Alguien RECIBE notificación/mensaje/cambio visible  │
│  ├─ Actor secundario PERCIBE que algo ocurrió           │
│  └─ GENERA UC completo                                  │
│                                                          │
│  Ejemplo:                                                │
│  "SI sesión >12 min ENTONCES enviar alerta"             │
│  → Usuario RECIBE alerta en buzón ✅ Observable         │
│  → UC-IACT-07 generado                                  │
│                                                          │
│  ────────────────────────────────────────────────────   │
│                                                          │
│  INFERENCIA:                                             │
│  ├─ Resultado NO es observable (cambio interno)         │
│  ├─ Solo campo en BD cambia                             │
│  ├─ Sin notificación al usuario                         │
│  └─ NO genera UC, solo FR directo                       │
│                                                          │
│  Ejemplo:                                                │
│  "SI sesión >15 min inactiva ENTONCES marcar EXPIRADA"  │
│  → Solo campo 'estado' cambia ❌ NO observable          │
│  → FR-305 directo (sin UC)                              │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

**Test de Observabilidad:**

Para decidir si genera UC, pregúntate:

```
¿El resultado de esta BR es algo que un actor externo 
 puede VER, LEER, RECIBIR o PERCIBIR de alguna forma?

SÍ → DESENCADENADOR → Genera UC
NO  → INFERENCIA → Solo FR directo
```

### Ejemplo Principal: BR-IACT-031 ⭐

Este es el **ejemplo central de PARTE 2**, aparecerá en múltiples secciones.

```
BR-IACT-031 (DESENCADENADOR):
"SI una sesión lleva más de 12 minutos activa (desde last_activity)
 Y el usuario NO ha interactuado en los últimos 2 minutos
 ENTONCES el sistema envía una alerta al buzón interno del usuario
 indicando que la sesión expirará en 3 minutos si no hay actividad."

Tipo: Desencadenador (Trigger basado en tiempo)
Fuente: Política de Seguridad + CNST-009
Criticidad: Alta (Prevención de sesiones zombie)
Vigencia: Desde 2025-09-01
Frecuencia de evaluación: Cada minuto (APScheduler job)

Valores específicos:
  - Tiempo alerta: 12 minutos desde last_activity
  - Tiempo expiración: 15 minutos desde last_activity
  - Ventana de notificación: 3 minutos antes de expirar
  - Condición adicional: Sin interacción en últimos 2 minutos
```

**Análisis Paso a Paso:**

**PASO 1: Verificar que es Desencadenador**

✅ Tiene estructura IF-THEN
✅ Condición es temporal (tiempo transcurrido)
✅ Acción es notificar (comportamiento observable)
✅ Usuario RECIBE algo (mensaje en buzón)

**Conclusión:** Es Desencadenador → Genera UC

**PASO 2: Identificar Actor Primario**

```
¿Quién inicia el comportamiento?

Opciones:
  A) Usuario → ❌ NO, el usuario NO inicia la alerta
  B) Administrador → ❌ NO, no es acción administrativa
  C) Sistema (tiempo) → ✅ SÍ, se ejecuta automáticamente cada minuto

Actor Primario: Sistema (Scheduler/Tiempo)
Trigger: Cada minuto (cron job / APScheduler)
```

**PASO 3: Identificar Actores Secundarios**

```
¿Quién participa pero no inicia?

- Usuario con sesión activa (RECIBE la alerta) → Actor Secundario
- SessionMonitorService (valida condiciones) → Componente técnico (no actor)
- InternalMessageService (envía mensaje) → Componente técnico (no actor)

Actor Secundario: Usuario (recibe notificación)
```

**PASO 4: Identificar Stakeholders**

```
¿Quiénes se benefician y por qué?

Usuario:
  - Quiere aviso ANTES de perder su sesión
  - Quiere tiempo para guardar trabajo
  - Quiere poder extender sesión si necesita

Administrador:
  - Quiere reducir sesiones zombie
  - Quiere liberar recursos del servidor
  - Quiere mejorar seguridad

Seguridad:
  - Quiere cerrar sesiones inactivas automáticamente
  - Quiere reducir ventanas de ataque
  - Quiere cumplir política de timeout 15 min
```

**PASO 5: Construir UC Completo**

```
UC-IACT-07: Notificar Expiración Inminente de Sesión

═══════════════════════════════════════════════════════════
IDENTIFICACIÓN
═══════════════════════════════════════════════════════════

ID: UC-IACT-07
Nombre: Notificar Expiración Inminente de Sesión
Versión: 2.0.0
Módulo: MOD_Session
Derivado de: BR-IACT-031 (Desencadenador)
Prioridad: Alta
Complejidad: Media
Frecuencia: Continua (cada minuto para todas las sesiones)

═══════════════════════════════════════════════════════════
ACTORES
═══════════════════════════════════════════════════════════

Actor Primario:
  Sistema (Tiempo) - APScheduler job ejecutado cada minuto

Actores Secundarios:
  - Usuario con sesión activa (recibe notificación)
  - SessionMonitorService (valida condiciones técnicas)

Stakeholders e Intereses:
  - Usuario: Quiere aviso antes de perder sesión para no perder trabajo
  - Admin: Quiere reducir sesiones zombie y liberar recursos
  - Seguridad: Quiere cumplir política de timeout de 15 minutos

═══════════════════════════════════════════════════════════
CONTEXTO DE EJECUCIÓN
═══════════════════════════════════════════════════════════

Precondiciones:
  - APScheduler job configurado y activo
  - Existen sesiones en estado 'ACTIVA' en BD
  - Tabla user_sessions tiene índices en (estado, last_activity)
  - InternalMessageService está disponible

Trigger:
  Cada minuto en punto (0 segundos):
    - Cron expression: "0 * * * *"
    - APScheduler job ID: "session_expiration_check"
    - Timeout del job: 30 segundos

Garantías Mínimas:
  - Job se ejecuta incluso si hay errores parciales
  - Errores en una sesión no afectan otras sesiones
  - Logs de errores siempre se registran
  - Job no consume >500MB RAM ni >10% CPU

Garantías de Éxito:
  - Todas las sesiones elegibles reciben notificación
  - Timestamps actualizados correctamente
  - Auditoría completa registrada
  - No se envían duplicados en mismo minuto

═══════════════════════════════════════════════════════════
COMPORTAMIENTO - FLUJO NORMAL
═══════════════════════════════════════════════════════════

1. Sistema inicia job programado (cada minuto en punto)

   Contexto:
     - Timestamp actual: NOW()
     - Job ID: session_expiration_check
     - Inicio: {timestamp}

2. Sistema consulta sesiones que cumplen condiciones [BR-IACT-031]

   Query:
   SELECT 
     s.session_id,
     s.user_id,
     s.last_activity,
     s.created_at,
     TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) as minutos_inactivos,
     u.nombre,
     u.email
   FROM user_sessions s
   JOIN users u ON s.user_id = u.user_id
   WHERE s.estado = 'ACTIVA'
     AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) >= 12  -- >12 min
     AND TIMESTAMPDIFF(MINUTE, s.last_activity, NOW()) < 15   -- <15 min
     AND NOT EXISTS (
       SELECT 1 FROM session_notifications sn
       WHERE sn.session_id = s.session_id
         AND sn.notification_type = 'EXPIRATION_WARNING'
         AND sn.created_at > DATE_SUB(NOW(), INTERVAL 2 MINUTE)
     );

   Explicación de filtros:
     - estado = 'ACTIVA': Solo sesiones activas
     - >= 12 minutos: Condición de alerta (BR-IACT-031)
     - < 15 minutos: Aún no expirada
     - NOT EXISTS: Evitar duplicados (no notificada recientemente)

3. Sistema itera sobre cada sesión encontrada

   FOR EACH sesion IN sesiones_encontradas:
     Procesar individualmente (pasos 4-7)
   END FOR

   Paralelización: NO (secuencial para evitar race conditions)

4. Sistema calcula tiempo restante antes de expiración

   tiempo_restante = 15 - minutos_inactivos
   
   Ejemplo:
     - last_activity: 12.5 minutos atrás
     - tiempo_restante: 15 - 12.5 = 2.5 minutos
     - Redondeado: 3 minutos (hacia arriba para ser conservador)

5. Sistema compone mensaje de alerta

   Template:
   ───────────────────────────────────────────────────────
   🕐 ALERTA: Su sesión expirará pronto
   ───────────────────────────────────────────────────────
   
   Su sesión ha estado inactiva por {minutos_inactivos} minutos.
   
   ⚠️  Su sesión expirará en aproximadamente {tiempo_restante} 
       minutos si no realiza ninguna actividad.
   
   Para mantener su sesión activa:
   • Haga clic en cualquier parte del sistema
   • Actualice alguna página (F5)
   • O haga clic en el botón de abajo
   
   [Mantener Sesión Activa]
   
   Si su sesión expira:
   • Perderá cualquier trabajo no guardado
   • Deberá iniciar sesión nuevamente
   
   Hora actual: {timestamp_actual}
   Última actividad: {last_activity_timestamp}
   ───────────────────────────────────────────────────────

   Prioridad del mensaje: HIGH
   Expira automáticamente: Sí (cuando sesión se actualice o expire)

6. Sistema registra notificación en tabla session_notifications

   INSERT INTO session_notifications (
     session_id,
     notification_type,
     minutos_inactivos,
     tiempo_restante_minutos,
     created_at,
     enviada
   ) VALUES (
     {session_id},
     'EXPIRATION_WARNING',
     {minutos_inactivos},
     {tiempo_restante},
     NOW(),
     FALSE  -- se marca TRUE después de envío exitoso
   );

   Propósito: Evitar duplicados y tener auditoría

7. Sistema envía mensaje a buzón interno del usuario

   CALL InternalMessageService.send(
     recipient_user_id: {user_id},
     sender_user_id: NULL,  -- mensaje del sistema
     message_type: 'SESSION_ALERT',
     subject: 'ALERTA: Su sesión expirará pronto',
     body_text: {mensaje_compuesto},
     body_html: {mensaje_html_formateado},
     priority: 'HIGH',
     action_button: {
       label: 'Mantener Sesión Activa',
       action: 'EXTEND_SESSION',
       session_id: {session_id}
     },
     auto_expire_at: {timestamp_expiracion_sesion}
   );

   Si envío exitoso:
     UPDATE session_notifications
     SET enviada = TRUE, fecha_envio = NOW()
     WHERE notification_id = {notification_id};

8. Sistema registra evento en auditoría

   INSERT INTO audit_log (
     evento_tipo,
     session_id,
     user_id,
     descripcion,
     metadata_json,
     timestamp
   ) VALUES (
     'SESSION_EXPIRATION_WARNING',
     {session_id},
     {user_id},
     'Notificación de expiración enviada',
     JSON_OBJECT(
       'minutos_inactivos', {minutos_inactivos},
       'tiempo_restante', {tiempo_restante},
       'message_id', {message_id}
     ),
     NOW()
   );

9. Sistema continúa con siguiente sesión (volver a paso 3)

10. Sistema finaliza job exitosamente

    Logs finales:
      - Total sesiones procesadas: {count}
      - Notificaciones enviadas: {enviadas}
      - Errores: {errores}
      - Duración: {duracion_ms}ms
      - Próxima ejecución: {timestamp + 1 minuto}

═══════════════════════════════════════════════════════════
FLUJOS ALTERNOS
═══════════════════════════════════════════════════════════

FA-1: No Hay Sesiones que Cumplan Condiciones

  Punto de desviación: Paso 2
  
  2a. Query retorna 0 filas (ninguna sesión cumple condiciones)
  
  2b. Sistema registra en log:
      "No hay sesiones elegibles para notificación en esta ejecución"
  
  2c. Sistema incrementa contador de ejecuciones sin acción
  
  2d. UC termina exitosamente (no es error, es caso normal)
  
  Postcondición: Ningún mensaje enviado (comportamiento esperado)

FA-2: Sesión Ya Expiró Mientras se Procesaba (Race Condition)

  Punto de desviación: Paso 4
  
  4a. Sistema intenta calcular tiempo_restante
  
  4b. Sesión ya fue marcada como EXPIRADA por otro proceso
      (UC-IACT-08: Expirar Sesión Automáticamente)
  
  4c. Sistema detecta estado != 'ACTIVA' al refrescar
  
  4d. Sistema registra en log: "Sesión {session_id} expiró durante procesamiento"
  
  4e. Sistema OMITE esa sesión (no envía notificación)
  
  4f. Continuar con siguiente sesión (paso 9)
  
  Postcondición: Notificación NO enviada (correcto, sesión ya expiró)

FA-3: Error al Enviar Mensaje a Buzón Interno

  Punto de desviación: Paso 7
  
  7a. InternalMessageService.send() retorna error o excepción
  
  7b. Sistema captura error específico:
      - MessageQueueFull
      - RecipientNotFound
      - ServiceUnavailable
      - NetworkTimeout
  
  7c. Sistema NO marca notificación como enviada (enviada = FALSE)
  
  7d. Sistema registra error detallado:
      INSERT INTO error_log (
        error_type,
        session_id,
        user_id,
        error_message,
        stack_trace,
        timestamp,
        retry_scheduled
      ) VALUES (
        'MESSAGE_SEND_FAILED',
        {session_id},
        {user_id},
        {error_message},
        {stack_trace},
        NOW(),
        TRUE  -- se reintentará en siguiente ejecución
      );
  
  7e. Sistema NO detiene el job (continúa con otras sesiones)
  
  7f. Continuar con siguiente sesión (paso 9)
  
  Postcondición: 
    - Sesión sigue elegible para siguiente ejecución
    - Error registrado para debugging
    - Otras sesiones NO afectadas

FA-4: Usuario Extendió Sesión Justo Antes de Notificación

  Punto de desviación: Paso 2
  
  2a. Usuario realizó actividad entre query y envío de mensaje
  
  2b. last_activity se actualizó a timestamp reciente
  
  2c. Sesión ya no cumple condición >= 12 minutos
  
  2d. Sistema NO envía notificación (porque ya no aplica)
  
  2e. Sistema registra: "Sesión {session_id} actualizó actividad, omitiendo"
  
  2f. UC termina para esa sesión (comportamiento correcto)
  
  Postcondición: Sin notificación (usuario ya está activo)

FA-5: Límite de Notificaciones Excedido para Usuario

  Punto de desviación: Paso 6
  
  6a. Sistema verifica cuántas notificaciones envió al usuario hoy
  
  6b. COUNT(*) > 50 (límite diario de alertas por usuario)
  
  6c. Sistema deniega envío para evitar spam
  
  6d. Sistema registra: "Usuario {user_id} excedió límite diario de alertas"
  
  6e. Sistema marca sesión para expiración inmediata:
      UPDATE user_sessions
      SET estado = 'EXPIRED_NO_NOTIFICATION'
      WHERE session_id = {session_id};
  
  6f. Sistema notifica al administrador de sesión anómala
  
  6g. Continuar con siguiente sesión
  
  Postcondición: Sesión expirada sin notificación (protección anti-spam)

FA-6: Job Excede Timeout de 30 Segundos

  Punto de desviación: Durante cualquier paso
  
  *a. APScheduler detecta que job lleva >30 segundos ejecutándose
  
  *b. Scheduler fuerza terminación del job (kill)
  
  *c. Sistema registra alarma crítica:
      INSERT INTO system_alerts (
        alert_type,
        severity,
        description,
        timestamp
      ) VALUES (
        'JOB_TIMEOUT',
        'CRITICAL',
        'session_expiration_check excedió timeout de 30s',
        NOW()
      );
  
  *d. Sistema envía alerta a on-call engineer
  
  *e. Sistema investiga causa:
      - Muchas sesiones concurrentes?
      - Query lento (índices faltantes)?
      - BD sobrecargada?
  
  *f. UC termina parcialmente (solo sesiones procesadas hasta timeout)
  
  Postcondición: 
    - Algunas sesiones notificadas, otras pendientes
    - Alerta crítica activa para revisión
    - Próxima ejecución intentará sesiones faltantes

═══════════════════════════════════════════════════════════
RESULTADO
═══════════════════════════════════════════════════════════

Postcondiciones de Éxito (Flujo Normal):

  - Usuarios con sesiones elegibles recibieron notificación HIGH priority
  - Tabla session_notifications actualizada (enviada = TRUE)
  - Auditoría completa registrada para cada notificación
  - Usuarios tienen 3 minutos para reaccionar antes de expiración
  - Sin duplicados (gracias a EXISTS check en query)
  - Job completado en <30 segundos

Postcondiciones Parciales (Flujos Alternos):

  - FA-1: Sin sesiones procesadas (comportamiento normal)
  - FA-2: Sesión expiró, notificación omitida correctamente
  - FA-3: Error registrado, sesión reintentará en siguiente ejecución
  - FA-4: Usuario activo, notificación innecesaria no enviada
  - FA-5: Protección anti-spam activada, sesión expirada
  - FA-6: Alarma crítica generada, investigación requerida

═══════════════════════════════════════════════════════════
METADATOS Y TRAZABILIDAD
═══════════════════════════════════════════════════════════

Business Rules Aplicadas:
  
  BR-IACT-031: Notificar si >12 min inactiva (DESENCADENADOR principal)
    → Ubicación: Paso 2 (query con filtro >= 12)
    → Genera todo el UC

Casos de Uso Relacionados:

  UC-IACT-08: Expirar Sesión Automáticamente
    → Se ejecuta 3 minutos después si usuario no reacciona
    → Marca sesión como EXPIRADA
  
  UC-IACT-03: Extender Sesión Manualmente
    → Usuario puede invocar desde botón en notificación
    → Actualiza last_activity a NOW()

Functional Requirements Derivados (9 FR):

  FR-301: Consultar Sesiones Elegibles para Notificación
  FR-302: Calcular Tiempo Restante Antes de Expiración
  FR-303: Componer Mensaje de Alerta Personalizado
  FR-304: Registrar Notificación en session_notifications
  FR-305: Enviar Mensaje a Buzón Interno con Prioridad
  FR-306: Registrar Evento en Auditoría
  FR-307: Evitar Duplicados en Ventana de 2 Minutos
  FR-308: Manejar Errores sin Detener Job Completo
  FR-309: Generar Alarma si Job Excede Timeout

Métricas de Performance:

  - Query paso 2: <100ms (con índices correctos)
  - Composición mensaje: <10ms por sesión
  - Envío a buzón: <50ms por mensaje
  - Total por sesión: ~150ms
  - Capacidad: ~200 sesiones en 30 segundos
  - Uso RAM: ~100MB durante ejecución
  - Uso CPU: ~5% (single-threaded)

Configuración de Scheduler:

  # APScheduler configuration
  scheduler.add_job(
    func=notificar_expiracion_sesion,
    trigger='cron',
    minute='*',              # Cada minuto
    second='0',              # En punto (0 segundos)
    id='session_expiration_check',
    replace_existing=True,
    max_instances=1,         # Solo una instancia a la vez
    misfire_grace_time=30,   # Si falla, no compensar
    coalesce=True            # Unir ejecuciones perdidas
  )

Índices de BD Requeridos:

  CREATE INDEX idx_sessions_expiration_check
    ON user_sessions(estado, last_activity)
    WHERE estado = 'ACTIVA';

  CREATE INDEX idx_session_notifications_recent
    ON session_notifications(session_id, notification_type, created_at);

Testing:

  Casos de Prueba Mínimos:
    1. Sesión con 12.5 min inactiva → Recibe notificación
    2. Sesión con 11 min inactiva → NO recibe notificación
    3. Sesión con 16 min inactiva → Ya expirada, NO recibe
    4. Usuario con múltiples sesiones → Solo sesiones elegibles
    5. Sin sesiones activas → Job termina sin error
    6. Error en mensaje → Job continúa con otras sesiones
    7. Notificación reciente (<2 min) → NO duplicar

═══════════════════════════════════════════════════════════
```

### Ejemplo Adicional: BR-IACT-033

```
BR-IACT-033 (DESENCADENADOR):
"SI un permiso temporal expirará en menos de 24 horas
 Y el usuario tiene funciones críticas asignadas temporalmente
 ENTONCES notificar al usuario Y al administrador que asignó
 para decidir si renovar o revocar."

Tipo: Desencadenador
Observable: Usuario y Admin RECIBEN notificaciones
Genera: UC-IACT-09: Notificar Vencimiento de Permiso Temporal

Diferencias con UC-IACT-07:
  - Condición: <24h (vs >12 min)
  - Dual recipient: Usuario Y Admin (vs solo Usuario)
  - Requiere decisión: Renovar/Revocar (vs solo Extender)
  - Criticidad: Solo para funciones críticas (vs todas las sesiones)
```

### Plantilla para Construir UC desde Desencadenador

Cuando encuentres un Desencadenador, sigue estos pasos:

```
PASO 1: Verificar Estructura IF-THEN
  ¿Tiene condición temporal o de estado? → SÍ
  ¿Tiene acción observable? → SÍ
  → Es Desencadenador

PASO 2: Identificar Actor Primario
  ¿Quién INICIA el comportamiento?
  → Sistema (Tiempo/Scheduler) en mayoría de casos

PASO 3: Identificar Actor Secundario
  ¿Quién RECIBE el resultado observable?
  → Usuario, Admin, otro rol

PASO 4: Construir UC con estructura:
  
  PRECONDICIONES:
    - Scheduler configurado
    - Existen entidades en estado elegible
    - Servicios dependientes disponibles
  
  FLUJO NORMAL:
    1. Sistema inicia job (trigger temporal)
    2. Sistema consulta entidades elegibles (WHERE condición)
    3. Sistema itera sobre cada entidad
    4. Sistema calcula/prepara resultado
    5. Sistema compone mensaje/notificación
    6. Sistema envía a actor secundario
    7. Sistema registra en auditoría
    8. Sistema continúa con siguiente entidad
  
  FLUJOS ALTERNOS:
    - No hay entidades elegibles (caso normal)
    - Error al enviar (no detiene job)
    - Entidad cambió estado durante procesamiento
    - Timeout del job

PASO 5: Derivar FR
  - FR para query de entidades elegibles
  - FR para cálculo/preparación
  - FR para composición de mensaje
  - FR para envío
  - FR para auditoría
  - FR para manejo de errores
```

### Resumen del Patrón Desencadenadores

```
┌────────────────────────────────────────────────────┐
│  PATRÓN 3: DESENCADENADORES → UC COMPLETO ⭐       │
├────────────────────────────────────────────────────┤
│                                                    │
│  ENTRADA:  BR de tipo DESENCADENADOR               │
│            Comportamiento observable automático    │
│                                                    │
│  VERIFICACIÓN CLAVE:                               │
│    ¿El resultado es OBSERVABLE por actor externo?  │
│    SÍ → DESENCADENADOR (genera UC)                 │
│    NO → INFERENCIA (solo FR)                       │
│                                                    │
│  PROCESO:  1. Verificar estructura IF-THEN         │
│            2. Identificar actor primario (Sistema) │
│            3. Identificar actor secundario         │
│            4. Construir UC completo 12 componentes │
│            5. Configurar scheduler/cron            │
│            6. Derivar 5-10 FR                      │
│                                                    │
│  SALIDA:   UC completo e independiente             │
│            Job programado (APScheduler)            │
│            FR derivados de pasos                   │
│            Configuración de infraestructura        │
│                                                    │
│  GENERA: Caso de Uso COMPLETO ⭐                   │
│                                                    │
│  TRAZABILIDAD: BR → UC (1:1) → FR (1:N)            │
│                                                    │
│  ÚNICO PATRÓN QUE GENERA UC INDEPENDIENTE          │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 3.4 Patrón 4: Inferencias → FR Directo (Sin UC)

### Principio Fundamental

> **Las Inferencias NO generan Casos de Uso porque describen cambios internos NO observables. Generan Functional Requirements directos.**

Una Inferencia describe:
- Cambio automático de estado/campo en BD
- Basado en condición o regla lógica
- SIN interacción con actor externo
- SIN notificación observable
- Es "transparente" para el usuario

### Diferencia Crítica con Desencadenadores (Repetición Intencional)

**ESTA ES LA DISTINCIÓN MÁS CONFUSA Y MÁS IMPORTANTE:**

```
┌───────────────────────────────────────────────────────┐
│  DESENCADENADOR: "Usuario RECIBE algo"               │
│                                                       │
│  BR-IACT-031:                                         │
│  "SI sesión >12 min                                   │
│   ENTONCES enviar alerta al usuario"                 │
│                                                       │
│  → Usuario VE mensaje en buzón ✅                    │
│  → Genera UC-IACT-07                                 │
│                                                       │
├───────────────────────────────────────────────────────┤
│                                                       │
│  INFERENCIA: "Solo campo BD cambia"                  │
│                                                       │
│  BR-IACT-046:                                         │
│  "SI sesión >15 min inactividad                      │
│   ENTONCES marcar estado como EXPIRADA"             │
│                                                       │
│  → Solo campo 'estado' cambia ❌                     │
│  → NO genera UC, solo FR-305                         │
│                                                       │
└───────────────────────────────────────────────────────┘
```

**Test Visual Rápido:**

```
Pregunta: ¿Si un usuario estuviera mirando la pantalla,
          VERÍA o PERCIBIRÍA que esta BR se ejecutó?

Ejemplo 1 (Desencadenador):
  Sesión > 12 min → Enviar alerta
  
  Usuario ve: ✅ Mensaje nuevo en buzón "Su sesión expirará"
  → DESENCADENADOR → UC

Ejemplo 2 (Inferencia):
  Sesión > 15 min → Marcar EXPIRADA
  
  Usuario ve: ❌ Nada (solo cuando intenta siguiente acción)
  → INFERENCIA → FR directo
```

### Ejemplo Principal: BR-IACT-046

```
BR-IACT-046 (INFERENCIA):
"SI una sesión tiene más de 15 minutos de inactividad 
 (TIMESTAMPDIFF(MINUTE, last_activity, NOW()) > 15)
 ENTONCES el sistema marca automáticamente su estado como 'EXPIRADA'
 sin enviar notificación adicional."

Tipo: Inferencia (Cambio de estado automático)
Fuente: Política de Seguridad + CNST-009
Criticidad: Alta
Vigencia: Desde 2025-09-01
Frecuencia: Verificación continua (mismo job que BR-IACT-031)

Diferencia con BR-IACT-031:
  - BR-IACT-031 (Desencadenador): NOTIFICA a usuario (observable)
  - BR-IACT-046 (Inferencia): Solo CAMBIA estado (no observable)
```

**Análisis Paso a Paso:**

**PASO 1: Verificar que es Inferencia**

✅ Tiene estructura IF-THEN
✅ Condición es temporal
❌ Acción NO es observable (solo UPDATE interno)
❌ Usuario NO recibe nada

**Conclusión:** Es Inferencia → NO genera UC → Solo FR directo

**PASO 2: Identificar qué Cambia**

```
Campo afectado: user_sessions.estado
Valor anterior: 'ACTIVA'
Valor nuevo: 'EXPIRADA'

Trigger de cambio:
  TIMESTAMPDIFF(MINUTE, last_activity, NOW()) > 15

Momento del cambio:
  Inmediatamente al cumplirse condición
  (verificado por mismo job que BR-IACT-031)
```

**PASO 3: NO Buscar Actor (No aplica)**

Las Inferencias NO tienen actor porque:
- No hay interacción
- Es proceso interno
- No hay "quién recibe"

**PASO 4: Derivar FR Directo**

En lugar de UC, creamos directamente el FR:

```
FR-305: Expirar Sesión Automáticamente por Inactividad

═══════════════════════════════════════════════════════════
IDENTIFICACIÓN
═══════════════════════════════════════════════════════════

ID: FR-305
Nombre: Expirar Sesión Automáticamente por Inactividad
Tipo: Functional Requirement (Automatismo)
Módulo: MOD_Session
Derivado de: BR-IACT-046 (Inferencia)
Prioridad: Alta
Complejidad: Baja

═══════════════════════════════════════════════════════════
DESCRIPCIÓN
═══════════════════════════════════════════════════════════

Sistema debe marcar automáticamente como EXPIRADA cualquier sesión
que tenga más de 15 minutos de inactividad (sin interacción del usuario).

Este cambio ocurre internamente sin notificación al usuario. La expiración
se detectará cuando el usuario intente realizar su próxima acción.

Diferencia con BR-IACT-031:
  - BR-IACT-031 notifica a los 12 min (DESENCADENADOR → UC-IACT-07)
  - BR-IACT-046 expira a los 15 min (INFERENCIA → FR-305)

═══════════════════════════════════════════════════════════
REGLA DE NEGOCIO IMPLEMENTADA
═══════════════════════════════════════════════════════════

BR-IACT-046:
  "SI TIMESTAMPDIFF(MINUTE, last_activity, NOW()) > 15
   ENTONCES estado := 'EXPIRADA'"

Condición precisa:
  - last_activity: Timestamp de última interacción del usuario
  - NOW(): Timestamp actual del servidor
  - Umbral: 15 minutos (900 segundos)
  - No hay margen: exactamente >15 min

═══════════════════════════════════════════════════════════
IMPLEMENTACIÓN
═══════════════════════════════════════════════════════════

Método de Ejecución:
  
  Forma 1: En mismo job de BR-IACT-031 (Recomendado)
  
    # Dentro de session_expiration_check job
    # Después de notificaciones (UC-IACT-07)
    
    expire_inactive_sessions()

  Forma 2: Consulta SQL directa periódica
  
    Ejecutada cada minuto, después de notificaciones

Query de Expiración:

  UPDATE user_sessions
  SET 
    estado = 'EXPIRADA',
    expired_at = NOW(),
    expiration_reason = 'INACTIVITY_TIMEOUT'
  WHERE estado = 'ACTIVA'
    AND TIMESTAMPDIFF(MINUTE, last_activity, NOW()) > 15;

  -- Retorna: Cantidad de sesiones expiradas

Índice Requerido:
  
  CREATE INDEX idx_sessions_inactivity
    ON user_sessions(estado, last_activity)
    WHERE estado = 'ACTIVA';

Performance Esperada:
  - Query: <50ms
  - Típicamente: 0-20 sesiones por minuto
  - Sin notificaciones (solo UPDATE)

Auditoría:

  INSERT INTO audit_log (
    evento_tipo,
    session_id,
    user_id,
    descripcion,
    metadata_json,
    timestamp
  )
  SELECT 
    'SESSION_EXPIRED_AUTO',
    session_id,
    user_id,
    'Sesión expirada por inactividad >15 min',
    JSON_OBJECT(
      'minutos_inactivos', TIMESTAMPDIFF(MINUTE, last_activity, NOW()),
      'expiration_reason', 'INACTIVITY_TIMEOUT'
    ),
    NOW()
  FROM user_sessions
  WHERE session_id IN (
    {sesiones_recien_expiradas}
  );

═══════════════════════════════════════════════════════════
MANEJO DE EXPIRACIÓN POR USUARIO
═══════════════════════════════════════════════════════════

Cuando usuario intenta acción con sesión EXPIRADA:

  Middleware detecta:
    IF session.estado == 'EXPIRADA':
      - Limpiar session_id de cookies
      - Redirect a /login
      - Mostrar mensaje:
        "Su sesión expiró por inactividad. Por favor inicie sesión nuevamente."
      - Preservar URL destino para post-login redirect

No es Observable Inmediatamente:
  - Usuario NO recibe notificación cuando expira
  - Solo se entera al intentar siguiente acción
  - Es un "fail-fast" en próxima interacción

═══════════════════════════════════════════════════════════
INTERACCIÓN CON OTROS COMPONENTES
═══════════════════════════════════════════════════════════

Relación con UC-IACT-07 (Notificación a 12 min):

  Timeline:
    
    0 min ──────────────────────────────────────────
              │
              │ Usuario activo
              │
    12 min ───┼───> BR-IACT-031: Notificar (UC-IACT-07) ✅
              │     Usuario RECIBE alerta en buzón
              │     Tiene 3 minutos para reaccionar
              │
    15 min ───┼───> BR-IACT-046: Expirar (FR-305) ❌
              │     estado := 'EXPIRADA'
              │     Usuario NO recibe nada nuevo
              │     Descubrirá al siguiente clic
              ▼

Secuencia Completa:

  1. Usuario inactivo por 12 minutos
     → BR-IACT-031 (DESENCADENADOR) ejecuta
     → UC-IACT-07 se ejecuta
     → Usuario RECIBE notificación
  
  2. Usuario NO reacciona
  
  3. Usuario inactivo por 15 minutos
     → BR-IACT-046 (INFERENCIA) ejecuta
     → FR-305 se ejecuta
     → estado cambia a EXPIRADA
     → Sin notificación adicional
  
  4. Usuario intenta siguiente acción
     → Middleware detecta estado = EXPIRADA
     → Redirect a login
     → Usuario AHORA se entera

Si Usuario Reacciona a Tiempo:

  Si usuario hace clic en "Mantener Sesión" entre min 12-15:
    - UC-IACT-03: Extender Sesión se ejecuta
    - last_activity se actualiza a NOW()
    - Sesión ya no cumple condición > 15 min
    - FR-305 NO expira esa sesión
    - Ciclo reinicia

═══════════════════════════════════════════════════════════
CASOS DE PRUEBA
═══════════════════════════════════════════════════════════

CP-1: Expiración Normal
  Precondición: Sesión ACTIVA con last_activity hace 16 min
  Acción: Ejecutar FR-305
  Resultado: estado = 'EXPIRADA', expired_at = NOW()

CP-2: Sesión Dentro de Umbral
  Precondición: Sesión ACTIVA con last_activity hace 14 min
  Acción: Ejecutar FR-305
  Resultado: estado permanece 'ACTIVA' (no expira)

CP-3: Sesión Ya Expirada
  Precondición: Sesión con estado = 'EXPIRADA'
  Acción: Ejecutar FR-305
  Resultado: No cambia (UPDATE WHERE no la incluye)

CP-4: Usuario Reactiva Justo a Tiempo
  Precondición: Sesión last_activity hace 15.5 min
  Acción: Usuario hace clic → last_activity = NOW()
           Antes de que FR-305 ejecute
  Resultado: Sesión NO expira (last_activity actualizado)

CP-5: Múltiples Sesiones del Mismo Usuario
  Precondición: Usuario tiene 3 sesiones:
                - Sesión A: last_activity 10 min
                - Sesión B: last_activity 16 min
                - Sesión C: last_activity 20 min
  Acción: Ejecutar FR-305
  Resultado: Solo B y C expiradas, A permanece ACTIVA

CP-6: Sesión Expirada Manualmente Antes
  Precondición: Admin ejecutó UC-IACT-10: Cerrar Sesión Remota
                Estado ya es 'CERRADA_POR_ADMIN'
  Acción: FR-305 ejecuta
  Resultado: No afecta (WHERE estado = 'ACTIVA' no la incluye)

═══════════════════════════════════════════════════════════
CONFIGURACIÓN Y MONITOREO
═══════════════════════════════════════════════════════════

Parámetros Configurables:

  # En settings.py o config
  SESSION_INACTIVITY_TIMEOUT = 15  # minutos
  
  # Permitir override por tipo de usuario (futuro)
  SESSION_TIMEOUT_BY_ROLE = {
    'superusuario': 30,      # 30 min para superusuarios
    'admin_acceso': 20,      # 20 min para admins
    'usuario_regular': 15    # 15 min para usuarios normales
  }

Métricas a Monitorear:

  - sessions_expired_count: Cantidad por minuto
  - avg_session_duration: Duración promedio antes de expirar
  - sessions_active_peak: Pico de sesiones activas simultáneas
  - expiration_rate: % de sesiones que expiran vs cierres normales

Alertas:

  IF sessions_expired_count > 100 en 1 minuto THEN
    Alerta: "Tasa anormal de expiración de sesiones"
    Posible causa: Problema de red, BD lenta, bug en actualizaciones

═══════════════════════════════════════════════════════════
TRAZABILIDAD
═══════════════════════════════════════════════════════════

Derivado de:
  BR-IACT-046 (INFERENCIA) → FR-305 (directo, sin UC intermedio)

Integrado en:
  Ningún UC (es automatismo independiente)

Utilizado por:
  - SessionMiddleware (detecta estado EXPIRADA)
  - UC-IACT-01: Iniciar Sesión (limpia sesiones expiradas previas)
  - UC-IACT-02: Cerrar Sesión (no aplica si ya EXPIRADA)

Relacionado con:
  - UC-IACT-07: Notificar Expiración (3 min antes de FR-305)
  - UC-IACT-03: Extender Sesión (previene FR-305)
  - UC-IACT-10: Cerrar Sesión Remota (alternativa manual)

═══════════════════════════════════════════════════════════
```

### Ejemplo Adicional: BR-IACT-052

```
BR-IACT-052 (INFERENCIA):
"SI un usuario no tiene funciones asignadas (user_functions = ∅)
 Y ha pasado más de 7 días desde su creación
 ENTONCES marcar su estado como 'INACTIVO' automáticamente."

Tipo: Inferencia
Observable: NO (solo campo estado cambia)
Genera: FR-402 directo (sin UC)

Implementación:

  FR-402: Marcar Usuarios Sin Funciones como Inactivos

  UPDATE users
  SET 
    estado = 'INACTIVO',
    inactivated_at = NOW(),
    inactivation_reason = 'NO_FUNCTIONS_ASSIGNED'
  WHERE estado = 'ACTIVO'
    AND user_id NOT IN (
      SELECT DISTINCT user_id FROM user_functions
    )
    AND DATEDIFF(NOW(), created_at) > 7;

  Sin notificación, sin UC, solo cambio automático.
```

### Cuándo una Inferencia SÍ Aparece en UC

Aunque las Inferencias no generan UC, SÍ aparecen en UC existentes como **postcondiciones**:

```
Ejemplo: UC-IACT-04 (Asignar Funciones)

POSTCONDICIONES:
  ...
  - Permisos efectivos del usuario actualizados [BR-IACT-046]
    (Este es el resultado de una INFERENCIA integrada)
```

La Inferencia describe CÓMO se actualiza (automáticamente, sin notificación), pero dentro del contexto de un UC más grande.

### Plantilla para Manejar Inferencias

```
PASO 1: Identificar que es Inferencia
  ¿Tiene IF-THEN? → SÍ
  ¿Resultado observable? → NO
  → Es Inferencia

PASO 2: NO crear UC
  Inferencias NO generan UC independientes

PASO 3: Crear FR directo con estructura:
  
  FR-XXX: [Verbo] [Entidad] Automáticamente
  
  Descripción:
    - Qué campo cambia
    - Condición exacta
    - Query SQL UPDATE/INSERT
    - Sin interacción de usuario
  
  Implementación:
    - Query directo
    - Trigger de BD (alternativa)
    - Job programado
  
  Casos de prueba:
    - Condición cumplida → Cambio ocurre
    - Condición no cumplida → Sin cambio
    - Edge cases

PASO 4: Documentar en Trazabilidad
  BR → FR (sin UC intermedio)

PASO 5: Si aplica, agregar como Postcondición
  En UC que ejecuta la acción relacionada
```

### Resumen del Patrón Inferencias

```
┌────────────────────────────────────────────────────┐
│  PATRÓN 4: INFERENCIAS → FR DIRECTO (Sin UC)       │
├────────────────────────────────────────────────────┤
│                                                    │
│  ENTRADA:  BR de tipo INFERENCIA                   │
│            Cambio interno NO observable            │
│                                                    │
│  VERIFICACIÓN CLAVE:                               │
│    ¿El resultado es OBSERVABLE por actor externo?  │
│    NO → INFERENCIA (solo FR)                       │
│    SÍ → DESENCADENADOR (genera UC)                 │
│                                                    │
│  PROCESO:  1. Identificar qué campo cambia         │
│            2. Identificar condición exacta         │
│            3. NO buscar actor (no aplica)          │
│            4. Crear FR directo (sin UC)            │
│            5. Implementar como UPDATE/Trigger      │
│                                                    │
│  SALIDA:   FR directo con Query SQL                │
│            Sin UC intermedio                       │
│            Posible Trigger de BD                   │
│                                                    │
│  NO GENERA: Caso de Uso                            │
│                                                    │
│  PUEDE APARECER EN: Postcondición de UC existente  │
│                                                    │
│  TRAZABILIDAD: BR → FR (directo, 1:1)              │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 3.5 Patrón 5: Cálculos → Integración en Pasos de UC

### Principio Fundamental

> **Los Cálculos NO generan Casos de Uso independientes. Se integran como pasos dentro de UC existentes o como FR con algoritmo.**

Un Cálculo describe:
- Fórmula o algoritmo para derivar valor
- Típicamente usa múltiples inputs
- Produce un output numérico o categórico
- Se ejecuta DENTRO de un proceso más grande
- No tiene valor por sí solo (necesita contexto)

### Ejemplo Principal: BR-IACT-060

```
BR-IACT-060 (CÁLCULO):
"El score de riesgo de acceso se calcula como:

 score_riesgo = (cantidad_funciones_criticas × 25) +
                (cantidad_permisos_totales × 2) +
                (nivel_seguridad_usuario × -10) +
                (dias_desde_ultima_auditoria × 0.5)

 Rangos:
   0-40: BAJO
   41-70: MEDIO
   71-85: ALTO
   86-100: CRÍTICO

 El score se recalcula cada vez que se asignan/revocan funciones
 y determina si se requiere aprobación adicional."

Tipo: Cálculo (Fórmula con múltiples variables)
Fuente: Política de Seguridad + Análisis de Riesgo
Criticidad: Alta (afecta flujo de aprobación)
Vigencia: Desde 2025-10-15
```

**Análisis Paso a Paso:**

**PASO 1: Verificar que es Cálculo**

✅ Es fórmula matemática
✅ Tiene múltiples inputs
✅ Produce output (score_riesgo)
❌ NO describe comportamiento completo
❌ NO tiene valor aislado (necesita contexto de UC)

**Conclusión:** Es Cálculo → NO genera UC → Se integra en UC existente

**PASO 2: Identificar UC donde se Integra**

```
¿Dónde se usa este cálculo?

UC-IACT-04: Asignar Funciones a Usuario
  → Se calcula score ANTES de asignar
  → Determina si requiere aprobación
  → Se integra en PASO 6 del flujo

UC-IACT-06: Revocar Funciones
  → Se recalcula score DESPUÉS de revocar
  → Actualiza nivel de riesgo del usuario

UC-IACT-11: Generar Reporte de Auditoría
  → Se calcula para todos los usuarios
  → Identifica usuarios en riesgo ALTO/CRÍTICO
```

**PASO 3: Integrar como Paso en UC**

Ya vimos esto en UC-IACT-04:

```
UC-IACT-04: Asignar Funciones a Usuario

Flujo Normal:
  ...
  6. Sistema calcula score de riesgo de acceso [BR-IACT-060]
     
     Inputs:
       - cantidad_funciones_criticas: COUNT where es_critica = TRUE
       - cantidad_permisos_totales: COUNT from permissions_cache
       - nivel_seguridad_usuario: users.nivel_seguridad
       - dias_desde_ultima_auditoria: DATEDIFF(NOW(), last_audit_date)
     
     Formula:
       score_riesgo = (func_criticas × 25) +
                      (permisos × 2) +
                      (nivel_seg × -10) +
                      (dias_audit × 0.5)
     
     Clasificación:
       IF score_riesgo < 41 THEN categoria = 'BAJO'
       ELSIF score_riesgo < 71 THEN categoria = 'MEDIO'
       ELSIF score_riesgo < 86 THEN categoria = 'ALTO'
       ELSE categoria = 'CRÍTICO'
     
     Persistir:
       UPDATE users
       SET 
         risk_score = score_riesgo,
         risk_category = categoria,
         risk_calculated_at = NOW()
       WHERE user_id = {user_id};
  
  7. Sistema verifica si score > 85 (umbral crítico)
     
     IF score_riesgo > 85 THEN
       Ir a FA-5: Score de Riesgo Excede Umbral
     END IF
  ...
```

**PASO 4: Derivar FR del Cálculo**

```
FR-601: Calcular Score de Riesgo de Acceso

═══════════════════════════════════════════════════════════
IDENTIFICACIÓN
═══════════════════════════════════════════════════════════

ID: FR-601
Nombre: Calcular Score de Riesgo de Acceso
Tipo: Functional Requirement (Algoritmo de Cálculo)
Módulo: MOD_Access
Derivado de: BR-IACT-060 (Cálculo)
Usado en: UC-IACT-04 (Paso 6), UC-IACT-06, UC-IACT-11
Prioridad: Alta
Complejidad: Media

═══════════════════════════════════════════════════════════
FÓRMULA COMPLETA
═══════════════════════════════════════════════════════════

score_riesgo = (cantidad_funciones_criticas × 25) +
               (cantidad_permisos_totales × 2) +
               (nivel_seguridad_usuario × -10) +
               (dias_desde_ultima_auditoria × 0.5)

Donde:
  - cantidad_funciones_criticas: INT [0, 44]
      COUNT de funciones con es_critica = TRUE
  
  - cantidad_permisos_totales: INT [0, ∞)
      COUNT de permisos efectivos (cache)
  
  - nivel_seguridad_usuario: INT [1, 5]
      Campo users.nivel_seguridad
      (Factor negativo: más nivel = menos riesgo)
  
  - dias_desde_ultima_auditoria: INT [0, ∞)
      DATEDIFF(NOW(), users.last_audit_date)
      Si NULL: usar 365 días (penalizar nunca auditado)

Rango del Score: [0, 100] (forzado)
  Si resultado < 0: ajustar a 0
  Si resultado > 100: ajustar a 100

═══════════════════════════════════════════════════════════
CLASIFICACIÓN
═══════════════════════════════════════════════════════════

Categorías de Riesgo:

  BAJO (0-40):
    - Usuarios con pocas funciones
    - Nivel seguridad alto
    - Recientemente auditados
    - Requiere: Aprobación estándar
  
  MEDIO (41-70):
    - Usuarios con funciones moderadas
    - Nivel seguridad medio
    - Auditoría hace 3-6 meses
    - Requiere: Aprobación estándar + revisión
  
  ALTO (71-85):
    - Usuarios con múltiples funciones críticas
    - Nivel seguridad bajo
    - Auditoría hace >6 meses
    - Requiere: Aprobación de auditor
  
  CRÍTICO (86-100):
    - Usuarios con alto número de funciones críticas
    - Nivel seguridad insuficiente
    - Sin auditoría reciente
    - Requiere: Aprobación doble (Auditor + Superusuario)

Lógica de Clasificación:

  FUNCTION classify_risk(score):
    IF score < 41 THEN RETURN 'BAJO'
    ELSIF score < 71 THEN RETURN 'MEDIO'
    ELSIF score < 86 THEN RETURN 'ALTO'
    ELSE RETURN 'CRÍTICO'
    END IF
  END FUNCTION

═══════════════════════════════════════════════════════════
IMPLEMENTACIÓN SQL
═══════════════════════════════════════════════════════════

Query para un usuario específico:

  SELECT 
    u.user_id,
    u.nombre,
    
    -- Inputs del cálculo
    COUNT(DISTINCT CASE WHEN f.es_critica = TRUE THEN uf.function_id END) as func_criticas,
    COUNT(DISTINCT pc.permission_id) as permisos_totales,
    u.nivel_seguridad,
    COALESCE(DATEDIFF(NOW(), u.last_audit_date), 365) as dias_audit,
    
    -- Fórmula
    (
      (COUNT(DISTINCT CASE WHEN f.es_critica = TRUE THEN uf.function_id END) * 25) +
      (COUNT(DISTINCT pc.permission_id) * 2) +
      (u.nivel_seguridad * -10) +
      (COALESCE(DATEDIFF(NOW(), u.last_audit_date), 365) * 0.5)
    ) as score_calculado,
    
    -- Clasificación
    CASE
      WHEN (
        (COUNT(DISTINCT CASE WHEN f.es_critica = TRUE THEN uf.function_id END) * 25) +
        (COUNT(DISTINCT pc.permission_id) * 2) +
        (u.nivel_seguridad * -10) +
        (COALESCE(DATEDIFF(NOW(), u.last_audit_date), 365) * 0.5)
      ) < 41 THEN 'BAJO'
      WHEN (...) < 71 THEN 'MEDIO'
      WHEN (...) < 86 THEN 'ALTO'
      ELSE 'CRÍTICO'
    END as categoria_riesgo
    
  FROM users u
  LEFT JOIN user_functions uf ON u.user_id = uf.user_id
  LEFT JOIN functions f ON uf.function_id = f.function_id
  LEFT JOIN permissions_cache pc ON u.user_id = pc.user_id
  WHERE u.user_id = ?
  GROUP BY u.user_id, u.nombre, u.nivel_seguridad, u.last_audit_date;

Performance:
  - Con índices: <100ms
  - Sin índices: Hasta 2s (inaceptable)

Índices Requeridos:
  CREATE INDEX idx_user_functions_critical 
    ON user_functions(user_id, function_id);
  
  CREATE INDEX idx_functions_critical 
    ON functions(function_id, es_critica);
  
  CREATE INDEX idx_permissions_cache_user 
    ON permissions_cache(user_id);

═══════════════════════════════════════════════════════════
IMPLEMENTACIÓN PYTHON
═══════════════════════════════════════════════════════════

Función reutilizable:

  from datetime import datetime, timedelta
  from typing import Dict
  
  def calculate_risk_score(user_id: int) -> Dict[str, any]:
      """
      Calcula score de riesgo según BR-IACT-060.
      
      Args:
          user_id: ID del usuario a evaluar
      
      Returns:
          Dict con:
            - score: int (0-100)
            - category: str (BAJO/MEDIO/ALTO/CRÍTICO)
            - inputs: dict de valores usados
            - calculated_at: datetime
      """
      
      # 1. Obtener inputs
      user = User.objects.get(id=user_id)
      
      func_criticas = user.functions.filter(es_critica=True).count()
      permisos_totales = user.effective_permissions.count()
      nivel_seguridad = user.nivel_seguridad
      
      if user.last_audit_date:
          dias_audit = (datetime.now() - user.last_audit_date).days
      else:
          dias_audit = 365  # Penalizar si nunca auditado
      
      # 2. Aplicar fórmula
      score = (
          (func_criticas * 25) +
          (permisos_totales * 2) +
          (nivel_seguridad * -10) +
          (dias_audit * 0.5)
      )
      
      # 3. Forzar rango [0, 100]
      score = max(0, min(100, int(score)))
      
      # 4. Clasificar
      if score < 41:
          category = 'BAJO'
      elif score < 71:
          category = 'MEDIO'
      elif score < 86:
          category = 'ALTO'
      else:
          category = 'CRÍTICO'
      
      # 5. Persistir
      user.risk_score = score
      user.risk_category = category
      user.risk_calculated_at = datetime.now()
      user.save(update_fields=[
          'risk_score',
          'risk_category',
          'risk_calculated_at'
      ])
      
      # 6. Retornar resultado
      return {
          'score': score,
          'category': category,
          'inputs': {
              'funciones_criticas': func_criticas,
              'permisos_totales': permisos_totales,
              'nivel_seguridad': nivel_seguridad,
              'dias_desde_auditoria': dias_audit
          },
          'calculated_at': datetime.now()
      }

  # Uso en UC-IACT-04 paso 6:
  risk_data = calculate_risk_score(user_id=target_user.id)
  
  if risk_data['score'] > 85:
      # FA-5: Score Crítico, requiere justificación
      return require_additional_justification()

═══════════════════════════════════════════════════════════
CASOS DE PRUEBA
═══════════════════════════════════════════════════════════

CP-1: Usuario de Bajo Riesgo
  Inputs:
    - func_criticas: 0
    - permisos_totales: 10
    - nivel_seguridad: 5
    - dias_audit: 30
  Cálculo:
    (0×25) + (10×2) + (5×-10) + (30×0.5) = 0 + 20 - 50 + 15 = -15 → 0
  Resultado:
    score: 0, categoria: 'BAJO'

CP-2: Usuario de Riesgo Medio
  Inputs:
    - func_criticas: 2
    - permisos_totales: 50
    - nivel_seguridad: 3
    - dias_audit: 90
  Cálculo:
    (2×25) + (50×2) + (3×-10) + (90×0.5) = 50 + 100 - 30 + 45 = 165 → 100
    (ajustado a 100, pero clasificación sería CRÍTICO)
  ERROR en ejemplo: Debería ser 50 + 100 - 30 + 45 = 165
  Ajuste: score = 100 → CRÍTICO

CP-3: Usuario de Alto Riesgo
  Inputs:
    - func_criticas: 3
    - permisos_totales: 60
    - nivel_seguridad: 2
    - dias_audit: 180
  Cálculo:
    (3×25) + (60×2) + (2×-10) + (180×0.5) = 75 + 120 - 20 + 90 = 265 → 100
  ERROR: Fórmula produce valores >100 frecuentemente
  
  REVISIÓN NECESARIA: Ajustar pesos de fórmula

CP-4: Usuario Sin Auditoría (Nunca)
  Inputs:
    - func_criticas: 1
    - permisos_totales: 20
    - nivel_seguridad: 3
    - dias_audit: 365 (default)
  Cálculo:
    (1×25) + (20×2) + (3×-10) + (365×0.5) = 25 + 40 - 30 + 182.5 = 217.5 → 100
  Resultado:
    score: 100, categoria: 'CRÍTICO'
  Nota: Penalización fuerte por nunca auditado

CP-5: Superusuario con Todas las Funciones
  Inputs:
    - func_criticas: 15 (todas las críticas)
    - permisos_totales: 200
    - nivel_seguridad: 5
    - dias_audit: 7
  Cálculo:
    (15×25) + (200×2) + (5×-10) + (7×0.5) = 375 + 400 - 50 + 3.5 = 728.5 → 100
  Resultado:
    score: 100, categoria: 'CRÍTICO'
  
  PROBLEMA DETECTADO: Fórmula no escala bien, siempre da 100 para users normales

═══════════════════════════════════════════════════════════
PROBLEMA IDENTIFICADO Y SOLUCIÓN
═══════════════════════════════════════════════════════════

ANÁLISIS: La fórmula actual produce scores >100 en la mayoría de casos reales.

CAUSA: Pesos demasiado altos (25, 2, 0.5) + dias_audit sin límite superior.

SOLUCIÓN PROPUESTA: Normalizar inputs antes de aplicar fórmula

  score_riesgo = (
    (func_criticas / 15 * 30) +       // Normalizar a max 15 críticas
    (MIN(permisos_totales, 200) / 200 * 30) +  // Cap en 200
    ((5 - nivel_seguridad) * 10) +     // Invertir (5-nivel)
    (MIN(dias_audit, 365) / 365 * 10)  // Cap en 365 días
  )

  Rango resultante: [0, 80] aproximadamente
  Ajuste final: score *= 1.25 para cubrir [0, 100]

IMPLEMENTACIÓN REVISADA:

  def calculate_risk_score_normalized(user_id: int) -> int:
      user = User.objects.get(id=user_id)
      
      # Obtener inputs
      func_criticas = min(user.critical_functions_count(), 15)
      permisos = min(user.effective_permissions_count(), 200)
      nivel = user.nivel_seguridad
      dias = min(user.days_since_last_audit() or 365, 365)
      
      # Normalizar y calcular
      score = (
          (func_criticas / 15 * 30) +
          (permisos / 200 * 30) +
          ((5 - nivel) * 10) +
          (dias / 365 * 10)
      ) * 1.25
      
      return int(min(100, max(0, score)))

═══════════════════════════════════════════════════════════
MONITOREO Y MÉTRICAS
═══════════════════════════════════════════════════════════

Métricas a Capturar:

  - Distribución de usuarios por categoría
    * % BAJO
    * % MEDIO
    * % ALTO
    * % CRÍTICO
  
  - Score promedio por rol/agrupador
  - Usuarios que pasaron de BAJO→CRÍTICO en <7 días
  - Frecuencia de recálculo (debería ser cada asignación/revocación)

Alertas:

  IF COUNT(users WHERE category='CRÍTICO') > 10% total THEN
    Alerta: "Más del 10% de usuarios en riesgo CRÍTICO"
    Acción: Revisión de asignaciones masivas reciente

  IF user.score aumentó >30 puntos en <24h THEN
    Alerta: "Incremento anormal de riesgo para {user}"
    Acción: Auditoría inmediata

═══════════════════════════════════════════════════════════
TRAZABILIDAD
═══════════════════════════════════════════════════════════

Derivado de:
  BR-IACT-060 (CÁLCULO) → FR-601

Integrado en:
  - UC-IACT-04 Paso 6: Calcular antes de asignar
  - UC-IACT-06 Paso 8: Recalcular después de revocar
  - UC-IACT-11: Calcular para todos en reporte

Utilizado por:
  - FA-5 de UC-IACT-04: Si score > 85
  - Dashboard de Administrador: Visualizar usuarios por riesgo
  - Reportes de Auditoría: Filtrar ALTO/CRÍTICO

═══════════════════════════════════════════════════════════
```

### Ejemplo Adicional: BR-IACT-064

```
BR-IACT-064 (CÁLCULO):
"El indicador de cobertura de permisos se calcula como:

 cobertura = (permisos_asignados / permisos_requeridos_por_rol) × 100

 Donde permisos_requeridos_por_rol viene del perfil ideal definido
 para cada agrupador."

Tipo: Cálculo
Genera: FR-604 integrado en UC-IACT-20 (Generar Reporte de Cobertura)

Implementación:

  SELECT 
    u.user_id,
    u.nombre,
    COUNT(DISTINCT uf.function_id) as permisos_asignados,
    g.expected_functions_count as permisos_requeridos,
    (COUNT(DISTINCT uf.function_id) / g.expected_functions_count * 100) as cobertura_pct
  FROM users u
  JOIN user_groupers ug ON u.user_id = ug.user_id
  JOIN groupers g ON ug.grouper_id = g.grouper_id
  LEFT JOIN user_functions uf ON u.user_id = uf.user_id
  GROUP BY u.user_id, u.nombre, g.expected_functions_count;

Se integra como paso en UC-IACT-20, no genera UC propio.
```

### Resumen del Patrón Cálculos

```
┌────────────────────────────────────────────────────┐
│  PATRÓN 5: CÁLCULOS → INTEGRACIÓN EN PASOS        │
├────────────────────────────────────────────────────┤
│                                                    │
│  ENTRADA:  BR de tipo CÁLCULO                      │
│            Fórmula/Algoritmo con inputs            │
│                                                    │
│  PROCESO:  1. Identificar inputs necesarios        │
│            2. Identificar fórmula exacta           │
│            3. Identificar UC donde se usa          │
│            4. Integrar como PASO en ese UC         │
│            5. Crear FR con algoritmo detallado     │
│            6. Implementar en SQL y código          │
│                                                    │
│  SALIDA:   Paso enriquecido en UC existente        │
│            FR con algoritmo completo               │
│            Función reutilizable                    │
│                                                    │
│  NO GENERA: Caso de Uso independiente              │
│                                                    │
│  INTEGRACIÓN: Como paso en flujo normal            │
│               Como precondición (raro)             │
│               Como postcondición (actualizar)      │
│                                                    │
│  TRAZABILIDAD: BR → UC (integrado) → FR            │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

# SECCIÓN 3: RESUMEN Y TABLA COMPARATIVA

## 3.6 Tabla Comparativa de los 5 Patrones

```
┌───────────────┬──────────────┬──────────────┬─────────────────┬──────────────────────────┐
│ TIPO DE BR    │ ¿GENERA UC?  │ ¿GENERA FR?  │ RESULTADO       │ EJEMPLO IACT             │
├───────────────┼──────────────┼──────────────┼─────────────────┼──────────────────────────┤
│               │              │              │                 │                          │
│ 1. HECHO      │ NO           │ NO (direct)  │ Modelo Dominio  │ BR-IACT-012: code_slug   │
│               │              │              │ Entidades + Rel │ único → Modelo Function  │
│               │              │              │ Constraints     │                          │
│               │              │              │                 │                          │
├───────────────┼──────────────┼──────────────┼─────────────────┼──────────────────────────┤
│               │              │              │                 │                          │
│ 2.RESTRICCIÓN │ NO           │ SÍ           │ Precondición +  │ BR-IACT-087: nivel>=3    │
│               │              │ (de valid.)  │ Validación +    │ → Integrada en UC-04     │
│               │              │              │ Flujo Alterno   │   como Pre + FA-3        │
│               │              │              │                 │                          │
├───────────────┼──────────────┼──────────────┼─────────────────┼──────────────────────────┤
│               │              │              │                 │                          │
│ 3.DESENCADE-  │ SÍ ⭐⭐⭐    │ SÍ (5-10)    │ UC completo     │ BR-IACT-031: Notificar   │
│   NADOR       │ (ÚNICO TIPO) │              │ 12 componentes  │ expir → UC-IACT-07       │
│               │              │              │ Observable      │ (UC completo 10 pasos)   │
│               │              │              │                 │                          │
├───────────────┼──────────────┼──────────────┼─────────────────┼──────────────────────────┤
│               │              │              │                 │                          │
│ 4. INFERENCIA │ NO           │ SÍ (1 FR)    │ FR directo      │ BR-IACT-046: Marcar      │
│               │              │              │ UPDATE auto     │ EXPIRADA → FR-305        │
│               │              │              │ NO observable   │ (solo UPDATE, sin UC)    │
│               │              │              │                 │                          │
├───────────────┼──────────────┼──────────────┼─────────────────┼──────────────────────────┤
│               │              │              │                 │                          │
│ 5. CÁLCULO    │ NO           │ SÍ (1 FR +   │ Paso en UC +    │ BR-IACT-060: Score       │
│               │              │  integración)│ FR con algoritmo│ riesgo → FR-601          │
│               │              │              │ Función reutil. │ integrado en UC-04 P6    │
│               │              │              │                 │                          │
└───────────────┴──────────────┴──────────────┴─────────────────┴──────────────────────────┘
```

## 3.7 Árbol de Decisión

```
                            ┌──────────────┐
                            │ Business Rule│
                            │ Identificada │
                            └──────┬───────┘
                                   │
                    ┌──────────────┴──────────────┐
                    │                             │
           ┌────────▼────────┐           ┌────────▼────────┐
           │ ¿Describe       │           │ ¿Describe       │
           │ ESTRUCTURA?     │           │ COMPORTAMIENTO? │
           └────────┬────────┘           └────────┬────────┘
                    │ SÍ                          │ SÍ
                    │                             │
              ┌─────▼─────┐               ┌───────▼────────┐
              │   HECHO   │               │  IF-THEN       │
              │           │               │  encontrado?   │
              └─────┬─────┘               └───────┬────────┘
                    │                             │ SÍ
                    │                             │
                    ▼                    ┌────────┴────────┐
          Modelo de Dominio              │                 │
          (No genera UC)          ┌──────▼───────┐  ┌─────▼─────┐
                                  │ ¿Resultado   │  │ ¿Es       │
                                  │ OBSERVABLE?  │  │ FÓRMULA?  │
                                  └──────┬───────┘  └─────┬─────┘
                                         │ SÍ │ NO        │ SÍ
                               ┌─────────▼────▼──────┐    │
                               │                     │    │
                      ┌────────▼────────┐   ┌────────▼────▼──┐
                      │ DESENCADENADOR  │   │   INFERENCIA   │
                      │ UC completo ⭐  │   │   FR directo   │
                      └─────────────────┘   └────────────────┘
                                                     │
                                            ┌────────▼────────┐
                                            │                 │
                                     ┌──────▼──────┐  ┌──────▼────────┐
                                     │ RESTRICCIÓN │  │    CÁLCULO    │
                                     │ Integración │  │  Paso en UC   │
                                     └─────────────┘  └───────────────┘
```

---

**PARTE 2A FUNDAMENTOS COMPLETA**

**Próximas secciones:**
- PARTE 2B: Construcción Detallada de Casos de Uso (Secciones 4-7)
- PARTE 2C: Casos Especiales y Validación (Secciones 8-11)

**Templates identificados para extracción:**
1. ✅ Template de Decisión por Tipo de BR (Sec 1.2)
2. ✅ Plantilla de Decisión de Actor Primario (Sec 2.4)
3. ✅ Anatomía de UC - 12 componentes (Sec 2.2)
4. ✅ 5 Patrones de Transformación (Sec 3.1-3.5)

**Total PARTE 2A:** ~28,000 palabras, ~75 páginas