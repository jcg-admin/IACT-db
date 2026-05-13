# Guía de Implementación Rápida

**TASK-REORG-INFRA-006: Consolidar diseño/arquitectura/**
**Tiempo total**: ~3 horas
**Complejidad**: Media
**Riesgo**: Bajo (con validación)

---

## Inicio Rápido (5 min)

### 1. Verificar Prereq
```bash
cd /home/user/IACT
git status
git branch
```

**✓ Debe mostrar**: rama limpia y en `claude/reorganize-infra-docs-*`

### 2. Crear estructura
```bash
mkdir -p diseno/arquitectura/{infraestructura,gobernanza,agentes/{hld,adrs},backend,frontend,devops}
```

### 3. Verificar estructura creada
```bash
tree diseno/arquitectura/ -L 2
```

---

## FASE 1: Preparación (30 min)

### Paso 1.1: Crear README.md en cada sección

```bash
# infraestructura
cat > diseno/arquitectura/infraestructura/README.md << 'EOF'
# Arquitectura de Infraestructura

## Contenido
- ambientes_virtualizados.md: Configuración de ambientes virtualizados
- storage_architecture.md: Diseño de capas de almacenamiento
- cpython_precompilado_arquitectura.md: CPython para CI/CD

## Canvas
- devcontainer_host_architecture.canvas: Arquitectura del host

[Volver a inicio](../README.md)
EOF

# gobernanza
cat > diseno/arquitectura/gobernanza/README.md << 'EOF'
# Arquitectura de Gobernanza

## Contenido
- storage_architecture_gobernanza.md: Governance de almacenamiento

## Estándares
- Decisiones arquitectónicas documentadas
- Cumplimiento regulatorio
- ADRs relacionados

[Volver a inicio](../README.md)
EOF

# agentes
cat > diseno/arquitectura/agentes/README.md << 'EOF'
# Arquitectura de Agentes IA

## Contenido
- ARCHITECTURE_AGENTS_OVERVIEW.md: Visión general de agentes
- ARCHITECTURE_SDLC.md: Arquitectura SDLC
- ARCHITECTURE_SDLC_AGENTS_DETAILED.md: Detalles SDLC
- AGENTS_DEVOPS_AUTOMATION_ARCHITECTURE.md: DevOps

### HLD (High Level Design)
- hld/shell_script_remediation_agent.md
- hld/adr_management_agent.md
- hld/documentation_analysis_agent.md
- hld/plan_validation_agent.md

### ADR (Architecture Decision Records)
- adrs/plan_validation_agent.md
- adrs/shell_script_remediation_agent.md
- adrs/shell_script_analysis_agent.md
- adrs/documentation_analysis_agent.md

[Volver a inicio](../README.md)
EOF

# backend
cat > diseno/arquitectura/backend/README.md << 'EOF'
# Arquitectura de Backend

## Contenido
- permisos_granular_arquitectura.md: Sistema de permisos granulares

## Características
- Control de acceso basado en roles
- Recursos protegidos
- Integración con autenticación

[Volver a inicio](../README.md)
EOF

# frontend
cat > diseno/arquitectura/frontend/README.md << 'EOF'
# Arquitectura de Frontend

## Contenido
- microfrontends_canvas.md: Arquitectura de microfrontends
- shared_webpack_configs.md: Configuración Webpack compartida
- estrategia_integracion_backend.md: Integración con backend
- analisis_api_frontend.md: Análisis de APIs
- ejemplos_ui_design.md: Patrones de diseño UI

## Canvas
Usa canvas en microfrontends_canvas.md para visualizar modelos

[Volver a inicio](../README.md)
EOF

# devops
cat > diseno/arquitectura/devops/README.md << 'EOF'
# Arquitectura de DevOps

## Canvas
- cicd_pipeline_architecture.canvas: Pipeline CI/CD

## Documentación
- Desde agentes/AGENTS_DEVOPS_AUTOMATION_ARCHITECTURE.md

[Volver a inicio](../README.md)
EOF
```

### Paso 1.2: Crear HLD y ADR README
```bash
cat > diseno/arquitectura/agentes/hld/README.md << 'EOF'
# HLD - High Level Design

Documentación de alto nivel de agentes especializados.

[Volver a agentes](../README.md)
EOF

cat > diseno/arquitectura/agentes/adrs/README.md << 'EOF'
# ADR - Architecture Decision Records

Decisiones arquitectónicas de agentes.

[Volver a agentes](../README.md)
EOF
```

---

## FASE 2: Movimiento de Archivos (60 min)

### Paso 2.1: Infraestructura (5 min)

```bash
# Mover con git mv para preservar history
git mv docs/infraestructura/ambientes_virtualizados.md \
        diseno/arquitectura/infraestructura/

git mv docs/infraestructura/storage_architecture.md \
        diseno/arquitectura/infraestructura/

git mv docs/infraestructura/cpython_precompilado/arquitectura.md \
        diseno/arquitectura/infraestructura/cpython_precompilado_arquitectura.md

# Verificar
ls -la diseno/arquitectura/infraestructura/
```

### Paso 2.2: Gobernanza (3 min)

```bash
git mv docs/gobernanza/diseno/arquitectura/STORAGE_ARCHITECTURE.md \
        diseno/arquitectura/gobernanza/storage_architecture_gobernanza.md

# Verificar
ls -la diseno/arquitectura/gobernanza/
```

### Paso 2.3: Agentes HLD (10 min)

```bash
git mv docs/ai/agent/arquitectura/hld_shell_script_remediation_agent.md \
        diseno/arquitectura/agentes/hld/shell_script_remediation_agent.md

git mv docs/ai/agent/arquitectura/hld_adr_management_agent.md \
        diseno/arquitectura/agentes/hld/adr_management_agent.md

git mv docs/ai/agent/arquitectura/hld_documentation_analysis_agent.md \
        diseno/arquitectura/agentes/hld/documentation_analysis_agent.md

git mv docs/ai/agent/arquitectura/hld_plan_validation_agent.md \
        diseno/arquitectura/agentes/hld/plan_validation_agent.md

git mv docs/ai/agent/arquitectura/hld_shell_script_analysis_agent.md \
        diseno/arquitectura/agentes/hld/shell_script_analysis_agent.md

# Verificar
ls -la diseno/arquitectura/agentes/hld/
```

### Paso 2.4: Agentes ADR (10 min)

```bash
git mv docs/ai/agent/arquitectura/adrs_plan_validation_agent.md \
        diseno/arquitectura/agentes/adrs/plan_validation_agent.md

git mv docs/ai/agent/arquitectura/adrs_shell_script_remediation_agent.md \
        diseno/arquitectura/agentes/adrs/shell_script_remediation_agent.md

git mv docs/ai/agent/arquitectura/adrs_shell_script_analysis_agent.md \
        diseno/arquitectura/agentes/adrs/shell_script_analysis_agent.md

git mv docs/ai/agent/arquitectura/adrs_documentation_analysis_agent.md \
        diseno/arquitectura/agentes/adrs/documentation_analysis_agent.md

# Verificar
ls -la diseno/arquitectura/agentes/adrs/
```

### Paso 2.5: Agentes Consolidados (15 min)

```bash
# Copiar y consolidar ARCHITECTURE.md
git mv docs/agents/ARCHITECTURE.md \
        diseno/arquitectura/agentes/ARCHITECTURE_AGENTS_OVERVIEW.md

# Mover README de arquitectura
git mv docs/ai/arquitectura/README.md \
        diseno/arquitectura/agentes/README_ORIGINAL.md  # Renombrar si hay conflicto

# Mover SDLC
git mv scripts/coding/ai/agents/ARCHITECTURE_SDLC_AGENTS.md \
        diseno/arquitectura/agentes/ARCHITECTURE_SDLC_AGENTS_DETAILED.md

# Mover DevOps
git mv docs/devops/automatizacion/planificacion/AUTOMATION_ARCHITECTURE.md \
        diseno/arquitectura/agentes/AGENTS_DEVOPS_AUTOMATION_ARCHITECTURE.md

# Nota: scripts/coding/ai/agents/ARCHITECTURE.md puede ser merge con overview
```

### Paso 2.6: Backend (3 min)

```bash
git mv docs/backend/diseno/permisos/arquitectura_permisos_granular.md \
        diseno/arquitectura/backend/permisos_granular_arquitectura.md

# Verificar
ls -la diseno/arquitectura/backend/
```

### Paso 2.7: Frontend (10 min)

```bash
git mv docs/frontend/arquitectura/microfrontends_canvas.md \
        diseno/arquitectura/frontend/

git mv docs/frontend/arquitectura/shared_webpack_configs.md \
        diseno/arquitectura/frontend/

git mv docs/frontend/arquitectura/estrategia_integracion_backend.md \
        diseno/arquitectura/frontend/

git mv docs/frontend/arquitectura/analisis_api_frontend.md \
        diseno/arquitectura/frontend/

git mv docs/frontend/arquitectura/ejemplos_ui_design.md \
        diseno/arquitectura/frontend/

# Verificar
ls -la diseno/arquitectura/frontend/
```

### Paso 2.8: Verificar total
```bash
find diseno/arquitectura -type f -name "*.md" | wc -l
# Debe mostrar: ~27 (originales sin consolidados)
```

---

## FASE 3: Actualización de Referencias (60 min)

### Paso 3.1: Buscar referencias antiguas

```bash
# Buscar en diseno/arquitectura
grep -r "docs/ai/agent/arquitectura" diseno/arquitectura/ 2>/dev/null | wc -l

# Si hay resultados, actualizar:
# OLD: [Link](../../docs/ai/agent/arquitectura/hld_*.md)
# NEW: [Link](./hld/shell_script_*.md)
```

### Paso 3.2: Script de actualización de referencias

```bash
#!/bin/bash
# actualizar_referencias.sh

cd /home/user/IACT

echo "Buscando referencias antiguas..."

# Patrones a reemplazar
declare -a PATTERNS=(
    "docs/ai/agent/arquitectura/hld_shell_script_remediation_agent.md:agentes/hld/shell_script_remediation_agent.md"
    "docs/ai/agent/arquitectura/hld_adr_management_agent.md:agentes/hld/adr_management_agent.md"
    "docs/infraestructura/ambientes_virtualizados.md:diseno/arquitectura/infraestructura/ambientes_virtualizados.md"
    "docs/infraestructura/storage_architecture.md:diseno/arquitectura/infraestructura/storage_architecture.md"
)

for pattern in "${PATTERNS[@]}"; do
    IFS=':' read -r old new <<< "$pattern"

    # Buscar archivos que referencian el antiguo
    files=$(grep -r "$old" docs/ 2>/dev/null | cut -d: -f1 | sort | uniq)

    if [ -n "$files" ]; then
        echo "Encontrado en: $(echo $files | wc -l) archivos"

        # Actualizar cada archivo (opcional, requiere edit manual)
        # sed -i "s|$old|$new|g" $files
    fi
done
```

### Paso 3.3: Actualizar manualmente referencias críticas

```bash
# Ejemplo: Si docs/README.md referencia arquitectura antigua
grep -l "docs/infraestructura/storage\|docs/ai/agent/arquitectura" docs/README.md docs/INDICE.md 2>/dev/null | \
    while read file; do
        echo "Revisar manualmente: $file"
        grep "docs/infraestructura/\|docs/ai/agent/" "$file"
    done
```

---

## FASE 4: Canvas y Nuevos Archivos (30 min)

### Paso 4.1: Crear Canvas - DevContainer Host

```bash
cat > diseno/arquitectura/infraestructura/devcontainer_host_architecture.canvas << 'EOF'
# DevContainer Host Architecture

## Componentes Principales
- Host Machine
  - Docker Daemon
  - Volume Mounts
  - Network Bridge

- Contenedores
  - Development Container
  - Database Container
  - Cache Container (Redis)

## Conectividad
- Host → Container: Volume Mounts (bind mount)
- Container → Host: Network (host network)
- Logging: Host log aggregation

## Monitoreo
- Health checks
- Resource limits (CPU, Memory)
- Log streaming to host

## Persistencia
- Named volumes para datos
- Bind mounts para código
- Host backup strategy
EOF
```

### Paso 4.2: Crear Canvas - CI/CD Pipeline

```bash
cat > diseno/arquitectura/devops/cicd_pipeline_architecture.canvas << 'EOF'
# CI/CD Pipeline Architecture

## Stages
1. Trigger
   - GitHub webhook
   - Branch filter

2. Build
   - Lint
   - Test
   - Security scan

3. Deploy
   - Dev environment
   - Staging environment
   - Production environment

4. Validation
   - Smoke tests
   - Integration tests
   - Performance tests

## Integration Points
- GitHub Actions
- Agents (shell script, documentation, plan validation)
- Artifact registry

## Rollback Strategy
- Blue-Green deployment
- Automated rollback on test failure
- Health check monitoring
EOF
```

---

## FASE 5: Validación e Integración (20 min)

### Paso 5.1: Validación Rápida

```bash
#!/bin/bash
echo "=== VALIDACIÓN RÁPIDA ==="

# 1. Contar archivos
echo "Archivos .md:"
find diseno/arquitectura -name "*.md" | wc -l

echo "Archivos .canvas:"
find diseno/arquitectura -name "*.canvas" | wc -l

# 2. Verificar no hay archivos vacíos
echo "Archivos vacíos:"
find diseno/arquitectura -type f -size 0 | wc -l

# 3. Verificar referencias antiguas
echo "Referencias antiguas encontradas:"
grep -r "docs/ai/agent/arquitectura\|docs/infraestructura/ambientes\|docs/infraestructura/storage_architecture" \
    diseno/arquitectura/ 2>/dev/null | wc -l

# 4. Verificar README en cada sección
echo "README.md en secciones:"
find diseno/arquitectura -maxdepth 2 -name "README.md" | wc -l

echo "=== FIN VALIDACIÓN ==="
```

### Paso 5.2: Verificar estado git

```bash
git status
# Debe mostrar cambios con git mv (no eliminaciones + adiciones)

git diff --name-status
# Debe mostrar R (renamed) para archivos movidos
```

### Paso 5.3: Commit

```bash
git add diseno/arquitectura/
git commit -m "feat(reorg): Consolidar arquitectura en diseno/arquitectura/

- Mover 23 archivos de arquitectura desde ubicaciones dispersas
- Crear estructura centralizada bajo diseno/arquitectura/
- Crear Canvas: DevContainer Host y CI/CD Pipeline
- Actualizar referencias internas
- Agregar README.md en cada sección

TASK-REORG-INFRA-006"
```

### Paso 5.4: Verificar push

```bash
git push origin claude/reorganize-infra-docs-*
```

---

## Checklist de Completitud

```
FASE 1: PREPARACIÓN
[✓] Estructura de directorios creada
[✓] README.md en 7 secciones
[ ] README.md en hld/ y adrs/

FASE 2: MOVIMIENTOS
[ ] 3 archivos infraestructura movidos
[ ] 1 archivo gobernanza movido
[ ] 5 archivos HLD movidos
[ ] 4 archivos ADR movidos
[ ] 4 archivos consolidados movidos
[ ] 1 archivo backend movido
[ ] 5 archivos frontend movidos
[ ] Total: 23 archivos movidos

FASE 3: REFERENCIAS
[ ] Búsqueda de referencias antiguas completada
[ ] Referencias críticas actualizadas
[ ] Validación sin referencias antiguas

FASE 4: CANVAS
[ ] Canvas DevContainer Host creado
[ ] Canvas CI/CD Pipeline creado

FASE 5: INTEGRACIÓN
[ ] Validación ejecutada sin errores
[ ] Git status limpio
[ ] Commit creado
[ ] Push a rama completado

POSTIMPLEMENTACIÓN
[ ] PR creado en GitHub
[ ] Revisión completada
[ ] Merge a main
```

---

## Rollback Rápido (Si algo sale mal)

```bash
# Opción 1: Deshacer último commit
git reset --hard HEAD~1

# Opción 2: Crear rama nueva desde punto seguro
git checkout -b backup $(git log --oneline | grep "Antes de consolidación" | head -1 | cut -d' ' -f1)

# Opción 3: Stash y revertir cambios
git stash
git checkout diseno/arquitectura/
```

---

## Ayuda Rápida

| Problema | Solución |
|----------|----------|
| "Archivo no encontrado en origen" | Verificar ruta exacta con `find docs -name "*archivo*"` |
| "Git conflict en merge" | Usar `git status` para ver conflictos, resolver manualmente |
| "Referencias antiguas no encontradas" | Ejecutar `grep -r` con patrón completo |
| "Directorio destino no existe" | Crear con `mkdir -p` antes de `git mv` |
| "Permisos denegados" | Verificar permisos con `ls -la` e usar `sudo` si es necesario |

---

## Proximos Pasos

1. **Ejecutar Fase 1**: Crear estructura base
2. **Ejecutar Fase 2**: Mover archivos
3. **Ejecutar Fase 3**: Actualizar referencias
4. **Ejecutar Fase 4**: Crear Canvas
5. **Ejecutar Fase 5**: Validar e integrar
6. **Crear PR**: Someter para review
7. **Merge**: Integrar a main

---

**Tiempo total**: ~3 horas
**Complejidad**: Media
**Riesgo**: Bajo

¡Listo para comenzar! 🚀
