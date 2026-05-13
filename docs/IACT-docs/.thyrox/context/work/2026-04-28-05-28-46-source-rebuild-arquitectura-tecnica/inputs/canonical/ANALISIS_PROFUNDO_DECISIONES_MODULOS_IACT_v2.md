# ANÁLISIS PROFUNDO: Evolución y Decisiones de Módulos del Sistema IACT

**Fecha de análisis:** 2026-01-03
**Documentos fuente:** 19 archivos de decisiones arquitectónicas (fechados 2025-12-09)
**Propósito:** Trazar la evolución completa de decisiones sobre módulos, identificar contradicciones y determinar la estructura final correcta

---

## PARTE 1: INVENTARIO DE DOCUMENTOS ANALIZADOS

| # | Documento | Contenido Principal |
|---|-----------|---------------------|
| 1 | Vista general – Módulos del Sistema IACT | Lista inicial de 9 módulos con MOD-02 como IAM_RBAC |
| 2 | Primeros módulos comprobados | Validación contra arquitectura real, módulos que NO existen |
| 3 | MOD-02 – IAM_RBAC viola principios | Detección del "God Module", propuesta de división |
| 4 | Crítica módulo por módulo | Análisis de solapamientos entre módulos |
| 5 | MOD-03 – Supervisión del ETL v.0.0.1 | Redefinición como supervisión, no ejecución |
| 6 | MOD-03 – Supervisión del ETL v.0.1.1 | Ficha formal de arquitectura de ETL_MONITORING |
| 7 | MOD-04 – Visualización y Reportes unificado | Fusión de REPORTS + DASHBOARDS_SQL |
| 8 | MOD-07 AUDIT vs MOD-08 SYS_LOGS | Separación clara entre auditoría funcional y logs técnicos |
| 9 | MOD-10 RBAC_CORE vs MOD-09 SEC_RULES | Diferenciación configuración vs enforcement |
| 10 | RBAC_CORE – Lo que el usuario ve | Decisión de integrar SEC_RULES dentro de RBAC_CORE |
| 11 | Aplicando ejemplos de Prompts | Análisis arquitectónico de SEC_RULES como capa interna |
| 12 | Identificando los módulos funcionales | **DECISIÓN: 8 módulos, SEC_RULES integrado** |
| 13 | Orden correcto de módulos | Reordenamiento con RBAC_CORE en MOD-03 |
| 14 | Análisis módulo por módulo | PUEDE/NO PUEDE hacer de cada módulo |
| 15 | Conexión de RESTRICCIONES con MÓDULOS | Mapeo restricciones → módulos afectados |
| 16 | Flujos de datos principales (FD-01 a FD-12) | 12 flujos de datos del sistema |
| 17 | Lista de Flujos de Datos FD-01 a FD-12 | Índice formal de flujos |
| 18 | FD-04 Ejecución del ETL completo | Detalle del flujo ETL con sección 3.x |
| 19 | FD-04 versión completa (duplicado) | Referencia a sección 3.x del ETL |

---

## PARTE 2: LÍNEA TEMPORAL DE DECISIONES

### FASE 1: Estado Inicial (9 módulos con problemas)

**Documento:** "Vista general – Módulos del Sistema IACT"

```
MOD-01  Autenticación y Sesiones                       (AUTH)
MOD-02  Identidades, Roles, Segmentos y Permisos       (IAM_RBAC) ← PROBLEMA
MOD-03  ETL, Calidad y Disponibilidad de Datos         (ETL_DATA)
MOD-04  Reportes Operativos del IVR (SQL)              (REPORTS)
MOD-05  Dashboards Operativos basados en SQL           (DASHBOARDS_SQL)
MOD-06  Alertas Internas y Notificaciones              (ALERTS)
MOD-07  Auditoría Funcional                            (AUDIT)
MOD-08  Bitácoras Técnicas y Monitoreo                 (SYS_LOGS)
MOD-09  Restricciones y Reglas de Seguridad            (SEC_RULES)
```

**Problemas identificados:**
1. MOD-02 "IAM_RBAC" es un God Module (viola SRP)
2. MOD-04 y MOD-05 tienen responsabilidades duplicadas
3. SEC_RULES no debería ser módulo visible

---

### FASE 2: Detección del God Module

**Documento:** "MOD-02 – Identidades, Roles, Segmentos y Permisos - Viola tus principios"

**Problema detectado:**
> "Al meter en un solo módulo: Identidades de usuario, Roles, Segmentos, Permisos directos, Reglas SoD... estamos creando un módulo-God que sabe y controla demasiado."

**Decisión tomada:** Dividir MOD-02 en dos:
- **MOD-02 – USER_IDENTITY**: Gestión de cuentas (quién existe)
- **MOD-10 – RBAC_CORE**: Gestión de permisos (qué puede hacer)

**Resultado temporal:** 10 módulos

---

### FASE 3: Unificación de Visualización

**Documento:** "MOD-04 – Visualización y Reportes Operativos del IVR (módulo unificado)"

**Problema detectado:**
> "En la práctica el usuario hace esto: Entra al módulo de Dashboards, ve solo los dashboards/reportes a los que tiene permiso, si tiene VIEW ve gráficas/tablas, si tiene EXPORT puede descargar."

**Decisión tomada:** Fusionar MOD-04 REPORTS + MOD-05 DASHBOARDS_SQL en:
- **MOD-04 – VIS_REPORTS**: Visualización y Reportes Operativos del IVR

**Justificación:**
- No necesitas módulo separado de reportes y dashboards
- El mismo flujo, distintas capacidades por RBAC
- Mismo módulo, distintos permisos (VIEW vs EXPORT)

**Resultado temporal:** 9 módulos

---

### FASE 4: Debate sobre SEC_RULES

**Documentos:** "MOD-10 RBAC_CORE vs MOD-09 SEC_RULES", "RBAC_CORE – Lo que el usuario ve", "Aplicando ejemplos de Prompts"

**Análisis realizado:**

| Aspecto | RBAC_CORE | SEC_RULES |
|---------|-----------|-----------|
| Tipo | Configuración estática | Validación en runtime |
| Pregunta | "¿Qué roles tiene el usuario?" | "¿Esta acción está permitida ahora?" |
| UI | Sí (pantallas de admin) | NO |
| UC | Sí (UC-010, UC-011, UC-041, UC-042) | NO (automático) |
| Usuario interactúa | Sí | NO |

**Argumentos clave extraídos:**

Del documento "Aplicando ejemplos de Prompts":
> "SEC_RULES NO debe ser un módulo visible para el usuario. El usuario nunca 'entra' a SEC_RULES."
> "SEC_RULES debe ser un componente interno automático, NO un módulo funcional."
> "Igual que: Middleware de permisos, Policy enforcement, Decoradores de DRF, Validaciones antes de UC"

Del documento "RBAC_CORE – Lo que el usuario ve":
> "SEC_RULES es una subcapa técnica dentro del mismo dominio de acceso, NO un módulo funcional aparte para el usuario."
> "Así NO aparece como módulo separado en el catálogo funcional, pero sí queda documentado formalmente como parte del diseño de System Design."

**DECISIÓN TOMADA:**
> "SEC_RULES debe ser descrito como capa interna de enforcement dentro de ese mismo dominio, NO como módulo funcional separado."

---

### FASE 5: Lista Final Consolidada (8 módulos)

**Documento:** "Identificando los módulos funcionales"

**DECISIÓN OFICIAL:**

```
MOD-01  AUTH              - Sesiones y autenticación
MOD-02  USER_IDENTITY     - Usuarios / identidades  
MOD-03  ETL_MONITORING    - Monitoreo ETL
MOD-04  VIS_REPORTS       - Dashboards + Reportes + Exportaciones
MOD-06  ALERTS            - Alertas internas
MOD-07  AUDIT             - Auditoría funcional
MOD-08  SYS_LOGS          - Bitácoras técnicas
MOD-09  RBAC_CORE         - Roles, segmentos, permisos (SEC_RULES incorporado)
```

**Nota importante:** En este documento hay un salto de MOD-04 a MOD-06, MOD-05 desapareció por la fusión.

**Validación de consistencia (del documento):**
- ✅ ¿Duplicación? NO — nada se repite
- ✅ ¿Módulos muy pequeños/grandes? NO — cada uno tiene propósito específico
- ✅ ¿Módulos sin UI? Solo RBAC_CORE tiene partes automáticas, pero tiene UI para roles/segmentos/permisos
- ✅ SEC_RULES queda integrado y no es módulo visible

---

### FASE 6: Reordenamiento Lógico

**Documento:** "Orden correcto de módulos"

Se propuso reordenar para que RBAC_CORE vaya ANTES de los módulos funcionales:

```
MOD-01  AUTH
MOD-02  USER_IDENTITY
MOD-03  RBAC_CORE         ← Movido aquí (antes era MOD-09/MOD-10)
MOD-04  ETL_MONITORING
MOD-05  VIS_REPORTS
MOD-06  ALERTS
MOD-07  AUDIT
MOD-08  SYS_LOGS
MOD-09  SEC_RULES         ← Mantiene como "capa transversal al final"
```

**Justificación:**
> "El sistema debe definir primero identidades (MOD-02), luego permisos, roles y segmentos (MOD-03), y sólo después los módulos funcionales pueden saber qué mostrar, qué ocultar y qué permitir."

---

### FASE 7: Análisis Detallado PUEDE/NO PUEDE

**Documento:** "Análisis módulo por módulo"

Este documento asume 9 módulos (con SEC_RULES separado como MOD-09), lo cual **CONTRADICE** la decisión de la Fase 5.

**Contenido valioso extraído (responsabilidades por módulo):**

#### MOD-01 AUTH
- **PUEDE:** Login, logout, JWT, sesiones, throttling, timeout
- **NO PUEDE:** Definir roles ni permisos, lógica de alertas
- **Pregunta clave:** "¿Quién eres? ¿Tu sesión es válida?"

#### MOD-02 USER_IDENTITY
- **PUEDE:** Alta, baja lógica, modificación de usuario, preguntas de seguridad
- **NO PUEDE:** Lógica de precedencia, cálculo de permisos efectivos, validaciones SoD
- **Pregunta clave:** "¿Qué usuarios existen y con qué atributos?"

#### MOD-03 RBAC_CORE (en el documento aparece como separado de SEC_RULES)
- **PUEDE:** Catálogo de roles, permisos, segmentos, precedencias, SoD
- **NO PUEDE:** Mostrar UI funcional final, lógica de negocio de reportes
- **Pregunta clave:** "¿Qué puede hacer este usuario en este módulo, sobre qué datos?"

#### MOD-04 ETL_MONITORING
- **PUEDE:** Ver ejecuciones ETL, disponibilidad de datos, errores de carga
- **NO PUEDE:** Reportes de negocio, consultas directas a IVR, definir reglas de seguridad
- **Pregunta clave:** "¿El ETL está bien, cuándo corrió, qué datos tengo disponibles?"

#### MOD-05 VIS_REPORTS
- **PUEDE:** Dashboards, reportes tabulares, exportaciones según permisos
- **NO PUEDE:** Ejecutar ETL, implementar lógica RBAC, usar real-time
- **Pregunta clave:** "¿Qué ve el usuario y qué puede descargar?"

#### MOD-06 ALERTS
- **PUEDE:** Alertas basadas en métricas, buzón interno, reglas declarativas
- **NO PUEDE:** Consultas directas a BD IVR, mandar email, implementar lógica de permisos
- **Pregunta clave:** "¿Qué condiciones disparan alertas?"

#### MOD-07 AUDIT
- **PUEDE:** Registrar acciones de negocio (quién, qué, cuándo, resultado)
- **NO PUEDE:** Guardar stack traces/errores técnicos, definir reglas de acceso
- **Pregunta clave:** "¿Qué acciones de negocio relevantes se hicieron?"

#### MOD-08 SYS_LOGS
- **PUEDE:** Logs estructurados, niveles (INFO/WARN/ERROR), logs de infraestructura
- **NO PUEDE:** Registrar cosas de negocio, definir reglas de seguridad, exponer PII
- **Pregunta clave:** "¿Qué está pasando a nivel técnico con el sistema?"

#### MOD-09 SEC_RULES (en este documento aparece separado)
- **PUEDE:** Aplicar restricciones críticas automáticamente (middleware, validadores)
- **NO PUEDE:** Exponer UI, redefinir permisos, implementar lógica de dominio no-seguridad
- **Pregunta clave:** "¿Se están cumpliendo las restricciones globales?"

---

## PARTE 3: IDENTIFICACIÓN DE CONTRADICCIONES

### Contradicción Principal: ¿8 o 9 módulos?

| Documento | Módulos | SEC_RULES | RBAC_CORE posición |
|-----------|---------|-----------|-------------------|
| "Identificando los módulos funcionales" | **8** | **Integrado en RBAC_CORE** | MOD-09 |
| "Orden correcto de módulos" | 9 | MOD-09 separado | MOD-03 |
| "Análisis módulo por módulo" | 9 | MOD-09 separado | MOD-03 |
| "Flujos de datos principales" | 9 | MOD-09 separado | MOD-03 |

### Contradicción de Numeración

En "Identificando los módulos funcionales":
- Hay salto de MOD-04 a MOD-06
- MOD-05 no existe (fusionado)
- RBAC_CORE es MOD-09

En "Orden correcto de módulos":
- Numeración consecutiva MOD-01 a MOD-09
- RBAC_CORE es MOD-03
- VIS_REPORTS es MOD-05

### Análisis de la Contradicción

**Los documentos posteriores ("Orden correcto", "Análisis módulo por módulo", "Flujos de datos") parecen haber IGNORADO la decisión tomada en "Identificando los módulos funcionales".**

Evidencia:
1. "Identificando los módulos funcionales" dice explícitamente: "Resultado final: 8 módulos" y "SEC_RULES integrado como capa automática, NO visible para usuarios"
2. Pero "Análisis módulo por módulo" (documento posterior según UID) lista 9 módulos con SEC_RULES separado

---

## PARTE 4: DECISIÓN FINAL RECOMENDADA

Basándome en el análisis profundo de TODOS los documentos, y considerando:

1. La argumentación técnica más sólida está en "Identificando los módulos funcionales", "RBAC_CORE – Lo que el usuario ve" y "Aplicando ejemplos de Prompts"
2. SEC_RULES NO cumple la definición de módulo funcional (no tiene UI, no tiene UC, es automático)
3. La fusión de REPORTS + DASHBOARDS está bien justificada

### ESTRUCTURA FINAL: 8 MÓDULOS FUNCIONALES

```
ARQ_MOD_001  AUTH              - Autenticación y Sesiones
ARQ_MOD_002  USER_IDENTITY     - Gestión de Identidades y Cuentas
ARQ_MOD_003  RBAC_CORE         - Roles, Segmentos, Permisos + SEC_RULES (integrado)
ARQ_MOD_004  ETL_MONITORING    - Supervisión del ETL
ARQ_MOD_005  VIS_REPORTS       - Visualización y Reportes
ARQ_MOD_006  ALERTS            - Alertas y Notificaciones
ARQ_MOD_007  AUDIT             - Auditoría Funcional
ARQ_MOD_008  SYS_LOGS          - Bitácoras Técnicas
```

### ESTRUCTURA INTERNA DE ARQ_MOD_003 RBAC_CORE

El módulo RBAC_CORE contiene DOS componentes documentados:

**Componente 1: RBAC_CORE (Administración)**
- Tiene UI para administrar roles, segmentos, permisos
- UC visibles: UC-010, UC-011, UC-041, UC-042, etc.
- Endpoints de API para CRUD de roles/permisos/segmentos
- Es visible al usuario administrador

**Componente 2: SEC_RULES (Enforcement Interno)**
- NO tiene UI
- NO tiene UC propios
- Es middleware/decoradores/policies
- Se ejecuta automáticamente en cada request
- Aplica restricciones: NO email, BD IVR readonly, límites exportación, SoD, throttling, etc.

### ENFORCERS INTEGRADOS EN SEC_RULES

Del análisis de los documentos, SEC_RULES aplica:

| Enforcer | Restricción que aplica | CNST relacionada |
|----------|----------------------|------------------|
| NoEmailEnforcer | Todo por buzón interno | CNST_001 |
| ReadOnlyIVREnforcer | BD IVR solo SELECT | CNST_003 |
| NoRealTimeEnforcer | Sin WebSockets/SSE | CNST_003 |
| SessionDBEnforcer | Sesiones en BD, no Redis | CNST_002 |
| ExportLimitEnforcer | Límites de registros por tipo | CNST_007 |
| ThrottlingEnforcer | Rate limiting | CNST_007 |
| SoDEnforcer | Roles incompatibles | CNST_005 |

---

## PARTE 5: DIFERENCIACIÓN AUDIT vs SYS_LOGS

Del documento "MOD-07 AUDIT vs MOD-08 SYS_LOGS":

| Dimensión | MOD-07 AUDIT | MOD-08 SYS_LOGS |
|-----------|--------------|-----------------|
| Pregunta clave | "¿Quién hizo qué sobre qué cosa y cuándo?" | "¿Qué le está pasando al sistema por dentro?" |
| Vista | Negocio / Cumplimiento / Seguridad funcional | Técnico / Dev / Soporte / Monitoreo |
| Tipo de eventos | Acciones de negocio (login, crear usuario, exportar) | Eventos técnicos (errores, timeouts, warnings) |
| Mutabilidad | **Inmutable** (append-only) | Rotables, compactables |
| Retención | Años (por cumplimiento) | 30-90 días |
| Audiencia | Auditores, seguridad, supervisión | Devs, SRE, soporte técnico |
| Campos típicos | user_id, accion, recurso, timestamp, IP, resultado | timestamp, nivel, servicio, mensaje, stack_trace |

**Ejemplos diferenciadores:**
- "¿Quién cambió permisos de este usuario?" → **AUDIT**
- "¿Por qué está fallando el ETL?" → **SYS_LOGS**
- "Usuario exportó reporte X" → **AUDIT**
- "Timeout en query q_REPTRIM001" → **SYS_LOGS**

---

## PARTE 6: RESTRICCIONES CRÍTICAS POR MÓDULO

Del documento "Conexión de las RESTRICCIONES con los MÓDULOS":

### MOD-01 AUTH
- Sesiones en BD (`django.contrib.sessions.backends.db`)
- Sesión única por usuario
- Timeout 15 min
- Validar IP + User-Agent
- JWT con expiraciones fijas
- Login con throttling (5 intentos / 5 min)

### MOD-02 USER_IDENTITY
- Flat RBAC NIST, 18 roles funcionales
- Precedencia: Directo > Rol > Segmento
- SoD (SYSTEM_ADMIN ⚔️ AUDIT_VIEWER)
- Permisos por endpoint y por objeto

### MOD-03 RBAC_CORE (incluye SEC_RULES)
- Todas las reglas RBAC, SoD
- Permisos directos con justificación y vencimiento
- Enforcement de todas las restricciones globales

### MOD-04 ETL_MONITORING
- IVR = solo SELECT (readonly)
- ETL no puede escribir en MySQL
- Frecuencia 6–12 horas
- `@transaction.atomic` en el pipeline
- NO real-time / NO WebSockets / NO SSE

### MOD-05 VIS_REPORTS
- Datos siempre desfasados según última corrida ETL
- Límites de filtros, rangos de fechas (máx. 2 años)
- Tiempos de respuesta máximos
- Paginación, límites de registros, timeout

### MOD-06 ALERTS
- **TODO por buzón interno, NADA de correo**
- Tipos de alerta, severidades, frecuencias, snooze
- Máximo 50 destinatarios por alerta

### MOD-07 AUDIT
- Qué eventos auditar (login, permisos, exportaciones)
- Inmutabilidad de logs de auditoría
- SoD entre auditores y admins

### MOD-08 SYS_LOGS
- No loggear contraseñas, tokens, PII sin enmascarar
- Formato JSON estructurado, masking
- Retención 30-90 días

---

## PARTE 7: FLUJOS DE DATOS PRINCIPALES

Del documento "Flujos de datos principales del sistema IACT":

| FD | Nombre | Módulos Involucrados |
|----|--------|---------------------|
| FD-01 | Autenticación y Sesiones | AUTH, USER_IDENTITY, RBAC_CORE |
| FD-02 | Resolución de Permisos Efectivos | AUTH, USER_IDENTITY, RBAC_CORE |
| FD-03 | Gestión de Identidades | USER_IDENTITY, RBAC_CORE, AUDIT |
| FD-04 | Ejecución del ETL (Batch) | ETL_MONITORING, SYS_LOGS |
| FD-05 | Supervisión del ETL | ETL_MONITORING |
| FD-06 | Visualización Dashboards/Reportes | VIS_REPORTS, RBAC_CORE |
| FD-07 | Exportación de Reportes | VIS_REPORTS, RBAC_CORE, AUDIT |
| FD-08 | Evaluación y Entrega de Alertas | ALERTS, RBAC_CORE, AUDIT |
| FD-09 | Auditoría Funcional | AUDIT (transversal) |
| FD-10 | Bitácoras Técnicas | SYS_LOGS (transversal) |
| FD-11 | Aplicación de Reglas SEC_RULES | RBAC_CORE/SEC_RULES, AUDIT, SYS_LOGS |
| FD-12 | Mensajería Interna (Buzón) | ALERTS, USER_IDENTITY |

---

## PARTE 8: MÓDULOS QUE NO EXISTEN

Del documento "Primeros módulos comprobados":

**Explícitamente excluidos del Sistema IACT:**
- ❌ Exploración interactiva
- ❌ Query Builder para el usuario
- ❌ Modelos analíticos / Machine Learning
- ❌ Identificación automatizada de patrones
- ❌ Series de tiempo avanzadas
- ❌ Detección de anomalías
- ❌ Interfaz OLAP / Drill-down dinámico
- ❌ Tableros configurables por el usuario
- ❌ KPIs autogenerados con lógica dinámica
- ❌ Métricas no incluidas en los SQL existentes

**Razones:**
- No están en la arquitectura actual (Django + SQL estáticos)
- No están en los UC aceptados
- No se pueden implementar en 480 horas
- Violan restricciones operativas

---

## PARTE 9: CONCLUSIONES

### 9.1 La decisión correcta es 8 MÓDULOS

Basándome en la argumentación técnica de los documentos:
1. SEC_RULES no cumple definición de módulo funcional
2. No tiene UI ni UC propios
3. Es enforcement automático, no interacción de usuario
4. Debe documentarse como subcapa dentro de RBAC_CORE

### 9.2 Estructura Final Aprobada

```
ARQ_MOD_001  AUTH              
ARQ_MOD_002  USER_IDENTITY     
ARQ_MOD_003  RBAC_CORE         (incluye SEC_RULES como subcapa)
ARQ_MOD_004  ETL_MONITORING    
ARQ_MOD_005  VIS_REPORTS       
ARQ_MOD_006  ALERTS            
ARQ_MOD_007  AUDIT             
ARQ_MOD_008  SYS_LOGS          
```

### 9.3 Documentos Contradictorios

Los siguientes documentos contradicen la decisión de 8 módulos y deben considerarse como versiones previas NO finales:
- "Orden correcto de módulos" (lista 9 módulos)
- "Análisis módulo por módulo" (lista 9 módulos)
- "Flujos de datos principales" (referencia 9 módulos)

### 9.4 Documento Definitivo

El documento **"Identificando los módulos funcionales"** contiene la decisión final correcta:
> "Resultado final: 8 módulos"
> "SEC_RULES integrado como capa automática, NO visible para usuarios"

---

## ANEXO: Resumen de Responsabilidades PUEDE/NO PUEDE

### AUTH (ARQ_MOD_001)
**PUEDE:** Login, logout, JWT, sesiones, throttling, timeout 15 min
**NO PUEDE:** Definir roles/permisos, lógica de alertas, reglas avanzadas de acceso

### USER_IDENTITY (ARQ_MOD_002)
**PUEDE:** Alta/baja/modificación usuario, preguntas seguridad, estados
**NO PUEDE:** Lógica de precedencia, cálculo permisos efectivos, validaciones SoD

### RBAC_CORE (ARQ_MOD_003)
**PUEDE:** Catálogo roles/permisos/segmentos, precedencias, SoD, enforcement automático
**NO PUEDE:** UI funcional final, lógica de negocio de reportes/ETL

### ETL_MONITORING (ARQ_MOD_004)
**PUEDE:** Ver ejecuciones ETL, disponibilidad datos, errores carga
**NO PUEDE:** Reportes negocio, consultas directas IVR, reglas seguridad

### VIS_REPORTS (ARQ_MOD_005)
**PUEDE:** Dashboards, reportes tabulares, exportaciones según permisos
**NO PUEDE:** Ejecutar ETL, implementar RBAC, real-time

### ALERTS (ARQ_MOD_006)
**PUEDE:** Alertas basadas en métricas, buzón interno, reglas declarativas
**NO PUEDE:** Consultas BD IVR, email, implementar permisos

### AUDIT (ARQ_MOD_007)
**PUEDE:** Registrar acciones negocio (quién, qué, cuándo, resultado)
**NO PUEDE:** Stack traces/errores técnicos, definir reglas acceso

### SYS_LOGS (ARQ_MOD_008)
**PUEDE:** Logs estructurados, niveles INFO/WARN/ERROR, infraestructura
**NO PUEDE:** Registrar cosas negocio, reglas seguridad, exponer PII

---

*Análisis generado: 2026-01-03*
*Total documentos analizados: 19*
*Líneas de análisis: ~600*
