# Guía de Go-and-See (Gemba) — PS8

> Referencia para la aplicación del principio Gemba en el Step 1 de Toyota TBP.

---

## Los tres pilares del Gemba

| Término japonés | Traducción | Significado práctico |
|----------------|------------|---------------------|
| **Gemba** | "El lugar real" | Ve donde el trabajo ocurre — no gestiones el problema desde una sala de juntas |
| **Genbutsu** | "El objeto real" | Examina el artefacto real: el defecto, el dato, el output fallido — no una descripción de él |
| **Genjitsu** | "Los hechos reales" | Basa el análisis en evidencia observable, no en suposiciones o recuerdos |

El principio unificador: **"Go and see for yourself to thoroughly understand the situation."**

---

## Cuándo y cómo ir al Gemba

### Cuándo

- Al inicio del proyecto PS8 — antes de definir el Problem Statement definitivo
- Cuando el análisis produce hipótesis que no coinciden con la realidad observada
- Cuando el equipo tiene diferentes versiones de "cómo ocurre" el problema

### Protocolo de observación directa

1. **Preparación** — Define qué observar y qué preguntas responder antes de ir
2. **Ir sin juicio previo** — No ir a confirmar lo que ya crees; ir a ver lo que realmente pasa
3. **Observar el proceso completo** — No solo el punto de falla, sino los pasos anteriores y posteriores
4. **Hablar con quienes hacen el trabajo** — Son los expertos reales del proceso
5. **Documentar en el momento** — Tomar notas y datos mientras se observa, no después de regresar
6. **Medir, no estimar** — Usar datos reales cuando sea posible (tiempos, tasas, frecuencias)

---

## Preguntas clave para el Gemba

**Para entender el proceso:**
- "¿Cómo se supone que funciona este paso?"
- "¿Qué pasa exactamente cuando algo falla aquí?"
- "¿Con qué frecuencia ocurre?"
- "¿Cuándo notaste por primera vez este problema?"

**Para entender el contexto:**
- "¿Cuándo el proceso funciona bien vs cuándo falla? ¿Hay un patrón?"
- "¿Qué hace diferente una persona que no tiene el problema vs una que sí?"
- "¿Hay algo que haya cambiado recientemente que coincida con el inicio del problema?"

**Para entender el impacto:**
- "¿Cuánto tiempo extra te lleva cuando esto falla?"
- "¿Qué tienes que hacer cuando pasa esto?"
- "¿A quién más afecta?"

---

## Gemba en contextos digitales/software

Para equipos de software donde el "lugar real" es un sistema digital:

| Contexto físico | Equivalente digital |
|----------------|---------------------|
| Ir al piso de manufactura | Revisar logs en producción en el momento del fallo |
| Observar a un operador trabajar | Hacer pair observing con un usuario o ingeniero |
| Examinar el producto defectuoso | Examinar el error message, el stack trace, el output incorrecto |
| Medir el tiempo de ciclo | Medir latencia real, tiempo de procesamiento real |
| Hablar con el operador | Entrevistar al usuario que experimentó el problema |

**Herramientas de Gemba digital:**
- Logs de sistema (no resúmenes — logs reales del incidente)
- Dashboards y métricas en tiempo real
- Grabaciones de sesión de usuario (si aplica y con consentimiento)
- Replays de errores en staging
- Entrevistas con usuarios reales que experimentaron el problema

---

## Errores comunes en el Gemba

| Error | Por qué es problema | Corrección |
|-------|---------------------|-----------|
| **Ir con la causa ya decidida** | Sesgo de confirmación — solo se verá lo que ya se cree | Ir con preguntas abiertas, no con hipótesis a confirmar |
| **Solo hablar con el manager** | El manager reporta su percepción, no la realidad del proceso | Hablar directamente con quienes ejecutan el trabajo |
| **Una sola visita** | El problema puede ser intermitente o variar según condiciones | Observar en diferentes momentos si el problema es variable |
| **Documentar después de volver** | La memoria es selectiva y puede filtrar datos incómodos | Tomar notas y datos en el momento, en el lugar |
| **Gemba sin datos** | La observación sin medición es anecdótica | Medir: tiempos, frecuencias, tasas — cuantificar lo observado |
| **No involucrar al equipo** | El equipo puede sentir que "los están auditando" en lugar de involucrarse en la mejora | Explicar el propósito del Gemba y tratar al equipo como expertos del proceso |

---

## Conexión con el Problem Statement

El Gemba alimenta directamente el Problem Statement y el estado ideal vs actual:

```
Gemba → Datos reales observados → Estado actual cuantificado
Estado ideal (estándar, SLA, especificación) vs Estado actual → Brecha
Brecha → Problem Statement con número, período e impacto
```

Sin datos del Gemba, el Problem Statement es una suposición. Con datos del Gemba, es una descripción verificada de la realidad.
