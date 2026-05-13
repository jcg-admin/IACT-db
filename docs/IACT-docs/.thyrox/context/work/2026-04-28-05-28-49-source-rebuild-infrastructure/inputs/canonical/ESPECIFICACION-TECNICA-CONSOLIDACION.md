# Especificación Técnica: Consolidación diseño/arquitectura/

**Documento**: TASK-REORG-INFRA-006
**Tipo**: Especificación Técnica
**Versión**: 1.0
**Fecha**: 2025-11-18
**Técnica de Prompting**: Decomposed Prompting + Self-Consistency

---

## 1. Descripción General

Esta especificación técnica detalla el proceso completo para consolidar archivos de arquitectura dispersos en una estructura centralizada bajo `diseno/arquitectura/`.

### Alcance
- **Inclusión**: Todos los archivos de arquitectura (.md, .canvas) en el repo
- **Exclusión**: Archivos de contenido que no sean arquitectura
- **Transformación**: Reorganización de directorios y actualización de referencias

---

## 2. Estructura de Directorios (Antes)

```
Dispersión Actual (23 archivos en 11 ubicaciones):
├── docs/
│   ├── agents/ARCHITECTURE.md
│   ├── ai/
│   │   ├── agent/arquitectura/ (9 archivos HLD/ADR)
│   │   └── arquitectura/README.md
│   ├── backend/diseno/permisos/arquitectura_permisos_granular.md
│   ├── devops/automatizacion/planificacion/AUTOMATION_ARCHITECTURE.md
│   ├── frontend/arquitectura/ (5 archivos)
│   ├── gobernanza/diseno/arquitectura/STORAGE_ARCHITECTURE.md
│   └── infraestructura/
│       ├── ambientes_virtualizados.md
│       ├── storage_architecture.md
│       └── cpython_precompilado/arquitectura.md
└── scripts/coding/ai/agents/
    ├── ARCHITECTURE.md
    └── ARCHITECTURE_SDLC_AGENTS.md
```

---

## 3. Estructura de Directorios (Después)

```
Consolidación Centralizada (33 archivos en diseno/arquitectura/):
diseno/
└── arquitectura/
    ├── README.md (ÍNDICE MAESTRO + FRONTMATTER)
    ├── CONSOLIDATION_SUMMARY.md (Resumen de cambios)
    │
    ├── infraestructura/
    │   ├── README.md
    │   ├── ambientes_virtualizados.md
    │   ├── storage_architecture.md
    │   ├── cpython_precompilado_arquitectura.md
    │   └── devcontainer_host_architecture.canvas [NUEVO]
    │
    ├── gobernanza/
    │   ├── README.md
    │   └── storage_architecture_gobernanza.md
    │
    ├── agentes/
    │   ├── README.md
    │   ├── ARCHITECTURE_AGENTS_OVERVIEW.md
    │   ├── ARCHITECTURE_SDLC.md
    │   ├── ARCHITECTURE_SDLC_AGENTS_DETAILED.md
    │   ├── AGENTS_DEVOPS_AUTOMATION_ARCHITECTURE.md
    │   │
    │   ├── hld/
    │   │   ├── README.md
    │   │   ├── shell_script_remediation_agent.md
    │   │   ├── adr_management_agent.md
    │   │   ├── documentation_analysis_agent.md
    │   │   └── plan_validation_agent.md
    │   │
    │   └── adrs/
    │       ├── README.md
    │       ├── plan_validation_agent.md
    │       ├── shell_script_remediation_agent.md
    │       ├── shell_script_analysis_agent.md
    │       └── documentation_analysis_agent.md
    │
    ├── backend/
    │   ├── README.md
    │   └── permisos_granular_arquitectura.md
    │
    ├── frontend/
    │   ├── README.md
    │   ├── microfrontends_canvas.md
    │   ├── shared_webpack_configs.md
    │   ├── estrategia_integracion_backend.md
    │   ├── analisis_api_frontend.md
    │   └── ejemplos_ui_design.md
    │
    └── devops/
        ├── README.md
        └── cicd_pipeline_architecture.canvas [NUEVO]
```

---

## 4. Matriz de Transformación (Movimientos)

### 4.1 Infraestructura

| Origen | Destino | Tipo | Git Command |
|--------|---------|------|------------|
| `docs/infraestructura/ambientes_virtualizados.md` | `diseno/arquitectura/infraestructura/ambientes_virtualizados.md` | MOVER | `git mv` |
| `docs/infraestructura/storage_architecture.md` | `diseno/arquitectura/infraestructura/storage_architecture.md` | MOVER | `git mv` |
| `docs/infraestructura/cpython_precompilado/arquitectura.md` | `diseno/arquitectura/infraestructura/cpython_precompilado_arquitectura.md` | MOVER | `git mv` |
| N/A | `diseno/arquitectura/infraestructura/devcontainer_host_architecture.canvas` | CREAR | `Write tool` |

### 4.2 Gobernanza

| Origen | Destino | Tipo | Git Command |
|--------|---------|------|------------|
| `docs/gobernanza/diseno/arquitectura/STORAGE_ARCHITECTURE.md` | `diseno/arquitectura/gobernanza/storage_architecture_gobernanza.md` | MOVER | `git mv` |

### 4.3 Agentes (HLD)

| Origen | Destino | Tipo | Git Command |
|--------|---------|------|------------|
| `docs/ai/agent/arquitectura/hld_shell_script_remediation_agent.md` | `diseno/arquitectura/agentes/hld/shell_script_remediation_agent.md` | MOVER | `git mv` |
| `docs/ai/agent/arquitectura/hld_adr_management_agent.md` | `diseno/arquitectura/agentes/hld/adr_management_agent.md` | MOVER | `git mv` |
| `docs/ai/agent/arquitectura/hld_documentation_analysis_agent.md` | `diseno/arquitectura/agentes/hld/documentation_analysis_agent.md` | MOVER | `git mv` |
| `docs/ai/agent/arquitectura/hld_plan_validation_agent.md` | `diseno/arquitectura/agentes/hld/plan_validation_agent.md` | MOVER | `git mv` |
| `docs/ai/agent/arquitectura/hld_shell_script_analysis_agent.md` | `diseno/arquitectura/agentes/hld/shell_script_analysis_agent.md` | MOVER | `git mv` |

### 4.4 Agentes (ADR)

| Origen | Destino | Tipo | Git Command |
|--------|---------|------|------------|
| `docs/ai/agent/arquitectura/adrs_plan_validation_agent.md` | `diseno/arquitectura/agentes/adrs/plan_validation_agent.md` | MOVER | `git mv` |
| `docs/ai/agent/arquitectura/adrs_shell_script_remediation_agent.md` | `diseno/arquitectura/agentes/adrs/shell_script_remediation_agent.md` | MOVER | `git mv` |
| `docs/ai/agent/arquitectura/adrs_shell_script_analysis_agent.md` | `diseno/arquitectura/agentes/adrs/shell_script_analysis_agent.md` | MOVER | `git mv` |
| `docs/ai/agent/arquitectura/adrs_documentation_analysis_agent.md` | `diseno/arquitectura/agentes/adrs/documentation_analysis_agent.md` | MOVER | `git mv` |

### 4.5 Agentes (Consolidados)

| Origen | Destino | Tipo | Acción |
|--------|---------|------|--------|
| `docs/agents/ARCHITECTURE.md` + `scripts/coding/ai/agents/ARCHITECTURE.md` | `diseno/arquitectura/agentes/ARCHITECTURE_AGENTS_OVERVIEW.md` | CONSOLIDAR | Merger + Rename |
| `docs/ai/arquitectura/README.md` | `diseno/arquitectura/agentes/README.md` | MOVER | `git mv` |
| `scripts/coding/ai/agents/ARCHITECTURE_SDLC_AGENTS.md` | `diseno/arquitectura/agentes/ARCHITECTURE_SDLC_AGENTS_DETAILED.md` | MOVER | `git mv` |
| `docs/devops/automatizacion/planificacion/AUTOMATION_ARCHITECTURE.md` | `diseno/arquitectura/agentes/AGENTS_DEVOPS_AUTOMATION_ARCHITECTURE.md` | MOVER | `git mv` |

### 4.6 Backend

| Origen | Destino | Tipo | Git Command |
|--------|---------|------|------------|
| `docs/backend/diseno/permisos/arquitectura_permisos_granular.md` | `diseno/arquitectura/backend/permisos_granular_arquitectura.md` | MOVER | `git mv` |

### 4.7 Frontend

| Origen | Destino | Tipo | Git Command |
|--------|---------|------|------------|
| `docs/frontend/arquitectura/microfrontends_canvas.md` | `diseno/arquitectura/frontend/microfrontends_canvas.md` | MOVER | `git mv` |
| `docs/frontend/arquitectura/shared_webpack_configs.md` | `diseno/arquitectura/frontend/shared_webpack_configs.md` | MOVER | `git mv` |
| `docs/frontend/arquitectura/estrategia_integracion_backend.md` | `diseno/arquitectura/frontend/estrategia_integracion_backend.md` | MOVER | `git mv` |
| `docs/frontend/arquitectura/analisis_api_frontend.md` | `diseno/arquitectura/frontend/analisis_api_frontend.md` | MOVER | `git mv` |
| `docs/frontend/arquitectura/ejemplos_ui_design.md` | `diseno/arquitectura/frontend/ejemplos_ui_design.md` | MOVER | `git mv` |

---

## 5. Estrategia de Referencias

### 5.1 Patrón de Referencia Antigua a Evitar

```markdown
[Documentación de Agentes](../../docs/ai/agent/arquitectura/hld_shell_script_remediation_agent.md)
[Almacenamiento](../../docs/infraestructura/storage_architecture.md)
[Permisos Backend](../../docs/backend/diseno/permisos/arquitectura_permisos_granular.md)
```

### 5.2 Patrón de Referencia Nueva

```markdown
[Documentación de Agentes](./agentes/hld/shell_script_remediation_agent.md)
[Almacenamiento](./infraestructura/storage_architecture.md)
[Permisos Backend](./backend/permisos_granular_arquitectura.md)
```

### 5.3 Ubicaciones Donde Buscar Referencias Antiguas

```bash
# Búsqueda global de referencias antiguas
grep -r "docs/ai/agent/arquitectura" /home/user/IACT/docs --include="*.md"
grep -r "docs/infraestructura" /home/user/IACT/docs --include="*.md" | grep -v "diseno/"
grep -r "docs/backend/diseno/permisos" /home/user/IACT/docs --include="*.md"
grep -r "docs/gobernanza/diseno/arquitectura" /home/user/IACT/docs --include="*.md"
grep -r "docs/frontend/arquitectura" /home/user/IACT/docs --include="*.md" | grep -v "diseno/"
```

---

## 6. Creación de Nuevos Archivos

### 6.1 Archivos README.md Necesarios

```
diseno/arquitectura/README.md (MAESTRO)
diseno/arquitectura/infraestructura/README.md
diseno/arquitectura/gobernanza/README.md
diseno/arquitectura/agentes/README.md
diseno/arquitectura/agentes/hld/README.md
diseno/arquitectura/agentes/adrs/README.md
diseno/arquitectura/backend/README.md
diseno/arquitectura/frontend/README.md
diseno/arquitectura/devops/README.md
```

Cada README debe incluir:
- Descripción de contenido de la sección
- Índice de archivos
- Propósito de cada archivo
- Links a documentación relacionada
- Última fecha de actualización

### 6.2 Canvas Nuevos Requeridos

#### DevContainer Host Architecture Canvas
**Ubicación**: `diseno/arquitectura/infraestructura/devcontainer_host_architecture.canvas`

**Contenido mínimo**:
- Componentes del host
- Contenedores y volúmenes
- Configuración de networking
- Monitoreo e integración

#### CI/CD Pipeline Architecture Canvas
**Ubicación**: `diseno/arquitectura/devops/cicd_pipeline_architecture.canvas`

**Contenido mínimo**:
- Etapas del pipeline
- Agentes y workers
- Validaciones automáticas
- Integración con repositorio
- Despliegue y rollback

### 6.3 Archivo de Resumen de Consolidación

**Ubicación**: `diseno/arquitectura/CONSOLIDATION_SUMMARY.md`

**Contenido**:
- Fecha de consolidación
- Número de archivos movidos: 23
- Número de archivos nuevos creados: 2 (Canvas) + 9 (README)
- Cambios principales
- Guía de migración para usuarios
- FAQ sobre nueva ubicación de archivos

---

## 7. Validación y Pruebas

### 7.1 Checklist de Validación Técnica

```
PRE-CONSOLIDACIÓN
[ ] Backup de git stash creado
[ ] Rama separada confirmada (claude/reorganize-infra-docs-*)
[ ] Permisos de directorio verificados

DURANTE CONSOLIDACIÓN
[ ] Directorio diseno/arquitectura/ creado
[ ] Subdirectorios creados
[ ] Archivos movidos con git mv
[ ] Nuevo contenido creado (Canvas, README)
[ ] Consolidación de duplicados verificada

POST-CONSOLIDACIÓN
[ ] Todos los archivos .md presentes
[ ] Permisos de lectura correctos
[ ] No hay archivos huérfanos
[ ] Estructura coincide con especificación
```

### 7.2 Pruebas de Integridad

```bash
# Test 1: Contar archivos
find diseno/arquitectura -type f -name "*.md" -o -name "*.canvas" | wc -l
# Esperado: 33 (23 originales + 10 nuevos: 2 canvas + 8 README adicionales)

# Test 2: Verificar no existen directorios vacíos
find diseno/arquitectura -type d -empty
# Esperado: (vacío)

# Test 3: Validar YAML frontmatter
grep -c "^---$" diseno/arquitectura/README.md
# Esperado: 2

# Test 4: Buscar referencias antiguas
grep -r "docs/ai/agent/arquitectura\|docs/infraestructura/storage\|docs/backend/diseno" diseno/arquitectura/
# Esperado: (vacío) - Sin referencias antiguas

# Test 5: Verificar enlaces internos
find diseno/arquitectura -name "*.md" -exec grep -l "\[.*\](.*)" {} \;
# Revisar manualmente que todas las referencias son relativas
```

### 7.3 Self-Consistency Validation

Para garantizar consistencia, ejecutar:

```python
#!/usr/bin/env python3
import os
import re
from pathlib import Path

def validate_consolidation(root_dir="diseno/arquitectura"):
    """Valida integridad de la consolidación"""

    errors = []
    warnings = []

    # 1. Validar estructura
    required_dirs = [
        "infraestructura", "gobernanza", "agentes/hld", "agentes/adrs",
        "backend", "frontend", "devops"
    ]

    for dir_name in required_dirs:
        dir_path = Path(root_dir) / dir_name
        if not dir_path.exists():
            errors.append(f"Directorio faltante: {dir_path}")

    # 2. Contar archivos
    md_files = list(Path(root_dir).glob("**/*.md"))
    canvas_files = list(Path(root_dir).glob("**/*.canvas"))

    print(f"Archivos markdown: {len(md_files)}")
    print(f"Archivos canvas: {len(canvas_files)}")

    if len(md_files) < 30:
        warnings.append(f"Menos archivos de los esperados: {len(md_files)}")

    # 3. Buscar referencias antiguas
    old_refs = ["docs/ai/agent/", "docs/infraestructura/", "docs/backend/diseno/"]

    for file in md_files:
        with open(file, 'r') as f:
            content = f.read()
            for old_ref in old_refs:
                if old_ref in content and "diseno/arquitectura" not in content:
                    errors.append(f"Referencia antigua en {file}: {old_ref}")

    # 4. Validar frontmatter
    if (Path(root_dir) / "README.md").exists():
        with open(Path(root_dir) / "README.md", 'r') as f:
            first_line = f.readline()
            if not first_line.startswith("---"):
                errors.append("README.md maestro sin frontmatter YAML")

    return {
        "errors": errors,
        "warnings": warnings,
        "total_files": len(md_files) + len(canvas_files),
        "status": "PASS" if not errors else "FAIL"
    }

if __name__ == "__main__":
    result = validate_consolidation()
    print(f"\nValidación: {result['status']}")
    print(f"Total archivos: {result['total_files']}")
    if result['errors']:
        print(f"ERRORES ({len(result['errors'])}):")
        for error in result['errors']:
            print(f"  - {error}")
    if result['warnings']:
        print(f"ADVERTENCIAS ({len(result['warnings'])}):")
        for warning in result['warnings']:
            print(f"  - {warning}")
```

---

## 8. Plan de Implementación (Fases)

### Fase 1: Preparación (30 min)
1. Crear estructura de directorios
2. Crear archivos README.md
3. Generar CONSOLIDATION_SUMMARY.md

### Fase 2: Movimiento de Archivos (60 min)
1. Mover infraestructura (3 archivos)
2. Mover gobernanza (1 archivo)
3. Mover agentes HLD (5 archivos)
4. Mover agentes ADR (4 archivos)
5. Consolidar agentes únicos (3 archivos)
6. Mover backend (1 archivo)
7. Mover frontend (5 archivos)

### Fase 3: Actualización de Referencias (60 min)
1. Buscar referencias antiguas en /docs
2. Actualizar referencias en archivos consolidados
3. Validar integridad de enlaces

### Fase 4: Canvas y Finalización (30 min)
1. Crear canvas DevContainer Host
2. Crear canvas CI/CD Pipeline
3. Ejecutar validación técnica
4. Documentar en evidencias/

### Fase 5: Commit y PR (20 min)
1. Revisar cambios con git diff
2. Commit con mensaje descriptivo
3. Push y crear PR

**Tiempo total estimado**: 3 horas

---

## 9. Criterios de Aceptación

```
✓ DEBE
- [x] Estructura diseno/arquitectura/ creada
- [ ] 23 archivos movidos correctamente
- [ ] 9 README.md creados con contenido
- [ ] 2 Canvas nuevos creados
- [ ] Cero referencias antiguas en diseno/arquitectura/
- [ ] Git history preservado (no copias, movimientos)

✓ DEBERÍA
- [ ] CONSOLIDATION_SUMMARY.md completado
- [ ] Todos los README tienen frontmatter YAML
- [ ] Enlaces internos usan rutas relativas
- [ ] Documentación de migración disponible

✓ PODRÍA
- [ ] Crear script de validación automática
- [ ] Generar índice interactivo de arquitecturas
- [ ] Crear visualización de dependencias entre agentes
```

---

## 10. Rollback Plan

Si algo sale mal:

```bash
# 1. Revertir último commit
git revert HEAD

# 2. O resetear a estado anterior
git reset --hard <commit-hash-anterior>

# 3. O restablecer rama
git checkout <rama-anterior>
```

**Punto de recuperación**: Antes de ejecutar movimientos, hacer commit vacío
```bash
git commit --allow-empty -m "Checkpoint: Antes de consolidación arquitectura"
```

---

## 11. Referencias y Documentación

### Documentos Relacionados
- README.md principal: TASK-REORG-INFRA-006
- MAPEO-ARCHIVOS-ARQUITECTURA.md: Análisis detallado
- Evidencias del proyecto en: `evidencias/`

### Comandos Git Útiles
```bash
# Ver cambios
git status
git diff --name-status HEAD~1

# Historial
git log --oneline diseno/arquitectura/

# Búsqueda de referencias
git grep "docs/ai/agent/arquitectura" HEAD~1
```

---

**Especificación versión**: 1.0
**Fecha creación**: 2025-11-18
**Técnicas utilizadas**: Auto-CoT, Self-Consistency, Decomposed Prompting
**Estado**: LISTO PARA IMPLEMENTACIÓN
