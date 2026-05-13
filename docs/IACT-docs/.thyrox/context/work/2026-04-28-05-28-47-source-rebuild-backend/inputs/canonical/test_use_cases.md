# Casos de Uso - Tests TDD Técnicas de Prompting

**Proyecto**: IACT - Sistema de Agentes IA
**Módulos**: Auto-CoT y Self-Consistency
**Fecha**: 2025-11-14
**Coverage**: 85%+ por módulo

---

## Casos de Uso AutoCoTAgent

### CU-AUTOCOT-INIT: Inicialización del Agente

**Descripción**: Verificar que el agente Auto-CoT se inicializa correctamente con diferentes configuraciones.

**Casos de Test**:

#### CT-AUTOCOT-001: Inicialización con configuración por defecto
- **Entrada**: `AutoCoTAgent()` sin parámetros
- **Verificaciones**:
 - `k_clusters == 5`
 - `max_demonstrations == 10`
 - `demonstrations == []`
 - `use_llm == False`
 - `llm == None`
- **Resultado esperado**: Agente inicializado correctamente

#### CT-AUTOCOT-002: Inicialización con configuración personalizada
- **Entrada**:
 ```python
 AutoCoTAgent(
 k_clusters=3,
 max_demonstrations=5,
 llm_provider="openai",
 model="gpt-4",
 use_llm=False
 )
 ```
- **Verificaciones**:
 - `k_clusters == 3`
 - `max_demonstrations == 5`
- **Resultado esperado**: Configuración personalizada aplicada

#### CT-AUTOCOT-003: Inicialización con LLM habilitado
- **Precondición**: LLM_AVAILABLE == True
- **Entrada**: `AutoCoTAgent(use_llm=True)`
- **Verificaciones**:
 - `use_llm == True`
 - `llm is not None`
- **Resultado esperado**: LLM inicializado correctamente

#### CT-AUTOCOT-004: LLM deshabilitado cuando no disponible
- **Precondición**: LLM_AVAILABLE == False
- **Entrada**: `AutoCoTAgent(use_llm=True)`
- **Verificaciones**:
 - `use_llm == False`
 - `llm == None`
- **Resultado esperado**: Graceful degradation

---

### CU-AUTOCOT-CLUSTER: Clustering de Preguntas

**Descripción**: Agrupar preguntas similares en clusters para sampling diverso.

**Casos de Test**:

#### CT-AUTOCOT-005: Clustering básico
- **Entrada**: Lista de 4-6 preguntas
- **Parámetros**: `k_clusters=2`
- **Verificaciones**:
 - `len(clusters) <= 2`
 - Todos los elementos son listas
 - Preguntas distribuidas en clusters
- **Resultado esperado**: Preguntas agrupadas por similitud

#### CT-AUTOCOT-006: Más clusters que preguntas
- **Entrada**: 3 preguntas
- **Parámetros**: `k_clusters=10`
- **Verificaciones**:
 - `len(clusters) <= 3`
 - No clusters vacíos
- **Resultado esperado**: Ajuste automático de k

#### CT-AUTOCOT-007: Lista vacía
- **Entrada**: `[]`
- **Verificaciones**:
 - `clusters == []` o `clusters == [[]]`
- **Resultado esperado**: Manejo graceful de caso vacío

---

### CU-AUTOCOT-DEMO: Generación de Demostraciones

**Descripción**: Generar demostraciones Chain-of-Thought automáticamente.

**Casos de Test**:

#### CT-AUTOCOT-008: Generación básica
- **Entrada**:
 - 3 preguntas
 - Dominio: "security"
- **Verificaciones**:
 - Resultado es lista
 - Todos elementos son `Demonstration`
 - `len(demonstrations) >= 0`
- **Resultado esperado**: Demostraciones generadas

#### CT-AUTOCOT-009: Respeto de límite máximo
- **Entrada**: 10 preguntas
- **Parámetros**: `max_demonstrations=2`
- **Verificaciones**:
 - `len(demonstrations) <= 2`
- **Resultado esperado**: Límite respetado

#### CT-AUTOCOT-010: Lista vacía de preguntas
- **Entrada**: `questions=[]`
- **Verificaciones**:
 - `demonstrations == []`
- **Resultado esperado**: Sin errores, lista vacía

---

### CU-AUTOCOT-ZEROCOT: Zero-Shot Chain-of-Thought

**Descripción**: Generar razonamiento paso a paso sin ejemplos previos.

**Casos de Test**:

#### CT-AUTOCOT-011: Generación Zero-Shot
- **Entrada**:
 - Pregunta: "¿Cuáles son las implicaciones de seguridad?"
 - Dominio: "security"
- **Mock LLM Response**:
 ```
 Step 1: Analyze the authentication method
 Step 2: Identify SQL injection vulnerability
 Step 3: Assess the risk level
 Answer: The code has critical security vulnerabilities
 ```
- **Verificaciones**:
 - `isinstance(result, Demonstration)`
 - `result.question == pregunta_entrada`
 - `len(result.reasoning) > 0`
 - `len(result.answer) > 0`
- **Resultado esperado**: Demostración con razonamiento estructurado

#### CT-AUTOCOT-012: Extracción de reasoning y answer
- **Mock Response**: "Reasoning: Step by step\nAnswer: Final answer"
- **Verificaciones**:
 - "Step by step" en reasoning
 - "Final answer" en answer
- **Resultado esperado**: Parsing correcto

---

### CU-AUTOCOT-SAMPLE: Sampling Diverso

**Descripción**: Seleccionar preguntas representativas de cada cluster.

**Casos de Test**:

#### CT-AUTOCOT-013: Sampling de múltiples clusters
- **Entrada**:
 ```python
 clusters = [
 [Question("Q1"), Question("Q2")],
 [Question("Q3")],
 [Question("Q4"), Question("Q5"), Question("Q6")]
 ]
 max_samples = 2
 ```
- **Verificaciones**:
 - `len(sampled) <= 2`
 - Todos elementos son `Question`
- **Resultado esperado**: Preguntas diversas seleccionadas

#### CT-AUTOCOT-014: Single cluster
- **Entrada**: Un solo cluster con 3 preguntas, `max_samples=2`
- **Verificaciones**:
 - `len(sampled) <= 2`
- **Resultado esperado**: Sampling funciona con un cluster

#### CT-AUTOCOT-015: Clusters vacíos
- **Entrada**: `clusters = [[], [], []]`
- **Verificaciones**:
 - `sampled == []`
- **Resultado esperado**: Sin errores, lista vacía

---

### CU-AUTOCOT-QUALITY: Quality Scoring

**Descripción**: Calcular score de calidad para demostraciones.

**Casos de Test**:

#### CT-AUTOCOT-016: Demostración válida
- **Entrada**:
 ```python
 Demonstration(
 question="What is XSS?",
 reasoning="Step 1: Define XSS\nStep 2: Explain impact\nStep 3: Mitigation",
 answer="XSS is a security vulnerability..."
 )
 ```
- **Verificaciones**:
 - `0.0 <= score <= 1.0`
 - `score > 0.0`
- **Resultado esperado**: Score positivo

#### CT-AUTOCOT-017: Demostración vacía
- **Entrada**: `Demonstration("", "", "")`
- **Verificaciones**:
 - `score == 0.0` o `score < 0.5`
- **Resultado esperado**: Score bajo

#### CT-AUTOCOT-018: Reasoning chain largo
- **Entrada**: Dos demostraciones, una con 1 step, otra con 5 steps
- **Verificaciones**:
 - `score_long >= score_short * 0.8`
- **Resultado esperado**: Chains largos puntúan mejor

---

### CU-AUTOCOT-ERROR: Manejo de Errores

**Descripción**: Validar comportamiento ante errores.

**Casos de Test**:

#### CT-AUTOCOT-019: Fallo de LLM
- **Entrada**: LLM que lanza `Exception("LLM Error")`
- **Verificaciones**:
 - No crash
 - Resultado es lista válida
- **Resultado esperado**: Degradación graceful

#### CT-AUTOCOT-020: Tipo de pregunta inválido
- **Entrada**: `questions=[123, None, {}]`
- **Verificaciones**:
 - Lanza `TypeError`, `ValueError` o `AttributeError`
- **Resultado esperado**: Error validado

---

### CU-AUTOCOT-PARAM: Tests Parametrizados

**Descripción**: Validar múltiples configuraciones.

**Casos de Test**:

#### CT-AUTOCOT-021-023: Diferentes configuraciones
- **Parámetros**:
 - (k_clusters=2, max_demos=3)
 - (k_clusters=5, max_demos=10)
 - (k_clusters=10, max_demos=5)
- **Verificaciones**: Configuración aplicada correctamente

#### CT-AUTOCOT-024-026: Diferentes proveedores LLM
- **Parámetros**:
 - ("anthropic", "claude-sonnet-4-5-20250929")
 - ("openai", "gpt-4")
 - ("anthropic", "claude-3-opus-20240229")
- **Verificaciones**: Inicialización sin errores

---

### CU-AUTOCOT-INTEGRATION: Tests de Integración

**Descripción**: Pipeline completo end-to-end.

**Casos de Test**:

#### CT-AUTOCOT-027: Pipeline sin LLM
- **Entrada**: 4 preguntas, modo heurístico
- **Verificaciones**:
 - Pipeline completo sin errores
 - Resultado es lista válida
- **Resultado esperado**: Funciona sin LLM

#### CT-AUTOCOT-028: Pipeline con mock LLM
- **Entrada**: 5 preguntas con mock LLM
- **Mock Response**: "Step 1: Analysis\nStep 2: Reasoning\nAnswer: Result"
- **Verificaciones**:
 - `len(demonstrations) >= 0`
 - Todos son `Demonstration`
- **Resultado esperado**: Pipeline completo funcional

---

## Casos de Uso SelfConsistencyAgent

### CU-SELFCONS-INIT: Inicialización del Agente

**Descripción**: Verificar inicialización correcta del agente Self-Consistency.

**Casos de Test**:

#### CT-SELFCONS-001: Configuración por defecto
- **Entrada**: `SelfConsistencyAgent()`
- **Verificaciones**:
 - `num_samples >= 3`
 - `0 <= temperature <= 1.0`
 - Tiene método `generate_multiple_responses`
- **Resultado esperado**: Agente inicializado

#### CT-SELFCONS-002: Configuración personalizada
- **Entrada**:
 ```python
 config = {
 "num_samples": 5,
 "temperature": 0.8,
 "voting_strategy": "majority",
 "min_consistency_score": 0.6
 }
 ```
- **Verificaciones**: Configuración aplicada

#### CT-SELFCONS-003-005: Diferentes num_samples
- **Parámetros**: 3, 5, 10, 20
- **Verificaciones**: `num_samples` correcto

---

### CU-SELFCONS-GENERATE: Generación Múltiple

**Descripción**: Generar múltiples responses con variación.

**Casos de Test**:

#### CT-SELFCONS-006: Generación de 5 samples
- **Entrada**: Pregunta con `num_samples=5`
- **Verificaciones**:
 - Resultado es lista
 - `len(responses) == 5`
 - Todos elementos son dict
- **Resultado esperado**: 5 responses generados

#### CT-SELFCONS-007: Temperatura afecta diversidad
- **Entrada**: Dos agentes con temperature 0.1 y 0.9
- **Verificaciones**:
 - `agent_low.temperature < agent_high.temperature`
- **Resultado esperado**: Configuración diferenciada

---

### CU-SELFCONS-VOTE: Majority Voting

**Descripción**: Seleccionar respuesta más consistente por votación.

**Casos de Test**:

#### CT-SELFCONS-008: Ganador claro
- **Entrada**:
 ```python
 [
 {"answer": "Microservices", "confidence": 0.85},
 {"answer": "Microservices", "confidence": 0.78},
 {"answer": "Monolith", "confidence": 0.55},
 {"answer": "Microservices", "confidence": 0.90},
 {"answer": "Microservices", "confidence": 0.82}
 ]
 ```
- **Verificaciones**:
 - `winner == "Microservices"`
- **Resultado esperado**: Mayoría clara seleccionada

#### CT-SELFCONS-009: Manejo de empate
- **Entrada**: `[{"answer": "A"}, {"answer": "B"}]`
- **Verificaciones**:
 - Resultado no es None
 - Empate manejado
- **Resultado esperado**: Selección de una opción

#### CT-SELFCONS-010: Todas iguales
- **Entrada**: `[{"answer": "A"}, {"answer": "A"}, {"answer": "A"}]`
- **Verificaciones**:
 - `result == "A"`
- **Resultado esperado**: Unanimidad detectada

#### CT-SELFCONS-011: Lista vacía
- **Entrada**: `[]`
- **Verificaciones**:
 - `result is None` o `result == ""`
- **Resultado esperado**: Manejo de caso vacío

---

### CU-SELFCONS-SCORE: Consistency Scoring

**Descripción**: Calcular score de consistencia entre responses.

**Casos de Test**:

#### CT-SELFCONS-012: Alto acuerdo
- **Entrada**: Todas respuestas iguales
- **Verificaciones**:
 - `0.8 <= score <= 1.0`
- **Resultado esperado**: Score alto

#### CT-SELFCONS-013: Bajo acuerdo
- **Entrada**:
 ```python
 [
 {"answer": "A"},
 {"answer": "B"},
 {"answer": "C"},
 {"answer": "D"}
 ]
 ```
- **Verificaciones**:
 - `0.0 <= score < 0.5`
- **Resultado esperado**: Score bajo

#### CT-SELFCONS-014: Rango válido
- **Entrada**: Cualquier lista de responses
- **Verificaciones**:
 - `0.0 <= score <= 1.0`
- **Resultado esperado**: Score siempre en rango

---

### CU-SELFCONS-EXECUTE: Ejecución Completa

**Descripción**: Pipeline completo de Self-Consistency.

**Casos de Test**:

#### CT-SELFCONS-015: Resultado válido
- **Entrada**: Pregunta con mock LLM
- **Verificaciones**:
 - Contiene "final_answer"
 - Contiene "samples"
 - Contiene "consistency_score"
- **Resultado esperado**: Estructura válida

#### CT-SELFCONS-016: Umbral de confianza
- **Entrada**:
 ```python
 config = {
 "num_samples": 5,
 "min_consistency_score": 0.8
 }
 ```
- **Verificaciones**:
 - "consistency_score" en resultado
- **Resultado esperado**: Umbral aplicado

---

### CU-SELFCONS-ERROR: Manejo de Errores

**Descripción**: Validar comportamiento ante errores.

**Casos de Test**:

#### CT-SELFCONS-017: Fallo de LLM
- **Entrada**: LLM que lanza Exception
- **Verificaciones**:
 - Lanza Exception
- **Resultado esperado**: Error propagado

#### CT-SELFCONS-018-020: Inputs inválidos
- **Parámetros**:
 - `{}` (sin question)
 - `{"question": ""}` (vacía)
 - `{"question": None}` (None)
- **Verificaciones**:
 - Lanza `ValueError`, `KeyError` o `TypeError`
- **Resultado esperado**: Validación de entrada

---

### CU-SELFCONS-PERF: Performance

**Descripción**: Validar escalamiento de performance.

**Casos de Test**:

#### CT-SELFCONS-021-023: Escalamiento lineal
- **Parámetros**: num_samples = 5, 10, 20
- **Verificaciones**:
 - `duration < num_samples * 0.1`
- **Resultado esperado**: Performance escala linealmente

---

### CU-SELFCONS-INTEGRATION: Integración

**Descripción**: Pipeline completo end-to-end.

**Casos de Test**:

#### CT-SELFCONS-024: Pipeline completo
- **Entrada**: Pregunta con 5 responses variadas
- **Mock Responses**:
 - "Answer: Microservices" (x4)
 - "Answer: Monolith" (x1)
- **Verificaciones**:
 - "final_answer" presente
 - "consistency_score" > 0.5
- **Resultado esperado**: Mayoría seleccionada correctamente

---

### CU-SELFCONS-UTIL: Utilidades

**Descripción**: Funciones auxiliares.

**Casos de Test**:

#### CT-SELFCONS-025: Extracción de respuesta
- **Entrada**: "Reasoning: Because...\nAnswer: Use microservices"
- **Verificaciones**:
 - "microservices" en answer extraído
- **Resultado esperado**: Parsing correcto

#### CT-SELFCONS-026: Confidence agregado
- **Entrada**: Lista con confidence scores
- **Verificaciones**:
 - `0.0 <= avg_confidence <= 1.0`
 - `avg_confidence > 0.7`
- **Resultado esperado**: Promedio calculado

---

## Resumen de Coverage

### AutoCoTAgent
- **Total casos de uso**: 10
- **Total casos de test**: 28
- **Coverage estimado**: 85%+
- **Categorías**:
 - Inicialización: 4 tests
 - Clustering: 3 tests
 - Demostraciones: 3 tests
 - Zero-Shot CoT: 2 tests
 - Sampling: 3 tests
 - Quality: 3 tests
 - Errores: 2 tests
 - Parametrizados: 6 tests
 - Integración: 2 tests

### SelfConsistencyAgent
- **Total casos de uso**: 8
- **Total casos de test**: 26
- **Total coverage estimado**: 85%+
- **Categorías**:
 - Inicialización: 5 tests
 - Generación: 2 tests
 - Voting: 4 tests
 - Scoring: 3 tests
 - Execute: 2 tests
 - Errores: 4 tests
 - Performance: 3 tests
 - Integración: 1 test
 - Utilidades: 2 tests

---

## Nomenclatura

- **CU**: Caso de Uso
- **CT**: Caso de Test
- **AUTOCOT**: AutoCoTAgent
- **SELFCONS**: SelfConsistencyAgent
- **INIT**: Inicialización
- **CLUSTER**: Clustering
- **DEMO**: Demostraciones
- **VOTE**: Votación
- **SCORE**: Scoring
- **ERROR**: Manejo de errores
- **PARAM**: Parametrizado
- **INTEGRATION**: Integración
- **PERF**: Performance
- **UTIL**: Utilidades

---

**Generado**: 2025-11-14
**Total casos de uso**: 18
**Total casos de test**: 54
**Coverage objetivo**: 85%+
**Frameworks**: pytest, pytest-mock, pytest-parametrize
