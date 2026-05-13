```yml
type: Metodología Phase 4 — CONSTRAINTS
category: Delimitación del espacio de soluciones
version: 1.0
purpose: Guía para identificar y clasificar restricciones antes de diseñar la estrategia.
goal: Que Phase 5 STRATEGY explore únicamente soluciones que puedan implementarse.
updated_at: 2026-04-16
owner: workflow-constraints
```

# Constraints Methodology

## Propósito

Delimitar qué soluciones son posibles antes de elegir cuál es la mejor.
Sin restricciones claras, Phase 5 STRATEGY puede invertir tiempo en alternativas que no pueden ejecutarse.

> Un constraint documentado en Phase 4 vale más que uno descubierto en Phase 10.

---

## Cuándo usar Phase 4 CONSTRAINTS

| Situación | Usar CONSTRAINTS | Omitir (micro/pequeño) |
|-----------|:----------------:|:----------------------:|
| WP con decisiones de arquitectura | ✓ | — |
| Integración con sistemas externos regulados | ✓ | — |
| Cambios que afectan datos en producción | ✓ | — |
| Feature simple en stack conocido | — | ✓ |
| Bug fix acotado | — | ✓ |

---

## Tipos de restricciones

### HARD constraints

Condiciones no negociables. La solución que las viola no es una opción válida.

**Fuentes comunes:**
- Regulación legal o de compliance (GDPR, SOC2, HIPAA)
- SLAs contractuales con clientes
- Limitaciones del entorno (hosting, versiones de runtime fijas)
- Decisiones arquitectónicas anteriores (ADRs aprobados)
- Dependencias de sistemas que no se pueden cambiar

### SOFT constraints

Preferencias con peso. Violarlas tiene un coste — pero si el trade-off lo justifica, es aceptable.

**Fuentes comunes:**
- Estándares del equipo (linting, patrones de código)
- Preferencias de performance sin SLA formal
- Conveniencias de mantenimiento
- Consistencia con el resto de la base de código

---

## Proceso de identificación

### Paso 1 — Revisar el análisis de Phase 3

Los hallazgos de Phase 3 ANALYZE (causas raíz) generan restricciones directas.
Preguntas guía:
- ¿Qué causa raíz limita las opciones de solución?
- ¿Qué dependencias del sistema son inmutables?

### Paso 2 — Consultar stakeholders técnicos

No asumir restricciones — confirmarlas.
Preguntar explícitamente:
- "¿Qué no podemos cambiar?"
- "¿Qué debe ser verdad al final para que esto sea aceptable?"

### Paso 3 — Consultar ADRs anteriores

Revisar `.thyrox/context/decisions/` — las decisiones previas son restricciones actuales.

### Paso 4 — Distinguir HARD vs SOFT

Pregunta de clasificación: "Si necesitamos violar esta restricción para entregar, ¿puede aprobarse con autorización?"
- No (nunca): HARD
- Sí (con justificación): SOFT

---

## Anti-patrones

| Anti-patrón | Problema | Corrección |
|-------------|---------|-----------|
| Documentar restricciones asumidas sin verificar | Invalida el análisis | Confirmar con stakeholder o ADR |
| Mezclar HARD y SOFT en una lista | Oculta qué es negociable | Separar explícitamente |
| Restricciones vagas ("debe ser rápido") | No delimita el espacio | Cuantificar: "P95 < 200ms" |
| Listar restricciones sin impacto en diseño | Sin valor para Phase 5 | Documentar qué opciones elimina cada HC |

---

## Relación con otras fases

- **Phase 3 ANALYZE** — las causas raíz determinan qué restricciones técnicas son reales
- **Phase 5 STRATEGY** — opera solo dentro del espacio definido por Phase 4
- **Phase 8 PLAN EXECUTION** — el task-plan no puede asignar tareas que violen HCs

---

## Checklist de salida

- [ ] Al menos una HC documentada con origen verificado (no asumido)
- [ ] SCs clasificadas por peso
- [ ] Espacio de soluciones resultante explícito (opciones viables vs descartadas)
- [ ] Restricciones fuera de scope documentadas para evitar ambigüedad
