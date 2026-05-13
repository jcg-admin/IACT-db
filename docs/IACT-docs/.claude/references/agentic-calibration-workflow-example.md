```yml
created_at: 2026-04-19 07:27:05
project: THYROX
work_package: 2026-04-18-07-12-50-methodology-calibration
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Ejemplo de Flujo Multi-Agente: Análisis Adversarial de Calibración

Este documento captura un flujo real ejecutado durante Stage 1 DISCOVER del WP
`methodology-calibration` como ejemplo de referencia para el sistema de Agentic AI.
El caso de uso: evaluar la calidad epistémica de un capítulo de libro técnico en 3 versiones
sucesivas mediante agentes adversariales paralelos.

---

## 1. Contexto del Problema

El sistema recibió un capítulo de libro sobre el Protocolo de Contexto de Modelo (MCP).
El objetivo era determinar si el capítulo estaba **bien calibrado** — es decir, si sus
afirmaciones estaban respaldadas por evidencia real o eran proyecciones sin validación.

El autor del capítulo iteró 3 versiones intentando mejorar la calibración. El sistema de
agentes analizó cada versión de forma adversarial e independiente.

---

## 2. Arquitectura del Flujo

```
ORQUESTADOR (Claude Code)
    │
    ├─ Recibe input (texto del capítulo)
    ├─ Prepara input.md verbatim (sin comprimir claims)
    ├─ Lanza agentes en PARALELO
    │
    ├─── AGENTE A: deep-dive (adversarial)          [background]
    │        └─ 6+ capas de verificación
    │        └─ Detecta: contradicciones, saltos, engaños
    │        └─ Output: *-deep-dive.md
    │
    └─── AGENTE B: agentic-reasoning (calibración)  [background]
             └─ Clasifica cada claim por tipo de evidencia
             └─ Calcula ratio numérico
             └─ Output: *-calibration.md
    │
    ├─ Espera notificaciones de completion
    ├─ Commitea outputs
    └─ Reporta al usuario
```

### Roles de agentes

| Agente | Tipo | Función | Output |
|--------|------|---------|--------|
| Orquestador | Claude Code (main) | Coordina flujo, prepara inputs, commitea | now.md, commits |
| Adversarial | `deep-dive` | Detecta problemas estructurales | `*-deep-dive.md` |
| Calibrador | `agentic-reasoning` | Mide ratio evidencia/claims | `*-calibration.md` |

---

## 3. Ejecución por Versión

### Versión Original (Cap.10 sin correcciones)

**Input:** Capítulo completo con 11 secciones, 3 ejemplos de código, 9 casos de uso.

**Preparación del input:**
- Orquestador preservó verbatim todos los claims, código y conclusiones
- Agregó notas editoriales sobre 5 defectos de código detectados en lectura inicial:
  1. `tool_filter` en ubicación incorrecta (`StdioServerParameters` en lugar de `MCPToolset`)
  2. `Client` importado sin uso en versión extendida FastMCP
  3. Patrones `StdioConnectionParams` vs `StdioServerParameters` incompatibles entre ejemplos
  4. Código duplicado (versión condensada + extendida)
  5. Errores de sintaxis en versión ADK extendida

**Agentes lanzados en paralelo:** `deep-dive` + `agentic-reasoning`

**Hallazgos del deep-dive:**
- `C-1`: "Reduce dramáticamente la complejidad" vs 8 decisiones arquitectónicas propias del capítulo — MCP estandariza, no elimina complejidad
- `C-2`: "Descubrimiento dinámico" refutado por el propio código — todos los servidores hardcodeados
- `C-3`: Advertencia honesta de Sec.2 estructuralmente desconectada de los 9 casos de uso en Sec.6
- Patrón identificado: **Generalización por caso de referencia + advertencia desconectada**

**Resultado calibración: 65% — PARCIALMENTE CALIBRADO**

Distribución por dominio (patrón CAD — Calibración Asimétrica por Dominio):

| Dominio | Score |
|---------|-------|
| Protocolo MCP (especificación) | 0.91 |
| Advertencias honestas | 0.90 |
| Comparativo MCP vs Tool Calling | 0.72 |
| Casos de uso: BD, APIs | 0.70 |
| Casos de uso: IoT, Financiero | 0.20–0.30 |
| Ejemplos de código | 0.23 |

---

### Versión V1 — "Corregida Calibrada"

El autor recibió el análisis y entregó una versión corregida.

**Cambios declarados por el autor:**
- Tabla ANTES/DESPUÉS con estimación de líneas (200-500 → 50-100)
- "Dynamic discovery" corregido a "funciones dentro de servidores configurados"
- Servicios financieros reclasificado como ANTI-PATRÓN con patrón de 3 fases
- IoT y multi-paso: VÁLIDO SOLO CON 5 requisitos explícitos
- Ejemplo 4 nuevo: cliente de producción con retry, timeout, logging
- Nueva sección Gap Desarrollo/Producción

**Hallazgos del deep-dive (veredicto: PARCHE SOFISTICADO):**
- Correcciones genuinas: financiero → anti-patrón, IoT condicional, código sin duplicados
- Parches performativos: tabla 200-500 → 50-100 sin fuente empírica, "60-70% esfuerzo" sin cita
- Problemas nuevos introducidos:
  - Bug latente: `with_retry_and_logging` falla con funciones síncronas (`asyncio.wait_for` requiere coroutine)
  - Discovery caveat ausente en Sec.11/conclusiones (corrección aplicada solo en Sec.5 y Sec.6)
  - `tool_filter` sigue en ubicación incorrecta en Ejemplo 3

**Resultado calibración: 79% — CALIBRADO (supera gate de 75%)**

Mecanismo de mejora:
1. **Eliminación de 4 claims con score 0** — driver principal (reduce denominador)
2. **Corrección de casos regulados** — Financial 0.20 → 0.75, IoT 0.30 → 0.65
3. **Adición de sección producción calibrada** — requisitos verificables

La deuda epistémica no desapareció; se transformó: de intensificadores cualitativos
("dramáticamente") a números específicos sin fuente ("200-500 líneas", "60-70%") —
patrón de **falsa precisión**.

---

### Versión V2 — "Calibrada 2.0, Fixes Aplicados"

El autor entregó una segunda corrección. El header declaraba: "V1: 79% (SUPERA GATE) | V2: Fixes aplicados".

**Cambios principales en V2:**
- Distinción explícita: reduce ACOPLAMIENTO/TRABAJO, no COMPLEJIDAD CONCEPTUAL
- Tabla separada: "Descubrimiento de FUNCIONES" / "Descubrimiento de SERVIDORES"
- Sección "Interpretación honesta": cuándo Tool Calling es SUPERIOR
- 3 categorías de casos: A (Válidos), B (Condicionales), C (Anti-patrones)
- Explicación por requisito de POR QUÉ MCP no cumple cada requisito financiero
- 8 requisitos de producción (agrega Rate Limiting)
- "VERDAD FUNDAMENTAL": 3 afirmaciones precisas
- FIX BUG 1/2/3 declarados

**Resultado inesperado: V2 regresiona a 65.4% — PARCIALMENTE CALIBRADO (-13.5pp)**

**Causa raíz: efecto denominador**

V2 introduce 19 claims nuevos con ratio promedio de 48.4%.
Los claims heredados se mantienen en 87.3%.
El promedio de los nuevos arrastra el global hacia abajo.

```
V1: N_claims = 25, ratio = 79%   → numerador ≈ 19.75
V2: N_claims = 44, ratio = 65.4% → numerador ≈ 28.75
    (19 nuevos × 48.4% = 9.2 contribución adicional)
    (9.2 / 19 nuevos = 48.4% — por debajo del gate de 75%)
```

**Claims nuevos de alta calidad (score ≥ 0.80) — 7 claims:**
- VERDAD FUNDAMENTAL: "MCP estandariza COMUNICACIÓN, no CORRECTITUD"
- VERDAD FUNDAMENTAL: "MCP reduce ACOPLAMIENTO, no COMPLEJIDAD CONCEPTUAL"
- VERDAD FUNDAMENTAL: "MCP simplifica INTEGRACIÓN, no GARANTÍAS OPERACIONALES"
- Clarificación `tool_filter`: CUÁNDO / CUÁNDO NO usar
- Lista negativa "CUÁNDO MCP NO DEBE USARSE"
- Rate Limiting como 8vo requisito de producción
- Desglose TRABAJO / ACOPLAMIENTO / COMPLEJIDAD correctamente separados

**Claims nuevos que generan deuda epistémica (score ≤ 0.40) — 5 claims:**
- Umbrales 1-5 funciones / 10+ herramientas sin fuente (criterios de decisión inventados)
- Bug JSON-RPC persiste bajo declaración "Bugs corregidos" (`method: tool_name` ≠ `method: "tools/call"`)
- Allocación "realista" 20-30% / 60-70% sin evidencia empírica
- Calibraciones sub-caso 0.30/0.70 y 0.20/0.60 auto-referenciales
- TypeVar T como "fix" del bug async/síncrono — el bug persiste en runtime

**Hallazgo del deep-dive — FIX BUGs declarados:**

| Fix | Evaluación | Razón |
|-----|------------|-------|
| FIX BUG 2 (discovery) | REAL | Tabla separada aplicada en Sec.1 y Sec.2 |
| FIX BUG 1 (TypeVar T) | PERFORMATIVO | Python no enforce type hints en runtime; mismo bug latente |
| FIX BUG 3 (tool_filter) | INCIERTO | Texto corregido pero código Ejemplo 3 sin cambio |

---

## 4. Evolución de Calibración a Través de Versiones

```
Original → V1 Corregida → V2 Calibrada 2.0
  65%   →     79%       →      65.4%
         +14pp ↑                -13.5pp ↓
         (supera gate)          (regresiona)
```

### Patrón observado: "Whack-a-Mole Epistémico"

Cada corrección cierra algunos brechas de calibración y abre otras nuevas.
El autor corrige los problemas que el sistema señala explícitamente, pero
introduce nuevos claims no señalados con calibración insuficiente.

En V2, el autor:
- Corrigió los 3 bugs nombrados en el análisis
- No corrigió el bug no nombrado (JSON-RPC payload)
- Introdujo 19 claims nuevos de los cuales 5 son epistémicamente problemáticos

### Dinámica de revision sin adversarial técnico

El proceso de revisión fue convergente en las dimensiones visibles (financiero, IoT, multi-paso)
y estático o divergente en las dimensiones técnicas (JSON-RPC, número de líneas, bug de runtime).
Consistente con revisión editorial sin validación técnica adversarial.

---

## 5. Patrones Identificados Aplicables al Sistema

### Patrón 1: CAD — Calibración Asimétrica por Dominio

Un mismo documento puede tener dominios con calibración excelente (0.90) y dominios
con calibración crítica (0.20) en el mismo capítulo. La calibración global promedio
oculta la distribución real de riesgo.

**Implicación para el sistema:** El agente calibrador debe reportar distribución
por dominio, no solo ratio global.

### Patrón 2: Efecto Denominador

Agregar contenido nuevo puede degradar el ratio de calibración global aunque ningún
claim previo empeore. La métrica de calibración es sensible al volumen de claims nuevos.

**Implicación para el sistema:** Al evaluar versiones iterativas, reportar:
- Ratio global
- Ratio de claims heredados
- Ratio de claims nuevos
- Delta de denominador

### Patrón 3: Falsa Precisión

Reemplazar un intensificador cualitativo ("dramáticamente") con un número específico
sin fuente ("200-500 líneas") es epistémicamente más problemático — implica medición
donde no la hubo. El lector confía más en un número que en un adjetivo.

**Implicación para el sistema:** Números específicos sin cita deben clasificarse como
claim performativo de mayor severidad que intensificadores cualitativos.

### Patrón 4: Declaración Performativa de Corrección

Declarar "Bugs corregidos" en el header sin verificar exhaustivamente todos los bugs
crea una falsa garantía de calidad. El sistema adversarial detectó el bug JSON-RPC
no nombrado precisamente porque no confió en la declaración del autor.

**Implicación para el sistema:** El agente deep-dive no debe reducir su búsqueda
adversarial ante declaraciones de corrección del autor.

### Patrón 5: Fix Textual vs Fix Real

Un fix puede corregir el texto descriptivo sin corregir el código o la lógica subyacente.
FIX BUG 3 (tool_filter) corrigió la descripción pero no el Ejemplo 3.
FIX BUG 1 (TypeVar T) mejoró la anotación de tipos pero no el comportamiento en runtime.

**Implicación para el sistema:** El agente debe verificar que los fixes sean coherentes
entre texto, código y especificación — no solo en el nivel donde se declaró la corrección.

### Patrón 6: Cherry-pick Óptimo

La estrategia de mejora más eficiente no es tomar V2 como base, sino cherry-pick de
los 7 claims de alta calidad de V2 sobre la base V1. Esto maximiza calibración sin
incurrir en el efecto denominador de los 12 claims nuevos de baja calidad.

**Implicación para el sistema:** El agente calibrador debe identificar no solo el ratio
global sino qué claims específicos tienen mayor valor para futuras versiones.

---

## 6. Artefactos Producidos

| Versión | Artefacto | Resultado |
|---------|-----------|-----------|
| Original | `mcp-pattern-input.md` | Input verbatim + notas editoriales |
| Original | `mcp-pattern-deep-dive.md` | 6 saltos, 4 contradicciones, 5 engaños |
| Original | `mcp-pattern-calibration.md` | 65% — PARCIALMENTE CALIBRADO |
| Auditoría externa | `mcp-audit-input.md` | Input auditoría independiente |
| Auditoría externa | `mcp-audit-deep-dive.md` | Auditoría tiene sus propios problemas |
| Auditoría externa | `mcp-audit-calibration.md` | 79% — CALIBRADO (más alto del WP) |
| Análisis granular | `mcp-granular-calibration-input.md` | Script Python con scores por dominio |
| Análisis granular | `mcp-granular-deep-dive.md` | 4 errores aritméticos en el script |
| Análisis granular | `mcp-granular-calibration.md` | 55% — meta-análisis de análisis |
| V1 Corregida | `mcp-corrected-input.md` | Input v1 verbatim |
| V1 Corregida | `mcp-corrected-deep-dive.md` | PARCHE SOFISTICADO — 3 bugs nuevos |
| V1 Corregida | `mcp-corrected-calibration.md` | 79% — CALIBRADO (supera gate) |
| V2 Calibrada 2.0 | `mcp-corrected-v2-input.md` | Input v2 verbatim |
| V2 Calibrada 2.0 | `mcp-corrected-v2-deep-dive.md` | FIX BUGs: 1 real, 1 performativo, 1 incierto |
| V2 Calibrada 2.0 | `mcp-corrected-v2-calibration.md` | 65.4% — REGRESIÓN por efecto denominador |

---

## 7. Lecciones para el Sistema Agentic AI

### Sobre la arquitectura de agentes

- **Paralelismo es viable y productivo.** Deep-dive y calibración corren independientemente
  sobre el mismo input; sus hallazgos son complementarios, no redundantes.
- **El orquestador prepara el input; los agentes analizan.** La calidad del input.md
  determina la calidad del análisis. Un input comprimido produce análisis incompleto.
- **Los agentes no confían en declaraciones del autor.** El adversarial evaluó FIX BUGs
  independientemente y encontró que 1 de 3 era performativo.

### Sobre la medición de calidad

- **El ratio de calibración es una métrica de dirección, no un score absoluto.**
  Indica tendencia pero depende del denominador. Reportar distribución es más útil que promediar.
- **Las mejoras pueden ser no-lineales.** V1 (+14pp) y V2 (-13.5pp) muestran que
  añadir contenido sin rigor epistémico puede invertir mejoras previas.
- **El gate de 75% es válido como punto de paso, no como garantía de corrección.**
  V1 supera el gate con 3 bugs técnicos latentes.

### Sobre los ciclos de revisión

- **La convergencia editorial no garantiza convergencia técnica.**
  El autor resuelve los problemas que el sistema nombra; los no nombrados persisten.
- **La estrategia cherry-pick supera la estrategia de versión completa.**
  Seleccionar los claims de mayor valor de cada versión produce mejor resultado
  que aceptar versiones completas iterativas.
- **Los agentes adversariales deben re-evaluar cada versión sin asumir corrección.**
  La historia de versiones anteriores es contexto, no garantía.
