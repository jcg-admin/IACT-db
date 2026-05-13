```yml
type: Referencia PHASE 1: ANALYZE
category: Análisis
version: 1.0
purpose: Guía de cómo identificar y documentar QUIÉN usa el sistema y QUÉ necesita.
goal: Asegurar que todas las necesidades de stakeholders estén consideradas.
updated_at: 2026-03-25
owner: workflow-discover
```

# Stakeholders

## Propósito

Guía de cómo identificar y documentar QUIÉN usa el sistema y QUÉ necesita.

> Objetivo: Asegurar que todas las necesidades de stakeholders estén consideradas.

---

## Estructura Pura de Stakeholders

### Matriz de Stakeholders

**Formato:**
```
Role | Description | Goal / Intention
-----|-------------|------------------
```

#### 1. Role (Rol)

Nombre del rol/stakeholder (NO nombres de personas)

**Ejemplos buenos:**
```
- Documentation author
- Software developer
- System administrator
- End user
- Product manager
- QA tester
- Security officer
```

**Ejemplos malos:**
```
- Juan (es una persona, no un rol)
- Management (muy vago)
- The guys who use it (muy informal)
```

#### 2. Description (Descripción)

Quiénes son, qué hacen

**Características:**
- Conciso pero informativo
- Contexto de cómo interactúan con el sistema
- Rol ocupacional o funcional

**Ejemplo:**
```
"Writes documentation with HTML output"
"Uses architecture docs for documentation"
"Implements the ecommerce platform"
```

#### 3. Goal / Intention (Meta/Intención)

Qué espera o necesita del sistema

**Características:**
- Comenzar con verbo de necesidad (Wants, Needs, Requires)
- Específico y observable
- Orientado a beneficio
- Diferente para cada rol

**Ejemplo:**
```
"Wants to check that links and images are valid"
"Wants a practical example of how to apply architecture documentation"
"Wants to understand architecture decisions"
```

---

## Tipos de Stakeholders

### 1. Usuarios Finales
```
Role: End user / Customer
Description: Uses the application
Goal: Complete tasks efficiently, good experience
```

### 2. Desarrolladores
```
Role: Software developer
Description: Implements the architecture
Goal: Understand design decisions, easy to implement
```

### 3. Arquitectos
```
Role: Architect / System architect
Description: Makes architectural decisions
Goal: Trade-offs clear, decisions documented
```

### 4. Administradores
```
Role: System administrator
Description: Maintains and operates the system
Goal: Easy to deploy, monitor, troubleshoot
```

### 5. Gestores
```
Role: Project manager / Product manager
Description: Manages project/product timeline
Goal: Realistic timelines, clear requirements
```

### 6. Otros Roles
```
Role: QA tester
Role: Technical writer
Role: Security officer
Role: Data analyst
etc.
```

---

## Matriz Extendida (Opcional)

Si necesitas más información:

```
Role | Description | Goal | Priority | Contact
-----|-------------|------|----------|--------
     |             |      |          |
```

---

## Relación entre Stakeholders y Quality Goals

Los Quality Goals deben satisfacer necesidades de stakeholders:

```
Stakeholder             Quality Goal Derivado
─────────────────────────────────────────────

End User / Shopper  →   Security (safe payments)
                    →   Correctness (right prices)
                    →   Performance (fast checkout)

System Admin        →   Reliability (99.9% uptime)
                    →   Maintainability (easy updates)
                    →   Scalability (handle load)

Security Officer    →   Security (encrypt data)
                    →   Compliance (meet standards)
```

---

## Ejemplo: Ecommerce

```
Role | Description | Goal / Intention
-----|-------------|------------------

End User / Shopper
"Browses products and completes purchases"
| "Complete purchases quickly and securely"

Product Manager
"Manages ecommerce strategy and features"
| "Clear product vision, realistic timelines"

Software Developer
"Implements the ecommerce platform"
| "Understand architecture, easy to implement"

System Administrator
"Operates and maintains the platform"
| "Easy deployment, monitoring, troubleshooting"

QA Tester
"Tests functionality and quality"
| "Clear test scenarios, reproducible bugs"

Security Officer
"Ensures security compliance"
| "Clear security architecture, data protection"

DevOps Engineer
"Manages deployment and infrastructure"
| "Automated, reliable deployment pipeline"

Data Analyst
"Analyzes user behavior and sales"
| "Access to analytics data, easy reporting"
```

---

## Conflictos y Trade-offs

A menudo los stakeholders tienen metas que entran en conflicto:

```
Developer: "Quiere arquitectura simple, fácil de implementar"
      ↓
   CONFLICT
      ↓
Security Officer: "Necesita arquitectura robusta con validaciones"

Resolución:
→ Priority 1: Security
→ Arquitectura segura pero mantenible
→ Developer implementa con buena documentación
```

```
End User: "Quiere máxima privacidad"
      ↓
   CONFLICT
      ↓
Data Analyst: "Necesita datos para analytics"

Resolución:
→ Priority 1: Privacy
→ Anonimizar datos para analytics
→ User opt-in para analytics específicos
```

---

## Checklist para Stakeholders

### Contenido
- [ ] Todos los stakeholders identificados
- [ ] Roles claros y específicos
- [ ] Descripciones concisas
- [ ] Metas claramente articuladas
- [ ] Metas verificables
- [ ] Diferentes para cada rol

### Estructura
- [ ] Matriz consistente
- [ ] Roles ocupacionales (no nombres)
- [ ] Lenguaje consistente
- [ ] Completitud
- [ ] Prioridad clara (si aplica)

### Alineamiento
- [ ] Conectado a Quality Goals (1.2)
- [ ] Conectado a Requirements (1.1)
- [ ] Conflictos identificados
- [ ] Trade-offs resueltos

---

## Errores Comunes a Evitar

### [ERROR] NO hacer:
```
- Usar nombres de personas ("Juan, María")
- Stakeholders demasiado genéricos ("Management")
- Metas vagas ("wants good documentation")
- Demasiados stakeholders (pierde enfoque)
- Stakeholders contradictorios sin resolución
- Olvidar roles importantes (Security, QA)
- Metas imposibles de verificar
```

### HACER:
```
- Usar roles ocupacionales
- Específico y medible
- Varios stakeholders si aplica
- Metas claras y verificables
- Resolver conflictos
- Prioridades explícitas
- Conectar a Quality Goals
```

---

## Template para Stakeholders

Usar: [stakeholders.md.template](../assets/stakeholders.md.template)

**Estructura del documento:**
```
# Stakeholders: [Nombre del proyecto]

## Matriz de Stakeholders
[Tabla con Role | Description | Goal]

## Descripción Detallada de Cada Rol
Para cada stakeholder principal:
- Quién es
- Qué hace
- Qué necesita

## Conflictos y Trade-offs
[Resolver conflictos entre stakeholders]

## Alineamiento con Quality Goals
[Qué Quality Goals satisfacen necesidades]

## Validación
[Checklist]
```

---

## Próximo Paso

Una vez completado: → Pasar a [basic-usage](./basic-usage.md)

---

**Última actualización**: 2026-02-01
