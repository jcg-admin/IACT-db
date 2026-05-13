---
title: LLD - Instalacion y Deployment
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: design
subfase: lld_instalacion
proyecto: IACT---project
parent_doc: LLD_00_OVERVIEW.md
status: in_progress
version: 1.0
---

# Low-Level Design: Instalacion y Deployment

**Issue**: IACT-AUTO-001
**Fase**: FASE 3 - DESIGN (Low-Level Design)
**Fecha**: 2025-11-13
**Parent**: LLD_00_OVERVIEW.md v1.0

---

## Proposito

Este documento especifica procedimientos completos para:
1. **Instalacion** del sistema de automatizacion en IACT
2. **Validacion** de instalacion correcta
3. **Rollback** en caso de problemas
4. **Troubleshooting** errores comunes

**Audiencia**: DevOps / Tech Lead ejecutando deployment

---

## 1. Pre-Requisitos

### 1.1 Dependencias Sistema

**Requeridas ANTES de instalacion**:

```bash
# Verificar Git
git --version
# Expected: git version 2.x

# Verificar Python
python3 --version
# Expected: Python 3.12.x

# Verificar Node.js
node --version
# Expected: v18.x

# Verificar jq (JSON processor)
jq --version
# Expected: jq-1.6 o superior

# Verificar yq (YAML processor)
yq --version
# Expected: yq version 4.x
```

**Instalacion dependencias faltantes**:
```bash
# yq (si falta)
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq

# jq (si falta)
sudo apt-get update && sudo apt-get install -y jq

# nc/netcat (si falta)
sudo apt-get install -y netcat
```

### 1.2 Verificacion Entorno

**Validar estructura proyecto**:
```bash
cd /path/to/IACT---project

# Verificar directorios clave
[ -d "ui" ] && echo "UI: OK" || echo "UI: MISSING"
[ -d "api/callcentersite" ] && echo "API: OK" || echo "API: MISSING"
[ -d "scripts" ] && echo "Scripts: OK" || echo "Scripts: MISSING"
[ -d ".git" ] && echo "Git: OK" || echo "Git: MISSING"
```

### 1.3 Permisos

**Usuario debe tener**:
- Permisos escritura en directorio proyecto
- Permisos crear/modificar Git hooks
- Permisos ejecutar scripts

```bash
# Verificar permisos
touch .test_permisos && rm .test_permisos && echo "Permisos: OK" || echo "Permisos: FAIL"
```

---

## 2. Procedimiento Instalacion Completa

### 2.1 PASO 1: Backup Estado Actual

**CRITICO**: Crear backup ANTES de cualquier cambio

```bash
# Crear directorio backups
mkdir -p .backups/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=".backups/$(date +%Y%m%d_%H%M%S)"

# Backup Git hooks existentes
if [ -d ".git/hooks" ]; then
    cp -r .git/hooks "$BACKUP_DIR/hooks_backup"
    echo "Backup hooks: $BACKUP_DIR/hooks_backup"
fi

# Backup scripts existentes (si van a modificarse)
cp scripts/install_hooks.sh "$BACKUP_DIR/install_hooks.sh.backup"
if [ -f "scripts/git-hooks/pre-push" ]; then
    cp scripts/git-hooks/pre-push "$BACKUP_DIR/pre-push.backup"
fi

echo "Backup completado: $BACKUP_DIR"
```

### 2.2 PASO 2: Copiar Archivo Constitucion

**Crear .constitucion.yaml en raiz proyecto**:

```bash
# Ver especificacion completa en LLD_01_CONSTITUCION.md

cat > .constitucion.yaml <<'EOF'
version: "1.0"
metadata:
  project: "IACT---project"
  created: "2025-11-13"
  updated: "2025-11-13"

principles:
  - id: P1_separation_concerns_ui_api
    name: "Separacion de Responsabilidades UI/API"
    description: "UI (React) y API (Django) deben estar desacoplados"
    rationale: "Arquitectura modular facilita mantenimiento y escalabilidad"

  - id: P2_dual_database_routing
    name: "Enrutamiento Dual de Bases de Datos"
    description: "PostgreSQL y MariaDB con database router correcto"
    rationale: "Evitar inconsistencias datos entre bases"

  - id: P3_no_emojis_in_code_docs
    name: "Sin Emojis en Codigo/Documentacion"
    description: "Solo texto (NOTA:, ADVERTENCIA:, etc.)"
    rationale: "Compatibilidad terminal, accesibilidad"

  - id: P4_conventional_commits
    name: "Conventional Commits"
    description: "Formato: type(scope): description"
    rationale: "Historial Git legible, changelog automatico"

  - id: P5_tdd_for_critical_features
    name: "TDD para Features Criticos"
    description: "Tests ANTES de implementacion"
    rationale: "Calidad codigo, menos bugs produccion"

rules:
  - id: R1_no_direct_push_main
    principle_id: P4_conventional_commits
    name: "No Push Directo a Main"
    severity: error
    scope: pre-push
    condition:
      type: branch_check
      protected_branches: ["main", "master"]
    action:
      type: block
    message: "ERROR: Push directo a main bloqueado. Usa feature branch + PR"

  - id: R2_no_emojis_anywhere
    principle_id: P3_no_emojis_in_code_docs
    name: "Sin Emojis en Archivos"
    severity: error
    scope: pre-commit
    condition:
      type: file_content_check
      pattern: "[\\x{1F600}-\\x{1F64F}\\x{1F300}-\\x{1F5FF}\\x{1F680}-\\x{1F6FF}\\x{2600}-\\x{26FF}\\x{2700}-\\x{27BF}]"
      file_types: ["*.md", "*.py", "*.js", "*.ts", "*.jsx", "*.tsx", "*.yaml", "*.yml"]
    action:
      type: block
    message: "ERROR: Emojis detectados. Usar texto (NOTA:, ADVERTENCIA:)"

  - id: R3_ui_api_coherence
    principle_id: P1_separation_concerns_ui_api
    name: "Coherencia Cambios UI/API"
    severity: warning
    scope: pre-push
    condition:
      type: custom_script
      script: "scripts/check_ui_api_coherence.sh"
    action:
      type: warn
    message: "ADVERTENCIA: Cambios API sin tests UI. Revisar coherencia"

  - id: R4_database_router_validated
    principle_id: P2_dual_database_routing
    name: "Database Router Validado"
    severity: error
    scope: pre-push
    condition:
      type: custom_script
      script: "scripts/validate_database_router.sh"
    action:
      type: block
    message: "ERROR: Database router invalido. Verificar configuracion"

  - id: R5_tests_must_pass
    principle_id: P5_tdd_for_critical_features
    name: "Tests Deben Pasar"
    severity: error
    scope: pre-push
    condition:
      type: custom_script
      script: "scripts/run_all_tests.sh"
    action:
      type: block
    message: "ERROR: Tests fallidos. Fix antes de push"

  - id: R6_devcontainer_compatibility
    principle_id: P1_separation_concerns_ui_api
    name: "Compatibilidad DevContainer"
    severity: warning
    scope: manual
    condition:
      type: custom_script
      script: "scripts/validate_devcontainer_env.sh"
    action:
      type: warn
    message: "ADVERTENCIA: Entorno DevContainer incompleto"

metrics:
  track_violations: true
  report_frequency: weekly
  violations_log: "logs/constitucion_violations.log"
EOF

echo "Archivo .constitucion.yaml creado"
```

### 2.3 PASO 3: Copiar Archivo CI Local

**Crear .ci-local.yaml en raiz proyecto**:

```bash
# Ver especificacion completa en LLD_02_CI_LOCAL.md

cat > .ci-local.yaml <<'EOF'
version: "1.0"
pipeline:
  name: "IACT Local CI"
  fail_fast: true
  parallel: true
  timeout: 600

stages:
  - name: lint
    parallel: true
    jobs:
      - name: eslint_ui
        condition: "ui_changed"
        command: "cd ui && npm run lint"
        timeout: 120

      - name: ruff_api
        condition: "api_changed"
        command: "cd api/callcentersite && ruff check ."
        timeout: 60

      - name: markdown_lint
        condition: "docs_changed"
        command: "npx markdownlint-cli2 'docs/**/*.md'"
        timeout: 60

  - name: test
    parallel: true
    jobs:
      - name: jest_ui
        condition: "ui_changed"
        command: "cd ui && npm run test -- --coverage --coverageThreshold='{\"global\":{\"branches\":80,\"functions\":80,\"lines\":80,\"statements\":80}}'"
        timeout: 300

      - name: pytest_api
        condition: "api_changed"
        command: "cd api/callcentersite && pytest --cov=. --cov-report=term --cov-fail-under=80"
        timeout: 300

  - name: build
    parallel: true
    jobs:
      - name: webpack_ui
        condition: "ui_changed"
        command: "cd ui && npm run build"
        timeout: 180

      - name: collectstatic_api
        condition: "api_changed"
        command: "cd api/callcentersite && python manage.py collectstatic --noinput"
        timeout: 60

  - name: validate
    parallel: true
    jobs:
      - name: security_scan
        command: "scripts/validate_security_config.sh"
        timeout: 120

      - name: database_router
        condition: "api_changed"
        command: "scripts/validate_database_router.sh"
        timeout: 30

      - name: constitution
        command: "scripts/constitucion.sh --mode=ci-local"
        timeout: 60

      - name: docs_structure
        condition: "docs_changed"
        command: "scripts/validate_docs_structure.sh"
        timeout: 30

notifications:
  on_success:
    message: "CI Local: All stages passed"
  on_failure:
    message: "CI Local: Failures detected, check logs"
  on_warning:
    message: "CI Local: Warnings detected, review recommended"
EOF

echo "Archivo .ci-local.yaml creado"
```

### 2.4 PASO 4: Crear Scripts Nuevos

**Crear directorio utils**:
```bash
mkdir -p scripts/utils
```

**Crear scripts/utils/logging.sh**:
```bash
# Ver codigo completo en LLD_04_SCRIPTS_HELPERS.md
# Copiar contenido completo de seccion 3.1
```

**Crear scripts/utils/colors.sh**:
```bash
# Ver codigo completo en LLD_04_SCRIPTS_HELPERS.md
# Copiar contenido completo de seccion 3.2
```

**Crear scripts/constitucion.sh**:
```bash
# Ver codigo completo en LLD_01_CONSTITUCION.md
# Copiar contenido completo de seccion 3
```

**Crear scripts/ci-local.sh**:
```bash
# Ver codigo completo en LLD_02_CI_LOCAL.md
# Copiar contenido completo de seccion 3
```

**Crear scripts helpers**:
```bash
# check_ui_api_coherence.sh
# validate_devcontainer_env.sh
# validate_constitution_schema.sh
# Ver LLD_04_SCRIPTS_HELPERS.md secciones 1.1, 1.2, 1.3
```

**Aplicar permisos**:
```bash
chmod +x scripts/utils/logging.sh
chmod +x scripts/constitucion.sh
chmod +x scripts/ci-local.sh
chmod +x scripts/check_ui_api_coherence.sh
chmod +x scripts/validate_devcontainer_env.sh
chmod +x scripts/validate_constitution_schema.sh
```

### 2.5 PASO 5: Modificar Scripts Existentes

**Modificar scripts/install_hooks.sh**:
```bash
# Agregar despues de linea 63
# Ver LLD_04_SCRIPTS_HELPERS.md seccion 2.1
```

**Modificar scripts/git-hooks/pre-push**:
```bash
# Agregar antes de tests
# Ver LLD_04_SCRIPTS_HELPERS.md seccion 2.2
```

### 2.6 PASO 6: Modificar DevContainer Scripts

**Modificar infrastructure/devcontainer/scripts/post_create.sh**:
```bash
# Agregar al final del archivo
# Ver LLD_03_DEVCONTAINER.md seccion 2.1
```

**Modificar infrastructure/devcontainer/scripts/post_start.sh**:
```bash
# Agregar al final del archivo
# Ver LLD_03_DEVCONTAINER.md seccion 2.2
```

### 2.7 PASO 7: Instalar Git Hooks

**Ejecutar instalador**:
```bash
cd /path/to/IACT---project
./scripts/install_hooks.sh
```

**Output esperado**:
```
Installing Git Hooks
====================

[pre-commit] Installing...
  Installed: /path/to/.git/hooks/pre-commit
[commit-msg] Installing...
  Installed: /path/to/.git/hooks/commit-msg
[pre-push] Installing...
  Installed: /path/to/.git/hooks/pre-push
[pre-rebase] Installing...
  Installed: /path/to/.git/hooks/pre-rebase

====================
INSTALLATION COMPLETE
====================
Installed: 4 hook(s)
Skipped: 0 hook(s)

Sistema de Constitucion:
  - Archivo:       .constitucion.yaml
  - Validador:     scripts/constitucion.sh
  - Integracion:   pre-push hook
  - Validar:       ./scripts/constitucion.sh --mode=manual
```

---

## 3. Validacion Instalacion

### 3.1 Checklist Validacion

**Ejecutar cada comando, verificar output**:

```bash
# 1. Validar schema constitucion
./scripts/validate_constitution_schema.sh .constitucion.yaml
# Expected: [OK] Schema valido

# 2. Validar entorno DevContainer
./scripts/validate_devcontainer_env.sh
# Expected: Validacion completa: X/X checks pasaron

# 3. Test constitucion manual
./scripts/constitucion.sh --mode=manual
# Expected: [OK] Todas las reglas validadas

# 4. Verificar Git hooks instalados
ls -lah .git/hooks/pre-commit .git/hooks/pre-push .git/hooks/commit-msg .git/hooks/pre-rebase
# Expected: 4 archivos ejecutables

# 5. Test pre-commit hook (dry-run)
git add .constitucion.yaml
git commit -m "test: validar hooks" --dry-run
# Expected: pre-commit ejecuta, commit-msg valida formato
```

### 3.2 Test Completo End-to-End

**Ejecutar pipeline CI local**:
```bash
./scripts/ci-local.sh
```

**Output esperado** (si todo OK):
```
[INFO] IACT Local CI Pipeline
[INFO] Detectando cambios...
[INFO] Stage: lint
  [OK] eslint_ui: PASSED
  [OK] ruff_api: PASSED
[INFO] Stage: test
  [OK] jest_ui: PASSED (coverage: 85%)
  [OK] pytest_api: PASSED (coverage: 82%)
[INFO] Stage: build
  [OK] webpack_ui: PASSED
  [OK] collectstatic_api: PASSED
[INFO] Stage: validate
  [OK] security_scan: PASSED
  [OK] constitution: PASSED
[OK] Pipeline COMPLETO: 8/8 jobs passed
```

---

## 4. Rollback Procedure

### 4.1 Rollback Completo

**Si instalacion falla, revertir**:

```bash
# 1. Restaurar Git hooks
BACKUP_DIR=".backups/YYYYMMDD_HHMMSS"  # Usar directorio backup real
cp -r "$BACKUP_DIR/hooks_backup"/* .git/hooks/
echo "Hooks restaurados"

# 2. Restaurar scripts modificados
cp "$BACKUP_DIR/install_hooks.sh.backup" scripts/install_hooks.sh
cp "$BACKUP_DIR/pre-push.backup" scripts/git-hooks/pre-push
echo "Scripts restaurados"

# 3. Eliminar archivos nuevos
rm -f .constitucion.yaml
rm -f .ci-local.yaml
rm -f scripts/constitucion.sh
rm -f scripts/ci-local.sh
rm -f scripts/check_ui_api_coherence.sh
rm -f scripts/validate_devcontainer_env.sh
rm -f scripts/validate_constitution_schema.sh
rm -rf scripts/utils/
echo "Archivos nuevos eliminados"

# 4. Verificar estado
git status
echo "Rollback completado"
```

### 4.2 Rollback Parcial

**Si solo 1 componente falla**:

**Ejemplo: Rollback solo constitucion**:
```bash
rm -f .constitucion.yaml
rm -f scripts/constitucion.sh
# Revertir modificaciones pre-push hook
cp "$BACKUP_DIR/pre-push.backup" scripts/git-hooks/pre-push
```

---

## 5. Troubleshooting

### 5.1 Error: "yq: command not found"

**Problema**: yq no instalado
**Solucion**:
```bash
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq
yq --version
```

### 5.2 Error: "Permission denied" al ejecutar scripts

**Problema**: Scripts no ejecutables
**Solucion**:
```bash
chmod +x scripts/*.sh
chmod +x scripts/utils/*.sh
chmod +x .git/hooks/*
```

### 5.3 Error: "PostgreSQL connection failed"

**Problema**: Base datos no disponible
**Solucion**:
```bash
# Verificar servicios
docker-compose ps

# Reiniciar contenedores
docker-compose restart postgres mariadb

# Verificar puertos
nc -z localhost 5432 && echo "PostgreSQL: OK"
nc -z localhost 3306 && echo "MariaDB: OK"
```

### 5.4 Error: "Constitution validation failed"

**Problema**: .constitucion.yaml invalido
**Solucion**:
```bash
# Validar sintaxis YAML
yq eval '.' .constitucion.yaml

# Validar schema
./scripts/validate_constitution_schema.sh .constitucion.yaml

# Ver errores especificos en output
```

### 5.5 Error: "CI Local timeout"

**Problema**: Jobs tardan demasiado
**Solucion**:
```bash
# Aumentar timeout en .ci-local.yaml
# Cambiar pipeline.timeout de 600 a 900

# O ejecutar stages individuales
./scripts/ci-local.sh --stage=lint
./scripts/ci-local.sh --stage=test
```

---

## 6. Instalacion en DevContainer

### 6.1 Instalacion Automatica

**Si usando DevContainer**:

La instalacion es AUTOMATICA via lifecycle hooks:

1. **onCreateCommand**: Instala dependencias (yq, jq)
2. **postCreateCommand**:
   - Valida constitucion
   - Instala Git hooks
   - Verifica entorno
3. **postStartCommand**:
   - Quick health check
   - Recordatorios sistema activo

**NO requiere pasos manuales** (ver LLD_03_DEVCONTAINER.md)

### 6.2 Validacion Post-Create

**Verificar en DevContainer**:
```bash
# Abrir terminal en DevContainer
# Verificar instalacion
ls -la .git/hooks/
cat .constitucion.yaml
./scripts/validate_devcontainer_env.sh
```

---

## 7. Instalacion en CI/CD Externo (Futuro)

**NOTA**: Esta implementacion es para LOCAL development

**Para GitHub Actions / GitLab CI**:
- Adaptar .ci-local.yaml a syntax CI especifico
- Convertir scripts Bash a CI steps
- Agregar caching dependencies
- Fuera de scope FASE 3

---

## 8. Metricas Post-Instalacion

### 8.1 Metricas a Monitorear

**Semanalmente**:
```bash
# Revisar log violaciones
cat logs/constitucion_violations.log

# Contar violaciones por regla
grep -c "R1_no_direct_push_main" logs/constitucion_violations.log
grep -c "R2_no_emojis_anywhere" logs/constitucion_violations.log
```

**Mensualmente**:
- Tiempo promedio pipeline CI local
- Tasa aprobacion pre-push (% sin warnings)
- Reglas mas violadas (candidatas a revision)

---

## 9. Actualizaciones Futuras

### 9.1 Agregar Nueva Regla Constitucion

**Procedimiento**:
1. Editar .constitucion.yaml (agregar regla en `rules:`)
2. Validar schema: `./scripts/validate_constitution_schema.sh`
3. Test manual: `./scripts/constitucion.sh --mode=manual`
4. Commit cambio

**Ejemplo**:
```yaml
# Agregar en .constitucion.yaml rules:
  - id: R7_nueva_regla
    principle_id: P1_separation_concerns_ui_api
    name: "Nueva Regla Ejemplo"
    severity: warning
    scope: pre-commit
    condition:
      type: file_content_check
      pattern: "TODO:"
    action:
      type: warn
    message: "ADVERTENCIA: TODOs pendientes detectados"
```

### 9.2 Modificar Script Existente

**Procedimiento**:
1. Backup script: `cp scripts/X.sh scripts/X.sh.backup`
2. Editar script
3. Validar sintaxis: `bash -n scripts/X.sh`
4. Test manual
5. Commit cambio

---

## 10. Checklist Final

**Instalacion completada cuando**:

- [ ] Dependencias instaladas (yq, jq, nc)
- [ ] Backup estado actual creado
- [ ] .constitucion.yaml copiado y validado
- [ ] .ci-local.yaml copiado
- [ ] Scripts nuevos creados (constitucion.sh, ci-local.sh, helpers)
- [ ] Scripts existentes modificados (install_hooks.sh, pre-push)
- [ ] DevContainer scripts modificados (post_create.sh, post_start.sh)
- [ ] Permisos aplicados (chmod +x)
- [ ] Git hooks instalados (4 hooks)
- [ ] Validacion schema constitucion: PASSED
- [ ] Validacion entorno DevContainer: PASSED
- [ ] Test constitucion manual: PASSED
- [ ] Test CI local completo: PASSED
- [ ] Test end-to-end commit+push: PASSED

**Si todos los checks pasan**: INSTALACION COMPLETA

---

## Referencias Cruzadas

**Implementacion detallada**:
- LLD_01_CONSTITUCION.md: Codigo constitucion.sh
- LLD_02_CI_LOCAL.md: Codigo ci-local.sh
- LLD_03_DEVCONTAINER.md: Modificaciones DevContainer
- LLD_04_SCRIPTS_HELPERS.md: Scripts auxiliares

**Hacia Testing** (FASE 4):
- Procedimientos testing instalacion
- Tests validacion end-to-end

**Hacia Deployment** (FASE 5):
- Implementacion real siguiendo este LLD
- Deployment en entornos dev/staging/prod

---

**Metodologia**:
- Self-Consistency: Validacion multiple en cada paso
- Rollback Safety: Backups antes de cambios
- Incremental Verification: Test cada componente antes de siguiente

**Status**: LLD_05 COMPLETO
**Fecha**: 2025-11-13
**Autor**: SDLC Agent / DevOps Team
