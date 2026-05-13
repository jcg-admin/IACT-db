---
name: dmaic-measure
description: "Use when establishing a quantitative baseline in a DMAIC project. dmaic:measure — define measurement plan, collect process data, calculate Sigma Level baseline, and validate measurement system."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 01:00:00
---

# /dmaic-measure — DMAIC: Measure

> *"In God we trust. All others must bring data." — W. Edwards Deming*

Ejecuta la fase **Measure** de DMAIC. Establece el baseline cuantitativo del proceso con un sistema de medición validado.

**THYROX Stage:** Stage 2 BASELINE.

**Tollgate:** Baseline con Sigma Level calculado y MSA realizado antes de avanzar a Analyze.

---

## Pre-condición

Requiere: `{wp}/dmaic-define.md` con:
- Project Charter aprobado por sponsor
- CTQs definidos con métricas y especificaciones objetivo
- SIPOC del proceso

---

## Cuándo usar este paso

- Cuando el Project Charter de Define está aprobado
- Para establecer con datos dónde está el proceso actualmente
- Para confirmar que el sistema de medición es confiable antes de confiar en los datos

## Cuándo NO usar este paso

- Sin Problem Statement y CTQs definidos en Define — Measure necesita saber qué medir
- Si ya existe un baseline reciente y confiable — documentarlo y avanzar a Analyze
- Si el proceso cambia significativamente durante la recolección — los datos son de un proceso en transición

---

## Actividades

### 1. Process Map — mapear el proceso antes de medir

Antes de definir el plan de medición, mapear el proceso actual con suficiente detalle para identificar dónde y cómo medir:

| Herramienta | Cuándo usar | Qué produce |
|-------------|-------------|-------------|
| **Mapa de proceso detallado** | Proceso con 10-30 pasos | Flujo de actividades con decision points y handoffs |
| **Value Stream Map (VSM)** | Proceso operacional con flujo de materiales o información | Tiempos de ciclo, tiempos de espera, WIP, ratio VA/NVA |
| **Swim lane diagram** | Múltiples departamentos o roles | Dónde ocurren los handoffs y quién hace qué |

> El Process Map identifica los puntos exactos donde medir el CTQ y las variables de proceso (X's) que potencialmente influyen. Sin mapa, el plan de medición es incompleto.

**VSM — indicadores clave a capturar:**

| Indicador VSM | Fórmula / Descripción |
|---------------|-----------------------|
| **Tiempo de ciclo (CT)** | Tiempo de procesamiento activo por unidad |
| **Tiempo de entrega (LT)** | Tiempo total desde inicio hasta entrega al cliente |
| **WIP (Work in Process)** | Unidades en proceso en cada etapa |
| **Ratio VA/NVA** | Tiempo que agrega valor / Tiempo total |
| **Eficiencia del flujo** | (Tiempo VA / LT) × 100% |

### 2. Plan de medición

Antes de recopilar un solo dato, definir:

| ¿Qué? | ¿Cómo? | ¿Cuándo? | ¿Quién? | ¿Fuente? |
|-------|--------|----------|---------|---------|
| [CTQ principal] | [Instrumento/sistema] | [Frecuencia] | [Responsable] | [BD/sistema/manual] |
| [CTQs secundarios] | | | | |
| [Variables de proceso a monitorear] | | | | |

### 3. Determinar el tipo de dato — define qué análisis aplica

| Tipo de dato | Características | Métricas adecuadas | Herramientas |
|-------------|-----------------|-------------------|-------------|
| **Continuo** | Tiempo, temperatura, peso, costo | Media, desviación, Cp/Cpk | Histograma, control charts X-bar/R |
| **Discreto / Atributo** | Defecto sí/no, categoría | Proporción defectuosa, DPU, DPMO | p-chart, np-chart, Pareto |
| **Conteo** | Número de defectos por unidad | DPU, u-chart | c-chart, u-chart |

> Si tienes datos continuos, no los conviertas a atributo — perderás información valiosa sobre la distribución del proceso.

### 4. MSA — Measurement System Analysis

El MSA valida que el sistema de medición es confiable antes de confiar en los datos.

**Para datos continuos — Gauge R&R:**

| Pregunta | Herramienta |
|----------|-------------|
| ¿Los medidores miden lo mismo? (Reproducibilidad) | Gauge R&R |
| ¿El mismo medidor repite el resultado? (Repetibilidad) | Gauge R&R |
| ¿El instrumento está calibrado? (Exactitud) | Calibración / comparación con estándar |

**Criterios de aceptación del MSA (Gauge R&R):**
- `%GR&R < 10%` → Sistema de medición aceptable
- `10% ≤ %GR&R < 30%` → Aceptable condicionalmente; documentar y monitorear
- `%GR&R ≥ 30%` → Sistema de medición no confiable → corregir antes de continuar

Ver tabla de decisión completa y cómo ejecutar el Gauge R&R: [msa-gage-rr.md](./references/msa-gage-rr.md)

**Para datos de atributo — Kappa de Cohen:**

El Kappa de Cohen mide la concordancia entre evaluadores para datos categóricos (pasa/no pasa, categoría A/B/C):

| Kappa | Interpretación | Acción |
|-------|---------------|--------|
| > 0.9 | Concordancia excelente | MSA aprobado |
| 0.7 – 0.9 | Concordancia aceptable | Documentar; monitorear en producción |
| < 0.7 | Concordancia insuficiente | Revisar criterios de clasificación; reentrenar evaluadores |

> Si el Kappa < 0.7, los evaluadores no están clasificando el mismo defecto de la misma manera — los datos de atributo no son confiables. No omitir esta validación cuando el CTQ es discreto.

> Si el MSA falla, los datos que recopiles no son confiables — todo el análisis de Analyze será inválido. No omitir el MSA.

### 5. Recopilar datos — muestreo representativo

| Principio | Aplicación |
|-----------|-----------|
| **Tamaño de muestra** | Para proporciones: n ≥ 30 para datos estables; para eventos raros, más |
| **Período de recolección** | Suficiente para capturar variabilidad normal: turnos, días, semanas |
| **Estratificación** | Recopilar por subgrupo (turno, máquina, operador, región) para poder analizar en Analyze |
| **Datos del proceso, no del producto** | Medir el proceso mientras ocurre, no solo el resultado final |

### 6. Calcular métricas baseline

**Para datos de atributo (defectos):**

```
DPU = Defectos totales / Unidades totales

DPMO = (Defectos totales / (Unidades × Oportunidades de defecto)) × 1,000,000

Sigma Level ≈ conversión desde tabla DPMO:
  DPMO 308,537 → 2σ
  DPMO  66,807 → 3σ
  DPMO   6,210 → 4σ
  DPMO     233 → 5σ
  DPMO       3.4 → 6σ
```

> **Convención 1.5σ (long-term shift):** El Sigma Level calculado desde DPMO ya incorpora el shift de 1.5σ de Six Sigma. Este shift reconoce que los procesos reales se desplazan ±1.5σ a largo plazo respecto al proceso controlado en el corto plazo. Un proceso con DPMO = 3.4 se dice "6 Sigma" en el lenguaje Six Sigma, aunque estadísticamente el proceso corto plazo tiene 4.5σ. Esta convención es estándar en DMAIC — no mezclarla con cálculos estadísticos directos de distribución normal.

**Para datos continuos (variables):**

```
Cp = (USL - LSL) / (6σ)          ← capacidad potencial (proceso centrado)
Cpk = min[(USL - μ)/3σ, (μ - LSL)/3σ]   ← capacidad real (considera centrado)

Cpk < 1.0 → proceso no capaz
Cpk 1.0-1.33 → proceso marginalmente capaz
Cpk > 1.33 → proceso capaz
```

### 7. Process Capability — análisis de capacidad

| Herramienta | Propósito |
|-------------|-----------|
| **Histograma + límites de especificación** | Ver visualmente cuánta producción cae fuera de spec |
| **Gráfica de control** | Determinar si el proceso está en control estadístico |
| **Capability plot** | Cp, Cpk, % fuera de especificación |

> Cp/Cpk solo son válidos si el proceso está en control estadístico. Si las gráficas de control muestran causas especiales, corregirlas primero.

---

## Artefacto esperado

`{wp}/dmaic-measure.md` — usar template: [dmaic-measure-template.md](./assets/dmaic-measure-template.md)

---

## Red Flags — señales de Measure mal ejecutado

- **Sin MSA** — datos sin validación del sistema de medición son potencialmente inútiles
- **Datos históricos sin MSA retrospectivo** — datos de sistemas ya existentes no garantizan que el sistema mida bien; documentar la fuente y sus limitaciones si no se puede hacer MSA
- **Kappa < 0.7 ignorado** — si los evaluadores no concuerdan, los datos de atributo son ruido disfrazado de información
- **Muestra no representativa** — datos de un solo turno, un solo día, condiciones atípicas
- **Datos de resultado, no de proceso** — medir solo si el cliente se queja, no el proceso que genera el problema
- **Convertir datos continuos a binario innecesariamente** — se pierde sensibilidad para detectar mejoras
- **Baseline sin período definido** — *"tomamos datos de hace un tiempo"* no es un baseline confiable
- **Ignorar estratificación** — si no se desagrega por turno/máquina/operador, Analyze no podrá identificar fuentes de variación

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: dmaic:measure
flow: dmaic
```

**Al COMPLETAR** (baseline establecido, MSA validado):
```yaml
methodology_step: dmaic:measure  # completado → listo para dmaic:analyze
flow: dmaic
```

## Siguiente paso

Cuando el baseline está establecido y el MSA validado → `dmaic:analyze`

---

## Limitaciones

- Este skill guía el proceso de medición; las herramientas estadísticas específicas (Minitab, R, Python statsmodels) están fuera de scope
- Para procesos con alta complejidad estadística (múltiples correlaciones, no-normalidad severa), considerar la ayuda de un Black Belt o estadístico
- El cálculo de Sigma Level asume la convención Six Sigma estándar (shift de 1.5σ de largo plazo) — documentar explícitamente si se usa otra convención

---

## Reference Files

### Assets
- [dmaic-measure-template.md](./assets/dmaic-measure-template.md) — Template del artefacto Measure: VSM, Plan de medición, Gauge R&R, baseline DPU/DPMO/Sigma, Cp/Cpk

### References
- [msa-gage-rr.md](./references/msa-gage-rr.md) — Gauge R&R completo: componentes, tabla de decisión (%GR&R), Kappa de Cohen, diseño de estudio, sistemas automatizados
- [process-capability.md](./references/process-capability.md) — Cp/Cpk/Pp/Ppk: fórmulas, interpretación, tabla DPMO→Sigma Level, convención 1.5σ, prerequisitos

### Scripts
- [calculate-capability.py](./scripts/calculate-capability.py) — Calcula Cp/Cpk/Pp/Ppk desde CSV con límites de especificación

```bash
# Uso básico — primera columna numérica, con límites de especificación
python .claude/skills/dmaic-measure/scripts/calculate-capability.py measurements.csv --lsl 9.5 --usl 10.5

# Especificando columna
python .claude/skills/dmaic-measure/scripts/calculate-capability.py data.csv diameter --lsl 49.8 --usl 50.2

# Sin límites — muestra solo media y desviación estándar
python .claude/skills/dmaic-measure/scripts/calculate-capability.py data.csv
```
