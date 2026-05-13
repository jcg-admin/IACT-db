---
title: LLD - Integración DevContainer Lifecycle
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: design
subfase: lld_devcontainer
proyecto: IACT---project
parent_doc: HLD_SISTEMA_AUTOMATIZACION.md
status: complete
version: 1.0
---

# Low-Level Design: Integración DevContainer Lifecycle

**Issue**: IACT-AUTO-001
**Fase**: FASE 3 - DESIGN (Low-Level Design - Módulo 3)
**Fecha**: 2025-11-13
**Parent**: HLD_SISTEMA_AUTOMATIZACION.md v2.0, LLD_00_OVERVIEW.md

---

## 1. Modificaciones infrastructure/devcontainer/scripts/post_create.sh

**Ubicacion**: `/home/user/IACT---project/infrastructure/devcontainer/scripts/post_create.sh`
**Proposito**: Agregar validación constitución y auto-instalación hooks tras crear DevContainer

**Modificaciones a Agregar** (al final del archivo existente):

```bash
# ======================================================================
# SISTEMA DE AUTOMATIZACION - VALIDACIONES Y SETUP
# ======================================================================

echo ""
echo "========================================"
echo "Sistema de Automatizacion: Setup"
echo "========================================"
echo ""

# Detectar workspace name
WORKSPACE_NAME="${localWorkspaceFolderBasename:-IACT---project}"
WORKSPACE_PATH="/workspaces/$WORKSPACE_NAME"

# ─────────────────────────────────────────────────────────────────────
# 1. VALIDAR CONSTITUCION ENTORNO
# ─────────────────────────────────────────────────────────────────────
echo "1. Validando entorno contra constitucion..."

if [ -f "$WORKSPACE_PATH/scripts/constitucion.sh" ]; then
    # Ejecutar validacion constitucion para devcontainer-init
    if "$WORKSPACE_PATH/scripts/constitucion.sh" --mode=devcontainer-init; then
        echo "   Constitucion: PASSED"
    else
        echo "   ADVERTENCIA: Constitucion reporto problemas en entorno"
        echo "   DevContainer funcional pero puede tener degradacion"
        echo "   Ver logs: $WORKSPACE_PATH/.automation-logs/constitucion/devcontainer-init-*.log"
        echo ""
        echo "   Problemas comunes:"
        echo "   - CPython version != 3.12.6"
        echo "   - PostgreSQL no accesible (port 5432)"
        echo "   - MariaDB no accesible (port 3306)"
        echo ""
    fi
else
    echo "   ADVERTENCIA: scripts/constitucion.sh no encontrado"
    echo "   Sistema constitucion no disponible"
    echo "   Esto es normal si aun no se ha desplegado el sistema"
fi

echo ""

# ─────────────────────────────────────────────────────────────────────
# 2. INSTALAR GIT HOOKS
# ─────────────────────────────────────────────────────────────────────
echo "2. Instalando Git hooks..."

if [ -f "$WORKSPACE_PATH/.git/hooks/pre-commit" ]; then
    echo "   Git hooks: Ya instalados (skip)"
else
    if [ -f "$WORKSPACE_PATH/scripts/install_hooks.sh" ]; then
        cd "$WORKSPACE_PATH"
        ./scripts/install_hooks.sh

        if [ $? -eq 0 ]; then
            echo "   Git hooks: INSTALADOS"
        else
            echo "   ERROR: Fallo instalacion Git hooks"
            echo "   Ejecuta manualmente: ./scripts/install_hooks.sh"
        fi
    else
        echo "   ADVERTENCIA: scripts/install_hooks.sh no encontrado"
        echo "   Git hooks no disponibles"
    fi
fi

echo ""

# ─────────────────────────────────────────────────────────────────────
# 3. VERIFICAR DEPENDENCIAS SISTEMA AUTOMATIZACION
# ─────────────────────────────────────────────────────────────────────
echo "3. Verificando dependencias sistema automatizacion..."

# Verificar yq (YAML parser)
if command -v yq &> /dev/null; then
    echo "   yq: INSTALADO ($(yq --version))"
else
    echo "   ADVERTENCIA: yq no instalado"
    echo "   Requerido por: scripts/constitucion.sh, scripts/ci-local.sh"
    echo "   Instalar: sudo apt-get install yq"
fi

# Verificar jq (JSON parser)
if command -v jq &> /dev/null; then
    echo "   jq: INSTALADO ($(jq --version))"
else
    echo "   ADVERTENCIA: jq no instalado"
    echo "   Requerido por: scripts/constitucion.sh"
    echo "   Instalar: sudo apt-get install jq"
fi

# Verificar Python 3.9+
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "   Python: $PYTHON_VERSION"

if [ "$(echo "$PYTHON_VERSION" | cut -d. -f1,2)" != "3.12" ]; then
    echo "   ADVERTENCIA: Python version no es 3.12.x"
    echo "   Recomendado: 3.12.6 (CPython custom)"
fi

echo ""

# ─────────────────────────────────────────────────────────────────────
# FINALIZACION SETUP
# ─────────────────────────────────────────────────────────────────────
echo "========================================"
echo "DevContainer Setup: COMPLETO"
echo "========================================"
echo ""
echo "Proximos pasos:"
echo ""
echo "  API Backend:"
echo "    cd api/callcentersite"
echo "    python manage.py runserver"
echo ""
echo "  UI Frontend:"
echo "    cd ui"
echo "    npm start"
echo ""
echo "  CI Local (validacion completa):"
echo "    ./scripts/ci-local.sh"
echo "    # O: npm run ci:local (si configurado en package.json)"
echo ""
echo "  Documentacion:"
echo "    docs/devops/README.md"
echo "    docs/devops/automatizacion/CONSTITUCION_GUIDE.md"
echo ""
echo "  Sistema Constitucion:"
echo "    ./scripts/constitucion.sh --mode=validate-all"
echo ""
echo "========================================"
echo ""
```

**Ubicacion exacta**: Agregar ANTES del `echo "Devcontainer setup complete!"` existente (si existe)

---

## 2. Modificaciones infrastructure/devcontainer/scripts/post_start.sh

**Ubicacion**: `/home/user/IACT---project/infrastructure/devcontainer/scripts/post_start.sh`
**Proposito**: Quick checks y recordatorios en cada start del DevContainer

**Modificaciones a Agregar** (al final del archivo existente):

```bash
# ======================================================================
# SISTEMA DE AUTOMATIZACION - QUICK CHECKS
# ======================================================================

# Workspace path
WORKSPACE_NAME="${localWorkspaceFolderBasename:-IACT---project}"
WORKSPACE_PATH="/workspaces/$WORKSPACE_NAME"

# Quick health check servicios
echo ""
echo "Quick Health Check:"
echo "  PostgreSQL (5432): $(nc -z localhost 5432 && echo OK || echo FAIL)"
echo "  MariaDB (3306):    $(nc -z localhost 3306 && echo OK || echo FAIL)"
echo ""

# Recordatorio sistema activo
if [ -f "$WORKSPACE_PATH/scripts/constitucion.sh" ]; then
    echo "Sistema Automatizacion: ACTIVO"
    echo "  Git Hooks instalados"
    echo "  Constitucion habilitada"
    echo "  CI Local disponible: ./scripts/ci-local.sh"
    echo ""
fi
```

---

## 3. Flujo Completo Lifecycle DevContainer

```
Usuario abre DevContainer en VSCode
│
▼
┌─────────────────────────────────────────────────────────────────┐
│ 1. initializeCommand (HOST)                                     │
│    infrastructure/devcontainer/scripts/init_host.sh              │
│    - Validaciones pre-build                                     │
│    - Check Docker running                                       │
│    - Check disk space                                           │
│    - Ninguna modificacion necesaria (ya existe)                 │
└─────────────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────────────┐
│ 2. onCreateCommand (CONTAINER - primera vez)                    │
│    infrastructure/devcontainer/scripts/on_create.sh              │
│    - Setup Python CPython custom (3.12.6)                       │
│    - Configurar Git                                             │
│    - Crear directorios                                          │
│    - Ninguna modificacion necesaria (ya existe)                 │
└─────────────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────────────┐
│ 3. updateContentCommand (CONTAINER - primera vez)               │
│    infrastructure/devcontainer/scripts/update_content.sh         │
│    - pip install -r requirements.txt                            │
│    - npm install (en ui/)                                       │
│    - Ninguna modificacion necesaria (ya existe)                 │
└─────────────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────────────┐
│ 4. postCreateCommand (CONTAINER - primera vez)                  │
│    infrastructure/devcontainer/scripts/post_create.sh            │
│    - Database migrations                                        │
│    - Seed data (si dev)                                         │
│    ▼ MODIFICACION: Agregar al final                             │
│    ┌───────────────────────────────────────────────────────────┐│
│    │ VALIDACION CONSTITUCION ENTORNO                           ││
│    │ - Ejecutar scripts/constitucion.sh --mode=devcontainer-init││
│    │ - Verificar PostgreSQL (5432) accesible                   ││
│    │ - Verificar MariaDB (3306) accesible                      ││
│    │ - Verificar CPython 3.12.6                                ││
│    │ - Log warnings si problemas                               ││
│    └───────────────────────────────────────────────────────────┘│
│    ┌───────────────────────────────────────────────────────────┐│
│    │ INSTALAR GIT HOOKS                                        ││
│    │ - Verificar si .git/hooks/pre-commit existe               ││
│    │ - Si NO: ejecutar ./scripts/install_hooks.sh              ││
│    │ - Si SI: skip (ya instalados)                             ││
│    └───────────────────────────────────────────────────────────┘│
│    ┌───────────────────────────────────────────────────────────┐│
│    │ VERIFICAR DEPENDENCIAS                                    ││
│    │ - yq (YAML parser): requerido por constitucion.sh         ││
│    │ - jq (JSON parser): requerido por constitucion.sh         ││
│    │ - Python 3.12.x: advertir si version diferente           ││
│    └───────────────────────────────────────────────────────────┘│
│    ┌───────────────────────────────────────────────────────────┐│
│    │ MENSAJE FINALIZACION                                      ││
│    │ - "DevContainer Setup: COMPLETO"                          ││
│    │ - Proximos pasos (como correr API, UI, CI local)         ││
│    │ - Links a documentacion                                   ││
│    └───────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────────────┐
│ 5. postStartCommand (CONTAINER - cada start)                    │
│    infrastructure/devcontainer/scripts/post_start.sh             │
│    - Quick verification services (PostgreSQL, MariaDB)          │
│    ▼ MODIFICACION: Agregar al final                             │
│    ┌───────────────────────────────────────────────────────────┐│
│    │ QUICK HEALTH CHECK                                        ││
│    │ - nc -z localhost 5432 (PostgreSQL)                       ││
│    │ - nc -z localhost 3306 (MariaDB)                          ││
│    └───────────────────────────────────────────────────────────┘│
│    ┌───────────────────────────────────────────────────────────┐│
│    │ RECORDATORIO                                              ││
│    │ - "Sistema Automatizacion: ACTIVO"                        ││
│    │ - "Git Hooks instalados"                                  ││
│    │ - "Constitucion habilitada"                               ││
│    │ - "CI Local disponible: ./scripts/ci-local.sh"            ││
│    └───────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
│
▼
DevContainer READY - Usuario puede trabajar
```

---

## 4. Validaciones Ejecutadas en postCreateCommand

### 4.1 Validacion Constitucion (R6_devcontainer_compatibility)

**Script invocado**: `scripts/constitucion.sh --mode=devcontainer-init`

**Regla validada**: R6_devcontainer_compatibility (de `.constitucion.yaml`)

**Checks ejecutados** (via `scripts/validate_devcontainer_env.sh`):
1. Python version == 3.12.6
2. PostgreSQL accesible en port 5432
3. MariaDB accesible en port 3306
4. Git hooks instalados (.git/hooks/pre-commit existe)

**Resultado**:
- Si PASA: mensaje "Constitucion: PASSED"
- Si FALLA: WARNING (no bloquea DevContainer), mostrar problemas detectados

**Severity**: `warning` (NO bloquea startup DevContainer)

### 4.2 Instalacion Git Hooks

**Condicion**: Si `.git/hooks/pre-commit` NO existe

**Accion**: Ejecutar `./scripts/install_hooks.sh`

**Resultado**:
- Hooks instalados: pre-commit, commit-msg, pre-push, pre-rebase
- Desarrollador listo para trabajar con validaciones automaticas

### 4.3 Verificacion Dependencias

**Dependencias requeridas**:
- `yq`: YAML parser (usado por constitucion.sh, ci-local.sh)
- `jq`: JSON parser (usado por constitucion.sh)
- Python 3.12.x: Version especifica IACT

**Resultado**:
- Instalados: OK
- Faltantes: WARNING con instrucciones instalacion

---

## 5. Integracion con devcontainer.json

**Archivo**: `/home/user/IACT---project/.devcontainer/devcontainer.json`

**Ninguna modificacion necesaria** en `devcontainer.json` porque ya tiene:

```json
{
  "postCreateCommand": "bash infrastructure/devcontainer/scripts/post_create.sh",
  "postStartCommand": "bash infrastructure/devcontainer/scripts/post_start.sh"
}
```

Solo modificamos el CONTENIDO de esos scripts (post_create.sh y post_start.sh), NO la configuracion del lifecycle.

---

## 6. Procedimiento Instalacion/Modificacion

### 6.1 Paso a Paso

**PASO 1**: Editar `infrastructure/devcontainer/scripts/post_create.sh`
```bash
# Abrir archivo
vim infrastructure/devcontainer/scripts/post_create.sh

# Scroll al final
# Agregar seccion "SISTEMA DE AUTOMATIZACION - VALIDACIONES Y SETUP"
# (copiar codigo de Seccion 1 de este LLD)
```

**PASO 2**: Editar `infrastructure/devcontainer/scripts/post_start.sh`
```bash
# Abrir archivo
vim infrastructure/devcontainer/scripts/post_start.sh

# Scroll al final
# Agregar seccion "SISTEMA DE AUTOMATIZACION - QUICK CHECKS"
# (copiar codigo de Seccion 2 de este LLD)
```

**PASO 3**: Rebuild DevContainer para aplicar cambios
```bash
# En VSCode:
# Ctrl+Shift+P → "Dev Containers: Rebuild Container"
```

**PASO 4**: Verificar que modificaciones funcionan
```bash
# Revisar output postCreateCommand:
# Debe mostrar:
#   1. Validando entorno contra constitucion...
#   2. Instalando Git hooks...
#   3. Verificando dependencias...
#   DevContainer Setup: COMPLETO

# Revisar output postStartCommand:
# Debe mostrar:
#   Quick Health Check:
#   PostgreSQL (5432): OK
#   MariaDB (3306): OK
#   Sistema Automatizacion: ACTIVO
```

### 6.2 Testing Modificaciones

**Test 1**: DevContainer limpio (primera vez)
- Accion: Rebuild container from scratch
- Expected: Hooks instalados automaticamente, constitucion validada

**Test 2**: DevContainer existente (restart)
- Accion: Restart container (no rebuild)
- Expected: Quick checks ejecutados, recordatorio mostrado

**Test 3**: Hooks ya instalados
- Accion: Rebuild container con hooks ya instalados
- Expected: Skip instalacion hooks, mensaje "Ya instalados (skip)"

---

## 7. Troubleshooting

### Problema 1: Validacion constitucion falla (PostgreSQL no accesible)

**Sintoma**:
```
PostgreSQL no conectable
MariaDB no conectable
```

**Causa**: Servicios Docker Compose no iniciados

**Solucion**:
```bash
# En otro terminal (host):
docker-compose up -d postgres mariadb

# Dentro de DevContainer:
nc -z localhost 5432  # Deberia retornar 0
nc -z localhost 3306  # Deberia retornar 0
```

### Problema 2: Git hooks no se instalan

**Sintoma**:
```
ERROR: Fallo instalacion Git hooks
```

**Causa**: scripts/install_hooks.sh no ejecutable

**Solucion**:
```bash
chmod +x scripts/install_hooks.sh
./scripts/install_hooks.sh
```

### Problema 3: yq/jq no instalados

**Sintoma**:
```
ADVERTENCIA: yq no instalado
```

**Solucion**:
```bash
# Dentro de DevContainer:
sudo apt-get update
sudo apt-get install -y yq jq

# Verificar:
yq --version
jq --version
```

---

## 8. Proximos Pasos

**Tras deployment de esta integracion**:
1. Todos los desarrolladores tendran hooks instalados automaticamente
2. Validaciones constitucion ejecutadas al crear DevContainer
3. Ambiente consistente (todos usan mismo setup)
4. Menos friccion onboarding (nuevo dev: abrir DevContainer → listo)

**Testing** (FASE 4):
- Test instalacion hooks en DevContainer limpio
- Test validacion constitucion detecta problemas
- Test quick checks en post-start

---

**Status**: LLD DEVCONTAINER COMPLETO
**Fecha**: 2025-11-13
**Autor**: SDLC Agent / DevOps Team
**Complejidad**: Baja (solo modificaciones a 2 scripts existentes)
