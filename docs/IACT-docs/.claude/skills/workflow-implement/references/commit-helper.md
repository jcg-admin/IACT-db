```yml
type: Herramienta PHASE 6
category: Commits
version: 1.0
purpose: Guía de cómo usar Conventional Commits en PHASE 6: EXECUTE.
goal: Estandarizar mensajes de commit y crear auditoría clara.
updated_at: 2026-03-25
owner: workflow-execute
```

# Commit Helper - Conventional Commits Guide

## Propósito

Guía de cómo usar Conventional Commits en PHASE 6: EXECUTE.

> Objetivo: Estandarizar mensajes de commit y crear auditoría clara.

---

Guía para crear commits siguiendo **Conventional Commits** en el proyecto THYROX.

---

## Tabla de Contenidos

- [CUANDO HAGAS UN COMMIT, USA LOS TEMPLATES](#cuando-hagas-un-commit-usa-los-templates)
- [Cuando Usar](#cuando-usar)
- [Formato Base](#formato-base)
- [Tipos Válidos](#tipos-v�lidos)
- [Scopes Comunes en THYROX](#scopes-comunes-en-thyrox)
- [Reglas Esenciales](#reglas-esenciales)
- [Templates Disponibles](#templates-disponibles)
- [Ejemplos Rápidos](#ejemplos-r�pidos)
- [Proceso de Commit](#proceso-de-commit)
- [Validación Pre-Commit](#validacion-pre-commit)
- [Best Practices](#best-practices)
- [Integración con THYROX](#integracion-con-thyrox)
- [Referencias Externas](#referencias-externas)
- [Ver También](#ver-tambien)

---


## CUANDO HAGAS UN COMMIT, USA LOS TEMPLATES

Ahora que necesites hacer un commit, haz esto:

### Paso 1: Determina el tipo de cambio

- ¿Nueva feature? → Usa **feature.template**
- ¿Bug fix? → Usa **bugfix.template**
- ¿Refactoring? → Usa **refactor.template**
- ¿Documentación? → Usa **documentation.template**
- ¿Completar tarea THYROX entera? → Usa **task-completion.template**
- ¿Múltiples archivos con cambios transversales? → Usa **multiple-files.template**
- ¿Necesitas referencia completa? → Usa **commit-message-main.template**

### Paso 2: Consulta el template

```bash
cat .claude/skills/thyrox/assets/[template-nombre].template
```

### Paso 3: Completa el template

Copia el contenido, llena los espacios en blanco, elimina comentarios innecesarios.

### Paso 4: Haz el commit

```bash
git add [archivos]
git commit -m "[contenido del template completado]"
```

---

Claude te dirá cuál template usar según el tipo de cambio que hayas hecho.

---

## Cuando Usar

- Usuario pide hacer commit
- Se menciona "commit", "guardar cambios", "versionar"
- Después de completar tarea
- Al finalizar traducción o modificación
- Al terminar fase de THYROX

---

## Formato Base

```
<type>(<scope>): <description>

[body opcional]

[footer opcional]
```

---

## Tipos Válidos

| Tipo | Uso | Ejemplo |
|------|-----|---------|
| **feat** | Nueva funcionalidad | `feat(api): add user login endpoint` |
| **fix** | Corrección de bug | `fix(auth): handle token expiry` |
| **docs** | Solo documentación | `docs(readme): update setup instructions` |
| **style** | Formato (sin cambios funcionales) | `style(code): fix indentation` |
| **refactor** | Refactorización | `refactor(db): simplify queries` |
| **test** | Tests | `test(api): add authentication tests` |
| **chore** | Build, tools, dependencias | `chore(deps): update dependencies` |
| **perf** | Performance | `perf(api): optimize query performance` |

---

## Scopes Comunes en THYROX

| Scope | Cuándo usar |
|-------|------------|
| **api** | Cambios en API |
| **auth** | Autenticación y autorización |
| **db** | Base de datos, modelos |
| **build** | Build, CI/CD, configuración |
| **docs** | Documentación del proyecto |
| **tests** | Suite de tests |
| **roadmap** | Cambios en ROADMAP.md |
| **changelog** | Cambios en CHANGELOG.md |

---

## Reglas Esenciales

1. **Description**: máximo 72 caracteres, imperativo presente, sin punto final
2. **NO emojis** - Evitar completamente
3. **NO co-authored-by** sin colaboración real
4. **type y scope** en minúsculas
5. **Body** opcional pero recomendado para cambios no triviales

---

## Templates Disponibles

Usar los templates en `/assets/` para casos específicos:

| Archivo | Tipo | Uso |
|---------|------|-----|
| **commit-message-main.template** | Master | Referencia completa y ejemplos |
| **feature.template** | feat | Nueva característica o funcionalidad |
| **bugfix.template** | fix | Corrección de errores |
| **refactor.template** | refactor | Refactorización de código |
| **documentation.template** | docs | Cambios de documentación |
| **task-completion.template** | feat | Al completar una tarea de THYROX |
| **multiple-files.template** | multiple | Múltiples archivos modificados |

---

## Ejemplos Rápidos

### Agregar Feature

```
feat(api): add password reset endpoint

Implementar endpoint POST /auth/password-reset que permite
a usuarios solicitar reset de contraseña via email.

Incluye:
- Token generation con expiry de 1 hora
- Email validation
- Tests completos
```

### Fix Bug

```
fix(auth): handle null user in token validation

Corregir crash cuando user es null en middleware de
validacion de tokens. Ahora retorna 401 Unauthorized.
```

### Refactor

```
refactor(db): consolidate user queries into repository pattern

Centralizar todas las queries de usuarios en UserRepository
para evitar duplicacion y mejorar mantenibilidad.
```

### Completar Tarea THYROX

```
feat(api): implement user authentication (Phase 4: EXECUTE)

ROADMAP Reference: Phase 2 > User Authentication
- [x] Database schema
- [x] JWT service  
- [x] API endpoints
- [x] Tests
- [x] Documentation

Closes: ROADMAP Phase 2 User Authentication
```

---

## Proceso de Commit

### Paso 1: Revisar Cambios

```bash
git status           # Ver archivos modificados
git diff             # Ver cambios en detalle
```

### Paso 2: Stagear Archivos

```bash
git add <archivo1> <archivo2>   # Agregar archivos específicos
# NO hacer: git add .            # Evitar agregar todo sin revisar
```

### Paso 3: Crear Commit

**Opción A - Línea simple**:
```bash
git commit -m "type(scope): description"
```

**Opción B - Con body y editor** (mejor para cambios complejos):
```bash
git commit    # Se abre editor
# Escribir type(scope): description
# Línea en blanco
# Body con detalles
# Ctrl+S, Ctrl+X (en nano)
```

### Paso 4: Verificar

```bash
git log -1          # Ver commit creado
git log --oneline   # Ver en formato corto
```

---

## Validación Pre-Commit

### Antes de hacer commit

- [ ] Revisar `git diff` completo
- [ ] Confirmar cambios son atómicos (un cambio lógico)
- [ ] Description describe el cambio claramente
- [ ] Build exitoso si aplica (`make html` para Sphinx)
- [ ] No hay conflictos pendientes

### Si necesitas corregir

```bash
# Si no hiciste push aún:
git commit --amend    # Modificar commit anterior
git commit --amend --no-edit  # Sin abrir editor
```

---

## Best Practices

### Commits Atómicos

Un commit = un cambio lógico

BIEN:
```
commit 1: feat(db): add user table
commit 2: feat(api): add user endpoints
commit 3: test(api): add user tests
```

MAL:
```
commit 1: feat(db): add user table AND api endpoints AND tests
```

### Stagear Selectivamente

```bash
# BIEN:
git add api/user.py
git add tests/test_user.py
git commit -m "feat(api): add user endpoints"

# EVITAR:
git add .
git commit -m "random changes"
```

### Frecuencia

- Commits frecuentes (cada 30-60 minutos de trabajo)
- Pequeños cambios lógicos
- Fácil de revertir si algo falla

---

## Integración con THYROX

**Cuando completas una tarea:**

```
1. Terminas feature/fix/refactor
2. Haces commit con Conventional Commits
3. Actualizas ROADMAP.md:
   - [x] Tarea (YYYY-MM-DD)
4. Si completa feature entera:
   - Generar changelog
   - Considerar git tag v0.X.X
```

---

## Referencias Externas

- **Conventional Commits**: https://www.conventionalcommits.org/
- **Git Best Practices**: https://chris.beams.io/posts/git-commit/
- **Atomic Commits**: https://www.freshconsulting.com/blog/atomic-commits/

---

## Ver También

- `assets/` - Plantillas de commits para casos específicos
- [conventions](../../../references/conventions.md) - Convenciones generales del proyecto
- ROADMAP.md - Plan de proyecto para referenciar en commits

---

**Última actualización**: 2026-03-25
**Versión**: 1.0.0
