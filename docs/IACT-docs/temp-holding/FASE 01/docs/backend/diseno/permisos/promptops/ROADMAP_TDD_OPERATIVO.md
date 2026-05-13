---
title: Roadmap: TDD Agent Evolution
date: 2025-11-13
domain: backend
status: active
---

# Roadmap: TDD Agent Evolution

**Documento:** Roadmap de Extensiones TDD Agent
**Fecha:** 2025-11-11
**Autor:** TDD Agent Foundation Team
**Estado:** v1.0 MVP Completado

---

## Visión

Crear un agente TDD completamente autónomo que:
1. Genera tests completos desde requisitos naturales
2. Ejecuta ciclos TDD sin intervención humana
3. Auto-corrige errores comunes
4. Refactoriza código post-tests
5. Aprende de patrones previos para mejorar sugerencias

---

## Estado Actual: v1.0 MVP

### Funcionalidades Implementadas

[OK] **Test Template Generation**
- Genera estructura de clases de tests
- Crea fixtures básicos
- Genera métodos de test con TODOs
- Soporta tipos de agentes: gate, chain, template

[OK] **Pytest Execution**
- Ejecuta pytest con flags apropiados
- Captura stdout/stderr
- Parsea resultados básicos (passed/failed/skipped)
- Extrae duración y métricas

[OK] **Failure Analysis**
- Identifica tests fallidos
- Extrae nombres de tests
- Genera estructura de errores

[OK] **Documentation Generation**
- Crea markdown con errores descubiertos
- Documenta métricas del ciclo
- Incluye next steps
- Formato consistente con restricciones del proyecto

[OK] **CLI Interface**
- Argumentos: --component, --requirements, --type, --verbose
- Exit codes apropiados (0/1/2/3)
- Output formateado para humanos

[OK] **Shell Script Wrapper**
- Validación de argumentos
- Activación de entorno virtual
- Manejo de errores
- Output coloreado

### Limitaciones Conocidas

[WARNING] **Templates, no código completo**
- Genera TODOs en lugar de implementaciones
- Requiere desarrollador para llenar tests

[WARNING] **No auto-fix**
- Identifica errores pero no los corrige
- Requiere intervención manual

[WARNING] **Parsing básico**
- Extrae métricas con regex simple
- Puede fallar con outputs complejos

[WARNING] **Sin integración LLM**
- No usa AI para análisis semántico
- No genera sugerencias contextuales

[WARNING] **Sin refactoring**
- No optimiza código post-tests
- No detecta duplicación

---

## v1.1: Test Code Generation (Próximo Release)

### Objetivo

Eliminar templates y generar código completo de tests.

### Features

**1.1.1: Smart Test Generation**

[PENDING] Generar código real en lugar de TODOs
- Analizar requisitos con NLP básico
- Extraer casos de prueba automáticamente
- Generar asserts basados en expected_behavior
- Soportar fixtures complejos

```python
# Antes (v1.0 - Template)
def test_happy_path(self, agent):
 """Test: Caso exitoso básico."""
 # TODO: Implement
 pytest.skip("Not implemented yet")

# Después (v1.1 - Código generado)
def test_happy_path(self, agent):
 """Test: ViewSet con permission_classes se considera válido."""
 view_file = self.create_viewset_with_permissions()
 violations = agent._analyze_file(view_file, self.tmp_path)
 assert len(violations) == 0, "ViewSet con permisos no debe tener violaciones"
```

**1.1.2: Improved Pytest Parsing**

[PENDING] Usar pytest-json-report para parsing robusto
- Instalar pytest-json-report como dependencia
- Parsear JSON en lugar de text
- Extraer stack traces completos
- Obtener líneas exactas de errores

```python
# Antes
result = subprocess.run(["pytest", str(test_file), "-v", "--tb=short"])
# Parsing con regex del stdout

# Después
result = subprocess.run(["pytest", str(test_file), "-v", "--json-report", "--json-report-file=result.json"])
with open("result.json") as f:
 data = json.load(f)
 for test in data["tests"]:
 if test["outcome"] == "failed":
 extract_full_traceback(test)
```

**1.1.3: Auto-Fix Common Errors**

[PENDING] Corregir errores comunes automáticamente
- ImportError: Agregar imports faltantes
- FileNotFoundError: Crear directorios/archivos necesarios
- AttributeError: Sugerir alternativas
- NameError: Detectar typos

```python
def auto_fix_error(error_type: str, error_message: str, file_path: Path) -> bool:
 """Intenta corregir error automáticamente."""
 if error_type == "ImportError":
 # Extraer módulo faltante
 module = extract_module_from_error(error_message)
 # Agregar import al inicio del archivo
 add_import_to_file(file_path, module)
 return True

 if error_type == "FileNotFoundError":
 # Crear archivo/directorio faltante
 missing_path = extract_path_from_error(error_message)
 missing_path.parent.mkdir(parents=True, exist_ok=True)
 return True

 return False
```

### Criterios de Éxito v1.1

- [GOAL] 80% de tests generados sin TODOs
- [GOAL] Parsing de pytest 100% confiable
- [GOAL] Auto-fix de 50% de errores comunes

### Estimación

- Desarrollo: 3-5 días
- Testing: 2 días
- Documentación: 1 día
- Total: 6-8 días

---

## v2.0: LLM Integration (Future Release)

### Objetivo

Integrar LLM local para análisis semántico y generación contextual.

### Features

**2.0.1: Local LLM Integration**

[FUTURE] Integrar modelo local para análisis
- Usar llama.cpp o similar (sin dependencias externas)
- Ejecutar localmente (respetando restricción de no servicios externos)
- Modelo pequeño optimizado para código (CodeLlama 7B)

**2.0.2: Semantic Code Analysis**

[FUTURE] Analizar código con comprensión semántica
- Entender intención de requisitos en lenguaje natural
- Detectar edge cases implícitos
- Sugerir tests adicionales relevantes

```python
# Usuario escribe requisitos vagos
requirements = "El gate debe validar permisos correctamente"

# LLM extrae casos de prueba implícitos:
test_cases = llm.extract_test_cases(requirements)
# Resultado:
# - ViewSet sin permission_classes (error)
# - ViewSet con permission_classes vacío (error)
# - ViewSet con permission_classes = [AllowAny] (warning)
# - ViewSet con permission_classes = [IsAuthenticated] (warning)
# - ViewSet con permission_classes granulares (ok)
```

**2.0.3: Contextual Solution Suggestions**

[FUTURE] Sugerir soluciones basadas en contexto del proyecto
- Analizar código existente similar
- Detectar patrones del proyecto
- Generar soluciones consistentes con estilo

```python
# Error detectado:
# "ViewSet sin permission_classes"

# LLM analiza otros ViewSets del proyecto y sugiere:
solution = llm.suggest_solution(
 error="ViewSet sin permission_classes",
 context={"similar_viewsets": [...], "project_patterns": [...]}
)

# Resultado:
# "Agregar permission_classes = [VerificarPermisoGeneral]"
# (porque otros ViewSets del proyecto usan ese patrón)
```

**2.0.4: Requirements Refinement**

[FUTURE] Refinar requisitos vagos antes de generar tests
- Hacer preguntas clarificadoras
- Expandir casos edge implícitos
- Validar completitud de requisitos

```python
# Requisitos iniciales vagos
requirements = {
 "component": "audit_validator",
 "requirements": "Validar logs"
}

# LLM refina automáticamente:
refined = llm.refine_requirements(requirements)
# Resultado:
{
 "component": "audit_validator",
 "requirements": "Validar que logs de auditoría tengan campos requeridos",
 "expected_behavior": {
 "happy_path": "Log con todos los campos requeridos se acepta",
 "edge_cases": [
 "Log con campos opcionales missing",
 "Log con valores None en campos opcionales",
 "Log con timestamps en diferentes timezones"
 ],
 "error_cases": [
 "Log sin campo 'action'",
 "Log sin campo 'user_id'",
 "Log sin campo 'timestamp'"
 ]
 }
}
```

### Criterios de Éxito v2.0

- [GOAL] LLM local ejecutándose sin servicios externos
- [GOAL] 90% de tests generados son relevantes y completos
- [GOAL] Sugerencias de solución precisas en 70% de casos

### Restricciones Técnicas

- [IMPORTANT] No usar servicios externos (OpenAI API, Anthropic API, etc.)
- [IMPORTANT] Modelo debe ejecutarse localmente
- [IMPORTANT] Debe funcionar sin internet
- [IMPORTANT] Modelo < 10GB por restricciones de almacenamiento

### Estimación

- Investigación de modelos: 2 días
- Integración llama.cpp: 3 días
- Desarrollo features: 5-7 días
- Testing: 3 días
- Documentación: 2 días
- Total: 15-17 días

---

## v3.0: Zero-Intervention TDD (Vision)

### Objetivo

Ciclo TDD 100% autónomo sin intervención humana.

### Features

**3.0.1: Autonomous Code Implementation**

[VISION] Implementar código real automáticamente
- Generar implementación desde tests
- Ejecutar ciclo Red-Green-Refactor completo
- Validar corrección semántica

**3.0.2: Intelligent Refactoring**

[VISION] Refactorizar código post-tests
- Detectar duplicación
- Optimizar complejidad ciclomática
- Mejorar legibilidad
- Mantener cobertura 100%

**3.0.3: Coverage-Driven Test Expansion**

[VISION] Generar tests adicionales basados en coverage
- Detectar líneas sin coverage
- Generar tests para cubrir branches no testeados
- Expandir edge cases automáticamente

**3.0.4: Pattern Learning**

[VISION] Aprender de ciclos TDD previos
- Almacenar errores comunes y soluciones
- Detectar patrones de errores recurrentes
- Mejorar sugerencias con experiencia

```python
# Sistema aprende que en el proyecto:
# - Error "KeyError: message" ocurrió 3 veces
# - Solución siempre es "no pasar 'message' en extra dict"

# Próximo error similar se auto-corrige instantáneamente
pattern_db.learn(
 error_signature="KeyError.*message.*LogRecord",
 solution="Remove 'message' from extra dict"
)
```

**3.0.5: Multi-Cycle Orchestration**

[VISION] Orquestar múltiples ciclos TDD en paralelo
- Ejecutar TDD en múltiples componentes simultáneamente
- Detectar dependencias entre componentes
- Resolver dependencias en orden correcto

### Criterios de Éxito v3.0

- [GOAL] 95% de ciclos TDD completos sin intervención
- [GOAL] Código generado pasa code review humano en 80% de casos
- [GOAL] Refactoring automático mejora métricas de calidad

### Estimación

- Investigación: 5 días
- Desarrollo: 15-20 días
- Testing: 5 días
- Documentación: 3 días
- Total: 28-33 días

---

## Consideraciones de Implementación

### Dependencias Nuevas

**v1.1:**
- pytest-json-report (parsing robusto)
- ast (análisis de código Python - stdlib)

**v2.0:**
- llama-cpp-python (LLM local)
- transformers (opcional, para modelos HuggingFace)
- torch (backend para LLM)

**v3.0:**
- radon (métricas de complejidad)
- rope (refactoring automático)
- coverage.py (análisis de cobertura)

### Riesgos

**v1.1:**
- [RISK] Generación de tests incorrectos → Mitigar con validación humana inicial

**v2.0:**
- [RISK] LLM local demasiado lento → Mitigar con modelo pequeño optimizado
- [RISK] Modelo consume demasiada RAM → Mitigar con quantización

**v3.0:**
- [RISK] Código generado con bugs sutiles → Mitigar con validación semántica
- [RISK] Refactoring rompe comportamiento → Mitigar con tests de regresión

### Métricas de Éxito

| Versión | Autonomía | Precisión | Velocidad | Requisitos |
|---------|-----------|-----------|-----------|------------|
| v1.0 | 20% | 90% | Rápido | Mínimos |
| v1.1 | 50% | 85% | Rápido | Moderados |
| v2.0 | 70% | 80% | Medio | Altos |
| v3.0 | 95% | 75% | Lento | Muy altos |

Notas:
- **Autonomía**: % de ciclo TDD sin intervención humana
- **Precisión**: % de código/tests generados correcto
- **Velocidad**: Tiempo de ejecución relativo
- **Requisitos**: Recursos computacionales necesarios

---

## Casos de Uso por Versión

### v1.0 MVP (Actual)

**Mejor para:**
- Prototipado rápido de estructura de tests
- Documentación de errores descubiertos
- Proyectos donde desarrolladores implementan tests manualmente

**No recomendado para:**
- Proyectos que necesitan tests completos inmediatos
- Equipos sin experiencia en TDD

### v1.1

**Mejor para:**
- Generación rápida de tests completos
- Proyectos con convenciones claras
- Auto-corrección de errores simples

**No recomendado para:**
- Requisitos muy ambiguos
- Tests que requieren lógica compleja

### v2.0

**Mejor para:**
- Requisitos en lenguaje natural
- Proyectos con patrones complejos
- Tests que requieren análisis semántico

**No recomendado para:**
- Entornos con recursos limitados
- Proyectos que requieren respuesta inmediata

### v3.0

**Mejor para:**
- Automatización total de desarrollo
- Proyectos de larga duración
- Equipos que invierten en herramientas avanzadas

**No recomendado para:**
- Prototipos rápidos
- Proyectos con requisitos cambiantes constantemente

---

## Priorización

### Próximos 3 meses

1. **v1.1.1**: Test Code Generation (Priority: HIGH)
2. **v1.1.2**: Pytest-JSON parsing (Priority: HIGH)
3. **v1.1.3**: Auto-fix básico (Priority: MEDIUM)

### Próximos 6 meses

4. **v2.0.1**: Integración LLM local (Priority: MEDIUM)
5. **v2.0.2**: Semantic analysis (Priority: LOW)

### Próximos 12 meses

6. **v3.0**: Zero-intervention (Priority: FUTURE)

---

## Conclusión

El TDD Agent v1.0 MVP proporciona una base sólida para automatización TDD. Las versiones futuras expandirán capacidades hacia autonomía completa, pero cada versión debe:

1. **Mantener compatibilidad** con restricciones del proyecto
2. **No degradar performance** de versiones anteriores
3. **Documentar limitaciones** claramente
4. **Validar con casos reales** antes de release

**Próximo paso inmediato:** Implementar v1.1.1 (Test Code Generation)

---

**Documento generado por:** TDD Agent Foundation Team
**Última actualización:** 2025-11-11
**Versión:** 1.0
