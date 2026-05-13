---
title: Testing Plan - Sistema Automatizacion
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: testing
subfase: test_plan_red
proyecto: IACT---project
parent_doc: LLD_00_OVERVIEW.md
status: in_progress
version: 1.0
---

# Testing Plan: Sistema Automatizacion (TDD RED)

**Issue**: IACT-AUTO-001
**Fase**: FASE 4 - TESTING (TDD RED)
**Fecha**: 2025-11-13
**Parent**: LLD_00_OVERVIEW.md v1.0

---

## Proposito

Este documento especifica **todos los tests** que deben escribirse ANTES de implementar el sistema de automatizacion (enfoque TDD RED).

**TDD Workflow**:
1. **RED**: Escribir tests (este documento) - FASE 4
2. **GREEN**: Implementar para pasar tests - FASE 5
3. **REFACTOR**: Optimizar codigo - FASE 6

**Audiencia**: Desarrollador escribiendo tests

---

## 1. Testing Strategy

### 1.1 Niveles de Testing

**Piramide Testing**:
```
           /\
          /E2E\        End-to-End (5%)
         /------\
        /Integration\ Integration (25%)
       /------------\
      /   Unit Tests \ Unit (70%)
     /----------------\
```

**Distribucion esperada**:
- **Unit Tests**: 70% - Tests aislados funciones individuales
- **Integration Tests**: 25% - Tests interaccion componentes
- **End-to-End Tests**: 5% - Tests flujos completos usuario

### 1.2 Herramientas Testing

**Bash Scripts**:
- Framework: `bats-core` (Bash Automated Testing System)
- Mocking: `bats-mock`, `stub` functions
- Assertions: `bats-assert`, `bats-support`

**Python Scripts** (si aplicable futuro):
- Framework: `pytest`
- Coverage: `pytest-cov`

**Coverage Target**:
- Scripts criticos (constitucion.sh, ci-local.sh): 85%+
- Scripts helpers: 80%+
- Utilidades (logging.sh): 90%+

### 1.3 Estructura Tests

```
tests/
├── unit/
│   ├── test_constitucion.bats          # Unit tests constitucion.sh
│   ├── test_ci_local.bats              # Unit tests ci-local.sh
│   ├── test_check_ui_api_coherence.bats
│   ├── test_validate_devcontainer_env.bats
│   ├── test_validate_constitution_schema.bats
│   └── test_logging.bats               # Unit tests logging.sh
├── integration/
│   ├── test_hooks_integration.bats     # Git hooks + constitucion
│   ├── test_ci_pipeline.bats           # CI local full pipeline
│   └── test_devcontainer_lifecycle.bats
├── e2e/
│   └── test_developer_workflow.bats    # Complete dev workflow
├── fixtures/
│   ├── .constitucion.valid.yaml
│   ├── .constitucion.invalid.yaml
│   ├── .ci-local.valid.yaml
│   └── sample_commits/
└── helpers/
    ├── setup_test_env.sh               # Test environment setup
    └── teardown_test_env.sh            # Cleanup
```

---

## 2. Unit Tests - scripts/constitucion.sh

### 2.1 Test Suite: constitucion.sh

**Archivo test**: `tests/unit/test_constitucion.bats`

#### 2.1.1 Test: Validar .constitucion.yaml existe

```bash
@test "constitucion.sh fails if .constitucion.yaml missing" {
  # Setup: remove .constitucion.yaml
  rm -f .constitucion.yaml

  # Execute
  run ./scripts/constitucion.sh --mode=manual

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "ERROR" ]]
  [[ "$output" =~ ".constitucion.yaml" ]]
}
```

#### 2.1.2 Test: Validar sintaxis YAML

```bash
@test "constitucion.sh detects invalid YAML syntax" {
  # Setup: create invalid YAML
  cat > .constitucion.yaml <<EOF
version: "1.0
principles:  # Missing closing quote above
  - id: P1
EOF

  # Execute
  run ./scripts/constitucion.sh --mode=manual

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "sintaxis YAML" ]]
}
```

#### 2.1.3 Test: Regla R1 - No push directo main

```bash
@test "constitucion.sh R1 blocks push to main branch" {
  # Setup: switch to main
  git checkout -b main 2>/dev/null || git checkout main

  # Execute
  run ./scripts/constitucion.sh --mode=pre-push

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "R1_no_direct_push_main" ]]
  [[ "$output" =~ "ERROR" ]]
}
```

#### 2.1.4 Test: Regla R2 - Deteccion emojis

```bash
@test "constitucion.sh R2 detects emojis in staged files" {
  # Setup: create file with emoji
  echo "Test file with emoji ✓" > test_emoji.md
  git add test_emoji.md

  # Execute
  run ./scripts/constitucion.sh --mode=pre-commit

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "R2_no_emojis_anywhere" ]]
  [[ "$output" =~ "ERROR" ]]

  # Cleanup
  git reset HEAD test_emoji.md
  rm -f test_emoji.md
}
```

#### 2.1.5 Test: Regla R3 - UI/API coherence (warning)

```bash
@test "constitucion.sh R3 warns on API change without UI tests" {
  # Setup: mock check_ui_api_coherence.sh returning incoherent
  stub check_ui_api_coherence.sh 'exit 1'

  # Execute
  run ./scripts/constitucion.sh --mode=pre-push

  # Assert: warning, not error (exit 2, not 1)
  [ "$status" -eq 2 ]
  [[ "$output" =~ "R3_ui_api_coherence" ]]
  [[ "$output" =~ "ADVERTENCIA" ]]

  # Cleanup
  unstub check_ui_api_coherence.sh
}
```

#### 2.1.6 Test: Todas reglas pasan

```bash
@test "constitucion.sh succeeds when all rules pass" {
  # Setup: valid constitution, feature branch, no emojis
  cp tests/fixtures/.constitucion.valid.yaml .constitucion.yaml
  git checkout -b feature/test-branch

  # Mock helpers to succeed
  stub check_ui_api_coherence.sh 'exit 0'
  stub validate_database_router.sh 'exit 0'
  stub run_all_tests.sh 'exit 0'
  stub validate_devcontainer_env.sh 'exit 0'

  # Execute
  run ./scripts/constitucion.sh --mode=pre-push

  # Assert
  [ "$status" -eq 0 ]
  [[ "$output" =~ "OK" ]]

  # Cleanup
  unstub check_ui_api_coherence.sh
  unstub validate_database_router.sh
  unstub run_all_tests.sh
  unstub validate_devcontainer_env.sh
  git checkout -
}
```

#### 2.1.7 Test: Exit codes correctos

```bash
@test "constitucion.sh exit codes: 0=success, 1=error, 2=warning" {
  # Test exit 0
  # ... (similar to 2.1.6)

  # Test exit 1 (severity=error)
  # ... (similar to 2.1.3)

  # Test exit 2 (severity=warning)
  # ... (similar to 2.1.5)
}
```

**Total unit tests constitucion.sh**: 15-20 tests

---

## 3. Unit Tests - scripts/ci-local.sh

### 3.1 Test Suite: ci-local.sh

**Archivo test**: `tests/unit/test_ci_local.bats`

#### 3.1.1 Test: Validar .ci-local.yaml existe

```bash
@test "ci-local.sh fails if .ci-local.yaml missing" {
  rm -f .ci-local.yaml

  run ./scripts/ci-local.sh

  [ "$status" -eq 1 ]
  [[ "$output" =~ "ERROR" ]]
  [[ "$output" =~ ".ci-local.yaml" ]]
}
```

#### 3.1.2 Test: Smart detection - solo UI cambio

```bash
@test "ci-local.sh runs only UI jobs when UI changed" {
  # Setup: mock git diff to show UI changes only
  function git() {
    if [[ "$*" =~ "diff --name-only" ]]; then
      echo "ui/src/App.jsx"
    else
      command git "$@"
    fi
  }
  export -f git

  # Execute
  run ./scripts/ci-local.sh

  # Assert: UI jobs executed, API jobs skipped
  [[ "$output" =~ "eslint_ui: PASSED" ]]
  [[ "$output" =~ "jest_ui: PASSED" ]]
  [[ "$output" =~ "ruff_api: SKIPPED" ]]
  [[ "$output" =~ "pytest_api: SKIPPED" ]]
}
```

#### 3.1.3 Test: Ejecucion paralela stages

```bash
@test "ci-local.sh executes parallel jobs simultaneously" {
  # Setup: mock jobs with delays
  stub eslint 'sleep 2 && exit 0'
  stub ruff 'sleep 2 && exit 0'

  # Execute and measure time
  start=$(date +%s)
  run ./scripts/ci-local.sh --stage=lint
  end=$(date +%s)
  duration=$((end - start))

  # Assert: should take ~2s (parallel), not 4s (sequential)
  [ "$duration" -lt 3 ]
}
```

#### 3.1.4 Test: Fail-fast behavior

```bash
@test "ci-local.sh stops on first error when fail_fast=true" {
  # Setup: mock first job to fail, second to succeed
  stub eslint 'exit 1'
  stub ruff 'exit 0'

  # Execute
  run ./scripts/ci-local.sh --stage=lint

  # Assert: stopped after first failure
  [ "$status" -eq 1 ]
  [[ "$output" =~ "eslint_ui: FAILED" ]]
  [[ ! "$output" =~ "ruff_api" ]]  # Should not run
}
```

#### 3.1.5 Test: Coverage threshold enforcement

```bash
@test "ci-local.sh fails if coverage below 80%" {
  # Setup: mock jest to return coverage 75%
  stub jest 'echo "Coverage: 75%"; exit 1'

  # Execute
  run ./scripts/ci-local.sh --stage=test --job=jest_ui

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "coverage" ]]
}
```

#### 3.1.6 Test: JSON report generation

```bash
@test "ci-local.sh generates JSON report" {
  run ./scripts/ci-local.sh

  # Assert: report file created
  [ -f "/tmp/ci-local-report.json" ]

  # Assert: valid JSON
  jq empty /tmp/ci-local-report.json

  # Assert: contains expected fields
  local status=$(jq -r '.status' /tmp/ci-local-report.json)
  [[ "$status" =~ ^(success|failure)$ ]]
}
```

**Total unit tests ci-local.sh**: 15-20 tests

---

## 4. Unit Tests - Helper Scripts

### 4.1 Test Suite: check_ui_api_coherence.sh

**Archivo test**: `tests/unit/test_check_ui_api_coherence.bats`

#### 4.1.1 Test: Detecta API change sin UI test

```bash
@test "check_ui_api_coherence.sh detects API change without UI tests" {
  # Setup: mock git diff
  function git() {
    if [[ "$*" =~ "api/callcentersite" ]]; then
      echo "api/callcentersite/views.py"
    else
      echo ""
    fi
  }
  export -f git

  # Execute
  run ./scripts/check_ui_api_coherence.sh main

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "incoherente" ]]
}
```

#### 4.1.2 Test: Coherencia OK con UI tests

```bash
@test "check_ui_api_coherence.sh passes when UI tests present" {
  # Setup: mock git diff showing both API and UI tests changes
  function git() {
    if [[ "$*" =~ "api/callcentersite" ]]; then
      echo "api/callcentersite/views.py"
    elif [[ "$*" =~ "ui/src/__tests__" ]]; then
      echo "ui/src/__tests__/api.test.js"
    fi
  }
  export -f git

  # Execute
  run ./scripts/check_ui_api_coherence.sh main

  # Assert
  [ "$status" -eq 0 ]
  [[ "$output" =~ "coherente" ]]
}
```

**Total unit tests check_ui_api_coherence.sh**: 5-8 tests

---

### 4.2 Test Suite: validate_devcontainer_env.sh

**Archivo test**: `tests/unit/test_validate_devcontainer_env.bats`

#### 4.2.1 Test: Detecta PostgreSQL no disponible

```bash
@test "validate_devcontainer_env.sh fails if PostgreSQL down" {
  # Setup: mock nc to fail for port 5432
  function nc() {
    if [[ "$*" =~ "5432" ]]; then
      return 1
    fi
    return 0
  }
  export -f nc

  # Execute
  run ./scripts/validate_devcontainer_env.sh

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "PostgreSQL.*FAIL" ]]
}
```

#### 4.2.2 Test: Detecta Python version incorrecta

```bash
@test "validate_devcontainer_env.sh warns on Python != 3.12.x" {
  # Setup: mock python3 to return 3.11
  function python3() {
    echo "Python 3.11.5"
  }
  export -f python3

  # Execute
  run ./scripts/validate_devcontainer_env.sh

  # Assert
  [ "$status" -eq 1 ]
  [[ "$output" =~ "ADVERTENCIA.*3.12" ]]
}
```

#### 4.2.3 Test: Todas validaciones pasan

```bash
@test "validate_devcontainer_env.sh succeeds when all checks pass" {
  # Setup: mock all tools to succeed
  function nc() { return 0; }
  function python3() { echo "Python 3.12.6"; }
  function node() { echo "v18.19.0"; }
  function command() { return 0; }  # All dependencies present

  export -f nc python3 node command

  # Execute
  run ./scripts/validate_devcontainer_env.sh

  # Assert
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Validacion completa" ]]
}
```

**Total unit tests validate_devcontainer_env.sh**: 8-10 tests

---

### 4.3 Test Suite: validate_constitution_schema.sh

**Archivo test**: `tests/unit/test_validate_constitution_schema.bats`

#### 4.3.1 Test: Detecta sintaxis YAML invalida

```bash
@test "validate_constitution_schema.sh fails on invalid YAML" {
  cp tests/fixtures/.constitucion.invalid.yaml .constitucion.yaml

  run ./scripts/validate_constitution_schema.sh .constitucion.yaml

  [ "$status" -eq 1 ]
  [[ "$output" =~ "Sintaxis YAML invalida" ]]
}
```

#### 4.3.2 Test: Detecta campos requeridos faltantes

```bash
@test "validate_constitution_schema.sh detects missing required fields" {
  # Setup: YAML without 'version'
  cat > .constitucion.yaml <<EOF
principles:
  - id: P1
rules:
  - id: R1
EOF

  run ./scripts/validate_constitution_schema.sh .constitucion.yaml

  [ "$status" -eq 1 ]
  [[ "$output" =~ "version.*faltante" ]]
}
```

#### 4.3.3 Test: Detecta severity invalido

```bash
@test "validate_constitution_schema.sh detects invalid severity" {
  # Setup: rule with severity=critical (should be error/warning)
  cat > .constitucion.yaml <<EOF
version: "1.0"
principles:
  - id: P1
    name: "Test"
rules:
  - id: R1
    severity: critical
EOF

  run ./scripts/validate_constitution_schema.sh .constitucion.yaml

  [ "$status" -eq 1 ]
  [[ "$output" =~ "severity.*error.*warning" ]]
}
```

**Total unit tests validate_constitution_schema.sh**: 6-8 tests

---

### 4.4 Test Suite: logging.sh

**Archivo test**: `tests/unit/test_logging.bats`

#### 4.4.1 Test: log_info formatea correctamente

```bash
@test "log_info outputs formatted INFO message" {
  source scripts/utils/logging.sh

  run log_info "Test message"

  [[ "$output" =~ "[INFO] Test message" ]]
}
```

#### 4.4.2 Test: log_error envia a stderr

```bash
@test "log_error outputs to stderr" {
  source scripts/utils/logging.sh

  run log_error "Error message"

  # bats captures both stdout and stderr in $output
  [[ "$output" =~ "[ERROR] Error message" ]]
}
```

#### 4.4.3 Test: log_debug solo si DEBUG=1

```bash
@test "log_debug outputs only when DEBUG=1" {
  source scripts/utils/logging.sh

  # Without DEBUG
  DEBUG=0
  run log_debug "Debug message"
  [ -z "$output" ]

  # With DEBUG
  DEBUG=1
  run log_debug "Debug message"
  [[ "$output" =~ "[DEBUG] Debug message" ]]
}
```

**Total unit tests logging.sh**: 8-10 tests

---

## 5. Integration Tests

### 5.1 Test Suite: Git Hooks + Constitucion

**Archivo test**: `tests/integration/test_hooks_integration.bats`

#### 5.1.1 Test: pre-commit bloquea emojis

```bash
@test "pre-commit hook blocks commit with emojis" {
  # Setup: install hooks
  ./scripts/install_hooks.sh

  # Create file with emoji
  echo "Test ✓" > test.md
  git add test.md

  # Execute
  run git commit -m "test: add file"

  # Assert: blocked by pre-commit
  [ "$status" -eq 1 ]
  [[ "$output" =~ "emoji" ]]

  # Cleanup
  git reset HEAD test.md
  rm -f test.md
}
```

#### 5.1.2 Test: commit-msg valida conventional commits

```bash
@test "commit-msg hook blocks non-conventional commit" {
  ./scripts/install_hooks.sh

  # Create valid change
  echo "# Test" > README.md
  git add README.md

  # Execute with invalid message
  run git commit -m "Invalid commit message"

  # Assert: blocked by commit-msg
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Conventional Commits" ]]
}
```

#### 5.1.3 Test: pre-push invoca constitucion.sh

```bash
@test "pre-push hook invokes constitucion.sh" {
  ./scripts/install_hooks.sh

  # Mock constitucion.sh to log invocation
  stub constitucion.sh 'echo "constitucion.sh invoked"; exit 0'

  # Execute
  run git push --dry-run

  # Assert
  [[ "$output" =~ "constitucion.sh invoked" ]]

  # Cleanup
  unstub constitucion.sh
}
```

**Total integration tests hooks**: 8-10 tests

---

### 5.2 Test Suite: CI Pipeline Integration

**Archivo test**: `tests/integration/test_ci_pipeline.bats`

#### 5.2.1 Test: Pipeline completo sin errores

```bash
@test "CI pipeline executes all stages successfully" {
  # Setup: valid codebase
  cp tests/fixtures/.ci-local.valid.yaml .ci-local.yaml

  # Mock all jobs to succeed
  # ...

  # Execute
  run ./scripts/ci-local.sh

  # Assert: all stages passed
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Stage: lint.*PASSED" ]]
  [[ "$output" =~ "Stage: test.*PASSED" ]]
  [[ "$output" =~ "Stage: build.*PASSED" ]]
  [[ "$output" =~ "Stage: validate.*PASSED" ]]
}
```

#### 5.2.2 Test: Pipeline aborta en stage lint failed

```bash
@test "CI pipeline aborts if lint stage fails" {
  # Setup: mock eslint to fail
  stub eslint 'exit 1'

  # Execute
  run ./scripts/ci-local.sh

  # Assert: aborted after lint, no test stage
  [ "$status" -eq 1 ]
  [[ "$output" =~ "lint.*FAILED" ]]
  [[ ! "$output" =~ "Stage: test" ]]
}
```

**Total integration tests CI pipeline**: 6-8 tests

---

### 5.3 Test Suite: DevContainer Lifecycle

**Archivo test**: `tests/integration/test_devcontainer_lifecycle.bats`

#### 5.3.1 Test: post_create.sh instala hooks

```bash
@test "post_create.sh installs Git hooks automatically" {
  # Setup: clean hooks
  rm -rf .git/hooks/*

  # Execute
  run infrastructure/devcontainer/scripts/post_create.sh

  # Assert: hooks installed
  [ -f ".git/hooks/pre-commit" ]
  [ -f ".git/hooks/pre-push" ]
  [ -x ".git/hooks/pre-commit" ]
}
```

#### 5.3.2 Test: post_create.sh valida constitucion

```bash
@test "post_create.sh validates constitution on setup" {
  # Setup: invalid constitution
  cp tests/fixtures/.constitucion.invalid.yaml .constitucion.yaml

  # Execute
  run infrastructure/devcontainer/scripts/post_create.sh

  # Assert: validation warning shown
  [[ "$output" =~ "constitucion.*invalida" ]]
}
```

**Total integration tests DevContainer**: 5-6 tests

---

## 6. End-to-End Tests

### 6.1 Test Suite: Developer Workflow Completo

**Archivo test**: `tests/e2e/test_developer_workflow.bats`

#### 6.1.1 Test: Workflow feature branch completo

```bash
@test "E2E: Complete feature development workflow" {
  # 1. Create feature branch
  git checkout -b feature/test-e2e

  # 2. Make code change (UI)
  echo "export const Test = () => <div>Test</div>;" > ui/src/Test.jsx
  git add ui/src/Test.jsx

  # 3. Commit (pre-commit + commit-msg should run)
  run git commit -m "feat(ui): add test component"
  [ "$status" -eq 0 ]

  # 4. Run CI local
  run ./scripts/ci-local.sh
  [ "$status" -eq 0 ]

  # 5. Push (pre-push should run constitucion)
  run git push --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" =~ "constitucion" ]]

  # Cleanup
  git checkout -
  git branch -D feature/test-e2e
}
```

#### 6.1.2 Test: Workflow bloquea violation constitucion

```bash
@test "E2E: Workflow blocks constitution violation" {
  # 1. Create feature branch
  git checkout -b feature/bad-commit

  # 2. Add file with emoji (violation R2)
  echo "Test ✓" > test.md
  git add test.md

  # 3. Commit should be BLOCKED by pre-commit
  run git commit -m "test: add file"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "emoji" ]]

  # Cleanup
  git reset HEAD test.md
  rm -f test.md
  git checkout -
  git branch -D feature/bad-commit
}
```

**Total E2E tests**: 3-5 tests

---

## 7. Test Fixtures

### 7.1 Fixtures Requeridos

**Crear en `tests/fixtures/`**:

#### .constitucion.valid.yaml
```yaml
version: "1.0"
principles:
  - id: P1_test
    name: "Test Principle"
rules:
  - id: R1_test
    principle_id: P1_test
    name: "Test Rule"
    severity: error
    scope: pre-commit
```

#### .constitucion.invalid.yaml
```yaml
version: "1.0
# Missing quote above - invalid YAML
```

#### .ci-local.valid.yaml
```yaml
version: "1.0"
pipeline:
  name: "Test CI"
stages:
  - name: lint
```

---

## 8. Test Environment Setup

### 8.1 Setup Helper Script

**Archivo**: `tests/helpers/setup_test_env.sh`

```bash
#!/usr/bin/env bash
# Setup test environment

setup_test_repo() {
    # Create temp Git repo
    export TEST_REPO=$(mktemp -d)
    cd "$TEST_REPO"
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"

    # Copy scripts
    mkdir -p scripts
    cp -r "$PROJECT_ROOT/scripts/"* scripts/

    # Copy fixtures
    cp -r "$PROJECT_ROOT/tests/fixtures" .
}

teardown_test_repo() {
    cd /
    rm -rf "$TEST_REPO"
}
```

---

## 9. Coverage Requirements

### 9.1 Coverage Targets por Archivo

**Scripts criticos**:
- constitucion.sh: 85%+ line coverage
- ci-local.sh: 85%+ line coverage

**Scripts helpers**:
- check_ui_api_coherence.sh: 80%+
- validate_devcontainer_env.sh: 80%+
- validate_constitution_schema.sh: 80%+

**Utilidades**:
- logging.sh: 90%+

### 9.2 Medicion Coverage

**Herramienta**: `kcov` (Bash code coverage)

```bash
# Install kcov
sudo apt-get install kcov

# Run tests with coverage
kcov --exclude-pattern=/usr coverage/ bats tests/unit/test_constitucion.bats

# View report
open coverage/index.html
```

---

## 10. Ejecucion Tests

### 10.1 Ejecutar Todos los Tests

```bash
# Install bats-core
npm install -g bats

# Run all tests
bats tests/unit/*.bats
bats tests/integration/*.bats
bats tests/e2e/*.bats

# Or use helper
./scripts/run_all_tests.sh --include-automation
```

### 10.2 Ejecutar Tests Especificos

```bash
# Only unit tests
bats tests/unit/test_constitucion.bats

# Specific test
bats tests/unit/test_constitucion.bats --filter "R1 blocks push"

# With verbose output
bats -t tests/unit/test_constitucion.bats
```

---

## 11. CI Integration

### 11.1 Agregar a .ci-local.yaml

**Modificacion**: Agregar stage `test_automation` a .ci-local.yaml

```yaml
stages:
  # ... existing stages

  - name: test_automation
    parallel: false
    jobs:
      - name: unit_tests_automation
        command: "bats tests/unit/*.bats"
        timeout: 120

      - name: integration_tests_automation
        command: "bats tests/integration/*.bats"
        timeout: 180

      - name: coverage_automation
        command: "kcov coverage/ bats tests/unit/*.bats && [ $(grep -oP 'covered\":\K[0-9.]+' coverage/coverage.json) -ge 80 ]"
        timeout: 180
```

---

## 12. Resumen Testing Plan

### 12.1 Tests Totales Estimados

**Unit Tests**:
- constitucion.sh: 15-20 tests
- ci-local.sh: 15-20 tests
- check_ui_api_coherence.sh: 5-8 tests
- validate_devcontainer_env.sh: 8-10 tests
- validate_constitution_schema.sh: 6-8 tests
- logging.sh: 8-10 tests
**Subtotal Unit**: 57-76 tests

**Integration Tests**:
- Hooks integration: 8-10 tests
- CI pipeline: 6-8 tests
- DevContainer lifecycle: 5-6 tests
**Subtotal Integration**: 19-24 tests

**End-to-End Tests**:
- Developer workflow: 3-5 tests

**TOTAL**: 79-105 tests

### 12.2 Tiempo Estimado Implementacion

- Escribir unit tests: 6-8 horas
- Escribir integration tests: 3-4 horas
- Escribir E2E tests: 1-2 horas
- Setup fixtures y helpers: 1-2 horas
- Setup coverage: 1 hora

**Total estimado**: 12-17 horas

---

## 13. Checklist Testing (TDD RED)

**Completar ANTES de implementacion**:

- [ ] Instalar bats-core y dependencias
- [ ] Crear estructura `tests/` (unit, integration, e2e, fixtures, helpers)
- [ ] Escribir todos unit tests constitucion.sh (15-20 tests)
- [ ] Escribir todos unit tests ci-local.sh (15-20 tests)
- [ ] Escribir todos unit tests helpers (19-26 tests)
- [ ] Escribir todos unit tests logging.sh (8-10 tests)
- [ ] Escribir todos integration tests (19-24 tests)
- [ ] Escribir todos E2E tests (3-5 tests)
- [ ] Crear fixtures (.constitucion.valid/invalid, .ci-local.valid)
- [ ] Crear setup_test_env.sh y teardown_test_env.sh
- [ ] Configurar kcov para coverage
- [ ] Ejecutar todos tests - **TODOS DEBEN FALLAR** (TDD RED)
- [ ] Documentar tests en este archivo
- [ ] Commit testing plan

**Cuando todos los tests estan escritos y FALLAN**: Proceder a FASE 5 (Implementacion)

---

## Referencias Cruzadas

**Desde LLDs**:
- LLD_01_CONSTITUCION.md → Tests constitucion.sh
- LLD_02_CI_LOCAL.md → Tests ci-local.sh
- LLD_03_DEVCONTAINER.md → Tests DevContainer integration
- LLD_04_SCRIPTS_HELPERS.md → Tests helper scripts

**Hacia Deployment** (FASE 5):
- Implementar scripts para pasar todos estos tests
- TDD GREEN: codigo minimo para pasar tests
- REFACTOR: optimizar codigo manteniendo tests verdes

---

**Metodologia**:
- TDD RED: Escribir tests PRIMERO (este documento)
- Auto-CoT: Descomposicion tests por componente
- Self-Consistency: Multiple assertions por test
- Coverage-Driven: 80-90% coverage target

**Status**: TESTING PLAN COMPLETO (TDD RED)
**Fecha**: 2025-11-13
**Autor**: SDLC Agent / DevOps Team

---

## Proximos Pasos

1. Implementar todos los tests especificados
2. Verificar que TODOS los tests FALLEN (TDD RED confirmado)
3. Commit tests
4. **Continuar a FASE 5 (Deployment Plan - TDD GREEN)**
