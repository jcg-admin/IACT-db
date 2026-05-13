---
title: Deployment Plan - Sistema Automatizacion
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: deployment
subfase: tdd_green
proyecto: IACT---project
parent_doc: TESTING_PLAN.md
status: in_progress
version: 1.0
---

# Deployment Plan: Sistema Automatizacion (TDD GREEN)

**Issue**: IACT-AUTO-001
**Fase**: FASE 5 - DEPLOYMENT (TDD GREEN)
**Fecha**: 2025-11-13
**Parent**: TESTING_PLAN.md v1.0

---

## Proposito

Este documento especifica el **procedimiento de implementacion** del sistema de automatizacion siguiendo TDD GREEN:

1. **RED**: Tests escritos y fallando (FASE 4 - COMPLETO)
2. **GREEN**: Implementar codigo minimo para pasar tests (esta fase)
3. **REFACTOR**: Optimizar (FASE 6)

**Audiencia**: Desarrollador implementando sistema de automatizacion

---

## 1. TDD Workflow

### 1.1 Ciclo TDD para Cada Componente

```
Para cada componente (constitucion.sh, ci-local.sh, etc.):
1. Ejecutar tests → ROJO (fallan)
2. Implementar funcionalidad minima
3. Ejecutar tests → VERDE (pasan)
4. Refactorizar (si necesario, FASE 6)
5. Repetir
```

### 1.2 Orden Implementacion

**Orden recomendado** (dependencias primero):

1. **Utilidades** (logging.sh) - No depende de nada
2. **Helpers** (validate_constitution_schema.sh, validate_devcontainer_env.sh, check_ui_api_coherence.sh)
3. **Constitucion** (constitucion.sh) - Depende de helpers
4. **CI Local** (ci-local.sh) - Depende de constitucion
5. **Integracion DevContainer** (post_create.sh, post_start.sh)
6. **Git Hooks** (modificaciones install_hooks.sh, pre-push)

---

## 2. Implementacion Fase por Fase

### 2.1 FASE 5.1: Implementar Utilidades (logging.sh)

**Objetivo**: Pasar unit tests logging.sh (8-10 tests)

#### 2.1.1 Procedimiento

```bash
# 1. Ejecutar tests (deben FALLAR)
bats tests/unit/test_logging.bats
# Expected: 0/10 tests passed

# 2. Implementar logging.sh
# Copiar codigo de LLD_04_SCRIPTS_HELPERS.md seccion 3.1
cat > scripts/utils/logging.sh <<'EOF'
# ... (codigo completo de LLD_04 seccion 3.1)
EOF

chmod +x scripts/utils/logging.sh

# 3. Ejecutar tests nuevamente
bats tests/unit/test_logging.bats
# Expected: 10/10 tests passed (VERDE)

# 4. Commit
git add scripts/utils/logging.sh tests/unit/test_logging.bats
git commit -m "feat(utils): implement logging.sh utilities - TDD GREEN"
```

**Tiempo estimado**: 30 minutos

---

### 2.2 FASE 5.2: Implementar validate_constitution_schema.sh

**Objetivo**: Pasar unit tests validate_constitution_schema.sh (6-8 tests)

#### 2.2.1 Procedimiento

```bash
# 1. Ejecutar tests (ROJO)
bats tests/unit/test_validate_constitution_schema.bats
# Expected: 0/8 tests passed

# 2. Implementar script
# Copiar codigo de LLD_04_SCRIPTS_HELPERS.md seccion 1.3
cat > scripts/validate_constitution_schema.sh <<'EOF'
# ... (codigo completo de LLD_04 seccion 1.3.2)
EOF

chmod +x scripts/validate_constitution_schema.sh

# 3. Ejecutar tests (VERDE)
bats tests/unit/test_validate_constitution_schema.bats
# Expected: 8/8 tests passed

# 4. Commit
git add scripts/validate_constitution_schema.sh tests/unit/test_validate_constitution_schema.bats
git commit -m "feat(scripts): implement validate_constitution_schema.sh - TDD GREEN"
```

**Tiempo estimado**: 1 hora

---

### 2.3 FASE 5.3: Implementar validate_devcontainer_env.sh

**Objetivo**: Pasar unit tests validate_devcontainer_env.sh (8-10 tests)

#### 2.3.1 Procedimiento

```bash
# 1. Ejecutar tests (ROJO)
bats tests/unit/test_validate_devcontainer_env.bats

# 2. Implementar script
# Copiar codigo de LLD_04_SCRIPTS_HELPERS.md seccion 1.2
cat > scripts/validate_devcontainer_env.sh <<'EOF'
# ... (codigo completo de LLD_04 seccion 1.2.2)
EOF

chmod +x scripts/validate_devcontainer_env.sh

# 3. Ejecutar tests (VERDE)
bats tests/unit/test_validate_devcontainer_env.bats
# Expected: 10/10 tests passed

# 4. Commit
git add scripts/validate_devcontainer_env.sh tests/unit/test_validate_devcontainer_env.bats
git commit -m "feat(scripts): implement validate_devcontainer_env.sh - TDD GREEN"
```

**Tiempo estimado**: 1.5 horas

---

### 2.4 FASE 5.4: Implementar check_ui_api_coherence.sh

**Objetivo**: Pasar unit tests check_ui_api_coherence.sh (5-8 tests)

#### 2.4.1 Procedimiento

```bash
# 1. Ejecutar tests (ROJO)
bats tests/unit/test_check_ui_api_coherence.bats

# 2. Implementar script
# Copiar codigo de LLD_04_SCRIPTS_HELPERS.md seccion 1.1
cat > scripts/check_ui_api_coherence.sh <<'EOF'
# ... (codigo completo de LLD_04 seccion 1.1.2)
EOF

chmod +x scripts/check_ui_api_coherence.sh

# 3. Ejecutar tests (VERDE)
bats tests/unit/test_check_ui_api_coherence.bats
# Expected: 8/8 tests passed

# 4. Commit
git add scripts/check_ui_api_coherence.sh tests/unit/test_check_ui_api_coherence.bats
git commit -m "feat(scripts): implement check_ui_api_coherence.sh - TDD GREEN"
```

**Tiempo estimado**: 1 hora

---

### 2.5 FASE 5.5: Implementar constitucion.sh

**Objetivo**: Pasar unit tests constitucion.sh (15-20 tests)

#### 2.5.1 Procedimiento

**CRITICO**: Este es el componente mas complejo

```bash
# 1. Ejecutar tests (ROJO)
bats tests/unit/test_constitucion.bats
# Expected: 0/20 tests passed

# 2. Implementar constitucion.sh
# Copiar codigo de LLD_01_CONSTITUCION.md seccion 3

# Implementacion iterativa:
# 2a. Implementar solo carga YAML y validacion basica
# 2b. Ejecutar subset tests (validacion YAML)
# 2c. Implementar evaluacion reglas (R1, R2, etc.)
# 2d. Ejecutar todos tests
# 2e. Ajustar hasta VERDE completo

cat > scripts/constitucion.sh <<'EOF'
# ... (codigo completo de LLD_01 seccion 3)
EOF

chmod +x scripts/constitucion.sh

# 3. Ejecutar tests progresivamente
bats tests/unit/test_constitucion.bats --filter "YAML"
# Fix hasta verde

bats tests/unit/test_constitucion.bats --filter "R1"
# Fix hasta verde

bats tests/unit/test_constitucion.bats --filter "R2"
# Fix hasta verde

# ... repeat para R3-R6

# 4. Ejecutar TODOS tests (VERDE)
bats tests/unit/test_constitucion.bats
# Expected: 20/20 tests passed

# 5. Commit
git add scripts/constitucion.sh tests/unit/test_constitucion.bats
git commit -m "feat(constitucion): implement constitution validation system - TDD GREEN"
```

**Tiempo estimado**: 4-6 horas (componente mas complejo)

---

### 2.6 FASE 5.6: Implementar ci-local.sh

**Objetivo**: Pasar unit tests ci-local.sh (15-20 tests)

#### 2.6.1 Procedimiento

```bash
# 1. Ejecutar tests (ROJO)
bats tests/unit/test_ci_local.bats

# 2. Implementar ci-local.sh
# Copiar codigo de LLD_02_CI_LOCAL.md seccion 3

# Implementacion iterativa:
# 2a. Implementar solo carga .ci-local.yaml
# 2b. Implementar smart detection
# 2c. Implementar ejecucion stages
# 2d. Implementar paralelizacion
# 2e. Implementar fail-fast
# 2f. Implementar reportes

cat > scripts/ci-local.sh <<'EOF'
# ... (codigo completo de LLD_02 seccion 3)
EOF

chmod +x scripts/ci-local.sh

# 3. Ejecutar tests progresivamente
bats tests/unit/test_ci_local.bats --filter "YAML"
bats tests/unit/test_ci_local.bats --filter "smart detection"
bats tests/unit/test_ci_local.bats --filter "parallel"
# ... etc

# 4. Ejecutar TODOS tests (VERDE)
bats tests/unit/test_ci_local.bats
# Expected: 20/20 tests passed

# 5. Commit
git add scripts/ci-local.sh tests/unit/test_ci_local.bats
git commit -m "feat(ci-local): implement local CI/CD pipeline orchestrator - TDD GREEN"
```

**Tiempo estimado**: 4-6 horas

---

### 2.7 FASE 5.7: Modificar Scripts Existentes

**Objetivo**: Integrar sistema con scripts existentes

#### 2.7.1 Modificar install_hooks.sh

```bash
# 1. Backup
cp scripts/install_hooks.sh scripts/install_hooks.sh.backup

# 2. Aplicar modificacion de LLD_04 seccion 2.1
# Agregar mensaje constitucion despues linea 63

# 3. Test manual
./scripts/install_hooks.sh
# Verificar mensaje constitucion en output

# 4. Commit
git add scripts/install_hooks.sh
git commit -m "feat(hooks): add constitution system info to install_hooks.sh"
```

**Tiempo estimado**: 15 minutos

#### 2.7.2 Modificar pre-push hook

```bash
# 1. Backup
cp scripts/git-hooks/pre-push scripts/git-hooks/pre-push.backup

# 2. Aplicar modificacion de LLD_04 seccion 2.2
# Agregar invocacion constitucion.sh ANTES de tests

# 3. Test integration tests
bats tests/integration/test_hooks_integration.bats
# Expected: VERDE

# 4. Commit
git add scripts/git-hooks/pre-push
git commit -m "feat(hooks): integrate constitution validation in pre-push hook"
```

**Tiempo estimado**: 30 minutos

---

### 2.8 FASE 5.8: Integrar con DevContainer

**Objetivo**: Pasar integration tests DevContainer (5-6 tests)

#### 2.8.1 Modificar post_create.sh

```bash
# 1. Ejecutar tests (ROJO)
bats tests/integration/test_devcontainer_lifecycle.bats

# 2. Backup
cp infrastructure/devcontainer/scripts/post_create.sh infrastructure/devcontainer/scripts/post_create.sh.backup

# 3. Aplicar modificaciones de LLD_03 seccion 2.1
# Agregar al final del archivo

# 4. Ejecutar tests (VERDE)
bats tests/integration/test_devcontainer_lifecycle.bats
# Expected: 6/6 tests passed

# 5. Commit
git add infrastructure/devcontainer/scripts/post_create.sh
git commit -m "feat(devcontainer): integrate automation system in post_create hook"
```

**Tiempo estimado**: 1 hora

#### 2.8.2 Modificar post_start.sh

```bash
# 1. Backup
cp infrastructure/devcontainer/scripts/post_start.sh infrastructure/devcontainer/scripts/post_start.sh.backup

# 2. Aplicar modificaciones de LLD_03 seccion 2.2
# Agregar quick health checks

# 3. Test manual
./infrastructure/devcontainer/scripts/post_start.sh
# Verificar health checks output

# 4. Commit
git add infrastructure/devcontainer/scripts/post_start.sh
git commit -m "feat(devcontainer): add health checks to post_start hook"
```

**Tiempo estimado**: 30 minutos

---

### 2.9 FASE 5.9: Crear Archivos Configuracion

**Objetivo**: Crear .constitucion.yaml y .ci-local.yaml

#### 2.9.1 Crear .constitucion.yaml

```bash
# Copiar de LLD_05 seccion 2.2
cat > .constitucion.yaml <<'EOF'
# ... (contenido completo de LLD_05 seccion 2.2)
EOF

# Validar
./scripts/validate_constitution_schema.sh .constitucion.yaml
# Expected: Schema valido

# Commit
git add .constitucion.yaml
git commit -m "feat(constitucion): add constitution configuration file"
```

**Tiempo estimado**: 15 minutos

#### 2.9.2 Crear .ci-local.yaml

```bash
# Copiar de LLD_05 seccion 2.3
cat > .ci-local.yaml <<'EOF'
# ... (contenido completo de LLD_05 seccion 2.3)
EOF

# Commit
git add .ci-local.yaml
git commit -m "feat(ci-local): add CI local pipeline configuration"
```

**Tiempo estimado**: 15 minutos

---

## 3. Integration Testing

### 3.1 Ejecutar Integration Tests

**Despues de implementar todos componentes**:

```bash
# 1. Hooks integration
bats tests/integration/test_hooks_integration.bats
# Expected: 10/10 VERDE

# 2. CI pipeline integration
bats tests/integration/test_ci_pipeline.bats
# Expected: 8/8 VERDE

# 3. DevContainer integration
bats tests/integration/test_devcontainer_lifecycle.bats
# Expected: 6/6 VERDE
```

**Si alguno falla**: Debug y fix hasta VERDE

---

## 4. End-to-End Testing

### 4.1 Ejecutar E2E Tests

```bash
# Ejecutar workflow completo
bats tests/e2e/test_developer_workflow.bats
# Expected: 5/5 VERDE
```

**Si falla**: Verificar integracion completa componentes

---

## 5. Validacion Final

### 5.1 Checklist Pre-Deployment

**Ejecutar cada comando, verificar output VERDE**:

```bash
# 1. Todos unit tests
bats tests/unit/*.bats
# Expected: 76/76 VERDE

# 2. Todos integration tests
bats tests/integration/*.bats
# Expected: 24/24 VERDE

# 3. Todos E2E tests
bats tests/e2e/*.bats
# Expected: 5/5 VERDE

# 4. Coverage
kcov coverage/ bats tests/unit/*.bats
# Expected: 85%+ coverage

# 5. Validacion constitucion
./scripts/constitucion.sh --mode=manual
# Expected: Todas reglas OK

# 6. Pipeline CI local completo
./scripts/ci-local.sh
# Expected: All stages PASSED

# 7. Validacion DevContainer
./scripts/validate_devcontainer_env.sh
# Expected: X/X checks passed
```

**Si TODO pasa**: Deployment COMPLETO (TDD GREEN confirmado)

---

## 6. Deployment a Produccion

### 6.1 Procedimiento Deployment

**Seguir LLD_05_INSTALACION.md procedimientos**:

1. Pre-requisitos (yq, jq, nc)
2. Backup estado actual
3. Copiar archivos (scripts, configs)
4. Modificar scripts existentes
5. Instalar Git hooks
6. Validacion instalacion

**Referencia**: Ver LLD_05_INSTALACION.md seccion 2 para detalles completos

### 6.2 Deployment en Entornos

**Desarrollo (Local)**:
- Seguir procedimiento completo LLD_05
- Instalacion manual

**DevContainer**:
- Deployment AUTOMATICO via lifecycle hooks
- post_create.sh instala todo

**CI/CD Externo** (Futuro):
- Adaptar .ci-local.yaml a GitHub Actions / GitLab CI
- Fuera de scope actual

---

## 7. Rollback Procedure

**Si deployment falla en produccion**:

```bash
# Seguir LLD_05_INSTALACION.md seccion 4 (Rollback)
BACKUP_DIR=".backups/YYYYMMDD_HHMMSS"

# 1. Restaurar hooks
cp -r "$BACKUP_DIR/hooks_backup"/* .git/hooks/

# 2. Restaurar scripts modificados
cp "$BACKUP_DIR/install_hooks.sh.backup" scripts/install_hooks.sh
cp "$BACKUP_DIR/pre-push.backup" scripts/git-hooks/pre-push

# 3. Eliminar archivos nuevos
rm -f .constitucion.yaml .ci-local.yaml
rm -f scripts/constitucion.sh scripts/ci-local.sh
rm -f scripts/check_ui_api_coherence.sh
rm -f scripts/validate_devcontainer_env.sh
rm -f scripts/validate_constitution_schema.sh
rm -rf scripts/utils/

# 4. Verificar
git status
```

---

## 8. Tiempo Estimado Total

### 8.1 Desglose por Fase

| Fase | Componente | Tiempo Estimado |
|------|------------|-----------------|
| 5.1  | logging.sh | 30 min |
| 5.2  | validate_constitution_schema.sh | 1 hora |
| 5.3  | validate_devcontainer_env.sh | 1.5 horas |
| 5.4  | check_ui_api_coherence.sh | 1 hora |
| 5.5  | constitucion.sh | 4-6 horas |
| 5.6  | ci-local.sh | 4-6 horas |
| 5.7  | Modificar scripts existentes | 1 hora |
| 5.8  | Integrar DevContainer | 1.5 horas |
| 5.9  | Crear configs | 30 min |
| -    | Integration testing | 1 hora |
| -    | E2E testing | 30 min |
| -    | Validacion final | 1 hora |
| -    | Deployment produccion | 1 hora |

**TOTAL**: 18-22 horas

**Distribucion recomendada**: 3-4 dias (6 horas/dia)

---

## 9. Metricas de Exito

### 9.1 Definition of Done

**Sistema COMPLETO cuando**:

- [ ] Todos unit tests VERDE (76/76)
- [ ] Todos integration tests VERDE (24/24)
- [ ] Todos E2E tests VERDE (5/5)
- [ ] Coverage >= 85% componentes criticos
- [ ] constitucion.sh --mode=manual: OK
- [ ] ci-local.sh pipeline completo: PASSED
- [ ] validate_devcontainer_env.sh: OK
- [ ] Git hooks instalados y funcionando
- [ ] .constitucion.yaml validado
- [ ] .ci-local.yaml funcionando
- [ ] DevContainer lifecycle integrado
- [ ] Documentacion SDLC completa (Fases 1-6)
- [ ] Deployment produccion exitoso
- [ ] Validacion post-deployment OK

---

## 10. Troubleshooting Implementacion

### 10.1 Errores Comunes

**Error: "bats: command not found"**
```bash
# Solucion: instalar bats-core
npm install -g bats
# o
sudo apt-get install bats
```

**Error: Tests fallan inesperadamente**
```bash
# Debug: ejecutar con verbose
bats -t tests/unit/test_constitucion.bats

# Ver logs
DEBUG=1 ./scripts/constitucion.sh --mode=manual
```

**Error: Coverage bajo (<80%)**
```bash
# Identificar lineas no cubiertas
kcov --exclude-pattern=/usr coverage/ bats tests/unit/test_constitucion.bats
open coverage/constitucion.sh/index.html

# Agregar tests para lineas faltantes
```

### 10.2 Contacto Soporte

**Si bloqueado**:
- Revisar LLDs (detalles implementacion)
- Revisar TESTING_PLAN.md (specs tests)
- Consultar documentacion bats-core
- Revisar logs DEBUG=1

---

## 11. Proximos Pasos Post-Deployment

**Despues de FASE 5 completa**:

1. **FASE 6 - Maintenance Plan**: Optimizacion y refactoring
2. **Monitoreo**: Metricas constitucion violations
3. **Iteracion**: Agregar nuevas reglas si necesario
4. **Documentacion Usuario**: Guias para equipo desarrollo

---

## Referencias Cruzadas

**Desde Testing Plan**:
- TESTING_PLAN.md → Especificaciones tests

**Desde LLDs**:
- LLD_01_CONSTITUCION.md → Codigo constitucion.sh
- LLD_02_CI_LOCAL.md → Codigo ci-local.sh
- LLD_03_DEVCONTAINER.md → Integracion DevContainer
- LLD_04_SCRIPTS_HELPERS.md → Scripts helpers
- LLD_05_INSTALACION.md → Procedimientos deployment

**Hacia Maintenance**:
- DEPLOYMENT_PLAN.md → MAINTENANCE_PLAN.md (FASE 6)

---

**Metodologia**:
- TDD GREEN: Implementar codigo minimo para pasar tests
- Incremental: Componente por componente
- Test-Driven: Tests guian implementacion
- Rollback-Safe: Backups en cada paso

**Status**: DEPLOYMENT PLAN COMPLETO (TDD GREEN)
**Fecha**: 2025-11-13
**Autor**: SDLC Agent / DevOps Team

---

## Resumen Ejecutivo

**Deployment Path**:
```
Tests (RED) → Implementacion (GREEN) → Validacion → Deployment → Produccion
     ↓              ↓                      ↓             ↓            ↓
  FASE 4        FASE 5                  FASE 5        FASE 5      FASE 5
                (18-22h)
```

**Output Final**:
- Sistema automatizacion completo y funcional
- 105 tests pasando (VERDE)
- 85%+ coverage
- Deployment produccion exitoso
- Listo para FASE 6 (Mantenimiento)
