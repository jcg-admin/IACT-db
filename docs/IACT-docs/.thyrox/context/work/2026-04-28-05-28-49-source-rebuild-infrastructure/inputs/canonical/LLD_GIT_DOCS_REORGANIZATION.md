---
title: Low-Level Design - Git Documentation Reorganization
issue_number: IACT-GIT-DOCS-001
date: 2025-11-13
phase: design
status: lld_complete
domain: operaciones
---

# Low-Level Design: Git Documentation Reorganization

**Issue**: IACT-GIT-DOCS-001
**Phase**: FASE 3 - DESIGN (Low-Level)
**Date**: 2025-11-13
**Status**: LLD Complete

---

## 1. File-by-File Specifications

### 1.1 README.md

**Location**: `docs/devops/git/README.md`
**Purpose**: Entry point, navigation hub, learning roadmap
**Estimated Length**: 300-400 lines

**Detailed Structure**:

```markdown
---
title: Git/GitHub Documentation - Learning Roadmap
date: 2025-11-13
domain: operaciones
status: active
---

# Git/GitHub Documentation

[1-2 paragraph overview of documentation purpose and organization]

## Inicio Rapido

[3-4 line quick start guide pointing to Level 1]

## Estructura de la Documentacion

[Table showing 3 levels with description]

| Nivel | Audiencia | Contenido | Tiempo Estimado |
|-------|-----------|-----------|-----------------|
| Basico | 0-6 meses Git | Comandos esenciales, workflows | 1-2 semanas |
| Intermedio | 6+ meses Git | Sync con develop, conflictos | 3-5 dias |
| Avanzado | 1+ años Git | Casos especiales, merge sin ancestro | Segun necesidad |

## Roadmap de Aprendizaje

### Nivel 1 - Basico

**Objetivo**: [Clear objective statement]

**Prerequisitos**: Ninguno

**Guias**:
- [GIT_GITHUB_GUIA_INICIO.md](nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md) - Comandos y workflows fundamentales

**Criterio de Avance**: [Bulleted list of success criteria]

**Siguiente Paso**: Nivel 2 - Intermedio

### Nivel 2 - Intermedio

[Same structure as Level 1]

### Nivel 3 - Avanzado

[Same structure as Level 1]

## Matriz de Decisiones

Encuentra la guia correcta segun tu situacion:

| Situacion | Guia Recomendada | Nivel |
|-----------|------------------|-------|
| Soy nuevo en Git | GIT_GITHUB_GUIA_INICIO.md | Basico |
| Feature branch > 3 dias | FLUJO_SYNC_DEVELOP_ANTES_MERGE.md | Intermedio |
| Error "no merge base" | MERGE_STRATEGY_NO_COMMON_ANCESTOR.md | Avanzado |
| Necesito crear rama nueva | GIT_GITHUB_GUIA_INICIO.md (seccion Flujo de Trabajo) | Basico |
| Conflictos complejos en merge | FLUJO_SYNC_DEVELOP_ANTES_MERGE.md (seccion Resolucion) | Intermedio |
| No se cual guia leer | Empieza con Nivel 1 y avanza progresivamente | Basico |

## Referencia Rapida de Comandos

[Table organizing common commands by category]

| Categoria | Comando | Descripcion | Guia |
|-----------|---------|-------------|------|
| Configuracion | git clone | Clonar repositorio | Nivel 1 |
| Branches | git checkout -b | Crear nueva rama | Nivel 1 |
| Sync | git fetch origin develop | Traer cambios de develop | Nivel 2 |
| ... | ... | ... | ... |

## Contribuir a Esta Documentacion

[Guidelines for updating guides]

### Agregar Nueva Guia

1. Determinar nivel apropiado (basico/intermedio/avanzado)
2. Crear archivo en carpeta correspondiente
3. Usar plantilla de metadata (ver seccion Plantilla)
4. Actualizar este README (matriz de decisiones)
5. Agregar cross-references desde guias relacionadas

### Actualizar Guia Existente

[Process for updates]

### Plantilla de Metadata

```yaml
---
title: Titulo de la Guia
date: YYYY-MM-DD
level: basic|intermediate|advanced
domain: operaciones
prerequisites: Lista de prerequisitos
next_step: ../path/to/next/guide.md
estimated_time: X semanas/dias
status: active
---
```

## Contacto y Soporte

- Dudas sobre Git: [Tech Lead contact]
- Problemas con documentacion: [Create issue]
- Mejoras sugeridas: [PR process]

---

**Ultima actualizacion**: 2025-11-13
**Mantenedor**: Tech Lead / DevOps Team
```

**Implementation Notes**:
- Use standard markdown tables (pipe-delimited)
- Keep decision matrix to 6-8 most common situations
- Quick reference table should include 15-20 most common commands
- Update `date` whenever README modified

---

### 1.2 nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md

**Location**: `docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md`
**Purpose**: Teach fundamental Git commands and workflows
**Estimated Length**: 400-500 lines
**Source**: User-provided content + enhancements

**Required Enhancements to User-Provided Content**:

1. **Add Frontmatter**:
```yaml
---
title: Guia de Inicio con Git/GitHub
date: 2025-11-13
level: basic
domain: operaciones
prerequisites: Ninguno
next_step: ../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
estimated_time: 1-2 semanas
status: active
---
```

2. **Remove ALL Emojis**:
- Find: `[📘🎯✅⚠️🔧]` (and any other emoji characters)
- Replace with text equivalents:
  - Checkmark → "COMPLETADO:" or remove entirely
  - Warning → "ADVERTENCIA:"
  - Book → "NOTA:"
  - Wrench → "HERRAMIENTA:"

**Regex for emoji detection**:
```bash
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" GIT_GITHUB_GUIA_INICIO.md
```

3. **Add Cross-References**:

Insert after "Integrar cambios de develop antes de pull request" section:

```markdown
NOTA: Para feature branches de larga duracion (> 3 dias), consulta la guia completa:
[FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
```

Insert in "Notas Importantes" section:

```markdown
Si encuentras error "fatal: no merge base", consulta:
[MERGE_STRATEGY_NO_COMMON_ANCESTOR.md](../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md)
```

4. **Add Success Criteria Section** (append at end):

```markdown
## Criterio de Exito

Has completado este nivel cuando puedes:

- [ ] Clonar un repositorio sin ayuda
- [ ] Crear feature branch con nombre correcto (feature/XXX-descripcion)
- [ ] Hacer commits con mensajes descriptivos
- [ ] Subir rama al remoto con git push -u
- [ ] Crear Pull Request en GitHub
- [ ] Resolver conflictos basicos de merge
- [ ] Entender cuando escalar a tech lead

**Proximo Paso**: Nivel 2 - [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
```

**Content Sections** (from user-provided guide, keep structure):
- Objetivo
- Configuracion Inicial del Repositorio
- Comandos Basicos de Git
- Trabajo Basico con Ramas
- Convenciones de Nombres de Ramas (user-provided, keep as-is)
- Flujo de Trabajo Basico
- Checklist Pre-Push (user-provided, enhance if needed)
- Resolucion Basica de Conflictos (user-provided, keep as-is)
- Comandos de Navegacion
- Gestion de Repositorios Remotos
- Comandos de Informacion
- Comandos Basicos de Limpieza
- Comandos de Emergencia
- Ejemplo Practico Completo
- Notas Importantes
- Criterio de Exito (NEW - add this)

---

### 1.3 nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md

**Location**: `docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md`
**Purpose**: Teach sync workflow for long-running branches
**Estimated Length**: 600+ lines (existing content)
**Source**: Existing file at `docs/operaciones/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md`

**Required Modifications**:

1. **Update Frontmatter** (replace existing):
```yaml
---
title: Flujo de Sincronizacion con Develop Antes de Merge
date: 2025-11-13
level: intermediate
branch_source: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
branch_target: develop
domain: operaciones
prerequisites: Dominio de Nivel 1 (GIT_GITHUB_GUIA_INICIO.md)
next_step: ../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
estimated_time: 3-5 dias para dominar
status: active
---
```

2. **Add Prerequisites Section** (insert after frontmatter, before "Flujo: Sincronizar..."):
```markdown
## Prerequisitos

Antes de usar esta guia, debes dominar:

- Comandos basicos de Git (ver: [GIT_GITHUB_GUIA_INICIO.md](../nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md))
- Creacion y gestion de feature branches
- Resolucion basica de conflictos
- Haber completado al menos 5 PRs exitosos

NOTA: Si no cumples estos prerequisitos, comienza con Nivel 1.
```

3. **Remove Emojis** (if any):
- Search for emoji characters
- Replace with text equivalents

4. **Add Cross-References**:

Insert in "Problema que Resuelve" section:

```markdown
REFERENCIA: Para comandos basicos de merge, ver:
[GIT_GITHUB_GUIA_INICIO.md - Flujo de Trabajo Basico](../nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md#flujo-de-trabajo-basico)
```

Insert at end (before final status line):

```markdown
## Casos Especiales

Si encuentras error "fatal: no merge base" durante el sync, este es un caso avanzado.
Consulta: [MERGE_STRATEGY_NO_COMMON_ANCESTOR.md](../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md)
```

5. **Add Success Criteria** (append before final status):
```markdown
## Criterio de Exito

Has completado este nivel cuando puedes:

- [ ] Detectar cuando develop tiene cambios relevantes
- [ ] Analizar impacto de cambios en develop sobre tu branch
- [ ] Ejecutar sync (merge o rebase) sin perder cambios
- [ ] Resolver conflictos complejos surgidos del sync
- [ ] Validar que todo funciona despues del sync
- [ ] Crear PR limpio despues de sync exitoso

**Proximo Paso**: Para casos especiales, ver Nivel 3
```

**Content Sections** (existing, keep structure):
- [Keep all existing sections]
- [Add Prerequisites at top]
- [Add Cross-References as specified]
- [Add Success Criteria at end]

---

### 1.4 nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md

**Location**: `docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md`
**Purpose**: Resolve branches without common ancestor
**Estimated Length**: 800+ lines (existing content)
**Source**: Existing file at `docs/operaciones/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md`

**Required Modifications**:

1. **Update Frontmatter** (replace existing):
```yaml
---
title: Estrategia de Merge - Branch sin Ancestro Comun
date: 2025-11-13
level: advanced
branch_source: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
branch_target: develop
problem: No merge base - Historias divergentes
strategy: Cherry-pick con preservacion de historia
domain: operaciones
prerequisites: Dominio de Nivel 1 y Nivel 2, experiencia con merge y rebase
next_step: Consultar con tech lead si es primera vez
estimated_time: Segun caso (puede tomar 1-2 dias)
status: active
---
```

2. **Add Prerequisites Section** (insert after frontmatter):
```markdown
## Prerequisitos

IMPORTANTE: Esta es una guia AVANZADA. Necesitas:

- Dominio completo de Git basico (ver: [GIT_GITHUB_GUIA_INICIO.md](../nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md))
- Experiencia con sync de develop (ver: [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md))
- Comprension de Git internals (commits, SHAs, historia)
- Haber completado al menos 10 PRs exitosos

RECOMENDACION: Si es tu primer caso sin ancestro comun, consulta con tech lead antes de proceder.
```

3. **Remove Emojis** (if any):
- Search and replace emoji characters

4. **Add Success Criteria** (append before final status):
```markdown
## Criterio de Exito

Has completado este proceso cuando:

- [ ] Diagnosticaste correctamente el problema ("no merge base")
- [ ] Seleccionaste estrategia apropiada (cherry-pick/CP/rebase)
- [ ] Ejecutaste estrategia sin perder commits
- [ ] Resolviste todos los conflictos surgidos
- [ ] Validaste que todos los cambios estan presentes
- [ ] Historia de Git queda limpia y comprensible

NOTA: Este es un caso especial. No hay "proximo nivel" - consulta documentacion segun necesidad.
```

**Content Sections** (existing, keep structure):
- [Keep all existing sections]
- [Add Prerequisites at top]
- [Add Success Criteria at end]

---

## 2. Metadata Template Specifications

### 2.1 Metadata Field Definitions

**title** (string, required):
- Format: Sentence case (capitalize first word and proper nouns)
- Max length: 100 characters
- Example: "Guia de Inicio con Git/GitHub"
- Used in: README listings, file headers

**date** (string, required):
- Format: ISO 8601 (YYYY-MM-DD)
- Value: Last modification date
- Update: Every time file content changes
- Example: "2025-11-13"

**level** (enum, required):
- Valid values: "basic", "intermediate", "advanced"
- Maps to folder: basic → nivel_1_basico/, etc.
- Case sensitive: must be lowercase
- Example: "intermediate"

**domain** (string, required):
- For Git docs: Always "operaciones"
- Future: Could be "backend", "frontend", etc.
- Example: "operaciones"

**prerequisites** (string or list, required):
- Level 1: "Ninguno" (string)
- Level 2+: List of required knowledge or links
- Can reference other guides
- Example:
  ```yaml
  prerequisites: Dominio de Nivel 1 (GIT_GITHUB_GUIA_INICIO.md)
  ```
  OR
  ```yaml
  prerequisites:
    - Comandos basicos de Git
    - Creacion de feature branches
    - Resolucion basica de conflictos
  ```

**next_step** (string, optional but recommended):
- Format: Relative path to next guide OR descriptive text
- Level 1-2: Should point to next level
- Level 3: Can be "Consultar segun necesidad"
- Example: "../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md"

**estimated_time** (string, required):
- Format: Human-readable time estimate
- Include unit (semanas, dias, horas)
- Can be range
- Examples:
  - "1-2 semanas"
  - "3-5 dias para dominar"
  - "Segun caso"

**status** (enum, required):
- Valid values: "active", "deprecated", "draft"
- Most guides: "active"
- Deprecated guides: "deprecated" (include reason in guide)
- Work in progress: "draft"

**Additional Fields** (for specialized guides):
- branch_source: Source branch for merge guides
- branch_target: Target branch for merge guides
- problem: Problem being solved
- strategy: Strategy being used

### 2.2 YAML Validation Rules

**Syntax**:
```yaml
---
key: value
key_with_list:
  - item1
  - item2
nested:
  subkey: value
---
```

**Common Errors to Avoid**:
- Missing leading/trailing `---`
- Inconsistent indentation (use 2 spaces)
- Unquoted strings with colons (quote if contains `:`)
- Mixing tabs and spaces
- Missing space after colon

**Validation Command**:
```bash
# Check YAML syntax
python3 -c "import yaml; yaml.safe_load(open('file.md').read().split('---')[1])"
```

---

## 3. Cross-Reference Implementation

### 3.1 Link Syntax

**Standard Format**:
```markdown
[Link Text](relative/path/to/file.md)
```

**With Section Anchor**:
```markdown
[Link Text](relative/path/to/file.md#section-name)
```

**Section Anchor Rules**:
- Lowercase all letters
- Replace spaces with hyphens
- Remove special characters
- Example: "Flujo de Trabajo Basico" → "#flujo-de-trabajo-basico"

### 3.2 Relative Path Calculation

**From Level 1 to Level 2**:
```markdown
Current: docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
Target:  docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
Path:    ../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
```

**From Level 2 to Level 1**:
```markdown
Current: docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
Target:  docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
Path:    ../nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
```

**From Level 2 to Level 3**:
```markdown
Current: docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
Target:  docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
Path:    ../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
```

**General Rule**: `../<target_level_folder>/<target_file>.md`

### 3.3 Context for Cross-References

**Poor Cross-Reference** (no context):
```markdown
See FLUJO_SYNC_DEVELOP_ANTES_MERGE.md for more.
```

**Good Cross-Reference** (with context):
```markdown
NOTA: Para feature branches de larga duracion (> 3 dias), consulta la guia completa:
[FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
```

**Best Practice**:
- Explain WHY user might click link
- State WHAT they'll find in target guide
- Use keywords like "NOTA:", "REFERENCIA:", "IMPORTANTE:"

---

## 4. Emoji Removal Specifications

### 4.1 Emoji Detection

**Comprehensive Regex**:
```bash
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" file.md
```

**Common Emojis in Documentation**:
- Checkmark: ✅
- Cross mark: ❌
- Warning: ⚠️
- Information: ℹ️
- Book: 📘
- Rocket: 🚀
- Wrench: 🔧
- Star: ⭐

### 4.2 Replacement Strategy

**Replace with Text Labels**:
| Emoji | Context | Replacement |
|-------|---------|-------------|
| ✅ | Task completed | "COMPLETADO:" or remove entirely |
| ❌ | Task not done | "PENDIENTE:" or remove entirely |
| ⚠️ | Warning | "ADVERTENCIA:" or "CUIDADO:" |
| ℹ️ | Information | "NOTA:" or "INFO:" |
| 📘 | Reference | "REFERENCIA:" or "VER:" |
| 🚀 | Feature/deployment | "NUEVO:" or remove |
| 🔧 | Tool/command | "HERRAMIENTA:" or remove |
| ⭐ | Important | "IMPORTANTE:" or "DESTACADO:" |

**Context-Sensitive Replacement**:
```markdown
# BEFORE
✅ Crear rama feature

# AFTER (if checklist)
- [ ] Crear rama feature

# OR (if completed item)
COMPLETADO: Crear rama feature

# OR (if just emphasis, remove)
Crear rama feature
```

### 4.3 Validation

**After Removal**:
```bash
# Should return zero results
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/ -r
echo $?  # Should be 1 (no matches found)
```

---

## 5. Implementation Procedures

### 5.1 Procedure: Create Folder Structure

**Input**: None
**Output**: 3-level folder structure
**Duration**: 5 minutes

**Steps**:
```bash
# 1. Navigate to operaciones directory
cd docs/operaciones/

# 2. Create git directory and subdirectories
mkdir -p git/{nivel_1_basico,nivel_2_intermedio,nivel_3_avanzado,planificacion}

# 3. Verify structure
ls -R git/

# Expected output:
# git/:
# nivel_1_basico  nivel_2_intermedio  nivel_3_avanzado  planificacion
#
# git/nivel_1_basico:
#
# git/nivel_2_intermedio:
#
# git/nivel_3_avanzado:
#
# git/planificacion:
# ISSUE_GIT_DOCS_REORGANIZATION.md  FEASIBILITY_ANALYSIS_GIT_DOCS.md  HLD_GIT_DOCS_REORGANIZATION.md  LLD_GIT_DOCS_REORGANIZATION.md
```

**Validation**:
```bash
# Check all folders exist
test -d docs/devops/git/nivel_1_basico && echo "Level 1 OK"
test -d docs/devops/git/nivel_2_intermedio && echo "Level 2 OK"
test -d docs/devops/git/nivel_3_avanzado && echo "Level 3 OK"
test -d docs/devops/git/planificacion && echo "Planning OK"
```

---

### 5.2 Procedure: Integrate Basic Guide

**Input**: User-provided basic guide content (in conversation)
**Output**: docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
**Duration**: 2 hours

**Steps**:

1. **Create file with frontmatter**:
```bash
cat > docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md <<'EOF'
---
title: Guia de Inicio con Git/GitHub
date: 2025-11-13
level: basic
domain: operaciones
prerequisites: Ninguno
next_step: ../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
estimated_time: 1-2 semanas
status: active
---
EOF
```

2. **Append user-provided content**:
```bash
# Copy user-provided content from conversation
# Paste into file (using editor)
vim docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
# (append content after frontmatter)
```

3. **Remove emojis**:
```bash
# Search for emojis
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md

# Manually replace each emoji with text equivalent
# Example: "📘 **Para..." → "NOTA: Para..."
```

4. **Add cross-references**:

Find section "Integrar cambios de develop antes de pull request", insert:
```markdown
NOTA: Para feature branches de larga duracion (> 3 dias), consulta la guia completa:
[FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
```

Find section "Notas Importantes", insert:
```markdown
Si encuentras error "fatal: no merge base", consulta:
[MERGE_STRATEGY_NO_COMMON_ANCESTOR.md](../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md)
```

5. **Append success criteria section**:
```markdown
## Criterio de Exito

Has completado este nivel cuando puedes:

- [ ] Clonar un repositorio sin ayuda
- [ ] Crear feature branch con nombre correcto (feature/XXX-descripcion)
- [ ] Hacer commits con mensajes descriptivos
- [ ] Subir rama al remoto con git push -u
- [ ] Crear Pull Request en GitHub
- [ ] Resolver conflictos basicos de merge
- [ ] Entender cuando escalar a tech lead

**Proximo Paso**: Nivel 2 - [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
```

6. **Validate**:
```bash
# Check frontmatter syntax
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md').read().split('---')[1])"

# Check no emojis
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md
# Should return nothing

# Check cross-references point to existing paths (will validate after all files moved)
```

---

### 5.3 Procedure: Move Advanced Guides

**Input**: Existing guides in docs/operaciones/
**Output**: Guides moved to nivel_2_intermedio/ and nivel_3_avanzado/
**Duration**: 1 hour

**Steps**:

1. **Move Level 2 guide** (preserves Git history):
```bash
git mv docs/operaciones/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md \
       docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
```

2. **Move Level 3 guide**:
```bash
git mv docs/operaciones/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md \
       docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
```

3. **Update Level 2 frontmatter**:
```bash
vim docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
```

Replace frontmatter section with:
```yaml
---
title: Flujo de Sincronizacion con Develop Antes de Merge
date: 2025-11-13
level: intermediate
branch_source: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
branch_target: develop
domain: operaciones
prerequisites: Dominio de Nivel 1 (GIT_GITHUB_GUIA_INICIO.md)
next_step: ../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
estimated_time: 3-5 dias para dominar
status: active
---
```

4. **Add prerequisites section to Level 2**:

Insert after frontmatter:
```markdown
## Prerequisitos

Antes de usar esta guia, debes dominar:

- Comandos basicos de Git (ver: [GIT_GITHUB_GUIA_INICIO.md](../nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md))
- Creacion y gestion de feature branches
- Resolucion basica de conflictos
- Haber completado al menos 5 PRs exitosos

NOTA: Si no cumples estos prerequisitos, comienza con Nivel 1.
```

5. **Add cross-references to Level 2**:

In "Problema que Resuelve" section:
```markdown
REFERENCIA: Para comandos basicos de merge, ver:
[GIT_GITHUB_GUIA_INICIO.md](../nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md#flujo-de-trabajo-basico)
```

Before final status line:
```markdown
## Casos Especiales

Si encuentras error "fatal: no merge base" durante el sync, este es un caso avanzado.
Consulta: [MERGE_STRATEGY_NO_COMMON_ANCESTOR.md](../nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md)
```

6. **Add success criteria to Level 2**:
```markdown
## Criterio de Exito

Has completado este nivel cuando puedes:

- [ ] Detectar cuando develop tiene cambios relevantes
- [ ] Analizar impacto de cambios en develop sobre tu branch
- [ ] Ejecutar sync (merge o rebase) sin perder cambios
- [ ] Resolver conflictos complejos surgidos del sync
- [ ] Validar que todo funciona despues del sync
- [ ] Crear PR limpio despues de sync exitoso

**Proximo Paso**: Para casos especiales, ver Nivel 3
```

7. **Update Level 3 frontmatter**:
```bash
vim docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
```

Replace frontmatter:
```yaml
---
title: Estrategia de Merge - Branch sin Ancestro Comun
date: 2025-11-13
level: advanced
branch_source: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
branch_target: develop
problem: No merge base - Historias divergentes
strategy: Cherry-pick con preservacion de historia
domain: operaciones
prerequisites: Dominio de Nivel 1 y Nivel 2, experiencia con merge y rebase
next_step: Consultar con tech lead si es primera vez
estimated_time: Segun caso (puede tomar 1-2 dias)
status: active
---
```

8. **Add prerequisites to Level 3**:

Insert after frontmatter:
```markdown
## Prerequisitos

IMPORTANTE: Esta es una guia AVANZADA. Necesitas:

- Dominio completo de Git basico (ver: [GIT_GITHUB_GUIA_INICIO.md](../nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md))
- Experiencia con sync de develop (ver: [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md))
- Comprension de Git internals (commits, SHAs, historia)
- Haber completado al menos 10 PRs exitosos

RECOMENDACION: Si es tu primer caso sin ancestro comun, consulta con tech lead antes de proceder.
```

9. **Add success criteria to Level 3**:

Append before final status:
```markdown
## Criterio de Exito

Has completado este proceso cuando:

- [ ] Diagnosticaste correctamente el problema ("no merge base")
- [ ] Seleccionaste estrategia apropiada (cherry-pick/CP/rebase)
- [ ] Ejecutaste estrategia sin perder commits
- [ ] Resolviste todos los conflictos surgidos
- [ ] Validaste que todos los cambios estan presentes
- [ ] Historia de Git queda limpia y comprensible

NOTA: Este es un caso especial. No hay "proximo nivel" - consulta documentacion segun necesidad.
```

10. **Validate**:
```bash
# Check files moved
ls docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
ls docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md

# Check Git history preserved
git log --follow docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
# Should show history from original location

# Check frontmatter syntax
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md').read().split('---')[1])"
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md').read().split('---')[1])"
```

---

### 5.4 Procedure: Create README

**Input**: Knowledge of all guides
**Output**: docs/devops/git/README.md
**Duration**: 1.5 hours

**Steps**:

1. **Create file skeleton**:
```bash
cat > docs/devops/git/README.md <<'EOF'
---
title: Git/GitHub Documentation - Learning Roadmap
date: 2025-11-13
domain: operaciones
status: active
---

# Git/GitHub Documentation

[Content to be filled]

---

**Ultima actualizacion**: 2025-11-13
**Mantenedor**: Tech Lead / DevOps Team
EOF
```

2. **Fill in sections** (use template from Section 1.1):

Add overview paragraph:
```markdown
Esta documentacion proporciona una guia completa para trabajar con Git y GitHub en el proyecto, organizada en tres niveles de complejidad: Basico, Intermedio y Avanzado. Cada nivel construye sobre el anterior, permitiendo un aprendizaje progresivo desde comandos fundamentales hasta estrategias avanzadas de merge.
```

Add quick start:
```markdown
## Inicio Rapido

Si eres nuevo en Git o en el equipo: Comienza con [Nivel 1 - Guia de Inicio](nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md)

Si tienes un problema especifico: Usa la [Matriz de Decisiones](#matriz-de-decisiones) para encontrar la guia correcta.
```

Add structure table:
```markdown
## Estructura de la Documentacion

| Nivel | Audiencia | Contenido | Tiempo Estimado |
|-------|-----------|-----------|-----------------|
| Basico | 0-6 meses Git | Comandos esenciales, workflows diarios, branch naming | 1-2 semanas |
| Intermedio | 6+ meses Git | Sync con develop, conflictos complejos, validacion pre-PR | 3-5 dias |
| Avanzado | 1+ años Git | Casos especiales, merge sin ancestro comun, cherry-pick | Segun necesidad |
```

Add learning roadmap (3 subsections for each level):
```markdown
## Roadmap de Aprendizaje

### Nivel 1 - Basico

**Objetivo**: Dominar comandos Git fundamentales y poder trabajar de forma autonoma en feature branches simples.

**Prerequisitos**: Ninguno

**Guias**:
- [GIT_GITHUB_GUIA_INICIO.md](nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md) - Comandos, workflows, convenciones

**Criterio de Avance**:
- Puedes crear feature branch y PR sin ayuda
- Entiendes resolucion basica de conflictos
- Sigues convenciones de branch naming

**Siguiente Paso**: Nivel 2 - Intermedio

### Nivel 2 - Intermedio

**Objetivo**: Manejar feature branches de larga duracion y sincronizar con develop antes de crear PR.

**Prerequisitos**: Dominio de Nivel 1, experiencia con al menos 5 PRs

**Guias**:
- [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md) - Sync workflow completo

**Criterio de Avance**:
- Puedes detectar y sincronizar cambios de develop
- Resuelves conflictos complejos con confianza
- Validas cambios antes de PR

**Siguiente Paso**: Nivel 3 - Avanzado (solo si es necesario)

### Nivel 3 - Avanzado

**Objetivo**: Resolver casos especiales como branches sin ancestro comun.

**Prerequisitos**: Dominio de Nivel 1 y 2, comprension de Git internals

**Guias**:
- [MERGE_STRATEGY_NO_COMMON_ANCESTOR.md](nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md) - Cherry-pick strategy

**Criterio de Avance**:
- Diagnosticas error "no merge base"
- Ejecutas cherry-pick con batching
- Sabes cuando escalar a tech lead

**Siguiente Paso**: Consultar documentacion segun necesidad especifica
```

Add decision matrix:
```markdown
## Matriz de Decisiones

Encuentra la guia correcta segun tu situacion:

| Situacion | Guia Recomendada | Nivel |
|-----------|------------------|-------|
| Soy nuevo en Git o en el equipo | [GIT_GITHUB_GUIA_INICIO.md](nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md) | Basico |
| Necesito crear nueva feature branch | [GIT_GITHUB_GUIA_INICIO.md - Flujo de Trabajo](nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md#flujo-de-trabajo-basico) | Basico |
| Mi feature branch tiene > 3 dias | [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md) | Intermedio |
| Conflictos complejos al hacer merge | [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md - Resolucion](nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md#paso-3-sincronizar-tu-branch-con-develop) | Intermedio |
| Error "fatal: no merge base" | [MERGE_STRATEGY_NO_COMMON_ANCESTOR.md](nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md) | Avanzado |
| Necesito hacer cherry-pick de commits | [MERGE_STRATEGY_NO_COMMON_ANCESTOR.md - Cherry-pick](nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md#estrategia-1-cherry-pick-recomendada) | Avanzado |
| No se cual guia leer | Empieza con [Nivel 1](nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md) y avanza progresivamente | Basico |
```

Add quick reference:
```markdown
## Referencia Rapida de Comandos

| Categoria | Comando | Descripcion | Guia |
|-----------|---------|-------------|------|
| Configuracion | `git clone URL` | Clonar repositorio | Nivel 1 |
| Configuracion | `git fetch origin develop` | Traer cambios de develop | Nivel 2 |
| Branches | `git checkout -b feature/XXX-desc` | Crear nueva rama | Nivel 1 |
| Branches | `git branch -a` | Listar todas las ramas | Nivel 1 |
| Commits | `git add .` | Agregar cambios al staging | Nivel 1 |
| Commits | `git commit -m "mensaje"` | Crear commit | Nivel 1 |
| Sync | `git pull origin develop` | Traer y mergear develop | Nivel 1 |
| Sync | `git merge develop` | Mergear develop en tu rama | Nivel 2 |
| Push | `git push -u origin rama` | Subir rama (primera vez) | Nivel 1 |
| Push | `git push` | Subir cambios (siguientes veces) | Nivel 1 |
| Conflictos | `git status` | Ver archivos en conflicto | Nivel 1 |
| Avanzado | `git cherry-pick SHA` | Aplicar commit especifico | Nivel 3 |
| Avanzado | `git merge-base branch1 branch2` | Buscar ancestro comun | Nivel 3 |
```

Add contribution guidelines:
```markdown
## Contribuir a Esta Documentacion

### Agregar Nueva Guia

1. Determinar nivel apropiado (basico/intermedio/avanzado)
2. Crear archivo en carpeta correspondiente: `docs/devops/git/nivel_X_XXX/NOMBRE_GUIA.md`
3. Usar plantilla de metadata (ver seccion Plantilla)
4. Actualizar este README:
   - Agregar a Matriz de Decisiones
   - Actualizar Referencia Rapida si aplica
   - Agregar a Roadmap de Aprendizaje del nivel correspondiente
5. Agregar cross-references desde guias relacionadas
6. Crear PR con descripcion detallada

### Actualizar Guia Existente

1. Editar archivo correspondiente
2. Actualizar campo `date` en frontmatter
3. Si cambios mayores: actualizar README si afecta navegacion
4. Validar que cross-references siguen funcionando
5. Crear PR con descripcion de cambios

### Plantilla de Metadata

```yaml
---
title: Titulo de la Guia
date: YYYY-MM-DD
level: basic|intermediate|advanced
domain: operaciones
prerequisites: Lista de prerequisitos o "Ninguno"
next_step: ../path/to/next/guide.md
estimated_time: X semanas/dias
status: active
---
```

### Reglas de Contribucion

- NO usar emojis (usar texto: NOTA:, ADVERTENCIA:, IMPORTANTE:)
- Incluir ejemplos practicos con comandos
- Mantener tono profesional y objetivo
- Validar sintaxis de markdown y YAML
- Probar todos los comandos antes de documentar
```

Add contact section:
```markdown
## Contacto y Soporte

- **Dudas sobre Git**: Consultar con Tech Lead
- **Problemas con documentacion**: Crear issue en GitHub
- **Mejoras sugeridas**: Crear PR siguiendo guia de contribucion

Para casos urgentes o bloqueantes, escalar a tech lead directamente.
```

3. **Validate**:
```bash
# Check frontmatter
python3 -c "import yaml; yaml.safe_load(open('docs/devops/git/README.md').read().split('---')[1])"

# Check all links point to existing files
# (Manual check or use markdown link checker)

# Check no emojis
grep -P "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/README.md
```

---

### 5.5 Procedure: Final Validation

**Input**: All reorganized files
**Output**: Validation report (pass/fail)
**Duration**: 30 minutes

**Validation Checklist**:

1. **Structure Validation**:
```bash
# Check all folders exist
test -d docs/devops/git/nivel_1_basico && echo "✓ Level 1 folder" || echo "✗ Missing Level 1"
test -d docs/devops/git/nivel_2_intermedio && echo "✓ Level 2 folder" || echo "✗ Missing Level 2"
test -d docs/devops/git/nivel_3_avanzado && echo "✓ Level 3 folder" || echo "✗ Missing Level 3"
test -d docs/devops/git/planificacion && echo "✓ Planning folder" || echo "✗ Missing Planning"

# Check all guides exist
test -f docs/devops/git/README.md && echo "✓ README" || echo "✗ Missing README"
test -f docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md && echo "✓ Level 1 guide" || echo "✗ Missing Level 1 guide"
test -f docs/devops/git/nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md && echo "✓ Level 2 guide" || echo "✗ Missing Level 2 guide"
test -f docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md && echo "✓ Level 3 guide" || echo "✗ Missing Level 3 guide"
```

2. **Emoji Validation**:
```bash
# Should return 0 matches
grep -rP "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_1_basico/
grep -rP "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_2_intermedio/
grep -rP "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/nivel_3_avanzado/
grep -rP "[\x{1F600}-\x{1F64F}]|[\x{1F300}-\x{1F5FF}]|[\x{1F680}-\x{1F6FF}]|[\x{2600}-\x{27BF}]|[\x{2700}-\x{27BF}]" docs/devops/git/README.md

echo "✓ No emojis found" # if all return 0
```

3. **Metadata Validation**:
```bash
# Validate YAML syntax for all guides
for file in docs/devops/git/{nivel_1_basico,nivel_2_intermedio,nivel_3_avanzado}/*.md docs/devops/git/README.md; do
  echo "Checking: $file"
  python3 -c "import yaml; yaml.safe_load(open('$file').read().split('---')[1])" && echo "✓ Valid YAML" || echo "✗ Invalid YAML"
done
```

4. **Cross-Reference Validation** (manual):
- Open each guide
- Click each cross-reference link
- Verify target file exists and link works
- Check that link goes to intended section

5. **Content Quality Check** (manual):
- Each guide has frontmatter with all required fields
- Prerequisites section exists in Level 2 and 3
- Success criteria section exists in all guides
- Cross-references have context
- No emojis present

**Pass Criteria**:
- All folders exist
- All guide files exist
- 0 emojis found
- 100% YAML valid
- 100% cross-references work
- All content quality checks pass

**If any check fails**: Fix before proceeding to deployment

---

## 6. Testing Specifications

**Note**: Detailed in FASE 4, brief outline here for reference

### 6.1 Automated Tests

**Test 1: Structure Exists**
- Assert: All 4 folders exist
- Assert: README.md exists
- Assert: All 3 guide files exist

**Test 2: No Emojis**
- Assert: grep emoji regex returns 0 results

**Test 3: Valid YAML**
- Assert: All frontmatter parses successfully

### 6.2 Manual Tests

**Test 4: Cross-References Work**
- Manual: Click each link, verify target exists

**Test 5: Content Completeness**
- Manual: Each guide has required sections

### 6.3 User Acceptance Test

**Scenario**: New developer finds basic guide
- Given: Developer is new to Git
- When: Opens README.md
- Then: Can find Level 1 guide in < 2 minutes

---

## 7. Deployment Specifications

**Note**: Detailed in FASE 5, brief outline here

### 7.1 Deployment Steps

1. Create folder structure
2. Create/modify guide files
3. Validate all checks pass
4. Commit with message
5. Push to branch

### 7.2 Rollback Plan

If deployment fails:
```bash
# Revert all changes
git reset --hard HEAD~1

# Or revert specific commit
git revert <commit-sha>
```

---

## 8. Maintenance Specifications

**Note**: Detailed in FASE 6, brief outline here

### 8.1 Quarterly Maintenance

- Validate all cross-references still work
- Check for outdated content (Git version changes)
- Review and update examples if needed
- Verify metadata completeness

### 8.2 Update Triggers

- Git workflow changes
- New conventions adopted
- User feedback received
- Broken links detected

---

**Status**: LLD COMPLETE
**Approved By**: SDLC Agent (autonomous)
**Next Step**: FASE 4 - TESTING (Validation Plan)
**Estimated Duration**: 1 hour
