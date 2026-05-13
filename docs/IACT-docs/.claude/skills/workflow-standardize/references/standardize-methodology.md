```yml
type: Metodología Phase 12 — STANDARDIZE
category: Cierre y estandarización
version: 1.0
purpose: Guía para consolidar aprendizajes en patrones reutilizables y cerrar el WP formalmente.
goal: Que el conocimiento generado en este WP mejore los siguientes — no se pierda con el commit.
updated_at: 2026-04-16
owner: workflow-standardize
```

# Standardize Methodology

## Propósito

Convertir el conocimiento generado en un WP en patrones reutilizables y cerrar el ciclo formalmente.

> STANDARDIZE no es "hacer un resumen". Es extraer lo que funcionó, generalizar la forma, y dejarlo disponible para el siguiente WP.

---

## Cuándo usar Phase 12 STANDARDIZE

| Situación | Usar STANDARDIZE | Omitir (micro/pequeño) |
|-----------|:----------------:|:----------------------:|
| WP con decisiones arquitectónicas nuevas | ✓ | — |
| WP que introdujo un patrón de código repetible | ✓ | — |
| WP con métricas de éxito (comparar baseline) | ✓ | — |
| Bug fix aislado sin impacto estructural | — | ✓ |
| Documentación menor | — | ✓ |

---

## Proceso de estandarización

### Paso 1 — Revisar lecciones aprendidas (Phase 11)

El input de STANDARDIZE es el artefacto de Phase 11 TRACK/EVALUATE.
Identificar qué decisiones merecen ser patrones:
- ¿Se puede nombrar la solución? (si no tiene nombre, no es un patrón todavía)
- ¿Aplica a más de un contexto futuro?
- ¿Tiene consecuencias conocidas — beneficios y trade-offs?

### Paso 2 — Extraer patrones

Un patrón tiene cuatro partes obligatorias:
1. **Nombre**: identificable y memorable
2. **Contexto + Problema**: cuándo y por qué se necesita
3. **Solución**: estructura concreta (no vaga)
4. **Consecuencias**: qué ganas y qué sacrificas

Usar `assets/patterns.md.template`.

### Paso 3 — Comparar métricas finales contra baseline

Si el WP tuvo Phase 2 MEASURE, documentar el delta real en `final-report.md`.

**Anti-patrón**: afirmar "mejoró" sin el número. Si no se midió, decir "no se midió" — no inventar.

### Paso 4 — Cerrar artefactos vivos

| Artefacto | Acción de cierre |
|-----------|-----------------|
| `risk-register.md` | Marcar riesgos materializados. Archivar los no ocurridos. |
| `technical-debt.md` | Mover TDs resueltos. Registrar TDs nuevas. |
| `ROADMAP.md` | Marcar FASE como `DONE`. |
| `now.md` | Limpiar estado de sesión. |

### Paso 5 — Commit de cierre

```
chore(standardize): cierre FASE N — {nombre-wp}
```

---

## Relación con otras fases

- **Phase 11 TRACK/EVALUATE** produce lecciones — STANDARDIZE las convierte en patrones
- **Phase 1 DISCOVER del siguiente WP** consulta los patrones de este WP antes de analizar
- **`constitution.md`** puede actualizarse si el patrón es un principio fundacional del proyecto

---

## Checklist de salida

- [ ] `patterns.md` creado con al menos un patrón concreto (o nota explícita "sin patrones")
- [ ] `final-report.md` con métricas baseline vs resultado
- [ ] `ROADMAP.md` con esta FASE marcada como completada
- [ ] `risk-register.md` actualizado con estado de cierre
- [ ] `now.md` limpiado
- [ ] Commit de cierre con formato `chore(standardize): cierre FASE N`
