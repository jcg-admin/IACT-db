```yml
type: Metodología Phase 9 — PILOT/VALIDATE
category: Validación de supuestos
version: 1.0
purpose: Guía para diseñar y ejecutar PoCs que validen supuestos técnicos antes de Phase 10.
goal: Reducir riesgo de Phase 10 descubriendo problemas cuando son baratos de resolver.
updated_at: 2026-04-16
owner: workflow-pilot
```

# Pilot Methodology

## Propósito

Validar con el mínimo esfuerzo los supuestos técnicos de alto riesgo antes de iniciar Phase 10 EXECUTE.

> Un piloto no construye el sistema — prueba que el sistema puede construirse.

---

## Cuándo usar Phase 9 PILOT/VALIDATE

| Situación | Usar PILOT | Omitir |
|-----------|:----------:|:------:|
| Integración con API externa desconocida | ✓ | — |
| Tecnología nueva en el stack | ✓ | — |
| Migración con datos en producción | ✓ | — |
| Supuesto de performance sin benchmark | ✓ | — |
| Feature estándar en stack conocido | — | ✓ |
| Bug fix con causa raíz identificada | — | ✓ |
| Refactoring sin cambio de comportamiento | — | ✓ |

**Regla de decisión**: Si hay ≥1 supuesto que de ser falso invalidaría el plan de Phase 8, usar PILOT.

---

## Diseño del piloto

### Paso 1 — Identificar supuestos críticos

Del task-plan de Phase 8, extraer las tareas marcadas con alto riesgo o incertidumbre técnica.
Para cada una, formular el supuesto como hipótesis falsificable:

```
MAL: "Asumo que la API de X funciona bien"
BIEN: "H-001: La API de X soporta paginación con cursor y devuelve resultados consistentes bajo 500ms para datasets de 10k registros"
```

### Paso 2 — Priorizar por riesgo × coste

| Cuadrante | Acción |
|-----------|--------|
| Alto riesgo + bajo coste de validar | Validar siempre |
| Alto riesgo + alto coste de validar | Validar primero — puede cambiar el plan |
| Bajo riesgo + bajo coste | Opcional |
| Bajo riesgo + alto coste | Omitir — no justifica |

### Paso 3 — Diseñar el PoC mínimo

Reglas del PoC:
1. **Scope mínimo**: solo lo necesario para responder la hipótesis
2. **Sin producción**: en entorno aislado siempre
3. **Documentar el resultado**: no solo "funcionó" — guardar el output exacto
4. **Tiempo limitado**: fijar un timebox antes de empezar (ej: 2h)

### Paso 4 — Ejecutar y documentar

Usar `assets/pilot-report.md.template`. Registrar:
- Qué se hizo exactamente (reproducible)
- Resultado concreto con evidencia (output, log, métrica)
- Decisión derivada

---

## Manejo de supuestos invalidados

Si un supuesto H-NNN es falso:

1. **No improvisar**: detener el piloto y evaluar el impacto en el plan
2. **Volver a Phase 8**: si el task-plan asume ese supuesto, debe revisarse
3. **Documentar la alternativa**: qué cambia y por qué

**Anti-patrón**: invalidar un supuesto y "seguir igual porque ya lo planificamos".

---

## Relación con otras fases

- **Phase 8 PLAN EXECUTION** genera el task-plan y marca tareas de alto riesgo → PILOT las valida
- **Phase 10 EXECUTE** usa los resultados del piloto para ajustar el enfoque de implementación
- **Risk register** (Phase 1): los supuestos del piloto suelen derivar de riesgos identificados ahí

---

## Checklist de salida

- [ ] Todos los supuestos H-NNN tienen resultado (validado / invalidado / parcial)
- [ ] Supuestos invalidados tienen alternativa documentada
- [ ] Task-plan de Phase 8 actualizado si hubo cambios de diseño
- [ ] PoC temporales eliminados (o paths documentados para Phase 10)
- [ ] Decisión de avance explícita: AVANZAR / REVISAR / ESCALAR
