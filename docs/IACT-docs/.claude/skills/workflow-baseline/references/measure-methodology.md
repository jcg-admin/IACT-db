```yml
type: Metodología Phase 2 — MEASURE
category: Medición cuantitativa
version: 1.0
purpose: Guía para establecer baseline cuantitativo antes de analizar o diseñar soluciones.
goal: Producir datos que permitan medir el impacto real de la solución al final del ciclo.
updated_at: 2026-04-16
owner: workflow-measure
```

# Measure Methodology

## Propósito

Establecer baseline cuantitativo antes de intervenir. Sin datos del estado actual no hay forma de demostrar que la solución mejoró algo.

> Regla: Medir antes de cambiar. Medir después de cambiar. La diferencia es el valor entregado.

---

## Cuándo usar Phase 2 MEASURE

| Situación | Usar MEASURE | Omitir (micro/pequeño) |
|-----------|:------------:|:----------------------:|
| WP con criterios de éxito numéricos | ✓ | — |
| Performance, latencia, error rate | ✓ | — |
| Refactoring donde se quiere demostrar mejora | ✓ | — |
| Bug fix simple sin métricas | — | ✓ |
| Documentación | — | ✓ |

---

## Proceso de medición

### Paso 1 — Definir qué medir

Antes de recopilar datos, acordar qué métricas importan:

1. **Métricas de resultado** (outcome): qué cambio en el mundo externo se busca
   - Ej: tiempo de carga < 200ms, error rate < 0.1%, conversión +15%

2. **Métricas de sistema** (proxy): indicadores internos correlacionados con el outcome
   - Ej: P95 latencia de API, tasa de cache hits, queries por request

3. **Métricas de proceso**: velocidad de entrega, cobertura de tests
   - Estas son secundarias — solo relevantes si el WP toca el proceso de desarrollo

**Anti-patrón:** Medir todo lo que se puede medir en lugar de lo que importa para la decisión.

### Paso 2 — Establecer condiciones de medición

Las mismas métricas bajo condiciones distintas dan resultados distintos.
Documentar:
- Entorno (prod / staging / local)
- Carga (requests/s, usuarios concurrentes, tamaño de dataset)
- Configuración relevante (cache on/off, réplicas, índices)
- Período de tiempo (evitar días atípicos)

### Paso 3 — Recopilar datos

Usar herramientas apropiadas al contexto:

| Tipo de métrica | Herramientas típicas |
|----------------|---------------------|
| Performance web | Lighthouse, WebPageTest, k6 |
| API latencia | curl timing, k6, Grafana |
| Base de datos | EXPLAIN ANALYZE, slow query log |
| Error rates | Sentry, logs con grep/awk |
| Code quality | SonarQube, eslint --format json |
| Test coverage | nyc, jest --coverage |

### Paso 4 — Documentar el baseline

Usar `assets/baseline.md.template`. Incluir:
- Valores numéricos concretos (no "lento" — "P95 = 2.3s")
- Condiciones de medición reproducibles
- Anomalías observadas

---

## Definir targets (objetivos)

Un target válido tiene tres propiedades:
1. **Específico**: "P95 < 200ms" no "más rápido"
2. **Medible**: con el mismo método que el baseline
3. **Justificado**: por qué ese número y no otro (benchmark, SLA, user research)

---

## Relación con otras fases

- **Phase 1 DISCOVER** identifica el problema cualitativamente — MEASURE lo cuantifica
- **Phase 3 ANALYZE** usa los datos de MEASURE para encontrar causas raíz
- **Phase 11 TRACK/EVALUATE** compara el resultado final contra este baseline

---

## Checklist de salida

- [ ] Baseline documentado con valores numéricos, no estimaciones
- [ ] Condiciones de medición documentadas y reproducibles
- [ ] Al menos una métrica de éxito con valor target definido
- [ ] Método para verificar el target al final del WP acordado
