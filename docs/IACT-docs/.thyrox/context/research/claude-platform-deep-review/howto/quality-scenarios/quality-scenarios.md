---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: quality-scenarios
---

# Quality Scenarios — Claude Code How-To

## Patrones

### Patrón 1: Escenarios de uso completos como unidad de documentación

El repo documenta features a través de escenarios end-to-end, no solo referencia de API. `planning-mode-examples.md` tiene 5 escenarios completos (REST API, DB migration, frontend refactoring, security implementation, performance optimization) con: contexto del problema, plan generado, métricas objetivo, criterios de éxito. Los escenarios son la forma de documentación de mayor valor en el repo.

Fuente: `09-advanced-features/planning-mode-examples.md`, todos los ejemplos.

### Patrón 2: Checkpoint scenarios con casos de uso reales

El `08-checkpoints/checkpoint-examples.md` tiene 8 escenarios reales:
1. Database migration con rewind a estado previo
2. Performance optimization con comparación de variantes
3. UI iteration con múltiples experimentos
4. Debugging con retroceso al punto de quiebre
5. API design con exploración de alternativas
6. Config management con snapshot antes de cambios peligrosos
7. Test strategy con comparación de approaches
8. Summarize workflow para comprimir contexto antes de trabajo intenso

Cada escenario tiene el workflow exacto de comandos a ejecutar.

Fuente: `08-checkpoints/checkpoint-examples.md`, todos los ejemplos.

### Patrón 3: Subagent recipes como patrones de orquestación

Los subagentes documentados son recipes completos para casos de uso específicos:
- `code-reviewer.md`: revisar código con "use PROACTIVELY" — activación automática en cada cambio
- `debugger.md`: debugging con proceso de 5 pasos (reproduce → isolate → hypothesize → test → fix)
- `secure-reviewer.md`: security review read-only con patterns OWASP
- `test-engineer.md`: testing multi-capa con targets de cobertura (80% general, 100% critical paths)
- `implementation-agent.md`: implementación full-stack con todos los tools

Son patrones de orquestación reutilizables, no solo ejemplos.

Fuente: `04-subagents/`, todos los archivos de subagentes.

### Patrón 4: Hook examples con código Python funcional

Los ejemplos de hooks en `06-hooks/README.md` son código Python funcional listo para usar:
- Validación de mensaje de commit antes del commit
- Security scanner que bloquea operaciones riesgosas
- Context tracker que registra uso de tokens
- Notificador de Discord al completar tareas largas

Cada ejemplo tiene el código completo, no pseudocódigo.

Fuente: `06-hooks/README.md`, sección Examples.

### Patrón 5: "Before/After" como patrón narrativo de calidad

El planning-mode-examples.md usa explícitamente el patrón "Without Planning Mode" vs "With Planning Mode" para ilustrar el valor. Los checkpoints ejemplifican "estado antes vs estado después del rewind". El código de clean-code-rules usa before/after para cada regla. El patrón narrativo before/after es el mecanismo pedagógico principal del repo.

Fuente: `09-advanced-features/planning-mode-examples.md`, sección Example 1; `clean-code-rules.md`.

### Patrón 6: Métricas concretas como criterios de calidad

Los escenarios de planning mode incluyen métricas específicas:
- Performance: LCP <2.5s, FID <100ms, CLS <0.1
- Coverage: 80%+ general, 100% critical paths
- Timeline: estimaciones de tiempo por fase
- Impact: "Expected Impact: -40% load time"

Los criterios de éxito son numéricos cuando es posible, no descriptivos vagos.

Fuente: `09-advanced-features/planning-mode-examples.md`, Example 5; `04-subagents/test-engineer.md`.

## Conceptos

- **Scenario-driven documentation**: documentar por casos de uso reales, no por referencia de API
- **Before/after narrative**: patrón pedagógico para mostrar valor de features
- **Recipe pattern**: artefactos reutilizables para casos de uso recurrentes
- **Quantified success criteria**: métricas numéricas en lugar de criterios vagos
- **Multi-phase workflows**: escenarios organizados en fases con estimaciones de tiempo

## Notas

El repo invierte proporcionalmente más en escenarios y ejemplos completos que en referencia técnica pura. Esto es una decisión de calidad pedagógica: un desarrollador aprende más de un caso de uso completo que de una lista de parámetros. Esta ratio de "ejemplos vs referencia" es un dato importante para evaluar la calidad de documentación del proyecto THYROX.
