```yml
type: Referencia PHASE 1: ANALYZE
category: Análisis
version: 1.0
purpose: Guía de cómo definir objetivos de calidad priorizados (Critical, Important, Desirable).
goal: Especificar QUÉ TAN BIEN debe funcionar el sistema con scenarios medibles.
updated_at: 2026-03-25
owner: workflow-discover
```

# Quality Goals

## Propósito

Guía de cómo definir objetivos de calidad priorizados (Critical, Important, Desirable).

> Objetivo: Especificar QUÉ TAN BIEN debe funcionar el sistema con scenarios medibles.

---

## Estructura Pura de Quality Goals

### Elementos Clave

#### 1. Prioridad

Las calidades se organizan por importancia:

```
Priority 1 (Crítica)    → Non-negotiable (sin esta, sistema falla)
Priority 2 (Importante) → Afecta usabilidad/mantenimiento
Priority 3 (Deseable)   → Mejora pero no esencial
```

#### 2. Quality Attribute

El atributo de calidad específico:

**Categorías comunes:**
- **Correctness** - Funciona como se especifica
- **Reliability** - Funciona consistentemente
- **Performance** - Responde en tiempo
- **Scalability** - Crece con demanda
- **Security** - Protege datos
- **Maintainability** - Fácil de modificar
- **Usability** - Fácil de usar
- **Flexibility** - Adaptable a cambios
- **Safety** - No causa daño

#### 3. Scenario

El escenario que mide ese atributo:

**Formato:**
```
"[Subject] [action] [result]"

Ejemplo: "Every broken internal link is found and reported"
```

**Características:**
- Verificable/medible
- Concreto y específico
- Describe situación real de uso
- Prueba el atributo de calidad

---

## Estructura Recomendada

### Matriz Estructurada

```
Priority | Quality Goal | Scenario
---------|--------------|----------
1        | Correctness  | Every [action] is [result]
2        | Performance  | [Action] completes in [time]
3        | Flexibility  | [System] supports [change]
```

---

## Ejemplo: Ecommerce

### Priority 1: Critical

```
| Quality Goal | Scenario |
|--------------|----------|
| Correctness  | Every product price is correctly calculated in cart |
| Security     | Payment data is encrypted end-to-end |
| Reliability  | 99.9% of transactions process without error |
```

### Priority 2: Important

```
| Quality Goal | Scenario |
|--------------|----------|
| Performance  | Product search returns results in under 2 seconds |
| Scalability  | System handles 10,000 concurrent users |
| Usability    | New user completes registration in under 3 minutes |
```

### Priority 3: Desirable

```
| Quality Goal | Scenario |
|--------------|----------|
| Performance  | Mobile app loads products in under 1 second on 4G |
| Flexibility  | New payment methods can be added without code changes |
```

---

## Trade-offs Comunes

En Quality Goals, a menudo hay tensiones:

```
Performance vs Flexibility
  → Más flexible = más lento
  → Prioridad: elegir una

Security vs Usability
  → Más seguro = más pasos
  → Prioridad: balance

Scalability vs Simplicity
  → Más escalable = más complejo
  → Prioridad: qué importa más
```

---

## Relación con Otras Secciones

**Quality Goals (1.2) vs Requirements (1.1):**
- Requirements: "Sistema valida HTML"
- Quality Goals: "TODOS los errores son encontrados"

**Quality Goals (1.2) vs Constraints (2):**
- Quality Goals: Objetivos de qué tan bien
- Constraints: Limitaciones técnicas/organizacionales

**Quality Goals (1.2) vs Solution Strategy (3):**
- Quality Goals: Qué tan bien
- Solution Strategy: Cómo lograr eso arquitectónicamente

---

## Checklist para Quality Goals

### Contenido
- [ ] Prioridades claras (1, 2, 3)
- [ ] Quality attributes bien definidos
- [ ] Scenarios específicos y verificables
- [ ] Scenarios medibles
- [ ] No confundir con requisitos de proyecto

### Estructura
- [ ] Matriz Priority | Quality | Scenario
- [ ] Organizados por prioridad
- [ ] Lenguaje consistente
- [ ] Claridad
- [ ] Completitud

### Trazabilidad
- [ ] Conectado a Requirements (1.1)
- [ ] Conectado a Constraints (2)
- [ ] Impacto en arquitectura identificado

---

## Errores Comunes a Evitar

### [ERROR] NO hacer:
```
- Quality Goals vagos ("sistema debe ser bueno")
- No verificables ("será muy rápido")
- Confundir con requisitos de proyecto ("hacer login en sprint 3")
- Demasiados Priority 1 (todo no puede ser crítico)
- Scenarios no medibles
- Ignorar trade-offs
```

### HACER:
```
- Prioridades claras y justificadas
- Scenarios concretos y medibles
- Enfocados en atributos de calidad
- Independientes del proyecto
- Guían decisiones arquitectónicas
- Reconocer trade-offs
```

---

## Template para Quality Goals

Usar: [quality-goals.md.template](../assets/quality-goals.md.template)

**Estructura del documento:**
```
# Quality Goals: [Nombre del proyecto]

## Priority 1 (Critical)
[Tabla con atributo y scenario]

## Priority 2 (Important)
[Tabla con atributo y scenario]

## Priority 3 (Desirable)
[Tabla con atributo y scenario]

## Trade-offs
[Decisiones entre objetivos conflictivos]

## Validación
[Checklist]
```

---

## Próximo Paso

Una vez completado: → Pasar a [stakeholders](./stakeholders.md)

---

**Última actualización**: 2026-02-01
