# Estrategia de Merge - PR #175

## Información General

- **Fecha de creación**: 2025-11-13
- **Última actualización**: 2025-11-13
- **PR Origen**: #175 (copilot/sub-pr-175-yet-again)
- **Branch Destino**: develop (rama principal de desarrollo)
- **Branch de Prioridad**: claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
- **Responsable**: @copilot
- **Solicitado por**: @2-Coatl
- **Restricciones**: Sin emojis ni iconos en documentación

## Objetivo

Integrar correctamente el PR #175 a la rama **develop**, manteniendo como **prioridad absoluta** los cambios existentes en `claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R`. La rama develop debe contener todos los commits del historial.

## Requisitos de Integración

1. **Destino**: develop (rama principal de desarrollo)
2. **Prioridad**: Cambios de claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
3. **Historial**: Preservar todos los commits
4. **Formato**: Sin emojis ni iconos en documentación
5. **Validación**: 21 ADRs en formato correcto (ADR_2025_XXX_)

## Contexto del PR #175

### Cambios Principales
- **21 ADRs** renombrados (formato underscore)
- **137 referencias** actualizadas
- **98 archivos** modificados
- **+6,869 líneas netas**
- **Documentación SDLC completa** (6 fases, 4,328 líneas)
- **Reportes de validación** (1,489 líneas)
- **Tests TDD** (751 líneas)

### Dominios Afectados
- AI: 2 ADRs
- Backend: 8 ADRs
- Frontend: 6 ADRs
- Infraestructura: 6 ADRs
- Gobernanza: 1 ADR

## Estrategia de Merge - Opción Recomendada

### Importante: Integración a Develop

Esta estrategia está diseñada para integrar los cambios a la rama **develop**, que es la rama principal de desarrollo del proyecto. Todos los commits deben ser preservados en el historial de develop.

### Opción 1: Merge con Prioridad Claude (RECOMENDADA)

Esta estrategia garantiza que los cambios de la rama Claude se mantengan intactos y que todos los commits sean incluidos en develop.

#### Paso 1: Preparación

```bash
# Posicionarse en la rama de trabajo actual
cd /home/runner/work/IACT---project/IACT---project
git checkout copilot/sub-pr-175-yet-again

# Verificar estado limpio
git status

# Actualizar referencias remotas (incluyendo develop)
git fetch origin
git fetch origin develop
```

#### Paso 2: Obtener Rama Claude

```bash
# Intentar fetch de la rama Claude
git fetch origin claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R

# Si la rama no está en remoto, verificar si existe localmente
git branch -a | grep claude/analyze-scripts-output
```

#### Paso 3: Identificar Archivos en Conflicto

```bash
# Simular merge para ver conflictos (sin commitear)
git merge --no-commit --no-ff origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R

# Ver archivos en conflicto
git status | grep "both modified"

# Abortar el merge temporal
git merge --abort
```

#### Paso 4: Estrategia de Resolución

Para **CADA archivo en conflicto**:

```bash
# Opción A: Aceptar versión Claude completa
git checkout --theirs path/to/conflicted/file

# Opción B: Aceptar versión actual completa
git checkout --ours path/to/conflicted/file

# Opción C: Merge manual (si necesario)
# Editar archivo manualmente preservando cambios Claude
```

**REGLA DE ORO**: En caso de duda, **siempre elegir --theirs** (versión Claude).

#### Paso 5: Merge Real

```bash
# Hacer merge
git merge origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R

# Resolver conflictos siguiendo la estrategia del Paso 4

# Después de resolver todos los conflictos
git add .
git commit -m "merge: integrate claude/analyze-scripts-output with priority on Claude changes"
```

#### Paso 6: Verificación

```bash
# Verificar que no hay conflictos pendientes
git status

# Verificar archivos críticos
git diff HEAD~1 -- docs/gobernanza/INDICE_ADRs.md
git diff HEAD~1 -- docs/ai/agent/

# Ejecutar tests si existen
pytest tests/ -v || echo "Tests not available yet"

# Verificar integridad de ADRs
find docs -name "ADR_2025_*" | wc -l  # Debe ser 21
find docs -name "ADR-2025-*" | wc -l  # Debe ser 0
```

#### Paso 7: Integración a Develop

```bash
# Una vez verificado que el merge es correcto, integrar a develop
# IMPORTANTE: Este paso debe ser realizado por alguien con permisos en develop

# Opción A: Merge directo a develop (requiere permisos)
git checkout develop
git merge copilot/sub-pr-175-yet-again --no-ff -m "feat: integrate ADR standardization and SDLC documentation"
git push origin develop

# Opción B: Crear PR a develop (recomendado para revisión)
# El PR ya existe, solo asegurar que la rama base sea develop
# GitHub/GitLab permitirá merge con revisión
```

**Verificación post-integración a develop**:
```bash
# Verificar que develop tiene todos los commits
git checkout develop
git log --oneline -20

# Verificar que los ADRs están en formato correcto
find docs -name "ADR_2025_*" | wc -l  # Debe ser 21
find docs -name "ADR-2025-*" | wc -l  # Debe ser 0

# Verificar que no hay emojis en documentación nueva
grep -r "✅\|❌\|⏸️" MERGE_STRATEGY_PR_175.md PR_DESCRIPTION.md || echo "Sin emojis - Correcto"
```

#### Paso 8: Push y Cleanup

```bash
# Push de la rama de trabajo (si aún no se hizo)
git checkout copilot/sub-pr-175-yet-again
git push origin copilot/sub-pr-175-yet-again

# Después de merge a develop, limpiar rama de trabajo
# (Opcional, solo después de confirmar que develop tiene todo)
git push origin --delete copilot/sub-pr-175-yet-again
```

## Estrategia Alternativa - Opción 2: Rebase con Prioridad Claude

Si el merge directo causa demasiados conflictos:

```bash
# Hacer backup de la rama actual
git branch backup-pr-175-$(date +%Y%m%d-%H%M%S)

# Rebase sobre Claude
git rebase origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R

# En cada conflicto:
# 1. git status (ver archivos en conflicto)
# 2. Resolver priorizando versión Claude
# 3. git add <archivos-resueltos>
# 4. git rebase --continue

# Si algo sale mal
git rebase --abort
git checkout backup-pr-175-$(date +%Y%m%d)
```

## Estrategia Alternativa - Opción 3: Cherry-pick Selectivo

Si solo algunos commits del PR #175 son necesarios:

```bash
# Cambiar a rama Claude
git checkout claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R
git checkout -b merge-pr-175-selective

# Ver commits del PR #175
git log --oneline copilot/sub-pr-175-yet-again -20

# Cherry-pick commits específicos (ej: documentación SDLC)
git cherry-pick <commit-hash-1>
git cherry-pick <commit-hash-2>

# Resolver conflictos priorizando versión Claude
# Seguir procedimiento del Paso 4
```

## Archivos Críticos a Verificar Post-Merge

### Prioridad Alta

1. **Índice de ADRs**
   - `docs/gobernanza/INDICE_ADRs.md`
   - Verificar que contiene los 21 ADRs

2. **ADRs Renombrados**
   ```bash
   # Verificar nomenclatura correcta
   find docs -name "ADR_2025_*" -type f | sort
   ```

3. **Referencias en Documentación**
   ```bash
   # Buscar referencias a formato antiguo (no debe haber)
   grep -r "ADR-2025-" docs/ --include="*.md" || echo "OK: No old format found"
   ```

4. **Documentación SDLC**
   - `docs/ai/agent/planificacion_y_releases/ISSUE_ADR_MANAGEMENT_AGENT.md`
   - `docs/ai/agent/planificacion_y_releases/FEASIBILITY_ANALYSIS_ADR_MANAGEMENT_AGENT.md`
   - `docs/ai/agent/arquitectura/hld_adr_management_agent.md`
   - `docs/ai/agent/diseno_detallado/lld_adr_management_agent.md`
   - `docs/ai/agent/tests/test_adr_management_agent.py`
   - `docs/ai/agent/deployment/deployment_plan_adr_management_agent.md`
   - `docs/ai/agent/mantenimiento/maintenance_plan_adr_management_agent.md`

5. **CODEOWNERS**
   - `.github/CODEOWNERS`

### Prioridad Media

6. **Reportes de Validación**
   - `docs/REPORTE_VALIDACION_COMPLETA.md`
   - `docs/VALIDACION_CONFORMIDAD_GOBERNANZA.md`

7. **Scripts**
   - Verificar que scripts obsoletos fueron removidos
   - `scripts/estandarizar_adrs.py` (debe NO existir)
   - `scripts/corregir_nomenclatura_adrs.py` (debe NO existir)
   - `scripts/actualizar_referencias_adrs.py` (debe NO existir)

### Prioridad Baja

8. **Configuración**
   - `.gitignore`
   - `pytest.ini`
   - `requirements.txt`

## Matriz de Decisión de Conflictos

| Tipo de Conflicto | Estrategia | Prioridad |
|-------------------|------------|-----------|
| ADR renombrado vs ADR original | Mantener Claude | ALTA |
| Índice ADRs nuevo vs antiguo | Mantener Claude | ALTA |
| CODEOWNERS movido vs original | Mantener Claude | ALTA |
| Documentación SDLC nueva vs ausente | Integrar PR #175 | MEDIA |
| Tests nuevos vs ausentes | Integrar PR #175 | MEDIA |
| Scripts eliminados vs existentes | Mantener Claude | ALTA |
| Referencias actualizadas vs antiguas | Mantener Claude | ALTA |
| Reportes nuevos vs ausentes | Integrar PR #175 | BAJA |

## Resolución de Conflictos Específicos

### Si Conflicto en INDICE_ADRs.md

```bash
# Aceptar versión Claude
git checkout --theirs docs/gobernanza/INDICE_ADRs.md

# Verificar que contiene 21 ADRs
grep "ADR_2025_" docs/gobernanza/INDICE_ADRs.md | wc -l
```

### Si Conflicto en ADRs Individuales

```bash
# Para cada ADR en conflicto
# Aceptar versión Claude (nombre con underscores)
git checkout --theirs docs/backend/arquitectura/adr/ADR_2025_XXX_*.md
git checkout --theirs docs/frontend/arquitectura/adr/ADR_2025_XXX_*.md
# etc.
```

### Si Conflicto en Documentación Nueva

```bash
# Si el archivo solo existe en PR #175, no hay conflicto
# Si existe en ambas, verificar contenido

# Ver diferencias
git diff origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R..HEAD -- path/to/doc

# Decisión:
# - Si contenido es complementario: merge manual
# - Si contenido es contradictorio: priorizar Claude
```

## Checklist de Validación Post-Merge

### Validaciones Técnicas
```markdown
- [ ] Merge completado sin conflictos pendientes
- [ ] git status muestra "working tree clean"
- [ ] 21 ADRs con formato ADR_2025_XXX_*.md
- [ ] 0 ADRs con formato antiguo ADR-2025-XXX-*.md
- [ ] Índice maestro existe en docs/gobernanza/INDICE_ADRs.md
- [ ] CODEOWNERS en .github/CODEOWNERS
- [ ] Documentación SDLC completa (7 archivos)
- [ ] Tests TDD existen
- [ ] Scripts obsoletos eliminados
- [ ] Referencias actualizadas (sin formato antiguo)
- [ ] Build pasa (si aplica)
- [ ] Tests pasan (si aplica)
```

### Validaciones de Formato
```markdown
- [ ] Sin emojis en MERGE_STRATEGY_PR_175.md
- [ ] Sin emojis en PR_DESCRIPTION.md
- [ ] Sin iconos en documentación nueva
- [ ] Formato markdown correcto
```

### Validaciones de Integración
```markdown
- [ ] Commit de merge creado
- [ ] Push exitoso a rama de trabajo
- [ ] Rama develop contiene todos los commits
- [ ] Historial de commits preservado
- [ ] PR actualizado con estrategia de merge
```

## Rollback Plan

Si algo sale mal durante el merge:

```bash
# Opción 1: Abortar merge
git merge --abort

# Opción 2: Reset a estado anterior
git reset --hard HEAD~1  # O usa git reset --hard ORIG_HEAD para volver al commit anterior al merge

# Opción 3: Restaurar desde backup
# Busca el nombre correcto de la rama de backup antes de hacer checkout:
git branch | grep backup-pr-175
# Luego usa el nombre exacto, por ejemplo:
git checkout backup-pr-175-20251113-143000

# Opción 4: Recrear rama desde remoto
git fetch origin
git reset --hard origin/copilot/sub-pr-175-yet-again
```

## Comandos de Emergencia

```bash
# Ver estado actual
git status
git log --oneline -10

# Ver conflictos
git diff

# Ver qué archivos cambiaron en cada rama
git diff origin/claude/analyze-scripts-output-011CV5YLxdEnu9YN3qpzGV2R..HEAD --name-only

# Deshacer último commit (si aún no se hizo push)
git reset --soft HEAD~1

# Ver archivos en staging
git diff --cached --name-only
```

## Comunicación Post-Merge

Después de completar el merge exitosamente:

1. **Actualizar PR Description** con:
   - Estrategia de merge utilizada
   - Conflictos encontrados y cómo se resolvieron
   - Archivos priorizados de rama Claude
   - Checklist de validación completada

2. **Comentar en PR** con resumen:
   ```markdown
   Merge completado con prioridad en rama Claude
   
   **Estrategia**: [Opción utilizada]
   **Conflictos resueltos**: X archivos
   **Prioridad Claude**: Mantenida en todos los conflictos
   **Validación**: Checklist completo
   **Commit**: [hash del commit de merge]
   ```

3. **Solicitar revisión** si es necesario

## Referencias

- **Runbook de Merge**: `docs/operaciones/merge_y_limpieza_ramas.md`
- **Registro previo**: `docs/ai/registros/2025_11_05_merge_ramas.md`
- **PR Description**: [Ver arriba en contexto]
- **Git Documentation**: https://git-scm.com/docs/git-merge

## Notas Técnicas

### Diferencias entre --ours y --theirs

En contexto de merge:
- `--ours`: Versión de la rama **actual** (copilot/sub-pr-175-yet-again)
- `--theirs`: Versión de la rama **entrante** (claude/analyze-scripts-output)

**Para priorizar Claude**: Usar `--theirs`

### Tipos de Merge

1. **Fast-forward**: Cuando no hay commits divergentes
   ```bash
   git merge --ff-only
   ```

2. **Three-way merge**: Cuando hay commits en ambas ramas
   ```bash
   git merge --no-ff
   ```

3. **Squash merge**: Combinar todos los commits en uno
   ```bash
   git merge --squash
   ```

**Recomendación**: Three-way merge con `--no-ff` para mantener historial.

## Métricas de Éxito

- **0 conflictos** pendientes después del merge
- **100%** de archivos Claude priorizados mantenidos
- **21 ADRs** en formato correcto
- **0 referencias** a formato antiguo
- **All checks passing** (CI/CD)
- **Review approved** por @2-Coatl

---

**Documento creado**: 2025-11-13
**Última actualización**: 2025-11-13
**Estado**: Propuesta
**Versión**: 1.0.0
**Aprobación requerida**: @2-Coatl
