# Backend - Documentación

Documentación del dominio Backend de IACT.

## Propósito

Esta documentación proporciona:

1. **SDLC completo**: Implementación TDD para técnicas de prompting y código backend
2. **Arquitectura de Agentes**: Design patterns y estructura de agentes AI
3. **Tests automatizados**: 80%+ coverage con pytest
4. **Guías de desarrollo**: Para developers backend y AI engineers

## Contenido Principal

### SDLC (Software Development Lifecycle)

Documentación completa del ciclo SDLC para implementación de tests TDD de técnicas de prompting:

- **[planning/](planning/)** - Fase de planificación
 - Issue tracking
 - Story points
 - Acceptance criteria

- **[feasibility/](feasibility/)** - Análisis de viabilidad
 - Risk analysis
 - Dependency mapping
 - Go/No-Go decision

- **[design/](design/)** - Diseño HLD/LLD
 - High-Level Design
 - Low-Level Design
 - Test architecture

- **[testing/](testing/)** - Estrategia de testing
 - Test strategy
 - Test use cases
 - Coverage reports

- **[deployment/](deployment/)** - Plan de deployment
 - Deployment strategy
 - Rollback plan
 - CI/CD integration

Ver resumen completo: [SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md](SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md)

### Gobernanza del Dominio

- **gobernanza/** - Estándares y políticas específicas de backend
 - Coding standards Python
 - Testing requirements (TDD estricto)
 - Code review guidelines

### ADRs del Dominio

- **adr/** - Architecture Decision Records específicos de backend
 - Decisiones de diseño de agentes
 - Patrones de testing
 - Arquitectura de código

### Procedimientos

- **procedimientos/** - Procedimientos específicos de desarrollo backend
 - Workflow de desarrollo TDD
 - Proceso de code review
 - Deployment de código Python

## Relación con otras Secciones

- [docs/ai/](../ai/) - Sistema de agentes AI/ML (código vivo)
- [.github/agents/](.github/agents/) - Definiciones de agentes
- [docs/devops/](../devops/) - Automatización CI/CD
- [docs/qa/](../qa/) - Validación y quality gates
- [docs/gobernanza/](../gobernanza/) - Gobernanza padre

## Código Relacionado

### Scripts

```
scripts/coding/ai/ # Código de agentes AI (Python)
 agents/ # 30+ agentes
 sdlc/ # Agentes SDLC
 automation/ # Agentes de automatización
 tests/ # Tests TDD
```

### API

```
api/ # Django REST API
```

## Para Empezar

### Si eres AI Engineer

1. Ver [documentación SDLC completa](SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md)
2. Explorar [tests de prompting techniques](testing/test_use_cases.md)
3. Revisar código en `scripts/coding/ai/agents/`

### Si eres Backend Developer

1. Ver [planning de features](planning/planning_output.md)
2. Revisar [diseño arquitectónico](design/design_hld_lld.md)
3. Ejecutar tests:
 ```bash
 pytest scripts/coding/ai/tests/
 ```

### Si estás implementando TDD

1. Leer [estrategia de testing](testing/testing_strategy.md)
2. Ver [casos de uso de tests](testing/test_use_cases.md)
3. Seguir patrones en `scripts/coding/ai/tests/conftest.py`

## Comandos Útiles

```bash
# Ejecutar tests de backend
pytest scripts/coding/ai/tests/ -v

# Ver coverage
pytest --cov=scripts/coding/ai/agents/base --cov-report=html

# Ejecutar tests específicos
pytest scripts/coding/ai/tests/techniques/test_auto_cot_agent.py

# Validar código Python
ruff check scripts/coding/ai/

# Ejecutar SDLC pipeline
python scripts/run_sdlc_pipeline_for_tdd.py
```

## Convenciones del Dominio

### Nomenclatura

- Archivos: `snake_case.md`
- Sin números en prefijos
- Sin emojis

### Estructura de Tests

```python
# Patrón AAA (Arrange, Act, Assert)
def test_feature():
 # Arrange
 agent = AutoCoTAgent()

 # Act
 result = agent.process(input_data)

 # Assert
 assert result.status == "success"
```

### Coverage Target

- Mínimo: 80%
- Ideal: 90%+
- Crítico: 100% para código de agentes SDLC

## Estado Actual

- SDLC completo: [OK] Documentado
- Tests implementados: 2/11 módulos (18%)
 - [OK] `test_auto_cot_agent.py` (25 tests)
 - [OK] `test_self_consistency.py` (20 tests)
 - ⏳ 9 módulos pendientes

Ver progreso completo en [testing/testing_strategy.md](testing/testing_strategy.md)

## Contribuir

Para contribuir a backend:

1. Seguir TDD estricto
2. Alcanzar 80%+ coverage
3. Pasar `./scripts/ci-local.sh`
4. Actualizar documentación relevante

Ver guía completa: [../CONTRIBUTING.md](../../CONTRIBUTING.md)

---

**Última actualización**: 2025-11-14
**Owner**: AI Engineering Team
**Status**: Active development
