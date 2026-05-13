---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: quality-goals
repo: claude-code-ultimate-guide
---

# Objetivos de Calidad: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Adherencia de instrucciones como métrica primaria
**Descripción:** El repositorio define "adherence" (cuánto Claude sigue las instrucciones del CLAUDE.md) como métrica de calidad fundamental. Hay datos empíricos sobre degradación por tamaño de archivo: 1-100 líneas ~95%, 200-400 líneas ~75%, 600+ líneas ~45%.
**Fuente:** core/context-engineering.md:191-203
**Relevancia:** Alta

### Patrón 2 — Techo de 150 instrucciones
**Descripción:** Observación empírica de equipos: más de ~150 reglas distintas en CLAUDE.md causa que el modelo empiece a ignorar selectivamente. El mecanismo es "attention diffusion": las reglas de alta salience desplazan a las de baja salience.
**Fuente:** core/context-engineering.md:183-189
**Relevancia:** Alta

### Patrón 3 — Confiabilidad de skills: el problema del 56%
**Descripción:** Blog de ingeniería de Vercel (Gao, 2026): los agentes invocan skills on-demand solo el 56% del tiempo, defaulteando al conocimiento nativo el resto. Implicación: skills críticos deben reforzarse con instrucciones en CLAUDE.md o triggers explícitos.
**Fuente:** core/glossary.md:132 ("The 56% Reliability Warning")
**Relevancia:** Alta

### Patrón 4 — Tasas de éxito por scope
**Descripción:** Datos de estudios de practitioners: 1-3 archivos ~85% éxito, 4-7 archivos ~60%, 8+ archivos ~40%. El scope del trabajo es el predictor más fuerte de calidad de output.
**Fuente:** core/architecture.md:457-463
**Relevancia:** Alta

### Patrón 5 — El problema del 80% (Addy Osmani)
**Descripción:** AI maneja confiablemente el 80% de una tarea. El 20% restante es donde la experiencia y el juicio humano determinan el éxito. La verificación no es opcional; es donde se gana o pierde la calidad real.
**Fuente:** core/glossary.md:133 ("The 80% Problem")
**Relevancia:** Alta

### Patrón 6 — Datos empíricos sobre código AI vs humano
**Descripción:** AI produce 1.75× más errores de lógica (ACM 2025), 45% de outputs contienen vulnerabilidades de seguridad (Veracode 2025), 2.74× más vulnerabilidades XSS (CodeRabbit 2025), +24% incidentes por PR (Cortex.io 2026). Sin embargo, un RCT con 151 devs no encontró diferencia en tiempo de mantenimiento downstream.
**Fuente:** ultimate-guide.md:1379-1392
**Relevancia:** Alta

### Patrón 7 — Degradación de sesión por turns
**Descripción:** 15-25 turns: Claude pierde track de constraints anteriores. 80-100K tokens acumulados: ignora requisitos del inicio de la sesión. >5 archivos simultáneos: cambios inconsistentes. Estos son thresholds empíricos, no garantizados.
**Fuente:** core/architecture.md:449-470
**Relevancia:** Media

## Conceptos clave

- Calidad = adherencia + correctness + scope manageable
- Rule quality beats rule quantity (20 reglas específicas > 200 aspiracionales)
- Context rot degrada calidad aunque no haya desbordamiento
- Verificación proporcional al riesgo, no uniforme
- "Context failure, not model failure" — mayoría de outputs malos son fallas de contexto

## Notas adicionales

El repositorio distingue entre "context rot" (degradación por tamaño) y "failure re-injection drift" (degradación por errores repetidos en el contexto). Son mecanismos distintos que requieren mitigaciones distintas.

El framework SPACE y DORA aplicados a equipos AI-augmented aparecen en ops/team-metrics.md con métricas específicas para cuando AI escribe 70%+ del código.
