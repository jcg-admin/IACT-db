# Root Cause Analysis Methodology

> Reference para Stage 3 DIAGNOSE. Usar cuando se necesita identificar causas raíz
> de un problema antes de diseñar soluciones.

## ¿Cuándo aplicar RCA?

Root Cause Analysis (RCA) aplica en Stage 3 DIAGNOSE cuando:
- Se identificaron síntomas pero no las causas subyacentes
- Un problema recurrente necesita solución estructural (no solo paliativa)
- Se requiere evidencia basada en datos antes de proponer contramedidas

---

## Técnica 1: 5 Whys (Toyota)

La técnica más simple. Aplicar cuando el problema tiene una cadena causal lineal.

**Proceso:**
1. Escribir el problema observado con precisión
2. Preguntar "¿Por qué?" y registrar la respuesta
3. Preguntar "¿Por qué?" a la respuesta anterior
4. Repetir hasta 5 veces (o hasta llegar a una causa accionable)
5. Verificar: ¿resolviendo esta causa raíz se elimina el síntoma original?

**Ejemplo:**
```
Problema: El sistema falla en producción los lunes por la mañana
¿Por qué? → Los jobs de batch nocturnos del domingo no terminan a tiempo
¿Por qué? → Procesan un volumen mayor al estimado en diseño
¿Por qué? → El volumen de datos creció 3x en los últimos 6 meses
¿Por qué? → No existe proceso de revisión de capacidad periódico
¿Por qué? → No hay ownership definido para monitoreo de recursos
→ CAUSA RAÍZ: ausencia de proceso de capacity planning con dueño asignado
```

**Limitaciones:** No funciona bien para problemas con múltiples causas interactuantes.

---

## Técnica 2: Diagrama de Ishikawa (Fishbone / 6M)

Para problemas con múltiples causas posibles. Mejor para descubrimiento que para validación.

**Las 6M (dominio manufactura):**
- **Máquinas** — equipos, herramientas, tecnología
- **Métodos** — procesos, procedimientos, instrucciones
- **Materiales** — insumos, datos de entrada, dependencias
- **Mano de obra** — personas, habilidades, capacitación
- **Medio ambiente** — entorno, condiciones externas
- **Medición** — métricas, instrumentos, criterios de evaluación

**Las 4P (dominio servicios/software):**
- **Políticas** — reglas, decisiones, governance
- **Procedimientos** — procesos, workflows, flujos
- **Personas** — habilidades, motivación, organización
- **Planta/Plataforma** — tecnología, infraestructura, herramientas

**Proceso:**
1. Escribir el efecto (problema) en la "cabeza" del pez
2. Dibujar las espinas principales (una por categoría)
3. Brainstorming: agregar causas posibles bajo cada categoría
4. Priorizar causas por frecuencia de mención y evidencia disponible
5. Validar las causas más probables con datos

---

## Técnica 3: Árbol de Causas (Fault Tree Analysis)

Para sistemas complejos donde el fallo puede ocurrir por múltiples caminos.

**Proceso:**
1. Definir el evento tope (top event = el fallo)
2. Identificar condiciones que pueden causar el evento tope
3. Conectar con puertas lógicas: AND (todas necesarias) / OR (cualquiera suficiente)
4. Expandir recursivamente hasta eventos básicos (con datos observables)
5. Calcular probabilidad si los datos lo permiten

---

## Técnica 4: Pareto Analysis (80/20)

Para priorizar cuando hay múltiples causas identificadas.

**Proceso:**
1. Listar todas las causas identificadas
2. Medir frecuencia o impacto de cada causa
3. Ordenar de mayor a menor
4. Calcular % acumulado
5. Identificar las causas que explican el 80% del efecto

**Regla:** Atacar primero las causas del "lado izquierdo" del Pareto (mayor impacto).

---

## Validación de causas raíz

Una causa raíz es válida cuando cumple las 3 condiciones:

| Criterio | Pregunta de verificación |
|----------|--------------------------|
| **Necesaria** | Si esta causa no existiera, ¿el problema desaparecería? |
| **Suficiente** | Si esta causa existe, ¿el problema ocurre inevitablemente? |
| **Accionable** | ¿Podemos eliminar o mitigar esta causa con los recursos disponibles? |

Una causa que no es accionable no es útil aunque sea real — seguir preguntando "¿por qué?" para llegar a una causa que sí se pueda atacar.

---

## Relación con methodology skills

| Metodología | Técnica RCA recomendada | Skill |
|-------------|------------------------|-------|
| PPS (Toyota TBP) | 5 Whys + Fishbone | `pps-analyze` |
| DMAIC | Fishbone + Pareto + regresión | `dmaic-analyze` |
| Lean | 5 Whys + VSM para localizar | `lean-analyze` |
| BPA | 5 Whys + VA/NVA mapping | `bpa-analyze` |
| PDCA | 5 Whys (simple) | `pdca-plan` |

---

## Output esperado en Stage 3 DIAGNOSE

El artefacto de RCA en Stage 3 debe incluir:

```markdown
## Root Cause Analysis

### Problema validado
[Descripción precisa con datos: qué, cuándo, cuánto]

### Método aplicado
[5 Whys / Ishikawa / Árbol de causas / Pareto]

### Evidencia recopilada
[Datos concretos: logs, métricas, entrevistas, observaciones directas]

### Causas identificadas
| Causa | Categoría | Evidencia | Frecuencia | Impacto |
|-------|-----------|-----------|------------|---------|

### Causa raíz seleccionada
[La causa que cumple los 3 criterios: necesaria, suficiente, accionable]

### Validación
[¿Cómo se verificó que esta es la causa raíz y no un síntoma?]
```
