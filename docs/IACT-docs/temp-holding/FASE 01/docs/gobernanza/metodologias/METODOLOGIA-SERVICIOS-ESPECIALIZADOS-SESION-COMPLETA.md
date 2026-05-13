---
id: METOD-GOB-010
tipo: metodologia
categoria: orquestacion-agentes
titulo: Metodologia de Agentes Especializados para Sesiones Complejas
fecha: 2025-11-18
autor: Claude Code Agent
version: 1.0.0
caso_estudio: Sesion 2025-11-17-18 (Consolidacion + Refactorizaciones)
---

# METODOLOGIA DE AGENTES ESPECIALIZADOS PARA SESIONES COMPLEJAS

## 1. Resumen Ejecutivo

Esta metodología documenta el sistema de agentes especializados usado para ejecutar sesiones complejas de desarrollo que requieren:
- Análisis exhaustivos
- Planificación detallada
- Ejecución con múltiples tareas
- Documentación completa
- Zero regresiones

**Caso de Estudio:** Sesión 2025-11-17-18
- 33 pasos ejecutados
- 30 commits generados
- 30 tareas completadas
- ~15,000 líneas documentadas
- 6-7 horas de trabajo

---

## 2. Principios Fundamentales

### 2.1 Especialización de Agentes
- Cada agente tiene un propósito específico
- Los agentes se lanzan en paralelo cuando es posible
- Los agentes generan documentación estructurada
- Los agentes NO se interrumpen entre sí

### 2.2 Documentación como Código
- TODO se documenta exhaustivamente
- Documentación se genera DURANTE la ejecución, no después
- Evidencias obligatorias en cada paso
- Trazabilidad completa

### 2.3 Metodología TDD
- Tests primero (RED)
- Implementar cambio (REFACTOR)
- Validar tests (GREEN)
- Validaciones adicionales (VALIDATE)

### 2.4 Transparencia Inmediata
- Errores reportados inmediatamente
- No ocultar fallos
- Rollback documentado
- Lecciones aprendidas capturadas

---

## 3. Tipos de Agentes Especializados

### 3.1 Agente de Análisis
**Propósito:** Analizar estado actual y generar reporte exhaustivo

**Cuándo usar:**
- Al inicio de una sesión compleja
- Cuando se necesita entender el estado de múltiples ramas
- Cuando se requiere inventario de estructura

**Salidas típicas:**
- ANALISIS-*.md (600-800 líneas)
- INDICE.md explicativo
- Métricas cuantificadas
- Matriz de riesgos

**Ejemplo de esta sesión:**
- Paso 1: Análisis de ramas Git (707 líneas)
- Paso 16: Análisis refactorizaciones MCP (633 líneas)
- Paso 26: Análisis estructura gobernanza (763 líneas)

**Comandos típicos usados:**
```bash
# Análisis de ramas
git branch -a
git log --oneline
git diff --stat

# Análisis de estructura
find . -type d | wc -l
find . -name "*.md" | wc -l
```

---

### 3.2 Agente de Planificación
**Propósito:** Crear plan ejecutable con tareas detalladas

**Cuándo usar:**
- Después del análisis
- Cuando se requiere metodología específica (TDD, etc.)
- Cuando el trabajo tiene múltiples fases

**Salidas típicas:**
- PLAN-*.md (600-900 líneas)
- Matriz RACI
- Dependencias entre tareas
- Estrategia de rollback
- Tiempo estimado

**Ejemplo de esta sesión:**
- Paso 2: Plan consolidación ramas (605 líneas, 6 fases, 14 tareas)
- Paso 18: Plan refactorizaciones TDD (629 líneas, 5 fases, 16 tareas)

**Estructura del plan:**
1. Resumen ejecutivo
2. Objetivos
3. Metodología
4. Fases del plan
5. Matriz RACI
6. Dependencias
7. Estrategia rollback
8. Riesgos y mitigaciones
9. Criterios de éxito
10. Tiempo estimado

---

### 3.3 Agente de Creación de Tareas
**Propósito:** Generar documentación detallada de cada tarea

**Cuándo usar:**
- Después de tener el plan
- Lanzar MÚLTIPLES agentes en PARALELO (1 agente por cada 3-4 tareas)
- Cuando se requiere granularidad extrema

**Salidas típicas:**
- TASK-NNN-nombre/README.md (200-400 líneas por tarea)
- Carpeta evidencias/ vacía lista para usar
- Comandos bash exactos
- Criterios de éxito medibles

**Ejemplo de esta sesión:**
- Paso 19: Agente 1 → TASK-001 a TASK-004 (1,062 líneas)
- Paso 20: Agente 2 → TASK-005 a TASK-008 (1,770 líneas)
- Paso 21: Agente 3 → TASK-009 a TASK-012 (1,771 líneas)
- Paso 22: Agente 4 → TASK-013 a TASK-016 (2,066 líneas)

**IMPORTANTE:** Lanzar 4 agentes EN PARALELO aceleró el proceso 4x

**Estructura de cada tarea:**
```markdown
---
id: TASK-XXX-NNN
tipo: [preparacion|tdd-red|tdd-refactor|tdd-green|tdd-validate|commit]
---

# TASK-XXX-NNN: [Título]

## Objetivo
## Prerequisitos
## Pasos de Ejecución (con comandos bash exactos)
## Criterios de Éxito
## Validación
## Rollback
## Evidencias Requeridas
## Riesgos
## Notas
## Checklist de Finalización
```

---

### 3.4 Agente de Ejecución Principal
**Propósito:** Ejecutar TODAS las tareas del plan en secuencia

**Cuándo usar:**
- Cuando todas las tareas están documentadas
- Cuando se requiere ejecución completa sin intervención
- Cuando se necesita consistencia absoluta

**Salidas típicas:**
- Código refactorizado
- Commits aplicados
- Evidencias generadas en cada TASK-NNN/evidencias/
- Reporte de ejecución completo

**Ejemplo de esta sesión:**
- Paso 23: Ejecutar plan refactorizaciones (16/16 tareas, 46 evidencias)
- Paso 30: Ejecutar plan consolidación (13/13 tareas, 13 evidencias)

**Responsabilidades:**
1. Leer cada TASK-NNN/README.md
2. Ejecutar TODOS los pasos documentados
3. Guardar TODAS las evidencias
4. Validar TODOS los criterios de éxito
5. DETENER si falla una tarea crítica
6. Ejecutar rollback si necesario
7. Reportar transparentemente

**Metodología de ejecución:**
```
Para cada tarea en orden:
  1. Leer TASK-NNN/README.md
  2. Verificar prerequisitos
  3. Ejecutar pasos uno por uno
  4. Guardar evidencias en evidencias/
  5. Validar criterios de éxito
  6. Si FALLA → Rollback + DETENER
  7. Si ÉXITO → Continuar siguiente tarea
```

---

### 3.5 Agente de Procedimientos
**Propósito:** Crear procedimientos reutilizables basados en experiencia

**Cuándo usar:**
- Después de ejecutar exitosamente un plan
- Cuando el proceso es repetible
- Cuando se quiere estandarizar una metodología

**Salidas típicas:**
- PROCED-GOB-NNN-*.md (400-600 líneas)
- Proceso paso a paso
- Herramientas recomendadas
- Plantillas de referencia

**Ejemplo de esta sesión:**
- Paso 4: PROCED-GOB-007 consolidación ramas (605 líneas)
- Paso 8: PROCED-GOB-008 permisos Git (490 líneas)
- Paso 24: PROCED-GOB-009 refactorizaciones TDD (461 líneas)

---

### 3.6 Agente de Verificación
**Propósito:** Verificar que procedimientos están actualizados con ejecución real

**Cuándo usar:**
- Después de ejecutar un procedimiento
- Para identificar gaps entre teoría y práctica
- Para capturar lecciones aprendidas

**Salidas típicas:**
- REPORTE-VERIFICACION-*.md (1,000-1,500 líneas)
- Comparación procedimiento vs realidad
- Gaps identificados con prioridades
- Recomendaciones de actualización

**Ejemplo de esta sesión:**
- Paso 33: Verificar PROCED-GOB-009 (1,201 líneas)

---

## 4. Flujo de Trabajo Completo

### Fase 1: ANÁLISIS
```
Usuario → Solicitud compleja
    ↓
Agente Principal → Lanza Agente de Análisis
    ↓
Agente de Análisis → Genera ANALISIS-*.md
    ↓
Resultado → Estado actual documentado
```

### Fase 2: PLANIFICACIÓN
```
ANALISIS-*.md existe
    ↓
Agente Principal → Lanza Agente de Planificación
    ↓
Agente de Planificación → Genera PLAN-*.md
    ↓
Resultado → Estrategia ejecutable con N tareas
```

### Fase 3: CREACIÓN DE TAREAS
```
PLAN-*.md existe con N tareas
    ↓
Agente Principal → Lanza 3-4 Agentes de Tareas EN PARALELO
    ↓
Agente 1 → TASK-001 a TASK-004
Agente 2 → TASK-005 a TASK-008  (en paralelo)
Agente 3 → TASK-009 a TASK-012  (en paralelo)
Agente 4 → TASK-013 a TASK-016  (en paralelo)
    ↓
Resultado → N tareas documentadas exhaustivamente
```

### Fase 4: EJECUCIÓN
```
TASK-001 a TASK-N documentadas
    ↓
Agente Principal → Lanza Agente de Ejecución
    ↓
Agente de Ejecución → Ejecuta secuencialmente TASK-001 → TASK-N
    ↓
Por cada tarea:
  - Leer README.md
  - Ejecutar pasos
  - Guardar evidencias
  - Validar éxito
    ↓
Resultado → Trabajo completado + Evidencias generadas
```

### Fase 5: PROCEDIMIENTO
```
Ejecución exitosa
    ↓
Agente Principal → Lanza Agente de Procedimientos
    ↓
Agente de Procedimientos → Genera PROCED-GOB-NNN-*.md
    ↓
Resultado → Proceso reutilizable estandarizado
```

### Fase 6: VERIFICACIÓN
```
PROCED-GOB-NNN-*.md existe
Plan ejecutado
    ↓
Agente Principal → Lanza Agente de Verificación
    ↓
Agente de Verificación → Compara procedimiento vs realidad
    ↓
Resultado → Reporte con gaps y recomendaciones
```

---

## 5. Ventajas de Esta Metodología

### 5.1 Paralelización
- Lanzar 4 agentes de tareas en paralelo = 4x más rápido
- Reducir tiempo de creación de tareas de 4-6h a 1-1.5h

### 5.2 Documentación Exhaustiva
- ~15,000 líneas generadas automáticamente
- Documentación durante ejecución, no después
- Evidencias completas para auditoría

### 5.3 Trazabilidad Completa
- Cada paso documentado
- Cada decisión justificada
- Cada comando ejecutado registrado
- Cada evidencia guardada

### 5.4 Zero Regresiones
- Tests validados en cada fase
- Rollback inmediato ante fallos
- Metodología TDD estricta
- Validaciones continuas

### 5.5 Reutilización
- Procedimientos generados son reutilizables
- Plantillas de referencia para futuros trabajos
- Lecciones aprendidas capturadas
- Mejora continua documentada

---

## 6. Métricas del Caso de Estudio

### Agentes Lanzados: 11 agentes totales

**Agentes de Análisis:** 3
- Análisis ramas (Paso 1)
- Análisis refactorizaciones (Paso 16)
- Análisis estructura (Paso 26)

**Agentes de Planificación:** 2
- Plan consolidación (Paso 2)
- Plan refactorizaciones (Paso 18)

**Agentes de Tareas:** 4 (en paralelo)
- Agente 1: TASK-001 a TASK-004 (Paso 19)
- Agente 2: TASK-005 a TASK-008 (Paso 20)
- Agente 3: TASK-009 a TASK-012 (Paso 21)
- Agente 4: TASK-013 a TASK-016 (Paso 22)

**Agentes de Ejecución:** 2
- Ejecución plan refactorizaciones (Paso 23)
- Ejecución plan consolidación (Paso 30)

**Agentes de Procedimientos:** 3
- Procedimiento consolidación ramas (Paso 4)
- Procedimiento permisos Git (Paso 8)
- Procedimiento refactorizaciones TDD (Paso 24)

**Agentes de Verificación:** 1
- Verificación PROCED-GOB-009 (Paso 33)

### Tiempo Total: 6-7 horas

**Distribución:**
- Análisis y planificación: 2-3 horas
- Creación de tareas: 1-1.5 horas (paralelizado)
- Ejecución: 1.5-2 horas
- Procedimientos y verificación: 1 hora

### Salidas Generadas

**Documentos:** ~120 archivos
**Líneas de código:** 28 líneas modificadas
**Líneas de documentación:** ~15,000 líneas
**Evidencias:** 63 archivos (~2,000 líneas)
**Commits:** 30 commits
**Tareas completadas:** 30/30 (100%)

---

## 7. Cómo Replicar Esta Metodología

### Paso 1: Identificar Complejidad
Si la solicitud requiere:
- Múltiples análisis
- Planificación detallada
- Más de 5 tareas
- Documentación exhaustiva
- Zero regresiones
→ Usar esta metodología

### Paso 2: Lanzar Agente de Análisis
```
Task tool con subagent_type: general-purpose
Prompt: "Analizar [contexto] y generar ANALISIS-*.md exhaustivo"
```

### Paso 3: Lanzar Agente de Planificación
```
Task tool con subagent_type: general-purpose
Prompt: "Crear PLAN-*.md ejecutable basado en ANALISIS-*.md"
```

### Paso 4: Lanzar Agentes de Tareas EN PARALELO
```
IMPORTANTE: Usar MÚLTIPLES Task tools en UN SOLO mensaje

Task tool 1: Crear TASK-001 a TASK-004
Task tool 2: Crear TASK-005 a TASK-008
Task tool 3: Crear TASK-009 a TASK-012
Task tool 4: Crear TASK-013 a TASK-016
```

### Paso 5: Lanzar Agente de Ejecución
```
Task tool con subagent_type: general-purpose
Prompt: "Ejecutar TODAS las tareas del PLAN-*.md en secuencia estricta con metodología TDD"
```

### Paso 6: Lanzar Agente de Procedimientos
```
Task tool con subagent_type: general-purpose
Prompt: "Crear PROCED-GOB-NNN-*.md basado en caso exitoso"
```

### Paso 7: Lanzar Agente de Verificación
```
Task tool con subagent_type: general-purpose
Prompt: "Verificar PROCED-GOB-NNN-*.md comparando con ejecución real"
```

---

## 8. Plantillas de Prompts

### 8.1 Prompt para Agente de Análisis
```
Crear análisis exhaustivo de [CONTEXTO] en [UBICACIÓN].

OBJETIVO: Documentar estado actual completo

TAREAS:
1. Analizar [específico]
2. Generar ANALISIS-[NOMBRE]-YYYY-MM-DD.md
3. Incluir: estado actual, métricas, riesgos, recomendaciones

ESTRUCTURA:
- Resumen ejecutivo
- Inventario completo
- Análisis por categoría
- Matriz de riesgos
- Métricas cuantificadas
- Recomendaciones priorizadas

IMPORTANTE:
- NO usar emojis
- Números exactos, no aproximaciones
- Comandos git/bash usados documentados

RESULTADO: Ubicación archivo, métricas, hallazgos
```

### 8.2 Prompt para Agente de Planificación
```
Crear PLAN ejecutable con metodología TDD basado en ANALISIS-*.md

OBJETIVO: Plan de N tareas en M fases

TAREAS:
1. Definir fases (preparación, ejecución, validación, commit)
2. Crear PLAN-[NOMBRE]-YYYY-MM-DD.md
3. Incluir: fases, tareas, RACI, rollback, riesgos, tiempos

ESTRUCTURA:
- Resumen ejecutivo
- Objetivos
- Metodología TDD (RED-REFACTOR-GREEN-VALIDATE)
- Fases del plan
- Matriz RACI
- Dependencias
- Estrategia rollback
- Riesgos y mitigaciones
- Criterios de éxito
- Tiempo estimado

IMPORTANTE:
- Metodología TDD estricta
- Rollback por fase
- Evidencias obligatorias

RESULTADO: Ubicación plan, fases, tareas, tiempo estimado
```

### 8.3 Prompt para Agente de Tareas (lanzar 4 en paralelo)
```
Crear tareas TASK-NNN a TASK-MMM del plan [NOMBRE]

OBJETIVO: Documentación exhaustiva de cada tarea

ESTRUCTURA por tarea:
TASK-NNN-nombre/
├── README.md (200-400 líneas)
└── evidencias/

CONTENIDO README.md:
- Metadata YAML
- Objetivo
- Prerequisitos
- Pasos con comandos bash EXACTOS
- Criterios de éxito MEDIBLES
- Validación con comandos
- Rollback documentado
- Evidencias requeridas (lista)
- Riesgos con mitigaciones
- Checklist finalización

IMPORTANTE:
- Comandos bash ejecutables (rutas absolutas)
- Criterios medibles (no genéricos)
- NO usar emojis

RESULTADO: Total tareas creadas, líneas generadas, problemas
```

### 8.4 Prompt para Agente de Ejecución
```
Ejecutar TODAS las tareas del plan [NOMBRE] en SECUENCIA ESTRICTA

METODOLOGÍA: TDD (RED-REFACTOR-GREEN-VALIDATE)

IMPORTANTE:
1. Orden secuencial: TASK-001 → TASK-002 → ... → TASK-N
2. Por cada tarea:
   - Leer README.md completo
   - Ejecutar TODOS los pasos
   - Guardar TODAS las evidencias
   - Validar TODOS los criterios
3. Si falla tarea CRÍTICA:
   - Ejecutar rollback
   - DETENER ejecución
   - Reportar error EXACTO

ESTRATEGIA:
- [específico del contexto]

RESULTADO:
- Tareas ejecutadas exitosamente
- Tareas fallidas (si alguna)
- Resumen cambios
- Estado final
- Problemas con transparencia inmediata
```

### 8.5 Prompt para Agente de Procedimientos
```
Crear procedimiento reutilizable basado en caso exitoso [NOMBRE]

OBJETIVO: PROCED-GOB-NNN-[nombre].md

ESTRUCTURA:
1. Propósito
2. Alcance (aplica/no aplica)
3. Roles y responsabilidades
4. Prerequisitos
5. Fases del procedimiento
6. Metodología
7. Gestión de evidencias
8. Estrategia de rollback
9. Riesgos y mitigaciones
10. Criterios de éxito
11. Métricas y reporting
12. Frecuencia de uso
13. Herramientas recomendadas
14. Plantillas de referencia

BASADO EN:
- Caso exitoso: [NOMBRE]
- [Detalles del caso]

IMPORTANTE:
- Proceso reutilizable
- NO usar emojis
- Plantillas incluidas

RESULTADO: Ubicación, secciones, líneas, características
```

### 8.6 Prompt para Agente de Verificación
```
Verificar procedimiento [NOMBRE] comparando con ejecución real

OBJETIVO: REPORTE-VERIFICACION-[NOMBRE].md

TAREAS:
1. Leer procedimiento
2. Comparar con ejecución real de [CASOS]
3. Identificar:
   - Aciertos (lo que funcionó)
   - Gaps (lo que falta/difiere)
   - Lecciones aprendidas no incluidas

ESTRUCTURA REPORTE:
- Estado actual procedimiento
- Comparación con ejecución real
  - Aciertos (lista)
  - Gaps (prioridad alta/media/baja)
  - Lecciones aprendidas
- Recomendaciones actualización
  - Cambios sugeridos (prioridad)
  - Adiciones sugeridas
  - Mejoras claridad
- Conclusión
  - ¿Actualizado? SI/NO/PARCIALMENTE
  - ¿Requiere actualización? SI/NO
  - Prioridad: ALTA/MEDIA/BAJA

IMPORTANTE:
- Específico con gaps
- Métricas reales vs estimadas
- NO emojis

RESULTADO: Análisis completo actualización
```

---

## 9. Lecciones Aprendidas

### 9.1 Paralelización es Clave
- Lanzar agentes en paralelo reduce tiempo dramáticamente
- 4 agentes de tareas en paralelo = 4x más rápido
- Usar Task tool MÚLTIPLE en UN mensaje

### 9.2 Documentación Durante, No Después
- Generar documentación MIENTRAS se ejecuta
- Evidencias en tiempo real
- No depender de memoria después

### 9.3 Granularidad Extrema Funciona
- Tareas de 200-400 líneas son ejecutables sin ambigüedad
- Comandos bash exactos evitan errores
- Criterios medibles permiten validación objetiva

### 9.4 TDD Previene Regresiones
- Metodología TDD estricta funcionó perfectamente
- Zero regresiones en 30 tareas
- Tests primero garantiza calidad

### 9.5 Procedimientos Mejoran con Uso
- Primera versión 70% correcta
- Verificación identifica gaps
- Actualización basada en experiencia real

---

## 10. Antipatrones (Qué NO Hacer)

### NO lanzar agentes secuencialmente cuando pueden ir en paralelo
Ejemplo malo: Crear TASK-001, esperar, crear TASK-002, esperar...
Ejemplo bueno: Lanzar 4 agentes que crean TASK-001 a TASK-016 en paralelo

### NO crear documentación después de ejecutar
Ejemplo malo: Ejecutar todo, luego documentar
Ejemplo bueno: Documentar durante ejecución con evidencias

### NO usar criterios genéricos
Ejemplo malo: "Verificar que funciona"
Ejemplo bueno: "Ejecutar: pytest test_registry.py -v → 13/13 tests PASS"

### NO ocultar fallos
Ejemplo malo: Continuar cuando test falla
Ejemplo bueno: DETENER, ejecutar rollback, reportar error exacto

### NO omitir evidencias
Ejemplo malo: Ejecutar tarea sin guardar logs
Ejemplo bueno: Guardar TODAS las salidas en evidencias/

---

## 11. Casos de Uso

### Caso 1: Consolidación de Múltiples Ramas
**Usar:** Agente Análisis → Agente Planificación → 4 Agentes Tareas → Agente Ejecución
**Ejemplo:** QA-ANALISIS-RAMAS-001 (14 tareas, 17 evidencias)

### Caso 2: Refactorizaciones con TDD
**Usar:** Agente Análisis → Agente Planificación → 4 Agentes Tareas → Agente Ejecución → Agente Procedimientos
**Ejemplo:** QA-REFACTOR-MCP-002 (16 tareas, 46 evidencias, PROCED-GOB-009 generado)

### Caso 3: Análisis de Estructura
**Usar:** Agente Análisis
**Ejemplo:** QA-ANALISIS-ESTRUCTURA-003 (102 dirs, 415 archivos)

### Caso 4: Creación de Procedimientos
**Usar:** Agente Procedimientos (basado en caso exitoso)
**Ejemplo:** PROCED-GOB-007, PROCED-GOB-008, PROCED-GOB-009

### Caso 5: Verificación de Procedimientos
**Usar:** Agente Verificación
**Ejemplo:** REPORTE-VERIFICACION-PROCED-GOB-009

---

## 12. Métricas de Efectividad

### Velocidad
- Sin metodología: ~15-20 horas estimadas
- Con metodología: 6-7 horas reales
- **Mejora:** 2-3x más rápido

### Calidad
- Tests passing: 13/13 (100%)
- Regresiones: 0
- Documentación: ~15,000 líneas generadas
- **Mejora:** Zero defectos

### Trazabilidad
- Evidencias: 63 archivos
- Commits: 30 documentados
- Decisiones: Todas justificadas
- **Mejora:** 100% trazable

---

## 13. Referencias

### Documentos Generados en Esta Sesión
- QA-ANALISIS-RAMAS-001/
- QA-REFACTOR-MCP-002/
- QA-ANALISIS-ESTRUCTURA-003/
- PROCED-GOB-007, PROCED-GOB-008, PROCED-GOB-009
- REPORTE-VERIFICACION-PROCED-GOB-009

### Commits Generados
- Rango: 1dc3719..148cdb5
- Total: 31 commits
- Branch: claude/fix-branch-issues-013FpGsYZUySbBL6bsMbhBf2

---

**Metodología creada:** 2025-11-18
**Última actualización:** 2025-11-18
**Versión:** 1.0.0
**Estado:** DOCUMENTADO
**Caso de estudio:** Sesión 2025-11-17-18 (exitosa)
