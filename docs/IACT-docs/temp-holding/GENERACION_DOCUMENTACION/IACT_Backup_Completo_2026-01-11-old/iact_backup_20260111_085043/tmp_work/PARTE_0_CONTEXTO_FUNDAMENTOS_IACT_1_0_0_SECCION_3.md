<a name="4-alcance-del-material"></a>

## 4. ALCANCE DEL MATERIAL

### 4.1 Qué Cubre Este Material

Este material pedagógico (PARTES 0-6) cubre:

```
✅ INCLUIDO EN EL MATERIAL
════════════════════════════

1. Metodología BR → UC → FR
   - Identificación de reglas de negocio
   - Transformación sistemática a casos de uso
   - Derivación de requisitos funcionales

2. Técnicas de Elicitación
   - CRUD básico
   - Técnica de Larman
   - UI-Driven Use Cases
   - Stakeholder-Driven Use Cases

3. Proyecto IACT Real
   - Ejemplos de MOD_Reports
   - Ejemplos de MOD_Auth
   - Ejemplos de MOD_Access
   - Ejemplos de MOD_Alerts

4. Trazabilidad Completa
   - Matrices RTM
   - Forward/Backward tracing
   - Gestión de cambios

5. Plantillas y Herramientas
   - Templates de UC (14 secciones)
   - Templates de FR (10 componentes)
   - Checklists de validación
   - Scripts de auditoría
```

```
❌ NO INCLUIDO (Fuera del Alcance)
═══════════════════════════════════

1. Requisitos No Funcionales (NFR)
   - Performance
   - Seguridad
   - Escalabilidad
   → Ver: RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md

2. Arquitectura Técnica
   - Diagramas de componentes
   - Deployment
   - Stack tecnológico
   → Ver: docs/arquitectura/

3. Diseño de Datos
   - Modelo ER
   - Normalización
   - Índices
   → Ver: docs/database/

4. Testing Detallado
   - Estrategia de testing
   - Test plans
   - Coverage
   → Ver: docs/testing/

5. Gestión de Proyecto
   - Estimaciones
   - Cronogramas
   - Asignación de recursos
   → Ver: docs/management/
```

### 4.2 Dominio del Proyecto IACT

**IACT:** IVR Analytics & Customer Tracking

**Contexto:**
- Sistema de análisis de llamadas IVR (Interactive Voice Response)
- Tracking de clientes que interactúan con sistema telefónico automatizado
- Reportes consolidados de métricas operacionales
- Control de acceso basado en funciones atómicas (RBAC v5.1.1)

**Módulos Principales:**

```
MOD_Auth: Autenticación y Sesiones
  - Login/Logout
  - Gestión de sesiones
  - Notificaciones de expiración
  - Reseteo de passwords

MOD_Users: Gestión de Usuarios
  - CRUD de usuarios
  - Perfiles
  - Preferencias
  - Estados (activo/bloqueado/baja)

MOD_Access: Control de Acceso RBAC
  - Asignación de funciones atómicas
  - Validación de permisos
  - Segregation of Duties (SoD)
  - Permisos temporales

MOD_Pipeline: ETL y Procesamiento
  - Extracción de BD IVR
  - Transformación de datos
  - Carga a BD Analytics
  - Ejecución cada 6-12 horas

MOD_Reports: Reportes y Analytics
  - Consultas consolidadas
  - Exportación (CSV/Excel/PDF)
  - Filtros avanzados
  - Aprobación de consultas grandes

MOD_Alerts: Alertas y Notificaciones
  - Configuración de alertas
  - Umbrales dinámicos
  - Notificaciones internas (CNST-001)
  - Logs de alertas

MOD_Audit: Auditoría
  - Registro de acciones
  - Búsqueda de eventos
  - Reportes de auditoría
  - Retención 7 años

MOD_Logs: Logs Técnicos
  - Logs de aplicación
  - Monitoreo de errores
  - Dashboards técnicos
  - Alertas de sistema
```

**Restricciones del Sistema (CNST):**

```
CNST-001: NO envío de emails externos
  → Solo notificaciones en buzón interno

CNST-002: Sesión única por usuario
  → Cierre automático de sesión anterior

CNST-003: BD IVR solo lectura
  → Datos con desfase 6-12h (según ETL)

CNST-004: ETL cada 6-12 horas
  → Datos NO en tiempo real

CNST-005: Flat RBAC + SoD
  → 44 funciones atómicas, sin jerarquía
  → Permisos temporales con justificación

CNST-006: Rango máximo 2 años
  → Reportes limitados a 730 días

CNST-007: Límites de exportación
  → CSV: 100K registros
  → Excel: 50K registros
  → PDF: 10K registros

CNST-008: Sesión expira 15 minutos
  → Inactividad = logout automático

CNST-009: Auditoría obligatoria
  → Todas las acciones se registran

CNST-010: Retención logs 7 años
  → Cumplimiento normativo
```

### 4.3 Actores del Sistema

**Agrupadores RBAC (AGR-00x):**

```
AGR-001: agr_operador
  - Usuarios operativos básicos
  - Consulta datos de su segmento
  - Sin permisos de administración
  - Funciones: 5-10 funciones básicas

AGR-002: agr_analista
  - Analistas de negocio
  - Reportes avanzados
  - Exportación de datos
  - Funciones: 15-20 funciones

AGR-003: agr_supervisor
  - Supervisores de área
  - Aprobación de consultas grandes
  - Gestión de equipo
  - Funciones: 25-30 funciones

AGR-004: agr_admin_sistema
  - Administradores técnicos
  - Gestión de usuarios
  - Asignación de funciones
  - Configuración del sistema
  - Funciones: 35-40 funciones

AGR-005: agr_auditor
  - Auditores internos
  - Solo lectura de logs
  - Reportes de auditoría
  - Sin permisos de modificación
  - Funciones: 5-8 funciones específicas
```

**Segmentos de Datos:**

```
Operativo (OP):
  - Centros de contacto operativos
  - Métricas de llamadas
  - Datos de clientes activos

Financiero (FI):
  - Centros financieros
  - Transacciones telefónicas
  - Datos sensibles

Ventas (VT):
  - Centros de ventas
  - Métricas de conversión
  - Campañas telefónicas

Soporte (SP):
  - Centros de soporte técnico
  - Tiempos de resolución
  - Satisfacción del cliente
```

### 4.4 Ejemplos Usados en el Material

**BR Principales:**

```
BR-IACT-028: Aprobación consultas >10K registros
  → Usado extensivamente en PARTE 2

BR-IACT-031: Notificación sesión por expirar (12 min)
  → Ejemplo de Desencadenador en PARTE 1

BR-IACT-046: Marcar sesión expirada (15 min)
  → Ejemplo de Inferencia en PARTE 1

BR-IACT-087: Nivel seguridad ≥3 para funciones críticas
  → Usado en PARTE 2 y 3

BR-IACT-053: Cálculo promedio duración llamadas
  → Ejemplo de Cálculo en PARTE 1

BR-IACT-001: Definición "Cliente activo"
  → Ejemplo de Definición en PARTE 1
```

**UC Principales:**

```
UC-IACT-RPT-01: Consultar Reporte Trimestral
  → Caso maestro en PARTE 0, 2 y 4
  → 11 pasos, 4 flujos alternos, 3 excepciones
  → Integra BR-IACT-028, CNST-006, CNST-007

UC-IACT-AUTH-01: Iniciar Sesión
  → Ejemplo básico en PARTE 3

UC-IACT-AUTH-07: Notificar Sesión por Expirar
  → Ejemplo de UC generado por Desencadenador

UC-IACT-ACC-01: Asignar Funciones a Usuario
  → Ejemplo de RBAC en PARTE 3
  → Implementa BR-IACT-087

UC-IACT-RPT-09: Aprobar/Rechazar Consulta Grande
  → Complemento de UC-IACT-RPT-01
  → Actor: Supervisor
```

**FR Principales:**

```
FR-RPT-01-07: Calcular COUNT(*) antes de query principal
  → Derivado de UC-IACT-RPT-01 paso 7
  → Implementa BR-IACT-028

FR-AUTH-07-02: Query sesiones por expirar
  → Derivado de UC-IACT-AUTH-07
  → Implementa BR-IACT-031

FR-ACC-01-04: Validar nivel seguridad para funciones críticas
  → Derivado de UC-IACT-ACC-01
  → Implementa BR-IACT-087
```

---

<a name="5-roadmap-detallado"></a>

## 5. ROADMAP DETALLADO

### 5.1 Mapa Conceptual de las 6 Partes

```
┌──────────────────────────────────────────────────────────────────┐
│                    MATERIAL PEDAGÓGICO COMPLETO                   │
│                           6 PARTES                                │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  PARTE 0: Contexto y Fundamentos (ESTE DOCUMENTO)                │
│  ═══════════════════════════════════════════════                 │
│  • El Problema                                                    │
│  • La Solución (Jerarquía 4 niveles)                              │
│  • Transformaciones Clave                                         │
│  • Alcance y Roadmap                                              │
│                                                                   │
│                           ↓ FUNDAMENTA                            │
│                                                                   │
│  PARTE 1: Identificar Reglas de Negocio                          │
│  ═══════════════════════════════════════                         │
│  • Taxonomía: 5 tipos de BR                                      │
│  • Técnicas de elicitación de BR                                 │
│  • Desencadenadores vs Inferencias ⭐                             │
│  • Documentación de BR                                            │
│  • Ejercicios prácticos                                           │
│                                                                   │
│  Duración: 8-10 horas estudio                                     │
│  Ejemplos: 15+ BR del proyecto IACT                               │
│                                                                   │
│                           ↓ TRANSFORMA EN                         │
│                                                                   │
│  PARTE 2: Transformar BR en UC                                    │
│  ══════════════════════════════════                               │
│  • PARTE 2A: Fundamentos (5 patrones transformación)              │
│  • PARTE 2B: Construcción Detallada (7 pasos)                     │
│  • PARTE 2C: Casos Especiales y Validación                        │
│                                                                   │
│  Duración: 12-15 horas estudio                                    │
│  Ejemplos: UC-IACT-RPT-01, UC-IACT-ACC-01, UC-IACT-AUTH-07        │
│  Incluye: Checklist 26 puntos, RTM, trazabilidad                  │
│                                                                   │
│                           ↓ COMPLEMENTA CON                       │
│                                                                   │
│  PARTE 3: Técnicas de Elicitación UC                             │
│  ═══════════════════════════════════                             │
│  • PARTE 3A: Introducción y CRUD                                  │
│  • PARTE 3B: Técnica de Larman (20+ UC)                           │
│  • PARTE 3C: UI-Driven + Stakeholder-Driven                       │
│  • PARTE 3D: Consolidación y Resumen                              │
│                                                                   │
│  Duración: 10-12 horas estudio                                    │
│  Ejemplos: 40+ UC desarrollados completos                         │
│                                                                   │
│                           ↓ DERIVA EN                             │
│                                                                   │
│  PARTE 4: Requisitos Funcionales                                 │
│  ════════════════════════════════                                │
│  • Definición y estándares (IEEE 830, ISO 25010)                  │
│  • Plantilla FR (10 componentes)                                  │
│  • Proceso de derivación UC → FR                                  │
│  • Clasificación y priorización                                   │
│  • FR completos con casos de prueba                               │
│                                                                   │
│  Duración: 8-10 horas estudio                                     │
│  Ejemplos: 30+ FR derivados con código Python/SQL                 │
│                                                                   │
│                           ↓ GESTIONA CON                          │
│                                                                   │
│  PARTE 5: Trazabilidad y Gestión                                 │
│  ════════════════════════════════════                            │
│  • Matrices RTM (Requirements Traceability Matrix)                │
│  • Forward/Backward tracing                                       │
│  • Gestión de cambios                                             │
│  • Versionado de requisitos                                       │
│  • Herramientas de trazabilidad                                   │
│                                                                   │
│  Duración: 6-8 horas estudio                                      │
│  Incluye: Scripts automatización, dashboards                      │
│                                                                   │
│                           ↓ PRACTICA CON                          │
│                                                                   │
│  PARTE 6: Casos Prácticos Completos                              │
│  ═══════════════════════════════════                             │
│  • Ejercicio 1: Módulo Reportes (end-to-end)                      │
│  • Ejercicio 2: Módulo Alertas (end-to-end)                       │
│  • Ejercicio 3: Módulo RBAC (end-to-end)                          │
│  • Soluciones completas con código                                │
│                                                                   │
│  Duración: 12-15 horas práctica                                   │
│  Entregables: 3 módulos documentados + implementados              │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘

TOTAL ESTIMADO: 60-80 horas de estudio + práctica
```

### 5.2 PARTE 1: Identificar Reglas de Negocio

**Objetivo:** Aprender a identificar y clasificar reglas de negocio.

**Contenido:**

```
Sección 1: Introducción
  - ¿Qué es una BR?
  - ¿Por qué documentar BR?
  - BR vs BReq vs UC vs FR

Sección 2: Taxonomía de BR (5 Tipos)
  - Tipo 1: Restricciones
  - Tipo 2: Cálculos
  - Tipo 3: Desencadenadores ⭐
  - Tipo 4: Inferencias ⭐
  - Tipo 5: Definiciones

Sección 3: Desencadenadores vs Inferencias
  ⭐ SECCIÓN MÁS IMPORTANTE DE PARTE 1
  - Test de observabilidad
  - Timeline comparativo
  - Impacto en UC
  - Ejemplos: BR-IACT-031 vs BR-IACT-046

Sección 4: Técnicas de Elicitación de BR
  - Entrevistas con stakeholders
  - Análisis de documentos
  - Observación de procesos
  - Workshops

Sección 5: Documentación de BR
  - Template estándar
  - Campos obligatorios
  - Nomenclatura

Secciones 6-12: Ejemplos y Ejercicios
  - 15+ BR del proyecto IACT
  - 5 ejercicios prácticos
  - Soluciones detalladas
```

**Duración:** 8-10 horas  
**Prerequisitos:** PARTE 0  
**Entregables:** 10 BR documentadas del proyecto IACT

### 5.3 PARTE 2: Transformar BR en UC

**Objetivo:** Dominar la transformación sistemática BR → UC.

**PARTE 2A: Fundamentos (3,735 líneas)**

```
Sección 1: Los 5 Patrones de Transformación
  Patrón 1: Restricciones → Precondiciones/Flujos Alternos
    Ejemplo: BR-IACT-087 → UC-IACT-ACC-01 (FA-3)
  
  Patrón 2: Cálculos → FR Derivados
    Ejemplo: BR-IACT-053 → FR-RPT-02-08
  
  Patrón 3: Desencadenadores → UC Completos ⭐
    Ejemplo: BR-IACT-031 → UC-IACT-AUTH-07 (11 pasos)
  
  Patrón 4: Inferencias → FR Directos
    Ejemplo: BR-IACT-046 → FR-AUTH-08-02
  
  Patrón 5: Definiciones → Glosario
    Ejemplo: BR-IACT-001 → GLOSARIO.rst

Sección 2: Fórmulas Matemáticas
  - AVG, SUM, COUNT en SQL
  - Redondeo y precisión
  - Casos especiales (división por cero)

Sección 3: Algoritmos de Decisión
  - Pseudocódigo
  - Estructuras IF-THEN-ELSE
  - Bucles y validaciones
  - Ejemplo completo: BR-IACT-087 (nivel seguridad)
```

**PARTE 2B: Construcción Detallada (4,359 líneas)**

```
Sección 4: Construcción UC Paso a Paso (7 Pasos)
  Paso 1: Identificar actor principal
  Paso 2: Definir trigger
  Paso 3: Enumerar pasos del flujo normal
  Paso 4: Identificar flujos alternos
  Paso 5: Identificar excepciones
  Paso 6: Definir precondiciones/postcondiciones
  Paso 7: Agregar trazabilidad

Sección 5: Integración Multi-BR
  - UC que implementa 3-5 BR diferentes
  - Ejemplo: UC-IACT-RPT-01 integra:
    • BR-IACT-028 (aprobación)
    • BR-IACT-053 (count)
    • BR-IACT-087 (nivel seguridad)

Sección 6: Derivación FR desde UC
  - 1 paso UC → 1-3 FR
  - Nomenclatura FR
  - FR con código implementable

Sección 7: Trazabilidad Bidireccional
  - Matrices RTM
  - Forward tracing
  - Backward tracing
  - Propagación de cambios
```

**PARTE 2C: Casos Especiales (3,332 líneas)**

```
Sección 8: Casos Especiales
  - UC CRUD (casos simples)
  - UC con CNST (restricciones arquitectónicas)
  - UC múltiples actores
  - UC con variantes
  - UC concurrencia

Sección 9: Validación UC
  - Checklist 26 puntos ⭐
  - Peer review
  - Stakeholder walkthrough
  - Validación de trazabilidad

Sección 10: Métricas de Calidad
  - Completitud
  - Consistencia
  - Claridad
  - Trazabilidad

Sección 11: Ejercicios Prácticos
  - 4 ejercicios con soluciones completas
```

**Total PARTE 2:** 11,426 líneas (~215 páginas)  
**Duración:** 12-15 horas  
**Entregables:** 5 UC completos documentados

### 5.4 PARTE 3: Técnicas de Elicitación UC

**Objetivo:** Dominar técnicas avanzadas para descubrir casos de uso.

**Contenido:**

```
PARTE 3A: Introducción y CRUD (936 líneas)
  - Técnicas de elicitación
  - CRUD básico
  - Casos de uso elementales

PARTE 3B: Técnica de Larman (3,277 líneas)
  - Eventos del sistema
  - Operaciones del sistema
  - 20+ UC desarrollados con Larman

PARTE 3C: UI-Driven + Stakeholder-Driven (1,801 líneas)
  - UI-Driven: partir de mockups/wireframes
  - Stakeholder-Driven: workshops
  - 8 UC completos

PARTE 3D: Consolidación (1,280 líneas)
  - Numeración de UC
  - Priorización MoSCoW
  - Roadmap de releases
  - Ejercicio Library System completo
```

**Total PARTE 3:** 7,294 líneas  
**Duración:** 10-12 horas

### 5.5 PARTE 4: Requisitos Funcionales

**Objetivo:** Derivar FR implementables desde UC.

**Contenido:**

```
Sección 1: Definición y Estándares
  - IEEE 830
  - ISO 25010
  - INCOSE

Sección 2: Plantilla FR (10 Componentes)
  - ID, Nombre, Módulo
  - Descripción
  - Derivado de (UC)
  - Especificación técnica
  - Implementación (código)
  - Casos de prueba
  - Validación
  - Prioridad
  - Trazabilidad

Secciones 3-9: Proceso y Ejemplos
  - Derivación UC → FR
  - Clasificación (funcional, datos, interfaz)
  - Priorización
  - 30+ FR con código Python/SQL completo
```

**Duración:** 8-10 horas

### 5.6 PARTE 5: Trazabilidad

**Objetivo:** Gestionar cambios y mantener trazabilidad.

**Contenido:**

```
- Matrices RTM automatizadas
- Scripts de validación
- Dashboards de cobertura
- Versionado semántico de requisitos
- Gestión de cambios
```

**Duración:** 6-8 horas

### 5.7 PARTE 6: Casos Prácticos

**Objetivo:** Aplicar TODO en ejercicios end-to-end.

**Contenido:**

```
Ejercicio 1: Módulo Reportes Completo
  - 5 BR → 3 UC → 15 FR → Código → Tests
  
Ejercicio 2: Módulo Alertas Completo
  - 4 BR → 2 UC → 10 FR → Código → Tests

Ejercicio 3: Módulo RBAC Completo
  - 6 BR → 4 UC → 20 FR → Código → Tests
```

**Duración:** 12-15 horas

### 5.8 Ruta de Aprendizaje Recomendada

```
SEMANA 1: Fundamentos
  Día 1-2: PARTE 0 (contexto)
  Día 3-5: PARTE 1 (identificar BR)

SEMANA 2: Transformación
  Día 1-3: PARTE 2A (patrones transformación)
  Día 4-5: PARTE 2B (construcción detallada)

SEMANA 3: Casos Especiales y Técnicas
  Día 1-2: PARTE 2C (casos especiales)
  Día 3-5: PARTE 3 (técnicas elicitación)

SEMANA 4: FR y Trazabilidad
  Día 1-3: PARTE 4 (requisitos funcionales)
  Día 4-5: PARTE 5 (trazabilidad)

SEMANA 5: Práctica
  Día 1-5: PARTE 6 (casos prácticos)

TOTAL: 5 semanas (60-80 horas)
```

---

