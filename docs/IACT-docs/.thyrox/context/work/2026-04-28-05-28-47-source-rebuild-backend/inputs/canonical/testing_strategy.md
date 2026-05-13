# FASE 4: TESTING - Estrategia de Testing TDD

**Agent**: SDLCTestingAgent
**Fecha**: 2025-11-14
**Decisión**: GO
**Técnicas aplicadas**: Auto-CoT, Self-Consistency

---

## Test Strategy

### Pyramid de Testing

```
 /\
 /E2E\ 10% - Integration tests
 /------\
 /Unit \ 90% - Unit tests
 /----------\
```

### Test Plan por Módulo

#### GRUPO 1: Técnicas Avanzadas (Implementar primero - PRIORITY HIGH)

**1. test_auto_cot_agent.py** - Auto-CoT Testing
- Test inicialización con configs
- Test clustering de preguntas
- Test sampling de demostraciones
- Test generación Zero-Shot CoT
- Test error handling
- **Coverage target**: 85%
- **Effort**: 1 día

**2. test_self_consistency.py** - Self-Consistency Testing
- Test generación múltiples samples
- Test majority voting
- Test consistency scoring
- Test temperatura y diversidad
- **Coverage target**: 85%
- **Effort**: 0.8 días

**3. test_chain_of_verification.py** - CoVe Testing
- Test generación de preguntas verificación
- Test verificación independiente
- Test refinamiento de respuesta
- **Coverage target**: 80%
- **Effort**: 0.8 días

**4. test_tree_of_thoughts.py** - ToT Testing
- Test BFS/DFS exploration
- Test node evaluation
- Test branch pruning
- Test tree traversal
- **Coverage target**: 75% (complejidad alta)
- **Effort**: 1.2 días

#### GRUPO 2-5: Resto de Técnicas (8 días totales)

Ver planning document para detalle completo.

---

## Test Coverage Requirements

### Mínimo por Categoría

| Categoría | Coverage | Justificación |
|-----------|----------|---------------|
| Happy Path | 100% | Funcionalidad core |
| Edge Cases | 80% | Casos límite importantes |
| Error Handling | 90% | Manejo robusto de errores |
| Integration | 60% | Tests selectivos |

### Exclusiones de Coverage

- Código de debugging
- Imports
- `__init__.py` vacíos
- Código deprecated

---

## Test Execution Strategy

### Aplicación de Auto-CoT

**Uso**: Generar casos de test complejos

**Proceso**:
1. **Thought**: "¿Qué escenarios edge necesito cubrir?"
2. **Action**: Analizar código y encontrar branches
3. **Observation**: Identificar 5 edge cases
4. **Thought**: "¿Cómo testear cada caso?"
5. **Action**: Generar test cases
6. **Result**: Test suite completo

**Ejemplo aplicado**:
```python
# Auto-CoT generó estos casos para auto_cot_agent:
# 1. Question vacía → ValueError
# 2. Question muy larga → Truncate
# 3. Num_demonstrations = 0 → Zero-shot mode
# 4. Clustering disabled → Direct sampling
# 5. LLM failure → Graceful degradation
```

### Aplicación de Self-Consistency

**Uso**: Validar que tests cubren casos diversos

**Proceso**:
1. Generar 5 versiones diferentes del test
2. Verificar que todas pasen
3. Seleccionar la más robusta (majority voting)
4. Iterar hasta consistency_score > 0.8

**Ejemplo aplicado**:
```python
# Self-Consistency para test_majority_voting:
# Version 1: Test con 3 samples, 2 iguales
# Version 2: Test con 5 samples, 3 iguales
# Version 3: Test con 10 samples, empate
# Version 4: Test con responses vacías
# Version 5: Test con confidence scores

# Majority selecciona: Version 2 (más balanceada)
```

---

## Fixtures y Mocking Strategy

### conftest.py - Setup Global

```python
# Fixtures principales:
- mock_llm_generator
- sample_questions
- auto_cot_responses
- self_consistency_responses
- sample_contexts
```

### Mock Responses Strategy

**Principio**: Mock responses deben ser realistas pero determinísticos

**Implementación**:
1. Capturar responses reales de LLM en dev
2. Sanitizar y anonimizar
3. Usar como fixtures en tests
4. Versionar responses

---

## CI/CD Integration

### GitHub Actions Workflow

```yaml
name: Tests TDD - Técnicas Prompting

on: [push, pull_request]

jobs:
 test:
 runs-on: ubuntu-latest
 steps:
 - uses: actions/checkout@v3

 - name: Setup Python
 uses: actions/setup-python@v4
 with:
 python-version: '3.9'

 - name: Install dependencies
 run: |
 pip install pytest pytest-cov pytest-mock
 pip install -r requirements.txt

 - name: Run tests
 run: |
 pytest scripts/coding/ai/tests/techniques/ \
 --cov=scripts/coding/ai/agents/base \
 --cov-report=html \
 --cov-report=term \
 --cov-fail-under=80

 - name: Upload coverage
 uses: codecov/codecov-action@v3
```

---

## Test Execution Plan

### Phase 1: Foundation (Día 1-2)
1. Setup test infrastructure
2. Create conftest.py con fixtures
3. Create mock_responses
4. Implementar test_auto_cot_agent.py
5. Implementar test_self_consistency.py

### Phase 2: Core (Día 3-5)
6. test_chain_of_verification.py
7. test_tree_of_thoughts.py
8. test_fundamental_techniques.py
9. test_structuring_techniques.py

### Phase 3: Extended (Día 6-8)
10. test_knowledge_techniques.py
11. test_optimization_techniques.py
12. test_specialized_techniques.py

### Phase 4: Final (Día 9-10)
13. test_search_optimization.py
14. test_prompt_templates.py
15. Integration tests
16. Documentation

---

## Success Criteria

[OK] All tests pass
[OK] Coverage >= 80% per module
[OK] CI/CD pipeline green
[OK] Documentation complete
[OK] No critical bugs
[OK] Performance acceptable (< 5 min total test time)

---

## Próximo Paso

**Fase 5: Deployment**
Planificar deployment de tests al repositorio y activación de CI/CD.

**Decisión**: GO [OK]
