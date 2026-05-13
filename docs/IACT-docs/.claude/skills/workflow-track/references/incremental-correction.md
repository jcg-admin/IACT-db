```yml
type: Metodología PHASE 7: TRACK
category: Corrección Incremental
version: 1.0
purpose: Metodología validada para corrección de 100+ issues a gran escala con análisis obligatorio.
goal: Convertir caos de issues en correcciones organizadas y medibles.
updated_at: 2026-03-25
owner: workflow-track
```

# Incremental Correction Methodology

## Propósito

Metodología validada para corrección de 100+ issues a gran escala con análisis obligatorio.

> Objetivo: Convertir caos de issues en correcciones organizadas y medibles.

---

**Versión**: 1.4.0  
**Aplicable a**: Cualquier proyecto con corrección incremental de issues (100+ issues)

---

## Tabla de Contenidos

- [Cuándo Usar Esta Metodología](#cu�ndo-usar-esta-metodologia)
- [Decision Framework: ¿Manual vs Script?](#decision-framework-manual-vs-script)
- [Trigger Patterns](#trigger-patterns)
- [Self-Check Before Starting Correction](#self-check-before-starting-correction)
- [Templates Para Documentar el Proceso](#templates-para-documentar-el-proceso)
- [Workflow Completo](#workflow-completo)
- [Cómo Usar los Templates](#como-usar-los-templates)
- [Mejores Prácticas](#mejores-pr�cticas)
- [Filosofía Fundamental](#filosofia-fundamental)
- [Beneficios de la Metodología](#beneficios-de-la-metodologia)
- [Ejemplo de Proyecto Real](#ejemplo-de-proyecto-real)
- [Integración con THYROX](#integracion-con-thyrox)
- [FAQ](#faq)
- [Ver También](#ver-tambien)

---


## Cuándo Usar Esta Metodología

Use esta metodología cuando necesite:

- [OK] Corregir 100+ issues en un proyecto
- [OK] Decidir entre manual vs automatizado
- [OK] Estructurar proceso de corrección a gran escala
- [OK] Evitar introducir regresiones
- [OK] Documentar decisiones y aprendizajes
- [OK] Balancear velocidad vs calidad

**NO use esta metodología para**:
- [ERROR] Correcciones puntuales (<10 issues)
- [ERROR] Issues de complejidad uniforme
- [ERROR] Cuando velocidad es la única prioridad

---

## Decision Framework: ¿Manual vs Script?

**Usa este framework para decidir tu enfoque de corrección**:

1. **¿Los issues son 100% idénticos (mismo patrón, mismo fix)?**
   → SÍ: Considerar script (SI cumples las 8 Protecciones)
   → NO: Manual OBLIGATORIO

2. **¿Puedes describir el fix en 1 línea de código?**
   → SÍ: Script PUEDE ser seguro
   → NO: Manual (fix complejo)

3. **¿Has validado el fix en 3-5 archivos manualmente primero?**
   → SÍ: Script puede proceder
   → NO: Hacer validación manual primero

4. **¿Cumples TODAS las 8 Protecciones?**
   → SÍ: Script seguro permitido
   → NO: Manual OBLIGATORIO

5. **¿Tienes prisa o presión de tiempo?**
   → SÍ: Manual (paradójicamente más rápido a largo plazo)
   → NO: Evaluar manual vs script

6. **¿Ya tuviste problemas con scripts antes?**
   → SÍ: Manual SIEMPRE
   → NO: Evaluar cuidadosamente

**Regla de oro**: **Si dudas entre manual y script → MANUAL**

**Regla de realidad**: Scripts "rápidos" sin protecciones SIEMPRE terminan en desastre.

---

## Trigger Patterns

### Señales Explícitas (100% usar esta metodología)

- Usuario dice: "tengo 100+ errores/warnings"
- Usuario dice: "necesito corregir muchos issues"
- Usuario dice: "¿debería usar un script?"
- Usuario pregunta: "¿manual o automatizado?"
- Usuario menciona: "corrección a gran escala"

### Señales Implícitas (muy probable)

- Build muestra 100+ WARNING/ERROR
- Usuario menciona "muchos" errores sin número específico
- Usuario pregunta sobre "estrategia" de corrección
- Usuario está evaluando tiempo vs calidad
- Contexto indica proyecto con deuda técnica

### Trigger Words Clave

**Palabras de escala**:
- "muchos", "100+", "cientos", "masivo"
- "gran escala", "bulk", "batch"
- "todos los", "automatizar"

**Palabras de metodología**:
- "estrategia", "approach", "metodología"
- "manual vs script", "automatizado"
- "incremental", "paso a paso"

**Palabras de problema**:
- "WARNING", "ERROR", "issues", "deuda técnica"
- "regresiones", "rompí", "empeoré"

**Anti-triggers** (NO usar si solo dicen):
- "tengo 5 errores" (<10 issues)
- "¿qué es un WARNING?" (solo información)
- "¿cómo funciona Sphinx?" (contexto general)

---

## Self-Check Before Starting Correction

**OBLIGATORIO antes de corregir ANY issue**:

### Pre-Análisis (FASE 0)
- [ ] ¿Leí COMPLETO esta metodología antes de empezar?
- [ ] ¿Hice build inicial para contar issues REALES?
- [ ] ¿Tengo el número EXACTO de issues (no estimado)?
- [ ] ¿Categoricé los issues por tipo?
- [ ] ¿Identifiqué cuáles son fáciles vs difíciles?

**Si NO → STOP - Ejecutar FASE 0 primero**

### Pre-Corrección (FASE 1)
- [ ] ¿Decidí mi estrategia (manual, script, híbrido)?
- [ ] ¿Si voy a usar script, cumple las 8 Protecciones?
- [ ] ¿Tengo tiempo REALISTA estimado?
- [ ] ¿Documenté mi plan en PLAN.md?
- [ ] ¿Tengo git status limpio?

**Si NO → STOP - Completar FASE 1 primero**

### Durante Corrección (FASE 2-3)
- [ ] ¿Estoy siguiendo mi plan documentado?
- [ ] ¿Valido después de CADA corrección?
- [ ] ¿Los issues DISMINUYEN (no aumentan)?
- [ ] ¿Hago commit por cambio lógico?
- [ ] ¿Documento decisiones en tiempo real?

**Si NO → STOP - Volver al proceso correcto**

### Pre-Script (Si aplicable)
- [ ] ¿El script cumple TODAS las 8 Protecciones?
- [ ] ¿Hice DRY-RUN y revisé output?
- [ ] ¿Probé en 1 archivo primero?
- [ ] ¿Tengo plan de ROLLBACK listo?
- [ ] ¿Entiendo QUÉ hace cada línea del script?

**Si NO → STOP - NO ejecutar script**

---

## Templates Para Documentar el Proceso

Esta metodología incluye 4 templates para documentar cada fase:

### 1. analysis-phase.md.template

**Propósito**: Análisis inicial de todos los issues detectados

**Contenido**:
- Build output completo
- Categorización de issues (tipo, severidad, archivo)
- Análisis de patterns recurrentes
- Métricas iniciales
- Issues detallados por tipo

**Cuándo usar**: Inmediatamente después de detectar issues en el build

**Ubicación**: [analysis-phase.md.template](../assets/analysis-phase.md.template)

---

### 2. categorization-plan.md.template

**Propósito**: Estrategia y planificación de cómo abordar los issues en lotes

**Contenido**:
- Estrategia de categorización elegida
- Criterios de priorización
- Definición de lotes (qué issues en cada lote)
- Estimación de tiempo por lote
- Plan de validación entre lotes

**Cuándo usar**: Después de completar analysis-phase.md

**Ubicación**: `categorization-plan.md.template`

---

### 3. execution-log.md.template

**Propósito**: Log detallado de la ejecución de cada lote

**Contenido**:
- Tabla de tracking general de progreso
- Detalles de ejecución por lote (issues, archivos, comandos)
- Checkpoints de validación (build status)
- Problemas encontrados y decisiones tomadas
- Métricas de progreso
- Commits realizados

**Cuándo usar**: Durante toda la ejecución, actualizar después de cada lote

**Ubicación**: [execution-log.md.template](../../workflow-execute/assets/execution-log.md.template)

---

### 4. final-report.md.template

**Propósito**: Reporte final con resultados, métricas y lecciones aprendidas

**Contenido**:
- Resumen ejecutivo
- Métricas finales (antes vs después)
- Tabla comparativa de impacto
- Lecciones aprendidas
- Issues no resueltos (si aplica)
- Recomendaciones para futuro
- Conclusiones y próximos pasos

**Cuándo usar**: Al completar todos los lotes

**Ubicación**: [final-report.md.template](../assets/final-report.md.template)

---

## Workflow Completo

```
1. Detectar issues en build
   ↓
2. Crear analysis-phase.md
   - Ejecutar build completo
   - Copiar output
   - Categorizar todos los issues
   - Identificar patterns
   - Calcular métricas iniciales
   ↓
3. Crear categorization-plan.md
   - Definir estrategia (por tipo, archivo, severidad, etc.)
   - Crear lotes lógicos
   - Priorizar lotes
   - Estimar tiempo por lote
   - Establecer checkpoints de validación
   ↓
4. Crear execution-log.md
   - Iniciar con estado general
   - Por cada lote:
     * Documentar issues abordados
     * Registrar archivos modificados
     * Ejecutar comandos
     * Checkpoint de validación (build)
     * Problemas y decisiones
     * Commit
   - Actualizar métricas de progreso
   ↓
5. Crear final-report.md
   - Compilar resultados finales
   - Comparar antes vs después
   - Documentar lecciones aprendidas
   - Issues pendientes (si hay)
   - Recomendaciones futuras
   ↓
6. Proyecto completado con documentación completa
```

---

## Cómo Usar los Templates

### Paso 1: Copiar Templates

```bash
# Copiar templates según necesites
cp .claude/skills/workflow-track/assets/analysis-phase.md.template ./ANALISIS_issues_$(date +%Y-%m-%d).md
cp .claude/skills/workflow-decompose/assets/categorization-plan.md.template ./PLAN_categorizacion_$(date +%Y-%m-%d).md
cp .claude/skills/workflow-execute/assets/execution-log.md.template ./LOG_ejecucion_$(date +%Y-%m-%d).md
cp .claude/skills/workflow-track/assets/final-report.md.template ./REPORTE_final_$(date +%Y-%m-%d).md
```

### Paso 2: Completar analysis-phase.md

1. Ejecutar build y capturar output:
   ```bash
   make clean
   make html 2>&1 | tee build-output.txt
   ```

2. Abrir analysis-phase.md

3. Completar:
   - Pegar build output completo
   - Contar issues por tipo
   - Categorizar por severidad
   - Identificar archivos más afectados
   - Identificar patterns recurrentes
   - Listar issues detallados por tipo

4. Calcular métricas:
   - Total de issues
   - Porcentajes por categoría
   - Top archivos afectados

### Paso 3: Completar categorization-plan.md

1. Revisar analysis-phase.md

2. Decidir estrategia:
   - Por tipo de issue (ej: todos los "reference not found" juntos)
   - Por archivo (ej: todos los issues de archivo X juntos)
   - Por severidad (ej: críticos primero)
   - Por complejidad (ej: fáciles primero o difíciles primero)

3. Crear lotes:
   - Agrupar issues según estrategia
   - Nombrar cada lote descriptivamente
   - Asignar prioridad a cada lote
   - Estimar tiempo por lote

4. Definir orden de ejecución basado en:
   - Prioridad
   - Dependencies entre lotes
   - Impacto en build

### Paso 4: Usar execution-log.md

1. Abrir execution-log.md

2. Antes de empezar:
   - Completar tabla de tracking general con todos los lotes
   - Estado inicial: todos "Pendiente"

3. Por cada lote:
   - Marcar estado "En progreso"
   - Documentar issues que se abordan
   - Listar archivos a modificar
   - Ejecutar correcciones
   - Pegar comandos ejecutados
   - **CHECKPOINT**: Ejecutar build validation
   - Pegar build output
   - Validar que se resolvieron issues del lote
   - Documentar problemas encontrados
   - Documentar decisiones tomadas
   - **COMMIT**: git commit con mensaje descriptivo
   - Marcar estado "Completado"
   - Actualizar métricas de progreso

4. Mantener actualizado durante toda la ejecución

### Paso 5: Completar final-report.md

1. Al terminar todos los lotes, copiar template

2. Compilar información de:
   - analysis-phase.md (métricas iniciales)
   - categorization-plan.md (plan vs realidad)
   - execution-log.md (qué pasó realmente)

3. Completar:
   - Resumen ejecutivo con logros principales
   - Tabla comparativa antes vs después
   - Métricas finales (reducción de issues)
   - Resumen de cada lote (éxitos y dificultades)
   - Problemas críticos encontrados
   - Lecciones aprendidas (qué funcionó, qué no)
   - Issues no resueltos (si hay)
   - Recomendaciones para futuro

---

## Mejores Prácticas

### Para analysis-phase.md

- **Ser exhaustivo**: Documentar TODOS los issues, no solo algunos
- **Categorizar bien**: Las categorías determinan los lotes futuros
- **Identificar patterns**: Patterns permiten soluciones en batch eficientes
- **No omitir**: Incluir build output completo, no resumido

### Para categorization-plan.md

- **Lotes pequeños**: Mejor muchos lotes pequeños que pocos grandes (fácil validar)
- **Priorizar impacto**: Resolver primero lo que más mejora el build
- **Ser realista**: Estimar tiempo conservadoramente (+20% buffer)
- **Validación frecuente**: Checkpoint después de cada lote, no al final

### Para execution-log.md

- **Actualizar frecuentemente**: Después de cada lote, no al final del día
- **Documentar problemas**: Especialmente los inesperados
- **Registrar decisiones**: Por qué se tomó X decisión vs Y
- **Commits frecuentes**: Un commit por lote, no todo junto al final
- **Build validation**: SIEMPRE validar build después de cada lote

### Para final-report.md

- **Ser honesto**: Documentar qué no funcionó también
- **Métricas claras**: Números concretos (X% de reducción, Yh invertidas)
- **Lecciones útiles**: Qué aplicar en próxima corrección incremental
- **Recomendaciones accionables**: Acciones específicas, no genéricas

---

## Filosofía Fundamental

> **Principio central**: Calidad > Velocidad

**Validado en producción**:
- Proyecto: ADT Sphinx (230 WARNING)
- Resultado: 23 corregidos, 0 errores introducidos
- Trade-off: 6x más lento, pero 0 regresiones
- Conclusión: Tiempo "perdido" < Tiempo arreglando errores

---

## Beneficios de la Metodología

### Con Templates y Metodología

- **Consistencia**: Todos los proyectos siguen mismo proceso documentado
- **Tracking**: Fácil ver progreso y estimar tiempo restante
- **Aprendizaje**: Lecciones aprendidas se documentan y replican
- **Calidad**: Checkpoints frecuentes previenen regresiones
- **Rollback**: Fácil revertir un lote si algo falla

### Sin Templates y Metodología

- Documentación inconsistente o inexistente
- Difícil trackear progreso
- Lecciones se pierden
- Mayor riesgo de introducir nuevos bugs
- Difícil justificar tiempo invertido

---

## Ejemplo de Proyecto Real

### Escenario

Proyecto Sphinx con 230 warnings detectados en build.

### Aplicación de Metodología

**1. ANALISIS_230_warnings_sphinx.md**:
- Build output completo capturado
- Categorizado: 120 "reference not found", 80 "duplicate label", 30 "toctree"
- 5 patterns identificados
- Top 10 archivos más afectados documentados

**2. PLAN_categorizacion_5_lotes.md**:
- Estrategia: Por tipo de issue
- 5 lotes definidos:
  * Lote 1: Referencias rotas críticas (50 issues, 2h)
  * Lote 2: Duplicate labels (80 issues, 3h)
  * Lote 3: Referencias rotas no críticas (70 issues, 2.5h)
  * Lote 4: Toctree issues (30 issues, 1.5h)
  * Lote 5: Validación final (limpieza, 1h)
- Total estimado: 10h

**3. LOG_ejecucion_230_warnings.md**:
- Lote 1: 50 issues resueltos, build pasó, commit realizado (2.2h real)
- Lote 2: 80 issues resueltos, 3 problemas encontrados, soluciones documentadas (3.5h real)
- Lote 3: 70 issues resueltos (2.8h real)
- Lote 4: 30 issues resueltos (1.3h real)
- Lote 5: Validación final, 2 issues menores encontrados y corregidos (1.2h real)
- Total real: 11h (vs 10h estimado, +10% variación aceptable)

**4. REPORTE_final_230_warnings.md**:
- Reducción: 230 → 2 warnings (99.1%)
- Lecciones: Pattern matching acelera corrección 3x
- Recomendación: Implementar pre-commit hook para prevenir duplicate labels
- Próximos pasos: Resolver 2 warnings restantes (requieren research adicional)

---

## Integración con THYROX

Esta metodología es parte de **PHASE 7: TRACK** del skill THYROX.

Usar cuando:
- Completes PHASE 6: EXECUTE
- Detectas 100+ issues en tu proyecto
- Necesitas planificar corrección incremental

Workflow:
1. PHASE 7: TRACK (THYROX) te guía inicialmente
2. Si tienes 100+ issues → Usa incremental-correction-methodology
3. Usa los 4 templates para documentar cada fase
4. Cuando termines → Incluye final-report.md en tu commit

---

## FAQ

**Q: ¿Debo usar los 4 templates siempre?**

A: Para proyectos con >50 issues, SÍ. Para <50 issues, analysis + execution-log puede ser suficiente.

**Q: ¿Qué hago si un lote falla la validación?**

A: Documentar en execution-log, revertir cambios del lote (git reset), ajustar estrategia, re-intentar.

**Q: ¿Cuál es el tamaño ideal de lote?**

A: 15-30 issues por lote. Menos de 15 es demasiado granular, más de 30 dificulta validación.

**Q: ¿Debo seguir orden estricto de templates?**

A: SÍ. El orden es: analysis → categorization → execution → final-report. Cada uno depende del anterior.

**Q: ¿Qué hago con issues que no se pueden resolver?**

A: Documentar en execution-log por qué no se pueden resolver, incluir en final-report sección "Issues No Resueltos" con plan futuro.

**Q: ¿Manual o script?**

A: Usa el Decision Framework al inicio. Si dudas → MANUAL. Scripts sin las 8 Protecciones causan más problemas que resuelven.

---

## Ver También

- THYROX SKILL.md - PHASE 7: TRACK
- Templates en `/assets/`:
  - [analysis-phase.md.template](../assets/analysis-phase.md.template)
  - [categorization-plan.md.template](../../workflow-decompose/assets/categorization-plan.md.template)
  - [execution-log.md.template](../assets/execution-log.md.template)
  - [final-report.md.template](../assets/final-report.md.template)
- commit-helper.md - Para commits documentados después de cada lote

---

**Última actualización**: 2026-02-01  
**Versión**: 1.5.0
