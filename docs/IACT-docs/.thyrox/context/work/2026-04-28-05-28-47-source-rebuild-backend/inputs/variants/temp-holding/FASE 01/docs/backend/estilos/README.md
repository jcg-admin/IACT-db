# Estilos - Backend

Este directorio contiene guias de estilo especificas del backend del proyecto IACT.

## Proposito

Establecer convenciones de:
- Estilo de codigo Python
- Estilo de codigo Django
- Best practices de DRF
- Convenciones de naming
- Estructura de archivos

## Nomenclatura

```
nombre-lenguaje-style-guide.md
nombre-framework-best-practices.md
```

**Ejemplos:**
- `python-style-guide.md`
- `django-best-practices.md`
- `drf-conventions.md`
- `sql-naming-conventions.md`

## Guias de Estilo Planificadas

### Python Style Guide
- Basado en PEP 8
- Configuracion de black, flake8, isort
- Type hints y mypy
- Docstrings (Google style)

### Django Best Practices
- Estructura de apps
- Organizacion de modelos
- Managers y QuerySets
- Signals y cuando usarlos
- Migraciones

### Django REST Framework
- Serializacion
- ViewSets vs APIViews
- Permisos y autenticacion
- Throttling y rate limiting
- Versionado de APIs

### Database & SQL
- Naming de tablas
- Naming de columnas
- Indices
- Constraints

## Herramientas de Estilo

### Formatters
- **black:** Formateo automatico de codigo
- **isort:** Organizacion de imports

### Linters
- **flake8:** Linting de codigo Python
- **pylint:** Analisis estatico
- **mypy:** Type checking

### Pre-commit Hooks
Configuracion de hooks para validar estilo antes de commit.

## Configuraciones

### pyproject.toml
```toml
[tool.black]
line-length = 88
target-version = ['py310']

[tool.isort]
profile = "black"
line_length = 88
```

### .flake8
```ini
[flake8]
max-line-length = 88
extend-ignore = E203, W503
```

## Restricciones del Proyecto

Las guias de estilo deben considerar:
- Nomenclatura que refleje restricciones (ej: no usar nombres relacionados con Redis/SMTP)
- Documentar separacion de concerns para dual DB
- Convenciones para sesiones en MySQL

---

**Ultima actualizacion:** 2025-11-18
**Responsable:** Equipo Backend
