# Agentic System Design — Referencia Stage 5 STRATEGY

> On-demand. Usar cuando el WP construye o diseña un sistema donde un agente toma decisiones autónomas.

## Qué hace a un sistema "agentic"

Un sistema es agentic cuando cumple mínimo 3 de estas 5 propiedades:
1. **Autonomía:** toma decisiones sin aprobación explícita en cada paso
2. **Percepción:** lee estado del entorno (archivos, APIs, herramientas)
3. **Acción:** modifica el entorno (escribe, crea, llama APIs)
4. **Goal-orientation:** tiene un objetivo que persiste entre invocaciones
5. **Razonamiento:** justifica decisiones (LLM con chain-of-thought o similar)

## Agente-como-herramienta vs Agente-como-arquitectura

| Dimensión | Agente-como-herramienta | Agente-como-arquitectura |
|-----------|------------------------|--------------------------|
| Scope | Una función específica | Flujo completo de trabajo |
| State | Stateless entre calls | Persiste estado entre sesiones |
| Decision | Predefinida por el caller | Autónoma dentro de constraints |
| Error | Propaga al caller | Maneja internamente con fallback |

## Preguntas de Stage 5 STRATEGY para WPs agentic

1. ¿El agente tiene un mecanismo de decisión real o solo llama una API?
2. ¿Cómo persiste el estado entre invocaciones? (git, DB, archivos)
3. ¿Qué herramientas puede usar y con qué scope? (bound-detector)
4. ¿Cuándo escala a humano (HITL real, no decorativo)?
5. ¿Cómo se verifica que el output es correcto? (agentic-validator)

## Exit criteria adicionales Stage 5 para sistemas agentic

- [ ] La estrategia especifica el mecanismo de decisión del agente (no solo el código que lo rodea)
- [ ] Está definido el scope de herramientas (AP-01..AP-30 como checklist)
- [ ] Está definido el protocolo HITL (interrupt/resume real — AP-16, AP-17)
- [ ] Está definida la observabilidad (logging, state tracking — AP-13..AP-15)

## Criterios Stage 3 DIAGNOSE para gaps en sistemas agentic

Para WPs que diagnostican un sistema agentic, verificar:
- Callbacks con contratos correctos (AP-01, AP-02)
- Type contracts en outputs de agentes (AP-03..AP-06)
- Temperatura correcta en clasificadores (AP-07, AP-08)
- Error handling en outputs LLM (AP-09..AP-12)
- HITL real vs decorativo (AP-16, AP-17)
