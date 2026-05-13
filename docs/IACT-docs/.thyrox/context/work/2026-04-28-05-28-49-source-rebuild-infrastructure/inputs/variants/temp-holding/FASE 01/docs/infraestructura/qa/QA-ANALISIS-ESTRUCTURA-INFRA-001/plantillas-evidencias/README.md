---
id: PLANTILLAS-EVIDENCIAS-INFRA
tipo: guia_plantillas
categoria: qa_evidencias
fecha_creacion: 2025-11-18
version: 1.0.0
tecnicas_aplicadas: [Auto-CoT, Self-Consistency]
---

# Plantillas de Evidencias para TASK-REORG-INFRA

## Proposito

Este directorio contiene plantillas estandarizadas para documentar evidencias de ejecucion de tareas TASK-REORG-INFRA, aplicando tecnicas de prompting avanzadas: Auto-CoT (Automatic Chain-of-Thought) y Self-Consistency.

## Plantillas Disponibles

### 1. PLANTILLA-RESUMEN-EJECUCION.md

**Tecnica Aplicada:** Auto-CoT (Automatic Chain-of-Thought)

**Proposito:** Documentar el proceso de ejecucion de una tarea mediante razonamiento paso a paso, desde la comprension del problema hasta la validacion de resultados.

**Cuando Usar:**
- Despues de completar una tarea TASK-REORG-INFRA
- Para documentar el razonamiento y decisiones tomadas
- Para registrar metricas y resultados de ejecucion
- Como evidencia de completitud de la tarea

**Secciones Principales:**
1. Resumen Ejecutivo
2. Auto-CoT: Razonamiento Paso a Paso (4 fases)
   - Fase 1: Comprension del Problema
   - Fase 2: Planificacion de Solucion
   - Fase 3: Ejecucion
   - Fase 4: Validacion de Resultados
3. Tecnicas de Prompting Aplicadas
4. Artifacts Creados
5. Metricas de Ejecucion
6. Problemas y Soluciones
7. Criterios de Aceptacion - Estado
8. Proximos Pasos

**Beneficios del Auto-CoT:**
- Documenta el PORQUE de cada decision
- Facilita revision y auditoria
- Ayuda a identificar mejoras de proceso
- Permite replicar razonamiento en tareas futuras

---

### 2. PLANTILLA-VALIDACION-COMPLETITUD.md

**Tecnica Aplicada:** Self-Consistency (Validacion Multiple)

**Proposito:** Validar completitud de una tarea desde multiples perspectivas independientes para asegurar consistencia y calidad.

**Cuando Usar:**
- Para validar que una tarea esta realmente completa
- Antes de marcar una tarea como COMPLETADA
- Para identificar gaps o inconsistencias
- Como validacion de calidad independiente

**Perspectivas de Validacion:**
1. **P1: Validacion de Existencia** - Los artifacts existen fisicamente?
2. **P2: Validacion de Estructura** - Tienen la estructura correcta?
3. **P3: Validacion de Contenido** - El contenido es completo y coherente?
4. **P4: Validacion de Calidad** - Cumplen estandares de calidad?
5. **P5: Validacion Self-Consistency** - Son consistentes entre perspectivas?
6. **P6: Validacion de Criterios** - Se cumplen criterios de aceptacion?

**Secciones Principales:**
1. 6 Perspectivas de Validacion (cada una con criterios especificos)
2. Matriz de Validacion Cruzada
3. Score de Completitud (ponderado)
4. Resumen de Validacion (hallazgos, debilidades, riesgos)
5. Acciones Correctivas
6. Validacion Final (APROBAR/APROBAR CON EXCEPCIONES/RECHAZAR)

**Beneficios del Self-Consistency:**
- Detecta inconsistencias no obvias
- Valida desde multiples angulos
- Reduce riesgo de aprobar trabajo incompleto
- Proporciona confianza objetiva en completitud

---

### 3. PLANTILLA-CHECKLIST-TAREAS.md

**Tecnica Aplicada:** Auto-CoT + Self-Consistency (Combinadas)

**Proposito:** Guiar la ejecucion de una tarea paso a paso, combinando razonamiento logico (Auto-CoT) con validacion multiple (Self-Consistency).

**Cuando Usar:**
- ANTES de empezar una tarea (como guia de ejecucion)
- DURANTE la tarea (para tracking de progreso)
- DESPUES de la tarea (como evidencia de completitud)
- Como herramienta de planificacion y control

**Fases del Checklist:**
1. **FASE 1: Preparacion (Auto-CoT)**
   - Comprension del Problema
   - Recoleccion de Informacion
   - Planificacion de Estrategia
   - Preparacion de Entorno

2. **FASE 2: Ejecucion (Auto-CoT Paso a Paso)**
   - Sub-tareas individuales
   - Comandos ejecutados
   - Validaciones inmediatas
   - Razonamiento documentado

3. **FASE 3: Validacion (Self-Consistency)**
   - Validacion de Existencia
   - Validacion de Estructura
   - Validacion de Contenido
   - Validacion de Calidad
   - Validacion de Criterios
   - Validacion Self-Consistency

4. **FASE 4: Documentacion de Evidencias**
   - Crear archivos de evidencia
   - Actualizar documentacion

5. **FASE 5: Finalizacion**
   - Revision final
   - Commit y Push
   - Notificacion y Handoff

**Secciones Adicionales:**
- Resumen de Metricas (tiempo, completitud, calidad)
- Problemas Encontrados
- Lecciones Aprendidas
- Estado Final

**Beneficios de Combinacion:**
- Auto-CoT guia el razonamiento en preparacion y ejecucion
- Self-Consistency valida desde multiples perspectivas
- Checklist asegura que no se olvida ningun paso critico
- Sirve tanto como guia prospectiva como evidencia retrospectiva

---

## Como Usar las Plantillas

### Flujo de Trabajo Recomendado

```
INICIO DE TAREA
    |
    v
1. Copiar PLANTILLA-CHECKLIST-TAREAS.md
   a: TASK-REORG-INFRA-XXX/evidencias/CHECKLIST-TAREAS.md
    |
    v
2. Personalizar CHECKLIST-TAREAS.md
   - Reemplazar [CORCHETES]
   - Definir sub-tareas especificas
   - Establecer validaciones
    |
    v
3. Ejecutar tarea siguiendo CHECKLIST
   - Marcar [x] items completados
   - Documentar razonamiento Auto-CoT
   - Registrar problemas/soluciones
    |
    v
4. Validar con CHECKLIST (Fase 3)
   - Ejecutar TODAS las validaciones
   - Registrar resultados PASS/FAIL
    |
    v
5. Crear RESUMEN-EJECUCION.md
   (usando PLANTILLA-RESUMEN-EJECUCION.md)
   - Documentar Auto-CoT completo
   - Registrar metricas
   - Listar artifacts creados
    |
    v
6. Crear VALIDACION-COMPLETITUD.md
   (usando PLANTILLA-VALIDACION-COMPLETITUD.md)
   - Validar desde 6 perspectivas
   - Calcular score de completitud
   - Emitir recomendacion final
    |
    v
7. Revision Final
   - Si score >= 90: APROBAR
   - Si score 75-89: APROBAR CON EXCEPCIONES
   - Si score < 75: RECHAZAR (retrabajo)
    |
    v
FIN DE TAREA
```

---

## Estructura Esperada de Evidencias

Para cada TASK-REORG-INFRA-XXX, la carpeta evidencias/ deberia contener:

```
TASK-REORG-INFRA-XXX/
├── README.md                           (Descripcion de la tarea)
└── evidencias/
    ├── CHECKLIST-TAREAS.md             (Guia + tracking de ejecucion)
    ├── RESUMEN-EJECUCION.md            (Auto-CoT: razonamiento documentado)
    ├── VALIDACION-COMPLETITUD.md       (Self-Consistency: validacion multiple)
    ├── [evidencia-especifica-1.txt]    (Outputs, logs, capturas)
    ├── [evidencia-especifica-2.log]
    └── [evidencia-especifica-N]
```

**Archivos Obligatorios:**
- CHECKLIST-TAREAS.md (siempre)
- RESUMEN-EJECUCION.md (siempre)
- VALIDACION-COMPLETITUD.md (siempre)

**Archivos Opcionales:**
- Evidencias especificas segun tipo de tarea (logs, outputs, screenshots, etc)

---

## Tecnicas de Prompting Explicadas

### Auto-CoT (Automatic Chain-of-Thought)

**Concepto:** Documentar el razonamiento paso a paso, no solo el resultado.

**Preguntas Clave:**
- Que estoy tratando de resolver? (Problema)
- Por que es importante? (Justificacion)
- Como lo voy a resolver? (Estrategia)
- Que hice en cada paso? (Ejecucion)
- Como valido que funciono? (Verificacion)

**Formato Tipico:**
```
Paso 1: [Accion]
- [Razonamiento: por que este paso]
- [Comando/Herramienta: que use]
- [Resultado: que obtuve]
- [Validacion: como verifique]
```

**Beneficios:**
1. Transparencia de razonamiento
2. Facilita auditoria y revision
3. Permite replicar logica en tareas similares
4. Identifica gaps en razonamiento

**Ejemplo Real:**
```
Paso 1: Verificar estado actual
- Razonamiento: Necesito saber que archivos existen antes de mover
- Comando: find docs/infraestructura -name "*.md" -maxdepth 1
- Resultado: 15 archivos .md en raiz
- Validacion: Comparar con lista esperada (15 = 15, OK)
```

---

### Self-Consistency (Validacion Multiple)

**Concepto:** Un resultado es valido si se confirma desde multiples perspectivas independientes.

**Principio:** Si valido algo desde 6 perspectivas diferentes y todas coinciden, tengo alta confianza en el resultado.

**Perspectivas Comunes:**
1. Existencia fisica (el archivo existe?)
2. Estructura interna (tiene el formato correcto?)
3. Contenido (es completo y coherente?)
4. Calidad (cumple estandares?)
5. Consistencia cruzada (no hay contradicciones?)
6. Criterios (cumple requisitos originales?)

**Formato Tipico:**
```
Pregunta: Esta el archivo X completo?

Perspectiva A (Existencia): SI - El archivo existe en disco
Perspectiva B (Estructura): SI - Tiene frontmatter + 5 secciones
Perspectiva C (Contenido): SI - Todas las secciones tienen contenido
Perspectiva D (Calidad): SI - Sin errores de formato
Perspectiva E (Consistencia): SI - Coherente con otros archivos
Perspectiva F (Criterios): SI - Cumple criterio de aceptacion #3

Resultado: CONSISTENTE - Alta confianza que esta completo
```

**Beneficios:**
1. Reduce falsos positivos (marcar como completo algo incompleto)
2. Detecta inconsistencias sutiles
3. Proporciona confianza objetiva
4. Identifica gaps especificos

**Ejemplo Real:**
```
Validacion de README.md de carpeta "catalogos/"

P1 (Existencia):     PASS - docs/infraestructura/catalogos/README.md existe
P2 (Estructura):     PASS - Tiene frontmatter YAML + 5 secciones
P3 (Contenido):      PASS - Proposito documentado, contenido esperado listado
P4 (Calidad):        PASS - Sin emojis, formato markdown valido
P5 (Consistencia):   PASS - Consistente con otros 12 READMEs
P6 (Criterios):      PASS - Cumple criterio "cada carpeta tiene README"

Score: 6/6 (100%) - APROBADO
```

---

## Mejores Practicas

### Para Auto-CoT:

1. **Documenta DURANTE, no DESPUES**
   - Escribe razonamiento mientras ejecutas, no al final
   - Es mas preciso y captura detalles que olvidarias

2. **Se Especifico**
   - No digas "ejecute comandos" - di CUALES comandos
   - No digas "funciono" - di COMO validaste que funciono

3. **Incluye PORQUE**
   - No solo QUE hiciste, sino POR QUE lo hiciste
   - Explica decisiones y alternativas consideradas

4. **Valida Cada Paso**
   - Cada paso debe tener validacion inmediata
   - No avances sin confirmar que funciono

---

### Para Self-Consistency:

1. **No Saltes Perspectivas**
   - Ejecuta TODAS las perspectivas, no solo algunas
   - Cada perspectiva aporta valor unico

2. **Se Objetivo**
   - PASS significa "cumple completamente"
   - FAIL significa "no cumple o cumple parcialmente"
   - No hay medias tintas

3. **Documenta Evidencia**
   - Cada validacion debe tener evidencia verificable
   - Comandos ejecutados, outputs observados

4. **Calcula Scores Honestamente**
   - No infles scores para "pasar"
   - Score < 90 indica areas de mejora reales

---

### Para Uso General de Plantillas:

1. **Personaliza, No Uses Tal Cual**
   - Las plantillas son punto de partida
   - Adapta a necesidades especificas de tu tarea

2. **Elimina Secciones No Aplicables**
   - Si algo no aplica, eliminalo (no dejes placeholder)
   - Marca secciones [OPCIONAL] claramente

3. **Actualiza Conforme Avanzas**
   - No llenes todo al final
   - Actualiza checklist y evidencias en tiempo real

4. **No Uses Emojis**
   - Mantiene profesionalismo
   - Facilita parsing automatico

5. **Se Consistente**
   - Usa mismas plantillas para todas las tareas TASK-REORG-INFRA
   - Facilita comparacion y analisis

---

## Ejemplos de Uso

### Ejemplo 1: TASK-REORG-INFRA-003 (Crear READMEs)

**Evidencias Generadas:**
- `CHECKLIST-TAREAS.md` - Tracking de creacion de 13 READMEs
- `RESUMEN-EJECUCION.md` (TAREA-COMPLETADA.md) - Auto-CoT aplicado
- `VALIDACION-COMPLETITUD.md` (validacion-readmes.md) - 13/13 READMEs validados
- `readmes-creados.txt` - Listado de artifacts

**Score Final:** 100% (13/13 READMEs completos y validados)

Ver: `docs/infrastructure/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-003-crear-readmes-carpetas-nuevas/evidencias/`

---

### Ejemplo 2: TASK-REORG-INFRA-004 (Mapeo de Migracion)

**Evidencias Generadas:**
- `PROCESO-AUTO-COT-SELF-CONSISTENCY.md` - Razonamiento completo documentado
- Matriz de 24 entradas con mapeo completo
- Analisis de duplicados
- Validaciones exhaustivas

**Tecnicas Aplicadas:**
- Auto-CoT: 7 pasos de razonamiento sobre categorización
- Self-Consistency: Inventario exhaustivo, validacion de duplicados, coherencia
- Tabular CoT: Matriz estructurada de decisiones
- Tree-of-Thought: Estructura jerarquica de directorios

Ver: `docs/infrastructure/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-004-mapeo-migracion-documentos/evidencias/`

---

## Preguntas Frecuentes

### Q1: Debo usar las 3 plantillas para cada tarea?

**A:** Si. Las 3 plantillas son complementarias:
- CHECKLIST: Guia durante ejecucion
- RESUMEN-EJECUCION: Documenta razonamiento post-ejecucion
- VALIDACION-COMPLETITUD: Valida calidad antes de aprobar

### Q2: Puedo modificar las plantillas?

**A:** Si, pero mantiene las secciones core:
- Auto-CoT: Razonamiento paso a paso
- Self-Consistency: Validacion multiple (minimo 3 perspectivas)
- Frontmatter YAML
- Metricas cuantificables

### Q3: Que hago si una validacion falla (FAIL)?

**A:**
1. Documenta el fallo especificamente
2. Identifica causa raiz
3. Corrige el problema
4. Re-ejecuta validacion
5. Si persiste, escala a stakeholder

### Q4: Cuanto tiempo toma llenar las plantillas?

**A:** Estimacion tipica:
- CHECKLIST: Actualizar durante ejecucion (overhead ~10%)
- RESUMEN-EJECUCION: 20-30 minutos post-tarea
- VALIDACION-COMPLETITUD: 15-20 minutos de validacion

**Total:** ~30-50 minutos de documentacion por tarea

**Beneficio:** Evidencia auditables, reduccion de retrabajo, mejora continua

### Q5: Que es un buen score de completitud?

**A:** Interpretacion:
- 90-100: Excelente (aprobar sin reservas)
- 75-89: Bueno (aprobar con seguimiento menor)
- 60-74: Aceptable (requiere mejoras)
- < 60: Insuficiente (rechazar, requiere retrabajo)

---

## Mantenimiento de Plantillas

**Responsable:** QA Infrastructure Team

**Actualizar cuando:**
- Se identifican mejoras de proceso
- Se agregan nuevas tecnicas de prompting
- Se detectan gaps en plantillas actuales
- Feedback de usuarios indica confusion

**Versionado:**
- Version actual: 1.0.0 (2025-11-18)
- Cambios mayores incrementan primera cifra (2.0.0)
- Cambios menores incrementan segunda cifra (1.1.0)
- Correcciones incrementan tercera cifra (1.0.1)

**Historial de Cambios:**
- 2025-11-18: v1.0.0 - Creacion inicial de 3 plantillas

---

## Referencias

### Documentos Relacionados

- [PROCESO-AUTO-COT-SELF-CONSISTENCY.md](../TASK-REORG-INFRA-004-mapeo-migracion-documentos/evidencias/PROCESO-AUTO-COT-SELF-CONSISTENCY.md) - Ejemplo completo de aplicacion
- [TASK-REORG-INFRA-003 evidencias/](../TASK-REORG-INFRA-003-crear-readmes-carpetas-nuevas/evidencias/) - Ejemplo de evidencias completas
- [LISTADO-COMPLETO-TAREAS.md](../LISTADO-COMPLETO-TAREAS.md) - Lista de todas las tareas TASK-REORG-INFRA

### Tecnicas de Prompting

- Auto-CoT: Chain-of-Thought prompting automatico
- Self-Consistency: Validacion mediante multiples perspectivas
- Tabular CoT: Estructuracion de razonamiento en tablas
- Tree-of-Thought: Razonamiento jerarquico

---

**Ultima Actualizacion:** 2025-11-18
**Version:** 1.0.0
**Responsable:** QA Infrastructure Team
**Estado:** Activo
