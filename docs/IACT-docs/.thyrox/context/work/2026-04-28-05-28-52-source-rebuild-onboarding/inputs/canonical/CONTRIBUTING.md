---
title: Contributing to IACT Project
date: 2025-11-13
domain: general
status: active
---

# Contributing to IACT Project

Thank you for your interest in contributing to the IACT project. This document provides guidelines and best practices for contributors.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Project Policies](#project-policies)
4. [Development Workflow](#development-workflow)
5. [Code Standards](#code-standards)
6. [Testing](#testing)
7. [Documentation](#documentation)
8. [Commit Guidelines](#commit-guidelines)

## Code of Conduct

We expect all contributors to:
- Be respectful and professional
- Focus on technical accuracy
- Provide constructive feedback
- Follow project guidelines and standards

## Getting Started

### Prerequisites

- Python 3.9+
- Git
- Understanding of the project architecture (see `docs/`)

### Setup

1. Clone the repository
2. Create a virtual environment: `python -m venv .venv`
3. Activate: `source .venv/bin/activate` (Linux/Mac) or `.venv\Scripts\activate` (Windows)
4. Install dependencies: `pip install -r requirements.txt`
5. Run tests to verify setup: `pytest tests/`

## Project Policies

### CRITICAL: NO EMOJI Policy

The IACT project has a **STRICT NO EMOJI policy** for all files:

- Code files (.py, .js, .ts, etc.)
- Documentation (.md, .txt)
- Scripts (.sh, .bash)
- Configuration files (.yaml, .yml, .json)
- Commit messages

**Why?**
- Compatibility: Not all terminals/editors render emojis correctly
- Accessibility: Screen readers may have issues with emojis
- Professionalism: Technical documentation should be formal
- Searchability: Difficult to grep/search for emojis
- Internationalization: Emojis can have different cultural meanings

**Validation:**
```bash
# Check specific files before committing
python scripts/workflows/check_no_emojis.py file1.py file2.md

# Check all project files
python scripts/workflows/check_no_emojis.py --all
```

**Pre-commit Hook:**
A pre-commit hook is installed that automatically checks for emojis. If emojis are detected, the commit will be rejected.

**Alternatives to Common Emojis:**

| Instead of | Use |
|------------|-----|
| checkmark  | [x] or "Completado" or "OK" or "PASS" |
| cross mark | [ ] or "Pendiente" or "FAIL" |
| warning    | "ADVERTENCIA:" or "WARNING:" or "Nota:" |
| rocket     | Omit or "Lanzado" or "Deployed" |
| document   | Omit or "Documentado" |
| wrench     | "Configurado" or "Fixed" |
| lightbulb  | "Nota:" or "TIP:" |
| party      | Omit or "Completado exitosamente" |
| target     | "Objetivo:" or "Goal:" |
| chart      | "Metricas:" or "Metrics:" |

**For detailed analysis:** See `ANALISIS_POLITICA_NO_EMOJIS.md`

### Other Project Restrictions

See `docs/gobernanza/GUIA_ESTILO.md` for complete list:

1. **No JavaScript for Scripts**: Use Python for all automation scripts
2. **No Redis**: Sessions stored in MySQL/PostgreSQL only
3. **No Email**: Alerts via internal inbox system
4. **IVR Database is Read-Only**: Zero writes to IVR database
5. **ETL is Batch**: Executed every 6-12 hours, not real-time
6. **File Naming**: Prefer underscores (_) over hyphens (-) in filenames

## Development Workflow

### Branch Strategy

- `main` - Production branch
- `develop` - Development branch
- `claude/*` - Claude Code working branches
- `feature/*` - Feature branches
- `fix/*` - Bug fix branches

### Creating a Feature

1. Create branch from `develop`: `git checkout -b feature/your-feature-name`
2. Implement feature following TDD approach (see below)
3. Run tests: `pytest tests/`
4. Check for emojis: `python scripts/workflows/check_no_emojis.py --all`
5. Commit changes following commit guidelines
6. Push and create Pull Request

### Test-Driven Development (TDD)

This project uses a strict TDD approach:

**RED-GREEN-REFACTOR Cycle:**

1. **RED**: Write failing tests first
   ```bash
   pytest tests/ -v  # Should fail
   ```

2. **GREEN**: Implement minimum code to pass tests
   ```bash
   pytest tests/ -v  # Should pass
   ```

3. **REFACTOR**: Improve code quality while keeping tests green
   ```bash
   pytest tests/ -v  # Should still pass
   ```

**TDD Constitution Rules:**

The project enforces 8 immutable TDD rules (see `scripts/ai/tdd/constitution.py`):
- 4 CRITICAL rules (must never be violated)
- 2 HIGH priority rules
- 2 MEDIUM priority rules

**TDD Feature Agent:**

Use the TDD Feature Agent for automated TDD workflows:
```python
from scripts.ai.tdd.feature_agent import TDDFeatureAgent

agent = TDDFeatureAgent()
result = agent.run({
    "issue_title": "Your Feature",
    "acceptance_criteria": [...],
    "technical_requirements": [...]
})
```

## Code Standards

### Python Code Style

**PEP 8 Compliance:**
- Line length: 88 characters (Black formatter)
- Type hints: Mandatory for all functions
- Docstrings: Google style format

**Example:**
```python
from typing import List, Dict

def process_user_authentication(user_data: Dict[str, str]) -> bool:
    """
    Validates user credentials and returns authentication status.

    Args:
        user_data: Dictionary containing 'username' and 'password' keys

    Returns:
        True if authentication successful, False otherwise

    Raises:
        ValueError: If user_data is missing required keys
    """
    if not user_data.get('username') or not user_data.get('password'):
        raise ValueError("Missing required authentication fields")
    return validate_credentials(user_data)
```

### Clean Code Naming Principles

Follow Robert Martin's 9 naming principles (see `docs/gobernanza/GUIA_ESTILO.md`):

1. Names Reveal Intention
2. Avoid Disinformation
3. Meaningful Distinctions
4. Pronounceable Names
5. Searchable Names
6. Avoid Encodings
7. Avoid Mental Mapping
8. One Word Per Concept
9. Architecture Reveals Intent

**Bad:**
```python
def proc_data(d):
    t = datetime.now()
    return d
```

**Good:**
```python
def process_user_authentication(user_data: Dict) -> bool:
    current_timestamp = datetime.now()
    return validate_user_credentials(user_data, current_timestamp)
```

### Import Order

```python
# 1. Standard library
import os
from pathlib import Path
from typing import List, Dict

# 2. Third-party packages
from django.db import models
import pytest

# 3. Local application
from scripts.ai.shared.agent_base import AgentBase
from apps.core.models import User
```

## Testing

### Running Tests

```bash
# Run all tests
pytest tests/

# Run with coverage
pytest tests/ --cov=scripts --cov-report=html

# Run specific test file
pytest tests/ai/agents/test_tdd_constitution.py

# Run with verbose output
pytest tests/ -v
```

### Test Structure

```python
import pytest
from scripts.ai.tdd.constitution import TDDConstitution

class TestTDDConstitution:
    """Test suite for TDD Constitution validation."""

    def test_validate_test_first_rule_pass(self):
        """Test that TEST_FIRST rule passes when tests exist before code."""
        constitution = TDDConstitution()
        result = constitution.validate_test_first(test_exists=True, code_exists=False)
        assert result.is_valid
        assert len(result.violations) == 0

    def test_validate_test_first_rule_fail(self):
        """Test that TEST_FIRST rule fails when code exists before tests."""
        constitution = TDDConstitution()
        result = constitution.validate_test_first(test_exists=False, code_exists=True)
        assert not result.is_valid
        assert len(result.violations) == 1
```

### Test Coverage Requirements

- Minimum coverage: 80%
- All new features must include tests
- Bug fixes must include regression tests

## Documentation

### Markdown Documentation

All `.md` files must include YAML front matter:

```yaml
---
id: DOC-XXX-YYY
tipo: guia|procedimiento|adr|requisito
estado: borrador|activo|archivado
propietario: equipo-xxx
ultima_actualizacion: YYYY-MM-DD
---
```

### Code Documentation

- All modules must have module-level docstrings
- All classes must have class-level docstrings
- All public functions must have docstrings with Args, Returns, Raises
- Use Google-style docstrings

### README Files

- Always uppercase: `README.md`
- Must include: Purpose, Usage, Examples
- NO emojis allowed

## Commit Guidelines

### Conventional Commits Format

```
type(scope): brief description

Detailed explanation if needed.

Refs: #issue-number
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

**Examples:**

```
feat(auth): implement two-factor authentication

Added SMS-based 2FA for user login.
Includes rate limiting and backup codes.

Refs: #123
```

```
fix(tdd): correct test execution order in feature agent

Fixed issue where tests were running before being generated,
violating TDD constitution rule TEST_FIRST.

Refs: #456
```

### Commit Best Practices

- Keep commits atomic (one logical change per commit)
- Write clear, descriptive commit messages
- NO emojis in commit messages
- Reference issue numbers when applicable
- Use imperative mood: "Add feature" not "Added feature"

## Pull Request Process

1. Ensure all tests pass: `pytest tests/`
2. Check code coverage meets minimum requirements
3. Verify no emojis: `python scripts/workflows/check_no_emojis.py --all`
4. Update documentation if needed
5. Create PR with clear description
6. Link related issues
7. Request review from maintainers

### PR Description Template

```markdown
## Summary
Brief description of changes

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Coverage meets requirements
- [ ] No emojis detected

## Related Issues
Refs: #123

## Checklist
- [ ] Code follows style guide
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] No emojis in any files
- [ ] Conventional commit format used
```

## Getting Help

- Check existing documentation in `docs/`
- Review style guide: `docs/gobernanza/GUIA_ESTILO.md`
- Read emoji policy analysis: `ANALISIS_POLITICA_NO_EMOJIS.md`
- Check workflows in `docs/workflows/`
- Create an issue for questions or problems

## References

- [Clean Code by Robert Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [PEP 8 - Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- Project Style Guide: `docs/gobernanza/GUIA_ESTILO.md`
- Emoji Policy Analysis: `ANALISIS_POLITICA_NO_EMOJIS.md`

---

**Last Updated:** 2025-11-09

Thank you for contributing to the IACT project!
