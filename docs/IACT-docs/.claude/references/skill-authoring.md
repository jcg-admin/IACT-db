```yml
type: Mejores Prácticas Anthropic
category: Skill Authoring
version: 1.0
purpose: Compilación de mejores prácticas de Anthropic para crear skills de alta calidad.
goal: Proporcionar guía completa de skill authoring con ejemplos.
updated_at: 2026-03-25
owner: thyrox (cross-phase)
```

# Skill Authoring - Mejores Prácticas para Crear Skills

## Propósito

Compilación de mejores prácticas de Anthropic para crear skills de alta calidad.

> Objetivo: Proporcionar guía completa de skill authoring con ejemplos.

---

Basado en: Anthropic Skill Authoring Best Practices
Adaptado para: THYROX
Fecha: 2026-02-01

---

## Principios Fundamentales

### 1. Conciso es Clave

El contexto es un recurso compartido. Tu skill compite por tokens con:
- System prompt
- Historial de conversación
- Metadata de otros skills
- La petición del usuario

**Regla de oro**: Solo agregar contexto que Claude NO tiene ya.

**Pregúntate siempre**:
- ¿Claude realmente necesita esta explicación?
- ¿Puedo asumir que Claude ya sabe esto?
- ¿Este párrafo justifica su costo en tokens?

**Ejemplo - Conciso (BUENO)**:
```markdown
## Extraer Texto de PDF

Usar pdfplumber para extracción:

```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Ejemplo - Verboso (MALO)**:
```markdown
## Extraer Texto de PDF

Los archivos PDF (Portable Document Format) son un formato común que contiene
texto, imágenes y otro contenido. Para extraer texto de un PDF, necesitarás
usar una librería. Hay muchas librerías disponibles para procesamiento de PDF,
pero recomendamos pdfplumber porque es fácil de usar y maneja la mayoría de
casos bien. Primero necesitarás instalarlo con pip...
```

**Por qué el ejemplo conciso es mejor**: Asume que Claude sabe qué son PDFs y cómo funcionan librerías.

---

### 2. Establecer Grados de Libertad Apropiados

Ajusta el nivel de especificidad según fragilidad y variabilidad de la tarea.

#### Alta Libertad (Instrucciones basadas en texto)

**Usar cuando**:
- Múltiples enfoques son válidos
- Decisiones dependen del contexto
- Heurísticas guían el approach

**Ejemplo**:
```markdown
## Proceso de Code Review

1. Analizar estructura y organización del código
2. Verificar bugs potenciales o edge cases
3. Sugerir mejoras para legibilidad y mantenibilidad
4. Verificar adherencia a convenciones del proyecto
```

#### Libertad Media (Pseudocódigo o scripts con parámetros)

**Usar cuando**:
- Existe un patrón preferido
- Cierta variación es aceptable
- Configuración afecta comportamiento

**Ejemplo - ADT**:
```markdown
## Generar Reporte de Build

Usar esta estructura y personalizar según necesidad:

```python
def generar_reporte(data, formato="markdown", incluir_graficos=True):
    # Procesar data
    # Generar output en formato especificado
    # Opcionalmente incluir visualizaciones
```
```

#### Baja Libertad (Scripts específicos, pocos parámetros)

**Usar cuando**:
- Operaciones son frágiles y propensas a error
- Consistencia es crítica
- Secuencia específica debe seguirse

**Ejemplo - ADT**:
```markdown
## Build Sphinx con Validación

Ejecutar EXACTAMENTE este comando:

```bash
make clean && make html 2>&1 | tee build-output.txt
```

NO modificar el comando ni agregar flags adicionales.
```

**Analogía**: 
- **Puente angosto con acantilados**: Solo hay un camino seguro → Baja libertad (ej: migraciones de DB)
- **Campo abierto sin peligros**: Muchos caminos llevan al éxito → Alta libertad (ej: code reviews)

---

### 3. Testar con Todos los Modelos que Planeas Usar

Skills actúan como adiciones a modelos, efectividad depende del modelo subyacente.

**Consideraciones por modelo**:
- **Claude Haiku** (rápido, económico): ¿El skill da suficiente guía?
- **Claude Sonnet** (balanceado): ¿El skill es claro y eficiente?
- **Claude Opus** (razonamiento potente): ¿El skill evita sobre-explicar?

**Principio**: Si planeas usar el skill con múltiples modelos, apunta a instrucciones que funcionen bien con todos.

---

## Estructura de Skills

### Naming Conventions

Usar patrones consistentes para facilitar referencia y discusión.

**Formato recomendado**: Forma gerundio (verbo + -ing) en inglés, o sustantivo-acción en español.

**Buenos nombres de skills** (ADT):
- `commit-helper` (acción-ayudante)
- `translation-workflow` (sustantivo-flujo)
- `incremental-correction-methodology` (metodología-acción)
- `spec-driven-dev` (proceso-desarrollo)

**Evitar**:
- Nombres vagos: `helper`, `utils`, `tools`
- Demasiado genéricos: `documents`, `data`, `files`
- Palabras reservadas: `anthropic-helper`, `claude-tools`
- Patrones inconsistentes dentro de tu colección

**Regla técnica**: Solo minúsculas, números y guiones (-), máximo 64 caracteres.

---

### Escribir Descriptions Efectivas

La `description` en frontmatter habilita descubrimiento del skill.

**Formato recomendado**:
```
"[Qué hace el skill]. Usar cuando [trigger específico o contexto]."
```

**IMPORTANTE**: Siempre escribir en tercera persona. La descripción se inyecta en system prompt.

**Bueno**: "Procesa archivos Excel y genera reportes"
**Evitar**: "Yo puedo ayudarte a procesar archivos Excel"
**Evitar**: "Puedes usar esto para procesar archivos Excel"

**Ejemplos efectivos - ADT**:

**Skill de procesamiento Sphinx**:
```yaml
description: "Ejecuta builds de Sphinx, analiza warnings y genera reportes. Usar cuando trabajas con documentación Sphinx, architecture docs o necesitas validar build."
```

**Skill de traducción**:
```yaml
description: "Traduce documentación técnica de inglés a español con alta fidelidad. Usar cuando traduces architecture docs, Sphinx docs o documentación técnica compleja."
```

**Skill de corrección incremental**:
```yaml
description: "Metodología validada para corrección incremental de issues a gran escala. Usar cuando necesitas corregir 100+ warnings o errores en proyecto."
```

**Evitar descripciones vagas**:
```yaml
description: "Ayuda con documentos"  # [ERROR] Demasiado vago
description: "Procesa data"          # [ERROR] No específico
description: "Hace cosas con archivos" # [ERROR] Sin triggers claros
```

---

## Progressive Disclosure Patterns

SKILL.md sirve como overview que apunta a materiales detallados según necesidad.

**Guía práctica**:
- Mantener SKILL.md bajo 500 líneas para performance óptimo
- Split contenido en archivos separados cuando te acercas a este límite
- Usar patrones de abajo para organizar instrucciones, código y recursos

### De Simple a Complejo - Visual

**Skill básico**:
```
skill/
└── SKILL.md (frontmatter + contenido)
```

**Skill con contenido adicional**:
```
skill/
├── SKILL.md (overview + decision framework)
├── reference.md (detalles técnicos)
├── examples.md (ejemplos de uso)
└── scripts/
    ├── helper.py
    └── validator.py
```

**Ejemplo - ADT**:
```
incremental-correction-methodology/
├── SKILL.md (metodología core + fases)
├── assets/
│   ├── analysis-phase.md.template
│   ├── categorization-plan.md.template
│   ├── execution-log.md.template
│   ├── final-report.md.template
│   └── README.md
└── (scripts si necesario en futuro)
```

---

### Patrón 1: Guía de Alto Nivel con Referencias

````markdown
---
name: sphinx-documentation
description: "Construye y valida documentación Sphinx para architecture docs. Usar cuando trabajas con docs Sphinx o architecture docs."
---

# Sphinx Documentation

## Quick Start

Build básico:
```bash
make clean && make html
```

## Features Avanzadas

**Análisis de warnings**: Ver [ANALYSIS](ANALYSIS.md) para guía completa
**Validación de links**: Ver [LINKCHECK](LINKCHECK.md) para todos los métodos
**Ejemplos**: Ver [EXAMPLES](EXAMPLES.md) para patrones comunes
````

Claude carga ANALYSIS.md, LINKCHECK.md o EXAMPLES.md solo cuando necesario.

---

### Patrón 2: Organización por Dominio

Para skills con múltiples dominios, organizar contenido por dominio para evitar cargar contexto irrelevante.

**Ejemplo - ADT**:
```
translation-workflow/
├── SKILL.md (overview y navegación)
└── modes/
    ├── high-fidelity.md (traducción fidelidad alta)
    ├── visual-markup.md (traducción con marcado visual)
    └── enrichment.md (enriquecimiento de contenido)
```

```markdown
# Translation Workflow

## Modos Disponibles

**Alta Fidelidad**: Preservación máxima de estructura → Ver [modes/high-fidelity](modes/high-fidelity.md)
**Marcado Visual**: Traducción con énfasis visual → Ver [modes/visual-markup](modes/visual-markup.md)
**Enriquecimiento**: Agregar valor al contenido → Ver [modes/enrichment](modes/enrichment.md)

## Búsqueda Rápida

```bash
grep -i "terminology" modes/high-fidelity.md
grep -i "emphasis" modes/visual-markup.md
```
```

---

### Patrón 3: Detalles Condicionales

Mostrar contenido básico, enlazar a contenido avanzado.

**Ejemplo - ADT**:
```markdown
# Procesamiento de Archivos RST

## Edición Básica

Para edits simples, modificar el archivo .rst directamente.

**Para cambios complejos**: Ver [ADVANCED-RST](ADVANCED-RST.md)
**Para directives especiales**: Ver [DIRECTIVES](DIRECTIVES.md)
```

Claude lee ADVANCED-RST.md o DIRECTIVES.md solo cuando usuario necesita esas features.

---

### Evitar Referencias Profundamente Anidadas

Claude puede leer parcialmente archivos cuando están referenciados desde otros archivos referenciados.

**Mantener referencias a 1 nivel de profundidad desde SKILL.md**.

**Malo - Demasiado profundo**:
```markdown
# SKILL.md
Ver [advanced](advanced.md)...

# advanced.md
Ver [details](details.md)...

# details.md
Aquí está la información real...
```

**Bueno - Un nivel de profundidad**:
```markdown
# SKILL.md

**Uso básico**: [instrucciones en SKILL.md]
**Features avanzadas**: Ver [advanced](advanced.md)
**Referencia API**: Ver [reference](reference.md)
**Ejemplos**: Ver [examples](examples.md)
```

---

### Estructurar Archivos de Referencia Largos con TOC

Para archivos de referencia >100 líneas, incluir tabla de contenidos al inicio.

**Ejemplo**:
```markdown
# Referencia de Directives Sphinx

## Contenido
- Directives básicas (toctree, include, literalinclude)
- Directives de admonición (note, warning, danger)
- Directives de código (code-block, highlight)
- Directives personalizadas de architecture docs
- Ejemplos de uso

## Directives Básicas
...

## Directives de Admonición
...
```

Claude puede leer el archivo completo o saltar a secciones específicas.

---

## Workflows y Feedback Loops

### Usar Workflows para Tareas Complejas

Dividir operaciones complejas en pasos claros y secuenciales.

**Ejemplo 1 - Workflow de Análisis (sin código)**:

```markdown
## Workflow de Análisis de Build

Copiar este checklist y trackear progreso:

```
Progreso de Análisis:
- [ ] Paso 1: Ejecutar build completo y capturar output
- [ ] Paso 2: Categorizar warnings por tipo
- [ ] Paso 3: Identificar archivos más afectados
- [ ] Paso 4: Crear resumen estructurado
- [ ] Paso 5: Calcular métricas (total, %)
```

**Paso 1: Ejecutar build completo**

```bash
make clean && make html 2>&1 | tee build-output.txt
```

Captura el output completo en archivo para análisis.

**Paso 2: Categorizar warnings**

Revisar build-output.txt y agrupar warnings por tipo:
- Referencias no encontradas
- Duplicate labels
- Toctree issues
- Otros

**Paso 3: Identificar archivos afectados**

Listar los 10 archivos con más warnings.

**Paso 4: Crear resumen**

Usar template analysis-phase.md para documentar hallazgos.

**Paso 5: Calcular métricas**

- Total warnings: [número]
- Por tipo: [distribución]
- % del total: [porcentajes]
```

El checklist ayuda trackear progreso en workflows multi-paso.

---

**Ejemplo 2 - Workflow de Corrección (con código)**:

```markdown
## Workflow de Corrección Incremental

Copiar checklist:

```
Progreso de Corrección:
- [ ] Paso 1: Analizar issues (ejecutar build)
- [ ] Paso 2: Crear plan de lotes
- [ ] Paso 3: Validar estrategia
- [ ] Paso 4: Ejecutar lote 1
- [ ] Paso 5: Checkpoint de validación
```

**Paso 1: Analizar issues**

```bash
make clean && make html 2>&1 | tee build-output.txt
wc -l build-output.txt  # Contar líneas
grep -c "WARNING" build-output.txt  # Contar warnings
```

**Paso 2: Crear plan de lotes**

Decidir estrategia:
- Por tipo de issue
- Por archivo
- Por severidad

Documentar en categorization-plan.md

**Paso 3: Validar estrategia**

Revisar que:
- Lotes son manejables (15-30 issues cada uno)
- Orden de ejecución es lógico
- Tiempo estimado es realista

**Paso 4: Ejecutar lote 1**

Corregir issues del lote.
Documentar en execution-log.md.

**Paso 5: Checkpoint**

```bash
make clean && make html
# Si build pasa → commit y continuar
# Si build falla → revertir y ajustar
```

Solo continuar cuando validación pasa.
```

---

### Implementar Feedback Loops

**Patrón común**: Ejecutar validador → corregir errores → repetir

**Ejemplo 1 - Validación de Estilo (sin código)**:

```markdown
## Proceso de Revisión de Contenido

1. Escribir contenido siguiendo STYLE_GUIDE.md
2. Revisar contra checklist:
   - Verificar consistencia terminológica
   - Confirmar ejemplos siguen formato estándar
   - Validar que todas las secciones requeridas están presentes
3. Si hay issues:
   - Anotar cada issue con referencia a sección
   - Revisar contenido
   - Revisar checklist nuevamente
4. Solo proceder cuando todos los requisitos se cumplen
5. Finalizar y guardar documento
```

El "validador" es STYLE_GUIDE.md, Claude realiza el check leyendo y comparando.

---

**Ejemplo 2 - Validación de Build (con código)**:

```markdown
## Proceso de Edición de Documentación

1. Hacer edits en archivos .rst
2. **Validar inmediatamente**: 
   ```bash
   make html 2>&1 | grep -i "warning\|error"
   ```
3. Si validación falla:
   - Revisar mensaje de error cuidadosamente
   - Corregir issues en archivos
   - Ejecutar validación nuevamente
4. **Solo proceder cuando validación pasa**
5. Commit:
   ```bash
   git add .
   git commit -m "docs: [descripción del cambio]"
   ```
```

El loop de validación detecta errores temprano.

---

## Content Guidelines

### Evitar Información Time-Sensitive

No incluir información que se volverá obsoleta.

**Malo - Time-sensitive** (se volverá incorrecto):
```markdown
Si estás haciendo esto antes de Agosto 2025, usa la API vieja.
Después de Agosto 2025, usa la API nueva.
```

**Bueno - Sección "Old Patterns"**:
```markdown
## Método Actual

Usar Sphinx 7.x con Python 3.11+:

```bash
pip install sphinx>=7.0
```

## Patrones Antiguos

<details>
<summary>Sphinx 5.x (deprecated 2024-08)</summary>

Sphinx 5.x usaba configuración diferente en conf.py:

```python
# Configuración obsoleta - NO usar
html_theme = 'alabaster'
```

Este approach ya no es recomendado.
</details>
```

La sección de patrones antiguos provee contexto histórico sin contaminar contenido principal.

---

### Usar Terminología Consistente

Elegir UN término y usarlo en todo el skill.

**Bueno - Consistente**:
- Siempre "archivo RST"
- Siempre "directiva"
- Siempre "extraer"

**Malo - Inconsistente**:
- Mix "archivo RST", "documento RST", "file RST"
- Mix "directiva", "directive", "comando"
- Mix "extraer", "obtener", "sacar"

Consistencia ayuda a Claude entender y seguir instrucciones.

---

## Patrones Comunes

### Patrón de Template

Proveer templates para formato de output.

**Para requisitos estrictos** (como respuestas API o formatos de datos):

```markdown
## Estructura de Reporte

SIEMPRE usar esta estructura exacta:

```markdown
# [Título del Análisis]

## Resumen Ejecutivo
[Párrafo de overview con hallazgos clave]

## Hallazgos Principales
- Hallazgo 1 con data de soporte
- Hallazgo 2 con data de soporte
- Hallazgo 3 con data de soporte

## Recomendaciones
1. Recomendación específica accionable
2. Recomendación específica accionable
```
```

**Para guía flexible** (cuando adaptación es útil):

```markdown
## Estructura de Reporte

Aquí hay un formato default sensato, pero usa tu criterio según el análisis:

```markdown
# [Título del Análisis]

## Resumen Ejecutivo
[Overview]

## Hallazgos Principales
[Adaptar secciones basado en lo que descubras]

## Recomendaciones
[Personalizar al contexto específico]
```

Ajustar secciones según necesidad del tipo de análisis específico.
```

---

### Patrón de Ejemplos

Para skills donde calidad de output depende de ver ejemplos, proveer pares input/output.

**Ejemplo - ADT**:

```markdown
## Formato de Commit Message

Generar mensajes de commit siguiendo estos ejemplos:

**Ejemplo 1**:
Input: Agregada autenticación de usuario con JWT tokens
Output:
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**Ejemplo 2**:
Input: Corregido bug donde fechas se mostraban incorrectamente en reportes
Output:
```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```

**Ejemplo 3**:
Input: Actualizadas dependencias y refactorizada gestión de errores
Output:
```
chore: update dependencies and refactor error handling

- Upgrade lodash to 4.17.21
- Standardize error response format across endpoints
```

Seguir este estilo: type(scope): descripción breve, luego explicación detallada.
```

Ejemplos ayudan a Claude entender el estilo y nivel de detalle deseado.

---

### Patrón de Workflow Condicional

Guiar a Claude a través de puntos de decisión.

**Ejemplo - ADT**:

```markdown
## Workflow de Modificación de Documentación

1. Determinar tipo de modificación:

   **¿Crear contenido nuevo?** → Seguir "Workflow de Creación" abajo
   **¿Editar contenido existente?** → Seguir "Workflow de Edición" abajo

2. Workflow de Creación:
   - Crear nuevo archivo .rst
   - Seguir estructura de architecture docs si aplica
   - Agregar a toctree en index.rst
   - Build y validar

3. Workflow de Edición:
   - Abrir archivo existente
   - Hacer cambios preservando estructura
   - Validar sintaxis RST
   - Build y verificar

**Tip**: Si workflows se vuelven grandes o complicados, considera moverlos a archivos separados.
```

---

## Evaluación e Iteración

### Construir Evaluaciones Primero

**Crear evaluaciones ANTES de escribir documentación extensa**. Esto asegura que tu skill resuelve problemas reales.

**Desarrollo guiado por evaluación**:
1. **Identificar gaps**: Ejecutar Claude en tareas representativas sin skill. Documentar fallas específicas
2. **Crear evaluaciones**: Construir tres escenarios que testen estos gaps
3. **Establecer baseline**: Medir performance de Claude sin el skill
4. **Escribir instrucciones mínimas**: Crear solo suficiente contenido para abordar gaps y pasar evaluaciones
5. **Iterar**: Ejecutar evaluaciones, comparar con baseline, refinar

**Estructura de evaluación**:
```json
{
  "skills": ["sphinx-documentation"],
  "query": "Ejecutar build de Sphinx y analizar warnings",
  "files": ["source/index.rst", "source/conf.py"],
  "expected_behavior": [
    "Ejecuta make clean && make html exitosamente",
    "Captura y categoriza todos los warnings del build",
    "Identifica los 5 archivos con más warnings"
  ]
}
```

Evaluaciones son tu fuente de verdad para medir efectividad del skill.

---

### Desarrollar Skills Iterativamente con Claude

El proceso más efectivo involucra a Claude mismo.

**Creando un skill nuevo**:

1. **Completar tarea sin skill**: Trabajar en un problema con Claude usando prompting normal. Al trabajar, naturalmente proveerás contexto, explicarás preferencias, compartirás conocimiento procedimental.

2. **Identificar el patrón reutilizable**: Después de completar la tarea, identificar qué contexto provees que sería útil para tareas similares futuras.

3. **Pedir a Claude crear skill**: "Crea un skill que capture este patrón que acabamos de usar. Incluir [especificar qué incluir]."

4. **Revisar concisión**: Verificar que Claude no agregó explicaciones innecesarias.

5. **Mejorar arquitectura de información**: Pedir a Claude organizar contenido más efectivamente.

6. **Testar en tareas similares**: Usar el skill con Claude en casos de uso relacionados.

7. **Iterar basado en observación**: Si Claude tiene dificultades, volver con detalles específicos.

**Iterando en skills existentes**:

1. **Usar skill en workflows reales**: Dar a Claude tareas reales, no escenarios de test
2. **Observar comportamiento**: Notar dónde tiene dificultades o hace elecciones inesperadas
3. **Volver a Claude para mejoras**: Compartir SKILL.md actual y describir lo observado
4. **Revisar sugerencias**: Claude puede sugerir reorganizar, usar lenguaje más fuerte, reestructurar
5. **Aplicar y testar cambios**: Actualizar skill, testar nuevamente
6. **Repetir según uso**: Continuar ciclo observar-refinar-testar

---

## Resumen de Principios

1. **Conciso es clave** - Solo agregar contexto que Claude no tiene
2. **Grados de libertad** - Ajustar especificidad a fragilidad de tarea
3. **Testar con modelos** - Validar que funciona con todos los modelos planeados
4. **Naming consistente** - Usar patrones descriptivos y consistentes
5. **Descriptions efectivas** - Incluir QUÉ hace y CUÁNDO usar
6. **Progressive disclosure** - SKILL.md <500 líneas, detalles en archivos
7. **Evitar deep nesting** - Referencias a 1 nivel máximo
8. **Workflows claros** - Dividir tareas complejas en pasos
9. **Feedback loops** - Validar frecuentemente durante ejecución
10. **Evitar time-sensitive** - Usar "old patterns" para info obsoleta
11. **Terminología consistente** - Un término por concepto
12. **Evaluaciones primero** - Construir evaluaciones antes de documentación
13. **Iterar con Claude** - Usar Claude para diseñar y refinar skills

---

---

## Frontmatter completo (GAP-001)

Todos los campos disponibles del frontmatter de skills post-2026-03-25. Los marcados como opcionales se omiten si no son necesarios.

```yaml
---
name: mi-skill              # Opcional. Si se omite: usa nombre del directorio.
                            # Solo a-z, 0-9, - (hyphens). Max 64 chars.
                            # NOTA: underscores NO son válidos en el campo name.
description: |              # Recomendado. Claude lo usa para auto-seleccionar.
  Qué hace el skill. Usar cuando condición específica.
  Max 250 chars visibles en listado (se trunca si excede).
argument-hint: "[nombre] [formato]"  # Opcional. Hint en autocomplete del menú /.
disable-model-invocation: true       # Opcional. Ver §Modos de invocación.
user-invocable: false                # Opcional. Ver §Modos de invocación.
allowed-tools: Read Grep             # Opcional. Herramientas pre-aprobadas mientras el skill está activo.
model: sonnet                        # Opcional. Modelo mientras el skill está activo.
effort: high                         # Opcional. low|medium|high|max (Opus 4.6 only).
context: fork                        # Opcional. Ejecuta en subagente aislado. Ver §Context isolation.
agent: Explore                       # Opcional. Qué subagente usar con context: fork.
shell: bash                          # Opcional. bash (default) o powershell.
hooks:                               # Opcional. Hooks del lifecycle de este skill.
  - event: UserPromptSubmit
    once: true
    type: command
    command: "echo 'skill activado' >> context/now.md"
paths: "src/**/*.ts"                 # Opcional. Ver §Activación condicional.
---
```

**Campos básicos requeridos/recomendados:**

| Campo | Estado | Notas |
|-------|--------|-------|
| `name` | Opcional | Si se omite usa el nombre del directorio. Respetar formato kebab-case. |
| `description` | Recomendado | Sin description, Claude no puede auto-seleccionar el skill. |
| Resto | Opcional | Solo agregar si hay razón concreta. |

---

## Modos de invocación (GAP-002 + GAP-003)

Tres modos disponibles controlados por dos campos de frontmatter:

| Frontmatter | Usuario invoca | Claude invoca | Description en context |
|-------------|---------------|---------------|------------------------|
| (default) | Sí — `/<name>` | Sí — auto-selección | Siempre cargada |
| `disable-model-invocation: true` | Sí — `/<name>` | No | NUNCA cargada |
| `user-invocable: false` | No — oculto del menú | Sí — auto-selección | Siempre cargada |

**`disable-model-invocation: true` — doble efecto:**

1. **Control de invocación:** Claude no puede auto-seleccionar el skill
2. **Optimización de context budget:** La description NO se incluye en el context hasta que el usuario lo invoca

Este doble efecto es la razón principal para usarlo en skills de workflow pesados:

```yaml
# Skill que el usuario invoca manualmente, con body extenso:
---
name: workflow-execute
description: Phase 6 EXECUTE — implementa el task-plan.md
disable-model-invocation: true   # Control + context budget: zero costo hasta /workflow-execute
---
```

**`user-invocable: false` — skill invisible para el usuario:**

```yaml
# Skill que solo Claude activa, oculto del menú /:
---
name: legacy-context
description: Contexto del sistema legacy para Claude. Solo útil como referencia de Claude.
user-invocable: false
---
```

**Regla de context budget (GAP-003):**

Las descriptions de todos los skills model-invocable se cargan al inicio de sesión. El budget total es **~1% de la context window** (~8,000 caracteres como fallback). Con muchos skills instalados, las descriptions se truncan automáticamente.

Estrategia para conservar budget:
- Skills pesados de uso manual → `disable-model-invocation: true` (0 costo)
- Skills de conocimiento siempre relevante → mantener model-invocable con description corta
- Skills de workflow → usar `disable-model-invocation: true` siempre

---

## Variables de sustitución (GAP-004)

Disponibles en el body de SKILL.md, se resuelven antes de que Claude vea el contenido:

| Variable | Descripción | Ejemplo de uso |
|----------|-------------|----------------|
| `$ARGUMENTS` | Todos los argumentos al invocar | `/fix-issue 123` → `$ARGUMENTS` = `123` |
| `$ARGUMENTS[N]` o `$N` | Argumento por índice (0-based) | `$ARGUMENTS[0]` = primer argumento |
| `${CLAUDE_SESSION_ID}` | ID de la sesión actual | Para logging o nombres únicos |
| `${CLAUDE_SKILL_DIR}` | Directorio del SKILL.md | Para referenciar scripts relativos al skill |

**Ejemplo completo:**

```yaml
---
name: fix-issue
description: Corrige un issue de GitHub por número. Usar cuando se quiere implementar un fix.
argument-hint: "[issue-number]"
---

## Contexto
- Issue a resolver: $ARGUMENTS
- Directorio del skill: ${CLAUDE_SKILL_DIR}
- Sesión: ${CLAUDE_SESSION_ID}

## Tarea
Implementar fix para el issue #$ARGUMENTS:
1. Leer el issue con `gh issue view $ARGUMENTS`
2. Identificar archivos afectados
3. Implementar la corrección
4. Escribir tests
5. Crear commit con referencia al issue

## Scripts disponibles
Ver ${CLAUDE_SKILL_DIR}/scripts/ para utilidades de validación.
```

**Uso de `${CLAUDE_SKILL_DIR}` para referenciar scripts:**

```markdown
Ejecutar validaciones del proyecto:
!`bash ${CLAUDE_SKILL_DIR}/scripts/validate.sh`
```

---

## Inyección dinámica de contexto (GAP-005)

La sintaxis `!`backtick`ejecuta comandos shell antes de que Claude vea el contenido del skill. Claude solo ve el output del comando, no el comando en sí.

**Sintaxis inline:**
```
Estado actual del repositorio: !`git status --short`
Branch activo: !`git branch --show-current`
```

**Sintaxis de bloque multi-línea (backtick triple con `!`):**
```
Estado del entorno:
!`node --version`
!`git log --oneline -5`
```

**Ejemplo de skill que usa inyección dinámica:**

```yaml
---
name: pr-summary
description: Genera resumen de un pull request. Usar cuando se quiere describir los cambios de un PR.
context: fork
agent: Explore
---

## Contexto del pull request
- Archivos modificados: !`gh pr diff --name-only`
- Status CI: !`gh pr checks`

## Tarea
Con el contexto anterior, genera un resumen del PR que incluya:
1. Qué cambia y por qué
2. Impacto potencial
3. Areas que requieren revisión cuidadosa
```

**Por defecto el shell es `bash`.** Para usar PowerShell:

```yaml
---
shell: powershell
---
Estado: !`Get-Location`
```

---

## Context isolation con `context: fork` (GAP-006)

El campo `context: fork` ejecuta el skill en un subagente aislado, no inline en el contexto principal.

**Sin `context: fork` (default):**
- El skill corre inline — su output queda en el contexto principal
- Útil para skills cortos de referencia
- Riesgo: output verboso (tests, análisis extenso) contamina el contexto

**Con `context: fork`:**
- El skill content se convierte en el task del subagente
- El subagente corre en su propio context window
- Solo el resumen final vuelve al contexto principal
- El campo `agent:` especifica qué tipo de subagente usar

```yaml
---
name: deep-analysis
context: fork
agent: Explore          # Explore: Haiku, read-only, bajo costo
---

Analiza el codebase para identificar:
1. Patrones de arquitectura
2. Dependencias circulares
3. Módulos con alta complejidad ciclomática

Retorna un resumen estructurado con hallazgos específicos.
```

**Tipos de subagente disponibles para `agent:`:**

| Agent | Modelo | Herramientas | Ideal para |
|-------|--------|--------------|-----------|
| `Explore` | Haiku (rápido, económico) | Read-only | Exploración, búsqueda, análisis |
| `Plan` | Hereda del parent | Lectura | Crear planes de implementación |
| `general-purpose` | Hereda del parent | Todas | Tareas que requieren modificar archivos |
| Agente custom | Según definición | Según definición | Workflows especializados |

**Diferencia con `skills:` en agents:**
- `context: fork` en SKILL → el skill invoca un subagente cuando se activa
- `skills:` en Agent → el agente tiene el skill precargado en su contexto desde el inicio

---

## Description budget (GAP-014)

**Límite de UI:** La description de un skill está limitada a **250 caracteres** visibles en el listado del menú `/`. Si excede, se trunca en la UI.

**Budget de context window:** Las descriptions de todos los skills model-invocable se incluyen en el context al inicio. El budget total es `~1% del context window` (~8,000 caracteres como fallback). Si hay muchos skills, las descriptions se truncan para caber en el budget.

**Estrategia de description efectiva — front-load el trigger:**

```yaml
# Malo — el trigger está al final (puede truncarse)
description: "Metodología validada para análisis de builds Sphinx, gestión de warnings,
generación de reportes y corrección incremental. Usar cuando trabajas con Sphinx."

# Bueno — trigger al inicio (front-loaded)
description: "Usar cuando trabajas con docs Sphinx o architecture docs. Ejecuta builds,
analiza warnings y genera reportes de corrección incremental."
```

**Verificar el tamaño:**

```bash
echo -n "Tu description aquí" | wc -c
# Si > 250: se trunca en UI
# Si > 8000 chars totales de descriptions: el modelo puede no ver todas
```

**Para skills con `disable-model-invocation: true`:**
La description nunca se incluye en el context window (cero costo de budget). El límite de 250 chars sigue aplicando al menú `/`, pero no afecta el context budget del modelo.

**Override del budget (avanzado):**
```bash
export SLASH_COMMAND_TOOL_CHAR_BUDGET=12000  # Aumentar el budget de descriptions
```

---

## Activación condicional con `paths:` (GAP-015)

El campo `paths:` limita cuándo Claude auto-activa el skill basándose en los archivos que el usuario tiene en scope.

```yaml
---
name: api-conventions
description: Convenciones de la API para este codebase.
paths: "src/api/**/*.ts"    # Solo se activa cuando el usuario trabaja con archivos en src/api/
---

Cuando escribas endpoints de API en este proyecto:
- Usar Zod para validación de input
- Retornar errores con formato {success: false, error: {code, message}}
- Incluir paginación cursor-based en listas
```

**Formatos válidos para `paths:`:**

```yaml
# String simple (un patrón)
paths: "src/**/*.ts"

# String con múltiples patrones (comma-separated)
paths: "src/**/*.ts, tests/**/*.test.ts"

# Lista YAML
paths:
  - "src/api/**"
  - "tests/api/**"
```

**Patrones glob comunes:**

| Patrón | Qué coincide |
|--------|-------------|
| `src/**/*.ts` | Todos los .ts en src/ recursivamente |
| `src/**` | Todos los archivos en src/ |
| `*.{ts,tsx}` | Archivos .ts o .tsx |
| `{src,lib}/**/*.ts` | .ts en src/ o lib/ |

**Cuándo usar `paths:`:**

- Skills de convenciones específicas a un módulo (ej: `paths: "src/api/**"` para convenciones de API)
- Skills de guías técnicas por tipo de archivo (ej: `paths: "**/*.sql"` para patrones SQL)
- Evitar que skills de un módulo aparezcan en sesiones donde no son relevantes

**Diferencia con `.claude/rules/` con `paths:`:**

- `skill paths:` → hint al modelo para auto-activación (probabilístico)
- `.claude/rules/` con `paths:` frontmatter → carga determinística cuando ciertos archivos están en scope

Para garantías determinísticas, usar `.claude/rules/`. Para hints al modelo, usar `skill paths:`.

---

**Documento basado en**: Anthropic Skill Authoring Best Practices
**Adaptado para**: THYROX
**Fecha**: 2026-02-01
**Actualizado con**: GAP-001..006, GAP-014, GAP-015 (FASE 33)
**Ver también**: [claude-code-components.md](./claude-code-components.md), [component-decision.md](./component-decision.md), [prompting-tips.md](./prompting-tips.md)
