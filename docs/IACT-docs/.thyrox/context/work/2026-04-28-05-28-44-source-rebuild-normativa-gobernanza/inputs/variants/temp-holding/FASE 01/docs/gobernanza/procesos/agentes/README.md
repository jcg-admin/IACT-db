---
id: DOC-GOB-AGENTES
tipo: documentacion
categoria: gobernanza
version: 1.0.0
fecha_creacion: 2025-11-06
propietario: equipo-gobernanza
relacionados: ["DOC-GOB-CONSTITUTION-AI", "GUIA_ESTILO", "PROC-GUIA-FEATURES"]
date: 2025-11-13
---

# Agentes AI - Proyecto IACT

## Propósito

Documentación del sistema de agentes AI del proyecto IACT, incluyendo la constitution que guía sus decisiones y el framework de integración.

## Alcance

Esta documentación cubre:
- Constitution para agentes AI
- Framework de integración (constitution_loader.py, base.py)
- Agentes disponibles (16+ agentes especializados)
- Principios y guardrails
- Validaciones automáticas
- Límites de autoridad y escalación

---

## Agentes Disponibles

El proyecto IACT cuenta con **16+ agentes especializados** en dos categorías principales:

### Agentes de Testing (7 agentes)

Ubicación: `scripts/ai/agents/`

1. **CoverageAnalyzer**: Analiza cobertura de tests existente
2. **TestPlanner**: Genera plan de tests basado en código
3. **LLMGenerator**: Genera tests usando LLM
4. **SyntaxValidator**: Valida sintaxis de tests generados
5. **TestRunner**: Ejecuta tests y reporta resultados
6. **CoverageVerifier**: Verifica que cobertura cumple mínimo
7. **PRCreator**: Crea pull request con tests generados

### Agentes de Business Analysis (9 agentes)

Ubicación: `scripts/ai/agents/`

1. **BusinessAnalysisGenerator**: Genera análisis de negocio completo
2. **TraceabilityMatrixGenerator**: Genera matrices de trazabilidad ISO 29148
3. **CompletenessValidator**: Valida completitud de documentación
4. **TemplateGenerator**: Genera plantillas personalizables
5. **DocumentSplitter**: Divide documentos grandes en módulos
6. **BusinessAnalysisPipeline**: Orquesta flujo completo de análisis

Más agentes especializados en desarrollo activo.

**Documentación completa**: Ver `scripts/ai/agents/README_BUSINESS_ANALYSIS.md`

---

## Constitution

La **Constitution** (`constitution.md`) define 12 principios fundamentales que guían las decisiones de todos los agentes AI.

### Principios Fundamentales

#### 1. Calidad sobre Velocidad

La calidad del output es siempre prioritaria sobre la velocidad de ejecución.

**Validación automática**:
- Sin placeholders (TODO, FIXME, XXX, HACK)
- Documentación presente y completa
- Código completo y funcional

**Ejemplo de violación**:
```python
# BLOQUEADO - Contiene placeholder
def calcular_precio(producto):
    # TODO: implementar lógica de descuentos
    return producto.precio
```

#### 2. Adherencia a Estándares

Cumplimiento estricto de guías y estándares del proyecto.

**Documentos vinculantes**:
- `docs/gobernanza/GUIA_ESTILO.md`
- `docs/gobernanza/estandares_codigo.md`
- `docs/gobernanza/casos_de_uso_guide.md`

**Reglas críticas**:
- PROHIBIDO: Emojis en cualquier output
- OBLIGATORIO: Conventional Commits
- OBLIGATORIO: Type hints en Python
- OBLIGATORIO: Docstrings formato Google
- OBLIGATORIO: TDD (tests antes de código)

#### 3. Trazabilidad Completa

Todo artefacto generado debe ser trazable a su origen.

**Formato de trazabilidad**:
```python
"""
Implementa autenticación JWT.

Trazabilidad:
- Requisito: REQ-SEC-001
- Spec: docs/specs/authentication-jwt.md
- Issue: #45
- ADR: docs/arquitectura/adr/adr_2025_002_jwt.md
"""
```

**Validación automática**:
- Busca referencias REQ-*, SPEC-*, ADR-* en output
- Bloquea si no hay trazabilidad

#### 4. Límites de Autoridad

Los agentes tienen autoridad limitada y deben escalar cuando sea apropiado.

**Autoridad permitida** (sin escalación):
- Generar tests basados en código
- Generar documentación técnica
- Crear borradores de análisis
- Formatear código según estándares
- Ejecutar pre-commit hooks
- Crear matrices de trazabilidad

**Requiere escalación humana**:
- Cambios arquitectónicos
- Modificación de esquemas de BD
- Cambios en APIs públicas
- Eliminar código o archivos
- Modificar configuración de CI/CD
- Cambios de seguridad (auth, authorization)
- Cambios en dependencias core
- Merge a branches protegidas
- Decisiones de negocio

**Formato de escalación**:
```
ESCALACIÓN REQUERIDA

Agente: BusinessAnalysisGenerator
Razón: Cambio arquitectónico detectado
Acción propuesta: Modificar modelo User...
Impacto: Migración de BD, cambios en API

Requiere: Aprobación de arquitecto
```

#### 5. Documentación Obligatoria

Todo output debe estar documentado según estándares.

**Para código Python**:
- Docstrings formato Google
- Type hints completos
- Ejemplos de uso
- Trazabilidad explícita

**Para tests**:
- Caso de prueba (CP-XXX-XX)
- Criterio de aceptación (CA-XXX-XX)
- Given-When-Then

#### 6. Testing y Validación

Todo código generado debe incluir tests.

**Niveles requeridos**:
- Tests unitarios para funciones/métodos
- Tests de integración para APIs/BD
- Tests de contrato para APIs públicas

**Cobertura mínima**:
- Código crítico (seguridad, pagos): 90%
- Código de negocio: 80%
- Código de utilidades: 70%

**Criterio de completitud**:
- [ ] Todos los tests pasan
- [ ] Cobertura cumple mínimo
- [ ] Linters sin errores
- [ ] No secrets detectados
- [ ] No emojis
- [ ] Documentación completa
- [ ] Trazabilidad establecida

---

## Framework de Integración

### Constitution Loader

**Módulo**: `scripts/ai/agents/constitution_loader.py`

**Clases principales**:

#### Constitution

Carga y proporciona acceso a principios de la constitution.

```python
from constitution_loader import load_constitution

# Cargar constitution
constitution = load_constitution()

# Obtener principios
quality_principle = constitution.get_quality_principle()
traceability_principle = constitution.get_traceability_principle()

# Ver todos los principios
for principle in constitution.get_all_principles():
    print(f"{principle.number}. {principle.name}")
```

#### ConstitutionValidator

Valida adherencia a constitution.

```python
from constitution_loader import create_validator

validator = create_validator()

# Validar output
output_data = {"code": "...", "docs": "..."}

violations = validator.validate_all(output_data)
# Retorna: {"quality": [...], "traceability": [...], "emojis": [...], "testing": [...]}

# Validaciones específicas
emoji_violations = validator.validate_no_emojis(output_data)
trace_violations = validator.validate_traceability(output_data)

# Verificar autoridad
has_authority = validator.validate_authority_limits("modificar_arquitectura", {})
```

### Base Agent Class

**Módulo**: `scripts/ai/agents/base.py`

Todos los agentes heredan de `Agent` que proporciona:

#### Integración Automática de Constitution

```python
class MyAgent(Agent):
    def run(self, input_data):
        # Constitution ya está cargada en self.constitution
        # Validator ya está disponible en self.constitution_validator

        # Verificar autoridad antes de acción crítica
        if not self.check_authority("modificar_arquitectura"):
            return {"error": "Requiere escalación"}

        # Generar output...
        return output
```

#### Guardrails Automáticos

```python
# En Agent.execute():
# 1. Valida input
# 2. Ejecuta run()
# 3. Aplica guardrails (valida contra constitution)
# 4. Bloquea si hay violaciones

result = agent.execute(input_data)

if result.is_blocked():
    # Output violó constitution
    print(result.errors)
    # ["[emojis] Output contiene emojis",
    #  "[traceability] Output carece de trazabilidad"]
```

#### Método check_authority()

```python
# Verificar antes de acción crítica
if not agent.check_authority("cambiar_esquema_bd"):
    agent.logger.error("ESCALACIÓN REQUERIDA")
    return AgentResult(status=AgentStatus.BLOCKED)

# Continuar con acción permitida...
```

---

## Validaciones Automáticas

Cuando un agente ejecuta, se validan automáticamente:

### 1. Sin Emojis

**Qué valida**: Output no contiene emojis prohibidos

**Emojis buscados**: [x] [ ] [WARNING]      y 100+ más

**Alternativas**: Ver `docs/gobernanza/GUIA_ESTILO.md`

**Implementación**: Usa misma lógica que `scripts/check_no_emojis.py`

### 2. Trazabilidad

**Qué valida**: Output contiene referencias a requisitos

**Patrones buscados**:
- `REQ-XXX-NNN` (requisitos)
- `SPEC-XXX-NNN` (especificaciones)
- `ADR-YYYY-NNN` (decisiones arquitectónicas)

**Falla si**: No hay ninguna referencia

### 3. Calidad

**Qué valida**:
- Sin placeholders (TODO, FIXME, XXX, HACK, ...)
- Documentación presente (docstrings, comentarios)

**Falla si**: Código incompleto o sin documentar

### 4. Testing

**Qué valida**: Código incluye tests

**Patrones buscados**:
- `def test_*`
- `class Test*`
- `@pytest.mark.*`
- `assert`

**Falla si**: Código sin tests asociados

---

## Uso en Agentes

### Ejemplo Completo

```python
from base import Agent, AgentStatus, AgentResult
from typing import Dict, Any, List

class DocumentationGenerator(Agent):
    """
    Genera documentación técnica con validación de constitution.

    Trazabilidad: REQ-DOC-001
    """

    def run(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Genera documentación a partir de código.

        Args:
            input_data: {"code": str, "module_name": str}

        Returns:
            {"documentation": str, "toc": List[str]}
        """
        code = input_data["code"]
        module_name = input_data["module_name"]

        # Verificar autoridad para modificar docs
        if not self.check_authority("crear_documentacion"):
            self.logger.error("Sin autoridad para crear documentación")
            raise PermissionError("Escalación requerida")

        # Generar documentación
        documentation = self._generate_docs(code, module_name)

        # Asegurar trazabilidad
        documentation += "\n\nTrazabilidad: REQ-DOC-001\n"

        # Sin emojis, con documentación completa
        return {
            "documentation": documentation,
            "toc": self._generate_toc(documentation)
        }

    def _custom_guardrails(self, output_data: Dict[str, Any]) -> List[str]:
        """Validaciones adicionales específicas."""
        errors = []

        # Verificar que hay tabla de contenidos
        if not output_data.get("toc"):
            errors.append("Documentación debe incluir tabla de contenidos")

        return errors

# Uso
agent = DocumentationGenerator()
result = agent.execute({"code": "...", "module_name": "auth"})

if result.is_success():
    print("Documentación generada y validada")
elif result.is_blocked():
    print(f"Bloqueado por guardrails: {result.errors}")
```

### Flujo de Ejecución

```
1. agent.execute(input_data)
   ↓
2. Carga constitution (si no está cargada)
   ↓
3. agent.validate_input(input_data)
   ↓
4. agent.run(input_data)  # Lógica del agente
   ↓
5. agent.apply_guardrails(output_data)
   ├─ validator.validate_no_emojis()
   ├─ validator.validate_traceability()
   ├─ validator.validate_quality_over_speed()
   ├─ validator.validate_testing()
   └─ agent._custom_guardrails()
   ↓
6. Si hay violaciones → AgentStatus.BLOCKED
   Si todo OK → AgentStatus.SUCCESS
```

---

## Tests de Constitution

**Ubicación**: `scripts/ai/agents/test_constitution_integration.py`

**Cobertura**:
- Carga de constitution
- Validadores individuales
- Integración con Agent base class
- Tests marcados como `@pytest.mark.critical` para pre-push hook

**Ejecutar tests**:
```bash
# Todos los tests
pytest scripts/ai/agents/test_constitution_integration.py -v

# Solo tests críticos
pytest scripts/ai/agents/test_constitution_integration.py -m critical

# Con cobertura
pytest scripts/ai/agents/test_constitution_integration.py --cov=scripts/ai/agents
```

---

## Troubleshooting

### "Constitution loader no disponible"

**Problema**: `constitution_loader.py` no se encuentra

**Solución**:
```bash
# Verificar que existe
ls scripts/ai/agents/constitution_loader.py

# Verificar imports
python -c "from scripts.ai.agents.constitution_loader import load_constitution"
```

### "No se pudo cargar constitution"

**Problema**: Archivo `constitution.md` no existe o está corrupto

**Solución**:
```bash
# Verificar que existe
ls docs/gobernanza/agentes/constitution.md

# Verificar formato markdown
head -20 docs/gobernanza/agentes/constitution.md
```

### Agente bloquea output válido

**Problema**: Falso positivo en validaciones

**Solución**: Override `_custom_guardrails()` para relajar validaciones específicas

```python
def _custom_guardrails(self, output_data):
    # No aplicar validación de tests para docs
    return []
```

---

## Evolución y Mantenimiento

### Agregar Nuevo Principio

1. Editar `docs/gobernanza/agentes/constitution.md`
2. Agregar sección `### N. Nombre del Principio`
3. Documentar principio, aplicación, ejemplos
4. Actualizar `constitution_loader.py` si se requiere validación específica
5. Agregar tests en `test_constitution_integration.py`
6. Incrementar versión de constitution

### Modificar Validaciones

1. Editar `scripts/ai/agents/constitution_loader.py`
2. Modificar método `validate_*()` correspondiente
3. Actualizar tests
4. Commit con mensaje descriptivo

### Actualizar Límites de Autoridad

1. Editar lista `requires_escalation` en `ConstitutionValidator.validate_authority_limits()`
2. Actualizar documentación
3. Comunicar cambios a desarrolladores

---

## Referencias

- **Constitution completa**: [`constitution.md`](constitution.md)
- **Constitution loader**: `scripts/ai/agents/constitution_loader.py`
- **Base agent class**: `scripts/ai/agents/base.py`
- **Tests de integración**: `scripts/ai/agents/test_constitution_integration.py`
- **Guía de estilo**: [`../../GUIA_ESTILO.md`](../../GUIA_ESTILO.md)
- **Agentes de Business Analysis**: `scripts/ai/agents/README_BUSINESS_ANALYSIS.md`
- **Plantillas de desarrollo**: [`../../plantillas/desarrollo/`](../../plantillas/desarrollo/)

---

**Última actualización**: 2025-11-06
**Versión**: 1.0.0
**Mantenido por**: equipo-gobernanza
