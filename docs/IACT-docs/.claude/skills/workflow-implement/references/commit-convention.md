```yml
type: Documentación del Proyecto
category: Convenciones de Control de Versión
version: 1.0
purpose: Guía de convenciones para mensajes de commits
goal: Estandarizar commits para mejor legibilidad e integración automática
updated_at: 2026-03-25
owner: workflow-execute
```

# Commit Convention

## Propósito

Guía de convenciones para mensajes de commits en el proyecto THYROX, basada en Conventional Commits.

> Objetivo: Todos los commits sean legibles, estructurados, y permitir changelog y versionado automático.

---

## Formato de Commit

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type (Obligatorio)

**feat:** Nuevo feature<br>
**fix:** Bug fix<br>
**docs:** Cambios en documentación<br>
**style:** Cambios de formato (no afectan código)<br>
**refactor:** Refactoring de código<br>
**perf:** Mejoras de performance<br>
**test:** Agregando o actualizando tests<br>
**chore:** Cambios en build, deps, etc.

### Scope (Opcional)

Área del proyecto afectada:

```
feat(api): add user authentication
fix(db): resolve connection pool issue
docs(readme): update installation
style(code): format with prettier
refactor(service): simplify user service
test(auth): add login tests
chore(deps): update dependencies
```

**Ejemplos de scope:**<br>
api, db, docs, ui, auth, tests, build, deps, config, ci

### Subject (Obligatorio)

- Máximo 50 caracteres
- Comienza con minúscula
- Imperative mood ("add" no "added" o "adds")
- Sin punto final

**Correcto:**<br>
`feat(api): add user authentication endpoint`<br>
`fix(db): resolve connection pool issue`

**Incorrecto:**<br>
`feat(api): Added user authentication endpoint.`<br>
`fix(db): Resolves connection pool issue.`

### Body (Opcional pero recomendado)

- Explica QUÉ cambió y POR QUÉ
- No el CÓMO (eso está en el código)
- Máximo 72 caracteres por línea
- Separado del subject por línea en blanco

**Ejemplo:**

```
feat(api): add user authentication endpoint

Add JWT-based authentication for API endpoints.
This allows secure user sessions and role-based
access control.

Implements:
- Login endpoint
- Token generation
- Token validation middleware
- Refresh token support
```

### Footer (Opcional)

Para referencias a issues o breaking changes:

```
Fixes #123
Closes #456
Breaking-Change: Session format changed
```

---

## Ejemplos Completos

### Nuevo Feature

```
feat(api): add password reset functionality

Implement email-based password reset for users.

- Add reset password endpoint
- Send reset token via email
- Validate token and update password
- Add tests for all scenarios

Fixes #234
```

### Bug Fix

```
fix(auth): prevent unauthorized access to admin endpoints

Add proper role validation in middleware. Previously,
users could access admin endpoints without proper
authorization.

Tests added to prevent regression.

Fixes #567
```

### Documentation

```
docs(api): document authentication endpoints

Add comprehensive documentation for:
- Login endpoint
- Token refresh
- Logout
- Password reset

Includes curl examples and response schemas.
```

### Refactoring

```
refactor(service): extract database logic into repositories

Move database queries from service layer to repository
pattern. Improves testability and separation of concerns.

No functional changes. All tests pass.
```

---

## Breaking Changes

Marca breaking changes explícitamente:

```
feat(api)!: change user response format

BREAKING CHANGE: The user response format has changed.
Previously returned { id, name, email }.
Now returns { userId, userName, emailAddress }.

Update clients accordingly.
```

O en el footer:

```
feat(api): change user response format

Description of changes...

BREAKING-CHANGE: user response format changed
```

---

## Convenciones del Proyecto

### Siempre en Inglés

```
OK: feat(api): add authentication
MAL: feat(api): agregar autenticación
```

### Referencia a Issues

```
OK: Fixes #123
OK: Closes #456
OK: Resolves #789

MAL: fix #123 (sin palabra)
MAL: fixes issue #123 (demasiado verboso)
```

### Scope Consistente

Usa el mismo scope para cambios relacionados:

```
feat(api): add user endpoint
feat(api): add validation
feat(api): add tests
```

### No Demasiado Largo

```
OK: feat(api): add user authentication
MAL: feat(api): add user authentication with JWT tokens and refresh functionality
```

---

## Integración Automática

Con commits bien formateados:

### Changelog Automático

```
semantic-release genera CHANGELOG.md:

feat: Nuevas features van en sección "Features"
fix: Bug fixes van en sección "Bug Fixes"
BREAKING CHANGE: Van en sección "Breaking Changes"
```

### Versionado Automático

```
feat commit → version minor (0.1.0 → 0.2.0)
fix commit → version patch (0.1.0 → 0.1.1)
BREAKING CHANGE → version major (0.1.0 → 1.0.0)
```

---

## Checklist para Commits

Antes de hacer `git push`:

- [ ] Mensaje describe claramente el cambio
- [ ] Tipo es correcto (feat, fix, docs, etc.)
- [ ] Scope es aplicable
- [ ] Subject es imperativo y conciso
- [ ] Body explica el POR QUÉ
- [ ] Issue referenciado con Fixes/Closes
- [ ] No hay errores de ortografía
- [ ] Tests pasan localmente
- [ ] Código sigue las convenciones

---

## Git Aliases (Opcional)

Agrega estos aliases para facilitar commits:

```bash
# Mostrar commits con formato
git config --global alias.log1 'log --oneline'
git config --global alias.log2 'log --oneline --graph'

# Commit con template
git config --global alias.commit-msg 'commit -t .commit-template'
```

---

## Recursos

**Conventional Commits:** https://www.conventionalcommits.org/<br>
**Semantic Versioning:** https://semver.org/<br>
**Git Guide:** https://git-scm.com/book/

---

**Última Actualización:** 2026-03-25<br>
**Próxima Review:** 2026-04-25
