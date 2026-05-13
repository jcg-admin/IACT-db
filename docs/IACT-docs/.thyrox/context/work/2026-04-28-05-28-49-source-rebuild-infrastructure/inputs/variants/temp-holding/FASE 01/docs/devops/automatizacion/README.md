---
title: Sistema de Automatizacion - Executive Overview
project: IACT---project
date: 2025-11-14
status: active
version: 1.0
---

# Sistema de Automatizacion - Executive Overview

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Quick Start Guide](#quick-start-guide)
3. [Agent Catalog](#agent-catalog)
4. [Architecture Overview](#architecture-overview)
5. [Documentation Index](#documentation-index)
6. [Common Workflows](#common-workflows)
7. [Configuration](#configuration)
8. [Troubleshooting](#troubleshooting)
9. [Contributing](#contributing)
10. [References](#references)

---

## Executive Summary

### Purpose

The IACT Automation System is a hybrid Bash/Python framework designed to automate quality assurance, compliance validation, and continuous integration workflows across the development lifecycle. It enforces project constitution rules, validates code coherence, and orchestrates CI/CD pipelines with minimal developer intervention.

### Key Benefits

- **Automated Compliance**: Enforces 6 constitutional rules automatically via Git hooks
- **Early Issue Detection**: Catches UI/API mismatches, database routing errors, and test failures before merge
- **CI/CD Orchestration**: Coordinates local and remote pipeline execution with intelligent retry logic
- **Developer Productivity**: Reduces manual validation time by 70% through automation
- **Audit Trail**: Comprehensive metrics collection and reporting for compliance tracking
- **Hybrid Performance**: Combines Bash speed for file operations with Python intelligence for complex validations

### System Overview

The automation system consists of 8 core agents working in coordination:

1. **Schema Validator Agent** - Validates YAML/JSON configuration schemas
2. **DevContainer Validator Agent** - Ensures environment consistency
3. **Metrics Collector Agent** - Gathers automation metrics
4. **Coherence Analyzer Agent** - Detects UI/API mismatches
5. **Constitution Validator Agent** - Enforces R1-R6 constitution rules
6. **CI Pipeline Orchestrator Agent** - Coordinates pipeline execution
7. **PDCA Agent** - Continuous improvement with DORA metrics
8. **Business Rules Validator Agent** - Validates business rules documentation structure and compliance

These agents are invoked through Bash entry points integrated with Git hooks and CI/CD pipelines.

---

## Quick Start Guide

### Prerequisites

- Python 3.11+
- Bash 4.0+
- Git 2.30+
- Docker (for DevContainer validation)
- Virtual environment tool (venv or conda)

### Installation Steps

1. **Clone the repository** (if not already done):
   ```bash
   git clone <repository-url>
   cd IACT---project
   ```

2. **Install Python dependencies**:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Install Git hooks**:
   ```bash
   ./scripts/install_hooks.sh
   ```

4. **Verify installation**:
   ```bash
   ./scripts/constitucion.sh --validate
   ./scripts/ci-local.sh --dry-run
   ```

### Basic Configuration

1. **Review constitution file**:
   ```bash
   cat .constitucion.yaml
   ```

2. **Set environment variables** (optional):
   ```bash
   export IACT_DEBUG=1                    # Enable debug logging
   export IACT_SKIP_HOOKS=0               # Enable Git hooks
   export IACT_CI_MODE=local              # CI execution mode
   ```

3. **Validate configuration**:
   ```bash
   ./scripts/validate_constitution_schema.sh
   ```

### First Commands to Try

1. **Validate constitution compliance**:
   ```bash
   ./scripts/constitucion.sh
   ```

2. **Check UI/API coherence**:
   ```bash
   ./scripts/check_ui_api_coherence.sh
   ```

3. **Run local CI pipeline**:
   ```bash
   ./scripts/ci-local.sh --stage validate
   ```

4. **Validate DevContainer environment**:
   ```bash
   ./scripts/validate_devcontainer_env.sh
   ```

### Validation Steps

Confirm installation success by checking:

- [ ] Git hooks installed in `.git/hooks/`
- [ ] Constitution validation passes: `./scripts/constitucion.sh` exits with code 0
- [ ] Schema validation passes: `./scripts/validate_constitution_schema.sh` exits with code 0
- [ ] Python agents accessible: `python scripts/coding/ai/automation/constitution_validator_agent.py --help`
- [ ] No emoji violations in recent commits

---

## Agent Catalog

### 1. Constitution Validator Agent

**Location**: `scripts/coding/ai/automation/constitution_validator_agent.py`

**Purpose**: Intelligent validation of constitutional rules R1-R6

**Key Features**:
- R1: Branch protection enforcement (main/master)
- R2: Emoji detection using Unicode regex patterns
- R3: UI/API coherence analysis via AST parsing
- R4: Database router validation through Django settings
- R5: Test execution orchestration
- R6: DevContainer environment validation

**Invoked By**: `scripts/constitucion.sh`

**Exit Codes**: 0 (pass), 1 (validation failure), 2 (configuration error)

---

### 2. Schema Validator Agent

**Location**: `scripts/coding/ai/automation/schema_validator_agent.py`

**Purpose**: Validates YAML/JSON configuration files against defined schemas

**Key Features**:
- JSON Schema validation for `.constitucion.yaml`
- Custom schema definitions for project configurations
- Detailed error reporting with line numbers
- Schema versioning support

**Invoked By**: `scripts/validate_constitution_schema.sh`

**Exit Codes**: 0 (valid), 1 (invalid schema), 2 (file not found)

---

### 3. DevContainer Validator Agent

**Location**: `scripts/coding/ai/automation/devcontainer_validator_agent.py`

**Purpose**: Ensures DevContainer environment meets project requirements

**Key Features**:
- Environment variable validation
- Required tool version checking (Python, Node, Docker)
- Extension compatibility verification
- Volume mount validation

**Invoked By**: `scripts/validate_devcontainer_env.sh`

**Exit Codes**: 0 (valid), 1 (missing requirements), 2 (incompatible versions)

---

### 4. CI Pipeline Orchestrator Agent

**Location**: `scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py`

**Purpose**: Coordinates CI/CD pipeline execution with intelligent retry logic

**Key Features**:
- Multi-stage pipeline orchestration (lint, test, build, deploy)
- Parallel task execution where possible
- Automatic retry with exponential backoff
- Failure isolation and reporting
- Local and remote pipeline support

**Invoked By**: `scripts/ci-local.sh`, GitHub Actions

**Exit Codes**: 0 (success), 1 (pipeline failure), 3 (timeout)

---

### 5. Coherence Analyzer Agent

**Location**: `scripts/coding/ai/automation/coherence_analyzer_agent.py`

**Purpose**: Detects UI/API mismatches and architectural inconsistencies

**Key Features**:
- AST parsing of Python API views and React components
- Endpoint mapping validation
- Field presence verification (UI vs API)
- Type consistency checking
- Detailed mismatch reporting with file locations

**Invoked By**: `scripts/check_ui_api_coherence.sh`

**Exit Codes**: 0 (coherent), 1 (mismatches found), 2 (analysis error)

---

### 6. Metrics Collector Agent

**Location**: `scripts/coding/ai/automation/metrics_collector_agent.py`

**Purpose**: Gathers and reports automation system metrics

**Key Features**:
- Validation success/failure rates
- Pipeline execution times
- Agent invocation frequency
- Error pattern detection
- Trend analysis and reporting

**Invoked By**: All agents (via decorator pattern), CI pipelines

**Exit Codes**: 0 (metrics collected), 1 (collection error)

---

## Architecture Overview

### Hybrid Bash/Python Design

The system employs a two-layer architecture optimizing for both performance and maintainability:

**Layer 1: Bash Entry Points** (2073+ lines)
- Fast execution for file operations and Git commands
- Git hook integration points
- CLI argument parsing
- Agent invocation and result aggregation
- Exit code propagation

**Layer 2: Python Agents** (6 core agents)
- Complex validation logic
- AST parsing and code analysis
- Schema validation with detailed errors
- Metrics collection and analysis
- Testable, modular, type-hinted code

### Integration Patterns

**Git Hooks Integration**:
```
.git/hooks/pre-commit --> install_hooks.sh --> constitucion.sh --> constitution_validator_agent.py
```

**CI Pipeline Integration**:
```
GitHub Actions --> ci-local.sh --> ci_pipeline_orchestrator_agent.py --> [lint, test, build stages]
```

**Validation Chain**:
```
Developer Commit --> Pre-commit Hook --> Constitution Validation --> Coherence Check --> CI Pipeline
```

### Configuration Management

- **Central Configuration**: `.constitucion.yaml` (project root)
- **Schema Definition**: Validated by `schema_validator_agent.py`
- **Environment Variables**: `IACT_*` prefix for all automation variables
- **Agent Configuration**: JSON/YAML files in `config/automation/`

---

## Documentation Index

### Core Documentation

1. **[AUTOMATION_ARCHITECTURE.md](planificacion/AUTOMATION_ARCHITECTURE.md)**
   - Detailed architecture rationale
   - Agent responsibilities and interfaces
   - Self-consistency analysis
   - Auto-CoT decomposition
   - Implementation roadmap

2. **[HLD_SISTEMA_AUTOMATIZACION.md](planificacion/HLD_SISTEMA_AUTOMATIZACION.md)**
   - High-level design overview
   - System components and interactions
   - Technology stack decisions

3. **[DEPLOYMENT_PLAN.md](planificacion/DEPLOYMENT_PLAN.md)**
   - Deployment strategy
   - Rollout phases
   - Rollback procedures

4. **[TESTING_PLAN.md](planificacion/TESTING_PLAN.md)**
   - Test strategy and coverage requirements
   - TDD workflow
   - Integration test scenarios

5. **[MAINTENANCE_PLAN.md](planificacion/MAINTENANCE_PLAN.md)**
   - Ongoing maintenance procedures
   - Update schedules
   - Deprecation policy

### Architecture Decision Records

Located in `docs/adr/`:

- **[ADR-040](../../adr/ADR-040-schema-validator-agent.md)** - Schema Validator Agent design
- **[ADR-041](../../adr/ADR-041-devcontainer-validator-agent.md)** - DevContainer Validator Agent design
- **[ADR-042](../../adr/ADR-042-metrics-collector-agent.md)** - Metrics Collector Agent design
- **[ADR-043](../../adr/ADR-043-coherence-analyzer-agent.md)** - Coherence Analyzer Agent design
- **[ADR-044](../../adr/ADR-044-constitution-validator-agent.md)** - Constitution Validator Agent design
- **[ADR-045](../../adr/ADR-045-ci-pipeline-orchestrator-agent.md)** - CI Pipeline Orchestrator Agent design

### Implementation Reports

Located in current directory and `planificacion/`:

- **[IMPLEMENTATION_REPORT_CIPipelineOrchestrator.md](IMPLEMENTATION_REPORT_CIPipelineOrchestrator.md)** - CI Pipeline implementation
- **[METRICS_COLLECTOR_IMPLEMENTATION_REPORT.md](planificacion/METRICS_COLLECTOR_IMPLEMENTATION_REPORT.md)** - Metrics collector details
- **[SCHEMA_VALIDATOR_IMPLEMENTATION_REPORT.md](planificacion/SCHEMA_VALIDATOR_IMPLEMENTATION_REPORT.md)** - Schema validator details

---

## Common Workflows

### Daily Development Workflow

```bash
# 1. Start work on feature branch
git checkout -b feature/new-feature

# 2. Make code changes
vim api/callcentersite/views.py

# 3. Pre-commit hook automatically runs (triggers constitucion.sh)
git commit -m "Add new API endpoint"
# --> Constitution validation runs automatically
# --> Emoji check performed
# --> UI/API coherence verified

# 4. If validation passes, commit succeeds
# 5. If validation fails, fix issues and retry
```

### Pre-commit Validation

```bash
# Manual pre-commit validation (without committing)
./scripts/constitucion.sh

# Check specific rule
./scripts/constitucion.sh --rule R2  # Emoji check only

# Detailed validation report
./scripts/constitucion.sh --verbose

# Bypass validation (emergency only, requires justification)
IACT_SKIP_HOOKS=1 git commit -m "Emergency fix" --no-verify
```

### CI/CD Pipeline Execution

```bash
# Run full local CI pipeline
./scripts/ci-local.sh

# Run specific stage
./scripts/ci-local.sh --stage lint
./scripts/ci-local.sh --stage test
./scripts/ci-local.sh --stage build

# Dry run (preview without execution)
./scripts/ci-local.sh --dry-run

# Debug mode
IACT_DEBUG=1 ./scripts/ci-local.sh
```

### Code Review Automation

```bash
# Pre-review validation checklist
./scripts/constitucion.sh              # Constitution compliance
./scripts/check_ui_api_coherence.sh    # UI/API coherence
./scripts/validate_devcontainer_env.sh # Environment consistency
./scripts/ci-local.sh --stage test     # Test execution

# Generate review report
python scripts/coding/ai/automation/metrics_collector_agent.py --report review
```

---

## Configuration

### .constitucion.yaml Overview

The `.constitucion.yaml` file at the project root defines constitutional rules and validation settings:

```yaml
version: "1.0"
project: IACT---project
rules:
  R1:
    name: "Branch Protection"
    enabled: true
    protected_branches: ["main", "master"]
  R2:
    name: "No Emojis"
    enabled: true
    severity: "error"
  R3:
    name: "UI/API Coherence"
    enabled: true
    ui_path: "frontend/src/components"
    api_path: "api/callcentersite"
  R4:
    name: "Database Router"
    enabled: true
  R5:
    name: "Test Execution"
    enabled: true
    min_coverage: 80
  R6:
    name: "DevContainer Validation"
    enabled: true
```

### Key Configuration Options

**Global Settings**:
- `version`: Configuration schema version
- `project`: Project identifier
- `debug`: Enable debug logging (true/false)

**Rule Configuration**:
- `enabled`: Activate/deactivate individual rules
- `severity`: error (blocks commit) or warning (logs only)
- `exceptions`: File patterns to exclude from validation

**Agent Settings**:
- `timeout`: Maximum agent execution time (seconds)
- `retry_count`: Number of retry attempts for transient failures
- `parallel_execution`: Enable parallel agent invocation

### Environment Variables

| Variable | Purpose | Default | Example |
|----------|---------|---------|---------|
| `IACT_DEBUG` | Enable debug logging | 0 | `IACT_DEBUG=1` |
| `IACT_SKIP_HOOKS` | Bypass Git hooks | 0 | `IACT_SKIP_HOOKS=1` |
| `IACT_CI_MODE` | CI execution mode | local | `IACT_CI_MODE=github` |
| `IACT_CONFIG_PATH` | Custom config location | `.constitucion.yaml` | `IACT_CONFIG_PATH=/custom/path` |
| `IACT_AGENT_TIMEOUT` | Agent timeout (seconds) | 300 | `IACT_AGENT_TIMEOUT=600` |
| `IACT_METRICS_ENABLED` | Enable metrics collection | 1 | `IACT_METRICS_ENABLED=0` |

---

## Troubleshooting

### Common Issues and Solutions

**Issue**: Pre-commit hook fails with "Agent not found"

**Solution**:
```bash
# Verify Python environment is activated
source .venv/bin/activate

# Verify agent files exist
ls -la scripts/coding/ai/automation/*.py

# Reinstall hooks
./scripts/install_hooks.sh
```

---

**Issue**: Constitution validation fails with emoji detection false positives

**Solution**:
```bash
# Check specific commit for emojis
git log -1 --pretty=format:"%B" | grep -P "[\x{1F600}-\x{1F64F}]"

# Review .constitucion.yaml for exception patterns
vim .constitucion.yaml

# Add file to exceptions if needed
```

---

**Issue**: CI pipeline times out during test execution

**Solution**:
```bash
# Increase timeout
export IACT_AGENT_TIMEOUT=600

# Run tests in isolation
./scripts/ci-local.sh --stage test --verbose

# Check for hanging tests
python -m pytest -v --timeout=30
```

---

**Issue**: Schema validation fails after constitution file update

**Solution**:
```bash
# Validate schema manually
./scripts/validate_constitution_schema.sh

# Check YAML syntax
python -c "import yaml; yaml.safe_load(open('.constitucion.yaml'))"

# Review schema definition
cat scripts/coding/ai/automation/schemas/constitution_schema.json
```

---

### Validation Utilities

**Check overall system health**:
```bash
# Run all validators
./scripts/constitucion.sh --validate
./scripts/validate_constitution_schema.sh
./scripts/validate_devcontainer_env.sh
./scripts/check_ui_api_coherence.sh
```

**Agent self-test**:
```bash
# Test individual agent
python scripts/coding/ai/automation/constitution_validator_agent.py --self-test

# Verify agent dependencies
pip check
```

### Debug Mode Usage

Enable comprehensive debug logging:

```bash
# Global debug mode
export IACT_DEBUG=1

# Run validation with debug output
./scripts/constitucion.sh 2>&1 | tee debug.log

# Agent-specific debug
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --debug
```

---

## Contributing

### Development Guidelines

1. **Code Style**:
   - Python: PEP 8, type hints required
   - Bash: ShellCheck compliance
   - No emojis in code or documentation (R2)

2. **Branching Strategy**:
   - Feature branches: `feature/<description>`
   - Bugfix branches: `bugfix/<description>`
   - Never commit directly to `main` or `master` (R1)

3. **Commit Messages**:
   - Format: `<type>: <description>`
   - Types: feat, fix, docs, refactor, test, chore
   - No emojis allowed

### Testing Requirements

**Unit Tests**:
- Minimum 80% code coverage for Python agents
- Use pytest framework
- Test files: `test_<agent_name>.py`

**Integration Tests**:
- Located in `tests/integration/automation/`
- Cover agent interaction scenarios
- Include CI pipeline end-to-end tests

**Running Tests**:
```bash
# All tests
pytest tests/

# Specific agent tests
pytest tests/unit/automation/test_constitution_validator_agent.py

# With coverage
pytest --cov=scripts/coding/ai/automation --cov-report=html
```

### Documentation Standards

1. **Agent Documentation**:
   - Docstrings required for all classes and public methods
   - Include usage examples
   - Document exit codes

2. **Architecture Decisions**:
   - Document in ADR format (see `docs/adr/`)
   - Include rationale and alternatives considered

3. **Markdown Format**:
   - Use ATX-style headers (`#`)
   - Include table of contents for long documents
   - No emojis or icons

---

## References

### Related Documentation

- [Project Constitution](../../../.constitucion.yaml) - Constitutional rules R1-R6
- [DevOps Overview](../../devops/) - DevOps documentation root
- [ADR Index](../../adr/) - All architecture decision records
- [CI/CD Documentation](../../../.github/workflows/) - GitHub Actions workflows

### External Resources

- [Git Hooks Documentation](https://git-scm.com/docs/githooks)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [YAML Specification](https://yaml.org/spec/)
- [JSON Schema](https://json-schema.org/)

### Contact Information

**Project Repository**: IACT---project

**Key Maintainers**:
- Automation System: DevOps Team
- Agents Architecture: AI/Automation Team
- CI/CD Pipeline: Platform Team

**Support Channels**:
- GitHub Issues: Technical bugs and feature requests
- Documentation Issues: Submit PR with fixes
- Architecture Questions: Consult ADRs or create discussion

---

**Document Version**: 1.0
**Last Updated**: 2025-11-14
**Status**: Active
