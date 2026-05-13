---
title: Plan de Remediación: Shell Scripts by Domain (DDD)
date: 2025-11-13
domain: general
status: active
---

# Plan de Remediación: Shell Scripts by Domain (DDD)

**Issue ID**: REMEDIATION-SHELL-SCRIPTS-001
**Fecha**: 2025-11-13
**Estado**: ACTIVO
**Metodología**: Domain-Driven Design (DDD) + Auto-CoT + TDD

---

## 1. Resumen Ejecutivo

### Análisis Realizado
- **Scripts analizados**: 145
- **Score promedio**: 92.0/100
- **Issues totales**: 503
- **Dominios identificados**: 17
- **Prioridad global**: Media-Alta

### Distribución por Tipo

| Categoría | Cantidad | Severidad | % Total |
|-----------|----------|-----------|---------|
| Constitutional Rule 3 | 116 | 21 CRITICAL, 95 HIGH | 23% |
| Security (Command Injection) | 387 | 387 HIGH | 77% |
| Quality (Code Smells) | 0 | - | 0% |
| **TOTAL** | **503** | - | **100%** |

### Approach: Domain-Driven Design

Este plan organiza la remediación por **dominios funcionales**, permitiendo que cada equipo/dominio remedie sus propios scripts de forma independiente, siguiendo los principios de DDD.

**Ventajas**:
- Ownership claro por dominio
- Remediación paralela (sin dependencias entre dominios)
- PRs independientes por dominio
- Testing aislado por dominio

---

## 2. Dominios Prioritarios (Auto-CoT Analysis)

### Cluster P0: High-Impact Domains (> 50 issues)

| Dominio | Scripts | Issues | Score | Critical | Equipo Responsable |
|---------|---------|--------|-------|----------|---------------------|
| infrastructure/vagrant | 9 | 69 | 83.8 | 3 | Infrastructure Team |
| infrastructure/cpython | 17 | 67 | 90.2 | 0 | Infrastructure Team |
| infrastructure/devcontainer | 9 | 60 | 87.8 | 3 | Infrastructure Team |
| scripts/validation | 18 | 56 | 93.2 | 0 | QA Team |
| infrastructure/other | 17 | 52 | 92.1 | 0 | Infrastructure Team |
| scripts/root | 17 | 51 | 92.6 | 2 | DevOps Team |

**Total P0**: 87 scripts, 355 issues (70% del total)

### Cluster P1: Medium-Impact Domains (21-50 issues)

| Dominio | Scripts | Issues | Score | Critical | Equipo Responsable |
|---------|---------|--------|-------|----------|---------------------|
| scripts/git-hooks | 8 | 45 | 85.2 | 1 | DevOps Team |
| scripts/coding | 8 | 39 | 91.5 | 2 | Development Team |

**Total P1**: 16 scripts, 84 issues (17% del total)

### Cluster P2: Low-Impact Domains (11-20 issues)

| Dominio | Scripts | Issues | Score | Critical | Equipo Responsable |
|---------|---------|--------|-------|----------|---------------------|
| infrastructure/box | 8 | 19 | 94.4 | 6 | Infrastructure Team |
| scripts/ci | 14 | 18 | 96.3 | 0 | CI/CD Team |
| scripts/workflows | 6 | 11 | 94.5 | 0 | GitHub Actions Team |

**Total P2**: 28 scripts, 48 issues (10% del total)

### Cluster P3: Minimal-Impact Domains (<= 10 issues)

| Dominio | Scripts | Issues | Score | Equipo Responsable |
|---------|---------|--------|-------|---------------------|
| infrastructure/disaster_recovery | 4 | 5 | 96.2 | Infrastructure Team |
| docs/scripts | 2 | 4 | 97.0 | Documentation Team |
| scripts/templates | 3 | 3 | 97.7 | DevOps Team |
| infrastructure/cassandra | 3 | 2 | 98.7 | Infrastructure Team |
| scripts/lib | 1 | 1 | 99.0 | DevOps Team |
| scripts/examples | 1 | 1 | 99.0 | Documentation Team |

**Total P3**: 14 scripts, 16 issues (3% del total)

---

## 3. Estrategia de Remediación por Dominio

### Principio DDD: Bounded Contexts

Cada dominio es un **bounded context** independiente con:
- Ownership claro
- Branch independiente
- Suite de tests aislada
- PR y merge independientes

### Workflow por Dominio

```bash
# 1. Crear branch del dominio
git checkout -b fix/shell-remediation-<DOMAIN>

# 2. Remediar scripts del dominio
for script in <DOMAIN_SCRIPTS>; do
    # Fix constitutional issues
    # Fix security issues
    # Run tests
done

# 3. Re-analizar dominio
python3 << EOF
from scripts.coding.ai.agents.quality.shell_analysis_agent import ShellScriptAnalysisAgent
agent = ShellScriptAnalysisAgent()
result = agent.execute({
    "script_path": "<DOMAIN_PATH>",
    "output_dir": "docs/scripts/analisis/<DOMAIN>"
})
EOF

# 4. Commit y push
git add <DOMAIN_PATH>
git commit -m "fix(shell/<domain>): remediate all scripts in <DOMAIN>

- Fixed X constitutional violations
- Fixed Y security issues
- Average score: A.B -> C.D

Traceability: REMEDIATION-SHELL-SCRIPTS-001"

git push -u origin fix/shell-remediation-<DOMAIN>

# 5. Create PR
gh pr create --title "fix(shell): Remediate <DOMAIN> scripts" \
             --body "### Summary
- Scripts fixed: N
- Issues resolved: M
- Score improvement: A.B -> C.D

### Checklist
- [x] All scripts have set -euo pipefail
- [x] All variables quoted
- [x] Tests pass
- [x] Re-analysis confirms fixes"
```

---

## 4. Planes por Dominio (P0 Only)

### 4.1 infrastructure/vagrant (P0 - Priority 1)

**Responsable**: Infrastructure Team
**Scripts**: 9
**Issues**: 69 (22 Constitutional, 47 Security)
**Score actual**: 83.8
**Target score**: 95+

**Top Scripts a Remediar**:
1. `system_prepare.sh` (66/100) - 18 issues
   - Missing `set -e` (CRITICAL)
   - 17 unquoted variables (HIGH)

2. `mariadb_install.sh` - 13 issues
   - 3 silent `|| true` patterns
   - 10 unquoted variables

3. `postgres_install.sh` - 11 issues
   - 2 silent `|| true` patterns
   - 9 unquoted variables

**Plan de Acción**:
```bash
# Fase 1: Fix CRITICAL (1 día)
- Add 'set -euo pipefail' to system_prepare.sh

# Fase 2: Fix Security HIGH (2 días)
- Quote all 47 variables across 9 scripts
- Pattern: $var -> "$var", ${var} -> "${var}"

# Fase 3: Fix Constitutional HIGH (1 día)
- Replace 19 '|| true' with explicit error handling

# Total: 4 días
```

**Acceptance Criteria**:
- [ ] Score: 83.8 -> 95+
- [ ] Issues: 69 -> < 5
- [ ] Tests: All vagrant tests pass
- [ ] Re-analysis: CRITICAL=0, HIGH<5

---

### 4.2 infrastructure/cpython (P0 - Priority 2)

**Responsable**: Infrastructure Team
**Scripts**: 17
**Issues**: 67 (13 Constitutional, 54 Security)
**Score actual**: 90.2
**Target score**: 96+

**Top Scripts a Remediar**:
1. `retry_handler.sh` (70/100) - 13 issues
2. `state_manager.sh` (74/100) - 10 issues
3. `network.sh` (70/100) - 10 issues

**Plan de Acción**:
```bash
# Fase 1: Fix Constitutional (1 día)
- Replace 13 '|| true' with explicit error handling
- Add logging for all error paths

# Fase 2: Fix Security (2 días)
- Quote 54 variables across 17 scripts
- Special attention to network.sh (network commands)

# Total: 3 días
```

**Acceptance Criteria**:
- [ ] Score: 90.2 -> 96+
- [ ] Issues: 67 -> < 5
- [ ] Tests: cpython build tests pass

---

### 4.3 infrastructure/devcontainer (P0 - Priority 3)

**Responsable**: Infrastructure Team
**Scripts**: 9
**Issues**: 60 (30 Constitutional, 30 Security)
**Score actual**: 87.8
**Target score**: 95+

**Top Scripts a Remediar**:
1. `on_create.sh` (71/100) - 16 issues
   - Missing `set -e` (CRITICAL)
   - 15 security issues

2. `python.sh` (69/100) - 12 issues
3. `update_content.sh` - 12 issues

**Plan de Acción**:
```bash
# Fase 1: Fix CRITICAL (1 día)
- Add 'set -euo pipefail' to 3 scripts without it

# Fase 2: Fix Security + Constitutional (2 días)
- Quote 30 variables
- Replace 27 '|| true' patterns

# Total: 3 días
```

**Acceptance Criteria**:
- [ ] Score: 87.8 -> 95+
- [ ] Issues: 60 -> < 5
- [ ] Tests: devcontainer creation succeeds

---

### 4.4 scripts/validation (P0 - Priority 4)

**Responsable**: QA Team
**Scripts**: 18
**Issues**: 56 (17 Constitutional, 39 Security)
**Score actual**: 93.2
**Target score**: 97+

**Top Scripts a Remediar**:
1. `validate_shell_constitution.sh` (65/100) - 19 issues
   - Ironically, the validator itself has issues!

2. `run_all_compliance_checks.sh` - 7 issues
3. `run_all_security_checks.sh` - 6 issues

**Plan de Acción**:
```bash
# Fase 1: Fix validator scripts (2 días)
- Critical: Fix validate_shell_constitution.sh first
- This will help validate other fixes

# Fase 2: Fix remaining validation scripts (1 día)
- Quote 39 variables
- Replace 17 '|| true' patterns

# Total: 3 días
```

**Acceptance Criteria**:
- [ ] Score: 93.2 -> 97+
- [ ] Issues: 56 -> < 3
- [ ] All validation scripts validate themselves

---

### 4.5 infrastructure/other (P0 - Priority 5)

**Responsable**: Infrastructure Team
**Scripts**: 17
**Issues**: 52 (8 Constitutional, 44 Security)
**Score actual**: 92.1
**Target score**: 96+

**Plan de Acción**:
```bash
# Fase 1: Fix Security (2 días)
- Quote 44 variables across infrastructure scripts

# Fase 2: Fix Constitutional (1 día)
- Replace 8 '|| true' patterns

# Total: 3 días
```

---

### 4.6 scripts/root (P0 - Priority 6)

**Responsable**: DevOps Team
**Scripts**: 17
**Issues**: 51 (9 Constitutional, 42 Security)
**Score actual**: 92.6
**Target score**: 96+

**Top Scripts a Remediar**:
1. `validate_security_config.sh` (69/100) - 14 issues
2. `validate_critical_restrictions.sh` (75/100) - 9 issues
3. `run_all_tests.sh` - 8 issues

**Plan de Acción**:
```bash
# Fase 1: Fix CRITICAL (1 día)
- Add 'set -euo pipefail' to 2 scripts

# Fase 2: Fix Security + Constitutional (2 días)
- Quote 42 variables
- Replace 7 '|| true' patterns

# Total: 3 días
```

---

## 5. Timeline Global

### Semana 1: P0 Domains (Paralelo)

| Día | Infrastructure Team | QA Team | DevOps Team |
|-----|---------------------|---------|-------------|
| 1-4 | vagrant (4 días) | - | - |
| 5-7 | cpython (3 días) | validation (3 días) | root (3 días) |

### Semana 2: P0 Domains (Continuación)

| Día | Infrastructure Team | QA Team | DevOps Team |
|-----|---------------------|---------|-------------|
| 8-10 | devcontainer (3 días) | - | - |
| 11-12 | other (3 días) | - | - |

### Semana 3: P1 y P2 Domains

| Día | Development Team | CI/CD Team | GitHub Actions Team |
|-----|------------------|------------|---------------------|
| 13-14 | coding (2 días) | ci (1 día) | workflows (1 día) |
| 15-16 | - | - | git-hooks (2 días) |

### Semana 4: P3 Domains + Final Validation

| Día | Actividad |
|-----|-----------|
| 17-18 | Remediar P3 domains |
| 19 | Re-análisis global completo |
| 20 | Retrospective y documentación |

---

## 6. Testing Strategy por Dominio

### infrastructure/vagrant
```bash
cd infrastructure/vagrant
./bootstrap.sh --dry-run
pytest tests/bootstrap_test.sh
```

### infrastructure/cpython
```bash
./scripts/infrastructure/cpython/scripts/validate_build.sh
```

### infrastructure/devcontainer
```bash
# Test creation
.devcontainer/scripts/on_create.sh --test-mode
```

### scripts/validation
```bash
# Run all validation scripts on themselves
./scripts/validation/quality/validate_shell_constitution.sh scripts/validation/
```

### scripts/root
```bash
# Run tests
./scripts/run_all_tests.sh
```

---

## 7. Success Metrics por Dominio

| Dominio | Score Baseline | Score Target | Issues Baseline | Issues Target |
|---------|----------------|--------------|-----------------|---------------|
| infrastructure/vagrant | 83.8 | 95+ | 69 | < 5 |
| infrastructure/cpython | 90.2 | 96+ | 67 | < 5 |
| infrastructure/devcontainer | 87.8 | 95+ | 60 | < 5 |
| scripts/validation | 93.2 | 97+ | 56 | < 3 |
| infrastructure/other | 92.1 | 96+ | 52 | < 5 |
| scripts/root | 92.6 | 96+ | 51 | < 5 |

**Global Metrics**:
- Average Score: 92.0 -> 98.0+
- Total Issues: 503 -> < 50
- CRITICAL Issues: 21 -> 0
- Security HIGH: 387 -> < 20

---

## 8. Risk Mitigation

### Risk 1: Domain Dependencies
**Probabilidad**: Baja
**Mitigación**: Los dominios están bien aislados, sin dependencias entre scripts de diferentes dominios

### Risk 2: Conflictos de Merge
**Probabilidad**: Muy Baja
**Mitigación**: Cada dominio tiene sus propios archivos, no hay overlaps

### Risk 3: Breaking Changes por Dominio
**Probabilidad**: Media
**Mitigación**:
- Tests exhaustivos por dominio antes de merge
- Dry-run mode en scripts de infrastructure
- Staging deployment primero

---

## 9. Herramientas Automatizadas

### 9.1 Script de Remediación por Dominio

```bash
#!/bin/bash
# scripts/remediation/remediate_domain.sh

set -euo pipefail

DOMAIN=$1
OUTPUT_DIR="docs/scripts/analisis/${DOMAIN//\//_}"

# 1. Analyze domain
python3 -c "
from scripts.coding.ai.agents.quality.shell_analysis_agent import ShellScriptAnalysisAgent
from pathlib import Path

agent = ShellScriptAnalysisAgent(config={'analysis_depth': 'standard'})

# Find domain path
if '$DOMAIN'.startswith('infrastructure/'):
    domain_path = 'infrastructure/' + '$DOMAIN'.split('/')[1]
elif '$DOMAIN'.startswith('scripts/'):
    domain_path = 'scripts/' if '$DOMAIN' == 'scripts/root' else 'scripts/' + '$DOMAIN'.split('/')[1]
else:
    domain_path = '$DOMAIN'

result = agent.execute({
    'script_path': domain_path,
    'output_dir': '$OUTPUT_DIR'
})

print(f'Domain: $DOMAIN')
print(f'Scripts: {result.data[\"summary\"][\"total_scripts\"]}')
print(f'Score: {result.data[\"summary\"][\"average_score\"]:.1f}')
print(f'Issues: {result.data[\"summary\"][\"total_violations\"] + result.data[\"summary\"][\"total_security_issues\"]}')
"

# 2. Extract scripts to fix
jq -r '.issues.constitutional[] | .file' "${OUTPUT_DIR}/SUMMARY.json" | sort -u > "${OUTPUT_DIR}/scripts_to_fix.txt"

echo "Scripts to fix saved in: ${OUTPUT_DIR}/scripts_to_fix.txt"
```

### 9.2 Verificación Post-Remediación

```bash
#!/bin/bash
# scripts/remediation/verify_domain.sh

set -euo pipefail

DOMAIN=$1
BASELINE_SCORE=$2
TARGET_SCORE=$3

# Re-analyze
python3 -c "..." # Similar to above

# Compare
if [ "$CURRENT_SCORE" -ge "$TARGET_SCORE" ]; then
    echo "SUCCESS: Domain $DOMAIN meets target score"
    exit 0
else
    echo "FAIL: Domain $DOMAIN score $CURRENT_SCORE < target $TARGET_SCORE"
    exit 1
fi
```

---

## 10. Próximos Pasos Inmediatos

### Para Infrastructure Team:
```bash
# Start with vagrant (highest issues, lowest score)
git checkout -b fix/shell-remediation-infrastructure-vagrant
cd infrastructure/vagrant

# Fix system_prepare.sh first (18 issues, CRITICAL)
vim scripts/system_prepare.sh
# ... fixes ...

pytest tests/
```

### Para QA Team:
```bash
# Start with validation domain
git checkout -b fix/shell-remediation-scripts-validation
cd scripts/validation

# Fix validate_shell_constitution.sh first (irony!)
vim quality/validate_shell_constitution.sh
# ... fixes ...

./quality/validate_shell_constitution.sh .
```

### Para DevOps Team:
```bash
# Start with root scripts
git checkout -b fix/shell-remediation-scripts-root
cd scripts

# Fix validate_security_config.sh first
vim validate_security_config.sh
# ... fixes ...

./run_all_tests.sh
```

---

## 11. Referencias

- **Análisis por Dominios**: `docs/scripts/analisis/DOMAIN_ANALYSIS.json`
- **Análisis General**: `docs/scripts/analisis/SUMMARY.json`
- **Shell Constitution**: `docs/SHELL_SCRIPTS_CONSTITUTION.md`
- **Agent con DDD**: `scripts/coding/ai/agents/quality/shell_analysis_agent.py`
- **Issue Tracking**: FEATURE-SHELL-ANALYSIS-001
- **Remediation Tracking**: REMEDIATION-SHELL-SCRIPTS-001

---

**Trazabilidad**: REMEDIATION-SHELL-SCRIPTS-001, FEATURE-SHELL-ANALYSIS-001
**Metodología**: DDD (Domain-Driven Design), Auto-CoT, TDD
**Aprobación**: Pendiente de revisión por domain owners
**Última Actualización**: 2025-11-13
