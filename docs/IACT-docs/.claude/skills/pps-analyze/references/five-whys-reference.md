# Referencia: Técnica 5 Whys — PS8

> Fuente base: Five Whys analysis — /tmp/references/topics/topics/five-whys-analysis/index.md
> Ampliado con contexto TBP y guía de aplicación para pps:analyze.

---

## ¿Qué son los 5 Whys?

Los 5 Whys (Cinco Por Qués) es una técnica de resolución de problemas que trabaja hacia atrás desde los síntomas de un problema hasta sus causas subyacentes, preguntando iterativamente "¿por qué?" hasta identificar la causa raíz.

El método fue desarrollado por Sakichi Toyoda y se convirtió en pieza central del Toyota Production System (TPS) y posteriormente del Toyota Business Practices (TBP). Su poder reside en su simplicidad: no requiere herramientas estadísticas sofisticadas, solo rigor al responder con evidencia.

**Principio fundamental:** No conformarse con las respuestas obvias. El equipo debe profundizar más allá del síntoma para llegar a la causa subyacente que, si se elimina, evitaría que el problema recurriera en el futuro.

---

## El proceso paso a paso

1. **Comenzar con el síntoma** — usar el Problem Statement definido en pps:clarify como punto de partida
2. **Preguntar "¿Por qué?" sobre el síntoma** — buscar la causa inmediata con evidencia observable
3. **Preguntar "¿Por qué?" sobre esa causa** — no sobre el síntoma, sino sobre la causa recién identificada
4. **Continuar hasta llegar al factor sistémico** — el número exacto varía; "5" es orientativo
5. **Validar cada eslabón con datos** — cada respuesta necesita evidencia; no aceptar suposiciones

El análisis se realiza típicamente en equipo, con personas que tienen conocimiento directo del proceso. La perspectiva múltiple evita los puntos ciegos individuales.

---

## Cuándo usar 5 Whys vs otras técnicas

| Situación | Herramienta recomendada |
|-----------|------------------------|
| Problema con cadena causal relativamente lineal | 5 Whys — rápido y directo |
| Problema con múltiples causas potenciales desconocidas | Fishbone primero, luego 5 Whys por cada rama |
| Problema con datos estadísticos disponibles | 5 Whys + análisis de Pareto para priorizar |
| Problema donde la causa "obvia" es la única considerada | Fishbone obligatorio — amplía la búsqueda |
| Problema recurrente que se creyó resuelto antes | 5 Whys más profundo — la causa raíz anterior estaba incompleta |

**Regla TBP:** En pps:analyze se usan ambas herramientas de forma complementaria:
- Fishbone para exploración amplia de hipótesis (apertura)
- 5 Whys para profundizar en cada hipótesis hasta la causa sistémica (cierre)

---

## Pitfalls — errores comunes y cómo evitarlos

| Error | Síntoma | Cómo evitarlo |
|-------|---------|---------------|
| **Responder con suposiciones** | "Porque el equipo no presta atención" — sin evidencia | Pedir el dato que soporta cada respuesta antes de continuar |
| **Culpar a personas** | "Porque [persona] cometió un error" | Reformular: ¿Por qué el sistema permitió que ese error ocurriera? |
| **Detenerse demasiado pronto** | La "causa raíz" todavía es un síntoma | Preguntar: ¿Si corregimos esto, garantizamos que no vuelve a pasar? Si no → continuar |
| **Tomar el primer camino** | Hay múltiples causas pero se explora solo una | Usar Fishbone primero para identificar todas las ramas antes de ir a 5 Whys |
| **Causa fuera del control del equipo** | "Porque el proveedor externo falla" | Explorar por qué el proceso depende de ese proveedor sin control — eso sí es accionable |
| **Análisis solo en reunión** | Las respuestas son teóricas, no basadas en observación | Combinar con Gemba — verificar las hipótesis en el proceso real |

---

## El "5" no es un límite rígido

El número de iteraciones varía según la complejidad del problema:

- **3 Whys**: suficiente para problemas simples con causa raíz superficial
- **5 Whys**: el estándar para la mayoría de problemas operacionales
- **7+ Whys**: problemas sistémicos complejos con causas raíz en cultura, diseño organizacional o procesos multisistema

La señal de parada no es el número — es haber llegado a un factor sistémico cuya corrección previene la recurrencia.

---

## Conexión con el A3 Report

Los 5 Whys alimentan directamente la **Sección 4 del A3 Report** (Root Cause Analysis):

```
Fishbone → múltiples hipótesis priorizadas
5 Whys por cada hipótesis → cadena causal confirmada
Causa raíz confirmada con datos → Sección 4 del A3
```

El A3 exige síntesis: no se incluyen todos los hilos explorados — solo la cadena causal principal y las causas raíz confirmadas. Las hipótesis descartadas se documentan en el worksheet de 5 Whys pero no en el A3 final.
