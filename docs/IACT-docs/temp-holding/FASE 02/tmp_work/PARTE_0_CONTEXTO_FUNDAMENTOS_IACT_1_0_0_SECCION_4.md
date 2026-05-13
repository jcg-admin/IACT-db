<a name="6-metodologia-estudio"></a>

## 6. METODOLOGÍA DE ESTUDIO

### 6.1 Cómo Estudiar Este Material

**Principios de Aprendizaje Efectivo:**

```
1. APRENDER HACIENDO (70%)
   ❌ NO: Leer pasivamente las 6 partes
   ✅ SÍ: Documentar 3 BR reales de tu proyecto mientras lees PARTE 1

2. ITERACIÓN INCREMENTAL
   ❌ NO: Intentar dominar todo antes de empezar
   ✅ SÍ: Documentar 1 UC simple, obtener feedback, mejorar

3. VALIDACIÓN CONTINUA
   ❌ NO: Esperar al final para validar
   ✅ SÍ: Validar cada BR/UC con stakeholder antes de continuar

4. TRAZABILIDAD DESDE EL INICIO
   ❌ NO: "Agregaremos trazabilidad después"
   ✅ SÍ: Cada BR enlaza a BReq, cada UC enlaza a BR desde el día 1
```

### 6.2 Ejercicios Prácticos por Parte

**PARTE 1: Ejercicios de BR**

```
Ejercicio 1.1: Identificar Tipo de BR
  Dado: 10 enunciados de reglas de negocio
  Clasificar: ¿Restricción? ¿Cálculo? ¿Desencadenador? ¿Inferencia? ¿Definición?
  
  Ejemplo:
    "El sistema debe cerrar automáticamente sesiones inactivas por más de 15 minutos"
    → Respuesta: Inferencia (BR-IACT-046)

Ejercicio 1.2: Desencadenador vs Inferencia
  Dado: 5 pares de BR similares
  Identificar: ¿Cuál es desencadenador y cuál inferencia?
  
  Ejemplo:
    A) "El sistema notifica al usuario cuando su sesión lleva 12 minutos inactiva"
    B) "El sistema marca la sesión como expirada a los 15 minutos de inactividad"
    → Respuesta: A = Desencadenador (observable), B = Inferencia (no observable)

Ejercicio 1.3: Documentar BR de Tu Proyecto
  Tarea: Documentar 5 BR reales de tu proyecto actual
  Template: Usar formato de BR-IACT-XXX
  Validar: Con Product Owner o stakeholder
```

**PARTE 2: Ejercicios de Transformación**

```
Ejercicio 2.1: Restricción → Precondición
  Dado: BR-IACT-087 (nivel seguridad ≥3)
  Transformar: A precondición de UC-IACT-ACC-01
  
Ejercicio 2.2: Desencadenador → UC Completo
  Dado: BR-IACT-031 (notificar sesión por expirar)
  Generar: UC-IACT-AUTH-07 completo con 11 pasos
  
Ejercicio 2.3: Cálculo → FR
  Dado: BR-IACT-053 (promedio duración)
  Derivar: FR-RPT-02-08 con query SQL
  
Ejercicio 2.4: UC Completo End-to-End
  Tarea: Tomar 1 BR de tu proyecto
  Generar: UC completo (14 secciones)
  Derivar: 5 FR implementables
  Validar: Con equipo
```

**PARTE 3: Ejercicios de Elicitación**

```
Ejercicio 3.1: CRUD de una entidad
  Elegir: Entidad de tu proyecto (ej: Cliente, Producto)
  Generar: 4 UC (Crear, Leer, Actualizar, Eliminar)
  
Ejercicio 3.2: Técnica de Larman
  Dado: 5 eventos del sistema de tu proyecto
  Aplicar: Técnica de Larman para generar UC
  
Ejercicio 3.3: UI-Driven
  Dado: Mockup o wireframe
  Identificar: UC implícitos en la interfaz
```

**PARTE 4: Ejercicios de FR**

```
Ejercicio 4.1: Derivar FR desde UC
  Dado: UC con 8 pasos
  Derivar: 10 FR (1-2 FR por paso)
  
Ejercicio 4.2: FR con Código Implementable
  Dado: FR-RPT-01-07 (calcular count)
  Implementar: Código Python completo con tests
```

### 6.3 Checklist de Validación

**Checklist para BR:**

```
□ ID único (BR-IACT-XXX)
□ Tipo identificado (Restricción/Cálculo/Desencadenador/Inferencia/Definición)
□ Enunciado claro en lenguaje natural
□ Observable por stakeholder (si aplica)
□ Casos de ejemplo incluidos
□ Derivado de BReq identificado
□ UC generados listados
□ Validado con PO/Stakeholder
```

**Checklist para UC (26 puntos - versión resumida):**

```
□ 1. ID único (UC-MOD-NN)
□ 2. Nombre descriptivo en infinitivo
□ 3. Actor principal identificado
□ 4. Precondiciones completas
□ 5. Trigger claro
□ 6. Postcondiciones de éxito
□ 7. Flujo normal numerado
□ 8. Al menos 1 flujo alterno
□ 9. Al menos 1 excepción
□ 10. CNST aplicables listadas
□ 11. BR implementadas referenciadas
□ 12. FR derivados listados
□ 13. Trazabilidad completa
□ 14. Sin ambigüedad técnica
... (26 puntos completos en PARTE 2C)
```

**Checklist para FR:**

```
□ ID único (FR-MOD-UC-NN)
□ Derivado de UC específico
□ Implementa BR específica
□ Especificación técnica clara
□ Código/SQL implementable
□ Casos de prueba definidos
□ Criterios de validación
□ Prioridad asignada
```

### 6.4 Recursos y Herramientas

**Herramientas Recomendadas:**

```
Documentación:
  - Sphinx + RST (generación de docs)
  - PlantUML (diagramas UC)
  - Mermaid (diagramas de flujo)

Trazabilidad:
  - Matrices RTM en Excel/Google Sheets
  - Scripts Python para validación
  - Jira/Confluence para gestión

Código:
  - Git para versionado
  - Django/Python para implementación
  - pytest para tests
```

**Templates Disponibles:**

```
T01: Decisión de Tipo de BR
T02: Construcción UC en 7 Pasos
T03: Identificación de Actor Primario
T04: Documentación FR (10 Componentes)
T05: Construcción de Flujos Alternos
T06: Integración de BR en UC
T09: Checklist de Calidad UC (26 Puntos)
T10: Peer Review de UC
T12: Matriz de Trazabilidad RTM
```

### 6.5 Errores Comunes a Evitar

**Error 1: Confundir Desencadenador con Inferencia**

```
❌ INCORRECTO:
  "El sistema notifica al usuario cuando la sesión expira"
  Clasificado como: Inferencia
  
✅ CORRECTO:
  Pregunta: ¿El usuario VE/RECIBE algo?
  Respuesta: SÍ (notificación)
  → Es DESENCADENADOR, NO inferencia
```

**Error 2: BR Demasiado Técnica**

```
❌ INCORRECTO:
  BR-XXX: "El campo 'estado' de la tabla 'sessions' debe cambiar
           a 'EXPIRED' cuando NOW() - last_activity > 15 minutos"
  
✅ CORRECTO:
  BR-IACT-046: "Una sesión se considera expirada si han transcurrido
                más de 15 minutos desde la última actividad"
```

**Error 3: UC sin Flujos Alternos**

```
❌ INCORRECTO:
  UC solo tiene flujo normal (camino feliz)
  
✅ CORRECTO:
  UC tiene:
    - Flujo normal
    - 2-4 flujos alternos
    - 1-2 excepciones
```

**Error 4: FR sin Trazabilidad**

```
❌ INCORRECTO:
  FR-001: "El sistema debe validar permisos"
  (¿De qué UC viene? ¿Qué BR implementa?)
  
✅ CORRECTO:
  FR-RPT-01-07: "Calcular COUNT(*) antes de query principal"
  Derivado de: UC-IACT-RPT-01 paso 7
  Implementa: BR-IACT-028, BR-IACT-053
```

**Error 5: No Validar con Stakeholders**

```
❌ INCORRECTO:
  Analista documenta 20 BR sin validar
  → En revisión: 15 BR están incorrectas
  
✅ CORRECTO:
  Analista documenta 3 BR
  → Valida con PO inmediatamente
  → Corrige errores
  → Continúa con siguientes 3
```

### 6.6 Métricas de Progreso

**Seguimiento de Avance:**

```
PARTE 1: Identificar BR
  □ 15 BR leídas y comprendidas
  □ 5 BR documentadas de tu proyecto
  □ 3 ejercicios completados
  □ Validación con PO obtenida

PARTE 2: Transformar BR → UC
  □ 5 patrones de transformación dominados
  □ 3 UC completos documentados
  □ 10 FR derivados
  □ Checklist 26 puntos aplicado

PARTE 3: Técnicas de Elicitación
  □ CRUD de 1 entidad completado
  □ Técnica Larman aplicada (5 UC)
  □ UI-Driven aplicado (3 UC)

PARTE 4: FR
  □ 15 FR derivados con código
  □ 15 tests implementados
  □ Trazabilidad completa

PARTE 5: Trazabilidad
  □ RTM creada (30+ entradas)
  □ Script de validación funcionando
  □ Dashboard de cobertura

PARTE 6: Casos Prácticos
  □ Ejercicio 1 completado (Reportes)
  □ Ejercicio 2 completado (Alertas)
  □ Ejercicio 3 completado (RBAC)
```

---

<a name="7-convenciones-referencias"></a>

## 7. CONVENCIONES Y REFERENCIAS

### 7.1 Nomenclatura del Proyecto IACT

**Reglas de Negocio:**

```
Formato: BR-IACT-NNN
Ejemplo: BR-IACT-028

Donde:
  BR = Business Rule
  IACT = Proyecto
  NNN = Número secuencial (001-999)
```

**Business Requirements:**

```
Formato: BRQ-MOD-NNN
Ejemplo: BRQ-RPT-001

Donde:
  BRQ = Business Requirement
  MOD = Módulo (RPT, AUTH, ACC, etc.)
  NNN = Número secuencial
```

**Casos de Uso:**

```
Formato: UC-IACT-MOD-NN_Nombre_Descriptivo_X_Y_Z.rst
Ejemplo: UC-IACT-RPT-01_Consultar_Reporte_4_0_0.rst

Donde:
  UC = Use Case
  IACT = Proyecto
  MOD = Módulo (RPT, AUTH, ACC, etc.)
  NN = Número secuencial (01-99)
  Nombre_Descriptivo = Nombre en CamelCase con guiones bajos
  X_Y_Z = Versión semántica (MAJOR_MINOR_PATCH)
```

**Requisitos Funcionales:**

```
Formato: FR-MOD-UC-NN
Ejemplo: FR-RPT-01-07

Donde:
  FR = Functional Requirement
  MOD = Módulo
  UC = Número del UC del que deriva (01)
  NN = Número secuencial dentro del UC (07)
```

**Restricciones del Sistema:**

```
Formato: CNST-NNN
Ejemplo: CNST-005

Donde:
  CNST = Constraint
  NNN = Número secuencial (001-999)
```

**Agrupadores RBAC:**

```
Formato: AGR-NNN
Ejemplo: AGR-003

Donde:
  AGR = Agrupador
  NNN = Número secuencial (001-999)
```

**Funciones Atómicas RBAC:**

```
Formato: MOD-NNN
Ejemplo: RPT-001

Donde:
  MOD = Módulo (AUTH, RPT, ACC, etc.)
  NNN = Número secuencial (001-999)
  
Nombre: snake_case descriptivo
Ejemplo: ve_reportes, asigna_funciones, gestiona_sesiones
```

### 7.2 Estándares de Documentación

**STD_001 v1.1.0: Sin Emojis**

```
❌ PROHIBIDO:
  - ✅ ❌ ⚠️ (checkmarks, x, warnings)
  - 🚀 📁 💾 (iconos temáticos)
  - Cualquier emoji Unicode

✅ ALTERNATIVAS:
  - [OK], [ERROR], [WARN]
  - [INFO], [SUCCESS], [PENDING]
  - Texto descriptivo
```

**NOM_001 v2.0.0: Nomenclatura**

```
CAMBIOS v1.0 → v2.0:
  - Dígitos secuenciales: 2 → 3
  - Versionado: Opcional → OBLIGATORIO
  - Formato: _MAJOR_MINOR_PATCH
  - Prefijos: 17 → 27 tipos
  
EJEMPLO:
  v1.0: UC_RPT_01_Consultar_Reporte.rst
  v2.0: UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
```

### 7.3 Glosario de Términos

```
BR (Business Rule):
  Política o decisión del negocio expresada en lenguaje natural

BReq (Business Requirement):
  Objetivo del negocio medible

UC (Use Case):
  Interacción observable entre actor y sistema

FR (Functional Requirement):
  Especificación técnica implementable

CNST (Constraint):
  Restricción arquitectónica del sistema

RTM (Requirements Traceability Matrix):
  Matriz de trazabilidad de requisitos

SoD (Segregation of Duties):
  Separación de responsabilidades

RBAC (Role-Based Access Control):
  Control de acceso basado en funciones atómicas

ETL (Extract, Transform, Load):
  Proceso de extracción, transformación y carga de datos

IVR (Interactive Voice Response):
  Sistema de respuesta de voz interactiva
```

### 7.4 Referencias Bibliográficas

**Libros:**

```
1. Cockburn, Alistair. "Writing Effective Use Cases" (2001)
   → Técnica de Larman, niveles de UC

2. Wiegers, Karl; Beatty, Joy. "Software Requirements" 3rd Ed. (2013)
   → IEEE 830, requisitos funcionales

3. Robertson, Suzanne; Robertson, James. "Mastering the Requirements Process" (2012)
   → Elicitación de requisitos, trazabilidad

4. Larman, Craig. "Applying UML and Patterns" 3rd Ed. (2004)
   → Técnica de Larman detallada
```

**Estándares:**

```
1. IEEE 830-1998: Recommended Practice for Software Requirements Specifications
   → Estructura de SRS, requisitos funcionales

2. ISO/IEC 25010:2011: Systems and software Quality Requirements and Evaluation (SQuaRE)
   → Características de calidad

3. INCOSE Systems Engineering Handbook v4 (2015)
   → Gestión de requisitos, trazabilidad
```

**Documentación del Proyecto:**

```
1. MODELO_RBAC_IACT_v5_1_1.md
   → 44 funciones atómicas, agrupadores, SoD

2. RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md
   → 10 CNST detalladas

3. REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md
   → Estado congelado de CNST

4. NOM_001_Nomenclatura_Proyecto_v2_0_0.rst
   → Nomenclatura completa con versionado

5. STD_001_Estandares_Documentacion_v1_1_0.rst
   → Estándar sin emojis
```

### 7.5 Contacto y Soporte

**Canales de Ayuda:**

```
Dudas sobre el Material:
  - Email: team-iact@empresa.com
  - Slack: #iact-documentation
  - Wiki: confluence.empresa.com/iact

Validación de Requisitos:
  - Product Owner: po-iact@empresa.com
  - Tech Lead: techlead-iact@empresa.com

Revisión de Código:
  - Pull Requests: github.com/empresa/iact
  - Code Reviews: Viernes 10:00 AM
```

### 7.6 Control de Versiones de Este Documento

```
Versión 1.0.0 (2026-01-08):
  - Versión inicial completa
  - 7 secciones principales
  - Ejemplos 100% IACT (no químicos)
  - ~18,000 palabras

Cambios respecto a versión anterior:
  - Reescritura completa del dominio
  - Químicos → IACT (sistema IVR Analytics)
  - BR-028, BR-031, BR-046, BR-087, BR-053 como ejemplos principales
  - UC-IACT-RPT-01 como caso maestro
  - Integración con RBAC v5.1.1 y CNST v1.0
```

---

## CONCLUSIÓN

Este documento es el **puente** entre la teoría de ingeniería de requisitos y la práctica del proyecto IACT.

**Recuerda:**

1. **Los requisitos implícitos causan el 60% de los defectos** en proyectos de software
2. **Documentar BR es invertir en prevención**, no perder tiempo
3. **La jerarquía BR → BReq → UC → FR no es burocracia**, es comunicación estructurada
4. **Desencadenadores vs Inferencias** es la distinción más importante
5. **Trazabilidad desde el día 1** ahorra semanas de retrabajo

**Próximos Pasos:**

1. Lee PARTE 1 (Identificar Reglas de Negocio)
2. Documenta 3 BR reales de tu módulo
3. Valida con tu PO
4. Continúa con PARTE 2 (Transformar BR → UC)

**¡Buena suerte en tu aprendizaje!**

---

## APÉNDICE A: CASO ILUSTRATIVO COMPLETO

### Caso End-to-End: BR-IACT-028

```
┌──────────────────────────────────────────────────────────────┐
│         TRAZABILIDAD COMPLETA: BR-IACT-028                    │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  STAKEHOLDER:                                                 │
│  "El servidor Analytics se saturó 3 veces en Q3-2025.         │
│   Necesitamos prevenir que consultas grandes lo sobrecarguen."│
│                                                               │
│                           ↓ GENERA                            │
│                                                               │
│  BRQ-RPT-001: Prevenir Sobrecarga Servidor                   │
│  ═══════════════════════════════════════                     │
│  Métrica: 0 incidentes en Q1-2026                            │
│  KPI: CPU <80%, latencia p95 <3s                             │
│                                                               │
│                           ↓ SE IMPLEMENTA CON                 │
│                                                               │
│  BR-IACT-028: Aprobación Consultas Grandes                   │
│  ═══════════════════════════════════════════                 │
│  Tipo: Restricción                                            │
│  Enunciado: "Consultas >10K registros requieren aprobación"  │
│  Observable: Usuario ve modal de solicitud aprobación        │
│                                                               │
│                  ↓ TRANSFORMA EN (Patrón 1)                   │
│                                                               │
│  UC-IACT-RPT-01: Consultar Reporte Trimestral                │
│  ══════════════════════════════════════════                  │
│  Paso 7: Ejecuta COUNT(*)                                    │
│  Paso 8: Si count >10K → FA-1 (Requiere Aprobación)          │
│  FA-1: Sistema notifica supervisor, crea request             │
│                                                               │
│         ↓ DERIVA EN                                           │
│                                                               │
│  FR-RPT-01-07: Calcular COUNT(*) Antes de Query              │
│  ═══════════════════════════════════════════════            │
│  Query: SELECT COUNT(*) FROM analytics_calls WHERE...        │
│  Timeout: 5 segundos                                          │
│  Decisión: IF count > 10000 THEN solicitar_aprobacion()      │
│                                                               │
│         ↓ SE IMPLEMENTA EN                                    │
│                                                               │
│  reports/services.py                                          │
│  ════════════════════                                        │
│  def calculate_query_count(filters, user):                   │
│      query = "SELECT COUNT(*) FROM analytics_calls..."       │
│      count = execute(query, timeout=5)                       │
│      if count > 10000:                                       │
│          create_approval_request(user, filters, count)       │
│          return {'requires_approval': True, 'count': count}  │
│      return {'requires_approval': False, 'count': count}     │
│                                                               │
│         ↓ SE VALIDA CON                                       │
│                                                               │
│  tests/test_reports.py                                        │
│  ══════════════════════                                      │
│  def test_count_over_10k_requires_approval():                │
│      filters = create_large_query_filters()                  │
│      result = calculate_query_count(filters, user)          │
│      assert result['requires_approval'] == True              │
│      assert result['count'] > 10000                          │
│      assert ApprovalRequest.objects.filter(                 │
│          user=user, status='PENDING').exists()              │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

**Propagación de Cambios:**

Si PO cambia BR-IACT-028 de 10,000 a 5,000:

```
1. Actualizar BR-IACT-028: "consultas >10,000" → "consultas >5,000"
2. Actualizar UC-IACT-RPT-01 paso 8: "count > 10000" → "count > 5000"
3. Actualizar FR-RPT-01-07: "IF count > 10000" → "IF count > 5000"
4. Actualizar reports/services.py línea 47: "if count > 10000:" → "if count > 5000:"
5. Actualizar tests/test_reports.py: Casos con 8000 ahora fallan, ajustar a 4000/6000
6. Ejecutar tests: Validar que cambio es correcto
7. Commit con mensaje: "BR-IACT-028: Cambiar umbral de 10K a 5K registros"
```

---

## APÉNDICE B: CHECKLIST DE PREPARACIÓN

**Antes de Empezar PARTE 1:**

```
□ He leído PARTE 0 completa
□ Entiendo la jerarquía BR → BReq → UC → FR
□ Entiendo los 5 tipos de BR
□ Entiendo Desencadenadores vs Inferencias
□ Tengo acceso a stakeholders para validar BR
□ Tengo herramientas configuradas (editor, templates)
□ He reservado 8-10 horas para PARTE 1
```

**Antes de Empezar PARTE 2:**

```
□ He completado PARTE 1
□ He documentado al menos 5 BR reales
□ He validado BR con PO
□ Entiendo los 5 patrones de transformación
□ Tengo templates de UC listos
□ He reservado 12-15 horas para PARTE 2
```

---

**FIN DE PARTE 0**

**Ubicación:** /tmp/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0.md  
**Versión:** 1.0.0  
**Fecha:** 2026-01-08  
**Próximo Paso:** Leer PARTE 1 - Identificar Reglas de Negocio

---

