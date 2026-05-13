```yml
type: Metodología (opción dentro de PHASE 4: STRUCTURE)
category: Desarrollo Guiado por Especificaciones
version: 1.0
purpose: Metodología en 4 pasos (Requirements, Design, Tasks, Validation) para features complejas.
goal: Proporcionar proceso estructurado cuando Phase 4 requiere especificación detallada.
updated_at: 2026-03-25
owner: workflow-structure
```

# Spec-Driven Development

## Propósito

Metodología completa para desarrollo en 4 fases: Requirements, Design, Tasks, Validation.

> Objetivo: Proporcionar proceso estructurado para features complejas.

---

Metodología para trabajo complejo que requiere planificación estructurada. Aplica 4 fases: Requirements → Design → Tasks → Implementation.

---

## Tabla de Contenidos

- [Cuando Usar Spec-Driven Development](#cuando-usar-spec-driven-development)
- [Decision Framework: ¿Necesito Spec-Driven Development?](#decision-framework-necesito-spec-driven-development)
- [Trigger Patterns](#trigger-patterns)
- [Self-Check Before Starting Spec-Driven](#self-check-before-starting-spec-driven)
- [Templates Disponibles](#templates-disponibles)
- [Workflow Completo (4 Fases)](#workflow-completo-4-fases)
- [Convenciones de Naming](#convenciones-de-naming)
- [Mejores Prácticas](#mejores-pr�cticas)
- [Ejemplo Completo Real](#ejemplo-completo-real)
- [Problema](#problema)
- [Objetivos](#objetivos)
- [Requisitos Funcionales](#requisitos-funcionales)
- [Restricciones](#restricciones)
- [Decisión Arquitectónica](#decision-arquitectonica)
- [Estructura](#estructura)
- [Plan de Testing](#plan-de-testing)
- [TASK-001: Preparar directorios](#task-001-preparar-directorios)
- [TASK-002: Copiar originales](#task-002-copiar-originales)
- [TASK-003: Traducir index.rst](#task-003-traducir-index.rst)
- [TASK-004: Traducir quality_tree.rst](#task-004-traducir-quality_tree.rst)
- [TASK-005-007: Traducir scenas.rst, appendix.rst, etc](#task-005-007-traducir-scenas.rst-appendix.rst-etc)
- [TASK-008: Validación final](#task-008-validacion-final)
- [Checkpoints](#checkpoints)
- [Rollback](#rollback)
- [Integración con THYROX](#integracion-con-thyrox)
- [FAQ](#faq)
- [Ver También](#ver-tambien)

---


## Cuando Usar Spec-Driven Development

Usar cuando:
- Features complejas
- Cambios arquitectónicos
- Traducciones grandes (multi-sección)
- Refactorings importantes
- Implementación de workflows nuevos
- Trabajo que afecta múltiples componentes

---

## Decision Framework: ¿Necesito Spec-Driven Development?

**Usa este framework para decidir si aplicar metodología spec-driven**:

1. **¿El trabajo tomará >2 horas?**
   → Sí, usar spec-driven (planificación vale la pena)

2. **¿Hay múltiples pasos o fases?**
   → Sí, spec-driven (estructura 4 fases ayuda)

3. **¿Afecta arquitectura o estructura importante?**
   → Sí, spec-driven (diseño crítico)

4. **¿Necesitas aprobación o revisión antes de implementar?**
   → Sí, spec-driven (specs documentadas facilitan)

5. **¿Es cambio simple de 1 archivo <30 min?**
   → No, hacerlo directamente sin spec-driven

6. **¿Ya sabes exactamente cómo implementar?**
   → Depende: si complejo aún así usa spec-driven

7. **¿Hay riesgo de regresiones o efectos secundarios?**
   → Sí, spec-driven (plan de testing)

8. **¿Necesitas tracking de progreso en múltiples sesiones?**
   → Sí, spec-driven (tasks estructuradas)

**Regla de oro**: **>2 horas O complejo → spec-driven**

---

## Trigger Patterns

### Señales Explícitas
- Usuario dice: "vamos a implementar X"
- Usuario dice: "necesito planificar..."
- Usuario menciona: "feature", "proyecto grande", "cambio arquitectónico"
- Usuario pregunta: "¿cómo organizo esto?"
- Trabajo claramente multi-fase o multi-sesión

### Señales Implícitas
- Usuario describe trabajo complejo
- Múltiples componentes afectados
- Usuario usa tiempo futuro ("vamos a...", "implementaremos...")
- Contexto indica planificación necesaria
- Usuario menciona riesgos o incertidumbre

### Trigger Words
- "feature", "proyecto", "implementar", "desarrollar"
- "planificar", "diseñar", "especificar"
- "cambio arquitectónico", "refactoring grande"
- "traducción multi-sección", "workflow nuevo"

**Anti-triggers** (NO usar spec-driven):
- Hotfix urgente (<30 min)
- Cambio trivial de 1-2 líneas
- "fix rápido", "typo", "cambio menor"
- Usuario ya tiene plan completo claro
- Experimentación rápida (usar branches temporales)

---

## Self-Check Before Starting Spec-Driven

**OBLIGATORIO antes de iniciar metodología**:

### Pre-Planning Checks
- [ ] ¿El trabajo tomará >2 horas?
- [ ] ¿Es suficientemente complejo para justificar planificación?
- [ ] ¿Tengo tiempo para hacer las 4 fases correctamente?
- [ ] ¿Tengo claro el objetivo general?

**Si NO a mayoría → Considerar hacerlo directamente sin spec-driven**

### During Spec-Driven Checks

**FASE 1 (Requirements)**:
- [ ] ¿Documenté contexto y problema?
- [ ] ¿Definí objetivos claros y medibles?
- [ ] ¿Listé requisitos funcionales?
- [ ] ¿Especifiqué criterios de aceptación?

**FASE 2 (Design)**:
- [ ] ¿Propuse solución técnica?
- [ ] ¿Documenté alternativas consideradas?
- [ ] ¿Identifiqué archivos a modificar/crear?
- [ ] ¿Tengo plan de implementación?

**FASE 3 (Tasks)**:
- [ ] ¿Descompuse en tareas atómicas?
- [ ] ¿Cada tarea tiene criterio de "done"?
- [ ] ¿Ordené tareas por dependencias?
- [ ] ¿Estimé tiempos realistas?

**FASE 4 (Implementation)**:
- [ ] ¿Sigo el plan documentado?
- [ ] ¿Marco tareas como completadas?
- [ ] ¿Hago commits por tarea?
- [ ] ¿Valido después de cada tarea?

**Si NO en cualquier fase → PAUSE - Completar antes de continuar**

### Post-Implementation Checks
- [ ] ¿Todas las tareas marcadas como done?
- [ ] ¿Los criterios de aceptación se cumplen?
- [ ] ¿Documenté decisiones importantes?
- [ ] ¿El trabajo está completado según specs?

**Si NO → COMPLETAR antes de cerrar proyecto**

---

## Templates Disponibles

### 1. requirements-specification.md.template

**Propósito**: Definir QUÉ se necesita (PHASE 1: ANALYZE)

**Contenido**:
- Contexto y problema
- Objetivos (principal + secundarios)
- Requisitos funcionales (RF)
- Requisitos no funcionales (RNF)
- Restricciones
- Fuera de alcance
- Stakeholders
- Referencias

**Cuándo usar**: Al iniciar análisis de requisitos

**Ubicación**: [requirements-specification.md.template](../assets/requirements-specification.md.template)

---

### 1b. requirements-specification.md.template

**Propósito**: Definir CÓMO se implementan los requisitos (PHASE 4: STRUCTURE)

**Contenido**:
- Mapeo análisis → especificación
- Criterios de aceptación
- Consideraciones técnicas
- Componentes afectados
- Esfuerzo estimado
- Validación y aprobaciones

**Cuándo usar**: Al estructurar implementación técnica

**Ubicación**: [requirements-specification.md.template](../assets/requirements-specification.md.template)

---

### 2. design.md.template

**Propósito**: Definir CÓMO se implementará (PHASE 4: STRUCTURE)

**Contenido**:
- Visión general de la solución
- Decisiones arquitectónicas (DA)
- Componentes afectados
- Estructura de archivos
- Interfaces y contratos
- Dependencias
- Impacto (breaking changes, migración)
- Plan de rollback
- Testing
- Referencias

**Cuándo usar**: Después de aprobación de requirements

**Ubicación**: [design.md.template](../assets/design.md.template)

---

### 3. tasks.md.template

**Propósito**: Definir pasos EXACTOS de implementación (FASE 3)

**Contenido**:
- Resumen de tareas
- Tareas organizadas por fases (Preparación, Core, Validación)
- Cada tarea con:
  * Descripción
  * Archivos afectados
  * Comandos exactos
  * Criterios de éxito
  * Dependencias
  * Estimación
- Orden de ejecución
- Checkpoints de validación
- Rollback points
- Notas

**Cuándo usar**: Después de aprobación de design

**Ubicación**: [tasks.md.template](../assets/tasks.md.template)

---

## Workflow Completo (4 Fases)

### FASE 1: Requirements (Definir QUE)

**Objetivo**: Documento claro de qué se necesita

**Pasos**:
1. Usar [requirements-specification.md.template](../assets/requirements-specification.md.template)
2. Completar:
   - Contexto y problema
   - Objetivos claros
   - Requisitos funcionales (RF)
   - Requisitos no funcionales (RNF)
   - Restricciones
   - Fuera de alcance
3. **SOLICITAR APROBACION AL USUARIO**
4. **NO CONTINUAR SIN APROBACION EXPLICITA**

---

### FASE 2: Design (Definir COMO)

**Objetivo**: Documento técnico de cómo se implementará

**Pasos**:
1. Basarse en requirements aprobados
2. Usar [design.md.template](../assets/design.md.template)
3. Completar:
   - Visión general de la solución
   - Decisiones arquitectónicas (DA)
   - Componentes afectados
   - Estructura de archivos
   - Interfaces y contratos
   - Plan de testing
   - Plan de rollback
4. **SOLICITAR APROBACION AL USUARIO**
5. **NO CONTINUAR SIN APROBACION EXPLICITA**

---

### FASE 3: Tasks (Definir pasos EXACTOS)

**Objetivo**: Documento ejecutable con todos los pasos

**Pasos**:
1. Basarse en design aprobado
2. Usar [tasks.md.template](../assets/tasks.md.template)
3. Completar:
   - Desglosar en tareas atómicas (15-30 tasks típicamente)
   - Cada task con descripción, archivos, comandos exactos
   - Criterios de éxito claros
   - Dependencias entre tasks
   - Estimaciones realistas
   - Checkpoints de validación
   - Rollback points
4. **SOLICITAR APROBACION AL USUARIO**
5. **NO CONTINUAR SIN APROBACION EXPLICITA**

---

### FASE 4: Implementation (EJECUTAR)

**Objetivo**: Ejecutar plan documentado

**Pasos**:
```
Para cada TASK (en orden):

1. Anunciar: "EJECUTANDO TASK-XXX: [nombre]"

2. Seguir pasos EXACTOS de tasks

3. Validar criterios de éxito

4. Commit (si indicado):
   git add [archivos]
   git commit -m "feat(scope): implement TASK-XXX - [nombre]"

5. Marcar como completada

Si tarea falla:
  - Diagnosticar
  - Decidir: fix inmediato, pausar, o rollback
  - Documentar problema

Si design insuficiente:
  - Pausar
  - Volver a FASE 2
  - Actualizar design y tasks
  - Re-aprobar
  - Continuar
```

---

## Convenciones de Naming

### Estructura de Documentos

Nombre archivo: `YYYY-MM-DD-HH-MM-titulo.md`
- YYYY-MM-DD: Fecha inicio
- HH-MM: Hora/minuto
- titulo: Kebab-case, max 50 chars

Ejemplos:
- 2026-01-28-09-10-requirements-traducir-architecture-docs-sec-10.md
- 2026-01-28-10-00-design-traducir-architecture-docs-sec-10.md
- 2026-01-28-10-30-tasks-traducir-architecture-docs-sec-10.md

### Identificadores

**RF**: Requisito Funcional (RF-001, RF-002, etc)
**RNF**: Requisito No Funcional (RNF-001, etc)
**DA**: Decisión Arquitectónica (DA-001, etc)
**TASK**: Tarea de implementación (TASK-001, etc)
**TC**: Test Case (TC-001, etc)

### Estados

- Draft: En elaboración
- Review: En revisión
- Approved: Aprobado para implementación
- In Progress: En implementación
- Completed: Completado

---

## Mejores Prácticas

### FASE 1: Requirements
- Ser exhaustivo: Listar TODOS los requisitos
- Criterios medibles: "Debe..." no "Debería..."
- Restricciones claras: Limitar alcance
- Stakeholders identificados: Quién aprueba qué

### FASE 2: Design
- Alternativas documentadas: Explicar por qué se eligió una solución
- Decisiones justificadas: DA con contexto claro
- Impacto claro: Breaking changes, migraciones
- Rollback plan: Siempre tener plan B

### FASE 3: Tasks
- Tareas atómicas: Una tarea = un cambio lógico
- Criterios específicos: Cómo validar "done"
- Dependencias explícitas: Order matters
- Estimaciones realistas: +20% buffer para incertidumbre

### FASE 4: Implementation
- Seguir plan documentado: Variaciones documentadas
- Commits frecuentes: Después de 2-3 tasks
- Checkpoints rigurosos: Validar siempre
- Documentar decisiones: Si ajustas plan, explica por qué

---

## Ejemplo Completo Real

### Proyecto: Traducir architecture docs Section 10

**2026-01-28-09-10-requirements-traducir-architecture-docs-sec-10.md**
```markdown
# Requirements: Traducir architecture docs Section 10

## Problema
Documentación en inglés, necesitamos versión en español para usuarios internos.

## Objetivos
Principal: Traducir sección 10 Quality Requirements de architecture docs a español
Secundarios: Validar con SMEs, generar metadata

## Requisitos Funcionales

RF-001: Traducir todos los archivos
- Criterio: 100% de contenido traducido, calidad alta

RF-002: Generar metadata
- Criterio: Metadata JSON válido con versiones

RF-003: Validación de build
- Criterio: Sphinx build sin errores

## Restricciones
- Usar modo Alta Fidelidad (no simplificar tecnicismos)
- Mantener estructura original
- Preservar cross-references
```

**2026-01-28-10-00-design-traducir-architecture-docs-sec-10.md**
```markdown
# Design: Traducir architecture docs Section 10

Basado en: requirements (aprobado 2026-01-28-09-30)

## Decisión Arquitectónica

DA-001: Usar modo Alta Fidelidad
- Contexto: Es especificación técnica
- Decision: Alta Fidelidad (traducción muy fiel)
- Razon: Requiere precisión máxima
- Consecuencias: Toma más tiempo, mejor calidad

## Estructura

```
sections/10_quality_requirements/
├── original/
├── traduccion/
│   ├── index.rst
│   ├── quality_tree.rst
│   └── scenarios.rst
└── analisis_seccion.json
```

## Plan de Testing

TC-001: Traducción completa
- Validar: Todos los párrafos traducidos

TC-002: Build sin errores
- Validar: make html exitoso

TC-003: Cross-references validas
- Validar: linkcheck pasando
```

**2026-01-28-10-30-tasks-traducir-architecture-docs-sec-10.md**
```markdown
# Tasks: Traducir architecture docs Section 10

Total tareas: 8
Estimación total: 6 horas

## TASK-001: Preparar directorios
- Archivos: Ninguno (solo mkdir)
- Comandos:
  ```bash
  mkdir -p sections/10_quality_requirements/original
  mkdir -p sections/10_quality_requirements/traduccion
  ```
- Criterios: Directorios existen
- Estimación: 5 min

## TASK-002: Copiar originales
- Archivos: source/architecture/... → sections/10_quality_requirements/original/
- Criterios: Archivos copiados sin cambios
- Estimación: 10 min

## TASK-003: Traducir index.rst
- Archivos: sections/10_quality_requirements/traduccion/index.rst (NEW)
- Criterios:
  - Archivo existe
  - Traducción 100%
  - Build sin errores
- Estimación: 1.5 horas
- Dependencias: TASK-001, TASK-002

## TASK-004: Traducir quality_tree.rst
... (similar estructura)

## TASK-005-007: Traducir scenas.rst, appendix.rst, etc
... (continuar)

## TASK-008: Validación final
- Comandos:
  ```bash
  make clean html
  make linkcheck
  ```
- Criterios: Ambos comandos exit code 0
- Dependencias: TASK-001 a TASK-007

## Checkpoints

CHECKPOINT-1: Después TASK-003
- Validar: Build sin errores

CHECKPOINT-2: Después TASK-006
- Validar: 70% completo, preview disponible

## Rollback

Si falla TASK-004:
- git revert commits TASK-003 a TASK-004
- Revisar original, ajustar approach
```

**FASE 4: Implementation**
```
EJECUTANDO TASK-001: Preparar directorios
[Crear directorios]
+TASK-001 completada

EJECUTANDO TASK-002: Copiar originales
[Copiar archivos]
+TASK-002 completada

EJECUTANDO TASK-003: Traducir index.rst
[Traducir contenido con ArchitectureTranslator]
[Validar build]
+TASK-003 completada
git commit -m "feat(architecture-docs): implement TASK-003 - translate section 10 index"

... continuar hasta TASK-008

EJECUTANDO TASK-008: Validación final
[Ejecutar make clean html, linkcheck]
+Todos los tests pasan
+Proyecto completado

git commit -m "feat(architecture-docs): implement TASK-008 - final validation section 10 complete"
```

---

## Integración con THYROX

Spec-Driven Development es **OPCION dentro de PHASE 4: STRUCTURE** de THYROX.

**Flujo**:
1. User: "Voy a trabajar en una feature compleja"
2. PHASE 4: STRUCTURE → Ofrece dos opciones:
   - Simple: PRD básico (para trabajo pequeño)
   - Complejo: Spec-Driven (para trabajo grande/riesgoso)
3. User: "Es complejo, necesito planificación detallada"
4. Claude: Use Spec-Driven Development
5. Execute 4 fases con templates
6. At end → Use PHASE 6: EXECUTE para implementar

---

## FAQ

**Q: ¿Las 4 fases siempre toman mucho tiempo?**

A: Depende:
- Requirements: 30 min - 1 hora
- Design: 45 min - 2 horas
- Tasks: 30 min - 1.5 horas
- Implementation: Varía según complejidad
- Total setup: 2-4 horas para trabajo de 8+ horas

**Q: ¿Puedo saltarme alguna fase?**

A: No. Las 4 fases son secuenciales y dependen una de la otra. Saltarse una crea problemas en implementación.

**Q: ¿Qué pasa si descubro un problema en FASE 4?**

A: 
1. Documenta el problema
2. Vuelve a FASE 2 si es design issue
3. Actualiza design y tasks
4. Re-aprueba
5. Continúa implementación

**Q: ¿Puedo hacer FASE 4 en múltiples sesiones?**

A: Sí. Tasks documentadas permiten reanudar. Marca tasks completadas en documento.

**Q: ¿Es spec-driven overhead?**

A: No. Es inversión:
- 3-4 horas de planificación
- Ahorra 5+ horas en implementación
- Cero regresiones
- Documentación para futuro
- ROI positivo

---

## Ver También

- THYROX SKILL.md - PHASE 4: STRUCTURE
- Templates en `/assets/`:
  - [requirements-specification.md.template](../assets/requirements-specification.md.template)
  - [requirements-specification.md.template](../assets/requirements-specification.md.template)
  - [design.md.template](../assets/design.md.template)
  - [tasks.md.template](../assets/tasks.md.template)
- commit-helper.md - Para commits documentados por tarea
- incremental-correction.md - Para corregir 100+ issues

---

**Última actualización**: 2026-02-01  
**Versión**: 1.2.0
