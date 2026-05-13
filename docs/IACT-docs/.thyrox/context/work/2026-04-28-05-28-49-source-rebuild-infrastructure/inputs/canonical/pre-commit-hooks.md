---
id: PRE-COMMIT-HOOKS-README
tipo: configuracion
categoria: qa
fecha: 2025-11-07
propietario: qa-lead
---

# Pre-commit Hooks - IACT Project

Configuracion de pre-commit hooks para asegurar calidad de codigo antes de commits.

## Instalacion

### 1. Instalar pre-commit

```bash
pip install pre-commit
```

### 2. Instalar hooks en el repositorio

```bash
pre-commit install
```

### 3. (Opcional) Instalar hooks para commit-msg

```bash
pre-commit install --hook-type commit-msg
```

## Uso

### Automatico (en cada commit)

Los hooks se ejecutan automaticamente al hacer `git commit`:

```bash
git add .
git commit -m "feat: nueva funcionalidad"
# Pre-commit ejecuta todos los hooks configurados
```

### Manual (en todos los archivos)

Para ejecutar hooks manualmente en todo el proyecto:

```bash
pre-commit run --all-files
```

### Manual (en archivos staged)

Para ejecutar hooks solo en archivos en staging:

```bash
pre-commit run
```

### Manual (hook especifico)

Para ejecutar un hook especifico:

```bash
pre-commit run black --all-files
pre-commit run flake8 --all-files
pre-commit run markdownlint --all-files
```

## Hooks Configurados

### General File Checks

- **no-commit-to-branch**: Previene commits directos a main/master
- **trailing-whitespace**: Elimina espacios en blanco al final de lineas
- **end-of-file-fixer**: Asegura newline al final de archivos
- **check-yaml**: Valida sintaxis YAML
- **check-json**: Valida sintaxis JSON
- **check-toml**: Valida sintaxis TOML
- **check-added-large-files**: Previene commits de archivos >1MB
- **check-merge-conflict**: Detecta marcadores de merge conflict
- **mixed-line-ending**: Normaliza line endings a LF

### Python Code Quality

- **black**: Formatea codigo Python (line-length=100)
- **isort**: Ordena imports Python (profile=black)
- **flake8**: Linting Python (max-line-length=100)
- **bandit**: Analisis de seguridad Python

### Python-specific Checks

- **check-ast**: Valida sintaxis Python (AST)
- **check-builtin-literals**: Detecta uso incorrecto de builtins
- **check-docstring-first**: Valida orden de docstrings
- **debug-statements**: Detecta debugger statements (pdb, ipdb)
- **name-tests-test**: Valida nombres de archivos de tests

### Django-specific

- **django-upgrade**: Actualiza codigo Django a version 4.2

### Documentation

- **markdownlint**: Linting de archivos Markdown

### Security

- **detect-secrets**: Detecta secrets/passwords en codigo

### Shell Scripts

- **shellcheck**: Linting de shell scripts

## Configuracion

### .pre-commit-config.yaml

Archivo principal de configuracion de pre-commit hooks.

### .markdownlint.json

Configuracion de markdownlint para documentacion:
- MD013 disabled: No limite de linea (flexibilidad para tablas)
- MD024 siblings_only: Permite headers duplicados en diferentes secciones
- MD033: Permite HTML inline en Markdown
- MD041: No require H1 al inicio (frontmatter YAML)

### .secrets.baseline

Baseline de detect-secrets para ignorar false positives conocidos.

### pyproject.toml

Configuracion de herramientas Python (black, isort, flake8, bandit).

## Bypass de Hooks (uso excepcional)

### Bypass todos los hooks

```bash
git commit --no-verify -m "feat: commit sin hooks"
```

[ADVERTENCIA] Solo usar en casos excepcionales:
- Commits de emergencia en produccion
- Work-in-progress en branches personales
- Documentacion incompleta que se completara despues

### Bypass hook especifico

Editar `.pre-commit-config.yaml` y agregar `exclude: ^path/to/file$` al hook.

## Actualizacion de Hooks

### Actualizar a ultimas versiones

```bash
pre-commit autoupdate
```

### Actualizar version especifica

Editar `.pre-commit-config.yaml` y cambiar `rev: vX.Y.Z` del hook deseado.

## Troubleshooting

### Hook falla con error de instalacion

```bash
# Limpiar cache y reinstalar
pre-commit clean
pre-commit install --install-hooks
```

### Hook falla en archivos especificos

```bash
# Ver output detallado
pre-commit run --all-files --verbose
```

### Ignorar archivos temporalmente

Editar `.pre-commit-config.yaml` y agregar `exclude: ^path/` al hook.

### Hooks lentos

```bash
# Ejecutar hooks en paralelo (por defecto)
# Deshabilitar hooks pesados en desarrollo local:
# Comentar hooks en .pre-commit-config.yaml
```

## CI/CD Integration

Los hooks tambien se ejecutan en CI/CD via GitHub Actions.

Ver `.github/workflows/pre-commit.yml` para configuracion de CI.

## Metricas de Calidad

### Objetivos

- [OK] 100% de commits pasan pre-commit hooks
- [OK] 0 secrets en repositorio
- [OK] Codigo formateado consistentemente (black + isort)
- [OK] 0 vulnerabilidades de seguridad (bandit)
- [OK] Documentacion sin errores de sintaxis (markdownlint)

### Monitoreo

```bash
# Ver estadisticas de hooks
pre-commit run --all-files --show-diff-on-failure
```

## Referencias

- [pre-commit.com](https://pre-commit.com)
- [Black](https://black.readthedocs.io/)
- [isort](https://pycqa.github.io/isort/)
- [flake8](https://flake8.pycqa.org/)
- [bandit](https://bandit.readthedocs.io/)
- [markdownlint](https://github.com/DavidAnson/markdownlint)
- [detect-secrets](https://github.com/Yelp/detect-secrets)

---

**Creado**: 2025-11-07
**Responsable**: QA Lead
**Relacionados**: pyproject.toml, .github/workflows/pre-commit.yml
