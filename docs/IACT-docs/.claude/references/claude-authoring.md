```yml
type: Reference
title: Claude Authoring — Guía para Crear y Mantener CLAUDE.md
category: Authoring — CLAUDE.md
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Cuándo y cómo crear CLAUDE.md — jerarquía, @imports, /init, anti-patrones, herencia por agentes
```

# Claude Authoring — Guía para Crear y Mantener CLAUDE.md

Guía para crear, estructurar y mantener archivos CLAUDE.md efectivos. Cubre la jerarquía de 4 niveles, imports, el comando `/init`, y los límites de lo que CLAUDE.md debe y no debe contener.

Para la jerarquía técnica completa de 8 niveles, ver [memory-hierarchy.md](memory-hierarchy.md).
Para decidir entre CLAUDE.md vs SKILL vs Agent, ver [component-decision.md](component-decision.md).

---

## 1. Regla core: CLAUDE.md = instrucciones universales sin excepción

CLAUDE.md se carga automáticamente en CADA sesión, sin condiciones. Esto lo hace diferente de todos los demás mecanismos:

- **SKILL**: se carga on-demand, puede no dispararse (probabilístico)
- **Agent**: contexto propio, se invoca para tareas específicas
- **Hook**: responde a eventos del sistema (no siempre activo)
- **CLAUDE.md**: **SIEMPRE** cargado, **SIEMPRE** activo

**Consecuencia directa:** Solo poner en CLAUDE.md instrucciones que deben aplicarse en TODA sesión sin excepción. Si una instrucción aplica "cuando X", "si el usuario hace Y", o "solo en ciertos proyectos" → no va en CLAUDE.md.

**Ejemplos de lo que SÍ va en CLAUDE.md:**
- Convenciones de commits que aplican siempre
- Estructura del proyecto que Claude debe conocer siempre
- Restricciones de seguridad que nunca deben romperse
- Glosario de términos del proyecto

**Ejemplos de lo que NO va en CLAUDE.md:**
- "Cuando refactorices código, sigue este proceso de 7 pasos" → SKILL
- "Revisa seguridad antes de hacer PR" → Agent o Hook
- "Al detectar este tipo de archivo, aplica estas reglas" → SKILL con `paths:`

---

## 2. Jerarquía de 4 niveles (perspectiva de autoría)

Desde la perspectiva de quién escribe y qué aplica a quién:

| Nivel | Archivo | Aplica a | Quién lo escribe |
|-------|---------|---------|-----------------|
| **Enterprise** | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | Todos los usuarios de la organización | Administrador IT |
| **User** | `~/.claude/CLAUDE.md` | Todos los proyectos del usuario | El desarrollador |
| **Project** | `./.claude/CLAUDE.md` o `./CLAUDE.md` | Todos los que trabajan en el proyecto | El equipo (vía git) |
| **Subdirectory** | `./src/api/CLAUDE.md` | Solo cuando Claude trabaja en ese directorio | El equipo |

**Precedencia:** Enterprise > User > Project > Subdirectory (local override).

**Cuándo usar cada nivel:**

```
Enterprise  → Políticas de seguridad corporativas, herramientas prohibidas
User        → Preferencias personales de codificación, estilo de respuesta
Project     → Convenciones del equipo, arquitectura del proyecto, comandos comunes
Subdirectory → Reglas específicas de un módulo que sobreescriben o complementan el project-level
```

**Ejemplo de subdirectory CLAUDE.md:**

```markdown
# API Module Standards

Este archivo overrides root CLAUDE.md para todo en /src/api/

## Validación obligatoria
- Usar Zod para todo input
- Retornar 400 con errores por campo
- Nunca exponer stack traces en producción
```

---

## 3. `@path/to/file` imports — cuándo referenciar vs copiar

La sintaxis `@path` importa el contenido de otro archivo directamente en el contexto de Claude:

```markdown
# En CLAUDE.md

## Arquitectura
@docs/architecture.md

## Estándares de API
@docs/api-standards.md

## Preferencias personales (solo en esta máquina)
@~/.claude/my-preferences.md
```

**Reglas de los imports:**

- Soporta paths relativos (`@docs/api.md`) y absolutos (`@~/.claude/prefs.md`)
- Máximo **5 niveles de recursión** (A importa B importa C... hasta 5)
- Primera vez que se importa desde ruta externa → diálogo de aprobación único
- NO funciona dentro de bloques de código markdown (es seguro documentarlos en ejemplos)

**Cuándo referenciar con `@` vs copiar el contenido:**

| Situación | Approach |
|-----------|----------|
| El documento ya existe y está bien mantenido (README, architecture.md) | `@path` — no duplicar |
| El contenido cambia frecuentemente | `@path` — siempre tendrás la versión actual |
| Son 2-3 líneas críticas que deben estar visibles inline | Copiar directamente |
| El path externo puede no existir en todas las máquinas | Copiar directamente |

**Evitar la trampa del megaarchivo:**

```markdown
# Malo — todo el contenido copiado en CLAUDE.md
## Convenciones de commit
[200 líneas copiadas de commit-guide.md]

## Arquitectura
[300 líneas copiadas de architecture.md]

# Bueno — imports limpios
## Convenciones de commit
@docs/commit-guide.md

## Arquitectura
@docs/architecture.md
```

---

## 4. `/init` — bootstrapping de CLAUDE.md

El comando `/init` es el punto de entrada recomendado para crear CLAUDE.md en un proyecto nuevo.

**Qué hace `/init`:**
1. Analiza la estructura del proyecto (archivos, stack tecnológico)
2. Genera un CLAUDE.md con secciones estándar pre-pobladas
3. Crea el archivo en `./CLAUDE.md` o `./.claude/CLAUDE.md`

**Cuándo usar:**
- Proyecto nuevo que no tiene CLAUDE.md
- Bootstrapping de standards de equipo
- Primer setup de Claude Code en un repositorio existente

**Modo interactivo mejorado:**

```bash
CLAUDE_CODE_NEW_INIT=1 claude
/init
```

Activa un flujo multi-fase que pregunta sobre el proyecto paso a paso.

**Workflow post-init:**
1. Ejecutar `/init` para generar el template
2. Revisar el contenido generado
3. Personalizar las secciones con los estándares reales del proyecto
4. Hacer commit: `git add .claude/CLAUDE.md && git commit -m "docs: initialize project memory"`

**Nota:** `/init` es para bootstrapping inicial. Para editar CLAUDE.md posteriormente, usar `/memory` (abre el archivo en el editor del sistema) o editar directamente.

---

## 5. Estructura recomendada de un CLAUDE.md

Un CLAUDE.md bien estructurado facilita que Claude encuentre la información relevante rápidamente.

**Template base:**

```markdown
# [Nombre del Proyecto]

## Visión general
- Stack: [tecnologías principales]
- Equipo: [tamaño aproximado]
- Repositorio: [link si aplica]

## Comandos comunes
| Comando | Propósito |
|---------|-----------|
| `npm run dev` | Servidor de desarrollo |
| `npm test` | Ejecutar tests |
| `npm run lint` | Verificar estilo |

## Convenciones de código
- [Convención 1]
- [Convención 2]

## Convenciones de git
- Commits: [patrón, ej: Conventional Commits]
- Branches: [patrón, ej: feature/descripcion]
- PRs: [proceso]

## Arquitectura
@docs/architecture.md

## Restricciones / reglas críticas
- [Restricción 1 que Claude debe respetar siempre]
- [Restricción 2]
```

**Secciones opcionales frecuentes:**

```markdown
## Glosario
| Término | Significado |
|---------|-------------|
| WP | Work Package |
| FASE | Unidad de trabajo del proyecto |

## Contactos / dueños
- Auth: @persona1
- Infra: @persona2

## Paths importantes
- Configuración: `config/`
- Tests: `tests/`
- Docs: `docs/`
```

---

## 6. Límites de tamaño

CLAUDE.md no tiene un límite técnico estricto, pero hay límites prácticos:

**Reglas prácticas:**

- Mantener CLAUDE.md < 500 líneas de contenido activo
- Si supera 500 líneas → split en imports: `@docs/section-a.md`, `@docs/section-b.md`
- El CLAUDE.md del proyecto THYROX usa `@` imports extensamente para mantener el archivo ligero

**Por qué importa el tamaño:**
- CLAUDE.md se carga en CADA sesión, sin excepción
- Contenido excesivo consume context window que podría usarse para la tarea actual
- El auto-compaction preserva CLAUDE.md, pero un archivo muy grande puede truncarse

**Cuándo hacer split:**

```markdown
# Señales de que CLAUDE.md es demasiado grande:
# 1. Tarda en cargarse notablemente
# 2. Contiene secciones que solo aplican en algunos contextos
# 3. Tiene documentación técnica detallada de múltiples dominios

# Solución: extraer a archivos separados e importar
@docs/backend-conventions.md
@docs/frontend-conventions.md
@docs/database-guidelines.md
```

**Sistema modular con `.claude/rules/`:**

Para reglas path-specific (sin llenar CLAUDE.md):

```
.claude/
└── rules/
    ├── api-validation.md    # Solo aplica a src/api/**
    ├── test-patterns.md     # Solo aplica a tests/**
    └── security.md          # Aplica globalmente
```

Frontmatter en rules:
```yaml
---
paths: src/api/**/*.ts
---
# API Validation Rules
- Usar Zod para todo input de usuario
```

---

## 7. Qué NO incluir en CLAUDE.md

### No incluir instrucciones condicionales

```markdown
# Malo — instrucción condicional en CLAUDE.md
Cuando el usuario esté haciendo refactoring, seguir este proceso:
1. Analizar el alcance
2. Crear un plan
3. Ejecutar en lotes de 50 líneas

# Correcto — va en un SKILL
# Crear .claude/skills/refactoring-workflow/SKILL.md con ese contenido
```

### No incluir side effects que requieren ejecución

```markdown
# Malo — instrucción que requiere lanzar un proceso
Al inicio de sesión, verificar que docker está corriendo y levantarlo si no.

# Correcto — va en un Hook SessionStart
# .claude/settings.json:
# "hooks": { "SessionStart": [{ "hooks": [{ "type": "command", "command": "./scripts/check-docker.sh" }] }] }
```

### No incluir documentación técnica detallada

```markdown
# Malo — 200 líneas de cómo funciona la API de Stripe
## Stripe Integration
[documentación completa del flow de pagos, webhooks, etc.]

# Correcto — importar o referenciar
## Pagos
Ver @docs/stripe-integration.md para el flow completo.
Regla crítica: nunca loggear card numbers — ni parcialmente.
```

### No incluir contexto de proyecto que cambia frecuentemente

```markdown
# Malo — estado del proyecto que se vuelve desactualizado
## Estado actual
Estamos en Q4 2025, migrando de PostgreSQL 14 a 16.
El servicio de auth está siendo refactorizado.

# Correcto — ese contexto va en context/focus.md o context/project-state.md (THYROX)
```

---

## 8. Anti-patrones

**CLAUDE.md como SKILL**

El error más común: poner en CLAUDE.md instrucciones largas de proceso que solo aplican cuando el usuario activa un workflow específico.

```markdown
# Malo
## Proceso de code review
[15 secciones detalladas de cómo hacer code review]

# Correcto
# Crear .claude/skills/code-review/SKILL.md con esas instrucciones
# En CLAUDE.md solo: "Para code reviews, usar el skill /code-review"
```

**Instrucciones que solo aplican a veces**

```markdown
# Malo
Si estás trabajando con archivos .ts en src/api/, usar strictMode.

# Correcto — usar .claude/rules/ con paths:
---
paths: src/api/**/*.ts
---
Usar TypeScript strictMode siempre.
```

**Megaarchivo sin estructura**

Un CLAUDE.md de 800 líneas sin secciones, mezcla de instrucciones de proceso, documentación técnica y convenciones del equipo. Claude lee todo pero el noise reduce la efectividad de las instrucciones importantes.

**Solución:** Mantener solo las reglas que aplican siempre. Todo lo demás → imports, skills, o rules modulares.

**Duplicar contenido de documentación existente**

```markdown
# Malo — copiar README.md completo en CLAUDE.md
## Visión del proyecto
[500 líneas copiadas del README]

# Correcto
## Visión del proyecto
@README.md
```

---

## Referencias

- [memory-hierarchy.md](memory-hierarchy.md) — Jerarquía técnica completa de 8 niveles, settings precedence
- [skill-vs-agent.md](skill-vs-agent.md) — Cuándo CLAUDE.md vs SKILL vs Agent
- [component-decision.md](component-decision.md) — Flowchart de decisión completo
- [skill-authoring.md](skill-authoring.md) — Para lo que no va en CLAUDE.md sino en SKILL
- `.claude/CLAUDE.md` — El CLAUDE.md de THYROX como ejemplo de referencia
