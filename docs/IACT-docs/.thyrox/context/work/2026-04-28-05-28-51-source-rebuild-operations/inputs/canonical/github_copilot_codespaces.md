---
id: RUNBOOK-CODESPACES
estado: draft
propietario: equipo-devops
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-DEVOPS-INDEX", "DOC-DEVOPS-CONTAINERS"]
date: 2025-11-13
---
# Runbook: Desarrollo con GitHub Codespaces y Copilot

## Propósito

Guía para configurar y usar GitHub Codespaces con GitHub Copilot para el desarrollo del proyecto IACT.

## Estado Actual

WARNING **Nota**: Esta funcionalidad está en planificación. El proyecto actualmente usa Vagrant (ver [ADR_2025_001](../../arquitectura/adr/ADR_2025_001-vagrant-mod-wsgi.md)).

Este runbook documenta el proceso futuro cuando se implemente DevContainers y Codespaces.

## Pre-requisitos

- Cuenta GitHub con acceso al repositorio
- GitHub Copilot habilitado (licencia individual o empresa)
- Navegador web moderno (Chrome, Firefox, Edge)
- Opcional: VS Code instalado localmente

## ¿Qué es GitHub Codespaces?

GitHub Codespaces es un entorno de desarrollo en la nube que:

- START Se configura automáticamente desde `.devcontainer/`
- ☁️ Corre en servidores de GitHub (o Azure)
- 💻 Accesible desde navegador o VS Code
- HERRAMIENTA Incluye todas las herramientas y dependencias

## ¿Qué es GitHub Copilot?

GitHub Copilot es un asistente de programación con IA que:

- AUTO Sugiere código mientras escribes
- NOTA Genera funciones completas desde comentarios
- BUSCAR Ayuda con tests, documentación, refactoring
- 🧠 Aprende del contexto de tu proyecto

## Crear un Codespace

### Desde GitHub Web

1. Ve al repositorio: `https://github.com/2-Coatl/IACT---project`
2. Click en botón verde **"Code"**
3. Selecciona tab **"Codespaces"**
4. Click en **"Create codespace on main"** (o la rama que prefieras)
5. Espera ~2 minutos mientras se aprovisiona

### Desde VS Code Local

1. Instala extensión: [GitHub Codespaces](https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces)
2. Presiona `Cmd+Shift+P` (macOS) o `Ctrl+Shift+P` (Windows/Linux)
3. Escribe: "Codespaces: Create New Codespace"
4. Selecciona repositorio: `2-Coatl/IACT---project`
5. Selecciona rama (típicamente `main` o `develop`)

### Desde CLI

```bash
# Instalar GitHub CLI
brew install gh  # macOS
# o descargar desde https://cli.github.com/

# Autenticar
gh auth login

# Crear codespace
gh codespace create --repo 2-Coatl/IACT---project

# Conectar a codespace
gh codespace code
```

## Configuración de Copilot

### Activar Copilot

1. En Codespace, abre Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
2. Busca: "GitHub Copilot: Sign In"
3. Sigue el flujo de autenticación

### Configurar Sugerencias

**Settings JSON:**
```json
{
  "github.copilot.enable": {
    "*": true,
    "python": true,
    "markdown": true,
    "yaml": true
  },
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.advanced": {
    "inlineSuggestCount": 3
  }
}
```

## Usar Copilot Efectivamente

### 1. Completado de Código

**Ejemplo:**

```python
# Escribes un comentario descriptivo:
# Función que calcula el Average Handling Time de una lista de llamadas

# Copilot sugiere:
def calculate_aht(calls: List[Dict]) -> float:
    """Calcula Average Handling Time."""
    if not calls:
        return 0.0
    total_duration = sum(call['duration'] for call in calls)
    return total_duration / len(calls)
```

### 2. Generar Tests

**Ejemplo:**

```python
# Dado este código:
def calculate_aht(calls: List[Dict]) -> float:
    if not calls:
        return 0.0
    total_duration = sum(call['duration'] for call in calls)
    return total_duration / len(calls)

# Escribes:
def test_calculate_aht_

# Copilot sugiere:
def test_calculate_aht_with_valid_calls():
    """Should calculate correct AHT."""
    calls = [
        {'duration': 100},
        {'duration': 200},
        {'duration': 300},
    ]
    assert calculate_aht(calls) == 200.0

def test_calculate_aht_with_empty_list():
    """Should return 0 for empty list."""
    assert calculate_aht([]) == 0.0
```

### 3. Documentación

**Ejemplo:**

```python
# Posiciona cursor sobre función y presiona Option+Cmd+I (macOS)
# Copilot genera docstring:

def process_ivr_data(raw_data: dict) -> ProcessedCall:
    """
    Procesa datos crudos del sistema IVR.

    Args:
        raw_data: Diccionario con datos crudos de la llamada desde IVR

    Returns:
        ProcessedCall: Objeto con datos transformados y validados

    Raises:
        ValidationError: Si datos no cumplen schema requerido
        TransformationError: Si falla transformación de datos

    Example:
        >>> raw = {'call_id': '123', 'duration': 120}
        >>> process_ivr_data(raw)
        ProcessedCall(id='123', duration=120)
    """
    pass
```

### 4. Chat con Copilot

**Abrir Chat:**
- Click en ícono de Copilot en sidebar
- O presiona `Cmd+Shift+I` / `Ctrl+Shift+I`

**Preguntas útiles:**

```
# Explicar código
"Explica qué hace esta función"

# Optimizar
"¿Cómo puedo optimizar esta query de Django?"

# Debugging
"¿Por qué este test está fallando?"

# Refactoring
"Refactoriza esta función para usar Repository Pattern"

# Generar tests
"Genera tests para esta clase"
```

## Flujo de Trabajo Típico

### 1. Crear Feature

```bash
# En terminal de Codespace
git checkout -b feature/nueva-funcionalidad-$(date +%H-%M-%S)
```

### 2. Escribir Código con Copilot

```python
# Escribe comentarios descriptivos
# Copilot sugiere implementación
# Acepta con Tab o rechaza con Esc

# Ejemplo:
# Clase que representa un agente del call center
class Agent(models.Model):  # Copilot completa automáticamente
    agent_id = models.IntegerField(unique=True)
    name = models.CharField(max_length=100)
    # Copilot sugiere más campos relevantes...
```

### 3. Generar Tests

```python
# Escribe: def test_
# Copilot sugiere tests basados en código existente
```

### 4. Ejecutar Tests

```bash
pytest
```

### 5. Commit y Push

```bash
git add .
git commit -m "feat(agents): agregar modelo Agent con validaciones"
git push -u origin feature/nueva-funcionalidad-XX-XX-XX
```

### 6. Crear PR desde Codespace

```bash
# Usando gh CLI
gh pr create --title "Agregar modelo Agent" --body "Implementa modelo de agente..."
```

## Configuración del Codespace

### Personalizar `.devcontainer/devcontainer.json`

```json
{
  "name": "IACT Development",
  "image": "mcr.microsoft.com/devcontainers/python:3.11",

  "features": {
    "ghcr.io/devcontainers/features/python:1": {
      "version": "3.11"
    },
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },

  "customizations": {
    "vscode": {
      "extensions": [
        "GitHub.copilot",
        "GitHub.copilot-chat",
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-python.black-formatter"
      ],
      "settings": {
        "github.copilot.enable": {
          "*": true
        }
      }
    }
  },

  "postCreateCommand": "bash .devcontainer/post-create.sh",

  "forwardPorts": [8000, 15432, 13306]
}
```

## Límites y Cuotas

### Free Tier

- **Horas gratuitas/mes**: 60 horas (2 cores) o 30 horas (4 cores)
- **Storage**: 15 GB
- **Codespaces simultáneos**: 2

### Pro Tier

- **Horas gratuitas/mes**: 90 horas (2 cores) o 45 horas (4 cores)
- **Storage**: 20 GB
- **Codespaces simultáneos**: 4

### Team/Enterprise

- Configurado por organización
- Típicamente más horas y recursos

**Ver uso:**
```
https://github.com/settings/billing
```

## Mejores Prácticas

### 1. Detener Codespaces Cuando No Uses

```bash
# Desde CLI
gh codespace stop

# O desde web: Code > Codespaces > ⋮ > Stop codespace
```

### 2. Configurar Auto-Stop

En settings del Codespace:
- Default: 30 minutos de inactividad
- Ajustable: 5 min - 4 horas

### 3. Usar Dotfiles Personales

Crear repositorio `github.com/<tu-usuario>/dotfiles`:

```
dotfiles/
├── .bashrc
├── .gitconfig
└── install.sh
```

GitHub Codespaces lo clona automáticamente.

### 4. Secretos en Codespaces

```
GitHub Settings > Codespaces > Secrets
```

Agregar:
- `DB_PASSWORD`
- `SECRET_KEY`
- API keys

Accesibles en codespace via env vars.

## Troubleshooting

### Copilot No Sugiere Nada

**Verificar:**
1. Copilot está activado (ícono en status bar)
2. Licencia válida: `https://github.com/settings/copilot`
3. Archivo es de tipo soportado (`.py`, `.js`, etc.)

**Reiniciar:**
```
Cmd+Shift+P > "Developer: Reload Window"
```

### Codespace Lento

**Aumentar recursos:**
1. Detener codespace
2. Crear nuevo con más cores (4-core en vez de 2-core)
3. Migrar código si es necesario

**Optimizar:**
- Cerrar archivos/tabs innecesarios
- Desactivar extensiones no usadas
- Limpiar node_modules, __pycache__

### Error de Conexión a DB

**Verificar:**
```bash
# Desde terminal de Codespace
./scripts/verificar_servicios.sh
```

**Logs de contenedores:**
```bash
docker-compose logs postgres
docker-compose logs mariadb
```

## Shortcuts Útiles

| Acción | macOS | Windows/Linux |
|--------|-------|---------------|
| Aceptar sugerencia Copilot | Tab | Tab |
| Siguiente sugerencia | Option+] | Alt+] |
| Sugerencia anterior | Option+[ | Alt+[ |
| Abrir Copilot Chat | Cmd+Shift+I | Ctrl+Shift+I |
| Command Palette | Cmd+Shift+P | Ctrl+Shift+P |
| Terminal | Ctrl+` | Ctrl+` |

## Referencias

- [GitHub Codespaces Docs](https://docs.github.com/en/codespaces)
- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [DevContainers](contenedores_devcontainer.md)
- [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)

## Changelog

- 2025-11-02: Creación inicial (draft - pendiente implementación)
