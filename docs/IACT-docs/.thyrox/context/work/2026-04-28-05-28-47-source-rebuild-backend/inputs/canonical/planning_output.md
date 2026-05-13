# FASE 1: PLANNING - Implementación TDD para Técnicas de Prompting

**Agent**: SDLCPlannerAgent
**Fecha**: 2025-11-14
**Decisión**: GO
**Técnicas aplicadas**: Few-Shot Prompting, Task Decomposition

---

## Issue #TDD-PROMPTING-001

### Título
Implementar tests TDD completos para todas las técnicas de prompting

### Descripción

Como equipo de desarrollo,
Queremos tener tests TDD completos para todas las técnicas de prompting implementadas,
Para garantizar calidad, mantenibilidad y confianza en el código de los agentes.

### Contexto

El proyecto IACT tiene 11 módulos de técnicas de prompting implementadas en Python en `scripts/coding/ai/agents/base/`, pero actualmente carecen de tests unitarios. Esto representa un riesgo para la calidad del código y dificulta el mantenimiento y evolución de los agentes.

### Acceptance Criteria

- [ ] Cada módulo de técnica de prompting tiene su archivo de tests correspondiente
- [ ] Cobertura de código >= 80% para cada módulo
- [ ] Tests usan pytest como framework
- [ ] Cada test tiene docstring descriptivo
- [ ] Tests cubren casos happy path, edge cases y manejo de errores
- [ ] Tests siguen convenciones de naming del proyecto
- [ ] Tests pasan en CI/CD pipeline
- [ ] Documentación de tests incluida en README

### Story Points: 13

**Justificación**:
- 11 módulos a testear = 8 pts
- Complejidad técnica (técnicas avanzadas) = 3 pts
- Setup inicial de infraestructura de tests = 2 pts
- Total: 13 pts (equivalente a ~2 sprints)

### Prioridad: P0 (Crítica)

**Razón**: Tests son fundacionales para la calidad del código. Sin ellos, cualquier refactoring o nueva feature es arriesgada.

### Requisitos Técnicos

1. **Framework**: pytest 7.x o superior
2. **Coverage tool**: pytest-cov
3. **Ubicación tests**: `scripts/coding/ai/tests/techniques/`
4. **Naming convention**: `test_<module_name>.py`
5. **Mocking**: pytest-mock para dependencias externas
6. **Fixtures**: Usar pytest fixtures para setup/teardown

### Módulos a Testear

#### Grupo 1: Técnicas Avanzadas (Prioridad Alta)
1. **auto_cot_agent.py** - Automatic Chain-of-Thought
 - Clustering de preguntas
 - Sampling de demostraciones
 - Generación de razonamiento

2. **self_consistency.py** - Multiple reasoning paths
 - Generación de múltiples respuestas
 - Majority voting
 - Scoring de consistencia

3. **chain_of_verification.py** - Step-by-step verification
 - Generación de preguntas de verificación
 - Verificación independiente
 - Refinamiento de respuesta

4. **tree_of_thoughts.py** - Tree exploration
 - BFS/DFS exploration
 - Node evaluation
 - Branch pruning

#### Grupo 2: Técnicas Fundamentales (Prioridad Media)
5. **fundamental_techniques.py**
 - RolePromptingAgent
 - FewShotPromptingAgent
 - ZeroShotPromptingAgent

6. **structuring_techniques.py**
 - PromptChainingAgent
 - TaskDecompositionAgent

#### Grupo 3: Técnicas de Conocimiento (Prioridad Media)
7. **knowledge_techniques.py**
 - ReActAgent
 - RAGAgent
 - ToolUseAgent

#### Grupo 4: Técnicas de Optimización (Prioridad Media)
8. **optimization_techniques.py**
 - ConstitutionalAIAgent
 - DelimiterPromptingAgent
 - ConstrainedPromptingAgent

9. **search_optimization_techniques.py**
 - BinarySearchPromptingAgent
 - GreedyInformationDensityAgent

#### Grupo 5: Técnicas Especializadas (Prioridad Baja)
10. **specialized_techniques.py**
 - ExpertPromptingAgent
 - MetaPromptingAgent

11. **prompt_templates.py**
 - PromptTemplateEngine
 - Template rendering
 - YAML frontmatter generation

### Dependencias

- pytest y pytest-cov instalados
- pytest-mock para mocking
- Fixtures compartidos para LLM mocking
- CI/CD pipeline configurado para ejecutar tests

### Tareas Derivadas

1. Setup infraestructura de tests
2. Crear fixtures compartidos (conftest.py)
3. Implementar tests por grupo (5 tareas)
4. Configurar CI/CD para ejecutar tests
5. Generar reporte de coverage
6. Documentar guía de testing

### Riesgos Identificados

1. **Complejidad de mocking LLM**: Las técnicas dependen de respuestas LLM → Solución: Mock con responses predefinidas
2. **Técnicas interdependientes**: Algunas técnicas usan otras → Solución: Tests de integración separados
3. **Coverage difícil de alcanzar**: Técnicas con muchos branches → Solución: Tests parametrizados

### Estimación de Tiempo

- Grupo 1 (Técnicas Avanzadas): 5 días
- Grupo 2-4 (Fundamentales-Optimización): 4 días
- Grupo 5 (Especializadas): 2 días
- Setup + Documentación: 2 días
- **Total**: 13 días (~2 sprints)

### Técnicas SDLC a Aplicar

- **Auto-CoT**: Para generar casos de test complejos
- **Self-Consistency**: Para validar que los tests cubren casos diversos
- **TDD Estricto**: Red-Green-Refactor cycle
- **Constitutional AI**: Guardarraíles en tests

---

## Próximo Paso

**Fase 2: Feasibility Analysis**
Analizar riesgos técnicos, dependencias y viabilidad de la implementación.
