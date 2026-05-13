```yml
type: Metodología Phase 6 — PLAN
category: Definición de scope
version: 1.0
purpose: Guía para delimitar el scope del WP con in-scope y out-of-scope explícitos.
goal: Que Phase 7 y Phase 8 trabajen sobre un scope acordado — sin expansión implícita.
updated_at: 2026-04-16
owner: workflow-plan
```

# Scope Definition

## Propósito

Convertir la estrategia aprobada en un acuerdo concreto sobre qué entra y qué no entra en este WP.

> "Todo lo que no está explícitamente en scope está fuera de scope" — no al revés.

---

## Por qué definir scope antes de descomponer

Sin scope aprobado, Phase 8 PLAN EXECUTION puede:
- Crear tareas para cosas que el stakeholder no espera
- Omitir tareas que el stakeholder sí espera
- Expandirse al descubrir trabajo relacionado durante ejecución

El scope es el contrato entre quien diseña y quien aprueba.

---

## Componentes del scope

### In-scope

Lo que ESTE WP entrega. Criterio: si no está listado aquí, no se hace en este WP.

Formato válido:
```
- [Funcionalidad o cambio concreto] — [criterio de completitud observable]
```

Ejemplo:
```
- Migración de tabla `users` a nueva estructura — todos los registros migrados, sin pérdida de datos, tests verdes
- Endpoint POST /api/users actualizado — acepta nuevo formato, backward-compatible con clientes existentes
```

### Out-of-scope

Lo que NO se hace en este WP, aunque esté relacionado. Sin esta lista, el scope crece por defecto.

Formato válido:
```
- [Funcionalidad relacionada] — [razón de exclusión]
```

Ejemplo:
```
- Migración de tabla `organizations` — se hace en FASE N+1, scope separado
- Actualización de clientes externos — fuera del control de este equipo
```

### Dependencias externas

Lo que este WP necesita pero no controla. Documentar para evitar bloqueos durante Phase 10.

```
- [Dependencia] — [estado actual] — [owner]
```

---

## Cómo detectar scope creep

Señales durante Phase 8-10 de que el scope se está expandiendo:
- Una tarea T-NNN no tiene trazabilidad a ningún item del in-scope
- Se descubre trabajo "que debería hacerse ya que estamos"
- Una tarea tiene duración estimada mayor al 25% del WP total

**Acción**: pausar y decidir explícitamente si ampliar el scope (requiere aprobación) o crear un nuevo WP.

---

## Relación con ROADMAP.md

Cada item del in-scope debe tener un checkbox en ROADMAP.md al nivel correcto:

```markdown
### FASE N — [nombre-wp]
- [ ] [item in-scope 1]
- [ ] [item in-scope 2]
```

El ROADMAP no es el task-plan — es el estado visible de alto nivel para stakeholders.

---

## Checklist de salida

- [ ] In-scope con criterios de completitud observables (no vagos)
- [ ] Out-of-scope lista al menos 2-3 exclusiones relevantes
- [ ] Dependencias externas documentadas con owner
- [ ] ROADMAP.md actualizado con los items de in-scope
- [ ] Gate 6→7 aprobado por stakeholder antes de Phase 7
